<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<%try{
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
	//String company_name= A.getName("companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();

	Connection cong=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;

	/*try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }*/

if("Default".equals(command))
{
	String hcommand=request.getParameter("hcommand");		

		 try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }

//	out.print("<br>"+hcommand);
	
%>
		<html>
		<head>
			<title>Samyak Software- India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="OptimumQuantity.jsp" method=post name=f1>
		<input type=hidden name=hcommand value='lotno'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Optimum Quantity</th>
		</tr>
		<tr>
			<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
				<tr>
					<td>Lot No.</td>
					<td><input type=text name=Lot_No size=12 value=1></td>
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
			<title>Samyak Software- India </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="OptimumQuantity.jsp" method=post name=f1>
		<input type=hidden name=hcommand value='location'>
		<input type=hidden name=message value='Default'>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
		<tr>
			<th bgcolor=skyblue>Optimum Quantity</th>
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
					<td colspan=2 align=center><input type=submit name=command value="Next" class=button1> </td>
				</tr>
			</table>
			</td>
		</tr>
		</table>
		</form>
		</body>
		</html>
<%		C.returnConnection(cong);         %>

<%}

if("Next".equals(command))
{



String hcommand=request.getParameter("hcommand");
String query="";
	if("lotno".equals(hcommand))
	{
	 try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }

	String Lot_No=request.getParameter("Lot_No");
//	out.print("<br> Lot_No "+Lot_No);
	
	String Lot_Id=A.getNameCondition(cong,"Lot","Lot_Id","where Lot_No='"+Lot_No+"' and company_id="+company_id);

	query="select count(Lot_Id) as counter from Lot where Lot_No='"+Lot_No+"' and company_id="+company_id;
	pstmt_g=cong.prepareStatement(query);
	try{
	rs_g=pstmt_g.executeQuery();
	}catch(Exception e) {out.print(e); }
	int count=0;
	while(rs_g.next())
	{
		count=rs_g.getInt("counter");
	}
	pstmt_g.close();
//	out.print("<br> count="+count);
	if(count==0)
	{	C.returnConnection(cong);

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
<%
	}
	else
	{
		query="select * from LotLocation where Lot_Id="+Lot_Id;	

		pstmt_g=cong.prepareStatement(query);
		try{
		rs_g=pstmt_g.executeQuery();
		}catch(Exception e) {out.print(e); }
		int i=0;
		while(rs_g.next())
		{
			i++;
		}

		String Location_Id[]=new String[i];
		double Optimum_Quantity[]=new double[i];
		i=0;
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();

		while(rs_g.next())
		{
			Location_Id[i]=rs_g.getString("Location_Id");
//			out.print("<br> Location_Id"+Location_Id[i]);
			Optimum_Quantity[i]=rs_g.getDouble("Optimum_Quantity");
//			out.print("<br> Optimum_Quantity"+Optimum_Quantity[i]);
			i++;
		}
//		out.print("<br> i="+i);
%>
		<html>
		<head>
			<title>Fine Star - Samyak Software </title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="UpdateOptimumQuantity.jsp?" method=post name=mainform>
		<input type=hidden name="hcommand" value="<%=hcommand%>">
		<input type=hidden name="message" value="Default">
		<input type=hidden name="Lot_Id" value="<%=Lot_Id%>">
		<input type=hidden name="counter" value="<%=i%>">

		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='40%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Optimum Quantity for Lot No. <%=Lot_No%></th>
		</tr>
		<tr>
		<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
		<tr>
			<th>Location</td>
			<th>Optimum Quantity</td>
		</tr>

<%		for(int j=0;j<i;j++)
		{%>
		<tr>
			<td><%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_id="+Location_Id[j])%><input type=hidden name="Location_Id<%=j%>" value="<%=Location_Id[j]%>"></td>
			<td><input type=text name="Optimum_Quantity<%=j%>" value='<%=str.mathformat((Optimum_Quantity[j]),3)%>' onblur='validate(this,3)' style="text-align:right"></td>
		</tr>
<%		}%>
		</table>
		</td>
		</tr>
		<tr>
			<td align=center><input type=submit name=command value="Update" class='button1'></td>
		</tr>
		</table>
		</form>
		</body>
		</html>
<%	  C.returnConnection(cong);
  pstmt_g.close();	
	}
}//if "lotno" end here

	if("location".equals(hcommand))
	{
		 try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }

		String Location_Id=request.getParameter("Location_Id");
