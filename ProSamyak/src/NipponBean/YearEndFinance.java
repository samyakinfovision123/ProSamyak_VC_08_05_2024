package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;
public class  YearEndFinance
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connect1 C;
	NipponBean.Array A;

	public	YearEndFinance()
		{
		try{
		//	C=new Connect1();
			A=new NipponBean.Array();

	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}
		}
public String DebitCreditBalance(Connection con,String ledger_id,java.sql.Date D1,java.sql.Date D2,int d) 
{
try{
String query="";
// cong=C.getConnection();
	
double local=0;
double dollar=0;
double local_tot=0;
double dollar_tot=0;

double db_localamount =0;
double db_dollaramount =0;
double cr_localamount=0;
double cr_dollaramount=0;
double rlocal=0;
double rdollar=0;

query="Select * from Financial_Transaction where  Ledger_id="+ledger_id+" and Transaction_Date between ? and ? and Active=1 order by Transaction_Date,Tranasaction_Id ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setDate(2,D2);
rs_g = pstmt_g.executeQuery();	
	
int m=1;
while(rs_g.next())
{
//System.out.println("Total Voucher for this Ledger is "+D1 +":"+ledger_id+" counter "+m);
String voucher_id=rs_g.getString("Voucher_id");
String transaction_type= rs_g.getString("transaction_type");
local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),d);
local_tot +=local;
dollar_tot +=dollar;
if("0".equals(transaction_type))
{
db_localamount +=local;
db_dollaramount +=dollar;
rlocal += local;
rdollar += dollar;
}
else{
cr_localamount +=local;
cr_dollaramount +=dollar;
rlocal =rlocal-local;
rdollar =rdollar-dollar;
}//else inner
m=m+1;
}//while
pstmt_g.close();
//C.returnConnection(cong);

/*if(rlocal > 0)
{
	db_localamount +=(rlocal );
	db_dollaramount +=(rdollar);
}
else
{
	
	cr_localamount +=(rlocal*-1);
	cr_dollaramount +=(rdollar*-1);
}
*/

String temp=""+db_localamount+"/"+cr_localamount;
return temp;
}catch(Exception e)
	{//C.returnConnection(cong);
	//System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;
	}
//finally{C.returnConnection(cong); }

}//DebitCreditBalance 

public String ClosingBalance(Connection con,String ledger_id,java.sql.Date D1,int d, String yearend_id, String company_id) 
{
try{
String query="";
// cong=C.getConnection();
//System.out.println("Inside YEF 105 ledger_id"+ledger_id);
 query="Select * from Ledger where  Ledger_id="+ledger_id+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id;
pstmt_g = con.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
double opening_localbalance=0;
double opening_dollarbalance=0;
while(rs_g.next())
{
opening_localbalance=str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
opening_dollarbalance=str.mathformat(rs_g.getDouble("Opening_DollarBalance"),2);
}
pstmt_g.close();	
double local=0;
double dollar=0;
double local_tot=0;
double dollar_tot=0;

double db_localamount =opening_localbalance;
double db_dollaramount =opening_dollarbalance;
double cr_localamount=0;
double cr_dollaramount=0;
double rlocal=opening_localbalance;
double rdollar=opening_dollarbalance;

if(opening_localbalance <0)
{
int c=-1;
db_localamount =0;
db_dollaramount =0 ;
cr_localamount=(opening_localbalance * c);
cr_dollaramount=(opening_dollarbalance * c);
rlocal=opening_localbalance;
rdollar=opening_dollarbalance  ;
}

query="Select * from Financial_Transaction where  Ledger_id="+ledger_id+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id+" and Transaction_Date <= ? and Active=1 order by Transaction_Date,Tranasaction_Id ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
rs_g = pstmt_g.executeQuery();	
	
int m=1;
while(rs_g.next())
{
//System.out.println("Total Voucher for this Ledger is "+D1 +":"+ledger_id+" counter "+m);
String voucher_id=rs_g.getString("Voucher_id");
String transaction_type= rs_g.getString("transaction_type");
local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),2);
local_tot +=local;
dollar_tot +=dollar;
if("0".equals(transaction_type))
{
db_localamount +=local;
db_dollaramount +=dollar;
rlocal += local;
rdollar += dollar;
}
else{
cr_localamount +=local;
cr_dollaramount +=dollar;
rlocal =rlocal-local;
rdollar =rdollar-dollar;
}//else inner
m=m+1;
}//while
pstmt_g.close();
//C.returnConnection(cong);

