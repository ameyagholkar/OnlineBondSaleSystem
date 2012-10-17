<%@page import="com.db.training.blb.objects.ConfirmationData"%>
<%@page import="com.db.training.blb.BondModule"%>
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
<script type="text/javascript">
function validate(){
	if(isNaN(document.getElementById("quantity").value) || (document.getElementById("quantity").value == "" ) ){
		alert("Please enter a number.");
		return false;
	}
	
	if(!isNaN(document.getElementById("quantity").value)){
		if(parseInt(document.getElementById("quantity").value) <= 0){
			alert("Please enter a number greater than 0.");
			return false;
		}
	}
}

</script>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div id='cssmenu'>
		<ul>
			<li><a href='index.jsp'><span>Home/Portfolio
						Management</span></a></li>
			<%
				if (request.getParameter("customerId") != null
						&& (!request.getParameter("customerId")
								.equalsIgnoreCase(""))) {
			%>
				<li><a href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>
				<li class='active'><a href='sell.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Sell</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%



	%>		
			<%@ include file="customer_name_balance_header.jsp"  %>
	<%
	if(request.getParameter("action")!=null ){
		if("sell".equalsIgnoreCase(request.getParameter("action"))){
	    String sessionId="";
		Cookie[] cookies=request.getCookies();
		if(cs!=null){
		    List<Cookie> cookiez=Arrays.asList(cs);
		    for(Cookie cookie: cookiez){
		    	if(cookie.getName().equalsIgnoreCase("SESSION")){
		    		sessionId=cookie.getValue().trim();
		    	}
		    }
		}
		ConfirmationData data= new BondModule().sellBond(request.getParameter("cusip"),request.getParameter("customerId"), request.getParameter("quantity"), sessionId);
		switch(data.getStatus()){
			case 0: out.println("Oops! Something went wrong. Transaction has been aborted. Please use the Portfolio Management button to start again."); break;
			case 1: 
				ResultSet rs=new BondModule().getTransactionDataFromDate(data.getProcessingTime(), request.getParameter("customerId"), 1);
				int id=0;
				if(rs.next()){
				%>
				<table id="newspaper-b">

				<tr>
					<td>CUSIP</td>
					<td>
						<%
							out.println(rs.getString("cusip"));
						%>
					</td>
				</tr>
				<tr>
					<td>Rating (SnP)</td>
					<td>
						<%
							out.println(SearchCriteria.getSnpRating(rs
													.getString("rating_snp")));
						%>
					</td>
				</tr>
				<tr>
					<td>Rating (Moody's)</td>
					<td>
						<%
							out.println(SearchCriteria.getMoodysRating(rs
													.getString("rating_moody")));
						%>
					</td>
				</tr>
				<tr>
					<td>Price ($)</td>
					<td>
						<%
							out.println(rs.getDouble("price"));
						%>
					</td>
				</tr>
				<tr>
					<td>Quantity</td>
					<td>
						<%
							out.println(rs.getInt("quantity"));
						%>
					</td>
				</tr>
				<tr>
					<td>Transaction Date</td>
					<td>
						<%
							out.println(rs.getString("date"));
						%>
					</td>
				</tr>
				<tr>
					<td>Trader</td>
					<td>
						<%
							out.println(rs.getString("tusername"));
						%>
					</td>
				</tr>
				<tfoot><tr><td colspan=2>
					<em><b>The sell transaction has been successfully initiated. You
							will receive a confirmation upon successful clearance. If you wish
							to cancel this transaction, please press </b></em>
					<a name="cancelBtn" href="sell.jsp?customerId=<%= request.getParameter("customerId") %>&action=cancel&transId=<%= rs.getInt("transaction_id") %>">Cancel</a>
					</td></tr>
				</tfoot>
			</table><%
				} break;
			case 2:
				%>
					<div align="center" class="ex" id="errorMessage">
					<table>
						<tr>
							<td><img src="images/Error.png" /></td>
							<td><span style="font-family: Lucida Sans; font-weight: bold;">
								Cannot process order since the requested quantity of bond is not available.
							</span></td>
						</tr>
					</table>
					</div>
				<%
				break;
			
			}// switch
		}else{
			boolean result="cancel".equalsIgnoreCase(request.getParameter("action"))?(new BondModule().cancelTransaction2(request.getParameter("customerId"), request.getParameter("transId"))):false;
			if(result){
				response.sendRedirect("index.jsp?customerId="+request.getParameter("customerId")+"&cancel=1");
				return;
			}
		}
		
	}else{
		if(request.getParameter("customerId") != null
				&& (!request.getParameter("customerId")
						.equalsIgnoreCase(""))){
			ResultSet rs = PortfolioModule.getPortfolio(request);
			ResultSetMetaData metaData = rs.getMetaData();
			if (rs.next()) {
	%>
	<br>
	<table border=1 cellpading=0 cellspacing=0 id="newspaper-b">
		<tr>
		<thead>
			<%
				for (int i = 1; i <= metaData.getColumnCount(); i++) {
							String s = metaData.getColumnLabel(i);
							if (s.startsWith("Rating")) {
								out.write("<th>Rating</th>");
								i++;
							} else {
								out.write("<th>" + s + "</th>");
							}
						}
			%>
			<th>Sell</th>
		</thead>
		</tr>
		<tbody>
			<%
				do {
							out.write("<tr>");
							String cusip="";
							for (int i = 1; i <= metaData.getColumnCount(); i++) {
								if(metaData.getColumnLabel(i).equalsIgnoreCase("CUSIP")){
									cusip=rs.getString(i);
								}
								if (metaData.getColumnLabel(i).equalsIgnoreCase(
										"RatingSNP")) {
									String snp = rs.getString(i);
									String moody = rs.getString(i + 1);
									out.write("<td>"
											+ SearchCriteria.getSnpRating(snp)
											+ "/"
											+ SearchCriteria.getMoodysRating(moody)
											+ "</td>");
									i++;
								} else {
									out.write("<td>" + rs.getString(i) + "</td>");
								}
							}
							%><td>
							<form action='sell.jsp' method='post' name='sellForm'>
							<input type="text" name="quantity" id="quantity" value=""/><input type="hidden" name="cusip" value="<% out.write(cusip); %>"/>
							<input type="hidden" name="action" value="sell"/>
							<input type="hidden" name="customerId" value="<%=request.getParameter("customerId")%>"/>
							<input type=submit value='Sell'/>
							</form></td></tr>
							<%
						} while (rs.next());
			%>
		</tbody>
	</table>
	<%
		} else {
	%><br><br><span id='bonderror'><em>Currently there are no bond holdings for this customer. Please use the menu above to Buy bonds.</em></span>
	<%
		}
		}else{%>
			<span style="color: #bb0000">No customer selected.</span>
		<%}
	}
	%>
</body>
</html>