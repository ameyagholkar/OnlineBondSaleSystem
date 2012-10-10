<%@page import="com.db.training.blb.AuthorizationModule"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	AuthorizationModule.unauthorize(request, response);
	response.sendRedirect("login.jsp");
	return;
%>