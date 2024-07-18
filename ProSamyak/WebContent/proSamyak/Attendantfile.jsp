<%

/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		11/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    Mr ganesh        22-04-2011  Done        time problem
* 3		Anil			23-04-2011	Done		To Access on Server
* 4    Mr Ganesh 		26-04-2011  Done        server Time Increamnet 
* 5		Anil			26-04-2011  done        TL 2 Version Control & textarea instead of text for remark
* 6		Chanchal		19-07-2011  Done        Daily Note Started.
* 7   Chanchal		23/09/2011	Done	Daily note & Meta tag expires and auctocomplet off applied  cvd230911
*  8 07Oct 2011 * "You can't connect the dots looking forward; you can only connect them looking backward. So you have to trust that the dots will somehow connect in your future. You have to trust in something -- your gut, destiny, life, karma, whatever. This approach has never let me down, and it has made all the difference in my life." 

-Stanford University commencement speech, 2005
* 9  Chanchal - Notice for Project names correction in all future communication
* 10 ParagJ            04-01-2024   Done         Set Date And Time
* 11 ParagJ            29-03-2024   Done         Set Date And Time (9 hrs, 30 mins)

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
%>

<%@ page language="java"  import="java.sql.Connection ,java.sql.Timestamp"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="A" scope="page" class="NipponBean.Array" />
 <jsp:useBean id="C" scope="page" class="NipponBean.Connect" />

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT">
<title>Insert title here</title>

</head>
<body>
<%
Connection cong = null;

			try {
				
				
			    String userName=String.valueOf(session.getAttribute("user_name"));
			    String EmployeeNameID =String.valueOf(session.getAttribute("empName"));
			    
				System.out.println("EmP_Id"+EmployeeNameID);
				cong = C.getConnection();
				Timestamp currentTime = new Timestamp(System.currentTimeMillis());
				
				String Save = String.valueOf(request.getAttribute("Save"));
				String empName = A.getNameCondition(cong , "masterEngineer", "engineerName", "  where active = 1  and CurrentActive=1 and engineerId ="+EmployeeNameID );
				
				currentTime.setHours(( currentTime.getHours() + 9));//chanchal //ParagJ29032024
				currentTime.setMinutes((currentTime.getMinutes() + 30));
				%>
				<form action="attendant-Add.do" method="post" autocomplete=off> <!-- cvd230911 -->

				<table align=center>
<tr><th>
<font color=blue>
<Marquee>Do Visit, Give your feedback in proSamyak. (Project Name = esamyak.com 

<a href="http://esamyak.com/new/" target=_blank>Samyak new website www.esamyak.com/new </a>
<!-- Please Read Date 11 Oct 2011 , Tuesday. --><br>
</marquee>
</th>
</tr>
<tr><td>
&nbsp;&nbsp<br> <font color=blue><!--
Samyak Notice No 1 - Date 11 Oct 2011 --> <br> 

<!--
Notice 1 : Mandatory to reference Project Names in All Samyak-Internal communications and systems. <br>
 
Communications: Email, Telephonic conversation, personal communications with fellow colleagues, etc. <br>

Systems: Tomcat Instance, Eclipse files, Database Names, etc. <br>
 
List of Project Names: Swasitk1112, BlueBird1112, Apple, Samayk5.0, SamyakAmbition, GemJp4.8Star, SamyakVC2011 etc. <br>

Note: <br>
1. Casing must be maintained as per the list above. <br>
2. Spaces (Leading/Trailing/Inline) are not to be used. <br>
3. Usage of Project Names allows for brevity & clarity, & helps set the context of people involved. <br></td></tr>

-->
</font>
</table>

				<table width="50%"  align="center" bordercolor="gray" border="2">


				<%
				if ( !( Save.equalsIgnoreCase("NULL")))
				{%>
				<tr>
				<td colspan="2" align="center" >
				<%=Save %>	
				</td>
				</tr>
				<%
				}
				if (userName.equalsIgnoreCase("admin"))
				{
				%>
				<tr>
				<td>
				Employee Name
				</td>
				<td>
				<input type="text"  value="<%=empName %>" name="user" />
				</td>
				</tr>
				<tr>
				<td>
				Date &  Time 
				</td>
				<td>
				<input type="text" value="<%= currentTime.toString().substring(0,16) %>" name="time" />
				</td>
				</tr>
				<tr>
				<td colspan="2" align="center">
				&nbsp;
				</td>
				</tr>				
				<tr>
				<td colspan="2" align="center">
				<%
				if ( !( Save.equalsIgnoreCase("NULL")))
				{
				%>
				<input type="submit" value="save" name="command" disabled="disabled"/>
				<%
				}else
				{%>
					
						<input type="submit" value="save" name="command" />
				<% 
				}
				%>
				</td>
				</tr>
				</table>
				</form>	
				<% 
				}else
				{
				%>
				<tr>
				<td>
				Employee Name
				</td>
				<td>
				<%=empName %>
				<input type="hidden" value="<%=EmployeeNameID %>" name="user" />
				</td>
				</tr>
				<tr>
				<td>
				Date &  Time 
				</td>
				<td>
				<%=currentTime.toString().substring(0,16)%>
				
				<input type="hidden" value="<%=currentTime%>" name="time" />
				
				</td>
				</tr>
				<tr>
				<td>
				Work 
				</td>
				<td>
				<Textarea name="remark" 
		cols="30" rows="3"></Textarea>
				 
				</td>
				</tr>		
				<tr>
				<td colspan="2" align="center">
				<%
				if ( !( Save.equalsIgnoreCase("NULL")))
				{%>
					
				<input type="submit" value="save" name="command"  disabled="disabled"/>
				<%
				}else
				{
				%>
				<input type="submit" value="save" name="command" />
				<%
				}
				%>
				</td>
				</tr>
	
				

				<tr><td colspan=2 align=left> <font color=#330099>
				&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Thought for the day : <br> </td>
</tr><tr>
				<td colspan=2 align=center> <font color=#660000>
 <br>
"Successful people tend to become more successful because they are always thinking about their successes."   <br> ~
	<a href="http://en.wikipedia.org/wiki/Brian_Tracy" target=_blank>Brian Tracy </a>

 

		


</font> </td>
<tr><td align=right colspan=2><font color=#330099>
				&nbsp Keep walking...................!..<br>
</font>


				
				</td></tr>
				</table>
				</form>
			<%
			}
			}catch(Exception e){
				System.out.println("Error "+e);
			}finally{
				C.returnConnection(cong);
			}
			
			
		

%> 

 
</body>
</html>