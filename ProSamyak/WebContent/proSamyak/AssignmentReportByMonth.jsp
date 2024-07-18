<%
/*
created on 16/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		16/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

%>

<%@ page language="java" 
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

		
<form action="AssignmentReport.jsp" method="post" >

						<TABLE align=center  width="30%" border=1 cellspacing=0>
						<tr >
						<th colspan =3>
						Deveploer Assignment
						</th>
						</tr>
						 <TR>
							<TH align=left>
								Month(mm)
							</TH>	
							<TD colspan="2">
								<input type="text"  name="month"  value="" size="8"> 
							</TD>
						</TR>
						
						<TR>
							<TD align=center colspan=3 >
								<INPUT type=submit tabindex=2  value='Report by Month' name="command"  >
							</TD>
						</TR>
					</TABLE>
					
					
					
</form>
</body>
</html>