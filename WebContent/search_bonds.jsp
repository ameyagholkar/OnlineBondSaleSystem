<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="common_styles.css" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Bonds</title>
<script type="text/javascript">
	function validateForm() {
		var x = document.forms["searchForm"]["coupon_rate_low"].value;
		var y = document.forms["searchForm"]["coupon_rate_high"].value;
		if (x == null || x == "" || y == null || y == "") {
			alert("Coupon Rate limits cannot be blank!");
			return false;
		}
	}
</script>
<style>
div.ex {
	width: 500px;
	padding: 10px;
	border: 1px solid gray;
	margin: 10px;
	background-color: #F81B23;
}
</style>
</head>
<body>
	<%
		// Redirect to index Page if the customer id is not set.
		if (request.getParameter("customerId") == null) {
			response.sendRedirect("index.jsp");
			return;
		}
	%>
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
	<%@ include file="customer_name_balance_header.jsp"  %>
	<%
		if (request.getParameter("invalid") != null) {
	%>
	<div align="center" class="ex" id="errorMessage">
		<table><tr><td><img src="images/Error.png" /></td>
		<td><span style="font-family:Lucida Sans;font-weight:bold;">
		<%
			// Redirect to index Page if the customer id is not set.

				if (request.getParameter("invalid").equals("1")) {
					out.println("Cannot process order since the requested quantity of bond is not available.");
				}
				if (request.getParameter("invalid").equals("2")) {
					out.println("Cannot process order since the customer does not have enough balance.");
				}
		%>
		</span></td></tr>
		</table>
	</div>

	<%
		}
	%>

	<form
		action='buy.jsp?customerId=<%=request.getQueryString().substring(
					request.getQueryString().indexOf("customerId=") + 11)%>'
		method='POST' name='searchForm'>
		<table cellpadding='10'>
			<tr>
				<td><b>Rating</b></td>
				<td>Low:&nbsp;<input type='text' name='rating_low'></td>
				<td>High:&nbsp;<input type='text' name='rating_high'></td>
			</tr>
			<tr>
				<td><b>Coupon Rate (%)</b></td>
				<td>Low:&nbsp;<input type='text' name='coupon_rate_low'></td>
				<td>High:&nbsp;<input type='text' name='coupon_rate_high'></td>
			</tr>
			<tr>
				<td><b>Current Yield (%)</b></td>
				<td>Low:&nbsp;<input type='text' name='current_yield_low'></td>
				<td>High:&nbsp;<input type='text' name='current_yield_high'></td>
			</tr>
			<tr>
				<td><b>Yield to Maturity (%)</b></td>
				<td>Low:&nbsp;<input type='text' name='yield2maturity_low'></td>
				<td>High:&nbsp;<input type='text' name='yield2maturity_high'></td>
			</tr>
			<tr>
				<td><b>Maturity Date</b></td>
				<td>Low:&nbsp;<input type='text' name='maturity_date_low'></td>
				<td>High:&nbsp;<input type='text' name='maturity_date_high'></td>
			</tr>
			<tr>
				<td><b>Par Value ($)</b></td>
				<td>Low:&nbsp;<input type='text' name='par_value_low'></td>
				<td>High:&nbsp;<input type='text' name='par_value_high'></td>
			</tr>
			<tr>
				<td><b>Price ($)</b></td>
				<td>Low:&nbsp;<input type='text' name='price_low'></td>
				<td>High:&nbsp;<input type='text' name='price_high'></td>
			</tr>
		</table>
		<input type='hidden' name='searched' value='1' /> <input
			type='submit' value='Search' />
	</form>

</body>
</html>