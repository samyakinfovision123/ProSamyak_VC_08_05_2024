<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//String company_name= A.getName("companyparty",company_id);
//String local_symbol= I.getLocalSymbol(company_id);
//String local_currency= I.getLocalCurrency(company_id);
//int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
 int dd=D.getDate();
 int d1=dd + 1;
int mm=D.getMonth();
java.sql.Date Dnext = new java.sql.Date((year),(mm),d1);

year =year-1;
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
try{
if("Default".equals(command))
	{
%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
window.event.returnValue=0;
}




function a(str)
{
window.open(str,"right", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=400","Width=750", "Resizable=yes","Scrollbars=yes","status=Yes"])
}
function b(str)
{
window.open(str,"_blank", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=400","Width=750", "Resizable=yes","Scrollbars=yes","status=Yes"])
}
function c(str)
{
window.open(str,"_blank", ["Top=2","Left=50","Toolbar=no", "Location=0","Menubar=no","Height=500","Width=600", "Resizable=yes","Scrollbars=yes","status=Yes"])
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG" scroll=no>
<table   bordercolor=skyblue  border=1 cellspacing=0 align=center height='36'>
<tr bgcolor=skyblue><th>Vouchers</th>

</tr>
<tr align=center><td><input type=button value='Edit' class='button1' onClick='a("EditVouchers.jsp?command=edit&message=masters")'> </td>
</tr>  


<tr align=center><td><input type=button value='Cancel' class='button1' onClick='a("CancelVouchers.jsp?command=edit&message=masters")'> </td>
</tr>  

</table>
<%
}//if Default

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>









