<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<!--Origanal Table By Vaibhav -->
<html>
<title> Edit Lot No</title>
<head>

	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<SCRIPT LANGUAGE="JavaScript" src="Scripting.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakcalendar.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakdate.js">
	</SCRIPT>
	<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
	<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
	</script>



</head>
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
conp=C.getConnection();

String company_name= A.getName(conp,"companyparty",company_id);
String servername=request.getServerName();
int lot_id=Integer.parseInt(request.getParameter("lot_id"));
//out.print("<br>lot_id in Int"+lot_id);
//String stringlot_id=""+lot_id;
//out.print("<br>lot_id in String"+stringlot_id);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


try	
{
String query="";

query="Select *  from  Diamond where Lot_Id="+lot_id;
//out.print(query);
		pstmt_p = conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();

String cut_id=""; 
String color_id=""; 
String purity_id=""; 
String fluorescence_id=""; 
String shape_id=""; 
String lab_id=""; 
String polish_id=""; 
String tableincusion_id=""; 
String symmetry_id=""; 
String luster_id=""; 
String lot_description=""; 
String lot_location=""; 
double total_depth=0;
double crown_angle=0;
double table_per= 0;
String size_id= "";
String country_id= "";
String shade_id= "";
String blackinclusion= "";
String openinclusion= "";
double weight= 0;
double purchase_price= 0;
double selling_price= 0;
String diameter="";
//String filename = "";
	
while(rs_g.next()) 	
	{

cut_id=rs_g.getString("cut_id");
//out.print(cut_id);
	
color_id=rs_g.getString("color_id");
purity_id=rs_g.getString("purity_id");
fluorescence_id= rs_g.getString("fluorescence_id");
shape_id=rs_g.getString("shape_id");
lab_id=rs_g.getString("lab_id");
polish_id=rs_g.getString("polish_id");
tableincusion_id= rs_g.getString("tableincusion_id");
symmetry_id=rs_g.getString("symmetry_id");
luster_id=rs_g.getString("luster_id");

country_id=rs_g.getString("country_id");

total_depth= rs_g.getDouble("Total_Depth");
crown_angle= rs_g.getDouble("Crown_Angle");
table_per= rs_g.getDouble("Table_Perecentage");
size_id= rs_g.getString("D_Size");
shade_id= rs_g.getString("Shade_Id");
blackinclusion= rs_g.getString("Blackinclusion_Id");
openinclusion= rs_g.getString("Openinclusion_Id");

selling_price= rs_g.getDouble("Selling_Price");
purchase_price= rs_g.getDouble("Purchase_Price");
weight= rs_g.getDouble("Weight");
diameter= rs_g.getString("Diameter");
if(rs_g.wasNull())
	diameter="0";
//filename = rs_g.getString("drwg_FileName")
	
}//end while

pstmt_p.close();

double reorderquantity=0;
String Lot_No="";
String Lot_Name="";
String Lot_Description="";
String Lot_Referance="";
String Lot_Location="";
//String Active=="";

%>
<%

String description="";

		query="Select * from Diamond where Lot_Id="+lot_id;
		
		pstmt_p = conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		
		//out.print("<br> Diameter="+diameter);
	}
%>
<%	query="Select *  from  Lot where Lot_Id="+lot_id;
	
	//out.print("<br> 182="+query);
	pstmt_p = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
	{
	reorderquantity= rs_g.getDouble("ReorderQuantity");
	//out.print("<br> reorderquantity="+reorderquantity);

	Lot_No= rs_g.getString("Lot_No");
	//out.print("<br> Lot_No="+Lot_No);


	Lot_Name= rs_g.getString("Lot_Name");
	//out.print("<br> Lot_Name="+Lot_Name);

	//Lot_Description= rs_g.getString("Lot_Description");
	//out.print("<br> Lot_Description="+Lot_Description);

	Lot_Referance= rs_g.getString("Lot_Referance");
	if(rs_g.wasNull())
		Lot_Referance="";
	//out.print("<br> Lot_Referance="+Lot_Referance);

	Lot_Location= rs_g.getString("Lot_Location");
	//out.print("<br> Lot_Location="+Lot_Location);


	}
pstmt_p.close();



%>
<!--Above Newwly added-->

<!--Below  Priganal Table-->


<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='document.mainform.lot_no.select();'>
<form action="UpdateLot.jsp" method=post name=mainform>
<table borderColor=skyblue align=center border=0 cellspacing=0 cellpadding=2  width="70%">
<tr><td>
<table  align=center border=1 WIDTH="70%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
	<th colspan=4 align=center>
	Edit Lot No.<%=Lot_No%></th>  
</tr>
	
	
<tr>
	<td>
		
		
		No<font value='' class="star1">*</font>
	</td>

	<td colSpan=3>
		<input type=text name=lot_no size=30 value='<%=Lot_No%>'>
		<input type=hidden name=templot_id size=30 value='<%=lot_id%>'>

		<script language='javascript'>
		//if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Created On' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
		</script> 
		<input type=hidden name='datevalue' size=6 maxlength=10 value="07/09/2005" onblur='return  fnCheckDate(this.value,"Date")'>	
		<input type=hidden name=datevalue1 value="31/03/2004">	
	</td>

