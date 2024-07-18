<!--            Modified By=>Dattatraya 
					Date=>30/12/2005
				Add/Modify Funtions=>
					 calcTotal(),finalTotal(),calcLedgerRow(),
					 calcDebitCredit(), CtaxCal()
-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array"/>
<jsp:useBean id="C"   scope="application" class="NipponBean.Connect"/>
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<jsp:useBean id="AC"  class="NipponBean.ArrayCSS" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<% 
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;

PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

try	{
	conp=C.getConnection();
	cong=C.getConnection();
//	cong=C.getConnection();
	}
catch(Exception e31)
	{ 
	out.println("<font color=red> FileName : EditSaleForm1.jsp<br>Bug No e31 : "+ e31);
	}
//System.out.println("29************ in editsale form1.jsp");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String company_name= A.getName(cong,"companyparty",company_id);
String local_currencysymbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
String errline="42";
  int d_org=d;
//out.print("<br> 45");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br><center><font color=red>command=" +command+"</font></center>");
String startDate = format.format(YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(cong,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);

//out.print("<br> 65");
%>



<%
try{	

if("try".equals(command))
{
	out.println("<h1> Under contruction  Thanks </h1>");
}

if("sedit".equals(command))
{

	String tempFlag=request.getParameter("tempFlag"); 

%>
	<input type=hidden name=tempFlag value="<%=tempFlag%>">
<%

//out.print("<br> 83");
//out.println("Inside Sale Edit ");
String receive_id=request.getParameter("receive_id");
//out.print("<br>receive_id=" +receive_id);
String tempv=""+A.getNameCondition(cong,"Voucher","Voucher_Id"," where Voucher_No='"+receive_id+"'");
String ref_no=""+A.getNameCondition(cong,"Voucher","Ref_No"," where Voucher_Id="+tempv);
//out.print("<br>ref_no=" +ref_no);
String description=""+A.getNameCondition(cong,"Voucher","Description"," where Voucher_Id="+tempv);
//out.print("<br>description=" +description);
int Iv_id=Integer.parseInt(request.getParameter("Iv_id"));
//out.print("<br>Iv_id=" +Iv_id);

int Fv_id=Integer.parseInt(request.getParameter("Fv_id"));
//out.print("<br>Fv_id=" +Fv_id);

int pdcount=0;
String Inv_id=""+Iv_id;
String Finv_id=""+Fv_id;
if(Fv_id==0 && Iv_id==0)
	{
		String pdquery="select * from Payment_Details where (For_Head=9 or For_Head=10) and Active=1 and For_HeadId="+receive_id;

        //out.print("<br>75 Receive_id: "+receive_id);
		pstmt_p=conp.prepareStatement(pdquery);
		rs_g=pstmt_p.executeQuery();

		while(rs_g.next())
		{
			pdcount++;
		}

Inv_id=A.getNameCondition(cong,"Voucher","Voucher_Id","where Voucher_No='"+receive_id+"' and Voucher_Type=1 and Active=1");
//out.print("<br>85 receive_id "+receive_id);
//out.print("<br>86 Inv_id "+Inv_id);

Finv_id=A.getNameCondition(cong,"Voucher","Voucher_Id","where Referance_VoucherId="+receive_id+" and Voucher_Type=8 and Active=1");
//out.print("<br>89 Inv_id "+Inv_id);
if("".equals(Finv_id))
	{
		Finv_id="0";
	}

//out.print("<br>80 Finv_id "+Finv_id);

//out.print("<br> 127");

	}
//System.out.println("126 in editsale form1.jsp");
java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date stockdate = new java.sql.Date(System.currentTimeMillis());

double exchange_rate=0;
double ctax = 0;
double discount = 0;
double total = 0;
double org_receivetotal = 0;
double subtotal=0;
int counter=0;
java.sql.Date receive_date = new java.sql.Date(System.currentTimeMillis());
String receive_no="";
String currency_id="";
String companyparty_id="";
String receive_companyid="";
String receive_byname="";
String receive_fromname="";
String duedays="";
String salesperson_id="";
double Difference_Amount=0;
String narr="";
String refno="";
String purchasesalegroup_id="";
//out.print("<br> 153");
String query="Select * from Receive where Receive_Id=?";
//out.println("Query12"+query);
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		receive_no=rs_g.getString("Receive_No");
		receive_date=rs_g.getDate("Receive_Date");
		counter=rs_g.getInt("Receive_Lots");
		currency_id=rs_g.getString("Receive_CurrencyId");
		if("0".equals(currency_id))
					{d=2;}
		exchange_rate=rs_g.getDouble("Exchange_rate");
		ctax=rs_g.getDouble("Tax");
		discount=rs_g.getDouble("discount");
		total= str.mathformat(rs_g.getDouble("Receive_Total"),d);
		org_receivetotal=total;
		companyparty_id=rs_g.getString("Receive_FromId");
		receive_fromname=rs_g.getString("Receive_FromName");
		receive_companyid=rs_g.getString("Company_Id");
		receive_byname=rs_g.getString("Receive_ByName");
		due_date=rs_g.getDate("Due_Date");
		stockdate=rs_g.getDate("Stock_Date");
		duedays=rs_g.getString("Due_Days");
		salesperson_id=rs_g.getString("SalesPerson_Id");
		Difference_Amount=rs_g.getDouble("Difference_Amount");
		purchasesalegroup_id=rs_g.getString("PurchaseSaleGroup_Id");
		/*narr=rs_g.getString("Description");
		  if(rs_g.wasNull())
			{narr="--";}
		refno=rs_g.getString("Reference_No");
		  if(rs_g.wasNull())
			{refno="--";}*/
			//out.print("<br>  188 under  while ");
	}
	pstmt_g.close();
//	System.out.println("186 currency_id=" +currency_id);

	if("null".equals(salesperson_id))
	{
		salesperson_id=""+0;
	}


	int itoday_day=receive_date.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(receive_date.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(receive_date.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;


	company_name="";
	String company_address="";
	String company_city="";
	String company_country="";
	String company_phone_off="";

	String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+receive_companyid;
	pstmt_p = cong.prepareStatement(company_query);
//	System.out.println("212 company_query=>"+company_query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
		//out.println("Inside While 50");
		company_name= rs_g.getString("CompanyParty_Name");	company_address= rs_g.getString("Address1");	
		company_city= rs_g.getString("City");		
		company_country= rs_g.getString("Country");		
		company_phone_off= rs_g.getString("Phone_Off");		
	}

	pstmt_p.close();

	//out.println("<BR>counter= "+counter);
	//out.println("<BR>company id is= "+companyparty_id);
	String companyparty_name="";
	String address1="";
	String city="";
	String country="";
	String phone_off="";

	String company_queryy="select * from Master_CompanyParty where active=1 and companyparty_id="+companyparty_id;
	pstmt_p = cong.prepareStatement(company_queryy);
	//System.out.println("<"+company_queryy);
	rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
		//out.println("Inside While 50");
		companyparty_name= rs_g.getString("CompanyParty_Name");		
		address1= rs_g.getString("Address1");		
		city= rs_g.getString("City");		
		country= rs_g.getString("Country");		
		phone_off= rs_g.getString("Phone_Off");		

		}
	pstmt_p.close();

	//out.println("<br>Outsude  While 59");
//out.print("<br> 255");
double originalQuantity[]=new double[counter];
double returnQuantity[]=new double[counter];
double ghat[]=new double[counter];
double quantity[]=new double[counter];
double rate[]=new double[counter];
double amount[]=new double[counter];
String lotDiscount[]=new String[counter];
double ctax_amt=0;
double temp_amt=0;
double discount_amt=0;
String remarks[]=new String[counter]; 
String receivetransaction_id[]=new String[counter]; 
String lot_id[]=new String[counter]; 
String location_id[]=new String[counter]; 
String lot_no[]=new String[counter]; 
String pcs[]=new String[counter];
double calcqty[]=new double[counter]; 
query="Select * from Receive_Transaction where Receive_Id=? and Active=1";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
		{
receivetransaction_id[n]=rs_g.getString("ReceiveTransaction_id");
lot_id[n]=rs_g.getString("Lot_Id");
//out.print("<br>182lot_id[n]="+lot_id[n]);
location_id[n]=rs_g.getString("Location_Id");
originalQuantity[n]= rs_g.getDouble("Original_Quantity");
returnQuantity[n]= rs_g.getDouble("Return_Quantity");
quantity[n]= rs_g.getDouble("Quantity");
rate[n]= rs_g.getDouble("Receive_Price"); 
pcs[n]=rs_g.getString("Pieces");
lotDiscount[n]=rs_g.getString("Lot_Discount");
remarks[n]=rs_g.getString("Remarks"); 
amount[n]= str.mathformat((quantity[n] * rate[n]),d) ;
subtotal += amount[n]; 
calcqty[n]=originalQuantity[n]-returnQuantity[n];
ghat[n]=calcqty[n]-quantity[n];
rate[n]=str.mathformat(rate[n],3);
n++;
		}//while

//System.out.println("264 query=>"+query);
pstmt_g.close();
//out.print("<br> 291");
discount_amt = subtotal * (discount/100);
//out.println("<font color=red>discount_amt:</font>"+discount_amt);
temp_amt = subtotal - discount_amt;
ctax_amt = temp_amt * (ctax/100);
total= temp_amt + ctax_amt;
//out.print("<br>subtotal=" +subtotal);
//out.print("<br>ctax_amt=" +ctax_amt);
//out.print("<br>total=" +total);

for (int i=0;i<counter;i++)
{
lot_no[i]=A.getName(conp,"Lot", "Lot_No", lot_id[i]);
}//for



String currency_symbol=I.getSymbol(conp,currency_id);
/*
//int d=0;
if("0".equals(currency_id))
{
currency_symbol="US $";
d=2;
}
*/

//out.print("<br>314 receive_id "+receive_id);
String testvoucher_id=  A.getNameCondition(cong,"Voucher","Voucher_Id","Where Voucher_Type=2 and Voucher_No='"+receive_id+"'" );
testvoucher_id= "0";
//out.print("<br>316 testvoucher_id "+testvoucher_id);
String ctax_id= A.getNameCondition(conp,"Ledger","ledger_id","Where Ledger_Name='C. Tax' and Company_id="+company_id+"" ); 
//out.print("<br>318 ctax_id "+ctax_id);

int ledgers= Integer.parseInt(A.getNameCondition(conp,"Voucher","ToBy_Nos","Where Voucher_Type=1 and Voucher_No='"+receive_id+"'"));
//out.println("<br>322  ledgers "+ledgers);

%>
<html>
<head><title>Samyak Software</title>
<script language="JavaScript">

<%
	String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Sale=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_p = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var companyArray=new Array("+companyArray+");");


	String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
	pstmt_p = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");


%>

function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate

function calcLedgers()
{
	var subtotal1=0;
<%
	for(int i=0;i<ledgers;i++)
	{%>
		if(!document.mainform.findeleted<%=i%>.checked)
		{
		var le_amt<%=i%>=parseFloat(document.mainform.acamount<%=i%>.value)
		var le_db<%=i%>=parseFloat(document.mainform.debitcredit<%=i%>.value)
		le_amt<%=i%>=le_amt<%=i%>*(le_db<%=i%>*-1);
		subtotal1=subtotal1+le_amt<%=i%>;
		}
	<%}%>
//	alert(subtotal1);
	return subtotal1;
}

function recalculateQty(rowNum){

	var orgQtyName = "originalQuantity"+rowNum;
	var retQtyName = "returnQuantity"+rowNum;
	var ghatName = "ghat"+rowNum;
	var qtyName = "quantity"+rowNum;
	var finalquantity = parseFloat(document.mainform.elements[orgQtyName].value) - parseFloat(document.mainform.elements[retQtyName].value) - parseFloat(document.mainform.elements[ghatName].value); 
	
	if(finalquantity < 0)
	{
		alert("Quantity will be Negative for row:"+(parseInt(rowNum)+1));
		return false;
	}

	document.mainform.elements[qtyName].value = finalquantity.toFixed(3);
}

function Discount(rowNum){
		var lotdiscountName = "lotDiscount"+rowNum;
		var rateName = "rate"+rowNum;	
//alert("Ratename="+rateName);

	var lotDiscount = document.mainform.elements[lotdiscountName].value;
	var discountPercents = lotDiscount.split(':');

	for(i=0; i<discountPercents.length; i++)
	{
		var discount = discountPercents[i];
		if(isNaN(discount))
		{
			return false;
		}
//alert("discount="+discount);
		rate = rate + (document.mainform.elements[rateName].value  * discount) / 100;
	}
	document.mainform.elements[rateName].value = rate.toFixed(3);
}

function percentLedgerChanged(rowNum)
{
	
	{
		var initialValue = parseFloat(document.mainform.subtotal.value);
		
		if(initialValue != 0)
		{
			for(var i=0; i<rowNum; i++)
			{
				var drcrName = "debitcredit"+i;
				var ledgerLocalAmtName = "ledgerLocalAmount"+i;
						
				initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerLocalAmtName].value));

			}
			
			for(var i=rowNum; i<<%=(ledgers)%>; i++)
			{
			
				var perName = "ledgerPercent"+i;
				var perValue = document.mainform.elements[perName].value;
				var ledgerAmt = (initialValue * perValue) / 100;

				var ledgerAmtName = "ledgerAmount"+i;
				var ledgerlocalAmtName = "ledgerLocalAmount"+i;


				document.mainform.elements[ledgerlocalAmtName].value = ledgerAmt.toFixed(3);
				document.mainform.elements[ledgerAmtName].value = (document.mainform.elements[ledgerlocalAmtName].value / parseFloat(document.mainform.exchange_rate.value)).toFixed(3);

				var drcrName = "debitcredit"+i;
				var ledgerAmtName = "ledgerAmount"+i;
						
				initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerlocalAmtName].value));

			}
		}
	}//end of if local
	else
	{
		var initialValue = parseFloat(document.mainform.amountTotal.value);

		if(initialValue != 0)
		{
			
			
			for(var i=0; i<rowNum; i++)
			{
				var drcrName = "debitcredit"+i;
				var ledgerAmtName = "ledgerAmount"+i;
						
				initialValue +=  ( parseFloat(document.mainform.elements[drcrName].value) * parseFloat(document.mainform.elements[ledgerAmtName].value));

			}
			
			for(var i=rowNum; i<<%=(ledgers)%>; i++)
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
	}
	
	
}

