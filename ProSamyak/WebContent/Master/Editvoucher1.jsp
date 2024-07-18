 <%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<%!int samyakerror=7;%>
<% 
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{
	
	cong=C.getConnection();
	
}
catch(Exception e31){ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : EditVoucher1.jsp<br>Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String company_name= A.getName(cong,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
int usDlr= Integer.parseInt(""+session.getValue("usDlr"));
int exRateDec= Integer.parseInt(""+session.getValue("exRateDec"));

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


String startDate = format.format(YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));
samyakerror=36;
//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(cong,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
try{
	
//	cong=C.getConnection();
//out.println("<br> 47");
int voucher_type= Integer.parseInt(request.getParameter("voucher_type"));
//out.print("<br> 49 voucher_type=" +voucher_type);
String voucher_id=request.getParameter("voucher_id");
String from_india=request.getParameter("from_india");

if("yes".equals(from_india))
{
	from_india="yes";
}//if("yes".equals(from_india))
else
{
	from_india="no";
} //else

//out.println("<br> 48 voucher_id="+voucher_id); 
 //String ref_no=""+request.getParameter("ref_no");

//out.print("<br>voucher_id=" +voucher_id);

java.sql.Date vucher_date = new java.sql.Date(System.currentTimeMillis());
String voucher_no="";
String ref_no="";
String v_currency="";
String ex_rate="";
String v_tot="";
String description="";
String costheadsubgroup_id= "";
	String costheadgroup_id= "";
int toby_nos=0;
int orignal_toby=0;
String query="Select * from Voucher where   Voucher_id=?   and voucher_type=?";
//out.print("<br>query=" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,voucher_id); 
pstmt_g.setString(2,""+voucher_type); 
rs_g = pstmt_g.executeQuery();	
//out.print("<br>57 query=" +query);
while(rs_g.next())
		{
voucher_no=rs_g.getString("Voucher_no");
ref_no=rs_g.getString("Ref_No");
vucher_date=rs_g.getDate("Voucher_Date");
toby_nos=rs_g.getInt("ToBy_Nos");
//ref_no=rs_g.getString("Ref_No");
  orignal_toby=toby_nos;
//out.print("<br>orignal_toby"+orignal_toby);
v_currency=rs_g.getString("Voucher_Currency");
ex_rate=rs_g.getString("Exchange_Rate");
v_tot=rs_g.getString("Voucher_Total");
description=rs_g.getString("Description");
if (rs_g.wasNull())
			{description="";}
 costheadsubgroup_id= rs_g.getString("CostHeadSubGroup_Id");
 costheadgroup_id= rs_g.getString("CostHeadGroup_Id");

		}
		pstmt_g.close();

String today_string= format.format(vucher_date);

//out.print("<br>v_currency"+v_currency);
String localcurrency="";
String dollarcurrency="";
if("1".equals(v_currency))
	{localcurrency="checked";
d=d;
}
else{dollarcurrency="checked";
d=4;}
String for_headid[] = new String[toby_nos]; 
String remark[] = new String[toby_nos]; 
String mode[] = new String[toby_nos]; 
String ft_id[] = new String[toby_nos]; 
String ledger_id[] = new String[toby_nos]; 
String amount[] = new String[toby_nos]; 
//out.print("<br>113 toby_nos= "+toby_nos);
if(voucher_type == 8 || voucher_type == 9 || voucher_type == 12 || voucher_type == 13 )
{
 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type desc";
}
else
{
 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type Desc";
}
//out.print(query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,voucher_id); 
rs_g = pstmt_g.executeQuery();	
int c=0;
samyakerror=128;
while(rs_g.next())
		{
ft_id[c]=rs_g.getString("Tranasaction_Id");
for_headid[c]=rs_g.getString("for_headid");
//out.print("<br>for_headid->"+for_headid[c]);
//out.print("<br>--------------->for_headid["+c+"]"+for_headid[c]);

remark[c]=rs_g.getString("Description");

mode[c]=rs_g.getString("Transaction_Type");
amount[c]=rs_g.getString("Amount");
ledger_id[c]=rs_g.getString("Ledger_Id");
//out.print("<br> 138--------------->Ledger_Id["+c+"]"+ledger_id[c]);

c++;
		}	pstmt_g.close();

for(int i=0; i<toby_nos;i++)
		{
	/*out.print("<br>");
	out.print("&nbsp;&nbsp;ft_id="+ft_id[i]);
out.print("&nbsp;&nbsp;for_headid="+for_headid[i]);
out.print("&nbsp;&nbsp;mode="+mode[i]);
out.print("&nbsp;&nbsp;amount="+amount[i]);
out.print("&nbsp;&nbsp;remark="+remark[i]);
out.print("&nbsp;&nbsp;ledger_id="+ledger_id[i]); */
}//mode=1 =to mode=0=by
//out.print("<br> 128voucher_type"+voucher_type);
if(4==voucher_type)
	{

samyakerror=160;
/*A.getNameCondition("Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id+" and transaction_type=0" );//by

String for_headid1 = A.getNameCondition("Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id+" and transaction_type=1" );//to

String remark= A.getNameCondition("Financial_Transaction","Description","Where Voucher_id="+voucher_id+" and transaction_type=0" );

String remark1 = A.getNameCondition("Financial_Transaction","Description","Where Voucher_id="+voucher_id+" and transaction_type=1" );


out.print("<BR>for_headid"+for_headid);
out.print("<BR>for_headid1"+for_headid1);
*/
String Lock_pnid= A.getNameCondition(cong,"Master_Account","Account_Id","Where Account_Name='PN Account' and company_id="+company_id+"");
//out.println("pn_account"+Lock_pnid);
//out.println("for_headid[0]"+for_headid[0]);
//out.println("for_headid[1]"+for_headid[1]);

if (Lock_pnid.equals(for_headid[0]) || Lock_pnid.equals(for_headid[1]))
{
		C.returnConnection(cong);	

	out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'></head><body bgcolor=#CCCCFF ><center><b><font color=red>This PN Confirmation voucher can't be edited. Contact Super Admin.</font></b><br><br><input type=button value='Close' class='button1' onClick='window.close()'></center></body>");
}
else 
{
%>
<html><head><title>Samyak Software - INDIA</title>
	<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script>
function disrtclick()
{
//window.event.returnValue=0;
}



function calcTotal(name)
{
var d=4;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

validate(name,d)
	//alert ("Ok Inside CalcTotal");
var total_debit=0;
var total_credit=0;
total_debit=parseFloat(document.mainform.amount1.value)
document.mainform.debit_total.value=total_debit;
total_credit=parseFloat(document.mainform.amount0.value)
document.mainform.credit_total.value=total_credit;
}

function CheckTotal_CreditDebit()
{
calcTotal(document.mainform.amount0);
if(document.mainform.account_id0.value == document.mainform.account_id1.value  )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}
if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		document.mainform.credit_total.value !=document.mainform.debit_total.value)
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}

}
</script>

<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}


function validatedate(){
var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;
   
}


function compareExchRate(changedDate,name,origDate)
{
   
   
   
   
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#CCCCFF >
<form action="UpdateVoucher.jsp" method=post name=mainform   onsubmit="return validatedate()">
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><b><%=company_name%></b></td> 
<td align=right>Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1 cellspacing=0 bgcolor=#CCCCFF width='100%'>
<tr><td>
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>

<!--Edit Part For Contra Voucher -->

<tr ><th colspan=5>Contra Voucher</th></tr>
<tr>
<td>Contra No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>

<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>

<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=3 align=right><script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script> <!-- Date --> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>
<input type=hidden name=voucher_id value="<%=voucher_id%>">
<input type=hidden name=voucher_type value="4">

</td>
</tr>

<tr>
<td colspan=2>Currency 
	<input type=radio size=4 name=currency value=local <%=localcurrency%>>Local	<input type=radio size=4 name=currency value=dollar <%=dollarcurrency%>>Dollar</td>

<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value= '<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<th colspan=2 align=center> Particulars</th>
<th align=center>Debit </th>
<th align=center>Credit</th>
<th align=center>Remarks</th>
</tr>
<tr>
<td colspan=5><hr></td>
</tr>

<input type=hidden name=srno0 value=0>
<input type=hidden name=type_toby0 value="by">
 <input type=hidden name=ft_id0 value="<%=ft_id[0]%>">
<tr>
<td colspan=1>To</td><td> <%=A.getMasterArrayAccount(cong,"account_id0",for_headid[0],company_id+" and yearend_id="+yearend_id) %><%//=A.getMasterArray("Account","account_id","",company_id) %> </td><td></td>
<td align=center>
<input type=text size=8 name=amount0  value="<%=str.mathformat(""+v_tot,d)%>" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks0  value="<%=remark[0]%>"> </td>
</tr>

<tr>
<input type=hidden name=srno1 value=1>
 <input type=hidden name=ft_id1 value="<%=ft_id[1]%>">
<input type=hidden name=type_toby1 value="to">
<td colspan=1>By </td>
<td><%=A.getMasterArrayAccount(cong,"account_id1",for_headid[1],company_id+" and yearend_id="+yearend_id) %><%//=A.getArray("Ledger","ledger_id","",company_id,"Receipt")%></td>
<td align=center>
	<input type=text size=8 name=amount1  OnBlur='return calcTotal(this)' value="<%=str.mathformat(""+v_tot,d)%>" style="text-align:right"></td>
<td></td>
<td><input type=text size=8 name=remarks1  value="<%=remark[1]%>"> </td>
</tr>


<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<tr>
<td colspan=1></td>
<td><b>Total</b></td>
<td align=center>
<input type=text size=8 name=debit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#CCCCFF" style="text-align:right">
</td>
<td align=center><input type=text size=8 name=credit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#CCCCFF" style="text-align:right"></td>
<td></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>


<tr>
<td>Narration</td>
<td colspan=4><input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<tr><td colspan=5>&nbsp;</td></tr>
<tr><td colspan=5>&nbsp;</td></tr>
<tr>
<!--<td colspan=2 align=center>
 Add 
<Select name=to_by>
<option value='to'>To</option>
<option value='by'>By</option>
</select>
<input type=hidden name=counter value=1>
<input type=submit name=command value='ADD'
onClick='return confirm("Do You want to ADD ?")' class='button1'> 
<td>&nbsp;</td>-->
<input type=hidden name=to_by value="to">
 <input type=hidden name=counter value="<%=toby_nos%>"> <td align=center colspan=5>
<input type=submit name=command value='Update' class='button1' onClick="return CheckTotal_CreditDebit()">
</td></tr>

</table>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>
<%
		C.returnConnection(cong);	

}// Lock for PN
}//voucher type=4 i.e. Contra


if(5==voucher_type)//Paymant Voucher
{
	//out.print("<br>ToBy_Nos="+toby_nos);
samyakerror=425;

%>

<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script>

function disrtclick()
{
//window.event.returnValue=0;
}


function validatedate(){
var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

}






function calcTotal(name)
{
var d=4;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

validate(name,d)
	//alert ("Ok Inside CalcTotal");
var total_debit=0;
var total_credit=0;


<% int f1=0; %>

total_credit=parseFloat(document.mainform.amount<%=f1%>.value)
document.mainform.credit_total.value=total_credit;
<%
int t=toby_nos;
for(int x1=1; x1<t; x1++){%>
total_debit= parseFloat(total_debit) + parseFloat(document.mainform.amount<%=x1%>.value);

temp_dr= new String(total_debit);
var i_dr=temp_dr.indexOf(".") ;
var temp1_dr="";
if(i_dr>0)
	{
i_dr =parseInt(i_dr) + parseInt(d) + 1;
temp1_dr=temp_dr.substring(0,i_dr);
total_debit=temp1_dr;
	}


<%}%>
document.mainform.debit_total.value=total_debit;

}

function nonrepeat()
{
	<%
	for(int i=0;i<toby_nos;i++)
	{
		for(int j=i+1;j<toby_nos;j++)
		{%>
	if(document.mainform.type_toby<%=i%>.value=="by" && document.mainform.type_toby<%=j%>.value=="by")
	{

		if(document.mainform.account_id<%=i%>.value == document.mainform.account_id<%=j%>.value)
		{
		alert ("Do Select Proper Account in Particulars");
		return false;
		}
	}
	<%}
	}%>
}

function CheckTotal_CreditDebit()
{
a= nonrepeat();


if(a==false)
	{
	return false;
	}
else
	{

calcTotal(document.mainform.amount0);

if(document.mainform.account_id0.value == document.mainform.account_id1.value  )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		document.mainform.credit_total.value !=document.mainform.debit_total.value)
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
	}
}
</script>

<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}

