<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
	conp=C.getConnection();
	cong=C.getConnection();
	}
catch(Exception e31)
	{ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);
	}

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
 //out.print("<br><center><font color=red>command=" +command+"</font></center>");

String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);


%>



<%
try{

if("CgtPurchaseEdit".equals(command))
{
	
// out.println("Inside Sale Edit ");
String receive_id=request.getParameter("receive_id");
//out.print("<br>receive_id=" +receive_id);

java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date stockdate = new java.sql.Date(System.currentTimeMillis());
double exchange_rate=0;
double ctax = 0;
double discount = 0;
double total = 0;
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
String ref_no="";//request.getParameter("ref_no");
String description="";
String purchasesalegroup_id="";
String receive_category_id="";
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
exchange_rate=rs_g.getDouble("Exchange_rate");
ctax=rs_g.getDouble("Tax");
total= rs_g.getDouble("Receive_Total");
companyparty_id=rs_g.getString("Receive_FromId");
receive_fromname=rs_g.getString("Receive_FromName");
receive_companyid=rs_g.getString("Company_Id");
receive_byname=rs_g.getString("Receive_ByName");
due_date=rs_g.getDate("Due_Date");
stockdate=rs_g.getDate("Stock_Date");
duedays=rs_g.getString("Due_Days");
salesperson_id=rs_g.getString("SalesPerson_Id");
receive_category_id=rs_g.getString("Receive_Category");
purchasesalegroup_id=rs_g.getString("PurchaseSaleGroup_Id");


ref_no=rs_g.getString("CgtRef_No");
if(rs_g.wasNull())
			{
	//ref_no=rs_g.getString("");
      ref_no="";
			}

description=rs_g.getString("CgtDescription");
if(rs_g.wasNull())
			{
	//ref_no=rs_g.getString("");
      description="";
			}
}
pstmt_g.close();
//out.print("<br>67 currency_id=" +currency_id);

String today_string= format.format(receive_date);


company_name="";
String company_address="";
String company_city="";
String company_country="";
String company_phone_off="";
//out.print("<br>receive_companyid"+receive_companyid);
String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+receive_companyid;
//out.print("<br>117company_query"+company_query);

pstmt_p = conp.prepareStatement(company_query);

//out.println("<BR> 118"+company_query);
rs_g = pstmt_p.executeQuery();
//	out.print("<br>120company_query"+company_query);
	while(rs_g.next()) 	
	{
	//out.println("Inside While 50");
	company_name= rs_g.getString("CompanyParty_Name");	
	company_address= rs_g.getString("Address1");	
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
pstmt_p = conp.prepareStatement(company_queryy);
// out.println("<br>"+company_queryy);
 //out.print("<br>140*****************************************************");
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

double quantity[]=new double[counter];
double rate[]=new double[counter];
double amount[]=new double[counter];
double ctax_amt=0;
double temp_amt=0;
//double discount_amt=0;
String remarks[]=new String[counter]; 
String receivetransaction_id[]=new String[counter]; 
String lot_id[]=new String[counter]; 
String lot_no[]=new String[counter]; 
String location_id[]=new String[counter]; 
String pcs[]=new String[counter];

query="Select * from Receive_Transaction where Receive_Id=? and active=1";
pstmt_g = cong.prepareStatement(query);
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
 String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}
	while(rs_g.next())
		{
receivetransaction_id[n]=rs_g.getString("ReceiveTransaction_id");
lot_id[n]=rs_g.getString("Lot_Id");
location_id[n]=rs_g.getString("location_id");
//out.print("<br>locaation_id "+location_id[n]);
quantity[n]= rs_g.getDouble("Available_Quantity");
rate[n]= rs_g.getDouble("Receive_Price"); 
pcs[n]=rs_g.getString("Pieces");
remarks[n]=rs_g.getString("Remarks"); 
amount[n]= str.mathformat((quantity[n] * rate[n]),d) ;
subtotal += str.mathformat((amount[n]),d) ;
n++;
		}//while

pstmt_g.close();

//discount_amt = subtotal * (discount/100);
temp_amt = subtotal ;
//	- discount_amt;
ctax_amt = str.mathformat((temp_amt * (ctax/100)),d);
total= str.mathformat((temp_amt + ctax_amt),d);;
//out.print("<br>subtotal=" +subtotal);
//out.print("<br>ctax_amt=" +ctax_amt);
//out.print("<br>total=" +total);

for (int i=0;i<counter;i++)
{
lot_no[i]=A.getName(conp,"Lot", "Lot_No", lot_id[i]);
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
 String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}
*/
%>
<html>
<head><title>Samyak Software</title>
<script language="JavaScript">
<%
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

function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate


function calcTotal(name)
{
var d=<%=d%>;
validate(name,15)
//alert ("Ok Inside CalcTotal"+d);
var subtotal=0;
<%
for(int i=0;i<counter;i++)
{

%>


if(!(document.mainform.deleted<%=i%>.checked))
{

validate(document.mainform.rate<%=i%>,15);
validate(document.mainform.amount<%=i%>,d);

if((document.mainform.amount<%=i%>.value=="0")||(document.mainform.amount<%=i%>.value==""))
{

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
}
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


subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount<%=i%>.value);
}//end if checked
<%

}//end for 
%>

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
var temp_total= parseFloat(document.mainform.subtotal.value);
/*
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
*/
//var finaltotal=temp_total+tax_amt;
//var finaltotal= parseFloat(document.mainform.subtotal.value)+ parseFloat(document.mainform.ctax_amt.value);

var finaltotal= parseFloat(document.mainform.subtotal.value);

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
	
	
	
	
	newlocation();
	var finaltotal=document.mainform.total.value;
	if(isNaN(finaltotal))
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	//return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
	}//onSubmitValidate
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