function calcTotal(name)
	{
	var fieldname=name.name;
	var amountN = 0;
	var qtyN = 0;
	var rateN = 0;
	var d=2;
	if(document.mainform.currency[0].checked)
	{
		d=<%=d%>;
	}
	validate(name,15)
    //alert ("Ok Inside CalcTotal"+d);
	var subtot = 0;
	var subtotal = 0;
	var subtotal1 = calcLedgers();
	subtotal = subtotal +subtotal1; 
	
	var counter=<%=counter%>;

	<%for(int i=0; i<counter; i++)
	{%>
		deletedName = "deleted"+i;
		lotName = "lotno"+i;
		rateName = "rate"+i;
		amountName = "amount"+i;
		quantityName = "quantity"+i;
		hiddenamountName = "hiddenamount"+i;
		var amt=0;
		if(!(document.mainform.elements[deletedName].checked))
		{
		  if(fieldname!=null)
		  {
			if(document.mainform.elements[lotName].value!="#")
			{	
			  validate(document.mainform.elements[rateName],15);
			  validate(document.mainform.elements[amountName],d);
				   
			  if((document.mainform.elements[amountName].value=="0")||(
				document.mainform.elements[amountName].value==""))
			  {
				var amt1=(document.mainform.elements[quantityName].value) * (document.mainform.elements[rateName].value);
				amt1=amt1.toFixed(d);
				document.mainform.elements[amountName].value=amt1;
				document.mainform.elements[hiddenamountName].value=amt1;
			  }
				
			  if(document.mainform.elements[rateName].value=="0")
			  {		
				document.mainform.elements[rateName].value=(document.mainform.elements[amountName].value) / (document.mainform.elements[quantityName].value);
			  }
			
			  amountN=parseFloat(document.mainform.amount<%=i%>.value);
			  qtyN=parseFloat(document.mainform.quantity<%=i%>.value);
			  rateN=parseFloat(document.mainform.rate<%=i%>.value);

			  if( amountN!= (qtyN * rateN))
			  {
				if(amountN > (qtyN*rateN))
				{
				 document.mainform.rate<%=i%>.value=((amountN)/(qtyN));
				}
				else
				{
				   amt=(qtyN * rateN);
				   amt=amt.toFixed(d);
				   document.mainform.amount<%=i%>.value = amt;
				   document.mainform.hiddenamount<%=i%>.value = amt;
				}
			   }//if
			 }
		   }
		//var amount11=document.mainform.amount<%=i%>.value;
		//subtotal=parseFloat(subtotal)+parseFloat(amount11);
		subtotal=parseFloat(subtotal)+parseFloat(amountN);
		
		if(amt != 0)
		{
			amt = amt - amountN;
			subtotal=parseFloat(subtotal)+parseFloat(amt);
		}
		 
		}//end of outer if
		 
	<%}%>//end of for
	
	//subtotal=parseFloat(subtotal)+parseFloat(subtot);
	 subtotal=subtotal.toFixed(d);
	document.mainform.subtotal.value=subtotal;

}// calcTotalNew()


function finalTotal()
{
	calcTotal(document.mainform.total);
	var d=2;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}
	//validate(name,15)
	//alert ("Ok Inside finalTotal"+d);
	var subtotal=0;
	
	var temp_total= parseFloat(document.mainform.subtotal.value);
	var tax_amt= 0;
	if((document.mainform.ctax_amt.value=="")){
		tax_amt=(temp_total*document.mainform.ctax.value)/100;
		tax_amt=tax_amt.toFixed(d);
		document.mainform.ctax_amt.value=tax_amt;
	}

	if(document.mainform.ctax.value=="0"){
		tax_amt=document.mainform.ctax_amt.value;
		document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;
	}

	if(document.mainform.ctax_amt.value != (((temp_total*document.mainform.ctax.value)/100)))
	{
		if(document.mainform.ctax_amt.value > (((temp_total*document.mainform.ctax.value)/100)))
		{
			tax_amt=document.mainform.ctax_amt.value;
			document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;

		}
		else{
			tax_amt= (temp_total*document.mainform.ctax.value)/100;

			tax_amt=tax_amt.toFixed(d);
			document.mainform.ctax_amt.value=tax_amt;
		}
	}

	//var finaltotal=temp_total+tax_amt;
	var finaltotal= parseFloat(document.mainform.subtotal.value)+
	parseFloat(document.mainform.ctax_amt.value);
	finaltotal=finaltotal.toFixed(d);

	document.mainform.total.value=finaltotal;
	//subtotal=document.mainform.subtotal.value;
	
	if(isNaN(finaltotal))
	{ 
		return false;
	} 
	else{
		return true;
	}
}//function finalTotal()// calcTotal



function calcTotalRow(name, deletedElem, lotnoElem, rateElem, amountElem, quantityElem, hiddenamountElem)
{
	var fieldname=name.name;
	var d=2;

	if(document.mainform.currency[0].checked)
	{
		d=<%=d%>;
	}
	validate(name,15)

	if(!(deletedElem.checked))
	{
	  if(fieldname!=null)
	  {
		if(lotnoElem.value!="#")
		{	
			validate(rateElem,15);
			validate(amountElem,d);

			if((amountElem.value=="0")||(amountElem.value==""))
			{
				var amt=(quantityElem.value) * (rateElem.value);
				amt=amt.toFixed(d);
				amountElem.value=amt;
				//document.mainform.hiddenamount.value=amt;
			}

			if(rateElem.value=="0")
			{
			rateElem.value=(amountElem.value) / (quantityElem.value);
			}

		if(amountElem.value != ((quantityElem.value)*(rateElem.value)))
		{
		 if(amountElem.value > ((quantityElem.value)*(rateElem.value)))
		 {
			rateElem.value=(amountElem.value) / (quantityElem.value);
		 }
		 else
		 {
			var amt=(quantityElem.value) * (rateElem.value);
			amt=amt.toFixed(d);
			amountElem.value=amt;
		 }
	    }//if 530
		
		var hiddenamt=parseFloat(hiddenamountElem.value);
		var subtotal=parseFloat(document.mainform.subtotal.value);
		
		subtotal=subtotal-hiddenamt;
		subtotal=subtotal.toFixed(d);
		
		var changedamt=parseFloat(amountElem.value);
		//alert("changedamt="+changedamt);
		var subtotal11=parseFloat(subtotal) + parseFloat(changedamt);
		
		subtotal=subtotal11.toFixed(d);
		//alert("subtotal33="+subtotal);
		document.mainform.subtotal.value=subtotal;
		hiddenamountElem.value=changedamt;

		if(isNaN(subtotal))
		{ 
		return false;
		} 
		else
		{
		return true;
		}
	  }
	}
	}
}//end calcTotalRow()


//For Add/Subtracting Ledger Amount to Sobtotal
function calcLedgerRow(findeletedElem, ledgerAmtElem, hiddenLedAmtElem, debitcreditElem)
{
		//alert("hayyyyyyy");
		if(!findeletedElem.checked)
		{
		var le_amt =parseFloat(ledgerAmtElem.value);
		var hid_le_amt =parseFloat(hiddenLedAmtElem.value);
		var le_db =parseFloat(debitcreditElem.value);
		var subtotal1=parseFloat(document.mainform.subtotal.value);
		
		hid_le_amt=hid_le_amt *(le_db *-1);
		subtotal1=subtotal1-hid_le_amt;
		var le_amt1 =le_amt *(le_db *-1);
		subtotal1=subtotal1+le_amt1;
		document.mainform.subtotal.value=subtotal1;
		hiddenLedAmtElem.value=le_amt;
		}

		if(isNaN(subtotal1))
		{ 
		return false;
		} 
		else
		{
		return true;
		}

}
//For Add/Subtracting Ledger Amount to Sobtotal
		//Debit=minus
		//Credit=plus
function calcDebitCredit(findeletedElem, ledgerAmtElem, hiddenLedAmtElem, debitcreditElem)
{
		
		//alert("hayyyyyyyCrDr");
		if(!findeletedElem.checked)
		{
			var le_amt =parseFloat(ledgerAmtElem.value);
			var hid_le_amt =parseFloat(hiddenLedAmtElem.value);
			var le_db =parseFloat(debitcreditElem.value);
			var subtotal1=parseFloat(document.mainform.subtotal.value);
			
			if(le_db==1)//Debit
			{
				subtotal1=subtotal1-le_amt-le_amt;
			}
			if(le_db==-1)//Credit
			{
				subtotal1=subtotal1+le_amt+le_amt;
			}
			//alert("subtotal1_min_hidamt="+subtotal1);
			document.mainform.subtotal.value=subtotal1;
			//alert("hiddenLedAmtElem="+le_amt);
		}
	
}


function CtaxCal()
{
	var d=2;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

	//alert("Datta");
	var temp_total= parseFloat(document.mainform.subtotal.value);
	//alert("temp_total="+temp_total);
	var tax_amt= 0;
	if((document.mainform.ctax_amt.value=="")){
		tax_amt=(temp_total*document.mainform.ctax.value)/100;
		tax_amt=tax_amt.toFixed(d);
		document.mainform.ctax_amt.value=tax_amt;

	}
	if(document.mainform.ctax.value=="0"){
		tax_amt=document.mainform.ctax_amt.value;
		document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;
	}
	if(document.mainform.ctax_amt.value != (((temp_total*document.mainform.ctax.value)/100)))
	{
		if(document.mainform.ctax_amt.value > (((temp_total*document.mainform.ctax.value)/100)))
		{
			tax_amt=document.mainform.ctax_amt.value;
			document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;

		}
		else{
			tax_amt= (temp_total*document.mainform.ctax.value)/100;

			tax_amt=tax_amt.toFixed(d);
			document.mainform.ctax_amt.value=tax_amt;
		}
	}
	
	//var finaltotal=temp_total+tax_amt;
	var ctaxamount=parseFloat(document.mainform.ctax_amt.value);
	
	var finaltotal= parseFloat(document.mainform.subtotal.value)+parseFloat(ctaxamount);
	
	//finaltotal=finaltotal.toFixed(d);
	//alert("613 finaltotal="+finaltotal);
	document.mainform.total.value=finaltotal;
	
}//end of CtaxCalc



function onLocalSubmitValidate()
	{
	
	var flag;
      
	   flag=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag==false)
			return false;
	
	
	
	newlocation();

	//calcTotal(document.mainform.total);
	a=nonrepeat();
	if(a==false)
	{
	return false;
	}
	else
		{
	var finaltotal=document.mainform.total.value;

	var ffinaltotal=parseFloat(finaltotal);

	if((""==finaltotal)||(isNaN(finaltotal)) || (ffinaltotal==0) )
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	//return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
		}
	}//onSubmitValidate

