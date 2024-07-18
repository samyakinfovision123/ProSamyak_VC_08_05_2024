<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<jsp:useBean id="GD" class="NipponBean.GetDate" />

<%
	Connection cong=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;

 	try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); } 

	String command=request.getParameter("command"); 
//	out.print("<br> 17 command "+command);
	
	String message=request.getParameter("message"); 
	
	if(!("Default".equals(message)))
	{
	out.print("<br><b> "+message+"</b>");
	}

	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	String company_name= A.getName(cong,"companyparty",company_id);
	String local_currency= I.getLocalCurrency(cong,company_id);
	

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();



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
		<form action="EditClosingStock.jsp" method=post name=f1>
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
				<input type=hidden name=Currency value="local">
				<input type=hidden name=rateAmount value=rate>
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

	

		<!--
		<html>
		<head>
			<title>Samyak Software -India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="EditClosingStock.jsp" method=post name=f1>
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
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1> </td>
				</tr>
			</table>
			</td>
		</tr>
		</table>
		</form>
		</body>
		</html>
-->
<%

C.returnConnection(cong);

}
%>


<%
if("Next".equals(command))
{
	
try{
	String query="";
	int i=0;
 //   out.print("<br> 159 Inside next");
	String lotLocation=request.getParameter("lotLocation");		
//	out.print("<br> lotLocation "+lotLocation);
	
	String rateAmount=request.getParameter("rateAmount");		
//	out.print("<br> rateAmount "+rateAmount);

	String Currency=request.getParameter("Currency");		
//	out.print("<br> Currency "+Currency);
//********************************LOT_NO IF START HERE *****************************
//    out.print("169 lotno"+lotno);
   // out.print("<br> 169 lotLocation :"+lotLocation);
	
	if("lotno".equals(lotLocation))
	{
 //out.print("<br> 174 Inside if");
 	String Lot_No=request.getParameter("Lot_No");
//	out.print("<br> Lot_No "+Lot_No);
	
	query="select count(Lot_Id) as LotCount from Lot where Lot_No=? and company_id="+company_id;
	pstmt_g=cong.prepareStatement(query);
	pstmt_g.setString(1,Lot_No);
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	while(rs_g.next())
	{
	i=rs_g.getInt("LotCount");
//		out.print("<br> i==>"+i);
	}
	pstmt_g.close();
//	out.print("<br> i :"+i);
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
			<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
		</body>
		</html> 

<%	}
	else
	{
    
	i=0;
//    out.print("<br> Inside else");
	query="Select * from Receive R, Receive_Transaction RT,Lot L where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and   RT.Lot_Id=L.Lot_Id and L.Lot_No=? and L.company_id=? and R.R_Return=1 and R.yearend_id="+yearend_id;
	
	pstmt_g=cong.prepareStatement(query);
	
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);

//	out.print("<br>"+query);
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);
	while(rs_g.next())
	{i++;}
	pstmt_g.close();
  //  out.print("<br> 227 i :"+i); 
	int locationPresent=i;

	double ReceiveTransaction_Id[]=new double[locationPresent];
	double Receive_Id[]=new double[locationPresent];
	int  Lot_Id[]=new int[locationPresent];

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
	rs_g=pstmt_g.executeQuery();
//	out.print(rs_g);

		
	i=0;

	while(rs_g.next())
	{
		ReceiveTransaction_Id[i]=rs_g.getDouble("ReceiveTransaction_Id");
//		out.print("<br>ReceiveTransaction_Id"+i+": "+ReceiveTransaction_Id[i]);

		Receive_Id[i]=rs_g.getDouble("Receive_Id");
//		out.print("<br>Receive_Id"+i+":"+Receive_Id[i]);
		
		Lot_Id[i]= rs_g.getInt("Lot_Id");
//		out.print("<br>Lot_Id"+i+":"+Lot_Id[i]);
		PLocation_Id[i]=rs_g.getLong("Location_Id");
		PReceive_CurrencyId[i]=rs_g.getLong("Receive_CurrencyId");
		PReceive_Quantity[i]=rs_g.getDouble("Receive_Quantity");
		
		PReceive_ExchangeRate[i]=rs_g.getDouble("Receive_ExchangeRate");
		PLocal_Total[i]=rs_g.getDouble("Local_Price");
		PDollar_Total[i]=rs_g.getDouble("Dollar_Price");
		PUnit_Id[i]=rs_g.getLong("Unit_Id");
		i++;
	}
	
	pstmt_g.close();
	


	
%>	
    	
	<html>
		<head>
			<title> Samyak Software </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="Update_EditClosingStock.jsp" method=post name=f1>
	<input type=hidden name="lotLocation" value="<%=lotLocation%>">
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="Lot_No" value="<%=Lot_No%>">
	<input type=hidden name="locationAbsent" value="<%//=locationAbsent%>">

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

			<input type=hidden name=present value='<%=locationPresent%>' >

			
	<!-- 	<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
 -->

<%	int k=0;
	for(k=0;k<locationPresent;k++)
	{%>
		<input type=hidden name=Location_Id<%=k%> value='<%=PLocation_Id[k]%>' >
		<input type=hidden name=Receive_Id<%=k%> value='<%=Receive_Id[k]%>' >
		<input type=hidden name=ReceiveTransaction_Id<%=k%> value='<%=ReceiveTransaction_Id[k]%>' >
		<input type=hidden name=lot_id<%=k%> value='<%=Lot_Id[k]%>' >

				<tr>
					<td width='10%'><%=k+1%></td>
<!-- 					<td width='15%'><%=Lot_No%></td>
 -->					<td width='20%' align=center><%=A.getName(cong,"Location",""+PLocation_Id[k])%></td>
					<td width='15%' align=center><%=A.getName(cong,"Unit",""+PUnit_Id[k])%></td>
					<td width='15%' align=right>
					<!-- Hidden next opening yearend id -->
					<!-- Hidden next opening receive id -->	
					<%

					//A.getNameCondition(conp,"YearEnd",yearend_id, "");
					//int nextyearend_id = 2;



					//Start : dynamically getting nextyearend_id
					String Fyear = YED.returnCurrentFinancialYear(cong , pstmt_g, rs_g, yearend_id, company_id);
					
					StringTokenizer splityear = new StringTokenizer(Fyear,"#");
					String tempFromDate = (String)splityear.nextElement();
					String tempToDate = (String)splityear.nextElement();

					StringTokenizer enddate = new StringTokenizer(tempToDate,"-");
					int counter=enddate.countTokens();

					int endyear=Integer.parseInt((String)enddate.nextElement());
					int endmonth=Integer.parseInt((String)enddate.nextElement());
					String endday= (String)enddate.nextElement();
					StringTokenizer splitendday = new StringTokenizer(endday," ");
					int splittedendday = Integer.parseInt((String)splitendday.nextElement());

					//created new dates for next financial year from the current year end date
					java.sql.Date newFinancialYearStart = new java.sql.Date( endyear-1900, endmonth-1, splittedendday+1);
					java.sql.Date newFinancialYearEnd = new java.sql.Date( endyear+1-1900 , endmonth-1, splittedendday);


					String ys = GD.format(newFinancialYearStart);
					String yd = GD.format(newFinancialYearEnd);

					
					query = "Select yearend_id from YearEnd where From_Date=? and To_Date=? and Company_Id=?";
				
					pstmt_g = cong.prepareStatement(query);
					pstmt_g.setString(1,""+newFinancialYearStart);
					pstmt_g.setString(2,""+newFinancialYearEnd);
					pstmt_g.setString(3,company_id);
					rs_g = pstmt_g.executeQuery();

					rs_g.next();

					String nextyearend_id = rs_g.getString("yearend_id");

					//End : dynamically getting nextyearend_id



					query="Select * from Receive R , Receive_Transaction RT , Lot L where R.Receive_id = RT.Receive_Id and  R.Opening_Stock=1 and   RT.Lot_Id = L.Lot_Id and L.Lot_No=? and L.company_id=? and R.R_Return=0 and RT.Location_Id = "+PLocation_Id[k]+" and R.yearend_id ="+nextyearend_id;
					//out.print("<BR>"+query);
					pstmt_g=cong.prepareStatement(query);
					
					pstmt_g.setString(1,Lot_No);
					pstmt_g.setString(2,company_id);

				//	out.print("<br>"+query);
					rs_g=pstmt_g.executeQuery();
				    //out.print(rs_g);
					String nextOpeningR_Id="";
					String nextOpeningRT_Id="";
					while(rs_g.next())
					{
						nextOpeningR_Id = rs_g.getString("Receive_Id");
						nextOpeningRT_Id = rs_g.getString("ReceiveTransaction_Id");

					}
					pstmt_g.close();
					//  out.print("<br> 227 i :"+i); 
					locationPresent=i;

					%>
					<!-- Hidden next opening receive transaction id -->	

					<%=str.mathformat(PReceive_Quantity[k],3)%>
					
					<input type=hidden name=nextOpeningR_Id<%=k%> value=<%=nextOpeningR_Id%>>

					<input type=hidden name=nextOpeningRT_Id<%=k%> value=<%=nextOpeningRT_Id%>>

					
					<input type=hidden name=quantity<%=k%> value="<%=str.mathformat(PReceive_Quantity[k],3)%>" style="text-align:right" onblur="validate(this,3)"><input type=hidden name=old_quantity<%=k%> value="<%=PReceive_Quantity[k]%>"></td>

<%					
			int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right><input type=text value='<%=str.mathformat(""+(PLocal_Total[k] *PReceive_Quantity[k]),d)%>'  name=localaomunt<%=k%> style="text-align:right" onblur="validate(this,<%=d%>)"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name=localrate<%=k%> value='<%=str.mathformat(PLocal_Total[k],15)%>' style="text-align:right" onblur="validate(this,15)"></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right><input type=text name=dolleramount<%=k%> value='<%=str.mathformat((PDollar_Total[k] * PReceive_Quantity[k]),2)%>' style="text-align:right" onblur="validate(this,2)"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name=dollerrate<%=k%> value='<%=str.mathformat(PDollar_Total[k],15)%>' style="text-align:right" onblur="validate(this,15)"></td> 
						<% } 
					}%>	
					<td width='10%' align=right><input type=text name=ExchangRate<%=k%> value='<%=str.format(PReceive_ExchangeRate[k],2)%>' style="text-align:right" onblur="validate(this,2)"></td>
				</tr>
