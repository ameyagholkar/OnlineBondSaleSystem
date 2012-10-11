<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="common.jsp"%>
<%@ page import="com.db.training.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bond Purchase Confirmation</title>
<%
	// Processing for finalizing the bond purchase
	// Redirect to index Page if the customer id is not set.
	String cusip = "0088a4573";
	if (request.getParameter("customerId") == null) {
		response.sendRedirect("index.jsp");
	}
	Cookie[] cs = request.getCookies();
	if (cs == null) {
		response.sendRedirect("login.jsp");
	}
	List<Cookie> cookies = Arrays.asList(cs);
	String sessionId = "";
	for (Cookie cookie : cookies) {
		if (cookie.getName().equalsIgnoreCase("SESSION")) {
			sessionId = cookie.getValue().trim();
		}
	}
	String customerId = request
			.getParameter("customerId");
	if (new QueryEngine(new ConnectionEngine())
			.checkPortfolioManagementPermission(customerId,
					sessionId)){
		out.println("Works!");		
		// customer ID, Trader ID, Number of Bonds, Price, cusip, group id = 0
	}else{
		// TODO - Consult Team for Action to be taken here.
	}
%>
</head>
<body>

</body>
</html>