function newlocation()
 {
	<%
	for(int i=0;i<counter;i++)
	{%>
		document.mainform.newlocation_id<%=i%>.value=document.mainform.masterlocation.value;
	<%}%>

 }


function handleFocus(name)
	{document.mainform.lotfocus.value=name;}


function lotValue(val)
{
temp=val;
//alert("you selected "+temp);
//var counter=<%=counter%>
<%
for (int h=0;h<counter;h++){
%>
 templot=document.mainform.lotfocus.value;
//alert(templot);	
if(templot=="newlotno<%=h%>")
	{
	document.mainform.newlotno<%=h%>.value = temp;
	<%
	if(h+1<counter)
		{%>
		document.mainform.newlotno<%=h+1%>.focus();
	  <%}%>	

	}
<%}%>
}


function nonrepeat()
{
	<%
	for(int i=0;i<ledgers;i++)
	{
		for(int j=i+1;j<ledgers;j++)
		{%>
		if(document.mainform.ledger<%=i%>.value == document.mainform.ledger<%=j%>.value)
		{
		alert ("Do Select Proper Account in Particulars");
		return false;
		}

	<%}
	}%>
}

</script>

<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>

<script language="JavaScript">
function onload_form()
{
//calcTotal(document.mainform.total);
document.mainform.consignment_no.focus()
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>

<body bgColor=#ffffee onLoad='onload_form(this);' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="indiaEditSaleForm1.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<input type=hidden name=lotfocus >

<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=receive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value=<%=counter+1%>>
<input type=hidden name=old_lots value=<%=counter%>>

<input type=hidden name=ledgers value=<%=ledgers%>>
<input type=hidden name=old_ledgers value=<%=ledgers%>>
<input type=hidden name=org_ledgers value=<%=ledgers%>>



<tr>
<th colspan=8 align=center>Edit Sale </th>
</tr>

<input type=hidden name="pdcount" value="<%=pdcount%>">

<script language="JavaScript">

 function currencylabel()
	{
		var temp="<%=local_currencysymbol%>";
	 	if(document.mainform.currency[1].checked)
		{
  			temp="$";
		}
		document.mainform.currency_text.value=temp;
	}
</script>

<tr>
	<td colspan=1>No :
	<input type=text name=consignment_no size=5 value="<%=receive_no%>" onBlur='return nullvalidation(this)'></td>

	<td colspan=1>Ref No :
	<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10></td>

	<td>To,</td>
	<td> 
	<%
	String condition="Where Super=0 and Sale=1 and active=1";
	if("0".equals(currency_id))
	{
	condition="Where Super=0 and Sale=1 and active=1";
	}
	%>
	<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
	 <script language="javascript">
		var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
	</script>	

<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
	</td><input type=hidden name="oldcompanyparty_id" value="<%=companyparty_id%>">

	<%
	String disloc="";
	String disdol="";
	String local_currencysymbol_Show="";

	if("0".equals(currency_id))
	{
	disdol="checked";
	local_currencysymbol_Show="$";
	 }
	 else
	{
	local_currencysymbol_Show=local_currencysymbol;
	disloc="checked";
	} %>

	<td>Sale Group</td>
	<td>	
		<%=A.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>
</tr>


<tr>
	<td>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
	</script>
	</td>

	<td><input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(receive_date)%>"
	onblur='return  fnCheckMultiDate(this,"Invoice Date")'>
	</td>

	<input type=hidden name=old_date value="<%=format.format(receive_date)%>">

	<td>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100'>")}
	</script>	
	</td>
	<td>
	<input type=text name='stockdate' size=8 maxlength=10 value="<%=format.format(stockdate)%>"
	onblur='return  fnCheckMultiDate(this,"Due Date")'>
	</td>

	<td align=left>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
	</script>	
	</td>
	<td>
	<input type=text name='duedate' size=8 maxlength=10 value="<%=format.format(due_date)%>"
	onblur='return  fnCheckMultiDate1(this,"Stock Date")'>
	</td>
	<td>
	<input type=hidden name="due_dateold" value="<%=format.format(stockdate)%>">
	</td>
</tr>

<%
if( (Iv_id>0 && Fv_id>0) || pdcount==0 )
	{
	String FTcash_id=A.getNameCondition(conp,"Financial_Transaction","For_HeadId","where Voucher_Id="+Fv_id+" and For_Head=1 and Active=1");
	%>


<tr>
	<td>Sale Type</td>
	<td><Select name=cash_id >
	<option value=0>Regular</option>
</select><%//=A.getCashAccounts(conp,"cash_id",FTcash_id,company_id,"1")%></td>
	<input type=hidden name="Inv_id" value="<%=Inv_id%>">
	<input type=hidden name="Finv_id" value="<%=Finv_id%>">
<%
	}
	else
	{%>
	<input type=hidden name="cash_id" value="0">
	<input type=hidden name="Inv_id" value="<%=Iv_id%>">
	<input type=hidden name="Finv_id" value="<%=Fv_id%>">
<%}%>


<% if(counter!=0)
	{%>
	<td>Location</td>
	<td COLSPAN=1> 
	<%=A.getMasterArrayCondition(conp,"Location","masterlocation",location_id[0],"where company_id="+company_id)%></td>
<%}%>

	<td>Category &nbsp;&nbsp;&nbsp        		  <%=A.getArrayConditionAll(conp,"Master_LotCategory","category_id","","where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%> </td>
  
	<td width=200>Currency &nbsp;&nbsp;&nbsp
	   <input onclick='currencylabel()' type=radio name="currency"  value=local <%=disloc%>> Local
	   <input type=radio onclick='currencylabel()' name="currency" value=dollar <%=disdol%>> Dollar
	</td>
</tr>


<tr>
	<td>Sales Person </td>
	<td><%=A.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=0 and Active=1 and company_id="+company_id+"") %>
	</td>

	<td>Exchange Rate &nbsp;&nbsp</td>
	<td><input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this,2)"  size=4 style="text-align:right">
	</td>

	<td>Due Days</td>
	<td><input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name="duedaysold" value="<%=duedays%>"></td>
</tr>
</table>
<TABLE borderColor=red WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
<% 
	if(counter!=0)
	{%>
<tr>
<td>Sr No/Delete</td>
<td>Lot No</td>
<td>Original Qty</td>
<td>Return Qty</td>
<td>Ghat Qty</td>
<td>Selection Qty</td>
<td>Rate / Unit</td>
<td>Amount in (<%=local_currencysymbol_Show%>)</td>
<td>Lot Discount %</td>
<td>Remarks</td>
</tr>


<% 
for (int i=0;i<counter;i++)
{

if((n+ledgers)==1)//n:no of lots ledgers: no of ledgers
	{%>
	 <tr><td><%=i+1%></td>
     <input type=hidden name="deleted<%=i%>" value="no">
  <%}
    else
	{%><tr><td><%=i+1%><input type="hidden" name="deleted<%=i%>" value="no"></td><!-- onclick=' return calcTotal(document.mainform.ctax_amt)' -->
  <%}%>



<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lotid<%=i%> value="<%=lot_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lot_no[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=location_id[i]%>">	
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >
<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
<input type=hidden name=hiddenamount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>">
<td>
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> autocomplete=off value="<%=lot_no[i]%>" size=10 onBlur='return nullvalidation(this)'  onfocus='handleFocus("newlotno<%=i%>")'> </td>
<td>
<input type=text name=originalQuantity<%=i%> value="<%=originalQuantity[i]%>" size=5 onBlur="recalculateQty('<%=i%>');" readonly onfocus="this.select();" style="text-align:right"></td>
<td>
<input type=text name=returnQuantity<%=i%> value="<%=returnQuantity[i]%>" size=5 onBlur="recalculateQty('<%=i%>');" readonly onfocus="this.select();" style="text-align:right"></td>
<td>
<input type=text name=ghat<%=i%> value="<%=str.mathformat(""+ghat[i],3)%>" size=5 onBlur="recalculateQty('<%=i%>');" readonly onfocus="this.select();" style="text-align:right"></td>
<td>
<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5  style="text-align:right" OnBlur="'validate(this,3)';recalculateQty('<%=i%>')" readonly onfocus="this.select();">
</td>
<td><input type=text name=rate<%=i%> value="<%=str.mathformat(""+rate[i],3)%>" readonly size=5  style="text-align:right" ></td>
<td align=left><input type=text name=amount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>" size=8 readonly style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.newlotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)'>
</td>
<td><input type=text name=lotDiscount<%=i%> value="<%=lotDiscount[i]%>" size=8 readonly OnBlur="Discount('<%=i%>')"></td>
<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
</tr>
<script language="javascript">

	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
			
</script>	
<%errline="1226";
}
	}
%>

<input type=hidden name=discount size=8 value="0" style="text-align:right">
<input type=hidden name=discount_amt size=8 OnBlur='return calcTotal(this)'  style="text-align:right" value="0">
<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 value="<%=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 OnBlur='return calcTotal(this)'  style="text-align:right" value="<%=str.mathformat(""+(discount*subtotal/100),d)%>"></td>
<td colspan=2></td>
</tr> -->
<%errline="1240";
//out.print("<br>1045 ctax_id="+ctax_id);
String intital_subtotal="";
query="Select * from Financial_Transaction where Voucher_Id=? and active=1 and Sr_No=0 and ledger_id="+ctax_id+"";
//out.print("<br>1048 query:"+query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,testvoucher_id); 
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{
intital_subtotal=rs_g.getString("Amount");
}
pstmt_g.close();
//out.print("<br>1055 intital_subtotal="+intital_subtotal);



int Total=0;
query="Select count(*) as Total from Financial_Transaction FT , Voucher V where V.Voucher_Id=FT.Voucher_Id and V.Voucher_type=1 and V.voucher_No='"+receive_id+"' and FT.Active=1 and Ledger_Id > "+ctax_id;

pstmt_g = cong.prepareStatement(query);
//pstmt_g.setString(1,testvoucher_id); 
rs_g = pstmt_g.executeQuery();	
int k=0; //k is local variable for row count loop
while(rs_g.next())
{
	Total = rs_g.getInt("Total");	
}
pstmt_g.close();

String Tranasaction_Id[]=new String[Total]; 
out.print("<br>1257 ledgers="+Total);
String Sr_No[]=new String[Total]; 
String Transaction_Type[]=new String[Total]; 
String Amount[]=new String[Total]; 
String Ledger_Id[]=new String[Total]; 

query="Select * from Financial_Transaction FT , Voucher V where V.Voucher_Id=FT.Voucher_Id and V.Voucher_type=1 and V.voucher_No='"+receive_id+"' and FT.Active=1 and Ledger_Id > "+ctax_id+" order by Tranasaction_Id";
pstmt_g = cong.prepareStatement(query);
//pstmt_g.setString(1,testvoucher_id); 
rs_g = pstmt_g.executeQuery();	
 k=0; //k is local variable for row count loop
while(rs_g.next())
{
	out.print("<br>703K="+k);
Tranasaction_Id[k]=rs_g.getString("Tranasaction_Id");
Sr_No[k]=rs_g.getString("Sr_No");
Transaction_Type[k]=rs_g.getString("Transaction_Type");
Amount[k]=rs_g.getString("Amount");
Ledger_Id[k]=rs_g.getString("Ledger_Id");

//out.print("<br>Tranasaction_Id[k]"+Tranasaction_Id[k]);
//out.print("<br>Sr_No[k]"+Sr_No[k]);
//out.print("<br>Transaction_Type[k]"+Transaction_Type[k]);
//out.print("<br>Amount[k]"+Amount[k]);
//out.print("<br>Ledger_Id[k]"+Ledger_Id[k]);
errline="1279";
k++;
errline="1281";
}//while
pstmt_g.close();
//out.print("<br>703K="+k);
//out.print("<br>703ledgers="+ledgers);
errline="1285";
%>
	
<%
	
for(int i=0;i<ledgers;i++)
{errline="1290";%>
<tr>
	<td align=left><%=i+1%><input align=left type="hidden" name="findeleted<%=i%>" value="no"> </td>

	<input type="hidden" name="org_transacionid<%=i%>" value="<%=Tranasaction_Id[i]%>">
	<td colspan=6 align=right>  <%=A.getArray(conp,"Ledger","ledger"+i,Ledger_Id[i],company_id+" and yearend_id="+yearend_id ,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;</td>

	<td colspan=1 align=left>
	<input type=text name="acamount<%=i%>" value="<%=str.mathformat(""+Amount[i],d)%>"  style="text-align:right" size="8" readonly onChange='return calcLedgerRow(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
	
	<input type=hidden name="hiddenacamount<%=i%>" value="<%=str.mathformat(""+Amount[i],d)%>"></td>

	<%if("0".equals(Transaction_Type[i]))
		
	{errline="1304";%>
		<td colspan=1>
			<select name= "debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>,document.mainform.acamount<%=i%>,document.mainform.hiddenacamount<%=i%>,document.mainform.debitcredit<%=i%>)'>
				<option value="1" selected>Dr</option>
				<option value="-1">Cr</option>
			</select>
		</td>
	<%} 
	else 
		{ %>
		<td colspan=1>
			<select name="debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
				<option value="1">Dr</option>
				<option value="-1" selected>Cr</option>
			</select>
		</td>
		<%errline="1320";}%>
</tr>
<%
	}

/* 
	
End of code for financail transactions       
*/
%>

<tr>
<!-- <td colspan=1></td> -->
<td colspan=7>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1 align=left><input type=text name=subtotal size=8 readonly     value="<%=str.mathformat(""+subtotal,d)%>" style="text-align:right"
   >
	<input type=hidden name=hiddensubtotal value="<%=str.mathformat(""+subtotal,d)%>"></td>
	  
<td colspan=2></td>
</tr>
<tr>
<!-- <td colspan=1></td> -->
<td colspan=6>C.Tax (%)</td>
<td colspan=1 align=left><input type=text name=ctax size=8  value="<%=ctax%>" style="text-align:right"></td>
<td align=left><input type=text name=ctax_amt size=8 OnBlur='return CtaxCal()' style="text-align:right" value="<%=str.mathformat(""+((subtotal-(discount*subtotal)/100)*ctax)/100,d)%>"></td>
<td colspan=2></td>
</tr>

<tr>
<!-- <td colspan=1></td> -->
<td colspan=7>Total in <%=local_currencysymbol%></td>
<td colspan=1 align=left><input type=text readonly name=total size=8 value="<%=str.mathformat(""+org_receivetotal,d)%>" style="text-align:right"></td>  <!-- return calcTotal(this) -->
</tr>
</table>
<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
<%
if(Difference_Amount<0)
	
{
%>
<tr>
<!-- <td colspan=1></td> -->
<!--<td colspan=4>Difference Account in <%=local_currencysymbol%></td>
<td colspan=1 align=left>--><input type=hidden name=difference size=8  style="text-align:right" value="<%=-1*Difference_Amount%>"></td>
<!--<td><select name="diffdebit"><option value="1">Dr</option><option value="-1">Cr</option></select></td>-->
<td colspan=6>Narration:
<input type=text size=75 value="<%=description%>" name=description></td>
</tr>
	<%errline="1368";	}
	else{
%>
<tr>
<!-- <td colspan=1></td> -->
<!--<td colspan=4>Difference Account in <%=local_currencysymbol%></td>
<td colspan=1 align=left>--><input type=hidden name=difference size=8  style="text-align:right" value="<%=Difference_Amount%>">
<!--<td><select name="diffdebit"><option value="-1">Cr</option> <option value="1">Dr</option></select></td>-->

<td colspan=6>Narration:
<input type=text name=description value="<%=description%>" size=75 ></td>
</tr>
	<%
	} errline="1288";
%>

<%
tempFlag=request.getParameter("tempFlag"); 
//out.print("<br>902 tempFlag"+tempFlag);
%>

<input type=hidden name=tempFlag value="<%=tempFlag%>">



<tr>

<td align=center>
<input type=submit name=command value=NEXT class='button1'  OnClick='return finalTotal()'>
</td>

</tr>

</TABLE>
</td>
</tr>
<% if(counter!=0)
	
	{%>

	<!-- <tr>
<TD align=right rowspan=4>
<IFRAME name=bottom align=right src="../Inventory/InvSearch.jsp?command=Search&location_id=<%//=1%>&inv_date=<%//=format.format(receive_date)%>" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="1" scrolling="auto" align="right" width='100%' height='100%'>
</IFRAME></TD>
</tr> -->
<%}%>
</table>
</FORM>
</body>
</html>
<%
C.returnConnection(conp);
C.returnConnection(cong);


}//if saleedit


}
catch(Exception e631){ 
C.returnConnection(conp);
C.returnConnection(cong);
out.println("<font color=red> FileName : EditSaleForm1.jsp command=sedit<br>Bug No e631 : "+ e631+"errline="+errline);}



