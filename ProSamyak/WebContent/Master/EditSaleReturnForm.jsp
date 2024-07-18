<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"  class="NipponBean.Array" />
<jsp:useBean id="C" scope="application"  class="NipponBean.Connect" />
<jsp:useBean id="I"  class="NipponBean.Inventory" />
<jsp:useBean id="G"  class="NipponBean.GetDate" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />

<%
Connection conp = null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : LotMovement.jsp<br>Bug No e31 : "+ e31);}


String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

ResultSet rs_g= null;
//Connection cong = null;
//Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
/*try	{
	conp=C.getConnection();
	cong=C.getConnection();
	}
catch(Exception e31)
	{ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);
	}*/

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);


String command=request.getParameter("command");
//out.print("<br><center><font color=red>command=" +command+"</font></center>");
%>



<%
try{
// conp=C.getConnection();
//	cong=C.getConnection();

if("pedit".equals(command))
	{
//out.println("Inside Sale Edit ");
String receive_id=request.getParameter("receive_id");
//out.print("<br>receive_id=" +receive_id);
String ref_no="";
String description="";

String tempv="";
tempv=""+A.getNameCondition(conp,"Voucher","Voucher_Id","where Voucher_No='"+receive_id+"'");
ref_no=""+A.getNameCondition(conp,"Voucher","Ref_No","where Voucher_Id="+tempv);
description=""+A.getNameCondition(conp,"Voucher","Description","where Voucher_Id="+tempv);
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
String Consignment_ReceiveId="";

String purchasesalegroup_id="";

double Difference_Amount=0;

String query="Select * from Receive where Receive_Id=?";
//out.println("<br>73 Query12"+query);
pstmt_g = conp.prepareStatement(query);
	pstmt_g.setString(1,receive_id); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
		{
receive_no=rs_g.getString("Receive_No");
receive_date=rs_g.getDate("Receive_Date");
counter=rs_g.getInt("Receive_Lots");
currency_id=rs_g.getString("Receive_CurrencyId");
exchange_rate=rs_g.getDouble("Exchange_rate");
ctax=rs_g.getDouble("Tax");
total= rs_g.getDouble("Receive_Total");
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
Consignment_ReceiveId = rs_g.getString("Consignment_ReceiveId");
//out.print("102 Consignment_ReceiveId"+Consignment_ReceiveId);

}
pstmt_g.close();
//out.print("<br>99 currency_id=" +currency_id);
//C.returnConnection(cong);

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
pstmt_p = conp.prepareStatement(company_query);
//out.println("<BR>"+company_query);
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
//out.println("<BR>132 company id is= "+companyparty_id);
String companyparty_name="";
String address1="";
String city="";
String country="";
String phone_off="";

String company_queryy="select * from Master_CompanyParty where active=1 and companyparty_id="+companyparty_id;
pstmt_p = conp.prepareStatement(company_queryy);
//out.println("<br>"+company_queryy);
rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
//	out.println("<br>Inside While 145");
	companyparty_name= rs_g.getString("CompanyParty_Name");		
	address1= rs_g.getString("Address1");		
	city= rs_g.getString("City");		
	country= rs_g.getString("Country");		
	phone_off= rs_g.getString("Phone_Off");		

	}
pstmt_p.close();

//out.println("<br>Outsude  While 155");

double quantity[]=new double[counter];
double rate[]=new double[counter];
double amount[]=new double[counter];
double amount_tocompare[]=new double[counter+10];
double receiveprice_topunch[]=new double[counter+10];
double ctax_amt=0;
double temp_amt=0;
//double discount_amt=0;
String remarks[]=new String[counter]; 
String receivetransaction_id[]=new String[counter]; 
String lot_id[]=new String[counter]; 
String lot_no[]=new String[counter]; 
String location_id[]=new String[counter]; 
String pcs[]=new String[counter];

String newConsignment_ReceiveId[]=new String[counter];

query="Select * from Receive_Transaction where Receive_Id=? and active=1";
pstmt_g = conp.prepareStatement(query);
	pstmt_g.setString(1,receive_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;

String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;
if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{
local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}

	while(rs_g.next())
		{
receivetransaction_id[n]=rs_g.getString("ReceiveTransaction_id");
//out.print("<br>193receivetransaction_id[n] "+receivetransaction_id[n]);
lot_id[n]=rs_g.getString("Lot_Id");
location_id[n]=rs_g.getString("location_id");
//out.print("<br>locaation_id "+location_id[n]);
quantity[n]= rs_g.getDouble("Quantity");
rate[n]= rs_g.getDouble("Receive_Price"); 
//out.print("<br>198rate[n] "+rate[n]);
pcs[n]=rs_g.getString("Pieces");
remarks[n]=rs_g.getString("Remarks"); 
amount[n]= str.mathformat((quantity[n] * rate[n]),d) ;
subtotal += str.mathformat(amount[n],d) ;
n++;
		}//while

pstmt_g.close();


if(!"0".equals(Consignment_ReceiveId))
{
	int nn=0;
	int ntemp = 0;
	for (int i=0;i<counter;i++)
	{
	//	out.print("<br>317 Inside for");

		query="Select Consignment_ReceiveId from Receive_Transaction where ReceiveTransaction_Id=?";
		pstmt_g = conp.prepareStatement(query);
		pstmt_g.setString(1,receivetransaction_id[i]);
		rs_g = pstmt_g.executeQuery();	
	//	out.print("<br> 323 receivetransaction_id[i] :"+receivetransaction_id[i]);
		while(rs_g.next())
			{
				newConsignment_ReceiveId[i]=rs_g.getString("Consignment_ReceiveId");
				//out.print("<br>224 newConsignment_ReceiveId[i]"+newConsignment_ReceiveId[i]);
				nn++;
			}//while
			pstmt_g.close();
	}



	for (int i=0;i<counter;i++)
	{

		query="Select * from Receive_Transaction where ReceiveTransaction_Id=?";
		pstmt_g = conp.prepareStatement(query);
		pstmt_g.setString(1,newConsignment_ReceiveId[i]);
		rs_g = pstmt_g.executeQuery();	
	//	int nn=0;
		ntemp=0;
		while(rs_g.next())
			{

				
				amount_tocompare[i]=rs_g.getDouble("Available_Quantity");
				receiveprice_topunch[i] = rs_g.getDouble("Receive_Price");
				amount_tocompare[i] = amount_tocompare[i] + quantity[i];
				//out.print("<br>240 amount_tocompare[i]"+amount_tocompare[i]+"<br>");
				

				ntemp++;
			}//while
			pstmt_p.close();
	}

}



//discount_amt = subtotal * (discount/100);
temp_amt = subtotal ;
//	- discount_amt;
ctax_amt = str.mathformat((temp_amt * (ctax/100)),d);
total= str.mathformat((temp_amt + ctax_amt),d);
//out.print("<br>subtotal=" +subtotal);
//out.print("<br>ctax_amt=" +ctax_amt);
//out.print("<br>204 total=" +total);

for (int i=0;i<counter;i++)
{
//	out.print("<br>208 ");

lot_no[i]=A.getName(conp,"Lot", "Lot_No", lot_id[i]);
//out.print("<br>211 ");
}//for
/*
String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;
if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{
local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}
*/

String testvoucher_id= A.getNameCondition(conp,"Voucher","Voucher_Id","Where Voucher_Type=11 and Voucher_No='"+receive_id+"'" );
String ctax_id= A.getNameCondition(conp,"Ledger","ledger_id","Where Ledger_Name='C. Tax' and Company_id="+company_id+"" ); 
int ledgers= Integer.parseInt(A.getNameCondition(conp,"Voucher","ToBy_Nos","Where Voucher_Type=11 and Voucher_No='"+receive_id+"'"));
//out.print("ledgers toby"+ledgers);

//out.print("receive_id 228 "+receive_id);
//out.print("ledgers"+ledgers);
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
	for(int i=0;i<ledgers;i++)
	{%>
		if(!document.mainform.findeleted<%=i%>.checked)
		{
		var le_amt<%=i%>=parseFloat(document.mainform.acamount<%=i%>.value)
		var le_db<%=i%>=parseFloat(document.mainform.debitcredit<%=i%>.value)
		le_amt<%=i%>=le_amt<%=i%>*(le_db<%=i%>);
		subtotal1=subtotal1+le_amt<%=i%>;
		}
	<%}%>
	//alert(subtotal1);
	return subtotal1;
}


function calcTotal(name)
{
var subtotal1=calcLedgers();
var d=<%=d%>;
validate(name)
//alert ("Ok Inside CalcTotal"+d);
var subtotal=0;
<%
for(int i=0;i<counter;i++)
{

%>
if(!(document.mainform.deleted<%=i%>.checked))
{

validate(document.mainform.rate<%=i%>);
validate(document.mainform.amount<%=i%>,d);
<% if("0".equals(Consignment_ReceiveId))
	{%>

if((document.mainform.amount<%=i%>.value=="0")||(document.mainform.amount<%=i%>.value==""))
{

	var amt=(document.mainform.quantity<%=i%>.value) * (document.mainform.rate<%=i%>.value);

<%}else
	{
%>
	var amt=(document.mainform.quantity<%=i%>.value)* (document.mainform.receiveprice_topunch<%=i%>.value);
<%	}
%>


//alert(amt);
 temp_amt= new String(amt);
 //alert(temp_amt);

var i_amt=temp_amt.indexOf(".") ;
var temp1_amt="";
if(i_amt>0)
	{
i_amt =parseInt(i_amt) + parseInt(d) + 1;
temp1_amt=temp_amt.substring(0,i_amt);
	}
else{temp1_amt=temp_amt;}
document.mainform.amount<%=i%>.value=temp1_amt;
<% if("0".equals(Consignment_ReceiveId))
	{%>
}
<%}%>

<% if("0".equals(Consignment_ReceiveId))
	{%>


if(document.mainform.rate<%=i%>.value=="0"){
document.mainform.rate<%=i%>.value=(document.mainform.amount<%=i%>.value) / (document.mainform.quantity<%=i%>.value);
}
if(document.mainform.amount<%=i%>.value != ((document.mainform.quantity<%=i%>.value)*(document.mainform.rate<%=i%>.value)))
{
if(document.mainform.amount<%=i%>.value > ((document.mainform.quantity<%=i%>.value)*(document.mainform.rate<%=i%>.value))) {
document.mainform.rate<%=i%>.value=(document.mainform.amount<%=i%>.value) / (document.mainform.quantity<%=i%>.value);
}
else{
var amt=(document.mainform.quantity<%=i%>.value) * (document.mainform.rate<%=i%>.value);

 temp_amt= new String(amt);
var i_amt=temp_amt.indexOf(".") ;
var temp1_amt="";
if(i_amt>0)
{
i_amt =i_amt + d + 1
temp1_amt=temp_amt.substring(0,i_amt);
}
else{
temp1_amt=temp_amt;
}
document.mainform.amount<%=i%>.value=temp1_amt;


}

}//if

<%}%>

subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount<%=i%>.value);
//alert(subtotal);
}//end if checked
<%

}//end for 
%>
var taxable_total=parseFloat(subtotal)+parseFloat(subtotal1);
//alert(taxable_total);
temp_sub = new String(subtotal);
var i_sub=temp_sub.indexOf(".") ;
var temp1_sub="";
if(i_sub>0)
	{
i_sub =i_sub + d +1 ;
temp1_sub=temp_sub.substring(0,i_sub);
subtotal=temp1_sub;
	}
document.mainform.subtotal.value=subtotal;
var temp_total= parseFloat(taxable_total);
var tax_amt= 0;
if((document.mainform.ctax_amt.value=="")){
tax_amt=
(temp_total*document.mainform.ctax.value)/100;
 temp_tax= new String(tax_amt);
var i_tax=temp_tax.indexOf(".") ;
var temp1_tax="";
if(i_tax>0)
{
i_tax=i_tax +d +1 ;
temp1_tax=temp_tax.substring(0,i_tax);
}
else{
temp_tax=temp1_tax;
}
document.mainform.ctax_amt.value=temp1_tax;

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

 temp_tax= new String(tax_amt);
var i_tax=temp_tax.indexOf(".") ;
var temp1_tax="";
if(i_tax>0)
	{
i_tax=i_tax +d +1 ;
temp1_tax=temp_tax.substring(0,i_tax);
	}
else{temp1_tax=temp_tax;}
document.mainform.ctax_amt.value=temp1_tax;


}
}

