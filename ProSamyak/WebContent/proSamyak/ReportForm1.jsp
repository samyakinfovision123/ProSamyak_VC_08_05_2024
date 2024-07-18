<!-- 
-------------------------------------------------------------------------------------------------------------------------
*	Modified By		Date		Status		Reasons
-------------------------------------------------------------------------------------------------------------------------
1   ParagJ          26-12-2023  Done        chnage buttons to input type = button
2   ParagJ          09-01-2024  Done        Commented Unwanted Comments
-------------------------------------------------------------------------------------------------------------------------
-->
<%@page language="java" import="java.sql.*,java.io.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="format"  scope="application"   class="NipponBean.format" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<script language=javascript src="../Samyak/ListBoxMultiple.js"></script>
<%
	String user_id= ""+session.getValue("user_id");
	String machine_name=request.getRemoteHost();
	
	String user_level= ""+session.getValue("user_level");
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");

	Connection con=null;
	Connection cong=null;
	
	ResultSet rs_g=null;
	Statement stmt=null;
	
	PreparedStatement pstmt=null;
	PreparedStatement pstmt_g=null;
	
	String query="";
	
	int counter=0;
	int errLine = 15;
	int i=0;
	
	String command=request.getParameter("command");
//out.print("<br> 34 command:-"+command);
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
		out.println("<center><font class='message1'>"+message+"</font></center>");
	try
	{
		con=C.getConnection();
%>

<html>
<head>
	<title>Report Form</title>
</head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body background="../Buttons/BGCOLOR.JPG">
<form name=reportform method="post" action="ReportForm1.jsp" target=_blank>
<table border=1 borderColor=skyblue align=center width="50%" cellspacing=0 cellpadding=2 align=center>

<tr><td>
	<table borderColor=blue border=0 WIDTH="100%" cellspacing=2 cellpadding=2>
	
	<tr bgcolor="skyblue">
		<th colspan=4 align="center">Report Form</th>
	</tr>
<tr>
		<td colspan=3 align="center"><hr></td>
	</tr>
	<tr>
		<td align="center" colspan=4 >Range For : 
			<select name="rangefor" size=1>
			<option value="startedOn">Given Date</option>
			<option value="targetedOn">Target On</option>
			<option value="completedOn">Complete On</option>
			</select>
		</td>
	</tr>
</tr>

	<tr>
		<td colspan=3 align="center"><hr></td>
	</tr>

	<tr>
	
	
		<td  align="center">
		From Date : 
			<%
				java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
				int year=D.getYear();
				int dd=01;
				int mm=D.getMonth();
				
				java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
				java.sql.Date Dprevious1 = new java.sql.Date((104),03,01);
			%>
			
			<%= L.date(Dprevious1,"dd1","mm1","yy1")%>
			
		</td>
		<td>
		
		</td>
		<td align="center">
		
			To Date :	<%= L.date(D,"dd2","mm2","yy2")%>
		
		</td>
		
	</tr>

	<tr>
		<td colspan=4><hr></td>
	</tr>

	<%//-------------------------------------------------------------------------------------------------------------------------------------%>

	<tr>
		<td align="center">
		<fieldset><legend><font size=2>Select Engineer Name</font></legend>
		
		<table border='0' cellpadding=0 cellspacing=5>
		
		<tr><td rowspan=4>		
				<select id='availableEngineerOptions' name='availableEngineerOptions' multiple ondblclick='addAttribute("availableEngineerOptions", "selectedEngineerOptions")' style='width=100px' size=5>
				
				<%
					String groupquery="";
				
					groupquery = "Select engineerId,engineerName from masterEngineer where active="+1+" order by engineerName";
					pstmt = con.prepareStatement(groupquery);
					rs_g = pstmt.executeQuery();
					while(rs_g.next()){
					out.print("<option value='"+rs_g.getInt("engineerId")+"'>"+rs_g.getString("engineerName")+"</option>");			
					}
					pstmt.close();
				
				%>
				</select>
			</td>

			<td align=center valign=middle>
				<input type=button onclick='addAll("availableEngineerOptions", "selectedEngineerOptions")' style='height:23px;width=23px' value=">>">	
			</td>	

			<td rowspan=4> 
				<select id='selectedEngineerOptions' name='selectedEngineerOptions' multiple ondblclick='delAttribute("availableEngineerOptions", "selectedEngineerOptions")' style='width=100px' size=5 > 
				</select>	
			</td>
		</tr>

		<tr>
			<td align=center valign=middle>
			<input type=button onclick='addAttributeMultiple("availableEngineerOptions", "selectedEngineerOptions")' style='height:23px;width=23px' value=">"> </td>
		</tr>	
		
		<tr> 
			<td align=center valign=middle>
			<input type=button onclick='delAttributeMultiple("availableEngineerOptions", "selectedEngineerOptions")' style='height:23px;width=23px' value=">"> </td>
		</tr>
		
		<tr>
			<td align=center valign=middle>
			<input type=button onclick='delAll("availableEngineerOptions", "selectedEngineerOptions")' style='height:23px;width=23px' value=">>"> </td>	
		</tr> 
		</table>
		</fieldset>
		</td>


		<td  align=center>
		<fieldset><legend><font size=2>Select Project Name</font></legend>
		<table border='0' cellpadding=0 cellspacing=5>
		
		<tr><td rowspan=4>
			<select id='availableProjectOptions' name='availableProjectOptions' multiple ondblclick='addAttribute("availableProjectOptions", "selectedProjectOptions")' style='width=135px' size=5>
				
			<%
				//String groupquery="";
				
				groupquery = "Select projectId,projectName from masterProject where active="+1+" order by projectName";
				pstmt = con.prepareStatement(groupquery);
				rs_g = pstmt.executeQuery();
				
				while(rs_g.next()){
				out.print("<option value='"+rs_g.getInt("projectId")+"'>"+rs_g.getString("projectName")+"</option>");			
				}
				pstmt.close();
				
			%>
			</select>
			</td>
			
			<td align=center valign=middle>
				<input type=button onclick='addAll("availableProjectOptions",
				"selectedProjectOptions")' style='height:23px;width=23px' value=">>"> 
			</td>	
			
			<td rowspan=4> 
				<select id='selectedProjectOptions' name='selectedProjectOptions' multiple ondblclick='delAttribute("availableProjectOptions", "selectedProjectOptions")' style='width=100px' size=5> 
				</select>	
			</td>
		</tr>
		
		<tr> 
			<td align=center valign=middle>
			<input type=button onclick='addAttributeMultiple("availableProjectOptions", "selectedProjectOptions")' style='height:23px;width=23px' value=">"></td>
		</tr>	
		
		<tr> 
			<td align=center valign=middle>
			<input type=button onclick='delAttributeMultiple("availableProjectOptions", "selectedProjectOptions")' style='height:23px;width=23px' value=">"> </td>
		</tr>
		
		<tr>
			<td align=center valign=middle><button onclick='delAll("availableProjectOptions", "selectedProjectOptions")' style='height:23px;width=23px'>&lt;&lt;</button> </td>	
		</tr> 
		</table>
		</fieldset>
		</td>


	<td  align=center>
		<fieldset><legend><font size=2>Select Status</font></legend>
		<table border='0' cellpadding=0 cellspacing=5>
		<tr>
			<td rowspan=4>
			<select id='availableStatusOptions' name='availableStatusOptions' multiple ondblclick='addAttribute("availableStatusOptions", "selectedStatusOptions")' style='width=150px' size=5>
				
			<%
				//String groupquery="";
				groupquery = "Select statusId,statusName from masterStatus where active="+1+" order by statusName";
				pstmt = con.prepareStatement(groupquery);
				rs_g = pstmt.executeQuery();
				while(rs_g.next()){
					out.print("<option value='"+rs_g.getInt("statusId")+"'>"+rs_g.getString("statusName")+"</option>");			
				}
				pstmt.close();
				
			%>
			</select>
			</td>
			
			<td align=center valign=middle>
				<input type=button onclick='addAll("availableStatusOptions", "selectedStatusOptions")' style='height:23px;width=23px' value=">>"> 
			</td>	
			
			<td rowspan=4> 
				<select id='selectedStatusOptions' name='selectedStatusOptions' multiple ondblclick='delAttribute("availableStatusOptions", "selectedStatusOptions")' style='width=100px' size=5> 
				</select>	
			</td>
	</tr>
	
	<tr> 
		<td align=center valign=middle>
			<input type=button onclick='addAttributeMultiple("availableStatusOptions", "selectedStatusOptions")' style='height:23px;width=23px' value=">">
		</td>
	</tr>	
	
	<tr> 
		<td align=center valign=middle>
			<input type=button onclick='delAttributeMultiple("availableStatusOptions", "selectedStatusOptions")' style='height:23px;width=23px' value=">">
		</td>
	</tr>
	
	<tr>
		<td align=center valign=middle>
			<input type=button onclick='delAll("availableStatusOptions", "selectedStatusOptions")' style='height:23px;width=23px' value=">>"> 
		</td>	
	</tr> 
		</table>
		</fieldset>
		</td>
	</tr> 
	
	<tr>
		<td colspan=3 align="center"><hr></td>
	</tr>
	
	<tr>
		


		<td  align=center>
		<fieldset><legend><font size=2>Display Criteria</font></legend>
		<table border='0' cellpadding=0 cellspacing=5>
	
		<tr>
			<td><input type=checkbox name=tdate value='yes' align="left" checked>Target Date</td>
			<td><input type=checkbox name=ename_checkbox value='yes' align="left" checked>Engineer Name	</td>
		</tr>

		<tr>
			<td><input type=checkbox name=pname_checkbox value='yes' align="left" checked>Project Name	</td>
			<td><input type=checkbox name=adesc_checkbox value='yes' align="left" checked>Description	</td>
		</tr>

		<tr>
			<td><input type=checkbox name=givendate_checkbox value='yes' align="left" checked>Given Date		</td>
			<td><input type=checkbox name=completedate_checkbox value='yes' align="left" checked>Completed Date		</td>
		</tr>

		<tr>
			<td><input type=checkbox name=priority_checkbox value='yes' align="left" checked>Priority	</td>
			<td><input type=checkbox name=type_checkbox value='yes' align="left" checked>Type</td>
		</tr>
		
		</table>
		</fieldset>
		</td>



		<td  align=center>
		<fieldset><legend><font size=2>Priority</font></legend>
		<table border='0' cellpadding=0 cellspacing=3>
	<tr>	
		<td rowspan=4 >
			<select id='availablePriorityOptions' 
			name='availablePriorityOptions' multiple 
			ondblclick='addAttribute("availablePriorityOptions", "selectedPriorityOptions")' 
			style='width=100px' size=5 >
			
			
			</select>
			</td>
		
			<td align=center valign=middle>
				<input type=button onclick='addAll("availablePriorityOptions", "selectedPriorityOptions")' 
				style='height:23px;width=23px' value=">>"> 
			</td>	
			
			<td rowspan=4> 
				<select id='selectedPriorityOptions' name='selectedPriorityOptions' multiple 
				ondblclick='delAttribute("availablePriorityOptions", "selectedPriorityOptions")' 
				style='width=100px' size=5> 

				<%
				//String groupquery="";
				groupquery = "Select priorityId,priorityName from masterPriority where active="+1+" order by priorityName";
				pstmt = con.prepareStatement(groupquery);
				rs_g = pstmt.executeQuery();
				while(rs_g.next()){
					out.print("<option value='"+rs_g.getInt("priorityId")+"'>"+rs_g.getString("priorityName")+"</option>");			
				}
				pstmt.close();
			%>
				</select>	
			</td>
		</tr>

		<tr> 
			<td align=center valign=middle>
			<input type=button onclick='addAttributeMultiple("availablePriorityOptions", "selectedPriorityOptions")' 
			style='height:23px;width=23px' value=">"> </td>
		</tr>	
		
		<tr> 
			<td align=center valign=middle>
			<input type=button onclick='delAttributeMultiple("availablePriorityOptions", "selectedPriorityOptions")' 
			style='height:23px;width=23px' value=">"> </td>
		</tr>
		
		<tr>
			<td align=center valign=middle>
			<input type=button onclick='delAll("availablePriorityOptions", "selectedPriorityOptions")' 
			style='height:23px;width=23px' value=">>"></td>	
		</tr> 
		
		</table>
		</fieldset>
		</td>