%>

<!---------------------------------------------------------
							ADD Form Start
----------------------------------------------------------->

<%
try{
if("ADD".equals(command))
{

String old_date=request.getParameter("old_date");

//String narr=request.getParameter("narration");
//String refno=request.getParameter("refno");


String tempFlag=request.getParameter("tempFlag"); 
//out.print("<br>972 tempFlag"+tempFlag);
%>
	<input type=hidden name=tempFlag value="<%=tempFlag%>">
<%



String category_id=request.getParameter("category_id");

int addlots= Integer.parseInt(request.getParameter("addlots"));
String lotledger=request.getParameter("lotledger");
//out.print("<br>983 lotledger "+lotledger);
String add_lots="";
int newlots=0;
String add_ledgers="";
int newledgers=0;
if("lot".equals(lotledger))
	{
//	out.print("Inside if");
	add_lots = request.getParameter("addlots");
	newlots=Integer.parseInt(add_lots);
	}
else
	{
//	out.print("Inside else");
	add_ledgers = request.getParameter("addlots");
//	out.print("<br>868 add_ledgers "+add_ledgers);

	newledgers=Integer.parseInt(add_ledgers);
	}

String oldreceive_no=request.getParameter("oldreceive_no");
String receive_no=request.getParameter("receive_no");
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
String old_lots = request.getParameter("old_lots");
//out.print("<br>1008 old_lots: "+old_lots);

String cash_id=request.getParameter("cash_id");
int Fv_id=Integer.parseInt( request.getParameter("Finv_id") );
//out.print("<br>1012 old_lots: "+old_lots);
int Iv_id=Integer.parseInt( request.getParameter("Inv_id") );
//out.print("<br>1014 old_lots: "+old_lots);
int pdcount=Integer.parseInt(request.getParameter("pdcount"));
String ledgers = request.getParameter("ledgers");
//out.print("<br>1016 ledgers: "+ledgers);

String old_ledgers = request.getParameter("old_ledgers");
String org_ledgers = request.getParameter("org_ledgers");
int ledgercounter=Integer.parseInt(old_ledgers);

String consignment_no = request.getParameter("consignment_no");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
String due_date = request.getParameter("duedate");
String due_dateold = request.getParameter("due_dateold");

String receive_date=""+datevalue;
String currency = request.getParameter("currency");
String currency_id = request.getParameter("currency_id");
String exchange_rate = request.getParameter("exchange_rate");
String salesperson_id = request.getParameter("salesperson_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");

int nolots_old=Integer.parseInt(lots);
int counter=nolots_old;
//out.print("<br>1037 counter :"+counter);
String lotid[]=new String[counter];
String deleted[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String receivetransaction_id[]=new String[counter];
String lotno[]=new String[counter];
String newlotno[]=new String[counter];
String pcs[]=new String[counter];
String old_quantity[]=new String[counter];
String quantity[]=new String[counter];
String rate[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];
// out.print("counter "+counter);
for (int i=0;i<(counter-1);i++)
{
deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted[i] "+deleted[i]);
//out.print("<br> i=="+i);
receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);

lotno[i]=""+request.getParameter("lotno"+i);
//out.print("<br>lotno[i] "+lotno[i]);
newlotno[i]=""+request.getParameter("newlotno"+i);
//out.print("<br>newlotno[i] "+newlotno[i]);
lotid[i]=""+request.getParameter("lotid"+i);
//newlotid[i]=A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No="+newlotno[i]);

location_id[i]=""+request.getParameter("location_id"+i);
newlocation_id[i]=""+request.getParameter("newlocation_id"+i);

pcs[i]=""+request.getParameter("pcs"+i);
old_quantity[i]=""+request.getParameter("old_quantity"+i);
quantity[i]=""+request.getParameter("quantity"+i);
rate[i]=""+request.getParameter("rate"+i); 
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
}

//String add_lots = request.getParameter("addlots");
int total_lots=counter+newlots;
//out.print("<br>964 total_lots "+total_lots);
String org_transacionid[]=new String[ledgercounter];
String findeleted[]=new String[ledgercounter];
String ledger[]=new String[ledgercounter];
double acamount[]=new double[ledgercounter];
String debitcredit[]=new String[ledgercounter];


for (int i=0;i<ledgercounter;i++)
{

org_transacionid[i]=""+request.getParameter("org_transacionid"+i);
findeleted[i]=""+request.getParameter("findeleted"+i);
ledger[i]=request.getParameter("ledger"+i);
acamount[i]=Double.parseDouble(request.getParameter("acamount"+i));
debitcredit[i]=request.getParameter("debitcredit"+i);
}

double difference=Double.parseDouble(request.getParameter("difference"));
String diffdebit=request.getParameter("diffdebit");

int total_ledgers=ledgercounter+newledgers;

String companyparty_name= request.getParameter("companyparty_name");
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");
String subtotal =""+ request.getParameter("subtotal");
String ctax =""+ request.getParameter("ctax");
String discount =""+ request.getParameter("discount");
String total =""+ request.getParameter("total");
String duedays =""+ request.getParameter("duedays");
String duedaysold =""+ request.getParameter("duedaysold");

String currency_text =""+ request.getParameter("currency_text");
/*
 //int d=0;

if ("dollar".equals(currency))
	{
		d=2;
	}
if("local".equals(currency))
{
 d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
}
*/
//out.print("<br>d--->"+d);
%>

<html>
<head><title>Samyak Software</title>
<script language="JavaScript">

<%
	String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Sale=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_p = conp.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var companyArray=new Array("+companyArray+");");


	String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
	pstmt_p = conp.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");


%>


function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate

function calcLedgers()
{
	var subtotal1=0;
	<%
	for(int i=0;i<total_ledgers;i++)
	{%>
	//alert(document.mainform.findeleted<%=i%>.value);
	if(!(document.mainform.findeleted<%=i%>.value=='yes'))
		{
		//alert("915 subtotal"+subtotal1);
		var le_amt<%=i%>=parseFloat(document.mainform.acamount<%=i%>.value)
		var le_db<%=i%>=parseFloat(document.mainform.debitcredit<%=i%>.value)
		le_amt<%=i%>=le_amt<%=i%>*(le_db<%=i%>*-1);
		subtotal1=subtotal1+le_amt<%=i%>;
		}
	<%}%>
		//alert(subtotal1);
	return subtotal1;
}


function calcTotal(name)
{
	var fieldname=name.name;
	var amountN = 0;
	var qtyN = 0;
	var rateN = 0;
	var d=2;
	
	if(document.mainform.currency[0].checked)
	{
		d=<%=d%>;
	}
	validate(name,15);
    //alert ("Ok Inside CalcTotal"+d);
	var subtot = 0;
	var subtotal = 0;
	var subtotal1 = calcLedgers();
	subtotal = subtotal +subtotal1; 
	//alert("1577");
	<%int counter_temp=(counter-1);%>
	
	
	<%for(int i=0;i<counter_temp; i++)
	{%>
		deletedName = "deleted"+i;
		lotName = "lotno"+i;
		rateName = "rate"+i;
		amountName = "amount"+i;
		quantityName = "quantity"+i;
		hiddenamountName = "hiddenamount"+i;
		//alert(document.mainform.elements[amountName].value);
		//alert("i="+i);
		var amt=0;
		if(!(document.mainform.elements[deletedName].checked))
		{
		  if(fieldname!=null)
		  {
			if(document.mainform.elements[lotName].value!="#")
			{	
			  validate(document.mainform.elements[rateName],15);
			  validate(document.mainform.elements[amountName],d);
				   
			  if((document.mainform.elements[amountName].value=="0")||(
				document.mainform.elements[amountName].value==""))
			  {
				var amt1=(document.mainform.elements[quantityName].value) * (document.mainform.elements[rateName].value);
				amt1=amt1.toFixed(d);
				document.mainform.elements[amountName].value=amt1;
				document.mainform.elements[hiddenamountName].value=amt1;
			  }
				
			  if(document.mainform.elements[rateName].value=="0")
			  {		
				document.mainform.elements[rateName].value=(document.mainform.elements[amountName].value) / (document.mainform.elements[quantityName].value);
			  }
			
			  amountN=parseFloat(document.mainform.amount<%=i%>.value);
			  qtyN=parseFloat(document.mainform.quantity<%=i%>.value);
			  rateN=parseFloat(document.mainform.rate<%=i%>.value);
			  //alert("amountN="+amountN);
			  if( amountN!= (qtyN * rateN))
			  {
				if(amountN > (qtyN*rateN))
				{
				 document.mainform.rate<%=i%>.value=((amountN)/(qtyN));
				}
				else
				{
				   amt=(qtyN * rateN);
				   amt=amt.toFixed(d);
				   document.mainform.amount<%=i%>.value = amt;
				   document.mainform.hiddenamount<%=i%>.value = amt;
				}
			   }//if
			 }
		   }
		//var amount11=document.mainform.amount<%=i%>.value;
		//subtotal=parseFloat(subtotal)+parseFloat(amount11);
		//alert("1635");
		subtotal=parseFloat(subtotal)+parseFloat(amountN);
		
		if(amt != 0)
		{
			amt = amt - amountN;
			subtotal=parseFloat(subtotal)+parseFloat(amt);
		}
		 //alert("1643");
		}//end of outer if
		 
	<%}%>//end of for
	
	//subtotal=parseFloat(subtotal)+parseFloat(subtot);
	 subtotal=subtotal.toFixed(d);
	document.mainform.subtotal.value=subtotal;
	//alert("At End");
}// calcTotalNew()


function finalTotal()
{
	
	calcTotal(document.mainform.total);
	var d=2;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}
	//validate(name,15)
	
	var subtotal=0;
	
	var temp_total= parseFloat(document.mainform.subtotal.value);
	var tax_amt= 0;
	if((document.mainform.ctax_amt.value=="")){
		tax_amt=(temp_total*document.mainform.ctax.value)/100;
		tax_amt=tax_amt.toFixed(d);
		document.mainform.ctax_amt.value=tax_amt;
	}

	if(document.mainform.ctax.value=="0"){
		tax_amt=document.mainform.ctax_amt.value;
		document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;
	}

	if(document.mainform.ctax_amt.value != (((temp_total*document.mainform.ctax.value)/100)))
	{
		if(document.mainform.ctax_amt.value > (((temp_total*document.mainform.ctax.value)/100)))
		{
			tax_amt=document.mainform.ctax_amt.value;
			document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;

		}
		else{
			tax_amt= (temp_total*document.mainform.ctax.value)/100;

			tax_amt=tax_amt.toFixed(d);
			document.mainform.ctax_amt.value=tax_amt;
		}
	}

	//var finaltotal=temp_total+tax_amt;
	
	
	//var finaltotal= parseFloat(document.mainform.subtotal.value)+
	//parseFloat(document.mainform.ctax_amt.value);
	//finaltotal=finaltotal.toFixed(d);

	//document.mainform.total.value=finaltotal;
	//subtotal=document.mainform.subtotal.value;
	
	var finaltotal= parseFloat(document.mainform.subtotal.value)+
	parseFloat(document.mainform.ctax_amt.value);
	finaltotal=finaltotal.toFixed(d);

	document.mainform.total.value=finaltotal;
	if(isNaN(finaltotal))
	{ 
		return false;
	} 
	else{
		return true;
	}
}//function finalTotal()// calcTotal


function calcTotalRow(name, deletedElem, lotnoElem, rateElem, amountElem, quantityElem, hiddenamountElem)
{
	var fieldname=name.name;
	var d=2;

	if(document.mainform.currency[0].checked)
	{
		d=<%=d%>;
	}
	validate(name,15)

	if(!(deletedElem.checked))
	{
	  if(fieldname!=null)
	  {
		if(lotnoElem.value!="#")
		{	
			validate(rateElem,15);
			validate(amountElem,d);

			if((amountElem.value=="0")||(amountElem.value==""))
			{
				var amt=(quantityElem.value) * (rateElem.value);
				amt=amt.toFixed(d);
				amountElem.value=amt;
				//document.mainform.hiddenamount.value=amt;
			}

			if(rateElem.value=="0")
			{
			rateElem.value=(amountElem.value) / (quantityElem.value);
			}

		if(amountElem.value != ((quantityElem.value)*(rateElem.value)))
		{
		 if(amountElem.value > ((quantityElem.value)*(rateElem.value)))
		 {
			rateElem.value=(amountElem.value) / (quantityElem.value);
		 }
		 else
		 {
			var amt=(quantityElem.value) * (rateElem.value);
			amt=amt.toFixed(d);
			amountElem.value=amt;
		 }
	    }//if 530
		
		var hiddenamt=parseFloat(hiddenamountElem.value);
		var subtotal=parseFloat(document.mainform.subtotal.value);
		
		subtotal=subtotal-hiddenamt;
		subtotal=subtotal.toFixed(d);
		
		var changedamt=parseFloat(amountElem.value);
		//alert("changedamt="+changedamt);
		var subtotal11=parseFloat(subtotal) + parseFloat(changedamt);
		
		subtotal=subtotal11.toFixed(d);
		//alert("subtotal33="+subtotal);
		document.mainform.subtotal.value=subtotal;
		hiddenamountElem.value=changedamt;

		if(isNaN(subtotal))
	{ 
		return false;
	} 
	else{
		return true;
	}


	  }
	}
	}
}//end calcTotalRow()


function calcLedgerRow(findeletedElem, ledgerAmtElem, hiddenLedAmtElem, debitcreditElem)
{
		
		//alert("hayyyyyyy");
		if(!findeletedElem.checked)
		{
		var le_amt =parseFloat(ledgerAmtElem.value);
		//alert("le_amt="+le_amt);
		var hid_le_amt =parseFloat(hiddenLedAmtElem.value);
		//alert("hid_le_amt="+hid_le_amt);
		var le_db =parseFloat(debitcreditElem.value);
		//alert("le_db="+le_db);
		var subtotal1=parseFloat(document.mainform.subtotal.value);
		//alert("subtotal1="+subtotal1);

		
		var minusQty=le_amt-hid_le_amt;
		if(le_db==1)
		{
		subtotal1=subtotal1-minusQty;
		}
		if(le_db==-1)
		{
		subtotal1=subtotal1+minusQty;
		}
		//alert("subtotal1_min_hidamt="+subtotal1);
		document.mainform.subtotal.value=subtotal1;
		//alert("hiddenLedAmtElem="+le_amt);
		hiddenLedAmtElem.value=le_amt;
		}
	
}

//For Add/Subtracting Ledger Amount to Sobtotal
		//Debit=minus
		//Credit=plus
function calcDebitCredit(findeletedElem, ledgerAmtElem, hiddenLedAmtElem, debitcreditElem)
{
		
		//alert("hayyyyyyyCrDr");
		if(!findeletedElem.checked)
		{
			var le_amt =parseFloat(ledgerAmtElem.value);
			var hid_le_amt =parseFloat(hiddenLedAmtElem.value);
			var le_db =parseFloat(debitcreditElem.value);
			var subtotal1=parseFloat(document.mainform.subtotal.value);
			
			if(le_db==1)//Debit
			{
				subtotal1=subtotal1-le_amt-le_amt;
			}
			if(le_db==-1)//Credit
			{
				subtotal1=subtotal1+le_amt+le_amt;
			}
			//alert("subtotal1_min_hidamt="+subtotal1);
			document.mainform.subtotal.value=subtotal1;
			//alert("hiddenLedAmtElem="+le_amt);
		}
	
}


function CtaxCal()
{
	var d=2;
	if(document.mainform.currency[0].checked)
	{
		d=<%=d%>;
	}

	//alert("DG");
	var temp_total= parseFloat(document.mainform.subtotal.value);
	//alert("temp_total="+temp_total);
	var tax_amt= 0;

	if((document.mainform.ctax_amt.value==""))
	{
		tax_amt=(temp_total*document.mainform.ctax.value)/100;
		tax_amt=tax_amt.toFixed(d);
		document.mainform.ctax_amt.value=tax_amt;

	}

	if(document.mainform.ctax.value=="0")
	{
		tax_amt=document.mainform.ctax_amt.value;
		document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;
	}

	if(document.mainform.ctax_amt.value != (((temp_total*document.mainform.ctax.value)/100)))
	{
		if(document.mainform.ctax_amt.value > (((temp_total*document.mainform.ctax.value)/100)))
		{
			tax_amt=document.mainform.ctax_amt.value;
			document.mainform.ctax.value=((document.mainform.ctax_amt.value)*100)/temp_total;

		}
		else{
			tax_amt= (temp_total*document.mainform.ctax.value)/100;

			tax_amt=tax_amt.toFixed(d);
			document.mainform.ctax_amt.value=tax_amt;
			}
	}
	
	//var finaltotal=temp_total+tax_amt;
	var ctaxamount=parseFloat(document.mainform.ctax_amt.value);
	
	var finaltotal= parseFloat(document.mainform.subtotal.value)+parseFloat(ctaxamount);
	
	//finaltotal=finaltotal.toFixed(d);
	//alert("613 finaltotal="+finaltotal);
	document.mainform.total.value=finaltotal;
	
}//end of CtaxCalc

function newlocation()
{
<%
for(int i=0;i<counter-1;i++)
	{%>
	document.mainform.newlocation_id<%=i%>.value=document.mainform.masterlocation.value;
	<%}%>

}

function onLocalSubmitValidate()
	{
	var flag;
      
	   flag=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag==false)
			return false;
	
	
	//calcTotal(document.mainform.total);
	a=nonrepeat();
 	

	if(a==false)
	{
	return false;
	}
	else
		
	{
	var finaltotal=document.mainform.total.value;

	var ffinaltotal=parseFloat(finaltotal);

	if((""==finaltotal)||(isNaN(finaltotal)) || (ffinaltotal==0) )
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	//return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
		}
	}//onSubmitValidate