function compareExchRate(changedDate,name,origDate)
{
   //flag = fnCheckDate(changedDate,name)
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#FFFF99  onContextMenu="disrtclick()">
<form action="ADDUpdateVoucher.jsp" method=post name=mainform onsubmit="return validatedate()" >
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><b><%=company_name%></b></td> 
<td align=right>Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1 cellspacing=0 bgcolor=#FFFF99 width='100%'>
<tr><td>
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>

<!--Edit parPayment Voucher -->

<tr ><th colspan=5>Payment Voucher</th></tr>
<tr>
<td>Payment No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>
<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>

<td colspan=3 align=right><script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>
<input type=hidden name=voucher_type value="5">
<input type=hidden name=orignal_toby value='<%=orignal_toby%>'>



</td>
</tr>

<tr>
<td colspan=2>Currency 
	<input type=radio size=4 name=currency value=local <%=localcurrency%>>Local	<input type=radio size=4 name=currency value=dollar <%=dollarcurrency%> > Dollar</td>
<td align=center><B>Cost Center Sub Head Name</B>
<%=I.getCostHeadArray(cong,cong,"costheadsubgroup_id",costheadsubgroup_id,company_id,"") %></td>

<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value= '<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<th colspan=2 align=center> Particulars</th>
<th align=center>Debit </th>
<th align=center>Credit</th>
<th align=center>Remarks</th>
</tr>
<tr>
<td colspan=5><hr></td>
</tr>
<%
for(int i=1; i<(toby_nos); i++)
{

%>
<tr>
	<input type=hidden name=srno<%=i%> value=0>
<input type=hidden name=type_toby<%=i%> value="by">
 <input type=hidden name=ft_id<%=i%> value="<%=ft_id[i]%>">
<td colspan=1>By </td>
<td> <%=A.getArray(cong,"Ledger","account_id"+i,ledger_id[i],company_id+" and yearend_id="+yearend_id,"Ledger")%>
</td>
<td align=center><input type=text size=8 name=amount<%=i%>  OnBlur='return calcTotal(this)' style="text-align:right" value="<%=str.mathformat(""+amount[i],d)%>"></td>
<td></td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remark[i]%>"> </td>
</tr>
<%}//for
int f=0;

%>
<tr>
<input type=hidden name=srno<%=f%> value=1>
 <input type=hidden name=ft_id<%=f%> value="<%=ft_id[f]%>">
<input type=hidden name=type_toby<%=f%> value="to">
<td colspan=1>To </td>
<td><%=A.getMasterArrayAccount(cong,"account_id"+f,for_headid[f],company_id+" and yearend_id="+yearend_id,"Normal") %>
</td>
<td></td>
<td align=center>
<input type=text size=8 name=amount<%=f%>  value="<%=str.mathformat(""+amount[f],d)%>" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=f%>  value="<%=remark[f]%>"> </td>
</tr>


<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<tr>
<td colspan=1></td>
<td><b>Total</b></td>
<td align=center>
<input type=text size=8 name=debit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#FFFF99" style="text-align:right">
</td>
<td align=center><input type=text size=8 name=credit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#FFFF99" style="text-align:right"></td>
<td></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>


<tr>
<td>Narration</td>
<td colspan=4><input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<tr><td colspan=5>&nbsp;</td></tr>
<tr><td colspan=5>&nbsp;</td></tr>
<tr>
<td colspan=2 align=center>
<!-- Add 
<Select name=to_by>
<option value='to'>To</option>
<option value='by'>By</option>
</select>
 -->
<!-- <input type=hidden name=to_by value='by'>
 -->
 <input type=hidden name=voucher_id value="<%=voucher_id%>">
 <input type=hidden name=counter value="<%=toby_nos%>">
<!-- <input type=submit name=command value='ADD'
onClick='return confirm("Do You want to ADD ?")' class='button1'> 
<td align=center colspan=2>-->
<input type=hidden name=counter value=1>
<input type=hidden name=to_by value='by'>

<input type=submit name=command value=Add class='button1'>
</td>
<td>&nbsp;</td>
<td colspan=2 align=center>

<input type=submit name=command value='Save' class='button1' onClick="return CheckTotal_CreditDebit()">
</td></tr>

</table>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>
<%

	C.returnConnection(cong);	

	}//voucher type=5 i.e. Payment//voucher type=5 i.e. Payment
//----------------------------------------------------------------
if(6==voucher_type)//Receipt Voucher
	{
samyakerror=742;
query="Select * from PN where   Loan_VoucherId=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,voucher_id); 
rs_g = pstmt_g.executeQuery();	
int jcount=0;
while(rs_g.next())
		{jcount++;}
pstmt_g.close();
if(jcount > 0)
{
	C.returnConnection(cong);	

%>
<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script language="JavaScript">
function f1()
{
alert("Receipt Vocuher <%=voucher_no%> Caan't be edited as it is PN   discounting Voucher.");
 window.close(); 
} 

function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}


</script>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#78D9FE  onload="f1()">
</body>
</body>
</html>
<%
}
else{
%>

<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 

<script>

function disrtclick()
{
//window.event.returnValue=0;
}

function calcTotal(name)
{
var d=4;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

validate(name,d)
//alert ("Ok Inside CalcTotal");
var total_debit=0;
var total_credit=0;
<% int f1=toby_nos-1; %>

total_debit=parseFloat(document.mainform.amount<%=f1%>.value)
document.mainform.debit_total.value=total_debit;
<%
int t=toby_nos-1;
for(int x1=0; x1<t; x1++){%>
total_credit= parseFloat(total_credit) + parseFloat(document.mainform.amount<%=x1%>.value);

temp_cr= new String(total_credit);
var i_cr=temp_cr.indexOf(".") ;
var temp1_cr="";
if(i_cr>0)
	{
i_cr =parseInt(i_cr) + parseInt(d) + 1;
temp1_cr=temp_cr.substring(0,i_cr);
total_credit=temp1_cr;
	}
<%}%>
document.mainform.credit_total.value=total_credit;
}


function nonrepeat()
{
	<%
	for(int i=0;i<toby_nos;i++)
	{
		for(int j=i+1;j<toby_nos;j++)
		{%>
	if(document.mainform.type_toby<%=i%>.value=="to" && document.mainform.type_toby<%=j%>.value=="to")
	{
		if(document.mainform.account_id<%=i%>.value == document.mainform.account_id<%=j%>.value)
		{
		alert ("Do Select Proper Account in Particulars");
		return false;
		}
	}
	<%}
	}%>
}


function CheckTotal_CreditDebit()
{
a= nonrepeat();

if(a==false)
	{
	return false;
	}
else
	{

calcTotal(document.mainform.amount0);

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		document.mainform.credit_total.value !=document.mainform.debit_total.value)
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
	}
}
</script>

<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}


function validate()
	{

var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;
	}
function compareExchRate(changedDate,name,origDate)
{
  // flag = fnCheckDate(changedDate,name)
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#99FF99  onContextMenu="disrtclick()">
<form action="AddUpdateReceiptVoucher.jsp" method=post name=mainform onsubmit="return validatedate()">
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
<td align=right>Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border="1" cellspacing=0 bgcolor=#99FF99 width='100%'>
<tr><td>
<table align=center bordercolor=black border=0 cellspacing=0 width='100%'>

<!--Edit Part For Receipt Voucher-->

<tr ><th colspan=5>Receipt Voucher</th></tr>
<tr>
<td>Receipt No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>
<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >

<td colspan=3 align=right><script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>
<input type=hidden name=voucher_id value="<%=voucher_id%>">
<input type=hidden name=voucher_type value="6">
<input type=hidden name=to_by value='to'>


</td>
</tr>

<tr>
<td colspan=2>Currency 
	<input type=radio size=4 name=currency value=local <%=localcurrency%>>Local	<input type=radio size=4 name=currency value=dollar <%=dollarcurrency%>> Dollar</td>

<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<th colspan=2 align=center> Particulars</th>
<th align=center>Debit </th>
<th align=center>Credit</th>
<th align=center>Remarks</th>
</tr>
<tr>
<td colspan=5><hr></td>
<%
for(int i=0; i<(toby_nos-1); i++)
{

%>

</tr>
	<input type=hidden name=srno<%=i%> value=0>
<input type=hidden name=type_toby<%=i%> value="to">
 <input type=hidden name=ft_id<%=i%> value="<%=ft_id[i]%>">

<tr>
<td colspan=1>To </td><td> 
<%=A.getArray(cong,"Ledger","account_id"+i,ledger_id[i],company_id+" and yearend_id="+yearend_id,"Ledger")%>
<%//=A.getMasterArrayAccount("account_id0","",company_id) %><%//=A.getMasterArray("Account","account_id","",company_id) %> </td><td></td>
<td align=center>
<input type=text size=8 name=amount<%=i%>  value="<%=str.mathformat(""+amount[i],d)%>" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remark[i]%>"> </td>
</tr>
<%}//for
int f=toby_nos-1;
%>

<tr>
<input type=hidden name=srno<%=f%> value=1>
 <input type=hidden name=ft_id<%=f%> value="<%=ft_id[f]%>">
<input type=hidden name=type_toby<%=f%> value="by">
<td colspan=1>By </td>
<td><%=A.getMasterArrayAccount(cong,"account_id"+f,for_headid[f],company_id+" and yearend_id="+yearend_id,"Normal") %>
<%//=A.getArray("Ledger","ledger_id","",company_id,"Receipt")%>
</td>
<td align=center><input type=text size=8 name=amount<%=f%>  OnBlur='return calcTotal(this)' style="text-align:right" value="<%=str.mathformat(""+amount[f],d)%>"></td>
<td></td>
<td><input type=text size=8 name=remarks<%=f%>  value="<%=remark[f]%>"> </td>
</tr>


<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center>
<input type=text size=8 name=debit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#99FF99" style="text-align:right">
</td>
<td align=center><input type=text size=8 name=credit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#99FF99" style="text-align:right"></td>
<td></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>


<tr>
<td>Narration</td>
<td colspan=4><input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<tr><td colspan=5>&nbsp;</td></tr>
<tr><td colspan=5>&nbsp;</td></tr>
<tr>
<!-- Add 
<Select name=to_by>
<option value='to'>To</option>
<option value='by'>By</option>
</select> 
<input type=hidden name=to_by value='to'>
<input type=hidden name=counter value=1>
<input type=submit name=command value='ADD'
onClick='return confirm("Do You want to ADD ?")' class='button1'>
<td>&nbsp;</td>-->
<td align=center colspan=2>
<input type=hidden name=orignal_toby value='<%=orignal_toby%>'>
 <input type=hidden name=counter value="<%=orignal_toby%>">
<input type=submit name=command  class=button1 value=Add></td>
<td>&nbsp;</td>
<td align=center colspan=2>
<input type=submit name=command value='Save' class='button1' onClick="return CheckTotal_CreditDebit()">
</td></tr>

</table>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>
<%
		C.returnConnection(cong);	

}//else
	}//voucher type=6 i.e. Receipt
//-----------------------------------------------------------------------

if(7==voucher_type)//Jenrl 
	{
samyakerror=1083;
query="Select * from PN where   Voucher_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,voucher_id); 
rs_g = pstmt_g.executeQuery();	
int jcount=0;
while(rs_g.next())
		{jcount++;}
pstmt_g.close();

if(jcount > 0)
{
C.returnConnection(cong);	
%>
<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script language="JavaScript">
function f1()
{
alert("Journal Vocuher <%=voucher_no%> Caan't be edited as it is PN  Clearence of discounted PN.");
 window.close(); 
} 

function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}


</script>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#78D9FE  onload="f1()">
</body>
</body>
</html>
<%
}
else{
for(int i=0; i<(toby_nos); i++)
{

//out.print("<br>ledger_id[i]"+ledger_id[i]);
if("0".equals(ledger_id[i]))
	{
//out.print("<br>802"+ledger_id[i]);
//out.print("<br>for_headid"+for_headid[i]);
String temp=A.getNameCondition(cong,"PN","To_FromId","Where RefVoucher_id="+voucher_id);
//out.print("<br>802temp="+temp);
String temp1=A.getNameCondition(cong,"Ledger","Ledger_id","Where  for_head=14 and For_headid="+temp+"and Ledger_type=3" );
ledger_id[i]=temp1;
 //out.print("<br>802temp1="+temp1);

}

}//for
%>

<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 

<script>

function disrtclick()
{
//window.event.returnValue=0;
}

function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}

function calcTotal(name)
{
var d=4;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

//validate(name,d)
//alert ("Ok Inside CalcTotal");
var total_debit=0;
var total_credit=0;

<%
for(int i=0;i<(toby_nos);i++)
{
if ("0".equals(mode[i]))
{
//out.print("total_debit=parseFloat(total_debit)+parseFloat(document.mainform.amount"+i+".value);");
%>
validate(document.mainform.amount<%=i%>,d)
total_debit =parseFloat(total_debit) + parseFloat(document.mainform.amount<%=i%>.value);
temp_dr= new String(total_debit);
var i_dr=temp_dr.indexOf(".") ;
var temp1_dr="";
if(i_dr>0)
	{
i_dr =parseInt(i_dr) + parseInt(d) + 1;
temp1_dr=temp_dr.substring(0,i_dr);
total_debit=temp1_dr;
	}
<%
}//end if
else if ("1".equals(mode[i]))
{
//out.print("total_credit=parseFloat(total_credit)+parseFloat(document.mainform.amount"+i+".value);");
%>
validate(document.mainform.amount<%=i%>,d)
total_credit =parseFloat(total_credit) + parseFloat(document.mainform.amount<%=i%>.value);

temp_cr= new String(total_credit);
var i_cr=temp_cr.indexOf(".") ;
var temp1_cr="";
if(i_cr>0)
	{
i_cr =parseInt(i_cr) + parseInt(d) + 1;
temp1_cr=temp_cr.substring(0,i_cr);
total_credit=temp1_cr;
	}
<%
}//end if
}//end for 


%>


document.mainform.credit_total.value=total_credit;
document.mainform.debit_total.value=total_debit;

}

function nonrepeat()
{
	<%
	for(int i=0;i<toby_nos;i++)
	{
		for(int j=i+1;j<toby_nos;j++)
		{%>
		if(document.mainform.account_id<%=i%>.value == document.mainform.account_id<%=j%>.value)
		{
		alert ("Do Select Proper Account in Particulars");
		return false;
		}

	<%}
	}%>
}

function CheckTotal_CreditDebit()
{
a=nonrepeat();
if(a==false)
{
	return false;
}
else
	{

calcTotal(document.mainform.amount0);
if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		document.mainform.credit_total.value !=document.mainform.debit_total.value)
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
	}
}
</script>

<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}

