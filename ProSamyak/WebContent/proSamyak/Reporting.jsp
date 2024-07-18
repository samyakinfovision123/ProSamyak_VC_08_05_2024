<%
/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        add MVC 
* 2	   Anil				23-04-2011	Done		To Access on Server
* 3    MR Ganesh        26-04-2011  Done        all report   
* 4	   Anil				26-04-2011  done        TL 2 Version Control
* 4	  GaneshG,Shrikant	21-05-2011  Start		Adding datwise report for past 7 days & past 15 days

* 5   GaneshG, Srikant 21-05-2011 done           Report To display datewise
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

%>
<%@ page language="java" import="java.sql.Date , java.sql.Connection ,java.sql.Timestamp,samyak.beans.masterEngineerBean,samyak.database.masterEngineerDb,java.io.*,java.sql.*,java.util.*,NipponBean.*"
contentType="text/html; charset=ISO-8859-1"
 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<jsp:useBean id="C" scope="page" class="NipponBean.Connect" />
<jsp:useBean id="A" scope="page" class="samyak.utils.OldMethodOveride" />
<jsp:useBean id="AA" scope="page" class="NipponBean.Array" />
<%
Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs_g=null;
long engineerId=0;
String engineerName="";
String presentquery="";

List engId=new ArrayList();
String attendQuery="";
String TodayString="";
System.out.println("Time is");

java.sql.Date currentTime = new java.sql.Date(System.currentTimeMillis());
Timestamp f1=new Timestamp(System.currentTimeMillis());
System.out.println("Time is=============="+currentTime);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

