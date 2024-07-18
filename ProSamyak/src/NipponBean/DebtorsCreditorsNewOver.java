package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  DebtorsCreditorsNewOver
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connection conp = null;
	ResultSet rs_p=null;
	PreparedStatement pstmt_p=null;
	Connect c;
	NipponBean.Array A;

	public	DebtorsCreditorsNewOver()
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

	}catch(Exception e)
	{
		//c.returnConnection(cong);
//System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;

	}
////finally{c.returnConnection(cong); }

}//exchangeGainLoss
public String ClosingDebtorsCreditors(Connection con,java.sql.Date D1,String party_id,String company_id,int d)
{
try{

String temp_ex= ""+partyexchangeGainLoss(con,party_id, company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
double purchase_gainloss =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
double sale_gainloss = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
// cong=c.getConnection();



String query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

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
double total_purchase_dollar=0;



double sales=0;
double sales_dollar=0;

double cr_purchasereturn=0;
double cr_purchasereturn_dollar=0;

double dr_salereturn=0;
double dr_salereturn_dollar=0;

double salereturn=0;
double salereturn_dollar=0;

while(rs_g.next())
	{

int  voucher_type=rs_g.getInt("Voucher_Type");
String r_id=rs_g.getString("Voucher_No");

double Local_Total= str.mathformat(rs_g.getDouble("Local_Total"),d);

double Dollar_Total=str.mathformat(rs_g.getDouble("Dollar_Total"),d);

String receive_fromid= A.getNameCondition(con, "Receive","Receive_fromid","Where  Receive_id="+r_id+"");



if((party_id.equals(receive_fromid)) &&(((2==voucher_type)||(11==voucher_type))))
{
if(2==voucher_type)
	{total_purchase +=Local_Total;
total_purchase_dollar+=Dollar_Total;


}
else{dr_salereturn +=Local_Total;
dr_salereturn_dollar+=Dollar_Total;

}
}
else{
if((1==voucher_type)&&(party_id.equals(receive_fromid)))
	{sales +=Local_Total;
    sales_dollar +=Dollar_Total;


}
if((10==voucher_type)&&(party_id.equals(receive_fromid)))
	{
	cr_purchasereturn +=Local_Total;
	
	cr_purchasereturn_dollar+=Dollar_Total;
	}


}

}
pstmt_g.close();

double purchase=total_purchase;
double purchase_dollar=total_purchase_dollar;
 
 query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_sundrycreditors=0;
double opening_sundrycreditors_dollar=0;

double opening_sundrydebtors=0;
double opening_sundrydebtors_dollar=0;
double advance_sundrycreditors=0;
double advance_sundrycreditors_dollar=0;
double advance_sundrydebtors=0;
double advance_sundrydebtors_dollar=0;

	while(rs_g.next())
	{
	opening_sundrydebtors += str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
	
	opening_sundrydebtors_dollar += str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),d);
	
	opening_sundrycreditors += str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
	opening_sundrycreditors_dollar += str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),d);
	
	
	
	
	
	
	
	
	advance_sundrycreditors += str.mathformat(rs_g.getDouble("Purchase_AdvanceLocal"),d);
	advance_sundrycreditors_dollar += str.mathformat(rs_g.getDouble("Purchase_AdvanceDollar"),d);
	
	
	advance_sundrydebtors += str.mathformat(rs_g.getDouble("Sale_AdvanceLocal"),d);
	advance_sundrydebtors_dollar += str.mathformat(rs_g.getDouble("Sale_AdvanceDollar"),d);

		
		
		}
	pstmt_g.close();
String slid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=1");
String plid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=2");


query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid+" or ledger_id="+plid+") and Transaction_Date <=? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
pstmt_g = con.prepareStatement(query);
double purchase_total = 0;
double purchase_total_dollar = 0;

double sell_total = 0;
double sell_total_dollar = 0;


double t_purchase_total = 0;
double t_purchase_total_dollar = 0;

double t_sell_total = 0;
double t_sell_total_dollar = 0;

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

double cr_purchase_dollar=0;
double dr_purchase_dollar=0;

double cr_sales=0;
double dr_sales=0;

double cr_sales_dollar=0;
double dr_sales_dollar=0;



double cr_pn=0;
double dr_pn=0;

