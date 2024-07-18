<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="A"   class="NipponBean.Array" />

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

%>
<HTML>
<HEAD>
<TITLE> Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
function validate(name)
	{
	if(name.value =="") { alert("Please Enter Properly"); name.focus();}
	}
</script>
</HEAD>
<!-- if(isNaN(name.value)) { alert("Please Enter No Properly"); name.focus();}
	if(name.value.charAt(0) == ".") { name.value="0"+name.value ; }
-->
	
<BODY bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" vlink="blue">

<%
String command   = request.getParameter("command");

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	/*try{
	conp=C.getConnection();
	}
	catch(Exception Samyak32){ 
	out.println("<font color=red> FileName : GL_Editmasters.jsp <br>Bug No Samyak32 :"+ Samyak32 +"</font>");}*/
	String query="";
String message = request.getParameter("message"); 
//String name   = request.getParameter("name"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}

try{
if("Currency".equals(command))
{
conp=C.getConnection();
query="select * from Lot  where company_id="+company_id+"";
pstmt_p  = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
int icount=0;
while(rs_g.next())
{icount++;}
pstmt_p.close();
if(icount >0)
	{
	query = "select *from Master_Currency where local_currency=0 and company_id="+company_id+"  order by Currency_Name";
	}
else{
		query = "select *from Master_Currency where company_id="+company_id+" order by Currency_Name";
}
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	int counter=0;
	while(rs_g.next())
	{counter++;}
	pstmt_p.close();
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	int c=0;
String currency_id[]=new String[counter]; 		
String currency_name[]=new String[counter];		
String currency_symbol[]=new String[counter];		
String base_exchangerate[]=new String[counter];	
String local_currency[]=new String[counter];	
String active[]=new String[counter];	
int item[]= new int[counter]; 

	while(rs_g.next())
	{
 currency_id[c]			=rs_g.getString("Currency_Id");
 currency_name[c]		=rs_g.getString("Currency_Name");
 currency_symbol[c]		=rs_g.getString("Currency_Symbol").trim();
base_exchangerate[c]	=rs_g.getString("Base_ExchangeRate");
 local_currency[c]	=rs_g.getString("local_currency");
// out.print("<br>local="+ local_currency[c]);
 active[c]	=rs_g.getString("Active");
 c++;
	}
	pstmt_p.close();

C.returnConnection(conp);

	%>
	<form action=UpdateCurrency.jsp method=post >
	<table align=center cellspacing=0 border=1 bordercolor=skyblue cellspacing=0>
	<tr bgcolor="skyblue"><th colspan=6>Edit Currency Master</th><tr>
	<tr><th> Sr No </th><th>Symbol<font class="star1"> *</font></th><th >Name<font class="star1"> *</font></th><th>Exchange Rate<br> per US $<font class="star1"> *</font></th> <th>Active</th>
<%if(icount>0)
	{}
	else{out.print("<th>Local Currency</th> ");}
	%>
	</tr>
	<%
int j=0;
for(int i=0; i<counter; i++)	
	{

%>
<tr align=center>

<input type=hidden name=currency_id<%=i %> value=<%=currency_id[i]%>  ><TD><%=++j%></td>
<td><input type=text name=currency_symbol<%=i %> value='<%=currency_symbol[i]%>' size=5  onBlur='validate(this)'></td>
<td><input type=text name=currency_name<%=i %> value="<%=currency_name[i]%>" size=15  onBlur='validate(this)'></td>
<td><input type=text name=base_exchangerate<%=i %> value="<%=str.format(base_exchangerate[i])%>" size=5  ></td>

<%
String str2="";
String str1="";
%>
<td>
<%if ("1".equals(active[i])){str2="checked";}%>

	<input type=checkbox name=active<%=i%> value="yes" <%=str2%> ></td>
<%
if(icount > 0)
	{  }
else{
%><td>
<%
if("1".equals(local_currency[i])){str1=" checked ";} %>
<input type=radio name=local value='<%=currency_id[i]%>'  <%=str1%> ></td>
<%}%>

</tr>
<%

}//for 
%>
<tr>
<td colspan=6 align=center>
<input type=hidden name=count value=<%=icount%> > 
<input type=hidden name=counter value=<%=counter%> > 
<input type=submit name=command value='Update Currency' class='Button1' >
</td>
</tr>
</table>
</form>	
<%

}//if Currency 
}catch(Exception Samyak418){ 
out.println("<font color=red> FileName : Editmasters.jsp <br>Bug No Samyak418 :"+ Samyak418 +"</font>");}

%>

</BODY>
</HTML>











