<%@page language="java" import="java.sql.*,java.io.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="format"  scope="application"   class="NipponBean.format" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<%
	String user_id= ""+session.getValue("user_id");
	String machine_name=request.getRemoteHost();
	Connection con=null;
	ResultSet rs_g=null;
	Statement stmt=null;
	PreparedStatement pstmt=null;
	String query="";
	int counter=0;
	int errLine = 15;
	int i=0;
	String command=request.getParameter("command");
	String message=request.getParameter("message");
	String title1="";
	String description1="";
	int engid=0;
	int project_id=0;
	int type_id=0;
	int priority_id=0;
	int assignment_id=0;

if("Default".equals(command))
{
	if(message!=null)
		out.println("<center><font class='message1'> "+message+"</font></center>");
	try
	{
		con=C.getConnection();
		/*****************************
		query="select count(*) as counter from masterProject";
		stmt=con.createStatement();
		rs_p=stmt.executeQuery(query);
	
		while(rs_p.next())
		{
			counter=rs_p.getInt(counter);
		}
		stmt.close();
		*****************************/
		//String employee_name1=request.getParameter("ename");
%>
			
<html>
	<head>
		<title>Report Form</title>
	</head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<body background="../Buttons/BGCOLOR.JPG">
		<form name=reportform method="post" action="ReportForm.jsp">
			<table border=1 borderColor=skyblue align=center cellspacing=0 cellpadding=2 align=center>
				<tr>
					<td>
						<table borderColor=blue border=0 WIDTH="100%" cellspacing=2 cellpadding=2>
							<tr bgcolor="skyblue">
								<th colspan=4 align=center>
									Report Form
								</th>
							</tr>

							<tr>
								<td colspan=3><hr></td>
							</tr>

							<tr>
								<td>
									<p>From Date : 
								</td>
							<%
									java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
									//String today_string = format.format(D);
									//out.print("today_string : "+D);
							%>
								<td>
									<%= L.date(D,"dd1","mm1","yy1")%>
								</td>
							</tr>

							<tr>
								<td colspan=4><hr></td>
							</tr>

							<tr>
								<td>
									<p>To Date : 
								</td>
								<td>
									<%= L.date(D,"dd2","mm2","yy2")%>
								</td>
							</tr>

							<tr>
								<td colspan=4><hr></td>
							</tr>

							<tr>
								<td>
									<p>Select Engineer Name  : 
								</td>
								<%			
										query = "select count(*) as counter from masterEngineer";
							errLine = 50;
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
							errLine = 53;
										while(rs_g.next())
										{
											counter = rs_g.getInt("counter");
										}
										pstmt.close();

										String ename1[]=new String[counter];
										String eid1[]=new String[counter];

										query = "select  engineerId,engineerName from masterEngineer";
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
										
										//int i=0;
										while(rs_g.next())
										{
											errLine = 97;
											eid1[i] = rs_g.getString("engineerId");
											ename1[i] = rs_g.getString("engineerName");
											i++;
											errLine=101;
										}
										pstmt.close();%>
								<td>
										<select name="ename" size=3 multiple>
										<%for(int j=0;j<counter;j++)
											{
											errLine=107;
											if(j==0)
												{
												%>
											<option value=<%=eid1[j]%> selected><%=ename1[j]%></option>
											<%}
											else
											{%>
											<option value=<%=eid1[j]%>><%=ename1[j]%></option>		
											<%
											}
										}%>
										</select>
									</td>
							</tr>
		
							<tr>
								<td colspan=4><hr></td>
							</tr>

							<tr>
								<td>
									<p>Project Name : 
								</td>
								<%		
										query = "select count(*) as counter from masterProject";
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
										while(rs_g.next())
										{
											counter = rs_g.getInt("counter");
										}
										pstmt.close();

										String pname1[]=new String[counter];
										String pid1[]=new String[counter];

										query = "select projectId,projectName from masterProject";
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
										 i=0;
										while(rs_g.next())
										{
											errLine=137;
											pid1[i]=rs_g.getString("projectId");
											pname1[i]=rs_g.getString("projectName");
											i++;
											errLine=141;
										}
										pstmt.close();
							
										%>
									<td>
										<select name="pname" size=3 multiple>
										<%for(int j=0;j<counter;j++){
											errLine=149;
											if(j==0)
											{%>
											<option value=<%=pid1[j]%> selected><%=pname1[j]%></option>
											<%}
											else
											{%>
											<option value=<%=pid1[j]%>><%=pname1[j]%></option>		
											<%
											}
										}%>
										</select>
									</td>
							</tr>

							<tr>
								<td colspan=4><hr></td>
							</tr>

							<tr>
								<td>	
									<p>Work Status : 
								</td>
								</td>
								<%																	
										query = "select count(*) as counter from masterStatus";
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
										while(rs_g.next())
										{
											errLine=291;
											counter = rs_g.getInt("counter");
										}
										pstmt.close();

										String status1[]=new String[counter];
										String statusid1[]=new String[counter];

										query = "select statusId,statusName from masterStatus";
										pstmt = con.prepareStatement(query);
										rs_g = pstmt.executeQuery();
										i=0;
										errLine=303;
										while(rs_g.next())
										{
											statusid1[i]=rs_g.getString("statusId");
											status1[i]=rs_g.getString("statusName");
											i++;
											errLine=309;
										}
										pstmt.close();%>
										<td>
										<select name="statusname" size=1>
										<%for(int j=0;j<counter;j++){%>
											<option value=<%=statusid1[j]%>><%=status1[j]%></option>
											<%}%>
										</select>
									</td>
							</tr>
							
							<tr bgcolor="skyblue">
								<th colspan=4 align=center>
									Display Criteria
								</th>
							</tr>
							<tr>
								<td>
									<input type=checkbox name=tdate value='yes'>Target Date
								</td>
							</tr>
							<tr>
								<td>Order By : </td>
								<td>
									<select name="orderby" size=1>
										<option value="startedOn">Start Date</option>
										<option value="targetedOn">Target Date</option>
										<option value="completedOn">Complete Date</option>
									</select>
								</td>
							</tr>
							<%
								C.returnConnection(con);
							}catch(Exception e)
							{
								C.returnConnection(con);
								out.print("Error Occured!!!!!!!!!!!! at "+errLine+" is "+e);
							}
						%>
							<tr>
								<td colspan=4 align=center>
									<input type="submit" name="command" value="NEXT" style="height:30px; width:60px; background:#D3D5A8; font-size:16">
								</td>
							</tr>
				</table>
			</table>
		</form>
	</body>
</html>
<%
}%>