//var finaltotal=temp_total+tax_amt;
var finaltotal= parseFloat(taxable_total)+
parseFloat(document.mainform.ctax_amt.value);
//var finaltotal= parseFloat(document.mainform.subtotal.value)+
parseFloat(document.mainform.ctax_amt.value);
 temp_tot= new String(finaltotal);
var i_tot=temp_tot.indexOf(".") ;
var temp1_tot="";
if(i_tot>0)
	{
i_tot=i_tot +d +1 ;
temp1_tot=temp_tot.substring(0,i_tot);
	}
else{temp1_tot=temp_tot;}

document.mainform.total.value=temp1_tot;

if(isNaN(subtotal))
{ 
return false;
} 
else{
return true;
}
}// calcTotal

function newlocation()
{
<%
for(int i=0;i<counter;i++)
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



<%
	if("0".equals(Consignment_ReceiveId))
	{
%>
			newlocation();
<%
	}

%>
	calcTotal(document.mainform.total);
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

function quantity(name)
{
	
	validate(name,3)
		flag = 0;
<%
int temp = Integer.parseInt(Consignment_ReceiveId);
if(temp > 0)
{
for(int i=0;i<counter;i++)
	{%>

	val1=parseFloat(document.mainform.amount_tocompare<%=i%>.value)
		
  //val3=parseFloat(document.mainform.old_quantity<%=i%>.value)
   //al1 = val1 + val3
	val2=parseFloat(document.mainform.quantity<%=i%>.value)

	//	alert("val1 :"+val1)
	//	alert("val2 :"+val2)

		if(val2>(val1+0.005))
		{

			alert("Return Quantity Should be less than "+(val1+0.005));
			document.mainform.quantity<%=i%>.select();
			//return false;
			flag = 1 
		}


	<%}
	%>
		if(flag == 0)
			return true
		else
		    return false 
<%	
}%>
}// quantity

function copyDate(name,field)
{
flag = fnCheckMultiDate(name,field)
//	alert(field);
if(flag==true)
{
		if(field=="Invoice Date")
			document.mainform.stockdate.value = document.mainform.datevalue.value;		
		
		if(field=="Stock Date")
			document.mainform.datevalue.value = document.mainform.stockdate.value; 

// alert()
	return true
}
else
	return false
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
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>
<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG" onload="calcTotal(document.mainform.total)">
<FORM name=mainform
action="EditSaleReturnForm.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<input type=hidden name=lotfocus >

<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=0>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0>
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=receive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value=<%=counter+1%>>

<input type=hidden name=old_lots value=<%=counter%>>

<input type=hidden name=ledgers value=<%=ledgers%>>
<input type=hidden name=old_ledgers value=<%=ledgers%>>
<input type=hidden name=org_ledgers value=<%=ledgers%>>
<!--	----------------------------------------------------------------------       -->
<input type="hidden" name="Consignment_ReceiveId" value="<%=Consignment_ReceiveId%>" >
<% //out.print("Consignment_ReceiveId"+Consignment_ReceiveId);      %>


<tr>
<th colspan=8 align=center>Edit Sale Return</th>
</tr>

<tr>
<td colspan=1>No 
<input type=text name=consignment_no size=5 value="<%=receive_no%>" onBlur='return nullvalidation(this)'></td>

<td colspan=1>Ref No 
<input type=text name=ref_no size=10 value="<%=ref_no%>"></td>

<td colspan=1>To:
<%=company_name%></td>

<td align=left>From:</td>
<td>
<%
String condition="Where Super=0 and Sale=1 and active=1";
if("0".equals(currency_id))
{
condition="Where Super=0 and  Sale=1 and active=1";
}
%>
<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
	 <script language="javascript">
		var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
	</script>	
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
<input type=hidden name="oldcompanyparty_id" value="<%=companyparty_id%>">
<td colspan=3>Sale Group
	
	<%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>


</tr>
<script language="JavaScript">
  function stdate()
{

temp=document.mainform.datevalue.value;
document.mainform.stockdate.value = temp;
}



	 </script>
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
</script>
<input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(receive_date)%>"
onchange='stdate();' onfocus='stdate();' onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'
>
</td>

<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100'>")}
</script>
<input type=text name='stockdate' size=8 maxlength=10 value="<%=format.format(stockdate)%>" onblur='return  fnCheckMultiDate(this,"Stock Date")'><input type=hidden name="stockdateold" value="<%=format.format(stockdate)%>">
</td>

<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script>
<input type=text name='due_date' size=8 maxlength=10 value="<%=format.format(due_date)%>"
onblur='return  fnCheckMultiDate1(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=format.format(due_date)%>">
</td>
	
<td >Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name="duedaysold" value="<%=duedays%>"></td>

</tr>

<tr>
<%if(counter!=0)
	{%>

<td>Location</td>

<%
	if(!"0".equals(Consignment_ReceiveId))
	{
%>
		<td COLSPAN=2> 
		<%=AC.getMasterArrayCondition(conp,"Location","location_id0",A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id),"where Active=1",company_id)%></td>
<%
	}
	else
	{
%>
	
		<td COLSPAN=1> 
		<%=A.getMasterArrayCondition(conp,"Location","masterlocation",location_id[0],"where company_id="+company_id)%></td>

<%
	}
%>

	<%}%>

<td colspan=2>Purchase Person
  <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id","","where company_id="+company_id+"")%>
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

<td>Exchange Rate </td>	
<td><input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>

<%if(counter!=0)
	{%>

<tr>
<td>Sr No/Delete</td>
<td>Lot No</td>
<!-- <td>Location</td> -->

<td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>
<% 
 String rate_rd="";
	if("0".equals(Consignment_ReceiveId))
	{
		rate_rd="";
	}
	else
	{
		rate_rd="readonly";
	}

for (int i=0;i<counter;i++)
{
%>
<tr><td><%=i+1%><input type="checkbox" name="deleted<%=i%>" value="yes" onclick=' return calcTotal(document.mainform.ctax_amt)'></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lot_id<%=i%> value="<%=lot_id[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">

<input type=hidden name=amount_tocompare<%=i%> value="<%=amount_tocompare[i]%>">

<input type=hidden name=newlocation_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lot_no[i]%>">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> autocomplete=off value="<%=lot_no[i]%>" size=10 onBlur='return nullvalidation(this)'  onfocus='handleFocus("newlotno<%=i%>")' <%= rate_rd %>></td>
<!-- 	<td><%//=A.getName("Location",location_id[i])%></td>-->
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >
<td>
<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='return quantity(this)' style="text-align:right"></td>
<%
if("0".equals(Consignment_ReceiveId))
	{
%>
		<td><input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5  style="text-align:right"></td>


<%	}
	else
	{
%>

		<td><input type=text name=receiveprice_topunch<%=i%> value="<%=receiveprice_topunch[i]%>" size=5  style="text-align:right" readonly></td>
			<input type=hidden name=rate<%=i%> value="<%=rate[i]%>">

<%
	}
%>
<td><input type=text name=amount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>" size=8 style="text-align:right" OnBlur='return calcTotal(this)'></td>
<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
</tr>
<script language="javascript">

	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
			
</script>	
<%
}// end for
	}//end if
%>

<tr>
<td colspan=1></td>
<td colspan=4>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=str.mathformat(""+subtotal,d)%>" style="text-align:right"></td>
<td colspan=1></td>
</tr>



<%
/* 
				Start of code for financail transactions       
*/

//out.print("<br>testvoucher_id=" +testvoucher_id);
//out.print("<br>ledgers=" +ledgers);

String intital_subtotal="";
query="Select * from Financial_Transaction where Voucher_Id=? and active=1 and Sr_No=0 and ledger_id="+ctax_id+"";
pstmt_g = conp.prepareStatement(query);
pstmt_g.setString(1,testvoucher_id); 
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{
intital_subtotal=rs_g.getString("Amount");
}
pstmt_g.close();
//out.print("<br>675ledgers="+ledgers);

String Tranasaction_Id[]=new String[ledgers]; 
String Sr_No[]=new String[ledgers]; 
String Transaction_Type[]=new String[ledgers]; 
String Amount[]=new String[ledgers]; 
String Ledger_Id[]=new String[ledgers]; 
if(ledgers!=0)
{

query="Select * from Financial_Transaction FT , Voucher V where V.Voucher_Id=FT.Voucher_Id and V.Voucher_type=11 and V.voucher_No='"+receive_id+"' and FT.Active=1 and Ledger_Id > "+ctax_id+" order by Tranasaction_Id";
pstmt_g = conp.prepareStatement(query);
//pstmt_g.setString(1,testvoucher_id); 
rs_g = pstmt_g.executeQuery();	
int k=0; //k is local variable for row count loop
while(rs_g.next())
{
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

k++;
}//while
pstmt_g.close();
}
//out.print("<br>703K="+k);
//out.print("<br>703ledgers="+ledgers);
%>
	
<%
for(int i=0;i<ledgers;i++)
{%>
<tr>
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=Tranasaction_Id[i]%>">
<input type="checkbox" name="findeleted<%=i%>" value="yes"> </td>
<td colspan=4 align=right>  <%=A.getArray(conp,"Ledger","ledger"+i,Ledger_Id[i],company_id +" and yearend_id="+yearend_id,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td colspan=1 align=left><input type=text name="acamount<%=i%>" value="<%=str.mathformat(""+Amount[i],d)%>"  style="text-align:right" size="8"></td>
<%if("0".equals(Transaction_Type[i])) {%>
<td colspan=1><select name= "debitcredit<%=i%>"><option value="1" selected>Dr</option><option value="-1">Cr</option></select></td>
<%} else { %>
<td colspan=1><select name="debitcredit<%=i%>"><option value="1">Dr</option><option value="-1" selected>Cr</option></select></td>
<%}%>
</tr>
<%
	}

/* 
	
End of code for financail transactions       
*/
%>
<!-- 
	<tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 readonly style="text-align:right" value="<%//=(discount*subtotal)%>"></td>
<td colspan=2></td>
</tr>
--> 




<tr>
<td colspan=1></td>
<td colspan=3>Tax (%)</td>
<td colspan=1><input type=text name=ctax size=8  value="<%=ctax%>" style="text-align:right"></td>


<td><input type=text name=ctax_amt size=8 OnBlur='return calcTotal(this)' style="text-align:right" value="<%=str.mathformat(intital_subtotal,d)%>"></td>
<td colspan=1></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=1>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=str.mathformat(""+org_receivetotal,d)%>" style="text-align:right" OnBlur='return calcTotal(this)'><input type=hidden name=old_total  value="<%=str.mathformat(""+org_receivetotal,d)%>"></td>
</tr>

<%
if(Difference_Amount<0)
{
%><tr>
<td colspan=1></td>
<!--<td colspan=4>Difference Account in <%=local_currencysymbol%></td>
<td colspan=1>--><input type=text name=difference size=10  style="text-align:right" value="0"><!--</td> -->
<!--<td><select name="diffdebit"><option value="1">Dr</option><option value="-1">Cr</option></select></td>-->
<td colspan=6>Narration<input type=text name=description size=75  value="<%=description%>"></td>

</tr>
	<%	}
	else{
%>
<tr>
<!--<td colspan=1></td>
<td colspan=4>Difference Account in <%=local_currencysymbol%></td>
<td colspan=1>--><input type=hidden name=difference size=10  style="text-align:right" value="0"><!--</td>-->
<input type=hidden name=diffdebit  value="-1">
<!--<select name="diffdebit"><option value="-1">Cr</option> <option value="1">Dr</option></select></td>-->
<td colspan=6>Narration<input type=text name=description size=75  value="<%=description%>"></td>
</tr>
	<%
	}
%>

<tr>

<td colspan=8 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)' class='button1'> &nbsp;&nbsp;
<input type=text name=addlots size=2 value="1" onBlur="validate(this)" style="text-align:right">
<% if(counter!=0)
	{%>
<input type=radio name="lotledger" value="lot" checked>&nbsp;&nbsp; Add Lot &nbsp;&nbsp;
<input type=radio name="lotledger" value="ledger">&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
<%}
else
	{
%>
<input type=radio name="lotledger" value="ledger" checked>&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
<%}%>
<% String add_dis="";
	if("0".equals(Consignment_ReceiveId))
	{
		add_dis="";
	}
	else
	{
		add_dis="disabled";
	}
%>


<input type=submit name=command value=ADD
	onClick='return confirm("Do You want to ADD ?")' class='button1' <%= add_dis %>>
&nbsp;&nbsp;
<input type=submit name=command value=NEXT class='button1'>
</td>

</tr>




</TABLE>
</td>
</tr>
<%
	if(counter!=0)
	{
	
	%>
<!-- 	<tr>
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
}//if pedit

//C.returnConnection(conp);
}
catch(Exception e631){ 
out.println("<font color=red> FileName : EditSale.jsp command=sedit<br>Bug No e631 : "+ e631);}



