<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
 
<%
	Connection cong=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;

 	try
	{
	cong=C.getConnection();
	}catch(Exception e)
	{
		sout.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>");
	} 



	String command=request.getParameter("command"); 
//	out.print("<br>"+command);
	
	String message=request.getParameter("message"); 

	if(!("Default".equals(message)))
	{
	out.print("<br><b> "+message+"</b>");
	}

	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String company_name= A.getName(cong,"companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();

	
	try{
	if("edit".equals(command))
	{
	String lotLocation=request.getParameter("lotLocation");		
//	out.print("<br>"+lotLocation);
	
%>
		<html>
		<head>
			<title>Samyak Software- India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="EditOpeningStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='lotno'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Opening Stock</th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
				<tr>
					<td>Lot No.</td>
					<td><input type=text name=Lot_No size=12 value=1></td>
				</tr>
				<tr>
					<td>Currency</td>
					<td><input type=radio name=Currency value="local" checked> Local <input type=radio name=Currency value="dollar"> Dollar </td>
				</tr>
				<tr>
					<td colspan=2 align=center><input type=radio name=rateAmount value=rate checked> Rate <input type=radio name=rateAmount value=amount> Amount</td>
				</tr>
				<tr>
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1> </td>
				</tr>
				
			</table>
			</td>
		</tr>
		</table>
		</form>
		</body>
		</html>

	


		<html>
		<head>
			<title>Fine Star - Samyak Software </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="EditOpeningStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='location'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Opening Stock</th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
				<tr>
					<td>Location</td>
					<td><%=A.getMasterArrayCondition(cong,"Location","Location_Id","","where company_id="+company_id)%></td>
				</tr>
				<tr>
					<td>From Lot No.</td>
					<td><input type=text name=fromLot_No size=12 value=1></td>
				</tr>
				<tr>
					<td>To Lot No.</td>
					<td><input type=text name=toLot_No size=12 value=1></td>
				</tr>
				<tr>
					<td>Currency</td>
					<td><input type=radio name=Currency value="local" checked> Local <input type=radio name=Currency value="dollar"> Dollar </td>
				</tr>
				<tr>
					<td colspan=2 align=center><input type=radio name=rateAmount value=rate checked> Rate <input type=radio name=rateAmount value=amount> Amount</td>
				</tr>
				<tr>
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1> </td>
				</tr>
			</table>
			</td>
		</tr>
		</table>
		</form>
		</body>
		</html>

<%
	C.returnConnection(cong);

}

}catch(Exception e) { out.print("<br>134::===>> "+e); }%>


<%	if("Next".equals(command))
	{

 	String query="";
	int i=0;

	String lotLocation=request.getParameter("lotLocation");		
//	out.print("<br> lotLocation "+lotLocation);
	
	String rateAmount=request.getParameter("rateAmount");		
//	out.print("<br> rateAmount "+rateAmount);

	String Currency=request.getParameter("Currency");		
//	out.print("<br> Currency "+Currency);

	if("lotno".equals(lotLocation))
	{
	String Lot_No=request.getParameter("Lot_No");
//	out.print("<br> Lot_No "+Lot_No);
	
	query="select count(Lot_Id) as LotCount from Lot where Lot_No=? and company_id="+company_id;
	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);

	try
	{
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	}catch(Exception e) { out.print("<br> Samyak Bug 169 ::::<font color= red> "+e+"</font>"); }

	
	while(rs_g.next())
	{
		i=rs_g.getInt("LotCount");
//		out.print("<br> i==>"+i);
	}
	
	if(i==0)
	{
		C.returnConnection(conp);

		%>
	<html>
		<head>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
		</head>
		<body background='../Buttons/BGCOLOR.JPG' >
			<br><center>
			<font class='star1'><b>Lot No 
			<font class='msgcolor2'><%=Lot_No%> </font>does not exists.</font></b>
			<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
		</body>
		</html>

<%	}
	else
	{
	pstmt_g.close();
	i=0;

	query="Select * from Receive R, Receive_Transaction RT,Lot L where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=true and   RT.Lot_Id=L.Lot_Id and L.Lot_No=? and L.company_id=?";
	
	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);

//	out.print("<br>"+query);
	try
	{
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	}catch(Exception e) { out.print("<br> Samyak Bug 211 ::::<font color= red> "+e+"</font>"); }
	
	while(rs_g.next())
	{
		i++;
	}
	
	int locationPresent=i;
	pstmt_g.close();

	long PLocation_Id[]=new long[locationPresent];
	long PReceive_CurrencyId[]=new long[locationPresent];
	double PReceive_Quantity[]=new double[locationPresent];
	double PReceive_ExchangeRate[]=new double[locationPresent];
	double PLocal_Total[]=new double[locationPresent];
	double PDollar_Total[]=new double[locationPresent];
	long PUnit_Id[]= new long[locationPresent];
	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);

//	out.print("<br>"+query);
	try
	{
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	}catch(Exception e) { out.print("<br> Samyak Bug 232 ::::<font color= red>"+e+"</font>"); }

	try{
	
	i=0;

	while(rs_g.next())
	{
		PLocation_Id[i]=rs_g.getLong("Location_Id");
		PReceive_CurrencyId[i]=rs_g.getLong("Receive_CurrencyId");
		PReceive_Quantity[i]=rs_g.getDouble("Receive_Quantity");
		PReceive_ExchangeRate[i]=rs_g.getDouble("Receive_ExchangeRate");
		PLocal_Total[i]=rs_g.getDouble("Local_Total");
		PDollar_Total[i]=rs_g.getDouble("Dollar_Total");
		PUnit_Id[i]=rs_g.getLong("Unit_Id");
		i++;
	}
	
	}catch(Exception e) { out.print("<br> Samyak Bug 243 ::::<font color= red>"+e+"</font>"); }
 %>

	<html>
		<head>
			<title>Samyak Software- India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="UpdateEditOpeningStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="<%=lotLocation%>">
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="Lot_No" value="<%=Lot_No%>">
	<input type=hidden name="counter" value="<%=locationPresent%>">
<!-- 	<input type=hidden name="locationAbsent" value="<%//=locationAbsent%>">
 -->
	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Opening Stock Lot No. Wise</th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
				<tr bgcolor=#CCFFFF>
					<td width='10%' align=center>Sr.No.</td>
					<td width='15%' align=center>Lot No.</td>
					<td width='20%' align=center>Location</td>
					<td width='15%' align=center>Unit of Measurement</td>
					<td width='15%' align=center>Quantity</td>
<%					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=center>Local Amount</td>
<%						}
						else {%> <td width='15%' align=center>Local Rate</td> <% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=center>Dollar Amount</td>
<%						}
						else {%> <td width='15%' align=center>Dollar Rate</td> <% } 
					}
