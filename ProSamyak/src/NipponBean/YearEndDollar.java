package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;
//All methods in this file are copy pasted from other files and only some changes are done to get the dollar values hence there may be some confusing variable names
public class  YearEndDollar
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connection conp = null;
	ResultSet rs_p=null;
	PreparedStatement pstmt_p=null;
	Connect c;
	NipponBean.Array A;

	public YearEndDollar()
		{
			try{
		//c=new Connect();
		A=new NipponBean.Array();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}
		}
public String partyexchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1) 
{
try{
 //cong=c.getConnection();

String query="";
query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and R.Receive_Date <=?  and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 order by R.Receive_id";

	pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int counter=0;
	double purchase_local_currency =0;
	double sale_local_currency =0;
	double purchase_LC =0;  // purchase local currency gain or loss
	double sale_LC =0;      // sale local currency gain or loss
	//for individual while loop for same receive id 
	double t_purchase_LC =0;  // purchase local currency gain or loss
	double t_sale_LC =0;      // sale local currency gain or loss

	double FINAL_GAINLOSS=0;
	double t_old_exrate = 0;
	double t_total_dollar = 0;
	int t_receiveid =0;
	double t_purchase_gainloss=0;	
	double PURCHASE_GAINLOSS = 0;
	boolean flag = false;
	
	double st_old_exrate = 0;
	double st_total_dollar = 0;
	int st_receiveid =0;
	double st_purchase_gainloss=0;	
	double salePURCHASE_GAINLOSS = 0;
	boolean sflag = false;

	while(rs_g.next()) 
		{
	 t_receiveid = rs_g.getInt("receive_id");

	
if(rs_g.getBoolean("Receive_Sell"))//purchase
{
	t_old_exrate = rs_g.getDouble("Exchange_Rate");
	double local_amount  = rs_g.getDouble("Local_Amount");
	double dollar_amount = rs_g.getDouble("Dollar_Amount");	
	t_total_dollar = t_total_dollar + dollar_amount; 
	t_purchase_gainloss = (t_old_exrate*dollar_amount) - (local_amount);
	PURCHASE_GAINLOSS = PURCHASE_GAINLOSS + t_purchase_gainloss;
}
else //sale
	{
	st_old_exrate = rs_g.getDouble("Exchange_Rate");
	double slocal_amount  = rs_g.getDouble("Local_Amount");
	double sdollar_amount = rs_g.getDouble("Dollar_Amount");	
	st_total_dollar = st_total_dollar + sdollar_amount; 
	
	st_purchase_gainloss = (st_old_exrate*sdollar_amount) - (slocal_amount);
	salePURCHASE_GAINLOSS = salePURCHASE_GAINLOSS + st_purchase_gainloss;
	}//else
}//while
pstmt_g.close();
//c.returnConnection(cong);


FINAL_GAINLOSS=PURCHASE_GAINLOSS-salePURCHASE_GAINLOSS;
return ""+PURCHASE_GAINLOSS+"/"+salePURCHASE_GAINLOSS;

	}catch(Exception e)
	{
		//c.returnConnection(cong);
//System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;

	}
////finally{c.returnConnection(cong); }

}//exchangeGainLoss



public String YearEndClosingDebtorsCreditorsDollar(Connection con,java.sql.Date D1, String company_id,int d, String yearend_id)
{
try{
String query="";
// cong=c.getConnection();
 query="Select * from Master_CompanyParty where company_id=?  and Active=1 order by Transaction_Currency, CompanyParty_Name ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id);
	rs_g = pstmt_g.executeQuery();	
	int i=0;
while(rs_g.next())
	{i++;}
	pstmt_g.close();
int partycounter=i;
String name[]=new String[partycounter];
double opening_sundrycreditors[]=new double[partycounter];
double opening_sundrydebtors[]=new double[partycounter];
double opening_pn[]=new double[partycounter];
int party_id[]=new int[partycounter]; 
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id);
	rs_g = pstmt_g.executeQuery();	
i=0;
	while(rs_g.next())
	{
	party_id[i]=rs_g.getInt("Companyparty_id");
	name[i]=rs_g.getString("CompanyParty_Name");
	opening_sundrydebtors[i] = str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),d);
	opening_sundrycreditors [i]= str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),d);
	
	opening_pn[i] = str.mathformat(rs_g.getDouble("Opening_PNDollarBalance"),d);
	i++;
		}
	pstmt_g.close();


