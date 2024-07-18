<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<% 
//out.print("Inside ");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

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
if(document.NewCategory.lotcategory_name.value == "")
			{
			alert("Please enter Category's name Properly.");
			document.NewCategory.lotcategory_name.focus();
			return errfound;
			}
		else{
		if(document.NewCategory.lotcategory_code.value == "")
			{
			alert("Please enter Code Properly.");
			document.NewCategory.lotcategory_code.focus();
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

<form name=NewCategory  action="UpdateCategory.jsp" method=post onsubmit="return Validate();">
<% 

String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
int srno=1;
String selectquery ="Select * from Master_LotCategory where company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,company_id);	
//out.print("<br>46"+selectquery);
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
{srno++;}
//out.print("nameexist"+nameexist);
pstmt_p.close();
C.returnConnection(conp);
if("Default".equals(message))
{}
else{out.println("<center><font class='message1'> "+message+"</font></center>");}%>

<br>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor=skyblue>
<th colspan=4>Add New Category </th>
</tr>

<tr>
<td>Sr No</td>
<td><input type=text name=sr_no size=6 value='<%=srno%>'>
<input type=hidden name=active value=yes ></td>
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3><input type=text name=lotcategory_name size=25 ></td>
</tr>

<tr>
<td>Code <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=lotcategory_code size=25 >
<input type=hidden name=sr_no size=6 value='1'>
</td>
</tr>

<tr>
<td>Description <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=lotcategory_description size=25 >
<input type=hidden name=sr_no size=6 value='1'>
</td>
</tr>

<tr>
<td colspan=4 align='center'>
<input type=submit name=command value='Add Category' class='Button1'>
</td>
</tr>

</table>
</td>
</tr>
</table>
</form>
</body>
</html>









