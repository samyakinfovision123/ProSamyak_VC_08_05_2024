<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String errLine="7";
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
//String ref_no=""+request.getParameter("ref_no");

ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;


try	{
	conp=C.getConnection();
}
catch(Exception e31)
{out.println("<font color=red> FileName : UpdateVoucher.jsp<br>Bug No Samyak31 : "+ e31);}



String query="";
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string=format.format(D);
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
out.println("Command is "+command);
double oldex_rate= Double.parseDouble(request.getParameter("oldex_rate"));

out.print("<br>Inside 7oldex_rate "+oldex_rate);

String orignal_toby=request.getParameter("orignal_toby");
//out.print("<br>orignal_toby"+orignal_toby);
String old_currency=request.getParameter("old_currency");
//out.print("<br>old_currency"+old_currency);

String voucher_id=""+request.getParameter("voucher_id");
//out.print("<br>voucher_id"+voucher_id);
String voucher_no=""+request.getParameter("voucher_no");
String ref_no=""+request.getParameter("ref_no");

//String journal_no=""+request.getParameter("journal_no");
String datevalue=""+request.getParameter("datevalue");
String currency= request.getParameter("currency");
//out.print("<br>14currency:"+currency);
String exchange_rate=request.getParameter("exchange_rate");
//float exchange_rate= Float.parseFloat(request.getParameter("exchange_rate"));
//out.print("<br>12exrate:"+exchange_rate);
String description= request.getParameter("description");

String to_by=""+request.getParameter("to_by");
//out.println("to_by is "+to_by);
int count_actual=Integer.parseInt(request.getParameter("counter"));
int counter=count_actual+1;
//out.println("counter is "+counter);

String srno[]=new String[counter];
String type_toby[]=new String[counter+1]; 
String account_id[]=new String[counter];
String amount[]=new String[counter];
String old_amount[]=new String[counter];
String remarks[]=new String[counter];
String old_ledgerid[]=new String[counter];
String ft_id[]=new String[counter];

errLine="89";
for (int i=0;i<=count_actual;i++)
{
srno[i]=""+request.getParameter("srno"+i);
type_toby[i]=""+request.getParameter("type_toby"+i);
account_id[i]=""+request.getParameter("account_id"+i);
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
old_ledgerid[i]=""+request.getParameter("old_ledgerid"+i);
//out.print("<br>old_ledgerid["+i+"]"+old_ledgerid[i]);
old_amount[i]=""+request.getParameter("old_amount"+i);
//out.print("<br>old_amount["+i+"]"+old_amount[i]);
ft_id[i]=""+request.getParameter("ft_id"+i);
//out.print("<br>ft_id["+i+"]"+ft_id[i]);

}
 
type_toby[count_actual]=to_by;
//for (int i=0;i<=count_actual;i++)
//{
//out.println("<br>srno"+i+":"+srno[i]);
//out.println("<font //color=red>type_toby"+i+":</font>"+type_toby[i]);
//out.println(",account_id"+i+":"+account_id[i]);
//out.println(",amount"+i+":"+amount[i]);
//out.println(",remarks"+i+":"+remarks[i]);
//}
%>

<html><head><title>Samyak Software - INDIA</title>
<script>
function disrtclick()
{
//window.event.returnValue=0;
}

function aLocalValidateDebit_amount(fieldname)
{
var total_debit=0;
validate(fieldname);
total_debit=document.mainform.by_amount.value
document.mainform.debit_total.value=total_debit;
}

function aLocalValidateCredit_amount(fieldname)
{
var total_credit=0;
validate(fieldname);
total_credit=document.mainform.to_amount.value
document.mainform.credit_total.value=total_credit;
}

