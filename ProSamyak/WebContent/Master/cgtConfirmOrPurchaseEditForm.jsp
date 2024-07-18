
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />

<html>
<head>
<title>Samyak Software -India</title>

<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


</head>



<% 
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;


try{


try	
{
	cong=C.getConnection();
}
catch(Exception Samyak60)
{ 
out.println("<br><font color=red> FileName : cgtConfirmOrPurchaseEditForm.jsp<br>Bug No Samyak60 : "+ Samyak60);
}

String user_name = ""+session.getValue("user_name");
int user_level = Integer.parseInt(""+session.getValue("user_level"));
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

String company_name="";
String company_address="";
String company_city="";
String company_country="";
String company_phone_off="";
String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+company_id;
pstmt_g = cong.prepareStatement(company_query);
//System.out.println(company_query);
rs_g = pstmt_g.executeQuery();
	while(rs_g.next()) 	
	{
	company_name= rs_g.getString("CompanyParty_Name");	
	company_address= rs_g.getString("Address1");	
	company_city= rs_g.getString("City");		
	company_country= rs_g.getString("Country");		
	company_phone_off= rs_g.getString("Phone_Off");	
	}
pstmt_g.close();
String local_currencyid=I.getLocalCurrency(cong,company_id);
String local_currencysymbol= I.getLocalSymbol(cong,company_id);
//out.print("<br>local_currencysymbol"+local_currencysymbol);
String base_exchangerate= I.getLocalExchangeRate(cong,company_id);


java.sql.Date D4 = new
java.sql.Date(System.currentTimeMillis());
String date=""+format.format(D4);
String startDate = format.format(YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));
//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(cong,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);



java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date invoice_datetemp = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Chanchal_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_date=stoday_day+"/"+stoday_month+"/"+today_year;
// end of today_date in dd/mm/yyyy format

// logic to get local currecy 
// end of local currecy logic
String command = request.getParameter("command");
String Receive_Id = request.getParameter("Receive_Id");
int lotRows = 0;	

String condition="and Super=0  and Purchase=1 and active=1";

int flag1 = 0;

if("PurchaseEdit".equals(command) || "CgtConfirmEdit".equals(command))
{
 
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid));
//C.returnConnection(cong);
 
//--------------------String Date To Date Variable----------------------------------------
String invoicedate=request.getParameter("invoicedate");

 %>
<script language="javascript">
function tb(str)
{
window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=no"])
}

<%
	String descQuery = "Select Description_Name from Master_Description where Active=1 order by Sr_No";
		
	pstmt_g = cong.prepareStatement(descQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String descArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			descArray += "\"" +rs_g.getString("Description_Name") +"\"";
		}
		else
		{
			descArray += "\"" +rs_g.getString("Description_Name") +"\",";
		}
	}
	pstmt_g.close();
	out.print("var descArray=new Array("+descArray+");");


	String sizeQuery = "Select Size_Name from Master_Size where Active=1 order by Sr_No";
		
	pstmt_g = cong.prepareStatement(sizeQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String sizeArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			sizeArray += "\"" +rs_g.getString("Size_Name") +"\"";
		}
		else
		{
			sizeArray += "\"" +rs_g.getString("Size_Name") +"\",";
		}
	}
	pstmt_g.close();
	out.print("var sizeArray=new Array("+sizeArray+");");

	String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Purchase=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String companyArray = "";
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
	out.print("var companyArray=new Array("+companyArray+");");


	String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
	pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String lotNoArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\"";
		}
		else
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\",";
		}
	}
	pstmt_g.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");


%>


</script>

	

<body background="../Buttons/BGCOLOR.JPG" onload="initDeletedRows();">
<form name=mainform action="cgtConfirmOrPurchaseEditFormAddNext.jsp"   method=post onsubmit="return onSubmitValidateForm()">

<input type=hidden name="Receive_Id" value="<%=Receive_Id%>">
<table bordercolor=red align=center border=1  cellspacing=0 cellpadding=2 width="100%">
<tr><td>

<tr>
<th colspan=15 align=center >
	<%if("PurchaseEdit".equals(command))
	{%>
		Edit Purchase For <%=A.getNameCondition(cong, "Receive", "Receive_No", "where Receive_Id="+Receive_Id)%>
		<input type=hidden name="EditType" value="PurchaseEdit">
	<%}
	else
	{%>
		Edit Consignment Confirm for <%=A.getNameCondition(cong, "Receive", "Receive_No", "where Receive_Id="+Receive_Id)%>
		<input type=hidden name="EditType" value="CgtConfirmEdit">
  <%}%>
</th>
</tr>

<tr><td>

<%
//getting the header and footer info
String Receive_No="";
double Local_Total = 0;
double Dollar_Total = 0;
java.sql.Date Receive_Date = new java.sql.Date(System.currentTimeMillis());
int Receive_CurrencyId = 0;
double Exchange_Rate = 0;
int	Receive_FromId = 0;
String	Receive_FromName = "";
int	SalesPerson_Id = 0;
int	Receive_Category = 0;
int PurchaseSaleGroup_Id = 0;
String narration = "";
int	Broker_Id = 0;
String Broker_Formula = "";
int	Due_Days = 0;
String final_duedate = ""; 

String RQuery = "SELECT Receive_No, Local_Total, Dollar_Total, Receive_Date, Receive_Lots, Receive_CurrencyId, Exchange_Rate, Receive_FromId, Receive_FromName, SalesPerson_Id, Receive_Category, PurchaseSaleGroup_Id, CgtDescription, Broker_Id, Broker_Formula, Due_Days, Due_Date FROM Receive WHERE Receive_Id="+Receive_Id+" AND Active=1";

pstmt_g = cong.prepareStatement(RQuery);
rs_g = pstmt_g.executeQuery();

while(rs_g.next())
{
	Receive_No = rs_g.getString("Receive_No");
	Local_Total = rs_g.getDouble("Local_Total");
	Dollar_Total = rs_g.getDouble("Dollar_Total");
	Receive_Date = rs_g.getDate("Receive_Date");
	lotRows = rs_g.getInt("Receive_Lots");
	Receive_CurrencyId = rs_g.getInt("Receive_CurrencyId");
	Exchange_Rate = rs_g.getDouble("Exchange_Rate");
	Receive_FromId = rs_g.getInt("Receive_FromId");
	Receive_FromName = rs_g.getString("Receive_FromName");
	SalesPerson_Id = rs_g.getInt("SalesPerson_Id");
	Receive_Category = rs_g.getInt("Receive_Category");
	PurchaseSaleGroup_Id = rs_g.getInt("PurchaseSaleGroup_Id");
	narration = rs_g.getString("CgtDescription");
	Broker_Id = rs_g.getInt("Broker_Id");
	Broker_Formula = rs_g.getString("Broker_Formula");
	Due_Days = rs_g.getInt("Due_Days");
	final_duedate = format.format(rs_g.getDate("Due_Date"));
}

pstmt_g.close();




//getting the lot details
double originalQtyTotal = 0;
double qtyTotal = 0;
double returnQtyTotal = 0;
double rejectQtyTotal = 0;
double dollaramountTotal = 0;
double localamountTotal = 0;

int Lot_Id[] = new int[lotRows];
int ReceiveTransaction_Id[] = new int[lotRows];
double Original_Quantity[] = new double[lotRows];
double Quantity[] = new double[lotRows];
double Local_Price[] = new double[lotRows];
double LocalEffective_Price[] = new double[lotRows];
double Dollar_Price[] = new double[lotRows];
double DollarEffective_Price[] = new double[lotRows];
double Local_Amount[] = new double[lotRows];
double Dollar_Amount[] = new double[lotRows];
String Remarks[] = new String[lotRows];
double Return_Quantity[] = new double[lotRows];
double Rejection_Percent[] = new double[lotRows];
double Rejection_Quantity[] = new double[lotRows];
String Lot_Discount[] = new String[lotRows];