%>

<!---------------------------------------------------------
							ADD Form Start
---------------------------------------------------------->

<%
try{

if("ADD".equals(command))
{
int addlots=Integer.parseInt(request.getParameter("addlots"));
String lotledger=request.getParameter("lotledger");
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
	newledgers=Integer.parseInt(add_ledgers);
	}

String oldreceive_no=request.getParameter("oldreceive_no");
String receive_no=request.getParameter("receive_no");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
String old_lots = request.getParameter("old_lots");
String old_total = request.getParameter("old_total");

String ledgers = request.getParameter("ledgers");
String old_ledgers = request.getParameter("old_ledgers");
String org_ledgers = request.getParameter("org_ledgers");
int ledgercounter=Integer.parseInt(old_ledgers);

String consignment_no = request.getParameter("consignment_no");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> stock date "+stockdate );
String stockdateold = request.getParameter("stockdateold");
String due_date = request.getParameter("due_date");
String due_dateold = request.getParameter("due_dateold");
String receive_date=""+datevalue;
String currency = request.getParameter("currency");
String currency_id = request.getParameter("currency_id");
String salesperson_id=request.getParameter("salesperson_id");
String purchasesalegroup_id=request.getParameter("purchasesalegroup_id");

String exchange_rate = request.getParameter("exchange_rate");
int nolots_old=Integer.parseInt(lots);
int counter=nolots_old;
String deleted[]=new String[counter];
String lotid[]=new String[counter];
String receivetransaction_id[]=new String[counter];
String lotno[]=new String[counter];
String newlotno[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String pcs[]=new String[counter];
String old_quantity[]=new String[counter];
String quantity[]=new String[counter];
String rate[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];
 String Consignment_ReceiveId="";

Consignment_ReceiveId =""+request.getParameter("Consignment_ReceiveId");

 //out.print("Consignment_ReceiveId"+Consignment_ReceiveId);      

for (int i=0;i<counter-1;i++)
{
deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted[i] "+deleted[i]);
lotid[i]=""+request.getParameter("lot_id"+i);
//out.print("Lot_id"+i+lotid[i]);
receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);

lotno[i]=""+request.getParameter("lotno"+i);
newlotno[i]=""+request.getParameter("newlotno"+i);
location_id[i]=""+request.getParameter("location_id"+i);
newlocation_id[i]=""+request.getParameter("newlocation_id"+i);

pcs[i]=""+request.getParameter("pcs"+i);
old_quantity[i]=""+request.getParameter("old_quantity"+i);
quantity[i]=""+request.getParameter("quantity"+i);
rate[i]=""+request.getParameter("rate"+i); 
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
}

int total_lots=counter+newlots;


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

String companyparty_name = request.getParameter("companyparty_name");
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");
String subtotal =""+ request.getParameter("subtotal");
String ctax =""+ request.getParameter("ctax");
//String discount =""+ request.getParameter("discount");
String total =""+ request.getParameter("total");
String duedays =""+ request.getParameter("duedays");
String duedaysold =""+ request.getParameter("duedaysold");

String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;

if ("dollar".equals(currency))
	{local_currencysymbol="$";}

if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{

local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}

 %>

<html>
<head><title>Samyak Software</title>

<script language='JavaScript'>

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

if(name.value =="" ) 
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
		le_amt<%=i%>=le_amt<%=i%>*(le_db<%=i%>);
		subtotal1=subtotal1+le_amt<%=i%>;
		}
	<%}%>
	//alert(subtotal1);
	return subtotal1;
}

