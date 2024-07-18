<%@page language="java" import="java.sql.*,java.io.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="format"  scope="application"   class="NipponBean.format" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />


<!-- <link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> -->

		<% 
			String user_id= ""+session.getValue("user_id");
			//String user_level= ""+session.getValue("user_level");
			String machine_name=request.getRemoteHost();
			String query = "";
			
			int errLine = 15;
			java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
			java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
			//command=Default
			
			String command=request.getParameter("command");
out.print("27:-"+command);
			String message=request.getParameter("message");
			
			Connection con=null;
			Connection cong=null;
			
			ResultSet rs_g=null;
			//Statement stmt=null;
			PreparedStatement pstmt=null;
			PreparedStatement pstmt_g=null;
			//int sr1=0;
			
			int counter = 0;
			int i=0;
			try	
			{
			cong=C.getConnection();
			}
			catch(Exception Samyak31)
			{ 
			C.returnConnection(cong);
			out.println("<br><font color=red> FileName : CgtReceive.jsp<br>Bug No Samyak31 : "+ Samyak31);
			}

			if("Default".equals(command))
			{
			try
			{	
			errLine = 34;
			con=C.getConnection();
		%>
		
		<script language="javascript">
			<%
				String lotNoQuery = "Select engineerName from masterEngineer where Active=1 order by engineerName";
					
				pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt_g.executeQuery();
				String engArray = "";
				
				while(rs_g.next()) 	
				{
					if(rs_g.isLast())
					{
					engArray += "\"" +rs_g.getString("engineerName") +"\"";
					}
					else
					{
					engArray += "\"" +rs_g.getString("engineerName") +"\",";
					}
				}
				pstmt_g.close();
				rs_g.close();
				out.print("var engArray=new Array("+engArray+");");

				String proQuery = "Select projectName from masterProject where Active=1 order by projectName";
		
				pstmt_g = cong.prepareStatement(proQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt_g.executeQuery();
				String proArray = "";
				while(rs_g.next()) 	
				{
					if(rs_g.isLast())
					{
					proArray += "\"" +rs_g.getString("projectName") +"\"";
					}
					else
					{
					proArray += "\"" +rs_g.getString("projectName") +"\",";
					}
				}
				pstmt_g.close();
				rs_g.close();
			
				out.print("var proArray=new Array("+proArray+");");
			%>
		</script>

			<%
				if(message!=null)
					out.println("<center><font class='message1'> "+message+"</font></center>");
									
				String engid="";
				String project_id="";
				String type_id="";
				String priority_id="";
				String status_id="";
				String title1="";
				String description1="";

				java.sql.Date givenDate=new java.sql.Date(System.currentTimeMillis());
				java.sql.Date completedDate=new java.sql.Date(System.currentTimeMillis());
				java.sql.Date targetDate=new java.sql.Date(System.currentTimeMillis());
				
				String assignment_id=request.getParameter("assignment_id");
out.print("<br>121 assignment_id:-"+assignment_id);
				query = "select * from assignmentTransaction where assignmentId="+assignment_id+"";
				
				errLine = 77;
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				errLine = 80;
	
				while(rs_g.next())
				{
				engid= rs_g.getString("engineerId");
				project_id=rs_g.getString("projectId");
				type_id=rs_g.getString("typeId");
				priority_id=rs_g.getString("priorityId");
				title1=rs_g.getString("assignmentName");
				description1=rs_g.getString("assignmentDescription");
				givenDate=rs_g.getDate("startedOn");
				targetDate=rs_g.getDate("targetedOn");			completedDate=rs_g.getDate("completedOn");
				status_id=rs_g.getString("statusId");

				if(completedDate==null)
				completedDate=today_date;
				}
				pstmt.close();

				String engname="";
				String pnname="";

				String enQuery1 = "Select engineerId,engineerName from masterEngineer where Active=1 and engineerId ="+engid;
				//out.print("<br>enQuery="+enQuery);
				
				errLine=394;
				pstmt = con.prepareStatement(enQuery1, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt.executeQuery();
				errLine=397;
				i = 0;
				while(rs_g.next()) 	
				{
					engname =rs_g.getString("engineerName");
					i++;	
				}
				pstmt.close();
				rs_g.close();
				if(i==0)
				{
				response.sendRedirect("DailyInfo.jsp?command=Default&message= <b><font size=4 color='#FF661C'>engineer name Record not found</font></b>.");
				}
		
				String pnQuery1 = "Select projectId,projectName from masterProject where Active=1 and projectId ="+project_id;
				
				pstmt = con.prepareStatement(pnQuery1, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt.executeQuery();
			
				i = 0;
				while(rs_g.next()) 	
				{
					pnname =rs_g.getString("projectName");
					i++;	
				}
				pstmt.close();
				rs_g.close();
				if(i==0)
				{
				response.sendRedirect("DailyInfo.jsp?command=Default&message= <b><font size=4 color='#FF661C'>Project name Record not found</font></b>.");
				}
				pstmt.close();
				rs_g.close();
			%>

<html>
<head>
<title>Daily Form</title>

<script language="JavaScript" src="validate_title.js"></script>
<script language="JavaScript" src="focus.js"></script>
<SCRIPT language=javascript	src="../Samyak/SamyakYearEndDate.js"></script>
<SCRIPT language=javascript src="../Samyak/Samyakmultidate.js"></script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body background="../Buttons/BGCOLOR.JPG" onLoad='document.mainform.engineer_name.select()'>

<form name=mainform method="post" action="EditInfo.jsp">
<table border=1 borderColor=skyblue align=center cellspacing=0 cellpadding=2 align=center>

	<tr><td>
		<table borderColor=blue border=0 WIDTH="100%" cellspacing=2 cellpadding=2>
		
		<tr bgcolor="skyblue">
			<th colspan=4 align=center>	Daily Update Form : </th>
		</tr>

		<tr><td>Engineer Name : </td>
			<td>
			<input type=text name="engineer_name" id=engineer_name value="<%=engname%>"  size=15 autocomplete=off 
			onBlur="getthefocus(document.mainform.project_name); 
			return nullvalidation(this);"></td>

			<script language="javascript">
				var engobj = new  actb(document.getElementById('engineer_name'), engArray);
			</script>	
		</tr>
							
		<tr><td>Project Name : </td>
			<td><input type=text name=project_name id=project_name value="<%=pnname%>" size=15 autocomplete=off 
			onBlur="return nullvalidation(this)"></td>

			<script language="javascript">
				var pnobj = new  actb(document.getElementById('project_name'), proArray);
			</script>	
		</tr>

		<tr><td><p>Assignment Title : </td>
			<td><input type="text" name="title" size=30 value='<%=title1%>'>
				<input type="hidden" name="assignment_id" size=30 value='<%=assignment_id%>'></td>
		</tr>

		<tr><td><p>Assignment Description : </td>
			<td>
<Textarea name="description" cols="35" rows="3" value=><%=description1%></Textarea>
</td>
		</tr>

		<tr><td><p>Assignment Type : </td>
			<%	
				query = "select count(*) as counter from masterType";
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				while(rs_g.next())
				{
					counter = rs_g.getInt("counter");
				}
				pstmt.close();

				String atype1[]=new String[counter];
				String atypeid1[]=new String[counter];

				query = "select typeId,typeName from masterType";
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				i=0;
				while(rs_g.next())
				{
				errLine=198;
				atypeid1[i]=rs_g.getString("typeId");
				atype1[i]=rs_g.getString("typeName");
				i++;
				}
				pstmt.close();
			%>
											
			<td><%=A.getMasterArraySamyakPro(con,"masterType","atype","where active=1 ","typeId","typeName",type_id)
				%>		</td>
		</tr>
							
		<tr><td><p>Priority :</td>
			<%																	
				query = "select count(*) as counter from masterPriority";
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				while(rs_g.next())
				{
				counter = rs_g.getInt("counter");
				}
				pstmt.close();

				String priority1[]=new String[counter];
				String priorityid1[]=new String[counter];

				query = "select priorityId,priorityName from masterPriority";
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				i=0;
				while(rs_g.next())
				{
				errLine=237;
				priorityid1[i]=rs_g.getString("priorityId");
				priority1[i]=rs_g.getString("priorityName");
				i++;
				}
				pstmt.close();
			%>
	
			<td><%=A.getMasterArraySamyakPro(con,"masterPriority","priorityname1","where active=1 ","priorityId","priorityName",priority_id)%> </td> 
		</tr>

				<!--  <-stockdate -->  
		<tr><td>
			<script language='javascript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.givendate, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Given Date' style='font-size:11px ; width:100'>")}
			</script> </td>
											 
			<td  align=left> 
			<input type=text class="ipstock" name='givendate' size=8 maxlength=10	value="<%=format.format(givenDate)%>"
			onblur='return  fnCheckMultiDate(this,"Date")' OnKeyUp="checkMe(this);"></td>
		</tr>		

			<!--  <-stockdate -->  
		<tr><td>
			<script language='javascript'>
			if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.targetdate, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Target Date' style='font-size:11px ; width:100'>")}
			</script></td>
				
			<td  align=left> 
			<input type=text class="ipstock" name='targetdate' size=8 maxlength=10 value="<%=format.format(targetDate)%>"
			onblur='return  fnCheckMultiDate(this,"Date")' OnKeyUp="checkMe(this);"></td>
		</tr>		

		<tr><!--  <-stockdate -->  
			<td>
			<script language='javascript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.completedate, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Completed Date' style='font-size:11px ; width:100'>")}
			</script> </td>
	
			<td align=left> 
			<input type=text class="ipstock" name='completedate' size=8 maxlength=10 value="<%=format.format(completedDate)%>"
			onblur='return  fnCheckMultiDate(this,"Date")' 
			OnKeyUp="checkMe(this);"></td>
		</tr>		

		<tr><td><p>Work Status : </td>
			<%	
				query = "select count(*) as counter from masterStatus";
				pstmt = con.prepareStatement(query);
				rs_g = pstmt.executeQuery();
				while(rs_g.next())	{
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
				while(rs_g.next())	{
				statusid1[i]=rs_g.getString("statusId");
				status1[i]=rs_g.getString("statusName");
				i++;
				errLine=309;
				}
				pstmt.close();
			%>
			<td><%=A.getMasterArraySamyakPro(con,"masterStatus","statusname1","where active=1 ","statusId","statusName",status_id)%>	</td>
		</tr>
									
		<tr>
			<td colspan=4><hr></td>
		</tr>
		
		<tr><td colspan=2 align="center">								
			<input type="submit" name="command" value="UPDATE" style="height:25px; width:80px; background:#D3D5A8; font-size:16"></td>
		</tr>
	</table>
</table>
										
		<%	errLine=322;
			C.returnConnection(con);
			C.returnConnection(cong);
			}catch(Exception e)
			{
			C.returnConnection(con);
			C.returnConnection(cong);
			out.print("Error Found!!!!!!!!!!!!"+e+" ErrLine="+errLine);
			}
		%>
		
		<%
			}
			if("UPDATE".equals(command))
			{	
			try
			{
			errLine=348;
			con=C.getConnection();
			
			String assignment_id=request.getParameter("assignment_id");
			String ename="";
			String pname="";

			String enQuery = "Select engineerId,engineerName from masterEngineer where Active=1 and engineerName like '"+request.getParameter("engineer_name")+"'";
			
			//out.print("<br>enQuery="+enQuery);
			
			errLine=394;
			pstmt_g = con.prepareStatement(enQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			errLine=397;
			i = 0;
			while(rs_g.next()) 	
			{
			ename =rs_g.getString("engineerId");
			i++;	
			}
			pstmt_g.close();
			rs_g.close();
			if(i==0)
			{
			//response.sendRedirect("DailyInfo.jsp?command=Default&message= <b><font size=4 color='#FF661C'>engineer name Record not found</font></b>.");
			}


			String pnQuery = "Select projectId,projectName from masterProject where Active=1 and projectName like '"+request.getParameter("project_name")+"'";
		
			pstmt_g = con.prepareStatement(pnQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
	
			i = 0;
			while(rs_g.next()) 	
			{
			pname =rs_g.getString("projectId");
			i++;	
			}
			pstmt_g.close();
			rs_g.close();
			if(i==0)
			{
			//response.sendRedirect("DailyInfo.jsp?command=Default&message= <b><font size=4 color='#FF661C'>Project name Record not found</font></b>.");
			}
			pstmt_g.close();
			rs_g.close();
	
			errLine=371;
			
			String title=request.getParameter("title");
			//out.print("title1 :"+title1);
			String description=request.getParameter("description");
			String atype = request.getParameter("atype");
			String priorityname = request.getParameter("priorityname1");
			String statusname=request.getParameter("statusname1");

			errLine=399;
			//out.print("<br>machine_name="+machine_name);
						
			String gdate1=request.getParameter("givendate");
			String tdate1=request.getParameter("targetdate");
			String cdate1=request.getParameter("completedate");
			StringTokenizer st=new StringTokenizer(gdate1,"/");

			int d1 = Integer.parseInt(st.nextToken());
			int m1 = Integer.parseInt(st.nextToken());
			int y1 = Integer.parseInt(st.nextToken());
			java.sql.Date gdate =new java.sql.Date((y1-1900),m1-1,d1);

			StringTokenizer st1=new StringTokenizer(tdate1,"/");
			int d11 = Integer.parseInt(st1.nextToken());
			int m11 = Integer.parseInt(st1.nextToken());
			int y11 = Integer.parseInt(st1.nextToken());
			java.sql.Date tdate =new java.sql.Date((y11-1900),m11-1,d11);
			//out.println("tdate="+tdate);

			StringTokenizer st2=new StringTokenizer(cdate1,"/");
			int d12 = Integer.parseInt(st2.nextToken());
			int m12 = Integer.parseInt(st2.nextToken());
			int y12 = Integer.parseInt(st2.nextToken());
			java.sql.Date cdate =new java.sql.Date((y12-1900),m12-1,d12);

			String s1="true";
			
			errLine=403;
			
			query="Update assignmentTransaction set assignmentName = '"+title+"',  assignmentDescription = ?,  projectId = "+pname+", engineerId = "+ename+", startedOn = ?, targetedOn = ?, completedOn = ?, statusId = "+statusname+", typeId = "+atype+", priorityId = "+priorityname+",  modifiedBy = "+user_id+", modifiedMachineName = '"+machine_name+"', active = ? where assignmentId = "+assignment_id;
			pstmt=con.prepareStatement(query);
				
			pstmt.setString(1,description);
			pstmt.setDate(2,gdate);
			pstmt.setDate(3,tdate);
			pstmt.setDate(4,cdate);
			pstmt.setBoolean(5,true);
			

			int a=pstmt.executeUpdate();
			errLine=416;
			pstmt.close();
			
			//response.sendRedirect("ReportForm1.jsp?command=Default&message= <b><font size=4 color='#FF661C'> Record Updated Successfully</font></b>.");
		%>

			<SCRIPT LANGUAGE="JavaScript">
				alert("Data Successfully Update!");
				window.close();
			</SCRIPT>

		<%
			C.returnConnection(con);
			C.returnConnection(cong);

			}catch(Exception e)
			{	
			C.returnConnection(cong);
			C.returnConnection(con);
			out.print("Error Occured!!!!!!!!!!!! at "+errLine+" is "+e);
			}
			}
		%>
				
</form>
</body>
</html>