String locked[] = new String[lotRows]; //store 'yes' to indicate the lot has been splitted or compared and cannot be edited, otherwise store 'no'


String RTQuery = "SELECT ReceiveTransaction_Id, Lot_Id, Original_Quantity, Quantity, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price, Local_Amount, Dollar_Amount, Remarks, Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount  FROM Receive_Transaction WHERE Receive_Id="+Receive_Id+" AND Active=1";

pstmt_g = cong.prepareStatement(RTQuery);
rs_g = pstmt_g.executeQuery();

int rtRow=0;
while(rs_g.next())
{
	ReceiveTransaction_Id[rtRow] = rs_g.getInt("ReceiveTransaction_Id");
	Lot_Id[rtRow] = rs_g.getInt("Lot_Id");
	Original_Quantity[rtRow] = rs_g.getDouble("Original_Quantity");
	Quantity[rtRow] = rs_g.getDouble("Quantity");
	Local_Price[rtRow] = rs_g.getDouble("Local_Price");
	LocalEffective_Price[rtRow] = rs_g.getDouble("LocalEffective_Price");
	Dollar_Price[rtRow] = rs_g.getDouble("Dollar_Price");
	DollarEffective_Price[rtRow] = rs_g.getDouble("DollarEffective_Price");
	Local_Amount[rtRow] = rs_g.getDouble("Local_Amount");
	Dollar_Amount[rtRow] = rs_g.getDouble("Dollar_Amount");
	Remarks[rtRow] = rs_g.getString("Remarks");
	Return_Quantity[rtRow] = rs_g.getDouble("Return_Quantity");
	Rejection_Percent[rtRow] = rs_g.getDouble("Rejection_Percent");
	Rejection_Quantity[rtRow] = rs_g.getDouble("Rejection_Quantity");
	Lot_Discount[rtRow] = rs_g.getString("Lot_Discount");

	originalQtyTotal += Original_Quantity[rtRow];
	qtyTotal += Quantity[rtRow];
	returnQtyTotal += Return_Quantity[rtRow];
	rejectQtyTotal += Rejection_Quantity[rtRow];
	dollaramountTotal += Dollar_Amount[rtRow];
	localamountTotal += Local_Amount[rtRow];

	rtRow++;
}

pstmt_g.close();

//check whether the lot has been splitted or not

//get all the destination stock transfer entries of type 4 for the given purchase or consignment confirm
String splitReceiveIdList = "-1";
String splitStkQuery = "SELECT Receive_Id FROM Receive WHERE StockTransfer_Type=4 AND Active=1 AND Consignment_ReceiveId="+Receive_Id+" AND Receive_Sell=1";

pstmt_g = cong.prepareStatement(splitStkQuery);
rs_g = pstmt_g.executeQuery();

while(rs_g.next())
{
	splitReceiveIdList += ", " + rs_g.getString("Receive_Id");
}
pstmt_g.close();

//get all the OT_RefText for the above read split receive ids
ArrayList splitRTIdList = new ArrayList();
splitStkQuery = "SELECT OT_RefText FROM Receive_Transaction WHERE Active=1 AND Receive_Id IN ("+splitReceiveIdList+")";

pstmt_g = cong.prepareStatement(splitStkQuery);
rs_g = pstmt_g.executeQuery();

while(rs_g.next())
{
	String ids = rs_g.getString("OT_RefText");
	StringTokenizer sttkn = new StringTokenizer(ids, ":");
	while(sttkn.hasMoreElements())
	{
		splitRTIdList.add(sttkn.nextElement());
	}
}
pstmt_g.close();

//Now check if the current purchase's RT ids are present in the splitRTIdList ArrayList.


for(int i=0; i<lotRows; i++)
{
	String tempRTId = "" + ReceiveTransaction_Id[i];
	if( splitRTIdList.contains(tempRTId) )
	{
		locked[i] = "yes";
	}

}


//load the lot details
String Lot_No[] = new String[lotRows];
int Desciption_Id[] = new int[lotRows];
String Desciption_Name[] = new String[lotRows];
int Size_Id[] = new int[lotRows];
String Size_Name[] = new String[lotRows];

for (int i=0;i<lotRows;i++)
{
	String lotQuery = "SELECT Lot_No, D_Size, Description_Id FROM Lot L, Diamond D WHERE L.Lot_Id=D.Lot_Id AND D.Lot_Id="+Lot_Id[i]+" AND L.Active=1";

	pstmt_g = cong.prepareStatement(lotQuery);
	rs_g = pstmt_g.executeQuery();

	while(rs_g.next())
	{
		Lot_No[i] = rs_g.getString("Lot_No");
		Size_Id[i] = rs_g.getInt("D_Size");
		Desciption_Id[i] = rs_g.getInt("Description_Id");
	}
	pstmt_g.close();

	Desciption_Name[i] = A.getNameCondition(cong, "Master_Description", "Description_Name", " WHERE Active=1 and Description_Id="+Desciption_Id[i]);

	Size_Name[i] = A.getNameCondition(cong, "Master_Size", "Size_Name", " WHERE Active=1 and Size_Id="+Size_Id[i]);
}


//get the ledger data
String cTaxLedger = A.getNameCondition(cong, "Ledger", "Ledger_Id", " WHERE Ledger_Name='C. Tax' AND For_Head=17 AND Company_Id="+company_id);

String FTQuery = "Select count(*) as LedgerCount FROM Financial_Transaction WHERE Receive_Id="+Receive_Id+" AND Active=1 AND Ledger_Id <> "+cTaxLedger+" AND Company_Id="+company_id+" AND yearend_id="+yearend_id;

pstmt_g = cong.prepareStatement(FTQuery);
rs_g = pstmt_g.executeQuery();

int oldLedgerRows = 0;

while(rs_g.next())
{
	oldLedgerRows = rs_g.getInt("LedgerCount");
}
pstmt_g.close();

String ftid[] = new String[oldLedgerRows];
String ledger[] = new String[oldLedgerRows];
double ledgerPercent[] = new double[oldLedgerRows];
double ledgerAmount[] = new double[oldLedgerRows];
double ledgerLocalAmount[] = new double[oldLedgerRows];
String debitcredit[] = new String[oldLedgerRows];

FTQuery = "Select Tranasaction_Id, Ledger_Id, Cheque_No, Dollar_Amount, Local_Amount, Transaction_Type FROM Financial_Transaction WHERE Receive_Id="+Receive_Id+" AND Active=1 AND Ledger_Id <> "+cTaxLedger+" AND Company_Id="+company_id+" AND yearend_id="+yearend_id;

pstmt_g = cong.prepareStatement(FTQuery);
rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
{
	ftid[c] = rs_g.getString("Tranasaction_Id");
	ledger[c] = rs_g.getString("Ledger_Id");
	ledgerPercent[c] = rs_g.getDouble("Cheque_No"); //currently percentage is stored in the Cheque_No column
	ledgerAmount[c] = rs_g.getDouble("Dollar_Amount");
	ledgerLocalAmount[c] = rs_g.getDouble("Local_Amount");
	debitcredit[c] = rs_g.getString("Transaction_Type");
	c++;
}
pstmt_g.close();


	
%>

<script language="JavaScript">
<!--
function setduedate()
{
	temp=document.mainform.datevalue.value;
	document.mainform.duedate.value = temp;
}

