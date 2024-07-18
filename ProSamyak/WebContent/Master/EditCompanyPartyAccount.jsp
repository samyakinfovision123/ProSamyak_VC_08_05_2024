<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="CVD" class="NipponBean.CustomerVendorDetail"/>
<jsp:useBean   id="LG"  class="NipponBean.LedgerGroup" /> 
<jsp:useBean   id="YED" class="NipponBean.YearEndDate" />
<%
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
		}catch(Exception Samyak13){ 
	out.println("<font color=red> FileName : EditParty.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");
	}
String errLine="17";
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
String user_name= ""+session.getValue("user_name");
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
int usDlr= Integer.parseInt(""+session.getValue("usDlr"));
String yearend_id= ""+session.getValue("yearend_id");
String command = request.getParameter("command");
//System.out.println("command="+command);
String message = request.getParameter("message"); 

String edited_id="";
if("masters".equals(message))
{}
else{//out.println("<center><font class='submit1'> "+message+"</font></center><br>");
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
<script language="javascript" src="../Samyak/ajax1.js"></script>
<script language="javascript" src="../Samyak/Ledger.js"></script>

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
		if(tempA.length < 2)
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
function showSubGroup()
{
	var companyid=<%=company_id%>
	var group=document.mainform.category.value;
	//alert("companyid="+companyid);
	getSubGroup(group,companyid);
	
	
}//
/*function isTransactionExist(ledger_no)
{
	alert("ledger_no="+ledger_no);
	var companyid=<%=company_id%>
	if(ledger_no==1)
	{
		
	alert("In ");	
	alert("document.mainform.companyparty_id="+document.mainform.companyparty_id.value);	getTransactionCount(ledger_no,companyid,document.mainform.companyparty_id.value);
	
	}
	if(ledger_no==2)
	{
		getTransactionCount(ledger_no,companyid,document.mainform.companyparty_id.value);
	}
	if(ledger_no==3)
	{
		getTransactionCount(ledger_no,companyid,document.mainform.companyparty_id.value);
	}
}*/
function showHideSpan()
{
	var hide_info_span_ele=document.getElementById('hide_info_span');
	var info_span_ele=document.getElementById('info_span');
	if(document.mainform.other_info.checked)
	{
		hide_info_span_ele.style.visibility="Hidden";
		info_span_ele.style.visibility="Visible";
	}
	else
	{	
		info_span_ele.style.visibility="Hidden";
		hide_info_span_ele.style.visibility="Visible";
		
		
	}
}
//-->
function checkCurrency()
{
	var local_dec=<%=d%>;
	var dollar_dec=<%=usDlr%>;
	var opening_ele=document.getElementById('opening_amount');
	var opening_drcr_ele=document.getElementById('isDrCr');
	var	debtors_ele=document.getElementById('deb');
	var debtors_drcr_ele=document.getElementById('deb_drcr');
	var	creditors_ele=document.getElementById('cre');
	var	creditors_drcr_ele=document.getElementById('cre_drcr');
	var closing_ele=document.getElementById('clo');	
	var closing_drcr_ele=document.getElementById('clo_drcr');	
	
	if(document.mainform.currency[0].checked)
	{
		var opening=document.mainform.loc_opening.value;
		var tran_debit=document.mainform.loc_trans_debit.value;
		var tran_credit=document.mainform.loc_trans_credit.value;
		var closing=document.mainform.loc_closing.value;
		
		if(opening>=0)
		{
				opening_ele.value=opening.toFixed(local_dec);
				opening_drcr_ele.value="Credit";
		}
		else
		{
				opening_ele.value=opening*(-1).toFixed(local_dec);
				opening_drcr_ele.value="Debit"
		}
	
		if(tran_debit>=0)
		{
				//debtors_ele.innerHTML=tran_debit+" "+"Dr";
				debtors_ele.value=tran_debit.toFixed(local_dec);
				debtors_drcr_ele.value="Dr";
		}
		else
		{
				debtors_ele.value=tran_debit*(-1).toFixed(local_dec);
				debtors_drcr_ele.value="Cr";		
		}
		if(tran_credit>=0)
		{
				creditors_ele.value=tran_credit.toFixed(local_dec);
				creditors_drcr_ele.value="Dr";
		}
		else
		{
				creditors_ele.value=tran_credit*(-1).toFixed(local_dec);
				creditors_drcr_ele.value="Cr";
		}
		
		if(closing>=0)
		{
				closing_ele.value=closing.toFixed(local_dec);
				closing_drcr_ele.value="Dr";
		}
		else
		{
				closing_ele.value=closing*(-1).toFixed(local_dec);
				closing_drcr_ele.value="Cr";
		}
	
	}
	if(document.mainform.currency[1].checked)
	{
		var opening=document.mainform.dol_opening.value;
		var tran_debit=document.mainform.dol_trans_debit.value;
		var tran_credit=document.mainform.dol_trans_credit.value;
		var closing=document.mainform.dol_closing.value;
		alert("tran_credit="+tran_credit);
		if(opening>=0)
		{
				opening_ele.value=opening.toFixed(dollar_dec);
				opening_drcr_ele.value="Credit"
		}
		else
		{
				opening_ele.value=opening*(-1).toFixed(dollar_dec);
				opening_drcr_ele.value="Debit"
		}
	
		if(tran_debit>=0)
		{
				debtors_ele.value=tran_debit.toFixed(dollar_dec);
				debtors_drcr_ele.value="Dr";
		}
		else
		{
				debtors_ele.value=tran_debit*(-1).toFixed(dollar_dec);
				debtors_drcr_ele.value="Cr";
		}

		if(tran_credit>=0)
		{
				creditors_ele.value=tran_credit.toFixed(dollar_dec);
				creditors_drcr_ele.value="Dr";	
		}
		else
		{
				
				creditors_ele.value=tran_credit*(-1).toFixed(dollar_dec);
				creditors_drcr_ele.value="Cr";	
		}
		if(closing>=0)
		{
				closing_ele.value=closing.toFixed(dollar_dec);
				closing_drcr_ele.value="Dr";
		}
		else
		{
				closing_ele.value=closing*(-1).toFixed(dollar_dec);
				closing_drcr_ele.value="Cr";
		}
	
	}
}

</script>
<script language="JavaScript">
<!--
function setFoucs()
{
	document.mainform.companyparty_name.select();
}
//-->
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<script language="javascript" src="../Samyak/Ledger.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onLoad='setFoucs();'>

<!--  Company selection form -->

<% 

if("edit".equals(command))
{
%>
<form action="EditCompanyPartyAccount.jsp?command=PartySelected&message=masters" method=post >
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
	

}
%>

<%
try{
	
if("PartySelected".equals(command))
{
			

	String companyparty_id=request.getParameter("CompanyParty_Id");
	
	String salespartygroup_id = A.getNameCondition(conp, "Ledger", "PartyGroup_Id","where For_Head=14 and Ledger_Type=1 and For_HeadId="+companyparty_id);

	String interest = A.getNameCondition(conp, "Ledger", "Interest","where For_Head=14 and Ledger_Type=1 and For_HeadId="+companyparty_id);
	
	String purchasepartygroup_id = A.getNameCondition(conp, "Ledger", "PartyGroup_Id","where For_Head=14 and Ledger_Type=2 and For_HeadId="+companyparty_id);

	String OtherActive="";
	String query= "select active from ledger where for_headid <>"+companyparty_id+" and parentcompanyparty_id=?";
		pstmt_p  = conp.prepareStatement(query);
		pstmt_p.setString(1, companyparty_id);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{
			OtherActive=rs_g.getString("active");
		}
		pstmt_p.close();
	 query = "select * from Receive where Receive_FromId=?";
		pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, companyparty_id);
	rs_g = pstmt_p.executeQuery();
	int rec_count=0;
	while(rs_g.next())
		{rec_count++; }
	pstmt_p.close();
	 query = "select * from Master_CompanyParty where CompanyParty_Id=? and company_id="+company_id;
	//out.println("companyparty_id="+companyparty_id);
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, companyparty_id);
	rs_g = pstmt_p.executeQuery();

while(rs_g.next())
{
//out.println("341");
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
String shikesho_active		=rs_g.getString("Shikesho");

String salesperson_id=rs_g.getString("SalesPerson_Id");
String duedays="";

duedays=rs_g.getString("Due_Days");

	if (rs_g.wasNull())
			{duedays="0";}



java.sql.Date opening_date = new java.sql.Date(System.currentTimeMillis());

opening_date=rs_g.getDate("Opening_Date");
String today_string= format.format(opening_date);

String credit_limit_per_day=rs_g.getString("PerDay_CreditLimit");

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





<form action='UpdateNewCompanyPartyAccount.jsp' method=post name="mainform" onsubmit="return LocalValidate();">
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor="skyblue">
<th colspan=4 align=center>
Update Account</th>
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

<tr>
	<td colspan=4><hr></hr></td>
</tr>
<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr>
	<td colspan=4><hr></hr></td>
</tr>
<%
java.sql.Date from_date = YED.getDate(conp, "YearEnd", "From_Date", " where company_id="+company_id+" and yearend_id="+yearend_id);

java.sql.Date to_date = YED.getDate(conp, "YearEnd", "To_Date", "  where company_id="+company_id+" and yearend_id="+yearend_id);
	

%>
<tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=1><INPUT type=text name=companyparty_name size=30 value="<%=companyparty_name%>" TABINDEX="1"></td>

<td colspan=1><script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Opening Date' style='font-size:11px ;  width:70'>")}
</script>
</td>
<td>
 <input type=text name='datevalue' id='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+from_date+"\"");%>,<%out.print("\""+to_date+"\"");%>);'>


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
		<input type=radio size=4 name=currency value=dollar <%=dollar_checked%>  TABINDEX="2">Dollar</td>
	 <%}%>


<%
	query="select Ledger_type from Ledger where ParentCompanyParty_Id="+companyparty_id+" and MainLedger=1"; 
	pstmt_p=conp.prepareStatement(query);
	
	rs_g = pstmt_p.executeQuery();
	
	String ledger_type="";
	String ledger_type1="";
	boolean isActive=false;
	while(rs_g.next())
	{
		ledger_type=rs_g.getString("Ledger_type");  
	}
	
	String query1="select For_Head,Ledger_type,Active from Ledger where For_Head<>14 and ParentCompanyParty_Id="+companyparty_id+" and  company_id="+company_id+" and active=1";
	pstmt_p=conp.prepareStatement(query1);
	rs_g = pstmt_p.executeQuery();
	
	String For_Head="";
	
	while(rs_g.next())
	{
		For_Head=rs_g.getString("For_Head");  
		//out.print("<br> 467 "+For_Head);
		ledger_type1=rs_g.getString("Ledger_type");	
		isActive=rs_g.getBoolean("Active");
		ledger_type1=" and subGroup_Id="+ledger_type1;
		
	}
	if("".equals(For_Head))
	{
		
		For_Head="2";
		ledger_type1=" or subGroup_Id=0";
		isActive=true;
	} //if("".equals(For_Head))
%>


<!--   For Calculation of Opening,transaction ,closing of party  -->
 

 <!-- For Sundry debitors   -->

<%	
	String ledger_id="";	
	double sundry_local_opening=0;
	double sundry_dollar_opening=0;
	String str_ledgerId="select ledger_id from ledger where ledger_type=1 and company_id="+company_id+" and active=1 and for_headId="+companyparty_id;

	pstmt_p=conp.prepareStatement(str_ledgerId);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		ledger_id=rs_g.getString("ledger_id");
		
	}
	pstmt_p.close();
	
	str_ledgerId="select * from Master_CompanyParty where  company_id="+company_id+" and active=1 and companyparty_id="+companyparty_id;

	pstmt_p=conp.prepareStatement(str_ledgerId);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		sundry_local_opening=rs_g.getDouble("opening_rlocalbalance");
		sundry_dollar_opening=rs_g.getDouble("opening_rdollarbalance");
	}
	pstmt_p.close();


	String ctaxLedgerId = A.getNameCondition(conp, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");

	
	
	//out.println("<br> ######### ");
	String party_id[]=new String[1];
	String led_id[]=new String[1];
	party_id[0]=companyparty_id;
	led_id[0]=ledger_id;
	CVD.CustomerVendorDetailAllRows(led_id, conp, from_date, to_date, party_id, company_id,"sale", ctaxLedgerId);
	
	//out.println("ledger_id"+ledger_id);
	//out.println("from_date"+from_date);
	//out.println("to_date"+to_date);
	//out.println("sundry_local_opening"+sundry_local_opening);
	//out.println("sundry_dollar_opening"+sundry_dollar_opening);
	//out.println("companyparty_id"+companyparty_id);
	//out.println("company_id"+company_id);
	
	String row="";
	row = CVD.CustomerVendorDetailRow(ledger_id, conp, from_date, to_date, sundry_local_opening, sundry_dollar_opening, companyparty_id, company_id, "sale", ctaxLedgerId);
	
	//out.println("<br> row="+row);
	
	StringTokenizer rowTokens = new StringTokenizer(row,"#");
	errLine = "337";
	double local_opening_dr = Double.parseDouble((String)rowTokens.nextElement());
	errLine = "375";
	double local_opening_cr = Double.parseDouble((String)rowTokens.nextElement());
	double local_trans_dr_sale = Double.parseDouble((String)rowTokens.nextElement());
	double local_trans_cr_sale = Double.parseDouble((String)rowTokens.nextElement());
	double local_closing_dr = Double.parseDouble((String)rowTokens.nextElement());
	double local_closing_cr = Double.parseDouble((String)rowTokens.nextElement());
	errLine = "380";
	double dollar_opening_dr = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_opening_cr = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_trans_dr_sale = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_trans_cr_sale = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_closing_dr = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_closing_cr = Double.parseDouble((String)rowTokens.nextElement());
	

//out.println("local_opening_dr="+local_opening_dr);
//out.println("local_opening_cr="+local_opening_cr);

%>
 <!--  End for Sundry debitors  -->


<!-- For Sundry creditors  -->
<%
	 ledger_id="";	
	 str_ledgerId="select ledger_id from ledger where ledger_type=2 and company_id="+company_id+" and active=1 and for_headId="+companyparty_id;

	pstmt_p=conp.prepareStatement(str_ledgerId);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		ledger_id=rs_g.getString("ledger_id");
		
	}
	pstmt_p.close();
	
	str_ledgerId="select * from Master_CompanyParty where  company_id="+company_id+" and active=1 and companyparty_id="+companyparty_id;

	pstmt_p=conp.prepareStatement(str_ledgerId);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		sundry_local_opening=rs_g.getDouble("opening_plocalbalance");
		sundry_dollar_opening=rs_g.getDouble("opening_pdollarbalance");
	}
	pstmt_p.close();


	ctaxLedgerId = A.getNameCondition(conp, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");
	led_id[0]=ledger_id;
	CVD.CustomerVendorDetailAllRows(led_id, conp, from_date, to_date, party_id, company_id,"purchase", ctaxLedgerId);
	
	row="";
	row = CVD.CustomerVendorDetailRow(ledger_id, conp, from_date, to_date, sundry_local_opening, sundry_dollar_opening, companyparty_id, company_id, "purchase", ctaxLedgerId);
	
	rowTokens = new StringTokenizer(row,"#");
	errLine = "337";
	local_opening_dr += Double.parseDouble((String)rowTokens.nextElement());
	errLine = "375";
	local_opening_cr += Double.parseDouble((String)rowTokens.nextElement());
	double local_trans_dr_purchase = Double.parseDouble((String)rowTokens.nextElement());
	double local_trans_cr_purchase = Double.parseDouble((String)rowTokens.nextElement());
	local_closing_dr += Double.parseDouble((String)rowTokens.nextElement());
	local_closing_cr += Double.parseDouble((String)rowTokens.nextElement());
	errLine = "380";
	
	dollar_opening_dr += Double.parseDouble((String)rowTokens.nextElement());
	dollar_opening_cr += Double.parseDouble((String)rowTokens.nextElement());
	double dollar_trans_dr_purchase = Double.parseDouble((String)rowTokens.nextElement());
	double dollar_trans_cr_purchase = Double.parseDouble((String)rowTokens.nextElement());
	dollar_closing_dr += Double.parseDouble((String)rowTokens.nextElement());
	dollar_closing_cr += Double.parseDouble((String)rowTokens.nextElement());

//out.println("local_opening_dr="+local_opening_dr);
//out.println("local_opening_cr="+local_opening_cr);


%>
<!--    End for Sundry creditors  -->

<!--   For Ledger Opening ,Transaction and Closing --> 
	<%
	  errLine="776"; 
	double ledger_LocalOpening_Dr =0;
	double ledger_DollarOpening_Dr =0;
	double ledger_LocalOpening_Cr =0;
	double ledger_DollarOpening_Cr =0;
	double leger_LocalTrans_Dr =0;
	double ledger_DollarTrans_Dr =0;
	double ledger_LocalTrans_Cr =0;
	double ledger_DollarTrans_Cr =0;
	double ledger_LocalClosing_Dr =0;
	double ledger_DollarClosing_Dr =0;
	double ledger_LocalClosing_Cr =0;
	double ledger_DollarClosing_Cr =0;
		
	String reportyearend_id = YED.returnYearEndId(conp , pstmt_p, rs_g, from_date, company_id);
	
	ArrayList ledgerReportRows = LG.getLedgerRows(conp, company_id, reportyearend_id, from_date,to_date);

	String other_ledger_id="";
	String str_other_ledger_id="select Ledger_Id from Ledger where For_Head<>14 and company_id="+company_id+" and ParentCompanyParty_Id="+companyparty_id; 
		
		
	errLine="798";

	pstmt_p=conp.prepareStatement(str_other_ledger_id);
	rs_g = pstmt_p.executeQuery();

	while(rs_g.next())
	{
		other_ledger_id=rs_g.getString("Ledger_Id");
	}
	pstmt_p.close();
		
	for(int i=0; i<ledgerReportRows.size(); i++)
	{
			LedgerGroupRow row1 = (LedgerGroupRow)ledgerReportRows.get(i);
			if(other_ledger_id.equals(row1.getLedgerId()))
			{
				ledger_LocalOpening_Dr += row1.getLocalOpening_Dr();
				ledger_DollarOpening_Dr += row1.getDollarOpening_Dr();
				ledger_LocalOpening_Cr += row1.getLocalOpening_Cr();
				ledger_DollarOpening_Cr += row1.getDollarOpening_Cr();
				leger_LocalTrans_Dr += row1.getLocalTrans_Dr();
				ledger_DollarTrans_Dr += row1.getDollarTrans_Dr();
				ledger_LocalTrans_Cr += row1.getLocalTrans_Cr();
				ledger_DollarTrans_Cr += row1.getDollarTrans_Cr();
				ledger_LocalClosing_Dr += row1.getLocalClosing_Dr();
				ledger_DollarClosing_Dr += row1.getDollarClosing_Dr();
				ledger_LocalClosing_Cr += row1.getLocalClosing_Cr();
				ledger_DollarClosing_Cr += row1.getDollarClosing_Cr();

			
			}
		
	 }
errLine="832";	

//out.println("ledger_LocalOpening_Dr="+ledger_LocalOpening_Dr);
//out.println("ledger_LocalOpening_Cr="+ledger_LocalOpening_Cr);

%>
<!--  End for Ledger Opening ,Transaction and Closing --> 

<%
  double total_local_opening=local_opening_dr+local_opening_cr*(-1)+ledger_LocalOpening_Dr+ledger_LocalOpening_Cr*(-1);
  
  double total_local_trans_debit=local_trans_dr_sale+local_trans_dr_purchase*(1)+leger_LocalTrans_Dr;
   
  double total_local_trans_credit=local_trans_cr_sale*(-1)+local_trans_cr_purchase*(-1)+ledger_LocalTrans_Cr*(-1);

  double total_local_closing=local_closing_dr+local_closing_cr*(-1)+ledger_LocalClosing_Dr+ledger_LocalClosing_Cr*(-1);

  
  double total_dollar_opening=dollar_opening_dr+dollar_opening_cr*(-1)+ledger_DollarOpening_Dr+ledger_DollarOpening_Cr*(-1);
  
  double total_dollar_trans_debit=dollar_trans_dr_sale+dollar_trans_cr_sale*(-1)+ledger_DollarTrans_Dr;
  
  double total_dollar_trans_credit=dollar_trans_dr_purchase+dollar_trans_cr_purchase*(-1)+ledger_DollarTrans_Cr*(-1);
  
  double total_dollar_closing=dollar_closing_dr+dollar_closing_cr*(-1)+ledger_DollarClosing_Dr+ledger_DollarClosing_Cr*(-1);

errLine="863";
%>
<!-- End for Calculation of Opening,transaction ,closing of party  -->

<!--    For sale ,purchase and  other opening balance   -->
<td>Opening Balance</td>

<td id='opening_td' align='right'>&nbsp;&nbsp;&nbsp;&nbsp;
<%if(rec_count>0)
{

if("checked".equals(local_checked))
{
    
	if(total_local_opening>=0)
	{%>
		
		<input type=text size=10 name=opening_amount value=<%=str.mathformat(""+total_local_opening,d)%> 			style="text-align:right;background-color:#FFFFFF;border-style:inset" TABINDEX="3">
		<Select name=isDrCr TABINDEX="4">
		
		<option value='Credit' selected>Dr</option>
		<option value='Debit' >Cr</option>
		
		</select>
		</td>
	<%
	}
		else
	{%>
		<input type=text size=10 name=opening_amount value=<%=str.mathformat(""+(total_local_opening*(-1)),d)%> 				style="text-align:right;border-style:solid;background-color:#FFFFFF" TABINDEX="5">
		<Select name=isDrCr TABINDEX="6">
		
		<option value='Credit' >Dr</option>
		<option value='Debit' selected>Cr</option>
		
		</select>
		</td>
		
	<%}
} 
else  
{
	
	if(total_dollar_opening>=0)
	{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=str.mathformat(""+total_dollar_opening,usDlr)%> 				style="text-align:right;border-style:solid;background-color:#FFFFFF" TABINDEX="3">
		<Select name=isDrCr id='iDrCr' TABINDEX="4">
		
		<option value='Credit' selected>Dr</option>
		<option value='Debit' >Cr</option>
		
		</select>
		</td>
		
		<%//=total_dollar_opening+" "+"Dr"%>
	<%
	}
		else
	{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=str.mathformat(""+(total_dollar_opening*(-1)),usDlr)%> 				style="text-align:right;border-style:solid;background-color:#FFFFFF" TABINDEX="5">
		<Select name=isDrCr id='iDrCr' TABINDEX="6">
		
		<option value='Credit'  >Dr</option>
		<option value='Debit' selected>Cr</option>
		
		</select>
		</td>
		
		<%//=(total_dollar_opening*(-1))+" "+"Cr"%>
	<%}

}
} %>

 <%if(rec_count==0)
	 { 
	 if("checked".equals(local_checked))
	 {
		if(total_local_opening>=0)
		{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=(str.mathformat(""+total_local_opening,d))%> 				style="text-align:right;border-style:solid;background-color:#FFFFFF" TABINDEX="3">
		<Select name=isDrCr id='iDrCr' id='iDrCr' TABINDEX="4">
		
		<option value='Credit'  selected>Dr</option>
		<option value='Debit' >Cr</option>
		
		</select>
		</td>
		<%
		}
		else
		{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=str.mathformat(""+(total_local_opening*(-1)),d)%> 				style="text-align:right;border-style:solid;background:#FFFFFF" TABINDEX="5">
		<Select name=isDrCr id='iDrCr' TABINDEX="6">
		
		<option value='Credit'  >Dr</option>
		<option value='Debit' selected>Cr</option>
		
		</select>
		</td>
		<%}
	 }
	 else
	 {
		 if(total_dollar_opening>=0)
		{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=(str.mathformat(""+total_dollar_opening,d))%> 				style="text-align:right;border-style:solid;background-color:#FFFFFF" TABINDEX="4">
		<Select name=isDrCr id='iDrCr' id='iDrCr' TABINDEX="5">
		
		<option value='Credit'  selected>Dr</option>
		<option value='Debit' >Cr</option>
		
		</select>
		</td>
		<%
		}
		else
		{%>
		<input type=text size=10 name=opening_amount id='opening_amount' value=<%=str.mathformat(""+(total_dollar_opening*(-1)),d)%> 				style="text-align:right;border-style:solid;background:#FFFFFF" TABINDEX="4">
		<Select name=isDrCr id='iDrCr' TABINDEX="5">
		
		<option value='Credit'  >Dr</option>
		<option value='Debit' selected>Cr</option>
		
		</select>
		</td>
		<%}
	 }


	}%>

<input type='hidden' name='loc_opening' value=<%=str.mathformat(""+total_local_opening,d)%>>   


<input type='hidden' name='dol_opening' value=<%=str.mathformat(""+total_dollar_opening,usDlr)%>>   



<%if("1".equals(ledger_type)){%>
	
	
		<% 
	if(sale_balance >= 0) {
	%>
		<input type=hidden size=8 name="ledger_amount" value="<%=str.mathformat(""+sale_balance,d)%>" onBlur='validate(this)' style="text-align:right">
		<Select name=main_ledger_amount style='visibility:hidden'>
			<option value='Credit'>Dr</option>
			<option value='Debit'>Cr</option>
		</select>
<% } else { %>
		<input type=hidden size=8 name="ledger_amount" value="<%=str.mathformat(""+(-(sale_balance)),d)%>" onBlur='validate(this)' style="text-align:right">
			<Select name=main_ledger_amount style='visibility:hidden'>
				<option value='Debit'>Cr</option>
				<option value='Credit'>Dr</option>
			</select>
<% } %>

<%}if("2".equals(ledger_type)){%>
	<% 
	if(purchase_balance >= 0) {
		%>
		<input type=hidden size=8 name="ledger_amount" value="<%=str.mathformat(""+purchase_balance,d)%>" onBlur='validate(this)' style="text-align:right">
		<Select name=main_ledger_amount style='visibility:hidden'>
			<option value='Credit'>Dr</option>
			<option value='Debit'>Cr</option>
		</select>
<% } else { %>
		<input type=hidden size=8 name="ledger_amount" value="<%=str.mathformat(""+(-(purchase_balance)),d)%>" onBlur='validate(this)' style="text-align:right">
		<Select name=main_ledger_amount style='visibility:hidden'>
			<option value='Debit'>Cr</option>
			<option value='Credit'>Dr</option>
		</select>
<% } %>


<%}if(!("1".equals(ledger_type))&&!("2".equals(ledger_type))){%>
	 <input type=hidden size=10 name=ledger_amount value=0 style="text-align:right" ><Select name=main_ledger_amount style='visibility:hidden'>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
	</select>
<%}%>
<!--    End of sale, purchase and other opening balance  --> 
</tr>
<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=1><input type=text size=4 name=exchange_rate value ='<%=str.format(""+exchange_rate,2)%>' onBlur='validate(this)' style="text-align:right" TABINDEX="6"></td>
<td>Transaction Dr</td><td id='debtors_td' align=right>
<%if(rec_count>0)
{
if("checked".equals(local_checked))
{
    if(total_local_trans_debit>=0)
	{%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value=<%=str.format(""+total_local_trans_debit,d)%>>
		<input type=text name='deb_drcr' id='deb_drcr' size=1 style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value='Dr' readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_local_trans_debit*(-1)),d)%>><input type=text name='deb_drcr' id='deb_drcr' size=1 style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value='Cr' readOnly></td>
	<%}
} 
 else  
{
	if(total_dollar_trans_debit>=0)
	{%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_dollar_trans_debit,usDlr)%>><input type=text name='deb_drcr' size=1 id='deb_drcr' value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_dollar_trans_debit*(-1)),d)%>><input type=text name='deb_drcr' size=1 id='deb_drcr' value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}

}
} %>

 <%if(rec_count==0)
	 { 
	 if("checked".equals(local_checked))
	 {
	 if(total_local_trans_debit>=0)
	 {%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_local_trans_debit,d)%>><input type=text name='deb_drcr' id='deb_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly> </td>
		
	<%
	
	 }
		else
	{%>
		<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_local_trans_debit*(-1)),d)%>>
		<input type=text name='deb_drcr' id='deb_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly>
		</td>
	<%}
	 }
	 else
	 {
		if(total_dollar_trans_debit>=0)
		{%>
			<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_dollar_trans_debit,d)%>><input type=text name='deb_drcr' id='deb_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly> </td>
		
		<%
	
		}
		else
		{%>
			<input type=text name='deb' id='deb' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_dollar_trans_debit*(-1)),d)%>>
			<input type=text name='deb_drcr' id='deb_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly>
			</td>
		<%}
	
	
	 }
	
	}%>
