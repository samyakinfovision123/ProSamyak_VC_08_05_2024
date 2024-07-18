<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%// System.out.println("Inside GL_New.jsp");%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="CVR" class="NipponBean.CustomerVendorReport"/>
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<% 
PreparedStatement pstmt_g=null;
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
try	
{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception e31)
{ 
	out.println("<font color=red> Bug No e31 : "+ e31);
	C.returnConnection(cong);
	C.returnConnection(conp);
}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
int usDlr= Integer.parseInt(""+session.getValue("usDlr"));

String startDate = format.format(YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));
//out.print("<br>25 startDate"+startDate);
String command = request.getParameter("command");
//out.println("command is "+command);
String message=request.getParameter("message");
//out.print("<br>25 message="+message);
String local_currency= I.getLocalCurrency(cong,company_id);
float percentage=0.001f;
String errLine="37";
String local_symbol= I.getLocalSymbol(cong,company_id);
String party_currency="";
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
java.sql.Date from_date=new java.sql.Date((2006-1900),03,01);
java.sql.Date to_date=new java.sql.Date((2007-1900),02,31);
//String name   = request.getParameter("name"); 
if("Default".equals(message))
{
}
else
{
	out.println("<center><font class='submit1'> "+message+"</font></center>");
}
int counter=0;
String query="";
String query1="";
//String companyparty_id= ""+L.get_master_id(cong,"Master_companyparty");
//System.out.println("companyparty id is "+companyparty_id);
if("Default".equals(command))
{
try
{
%>
<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script>
</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<SCRIPT language="javascript" src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/ajax1.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/actb.js"></SCRIPT>
<script language=javascript src="../Samyak/common.js"></script>


<STYLE type='text/css'>
.tableContainer {
		MARGIN: 0px auto; 
		OVERFLOW: auto; WIDTH: 650px; 
		HEIGHT: 300px;
	}
	
	.TABLE{
		BORDER-RIGHT: slategray 1px solid; 
		BORDER-TOP: slategray 1px solid; 
		BORDER-LEFT: slategray 1px solid; 
		WIDTH: 100%; BORDER-BOTTOM: slategray 1px solid ;
		BORDER:1px solid;BORDER-COLLAPSE:separate;
		BORDER-COLOR:#000000;BACKGROUND-COLOR:#E2E2E2;
		BORDER-COLOR:#000000;
	}
	.UNKNOWN {
		OVERFLOW: auto; HEIGHT: 50px;
	}
	.THEAD TD {
		BORDER-TOP: slategray 2px solid; 
		FONT-WEIGHT: bold; FONT-SIZE: 14px; COLOR: steelblue; 
		BORDER-BOTTOM: slategray 2px solid; POSITION: relative;  
		TOP: expression(document.getElementById("data").scrollTop-2); 
		BACKGROUND-COLOR: papayawhip; TEXT-ALIGN: center;
	}
	.TD {
		PADDING-RIGHT: 1px; BORDER-TOP: slategray 1px solid; FONT-SIZE: 12px; 
		BORDER-LEFT: slategray 1px solid; COLOR: #330000; 
		FONT-FAMILY: Arial,sans-serif;BORDER-BOTTOM: slategray 1px solid;
		BORDER-RIGHT: slategray 1px solid;
	}
	
	.TFOOT TD{
		BORDER-TOP: slategray 2px solid; FONT-WEIGHT: bold; FONT-SIZE: 13px; 
		COLOR: steelblue; BACKGROUND-COLOR: papayawhip;
	}
	.TD:unknown {
		PADDING-RIGHT: 20px;
	}
</STYLE>




<script language="JavaScript">
<!--
function SubmitMe(ele)
{
	
	document.mainform.action="../Master/SaleReceiptExport.jsp?command=Default&isParty=1&changedate=none&category=Receive&party_id="+ele.value;
	document.mainform.submit();

}
function calculateMe(subme)
{
	calcAmount();
    CalcLessPaymentDollar();
	setLessPaymentExRate();
	setLessPaymentDollar();
	setLessPaymentLocal();
	calcExDiff();
	document.mainform.action="../Master/SalesReceiptExportUpdate.jsp?command=Save";
	document.mainform.submit();
}


function calcAmount()
{
	document.mainform.amount.value=(document.mainform.amount.value*document.mainform.balance_dollar_ex_rate.value);
	document.mainform.credit_total.value=document.mainform.balance_dollar.value;
	
}
function CalcLessPaymentDollar()
{
	
//alert("Hello");	
document.mainform.less_payment_dollar.value=parseFloat(document.mainform.balance_dollar.value-document.mainform.receive_dollar.value).toFixed(<%=usDlr%>);
//alert("133");
}
function setLessPaymentExRate()
{
   	document.mainform.less_payment_dollar_ex_rate.value=document.mainform.receive_dollar_ex_rate.value;
}
function setLessPaymentDollar()
{
	document.mainform.less_payment_dollar.value=parseFloat(document.mainform.balance_dollar.value-document.mainform.receive_dollar.value).toFixed(<%=usDlr%>);
}
function setLessPaymentLocal()
{
	document.mainform.less_payment_local.value=(document.mainform.less_payment_dollar.value*document.mainform.less_payment_dollar_ex_rate.value);
}
function calcExDiff()
{
	
	var balance_local_amount=(document.mainform.balance_dollar.value)*(document.mainform.balance_dollar_ex_rate.value);
	//alert("balance_local_amount="+balance_local_amount);
	var receive_local_amount=(document.mainform.receive_dollar.value)*parseFloat(document.mainform.receive_dollar_ex_rate.value);
	//alert("receive_local_amount="+receive_local_amount);
	var less_payment_local_amount=document.mainform.less_payment_local.value;
	//alert("less_payment_local_amount="+less_payment_local_amount);
	var bank_charges_local_amount=document.mainform.bank_charges.value;
	//alert("bank_charges_local_amount="+bank_charges_local_amount);
	var ex_gain_loss_local_amount=((parseFloat(receive_local_amount)+parseFloat(less_payment_local_amount))-parseFloat(balance_local_amount));
	//alert("ex_gain_loss_local_amount="+ex_gain_loss_local_amount);	
	
	
	ex_gain_loss_local_amount=(parseFloat(ex_gain_loss_local_amount)-(parseFloat(less_payment_local_amount)+parseFloat(bank_charges_local_amount)));
	
	if(ex_gain_loss_local_amount>0)
	{
		document.mainform.ex_diff.value=ex_gain_loss_local_amount;
		document.getElementById("gain_loss_display").innerHTML="GAIN";
	}
	else
	{
		document.mainform.ex_diff.value=ex_gain_loss_local_amount*(-1);
		document.getElementById("gain_loss_display").innerHTML="LOSS";
	}
}
function CalcBankAmount()
{
	var receive_local_amount=(document.mainform.balance_dollar.value)*parseFloat(document.mainform.receive_dollar_ex_rate.value);

	var less_payment_local_amount=document.mainform.less_payment_local.value;
	var bank_charges_local_amount=document.mainform.bank_charges.value;

    document.mainform.payment_received_bank.value=(parseFloat(receive_local_amount)-(parseFloat(less_payment_local_amount)+parseFloat(bank_charges_local_amount)));

} //CalcBankAmount

//-->
function formOnLoad()
{
	//alert("Hello");
	document.mainform.datevalue.focus();
}

</script>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" OnLoad="formOnLoad();">
<form method='post' name='mainform' action="">
<%
	String party_id="0";

	String str_party_name=""+request.getParameter("party_name");
	//out.println("str_party_name="+str_party_name);
	
	if("null".equals(str_party_name))
	{
		str_party_name="";
		//out.println("236");
	}
	String query_company_id="select companyparty_id from Master_CompanyParty "+
	" where companyparty_name='"+str_party_name+"' and company_id="+company_id;
	pstmt_g = cong.prepareStatement(query_company_id, ResultSet.TYPE_SCROLL_INSENSITIVE,
			ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next()) 	
	{
		party_id=rs_g.getString("companyparty_id");
	} //while()
	pstmt_g.close();
	
	String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 "+
			   "and Company_Id="+company_id+" order by CompanyParty_Name";
	pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,
			ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String companyArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\"";
		} //if
		else
		{
			companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
		} //else
	} //while
	pstmt_g.close();