function handleFocus(name)
	{document.mainform.lotfocus.value=name;}
function lotValue(val)
{
temp=val;
//alert("you selected "+temp);
//var counter=<%=counter%>
<%
for (int h=0;h<(total_lots-1);h++){
%>
 templot=document.mainform.lotfocus.value;
//alert(templot);	
if(templot=="newlotno<%=h%>")
	{
	document.mainform.newlotno<%=h%>.value = temp;
	<%
	if(h+1<(total_lots-1))
		{%>
		document.mainform.newlotno<%=h+1%>.focus();
<%}%>	

	}
<%}%>
}

function nonrepeat()
{
	<%
	for(int i=0;i<total_ledgers;i++)
	{
		for(int j=i+1;j<total_ledgers;j++)
		{%>
		if(document.mainform.ledger<%=i%>.value == document.mainform.ledger<%=j%>.value)
		{
		alert ("Do Select Proper Account in Particulars");
		return false;
		}

	<%}
	}%>
}

</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditSaleForm1.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >

<input type=hidden name=old_date value=<%=old_date%>>
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=no_lots value=<%=total_lots%>>
<input type=hidden name=lotfocus >
<input type=hidden name="pdcount" value="<%=pdcount%>">

<input type=hidden name=ledgers value=<%=ledgercounter%>>
<input type=hidden name=old_ledgers value=<%=total_ledgers%>>
<input type=hidden name=org_ledgers value=<%=org_ledgers%>>



<tr>
<th colspan=8 align=center>Edit Sale </th>
</tr>

<tr>
<td>No :<input type=text name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'></td>
<td colspan=1>Ref No :<input type=text name=ref_no size=10 value="<%=ref_no%>"></td>
<!--<td colspan=1> </td>-->

<td>To,</td>
<td>
<%
String condition="Where Super=0  and Sale=1 and active=1";
%>
<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
 <script language="javascript">
	var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
</script>	
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
</td>
<td>Sale Group</td>
<td>	
	<%=A.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>


 </tr>
<input type=hidden name="oldcompanyparty_id" value="<%=oldcompanyparty_id%>">

 <script language="JavaScript">

 function currencylabel()
	{
		var temp="<%=local_currencysymbol%>";
 
 		if(document.mainform.currency[1].checked)
		{
  			temp="$";
		}
		 document.mainform.currency_text.value=temp;
	}

 </script>

  <%
String disloc="";
String disdol="";
String local_currencysymbol_Show="";

if("dollar".equals(currency))
{
 disdol="checked";
 local_currencysymbol_Show="$";
 }
 else
{
local_currencysymbol_Show=local_currencysymbol;
disloc="checked";
}
%>
 


<tr>
<td colspan=1>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
</script></td>	<td>
<input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>"
onblur='return  fnCheckMultiDate(this,"Invioce Date")'></td>

<td colspan=1>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100'>")}
</script></td>	<td>
<input type=text name='stockdate' size=8 maxlength=10 value="<%=stockdate%>"
onblur='return  fnCheckMultiDate(this,"Stock Date")'></td>

