<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />


<html>
<head>
</head>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<SCRIPT LANGUAGE="JavaScript" src="Scripting.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakcalendar.js"></SCRIPT>

	<SCRIPT language=javascript src="..\Samyak\Samyakdate.js"></SCRIPT>

</head>

<% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String servername=request.getServerName();
int lot_id=Integer.parseInt(request.getParameter("lot_id"));
String Lot_No=request.getParameter("Lot_No");
//out.print("<br>lot_id "+lot_id);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try	
{
	conp=C.getConnection();

String company_name= A.getName(conp,"companyparty",company_id);

String reorderquantity="";
//String Lot_No="";
String Lot_Name="";
String Lot_Description="";
String Lot_Referance="";
String Lot_Location="";
//String Active=="";
String query="";

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

//----------------------------------------------------------------------

/*
String query="";

query="Select *  from  Jewelry where Lot_Id="+lot_id;
//out.print(query);
		pstmt_p = conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();
*/


String client_no="";
double total_weight=0;
double gross_weight=0;
double metal_weight=0;
String item_typeid="";
String country_id="";
String shape_id=""; 
String treatment_id="";
String colorstone_id="";
String gold_id="";
String platinum_id="";

String Book_No="";
String GroupCode_Id="";
String Supplier_Id="";
double Diamond_Weight=0;
double ColorStone_Weight=0;
String GoldMetaltype_Id="";
String Price_Code="";

double gold_qty=0;
double platinum_qty=0;
double selling_price=0;
double tag_price=0;
double number_of_stones=0;

query="Select *  from  Jewelry where Lot_Id="+lot_id;

//out.print(query);

pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
	{
client_no=rs_g.getString("client_no");
//out.print("<BR>client_no=  "+client_no);

total_weight=rs_g.getDouble("total_weight");
//out.print("<BR>total_weight=  "+total_weight);

gross_weight=rs_g.getDouble("gross_weight");
//out.print("<BR>gross_weight=  "+gross_weight);

metal_weight=rs_g.getDouble("metal_weight");
//out.print("<BR>metal_weight=  "+metal_weight);

item_typeid=rs_g.getString("item_typeid");
//out.print("<BR>item_typeid=  "+item_typeid);

country_id=rs_g.getString("country_id");
//out.print("<BR>country_id=  "+country_id);

treatment_id=rs_g.getString("treatment_id");
//out.print("<BR>treatment_id=  "+treatment_id);

shape_id=rs_g.getString("Shape_Id");
//out.print("<BR>shape_id=  "+shape_id);

colorstone_id=rs_g.getString("color_stoneid");
//out.print("<BR>colorstone_id=  "+colorstone_id);

gold_id=rs_g.getString("gold_id");
//out.print("<BR>gold_id=  "+gold_id);

platinum_id=rs_g.getString("platinum_id");
//out.print("<BR>platinum_id=  "+platinum_id);

gold_qty=rs_g.getDouble("gold_qty");
//out.print("<BR>platinum_id=  "+platinum_id);

platinum_qty=rs_g.getDouble("platinum_qty");
//out.print("<BR>platinum_qty=  "+platinum_qty);

selling_price=rs_g.getDouble("selling_price");
//out.print("<BR>selling_price=  "+selling_price);

tag_price=rs_g.getDouble("tag_price");
//out.print("<BR>tag_price=  "+tag_price);

number_of_stones=rs_g.getDouble("number_of_stones");
//out.print("<BR>number_of_stones=  "+number_of_stones);

Book_No=rs_g.getString("Book_No");
//out.print("<BR>Book_No=  "+Book_No);

GroupCode_Id=rs_g.getString("GroupCode_Id");
//out.print("<BR>GroupCode_Id=  "+GroupCode_Id);

Supplier_Id=rs_g.getString("Supplier_Id");
//out.print("<BR>Supplier_Id=  "+Supplier_Id);

Diamond_Weight=rs_g.getDouble("Diamond_Weight");
//out.print("<BR>Diamond_Weight=  "+Diamond_Weight);

ColorStone_Weight=rs_g.getDouble("ColorStone_Weight");
//out.print("<BR>ColorStone_Weight=  "+ColorStone_Weight);

GoldMetaltype_Id=rs_g.getString("GoldMetaltype_Id");
//out.print("<BR>GoldMetaltype_Id=  "+GoldMetaltype_Id);

Price_Code=rs_g.getString("Price_Code");
//out.print("<BR>Price_Code=  "+Price_Code);

}
pstmt_p.close();


%>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="UpdateEditJewelry.jsp" method=post name=NewLot>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=skyblue border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Edit Jewelry
</th>  
</tr>
<tr><td>Lot No:-</td><td><B><%=Lot_No%></B></td>
	<input type=hidden name=lot_no size=6 value='<%=Lot_No%>'>
	<input type=hidden name=lot_id size=6 value='<%=lot_id%>'>
	</td>
</tr>
 <tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=3> <INPUT type=text name=lot_name size=30 value='<%=Lot_Name%>'> </td>
</tr>

<!-- <tr>
    <td>Company </td>
    <td colSpan=3><%//=A.getMasterArray(conp,"CompanyParty","Company_id",company_id)%></td>
</tr> -->
<INPUT type=hidden name=Company_id size=30 value='<%=company_id%>'>

<tr>
    <td>Description</font></td>
    <td colSpan=3> <INPUT type=text name=lot_description size=30 value='<%=Lot_Description%>'> </td>
</tr>
<!-- <INPUT type=hidden name=lot_description size=30 value='<%=Lot_Description%>'>
 -->
<!-- <tr>
    <td>Location</font></td>
    <td colSpan=3> <INPUT type=text name=lot_location size=30 value="<%=Lot_Location%>"> </td>
</tr>
 -->
  <INPUT type=hidden name=lot_location size=30 value="<%=Lot_Location%>">

 <tr>
    <td>Lot_Referance</font></td>
    <td colSpan=3> <INPUT type=text name=Lot_Referance size=30 value="<%=Lot_Referance%>"> </td>
</tr>


 <tr>
    <td>ReorderQuantity</font></td>
    <td colSpan=3> <INPUT type=text name=reorderquantity size=30 value="<%=reorderquantity%>"> </td>
</tr>

<!--  <INPUT type=hidden name=reorderquantity size=30 value="<%=reorderquantity%>">
 --></table>
<%//-------------------------------------------------------%>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>

 <tr><td>client_no</td>
	<td><INPUT type=text name=client_no size=8 onblur='validate(this)' style="text-align:right" value='<%=client_no%>'> </td>


 <td colspan=1>Metal Weight</td>
<td> <INPUT type=text name=metal_weight size=8 onblur='validate(this)' style="text-align:right" value='<%=str.mathformat(metal_weight,2)%>'> </td>

 </tr>
<tr><td>Total Weight</td>
<td><INPUT type=text name=total_weight size=8 onblur='validate(this)' style="text-align:right" value='<%=str.mathformat(total_weight,2)%>'> </td>

 <td colspan=1>Gross Weight </td>
<td><INPUT type=text name=gross_weight size=8 onblur='validate(this)' style="text-align:right" value='<%=str.mathformat(gross_weight,2)%>'> </td>
</tr>

<tr>
<td>Selling Price</td>
<td colspan=1><input type=text name=selling_price size=8 onblur='validate(this)' style="text-align:right" value='<%=str.mathformat(selling_price,2)%>'></td> 

<td >Tag Price</td>
<td colspan=1><input type=text name=tag_price size=8 onblur='validate(this)' style="text-align:right" value='<%=str.mathformat(tag_price,2)%>'></td> 
</tr>

<tr>
<td>Gold</td>
<td><%=A.getMasterArray(conp,"Gold","gold_id",""+gold_id)%>
</td>
<td>Gold Qty.</td>
<td><input type=text name=gold_qty 
value='<%=str.mathformat(gold_qty,3)%>' size=4 onblur='validate(this)' style="text-align:right">
</TD>
</TR>


<tr>
<td>Platinum</td>
<td><%=A.getMasterArray(conp,"Platinum","platinum_id",platinum_id)%></td>
<td>Platinum Qty.</td>
<td><input type=text name=platinum_qty value='<%=str.format(""+platinum_qty,3)%>' size=4 onblur='validate(this)' style="text-align:right">
</td>
</tr>

<tr><td colspan=6>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr><th colspan=3 align=center>Specifications</th></tr>
<tr>

<td >Country Of Origin<br>
<%=A.getMasterArray(conp,"Country","country_id",country_id)%>
</td>


<td >Treatement Code<br>
<%=A.getMasterArray(conp,"Treatment","treatment_id",treatment_id)%>
</td>
</tr>

<tr>
<td >Diamonds<br>
<%=A.getMasterArray(conp,"Shape","shape_id",shape_id)%>
</td>

<td >Color Stones<br>
<%=A.getMasterArray(conp,"ColorStone","colorstone_id",colorstone_id)%>
</td>
<td > Number Of Stones<input type=text name=number_of_stones value='<%=number_of_stones%>' size=4 onblur='validate(this)' style="text-align:right"></td>
</tr>

<!-- <tr>
	<td>Book No.</td>
	<td><select name=Book_No>
	<%/*for(int i=0;i<=25;i++)
	{ String selected="";
		if(i==Integer.parseInt(Book_No))
		{
			selected="selected";
		}*/%>
		<option value=<%//=i%> <%//=selected%>><%//=i%></option>
<%/*	}*/%></select></td>
	    <td>Description</font></td>
    <td colSpan=3> <INPUT type=text name=lot_description size=30 value='<%//=Lot_Description%>'> </td>

</tr>
<tr>
<td>Group Code</td>	<td><%=A.getMasterArrayCondition(conp,"GroupCode","GroupCode_Id",GroupCode_Id,"")%></td>
	<td>Supplier</td>
	<td><%=A.getMasterArrayCondition(conp,"Supplier","Supplier_Id",Supplier_Id,"")%></td>
</tr>
<tr>
	<td>Diamond Wt.</td>
	<td><input type=text name="Diamond_Weight" value="<%=str.mathformat(Diamond_Weight,3)%>" onblur='validate(this,3)'> </td>
	<td>Color Stone Wt.</td>
	<td><input type=text name="ColorStone_Weight" value="<%=str.mathformat(ColorStone_Weight,3)%>" onblur='validate(this,3)'></td>

</tr>
<tr>
	<td>Gold Metal Type</td>
	<td><%=A.getMasterArrayCondition(conp,"GoldMetaltype","GoldMetaltype_Id",GoldMetaltype_Id,"")%></td>
	<td >Jewel Type</td>
	<td><%=A.getMasterArray(conp,"ItemType","Itemtype_id",item_typeid)%></td>
</tr>
<tr>
	<td>Price Code</td>
	<td><input type=text name="Price_Code" value="<%=Price_Code%>"></td>
	<td>Reorder Quantity</td>
	 <td><input type=text name="reorderquantity" value="<%=str.format(""+reorderquantity,3)%>" style="text-align:right"></td>

</tr> -->
</table>
</td>
</tr>

<tr align=center>
<td colspan=6 align=center>
<input type=submit  name=command  value='Update' class='button1'> 
</td>
</tr>
	
</table>

<%
C.returnConnection(conp);
}//end try
catch(Exception e31)
{ 
out.println("<font color=red> FileName : EditLot.jsp<br>Bug No e31 : "+ e31);
}
%>








