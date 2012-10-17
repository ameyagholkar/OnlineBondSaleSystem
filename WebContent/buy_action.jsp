<%@page import="com.db.training.blb.SearchCriteria"%>
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
<script type="text/javascript">
	function calculation(price) {
		var quantity = document.getElementById("quantity").value;
		var amount = quantity * price;
		document.getElementById("amount").innerHTML = amount;
		//document.getElementById("total").value = amount;
	}

	function returnTotal() {
		var amount = document.getElementById("amount").value;
		//return amount;
		document.getElementById("total").innerHTML = amount;
	}
	

	function validate(){
		if(isNaN(document.getElementById("quantity").value) || (document.getElementById("quantity").value == "" ) ){
			alert("Please enter a number.");
			return false;
		}
		if(!isNaN(document.getElementById("quantity").value)){
			if(parseInt(document.getElementById("quantity").value) <= 0){
				alert("Please enter a number greater than 0.");
				return false;
			}
		}
	}

</script>
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
%>
<title>Buy Bonds</title>
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
			<li class='active'><a
				href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>

			<li><a
				href='sell.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Sell</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%@ include file="customer_name_balance_header.jsp"%>
	<h1>Buy Local Bonds: Purchase Order</h1>

	<%
		try {
			String cusip = request.getParameter("cusip");

			ResultSet resultSet = new QueryEngine(new ConnectionEngine())
					.getBondData(cusip);
			if (resultSet == null) {
				out.println("<h1>No Bonds found!</h1>");
			}

			double price = Double.parseDouble(resultSet.getString("price"));
			//out.println("price = "+price);

			out.println("<table border='1' id='newspaper-b'>");
			out.println("<tr><thead><th>CUSIP</th><th>Bond Name</th><th>Issuer Name</th><th>Rating</th><th>Current Yield (%)</th><th>Yield to Maturity (%)</th><th>Coupon</th><th>Maturity Date</th><th>Price ($)</th></thead></tr>");
			out.println("<tr><td>"
					+ cusip
					+ "</td> <td>"
					+ resultSet.getString("bond_name")
					+ "</td><td>"
					+ resultSet.getString("issuer_name")
					+ "</td><td>"
					+ SearchCriteria.getSnpRating(resultSet
							.getString("rating_snp"))
					+ "/"
					+ SearchCriteria.getMoodysRating(resultSet
							.getString("rating_moody")) + "</td><td>"
					+ resultSet.getString("current_yield") + "</td><td>"
					+ resultSet.getString("maturity_yield") + "</td><td>"
					+ resultSet.getString("coupon_rate") + "</td><td>"
					+ resultSet.getString("maturity_date") + "</td><td>"
					+ price);
			out.println("</tr>");
			out.println("</table>");

			out.println("<br>");

			out.println("<p>Quantity Available  "
					+ resultSet.getString("quantity_owned") + "</p>");
			out.println("<input type='Submit' value= 'Calculate Total Price' onclick='calculation("
					+ price + ")'/>");

			out.println("<form name ='userForm' method = 'POST' action='process_buy.jsp?customerId="
					+ request.getParameter("customerId") + "' onsubmit='return validate()'>");
			out.print("Please enter quantity to buy <input type='text' name='quantity' id='quantity'>");

			out.println("<table><tr><td>Total purchase amount ($)</td><td id='amount'></td></tr></table>");
			out.println("<input type='hidden' name = 'cusip' value = '"
					+ cusip + "'>");
			out.println("<input type='hidden' name = 'price' value = '"
					+ price + "'>");

			out.println("<input type='submit' style='margin-left: 45px; font-size: 15px; width: 200px;' value= 'Buy'>");
			out.println("</form>");

			out.println("<form name ='userForm' method = 'POST' action='buy.jsp?customerId="
					+ request.getParameter("customerId") + "'>");
			out.println("<input type='hidden' name = 'bond_name' value = '"
					+ request.getParameter("bond_name") + "'>");
			out.println("<input type='hidden' name = 'bond_issuer' value = '"
					+ request.getParameter("bond_issuer") + "'>");
			out.println("<input type='hidden' name = 'coupon_rate_low' value = '"
					+ request.getParameter("coupon_rate_low") + "'>");
			out.println("<input type='hidden' name = 'coupon_rate_high' value = '"
					+ request.getParameter("coupon_rate_high") + "'>");
			out.println("<input type='hidden' name = 'rating_low' value = '"
					+ request.getParameter("rating_low") + "'>");
			out.println("<input type='hidden' name = 'rating_high' value = '"
					+ request.getParameter("rating_high") + "'>");
			out.println("<input type='hidden' name = 'current_yield_low' value = '"
					+ request.getParameter("current_yield_low") + "'>");
			out.println("<input type='hidden' name = 'current_yield_high' value = '"
					+ request.getParameter("current_yield_high") + "'>");
			out.println("<input type='hidden' name = 'yield2maturity_low' value = '"
					+ request.getParameter("yield2maturity_low") + "'>");
			out.println("<input type='hidden' name = 'yield2maturity_high' value = '"
					+ request.getParameter("yield2maturity_high") + "'>");
			out.println("<input type='hidden' name = 'maturity_date_low' value = '"
					+ request.getParameter("maturity_date_low") + "'>");
			out.println("<input type='hidden' name = 'maturity_date_high' value = '"
					+ request.getParameter("maturity_date_high") + "'>");
			out.println("<input type='hidden' name = 'par_value_low' value = '"
					+ request.getParameter("par_value_low") + "'>");
			out.println("<input type='hidden' name = 'par_value_high' value = '"
					+ request.getParameter("par_value_high") + "'>");
			out.println("<input type='hidden' name = 'price_low' value = '"
					+ request.getParameter("price_low") + "'>");
			out.println("<input type='hidden' name = 'price_high' value = '"
					+ request.getParameter("price_high") + "'>");
			out.println("<input type='submit' style='margin-left: 45px; font-size: 15px; width: 200px;' value= 'Return to Buy List'>");
			//out.println("<br><br><a href='buy.jsp'>Return to Buy Page</a>");
			out.println("</form>");

		} catch (Exception e) {
			// other unexpected exception, print error message to the console
			e.printStackTrace();
		}
	%>

</body>
</html>