<input type='hidden' name='loc_trans_debit' value=<%=str.format(""+total_local_trans_debit,d)%>>   
<input type='hidden' name='dol_trans_debit' value=<%=str.format(""+total_dollar_trans_debit,usDlr)%>>   

</tr>
 
<tr><td colspan=2></td>
<td>Transaction Cr</td><td id='creditors_td' align='right'>
<%if(rec_count>0)
{
if("checked".equals(local_checked))
{
    if(total_local_trans_credit>0)
	{%>
		<input type=text name='cre' id='cre' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_local_trans_credit,d)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='cre' id='cre' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value=<%=str.format(""+(total_local_trans_credit*(-1)),d)%>><input type=text name='cre_drcr' id='cre_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}
	} 
	else  
	{
	if(total_dollar_trans_credit>0)
	{%>
		<input type=text name='cre' id='cre' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value=<%=str.format(""+total_dollar_trans_credit,usDlr)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%> 
		<input type=text name='cre' id='cre' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+((-1)*total_dollar_trans_credit),usDlr)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}

}
} %>

 <%if(rec_count==0)
	 { 
	 if("checked".equals(local_checked))
	 {
	  if(total_local_trans_credit>0)
	  {%>
		<input type=text name='cre' size=10 id='cre' readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_local_trans_credit,d)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
		<%
		}
	  else
	  {%>
		<input type=text name='cre' size=10 id='cre' readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value=<%=str.format(""+(total_local_trans_credit*(-1)),d)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}
	 }
	 else
	 {
	
	 if(total_dollar_trans_credit>0)
	  {%>
		<input type=text name='cre' size=10 id='cre' readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_dollar_trans_credit,d)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
		<%
		}
	  else
	  {%>
		<input type=text name='cre' size=10 id='cre' readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" value=<%=str.format(""+(total_dollar_trans_credit*(-1)),d)%>>
		<input type=text name='cre_drcr' id='cre_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}
	 
	 }
	}%>