function aCheckTotal_CreditDebit()
{
return true;
}
function nonrepeat()
{
	<%
	for(int i=0;i<counter;i++)
	{
		for(int j=i+1;j<counter;j++)
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
validate(name)
//alert ("Ok Inside CalcTotal");

var total_debit=0;
var total_credit=0;
<%
for(int i=0;i<counter+1;i++)
{
if ("by".equals(type_toby[i]))
{
out.print("total_debit=parseFloat(total_debit)+parseFloat(document.mainform.amount"+i+".value);");
}//end if
else if ("to".equals(type_toby[i]))
{
out.print("total_credit=parseFloat(total_credit)+parseFloat(document.mainform.amount"+i+".value);");
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

<body bgcolor=#78D9FE  onContextMenu="disrtclick()">
<form action="AddUpdateJournalVoucher.jsp?message=Default" method=post name=mainform >
<table align=center bordercolor=skyblue border=0 cellspacing=0 width='100%'>
<tr><td><B><%=company_name%></B></td> 
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
<td colspan=3 align=right>Exchange Rate/$ <font class="star1">*</font> <input type=text size=4 name=exchange_rate value='<%=exchange_rate%>' onblur='validate(this)' style="text-align:right"></td>
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

<!-- for (int i=0;i<count_actual;i++)
{
srno[i]=""+request.getParameter("srno"+i);
type_toby[i]=""+request.getParameter("type_toby"+i);
account_id[i]=""+request.getParameter("account_id"+i);
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
} -->

<%
for (int i=0;i<count_actual;i++)
{
%>
<input type=hidden name=srno<%=i%> value=<%=srno[i]%>>
<input type=hidden name=old_amount<%=i%> value=<%=old_amount[i]%>>
	<input type=hidden name=old_ledgerid<%=i%> value='<%=old_ledgerid[i]%>'>
	<input type=hidden name=ft_id<%=i%> value='<%=ft_id[i]%>'>


<%
if("to".equals(type_toby[i]))
	{
%>
<input type=hidden name=type_toby<%=i%> value=to>
<tr>
<td colspan=1>To </td>
<td><%=A.getArray(conp,"Ledger","account_id"+i,account_id[i],company_id+"and yearend_id="+yearend_id,"Journal")%> 
</td>
<td></td>
<td align=center>
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
<td><%=A.getArray(conp,"Ledger","account_id"+i,account_id[i],company_id+"and yearend_id="+yearend_id,"Journal")%>
</td><td align=center>
<input type=text size=8 name=amount<%=i%> value="<%=amount[i]%>" OnBlur='return calcTotal(this)' style="text-align:right"></td>
<td></td>
<td><input type=text size=8 name=remarks<%=i%>  value="<%=remarks[i]%>"> </td>
</tr>
<%
}
}//end for

if ("to".equals(to_by))
	{
%>
<tr>
<input type=hidden name=srno<%=count_actual%> value=<%=count_actual%>>
<input type=hidden name=type_toby<%=count_actual%> value=to>
<td colspan=1>To </td><td> 
<%=A.getArray(conp,"Ledger","account_id"+count_actual,"",company_id+"and yearend_id="+yearend_id,"Journal")%>
</td>
<td></td>
<td align=center>
<input type=text size=8 name=amount<%=count_actual%>  value="" OnBlur='return calcTotal(this)' style="text-align:right">
</td>
<td><input type=text size=8 name=remarks<%=count_actual%>  value="" > </td>
</tr>
<%	}
else if ("by".equals(to_by))
	{
%>

<tr>

<input type=hidden name=srno<%=count_actual%> value=<%=count_actual%>>
<input type=hidden name=type_toby<%=count_actual%> value=by>
<td colspan=1>By </td>
<td><%=A.getArray(conp,"Ledger","account_id"+count_actual,"",company_id+"and yearend_id="+yearend_id,"Journal")%></td>
<td align=center><input type=text size=8 name=amount<%=count_actual%> OnBlur='return calcTotal(this)' style="text-align:right"></td>
<td></td>
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
<td><b>Total</b></td>
<td align=center bgcolor=#78D9FE>
<input type=text size=8 name=debit_total  readonly value="" style="background:#78D9FE" style="text-align:right">
</td>
<td align=center bgcolor=#78D9FE><input type=text size=8 name=credit_total  readonly value="" style="background:#78D9FE" style="text-align:right"></td>
<td></td>
</tr>

<tr>
<td colspan=5><hr></td>
</tr>
<tr>


<tr>
<td>Narration</td>
<td colspan=4><input type=text size=75 name=description value=<%=description%>></td>
</tr>

<tr><td colspan=5>&nbsp;</td></tr>
<tr><td colspan=5>&nbsp;</td></tr>
<tr>
<td  align=center>
<input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></td>

<td colspan=2 align=center>
Add 
<Select name=to_by>
<option value='to'>To</option>
<option value='by'>By</option>
</select>
<input type=hidden name=counter value=<%=counter%>>
<input type=hidden name=voucher_no value=<%=voucher_no%>>
<input type=hidden name=voucher_id value=<%=voucher_id%>>
<input type=hidden name=old_currency value=<%=old_currency%>>
<input type=hidden name=oldex_rate value=<%=oldex_rate%>>
<input type=hidden name=orignal_toby value=<%=orignal_toby%>>

<input type=submit name=command value='Add'
onClick='return confirm("Do You want to ADD ?")' class='button1'>
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
	 //out.print("<br>orignal_toby"+orignal_toby);
// out.print("<br>count_actual"+count_actual);



C.returnConnection(conp);
}//try
catch(Exception Samyak444){ 
out.println("<br><font color=red> FileName : Journal.jsp Bug No Samyak444 : "+ Samyak444);
}

}//if ADD

/*************************Update Jenral ************************
***************************Start Here **************************
****************************************************************/
if("Save".equals(command))
{
try{ 

 int orignal_toby= Integer.parseInt(request.getParameter("orignal_toby"));
out.print("<br>orignal_toby"+orignal_toby);
String voucher_no=""+request.getParameter("voucher_no");
String from_india=""+request.getParameter("from_india");
//out.print("<br>voucher_no"+voucher_no);
 String ref_no=""+request.getParameter("ref_no");

 double total= Double.parseDouble(request.getParameter("credit_total"));
//out.print("<br>Total"+total);
double debit_total= Double.parseDouble(request.getParameter("debit_total"));
 String type="7";
query="";
out.print("<br>type:"+type);
if(total==debit_total)
{
 //out.print("<br>11:"+total);
double exchange_rate= Double.parseDouble(request.getParameter("exchange_rate"));
out.print("<br>12exrate:"+exchange_rate);

String voucher_id=request.getParameter("voucher_id");
//out.print("<br>voucher_id"+voucher_id);

int v_old=Integer.parseInt(voucher_id);
//out.print("<br>v_old"+v_old);

int v_id=0;
String noquery="Select * from  Voucher where Company_Id=? and Voucher_No=?";
//out.print("<br>94 query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no); 
rs_g = pstmt_p.executeQuery();
out.print("<br>94 query fired" +query);
int no_exist=0;
while(rs_g.next()) 	
{
v_id=rs_g.getInt("voucher_id");
if (rs_g.wasNull())
{v_id=0;}
no_exist++;}
pstmt_p.close();

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


//out.print("<br>507 voucher_id"+voucher_id);
//out.print("<br>v_id"+v_id);

String datevalue=""+request.getParameter("datevalue");
java.sql.Date date_value=format.getDate(datevalue);

String currency= request.getParameter("currency");
String description= request.getParameter("description");
//String to_by=""+request.getParameter("to_by");
//out.println("to_by is "+to_by);
int count_actual= Integer.parseInt(request.getParameter("counter"));
int counter=count_actual;
out.println("79 counter is "+counter);
boolean voucher_currency=false;
double localamt=0;
double dollaramt=0;
//out.println("<br><font color=red>currency</font>:"+currency);

if ("local".equals(currency))
{
	if(exchange_rate==0)
	{
		localamt=total;
		dollaramt= 0;
	}
	else
	{
		localamt=total;
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
String for_ledgertype[]=new String[counter];

boolean mode[]=new boolean[counter];
String ft_id[]=new String[counter];
 //out.println("<br>count_actual"+count_actual);
for (int i=0;i<count_actual;i++)
{
//srno[i]=""+request.getParameter("srno"+i);
//out.print("srno"+i+" "+srno[i]);
type_toby[i]=""+request.getParameter("type_toby"+i);
account_id[i]=""+request.getParameter("account_id"+i);
String amountTemp=request.getParameter("amount"+i);
	//out.print("<br>amount["+i+"]"+amountTemp);
amount[i]=Double.parseDouble(amountTemp); 
remarks[i]=""+request.getParameter("remarks"+i); 
ft_id[i]=""+request.getParameter("ft_id"+i);
	//out.print("<br>ft_id["+i+"]"+ft_id[i]);
}

 //out.println("Outside for 123 --");
// type_stoby[counter]=to_by;
//out.println("<br><font color=red>v_type="+type+"</font>");
//out.print("<br>583 count_actual"+count_actual);

for (int i=0;i<count_actual;i++)
{
//out.println("<br>srno"+i+":"+srno[i]);
//out.println("<font color=red>type_toby"+i+":</font>"+type_toby[i]);
//out.println(",account_id"+i+":"+account_id[i]);
//out.println(",amount"+i+":"+amount[i]);
//out.println(",remarks"+i+":"+remarks[i]);
//out.println(",ft_id"+i+":"+ft_id[i]);
ledger_id[i]=account_id[i];
//out.print("Query1");







//JOURNAL
	
query="Select * from Ledger where Ledger_id="+account_id[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
for_head[i]=rs_g.getString("For_Head");
for_headid[i]=rs_g.getString("For_HeadId");
ledger_type[i]=rs_g.getString("Ledger_type");
for_ledgertype[i]=ledger_type[i];

ledger_id[i]=account_id[i];

}
pstmt_p.close();
mode[i]=false;
if("to".equals(type_toby[i]))
	{mode[i]=true;}

// For JOURNAL End Here 

//out.println("<br><font color=blue>for_head="+for_head[i]);
//out.println("<br>for_headid="+for_headid[i]+"</font>");
//out.println("<br>ledger_id="+ledger_id[i]+"</font>");
if ("local".equals(currency))
	{
	if(exchange_rate==0)
		{
		local_amount[i]=amount[i];
		dollar_amount[i]= 0;
		}
	else
		{
		local_amount[i]=amount[i];
		dollar_amount[i]= local_amount[i]/exchange_rate;
		}
	}
else
	{
	dollar_amount[i]=amount[i];
	local_amount[i]= dollar_amount[i]*exchange_rate;
	}
//out.print("<br> 637 --");
}

//out.print("<br> for 155 --");


//out.println("<br>669 voucher_id="+voucher_id);

if("7".equals(type))
{
//out.print("<br>639 Inside Jenral Voucher ");

String old_currency=request.getParameter("old_currency");
//out.print("<br>old_currency"+old_currency);
	//out.print("<br>Inside 7 ");

double oldex_rate= Double.parseDouble(request.getParameter("oldex_rate"));

out.print("<br>647 Inside 7oldex_rate-> "+oldex_rate);
//out.print("<br>Counter"+counter);
int old_ledgerid[]=new int[count_actual];
int temp_ledgerid[]=new int[count_actual];
double  old_amount[]=new double[count_actual];
double oldlocal_amount[]=new double[counter];
double olddollar_amount[]=new double[counter];
//out.print("<br><br>");

for (int i=0;i<(orignal_toby);i++)
{
	out.print("<br> 674 Inside For "+i);
String tempold_ledgerid=request.getParameter("old_ledgerid"+i);
out.print("<BR> 676 old_ledgerid"+ request.getParameter("old_ledgerid"+i));
old_ledgerid[i]=Integer.parseInt(request.getParameter("old_ledgerid"+i));
out.print("<BR>678 old_ledgerid"+ request.getParameter("old_amount"+i));
out.print("<br>old_ledgerid["+i+"]"+old_ledgerid[i]);
old_amount[i]=Double.parseDouble(request.getParameter("old_amount"+i));
out.print("<br>old_amount["+i+"]"+old_amount[i]);
temp_ledgerid[i]=Integer.parseInt(ledger_id[i]);
if ("local".equals(old_currency))
	{
		if(oldex_rate==0)
		{
			oldlocal_amount[i]=old_amount[i];
			olddollar_amount[i]= 0;
		}
		else
		{
			oldlocal_amount[i]=old_amount[i];
			olddollar_amount[i]= oldlocal_amount[i]/oldex_rate;
		}
	}
else
	{
	olddollar_amount[i]=old_amount[i];
	oldlocal_amount[i]= olddollar_amount[i]*oldex_rate;
	}
	//out.print("<br>olddollar_amount[i] "+ olddollar_amount[i]);
	//out.print("<br>oldlocal_amount[i] "+ oldlocal_amount[i]);

//out.print("<br><br>");
}
String oldfor_head[]=new String[count_actual];
String oldfor_headid[]=new String[count_actual];
String oldledger_type[]=new String[count_actual];
//out.print("***");
for (int i=0;i<count_actual;i++)
{
query="Select * from Ledger where Ledger_id="+old_ledgerid[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
oldfor_head[i]=rs_g.getString("For_Head");
oldfor_headid[i]=rs_g.getString("For_HeadId");
oldledger_type[i]=rs_g.getString("Ledger_type");

}
pstmt_p.close();
out.print("<Br> 723" );
}

String pn_accountid= A.getNameCondition(conp,"Master_Account","account_id","Where Account_Name='PN Account' and Company_id="+company_id+" ");
//out.print("<br>pn_accountid"+pn_accountid);
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
 // out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +a691+" voucher_id "+voucher_id);
pstmt_p.close();
//int tranasaction_id= L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
 //out.print("<br>orignal_toby"+orignal_toby);
// out.print("<br>count_actual"+count_actual);


// out.print("<br>123orignal_toby"+orignal_toby);
 //out.print("<br>456count_actual"+count_actual);


for (int i=0;i< orignal_toby;i++)
{
//out.print("<br>==============i=>"+i);
if(temp_ledgerid[i]==old_ledgerid[i])
	{
	//out.print("***"+i);

query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+date_value+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);	
//out.print("ft_id[i]"+ft_id[i]);

	}
else{
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
//out.print("ft_id[i]"+ft_id[i]);

}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
 int a749 = pstmt_p.executeUpdate();
 //out.println(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();

out.println("<br> 825");

if("14".equals(for_head[i]))
	{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
// out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");

advpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
advpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");

}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
// sign changed of operation on 24/05/04 by Samyak113 after dissussion with  Samyak114
	//Start Samyak113 
	{
	advsale_localbalance= advsale_localbalance - oldlocal_amount[i] + local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance - olddollar_amount[i] + dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance + oldlocal_amount[i] - local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance + olddollar_amount[i] - dollar_amount[i];
	}
	//End Samyak113 
}

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance= advpurchase_localbalance + oldlocal_amount[i] - local_amount[i];
	advpurchase_dollarbalance= advpurchase_dollarbalance + olddollar_amount[i] - dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance= advpurchase_localbalance - oldlocal_amount[i] + local_amount[i];
	advpurchase_dollarbalance= advpurchase_dollarbalance - olddollar_amount[i] + dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];
String pn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);
errLine="900";


if(mode[i])

	{
out.print("<br>904Samyak");
advpn_localbalance = advpn_localbalance + oldlocal_amount[i] - local_amount[i];
advpn_dollarbalance= advpn_dollarbalance + olddollar_amount[i] - dollar_amount[i];
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,(amount[i]*-1));		
pstmt_p.setDouble (5,(local_amount[i]*-1));		
pstmt_p.setDouble (6,(dollar_amount[i]*-1));		
pstmt_p.setDouble (7,exchange_rate);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,""+voucher_id);
pstmt_p.setString (11,pn_id);		
 int a322 = pstmt_p.executeUpdate();
 out.println(" <BR>921<font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
		out.print("<br>929 else");
	advpn_localbalance= advpn_localbalance - oldlocal_amount[i] + local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance - olddollar_amount[i] + dollar_amount[i];
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,(amount[i]*1));		
pstmt_p.setDouble (5,(local_amount[i]*1));		
pstmt_p.setDouble (6,(dollar_amount[i]*1));		
pstmt_p.setDouble(7,exchange_rate);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,""+voucher_id);
pstmt_p.setString (11,pn_id);	
errLine="949";

 int a322 = pstmt_p.executeUpdate();
 //out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}


}//if  "3".equals(ledger_type[i])

out.print("<br>955");
query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setDouble (5,advpn_localbalance);
pstmt_p.setDouble (6,advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);

//out.print("<brr> 895 ++++");
errLine="971";

int a870 = pstmt_p.executeUpdate();
// out.println("<font color=Red> 895Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();




	}//if for_head=14




}//if--temp_ledgerid[i]==old_ledgerid[i]

else{
out.print("<br>982");

if((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])!=14))
	{
out.print("<br>986 else");
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
//pstmt_p.setString(7,""+mode[i]);
pstmt_p.setBoolean(7,mode[i]);

pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
//out.println("<br >ft_id[i]"+ft_id[i]);
out.print("<br >1011machine_name "+machine_name);
errLine="1020";

int a749 = pstmt_p.executeUpdate();
out.println(" <BR>1013<font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");

advpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
advpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance + oldlocal_amount[i] ;
	advsale_dollarbalance= advsale_dollarbalance + olddollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance - oldlocal_amount[i] ;
	advsale_dollarbalance= advsale_dollarbalance - olddollar_amount[i] ;
	}
}

