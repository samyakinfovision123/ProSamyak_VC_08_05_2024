<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />

<%
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{conp=C.getConnection(); 	}catch(Exception e14){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e14 :"+ e14 +"</font>");}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
//String local_symbol= I.getLocalSymbol(company_id);
//String local_currency= I.getLocalCurrency(company_id);
//int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String command = request.getParameter("command");
//	out.print("<br>"+command);
%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
function Validate()
	{
	errfound = false;

	if(document.mainform.account_name.value == "")
		{
		alert("Please enter Account's name.");
		document.mainform.account_name.select();
		return errfound;
		}
	else 
		{
			var tempA=document.mainform.account_name.value;
			if(tempA.length < 4)
			{
			alert("Please enter Account's name Properly. Must be more than three characters");
			document.mainform.account_name.select();
			return errfound;
			}
		else
			{
			if(document.mainform.account_number.value == "")
				{
				alert("Please enter Account no.");
				document.mainform.account_number.select();
				return errfound;
				}
			else
				{
				return !errfound;
				}
			}

}
	}//validate

</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<% 

if("edit".equals(command))
{
try{
String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 

if("Default".equals(message))
{}
else{out.println("<center><font class='message1'> "+message+"</font><br></center>");}
String UnitQuery = "select * from Master_Unit where  company_id="+company_id+" order by  Unit_Name";
pstmt_p  = conp.prepareStatement(UnitQuery);
rs_g = pstmt_p.executeQuery();
	int counter =0;
	while(rs_g.next())
	{counter++;}
//	out.println(counter);
	pstmt_p.close();
	int m =0;
	String unit_id[]=new String[counter] ;
	String unit_name[]=new String[counter] ;
	String unit_code[]=new String[counter] ;
	pstmt_p  = conp.prepareStatement(UnitQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		unit_id[m]= rs_g.getString("unit_Id");
		unit_name[m]=rs_g.getString("unit_Name");
		unit_code[m]=rs_g.getString("unit_Code");
//out.println("1:"+account_id[m]+" 2:"+account_name[m]+" 3:"+account_number[m]);
		m++;
		}
	pstmt_p.close();
%>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4 bgcolor="skyblue">Click On Unit Code to Edit</th>
</tr>

<tr>
<th>Sr No </th>
<th>Unit Name </th>
<th>Unit Code </th>
</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>
<td><%=unit_name[m]%></td>
<td>
<a href="EditUnit.jsp?command=Next&unit_id=<%=unit_id[m]%>&message=Default"> 
<%=unit_code[m]%> 
</a>
</td>
</tr>
<%
}// endof for m loop

	C.returnConnection(conp);
}//try end

catch(Exception e233){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e233 :"+ e233 +"</font>");}
}	//endif of edit.equals(command)	




if("Next".equals(command))
	{
	try{
	String unit_id = request.getParameter("unit_id");
//	out.println(unit_id);
	String unit_name="";
	String unit_code="";
	String unit_description="";

	String active="";
	String sr_no="";
	String tempCheck="";

	String EditQuery = "select * from Master_Unit where unit_id="+unit_id;
	//out.println(EditQuery);
	pstmt_p  = conp.prepareStatement(EditQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		unit_name=rs_g.getString("unit_name");
		//out.print("<br>unit_name:"+unit_name);
		unit_code=rs_g.getString("unit_code");
		//out.print("<br>unit_code:"+unit_code);
		unit_description=rs_g.getString("unit_description");
		//out.print("<br>unit_description:"+unit_description);
		sr_no=rs_g.getString("sr_no");
		active=rs_g.getString("Active");
		//out.print("<br>sr_no:"+sr_no);
		if("1".equals(active))
		{tempCheck = " checked " ;}
		}
//System.out.println("activeyes:"+tempCheck);
%>
<HTML>
<HEAD>
<TITLE>Samyak Software, India </TITLE>

<script>
var errfound = false;
function Validate()
{
errfound = false;
if(document.NewUnit.unit_name.value == "")
			{
			alert("Please enter Unit's name Properly.");
			document.NewUnit.unit_name.focus();
			return errfound;
			}
		else{
		if(document.NewUnit.unit_code.value == "")
			{
			alert("Please enter Code Properly.");
			document.NewUnit.unit_code.focus();
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

<form name=NewUnit  action="UpdateUnit.jsp" method=post onsubmit="return Validate();">
<% 

String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 

if("Default".equals(message))
{}
else{out.println("<center><font class='message1'> "+message+"</font></center>");}%>
<br>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor=skyblue>
<th colspan=4>Edit Unit of Measurment</th>
</tr>

<tr>
<td>Sr No</td>
<td><input type=hidden name=unit_id value='<%=unit_id%>'>
	<input type=text name=sr_no size=6 value='<%=sr_no%>'>
</td>
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3><input type=text name=unit_name size=25 value=<%=unit_name%>></td>
</tr>

<tr>
<td>Code <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=unit_code size=25 value='<%=unit_code%>'>
</td>
</tr>

<tr>
<td>Description <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=unit_description size=25 value='<%=unit_description%>'>
</td>
</tr>

<tr>
<td>Active</td> 
<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>
</tr>
<tr>
	<td align=center colspan="2"><input type=submit value='Update Unit' name=command class='Button2'>
	</td>
</tr>

</table>
</td>
</tr>
</table>
</form>
</body>
</html>



<%
	
C.returnConnection(conp);
}// try end
	
	catch(Exception e233){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e233 :"+ e233 +"</font>");}//catch end
	}// endif SelectedAccountName
	%>









