<%@page import="com.db.training.blb.dao.ConnectionEngine"%>
<%@page import="com.db.training.blb.dao.QueryEngine"%>
<%@ include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="favicon.jsp"%>
<link href="common_styles.css" rel="stylesheet" type="text/css">
<link href="menu_assets/styles.css" rel="stylesheet" type="text/css">
<link href="table_assets/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Bonds</title>
<script type="text/javascript">
	function validateForm() {
		if (	isNaN(document.getElementById("coupon_rate_low").value) || 
				isNaN(document.getElementById("coupon_rate_high").value) || 
				isNaN(document.getElementById("current_yield_low").value) || 
				isNaN(document.getElementById("current_yield_high").value) || 
				isNaN(document.getElementById("yield2maturity_low").value) || 
				isNaN(document.getElementById("yield2maturity_high").value) || 
				isNaN(document.getElementById("par_value_low").value) || 
				isNaN(document.getElementById("par_value_high").value) ||
				isNaN(document.getElementById("price_low").value) || 
				isNaN(document.getElementById("price_high").value) ) {
			alert("You have entered text instead of a number. Please enter a number.");
			return false;
		}
	}

	var time_variable;
	 
	function getXMLObject()  //XML OBJECT
	{
	   var xmlHttp = false;
	   try {
	     xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");  // For Old Microsoft Browsers
	   }
	   catch (e) {
	     try {
	       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");  // For Microsoft IE 6.0+
	     }
	     catch (e2) {
	       xmlHttp = false;   // No Browser accepts the XMLHTTP Object then false
	     }
	   }
	   if (!xmlHttp && typeof XMLHttpRequest != 'undefined') {
	     xmlHttp = new XMLHttpRequest();        //For Mozilla, Opera Browsers
	   }
	   return xmlHttp;  // Mandatory Statement returning the ajax object created
	}
	 
	var xmlhttp = new getXMLObject();	//xmlhttp holds the ajax object
	 
	function ajaxFunction(customerId) {
	  var getdate = new Date();  //Used to prevent caching during ajax call
	  if(xmlhttp) {
	  	var bond_issuer = document.getElementById("bond_issuer").value;
	  	var bond_name = document.getElementById("bond_name").value;
	  	var rating_low = document.getElementById("rating_low").value;
	  	var rating_high = document.getElementById("rating_high").value;
	  	var coupon_rate_low = document.getElementById("coupon_rate_low").value;
	  	var coupon_rate_high = document.getElementById("coupon_rate_high").value;
	  	var current_yield_low = document.getElementById("current_yield_low").value;
	  	var current_yield_high = document.getElementById("current_yield_high").value;
	  	var yield2maturity_low = document.getElementById("yield2maturity_low").value;
	  	var yield2maturity_high = document.getElementById("yield2maturity_high").value;
	  	var maturity_date_low = document.getElementById("maturity_date_low").value;
	  	var maturity_date_high = document.getElementById("maturity_date_high").value;
	  	var par_value_low = document.getElementById("par_value_low").value;
	  	var par_value_high = document.getElementById("par_value_high").value;
	  	var price_low = document.getElementById("price_low").value;
	  	var price_high = document.getElementById("price_high").value;
	  	//alert(customerId);
	    xmlhttp.open("POST","buy_ajax.jsp",true); //calling testing.php using POST method
	    xmlhttp.onreadystatechange  = handleServerResponse;
	    xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	    xmlhttp.send("bond_name=" + bond_name + "&bond_issuer=" + bond_issuer + "&rating_low=" + rating_low + 
	    		 "&rating_high=" + rating_high +  "&coupon_rate_low=" + coupon_rate_low +  "&coupon_rate_high=" + coupon_rate_high + 
	    		 "&current_yield_high=" + current_yield_high +  "&current_yield_low=" + current_yield_low +  
	    		 "&yield2maturity_low=" + yield2maturity_low + "&yield2maturity_high=" + yield2maturity_high +  
	    		 "&maturity_date_low=" + maturity_date_low + "&maturity_date_high=" + maturity_date_high + 
	    		 "&par_value_low=" + par_value_low + "&par_value_high=" + par_value_high + 
	    		 "&price_high=" + price_high + "&price_low=" + price_low + "&customerId=" + customerId); //Posting txtname to PHP File
	  }
	}
	 
	function handleServerResponse() {
	   if (xmlhttp.readyState == 4) {
	     if(xmlhttp.status == 200) {
	       document.getElementById("txtHint").innerHTML=xmlhttp.responseText; //Update the HTML Form element 
	     }
	   }
	}
</script>