<input type='hidden' name='loc_trans_credit' value=<%=str.format(""+total_local_trans_credit,d)%>>   

<input type='hidden' name='dol_trans_credit' value=<%=str.format(""+total_local_trans_credit,usDlr)%>>   



</tr>
<tr>
	<td>Due Days</td> 
    <td><input type=text name=duedays value=<%=duedays%> style="text-align:right" size=7 onblur="return validate(this,0)" TABINDEX="7"></td>
	<td>Closing</td>
	<td id='closing_td' align='right'>
	
	
	
<%if(rec_count>0)
{
if("checked".equals(local_checked))
{
    if(total_local_closing>=0)
	{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_local_closing,d)%>>
		<input type=text name='clo_drcr' id='clo_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_local_closing*(-1)),d)%>><input type=text name='clo_drcr' size=1 id='clo_drcr' value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}
} 
 else  
{
	if(total_dollar_closing>=0)
	{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_dollar_closing,usDlr)+" "+"Dr"%>><input type=text name='clo_drcr' size=1 id='clo_drcr' value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_dollar_closing*(-1)),usDlr)%>><input type=text name='clo_drcr' size=1 id='clo_drcr' value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}

}
} %>

 <%if(rec_count==0)
	 { 
	  if("checked".equals(local_checked))
	  {
		 if(total_local_closing>=0)
			{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_local_closing,d)%>><input type=text name='clo_drcr' id='clo_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%
	}
		else
	{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_local_closing*(-1)),d)%>><input type=text name='clo_drcr' id='clo_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
	<%}
	  }
	else
	{
		if(total_dollar_closing>=0)
		{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+total_dollar_closing,d)%>><input type=text name='clo_drcr' id='clo_drcr' size=1 value='Dr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
		<%
		}
		else
		{%>
		<input type=text name='clo' id='clo' size=10 readOnly style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'"  value=<%=str.format(""+(total_dollar_closing*(-1)),d)%>><input type=text name='clo_drcr' id='clo_drcr' size=1 value='Cr' style="text-align:right;border-style:none;background:\'../Buttons/BGCOLOR.JPG\'" readOnly></td>
		<%}
		 
		 
	}
}%>

