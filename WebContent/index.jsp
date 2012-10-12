<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.PortfolioModule"%>
<%@ include file="common.jsp"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<title>Online Wholesaler</title>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div id='cssmenu'>
		<ul>
			<li class='active '><a href='index.jsp'><span>Home/Portfolio
						Management</span></a></li>
			<%
				if (request.getParameter("customerId") != null
						&& (!request.getParameter("customerId")
								.equalsIgnoreCase(""))) {
			%>
			<li><a
				href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%
		if (PortfolioModule.isTrader(request)
				&& (request.getParameter("customerId") == null || request
						.getParameter("customerId").equalsIgnoreCase(""))) {
			ResultSet rs = PortfolioModule.getCustomers(request);
			ResultSetMetaData metaData = rs.getMetaData();
			if (rs.next()) {
	%>
	<br>
	<table border=1 cellspacing=0 id="newspaper-b">
		<tr>
		<thead>
			<%
				for (int i = 2; i <= metaData.getColumnCount(); i++) {
							out.write("<th>" + metaData.getColumnLabel(i) + "</th>");
						}
			%>
		</thead>
		<tfoot>
			<tr>
				<td colspan="5"><em>Please choose a Customer by clicking on their name to continue.</em></td>
			</tr>
		</tfoot>
		<tbody>
			<%
				do {
							out.write("<tr>");
							for (int i = 2; i <= metaData.getColumnCount(); i++) {
								if (i != 2) {
									out.write("<td>" + rs.getString(i) + "</td>");
								} else {
									out.write("<td><a href=\"index.jsp?customerId="
											+ rs.getString(1) + "\">"
											+ rs.getString(i) + "</a></td>");
								}
							}
							out.write("<tr>");
						} while (rs.next());
			%>
		</tbody>
	</table>
	<%
		} else {
	%><span style="color: #bb0000">No customers available.</span>
	<%
		}
		} else {
			ResultSet rs = PortfolioModule.getPortfolio(request);
			ResultSetMetaData metaData = rs.getMetaData();
			if (rs.next()) {
	%>
	<br>
	<table border=1 cellpading=0 cellspacing=0 id="newspaper-b">
		<tr>
		<thead>
			<%
				for (int i = 1; i <= metaData.getColumnCount(); i++) {
							out.write("<th>" + metaData.getColumnLabel(i) + "</th>");
						}
			%>
		</thead>
		</tr>
		<tbody>
			<%
				do {
							out.write("<tr>");
							for (int i = 1; i <= metaData.getColumnCount(); i++) {
								if (metaData.getColumnLabel(i).equalsIgnoreCase(
										"Rating")) {
									String s = rs.getString(i);
									out.write("<td>"
											+ SearchCriteria.getSnpRating(s) + "/"
											+ SearchCriteria.getMoodysRating(s)
											+ "</td>");
								} else {
									out.write("<td>" + rs.getString(i) + "</td>");
								}
							}
							out.write("<tr>");
						} while (rs.next());
			%>
		</tbody>
	</table>
	<%
		} else {
	%><span style="color: #bb0000">No bonds in possession.</span>
	<%
		}
		}
	%>
</body>
</html>