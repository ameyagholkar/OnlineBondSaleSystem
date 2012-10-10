<%@page import="com.db.training.blb.AuthorizationModule"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"  %>
    <% 
    if(AuthorizationModule.checkCookie(request)||AuthorizationModule.checkCredentials(request,response)){
    	out.write("SUCCESS");
    	response.sendRedirect("index.jsp");
    	return;
    }else{
    	if(request.getMethod().equalsIgnoreCase("POST")){
    		response.sendRedirect("login.jsp?invalid");
    		return;
    	}
    }
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Wholesaler</title>
</head>
<body>
	<form action="login.jsp" method=post>
		Please, enter your user name and password:<br>
		<%
			if(request.getQueryString()!=null?request.getQueryString().equalsIgnoreCase("invalid"):false){
				out.write("<span style='color: #cc0000'>Invalid credentials!</span><br>");
			}
		%>
		<input type="text" name="username" style="width: 217px; "><br>
		<input type="password" name="password" style="width: 218px; ">
		<input type="submit" value="Sign In" style="width: 118px; height: 28px">
	</form>
</body>
</html>