double cr_pn_dollar=0;
double dr_pn_dollar=0;



double dc_temp[]=new double[pd_count];
double dollar_dc_temp[]=new double[pd_count];
	
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
	 dc_mode[n]=rs_g.getBoolean("Transaction_Type");
	 dc_temp[n] =str.mathformat(rs_g.getDouble("Local_Amount"),d);
	 dollar_dc_temp[n]=str.mathformat(rs_g.getDouble("Dollar_Amount"),d);
	 
	 
	 
	 ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();
//c.returnConnection(cong);

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
	{cr_sales += dc_temp[n];
	 cr_sales_dollar+=dollar_dc_temp[n];
	
	}
	
	else
	{
	dr_sales += dc_temp[n];
	dr_sales_dollar+=dollar_dc_temp[n];
	}
}//if 

if (2==ledger_type)
	{
	if(dc_mode[n])
	{
		
		cr_purchase += dc_temp[n];
		cr_purchase_dollar+=dollar_dc_temp[n];
	}
	else
	{
		dr_purchase += dc_temp[n];
	    dr_purchase_dollar+=dollar_dc_temp[n];
	
	}
}//if 


}
if (purchase_gainloss >= 0){

	dr_purchase +=purchase_gainloss;
	dr_purchase_dollar+=purchase_gainloss;
 
 }else{ 
cr_purchase +=purchase_gainloss *-1 ;
cr_purchase_dollar+=purchase_gainloss*-1;}
	if (sale_gainloss < 0){
	dr_sales +=sale_gainloss*-1;
    dr_sales_dollar+=sale_gainloss*-1;


}else{ 
	cr_sales +=sale_gainloss;
	cr_sales_dollar+=sale_gainloss;
	} 

total_purchase+=cr_purchase ;
total_purchase_dollar+=cr_purchase_dollar ;


purchase+=cr_purchase ;
purchase_dollar+=cr_purchase_dollar ;



sales+=dr_sales ;
sales_dollar+=dr_sales_dollar ;



purchase_total +=dr_purchase +cr_purchasereturn ;
purchase_total_dollar +=dr_purchase_dollar +cr_purchasereturn_dollar ;




sell_total += cr_sales + dr_salereturn;	
sell_total_dollar += cr_sales_dollar + dr_salereturn_dollar;	



double pending_purchase=purchase - purchase_total -opening_sundrycreditors;
double pending_purchase_dollar=purchase_dollar - purchase_total_dollar -opening_sundrycreditors_dollar;







double pending_sale= sales-sell_total + opening_sundrydebtors; 
double pending_sale_dollar= sales_dollar-sell_total_dollar + opening_sundrydebtors_dollar; 







return ""+pending_purchase+"/"+pending_sale+"/"+pending_purchase_dollar+"/"+pending_sale_dollar;


}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue




public String ClosingDebtorsCreditorsDollar(Connection con,java.sql.Date D1,String party_id,String company_id,int d)


{
try{

String temp_ex= ""+partyexchangeGainLoss(con,party_id, company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
double purchase_gainloss =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
double sale_gainloss = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
// cong=c.getConnection();



String query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

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
	opening_sundrydebtors += str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),d);
	
	opening_sundrycreditors += str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),d);
	
	advance_sundrycreditors += str.mathformat(rs_g.getDouble("Purchase_AdvanceDollar"),d);
	advance_sundrydebtors += str.mathformat(rs_g.getDouble("Sale_AdvanceDollar"),d);

		}
	pstmt_g.close();
String slid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=1");
String plid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=2");


query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid+" or ledger_id="+plid+") and Transaction_Date <=? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
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
	 dc_temp[n] =str.mathformat(rs_g.getDouble("Dollar_Amount"),d);
	 
	 ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();
//c.returnConnection(cong);

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



double pending_purchase=purchase - purchase_total -opening_sundrycreditors;

double pending_sale= sales-sell_total + opening_sundrydebtors; 







return ""+pending_purchase+"/"+pending_sale;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}/// end of ClosingDebtorsCreditorsDollar method 