<td  align=center>
		<fieldset style="height:120px">
		<legend><font size=2>Display Criteria</font></legend>			
		<table border='0' cellpadding=0 cellspacing=5>
			
		<tr><td>First Order By : </td>
			<td><select name="orderby1" size=1>
				<option value="startedOn">Given Date</option>
				<option value="engineerId">Engineer Name</option>
				<option value="projectId">Project Name</option>
				<option value="typeId">Assignment Type</option>
				<option value="statusId">Status</option>
				<option value="completedOn">Completion Date</option>
				<option value="targetedOn">Target Date</option>
				<option value="priorityId">Priority</option>
				</select>
			</td>
		</tr>	
		<tr><td>Second Order By : </td>
			<td><select name="orderby2" size=1>
				<option value="engineerId">Engineer Name</option>
				<option value="projectId" selected>Project Name</option>
				<option value="typeId">Assignment Type</option>
				<option value="statusId">Status</option>
				<option value="startedOn">Given Date</option>
				<option value="completedOn">Completion Date</option>
				<option value="targetedOn">Target Date</option>
				<option value="priorityId">Priority</option>
				</select>
			</td>
		</tr>
		</table>
		</fieldset>
		</td>


		</tr> 
	

<!-- Priority & Display criteria -->

<tr>
		<td colspan=4><hr></td>
	</tr>
	
		
		<%//----------------------------------------------------------------------------------------------------------------------------------------%>
		
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
				<input type="submit" name="command" value="NEXT" style="height:30px; width:60px; background:#D3D5A8; font-size:16" onClick="return temp()">
			</td>
		</tr>
		</table>
		</table>
		
		<div id=hiddenSelectList1 style="visibility:hidden">
			<select name="engineer_id" id="engineer_id" multiple></select>
		</div> 

		<div id=hiddenSelectList2 style="visibility:hidden">
			<select name="project_id" id="project_id" multiple></select>
		</div> 

		<div id=hiddenSelectList3 style="visibility:hidden">
			<select name="status_id" id="status_id" multiple></select>
		</div> 
		<div id=hiddenSelectList4 style="visibility:hidden">
			<select name="Priority_id" id="Priority_id" multiple></select>
		</div> 

		<SCRIPT LANGUAGE="JavaScript">
		
		function validation()
		{
			selectedEngineerOptionsId = document.getElementById("selectedEngineerOptions");
			selectedProjectOptionsId = document.getElementById("selectedProjectOptions");
			selectedStatusOptionsId = document.getElementById("selectedStatusOptions");
			selectedPriorityOptionsId = document.getElementById("selectedPriorityOptions");
			
			if(selectedEngineerOptionsId.length==0 )
			{
				alert("Please Insert Engineer Name");
				return 0;
			}
			else
			{
				if(selectedProjectOptionsId.length==0 )
				{
					alert("Please Insert Project Name");
					return 0;
				}
				else
				{
					if(selectedStatusOptionsId.length==0)
					{
						alert("Please Insert Status Name");
						return 0;
					}
					else
					{
						if(selectedPriorityOptionsId.length==0)
						{
							alert("Please Insert Priority Name");
							return 0;
						}	
						else
						{
							return 1;
						}
					}
				}
			}
		}

			function temp()
			{
				var orderby1,orderby2;
				orderby11=document.getElementById("orderby1");
				//alert("orderby11"+orderby11);
				for(var j=0;j<orderby11.length;j++)
				{
					if(document.reportform.orderby1.options[j].selected)
					{
						orderby1=document.reportform.orderby1.options[j].value;
					}
				}

				orderby22=document.getElementById("orderby2");
				//alert("orderby11"+orderby11);
				for(var j=0;j<orderby22.length;j++)
				{
				
					if(document.reportform.orderby2.options[j].selected)
					{
						orderby2=document.reportform.orderby2.options[j].value;			
					}
				}

				if(orderby1==orderby2)
				{
					alert("Select Different Order By Criteria");
					return false;
				}
				selected1 = document.getElementById('selectedEngineerOptions');
				//alert(selected1);
				document.reportform.engineer_id.length = 0;
				//alert("selected"+selected.length);
				for(var i=0; i<selected1.length ;i++)
				{
					document.reportform.engineer_id.options[i] = new Option(selected1.item(i).value, selected1.item(i).value, true, true);
				}
				selected2 = document.getElementById('selectedProjectOptions');
				document.reportform.project_id.length = 0;
				//alert("selected"+selected.length);
				for(var i=0; i<selected2.length ;i++)
				{
					document.reportform.project_id.options[i] = new Option(selected2.item(i).value, selected2.item(i).value, true, true);
				}
				selected3 = document.getElementById('selectedStatusOptions');
				document.reportform.status_id.length = 0;
				//alert("selected"+selected.length);
				for(var i=0; i<selected3.length ;i++)
				{
					document.reportform.status_id.options[i] = new Option(selected3.item(i).value, selected3.item(i).value, true, true);
				}
				
				selected4 = document.getElementById('selectedPriorityOptions');
				document.reportform.Priority_id.length = 0;
				//alert("selected"+selected.length);
				for(var i=0; i<selected4.length ;i++)
				{
					document.reportform.Priority_id.options[i] = new Option(selected4.item(i).value, selected4.item(i).value, true, true);
				}

				//if(document.reportform.status_id.length == 0;)
				//	alert("Please select Status!!!!!!!!");
				var a=validation();
				if(a==1)
				{
					return true;
				}
				else
				{return false;}
			}
		
			</SCRIPT>
		</form>
	</body>
