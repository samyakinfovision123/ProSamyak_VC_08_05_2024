<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<%!int samyakerror=0;%>
<% 
Connection conp = null;
try	{
	
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
 String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String text="jpg";
String servername=request.getServerName();


//out.print("<br>2");
//out.print("<br>text="+text);

String today_string=format.format(D);
String condition="where Company_Id="+company_id;
java.sql.Date DS = Config.financialYearStart();
int dd=DS.getDate()-1;
//DS.setString(""+dd);

String command = request.getParameter("command");
String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";

try{
%>
<html>
<head>
<title>Samyak Software - India</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>

<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>




<SCRIPT LANGUAGE="JavaScript">

function tbnew(str)
{
window.open(str,"_blank", ["Top=70","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=400","Width=500", "Resizable=yes","Scrollbars=yes","status=no"])
}




</SCRIPT>


</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='document.mainform.lot_no.select();'>
<form action="UpdateLot.jsp" method=post name=mainform onsubmit="return LocalValidate();">
<table align=center bordercolor="skyblue" border=1 cellspacing=0 cellpadding=2 width='100%'>
<tr><td>
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Enter Lot Details
</th>  
</tr>
<tr>
	<td></td>

</tr>
<tr>
</tr>
<tr>
</tr>
<tr>
</tr>

<tr>

</tr>
</TABLE>


</td></tr>
</table>
</form>
</body>
</html>
<% 
   C.returnConnection(conp);	
}catch(Exception Samyak170)
	{ 
	C.returnConnection(conp);
	out.println("<font color=red> FileName : NewLot.jsp <br>Bug No Samyak170 :"+ Samyak170 +"</font>");
	}
	%>







