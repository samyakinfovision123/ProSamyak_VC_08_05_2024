<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
 
<%
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");


	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
		}
		catch(Exception Samyak13)
		{ 
		out.println("<font color=red> FileName : EditParty.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");
		}


String machine_name=request.getRemoteHost();
String command = request.getParameter("command");
//out.println(command);
String message = request.getParameter("message"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}


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
%>
<form action="EditGroup.jsp?command=SELECT&message=masters" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Group </th>
</tr>

<tr><td>Under</td>
<td>
<select name=category>
<option value='2'>Fixed Asset</option>
<option value='15'>Current Assets</option>
<option value='17'>Current Liabilities</option>
<option value='16'>Misc Expenditure</option>
<option value='18'>Reserves & Surplus</option>
<option value='5'>Investment</option>
<option value='7'>Loan(Liabilities) </option>
<option value='11'>Loan & Advances </option>
<option value='3'>Capital </option>
<!-- <option value='6' >Sundry Expenses</option>
 --></Select>
<input type=hidden name=active value=yes checked>
</td>
</tr>
<tr>
	<td colspan=2 align=center>
	<INPUT type=submit  name=command  value='SELECT' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
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
try{
	if("SELECT".equals(command))
	{
String category=request.getParameter("category");
//	out.println(category);
String query = "Select * from Master_SubGroup where Company_id=?  and For_HeadId=?";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,category); 
	rs_g = pstmt_p.executeQuery();	
	int n=0;
	while(rs_g.next())
		{n++;}
		pstmt_p.close();
//	out.println("<BR>"+n);
	int counter=n;
	String subgroup_id[]=new String[counter]; 
	String subgroup_name[]=new String[counter]; 
	String subgroup_code[]=new String[counter]; 
	String active[]=new String[counter]; 
	boolean ledgerpresent[]=new boolean[counter];
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,category); 
	rs_g = pstmt_p.executeQuery();	
	n=0;
	while(rs_g.next())
	{
	subgroup_id[n]=rs_g.getString("subgroup_id");	
	subgroup_name[n]=rs_g.getString("subgroup_name");	
	subgroup_code[n]=rs_g.getString("subgroup_code");	
	active[n]=rs_g.getString("active");	
	n++;
	}
	pstmt_p.close();

for(int i=0; i<counter; i++)
{
ledgerpresent[i]=false;
query = "Select * from Ledger where Company_id=?  and For_Head=? and Ledger_Type=? and Active=1";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,category); 
	pstmt_p.setString(3,subgroup_id[i]); 
	rs_g = pstmt_p.executeQuery();	
	while(rs_g.next())
	{ledgerpresent[i]=true;}
		pstmt_p.close();
}


String category_name= A.getNameCondition(conp,"Master_FinanceHeads","Head_Name","Where Head_id="+category+"" );
%>
<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action='UpdateGroup.jsp' method=post>
<table border=1  cellspacing=0 cellpadding=2 align=center>
<tr><th colspan=4> <%=category_name%></th></tr>
<tr bgcolor="skyblue">
	<th>Sr .No</th> <th>Name</th> <th>Description</th> <th>Active</th>
</tr>
<%
for(int i=0; i<counter; i++)
{
String str="";
if("1".equals(active[i]))
	{str="checked";}
	%>
<tr>
<input type=hidden name=subgroup_id<%=i%> value='<%=subgroup_id[i]%>'>
<td><%=i+1%></td>
<td><input type=text name=subgroup_name<%=i%> value='<%=subgroup_name[i]%>' size=15></td>
<td><input type=text name=subgroup_code<%=i%> value='<%=subgroup_code[i]%>' size=15></td>
<%if(ledgerpresent[i]){%>
<input type=hidden name=active<%=i%> value='yes'>
<%}else{%>
<td><input type=checkbox name=active<%=i%> value='yes' <%=str%>></td>
<%}%>
</tr>
<%}//for%>
<input type=hidden name=counter value='<%=counter%>'>
<input type=hidden name=category_name value='<%=category_name%>'>
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</td>
</tr>
</table></form>
<%

	 	C.returnConnection(conp);

}//if SELECT
}catch(Exception Samyak233){ 
out.println("<br><font color=red> FileName : EditParty.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");} 
%>
</BODY>
</HTML>








