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
<META HTTP-EQUIV="Expires" CONTENT="0">

<script>
var errfound = false;
function LocalValidate()
	{
	/*
	errfound = false;

	if(document.mainform.user_password.value !=document.mainform.confirm_userpassword.value )
	{
		alert("Password and Confirm Password Should Match");
		document.mainform.user_password.select();
		return errfound;
	}
	else
	{
		return !errfound;
	}
	*/

	
}//validate


</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG" onload="document.mainform.path.value = document.mainform.drive.value;"
>
<br>

<form name=mainform action=BackUpDB.jsp  method=post onsubmit="return LocalValidate();">
<TABLE align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE  border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor=skyblue>
<th colspan=2>BackUp Database
</th>
</tr>
<%
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
ResultSet rs_p= null;
ResultSet rs_g= null;
Connection conp = null;
Connection cong = null;
try	{
	conp=C.getConnection();
	cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

File dirNames[] = File.listRoots();

%>
<tr>
<td colspan=2>Root Drive

<select name="drive" onchange='document.mainform.path.value = document.mainform.drive.value;window.open("../Master/BackUpFolder.jsp?command=Go&prevPath="+document.mainform.path.value,"folder"); '>
<%
for(int i=0; i<dirNames.length; i++)
{
	String rootName = dirNames[i].getPath() ;
	rootName = rootName.substring(0, (int)(rootName.length()-1));
	out.print("<option value='"+rootName+"/'>"+rootName+"</option>");

}

%>
</select>
</td>
</tr>
<!-- 
<tr>
<td>Database Password</td>
<td><INPUT name=user_password size=15 type=password></td> 
</tr>

<tr>
<td>Confirm Database Password</td>
<td><INPUT name=confirm_userpassword size=15 type=password></td> 
</tr>
 -->
<tr>
<td colspan=2>
<IFRAME name="folder" align=right src="../Master/BackUpFolder.jsp?command=Go" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="auto" align="right" width='100%'>
</IFRAME></td>
</tr>
 <input type="hidden" name="path" value="">

<script language="JavaScript">
<!--
window.open("../Master/BackUpFolder.jsp?command=Go&prevPath="+document.mainform.drive.value,"folder");
//-->
</script>
<%
	C.returnConnection(conp);	
	C.returnConnection(cong);	


%>
<tr align=middle>
<td colSpan=2><input name=command type=submit value="BackUp" class='Button1'> 
</td>
</tr>

</table>
</table>
</form>
</BODY>
</HTML>













