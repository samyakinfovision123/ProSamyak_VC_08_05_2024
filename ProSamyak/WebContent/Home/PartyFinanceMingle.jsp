<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="DC" class="NipponBean.DebtorsCreditors" />
<jsp:useBean id="YED" class="NipponBean.YearEndDate" />
<jsp:useBean id="CVR" class="NipponBean.CustomerVendorReport" />

<%
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String ErrorLine="0";
String yearend_id = ""+session.getValue("yearend_id");
//out.print("<br> company_id"+company_id);
Connection cong = null;
Connection conp = null;
ResultSet rs_g= null;
ResultSet rs_p= null;

PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

try	{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception Samyak23){ 
	out.println("<font color=red> FileName : AccountMingle.jsp<br>Bug No Samyak23 : "+ Samyak23);}

String company_name= A.getName(cong,"companyparty",company_id);
String local_currency= I.getLocalCurrency(cong,company_id);

String local_symbol= I.getLocalSymbol(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
/*
int year=D.getYear();
int dd=01;
int mm=D.getMonth();
int d1=dd + 1;
mm--;
ErrorLine="45";
java.sql.Date Dprevious = new java.sql.Date((year-1),(mm),d1); */

int year=D.getYear();
year =2004;

int dd=1;
int mm=3;
java.sql.Date Dprevious = new java.sql.Date((year-1900),(mm),dd);

java.sql.Date yearendStartDate = YED.getDate(cong,"Yearend","From_Date", " where yearend_id="+yearend_id);
java.sql.Date yearendEndDate = YED.getDate(cong,"Yearend","To_Date", " where yearend_id="+yearend_id);


String command=request.getParameter("command");
//out.print("<br>command=" +command);
//out.print("<br> 49 dd"+)
try{
if("Default".equals(command))
{
%>
<html>
<head>
	<title>Samyak Software</title>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<script language="javascript" src="../Samyak/actb.js"></script>
	<script language="javascript" src="../Samyak/common.js"></script>
	<script language="javascript" src="../Samyak/getId.js"></script>
	<script language="javascript" src="../Samyak/ajax1.js"></script>
	<script language="javascript" src="../Samyak/GetCashBankLedgerId.js"></script>
</head>
<script language="JavaScript">
<!--
function getMyId()
{
		if("Party"==document.f1.account_type.value)
		{
			
			document.f1.action="../Home/PartyFinanceMingle.jsp?command=Next";
			return true;
			
		}
		if("Cash"==document.f1.account_type.value)
		{
		   
		   	document.f1.action="../Report/CashBankBookNew_Format.jsp?command=Next&BookType=Cash&orderby=vouchDate&exchrate=yes&refno=yes&bothCurrency=both";
			return true;
			
		}
		if("Bank"==document.f1.account_type.value)
		{
		
			document.f1.action="../Report/CashBankBookNew_Format.jsp?command=Next&BookType=Bank&orderby=vouchDate&exchrate=yes&refno=yes&bothCurrency=both";
			return true;
			
		}
} //getMyId()
//-->
</script>
<body bgcolor=#ffffee background="../Buttons/BGCOLOR.JPG">
<form action="PartyFinanceMingle.jsp" name=f1 method="post" target=_blank OnSubmit="getMyId();">
<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue>
		<th colspan=2>Account Mingle Reports</th>
	</tr>
	<tr>
		<th>From</th>
		<td><%=L.date(yearendStartDate,"dd1","mm1","yy1")%></td>
	</tr> 
	<tr>
		<th>To</th>
		<td><%=L.date(yearendEndDate,"dd2","mm2","yy2")%></td>
	</tr> 
	<tr>
		<th>Account </th>


		<TD>
			<INPUT type=text name='From' id='From' size=20 TABINDEX="4" autocomplete=off OnBlur='getCashBankLedgerIdByName(this.value,this.name,document.f1.account_id,<%=company_id%>)'>
		<input type=hidden name=party_id value='0'>
		<input type=hidden name=account_id value='0'>
		<input type=hidden name=account_type value='0'>
		</TD>

	<script language="JavaScript">
	<!--
	<%
		String companyArray="";
		String companyQuery="";		
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

	//-->
	</script>
	<script language="javascript">
			var companyobj = new  actb(document.getElementById('From'), companyArray);	
		</script>
		
<%
	C.returnConnection(cong); 
%>
	</tr>
	<tr>
	   <th>Currency In</th>
	   <th align=left>
			<input type="radio" name="currency" value="local" checked> Local</input>
			<input type="radio" name="currency" value="dollar"> Dollar</input>
			<input type="radio" name="currency" value="both" >Both</input>
		</th>
	</tr>
	<tr>
		<td colspan=2 align=center><input type=submit name="command" value="Next" class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
	</tr>
</table>
</form>
</body>
</html>
<%
	C.returnConnection(cong);
	C.returnConnection(conp);		
	}// Default

}catch(Exception e) 
{ 
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print(e); 
}

try{
if("Next".equals(command))
{
	int dd1 =Integer.parseInt(request.getParameter("dd1"));
	int mm1 =Integer.parseInt(request.getParameter("mm1"));
	int yy1 =Integer.parseInt(request.getParameter("yy1"));
	java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);

	int dd2 =Integer.parseInt(request.getParameter("dd2"));
	int mm2 =Integer.parseInt(request.getParameter("mm2"));
	int yy2 =Integer.parseInt(request.getParameter("yy2"));
	java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	
	String party_id=request.getParameter("party_id");
	//out.print("<br> 120 party_id"+party_id);
	String currency= request.getParameter("currency");
//out.print("<br> 120 currency"+currency);
	
	CVR.loadMasters(conp);//first method of the bean to be called to load the particulars values
ErrorLine="126";
	String query="";
	String party_id1="";
	String party_currency="";
	String party_name="";
	double credit_limit=0;

	double opening_sundrycreditors=0;
	double opening_sundrydebtors=0;
	double dopening_sundrycreditors=0;
	double dopening_sundrydebtors=0;
	String ledgername="";
	String ledgerid="";
	double finalclosing=0;
	double dfinalclosing=0;
	HashMap h=new HashMap();

	query="select Ledger_Name,ledger_id from ledger where Active=1 and parentCompanyParty_id="+party_id;
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		ledgername=rs_g.getString("Ledger_Name");
		ledgerid=rs_g.getString("ledger_id");
		h.put(ledgerid,ledgername);
	}
	pstmt_g.close();

	
	query=" Select companyparty_name, credit_limit, Transaction_Currency, CompanyParty_Id, Opening_PLocalBalance, Opening_RLocalBalance, Opening_PDollarBalance, Opening_RDollarBalance from Master_CompanyParty where CompanyParty_Id=".concat(party_id);
	//out.print("<BR>133 query=" +query);
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		 party_name= rs_g.getString("companyparty_name");
		 credit_limit= str.mathformat(rs_g.getDouble("credit_limit"),d);

		 party_currency= rs_g.getString("Transaction_Currency");
		 party_id1=rs_g.getString("CompanyParty_Id");

		 opening_sundrycreditors = str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
		 
		 opening_sundrydebtors = str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
		 
		 dopening_sundrycreditors = str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),2);
	
		 dopening_sundrydebtors = str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),2);

	 }
	pstmt_g.close();
			String ledgerQuery="select count(*) as counter from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt_g=conp.prepareStatement(ledgerQuery);
			rs_g=pstmt_g.executeQuery();
			int lcount=0;
			while(rs_g.next())
			{
				lcount=rs_g.getInt("counter");
				
			}
			pstmt_g.close();

			double Opening_LocalBalance[]=new double[lcount];
			double Opening_DollarBalance[]=new double[lcount];
			ledgerQuery="select Opening_LocalBalance,Opening_DollarBalance from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt_g=conp.prepareStatement(ledgerQuery);
			rs_g=pstmt_g.executeQuery();
			int r=0;
			while(rs_g.next())
			{
				Opening_LocalBalance[r]=rs_g.getDouble("Opening_LocalBalance");
				Opening_DollarBalance[r]=rs_g.getDouble("Opening_DollarBalance");

				r++;
			}
			pstmt_g.close();

	String salesAccLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", " where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=1 and Active=1");
	//out.print("<br> 169 salesAccLedgerId"+salesAccLedgerId);
	String purchaseAccLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", " where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=2 and Active=1");
	
	//out.print("<br> 169 purchaseAccLedgerId"+purchaseAccLedgerId);
	String ctaxLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");
	
	//out.print("<br> 169 ctaxLedgerId"+ctaxLedgerId);

	List salesList = new ArrayList();
	List purchaseList = new ArrayList();
	List ledgerList =new ArrayList();
	List mingledList = new ArrayList();
	ErrorLine="183";
	salesList = CVR.getSalesTransaction(salesAccLedgerId, conp, cong, D1, D2, opening_sundrydebtors, dopening_sundrydebtors, company_id, party_id, ctaxLedgerId);
	ErrorLine="185";
	purchaseList = CVR.getPurchaseTransaction(purchaseAccLedgerId, conp, cong, D1, D2, opening_sundrycreditors, dopening_sundrycreditors, company_id, party_id, ctaxLedgerId);
	ErrorLine="187";
	ledgerList =  CVR.getLedgerTransaction(conp, cong, D1, D2,Opening_LocalBalance,Opening_DollarBalance,company_id, party_id, ctaxLedgerId);
	
	ErrorLine="189";	
	mingledList = CVR.mingleList(salesList, purchaseList,ledgerList);
		
