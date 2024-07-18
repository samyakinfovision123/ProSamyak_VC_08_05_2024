<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<%
	String command=request.getParameter("command"); 
// out.print("<br>"+command);
	
	String message=request.getParameter("message"); 
	
	if(!("Default".equals(message)))
	{
	out.print("<br><b> "+message+"</b>");
	}

	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	//String company_name= A.getName("companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();

	Connection cong=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;

	try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }



/*if("Default".equals(command))
{*/%>
<!-- <html>
<head>
<title>Fine Star - Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="OpeningStock.jsp" method=post name=f1>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr>
	<th bgcolor=skyblue>Opening Stock</th>
</tr>
<tr>
<td>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>

<tr>
	<td> <input type=radio name=lotLocation value=lotno checked> Lot No. Wise </td>
	<td> <input type=radio name=lotLocation value=location> Location Wise </td>
</tr>
</table>
</td>
</tr>
<tr>
	<td colspan=2 align=center><input type=submit name=command value="Submit" class=button1></td>
</tr>
</table>
</form>
</body>
</html>
 -->
<%//}

if("Default".equals(command))
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
		<form action="ClosingStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='lotno'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Closing Stock - Lotwise</th>
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
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
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
		<form action="ClosingStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='location'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Closing Stock - Locationwise</th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
				<tr>
					<td>Location</td>
					<td><%=A.getMasterArrayCondition(cong,"Location","Location_Id","","where company_id="+company_id)%></td>
<%					C.returnConnection(cong);      %>
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
						<td>Order By</td>
						<td><select name=order>
								<option value='1'>Lot No
								<option value='2'>Lot Id
	                	    </select></td>
						</tr>
				<tr>
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
				</tr>
			</table>
			</td>
		</tr>
		</table>
		</form>
		</body>
		</html>

<%}%>

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

//**********If LOT_NO Start Here ************

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
		  C.returnConnection(cong);
%>
	<html>
		<head>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
		</head>
		<body background='../Buttons/BGCOLOR.JPG' >
			<br><center>
			<font class='star1'><b>Lot No 
			<font class='msgcolor2'><%=Lot_No%> </font>does not exists.</font></b>
			<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></center>
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
		PLocal_Total[i]=rs_g.getDouble("Local_Price");
		PDollar_Total[i]=rs_g.getDouble("Dollar_Price");
		PUnit_Id[i]=rs_g.getLong("Unit_Id");
		i++;
	}
	
	}catch(Exception e) { out.print("<br> Samyak Bug 243 ::::<font color= red>"+e+"</font>"); }

	try{
	
	for(int j=0;j<i;j++)
	{
//		out.print("<br> PLocation_Id "+PLocation_Id[j]);
	}
	
	}catch(Exception e) { out.print("<br> Samyak Bug 281 ::::<font color= red>"+e+"</font>"); }
	

	query="select * from Master_Location where  Active=1 and company_id="+company_id+" and location_id NOT IN (Select Location_Id from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=true and   RT.Lot_Id=ALL (select Lot_Id from Lot where Lot_No =? and company_id=?) )";

	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);

//	out.print("<br>"+query);
	try
	{
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	}catch(Exception e) { out.print("<br> Samyak Bug 266 ::::<font color= red> "+e+"</font>"); }
	i=0;
	while(rs_g.next())
	{
		i++;
	}
	
	int locationAbsent=i;
 //	out.print("<br>"+i);
	pstmt_g.close();

	long ALocation_Id[]=new long[locationAbsent];

	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);

//	out.print("<br>"+query);
	try
	{
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	}catch(Exception e) { out.print("<br> Samyak Bug 287 ::::<font color= red>"+e+"</font>"); }

	try{
	
	i=0;
	while(rs_g.next())
	{
		ALocation_Id[i++]=rs_g.getLong("Location_Id");
	}
	
	}catch(Exception e) { out.print("<br> Samyak Bug 297 ::::<font color= red>"+e+"</font>"); }

	try{
	
	for(int j=0;j<i;j++)
	{
//		out.print("<br> ALocation_Id "+ALocation_Id[j]);
	}
	
	}catch(Exception e) { out.print("<br> Samyak Bug 306 ::::<font color= red>"+e+"</font>"); }


