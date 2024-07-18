<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String message = ""+request.getParameter("message");
String condition="Where GIA_Filename='None' and company_id="+company_id+" ";
//order by Lot_no
String servername=request.getServerName();
//out.print("<br>servername=" +servername);

%>
<HTML>
<HEAD>
<title>GIA Rapaport Modify</title>
<script>
var errfound = false;
function LocalValidate()
	{
	errfound = false;
	if(document.f1.file.value == "")
		{
		alert("Please Select the Proper file.");
		document.f1.file.focus();
		return errfound;
		}
			else
				{
				return !errfound;
				}
		
	}

</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</HEAD>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<%
if("Default".equals(message)) 
{}else{
%>
<center>
<%="<font color=red ><b>"+message+"</b></font>"%>
</center>
<%
}
%>

<form action="GIARapaportModify.jsp" ENCTYPE="multipart/form-data" METHOD=POST name=f1 onsubmit="return LocalValidate();">
<table border=1 bordercolor=skyblue cellspacing=0 align=center valign=middle>
<tr><th colspan=2> GIA Rapaport Modify 
<tr><td>Lot No 
	<td><input type=text name=lot_id value="" size=10> 
<%//=A.getMasterArrayConditionLot("lot_id","", condition) %>
<tr><td>File 
	<td><input type=file name=file >
<tr><td colspan=2 align=center>
<input type=submit name=submitter value=Update class='Button1'>
</BODY>
</HTML>