<%}
					
				if(locationPresent!=0)
				{%>

					<tr><td colspan=6 align=center><input type=submit name=command value="Update" class=button1></td></tr>
					<%}
				else
				{%>
					<tr><td colspan=6 align=center><b><font class=msgred>There is no Closing Stock Present  for Selected Lot and Location</font><b></td></tr>

					<tr><td colspan=6 align=center><input type=button name=command value="Back" class=button1 onclick="history.back(1)"></td></tr>
<%				}

 }//else


  }//end lot no if
//***************************************************************************

	if("location".equals(lotLocation))
	{

String order=request.getParameter("order");
 	// out.print("<br>order "+order);
	if("1".equals(order))
	{

 	String Location_Id=request.getParameter("Location_Id");
//	out.print("<br> Location_Id "+Location_Id);

	String fromLot_No=request.getParameter("fromLot_No");
	//out.print("<br> fromLot_No "+fromLot_No);

	String toLot_No=request.getParameter("toLot_No");
	//out.print("<br> toLot_No "+toLot_No);
	

	String fromLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+fromLot_No+"'" );
	
//	out.print("<br> fromLot_Id "+fromLot_Id);

	String toLot_Id= A.getNameCondition(cong,"Lot","Lot_id","Where company_id="+company_id+" and Lot_no='"+toLot_No+"'" );

//	out.print("<br> toLot_Id "+toLot_Id);
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
			
		}//else
			
		else
		{
 	
			query="select * from Lot order by lot_no";
			pstmt_g=cong.prepareStatement(query);
//			out.print(query);

			
			rs_g=pstmt_g.executeQuery();
			

			int  countLot_Id=0;
			int from=0;
			int to=0;

			String  Lot_No="";
				// out.print("<br>fromLot_No"+fromLot_No);
			
			while(rs_g.next())
			{
				Lot_No=rs_g.getString("Lot_No");
				 //out.print("<br>Lot_No"+Lot_No);
				
				if(Lot_No.equals(fromLot_No))
				{
				from=countLot_Id;
				}
				
				if(Lot_No.equals(toLot_No))
				{
				to=countLot_Id;
				}
			countLot_Id++;	

			}
			pstmt_g.close();
			to++;				

						//out.print("<br>from"+from);
					//	out.print("<br>to"+to);
		countLot_Id=to-from;
			
			 //out.print("<br>countLot_Id "+countLot_Id);
			
			
			double ReceiveTransaction_Id[]=new double[countLot_Id];
			double Receive_Id[]=new double[countLot_Id];
			//double Location_Id[]=new double[countLot_Id];

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

				if(Lot_No.equals(fromLot_No))
				{

				
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
				query="Select * from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and  RT.Lot_Id=? and RT.Location_Id=?  and R.company_id="+company_id;

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

					ReceiveTransaction_Id[m]=rs_g.getDouble("ReceiveTransaction_Id");
					//	out.print("<br>ReceiveTransaction_Id"+m+ReceiveTransaction_Id[m]);

					Receive_Id[m]=rs_g.getDouble("Receive_Id");
	//out.print("<br>Receive_Id"+m+Receive_Id[m]);

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
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="Update_EditClosingStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Closing Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></th>
		</tr>
		<tr>
			<td>
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
		<input type=hidden name=Location_Id<%=k%> value='<%=Location_Id%>' >
		<input type=hidden name=Receive_Id<%=k%> value='<%=Receive_Id[k]%>' >
		<input type=hidden name=ReceiveTransaction_Id<%=k%> value='<%=ReceiveTransaction_Id[k]%>' >
					<td width='10%'><%=k+1%></td>
					<td width='15%'><%=LPLot_No[k]%></td>
					<input type=hidden name=lot_id<%=k%> value='<%=interLot_Id[k]%>' >
<!-- 					<td width='20%' align=center><%//=A.getName("Location",""+Location_Id)%></td>
 -->					<td width='15%' align=left><%=A.getName(cong,"Unit",""+LPUnit_Id[k])%></td>
					<td width='15%' align=right><input type=text name=quantity<%=k%> value='<%=LPReceive_Quantity[k]%>' style="text-align:right" onblur="validate(this,3)"><input type=hidden name=old_quantity<%=k%> value="<%=LPReceive_Quantity[k]%>"></td>
<%					
	 
	 			int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
 
					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right><input type=text value='<%=str.mathformat(""+(LPLocal_Total[k]* LPReceive_Quantity[k]),d)%>' name=localaomunt<%=k%>  style="text-align:right" onblur="validate(this,<%=d%>)"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right>
							<input type=text name=localrate<%=k%> value='<%=str.mathformat(LPLocal_Total[k],15)%>'  style="text-align:right" onblur="validate(this,15)"></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right><input type=text name=dolleramount<%=k%> value='<%=str.mathformat((LPDollar_Total[k]*LPReceive_Quantity[k]),2)%>'  style="text-align:right" onblur="validate(this,2)"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name=dollerrate<%=k%> value='<%=str.mathformat(LPDollar_Total[k],15)%>' style="text-align:right" onblur="validate(this,15)"> </td> 
						<% } 
					}%>				
					<td width='10%' align=right><input type=text name=ExchangRate<%=k%> value='<%=str.format(""+LPReceive_ExchangeRate[k],2)%>' style="text-align:right" onblur="validate(this,2)"></td>

				</tr>
