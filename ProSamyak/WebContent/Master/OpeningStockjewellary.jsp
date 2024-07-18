<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//String company_name= A.getName("companyparty",company_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string=stoday_day+"/"+stoday_month+"/"+today_year;
// end of today_date in dd/mm/yyyy format

String command = request.getParameter("command");
String message=request.getParameter("message"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
//String lot_id=""+ L.get_master_id("Lot");
try{
%>
<html>
<head>
<title>Fine Star - Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<script language='javascript'>
var errfound = false;
function LocalValidate()
	{
	errfound = false;
	if(document.f1.lot_name.value == "")
		{
		alert("Please enter Lot name.");
		document.f1.lot_name.focus();
		return errfound;
		}
			else if(isNaN(document.f1.test_amt.value))
				{
				alert("Please enter Quantity & Rate Properly.");
				return false;
				}
			else
				{
				return !errfound;
				}
		
	}

function calcTotal(name)
{
validate(name)
//alert ("Ok Inside CalcTotal");

if((document.f1.test_amt.value=="0")||(document.f1.test_amt.value=="")){
document.f1.test_amt.value=document.f1.carats.value*document.f1.rate.value;
}
if(document.f1.rate.value=="0"){
	document.f1.rate.value=document.f1.test_amt.value  / document.f1.carats.value;}

if(document.f1.test_amt.value != ((document.f1.carats.value)*(document.f1.rate.value)))
{
if(document.f1.test_amt.value > ((document.f1.carats.value)*(document.f1.rate.value)))
{	document.f1.rate.value=document.f1.test_amt.value  / document.f1.carats.value;}

else{
document.f1.test_amt.value=document.f1.carats.value*document.f1.rate.value;}
}//if
}



</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="UpdateJewellary.jsp" method=post name=f1 onsubmit="return LocalValidate();">
<table borderColor=skyblue align=center border=0 cellspacing=0 cellpadding=2>

<tr><td colspan="6">
<table  border=1 cellspacing=0 cellpadding=2>
<tr bgcolor="#FFFFCC">
<th colspan=6 align=center>
Add New Opening Stock for Jewelry 
</th>  
</tr>

<tr>
<td>No <font class="star1">*</font></td>
<td colspan=3><input type=text name=lot_no size=15 value='1'></td>
<td colspan=2>Created On <input type=hidden name=datevalue value="31/03/2004"> 31/03/2004</td>
</tr>

<tr>
<td>Client No <font class="star1">*</font></td>
<td colspan=5><input type=text name=client_no size=15 value='1'></td>
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colspan=5> <INPUT type=text name=lot_name size=30> </td>
</tr>

<tr>
    <td>Description</font></td>
    <td colSpan=2> <INPUT type=text name=lot_description size=30> </td>
    <td>Location</font></td>
    <td colspan=2> <INPUT type=text name=lot_location size=20 value="Main"> </td>
</tr>
<tr>
<td colspan=1>Total Weight / Carat  </td>
<td><INPUT type=text name=total_weight size=8 onblur='validate(this)' style="text-align:right" value=0> </td>
<td colspan=1>Gross Weight </td>
<td><INPUT type=text name=gross_weight size=8 onblur='validate(this)' style="text-align:right" value=0> </td>
<td td colspan=1>Metal Weight</td>
<td> <INPUT type=text name=metal_weight size=8 onblur='validate(this)' style="text-align:right" value=0> </td>
</tr>

<tr>
<td>Selling Price</td>
<td colspan=1><input type=text name=selling_price size=8 onblur='validate(this)' style="text-align:right" value=0></td> 
<td >Tag Price</td>
<td colspan=1><input type=text name=tag_price size=8 onblur='validate(this)' style="text-align:right" value=0></td> 
</tr>
<tr>
<td>Gold</td>
<td>
<select name='gold_id' >
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
<td><input type=text name=gold_qty value="0" size=4 onblur='validate(this)' style="text-align:right">
</TD>
</TR>


<tr>
<td>Platinum</td>
<td>
<select name='platinum_id' >
<option value="1"> PT 850</option>
<option value="2"> PT 900</option>
<option value="3"> PT 950</option>
<option value='998' > Other</option>
<option value="999" Selected>NONE</option>
</select></td>
<td>Platinum Qty.</td>
<td><input type=text name=platinum_qty value="0" size=4 onblur='validate(this)' style="text-align:right">
</td>
</tr>
<tr><td colspan=6>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=3 align=center>Specifications</th>
</tr>

<tr>
<td>Item Type<br>
<select name='item_typeid' >
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
<td>Country Of Origin<br>
<select name='country_id' >
<option value='1' > India</option> 
<option value='2' > Thailand</option> 
<option value='3' > China</option> 
<option value='998' > Other</option>
<option value='999' Selected> NONE</option>
</select> 
</td>
<td>Treatement Code<br>
<select name='treatment_id' >
<option value='1' > A</option> 
<option value='2' > B</option> 
<option value='3' > C</option> 
<option value='4' > D</option>
<option value='5' > E</option>
<option value='998' > Other</option>
<option value='999' Selected> NONE</option>
</select> 
</td>
<td></td>
</tr>
</tr>

<tr>
<td>Diamonds<br>
<select name='shape_id' ><option value='1' > ROUND </option> <option value='2' > PEARS </option> <option value='3' > OVAL </option> <option value='4' > MARQUIS </option> <option value='5' > PRINCESS </option> <option value='6' > EMERLD </option> <option value='7' > SQ. EMERLD </option> <option value='8' > TRINGLE </option> <option value='9' > HEART SHAPE </option> <option value='10' > RADIENT </option> <option value='11' > SQ. RADIENT </option> <option value='12' > BUGGETS </option> <option value='13' > TAPPERS </option> <option value='14' > OTHER </option> <option value='999' selected  > NONE </option>  </select> 
</td>

<td>Color Stones<br>
<select name='colorstone_id' >
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
<td></td>
</tr>
</table>
</tr>

<tr>
<td colspan="6">
<table  border=1 cellspacing=0 cellpadding=0 width="100%">
<tr bgcolor="#FFFFCC">
<th colspan=6 align="center">Opening Stock Details </th>	
</tr>
<tr>
<td align="center">Currency</td><td align="center"><input type=radio name=currency value=local checked>Local <input type=radio name=currency value=dollar>Dollar
</td>
<td colspan=1 align="center">Exchange Rate/$<font class="star1">*</font></td>
<%
Connection cong = null;
try	{cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : LotMovement.jsp<br>Bug No e31 : "+ e31);}
%>
<td align="center"><input type=text name=exchange_rate
value='<%=str.format(I.getLocalExchangeRate(cong,company_id))%>' size=4 onblur='validate(this)' style="text-align:right">
</td>
<% C.returnConnection(cong); %>
</tr>
<tr>
<td align="center"><b>Pcs. </b><br><input type= text name=diamonds size=2 onblur='validate(this)' style="text-align:right"> </td>
<td align="center"><b>Quantiy (Carats)</b><br><input type= text name=carats size=5 OnBlur='return calcTotal(this)' style="text-align:right"> </td>
<td align="center"><b>Rate/Unit</b><br>
<input type=text name=rate value='0' size=7 style="text-align:right" > 
&nbsp;&nbsp;</td>
<td align="center"><b>Amount</b> <br><input type=text name=test_amt value=0  OnBlur='return  calcTotal(this)'  size=10 style="text-align:right" ></td>
</tr>
</table>
</td>
</tr>



<tr align=center>
<td colspan=6 align=center>
<input type=submit  name=command  value='Save' class="button1"> 
</td>
</tr> 
</table>
</td></tr>
</table>
</form>
</body>
</html>
<% 

	}catch(Exception Samyak359){ 
	out.println("<font color=red> FileName : NewJewellary.jsp <br>Bug No Samyak359 :"+ Samyak359 +"</font>");}
	%>