%>
	
	<html>
		<head>
			<title>Fine Star - Samyak Software </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="UpdateClosingStock.jsp?" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="<%=lotLocation%>">
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="Lot_No" value="<%=Lot_No%>">
	<input type=hidden name="locationAbsent" value="<%=locationAbsent%>">

	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Closing Stock for Lot No. <%=Lot_No%></th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
				<tr bgcolor=#CCFFFF>
					<td width='10%' align=center>Sr.No.</td>
<!-- 					<td width='15%' align=center>Lot No.</td>
 -->					<td width='20%' align=center>Location</td>
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
					<td width='10%'><%=k+1%></td>
<!-- 					<td width='15%'><%=Lot_No%></td>
 -->					<td width='20%' align=center><%=A.getName(cong,"Location",""+PLocation_Id[k])%></td>
					<td width='15%' align=center><%=A.getName(cong,"Unit",""+PUnit_Id[k])%></td>
					<td width='15%' align=right OnBlur='return validate(this,3)'><%=PReceive_Quantity[k]%></td>
<%					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right OnBlur='return validate(this,3)'><%=PLocal_Total[k] *PReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=PLocal_Total[k]%></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right OnBlur='return validate(this,3)'> <%=PDollar_Total[k] * PReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=PDollar_Total[k]%></td> 
						<% } 
					}%>	
					<td width='10%' align=right><%=str.format(""+PReceive_ExchangeRate[k],2)%></td>
				</tr>
<%}%>
<%	int c=k;
	try {
	for(k=0;k<locationAbsent;k++)
	{%>
				<tr>
					<td width='10%'><%=++c%><input type=checkbox name=chk<%=k%> value=yes></td>
<!-- 					<td width='15%'><%=Lot_No%></td>
 -->					<td width='20%' align=left><%=A.getName(cong,"Location",""+ALocation_Id[k])%><input type=hidden name=ALocation_Id<%=k%> value='<%=ALocation_Id[k]%>'></td>
					<td width='15%' align=left><%=A.getName(cong,"Unit",A.getNameCondition(cong,"Lot","Unit_Id","where Lot_No='"+Lot_No+"' and Company_Id="+company_id+""))%><input type=hidden name=AUnit_Id<%=k%> value='<%=A.getNameCondition(cong,"Lot","Unit_Id","where Lot_No='"+Lot_No+"' and Company_Id="+company_id+"")%>'></td>
					<td width='15%' align=right OnBlur='return validate(this,3)'><input type=text name=AQuantity<%=k%> value='0.0' style='text-align:right' size=10 OnBlur='return validate(this,3)'></td>
					<td width='15%' align=right><input type=text name=ARateAmount<%=k%> value='0.0' style='text-align:right' size=10></td>
<%					String ex_rate=""+I.getLocalExchangeRate(cong,company_id);%>
					<td width='10%' align=right><input type=text name=AExchange_Rate<%=k%> value=<%=str.format(ex_rate,2)%> style='text-align:right' size=8></td>
				</tr>
	<%}
					}catch(Exception e) { out.print("<br> 433"+e); }%>
			</table>
			</td>
		</tr>
<% if(locationAbsent>0)
		{%>
		<tr>
			<td align=center><input type=submit name=command value="Update" class=button1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
		<tr>
<%}%>
	</table>
	</form>
	</body>
	</html>
<%
						  C.returnConnection(cong);
	}
	}// if lotno

//*******If location  Start Here **********************

	if("location".equals(lotLocation))
	{

String order=request.getParameter("order");
 //	 out.print("<br>order "+order);
	if("1".equals(order))
	{

	String Location_Id=request.getParameter("Location_Id");
//	out.print("<br> Location_Id "+Location_Id);

	String fromLot_No=request.getParameter("fromLot_No");
	//out.print("<br> fromLot_No "+fromLot_No);

	String toLot_No=request.getParameter("toLot_No");
	//out.print("<br> toLot_No "+toLot_No);
	

	String fromLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+fromLot_No+"'" );
	
	//out.print("<br> fromLot_Id "+fromLot_Id);

	String toLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+toLot_No+"'" );

	//out.print("<br> toLot_Id "+toLot_Id);
