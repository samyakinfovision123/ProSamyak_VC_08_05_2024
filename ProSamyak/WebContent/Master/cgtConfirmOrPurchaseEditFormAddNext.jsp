<!-- Consingment In Start 06-03-05 -->

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
out.println("<br><font color=red> FileName : cgtConfirmOrPurchase.jsp<br>Bug No Samyak60 : "+ Samyak60);
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
String EditType = request.getParameter("EditType");


String lots = request.getParameter("oldLotRows");
int lotRows= Integer.parseInt(lots);
String condition="and Super=0  and Purchase=1 and active=1";

int oldLedgerRows = Integer.parseInt(request.getParameter("oldLedgerRows"));
int newLedgerRows = 0;
int newLotRows = 0;

String addType = request.getParameter("addType");
if("ledger".equals(addType))
{
	newLedgerRows = Integer.parseInt(request.getParameter("addLotsLedgers"));

}
if("lot".equals(addType))
{
	newLotRows = Integer.parseInt(request.getParameter("addLotsLedgers"));

}


int flag1 = 0;
if("ADD".equals(command))
{
 
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid));
//C.returnConnection(cong);
 
//--------------------String Date To Date Variable----------------------------------------

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

	for(var z=0; z<<%=lotRows+newLotRows%>; z++)
	{
		recalculateQty(0);		
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
	for (int i=0;i<lotRows+newLotRows;i++)
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
	for (int i=0;i<lotRows+newLotRows;i++)
	{
%>		if(! document.mainform.delete<%=i%>.checked)
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
	for (int i=0;i<lotRows+newLotRows;i++)
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
	for (int i=0;i<lotRows+newLotRows;i++)
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
	for (int i=0;i<oldLedgerRows+newLedgerRows;i++)
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
	for (int i=0;i<lotRows+newLotRows;i++)
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
	for (int i=0;i<oldLedgerRows+newLedgerRows;i++)
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
		alert("Quantity is Negative");
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
	for (int i=0;i<lotRows+newLotRows;i++)
	{
%>
		calculateEffRate(<%=i%>);
<%
	}	
%>

	<%
	for (int i=0;i<oldLedgerRows+newLedgerRows;i++)
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
	

	for(var i=rowNum; i<<%=(oldLedgerRows+newLedgerRows)%>; i++)
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

	
	for(var i=rowNum+1; i<<%=(oldLedgerRows+newLedgerRows)%>; i++)
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

	
	for(var i=rowNum+1; i<<%=(oldLedgerRows+newLedgerRows)%>; i++)
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
	for(int i=0; i < oldLedgerRows+newLedgerRows; i++)
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
</script>

<%
//Reading the data from the previous file
String purchase_no = request.getParameter("purchase_no");
String ref_no = request.getParameter("ref_no");
String currency = request.getParameter("currency");
String companyparty_name = request.getParameter("companyparty_name");
String companyparty_id = request.getParameter("companyparty_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String datevalue = request.getParameter("datevalue");
String duedays = request.getParameter("duedays");
String duedate = request.getParameter("duedate");
String purchase_type = request.getParameter("purchase_type");
String location_id0 = request.getParameter("location_id0");
String category_id = request.getParameter("category_id");
String exchange_rate = request.getParameter("exchange_rate");
String purchaseperson_id = request.getParameter("purchaseperson_id");
String broker_id = request.getParameter("broker_id");
String broker_remarks = request.getParameter("broker_remarks");





%>	

<body background="../Buttons/BGCOLOR.JPG" onload="initDeletedRows()">
<form name=mainform action="cgtConfirmOrPurchaseEditFormAddNext.jsp"   method=post onsubmit="return onSubmitValidateForm()">
<input type=hidden name="Receive_Id" value="<%=Receive_Id%>">

<table bordercolor=red align=center border=1  cellspacing=0 cellpadding=2 width="100%">
<tr><td>

<tr>
<th colspan=15 align=center >
	<%if("PurchaseEdit".equals(EditType))
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

	<table  border=1 width="100%" cellspacing=0 cellpadding=2 bordercolor=#AAD6F9>

	<tr>
		<td>Inv No:</td><td><input type=Text name=purchase_no size=4 value="<%=purchase_no%>" readonly style="background:#CCCCFF">  
		</td>
		<td>Ref No</td><td>
		<input type=text name=ref_no size=4  value="<%=ref_no%>" maxlength=10>
		</td>
		<td >Currency </td><td colspan=3>

		<%
		if("local".equals(currency))
		{
		%>
			<input type=hidden name=currency value=local>Local
		<%}
		else
		{%>
			<input type=hidden name=currency value=dollar> Dollar
		<%
		}
		%>
		</td>

		<td>
		From 

		<%if("PurchaseEdit".equals(EditType))
		{%>
			<a href="javascript:tb('../Master/NewParty.jsp?message=Default')">
			<img src="../Buttons/add.jpg" height="10" width="10">
			</a></td><td> <input type=text name=companyparty_name value="<%=companyparty_name%>"  size=15 id=companyparty_name>
		
			<script language="javascript">
		
				var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
		
			</script>	
		<%}
		else
		{%>
			</td><td> <input type=text readonly name=companyparty_name value="<%=companyparty_name%>" style="background:#CCCCFF" size=15 id=companyparty_name>
		
		<%}%>
		</td>
		<td colspan=2>
		Purchase Group <a href="javascript:tb('../Finance/PurchaseSaleGroupType.jsp?command=Default&message=Default')"> <img src="../Buttons/add.jpg" height="10" width="10">	</a> </td><td> <%=AC.getMasterArrayCondition(cong,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=1",company_id)%>
		</td>

	</tr>

	</tr>
		<td colspan=2>
		<!-- invoice date -->
		<script language='javascript'>
		if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")'onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Invoice Date'  style='font-size:11px ;  width:100'>")}
		</script> 
		</td> 
		<td colspan=2>
			
		<input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(format.getDate(datevalue))%>"
		onblur='setduedate();return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);' class="ipplane" accesskey="i"  onfocus='setduedate();'>
		</td>

		<td colspan=2>Due Days</td><td colspan=2><input type=text size=5 name='duedays' value="<%=duedays%>" style="text-align:right" onBlur="return addDueDays(document.mainform.datevalue, 'Date', document.mainform.duedate, this);"></td>

		<td colspan=2>
		<script language='javascript'>
		if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\" value='Due Date' style='font-size:11px ; width:100'>")}
		</script> 
			 
		 </td>

		 <td colspan=2>
		 <input type=text size=8 name='duedate' class="ipplane" value="<%=format.format(format.getDate(duedate))%>" onblur='return  fnCheckMultiDate1(this,"Date")'>
		</td>
	</tr>

	<tr>
		<td colspan=2>Type</td>

		<td colspan=2>Regular</td>
		<input type=hidden name="purchase_type" value="<%=purchase_type%>">
		
		<td colspan=2>Location <a href="javascript:tb('../Master/NewLocation.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a></td>
		<td colspan=2> 
		<%=AC.getMasterArrayCondition(cong,"Location","location_id0",""+location_id0,"where Active=1",company_id)%>
		<%//=A.getMasterArrayCondition(cong,"Location","location_id0","","where Active=1",company_id)%></td>

		<td colspan=2>Category  <a href="javascript:tb('../Master/NewCategory.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a></td>
		<td colspan=3><%=AC.getArrayConditionAll(cong,"Master_LotCategory","category_id",""+category_id,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
		</td>

	</tr>

	<tr>
		<td colspan=2>Exchange Rate </td>
		<td colspan=2>
		<input type=text name=exchange_rate size=5 value="<%=str.mathformat(exchange_rate,3)%>" onBlur="calcLocalRate()" style="text-align:right">
		 </td>
		<td colspan=2>Purchase Person <a href="javascript:tb('../Master/SalesPerson.jsp?command=Default&message=Default')"><img src="../Buttons/add.jpg" height="10" width="10"></a> </td>
		<td colspan=3> <%=AC.getMasterArrayCondition(cong,"SalesPerson","purchaseperson_id",""+purchaseperson_id,"where company_id="+company_id+"")%></td>

		<td >Broker <a href="javascript:tb('../Master/SalesPerson.jsp?command=Default&message=Default')"> <img src="../Buttons/add.jpg" height="10" width="10"></a> 
		</td>

		<td>	<%=AC.getMasterArrayCondition(cong,"SalesPerson","broker_id",""+broker_id,"where company_id="+company_id+"")%>
		</td>
		<td> <input type=text name=broker_remarks size=5 value="<%=broker_remarks%>" style="text-align:left" onBlur="checkDiscount(this);"></td>
	</tr>
	</table>
</td></tr>
<tr><td>

<%
//Reading the data of the previous lots.
String rtid[] = new String[lotRows];
String lotid[] = new String[lotRows];
String oldlotid[] = new String[lotRows];
String lotno[] = new String[lotRows];
String description[] = new String[lotRows];
String dsize[] = new String[lotRows];
String originalQty[] = new String[lotRows];
String returnQty[] = new String[lotRows];
String rejection[] = new String[lotRows];
String rejectionQty[] = new String[lotRows];
String qty[] = new String[lotRows];
String oldqty[] = new String[lotRows];
String rate[] = new String[lotRows];
String effrate[] = new String[lotRows];
String localrate[] = new String[lotRows];
String efflocalrate[] = new String[lotRows];
String amount[] = new String[lotRows];
String localamount[] = new String[lotRows];
String remarks[] = new String[lotRows];
String lotDiscount[] = new String[lotRows];
String delete[] = new String[lotRows];
String locked[] = new String[lotRows];

for(int i=0; i<lotRows; i++)
{
	rtid[i] = request.getParameter("rtid"+i);
	lotid[i] = request.getParameter("lotid"+i);
	oldlotid[i] = request.getParameter("oldlotid"+i);
	delete[i] = request.getParameter("delete"+i);
	locked[i] = request.getParameter("locked"+i);
	lotno[i] = request.getParameter("lotno"+i);
	description[i] = request.getParameter("description"+i);
	dsize[i] = request.getParameter("dsize"+i);
	originalQty[i] = request.getParameter("originalQty"+i);
	returnQty[i] = request.getParameter("returnQty"+i);
	rejection[i] = request.getParameter("rejection"+i);
	rejectionQty[i] = request.getParameter("rejectionQty"+i);
	qty[i] = request.getParameter("qty"+i);
	oldqty[i] = request.getParameter("oldqty"+i);
	rate[i] = request.getParameter("rate"+i);
	effrate[i] = request.getParameter("effrate"+i);
	localrate[i] = request.getParameter("localrate"+i);
	efflocalrate[i] = request.getParameter("efflocalrate"+i);
	amount[i] = request.getParameter("amount"+i);
	localamount[i] = request.getParameter("localamount"+i);
	remarks[i] = request.getParameter("remarks"+i);
	lotDiscount[i] = request.getParameter("lotDiscount"+i);
	
}


String originalQtyTotal = request.getParameter("originalQtyTotal");
String returnQtyTotal = request.getParameter("returnQtyTotal");
String rejectQtyTotal = request.getParameter("rejectQtyTotal");
String qtyTotal = request.getParameter("qtyTotal");
String amountTotal = request.getParameter("amountTotal");
String localamountTotal = request.getParameter("localamountTotal");
String narration = request.getParameter("narration");


%>

<%if("PurchaseEdit".equals(EditType))
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
		<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="<%=oldlotid[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=rtid<%=i%> value="<%=rtid[i]%>" >
		<input type=hidden name=locked<%=i%> value="<%=locked[i]%>" id=locked<%=i%>>

		<tr>
		<td><%=(i+1)%><input type="checkbox" name="delete<%=i%>" value='yes'" onClick="deleteRow('<%=i%>');" <%if("yes".equals(locked[i])) 				{out.print("disabled");}%> <%if("yes".equals(delete[i])) 				{out.print("checked");}%>></td>
		
		<td><input type=text size=7 name=lotno<%=i%> value="<%=lotno[i]%>" id=lotno<%=i%> style="text-align:left;" onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'dummyrate<%=i%>', 'description<%=i%>', 'purchase' );" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=description<%=i%> size=7 value="<%=description[i]%>" style="text-align:left" id=description<%=i%> <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=dsize<%=i%> size=7 value="<%=dsize[i]%>"  style="text-align:left" id=dsize<%=i%> onblur="getLots('<%=company_id%>', document.mainform.description<%=i%>.value, document.mainform.dsize<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','lotno<%=i%>', 'dummyrate<%=i%>', 'description<%=i%>', 'purchase' ); " <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>

		<td><input type=text name=originalQty<%=i%> size=7 value="<%=originalQty[i]%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" onfocus="setOtherRates(<%=i%>);" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=returnQty<%=i%> size=7 value="<%=returnQty[i]%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		<input type=hidden name=rejection<%=i%> value="<%=rejection[i]%>" onBlur="nochk(this,3)" >
		<input type=hidden name=rejectionQty<%=i%> value="<%=rejectionQty[i]%>" onBlur="nochk(this,3)">
		
		<td><input type=text name=qty<%=i%> readonly size=7 value="<%=qty[i]%>" onBlur="nochk(this,3)" style="text-align:right;background:#CCCCFF"></td>
		<input type=hidden name=oldqty<%=i%> value="<%=oldqty[i]%>" >
		
		<td><input type=hidden name=rate<%=i%>  value="<%=rate[i]%>" style="text-align:right" id=rate<%=i%>>
		<input type=text name=effrate<%=i%> value="<%=effrate[i]%>" onBlur="nochk(this,3); calculateEffRate('<%=i%>');"  style="text-align:right" size=7 id=effrate<%=i%> <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>>
		<input type=hidden name=localrate<%=i%> value="<%=localrate[i]%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="<%=efflocalrate[i]%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<input type=hidden name=dummyrate<%=i%> value="0" id=dummyrate<%=i%>>
		
		<td><input type=text name=amount<%=i%> size=7 value="<%=amount[i]%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=localamount<%=i%> size=7 value="<%=localamount[i]%>" onBlur="nochk(this,3)" style="text-align:right" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=remarks<%=i%> size=15 value="<%=remarks[i]%>" style="text-align:left" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
		
		<td><input type=text name=lotDiscount<%=i%> size=7 value="<%=lotDiscount[i]%>" style="text-align:left" onBlur="checkDiscount(this); calculateEffRate('<%=i%>');" <%if("yes".equals(locked[i])) {out.print("readonly style=\"background:#CCCCFF\""); }%>></td>
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


		<%
		for (int i=lotRows;i<(lotRows+newLotRows);i++)
			{
		%>
		<input type=hidden name=lotid<%=i%> value="" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="0" id=oldlotid<%=i%>>
		<input type=hidden name=rtid<%=i%> value="0" >

		<tr>
		<td><%=(i+1)%><input type="checkbox" name="delete<%=i%>" value='yes'" onClick="deleteRow('<%=i%>');"></td>
		<td><input type=text size=7 name=lotno<%=i%> value="" id=lotno<%=i%> style="text-align:left;" onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'purchase' );"></td>
		<td><input type=text name=description<%=i%> size=7 value="" style="text-align:left" id=description<%=i%>></td>
		<td><input type=text name=dsize<%=i%> size=7 value=""  style="text-align:left" id=dsize<%=i%> onblur="getLots('<%=company_id%>', document.mainform.description<%=i%>.value, document.mainform.dsize<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','lotno<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'purchase' ); "></td>
		<td><input type=text name=originalQty<%=i%> size=7 value="0" onBlur="nochk(this,3); recalculateQty('<%=i%>');" onfocus="setOtherRates(<%=i%>);" style="text-align:right"></td>
		<td><input type=text name=returnQty<%=i%> size=7 value="0" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right"></td>
		<input type=hidden name=rejection<%=i%> value="0" onBlur="nochk(this,3)" >
		<input type=hidden name=rejectionQty<%=i%> value="0" onBlur="nochk(this,3)">
		<td><input type=text name=qty<%=i%> readonly size=7 value="0" onBlur="nochk(this,3)" style="text-align:right;background:#CCCCFF"></td>
		<input type=hidden name=oldqty<%=i%> value="0" >
		<td><input type=hidden name=rate<%=i%>  value="1" style="text-align:right" id=rate<%=i%>>
		<input type=text name=effrate<%=i%> value="1" onBlur="nochk(this,3); calculateEffRate('<%=i%>');"  style="text-align:right" size=7 id=effrate<%=i%>>
		<input type=hidden name=localrate<%=i%> value="1"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="1"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<td><input type=text name=amount<%=i%> size=7 value="0" onBlur="nochk(this,3)" style="text-align:right" ></td>
		<td><input type=text name=localamount<%=i%> size=7 value="0" onBlur="nochk(this,3)" style="text-align:right"></td>
		<td><input type=text name=remarks<%=i%> size=15 value="" style="text-align:left"></td>
		<td><input type=text name=lotDiscount<%=i%> size=7 value="" style="text-align:left" onBlur="checkDiscount(this); calculateEffRate('<%=i%>');"></td>
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
		<input type=hidden name=oldLotRows value="<%=lotRows+newLotRows%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows+newLedgerRows%>">
		<input type=text size=7 name=originalQtyTotal readonly value="<%=originalQtyTotal%>" style="background:#CCCCFF" style="text-align:right">
		</td><td align=left>
		<input type=text size=7 name=returnQtyTotal readonly value="<%=returnQtyTotal%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		<td align=left>
		<input type=hidden name=rejectQtyTotal readonly value="<%=rejectQtyTotal%>">
		<input type=text size=7 name=qtyTotal readonly value="<%=qtyTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td>&nbsp;</td>
		<td>
		<input type=text size=7 name=amountTotal readonly value="<%=amountTotal%>" style="background:#CCCCFF" style="text-align:right">
		</td><td align=left>
		<input type=text size=7 name=localamountTotal readonly value="<%=localamountTotal%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		</tr>
		<%//add old ledger rows
		//Read the values of the old ledger rows and display them
		String ftid[] = new String[oldLedgerRows];
		String deleteLedger[] = new String[oldLedgerRows];
		String ledger[] = new String[oldLedgerRows];
		String ledgerPercent[] = new String[oldLedgerRows];
		String ledgerAmount[] = new String[oldLedgerRows];
		String ledgerLocalAmount[] = new String[oldLedgerRows];
		String debitcredit[] = new String[oldLedgerRows];

		for(int i=0; i<oldLedgerRows; i++)
		{
			ftid[i] = request.getParameter("ftid"+i);
			deleteLedger[i] = request.getParameter("deleteLedger"+i);
			ledger[i] = request.getParameter("ledger"+i);
			ledgerPercent[i] = request.getParameter("ledgerPercent"+i);
			ledgerAmount[i] = request.getParameter("ledgerAmount"+i);
			ledgerLocalAmount[i] = request.getParameter("ledgerLocalAmount"+i);
			debitcredit[i] = request.getParameter("debitcredit"+i);
		%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');" <%if("yes".equals(deleteLedger[i])) 				{out.print("checked");}%>></td>
			<td colspan=6 align=right><%=A.getArray(cong,"Ledger","ledger"+i,""+ledger[i],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="<%=ledgerAmount[i]%>"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="<%=ledgerLocalAmount[i]%>"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>
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

		<%//add new ledger rows
		for(int i=oldLedgerRows; i<(oldLedgerRows+newLedgerRows); i++)
		{%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="0">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');"></td>
			<td colspan=6 align=right><%=A.getArray(cong,"Ledger","ledger"+i,"",company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="0"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="0"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="0"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>

			 <td>
				<select name="debitcredit<%=i%>"  onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged()">
					<option value="1">Dr</option>
					<option value="-1">Cr</option>
				</select>
			</td>
			</tr>
	   <%}%>


		<%
		//read the last pages final amounts
		String amountFinalTotal = request.getParameter("amountFinalTotal");
		String localamountFinalTotal = request.getParameter("localamountFinalTotal");
		%>
	   <tr>
		<td colspan=8>Total </td>
		<td align=left>
		<input type=text size=7 name=amountFinalTotal readonly value="<%=amountFinalTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountFinalTotal readonly value="<%=localamountFinalTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>

		<tr>
		<td colspan=13> Narration <input type=text name=narration size=100 value="<%=narration%>">
		</tr>

		</table>
		<tr>
		<td>
		</table>

<%
}//end of if 
else //this portion is for consignment confirm
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
		<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="<%=oldlotid[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=rtid<%=i%> value="<%=rtid[i]%>" >

		<tr>
		<td><%=(i+1)%></td>
		<td><%=lotno[i]%>
		<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>" id=lotno<%=i%> ></td>
		<td><%=description[i]%>
		<input type=hidden name=description<%=i%> value="<%=description[i]%>"  id=description<%=i%>></td>
		<td><%=dsize[i]%>
		<input type=hidden name=dsize<%=i%>  value="<%=dsize[i]%>"  id=dsize<%=i%> ></td>
		<td><input type=text name=originalQty<%=i%> size=7 value="<%=originalQty[i]%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right"></td>
		<td><input type=text name=returnQty<%=i%> size=7 value="<%=returnQty[i]%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right"></td>
		<td>
		<input type=text name=rejection<%=i%> size=3 value="<%=rejection[i]%>" readonly  style="text-align:right;background:#CCCCFF"></td>
		<td>
		<input type=text name=rejectionQty<%=i%> size=7 value="<%=rejectionQty[i]%>" onBlur="nochk(this,3); recalculateQty('<%=i%>');" style="text-align:right"></td>
		<td><input type=text name=qty<%=i%> readonly size=7 value="<%=qty[i]%>" onBlur="nochk(this,3)" style="text-align:right;background:#CCCCFF"></td>
		<input type=hidden name=oldqty<%=i%> value="<%=oldqty[i]%>" >
		<td><input type=hidden name=rate<%=i%> size=7 value="<%=rate[i]%>"  style="text-align:right" id=rate<%=i%>>
		<input type=text size=7 name=effrate<%=i%> value="<%=effrate[i]%>"  style="text-align:right" onBlur="nochk(this,3); calculateEffRate('<%=i%>');" id=effrate<%=i%> >
		<input type=hidden name=localrate<%=i%> value="<%=localrate[i]%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="<%=efflocalrate[i]%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<td><input type=text name=amount<%=i%> size=7 value="<%=amount[i]%>" onBlur="nochk(this,3)" style="text-align:right" ></td>
		<td><input type=text name=localamount<%=i%> size=7 value="<%=localamount[i]%>" onBlur="nochk(this,3)" style="text-align:right"></td>
		<td><input type=text name=remarks<%=i%> size=10 value="<%=remarks[i]%>" style="text-align:left"></td>
		<td><input type=text name=lotDiscount<%=i%> size=7 value="<%=lotDiscount[i]%>" style="text-align:left" onBlur="checkDiscount(this); calculateEffRate('<%=i%>');"></td>
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
		<input type=hidden name=oldLotRows value="<%=lotRows+newLotRows%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows+newLedgerRows%>">
		<input type=text size=7 name=originalQtyTotal readonly value="<%=originalQtyTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=returnQtyTotal readonly value="<%=returnQtyTotal%>" style="background:#CCCCFF" style="text-align:right">
		</td>
		<td>&nbsp;</td>
		<td align=left>
		<input type=text size=7 name=rejectQtyTotal readonly value="<%=rejectQtyTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=qtyTotal readonly value="<%=qtyTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td>&nbsp;</td>
		<td align=left>
		<input type=text size=7 name=amountTotal readonly value="<%=amountTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountTotal readonly value="<%=localamountTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>
		<%//add old ledger rows
		//Read the values of the old ledger rows and display them
		String ftid[] = new String[oldLedgerRows];
		String deleteLedger[] = new String[oldLedgerRows];
		String ledger[] = new String[oldLedgerRows];
		String ledgerPercent[] = new String[oldLedgerRows];
		String ledgerAmount[] = new String[oldLedgerRows];
		String ledgerLocalAmount[] = new String[oldLedgerRows];
		String debitcredit[] = new String[oldLedgerRows];

		for(int i=0; i<oldLedgerRows; i++)
		{
			ftid[i] = request.getParameter("ftid"+i);
			deleteLedger[i] = request.getParameter("deleteLedger"+i);
			ledger[i] = request.getParameter("ledger"+i);
			ledgerPercent[i] = request.getParameter("ledgerPercent"+i);
			ledgerAmount[i] = request.getParameter("ledgerAmount"+i);
			ledgerLocalAmount[i] = request.getParameter("ledgerLocalAmount"+i);
			debitcredit[i] = request.getParameter("debitcredit"+i);
		%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');" <%if("yes".equals(deleteLedger[i])) 				{out.print("checked");}%>></td>
			<td colspan=8 align=right><%=A.getArray(cong,"Ledger","ledger"+i,""+ledger[i],company_id+"and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="<%=ledgerAmount[i]%>"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="<%=ledgerLocalAmount[i]%>"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>
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

		<%//add new ledger rows
		for(int i=oldLedgerRows; i<(oldLedgerRows+newLedgerRows); i++)
		{%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="0">
			<td><input type="checkbox" name="deleteLedger<%=i%>" value='yes'" onClick="deleteLedgerRow('<%=i%>');"></td>
			<td colspan=8 align=right><%=A.getArray(cong,"Ledger","ledger"+i,"",company_id+"and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
			<input type=text size=3 name=ledgerPercent<%=i%> value="0"  style="text-align:right" onBlur="validate(this); percentLedgerChanged(<%=i%>);">
			 % </td>
			<td align=left>
			<input type=text size=7 name=ledgerAmount<%=i%> value="0"  style="text-align:right" onBlur="validate(this); ledgerAmountChanged(<%=i%>);"></td>
			<td align=left>
			<input type=text size=7 name=ledgerLocalAmount<%=i%> value="0"  style="text-align:right" onBlur="validate(this); ledgerLocalAmountChanged(<%=i%>);"></td>

			 <td>
				<select name="debitcredit<%=i%>"  onchange="ledgerAmountChanged(<%=i%>); debitcreditChanged()">
					<option value="1">Dr</option>
					<option value="-1">Cr</option>
				</select>
			</td>
			</tr>
	   <%}%>


		<%
		//read the last pages final amounts
		String amountFinalTotal = request.getParameter("amountFinalTotal");
		String localamountFinalTotal = request.getParameter("localamountFinalTotal");
		%>
	   <tr>
		<td colspan=10>Total </td>
		<td align=left>
		<input type=text size=7 name=amountFinalTotal readonly value="<%=amountFinalTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		<td align=left>
		<input type=text size=7 name=localamountFinalTotal readonly value="<%=localamountFinalTotal%>" style="background:#CCCCFF" style="text-align:right"></td>
		</tr>


		<tr>
		<td colspan=14> Narration <input type=text name=narration size=100 value="<%=narration%>">
		</tr>

		</table>
		</td>
		</tr>
	</table>




<%}//end of else %>
<br><br>
<table width='100%' cellpadding=0 cellspacing=0>
<tr>
<td colspan=1 align=center>
	<input type=button name=command value=BACK class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="history.go(-1);" >
</td>
<%if("PurchaseEdit".equals(EditType))
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
 
}//end if ('ADD')


if("NEXT".equals(command))
{
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid));

newLotRows = 0;
newLedgerRows = 0;
//C.returnConnection(cong);
 
//--------------------String Date To Date Variable----------------------------------------

//Reading the data from the previous file

int invalidLots = 0;

String purchase_no = request.getParameter("purchase_no");
String ref_no = request.getParameter("ref_no");
String currency = request.getParameter("currency");
String companyparty_name = request.getParameter("companyparty_name");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String datevalue = request.getParameter("datevalue");
String duedays = request.getParameter("duedays");
String duedate = request.getParameter("duedate");
String purchase_type = request.getParameter("purchase_type");
String location_id0 = request.getParameter("location_id0");
String category_id = request.getParameter("category_id");
String exchange_rate = request.getParameter("exchange_rate");
String purchaseperson_id = request.getParameter("purchaseperson_id");
String broker_id = request.getParameter("broker_id");
String broker_remarks = request.getParameter("broker_remarks");


//check whether the companyparty_name exists or not.

String companyQuery = "Select CompanyParty_Id from Master_CompanyParty where company_id="+company_id+" and Active=1 and Purchase=1 and CompanyParty_Name like '"+companyparty_name+"'";

pstmt_g = cong.prepareStatement(companyQuery);
rs_g = pstmt_g.executeQuery();

long companyparty_id = 0;

while(rs_g.next())
{
	companyparty_id = rs_g.getLong("CompanyParty_Id");
}
pstmt_g.close();

if(companyparty_id == 0)
	{
		out.print("<br><center><font color=red>Company name \""+companyparty_name+"\" does not exist. </font></center>");
		out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1'></center>");

	}

else
	{



%>	

<body background="../Buttons/BGCOLOR.JPG" >
<form name=mainform action="cgtConfirmOrPurchaseEditFormUpdate.jsp"   method=post >
<input type=hidden name="Receive_Id" value="<%=Receive_Id%>">

<table bordercolor=red align=center border=1  cellspacing=0 cellpadding=2 width="100%">
<tr><td>

<tr>
<th colspan=15 align=center >
	<%if("PurchaseEdit".equals(EditType))
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

	<table  border=1 width="100%" cellspacing=0 cellpadding=2 bordercolor=#AAD6F9>

	<tr>
		<td>Inv No:</td><td><%=purchase_no%>
		<input type=hidden name=purchase_no size=4 value="<%=purchase_no%>" readonly style="background:#CCCCFF">  

		</td>
		<td>Ref No</td><td><%=ref_no%>
		<input type=hidden name=ref_no value="<%=ref_no%>">
		</td>
		<td >Currency </td><td colspan=3>

		<%	
		if("local".equals(currency))
		{
		%>
			<input type=hidden name=currency value=local>Local
		<%}
		else
		{%>
			<input type=hidden name=currency value=dollar> Dollar
		<%}
		%>
		</td>

		<td>
		From 
		</td><td><%=companyparty_name%> <input type=hidden name=companyparty_name value="<%=companyparty_name%>" id=companyparty_name>
		<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
		</td>
		<td colspan=2>
		Purchase Group </td>
		<td> <%=A.getName(cong,"PurchaseSaleGroup",purchasesalegroup_id)%>	
		<input type=hidden name=purchasesalegroup_id value="<%=purchasesalegroup_id%>"
		</td>

	</tr>

	</tr>
		<td colspan=2>
		Invoice Date
		</td> 
		<td colspan=2>
		<%=format.format(format.getDate(datevalue))%>
		<input type=hidden name='datevalue' value="<%=format.format(format.getDate(datevalue))%>"
		>
		</td>

		<td colspan=2>Due Days</td>
		<td colspan=2><%=duedays%><input type=hidden name='duedays' value="<%=duedays%>"></td>

		<td colspan=2>
		Due Date			 
		 </td>

		 <td colspan=2><%=format.format(format.getDate(duedate))%>
		 <input type=hidden name='duedate' value="<%=format.format(format.getDate(duedate))%>" >
		</td>
	</tr>

	<tr>
		<td colspan=2>Type</td>

		<td colspan=2>
		<%if("0".equals(purchase_type))
		{%>
		Regular
		<%}
		else
		{
			out.print(A.getNameCondition(cong, "Master_Account", "Account_Name", " WHERE where AccountType_Id=6 and Company_Id="+company_id+" and Active=1 and Account_Id="+purchase_type));
		}%>
		</td>
			<input type=hidden name="purchase_type" value="<%=purchase_type%>">
		
		<td colspan=2>Location </td>
		<td colspan=2> 
		<%=A.getName(cong,"Location",location_id0)%>	
		<input type=hidden name='location_id0' value="<%=location_id0%>" >
		</td>

		<td colspan=2>Category </td>
		<td colspan=3><%=A.getName(cong,"LotCategory",category_id)%>	
		<input type=hidden name='category_id' value="<%=category_id%>" >
		</td>

	</tr>

	<tr>
		<td colspan=2>Exchange Rate </td>
		<td colspan=2><%=str.mathformat(exchange_rate,3)%>
		<input type=hidden name=exchange_rate  value="<%=str.mathformat(exchange_rate,3)%>" >
		 </td>
		<td colspan=2>Purchase Person  </td>
		<td colspan=3><%=A.getName(cong,"SalesPerson",purchaseperson_id)%></td>
		<input type=hidden name='purchaseperson_id' value="<%=purchaseperson_id%>" >
		
		<td >Broker </td>

		<td>	<%=A.getName(cong,"SalesPerson",broker_id)%>
	<input type=hidden name='broker_id' value="<%=broker_id%>">
		</td>
		<td> <%=broker_remarks%>
	<input type=hidden name=broker_remarks size=5 value="<%=broker_remarks%>" style="text-align:left"></td>
	</tr>
	</table>
</td></tr>
<tr><td>

<%
//Reading the data of the previous lots.
String rtid[] = new String[lotRows];
String lotid[] = new String[lotRows];
String oldlotid[] = new String[lotRows];
String lotno[] = new String[lotRows];
String description[] = new String[lotRows];
String dsize[] = new String[lotRows];
String originalQty[] = new String[lotRows];
String returnQty[] = new String[lotRows];
String rejection[] = new String[lotRows];
String rejectionQty[] = new String[lotRows];
String qty[] = new String[lotRows];
String oldqty[] = new String[lotRows];
String rate[] = new String[lotRows];
String effrate[] = new String[lotRows];
String localrate[] = new String[lotRows];
String efflocalrate[] = new String[lotRows];
String amount[] = new String[lotRows];
String localamount[] = new String[lotRows];
String remarks[] = new String[lotRows];
String lotDiscount[] = new String[lotRows];
String delete[] = new String[lotRows];

for(int i=0; i<lotRows; i++)
{
	rtid[i] = request.getParameter("rtid"+i);
	lotid[i] = request.getParameter("lotid"+i);
	oldlotid[i] = request.getParameter("oldlotid"+i);
	lotno[i] = request.getParameter("lotno"+i);
	description[i] = request.getParameter("description"+i);
	dsize[i] = request.getParameter("dsize"+i);
	originalQty[i] = request.getParameter("originalQty"+i);
	returnQty[i] = request.getParameter("returnQty"+i);
	rejection[i] = request.getParameter("rejection"+i);
	rejectionQty[i] = request.getParameter("rejectionQty"+i);
	qty[i] = request.getParameter("qty"+i);
	oldqty[i] = request.getParameter("oldqty"+i);
	rate[i] = request.getParameter("rate"+i);
	effrate[i] = request.getParameter("effrate"+i);
	localrate[i] = request.getParameter("localrate"+i);
	efflocalrate[i] = request.getParameter("efflocalrate"+i);
	amount[i] = request.getParameter("amount"+i);
	localamount[i] = request.getParameter("localamount"+i);
	remarks[i] = request.getParameter("remarks"+i);
	lotDiscount[i] = request.getParameter("lotDiscount"+i);
	delete[i] = request.getParameter("delete"+i);

	if("PurchaseEdit".equals(EditType))
	{
		if(! ("".equals(lotid[i])) )	
		 {
			 //check whether the lot exists or not.

			String lotQuery = "Select L.Lot_Id, L.Lot_No from Lot L, Diamond D, Master_Size MS, Master_Description MD where L.Lot_Id=D.Lot_Id and  L.company_id="+company_id+" and L.Active=1 and MS.Active=1 and MD.Active=1 and D.D_Size=MS.Size_Id and D.Description_Id=MD.Description_Id and MS.Size_Name = '"+dsize[i]+"' and MD.Description_Name='"+description[i]+"'";

			pstmt_g = cong.prepareStatement(lotQuery);
			rs_g = pstmt_g.executeQuery();

			long lot_id = 0;

			while(rs_g.next())
			{
				lot_id = rs_g.getLong("Lot_Id");
				lotid[i]=""+lot_id;
				lotno[i]=rs_g.getString("Lot_No");
			}
			pstmt_g.close();

			if(lot_id == 0)
			{
				 lotid[i]="X";
				 lotno[i]="X";
				 
			}
		 }
	}
}


String originalQtyTotal = request.getParameter("originalQtyTotal");
String returnQtyTotal = request.getParameter("returnQtyTotal");
String rejectQtyTotal = request.getParameter("rejectQtyTotal");
String qtyTotal = request.getParameter("qtyTotal");
String amountTotal = request.getParameter("amountTotal");
String localamountTotal = request.getParameter("localamountTotal");
String narration = request.getParameter("narration");


%>

<%if("PurchaseEdit".equals(EditType))
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
		int j=0;
		for (int i=0;i<lotRows;i++)
		{
			if("".equals(lotid[i]))
			{
				invalidLots++;
				continue;
				
			}
			if("X".equals(lotid[i]))
			{
			%>
			<tr bgcolor=red>
			<td>X</td>
			<td><%=lotno[i]%></td>
			<td><%=description[i]%></td>
			<td><%=dsize[i]%></td>
			<td align=right><%=str.mathformat(""+originalQty[i],3)%></td>
			<td align=right><%=str.mathformat(""+returnQty[i],3)%></td>
			<td align=right><%=str.mathformat(""+qty[i],3)%></td>
			<td align=right><%=str.mathformat(""+effrate[i],3)%></td>
			<td align=right><%=str.mathformat(""+amount[i],3)%></td>
			<td align=right><%=str.mathformat(""+localamount[i],3)%></td>
			<td><%=remarks[i]%></td>
			<td><%=lotDiscount[i]%></td>
			</tr>


			<%
			invalidLots++;
			continue;
			}
			%>
		
		<input type=hidden name=lotid<%=j%> value="<%=lotid[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=j%> value="<%=oldlotid[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=rtid<%=i%> value="<%=rtid[i]%>" >
		<input type=hidden name=delete<%=i%> value="<%=delete[i]%>" id=delete<%=i%>>

		<%if("yes".equals(delete[i]))
		{%>
			<tr bgcolor="#CC6699">
		<%}
		else
		{%>
			<tr>
		<%}%>
		<td><%=(j+1)%></td>
		<td><%=lotno[i]%>
		<input type=hidden name=lotno<%=j%> value="<%=lotno[i]%>" id=lotno<%=i%> ></td>
		<td><%=description[i]%>
		<input type=hidden name=description<%=j%> value="<%=description[i]%>" id=description<%=j%>></td>
		<td><%=dsize[i]%>
		<input type=hidden name=dsize<%=j%> value="<%=dsize[i]%>"   id=dsize<%=j%>></td>
		<td align=right><%=originalQty[i]%>
		<input type=hidden name=originalQty<%=j%>  value="<%=originalQty[i]%>" ></td>
		<td align=right><%=returnQty[i]%>
		<input type=hidden name=returnQty<%=j%> value="<%=returnQty[i]%>" ></td>
		<input type=hidden name=rejection<%=j%> value="<%=rejection[i]%>" >
		<input type=hidden name=rejectionQty<%=j%> value="<%=rejectionQty[i]%>" >
		<td align=right><%=qty[i]%>
		<input type=hidden name=qty<%=j%> value="<%=qty[i]%>"></td>
		<input type=hidden name=oldqty<%=i%> value="<%=oldqty[i]%>" >
		<td align=right><%=effrate[i]%>
		<input type=hidden name=rate<%=j%>  value="<%=rate[i]%>" style="text-align:right" id=rate<%=i%>>
		<input type=hidden name=effrate<%=j%> value="<%=effrate[i]%>"  id=effrate<%=i%>>
		<input type=hidden name=localrate<%=j%> value="<%=localrate[i]%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=j%> value="<%=efflocalrate[i]%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<td align=right><%=amount[i]%>
		<input type=hidden name=amount<%=j%> size=7 value="<%=amount[i]%>"  ></td>
		<td align=right><%=localamount[i]%>
		<input type=hidden name=localamount<%=j%>  value="<%=localamount[i]%>" ></td>
		<td> <%=remarks[i]%>
		<input type=hidden name=remarks<%=j%> value="<%=remarks[i]%>" ></td>
		<td><%=lotDiscount[i]%>
		<input type=hidden name=lotDiscount<%=j%>  value="<%=lotDiscount[i]%>" ></td>
		</tr>
		<%
			j++;
			}
		%>


		<tr>
		<td colspan=4>Inventory Total </td>
		<td align=right><%=originalQtyTotal%>
		<input type=hidden name=oldLotRows value="<%=lotRows + newLotRows - invalidLots%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows+newLedgerRows%>">
		<input type=hidden name=originalQtyTotal value="<%=originalQtyTotal%>">
		</td><td align=right><%=returnQtyTotal%>
		<input type=hidden name=returnQtyTotal value="<%=returnQtyTotal%>" >
		</td>
		<td align=right>
		<input type=hidden name=rejectQtyTotal readonly value="<%=rejectQtyTotal%>">
		<%=qtyTotal%>
		<input type=hidden name=qtyTotal value="<%=qtyTotal%>" ></td>
		<td>&nbsp;</td>
		<td align=right><%=amountTotal%>
		<input type=hidden name=amountTotal value="<%=amountTotal%>">
		</td>
		<td align=right><%=localamountTotal%>
		<input type=hidden name=localamountTotal value="<%=localamountTotal%>" >
		</td>
		</tr>
		<%//add old ledger rows
		//Read the values of the old ledger rows and display them
		String ftid[] = new String[oldLedgerRows];
		String deleteLedger[] = new String[oldLedgerRows];
		String ledger[] = new String[oldLedgerRows];
		String ledgerPercent[] = new String[oldLedgerRows];
		String ledgerAmount[] = new String[oldLedgerRows];
		String ledgerLocalAmount[] = new String[oldLedgerRows];
		String debitcredit[] = new String[oldLedgerRows];

		for(int i=0; i<oldLedgerRows; i++)
		{
			ftid[i] = request.getParameter("ftid"+i);
			ledger[i] = request.getParameter("ledger"+i);
			deleteLedger[i] = request.getParameter("deleteLedger"+i);
			ledgerPercent[i] = request.getParameter("ledgerPercent"+i);
			ledgerAmount[i] = request.getParameter("ledgerAmount"+i);
			ledgerLocalAmount[i] = request.getParameter("ledgerLocalAmount"+i);
			debitcredit[i] = request.getParameter("debitcredit"+i);
		%>
			<%if("yes".equals(deleteLedger[i]))
			{%>
				<tr bgcolor="#CC6699">
			<%}
			else
			{%>
				<tr>
			<%}%>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<input type=hidden name=deleteLedger<%=i%> value="<%=deleteLedger[i]%>">
			<td colspan=7 align=right>
			<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>">
		
			<%=A.getNameCondition(cong,"Ledger","Ledger_Name", " Where ledger_Id="+ledger[i]+" and yearend_id="+yearend_id+" And company_id="+company_id) %></td>
			<td align=right><%=ledgerPercent[i]%>
			<input type=hidden name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>">
			 % </td>
			<td align=right><%=ledgerAmount[i]%>
			<input type=hidden name=ledgerAmount<%=i%> value="<%=ledgerAmount[i]%>" ></td>
			<td align=right><%=ledgerLocalAmount[i]%>
			<input type=hidden name=ledgerLocalAmount<%=i%> value="<%=ledgerLocalAmount[i]%>" ></td>

			<input type=hidden name=debitcredit<%=i%> value="<%=debitcredit[i]%>" >
			<%if("1".equals(debitcredit[i])) {%>
				<td>Dr</td>
			<%} else { %>
				<td>Cr</td>
			<%}%>
			</tr>
		<%
		}
		
		//read the last pages final amounts
		String amountFinalTotal = request.getParameter("amountFinalTotal");
		String localamountFinalTotal = request.getParameter("localamountFinalTotal");
		%>

	   <tr>
		<td colspan=8>Total </td>
		<td align=right><%=amountFinalTotal%>
		<input type=hidden name=amountFinalTotal value="<%=amountFinalTotal%>" ></td>
		<td align=right><%=localamountFinalTotal%>
		<input type=hidden name=localamountFinalTotal value="<%=localamountFinalTotal%>"></td>
		</tr>

		<tr>
		<td colspan=13> Narration: <%=narration%>
		<input type=hidden name=narration value="<%=narration%>">
		</tr>

		</table>
		<tr>
		<td>
		</table>

<%
}//end of if 
else //this portion is for consignment confirm edit
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
		<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>" id=lotid<%=i%>>
		<input type=hidden name=oldlotid<%=i%> value="<%=oldlotid[i]%>" id=oldlotid<%=i%>>
		<input type=hidden name=rtid<%=i%> value="<%=rtid[i]%>" >

		<tr>
		<td><%=(i+1)%></td>
		<td><%=lotno[i]%>
		<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>" id=lotno<%=i%> ></td>
		<td><%=description[i]%>
		<input type=hidden name=description<%=i%> value="<%=description[i]%>"  id=description<%=i%>></td>
		<td><%=dsize[i]%>
		<input type=hidden name=dsize<%=i%>  value="<%=dsize[i]%>"  id=dsize<%=i%> ></td>
		<td align=right><%=originalQty[i]%>
		<input type=hidden name=originalQty<%=i%> value="<%=originalQty[i]%>" ></td>
		<td align=right><%=returnQty[i]%>
		<input type=hidden name=returnQty<%=i%> value="<%=returnQty[i]%>" ></td>
		<td align=right><%=rejection[i]%>
		<input type=hidden name=rejection<%=i%> value="<%=rejection[i]%>" ></td>
		<td align=right><%=rejectionQty[i]%>
		<input type=hidden name=rejectionQty<%=i%> value="<%=rejectionQty[i]%>"></td>
		<td align=right><%=qty[i]%>
		<input type=hidden name=qty<%=i%> value="<%=qty[i]%>"></td>
		<input type=hidden name=oldqty<%=i%> value="<%=oldqty[i]%>" >
		<td align=right><%=effrate[i]%>		
		<input type=hidden name=rate<%=i%> value="<%=rate[i]%>"  id=rate<%=i%>>
		<input type=hidden name=effrate<%=i%> value="<%=effrate[i]%>"   id=effrate<%=i%> >
		<input type=hidden name=localrate<%=i%> value="<%=localrate[i]%>"  style="text-align:right" id=localrate<%=i%>>
		<input type=hidden name=efflocalrate<%=i%> value="<%=efflocalrate[i]%>"  style="text-align:right" id=efflocalrate<%=i%>></td>
		<td align=right><%=amount[i]%>
		<input type=hidden name=amount<%=i%> value="<%=amount[i]%>"  ></td>
		<td align=right><%=localamount[i]%>
		<input type=hidden name=localamount<%=i%> value="<%=localamount[i]%>" ></td>
		<td><%=remarks[i]%>
		<input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>" ></td>
		<td><%=lotDiscount[i]%>
		<input type=hidden name=lotDiscount<%=i%> value="<%=lotDiscount[i]%>" ></td>
		</tr>
		<%
			}
		%>
		<tr>
		<td colspan=4>Inventory Total </td>
		<td align=right><%=originalQtyTotal%>
		<input type=hidden name=oldLotRows value="<%=lotRows+newLotRows%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows+newLedgerRows%>">
		<input type=hidden name=originalQtyTotal value="<%=originalQtyTotal%>"></td>
		<td align=right><%=returnQtyTotal%>
		<input type=hidden name=returnQtyTotal value="<%=returnQtyTotal%>" >
		</td>
		<td>&nbsp;</td>
		<td align=right><%=rejectQtyTotal%>
		<input type=hidden name=rejectQtyTotal value="<%=rejectQtyTotal%>" ></td>
		<td align=right><%=qtyTotal%>
		<input type=hidden name=qtyTotal value="<%=qtyTotal%>" ></td>
		<td>&nbsp;</td>
		<td align=right><%=amountTotal%>
		<input type=hidden name=amountTotal value="<%=amountTotal%>" ></td>
		<td align=right><%=localamountTotal%>
		<input type=hidden name=localamountTotal value="<%=localamountTotal%>"></td>
		</tr>
		<%//add old ledger rows
		//Read the values of the old ledger rows and display them
		String ledger[] = new String[oldLedgerRows];
		String deleteLedger[] = new String[oldLedgerRows];
		String ftid[] = new String[oldLedgerRows];
		String ledgerPercent[] = new String[oldLedgerRows];
		String ledgerAmount[] = new String[oldLedgerRows];
		String ledgerLocalAmount[] = new String[oldLedgerRows];
		String debitcredit[] = new String[oldLedgerRows];

		for(int i=0; i<oldLedgerRows; i++)
		{
			ftid[i] = request.getParameter("ftid"+i);
			deleteLedger[i] = request.getParameter("deleteLedger"+i);
			ledger[i] = request.getParameter("ledger"+i);
			ledgerPercent[i] = request.getParameter("ledgerPercent"+i);
			ledgerAmount[i] = request.getParameter("ledgerAmount"+i);
			ledgerLocalAmount[i] = request.getParameter("ledgerLocalAmount"+i);
			debitcredit[i] = request.getParameter("debitcredit"+i);
		%>
			<tr>
			<input type=hidden name=ftid<%=i%> value="<%=ftid[i]%>">
			<input type=hidden name=deleteLedger<%=i%> value="<%=deleteLedger[i]%>">
			<td colspan=9 align=right>
			<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>">
			<%=A.getNameCondition(cong,"Ledger","Ledger_Name", " Where ledger_Id="+ledger[i]+" and yearend_id="+yearend_id+" And company_id="+company_id) %>
			</td>
			<td align=right><%=ledgerPercent[i]%>
			<input type=hidden name=ledgerPercent<%=i%> value="<%=ledgerPercent[i]%>"> % </td>
			<td align=right><%=ledgerAmount[i]%>
			<input type=hidden name=ledgerAmount<%=i%> value="<%=ledgerAmount[i]%>" ></td>
			<td align=right><%=ledgerLocalAmount[i]%>
			<input type=hidden name=ledgerLocalAmount<%=i%> value="<%=ledgerLocalAmount[i]%>"></td>
			<input type=hidden name=debitcredit<%=i%> value="<%=debitcredit[i]%>" >
			<%if("1".equals(debitcredit[i])) {%>
				<td>Dr</td>
			<%} else { %>
				<td>Cr</td>
			<%}%>
			</tr>
		<%
		}
		
		//read the last pages final amounts
		String amountFinalTotal = request.getParameter("amountFinalTotal");
		String localamountFinalTotal = request.getParameter("localamountFinalTotal");
		%>
	   <tr>
		<td colspan=10>Total </td>
		<td align=right><%=amountFinalTotal%>
		<input type=hidden name=amountFinalTotal value="<%=amountFinalTotal%>"></td>
		<td align=right><%=localamountFinalTotal%>
		<input type=hidden name=localamountFinalTotal value="<%=localamountFinalTotal%>" ></td>
		</tr>


		<tr>
		<td colspan=14> Narration: <%=narration%>
		<input type=hidden name=narration size=100 value="<%=narration%>">
		</tr>

		</table>
		</td>
		</tr>
	</table>




<%}//end of else %>
<br><br>
<table width='100%' cellpadding=0 cellspacing=0>
<tr>
<td colspan=1 align=center>&nbsp;
 <input type=button name=command value="BACK" class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="history.go(-1);"> 
</td>
<%if((lotRows-invalidLots) > 0)
{%>
	<td colspan=1 align=center>
	<input type=submit name=command  value="SAVE" class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" >
	</td>
	
	
<%}%>
</td>
</tr>
</table>
</form>
<%

	}//end of else

}//end if ('NEXT')

C.returnConnection(cong);
}
catch(Exception Samyak188){ 
C.returnConnection(cong);
out.println("<font color=red> FileName : cgtConfirmOrPurchase.jsp <br>Bug No Samyak188 <br>Please Contact Samyak Admin <br> bug is  "+ Samyak188 +"</font>");}
%> 