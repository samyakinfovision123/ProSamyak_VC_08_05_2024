<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="db" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

<% 
int errLine=9;
Connection conp=null;
Connection cong=null;
ResultSet rs_g=null;
PreparedStatement pstmt_g =null;
try{

String message="";  

String command=request.getParameter("command");
//out.print("<br> command="+command);
message=request.getParameter("message");
//out.print("<br>17 message="+message);


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());
//String today=format.format(D);
//out.print(today);
String machine_name=request.getRemoteHost();
//out.print("<br>machine_name"+machine_name);
String user_id=""+session.getValue("user_id");
//out.print("<br>user_id"+user_id);
PreparedStatement pstmt_p=null;

String condition="";

	conp=db.getConnection();
	cong=db.getConnection();
	conp.setAutoCommit(false);

	//out.print("<br>25 command="+command);

 errLine=43; 
  %>

<html>
<head>
    <link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css" media="all">
	<script language=javascript src="../Samyak/dovedate.js"> </script>
	<script language=javascript src="../Samyak/dovecalendar.js"></script> 
	<script language="JavaScript" SRC="../Samyak/lw_layers.js"> </script>
	<script language="JavaScript" src="../Samyak/lw_menu.js"></script>

</script>

<script language=javascript>
	function change()
	{
		if(document.mainform.user_selection.value == 0 )
		{
			alert("Please Select Entity");
			return;
		}

		if(document.mainform.user_selection.value != 2)
		{
			document.mainform.condition.value="allow";
			document.mainform.time.value="after";
		//document.mainform.command.value="Default";

			document.mainform.submit();
		}
	}
	
 function onSubmitValidate()
 {
  if(document.mainform.username.value=="")
	 {
	  alert("Enter the User Name");
	  document.mainform.username.focus();
	 return false;
	}

  if(document.mainform.password.value=="")
	 {
	  alert("Enter the Password");
	  document.mainform.password.focus();
	 return false;
	}
	

		
  if(document.mainform.repassword.value=="")
	 {
	  alert("Enter the Retype Password");
	  document.mainform.repassword.focus();
	 return false;
	}

 if(document.mainform.repassword.value!=document.mainform.password.value)
	 {
	  alert("Retype Password will be same as Password");
	  document.mainform.repassword.focus();
	 return false;
	}
 }
</script>
</head>
<body bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">

<%String user_selection=request.getParameter("user_selection");
condition=request.getParameter("condition");
String time=request.getParameter("time");