<td colspan=1 align=right>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script>	</td><td>
<input type=text name='duedate' size=8 maxlength=10 value="<%=due_date%>"
onblur='return  fnCheckMultiDate1(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=due_dateold%>"></td>


</tr>

<tr>

<% if( (Iv_id>0 && Fv_id>0) || pdcount==0 )
	{%>
<td>Sale Type</td>
<td>
<Select name=cash_id >
	<option value=0>Regular</option>
</select><%//=AC.getCashAccounts(conp,"cash_id",cash_id,company_id,"1")%></td>
<input type=hidden name="Inv_id" value="<%=Iv_id%>">
<input type=hidden name="Finv_id" value="<%=Fv_id%>">

<%	}
else{%>
<input type=hidden name="cash_id" value="0">
<input type=hidden name="Inv_id" value="<%=Iv_id%>">
<input type=hidden name="Finv_id" value="<%=Fv_id%>">
<%}%>

<% if(Integer.parseInt(old_lots)!=0)
	{%>

	<td>Location</td>
	<td>
	<%=AC.getMasterArrayCondition(conp,"Location","masterlocation",newlocation_id[0],"where company_id="+company_id)%>
	<%//=A.getName(conp,"Location",newlocation_id[0])%></td>
	<%}%>
	<td>Category &nbsp;&nbsp;&nbsp <%=AC.getArrayConditionAll(conp,"Master_LotCategory","category_id",category_id,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%> </td>
  
<td width=200>Currency &nbsp;&nbsp;&nbsp
	<input onclick='currencylabel()' type=radio name="currency"  value=local <%=disloc%>> Local
	<input type=radio onclick='currencylabel()' name="currency" value=dollar <%=disdol%>> Dollar
</td>
</tr>
<tr>
<td colspan=1>Sales Person </td>
<td>
<%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=0 and Active=1 and company_id="+company_id+"") %>
</td>
<%
if("0".equals(currency_id))
{
local_currencysymbol="US $";	
%>
<input type=hidden name=currency value=dollar> 

<% } else {
local_currencysymbol=local_currencysymbol;
%> 
<input type=hidden name=currency value=local> 
<% } %>

<td>Exchange Rate &nbsp;&nbsp</td>
<td><input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this,2)"  size=4 style="text-align:right">
</td>
<td>Due Days</td>
<td><input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"><input type=hidden name="duedaysold" value="<%=duedaysold%>"> </td>
</tr>


<% if(Integer.parseInt(old_lots)!=0)
	{%>

<tr>
<td>Sr No</td>
<td>Lot No</td>
<!-- <td>Location</td> -->

<td>Quantity</td>
<td>Rate / Unit</td>
<td colspan=1>Amount in
	<input type=text name=currency_text readonly value='<%=currency_text%>' size=3></td>
<td>Remarks</td>
</tr>


<% 
String temp1="";
for (int i=0;i<(counter-1);i++)
{
	if("yes".equals(deleted[i]))
	{
		temp1="readonly";
		%>
			<tr bgcolor=red >
		<%
	}
		else
	{
			temp1="";
		%>
			<tr>
		<% }//end else
%>

<td><%=i+1%></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name="deleted<%=i%>" value="<%=deleted[i]%>">

<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> value="<%=newlotno[i]%>"  size=10 <%=temp1%> autocomplete=off onfocus='handleFocus("newlotno<%=i%>")'> 
</td>

<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>"></td>
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >

<td>
	<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
	<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='validate(this,3)' style="text-align:right" <%=temp1%>>
</td>
<td><input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5  style="text-align:right" <%=temp1%>></td>

<td align=left>
	<input type=text name=amount<%=i%> value="<%=amount[i]%>" size=8 style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.lotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)' <%=temp1%>>
	<input type=hidden name=hiddenamount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>">
</td>
<td>
	<input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8 <%=temp1%>>
</td>
</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>	
<%
}
	
for (int i=counter-1;i<(total_lots-1);i++)
{
%>
<input type=hidden name="deleted<%=i%>" value="no">

<tr><td><%=i+1%></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%>  value="noid">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> size=10 onBlur='return nullvalidation(this)' value="" autocomplete=off onfocus='handleFocus("newlotno<%=i%>")'>
</td>

<input type=hidden name="location_id<%=i%>" value="<%=location_id[0]%>">
<input type=hidden name="newlocation_id<%=i%>" value="<%=newlocation_id[0]%>">

<input type=hidden name=pcs<%=i%> value="0">
<td><input type=hidden name=old_quantity<%=i%> value="0">
	<input type=text name=quantity<%=i%> value="0" size=5 OnBlur='validate(this,3)' style="text-align:right">
</td>
<td><input type=text name=rate<%=i%> value="1" size=5 style="text-align:right"></td>
<td><input type=text name=amount<%=i%> value="0" size=8 style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.newlotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)'>
<input type=hidden name=hiddenamount<%=i%> value="0"></td>
<td><input type=text name=remarks<%=i%> value="" size=8></td>
</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>	

<%
}
}

