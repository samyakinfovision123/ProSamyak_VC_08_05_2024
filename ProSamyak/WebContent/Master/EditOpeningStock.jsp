<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

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
	out.print("<br><br> "+message+"</b>");
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
		<form action="EditOpeningStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='lotno'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Opening Stock - Lotwise</th>
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
			<title>Samyak Software -India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="EditOpeningStock.jsp" method=post name=f1>
		<input type=hidden name=lotLocation value='location'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Opening Stock - Locationwise</th>
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
								<!-- <option value='2'>Lot Id -->
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
	//out.print("<br>190  i :"+i);
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
	//out.print("<br>215 Lot_No="+Lot_No);
	//out.print("<br>216 company_id="+company_id);
	//out.print("<br>216 yearend_id="+yearend_id);

	//query="Select * from Receive R, Receive_Transaction RT,Lot L where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and   RT.Lot_Id=L.Lot_Id and L.Lot_No=? and L.company_id=? and R.R_Return=0 and R.yearend_id=?";




		query="Select R.Receive_Id as rid,R.Receive_CurrencyId as recid,R.Receive_ExchangeRate as rexec,R.Receive_Quantity as rqty , RT.ReceiveTransaction_Id as rtid,RT.Location_Id as rtlocid,RT.Local_Price as rtlp,RT.Dollar_Price as rtdp ,L.Lot_Id as lid , L.Unit_Id as lu  from Receive R, Receive_Transaction RT,Lot L where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and   RT.Lot_Id=L.Lot_Id and L.Lot_No=? and L.company_id=? and R.R_Return=0 and R.yearend_id=?";
	
	    //out.print("<br>216 query="+query);

	pstmt_g=cong.prepareStatement(query);
	//out.print("<br>220 query="+query);
	pstmt_g.setString(1,Lot_No);
	pstmt_g.setString(2,company_id);
	pstmt_g.setString(3,yearend_id);

//	out.print("<br>"+query);
	rs_g=pstmt_g.executeQuery();
	//out.print("<br>236 query="+query);
//	out.print(rs_g);
	while(rs_g.next())
	{i++;}
	pstmt_g.close();
//  out.print("<br> 232 i :"+i); 
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
	pstmt_g.setString(3,yearend_id);
//	out.print("<br>"+query);
	rs_g=pstmt_g.executeQuery();
	//out.print(rs_g);

		
	i=0;

	while(rs_g.next())
	{
	  Receive_Id[i]=rs_g.getDouble("rid");
//	 out.print("<br>266 Receive_Id"+i+": "+Receive_Id[i]);
    
	
	PReceive_CurrencyId[i]=rs_g.getLong("recid");
    //      out.print("<br>270 PReceive_CurrencyId"+i+":"+PReceive_CurrencyId[i]);
     
	 
	 PReceive_ExchangeRate[i]=rs_g.getDouble("rexec");
//	out.print("<br>275 PReceive_ExchangeRate"+i+":"+PReceive_ExchangeRate[i]);
	 


	PReceive_Quantity[i]=rs_g.getDouble("rqty");
//	 out.print("<br>279 PReceive_Quantity"+i+":"+PReceive_Quantity[i]);



	 ReceiveTransaction_Id[i]=rs_g.getDouble("rtid");
	//out.print("<br>284ReceiveTransaction_Id"+i+": "+ReceiveTransaction_Id[i]);

	 
		PLocation_Id[i]=rs_g.getLong("rtlocid");
		//out.print("<br>288 PLocation_Id"+i+":"+PLocation_Id[i]);


	PLocal_Total[i]=rs_g.getDouble("rtlp");
	//out.print("<br>292 PLocal_Total"+i+":"+PLocal_Total[i]);

		PDollar_Total[i]=rs_g.getDouble("rtdp");
		//out.print("<br>285 PDollar_Total"+i+":"+PDollar_Total[i]);
//		out.print("<br>Receive_Id"+i+":"+Receive_Id[i]);
		


		Lot_Id[i]= rs_g.getInt("lid");
		//out.print("<br>302 Lot_Id"+i+":"+Lot_Id[i]);

		
		

		
	
		
		
		PUnit_Id[i]=rs_g.getLong("lu");
		//out.print("<br>311 lu"+i+":"+PUnit_Id[i]);
		
		
		i++;
	}
	//out.print("<br>316 i="+i);
	pstmt_g.close();
	


	
%>	
    	
	<html>
		<head>
			<title> Samyak Software </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="Update_EditOpeningStock.jsp" method=post name=f1>
	<input type=hidden name="lotLocation" value="<%=lotLocation%>">
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="Lot_No" value="<%=Lot_No%>">
	<input type=hidden name="locationAbsent" value="<%//=locationAbsent%>">

	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Opening Stock for Lot No. <%=Lot_No%></th>
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
					<td width='15%' align=right><input type=text name=quantity<%=k%> value="<%=str.mathformat(PReceive_Quantity[k],3)%>" style="text-align:right" onblur="validate(this,3)"><input type=hidden name=old_quantity<%=k%> value="<%=PReceive_Quantity[k]%>"></td>

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
					<tr><td colspan=6 align=center><b><font class=msgred>There is no Opening Stock Present  for Selected Lot and Location</font><b></td></tr>

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
		
