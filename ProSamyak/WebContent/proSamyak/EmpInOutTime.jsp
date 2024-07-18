
<%

/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2		Anil			23-04-2011	Done		To Access on Server
* 3   Mr Ganesh	        26-04-2011  Done        To version control
* 4		Anil			26-04-2011  done        TL 2 Version Control
* 5		chanchal		14-05-2011  done       default data set
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
%>

<%@ page language="java" import="java.sql.Connection ,java.sql.Timestamp , java.sql.Date , NipponBean.Array"
contentType="text/html; charset=ISO-8859-1"
 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 <jsp:useBean id="C" scope="page" class="NipponBean.Connect" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script language="javascript" src="../SamyakJS/cal/proSamyak.js"></script>
<title>Insert title here</title>

</head>
<body>

	<%
	Connection cong = null;
	try 
	{		
		cong = C.getConnection();
		Array A = new Array ();
		String save = String.valueOf(request.getAttribute("save"));
	/* 	String Date=System.currentTimeMillis(); */
	
	%>
	<form action="Report-Add.do" method="post" >
	<table width="40%"  align="center" bordercolor="gray" border="2">
	<%
				if ( !( save.equalsIgnoreCase("NULL")))
				{%>
				<tr>
				<td colspan="2" align="center">
				<%=save %>	
				</td>
				</tr>
				<%
				}
	%>
	<tr>
	<th>
	Engg Name 
	</th>
	<td>
	<%= A.getDropDown(cong,"masterEngineer","engineerId", "engineerName","masterEngineerTable","52"," where active = 1  and CurrentActive=1")%>
	
	</td>
	</tr>
	<tr>
	<th>
	yyyy-mm
	</th>
	<td>
	<input type="text" name="yearmonth" value="2011-05" />
	</td>
	</tr>
	<tr>
	<td align="center" colspan="2">
	<%
	if ( !( save.equalsIgnoreCase("NULL")))
	{%>
		<input type="submit" value="Report"  name="inOut" disabled="disabled" />
	<% }else
	{
	%>
	<input type="submit" value="Report"  name="command" />
	<%
	}
	%>
 	</td>
	</tr>
	</table>
	</form>
	<%
	}catch(Exception e)
	{
	e.printStackTrace() ;	
	}finally
	{
	C.returnConnection(cong);	
	}
	
	%>
</body>
</html>