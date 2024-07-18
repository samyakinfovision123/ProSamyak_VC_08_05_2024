<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;
ResultSet rs_p= null;

Connection conp = null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date DS = Config.financialYearStart();
int dd=DS.getDate()-1;
//DS.setString(""+dd);
String today_string=format.format(D);

String command = request.getParameter("command");
String message=request.getParameter("message"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
String lot_id=""+ L.get_master_id(conp,"Lot");
try{
%>
<html>
<head>
<title>Samyak Software - India</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script language='javascript'>
var errfound = false;

//-------------------------------------
 function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter Name Properly "); 
name.focus();}
}// validate

//-------------------------------------




//-----------------------------------------------------------	
function calcTotal(name)
{
//validate(name)
//alert ("Ok Inside CalcTotal");
//-------------------------------------------
if(name.value =="") 
{ alert("Please Enter Field "); 
}
if(isNaN(name.value)) 
{ 
	alert("Please Enter Field Properly");
	name.select();
}

//---------------------------------------------
if((document.mainform.test_amt.value=="0")||(document.mainform.test_amt.value=="")){
document.mainform.test_amt.value=document.mainform.carats.value*document.mainform.rate.value;
//alert ("Ok Inside if");

}
if(document.mainform.rate.value=="0"){
	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

if(document.mainform.test_amt.value != ((document.mainform.carats.value)*(document.mainform.rate.value)))
{
if(document.mainform.test_amt.value > ((document.mainform.carats.value)*(document.mainform.rate.value)))
{	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

else{
document.mainform.test_amt.value=document.mainform.carats.value*document.mainform.rate.value;}
}//if
}
//------------------------------------------------------------
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='document.mainform.lot_no.select();'>
<form action="UpdateJewellary.jsp" method=post name=mainform>
<table borderColor=skyblue align=center border=0 cellspacing=0 cellpadding=2 width=100%>
<tr><td>
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2  borderColor=skyblue>

<tr bgcolor="skyblue">
<th colspan=6 align=center>
Add New Jewelry Lot
</th>  
</tr>

<tr>
<td>Lot No<font class="star1">*</font></td>
<td  colspan=2><input type=text name=lot_no size=15 value='1' onblur='nullvalidation(this)'></td> 

<td colspan=2 align=left>
<script language='javascript'>
//if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Created On' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script> 
	<input type=hidden name='datevalue' size=6 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date")'>
</td>
</tr>
<input type=hidden name=opdatevalue value="<%=format.format(DS)%>">	

<tr>
<!-- <td>Book No.</td>
<td><select name=Book_No>
<%/* for(int i=1;i<=25;i++)
	{*/%>
	<option value="<%//=i%>"><%//=i%></option> 
<%/*	}*/
%></select>
	</td> -->
<input type=hidden name="Book_No" value="999">
 <td>Client No <font class="star1">*</font></td>
 <td colSpan=3><input type=text name=client_no size=15 value='1'></td> 
</tr>
<!-- 
<tr>
 <td>Name <font class="star1">*</font></td>
 <td colSpan=3> <INPUT type=text name=lot_name onblur='nullvalidation(this)' size=30 value=''> </td> </tr>--> 


 <tr>
<td>Description</td>
<td colspan=3><input type=text name=Description></td>
</tr>
</tr>
<tr><td>Reference</td><td> <input type=text name=reference value=""> </td>
	 <td >Reorder Quantity</td> 
	 <td> <input type=text name=reorderquantity value='0' style="text-align:right" size=8>
	</td>
</tr>
<input type=hidden name="GroupCode_Id" value="999">
<input type=hidden name="Supplier_Id" value="999">
<!--	<td>Group Code</td>
	<td>
	<select name='GroupCode_Id' >
		<option value='1' > 13005 </option> 
		<option value='2' > 17005 </option>
		<option value='3' > 20005 </option> 
		<option value='4' > 21005 </option> 
		<option value='5' > 30005 </option> 
		<option value='6' > 30006 </option> 
		<option value='7' > 30007 </option>
		<option value='8' > 30008 </option> 
		<option value='9' > 30009 </option> 
		<option value='10' > 30010 </option>
		<option value='11' > 30011 </option>
		<option value='12' > 30012 </option>
		<option value='13' > 30013 </option>
		<option value='14' > 30014 </option> 
		<option value='15' > 30015 </option> 
		<option value='16' > 30016 </option> 
		<option value='17' > 30017 </option> 
		<option value='18' > 30018 </option> 
		<option value='19' > 30019 </option> 
		<option value='20' > 30020 </option> 
		<option value='21' > 30021 </option> 
		<option value='22' > 40005 </option> 
		<option value='23' > 50005 </option> 
		<option value='24' > 60005 </option> 
		<option value='25' > 70005 </option> 
		<option value='26' > 80005 </option> 
		<option value='27' > 90005 </option> 
	</select>  
</td>
	<td>Supplier</td>
	<td>
	<select name='Supplier_Id' >
			<option value='1' > Sanghavi </option> 
		<option value='2' > India </option> 
		<option value='3' > ASHER </option> 
		<option value='4' > Nanaka </option> 
		<option value='5' > HIBIC </option>
		<option value='6' > Local </option> 
		<option value='7' > Japan </option> 
		<option value='8' > Korea </option> 
		<option value='9' > TM-40 </option> 
		<option value='10' > Bangkong </option>
		<option value='11' > Core </option> 
		<option value='12' > BECO </option> 
		<option value='998' > OTHER </option> 
		<option value='999' > NONE </option>  
	</select> 
</td>
-->
 <tr>
	<td >Total Weight / Carat  </td>
	<td><INPUT type=text name=total_weight size=8 onblur='validate(this)' style="text-align:right" value='0'> </td>
 	<td >Gross Weight </td>
	<td colspan=3> <INPUT type=text name=gross_weight size=8 onblur='validate(this)' style="text-align:right" value='0'>  </td>
	
</tr>

<!-- </tr>
 -->
<!--  </td>
    <td>Location</td>
    <td > --> <INPUT type=hidden name=lot_location size=20 value="999"> <!-- </td>
</tr>-->


<tr>
	<td >Metal Weight</td>
	<td colSpan=5> <INPUT type=text name=metal_weight size=8 onblur='validate(this)' style="text-align:right" value=0> </td>
</tr>
<tr>
	<td>Selling Price</td>
	<td > <input type=text name=selling_price size=8 onblur='validate(this)' style="text-align:right" value=0></td> 
	<td >Tag Price</td>
	<td colspan=3> <input type=text name=tag_price size=8 onblur='validate(this)' style="text-align:right" 	value=0></td> 
</tr>


<tr><td>Gold</td>
		<td>

		<select name='gold_id' style="width:90;">
		<option value="1"> 14 Yellow</option>
		<option value="2"> 14 White</option>
		<option value="3"> 18 Yellow</option>
		<option value="4"> 18 White</option>
		<option value="5"> 14 TT</option>
		<option value="6"> 18 TT</option>
		<option value='998' > Other</option>
		<option value="999" selected> NONE</option>
		</select>
		</td>
<td>Gold Qty.</td>
<td colspan=3><input type=text name=gold_qty size=8 onblur='validate(this)' style="text-align:right" value="0">

</TD>
</TR>


<tr>
<td>Platinum</td>
<td>
<select name='platinum_id' style="width:90;"> 
<option value="1"> PT 850</option>
<option value="2"> PT 900</option>
<option value="3"> PT 950</option>
<option value='998' > Other</option>
<option value="999" Selected>NONE</option>
</select></td>
 <td>Platinum Qty.</td>
<td colspan=3><input type=text name=platinum_qty value="0" size=8 onblur='validate(this)' style="text-align:right">
</td>
</tr>

 <tr><td colspan=6>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue"><th colspan=3 align=center>Specifications</th></tr>

 <tr>


 <td >Country Of Origin<br>
<select name='country_id' style="width:125;">
<option value='1' > India</option> 
<option value='2' > Thailand</option> 
<option value='3' > China</option> 
<option value='998' > Other</option>
<option value='999' Selected> NONE</option>
</select> 
</td>
<td >Treatement Code<br>
<select name='treatment_id' style="width:125;">
<option value='1' > A</option> 
<option value='2' > B</option> 
<option value='3' > C</option> 
<option value='4' > D</option>
<option value='5' > E</option>
<option value='998' > Other</option>
<option value='999' Selected> NONE</option>
</select> 
</td> 
	 <td >Item Type<br>
<select name='item_typeid' style="width:125;">
<option value='1' > Ear Rings</option> 
<option value='2' > Nose Pin </option> 
<option value='3' > Necklace </option> 
<option value='4' > Chain </option> 
<option value='5' > Bangles</option> 
<option value='6' > Bracelet</option> 
<option value='7' > Tie Pin</option> 
<option value='8' > Sets</option>
<option value='9' > Pendantent</option>
<option value='10' > Ring Head</option>
<option value='11' >Cuff Links</option>
<option value='12' >Lady Ring</option>
<option value='13' >Mens Ring</option>
<option value='999' Selected >NONE</option>
</select> 
</td>

</tr>


 <td >Diamonds<br>
<select name='shape_id' style="width:125;"><option value='1' > ROUND </option> <option value='2' > PEARS </option> <option value='3' > OVAL </option> <option value='4' > MARQUIS </option> <option value='5' > PRINCESS </option> <option value='6' > EMERLD </option> <option value='7' > SQ. EMERLD </option> <option value='8' > TRINGLE </option> <option value='9' > HEART SHAPE </option> <option value='10' > RADIENT </option> <option value='11' > SQ. RADIENT </option> <option value='12' > BUGGETS </option> <option value='13' > TAPPERS </option> <option value='14' > OTHER </option> <option value='999' selected  > NONE </option>  </select> 
</td>

<td >Color Stones<br>
<select name='colorstone_id' style="width:125;">
<option value='1' > Ruby</option> 
<option value='2' > Sapphire</option> 
<option value='3' > Emerald</option> 
<option value='4' > Tanzanite </option> 
<option value='5' > Amgthest</option>
<option value='6' > Aquamarine</option>
<option value='7' > Cornellian</option>
<option value='8' > Garnet</option>
<option value='9' > Jolite</option>
<option value='10' > Pinktourmaline</option>
<option value='11' > Peridot</option>
<option value='12' > Rhodolite</option>
<option value='13' > Topaz</option>
<option value='14' >Turqoise</option>
<option value='15' > Pearl</option>
<option value='998' > Other</option>
<option value='999' Selected>NONE</option>
</select> 
</td>
<td >Number Of Stons<br><input type=text name="numberofstones" value="0" size=14 style="text-align:right"></td>
<!-- <tr>
 <td>Diamond Wt.</td>
 <td> --><input type=hidden name="Diamond_Weight" onblur='validate(this,3)' value='999'><!-- </td>
 <td>Color stone Wt.</td>
 <td> --><input type=hidden name="ColorStone_Weight" onblur='validate(this,3)' value='999'>
 <input type=hidden name="GoldMetaltype_Id" onblur='validate(this,3)' value='999'>
 <input type=hidden name="item_typeid" onblur='validate(this,3)' value='999'>
 <input type=hidden name="Price_Code" onblur='validate(this,3)' value='999'>

 <!-- </td> 
 </tr>
<tr>
	 <td>Gold Metal Type</td>
	 <td><select name='GoldMetaltype_Id' >
			 <option value='1' > 10 K </option> 
			 <option value='2' > 14 K </option>
			 <option value='3' > 18 K </option> 
			 <option value='4' > 22 K </option> 
			 <option value='5' > PT </option> 
			 <option value='6' > 18 KPK </option>
			 <option value='998' > OTHER </option> 
			 <option value='999' > NONE </option>  
		</select>
	 </td>
-->
<!-- 
<tr>
	<td>Price Code</td>
	<td colspan=3><input type=text name="Price_Code" value="None"></td>
</tr>
 -->
</table>
<%//-------------------------------------------------------------------
	int locCount=0;
	
	query="select count(Location_Id) as counter from Master_Location where company_id="+company_id+" and Active=1";
	pstmt_p=conp.prepareStatement(query);
	try{
	rs_p=pstmt_p.executeQuery();
	}catch(Exception e) { out.print(e); }
	while(rs_p.next())
	{
		locCount=Integer.parseInt(rs_p.getString("counter"));
	}
  pstmt_p.close();

	if(locCount==1)
	{

%>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
	<tr bgcolor="skyblue">
		<th colspan=6 align="center">Opening Stock Details <Input type=checkbox name=detail value=yes checked>Check Here
		</th>	
	</tr>

	<tr>
		<td colspan=2>Currency <input type=radio name=currency value=local checked>Local <input type=radio name=currency value=dollar>Dollar
		</td>
		<td colspan=2 align="left">Exchange Rate/$ <font class="star1">*</font>
	     <input type=text  name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>' size=4 align ="left" onblur='validate(this,2)' style="text-align:right">
	</td>
	<td>Location </td>
<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where company_id="+company_id+" and active=1 order by location_id")%><input type=hidden name=location_id value=<%=A.getNameCondition(conp,"Master_Location","Location_Id","where company_id="+company_id)%>></td>

</tr>
<input type= hidden name=diamonds value="0" size=2 onblur='validate(this,0)' style="text-align:right"> 
<tr>
<!-- <td>Pcs. <font class="star1">*</font><br><input type= text name=diamonds value="0" size=2 onblur='validate(this,0)' style="text-align:right"> </td>
 --><td>Quantiy (Carats)<font class="star1">*</font><br><input type= text name=carats size=5  style="text-align:right" OnBlur='validate(this,0)' value=0> </td>
<td colspan=3>Rate/Unit<br>
<input type=text name=rate value='1' size=7 style="text-align:right" > 
&nbsp;&nbsp;</td>
<td colspan=2>Amount <br><input type=text name=test_amt value="0"  size=10 style="text-align:right" OnBlur='return calcTotal(this)'></td>
</tr>


<%}

else
{%>
	<input type=hidden name=detail value="N0">
<%}

//------------------------------------------------------------%>
<tr>
	<td align=center colspan=6 ><input type=submit  name=command  value='ADD' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</tr>

</table>

</form>
</body>
</html>
<% 
  C.returnConnection(conp);
	}catch(Exception Samyak359){
	 C.returnConnection(conp);
	out.println("<font color=red> FileName : NewJewellary.jsp <br>Bug No Samyak359 :"+ Samyak359 +"</font>");}
	%>







