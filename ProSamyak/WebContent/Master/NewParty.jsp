<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%// System.out.println("Inside GL_New.jsp");%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<% 
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;
Connection conp = null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));
//out.print("<br>25 startDate"+startDate);
String command = request.getParameter("command");
//System.out.println("command is "+command);
String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
//System.out.println("companyparty id is "+companyparty_id);
try{
%>

<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<script>
function ValidLength(item,len)
	{
		return (item.length >= len);
	}
function ValidEmail(item)
	{
		if (!ValidLength(item, 5))
		return false;
		if (item.indexOf ('@', 0) == -1)
		return false;
		return true
	}

var errfound = false;
function Validate()
	{
	errfound = false;
	if(document.mainform.companyparty_name.value == "")
		{
		alert("Please enter Customer/Vendor Account's name.");
		document.mainform.companyparty_name.focus();
		return errfound;
		}
	else{
		var tempA=document.mainform.companyparty_name.value;
		if(tempA.length < 1)
			{
			alert("Please enter Customer/Vendor Account's name Properly. Must be more than one character");
			document.mainform.companyparty_name.focus();
			return errfound;
			}
		else
			{
			if(document.mainform.country.value == "")
				{
			alert("Please enter County's name.");
			document.mainform.country.focus();
			return errfound;
				}

			else
				{
			if(document.mainform.sale.checked || document.mainform.purchase.checked || document.mainform.pn.checked)
					{return !errfound;}
			else {
				 alert("Please Select One of the Customer/Vendor Account type (Sale / Purchase /PN) ");
				 return errfound;
				 }

			}
		}
	}
	}
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<script>
function setFoucs()
		{
		this.document.mainform.companyparty_name.focus();
		 }
</script>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onLoad='setFoucs()'>
<form action="UpdateParty.jsp" method=post name=mainform onsubmit="return Validate();">
<input type=hidden name=active value=yes>
<input type =hidden name= category_code value=0>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor="skyblue">
<th colspan=4 align=center>
Add New Customer/Vendor Account</th>
</tr>

<!--<tr><td>Sr No</td>
			<td colSpan=3><%=companyparty_id%>
		<input type=hidden name=sr_no size=6 value='<%=companyparty_id%>'></td>
</tr>-->

<tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=2><INPUT type=text name=companyparty_name size=30 ></td>

<td colspan=2>Opening Date
<script language='JavaScript'>
//if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Opening Date' style='font-size:11px ; width:90'>")}
</script>
<input type=hidden name='datevalue' size=8 maxlength=10 value="<%=startDate%>"
onblur='return  fnCheckMultiDate(this,"Date")' readonly>
<%=startDate%>
</td>
</tr>

<tr>
<td>Currency <font class="star1">*</font></td>
<td><input type=radio size=4 name=currency value=local checked>Local&nbsp;<input type=radio size=4 name=currency value=dollar>Dollar</td>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=4 name=exchange_rate value=
'<%=str.format(I.getLocalExchangeRate(conp,company_id))%>'  onBlur='validate(this)' style="text-align:right"></td>
</tr>

<tr>
<td>Sales</td>	 
<td colspan=1><input type=checkbox name=sale value=yes checked>
Opening Balance <input type=text size=4 name="opening_salesbalance" value=0 onBlur='validate(this)' style="text-align:right">
<Select name=sale_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
<td>Sales Party Group : </td>	
<td>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","salespartygroup_id",A.getNameCondition(conp,"Master_PartyGroup","partygroup_id","where PartyGroup_Name='Normal' and Group_Type=0 and company_id="+company_id),"where Active=1 and Group_Type=0",company_id)%></td>
</tr>

<tr>
<td>Purchase</td>	 
<td colspan=1><input type=checkbox name=purchase value=yes checked>
Opening Balance <input type=text size=4 name="opening_purchasebalance" value=0 onBlur='validate(this)' style="text-align:right">
<Select name=purchase_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit' selected>Cr</option>
</select></td>
<td>Purchase Party Group : </td>
<td>	<%=AC.getMasterArrayCondition(conp,"PartyGroup","purchasepartygroup_id",A.getNameCondition(conp,"Master_PartyGroup","partygroup_id","where PartyGroup_Name='Normal' and Group_Type=1 and company_id="+company_id),"where Active=1 and Group_Type=1",company_id)%></td>
</tr>

<tr>
<td><!-- PN --></td>	 
<td colspan=3>
	
<input type=hidden name=pn value=no>
<!-- Opening Balance --> <input type=hidden size=4 name="opening_pnbalance" value=0 onBlur='validate(this)' style="text-align:right">
<input type=hidden name=pn_creditdebit value='Credit'>
	</td>
</tr>
<tr>

<td>Sales Person</td>
<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id","","where company_id="+company_id+"and purchasesale=0")%></td>
<td>Interest rate (%) </td>	
<td><input type=text name=interest value="0" style="text-align:right" size=7 onblur="return validate(this,2)"></td>
</tr>
<tr>
	<td colspan=4><hr></td>
</tr>
<tr>
	<td align=center  colspan=4>Credit Limit Currency <font class="star1">*</font>
<input type=radio size=4 name=currency_limit value=local checked>Local&nbsp;<input type=radio size=4 name=currency_limit value=dollar>Dollar</td>
</tr>
<tr>
<td>Credit Limit</td><td>
<input type=text size=8 name="credit_limit" value=0 onBlur='validate(this)' style="text-align:right"></td>
<td>Credit Limit Per Day</td><td>
<input type=text size=8 name="credit_limit_per_day" value=0 onBlur='validate(this)' style="text-align:right"></td></tr>
<tr>
	<td colspan=4><hr></td>
</tr>
<tr>
<td><!-- Shikesho --><input type=hidden size=8 name="shikesho" value='no' >Due Days</td>
<td><input type=text name=duedays value="0" style="text-align:right" size=7 onblur="return validate(this,0)"></td>

<input type=hidden name="closing" value='13'>
<input type=hidden name="payment" value='1'>

</tr>
<!-- <tr><td>Payment Date</td> <td><%//=A.getMasterArrayCondition(conp,"ClosingPayment","payment","","Where payment=1 and Active=1 order by SR_NO")%></td></tr> -->

<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 size=50> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=1><INPUT  type=text name=address3 size=25 ></td> 
    <td>City</td> 
    <td><INPUT  type=text name=city></td> 
</tr>
<tr>
    <td>Pin</td> 
    <td><INPUT  type=text name=pin></td> 
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country value='India'></td>
</tr> 

<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name=income_taxno></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name=sales_taxno></td>
</tr>

<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi></td>
</tr>

<tr>
    <td>Fax</td> 
    <td><INPUT  type=text name=fax_no></td>
	<td>Mobile</td>
    <td><INPUT  type=text name=mobile></td>
</tr>	

<tr>
    <td>Email</td> 
    <td><INPUT  type=text name=email></td>
    <td>Website</td> 
    <td><INPUT  type=text name=website></td>
	
<tr>
    <td>Customer Sales Person </td> 
    <td><INPUT  type=text name=person1></td>
    <td>Contact Person </td>
    <td><INPUT type=text  name=person2> </td>
</tr>



<!-- <tr>
<td>Opening Balance(Receivable)</td>
<td><input type=text size=4 name="receivable_balance" value=0 onBlur='validate(this)'></td>
<td>Opening Balance(Payable)</td>
<td><input type=text size=4 name="payable_balance" value=0 onBlur='validate(this)'></td>
</tr>

 -->
<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='Save' class='Button1'> 
</td>
</tr>
</table>
</td>
</tr>
</TABLE>

</form>
</BODY>
</HTML>
<% 
	C.returnConnection(conp);	

	}catch(Exception e170){ 
	out.println("<font color=red> FileName : GL_NewParty.jsp <br>Bug No e170 :"+ e170 +"</font>");}
	%>