<%
if("NEXT".equals(command))
{
	try
	{
		con=C.getConnection();

		String ename1[]=new String[0];
		String pname1[]=new String[0];
		ename1=request.getParameterValues("ename");
		pname1=request.getParameterValues("pname");
		
		String status1=request.getParameter("statusname");
		
		String tdate=request.getParameter("tdate");
		String orderby=request.getParameter("orderby");
		//out.print("orderby==>>"+orderby);

		String enameid="";
		String projectid="";
		for(int k=0;k<ename1.length;k++)
		{
			if(k==0)
			{enameid=ename1[k];}else{enameid=enameid+","+ename1[k];}
		}
		for(int k=0;k<pname1.length;k++)
		{
			if(k==0)
			{projectid=pname1[k];}else{projectid=projectid+","+pname1[k];}
		}
		//out.print("ename1===>"+ename1);
		//out.print("pname1===>"+pname1);

		int d1=Integer.parseInt(request.getParameter("dd1"));
		int m1=Integer.parseInt(request.getParameter("mm1"));
		int y1=Integer.parseInt(request.getParameter("yy1"));
		int d2=Integer.parseInt(request.getParameter("dd2"));
		int m2=Integer.parseInt(request.getParameter("mm2"));
		int y2=Integer.parseInt(request.getParameter("yy2"));
		
		java.sql.Date date1=new java.sql.Date((y1-1900),(m1-1),d1);
		java.sql.Date date2=new java.sql.Date((y2-1900),(m2-1),d2);

		//out.print(" +++From Date===>"+date1);
		//out.print(" +++To Date===>"+date2);

		query="Select count(*) as counter from assignmentTransaction where engineerID in("+enameid+")  and projectId  in ( "+projectid+") and statusId="+status1+" and startedOn between '"+date1+ "' and '"+date2+"'";
		//out.print(query);
		pstmt = con.prepareStatement(query);
		rs_g = pstmt.executeQuery();
		while(rs_g.next())
		{
				counter=rs_g.getInt("counter");
		}
		pstmt.close();

		query="Select * from assignmentTransaction where engineerID in ("+enameid+")  and projectId in ( "+projectid+")  and statusId="+status1+" and startedOn between '"+date1+ "' and '"+date2+"'order by "+orderby;
		//out.print("<br>"+query);
		pstmt = con.prepareStatement(query);
		rs_g = pstmt.executeQuery();

			int assignmentid[]=new int[counter];
			String atitle[]=new String[counter];
			String adescription[]=new String[counter];
			int ename[]=new int[counter];
			int pname[]=new int[counter];
			int statusname[]=new int[counter];
			java.sql.Date startdate[]=new java.sql.Date[counter];
			java.sql.Date completedate[]=new java.sql.Date[counter];
			java.sql.Date targetdate[]=new java.sql.Date[counter];

			String engineername[]=new String[counter];
			String projectname[]=new String[counter];
			String status[]=new String[counter];
			int type[]=new int[counter];
			String priority1[]=new String[counter];

			 i=0;
			while(rs_g.next())
			{
				assignmentid[i]=rs_g.getInt("assignmentId");
				atitle[i]=rs_g.getString("assignmentName");
				adescription[i]=rs_g.getString("assignmentDescription");
				ename[i]=rs_g.getInt("engineerId");
				pname[i]=rs_g.getInt("projectId");
				type[i]=rs_g.getInt("typeId");
				priority1[i]=rs_g.getString("priorityId");
				statusname[i]=rs_g.getInt("statusId");
				startdate[i]=rs_g.getDate("startedOn");
				completedate[i]=rs_g.getDate("completedOn");
				//out.print("==>><br>"+completedate[i]);
			//	if(rs_g.wasNull())
			//	{	//System.out.print("Hi");
					//completedate[i]="";}
				//if(completedate[i]==null)
					//completedate[i]="0";
				targetdate[i]=rs_g.getDate("targetedOn");
				i++;
			}
		%>
<html>
 <head>
	<title>Engineer Report</title>
</head>
<body background="../Buttons/BGCOLOR.JPG">
	<form name=detail_report_form method="post">
		<table border=1 bordercolor="skyblue">
		<tr bgcolor="skyblue">
			<th colspan=8 align=center>
				Report Between <%=format.format(date1)%> and <%=format.format(date2)%>
			</th>
		</tr>
		<tr>
				<th>Sr. No.</th>
				<th>Assignment Title</th>
				<th>Engineer Name</th>
				<th>Project Name</th>
				<th>Work Status </th>
				<th>Started On</th>
				<th>Completed On</th>
			<%
				if("yes".equals(tdate))
				{
			%>
				<th>Targeted On</th>
				<%
				}
				%>
		</tr>
		<%
				for(i=0;i<counter;i++)
			{%>
				<tr>
					<td align=center><%=i+1%></td>
					<td>
						<a href="EditInfo.jsp?command=Default&assignment_id=<%=assignmentid[i]%>"><%=atitle[i]%>
						</a>
					</td>
					<%engineername[i]=A.getNameCondition(con,"masterEngineer","engineerName","where engineerId="+ename[i]+"");%>
					<td><%=engineername[i]%></td>
					<%projectname[i]=A.getNameCondition(con,"masterProject","projectName","where projectId="+pname[i]+"");%>
					<td><%=projectname[i]%></td>
					<%status[i]=A.getNameCondition(con,"masterStatus","statusName","where statusId="+statusname[i]+"");%>
					<td><%=status[i]%></td>
					<td><%=format.format(startdate[i])%></td>
					<td><% if(completedate[i]== null)
									{out.print("Not Completed");}
								else{out.print(format.format(completedate[i]));}%></td>
					<%
						if("yes".equals(tdate))
						{
					%>
					<td><%=format.format(targetdate[i])%></td>
					<%
						}
					%>
				</tr>
			<%}
			C.returnConnection(con);
	}catch(Exception e)
	{
		C.returnConnection(con);
		out.print("Error Found!!!!!!!!!!!"+e);
	}
}
%>
		</table>
	</form>
</html>
	