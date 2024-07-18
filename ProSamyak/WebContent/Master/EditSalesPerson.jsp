<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<%

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	
try
{
	conp=C.getConnection();

	int scount=0;
	int bcount=0;
	int pcount=0;

	int Purcount=0;
	int Salecount=0;
	int Brokercount=0;


	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String company_id= ""+session.getValue("company_id");
	String machine_name=request.getRemoteHost();
	String local_symbol= I.getLocalSymbol(conp,company_id);
	String local_currency= I.getLocalCurrency(conp,company_id);
	
	int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

	String command = request.getParameter("command");
	//out.println(command);

	String message = request.getParameter("message"); 
	String message1 = request.getParameter("message1"); 
	
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
	
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	
	if (itoday_day < 10)
	{
		stoday_day="0"+itoday_day;
	}
	
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
%>
<html>
<head>
<title>Samyak Software</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<script>
var errfound = false;
function LocalValidate()
{
	errfound = false;
	if(document.mainform.salesperson_name.value == "")
	{
		alert("Please enter Person name.");
		document.mainform.salesperson_name.select();
		return errfound;
	}
	else 
	{
			var tempA=document.mainform.salesperson_name.value;
			if(tempA.length < 4)
			{
			alert("Please enter Person name Properly. Must be more than three characters");
			document.mainform.salesperson_name.select();
			return errfound;
			}
			else
			{
				return !errfound;
			}
		}// else 
}//validate
</script>

<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<!--  Company selection form -->
<form action="EditSalesPerson.jsp" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>

<%
if("edit".equals(command))
{
	String view = request.getParameter("view"); 
		
	if("Sale".equals(message))
	{
		if(message1 == null)
		{}
		else
		{
			out.println("<center><font class='submit1'> "+message1+"</font></center>");
		}

	String query12 = "select count(*) as counter from Master_SalesPerson where PurchaseSale=0 and company_id="+company_id;
	
	pstmt_p  = conp.prepareStatement(query12);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		scount = rs_g.getInt("counter");
	}
	pstmt_p.close();

	String  salesperson_name[] = new String[scount];
	int salesperson_id[] = new int[scount];

	if("yes".equals(view))
	{
		query12 = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=0 and Active=1 and company_id="+company_id+" order by SalesPerson_name";
	}
	else
	{
		query12 = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=0 and company_id="+company_id+" order by SalesPerson_name";
	}
		
	pstmt_p  = conp.prepareStatement(query12);
	rs_g = pstmt_p.executeQuery();
	int p=0;
	while(rs_g.next())
	{
		salesperson_name[p] =rs_g.getString("SalesPerson_Name");
		salesperson_id[p] =Integer.parseInt(rs_g.getString("salesperson_id"));
	//	out.print("<br> 146 salesperson_id["+p+"] = "+salesperson_id[p]);
		p++;
	}
	pstmt_p.close();

%>

<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Sales Person Name </th>
</tr>
<tr>
		<th> Sr.No </th>
		<th> Sales Person Name </th>
</tr>
		
<%
	for(int n=0;n<scount; n++)
	{
		
		String saleActquery = "select count(*) as counter from Receive where company_id="+company_id+" and salesperson_id ="+salesperson_id[n];

		pstmt_p  = conp.prepareStatement(saleActquery);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{
			Salecount = rs_g.getInt("counter");
		//	out.print(" <br> 178 Salecount = "+Salecount);
		}
		pstmt_p.close();
		
		
		
		
		if(null==salesperson_name[n])
		{}
		else
		{
%>
<tr>
	<td><%=n+1%></td>
<%
	if("yes".equals(view))
	{
%>
	<td><%=salesperson_name[n]%></td>
<%
	}
	else
	{
%>
	<td><a href="../Master/EditSalesPerson.jsp?command=SELECT&salesperson_id=<%=salesperson_id[n]%>&message=Sale&idcount=<%=scount%>&Salecount=<%=Salecount%>"><%=salesperson_name[n]%></a>
	<input type=hidden name=spid<%=n%> value="<%=salesperson_id[n]%>">
	</td>
<% 
	}
%>
</tr>
<%
	}//else null
}//for loop
%>
<input type=hidden name=message value="Sale"> 
</table>
<%
	}
//}
%>

<%
if("Purchase".equals(message))
{
	String purchaseview = request.getParameter("Purchaseview");
		
	if(message1 == null)
	{}
	else
	{
		out.println("<center><font class='submit1'> "+message1+"</font></center>");
	}


	String Purquery = "select count(*) as counter from Master_SalesPerson where PurchaseSale=1 and company_id="+company_id;
	
	pstmt_p  = conp.prepareStatement(Purquery);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		pcount = rs_g.getInt("counter");
	}
	pstmt_p.close();

	String  Purchaseperson_name[] = new String[pcount];
	int Purchaseperson_id[] = new int[pcount];

	if("yes".equals(purchaseview))
	{
	
		Purquery = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=1 and Active=1 and company_id="+company_id+" order by SalesPerson_name";
	}
	else
	{
		Purquery = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=1 and company_id="+company_id+" order by SalesPerson_name";
	}

	pstmt_p  = conp.prepareStatement(Purquery);
	rs_g = pstmt_p.executeQuery();
	int s=0;
	while(rs_g.next())
	{
		Purchaseperson_name[s] =rs_g.getString("SalesPerson_Name");
		Purchaseperson_id[s] =Integer.parseInt(rs_g.getString("salesperson_id"));
		//out.print("<br> 244 Purchaseperson_id["+s+"] = "+Purchaseperson_id[s]);
	s++;
	}
	pstmt_p.close();

%>

<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Purchase Person Name </th>
</tr>

<tr>
		<th> Sr.No </th>
		<th> Purchase Person Name </th>
</tr>

<%
	for(int a=0;a<pcount; a++)
	{

		String PurActquery = "select count(*) as counter from Receive where company_id="+company_id+" and salesperson_id ="+Purchaseperson_id[a];

		pstmt_p  = conp.prepareStatement(PurActquery);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{
			Purcount = rs_g.getInt("counter");
			//out.print(" <br> 272 Purcount = "+Purcount);
		}
		pstmt_p.close();


		if(null==Purchaseperson_name[a])
		{}
		else
		{
%>
		<tr>
			<td><%=a+1%></td>
<%
		if("yes".equals(purchaseview))
		{
%>
			<td><%=Purchaseperson_name[a]%></td>
<%
		}
		else
		{
%>
	<td><a href="../Master/EditSalesPerson.jsp?command=SELECT&salesperson_id=<%=Purchaseperson_id[a]%>&message=Purchase&idcount=<%=pcount%>&Purcount=<%=Purcount%>"><%=Purchaseperson_name[a]%> </a></td>
	<input type=hidden name=spid<%=a%> value="<%=Purchaseperson_id[a]%>">
<% 
	}
%>
</tr>
<%
	}
	}
%>


<input type=hidden name=message value="Purchase"> 
</table>
<%
}

