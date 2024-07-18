<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{
	cong=C.getConnection();
}
catch(Exception e31){ 
out.println("<font color=red> FileName : CgtReport.jsp<br>Bug No e31 : "+ e31);}



String company_name= A.getName(cong,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
C.returnConnection(cong);


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
<tr bgcolor=skyblue><th>Consignment </th>

</tr>


<tr align=center><td><input type=button value='Cgt Purchase' class='button1' onClick='a("EditCgtPurchase.jsp?command=PurchaseReport&message=masters")'> </td>
</tr> 

<tr align=center><td><input type=button value='Cgt Sale' class='button1' onClick='a("EditCgtSale.jsp?command=SaleReport&message=masters")'> </td>
</tr> 
</table>
<%
}//if Default


if("Stock".equals(command))
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
window.open(str,"parent", ["Top=2","Left=50","Toolbar=no", "Location=0","Menubar=no","Height=500","Width=600", "Resizable=yes","Scrollbars=yes","status=Yes"])
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG" scroll=no>
<table align=center  bordercolor=skyblue  border=1 cellspacing=0  height='36'>
<tr bgcolor=skyblue><th>Inventory</th>

</tr>
<tr align=center><td><input type=button value='Diamond Lot' class='button1' onClick='a("EditLot.jsp?command=edit&message=Default")'></td>
</tr> 


<tr align=center><td><input type=button value='Jewelry Lot' class='button1' onClick='a("EditJewelry.jsp?command=edit&message=Default")'> </td>
</tr> 
<tr align=center><td><input type=button value='Opening Stock' class='button1' onClick='a("EditOpeningStock.jsp?command=edit&message=Default")'> </td>
</tr> 


<!-- <tr align=center><td><input type=button value='Stock Transfer' class='button1' onClick='a("EditStockTransferReport.jsp?command=Default&message=Default")'> </td>
</tr> 
 -->
</table>
<%
}//if Stock





if("Finance".equals(command))
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
window.open(str,"parent", ["Top=2","Left=50","Toolbar=no", "Location=0","Menubar=no","Height=500","Width=600", "Resizable=yes","Scrollbars=yes","status=Yes"])
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG" scroll=no>
<table align=center  bordercolor=skyblue  border=1 cellspacing=0  height='36'>
<tr bgcolor=skyblue><th>Financial</th>

</tr>
<tr align=center><td><input type=button value='Sale' class='button1' onClick='a("EditSale.jsp?command=SaleReport&message=masters")'> </td>
</tr> 


<tr align=center><td><input type=button value='Purchase' class='button1' onClick='a("EditPurchase.jsp?command=PurchaseReport&message=masters")'> </td>
</tr> 

</table>
<%
}//if Finance



}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>