%>	
	<script language="javascript">
	<%
		out.print("var companyArray=new Array("+companyArray+");");
	%>
	</script>
	
<%
String isParty=request.getParameter("isParty");
//out.println("isParty="+isParty);
if("1".equals(isParty))
{

int testvoucher_id=L.get_master_id(cong,"Voucher");
errLine="114";

String changedate= request.getParameter("changedate");

if(changedate.equals("none"))
{
	changedate = today_string;
}
errLine="123";
String category= request.getParameter("category");

//out.println("party_id="+party_id);
String category1=category;
String condition="";

String adv_local="";
String adv_dollar="";
String party_currencyid=local_currency;
errLine="132";
String ledger_id="";
//out.println("party_id="+party_id);
if("Receive".equals(category))
{
	category1="Sale";
}
if("0".equals(party_id))
{
	party_currency="ALL";
	query="Select count(*) as row_counter from Receive  where Receive_Date < = ? and "+
			"Company_id=? and Purchase=1 and Receive_sell=0 and proactive=0 and Active=1 "+
			"and R_Return=0 and Receive_FromId="+party_id;
	query1="Select * from Receive  where Receive_Date < = ? "+
			"and Company_id=? and Purchase=1 and Receive_sell=0 and proactive=0 "+
			"and Active=1 and R_Return=0 and Receive_FromId="+party_id+" order by Due_Date,Receive_date ,Receive_no";
}
else
{
	query="Select * from Master_companyparty where companyparty_id="+party_id+"";
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		party_currency = rs_g.getString("Transaction_Currency");
		adv_local = rs_g.getString("Sale_AdvanceLocal");
		adv_dollar = rs_g.getString("Sale_AdvanceDollar");
	}
	pstmt_g.close();
	if("0".equals(party_currency))
	{
		party_currencyid="0";
	}
	party_currency="ALL";
	

	query="Select * from Ledger where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=1";
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		ledger_id = rs_g.getString("Ledger_Id");

	}
    pstmt_g.close();

	query="Select count(*) as row_counter from Receive  where Receive_Date <= ?"+
			" and Company_id=?  and Receive_FromId="+party_id+" and Purchase=1 "+
			"and Receive_Sell=0 and proactive=0 and Active=1 and R_Return=0 and Receive_CurrencyId<>"+company_id;

	//out.println("query="+query);
	query1="Select * from Receive  where Receive_Date <= ? and Company_id=?  "+
			"and Receive_FromId="+party_id+" and Purchase=1 and Receive_Sell=0 "+
			"and proactive=0 and Active=1 and R_Return=0 and Receive_CurrencyId<>"+company_id+
			" order by Due_Date,Receive_date ,"+
			" Receive_no";
}
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString (1,""+D);
//	pstmt_g.setString (2,""+D2);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
		n=rs_g.getInt("row_counter");
	} //while
	pstmt_g.close();
	errLine="188";
	counter=n;
	//out.print("<br>210 counter=" +counter);
	//out.print("<br>party_currency=" +party_currency);
	String receive_id[]=new String[counter];
	String receive_no[]=new String[counter];
	String Receive_CurrencyId[]=new String[counter];
	String receive_ex_rate[]=new String[counter];
	String receive_fromid[]=new String[counter];
	String receive_lots[]=new String[counter];
	java.sql.Date receive_date[] = new java.sql.Date[counter];
	java.sql.Date due_date[] = new java.sql.Date[counter];
	float local[] =new float[counter];
	float dollar[] =new float[counter];
	float qty[] =new float[counter];
	float rlocal[] =new float[counter];
	float rdollar[] =new float[counter];
	float plocal[] =new float[counter];
	float pdollar[] =new float[counter];
	float temp_plocal[]=new float[counter];
	float temp_pdollar[]=new float[counter];
	boolean display_flag[]=new boolean[counter];
	double local_total=0; 
	double dollar_total=0; 
	double rlocal_total=0; 
	double rdollar_total=0; 
	double plocal_total=0; 
	double pdollar_total=0; 
	errLine="215";
	float receive_tot=0;
	pstmt_g = cong.prepareStatement(query1);
	pstmt_g.setString (1,""+D);
	//	pstmt_g.setString (2,""+D2);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	n=0;
	while(rs_g.next())
	{
		receive_id[n] =rs_g.getString("Receive_id");		
		receive_no[n]=rs_g.getString("receive_no");
		Receive_CurrencyId[n]=rs_g.getString("Receive_CurrencyId");
		//out.print("<br>265 Receive_CurrencyId["+n+"]="+Receive_CurrencyId[n]);
		receive_ex_rate[n]=rs_g.getString("Exchange_Rate");
		receive_date[n]=rs_g.getDate("Receive_Date");
		receive_lots[n]=rs_g.getString("Receive_Lots");
		qty[n] =rs_g.getFloat("Receive_Quantity");
		local[n] =rs_g.getFloat("Local_Total");
		dollar[n] =rs_g.getFloat("Dollar_Total");
		receive_fromid[n]=rs_g.getString("Receive_FromId");
		due_date[n]=rs_g.getDate("Due_Date");
		n++;
	}
	pstmt_g.close();
	errLine="239";
	int m=0;
	for(int i=0; i<counter; i++)
	{
		query="Select count(*) as counter from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 ";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id[i]); 
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
			int temp_counter=rs_g.getInt("counter");
			m=m+temp_counter;
		}
		pstmt_g.close();
	}//for
	int count=m;
	//out.print("<br>count=" +count);
	String for_headid[]=new String[count];
	float local_amount[] =new float[count];
	float dollar_amount[] =new float[count];
	errLine="259";
	m=0;
	for(int i=0; i<counter; i++)
	{
		query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 ";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id[i]); 
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
			for_headid[m]=rs_g.getString("For_HeadId");
			local_amount[m] =rs_g.getFloat("Local_Amount");
			dollar_amount[m] =rs_g.getFloat("Dollar_Amount");

			m++;
		}
		pstmt_g.close();
	}//for
	int  j=0;
	errLine="295";
