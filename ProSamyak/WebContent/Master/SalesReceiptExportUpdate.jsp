<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

String command  = request.getParameter("command");
String category  = request.getParameter("category");

String errLine="22";	
ResultSet rs_g= null;
Connection conp = null;
Connection cong = null;
//Connection conm = null;
Connection conp1 = null;
Connection conp2 = null;
	
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
	
conp=C.getConnection();
cong=C.getConnection();
conp1=C.getConnection();
conp2=C.getConnection();

if("Save".equals(command))
{
	conp.setAutoCommit(false);
	conp1.setAutoCommit(false);
	errLine="42";
%>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<%
	String account_id1=""+request.getParameter("account_id");
	//out.print("<br>account_id1->"+account_id1);

String Transaction_Currency_Bank=A.getNameCondition(cong,"Master_Account","Transaction_Currency"," Where Account_Id= " + account_id1 );
//out.print("<br>Transaction_Currency_Bank->"+Transaction_Currency_Bank);
System.out.println("Transaction_Currency_Bank="+Transaction_Currency_Bank);
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
errLine="63";
String currency= request.getParameter("currency");
double ex_diff=Double.parseDouble(request.getParameter("ex_diff"));
String ex_diff_ledger=request.getParameter("ex_diff_ledger");
//out.print("<br>14currency:->"+currency);
boolean currency_check_flag=true;
if(Bank_Currency.equals(currency))
{
	currency_check_flag=true;
}
else
{
	currency_check_flag=false;
}

//out.print("<br>currency_check_flag"+currency_check_flag);
currency_check_flag=true; //to remove the currency lock
errLine="80";
if(currency_check_flag == true )
{
	//-----------------

try{
	
String query="";
String receipt_no= request.getParameter("receipt_no");
//out.print("<br>87 receipt_no="+receipt_no);
String ref_no= request.getParameter("ref_no");
String ledger_id= request.getParameter("ledger_id");
//out.println("receipt_no isledger_id"+ledger_id+" "+receipt_no);
String for_headid=A.getName(cong,"Ledger", "For_HeadId", "Ledger_id", ledger_id);
String party_id= request.getParameter("party_id");
String party_name=request.getParameter("party_name");
errLine="95";
//out.println("for_headid is"+for_headid);
String description= request.getParameter("description");
//out.print("<br>description:"+description);
String datevalue= request.getParameter("datevalue");
//out.print("<br>datevalue:"+datevalue);
double amount= Double.parseDouble(request.getParameter("amount"));

errLine="102";
double expense_amt1= Double.parseDouble(request.getParameter("less_payment_local"));//less_payment_local
System.out.println("103expense_amt1="+expense_amt1);
errLine="104";
double expense_amt2= Double.parseDouble(request.getParameter("bank_charges"));//bank_charges

System.out.println(" 107 expense_amt2="+expense_amt2);

double total= Double.parseDouble(request.getParameter("credit_total"));
total= Double.parseDouble(request.getParameter("payment_received_bank"));

double income_amt=0;//Double.parseDouble(request.getParameter("income_amt"));
//out.print("<br>11:"+amount);
out.println("total="+total);
amount=total;
String less_payment_rs_ledger=""+request.getParameter("less_payment_rs_ledger");
double exchange_rate= Double.parseDouble(request.getParameter("receive_dollar_ex_rate"));
//out.print("<br>12exrate:"+exchange_rate);
String account_id= request.getParameter("account_id");
String expense_id1= request.getParameter("less_payment_rs_ledger");//less_payment_rs_ledger
//out.println("expense_id1"+expense_id1);
String expense_id2= request.getParameter("bank_charges_ledger");//bank_charges_ledger
String income_id=""; request.getParameter("income_id");
//out.print("<br>:15"+account_id);
String type= "8";
//out.print("<br>type:"+type);
String payment_mode= "ChequeDD" ; 
System.out.println("payment_mode="+payment_mode);
errLine="125";
String temp_for_head="";
String temp_for_headid="";
if("0".equals(account_id))
{
	payment_mode= "Cash" ;
}
boolean flag_paymentmode=true;
if ("Cash".equals(payment_mode))
{
	flag_paymentmode=false;
//	out.print("<br>83payment_mode:"+payment_mode);
}
errLine="137";
boolean flag_type=true;
//out.print("<br>flag_type:"+flag_type);
//String currency= request.getParameter("currency");
//out.print("<br>14currency:"+currency);
double localamt=0;
double dollaramt=0;
double local_tot=0;
double dollar_tot=0;
double local_exp1=0;
double dollar_exp1=0;
double local_exp2=0;
double dollar_exp2=0;
double local_ex_diff=0;
double dollar_ex_diff=0;
double local_income=0;
double dollar_income=0;

boolean voucher_currency=false;

/*if ("local".equals(currency))
{*/
     localamt=amount;
	 System.out.println("148 localamt="+localamt);
	 dollaramt= localamt/exchange_rate;
 	 amount=dollaramt;
	 
	 local_tot=total;
	 dollar_tot=local_tot/exchange_rate;
	 total=dollar_tot;

	 local_exp1=expense_amt1;
	 dollar_exp1=local_exp1/exchange_rate;
	 expense_amt1=dollar_exp1;
	 
	 local_exp2=expense_amt2;
	 dollar_exp2=local_exp2/exchange_rate;
	 expense_amt2=dollar_exp2;

	 local_ex_diff=ex_diff;
	 dollar_ex_diff=local_ex_diff/exchange_rate;
	 ex_diff=dollar_ex_diff;

	 local_income=income_amt;
	 dollar_income=local_income/exchange_rate;
     
	 voucher_currency=false;
/*}*/
/*else
{
	 dollaramt=amount;
	 localamt= dollaramt*exchange_rate;
	 System.out.println("163 localamt="+localamt);
	 
	 dollar_tot=total;
 	 local_tot=dollar_tot*exchange_rate;
	 dollar_exp1=expense_amt1;
	 local_exp1=dollar_exp1*exchange_rate;
	 dollar_exp2=expense_amt2;
	 local_exp2=dollar_exp2*exchange_rate;
	 dollar_income=income_amt;
	 local_income=dollar_income*exchange_rate;
	 voucher_currency=false;
}*/
errLine="186";
out.println("total="+total);
out.println("local_tot="+local_tot);
out.println("dollar_tot="+dollar_tot);
int counter= Integer.parseInt(request.getParameter("counter"));
errLine="188";
//out.println("<font color=navy>counter is </font>"+counter);
String receive[]=new String[counter];
String receive_id[]=new String[counter];
String receive_fromid[]=new String[counter];
String recd_amt[]=new String[counter];
String pl_amt[]=new String[counter];
String pd_amt[]=new String[counter];
double receive_amount[]=new double[counter];
double pending_local[]=new double[counter];
double pending_dollar[]=new double[counter];
boolean proactive[]=new boolean[counter];
String Receive_Currency[]=new String[counter];
//out.print("Line:199");
int status=0; 
for (int i=0;i<(counter-1);i++)
{
proactive[i]=false;
receive[i]=""+request.getParameter("receive"+i);
if("yes".equals(receive[i]))
{
	status++;
}
errLine="211";
//out.print("<BR>162receive="+receive[i]);
receive_id[i]=""+request.getParameter("receive_id"+i);
System.out.println("218 receive_id[i]="+receive_id[i]);
receive_fromid[i]=""+request.getParameter("receive_fromid"+i);
recd_amt[i]=request.getParameter("receive_amount"+i);
errLine="217";
//out.print("<br>166");
pl_amt[i]=request.getParameter("pending_local"+i);
System.out.println("228 pl_amt[i]="+pl_amt[i]);
pd_amt[i]=request.getParameter("pending_dollar"+i);
System.out.println("232 pd_amt[i]="+pd_amt[i]);
//out.print("<br>169pl_amt[i]="+pl_amt[i]);
//out.print("<br>169pd_amt[i]="+pd_amt[i]);
errLine="225";
out.println("recd_amt["+i+"]="+recd_amt[i]);
if("".equals(recd_amt[i]))
{
	receive_amount[i]=0;
}
else
{
	receive_amount[i]=Double.parseDouble(recd_amt[i]);
	System.out.println("239 receive_amount[i]="+receive_amount[i]);
}
//out.print("<br>176");
errLine="236";
if("".equals(pl_amt[i]))
{
	pending_local[i]=0;
}
else
{
	pending_local[i]=Double.parseDouble(pl_amt[i]);
	System.out.println("247 pending_local[i]="+pending_local[i]);
}
errLine="246";
//out.print("<br>181");
if("".equals(pd_amt[i]))
{   
	pending_dollar[i]=0; 
}
else
{ 
	pending_dollar[i]=Double.parseDouble(pd_amt[i]); 
}

Receive_Currency[i]=request.getParameter("Receive_Currency"+i);

} //for
//out.println("<br><B>188status=</b>"+status);
errLine="259";
if(status > 0)
{
String for_head="9";
int voucher_id= L.get_master_id(cong,"Voucher","voucher_id");
int refvoucher_id=voucher_id;
String v_no="1";
if(voucher_id >1)
{
int v_id=voucher_id-1;
query="Select * from  Voucher where Voucher_Id=?";
//out.print("<br>94 query" +query);
//out.print("Line:248");
pstmt_p = cong.prepareStatement(query);
pstmt_p.setString(1,""+v_id); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
while(rs_g.next()) 	
{
	v_no=rs_g.getString("Voucher_No");}
}
pstmt_p.close();
String noquery="Select * from  Voucher where Company_Id=? and Voucher_No=?";
//out.print("<br>94 query" +query);
System.out.println("270  noquery="+noquery);
pstmt_p = cong.prepareStatement(noquery);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,receipt_no); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
int no_exist=0;
while(rs_g.next()) 	
{no_exist++;}
pstmt_p.close();



if(no_exist > 0)
{
%>
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">

<%
		C.returnConnection(conp);
		C.returnConnection(conp1);
		C.returnConnection(conp2);
		C.returnConnection(cong);
		out.print("<br><center><font class='star1'>Voucher No <font color=blue>&nbsp;"+receipt_no+ " &nbsp;</font>already exist.</font> </center>");
		out.print("<br><center><font class='star1'>Last Voucher No  is <font color=blue> &nbsp;"+v_no+ "&nbsp;<font>.</font> </center>");
		out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else
{

//out.println("<br>669 voucher_id="+voucher_id);
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+D+"',?,?,?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+voucher_id);		
//out.print("<br >1 "+voucher_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);		
//out.print("<br >2 :0");
pstmt_p.setString (5,"2");
//out.print("<br >5 2");
pstmt_p.setBoolean (6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,total);	
out.println("total="+total);
pstmt_p.setDouble (9,local_tot);	
out.println("local_tot="+local_tot);
pstmt_p.setDouble (10,dollar_tot);
out.println("dollar_tot="+dollar_tot);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,yearend_id);	
pstmt_p.setString (15,ref_no);	
//out.print("<br >machine_name "+machine_name);
int a691 = pstmt_p.executeUpdate();

System.out.println("328  a691="+a691);


//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +a691);
pstmt_p.close();
temp_for_head=for_head;
temp_for_headid=for_headid;

int tranasaction_id= L.get_master_id(cong,"Financial_Transaction");
System.out.println("<br>350 tranasaction_id="+tranasaction_id);

query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranasaction_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+voucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"1");
pstmt_p.setDouble (9,amount);	
pstmt_p.setDouble (10,localamt);	
pstmt_p.setDouble (11,dollaramt);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,ledger_id);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int a209 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +a209);
pstmt_p.close();
System.out.println("363  a209="+a209);
for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

 tranasaction_id += 1 ; //""+L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName,Ledger_Id,Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+format.getDate(datevalue)+"',?)";
//out.print("Line:351");
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranasaction_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+voucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);

pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"0");
pstmt_p.setDouble (9,amount);	
pstmt_p.setDouble (10,localamt);	
pstmt_p.setDouble (11,dollaramt);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int a242 = pstmt_p.executeUpdate();
//System.out.println("408  a242="+a242);
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +a242);
pstmt_p.close();
int exvoucher_id=voucher_id+1;
System.out.println("411  expense_amt1="+expense_amt1);
int tranas_id=tranasaction_id+1;
//int tranas_id= L.get_master_id(cong,"Financial_Transaction");
//out.println("expense_id1"+expense_id1);
if (expense_amt1>0)
{
	//String exvoucher_id=""+L.get_master_id(cong,"Voucher");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName, Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+D+"',?,?,?,?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+exvoucher_id);		
//out.print("<br >1 "+exvoucher_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);		
//out.print("<br >2 :0");
pstmt_p.setString (5,"2");
//out.print("<br >5 2");
pstmt_p.setBoolean (6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,expense_amt1);	
pstmt_p.setDouble (9,local_exp1);	
pstmt_p.setDouble (10,dollar_exp1);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+refvoucher_id);	
pstmt_p.setString (15,yearend_id);	
pstmt_p.setString (16,ref_no);	
//out.print("<br >machine_name "+machine_name);
int aexp = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +aexp);
//System.out.println("442  aexp="+aexp);
pstmt_p.close();
System.out.println("451 aexp="+aexp);
//int tranas_id= L.get_master_id(cong,"Financial_Transaction");
//out.println("expense_id1"+expense_id1);
String exp_headid= A.getName(cong,"Ledger","For_HeadId","Ledger_Id",expense_id1);
//out.println("<br>150 tranasaction_id="+tranasaction_id);
System.out.println("456 exp_headid="+exp_headid);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);