if("Broker".equals(message))
{
	String brokerview = request.getParameter("brokerview"); 

	if(message1 == null)
	{
	}else
	{
		out.println("<center><font class='submit1'> "+message1+"</font></center>");
	}

	String Broquery = "select count(*) as counter from Master_SalesPerson where PurchaseSale=2 and company_id="+company_id;
	
	pstmt_p  = conp.prepareStatement(Broquery);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		bcount = rs_g.getInt("counter");
	}
	pstmt_p.close();

	String  Brokerperson_name[] = new String[bcount];
	int brokerperson_id[] = new int[bcount];

	if("yes".equals(brokerview))
	{
		Broquery = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=2 and Active=1 and company_id="+company_id+" order by SalesPerson_name";
	}
	else
	{
		Broquery = "select SalesPerson_name,salesperson_id from Master_SalesPerson where PurchaseSale=2 and company_id="+company_id+" order by SalesPerson_name";
	}
	
	pstmt_p  = conp.prepareStatement(Broquery);
	rs_g = pstmt_p.executeQuery();
	int q=0;
	while(rs_g.next())
	{
		Brokerperson_name[q] =rs_g.getString("SalesPerson_Name");
		brokerperson_id[q] =Integer.parseInt(rs_g.getString("salesperson_id"));
	q++;
	}
	pstmt_p.close();
%>