<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditCgtPurchaseForm.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr><td colspan=3>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=receive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value=<%=counter+1%>>
<input type=hidden name=old_lots value=<%=counter%>>

<tr>
<th colspan=8 align=center>Edit Consignment</th>
</tr>

<tr>
<td colspan=1>No
  <input type=text name=consignment_no size=5 value="<%=receive_no%>" onBlur='return nullvalidation(this)'></td>
<td>Ref No<input type=text name=ref_no size=5 value="<%=ref_no%>"></td>&nbsp &nbsp
<!--<td>To: &nbsp &nbsp
<%//=company_name%></td>-->

<td colspan=1>From 
<%
String condition="Where Super=0  and Purchase=1 and active=1";
 %>
 <input type=text onfocus="this.select()" name=companyparty_name value='<%=A.getNameCondition(conp,"Master_CompanyParty", "CompanyParty_Name", " Where CompanyParty_Id="+companyparty_id)%>'  size=15 id=companyparty_name autocomplete=off>
 <script language="javascript">
	var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
</script>	
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
</td><input type=hidden name="oldcompanyparty_id" value="<%=companyparty_id%>">
<td>Purchase Group	
	<%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=1",company_id)%></td>
<%//out.print("<br>490 purchasesalegroup_id "+purchasesalegroup_id);%>


	<td>Category</td>
	<td><%=AC.getArrayConditionAll(conp,"Master_LotCategory","receive_category_id", receive_category_id ,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%></td>



	<td>Due Days</TD><TD><input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name="duedaysold" value="<%=duedays%>"></td>

	

</tr>
<tr>

<td>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ;' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>

<input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

</td>
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>
<input type=text name='stockdate' size=8 maxlength=10 value="<%=format.format(stockdate)%>"
onblur='return  fnCheckMultiDate(this,"Stock Date")'><input type=hidden name="stockdateold" value="<%=format.format(stockdate)%>">
</td>

<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>

<input type=text name='due_date' size=8 maxlength=10 value="<%=format.format(due_date)%>"
onblur='return  fnCheckMultiDate(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=format.format(due_date)%>">
</td>




</tr>



 
<tr>
 
<td>Location</td>
<td><%=AC.getMasterArrayCondition(conp,"Location","masterlocation",location_id[0],"where company_id="+company_id)%></td>
<td><%
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
<td> 
Purchase Person 
  <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=1 and Active=1 and company_id="+company_id+" order by SalesPerson_Name ")%>
</td>
<td></td>
<td>Exchange Rate  
 <input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>

</table>
</td></tr>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0>

<tr>
<td>Sr No</td>
<td>Delete</td>
<td>Lot No</td>
<!-- <td>Location</td> -->
<!-- <td>Pcs</td>
 --><td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>
<% 
for (int i=0;i<counter;i++)
{
%>
<tr><td><%=i+1%></td>
<td><input type="checkbox" name="deleted<%=i%>" value="yes" onclick=' return calcTotal(document.mainform.ctax_amt)'></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lot_id<%=i%> value="<%=lot_id[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=lotno<%=i%>  value="<%=lot_no[i]%>">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> autocomplete=off value="<%=lot_no[i]%>" size=10 onBlur='return nullvalidation(this)'></td>
<!-- 	<td><%//=A.getName("Location",location_id[i])%></td>-->
 <!-- <td> --><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this)" size=2 style="text-align:right"><!-- </td> -->
<td>
	<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
	<input type=text name=quantity<%=i%> value="<%=str.mathformat(quantity[i],3)%>" size=5 OnBlur='validate(this,3)' style="text-align:right">
</td>
<td><input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5  style="text-align:right"></td>
<td><input type=text name=amount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>" size=8 style="text-align:right" OnBlur='return calcTotal(this)'></td>
<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
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
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=str.mathformat(""+subtotal,d)%>" style="text-align:right" OnBlur='return calcTotal(this)'></td>
<td colspan=1></td>
</tr>



<tr>
<td colspan=8></td>
 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
<td><input type=hidden name=ctax_amt size=8  style="text-align:right" value="0"></td>
<td colspan=1></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=str.mathformat(""+total,d)%>" style="text-align:right" OnBlur='return calcTotal(this)'></td>
</tr>

<tr>
<td colspan=12>Narration: <input type=text  name=description size=125 value="<%=description%>" ></td>

</tr>

<tr>
<td colspan=6 align=center>
Add Lots <input type=text name=addlots size=2 value="1" onBlur="validate(this)">
<input type=submit name=command value=ADD  class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp;&nbsp;<input type=submit name=command value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</tr>
</TABLE>

</td>
</tr>

</table>
</FORM>
</body>
</html>
<%

C.returnConnection(cong);
C.returnConnection(conp);

}//end if CgtPurchaseEdit

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