</html>
<%
	}
%>


<%
if("NEXT".equals(command))
{
	try
	{
		con=C.getConnection();
		
		String ename1[]=new String[0];
		String pname1[]=new String[0];
		ename1=request.getParameterValues("engineer_id");
		pname1=request.getParameterValues("project_id");
		
		//out.print("<br> 652 ename1==>"+ename1);
		//out.print("<br> 652 pname1==>"+pname1);
		
		String status1[]=new String[0];
		status1=request.getParameterValues("status_id");
		
		//out.print("status1===>"+status1);

		String priorityname2[]=new String[0];
		priorityname2=request.getParameterValues("Priority_id");
		
		String tdate=request.getParameter("tdate");
//out.print("<br>662 tdate==>"+tdate);

		String ename_checkbox=request.getParameter("ename_checkbox");
		String pname_checkbox=request.getParameter("pname_checkbox");
		String adesc_checkbox=request.getParameter("adesc_checkbox");
		String givendate_checkbox=request.getParameter("givendate_checkbox");
		String completedate_checkbox=request.getParameter("completedate_checkbox");
		String priority_checkbox=request.getParameter("priority_checkbox");
		String type_checkbox=request.getParameter("type_checkbox");

		String orderby1=request.getParameter("orderby1");
		String orderby2=request.getParameter("orderby2");
		String rangefor=request.getParameter("rangefor");
		//out.print("orderby==>>"+orderby1);
		
		String enameid="";
		String projectid="";
		String statusid1="";
		String ppriorityid="";
		
		for(int k=0;k<ename1.length;k++)
		{
			if(k==0)
			{enameid=ename1[k];}else{enameid=enameid+","+ename1[k];}
		}

		for(int k=0;k<pname1.length;k++)
		{
			if(k==0)
			{
				projectid=pname1[k];}else{projectid=projectid+","+pname1[k];
			}
		}

		for(int k=0;k<status1.length;k++)
		{
			if(k==0)
			{statusid1=status1[k];}else{statusid1=statusid1+","+status1[k];}
		}

		for(int k=0;k<priorityname2.length;k++)
		{
			if(k==0)
			{ppriorityid=priorityname2[k];}else{ppriorityid=ppriorityid+","+priorityname2[k];}	
		}	
		
		

		int d1=Integer.parseInt(request.getParameter("dd1"));
		int m1=Integer.parseInt(request.getParameter("mm1"));
		int y1=Integer.parseInt(request.getParameter("yy1"));
		int d2=Integer.parseInt(request.getParameter("dd2"));
		int m2=Integer.parseInt(request.getParameter("mm2"));
		int y2=Integer.parseInt(request.getParameter("yy2"));
		
		java.sql.Date date1=new java.sql.Date((y1-1900),(m1-1),d1);
		java.sql.Date date2=new java.sql.Date((y2-1900),(m2-1),d2);
	
		
		
		/* out.print("projectid===>"+projectid);
		out.print("ppriorityid===>"+ppriorityid);
		out.print("rangefor===>"+rangefor);
		out.print("date1===>"+date1);
		out.print("date2===>"+date2);
		out.print("orderby1===>"+orderby1);
		out.print("orderby2===>"+orderby2); */
		
		//out.print(" +++From Date===>"+date1);
		//out.print(" +++To Date===>"+date2);

		/*query="Select count(*) as counter from assignmentTransaction where engineerID in("+enameid+")  and projectId  in ( "+projectid+") and statusId in ( "+statusid1+") and "+rangefor+" between '"+date1+ "' and '"+date2+"'";
		//out.print(query);
		pstmt = con.prepareStatement(query);
		rs_g = pstmt.executeQuery();
		while(rs_g.next())
		{
				counter=rs_g.getInt("counter");
		}
		pstmt.close();*/

		query="Select * from assignmentTransaction where engineerID in ("+enameid+")  and projectId in ( "+projectid+")  and statusId in ( "+statusid1+") and priorityId in ("+ppriorityid+") and "+rangefor+" between '"+date1+ "' and '"+date2+"'order by "+orderby1+","+orderby2;
		//out.print("<br>682 Query:-"+query);
		pstmt = con.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt.executeQuery();

		rs_g.last();
		counter=rs_g.getRow();
		rs_g.beforeFirst();

			int assignmentid[]=new int[counter];
			String atitle[]=new String[counter];
			String adescription[]=new String[counter];
			int ename[]=new int[counter];
			int pname[]=new int[counter];
			int statusname[]=new int[counter];
			int ppriorityname[]=new int[counter];

			java.sql.Date startdate[]=new java.sql.Date[counter];
			java.sql.Date completedate[]=new java.sql.Date[counter];
			java.sql.Date targetdate[]=new java.sql.Date[counter];

			String engineername[]=new String[counter];
			String projectname[]=new String[counter];
			String status[]=new String[counter];
			int type[]=new int[counter];
//			String priority1[]=new String[counter];

			String typename[]=new String[counter];
			String priorityname1[]=new String[counter];

			 i=0;
			while(rs_g.next())
			{
				assignmentid[i]=rs_g.getInt("assignmentId");
				atitle[i]=rs_g.getString("assignmentName");
				adescription[i]=rs_g.getString("assignmentDescription");
				ename[i]=rs_g.getInt("engineerId");
				pname[i]=rs_g.getInt("projectId");
				type[i]=rs_g.getInt("typeId");
				ppriorityname[i]=rs_g.getInt("priorityId");
				statusname[i]=rs_g.getInt("statusId");
				startdate[i]=rs_g.getDate("startedOn");
				completedate[i]=rs_g.getDate("completedOn");
				targetdate[i]=rs_g.getDate("targetedOn");
				i++;
			}
			pstmt.close();
		%>
<html>
 <head>
	<title>Engineer Report</title>
<style type="text/css">  
.pg-normal 
{
    color: black;
    font-weight: normal;
    text-decoration: none;    
    cursor: pointer;    
}
.pg-selected 
{
    color: black;
    font-weight: bold;        
    text-decoration: underline;
                cursor: pointer;
}
</style>
<script type="text/javascript" src="../Samyak/paging.js"></script> 
<script type="text/javascript" src="../Samyak/sorttable.js"></script>
</head>

<body >
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<link href='../Samyak/reportcss.css' rel=stylesheet type='text/css'>
	<form name=detail_report_form method="post">
		<table class='sortable' border=0 bordercolor="skyblue" align="center"  cellspacing=0 >
		<thead>
		<tr>
			<th colspan=11 align=center>	
				Report Between <%=format.format(date1)%> and <%=format.format(date2)%>
			</th>
		</tr>
			<tr bgcolor=#009999 >
				<th class="th4">Sr. No.</th>
				<%
				if("yes".equals(ename_checkbox))
				{%>
					<th class="th4">Engineer Name</th>
				<%}%>
				<%
				if("yes".equals(pname_checkbox))
				{%>
				<th class="th4">Project Name</th>
				<%}%>
				
				<th class="th4">Assignment  Title </th>
				
				<%
				if("yes".equals(adesc_checkbox))
				{%>
					<th class="th4">Assignment Description</th>
					
				<%}%>
				<%
				if("yes".equals(type_checkbox))
				{%>
					<th class="th4">Assignment Type</th>
				<%}%>
				
				<%
				if("yes".equals(priority_checkbox))
				{%>
					<th class="th4">Assignment Priority</th>
				<%}%>
				
				<th class="th4">Work Status </th>
				<%
				if("yes".equals(givendate_checkbox))
				{%>
					<th class="th4">Started On</th>
				<%}%>
				<%
				if("yes".equals(tdate))
				{%>
				<th class="th4">Targeted On</th>
				<%}%>
				<%
				if("yes".equals(completedate_checkbox))
				{%>
					<th class="th4">Completed On</th>
				<%}%>
		</tr>
		<tr><th colspan=11></th></tr>
		<tr><th colspan=11></th></tr>
		</thead>
		<tbody id='results'>
		<%for(i=0;i<counter;i++){%>
		<tr <%if(i%2==0){%>bgcolor="#E5E5E5" <%}else{%>	bgcolor="#F7F7F7"<%}%>>            
			<td align=center ><%=i+1%></td>
				<%engineername[i]=A.getNameCondition(con,"masterEngineer","engineerName", "where engineerId="+ename[i]+"");%>
				<%if("yes".equals(ename_checkbox)){%>
			<td><%=engineername[i]%></td>
				<%}%>
				<%projectname[i]=A.getNameCondition(con,"masterProject","projectName","where projectId="+pname[i]+"");%>
				<%if("yes".equals(pname_checkbox)){%>
			<td><%=projectname[i]%></td>
				<%}%>
			<td>
				**<a href="EditInfo.jsp?command=Default&assignment_id=<%=assignmentid[i]%> "target=_blank><%=atitle[i]%></a>
			</td>
				<%if("yes".equals(adesc_checkbox)){%>
			<td><%=adescription[i]%></td>
				<%}%>
				<%typename[i]=A.getNameCondition(con,"masterType","typeName","where typeId="+type[i]+"");%>
				<%if("yes".equals(type_checkbox)){%>
			<td align="center"><%=typename[i]%></td>
				<%}%>
				<%priorityname1[i]=A.getNameCondition(con,"masterPriority","priorityName", 
				"where priorityId="+ppriorityname[i]+"");%>
				<%if("yes".equals(priority_checkbox)){%>
			<td align="center"  ><%=priorityname1[i]%></td>
				<%}%>
				<%status[i]=A.getNameCondition(con,"masterStatus","statusName","where statusId="+statusname[i]+"");%>
			<td><%=status[i]%></td>
				<%if("yes".equals(givendate_checkbox)){%>
			<td align="center"><%=format.format(startdate[i])%></td>
				<%}%>
				<%if("yes".equals(tdate)){%>
			<td align="center" ><%=format.format(targetdate[i])%></td>
				<%}%>
				<%if("yes".equals(completedate_checkbox)){%>
			<td align="center" ><% if(completedate[i]== null)
				{out.print("Not Completed");}
				else{out.print(format.format(completedate[i]));}%>
			</td>
				<%}%>
		</tr>
		<%}
			C.returnConnection(con);
		}
		catch(Exception e)
		{
			C.returnConnection(con);
			out.print("Error Found!!!!!!!!!!!"+e);
		}
}%>
</tbody>
<tfoot>
</tfoot>
</table>
<font size="2">
	<div id="pageNavPosition"></div>
</font>
</form>
</html>
