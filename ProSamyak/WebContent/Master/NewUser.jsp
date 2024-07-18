<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
//out.print("<br>10 company_id="+company_id);
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
//out.print("<br>company_id"+company_id);
%>
<HTML>
<HEAD>
<TITLE>Samyak Software</TITLE>


<script>
var errfound = false;
function LocalValidate()
	{
	errfound = false;

	if(document.mainform.user_name.value == "")
		{
		alert("Please enter User's name.");
		document.mainform.user_name.select();
		return errfound;
		}
		else if(document.mainform.user_password.value =="")
		{
		alert("Please Enter Password Properly");
		document.mainform.user_password.select();
		return errfound;
		}
		else if(document.mainform.user_password.value !=document.mainform.confirm_userpassword.value )
		{
		alert("Password and Confirm Password Should Match");
		document.mainform.user_password.select();
		return errfound;
		}
		else{
			return !errfound;
			}
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
<%

	String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

%>
<br>

<form name=mainform action=UpdateUser.jsp method=post onsubmit="return LocalValidate();">
<TABLE align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE  border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor=skyblue>
<th colspan=2>CREATE NEW USER
</th>
</tr>
<%
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;
Connection conp = null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}
String user_newid= ""+L.get_master_id(conp,"Master_User");

if("0".equals(company_id))
{
%>
<tr><td>Company</td>
<td><%=A.getMasterArrayCondition(conp,"CompanyParty","CompanyParty_Id","","where company=1",company_id) %>
	 </td>
</tr>
<%}%>

<tr>
<td>Name <font class="star1">*</font></td>
<td><INPUT name=user_name size=15> </td>
</tr>

<tr>
<td>Password   <font class="star1">*</font></td>
<td><INPUT name=user_password size=15 type=password></td> 
</tr>

<tr>
<td>Confirm Password <font class="star1">*</font></td>
<td><INPUT name=confirm_userpassword size=15 type=password></td> 
</tr>

<tr>
<td>User Level</td> 
<td><%=A.getPriviledgeLevelArray(conp,"priviledge_level","23") %></td> 
</tr>

<tr>
<td>Department</td> <td> <%=A.getMasterArraySrNo(conp,"Department","department_id","")%> </td>
</tr>

<%
	C.returnConnection(conp);	


%>
<tr align=middle>
<td colSpan=2><input name=command onclick="return LocalValidate()" type=submit value="Save" class='Button1'> 
</td>
</tr>

</table>
</table>
</form>
</BODY>
</HTML>