for(int i=0; i<counter; i++)
{
	j=0;
	rlocal[i] =0;
	rdollar[i]=0;
	while(j< count)
	{
		if(receive_id[i].equals(for_headid[j]))
		{
			rlocal[i] += local_amount[j];
			rdollar[i] += dollar_amount[j];
		}
		j++;
	}
}//for
errLine="311";
for(int i=0; i<counter; i++)
{
	plocal[i] =local[i] - rlocal[i];
	pdollar[i] =dollar[i]-rdollar[i];
	receive_tot += qty[i];
	local_total += local[i];
	dollar_total += dollar[i];
	rlocal_total +=rlocal[i]; 
	rdollar_total +=rdollar[i]; 
	plocal_total += plocal[i]; 
	pdollar_total += pdollar[i];
}//for
counter++;
errLine="325";
for(int i=0; i<counter-1; i++)
{ 
	if("0".equals(Receive_CurrencyId[i]))
	{
		temp_pdollar[i]=(dollar[i]*(percentage))/100;
		//out.print("<br>352 temp_pdollar["+i+"]="+temp_pdollar[i]);
		if(pdollar[i]<=temp_pdollar[i])
		{
			display_flag[i]=true;
		}
		else
		{
			display_flag[i]=false;
		}
		errLine="355";
	}
	else
	{
		temp_plocal[i]=(local[i]*(percentage))/100;
		if(plocal[i]<=temp_plocal[i])
		{
			display_flag[i]=true;
		}
		else
		{
			display_flag[i]=false;
		}
	//out.print("<br>360 display_flag["+i+"]="+display_flag[i]);
		errLine="361";
	}
} //for
errLine="357";
%>