<input type='hidden' name='loc_closing' value=<%=str.format(""+total_local_closing,d)%>>   

<input type='hidden' name='dol_closing' value=<%=str.format(""+total_dollar_closing,usDlr)%>>   
<tr>
	<td colspan=6><hr></hr></td>
</tr>
<tr>
  <td>Credit Limit Currency <font class="star1">*</font></td>
  
<td><input type=radio size=4 name=currency_limit value=local    <%=local_checked1%>  TABINDEX="8"> Local

<input type=radio size=4 name=currency_limit value=dollar <%=dollar_checked1%>  TABINDEX="9">Dollar</td>

 
</tr>
<tr>
	<td>Credit Limit</td> 
    <td><input type=text size=8 name="credit_limit" value=<%=credit_limit%> onBlur='validate(this)' style="text-align:right" TABINDEX="10"></td>
	<td>Credit Limit Per Day</td>
    <td><input type=text size=8 name="credit_limit_per_day" value=<%=credit_limit_per_day%> onBlur='validate(this)' style="text-align:right" TABINDEX="11"></td>
    
</tr>
</table>

<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr><td colspan=6><hr></hr></td></tr>
<tr>
	<th colspan=1>Main Ledger</th>
<td></td>

<%if("1".equals(ledger_type)){%>
	
	<td><input type=radio name=main_ledger value=sale checked TABINDEX="12"> Sale</td>
	<td><input type=radio name=main_ledger value=purchase  TABINDEX="13">Purchase</td>
	<td><input type=radio name=main_ledger value='others' TABINDEX="14"> Others &nbsp;&nbsp;
	Amount</td> 
	
<%}if("2".equals(ledger_type)){%>
	<td><input type=radio name=main_ledger value=sale TABINDEX="12"> Sale</td>
	<td><input type=radio name=main_ledger value=purchase checked  TABINDEX="13"> Purchase 
	<td><input type=radio name=main_ledger value='others' TABINDEX="14">Others &nbsp;&nbsp;
	Amount</td> 
<%}if(!("1".equals(ledger_type))&&!("2".equals(ledger_type))){%>
	<td><input type=radio name=main_ledger value=sale TABINDEX="12"> Sale</td>
	<td><input type=radio name=main_ledger value=purchase  TABINDEX="13">Purchase</td>
	
	<td><input type=radio name=main_ledger value='others' checked TABINDEX="14">Others &nbsp;&nbsp;
	Amount</td>
<%}%>
</tr>
<tr><td colspan=6><hr></hr></td></tr>
<input type=hidden size=8 name="opening_salesbalance" value="<%=str.mathformat(""+sale_balance,d)%>" >
<input type=hidden size=8 name="opening_purchasebalance" value="<%=str.mathformat(""+purchase_balance,d)%>">

