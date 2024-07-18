<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<%
	
	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");


	Connection conp = null;
	Connection cong = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;
	ResultSet rs_p = null;
	

try
{
		conp=C.getConnection(); 	
		cong=C.getConnection(); 	
}
catch(Exception e14)
{ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e14 :"+ e14 +"</font>");
}

String company_name= A.getName(conp,"companyparty",company_id);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String command = request.getParameter("command");
//out.print("<br>"+command);

%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
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

</script><SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<% 
String LocationQuery="";
if("edit".equals(command))
{
	try
		{
			 String
				 view=request.getParameter("view"); 
			 String message=request.getParameter("message"); 
			
			if("yes".equals(view))
			{
					LocationQuery = "select * from Master_Location where Active=1 and  company_id="+company_id+" order by  Location_Name";

			}
			else
			{
				LocationQuery = "select * from Master_Location where company_id="+company_id+" order by  Location_Name";
			}
		
			pstmt_p  = conp.prepareStatement(LocationQuery);
			rs_g = pstmt_p.executeQuery();
			int counter =0;
			while(rs_g.next())
			{
				counter++;
			}

		pstmt_p.close();
		int m =0;
		String location_id[]=new String[counter] ;
		String location_name[]=new String[counter] ;
		String location_code[]=new String[counter] ;
		pstmt_p  = conp.prepareStatement(LocationQuery);
		rs_g = pstmt_p.executeQuery();
	
		while(rs_g.next())
		{
			location_id[m]= rs_g.getString("location_Id");
			location_name[m]=rs_g.getString("location_Name");
			location_code[m]=rs_g.getString("location_Code");
		m++;
		}
		pstmt_p.close();
 %>

 <table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4 bgcolor="skyblue">Click On Location Code to Edit</th>
</tr>

<tr>
<th>Sr No </th>
<th>Location Name </th>
<th>Location Code </th>
</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>
<td><%=location_name[m]%></td>

<%
	if("yes".equals(view))
	{
%>
<td><%=location_code[m]%> </td>
<%
	}
	else
	{
%>
<td>
<a href="EditLocation.jsp?command=Next&location_id=
<%=location_id[m]%>&message=Default"> 
<%=location_code[m]%> 
</a>
</td>
<%
	}
%>

</tr>
<%
	}// endof for m loop
	C.returnConnection(conp);
		C.returnConnection(cong);
}//try end
catch(Exception e233)
{ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e233 :"+ e233 +"</font>");
}
}	//endif of edit.equals(command)	




if("Next".equals(command))
{
	try
	{
		String location_id = request.getParameter("location_id");
		//String msg1 = request.getParameter("message");
	//	out.print("location_id"+location_id);
		String location_name="";
		String location_code="";
		String location_description="";
		String active="";
		String sr_no="";
		String tempCheck="";

		String EditQuery = "select * from Master_Location where location_id="+location_id;
		
		pstmt_p  = conp.prepareStatement(EditQuery);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{
			location_name=rs_g.getString("location_name");
			location_code=rs_g.getString("location_code");
			location_description=rs_g.getString("location_description");
			sr_no=rs_g.getString("sr_no");
			active=rs_g.getString("Active");

			if("1".equals(active))		
			{
				tempCheck = " checked " ;
			}
		}
		pstmt_p.close();

		String ActiveQuery = "select count(*)as counter from receive_transaction where Active=1 and location_id="+location_id;

		pstmt_g = cong.prepareStatement(ActiveQuery);
		rs_p= pstmt_g.executeQuery();
		int count=0;
		while(rs_p.next())
		{
			count=rs_p.getInt("counter");
		}
		pstmt_g.close();
		//out.print(" 234 count="+count);

%>

<HTML>
<HEAD>
<TITLE>Samyak Software, India </TITLE>

<script>
var errfound = false;
function Validate()
{
errfound = false;
if(document.NewLocation.location_name.value == "")
			{
			alert("Please enter Location's name Properly.");
			document.NewLocation.location_name.focus();
			return errfound;
			}
		else{
		if(document.NewLocation.location_code.value == "")
			{
			alert("Please enter Code Properly.");
			document.NewLocation.location_code.focus();
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

<form name=NewLocation  action="UpdateLocation.jsp" method=post onsubmit="return Validate();">
<% 

String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
%>
<br>
<%
	if(null==message)
		{}
	else
		{
%>
<center>
<FONT SIZE="5.9" COLOR="RED"><%=message%></FONT>
</center>
<%
		}
%>
<BR>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor=skyblue>
<th colspan=4>Edit Location </th>
</tr>

<tr>
<td>Sr No</td>
<td><input type=hidden name=location_id value='<%=location_id%>'>
	<input type=text name=sr_no size=6 value='<%=sr_no%>'>
</td>
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3><input type=text name=location_name size=25 value='<%=location_name%>'></td>
</tr>

<tr>
<td>Code <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=location_code size=25 value='<%=location_code%>'>
</td>
</tr>

<tr>
<td>Description <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=location_description size=25 value='<%=location_description%>'>
</td>
</tr>

<tr>
<%
	if(count==0)
		{
%>
<td>Active</td> 
<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>
<%
	}
	else
	{
%>
<td></td> 
<td><input type=hidden name=active value=yes <%=tempCheck%>></td>

<%}%>
</tr>
<tr>
	<td align=center colspan="2"><input type=submit  value='SAVE' name=command class='Button1'>
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
		C.returnConnection(cong);

	}// try end
	
	catch(Exception e233){ 
		C.returnConnection(conp);
		C.returnConnection(cong);
	out.print("<font color=red> FileName : EditLocation.jsp <br>Bug No e233 :"+ e233 +"</font>");}//catch end
	}// endif SelectedAccountName
	%>