<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<tr>
	<th colspan=2 bgcolor="skyblue">Select Broker Person Name </th>
</tr>

<tr>
		<th> Sr.No </th>
		<th> Broker Person Name </th>
</tr>



<%
	for(int m=0;m<bcount; m++)
	{
		String BrokerActquery = "select count(*) as counter from Receive where company_id="+company_id+" and Broker_id ="+brokerperson_id[m];

		pstmt_p  = conp.prepareStatement(BrokerActquery);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{
			Brokercount = rs_g.getInt("counter");
		}
		pstmt_p.close();
	
		if(null==Brokerperson_name[m])
		{}
		else
		{
%>
<tr>
	<td><%=m+1%></td>
<%
	if("yes".equals(brokerview))
	{
%>
	<td><%=Brokerperson_name[m]%></td>
<%
	}
	else
	{
%>
	<td><a href="../Master/EditSalesPerson.jsp?command=SELECT&salesperson_id=<%=brokerperson_id[m]%>&message=Broker&idcount=<%=bcount%>&Brokercount=<%=Brokercount%>"><%=Brokerperson_name[m]%></a>
	<input type=hidden name=spid<%=m%> value="<%=brokerperson_id[m]%>">
	</td>
<% 
	}
%>
</tr>
<%
	}	
}
%>

<input type=hidden name=message value="Broker"> 
</table>
<%
		}
}
%>
</td>
</tr>
</table>
</form>