query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setDate(2,D1);
rs_g = pstmt_g.executeQuery();	
int j=0;
while(rs_g.next())
	{j++;}
pstmt_g.close();

int vouchercount=j;
//  out.print("<br>vouchercount="+vouchercount);

double purchaseaccount[]=new double[partycounter];
double purchasereturn[]=new double[partycounter];
double saleaccount[]=new double[partycounter];
double discount[]=new double[partycounter];
double discount_total[]=new double[partycounter];
double total_purchase[]=new double[partycounter];
double sales[]=new double[partycounter];
double cr_purchasereturn[]=new double[partycounter];
double dr_salereturn[]=new double[partycounter];
double salereturn[]=new double[partycounter];
double purchase_gainloss[]=new double[partycounter];
double sale_gainloss[]=new double[partycounter];

double Local_Total[]=new double[vouchercount];
int receive_fromid[]=new int[vouchercount];
int  voucher_type[]=new int[vouchercount];
pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setDate(2,D1);
rs_g = pstmt_g.executeQuery();	
j=0;

while(rs_g.next())
	{
Local_Total[j]= str.mathformat(rs_g.getDouble("Dollar_Total"),2);
String r_id=rs_g.getString("Voucher_No");
receive_fromid[j]=Integer.parseInt(A.getNameCondition(con,"Receive","Receive_fromid","Where  Receive_id="+r_id+""));
 voucher_type[j]=rs_g.getInt("Voucher_Type");
/* out.print("<br>voucher_type[j]="+voucher_type[j]);
  out.print("receive_fromid[j]="+receive_fromid[j]);
 out.print("Local_Total[j]="+Local_Total[j]);*/
j++;
}
pstmt_g.close();

for(i=0; i<partycounter; i++)
{

//String temp_ex= ""+partyexchangeGainLoss(con,""+party_id[i], company_id,D1);
//StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
//purchase_gainloss[i] =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
purchase_gainloss[i] =0;
 //sale_gainloss[i] = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
sale_gainloss[i] = 0;

// out.print("<br>192party_id[i]="+party_id[i]);
j=0;

while(j<vouchercount)
	{
/* out.print("<br>voucher_type[j]="+voucher_type[j]);
  out.print("receive_fromid[j]="+receive_fromid[j]);
 out.print("Local_Total[j]="+Local_Total[j]);
 out.print("party_id[i]="+party_id[i]);
*/
if((party_id[i]==receive_fromid[j])&&(2==voucher_type[j]))
	{total_purchase[i] +=Local_Total[j];}
else if((party_id[i]==receive_fromid[j])&&(11==voucher_type[j]))
	{dr_salereturn[i] +=Local_Total[j];}


else if ((1==voucher_type[j])&&(party_id[i]==receive_fromid[j]))
	{sales[i] +=Local_Total[j];}
else if ((10==voucher_type[j])&&(party_id[i]==receive_fromid[j]))
	{cr_purchasereturn[i] +=Local_Total[j];}
j++;
	}//while


}//for

String slid[]=new String[partycounter];
String plid[]=new String[partycounter];
double purchase[]=new double[partycounter];

for(i=0; i<partycounter; i++)
	{
 purchase[i]=total_purchase[i];
 slid[i]=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id[i]+" and Ledger_type=1");
 plid[i]=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id[i]+" and Ledger_type=2");

	}

double cr_purchase[]=new double[partycounter];
double dr_purchase[]=new double[partycounter];
double cr_sales[]=new double[partycounter];
double dr_sales[]=new double[partycounter];
double cr_pn[]=new double[partycounter];
double dr_pn[]=new double[partycounter];
double purchase_total[]=new double[partycounter];
double sell_total[]=new double[partycounter];
double t_purchase_total[]=new double[partycounter];
double t_sell_total[]=new double[partycounter];
double  pending_purchase[]=new double[partycounter];
double  pending_sale[]=new double[partycounter];

