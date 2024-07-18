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
<tr><td>Active</td> 
	<td><input type=checkbox name=active value=yes <%=activeyes%>></td>
</tr>
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Sale" >
</td>
</tr>

<%
	}
	
	if("Purchase".equals(message))
	{
%>

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
<tr><td>Active</td> 
	<td><input type=checkbox name=active value=yes <%=activeyes%>></td>
</tr>
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Purchase" >
</td>
</tr>
<%
	
	}

	if("Broker".equals(message))
	{

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
<tr><td>Active</td> 
	<td><input type=checkbox name=active value=yes <%=activeyes%>></td>
</tr>
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='button1'>
	<input type=hidden name=message value="Broker" >
</td>
</tr>

<%
		}
	}//while
}