function compareExchRate(changedDate,name,origDate)
{
   //flag = fnCheckDate(changedDate,name)
   var flag;
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#78D9FE  onContextMenu="disrtclick()">
<form action="AddUpdateJournalVoucher.jsp" method=post name=mainform onsubmit="return validatedate()" >
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><b><%=company_name%></b></td> 
<td align=right>Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1 cellspacing=0 bgcolor=#78D9FE width='100%'>

<tr><td>
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr ><th colspan=5>
Journal Voucher</th></tr>
<tr>
<td>Journal No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>

<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=3 align=right><script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

<input type=hidden name=voucher_id value="<%=voucher_id%>">
<input type=hidden name=voucher_type value="7">

</td>
</tr>

<tr>
<td colspan=2>Currency 
	<input type=radio size=4 name=currency value=local <%=localcurrency%>>Local	<input type=radio size=4 name=currency value=dollar <%=dollarcurrency%>> Dollar</td>

<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>
</tr>
<input type=hidden name=oldex_rate value="<%=ex_rate%>">
<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<th colspan=2 align=center> Particulars</th>
<th align=center>Debit </th>
<th align=center>Credit</th>
<th align=center>Remarks</th>
</tr>
<tr>
<td colspan=5><hr></td>
</tr>


<%
if("1".equals(v_currency))
	{
	//out.print("<input type=hidden  name=old_currency value=local>");


}
else{
	//out.print("<input type=hidden  name=old_currency value=dollar>");
}

//mode1=to mode0=by
for(int i=0; i<(toby_nos); i++)
{
if("0".equals(mode[i]))
	{
out.print("<input type=hidden name=old_ledgerid"+i+" value="+ledger_id[i]+">");

%>
<tr>
<input type=hidden name=srno<%=i%> value=0>
<input type=hidden name=type_toby<%=i%> value="by">
 <input type=hidden name=ft_id<%=i%> value="<%=ft_id[i]%>">
 <input type=hidden name=old_amount<%=i%> value="<%=amount[i]%>">

<td colspan=1>By </td>
<td> <%=A.getArray(cong,"Ledger","account_id"+i,ledger_id[i],company_id+" and yearend_id="+yearend_id,"Journal")%>
</td>
<td align=center><input type=text size=8 name=amount<%=i%>  value="<%=str.mathformat(""+amount[i],d)%>" OnBlur='return calcTotal(this)' style="text-align:right"></td>
<td></td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remark[i]%>"> </td>
</tr>
<%}//if 
else{
out.print("<input type=hidden name=old_ledgerid"+i+" value="+ledger_id[i]+">");

	%>

<tr>
<input type=hidden name=srno<%=i%> value=1>
<input type=hidden name=type_toby<%=i%> value="to">
 <input type=hidden name=ft_id<%=i%> value="<%=ft_id[i]%>">
 <input type=hidden name=old_amount<%=i%> value="<%=amount[i]%>">

<td colspan=1>To </td>
<td>
<%=A.getArray(cong,"Ledger","account_id"+i,ledger_id[i],company_id+" and yearend_id="+yearend_id,"Journal")%>
</td>
<td></td>
<td align=center>
<input type=text size=8 name=amount<%=i%>  value="<%=str.mathformat(""+amount[i],d)%>" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remark[i]%>"> </td>
</tr>

<%}
	}//for
%>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<tr>
<td colspan=1></td>
<td><b>Total</b></td>
<td align=center>
<input type=text size=8 name=debit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#78D9FE" style="text-align:right">
</td>
<td align=center><input type=text size=8 name=credit_total  readonly value="<%=str.mathformat(""+v_tot,d)%>" style="background:#78D9FE" style="text-align:right"></td>
<td></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>


<tr>
<td>Narration</td>
<td colspan=4><input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<tr><td colspan=5>&nbsp;</td></tr>
<tr><td colspan=5>&nbsp;</td></tr>
<tr>
<td colspan=2 align=center>
 <input type=hidden name=counter value="<%=toby_nos%>">
 <input type=hidden name=orignal_toby value="<%=orignal_toby%>">


<Select name=to_by>
<option value='to'>To</option>
<option value='by'>By</option>
</select>
<input type=submit name=command value='Add'
onClick='return confirm("Do You want to ADD ?")' class='button1'>
	<td>&nbsp;	</td>
<td align=center colspan=2>
<input type=submit name=command value='Save' class='button1' onClick="return CheckTotal_CreditDebit()">




</td></tr>

</table>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>
<%
		C.returnConnection(cong);	

}//else
	}//voucher type=7 i.e. journal




if(8==voucher_type)//Sales Receipt
	{
	samyakerror=1489;
//out.print("<br>1482 Here");
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and Voucher_Id=? and Active=1 ";
int m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
		{m++;}
		pstmt_g.close();

int count=m;
//out.print("<br>1501count=" +count);
String payment_id[]=new String[count];
int pdfor_headid[]=new int[count];
double local_amount[] =new double[count];
double dollar_amount[] =new double[count];
int pfor_headid[]=new int[count];
double plocal_amount[] =new double[count];
double pdollar_amount[] =new double[count];
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
samyakerror=1510;
	while(rs_g.next())
	{
payment_id[m]=rs_g.getString("payment_id");
pdfor_headid[m]=rs_g.getInt("For_HeadId");
local_amount[m] =rs_g.getDouble("Local_Amount");
dollar_amount[m] =rs_g.getDouble("Dollar_Amount");

m++;}samyakerror=1518;
	pstmt_g.close();
int salecount=count;
String receive_no[]=new String[count];
java.sql.Date receive_date[] = new java.sql.Date[count];
java.sql.Date due_date[] = new java.sql.Date[count];
double slocal[] =new double[count];
double sdollar[] =new double[count];
double srlocal[] =new double[count];
double srdollar[] =new double[count];
double splocal[] =new double[count];
double spdollar[] =new double[count];
String Receive_CurrencyId[]=new String[count];
samyakerror=1531;
for(int i=0; i<count; i++)
{
receive_date[i]=D;
query="Select * from Receive  where Receive_id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
receive_no[i]=rs_g.getString("receive_no");
receive_date[i]=rs_g.getDate("Receive_Date");
if(rs_g.wasNull())
{receive_date[i]=D;}
//out.print("<br>receive_date="+receive_date[i]);
//due_date[i]=rs_g.getDate("Due_Date");
slocal[i] =rs_g.getDouble("Local_Total");
sdollar[i] =rs_g.getDouble("Dollar_Total");
Receive_CurrencyId[i]=rs_g.getString("Receive_CurrencyId");
	}
		pstmt_g.close();
}//for
 m=0;
// out.print("<br>1538 count=" +count);
samyakerror=1555;
for(int i=0; i<count; i++)
{
	//out.println("<BR>1542 pdfor_headid[i]="+pdfor_headid[i]);
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id;

//out.print("<br>1545 query=" +query);

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
			m++;
			//System.out.println("1548 m=" +m);
		}
		pstmt_g.close();
	//System.out.println("1555 query=" +query);
	
}//for

count=m; 
 pfor_headid=new int[count];
 plocal_amount =new double[count];
 pdollar_amount =new double[count];
samyakerror=1577;
//out.print("<br>1552 count=" +count);

//out.println("<br>1556 salecount="+salecount);
m=0;
for(int i=0; i<salecount; i++)
{
	//out.print("<br>pdfor_headid["+i+"]="+pdfor_headid[i]);
	query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
	//out.print("<br>query="+query);
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
	//out.print("<br> 1595 m="+m);
	pfor_headid[m]=rs_g.getInt("For_HeadId");
	plocal_amount[m] =rs_g.getDouble("Local_Amount");
	pdollar_amount[m] =rs_g.getDouble("Dollar_Amount");

	m++;
	//out.println("<br>1601 m=" +m);

	}
	pstmt_g.close();
//out.print("<br> 1602 m="+m);
}//for
//out.print("<br> 1602 m="+m);
int  j=0;
samyakerror=1607;
for(int i=0; i<salecount; i++)
{
j=0;
srlocal[i] =0;
srdollar[i]=0;

//out.print("<br>1619pdfor_headid "+pdfor_headid.length);
//out.print("<br>1620pfor_headid "+pfor_headid.length);
samyakerror=1616;
while(j< salecount)
	{
	if(pdfor_headid[i]==(pfor_headid[j]))
		{
		srlocal[i] += plocal_amount[j];
		srdollar[i] += pdollar_amount[j];
		}
	//out.println("<br>1595 j=" +j);
	//out.println("<br>1595 i=" +i);
	j++;
	}
	samyakerror=1627;
	//System.out.println("1628 j=" +j);
}//for
	//System.out.println("1597 salecount="+salecount);
//out.print("<br>1608 ledger_id[0]="+ledger_id[0]);
String party_id=A.getName(cong,"Ledger", "For_HeadId", "Ledger_id", ledger_id[0]); 
query="select * from Master_companyparty where companyparty_id="+party_id+"";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
double temp_local=0;
double temp_dollar=0;
	while(rs_g.next())
		{
temp_local= rs_g.getDouble("Sale_AdvanceLocal");
temp_dollar= rs_g.getDouble("Sale_AdvanceDollar");
		}
pstmt_g.close();



for(int i=0; i<salecount; i++)
{
if(pdfor_headid[i]==0)
		{
//out.print("<br>temp_local="+temp_local);
//out.print("<br>local_amount="+local_amount[i]);

receive_no[i]="On Account";
srlocal[i] =0;
srdollar[i]=0;
splocal[i] =temp_local-local_amount[i];
spdollar[i] =temp_dollar-dollar_amount[i];

}
else{
splocal[i] =slocal[i] - srlocal[i];
spdollar[i] =sdollar[i]-srdollar[i];
}
 }//for

String svou_id[]=new String[3];
samyakerror=1667;
query="Select * from Voucher where Referance_VoucherId=?";
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();
//	out.print("<br> 1403 ");
	while(rs_g.next())
	{
svou_id[m]=rs_g.getString("voucher_id");
if(rs_g.wasNull()){svou_id[m]="0";}
m++;
}
	pstmt_g.close();
 samyakerror=1681;
 int sfor_headid[] = new int[6]; 
 int salesvoucher_id[] = new int[6]; 
int smode[] = new int[6]; 
int sft_id[] = new int[6]; 
int sledger_id[] = new int[6]; 
double samount[] = new double[6]; 
 c=0;
for(int i=0;i<6;i++)
{
salesvoucher_id[i] = 0; 
sfor_headid[i] = 0; 
smode[i] = 2; 
sft_id[i] = 0; 
sledger_id[i] = 0; 
samount[i] = 0; 
}
for(int i=0;i<3;i++)
{

 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,svou_id[i]); 
rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
		{
sft_id[c]=rs_g.getInt("Tranasaction_Id");
if(rs_g.wasNull()){sft_id[c]=0;}
salesvoucher_id[c]=rs_g.getInt("Voucher_id");
if(rs_g.wasNull()){salesvoucher_id[c]=0;}
sfor_headid[c]=rs_g.getInt("for_headid");
if(rs_g.wasNull()){sfor_headid[c]=0;}
smode[c]=rs_g.getInt("Transaction_Type");
if(rs_g.wasNull()){smode[c]=2;}
samount[c]=rs_g.getDouble("Amount");
if(rs_g.wasNull()){samount[c]=0;}
sledger_id[c]=rs_g.getInt("Ledger_Id");
if(rs_g.wasNull()){sledger_id[c]=0;}
c++;

	}	pstmt_g.close();
}//for
double salev_tot=Double.parseDouble(amount[0]);
for(int i=0;i<6;i++)
{
if((smode[i]==1)&&(sledger_id[i]!=0))
	{salev_tot +=samount[i];}
//out.print("<br>1735 ");
//out.print("&nbsp;&nbsp;salesvoucher_id="+salesvoucher_id[i]);
//out.print("&nbsp;&nbsp;sft_id="+sft_id[i]);
//out.print("&nbsp;&nbsp;sfor_headid="+sfor_headid[i]);
//out.print("&nbsp;&nbsp;smode="+smode[i]);
//out.print("&nbsp;&nbsp;samount="+samount[i]);
//out.print("&nbsp;&nbsp;sledger_id="+sledger_id[i]);

}
//out.print("&nbsp;&nbsp;salev_tot="+salev_tot);

int idexpense_id[]=new int[2];
int expft_id[]=new int[2];
int expv_id[]=new int[2];
double expamt[]=new double[2];
int e=0;
int idincome_id=0;
int idft_id=0;
int indv_id=0;
double idamt=0;
	for(int i=0;i<6;i++)
{
	if((smode[i]==0)&&(sledger_id[i]!=0))
	{
		expamt[e]= samount[i];
		idexpense_id[e]=sledger_id[i];
		expv_id[e]=salesvoucher_id[i];
		expft_id[e]=sft_id[i];
e++;
	}
if((smode[i]==1)&&(sledger_id[i]!=0))
	{
		idamt= samount[i];
		indv_id= salesvoucher_id[i];
		idincome_id=sledger_id[i];
		idft_id=sft_id[i];
	}
	
}//for
double fin_amt=salev_tot-expamt[0]-expamt[1];
if("0".equals(v_currency))
	{d=4;}
	%>
<html><head><title>Edit Sales Receipt- Samyak Software - INDIA</title>

<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT">
<script language="JavaScript">



function LocalValidate_Income(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.credit_total.value=parseFloat(document.mainform.income_amt.value)+parseFloat(document.mainform.received_total.value);

}


function LocalValidate(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.debit_total.value=parseFloat(document.mainform.amount2.value)+parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);
}

function CheckTotal_CreditDebit()
{
//var flagReturn =calcTotal(document.mainform.amount.value)
//alert("msg 2654 "+flagReturn);
if(!calcTotal(document.mainform.amount.value))
	{return false;}

if((document.mainform.expense_id1.value == document.mainform.expense_id2.value) && (document.mainform.expense_amt1.value !=0) && (document.mainform.expense_amt2.value != 0) )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(parseFloat(document.mainform.credit_total.value) !=parseFloat(document.mainform.debit_total.value))
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
}

function disrtclick()
{
//window.event.returnValue=0;
}

function calcTotal(name)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}

//validate(name)
//alert ("Ok Inside CalcTotal");
var total_received=0;
<%
for(int i=0;i<salecount;i++)
{
//out.println("if(document.mainform.receive"+i+".checked){total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount"+i+".value)}");
%>

if(document.mainform.receive<%=i%>.checked)
{
<%
if(pdfor_headid[i]!=0)
	{
if("0".equals(Receive_CurrencyId[i]))
	{%>
	
		if(document.mainform.currency[0].checked)
		{
//			alert(" dollar invoice & dollar entry");





if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_dollar<%=i%>.value)))
			{
				alert(" Paid Amount should be less than or equal to Pending Amount (1883)");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}
		}
		else
		{
//			alert("dollar invoice & local entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))/(parseFloat(document.mainform.exchange_rate.value))


			var pndg2= (parseFloat(document.mainform.pending_dollar<%=i%>.value));
			pndg1=pndg1.toFixed(d);
			pndg2=pndg2.toFixed(d);

			//alert("entered "+pndg1);
			//alert("pending "+pndg2);

			if( parseFloat( pndg2 ) < parseFloat( pndg1 ) )
			{
				alert("1904 Paid Amount should be less than or equal to Pending Amount (1904)");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		}

<%	}
else
	{%>
//----------------
		if(document.mainform.currency[0].checked)
		{

//			alert("local invoice dollar entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))*(parseFloat(document.mainform.exchange_rate.value))
			pndg1=pndg1.toFixed(d);
//			alert("entered local "+pndg1);

			var pndg2= parseFloat(document.mainform.pending_local<%=i%>.value)
			pndg2=pndg2.toFixed(d);
//			alert("pending local "+pndg2);
			
			if(parseFloat(pndg2) < parseFloat(pndg1) )
			{
				alert("Paid Amount should be less than or equal to Pending Amount (1930)");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		
		}
		else
		{
//			alert("448 local invoice local entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_local<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount (1942)");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}

		}

<%	}
}
%>
validate(document.mainform.receive_amount<%=i%>,d);
total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount<%=i%>.value);

total_received=total_received.toFixed(d);
/*
temp_rcd= new String(total_received);
var i_rcd=temp_rcd.indexOf(".") ;
var temp1_rcd="";
if(i_rcd>0)
	{
i_rcd =parseInt(i_rcd) + parseInt(d) + 1;
temp1_rcd=temp_rcd.substring(0,i_rcd);
total_received=temp1_rcd;
	}
*/
}//if
<%}%>
document.mainform.received_total.value=total_received;
document.mainform.credit_total.value=parseFloat(total_received) + parseFloat(document.mainform.income_amt.value);
document.mainform.amount.value=total_received;
return true;
}


