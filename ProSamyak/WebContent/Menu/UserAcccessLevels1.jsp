<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

 <%
	String command = request.getParameter("command");
	//out.print("<br>10 command="+command);
	Connection conp=null;
	Connection con3=null;
	conp=ConnectDB.getConnection();
	con3=ConnectDB.getConnection();
	PreparedStatement pstmt3 = null;
	PreparedStatement pstmt_p = null;
ResultSet rs3 = null;
ResultSet rs_p = null;
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

function submitValidate()
{
	if(document.theForm.UserId.value==-1)
		return false;
	else
		return true;
}
</script>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>
<body bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
	  <br>
		<br>
		<center>
		<h3>Control Panel</h3>
<form name ="theForm" action ="UserAcccessLevels1.jsp?command=Select" method ="post" onsubmit="return submitValidate()">
<input type ="hidden" name ="EntityID" value ="0">
<table align=center bordercolor=skyblue  border=1 cellspacing=0 cellpadding=0 >
<tr>
<th width="100"  align="right" >UserName</td><td>
<%
String query ="select User_Id,User_Name from Master_User where User_Id in(select distinct(UserId) from UserAuthority where Active=1) order by User_Name";



	pstmt_p = conp.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();

	String html_array ="<select name='UserId'";

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' selected >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString("User_Id").trim();		
		 String temp = rs.getString("User_Name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";

		pstmt_p.close();

%>
<%=html_array%>

</td>
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
			}
if(command.equals("Select"))
{
		 //out.print("Inside Select");
			
			String UserId = request.getParameter("UserId");
			String EntityID = request.getParameter("EntityID");
			//System.out.println("107 EntityID = "+EntityID);
			//System.out.println("108 UserId = "+UserId);
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

			response.sendRedirect("UserLevelNew.jsp?command=default&UserID="+UserId+"&EntityID="+EntityID);			
}
}
catch(Exception e)
{
	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(con3);
	out.print(e);
}
%>	