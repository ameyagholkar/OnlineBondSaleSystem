<%@page import="com.db.training.blb.PortfolioModule"%>
<%@ include file="common.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>Online Wholesaler</title>
</head>
<body>
<%
	ResultSet rs=PortfolioModule.getPortfolio(request);
	ResultSetMetaData metaData=rs.getMetaData();
	//if(rs.n)
%>
</body>
</html>