public String ClosingAccount(Connection con,java.sql.Date D1,String party_id,String company_id,int d)
{
try{
 //cong=c.getConnection();

String temp_ex= ""+partyexchangeGainLoss(con,party_id, company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
double purchase_gainloss =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
double sale_gainloss = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);


String query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

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

double dpurchaseaccount=0;
double dpurchasereturn=0;
double dsaleaccount=0;
double ddiscount=0;
double ddiscount_total=0;
double dtotal_purchase=0;
double dsales=0;
double dcr_purchasereturn=0;
double ddr_salereturn=0;
double dsalereturn=0;

while(rs_g.next())
	{
int  voucher_type=rs_g.getInt("Voucher_Type");
String r_id=rs_g.getString("Voucher_No");

double Local_Total= str.mathformat(rs_g.getDouble("Local_Total"),d);
double Dollar_Total= str.mathformat(rs_g.getDouble("Dollar_Total"),2);

String receive_fromid= A.getNameCondition(con,"Receive","Receive_fromid","Where  Receive_id="+r_id+"");



if((party_id.equals(receive_fromid)) &&(((2==voucher_type)||(11==voucher_type))))
{
if(2==voucher_type)
	{
	total_purchase +=Local_Total;
	dtotal_purchase +=Dollar_Total;
}
else{
	dr_salereturn +=Local_Total;
	ddr_salereturn +=Dollar_Total;
	}
}
else{
if((1==voucher_type)&&(party_id.equals(receive_fromid)))
	{
	sales +=Local_Total;
	dsales +=Dollar_Total;
}
if((10==voucher_type)&&(party_id.equals(receive_fromid)))
	{
	cr_purchasereturn +=Local_Total;
	dcr_purchasereturn +=Dollar_Total;
	}


}

}
pstmt_g.close();
double purchase=total_purchase;
double dpurchase=dtotal_purchase;
 query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_sundrycreditors=0;
double opening_sundrydebtors=0;
double advance_sundrycreditors=0;
double advance_sundrydebtors=0;

double dopening_sundrycreditors=0;
double dopening_sundrydebtors=0;
double dadvance_sundrycreditors=0;
double dadvance_sundrydebtors=0;

	while(rs_g.next())
	{
	opening_sundrydebtors += str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
	
	dopening_sundrydebtors += str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),2);

	opening_sundrycreditors += str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
	
	dopening_sundrycreditors += str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),2);

	advance_sundrycreditors +=str.mathformat(rs_g.getDouble("Purchase_AdvanceLocal"),d);
	advance_sundrydebtors += str.mathformat(rs_g.getDouble("Sale_AdvanceLocal"),d);



	
	
	dadvance_sundrycreditors += str.mathformat(rs_g.getDouble("Purchase_AdvanceDollar"),2);
	dadvance_sundrydebtors += str.mathformat(rs_g.getDouble("Sale_AdvanceDollar"),2);

		}
	pstmt_g.close();
String slid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=1");
String plid=A.getNameCondition(con,"Ledger","Ledger_id","Where For_head=14 and For_headid="+party_id+" and Ledger_type=2");


query="Select * from Financial_Transaction  where (For_head=14 or For_head=9 or For_head=10)and (ledger_id="+slid+" or ledger_id="+plid+") and Transaction_Date <=? and Company_Id=?  and Active=1 order by Transaction_Date, Tranasaction_Id" ;
pstmt_g = con.prepareStatement(query);
double purchase_total = 0;
double sell_total = 0;
double t_purchase_total = 0;
double t_sell_total = 0;


double dpurchase_total = 0;
double dsell_total = 0;
double dt_purchase_total = 0;
double dt_sell_total = 0;

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

double dcr_purchase=0;
double ddr_purchase=0;
double dcr_sales=0;
double ddr_sales=0;


double dc_temp[]=new double[pd_count];
double ddc_temp[]=new double[pd_count];
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);	
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
	 
	 dc_mode[n]=rs_g.getBoolean("Transaction_Type");
	 dc_temp[n] =str.mathformat(rs_g.getDouble("Local_Amount"),d);
	 ddc_temp[n] =str.mathformat(rs_g.getDouble("Dollar_Amount"),2);
	 
	 ledger_id[n] = rs_g.getString("ledger_id");	
	 n++;
	}