<%
	if("SELECT".equals(command))
	{
		String salesperson_id = request.getParameter("salesperson_id");
		//	out.println(salesperson_id);
		
		message=request.getParameter("message");
		//out.print("<br>179 message="+message);
	
		String query = "select * from Master_SalesPerson where SalesPerson_Id=?";
		pstmt_p  = conp.prepareStatement(query);
		pstmt_p.setString(1,salesperson_id);
		rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		String salesperson_name =rs_g.getString("SalesPerson_Name");
		if (rs_g.wasNull())
		{
			salesperson_name="";
		}
		String address1=rs_g.getString("address1");
		
		if (rs_g.wasNull())
		{
			address1="";
		}

		String address2=rs_g.getString("address2");
		if (rs_g.wasNull())
		{
			address2="";
		}

		String address3=rs_g.getString("address3");
		if (rs_g.wasNull())
		{
			address3="";
		}

		String city=rs_g.getString("city");	
		if (rs_g.wasNull())
		{
			city="";
		}
		String pin=rs_g.getString("pin");
		if (rs_g.wasNull())
		{
			pin="";
		}
		
		String country=rs_g.getString("country");
		if (rs_g.wasNull())
		{
			country="";
		}
		String mobile=rs_g.getString("mobile");
		if (rs_g.wasNull())
		{
			mobile="";
		}
		
		String phone_o=rs_g.getString("phone_o");
		if (rs_g.wasNull())
		{
			phone_o="";
		}
		String phone_r=rs_g.getString("phone_r");
		if (rs_g.wasNull())
		{phone_r="";}

		String fax=rs_g.getString("fax");	
		if (rs_g.wasNull())
		{fax="";}
	
		String email=rs_g.getString("email");	
		if (rs_g.wasNull())
		{email="";}

		String commission=rs_g.getString("commission");	
		if (rs_g.wasNull())
		{commission="";}

		String active=rs_g.getString("Active");
		
		String activeyes="";
		if("1".equals(active)){activeyes = " checked " ;}
%>

<form action='EditSalesPerson.jsp' method=post name="mainform" onsubmit="return LocalValidate();">
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">

<%
	if("Sale".equals(message))
	{
		int SeSalecount = Integer.parseInt(request.getParameter("Salecount"));
		//out.print("<br>531 SeSalecount="+SeSalecount);
%>

<tr bgcolor="skyblue">
<th colspan=4 align=center>Update Sales Person</th>
</tr>
<input type=hidden name=salesperson_id value='<%=salesperson_id%>'> 
<tr>
	<td>Sales Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value="<%=salesperson_name%>"></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50 Value="<%=address1%>"> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 Value="<%=address2%>"></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 Value="<%=address3%>"></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city Value="<%=city%>"></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin Value="<%=pin%>"></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country Value="<%=country%>"></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile Value="<%=mobile%>"></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o Value="<%=phone_o%>"></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r Value="<%=phone_r%>"></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax Value="<%=fax%>"></td> 
<td>Email</td> 
<td><INPUT  type=text name=email Value="<%=email%>"></td> 
</tr>
<tr>
<td>Commission (%)</td> 
<td colspan=3><INPUT  type=text name=commission Value="<%=str.format(commission,2)%>" size=5></td> 
</tr>
<%
	if(SeSalecount > 0)
	{
%>
<tr><td>Active</td> 
<td><input type=hidden name=active12 <%=activeyes%> value=yes>YES</td>
</tr>
<%
	}
	else
	{
%>
<tr><td>Active</td> 
	<td><input type=checkbox name=active12 value=yes <%=activeyes%>></td>
</tr>
<%
	}
%>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Sale" >
</td>
</tr>

<%
	}
%>
	
	
	
	
<%
	if("Purchase".equals(message))
	{
		int SePurcount = Integer.parseInt(request.getParameter("Purcount"));
%>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<tr bgcolor="skyblue">
<th colspan=4 align=center>Update Purchase Person</th>
</tr>
<input type=hidden name=salesperson_id value='<%=salesperson_id%>'> 

<tr>
	<td>Purchase Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value="<%=salesperson_name%>"></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50 Value="<%=address1%>"> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 Value="<%=address2%>"></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 Value="<%=address3%>"></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city Value="<%=city%>"></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin Value="<%=pin%>"></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country Value="<%=country%>"></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile Value="<%=mobile%>"></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o Value="<%=phone_o%>"></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r Value="<%=phone_r%>"></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax Value="<%=fax%>"></td> 
<td>Email</td> 
<td><INPUT  type=text name=email Value="<%=email%>"></td> 
</tr>
<tr>
<td>Commission (%)</td> 
<td colspan=3><INPUT  type=text name=commission Value="<%=str.format(commission,2)%>" size=5></td> 
</tr>

<%
	if(SePurcount > 0)
	{
%>
<tr><td>Active</td> 
<td><input type=hidden name=active12 <%=activeyes%> value=yes>YES</td>
</tr>
<%
	}
	else
	{
%>
<tr><td>Active</td> 
	<td><input type=checkbox name=active12 value=yes <%=activeyes%>></td>
</tr>

<%
	}
%>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Purchase" >
</td>
</tr>
<%
	
	}
%>

<%
	if("Broker".equals(message))
	{
		int SeBrokercount = Integer.parseInt(request.getParameter("Brokercount"));

%>

<tr bgcolor="skyblue">
<th colspan=4 align=center>Update Broker Person</th>
</tr>
<input type=hidden name=salesperson_id value='<%=salesperson_id%>'> 

<tr>
	<td>Broker Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value="<%=salesperson_name%>"></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50 Value="<%=address1%>"> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 Value="<%=address2%>"></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 Value="<%=address3%>"></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city Value="<%=city%>"></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin Value="<%=pin%>"></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country Value="<%=country%>"></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile Value="<%=mobile%>"></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o Value="<%=phone_o%>"></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r Value="<%=phone_r%>"></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax Value="<%=fax%>"></td> 
<td>Email</td> 
<td><INPUT  type=text name=email Value="<%=email%>"></td> 
</tr>
<tr>
<td>Commission (%)</td> 
<td colspan=3><INPUT  type=text name=commission Value="<%=str.format(commission,2)%>" size=5></td> 
</tr>
<%
	if(SeBrokercount > 0)
	{
%>
<tr><td>Active</td> 
<td><input type=hidden name=active12 <%=activeyes%> value=yes >YES</td>
</tr>
<%
	}
	else
	{
%>
<tr><td>Active</td> 
	<td><input type=checkbox name=active12 value=yes <%=activeyes%>></td>
</tr>
<%
	}
%>


<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Broker" >
</td>
</tr>

<%
		}
	}//while
}//if Partyselected
%>

 
 
 <%

 if("UPDATE".equals(command))
{
		String salesperson_id=request.getParameter("salesperson_id");
		//out.print("<br> 702 salesperson_id = "+salesperson_id);
		
		String salesperson_name=request.getParameter("salesperson_name");	
		//out.print("<br> 705 salesperson_name = "+salesperson_name);

		//out.print("<br> 705 company_id = "+company_id);
		
		String address1=request.getParameter("address1");	
		String address2=request.getParameter("address2");	
		String address3=request.getParameter("address3");	
		String city=request.getParameter("city");	
		String pin=request.getParameter("pin");	
		String country=request.getParameter("country");	
		String mobile=request.getParameter("mobile");	
		String phone_o=request.getParameter("phone_o");	
		String phone_r=request.getParameter("phone_r");	
		String fax=request.getParameter("fax");	
		String email=request.getParameter("email");
		String commission=request.getParameter("commission");
		String active123=request.getParameter("active12");

		System.out.println ("<br> 826 active12  "+active123);

		String selectquery="";
		boolean active_flag =false; 
		
		if("yes".equals(active123))
		{
			active_flag=true;
		}
		message=request.getParameter("message");

		if("Sale".equals(message))
		{
			selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and purchaseSale=0 and SalesPerson_id !="+salesperson_id+" and  company_id="+company_id;
		}
		if("Purchase".equals(message))
		{
			selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and purchaseSale=1 and SalesPerson_id !="+salesperson_id+"  and company_id="+company_id;
		}
		if("Broker".equals(message))
		{
			selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and  purchaseSale=2 and SalesPerson_id !="+salesperson_id+"  and company_id="+company_id;
		}


		pstmt_p = conp.prepareStatement(selectquery);
		rs_g = pstmt_p.executeQuery();	
		int idcount=0;
		while(rs_g.next())
		{
			idcount++;
		}
		pstmt_p.close();

		//out.print("<br> 705 count = "+idcount);

		if(idcount<1)
		{
				String query ="Update Master_SalesPerson set SalesPerson_Name=?, Address1=?, Address2=?, Address3=?, City=?, Pin=?, Country=?, Mobile=?, Phone_O=?, Phone_R=?, Fax=?, Email=? ,Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, active=?, commission="+commission+" where SalesPerson_Id=?";

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString (1,""+salesperson_name);
		pstmt_p.setString (2,""+address1);
		pstmt_p.setString (3,""+address2);
		pstmt_p.setString (4,""+address3);
		pstmt_p.setString (5,""+city);
		pstmt_p.setString (6,""+pin);
		pstmt_p.setString (7,""+country);
		pstmt_p.setString (8,""+mobile);
		pstmt_p.setString (9,""+phone_o);
		pstmt_p.setString (10,""+phone_r);
		pstmt_p.setString (11,""+fax);
		pstmt_p.setString (12,""+email);
		pstmt_p.setString (13, user_id);
		pstmt_p.setString (14, machine_name);
		pstmt_p.setBoolean (15,active_flag);
		pstmt_p.setString (16,""+salesperson_id);		

		int a = pstmt_p.executeUpdate();

		C.returnConnection(conp);
	
	if("Sale".equals(message))
	{
		response.sendRedirect("EditSalesPerson.jsp?command=edit&message=Sale&message1=Sales 	Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}
	else
	{}
	
	if("Purchase".equals(message))
	{
		response.sendRedirect("EditSalesPerson.jsp?command=edit&message=Purchase&message1=Purchase Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}
	else
	{}
	
	if("Broker".equals(message))
	{
		response.sendRedirect("EditSalesPerson.jsp?command=edit&message=Broker&message1=Broker 	Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}
	else
	{}

	}
	else
	{
		if("Sale".equals(message))
		{
				out.println("<BODY><center><font color=red><h2>Sales Person "+salesperson_name+" already exists.</h2><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");
		}
		if("Purchase".equals(message))
		{
				out.println("<BODY><center><font color=red><h2>Purchase Person "+salesperson_name+" already exists.</h2><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");
		}
		if("Broker".equals(message))
		{
				out.println("<BODY><center><font color=red><h2>Broker Person "+salesperson_name+" already exists.</h2><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");
		}
	}//if end

 }//UPDATE
	
	C.returnConnection(conp);
}
catch(Exception Samyak233)
{ 
	C.returnConnection(conp);

	out.println("<br><font color=red> FileName : EditParty.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");
} 

%>


</BODY>
</HTML>









