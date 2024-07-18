<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%// System.out.println("Inside GL_NewCompany.jsp");%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<jsp:useBean id="I" class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);


	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{conp=C.getConnection();}catch(Exception Samyak13){ 
	out.println("<font color=red> FileName : NewCompany.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");}

String command = request.getParameter("command");
//System.out.println("From New Company :- command is "+command);
//out.println("From New Company :- command is "+command);
String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}


String query="";
String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
//System.out.println("companyparty id is "+companyparty_id);
if("0".equals(company_id))
{
try{
%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>



<script>
var errfound1 = false;
function validateExrate(form)
	{
	 errfound1 = false;
     if(document.Newcompanyparty.base_exchangerate.value =="")
				{
			alert("Please enter ExchangeRate");
			document.Newcompanyparty.base_exchangerate.focus();
			return errfound1;
				}

			else
				{
				return !errfound1;
				}
       }
function ValidLength(item,len)
	{
		return (item.length >= len);
	}
function ValidEmail(item)
	{
		if (!ValidLength(item, 5))
		return false;
		if (item.indexOf ('@', 0) == -1)
		return false;
		return true
	}

var errfound = false;
function LocalValidate()
	{
	errfound = false;
	if(document.Newcompanyparty.companyparty_name.value == "")
		{
		alert("Please enter Company's name.");
		document.Newcompanyparty.companyparty_name.focus();
		return errfound;
		}
	else{
		var tempA=document.Newcompanyparty.companyparty_name.value;
		if(tempA.length < 2)
			{
			alert("Please enter Company's name Properly. Must be more than three characters");
			document.Newcompanyparty.companyparty_name.focus();
			return errfound;
			}
		else
			{
			if(document.Newcompanyparty.country.value =="")
				{
			alert("Please enter County's name.");
			document.Newcompanyparty.country.focus();
			return errfound;
				}

			else
				{
				return !errfound;
				}
			}
			
		}
	}


</script>
	<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js"></script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="UpdateCompany.jsp" method=post name=Newcompanyparty onsubmit="return LocalValidate();">
<input type=hidden name=active value=yes>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Add New Company
<input type=hidden name=sr_no size=6 value='<%=companyparty_id%>'></th>
</tr>
<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3> <INPUT type=text name=companyparty_name size=30> </td>
</tr>
<td>Entity</td>
<td><%
	
	String EntityQuery ="select * from Entity Where Active=1 and EId Not IN (1,2)";
	pstmt_p = conp.prepareStatement(EntityQuery);
	rs_g = pstmt_p.executeQuery();
	String html_array ="<select name='category_code' >";
	while(rs_g.next())
	{
		 String temp1 = rs_g.getString("Eid");		
		 String temp = rs_g.getString("EName");
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 html_array = html_array +" > "+temp+" </option> ";
	}
	html_array = html_array +" </select> ";
	pstmt_p.close();
	out.print(html_array);%></td>
<!-- <input type=hidden name="category_code" value=0> -->
<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 size=50> </td>
</tr>
<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 ></td> 
</tr>
<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 ></td> 
<tr>
    <td>City</td> 
    <td><INPUT  type=text name=city></td> 
    <td>Pin</td> 
    <td><INPUT  type=text name=pin></td> 
<tr>
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country>
	</td>
</tr> 
<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name=income_taxno></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name=sales_taxno></td>
</tr>
<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi></td>
</tr>
<tr>
    <td>Fax 
    <td><INPUT type=text name=fax_no></td>
	<td>Mobile</td>
    <td><INPUT type=text name=mobile></td>
</tr>	
<tr>
    <td>Email</td> 
    <td><INPUT type=text name=email>
    <td>Website</td> 
    <td><INPUT type=text name=website><tr>
    <td>Contact Person 1</td> 
    <td><INPUT type=text name=person1>
    <td>Person 2</td>
    <td><INPUT type=text  name=person2> </td>
</tr>

<tr bgcolor="skyblue">
<th colspan=4 align=center>
Local Currency </th></tr>
<tr><td height=25>Financial Year</td>
	<td><script language='javascript'>
<!--
if (!document.layers) {
document.write("<input type=button class='button1' onclick='popUpCalendar(this, Newcompanyparty.datevalue, \"dd/mm/yyyy\")' value='From' style='font-size:11px ; width:50' >")
	}
	//-->
</script>
	<input type=text name='from_date' size=8 maxlength=10 value="01/04/2005"
onblur='return  fnCheckDate(this.value,"Date")' >
</td>
	<td><script language='javascript'>
<!--
if (!document.layers) {
document.write("<input type=button class='button1' onclick='popUpCalendar(this, Newcompanyparty.datevalue, \"dd/mm/yyyy\")' value='To' style='font-size:11px ; width:50' >")
	}
	//-->
</script><input type=text name='to_date' size=8 maxlength=10 value="31/03/2006"
onblur='return  fnCheckDate(this.value,"Date")' >
</td>
	</tr>

<tr>
<td>Currency Name <font class="star1">*</font> </td>
<td><input type=text size=15 name=currency_name value="Yen" ></td>
<td>Currency Symbol<font class="star1">*</font> 
<td colspan=3> <input type=text size=5  value="Y" name=currency_symbol >
</tr>
<tr>
	<td>Exchange Rate Per US $<font class="star1">*</font></td>
<td><input type=text size=10  value="112" name=base_exchangerate onBlur='validateExrate(this)'> </td>
	<td>Decimal Places<font class="star1">*</font></td>
	<td><input type=text size=4 name=decimal_places value="0" onBlur='validate(this)'></td>
</tr>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='ADD Company' onclick="return LocalValidate()" class='Button1'> 
</table>
</td>
</tr>
</TABLE>

</form>
</BODY>
</HTML>
<% 
	C.returnConnection(conp);	

	}catch(Exception e170){ 
	out.println("<font color=red> FileName : GL_NewCompany.jsp <br>Bug No e170 :"+ e170 +"</font>");}
}//if company_id
else
{
try{
query="Select * from master_companyparty where super=1 and company=1 and active=1";
//System.out.println("191 Query is "+query);
//out.println("191 Query is "+query);

	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	int c=0;
	while(rs_g.next())		{
		c++;
		}

	pstmt_p.close();
//	out.print("<br>cccccccccccccount="+c);
	int count = c;
	String sname[]=new String[count];
	int sc_id[]=new int[count];
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	c=0;
	while(rs_g.next())
		{
		sc_id[c]=rs_g.getInt("CompanyParty_Id");
		out.print("<br>281 sc_id[c]="+sc_id[c]);
		sname[c]=rs_g.getString("CompanyParty_Name");
		
		out.print("<br>284 sname[c]="+sname[c]);
		//out.print("<br>count="+count+"sname="+sname[c]);
	//	out.print("sname_id="+sc_id[c]);
		c++;
		}
	pstmt_p.close();


query="Select * from master_companyparty where company=1 and company_id="+company_id+" and active=1";
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	c=0;
	while(rs_g.next())	{c++;}
	pstmt_p.close();

//	out.print("<br>counter="+c);
	int group_counter = c+1;
	int group_id[] = new int[group_counter];
	String company_name[]= new String[group_counter];
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
 
	c=0;
	while(rs_g.next())
		{
		group_id[c] = rs_g.getInt("GroupCompany_Id");
		company_name[c] = rs_g.getString("CompanyParty_Name");
		//out.print("<br>count="+group_counter+"c_name="+company_name[c]);
//out.print("<br>count="+group_counter+"group_id="+group_id.length);
		c++;
	}
pstmt_p.close();

group_id[group_counter-1] =  Integer.parseInt(company_id);
//out.print("<br><font color=green>group_id="+group_id.length);
//out.print("<br></font>count - group_counter "+(count - group_counter));

int array[] = new int[count - group_counter];
String sname_array[] = new String[count - group_counter];
//out.print(" <br> sc_id "+sc_id.length);
//out.print(" <br> array "+array.length);
//out.print(" <br> group_id "+group_id.length);
int temp_counter = 0;
int temp=0;

for(int i=0;i < sc_id.length;i++)
	{
	temp_counter=0;
//	out.print(" <br>1 sc_id "+sc_id[i] );
	for(int j=0;j<group_id.length;j++)
		{
		if(sc_id[i] == group_id[j])
			{ 
			temp_counter++;
			}
		else 
			{ 
			}
		}// inside first for
			if(!(temp_counter > 0)) 
				{
			//	out.print("<br> Inside Zeroooooooooo "+temp);
					array[temp] = sc_id[i];	
					sname_array[temp] = sname[i];
					temp++;
				temp_counter=0;
				}
	} //for outer
%>
<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="UpdateCompany.jsp" method=post name=mainform>
<input type=hidden name=active value=yes>


<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor="skyblue">
<th colspan=4 align=center>
Add  Company</th>	</tr>
<tr>
  <td>Name <font class="star1">*</font></td>
  <td >
	<select name=company >

	<%
for(int i=0;i < array.length;i++)
	{
String selected = " selected ";
if( i > 0) { selected = " ";}
%>

	<option value="<%=array[i]%>" <%=selected%>> <%=sname_array[i]%>
	</option>
	
<%
	}
%>
</select>
 </tr>

<tr>
<td>Opening Date</td>
<td colspan=3> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date")'>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Select' style='font-size:11px ; width:50'>")}
</script>
</td>
</tr>
<tr>
<td>Currency</td>
<td><input type=radio size=4 name=currency value=local checked>Local&nbsp;<input type=radio size=4 name=currency value=dollar>Dollar</td>
</tr>
<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=4 name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>'  onBlur='validate(this)'></td>
</tr>

<tr>
<td>Sales</td>	 
<td colspan=3><input type=checkbox name=sale value=yes>
Opening Balance <input type=text size=4 name="opening_salesbalance" value=0 onBlur='validate(this)'>
<Select name=sale_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
</tr>

<tr>
<td>Purchase</td>	 
<td colspan=3><input type=checkbox name=purchase value=yes>
Opening Balance <input type=text size=4 name="opening_purchasebalance" value=0 onBlur='validate(this)'>
<Select name=purchase_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
</tr>

<tr>
<td>PN</td>	 
<td colspan=3><input type=checkbox name=pn value=yes>
Opening Balance <input type=text size=4 name="opening_pnbalance" value=0 onBlur='validate(this)'>
<Select name=pn_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
</tr>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='ADD Company' class='Button1'> 
</table>
</td>
</tr>
</TABLE>

</form>
</BODY>
</HTML>
<% 
	C.returnConnection(conp);	

	}catch(Exception e170){ 
	out.println("<font color=red> FileName : NewCompany.jsp <br>Bug No e170 :"+ e170 +"</font>");}

	}%>








