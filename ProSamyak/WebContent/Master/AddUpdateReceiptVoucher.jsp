<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
String query="";
try	{
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : UpdateVoucher.jsp<br>Bug No Samyak31 : "+ e31);}


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
 
int dd1=D.getDate();
int mm1=D.getMonth()+1;
int yy1=D.getYear()+1900;

int dd2=D.getDate();
int mm2=D.getMonth()+1;
int yy2=D.getYear()+1900;

String company_name= A.getName(conp,"companyparty",company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int  d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String command=request.getParameter("command");
//out.print("<br>Command"+command);
//-----------------------Command=ADD-----------------------------


if("Add".equals(command))
{

try{


//out.println("Command is "+command);

	String voucher_id=request.getParameter("voucher_id");
//out.print("voucher_id"+voucher_id);

String orignal_toby=""+request.getParameter("orignal_toby");
String receipt_no=""+request.getParameter("voucher_no");
String ref_no=""+request.getParameter("ref_no");
String datevalue=""+request.getParameter("datevalue");
String currency= request.getParameter("currency");
//out.print("<br>14currency:"+currency);
String exchange_rate=request.getParameter("exchange_rate");
//float exchange_rate= Float.parseFloat(request.getParameter("exchange_rate"));
//out.print("<br>12exrate:"+exchange_rate);
String description= request.getParameter("description");

String to_by=""+request.getParameter("to_by");
// out.println("<br>to_by is "+to_by);

int count_actual=Integer.parseInt(request.getParameter("counter"));
int counter=count_actual+1;
//out.print("<br>orignal_toby"+orignal_toby);
//out.print("<br>count_actual"+count_actual);
//out.println("<br>counter is "+counter);

String srno[]=new String[counter];
String type_toby[]=new String[counter+1]; 
String account_id[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];

int ft_id[]=new int[counter];

for (int i=0;i<=count_actual;i++)
{

srno[i]=""+request.getParameter("srno"+i);
type_toby[i]=""+request.getParameter("type_toby"+i);
	//out.print("<br>84 type_toby[i]"+type_toby[i]);
	//out.print(" i"+i);

account_id[i]=""+request.getParameter("account_id"+i);
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 

String tempft_id =request.getParameter("ft_id"+i);
if(tempft_id==null)
	{
	tempft_id="0";
	}
ft_id[i]=Integer.parseInt(tempft_id);
//out.print("<br>ft_id"+i+ft_id[i]);



}
type_toby[count_actual]=to_by;
//type_toby[counter]="to";
	//out.print("<br>89 type_toby[counter] "+type_toby[counter]);
	//out.print("<br>89 [counter] "+counter);
	//out.print("<br>89 [count_actual] "+count_actual);
	//out.print("<br>89 to_by "+to_by);

//for (int i=0;i<=count_actual;i++)
//{
//out.println("<br>srno"+i+":"+srno[i]);
//out.println("<font //color=red>type_toby"+i+":</font>"+type_toby[i]);
//out.println(",account_id"+i+":"+account_id[i]);
//out.println(",amount"+i+":"+amount[i]);
//out.println(",remarks"+i+":"+remarks[i]);
//}


/*
for(int i=0;i< counter;i++)
	{
	//out.print("<br>to_by"+type_toby[i]);

	}
*/

%>

<html><head><title>Samyak Software - INDIA</title>
<script>
function disrtclick()
{
//window.event.returnValue=0;
}

function nonrepeat()
{
	<%
	for(int i=0;i<counter;i++)
	{
		for(int j=i+1;j<counter;j++)
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

function calcTotal(name)
{
//alert ("Ok Inside CalcTotal");
var d=2;
	if(document.mainform.currency[0].checked)
	{d=<%=d%>;}

var total_debit=0;
var total_credit=0;


<%
for(int i=0;i<counter;i++)
{
if ("by".equals(type_toby[i]))
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
else if ("to".equals(type_toby[i]))
{
%>
validate(document.mainform.amount<%=i%>,d)
//alert ("amt="+document.mainform.amount<%=i%>.value);
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

//out.print("total_credit=parseFloat(total_credit)+parseFloat(document.mainform.amount"+i+".value);");
}//end if
}//end for 


%>


document.mainform.credit_total.value=total_credit;
document.mainform.debit_total.value=total_debit;
}
</script>

<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=#99FF99  onContextMenu="disrtclick()">
<form action="AddUpdateReceiptVoucher.jsp?message=Default" method=post name=mainform >
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><b><%=company_name%></b></td> 
<td align=right>Date:<%=format.format(D)%></td><tr>
<tr><td colspan=2>
<table align=center  border=1 cellspacing=0 bgcolor=#99FF99 width='100%'>
<tr><td>
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>

<tr ><th colspan=5>Receipt Voucher</th></tr>
<tr>
<td>Receipt No
<input type=text name=voucher_no value="<%=receipt_no%>" size=4></td>

<td>
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>

<td colspan=3 align=right>
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Date' style='font-size:11px ; width:50'>")}
</script> <input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>"
onblur='return  fnCheckDate(this.value,"Date")'>


</td>
</tr>

<tr>
<td colspan=2>Currency 
<% if("local".equals(currency))
	{ %>
	<input type=radio size=4 name=currency value=local checked>Local	<input type=radio size=4 name=currency value=dollar>Dollar
<% }else { %>
		<input type=radio size=4 name=currency value=local >Local	<input type=radio size=4 name=currency value=dollar checked>Dollar
<%
}
%>
</td>
<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=exchange_rate%>' onblur='validate(this,2)' style="text-align:right"></td>
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
for (int i=0;i<count_actual;i++)
{	
%>
<input type=hidden name=srno<%=i%> value=<%=srno[i]%>>
<input type=hidden name=ft_id<%=i%> value=<%=ft_id[i]%>>


<%
if("to".equals(type_toby[i]))
	{
%>
<input type=hidden name=type_toby<%=i%> value=to>
<tr>
<td colspan=1>To </td><td> 
<%=A.getArray(conp,"Ledger","account_id"+i,account_id[i],company_id+" and yearend_id="+yearend_id,"Ledger")%>

<%//=A.getMasterArrayAccount(conp,"account_id"+i,account_id[i],company_id) %><%//=A.getMasterArray(conp,"Account","account_id","",company_id) %> </td><td></td>
<td align=center><%//=i%> 
<input type=text size=8 name=amount<%=i%>  value="<%=amount[i]%>" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remarks[i]%>"> </td>
</tr>
<% }
else if("by".equals(type_toby[i]))
	{
%>
<input type=hidden name=type_toby<%=i%> value=by>
<td colspan=1>By </td>
<td>
<%=A.getMasterArrayAccount(conp,"account_id"+i,account_id[i],company_id+" and yearend_id="+yearend_id,"Normal") %>
<%//=A.getArray("Ledger","ledger_id","",company_id,"Receipt")%>
</td>
<td align=center><%//=i%> 
<input type=text size=8 name=amount<%=i%> value="<%=amount[i]%>" OnBlur='return calcTotal(this)' style="text-align:right"></td>
<td></td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remarks[i]%>"> </td>
</tr>
<%
}
}//end for
//out.print("<br>********************to_by-->"+to_by);
if ("to".equals(to_by))
	{
	//out.print("<br>count_actual to"+count_actual);
%>
<tr>
<input type=hidden name=srno<%=count_actual%> value=<%=count_actual%>>
<input type=hidden name=type_toby<%=count_actual%> value=to>
<td colspan=1>To </td><td> 
<%=A.getArray(conp,"Ledger","account_id"+count_actual,"",company_id+" and yearend_id="+yearend_id,"Ledger")%>
<%//=A.getArray("Ledger","account_id","",company_id,"Receipt")%>
<%//=A.getMasterArrayAccount("account_id"+counter,"",company_id) %>
</td><td></td>
<td align=center><%//=count_actual%>
<input type=text size=8 name=amount<%=count_actual%>  value="" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=count_actual%>  value="0" > </td>
</tr>
<%	}
else if ("by".equals(to_by))
	{
		//out.print("<br>Inside by");

%>

<tr>
<input type=hidden name=srno<%=count_actual%> value=<%=count_actual%>>
<input type=hidden name=type_toby<%=count_actual%> value=to>
<td colspan=1>By </td>
<td>
<%=A.getMasterArrayAccount(conp,"account_id"+count_actual,"",company_id+" and yearend_id="+yearend_id,"Normal") %>
<%//=A.getArray("Ledger","ledger_id","",company_id,"Receipt")%>
</td>
<td align=center><input type=text size=8 name=amount<%=count_actual%> OnBlur='return calcTotal(this)' style="text-align:right" value="0"></td>
<td><%//=count_actual%></td>
<td><input type=text size=8 name=remarks<%=count_actual%>  value=""> </td>
</tr>
<%
	}
%>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>
<tr>
<td colspan=1></td>
<td><B>Total</B></td>
<td align=center bgcolor=#99FF99>
<input type=text size=8 name=debit_total  readonly value="" style="background:#99FF99" style="text-align:right">
</td>
<td align=center bgcolor=#99FF99><input type=text size=8 name=credit_total  readonly value="" style="background:#99FF99" style="text-align:right"></td>
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
</select> -->
<input type=hidden name=to_by value='to'>
<input type=hidden name=orignal_toby value='<%=orignal_toby%>'>
<input type=hidden name=voucher_id value="<%=voucher_id%>">
<input type=hidden name=counter value=<%=counter%>>
<input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></td>
<td align=center >
<input type=submit name=command value='Add' class='button1'>
</td>
<td colspan=2 align=center>
<input type=submit name=command value='Save' class='button1' onClick="return CheckTotal_CreditDebit()"></td></tr>
</table>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>

<%
	C.returnConnection(conp);
	
}//try
catch(Exception Samyak444){ 
out.println("<br><font color=red> FileName : Receipt.jsp Bug No Samyak444 : "+ Samyak444);
}
}//if ADD








if("Save".equals(command))
{
	
%>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<%
	String account_id1=""+request.getParameter("account_id1");
	String from_india=""+request.getParameter("from_india");
//out.print("<br>account_id1->"+account_id1);

String Transaction_Currency_Bank=A.getNameCondition(conp,"Master_Account","Transaction_Currency"," Where Account_Id= " + account_id1 );
//out.print("<br>Transaction_Currency_Bank->"+Transaction_Currency_Bank);

String Bank_Currency="";
if("1".equals(Transaction_Currency_Bank))
{
Bank_Currency="local";
}
else// Transaction_Currency_Bank=0
{
	Bank_Currency="dollar";
}
//out.print("<br>Bank_Currency->"+Bank_Currency);

String currency= request.getParameter("currency");
//out.print("<br>14currency:->"+currency);

boolean currency_check_flag=true;

/*Currency Check lock removed on clients request 24/09/2005
if(Bank_Currency.equals(currency))
{
	currency_check_flag=true;
}
else
{
	currency_check_flag=false;
}
*/
//out.print("<br>currency_check_flag"+currency_check_flag);

if(currency_check_flag == true )
{


int orignal_toby=Integer.parseInt(request.getParameter("orignal_toby"));
//out.print(" <br>orignal_toby "+orignal_toby);

try{ 


String voucher_no=""+request.getParameter("voucher_no");
//out.print("<br>voucher_no->"+voucher_no);
String ref_no=""+request.getParameter("ref_no");

String type= ""+request.getParameter("voucher_type");
//out.print("<br>Type="+type);
double total= Double.parseDouble(request.getParameter("credit_total"));
double debit_total= Double.parseDouble(request.getParameter("debit_total"));
 //out.println("counter "+counter);
query="";
//out.print("<br>type:"+type);
if(total==debit_total)
{
//out.print("<br>11:"+total);
double exchange_rate= Double.parseDouble(request.getParameter("exchange_rate"));
// out.print("<br>12exrate:"+exchange_rate);

String voucher_id=request.getParameter("voucher_id");
//out.print("<br>422voucher_id->"+voucher_id);

int v_old=Integer.parseInt(voucher_id);
int v_id=0;
String noquery="Select * from  Voucher where Company_Id=? and Voucher_No=?";
//out.print("<br>94 query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no); 
rs_g = pstmt_p.executeQuery();
// out.print("<br>94 query fired" +query);
int no_exist=0;
while(rs_g.next()) 	
{
v_id=rs_g.getInt("voucher_id");
if (rs_g.wasNull())
{v_id=0;}
no_exist++;}
pstmt_p.close();
//out.print("<br>************");

if((no_exist > 0)&&(v_id != v_old))
{
	C.returnConnection(conp);
	
	%>

<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<%
out.print("<br><center><font class='star1'>Voucher No "+voucher_no+ " already exist.</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else
	{




//out.print("<br>voucher_id"+voucher_id);
//out.print("<br>v_id"+v_id);

String datevalue=""+request.getParameter("datevalue");
java.sql.Date date_value=format.getDate(datevalue);



//String currency= request.getParameter("currency");




String description= request.getParameter("description");
//String to_by=""+request.getParameter("to_by");
//out.println("to_by is "+to_by);
int count_actual= Integer.parseInt(request.getParameter("counter"));
int counter=count_actual;
//out.println("79 counter is "+counter);
boolean voucher_currency=false;
double localamt=0;
double dollaramt=0;
//out.println("<br><font color=red>currency</font>:"+currency);

if ("local".equals(currency))
{
localamt=total;
if(exchange_rate==0)
	{
	localamt=0;
	}
else
	{
	dollaramt= localamt/exchange_rate;
	}
voucher_currency=true;
}
else
{
dollaramt=total;
localamt= dollaramt*exchange_rate;
voucher_currency=false;
}
//out.println("<font color=red>localamt</font>:"+localamt);
//out.println("<font color=red>dollaramt</font>:"+dollaramt);



String srno[]=new String[counter];
String type_toby[]=new String[counter]; 
String account_id[]=new String[counter];
double amount[]=new double[counter];
double local_amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String remarks[]=new String[counter];
String for_head[]=new String[counter];
String for_headid[]=new String[counter];
String ledger_id[]=new String[counter];
String ledger_type[]=new String[counter];

boolean mode[]=new boolean[counter];
String ft_id[]=new String[counter];
// out.println("count_actual"+count_actual);
for (int i=0;i<count_actual;i++)
{

//srno[i]=""+request.getParameter("srno"+i);
//out.print("srno"+i+" "+srno[i]);
type_toby[i]=""+request.getParameter("type_toby"+i);
account_id[i]=""+request.getParameter("account_id"+i);
String amt=request.getParameter("amount"+i);
//out.print("<br>amt"+amt);
amount[i]=Double.parseDouble(amt); 
//out.print("<br>amount"+i+amount[i]);

remarks[i]=""+request.getParameter("remarks"+i); 
ft_id[i]=""+request.getParameter("ft_id"+i);
}

 //out.println("Outside for 123 --");
// type_stoby[counter]=to_by;
//out.println("<br><font color=red>v_type="+type+"</font>");
for (int i=0;i<count_actual;i++)
{
//out.println("<br>srno"+i+":"+srno[i]);
//out.println("<font color=red>type_toby"+i+":</font>"+type_toby[i]);
//out.println(",account_id"+i+":"+account_id[i]);
//out.println(",amount"+i+":"+amount[i]);
//out.println(",remarks"+i+":"+remarks[i]);
//out.println(",ft_id"+i+":"+ft_id[i]);
ledger_id[i]=account_id[i];
//out.print("<br>type->"+type);


//String type="6";
/*
if("6".equals(type))//RECEIPT
{*/
ledger_id[i]="0";
for_headid[i]=account_id[i];
for_head[i]="1";
if("0".equals(account_id[i]))
{for_head[i]="4";}
//mode=true= debit false=credit
mode[i]=false;
//out.print("<br>------- type_toby"+"["+i+"]"+type_toby[i]);

if("to".equals(type_toby[i]))
{
mode[i]=true;

query="Select * from Ledger where Ledger_id="+account_id[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
for_head[i]=rs_g.getString("For_Head");
for_headid[i]=rs_g.getString("For_HeadId");
ledger_id[i]=account_id[i];

}
pstmt_p.close();
}
//}

	
//out.println("<br><font color=blue>for_head="+for_head[i]);
//out.println("<br>for_headid="+for_headid[i]+"</font>");
//out.println("<br>ledger_id="+ledger_id[i]+"</font>");
if ("local".equals(currency))
	{
	local_amount[i]=amount[i];
	if(exchange_rate==0)
		{
		dollar_amount[i]=0;
		}
	else
		{
		dollar_amount[i]= local_amount[i]/exchange_rate;
		}
	}
else
	{
	dollar_amount[i]=amount[i];
	local_amount[i]= dollar_amount[i]*exchange_rate;
	}
 //out.print("<br> 151 --");
}

//out.print("<br> for 155 --");


//out.println("<br>669 voucher_id="+voucher_id);
for (int i=0;i< counter;i++)
{
//out.print("<br>------- ft_id"+"["+i+"]"+ft_id[i]);
//out.print("<br>------- for_headid"+"["+i+"]"+for_headid[i]);
//out.print("<br>------- mode"+"["+i+"]"+mode[i]);
//out.print("<br><br>");

}
conp.setAutoCommit(false);

query="Update Voucher set  Company_Id=?, Voucher_No=?, Voucher_Date='"+date_value+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?,Ref_No=? where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);


pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no);		
//out.println("<br >2 :0");
pstmt_p.setString (3,""+counter);
//out.println("<br >5 "+counter);
pstmt_p.setBoolean(4,voucher_currency);
pstmt_p.setDouble (5,exchange_rate);
pstmt_p.setDouble (6,total);	
pstmt_p.setDouble (7,localamt);	
pstmt_p.setDouble (8,dollaramt);
pstmt_p.setString (9,description);
pstmt_p.setString (10,user_id);	
pstmt_p.setString (11,machine_name);	
pstmt_p.setString(12,ref_no);

pstmt_p.setString (13,""+voucher_id);		
//out.println("<br >machine_name "+machine_name);
//out.println("<br >voucher_id "+voucher_id);

  int a691 = pstmt_p.executeUpdate();
  //out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +a691+" voucher_id "+voucher_id);
pstmt_p.close();

//int tranasaction_id= L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
//out.print("<br>-------Actual Count======>"+count_actual);
for (int i=0;i< orignal_toby;i++)
{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+date_value+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));		
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
 int a749 = pstmt_p.executeUpdate();
 // out.println(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();

}//for
int tranasaction_id= L.get_master_id(conp,"Financial_Transaction");
//out.print("<br>tranasaction_id-->"+tranasaction_id);
//out.print("<br>orignal_toby-->"+orignal_toby);
//out.print("<br>count_actual-->"+count_actual);


//-----------------------------------------------
for(int i=orignal_toby;i< count_actual ;i++)
	{
//out.print("<br>-----------------i>"+i);
if("1".equals(for_head[i]))
	{account_id[i]="0";}
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName,Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+date_value+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+(tranasaction_id));		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+voucher_id);		
pstmt_p.setString(4,""+(i+1));	
pstmt_p.setString (5,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid[i]);
pstmt_p.setString (7,remarks[i]);
pstmt_p.setBoolean(8,mode[i]);
pstmt_p.setDouble (9,amount[i]);	
pstmt_p.setDouble (10,local_amount[i]);	
pstmt_p.setDouble (11,dollar_amount[i]);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,account_id[i]);	
pstmt_p.setString (15,yearend_id);
//out.print("<br >machine_name "+machine_name);
  int a749 = pstmt_p.executeUpdate();
 // out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +a749);
pstmt_p.close();
		tranasaction_id++;

	}
//--------------------------------------------------


conp.commit();

C.returnConnection(conp);

%>
<script language="JavaScript">
function f1()
{
var vno="<%=voucher_no%>";
alert("Data Sucessfully Updated for Voucher No "+vno+"");
<%
if("yes".equals(from_india))
{
	response.sendRedirect("../Report/DayBook_India.jsp?command=Next&bydate=Invoice_Date&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
}
else
{
	response.sendRedirect("EditVouchers.jsp?command=edit&&message=Voucher "+voucher_no+" Updated Successfully");
}

%> 
 
 window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML>
<%
 }//else moexist
}//if total
else {

C.returnConnection(conp);


%>
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<%
out.print("<br><center><font class='star1'>Debit And Credit Total Should Be Equal</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}


}
catch(Exception Samyak444){ 
	conp.rollback();
out.println("<br><font color=red> FileName : UpdateVoucher.jsp Bug No Samyak444 : "+ Samyak444);
}

}//end if
else
{
		C.returnConnection(conp);
 out.println("<body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Bank Currency Should Be Same as Transction Currency</b><br><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");

}//end else

}//if Update
%>