</tr>
<!-- <tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=3> <INPUT type=text name=lot_name size=30> </td>
</tr> -->
<!-- <tr>
    <td>Company </td>
    <td colSpan=3>KTA SOLN</td>
</tr> -->
<tr>
	<td>Company</font></td>
    <td colSpan=3> <INPUT type=hidden name=company size=30> <%=company_name%></td>
</tr>
<tr>
	<td>Description</font></td>
    <td colSpan=3> <INPUT type=text name=lot_description size=30
	value=<%=Lot_Description%>> </td>
</tr>
<tr>
    <td>Lot_Reference</font></td>
    <td colSpan=3> <INPUT type=text name=lot_reference size=30
	value=<%=Lot_Referance%>> </td>
</tr>
	   <INPUT type=hidden name=lot_location size=30 value="Main"> 

<!-- <tr>
    <td>Location</font></td>
    <td colSpan=3> <INPUT type=text name=lot_location size=30 value="Main"> </td>
</tr>
 -->	

<tr>
	<td>Diameter</td><td><input type=text name=diameter value="<%=str.mathformat(diameter,3)%>" size=7 style="text-align:right" onblur='validate(this,3)' >
	</td>
</tr>

<tr><td colspan=4>
<table width='100%'>
<tr>
	<td>Total Depth<br><input type=text name=total_depth value='<%=str.mathformat(total_depth,2)%>' size=7 style="text-align:right" onblur='validate(this,3)' >
	</td>
	<td>Table Percentage<br><input type=text name=table_per value='<%=str.mathformat(table_per,2)%>' size=7 style="text-align:right" onblur='validate(this,3)'>
	</td>
	<td>Crown Angle<br> <input type=text name=crown_angle value='<%=str.mathformat(crown_angle,2)%>' size=7 style="text-align:right" onblur='validate(this,3)'> 
	</td>
	<td>Reorder Quantity <br><input type=text name=reorderquantity value='<%=str.mathformat(reorderquantity,3)%>' size=17 onblur='validate(this,3)'>
	</td>
</tr>
<tr>
<td>Purchase Price (US $)<br><input type=text name=purchase_price value='<%=str.mathformat(purchase_price,2)%>' size=7 style="text-align:right" onblur='validate(this,2)'></td>

<td>Selling Price (US $)<br><input type=text name=selling_price  value='<%=str.mathformat(selling_price,2)%>' size=7 style="text-align:right" onblur='validate(this,2)' ></td>

<td>Weight<br><input type=text name=weight value='<%=str.mathformat(weight,2)%>' size=7 style="text-align:right" onblur='validate(this,3)'></td>

<td>Size<br><%=A.getMasterArray(conp,"Size","size_id",size_id) %></td>
</tr>

</table>
</td>
</tr>

<tr><td colspan=2>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr><th colspan=6 align=center bgcolor=skyblue>Specifications</th></tr>

<tr>

	<td>Shape<br><%=A.getMasterArray(conp,"shape","shape_id",shape_id) %></td>
	
	<td>Color<br><%=A.getMasterArray(conp,"color","color_id",color_id) %></td> 
	

	<td>Purity (Clarity)<br><%=A.getMasterArray(conp,"purity","purity_id",purity_id) %>
	</td>

	<td>Cut<br><%=A.getMasterArray(conp,"cut","cut_id",cut_id)%>  
	</td>
</tr>
<tr>
	<td >Flourescene<br><%=A.getMasterArray(conp,"Fluorescence","fluorescence_id",fluorescence_id) %></td>

	


	<td>Lab<br><%=A.getMasterArray(conp,"Lab","lab_id",lab_id) %></td>

	<td>Polish<br><%=A.getMasterArray(conp,"polish","polish_id",polish_id)%></td>

	<td>Symmetry<br><%=A.getMasterArray(conp,"symmetry","symmetry_id",symmetry_id) %></td>


</tr>
<tr>
	<td >Table  Incusion<br><%=A.getMasterArray(conp,"TableIncusion","tableincusion_id",tableincusion_id) %>
	</td>


	<td>Luster<br><%=A.getMasterArray(conp,"luster","luster_id",luster_id) %>
	</td>

	<td >Country Of Origin<br>
	<%=A.getMasterArraySrNo(conp,"Country","country_id",country_id) %>
	</td>

	<td colspan=3>Shade<br><%=A.getMasterArray(conp,"Shade","shade_id",shade_id) %>
	</td>
</tr>
<tr>
	<td>Black Inclusion<br><%=A.getMasterArray(conp,"Blackinclusion","blackinclusion",blackinclusion) %>
	</td>
	
	<td colspan=5>Open Inclusion<br> <%=A.getMasterArray(conp,"Openinclusion","openinclusion",openinclusion) %> 
	</td>

	</tr>
<tr bgcolor=skyblue>
</tr>
<tr>
</tr>
</table>
<tr align=center>
<td colspan=4 align=center>
<input type=submit  name=command  value='Update' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</td>
</tr>
</table>
</td></tr>
</table>
</form>
</body>
</html>
<%
	C.returnConnection(conp);

}//end try
catch(Exception e31)
{ 
C.returnConnection(conp);
out.println("<font color=red> FileName : EditLot.jsp<br>Bug No e31 : "+ e31);
}
%>









