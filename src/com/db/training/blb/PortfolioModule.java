package com.db.training.blb;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;
import com.mysql.jdbc.PreparedStatement;

public class PortfolioModule {
	
	public static boolean isTrader(HttpServletRequest request) throws SQLException, ClassNotFoundException{
		Cookie[] cs=request.getCookies();
		if(cs==null){
			return false;
		}
	    List<Cookie> cookies=Arrays.asList(cs);
	    String sessionId="";
	    for(Cookie cookie: cookies){
	    	if(cookie.getName().equalsIgnoreCase("SESSION")){
	    		sessionId=cookie.getValue().trim();
	    	}
	    }
	    QueryEngine queryEngine=new QueryEngine(new ConnectionEngine());
	    ResultSet resultSet=queryEngine.query("select t.id from traders t inner join login_session l on t.username=l.username where l.session_id=?",sessionId);
		return resultSet.next();
	}
	
	public static ResultSet getCustomers(HttpServletRequest request) throws ClassNotFoundException, SQLException{
		Cookie[] cs=request.getCookies();
		if(cs==null){
			return null;
		}
	    List<Cookie> cookies=Arrays.asList(cs);
	    String sessionId="";
	    for(Cookie cookie: cookies){
	    	if(cookie.getName().equalsIgnoreCase("SESSION")){
	    		sessionId=cookie.getValue().trim();
	    	}
	    }
	    QueryEngine queryEngine=new QueryEngine(new ConnectionEngine());
	    ResultSet resultSet=queryEngine.query(
	    		"select c.id as 'Id', c.full_name as 'Name', c.balance as 'Balance ($)', c.address as 'Address', c.phone as 'Phone', (select username from traders t1 where t1.id=c.trader_id) as 'Trader' from customers c inner join (select distinct participant_id from groups gg inner join (select g.id  from groups g inner join (select id from traders t inner join login_session l on t.username=l.username where l.session_id=?) t where g.participant_id=t.id and g.group_type<1) gid on gid.id=gg.id) trds on c.trader_id=trds.participant_id",sessionId
	    		);
		return resultSet;
	}
	
	public static ResultSet getPortfolio(HttpServletRequest request) throws SQLException, ClassNotFoundException{
		Cookie[] cs=request.getCookies();
		if(cs==null){
			return null;
		}
	    List<Cookie> cookies=Arrays.asList(cs);
	    String sessionId="";
	    String customerId=request.getParameter("customerId");
	    for(Cookie cookie: cookies){
	    	if(cookie.getName().equalsIgnoreCase("SESSION")){
	    		sessionId=cookie.getValue().trim();
	    	}
	    }
	    QueryEngine queryEngine=new QueryEngine(new ConnectionEngine());
	    ResultSet resultSet;
	    if(customerId==null || customerId.equalsIgnoreCase("")){
	    	resultSet=queryEngine.getBondsForGivenSessionId(sessionId);
	    }else{
	    	resultSet=queryEngine.getBondsForGivenCustomerId(customerId,sessionId);
	    }
		return resultSet;
	}

}