</head>
<%
//Redirect to index Page if the customer id is not set
if (request.getParameter("customerId") == null || "".equalsIgnoreCase(request.getParameter("customerId"))) {
	response.sendRedirect("index.jsp");
	return;
}
try{
	int id=Integer.parseInt(request.getParameter("customerId"));
	if(id<=0){
		response.sendRedirect("index.jsp");
		return;
	}
}catch(Exception e){
	response.sendRedirect("index.jsp");
	return;
}
%>
<body onload="ajaxFunction(<%=request.getParameter("customerId")%>);">

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
			<li class='active'><a
				href='search_bonds.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Buy</span></a></li>

			<li><a
				href='sell.jsp?customerId=<%=request.getParameter("customerId")%>'><span>Sell</span></a></li>
			<%
				}
			%>
			<li><a href='logout.jsp'><span>Logout</span></a></li>
		</ul>
	</div>
	<%@ include file="customer_name_balance_header.jsp"%>
	<%
		if (request.getParameter("invalid") != null) {
	%>
	<div align="center" class="ex" id="errorMessage">
		<table>
			<tr>
				<td><img src="images/Error.png" /></td>
				<td><span style="font-family: Lucida Sans; font-weight: bold;">
						<%
							// Redirect to index Page if the customer id is not set.

								if (request.getParameter("invalid").equals("1")) {
									out.println("Cannot process order since the requested quantity of bond is not available.");
								}
								if (request.getParameter("invalid").equals("2")) {
									out.println("Cannot process order since the customer does not have enough balance.");
								}
						%>
				</span></td>
			</tr>
		</table>
	</div>

	<%
		}
	%>
	<table>
		<tr>
			<td>
				<form
					action='buy.jsp?customerId=<%=request.getQueryString().substring(
					request.getQueryString().indexOf("customerId=") + 11)%>'
					method='POST' name='searchForm' onsubmit="return validateForm()">
					<table cellpadding='10' id='newspaper-b' style='width: 300px;'>
						<thead>
							<tr>
								<td colspan=3><em>Enter the Search Criteria to search
										the market for Bonds. Move your mouse over the fields for
										additional help. If search is initiated without any criteria,
										all available bonds will be displayed.</em></td>
							</tr>
						</thead>
						<tr>
							<th><b>Name</b></th>
							<td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
								type='text' name='bond_name' id='bond_name'
								title="Enter the Name of Bond here."
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Issuer</b></th>
							<td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
								type='text' name='bond_issuer' id='bond_issuer'
								title="Enter the Issuer Name here."
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Rating</b></th>
							<td>Low:&nbsp;<input type='text' name='rating_low'
								id='rating_low' title="Enter Minimum Rating here. E.g. (D/BB)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='rating_high'
								id='rating_high'
								title="Enter Maximum Rating here. E.g. (AAA/Aaa)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Coupon Rate (%)</b></th>
							<td>Low:&nbsp;<input type='text' name='coupon_rate_low'
								id='coupon_rate_low'
								title="Enter Minimum Coupon Rate. E.g. (3.5)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='coupon_rate_high'
								id='coupon_rate_high'
								title="Enter Maximum Coupon Rate. E.g. (10.2)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Current Yield (%)</b></th>
							<td>Low:&nbsp;<input type='text' name='current_yield_low'
								id='current_yield_low'
								title="Enter Minimum Current yield here. E.g. (3.5)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='current_yield_high'
								id='current_yield_high'
								title="Enter Maximum Current yield here. E.g. (10.2)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Yield to Maturity (%)</b></th>
							<td>Low:&nbsp;<input type='text' name='yield2maturity_low'
								id='yield2maturity_low'
								title="Enter Minimum yield to Maturity here. E.g. (3.5)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='yield2maturity_high'
								id='yield2maturity_high'
								title="Enter Maximum yield to Maturity here. E.g. (10.2)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Maturity Date</b></th>
							<td>Low:&nbsp;<input type='text' name='maturity_date_low'
								id='maturity_date_low'
								title="Enter Minimum Maturity Date here. E.g. (YYYY-MM-DD)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='maturity_date_high'
								id='maturity_date_high'
								title="Enter Maximum Maturity Date here. E.g. (YYYY-MM-DD)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Par Value ($)</b></th>
							<td>Low:&nbsp;<input type='text' name='par_value_low'
								id='par_value_low'
								title="Enter Minimum Par Value here. E.g. (50)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='par_value_high'
								id='par_value_high'
								title="Enter Maximum Par Value here. E.g. (500)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<th><b>Price ($)</b></th>
							<td>Low:&nbsp;<input type='text' name='price_low'
								id='price_low' title="Enter Minimum Price here. E.g. (300)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
							<td>High:&nbsp;<input type='text' name='price_high'
								id='price_high' title="Enter Maximum Price here. E.g. (900)"
								onchange="ajaxFunction(<%=request.getParameter("customerId")%>);"></td>
						</tr>
						<tr>
							<td colspan=3 align="center"><input type='hidden'
								id='customerId' value='<%=request.getParameter("customerId")%>' />
								<input type='submit' value='Search'
								style='margin-left: 45px; font-size: 25px; width: 200px;' /></td>
						</tr>

					</table>

				</form>
			</td>
			<td valign='top'>
				<div id='txtHint'></div>
			</td>
		</tr>
	</table>

</body>
</html>