if("allow".equals(condition))
{
%>
<form name=mainform action='addUser.jsp?message=Default' method=post >
<table align=center border=1  bordercolor=skyblue cellspacing=2 cellpadding=2>

<% 

  if(!("Default".equals(message)))
	{
		out.print("<pre><b><p align=center class=msgred>"+message+"</p><b></pre>");
    }
	else{}

%>


<%if(!"after".equals(time)){%>
<tr>
<th  class="td6" colspan=4 >Add User
</th></tr>

<tr>
    <td class="td4">User Name <font class="star1">*</font> 
    <td colspan=3><input type=text name=username size=20 value="">	


<tr>
    <td class="td4">Password <font class="star1">*</font> 
    <td colspan=3>
	<input type=password name=password maxlength=10 >
	

<tr>
    <td class="td4">Retype Password <font class="star1">*</font> 
    <td colspan=3>
	<input type=password name=repassword maxlength=10 >
	
<!--
<tr>
    <td class="td4">Name <font class="star1">*</font> 
    <td colspan=3>
	<input type=text name=name size=50 value="" >
-->	

	<input type=hidden name=condition value="">
	<input type=hidden name=time value="">
	<!--<input type=hidden name=command value="Default">-->
<tr>
	<td class="td4">For Whom</td>
	<td colspan=3>
<%
String query ="select Eid, EName from Entity Where Active=1 and EName <> 'Admin'";

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
String html_array ="<select name='user_selection' onChange='change()'>";
 html_array = html_array +"<option value='0'>Select</option>"; 
int i=1;
while(rs_g.next())
{
	 String temp1 = rs_g.getString("Eid");		
	 String temp = rs_g.getString("EName");
	 
	 html_array = html_array +"<option value='"+temp1 +"'>"+temp+"</option>"; 

	out.print("<input type=hidden name='EntityID"+temp1+"' value='"+temp1+"'>");
	out.print("<input type=hidden name='EntityValue"+temp1+"' value='"+temp+"'>");
	i++;
}
html_array = html_array +" </select> ";
pstmt_g.close();

out.print(html_array);




%>

	</td>
</tr>



<%}
else
{%>

<%if("3".equals(user_selection)){%>
<tr>
<th  class="td6" colspan=4 bgcolor="#CCCCFF" align=center>Add User for India
</th></tr>
<%}
else
{
if("4".equals(user_selection)){%>
<tr>
<th  class="td6" colspan=4 bgcolor="#CCCCFF" align=center>Add User for Overseas
</th></tr>
<%}

}%>
<tr>
	<td class="td4">User Name <font class="star1">*</font> 
	<td colspan=3><input type=text name=username size=20 value="<%=request.getParameter("username")%>">	
</tr>

<tr>
    <td class="td4">Password <font class="star1">*</font> 
    <td colspan=3>
	<input type=password name=password maxlength=10 value="<%=request.getParameter("password")%>">
</tr>	

<tr>
    <td class="td4">Retype Password <font class="star1">*</font> 
    <td colspan=3>
	<input type=password name=repassword maxlength=10 value="<%=request.getParameter("repassword")%>" >
</tr>	


<input type=hidden name=condition value="">
<input type=hidden name=time value="">


<tr>
	<td class="td4">For Whom</td>
	<td colspan=3>
	<select name="user_selection" onchange="change()">
		
		<option value="-1">Select</option>		
		<%if("3".equals(user_selection)){%>
			<option value="3" selected>India</option>
		<%}
		else
		{%>
			<option value="3">India</option>
		<%}%>
		
		<%if("4".equals(user_selection)){%>
		    <option value="4" selected>Overseas</option> 
		<%}
		else{%>
			<option value="4">Overseas</option> -->
		<%}%>
		</select>
	</td>
</tr>



<%
//out.print("<br> 267 user_selection="+user_selection);	
if("3".equals(user_selection)){%>
	
<tr><td class="td4" >Company <font class="star1">*</font></td>
<td colspan=3>
<%=AM.getMasterArray(conp,"Master_CompanyParty"," where active=1 and Category_Code=3","CompanyParty_Id","","CompanyParty_Name","CompanyParty_Id","CompanyParty_Name","","")%>



</td></tr>
<%}%>

<%if("4".equals(user_selection)){%>

<tr><td class="td4">Company <font class="star1">*</font></td>
<td colspan=3>
<%=AM.getMasterArray(conp,"Master_CompanyParty"," where	active=1 and Category_Code=4","CompanyParty_Id","","CompanyParty_Name","CompanyParty_Id","CompanyParty_Name","","")%>	
</td></tr>
<%}%>
<tr><td class="td4">User Level<font class="star1">*</font></td>
<td colspan=3>
<%=A.getPriviledgeLevelArray(cong,"priviledge_level","23") %></td> 
</tr>

<tr>
<td>Department</td> <td> <%=A.getMasterArraySrNo(cong,"Department","department_id","")%> </td>
</tr>

<%}%>
	<tr align=middle>
	<td colspan=4>
	<input type=submit  name=command  value=NEXT class=button1 onclick='return onSubmitValidate()' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
	</table>

	</form>


<%
	  db.returnConnection(conp);
	db.returnConnection(cong);
}//end default	