<script language="JavaScript">
<!--
var global_dollar_balance=0;
function putPending()
{
	
	
	total_balance_dollar=0;
	avg_ex_rate=0;	
	var checked_total=0;
	for(cnt=0;cnt<<%=(counter-1)%>;cnt++)
	{
		
		if(document.mainform.elements["receive"+cnt].checked)
		{
			checked_total=parseFloat(checked_total)+1;
			if(parseFloat(document.mainform.elements["receive_amount"+cnt].value)==0)
			{
				total_balance_dollar=parseFloat(total_balance_dollar)+parseFloat(document.mainform.elements["pending_dollar"+cnt].value);
				document.mainform.elements["receive_amount"+cnt].value=parseFloat(document.mainform.elements["pending_dollar"+cnt].value).toFixed(<%=usDlr%>);
			}
			else
			{
				total_balance_dollar=parseFloat(total_balance_dollar)+parseFloat(document.mainform.elements["receive_amount"+cnt].value);

			}
			avg_ex_rate=avg_ex_rate+parseFloat(document.mainform.elements["exchange_rate"+cnt].value);
			//alert("avg_ex_rate="+avg_ex_rate);
			
		}
		else
		{
			if(parseFloat(document.mainform.elements["receive_amount"+cnt].value)!=0)
			{
					document.mainform.elements["receive_amount"+cnt].value=parseFloat("0.00").toFixed(<%=usDlr%>);
			}
		}
	} //for
	document.mainform.balance_dollar.value=parseFloat(total_balance_dollar).toFixed(<%=usDlr%>);
	document.mainform.receive_dollar.value=document.mainform.balance_dollar.value;
	temp_ex_rate=parseFloat((avg_ex_rate)/checked_total).toFixed(2);
		if(isNaN(temp_ex_rate))
		{	
			document.mainform.balance_dollar_ex_rate.value=parseFloat("0.00").toFixed(2);
		}
		else
		{
			document.mainform.balance_dollar_ex_rate.value=parseFloat(temp_ex_rate).toFixed(2);
		}
	}