function calcTotal(name)
{
var subtotal1=calcLedgers();
var d=<%=d%>;
validate(name)
//alert ("Ok Inside CalcTotal"+d);
var subtotal=0;
<%
for(int i=0;i<(total_lots-1);i++)
{
%>
	if(!(document.mainform.deleted<%=i%>.value=='yes'))
{

validate(document.mainform.rate<%=i%>);
validate(document.mainform.amount<%=i%>,d);

<% if("0".equals(Consignment_ReceiveId))
	{%>
if((document.mainform.amount<%=i%>.value=="0")||(document.mainform.amount<%=i%>.value==""))
{
<%}%>

var amt=(document.mainform.quantity<%=i%>.value) * (document.mainform.rate<%=i%>.value);
//alert(amt);
 temp_amt= new String(amt);
 //alert(temp_amt);

var i_amt=temp_amt.indexOf(".") ;
var temp1_amt="";
if(i_amt>0)
	{
i_amt =parseInt(i_amt) + parseInt(d) + 1;
temp1_amt=temp_amt.substring(0,i_amt);
	}
else{temp1_amt=temp_amt;}
document.mainform.amount<%=i%>.value=temp1_amt;

<% if("0".equals(Consignment_ReceiveId))
	{%>

}

<%}%>

<% if("0".equals(Consignment_ReceiveId))
	{%>


if(document.mainform.rate<%=i%>.value=="0"){
document.mainform.rate<%=i%>.value=(document.mainform.amount<%=i%>.value) / (document.mainform.quantity<%=i%>.value);
}
if(document.mainform.amount<%=i%>.value != ((document.mainform.quantity<%=i%>.value)*(document.mainform.rate<%=i%>.value)))
{
if(document.mainform.amount<%=i%>.value > ((document.mainform.quantity<%=i%>.value)*(document.mainform.rate<%=i%>.value))) {
document.mainform.rate<%=i%>.value=(document.mainform.amount<%=i%>.value) / (document.mainform.quantity<%=i%>.value);
}
else{
var amt=(document.mainform.quantity<%=i%>.value) * (document.mainform.rate<%=i%>.value);

 temp_amt= new String(amt);
var i_amt=temp_amt.indexOf(".") ;
var temp1_amt="";
if(i_amt>0)
{
i_amt =i_amt + d + 1
temp1_amt=temp_amt.substring(0,i_amt);
}
else{
temp1_amt=temp_amt;
}
document.mainform.amount<%=i%>.value=temp1_amt;


}

}//if
<%}%>

subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount<%=i%>.value);
}//end if
<%

}//end for 
%>
var taxable_total=parseFloat(subtotal)+parseFloat(subtotal1);