pstmt_p.setString(2,company_id); 

pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"13");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean (8,false);
pstmt_p.setDouble (9,expense_amt1);	
pstmt_p.setDouble (10,local_exp1);	
pstmt_p.setDouble (11,dollar_exp1);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,expense_id1);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
System.out.println("482 exp_headid="+exp_headid);
/*
out.println(tranas_id+"<Br>");
out.println(company_id+"<Br>");
out.println(exvoucher_id+"<Br>");
out.println(exp_headid+"<Br>");
out.println(description+"<Br>");
out.println(tranas_id+"<Br>");
out.println(tranas_id+"<Br>");
*/
int aft1 = pstmt_p.executeUpdate();

//System.out.println("471  aft1="+aft1);
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();
System.out.println("497 exp_headid="+exp_headid);
for_head="1";
if("0".equals(account_id))
{
	for_head="4";
}
for_headid=account_id;

 tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
//System.out.println("Line:481");
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+format.getDate(datevalue)+"',?)";
out.print("Line:456");
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,temp_for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,temp_for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"1");
pstmt_p.setDouble (9,expense_amt1);	
pstmt_p.setDouble (10,local_exp1);	
pstmt_p.setDouble (11,dollar_exp1);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,ledger_id);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
System.out.println("532");
//System.out.println("507 aft2="+aft2);
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();
exvoucher_id=exvoucher_id+1;
tranas_id=tranas_id+1;
}//expense_amt1
//System.out.println("525 expense_amt2="+expense_amt2);



