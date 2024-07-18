
<%

/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2	   Anil			23-04-2011	Done		    To Access on Server
* 3    Mr Ganesh	    26-04-2011  Done        To version control
* 4	   Anil			26-04-2011  done            TL 2 Version Control
* 5   GaneshG Srikant 21-05-2011 done           Report To display datewise
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
	
	%>
	<form action="Report.do" method="post" target="_blank">
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
	<%= A.getDropDown(cong,"masterEngineer","engineerId", "engineerName","masterEngineerTable","43"," where active = 1  and CurrentActive=1")%>
	
	</td>
	</tr>
	<tr>
	<th>
	Attendance type
	</td>
	<td>
	<input type=radio name=day value='7' Checked  >&nbsp;7days&nbsp;<br>
	<input type=radio name=day value='15' >&nbsp;15days&nbsp;<br>
	<input type=radio name=day value='30' >&nbsp;30days&nbsp;<br>
	
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