<input type=hidden size=8 name="opening_pnbalance" value="<%=str.mathformat(""+pn_balance,d)%>" >
<%errLine="1211";%>
<tr>
<td> Others</td><td colspan=1 align=left></td>		
<td>Ledger Group</td>
<td>

	<%=A.getCategoryArray(conp,"Master_FinanceHeads","category\'  OnChange=\'showSubGroup();\' TABINDEX=\'15\' style=\'width:150;font-size:12",""+For_Head," where Main_Group=1","Head_Id","Head_Name","2") %>
	</td>
	<td colspan=1 align=left>SubGroup</td>
<td>	<%=A.getCategoryArray(conp,"Master_SubGroup","SubGroup\' TABINDEX=\'16\' style=\'width:150;",""+For_Head,"  where company_id="+company_id+" and For_HeadId="+For_Head+"   "+ledger_type1,"SubGroup_Id","SubGroup_Name","2") %>
</td>
</tr>
<tr>
<td>Sales</td>	 
<td colspan=1>
</td>
<td>Sales Party Group</td>
<td>
<%errLine="1229";%>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","salespartygroup_id\'     TABINDEX=\'17",salespartygroup_id,"where Active=1 and Group_Type=0",company_id)%>
</td>
<td>Sales Person</td>
<%if("15".equals(user_level))
	{	
		String sersonId=A.getNameCondition(conp,"Master_SalesPerson","SalesPerson_Id","where SalesPerson_Name='"+user_name+"' and active=1 and PurchaseSale=0");
		if(sersonId.equals(""))
		{%><td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id\' TABINDEX=\'9","","where company_id="+company_id+" and PurchaseSale=0")%></td>
		<%}
		else
		{%><td><%=user_name%><td>
			<%}
	}
	else
	{
%>
<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id\' TABINDEX=\'18",salesperson_id,"where company_id="+company_id+" and PurchaseSale=0")%></td>
<%}%>
</tr>