try{
		if(("".equals(fromLot_Id))||("".equals(toLot_Id)))
		{
			  C.returnConnection(cong);

	%>
			<html>
			<head>
				<script language="JavaScript">
					function f1()
					{
					var ccno = "<%=fromLot_No%>";
					var ctno = "<%=toLot_No%>";
					alert("The Lot_ No "+ccno+" or "+ctno+" doesn't exist"); 
					//history.go(-1);
					//window.close(); 

					}
				</script>
			</head>
			<body bgColor=#ffffee onLoad='f1()'  background="../Buttons/BGCOLOR.JPG">
			</body>
			</html>
		
<%	

	response.sendRedirect("ClosingStock.jsp?command=Default&message=<center><font color=blue>Lot No. </font><font color=red>"+fromLot_No+"</font><font color=blue> or </font><font color=red>"+toLot_No+"</font><font color=blue> does not exist</font>" );
			
		}
			

		else
		{
			
			query="select * from Lot where company_id="+company_id+"  order by lot_no";
			pstmt_g=cong.prepareStatement(query);
//			out.print(query);

			
			rs_g=pstmt_g.executeQuery();
			

			int  countLot_Id=0;
			int from=0;
			int to=0;

			String  Lot_No="";
				 //out.print("<br>fromLot_No"+fromLot_No);
			
			while(rs_g.next())
			{
				Lot_No=rs_g.getString("Lot_No");
				//out.print("<br>Lot_No"+Lot_No);
				
				if(Lot_No.equalsIgnoreCase(fromLot_No))
				{
				from=countLot_Id;
				}
				
				if(Lot_No.equalsIgnoreCase(toLot_No))
				{
				to=countLot_Id;
				}
			countLot_Id++;	

			}
			to++;				

						//out.print("<br>from"+from);
					//	out.print("<br>to"+to);
		countLot_Id=to-from;
///out.print("<br>countLot_Id="+countLot_Id);
		if(countLot_Id>25)
			{
			  C.returnConnection(cong);

			%><html>
			<head>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

			</head>
			<body><%
				out.print("<center><font class='msgblue'>Sorry could not add opening stock for more than 25 Lots at a time Please select the range containing less than 25 Lots </center>");
				out.print("<br><center><input type='button' name='command' value='Back' class='button1' onclick='history.go(-1)'></center>");%>
			</body>
				</html><%
			}
			else{
			 //out.print("<br>countLot_Id "+countLot_Id);
			pstmt_g.close();
			
			long interLot_Id[]=new long[countLot_Id];
			long PresentLot_Id[]=new long[countLot_Id];
			long AbsentLot_Id[]=new long[countLot_Id];
			long LPReceive_CurrencyId[]=new long[countLot_Id];
			double LPReceive_Quantity[]=new double[countLot_Id];
			double LPReceive_ExchangeRate[]=new double[countLot_Id];
			double LPLocal_Total[]=new double[countLot_Id];
			double LPDollar_Total[]=new double[countLot_Id];
			long LPUnit_Id[]= new long[countLot_Id];
			String LPLot_No[]=new String[countLot_Id];
			
			pstmt_g=cong.prepareStatement(query);
 			//out.print(query);
			
			int countLot=0;
			rs_g=pstmt_g.executeQuery();
							int j=1;

			while(rs_g.next())
			{
				
				Lot_No=rs_g.getString("Lot_No");

				if(Lot_No.equalsIgnoreCase(fromLot_No))
				{

				//out.print("<br> 637 if from");
				interLot_Id[countLot]=rs_g.getLong("Lot_Id");
				rs_g.next();
				countLot++;

				int temp1=countLot_Id;
				 
				temp1=temp1-1;
				//out.print("***temp1"+temp1);
				
				for(j=1;j<=temp1;j++)
					{
					interLot_Id[countLot]=rs_g.getLong("Lot_Id");
					rs_g.next();
					countLot++;
					}

				break;
				}//end if
							
			
			}
			pstmt_g.close();
			
			 	/*	for(j=0;j<countLot_Id;j++)
					{

			//	 out.print("<br>1lot"+j+"->"+interLot_Id[j]);
					}

*/

			int count=0;
			int Present[]=new int[countLot_Id];
			int m=0;
			// out.print("***countLot_Id"+countLot_Id);

			for(count=0;count<countLot_Id;count++)
			{
				Present[count]=0;
				query="Select * from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=true and  RT.Lot_Id=? and RT.Location_Id=?  and R.company_id="+company_id;

				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setString(1,""+interLot_Id[count]);
				pstmt_g.setString(2,""+Location_Id);
				rs_g=pstmt_g.executeQuery();
				//out.print("**"+count);
				while(rs_g.next())
				{
					Present[count]=1;
//					out.print("<br>yes"+count+"        "+interLot_Id[count]);
					PresentLot_Id[m]=interLot_Id[count];
					LPReceive_CurrencyId[m]=rs_g.getLong("Receive_CurrencyId");
					LPReceive_Quantity[m]=rs_g.getDouble("Receive_Quantity");
					LPReceive_ExchangeRate[m]=rs_g.getDouble("Receive_ExchangeRate");
					LPLocal_Total[m]=rs_g.getDouble("Local_Price");
					LPDollar_Total[m]=rs_g.getDouble("Dollar_Price");
					LPUnit_Id[m]=Long.parseLong(A.getNameCondition(cong,"Lot","Unit_Id","where Lot_Id="+PresentLot_Id[m]));
					
					LPLot_No[m]=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+PresentLot_Id[m]);
					m++;
				}
			}
		  
	
 	//out.print("<br> m= "+m);
			int n=0;
			for(count=0;count<countLot_Id;count++)
			{
				if(Present[count]!=1)
				{
					 //	out.print("<br>708  m= "+m);

					AbsentLot_Id[n]=interLot_Id[count];
					n++;
				}
			}
			//out.print("<br> n= "+n);
			

%>
<html>
		<head>
			<title>Samyak Software- India </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		

		<script language=javascript>
				function selectall(name)
				{
				//alert("hi");
					if(name.checked)
					{
					<%for(int chk=0;chk<n;chk++){%>
						document.f1.chk<%=chk%>.checked=true;
					<%}%>
					}
					else{
					<%for(int chk=0;chk<n;chk++){%>
						document.f1.chk<%=chk%>.checked=false;
					<%}%>
					}
				}
			</script>
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="UpdateClosingStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%' rules=no>
		
		<% if(!(n==0))
			{%>
			<tr>
			<td bgcolor=skyblue width='20%'>&nbsp;
			<input type=checkbox name=chkselectall value="1" onclick='selectall(this)'> Select All
				</td>
			
			<td bgcolor=skyblue width='80%' align=center><b>Closing Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></b></td>
		</tr>
		<%	}else{	%>
				<tr>
				<td bgcolor=skyblue width='100%' align=center colspan=2><b>Closing Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></b></td>
		</tr>
		<%	}	%>
			
		<tr>
			<td colspan=2>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
				<tr bgcolor=#CCFFFF>
					<td width='10%' align=center>Sr.No.</td>
					<td width='15%' align=center>Lot No.</td>
<!-- 					<td width='20%' align=center>Location</td>
 -->					<td width='15%' align=center>Unit of Measurement</td>
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
%>						<td width='10%' align=center>Exchange Rate</td>
			
				</tr>
<%int k=0;%>
			<input type=hidden name=present value="<%=m%>">	
<%
for(k=0;k<m;k++)
	{%>			
				<tr>
					<td width='10%'><%=k+1%></td>
					<td width='15%'><%=LPLot_No[k]%></td>
<!-- 					<td width='20%' align=center><%//=A.getName(cong,"Location",""+Location_Id)%></td>
 -->					<td width='15%' align=left><%=A.getName(cong,"Unit",""+LPUnit_Id[k])%></td>
					<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPReceive_Quantity[k]%></td>
<%					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPLocal_Total[k]* LPReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=LPLocal_Total[k]%></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPDollar_Total[k]*LPReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=LPDollar_Total[k]%> </td> 
						<% } 
					}%>				
					<td width='10%' align=right><%=str.format(""+LPReceive_ExchangeRate[k],2)%></td>

				</tr>
<%}%>
						<input type=hidden name=absent value="<%=n%>">
