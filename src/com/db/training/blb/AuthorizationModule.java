package com.db.training.blb;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.db.training.blb.dao.ConnectionEngine;
import com.db.training.blb.dao.QueryEngine;

public class AuthorizationModule {
	
	public static boolean checkCookie(HttpServletRequest request) throws ClassNotFoundException, SQLException{
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
		return (new QueryEngine(new ConnectionEngine()).getUserForSessionId(sessionId))!=null;
	}
	
	public static boolean checkCredentials(HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, SQLException{
		QueryEngine queryEngine=new QueryEngine(new ConnectionEngine());
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		if(queryEngine.checkUserCredentials(username, password)){
			response.setHeader("Set-Cookie", "SESSION="+queryEngine.createSession(username)+"; Path=/");
		}else{
			return false;
		}
		return true;
	}

}
