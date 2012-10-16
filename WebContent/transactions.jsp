<%@page import="com.db.training.blb.SearchCriteria"%>
<%@page import="com.db.training.blb.PortfolioModule"%>
<%@page import="com.db.training.blb.dao.*"%>
<%@ include file="common.jsp"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="common_styles.css" rel="stylesheet" type="text/css">
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<title>Online Wholesaler</title>
<style>
div.message {
	width: 500px;
	padding: 10px;
	border: 1px solid gray;
	margin: 10px;
}
</style>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div id='cssmenu'>
		<ul>
			<li class='active '><a href='index.jsp'><span>Home/Portfolio
						Management</span></a></li>
			<%
				if (request.getParameter("customerId") != null
						&& (!request.getParameter("customerId")
								.equalsIgnoreCase(""))) {
			%>
			<li><a
				href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>

			<li><a
				href='sell.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Sell</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%
		if(PortfolioModule.isTrader(request)){
			String sessionId="";
			Cookie[] cs=request.getCookies();
			if(cs!=null){
			    List<Cookie> cookies=Arrays.asList(cs);
			    for(Cookie cookie: cookies){
			    	if(cookie.getName().equalsIgnoreCase("SESSION")){
			    		sessionId=cookie.getValue().trim();
			    	}
			    }
			}
			QueryEngine engine=new QueryEngine(new ConnectionEngine());
			ResultSet rs=engine.query("select id as 'ID', buyer_id as 'Buyer Group ID', seller_id as 'Seller Group ID', (select username from blb.traders t1 where t1.id=trader_id limit 1) as 'Trader',transaction_date as 'Date & Time', bond_cusip as 'CUSIP', quantity as 'Quantity',(case when transaction_status=1 then 'pending' else (case when transaction_status=0 then 'initiated' else (case when transaction_status=2 then 'completed' else (case when transaction_status=3 then 'cancelled' end) end) end) end) as 'Status' from blb.transactions where trader_id in (select participant_id from blb.groups where id = (select g.id from blb.groups g where participant_id = (select t.id from blb.traders t inner join blb.login_session l on t.username=l.username where l.session_id=?) and group_type=0 ))",sessionId);
			ResultSetMetaData metaData = rs.getMetaData();
			if (rs.next()) {
	%>
	<br>
	<table border=1 cellspacing=0 id="newspaper-b">
		<tr>
		<thead>
			<%
				for (int i = 1; i <= metaData.getColumnCount(); i++) {
					out.write("<th>" + metaData.getColumnLabel(i) + "</th>");
				}
			%>
		</thead>
		<!--tfoot>
			<tr>
				<td colspan="5"><em>Please choose a Customer by clicking
						on their name to continue.</em></td>
			</tr>
		</tfoot-->
		<tbody>
			<%
			do {
				out.write("<tr>");
				for (int i = 1; i <= metaData.getColumnCount(); i++) {
					out.write("<td>" + rs.getString(i) + "</td>");
				}
				out.write("</tr>");
			} while (rs.next());
			%>
		</tbody>
	</table>
	<%
			}
		}
	 %>
</body>
</html>