function changeAmount(ele_idx,local_ele)
{
	//alert("ele_idx="+ele_idx);
	if(document.mainform.elements["receive"+ele_idx].checked)
	{
		
	//alert("ele_idx="+ele_idx);	
	var new_amount=parseFloat(document.mainform.balance_dollar.value).toFixed(<%=usDlr%>)-parseFloat(local_ele.value).toFixed(<%=usDlr%>);
	document.mainform.balance_dollar.value=parseFloat(new_amount).toFixed(<%=usDlr%>);
	//document.mainform.receive_dollar.value=document.mainform.balance_dollar.value;

	}
}
function checkDateValidity(ele)
{
	checkMe(ele);
}
function checkDate(th)
{
	var r_id=document.mainform.datevalue.value;
	var a=fnCheckDate(r_id,th.name);
	if(a==false)	
			th.focus();
	return a;
}
//-->
</script>

<table border=1 bordercolor=#330000>
<tr>
<td bgcolor=#83B8FA align='center'><font name='Bookman Old Style' color='#FFFFFF'size=6>Export Receipt </font></td>
</tr>
</tr>
<td>
<table  border=1 bordercolor=#FFFFFF   width="100%" cellspacing=1 cellpadding=2 bgcolor=#CBD6FE>

<tr>
	<td width='10%'><label>Date</label></td>
	<td width='20%' colspan=2><input type=text name='datevalue' value='<%=format.format(D)%>' TABINDEX="0" maxlength='10' size='8' OnKeyUp="checkDateValidity(this);" OnBlur="return checkDate(this);" style='border-style:groove' >
