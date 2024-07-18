<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
	conp=C.getConnection();
//	cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);}
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
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
//out.print("<br>command=" +command);
try{
%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}

//background='exambg.gif'
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<!--  -->
<%
if("SaleReport".equals(command))
{
%>
<body  onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<table align=center bordercolor=skyblue border=0 cellspacing=0>

</td></tr>
<tr><td>
	<form action=EditSale.jsp name=f1 method=post >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Select Sale to Edit
	</th></tr>
	<tr><th>From</th>	<td align="center"><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td align="center"><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Account</th>
    <TD align="center">   
<%=A.getMasterArrayAll(conp,"Companyparty","party_id","",company_id)%> </td></tr>
	<tr><td align=center colspan=2 >
	<input type=submit value='Edit Sale' name=command  class="button1">
</td>
</tr>
</table>
</form>			
<%
C.returnConnection(conp);
}//if SaleReport
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>
</BODY>
</HTML>
<%


try{
//	conp=C.getConnection();
//	cong=C.getConnection();

if("Edit Sale".equals(command))
	{
	cong=C.getConnection();

int dd1 = Integer.parseInt(request.getParameter("dd1"));
int mm1 = Integer.parseInt(request.getParameter("mm1"));
int yy1 = Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>D1=" +D1);
int dd2 = Integer.parseInt(request.getParameter("dd2"));
int mm2 = Integer.parseInt(request.getParameter("mm2"));
int yy2 = Integer.parseInt(request.getParameter("yy2"));
java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>D2=" +D2);
String party_id= request.getParameter("party_id");
double total_saleaccount=0;

//out.print("<br>party=" +party_id);
String query="";

if("0".equals(party_id))
{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Receive_Sell=0 and Active=1 and Return=0 order by Receive_Date,Receive_No,Receive_Id";
}
//receive=0 specifies that the receive is consignment receive
else{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=?  and Receive_FromId="+party_id+" and Purchase=1 and Receive_Sell=0 and Active=1 and Return=0 order by Receive_Date,Receive_No,Receive_Id";
}
//out.print("<br>query="+query);
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	
%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}
//background='exambg.gif'
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body  onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<table align=center border=0 cellspacing=0>
<tr><td>Company:<%=company_name%></td> 
<!-- <td align=right>Run Date:<%=format.format(D)%></td> --><tr>
<tr><td colspan=2>
<table align=center border=1 cellspacing=0>
<tr><th colspan=13>
Select Sale From Report To Edit</th>
<tr>
<th>Sr No</th>
<th>No</th>
<th>Ref.No</th>

<th>To</th>
<th>Sale</th>
<th>Date</th>
<th>Lots</th>
<th>Due Date</th>
<th>Quantity</th>
<th>Local Total</th>
<th>C. Tax</th>
<th>Total</th>
<th>Dollar Total($)</th>
</tr>
<%
int i=1;
double local_total=0; 
double tlocal_total=0; 
double tax_total=0; 
double dollar_total=0;
double reportcurrency_id=0;
double qty=0;
double tot_qty=0;
double local=0; 
double tlocal=0; 
double dollar=0; 
double tax=0;
double ctax_local=0;

	while(rs_g.next())
		{
String Receive_id =rs_g.getString("Receive_id");
boolean proactive = rs_g.getBoolean("ProActive");
int Iv_id=0;
int Fv_id=0;

boolean cashflag=false;
if(proactive)
{
String v_query="select Voucher_Id from Voucher where Voucher_No='"+Receive_id+"' and Voucher_Type=1 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Iv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();
v_query="select Voucher_Id from Voucher where Referance_VoucherId="+Iv_id+" and Voucher_Type=8 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Fv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();

	if(Fv_id>0)
	{
		cashflag=true;
	}
//out.print("<br>200 cashflag "+cashflag);
}
if((!proactive) || (proactive && cashflag))
	{

//	out.print("Inside if Dollar");

reportcurrency_id=rs_g.getDouble("Receive_CurrencyId");
String dispaly_bgcolor="yellow";
String display_sale="Export";
String receive_from=rs_g.getString("Receive_FromId");
if(receive_from.equals(company_id))
{}
else{
if(reportcurrency_id==0)
{
display_sale="Export";
dispaly_bgcolor="white";
}else 
{
display_sale="Local";
dispaly_bgcolor="silver";
}
if(reportcurrency_id==0)
{

%>
<%
String pdquery="select *  from Payment_Details where For_HeadId="+Receive_id+" and Active=1";
//out.print("<br>232 query= "+query);
pstmt_p=conp.prepareStatement(pdquery);
rs_p=pstmt_p.executeQuery();
double pdcount=0;
while(rs_p.next())
	{
		pdcount++;
	}
	pstmt_p.close();
//out.print("<br>237 cashflag "+cashflag);
if((pdcount==0) || (cashflag))
	{
%>

<tr >

<td>
	<%=i++%></td>
<td><A href= "EditSaleForm.jsp?command=sedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_blank>
	<%=rs_g.getString("Receive_no")%></a></td>&nbsp;
<td>&nbsp;<%=A.getNameCondition(conp,"Voucher","ref_no","where Voucher_No='"+Receive_id+"'")%></td>
<td><%=A.getName(conp,"CompanyParty",receive_from)%>  </td>
<td bgcolor=<%=dispaly_bgcolor%>><%=display_sale%></td>
<td><%=format.format(rs_g.getDate("Receive_Date"))%></td>
<td><%=rs_g.getString("Receive_Lots")%></td>
<td><%=format.format(rs_g.getDate("Due_Date"))%></td>
<%
local=rs_g.getDouble("Local_Total");
dollar=rs_g.getDouble("Dollar_Total");
qty=rs_g.getDouble("Receive_Quantity");
tax=rs_g.getDouble("Tax");
tot_qty += qty;
local_total += local;
dollar_total += dollar;
ctax_local=local- local /((tax/100)+1);
tlocal=local-ctax_local;
tax_total +=ctax_local;
tlocal_total +=tlocal;
	%>
<td align=right> <%=str.format(""+qty,3)%></td>
<td align=right><%=str.format(""+tlocal,d)%></td>
<td align=right><%=str.format(""+ctax_local,d)%></td>
<td align=right><%=str.format(""+local,d)%></td>
<td align=right><%=str.format(""+dollar,2)%></td>

</tr>

<%	}//pdcount==0
	}
		}//else
	}
	}
		pstmt_g.close();
		total_saleaccount +=tlocal_total;
	%>
<tr><td align=right colspan=8><b>Total</b></td>
<td align=right><%=str.format(""+tot_qty,3)%></td>
<td align=right><%=str.format(""+tlocal_total,d)%></td>
<td align=right><%=str.format(""+tax_total,d)%></td>
<td align=right><%=str.format(""+local_total,d)%></td>
<td align=right> <%=str.format(""+dollar_total,2)%></td>
</tr>
<%
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	
 local_total=0; 
tlocal_total=0; 
tax_total=0; 
dollar_total=0;
reportcurrency_id=0;
qty=0;
tot_qty=0;
local=0; 
tlocal=0; 
dollar=0; 
tax=0;
ctax_local=0;
while(rs_g.next())
{
String Receive_id =rs_g.getString("Receive_id");
boolean proactive = rs_g.getBoolean("ProActive");
int Iv_id=0;
int Fv_id=0;

boolean cashflag=false;
if(proactive)
{
String v_query="select Voucher_Id from Voucher where Voucher_No='"+Receive_id+"' and Voucher_Type=1 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Iv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();
v_query="select Voucher_Id from Voucher where Referance_VoucherId="+Iv_id+" and Voucher_Type=8 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Fv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();

	if(Fv_id>0)
	{
		cashflag=true;
	}

}
if((!proactive) || (proactive && cashflag))
	{
reportcurrency_id=rs_g.getDouble("Receive_CurrencyId");
String dispaly_bgcolor="yellow";
String display_sale="Import";
String receive_from=rs_g.getString("Receive_FromId");
if(receive_from.equals(company_id))
{}
else{
if(reportcurrency_id==0)
{
display_sale="Import";
dispaly_bgcolor="white";
}else 
{
display_sale="Local";
dispaly_bgcolor="silver";
}
if(reportcurrency_id==0)
{}
else{
%>
<%
String pdquery="select *  from Payment_Details where For_HeadId="+Receive_id+" and Active=1";
//out.print("<br>232 query= "+query);
pstmt_p=conp.prepareStatement(pdquery);
rs_p=pstmt_p.executeQuery();
double pdcount=0;
while(rs_p.next())
	{
		pdcount++;
	}
	pstmt_p.close();
if((pdcount==0) || (cashflag))
	{
%>

<tr>
<td>
<%=i++%></td>
<td><A href= "EditSaleForm.jsp?command=sedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_blank><%=rs_g.getString("Receive_no")%></a></td>
<td><%=A.getNameCondition(conp,"voucher","Ref_No","where Voucher_No='"+Receive_id+"'")%></td>
<td><%=A.getName(conp,"CompanyParty",receive_from)%>  </td>
<td bgcolor=<%=dispaly_bgcolor%>><%=display_sale%></td>
<td><%=format.format(rs_g.getDate("Receive_Date"))%></td>
<td><%=rs_g.getString("Receive_Lots")%></td>
<td><%=format.format(rs_g.getDate("Due_Date"))%></td>
<%local=rs_g.getDouble("Local_Total");
dollar=rs_g.getDouble("Dollar_Total");
qty=rs_g.getDouble("Receive_Quantity");
tax=rs_g.getDouble("Tax");
tot_qty += qty;
local_total += local;
dollar_total += dollar;
ctax_local=local- local /((tax/100)+1);
tlocal=local-ctax_local;
tax_total +=ctax_local;
tlocal_total +=tlocal;%>
<td align=right><%=str.format(""+qty,3)%></td>
<td align=right><%=str.format(""+tlocal,d)%></td>
<td align=right><%=str.format(""+ctax_local,d)%></td>
<td align=right><%=str.format(""+local,d)%></td>
<td align=right><%=str.format(""+dollar,2)%></td></tr>
<%	}
	}
	}//else
	}
	}

	pstmt_g.close();
	total_saleaccount +=tlocal_total;
%>
<tr>
<td align=right colspan=8><b>Total</b></td>
<td align=right><%=str.format(""+tot_qty,3)%></td>
<td align=right><%=str.format(""+tlocal_total,d)%></td>
<td align=right><%=str.format(""+tax_total,d)%></td>
<td align=right><%=str.format(""+local_total,d)%></td>
<td align=right> <%=str.format(""+dollar_total,2)%></td>
</tr>
<tr><td align=right colspan=8><b>Total Sale</b></td>
<td align=right></td>
<td align=right> <%=str.format(""+total_saleaccount,d)%></td>
</tr>
</table>
</td></tr>
<!-- <tr><td colspan=2><hr></td><tr> -->
<tr><td align=right COLSPAN=2><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>

<%
C.returnConnection(conp);
C.returnConnection(cong);

}//if Receive 

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>



