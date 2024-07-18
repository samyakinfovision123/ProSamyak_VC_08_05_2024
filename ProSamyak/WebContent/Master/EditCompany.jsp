<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<% String command = request.getParameter("command");
String message = request.getParameter("message"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
	}catch(Exception Samyak13){ 
	out.println("<font color=red> FileName : EditCompany.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");
	}
	%>

<% 
String user_name	= ""+session.getValue("user_name");
int user_level		= Integer.parseInt(""+session.getValue("user_level"));
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
%>

<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script>
function Validate()
	{
	var errfound = false;
	if(document.EditCompany.companyparty_name.value == "")
		{
		alert("Please enter company's name.");
		document.EditCompany.companyparty_name.focus();
		return errfound;
		}
else{
		var tempA=document.EditCompany.companyparty_name.value;
		if(tempA.length < 2)
			{
			alert("Please enter Company's name Properly. Must be more than three characters");
			document.EditCompany.companyparty_name.focus();
			return errfound;
			}
		else
			{
			if(document.EditCompany.country.value == "")
				{
			alert("Please enter County's name.");
			document.EditCompany.country.focus();
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


</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<!--  Company selection form -->

<% 

	if("edit".equals(command))
	{
%>
<form action="EditCompany.jsp?command=CompanySelected&message=masters" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Company Name </th>
</tr>

<tr>
	<td align=center>Company Name </td>
	<td><%=A.getMasterArrayCondition(conp,"CompanyParty","CompanyParty_Id","","where company=1",company_id) %>
	</td>
</tr>
<tr>
	<td colspan=2 align=center>
	<INPUT type=submit  name=command  value='SELECT' class='Button1'> 
	</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<%
C.returnConnection(conp);


}
%>

<%
try{
	if("CompanySelected".equals(command))
	{
 
	String companyparty_id=request.getParameter("CompanyParty_Id");
	//out.println(companyparty_id);
	String query = "select * from Master_CompanyParty where CompanyParty_Id=?";
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, companyparty_id);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
		{
String companyparty_name =rs_g.getString("CompanyParty_Name");
if (rs_g.wasNull())
			{companyparty_name="";}
//out.println("<br>1:"+companyparty_name);
String category_code	=rs_g.getString("category_code");
if (rs_g.wasNull())
			{category_code="0";}

//out.println("<br>2:"+category_code);
String address1		=rs_g.getString("address1");
if (rs_g.wasNull())
			{address1="";}

//out.println("<br>3:"+address1);
String address2     =rs_g.getString("address2");
if (rs_g.wasNull())
			{address2="";}

//out.println("<br>4:"+address2);
String address3		=rs_g.getString("address3");
if (rs_g.wasNull())
			{address3="";}

//out.println("<br>5:"+address2);
String city			=rs_g.getString("city");	
if (rs_g.wasNull())
			{city="";}

//out.println("<br>6:"+city);
String pin			=rs_g.getString("pin");
if (rs_g.wasNull())
			{pin="";}
//out.println("<br>7:"+pin);
String country		=rs_g.getString("country");
if (rs_g.wasNull())
			{country="";}

//out.println("<br>8:"+country);
String income_taxno		=rs_g.getString("income_taxno");
if (rs_g.wasNull())
			{income_taxno="";}

//out.println("<br>9:"+income_taxno);
String sales_taxno		=rs_g.getString("sales_taxno");
if (rs_g.wasNull())
			{sales_taxno="";}

//out.println("<br>9:"+phone_off);

String phone_off		=rs_g.getString("phone_off");
if (rs_g.wasNull())
			{phone_off="";}

//out.println("<br>9:"+phone_off);
String phone_resi			=rs_g.getString("phone_resi");
if (rs_g.wasNull())
{phone_resi="";}

//out.println("<br>10:"+phone_resi);
String mobile		=rs_g.getString("mobile");
//out.println("<br>11 ccc:"+mobile);
if (rs_g.wasNull())
			{mobile="";}
//out.println("<br>11 ccc:"+mobile);
//out.println("<br>11:"+mobile);
String email		=rs_g.getString("email");	
if (rs_g.wasNull())
			{email="";}

//out.println("<br>12:"+email);
String website		=rs_g.getString("website");
if (rs_g.wasNull())
			{website="";}

//out.println("<br>13:"+website);
String person1			=rs_g.getString("person1");
if (rs_g.wasNull())
			{person1="";}

//out.println("<br>14:"+person1);
String person2			=rs_g.getString("person2");
if (rs_g.wasNull())
			{person2="";}

//out.println("<br>15:"+person2);

String fax_no			=rs_g.getString("fax");	
//out.println("<br>16:"+fax_no);
if (rs_g.wasNull())
			{fax_no="";}
//out.println("<br>16:"+fax_no);
//out.println("<br>16:"+fax_no);
String active		=rs_g.getString("active");
//out.println("<br>17:"+active);
String sr_no		=rs_g.getString("sr_no");
if (rs_g.wasNull())
			{sr_no="";}

//out.println("<br>18:"+sr_no);
String Company		=rs_g.getString("Company");
if (rs_g.wasNull())
			{Company="";}

//out.println("<br>19:"+Company);
String activeyes="";
if("1".equals(active)){activeyes = " checked " ;}
%>

<form action='UpdateCompany.jsp' method=post name="EditCompany" onsubmit="return Validate();">
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Update Company
<input type=hidden value='<%=companyparty_id%>' name=companyparty_id > 
<input type=hidden name=sr_no size=6 value='<%=sr_no%>'>
</tr>
<!-- <tr><td>Sr No</td>
	<td colSpan=3><%=sr_no%></td>
</tr>
 --></tr>

  <tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=3><INPUT type=text name=companyparty_name value="<%=companyparty_name%>" size=30 value=''></td>
	</tr>
<input type =hidden name= category_code value=<%=category_code%>>

<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 value='<%=address1%>' size=50> </td>
</tr>
<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 value='<%=address2%>' size=50 ></td> 
</tr>
<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 value='<%=address3%>' size=50 ></td> 
<tr>
    <td>City</td> 
    <td><INPUT  type=text name=city value='<%=city%>'></td> 
    <td>Pin</td> 
    <td><INPUT  type=text name=pin value='<%=pin%>'></td> 
<tr>
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country value='<%=country%>'>
	</td>
</tr> 
<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name='income_taxno' value='<%=income_taxno%>'></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name='sales_taxno' value='<%=sales_taxno%>'></td>
</tr>

<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off value='<%=phone_off%>'></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi value='<%=phone_resi%>'></td>
</tr>
<tr>
    <td>Fax 
    <td><INPUT  type=text name=fax_no value='<%=fax_no%>'></td>
	<td>Mobile</td>
    <td><INPUT  type=text name=mobile value='<%=mobile%>'></td>
</tr>	
<tr>
    <td>Email</td> 
    <td><INPUT  type=text name=email value='<%=email%>'>
    <td>Website</td> 
    <td><INPUT  type=text name=website value='<%=website%>'>
</tr>
<tr>
    <td>Contact Person 1</td> 
    <td><INPUT  type=text name=person1 value='<%=person1%>'>
    <td>Person 2</td>
    <td><INPUT type=text  name=person2 value='<%=person2%>'> 
	<input type=hidden name=active value=yes >
</td>
</tr>
<!-- <tr><td>Active</td> 
	<td></td>
</tr>
 -->
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='Button1'> 
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<%
		}//while
pstmt_p.close();
C.returnConnection(conp);

}//if Companyselected

}catch(Exception Samyak233){ 
	out.println("<br><font color=red> FileName : EditCompany.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");} 
%>

</BODY>
</HTML>









