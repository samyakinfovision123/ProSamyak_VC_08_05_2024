<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
String command = request.getParameter("command");
//out.print("<BR>command="+command);
if("Default".equals(command))
{

%>
<HTML>
<HEAD>
<TITLE>Samyak Software- India</TITLE>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

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
	else {
			var tempA=document.mainform.salesperson_name.value;
			if(tempA.length < 3)
			{
			alert("Please enter Person name Properly. Must be more than two characters");
			document.mainform.salesperson_name.select();
			return errfound;
			}
			else{
				return !errfound;
				}
		}// else 


}//validate

</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<br>

<form name=mainform action=UpdateSalesPerson.jsp method=post onsubmit="return LocalValidate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<%
	String message=request.getParameter("message"); 
	String message1=request.getParameter("message1"); 
	//out.print(" <br> 74 message1"+message1);
if("Sale".equals(message))
{
	if(message1 == null)
	{
	}else
	{
		out.println("<center><font class='submit1'> "+message1+"</font></center>");
	}
%>

<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="4">Add New Sales Person</th>
</tr>

<tr>
	<td>Sales Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value=""></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 ></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax></td> 
<td>Email</td> 
<td><INPUT  type=text name=email></td> 
</tr>
<tr>
<td>Commission (%) </td> 
<td colspan=3><INPUT  type=text name=commission size=5 value="0" onBlur='validate(this,2)' style="text-align:right"></td> 

</tr>
<input type=hidden name=command1 value='Default' >
<input type=hidden name=message value='Sale' >
<tr>
	<td align=center colspan="4"><input type=submit value='Save' name=command class="button1">
	</td>
</tr>
</table>
<%}
	

//else{out.println("<center><font class='submit1'> "+message1+"</font></center>");}%>
<%
if("Purchase".equals(message))
{
	if(message1 == null)
	{
	}else
	{
		out.println("<center><font class='submit1'> "+message1+"</font></center>");
	}
	%>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="4">Add New Purchase Person</th>
</tr>

<tr>
	<td>Purchase Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value=""></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 ></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax></td> 
<td>Email</td> 
<td><INPUT  type=text name=email></td> 
</tr>
<tr>
<td>Commission (%) </td> 
<td colspan=3><INPUT  type=text name=commission size=5 value="0" onBlur='validate(this,2)' style="text-align:right"></td> 

</tr>
<input type=hidden name=command1 value='Default' >
<input type=hidden name=message value='Purchase' >
<tr>
	<td align=center colspan="4"><input type=submit value='Save' name=command class="button1">
	</td>
</tr>
</table>
<%}
//else{out.println("<center><font class='submit1'> "+message1+"</font></center>");}%>
<%
if("Broker".equals(message))
{
	if(message1 == null)
	{
	}else
	{
		out.println("<center><font class='submit1'> "+message1+"</font></center>");
	}
	%>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="4">Add New Broker Person</th>
</tr>

<tr>
	<td>Broker Person Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=salesperson_name Value=""></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 ></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax></td> 
<td>Email</td> 
<td><INPUT  type=text name=email></td> 
</tr>
<tr>
<td>Commission (%) </td> 
<td colspan=3><INPUT  type=text name=commission size=5 value="0" onBlur='validate(this,2)' style="text-align:right"></td> 

</tr>
<input type=hidden name=command1 value='Default' >
<input type=hidden name=message value='Broker' >
<tr>
	<td align=center colspan="4"><input type=submit value='Save' name=command class="button1">
	</td>
</tr>
</table>
<%}
//else{out.println("<center><font class='submit1'> "+message1+"</font></center>");}%>
</table>
</form>

</BODY>
</HTML>
<% } //if Default
%>








