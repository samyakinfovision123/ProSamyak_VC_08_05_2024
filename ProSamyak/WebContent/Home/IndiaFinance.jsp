<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*"  %>
<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<jsp:useBean id="YEF"  class="NipponBean.YearEndFinance" />
<jsp:useBean id="CBOC"  class="NipponBean.CashBankOpeningClosing" />

<% 

ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_g=null;
Connection cong = null;
String errLine="16";
PreparedStatement pstmt_p=null;
String command=request.getParameter("command");
//System.out.println("command="+command);
try	
{	
	//System.out.println("22 conp");
	
	conp=C.getConnection();
	cong=C.getConnection();
	//System.out.println("23 cong");



String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

String local_symbol= I.getLocalSymbol(cong,company_id);

java.sql.Date yearendEndDate = YED.getDate(conp,"Yearend","To_Date", " where yearend_id="+yearend_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String datevalue=""+request.getParameter("datevalue");
//out.println("datevalue="+datevalue);
String from_invoice=""+request.getParameter("from_invoice");
//out.println("from_invoice="+from_invoice);
if("yes".equals(from_invoice))
{
	D=format.getDate(datevalue);
}
String message=request.getParameter("message");
//out.println("<br> message="+message); 
String Party_Name="";
String Party_Id="0";
String flag=request.getParameter("flag");
String Lflag=request.getParameter("Lflag");
String MCPartyId=request.getParameter("MCPartyId");
String TypeValue=request.getParameter("TypeValue");
errLine="40";
//out.print("<br> 34 flag"+flag);
//out.print("<br> 34 MCPartyId"+MCPartyId);
//out.print("<br> 34 TypeValue"+TypeValue);
String Name=request.getParameter("companyparty_name");
if(Name==null)
{
	Name="";
}
if(flag == null)
{
	flag="company";
}
if(Lflag == null)
{
	Lflag="false";
}
if(MCPartyId == null)
{
	MCPartyId="0";
}
//out.print("<br> 51 Lflag"+Lflag);
String lastVchDate=""+request.getParameter("lastVchDate"); 
String today_string= format.format(D);
if("null".equals(lastVchDate))
{
	lastVchDate=""+today_string;
    //out.print("Inside lastVchDate"+lastVchDate);
}
errLine="59";
String currency=request.getParameter("currency");
if(currency == null)
{
	currency="both";
	//out.print("<br> Under if curency"+currency);
}
//out.print("<br> Currency "+currency);
java.sql.Date Dprevious = null;
java.sql.Date D1 =null;
java.sql.Date D2 = null;
java.sql.Date OpDate = null;
int  dd1=0;
int  mm1=0;
int  yy1=0;
int  dd2=0;
int  mm2=0;
int  yy2=0;
//out.print("<br> 46 message"+message);
if(message.equals("Default"))
{
	//out.println("In Default");
	int year=D.getYear();
	year =2004;
	int dd=1;
	int mm=3;
		
	 dd1=D.getDate();
	 mm1=D.getMonth()+1;
	 yy1=D.getYear()+1900;
	 D1 = D;
	
	 OpDate = new java.sql.Date((yy1-1900),(mm1-1),(dd1-1));

	dd2=dd1;
	mm2=mm1;
	yy2=yy1;
	 D2 = D1;
}
else
{
	
	Party_Name=request.getParameter("companyparty_name");
	
	 dd1 =Integer.parseInt(request.getParameter("dd1"));
	 mm1 =Integer.parseInt(request.getParameter("mm1"));
	 yy1 =Integer.parseInt(request.getParameter("yy1"));

	 OpDate = new java.sql.Date((yy1-1900),(mm1-1),(dd1-1));

	 D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);

	 dd2 =Integer.parseInt(request.getParameter("dd2"));
	 mm2 =Integer.parseInt(request.getParameter("mm2"));
	 yy2 =Integer.parseInt(request.getParameter("yy2"));

	 D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	 
	 String Partycondition="where CompanyParty_Name='"+Party_Name+"' and active=1 and company_Id="+company_id;

	Party_Id=A.getNameCondition(conp,"Master_CompanyParty","CompanyParty_Id",Partycondition);
	
	if(Party_Id.equals(""))
	{
		flag="company";
	}
}

	String local_currency= I.getLocalCurrency(conp,company_id);
	
	int  d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

	String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

	java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
%>

<html><head>
<title>Home - Samyak Software -India</title>

<style>
	a{color: white;text-decoration: none}
	.normal{background-color: #00308F;color: white}
	.hover{background-color: black;color: white}
</style>

<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<script language=javascript src="../samyak/samyakyearenddate.js"></script>

<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT">
<META HTTP-EQUIV="Expires" CONTENT="0">

<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language=javascript src="../Samyak/Samyakmultidate.js"></script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<SCRIPT language=javascript src="../Samyak/stockdate.js"></script>
<SCRIPT language=javascript src="../Samyak/SamyakYearEndDate.js"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language="javascript" src="../Samyak/actb.js"></script>
<script language="javascript" src="../Samyak/common.js"></script>
<script language="javascript" src="../Samyak/getId.js"></script>
<script language="javascript" src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<script language="javascript">
<%
	
	String companyArray = "";
	
	String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                  ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\"";
		}
		else
		{
			companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
		}
	}
	pstmt_g.close();
//	out.print("var companyArray=new Array("+companyArray+");");
%>

function functionCall()
{
		document.mainform.From.focus();
}

function setDates()	
{
	document.mainform.toDate.value=document.mainform.fromDate.value;
	document.mainform.datevalue.value=document.mainform.fromDate.value;

} //setDates()

function setDates2()	
{
	document.mainform.fromDate.value=document.mainform.datevalue.value;
	document.mainform.toDate.value=document.mainform.datevalue.value;
} //setDates()