temp_sub = new String(subtotal);
var i_sub=temp_sub.indexOf(".") ;
var temp1_sub="";
if(i_sub>0)
	{
i_sub =i_sub + d +1 ;
temp1_sub=temp_sub.substring(0,i_sub);
subtotal=temp1_sub;
	}
document.mainform.subtotal.value=subtotal;
var temp_total= parseFloat(taxable_total);
var tax_amt= 0;
if((document.mainform.ctax_amt.value=="")){
tax_amt=
(temp_total*document.mainform.ctax.value)/100;
 temp_tax= new String(tax_amt);
var i_tax=temp_tax.indexOf(".") ;
var temp1_tax="";
if(i_tax>0)
{
i_tax=i_tax +d +1 ;
temp1_tax=temp_tax.substring(0,i_tax);
}
else{
temp_tax=temp1_tax;
}
document.mainform.ctax_amt.value=temp1_tax;

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

 temp_tax= new String(tax_amt);
var i_tax=temp_tax.indexOf(".") ;
var temp1_tax="";
if(i_tax>0)
	{
i_tax=i_tax +d +1 ;
temp1_tax=temp_tax.substring(0,i_tax);
	}
else{temp1_tax=temp_tax;}
document.mainform.ctax_amt.value=temp1_tax;


}
}

//var finaltotal=temp_total+tax_amt;
var finaltotal= parseFloat(taxable_total)+
parseFloat(document.mainform.ctax_amt.value);
 temp_tot= new String(finaltotal);
var i_tot=temp_tot.indexOf(".") ;
var temp1_tot="";
if(i_tot>0)
	{
i_tot=i_tot +d +1 ;
temp1_tot=temp_tot.substring(0,i_tot);
	}
else{temp1_tot=temp_tot;}

document.mainform.total.value=temp1_tot;

if(isNaN(subtotal))
{ 
return false;
} 
else{
return true;
}
}// calcTotal