String receive_category_id=request.getParameter("receive_category_id");
//out.print("<br>678 Receive_category-id=>"+receive_category_id);
int addlots=Integer.parseInt(request.getParameter("addlots"));

String oldreceive_no=request.getParameter("oldreceive_no");
String salesperson_id=request.getParameter("salesperson_id");
//out.print("salesperson_id"+salesperson_id);

String receive_no=request.getParameter("receive_no");
String receive_id=request.getParameter("receive_id");
//String receive_category_id1=""+A.getNameCondition(cong,"Receive","Receive_Category"," where Receive_Id="+receive_id);
//out.print("<br>690Category_id= "+receive_category_id);
String lots = request.getParameter("no_lots");
String old_lots = request.getParameter("old_lots");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");

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

String purchasesalegroup_id=""+request.getParameter("purchasesalegroup_id");
//out.print("<br>706Purchase Sale Group Id"+purchasesalegroup_id);
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
String add_lots = request.getParameter("addlots");
int newlots=Integer.parseInt(add_lots);
int total_lots=counter+newlots;
String companyparty_name= request.getParameter("companyparty_name");
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
<script language="JavaScript">
<%
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
function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate

function calcTotal(name)
{
var d=<%=d%>;
validate(name,15)
//alert ("Ok Inside CalcTotal"+d);
var subtotal=0;
<%
for(int i=0;i<(total_lots-1);i++)
{
%>
	if(!(document.mainform.deleted<%=i%>.value=='yes'))
{

validate(document.mainform.rate<%=i%>,15);
validate(document.mainform.amount<%=i%>,d);

if((document.mainform.amount<%=i%>.value=="0")||(document.mainform.amount<%=i%>.value==""))
{

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
}
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


subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount<%=i%>.value);
}//end if
<%

}//end for 
%>

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
var temp_total= parseFloat(document.mainform.subtotal.value);
/*
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
*/
//var finaltotal=temp_total+tax_amt;
//var finaltotal= parseFloat(document.mainform.subtotal.value)+ parseFloat(document.mainform.ctax_amt.value);
var finaltotal= parseFloat(document.mainform.subtotal.value);
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
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditCgtPurchaseForm.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=no_lots value=<%=total_lots%>>
<tr >
<td colspan=9 align=center><b>Edit Consignment </b></td>
</tr>

