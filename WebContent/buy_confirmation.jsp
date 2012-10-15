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
<script language="javascript" type="text/javascript">
	history.forward();
</script>
<title>Bond Buy Confirmation</title>
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
		if (request.getParameter("status") != null) {
			if (request.getParameter("status").equals("1")) {
				if (request.getParameter("date") != null) {
					ResultSet rs = new BondModule()
							.getTransactionDataFromDate(request
									.getParameter("date"));
					rs.last();
					int resultSize = rs.getRow();
					rs.first();
					int i = 0;
	%>
	<table id="newspaper-b">
		<%
			while (i < resultSize) {
		%>
		<tr>
			<td>CUSIP</td>
			<td>
				<%
					out.println(rs.getString("cusip"));
				%>
			</td>
		</tr>
		<tr>
			<td>Rating (SnP)</td>
			<td>
				<%
					out.println(SearchCriteria.getSnpRating(rs
											.getString("rating_snp")));
				%>
			</td>
		</tr>
		<tr>
			<td>Rating (Moody's)</td>
			<td>
				<%
					out.println(SearchCriteria.getMoodysRating(rs
											.getString("rating_moody")));
				%>
			</td>
		</tr>
		<tr>
			<td>Price ($)</td>
			<td>
				<%
					out.println(rs.getDouble("price"));
				%>
			</td>
		</tr>
		<tr>
			<td>Quantity</td>
			<td>
				<%
					out.println(rs.getInt("quantity"));
				%>
			</td>
		</tr>
		<tr>
			<td>Transaction Date</td>
			<td>
				<%
					out.println(rs.getString("date"));
				%>
			</td>
		</tr>
		<tr>
			<td>Trader</td>
			<td>
				<%
					out.println(rs.getString("tusername"));
				%>
			</td>
		</tr>
		<tr>
			<td>Customer Name</td>
			<td>
				<%
					out.println(rs.getString("cname"));
				%>
			</td>
		</tr>
		<tr>
			<td>Customer Balance ($)</td>
			<td>
				<%
					out.println(rs.getDouble("balance"));
				%>
			</td>
		</tr>
		<tfoot><tr><td colspan=2>
			<em><b>The above transaction has been successfully initiated. You
					will receive a confirmation upon successful clearance. If you wish
					to cancel this transaction, please press </b></em>
			<a name="cancelBtn" href="buy_cancel.jsp?customerId=<%= request.getParameter("customerId") %>&transId=<%= rs.getInt("transaction_id") %>">Cancel</a>
			</td></tr>
		</tfoot>
	</table>
	<%
		i++;
					}
				}

			}
			if (request.getParameter("status").equals("0")) {
				out.println("Oops! Something went wrong. Transaction has been aborted. Please use the Portfolio Management button to start again.");
			}
		}
	%>
</body>
</html>