function onLocalSubmitValidate()
	{
	a=nonrepeat();
	calcTotal(document.mainform.total);

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
	return  fnCheckDate(document.mainform.datevalue.value,"Date")
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

function copyDate(name,field)
{
flag = fnCheckMultiDate(name,field)
//	alert(field);
if(flag==true)
{
		if(field=="Invoice Date")
			document.mainform.stockdate.value = document.mainform.datevalue.value;		
		
		if(field=="Stock Date")
			document.mainform.datevalue.value = document.mainform.stockdate.value; 

// alert()
	return true
}
else
	return false
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
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditSaleReturnForm.jsp?" method=post onSubmit='return onLocalSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=0 WIDTH="90%">
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=no_lots value=<%=total_lots%>>

<input type=hidden name=ledgers value=<%=ledgercounter%>>
<input type=hidden name=old_ledgers value=<%=total_ledgers%>>
<input type=hidden name=org_ledgers value=<%=org_ledgers%>>

<input type=hidden name=salesperson_id value="<%=salesperson_id%>">
<input type=hidden name=lotfocus >

<tr>
<th colspan=7 align=center>Edit Sale Return </th>
</tr>

<tr>
<td>No
 <input type=text name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'></td>
<td >Ref No
 <input type=text name=ref_no size=10 value="<%=ref_no%>"></td>
	<!-- onBlur='return nullvalidation(this)'></td>-->
 
 <td colspan=1>To:-<%=company_name%></td>
<td>From:</td>
<td>
<%
String condition="Where Super=0  and Sale=1 and active=1";
if("0".equals(currency_id))
{
condition="Where Super=0 and Transaction_Currency=0 and Sale=1 and active=1";
}
%>
<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
 <script language="javascript">
	var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
</script>	
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
<input type=hidden name="oldcompanyparty_id" value="<%=oldcompanyparty_id%>"></td>
<td colspan=2>Sale Group : <%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>
</tr>
 <script language="JavaScript">
  function stdate()
{

temp=document.mainform.datevalue.value;
document.mainform.stockdate.value = temp;
}



	 </script>
<tr>
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
</script>	
<input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>"
onchange='stdate();' onfocus='stdate();' >
</td>

<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100'>")}
</script>	
<input type=text name='stockdate' size=8 maxlength=10 value="<%=stockdate%>" ><input type=hidden name="stockdateold" value="<%=stockdateold%>"></td>

<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script>	
<input type=text name='due_date' size=8 maxlength=10 value="<%=due_date%>"
onblur='return  fnCheckMultiDate1(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=due_dateold%>"></td>
<td>Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"><input type=hidden name="duedaysold" value="<%=duedaysold%>"> </td>
</tr>

<tr>
<% if(Integer.parseInt(old_lots)!=0)
	{%>
<td>Location</td>
<td><%=A.getName(conp,"Location",newlocation_id[0])%></td>
<%}%>
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
<td>Purchase Person</td>
<td > <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where company_id="+company_id+"")%>
</td>
<td>Exchange Rate </td>	
<td><input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>
<% if(Integer.parseInt(old_lots)!=0)
	{%>

<tr>
<td>Sr No</td>
<td>Lot No</td>
<!-- <td>Location</td> -->

<td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>
<%}%>
<% 
String temp1="";
for (int i=0;i<counter-1;i++)
{
	
	if("yes".equals(deleted[i]))
	{	temp1="readonly"; 		%>
		<tr bgcolor=red > 	<% 	}
	else {
		temp1="";
	%>
		<tr>
	<% 
	}//end else
   %>

	
<td><%=i+1%></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name="deleted<%=i%>" value="<%=deleted[i]%>">
<input type=hidden name=lot_id<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>" size=10 onBlur='return nullvalidation(this)' >
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> autocomplete=off value="<%=newlotno[i]%>"  size=10 <%=temp1%>  onfocus='handleFocus("newlotno<%=i%>")'> </td>

<input type=hidden name=Consignment_ReceiveId value=<%=Consignment_ReceiveId%>>

<!-- <td><%//=A.getName("Location",location_id[i])%></td> -->
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>">
<td>
<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='validate(this,3)' <%=temp1%> style="text-align:right">
</td>
<td><input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5 <%=temp1%> style="text-align:right"></td>
<td><input type=text name=amount<%=i%> value="<%=amount[i]%>" size=8 <%=temp1%> style="text-align:right" OnBlur='return calcTotal(this)'></td>
<td><input type=text <%=temp1%> name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
		

</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>	
<% //}//end if


}//end of first for in ADD



for (int i=counter-1;i<((counter-1)+newlots);i++)
{
%>

<tr><td><%=i+1%></td>
<td>
	<input type=hidden name="deleted<%=i%>" value="no">

<input type=hidden name=receivetransaction_id<%=i%>  value="noid">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> size=10 onBlur='return nullvalidation(this)' value="" autocomplete=off onfocus='handleFocus("newlotno<%=i%>")'></td>
<!-- <td><%//=A.getMasterArray("Location","location_id"+i,"",company_id)%>
</td> -->
<input type=hidden name="location_id<%=i%>" value="<%=location_id[0]%>">
<input type=hidden name="newlocation_id<%=i%>" value="<%=newlocation_id[0]%>">
<input type=hidden name=pcs<%=i%> value="0" >
<td><input type=hidden name=old_quantity<%=i%> value="0">
	<input type=text name=quantity<%=i%> value="1" size=5 OnBlur='validate(this,3)' style="text-align:right">
</td>
<td><input type=text name=rate<%=i%> value="0" size=5 style="text-align:right"></td>
<td><input type=text name=amount<%=i%> value="0" size=8 style="text-align:right" OnBlur='return calcTotal(this)' ></td>
<td><input type=text name=remarks<%=i%> value="" size=8></td>
</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>	
<%
}
%>

<tr>
<td colspan=1></td>
<td colspan=4>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"></td>
<td colspan=1></td>
</tr>
<%
for(int i=0;i<ledgercounter;i++)
{

if("yes".equals(findeleted[i]))
{%>
<tr bgcolor=red > 
<td><%=i+1%>
<input type="hidden" name="org_transacionid<%=i%>" value="<%=org_transacionid[i]%>">
<input type="hidden" name="findeleted<%=i%>" value="<%=findeleted[i]%>"> </td>

<td colspan=4 align=right>
	<%=A.getNameCondition(conp,"Ledger","Ledger_Name","where Ledger_Id="+ledger[i]+"") %> &nbsp;&nbsp;&nbsp;&nbsp;<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>"></td>
<td colspan=1 align=left> <input type=text name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onBlur="validate(this)" readonly></td>
<%if("1".equals(debitcredit[i])) {%>
<td colspan=1><select name= "debitcredit<%=i%>"><option value="1" selected>Dr</option></select></td>
<%} else { %>
<td colspan=1><select name="debitcredit<%=i%>"><option value="1">Dr</option></select></td>
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

<td colspan=4 align=right><%=A.getArray(conp,"Ledger","ledger"+i,ledger[i],company_id +" and yearend_id="+yearend_id,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td colspan=1 align=left> <input type=text name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onBlur="validate(this)"></td>
<%if("1".equals(debitcredit[i])) {%>
<td colspan=1><select name= "debitcredit<%=i%>"><option value="1" selected>Dr</option><option value="-1">Cr</option></select></td>
<%} else { %>
<td colspan=1><select name="debitcredit<%=i%>"><option value="1">Dr</option><option value="-1" selected>Cr</option></select></td>
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
<td><%=i+1%><input type="hidden" name="org_transacionid<%=i%>" value="noid">

	<input type="hidden" name="findeleted<%=i%>" value="no"> </td><td colspan=4 align=right><%=A.getArray(conp,"Ledger","ledger"+i,"",company_id+" and yearend_id="+yearend_id ,"Expense") %> &nbsp;&nbsp;&nbsp;&nbsp;</td>
<td colspan=1 align=left><input type=text name="acamount<%=i%>" value="0" style="text-align:right" size="8" onBlur="validate(this)"></td>
<td colspan=1><select name="debitcredit<%=i%>"><option value="1">Dr</option><option value="-1">Cr</option></select></td>
</tr>
<%}%>
<input type=hidden name="ledgers" value="<%=total_ledgers%>">
<input type=hidden name="org_ledgers" value="<%=old_ledgers%>">
<input type=hidden name="old_ledgers" value="<%=old_ledgers%>">


<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 readonly style="text-align:right" value=""></td>
<td colspan=2></td>
</tr>
 --><tr>
<td colspan=1></td>
<td colspan=3>Tax (%)</td>
<td colspan=1><input type=text name=ctax size=8  value="<%=ctax%>" style="text-align:right"></td>
<td><input type=text name=ctax_amt size=8 OnBlur='return calcTotal(this)' style="text-align:right" value="0"></td>
<td colspan=1></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=total%>" style="text-align:right" OnBlur='return calcTotal(this)' ><input type=hidden name=old_total  value="<%= old_total %>"></td>
</tr>

<tr>
<!--<td colspan=1></td>
<td colspan=4>Difference Account in <%=local_currencysymbol%></td>
<td colspan=1>--><input type=hidden name=difference size=10   value="0"><!--</td>-->
<td colspan=6>Narration<input type=text name=description size=75  value="<%=description%>"></td>
<% if("1".equals(diffdebit))
	{%>

<input type=hidden name=diffdebit  value="-1">

<!--<td><select name="diffdebit"><option value="1" selected>Dr</option><option value="-1">Cr</option></select></td>-->
<%	}
	else
	{%><input type=hidden name=diffdebit  value="-1">
<!--<td><select name="diffdebit"><option value="1">Dr</option><option value="-1" selected>Cr</option></select></td>-->
<% }%>
</tr>
<tr>

<td colspan=8 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)' class='button1'> &nbsp;&nbsp;
<input type=text name=addlots size=2 value="1" onBlur="validate(this)" style="text-align:right">
<% if(Integer.parseInt(old_lots)!=0)
	{%>
<input type=radio name="lotledger" value="lot" checked>&nbsp;&nbsp; Add Lot &nbsp;&nbsp;
<input type=radio name="lotledger" value="ledger">&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
<%}
else{%>
<input type=radio name="lotledger" value="ledger" checked>&nbsp;&nbsp; Add Ledger &nbsp;&nbsp;
<%}%>

<input type=submit name=command value=ADD
	onClick='return confirm("Do You want to ADD ?")' class='button1'>
&nbsp;&nbsp;
<input type=submit name=command value=NEXT class='button1'>
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
}//if add

}
catch(Exception Samyak1031){ 
out.println("<font color=red> FileName : EditPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							ADD Form End 
--------------------------------------------------------  -->


<!---------------------------------------------------------
							NEXT Form Start
----------------------------------------------------------->

<%
try{
	
if("NEXT".equals(command))
{
//		conp=C.getConnection();

//out.print("Next");
//int addlots=Integer.parseInt(request.getParameter("addlots"));
int addlots=0;
String receive_id=request.getParameter("receive_id");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");

String Consignment_ReceiveId=""+request.getParameter("Consignment_ReceiveId");
//out.print("br 1823 Consignment_ReceiveId"+Consignment_ReceiveId);
String lots = request.getParameter("no_lots");
int Final_lots=(Integer.parseInt(lots));
//out.println("<center><br>Final lots: "+Final_lots+"</center>");
String old_lots = request.getParameter("old_lots");
//out.print("<br>1521old_lots "+old_lots);
String ledgers = request.getParameter("ledgers");
String old_ledgers = request.getParameter("old_ledgers");
String org_ledgers = request.getParameter("org_ledgers");
int totalledgers=Integer.parseInt(old_ledgers);
String old_total = request.getParameter("old_total");


//out.println("<center><br>ledgers: "+ledgers+"</center>");
//out.println("<center><br>old_ledgers: "+old_ledgers+"</center>");
//out.println("<center><br>org_ledgers: "+org_ledgers+"</center>");
//out.println("<center><br>totalledgers: "+totalledgers+"</center>");
String oldreceive_no = request.getParameter("oldreceive_no");
String consignment_no = request.getParameter("consignment_no");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> Stock Date "+stockdate);
String stockdateold = request.getParameter("stockdateold");
String salesperson_id=request.getParameter("salesperson_id");
String purchasesalegroup_id=request.getParameter("purchasesalegroup_id");
String companyparty_name= request.getParameter("companyparty_name");
String companyparty_id= A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Id", " Where companyparty_name='"+companyparty_name+"' and company_id="+company_id );
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");

String due_date = request.getParameter("due_date");
String due_dateold = request.getParameter("due_dateold");
String duedays =""+ request.getParameter("duedays");
String duedaysold =""+ request.getParameter("duedaysold");
int finalduedays=Integer.parseInt(duedays);
String finalduedate=format.getDueDate(datevalue,finalduedays);
if(duedaysold.equals(duedays))
	{
	if(due_date.equals(due_dateold))
		{
			if(!(companyparty_id.equals(oldcompanyparty_id)))
			{
			finalduedays= Integer.parseInt(G.getFinalDueDays(conp,datevalue, companyparty_id));
			finalduedate=format.getDueDate(datevalue,finalduedays);
			}
		}
	else
		{
			finalduedate=due_date;
			finalduedays=Integer.parseInt(format.getDueDays(datevalue,finalduedate));
		}	
	}

String receive_date=""+datevalue;
String currency = request.getParameter("currency");
String currency_id = request.getParameter("currency_id");
//out.println("Line No 979: currecy"+currency);
double difference=Double.parseDouble(request.getParameter("difference"));
String diffdebit=request.getParameter("diffdebit");

String exchange_rate = request.getParameter("exchange_rate");
int nolots_old=Integer.parseInt(lots);

int counter=Final_lots;//****

String lotid[]=new String[counter];
String newlotid[]=new String[counter];
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
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String receiveprice_topunch[] =new String[counter];
double tot_newqty=0;
//out.print("acounter"+counter);
for (int i=0;i<counter-1;i++)
{

location_id[i]=""+request.getParameter("location_id"+i);
//out.print("<br>location_id[i]"+location_id[i]);

newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
//out.print("<br> newlocation_id[i]"+newlocation_id[i]);

deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted-"+i+deleted[i]);

lotno[i]=""+request.getParameter("lotno"+i);
newlotno[i]=""+request.getParameter("newlotno"+i);
//out.print("<br>newlotno[i]="+newlotno[i]);

receiveprice_topunch[i]=""+request.getParameter("receiveprice_topunch"+i);
//out.print("<br>receiveprice_topunch"+receiveprice_topunch[i]);
lotid[i]=""+request.getParameter("lot_id"+i);
//out.print("<br>Lotid"+lotid[i]);

newlotid[i]=A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No='"+newlotno[i]+"' and company_id="+company_id);
//out.print("<br> company_id= "+company_id);
//out.print("<br>newLotid"+newlotid[i]);

receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);
pcs[i]=""+request.getParameter("pcs"+i);
old_quantity[i]=""+request.getParameter("old_quantity"+i);
quantity[i]=""+request.getParameter("quantity"+i);
rate[i]=""+request.getParameter("rate"+i); 
//out.print("<br> 1981 rate[i]"+rate[i]);
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 

tot_newqty +=Double.parseDouble(quantity[i]);
}



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






String querynewlot="";
String lotcount[]=new String[counter];
	int lotflag=0;
for(int i=0;i<counter-1;i++)
{
	//out.print("<br>For");

	querynewlot="select * from Lot where Lot_No='"+newlotno[i]+"' and company_id="+company_id;
	pstmt_p=conp.prepareStatement(querynewlot);
	rs_g=pstmt_p.executeQuery();
	while(rs_g.next())
	{
		lotcount[i]="yes";
		lotflag++;
	}
	

}
//out.print("<br>1252 lotflag "+lotflag);
for(int i=0;i<counter-1;i++)
{

	if(!("yes".equals(lotcount[i])))
	{
		 out.print("<br>Lot No "+newlotno[i]+"does not exists<br>");	
			
	}
}

if(!(lotflag==counter-1))
{
	out.print("<input type=button name='command' value='Back' onclick='history.back(1)'>");
}
else
	{
String add_lots = request.getParameter("addlots");
//int newlots=Integer.parseInt(add_lots);
int newlots=0;
int total_lots=counter+newlots;
//out.println("Line No 979: total_lots"+total_lots);
String subtotal =""+ request.getParameter("subtotal");
String total =""+ request.getParameter("total");
//out.print("<br>total "+total);
String ctax =""+ request.getParameter("ctax");
//String discount =""+ request.getParameter("discount");
//double discount_amount= Double.parseDouble(subtotal)*Double.parseDouble(discount)/100;
double ctax_amount=Double.parseDouble(request.getParameter("ctax_amt"));

//out.print("<br> C Tax amt "+ctax_amount);
double total_amount=
(Double.parseDouble(subtotal)+ctax_amount);
//	-discount_amount);

//String total =""+ request.getParameter("total");


String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;
if ("dollar".equals(currency))
	{local_currencysymbol="$";
	}

if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{

local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
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
String noquery="Select * from  Receive where Receive_No=? and company_id=? and Receive_Sell=1";
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
%><body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
<%
out.print("<br><center>Sale No "+consignment_no+ " already exist. </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else{

int j=0;
int flag= 0;
int final_flag=0; 
double carats[]=new double[counter] ;
double sell_quantity[]=new double[counter] ;
String lot_id[]= new String[counter];

for (int i=0;i<counter-1;i++)
{
j=0;
String query="Select * from  Lot where Lot_No=? and company_id=?";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,lotno[i]); 
//out.print("<br>lotno[i]=" +lotno[i]);
pstmt_p.setString(2,company_id); 
rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
	j++;
	lot_id[i]=rs_g.getString("Lot_Id");
	}
	pstmt_p.close();


}//for



%>
<html>
<head>
<title>Samyak Software</title>
<script language="JavaScript">
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

</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<!-- onSubmit='return onSubmitValidate()' -->
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditSaleReturnUpdate.jsp?" method=post >
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2 width='90%'>
<tr><td>
<TABLE  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<input type=hidden name=receive_id value=<%=receive_id%>>

<input type=hidden name=Consignment_ReceiveId value=<%=Consignment_ReceiveId%>>

<input type=hidden name=no_lots value='<%=counter%>'>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>
<input type=hidden name="stockdate" value="<%=stockdate%>">
<input type=hidden name="stockdateold" value="<%=stockdateold%>">
<input type=hidden name="due_dateold" value="<%=due_dateold%>">
<input type=hidden name="finalduedays" value="<%=finalduedays%>">
<tr bgcolor=skyblue>
<th colspan=9 align=center>Edit Sale Return </th>
</tr>
<%
String party_name= A.getName(conp,"companyparty",companyparty_id);
	//=A.getMasterArrayCondition("companyparty","companyparty_id",companyparty_id,condition ,company_id) 

%>
<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
 <input type=hidden name=consignment_no  value="<%=consignment_no%>" >
<input type=hidden name=datevalue  value="<%=receive_date%>" >


<tr>
<td colspan=2>No:<%=consignment_no%></td>
<td colspan=2>Ref No:<input type=hidden name=ref_no  size=10 value="<%=ref_no%>"><%=ref_no%></td>

<td colspan=3>From:<%=party_name%></td>
<td colspan=2>By:<%=company_name%></td>
</tr>

<tr>
<td colspan=2>Invoice Date :<%=receive_date%></td>
<td colspan=2>Stock Date:<%=stockdate%></td>
<td colspan=5>  <script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.finalduedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script><input type=text name='finalduedate' size=8 maxlength=10 value="<%=finalduedate%>" onblur='return  fnCheckMultiDate1(this,"Due Date")'>
</td>
</tr>


<tr>
   <td colspan=2>Location: <%=A.getName(conp,"Location",newlocation_id[0])%></td>

<td colspan=2>Purchase Person:<%=A.getNameCondition(conp,"Master_SalesPerson","SalesPerson_Name","where SalesPerson_Id="+salesperson_id)%>
<input type=hidden name="salesperson_id" value="<%=salesperson_id%>"></td>

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

<td colspan=2>Sales Group : <%=A.getName(conp,"PurchaseSaleGroup",purchasesalegroup_id)%>
<input type=hidden name=purchasesalegroup_id value=<%=purchasesalegroup_id%>> 
</td>
<td colspan=3>Exchange Rate <input type=hidden name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this,2)"  size=4 style="text-align:right"><%=str.format(exchange_rate)%>
</td>
</tr>



<tr>
<td>Sr No</td>
<td>Lot No</td>

<td colspan=2 align=right>Quantity<br>(Carat)</td>
<td colspan=2 align=right>Rate / Unit</td>
<td align=right>Amount in <%=local_currencysymbol%></td>
<td colspan=2>Remarks</td>
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
<tr <%=bg%>><td><%=i+1%></td>
<td><%=newlotno[i]%> </td>

<td colspan=2 align="right"><%=str.format(""+quantity[i],3)%></td>

<%
if("0".equals(Consignment_ReceiveId))
	{
%>
	<td colspan=2 align="right"><%=str.mathformat(rate[i],d)%></td>


<%	}
	else
	{
%>

		<td colspan=2 align="right"><%=receiveprice_topunch[i]%></td>
	

<%
	}
%>


<td align="right"><%=str.format(""+amount[i],d)%> </td>
<td colspan=2>&nbsp;<%=remarks[i]%></td>
</tr>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=newlotid<%=i%> value="<%=newlotid[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>">
<input type=hidden name=deleted<%=i%> value='<%=deleted[i]%>' >
<input type=hidden name=newlotno<%=i%> value="<%=newlotno[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>"> 
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>"> 
<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >
<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
<input type=hidden name=quantity<%=i%> value="<%=quantity[i]%>" >
<input type=hidden name=rate<%=i%> value="<%=rate[i]%>" >
<input type=hidden name=amount<%=i%> value="<%=amount[i]%>" >
<input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>" >
<%
}//end for
%>
<input type=hidden name=deletedcount value='<%=deletedcount%>' >
<tr>
<td colspan=2>&nbsp;</td>
<td colspan=1> Sub Total in <%=local_currencysymbol%></td>
<td colspan=1 align="right"><%=str.format(""+tot_newqty,3)%></td>
<td colspan=2> &nbsp;</td>
<td colspan=1 align="right"><input type=hidden name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"><%=str.format(""+subtotal,d)%></td>
<td colspan=1>&nbsp;</td>
</tr>
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

<td colspan=4 align=right>
	<%=A.getNameCondition(conp,"Ledger","Ledger_Name","where Ledger_Id="+ledger[i]+"") %> &nbsp;&nbsp;&nbsp;&nbsp;<input type=hidden name="ledger<%=i%>" value="<%=ledger[i]%>"></td>
<td colspan=1 align=right> <input type=hidden name="acamount<%=i%>" value="<%=acamount[i]%>" style="text-align:right" size="8" onBlur="validate(this)" readonly><%=str.format(""+acamount[i],d)%></td>
<%if("1".equals(debitcredit[i])) {%>
<!--<td colspan=1>Dr--> <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"><!--</td>-->
<%} else { %>
<!--<td colspan=1>Cr--> <input type=hidden name="debitcredit<%=i%>" value="<%=debitcredit[i]%>"><!--</td>-->
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
<td colspan=4 align=right>
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





<tr>
<td colspan=2>&nbsp;</td>
<td colspan=3>Tax (%)</td>
<td colspan=1 align="right"><input type=hidden name=ctax size=8 OnBlur='return calcTotal(this)' value="<%=ctax%>" style="text-align:right"> <%=str.mathformat(ctax,d)%></td>
<td align="right"><input type=hidden name=ctax_amt size=8 readonly style="text-align:right" value="<%=ctax_amount%>"><%=str.format(""+ctax_amount,d)%></td>
<td colspan=1>&nbsp;</td>
</tr>
<tr>
<td colspan=2>&nbsp;</td>
<td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1 align="right"><input type=hidden readonly name=total size=8 value="<%=total%>" style="text-align:right"> <%=str.format(""+total,d)%><input type=hidden name=old_total  value="<%= old_total %>">           </td>
	<td colspan=1>&nbsp;</td>

</tr>
<tr>
<!--<td colspan=1></td>
<td colspan=1  align=right>Difference Account in <%=local_currencysymbol%></td>
<td colspan=2 align=right></td>
<td colspan=2 align=right><B><%=str.format(difference,d)%></B>--><input type=hidden readonly name=difference size=10 value="0"></td>
<input type=hidden name="diffdebit" value="-1">
<% if("1".equals(diffdebit))
	{%>
<!--<td colspan=1 align=left>&nbsp;&nbsp;Dr</td>-->
<% }
else
	{
%>
<!--<td colspan=1 align=left>&nbsp;&nbsp;Cr</td>-->
<%}%>
<td></td>
</tr>
<tr>
	<td colspan=2>&nbsp;</td>
	<td colspan=4>Due Days<input type=hidden name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name=duedaysold size=1 value="<%=duedaysold%>" onBlur="validate(this)" style="text-align:right"><%=duedays%></td>
	<td colspan=3>&nbsp;</td>	
	</tr>


<tr>
<tr>
	<td colspan=6>Narration:<input type=hidden name=description value="<%=description%>"   size=75><%=description%></td>
	<td colspan=3>&nbsp;</td>	
	</tr>
<td colspan=9 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1'> &nbsp; &nbsp;&nbsp;<input type=submit name=command value=UPDATE class='button1'> </td>
</tr>
</TABLE>
</td>
</tr>
</table>
</FORM>
</BODY>
</HTML>
<% 
	} // if no_i
}//end else lots present check
	C.returnConnection(conp);
}//if Next

}
catch(Exception Samyak1031){ 
out.println("<font color=red> FileName : EdirPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							NEXT Form End 
--------------------------------------------------------  -->