<%int c=m;
				//out.print("<br> 830 "+c);
%>
<%
for(k=0;k<n;k++)
	{%>	
	

				<tr>
					<td width='10%'><%=++c%><input type=checkbox name=chk<%=k%> value=yes></td>
					<td width='15%'><%=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+AbsentLot_Id[k])%><input type=hidden  name=ALot_Id<%=k%> value='<%=AbsentLot_Id[k]%>'></td>

					<input type=hidden name=ALocation_Id<%=k%> value='0'>
					
					<td width='15%' align=left><%=A.getNameCondition(cong,"Master_Unit","Unit_Name","where Unit_Id="+A.getNameCondition(cong,"Lot","Unit_Id","where Lot_Id="+AbsentLot_Id[k]))%><input type=hidden name=AUnit_Id<%=k%> value='<%=A.getNameCondition(cong,"Lot","Unit_Id","where Lot_ID="+AbsentLot_Id[k])%>'></td>
					<td width='15%' align="right"><input type=text name=AQuantity<%=k%> value='0.0' style='text-align:right' size=10  OnBlur='return validate(this,3)'></td>
<%					String ex_rate=""+I.getLocalExchangeRate(cong,company_id);%>
					<td width='15%' align=right><input type=text name=ARateAmount<%=k%> value='0.0' style='text-align:right' size=10></td>
					<td width='10%' align=right><input type=text name=AExchange_Rate<%=k%> value=<%=str.format(ex_rate,2)%> style='text-align:right' size=8  OnBlur='return validate(this,2)'></td>
				</tr>
	<%}%>
			</table>
					</td>
				</tr>
