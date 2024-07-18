<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />
<%
Connection con = null;  
Connection cong = null;  

PreparedStatement pstmt = null; 
PreparedStatement pstmtUpdate = null; 
PreparedStatement pstmtSeq = null; 
  
PreparedStatement pstmt2 = null;
PreparedStatement pstmt1 = null;
ResultSet rs = null;//to set counter
ResultSet rs1 = null;//to check child
ResultSet rsSeq = null;//to check child

%>
<%
try
{
	

String command = request.getParameter("command");
int MenuId =Integer.parseInt(request.getParameter("MenuId"));
//System.out.println("28 MenuId="+MenuId);
int UserId =0;//Integer.parseInt(request.getParameter("UserId"));
 
int EntityID=Integer.parseInt(request.getParameter("EntityID"));


/*out.print("ParentID"+ParentID);
 out.print("<br>Uptill ok<br>");
 out.print("<br>Uptill ok<br>");*/
	//     SET CHILD TO TRUE
 con =ConnectDB.getConnection();   
 
	if("Default".equals(command))
	{

boolean checkChild = false;
boolean active = false;
String menuname="";
String srno="";
String link="";
String chk="";
String rd="";
String ParentID="";
String Menu_Width="";
String query1 = " select MName,ParentID, SrNo, Link, Menu_Width, Child, Active, No_Child from MenuMaster where MId ="+MenuId;
//out.print("<BR>"+query1);
pstmt = con.prepareStatement(query1);
		rs1=pstmt.executeQuery();
		//System.out.println("55 query1="+query1);
	while(rs1.next())
	{
		menuname=rs1.getString("MName").trim();
		//System.out.println("59 menuname="+menuname);
		ParentID=rs1.getString("ParentID").trim();
		//System.out.println("61 ParentID="+ParentID);
		srno=rs1.getString("SrNo").trim();
		//System.out.println("63 srno="+srno);
		link=rs1.getString("Link");
		//System.out.println("65 link="+link);
		if(rs1.wasNull()){
		link="-";
		}
		//System.out.println("64 link="+link);
		Menu_Width=rs1.getString("Menu_Width").trim();
		checkChild = rs1.getBoolean("Child");
		int childNo = rs1.getInt("No_Child");
		active = rs1.getBoolean("Active");
		//out.println("73 childNo="+childNo);
		if(active)
		{chk="checked";}
		//if(checkChild)
		//{rd="onclick=\"this.checked=true;\"";}
		cong =ConnectDB.getConnection();   
		String parentActive = A.getNameCondition(cong, "MenuMaster", "Active", "where MId="+ParentID);
		//out.println("83 parentActive="+parentActive);
		ConnectDB.returnConnection(cong);   
		if(parentActive.equals("0"))
		{rd="onclick=\"this.checked=false;alert('Make the Parent link active first');\"";}
		if(childNo != 0)
		{rd="onclick=\"this.checked=true;alert('Make the child links inactive first');\"";}
	}
	pstmt.close();
//
//------------------------------------------------------------------------------------
	

String entity[]=new String[4];
entity[0]="";
entity[1]="Global";
entity[2]="India";
entity[3]="Overseas";


%>
<html>
	<head>
					<script language="javascript">
					function CancelBack()
					{
						history.back(1);
					}
					</script>
<link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css">
<link href="../Samyak/tablecss.css" rel="stylesheet" type="text/css">
</head>

<body class=bgimage onload = "" bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<form name ="mainform" method = "post" action = "EditRow.jsp">
		<table align=center bordercolor=skyblue  border=1 cellspacing=0 cellpadding=0 width="100%">
	<tr>
	<th colspan=2><%=entity[EntityID-1]%></th>
	</tr><tr>
	<th colspan=2>Edit <%=menuname%></th></tr>
				<input name = "MenuId" type = "hidden" value="<%=MenuId%>"> 
				<input name = "ParentID" type = "hidden" value="<%=ParentID%>"> 
				<input name = "UserId" type = "hidden" value="<%=UserId%>"> 
				<input name = "EntityID" type = "hidden" value="<%=EntityID%>"> 
				<!-- <input name = "Sequence" type = "hidden" value="">  -->
				<tr><td > Enter the Menu Name:</td>
					<td ><input type ="text" name = "MenuName" value = "<%=menuname%>"></td>
				</tr>
				<tr><td  > Enter the Serial No:</td>
					<td ><input type ="text" name = "SrNo" value = "<%=srno%>"></td>
				
				<tr>
				<tr><td  > Enter the Link For Menu:</td>
					<td  > <input type ="text" name = "Link" value = '<%=link%>' size=100> </td></tr>

				<tr>
				<tr><td  > Enter the Width For Menu:</td>
					<td  > <input type ="text" name = "Menu_Width" value = "<%=Menu_Width%>" > </td></tr>

				
				<tr><td>Active</td>
					<td>
					<input type=checkbox name=active 
					<%=chk%>  <%=rd%> >
					</td>
					
				<tr>
					<td  colspan=2 align="center">
	          <input type = "submit" name = "command" value ="Update" class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" > </td>
					<!-- <td  width="100" height="19" align="center">
	          <input type = "button" name = "command" value ="Cancel" onClick ="CancelBack()"> -->
			  </td>
				</tr>
		</table>
</form>
</body>
</html>
<%//------------------------------------------------------------------------------------

ConnectDB.returnConnection(con);
	}//if default



	if("Update".equals(command))
		{	
		//out.print("Inside Insert");
	
		java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
		String Modified_On=format.format(D);
	//out.print("Modified_On="+Modified_On);
		String MenuName = request.getParameter("MenuName");
		String ParentID = request.getParameter("ParentID");
		String Link = request.getParameter("Link");
		String Menu_Width = request.getParameter("Menu_Width");
		String active = request.getParameter("active");
		//System.out.println("155 active="+active);
		boolean act=false;
		if("on".equals(active)){act=true;}
		 EntityID = Integer.parseInt(request.getParameter("EntityID"));
		 UserId = Integer.parseInt(request.getParameter("UserId"));
		// SequenceP = Integer.parseInt(request.getParameter("SequenceP"));
		int SrNo = Integer.parseInt(request.getParameter("SrNo"));
	
		//GET SEQUENCE OF THE EXPECTED MENU POSITION
		
		String sql1 = "Update  MenuMaster set MName=?, SrNo=?, Link=?,EID=? ,Menu_Width=?, Active=? where MID=?";
		pstmt1 = con.prepareStatement(sql1);
		pstmt1.setString(1,MenuName);
		pstmt1.setString(2,""+SrNo);
		pstmt1.setString(3,""+Link);
		pstmt1.setInt(4,EntityID);
		pstmt1.setString(5,""+Menu_Width);
		pstmt1.setBoolean(6,act);
		pstmt1.setString(7,""+MenuId);
		//System.out.println("174 sql1="+sql1);
		int checkIn=pstmt1.executeUpdate();	
		pstmt1.close();


String Query = "select count(*) as counter from MenuMaster where ParentID="+ParentID+" and active=1";
			int cnt = 0;
			pstmt2 = con.prepareStatement(Query);
			rs = pstmt2.executeQuery();
			//System.out.println("183 Query="+Query);
			while(rs.next())
				{
				cnt = rs.getInt("counter");
				}
				pstmt2.close();


 sql1 = "Update  MenuMaster set No_Child=? where MID=?";
		pstmt1 = con.prepareStatement(sql1);
		pstmt1.setString(1,""+cnt);
		pstmt1.setString(2,""+ParentID);
		checkIn=pstmt1.executeUpdate();	
		//System.out.println("196 sql1="+sql1);
		pstmt1.close();


		
Query = "select count(*) as counter from MenuMaster where ParentID="+MenuId+" and Active=1";
			 cnt = 0;
			pstmt2 = con.prepareStatement(Query);
			rs = pstmt2.executeQuery();
			while(rs.next())
				{
				cnt = rs.getInt("counter");
				}
				pstmt2.close();


 sql1 = "Update  MenuMaster set No_Child=? where MID=?";
		pstmt1 = con.prepareStatement(sql1);
		pstmt1.setString(1,""+cnt);
		pstmt1.setString(2,""+MenuId);

		 checkIn=pstmt1.executeUpdate();	
		pstmt1.close();

//if active childs are zero then you can disable the link
		String ActiveQuery = "select count(*) as counter from MenuMaster where ParentID="+ParentID+" and active=1 ";
		int activecnt = 0;
		pstmt2 = con.prepareStatement(ActiveQuery);
		rs = pstmt2.executeQuery();
		while(rs.next())
		{
			activecnt = rs.getInt("counter");
			//System.out.println("<br>251 activecnt="+activecnt);
		}
		pstmt2.close();

		if(activecnt == 0)
		{
			sql1 = "Update  MenuMaster set No_Child=? where MID=?";
			pstmt1 = con.prepareStatement(sql1);
			pstmt1.setString(1,""+activecnt);
			pstmt1.setString(2,""+ParentID);
			checkIn=pstmt1.executeUpdate();	
			//System.out.println("196 sql1="+sql1);
			pstmt1.close();
		}


ConnectDB.returnConnection(con);

		%>
			<html>
			<head>
					<script language="javascript">
						alert("record Updated Successfully");
						window.opener.history.go(0);
						window.close();
						//history.back(1);
					</script>

			</head>
			<body>
			</body></html>
		<%
	}
	
}//--------------------------------------------------------------------------------------------------------
catch(Exception e)
{
	ConnectDB.returnConnection(con);

	out.println(e);
}
%>