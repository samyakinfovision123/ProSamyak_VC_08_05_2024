<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
 
<html>
<head>
</head>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<SCRIPT LANGUAGE="JavaScript" src="Scripting.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakdate.js"></SCRIPT>

</head>

<% 
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
conp=C.getConnection();

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
String servername=request.getServerName();
int lot_id=Integer.parseInt(request.getParameter("lot_id"));
//out.print("<br>lot_id "+lot_id);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
try	
{

String query="";

query="Select *  from  Diamond where Lot_Id="+lot_id;
//out.print(query);
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
String reorderquantity="";
String Lot_No="";
String Lot_Name="";
String Lot_Description="";
String Lot_Referance="";
String Lot_Location="";
//String Active=="";


query="Select *  from  Lot where Lot_Id="+lot_id;


	//out.print(query);
	pstmt_p = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
	{
	reorderquantity= rs_g.getString("ReorderQuantity");
	//out.print("<br> reorderquantity="+reorderquantity);

	Lot_No= rs_g.getString("Lot_No");
	//out.print("<br> Lot_No="+Lot_No);

	Lot_Name= rs_g.getString("Lot_Name");
	//out.print("<br> Lot_Name="+Lot_Name);

	Lot_Description= rs_g.getString("Lot_Description");
	//out.print("<br> Lot_Description="+Lot_Description);

	Lot_Referance= rs_g.getString("Lot_Referance");
	//out.print("<br> Lot_Referance="+Lot_Referance);

	Lot_Location= rs_g.getString("Lot_Location");
	//out.print("<br> Lot_Location="+Lot_Location);


	}
pstmt_p.close();

%>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="UpdateEditItem.jsp" method=post name=NewLot >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=skyblue border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Edit Item
</th>  
</tr>
<tr><td>No:-</td><td><B><%=Lot_No%></B></td>
	<input type=hidden name=lot_no size=6 value='<%=Lot_No%>'>
	<input type=hidden name=lot_id size=6 value='<%=lot_id%>'>
	</td>
<tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=3> <INPUT type=text name=lot_name size=30 value='<%=Lot_Name%>'> </td>
</tr>
<tr>
    <td>Company </td>
    <td colSpan=3><%=company_name%></td>
</tr>
<tr>
    <td>Description</font></td>
    <td colSpan=3> <INPUT type=text name=lot_description size=30 value='<%=Lot_Description%>'> </td>
</tr>
	<INPUT type=hidden name=lot_location size=30 value="<%=Lot_Location%>"> 
<!-- <tr>
    <td>Location</font></td>
    <td colSpan=3> <INPUT type=text name=lot_location size=30 value="<%=Lot_Location%>"> </td>
</tr>
 --><tr>
    <td>Lot_Referance</font></td>
    <td colSpan=3> <INPUT type=text name=Lot_Referance size=30 value="<%=Lot_Referance%>"> </td>
</tr>

<tr>
    <td>ReorderQuantity</font></td>
    <td colSpan=3> <INPUT type=text name=reorderquantity size=7 value="<%=reorderquantity%>" onblur='validate(this,3)' style="text-align:left"> </td>
</tr>
<tr align=center ><td colspan=4> <input type=submit class='Button1' name=submit value=Update></td></tr>

</table>
</table>
</form>
</body>
</html>

<%
	C.returnConnection(conp);

}//end try
catch(Exception e31)
{ 
out.println("<font color=red> FileName : EditLot.jsp<br>Bug No e31 : "+ e31);
}

%>