</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}


function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}

function compareExchRate(changedDate,name,origDate)
{
	var flag;
   //flag = fnCheckDate(changedDate,name)
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor='#9DF4D1' onContextMenu="disrtclick()">

<form action="EditSalesReceiptUpdate.jsp" method=post name=mainform onSubmit='return validatedate()'>

<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
<td align=right>Run Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1	 cellspacing=0 rules=none bgcolor='#9DF4D1' width='100%'>

<!--Edit Part For Sales Recipt Voucher-->

<tr ><th colspan=9>Edit Sales Receipt Voucher</th></tr>
<tr>
<td>Receipt No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>

<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=2 align=right>
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script>
 <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

</td>
<input type=hidden name=voucher_id value="<%=voucher_id%>">

</tr>
<tr>
<%
	String lselect="";
	String dselect="";
if(v_currency.equals("0"))
	{
//	out.print("<br> 1638 if dollar");
dselect="checked";
}
else{
lselect="checked";
//	out.print("<br> 1638 if local");

}
%>
<td colspan=2 align=left>Currency <input type=radio name="currency" value="dollar" <%=dselect%>>Dollar<input type=radio name="currency" value="local" <%=lselect%>>Local
</td>
<td colspan=2 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>

</tr>
<tr><td colspan=4><hr></td></tr>
<tr > <th colspan=2 > Particulars</th>
<th>Debit
<%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th><th > Credit <%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th></tr>
<tr><td colspan=4><hr></td></tr>
<tr><td>To</td>
<input type=hidden name=ft_id0 value="<%=ft_id[0]%>">
<input type=hidden name=type_toby0 value="to">
<td>
<input type=hidden name=ledger_id value="<%=ledger_id[0]%>">

<%//=A.getArray("Ledger","ledger_id",ledger_id[0],company_id,"Party")%>
<B><%=A.getNameCondition(cong,"Ledger","Ledger_Name","Where Ledger_id="+""+ledger_id[0])%></B>
	
</td>
<td>&nbsp;</td>
<td align=center><input type=text size=8 name=amount  value="<%=str.mathformat(""+amount[0],d)%>" readonly  style="text-align:right" style="background:#9DF4D1" >
</td></tr>
<%
%>
<tr>
<td>By  </td>
<td >
<input type=hidden name=ft_id1 value="<%=ft_id[1]%>">
<input type=hidden name=type_toby1 value="by">

<%=A.getMasterArrayAccount(cong,"account_id",for_headid[1],company_id+" and yearend_id="+yearend_id,"Normal") %> 
<%//=A.getMasterArray("Account","account_id","",company_id) %> </td>
<td align=center><input type=text size=8 name=amount2  value="<%=str.mathformat(""+fin_amt,d)%>"     style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>

<td>By</td><td>
<input type=hidden name=expft_id1 value="<%=expft_id[0]%>">
<input type=hidden name=expv_id1 value="<%=expv_id[0]%>">

<%=A.getArray(cong,"Ledger","expense_id1",""+idexpense_id[0],company_id+" and yearend_id="+yearend_id,"Ledger")%></td><td  align=center> <input type=text size=8 name=expense_amt1  value="<%=str.mathformat(""+expamt[0],d)%>"  style="text-align:right" onblur='LocalValidate(this)'></td>
</tr>

<tr>
<input type=hidden name=expft_id2 value="<%=expft_id[1]%>">
<input type=hidden name=expv_id2 value="<%=expv_id[1]%>">

<td>By</td><td><%=A.getArray(cong,"Ledger","expense_id2",""+idexpense_id[1],company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td> 
<td  align=center><input type=text size=8 name=expense_amt2  value="<%=str.mathformat(""+expamt[1],d)%>"   style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>		
<td>To</td><td>
 <input type=hidden name=idft_id value="<%=idft_id%>">
 <input type=hidden name=indv_id value="<%=indv_id%>">

<%=A.getArray(cong,"Ledger","income_id",""+idincome_id,company_id+" and yearend_id="+yearend_id,"Ledger")%> </td><td></td>
<td  align=center><input type=text size=8 name=income_amt  value='<%=str.mathformat(""+idamt,d)%>' style="text-align:right" onblur='LocalValidate_Income(this)'></td></tr>

<tr><td colspan=4><hr></td></tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center >
<input type=text size=8 name=debit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#9DF4D1" style="text-align:right">
</td>
<td align=center ><input type=text size=8 name=credit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#9DF4D1" style="text-align:right"></td>
<td></td>
</tr>
<tr><td colspan=4><hr></td></tr>

<tr>
<td>Narration</td>
<td colspan=3><input type=text size=75 name=description value="<%=description%>"></td>
</tr>


<tr><td colspan=6><hr></td></tr>
<tr><td colspan=6>
<table align=center  border=1 cellspacing=0 width='100%'>
	<tr><th colspan=13>
Pending Sales </th>
<tr>
<th align=left>Select</th>
<th align=left>No</th>
<th align=center>Transaction<br>Currency</th>
<th>Date</th>
<%/*if("1".equals(v_currency))
{*/
	

%>
<th align=right>Total(<%=local_symbol%>)</th>
<th align=right>Recd(<%=local_symbol%>)</th>
<th align=right>Pending(<%=local_symbol%>)</th>
<!-- <th>Recd(<%=local_symbol%>)</th>
 --><%/*}else  {*/%>
<th align=right>Total($)</th>
<th align=right>Recd($)</th>
<th align=right>Pending($)</th>
<!-- <th>Recd($)</th>
 --><%/*}*/

%>
<th>Received</th>
<input type=hidden name=counter value="<%=salecount%>"> 
<%
j=1;
for(int i=0; i<(salecount); i++)
{
%>
<tr>
<td>
<%
if("On Account".equals(receive_no[i]))
{
//out.print("receive_no[i]"+receive_no[i]);

%>
<input type=checkbox name=receive<%=i%> value=yes OnClick='this.checked=true';OnClick='return calcTotal(this)'; checked> 
<%  
	}
else
	{
%>
<input type=checkbox name=receive<%=i%> value=yes OnClick='return calcTotal(this)' checked> 
<%
	}
%>	

&nbsp;<%=j++%></td>
<input type=hidden name=payment_id<%=i%> value="<%=payment_id[i]%>"> 
<input type=hidden name=pdfor_headid<%=i%> value="<%=pdfor_headid[i]%>"> 
<input type=hidden name=receive_id<%=i%> value="<%=pdfor_headid[i]%>"> 
<td><%=receive_no[i]%>
	<%//System.out.println(" 2144 Type = 8 ");
	/*

if(0==(pdfor_headid[i])){
out.print("<B>On Account</b>");}
else{
out.print(""+receive_no[i]);
}*/
	%></td>
<td><%
if(pdfor_headid[i]!=0)
	{
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
	}
else{
%>
	-


<%}

%>	
</td>

<td align=center> <%=format.format(receive_date[i])%></td>
<%if(pdfor_headid[i]==0)
		{
%>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+local_amount[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+dollar_amount[i],2)%>'>
<%		}else{
%><input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+splocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+spdollar[i],2)%>'>
<%}
	%>


<%/*if("1".equals(v_currency))
{*/
%>
<td align=right><%=str.format(""+slocal[i],d)%></td>
<td align=right><%=str.format(""+srlocal[i],d)%></td>
<td align=right><%=str.format(""+splocal[i],d)%></td>

<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
 --><%/*} else{*/%>

<td align=right><%=str.format(""+sdollar[i],2)%></td>
<td align=right><%=str.format(""+srdollar[i],2)%></td>
<td align=right><%=str.format(""+spdollar[i],2)%></td>


<%/*}*/
%>

<% if(v_currency.equals("1"))
	{
	%>
<td align=center><%//out.print("Local");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
<%}
else
	{%>
<td align=center><%//out.print("Dollar");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
<%}%>

</tr>

<%
}//for
%>
<tr>
<td colspan=10 align=right><B>Total</B></td>
<td align=center><input type=text name=received_total  value="<%=str.mathformat(""+amount[0],d)%>"  readonly size=8 style="background:#9DF4D1" style="text-align:right"> </td>
</tr>
</td></tr>
</table>
<tr><td align=center colspan=4>
<input type=submit name=command value='Update' onClick="return CheckTotal_CreditDebit()" class='button1'>
</td></tr>
</table>
</td></tr>
</table>


<%
	
	C.returnConnection(cong);	

}//voucher type=8 i.e. sales receipt
//-----------------------------------------------------

if(9==voucher_type)
{
samyakerror=2285;
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and Voucher_Id=? and Active=1 ";
int m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 

	rs_g = pstmt_g.executeQuery();	
//out.print("<br>1991 voucher_id"+voucher_id);
while(rs_g.next())
		{m++;}
		pstmt_g.close();

int count=m;
//out.print("<br>count=" +count);
String payment_id[]=new String[count];
int pdfor_headid[]=new int[count];
int fb_id[]=new int[count];
double local_amount[] =new double[count];
double dollar_amount[] =new double[count];
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
payment_id[m]=rs_g.getString("payment_id");
pdfor_headid[m]=rs_g.getInt("For_HeadId");
local_amount[m] =rs_g.getDouble("Local_Amount");
dollar_amount[m] =rs_g.getDouble("Dollar_Amount");
fb_id[m]=rs_g.getInt("FB_Id");
//out.print("<br> 2013 local_amount[m]"+local_amount[m]);
//out.print("<br> 2013 dollar_amount[m]"+dollar_amount[m]);
m++;}
	pstmt_g.close();
//System.out.println("2298 v_Type=9");
boolean fb_present =false;
for(int p=0; p<count; p++)
		{
if(fb_id[p] > 0)
			{fb_present=true;}
else{fb_present=false;}
		}

if(fb_present)
		{
	C.returnConnection(cong);	

%>
<html><head><title>Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script language="JavaScript">
function f1()
{
alert("Purchase Payment Vocuher <%=voucher_no%> Caan't be edited as it is Having Forward Booking Used in it.");
 window.close(); 
} 
function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}


</script>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#78D9FE  onload="f1()">
</body>
</body>
</html>
<%


}
else{
int salecount=count;
String receive_no[]=new String[count];
java.sql.Date receive_date[] = new java.sql.Date[count];
java.sql.Date due_date[] = new java.sql.Date[count];
double slocal[] =new double[count];
double sdollar[] =new double[count];
double srlocal[] =new double[count];
double srdollar[] =new double[count];
double splocal[] =new double[count];
double spdollar[] =new double[count];
String Receive_CurrencyId[]=new String[count];

for(int i=0; i<count; i++)
{
receive_date[i]=D;
query="Select * from Receive  where Receive_id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
receive_no[i]=rs_g.getString("receive_no");
receive_date[i]=rs_g.getDate("Receive_Date");
if(rs_g.wasNull())
{receive_date[i]=D;}
//out.print("<br>receive_date="+receive_date[i]);
//due_date[i]=rs_g.getDate("Due_Date");
slocal[i] =rs_g.getDouble("Local_Total");
sdollar[i] =rs_g.getDouble("Dollar_Total");
Receive_CurrencyId[i]=rs_g.getString("Receive_CurrencyId");

	}
		pstmt_g.close();
}//for

 m=0;
for(int i=0; i<count; i++)
{
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{m++;}
		pstmt_g.close();

}//for
count=m;
//out.print("<br>count=" +count);
int pfor_headid[]=new int[count];
double plocal_amount[] =new double[count];
double pdollar_amount[] =new double[count];

 m=0;
for(int i=0; i<salecount; i++)
{
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
pfor_headid[m]=rs_g.getInt("For_HeadId");
plocal_amount[m] =rs_g.getDouble("Local_Amount");
pdollar_amount[m] =rs_g.getDouble("Dollar_Amount");

		m++;}
	
	pstmt_g.close();
}//for

int  j=0;
for(int i=0; i<salecount; i++)
{
j=0;
srlocal[i] =0;
srdollar[i]=0;

while(j< count)
	{
	if(pdfor_headid[i]==(pfor_headid[j]))
		{
		srlocal[i] += plocal_amount[j];
		srdollar[i] += pdollar_amount[j];
		}
	j++;
	}
	
}//for

String party_id=A.getName(cong,"Ledger", "For_HeadId", "Ledger_id", ledger_id[1]); 
query="select * from Master_companyparty where companyparty_id="+party_id+"";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
double temp_local=0;
double temp_dollar=0;
	while(rs_g.next())
		{
temp_local= rs_g.getDouble("Purchase_AdvanceLocal");
temp_dollar= rs_g.getDouble("Purchase_AdvanceDollar");
		}
pstmt_g.close();



for(int i=0; i<salecount; i++)
{
if(pdfor_headid[i]==0)
		{
//out.print("<br>temp_local="+temp_local);
//out.print("<br>local_amount="+local_amount[i]);

receive_no[i]="On Account";
srlocal[i] =0;
srdollar[i]=0;
splocal[i] =temp_local-local_amount[i];
spdollar[i] =temp_dollar-dollar_amount[i];
	

}
else{
splocal[i] =slocal[i] - srlocal[i];
spdollar[i] =sdollar[i]-srdollar[i];
}
 }//for

String svou_id[]=new String[3];
query="Select * from Voucher where Referance_VoucherId=?";
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
svou_id[m]=rs_g.getString("voucher_id");
if(rs_g.wasNull()){svou_id[m]="0";}
m++;
}
	pstmt_g.close();
 


 int sfor_headid[] = new int[6]; 
 int salesvoucher_id[] = new int[6]; 
int smode[] = new int[6]; 
int sft_id[] = new int[6]; 
int sledger_id[] = new int[6]; 
double samount[] = new double[6]; 
 c=0;
for(int i=0;i<6;i++)
{
salesvoucher_id[i] = 0; 
sfor_headid[i] = 0; 
smode[i] = 2; 
sft_id[i] = 0; 
sledger_id[i] = 0; 
samount[i] = 0; 
}
for(int i=0;i<3;i++)
{

 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,svou_id[i]); 
rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
		{
sft_id[c]=rs_g.getInt("Tranasaction_Id");
if(rs_g.wasNull()){sft_id[c]=0;}
salesvoucher_id[c]=rs_g.getInt("Voucher_id");
if(rs_g.wasNull()){salesvoucher_id[c]=0;}
sfor_headid[c]=rs_g.getInt("for_headid");
if(rs_g.wasNull()){sfor_headid[c]=0;}
smode[c]=rs_g.getInt("Transaction_Type");
if(rs_g.wasNull()){smode[c]=2;}
samount[c]=rs_g.getDouble("Amount");
if(rs_g.wasNull()){samount[c]=0;}
sledger_id[c]=rs_g.getInt("Ledger_Id");
if(rs_g.wasNull()){sledger_id[c]=0;}


	c++;

	}	pstmt_g.close();
}//for

	