%>
<html>
	<head>
	<title>Sales/Purchase Account Mingle </title>
		<link href='../Samyak/reportcss.css' rel=stylesheet type='text/css'>
		<link href='../Samyak/tablecss.css' rel=stylesheet type='text/css'>
	
	<script language="JavaScript">
	<!--
	function tb(str)
		{
			window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=700", "Resizable=yes","Scrollbars=yes","status=no"])
		}
	//-->
	</script>

	</head>
	<body bgcolor=white>
	<form name=f1 >
	<table align=center borderColor=#FF66FF border=0 cellspacing=0 width='100%'>
	<tr>
		<td colspan=2 align=right><%=company_name%></td>
	</tr>
	<tr>
		<th align=center>Sales , Purchase and Ledger Account Mingle Report for <Font color=#9900CC><B><%=A.getNameCondition(cong,"Master_CompanyParty","CompanyParty_Name","where CompanyParty_Id="+party_id)%><B></font></td>
	</tr>
		<tr><th align=center>From <%=format.format(D1)%> - To <%=format.format(D2)%> </td></tr>
	<tr>
		<td><table align=center id=table21 cellspacing=0 width='100%'></td>
	</tr>
		<input type=hidden name=currency value=<%=currency%>>
	<tr bgcolor="#009999">
		<th class='th4'>Date</th>
		<th class='th4'>Particulars</th>
		<th class='th4'>Particulars</th>
		<th class='th4'>Vch Type</th>
		<th class='th4'>Vch No</th>
		<th class='th4'>Ref No</th>
		<%if("local".equals(currency) || "both".equals(currency))
		{%>
			<th class='th4'>Debit (<%=local_symbol%>)</th>
			<th class='th4'>Credit (<%=local_symbol%>)</th>
			<th class='th4'>Closing (<%=local_symbol%>)</th>
		<%}%>
		<%if("dollar".equals(currency) || "both".equals(currency))
		{%>
			<th class='th4'>Debit (US $)</th>
			<th class='th4'>Credit (US $)</th>
			<th class='th4'>Closing (US $)</th>
		<%}%>
	</tr>
	
	<%
	
	double local_closing=0;
	double dollar_closing=0;
	String Voucher_Id="";
	String NewLedger_Id="";
	//total of rows
	double db_localamount=0;
	double cr_localamount=0;
	double db_dollaramount=0;
	double cr_dollaramount=0;
	double LocalopeningBalanceDr=0;
	double LocalopeningBalanceCr=0;
	double DollaropeningBalanceDr=0;
	double DollaropeningBalanceCr=0;
	double LocalclosingBalance=0;
	//double LocalclosingBalanceCr=0;
	double LocalopeningBalanceCrNew=0;
	double DollarclosingBalance=0;
	//double DollarclosingBalanceCr=0;
	double LocalopeningBalanceDrNew=0;
	double DollaropeningBalanceDrNew=0;
	double DollaropeningBalanceCrNew=0;
	double tempLocalOpening=0;
	double tempDollarOpening=0;
	double closingBalance=0;
	String S1="";
	String S2="";
	String S3="";
	String S4="";

	
	ErrorLine="249";
	//displaying the rows
	int sizen=mingledList.size();
	int exit=0;
	int temp=0;
	int flag=1;
	customerVendorReportRow row11 = (customerVendorReportRow)mingledList.get(0);
		

		LocalopeningBalanceCrNew =row11.getLocalAmt_Cr();
		LocalopeningBalanceDrNew=row11.getLocalAmt_Dr();
		DollaropeningBalanceDrNew= row11.getDollarAmt_Dr();
		DollaropeningBalanceCrNew= row11.getDollarAmt_Cr();
		if(LocalopeningBalanceCrNew != 0)
		{
			S1="Cr";
			tempLocalOpening = LocalopeningBalanceCrNew;
			//out.println("351 tempLocalOpening="+tempLocalOpening);
		}
		if(LocalopeningBalanceDrNew != 0)
		{
			S1="Dr";
			tempLocalOpening =LocalopeningBalanceDrNew;
			//out.println("357 tempLocalOpening="+tempLocalOpening);
		}

		if(DollaropeningBalanceDrNew != 0)
		{
			S1="Dr";
			tempDollarOpening = DollaropeningBalanceDrNew;
		}
		if(DollaropeningBalanceCrNew != 0)
		{
			S1="Cr";
			tempDollarOpening =DollaropeningBalanceCrNew;
		}