if(rlocal < 0)
{
	int c=-1;
	db_localamount +=(rlocal *c);
	db_dollaramount +=(rdollar * c);
}
else
{
	cr_localamount +=rlocal;
	cr_dollaramount +=rdollar;
}


String temp=""+rlocal;
System.out.print("187 ==temp ==" +temp);
return temp;
}catch(Exception e)
	{//C.returnConnection(cong);
	System.out.print("<BR>190 YearEndFinance " +e);
	return ""+e;
	}
//finally{C.returnConnection(cong); }

}//ClosingBalance 





public String ClosingBankBalance(Connection con,String account_id,String company_id,java.sql.Date D1, int d, String yearend_id) 
{
try{
 //cong=C.getConnection();
double opening_localbalance = 0;
double opening_dollarbalance = 0;
String query ="Select *from Master_Account where account_id="+account_id +" and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id;
String account_no="";
String account_name="";

pstmt_g = con.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
	{
	account_name=rs_g.getString("Account_Name");
	account_no=rs_g.getString("Account_Number"); 
	opening_localbalance += str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
	opening_dollarbalance += str.mathformat(rs_g.getDouble("Opening_DollarBalance"),d);
	
	}
	pstmt_g.close();


if("PN Account".equals(account_name))
{
			

	//change in query for considering the yearend
	query="Select * from Ledger where Active=1 and For_Head=14 and Ledger_Type=3 and company_id="+company_id+" and YearEnd_Id="+yearend_id;
	pstmt_g = con.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		opening_localbalance += str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
		opening_dollarbalance += str.mathformat(rs_g.getDouble("Opening_DollarBalance"),2);

	}
	pstmt_g.close();
}

double rlocal=0;
double rdollar=0;
rlocal=opening_localbalance;
rdollar=opening_dollarbalance;
double db_localamount =opening_localbalance;
double db_dollaramount = opening_dollarbalance;
double cr_localamount=0;
double cr_dollaramount=0;

query="Select *from Financial_Transaction where For_Head=1 and For_HeadId="+account_id+"and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id+" and Transaction_Date<=? and Active=1 order by Transaction_Date, Voucher_id";


int ftvoucher_id=0;
int trans_type=0;
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1); 
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
ftvoucher_id=rs_g.getInt("Voucher_id");
trans_type= rs_g.getInt("Transaction_Type");
double local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
double dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),2);

if(0==trans_type)
{
rlocal += local;
rdollar += dollar;
db_localamount +=local;
db_dollaramount +=dollar;
}
else{
rlocal =rlocal - local;
rdollar =rdollar - dollar;
cr_localamount +=local;
cr_dollaramount +=dollar;
}

}
pstmt_g.close();
//C.returnConnection(cong);

cr_localamount +=rlocal;
cr_dollaramount +=rdollar;
return ""+rlocal;
}catch(Exception Samyak109)
	{//C.returnConnection(cong);
return ""+Samyak109;
	}
	//finally{C.returnConnection(cong); }

}//closingbankbalance




public String ClosingBankBalanceDollar(Connection con,String account_id,String company_id,java.sql.Date D1, int d, String yearend_id) 
{
try{
 //cong=C.getConnection();
double opening_localbalance = 0;
double opening_dollarbalance = 0;
String query ="Select *from Master_Account where account_id="+account_id+" and YearEnd_Id="+yearend_id;
String account_no="";
String account_name="";

pstmt_g = con.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
	{
	account_name=rs_g.getString("Account_Name");
	account_no=rs_g.getString("Account_Number"); 
	opening_localbalance += str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
	opening_dollarbalance += str.mathformat(rs_g.getDouble("Opening_DollarBalance"),2);
	
	}
	pstmt_g.close();


if("PN Account".equals(account_name))
		{
 	
 
	//change in query for considering the yearend
	query="Select * from Ledger where Active=1 and For_Head=14 and Ledger_Type=3 and company_id="+company_id+" and YearEnd_Id="+yearend_id;
	pstmt_g = con.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		opening_localbalance += str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
		opening_dollarbalance += str.mathformat(rs_g.getDouble("Opening_DollarBalance"),2);

	}
	pstmt_g.close();

		}

double rlocal=0;
double rdollar=0;
 rlocal=opening_localbalance;
 rdollar=opening_dollarbalance;
double db_localamount =opening_localbalance;
double db_dollaramount = opening_dollarbalance;
double cr_localamount=0;
double cr_dollaramount=0;

query="Select *from Financial_Transaction where For_Head=1 and For_HeadId="+account_id+" and YearEnd_Id="+yearend_id+" and Transaction_Date<=? and Active=1 order by Transaction_Date, Voucher_id";

pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1); 
rs_g = pstmt_g.executeQuery();

