<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<% 
	String errLine="9";
	ResultSet rs_g= null;
	Connection conp = null;
 	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
  try	{
		 conp=C.getConnection();
 		}catch(Exception Samyak38){ 
out.println("<font color=red> FileName : BankTransactionUpdate.jsp <br>Bug No Samyak38 :"+ Samyak38 +"</font>");} 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int dd1=D.getDate();
int mm1=D.getMonth()+1;
int yy1=D.getYear()+1900;

int dd2=D.getDate();
int mm2=D.getMonth()+1;
int yy2=D.getYear()+1900;

//out.println("Today's Date is "+D);
String today_string= format.format(D);

//out.print("<br>today_string=" +today_string);
String command  = request.getParameter("command");
//out.print("<br>command=" +command);
String category  = request.getParameter("category");
//out.print("<br>category=" +category);

	
//out.print("<br>Inside UPdate");

if("Update".equals(command))
{

try{

conp.setAutoCommit(false);

String query="";
String receipt_no= request.getParameter("voucher_no");
String ref_no=""+request.getParameter("ref_no");
String from_india=""+request.getParameter("from_india");
String datevalue= request.getParameter("datevalue");
out.print("<br>datevalue:"+datevalue);

String ledger_id= request.getParameter("ledger_id");
//out.println("receipt_no is="+receipt_no+",ledger_id"+ledger_id);
String for_headid=A.getName(conp,"Ledger", "For_HeadId", "Ledger_id", ledger_id);

String party_id=for_headid; //request.getParameter("party_id");

//out.println("for_headid is"+for_headid);
//String voucher_id=request.getParameter("voucher_id");

String description= request.getParameter("description");
//out.print("<br>description:"+description);

String account_id= request.getParameter("account_id");

String Transaction_Currency_Bank=A.getNameCondition(conp,"Master_Account","Transaction_Currency"," Where Account_Id= " + account_id );
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
//out.print("<br>14currency:"+currency);
boolean currency_check_flag=true;

if(Bank_Currency.equals(currency))
{
	currency_check_flag=true;
}
else
{
	currency_check_flag=false;
}
errLine="101";
//out.print("<br>currency_check_flag"+currency_check_flag);
//lock for currecny removed Chanchal 24062006
currency_check_flag=true;
//

if(currency_check_flag == true )
{

double amount= Double.parseDouble(request.getParameter("amount"));
double expense_amt1= Double.parseDouble(request.getParameter("expense_amt1"));
double expense_amt2= Double.parseDouble(request.getParameter("expense_amt2"));

//out.print("<br> 904 expense_amt1"+expense_amt1);

double total= Double.parseDouble(request.getParameter("credit_total"));
double income_amt= Double.parseDouble(request.getParameter("income_amt"));
//out.print("<br>11:"+amount);
double exchange_rate= Double.parseDouble(request.getParameter("exchange_rate"));
//out.print("<br>12exrate:"+exchange_rate);

String expense_id1= request.getParameter("expense_id1");
//out.print("<br>");
String expense_id2= request.getParameter("expense_id2");
String income_id= request.getParameter("income_id");
//out.print("<br>:15"+account_id);
String type= "9";
//out.print("<br>type:"+type);
String payment_mode= "ChequeDD" ; 
if("0".equals(account_id))
	{payment_mode= "Cash" ;}
boolean flag_paymentmode=true;
	if ("Cash".equals(payment_mode))
	{ flag_paymentmode=false;
//	out.print("<br>83payment_mode:"+payment_mode);

	}
boolean flag_type=true;
//out.print("<br>flag_type:"+flag_type);
double localamt=0;
double dollaramt=0;
double local_tot=0;
double dollar_tot=0;
double local_exp1=0;
double dollar_exp1=0;
double local_exp2=0;
double dollar_exp2=0;
double local_income=0;
double dollar_income=0;

boolean voucher_currency=false;

if ("local".equals(currency))
	{
     localamt=amount;
	 dollaramt= localamt/exchange_rate;
 	 local_tot=total;
	 dollar_tot=local_tot/exchange_rate;
	 local_exp1=expense_amt1;
	 dollar_exp1=local_exp1/exchange_rate;
	 local_exp2=expense_amt2;
	 dollar_exp2=local_exp2/exchange_rate;
	 local_income=income_amt;
	 dollar_income=local_income/exchange_rate;
     voucher_currency=true;
	}
else
	{
	 dollaramt=amount;
	 localamt= dollaramt*exchange_rate;
	 dollar_tot=total;
 	 local_tot=dollar_tot*exchange_rate;
	 dollar_exp1=expense_amt1;
	 local_exp1=dollar_exp1*exchange_rate;
	 dollar_exp2=expense_amt2;
	 local_exp2=dollar_exp2*exchange_rate;
	 dollar_income=income_amt;
	 local_income=dollar_income*exchange_rate;
	 voucher_currency=false;
	}
/*out.print("<br>126");
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
errLine="198";
int counter= Integer.parseInt(request.getParameter("counter"));
//out.println("<br><font color=navy>counter is </font>"+counter);
String receive[]=new String[counter];
String payment_id[]=new String[counter];
String pdfor_headid[]=new String[counter];
String receive_id[]=new String[counter];
String recd_amt[]=new String[counter];
String pl_amt[]=new String[counter];
String pd_amt[]=new String[counter];
double receive_amount[]=new double[counter];
double pending_local[]=new double[counter];
double pending_dollar[]=new double[counter];
boolean proactive[]=new boolean[counter];
String Receive_Currency[]=new String[counter];

int status=0; 
for (int i=0;i<counter;i++)
{
proactive[i]=false;
receive[i]=""+request.getParameter("receive"+i);
recd_amt[i]="0";

if("yes".equals(receive[i]))
	{status++;
recd_amt[i]=request.getParameter("receive_amount"+i);
}
//out.print("<BR>162receive="+receive[i]);
receive_id[i]=""+request.getParameter("receive_id"+i);
payment_id[i]=""+request.getParameter("payment_id"+i);
pdfor_headid[i]=""+request.getParameter("pdfor_headid"+i);
//out.print("<br>166");
pl_amt[i]=request.getParameter("pending_local"+i);
pd_amt[i]=request.getParameter("pending_dollar"+i);
//out.print("<br>169pl_amt[i]="+pl_amt[i]);
//out.print("<br>169pd_amt[i]="+pd_amt[i]);
if("".equals(recd_amt[i]))
	{receive_amount[i]=0;}
else{
	receive_amount[i]=Double.parseDouble(recd_amt[i]);
	//out.print("221  <br> receive_amount[i]"+receive_amount[i]);
}
//out.print("<br>176");
if("".equals(pl_amt[i]))
	{pending_local[i]=0;}
else{
	pending_local[i]=Double.parseDouble(pl_amt[i]);
}
//out.print("<br>181");
if("".equals(pd_amt[i]))
	{pending_dollar[i]=0;}
else{
	pending_dollar[i]=Double.parseDouble(pd_amt[i]);
}
Receive_Currency[i]=request.getParameter("Receive_Currency"+i);

}



//out.println("<br><B>188status=</b>"+status);
String voucher_id=request.getParameter("voucher_id");
int v_old=Integer.parseInt(voucher_id);
//out.print("<br>203v_old="+v_old);

if(status > 0)
{
String for_head="9";
 
int v_id=0;
String noquery="Select * from  Voucher where Company_Id=? and Voucher_No=? and Referance_VoucherId=0";
//out.print("<br>94 query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,receipt_no); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
int no_exist=0;
while(rs_g.next()) 	
{
v_id=rs_g.getInt("voucher_id");
if (rs_g.wasNull())
{v_id=0;}
no_exist++;}
pstmt_p.close();
//out.print("<br>221 v_id=" +v_id);
if((no_exist > 0)&&(v_id != v_old))
{C.returnConnection(conp);

	%>

<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<%
out.print("<br><center><font class='star1'>Voucher No "+receipt_no+ " already exist.</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else
	{
errLine="300";
/**Start catchng  various voucher_id and ft_id**/
int ft_id0= Integer.parseInt(request.getParameter("ft_id0"));
int ft_id1= Integer.parseInt(request.getParameter("ft_id1"));
int expv_id1= Integer.parseInt(request.getParameter("expv_id1"));
int expft_id1= Integer.parseInt(request.getParameter("expft_id1"));
int expv_id2= Integer.parseInt(request.getParameter("expv_id2"));
int expft_id2= Integer.parseInt(request.getParameter("expft_id2"));
int idft_id= Integer.parseInt(request.getParameter("idft_id"));
int indv_id= Integer.parseInt(request.getParameter("indv_id"));
//out.print("<font color=blue><br>256");
// out.print("<br>ft_id0 =" +ft_id0);
// out.print("<br>ft_id1 =" +ft_id1);
// out.print("<br>expv_id1 =" +expv_id1);
// out.print("<br>expft_id1 =" +expft_id1);
// out.print("<br>expv_id2 =" +expv_id2);
// out.print("<br>expft_id2 =" +expft_id2);
// out.print("<br>idft_id =" +idft_id);
// out.print("<br>indv_id =" +indv_id);


// out.print("<br>expense_id1="+expense_id1);
//out.print("<br>expense_id2="+expense_id2);
//out.print("<br>income_id="+income_id);

// out.print("<br></font>");



/**End catchng  various voucher_id and ft_id**/



//out.println("<br>669 voucher_id="+voucher_id);
//conp=C.getConnection();

query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?,Voucher_Currency=?,Ref_No=? where Voucher_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,receipt_no);		
pstmt_p.setString (2,""+exchange_rate);
pstmt_p.setDouble (3,total);	
pstmt_p.setDouble (4,local_tot);	
pstmt_p.setDouble (5,dollar_tot);
pstmt_p.setString (6,description);
pstmt_p.setString (7,user_id);	
pstmt_p.setString (8,machine_name);	
pstmt_p.setBoolean (9,voucher_currency);	
pstmt_p.setString(10,ref_no);

pstmt_p.setString (11,""+voucher_id);		
//out.print("<br >9 "+voucher_id);
//out.print("<br >machine_name "+machine_name);
int a691 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +a691);
pstmt_p.close();

//out.print("<br> 334");


query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString(1,"1");		
pstmt_p.setString (2,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (3,for_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,false);
pstmt_p.setDouble (6,amount);	
pstmt_p.setDouble (7,localamt);	
pstmt_p.setDouble (8,dollaramt);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,ledger_id);
pstmt_p.setString (12,""+ft_id1);		

//out.print("<br > ft_id0"+ft_id1);
int a209 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +a209);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