pstmt_g.close();
//c.returnConnection(cong);

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
	{
		cr_sales += dc_temp[n];
		dcr_sales += ddc_temp[n];
		}
	else
	{
		dr_sales += dc_temp[n];
		ddr_sales += ddc_temp[n];
		}
}//if 

if (2==ledger_type)
	{
	if(dc_mode[n])
	{
		cr_purchase += dc_temp[n];
		dcr_purchase += ddc_temp[n];
		}
	else
	{
		dr_purchase += dc_temp[n];
		ddr_purchase += ddc_temp[n];
		}
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
dtotal_purchase+=dcr_purchase ;
purchase+=cr_purchase ;
dpurchase+=dcr_purchase ;
sales+=dr_sales ;
dsales+=ddr_sales ;
purchase_total +=dr_purchase +cr_purchasereturn ;
dpurchase_total +=ddr_purchase +dcr_purchasereturn ;
sell_total += cr_sales + dr_salereturn;	
dsell_total += dcr_sales + ddr_salereturn;	




double pending_purchase=purchase - purchase_total -opening_sundrycreditors;
double dpending_purchase=dpurchase - dpurchase_total -dopening_sundrycreditors;

double pending_sale= sales-sell_total + opening_sundrydebtors; 
double dpending_sale= dsales-dsell_total + dopening_sundrydebtors; 






return ""+pending_purchase+"/"+dpending_purchase+"/"+pending_sale+"/"+dpending_sale;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue






public String ClosingDebtorsCreditors(Connection con,java.sql.Date D1, String company_id,int d)
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
	
	opening_sundrydebtors[i] = str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
	opening_sundrycreditors [i]= str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
	
	opening_pn[i] = str.mathformat(rs_g.getDouble("Opening_PNLocalBalance"),d);
	i++;
		}
	pstmt_g.close();


query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setString(2,""+D1);
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
pstmt_g.setString(2,""+D1);
rs_g = pstmt_g.executeQuery();	
j=0;

while(rs_g.next())
	{

String r_id=rs_g.getString("Voucher_No");
Local_Total[j]= str.mathformat(rs_g.getDouble("Local_Total"),d);

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

String temp_ex= ""+partyexchangeGainLoss(con,""+party_id[i], company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
purchase_gainloss[i] =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
 sale_gainloss[i] = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);

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
	pstmt_g.setString(1,""+D1);
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
local +=pn_localamount;
if(pn_localamount>0)
	{dr_total +=pn_localamount;}
else { cr_total +=(pn_localamount * -1);}

	}//while
 pstmt_g.close();
//c.returnConnection(cong);

pending_pn[i]=local;
	}

String tempr="";
for(i=0; i<partycounter; i++)
	{
tempr = tempr + "#"+name[i]+ "#" +pending_purchase[i]+ "#" +pending_sale[i]+ "#" +pending_pn[i] ;
	}



return tempr;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue


///
public String ClosingDebtorsCreditors(Connection con,java.sql.Date D1, String company_id,int d,String CreditLimit)
{
try{
String query="";
 //cong=c.getConnection();

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
double credit_limit[]=new double[partycounter];
int party_id[]=new int[partycounter]; 
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id);
	rs_g = pstmt_g.executeQuery();	
i=0;
	while(rs_g.next())
	{
	party_id[i]=rs_g.getInt("Companyparty_id");
	name[i]=rs_g.getString("CompanyParty_Name");
	opening_sundrydebtors[i] = str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
	
	opening_sundrycreditors [i]= str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
	
	opening_pn[i] = str.mathformat(rs_g.getDouble("Opening_PNLocalBalance"),d);
credit_limit[i]=str.mathformat(rs_g.getDouble("Credit_Limit"),d);
	i++;
		}
	pstmt_g.close();


query="Select * from voucher where Company_Id=? and (voucher_type=1 or voucher_type=2 or voucher_type=10 or Voucher_type=11)  and Active=1  and Voucher_Date<=?  order by Voucher_Date,Voucher_id";

pstmt_g = con.prepareStatement(query);

//pstmt_g.setDate(1,D1);
pstmt_g.setString(1,company_id); 
pstmt_g.setString(2,""+D1);
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
pstmt_g.setString(2,""+D1);
rs_g = pstmt_g.executeQuery();	
j=0;

while(rs_g.next())
	{

String r_id=rs_g.getString("Voucher_No");
Local_Total[j]= str.mathformat(rs_g.getDouble("Local_Total"),d);

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
// out.print("<br>192party_id[i]="+party_id[i]);
j=0;
String temp_ex= ""+partyexchangeGainLoss(con,""+party_id[i], company_id,D1);
StringTokenizer tempe = new StringTokenizer(temp_ex,"/");
purchase_gainloss[i] =str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);
 sale_gainloss[i] = str.mathformat(Double.parseDouble( (String)tempe.nextElement()),d);

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
	pstmt_g.setString(1,""+D1);
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
local +=pn_localamount;
if(pn_localamount>0)
	{dr_total +=pn_localamount;}
else { cr_total +=(pn_localamount * -1);}

	}//while
 pstmt_g.close();