int ftvoucher_id=0;
int trans_type=0;
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1); 
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
ftvoucher_id=rs_g.getInt("Voucher_id");
trans_type= rs_g.getInt("Transaction_Type");
double local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
double dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),d);

if(0==trans_type)//0 credit(incoming)
{
rlocal += local;
rdollar += dollar;
db_localamount +=local;
db_dollaramount +=dollar;
}
else{
rlocal =rlocal - local;
rdollar =rdollar - dollar;
cr_localamount +=local;
cr_dollaramount +=dollar;
}

}
pstmt_g.close();
//C.returnConnection(cong);

cr_localamount +=rlocal;
cr_dollaramount +=rdollar;
return ""+rlocal+"/"+rdollar;
}catch(Exception Samyak109)
	{//C.returnConnection(cong);
return ""+Samyak109;
	}
	//finally{C.returnConnection(cong); }

}//closingbankbalanceDollar





public String DebitCreditBank(Connection con,String account_id,java.sql.Date D1, java.sql.Date D2, int d) 
{
try{
 //cong=C.getConnection();

double rlocal=0;
double rdollar=0;
 rlocal=0;
 rdollar=0;
double db_localamount =0;
double db_dollaramount = 0;
double cr_localamount=0;
double cr_dollaramount=0;

String query="Select *from Financial_Transaction where For_Head=1 and For_HeadId="+account_id+" and Transaction_Date between ? and ? and Active=1 order by Transaction_Date, Voucher_id";

pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1); 
pstmt_g.setDate(2,D2); 
rs_g = pstmt_g.executeQuery();

int ftvoucher_id=0;
int trans_type=0;
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1); 
pstmt_g.setDate(2,D2); 
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
ftvoucher_id=rs_g.getInt("Voucher_id");
trans_type= rs_g.getInt("Transaction_Type");
double local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
double dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),2);


if(0==(trans_type))
{
rlocal += local;
rdollar += dollar;
db_localamount +=local;
db_dollaramount +=dollar;
}
else{
rlocal =rlocal - local;
rdollar =rdollar - dollar;
cr_localamount +=local;
cr_dollaramount +=dollar;
}
}
pstmt_g.close();
//C.returnConnection(cong);

//cr_localamount +=rlocal;
//cr_dollaramount +=rdollar;
//System.out.print("\n db_localamount="+db_localamount);
//1System.out.print("\n cr_localamount="+cr_localamount);
return ""+db_localamount+"/"+cr_localamount;
}catch(Exception Samyak109)
	{//C.returnConnection(cong);
return ""+Samyak109;
	}
//finally{C.returnConnection(cong); }

}//DebitCreditBank