if(expense_amt2 > 0)
{
//System.out.println("537 Inside loop");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName, Referance_VoucherId,YearEnd_Id,Ref_No )values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+D+"',?,?,?,?)";
out.print("Line:488");
//out.print("<BR>90" +query);
pstmt_p = conp1.prepareStatement(query);
pstmt_p.setString (1,""+exvoucher_id);		
//out.print("<br >1 "+exvoucher_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);		
//out.print("<br >2 :0");
pstmt_p.setString (5,"2");
//out.print("<br >5 2");
pstmt_p.setBoolean (6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,expense_amt2);	
pstmt_p.setDouble (9,local_exp2);	
pstmt_p.setDouble (10,dollar_exp2);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+refvoucher_id);	
pstmt_p.setString (15,yearend_id);	
pstmt_p.setString (16,ref_no);	
//out.print("<br >machine_name "+machine_name);
int aexp = pstmt_p.executeUpdate();
//System.out.println("541 aexp="+aexp);
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +aexp);
pstmt_p.close();
System.out.println("572 exp_headid=");
//System.out.println("Line:545");
//int tranas_id= L.get_master_id(conp1,"Financial_Transaction");
String exp_headid= A.getName(cong,"Ledger","For_HeadId","Ledger_Id",expense_id2);
System.out.println("578");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?,'"+format.getDate(datevalue)+"',?)";
//out.print("<BR>90" +query);
pstmt_p = conp1.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
System.out.println("<br >1 tranas_id"+tranas_id);
pstmt_p.setString(2,company_id); 
System.out.println("<br >1  company_id"+company_id);
pstmt_p.setString(3,""+exvoucher_id);		
System.out.println("<br >1 exvoucher_id"+exvoucher_id);
pstmt_p.setString(4,"1");
System.out.println("<br >1 "+"1");
pstmt_p.setString (5,"13");
System.out.println("<br >1 "+"13");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
System.out.println("<br >1 "+exp_headid);
pstmt_p.setString (7,description);
System.out.println("<br >1 "+description);
pstmt_p.setString (8,"0");
pstmt_p.setDouble (9,expense_amt2);	
System.out.println("<br >1 "+expense_amt2);
pstmt_p.setDouble (10,local_exp2);	
System.out.println("<br >1 "+local_exp2);
pstmt_p.setDouble (11,dollar_exp2);
System.out.println("<br >1 "+dollar_exp2);
pstmt_p.setString (12,user_id);
System.out.println("<br >1 "+user_id);
pstmt_p.setString (13,machine_name);
System.out.println("<br >1 "+machine_name);
pstmt_p.setString (14,expense_id2);	
System.out.println("<br >1 "+expense_id2);
pstmt_p.setString (15,yearend_id);	
System.out.println("<br >1 "+yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();
System.out.println("605");
for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

 tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp1.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,temp_for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,temp_for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"1");
