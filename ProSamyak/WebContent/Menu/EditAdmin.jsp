<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="C" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

 <% Connection cong = null;
 PreparedStatement pstmt_g = null;
 ResultSet rs_g =null;
	String command = request.getParameter("command");
try
{
cong = C.getConnection();
if(command.equals("default"))
{%> 
	<html>
	<head>
	<title>
	</title>
	<script language ="javascript">


	function submitForm()
	{	
		var entityNum = document.theForm.Entity.value;

		if(entityNum !=0 )
		{
			var selectedEntityID = "EntityID"+entityNum;
			var selectedEntityValue = "EntityValue"+entityNum;


			document.theForm.EntityID.value = document.theForm.elements[selectedEntityID].value; 
			document.theForm.EntityValue.value = document.theForm.elements[selectedEntityValue].value; 
			
			document.theForm.submit();
		}
		else
		{
			return false;
		}
	}
</script>
	<link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css">
</head>
<body class=bgimage onload = "" bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<center>

<form name ="theForm" action ="EditAdmin.jsp?command=Select" method ="post" onSubmit ="verify(this)">
<table align=center bordercolor=skyblue  border=1 cellspacing=2 cellpadding=2 >
<tr><th colspan=2>Edit Control Panel</th></tr>
<tr><td width="100" height="19" align="center" > Entity </td>
<td width="100" height="19" align="center" ><%
String query ="select Eid, EName from Entity Where Active=1 and EName <> 'Admin'";

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
String html_array ="<select name='Entity' onChange='submitForm()'>";
 html_array = html_array +"<option value='0'>Select</option>"; 
int i=1;
while(rs_g.next())
{
	 String temp1 = rs_g.getString("Eid");		
	 String temp = rs_g.getString("EName");
	 
	 html_array = html_array +"<option value='"+temp1 +"'>"+temp+"</option>"; 

	out.print("<input type=hidden name='EntityID"+temp1+"' value='"+temp1+"'>");
	out.print("<input type=hidden name='EntityValue"+temp1+"' value='"+temp+"'>");
	i++;
}
html_array = html_array +" </select> ";
pstmt_g.close();

out.print(html_array);
%>
</td>
	<input type ="hidden" name = "EntityID" value ="">
	<input type ="hidden" name = "EntityValue" value ="">
		
</table>
</form>
</body>
</html>

<%	}
	
if(command.equals("Select"))
{
		// out.print("Inside Select");
			String UName = request.getParameter("UserName");
			String EntityID = request.getParameter("EntityID");
			

			response.sendRedirect("EditMenu.jsp?command=default&EntityID="+EntityID);			
}
C.returnConnection(cong);
}
catch(Exception e)
{
	C.returnConnection(cong);
	out.print(e);
}
%>	