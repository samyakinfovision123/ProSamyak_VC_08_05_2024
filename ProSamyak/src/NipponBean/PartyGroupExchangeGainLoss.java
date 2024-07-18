package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.*;
import NipponBean.*;

public class  PartyGroupExchangeGainLoss
{
	ResultSet rs_g=null;
	PreparedStatement pstmt=null;
	String query="";
	public String getSaleExchangeGainLoss(Connection cong,String party_group_id,String company_id,java.sql.Date D1,java.sql.Date D2)
	{
		double st_purchase_gainloss=0;
		double st_purchase_gainloss_dollar=0;
		double salePURCHASE_GAINLOSS=0;
		double salePURCHASE_GAINLOSS_DOLLAR=0;
		double st_old_exrate=0;
		try{
		String company_id_list="0";
		query ="Select MCP.companyParty_ID from Ledger as L, Master_CompanyParty as MCP where For_Head=14 and For_HeadId=CompanyParty_Id and L.Active=1 and MCP.Active=1 AND MCP.Company_Id="+company_id+" and L.Company_Id="+company_id+"  and L.Ledger_Type=1 and L.PartyGroup_Id="+party_group_id;
		pstmt = cong.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt.executeQuery();	
		while(rs_g.next()) 
		{
			if(rs_g.isLast())
			{
			company_id_list=company_id_list+""+rs_g.getInt("companyParty_ID");
			}//if
			else
			{
				company_id_list=company_id_list+""+rs_g.getInt("companyParty_ID")+",";
			} //else
		}//while
		pstmt.close();
		
		query="Select R.receive_id,R.Receive_Sell,R.Receive_FromId,R.Exchange_Rate, PD.Local_Amount, PD.Dollar_Amount from Receive R, Payment_Details PD where R.Receive_Id=PD.For_HeadId  and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0 and R.Active=1 and PD.Active=1 and R.R_Return=0 and R.Receive_CurrencyId=0 and R.Receive_Sell=0 and R.Receive_FromId in ("+company_id_list+") order by R.Receive_id";	
		pstmt = cong.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,""+company_id);
		rs_g = pstmt.executeQuery();	
		
		while(rs_g.next()) 
		{
			st_old_exrate = rs_g.getDouble("Exchange_Rate");
			double slocal_amount  = rs_g.getDouble("Local_Amount");
			double sdollar_amount = rs_g.getDouble("Dollar_Amount");	
			//st_total_dollar = st_total_dollar + sdollar_amount; 
				
			st_purchase_gainloss = (st_old_exrate*sdollar_amount) - (slocal_amount);
			st_purchase_gainloss_dollar=st_purchase_gainloss/st_old_exrate;
				
			salePURCHASE_GAINLOSS = salePURCHASE_GAINLOSS + (st_purchase_gainloss);
			salePURCHASE_GAINLOSS_DOLLAR = salePURCHASE_GAINLOSS_DOLLAR +(st_purchase_gainloss_dollar);
			//total transaction amount 
		}
		
		pstmt.close();
		//System.out.println(""+salePURCHASE_GAINLOSS+"#"+salePURCHASE_GAINLOSS_DOLLAR);
		}//try
		catch(Exception e)
		{
			System.out.println("Exception e="+e);
			
			
		}
	return ""+salePURCHASE_GAINLOSS+"#"+salePURCHASE_GAINLOSS_DOLLAR;
	} //getSaleExchangeGainLoss()

	public String getPurchaseExchangeGainLoss(Connection cong,String party_group_id,String company_id,java.sql.Date D1,java.sql.Date D2)
	{
		double st_purchase_gainloss=0;
		double st_purchase_gainloss_dollar=0;
		double salePURCHASE_GAINLOSS=0;
		double salePURCHASE_GAINLOSS_DOLLAR=0;
		double st_old_exrate=0;
		try
		{
		String company_id_list="0";
		query ="Select MCP.companyParty_ID from Ledger as L, Master_CompanyParty as MCP where For_Head=14 and For_HeadId=CompanyParty_Id and L.Active=1 and MCP.Active=1 AND MCP.Company_Id="+company_id+" and L.Company_Id="+company_id+"  and L.Ledger_Type=2 and L.PartyGroup_Id="+party_group_id;
		pstmt = cong.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		
		rs_g = pstmt.executeQuery();	
		while(rs_g.next()) 
		{
			if(rs_g.isLast())
			{
				company_id_list=company_id_list+""+rs_g.getInt("companyParty_ID");
			}//if
			else
			{
				company_id_list=company_id_list+""+rs_g.getInt("companyParty_ID")+",";
			} //else
		}//while
		pstmt.close();
		
		query="Select R.receive_id,R.Receive_Sell,R.Receive_FromId,R.Exchange_Rate, PD.Local_Amount, PD.Dollar_Amount from Receive R, Payment_Details PD where R.Receive_Id=PD.For_HeadId  and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0 and R.Active=1 and PD.Active=1 and R.R_Return=0 and R.Receive_CurrencyId=0 and R.Receive_Sell=1 and R.Receive_FromId in ("+company_id_list+") order by R.Receive_id";	
		pstmt = cong.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,""+company_id);
		rs_g = pstmt.executeQuery();	
		
		while(rs_g.next()) 
		{
			st_old_exrate = rs_g.getDouble("Exchange_Rate");
			double slocal_amount  = rs_g.getDouble("Local_Amount");
			double sdollar_amount = rs_g.getDouble("Dollar_Amount");	
			//st_total_dollar = st_total_dollar + sdollar_amount; 
				
			st_purchase_gainloss = (st_old_exrate*sdollar_amount) - (slocal_amount);
			st_purchase_gainloss_dollar=st_purchase_gainloss/st_old_exrate;
				
			salePURCHASE_GAINLOSS = salePURCHASE_GAINLOSS + (st_purchase_gainloss);
			salePURCHASE_GAINLOSS_DOLLAR = salePURCHASE_GAINLOSS_DOLLAR +(st_purchase_gainloss_dollar);
			//total transaction amount 
		}
		
		pstmt.close();
		//System.out.println(""+salePURCHASE_GAINLOSS+"#"+salePURCHASE_GAINLOSS_DOLLAR);
		}//try
		catch(Exception e)
		{
			System.out.println("Exception e="+e);
		}
		
		return ""+salePURCHASE_GAINLOSS+"#"+salePURCHASE_GAINLOSS_DOLLAR;
	} //getSaleExchangeGainLoss()
}	