%>					<td width='10%' align=center>Exchange Rate</td>
				</tr>
			
	<!-- 	<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
 -->
<%	int k=0;
	for(k=0;k<locationPresent;k++)
	{%>
				<tr>
					<td width='5%'><%=k+1%><input type=checkbox name=chk<%=k%> value=yes></td>
					<td width='15%'><%=Lot_No%></td>
					<td width='20%' align=center><%=A.getName(cong,"Location",""+PLocation_Id[k])%><input type=hidden name=ALocation_Id<%=k%> value=<%=PLocation_Id[k]%> ></td>
					<td width='15%' align=center><%=A.getName(cong,"Unit",""+PUnit_Id[k])%> <input type=hidden name=AUnit_Id<%=k%> value=<%=PUnit_Id[k]%> ></td>
					<td width='15%' align=right><input type=text name='AQuantity<%=k%>' value='<%=PReceive_Quantity[k]%>' style='text-align:right' size=10></td>
<%					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right><input type=text name='ARateAmount<%=k%>' value='<%=PLocal_Total[k]%>' style='text-align:right' size=10></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name='ARateAmount<%=k%>' value='<%=PLocal_Total[k]/PReceive_Quantity[k]%>' style='text-align:right' size=10></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right><input type=text name='ARateAmount<%=k%>' value='<%=PDollar_Total[k]%>' style='text-align:right' size=10></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name='ARateAmount<%=k%>' value='<%=PDollar_Total[k]/PReceive_Quantity[k]%>' style='text-align:right' size=10></td> 
						<% } 
					}%>	
					<td width='10%' align=right><input type=text name='AExchange_Rate<%=k%>' value='<%=str.format(""+PReceive_ExchangeRate[k],2)%>' style='text-align:right' size=10></td>
				</tr>
<%}%>
					</table>
				</td>
				</tr>
				<tr>
					<td align=center><input type=submit name=command value="Update" class=button1></td>
				<tr>
			</table>
			</form>
			</body>
			</html>
<% 	}//else
	
	}//lot no

C.returnConnection(cong);
}//Next
%>