pstmt_p.setDouble (9,expense_amt2);	
pstmt_p.setDouble (10,local_exp2);	
pstmt_p.setDouble (11,dollar_exp2);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,ledger_id);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();
System.out.println("639");
exvoucher_id=exvoucher_id+1;
tranas_id=tranas_id+1;
}//expense_amt2
//System.out.println("625 income_amt="+income_amt);

/**** For Exchange Diff Ledger  ****/
//if (ex_diff>0)
//{
//String exvoucher_id=""+L.get_master_id(cong,"Voucher");
/*query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName, Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+D+"',?,?,?,?)";
*/
//out.print("<BR>90" +query);
/*pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+exvoucher_id);	*/	
//out.print("<br >1 "+exvoucher_id);
/*pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);*/		
//out.print("<br >2 :0");
//pstmt_p.setString (5,"2");
//out.print("<br >5 2");
/*pstmt_p.setBoolean (6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,ex_diff);	
pstmt_p.setDouble (9,local_ex_diff);	
pstmt_p.setDouble (10,dollar_ex_diff);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+refvoucher_id);	
pstmt_p.setString (15,yearend_id);	
pstmt_p.setString (16,ref_no);*/	
//out.print("<br >machine_name "+machine_name);
//int aexp = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +aexp);
//System.out.println("442  aexp="+aexp);
//pstmt_p.close();
//System.out.println("451 aexp="+aexp);
//int tranas_id= L.get_master_id(cong,"Financial_Transaction");
//out.println("expense_id1"+expense_id1);
//String exp_headid= A.getName(cong,"Ledger","For_HeadId","Ledger_Id",ex_diff_ledger);
//out.println("<br>150 tranasaction_id="+tranasaction_id);
//System.out.println("456 exp_headid="+exp_headid);
/*query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?,'"+format.getDate(datevalue)+"',?)";*/