<%
try{
//	conp=C.getConnection();
//	cong=C.getConnection();
		
if("sedit".equals(command))
{
	cong=C.getConnection();

//out.println("Inside Sale Edit ");
String receive_id=request.getParameter("receive_id");
//out.print("<br>receive_id=" +receive_id);

java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
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
discount=rs_g.getDouble("discount");
total= rs_g.getDouble("Receive_Total");
companyparty_id=rs_g.getString("Receive_FromId");
receive_fromname=rs_g.getString("Receive_FromName");
receive_companyid=rs_g.getString("Company_Id");
receive_byname=rs_g.getString("Receive_ByName");
due_date=rs_g.getDate("Due_Date");
duedays=rs_g.getString("Due_Days");
}
pstmt_g.close();
//out.print("<br>67 currency_id=" +currency_id);

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
//out.println("<BR>company id is= "+companyparty_id);
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
double discount_amt=0;
String remarks[]=new String[counter]; 
String receivetransaction_id[]=new String[counter]; 
String lot_id[]=new String[counter]; 
String lot_no[]=new String[counter]; 
String pcs[]=new String[counter];

query="Select * from Receive_Transaction where Receive_Id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
		{
receivetransaction_id[n]=rs_g.getString("ReceiveTransaction_id");lot_id[n]=rs_g.getString("Lot_Id");
quantity[n]= rs_g.getDouble("Quantity");
rate[n]= rs_g.getDouble("Receive_Price"); 
pcs[n]=rs_g.getString("Pieces");
remarks[n]=rs_g.getString("Remarks"); 
amount[n]= quantity[n] * rate[n] ;
subtotal += amount[n]; 
n++;
		}//while

pstmt_g.close();

discount_amt = subtotal * (discount/100);
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

String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;
if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{

local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}
%>
<html>
<head><title>Samyak Software</title>
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
for(int i=0;i<counter;i++)
{
out.print("document.ADDForm.amount"+i+".value=(document.ADDForm.quantity"+i+".value) * (document.ADDForm.rate"+i+".value);");
out.print("subtotal=parseDouble(subtotal)+parseDouble(document.ADDForm.amount"+i+".value);");
}//end for 
%>
document.ADDForm.subtotal.value=subtotal;
var discount_amt= (subtotal*document.ADDForm.discount.value)/100;
var temp_total= subtotal - discount_amt;
var tax_amt= (temp_total*document.ADDForm.ctax.value)/100;
var finaltotal=temp_total + tax_amt;
document.ADDForm.total.value=finaltotal;
document.ADDForm.ctax_amt.value=tax_amt;
document.ADDForm.discount_amt.value=discount_amt;

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
	var finaltotal=document.ADDForm.total.value;
	if(isNaN(finaltotal))
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	return  fnCheckDate(document.ADDForm.consignment_date.value,"Date")
	return true;
	}
	}//onSubmitValidate