if("NEXT".equals(command))
{

int CompanyParty_Id=-1; //for global
user_selection=request.getParameter("user_selection");
if("3".equals(user_selection) ||"4".equals(user_selection) )
{
	CompanyParty_Id=Integer.parseInt(request.getParameter("CompanyParty_Id"));
}
//out.print("user_selection"+user_selection);
//out.print("CompanyParty_Id"+CompanyParty_Id);
//out.print("<br>578 Inside ADD ");
String username=request.getParameter("username");
//out.print("<br>username="+username);
String password=request.getParameter("password");
//out.print("<br>password="+password);
String repassword=request.getParameter("repassword");
//out.print("<br>repassword="+repassword);
String priviledge_level =request.getParameter("priviledge_level");
//out.print("<br>priviledge_level="+priviledge_level);
String department_id =request.getParameter("department_id");
//out.print("<br>department_id="+department_id);
errLine=326;

  
  int repeat=AM.get_repeat_id(conp,"Master_User","User_Name",username);
//out.print("<br>617");
  if(repeat != 0)
	 {
		//out.print("<br>620");
		db.returnConnection(conp);
		out.print("<body  class=bgimage>" );
		out.print("<center><font class='star1'>User \""+username+"\" alredy exists</font></center><br>" );
		out.print("<center><input type=button name=command value=Back class='Button1' onclick='history.go(-1)'></center>" );
		//out.print("<br>624");
		  db.returnConnection(conp);


  }
  else
  {
  errLine=345;
	//out.print("<br>633");
	int User_id=L.get_master_id(conp,"Master_User","User_Id");	
	//out.print("<br>635  User_id="+User_id);
	String Yearend_Id="-1";
	if("3".equals(user_selection) ||"4".equals(user_selection) )
	{	
		Yearend_Id=A.getNameCondition(conp, "YearEnd", "yearend_id", " Where Active=1 and company_id="+CompanyParty_Id);
	}
	//out.print("<br>637");
	String addUser="Insert into Master_User ( User_Id,User_Name,User_Password,  Modified_By,Modified_On,Modified_MachineName,Active, Company_Id ,Priviledge_Level, department_id, YearEnd_Id, Created_On)values(?,?,?,?,?,?,?,?,?,?,?,? )";

	pstmt_p=conp.prepareStatement(addUser);
	  
	pstmt_p.setString(1,""+User_id);
	//out.print("<br> User_id="+User_id);
	pstmt_p.setString(2,username);
	//out.print("<br> username="+username);
	pstmt_p.setString(3,password);
	//out.print("<br> password="+password);
	pstmt_p.setString(4,""+1); //Admin Entity
	pstmt_p.setString(5,""+D);
	//out.print("<br> run_date="+run_date);
	pstmt_p.setString(6,machine_name);
	//out.print("<br> machine_name="+machine_name);
	pstmt_p.setInt(7,1);
	pstmt_p.setString(8,""+CompanyParty_Id);
	//out.print("<br> CompanyParty_Id="+CompanyParty_Id);
	pstmt_p.setString(9,priviledge_level);
	//out.print("<br> priviledge_level="+priviledge_level);
	pstmt_p.setString(10,department_id);
	//out.print("<br> department_id="+department_id);
	pstmt_p.setString(11,Yearend_Id);
	//out.print("<br> Yearend_Id="+Yearend_Id);
	pstmt_p.setString(12,""+D);
	   
	int a=pstmt_p.executeUpdate();
	pstmt_p.close();
	//out.print("inserted successfully");
	 
	 
    conp.commit();
	db.returnConnection(conp);
	  
	response.sendRedirect("..\\Menu\\UserLevel.jsp?command=default&EntityID="+user_selection+"&UserID="+User_id);

}//end of else

}//end Submit


}catch(Exception e263){
	conp.rollback();
	db.returnConnection(conp);
	db.returnConnection(cong);
	out.print("<br>263 errLine"+errLine+" Error in addUser.jsp"+e263);}
%>