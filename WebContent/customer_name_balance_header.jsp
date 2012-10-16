<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.PortfolioModule"%>
<%@page import="com.db.training.blb.dao.*"%>
<%@ include file="common.jsp"%>
<%@ page import="java.sql.*"%>

<%
	if (request.getParameter("customerId") != null
			&& (!request.getParameter("customerId")
					.equalsIgnoreCase(""))) {
		ResultSet rs = new QueryEngine(new ConnectionEngine()).query(
				"select full_name, balance from customers where id=?",
				request.getParameter("customerId"));
		if (rs.next()) {
			out.println(" <br><br><span id='customer' style='font-size: 12pt; color: #888888'><b>Customer Name: </b><em>"
					+ rs.getString(1));
			out.println("</em>&nbsp; &nbsp; &nbsp; <b>Available Balance: </b> <em> $"
					+ rs.getString(2) + "</em></span> <br> ");
		}
	}
	Cookie[] cs=request.getCookies();
	if(cs!=null){
	    List<Cookie> cookies=Arrays.asList(cs);
	    String sessionId="";
	    for(Cookie cookie: cookies){
	    	if(cookie.getName().equalsIgnoreCase("SESSION")){
	    		sessionId=cookie.getValue().trim();
	    	}
	    }
		String user=new QueryEngine(new ConnectionEngine()).getUserForSessionId(sessionId);
		ResultSet rs = new QueryEngine(new ConnectionEngine()).query(
				"select full_name, balance from customers where username=?",user);
		if (rs.next()) {
			out.println(" <br><br><span id='customer' style='font-size: 12pt; color: #888888'><b>Customer Name: </b><em>"
					+ rs.getString(1));
			out.println("</em>&nbsp; &nbsp; &nbsp; <b>Available Balance: </b> <em> $"
					+ rs.getString(2) + "</em></span> <br> ");
		}
	}

%>