//out.print("<br> 366");


query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString(1,"1");		
pstmt_p.setString (2,for_head);
//out.print("<br >3 "+for_head[i]);
errLine="400";
pstmt_p.setString (3,for_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,true);
pstmt_p.setDouble (6,amount);	
pstmt_p.setDouble (7,localamt);	
pstmt_p.setDouble (8,dollaramt);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,"0");
pstmt_p.setString (12,""+ft_id0);		
//out.print("<br >347ft_id1 "+ft_id0);
int a242 = pstmt_p.executeUpdate();
//out.println(" <BR>349<font color=navy>Updated FT2 Successfully: ?</font>" +a242);
pstmt_p.close();

//out.print("<br> 392");

if ((expense_amt1>0)&&(expv_id1==0))
{
String exvoucher_id=""+L.get_master_id(conp,"Voucher");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName,Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";

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
pstmt_p.setBoolean(6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,expense_amt1);	
pstmt_p.setDouble (9,local_exp1);	
pstmt_p.setDouble (10,dollar_exp1);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+voucher_id);	
pstmt_p.setString(15,yearend_id);
pstmt_p.setString(16,ref_no);

//out.print("<br >machine_name "+machine_name);
int aexp = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +aexp);
pstmt_p.close();

int tranas_id= L.get_master_id(conp,"Financial_Transaction");
String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",expense_id1);