</script>
<script language=avascript src="Samyakdate.js">
</script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgColor=#ffffee onContextMenu="disrtclick()" onLoad='document.ADDForm.consignment_no.focus()' background="../Buttons/BGCOLOR.JPG">
<FORM name=ADDForm
action="EditSaleUpdate.jsp?" method=post onSubmit='return onSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<input type=hidden name=no_lots value=<%=counter+1%>>
<tr>
<th colspan=8 align=center>Edit Sale </th>
</tr>
<tr>
<td>No</td>
<td colspan=1> <input type=text name=consignment_no size=5 value="<%=receive_no%>" onBlur='return nullvalidation(this)'>
<td colspan=4></td>
<td colspan=2>Date <input type=text name=consignment_date size=8 value="<%=format.format(receive_date)%>" onblur='return  fnCheckDate(this.value,"Date")'></td>
</tr>
<tr>
<td colspan=6></td>
<td colspan=2><%=company_name%></td>
</tr>

<tr>
<td>To,</td>
<td>
<%
String condition="Where Super=0 and Transaction_Currency=1 and Sale=1 and active=1";
if("0".equals(currency_id))
{
condition="Where Super=0 and Transaction_Currency=0 and Sale=1 and active=1";
}
%>
<%=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
</td>
<td></td>
<td><%
if("0".equals(currency_id))
{
local_currencysymbol="US $";	
%>
<td><input type=hidden name=currency value=dollar> 
</td>
<% } else {
local_currencysymbol=local_currencysymbol;
%> 
<td><input type=hidden name=currency value=local> 
<% } %></td>