for(int i=0;i<ledgercounter;i++)
{

if("yes".equals(findeleted[i]))
{%>
<tr bgcolor=red > 
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=org_transacionid[i]%>">
<input type="hidden" name="findeleted<%=i%>" value="<%=findeleted[i]%>"> </td>

<td colspan=4 align=left>
	<%=A.getNameCondition(conp,"Ledger","Ledger_Name","where Ledger_Id="+ledger[i]+"") %> &nbsp;&nbsp;&nbsp;&nbsp;<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>"></td>

<td colspan=1 align=left>
	<input type=text name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onChange='return calcLedgerRow(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
	<input type=hidden name="hiddenacamount<%=i%>" value="<%=acamount[i]%>">
</td>

<%if("1".equals(debitcredit[i])) 
 {%>
	<td colspan=1>
		<select name= "debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
			<option value="1" selected>Dr</option>
		</select>
	</td>
<%} 
  else
  { %>
	<td colspan=1>
		<select name="debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
			<option value="-1">Cr</option>
		</select>
	 </td>
<%}%>
</tr>
<% 	
}
else {
	%>
<tr>
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=org_transacionid[i]%>">
<input type="hidden" name="findeleted<%=i%>" value="<%=findeleted[i]%>"></td>

<td colspan=3 align=left><%=A.getArray(conp,"Ledger","ledger"+i,ledger[i],company_id +" and yearend_id="+yearend_id,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;</td>

<td colspan=1 align=left> 
	<input type=text name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onChange='return calcLedgerRow(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
	<input type=hidden name="hiddenacamount<%=i%>" value="<%=acamount[i]%>">
</td><!-- onBlur="validate(this)" -->

<%if("1".equals(debitcredit[i])) 
{%>
	<td colspan=1>
		<select name= "debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
			<option value="1" selected>Dr</option>
			<option value="-1">Cr</option>
		</select>
	</td>
<%}
  else 
  { %>
	<td colspan=1>
		<select name="debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
			<option value="1">Dr</option>
			<option value="-1" selected>Cr</option>
		</select>
	 </td>
<%}%>
</tr>

<% 
	}//end else
   %>



<%}
%>

<% 
//out.print("<br>1364 ledgercounter"+ledgercounter);
 //out.print("<br> 1365total_ledgers"+total_ledgers);
	for(int i=ledgercounter;i<total_ledgers;i++)
{%>
<tr>
<td><%=i+1%>
	<input type="hidden" name="org_transacionid<%=i%>" value="noid">
	<input type="hidden" name="findeleted<%=i%>" value="no">
</td>

<td colspan=3 align=left><%=A.getArray(conp,"Ledger","ledger"+i,"",company_id+" and yearend_id="+yearend_id ,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;
</td>

<td colspan=1 align=left>
	<input type=text name="acamount<%=i%>" value="0" style="text-align:right" size="8" onChange='return calcLedgerRow(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'><!-- onBlur="validate(this)" -->
	<input type=hidden name="hiddenacamount<%=i%>" value="0">
</td>

<td colspan=1>
	<select name="debitcredit<%=i%>" onchange='return calcDebitCredit(document.mainform.findeleted<%=i%>, document.mainform.acamount<%=i%>, document.mainform.hiddenacamount<%=i%>, document.mainform.debitcredit<%=i%>)'>
		<option value="1">Dr</option>
		<option value="-1">Cr</option>
	</select>
</td>

</tr>

<%}%>
<input type=hidden name="ledgers" value="<%=total_ledgers%>">
<input type=hidden name="org_ledgers" value="<%=old_ledgers%>">
<input type=hidden name="old_ledgers" value="<%=old_ledgers%>">

<input type=hidden name=discount size=8 value="0" style="text-align:right">
<input type=hidden name=discount_amt size=8  style="text-align:right" value="0">
<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 value="<%=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 OnBlur='return calcTotal(this)'  style="text-align:right" value="0"></td>
<td colspan=2></td>
</tr> -->

<tr>
<td colspan=4 align=left>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1 align=left><input type=text name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"></td>
<td colspan=2></td>
</tr>
<tr>
<!-- <td colspan=1></td> -->
<td colspan=3>C.Tax (%)</td>
<td colspan=1 align=left><input type=text name=ctax size=8  value="<%=ctax%>" style="text-align:right"></td>
<td align=left><input type=text name=ctax_amt size=8 OnBlur='return CtaxCal()' style="text-align:right" value="0"></td>
<td colspan=2></td>
</tr>
<tr>
<!-- <td colspan=1></td> -->
<td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1 align=left><input type=text readonly name=total size=8 value="<%=total%>" style="text-align:right"></td><!--  OnBlur='return finalTotal()' -->
</tr>

<tr>
<!-- <td colspan=1></td> -->
<!--<td colspan=4>Difference Account in <%=local_currencysymbol%></td>-->
<!--<td colspan=1 align=left>--><input type=hidden name=difference size=8  style="text-align:right" value="0"></td>
<input type=hidden name=diffdebit value="-1">

<td colspan=4>Narration:
	<input type=text size=75 name=description value="<%=description%>"></td> 
<% if("1".equals(diffdebit))
	{%>
<!--<td><select name="diffdebit"><option value="1" selected>Dr</option><option value="-1">Cr</option></select></td>-->
<%	}
	else
	{%>
<!--<td><select name="diffdebit"><option value="1">Dr</option><option value="-1" selected>Cr</option></select></td>-->
<% }%>
</tr>


<%
tempFlag=request.getParameter("tempFlag"); 

%>
	<input type=hidden name=tempFlag value="<%=tempFlag%>">



<tr>

<td colspan=8 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)' class='button1'> &nbsp;&nbsp;
<input type=text name=addlots size=2 value="1" onBlur="validate(this)" style="text-align:right">

<% if(Integer.parseInt(old_lots)!=0)
	{%>

<input type=radio name="lotledger" value="lot" checked>&nbsp;&nbsp; Add Lot &nbsp;&nbsp;
<input type=radio name="lotledger" value="ledger">&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
<%} else
	{%>
<input type=radio name="lotledger" value="ledger" checked>&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
	<%}%>
<input type=submit name=command value=ADD
	 class='button1'><!-- OnClick='return finalTotal()' -->
&nbsp;&nbsp;
<input type=submit name=command value=NEXT class='button1'  OnClick='return finalTotal()'>
</td>

</tr>
</TABLE>
</td>
</tr>
<% if(Integer.parseInt(old_lots)!=0)
	{%>

<!-- <tr>
<TD align=right rowspan=4>
<IFRAME name=bottom align=right src="../Inventory/InvSearch.jsp?command=Search&location_id=<%//=1%>&inv_date=<%//=datevalue%>" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="1" scrolling="auto" align="right" width='100%' height='100%'>
</IFRAME></TD>
</tr> -->
<%}%>
</table>
</FORM>
</BODY>
</HTML>
<%
C.returnConnection(conp);

C.returnConnection(cong);
	}//if add

}
catch(Exception Samyak1031){
C.returnConnection(conp);

C.returnConnection(cong);
out.println("<font color=red> FileName : EditSaleForm1.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							ADD Form End 
--------------------------------------------------------  -->


<!---------------------------------------------------------
							NEXT Form Start
----------------------------------------------------------->

<%
try{
//	conp=C.getConnection();
  
if("NEXT".equals(command))
{

String old_date=request.getParameter("old_date");
/*String narr=request.getParameter("narration");
String refno=request.getParameter("refno");

if(narr.equals(""))
{ narr="--";}
if(refno.equals(""))
{ refno="--";}*/

String tempFlag=request.getParameter("tempFlag"); 

%>
	<input type=hidden name=tempFlag value="<%=tempFlag%>">
<%



//out.print("Next");
String category_id=request.getParameter("category_id");
//int addlots=Integer.parseInt(request.getParameter("addlots"));
int addlots=0;
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
int Final_lots=(Integer.parseInt(lots));
//out.println("<center><br>Final lots: "+Final_lots+"</center>");
String old_lots = request.getParameter("old_lots");
//out.println("<center><br>old_lots: "+old_lots+"</center>");
String oldreceive_no = request.getParameter("oldreceive_no");

String ledgers = request.getParameter("ledgers");
String old_ledgers = request.getParameter("old_ledgers");
String org_ledgers = request.getParameter("org_ledgers");
int totalledgers=Integer.parseInt(old_ledgers);

String cash_id=request.getParameter("cash_id");
//out.print("<br>1683 cash_id "+cash_id);
int Fv_id=Integer.parseInt( request.getParameter("Finv_id") );
int Iv_id=Integer.parseInt( request.getParameter("Inv_id") );
int pdcount=Integer.parseInt(request.getParameter("pdcount"));


String consignment_no = request.getParameter("consignment_no");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> Stock Date "+stockdate);
String stockdateold = request.getParameter("stockdateold");

 //out.println("Line No 979: currecy"+currency);
String companyparty_name= request.getParameter("companyparty_name");
String companyparty_id= A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Id", " Where companyparty_name='"+companyparty_name+"' and company_id="+company_id );
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");

String exchange_rate = request.getParameter("exchange_rate");
String salesperson_id = request.getParameter("salesperson_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String due_date = request.getParameter("duedate");
String due_dateold = request.getParameter("due_dateold");
//out.print("<br>Due Date"+due_date);
//out.print("<br>Due Date old"+due_dateold);

String duedays =""+ request.getParameter("duedays");
//out.print("<br>duedays "+duedays);
String duedaysold =""+ request.getParameter("duedaysold");
int finalduedays=Integer.parseInt(duedays);
//out.print("<br>finalduedays "+finalduedays);
String finalduedate=format.getDueDate(datevalue,finalduedays);
if(duedaysold.equals(duedays))
	{
	//out.print("<br>1317");
	if(due_date.equals(due_dateold))
		{
			//out.print("<br>1320");

			if(!(companyparty_id.equals(oldcompanyparty_id)))
			{
			finalduedays= Integer.parseInt(G.getFinalDueDays(conp,datevalue, companyparty_id));
			finalduedate=format.getDueDate(datevalue,finalduedays);
			}
		}
	else
		{
			//out.print("<br>1330");

			finalduedate=due_date;
			finalduedays=Integer.parseInt(format.getDueDays(datevalue,finalduedate));
		}	
	}
//out.print("<br>finalduedays "+finalduedays);
String receive_date=""+datevalue;
String currency = request.getParameter("currency");
//out.print("<br>currency"+currency);

if ("dollar".equals(currency))
	{

	local_currencysymbol="$";
	  d=2;

	}

String currency_id = request.getParameter("currency_id");
//out.print("<br>currency_id "+currency_id);

double difference=Double.parseDouble(request.getParameter("difference"));
String diffdebit=request.getParameter("diffdebit");

int nolots_old=Integer.parseInt(lots);
//out.print("<br>nolots_old "+nolots_old);
int counter=Final_lots;
String lotid[]=new String[counter];
String newlotid[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String receivetransaction_id[]=new String[counter];
String lotno[]=new String[counter];
String newlotno[]=new String[counter];
String pcs[]=new String[counter];
String old_quantity[]=new String[counter];
String quantity[]=new String[counter];
String rate[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];
String deleted[]=new String[counter];
double qtyinhand[]=new double[counter];
boolean loc[]=new boolean[counter] ;
boolean lotexist[]=new boolean[counter] ;
String originalQuantity[]=new String[counter];
String returnQuantity[]=new String[counter];
String ghat[]=new String[counter];
String lotDiscount[]=new String[counter];
double total_newqty=0;
int lotflag=1;
int lotlocationpresent=0;
String lotabsent="";
for (int i=0;i<counter-1;i++)
{
loc[i]=false;
lotexist[i]=false;
location_id[i]=""+request.getParameter("location_id"+i);
newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
//out.print("<br> newlocation_id[i]"+newlocation_id[i]);

receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);

lotno[i]=""+request.getParameter("lotno"+i);
newlotno[i]=""+request.getParameter("newlotno"+i);
//out.print("<br>newlotno[i]="+newlotno[i]);

lotid[i]=""+request.getParameter("lotid"+i);
//out.print("<br>lotid[i] "+lotid[i]);

//-----------------
String lotquery="select *  from lot where Lot_No='"+newlotno[i]+"' and company_id="+company_id+"";
pstmt_p=conp.prepareStatement(lotquery);
rs_g=pstmt_p.executeQuery();
int lotcount=0;
while(rs_g.next())
	{
		//lotcount=rs_g.getInt("lotcount");
lotexist[i]=true;
newlotid[i]=rs_g.getString("Lot_Id");
	}
pstmt_p.close();
/*if(lotcount==0)
	{
		lotflag=0;
		lotabsent=newlotno[i];
		break;
	}
*/	
//---------------------
//newlotid[i]=A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No='"+newlotno[i]+"' and company_id="+company_id);
pcs[i]=""+request.getParameter("pcs"+i);
old_quantity[i]=""+request.getParameter("old_quantity"+i);
quantity[i]=""+request.getParameter("quantity"+i);
originalQuantity[i]=""+request.getParameter("originalQuantity"+i);
//out.print("<br>originalQuantity="+originalQuantity[i]);
returnQuantity[i]=""+request.getParameter("returnQuantity"+i);
//out.print("<br>returnQuantity="+returnQuantity[i]);
ghat[i]=""+request.getParameter("ghat"+i);
//out.print("<br>ghat="+ghat[i]);
lotDiscount[i]=""+request.getParameter("lotDiscount"+i);
//out.print("<br>lotDiscount="+lotDiscount[i]);

double lotlocationqty=0;

String lotlocationquery="select * from LotLocation where Lot_id=? and Location_Id=?";
pstmt_p=conp.prepareStatement(lotlocationquery);
pstmt_p.setString(1,newlotid[i]);
pstmt_p.setString(2,newlocation_id[i]);
rs_g=pstmt_p.executeQuery();
while(rs_g.next())
{
	lotlocationqty=rs_g.getDouble("Available_Carats");
  lotlocationpresent=1;
loc[i]=true;

}
pstmt_p.close();

/*	out.print("<br>lotid="+lotid[i]);
	out.print("<br>newlotid="+newlotid[i]);
	out.print("<br>location_id="+location_id[i]);
	out.print("<br>newlocation_id="+newlocation_id[i]);
*/
total_newqty +=Double.parseDouble(quantity[i]);
if((lotid[i].equals(newlotid[i])) &&(location_id[i].equals(newlocation_id[i])))
	{
/*	out.print("<br>lotlocationqty="+lotlocationqty);
	out.print("<br>old_quantity="+old_quantity[i]);
	out.print("<br>quantity="+quantity[i]);*/

qtyinhand[i]=(lotlocationqty+Double.parseDouble(old_quantity[i])-Double.parseDouble(quantity[i]));
	}
else{
qtyinhand[i]=lotlocationqty-Double.parseDouble(quantity[i]);
}

rate[i]=""+request.getParameter("rate"+i); 
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted-"+i+deleted[i]);
}//end for

String org_transacionid[]=new String[totalledgers];
String findeleted[]=new String[totalledgers];
String ledger[]=new String[totalledgers];
double acamount[]=new double[totalledgers];
String debitcredit[]=new String[totalledgers];

for (int i=0;i<totalledgers;i++)
{

org_transacionid[i]=""+request.getParameter("org_transacionid"+i);
findeleted[i]=""+request.getParameter("findeleted"+i);
ledger[i]=request.getParameter("ledger"+i);
acamount[i]=Double.parseDouble(request.getParameter("acamount"+i));
debitcredit[i]=request.getParameter("debitcredit"+i);
}

//-------------
%>
<html>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">	
<%
lotlocationpresent=0;
lotflag=0;

for (int i=0;i<counter-1;i++)
{
//out.print(loc[i]);
if(!lotexist[i])
	{
	
	out.print("<br><center><font class=msgred>Lot No<font class=msgblue>"+newlotno[i]+"</font> Does Not Exists</font>");
}
else{
lotflag +=1;}


if((!loc[i]) && (lotexist[i]) )
	{
	
	out.print("<br><center> <font class=msgred> Lot No <font class=msgblue>"+newlotno[i]+" </font> Does Not Exists Onselected Location " +A.getName(conp,"Location",newlocation_id[i])+"</font></center>");
	C.returnConnection(conp);
	}
else{
	lotlocationpresent+=1;}

//------------------
}//for
/*out.print("counter="+counter);
out.print("lotflag="+lotflag);
out.print("lotlocationpresent="+lotlocationpresent);*/
if((lotflag < (counter-1))||(lotlocationpresent< (counter-1)))
{
	
	out.print("<br><center><input type=button name=command value=Back onclick='history.back(1)' class=button1> </center>");
	
}
else
{

String add_lots = request.getParameter("addlots");
//int newlots=Integer.parseInt(add_lots);
int newlots=0;
int total_lots=counter+newlots;
//out.println("Line No 979: total_lots"+total_lots);
String subtotal =""+ request.getParameter("subtotal");
String ctax =""+ request.getParameter("ctax");
String discount =""+ request.getParameter("discount");
double discount_amount=
Double.parseDouble(subtotal)*Double.parseDouble(discount)/100;
double ctax_amount=Double.parseDouble(request.getParameter("ctax_amt"));
//out.println("2164 ctax_amount:"+ctax_amount);
double total_amount=
Double.parseDouble(request.getParameter("total"));

String total =""+ request.getParameter("total");

//int d=0;
if ("dollar".equals(currency))
	{local_currencysymbol="$";
	}


int no_i=0;
//out.println("oldreceive_no:"+oldreceive_no);
//out.println("consignment_no:"+consignment_no);
if(oldreceive_no.equals(consignment_no))
{ 
//out.println("Same");
}
else
{ 
//out.println("Different");
String noquery="Select * from  Receive where Receive_No=? and company_id=? and Receive_Sell=0";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,consignment_no); 
pstmt_p.setString(2,company_id); 
rs_g = pstmt_p.executeQuery();

	while(rs_g.next()) 	
	{
	no_i++;
	}
	pstmt_p.close();
//out.print("<br>no_i" +no_i);
}
if(no_i > 0)
	{
	
%>
<%
out.print("<br><center>Sale No "+consignment_no+ " already exist. </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}
else{

//out.print("else");
int j=0;
int flag= 0;
int final_flag=1; 
double carats[]=new double[counter] ;
double sell_quantity[]=new double[counter] ;
String lot_id[]= new String[counter];
int LessQtyNo=0;
boolean lot_flag[]=new boolean[counter]; 
boolean loc_flag[]=new boolean[counter]; 
boolean qty_flag[]=new boolean[counter]; 
boolean locqty_flag[]=new boolean[counter]; 
double totalPhysicalCarats[]=new double[counter] ;
double loccarats[]=new double[counter] ;
double totalFinanceCarats[]=new double[counter] ;

if(final_flag==1)	
{
%>
</html>
<html>
<head>
<title>Samyak Software</title>
<script language="JavaScript">
function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate

function validate(name)
{
	if(name.value =="") 
	{ alert("Please Enter Number "); 
	name.value="0"+name.value ;
	name.focus();}
	if(isNaN(name.value)) 
	{ alert("Please Enter Number Properly"); name.select();}
	if(name.value.charAt(0) == ".") 
	{ name.value="0"+name.value+"0"; }
	}// validate

function calcTotal(name)
	{
	validate(name)
	alert ("2437 Ok Inside CalcTotal");
	var subtotal=0;
	<%
	for(int i=0;i<(counter+addlots)-1;i++)
	{
	out.print("document.mainform.amount"+i+".value=(document.mainform.quantity"+i+".value) * (document.mainform.rate"+i+".value);");
	out.print("subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount"+i+".value);");
	}//end for 
	%>
document.mainform.subtotal.value=subtotal;
var discount_amt= (subtotal*document.mainform.discount.value)/100;
var temp_total= subtotal - discount_amt;
var tax_amt= (temp_total*document.mainform.ctax.value)/100;
var finaltotal=temp_total + tax_amt;
document.mainform.total.value=finaltotal;
document.mainform.ctax_amt.value=tax_amt;
document.mainform.discount_amt.value=discount_amt;

if(isNaN(subtotal))
{ 
return false;
} 
else{
return true;
}
}// calcTotal

function onSubmitValidate()
	{
	var finaltotal=document.mainform.total.value;
	if(isNaN(finaltotal))
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
	}//onSubmitValidate
</script>
<script language="JavaScript">
function processing(name)
	 {
		mainform.submit();
		name.disabled=true;
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
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<link href='../Samyak/tablecss.css' rel=stylesheet type='text/css'>
</head>

<!-- onSubmit='return onSubmitValidate()' -->
<body bgColor=#ffffee background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="indiaEditSaleUpdate.jsp?command=UPDATE" method=post >
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2 width='90%'>
<tr><td>
<TABLE  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 bordercolor=#d9d9d9 >
<input type=hidden name=old_date value=<%=old_date%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value=<%=counter+1%>>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>


<tr bgcolor=skyblue>
<th colspan=9 align=center>Edit Sale </th>
</tr>
<%
String salesperson_name= A.getName(conp,"SalesPerson",salesperson_id);
/*
String condition="Where Super=0 and Transaction_Currency=1 and Sale=1 and active=1";
if("0".equals(currency_id))
{
condition="Where Super=0 and Transaction_Currency=0 and Sale=1 and active=1";
}*/
String party_name= A.getName(conp,"companyparty",companyparty_id);

if("dollar".equals(currency))
{
local_currencysymbol="US $";	
%>
<input type=hidden name=currency value=dollar> 

<% } else {
local_currencysymbol=local_currencysymbol;
%> 
<input type=hidden name=currency value=local> 
<% } %>

<% if( (Iv_id>0 && Fv_id>0) || pdcount==0 )
	{
	if( ! ("0".equals(cash_id) ) )
		{%>
<tr>
	<td>Sale Type</td>
	<td><Select name=cash_id >
	<option value=0>Regular</option>
</select><%//=A.getNameCondition(conp,"Master_Account","Account_Name","where Account_Id="+cash_id)%></td>
<input type=hidden name="cash_id" value="<%=cash_id%>">
<input type=hidden name="Inv_id" value="<%=Iv_id%>">
<input type=hidden name="Finv_id" value="<%=Fv_id%>">
</tr>
<%	}
	else
		{
		%>
<input type=hidden name="cash_id" value="<%=cash_id%>">
<input type=hidden name="Inv_id" value="<%=Iv_id%>">
<input type=hidden name="Finv_id" value="<%=Fv_id%>">
<%	
		}	
}
else{%>
<input type=hidden name="cash_id" value="0">
<input type=hidden name="Inv_id" value="<%=Iv_id%>">
<input type=hidden name="Finv_id" value="<%=Fv_id%>">
<%}%>
<input type=hidden name="pdcount" value="<%=pdcount%>">
<input type=hidden name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'>
<input type=hidden size=10 value="<%=ref_no%>" maxlength=10 name=ref_no>
<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
<input type=hidden name=oldcompanyparty_id value="<%=oldcompanyparty_id%>">
 <input type=hidden name=datevalue size=8 value="<%=receive_date%>" onblur='return  fnCheckDate(this.value,"Date")'>
 <input type=hidden name="stockdate" value="<%=stockdate%>">
 <input type=hidden name=finalduedays size=1 value="<%=finalduedays%>" onBlur="validate(this)" style="text-align:right">
 <input type=hidden name='finalduedate' size=8 maxlength=10 value="<%=finalduedate%>"
onblur='return  fnCheckMultiDate1(this,"Due Date")'>
<tr>
<td><b>No:</td>
<td><%=consignment_no%></td>
<td><b>Ref No:</td>
<td><%=ref_no%></td>
<td><b>To:</td>
<td><%=party_name%></td>
<td><b>By:</td>
<td><%=company_name%></td>
</tr>
<tr>
<td><b>Invoice Date:</td>
<td><%=receive_date%></td>
<td><b>Stock Date :</td>
<td><%=stockdate%></td>
<td><b>Due Days</td>
<td><%=finalduedays%></td>
<td><b>Due Date :</td>
<td><%=finalduedate%></td>
</tr>
<input type=hidden name=salesperson_id value='<%=salesperson_id%>'>
<input type=hidden name=purchasesalegroup_id value='<%=purchasesalegroup_id%>'>
<input type=hidden name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
<tr>
<td><b>Location:</td>	<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+newlocation_id[0])%></td>
<td><b>Sales Person :</td>
<td> <%=salesperson_name%></td>
<td><b>Sales Group:</td> <td><%=A.getNameCondition(conp,"Master_PurchaseSaleGroup","PurchaseSaleGroup_Name","where PurchaseSaleGroup_Id="+purchasesalegroup_id)%>
</td>
<td><b>Exchange Rate :</td>
<td><%=str.format(exchange_rate)%></td>
</tr>
</table>
<TABLE borderColor=silver align=center border=1  cellspacing=0 cellpadding=2 width='100%'>
<tr>
<td>Sr No</td>
<td>Lot No</td>
<td>Original Quantity</td>
<td>Return Quantity</td>
<td>Ghat</td>
<td>Selection Quantity</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Lot Discount %</td>
<td>Remarks</td>
</tr>
<% 
	int deletedcount=0;
	String bg="";
for (int i=0;i<counter-1;i++)
{

	if("yes".equals(deleted[i]))
	{
	deletedcount++;
	bg="bgcolor=red";
	}
	else
	{
		bg="";
	}
	

%>
<tr <%=bg%>><td><%=i+1%></td><input type=hidden name="deleted<%=i%>" value="<%=deleted[i]%>">
<td><%=newlotno[i]%> </td>

<td align="right"><%=str.format(""+originalQuantity[i],3)%></td>
<td align="right"><%=str.format(""+returnQuantity[i],3)%></td>
<td align="right"><%=str.format(""+ghat[i],3)%></td>
<td align="right"><%=str.format(""+quantity[i],3)%>
</td>

<td align="right"><%=str.mathformat(rate[i],d)%></td>
<td align="right"><%=str.format(""+amount[i],d)%> </td>
<td align="left"><%=lotDiscount[i]%> </td>
<td>&nbsp;<%=remarks[i]%></td>
</tr>

<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lotid<%=i%> value="nolotid">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>">
<input type=hidden name="newlocation_id<%=i%>" value="<%=newlocation_id[0]%>"> 
<input type=hidden name="newlotid<%=i%>" value="<%=newlotid[i]%>"> 
<input type=hidden name="location_id<%=i%>" value="<%=location_id[i]%>">
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >
<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
<input type=hidden name=originalQuantity<%=i%> value="<%=originalQuantity[i]%>" >
<input type=hidden name=returnQuantity<%=i%> value="<%=returnQuantity[i]%>" >
<input type=hidden name=ghat<%=i%> value="<%=ghat[i]%>" >
<input type=hidden name=quantity<%=i%> value="<%=quantity[i]%>" > 
<input type=hidden name=rate<%=i%> value="<%=rate[i]%>" >
<input type=hidden name=amount<%=i%> value="<%=amount[i]%>" >
<input type=hidden name=lotDiscount<%=i%> value="<%=lotDiscount[i]%>" >
<input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>">

<%
}
%>
<input type=hidden name="category_id" value="<%=category_id%>">

<input type=hidden name=deletedcount value='<%=deletedcount%>' >




<input type=hidden name="ledgers" value="<%=totalledgers%>">
 <input type=hidden name="org_ledgers" value="<%=org_ledgers%>">
 <%
for(int i=0;i<totalledgers;i++)
{

if("yes".equals(findeleted[i]))
{%>
<tr bgcolor=red > 
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=org_transacionid[i]%>">
<input type="hidden" name="findeleted<%=i%>" value="<%=findeleted[i]%>"> </td>

<td colspan=5 align=right>

	<%=A.getNameCondition(conp,"Ledger","Ledger_Name","where Ledger_Id="+ledger[i]+"") %> &nbsp;&nbsp;&nbsp;&nbsp;<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>"></td>

<td colspan=1 align=right> <input type=hidden name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onBlur="validate(this)" readonly><%=str.format(""+acamount[i],d)%></td>
<%if("1".equals(debitcredit[i])) {%>
<td colspan=1>Dr <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"></td>
<%} else { %>
<td colspan=1>Cr <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"></td>
<%}%>
</tr>
<% 	
}
else {
	%>
<tr>
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=org_transacionid[i]%>">
<input type="hidden" name="findeleted<%=i%>" value="<%=findeleted[i]%>"> </td>
<td colspan=6 align=right>
	<%=A.getNameCondition(conp,"Ledger","Ledger_Name","where Ledger_Id="+ledger[i]+"") %> &nbsp;&nbsp;&nbsp;&nbsp;<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>"></td>

<td colspan=1 align=right> <input type=hidden name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onBlur="validate(this)"> <%=str.format(""+acamount[i],d)%></td>
<%if("1".equals(debitcredit[i])) {%>
<td colspan=1>Dr <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"></td>
<%} else { %>
<td colspan=1>Cr <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"></td>
<%}%>
</tr>

<% 
	}//end else
}
   %>

<input type=hidden name=discount size=8 OnBlur='return calcTotal(this)' value="0" style="text-align:right">

<input type=hidden name=discount_amt size=8 readonly style="text-align:right" value="0">
<!-- </tr>
<tr>
<td colspan=2>&nbsp;</td>
<td colspan=3>Discount (%)</td>
<td colspan=1 align="right"><input type=hidden name=discount size=8 OnBlur='return calcTotal(this)' value="<%=discount%>" style="text-align:right"><%=discount%></td>
<td colspan=1 align="right"><input type=hidden name=discount_amt size=8 readonly style="text-align:right" value="<%=discount_amount%>"> <%=str.format(""+discount_amount,d)%></td>
<td colspan=2>&nbsp;</td>

</tr> -->
<input type=hidden name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right">
<tr>
<td colspan=7> Sub Total in <%=local_currencysymbol%></td>
<td colspan=1 align="right"><%=str.format(""+subtotal,d)%></td>
<td colspan=1>&nbsp;</td>
</tr>
<input type=hidden name=ctax size=8 OnBlur='return calcTotal(this)' value="<%=ctax%>" style="text-align:right">
<input type=hidden name=ctax_amt size=8 readonly style="text-align:right" value="<%=ctax_amount%>">
<tr>
<td colspan=6>C.Tax (%)</td>
<td colspan=1 align="right"> <%=str.format(""+ctax,2)%></td>
<td align="right"><%=str.format(""+ctax_amount,d)%></td>
<td colspan=1>&nbsp;</td>
</tr>
<input type=hidden readonly name=total size=8 value="<%=total_amount%>" style="text-align:right">
<tr>
<td colspan=7>Total in <%=local_currencysymbol%></td>
<td colspan=1 align="right"><%=str.format(""+total_amount,d)%> </td>
<td colspan=1>&nbsp;</td>
</tr>
</tr>
</table>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2 width='100%'>
<tr>
<input type=hidden readonly name=difference size=10 value="0">
<input type=hidden name="diffdebit" value="-1">
<input type=hidden name=description size=75 value="<%=description%>">
<td colspan=1><b>Narration:</td>
<td colspan=9><%=description%></td>
<% if("1".equals(diffdebit))
	{%>
<!--<td colspan=1 align=left>&nbsp;&nbsp;Dr</td>-->
<% }
else
	{
%>
<!--<td colspan=1 align=left>&nbsp;&nbsp;Cr</td>-->
<%}%>
<!--<td>Narration:</td>
<td><input type=text name=description size=75 value="<%=description%>"></td> -->
</tr>


  <!-- <input type=hidden name=narr value="<%//=narr%>"> -->
  

<%
tempFlag=request.getParameter("tempFlag"); 

%>
	<input type=hidden name=tempFlag value="<%=tempFlag%>">




<td colspan=7 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1'> &nbsp; &nbsp;&nbsp;<input type=submit name=command value=UPDATE class='button1' onclick="processing(this)"> </td>
</tr>
</TABLE>
</td>
</tr>
</table>
</FORM>
</BODY>
</HTML>
<%  }// if final flag_1

	} // else if no_i
}//else lot present
//C.returnConnection(conp);
C.returnConnection(conp);
C.returnConnection(cong);

}//if add


}
catch(Exception Samyak1031){ 
C.returnConnection(conp);
C.returnConnection(cong);
out.println("<font color=red> FileName : EditSaleForm1.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							NEXT Form End 
--------------------------------------------------------  -->
