<%@page import="com.db.training.blb.AuthorizationModule"%>
<%@ page import="java.util.*"  %>
<%@ page import="java.sql.*"  %>
    <% 
    if(!(AuthorizationModule.checkCookie(request)|AuthorizationModule.checkCredentials(request,response))){
    	response.sendRedirect("login.jsp");
    	return;
    }
     %>         
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>