<td>Exchange Rate </td>	
<td><input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>




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
for (int i=0;i<counter;i++)
{
%>
<tr><td><%=i+1%></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name=lot_id<%=i%> value="<%=lot_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lot_no[i]%>" size=10 onBlur='return nullvalidation(this)'><%=lot_no[i]%> </td>
<td><input type=text name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this)" size=2 style="text-align:right"></td>
<td>
	<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
	<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right"></td>
<td><input type=text name=amount<%=i%> value="<%=amount[i]%>" size=8 style="text-align:right"></td>
<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
</tr>
<%
}
%>

<tr>
<td colspan=1></td>
<td colspan=4>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"></td>
<td colspan=2></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 OnBlur='return calcTotal(this)' value="<%=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 readonly style="text-align:right" value="<%=(discount*subtotal)%>"></td>
<td colspan=2></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=3>Tax (%)</td>
<td colspan=1><input type=text name=ctax size=8 OnBlur='return calcTotal(this)' value="<%=ctax%>" style="text-align:right"></td>
<td><input type=text name=ctax_amt size=8 readonly style="text-align:right" value="<%=((subtotal+discount*subtotal)*ctax)/100%>"></td>
<td colspan=2></td>
</tr>
<tr>
<td colspan=1></td>
<td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=total%>" style="text-align:right"></td>
</tr>

<tr>
	<td></td>
	<td colspan=8>Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> </td></tr>



<tr>
<td colspan=6 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1'> &nbsp;&nbsp;
Add Lots <input type=text name=addlots size=2 value="1" onBlur="validate(this)">
<input type=submit name=command value=ADD  class='button1'> &nbsp;&nbsp;<input type=submit name=command value=Update class='button1'> </td>
<td><input type=checkbox name=continue_anyway value='yes'> Continue Anyway	</td>
</tr>
 -->
</TABLE>
	</td>
	</tr>
	</table>
	</FORM>

<%
C.returnConnection(conp);
C.returnConnection(cong);

}//if saleedit
}
catch(Exception e631){ 
out.println("<font color=red> FileName : EditSale.jsp command=sedit<br>Bug No e631 : "+ e631);}
%>
</BODY>
</HTML>