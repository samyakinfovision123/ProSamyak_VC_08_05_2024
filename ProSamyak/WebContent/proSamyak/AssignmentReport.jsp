<%
/*
created on 16/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		16/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2		Anil			23-04-2011	Done		To Access on Server

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

%>

<%@ page language="java" import="samyak.utils.*"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="samyak.utils.Utility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="NipponBean.Connect"%>
<%@page import="java.sql.Connection"%>
<%@page import="samyak.database.masterEngineerDb"%>
<%@page import="samyak.beans.EngineerAssignmentDestributionBean"%>
<%@page import="samyak.database.EngineerAssignmentDestributionDb"%>
<%@page import="samyak.beans.notPersistenBean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
		<%
		Connect C= new Connect();
		Connection cong =null;
		try 
		{
		Timestamp T = new Timestamp (System.currentTimeMillis());
		//System.out.println(" AssignmentReport.jsp  login at "+T);
		htmlincoreJava obj = new htmlincoreJava (); 
		Timestamp T1 = new Timestamp( System.currentTimeMillis());
		String month = request.getParameter("month");
		EnggAssignmentReportutils enngId= new EnggAssignmentReportutils ();
		EngineerAssignmentDestributionBean objBean = new EngineerAssignmentDestributionBean();
		EngineerAssignmentDestributionDb objDb = new EngineerAssignmentDestributionDb();
		cong = C.getConnection();
		notPersistenBean objPBean = new notPersistenBean ();
		
		%>
		<table width="100%"  align="center" bordercolor="gray"  cellspacing=0 cellpadding=2  border="1">
		<tr>
		<td>
		Sr No 
		</td>
		<td>
		Name
		</td>
		<td>
		Assist  By
		</td>
		<%=obj.getOneThirtyOne(month) %>
		</tr>
		<%
		samyak.beans.masterEngineerBean MEObj[];//' = new samyak.beans.masterEngineerBean();
		samyak.database.masterEngineerDb MEDB = new samyak.database.masterEngineerDb();
		
		String Query ="select engineerId  from masterEngineer where active=1 and CurrentActive=1";
		ArrayList <String> getAllUserId =enngId.getArrayList(cong ,Query );
		MEObj=MEDB.selectMasterEngineerDb(cong,"where active=1 and CurrentActive=1",getAllUserId.size());
			
		for (int i=0 ; i < getAllUserId.size() ; i++)
		{
			
		
			
			objPBean= objDb.selectReport(cong ,Long.parseLong(getAllUserId.get(i)));
		
		%>
		<tr>
		<td>
		<%=(i+1) %>
		</td>
			
		<td>
		<%=MEObj[i].getEngineerName() %>
		</td>	
		<% 
		
		if (objPBean.getAssignmentBy()== null)
		{
		%>
		<td>
		-
		</td>
		<%
		}
		else
		{
		%>
		<td>
		<%=objPBean.getAssignmentBy() %>
		</td>
		<%
		}
		
		for (int day=1 ; day <= 31 ; day++ )
		{
			
		objPBean= objDb.selectReport(cong ,Long.parseLong(getAllUserId.get(i)),"2011" ,String.valueOf(day),month );
		if (objPBean.getProjectName()== null)
		{
		%>
			<td >
			<font>?
		    </font>
			</td>
		<% 
		}
		else
		{
		
			if (objPBean.getPriorityId() == 1)
			{
			%>
			<td bgcolor="orange">
			<%=objPBean.getProjectName()%>
			
			</td>
		<%
			}
			else if (objPBean.getPriorityId() == 3)
			{
			%>
			<td bgcolor="yellow">
			<%=objPBean.getProjectName()%>
			
			</td>
		<%
			}
			else if (objPBean.getPriorityId() == 4 || objPBean.getPriorityId() == 5) 
			{
			%>
				<td  bgcolor="green">
				<%=objPBean.getProjectName()%>
				
				</td>
			<%	
				
			}
			else
			{
				%>
				<td >
				<%=objPBean.getProjectName()%>
				
				</td>
			<%	
			}
		}
		}
		%>
		</tr>	
		<%
		}
		%>
		
	
		
		</table>
		<%
		}catch(Exception e)
		{
			e.printStackTrace();
		}finally
		{
			Timestamp T1 = new Timestamp (System.currentTimeMillis());
			System.out.println(" AssignmentReport.jsp  login at "+T1);
			C.returnConnection(cong);
		}
		%>
</body>
</html>