</tr>

<tr>
<td>Purchase</td>	 
<td colspan=1>
</td>
<td>Purchase Party Group</td>
<td>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","purchasepartygroup_id\' TABINDEX=\'19 ",purchasepartygroup_id,"where Active=1 and Group_Type=1",company_id)%>
</td>
<td>Purchase Person</td>

<%if("15".equals(user_level))
	{	
		String personId=A.getNameCondition(conp,"Master_SalesPerson","SalesPerson_Id","where SalesPerson_Name='"+user_name+"' and active=1 and PurchaseSale=1");
		if(personId.equals(""))
		{%><td>
			<%=AC.getMasterArrayCondition(conp,"SalesPerson","purchaseperson_id\' TABINDEX=\'20" ,"","where company_id="+company_id+" and PurchaseSale=1")%>
			</td>
		<%}
		else
			{%>
				<td><%=user_name%></td>
			<%}
	}else{%>
<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id\' TABINDEX=\'21 ",person2,"where company_id="+company_id+" and PurchaseSale=1")%></td> <%}%>
</tr>

<%errLine="1250";%>
<tr>
<td colspan=6 align='center'>Other Information<input type=checkbox name=other_info OnClick="showHideSpan();" TABINDEX="22"></td>
</tr>
<tr><td colspan=6><hr bgcolor=skyblue></hr></td></tr>
<!-- <tr> -->
<!-- <td>PN</td>	 
<td colspan=3><input type=checkbox name=pn value=yes  <%=pn_flag%>>
Opening Balance -->
<% 
if(pn_balance >= 0) {
%>
<input type=hidden size=8 name="opening_pnbalance" value="<%=str.mathformat(""+pn_balance,d)%>" onBlur='validate(this)' style="text-align:right">
<% } else { %>
<input type=hidden size=8 name="opening_pnbalance" value="<%=str.mathformat(""+(-(pn_balance)),d)%>" onBlur='validate(this)' style="text-align:right">

<% } %>

<input type=hidden size=8 name="credit_limit" value='<%=str.mathformat(""+credit_limit,d)%>' onBlur='validate(this)' style="text-align:right"><!-- </td> -->


<input type=hidden size=8 name="shikesho" value='yes' <%=shikesho_flag%>><!-- </td> -->

<!-- <td>Due Days</td>
<td> --><input type=hidden name=duedays value="<%=duedays%>" size="7" style="text-align:right" onblur="return validate(this,0)"><!-- </td> -->

<!-- <tr><td>Closing Date</td> <td><%//=A.getMasterArrayCondition(conp,"ClosingPayment","closing",closing,"Where payment=0 order by SR_NO")%></td>
<td>Interest Rate (%)</td>
<td> --><input type=hidden name=interest value="<%=str.mathformat(interest,2)%>" size="7" style="text-align:right" onblur="return validate(this,2)">
	<!--</td>
	
</tr>
<tr><td>Payment Date</td> <td><%//=A.getMasterArrayCondition(conp,"ClosingPayment","payment",payment,"Where payment=1 and active=1 order by SR_NO")%></td></tr>
 -->


	<!-- <td>SubGroup Name</td> -->
	<input type=hidden name=subgroup_name value="">
<!-- </tr> -->

</table>

<span id='hide_info_span'>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	
	<td colspan=2 align='center'><INPUT type=Button  name=command  id='button1' value='BACK' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick='history.go(-1)' TABINDEX="23"> </td><td colspan=2 align='center'><INPUT type=submit  name=command  id='button1' value='UPDATE' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" TABINDEX="24"> </td>
</tr>
</table>
</span>
<span id='info_span' style='visibility:Hidden'>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr>
	<td colspan=4 align=center>
		Other<input type=checkbox name=check_amount value=yes <%if(OtherActive.equals("1")){%><%="checked"%><%}%> TABINDEX="25">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Sale<input type=checkbox name=sale value=yes <%=sale_flag%> TABINDEX="26" >
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Purchase<input type=checkbox name=purchase value=yes  <%=purchase_flag%> TABINDEX="27">
	</td>
</tr>

<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 value='<%=address1%>' size=50 TABINDEX="28"> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 value='<%=address2%>' size=50 TABINDEX="29"></td> 
</tr>
<%errLine="1322";%>
<tr>
    <td></td> 
    <TD colSpan=1><INPUT  type=text name=address3 value='<%=address3%>' size=25 TABINDEX="30"></td> 
    <td>City</td> 
    <td><INPUT  type=text name=city value='<%=city%>' TABINDEX="31"></td> 
</tr>
<tr>
    <td>Pin</td> 
    <td><INPUT  type=text name=pin value='<%=pin%>' TABINDEX="32"></td> 
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country value='<%=country%>' TABINDEX="33"></td>
</tr> 

<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name=income_taxno value='<%=income_taxno%>' TABINDEX="34"></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name=sales_taxno value='<%=sales_taxno%>' TABINDEX="35"></td>
</tr>

<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off value='<%=phone_off%>' TABINDEX="36"></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi value='<%=phone_resi%>' TABINDEX="37"></td>
</tr>

<tr>
    <td>Fax</td> 
    <td><INPUT  type=text name=fax_no value='<%=fax_no%>' TABINDEX="38"></td>
	<td>Mobile</td>
    <td><INPUT  type=text name=mobile value='<%=mobile%>' TABINDEX="39"></td>
</tr>	

<tr>
    <td>Email</td> 
    <td><INPUT  type=text name=email value='<%=email%>' TABINDEX="40"></td>
    <td>Website</td> 
    <td><INPUT  type=text name=website value='<%=website%>' TABINDEX="41"></td>
	
<tr>
      <td>Interest rate (%)</td>
    <td><input type=text name=interest value=<%=interest%> style="text-align:right" size=7 onblur="return validate(this,2)"></td>
</tr>
	<INPUT type=hidden name=person1 value='<%=person1%>'>
	<INPUT type=hidden name=person2 value='<%=person2%>'>
<tr><td>Active</td> 
	<td>
<%errLine="1371";%>
<%if(rec_count>0)
{
errLine="1374";
out.print("<input type=hidden name=active value=yes >");
//out.print("Active");
errLine="1377";
}
else{
	errLine="1380";
	%>

	<input type=checkbox name=active value=yes <%=activeyes%> TABINDEX="42">
<%
		errLine="1385";
	}
	errLine="1435";
	%>
		</td>
</tr>

<TR align=center>
<TD colspan=4>
	<INPUT type=submit  name=command  id='button2' value='UPDATE' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" TABINDEX="43"> 
</td>
</tr>
</table>
</span>
<%
// out.println("Hello");
errLine="1450";
break;
}//while
errLine="1395";
pstmt_p.close();
errLine="1397";
C.returnConnection(conp);
errLine="1399";
}//if Partyselected

}catch(Exception Samyak233){ 
	C.returnConnection(conp);
	out.println("<br><font color=red> FileName : EditCompanyPartyAccount.jsp <br>Bug No Samyak233 :"+ Samyak233 +"errLine="+errLine+"</font>");} 
%>

</BODY>
</HTML>









