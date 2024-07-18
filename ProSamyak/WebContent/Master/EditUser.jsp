<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
/*
try	
{
	conp=C.getConnection();
}
catch(Exception e31)
{ 
out.println("<font color=red> FileName : EditUser.jsp<br>Bug No e31 : "+ e31);
}
*/

String command = request.getParameter("command");
//out.print("<br>command="+command);
String query="";
	String message=request.getParameter("message"); 

try{
	
if("edit".equals(command))
{
	conp=C.getConnection();
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}
query="Select * from Master_User where Company_Id<>0";
 pstmt_p  = conp.prepareStatement(query);
	//pstmt_p.setString(1,company_id);
	//pstmt_p.setString(2,user_level);
	rs_g = pstmt_p.executeQuery();

%>
<HTML>
<HEAD>
<TITLE> Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<br>

<form name=mainform action=UpdateUser.jsp method=post >
<TABLE align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE  border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor=skyblue>
<th colspan=8>Edit User
</th>
</tr>
<tr>
<th>Name </th><th>Password</th><th>User Level</th> <th>Department</th><th>Active</th></tr>
<%int i=0;
	while(rs_g.next())
		{
String str="";
String act=rs_g.getString("Active");
if("1".equals(act))
			{str="checked";}
	%>
<tr>
<td><INPUT type=text name=user_name<%=i%> size=15 value="<%=rs_g.getString("User_Name")%>" > 
<INPUT name=user_id<%=i%> type=hidden value="<%=rs_g.getString("User_Id")%>" > 
	</td>
<td><INPUT name=user_password<%=i%> size=15 type=password value="<%=rs_g.getString("User_Password")%>"></td> 
<td><%
	String priviledge_level = rs_g.getString("Priviledge_Level");
	if(rs_g.wasNull())
	{
		out.print("-----");
	}
	else
	{
		out.print(A.getPriviledgeLevelArray(conp,"priviledge_level"+i,priviledge_level));
		
	}%></td> 
<td> <%=A.getMasterArraySrNo(conp,"Department","department_id"+i,rs_g.getString("Department_Id"))%> </td>
<td><input type=checkbox name=active<%=i%> value=yes <%=str%>>
		</td>
</tr>

<%i++;
	}//while
		pstmt_p.close();
		%>

<tr align=center>
<input type=hidden name=counter value="<%=i%>">
<td colSpan=8><input name=command type=submit value="Update" class='Button1'> 
</td>
</tr>

</table>
</table>
</form>
</BODY>
</HTML>
<%
	C.returnConnection(conp);
	}

}// if edit
catch(Exception e116)
{ 
out.println("<font color=red> FileName : EditUser.jsp<br>Bug No e116 : "+ e116);
}

%>