if ("2".equals(ledger_type[i]))
	{                                                                       
	if(mode[i])
	{
	advpurchase_localbalance= advpurchase_localbalance + oldlocal_amount[i] ;
	advpurchase_dollarbalance= advpurchase_dollarbalance + olddollar_amount[i] ;
	}
	else
	{
	advpurchase_localbalance= advpurchase_localbalance - oldlocal_amount[i] ;
	advpurchase_dollarbalance= advpurchase_dollarbalance - olddollar_amount[i] ;
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];
String pn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);


if(mode[i])
	{
advpn_localbalance = advpn_localbalance - oldlocal_amount[i] ;
advpn_dollarbalance= advpn_dollarbalance - olddollar_amount[i] ;
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,0);		
pstmt_p.setDouble (5,0);		
pstmt_p.setDouble (6,0);		
pstmt_p.setDouble (7,0);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,pn_id);	
errLine="1106";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance + oldlocal_amount[i] ;
	advpn_dollarbalance= advpn_dollarbalance + olddollar_amount[i] ;
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,0);		
pstmt_p.setDouble (5,0);		
pstmt_p.setDouble (6,0);		
pstmt_p.setDouble (7,0);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,pn_id);	
errLine="1132";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}


}//if 


query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setDouble (5,advpn_localbalance);
pstmt_p.setDouble (6,advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
//out.print("<brr> 1067 ++++");
errLine="1153";

int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


}//if((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])!=14))

