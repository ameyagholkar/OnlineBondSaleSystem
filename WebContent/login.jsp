<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Wholesaler</title>
</head>
<body>
	<form action="<% out.write(request.getHeader("Referer")); %>" method=post>
		Please, enter your user name and password:<br><input type="text" name="username" style="width: 217px; "><br>
		<input type="password" name="password" style="width: 218px; ">
		<input type="submit" value="Sign In" style="width: 118px; height: 28px">
	</form>
</body>
</html>