</td>
	<td rowspan=7 bgcolor=#E8E7FE>
		<div class='tableContainer' id='data' >
		<table width='100%' class='TABLE' cellspacing=1>
			<thead class='THEAD TD'>
		<tr>
		<td align=left>Select</td>
		<td align=left>No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		
		<td align=left>Transaction <br> Currency</td>
		
		
		<%if("1".equals(party_currency))
		{
		%>
		<!-- <td align=right>Total(<%=local_symbol%>)</td>
		<td align=right>Recd(<%=local_symbol%>)</td> -->
		<td align=right>Pending(<%=local_symbol%>)</td>
		<input type=hidden size=4 name=currency value=local >
		<%}
		else if("0".equals(party_currency)) 
		{%>
		<!-- <td align=right>Total($)</td>
		<td align=right>Recd($)</td> -->
		<td align=right>Pending($)</td>
		<input type=hidden size=4 name=currency value=dollar>
		<%}
		else{
		%>
		<!-- <td align=right>Total(<%=local_symbol%>)</td>
		<td align=right>Recd(<%=local_symbol%>)</td> -->
		<td align=right>Pending(<%=local_symbol%>)</td>
		<!-- <td align=right>Total($)</td>
		<td align=right>Recd($)</td> -->
		<td align=right>Pending($)</td>

		<%}%>
		<td>Recd </td>
		<td>Due Date</td>
		
		<%if("1".equals(party_currency))
		{
		%>
		<td align=right>Total(<%=local_symbol%>)</td>
		<td align=right>Recd(<%=local_symbol%>)</td>
		<!-- <td align=right>Pending(<%=local_symbol%>)</td>
		<input type=hidden size=4 name=currency value=local > -->
		<%}
		else if("0".equals(party_currency)) 
		{%>
		<td align=right>Total($)</td>
		<td align=right>Recd($)</td>
		<!-- <td align=right>Pending($)</td>
		<input type=hidden size=4 name=currency value=dollar> -->
		<%}
		else{
		%>
		<td align=right>Total(<%=local_symbol%>)</td>
		<td align=right>Recd(<%=local_symbol%>)</td>
		<!-- <td align=right>Pending(<%=local_symbol%>)</td> -->
		<td align=right>Total($)</td>
		<td align=right>Recd($)</td>
		<!-- <td align=right>Pending($)</td> -->

		<%}%>
		
		</thead>
		<tbody >
		<input type=hidden name=counter value="<%=counter%>"> 
		<%
		j=1;
		double local_amount_total=0;
		double dollar_amount_total=0;
		//out.println("counter="+counter);
		errLine="414";
		for(int i=0; i<(counter-1); i++)
		{
			if(display_flag[i])	
			{
				errLine="1290";	
		%>
			<input type=hidden name=receive<%=i%> value=yes OnClick='putPending(<%=i%>,"receive<%=i%>"); return calcTotal(this);'>
			<input type=hidden name=receive_id<%=i%> value="<%=receive_id[i]%>"> 
			<input type=hidden name=receive_fromid<%=i%> value="<%=receive_fromid[i]%>"> 
			<!-- code for Ref.No -->
		<% 
			String voucher_id=""+A.getNameCondition(cong,"Voucher","Voucher_Id",
					"where Voucher_No='"+receive_id[i]+"'");
			String refno=""+A.getNameCondition(cong,"Voucher","Ref_No",
					"where Voucher_Id="+voucher_id);
			//out.print("<br>1260 Refno "+refno);
		%>

		<%
		if(Receive_CurrencyId[i].equals("0"))
		{
		%>
			<input type=hidden name="Receive_Currency<%=i%>" value="<%=Receive_CurrencyId[i]%>">	
		<%
		}
		else
		{%>
			<input type=hidden name="Receive_Currency<%=i%>" value="<%=Receive_CurrencyId[i]%>">	
		<%}
		%>

<!-- <td><%//=A.getName("CompanyParty",receive_fromid[i])%>  </td> -->

		<%if("1".equals(party_currency))
		{
		%>
		<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
		<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
		<%}
		else 
		if("0".equals(party_currency)) 
		{%>
			<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
			<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
		<%
		//local_amount_total+=local_amount_total+local[i];	
		//dollar_amount_total+=dollar_amount_total+dollar[i];	
		}
		else
		{
		%>
		<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
		<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
		<%
		//local_amount_total+=local_amount_total+local[i];	
		//dollar_amount_total+=dollar_amount_total+dollar[i];	
		}	
		%>
		<input type=hidden name=receive_amount<%=i%> size=8  OnBlur='return calcTotal()' style="text-align:right" value="0">

		<%
		}//end if display_flag=true
if(!(display_flag[i]))	
{
errLine="1290";	
%>
<tr>
<td class='TD'>
<input type=checkbox name=receive<%=i%> value=yes OnClick='putPending();'>&nbsp;<%=j++%></td>
<input type=hidden name=receive_id<%=i%> value="<%=receive_id[i]%>"> 
<input type=hidden name=exchange_rate<%=i%> value="<%=receive_ex_rate[i]%>"> 
<input type=hidden name=receive_fromid<%=i%> value="<%=receive_fromid[i]%>"> 
<td class='TD'><%=receive_no[i]%></td>
<!-- code for Ref.No -->
<% 
String voucher_id=""+A.getNameCondition(cong,"Voucher","Voucher_Id","where Voucher_No='"+receive_id[i]+"'");
String refno=""+A.getNameCondition(cong,"Voucher","Ref_No","where Voucher_Id="+voucher_id);
//out.print("<br>1260 Refno "+refno);
%>
<!-- <td>&nbsp;<%//=refno%></td> -->
<td class='TD'><%
	if(Receive_CurrencyId[i].equals("0"))
	{
	out.print("US $");%>
	<input type=hidden name="Receive_Currency<%=i%>" value="<%=Receive_CurrencyId[i]%>">	
<%
	}
	else
	{%>
	<%=local_symbol%>
	<input type=hidden name="Receive_Currency<%=i%>" value="<%=Receive_CurrencyId[i]%>">	
<%	}
%></td>

<!-- <td><%//=A.getName("CompanyParty",receive_fromid[i])%>  </td> -->
<!-- <td align=center><%//=format.format(receive_date[i])%></td> -->
<!-- <td align=center class='TD'><%=format.format(due_date[i])%></td> -->
<%if("1".equals(party_currency))
{
%>
<!-- <td align=right class='TD'><%//=str.format(""+local[i],d)%></td>
<td align=right class='TD'><%//=str.format(""+rlocal[i],d)%></td> -->
<td align=right class='TD'><%=str.format(""+plocal[i],d)%></td>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
<td align=center class='TD'><input type=text name=receive_amount<%=i%> size=8  OnBlur='changeAmount(<%=i%>,this);' style="text-align:right" value="0"></td>

<%
}
else 
if("0".equals(party_currency)) 
{
%>
<!-- <td align=right class='TD'><%//=str.format(""+dollar[i],usDlr)%></td>
<td align=right class='TD'><%//=str.format(""+rdollar[i],usDlr)%></td> -->
<td align=right class='TD'><%=str.format(""+pdollar[i],usDlr)%></td>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
<td align=center class='TD'><input type=text name=receive_amount<%=i%> size=8  OnBlur='changeAmount(<%=i%>,this);' style="text-align:right" value="0"></td>
<%
}
else
{
%>
<!-- <td align=right class='TD'><%//=str.format(""+local[i],d)%></td>
<td align=right class='TD'><%//=str.format(""+rlocal[i],d)%></td> -->
<td align=right class='TD'><%=str.format(""+plocal[i],d)%></td>
<!-- <td align=right class='TD'><%//=str.format(""+dollar[i],usDlr)%></td>
<td align=right class='TD'><%//=str.format(""+rdollar[i],usDlr)%></td> -->
<td align=right class='TD'><%=str.format(""+pdollar[i],usDlr)%></td>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+plocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+pdollar[i],usDlr)%>'>
<td align=center class='TD'><input type=text name=receive_amount<%=i%> size=8  OnBlur='changeAmount(<%=i%>,this);' style="text-align:right" value="0"></td>
<%
}
%>
<td align=center class='TD'><%=format.format(due_date[i])%></td>
<%
/**** New Block Of Code ****/
if("1".equals(party_currency))
{
%>
<td align=right class='TD'><%=str.format(""+local[i],d)%></td>
<td align=right class='TD'><%=str.format(""+rlocal[i],d)%></td>

<%
}
else 
if("0".equals(party_currency)) 
{
%>
<td align=right class='TD'><%=str.format(""+dollar[i],usDlr)%></td>
<td align=right class='TD'><%=str.format(""+rdollar[i],usDlr)%></td>
<%
}
else
{
%>
<td align=right class='TD'><%=str.format(""+local[i],d)%></td>
<td align=right class='TD'><%=str.format(""+rlocal[i],d)%></td>
<td align=right class='TD'><%=str.format(""+dollar[i],usDlr)%></td>
<td align=right class='TD'><%=str.format(""+rdollar[i],usDlr)%></td>
<%
}
/**** End Of New Block Of Code ****/
%>

</tr>
<%
}//end if display_flag=false

	local_amount_total+=plocal[i];
	dollar_amount_total+=pdollar[i];

}//for
j=counter-1;		
%>
<%
	
