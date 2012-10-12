<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
	function calculation(price) {
		var quantity = document.getElementById("quantity").value;
		var amount = quantity * price;
		document.getElementById("amount").innerHTML = amount;
		//document.getElementById("total").value = amount;
	}

	function submitType(submitType, customerId) {
		if (submitType == 0)
			document.userForm.action = "process_buy.jsp?customerId=" + customerId + "&quantity=" + document.getElementById("quantity").value;
		else
			{
			
			document.userForm.action = "buy.jsp?customerId=" + customerId;
			}
	}
	
	function returnTotal() {
		var amount = document.getElementById("amount").value;
		//return amount;
		document.getElementById("total").innerHTML = amount;
	}
</script>
<% 
// Redirect to index Page if the customer id is not set.
if(request.getParameter("customerId")==null){
	response.sendRedirect("index.jsp");
	return;
}
%>
<title>Buy Bonds</title>
</head>
<body>
	<%@ include file="header.jsp" %>
	<div id='cssmenu'>
		<ul>
			<li><a href='index.jsp'><span>Home/Portfolio Management</span></a></li>
			<%
				if (request.getParameter("customerId") != null && (!request.getParameter("customerId").equalsIgnoreCase(""))) {
					%>
					<li class='active '><a
						href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>
					<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<h1>Buy Local Bonds: Purchase Order</h1>

	<%
		try {
			String cusip = request.getParameter("cusip");

			ResultSet resultSet = new QueryEngine(new ConnectionEngine()).getBondData(cusip);
			if (resultSet == null) {
				out.println("<h1>No Bonds found!</h1>");
			}

			double price = Double.parseDouble(resultSet.getString("price"));
			//out.println("price = "+price);

			out.println("<table border='1' id='newspaper-b'>");
			out.println("<tr><thead><th>CUSIP</th><th>Bond Name</th><th>Issuer Name</th><th>Rating</th><th>Current Yield (%)</th><th>Yield to Maturity (%)</th><th>Coupon</th><th>Maturity Date</th><th>Price ($)</th></thead></tr>");
			out.println("<tr><td>" + cusip + "</td> <td>"
					+ resultSet.getString("bond_name") + "</td><td>"
					+ resultSet.getString("issuer_name") + "</td><td>"
					+ SearchCriteria.getSnpRating(resultSet.getString("rating_snp")) + "/" + SearchCriteria.getMoodysRating(resultSet.getString("rating_moody")) + "</td><td>"
					+ resultSet.getString("current_yield") + "</td><td>"
					+ resultSet.getString("maturity_yield") + "</td><td>"
					+ resultSet.getString("coupon_rate") + "</td><td>"
					+ resultSet.getString("maturity_date") + "</td><td>"
					+ price);
			out.println("</tr>");
			out.println("</table>");

			out.println("<br>");

			out.println("<p>Quantity Available  "+ resultSet.getString("quantity_owned") + "</p>");
			out.println("<button value= 'Calculate' onclick='calculation("+ price + ")'>Calculate</button>");

			out.println("<form name ='userForm' method = 'POST'>");
			out.print("Please enter quantity to buy <input type='text' name='quantity' id='quantity'>");

			out.println("<table><tr><td>Total purchase amount ($)</td><td id='amount'></td></tr></table>");
			out.println("<input type='hidden' name = 'cusip' value = '"+ cusip + "'>");
			//out.println("<input type='hidden' name = 'rating' value = '"+ resultSet.getString("rating_snp") + "'>");
			out.println("<input type='hidden' name = 'price' value = '"+ price + "'>");
			out.println("<input type='hidden' name = 'total_amount' id = 'total'>");
			
			out.println("<input type='submit' value= 'Buy' onClick = 'submitType(0, "+request.getParameter("customerId")+")'>");


			out.println("<input type='submit' value= 'Return to Buy List' onClick = 'submitType(1,"+request.getParameter("customerId")+")'>");
			//out.println("<br><br><a href='buy.jsp'>Return to Buy Page</a>");

			out.println("</form>");

		} catch (Exception e) {
			// other unexpected exception, print error message to the console
			e.printStackTrace();
		}
	%>

</body>
</html>