<% if(n>0)
				{%>
				<tr>
					<td align=center colspan=2><input type=submit name=command value="Update" class=button1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
				<tr>
<%}%>
			</table>
			</form>
			</body>
			</html>
			
<%	             C.returnConnection(cong);
	}
					}
}catch(Exception e) { out.print("<br> Samyak Bug 528 ::::<font color= red>"+e+"</font>"); }

	}// order by order no

	else
	{
//-------------------------------------------------------------------
	String Location_Id=request.getParameter("Location_Id");
//	out.print("<br> Location_Id "+Location_Id);

	String fromLot_No=request.getParameter("fromLot_No");
//	out.print("<br> fromLot_No "+fromLot_No);

	String toLot_No=request.getParameter("toLot_No");
//	out.print("<br> toLot_No "+toLot_No);
	

	String fromLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+fromLot_No+"'" );
	
//	out.print("<br> fromLot_Id "+fromLot_Id);

	String toLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+toLot_No+"'" );

//	out.print("<br> toLot_Id "+toLot_Id);
try{
		if(("".equals(fromLot_Id))||("".equals(toLot_Id)))
		{
			  C.returnConnection(cong);

	%>
			<html>
			<head>
				<script language="JavaScript">
					function f1()
					{
					var ccno = "<%=fromLot_No%>";
					var ctno = "<%=toLot_No%>";
					alert("The Lot_ No "+ccno+" or "+ctno+" doesn't exist"); 
					//history.go(-1);
					//window.close(); 

					}
				</script>
			</head>
			<body bgColor=#ffffee onLoad='f1()'  background="../Buttons/BGCOLOR.JPG">
			</body>
			</html>
		
<%		response.sendRedirect("ClosingStock.jsp?command=Default&message=<center><font color=blue>Lot No. </font><font color=red>"+fromLot_No+"</font><font color=blue> or </font><font color=red>"+toLot_No+"</font><font color=blue> does not exist</font>" );
			
		}
			

		else
		{
//			out.print("query");
			query="select * from Lot where Lot_Id between "+fromLot_Id+" and "+toLot_Id+" and company_id="+company_id;
			
			pstmt_g=cong.prepareStatement(query);
//			out.print(query);

			
			rs_g=pstmt_g.executeQuery();
			

			int countLot_Id=0;
			while(rs_g.next())
			{
				countLot_Id++;
			}
//			out.print("<br>countLot_Id "+countLot_Id);
			pstmt_g.close();
			if(countLot_Id>25)
			{
				  C.returnConnection(cong);

			%><html>
			<head>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

			</head>
			<body><%
				out.print("<center><font class='msgblue'>Sorry could not add opening stock for more than 25 Lots at a time Please select the range containing less than 25 Lots </center>");
				out.print("<br><center><input type='button' name='command' value='Back' class='button1' onclick='history.go(-1)'></center>");%>
			</body>
				</html><%
			}
			else{
			long interLot_Id[]=new long[countLot_Id];
			long PresentLot_Id[]=new long[countLot_Id];
			long AbsentLot_Id[]=new long[countLot_Id];
			long LPReceive_CurrencyId[]=new long[countLot_Id];
			double LPReceive_Quantity[]=new double[countLot_Id];
			double LPReceive_ExchangeRate[]=new double[countLot_Id];
			double LPLocal_Total[]=new double[countLot_Id];
			double LPDollar_Total[]=new double[countLot_Id];
			long LPUnit_Id[]= new long[countLot_Id];
			String LPLot_No[]=new String[countLot_Id];
			
			pstmt_g=cong.prepareStatement(query);
//			out.print(query);
			
			int countLot=0;
			rs_g=pstmt_g.executeQuery();
			while(rs_g.next())
			{
				interLot_Id[countLot]=rs_g.getLong("Lot_Id");
				countLot++;
			}
			pstmt_g.close();
			int count=0;
			int Present[]=new int[countLot_Id];
			int m=0;
			for(count=0;count<countLot_Id;count++)
			{
				Present[count]=0;
				query="Select * from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=true and  RT.Lot_Id=? and RT.Location_Id=?  and R.company_id="+company_id;

				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setString(1,""+interLot_Id[count]);
				pstmt_g.setString(2,""+Location_Id);
				rs_g=pstmt_g.executeQuery();

				while(rs_g.next())
				{
					Present[count]=1;
//					out.print("<br>yes"+count+"        "+interLot_Id[count]);
					PresentLot_Id[m]=interLot_Id[count];
					LPReceive_CurrencyId[m]=rs_g.getLong("Receive_CurrencyId");
					LPReceive_Quantity[m]=rs_g.getDouble("Receive_Quantity");
					LPReceive_ExchangeRate[m]=rs_g.getDouble("Receive_ExchangeRate");
					LPLocal_Total[m]=rs_g.getDouble("Local_Price");
					LPDollar_Total[m]=rs_g.getDouble("Dollar_Price");
					LPUnit_Id[m]=Long.parseLong(A.getNameCondition(cong,"Lot","Unit_Id","where Lot_Id="+PresentLot_Id[m]));
					
					LPLot_No[m]=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+PresentLot_Id[m]);
					m++;
				}
			}
			
//			out.print("<br> m= "+m);
			int n=0;
			for(count=0;count<countLot_Id;count++)
			{
				if(Present[count]!=1)
				{
					AbsentLot_Id[n]=interLot_Id[count];
					n++;
				}
			}
//			out.print("<br> n= "+n);
			

%>
<html>
		<head>
			<title>Samyak Software- India </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
				<script language=javascript>
				function selectall(name)
				{
				//alert("hi");
					if(name.checked)
					{
					<%for(int chk=0;chk<n;chk++){%>
						document.f1.chk<%=chk%>.checked=true;
					<%}%>
					}
					else{
					<%for(int chk=0;chk<n;chk++){%>
						document.f1.chk<%=chk%>.checked=false;
					<%}%>
					}
				}
				</script>
			</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="UpdateClosingStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
		<td bgcolor=skyblue width='20%'>&nbsp;
		<% if(!(n==0))
			{%>
			<input type=checkbox name=chkselectall value="1" onclick='selectall(this)'> Select All
		<%	}	%>
			</td>

			<td bgcolor=skyblue align=center width='80%'><b>Closing Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></b></td>
		</tr>
		<tr>
			<td colspan=2>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
				<tr bgcolor=#CCFFFF>
					<td width='10%' align=center>Sr.No.</td>
					<td width='15%' align=center>Lot No.</td>
<!-- 					<td width='20%' align=center>Location</td>
 -->					<td width='15%' align=center>Unit of Measurement</td>
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
%>						<td width='10%' align=center>Exchange Rate</td>
			
				</tr>
<%int k=0;%>
			<input type=hidden name=present value="<%=m%>">	
<%
for(k=0;k<m;k++)
	{%>			
				<tr>
					<td width='10%'><%=k+1%></td>
					<td width='15%'><%=LPLot_No[k]%></td>
<!-- 					<td width='20%' align=center><%//=A.getName(cong,"Location",""+Location_Id)%></td>
 -->					<td width='15%' align=left><%=A.getName(cong,"Unit",""+LPUnit_Id[k])%></td>
					<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPReceive_Quantity[k]%></td>
<%					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPLocal_Total[k]* LPReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=LPLocal_Total[k]%></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right OnBlur='return validate(this,3)'><%=LPDollar_Total[k]*LPReceive_Quantity[k]%></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><%=LPDollar_Total[k]%> </td> 
						<% } 
					}%>				
					<td width='10%' align=right><%=str.format(""+LPReceive_ExchangeRate[k],2)%></td>

				</tr>
<%}%>
						<input type=hidden name=absent value="<%=n%>">
