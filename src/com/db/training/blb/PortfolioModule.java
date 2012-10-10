package com.db.training.blb;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

public class PortfolioModule {
	
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
	    	resultSet=queryEngine.getBondsForGivenCustomerId(customerId);
	    }
		return resultSet;
	}

}