//out.print("<BR>90" +query);
/*pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);

pstmt_p.setString(2,company_id); 

pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"13");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean (8,false);
pstmt_p.setDouble (9,ex_diff);	
pstmt_p.setDouble (10,local_ex_diff);	
pstmt_p.setDouble (11,dollar_ex_diff);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,expense_id1);	
pstmt_p.setString (15,yearend_id);	*/
//out.print("<br >machine_name "+machine_name);
//System.out.println("482 exp_headid="+exp_headid);
/*
out.println(tranas_id+"<Br>");
out.println(company_id+"<Br>");
out.println(exvoucher_id+"<Br>");
out.println(exp_headid+"<Br>");
out.println(description+"<Br>");
out.println(tranas_id+"<Br>");
out.println(tranas_id+"<Br>");
*/
//int aft1 = pstmt_p.executeUpdate();

//System.out.println("471  aft1="+aft1);
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
//pstmt_p.close();
//System.out.println("497 exp_headid="+exp_headid);
//for_head="1";
//if("0".equals(account_id))
//{
//	for_head="4";
//}
//for_headid=account_id;

 //tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
//System.out.println("Line:481");
//query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+format.getDate(datevalue)+"',?)";
/*out.print("Line:456");
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,temp_for_head);*/
//out.print("<br >3 "+for_head[i]);
/*pstmt_p.setString (6,temp_for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"1");
pstmt_p.setDouble (9,ex_diff);	
pstmt_p.setDouble (10,local_ex_diff);	
pstmt_p.setDouble (11,dollar_ex_diff);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,ledger_id);	
pstmt_p.setString (15,yearend_id);*/
//out.print("<br >machine_name "+machine_name);
//int aft2 = pstmt_p.executeUpdate();
//System.out.println("532");
//System.out.println("507 aft2="+aft2);
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
//pstmt_p.close();
//exvoucher_id=exvoucher_id+1;
//tranas_id=tranas_id+1;
//}//expense_amt1
/**** End For Exchange Diff Ledger ****/

/*if(income_amt > 0)
{
//String exvoucher_id=""+ L.get_master_id(cong,"Voucher");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName, Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+D+"',?,?,?,?)";
out.print("Line:586");
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+exvoucher_id);		
//out.print("<br >1 "+exvoucher_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);		
//out.print("<br >2 :0");
pstmt_p.setString (5,"2");
//out.print("<br >5 2");
pstmt_p.setBoolean (6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,income_amt);	
pstmt_p.setDouble (9,local_income);	
pstmt_p.setDouble (10,dollar_income);
//out.print("<br> 543 income_amt "+income_amt);
//out.print("<br> 543 local_income "+local_income);
//out.print("<br> 543 dollar_income "+dollar_income);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+refvoucher_id);	
pstmt_p.setString (15,yearend_id);	
pstmt_p.setString (16,ref_no);	
//out.print("<br >machine_name "+machine_name);
int ain = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +ain);
pstmt_p.close();

//int tranas_id= L.get_master_id(cong,"Financial_Transaction");
String exp_headid= A.getName(cong,"Ledger","For_HeadId","Ledger_Id",income_id);
//out.println("<br>150 tranasaction_id="+tranasaction_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"12");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"1");
pstmt_p.setDouble (9,income_amt);	
pstmt_p.setDouble (10,local_income);	
pstmt_p.setDouble (11,dollar_income);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,income_id);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();
//out.print("Line:645");
for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;
//out.print("Line:650");
 tranas_id+=1;
 
 //tranas_id11 += 1 ; //""+L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id )values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+D+"',?,?, '"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setString (8,"0");
pstmt_p.setDouble (9,income_amt);	
pstmt_p.setDouble (10,local_income);	
pstmt_p.setDouble (11,dollar_income);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	
pstmt_p.setString (15,yearend_id);	
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();
exvoucher_id=exvoucher_id+1;
tranas_id=tranas_id+1;
}//income_amt
*/
/*out.print("<br>588");
 out.print("<br>amt =" +amount);
 out.print("<br>localamt =" +localamt);
 out.print("<br>dollaramt =" +dollaramt);
 out.print("<br>total =" +total);
 out.print("<br>local_tot =" +local_tot);
 out.print("<br>dollar_tot =" +dollar_tot);
 out.print("<br>expense_amt1 =" +expense_amt1);
 out.print("<br>local_exp1 =" +local_exp1);
 out.print("<br>dollar_exp1 =" +dollar_exp1);
 out.print("<br>expense_amt2 =" +expense_amt2);
 out.print("<br>local_exp2 =" +local_exp2);
 out.print("<br>dollar_exp2 =" +dollar_exp2);
 out.print("<br>income_amt =" +income_amt);
 out.print("<br>local_income =" +local_income);
 out.print("<br>dollar_income =" +dollar_income);
*/