System.out.println("D="+D);
int year1=D.getYear()+1900;
System.out.println("year1==="+year1);
int dd1=D.getDate();
int dd2=dd1;
System.out.println("dd1=="+dd1);
int mm1=D.getMonth()+1;
System.out.println("mm1=="+mm1);
java.sql.Date Dprevious = new java.sql.Date((year1),(mm1),dd1);
String invoicedate=format.format(Dprevious);
System.out.println(Dprevious);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action="#" >
			<%
			String usernameid=String.valueOf(request.getAttribute("usernameid"));
			String EngineerId=String.valueOf(request.getAttribute("EngId"));
		//	String hardcodeDate=f1;
		String ReportDay=String.valueOf(request.getAttribute("ReportDay"));
		System.out.println("ReportDay==="+ReportDay);
		String hardcodeDate=String.valueOf(request.getAttribute("currentTime"));
		//out.println("hardcodeDate="+hardcodeDate);
	//	java.sql.Date hardcodeDate=new java.sql.Date(System.currentTimeMillis());
			Connection cong = null;
			Date getDate = new Date (System.currentTimeMillis());
			//int xyz=7;
	//	if("ReportDay".equalsIgnoreCase(ReportDay)){
		//	System.out.println("inside if codition");
			try 
			{
				cong = C.getConnection();
				masterEngineerBean empObj = new masterEngineerBean ();
				masterEngineerDb empDbObj = new masterEngineerDb ();
				if("7".equalsIgnoreCase(ReportDay))
				{	
			%>
			<table width="100%"  align="center" bordercolor="gray"  cellspacing=0 cellpadding=2  border="1">
			<tr>
			<td colspan="39" align="center">
			Smayak softWare 
			</td>
			</tr>
			<tr>
			<td colspan="39" align="center">
		  	 MUSTER BOOK
			</td>
			</tr>
			<%
		
			String checkAll = AA.getNameCondition(cong , "masterEngineer" , "engineerName" , " where active=1  and CurrentActive=1 and engineerId ="+EngineerId);
			
			if("All".equalsIgnoreCase(checkAll))
			{

				String Query ="select count(engineerId) as counter from masterEngineer where active =1  and CurrentActive=1" ;
				long counterUser =Long.parseLong(A.passQuery(cong, Query, "counter"));
				masterEngineerBean empObjMulty [] = new masterEngineerBean [Integer.parseInt(String.valueOf(counterUser))];
				empObjMulty = empDbObj.selectMasterEngineerDb(cong , " where active=1  and CurrentActive=1 ", Integer.parseInt(String.valueOf(counterUser)) );
				 %>
					<tr >
					<td>
					Name
					</td>
					<td colspan="2">
					Designation
					</td>
					<td  colspan="4"  >
					Join_Date 
					</td>
					
					<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
					
					<td align="center">
					Counter Present
					</td>
					</tr>
				 
				<% 
				for (int userCounter=0 ; userCounter < counterUser ; userCounter++  )
				{
				if (! empObjMulty[userCounter].getEngineerName().equalsIgnoreCase("All"))
				{
				%>
					<tr>
					<td>
					<%= empObjMulty[userCounter].getEngineerName()%>
					</td>
					<td colspan="2">
					<%= empObjMulty[userCounter].getDesgnationId()%>
					</td>
					<td colspan="4">
					<%= empObjMulty[userCounter].getJoinDate().toString().substring(0 , 11)%>
					</td>
					
					<%
				
					int CounterIn=0;
					int CounterOut=0;
					int t=dd1;
					for (int day=7 ; day >=1; day--)
					{
						
						
							//System.out.println("inside if condition");
							int t2=dd2;
							if(t<t2-7)
							{
							t=t2;	
							}
							
						
						System.out.println("Inside Intime query<br>");
						String OutBoth=" " ;
						String InBoth=" " ;
						String mm =	hardcodeDate.substring(5,7);;
						String yyyy =hardcodeDate.substring(0,4);;
						String dd=" ";	
					/*		if (day < 10  )
							{
							 dd =A.getDay(day);
							}
							else if (day >= 10 && day <= 31)
							{
								dd=String.valueOf(day);
							}
					*/			
							
							String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId()+" and  month(time)="+mm1 +" and day(time)="+t+" and year(time)="+year1;
							System.out.println("QueryIn=="+QueryIn);
							t--;
							InBoth=A.passQuery(cong, QueryIn, "time");
							
							
						
						
					%>
					
					
					<%
					if ("0".equalsIgnoreCase(InBoth))
					{
					%>
					<td >
					<font color="red">
					- 
					</font>
					</td>
					<%
					}
					else
					{
					%>
					<td >
					<%=InBoth.substring(11 ,16) %>
					</td>
					
					<%
					CounterIn++;
					}
					%>
				
					<%
					} // for 
					%>
					<td>
					<%=CounterIn %>
					</td>
					</tr>
					<tr>
					<td>
					<%= empObjMulty[userCounter].getContactnumber()%>
					</td>
					<td colspan="2">
					<%= empObjMulty[userCounter].getAddress()%>
					</td>
					<td colspan="4">
					<%= empObjMulty[userCounter].getBirthDate().toString().substring(0,11)%>
					</td>
					<% 
					int t3=dd1;
					for (int day=7 ; day >=1; day--  )
					{
						int t2=dd2;
						if(t3<t2-7)
						{
						t3=t2;	
						}
						
						System.out.println("In Loop no 1");
						String OutBoth=" " ;
						String InBoth=" " ;
						String mm =	hardcodeDate.substring(5,7);
						String yyyy =hardcodeDate.substring(0,4);
						String dd=" ";	
							if (day < 10  )
							{
							 dd =A.getDay(day);
							}
							else if (day >= 10 && day <= 31)
							{
								dd=String.valueOf(day);
							}
								
							
						
							
							
							String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId() +" and   month(time)="+mm1+" and day(time)="+t3 +" and year(time)="+year1+" order by time desc";
							System.out.println("QueryOut"+QueryOut);
							OutBoth=A.passQuery(cong, QueryOut, "time");
							t3--;
						
					
					if ("0".equalsIgnoreCase(OutBoth))
					{
					%>
					<td >
					<font color="red">
					- 
					</font>
					</td>
					<%
					}
					else
					{
					%>
					<td>
					<%=OutBoth.substring(11 ,16) %>
					</td>
					<%
					 CounterOut++;
					}
					
					}
					%>
					<td>
					<%=CounterOut %>
					</td>
					</tr>
					<% 
				
					
					
				}
				
				} // if close 
				
			}
			
			
			else
			{
				empObj=empDbObj.selectMasterEngineerDb(cong ,Long.parseLong(EngineerId));
				String joinDate =empObj.getJoinDate().toString();
				
				int CounterIn=0;
				int CounterOut=0;
			%>
			
			<tr>
			<td>
			Name
			</td>
			<td colspan="2">
			Designation
			</td>
			<td colspan="4"  >
			Join_Date 
			</td>
			
			<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
						<td align="center">
			Counter Present 
			</td>
			</tr>
			<tr>
			
			<%
			
			if (empObj.getEngineerName()== null)
			{
			%>	
				<td>
				-
				</td>
			<% 
			}
			else
			{%>
				<td>
				<%=empObj.getEngineerName() %>
				</td>
				
			<% 
			}
			%>
			</td>
			<td colspan="2">
			<%=empObj.getDesgnationId() %> 
			</td>
			<%
			if (empObj.getJoinDate() == null )
			{
			%>
			<td colspan="4">
			-
			</td>
			<%
			}else
			{%>
			<td colspan="4">
			<%=joinDate.substring(0 , 11) %> 
			</td>	
			<% 
			}
			
		
			int t=dd1;
			for (int day=7 ; day >=1; day--  )
			{ 
				System.out.println("In Loop no 2");
				String OutBoth=" " ;
				String InBoth=" " ;
				String mm =	hardcodeDate.substring(5,7);;
				//System.out.println("mm=="+mm);
				String yyyy =hardcodeDate.substring(0,4);;
				//System.out.println("yyyy=="+yyyy);
				String dd=" ";	
				if (day < 10  )
				{
				 dd =A.getDay(day);
				}
				else if (day >= 10 && day <= 31)
				{
					dd=String.valueOf(day);
				}
			
				
				
				
				
				
						
					//int t=dd1;
					System.out.println("t=="+t);
					String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+" and  month(time)="+mm1+" and day(time)="+t+" and year(time)="+year1;
					System.out.println("QueryIn===="+QueryIn);
				t--;
				//	out.println("QueryIn="+QueryIn);
					InBoth=A.passQuery(cong, QueryIn, "time");
					
			//		System.out.println("InBoth"+InBoth);
				
			if ("0".equalsIgnoreCase(InBoth))
			{
			%>
			<td>
			<font color="red">
			- 
			</font>
			</td>
			<%
			}
			else
			{
			%>
			<td>
			
			<%=InBoth.substring(11 ,16) %>
			
			<%
			CounterIn++;
			}
			%>
			
			<% 
			} // for 
			%>
			<td>
			<%=CounterIn %>
			</td>
			</tr>
			<tr>
		
			<%
			if (empObj.getContactnumber() == 0)
			{
			%><td>
			-
			</td>
			<%
			}else
			{
			%>
			<td>
			<%=empObj.getContactnumber() %>
			</td>
			<%
			}
			if(empObj.getAddress() == null)
			{
			%>
			<td colspan="2">
			-
			</td>
			<%
			}
			else
			{
			%>
			<td colspan="2">
			<%=empObj.getAddress() %>
			</td>
			<%
			}
			if (empObj.getBirthDate() == null)
			{%>
				<td colspan="4">
				-
				</td>
			<% 
			}
			else
			{
			%>
			<td colspan="4">
			<%=empObj.getBirthDate().toString().substring(0,11) %>
			</td>
			<%
			}
			for (int day=7 ; day >=1; day--  )
			{
				System.out.println("In Loop no 3");
				String OutBoth=" " ;
				String InBoth=" " ;
				String mm =	hardcodeDate.substring(5,7);;
				String yyyy =hardcodeDate.substring(0,4);;
				String dd=" ";	
					if (day < 10  )
					{
					 dd =A.getDay(day);
					}
					else if (day >= 10 && day <= 31)
					{
						dd=String.valueOf(day);
					}
						//int Quryday=0;
					String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+"  and  month(time)="+mm1+" and day(time)="+dd1+" and year(time)="+ year1+" order by time desc";
					System.out.println("QueryOut ========="+QueryOut);
					OutBoth=A.passQuery(cong, QueryOut, "time");
				dd1--;	
				
			%>
			
		
			<%
			if ("0".equalsIgnoreCase(OutBoth))
			{
			%>
			<td>
			<font color="red">
			- 
			</font>
			</td>
			<%
			}
			else
			{
			%>
			<td>
			<%=OutBoth.substring(11 ,16) %>
			</td>
			<%
			CounterOut++;
			}
			%>
			
			<%
			}
			%>
			<td>
			<%=CounterOut %>
			</td>
			</tr>
			<% 
			}// else All
			}//Starting else part for 15 days
			
				
				else if("15".equalsIgnoreCase(ReportDay)){
				%>
				<table width="100%"  align="center" bordercolor="gray"  cellspacing=0 cellpadding=2  border="1">
				<tr>
				<td colspan="39" align="center">
				Smayak softWare 
				</td>
				</tr>
				<tr>
				<td colspan="39" align="center">
			  	 MUSTER BOOK
				</td>
				</tr>
				<%
			
				String checkAll = AA.getNameCondition(cong , "masterEngineer" , "engineerName" , " where active=1  and CurrentActive=1 and engineerId ="+EngineerId);
				
				if("All".equalsIgnoreCase(checkAll))
				{

					String Query ="select count(engineerId) as counter from masterEngineer where active =1  and CurrentActive=1" ;
					long counterUser =Long.parseLong(A.passQuery(cong, Query, "counter"));
					masterEngineerBean empObjMulty [] = new masterEngineerBean [Integer.parseInt(String.valueOf(counterUser))];
					empObjMulty = empDbObj.selectMasterEngineerDb(cong , " where active=1  and CurrentActive=1 ", Integer.parseInt(String.valueOf(counterUser)) );
					 %>
						<tr >
						<td>
						Name
						</td>
						<td colspan="2">
						Designation
						</td>
						<td  colspan="4"  >
						Join_Date 
						</td>
						
						<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
					<td align="center">
					<%int abc7=abc6-1; %>
					<%=abc7 %>
					<%if(abc7==1){
						
					abc7=32;	
					} %>
					</td>
					<td align="center">
					<%int abc8=abc7-1; %>
					<%=abc8 %>
					<%if(abc8==1){
						
					abc=8;	
					} %>
					</td>
					<td align="center">
					<%int abc9=abc8-1; %>
					<%=abc9 %>
					<%if(abc9==1){
						
					abc9=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc10=abc9-1; %>
					<%=abc10 %>
					<%if(abc10==1){
						
					abc10=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc11=abc10-1; %>
					<%=abc11 %>
					<%if(abc11==1){
						
					abc11=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc12=abc11-1; %>
					<%=abc12 %>
					<%if(abc12==1){
						
					abc12=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc13=abc12-1; %>
					<%=abc13 %>
					<%if(abc13==1){
						
					abc13=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc14=abc13-1; %>
					<%=abc14 %>
					<%if(abc14==1){
						
					abc14=32;	
					} %>
					</td>
				
				
				
				
				
				
					<td align="center">
						Counter Present
						</td>
						</tr>
					 
					<% 
					for (int userCounter=0 ; userCounter < counterUser ; userCounter++  )
					{
					if (! empObjMulty[userCounter].getEngineerName().equalsIgnoreCase("All"))
					{
					%>
						<tr>
						<td>
						<%= empObjMulty[userCounter].getEngineerName()%>
						</td>
						<td colspan="2">
						<%= empObjMulty[userCounter].getDesgnationId()%>
						</td>
						<td colspan="4">
						<%= empObjMulty[userCounter].getJoinDate().toString().substring(0 , 11)%>
						</td>
						
						<%
					
						int CounterIn=0;
						int CounterOut=0;
						int t=dd1;
						for (int day=15 ; day >=1; day--)
						{
							
							
								//System.out.println("inside if condition");
								int t2=dd2;
								if(t<t2-15)
								{
								t=t2;	
								}
								
							
							System.out.println("Inside Intime query<br>");
							String OutBoth=" " ;
							String InBoth=" " ;
							String mm =	hardcodeDate.substring(5,7);;
							String yyyy =hardcodeDate.substring(0,4);;
							String dd=" ";	
						/*		if (day < 10  )
								{
								 dd =A.getDay(day);
								}
								else if (day >= 10 && day <= 31)
								{
									dd=String.valueOf(day);
								}
						*/			
								
								String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId()+" and  month(time)="+mm1 +" and day(time)="+t+" and year(time)="+year1;
								System.out.println("QueryIn=="+QueryIn);
								t--;
								InBoth=A.passQuery(cong, QueryIn, "time");
								
								
							
							
						%>
						
						
						<%
						if ("0".equalsIgnoreCase(InBoth))
						{
						%>
						<td >
						<font color="red">
						- 
						</font>
						</td>
						<%
						}
						else
						{
						%>
						<td >
						<%=InBoth.substring(11 ,16) %>
						</td>
						
						<%
						CounterIn++;
						}
						%>
					
						<%
						} // for 
						%>
						<td>
						<%=CounterIn %>
						</td>
						</tr>
						<tr>
						<td>
						<%= empObjMulty[userCounter].getContactnumber()%>
						</td>
						<td colspan="2">
						<%= empObjMulty[userCounter].getAddress()%>
						</td>
						<td colspan="4">
						<%= empObjMulty[userCounter].getBirthDate().toString().substring(0,11)%>
						</td>
						<% 
						int t3=dd1;
						for (int day=15 ; day >=1; day--  )
						{
							int t2=dd2;
							if(t3<t2-15)
							{
							t3=t2;	
							}
							
							System.out.println("In Loop no 1");
							String OutBoth=" " ;
							String InBoth=" " ;
							String mm =	hardcodeDate.substring(5,7);
							String yyyy =hardcodeDate.substring(0,4);
							String dd=" ";	
								if (day < 10  )
								{
								 dd =A.getDay(day);
								}
								else if (day >= 10 && day <= 31)
								{
									dd=String.valueOf(day);
								}
									
								
							
								
								
								String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId() +" and   month(time)="+mm1+" and day(time)="+t3 +" and year(time)="+year1+" order by time desc";
								System.out.println("QueryOut"+QueryOut);
								OutBoth=A.passQuery(cong, QueryOut, "time");
								t3--;
							
						
						if ("0".equalsIgnoreCase(OutBoth))
						{
						%>
						<td >
						<font color="red">
						- 
						</font>
						</td>
						<%
						}
						else
						{
						%>
						<td>
						<%=OutBoth.substring(11 ,16) %>
						</td>
						<%
						 CounterOut++;
						}
						
						}
						%>
						<td>
						<%=CounterOut %>
						</td>
						</tr>
						<% 
					
						
						
					}
					
					} // if close 
					
				}
				
				
				else
				{
					empObj=empDbObj.selectMasterEngineerDb(cong ,Long.parseLong(EngineerId));
					String joinDate =empObj.getJoinDate().toString();
					
					int CounterIn=0;
					int CounterOut=0;
				%>
				
				<tr>
				<td>
				Name
				</td>
				<td colspan="2">
				Designation
				</td>
				<td colspan="4"  >
				Join_Date 
				</td>
				
					<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
					<td align="center">
					<%int abc7=abc6-1; %>
					<%=abc7 %>
					<%if(abc7==1){
						
					abc7=32;	
					} %>
					</td>
					<td align="center">
					<%int abc8=abc7-1; %>
					<%=abc8 %>
					<%if(abc8==1){
						
					abc=8;	
					} %>
					</td>
					<td align="center">
					<%int abc9=abc8-1; %>
					<%=abc9 %>
					<%if(abc9==1){
						
					abc9=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc10=abc9-1; %>
					<%=abc10 %>
					<%if(abc10==1){
						
					abc10=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc11=abc10-1; %>
					<%=abc11 %>
					<%if(abc11==1){
						
					abc11=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc12=abc11-1; %>
					<%=abc12 %>
					<%if(abc12==1){
						
					abc12=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc13=abc12-1; %>
					<%=abc13 %>
					<%if(abc13==1){
						
					abc13=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc14=abc13-1; %>
					<%=abc14 %>
					<%if(abc14==1){
						
					abc14=32;	
					} %>
					</td>
				
				
				
				<td align="center">
				Counter Present 
				</td>
				</tr>
				<tr>
				
				<%
				
				if (empObj.getEngineerName()== null)
				{
				%>	
					<td>
					-
					</td>
				<% 
				}
				else
				{%>
					<td>
					<%=empObj.getEngineerName() %>
					</td>
					
				<% 
				}
				%>
				</td>
				<td colspan="2">
				<%=empObj.getDesgnationId() %> 
				</td>
				<%
				if (empObj.getJoinDate() == null )
				{
				%>
				<td colspan="4">
				-
				</td>
				<%
				}else
				{%>
				<td colspan="4">
				<%=joinDate.substring(0 , 11) %> 
				</td>	
				<% 
				}
				
			
				int t=dd1;
				for (int day=15 ; day >=1; day--  )
				{ 
					System.out.println("In Loop no 2");
					String OutBoth=" " ;
					String InBoth=" " ;
					String mm =	hardcodeDate.substring(5,7);;
					//System.out.println("mm=="+mm);
					String yyyy =hardcodeDate.substring(0,4);;
					//System.out.println("yyyy=="+yyyy);
					String dd=" ";	
					if (day < 10  )
					{
					 dd =A.getDay(day);
					}
					else if (day >= 10 && day <= 31)
					{
						dd=String.valueOf(day);
					}
				
					
					
					
					
					
							
						//int t=dd1;
						System.out.println("t=="+t);
						String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+" and  month(time)="+mm1+" and day(time)="+t+" and year(time)="+year1;
						System.out.println("QueryIn===="+QueryIn);
					t--;
					//	out.println("QueryIn="+QueryIn);
						InBoth=A.passQuery(cong, QueryIn, "time");
						
				//		System.out.println("InBoth"+InBoth);
					
				if ("0".equalsIgnoreCase(InBoth))
				{
				%>
				<td>
				<font color="red">
				- 
				</font>
				</td>
				<%
				}
				else
				{
				%>
				<td>
				
				<%=InBoth.substring(11 ,16) %>
				
				<%
				CounterIn++;
				}
				%>
				
				<% 
				} // for 
				%>
				<td>
				<%=CounterIn %>
				</td>
				</tr>
				<tr>
			
				<%
				if (empObj.getContactnumber() == 0)
				{
				%><td>
				-
				</td>
				<%
				}else
				{
				%>
				<td>
				<%=empObj.getContactnumber() %>
				</td>
				<%
				}
				if(empObj.getAddress() == null)
				{
				%>
				<td colspan="2">
				-
				</td>
				<%
				}
				else
				{
				%>
				<td colspan="2">
				<%=empObj.getAddress() %>
				</td>
				<%
				}
				if (empObj.getBirthDate() == null)
				{%>
					<td colspan="4">
					-
					</td>
				<% 
				}
				else
				{
				%>
				<td colspan="4">
				<%=empObj.getBirthDate().toString().substring(0,11) %>
				</td>
				<%
				}
				for (int day=15 ; day >=1; day--  )
				{
					System.out.println("In Loop no 3");
					String OutBoth=" " ;
					String InBoth=" " ;
					String mm =	hardcodeDate.substring(5,7);;
					String yyyy =hardcodeDate.substring(0,4);;
					String dd=" ";	
						if (day < 10  )
						{
						 dd =A.getDay(day);
						}
						else if (day >= 10 && day <= 31)
						{
							dd=String.valueOf(day);
						}
							//int Quryday=0;
						String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+"  and  month(time)="+mm1+" and day(time)="+dd1+" and year(time)="+ year1+" order by time desc";
						System.out.println("QueryOut ========="+QueryOut);
						OutBoth=A.passQuery(cong, QueryOut, "time");
					dd1--;	
					
				%>
				
			
				<%
				if ("0".equalsIgnoreCase(OutBoth))
				{
				%>
				<td>
				<font color="red">
				- 
				</font>
				</td>
				<%
				}
				else
				{
				%>
				<td>
				<%=OutBoth.substring(11 ,16) %>
				</td>
				<%
				CounterOut++;
				}
				%>
				
				<%
				}
				%>
				<td>
				<%=CounterOut %>
				</td>
				</tr>
				<% 
				}
				} //Startin 30 report
				else if("30".equalsIgnoreCase(ReportDay)){
					%>
					<table width="100%"  align="center" bordercolor="gray"  cellspacing=0 cellpadding=2  border="1">
					<tr>
					<td colspan="39" align="center">
					Smayak softWare 
					</td>
					</tr>
					<tr>
					<td colspan="39" align="center">
				  	 MUSTER BOOK
					</td>
					</tr>
					<%
				
					String checkAll = AA.getNameCondition(cong , "masterEngineer" , "engineerName" , " where active=1  and CurrentActive=1 and engineerId ="+EngineerId);
					
					if("All".equalsIgnoreCase(checkAll))
					{

						String Query ="select count(engineerId) as counter from masterEngineer where active =1  and CurrentActive=1" ;
						long counterUser =Long.parseLong(A.passQuery(cong, Query, "counter"));
						masterEngineerBean empObjMulty [] = new masterEngineerBean [Integer.parseInt(String.valueOf(counterUser))];
						empObjMulty = empDbObj.selectMasterEngineerDb(cong , " where active=1  and CurrentActive=1 ", Integer.parseInt(String.valueOf(counterUser)) );
						 %>
							<tr >
							<td>
							Name
							</td>
							<td colspan="2">
							Designation
							</td>
							<td  colspan="4"  >
							Join_Date 
							</td>
							
						<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
					<td align="center">
					<%int abc7=abc6-1; %>
					<%=abc7 %>
					<%if(abc7==1){
						
					abc7=32;	
					} %>
					</td>
					<td align="center">
					<%int abc8=abc7-1; %>
					<%=abc8 %>
					<%if(abc8==1){
						
					abc=8;	
					} %>
					</td>
					<td align="center">
					<%int abc9=abc8-1; %>
					<%=abc9 %>
					<%if(abc9==1){
						
					abc9=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc10=abc9-1; %>
					<%=abc10 %>
					<%if(abc10==1){
						
					abc10=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc11=abc10-1; %>
					<%=abc11 %>
					<%if(abc11==1){
						
					abc11=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc12=abc11-1; %>
					<%=abc12 %>
					<%if(abc12==1){
						
					abc12=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc13=abc12-1; %>
					<%=abc13 %>
					<%if(abc13==1){
						
					abc13=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc14=abc13-1; %>
					<%=abc14 %>
					<%if(abc14==1){
						
					abc14=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc15=abc14-1; %>
					<%=abc15 %>
					<%if(abc15==1){
						
					abc15=32;	
					} %>
					</td>
					<td align="center">
					<%int abc16=abc15-1; %>
					<%=abc16 %>
					<%if(abc16==1){
						
					abc16=32;	
					} %>
					</td>
					<td align="center">
					<%int abc17=abc16-1; %>
					<%=abc17 %>
					<%if(abc17==1){
						
					abc17=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc18=abc17-1; %>
					<%=abc18 %>
					<%if(abc18==1){
						
					abc18=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc19=abc18-1; %>
					<%=abc19 %>
					<%if(abc19==1){
						
					abc19=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc20=abc19-1; %>
					<%=abc20 %>
					<%if(abc20==1){
						
					abc20=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc21=abc20-1; %>
					<%=abc21 %>
					<%if(abc21==1){
						
					abc21=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc22=abc21-1; %>
					<%=abc22 %>
					<%if(abc22==1){
						
					abc22=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc23=abc22-1; %>
					<%=abc23 %>
					<%if(abc23==1){
						
					abc23=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc24=abc23-1; %>
					<%=abc24 %>
					<%if(abc24==1){
						
					abc24=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc25=abc24-1; %>
					<%=abc25 %>
					<%if(abc25==1){
						
					abc25=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc26=abc25-1; %>
					<%=abc26 %>
					<%if(abc26==1){
						
					abc26=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc27=abc26-1; %>
					<%=abc27 %>
					<%if(abc27==1){
						
					abc27=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc28=abc27-1; %>
					<%=abc28 %>
					<%if(abc28==1){
						
					abc28=32;	
					} %>
					</td>
					<td align="center">
					<%int abc29=abc28-1; %>
					<%=abc29%>
					<%if(abc29==1){
						
					abc29=32;	
					} %>
					</td>
					
					
					
						<td align="center">
							Counter Present
							</td>
							</tr>
						 
						<% 
						for (int userCounter=0 ; userCounter < counterUser ; userCounter++  )
						{
						if (! empObjMulty[userCounter].getEngineerName().equalsIgnoreCase("All"))
						{
						%>
							<tr>
							<td>
							<%= empObjMulty[userCounter].getEngineerName()%>
							</td>
							<td colspan="2">
							<%= empObjMulty[userCounter].getDesgnationId()%>
							</td>
							<td colspan="4">
							<%= empObjMulty[userCounter].getJoinDate().toString().substring(0 , 11)%>
							</td>
							
							<%
						
							int CounterIn=0;
							int CounterOut=0;
							int t=dd1;
							for (int day=30 ; day >=1; day--)
							{
								
								
									//System.out.println("inside if condition");
									int t2=dd2;
								
									if(t<t2-30)
									{
									t=t2;	
									}
									
								
								System.out.println("Inside Intime query<br>");
								String OutBoth=" " ;
								String InBoth=" " ;
								String mm =	hardcodeDate.substring(5,7);;
								String yyyy =hardcodeDate.substring(0,4);;
								String dd=" ";	
								if (day < 10  )
									{
									 dd =A.getDay(day);
									}
									else if (day >= 10 && day <= 31)
									{
										dd=String.valueOf(day);
									}
										
									
									String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId()+" and  month(time)="+mm1 +" and day(time)="+t+" and year(time)="+year1;
									System.out.println("QueryIn=="+QueryIn);
									t--;
									InBoth=A.passQuery(cong, QueryIn, "time");
									
									
								
								
							%>
							
							
							<%
							if ("0".equalsIgnoreCase(InBoth))
							{
							%>
							<td >
							<font color="red">
							- 
							</font>
							</td>
							<%
							}
							else
							{
							%>
							<td >
							<%=InBoth.substring(11 ,16) %>
							</td>
							
							<%
							CounterIn++;
							}
							%>
						
							<%
							} // for 
							%>
							<td>
							<%=CounterIn %>
							</td>
							</tr>
							<tr>
							<td>
							<%= empObjMulty[userCounter].getContactnumber()%>
							</td>
							<td colspan="2">
							<%= empObjMulty[userCounter].getAddress()%>
							</td>
							<td colspan="4">
							<%= empObjMulty[userCounter].getBirthDate().toString().substring(0,11)%>
							</td>
							<% 
							int t3=dd1;
							for (int day=30 ; day >=1; day--  )
							{
								int t2=dd2;
								if(t3<t2-30)
								{
								t3=t2;	
								}
								
								System.out.println("In Loop no 1");
								String OutBoth=" " ;
								String InBoth=" " ;
								String mm =	hardcodeDate.substring(5,7);
								String yyyy =hardcodeDate.substring(0,4);
								String dd=" ";	
									if (day < 10  )
									{
									 dd =A.getDay(day);
									}
									else if (day >= 10 && day <= 31)
									{
										dd=String.valueOf(day);
									}
										
									
								
									
									
									String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId() +" and   month(time)="+mm1+" and day(time)="+t3 +" and year(time)="+year1+" order by time desc";
									System.out.println("QueryOut"+QueryOut);
									OutBoth=A.passQuery(cong, QueryOut, "time");
									t3--;
								
							
							if ("0".equalsIgnoreCase(OutBoth))
							{
							%>
							<td >
							<font color="red">
							- 
							</font>
							</td>
							<%
							}
							else
							{
							%>
							<td>
							<%=OutBoth.substring(11 ,16) %>
							</td>
							<%
							 CounterOut++;
							}
							
							}
							%>
							<td>
							<%=CounterOut %>
							</td>
							</tr>
							<% 
						
							
							
						}
						
						} // if close 
						
					}
					
					
					else
					{
						empObj=empDbObj.selectMasterEngineerDb(cong ,Long.parseLong(EngineerId));
						String joinDate =empObj.getJoinDate().toString();
						
						int CounterIn=0;
						int CounterOut=0;
					%>
					
					<tr>
					<td>
					Name
					</td>
					<td colspan="2">
					Designation
					</td>
					<td colspan="4"  >
					Join_Date 
					</td>
					
					<td align="center">
					<%int abc=currentTime.getDate(); %>
					<%=abc%>
					<%if(abc==1){
						
					abc=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc1=abc-1; %>
					<%=abc1 %>
					<%if(abc1==1){
						
					abc1=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc2=abc1-1; %>
					<%=abc2 %>
					<%if(abc2==1){
						
					abc2=32;	
					} %>
					
					</td>
					<td align="center">
					<%int abc3=abc2-1; %>
					<%=abc3 %>
					<%if(abc3==1){
						
					abc3=32;	
					} %>
					
					</td>
					<td  align="center">
					<%int abc4=abc3-1; %>
					<%=abc4 %>
			<%if(abc4==1){
						
					abc4=32;	
					} %>		
					</td>
					<td  align="center">
					<%int abc5=abc4-1; %>
					<%=abc5 %>
					<%if(abc5==1){
						
					abc5=32;	
					} %>
					</td>
					<td  align="center">
					<%int abc6=abc5-1; %>
					<%=abc6 %>
					<%if(abc6==1){
						
					abc6=32;	
					} %>
				</td>
					<td align="center">
					<%int abc7=abc6-1; %>
					<%=abc7 %>
					<%if(abc7==1){
						
					abc7=32;	
					} %>
					</td>
					<td align="center">
					<%int abc8=abc7-1; %>
					<%=abc8 %>
					<%if(abc8==1){
						
					abc=8;	
					} %>
					</td>
					<td align="center">
					<%int abc9=abc8-1; %>
					<%=abc9 %>
					<%if(abc9==1){
						
					abc9=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc10=abc9-1; %>
					<%=abc10 %>
					<%if(abc10==1){
						
					abc10=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc11=abc10-1; %>
					<%=abc11 %>
					<%if(abc11==1){
						
					abc11=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc12=abc11-1; %>
					<%=abc12 %>
					<%if(abc12==1){
						
					abc12=32;	
					} %>
					
					
					</td>
					<td align="center">
					<%int abc13=abc12-1; %>
					<%=abc13 %>
					<%if(abc13==1){
						
					abc13=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc14=abc13-1; %>
					<%=abc14 %>
					<%if(abc14==1){
						
					abc14=32;	
					} %>
					</td>
					
					
					<td align="center">
					<%int abc15=abc14-1; %>
					<%=abc15 %>
					<%if(abc15==1){
						
					abc15=32;	
					} %>
					</td>
					<td align="center">
					<%int abc16=abc15-1; %>
					<%=abc16 %>
					<%if(abc16==1){
						
					abc16=32;	
					} %>
					</td>
					<td align="center">
					<%int abc17=abc16-1; %>
					<%=abc17 %>
					<%if(abc17==1){
						
					abc17=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc18=abc17-1; %>
					<%=abc18 %>
					<%if(abc18==1){
						
					abc18=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc19=abc18-1; %>
					<%=abc19 %>
					<%if(abc19==1){
						
					abc19=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc20=abc19-1; %>
					<%=abc20 %>
					<%if(abc20==1){
						
					abc20=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc21=abc20-1; %>
					<%=abc21 %>
					<%if(abc21==1){
						
					abc21=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc22=abc21-1; %>
					<%=abc22 %>
					<%if(abc22==1){
						
					abc22=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc23=abc22-1; %>
					<%=abc23 %>
					<%if(abc23==1){
						
					abc23=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc24=abc23-1; %>
					<%=abc24 %>
					<%if(abc24==1){
						
					abc24=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc25=abc24-1; %>
					<%=abc25 %>
					<%if(abc25==1){
						
					abc25=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc26=abc25-1; %>
					<%=abc26 %>
					<%if(abc26==1){
						
					abc26=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc27=abc26-1; %>
					<%=abc27 %>
					<%if(abc27==1){
						
					abc27=32;	
					} %>
					</td>
					
					<td align="center">
					<%int abc28=abc27-1; %>
					<%=abc28 %>
					<%if(abc28==1){
						
					abc28=32;	
					} %>
					</td>
					<td align="center">
					<%int abc29=abc28-1; %>
					<%=abc29%>
					<%if(abc29==1){
						
					abc29=32;	
					} %>
					</td>
					
					
					<td align="center">
					Counter Present 
					</td>
					</tr>
					<tr>
					
					<%
					
					if (empObj.getEngineerName()== null)
					{
					%>	
						<td>
						-
						</td>
					<% 
					}
					else
					{%>
						<td>
						<%=empObj.getEngineerName() %>
						</td>
						
					<% 
					}
					%>
					</td>
					<td colspan="2">
					<%=empObj.getDesgnationId() %> 
					</td>
					<%
					if (empObj.getJoinDate() == null )
					{
					%>
					<td colspan="4">
					-
					</td>
					<%
					}else
					{%>
					<td colspan="4">
					<%=joinDate.substring(0 , 11) %> 
					</td>	
					<% 
					}
					
				
					int t=dd1;
					for (int day=30 ; day >=1; day--  )
					{ 
						System.out.println("In Loop no 2");
						String OutBoth=" " ;
						String InBoth=" " ;
						String mm =	hardcodeDate.substring(5,7);;
						//System.out.println("mm=="+mm);
						String yyyy =hardcodeDate.substring(0,4);;
						//System.out.println("yyyy=="+yyyy);
						String dd=" ";	
						if (day < 10  )
						{
						 dd =A.getDay(day);
						}
						else if (day >= 10 && day <= 32)
						{
							dd=String.valueOf(day);
						}
					
						
						
						
						
						
								
							//int t=dd1;
							System.out.println("t=="+t);
							String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+" and  month(time)="+mm1+" and day(time)="+t+" and year(time)="+year1;
							System.out.println("QueryIn===="+QueryIn);
						t--;
						//	out.println("QueryIn="+QueryIn);
							InBoth=A.passQuery(cong, QueryIn, "time");
							
					//		System.out.println("InBoth"+InBoth);
						
					if ("0".equalsIgnoreCase(InBoth))
					{
					%>
					<td>
					<font color="red">
					- 
					</font>
					</td>
					<%
					}
					else
					{
					%>
					<td>
					
					<%=InBoth.substring(11 ,16) %>
					
					<%
					CounterIn++;
					}
					%>
					
					<% 
					} // for 
					%>
					<td>
					<%=CounterIn %>
					</td>
					</tr>
					<tr>
				
					<%
					if (empObj.getContactnumber() == 0)
					{
					%><td>
					-
					</td>
					<%
					}else
					{
					%>
					<td>
					<%=empObj.getContactnumber() %>
					</td>
					<%
					}
					if(empObj.getAddress() == null)
					{
					%>
					<td colspan="2">
					-
					</td>
					<%
					}
					else
					{
					%>
					<td colspan="2">
					<%=empObj.getAddress() %>
					</td>
					<%
					}
					if (empObj.getBirthDate() == null)
					{%>
						<td colspan="4">
						-
						</td>
					<% 
					}
					else
					{
					%>
					<td colspan="4">
					<%=empObj.getBirthDate().toString().substring(0,11) %>
					</td>
					<%
					}
					for (int day=30 ; day >=1; day--  )
					{
						System.out.println("In Loop no 3");
						String OutBoth=" " ;
						String InBoth=" " ;
						String mm =	hardcodeDate.substring(5,7);;
						String yyyy =hardcodeDate.substring(0,4);;
						String dd=" ";	
							if (day < 10  )
							{
							 dd =A.getDay(day);
							}
							else if (day >= 10 && day <= 32)
							{
								dd=String.valueOf(day);
							}
								//int Quryday=0;
							String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+"  and  month(time)="+mm1+" and day(time)="+dd1+" and year(time)="+ year1+" order by time desc";
							System.out.println("QueryOut ========="+QueryOut);
							OutBoth=A.passQuery(cong, QueryOut, "time");
						dd1--;	
						
					%>
					
				
					<%
					if ("0".equalsIgnoreCase(OutBoth))
					{
					%>
					<td>
					<font color="red">
					- 
					</font>
					</td>
					<%
					}
					else
					{
					%>
					<td>
					<%=OutBoth.substring(11 ,16) %>
					</td>
					<%
					CounterOut++;
					}
					%>
					
					<%
					}
					%>
					<td>
					<%=CounterOut %>
					</td>
					</tr>
					<% 
					}
					
					
					
					
					
					
				}
				
				
			} // catch 
			catch(Exception e)
			{
				e.printStackTrace();
			}finally
			{
				C.returnConnection(cong);
			}
			
		//	}		
			
			%>
			
			</table>
</body>
</form>
</html>