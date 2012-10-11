<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Bonds</title>
<script type="text/javascript">
	function validateForm()
	{
	var x=document.forms["searchForm"]["coupon_rate_low"].value;
	var y=document.forms["searchForm"]["coupon_rate_high"].value;
	if (x==null || x=="" || y==null || y=="")
	  {
	  alert("Coupon Rate limits cannot be blank!");
	  return false;
	  }
	}
</script>
</head>
<body>
<%@ include file="header.jsp" %>
	<%
		out.println("<form action='buy.jsp' method='POST' name='searchForm' onsubmit=' return validateForm()'>");
		out.println("<table cellpadding='10'>");
		out.println("<tr><td><b>Coupon Rate</b></td><td>Low:&nbsp;<input type='text' name='coupon_rate_low' ></td><td>High:&nbsp;<input type='text' name='coupon_rate_high' ></td>");
		// -- To add more criteria
		out.println("</table>");
		out.println("<input type='hidden' name='searched' value='1' /> ");
		out.println("<input type='submit' value='Search' /> </form>");
		out.println("</form>");
		
	%>
</body>
</html>