<%		//response.sendRedirect("OpeningStock.jsp?command=Default&message=<center><font color=blue>Lot No. </font><font color=red>"+fromLot_No+"</font><font color=blue> or </font><font color=red>"+toLot_No+"</font><font color=blue> does not exist</font>" );
			
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
				try{
				query="Select R.Receive_Id as rid,R.Receive_CurrencyId as recid,R.Receive_ExchangeRate as rexec,R.Receive_Quantity as rqty,RT.ReceiveTransaction_Id as rtid,RT.Local_Price as rtlp,RT.Dollar_Price as rtdp from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and  RT.Lot_Id=? and RT.Location_Id=? and R.R_Return=0 and R.yearend_id=? and R.company_id="+company_id;

				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setString(1,""+interLot_Id[count]);
				pstmt_g.setString(2,""+Location_Id);
				pstmt_g.setString(3,""+yearend_id);
				rs_g=pstmt_g.executeQuery();
				//out.print("**"+count);
				while(rs_g.next())
				{
					Present[count]=1;
//					out.print("<br>yes"+count+"        "+interLot_Id[count]);
			PresentLot_Id[m]=interLot_Id[count];

			Receive_Id[m]=rs_g.getDouble("rid");
			
			LPReceive_CurrencyId[m]=rs_g.getLong("recid");
				
			LPReceive_ExchangeRate[m]=rs_g.getDouble("rexec");
				
			
					
			LPReceive_Quantity[m]=rs_g.getDouble("rqty");		
		ReceiveTransaction_Id[m]=rs_g.getDouble("rtid");
		
		LPLocal_Total[m]=rs_g.getDouble("rtlp");
					
		LPDollar_Total[m]=rs_g.getDouble("rtdp");			
					
					
					//	out.print("<br>ReceiveTransaction_Id"+m+ReceiveTransaction_Id[m]);

					//Receive_Id[m]=rs_g.getDouble("Receive_Id");
	//out.print("<br>Receive_Id"+m+Receive_Id[m]);

					//LPReceive_CurrencyId[m]=rs_g.getLong("Receive_CurrencyId");
					
						
					
					LPUnit_Id[m]=Long.parseLong(A.getNameCondition(cong,"Lot","Unit_Id","where Lot_Id="+PresentLot_Id[m]));
					
					LPLot_No[m]=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+PresentLot_Id[m]);
					m++;
				
				
				
				
				}
				}catch(Exception e){

              out.print("<br><font color=#0000FF>652 Exception is=</font> "+e);
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
	<form action="Update_EditOpeningStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Opening Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></th>
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
					<td align=center><b><font class=msgred>There is no Opening Stock for Selected Lot and Location</font></b></td>
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
	out.print("<br>795  Location_Id "+Location_Id);

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
		
<%		//response.sendRedirect("OpeningStock.jsp?command=Default&message=<center><font color=blue>Lot No. </font><font color=red>"+fromLot_No+"</font><font color=blue> or </font><font color=red>"+toLot_No+"</font><font color=blue> does not exist</font>" );
			
		}
			

		else
		{
 
		out.print("<br>842 query==>"+query);
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
			out.print("<br>885 ");
			for(count=0;count<countLot_Id;count++)
			{
				Present[count]=0;

//R.Receive_Id as rid,RT.ReceiveTransaction_Id as rtid,

				query="Select R.Receive_CurrencyId as recid,R.Receive_ExchangeRate as rexec,R.Receive_Quantity as rqty,RT.Local_Price as rtlp,RT.Dollar_Price as rtdp from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and  RT.Lot_Id=? and RT.Location_Id=? and R.R_Return=0 and R.yearend_id=? and R.company_id="+company_id;

				//query="Select * from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and  RT.Lot_Id=? and RT.Location_Id=? and R.R_Return=0 and R.yearend_id = ? and R.company_id="+company_id;

				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setString(1,""+interLot_Id[count]);
				pstmt_g.setString(2,""+Location_Id);
				pstmt_g.setString(3,""+yearend_id);
				rs_g=pstmt_g.executeQuery();

				while(rs_g.next())
				{
					Present[count]=1;
//					out.print("<br>yes"+count+"        "+interLot_Id[count]);
			PresentLot_Id[m]=interLot_Id[count];

			//Receive_Id[m]=rs_g.getDouble("rid");
			
			LPReceive_CurrencyId[m]=rs_g.getLong("recid");
				
			LPReceive_ExchangeRate[m]=rs_g.getDouble("rexec");
				
			
					
			LPReceive_Quantity[m]=rs_g.getDouble("rqty");		
		//ReceiveTransaction_Id[m]=rs_g.getDouble("rtid");
		
		LPLocal_Total[m]=rs_g.getDouble("rtlp");
					
		LPDollar_Total[m]=rs_g.getDouble("rtdp");			
					
					
//	out.print("<br>ReceiveTransaction_Id"+m+ReceiveTransaction_Id[m]);

					//Receive_Id[m]=rs_g.getDouble("Receive_Id");
	//out.print("<br>Receive_Id"+m+Receive_Id[m]);

					//LPReceive_CurrencyId[m]=rs_g.getLong("Receive_CurrencyId");
					
						
					
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
	<form action="Update_EditOpeningStock.jsp" method=post name=f1>
	
	<input type=hidden name="lotLocation" value="location">
	<input type=hidden name="Location_Id" value=<%=Location_Id%>>
	<input type=hidden name="rateAmount" value="<%=rateAmount%>">
	<input type=hidden name="Currency" value="<%=Currency%>">
	<input type=hidden name="message" value="Default">


	<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='90%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Opening Stock for <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></th>
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
					<td align=center><b><font class=msgred>There is no Opening Stock for Selected Lot and Location</font></b></td>
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
out.println("<font color=red> FileName : EditopeningStock.jsp <br>Bug No Samyak418 :"+ Samyak418 +"</font>");}



}//end next if

%>






