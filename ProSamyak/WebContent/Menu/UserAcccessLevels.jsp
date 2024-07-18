<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

 <%
	String user_id=""+session.getValue("user_id");
	String command = request.getParameter("command");
	Connection cong=null;
	Connection conp=null;
	Connection con3=null;
	cong=ConnectDB.getConnection();
	conp=ConnectDB.getConnection();
	con3=ConnectDB.getConnection();
	PreparedStatement pstmt3 = null;
ResultSet rs3 = null;
String entity_id = A.getNameCondition(cong,"UserAuthority","Eid", "where userid="+user_id);

//out.print("entity_id "+entity_id);

 %>
<%
try
{
if(command.equals("default"))
{
	//String EntityValue =request.getParameter("EntityValue");
	//int EntityID = Integer.parseInt(request.getParameter("EntityID"));
	
%>
<html>
<head>
<script language ="javascript">
function submitForm()
{	
document.theForm.submit();
	}
</script>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>
<body bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<br>
<br>
<center>
		<h3>Control Panel</h3>
<form name ="theForm" action ="UserAcccessLevels.jsp?command=Select" method ="post" >
<input type ="hidden" name ="EntityID" value ="0">
<table align=center bordercolor=skyblue  border=1 cellspacing=0 cellpadding=0 >
<tr>
	<th width="100"  align="right" >UserName</td><td><%=A.getMasterArray(conp,"User","UserId","")%></td>
</tr>
<tr >
<!-- <td>&nbsp;</td>
 --><td colspan=2 align=center > <input type=submit name=command value=Select class='Button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
</table>
</form>
</body>
</html>
<%
    ConnectDB.returnConnection(con3);	
	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
}


if(command.equals("Select"))
{
		// out.print("Inside Select");
			String UserId = request.getParameter("UserId");
			String EntityID = request.getParameter("EntityID");
			//out.print("75 <br> EntityID = "+EntityID);
			//out.print("75 <br> UserId = "+UserId);
			/*String  sql11 = "select User_Id from Master_User where User_Name='"+UName+"'"; 
			out.print("Sql"+sql11);
			pstmt3 = con3.prepareStatement(sql11);
			rs3= pstmt3.executeQuery();
					int UID=0;
				while(rs3.next())
				{
					UID = rs3.getInt("User_Id");
				} 
			*/
			ConnectDB.returnConnection(con3);	
			ConnectDB.returnConnection(conp);
			ConnectDB.returnConnection(cong);

			response.sendRedirect("UserLevel.jsp?command=default&UserID="+UserId+"&EntityID="+EntityID);			
}
}
catch(Exception e)
{
	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(con3);
	out.print(e);
}
%>	