//CVR.loadMasters(conp);	
	double local_closing_sale=0;
	double dollar_closing_sale=0;
	double Opening_RLocalBalance=0;
	double Opening_RDollarBalance=0;
	query=" Select Opening_RLocalBalance,Opening_RDollarBalance from Master_CompanyParty where CompanyParty_Id=".concat(party_id);

	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{		
		Opening_RLocalBalance=rs_g.getDouble("Opening_RLocalBalance");
		Opening_RDollarBalance=rs_g.getDouble("Opening_RDollarBalance");
			
	}
	pstmt_g.close();
	CVR.loadMasters(cong);
	String salesAccLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", 
			" where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=1 and Active=1");

	//out.println("salesAccLedgerId="+salesAccLedgerId);
	String ctaxLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");
	
	List salesList = new ArrayList();
	salesList = CVR.getSalesTransaction(salesAccLedgerId,cong,conp,from_date, 
			to_date,Opening_RLocalBalance,Opening_RDollarBalance,
			company_id,party_id,ctaxLedgerId);
	
	for(int i=0; i<salesList.size(); i++)
	{
		
		customerVendorReportRow row = (customerVendorReportRow)salesList.get(i);

		local_closing_sale += row.getLocalAmt_Dr();
		local_closing_sale -= row.getLocalAmt_Cr();
		
		dollar_closing_sale += row.getDollarAmt_Dr();
		dollar_closing_sale -= row.getDollarAmt_Cr();
		
	} //for
%>


<%if("ALL".equals(party_currency))
{
%> 
<td colspan=3 align=right class='TD'><B>Total</B></td>
<td align=right class='TD'><%=str.mathformat(""+local_amount_total,d)%></td>
<td align=right class='TD'><%=str.mathformat(""+dollar_amount_total,d)%></td>
<%}%> 


<!--<%//if(local_closing_sale>=0)
//{%>
<td align=right class='TD'><%//=str.mathformat(""+(local_closing_sale),d)%>&nbsp;&nbsp;Dr</td>
<%//}else{%>
<td align=right class='TD'><%//=str.mathformat(""+(local_closing_sale)*(-1),d)%>&nbsp;&nbsp;Cr</td>
<%//}%>

<%//if(dollar_closing_sale>=0){%>
<td align=right class='TD'><%//=str.format(""+(dollar_closing_sale),usDlr)%>&nbsp;&nbsp;Dr</td>
<%//}else{%>
<td align=right class='TD'><%//=str.format(""+(dollar_closing_sale)*(-1),usDlr)%>&nbsp;&nbsp;Cr</td>
<%//}%>
-->