<tr>
<td>No 
  <input type=text name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'></td>
<td> Ref No 
  <input type=text name=ref_no size=5 value="<%=ref_no%>"></td>
  
  
  
  <!--<td colspan=1>To : <%//=company_name%></td>-->
<td>From
<%
String condition="Where Super=0  and Purchase=1 and active=1";
%>
<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
 <script language="javascript">
	var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
</script>	
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
</td><input type=hidden name="oldcompanyparty_id" value="<%=oldcompanyparty_id%>">

<td>Purchase Group</td><td>
	<%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=1",company_id)%></td>

<td>Category</td>


<td><%=AC.getArrayConditionAll(conp,"Master_LotCategory","receive_category_id",receive_category_id,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
	</td>





<td colspan=1>Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"><input type=hidden name="duedaysold" value="<%=duedaysold%>"> </td></tr>




<tr>
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>	
<input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>"
onblur='return  fnCheckMultiDate(this,"Invoice Date")'></td>
 
<td colspan=1>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.sotckdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>	
<input type=text name='stockdate' size=8 maxlength=10 value="<%=stockdate%>"
onblur='return  fnCheckMultiDate(this,"Stock Date")'><input type=hidden name="stockdateold" value="<%=stockdateold%>">
</td>
 
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;  ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>	
<input type=text name='due_date' size=8 maxlength=10 value="<%=due_date%>"
onblur='return  fnCheckMultiDate(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=due_dateold%>"></td>
</tr>


 
 <tr>
	 <td>Location</td><td><%=AC.getMasterArrayCondition(conp,"Location","location_id0",location_id[0],"where Active=1",company_id)%></td>

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
<td> Purchase Person </td><td>
  <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=1 and Active=1 and company_id="+company_id+" order by SalesPerson_Name ")%>
</td>
<td>Exchange Rate  </td><td>
 <input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>
</table>

 </td></tr>
<tr><td>

 <table borderColor=#D9D9D9 align=center width=100% border=1  cellspacing=0 cellpadding=2>

 <tr>
<td>Sr No</td>
<td>Lot No</td>
<!-- <td>Location</td> -->
<!-- <td>Pcs</td>
 --><td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>

<% 
String temp1="";
for (int i=0;i<counter-1;i++)
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
<input type=hidden name=lot_id<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>" size=10 onBlur='return nullvalidation(this)'>
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> value="<%=newlotno[i]%>"  size=10 <%=temp1%> autocomplete=off> </td>

<!-- <td><%//=A.getName("Location",location_id[i])%></td> -->
<!-- <td> --><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this,3)" size=2 <%=temp1%> style="text-align:right"><!-- </td> -->
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



