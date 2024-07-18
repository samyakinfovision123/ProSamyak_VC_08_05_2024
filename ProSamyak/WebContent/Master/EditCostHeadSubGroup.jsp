<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
 
<%
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();

String command = request.getParameter("command");
//out.println(command);

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
		}catch(Exception Samyak13){ 
	out.println("<font color=red> FileName : EditParty.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");}
	%>

<% 
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<% 

	if("edit".equals(command))
	{

String message = request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}

%>
<form action="EditCostHeadSubGroup.jsp" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Cost Head </th>
</tr>

<tr><td>Under</td>
<td>
<%
String condition="Where active=1 and company_id="+company_id+" order by CostHeadGroup_Name";

%>

<%=A.getMasterArrayCondition(conp,"CostHeadGroup","CostHeadGroup_id","",condition) %>
</td>
</tr>
<tr>
	<td colspan=2 align=center>
	<INPUT type=submit  name=command  value='Next' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
	</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
</html>
</body>
<%
	C.returnConnection(conp);
}
%>

<%
//out.print("76 command"+command);
try{

	if("Next".equals(command))
	{
 
	String CostHeadGroup_id=request.getParameter("CostHeadGroup_id");
	//out.println("<br>85 CostHeadGroup_id"+CostHeadGroup_id);
String query = "Select * from Master_CostHeadSubGroup where Company_id=?  and CostHeadGroup_id=?";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,CostHeadGroup_id); 
	rs_g = pstmt_p.executeQuery();	
	int n=0;
	while(rs_g.next())
		{n++;}
		pstmt_p.close();
//	out.println("<BR>"+n);
	int counter=n;
	String costheadsubgroup_id[]=new String[counter]; 
	String costheadsubgroup_name[]=new String[counter]; 
	String costheadsubgroup_code[]=new String[counter]; 
	String costheadsubgroup_description[]=new String[counter]; 
	String sr_no[]=new String[counter]; 
	String active[]=new String[counter]; 
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,CostHeadGroup_id); 
	rs_g = pstmt_p.executeQuery();	
	n=0;
	while(rs_g.next())
	{
costheadsubgroup_id[n]=rs_g.getString("costheadsubgroup_id");	
costheadsubgroup_name[n]=rs_g.getString("costheadsubgroup_name");	
costheadsubgroup_code[n]=rs_g.getString("costheadsubgroup_code");	
costheadsubgroup_description[n]=rs_g.getString("costheadsubgroup_description");	
sr_no[n]=rs_g.getString("sr_no");	
active[n]=rs_g.getString("active");	
n++;
	}
	pstmt_p.close();
 
%>
<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action='UpdateCostHeadSubGroup.jsp' method=post>
<input type=hidden name=CostHeadGroup_id value='<%=CostHeadGroup_id%>'>
<table border=1  cellspacing=0 cellpadding=2 align=center>
<tr><th colspan=5>Edit Cost Head Sub Group</th></tr>
<tr bgcolor="skyblue">
	<th>Sr .No</th> 
	<th>Name</th>
	<th>Code</th>
	<th>Description</th> 
	<th>Active</th>
</tr>
<%
for(int i=0; i<counter; i++)
{
String str="";
if("1".equals(active[i]))
	{str="checked";}
	%>
<tr>

<td><input type=text name=sr_no<%=i%> value='<%=sr_no[i]%>' size=4>
<input type=hidden name=costheadsubgroup_id<%=i%> value='<%=costheadsubgroup_id[i]%>'>
</td>
<td><input type=text name=costheadsubgroup_name<%=i%> value='<%=costheadsubgroup_name[i]%>' size=15></td>
<td><input type=text name=costheadsubgroup_code<%=i%> value='<%=costheadsubgroup_code[i]%>' size=15></td>
<td><input type=text name=costheadsubgroup_description<%=i%> value='<%=costheadsubgroup_description[i]%>' size=15></td>
<td><input type=checkbox name=active<%=i%> value='yes' <%=str%>></td>
</tr>
<%}//for%>
<tr align=center>
<td colspan=5>
<input type=hidden name=counter value='<%=counter%>'>
<input type=hidden name=CostHeadGroup_id value='<%=CostHeadGroup_id%>'>
<input type=submit  name=command  value='Update' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</td>
</tr>
</table>
</form>
<%
C.returnConnection(conp);

}//if SELECT

}catch(Exception Samyak233){ 
out.println("<br><font color=red> FileName : EditParty.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");} 
%>
</BODY>
</HTML>