else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])!=14))
	{
out.print("<br>1148  else if");
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
errLine="1190";

int a749 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();


	}//else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])!=14))


else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])==14))
	{
out.print("<br>1184  else if");
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+date_value+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);		

	}
else{
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
//pstmt_p.setString(7,""+mode[i]);
pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
errLine="1248";

int a749 = pstmt_p.executeUpdate();
out.println(" <BR>1230<font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();



query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");
advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit


if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance-local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance-dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance+local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance+dollar_amount[i];
	}
}//if 

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance=advpurchase_localbalance-local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance-dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance=advpurchase_localbalance+local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance+dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];

	if(mode[i])
	{
advpn_localbalance=advpn_localbalance-local_amount[i];
advpn_dollarbalance=advpn_dollarbalance-dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*-1));		
pstmt_p.setDouble (6,(local_amount[i]*-1));		
pstmt_p.setDouble (7,(dollar_amount[i]*-1));		
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Payment");		
pstmt_p.setString (10,"0");	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (17,yearend_id);
//out.print("<br >22 "+machine_name);
errLine="1349";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance+local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance+dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*1));		
pstmt_p.setDouble (6,(local_amount[i]*1));		
pstmt_p.setDouble (7,(dollar_amount[i]*1));		
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Receipt");		
pstmt_p.setString (10,"0");	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (17,yearend_id);
//out.print("<br >22 "+machine_name);
errLine="1390";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
 

	}

	}//if

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setDouble (5,advpn_localbalance);
pstmt_p.setDouble (6,advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
//out.print("<brr> 1312 ++++");
errLine="1411";

int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red>1310 Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


	}//else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])==14))


