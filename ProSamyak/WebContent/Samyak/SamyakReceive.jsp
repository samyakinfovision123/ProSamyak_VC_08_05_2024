<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
/*try	{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}*/

try{
int current_id=0; 
int total_rows=0;


//String query="Select * from Receive where Receive_quantity=0 and Company_id=1 and Receive_fromid not like 1 and Receive_sell=0 and Purchase=1 and Active=1 and Return=0";
cong=C.getConnection();
String query="Select * from Receive  where Purchase=1 and company_id=1 and opening_stock=0 and Receive_FromId<>1 order by Receive_date ,Receive_no ";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
pstmt_g.close();
//out.println("counter is="+counter);

String receive_id[]= new String[counter];
boolean RActive[]=new boolean[counter];
String consignment_date[]= new String[counter];
String consignment_no[]= new String[counter];
String voucher_id[]= new String[counter];
String Receive_FromId[]= new String[counter];
String Ledger_Type[]= new String[counter];
String exchange_rate[]= new String[counter];
double Tax[]= new double[counter];
double Discount[]= new double[counter];
double Receive_Total[]= new double[counter];
double Local_Total[]= new double[counter];
double Dollar_Total[]= new double[counter];
double ctax_amt[]= new double[counter];
double ctax_localamt[]= new double[counter];
double ctax_dollaramt[]= new double[counter];

double dis_amt[]= new double[counter];
double dis_localamt[]= new double[counter];
double dis_dollaramt[]= new double[counter];

double invtotal[]= new double[counter];
double local_invtotal[]= new double[counter];
double dollar_invtotal[]= new double[counter];
boolean trans_type[]=new boolean[counter] ;
boolean dis_trans_type[]=new boolean[counter];
java.sql.Date recd_date[]=new java.sql.Date[counter];
int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
int reportcurrency_id=rs_g.getInt("Receive_CurrencyId");
int Receive_Sell=rs_g.getInt("Receive_Sell");
int Returned=rs_g.getInt("Return");
if((Receive_Sell==1)&&(Returned==1))//salereturn,Ledger_Type=1
	{trans_type[i]=false; Ledger_Type[i]="1"; dis_trans_type[i]=true;}
else if((Receive_Sell==1)&&(Returned==0))//purchase, Ledger_Type=2
	{trans_type[i]=false;	Ledger_Type[i]="2"; dis_trans_type[i]=true;}
else if((Receive_Sell==0)&&(Returned==1))//purchasereturn, Ledger_Type=2
	{trans_type[i]=true;Ledger_Type[i]="2";	 dis_trans_type[i]=false;}
else if((Receive_Sell==0)&&(Returned==0))//sale ,Ledger_Type=1
	{trans_type[i]=true;Ledger_Type[i]="1";	 dis_trans_type[i]=false;}
consignment_no[i]=rs_g.getString("Receive_No");
receive_id[i]=rs_g.getString("Receive_ID");
//out.print("<br> 88 receive_id[i] "+receive_id[i]);
exchange_rate[i]=rs_g.getString("Exchange_Rate");
//receive_id[i]=rs_g.getString("Receive_ID");
recd_date[i]=rs_g.getDate("Receive_Date");
//consignment_date[i]=format.format(recd_date);
Tax[i]=rs_g.getDouble("Tax");
Discount[i]=rs_g.getDouble("Discount");
Receive_Total[i]=rs_g.getDouble("Receive_Total");
Local_Total[i]=rs_g.getDouble("Local_Total");
Dollar_Total[i]=rs_g.getDouble("Dollar_Total");
Receive_FromId[i]=rs_g.getString("Receive_FromId");
RActive[i]=rs_g.getBoolean("Active");
if(reportcurrency_id==0)
{
/*	if(Tax[i]==0)
	{
ctax_amt[i]=Receive_Total[i]- str.mathformat(Receive_Total[i] /((Tax[i]/100)+1),2);
	}
	else
	{
ctax_amt[i]=Receive_Total[i]- str.mathformat(Receive_Total[i] /((Tax[i]/100)),2);
	}
	if(Discount[i]==0)
	{
dis_amt[i]=(Receive_Total[i]-ctax_amt[i])-str.mathformat((Receive_Total[i]-ctax_amt[i])/ ( (Discount[i]/100) +1) ,2);
	}
	else
	{
dis_amt[i]=(Receive_Total[i]-ctax_amt[i])-str.mathformat((Receive_Total[i]-ctax_amt[i])/ ( (Discount[i]/100) ) ,2);
	}
invtotal[i]=Receive_Total[i]-ctax_amt[i]+dis_amt[i];
*/

ctax_amt[i]=Receive_Total[i]-( Receive_Total[i] * 100 / (100 + Tax[i]));
dis_amt[i]=( Receive_Total[i] * 100 / (100 - Discount[i]))-Receive_Total[i];
invtotal[i]=Receive_Total[i]-ctax_amt[i]+dis_amt[i];





}
else{/*
ctax_amt[i]=Receive_Total[i]- str.mathformat(Receive_Total[i] /((Tax[i]/100)+1),2);
dis_amt[i]=(Receive_Total[i]-ctax_amt[i])-str.mathformat((Receive_Total[i]-ctax_amt[i])/ ( (Discount[i]/100) +1) ,2);

invtotal[i]=Receive_Total[i]-ctax_amt[i]+dis_amt[i];
*/

ctax_amt[i]=Receive_Total[i]-( Receive_Total[i] * 100 / (100 + Tax[i]));
dis_amt[i]=( Receive_Total[i] * 100 / (100 - Discount[i]))-Receive_Total[i];
invtotal[i]=Receive_Total[i]-ctax_amt[i]+dis_amt[i];



}/*
ctax_localamt[i]=Local_Total[i]- str.mathformat(Local_Total[i] /((Tax[i]/100)+1),2);
dis_localamt[i]=(Local_Total[i]-ctax_localamt[i])- str.mathformat((Local_Total[i]-ctax_localamt[i]) /((Discount[i]/100)+1),2);

local_invtotal[i]=Local_Total[i]-ctax_localamt[i]+dis_localamt[i];
*/

ctax_localamt[i]=Local_Total[i]-( Local_Total[i] * 100 / (100 + Tax[i]));
dis_localamt[i]=( Local_Total[i] * 100 / (100 - Discount[i]))-Local_Total[i];
local_invtotal[i]=Local_Total[i]-ctax_localamt[i]+dis_localamt[i];

/*
ctax_dollaramt[i]=Dollar_Total[i]- str.mathformat(Local_Total[i] /((Tax[i]/100)+1),2);
dis_dollaramt[i]=(Dollar_Total[i]-ctax_dollaramt[i])- str.mathformat((Dollar_Total[i]-ctax_dollaramt[i]) /((Discount[i]/100)+1),2);

dollar_invtotal[i]=Dollar_Total[i]-ctax_dollaramt[i]+dis_dollaramt[i];
*/

ctax_dollaramt[i]=Dollar_Total[i]-( Dollar_Total[i] * 100 / (100 + Tax[i]));
dis_dollaramt[i]=( Dollar_Total[i] * 100 / (100 - Discount[i]))-Dollar_Total[i];
dollar_invtotal[i]=Dollar_Total[i]-ctax_dollaramt[i]+dis_dollaramt[i];

//out.println("<br>counter is="+counter+" receive_id[i] "+receive_id[i]);
i=i+1;
}//while
pstmt_g.close();