double salev_tot=Double.parseDouble(amount[0]);
//out.print("&nbsp;&nbsp;salev_tot="+salev_tot);

for(int i=0;i<6;i++)
{
if((smode[i]==0)&&(sledger_id[i]!=0))
	{salev_tot +=samount[i];}
/*out.print("<br>");
out.print("&nbsp;&nbsp;salesvoucher_id="+salesvoucher_id[i]);
out.print("&nbsp;&nbsp;sft_id="+sft_id[i]);
out.print("&nbsp;&nbsp;sfor_headid="+sfor_headid[i]);
out.print("&nbsp;&nbsp;smode="+smode[i]);
out.print("&nbsp;&nbsp;samount="+samount[i]);
out.print("&nbsp;&nbsp;sledger_id="+sledger_id[i]);
*/
}
//out.print("&nbsp;&nbsp;salev_tot="+salev_tot);

int idexpense_id[]=new int[2];
int expft_id[]=new int[2];
int expv_id[]=new int[2];
double expamt[]=new double[2];
int e=0;
int idincome_id=0;
int idft_id=0;
int indv_id=0;
double idamt=0;
	for(int i=0;i<6;i++)
{
	if((smode[i]==0)&&(sledger_id[i]!=0))
	{
		expamt[e]= samount[i];
		idexpense_id[e]=sledger_id[i];
		expv_id[e]=salesvoucher_id[i];
		expft_id[e]=sft_id[i];
e++;
	}
if((smode[i]==1)&&(sledger_id[i]!=0))
	{
		idamt= samount[i];
		indv_id= salesvoucher_id[i];
		idincome_id=sledger_id[i];
		idft_id=sft_id[i];
	}
	
}//for
double fin_amt=salev_tot-idamt;
if("0".equals(v_currency))
{d=4;}
	%>
<html><head><title>Edit Purchase Payment- Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 

<script language="JavaScript">

function disrtclick()
{
//window.event.returnValue=0;
}
function LocalValidate(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.debit_total.value=parseFloat(document.mainform.amount.value)+parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);
}
function LocalValidate_Income(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.credit_total.value=parseFloat(document.mainform.amount2.value) + parseFloat(document.mainform.income_amt.value);
}

function CheckTotal_CreditDebit()
{
//var flagReturn =calcTotal(document.mainform.amount.value)
//alert("msg 2654 "+flagReturn);
if(!calcTotal(document.mainform.amount.value))
	{return false;}

if((document.mainform.expense_id1.value == document.mainform.expense_id2.value)&&(document.mainform.expense_amt1.value !=0) && (document.mainform.expense_amt2.value != 0)  )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		parseFloat(document.mainform.credit_total.value) !=parseFloat(document.mainform.debit_total.value))
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
}

function calcTotal(name)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}

//validate(name)
//alert ("Ok Inside CalcTotal");
var total_received=0;
<%
for(int i=0;i<salecount;i++)
{
//out.println("if(document.mainform.receive"+i+".checked){total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount"+i+".value)}");
%>
if(document.mainform.receive<%=i%>.checked)
{
<%
if(pdfor_headid[i]!=0)
	{
if("0".equals(Receive_CurrencyId[i]))
	{%>
	
		if(document.mainform.currency[0].checked)
		{
//			alert(" dollar invoice & dollar entry");
		var r_a =(parseFloat(document.mainform.receive_amount<%=i%>.value));
		var p_d =(parseFloat(document.mainform.pending_dollar<%=i%>.value));
	//alert("r_a"+r_a);
	//alert("p_d"+p_d);
		if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_dollar<%=i%>.value)))
			{
				alert("2705 Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}
		}
		else
		{
//			alert("dollar invoice & local entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))/(parseFloat(document.mainform.exchange_rate.value))


			var pndg2= (parseFloat(document.mainform.pending_dollar<%=i%>.value));
			pndg1=pndg1.toFixed(d);
			pndg2=pndg2.toFixed(d);

			//alert("2721 entered "+pndg1);
			/*var test1=30;
			var test2=20;
			if(test1<test2)
			{alert("test1 is Less test2"); 			}
			else{alert("test1 is Greater than test2");   } */
			
		//alert("2721 is pndg2 "+pndg2+" <  and pndg1 "+pndg1);
			if(parseFloat(pndg2)<parseFloat(pndg1))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		}

<%	}
else
	{%>
//----------------
		if(document.mainform.currency[0].checked)
		{

//			alert("local invoice dollar entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))*(parseFloat(document.mainform.exchange_rate.value))
			pndg1=pndg1.toFixed(d);
//			alert("entered local "+pndg1);

			var pndg2= parseFloat(document.mainform.pending_local<%=i%>.value)
			pndg2=pndg2.toFixed(d);
//			alert("pending local "+pndg2);
			
			if(parseFloat(pndg2)<parseFloat(pndg1))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		
		}
		else
		{
//			alert("448 local invoice local entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_local<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}

		}

<%	}
}
%>

validate(document.mainform.receive_amount<%=i%>,d);
total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount<%=i%>.value);
total_received=total_received.toFixed(d);

/*
temp_rcd= new String(total_received);
var i_rcd=temp_rcd.indexOf(".") ;
var temp1_rcd="";
if(i_rcd>0)
	{
i_rcd =parseInt(i_rcd) + parseInt(d) + 1;
temp1_rcd=temp_rcd.substring(0,i_rcd);
total_received=temp1_rcd;
	}*/

}//if
<%}%>

document.mainform.received_total.value=total_received;
document.mainform.debit_total.value= parseFloat(total_received)  + parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);

document.mainform.amount.value=total_received;
return true;
}



</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">

function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}


function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}

function compareExchRate(changedDate,name,origDate)
{   var flag;
   //flag = fnCheckDate(changedDate,name)
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor='#FCF7B6' onContextMenu="disrtclick()">

<form action="EditPurchasePaymentUpdate.jsp" method=post name=mainform onSubmit='return validatedate()'>

<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
<td align=right>Run Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1	 cellspacing=0 rules=none bgcolor='#FCF7B6' width='100%'>
	<tr ><th colspan=9>
Edit Purchase Payment Voucher</th></tr>
<tr>
<td>Payment No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>
<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=2 align=right>
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script>
 <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

</td>
<input type=hidden name=voucher_id value="<%=voucher_id%>">

</tr>
<tr>
<%
	String lselect="";
	String dselect="";
if(v_currency.equals("0"))
	{
//	out.print("<br> 1638 if dollar");
dselect="checked";
}
else{
lselect="checked";
//	out.print("<br> 1638 if local");

}
%>
<td colspan=2 align=left>Currency <input type=radio name="currency" value="dollar" <%=dselect%>>Dollar<input type=radio name="currency" value="local" <%=lselect%>>Local
</td>
<td colspan=2 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>

</tr>
<tr><td colspan=4><hr></td></tr>
<tr > <th colspan=2 > Particulars</th>
<th>Debit
<%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th><th > Credit <%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th></tr>
<tr><td colspan=4><hr></td></tr>
<tr><td>BY</td>
<input type=hidden name=ft_id1 value="<%=ft_id[1]%>">
<input type=hidden name=type_toby1 value="by">
<td>
<input type=hidden name=ledger_id value="<%=ledger_id[1]%>">

<%//=A.getArray("Ledger","ledger_id",ledger_id[0],company_id,"Party")%>
<B><%=A.getNameCondition(cong,"Ledger","Ledger_Name","Where Ledger_id="+""+ledger_id[1])%></B>
	
</td>
<td align=center><input type=text size=8 name=amount  value="<%=str.mathformat(""+amount[0],d)%>" readonly  style="text-align:right" style="background:#FCF7B6" >
</td></tr>
<%
%>
<tr>
<td>To  </td>
<td >
<input type=hidden name=ft_id0 value="<%=ft_id[0]%>">
<input type=hidden name=type_toby0 value="to">

<%=A.getMasterArrayAccount(cong,"account_id",for_headid[0],company_id+" and yearend_id="+yearend_id,"Normal") %> 
<%//=A.getMasterArray("Account","account_id","",company_id) %> </td>
	<td>&nbsp;</td>

<td align=center><input type=text size=8 name=amount2  value="<%=str.mathformat(""+fin_amt,d)%>"     style="text-align:right" onblur='LocalValidate_Income(this)'>
</td>
</tr>
<tr>

<td>By</td><td>
<input type=hidden name=expft_id1 value="<%=expft_id[0]%>">
<input type=hidden name=expv_id1 value="<%=expv_id[0]%>">

<%=A.getArray(cong,"Ledger","expense_id1",""+idexpense_id[0],company_id+" and yearend_id="+yearend_id,"Ledger")%></td><td  align=center> <input type=text size=8 name=expense_amt1  value="<%=str.mathformat(""+expamt[0],d)%>"  style="text-align:right" onblur='LocalValidate(this)'></td>
</tr>

<tr>
<input type=hidden name=expft_id2 value="<%=expft_id[1]%>">
<input type=hidden name=expv_id2 value="<%=expv_id[1]%>">

<td>By</td><td><%=A.getArray(cong,"Ledger","expense_id2",""+idexpense_id[1],company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td> 
<td  align=center><input type=text size=8 name=expense_amt2  value="<%=str.mathformat(""+expamt[1],d)%>"   style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>		
<td>To</td><td>
 <input type=hidden name=idft_id value="<%=idft_id%>">
 <input type=hidden name=indv_id value="<%=indv_id%>">

<%=A.getArray(cong,"Ledger","income_id",""+idincome_id,company_id+" and yearend_id="+yearend_id,"Ledger")%> </td><td></td>
<td  align=center><input type=text size=8 name=income_amt  value='<%=str.mathformat(""+idamt,d)%>' style="text-align:right" onblur='LocalValidate_Income(this)'></td></tr>

<tr><td colspan=4><hr></td></tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center >
<input type=text size=8 name=debit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#FCF7B6" style="text-align:right">
</td>
<td align=center ><input type=text size=8 name=credit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#FCF7B6" style="text-align:right"></td>
<td></td>
</tr>
<tr><td colspan=4><hr></td></tr>

<tr>
<td>Narration</td>
<td colspan=3><input type=text size=75 name=description value="<%=description%>"></td>
</tr>


<tr><td colspan=6><hr></td></tr>
<tr><td colspan=6>
<table align=center  border=1 cellspacing=0 width='100%'>
	<tr><th colspan=13>
Pending Purchase </th>
<tr>
<th align=left>Select</th>
<th align=left>No</th>
<th align=center>Transaction<br>Currency</th>
<th>Date</th>
<%/*if("1".equals(v_currency))
{*/
%>
<th align=right>Total(<%=local_symbol%>)</th>
<th align=right>Paid(<%=local_symbol%>)</th>
<th align=right>Pending(<%=local_symbol%>)</th>
<!-- <th>Recd(<%=local_symbol%>)</th>
 --><input type=hidden size=4 name=currency value=local >
<%/*}else  {*/%>
<th align=right>Total($)</th>
<th align=right>Paid($)</th>
<th align=right>Pending($)</th>
<%/*}*/

%>
<th>Paid</th>

<input type=hidden name=counter value="<%=salecount%>"> 
<%
j=1;
for(int i=0; i<(salecount); i++)
{
%>
<tr>
<td>
<%
if("On Account".equals(receive_no[i]))
{
//out.print("receive_no[i]"+receive_no[i]);

%>
<input type=checkbox name=receive<%=i%> value=yes OnClick='this.checked=true';OnClick='return calcTotal(this)'; checked> 
<%  
	}
else
	{

%>
<input type=checkbox name=receive<%=i%> value=yes               OnClick='return calcTotal(this)' checked> 
<%
}  
%>	
&nbsp;<%=j++%></td>
<input type=hidden name=payment_id<%=i%> value="<%=payment_id[i]%>"> 
<input type=hidden name=pdfor_headid<%=i%> value="<%=pdfor_headid[i]%>"> 
<input type=hidden name=receive_id<%=i%> value="<%=pdfor_headid[i]%>"> 
<td><%=receive_no[i]%>
	<%/*

if(0==(pdfor_headid[i])){
out.print("<B>On Account</b>");}
else{
out.print(""+receive_no[i]);
}*/
	%></td>
<td><%
if(pdfor_headid[i]!=0)
	{
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
	}
else{
%>-
<%}%>	
</td>

<td align=center> <%=format.format(receive_date[i])%></td>

<%if(pdfor_headid[i]==0)
		{
%>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+local_amount[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+dollar_amount[i],2)%>'>
<%		}else{
%><input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+splocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+spdollar[i],2)%>'>
<%}
	%>


<%/*if("1".equals(v_currency))
{*/
%>
<td align=right><%=str.format(""+slocal[i],d)%></td>
<td align=right><%=str.format(""+srlocal[i],d)%></td>
<td align=right><%=str.format(""+splocal[i],d)%></td>

<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
 --><%/*} else{*/%>

<td align=right><%=str.format(""+sdollar[i],2)%></td>
<td align=right> <%=str.format(""+srdollar[i],2)%></td>
<td align=right> <%=str.format(""+spdollar[i],2)%></td>


<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
 --><%/*}
*/
%>

<% if(v_currency.equals("1"))
	{
	%>
<td align=center><%//out.print("Local");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
<%}
else
	{%>
<td align=center><%//out.print("Dollar");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
<%}%>

</tr>

<%
}//for
%>
<tr>
<td colspan=10 align=right><B>Total</B></td>
<td align=center><input type=text name=received_total  value="<%=str.mathformat(""+amount[0],d)%>"  readonly size=8 style="background:#FCF7B6" style="text-align:right"> </td>
</tr>
</td></tr>
</table>
<tr><td align=center colspan=4>
<input type=submit name=command value='Update' onClick="return CheckTotal_CreditDebit()" class='button1'>
</td></tr>
</table>
</td></tr>
</table>


<%


	C.returnConnection(cong);	

}//else fb_present
	}//voucher type=9 i.e. Purchase payment



//-----------------------------------------------------





if(12==voucher_type)
	{
samyakerror=3124;
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and Voucher_Id=? and Active=1 ";
int m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
		{m++;}
		pstmt_g.close();

int count=m;
//out.print("<br>count=" +count);
String payment_id[]=new String[count];
int pdfor_headid[]=new int[count];
double local_amount[] =new double[count];
double dollar_amount[] =new double[count];
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
payment_id[m]=rs_g.getString("payment_id");
pdfor_headid[m]=rs_g.getInt("For_HeadId");
local_amount[m] =rs_g.getDouble("Local_Amount");
dollar_amount[m] =rs_g.getDouble("Dollar_Amount");
m++;}
	pstmt_g.close();
