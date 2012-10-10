<%@ include file="common.jsp" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JSP+SQL</title>
</head>
<body>

<%
///*	try {
/*	ConnectionEngine engine=new ConnectionEngine();
	engine.connect();
	engine.update("insert into test values(42)");
	ResultSet resultSet = engine.query("select * from test");
	while (resultSet.next()) {
		out.println(resultSet.getInt(1) +  "<br>");
	}
	engine.close();
}catch (Exception e) {
  // other unexpected exception, print error message to the console
  out.println(e.toString());
}*/
%>
</body>
</html>