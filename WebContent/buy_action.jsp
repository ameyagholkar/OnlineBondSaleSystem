<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
	function calculation(price) {
		var quantity = document.getElementById("quantity").value;
		var amount = quantity * price;
		document.getElementById("amount").innerHTML = amount;

	}
</script>

<script type="text/javascript">
	function submitType(submitType, customerId) {
		if (submitType == 0)
			document.userForm.action = "process_buy.jsp?customerId=" + customerId;
		else
			{
			
			document.userForm.action = "buy.jsp?customerId=" + customerId;
			}
	}
</script>
<% 
// Redirect to index Page if the customer id is not set.
if(request.getParameter("customerId")==null){
	response.sendRedirect("index.jsp");
}
%>
<title>Buy Bonds</title>
</head>
<body>
	<h1>Buy Local Bonds: Purchase Order</h1>

	<%
		try {
			String cusip = request.getParameter("cusip");
			double criteria1 = Double.parseDouble(request
					.getParameter("criteria1"));
			double criteria2 = Double.parseDouble(request
					.getParameter("criteria2"));
			//	out.println(cusip);

			ResultSet resultSet = new QueryEngine(new ConnectionEngine())
					.getBondData(cusip);
			if (resultSet == null) {
				out.println("<h1>No Bonds found!</h1>");
			}

			double price = Double.parseDouble(resultSet.getString("price"));
			//out.println("price = "+price);

			out.println("<table border='1'>");
			out.println("<tr><th>CUSIP</th><th>Bond Name</th><th>Issuer Name</th><th>Rating</th><th>Current Yield (%)</th><th>Yield to Maturity (%)</th><th>Coupon</th><th>Maturity Date</th><th>Price ($)</th></tr>");
			out.println("<tr><td>" + cusip + "</td> <td>"
					+ resultSet.getString("bond_name") + "</td><td>"
					+ resultSet.getString("issuer_name") + "</td><td>"
					+ resultSet.getString("rating") + "</td><td>"
					+ resultSet.getString("current_yield") + "</td><td>"
					+ resultSet.getString("maturity_yield") + "</td><td>"
					+ resultSet.getString("coupon_rate") + "</td><td>"
					+ resultSet.getString("maturity_date") + "</td><td>"
					+ price);
			out.println("</tr>");
			out.println("</table>");

			out.println("<p></p>");

			//out.println("<table border='1'>");
			//out.println("<tr><th>Quantity Available</th><td>"+ resultSet.getString("quantity_owned")+"</td></tr>");
			//out.println("<tr><th name='quantity'>Please enter quantity to buy</th><td><input type = 'int' name = 'quantity'></td></tr>");

			int quantity;
			double amount = 0.0;

			out.println("<p>Quantity Available  "
					+ resultSet.getString("quantity_owned") + "</p>");
			out.print("Please enter quantity to buy <input type='text' id='quantity'>");
			out.println("<button value= 'Calculate' onclick='calculation("
					+ price + ")'>Calculate</button>");

			out.println("<form name ='userForm' method = 'POST'>");

			out.println("<table><tr><td>Total purchase amount ($)</td><td id='amount'></td></tr></table>");
			out.println("<input type='submit' value= 'Buy' onClick = 'submitType(0, "+request.getParameter("customerId")+")'>");

			out.println("<input type='hidden' name = 'coupon_rate_low' value = '"
					+ criteria1 + "'>");
			out.println("<input type='hidden' name = 'coupon_rate_high' value = '"
					+ criteria2 + "'>");
			out.println("<input type='submit' value= 'Return to Buy List' onClick = 'submitType(1,"+request.getParameter("customerId")+")'>");
			//out.println("<br><br><a href='buy.jsp'>Return to Buy Page</a>");

			out.println("</form>");

		} catch (Exception e) {
			// other unexpected exception, print error message to the console
			out.println(e.toString());
		}
	%>

</body>
</html>