function onSubmitValidateForm()
{
	if(document.mainform.companyparty_name.value=="")
	{
		alert("Please Enter Customer/Party Name");
		document.mainform.companyparty_name.focus();
		document.mainform.companyparty_name.select();
		return false;
	}
	else if(document.mainform.companyparty_name.value.length < 3)
	{
		alert("Customer/Party Name Must Be Atleast 3 Characters");
		document.mainform.companyparty_name.focus();
		document.mainform.companyparty_name.select();
		return false;
	}

	for(var z=0; z<<%=lotRows%>; z++)
	{
		if(!recalculateQty(z))		
			{return false;}
	}

	calcOriginalQtyTotal();
	calcReturnQtyTotal();
	calcRejectionQtyTotal();
	calcAmountTotal();
	calclocalAmountTotal();
	
	return true;

}

function calcOriginalQtyTotal(){
	var originalQtyTotal = 0;
<%
	for (int i=0;i<lotRows;i++)
	{
%>	
		if(! document.mainform.delete<%=i%>.checked)
		{
			originalQtyTotal += parseFloat(document.mainform.originalQty<%=i%>.value);
		}
<%
	}	
%>
	document.mainform.originalQtyTotal.value = originalQtyTotal.toFixed(3);

}

function calcReturnQtyTotal(){
	var returnedQtyTotal = 0;
<%
	for (int i=0;i<lotRows;i++)
	{
%>
		if(! document.mainform.delete<%=i%>.checked)
		{
			returnedQtyTotal += parseFloat(document.mainform.returnQty<%=i%>.value);
		}
<%
	}	
%>
	document.mainform.returnQtyTotal.value = returnedQtyTotal.toFixed(3);

}

function calcRejectionQtyTotal(){
	var rejectedQtyTotal = 0;
<%
	for (int i=0;i<lotRows;i++)
	{
%>
		if(! document.mainform.delete<%=i%>.checked)
		{
			rejectedQtyTotal += parseFloat(document.mainform.rejectionQty<%=i%>.value);
		}
<%
	}	
%>
	document.mainform.rejectQtyTotal.value = rejectedQtyTotal.toFixed(3);

}

function calcAmountTotal(){
	var originalAmtTotal = 0;
<%
	for (int i=0;i<lotRows;i++)
	{
%>
		if(! document.mainform.delete<%=i%>.checked)
		{
			originalAmtTotal += parseFloat(document.mainform.amount<%=i%>.value);
		}
<%
	}	
%>
	document.mainform.amountTotal.value = originalAmtTotal.toFixed(3);
	calcAmountFinalTotal();
}


function calcAmountFinalTotal(){
	var originalAmtfinalTotal = parseFloat(document.mainform.amountTotal.value);
<%
	for (int i=0;i<oldLedgerRows;i++)
	{
%>		
		if(! document.mainform.deleteLedger<%=i%>.checked)
		{
			originalAmtfinalTotal += (parseFloat(document.mainform.ledgerAmount<%=i%>.value) * parseFloat(document.mainform.debitcredit<%=i%>.value) );
		}
<%
	}	
%>
	document.mainform.amountFinalTotal.value = originalAmtfinalTotal.toFixed(3);

}


function calclocalAmountTotal(){
	var originallocalAmtTotal = 0;
<%
	for (int i=0;i<lotRows;i++)
	{
%>
		if(! document.mainform.delete<%=i%>.checked)
		{
			originallocalAmtTotal += parseFloat(document.mainform.localamount<%=i%>.value);
		}
<%
	}	
%>
	document.mainform.localamountTotal.value = originallocalAmtTotal.toFixed(3);
	calclocalAmountFinalTotal();
}


function calclocalAmountFinalTotal(){
	var originallocalAmtfinalTotal = parseFloat(document.mainform.localamountTotal.value);
<%
	for (int i=0;i<oldLedgerRows;i++)
	{
%>
		if(! document.mainform.deleteLedger<%=i%>.checked)
		{
			originallocalAmtfinalTotal += (parseFloat(document.mainform.ledgerLocalAmount<%=i%>.value) * parseFloat(document.mainform.debitcredit<%=i%>.value) );
		}
<%
	}	
%>
	document.mainform.localamountFinalTotal.value = originallocalAmtfinalTotal.toFixed(3);

}

function debitcreditChanged()
{
	calcAmountFinalTotal();
	calclocalAmountFinalTotal();
}

function recalculateQty(rowNum){

	var orgQtyName = "originalQty"+rowNum;
	var retQtyName = "returnQty"+rowNum;
	var rejectQtyName = "rejectionQty"+rowNum;
	var qtyName = "qty"+rowNum;
	var rateName = "rate"+rowNum;	
	var amtName = "amount"+rowNum;
	var localamtName = "localamount"+rowNum;

	var finalquantity = parseFloat(document.mainform.elements[orgQtyName].value) - parseFloat(document.mainform.elements[retQtyName].value) - parseFloat(document.mainform.elements[rejectQtyName].value);
	
	if(finalquantity < 0)
	{
		alert("Quantity will be Negative for row:"+(parseInt(rowNum)+1));

		return false;
	}
	

	var old_qty = document.mainform.elements[qtyName].value;

	document.mainform.elements[qtyName].value = finalquantity.toFixed(3);

	var new_qtyTotal = document.mainform.qtyTotal.value - old_qty + finalquantity;
	document.mainform.qtyTotal.value = new_qtyTotal.toFixed(3);

	var old_amount = parseFloat(document.mainform.elements[amtName].value);
	var old_localamount = parseFloat(document.mainform.elements[localamtName].value);

	var new_amount = parseFloat(document.mainform.elements[qtyName].value) * parseFloat(document.mainform.elements[rateName].value);
	var new_localamount = new_amount * parseFloat(document.mainform.exchange_rate.value);

	document.mainform.elements[amtName].value = new_amount.toFixed(3);
	document.mainform.elements[localamtName].value = new_localamount.toFixed(<%=d%>);

	var new_total = document.mainform.amountTotal.value - old_amount + new_amount;
	document.mainform.amountTotal.value = new_total.toFixed(3);
	
	var new_localtotal = document.mainform.localamountTotal.value - old_localamount + new_localamount;
	document.mainform.localamountTotal.value = new_localtotal.toFixed(<%=d%>);

	calcOriginalQtyTotal();
	calcReturnQtyTotal();
	calcRejectionQtyTotal();

	percentLedgerChanged(0);

	return true;
}


function calculateEffRate(rowNum)
{
	var qtyName = "qty"+rowNum;
	var rateName = "rate"+rowNum;	
	var effrateName = "effrate"+rowNum;	
	var localrateName = "localrate"+rowNum;	
	var efflocalrateName = "efflocalrate"+rowNum;	
	var amtName = "amount"+rowNum;
	var localamtName = "localamount"+rowNum;
	var lotdiscountName = "lotDiscount"+rowNum;


	var effrate = parseFloat(document.mainform.elements[effrateName].value);
	var rate = effrate;

	var lotDiscount = document.mainform.elements[lotdiscountName].value;
	var discountPercents = lotDiscount.split(':');

	for(i=0; i<discountPercents.length; i++)
	{
		var discount = discountPercents[i];
		if(isNaN(discount))
		{
			return false;
		}
		rate = rate + (rate * discount) / 100;
	}
	document.mainform.elements[rateName].value = rate.toFixed(3);
	document.mainform.elements[localrateName].value = (rate * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);
	document.mainform.elements[efflocalrateName].value = (effrate * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);
	


	var old_amount = parseFloat(document.mainform.elements[amtName].value);
	var old_localamount = parseFloat(document.mainform.elements[localamtName].value);

	var new_amount = parseFloat(document.mainform.elements[qtyName].value) * parseFloat(document.mainform.elements[rateName].value);
	var new_localamount = new_amount * parseFloat(document.mainform.exchange_rate.value);

	document.mainform.elements[amtName].value = new_amount.toFixed(3);
	document.mainform.elements[localamtName].value = new_localamount.toFixed(<%=d%>);

	var new_total = document.mainform.amountTotal.value - old_amount + new_amount;
	document.mainform.amountTotal.value = new_total.toFixed(3);
	
	var new_localtotal = document.mainform.localamountTotal.value - old_localamount + new_localamount;
	document.mainform.localamountTotal.value = new_localtotal.toFixed(<%=d%>);

	percentLedgerChanged(0);

}

