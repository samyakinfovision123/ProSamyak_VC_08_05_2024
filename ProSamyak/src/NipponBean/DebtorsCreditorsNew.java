package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  DebtorsCreditorsNew
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connection conp = null;
	ResultSet rs_p=null;
	PreparedStatement pstmt_p=null;
	Connect c;
	NipponBean.Array A;

	public	DebtorsCreditorsNew()
		{
			try{
		//c=new Connect();
		A=new NipponBean.Array();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}
		}



//partyexchangeGainLoss until date D1
public String partyexchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1) 
{
try{
 //cong=c.getConnection();

	String query="";
	query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and R.Receive_Date <=?  and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 order by R.Receive_id";

	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
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

}catch(Exception e)	{
	System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;

}

}//exchangeGainLoss





//partyexchangeGainLoss between D1 and D2
public String partyexchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
{
try{
 //cong=c.getConnection();

	String query="";
	query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and R.Receive_Date between ? and ?  and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 order by R.Receive_id";

	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);
	pstmt_g.setString(3,company_id); 
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

}catch(Exception e)	{
	System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;

}

}//exchangeGainLoss





//ClosingDebtorsCreditors between the dates D1 and D2
public String ClosingDebtorsCreditors(Connection con, java.sql.Date D1, java.sql.Date D2, String party_id, String company_id, int d)
{
String line="196";
try{

String temp_ex= ""+partyexchangeGainLoss(con,party_id, company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
double purchase_gainloss =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
double sale_gainloss = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);

String query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<?  order by Voucher_Date,Voucher_id";

pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setString(2,""+D1);
rs_g = pstmt_g.executeQuery();	


double purchaseaccount=0;
double purchasereturn=0;
double saleaccount=0;
double discount=0;
double discount_total=0;
double total_purchase=0;
double sales=0;
double cr_purchasereturn=0;
double dr_salereturn=0;
double salereturn=0;

while(rs_g.next())
	{
		
		int  voucher_type=rs_g.getInt("Voucher_Type");
		String r_id=rs_g.getString("Voucher_No");
		double Local_Total= str.mathformat(rs_g.getDouble("Local_Total"),d);
		
		String receive_fromid= A.getNameCondition(con, "Receive","Receive_fromid","Where  Receive_id="+r_id+"");


		
		if((party_id.equals(receive_fromid)) &&(((2==voucher_type)||(11==voucher_type))))
		{
		if(2==voucher_type)
			{total_purchase +=Local_Total;}
		else{dr_salereturn +=Local_Total;}
		}
		else{
		if((1==voucher_type)&&(party_id.equals(receive_fromid)))
			{sales +=Local_Total;}
		if((10==voucher_type)&&(party_id.equals(receive_fromid)))
			{cr_purchasereturn +=Local_Total;}

	}

}
pstmt_g.close();
line="252";
double purchase=total_purchase;
 query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_sundrycreditors=0;
double opening_sundrydebtors=0;
double advance_sundrycreditors=0;
double advance_sundrydebtors=0;

	while(rs_g.next())
	{
	opening_sundrydebtors += str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
	opening_sundrycreditors += str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
	
	advance_sundrycreditors += str.mathformat(rs_g.getDouble("Purchase_AdvanceLocal"),d);
	advance_sundrydebtors += str.mathformat(rs_g.getDouble("Sale_AdvanceLocal"),d);

	}
	pstmt_g.close();
String slid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=1");
String plid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=2");

line="275";

query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid+" or ledger_id="+plid+") and Transaction_Date <? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
pstmt_g = con.prepareStatement(query);
double purchase_total = 0;
double sell_total = 0;
double t_purchase_total = 0;
double t_sell_total = 0;
int old_receive_id = 0;
int pd_count=0;	
//	pstmt_g.setDate(1,D1);
	pstmt_g.setString(1,""+D1);	
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
double cr_purchase=0;
double dr_purchase=0;
double cr_sales=0;
double dr_sales=0;
double cr_pn=0;
double dr_pn=0;

double dc_temp[]=new double[pd_count];
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
	 
	  dc_mode[n]=rs_g.getBoolean("Transaction_Type");
	 dc_temp[n] =str.mathformat(rs_g.getDouble("Local_Amount"),d);
	
	 ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();
//c.returnConnection(cong);
line="320";
for(n=0; n < pd_count; n++)
	{

		ledger_type=Integer.parseInt(A.getNameCondition(con,"Ledger","Ledger_type","Where ledger_id="+ledger_id[n]+""));
		//out.print("<br>ledger_type="+ledger_type);

		if (1==ledger_type)
			{
			if(dc_mode[n])
			{cr_sales += dc_temp[n];}
			else
			{dr_sales += dc_temp[n];}
		}//if 

		if (2==ledger_type)
			{
			if(dc_mode[n])
			{cr_purchase += dc_temp[n];}
			else
			{dr_purchase += dc_temp[n];}
		}//if 

	}
if (purchase_gainloss >= 0){
dr_purchase +=purchase_gainloss;
 }else{ 
cr_purchase +=purchase_gainloss *-1 ;} 

	if (sale_gainloss < 0){
	dr_sales +=sale_gainloss*-1;
}else{ 
	cr_sales +=sale_gainloss;} 

total_purchase+=cr_purchase ;
purchase+=cr_purchase ;
sales+=dr_sales ;
purchase_total +=dr_purchase +cr_purchasereturn ;
sell_total += cr_sales + dr_salereturn;	

line="360";

double pending_purchase=purchase - purchase_total -opening_sundrycreditors;

double pending_sale= sales-sell_total + opening_sundrydebtors; 

double opening_purchase = pending_purchase*(-1);
double opening_sale = pending_sale;



//getting the closing balance until the date D2 and the transactions between the period D1 and D2


temp_ex= ""+partyexchangeGainLoss(con,party_id, company_id,D1,D2);
StringTokenizer closing_tempe = new StringTokenizer(temp_ex,"/");
purchase_gainloss =str.mathformat(Double.parseDouble( (String)closing_tempe.nextElement()),d);
sale_gainloss = str.mathformat(Double.parseDouble( (String)closing_tempe.nextElement()),d);
//System.out.println("Exchange Gain Loss between D1 and D2: "+temp_ex);
line="380";



query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date between ? and ?  order by Voucher_Date,Voucher_id";

pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setString(2,""+D1);
pstmt_g.setString(3,""+D2);
rs_g = pstmt_g.executeQuery();	


purchaseaccount=0;
purchasereturn=0;
saleaccount=0;
discount=0;
discount_total=0;
total_purchase=0;
sales=0;
cr_purchasereturn=0;
dr_salereturn=0;
salereturn=0;

while(rs_g.next())
	{
		int  voucher_type=rs_g.getInt("Voucher_Type");
		String r_id=rs_g.getString("Voucher_No");
		double Local_Total= str.mathformat(rs_g.getDouble("Local_Total"),d);
		
		String receive_fromid= A.getNameCondition(con, "Receive","Receive_fromid","Where  Receive_id="+r_id+"");


		
		if((party_id.equals(receive_fromid)) &&(((2==voucher_type)||(11==voucher_type))))
		{
		if(2==voucher_type)
			{total_purchase +=Local_Total;}
		else{dr_salereturn +=Local_Total;}
		}
		else{
		if((1==voucher_type)&&(party_id.equals(receive_fromid)))
			{sales +=Local_Total;}
		if((10==voucher_type)&&(party_id.equals(receive_fromid)))
			{cr_purchasereturn +=Local_Total;}

	}

}
pstmt_g.close();
line="430";
purchase=total_purchase;

opening_sundrycreditors=opening_purchase;
opening_sundrydebtors=opening_sale;

slid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=1");
plid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=2");


line="440";

query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid+" or ledger_id="+plid+") and Transaction_Date between ? and ? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
pstmt_g = con.prepareStatement(query);
purchase_total = 0;
sell_total = 0;
t_purchase_total = 0;
t_sell_total = 0;
old_receive_id = 0;
pd_count=0;	
//	pstmt_g.setDate(1,D1);
pstmt_g.setString(1,""+D1);	
pstmt_g.setString(2,""+D2);	
pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
	
while(rs_g.next())
	{
	pd_count++;
	}
pstmt_g.close();
line="460";

//out.print("<br>pd_count="+pd_count);
ledger_type=0;
String closing_ledger_id[]=new String[pd_count];
boolean closing_dc_mode[]=new boolean[pd_count];
cr_purchase=0;
dr_purchase=0;
cr_sales=0;
dr_sales=0;
cr_pn=0;
dr_pn=0;

double closing_dc_temp[]=new double[pd_count];
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);	
pstmt_g.setString(2,""+D2);	
pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
n=0;
while(rs_g.next())
	{
	 closing_dc_mode[n]=rs_g.getBoolean("Transaction_Type");
	 
	 closing_dc_temp[n] =str.mathformat(rs_g.getDouble("Local_Amount"),d);
	 
	 closing_ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();
//c.returnConnection(cong);

line="490";
for(n=0; n < pd_count; n++)
	{

		ledger_type=Integer.parseInt(A.getNameCondition(con,"Ledger","Ledger_type","Where ledger_id="+closing_ledger_id[n]+""));
//out.print("<br>ledger_type="+ledger_type);

		if (1==ledger_type)
			{
			if(closing_dc_mode[n])
			{cr_sales += closing_dc_temp[n];}
			else
			{dr_sales += closing_dc_temp[n];}
		}//if 

		if (2==ledger_type)
			{
			if(closing_dc_mode[n])
			{cr_purchase += closing_dc_temp[n];}
			else
			{dr_purchase += closing_dc_temp[n];}
		}//if 


	}
if (purchase_gainloss >= 0){
dr_purchase +=purchase_gainloss;
 }else{ 
cr_purchase +=purchase_gainloss *-1 ;} 

	if (sale_gainloss < 0){
	dr_sales +=sale_gainloss*-1;
}else{ 
	cr_sales +=sale_gainloss;} 

line="525";
//calculating the transactions
double dr_trans_sales=0;
double cr_trans_sales=0;
double dr_trans_purchase=0;
double cr_trans_purchase=0;

dr_trans_sales = dr_sales + sales;
cr_trans_sales = cr_sales + dr_salereturn;

dr_trans_purchase = dr_purchase + cr_purchasereturn;
cr_trans_purchase = cr_purchase + total_purchase;

line="550";
total_purchase+=cr_purchase ;
purchase+=cr_purchase ;
sales+=dr_sales ;
purchase_total +=dr_purchase +cr_purchasereturn ;
sell_total += cr_sales + dr_salereturn;	


pending_purchase=0;
pending_sale=0;
pending_purchase=purchase - purchase_total -opening_sundrycreditors;
pending_sale= sales-sell_total + opening_sundrydebtors; 

double closing_purchase = pending_purchase*(-1);
double closing_sale = pending_sale;



return "" + opening_purchase +"/"+ opening_sale +"/"+ closing_purchase +"/"+ closing_sale +"/"+ dr_trans_purchase +"/"+ cr_trans_purchase +"/"+ dr_trans_sales +"/"+ cr_trans_sales;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
	return "Exception after line "+line+" in DebtorsCreditorsNew.java "+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//ClosingDebtorsCreditors()





//PartyWiseClosingDrCr between the dates D1 and D2
public String PartywiseClosingDrCr(Connection con, java.sql.Date from_date, java.sql.Date to_date, String partygroup_id, String sundarytype, String company_id, int d)
{
String line="571";
String partyDrCr="";
try{


String condition="";

if("1".equals(sundarytype))
	{
		condition = condition + " and Ledger_Type=1";
	}
if("2".equals(sundarytype))
	{
		condition = condition + " and Ledger_Type=2";
	}

if(partygroup_id != null && !("0".equals(partygroup_id)) )
	{
		condition = condition + " and PartyGroup_Id="+partygroup_id;
	}



double opening_debit=0;
double opening_totaldebit=0;
double opening_credit=0;
double opening_totalcredit=0;

double trans_debit=0;
double trans_totaldebit=0;
double trans_credit=0;
double trans_totalcredit=0;

double closing_debit=0;
double closing_totaldebit=0;
double closing_credit=0;
double closing_totalcredit=0;
int party_counter=0;

String query = "Select count(*) as party_counter from Ledger as L, Master_CompanyParty as MCP where For_Head=14 and For_HeadId=CompanyParty_Id";
query = query+condition;
//System.out.println("query = "+query);
line = "612";
pstmt_p = con.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next())
	{
	party_counter = rs_g.getInt("party_counter");
	}
//System.out.println("party_counter = "+party_counter);
String party_id[] = new String[party_counter];
line = "620";
//getting all the party_ids
query = "Select * from Ledger as L, Master_CompanyParty as MCP where For_Head=14 and For_HeadId=CompanyParty_Id and MCP.Active=1";
query = query+condition;

pstmt_p = con.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
int c=0;
while(rs_g.next())
{
	party_id[c]=rs_g.getString("For_HeadId");
	c++;
}
	
line = "634";	
for(int k=0; k<party_counter; k++)	
{
	double cr_trans_balance=0;
	double dr_trans_balance=0;
	double opening_balance=0;
	double closing_balance=0;
	String DrCr= ClosingDebtorsCreditors(con,from_date,to_date,party_id[k],company_id,d);
	line = "642";
	StringTokenizer LstOpening = new StringTokenizer(DrCr,"/");
	if("1".equals(sundarytype)) //sundary debitors (sale)
	{
		double temp=Double.parseDouble((String)LstOpening.nextElement());
		opening_balance=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
		closing_balance=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
		dr_trans_balance=Double.parseDouble((String)LstOpening.nextElement());
	    cr_trans_balance=Double.parseDouble((String)LstOpening.nextElement());
	}
	if("2".equals(sundarytype))//sundary creditors (purchase)
	{
		opening_balance=Double.parseDouble((String)LstOpening.nextElement());
		double temp=Double.parseDouble((String)LstOpening.nextElement());
		closing_balance=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
		dr_trans_balance=Double.parseDouble((String)LstOpening.nextElement());
	    cr_trans_balance=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
		temp=Double.parseDouble((String)LstOpening.nextElement());
	}
	
	if(opening_balance >= 0)
	{
		opening_totaldebit += opening_balance;
	}
	else
	{
		opening_balance = opening_balance * (-1);
		opening_totalcredit += opening_balance;
	}
	
	trans_totaldebit += dr_trans_balance;
	trans_totalcredit += cr_trans_balance;
		  
	if(closing_balance >= 0)
	{
		closing_totaldebit += closing_balance;
	}
	else
	{
		closing_balance = closing_balance * (-1);
		closing_totalcredit += closing_balance;
	}
		
line = "690";	
}
double opening_diff = opening_totaldebit - opening_totalcredit;
double closing_diff = closing_totaldebit - closing_totalcredit;

partyDrCr = opening_diff+"/"+trans_totaldebit+"/"+trans_totalcredit+"/"+closing_diff;
}
catch(Exception Samyak109){
	return "Exception after line "+line+" in DebtorsCreditorsNew.java "+Samyak109;
}

return partyDrCr;

}//PartyWiseClosingDrCr()



	public static void main(String[] args) throws Exception
	{

		DebtorsCreditorsNew l = new DebtorsCreditorsNew();
	
	}
}


