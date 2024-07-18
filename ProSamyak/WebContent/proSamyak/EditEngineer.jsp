<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

		<% 
			String company_id= ""+session.getValue("company_id");
			System.out.print("company_id"+company_id);
			String Id = request.getParameter("Id");
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
		%>

<HTML>
<HEAD>
<TITLE>Samyak Software- India </TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body background="../Buttons/BGCOLOR.JPG">

<form name=EditEngineer  action="UpdateEngineer.jsp" method=post >

<!-- onsubmit="return Validate();" -->
	<%
			if("Default".equals(message))
			{
						
			}
			else if(message!=null)
			{
			out.println("<center><font class='message1'> "+message+"</font></center>");
			}

			String name="";
			String desc="";
			String active="";
			String tempCheck="";
			int sr_no=0;

			query="Select srNo,"+master+"Name,"+master+"Description,active from master"+Master+" where "+master+"Id="+Id+""; 
			
			pstmt = con.prepareStatement(query);
			//out.print("<br>29 query= "+query);
			rs= pstmt.executeQuery();	
			int count=0;
				while(rs.next())
				{	
				name=rs.getString(""+master+"Name");
				desc=rs.getString(""+master+"Description");
				sr_no=rs.getInt("srNo");
				active=rs.getString("active");
				//out.print("<br>active"+active);
				
				if("1".equals(active))
				{
				//out.print("<br>In If loop");
				tempCheck = " checked " ;
				}	
				}
			pstmt.close();
	%>


<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
	<tr><td>
		<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >
		<tr bgcolor=skyblue>
			<th colspan=4>Edit <%=Master%> </th>
		</tr>

		<tr><td>Sr No</td>
			<td><input type=text name=sr_no size=6 value='<%=sr_no%>' Onblur="Validate(this)" >
		</tr>

		<tr><td>Name <font class="star1">*</font></td>
			<td colSpan=3><input type=text name=name1 size=25  value="<%=name%>"></td>
		</tr>

		<tr><td>Description <font class="star1">*</font></td>
			<td colspan=3><INPUT type=text name=desc size=25  value="<%=desc%>">
			<input type=hidden name=mId size=6 value=<%=Id%>>
			<input type=hidden name=master size=6 value=<%=master%>>
			<input type=hidden name=Master size=6 value=<%=Master%>> </td>
		</tr>

		<tr><td>Active</td> 
			<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>
		</tr>

		<tr><td colspan=4 align='center'>
			<input type=submit name=command value="Update" class='Button1'></td>
		</tr>
			</table>
			</td>
	</tr>
</table>
</form>
</body>
</html>
		<%
			C.returnConnection(con);
		}
		catch(Exception e31)
		{ 
			C.returnConnection(con);
			out.println("<font color=red> FileName : NewEngineer.jsp<br>Bug No e31 : "+ e31);
		}
		%>