function calcLocalRate()
{
	<%
	for (int i=0;i<lotRows;i++)
	{
%>
		calculateEffRate(<%=i%>);
<%
	}	
%>

	<%
	for (int i=0;i<oldLedgerRows;i++)
	{
%>
		document.mainform.ledgerLocalAmount<%=i%>.value = document.mainform.ledgerAmount<%=i%>.value * parseFloat(document.mainform.exchange_rate.value);
<%
	}	
%>

	percentLedgerChanged(0);

}


function setOtherRates(rowNum)
{
	var rateName = "rate"+rowNum;	
	var effrateName = "effrate"+rowNum;	
	var localrateName = "localrate"+rowNum;	
	var efflocalrateName = "efflocalrate"+rowNum;

	document.mainform.elements[rateName].value = document.mainform.elements[effrateName].value;

	document.mainform.elements[localrateName].value = parseFloat(document.mainform.elements[rateName].value) * parseFloat(document.mainform.exchange_rate.value);

	document.mainform.elements[efflocalrateName].value = document.mainform.elements[localrateName].value;

}


function percentLedgerChanged(rowNum)
{
	var initialValue = parseFloat(document.mainform.amountTotal.value);
	
	for(var i=0; i<rowNum; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
			var drcrName = "debitcredit"+i;
			var ledgerAmtName = "ledgerAmount"+i;
				
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));
		}

	}
	

	for(var i=rowNum; i<<%=(oldLedgerRows)%>; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
			var perName = "ledgerPercent"+i;
			var perValue = document.mainform.elements[perName].value;
			var ledgerAmt = (initialValue * perValue) / 100;

			var ledgerAmtName = "ledgerAmount"+i;
			var ledgerlocalAmtName = "ledgerLocalAmount"+i;

			document.mainform.elements[ledgerAmtName].value = ledgerAmt.toFixed(3);
			document.mainform.elements[ledgerlocalAmtName].value = (document.mainform.elements[ledgerAmtName].value * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

			var drcrName = "debitcredit"+i;
			var ledgerAmtName = "ledgerAmount"+i;
					
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));
		}
	}

	calcAmountFinalTotal();
	calclocalAmountFinalTotal();
	
}

function ledgerAmountChanged(rowNum)
{
	var initialValue = parseFloat(document.mainform.amountTotal.value);
	
	for(var i=0; i<rowNum; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
			var drcrName = "debitcredit"+i;
			var ledgerAmtName = "ledgerAmount"+i;
					
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));
		}
	}
	

	var perName = "ledgerPercent"+rowNum;
	var ledgerAmtName = "ledgerAmount"+rowNum;
	var ledgerlocalAmtName = "ledgerLocalAmount"+rowNum;

	
	var ledgerAmt = document.mainform.elements[ledgerAmtName].value;
	var perValue = (ledgerAmt * 100 ) / initialValue;
		
	document.mainform.elements[perName].value = perValue.toFixed(3);
	document.mainform.elements[ledgerlocalAmtName].value = (document.mainform.elements[ledgerAmtName].value * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

	var drcrName = "debitcredit"+rowNum;
	var ledgerAmtName = "ledgerAmount"+rowNum;
				
	initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));

	
	for(var i=rowNum+1; i<<%=(oldLedgerRows)%>; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
	
			var perName = "ledgerPercent"+i;
			var perValue = document.mainform.elements[perName].value;
			var ledgerAmt = (initialValue * perValue) / 100;

			var ledgerAmtName = "ledgerAmount"+i;
			var ledgerlocalAmtName = "ledgerLocalAmount"+i;

			document.mainform.elements[ledgerAmtName].value = ledgerAmt.toFixed(3);
			document.mainform.elements[ledgerlocalAmtName].value = (document.mainform.elements[ledgerAmtName].value * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

			var drcrName = "debitcredit"+i;
			var ledgerAmtName = "ledgerAmount"+i;
					
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));
		}
	}

	calcAmountFinalTotal();
	calclocalAmountFinalTotal();
	
}



function ledgerLocalAmountChanged(rowNum)
{
	var initialValue = parseFloat(document.mainform.localamountTotal.value);
	
	for(var i=0; i<rowNum; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
			var drcrName = "debitcredit"+i;
			var ledgerlocalAmtName = "ledgerLocalAmount"+i;
					
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerlocalAmtName].value));
		}
	}
	

	var perName = "ledgerPercent"+rowNum;
	var ledgerAmtName = "ledgerAmount"+rowNum;
	var ledgerlocalAmtName = "ledgerLocalAmount"+rowNum;

	var ledgerlocalAmt = document.mainform.elements[ledgerlocalAmtName].value;
	var perValue = (ledgerlocalAmt * 100 ) / initialValue;
		
	document.mainform.elements[perName].value = perValue.toFixed(3);
	document.mainform.elements[ledgerAmtName].value = (document.mainform.elements[ledgerlocalAmtName].value / parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

	var drcrName = "debitcredit"+rowNum;
	var ledgerAmtName = "ledgerAmount"+rowNum;
				
	initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));

	
	for(var i=rowNum+1; i<<%=(oldLedgerRows)%>; i++)
	{
		var deleteLedgerName = "deleteLedger"+i;
		if(! document.mainform.elements[deleteLedgerName].checked)
		{
			var perName = "ledgerPercent"+i;
			var perValue = document.mainform.elements[perName].value;
			var ledgerAmt = (initialValue * perValue) / 100;

			var ledgerAmtName = "ledgerAmount"+i;
			var ledgerlocalAmtName = "ledgerLocalAmount"+i;

			document.mainform.elements[ledgerAmtName].value = ledgerAmt.toFixed(3);
			document.mainform.elements[ledgerlocalAmtName].value = (document.mainform.elements[ledgerAmtName].value * parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

			var drcrName = "debitcredit"+i;
			var ledgerAmtName = "ledgerAmount"+i;
					
			initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));
		}
	}

	calcAmountFinalTotal();
	calclocalAmountFinalTotal();
	
}

