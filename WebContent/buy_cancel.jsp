<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="common.jsp"%>
<%@ page import="com.db.training.blb.BondModule"%>
<%@ page import="com.db.training.blb.SearchCriteria"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bond Buy Cancellation</title>
</head>
<body>
	<%@ include file="header.jsp"%>

	<div id='cssmenu'>
		<ul>
			<li><a href='index.jsp'><span>Home/Portfolio
						Management</span></a></li>
			<%
				if (request.getParameter("customerId") != null
						&& (!request.getParameter("customerId")
								.equalsIgnoreCase(""))) {
			%>
			<li class='active '><a
				href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%
		//Redirect to index Page if the customer id is not set
		if (request.getParameter("customerId") == null || "".equalsIgnoreCase(request.getParameter("customerId"))) {
			response.sendRedirect("index.jsp");
			return;
		}
		try{
			int id=Integer.parseInt(request.getParameter("customerId"));
			if(id<=0){
				response.sendRedirect("index.jsp");
				return;
			}
		}catch(Exception e){
			response.sendRedirect("index.jsp");
			return;
		}
		String customerId = request.getParameter("customerId");
		String transactionId = request.getParameter("transId");

		BondModule b = new BondModule();
		if (b.cancelTransaction(customerId, transactionId)) {
			response.sendRedirect("index.jsp?cancel=1&customerId="+customerId);
			return;
		}else {
			out.println("Oops! Something has gone wrong! We are working on it!");
		}
		
		
	%>
</body>
</html>