//c.returnConnection(cong);


pending_pn[i]=local;
	}

String tempr="";
for(i=0; i<partycounter; i++)
	{
tempr = tempr + "#"+name[i]+ "#" +pending_purchase[i]+ "#" +pending_sale[i]+ "#" +pending_pn[i]+"#"+credit_limit[i];
	}



return tempr;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}

///






public String ClosingDebtorsCreditors(Connection con,java.sql.Date D1,String party_id,String company_id,String type)
{
try{
//System.out.print("Inside 130");
// cong=c.getConnection();

String query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_sundrycreditors=0;
double opening_sundrydebtors=0;
double advance_sundrycreditors=0;
double advance_sundrydebtors=0;

	while(rs_g.next())
	{
	
	opening_sundrydebtors += rs_g.getDouble("Opening_RLocalBalance");
	
	opening_sundrycreditors += rs_g.getDouble("Opening_PLocalBalance");
	
	advance_sundrycreditors += rs_g.getDouble("Purchase_AdvanceLocal");
	advance_sundrydebtors += rs_g.getDouble("Sale_AdvanceLocal");

		}
	pstmt_g.close();



query="Select * from Receive R , Payment_Details PD  where R.Receive_Id = PD.for_Headid  and R.Receive_Date <=? and R.Company_id="+company_id+" and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0 and R.Receive_FromId=? order by R.Receive_Id ";
pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,party_id); 
	rs_g = pstmt_g.executeQuery();	

double purchase_total = 0;
double sell_total = 0;
double t_purchase_total = 0;
double t_sell_total = 0;
int old_receive_id = 0;
	
	int n=0;
	while(rs_g.next())
	{
	int temp_receive_id = rs_g.getInt("Receive_Id");
	String receive_sell = rs_g.getString("Receive_Sell");	

	if("1".equals(receive_sell))
		{
			t_purchase_total = rs_g.getDouble("Local_Amount");
			purchase_total += t_purchase_total;	

		}
	else{
			t_sell_total = rs_g.getDouble("Local_Amount");
			sell_total += t_sell_total;	
		}
	}
	pstmt_g.close();

//if("Closing".equals(type))

	{
	purchase_total +=advance_sundrycreditors;
sell_total += advance_sundrydebtors;	
	}
query="Select * from Receive  where Receive_Date <=? and Company_id="+company_id+" and Purchase=1  and Active=1  and Receive_FromId=?  and Opening_Stock=0 and Return=0 and Active=1 order by receive_date ,receive_no";
pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,party_id); 
	rs_g = pstmt_g.executeQuery();	

double slocal_total=0; 
double sexport_total=0; 
 double local_total=0; 
double import_total=0; 
double sales=0;
double purchase=0;
double local_local=0; 
double dollar_dollar=0; 
double closing =0;
while(rs_g.next())
	{
String receive_id =rs_g.getString("Receive_id");	
String receive_sell=rs_g.getString("Receive_Sell");
String receive_currency= rs_g.getString("Receive_CurrencyId");
local_local=rs_g.getDouble("Local_Total");
dollar_dollar=rs_g.getDouble("Dollar_Total");


if("1".equals(receive_sell))
{
purchase += local_local;
closing +=local_local;
 if("0".equals(receive_currency))
	{import_total += local_local;}
else{local_total += local_local;}
}
else
{
//closing = closing -local;
sales += local_local;
 if("0".equals(receive_currency))
	{sexport_total += local_local;}
else{slocal_total += local_local;}
}
	}//while
	pstmt_g.close();