query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"13");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,false);
pstmt_p.setDouble (9,expense_amt1);	
pstmt_p.setDouble (10,local_exp1);	
pstmt_p.setDouble (11,dollar_exp1);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,expense_id1);	
pstmt_p.setString(15,yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

 tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?, '"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,true);
pstmt_p.setDouble (9,expense_amt1);	
errLine="500";
pstmt_p.setDouble (10,local_exp1);	
pstmt_p.setDouble (11,dollar_exp1);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	
pstmt_p.setString(15,yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();

}//expense_amt1

else if(expv_id1 > 0)
{

query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Referance_VoucherId=?,Voucher_Currency=? ,Ref_No=? where Voucher_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,receipt_no);		
pstmt_p.setString (2,""+exchange_rate);
pstmt_p.setDouble (3,expense_amt1);	
pstmt_p.setDouble (4,local_exp1);	
pstmt_p.setDouble (5,dollar_exp1);
pstmt_p.setString (6,description);
pstmt_p.setString (7,user_id);	
pstmt_p.setString (8,machine_name);	
pstmt_p.setString (9,""+voucher_id);	
pstmt_p.setBoolean (10,voucher_currency);	
pstmt_p.setString(11,ref_no);

pstmt_p.setString (12,""+expv_id1);		

//out.print("<br >machine_name "+machine_name);
int aexp = pstmt_p.executeUpdate();
//out.println(" <BR>463<font color=navy>Updated Successfully: ?</font>" +aexp);
pstmt_p.close();


 //out.print("<br>474expense_id1="+expense_id1);
//out.print("<br>expense_id2="+expense_id2);
//out.print("<br>income_id="+income_id);

String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",expense_id1);
query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

pstmt_p.setString(1,"1");		
pstmt_p.setString (2,"13");
//out.print("<br >160487 "+exp_headid);
//out.print("<br >1455expft_id1= "+expft_id1);
pstmt_p.setString (3,exp_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,false);
pstmt_p.setDouble (6,expense_amt1);	
pstmt_p.setDouble (7,local_exp1);	
pstmt_p.setDouble (8,dollar_exp1);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,expense_id1);	
 //out.print("<br><font color=blue>497expense_id1="+expense_id1);
