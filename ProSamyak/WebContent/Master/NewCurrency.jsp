
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;

Connection conp = null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
%>
<HTML>
<HEAD>
<TITLE> Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
var errfound = false;
function LocalValidate()
	{
	errfound = false;

	if(document.f1.currency_name.value == "")
		{
		alert("Please enter Currency's name.");
		document.f1.currency_name.select();
		return errfound;
		}
	else{
			var tempA=document.f1.currency_name.value;
			if(tempA.length < 2)
			{
			alert("Please enter Currencyname Properly. Must be more than three characters");
			document.f1.currency_name.select();
			return errfound;
			}
			else if(document.f1.currency_symbol.value == "")
		{
		alert("Please enter Currency's symbol.");
		document.f1.currency_symbol.select();
		return errfound;
		}
				
else if(document.f1.base_exchangerate.value == "")
		{
		alert("Please enter Exchange Rate.");
		document.f1.base_exchangerate.select();
		return errfound;
		}
			else{
				return !errfound;
				}
		}

}//Localvalidate

function chknumber()
{
if(isNaN(document.f1.base_exchangerate.value))
	{
alert("Exchange Rate Should be Number");
document.f1.base_exchangerate.select();
return false;
	}
else{return true;}
}

function fnCheckInteger(astrFieldValue,astrFieldName)
{
	var RefString="1234567890";
	var InString = astrFieldValue;	

	//check only the characters present in RefString are entered

	for (Count=0; Count < InString.length; Count++)  
	{			
        if (RefString.indexOf (InString.substring (Count, Count+1))==-1)  
		{
				alert(astrFieldName + " should be Integer");
				f1.qty_order_point.select();
				return (false);
		}
     }
     return true;
}
</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<%
String message=request.getParameter("message"); 
//out.println(message);
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String sr_no= ""+L.get_master_id(conp,"Master_Currency");
%>
<br>
<form name=f1 action=UpdateCurrency.jsp method=post onsubmit="return LocalValidate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue" >
<th align=center colspan="2">Add New Currency</th>
</tr>
<tr>
<td>Sr. No.</td>
<td><%=sr_no%></td>
</tr>
<%
if("0".equals(company_id))
{

%>
<tr><td>Company</td>
<td><%=A.getMasterArrayCondition(conp,"CompanyParty","CompanyParty_Id","","where company=true",company_id) %>
	</td>
</tr>
<%
}
		C.returnConnection(conp);	
%>
<tr>
	<td>Currency Name  <font class="star1">*</font> </td>
	<td><input type=text size=15 name=currency_name></td>
</tr>

<tr>
	<td>Currency Symbol 
	<td colspan=3 > <input type=text size=5 name=currency_symbol >
</tr>

<tr>
	<td>Exchange Rate Per US $</td>
	<td><input type=text size=10 name=base_exchangerate onblur="chknumber()"></td>
</tr>
<tr>
	<td>Decimal Places</td>
	<td><input type=text size=4 name=decimal_places onBlur='validate(this)'></td>
</tr>

<tr>
	<td>Local Currency</td>
	<td><input type=checkbox name=local value=yes ></td>
</tr>	

<tr><td align=center colspan="2"><input type=submit value='SUBMIT' name=command class='Button1'>
</table>
</BODY>
</HTML>









