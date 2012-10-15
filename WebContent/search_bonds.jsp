<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="common_styles.css" rel="stylesheet" type="text/css">
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
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
	<%@ include file="customer_name_balance_header.jsp"%>
	<%
		if (request.getParameter("invalid") != null) {
	%>
	<div align="center" class="ex" id="errorMessage">
		<table>
			<tr>
				<td><img src="images/Error.png" /></td>
				<td><span style="font-family: Lucida Sans; font-weight: bold;">
						<%
							// Redirect to index Page if the customer id is not set.

								if (request.getParameter("invalid").equals("1")) {
									out.println("Cannot process order since the requested quantity of bond is not available.");
								}
								if (request.getParameter("invalid").equals("2")) {
									out.println("Cannot process order since the customer does not have enough balance.");
								}
						%>
				</span></td>
			</tr>
		</table>
	</div>

	<%
		}
	%>

	<form
		action='buy.jsp?customerId=<%=request.getQueryString().substring(
					request.getQueryString().indexOf("customerId=") + 11)%>'
		method='POST' name='searchForm'>
		<table cellpadding='10' id='newspaper-b'>
			<tr>
				<th><b>Name</b></th>
				<td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
					type='text' name='bond_name' title="Enter the Name of Bond here."></td>
			</tr>
			<tr>
				<th><b>Issuer</b></th>
				<td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
					type='text' name='bond_issuer' title="Enter the Issuer Name here."></td>
			</tr>
			<tr>
				<th><b>Rating</b></th>
				<td>Low:&nbsp;<input type='text' name='rating_low'
					title="Enter Minimum Rating here. E.g. (D/BB)"></td>
				<td>High:&nbsp;<input type='text' name='rating_high'
					title="Enter Maximum Rating here. E.g. (AAA/Aaa)"></td>
			</tr>
			<tr>
				<th><b>Coupon Rate (%)</b></th>
				<td>Low:&nbsp;<input type='text' name='coupon_rate_low'
					title="Enter Minimum Coupon Rate. E.g. (3.5)"></td>
				<td>High:&nbsp;<input type='text' name='coupon_rate_high'
					title="Enter Maximum Coupon Rate. E.g. (10.2)"></td>
			</tr>
			<tr>
				<th><b>Current Yield (%)</b></th>
				<td>Low:&nbsp;<input type='text' name='current_yield_low'
					title="Enter Minimum Current Yeild here. E.g. (3.5)"></td>
				<td>High:&nbsp;<input type='text' name='current_yield_high'
					title="Enter Maximum Current Yeild here. E.g. (10.2)"></td>
			</tr>
			<tr>
				<th><b>Yield to Maturity (%)</b></th>
				<td>Low:&nbsp;<input type='text' name='yield2maturity_low'
					title="Enter Minimum Yeild to Maturity here. E.g. (3.5)"></td>
				<td>High:&nbsp;<input type='text' name='yield2maturity_high'
					title="Enter Maximum Yeild to Maturity here. E.g. (10.2)"></td>
			</tr>
			<tr>
				<th><b>Maturity Date</b></th>
				<td>Low:&nbsp;<input type='text' name='maturity_date_low'
					title="Enter Minimum Maturity Date here. E.g. (YYYY-MM-DD)"></td>
				<td>High:&nbsp;<input type='text' name='maturity_date_high'
					title="Enter Maximum Maturity Date here. E.g. (YYYY-MM-DD)"></td>
			</tr>
			<tr>
				<th><b>Par Value ($)</b></th>
				<td>Low:&nbsp;<input type='text' name='par_value_low'
					title="Enter Minimum Par Value here. E.g. (50)"></td>
				<td>High:&nbsp;<input type='text' name='par_value_high'
					title="Enter Maximum Par Value here. E.g. (500)"></td>
			</tr>
			<tr>
				<th><b>Price ($)</b></th>
				<td>Low:&nbsp;<input type='text' name='price_low'
					title="Enter Minimum Price here. E.g. (300)"></td>
				<td>High:&nbsp;<input type='text' name='price_high'
					title="Enter Maximum Price here. E.g. (900)"></td>
			</tr>
			<tfoot>
				<tr>
					<td colspan=3><em>Enter the Search Criteria to search the market for Bonds.
						Move your mouse over the fields for additional help. If search is
						initiated without any criteria, all available bonds will be
						displayed.</em></td>
				</tr>
			</tfoot>
		</table>
		<input type='hidden' name='searched' value='1' /> <input
			type='submit' value='Search' />
	</form>

</body>
</html>