//out.print("<br>expense_id2="+expense_id2);
//out.print("<br>income_id="+income_id+"</font>");

pstmt_p.setString (12,""+expft_id1);		
//out.print("<br >expft_id1 "+expft_id1);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR>504<font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

String tranas_id= A.getNameCondition(conp,"Financial_Transaction","Tranasaction_Id","Where Voucher_id="+expv_id1+" and transaction_type=1" );
//out.print("<br>513tranas_id="+tranas_id);
query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,"2");		
pstmt_p.setString (2,""+for_head);
//out.print("<br >520 "+for_headid);
pstmt_p.setString (3,for_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,true);
pstmt_p.setDouble (6,expense_amt1);	
pstmt_p.setDouble (7,local_exp1);	
pstmt_p.setDouble (8,dollar_exp1);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,"0");	
pstmt_p.setString (12,""+tranas_id);
errLine="600";
//out.print("<br >tranas_id= "+tranas_id);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();

}//expense_amt1

errLine="608";




if((expense_amt2 > 0)&&(expv_id2==0))
{

String exvoucher_id= ""+L.get_master_id(conp,"Voucher");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName,Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";

out.print("<BR>619 " +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+exvoucher_id);		
//out.print("<br >1 "+exvoucher_id);
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,type);		
pstmt_p.setString(4,receipt_no);		
//out.print("<br >2 :0");
pstmt_p.setString (5,"2");
//out.print("<br >5 2");
pstmt_p.setBoolean(6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,expense_amt2);	
pstmt_p.setDouble (9,local_exp2);	
pstmt_p.setDouble (10,dollar_exp2);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+voucher_id);	
pstmt_p.setString(15,yearend_id);	
pstmt_p.setString(16,ref_no);

//out.print("<br >machine_name "+machine_name);
errLine="642";
int aexp = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +a691);
pstmt_p.close();