//	c.returnConnection(cong);

double pending_purchase=purchase - purchase_total -opening_sundrycreditors;
double pending_sale= sales-sell_total + opening_sundrydebtors; 
//System.out.print("pending_purchase"+pending_purchase);

return ""+pending_purchase+"/"+pending_sale;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue



public String cgtSalePurchase(Connection con,java.sql.Date D1,String party_id,String company_id)
{
try{
 //cong=c.getConnection();

String query="Select * from Receive R ,Receive_Transaction RT  where R.Receive_Id = RT.Receive_Id  and R.Receive_Date <=? and R.Company_id="+company_id+" and R.Purchase=0 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0 and R.Receive_FromId=? order by R.Receive_Id ";
pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,party_id); 
	rs_g = pstmt_g.executeQuery();	

double purchase_total = 0;
double purchase_total_dollar = 0;
double sell_total = 0;
double sell_total_dollar = 0;
double t_purchase_total = 0;
double t_purchase_total_dollar = 0;
double t_sell_total = 0;
int old_receive_id = 0;
	
	int n=0;
	while(rs_g.next())
	{
	int temp_receive_id = rs_g.getInt("Receive_Id");
	String receive_sell = rs_g.getString("Receive_Sell");	
	//double available_quantity= rs_g.getDouble("Available_Quantity");
	double available_quantity= rs_g.getDouble("Quantity");
	double tax=rs_g.getDouble("tax");
	double tax_amt=0;
	double tax_amt_dollar=0;
	double temp=0;
	double temp_dollar=0;
	t_purchase_total = rs_g.getDouble("Local_Price");
	//purchase_total_dollar
	t_purchase_total_dollar=rs_g.getDouble("Dollar_Price");
	
	temp=(t_purchase_total*available_quantity);	
	tax_amt=temp*tax/100;
	temp_dollar=(t_purchase_total_dollar*available_quantity);	
	tax_amt_dollar=temp_dollar*tax/100;

	if("1".equals(receive_sell))
		{purchase_total += temp+tax_amt;
	     purchase_total_dollar+=temp_dollar+tax_amt_dollar;
	}
	else{	sell_total += temp+tax_amt;	
			sell_total_dollar+=temp_dollar+tax_amt_dollar;
	      }
	}

pstmt_g.close();
//c.returnConnection(cong);




return ""+purchase_total+"/"+sell_total+"/"+purchase_total_dollar+"/"+sell_total_dollar;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue



public String pnSalePurchase(Connection con,java.sql.Date D1,String party_id,String company_id)
{
try{
// cong=c.getConnection();
String query="Select * from PN  where PN_Date <=? and Company_id=? and To_FromId="+party_id+" and Active=1 and PN_Status=0 order by PN_Status, PN_Date,PN_No";
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	




double pn_localamount=0;
double pn_dollaramount=0;
double cr_total=0;
double cr_total_dollar=0;
double dr_total=0;
double dr_total_dollar=0;
while(rs_g.next())
{

pn_localamount=rs_g.getDouble("PN_LocalAmount");
pn_dollaramount=rs_g.getDouble("PN_DollarAmount");


if(pn_localamount>0)
	{
	dr_total +=pn_localamount;
    dr_total_dollar+=pn_dollaramount;
    }

else { 
	cr_total +=(pn_localamount * -1);
    cr_total_dollar+=(pn_dollaramount*-1);
    }

	}//while
 pstmt_g.close();
// c.returnConnection(cong);

return ""+dr_total+"/"+cr_total+"/"+dr_total_dollar+"/"+cr_total_dollar;

}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(conp); }

	}//stockValue


