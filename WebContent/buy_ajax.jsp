<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@page import="com.db.training.blb.BondModule"%>
<%@ page import="java.util.*"  %>
<%@ page import="java.sql.*"  %>
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
	// DEBUG -- out.println(request.getParameter("coupon_rate_low"));
	//DEBUG -- out.println(request.getParameter("coupon_rate_high"));

	SearchCriteria criteria = new SearchCriteria();
	criteria.name = request.getParameter("bond_name");
	criteria.issuer = request.getParameter("bond_issuer");
	criteria.couponRateLow = request.getParameter("coupon_rate_low");
	criteria.couponRateHigh = request.getParameter("coupon_rate_high");
	criteria.ratingLow = request.getParameter("rating_low");
	criteria.ratingHigh = request.getParameter("rating_high");
	criteria.currentYieldLow = request
			.getParameter("current_yield_low");
	criteria.currentYieldHigh = request
			.getParameter("current_yield_high");
	criteria.yield2MaturityLow = request
			.getParameter("yield2maturity_low");
	criteria.yield2MaturityHigh = request
			.getParameter("yield2maturity_high");
	criteria.maturityDateLow = request
			.getParameter("maturity_date_low");
	criteria.maturityDateHigh = request
			.getParameter("maturity_date_high");
	criteria.parValueLow = request.getParameter("par_value_low");
	criteria.parValueHigh = request.getParameter("par_value_high");
	criteria.priceLow = request.getParameter("price_low");
	criteria.priceHigh = request.getParameter("price_high");
	criteria.checkCriteria();

	try {
		ResultSet resultSet = new BondModule().getListOfBonds(criteria);

		if (resultSet == null) {
			out.println("<h1>No Bonds found!</h1>");
			// RETURN to the Previous Page
		} else {
			out.println("<h1>Bonds Available</h1>");
			resultSet.last();
			int resultSize = resultSet.getRow();
			resultSet.first();
			// -- DEBUG out.println(resultSize);
			int i = 0;
			out.println("<form action='buy_action.jsp?customerId="
					+ request.getParameter("customerId")
					+ "' method='POST'>");
			out.println("<table border='1' id='newspaper-b' style='margin-left: 5px; width: 500px;'>");
			out.println("<thead><tr><th></th><th>CUSIP</th><th>Bond Name</th><th>Bond Issuer</th><th>Rating</th><th>Coupon Rate</th><th>Current Yield (%)</th><th>Maturity Yield (%)</th><th>Maturity Date</th><th>Par Value</th><th>Price ($)</th><th>Quantity Available</th></tr></thead>");
			while (i < resultSize) {
				out.println("<tr>");
				out.println("<td><input type='radio' name='cusip' value='"
						+ resultSet.getString("cusip") + "'></td><td>");
				out.println(resultSet.getString("cusip")
						+ "</td><td>"
						+ resultSet.getString("bond_name")
						+ "</td><td>"
						+ resultSet.getString("issuer_name")
						+ "</td><td>"
						+ SearchCriteria.getSnpRating(resultSet
								.getString("rating_snp"))
						+ "/"
						+ SearchCriteria.getMoodysRating(resultSet
								.getString("rating_moody"))
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

			out.println("<tr><td colspan=12 align='center'><input type='submit'  style='margin-left: 45px; font-size: 25px; width: 200px;' value='Buy' /> </td></tr>");

			out.println("</table>");
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
					+ request.getParameter("yield2maturity_high")
					+ "'>");
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
			out.println("</form>");
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	out.println("");
%>