int tranas_id= L.get_master_id(conp,"Financial_Transaction");
String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",expense_id2);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"13");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,false);
pstmt_p.setDouble (9,expense_amt2);	
pstmt_p.setDouble (10,local_exp2);	
pstmt_p.setDouble (11,dollar_exp2);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,expense_id2);	
pstmt_p.setString(15,yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

 tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?, '"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,true);
pstmt_p.setDouble (9,expense_amt2);	
pstmt_p.setDouble (10,local_exp2);	
pstmt_p.setDouble (11,dollar_exp2);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	
pstmt_p.setString(15,yearend_id);
errLine="701";
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();


}//expense_amt2



else if(expv_id2 > 0)
{

query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Referance_VoucherId=?,Voucher_Currency=?, Ref_No=? where Voucher_Id=?";

//out.print("<BR>62790" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,receipt_no);		
pstmt_p.setString (2,""+exchange_rate);
pstmt_p.setDouble (3,expense_amt2);	
pstmt_p.setDouble (4,local_exp2);	
pstmt_p.setDouble (5,dollar_exp2);
pstmt_p.setString (6,description);
pstmt_p.setString (7,user_id);	
pstmt_p.setString (8,machine_name);	
pstmt_p.setString (9,""+voucher_id);	
pstmt_p.setBoolean (10,voucher_currency);	
pstmt_p.setString(11,ref_no);
pstmt_p.setString (12,""+expv_id2);		

//out.print("<br >machine_name "+machine_name);
errLine="734";
int aexp = pstmt_p.executeUpdate();
errLine="736";
//out.println(" <BR>642<font color=navy>Updated Successfully: ?</font>" +aexp);
pstmt_p.close();



String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",expense_id2);
query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

pstmt_p.setString(1,"1");		
pstmt_p.setString (2,"13");
//out.print("<br >670 "+exp_headid);
pstmt_p.setString (3,exp_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,false);
pstmt_p.setDouble (6,expense_amt2);	
pstmt_p.setDouble (7,local_exp2);	
pstmt_p.setDouble (8,dollar_exp2);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,expense_id2);	
pstmt_p.setString (12,""+expft_id2);		
//out.print("<br >expft_id2 "+expft_id2);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

String tranas_id= A.getNameCondition(conp,"Financial_Transaction","Tranasaction_Id","Where Voucher_id="+expv_id2+" and transaction_type=1" );

query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,"2");		
pstmt_p.setString (2,""+for_head);
//out.print("<br >699 "+for_headid);
pstmt_p.setString (3,for_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,true);
pstmt_p.setDouble (6,expense_amt2);	
pstmt_p.setDouble (7,local_exp2);	
pstmt_p.setDouble (8,dollar_exp2);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,"0");	
pstmt_p.setString (12,""+tranas_id);		
//out.print("<br >tranas_id "+tranas_id);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();

}//expense_amt2




if ((income_amt >0)&&(indv_id==0))

{
errLine="802";
String exvoucher_id=""+ L.get_master_id(conp,"Voucher");
query="Insert into Voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName,Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(datevalue)+"',?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";

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
pstmt_p.setBoolean(6,voucher_currency);
pstmt_p.setString (7,""+exchange_rate);
pstmt_p.setDouble (8,income_amt);	
pstmt_p.setDouble (9,local_income);	
pstmt_p.setDouble (10,dollar_income);
pstmt_p.setString (11,description);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,""+voucher_id);	
pstmt_p.setString(15,yearend_id);	
pstmt_p.setString(16,ref_no);

//out.print("<br >machine_name "+machine_name);
int ain = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +ain);
pstmt_p.close();