function tb1(str)
{
	window.open(str,"bottom", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=no"]);
}
</script>

</head>

<body background="../Buttons/BGCOLOR.JPG" onLoad="functionCall()" >

<form name="mainform" action="IndiaFinance.jsp"  method=post >

<!-- <input type=hidden name=currency value="<%//=currency%>"> -->

<%	
		double totalLocalOpening=0;
		double totalDollarOpening=0;
		double totalDollarClosing=0;
		double totalLocalClosing=0;
		String msgLocalOpeningDrCr="Dr";
		String  msgDollarOpeningDrCr="Dr";
		String msgLocalClosingDrCr="Dr";
		String msgDollarClosingDrCr="Dr";
		
		Vector openingLocal=new Vector();
		Vector openingDollar=new Vector();
		Vector openingDrCr=new Vector();
		Vector openingCashBank=new Vector();
		
		Vector closingLocal=new Vector();
		Vector closingDollar=new Vector();
		Vector closingDrCr=new Vector();
		Vector closingCashBank=new Vector();
		
		if("company".equals(flag))
		{

			String reportyearend_id = YED.returnYearEndId(cong , pstmt_g, rs_g, D1, company_id);//get YearEnd_id from table YearEnd
			String accountid="";
			String account_name="";
			//int d=2;
			String  query1 ="Select account_id,account_name from Master_Account where AccountType_Id IN (1, 6)and  company_Id="+company_id+" and displayInEntryModule=?";
			pstmt_g=cong.prepareStatement(query1);
			pstmt_g.setBoolean(1,true);
			rs_g=pstmt_g.executeQuery();
			while(rs_g.next())
			{
				//out.print("<br> OpDate"+OpDate);
				accountid=rs_g.getString("account_id");
				account_name=rs_g.getString("account_name");
				String bankclosing_amt= YEF.ClosingBankBalance(cong,""+accountid,company_id,OpDate,d,reportyearend_id);

				String LTrans_DbCrTotal= ""+YEF.ClosingBankBalanceDollar(cong,""+accountid,company_id,OpDate,d,reportyearend_id);

				StringTokenizer Lst = new StringTokenizer(LTrans_DbCrTotal,"/");
				String LTrans_Dbtotal = (String)Lst.nextElement();
				String LTrans_Crtotal = ""+(String)Lst.nextElement();
				double opening_localbalance= str.mathformat(Double.parseDouble(LTrans_Dbtotal),d);
				double opening_dollarbalance= str.mathformat(Double.parseDouble(LTrans_Crtotal),d); 
				
				
				if(totalLocalOpening >= 0)
				{
					msgLocalOpeningDrCr="Dr";
				}else
				{
					msgLocalOpeningDrCr="Cr";
				}
				if(totalDollarOpening >= 0)
				{
					msgDollarOpeningDrCr="Dr";
				}else
				{
					msgDollarOpeningDrCr="Cr";
				}

				//out.print (" 314 <br> Opening Local Balance"+opening_localbalance);

				//out.print ("315 <br> Opening Dollar Balance"+opening_dollarbalance);
				if(currency.equals("local"))
				{
					totalLocalOpening= totalLocalOpening +opening_localbalance;
					openingLocal.add(opening_localbalance);
					openingCashBank.add(account_name);
					//out.println("255 opening_localbalance="+opening_localbalance);
					if(opening_localbalance>=0)
						openingDrCr.add("Dr");
					else
						openingDrCr.add("Cr");
				
				}else if(currency.equals("dollar"))
				{
					totalDollarOpening = totalDollarOpening +opening_dollarbalance;
					openingDollar.add(opening_dollarbalance);
					openingCashBank.add(account_name);
					if(opening_dollarbalance>=0)
						openingDrCr.add("Dr");
					else
						openingDrCr.add("Cr");

				}else if(currency.equals("both"))
				{
					totalLocalOpening= totalLocalOpening +opening_localbalance;
					totalDollarOpening = totalDollarOpening +opening_dollarbalance;
					openingLocal.add(opening_localbalance);
					openingDollar.add(opening_dollarbalance);
					openingCashBank.add(account_name);
					if(opening_localbalance>=0)
						openingDrCr.add("Dr");
					else
						openingDrCr.add("Cr");
					
				}

				double localClosinBalance=0;
				double dollarClosinBalance=0;
				//double localClosinBalance=0;

				String ClosingBalance=CBOC.getcashBankOpeningClosing(cong,conp,accountid,OpDate,company_id,currency,"",D2,reportyearend_id);
				//out.print("");
				if(currency.equals("local"))
				{
					localClosinBalance =Double.parseDouble(ClosingBalance);
					totalLocalClosing = totalLocalClosing + localClosinBalance;
					
					closingLocal.add(localClosinBalance);
					closingCashBank.add(account_name);
					//out.print("<br> 337 localClosinBalance"+localClosinBalance);
					if(localClosinBalance>=0)
						closingDrCr.add("Dr");
					else
						closingDrCr.add("Cr");
				
				}else if(currency.equals("dollar"))
				{
					dollarClosinBalance =Double.parseDouble(ClosingBalance);
					//out.print("<br> 341 dollarClosinBalance"+dollarClosinBalance);
					totalDollarClosing = totalDollarClosing + dollarClosinBalance;
					closingDollar.add(dollarClosinBalance);
					closingCashBank.add(account_name);
					if(dollarClosinBalance>=0)
						closingDrCr.add("Dr");
					else
						closingDrCr.add("Cr");
				}else if(currency.equals("both"))
				{
		
					StringTokenizer closing = new StringTokenizer(ClosingBalance,"#");
					localClosinBalance=Double.parseDouble((String)closing.nextElement());
					dollarClosinBalance=Double.parseDouble((String)closing.nextElement());
					totalLocalClosing = totalLocalClosing + localClosinBalance;
					totalDollarClosing = totalDollarClosing + dollarClosinBalance;
					//out.print("<br> 348 localClosinBalance"+localClosinBalance);
					//out.print("<br> 349 dollarClosinBalance"+dollarClosinBalance);
					closingLocal.add(localClosinBalance);
					closingDollar.add(dollarClosinBalance);
					closingCashBank.add(account_name);
					if(localClosinBalance>=0)
						closingDrCr.add("Dr");
					else
						closingDrCr.add("Cr");
				}
			

			}//while()....

			if(totalLocalClosing >= 0)
			{
				msgLocalClosingDrCr="Dr";
			}
			else
			{
				msgLocalClosingDrCr="Cr";
			}
			if(totalDollarClosing >= 0)
			{
				msgDollarClosingDrCr="Dr";
			}
			else
			{
				msgDollarClosingDrCr="Cr";
			}

	
		}
%>
	

<!-- <script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.fromDate, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'  onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script> <!-- Date --> 

	<input type=hidden name='fromDate' size=8 maxlength=10 value="<%=format.format(D1)%>" onBlur="setDates();return  fnCheckMultiDate(this,this.name);" OnKeyUp="checkMe(this);" >

<% lastVchDate=format.format(D1); %>
<!--  <input type=text name="fromDate" size=8 maxlength=10 value="<%=format.format(D1)%>"> -->

<!-- <script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.toDate, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script> <!-- Date -->  

	<input type=hidden name='toDate' size=8 maxlength=10 value="<%=format.format(D2)%>" OnKeyUp="checkMe(this);" OnBlur='return  fnCheckMultiDate(this,this.name);'>



<!--  <input type=text name="toDate" size=8 maxlength=10 value="<%=format.format(D2)%>"> -->
	 
	
	
	<input type=hidden onfocus="this.select()" name=companyparty_name value="<%=Name%>"   id=companyparty_name autocomplete=off>



<!-- 		<a href="javascript:tb1('../Master/EditCompanyPartyAccount.jsp?command=edit&message=masters')" >
	<img src="../Buttons/add.jpg" height="10" width="10" target='bottom'>
</a> -->
		<script language="javascript">
		
			var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
		
		</script>	
<!-- onkeyup='Test()' -->
<script language="javascript">
	
		function callme()
		{
			//alert("callme");
			var splidate=new Array();
			var splidate1=new Array();
			
			var newDate=document.mainform.fromDate.value;
			//alert(newDate);
			var newDate1=document.mainform.toDate.value;

			//alert(newDate);
			 spliDate=newDate.split("/");
			 spliDate1=newDate1.split("/");

			document.mainform.dd1.value=spliDate[0];
			document.mainform.mm1.value=spliDate[1];
			//alert(document.mainform.mm1.value);
			document.mainform.yy1.value=spliDate[2];
			document.mainform.dd2.value=spliDate1[0];
			document.mainform.mm2.value=spliDate1[1];
			document.mainform.yy2.value=spliDate1[2];
			//alert(document.mainform.mm1.value);
			var companyName=document.mainform.companyparty_name.value;
			//alert(companyName);
			if(companyName == "")
			{
				var cname="company";
				document.mainform.flag.value=cname;
			}
			else
			{
				var cname="party";
				document.mainform.flag.value=cname;

			}

			document.mainform.action="IndiaFinance.jsp?message=hello";
			document.mainform.submit();
		}
		//var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray); 
	
	</script>
		

<!-- 	<td width="37%">&nbsp;&nbsp;&nbsp;<B>Currency : </b>&nbsp;
			<input type="radio" name="currency"  value="local" > Local</input>
			<input type="radio" name="currency"  value="dollar"> Dollar</input>
			<input type="radio" name="currency" value="both" checked>Both</input>
			</td> -->
	<!-- <td><Input type=button name=GO value=GO onclick="callme()"></td> -->
	<!-- <td>4</td> -->


	<input type=hidden name=currency value="both">




<table border=1 width="100%" bordercolor=#660033 background=#E1E1FF >
	
<tr bgcolor=#E1E1FF>
<td>
	<table border=1 bordercolor=#660033 background=#E1E1FF valign=top>
	
	<tr bgcolor=#E1E1FF>
	<%
	String redirect_message=request.getParameter("redirect_message");
	if(redirect_message==null)
	{%>
		
	<%}
	else
	{%>
	<td colspan=5 align=center><%=redirect_message%></td>
	<%}
	%>
	</tr>
	







<tr width='400' bgcolor=#E1E1FF>
<td colspan=1>
	<script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script> <!-- Date --> 
	<%if(redirect_message==null){%>
	<input type=text name='datevalue' size=8 maxlength=10 value="<%=lastVchDate%>" OnKeyUp="checkMe(this);" OnBlur='setDates2(); return  fnCheckMultiDate(this,this.name);' TABINDEX="1">
	<%}else
	{

	String dvalue=request.getParameter("datevalue");	
	%>
	<input type=text name='datevalue' size=8 maxlength=10 value="<%=dvalue%>" OnKeyUp="checkMe(this);" OnBlur='setDates(); return  fnCheckMultiDate(this,this.name);' TABINDEX="1">
	<%}%>	
	<%//out.print("<br> 860 lastVchDate = "+lastVchDate);%>
	
	
	&nbsp;&nbsp;<input type=submit name=command value=GO class='buttong'    onmouseout="this.className='buttong';" onclick="callme()" onmouseover="this.className='buttong_over';" TABINDEX="2"> 
	
	
	
	</td>	
	
	<td colspan=3><B>Currency : </b>&nbsp;
	<input type="radio" name="currency1" id=1 value="local" checked TABINDEX="3" OnClick="document.mainform.closing_balance.value=document.mainform.from_local_closing.value;document.mainform.to_closing_balance.value=document.mainform.to_local_closing.value;"> <b>Local</b></input>
	<input type="radio" name="currency1" id=2 value="dollar" TABINDEX="3" OnClick="document.mainform.closing_balance.value=document.mainform.from_dollar_closing.value;document.mainform.to_closing_balance.value=document.mainform.to_dollar_closing.value;"> <b>Dollar</b></input>

	<b>Exchange Rate/$ </b><font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>' onblur="CalcExRateAmount();validate(this,2)"
	 style="text-align:right" TABINDEX="4"></td> 

	<td colspan=2>
			<b><input type=Button name='Settlement_Old' value='Settlement'	 OnClick='openForSettlement()' style='border:none'></b>
		
			<b><input type=Button name='Set_Off_Journal' value='Set_Off_Journal' OnClick='openForSetOffJournal()' style='border:none;width:180'></b>
		</td>
</tr>
<tr width='400' bgcolor=#E1E1FF>
<%
	int j=0;
	int i=0;
	int count=0;
	String AccountArray="";
	%>

	<%
	if("company".equals(flag))
	{
	%>
		
		<td valign=top> <b>Perticular 1 </b>
		
		<a href="javascript:tb1('../Master/NewCompanyPartyAccount.jsp?message=Default')" >
	<img src="../Buttons/add.jpg" height="10" width="10" target='bottom'>
	</a>
		
		
		<br>
		<INPUT type=text name='From' id='From' size=15 TABINDEX="5" autocomplete=off Onblur='getIdByName(this.value,this.name,document.mainform.From_Ledger,<%=company_id%>,document.mainform.datevalue.value,document.mainform.currency1[0].checked)' >
		
		<input type=hidden name='From_Ledger' value='0'> 
		
		<input type=text name=closing_balance value="" size=10 style="text-align:right;font-weight:bold;background-color:#E1E1FF;border-style:none" readonly>
		
		<input type=hidden name='from_local_closing' value=0>
		<input type=hidden name='from_dollar_closing' value=0>
		</td>
		<script language="javascript">
		function setFromLedgerValue(from_ledger)
		{
			document.mainform.From_Ledger.value=from_ledger;
			l_type1=(document.mainform.sub_ledgers.options[document.mainform.sub_ledgers.selectedIndex].text);
			
			//alert("l_type1="+l_type1);
			if(l_type1=="Sale")
			{
				//alert("Sale");
				document.mainform.drcr.options[1].selected=true;
				document.mainform.ledger_type.value="1";
				//document.mainform.drcr.value=
				//document.mainform.drcr.disabled=true;
			} //Sale
			if(l_type1=="Purchase")
			{
				document.mainform.drcr.options[0].selected=true;
				document.mainform.ledger_type.value="2";
			} //Purchase
			if(l_type1=="Other")
			{
				document.mainform.drcr.disabled=false;
				document.mainform.ledger_type.value="4";
			} //Other
		}
		function setToLedgerValue(to_ledger)
		{
			document.mainform.To_Ledger.value=to_ledger;
			//document.mainform.To_Ledger.focus();
			//alert(document.mainform.From_Ledger.value);
		}
		<%
			String companyArray_temp ="";
			companyArray="";
			companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Company_Id="+company_id+" order by CompanyParty_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			companyQuery = "select Ledger_Name from Ledger where Active=1 and For_Head<>14 and Company_Id="+company_id+" and ParentCompanyParty_Id=0 order by Ledger_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Ledger_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Ledger_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			companyQuery = "select Account_Name from Master_Account where Active=1 and accounttype_id in(1,6) and  Company_Id="+company_id+" order by Account_Name,Account_Id";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\"";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			int len=companyArray_temp.length();
			String companyArray_tokenizer=companyArray_temp.substring(1,(len-1));
			String companyArray_sort[]=companyArray_tokenizer.split("\",\"");
			java.util.Arrays.sort(companyArray_sort,java.text.Collator.getInstance());
			
			for(int cnt=0;cnt<companyArray_sort.length;cnt++)
			{
				if(cnt==0)
				{
					companyArray=companyArray+"\""+companyArray_sort[cnt];
					
				}
				if(cnt==(companyArray_sort.length-1))
				{
					companyArray=companyArray+companyArray_sort[cnt]+"\"";
					
					break;
				}
				if(!(cnt==0)&&!(cnt==(companyArray_sort.length-1)))
				{
					if(cnt==1)
					{
					companyArray=companyArray+"\",\""+companyArray_sort[cnt]+"\",\"";
					}
					else
					{
					companyArray=companyArray+companyArray_sort[cnt]+"\",\"";
					
					}	
						
					
				}
			}
			out.print("var companyArray=new Array("+companyArray+");");
		%>
		</script>
		</td>
		<script language="javascript">
			var companyobj = new  actb(document.getElementById('From'), companyArray);	
		</script>
		<input type="hidden" name="from_id" value="0">
		<!-- onChange="callType()" -->
		<td valign=top><b>Type</b><br>
			<select name="sub_ledgers" id="sub_ledgers" style="width:100;font-size:12;" OnBlur="setFromLedgerValue(this.value)" TABINDEX="6">
			</select>
		<input type=hidden name='ledger_type' id='ledger_type'>
		<select name=drcr TABINDEX="7">
			<option value=0>Dr</option>
			<option value=1 selected>Cr</option>
		</select>
			</td>
		
	
	<% if(Lflag.equals("true")|| Lflag.equals("Type")){ %>
		<input type=hidden name="NewMCParty_Id" value="<%=MCPartyId%>">
		
	<%}
	if(Lflag.equals("Type"))
	{
		String LedQuery="";
		String NewLedger_Id="";
		if(TypeValue.equals("0"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId !="+MCPartyId;
		}else if(TypeValue.equals("1"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId ="+MCPartyId+" and Ledger_Type=1";

		}else if(TypeValue.equals("2"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId ="+MCPartyId+" and Ledger_Type=2 and Active=1";

		}

		pstmt_g = cong.prepareStatement(LedQuery);
		rs_g = pstmt_g.executeQuery();	
		j=0;
		String TempLedger_Id="";
		while(rs_g.next())
		{
			NewLedger_Id=rs_g.getString("Ledger_Id");
			TempLedger_Id = "Led"+NewLedger_Id;
			//out.print("<br> TempLedger_Id"+TempLedger_Id);

		}
		pstmt_g.close();
		%>
			<input type=hidden name="Ledger_Id" value="<%=TempLedger_Id%>">

		<%


	}else if(Lflag.equals("false"))
	{
		%>
		<input type=hidden name="Ledger_Id" value="<%//=%>"> 
	<%}

	%>
	
	
		
	
	<td valign=top><b>Local Amount :</b><br><input type=text name=local_amount value="0" size=10 style="text-align:right" OnBlur="CalcExRateLocalAmount()" TABINDEX="8"></td>

	<td valign=top ><b>Dollar Amount :<br></b><input type=text name=dollar_amount value="0" size=10 style="text-align:right" OnBlur="CalcExRateDollarAmount()" TABINDEX="9"></td>	

	
	<td valign=top><b>Perticular 2</b>
	<br>
	<Input type="text" name="To" id="To" size="15" value="Cash"
	OnBlur='getIdByName(this.value,this.name,document.mainform.To_Ledger,<%=company_id%>,document.mainform.datevalue.value,document.mainform.currency1[0].checked)' autocomplete=off TABINDEX="10">
	<input type='hidden' name='To_Ledger' value='0'>
	<input type=text name=to_closing_balance value="" size=10 style="text-align:right;font-weight:bold;background-color:#E1E1FF;border-style:none" readonly>
		
		<input type=hidden name='to_local_closing' value=0>
		<input type=hidden name='to_dollar_closing' value=0>
	</td>	
	<td valign=top><b>Type</b><br>
		<select name="sub_ledgers1" id="sub_ledgers1" style="width:100;font-size:12;" OnBlur="setToLedgerValue(this.value)" TABINDEX="11">	
	</td>
		<script language="javascript">
					var companyobj = new  actb(document.getElementById('To'), companyArray);	
		</script>
<%
	}else 
	{
		
		////New Added /////////////
		%>
		<td><b>Perticular 1</b>
		
		<a href="javascript:tb1('../Master/NewCompanyPartyAccount.jsp?message=Default')" >
	<img src="../Buttons/add.jpg" height="10" width="10" target='bottom'>
	</a>

		
		<br>
		<INPUT type=text name='From' id='From' size=12 TABINDEX="5" autocomplete=off Onblur='getIdByName(this.value,this.name,document.mainform.From_Ledger,<%=company_id%>,document.mainform.datevalue.value,document.mainform.currency1[0].checked)' >
		<input type=hidden name='From_Ledger' value='0'> 
		
		<input type=text name=closing_balance value="" size=10 style="text-align:right;font-weight:bold;background-color:#E1E1FF;border-style:none" readonly>
		
		<input type=hidden name='from_local_closing' value=0>
		<input type=hidden name='from_dollar_closing' value=0>
		
		<script language="javascript">
		
		function setFromLedgerValue(from_ledger)
		{
			document.mainform.From_Ledger.value=from_ledger;
			//alert(document.mainform.From_Ledger.value);
			l_type1=(document.mainform.sub_ledgers.options[document.mainform.sub_ledgers.selectedIndex].text);
			
			//alert("l_type1="+l_type1);
			if(l_type1=="Sale")
			{
				//alert("Sale");
				document.mainform.drcr.options[1].selected=true;
				document.mainform.ledger_type.value="1";
			} //Sale
			if(l_type1=="Purchase")
			{
				document.mainform.drcr.options[0].selected=true;
				document.mainform.ledger_type.value="2";
			} //Purchase
			if(l_type1=="Other")
			{
				document.mainform.drcr.disabled=false;
				document.mainform.ledger_type.value="4";
			} //Other
		
		
		}
		<%
			String companyArray_temp ="";
			companyArray="";
			companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and CompanyParty_Id="+Party_Id+" and Company_Id="+company_id+" order by CompanyParty_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			companyQuery = "select Ledger_Name from Ledger where Active=1 and For_Head<>14 and Company_Id="+company_id+" and ParentCompanyParty_Id=0 order by Ledger_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Ledger_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Ledger_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			companyQuery = "select Account_Name from Master_Account where Active=1 and accounttype_id in(1,6) and  Company_Id="+company_id+" order by Account_Name,Account_Id";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\"";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			int len=companyArray_temp.length();
			String companyArray_tokenizer=companyArray_temp.substring(1,(len-1));
			String companyArray_sort[]=companyArray_tokenizer.split("\",\"");
			java.util.Arrays.sort(companyArray_sort,java.text.Collator.getInstance());
			
			for(int cnt=0;cnt<companyArray_sort.length;cnt++)
			{
				if(cnt==0)
				{
					companyArray=companyArray+"\""+companyArray_sort[cnt];
					
				}
				if(cnt==(companyArray_sort.length-1))
				{
					companyArray=companyArray+companyArray_sort[cnt]+"\"";
					
					break;
				}
				if(!(cnt==0)&&!(cnt==(companyArray_sort.length-1)))
				{
					if(cnt==1)
					{
					companyArray=companyArray+"\",\""+companyArray_sort[cnt]+"\",\"";
					}
					else
					{
					companyArray=companyArray+companyArray_sort[cnt]+"\",\"";
					
					}	
						
					
				}
			}
			out.print("var companyArray=new Array("+companyArray+");");
		%>
		</script>
		</td>
			<script language="javascript">
					var companyobj = new  actb(document.getElementById('From'), companyArray);	
			</script>
		<input type="hidden" name="from_id" value="0">
		<!-- onChange="callType()" -->
		<td><b>Type</b><br>
		<select name="sub_ledgers" id="sub_ledgers" style="width:100;font-size:12;" OnBlur="setFromLedgerValue(this.value)" TABINDEX="6">
			
		</select>
		<input type=hidden name='ledger_type' id='ledger_type'>
		
	<% if(Lflag.equals("true")|| Lflag.equals("Type")){ %>
		<input type=hidden name="NewMCParty_Id" value="<%=MCPartyId%>">
		
	<%}
	if(Lflag.equals("Type"))
	{
		String LedQuery="";
		String NewLedger_Id="";
		if(TypeValue.equals("0"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId !="+MCPartyId;
		}else if(TypeValue.equals("1"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId ="+MCPartyId+" and Ledger_Type=1";

		}else if(TypeValue.equals("2"))
		{
			LedQuery="select Ledger_Id from ledger where parentCompanyParty_Id="+MCPartyId+"and For_HeadId ="+MCPartyId+" and Ledger_Type=2 and Active=1";

		}

		pstmt_g = cong.prepareStatement(LedQuery);
		rs_g = pstmt_g.executeQuery();	
		j=0;
		String TempLedger_Id="";
		while(rs_g.next())
		{
			NewLedger_Id=rs_g.getString("Ledger_Id");
			TempLedger_Id = "Led"+NewLedger_Id;
			//out.print("<br> TempLedger_Id"+TempLedger_Id);

		}
		pstmt_g.close();
		%>
		<input type=hidden name="Ledger_Id" value="<%=TempLedger_Id%>">
		<%
		}
	else if(Lflag.equals("false"))
	{
		%>
		<input type=hidden name="Ledger_Id" value="<%//=%>"> 
	<%}

	%>
	
		<select name=drcr TABINDEX="7">
			<option value=0>Dr</option>
			<option value=1 selected>Cr</option>
		</select>
	</td>
	<td  ><b>Local Amount :</b><br><input type=text name=local_amount value="0" size=10 style="text-align:right" OnBlur="CalcExRateLocalAmount()" TABINDEX="8"></td>

	<td  ><b>Dollar Amount :</b><br><input type=text name=dollar_amount value="0" size=10 style="text-align:right" OnBlur="CalcExRateDollarAmount()" TABINDEX="9"></td>	

	
	<td ><b>Perticular 2</b><br>
		
	<Input type="text" name="To" id="To" size="12" value=""
	OnBlur='getIdByName(this.value,this.name,document.mainform.To_Ledger,<%=company_id%>,document.mainform.datevalue.value,document.mainform.currency1[0].checked)' autocomplete=off TABINDEX="10">
	<input type='hidden' name='To_Ledger' value='0'>
	<input type=text name=to_closing_balance value="" size=10 style="text-align:right;font-weight:bold;background-color:#E1E1FF;border-style:none" readonly>
		
		<input type=hidden name='to_local_closing' value=0>
		<input type=hidden name='to_dollar_closing' value=0>
	</td>
	<td ><b>Type</b>
		<select name="sub_ledgers1" id="sub_ledgers1" style="width:100;font-size:12;" OnBlur="setToLedgerValue(this.value)" TABINDEX="11">	
	</td>
	<script language="javascript">
		var companyobj = new  actb(document.getElementById('To'), companyArray);	
	</script>

<%
	}
%>
<script language="javascript">
var flag=document.mainform.flag.value;
//alert("h1"+flag);
	
	
if(flag == "party")
{
		function itemValue(tempLocalOpening,LocalclosingBalance,s1,s2)
		{
			var localOpeBalDr=tempLocalOpening;
			var localCloBal=LocalclosingBalance;

		document.mainform.partyLocalOpeningCredit.value=s1;
		document.mainform.partyLocalClosingCredit.value=s2;
		 if(localOpeBalDr != "0")
			{
				//alert('under if');
				document.mainform.partyLocalOpening.value=tempLocalOpening.toFixed(2);
				

				
			}
			
			if(localCloBal != "0")
			{
				document.mainform.partyLocalClosing.value=LocalclosingBalance.toFixed(2);
				
			}

		}
		
		
		function itemValue1(tempLocalOpening,LocalclosingBalance,tempDollarOpening,DollarclosingBalance,s1,s2)
		{
			//alert("S1="+s1);
			//alert("S2="+s2);

			document.mainform.partyLocalOpeningCredit.value=s1;
			document.mainform.partyLocalClosingCredit.value=s2;
			//alert("Company s2"+s2);
			var localOpeBalDr=tempLocalOpening;
			
			var localOpeBalCr=tempDollarOpening;
			var localCloBal=LocalclosingBalance;
			var localCloBal1=DollarclosingBalance;
			//alert('DollarclosingBalance'+DollarclosingBalance);
			document.mainform.partyBothLocalOpening.value=tempLocalOpening
			document.mainform.partyBothDollarOpening.value=tempDollarOpening
			document.mainform.partyBothLocalClosing.value=LocalclosingBalance
			document.mainform.partyBothDollarClosing.value=DollarclosingBalance
	}

} //if(flag == "party")
 
function openForSettlement()
{
	var str="../Finance/SalesReceipt1.jsp?command=Default&message=Default&changedate=none";

	window.open(str,"finance_right", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
} //openForSettlement
function openForSetOffJournal()
{
	var str="../Finance/SetOffJournal.jsp?command=Default&message=Default";
	window.open(str,"finance_right", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);

} //openForSettlement
function SaveFunction()
{
	var v1=document.mainform.From_Ledger.value;
	var v2=document.mainform.To_Ledger.value;
	//alert("v1="+v1);
	//alert("v2="+v2);
	var led=new Array();
	var led1=new Array();
	led=v1.split("#");
	led1=v2.split("#");
	var Ledger=led[0];
	var Ledger_Id=led[1];
	var Ledger1=led1[0];
	var Ledger1_Id=led1[1];
	var LedegerTyPeName="ltype"+Ledger_Id;
	var LedegerTyPeName1="ltype"+Ledger1_Id;
	//alert(Ledger);
	//alert(Ledger1);
	
	if(v1 == v2)
	{
		alert("Both party are same plz select another party..");
		return false;
	} //if(v1 == v2)
	else
	{
		if(v1==0)
		{
			alert(" For  Plz Select ProperParty");
			return false;
		} //if(v1==0)
		if(v2==0)
		{
			alert(" For  Plz Select ProperParty");
			return false;
		} //if(v2==0)
		if (Ledger == Ledger1)
		{
			if(Ledger == "Led")
			{
					document.mainform.action="../Finance/IndiaFinanceUpdate.jsp?command=Update";
					document.mainform.submit();
					return true;
			
			} //if(Ledger == "Led")
			if(Ledger == "Bank")
			{
					document.mainform.action="../Finance/IndiaFinanceUpdate.jsp?command=Update";
					document.mainform.submit();
					return true;

			} //if(Ledger == "Bank")
			if(Ledger == "Party")
			{
					//alert("Bank");
					document.mainform.action="../Finance/IndiaFinanceUpdate.jsp?command=Update";
					document.mainform.submit();
					return true;

			} //if(Ledger == "Party")


		} //if (Ledger == Ledger1)
		else
		{
						
			if(document.mainform.local_amount.value == 0)
			{
				alert("Plz Insert some Amount..");
				return false;
			}
			else
			{	
				document.mainform.action="../Finance/IndiaFinanceUpdate.jsp?command=Update&flag="+flag;
				document.mainform.submit();
				return true;
			}
		}
	} //else of if(v1 == v2)
} //saveFunction
function CalcExRateDollarAmount()
{
	if(document.mainform.currency1[1].checked)
	{
		var local_amt=document.mainform.dollar_amount.value*document.mainform.exchange_rate.value;
		document.mainform.local_amount.value=local_amt.toFixed(3);
	}
} //CalcExRateDollarAmount()
function CalcExRateLocalAmount()
{
	if(document.mainform.currency1[0].checked)
	{
		var dollar_amt=document.mainform.local_amount.value/document.mainform.exchange_rate.value;
		document.mainform.dollar_amount.value=dollar_amt.toFixed(2);
	}
} //CalcExRateLocalAmount()

</script>


 <table border=0 bordercolor=#660033 valign=top > 
 
	
	<input type=hidden name="ref_no" value=" " size=8 style="text-align:right" TABINDEX="12">
	
	<input type=hidden name="remarks1" value="" size=8 style="text-align:right" TABINDEX="13">		
	
	<input type=hidden name="remarks2" value="" size=8 style="text-align:right"
	TABINDEX="14">
	

<!--  New Row -->
	
	<tr bgcolor=#E1E1FF>
		<td>Settlement <input type=checkbox name=settlement value=settlement TABINDEX="11"></td>
		
		
		<td colspan=2><b>Narration	:</b><input type=text name="description"  size=50 TABINDEX="12" value="">
		</td>
		
	</tr>

	<tr>
</table>	
		<center>
		<input type=Button name=command value=SAVE class='button1'   onmouseover="this.className='button1_over';"  onmouseout="this.className='button1';" onclick="return SaveFunction()" TABINDEX="13"> 
		</center>
</td>
</tr>
</table>




















<center>
<table border=1 width="100%" bordercolor=#660033>
<tr>
	<td colspan=1 align=center><B>Opening Balance</B></td>
	<td colspan=1 align=center><B>Closing Balance</B></td>
</tr>

<tr>
	
	<%
		if("company".equals(flag))
		{
	%>
			
	<%
		if(currency.equals("local"))
		{
	%>
		<table border=1 bordercolor=Blue>
			<%for(int idx=0;idx<openingLocal.size();idx++)
				{	
				Double d1=(Double)openingLocal.get(idx);	
				double temp_op_local=d1.doubleValue();
				if(temp_op_local!=0){%>
				<tr><td align=left><%=(String)openingCashBank.get(idx)%></td>
				<%if(temp_op_local>0){%>	
				<td align=right><%=temp_op_local%></td>
				<%}else{%>
				<td align=right><%=(temp_op_local*(-1))%></td>
				<%}%>	
				<td align=right><%=" "+(String)openingDrCr.get(idx)%></td>
				<tr>	
				<%}}%>
			</table>
			</td>
			
	<%
			}
			if(currency.equals("dollar"))
			{
%>	
		<td>	
				
			<table border=1 bordercolor=#660000>
				
			<%for(int idx=0;idx<openingDollar.size();idx++)
			{	
				Double d1=(Double)openingDollar.get(idx);	
				double temp_op_dollar=d1.doubleValue();
				if(temp_op_dollar!=0){%>
				<tr>
					<td><%=(String)openingCashBank.get(idx)%>	</td>
					<%if(temp_op_dollar>0){%>	
				<td align=right><%=temp_op_dollar%></td>
				<%}else{%>
				<td align=right><%=(temp_op_dollar*(-1))%></td>
				<%}%>	
					<td><%=" "+(String)openingDrCr.get(idx)%></td>
				</tr>
			<%}}%>
			</table>
			</td>
			
<% 
			}

			if(currency.equals("both"))
			{
%>
			<td>
			<table border=1 valign=top bordercolor=white width="100%">
			<tr>
				<td>
					<table border=1 bordercolor=white width="100%">
					<tr>
						<td align=left> <B>Bank Name</B></td>
						<td align=center colspan=2><B>Local (<%=local_symbol%>)</B></td>
					</tr>

					<%
							for(int idx=0;idx<openingLocal.size();idx++)
							{	
								Double d1=(Double)openingLocal.get(idx);	
								double temp_op_local=d1.doubleValue();
								if(temp_op_local!=0){
					%>
							<tr>
								<td><%=(String)openingCashBank.get(idx)%></td>	
						<%
								if(temp_op_local>0)
								{
						%>	
									<td align=right><%=temp_op_local%></td>
						<%	
								}
								else
								{
						%>
									<td align=right><%=(temp_op_local*(-1))%></td>
						<%
								}
						%>	
									<td><%=" "+(String)openingDrCr.get(idx)%></td>
							</tr>
				<%
							}
						}
			%>
			</table>
			</td>

		
			<td>
			<table border=1 bordercolor=white width="100%">
			<tr>
			<td colspan=2 align=center><B>Dollar ($)</B></td>
			</tr>
		<%
				for(int idx=0;idx<openingDollar.size();idx++)
				{	
					Double d1=(Double)openingDollar.get(idx);	
					double temp_op_dollar=d1.doubleValue();
					if(temp_op_dollar!=0)
					{
		%>
				<tr>		
				<%
						if(temp_op_dollar>0)
						{
				%>	
							<td align=right><%=temp_op_dollar%></td>
				<%
						}
						else
						{
				%>
							<td align=right><%=(temp_op_dollar*(-1))%></td>
				<%
						}
				%>	
							<td><%=" "+(String)openingDrCr.get(idx)%></td>
				</tr>
		<%
					}
				}
		%>
				</td>
			</table>	

			</td>
			</tr>
			</table>	
	<%
			}
%>

	
	
	
	
	

	<%if(currency.equals("local"))
		{
		%>
			<b>Rs</b>&nbsp;&nbsp;</td><td> 
			 <table border=1 bordercolor=#660000>
			 <%for(int idx=0;idx<closingLocal.size();idx++)
				{	
				Double d1=(Double)closingLocal.get(idx);	
				double temp_cl_local=d1.doubleValue();
				if(temp_cl_local!=0){%>
				<tr><td><%=(String)closingCashBank.get(idx)%></td>	
				<%if(temp_cl_local>0){%>
				<td align=right><%=temp_cl_local%></td>
				<%}else{%>
				<td align=right><%=(temp_cl_local*(-1))%></td>
				<%}%>
				<td><%=" "+(String)closingDrCr.get(idx)%></td>
				</tr>
				<%}}%>
			</table>
			
			</td>
			
			
	<%}if(currency.equals("dollar"))
		{%>	
			<b>$</b>&nbsp;&nbsp;</td><td>
			<table border=1 bordercolor=#660000>
			<%for(int idx=0;idx<closingDollar.size();idx++)
			{	
				Double d1=(Double)closingDollar.get(idx);	
				double temp_cl_dollar=d1.doubleValue();
				if(temp_cl_dollar!=0){%>
				<tr><td><%=(String)closingCashBank.get(idx)%></td>	
				<%if(temp_cl_dollar>0){%>
				<td align=right><%=temp_cl_dollar%></td>
				<%}else{%>
				<td align=right><%=(temp_cl_dollar*(-1))%></td>
				<%}%>
				<td><%=" "+(String)closingDrCr.get(idx)%></td>
					
				<%}
				}%>	
				</tr>
				</table>
				</td>
<% }
				
		if(currency.equals("both"))
		{
%>
		<td>
			<table border=1 bordercolor=white width="100%">
			<tr>
				<td>
					<table border=1 bordercolor=white width="100%" >
					<tr>
					<td><B>Bank Name</B></td>
					<td colspan=2 align=center><B>Local(<%=local_symbol%>)</B></td>
					</tr>

			<%
					for(int idx=0;idx<closingLocal.size();idx++)
					{	
						Double d1=(Double)closingLocal.get(idx);	
						double temp_cl_local=d1.doubleValue();
						if(temp_cl_local!=0)
						{
			%>
						<tr>
							<td><%=(String)closingCashBank.get(idx)%></td>	
						
						<%
							if(temp_cl_local>0)
							{
						%>
							<td align=right><%=temp_cl_local%></td>
					<%
							}
							else
							{
					%>
							<td align=right><%=(temp_cl_local*(-1))%></td>
				<%		
							}
				%>
							<td><%="  "+(String)closingDrCr.get(idx)%></td>		</tr>
			<%
					}
				}
			%>
			
			</table>
			</td>
			
			
			<td>
			<table border=1 bordercolor=white width="100%">
			<tr>
			<td colspan=2 align=center><B>Dollar ($)</B></td>
			</tr>

			<%for(int idx=0;idx<closingDollar.size();idx++)
			{	
				Double d1=(Double)closingDollar.get(idx);	
				double temp_cl_dollar=d1.doubleValue();
				if(temp_cl_dollar!=0){%>
				<tr><%if(temp_cl_dollar>0){%>
				<td align=right><%=temp_cl_dollar%></td>
				<%}else{%>
				<td align=right><%=(temp_cl_dollar*(-1))%></td>
				<%}%>
				<td><%=" "+(String)closingDrCr.get(idx)%></td>
				</tr>
				<%}}%>
			
			</table>
			</td>
			</table>
			</td>
			
		<%}
	}
	else
	{%>
	<td></td>
	<td ><b>OP Bal :</b></td>
	<td>
		<%if(currency.equals("local"))
		{
			%>
			<b>Rs</b>&nbsp;&nbsp; </td><td><input type=text name="partyLocalOpening" readonly value="0" style="background:#99CCCC" style="text-align:right" size=8><input type=text name="partyLocalOpeningCredit" readonly value="" style="background:#99CCCC" style="text-align:right" size=1></td>
			<%}
			if(currency.equals("dollar"))
			{%>	
					<b>$</b>&nbsp;&nbsp;</td><td><input type=text name="partyLocalOpening" readonly value="0" style="background:#99CCCC" style="text-align:right" size=8>
					<input type=text name="partyLocalOpeningCredit" readonly value="" style="background:#99CCCC" style="text-align:right" size=1>	</td>
				<% }
				if(currency.equals("both"))
				{%>
					<b>Rs</b>&nbsp;&nbsp;</td><td><input type=text name="partyBothLocalOpening" readonly value="0" style="background:#99CCCC" style="text-align:right" size=8>&nbsp;&nbsp;
						</td><td><b>$&nbsp;&nbsp;</td><td><input type=text name="partyBothDollarOpening" readonly value="0" style="background:#99CCCC" style="text-align:right" size=8>
							<input type=text name="partyLocalOpeningCredit" readonly value="" style="background:#99CCCC" style="text-align:right" size=1>
								</td> 
				<%} %>
		
			<td><b>CLO Bal :&nbsp;&nbsp;&nbsp;</b><td>
			<td>
			<%if(currency.equals("local"))
			{
			%>
				<b>Rs</b>&nbsp;&nbsp;</td><td><input type=text name="partyLocalClosing"  readonly value="" style="background:#99CCCC" style="text-align:right" size=8>

				<input type=text name="partyLocalClosingCredit"  readonly value="" style="background:#99CCCC" style="text-align:right" size=1>
			</td>
			<%}if(currency.equals("dollar"))
			{%>	
				<b>$</b>&nbsp;&nbsp;</td><td><input type=text name="partyLocalClosing"  size=8  readonly value="" style="background:#99CCCC" style="text-align:right">

				<input type=text name="partyLocalClosingCredit"  size=1  readonly value="" style="background:#99CCCC" style="text-align:right">	
				</td>
			<% }if(currency.equals("both"))
			{%>
			<b>Rs</b></td><td><input type=text name="partyBothLocalClosing"  readonly value="" style="background:#99CCCC" style="text-align:right" size=8>
				&nbsp;&nbsp;</td><td><b>$&nbsp;&nbsp;</b> </td><td><input type=text name="partyBothDollarClosing"  readonly value="" style="background:#99CCCC" style="text-align:right" size=8>
				<input type=text name="partyLocalClosingCredit"  readonly value="" style="background:#99CCCC" style="text-align:right" size=1>
				</td>
<%}
	}
	//C.returnConnection(cong);
	//C.returnConnection(conp);
%>
</tr>
</table>

</center>

<table border=1 width="100%" bordercolor=#660033 >
<tr >
	<td colspan=3 valign=center >
		<%
		//cong=C.getConnection();
		//conp=C.getConnection();
		if("company".equals(flag))
		{
		%>
			<IFRAME name=finance_right align=right src="../Report/DayBook_IndiaFinance.jsp?command=Next&bydate=Invoice_Date&dd1=<%=dd1%>&mm1=<%=mm1%>&yy1=<%=yy1%>&dd2=<%=dd2%>&	mm2=<%=mm2%>&yy2=<%=yy2%>&party_id=<%=Party_Id%>&currency=<%=currency%>" marginwidth="10" marginheight="10" hspace="0" vspace="5" frameborder="0" scrolling="auto" align="right" width='100%'  height='350'>
			</IFRAME> 
		<%}
		else if("party".equals(flag))
		{%>
			<IFRAME name=finance_right align=right src="PartyFinanceMingle.jsp?command=Next&bydate=Invoice_Date&dd1=<%=dd1%>&mm1=<%=mm1%>&yy1=<%=yy1%>&dd2=<%=dd2%>&	mm2=<%=mm2%>&yy2=<%=yy2%>&party_id=<%=Party_Id%>&currency=<%=currency%>" marginwidth="10" marginheight="10" hspace="0" vspace="5" frameborder="0" scrolling="auto" align="right" width='100%'  height='350'>
			</IFRAME> 
		<%}%>

	</TD>
</TR>
		<input type=hidden name=dd1 value="<%=dd1%>">
		<input type=hidden name=mm1 value="<%=mm1%>">
		<input type=hidden name=yy1 value="<%=yy1%>">
		<input type=hidden name=dd2 value="<%=dd2%>">
		<input type=hidden name=mm2 value="<%=mm2%>">
		<input type=hidden name=yy2 value="<%=yy2%>">
		<input type=hidden name=flag value="<%=flag%>">
		
</table>

</form>
</body>
</HTML>
<%
	C.returnConnection(cong);
	C.returnConnection(conp);
}
catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("Exception in file IndiaFinance.jsp"+e +"errLine="+errLine);
	
}
%>


