<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="I"    class="NipponBean.Inventory" />

<%
//System.out.print(" Inside Account Edit");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");


	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
try
	{
		conp=C.getConnection(); 	
	}catch(Exception e14){ 
	out.print("<font color=red> FileName : EditPartyGroup.jsp <br>Bug No e14 :"+ e14 +"</font>");}

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
String base_exchangerate= I.getLocalExchangeRate(conp,company_id);

int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
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

	if(document.mainform.partygroup_name.value == "")
		{
		alert("Please enter PartyGroup's name.");
		document.mainform.partygroup_name.select();
		return errfound;
		}
	else 
		{
			var tempA=document.mainform.partygroup_name.value;
			if(tempA.length < 4)
				{
				alert("Please enter PartyGroup's name Properly. Must be more than three characters");
				document.mainform.partygroup_name.select();
				return errfound;
				}
			else
				{
				return !errfound;
				}
        }
	}//validate

</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<% 

if("Default".equals(command))
{
	
%>
	<form name=PartyGroupType  action=EditPartyGroup.jsp method=post>
<% 
	String message=request.getParameter("message"); 

	if("Default".equals(message))
	{}
	else
	{
		out.println("<center><font class='message1'> "+message+"</font></center>");
	}

	String view =request.getParameter("view"); 

%>
	<br>
	<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
	<tr><td>
	<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
	<tr bgcolor=skyblue><th colspan=4>Edit Party Group </th>
	</tr>
	<tr><td>Select Party Group Type</td>
	<td>
		<select name=partygroup_type>
			<option value='0'>Sales - Debitors</option>
			<option value='1'>Purchase - Creditors</option>
		</Select>
	</td>
	</tr>
	<tr>
		<td align=center colspan="2"><input type=submit value='Edit' name=command class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
	</td>
	</tr>
	<input type=hidden name=linkview value=<%=view%>>
</TABLE>
</td>
</tr>
</table>
</form>



<%
C.returnConnection(conp); 
}//end default






if("Edit".equals(command))
{
try
	{

	String partygroup_type=request.getParameter("partygroup_type");

	String linkview=request.getParameter("linkview");

	String Query = "";

	Query = "select * from Master_PartyGroup where  company_id= "+company_id+" and Group_Type="+partygroup_type+" order  by  PartyGroup_Name";

	pstmt_p  = conp.prepareStatement(Query);
	rs_g = pstmt_p.executeQuery();
	int counter =0;
	while(rs_g.next())
	{counter++;}
//	out.println(counter);
	pstmt_p.close();
	int m =0;
	String partygroup_id[]=new String[counter] ;
	String partygroup_name[]=new String[counter] ;
		
	pstmt_p  = conp.prepareStatement(Query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		partygroup_id[m]= rs_g.getString("PartyGroup_Id");
		partygroup_name[m]=rs_g.getString("PartyGroup_Name");
		m++;
		}
	pstmt_p.close();
%>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4 bgcolor="skyblue">Select Party Group Name for Edit</th>
</tr>

<tr>
<th>Sr No </th>
<th>Party Group Name </th>
</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>

<%
	if("yes".equals(linkview))
	{
%>
<td><%=partygroup_name[m]%></td>
<%
	}
	else
	{
%>
<td>
<a  href="EditPartyGroup.jsp?command=SelectedPartyGroupName&partygroup_id=<%=partygroup_id[m]%>"> 
<%=partygroup_name[m]%> </a>
</td>

<%
	}
%>

</tr>
<%
}// endof for m loop
		
C.returnConnection(conp);
}//try end

catch(Exception e233){ 
	out.print("<font color=red> FileName : EditPartyGroup.jsp <br>Bug No e233 :"+ e233 +"</font>");}
	}	//endif of edit.equals(command)	


if("SelectedPartyGroupName".equals(command))
	{
	try{
	int PartyGroupPrestenRows=0;
	String partygroup_id = request.getParameter("partygroup_id");
	String partygroup_name="";
	String partygroup_type="";
	String partygroup_code="";
	String tempCheck="";
	String active="";


	String EditQuery = "select * from Master_PartyGroup where PartyGroup_Id="+partygroup_id;
	//out.println(EditQuery);
	pstmt_p  = conp.prepareStatement(EditQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		partygroup_name=rs_g.getString("PartyGroup_Name");
		partygroup_type=rs_g.getString("Group_Type");
		partygroup_code=rs_g.getString("PartyGroup_Code");
		active=rs_g.getString("Active");
		if("1".equals(active))
		{tempCheck = " checked " ;}
			
		}
		pstmt_p.close();


	EditQuery = "select Count(*) as counter  from Ledger  where PartyGroup_Id="+partygroup_id;
	//out.println(EditQuery);
	pstmt_p  = conp.prepareStatement(EditQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		PartyGroupPrestenRows=rs_g.getInt("counter");
			}
		pstmt_p.close();
//out.print("<br> 256 PartyGroupPrestenRows"+PartyGroupPrestenRows);
%>
<form name=mainform  action="UpdatePartyGroup.jsp" method=post onsubmit="return Validate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="2">Update Party Group</th>
</tr>
<input type=hidden size=20 name="partygroup_id" value="<%=partygroup_id%>" >
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">

<tr>
	<td>Party Group Name <font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=40 name=partygroup_name value="<%=partygroup_name%>"></td>
</tr>
<tr>
	<td >Party Group Code<font class="star1"></font> </td>
	<td ><input type=text size=20 name=partygroup_code value="<%=partygroup_code%>"></td>
</tr>

<tr><td>Active</td> 
	<td>
<%
if(	PartyGroupPrestenRows < 1  )
		{
%>
<input type=checkbox name=active value=yes <%=tempCheck%>></td>
<% } else { %> Yes
<input type=hidden name=active value=yes ></td>
	<% }%>

</tr>
<tr>
	<td align=center colspan="2"><input type=submit value='UPDATE PARTY GROUP' name=command class='Button2' >
	</td>
</tr>
</table> 
</table> 
</form>

<%			
	C.returnConnection(conp);


	}// try end
catch(Exception e233){ 
	out.print("<font color=red> FileName : EditPartyGroup.jsp <br>Bug No e233 :"+ e233 +"</font>");}//catch end
	}// endif SelectedAccountName
	%>
</body>
</html>







