<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*"%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<% 
//out.print("Inside ");
System.out.print("Inside ");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
System.out.print("company_id"+company_id);
String MASTER = request.getParameter("MASTER");
String flag="aaa";
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : Cash.jsp<br>Bug No e31 : "+ e31);}

String query="";


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
String command=request.getParameter("command");
//out.print("command"+command);
System.out.print("command"+command);
//String categoy_id= ""+L.get_master_id("Master_ItemCategory");

%>

<HTML>
<HEAD>
<TITLE>Samyak Software- India </TITLE>

<script>
var errfound = false;
function Validate()
{
errfound = false;
if(document.NewMASTER.MASTER_name.value == "")
			{
			alert("Please enter Master name Properly.");
			document.NewMASTER.MASTER_name.focus();
			return errfound;
			}
		else{
		if(document.NewMASTER.MASTER_code.value == "")
			{
			alert("Please enter Code Properly.");
			document.NewMASTER.MASTER_code.focus();
			return errfound;
			}
		else
			{
			return !errfound;
			}
	}
	}
</SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body background="../Buttons/BGCOLOR.JPG">

<form name=NewMASTER  action="UpdateMaster.jsp" method=post onsubmit="return Validate();">
<!-- onsubmit="return Validate();" -->
<% 

String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
int srno=1;
String selectquery ="Select * from Master_"+MASTER +" "; 

pstmt_p = conp.prepareStatement(selectquery);
//pstmt_p.setString (1,company_id);	
//out.print("<br>46"+selectquery);
System.out.print("company_id"+company_id);
System.out.print("<br>46"+selectquery);
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
{srno++;}
//out.print("nameexist"+nameexist);
System.out.print("nameexist");
pstmt_p.close();
C.returnConnection(conp);
System.out.print(" After Connection close");
if("Default".equals(message))
{}
else{out.println("<center><font class='message1'> "+message+"</font></center>");}%>

<br>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor=skyblue>
<th colspan=4>Add New  <%=MASTER %> </th>
</tr>

<tr>
<td>Sr No</td>
<td><input type=text name=sr_no size=6 value='<%=srno%>'>
<input type=hidden name=active value=yes ></td>
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3><input type=text name=MASTER_name size=25 ></td>
</tr>



<tr>
<td>Description <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=MASTER_description size=25 >
<input type=hidden name=sr_no size=6 value='1'>
</td>
</tr>

<input type=hidden name=MASTER value=<%=MASTER%>>
<tr>
<td colspan=2 align='center'>

<!--  <input type=submit name=command value='Edit' class='Button1'> -->
		<a href="../Master/UpdateMaster.jsp?newcommand=Edit&MASTER=<%=MASTER%>">Edit</a></td>

 <td colspan=2><input type=submit name=command value='Add MASTER' class='Button1'>
</td>
 
</tr>

</table>
</td>
</tr>
</table>
</form>
</body>
</html>