else{

query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+date_value+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setDouble (8,amount[i]);	
pstmt_p.setDouble (9,local_amount[i]);	
pstmt_p.setDouble (10,dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);		

	}
else{
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
}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
errLine="1467";

int a749 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();


query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+oldfor_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double oadvsale_localbalance=0;
double oadvsale_dollarbalance=0;
double oadvpurchase_localbalance=0;
double oadvpurchase_dollarbalance=0;
double oadvpn_localbalance=0;
double oadvpn_dollarbalance=0;

while(rs_g.next()) 	
{
oadvpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
oadvsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
oadvpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");

oadvpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
oadvsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
oadvpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(oldledger_type[i]))
	{
	if(mode[i])
	{
	oadvsale_localbalance= oadvsale_localbalance + oldlocal_amount[i] ;
	oadvsale_dollarbalance= oadvsale_dollarbalance + olddollar_amount[i];
	}
	else
	{
	oadvsale_localbalance= oadvsale_localbalance - oldlocal_amount[i] ;
	oadvsale_dollarbalance= oadvsale_dollarbalance - olddollar_amount[i] ;
	}
}

if ("2".equals(oldledger_type[i]))
	{
	if(mode[i])
	{
	oadvpurchase_localbalance= oadvpurchase_localbalance + oldlocal_amount[i] ;
	oadvpurchase_dollarbalance= oadvpurchase_dollarbalance + olddollar_amount[i] ;
	}
	else
	{
	oadvpurchase_localbalance= oadvpurchase_localbalance - oldlocal_amount[i] ;
	oadvpurchase_dollarbalance= oadvpurchase_dollarbalance - olddollar_amount[i] ;
	}
	}//if 

