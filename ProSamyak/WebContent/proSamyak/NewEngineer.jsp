<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<% 
//out.print("Inside ");
	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String command=request.getParameter("command");
	String message=request.getParameter("message");
	String Master=request.getParameter("Master");
	String master=request.getParameter("master");

	ResultSet rs= null;
	Connection con = null;
	PreparedStatement pstmt=null;
	try
	{
		con=C.getConnection();
	
		String query="";
		int srno=1;
		String selectquery ="Select * from master"+Master+" "; 
		pstmt = con.prepareStatement(selectquery);
		rs = pstmt.executeQuery();	
		while(rs.next())
		{
			srno++;
		}
		//out.print("nameexist"+nameexist);
		pstmt.close();
	//	C.returnConnection(con);
		java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
		String today_string= format.format(D);
		
%>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<SCRIPT LANGUAGE="JavaScript">
function chk()
	{
		document.NewEngineer.name1.select();
	}
</SCRIPT>
<HTML>
<HEAD>
<TITLE> New <%=Master%> </TITLE>
</HEAD>
<BODY background="../Buttons/BGCOLOR.JPG" onLoad='chk();'>
<form name=NewEngineer  action="UpdateEngineer.jsp" method=post>
<%
	if("Default".equals(message))
	{
			
	}else if(message!=null)
	{
		out.println("<center><font class='message1'> "+message+"</font></center>");
	}

	if("Default".equals(command))
	{		
%>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
	<tr>
		<td>
			<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >
			<tr bgcolor=skyblue>
			<th colspan=4>Add New <%=Master%> </th>
		</tr>
		<tr>
			<td>Sr No</td>
			<td>
				<input type=text name=sr_no size=6 value='<%=srno%>'>
				<input type=hidden name=active value=yes >
			</td>
		</tr>
		<tr>
			<td>Name <font class="star1">*</font></td>
			<td colSpan=3>
				<input type=text name=name1 size=25 >
			</td>
		</tr>
		<tr>
			<td>Description<font class="star1">*</font></td>
			<td colSpan=3>
				<INPUT type=text name=description1 size=25 >
				<input type=hidden name=sr_no size=6 value='1'>
				<input type=hidden name=master size=6 value=<%=master%>>
				<input type=hidden name=Master size=6 value=<%=Master%>> 
			</td>
		</tr>
		<tr>
			<td colspan=2 align="center"><a href="UpdateEngineer.jsp?command=Edit&Master=<%=Master%>&master=<%=master%>"><font class="star1"> Edit</font></a>
			</td>
			<td colspan=2 align='center'>
				<input type=submit name=command value='Add' class='Button1'>
			</td>
		</tr>
	</table>
</td>
</tr>
</table>
</form>
<%
		}//if....
	C.returnConnection(con);
	}//try.........
	catch(Exception e31)
	{ 
		C.returnConnection(con);
		out.println("<font color=red> FileName : NewEngineer.jsp<br>Bug No e31 : "+ e31);
	}
	%>
</BODY>
</HTML>