%>
	
<%
		//out.print("<br> LocalopeningBalanceCrNew "+LocalopeningBalanceCrNew);
		//out.print("<br> LocalopeningBalanceDrNew "+LocalopeningBalanceDrNew);
		//out.print("<br> DollaropeningBalanceDrNew "+DollaropeningBalanceDrNew);
	//	out.print("<br> DollaropeningBalanceCrNew "+DollaropeningBalanceCrNew);
	//out.print("<br> 250 mingledList Size"+mingledList.size());
	for(int j=0;j<sizen;j++)
	{
	S2=S1;	
	customerVendorReportRow row1 = (customerVendorReportRow)mingledList.get(j);
	//out.print("<br> Ledger_Name"+Ledger_Name);
	local_closing += row1.getLocalAmt_Dr();
	local_closing -= row1.getLocalAmt_Cr();
	//out.print("<br> under for local_closing "+local_closing);
	dollar_closing += row1.getDollarAmt_Dr();
	dollar_closing -= row1.getDollarAmt_Cr();
	if(flag == 1  || flag==sizen )
	{
		if("local".equals(currency) || "both".equals(currency))
		{
			if(row1.getLocalAmt_Dr()!=0)
			{				
				S1="Dr";
				LocalopeningBalanceDr=row1.getLocalAmt_Dr();
				//out.print("<br> LocalopeningBalanceDr "+LocalopeningBalanceDr);
				
			}else{
				//out.print("<br> getLocalAmt_Dr 0");
				S1="Dr";
				}
			if(row1.getLocalAmt_Cr()!=0 )
			{
				S1="Cr";
				LocalopeningBalanceCr =row1.getLocalAmt_Cr();
				//out.print("<br> LocalopeningBalanceCr "+LocalopeningBalanceCr);
			}else{
				//out.print("<br> getLocalAmt_Cr 0 else");
				S1="Cr";
				}
			if(local_closing>0)
			{
				LocalclosingBalance = local_closing;
				S2="Dr";
				//out.print("<br> LocalclosingBalance "+LocalclosingBalance);
			}
			else
			{
				S2="Cr";
				LocalclosingBalance=(local_closing * -1);
			//	out.print("<br> LocalclosingBalance "+LocalclosingBalance);
				//(local_closing * -1) Cr.
			}
		}
//	-------------------
		if("dollar".equals(currency) || "both".equals(currency))
		{
			if(row1.getDollarAmt_Dr()!=0)
			{
				S3="Dr";
				DollaropeningBalanceDr=row1.getDollarAmt_Dr();
			}else{
				//out.print("<br>getDollarAmt_Dr 0");
				S3="Dr";
				}
			if(row1.getDollarAmt_Cr()!=0 )
			{
				DollaropeningBalanceCr =row1.getDollarAmt_Cr();
				S3="Cr";
			}else{
					//out.print("<br> getDollarAmt_Cr 0");
				S3="Cr";
				}
			if(local_closing>0)
			{
				//dollar_closing Dr 
				DollarclosingBalance = dollar_closing;
				S4="Dr";
			}
			else
			{
				DollarclosingBalance = (dollar_closing * -1);
				//(dollar_closing * -1) Cr.
				S4="Cr";
			}
		}
	}
//---------------------------------------
	flag++;

	
}