if ("3".equals(oldledger_type[i]))
	{
String oparty_id=oldfor_headid[i];
String opn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);


if(mode[i])
	{
oadvpn_localbalance = oadvpn_localbalance + oldlocal_amount[i] ;
oadvpn_dollarbalance= oadvpn_dollarbalance + olddollar_amount[i] ;

query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+oparty_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,0);		
pstmt_p.setDouble (5,0);		
pstmt_p.setDouble (6,0);		
pstmt_p.setDouble (7,0);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,opn_id);	
errLine="1554";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();


	}
	else
	{
	oadvpn_localbalance= oadvpn_localbalance - oldlocal_amount[i] ;
	oadvpn_dollarbalance= oadvpn_dollarbalance - olddollar_amount[i] ;

query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+date_value+"', Payment_Date='"+date_value+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+oparty_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setDouble (4,0);		
pstmt_p.setDouble (5,0);		
pstmt_p.setDouble (6,0);		
pstmt_p.setDouble (7,0);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,opn_id);		
errLine="1581";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();


}






}//if 


query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,oadvsale_localbalance);
pstmt_p.setDouble (2,oadvsale_dollarbalance);
pstmt_p.setDouble (3,oadvpurchase_localbalance);
pstmt_p.setDouble (4,oadvpurchase_dollarbalance);
pstmt_p.setDouble (5,oadvpn_localbalance);
pstmt_p.setDouble (6,oadvpn_dollarbalance);
pstmt_p.setString(7,oldfor_headid[i]);
//out.print("<brr> 1498 ++++");
errLine="1608";