int salecount=count;
String receive_no[]=new String[count];
java.sql.Date receive_date[] = new java.sql.Date[count];
java.sql.Date due_date[] = new java.sql.Date[count];
double slocal[] =new double[count];
double sdollar[] =new double[count];
double srlocal[] =new double[count];
double srdollar[] =new double[count];
double splocal[] =new double[count];
double spdollar[] =new double[count];
String Receive_CurrencyId[]=new String[count];

for(int i=0; i<count; i++)
{
receive_date[i]=D;
query="Select * from Receive  where Receive_id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
receive_no[i]=rs_g.getString("receive_no");
receive_date[i]=rs_g.getDate("Receive_Date");
if(rs_g.wasNull())
{receive_date[i]=D;}
//out.print("<br>receive_date="+receive_date[i]);
//due_date[i]=rs_g.getDate("Due_Date");
slocal[i] =rs_g.getDouble("Local_Total");
sdollar[i] =rs_g.getDouble("Dollar_Total");
Receive_CurrencyId[i]=rs_g.getString("Receive_CurrencyId");

	}
		pstmt_g.close();
}//for
 m=0;
for(int i=0; i<count; i++)
{
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{m++;}
		pstmt_g.close();

}//for

count=m;
//out.print("<br>count=" +count);
int pfor_headid[]=new int[count];
double plocal_amount[] =new double[count];
double pdollar_amount[] =new double[count];

 m=0;
for(int i=0; i<salecount; i++)
{
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
pfor_headid[m]=rs_g.getInt("For_HeadId");
plocal_amount[m] =rs_g.getDouble("Local_Amount");
pdollar_amount[m] =rs_g.getDouble("Dollar_Amount");

		m++;}
	pstmt_g.close();
}//for

int  j=0;
for(int i=0; i<salecount; i++)
{
j=0;
srlocal[i] =0;
srdollar[i]=0;

while(j< count)
	{
	if(pdfor_headid[i]==(pfor_headid[j]))
		{
		srlocal[i] += plocal_amount[j];
		srdollar[i] += pdollar_amount[j];
		}
	j++;
	}
}//for

String party_id=A.getName(cong,"Ledger", "For_HeadId", "Ledger_id", ledger_id[0]); 
query="select * from Master_companyparty where companyparty_id="+party_id+"";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
double temp_local=0;
double temp_dollar=0;
	while(rs_g.next())
		{
temp_local= rs_g.getDouble("Sale_AdvanceLocal");
temp_dollar= rs_g.getDouble("Sale_AdvanceDollar");
		}
pstmt_g.close();



for(int i=0; i<salecount; i++)
{
if(pdfor_headid[i]==0)
		{
//out.print("<br>temp_local="+temp_local);
//out.print("<br>local_amount="+local_amount[i]);

receive_no[i]="On Account";
srlocal[i] =0;
srdollar[i]=0;
splocal[i] =temp_local-local_amount[i];
spdollar[i] =temp_dollar-dollar_amount[i];

}
else{
splocal[i] =slocal[i] - srlocal[i];
spdollar[i] =sdollar[i]-srdollar[i];
}
 }//for

String svou_id[]=new String[3];
query="Select * from Voucher where Referance_VoucherId=?";
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
svou_id[m]=rs_g.getString("voucher_id");
if(rs_g.wasNull()){svou_id[m]="0";}
m++;
}
	pstmt_g.close();
 


 int sfor_headid[] = new int[6]; 
 int salesvoucher_id[] = new int[6]; 
int smode[] = new int[6]; 
int sft_id[] = new int[6]; 
int sledger_id[] = new int[6]; 
double samount[] = new double[6]; 
 c=0;
for(int i=0;i<6;i++)
{
salesvoucher_id[i] = 0; 
sfor_headid[i] = 0; 
smode[i] = 2; 
sft_id[i] = 0; 
sledger_id[i] = 0; 
samount[i] = 0; 
}
for(int i=0;i<3;i++)
{

 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,svou_id[i]); 
rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
		{
sft_id[c]=rs_g.getInt("Tranasaction_Id");
if(rs_g.wasNull()){sft_id[c]=0;}
salesvoucher_id[c]=rs_g.getInt("Voucher_id");
if(rs_g.wasNull()){salesvoucher_id[c]=0;}
sfor_headid[c]=rs_g.getInt("for_headid");
if(rs_g.wasNull()){sfor_headid[c]=0;}
smode[c]=rs_g.getInt("Transaction_Type");
if(rs_g.wasNull()){smode[c]=2;}
samount[c]=rs_g.getDouble("Amount");
if(rs_g.wasNull()){samount[c]=0;}
sledger_id[c]=rs_g.getInt("Ledger_Id");
if(rs_g.wasNull()){sledger_id[c]=0;}


	c++;

	}	pstmt_g.close();
}//for
double salev_tot=Double.parseDouble(amount[0]);
for(int i=0;i<6;i++)
{
if((smode[i]==1)&&(sledger_id[i]!=0))
	{salev_tot +=samount[i];}
/*out.print("<br>");
out.print("&nbsp;&nbsp;salesvoucher_id="+salesvoucher_id[i]);
out.print("&nbsp;&nbsp;sft_id="+sft_id[i]);
out.print("&nbsp;&nbsp;sfor_headid="+sfor_headid[i]);
out.print("&nbsp;&nbsp;smode="+smode[i]);
out.print("&nbsp;&nbsp;samount="+samount[i]);
out.print("&nbsp;&nbsp;sledger_id="+sledger_id[i]);
*/
}
//out.print("&nbsp;&nbsp;salev_tot="+salev_tot);

int idexpense_id[]=new int[2];
int expft_id[]=new int[2];
int expv_id[]=new int[2];
double expamt[]=new double[2];
int e=0;
int idincome_id=0;
int idft_id=0;
int indv_id=0;
double idamt=0;
	for(int i=0;i<6;i++)
{
	if((smode[i]==0)&&(sledger_id[i]!=0))
	{
		expamt[e]= samount[i];
		idexpense_id[e]=sledger_id[i];
		expv_id[e]=salesvoucher_id[i];
		expft_id[e]=sft_id[i];
e++;
	}
if((smode[i]==1)&&(sledger_id[i]!=0))
	{
		idamt= samount[i];
		indv_id= salesvoucher_id[i];
		idincome_id=sledger_id[i];
		idft_id=sft_id[i];
	}
	
}//for
double fin_amt=salev_tot-expamt[0]-expamt[1];
if("0".equals(v_currency))
{d=4;}

query="Select * from PN where Voucher_Id=0 and Active=1  and RefVoucher_id=? and PN_Status=0";
//out.print("<br>2300query="+query);
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
String pn_no="";
int pn_id=0;
String pn_location="";
String pn_bank="";
String pn_description="";
String loan_taken="";
java.sql.Date payment_date = new java.sql.Date(System.currentTimeMillis());
while(rs_g.next())
	{
pn_id=rs_g.getInt("pn_id");
pn_no=rs_g.getString("pn_no");
//out.print("<br>2315pn_no="+pn_no);
payment_date=rs_g.getDate("payment_date");
pn_location=rs_g.getString("Location");
pn_bank=rs_g.getString("Bank");
String pn_loan=rs_g.getString("PN_Loan");
if("1".equals(pn_loan))
	{loan_taken="Checked";}
pn_description=rs_g.getString("Description");
	
	}
		pstmt_g.close();

String payment_datestring= format.format(payment_date);


	%>
<html><head><title>Edit Sales Receipt- Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 	

<script language="JavaScript">
function LocalValidate_Income(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.credit_total.value=parseFloat(document.mainform.income_amt.value)+parseFloat(document.mainform.received_total.value);

}


function LocalValidate(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.debit_total.value=parseFloat(document.mainform.amount2.value)+parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);
}

function CheckTotal_CreditDebit()
{
calcTotal(document.mainform.amount);
if((document.mainform.expense_id1.value == document.mainform.expense_id2.value) && (document.mainform.expense_amt1.value !=0) && (document.mainform.expense_amt2.value != 0)  )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		parseFloat(document.mainform.credit_total.value) !=parseFloat(document.mainform.debit_total.value))
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
}

function disrtclick()
{
//window.event.returnValue=0;
}

function calcTotal(name)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}

//validate(name)
//alert ("Ok Inside CalcTotal");
var total_received=0;
<%
for(int i=0;i<salecount;i++)
{
//out.println("if(document.mainform.receive"+i+".checked){total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount"+i+".value)}");
%>
if(document.mainform.receive<%=i%>.checked)
{
<%
if(pdfor_headid[i]!=0)
	{
if("0".equals(Receive_CurrencyId[i]))
	{%>
	
		if(document.mainform.currency[0].checked)
		{
//			alert(" dollar invoice & dollar entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_dollar<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}
		}
		else
		{
//			alert("dollar invoice & local entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))/(parseFloat(document.mainform.exchange_rate.value))


			var pndg2= (parseFloat(document.mainform.pending_dollar<%=i%>.value));
			pndg1=pndg1.toFixed(d);
			pndg2=pndg2.toFixed(d);

//			alert("entered "+pndg1);
//			alert("pending "+pndg2);
			if(pndg2<pndg1)
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		}

<%	}
else
	{%>
//----------------
		if(document.mainform.currency[0].checked)
		{

//			alert("local invoice dollar entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))*(parseFloat(document.mainform.exchange_rate.value))
			pndg1=parseFloat(pndg1.toFixed(d));

			var pndg2= parseFloat(document.mainform.pending_local<%=i%>.value)
			pndg2=parseFloat(pndg2.toFixed(d));
//			alert("pending local "+pndg2);
//			alert("entered local "+pndg1);

			if(pndg2<pndg1)
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		
		}
		else
		{
//			alert("448 local invoice local entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_local<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}

		}

<%	}
}
%>

validate(document.mainform.receive_amount<%=i%>,d);
total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount<%=i%>.value);

total_received=total_received.toFixed(d);
/*
temp_rcd= new String(total_received);
var i_rcd=temp_rcd.indexOf(".") ;
var temp1_rcd="";
if(i_rcd>0)
	{
i_rcd =parseInt(i_rcd) + parseInt(d) + 1;
temp1_rcd=temp_rcd.substring(0,i_rcd);
total_received=temp1_rcd;
	}*/

}//if
<%}%>
document.mainform.received_total.value=total_received;
document.mainform.credit_total.value=parseFloat(total_received) + parseFloat(document.mainform.income_amt.value);
document.mainform.amount.value=total_received;
}


</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}

function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}