for (int i=counter-1;i<((counter-1)+addlots);i++)
{
%>

<tr><td><%=i+1%></td>
<td>
	<input type=hidden name="deleted<%=i%>" value="no">

<input type=hidden name=receivetransaction_id<%=i%>  value="noid">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> size=10 onBlur='return nullvalidation(this)' value=""></td>
<!-- <td><%//=A.getMasterArray("Location","location_id"+i,"",company_id)%>
</td> -->
<input type=hidden name="location_id<%=i%>" value="<%=location_id[0]%>">
<input type=hidden name="newlocation_id<%=i%>" value="<%=newlocation_id[0]%>">
<!-- <td> --><input type=hidden name=pcs<%=i%> value="0" onBlur="validate(this)" size=2 style="text-align:right"><!-- </td> -->
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
<!-- <td colspan=1></td>
 --><td colspan=4>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"></td>
<td colspan=1></td>
</tr>
<tr>
<td colspan=8></td>
 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
<td><input type=hidden name=ctax_amt size=8 OnBlur='return calcTotal(this)' style="text-align:right" value="0"></td>
<td colspan=1></td>
</tr>
<tr>
<!-- <td colspan=1></td>
 --><td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=total%>" style="text-align:right" OnBlur='return calcTotal(this)' ></td>
</tr>
<tr>
<td colspan=12>Narration: <input type=text  name=description size=95 value="<%=description%>" ></td>

</tr>
<input type=hidden  name=salesperson_id  value='<%=salesperson_id%>' >
<!--<input type=hidden value='<%//=purchasesalegroup_id%>' name=purchasesalegroup_id >-->

<tr>
<td colspan=7 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp; &nbsp;&nbsp;<input type=submit name=command value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</tr>
</TABLE>
</td>
</tr>
</table>
</FORM>
</BODY>
</HTML>
<%

C.returnConnection(cong);
C.returnConnection(conp);


}//if add
}
catch(Exception Samyak1031){ 
out.println("<font color=red> FileName : EditPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!----------------------------------------------------------
							ADD Form End 
---------------------------------------------------------->


<!---------------------------------------------------------
							NEXT Form Start
---------------------------------------------------------->

<%
try{
if("NEXT".equals(command))
{
%>

<html>
<head>
<title>Samyak Software</title>

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
<%

String receive_category_id=request.getParameter("receive_category_id");
//out.print("<br>1218 receive_category_id "+receive_category_id);

//int addlots=Integer.parseInt(request.getParameter("addlots"));
int addlots=0;
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
int Final_lots=(Integer.parseInt(lots));
//out.println("<center><br>Final lots: "+Final_lots+"</center>");
String old_lots = request.getParameter("old_lots");
 //out.println("<center><br>old_lots: "+old_lots+"</center>");
String oldreceive_no = request.getParameter("oldreceive_no");
String salesperson_id = request.getParameter("salesperson_id");
//out.print("salesperson_id"+salesperson_id);
String consignment_no = request.getParameter("consignment_no");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> Stock Date "+stockdate);
String stockdateold = request.getParameter("stockdateold");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");

String companyparty_name= request.getParameter("companyparty_name");
String companyparty_id= A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Id", " Where companyparty_name='"+companyparty_name+"' and company_id="+company_id );
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");
//String purchasesalegroup_id=""+request.getParameter("purchasesalegroup_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
//out.print("<br>1243 Purchase Sale Group ID "+purchasesalegroup_id);
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

amount[i]=""+request.getParameter("amount"+i); 

remarks[i]=""+request.getParameter("remarks"+i); 
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
		 out.print("<br><b><center><font class=msgblue >Lot No</font><font class=msgred > "+newlotno[i]+"</font><font class=msgblue >does not exists</font></center></b>");	
			
	}
}

if(!(lotflag==counter-1))
{
	C.returnConnection(conp);
	C.returnConnection(cong);


	out.print("<center><input type=button name='command' value='Back' onclick='history.back(1)' class='button1'   onmouseover=\"this.className='button1_over';\" onmouseout=\"this.className='button1';\"></center>");
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
//String discount =""+ request.getParameter("discount");
//double discount_amount= Double.parseDouble(subtotal)*Double.parseDouble(discount)/100;
double ctax_amount=
((Double.parseDouble(subtotal)*Double.parseDouble(ctax))/100);
double total_amount=
(Double.parseDouble(subtotal)+ctax_amount);
//	-discount_amount);

String total =""+ request.getParameter("total");


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
	C.returnConnection(conp);
	C.returnConnection(cong);

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
	//alert ("Ok Inside CalcTotal");
	var subtotal=0;
<%
for(int i=0;i<(counter+addlots)-1;i++)
{
out.print("document.mainform.amount"+i+".value=(document.mainform.quantity"+i+".value) * (document.mainform.rate"+i+".value);");
out.print("subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount"+i+".value);");
}//end for 
%>
document.mainform.subtotal.value=subtotal;
//var discount_amt= (subtotal*document.mainform.discount.value)/100;
var temp_total= subtotal; 
//	- discount_amt;
var tax_amt= (temp_total*document.mainform.ctax.value)/100;
var finaltotal=temp_total + tax_amt;
document.mainform.total.value=finaltotal;
document.mainform.ctax_amt.value=tax_amt;
//document.mainform.discount_amt.value=discount_amt;

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

<SCRIPT language=javascript >

function setfocus1()
	{
	document.mainform.finalduedate.focus()
	}
</script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<!-- onSubmit='return onSubmitValidate()' -->
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG" onload = "setfocus1()">
<FORM name=mainform
action="EditCgtPurchaseUpdate.jsp" method=post >

<TABLE borderColor=skyblue border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr><td>

<TABLE  borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr><td>


<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<input type=hidden  name=salesperson_id  value='<%=salesperson_id%>' >
	

<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value='<%=counter%>'>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>

<input type=hidden name="stockdate" value="<%=stockdate%>">
<input type=hidden name="stockdateold" value="<%=stockdateold%>">

<input type=hidden name="due_dateold" value="<%=due_dateold%>">


<input type=hidden name="finalduedays" value="<%=finalduedays%>">

<input type=hidden name="stockdateold" value="<%=stockdateold%>">

<tr bgcolor=skyblue>
<th colspan=8 align=center>Edit Consignment</th>
</tr>
<tr><td colspan=8><hr></td></tr>
<tr>

	<td>No -  <input type=hidden name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'><%=consignment_no%> </td>
<td>Ref.No<input type=hidden name=ref_no size=5 value="<%=ref_no%>"><%=ref_no%> </td>



<td>To  : 
<%
String condition="Where Super=0  and Purchase=1 and active=1";
%>
<%
String party_name= A.getName(conp,"companyparty",companyparty_id);
	//=A.getMasterArrayCondition("companyparty","companyparty_id",companyparty_id,condition ,company_id) 

%>
<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
<%=party_name%>
</td>
<td colspan=1>From  : <%=company_name%></td>
 
<td>Purchase Group : <%=A.getNameCondition(conp,"Master_PurchaseSaleGroup","PurchaseSaleGroup_Name","where PurchaseSaleGroup_Id="+purchasesalegroup_id)%>
<input type=hidden name=purchasesalegroup_id value='<%=purchasesalegroup_id%>'>
</td>




 	<td  colspan=1 >Due Days -<input type=hidden name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name=duedaysold size=1 value="<%=duedaysold%>" onBlur="validate(this)" style="text-align:right"><%=duedays%></td></tr>


 


</tr>
<tr>
<td >Receive Date - <input type=hidden name=datevalue size=8 value="<%=receive_date%>" onblur='return  fnCheckDate(this.value,"Date")'><%=receive_date%></td>
  	<td>Stock Date</td><td><%=stockdate%></td>

<td>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.finalduedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;  ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>
<input type=text name='finalduedate' size=8 maxlength=10 value="<%=finalduedate%>"
onblur='return  fnCheckMultiDate(this,"Due Date")' tabindex=1>
</td>

<%  int rec_cat_id=Integer.parseInt(receive_category_id);
	if(rec_cat_id==0) 
	{%>
<td>Category :All 
<input type=hidden name=receive_category_id value='<%=receive_category_id%>'>
</td>
 <%}

else
	{%>
<td>Category : <%=A.getNameCondition(conp,"Master_LotCategory","LotCategory_Name","where LotCategory_Id="+receive_category_id)%>
<input type=hidden name=receive_category_id value='<%=receive_category_id%>'>
</td>
	<%}%>

</tr><tr>

   <td>Location</td>
<td><%=A.getName(conp,"Location",newlocation_id[0])%></td>
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
 
<td colspan=1>Exchange Rate </td><td><input type=hidden name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right"><%=str.format(exchange_rate)%>
</td>
</tr>

</table>
</td></tr>

<tr><td>&nbsp;</td></tr>

<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2>
<tr>
<td>Sr No</td>
<td>Lot No</td>
<td>Pcs</td>
<td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
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
<tr <%=bg%>><td><%=i+1%></td>
<td>
<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=newlotid<%=i%> value="<%=newlotid[i]%>">
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">

<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>"><%=newlotno[i]%> </td>
<input type=hidden name=deleted<%=i%> value='<%=deleted[i]%>' >
<input type=hidden name=newlotno<%=i%> value="<%=newlotno[i]%>">

<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>"> 
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>"> 
<td align="right"><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this)" size=2 style="text-align:right"><%=pcs[i]%></td>
<td align="right">
	<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
	<input type=hidden name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right"><%=quantity[i]%>
</td>
<td align="right"><input type=hidden name=rate<%=i%> value="<%=rate[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right"><%=str.mathformat(rate[i],d)%></td>
<td align="right"><input type=hidden name=amount<%=i%> value="<%=amount[i]%>" size=8 style="text-align:right" readonly><%=str.format(""+amount[i],d)%>
<%//=(str.format(""+(rate[i]*amount[i]),2))%> </td>
<td><input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>" size=8><%=remarks[i]%></td>
</tr>

<%
}//end for
%>
</table>
</td>
</tr>


<input type=hidden name=deletedcount value='<%=deletedcount%>' >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2>

<tr>
<td width=62% align=right> Sub Total in <%=local_currencysymbol%></td>
<td width=24% align="right"><input type=hidden name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"><%=str.format(""+subtotal,d)%></td>
</tr>

<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1 align="right"><input type=hidden name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"><%//=discount%></td>
<td colspan=1 align="right"><input type=hidden name=discount_amt size=8 readonly style="text-align:right" value="<%//=discount_amount%>"> <%//=str.format(""+discount_amount,d)%></td>
<td colspan=2></td>
</tr>
 -->
 

 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
<input type=hidden name=ctax_amt size=8 OnBlur='return calcTotal(this)' style="text-align:right" value="0"></td>


<tr>

<td width="62%" align=right>Total in <%=local_currencysymbol%></td>
<td width="24%" align="right"><input type=hidden readonly name=total size=8 value="<%=total_amount%>" style="text-align:right"> <%=str.format(""+total_amount,d)%> </td>
</tr>
<td align=left>Narration:
<%=description%></td><td><input type=hidden size=95 name=description value="<%=description%>"></td>



<tr><td colspan=2>&nbsp;</td></tr>
<td colspan=8 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1' tabindex=2 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp; &nbsp;&nbsp;<input type=submit name=command value=UPDATE class='button1' tabindex=1 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</tr>
</TABLE>
</td></tr>
</table>

</FORM>
</BODY>
</HTML>
<% 
	


	C.returnConnection(conp);
	C.returnConnection(cong);

} // if no_i
}//end else lots present check
 
}//if Next
}
catch(Exception Samyak1031){ 

C.returnConnection(conp);
	C.returnConnection(cong);

out.println("<font color=red> FileName : EdirPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							NEXT Form End 
--------------------------------------------------------  -->