public String saleReturn(Connection con,String company_id, java.sql.Date D1, java.sql.Date D2, int d) 
{
try{
// cong=C.getConnection();

String query="Select * from Receive R, Receive_Transaction RT  where R.Receive_Date between ? and ? and R.Company_id=? and R.purchase=1 and R.Receive_Sell=1 and R.Opening_Stock=0 and R.Active=1 and R.R_Return=1 and R.Consignment_ReceiveId >0 and R.Receive_Id=RT.Receive_Id and R.Active=1 order by R.Receive_date ,R.Receive_no";

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setDate(2,D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int i=0;
	while(rs_g.next())
	{i++;}pstmt_g.close();
	int counter=i;
	int receive_id[]=new int[counter];  
	int receiveid[]=new int[counter];  
	int receive_trans[]=new int[counter];  
	int lot_id[]=new int[counter];  
	int reflot_id[]=new int[counter];  
	int ref_receiveid[]=new int[counter];  
	int lot_srno[]=new int[counter];  
	int reflot_srno[]=new int[counter];  
	double qty[]=new double[counter];  
	double ref_rate[]=new double[counter];  
	double rate[]=new double[counter];  
	double tax_amt[]=new double[counter];  
	double tax[]=new double[counter];  
	double discount_amt[]=new double[counter]; 
	double discount[]=new double[counter]; 
	double subtotal[]=new double[counter]; 
	double total[]=new double[counter]; 
	double total_tax=0;
	double total_discount=0;
	double temp=0;
	double temp_amt=0;
	double grand_total=0;
	double local_total=0;
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setDate(2,D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	i=0;
	while(rs_g.next())
	{
	
	receive_trans[i]= rs_g.getInt("ReceiveTransaction_Id");
	receive_id[i]=rs_g.getInt("Receive_Id");
	
	lot_srno[i]= rs_g.getInt("lot_srno");
	lot_id[i]=rs_g.getInt("lot_id");
	qty[i]=rs_g.getDouble("Quantity");
	rate[i]=str.mathformat(rs_g.getDouble("Local_Price"),d);
	ref_receiveid[i]= rs_g.getInt("Consignment_ReceiveId");
	//qty[i]=rs_g.getDouble("Available_Quantity");
	
	
	tax[i]=rs_g.getDouble("Tax");
	discount[i]=rs_g.getDouble("Discount");

		i++;}pstmt_g.close();


for(i=0; i<counter; i++)
	{
//query="Select * from Receive R, Receive_Transaction RT  where RT.Receive_Id=? and RT.Lot_id=? and RT.Lot_Srno=? order by R.Receive_date ,R.Receive_no";
query="Select * from Receive_Transaction  where Receive_Id=? and Lot_id=? and Active=1 order by receive_id ,lot_id";

	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+ref_receiveid[i]);
	pstmt_g.setString(2,""+lot_id[i]);	
//	pstmt_g.setString(3,""+lot_srno[i]);	
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
receiveid[i]=rs_g.getInt("Receive_Id");
reflot_id[i]=rs_g.getInt("lot_id");

reflot_srno[i]= rs_g.getInt("lot_srno");
ref_rate[i]=rs_g.getDouble("Local_Price");
	}pstmt_g.close();

	}//for
for(i=0; i<counter; i++)
	{
	 temp=qty[i]*ref_rate[i];
	 subtotal[i]=temp; 
	 local_total +=subtotal[i];
	 discount_amt[i]=temp * (discount[i]/100); 
	 temp_amt = temp - discount_amt[i];
tax_amt[i] = temp_amt * (tax[i]/100);
total[i]= temp_amt + tax_amt[i];
grand_total +=total[i];
total_tax +=tax_amt[i];
total_discount +=discount_amt[i];
}//for
//C.returnConnection(cong);

return ""+local_total+"/"+total_tax+"/"+total_discount;
}catch(Exception Samyak109)
	{//C.returnConnection(cong);
return ""+Samyak109;
	}
//finally{C.returnConnection(cong); }

}//saleReturn


public String LedgerClosingBalance(Connection con,String ledger_id,java.sql.Date D1,int d, String yearend_id, String company_id) 
{
try{
String query="";
query="Select * from Ledger where  Ledger_id="+ledger_id+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id;

pstmt_g = con.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
double opening_localbalance=0;
double opening_dollarbalance=0;
while(rs_g.next())
{
	opening_localbalance=str.mathformat(rs_g.getDouble("Opening_LocalBalance"),d);
	opening_dollarbalance=str.mathformat(rs_g.getDouble("Opening_DollarBalance"),2);
}
pstmt_g.close();	
double local=0;
double dollar=0;

double rlocal=opening_localbalance;
double rdollar=opening_dollarbalance;

if(opening_localbalance <0)
{
	int c=-1;
	rlocal=opening_localbalance;
	rdollar=opening_dollarbalance  ;
}

query="Select * from Financial_Transaction where  Ledger_id="+ledger_id+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearend_id+" and Transaction_Date <= ? and Active=1 order by Transaction_Date,Tranasaction_Id ";
//System.out.println(query);
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
rs_g = pstmt_g.executeQuery();	
	
int m=1;
while(rs_g.next())
{
	String voucher_id=rs_g.getString("Voucher_id");
	String transaction_type= rs_g.getString("transaction_type");
	local=str.mathformat(rs_g.getDouble("Local_Amount"),d);
	dollar=str.mathformat(rs_g.getDouble("Dollar_Amount"),2);
	if("0".equals(transaction_type))
	{
		rlocal += local;
		rdollar += dollar;
	}
	else{
		rlocal -= local;
		rdollar -= dollar;
	}//else inner
	m=m+1;
}//while
pstmt_g.close();

String temp=""+rlocal+"#"+rdollar;
return temp;
}catch(Exception e)
{
	System.out.print("<BR>559 method LedgerClosingBalance YearEndFinance " +e);
	return ""+e;
}
//finally{C.returnConnection(cong); }

}//end LedgerClosingBalance()

	public static void main(String[] args) throws Exception
	{

		Finance l = new Finance();
	
	}
}