function deleteRow(rowNum)
{
	var deleteName = "delete"+rowNum;
	var lotnoName = "lotno"+rowNum;
	var descriptionName = "description"+rowNum;
	var dsizeName = "dsize"+rowNum;
	var originalQtyName = "originalQty"+rowNum;
	var returnQtyName = "returnQty"+rowNum;
	var rejectionQtyName = "rejectionQty"+rowNum;
	var qtyName = "qty"+rowNum;
	var effrateName = "effrate"+rowNum;
	var amountName = "amount"+rowNum;
	var localamountName = "localamount"+rowNum;
	var remarksName = "remarks"+rowNum;
	var lotDiscountName = "lotDiscount"+rowNum;



	if(document.mainform.elements[deleteName].checked)
	{
		document.mainform.elements[lotnoName].readOnly = true;
		document.mainform.elements[lotnoName].style.backgroundColor = "#CC6699";
		document.mainform.elements[descriptionName].readOnly = true;
		document.mainform.elements[descriptionName].style.backgroundColor = "#CC6699";
		document.mainform.elements[dsizeName].readOnly = true;
		document.mainform.elements[dsizeName].style.backgroundColor = "#CC6699";
		document.mainform.elements[originalQtyName].readOnly = true;
		document.mainform.elements[originalQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[returnQtyName].readOnly = true;
		document.mainform.elements[returnQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[rejectionQtyName].readOnly = true;
		document.mainform.elements[rejectionQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[qtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[effrateName].readOnly = true;
		document.mainform.elements[effrateName].style.backgroundColor = "#CC6699";
		document.mainform.elements[amountName].readOnly = true;
		document.mainform.elements[amountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[localamountName].readOnly = true;
		document.mainform.elements[localamountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[remarksName].readOnly = true;
		document.mainform.elements[remarksName].style.backgroundColor = "#CC6699";
		document.mainform.elements[lotDiscountName].readOnly = true;
		document.mainform.elements[lotDiscountName].style.backgroundColor = "#CC6699";

		var orgqty = document.mainform.originalQtyTotal.value -  document.mainform.elements[originalQtyName].value;
		document.mainform.originalQtyTotal.value = orgqty.toFixed(3);
		var retqty = document.mainform.returnQtyTotal.value -  document.mainform.elements[returnQtyName].value;
		document.mainform.returnQtyTotal.value = retqty.toFixed(3);
		var rejqty = document.mainform.rejectQtyTotal.value -  document.mainform.elements[rejectionQtyName].value;
		document.mainform.rejectQtyTotal.value = rejqty.toFixed(3);
		var qty = document.mainform.qtyTotal.value -  document.mainform.elements[qtyName].value;
		document.mainform.qtyTotal.value = qty.toFixed(3);

		var invamt = document.mainform.amountTotal.value -  document.mainform.elements[amountName].value;
		document.mainform.amountTotal.value = invamt.toFixed(3);
		var invlclamt = document.mainform.localamountTotal.value -  document.mainform.elements[localamountName].value;
		document.mainform.localamountTotal.value = invlclamt.toFixed(3);

		percentLedgerChanged(0);
		
	}
	else
	{
	
		document.mainform.elements[lotnoName].readOnly = false;
		document.mainform.elements[lotnoName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[descriptionName].readOnly = false;
		document.mainform.elements[descriptionName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[dsizeName].readOnly = false;
		document.mainform.elements[dsizeName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[originalQtyName].readOnly = false;
		document.mainform.elements[originalQtyName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[returnQtyName].readOnly = false;
		document.mainform.elements[returnQtyName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[rejectionQtyName].readOnly = false;
		document.mainform.elements[rejectionQtyName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[qtyName].style.backgroundColor = "#CCCCFF";
		document.mainform.elements[effrateName].readOnly = false;
		document.mainform.elements[effrateName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[amountName].readOnly = false;
		document.mainform.elements[amountName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[localamountName].readOnly = false;
		document.mainform.elements[localamountName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[remarksName].readOnly = false;
		document.mainform.elements[remarksName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[lotDiscountName].readOnly = false;
		document.mainform.elements[lotDiscountName].style.backgroundColor = "#FFFFFF";

		var orgqty = parseFloat(document.mainform.originalQtyTotal.value) +  parseFloat(document.mainform.elements[originalQtyName].value);
		document.mainform.originalQtyTotal.value = orgqty.toFixed(3);
		var retqty = parseFloat(document.mainform.returnQtyTotal.value) + parseFloat(document.mainform.elements[returnQtyName].value);
		document.mainform.returnQtyTotal.value = retqty.toFixed(3);
		var rejqty = parseFloat(document.mainform.rejectQtyTotal.value) +  parseFloat(document.mainform.elements[rejectionQtyName].value);
		document.mainform.rejectQtyTotal.value = rejqty.toFixed(3);
		var qty = parseFloat(document.mainform.qtyTotal.value) +  parseFloat(document.mainform.elements[qtyName].value);
		document.mainform.qtyTotal.value = qty.toFixed(3);

		var invamt = parseFloat(document.mainform.amountTotal.value) +  parseFloat(document.mainform.elements[amountName].value);
		document.mainform.amountTotal.value = invamt.toFixed(3);
		var invlclamt = parseFloat(document.mainform.localamountTotal.value) +  parseFloat(document.mainform.elements[localamountName].value);
		document.mainform.localamountTotal.value = invlclamt.toFixed(3);

		percentLedgerChanged(0);
	}


}


function deleteLedgerRow(rowNum)
{
	var deleteLedgerName = "deleteLedger"+rowNum;
	var ledgerName = "ledger"+rowNum;
	var ledgerPercentName = "ledgerPercent"+rowNum;
	var ledgerAmountName = "ledgerAmount"+rowNum;
	var ledgerLocalAmountName = "ledgerLocalAmount"+rowNum;
	var debitcreditName = "debitcredit"+rowNum;
	
	if(document.mainform.elements[deleteLedgerName].checked)
	{
		//document.mainform.elements[ledgerName].disabled = true;
		document.mainform.elements[ledgerName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerPercentName].readOnly = true;
		document.mainform.elements[ledgerPercentName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerAmountName].readOnly = true;
		document.mainform.elements[ledgerAmountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerLocalAmountName].readOnly = true;
		document.mainform.elements[ledgerLocalAmountName].style.backgroundColor = "#CC6699";
		//document.mainform.elements[debitcreditName].disabled = true;
		document.mainform.elements[debitcreditName].style.backgroundColor = "#CC6699";
		
		percentLedgerChanged(0);
		
	}
	else
	{

		document.mainform.elements[ledgerName].disabled = false;
		document.mainform.elements[ledgerName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[ledgerPercentName].readOnly = false;
		document.mainform.elements[ledgerPercentName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[ledgerAmountName].readOnly = false;
		document.mainform.elements[ledgerAmountName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[ledgerLocalAmountName].readOnly = false;
		document.mainform.elements[ledgerLocalAmountName].style.backgroundColor = "#FFFFFF";
		document.mainform.elements[debitcreditName].disabled = false;
		document.mainform.elements[debitcreditName].style.backgroundColor = "#FFFFFF";
		
		percentLedgerChanged(0);
			
	}


}


function initDeletedRows()
{
	<%
	for(int i=0; i < lotRows; i++)
	{
	%>
	var deleteName = "delete"+<%=i%>;
	var lotnoName = "lotno"+<%=i%>;
	var descriptionName = "description"+<%=i%>;
	var dsizeName = "dsize"+<%=i%>;
	var originalQtyName = "originalQty"+<%=i%>;
	var returnQtyName = "returnQty"+<%=i%>;
	var rejectionQtyName = "rejectionQty"+<%=i%>;
	var qtyName = "qty"+<%=i%>;
	var effrateName = "effrate"+<%=i%>;
	var amountName = "amount"+<%=i%>;
	var localamountName = "localamount"+<%=i%>;
	var remarksName = "remarks"+<%=i%>;
	var lotDiscountName = "lotDiscount"+<%=i%>;



	if(document.mainform.elements[deleteName].checked)
	{
		document.mainform.elements[lotnoName].readOnly = true;
		document.mainform.elements[lotnoName].style.backgroundColor = "#CC6699";
		document.mainform.elements[descriptionName].readOnly = true;
		document.mainform.elements[descriptionName].style.backgroundColor = "#CC6699";
		document.mainform.elements[dsizeName].readOnly = true;
		document.mainform.elements[dsizeName].style.backgroundColor = "#CC6699";
		document.mainform.elements[originalQtyName].readOnly = true;
		document.mainform.elements[originalQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[returnQtyName].readOnly = true;
		document.mainform.elements[returnQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[rejectionQtyName].readOnly = true;
		document.mainform.elements[rejectionQtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[qtyName].style.backgroundColor = "#CC6699";
		document.mainform.elements[effrateName].readOnly = true;
		document.mainform.elements[effrateName].style.backgroundColor = "#CC6699";
		document.mainform.elements[amountName].readOnly = true;
		document.mainform.elements[amountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[localamountName].readOnly = true;
		document.mainform.elements[localamountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[remarksName].readOnly = true;
		document.mainform.elements[remarksName].style.backgroundColor = "#CC6699";
		document.mainform.elements[lotDiscountName].readOnly = true;
		document.mainform.elements[lotDiscountName].style.backgroundColor = "#CC6699";

		
		
	}
	
	<%
	}	
	%>

	<%
	for(int i=0; i < oldLedgerRows; i++)
	{
	%>
	var deleteLedgerName = "deleteLedger"+<%=i%>;
	var ledgerName = "ledger"+<%=i%>;
	var ledgerPercentName = "ledgerPercent"+<%=i%>;
	var ledgerAmountName = "ledgerAmount"+<%=i%>;
	var ledgerLocalAmountName = "ledgerLocalAmount"+<%=i%>;
	var debitcreditName = "debitcredit"+<%=i%>;



	if(document.mainform.elements[deleteLedgerName].checked)
	{
		//document.mainform.elements[ledgerName].disabled = true;
		document.mainform.elements[ledgerName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerPercentName].readOnly = true;
		document.mainform.elements[ledgerPercentName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerAmountName].readOnly = true;
		document.mainform.elements[ledgerAmountName].style.backgroundColor = "#CC6699";
		document.mainform.elements[ledgerLocalAmountName].readOnly = true;
		document.mainform.elements[ledgerLocalAmountName].style.backgroundColor = "#CC6699";
		//document.mainform.elements[debitcreditName].disabled = true;
		document.mainform.elements[debitcreditName].style.backgroundColor = "#CC6699";
				
	}
	
	<%
	}	
	%>
}
//-->
</script>
<table  border=1 width="100%" cellspacing=0 cellpadding=2 bordercolor=#AAD6F9>

<tr>
	<td>Inv No:</td><td><input type=Text name=purchase_no size=4 value="<%=Receive_No%>" readonly style="background:#CCCCFF">  
	</td>
	<td>Ref No</td><td>
		<input type=text name=ref_no size=4  value="" maxlength=10>
	</td>
	<td >Currency </td>
	<td colspan=3>
	<%
	if("PurchaseEdit".equals(command))
	{
		if(Receive_CurrencyId == 0)
		{%>
			<input type=radio name=currency value=local> Local
			<input type=radio name=currency value=dollar checked> Dollar
		<%}
		else
		{%>
			<input type=radio name=currency value=local checked> Local
			<input type=radio name=currency value=dollar> Dollar
		<%}
	}
	else
	{
		if(Receive_CurrencyId == 0)
		{%>
			<input type=hidden name=currency value=dollar> Dollar
		<%}
		else
		{%>
			<input type=hidden name=currency value=local>Local
		<%}
	}%>
	</td>
	<td>From </td>
	<td> 
	<%if("PurchaseEdit".equals(command))
	{%>
		<input type=text name=companyparty_name value="<%=Receive_FromName%>" size=15 id=companyparty_name>
		<input type=hidden name=companyparty_id value="<%=Receive_FromId%>" id=companyparty_id>
		<script language="javascript">
		
			var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
		
		</script>	
	<%}
	else
	{%>
		<input type=text readonly name=companyparty_name value="<%=Receive_FromName%>" style="background:#CCCCFF" size=15 id=companyparty_name>
		<input type=hidden name=companyparty_id value="<%=Receive_FromId%>" id=companyparty_id>
	<%}%>
	</td>
		
	<td colspan=1>
	Purchase Group <a href="javascript:tb('../Finance/PurchaseSaleGroupType.jsp?command=Default&message=Default')"> <img src="../Buttons/add.jpg" height="10" width="10">	</a> </td>
	<td> <%=AC.getMasterArrayCondition(cong,"PurchaseSaleGroup","purchasesalegroup_id",""+PurchaseSaleGroup_Id,"where Active=1 and PurchaseSaleGroup_Type=1",company_id)%>
	</td>

	</tr>

	<tr>
	<td colspan=2>
	<!-- invoice date -->
	<script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")'onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Invoice Date'  style='font-size:11px ;  width:100'>")}
	</script> 
	</td> 
	<td colspan=2>
		
	<input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(Receive_Date)%>"
	onblur='setduedate();return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);' class="ipplane" accesskey="i"  onfocus='setduedate();'>
	</td>

	<td colspan=2>Due Days</td><td colspan=2><input type=text size=5 name='duedays' value="<%=Due_Days%>" style="text-align:right" onBlur="return addDueDays(document.mainform.datevalue, 'Date', document.mainform.duedate, this);"></td>

	<td colspan=2>
	<script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Due Date' style='font-size:11px ; width:100'>")}
	</script> 
		 
	 </td>

	 <td colspan=2>
	 <input type=text size=8 name='duedate' class="ipplane" value="<%=final_duedate%>" onblur='return  fnCheckMultiDate1(this,"Date")'>
	</td>
</tr>

<tr>
	<td colspan=2>Type</td>
	<td colspan=2>Regular</td><input type=hidden name="purchase_type" value="0">
	<td colspan=2>Location <a href="javascript:tb('../Master/NewLocation.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a></td>
	<td colspan=2> 
	<%=AC.getMasterArrayCondition(cong,"Location","location_id0",A.getNameCondition(cong,"Receive_Transaction","Distinct(location_id)","where Receive_Id="+Receive_Id),"where Active=1",company_id)%>
	
	<td colspan=2>Category  <a href="javascript:tb('../Master/NewCategory.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a></td>
	<td colspan=3><%=AC.getArrayConditionAll(cong,"Master_LotCategory","category_id",""+Receive_Category,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
	</td>

</tr>

<tr>
	<td colspan=2>Exchange Rate </td>
	<td colspan=2>
	<input type=text name=exchange_rate size=5 value="<%=str.mathformat(""+Exchange_Rate,3)%>" onBlur="calcLocalRate()" style="text-align:right">
	 </td>
	<td colspan=2>Purchase Person <a href="javascript:tb('../Master/SalesPerson.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a> </td>
	<td colspan=3> <%=AC.getMasterArrayCondition(cong,"SalesPerson","purchaseperson_id",""+SalesPerson_Id,"where company_id="+company_id+"")%></td>

	<td >Broker <a href="javascript:tb('../Master/SalesPerson.jsp?command=Default&message=Default')"> <img src="../Buttons/add.jpg" height="10" width="10"></a> 
	</td>

	<td>	<%=AC.getMasterArrayCondition(cong,"SalesPerson","broker_id",""+Broker_Id,"where company_id="+company_id+"")%>
	</td>
	<td> <input type=text name=broker_remarks size=5 value="<%=Broker_Formula%>" style="text-align:left" onBlur="checkDiscount(this);"></td>
</tr>
</table>

</td></tr>
<tr><td>
<%

if("PurchaseEdit".equals(command))
{
%>

		<table  border=1 width="100%" cellspacing=0 cellpadding=2 bordercolor=#3300CC>

		<tr >
		<td width="5%">Sr No</td>
		<td width="5%">Lot No.</td>
		<td width="15%">Desc.</td>
		<td width="15%">Size</td>
		<td width="10%">Original Qty</td>
		<td width="10%">Return  Qty</td>
		<td width="10%">Selection Qty</td>
		<td width="15%">Rate ($)</td>
		<td width="15%">Amount ($)</td>
		<td width="15%">Amount (<%=local_currencysymbol%>)</td>
		<td width="20%">Remarks</td>
		<td width="5%">Lot Discount (%)</td>
		</tr>
		<%
		for (int i=0;i<lotRows;i++)
			{
		%>
		<input type=hidden name=rtid<%=i%> value="<%=ReceiveTransaction_Id[i]%>" >
		<input type=hidden name=lotid<%=i%> value="<%=Lot_Id[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="<%=Lot_Id[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=locked<%=i%> value="<%=locked[i]%>" id=locked<%=i%>>
		

		<tr>
		<td><%=(i+1)%><input type="checkbox" name="delete<%=i%>" value='yes'" onClick="deleteRow('<%=i%>');" <%if("yes".equals(locked[i])) 				{out.print("disabled");}%>></td>
		
		<td><input type=text size=7 name=lotno<%=i%> value="<%=Lot_No[i]%>" id=lotno<%=i%> style="text-align:left;" onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'dummyrate<%=i%>', 'description<%=i%>', 'purchase' );" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=description<%=i%> size=7 value="<%=Desciption_Name[i]%>" style="text-align:left" id=description<%=i%> <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=dsize<%=i%> size=7 value="<%=Size_Name[i]%>"  style="text-align:left" id=dsize<%=i%> onblur="getLots('<%=company_id%>', document.mainform.description<%=i%>.value, document.mainform.dsize<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','lotno<%=i%>', 'dummyrate<%=i%>', 'description<%=i%>', 'purchase' ); " <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=originalQty<%=i%> size=7 value="<%=str.format(Original_Quantity[i], 3)%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" onfocus="setOtherRates(<%=i%>);" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=returnQty<%=i%> size=7 value="<%=str.format(Return_Quantity[i], 3)%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<input type=hidden name=rejection<%=i%> value="<%=Rejection_Percent[i]%>" onBlur="nochk(this,3)" >
		<input type=hidden name=rejectionQty<%=i%> value="<%=str.format(Rejection_Quantity[i],3)%>" onBlur="nochk(this,3)">
		
		<td><input type=text name=qty<%=i%> readonly size=7 value="<%=str.format(Quantity[i], 3)%>" onBlur="nochk(this,3)" style="text-align:right;background:#CCCCFF">
		<input type=hidden name=oldqty<%=i%> value="<%=str.format(Quantity[i], 3)%>" >
		</td>
		
		<td><input type=hidden name=rate<%=i%>  value="<%=str.format(Dollar_Price[i], 3)%>" style="text-align:right" id=rate<%=i%>>
		
		<input type=text name=effrate<%=i%> value="<%=str.format(DollarEffective_Price[i], 3)%>" onBlur="nochk(this,3); calculateEffRate('<%=i%>');"  style="text-align:right" size=7 id=effrate<%=i%> <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>>
		<input type=hidden name=dummyrate<%=i%> value="0" id=dummyrate<%=i%>>
		
		<input type=hidden name=localrate<%=i%> value="<%=str.format(Local_Price[i], 3)%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="<%=str.format(LocalEffective_Price[i], 3)%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
	
		<td><input type=text name=amount<%=i%> size=7 value="<%=str.format(Dollar_Amount[i], 3)%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=localamount<%=i%> size=7 value="<%=str.format(Local_Amount[i], d)%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=remarks<%=i%> size=15 value="<%=Remarks[i]%>" style="text-align:left" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=lotDiscount<%=i%> size=7 value="<%=Lot_Discount[i]%>" style="text-align:left" onBlur="checkDiscount(this); calculateEffRate('<%=i%>');" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		</tr>
		<script language="javascript">

			var lobj<%=i%> = new  actb(document.getElementById('lotno<%=i%>'), lotNoArray);
			
			var dobj<%=i%> = new  actb(document.getElementById('description<%=i%>'), descArray);
			
			var sobj<%=i%> = new  actb(document.getElementById('dsize<%=i%>'), sizeArray);

			function nochk(elem,deci){
				validate(elem, deci);
			}
		</script>	
		<%
			}
		%>
		<tr>
		<td colspan=4>Inventory Total </td>
		<td align=left>
		<input type=hidden name=oldLotRows value="<%=lotRows%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows%>">
		<input type=text size=7 name=originalQtyTotal readonly value="<%=str.format(originalQtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right">
		</td><td align=left>
		<input type=text size=7 name=returnQtyTotal readonly value="<%=str.format(returnQtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		<td align=left>
		<input type=hidden name=rejectQtyTotal readonly value="<%=str.format(rejectQtyTotal, 3)%>">
		<input type=text size=7 name=qtyTotal readonly value="<%=str.format(qtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td>&nbsp;</td>
		<td>
		<input type=text size=7 name=amountTotal readonly value="<%=str.format(dollaramountTotal, 3)%>" style="background:#CCCCFF" style="text-align:right">
		</td><td align=left>
		<input type=text size=7 name=localamountTotal readonly value="<%=str.format(localamountTotal, d)%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		</tr>
	
		<%
		for(int i=0; i<oldLedgerRows; i++)
		{
		%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');"></td>
			<td colspan=6 align=right><%=A.getArray(cong,"Ledger","ledger"+i,""+ledger[i],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="<%=str.format(ledgerAmount[i], 3)%>"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="<%=str.format(ledgerLocalAmount[i], d)%>"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>
			<%if("1".equals(debitcredit[i])) {%>
				<td>
					<select name= "debitcredit<%=i%>" onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged()">
						<option value="1" selected>Dr</option>
						<option value="-1">Cr</option>
					</select>
				</td>
			<%} else { %>
				<td>
					<select name="debitcredit<%=i%>" onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged();">
						<option value="1">Dr</option>
						<option value="-1" selected>Cr</option>
					</select>
				</td>
			<%}%>
			</tr>
		<%
		}
		
		%>


		<tr>
		<td colspan=8>Total </td>
		<td align=left>
		<input type=text size=7 name=amountFinalTotal readonly value="<%=str.format(Dollar_Total, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountFinalTotal readonly value="<%=str.format(Local_Total, d)%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>

		<tr>
		<td colspan=13> Narration <input type=text name=narration size=100 value="<%=narration%>">
		</tr>

		</table>
		<tr>
		<td>
		</table>

<%
}//end of if Edit Purchase 
else //this portion is for consignment confirm Edit
{%>
	
		<table  border=1 width="100%" cellspacing=0 cellpadding=2 bordercolor=#3300CC>

		<tr >
		<td width="5%">Sr No</td>
		<td width="5%">Lot No.</td>
		<td width="15%">Desc.</td>
		<td width="15%">Size</td>
		<td width="10%">Original Qty</td>
		<td width="10%">Return  Qty</td>
		<td width="5%">Rejection %</td>
		<td width="5%">Rejection Qty</td>
		<td width="10%">Selection Qty</td>
		<td width="15%">Rate ($)</td>
		<td width="15%">Amount ($)</td>
		<td width="15%">Amount (<%=local_currencysymbol%>)</td>
		<td width="20%">Remarks</td>
		<td width="5%">Lot Discount (%)</td>
		</tr>
		<%
		for (int i=0;i<lotRows;i++)
			{
		%>
		<input type=hidden name=rtid<%=i%> value="<%=ReceiveTransaction_Id[i]%>" >
		<input type=hidden name=lotid<%=i%> value="<%=Lot_Id[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="<%=Lot_Id[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=locked<%=i%> value="<%=locked[i]%>" id=locked<%=i%>>

		<tr>
		<td><%=(i+1)%><input type="checkbox" name="delete<%=i%>" value='yes'" onClick="deleteRow('<%=i%>');" <%if("yes".equals(locked[i])) 				{out.print("disabled");}%>></td>
		<td><%=Lot_No[i]%>
		<input type=hidden name=lotno<%=i%> value="<%=Lot_No[i]%>" id=lotno<%=i%> ></td>
		<td><%=Desciption_Name[i]%>
		<input type=hidden name=description<%=i%> value="<%=Desciption_Name[i]%>"  id=description<%=i%>></td>
		<td><%=Size_Name[i]%>
		<input type=hidden name=dsize<%=i%>  value="<%=Size_Name[i]%>"  id=dsize<%=i%> ></td>
		<td><input type=text name=originalQty<%=i%> size=7 value="<%=str.format(Original_Quantity[i], 3)%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td><input type=text name=returnQty<%=i%> size=7 value="<%=str.format(Return_Quantity[i], 3)%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td>
		<input type=text name=rejection<%=i%> size=3 value="<%=Rejection_Percent[i]%>" readonly  style="text-align:right;background:#CCCCFF" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td>
		<input type=text name=rejectionQty<%=i%> size=7 value="<%=str.format(Rejection_Quantity[i],3)%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td><input type=text name=qty<%=i%> readonly size=7 value="<%=str.format(Quantity[i], 3)%>" onBlur="nochk(this,3)" style="text-align:right;background:#CCCCFF" >
		<input type=hidden name=oldqty<%=i%> value="<%=str.format(Quantity[i], 3)%>" >
		</td>
		<td><input type=hidden name=rate<%=i%> size=7 value="<%=str.format(Dollar_Price[i], 3)%>"  style="text-align:right" id=rate<%=i%>>
		<input type=text size=7 name=effrate<%=i%> value="<%=str.format(DollarEffective_Price[i], 3)%>"  style="text-align:right" onBlur="nochk(this,3); calculateEffRate('<%=i%>');" id=effrate<%=i%> <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>>
		<input type=hidden name=localrate<%=i%> value="<%=str.format(Local_Price[i], 3)%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="<%=str.format(LocalEffective_Price[i], 3)%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<td><input type=text name=amount<%=i%> size=7 value="<%=str.format(Dollar_Amount[i], 3)%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td><input type=text name=localamount<%=i%> size=7 value="<%=str.format(Local_Amount[i], d)%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td><input type=text name=remarks<%=i%> size=10 value="<%=Remarks[i]%>" style="text-align:left" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<td><input type=text name=lotDiscount<%=i%> size=7 value="<%=Lot_Discount[i]%>" style="text-align:left" onBlur="checkDiscount(this); calculateEffRate('<%=i%>');" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		</tr>
		<script language="javascript">

			var lobj<%=i%> = new  actb(document.getElementById('lotno<%=i%>'), lotNoArray);
			
			var dobj<%=i%> = new  actb(document.getElementById('description<%=i%>'), descArray);
			
			var sobj<%=i%> = new  actb(document.getElementById('dsize<%=i%>'), sizeArray);

			function nochk(elem,deci){
				validate(elem, deci);
			}
		</script>	
		<%
			}
		%>
		<tr>
		<td colspan=4>Inventory Total </td>
		<td align=left>
		<input type=hidden name=oldLotRows value="<%=lotRows%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows%>">
		<input type=text size=7 name=originalQtyTotal readonly value="<%=str.format(originalQtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=returnQtyTotal readonly value="<%=str.format(returnQtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		<td>&nbsp;</td>
		<td align=left>
		<input type=text size=7 name=rejectQtyTotal readonly value="<%=str.format(rejectQtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=qtyTotal readonly value="<%=str.format(qtyTotal, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td>&nbsp;</td>
		<td align=left>
		<input type=text size=7 name=amountTotal readonly value="<%=str.format(dollaramountTotal, 3)%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountTotal readonly value="<%=str.format(localamountTotal, d)%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>

		<%
		for(int i=0; i<oldLedgerRows; i++)
		{
		%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');"></td>
			<td colspan=8 align=right><%=A.getArray(cong,"Ledger","ledger"+i,""+ledger[i],company_id+"and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="<%=str.format(ledgerAmount[i], 3)%>"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="<%=str.format(ledgerLocalAmount[i], d)%>"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>
			<%if("1".equals(debitcredit[i])) {%>
				<td>
					<select name= "debitcredit<%=i%>" onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged()">
						<option value="1" selected>Dr</option>
						<option value="-1">Cr</option>
					</select>
				</td>
			<%} else { %>
				<td>
					<select name="debitcredit<%=i%>" onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged();">
						<option value="1">Dr</option>
						<option value="-1" selected>Cr</option>
					</select>
				</td>
			<%}%>
			</tr>
		<%
		}
		
		%>

		 <tr>
		<td colspan=10>Total </td>
		<td align=left>
		<input type=text size=7 name=amountFinalTotal readonly value="<%=Dollar_Total%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountFinalTotal readonly value="<%=Local_Total%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>
		<tr>
		<td colspan=14> Narration <input type=text name=narration size=100 value="<%=narration%>">
		</tr>

		</table>
		<tr>
		<td>
		</table>

		


<%}//end of else%>
<br><br>
<table width='100%' cellpadding=0 cellspacing=0>
<tr>
<td colspan=1 align=center>&nbsp;
<!-- <input type=button name=command value=BACK class='button1_over'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" disabled> -->
</td>

<%if("PurchaseEdit".equals(command))
{%>
<td colspan=1 align=center> 

	Add 
	<input type=radio name=addType value="ledger" checked>Ledgers 
	<input type=radio name=addType value="lot">Lots 
	<input type=text name=addLotsLedgers size=2 value="1" onBlur="validate(this)" style="text-align:right" >

	<input type=submit name=command value=ADD class='button1'   onmouseover="this.className='button1_over';"  onmouseout="this.className='button1';" > 
</td>
<%}
else
{%>
	<td colspan=1 align=center> 

	Add <input type=hidden name=addType value="ledger">Ledgers 
	<input type=text name=addLotsLedgers size=2 value="1" onBlur="validate(this)" style="text-align:right" >

	<input type=submit name=command value=ADD class='button1'   onmouseover="this.className='button1_over';"  onmouseout="this.className='button1';" > 
</td>

<%}%>
<td colspan=1 align=center>
<input type=submit name=command  value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" >
</td>
<td colspan=1 align=center>
<%
if(flag1==0)
{
%>
<input type=button name=edit value=EDIT class='button1_over'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick='edt()' disabled>
<%
}
else
{ %>
	<input type=button name=edit value=EDIT class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick='edt()' >
<%
}
%>
	</td>
</tr>
</table>
</form>
<%
 
}//end if ('Default')
C.returnConnection(cong);
}
catch(Exception Samyak188){ 
C.returnConnection(cong);
out.println("<font color=red> FileName : cgtConfirmOrPurchaseEditForm.jsp <br>Bug No Samyak188 <br>Please Contact Samyak Admin <br> bug is  "+ Samyak188 +"</font>");}
%> 