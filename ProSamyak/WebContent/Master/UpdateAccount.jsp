<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
//out.println("Inside UpdateAccount.jsp");
String command  = request.getParameter("command");
String command1   = request.getParameter("command1");
String main_account=request.getParameter("main_account");

//out.println("command1"+command1);


//System.out.println("Inside Updeate Account");
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	/*try	{
		 conp=C.getConnection();
		}catch(Exception e11){ 
		out.println("<font color=red> FileName : UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}*/
//		out.println("command is "+command);

if("SUBMIT".equals(command))
{
try{
	
	conp=C.getConnection();

//out.print("Command is "+command);
String account_name		=request.getParameter("account_name");	
String account_no		=request.getParameter("account_no");
String bank_id= request.getParameter("bank_id");
//out.print("<br>bank_id=" +bank_id);
String accounttype_id= request.getParameter("accounttype_id");
String description= request.getParameter("description");
String opening_date=request.getParameter("datevalue");
String currency=request.getParameter("currency");
String type=request.getParameter("type");

double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);
double opening_balance = Double.parseDouble(request.getParameter("opening_balance"));
//out.println("<br>102 exchange_rate is"+opening_balance);
String credit_debit=request.getParameter("credit_debit");
//out.println("Credit_Debit"+credit_debit);
if("Debit".equals(credit_debit))
{
opening_balance=0-opening_balance;
}

double opening_localbalance=0;
double opening_dollarbalance=0;
String currency_id="";
boolean currency_flag=true;
if ("dollar".equals(currency))
	{
	currency_flag=false;
	//local_currencysymbol="$";
	//currency_id="0";
	opening_dollarbalance=opening_balance;
	opening_localbalance=opening_dollarbalance*exchange_rate;
}//if
else{
	currency_flag=true;
	//currency_id=local_currencyid;
	opening_localbalance=opening_balance;
	opening_dollarbalance=opening_localbalance/exchange_rate;
}//else if dollar


String selectquery ="Select * from Master_Account where Account_number='"+account_no+"' and company_id="+company_id;
//out.println("<br>69"+selectquery);

pstmt_p = conp.prepareStatement(selectquery);
rs_g = pstmt_p.executeQuery();	
int i=0;
//out.println("<br>74 query Executed"+selectquery);
while(rs_g.next()){i++;}
pstmt_p.close();

//out.println("<br><font color=red>i=</font>"+i);
if(i==0)
{
String account_id= ""+L.get_master_id(conp,"Master_Account");
//out.println("account_id"+account_id);
String query = " INSERT INTO Master_Account ( Account_Id,Company_Id,Account_Name,Account_Number,Bank_Id, AccountType_Id ,Description, Opening_LocalBalance, Opening_DollarBalance, Opening_ExchangeRate,Opening_Date, Net_LocalBalance, Net_DollarBalance, Exchange_Rate, Modified_By, Modified_On, Modified_MachineName, Transaction_Currency,YearEnd_Id,DisplayInEntryModule) values(?,?,?,?, ?,?,?,?, ?,?,'"+format.getDate(opening_date)+"',?, ?,?,?,'"+format.getDate(today_string)+"', ?,?,?,?)";

//total columns = 17
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+ account_id);		
//out.print("<br>1 "+account_id);
pstmt_p.setString (2, company_id);	
//out.print("<br>2 "+company_id);
pstmt_p.setString (3,account_name);
//out.print("<br>3 "+account_name);
pstmt_p.setString (4, account_no);	
//out.print("<br>4 "+account_no);
pstmt_p.setString (5, bank_id);
//out.print("<br>5 "+bank_id);
pstmt_p.setString (6,accounttype_id);
//out.print("<br>6 "+accounttype_id);
pstmt_p.setString (7, description);
//out.print("<br> 7"+description);	
pstmt_p.setDouble(8,opening_localbalance);		
//out.print("<br> 7"+opening_localbalance);	
pstmt_p.setDouble (9, opening_dollarbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (10,""+ exchange_rate);
//out.print("<br> 7"+user_id);	
pstmt_p.setDouble (11, opening_localbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setDouble (12,opening_dollarbalance);	
//out.print("<br> 7"+user_id);	
pstmt_p.setString (13,""+ exchange_rate);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (14, user_id);	
//out.print("<br> 7"+user_id);	
pstmt_p.setString (15, machine_name);
pstmt_p.setBoolean(16, currency_flag);
//out.print("<br> 8"+machine_name);	
pstmt_p.setString (17,yearend_id);	
System.out.println("main_account="+main_account);
if(main_account==null)
	pstmt_p.setBoolean (18,false);	
else
	pstmt_p.setBoolean (18,true);	


int a = pstmt_p.executeUpdate();

pstmt_p.close();
C.returnConnection(conp);

//out.println("After query result a is "+a);
String temp="Account";
if("cash".equals(type))
	{temp="Cash";}
    

if("Bank_OD".equals(command1))
{
response.sendRedirect("NewAccount.jsp?command=Bank_OD&message=bank Account<font color=blue> "+account_no+" </font>successfully Added");
}
else{
response.sendRedirect("NewAccount.jsp?command=Default&message= "+temp+"<font color=blue> "+account_no+" </font>successfully Added&type="+type);

}
}
else
{
		C.returnConnection(conp);

%>
<html>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>
<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">

<center><font class='msgcolor1' >Account No <%=account_no%> already exists.<BR><input type=button name=command value='BACK' onClick='history.go(-1)' class='button1'></center>
<%
}//if end

}catch(Exception Samyak45){ 
out.println("<br><font color=red><h2> FileName : UpdateAccount.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' onClick='history.go(-1)'>");
}

}//if SUBMIT


