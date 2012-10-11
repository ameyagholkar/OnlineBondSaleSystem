
<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@page import="com.db.training.blb.BondModule"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Buy Bonds</title>
</head>
<body>
	<%
		//Redirect to index Page if the customer id is not set
		if (request.getParameter("customerId") == null) {
			response.sendRedirect("index.jsp");
		}
	%>
	<%@ include file="header.jsp"%>
	<h1>Bonds Available</h1>
	<%
		// DEBUG -- out.println(request.getParameter("coupon_rate_low"));
		//DEBUG -- out.println(request.getParameter("coupon_rate_high"));

		String couponRateLow;
		String couponRateHigh;
		if (request.getParameter("coupon_rate_low") == null) {
			couponRateLow = "0";
		}else{
			couponRateLow = request.getParameter("coupon_rate_low");
		}
		
		if (request.getParameter("coupon_rate_high") == null) {
			couponRateHigh = "100";
		}else{
			couponRateHigh = request.getParameter("coupon_rate_high");;
		}

		try {
			ResultSet resultSet = new BondModule().getListOfBonds(
					couponRateLow, couponRateHigh);

			if (resultSet == null) {
				out.println("<h1>No Bonds found!</h1>");
				// RETURN to the Previous Page
			} else {
				resultSet.last();
				int resultSize = resultSet.getRow();
				resultSet.first();
				// -- DEBUG out.println(resultSize);
				int i = 0;
				out.println("<form action='buy_action.jsp?customerId="
						+ request.getParameter("customerId")
						+ "' method='POST'>");
				out.println("<table border='1'>");
				out.println("<tr><th></th><th>CUSIP</th><th>Bond Name</th><th>Bond Issuer</th><th>Rating</th><th>Coupon Rate</th><th>Current Yield (%)</th><th>Maturity Yield (%)</th><th>Maturity Date</th><th>Par Value</th><th>Price ($)</th><th>Quantity Available</th></tr>");
				while (i < resultSize) {
					out.println("<tr>");
					out.println("<td><input type='radio' name='cusip' value='"
							+ resultSet.getString("cusip") + "'></td><td>");
					out.println(resultSet.getString("cusip") + "</td><td>"
							+ resultSet.getString("bond_name")
							+ "</td><td>"
							+ resultSet.getString("issuer_name")
							+ "</td><td>" + resultSet.getString("rating")
							+ "</td><td>"
							+ resultSet.getString("coupon_rate")
							+ "</td><td>"
							+ resultSet.getString("current_yield")
							+ "</td><td>"
							+ resultSet.getString("maturity_yield")
							+ "</td><td>"
							+ resultSet.getString("maturity_date")
							+ "</td><td>"
							+ resultSet.getString("par_value")
							+ "</td><td>" + resultSet.getString("price")
							+ "</td><td>"
							+ resultSet.getString("quantity_owned"));
					out.println("</tr>");
					resultSet.next();
					i++;
				}
				out.println("</table>");

				out.println("<input type='hidden' name = 'criteria1' value = '"+ couponRateLow + "'>");
				out.println("<input type='hidden' name = 'criteria2' value = '"+ couponRateHigh + "'>");
				out.println("<input type='submit' value='Buy' /> </form>");
			}
		} catch (Exception e) {
			// other unexpected exception, print error message to the console
			out.println(e.toString());
		}
		out.println("<a href='search_bonds.jsp?customerId="+request.getParameter("customerId")+"'>Return to Search Page</a>");
		

	%>
</body>
</html>