for(i=0; i<partycounter; i++)
	{
query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid[i]+" or ledger_id="+plid[i]+") and Transaction_Date <=? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
//out.print("<br>query="+query);
pstmt_g = con.prepareStatement(query);
int old_receive_id = 0;
int pd_count=0;	
//	pstmt_g.setDate(1,D1);
	pstmt_g.setDate(1,D1);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	
	while(rs_g.next())
	{pd_count++;
	}
pstmt_g.close();
//out.print("<br>pd_count="+pd_count);
int ledger_type=0;
String ledger_id[]=new String[pd_count];
boolean dc_mode[]=new boolean[pd_count];

double dc_temp[]=new double[pd_count];
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
	dc_mode[n]=rs_g.getBoolean("Transaction_Type");
	 dc_temp[n] =str.mathformat(rs_g.getDouble("Dollar_Amount"),d);
	 
	 ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();


for(n=0; n < pd_count; n++)
	{
/*out.print("<br>dc_temp="+dc_temp[n]);
out.print("<br>dc_mode="+dc_mode[n]);
out.print("<br>ledger_id="+ledger_id[n]);*/
ledger_type=Integer.parseInt(A.getNameCondition(con,"Ledger","Ledger_type","Where ledger_id="+ledger_id[n]+""));
//out.print("<br>ledger_type="+ledger_type);

if (1==ledger_type)
	{
	if(dc_mode[n])
	{cr_sales[i] += dc_temp[n];}
	else
	{dr_sales[i] += dc_temp[n];}
}//if 

if (2==ledger_type)
	{
	if(dc_mode[n])
	{cr_purchase[i] += dc_temp[n];}
	else
	{dr_purchase[i] += dc_temp[n];}
}//if 


}

/*out.print("purchase[i]="+purchase[i]);	
out.print("cr_purchase[i]="+cr_purchase[i]);	
out.print("dr_purchase[i]="+dr_purchase[i]);	
out.print("<br>sales[i]="+sales[i]);	
out.print("dr_sales[i]="+dr_sales[i]);	
out.print("cr_purchasereturn[i]="+cr_purchasereturn[i]);	
out.print("dr_salereturn[i]="+dr_salereturn[i]);	
*/
if (purchase_gainloss[i] >= 0){
dr_purchase[i] +=purchase_gainloss[i];
 }else{ 
cr_purchase[i] +=purchase_gainloss[i] *-1 ;} 

	if (sale_gainloss[i] < 0){
	dr_sales[i] +=sale_gainloss[i]*-1;
}else{ 
	cr_sales[i] +=sale_gainloss[i];} 


total_purchase[i] +=cr_purchase[i] ;
purchase[i] +=cr_purchase[i] ;
sales[i] +=dr_sales[i] ;
purchase_total[i] +=dr_purchase[i] +cr_purchasereturn[i];
sell_total[i] += cr_sales[i] + dr_salereturn[i];	

 pending_purchase[i]= purchase[i] - purchase_total[i] -opening_sundrycreditors[i];
 pending_sale[i]= sales[i]-sell_total[i] + opening_sundrydebtors[i]; 
/* out.print("<br>name[i]"+name[i]);
out.print("&nbsp;&nbsp;pending_purchase[i]="+str.format(""+pending_purchase[i],d));	
out.print("&nbsp;&nbsp;pending_sale[i]="+str.format(""+pending_sale[i],d));	
*/
}//for i
double pending_pn[]=new double[partycounter];
for(i=0; i<partycounter; i++)
	{
 query="Select * from PN  where PN_Date <=? and Company_id=? and To_FromId="+party_id[i]+" and Active=1 and PN_Status=0 order by PN_Status, PN_Date,PN_No";
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	


	double pn_localamount=0;
double pn_dollaramount=0;
double local=opening_pn[i];
double cr_total=0;
double dr_total=0;
while(rs_g.next())
{
pn_localamount= str.mathformat(rs_g.getDouble("PN_LocalAmount"),d);
pn_dollaramount= str.mathformat(rs_g.getDouble("PN_DollarAmount"),2);
local +=pn_dollaramount;
if(pn_dollaramount>0)
	{dr_total +=pn_dollaramount;}
else { cr_total +=(pn_dollaramount * -1);}

	}//while
 pstmt_g.close();
//c.returnConnection(cong);

pending_pn[i]=local;
	}