double rlocalamt=0;
double rdollaramt=0;
int k=0;
int payment_id=L.get_master_id(cong,"Payment_Details");
for_head="9";
//out.print("<br >638payment_id: "+payment_id);

for(int i=0; i<(counter-1); i++)
{
if ("yes".equals(receive[i]))
{

//out.print("<br >278payment_id: "+payment_id);
 rlocalamt=0;
 rdollaramt=0;
//payment_id = payment_id+k;
//k= k+1;
//------------------------Proactive-----------------------
if(Receive_Currency[i].equals("0"))
	{
		if ("local".equals(currency))
		{
		//	out.print("<br> 655 Dollar Invoice local Entry");
			rdollaramt=receive_amount[i]/exchange_rate;
			rlocalamt=receive_amount[i];
			double dollar_entered = receive_amount[i]/exchange_rate;
			if(pending_dollar[i]<=dollar_entered)
			{
				proactive[i]=true;
			}
		}
		else
		{
		//	out.print("<br> 659 Dollar Invoice dollar Entry");
			rdollaramt=receive_amount[i];
			rlocalamt=receive_amount[i]*exchange_rate;

			if(pending_dollar[i]<=receive_amount[i])
			{
				proactive[i]=true;
			}
		}
	}
else
	{
		if ("local".equals(currency))
		{
		//	out.print("<br> 666 Local Invoice local Entry");
			rdollaramt=receive_amount[i]/exchange_rate;
			rlocalamt=receive_amount[i];
			if(pending_local[i]<=receive_amount[i])
			{
				proactive[i]=true;
			}
		}
		else
		{
		//	out.print("<br> 670 Local Invoice dollar Entry");
			rdollaramt=receive_amount[i];
			rlocalamt=receive_amount[i]*exchange_rate;
			double local_entered = receive_amount[i]*exchange_rate;
			if(pending_local[i]<=local_entered)
			{
				proactive[i]=true;
			}
		}
	}
	//		out.print("<br> 700 rdollaramt="+rdollaramt);
	//		out.print("<br> 701 rlocalamt="+rlocalamt);

//------------------------Proactive-----------------------

/*
if ("local".equals(currency))
{
	if(receive_amount[i]==pending_local[i])
	{proactive[i]=true;}
	rlocalamt=receive_amount[i];
	rdollaramt= rlocalamt/exchange_rate;
	}
else
	{
	if(receive_amount[i]==pending_dollar[i])
	{proactive[i]=true;}
	rdollaramt=receive_amount[i];
	rlocalamt=rdollaramt*exchange_rate;
	}
*/
System.out.println("853");
query="Insert into Payment_Details (Payment_Id, voucher_id, Company_Id, Payment_No, For_Head, For_HeadId, Transaction_Type, Transaction_Date, Payment_Mode, Amount, Local_Amount, Dollar_Amount, Exchange_Rate, Modified_By, Modified_On, Modified_MachineName,YearEnd_Id)values (?,?,?,?, ?,?,?,'"+format.getDate(datevalue)+"', ?,?,?,?,  ?,?,'"+D+"',?,?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+(payment_id+k));		
//out.print("<br ><b>payment_id: "+payment_id+"</b>");
pstmt_p.setString (2,""+voucher_id);		
pstmt_p.setString (3,company_id);		
pstmt_p.setString (4,receipt_no);		
pstmt_p.setString (5,for_head);		
pstmt_p.setString (6,receive_id[i]);
//out.print("<BR>299");
boolean b=false;
pstmt_p.setBoolean (7,b);
pstmt_p.setBoolean (8,flag_paymentmode);
pstmt_p.setDouble (9,receive_amount[i]);	
//out.print("<BR>303");
pstmt_p.setDouble (10,rlocalamt);	
pstmt_p.setDouble (11,rdollaramt);
pstmt_p.setString (12,""+exchange_rate);
//out.print("<BR>306");
pstmt_p.setString (13,user_id);	
pstmt_p.setString (14,machine_name);	
pstmt_p.setString (15,yearend_id);	
//out.print("<br>machine_name "+machine_name);
int a305 = pstmt_p.executeUpdate();
//out.println(" <BR>177 <font color=navy> Payment_Details Updated Successfully: ?</font>" +a305);
pstmt_p.close();
k++;
}// yes receive[i]
}//for