//		out.print("<br>Location_Id "+Location_Id);

		String fromLot_No=request.getParameter("fromLot_No");
		String toLot_No=request.getParameter("toLot_No");
		
		query="select count(*) as counter from Lot where Lot_No =? and company_id="+company_id;
		pstmt_g=cong.prepareStatement(query);
		pstmt_g.setString(1,fromLot_No);
		rs_g=pstmt_g.executeQuery();
		int count1=0,count2=0;
		while(rs_g.next())
		{
			count1=rs_g.getInt("counter");
		}
		pstmt_g.close();
		pstmt_g=cong.prepareStatement(query);
		pstmt_g.setString(1,toLot_No);
		rs_g=pstmt_g.executeQuery();
		while(rs_g.next())
		{
			count2=rs_g.getInt("counter");
		}

		
		if(count1==0 || count2==0)
		{
//			out.print("<br>One of the Lot nos does not exist");
			pstmt_g.close();
			C.returnConnection(cong);
		response.sendRedirect("OptimumQuantity.jsp?connamd=Default&message=LotAbsent");
		}
		else
		{
		String strfromLot_Id=A.getNameCondition(cong,"Lot","Lot_Id","where Lot_No='"+fromLot_No+"' and company_id="+company_id);

		String strtoLot_Id=A.getNameCondition(cong,"Lot","Lot_Id","where Lot_No='"+toLot_No+"' and company_id="+company_id);

		long fromLot_Id=Long.parseLong(strfromLot_Id);
		
		long toLot_Id=Long.parseLong(strtoLot_Id);
		
		query="select * from lotLocation where Lot_Id between ? and ? and company_id="+company_id+" and Location_id="+Location_Id;
//		out.print("<br>Query= "+query);
		pstmt_g=cong.prepareStatement(query);
		pstmt_g.setString(1,""+fromLot_Id);
		pstmt_g.setString(2,""+toLot_Id);

		rs_g=pstmt_g.executeQuery();
		int i=0;
		while(rs_g.next())
		{
			i++;
		}
//		out.print("<br>i= "+i);
		pstmt_g.close();
		if(i==0)
		{
			C.returnConnection(cong);	response.sendRedirect("OptimumQuantity.jsp?connamd=Default&message=LocationAbsent");

		}
		else
		{
		String Lot_Id[]=new String[i];
		String Optimum_Quantity[]=new String[i];
		i=0;
		pstmt_g=cong.prepareStatement(query);
		pstmt_g.setString(1,""+fromLot_Id);
		pstmt_g.setString(2,""+toLot_Id);

		rs_g=pstmt_g.executeQuery();

		while(rs_g.next())
		{
			Lot_Id[i]=rs_g.getString("Lot_Id");
//			out.print("<br> Lot_Id"+Lot_Id[i]);
			Optimum_Quantity[i]=rs_g.getString("Optimum_Quantity");
//			out.print("<br> Optimum_Quantity"+Optimum_Quantity[i]);
			i++;

		}
%>
		<html>
		<head>
			<title>Samyak Software- India</title>
			<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
			<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
		</head>

		<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
		<form action="UpdateOptimumQuantity.jsp?" method=post name=mainform>
		<input type=hidden name="hcommand" value="<%=hcommand%>">
		<input type=hidden name="message" value="Default">
		<input type=hidden name="Location_Id" value="<%=Location_Id%>">
		<input type=hidden name="counter" value="<%=i%>">

		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='40%'>
		<tr>
			<th bgcolor=skyblue  colspan=7>Optimum Quantity for Location. <%=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id)%></th>
		</tr>
		<tr>
		<td>
			<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
		<tr>
			<th>Lot_No</td>
			<th>Optimum Quantity</td>
		</tr>

<%		for(int j=0;j<i;j++)
		{%>
		<tr>
			<td><%=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+Lot_Id[j])%><input type=hidden name="Lot_Id<%=j%>" value="<%=Lot_Id[j]%>"></td>
			<td><input type=text name="Optimum_Quantity<%=j%>" value='<%=str.format(""+Optimum_Quantity[j],3)%>' onblur='validate(this,3)' style="text-align:right"></td>
		</tr>
<%		}//for%>
		</table>
		</td>
		</tr>
		<tr>
			<td align=center><input type=submit name=command value="Update" class='button1'></td>
		</tr>
		</table>
		</form>
		</body>
		</html>

<%		}//else
		}//outer else

	pstmt_g.close();	
  C.returnConnection(cong);

	}

  }
	
	

	}catch(Exception e) {out.print(e); }
%>








