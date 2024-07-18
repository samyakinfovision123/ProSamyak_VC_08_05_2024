<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />
<%
Connection con = null;  

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
int ParentID =Integer.parseInt(request.getParameter("ParentId"));

int UserId =0;//Integer.parseInt(request.getParameter("UserId"));
 
int EntityID=Integer.parseInt(request.getParameter("EntityID"));


/*out.print("ParentID"+ParentID);
 out.print("<br>Uptill ok<br>");
 out.print("<br>Uptill ok<br>");*/
	//     SET CHILD TO TRUE
 con =ConnectDB.getConnection();   

if("Insert".equals(command))
{
Boolean checkChild = true;
String query1 = " select Child from MenuMaster where MId ="+ParentID;
pstmt = con.prepareStatement(query1);
		rs1=pstmt.executeQuery();
	while(rs1.next())
	{
		checkChild = rs1.getBoolean("Child");
	}
	pstmt.close();
		if(!(checkChild))
			{
				query1 = "update MenuMaster set Child=1 where MId="+ParentID;

				pstmt = con.prepareStatement(query1);
				pstmt.executeUpdate();
			}	
			pstmt.close();
}
//
//------------------------------------------------------------------------------------
	

	if("Default".equals(command))
	{
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
<form name ="mainform" method = "post" action = "InsertRow.jsp">
		<table align=center bordercolor=skyblue  border=1 cellspacing=0 cellpadding=0 width="100%">
	<tr>
	<th colspan=2><%=entity[EntityID-1]%></th>
	</tr><tr>
	<th colspan=2>SubMenu Under <%=A.getNameCondition(con,"Menumaster","Mname","where MId="+ParentID+"")%></th></tr>
				<input name = "ParentId" type = "hidden" value="<%=ParentID%>"> 
				<input name = "UserId" type = "hidden" value="<%=UserId%>"> 
				<input name = "EntityID" type = "hidden" value="<%=EntityID%>"> 
				<!-- <input name = "Sequence" type = "hidden" value="">  -->
				<tr><td > Enter the Menu Name:</td>
					<td ><input type ="text" name = "MenuName" value = ""></td>
				</tr>
				<tr><td  > Enter the Serial No:</td>
					<td ><input type ="text" name = "SrNo" value = ""></td>
				
						
				
				<tr>
				<tr><td > Enter the Link For Menu:</td>
					<td ><input type ="text" name = "Link" value = "" size=100></td>
				
				<tr><td  > Enter the Width For Menu:</td>
					<td ><input type ="text" name = "Menu_Width" value = "" ></td></tr>
				<tr>
					<td  colspan=2 align="center">
	          <input type = "submit" name = "command" value ="Insert" class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" > </td>
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



	if("Insert".equals(command))
		{	
		//out.print("Inside Insert");
	
		java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
		String Modified_On=format.format(D);
	//out.print("Modified_On="+Modified_On);
		String MenuName = request.getParameter("MenuName");
		String Link = request.getParameter("Link");
		String Menu_Width = request.getParameter("Menu_Width");
		 EntityID = Integer.parseInt(request.getParameter("EntityID"));
		 UserId = Integer.parseInt(request.getParameter("UserId"));
		// SequenceP = Integer.parseInt(request.getParameter("SequenceP"));
		int SrNo = Integer.parseInt(request.getParameter("SrNo"));
		//System.out.println("140 SrNo="+SrNo);
		//GET SEQUENCE OF THE EXPECTED MENU POSITION
		String sqlSeq = "select Sequence from MenuMaster where ParentID = " +ParentID+ " and SrNo ="+SrNo ; 
		
		pstmtSeq = con.prepareStatement(sqlSeq);
		rsSeq=pstmtSeq.executeQuery();
		int SequenceP1=0;
		while(rsSeq.next())
			{
			SequenceP1 =rsSeq.getInt("Sequence");
			}
			pstmtSeq.close();
			//out.print("SequenceP1"+SequenceP1);
			//System.out.println("153 sqlSeq="+sqlSeq); 
		 //UPDATE SEQUENCE WHERE SEQUENCE > SPECIFIED SEQUENCE
		String sql = "update MenuMaster set Sequence = Sequence + 1  where Sequence > "+SequenceP1;
		//out.print("Sql" +sql);
		pstmt = con.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		//System.out.println("160 sql="+sql); 
		//MAKES SR NO EMPTY FOR MENU
		//out.print("<br> SrNo "+SrNo);
		//out.print("<br> ParentID  "+ParentID);
		String sqlUpdate = "update MenuMaster set SrNo = SrNo + 1 where ParentID = " +ParentID+ " and SrNo =" +SrNo ;
		pstmtUpdate = con.prepareStatement(sqlUpdate);
		pstmtUpdate.executeUpdate();
		pstmtUpdate.close();
		//System.out.println("168 sqlUpdate="+sqlUpdate); 

		String sqlSeq1 = "select No_Child from MenuMaster where MID = " +ParentID+ "" ; 
		
		pstmtSeq = con.prepareStatement(sqlSeq1);
		rsSeq=pstmtSeq.executeQuery();
		int numberOfChild=0;
		while(rsSeq.next())
			{
			numberOfChild =rsSeq.getInt("No_Child");
			}
			pstmtSeq.close();
			numberOfChild++;

		String sqlUpdate1 = "update MenuMaster set No_Child = "+numberOfChild+" where MID = " +ParentID+ " " ;
		pstmtUpdate = con.prepareStatement(sqlUpdate1);
		pstmtUpdate.executeUpdate();
		pstmtUpdate.close();
		//System.out.println("168 sqlUpdate="+sqlUpdate1); 
				
				
				//     COUNTER FINDS THE MENU ID
			String Query = "select count(*) as counter from MenuMaster";
			int cnt = 0;
			pstmt2 = con.prepareStatement(Query);
			rs = pstmt2.executeQuery();
			while(rs.next())
				{
				cnt = rs.getInt("counter");
				}
				pstmt2.close();
			//		INSERT THE MENU IN THAT EMPTY POS.
	int MenuID = cnt + 1;
	int Sequence = SequenceP1+1;
	//out.print("MenuID"+MenuID);
		String sql1 = "insert into MenuMaster(MId, MName, ParentID,  SrNo, Child, Sequence, Eid, Link, Modified_By,Menu_Width, Active, Modified_On, No_Child ) values(?,?,?,?, ?,?,?,?, ?,?, ?,?,?)";
		pstmt1 = con.prepareStatement(sql1);
		pstmt1.setString(1,""+MenuID);
		pstmt1.setString(2,MenuName);
		pstmt1.setString(3,""+ParentID);
		pstmt1.setString(4,""+SrNo);
		pstmt1.setBoolean(5,false);
		pstmt1.setString(6,""+Sequence);
		pstmt1.setString(7,""+EntityID);
		pstmt1.setString(8,""+Link);
		pstmt1.setString(9,"1");
		pstmt1.setString(10,""+Menu_Width);
		pstmt1.setString(11,"1");
		pstmt1.setString(12,""+D);
		pstmt1.setString(13,"0");
		//pstmt1.setString(10,"17/02/2005");
		int checkIn=pstmt1.executeUpdate();
		//System.out.println("201 sql1="+sql1); 
		pstmt1.close();
		ConnectDB.returnConnection(con);
		%>
			<html>
			<head>
					<script language="javascript">
						alert("record Inserted Successfully");
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