public String pnClosing(Connection con,java.sql.Date D1,String party_id,String company_id, int d)
{
try{

// cong=c.getConnection();
String query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_pn=0;

	while(rs_g.next())
	{
	opening_pn += str.mathformat(rs_g.getDouble("Opening_PNLocalBalance"),d);

		}
	pstmt_g.close();

 query="Select * from PN  where PN_Date <=? and Company_id=? and To_FromId="+party_id+" and Active=1 and PN_Status=0 order by PN_Status, PN_Date,PN_No";
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	




double pn_localamount=0;
double pn_dollaramount=0;
double local=opening_pn;
double cr_total=0;
double dr_total=0;
while(rs_g.next())
{
pn_localamount= str.mathformat(rs_g.getDouble("PN_LocalAmount"),d);
pn_dollaramount= str.mathformat(rs_g.getDouble("PN_DollarAmount"),2);
local +=pn_localamount;
if(pn_localamount>0)
	{dr_total +=pn_localamount;}
else { cr_total +=(pn_localamount * -1);}

	}//while
 pstmt_g.close();
 //c.returnConnection(cong);


return ""+local;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue


public String pnClosingDollar(Connection con,java.sql.Date D1,String party_id,String company_id, int d)
{
try{

// cong=c.getConnection();
String query="Select * from Master_CompanyParty where CompanyParty_id=?  and Active=1 ";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,party_id);
	rs_g = pstmt_g.executeQuery();	
double opening_pn=0;
double dopening_pn=0;

	while(rs_g.next())
	{
	opening_pn += str.mathformat(rs_g.getDouble("Opening_PNLocalBalance"),d);
	dopening_pn += str.mathformat(rs_g.getDouble("Opening_PNDollarBalance"),2);

		}
	pstmt_g.close();

 query="Select * from PN  where PN_Date <=? and Company_id=? and To_FromId="+party_id+" and Active=1 and PN_Status=0 order by PN_Status, PN_Date,PN_No";
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	




double pn_localamount=0;
double pn_dollaramount=0;
double local=opening_pn;
double dollar=dopening_pn;
double cr_total=0;
double dr_total=0;
while(rs_g.next())
{
pn_localamount= str.mathformat(rs_g.getDouble("PN_LocalAmount"),d);
pn_dollaramount= str.mathformat(rs_g.getDouble("PN_DollarAmount"),2);
local +=pn_localamount;
dollar +=pn_dollaramount;
if(pn_localamount>0)
	{dr_total +=pn_localamount;}
else { cr_total +=(pn_localamount * -1);}

	}//while
 pstmt_g.close();
 //c.returnConnection(cong);

return ""+local+"/"+dollar;
}catch(Exception Samyak109)
	{//c.returnConnection(cong);
return ""+Samyak109;
	}
//finally{c.returnConnection(cong); }

	}//stockValue



//adding a method to calculate the pending consignment sale quantity in local as well as dollar values
public String cgtSalePending(Connection con,java.sql.Date D1,String party_id,String company_id, int d)
{
String errLine = "1847";
try{
	double cgt_qty = 0;
	double cgt_local_total = 0;
	double cgt_dollar_total = 0;

	double av_qty = 0;
	double av_localtotal = 0;
	double av_dollartotal = 0;

	//gettting the consignment sale
	ArrayList CgtRT_Id = new ArrayList();
	ArrayList CgtRT_Qty = new ArrayList();
	ArrayList CgtRT_LocalPrice = new ArrayList();
	ArrayList CgtRT_DollarPrice = new ArrayList();
	
	errLine = "1863";
	String query="Select RT.ReceiveTransaction_Id, RT.Quantity, RT.Local_Price, RT.Dollar_Price from  Receive R , receive_transaction RT  where R.receive_id=RT.receive_id  and R.Receive_Sell=0 and R.purchase=0 and R.Receive_Date <= ? and R.Company_id=? and R.Active=1 and RT.Active=1 and R.Receive_FromId="+party_id+" and R.R_Return=0 ";
	
	//System.out.println(query);
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		String rt_id = rs_g.getString("ReceiveTransaction_Id");
		double Quantity = rs_g.getDouble("Quantity");
		double Local_Price = rs_g.getDouble("Local_Price");
		double Dollar_Price = rs_g.getDouble("Dollar_Price");
		CgtRT_Id.add(rt_id);
		CgtRT_Qty.add(Quantity);
		CgtRT_LocalPrice.add(Local_Price);
		CgtRT_DollarPrice.add(Dollar_Price);
	}
	pstmt_g.close();
	errLine = "1884";

	for(int z=0; z<CgtRT_Id.size(); z++)
	{
	
		query="Select Sum(Quantity) as ConfirmReturnCount from  receive_transaction RT  where RT.Active=1 and RT.Consignment_ReceiveId = "+ (String) CgtRT_Id.get(z);
		pstmt_g = con.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();	
		
		while(rs_g.next())
		{
			double ConfirmReturnCount = rs_g.getDouble("ConfirmReturnCount");
			double CgtSaleQty = (Double)CgtRT_Qty.get(z);
			double localprice = (Double)CgtRT_LocalPrice.get(z);
			double dollarprice = (Double)CgtRT_DollarPrice.get(z);
			double pendingQty = CgtSaleQty - ConfirmReturnCount;
		
			av_qty += pendingQty;
			av_localtotal += pendingQty * localprice;
			av_dollartotal += pendingQty * dollarprice;
		}
		
		pstmt_g.close();
		errLine = "1907";
	}//end of for		

	return ""+av_localtotal+"/"+av_dollartotal;
}catch(Exception Samyak109)
	{
		Samyak109.printStackTrace();
		return " Error in cgtSalePending() in the file DebtorsCreditorsNewOver.java after line errLine:"+errLine+" is ="+Samyak109;
		
	}


}//cgtSalePending()

