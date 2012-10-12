<%@page import="com.db.training.blb.BondModule"%>
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
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bond Purchase Confirmation</title>
</head>
<body>
<%
	// Processing for finalizing the bond purchase
	// Redirect to index Page if the customer id is not set.		
	if (request.getParameter("customerId") == null) {
		response.sendRedirect("index.jsp");
		return;
	}
	//Get the required data from the previous page
	String cusip = request.getParameter("cusip");
	String numOfBonds = request.getParameter("quantity");
	String price=request.getParameter("price");
	if(numOfBonds==null||numOfBonds.equalsIgnoreCase("")){
		numOfBonds="0";
	}
	if(price==null||price.equalsIgnoreCase("")){
		price="0.0";
	}
	double totalPrice = Integer.parseInt(numOfBonds)*Double.parseDouble(price);
	
	//DEBUG --
	out.println(cusip + "  " + numOfBonds + "  " + totalPrice );

	//Get the Cookie for Trader ID
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
	String customerId = request.getParameter("customerId");
	//Check if Trader is authorized to make purchases
	if (new QueryEngine(new ConnectionEngine())
			.checkPortfolioManagementPermission(customerId, sessionId)) {
		out.println("Works!");		
		// customer ID, Trader ID, Number of Bonds, Price, cusip, group id = 0
		BondModule bondModule = new BondModule();
		//Call Process Order
		if(totalPrice>0.0){
			int status = bondModule.processBondOrder(cusip, numOfBonds, customerId, new Double(totalPrice).toString());
			if( status == 1){
				out.println("Done!");
				response.sendRedirect("buy_confirmation.jsp?status=1&customerId=" + customerId);
				return;
			}else if(status == 0){
				out.println("Exceptions!");
				response.sendRedirect("buy_confirmation.jsp?status=0&customerId=" + customerId);
				return;
			}else if(status == 2){
				response.sendRedirect("search_bonds.jsp?invalid=1&customerId=" + customerId);
				return;
			}else if(status == 3){
				response.sendRedirect("search_bonds.jsp?invalid=2&customerId=" + customerId);
				return;
			}
		}else{
			response.sendRedirect("search_bonds.jsp?invalid=1&customerId=" + customerId);
			return;
		}
	} else {
		// TODO - Consult Team for Action to be taken here.
	}
%>

</body>
</html>