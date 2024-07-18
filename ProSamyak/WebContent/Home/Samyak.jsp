<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%
String Flag=request.getParameter("Flag");
//System.out.println("flag=->"+Flag);
System.out.println(" 6 Samyak.jsp flag=:- "+Flag);
String company_id= ""+session.getValue("company_id");
String category_code= ""+session.getValue("category_code");
System.out.println(" 8 Samyak.jsp category_code=:- "+category_code);

System.out.println(" 6 Samyak.jsp flag=:- "+Flag);
%>
<html>
<head>
<script>
function b(str)
{
	var Flag1='<%=Flag%>';
	//var Flag1='<%=Flag%>';

	if(Flag1=="admin")
	{
		window.open("AdminFrame.html","_blank", ["Top=0","Left=0" , "Height=690", "Width=1020","Toolbar=no", "Location=0", "Menubar=no", "Resizable=yes", "Scrollbars=Auto", "status=yes"])
	}
	else
	{
		window.open("OverseasSparkler.html","_blank", ["Top=0","Left=0" , "Height=690", "Width=1020","Toolbar=no", "Location=0", "Menubar=no", "Resizable=yes", "Scrollbars=Auto", "status=yes"])
	}
	window.close();
}
function c(str)
{
	var Flag1='<%=Flag%>';
	//var Flag1='<%=Flag%>';

	if(Flag1=="admin")
	{
		window.open("AdminFrame.html","_blank", ["Top=0","Left=0" , "Height=690", "Width=1020","Toolbar=no", "Location=0", "Menubar=no", "Resizable=yes", "Scrollbars=Auto", "status=yes"])
	}
	else
	{
		window.open("IndiaSparkler.html","_blank", ["Top=0","Left=0" , "Height=690", "Width=1020","Toolbar=no", "Location=0", "Menubar=no", "Resizable=yes", "Scrollbars=Auto", "status=yes"])
	}
	window.close();
}

</script>
<title>Samyak Software</title>
<link href='../Dove/dovecss.css' rel=stylesheet type='text/css'>
</head>
<!-- <body scroll="no" background="../buttons/bgcolor.jpg"> -->
<%
if("3".equals(category_code))
{
	%>		
<body vlink="blue" alink="red" link="blue" background="../buttons/bgcolor.jpg"  onload='c()'>
<%
	}else {
%>
<body vlink="blue" alink="red" link="blue" background="../buttons/bgcolor.jpg"  onload='b()'>

<%
	}
%>
</body>


</html>

