<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<% 
Connection cong = null;

cong=C.getConnection();

String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(cong,"companyparty",company_id);
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
C.returnConnection(cong);
%>
<HTML>
<HEAD>
<title>Samyak Software </title>
<style>
	input{font-family:Arial,Times New Roman; font-size:11pt; color:black;}
	textarea{font-family:Arial,Times New Roman; font-size:11pt; color:black}
	select{font-family:Arial,Times New Roman; font-size:11pt; color:black;}
	th{font-family:Arial,Times New Roman; font-size:11pt; color:#993300;}
	td{font-family:Arial,Times New Roman; font-size:11pt; color:black}
	.td1{font-family:Tahoma,arial,Times New Roman; font-size:12pt; color:black}
	.submit1{font-family:Tahoma,arial,Times New Roman; font-size:12pt; color:red}
	.star1{font-family:Tahoma,arial,Times New Roman; font-size:10pt; font-weight:bold;color:red}
</style>

<script language="JavaScript">
function disback()
{
//alert(" Page is Refreshed ");
//if(history.back)	{	history.forward();	}
}
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

</script>
<META NAME="Author" CONTENT="JAINAM TECHNOLOGIES , phone : 98209 56851 / 9892369118">
</HEAD>

<BODY bgcolor=ffffee onContextMenu="disrtclick()" >
<table align=center valign=middle border=2 bordercolor=skyblue cellspacing=0>
<tr>
<th><%=company_name%></th>
</tr>
<tr>
<td align=center valign=middle>
<a href="MASTER/Masterleft.jsp?message=Default">
Master
<!--
<img name=equ src="buttons/flash_buttons/masters1.jpg" onMouseOver="document.equ.src='buttons/flash_buttons/masters2.jpg'" 
onMouseOut="document.equ.src='buttons/flash_buttons/masters1.jpg'" border=0 title=' Master Menu'> -->
</a>
</td>
</tr>
<tr>
<td align=center valign=middle>
<a href="Inventory/Inventoryleft.jsp" >Inventory
<!--
<img name=Sell src="buttons/flash_buttons/inventory1.jpg" onMouseOver="document.Sell.src='buttons/flash_buttons/inventory2.jpg'" 
onMouseOut="document.Sell.src='buttons/flash_buttons/inventory1.jpg'" border=0 title=' Inventory Menu'> --></a>


</td>
</tr>

<tr>
<td align=center valign=middle>
<a href ="Consignment/Cgtleft.jsp">Consignment</a>
</td>
</tr>

<tr>
<td align=center valign=middle>
<a href ="left.jsp">Account</a>
</td>
</tr>

<tr>
<td align=center valign=middle>
<a href ="left.jsp">General</a>
</td>
</tr>

<tr>
<td align=center valign=middle>
<a href ="left.jsp">Reports</a>
</td>
</tr>


</BODY>
</HTML>















