<%}%>
<%//************************************************************************%>
	
<%
 	//************************************************************************%>
			</table>
					</td>
				</tr>
<%		if(m!=0)
			{%>
				<tr>
					<td align=center><input type=submit name=command value="Update" class=button1></td>
				<tr>
		<%	} 
		else
			{
			%>
				<tr>
					<td align=center><b><font class=msgred>There is no Closing Stock for Selected Lot and Location</font></b></td>
				<tr>
				<tr>
					<td align=center><input type=button name=command value="Back" class=button1 onclick="history.back(1)"></td>
				<tr>
		<%	} %>
			</table>
			</form>
			</body>
			</html>
<%	
		}
	}// order by lot no
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
				query="Select * from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and  RT.Lot_Id=? and RT.Location_Id=?  and R.company_id="+company_id;

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
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="Update_EditClosingStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Closing Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></th>
		</tr>
		<tr>
			<td>
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
					<td width='15%' align=center><%=LPLot_No[k]%></td>
					<input type=hidden name=lot_id<%=k%> value='<%=interLot_Id[k]%>' >

<!-- 					<td width='20%' align=center><%//=A.getName("Location",""+Location_Id)%></td>
 -->					<td width='15%' align=left><%=A.getName(cong,"Unit",""+LPUnit_Id[k])%></td>
					<td width='15%' align=right><input type=text name=quantity<%=k%> value='<%=LPReceive_Quantity[k]%>' onblur="validate(this,3)"  style="text-align:right"><input type=hidden name=old_quantity<%=k%> value="<%=LPReceive_Quantity[k]%>"></td>