String tempr="";
for(i=0; i<partycounter; i++)
	{
tempr = tempr + "#"+name[i]+ "#" +pending_purchase[i]+ "#" +pending_sale[i]+ "#" +pending_pn[i] + "#" + party_id[i] ;
	}



return tempr;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue


///



//method calculating the profit loss in Dollar
public double getNetProfitLossDollar(Connection cong, int d, java.sql.Date D1, java.sql.Date D2, String company_id, String yearend_id){

double net_profit=0;
String errLine = "409";
try{
YearEndFinance YEF = new YearEndFinance();
YearEndStock YES = new YearEndStock();
Connect C = new Connect();
Connection con = C.getConnection();
String query="";
String party_id="0";

errLine = "415";
query="Select count(*) as category_counter from Master_LotCategory where company_id=?" ;

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
//pstmt_g.setString(2,yearend_id); 
rs_g = pstmt_g.executeQuery();	
int category_counter=0;
while(rs_g.next())
	{category_counter=rs_g.getInt("category_counter");}
pstmt_g.close();
errLine = "426";
int c=0;	

query="Select * from Master_LotCategory where Company_id=?";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
//pstmt_g.setString(2,yearend_id); 
rs_g = pstmt_g.executeQuery();	
double category_opening[]=new double[category_counter];
double category_closing[]=new double[category_counter];
String LotCategory_Name[]=new String[category_counter];
double final_opening=0;
double final_closing =0;
while(rs_g.next())
{
errLine = "442";
String LotCategory_Id=rs_g.getString("LotCategory_Id");
 LotCategory_Name[c]=rs_g.getString("LotCategory_Name");
errLine = "445";

category_opening[c]= YES.stockValueDollar(con,D1,company_id,"Opening",d, " and LotCategory_Id="+LotCategory_Id+"",yearend_id);

category_closing[c]= YES.stockValueDollar(con,D2,company_id,"Closing",d, " and LotCategory_Id="+LotCategory_Id+"",yearend_id);


final_opening += category_opening[c];
//final_closing += category_closing[c];
c++;
errLine = "455";
}//while
pstmt_g.close();
errLine = "459";


int counter=0;

query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Active=1  and Receive_FromId not like "+company_id+" and yearend_id="+ yearend_id+ " and Opening_Stock=0 order by receive_date ,receive_no";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setDate(2,D2);	
pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	

double slocal_total=0; 
double sexport_total=0; 
double local_total=0; 
double import_total=0; 
double sales=0;
double purchase=0;
double local=0; 
double dollar=0; 
double closing =final_opening;
double tax=0;
double ctax_local=0;
double discount=0;
double purchase_return=0;
double sale_return=0;

while(rs_g.next())
	{
boolean receive_sell=rs_g.getBoolean("Receive_Sell");
String receive_currency= rs_g.getString("Receive_CurrencyId");
double receive_total= str.mathformat(rs_g.getDouble("Local_Total"),d);
boolean returned=rs_g.getBoolean("R_Return");
double inv_total=str.mathformat(rs_g.getDouble("InvDollarTotal"),d);

double templocal_local=inv_total;



if((receive_sell)&&(!returned))
		{//purchaseaccount +=inv_total;
//total_purchase +=receive_total;
purchase += inv_total;
closing +=inv_total;

 if("0".equals(receive_currency))
	{import_total += templocal_local;}
else{local_total += templocal_local;}
}
else if((receive_sell)&&(returned))
		{
//	dr_salereturn += receive_total;
	sale_return +=inv_total;}
else if((!receive_sell)&&(!returned))
		{
//	sales +=receive_total;
	sales += inv_total;
 if("0".equals(receive_currency))
	{sexport_total += templocal_local;}
else{slocal_total += templocal_local;}

}
else if((!receive_sell)&&(returned))
		{purchase_return += inv_total;
//cr_purchasereturn +=receive_total;
}


}//while
pstmt_g.close();
errLine = "527";
query="Select * from Ledger where Company_id=? and For_Head="+6+" and Active=1 and yearend_id="+yearend_id+" order by Ledger_Name";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id);
rs_g = pstmt_g.executeQuery();	
int i=0;
while(rs_g.next())
	{i++;}//while
	pstmt_g.close();
 counter=i;

int ledger_id[]=new int[i];
int for_headid[]=new int[i];
double expense[]=new double[i];
double total_expense=0;
String ledger_name[]=new String[i]; 
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
i=0;
while(rs_g.next())
{
ledger_id[i]=rs_g.getInt("Ledger_Id");
for_headid[i]=rs_g.getInt("For_HeadId");
ledger_name[i]=rs_g.getString("Ledger_Name");
//expense[i]=rs_g.getDouble("Opening_LocalBalance");
String closingTemp= YEF.LedgerClosingBalance(cong,""+ledger_id[i],D2,d,yearend_id, company_id);

StringTokenizer tokens = new StringTokenizer(closingTemp, "#");

String temp = (String)tokens.nextElement();
String closing_amt1 = (String)tokens.nextElement();

expense[i]=Double.parseDouble(closing_amt1);

total_expense +=expense[i];
i++;
}//while
pstmt_g.close();
errLine = "566";
double total_indirectrexpense=0;
query="Select * from Ledger where Company_id=? and For_Head="+13+" and Active=1 and yearend_id=" + yearend_id + " order by Ledger_Name";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 

rs_g = pstmt_g.executeQuery();	
 i=0;
while(rs_g.next())
{i++;}//while
	pstmt_g.close();
int  in_counter=i;

int ledgerid[]=new int[i];
int forheadid[]=new int[i];
double in_expense[]=new double[i];
String ledgername[]=new String[i]; 
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
i=0;
while(rs_g.next())
{
ledgerid[i]=rs_g.getInt("Ledger_Id");
forheadid[i]=rs_g.getInt("For_HeadId");
ledgername[i]=rs_g.getString("Ledger_Name");
String closingTemp= YEF.LedgerClosingBalance(cong,""+ledgerid[i],D2,d,yearend_id,company_id);

StringTokenizer tokens = new StringTokenizer(closingTemp, "#");

String temp = (String)tokens.nextElement();
String closing_amt1 = (String)tokens.nextElement();


in_expense[i]=Double.parseDouble(closing_amt1);

//in_expense[i]=rs_g.getDouble("Opening_LocalBalance");
total_indirectrexpense +=in_expense[i];
i++;
}//while
pstmt_g.close();
errLine = "607";



double total_indirectincome=0;
query="Select * from Ledger where Company_id=? and For_Head="+12+" and Active=1 and yearend_id="+ yearend_id+ " order by Ledger_Name";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
 i=0;
while(rs_g.next())
{i++;}//while
	pstmt_g.close();
int  ic_counter=i;
errLine = "621";
int ic_ledgerid[]=new int[i];
int ic_forheadid[]=new int[i];
double in_income[]=new double[i];
String ic_ledgername[]=new String[i]; 
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
i=0;
while(rs_g.next())
{
ic_ledgerid[i]=rs_g.getInt("Ledger_Id");
ic_forheadid[i]=rs_g.getInt("For_HeadId");
ic_ledgername[i]=rs_g.getString("Ledger_Name");
String closingTemp= YEF.LedgerClosingBalance(cong,""+ic_ledgerid[i],D2,d,yearend_id,company_id);

StringTokenizer tokens = new StringTokenizer(closingTemp, "#");

String temp = (String)tokens.nextElement();
String closing_amt1 = (String)tokens.nextElement();

in_income[i]=Double.parseDouble(closing_amt1);

//in_expense[i]=rs_g.getDouble("Opening_LocalBalance");
total_indirectincome +=in_income[i];
i++;
}//while
pstmt_g.close();
errLine = "649";
//C.returnConnection(cong);




double gross_profit =  (sales + final_closing + purchase_return) - (final_opening + purchase + total_expense +  sale_return);
net_profit =gross_profit - total_indirectrexpense  -total_indirectincome;
double final_total =  sales + final_closing - sale_return - total_indirectincome;

//System.out.println("Net Profit : "+net_profit);
C.returnConnection(con);
}
catch(Exception e)
{
	System.out.println("Exception in getNetProfitLossDollar method after Line :"+errLine);
}

return net_profit;
}// end getNetProfitLossDollar




	public static void main(String[] args) throws Exception
	{

		DebtorsCreditors l = new DebtorsCreditors();
	
	}
}


