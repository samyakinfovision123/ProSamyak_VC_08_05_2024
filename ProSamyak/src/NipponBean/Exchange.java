package NipponBean;
import java.util.*;
import java.sql.*;
import NipponBean.*;

public class  Exchange
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connect1 c;
	public	Exchange()
		{
		
		/*	try{
		c=new Connect1();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/
		
		}
	

public String exchangeGainLoss(Connection con,String company_id,java.sql.Date D1, java.sql.Date D2) 
{
try{
 //cong=c.getConnection();

String query="";
query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId  and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0 and R.Receive_CurrencyId=0 and PD.Active=1 order by R.Receive_id";

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
//System.out.println("err;;;"+PURCHASE_GAINLOSS+"/"+salePURCHASE_GAINLOSS);
FINAL_GAINLOSS=PURCHASE_GAINLOSS-salePURCHASE_GAINLOSS;
return ""+PURCHASE_GAINLOSS+"/"+salePURCHASE_GAINLOSS;

	}catch(Exception e)
	{//c.returnConnection(cong);
	System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;
	}

}//exchangeGainLoss 


public String partyexchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
{
try{
 //cong=c.getConnection();

String query="";
query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and R.Receive_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 order by R.Receive_id";

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

	}catch(Exception e)
	{//c.returnConnection(cong);
	System.out.print("<BR>EXCEPTION=" +e);
	return ""+e;
	}

}//exchangeGainLoss 


	public static void main(String[] args) throws Exception
	{

		Exchange E = new Exchange();
	
	}
}