int a1123 = pstmt_p.executeUpdate();
//out.println("<font color=Red>1494 Master Company Party Updated  Successfully:a1123 " +a1123+"</font>");
pstmt_p.close();



query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");

advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");
advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit


if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance-local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance-dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance+local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance+dollar_amount[i];
	}
}//if 

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance=advpurchase_localbalance-local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance-dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance=advpurchase_localbalance+local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance+dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];

	if(mode[i])
	{
advpn_localbalance=advpn_localbalance-local_amount[i];
advpn_dollarbalance=advpn_dollarbalance-dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*-1));		
pstmt_p.setDouble (6,(local_amount[i]*-1));		
pstmt_p.setDouble (7,(dollar_amount[i]*-1));		
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Payment");		
pstmt_p.setString (10,"0");	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (17,yearend_id);
//out.print("<br >22 "+machine_name);
errLine="1710";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance+local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance+dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*1));		
pstmt_p.setDouble (6,(local_amount[i]*1));		
pstmt_p.setDouble (7,(dollar_amount[i]*1));		
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Receipt");		
pstmt_p.setString (10,"0");	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (17,yearend_id);
//out.print("<br >22 "+machine_name);
errLine="1751";

int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();


	}

	}//if

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setDouble (5,advpn_localbalance);
pstmt_p.setDouble (6,advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
//out.print("<brr> 1654 ++++");
errLine="1772";

int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red>1649 Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


}//else if ((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])==14))



}//else i.e. Not (temp_ledgerid[i]==old_ledgerid[i])

//out.print("<br>==============i=>"+i);

}//for

//************************************************************************
int tranasaction_id= L.get_master_id(conp,"Financial_Transaction");
 //out.println("<br>150 tranasaction_id="+tranasaction_id);

 //out.print("<br>123orignal_toby"+orignal_toby);
 //out.print("<br>456count_actual"+count_actual);
 
 
for (int i=orignal_toby;i<count_actual;i++)
{
	//out.print("Inside For ");
//tranasaction_id=tranasaction_id+1;
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+date_value+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+(tranasaction_id));		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+voucher_id);		
pstmt_p.setString(4,""+(i+1));
if(("14".equals(for_head[i]))&&("3".equals(for_ledgertype[i])))
	{
pstmt_p.setString (5,"1");
pstmt_p.setString (6,pn_accountid);
pstmt_p.setString (7,remarks[i]);
pstmt_p.setBoolean(8,mode[i]);
pstmt_p.setDouble (9,amount[i]);	
pstmt_p.setDouble (10,local_amount[i]);	
pstmt_p.setDouble (11,dollar_amount[i]);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	

	}
