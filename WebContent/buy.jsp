
<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Buy Bonds</title>
</head>
<body>
	<h1>Bond Display and Buy Page</h1>
	<%
		try {
			ResultSet resultSet = new QueryEngine(new ConnectionEngine())
					.getListOfBonds();
			if (resultSet == null) {
				out.println("<h1>No Bonds found!</h1>");
			}

			resultSet.last();
			int resultSize = resultSet.getRow();
			resultSet.first();
			// -- DEBUG ONLY out.println(resultSize);
			int i = 0;
			out.println("<table border='1'>");
			out.println("<tr><th></th><th>CUSIP</th><th>Rating</th><th>Coupon Rate</th><th>Current Yield (%)</th><th>Maturity Yield (%)</th><th>Maturity Date</th><th>Par Value</th><th>Price ($)</th><th>Quantity Available</th></tr>");
			while (i < resultSize) {
				out.println("<tr><td>");
				out.println("<input type='radio' name='"+ resultSet.getString("cusip")  +"' value='"+ resultSet.getString("cusip")  +"'></td><td>");
				out.println(resultSet.getString("cusip") + "</td><td>"
						+ resultSet.getString("rating") + "</td><td>"
						+ resultSet.getString("coupon_rate") + "</td><td>"
						+ resultSet.getString("current_yield")
						+ "</td><td>"
						+ resultSet.getString("maturity_yield")
						+ "</td><td>"
						+ resultSet.getString("maturity_date")
						+ "</td><td>" + resultSet.getString("par_value")
						+ "</td><td>" + resultSet.getString("price")
						+ "</td><td>"
						+ resultSet.getString("quantity_owned"));
				out.println("</tr>");
				i++;
			}
			out.println("</table>");
		} catch (Exception e) {
			// other unexpected exception, print error message to the console
			out.println(e.toString());
		}
	%>
</body>
</html>