function compareExchRate(changedDate,name,origDate)
{
   //flag = fnCheckDate(changedDate,name)
   var flag;
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor='#9DF4D1' onContextMenu="disrtclick()">

<form action=EditPNSalesReceiptUpdate.jsp method=post name=mainform onSubmit='return validatedate()'>

<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
<td align=right>Run Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1	 cellspacing=0 rules=none bgcolor='#9DF4D1' width='100%'>

<!--Edit Part For PN Sales Receipt Voucher-->

<tr ><th colspan=9>Edit PN Sales Receipt Voucher</th></tr>
<tr>
<td>Receipt No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>

<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=2 align=right>
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Receive Date' style='font-size:11px ; width:100'>")}
</script>
 <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

</td>
<input type=hidden name=voucher_id value="<%=voucher_id%>">

</tr>
<tr>
<td> PN No
<input type=text size=10 name="pn_no" value="<%=pn_no%>"></td>

<%
	String lselect="";
	String dselect="";
if(v_currency.equals("0"))
	{
//	out.print("<br> 1638 if dollar");
dselect="checked";
}
else{
lselect="checked";
//	out.print("<br> 1638 if local");

}
%>
<td colspan=1 align=left>Currency <input type=radio name="currency" value="dollar" <%=dselect%>>Dollar<input type=radio name="currency" value="local" <%=lselect%>>Local
</td>
<td colspan=1 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>

</tr>
<tr><td colspan=4><hr></td></tr>
<tr > <th colspan=2 > Particulars</th>
<th>Debit
<%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th><th > Credit <%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th></tr>
<tr><td colspan=4><hr></td></tr>
<tr><td>To</td>
<input type=hidden name=ft_id0 value="<%=ft_id[0]%>">
<input type=hidden name=type_toby0 value="to">
<td>
<input type=hidden name=ledger_id value="<%=ledger_id[0]%>">

<%//=A.getArray("Ledger","ledger_id",ledger_id[0],company_id,"Party")%>
<B><%=A.getNameCondition(cong,"Ledger","Ledger_Name","Where Ledger_id="+""+ledger_id[0])%></B>
	
</td>
<td>&nbsp;</td>
<td align=center><input type=text size=8 name=amount  value="<%=str.mathformat(""+amount[0],d)%>" readonly  style="text-align:right" style="background:#9DF4D1" >
</td></tr>
<%
%>
<tr>
<td>By  </td>
<td ><B>PN Account</B>
<input type=hidden name=ft_id1 value="<%=ft_id[1]%>">
<input type=hidden name=type_toby1 value="by">
<input type=hidden name=account_id value="<%=for_headid[1]%>">

<%//=A.getMasterArrayAccount("account_id",,company_id,"") %> 
<%//=A.getMasterArray("Account","account_id","",company_id) %> </td>
<td align=center><input type=text size=8 name=amount2  value="<%=str.mathformat(""+fin_amt,d)%>"     style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>

<td>By</td><td>
<input type=hidden name=expft_id1 value="<%=expft_id[0]%>">
<input type=hidden name=expv_id1 value="<%=expv_id[0]%>">

<%=A.getArray(cong,"Ledger","expense_id1",""+idexpense_id[0],company_id+" and yearend_id="+yearend_id,"Ledger")%></td><td  align=center> <input type=text size=8 name=expense_amt1  value="<%=str.mathformat(""+expamt[0],d)%>"  style="text-align:right" onblur='LocalValidate(this)'></td>
</tr>

<tr>
<input type=hidden name=expft_id2 value="<%=expft_id[1]%>">
<input type=hidden name=expv_id2 value="<%=expv_id[1]%>">

<td>By</td><td><%=A.getArray(cong,"Ledger","expense_id2",""+idexpense_id[1],company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td> 
<td  align=center><input type=text size=8 name=expense_amt2  value="<%=str.mathformat(""+expamt[1],d)%>"   style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>		
<td>To</td><td>
 <input type=hidden name=idft_id value="<%=idft_id%>">
 <input type=hidden name=indv_id value="<%=indv_id%>">

<%=A.getArray(cong,"Ledger","income_id",""+idincome_id,company_id+" and yearend_id="+yearend_id,"Ledger")%> </td><td></td>
<td  align=center><input type=text size=8 name=income_amt  value='<%=str.mathformat(""+idamt,d)%>' style="text-align:right" onblur='LocalValidate_Income(this)'></td></tr>

<tr><td colspan=4><hr></td></tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center >
<input type=text size=8 name=debit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#9DF4D1" style="text-align:right">
</td>
<td align=center ><input type=text size=8 name=credit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#9DF4D1" style="text-align:right"></td>
<td></td>
</tr>
<tr><td colspan=4><hr></td></tr>

<tr>
<td>Narration</td>
<td colspan=3><input type=text size=75 name=description value="<%=description%>"></td>
</tr>


<tr><td colspan=4>
<table cellspacing=0 width='100%'>
<tr><td colspan=6><hr></td></tr>
<tr><th colspan=6>PN Details </th></tr>
	<tr>
<td>Location</td>
<td colspan=1><input type=text size=20 name=location value="<%=pn_location%>"></td>
<td colspan=3 align="right">
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.payment_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script>
<input type=text name='payment_date' size=8 maxlength=10 value="<%=payment_datestring%>"
onblur='return  fnCheckDate(this.value,"Date")'>
</td>
</tr>

<tr>
<td>Description</td>
<td colspan=2><input type=text size=50 name=pn_description value="<%=pn_description%>"></td>
<td  colspan=3 align=right><!-- Bank Name
<%//=A.getMasterArrayAccount(cong,"bank_name",pn_bank,company_id,"PN") %> -->
<input type=hidden name="bank_name" value="0">
	</td>
</tr>
<input type=hidden name=loan value=no >
<input type=hidden name=pn_id value=<%=pn_id%> >
</table></td></tr>

<tr><td colspan=6><hr></td></tr>
<tr><td colspan=6>
<table align=center  border=1 cellspacing=0 width='100%'>
	<tr><th colspan=13>
Pending Sales </th>
<tr>
<th align=left>Select</th>
<th align=left>No</th>
<th align=center>Transaction<br>Currency</th>
<th>Date</th>
<%/*if("1".equals(v_currency))
{*/
	

%>
<th align=right>Total(<%=local_symbol%>)</th>
<th align=right>Recd(<%=local_symbol%>)</th>
<th align=right>Pending(<%=local_symbol%>)</th>
<!-- <th>Recd(<%=local_symbol%>)</th>
 -->
<%/*}else  {*/%>
<th align=right>Total($)</th>
<th align=right>Recd($)</th>
<th align=right>Pending($)</th>
<!-- <th>Recd($)</th>
 -->
<%/*}
*/
%>
<th>Received</th>

<input type=hidden name=counter value="<%=salecount%>"> 
<%
j=1;
for(int i=0; i<(salecount); i++)
{
%>
<tr>
<td>
<input type=checkbox name=receive<%=i%> value=yes OnClick='return calcTotal(this)' checked> &nbsp;<%=j++%></td>
<input type=hidden name=payment_id<%=i%> value="<%=payment_id[i]%>"> 
<input type=hidden name=pdfor_headid<%=i%> value="<%=pdfor_headid[i]%>"> 
<input type=hidden name=receive_id<%=i%> value="<%=pdfor_headid[i]%>"> 
<td><%=receive_no[i]%>
	<%/*

if(0==(pdfor_headid[i])){
out.print("<B>On Account</b>");}
else{
out.print(""+receive_no[i]);
}*/
	%></td>
<td><%
if(pdfor_headid[i]!=0)
	{
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
	}
else{
%>-
<%}%>	
</td>

<td align=center> <%=format.format(receive_date[i])%></td>
<%if(pdfor_headid[i]==0)
		{
%>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+local_amount[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+dollar_amount[i],2)%>'>
<%		}else{
%><input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+splocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+spdollar[i],2)%>'>
<%}
	%>


<%/*if("1".equals(v_currency))
{*/
%>
<td align=right><%=str.format(""+slocal[i],d)%></td>
<td align=right><%=str.format(""+srlocal[i],d)%></td>
<td align=right><%=str.format(""+splocal[i],d)%></td>

<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
 --><%/*} else{*/%>

<td align=right><%=str.format(""+sdollar[i],2)%></td>
<td align=right> <%=str.format(""+srdollar[i],2)%></td>
<td align=right> <%=str.format(""+spdollar[i],2)%></td>


<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
 --><%/*}
*/
%>

<% if(v_currency.equals("1"))
	{
	%>
<td align=center><%//out.print("Local");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
<%}
else
	{%>
<td align=center><%//out.print("Dollar");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
<%}%>

</tr>


<%
}//for
	C.returnConnection(cong);	

%>
<tr>
<td colspan=10 align=right><B>Total</B></td>
<td align=center><input type=text name=received_total  value="<%=str.mathformat(""+amount[0],d)%>"  readonly size=8 style="background:#9DF4D1" style="text-align:right"> </td>
</tr>
</td></tr>
</table>
<tr><td align=center colspan=4>
<%if(pn_id>0)
	{
%>


<input type=submit name=command value='Update' onClick="return CheckTotal_CreditDebit()" class='button1'>

<%}else{out.print("<font class='star1'>PN Against This Voucher  has been cleared, So can't be Modified</font>");}%>
</td></tr>
</table>
</td></tr>
</table>


<%




	}//voucher type=12 i.e.PN sales receipt




if(13==voucher_type)
	{
samyakerror=3970;
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and Voucher_Id=? and Active=1 ";
int m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
		{m++;}
		pstmt_g.close();

int count=m;
//out.print("<br>count=" +count);
String payment_id[]=new String[count];
int pdfor_headid[]=new int[count];
double local_amount[] =new double[count];
double dollar_amount[] =new double[count];
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
payment_id[m]=rs_g.getString("payment_id");
pdfor_headid[m]=rs_g.getInt("For_HeadId");
local_amount[m] =rs_g.getDouble("Local_Amount");
dollar_amount[m] =rs_g.getDouble("Dollar_Amount");
m++;}
	pstmt_g.close();
int salecount=count;
String receive_no[]=new String[count];
java.sql.Date receive_date[] = new java.sql.Date[count];
java.sql.Date due_date[] = new java.sql.Date[count];
double slocal[] =new double[count];
double sdollar[] =new double[count];
double srlocal[] =new double[count];
double srdollar[] =new double[count];
double splocal[] =new double[count];
double spdollar[] =new double[count];
String Receive_CurrencyId[]=new String[count];

for(int i=0; i<count; i++)
{
receive_date[i]=D;
query="Select * from Receive  where Receive_id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
receive_no[i]=rs_g.getString("receive_no");
receive_date[i]=rs_g.getDate("Receive_Date");
if(rs_g.wasNull())
{receive_date[i]=D;}
//out.print("<br>receive_date="+receive_date[i]);
//due_date[i]=rs_g.getDate("Due_Date");
slocal[i] =rs_g.getDouble("Local_Total");
sdollar[i] =rs_g.getDouble("Dollar_Total");
Receive_CurrencyId[i]=rs_g.getString("Receive_CurrencyId");

	}
		pstmt_g.close();
}//for
 m=0;
for(int i=0; i<count; i++)
{
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{m++;}
		pstmt_g.close();

}//for

count=m;
//out.print("<br>count=" +count);
int pfor_headid[]=new int[count];
double plocal_amount[] =new double[count];
double pdollar_amount[] =new double[count];

 m=0;
for(int i=0; i<salecount; i++)
{
query="Select * from Payment_Details where For_Head=10 and Transaction_Type=1 and For_HeadId=? and Active=1 and Voucher_id not like "+voucher_id+"";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+pdfor_headid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
pfor_headid[m]=rs_g.getInt("For_HeadId");
plocal_amount[m] =rs_g.getDouble("Local_Amount");
pdollar_amount[m] =rs_g.getDouble("Dollar_Amount");

		m++;}
	pstmt_g.close();
}//for

int  j=0;
for(int i=0; i<salecount; i++)
{
j=0;
srlocal[i] =0;
srdollar[i]=0;

while(j< count)
	{
	if(pdfor_headid[i]==(pfor_headid[j]))
		{
		srlocal[i] += plocal_amount[j];
		srdollar[i] += pdollar_amount[j];
		}
	j++;
	}
}//for

String party_id=A.getName(cong,"Ledger", "For_HeadId", "Ledger_id", ledger_id[1]); 
//out.print("<br>4159 party_id=="+party_id);
query="select * from Master_companyparty where companyparty_id="+party_id+"";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
double temp_local=0;
double temp_dollar=0;
	while(rs_g.next())
		{
temp_local= rs_g.getDouble("Purchase_AdvanceLocal");
temp_dollar= rs_g.getDouble("Purchase_AdvanceDollar");
		}
pstmt_g.close();



for(int i=0; i<salecount; i++)
{
if(pdfor_headid[i]==0)
		{
//out.print("<br>temp_local="+temp_local);
//out.print("<br>local_amount="+local_amount[i]);

receive_no[i]="On Account";
srlocal[i] =0;
srdollar[i]=0;
splocal[i] =temp_local-local_amount[i];
spdollar[i] =temp_dollar-dollar_amount[i];

}
else{
splocal[i] =slocal[i] - srlocal[i];
spdollar[i] =sdollar[i]-srdollar[i];
}
 }//for

String svou_id[]=new String[3];
query="Select * from Voucher where Referance_VoucherId=?";
m=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
svou_id[m]=rs_g.getString("voucher_id");
if(rs_g.wasNull()){svou_id[m]="0";}
m++;
}
	pstmt_g.close();
 


 int sfor_headid[] = new int[6]; 
 int salesvoucher_id[] = new int[6]; 
int smode[] = new int[6]; 
int sft_id[] = new int[6]; 
int sledger_id[] = new int[6]; 
double samount[] = new double[6]; 
 c=0;
for(int i=0;i<6;i++)
{
salesvoucher_id[i] = 0; 
sfor_headid[i] = 0; 
smode[i] = 2; 
sft_id[i] = 0; 
sledger_id[i] = 0; 
samount[i] = 0; 
}
for(int i=0;i<3;i++)
{

 query="Select * from Financial_Transaction where   Voucher_id=? order by Transaction_Type";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,svou_id[i]); 
rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
		{
sft_id[c]=rs_g.getInt("Tranasaction_Id");
if(rs_g.wasNull()){sft_id[c]=0;}
salesvoucher_id[c]=rs_g.getInt("Voucher_id");
if(rs_g.wasNull()){salesvoucher_id[c]=0;}
sfor_headid[c]=rs_g.getInt("for_headid");
if(rs_g.wasNull()){sfor_headid[c]=0;}
smode[c]=rs_g.getInt("Transaction_Type");
if(rs_g.wasNull()){smode[c]=2;}
samount[c]=rs_g.getDouble("Amount");
if(rs_g.wasNull()){samount[c]=0;}
sledger_id[c]=rs_g.getInt("Ledger_Id");
if(rs_g.wasNull()){sledger_id[c]=0;}


	c++;

	}	pstmt_g.close();
}//for
double salev_tot=Double.parseDouble(amount[0]);
for(int i=0;i<6;i++)
{
if((smode[i]==0)&&(sledger_id[i]!=0))
	{salev_tot +=samount[i];}
/*out.print("<br>");
out.print("&nbsp;&nbsp;salesvoucher_id="+salesvoucher_id[i]);
out.print("&nbsp;&nbsp;sft_id="+sft_id[i]);
out.print("&nbsp;&nbsp;sfor_headid="+sfor_headid[i]);
out.print("&nbsp;&nbsp;smode="+smode[i]);
out.print("&nbsp;&nbsp;samount="+samount[i]);
out.print("&nbsp;&nbsp;sledger_id="+sledger_id[i]);
*/
}
//out.print("&nbsp;&nbsp;salev_tot="+salev_tot);

int idexpense_id[]=new int[2];
int expft_id[]=new int[2];
int expv_id[]=new int[2];
double expamt[]=new double[2];
int e=0;
int idincome_id=0;
int idft_id=0;
int indv_id=0;
double idamt=0;
	for(int i=0;i<6;i++)
{
	if((smode[i]==0)&&(sledger_id[i]!=0))
	{
		expamt[e]= samount[i];
		idexpense_id[e]=sledger_id[i];
		expv_id[e]=salesvoucher_id[i];
		expft_id[e]=sft_id[i];
e++;
	}
if((smode[i]==1)&&(sledger_id[i]!=0))
	{
		idamt= samount[i];
		indv_id= salesvoucher_id[i];
		idincome_id=sledger_id[i];
		idft_id=sft_id[i];
	}
	
}//for
double fin_amt=salev_tot-idamt;
if("0".equals(v_currency))
{d=4;}

query="Select * from PN where Voucher_Id=0 and Active=1  and RefVoucher_id=? and PN_Status=0";
//out.print("<br>2300query="+query);
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,voucher_id); 
	rs_g = pstmt_g.executeQuery();	
String pn_no="";
int pn_id=0;
String pn_location="";
String pn_bank="";
String pn_description="";
String loan_taken="";
java.sql.Date payment_date = new java.sql.Date(System.currentTimeMillis());
while(rs_g.next())
	{
pn_id=rs_g.getInt("pn_id");
pn_no=rs_g.getString("pn_no");
//out.print("<br>2315pn_no="+pn_no);
payment_date=rs_g.getDate("payment_date");
pn_location=rs_g.getString("Location");
pn_bank=rs_g.getString("Bank");
String pn_loan=rs_g.getString("PN_Loan");
if("1".equals(pn_loan))
	{loan_taken="Checked";}
pn_description=rs_g.getString("Description");
	
	}
		pstmt_g.close();

String payment_datestring=format.format(payment_date) ;

	%>
<html><head><title>Edit Sales Receipt- Samyak Software - INDIA</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT"> 
<script language="JavaScript">

function disrtclick()
{
//window.event.returnValue=0;
}
function LocalValidate(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.debit_total.value=parseFloat(document.mainform.amount.value)+parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);
}
function LocalValidate_Income(fieldname)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
validate(fieldname,d);
document.mainform.credit_total.value=parseFloat(document.mainform.amount2.value) + parseFloat(document.mainform.income_amt.value);
}

function CheckTotal_CreditDebit()
{
calcTotal(document.mainform.amount);
if((document.mainform.expense_id1.value == document.mainform.expense_id2.value)&&(document.mainform.expense_amt1.value !=0) && (document.mainform.expense_amt2.value != 0)   )
	{
	alert ("Do Select Proper Account in Particulars");
	return false;
	}

if(document.mainform.credit_total.value==0)
	{
	alert ("Please Enter Value Properly");
	return false;
	}
else if(
		parseFloat(document.mainform.credit_total.value) !=parseFloat(document.mainform.debit_total.value))
		{
		alert ("Cerdit & Debit total should be equal");
		return false;
		}
	else if(isNaN(document.mainform.credit_total.value))
		{return false;}
	else if(isNaN(document.mainform.debit_total.value))
		{return false;}
	else{return true;}
}