//System.out.println("Under PartyFinanceMingle tempLocalOpening"+tempLocalOpening+":"+LocalclosingBalance+":"+tempDollarOpening+":"+tempDollarOpening+":"+DollarclosingBalance);
%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("under script");
	//var localopBalDr = <%=LocalopeningBalanceDr%>;
	//var localopBalCr = <%=LocalopeningBalanceCr%>;
	//var localclose = <%=LocalclosingBalance%>;
		var cur=document.f1.currency.value;
		var ss1='<%=S1%>';
		var ss2='<%=S2%>';
		var ss3='<%=S3%>';
		var ss4='<%=S4%>';
		if(cur == "local")
		{	
	
			
			window.parent.itemValue(<%=tempLocalOpening%>,<%=LocalclosingBalance%>,ss1,ss2);
			<%
				//System.out.println("Under PartyFinanceMingle Currency under local "+currency+":"+LocalopeningBalanceDr+":"+LocalopeningBalanceCr+":"+LocalclosingBalance);
			%>
		}
		if(cur == "dollar")
		{
			
			window.parent.itemValue(<%=tempDollarOpening%>,<%=DollarclosingBalance%>,ss3,ss4);
			//System.out.println("Under PartyFinanceMingle Currency under local "+currency);
		}
		//alert(cur);
		if(cur == "both")
		{
			window.parent.itemValue1(<%=tempLocalOpening%>,<%=LocalclosingBalance%>,<%=tempDollarOpening%>,<%=DollarclosingBalance%>,ss1,ss2);
		}

	</SCRIPT>
	
