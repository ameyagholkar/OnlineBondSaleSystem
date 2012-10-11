<%@page import="com.db.training.blb.AuthorizationModule"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%
	if (AuthorizationModule.checkCookie(request)
			|| AuthorizationModule.checkCredentials(request, response)) {
		out.write("SUCCESS");
		response.sendRedirect("index.jsp");
		return;
	} else {
		if (request.getMethod().equalsIgnoreCase("POST")) {
			response.sendRedirect("login.jsp?invalid");
			return;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <link rel="stylesheet" type="text/css" href="common_styles.css" /> 
<%@ include file="favicon.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Wholesaler</title>
<script type="text/javascript">
	function validateForm() {
		var x = document.forms["loginForm"]["username"].value;
		var y = document.forms["loginForm"]["password"].value;
		if (x == null || x == "") {
			alert("Username cannot be blank!");
			return false;
		}

		if (y == null || y == "") {
			alert("Password cannot be blank!");
			return false;
		}
	}
</script>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div class="loginBlock">
		<form action="login.jsp" method=post name="loginForm"
			onsubmit=' return validateForm()'>
			Sign in
			<hr>
			<br> Username<br>
			<input type="text" name="username" style="width: 217px;"><br>
			Password<br>
			<input type="password" name="password" style="width: 218px;">
			<br>
			<%
				if (request.getQueryString() != null ? request.getQueryString()
						.equalsIgnoreCase("invalid") : false) {
					out.write("<span style='color: #cc0000'>Invalid Username or Password</span><br>");
				}
			%><input type="submit" value="Sign In"
				style="width: 118px; height: 28px">
		</form>
	</div>
</body>
</html>