if("UPDATE ACCOUNT".equals(command))
{
try{
	conp=C.getConnection();
String account_id= request.getParameter("account_id");
//out.println("account_id:"+account_id);
String account_name		=request.getParameter("account_name");	
//out.println("account_name:"+account_name);
String account_number		=request.getParameter("account_number");
//out.println("account_number:"+account_number);
String bankparty_id= request.getParameter("bankparty_id");
//out.println("bankparty_id:"+bankparty_id);
String accounttype_id= request.getParameter("accounttype_id");
//out.println("accounttype_id:"+accounttype_id);
String description= request.getParameter("description");
//out.println("description:"+description);
String op_date=request.getParameter("datevalue");
//out.println("op_date:"+op_date);
String currency=request.getParameter("currency");
main_account=request.getParameter("main_account");
//out.println("currency:"+currency);
double exchange_rate=Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br><br>exchange_rate:"+exchange_rate);
String active= request.getParameter("active");
//out.println("<br>active:"+active);
boolean flag =false; 
if("yes".equals(active)){flag=true;}

double opening_balance = Double.parseDouble(request.getParameter("opening_balance"));
//out.println("<br>102 exchange_rate is"+opening_balance);
String credit_debit=request.getParameter("credit_debit");
//out.println("Credit_Debit"+credit_debit);
if("Debit".equals(credit_debit))
{
opening_balance=0-opening_balance;
}

double opening_localbalance=0;
double opening_dollarbalance=0;
String currency_id="";
boolean currency_flag=true;
if ("dollar".equals(currency))
	{
	currency_flag=false;
	//local_currencysymbol="$";
	//currency_id="0";
	opening_dollarbalance=opening_balance;
	opening_localbalance=opening_dollarbalance*exchange_rate;
}//if
else{
	currency_flag=true;
	//currency_id=local_currencyid;
	opening_localbalance=opening_balance;
	opening_dollarbalance=opening_localbalance/exchange_rate;
}//else if dollar




String query ="Update Master_Account set Account_Name=?, Account_Number=?, Bank_Id=?, AccountType_Id=? ,Description=?, Opening_Date='"+format.getDate(op_date)+"', Opening_LocalBalance=?, Opening_DollarBalance=?,Exchange_Rate=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, active=?,Transaction_Currency=?,DisplayInEntryModule=? where Account_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, account_name);
//out.print("<br>1 "+account_name);
pstmt_p.setString (2,account_number);
//out.print("<br> 2 account_number "+account_number);
pstmt_p.setString (3, bankparty_id);
//out.print("<br>3 bankparty_id "+bankparty_id);
pstmt_p.setString (4,accounttype_id);
//out.print("<br>4 "+accounttype_id);
pstmt_p.setString (5,description);
//out.print("<br>5 description "+description);
pstmt_p.setDouble (6,opening_localbalance);
//out.print("<br>6 opening_localbalance "+opening_localbalance);
pstmt_p.setDouble (7,opening_dollarbalance);	
//out.print("<br> 7 opening_dollarbalance "+opening_dollarbalance);
pstmt_p.setString (8,""+exchange_rate);
//out.print("<br>8 exchange_rate "+exchange_rate);
pstmt_p.setString (9,""+D);		
//out.print("<br>9 date "+D);
pstmt_p.setString (10,user_id);
//out.print("<br>10 userid "+user_id);
pstmt_p.setString (11,machine_name);
//out.print("<br>11 machine_name "+machine_name);	
pstmt_p.setBoolean (12,flag);
//out.print("<br>12 flag "+flag);
pstmt_p.setBoolean (13,currency_flag);
//out.print("<br>13 currency_flag "+currency_flag);
if(main_account==null)
	pstmt_p.setBoolean (14,false);
else
	pstmt_p.setBoolean (14,true);
pstmt_p.setString (15,account_id);	   
//out.print("<br>14 account_id"+account_id); 	

//out.println("<font color=blue>Before Query <br>"+query+"</font>");
int a = pstmt_p.executeUpdate();
//out.println("After query result a is "+a);
pstmt_p.close();
C.returnConnection(conp);

response.sendRedirect("EditMasters.jsp?command=Default&message=Account <font color=blue> "+account_name+"  </font> successfully Updated");

}
catch(Exception e233){ 
	out.println("<br><font color=red><h2> FileName : UpdateAccount.jsp <br>Bug No e233 :"+ e233 +"</h2></font>");}
}//if UPDATE ACCOUNT*/
%>








