<%

/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		11/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
1		Anil			23-04-2011	Done		To Access on Server

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
%>


<%@page language="java" import="java.sql.*,java.io.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="format" scope="application" class="NipponBean.format"/>
<jsp:useBean id="C" scope="application" class="NipponBean.Connect"/>
<jsp:useBean id="AC" class="NipponBean.ArrayCSS"/>
<jsp:useBean id="I" class="NipponBean.Inventory"/>
<jsp:useBean id="G" class="NipponBean.GetDate"/>
<jsp:useBean id="YED" class="NipponBean.YearEndDate"/>



<%
	String user_id= ""+ session.getValue("user_id");
	String machine_name=request.getRemoteHost();
	String query = "";
	int errLine = 15;
	java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	
	int year=D.getYear();
	int dd=D.getDate()+3;
	int mm=D.getMonth();
	java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
	String command=request.getParameter("command");
	String message=request.getParameter("message");
	//String message1=request.getAttribute("message1").toString();
	String invoicedate=format.format(Dprevious);

	Connection con=null;
	Connection cong=null;

	ResultSet rs_g=null;
	PreparedStatement pstmt=null;
	PreparedStatement pstmt_g=null;
	
	
		int counter = 0;
		int i=0;
		try {
		
		cong=C.getConnection();
		con=C.getConnection();
		

	if("Default".equals(command))
	{
		if(message!=null)
				out.println("<center><font class='message1'> "+message+"</font></center>");
		
		//if( ! message1.equalsIgnoreCase("null"))
			//out.println("<center><font class='message1'> "+message1+"</font></center>");
		%>

		<script language="javascript">
		<%
			String lotNoQuery = "Select engineerName from masterEngineer where Active=1 and CurrentActive=1  order by engineerName";
			pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
				
			pstmt_g = cong.prepareStatement(proQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
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

			<html>
			<head>
			<title>Daily Form</title>

	<script language="JavaScript" src="validate_title.js"></script>
	<script language="JavaScript" src="focus.js"></script>
	<SCRIPT language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
	<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
	<SCRIPT language=javascript src="../Samyak/Samyakmultidate.js"></script>
	<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
	<script language=javascript src="../Samyak/common.js"></script>
	<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
	<script language=javascript src="../Samyak/actb.js"></script>
</head>

		<body  background="../Buttons/BGCOLOR.JPG" onLoad='document.mainform.todaysdate.select()'>
	
		<form name=mainform method="post" action="AssignmentDestribution-Add.do">
	
		<table border=1 borderColor=skyblue align=center cellspacing=0 cellpadding=2 align=center>
			<tr>
			<td>
		 		<table borderColor=blue border=0 WIDTH="100%" cellspacing=2 cellpadding=2>
		 		<tr bgcolor="skyblue">
				<th colspan=4 align=center> Engineer Assignment Destribution Form: </th>
		 		</tr>

     			<tr>
    	 		<td>
    	 			<p>Started On  : 
    	 		</td>
				<td>
					<input type="text" name="StartedOn" id="StartedOn"   size="10" value=<%=format.format(today_date)%>  
					onblur='getthefocus(document.mainform.StartedOn);
					return  fnCheckMultiDate(this,"Date"); '
					OnKeyUp="checkMe(this);" >
			  	 </td>
   		 		</tr>
			<tr>	
				<td>
					<script language='javascript'>
					if (!document.layers) 
					{
					document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.targetOn, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Target On' style='font-size:11px ; width:100'>")}
					</script> 
				</td>
	
				<td align=left> 
				<input type=text class="ipstock" name='targetOn' size=8 maxlength=10 value="<%=format.format(format.getDate(invoicedate))%>"
				onblur='return  fnCheckMultiDate(this,"Date")' OnKeyUp="checkMe(this);">	
				</td>
  				</tr>		
	
		<tr>
			<td>
				Engineer Name :
	 		</td>
			<td >
				<input type=text name=engineername id=engineer_name value=""  size=15 autocomplete=off onBlur="return nullvalidation(this)" >
				</td>
				<script language="javascript">	
				var companyobj = new  actb(document.getElementById('engineer_name'), engArray);	
				</script>	
	 </tr>
			
	

			<tr>
				<td>
					<p>AssignBy Eng Name :
				</td>
				<td>
					
					<input type=text name="AssignmentByEngineername" id="AssignmentByengineername" value=""  size=15 autocomplete=off onBlur="return nullvalidation(this)"  >
				</td>
				<script language="javascript">	
				var companyobj = new  actb(document.getElementById('AssignmentByEngineername'), engArray);	
				</script>	
			</tr>
			<tr>
				<td>
					Project Name :
				</td>
				<td>
					<input type=text name=projectname id=project_name value=""  size=15 autocomplete=off onBlur='return nullvalidation(this)' ></td>
					<script language="javascript">
					var companyobj = new  actb(document.getElementById('project_name'), proArray);	
					</script>	
			</tr>
			<tr>
				<td>
						<p>Assignment Type :
						
				 </td>
<%  
	query = "select count(*) as counter from masterType";
	pstmt = con.prepareStatement(query);
		   rs_g = pstmt.executeQuery();
		   while(rs_g.next())
		   {
			counter = rs_g.getInt("counter");
		   }
	pstmt.close();
	//System.out.println("Line Number 189 pstmt_g closed assignment_type");
	rs_g.close();
   
		   String atype1[]=new String[counter];
		   String atypeid1[]=new String[counter];
	query = "select typeId,typeName from masterType";
	pstmt = con.prepareStatement(query);
		   rs_g = pstmt.executeQuery();
		   i=0;
		   while(rs_g.next()) {
  		   errLine=198;
		   atypeid1[i]=rs_g.getString("typeId");	atype1[i]=rs_g.getString("typeName");
		   i++;
		   }
	pstmt.close();
	//System.out.println("Line Number 205 pstmt_g closed ");
	rs_g.close();

%>

			<td>
				<select name="atype" size=1>
				<%for(int j=0;j<counter;j++) { errLine=207;%>
				<option value=<%=atypeid1[j]%>> <%=atype1[j]%></option> <%}%>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				<p>Priority : </td>
	<%							
			query = "select count(*) as counter from masterPriority";
			pstmt = con.prepareStatement(query);
			rs_g = pstmt.executeQuery();
			while(rs_g.next()) {
			counter = rs_g.getInt("counter");
			}
			pstmt.close();
			rs_g.close();
	
	String priority1[]=new String[counter];
	String priorityid1[]=new String[counter];
	
	query = "select priorityId,priorityName from masterPriority";
	pstmt = con.prepareStatement(query);
		rs_g = pstmt.executeQuery();
		i=0;
		while(rs_g.next()) {
		errLine=237;
		priorityid1[i]=rs_g.getString("priorityId");
		priority1[i]=rs_g.getString("priorityName");
		i++;
		}
	pstmt.close();
	rs_g.close();
%>

		<td>
		<select name="priorityname" size=1>
		<%
		for(int j=0;j<counter;j++)
		{
		%>
		<option value=<%=priorityid1[j]%>><%=priority1[j]%></option>
		<%
		}
		%>
		</select>
		</td>
		</tr>
 		<tr>
 		<td>
 		<p>Assignment Name : 
 		</td>
		<td><input type="text" name="AssignmentName" size="30"></td>
		</tr>
		<tr>
		<td>
		<p>Assignment Description :
		</td>
		<td>
		<Textarea name="description" 
		cols="30" rows="3">
		</Textarea>
		 </td>
		</tr>
		<tr>
		<td colspan=4><hr></td>
		</tr>

		<tr>
		<td colspan=2 align="center">								
		<input type="submit" name="command" value="Save" style="height:25px; width:80px; background:#D3D5A8; font-size:16" onClick="return validate_title()">
		</tr>
		</table>
		</table>

		
		<%       
		} // default Command
			
		}
		catch(Exception e)
		{
		System.out.println(e);	
		}
		finally
		{
		C.returnConnection(cong);
		C.returnConnection(con);
		}
		
		%>
</form>
</body>
</html>


