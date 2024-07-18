<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<%
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
		}catch(Exception Samyak13){ 
	out.println("<font color=red> FileName : EditParty.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");
	}
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
String temp_window_close="no";
String command = request.getParameter("command");
//out.println(command);
String windowClose=request.getParameter("windowClose");
if("yes".equals(windowClose))
{	temp_window_close="yes";}
String message = request.getParameter("message"); 
String edited_id="";
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");
edited_id=request.getParameter("edited_id");
}
	%>

<% 
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
%>

<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script>
function LocalValidate()
	{
	var errfound = false;
	if(document.mainform.companyparty_name.value == "")
		{
		alert("Please enter Customer/Vendor Account's name.");
		document.mainform.companyparty_name.focus();
		return errfound;
		}
else{
		var tempA=document.mainform.companyparty_name.value;
		if(tempA.length < 3)
			{
			alert("Please enter Customer/Vendor Account's name Properly. Must be more than two characters");
			document.mainform.companyparty_name.focus();
			return errfound;
			}
		else
			{
			if(document.mainform.country.value == "")
				{
			alert("Please enter Customer/Vendor Account's name.");
			document.mainform.country.focus();
			return errfound;
				}
			else
				{
				return !errfound;
				}
			}
		}
	}

</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<!--  Company selection form -->

<% 

	if("edit".equals(command))
	{
%>
<form action="EditParty.jsp?command=PartySelected&message=masters" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Customer/Vendor Account Name </th>
</tr>

<tr>
	<td align=center>Customer/Vendor Account</td>
	<td><%=A.getMasterArrayConditionActive(conp,"CompanyParty","CompanyParty_Id",edited_id,"where company=0 ",company_id) %>
	</td>
</tr>
<tr>
	<td colspan=2 align=center>
	<INPUT type=submit  name=command  value='SELECT' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
	</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<%
	C.returnConnection(conp);

}
%>