<%	

local_closing=0; 
dollar_closing=0;
//------------
//session.putValue("OpeningBalance",)
	for(int i=0; i<mingledList.size(); i++)
	{
		customerVendorReportRow row = (customerVendorReportRow)mingledList.get(i);
		Voucher_Id =(String)row.getVoucher_Id();
		NewLedger_Id=(String)row.getLedgerId();
		String Ledger_Name="";
		if(h.containsKey(NewLedger_Id))
		{
			Ledger_Name=(String)h.get(NewLedger_Id);
		}
		
		//out.print("<br> Ledger_Name"+Ledger_Name);
		local_closing += row.getLocalAmt_Dr();
		local_closing -= row.getLocalAmt_Cr();
		//out.print("<br> under for local_closing "+local_closing);
		dollar_closing += row.getDollarAmt_Dr();
		dollar_closing -= row.getDollarAmt_Cr();

		db_localamount+=row.getLocalAmt_Dr();
		cr_localamount+=row.getLocalAmt_Cr();
		db_dollaramount+=row.getDollarAmt_Dr();
		cr_dollaramount+=row.getDollarAmt_Cr();
		//String LedgerName=
	
		ErrorLine="316";
		%>
		<tr>
			<td align=center valign=top><%=format.format(row.getVoucher_Date())%></td> 

			<%
			String particulars[] = row.getParticulars();
			int size = particulars.length;
			%>
						
			<td>
			<%
			for(int name=0; name<size; name++)
			{%>
				<%=particulars[name]%></br>  
			<%}%>
			</td>
			<td><%= Ledger_Name%></td>
			<td valign=top><%=row.getVoucher_Type()%></td>  
			<td valign=top><a href="javascript:tb('<%=row.getVoucher_Link()%>')"><%=row.getVoucher_No()%></a></td> 
			<td valign=top><%=row.getRef_No()%></td> 
			
			<%if("local".equals(currency) || "both".equals(currency))
			{%>
			
				<%if(row.getLocalAmt_Dr()!=0)
				{%>
					<td align=right valign=top><%=str.format(""+row.getLocalAmt_Dr(), d)%></td> 
				<%}
				else
				{%>
					<td align=right valign=top>&nbsp;</td> 
				<%}%>
				<%if(row.getLocalAmt_Cr()!=0 )
				{%>
					<td align=right valign=top><%=str.format(""+row.getLocalAmt_Cr(), d)%></td> 
				<%}
				else
				{%>
					<td align=right valign=top>&nbsp;</td> 
				<%}%>

				<%if(local_closing>0)
				{%>
					<td align=right valign=top><%=str.format(""+local_closing, d)%> Dr.</td> 
				<%}
				else
				{%>
					<td align=right valign=top><%=str.format(""+(local_closing * -1), d)%> Cr.</td> 
				<%}%>
			<%}%>

			<%if("dollar".equals(currency) || "both".equals(currency))
			{%>
				<%if(row.getDollarAmt_Dr() != 0)
				{%>
					<td align=right valign=top><%=str.format(""+row.getDollarAmt_Dr(), 2)%></td> 
				<%}
				else
				{%>
					<td align=right valign=top>&nbsp;</td> 
				<%}%>
				<%if(row.getDollarAmt_Cr() != 0 )
				{%>
					<td align=right valign=top><%=str.format(""+row.getDollarAmt_Cr(), 2)%></td> 
				<%}
				else
				{%>
					<td align=right valign=top>&nbsp;</td> 
				<%}%>
				<%if(dollar_closing>0)
				{%>
					<td align=right valign=top><%=str.format(""+dollar_closing, 2)%> Dr.</td> 
				<%}
				else
				{%>
					<td align=right valign=top><%=str.format(""+(dollar_closing*-1), 2)%> Cr.</td> 
				<%}
				ErrorLine="344";
			}%>
			
		</tr>
	<%
	}//end of for
	%>

	<tr bgcolor="#DDDDDD">
		<td colspan=6><b>Total</b></td>
		<%if("local".equals(currency) || "both".equals(currency))
		{%>
			<td align=right><b><%=str.format(""+db_localamount, d)%></b></td>
			<td align=right><b><%=str.format(""+cr_localamount, d)%></b></td>
			<td>&nbsp;</td>
		<%}%>
		<%if("dollar".equals(currency) || "both".equals(currency))
		{%>
			<td align=right><b><%=str.format(""+db_dollaramount, 2)%></b></td>
			<td align=right><b><%=str.format(""+cr_dollaramount, 2)%></b></td>
			<td>&nbsp;</td>
		<%}%>
	</tr>	
	</table>
	</form>
	</body>
	</html>
<%	
	
	C.returnConnection(cong);
	C.returnConnection(conp);
	}
}
catch(Exception e) { 
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("Error line"+ErrorLine+"Exception"+e); 
}
%>