int tranas_id= L.get_master_id(conp,"Financial_Transaction");
String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",income_id);
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,'"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"1");		
pstmt_p.setString (5,"12");
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,exp_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,true);
pstmt_p.setDouble (9,income_amt);	
pstmt_p.setDouble (10,local_income);	
pstmt_p.setDouble (11,dollar_income);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,income_id);	
pstmt_p.setString(15,yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft1 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

 tranas_id += 1 ; //""+L.get_master_id("Financial_Transaction");
query="Insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_id,Sr_No, For_Head, For_HeadId, Description, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_By, Modified_On, Modified_MachineName, Ledger_Id, Transaction_Date,YearEnd_Id)values (?,?,?,? ,?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?, '"+format.getDate(datevalue)+"',?)";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+tranas_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,""+exvoucher_id);		
pstmt_p.setString(4,"2");		
pstmt_p.setString (5,for_head);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (6,for_headid);
pstmt_p.setString (7,description);
pstmt_p.setBoolean(8,false);
pstmt_p.setDouble (9,income_amt);	
pstmt_p.setDouble (10,local_income);	
pstmt_p.setDouble (11,dollar_income);
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);	
pstmt_p.setString (14,"0");	
pstmt_p.setString(15,yearend_id);
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
errLine="890";
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();

}//income_amt
else if(indv_id > 0)
{

query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Referance_VoucherId=?,Ref_No=? where Voucher_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,receipt_no);		
pstmt_p.setString (2,""+exchange_rate);
pstmt_p.setDouble (3,income_amt);	
pstmt_p.setDouble (4,local_income);	
pstmt_p.setDouble (5,dollar_income);
pstmt_p.setString (6,description);
pstmt_p.setString (7,user_id);	
pstmt_p.setString (8,machine_name);	
pstmt_p.setString (9,""+voucher_id);	
pstmt_p.setString(10,ref_no);

pstmt_p.setString (11,""+indv_id);		

//out.print("<br >machine_name "+machine_name);
int aexp = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated Successfully: ?</font>" +aexp);
pstmt_p.close();



String exp_headid= A.getName(conp,"Ledger","For_HeadId","Ledger_Id",income_id);
query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

pstmt_p.setString(1,"1");		
pstmt_p.setString (2,"12");
//out.print("<br >843 "+exp_headid);
pstmt_p.setString (3,exp_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,true);
pstmt_p.setDouble (6,income_amt);	
pstmt_p.setDouble (7,local_income);	
pstmt_p.setDouble (8,dollar_income);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,income_id);	
pstmt_p.setString (12,""+idft_id);		
//out.print("<br >machine_name "+machine_name);
errLine="943";
int aft1 = pstmt_p.executeUpdate();

//out.println(" <BR><font color=navy>Updated FT Successfully: ?</font>" +aft1);
pstmt_p.close();

for_head="1";
if("0".equals(account_id))
	{for_head="4";}
for_headid=account_id;

String tranas_id= A.getNameCondition(conp,"Financial_Transaction","Tranasaction_Id","Where Voucher_id="+indv_id+" and transaction_type=0" );

//out.print("<br> 904 local_income"+local_income);

query="Update  Financial_Transaction set Sr_No=?, For_Head=? , For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,"2");		
pstmt_p.setString (2,""+for_head);
//out.print("<br >873 "+for_headid);
pstmt_p.setString (3,for_headid);
pstmt_p.setString (4,description);
pstmt_p.setBoolean(5,false);
pstmt_p.setDouble (6,income_amt);	
pstmt_p.setDouble (7,local_income);	
pstmt_p.setDouble (8,dollar_income);
pstmt_p.setString (9,user_id);	
pstmt_p.setString (10,machine_name);	
pstmt_p.setString (11,"0");	
pstmt_p.setString (12,""+tranas_id);		
//out.print("<br >machine_name "+machine_name);
int aft2 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Updated FT2 Successfully: ?</font>" +aft2);
pstmt_p.close();
errLine="979";
}//income_amt