else{
pstmt_p.setString (5,for_head[i]);
pstmt_p.setString (6,for_headid[i]);
pstmt_p.setString (7,remarks[i]);
pstmt_p.setBoolean(8,mode[i]);
pstmt_p.setDouble (9,amount[i]);	
pstmt_p.setDouble (10,local_amount[i]);	
pstmt_p.setDouble (11,dollar_amount[i]);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,account_id[i]);	

}
pstmt_p.setString (15,yearend_id);
//out.println("<br >machine_name "+machine_name);
errLine="1840";

int a749 = pstmt_p.executeUpdate();
// out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +a749);
pstmt_p.close();

tranasaction_id++;
}//for



for (int i=orignal_toby;i<count_actual;i++)
{
	if("14".equals(for_head[i]))
	{
query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
	advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");

advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");

advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");
advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit


if ("1".equals(for_ledgertype[i]))
	{
	if(mode[i]) 
	// sign changed of operation on 24/05/04 by Samyak113 after dissussion with  Samyak114
	//Start Samyak113 
	{
advsale_localbalance= advsale_localbalance+local_amount[i];
advsale_dollarbalance= advsale_dollarbalance+dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance-local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance-dollar_amount[i];
	}
	//End Samyak113
}//if 

if ("2".equals(for_ledgertype[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance=advpurchase_localbalance-local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance-dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance=advpurchase_localbalance+local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance+dollar_amount[i];
	}
	}//if 

if ("3".equals(for_ledgertype[i]))
	{
String party_id=for_headid[i];

	if(mode[i])
	{
advpn_localbalance=advpn_localbalance-local_amount[i];
advpn_dollarbalance=advpn_dollarbalance-dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.println("<br >1 "+pn_id);
pstmt_p.setString (2,""+company_id);		
//out.println("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.println("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*-1));		
//out.print("<br>amount"+(amount[i]*-1));
pstmt_p.setDouble (6,(local_amount[i]*-1));		
//out.print("<br>amount"+(local_amount[i]*-1));
pstmt_p.setDouble (7,(dollar_amount[i]*-1));
//out.print("<br>amount"+(dollar_amount[i]*-1));
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Payment");		
pstmt_p.setString (10,""+1);	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
// out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
// out.print("<br >21"+machine_name);
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (17,yearend_id);
// out.print("<br >21"+voucher_id);

//out.print("<br >22 "+machine_name);
//out.print("<br>1829***********");
errLine="1960";

int a322 = pstmt_p.executeUpdate();
// out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance+local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance+dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+date_value+"','"+date_value+"',?,?, ?,?,?,?, ?,?,?, '"+D+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setDouble (5,(amount[i]*1));		
pstmt_p.setDouble (6,(local_amount[i]*1));		
pstmt_p.setDouble (7,(dollar_amount[i]*1));		
pstmt_p.setDouble (8,exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Receipt");		
pstmt_p.setString (10,"0");	
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
pstmt_p.setString (11,yearend_id);
//out.print("<br >22 "+machine_name);
//out.print("<br>1868*****");
errLine="2002";

int a322 = pstmt_p.executeUpdate();
// out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();


	}
}//if 


query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setDouble (5,advpn_localbalance);
pstmt_p.setDouble (6,advpn_dollarbalance);
pstmt_p.setString (7,""+for_headid[i]);
//out.print("<brr> 1885 ++++");
errLine="2023";

int a870 = pstmt_p.executeUpdate();
// out.println("<font color=Red>1880 Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();



}//if 
}//for 

//*************************************************************************


}//If Voucher Type=7

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
	response.sendRedirect("../Report/DayBook_New.jsp?command=Next&bydate=Invoice_Date&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
}//if
else
{
	response.sendRedirect("EditVouchers.jsp?command=edit&&message=Voucher "+voucher_no+" Updated Successfully");

}//else
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
%>
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<%
out.print("<br><center><font class='star1'>Debit And Credit Total Should Be Equal</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

}
catch(Exception Samyak444){
	conp.rollback();
out.println("<br><font color=red> FileName : UpdateVoucher.jsp Bug No Samyak444 errLine="+errLine+" bug is "+ Samyak444);
}
}//if Update
%>