<%
try{
	
	if("PartySelected".equals(command))
	{
			
	String companyparty_id=request.getParameter("CompanyParty_Id");
	//out.println(companyparty_id);
	String salespartygroup_id = A.getNameCondition(conp, "Ledger", "PartyGroup_Id","where For_Head=14 and Ledger_Type=1 and For_HeadId="+companyparty_id);
    
	String interest = A.getNameCondition(conp, "Ledger", "Interest","where For_Head=14 and Ledger_Type=1 and For_HeadId="+companyparty_id);
	
	String purchasepartygroup_id = A.getNameCondition(conp, "Ledger", "PartyGroup_Id","where For_Head=14 and Ledger_Type=2 and For_HeadId="+companyparty_id);
	
	String query = "select * from Receive where Receive_FromId=?";
		pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, companyparty_id);
	rs_g = pstmt_p.executeQuery();
	int rec_count=0;
	while(rs_g.next())
		{rec_count++; }
	pstmt_p.close();
	 query = "select * from Master_CompanyParty where CompanyParty_Id=?";
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, companyparty_id);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
		{
String companyparty_name =rs_g.getString("CompanyParty_Name");
if (rs_g.wasNull())
			{companyparty_name="";}
//out.println("<br>1:"+companyparty_name);
String category_code	=rs_g.getString("category_code");
if (rs_g.wasNull())
			{category_code="0";}

//out.println("<br>2:"+category_code);
String address1		=rs_g.getString("address1");
if (rs_g.wasNull())
			{address1="";}

//out.println("<br>3:"+address1);
String address2     =rs_g.getString("address2");
if (rs_g.wasNull())
			{address2="";}

//out.println("<br>4:"+address2);
String address3		=rs_g.getString("address3");
if (rs_g.wasNull())
			{address3="";}

//out.println("<br>5:"+address2);
String city			=rs_g.getString("city");	
if (rs_g.wasNull())
			{city="";}

//out.println("<br>6:"+city);
String pin			=rs_g.getString("pin");
if (rs_g.wasNull())
			{pin="";}
//out.println("<br>7:"+pin);
String country		=rs_g.getString("country");
if (rs_g.wasNull())
			{country="";}

//out.println("<br>8:"+country);
String income_taxno		=rs_g.getString("income_taxno");
if (rs_g.wasNull())
			{income_taxno="";}

//out.println("<br>9:"+income_taxno);
String sales_taxno		=rs_g.getString("sales_taxno");
if (rs_g.wasNull())
			{sales_taxno="";}

//out.println("<br>9:"+phone_off);

String phone_off		=rs_g.getString("phone_off");
if (rs_g.wasNull())
			{phone_off="";}

//out.println("<br>9:"+phone_off);
String phone_resi			=rs_g.getString("phone_resi");
if (rs_g.wasNull())
{phone_resi="";}

//out.println("<br>10:"+phone_resi);
String mobile		=rs_g.getString("mobile");
//out.println("<br>11 ccc:"+mobile);
if (rs_g.wasNull())
			{mobile="";}
//out.println("<br>11 ccc:"+mobile);
//out.println("<br>11:"+mobile);
String email		=rs_g.getString("email");	
if (rs_g.wasNull())
			{email="";}

//out.println("<br>12:"+email);
String website		=rs_g.getString("website");
if (rs_g.wasNull())
			{website="";}

//out.println("<br>13:"+website);
String person1			=rs_g.getString("person1");
if (rs_g.wasNull())
			{person1="";}

//out.println("<br>14:"+person1);
String person2			=rs_g.getString("person2");
if (rs_g.wasNull())
			{person2="";}

//out.println("<br>15:"+person2);

String fax_no			=rs_g.getString("fax");	
//out.println("<br>16:"+fax_no);
if (rs_g.wasNull())
			{fax_no="";}

String transaction_currency=""+rs_g.getString("Transaction_Currency");
String creditlimit_currency=""+rs_g.getString("CreditLimit_Currency");
String exchange_rate=""+rs_g.getString("RExchange_Rate");
double sale_balance=0;
double purchase_balance=0;
double pn_balance=0;

double advsale_locbalance=0;
double advpurchase_locbalance=0;
double advpn_locbalance=0;
double advsale_dolbalance=0;
double advpurchase_dolbalance=0;
double advpn_dolbalance=0;


double oldsale_locbalance = rs_g.getDouble("Opening_RLocalBalance");
double oldpurchase_locbalance= rs_g.getDouble("Opening_PLocalBalance");
double oldpn_locbalance= rs_g.getDouble("Opening_PNLocalBalance");

double oldsale_dolbalance= rs_g.getDouble("Opening_RDollarBalance");
double oldpurchase_dolbalance= rs_g.getDouble("Opening_PDollarBalance");
double oldpn_dolbalance = rs_g.getDouble("Opening_PNDollarBalance");

String local_checked="";
String local_checked1="";
String dollar_checked="";
String dollar_checked1="";
if("1".equals(creditlimit_currency))
{
	local_checked1="checked";
}
else
{
	dollar_checked1="checked";
}

if("1".equals(transaction_currency))
{
local_checked="checked";
sale_balance=oldsale_locbalance;
purchase_balance=oldpurchase_locbalance;
pn_balance=oldpn_locbalance;
d=d;
}
else
{
dollar_checked="checked";
sale_balance=oldsale_dolbalance;
purchase_balance=oldpurchase_dolbalance;
pn_balance=oldpn_dolbalance;
d=2;
}
advsale_locbalance= rs_g.getDouble("Sale_AdvanceLocal");
advpurchase_locbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advpn_locbalance= rs_g.getDouble("PN_AdvanceLocal");

advsale_dolbalance= rs_g.getDouble("Sale_AdvanceDollar");
advpurchase_dolbalance= rs_g.getDouble("Purchase_AdvanceDollar");
advpn_dolbalance= rs_g.getDouble("PN_AdvanceDollar");


//out.println("<br>16:"+fax_no);
//out.println("<br>16:"+fax_no);
String active		=rs_g.getString("active");
String sale_active		=rs_g.getString("Sale");
String purchase_active		=rs_g.getString("Purchase");
String pn_active		=rs_g.getString("PN");
//out.println("<br>17:"+active);
String sr_no		=rs_g.getString("sr_no");
if (rs_g.wasNull())
			{sr_no="";}

//out.println("<br>18:"+sr_no);
String Company		=rs_g.getString("Company");
if (rs_g.wasNull())
			{Company="";}

String closing		=rs_g.getString("Closing_Date");
if (rs_g.wasNull())
			{closing="";}
String payment		=rs_g.getString("Payment_Date");
if (rs_g.wasNull())
			{payment="";}
String credit_limit		=rs_g.getString("credit_limit");
if (rs_g.wasNull())
			{credit_limit="";}
String credit_limit_per_day		=rs_g.getString("PerDay_CreditLimit");
if (rs_g.wasNull())
			{credit_limit_per_day="";}
String shikesho_active		=rs_g.getString("Shikesho");

String salesperson_id=rs_g.getString("SalesPerson_Id");
String duedays="";

duedays=rs_g.getString("Due_Days");

	if (rs_g.wasNull())
			{duedays="0";}



java.sql.Date opening_date = new java.sql.Date(System.currentTimeMillis());

opening_date=rs_g.getDate("Opening_Date");
String today_string= format.format(opening_date);


//out.println("<br>19:"+Company);
String activeyes="";
if("1".equals(active)){activeyes = " checked " ;}
String sale_flag ="";
if("1".equals(sale_active)){sale_flag = " checked " ;}
String purchase_flag ="";
if("1".equals(purchase_active)){purchase_flag = " checked " ;}
String pn_flag ="";
if("1".equals(pn_active)){pn_flag = " checked " ;}
String shikesho_flag ="";
if("1".equals(shikesho_active)){shikesho_flag = " checked " ;}
%>

<form action='UpdateParty.jsp' method=post name="mainform" onsubmit="return LocalValidate();">
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor="skyblue">
<th colspan=4 align=center>
Update Customer/Vendor Account</th>
</tr>
<input type=hidden value='<%=companyparty_id%>' name=companyparty_id > 
<input type =hidden name= category_code value=<%=category_code%>>
<input type=hidden value='<%=advsale_locbalance%>' name=advsale_locbalance > 
<input type=hidden value='<%=advpurchase_locbalance%>' name=advpurchase_locbalance> 
<input type=hidden value='<%=advpn_locbalance%>' name=advpn_locbalance> 
<input type=hidden value='<%=advsale_dolbalance%>' name=advsale_dolbalance> 
<input type=hidden value='<%=advpurchase_dolbalance%>' name=advpurchase_dolbalance> 
<input type=hidden value='<%=advpn_dolbalance%>' name=advpn_dolbalance> 

<input type=hidden value='<%=oldsale_locbalance%>' name=oldsale_locbalance> 
<input type=hidden value='<%=oldpurchase_locbalance%>' name=oldpurchase_locbalance> 
<input type=hidden value='<%=oldpn_locbalance%>' name=oldpn_locbalance> 

<input type=hidden value='<%=oldsale_dolbalance%>' name=oldsale_dolbalance> 
<input type=hidden value='<%=oldpurchase_dolbalance%>' name=oldpurchase_dolbalance> 
<input type=hidden value='<%=oldpn_dolbalance%>' name=oldpn_dolbalance> 
<input type=hidden value='<%=temp_window_close%>' name=temp_window_close> 






<tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=2><INPUT type=text name=companyparty_name size=30 value="<%=companyparty_name%>"></td>

<td colspan=2> 
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Opening Date' style='font-size:11px ; width:90' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>
<input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date")'>

</td>
</tr>

<tr>
  <td>Currency <font class="star1">*</font></td>
  <%if(rec_count>0)
{
if("checked".equals(local_checked))
{%>
<td><input type=hidden size=4 name=currency value=local> <b>Local</b></td>
<%} 
 else  
{%>
 <td><input type=hidden size=4 name=currency value=dollar  ><b>Dollar</b></td>
<%}} %>

 <%if(rec_count==0)
	 { %>
	 <td><input type=radio size=4 name=currency value=local    <%=local_checked%> > Local&nbsp;
		<input type=radio size=4 name=currency value=dollar <%=dollar_checked%>>Dollar</td>
	 <%}%>
</tr>

<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=4 name=exchange_rate value ='<%=str.format(""+exchange_rate,2)%>' onBlur='validate(this)' style="text-align:right"></td>
</tr>

<tr>
<td>Sales</td>	 
<td colspan=1><input type=checkbox name=sale value=yes <%=sale_flag%>>
Opening Balance
<% 
if(sale_balance >= 0) {
%>
<input type=text size=8 name="opening_salesbalance" value="<%=str.mathformat(""+sale_balance,d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=sale_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
<% } else { %>
<input type=text size=8 name="opening_salesbalance" value="<%=str.mathformat(""+(-(sale_balance)),d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=sale_creditdebit>
<option value='Debit'>Cr</option>
<option value='Credit'>Dr</option>
</select>
<% } %>
</td>
<td>Sales Party Group</td>
<td>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","salespartygroup_id",salespartygroup_id,"where Active=1 and Group_Type=0",company_id)%>
</td>
</tr>

</tr>

<tr>
<td>Purchase</td>	 
<td colspan=1><input type=checkbox name=purchase value=yes  <%=purchase_flag%>>

Opening Balance
<% 
if(purchase_balance >= 0) {
%>
<input type=text size=8 name="opening_purchasebalance" value="<%=str.mathformat(""+purchase_balance,d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=purchase_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
<% } else { %>
<input type=text size=8 name="opening_purchasebalance" value="<%=str.mathformat(""+(-(purchase_balance)),d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=purchase_creditdebit>
<option value='Debit'>Cr</option>
<option value='Credit'>Dr</option>
</select>
<% } %>
</td>
<td>Purchase Party Group</td>
<td>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","purchasepartygroup_id",purchasepartygroup_id,"where Active=1 and Group_Type=1",company_id)%>
</td>
</tr>

<tr>
<td>PN</td>	 
<td colspan=3><input type=checkbox name=pn value=yes  <%=pn_flag%>>
Opening Balance
<% 
if(pn_balance >= 0) {
%>
<input type=text size=8 name="opening_pnbalance" value="<%=str.mathformat(""+pn_balance,d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=pn_creditdebit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
<% } else { %>
<input type=text size=8 name="opening_pnbalance" value="<%=str.mathformat(""+(-(pn_balance)),d)%>" onBlur='validate(this)' style="text-align:right">
<Select name=pn_creditdebit>
<option value='Debit'>Cr</option>
<option value='Credit'>Dr</option>
</select>
<% } %>

</td>
</tr>
<tr>
<td>Sales Person</td>
<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where company_id="+company_id+"and purchasesale=0")%></td>
</tr>
<tr>
	<td colspan=4><hr></td>
</tr>
<tr>
  <td align=center colspan=4>Credit Limit Currency <font class="star1">*</font> 
 
	 <input type=radio size=4 name=currency_limit value=local   
	<%=local_checked1%> > Local&nbsp;
		<input type=radio size=4 name=currency_limit value=dollar
	<%=dollar_checked1%>>Dollar
	
</td>
</tr>
<tr>

<td>Credit Limit</td><td colspan=1>
<input type=text size=8 name="credit_limit" value='<%=str.mathformat(""+credit_limit,d)%>' onBlur='validate(this)' style="text-align:right"></td>

<td>Credit Limit Per Day</td><td colspan=1>
<input type=text size=8 name="credit_limit_per_day" value='<%=str.mathformat(""+credit_limit_per_day,d)%>' onBlur='validate(this)' style="text-align:right"></td>
</tr>
<tr>
	<td colspan=4><hr></td>
</tr>
<tr>
<td>Shikesho</td><td colspan=1>
<input type=checkbox size=8 name="shikesho" value='yes' <%=shikesho_flag%>></td>

<td>Due Days</td>
<td><input type=text name=duedays value="<%=duedays%>" size="7" style="text-align:right" onblur="return validate(this,0)"></td>

</tr>

<tr><td>Closing Date</td> <td><%=A.getMasterArrayCondition(conp,"ClosingPayment","closing",closing,"Where payment=0 order by SR_NO")%></td>
<td>Interest Rate (%)</td>
<td><input type=text name=interest value="<%=str.format(interest,2)%>" size="7" style="text-align:right" onblur="return validate(this,2)"></td>
	
</tr>
<tr><td>Payment Date</td> <td><%=A.getMasterArrayCondition(conp,"ClosingPayment","payment",payment,"Where payment=1 and active=1 order by SR_NO")%></td></tr>


<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 value='<%=address1%>' size=50> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 value='<%=address2%>' size=50 ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=1><INPUT  type=text name=address3 value='<%=address3%>' size=25 ></td> 
    <td>City</td> 
    <td><INPUT  type=text name=city value='<%=city%>'></td> 
</tr>
<tr>
    <td>Pin</td> 
    <td><INPUT  type=text name=pin value='<%=pin%>'></td> 
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country value='<%=country%>'></td>
</tr> 

<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name=income_taxno value='<%=income_taxno%>'></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name=sales_taxno value='<%=sales_taxno%>'></td>
</tr>

<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off value='<%=phone_off%>'></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi value='<%=phone_resi%>'></td>
</tr>

<tr>
    <td>Fax</td> 
    <td><INPUT  type=text name=fax_no value='<%=fax_no%>'></td>
	<td>Mobile</td>
    <td><INPUT  type=text name=mobile value='<%=mobile%>'></td>
</tr>	

<tr>
    <td>Email</td> 
    <td><INPUT  type=text name=email value='<%=email%>'></td>
    <td>Website</td> 
    <td><INPUT  type=text name=website value='<%=website%>'></td>
	
<tr>
    <td>Customer Sales Person </td> 
    <td><INPUT  type=text name=person1 value='<%=person1%>'></td>
    <td>Contact Person </td>
    <td><INPUT type=text  name=person2 value='<%=person2%>'> </td>
</tr>
<tr><td>Active</td> 
	<td>
<%if(rec_count>0)
{
out.print("<input type=hidden name=active value=yes >");
//out.print("Active");
}
else{
	%>

	<input type=checkbox name=active value=yes <%=activeyes%>>
<%}%>
		</td>
</tr>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  value='UPDATE' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</td>
</tr>

<%
		}//while
pstmt_p.close();
C.returnConnection(conp);

}//if Partyselected

}catch(Exception Samyak233){ 
	out.println("<br><font color=red> FileName : EditParty.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");} 
%>

</BODY>
</HTML>