//out.println("<br>110");
for( i=0;i<counter;i++)
{

query="Select * from Voucher where Voucher_no=? and company_id=1 and (Voucher_type=1 or Voucher_type=2 or Voucher_type=10 or Voucher_type=11)";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]); 
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{voucher_id[i] =rs_g.getString("voucher_id");}	
pstmt_g.close();
}//for
//out.println("<br>126");
//out.println("<br>140");
boolean flag_currency=true;
//out.println("<br>141");
int transaction_id=L.get_master_id("Financial_Transaction");
//out.println("<br>143");

for( i=0;i<counter;i++)
{
//out.println("<br>147 for");

query="Update  Voucher  set ToBy_Nos=?,Active=? where Voucher_id=? ";
//out.print("<br> i"+i+" query" +query+"receive_id[i]"+receive_id[i]);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,"0"); 
pstmt_g.setBoolean(2,RActive[i]); 

pstmt_g.setString(3,""+voucher_id[i]); 
int a135 = pstmt_g.executeUpdate();
//out.print("<br> 156 Voucher Updated");
pstmt_g.close();

query="Update  Receive  set InvTotal=?, InvLocalTotal=?, InvDollarTotal=? where Receive_ID=? ";
////out.print("<br> i"+i+" query" +query+"receive_id[i]"+receive_id[i]);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+invtotal[i]); 
pstmt_g.setString(2,""+local_invtotal[i]); 
pstmt_g.setString(3,""+dollar_invtotal[i]); 
pstmt_g.setString(4,""+receive_id[i]); 
int a308 = pstmt_g.executeUpdate();
//out.println("<br>a308"+a308);
pstmt_g.close();
//out.print("<br> 169 Receive Updated");

/*if(Tax[i]!=0)
	{*/
query="insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_Id, Sr_No, For_Head, For_HeadId, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_On, Modified_By, Modified_MachineName, Ledger_Id, Transaction_Date, Tranasaction_No, Receive_Id, ReceiveFrom_LedgerId, Exchange_Rate) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?)";
pstmt_p = cong.prepareStatement(query);

pstmt_p.setString(1,""+transaction_id);
//out.print("<br>175 transaction_id="+transaction_id);

pstmt_p.setString(2,"1");
pstmt_p.setString(3,""+voucher_id[i]);
//out.print("<br>179 voucher_id[i]="+voucher_id[i]);
pstmt_p.setString(4,"0");
pstmt_p.setString(5,"17");
pstmt_p.setString(6,"1");
//out.print("<br>183 trans_type[i]="+trans_type[i]);

pstmt_p.setBoolean(7,trans_type[i]);
//out.print("<br>186 ctax_amt[i]="+ctax_amt[i]);
//out.print("<br>187 ctax_localamt[i]="+ctax_localamt[i]);
//out.print("<br>188 ctax_dollaramt[i]="+ctax_dollaramt[i]);

pstmt_p.setString(8,""+ctax_amt[i]);
pstmt_p.setString(9,""+ctax_localamt[i]);
pstmt_p.setString(10,""+ctax_dollaramt[i]);
//out.print("<br>193 today_string="+today_string);
pstmt_p.setString(11,""+format.getDate(today_string));
pstmt_p.setString(12,"1");
pstmt_p.setString(13,"Samyak23");
pstmt_p.setString(14,"1");
//out.print("<br>198 consignment_date[i]="+recd_date[i]);
//out.print("<br>199 consignment_no[i]="+consignment_no[i]);
pstmt_p.setString(15,""+recd_date[i]);
pstmt_p.setString(16,""+consignment_no[i]);
pstmt_p.setString(17,""+receive_id[i]);
//out.print("<br>201 receive_id[i]="+receive_id[i]);

String ReceiveFrom_LedgerId= A.getNameCondition("Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+Receive_FromId[i]+" and Ledger_Type="+Ledger_Type[i]+"");
//out.print("<br>204 ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);
pstmt_p.setString(18,""+ReceiveFrom_LedgerId);
//out.print("<br>206 exchange_rate[i]="+exchange_rate[i]);
pstmt_p.setString(19,""+exchange_rate[i]);
//out.print("<br>208 Financial Transaction "+exchange_rate[i]);
int a572 = pstmt_p.executeUpdate();
//out.println(" <BR><br><font color=red>Financial_Transaction Updated Successfully: ?</font>" +a572);
pstmt_p.close();
//out.print("<br> 212 Financial_Transaction Inserted");

transaction_id++;
	/*}*/
//--------------------------
if(Discount[i]!=0)
	{
query="insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_Id, Sr_No, For_Head, For_HeadId, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_On, Modified_By, Modified_MachineName, Ledger_Id, Transaction_Date, Tranasaction_No, Receive_Id, ReceiveFrom_LedgerId, Exchange_Rate) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?)";
pstmt_p = cong.prepareStatement(query);

//out.print("<br>transaction_id="+transaction_id);
pstmt_p.setString(1,""+transaction_id);
pstmt_p.setString(2,"1");
pstmt_p.setString(3,""+voucher_id[i]);
//out.print("<br>voucher_id[i]="+voucher_id[i]);
pstmt_p.setString(4,"0");
pstmt_p.setString(5,"13");
pstmt_p.setString(6,"2");
//out.print("<br>trans_type[i]="+trans_type[i]);

pstmt_p.setBoolean(7,dis_trans_type[i]);
//out.print("<br>ctax_amt[i]="+ctax_amt[i]);
//out.print("<br>ctax_localamt[i]="+ctax_localamt[i]);
//out.print("<br>ctax_dollaramt[i]="+ctax_dollaramt[i]);

pstmt_p.setString(8,""+dis_amt[i]);
pstmt_p.setString(9,""+dis_localamt[i]);
pstmt_p.setString(10,""+dis_dollaramt[i]);
//out.print("<br>today_string="+today_string);
pstmt_p.setString(11,""+format.getDate(today_string));
pstmt_p.setString(12,"1");
pstmt_p.setString(13,"Samyak23");
pstmt_p.setString(14,"2");//Ledger_Id
//out.print("<br>consignment_date[i]="+consignment_date[i]);
pstmt_p.setString(15,""+recd_date[i]);
pstmt_p.setString(16,""+consignment_no[i]);
pstmt_p.setString(17,""+receive_id[i]);
//out.print("<br>receive_id[i]="+receive_id[i]);

String disReceiveFrom_LedgerId= A.getNameCondition("Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+Receive_FromId[i]+" and Ledger_Type="+Ledger_Type[i]+"");
//out.print("<br>ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);
pstmt_p.setString(18,""+disReceiveFrom_LedgerId);
//out.print("<br>exchange_rate[i]="+exchange_rate[i]);
pstmt_p.setString(19,""+exchange_rate[i]);
//out.print("<br>Financial Transaction "+exchange_rate);
int a249 = pstmt_p.executeUpdate();
//out.println(" <BR><br><font color=red>Financial_Transaction Updated Successfully: ?</font>" +a572);
pstmt_p.close();
//out.print("<br> 257 Financial_Transaction Inserted");

transaction_id++;
	}
//--------------------------
}//for
C.returnConnection(cong);

out.println("<br> 265 Update Successfully");
%>


<%
//C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>