//adding a method to calculate the pending consignment sale quantity in local as well as dollar values
public String cgtPurchasePending(Connection con,java.sql.Date D1,String party_id,String company_id, int d)
{
String errLine = "1923";
try{
	double cgt_qty = 0;
	double cgt_local_total = 0;
	double cgt_dollar_total = 0;

	double av_qty = 0;
	double av_localtotal = 0;
	double av_dollartotal = 0;

	//gettting the consignment purchase
	ArrayList CgtRT_Id = new ArrayList();
	ArrayList CgtRT_Qty = new ArrayList();
	ArrayList CgtRT_LocalPrice = new ArrayList();
	ArrayList CgtRT_DollarPrice = new ArrayList();
	
	errLine = "1863";
	String query="Select RT.ReceiveTransaction_Id, RT.Quantity, RT.Local_Price, RT.Dollar_Price from  Receive R , receive_transaction RT  where R.receive_id=RT.receive_id  and R.Receive_Sell=1 and R.purchase=0 and R.Receive_Date <= ? and R.Company_id=? and R.Active=1 and RT.Active=1 and R.Receive_FromId="+party_id+" and R.R_Return=0 ";
	
	//System.out.println(query);
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		String rt_id = rs_g.getString("ReceiveTransaction_Id");
		double Quantity = rs_g.getDouble("Quantity");
		double Local_Price = rs_g.getDouble("Local_Price");
		double Dollar_Price = rs_g.getDouble("Dollar_Price");
		CgtRT_Id.add(rt_id);
		CgtRT_Qty.add(Quantity);
		CgtRT_LocalPrice.add(Local_Price);
		CgtRT_DollarPrice.add(Dollar_Price);
	}
	pstmt_g.close();
	errLine = "1959";

	for(int z=0; z<CgtRT_Id.size(); z++)
	{
	
		query="Select Sum(Quantity) as ConfirmReturnCount from  receive_transaction RT  where RT.Active=1 and RT.Consignment_ReceiveId = "+ (String) CgtRT_Id.get(z);
		pstmt_g = con.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();	
		
		while(rs_g.next())
		{
			double ConfirmReturnCount = rs_g.getDouble("ConfirmReturnCount");
			double CgtSaleQty = (Double)CgtRT_Qty.get(z);
			double localprice = (Double)CgtRT_LocalPrice.get(z);
			double dollarprice = (Double)CgtRT_DollarPrice.get(z);
			double pendingQty = CgtSaleQty - ConfirmReturnCount;
		
			av_qty += pendingQty;
			av_localtotal += pendingQty * localprice;
			av_dollartotal += pendingQty * dollarprice;
		}
		
		pstmt_g.close();
		errLine = "1982";
	}//end of for		

	return ""+av_localtotal+"/"+av_dollartotal;
}catch(Exception Samyak109)
	{
		Samyak109.printStackTrace();
		return " Error in cgtPurchasePending() in the file DebtorsCreditorsNewOver.java after line errLine:"+errLine+" is ="+Samyak109;
		
	}


}//cgtPurchasePending()



	public static void main(String[] args) throws Exception
	{

		DebtorsCreditorsNewOver l = new DebtorsCreditorsNewOver();
	
	}
}