//out.print("<br>588");
 //out.print("<br>amt =" +amount);
 //out.print("<br>localamt =" +localamt);
 //out.print("<br>dollaramt =" +dollaramt);
 //out.print("<br>total =" +total);
 //out.print("<br>local_tot =" +local_tot);
 //out.print("<br>dollar_tot =" +dollar_tot);
 //out.print("<br>expense_amt1 =" +expense_amt1);
 //out.print("<br>local_exp1 =" +local_exp1);
 //out.print("<br>dollar_exp1 =" +dollar_exp1);
 //out.print("<br>expense_amt2 =" +expense_amt2);
 //out.print("<br>local_exp2 =" +local_exp2);
 //out.print("<br>dollar_exp2 =" +dollar_exp2);
 //out.print("<br>income_amt =" +income_amt);
 //out.print("<br>local_income =" +local_income);
 //out.print("<br>900dollar_income =" +dollar_income);


for_head="10";
double rlocalamt=0;
double rdollaramt=0;
//out.print("<br>988 counter ="+counter);
for(int i=0; i<counter; i++)
{

//out.print("<br>992 I's ="+i);
//out.print("<br>993 for_head ="+for_head);
//out.print("<br>994 receive[i] ="+receive[i]);
boolean setflag;
 if("yes".equals(receive[i]))
	{
	 //out.print("<br>999 Samyak ");
	 setflag=true;
	}
	 else{
    setflag=false;
	 //out.print("<br>1004 Samyak ");
	 }

//if ("yes".equals(receive[i]))
//{
if (!("0".equals(pdfor_headid[i])))
{

 rlocalamt=0;
 rdollaramt=0;


//-------------Proactive----------------------------
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

//-------------Proactive----------------------------




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


//out.print("<br>1076pdfor_headid[i] ="+pdfor_headid[i]);
query="Update Payment_Details set  voucher_id=?, Company_Id=?, Payment_No=?, For_Head=?, For_HeadId=?, Transaction_Type=?, Transaction_Date='"+format.getDate(datevalue)+"', Payment_Mode=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Exchange_Rate=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? ,Active=? where Payment_Id=?";

//out.print("<BR>receive_amount[i]" +receive_amount[i]);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+voucher_id);		
pstmt_p.setString (2,company_id);		
pstmt_p.setString (3,receipt_no);		
pstmt_p.setString (4,for_head);		
pstmt_p.setString (5,pdfor_headid[i]);
//out.print("<BR>299");
pstmt_p.setBoolean(6,true);
pstmt_p.setBoolean(7,flag_paymentmode);
pstmt_p.setDouble (8,receive_amount[i]);	
//out.print("<BR>303");
pstmt_p.setDouble (9,rlocalamt);	
pstmt_p.setDouble (10,rdollaramt);
pstmt_p.setString (11,""+exchange_rate);
//out.print("<BR>306");
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);

pstmt_p.setBoolean (14,setflag);		






pstmt_p.setString (15,""+payment_id[i]);		
//out.print("<br>machine_name "+machine_name);
errLine="1147";
int a305 = pstmt_p.executeUpdate();
//out.println(" <BR>177 <font color=navy> Payment_Details Updated Successfully: ?</font>" +a305);
pstmt_p.close();

//}// yes receive[i]

}//end if NOT ON ACCOUNT
}//for

