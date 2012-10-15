<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.PortfolioModule"%>
<%@page import="com.db.training.blb.dao.*"%>
<%@ include file="common.jsp"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<title>Online Wholesaler</title>
<style>
div.message {
	width: 500px;
	padding: 10px;
	border: 1px solid gray;
	margin: 10px;
}
</style>
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
				<td colspan="5"><em>Please choose a Customer by clicking
						on their name to continue.</em></td>
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
			if (request.getParameter("cancel") != null
					&& request.getParameter("cancel").equals("1")) {
	%>
	<div align="center" class="message" id="message">
		<table>
			<tr>
				<td><img src="images/Done.jpg" /></td>
				<td><span style="font-family: Lucida Sans; font-weight: bold;">
						<%
							out.println("Order cancelled successfully.");
						%>
				</span></td>
			</tr>
		</table>
	</div>
	<%
		}

			if (request.getParameter("customerId") != null
					&& (!request.getParameter("customerId")
							.equalsIgnoreCase(""))) {
				ResultSet rs = new QueryEngine(new ConnectionEngine())
						.query("select full_name, balance from customers where id=?",
								request.getParameter("customerId"));
				if (rs.next()) {
					out.println("<span style='font-family: arial;  font-size: 12pt; color:#888888'>Customer Name: "
							+ rs.getString(1)
							+ "; Available Balance: "
							+ rs.getString(2) + "</span><br>");
				}
			}
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
							String s = metaData.getColumnLabel(i);
							if (s.startsWith("Rating")) {
								out.write("<th>Rating</th>");
								i++;
							} else {
								out.write("<th>" + s + "</th>");
							}
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
										"RatingSNP")) {
									String snp = rs.getString(i);
									String moody = rs.getString(i + 1);
									out.write("<td>"
											+ SearchCriteria.getSnpRating(snp)
											+ "/"
											+ SearchCriteria.getMoodysRating(moody)
											+ "</td>");
									i++;
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