if ("yes".equals(receive[counter-1]))
{

if ("local".equals(currency))
	{
	rlocalamt=receive_amount[counter-1];
	rdollaramt= rlocalamt/exchange_rate;
	rlocalamt +=pending_local[counter-1];
	rdollaramt+=pending_dollar[counter-1];
	}
else
	{
	rdollaramt=receive_amount[counter-1];
	rlocalamt=rdollaramt*exchange_rate;
	rlocalamt +=pending_local[counter-1];
	rdollaramt+=pending_dollar[counter-1];

	}
//			out.print("<br> 770 rdollaramt="+rdollaramt);
//			out.print("<br> 771 rlocalamt="+rlocalamt);
query="Update Master_companyparty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=? where companyparty_id="+party_id+"";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,rlocalamt);	
pstmt_p.setDouble (2,rdollaramt);
int a727 = pstmt_p.executeUpdate();
pstmt_p.close();
}

for(int i=0; i<(counter-1); i++)
{
query="Update Receive set ProActive=? where Receive_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean (1,proactive[i]);
pstmt_p.setString (2,receive_id[i]);
int a692 = pstmt_p.executeUpdate();
pstmt_p.close();
}//for 

conp.commit();
conp1.commit();
C.returnConnection(cong);
C.returnConnection(conp);
C.returnConnection(conp1);
C.returnConnection(conp2);
//response.sendRedirect("../Finance/SalesReceipt1.jsp?command=Default&message=Sales Receipt Voucher '<font color=blue>"+receipt_no+"</font>' Saved Successfully&changedate="+datevalue+"");

%>

<html>
<title>Samyak Software</title>
<script >
function CloseWindow()
{
	alert("Data Saved Successfully");
	<%  //C.returnConnection(conp); %>
	window.close();
	
}
</script>
<body bgcolor=ffffee onLoad='CloseWindow()' >

	<%
		response.sendRedirect("../Master/SaleReceiptExport.jsp?command=Default&isParty=1&changedate=none&category=Receive&party_name="+party_name+
				"&message="+receipt_no+" Saved Successfully");
	%>
<% 
}//else  assetno_exist > 0 
}//if status
else
{


   	C.returnConnection(conp);
	C.returnConnection(cong);
	C.returnConnection(conp1);
	C.returnConnection(conp2);


%>

<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">

<%
out.print("<br><center><font class='star1'>Please Select The Sale To Be Settled</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}
	//C.returnConnection(conp);
//	C.returnConnection(cong);
}catch(Exception Samyak284){ 
	conp.rollback();
	C.returnConnection(conp);
	C.returnConnection(conp1);
	C.returnConnection(conp2);
out.println("<br><font class='star1'><h2> FileName : ReceiptUpdate.jsp <br>Bug No Samyak284 :"+ Samyak284 +" errLine="+errLine+"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}//catch Samyak284

}//end currency_check_flag==true
else
{

	C.returnConnection(conp);
	C.returnConnection(cong);
	C.returnConnection(conp1);
	C.returnConnection(conp2);
	
 out.println("<body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Bank Currency Should Be Same as Transction Currency</b><br><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");

}//end else

	//C.returnConnection(conp);
	//C.returnConnection(cong);
	//C.returnConnection(conp1);
	//C.returnConnection(conp2);

}//if save

%>






