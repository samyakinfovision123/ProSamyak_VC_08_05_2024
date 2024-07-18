<%
/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        add MVC 
* 2	   Anil			    23-04-2011	Done		To Access on Server
* 3    MR Ganesh        26-04-2011  Done        all report   
* 4	   Anil			    26-04-2011  done        TL 2 Version Control
* 5    Prashant			03-06-2016  Done         Alternative Table Row Color Chnage
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

%>
<%@ page language="java" import="java.sql.Date , java.sql.Connection ,samyak.beans.masterEngineerBean,samyak.database.masterEngineerDb"
contentType="text/html; charset=ISO-8859-1"
 pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<jsp:useBean id="C" scope="page" class="NipponBean.Connect" />
<jsp:useBean id="A" scope="page" class="samyak.utils.OldMethodOveride" />
<jsp:useBean id="AA" scope="page" class="NipponBean.Array" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<script type="text/javascript">

function Alternate(id) 
{
	if(document.getElementsByTagName){  

	    var table = document.getElementById(id);
	    var rows = table.getElementsByTagName("tr");
	     for(i = 1; i < rows.length; i++){ 
	      if(i % 2 == 0){ 

	        rows[i].className = "even"; 

	      }else{ 

	        rows[i].className = "odd"; 

	      }       

	    }  

	  } 

	
}
</script>
<style>
.odd{background-color: #b8d1f3;} 
.even{background-color: #dae5f4;} 

</style>
<body onload="Alternate('alternativeRow');">
<form action="#" >
			<%
			String usernameid=String.valueOf(request.getAttribute("usernameid"));
			String EngineerId=String.valueOf(request.getAttribute("EngId"));
			String hardcodeDate =String.valueOf(request.getAttribute("yearmonth"));
			
			
			Connection cong = null;
			Date getDate = new Date (System.currentTimeMillis());
			try 
			{
				cong = C.getConnection();
				masterEngineerBean empObj = new masterEngineerBean ();
				masterEngineerDb empDbObj = new masterEngineerDb ();
				
			%>
			<table width="100%"  align="center" bordercolor="gray"  cellspacing=0 cellpadding=2  border="1" id="alternativeRow">
			<tr>
			<td colspan="39" align="center">
			<h1><b>eSamyak Software Pvt. Ltd, Mumbai India (www.esamyak.com)</b><h1>
			</td>
			</tr>
			<tr>
			<td colspan="39" align="center">
		  	 MONTHLY MUSTER BOOK
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
					<tr style="background-color: #66d9ff;">
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
					1
					</td>
					<td  align="center">
					2
					</td>
					<td align="center">
					3
					</td>
					<td align="center">
					4 
					</td>
					<td  align="center">
					5 
					</td>
					<td  align="center">
					6
					</td>
					<td  align="center">
					7
					</td>
					<td  align="center">
					8
					</td>
					<td align="center">
					9 
					</td>
					<td align="center"  >
					10 
					</td>
					<td  align="center" > 
					11
					</td>
					<td  align="center">
					12
					</td>
					<td align="center">
					13
					</td>
					<td  align="center">
					14 
					</td>
					<td  align="center" >
					15 
					</td>
					<td  align="center">
					16
					</td>
					<td  align="center" >
					17
					</td>
					<td  align="center" >
					18
					</td>
					<td  align="center" >
					19
					</td>
					<td  align="center" >
					20
					</td>
					<td  align="center" >
					21
					</td>
					<td  align="center" >
					22
					</td>
					<td  align="center" >
					23
					</td>
					<td  align="center">
					24 
					</td>
					<td  align="center" >
					25 
					</td>
					<td  align="center">
					26
					</td>
					<td  align="center" >
					27
					</td>
					<td   align="center">
					28
					</td>
					<td  align="center" >
					29
					</td>
					<td  align="center" >
					30
					</td>
					<td align="center">
					31
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
					for (int day=1 ; day <= 31 ; day++  )
					{
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
								
							
							String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId()+" and  month(time)="+mm +" and day(time)="+dd+" and year(time)="+yyyy;
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
					for (int day=1 ; day <= 31 ; day++  )
					{
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
								
							
							System.out.println();
							
							
							String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  engineerId ="+empObjMulty[userCounter].getEngineerId() +" and   month(time)="+mm+" and day(time)="+dd +" and year(time)="+yyyy+" order by time desc";
							OutBoth=A.passQuery(cong, QueryOut, "time");
							
						
					
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
				
			}else
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
			Desination
			</td>
			<td  colspan="4"  >
			Join_Date 
			</td>
			
			<td align="center">
			1
			</td>
			<td  align="center">
			2
			</td>
			<td align="center">
			3
			</td>
			<td align="center">
			4 
			</td>
			<td  align="center">
			5 
			</td>
			<td  align="center">
			6
			</td>
			<td  align="center">
			7
			</td>
			<td  align="center">
			8
			</td>
			<td align="center">
			9 
			</td>
			<td align="center"  >
			10 
			</td>
			<td  align="center" > 
			11
			</td>
			<td  align="center">
			12
			</td>
			<td align="center">
			13
			</td>
			<td  align="center">
			14 
			</td>
			<td  align="center" >
			15 
			</td>
			<td  align="center">
			16
			</td>
			<td  align="center" >
			17
			</td>
			<td  align="center" >
			18
			</td>
			<td  align="center" >
			19
			</td>
			<td  align="center" >
			20
			</td>
			<td  align="center" >
			21
			</td>
			<td  align="center" >
			22
			</td>
			<td  align="center" >
			23
			</td>
			<td  align="center">
			24 
			</td>
			<td  align="center" >
			25 
			</td>
			<td  align="center">
			26
			</td>
			<td  align="center" >
			27
			</td>
			<td   align="center">
			28
			</td>
			<td  align="center" >
			29
			</td>
			<td  align="center" >
			30
			</td>
			<td align="center">
			31
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
			
		
			
			for (int day=1 ; day <= 31 ; day++  )
			{
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
						
					
					String QueryIn= "select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+" and  month(time)="+mm +" and day(time)="+dd+" and year(time)="+yyyy;
					InBoth=A.passQuery(cong, QueryIn, "time");
				
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
			for (int day=1 ; day <= 31 ; day++  )
			{
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
						
					String QueryOut ="select top 1 time  from Attendance  Where  active=1 and  EngineerId ="+empObj.getEngineerId()+"  and  month(time)="+mm+" and day(time)="+dd +" and year(time)="+yyyy+" order by time desc";
					OutBoth=A.passQuery(cong, QueryOut, "time");
					
				
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
			} // catch 
			catch(Exception e)
			{
				e.printStackTrace();
			}finally
			{
				C.returnConnection(cong);
			}
			%>
			
			</table>
</body>
</form>
</html>