<%					
	 			int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

					if("local".equals(Currency))
					{
						if("amount".equals(rateAmount))
						{%>
						<td width='15%' align=right><input type=text value='<%=str.mathformat((LPLocal_Total[k]* LPReceive_Quantity[k]),d)%>' name=localaomunt<%=k%>  onblur="validate(this,<%=d%>)" style="text-align:right"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name=localrate<%=k%> value='<%=str.mathformat(LPLocal_Total[k],15)%>'  onblur="validate(this,15)" style="text-align:right"></td> 
						<% } 
					}
					else
					{
						if("amount".equals(rateAmount))
						{%>
							<td width='15%' align=right> <input type=text name=dolleramount<%=k%> value='<%=str.mathformat((LPDollar_Total[k]*LPReceive_Quantity[k]),2)%>' onblur="validate(this,2)"  style="text-align:right"></td>
<%						}
						else 
						{%> 
							<td width='15%' align=right><input type=text name=dollerrate<%=k%> value='<%=str.mathformat(LPDollar_Total[k],15)%>' onblur="validate(this,15)" style="text-align:right" > </td> 
						<% } 
					}%>				
					<td width='10%' align=right><input type=text name=ExchangRate<%=k%> value='<%=str.format(LPReceive_ExchangeRate[k],2)%>' style="text-align:right" onblur="validate(this,2)"></td>

				</tr>
<%}%>
						<input type=hidden name=absent value="<%=n%>">

			<%//**********************************************************************%>	
			
			<%//**********************************************************************
 			%>
	
	</table>
					</td>
				</tr>

<%		if(m!=0)
			{%>
				<tr>
					<td align=center><input type=submit name=command value="Update" class=button1></td>
				<tr>
		<%	} 
		else
			{
			%>
				<tr>
					<td align=center><b><font class=msgred>There is no Closing Stock for Selected Lot and Location</font></b></td>
				<tr>
				<tr>
					<td align=center><input type=button name=command value="Back" class=button1 onclick="history.back(1)"></td>
				<tr>
		<%	} %>
			</table>
			</form>
			</body>
			</html>
<%	}
	







		
	}//-End of order by Lot_Id-----------------------------------------------------------

}//end of secound window i.e. lotcoation =location


//**********************************************************************************



C.returnConnection(cong);



}catch(Exception Samyak418){ 
out.println("<font color=red> FileName : EditCLosingStock.jsp <br>Bug No Samyak418 :"+ Samyak418 +"</font>");}



}//end next if

%>






