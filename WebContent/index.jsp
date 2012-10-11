<%@page import="com.db.training.blb.PortfolioModule"%>
<%@ include file="common.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<title>Online Wholesaler</title>
</head>
<body>
<div id='cssmenu'>
<ul>
   <li class='active '><a href='#'><span>Home</span></a></li>
   <li><a href='#'><span>Products</span></a></li>
   <li><a href='#'><span>Company</span></a></li>
   <li><a href='#'><span>Contact</span></a></li>
</ul>
</div>
<%
	if(PortfolioModule.isTrader(request)&&(request.getParameter("customerId")==null||request.getParameter("customerId").equalsIgnoreCase(""))){
		ResultSet rs=PortfolioModule.getCustomers(request);
		ResultSetMetaData metaData=rs.getMetaData();
		if(rs.next()){
			%>
			<table border=1 cellpading=0 cellspacing=0>
				<tr>
					<%
						for(int i=2;i<=metaData.getColumnCount();i++){
							out.write("<th>"+metaData.getColumnLabel(i)+"</th>");
						}
					%>
				</tr>
				<tbody>
					<%
						do{
							out.write("<tr>");
							for(int i=2;i<=metaData.getColumnCount();i++){
								if(i!=2){
									out.write("<td>"+rs.getString(i)+"</td>");
								}else{
									out.write("<td><a href=\"index.jsp?customerId="+rs.getString(1)+"\">"+rs.getString(i)+"</a></td>");
								}
							}
							out.write("<tr>");
						}while(rs.next());
					%>				
				</tbody>
			</table>
			<%
		}else{
			%><span style="color: #bb0000">No customers available.</span><%
		}
	}else{
		ResultSet rs=PortfolioModule.getPortfolio(request);
		ResultSetMetaData metaData=rs.getMetaData();
		if(rs.next()){
			%>
			<table border=1 cellpading=0 cellspacing=0>
				<tr>
					<%
						for(int i=1;i<=metaData.getColumnCount();i++){
							out.write("<th>"+metaData.getColumnLabel(i)+"</th>");
						}
					%>
				</tr>
				<tbody>
					<%
						do{
							out.write("<tr>");
							for(int i=1;i<=metaData.getColumnCount();i++){
								out.write("<td>"+rs.getString(i)+"</td>");
							}
							out.write("<tr>");
						}while(rs.next());
					%>				
				</tbody>
			</table>
			<%
		}else{
			%><span style="color: #bb0000">No bonds in possession.</span><%
		}
	}
%>
</body>
</html>