<%int c=m;
for(k=0;k<n;k++)
	{%>		
				<tr>
					<td width='10%'><%=++c%><input type=checkbox name=chk<%=k%> value=yes></td>
					<td width='15%'><%=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+AbsentLot_Id[k])%><input type=hidden name=ALot_Id<%=k%> value='<%=AbsentLot_Id[k]%>'></td>

					<input type=hidden name=ALocation_Id<%=k%> value='0'>
					
					<td width='15%' align=left><%=A.getNameCondition(cong,"Master_Unit","Unit_Name","where Unit_Id="+A.getNameCondition(cong,"Lot","Unit_Id","where Lot_ID="+AbsentLot_Id[k]))%><input type=hidden name=AUnit_Id<%=k%> value='<%=A.getNameCondition(cong,"Lot","Unit_Id","where Lot_ID="+AbsentLot_Id[k])%>'></td>
					<td width='15%' align=right OnBlur='return validate(this,3)'><input type=text name=AQuantity<%=k%> value='0.0' style='text-align:right' size=10></td>
<%					String ex_rate=""+I.getLocalExchangeRate(cong,company_id);%>
					<td width='15%' align=right><input type=text name=ARateAmount<%=k%> value='0.0' style='text-align:right' size=10></td>
					<td width='10%' align=right><input type=text name=AExchange_Rate<%=k%> value=<%=str.format(ex_rate,2)%> style='text-align:right' size=8></td>
				</tr>
	<%}%>
			</table>
					</td>
				</tr>
<% if(n>0)
				{%>
				<tr>
					<td align=center colspan=2><input type=submit name=command value="Update" class=button1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
				<tr>
	<%}%>
			</table>
			</form>
			</body>
			</html>
<%	}
C.returnConnection(cong);
					}
}catch(Exception e) { out.print("<br> Samyak Bug 528 ::::<font color= red>"+e+"</font>"); }
	







		
	}//-End of order by Lot_Id----------------------------------------------------------------

}//end order 
//  C.returnConnection(cong);

}
%>








