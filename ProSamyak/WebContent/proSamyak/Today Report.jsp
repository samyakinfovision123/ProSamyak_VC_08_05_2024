
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy					Date			Status									Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    Shrikant,Ganesh Giranar		17/05/2011	 	start 		Adding present & absent button for today's present engineers 

-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form name=f1 action="present.jsp" method="post" >
<center>
<table>
<tr><td>
<input type="submit" value="Present" name="Present"></input></td>
</tr>
</table>

</center>

</form>
<form action="absent.jsp" method="post">
<table align=center>
<tr>
<td>
<input type="submit" value="Absent" name="Absent"></input>
</td>
</tr>

</table>
</form>

</body>
</html>