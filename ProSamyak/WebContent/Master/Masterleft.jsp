<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
try {
%>
<HTML>
<HEAD>
<TITLE>Fine Star - Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<META NAME="Samyak Software">
</HEAD>
<script >
function disback()
{
//alert(" Page is Refreshed ");
//if(history.back)	{	history.forward();	}
}
function disrtclick()
{
window.event.returnValue=0;
}
function OpenRight(str)
{
window.open(str,"right")
}

function OpenParent(str)
{
window.open(str,"_parent")
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
window.open(str,"_parent", ["Top=20","Left=170","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=800", "Resizable=yes","Scrollbars=yes","status=Yes"])
}

</script>
<BODY bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" vlink="blue">
<%
	String message = request.getParameter("message"); 
if	("Default".equals(message)){}
else{
	out.println("<center><font class='submit1'> "+message+"</font></center><br>");
	}
%>
<TABLE borderColor=skyblue align=center border=0 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center >
<th align=center class='th1' >Add New</th>
</tr>	


<tr align=center><td><input type=button value='User' class='button1' onClick='a("NewUser.jsp?message=Default")' ></td>
</tr> 

</table>
</td>
</tr>
<tr><td>
<TABLE borderColor=#D9D9D9 border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center >
<th align=center class='th1'>Edit Master</th>
</tr>


<tr align=center><td><input type=button value='Account' class='button1' onClick='a("EditParty.jsp?command=edit&message=masters")' ></td>
</tr> 


<tr align=center><td><input type=button value='Bank Account' class='button1' onClick='a("EditAccount.jsp?command=edit")' ></td>
</tr> 

<tr align=center><td><input type=button value='Cash' class='button1' onClick='a("EditCash.jsp?command=Default&message=masters")' ></td>
</tr> 


<tr align=center><td><input type=button value='Currency' class='button1' onClick='a("EditMasters.jsp?command=Currency&message=masters")' ></td>
</tr>  


<tr align=center><td><input type=button value='Consignment' class='button1' onClick='a("CgtInvFin.jsp?command=Default")'> </td>
</tr> 


<tr align=center><td><input type=button value='Financial' class='button1' onClick='a("CgtInvFin.jsp?command=Finance")'> </td>
</tr> 


<tr align=center><td><input type=button value='Group' class='button1' onClick='a("EditGroup.jsp?command=edit&message=masters")' ></td>
</tr> 

<tr align=center><td><input type=button value='Inventory' class='button1' onClick='a("CgtInvFin.jsp?command=Stock")'> </td>
</tr> 
<tr align=center><td><input type=button value='Ledger' class='button1' onClick='a("EditLedger.jsp?command=edit&message=masters")' ></td>
</tr> 


<tr align=center><td><input type=button value='Local Currency' class='button1' onClick='a("EditLocalCurrency.jsp?command=edit&message=masters")' ></td>
</tr> 

<tr align=center><td><input type=button value='Picture' class='button1' onClick='a("PictureModifyForm.jsp?message=Default")'> </td>
</tr> 




<tr align=center><td><input type=button value='Sales Person' class='button1' onClick='a("EditSalesPerson.jsp?command=edit&message=Default")'> </td>
</tr> 


<tr align=center><td><input type=button value='TrialBalance Admin' class='button1' onClick='a("../Report/NewTrailBalance.jsp?command=Default")'> </td>
</tr> 	


<tr align=center><td><input type=button value='Update Ex-Rate' class='button1' onClick='a("EditLocalCurrency.jsp?command=update&message=masters")'> </td>
</tr> 

<tr align=center><td><input type=button value='User' class='button1' onClick='a("EditUser.jsp?command=edit&message=Default")'> </td>
</tr> 

<tr align=center><td><input type=button value='Vouchers' class='button1' onClick='a("Voucher.jsp?command=Default")'> </td>
</tr> 

<tr><td></td></tr>
<!-- <tr align=center><td><input type=button value='Home' class='button4' onClick='c("../Nipponhome/Homepage.jsp")'> 
<a href="../Nipponhome/Homepage.jsp" target=_parent><%=company_name%></a>
</td>
</tr> 
 -->
<tr>
<td align=center valign=middle>
<A href="../Nipponhome/Homepage.jsp" target="_parent">
<img src='../buttons/house.gif'  border=0><br><B><%=company_name%></B>
</a>
</td>
</tr>


</table>


</table>
</BODY>
</HTML>
<% }
catch(Exception Samyak13){ 
out.println("<font color=red> FileName : Masterleft.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");}
%>