for(int i=0; i<counter; i++)
{

if ("0".equals(pdfor_headid[i]))
{

if ("local".equals(currency))
	{
	rlocalamt=receive_amount[i];
	rdollaramt= rlocalamt/exchange_rate;
	rlocalamt =rlocalamt- pending_local[i];
	rdollaramt=rdollaramt- pending_dollar[i];
	}
else
	{
	rdollaramt=receive_amount[i];
	rlocalamt=rdollaramt*exchange_rate;
	rlocalamt =rlocalamt- pending_local[i];
	rdollaramt=rdollaramt- pending_dollar[i];

	}
//out.print("<br>1099 rlocalamt"+rlocalamt);
//out.print("<br>1099 rdollaramt"+rdollaramt);
query="select * from Master_companyparty where companyparty_id="+party_id+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
double temp_local=0;
double temp_dollar=0;
	while(rs_g.next())
		{
temp_local= rs_g.getDouble("Purchase_AdvanceLocal");
temp_dollar= rs_g.getDouble("Purchase_AdvanceDollar");
		}
pstmt_p.close();
//out.print("<br>1099 temp_local"+temp_local);
//out.print("<br>1099 temp_dollar"+temp_dollar);
rlocalamt +=temp_local;
rdollaramt +=temp_dollar;
//out.print("<br>1099 party_id"+party_id);
//out.print("<br>1099 rlocalamt"+rlocalamt);
//out.print("<br>1099 rdollaramt"+rdollaramt);
query="Update Master_companyparty set Purchase_AdvanceLocal=?, Purchase_AdvanceDollar=? where companyparty_id="+party_id+"";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,rlocalamt);	
pstmt_p.setDouble (2,rdollaramt);
errLine="1202";
int a727 = pstmt_p.executeUpdate();
pstmt_p.close();


//------------------------------------------------------

query="Update Payment_Details set  voucher_id=?, Company_Id=?, Payment_No=?, For_Head=?, For_HeadId=?, Transaction_Type=?, Transaction_Date='"+format.getDate(datevalue)+"', Payment_Mode=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Exchange_Rate=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? where Payment_Id=?";

//out.print("<BR>receive_amount[i]" +receive_amount[i]);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+voucher_id);		
pstmt_p.setString (2,company_id);		
pstmt_p.setString (3,receipt_no);		
pstmt_p.setString (4,for_head);		
pstmt_p.setString (5,pdfor_headid[i]);
//out.print("<BR>299");
pstmt_p.setBoolean(6,true);
pstmt_p.setBoolean(7,flag_paymentmode);
if ("local".equals(currency))
	{
pstmt_p.setDouble (8,receive_amount[i]);	
pstmt_p.setDouble (9,receive_amount[i]);	
pstmt_p.setDouble (10,receive_amount[i]/exchange_rate);
    }
	else
    {
pstmt_p.setDouble (8,receive_amount[i]);	
pstmt_p.setDouble (9,receive_amount[i]*exchange_rate);
pstmt_p.setDouble (10,receive_amount[i]);
   		
	}
pstmt_p.setString (11,""+exchange_rate);
//out.print("<BR>306");
pstmt_p.setString (12,user_id);	
pstmt_p.setString (13,machine_name);
pstmt_p.setString (14,""+payment_id[i]);		
//out.print("<br>machine_name "+machine_name);
int a305 = pstmt_p.executeUpdate();
//out.println(" <BR>177 <font color=navy> Payment_Details Updated Successfully: ?</font>" +a305);
pstmt_p.close();

//---------------------------------------------------




}
	}
for(int i=0; i<counter; i++)
{
query="Update Receive set ProActive=? where Receive_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,proactive[i]);
pstmt_p.setString (2,receive_id[i]);
errLine="1258";
int a692 = pstmt_p.executeUpdate();
pstmt_p.close();

}//for 

conp.commit();
 C.returnConnection(conp);

 
%>
<html>
<title>Samyak Counsulting</title>
<script >
function CloseWindow()
	{
	alert("Data Saved Successfully");
	
	<%
//out.println("<br> 1370 ");
if("yes".equals(from_india))
{	
	response.sendRedirect("../Report/DayBook_India.jsp?command=Next&bydate=Invoice_Date&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
} //if
else
{
	response.sendRedirect("EditVouchers.jsp?command=edit&&message=Voucher "+receipt_no+" Updated Successfully");

} //else
%>
	
	window.close();
	}
</script>
<body bgcolor=ffffee onLoad='CloseWindow()' >
<%
}//else  assetno_exist > 0 
}//if status
else
{ C.returnConnection(conp);

	%>

<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">

<%
out.print("<br><center><font class='star1'>Please Select The Sale To Be Settled</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}
}

else
{
		C.returnConnection(conp);
 out.println("<body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='msgred'><b>Bank Currency Should Be Same as Transction Currency</b><br><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");

}//end else

}catch(Exception Samyak284){ conp.rollback();
C.returnConnection(conp);
out.println("<br><font class='star1'><h2> FileName : ReceiptUpdate.jsp <br>errLine is"+errLine+" No Samyak284 :"+ Samyak284 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}//catch Samyak284
}//if save

%>