function calcTotal(name)
{
	var d=4;

if(document.mainform.currency[1].checked)
	{
d=<%=d%>;
	}
//validate(name)
//alert ("Ok Inside CalcTotal");
var total_received=0;
<%
for(int i=0;i<salecount;i++)
{
//out.println("if(document.mainform.receive"+i+".checked){total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount"+i+".value)}");
%>
if(document.mainform.receive<%=i%>.checked)
{
<%
if(pdfor_headid[i]!=0)
	{
if("0".equals(Receive_CurrencyId[i]))
	{%>
	
		if(document.mainform.currency[0].checked)
		{
//			alert(" dollar invoice & dollar entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_dollar<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}
		}
		else
		{
//			alert("dollar invoice & local entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))/(parseFloat(document.mainform.exchange_rate.value))


			var pndg2= (parseFloat(document.mainform.pending_dollar<%=i%>.value));
			pndg1=parseFloat(pndg1.toFixed(d));
			pndg2=parseFloat(pndg2.toFixed(d));

//			alert("entered "+pndg1);
//			alert("pending "+pndg2);
			if(pndg2<pndg1)
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		}

<%	}
else
	{%>
//----------------
		if(document.mainform.currency[0].checked)
		{

//			alert("local invoice dollar entry");

			var pndg1= (parseFloat(document.mainform.receive_amount<%=i%>.value))*(parseFloat(document.mainform.exchange_rate.value))
			pndg1=parseFloat(pndg1.toFixed(d));
//			alert("entered local "+pndg1);

			var pndg2= parseFloat(document.mainform.pending_local<%=i%>.value)
			pndg2=parseFloat(pndg2.toFixed(d));
//			alert("pending local "+pndg2);
			
			if(pndg2<pndg1)
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;

			}
		
		}
		else
		{
//			alert("448 local invoice local entry");
			if((parseFloat(document.mainform.receive_amount<%=i%>.value))>(parseFloat(document.mainform.pending_local<%=i%>.value)))
			{
				alert("Paid Amount should be less than or equal to Pending Amount");
				document.mainform.receive_amount<%=i%>.select();
				return false;
			}

		}

<%	}
}
%>

validate(document.mainform.receive_amount<%=i%>,d);
total_received=parseFloat(total_received)+parseFloat(document.mainform.receive_amount<%=i%>.value);
total_received=total_received.toFixed(d);

/*
temp_rcd= new String(total_received);
var i_rcd=temp_rcd.indexOf(".") ;
var temp1_rcd="";
if(i_rcd>0)
	{
i_rcd =parseInt(i_rcd) + parseInt(d) + 1;
temp1_rcd=temp_rcd.substring(0,i_rcd);
total_received=temp1_rcd;
	}*/
}//if
<%}%>
document.mainform.received_total.value=total_received;
document.mainform.debit_total.value= parseFloat(total_received) + parseFloat(document.mainform.expense_amt1.value)+parseFloat(document.mainform.expense_amt2.value);

document.mainform.amount.value=total_received;
}



</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<SCRIPT language="JavaScript">
function exupdate(ex)
{
	document.mainform.exchange_rate.value = ex;
}


function validatedate()
		{

 var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;

		}

function compareExchRate(changedDate,name,origDate)
{
	var flag;
   //flag = fnCheckDate(changedDate,name)
   if(flag == true)
    {
	
    	var lc=<%=local_currency%>;

	var temp="../Inventory/InvExchangeRate.jsp?command=compareExchRate&invoicedate="+changedDate+"&currency_id="+lc;

	  
		window.open(temp,"_New", ["Top=2","Left=2","Toolbar=no", "Location=0","Menubar=no","Height=150","Width=200", "Resizable=yes","Scrollbars=no","status=no"]);

	   return true
	}
   else
	   return false
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor='#FCF7B6' onContextMenu="disrtclick()">

<form action=EditPNPurchasePaymentUpdate.jsp method=post name=mainform onSubmit='return validatedate()'>

<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
<td align=right>Run Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1	 cellspacing=0 rules=none bgcolor='#FCF7B6' width='100%'>

<!--Edit Part for PN Purchase Payment Voucher-->

<tr ><th colspan=9>Edit PN Purchase Payment Voucher</th></tr>
<tr>
<td>Payment No
<input type=text name=voucher_no value="<%=voucher_no%>" size=4></td>
<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
<input type=hidden name=from_india value="<%=from_india%>" >
<td colspan=2 align=right>
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Receive Date' style='font-size:11px ; width:100'>")}
</script>
 <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>


</td>
<input type=hidden name=voucher_id value="<%=voucher_id%>">

</tr>
<tr>
<td>PN No
<input type=text size=10 name="pn_no" value="<%=pn_no%>"></td>
<%
	String lselect="";
	String dselect="";
if(v_currency.equals("0"))
	{
//	out.print("<br> 1638 if dollar");
dselect="checked";
}
else{
lselect="checked";
//	out.print("<br> 1638 if local");

}
%>
<td colspan=1 align=left>Currency <input type=radio name="currency" value="dollar" <%=dselect%>>Dollar<input type=radio name="currency" value="local" <%=lselect%>>Local
</td>
<td colspan=1 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=str.format(""+ex_rate,exRateDec)%>' onblur='validate(this ,<%=exRateDec%>)' style="text-align:right"></td>

</tr>
<tr><td colspan=4><hr></td></tr>
<tr > <th colspan=2 > Particulars</th>
<th>Debit
<%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th><th > Credit <%if("1".equals(v_currency))
{out.print("("+local_symbol+")");}
else{out.print("($)");}%>
</th></tr>
<tr><td colspan=4><hr></td></tr>
<tr><td>BY</td>
<input type=hidden name=ft_id1 value="<%=ft_id[1]%>">
<input type=hidden name=type_toby1 value="by">
<td>
<input type=hidden name=ledger_id value="<%=ledger_id[1]%>">

<%//=A.getArray("Ledger","ledger_id",ledger_id[0],company_id,"Party")%>
<B><%=A.getNameCondition(cong,"Ledger","Ledger_Name","Where Ledger_id="+""+ledger_id[1])%></B>
	
</td>
<td align=center><input type=text size=8 name=amount  value="<%=str.mathformat(""+amount[0],d)%>" readonly  style="text-align:right" style="background:#FCF7B6" >
</td></tr>
<%
%>
<tr>
<td>To  </td>
<td ><B>PN Account</B>
<input type=hidden name=account_id value="<%=for_headid[0]%>">

<input type=hidden name=ft_id0 value="<%=ft_id[0]%>">
<input type=hidden name=type_toby0 value="to">

<%//=A.getMasterArrayAccount("account_id",for_headid[0],company_id,"Normal") %> 
<%//=A.getMasterArray("Account","account_id","",company_id) %> </td>
	<td>&nbsp;</td>

<td align=center><input type=text size=8 name=amount2  value="<%=str.mathformat(""+fin_amt,d)%>"     style="text-align:right" onblur='LocalValidate_Income(this)'>
</td>
</tr>
<tr>

<td>By</td><td>
<input type=hidden name=expft_id1 value="<%=expft_id[0]%>">
<input type=hidden name=expv_id1 value="<%=expv_id[0]%>">

<%=A.getArray(cong,"Ledger","expense_id1",""+idexpense_id[0],company_id+" and yearend_id="+yearend_id,"Ledger")%></td><td  align=center> <input type=text size=8 name=expense_amt1  value="<%=str.mathformat(""+expamt[0],d)%>"  style="text-align:right" onblur='LocalValidate(this)'></td>
</tr>

<tr>
<input type=hidden name=expft_id2 value="<%=expft_id[1]%>">
<input type=hidden name=expv_id2 value="<%=expv_id[1]%>">

<td>By</td><td><%=A.getArray(cong,"Ledger","expense_id2",""+idexpense_id[1],company_id+" and yearend_id="+yearend_id,"Ledger")%>
	</td> 
<td  align=center><input type=text size=8 name=expense_amt2  value="<%=str.mathformat(""+expamt[1],d)%>"   style="text-align:right" onblur='LocalValidate(this)'>
</td>
</tr>
<tr>		
<td>To</td><td>
 <input type=hidden name=idft_id value="<%=idft_id%>">
 <input type=hidden name=indv_id value="<%=indv_id%>">

<%=A.getArray(cong,"Ledger","income_id",""+idincome_id,company_id+" and yearend_id="+yearend_id,"Ledger")%> </td><td></td>
<td  align=center><input type=text size=8 name=income_amt  value='<%=str.mathformat(""+idamt,d)%>' style="text-align:right" onblur='LocalValidate_Income(this)'></td></tr>

<tr><td colspan=4><hr></td></tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center >
<input type=text size=8 name=debit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#FCF7B6" style="text-align:right">
</td>
<td align=center ><input type=text size=8 name=credit_total  readonly value='<%=str.mathformat(""+salev_tot,d)%>' style="background:#FCF7B6" style="text-align:right"></td>
<td></td>
</tr>
<tr><td colspan=4><hr></td></tr>

<tr>
<td>Narration</td>
<td colspan=3><input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<%


	%>
<tr><td colspan=4>
<table cellspacing=0 width='100%'>
<tr><td colspan=6><hr></td></tr>
<tr><th colspan=6>PN Details </th></tr>
	<tr>
<td>Location</td>
<td colspan=1><input type=text size=20 name=location value="<%=pn_location%>"></td>
<td colspan=3 align="right">
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.payment_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
</script>
<input type=text name='payment_date' size=8 maxlength=10 value="<%=payment_datestring%>"
onblur='return  fnCheckDate(this.value,"Date")'>
</td>
</tr>

<tr>
<td>Description</td>
<td colspan=3><input type=text size=50 name=pn_description value="<%=pn_description%>"></td>

<td  colspan=3 align=right>Bank Name
<%=A.getMasterArrayAccount(cong,"bank_name",pn_bank,company_id+" and yearend_id="+yearend_id,"PN") %> </td>
</tr>
<input type=hidden name=loan value=no >
<input type=hidden name=pn_id value=<%=pn_id%> >
</table></td></tr>

<tr><td colspan=6><hr></td></tr>
<tr><td colspan=6>
<table align=center  border=1 cellspacing=0 width='100%'>
	<tr><th colspan=13>
Pending Purchase </th>
<tr>
<th align=left>Select</th>
<th align=left>No</th>
<th align=center>Transaction<br>Currency</th>
<th>Date</th>
<%/*if("1".equals(v_currency))
{*/
	

%>
<th align=right>Total(<%=local_symbol%>)</th>
<th align=right>Recd(<%=local_symbol%>)</th>
<th align=right>Pending(<%=local_symbol%>)</th>
<!-- <th>Recd(<%=local_symbol%>)</th>
 -->
<%/*}else  {*/%>
<th align=right>Total($)</th>
<th align=right>Recd($)</th>
<th align=right>Pending($)</th>
<!-- <th>Recd($)</th>
 -->
<%/*}
*/
%>
<th>Received</th>

<input type=hidden name=counter value="<%=salecount%>"> 
<%
j=1;
for(int i=0; i<(salecount); i++)
{
%>
<tr>
<td>
<input type=checkbox name=receive<%=i%> value=yes OnClick='return calcTotal(this)' checked> &nbsp;<%=j++%></td>
<input type=hidden name=payment_id<%=i%> value="<%=payment_id[i]%>"> 
<input type=hidden name=pdfor_headid<%=i%> value="<%=pdfor_headid[i]%>"> 
<input type=hidden name=receive_id<%=i%> value="<%=pdfor_headid[i]%>"> 
<td><%=receive_no[i]%>
	<%/*

if(0==(pdfor_headid[i])){
out.print("<B>On Account</b>");}
else{
out.print(""+receive_no[i]);
}*/
	%></td>
<td><%
if(pdfor_headid[i]!=0)
	{
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
	}
else{
%>-
<%}%>	
</td>

<td align=center> <%=format.format(receive_date[i])%></td>
<%if(pdfor_headid[i]==0)
		{
%>
<input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+local_amount[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+dollar_amount[i],2)%>'>
<%		}else{
%><input type=hidden name=pending_local<%=i%> value='<%=str.mathformat(""+splocal[i],d)%>'>
<input type=hidden name=pending_dollar<%=i%> value='<%=str.mathformat(""+spdollar[i],2)%>'>
<%}
	%>


<%/*if("1".equals(v_currency))
{*/
%>
<td align=right><%=str.format(""+slocal[i],d)%></td>
<td align=right> <%=str.format(""+srlocal[i],d)%></td>
<td align=right> <%=str.format(""+splocal[i],d)%></td>

<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
 --><%/*} else{*/%>

<td align=right><%=str.format(""+sdollar[i],2)%></td>
<td align=right> <%=str.format(""+srdollar[i],2)%></td>
<td align=right> <%=str.format(""+spdollar[i],2)%></td>


<!-- <td align=center><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
 --><%/*}
*/
%>

<% if(v_currency.equals("1"))
	{
	%>
<td align=center><%//out.print("Local");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+local_amount[i],d)%>'> </td>
<%}
else
	{%>
<td align=center><%//out.print("Dollar");%><input type=text name=receive_amount<%=i%> size=8 OnBlur='return calcTotal(this)' style="text-align:right" value='<%=str.mathformat(""+dollar_amount[i],d)%>'> </td>
<%}%>

</tr>


<%

}//for
C.returnConnection(cong);

%>
<tr>
<td colspan=10 align=right><B>Total</B></td>
<td align=center><input type=text name=received_total  value="<%=str.mathformat(""+amount[0],d)%>"  readonly size=8 style="background:#FCF7B6" style="text-align:right"> </td>
</tr>
</td></tr>
</table>
<tr><td align=center colspan=4>
<%if(pn_id>0)
	{
%>


<input type=submit name=command value='Update' onClick="return CheckTotal_CreditDebit()" class='button1'>

<%}else{out.print("<font class='star1'>PN Against This Voucher  has been cleared, So can't be Modified</font>");}%>
</td></tr>
</table>
</td></tr>
</table>


<%




	}//voucher type=13 i.e.PN Purchase Payment




}
catch(Exception e31){ 
	C.returnConnection(cong);
	out.print("<br>Error after :: "+samyakerror);
	out.println("<font color=red> FileName : EditVoucher1.jsp<br>Bug No e31 : "+ e31);}
%>










