<%-- 
		Project	     --  Nippon
		File Name    --  PictureModifyForm.jsp
		Modified By  --  Vaibhav Patil
		Description  --  Original File
		Date         --  December 30 2005
--%>

	<!--import packages-->
	<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<% 
	String company_id= ""+session.getValue("company_id");
	String message = ""+request.getParameter("message");
	String condition="Where Drwg_FileName='None' and company_id="+company_id+" ";
%>
	<HTML>
	<HEAD>
	<script>
	var errfound = false;
	function LocalValidate(){
		errfound = false;
		if(document.f1.file.value == ""){
			alert("Please Select the Proper file.");
			document.f1.file.focus();
			return errfound;
		}//eo if
		else{
			return !errfound;
		}//eo else.
	}//eo function LocalValidate
	</script>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	</HEAD>
	<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<%
		if("Default".equals(message)){
		
		}
		else{
		%>
			<center>
			<%="<font color=red ><b>"+message+"</b></font>"%>
			</center>
		<%
		}//eo else.
		%>

		<form action="PictureModify.jsp" ENCTYPE="multipart/form-data" METHOD=POST name=f1 onsubmit="return LocalValidate();">
		<table border=1 bordercolor=skyblue cellspacing=0 align=center 	valign=middle>
		<tr>
			<th colspan=2 >Modify Picture
		<tr>
			<td>Lot No 
			<td><input type=text name=lot_id value="" size=10> 
		</tr>
		<tr>
			<td>File 
			<td><input type=file name=file>
		<tr>
			<td colspan=2 align=center>
			<input type=submit name=submitter value=Update class='Button1'>
		</tr>
		</BODY>
		</HTML>

		<%--End Of PictureModifyForm.jsp--%>