<td align=center class='TD'><input type=text name=received_total value='' readonly size=8 
style="background:#9DF4D1" style="text-align:right"> </td>
</tr>
	</tbody>
			
		</table>
		</div>
	</td>
</tr>
<tr>
	<td width='10%'><label>Receipt No</label></td>
	<td width='20%' colspan=2><input type=text name=receipt_no value="<%=Voucher.getAutoNumber(cong,8,"1",company_id)%>" size=4 style='border-style:groove'></td>
</tr>
<tr>
	<td width='10%'><label>Customer</label></td>
	<td width='20%' colspan=2>
	<input type="text" name="party_name" size=20 id="party_name" value="<%=str_party_name%>" onfous="this.select();">
	</td>
	<input type=hidden name="party_id" value="">
		
	
	
</tr>
<tr>
	<td width='10%'>Description</td>
	<td colspan=2><textarea width='20%' rows='4' cols='30' style='border-style:groove'></textarea></td>
</tr>
<tr>
	<td width='10%'><label>Balance Dollar</label></td>
	<td width='10%'><input type=text name='balance_dollar' style='text-align:right;border-style:groove' readonly size=12></td>
	<td width='10%'><label>@</label><input type=text name='balance_dollar_ex_rate' size=6 style='text-align:right;border-style:groove' OnBlur='calcAmount();'></td>
	<input type='hidden' name='amount' value=0>
	<input type='hidden' name='credit_total' value=0>
</tr>
<tr>
	<td width='10%'><label>Received Dollar</label></td>
	<td width='10%'><input type=text name='receive_dollar' style='text-align:right;border-style:groove' OnBlur='CalcLessPaymentDollar();' size=12></td>
	<td width='10%'><label>@</label><input type=text size=6  name='receive_dollar_ex_rate' style='text-align:right;border-style:groove' OnBlur='setLessPaymentExRate();'></td>
	
</tr>
<tr>
	<td width='10%'><label>Less Payment Dol</label></td>
	<td width='10%'><input type=text name='less_payment_dollar' style='text-align:right;border-style:groove' OnBlur='setLessPaymentDollar();' size=12></td>
	<td width='10%'><label>@</label><input type=text size=6 style='text-align:right;border-style:groove' name='less_payment_dollar_ex_rate' OnBlur='setLessPaymentLocal();'></td>
	
</tr>
<tr>
	<td width='10%'><label>Less Payment Rs</label></td>
	<td width='10%'><input type=text name='less_payment_local' style='text-align:right;border-style:groove' onBlur='' size=12></td>
	<td colspan=2><%=A.getArray(cong,"Ledger","less_payment_rs_ledger","",company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td>
	
</tr>
<tr>
	<td width='10%'><label>Bank Charges</label></td>
	<td width='10%'><input type=text name='bank_charges' style='text-align:right;border-style:groove' size=12 OnBlur="CalcBankAmount();"></td>
	<td colspan=2><%=A.getArray(cong,"Ledger","bank_charges_ledger","",company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td>
	
</tr>
<tr>
	<td width='10%'><label>Payment Received Bank</label></td>
	<td width='10%'><input type=text name='payment_received_bank' style='text-align:right;border-style:groove' onBlur='calcExDiff();' size=12></td>
	<td colspan=2><%=A.getMasterArrayAccount(cong,"account_id","",company_id+" and yearend_id="+yearend_id,"Normal") %>
	</td>
	
</tr>
<tr>
	<td width='10%'><label>Exch. Diff</label></td>
	<td width='10%'><input type=text name='ex_diff' style='text-align:right;border-style:groove' size=12></td>
	<td width='10%' colspan=2><label name='gain_loss_display' id='gain_loss_display'></label></td>
	
</tr>
<tr>
	<td  colspan=4 align='center'>
	<input type=Button name=command Value='Save' class='Button1'
	OnClick="calculateMe('subme')";>
	<input type=Submit name=cmd value="Refresh" class='Button1'>
	</td>
</tr>

	<script language="javascript">

			var cobj= new  actb(document.getElementById('party_name'),companyArray);
		
	</script>
</table>
</td>
</tr>
</table>
<input type='hidden' name='ledger_id' value=<%=ledger_id%>>
</form>
</body>
</html>
<% 
C.returnConnection(cong);	
C.returnConnection(conp);	
}
} //try
catch(Exception e170)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.println("<font color=red> FileName : GL_NewParty.jsp <br>Bug No e170 :"+ e170 +"</font>"+"errLine="+errLine);
} //catch(Exception)
} //Default	
%>








