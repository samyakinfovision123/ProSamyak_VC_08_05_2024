package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;

import NipponBean.*;

public class PurchaseSaleGroupAccount 
{

	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	PreparedStatement pstmt_p=null;
	public	PurchaseSaleGroupAccount()
		{
			
		}


	public double getPurchaseGroupAccount(Connection con, java.sql.Date D1, java.sql.Date D2, String company_id, String purchasesalegroup_id)
	//get the purchase account group wise
	{
		double purchaseaccount=0;
		double import_total=0;
		double local_total=0;
		double total_purchase=0;
		
		try{
		String query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Active=1  and Receive_FromId not like "+company_id+"  and Opening_Stock=0 and Active=1 and PurchaseSaleGroup_Id="+purchasesalegroup_id+" order by receive_date ,receive_no";
		pstmt_g = con.prepareStatement(query);

		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);	
		pstmt_g.setString(3,company_id); 
		rs_g = pstmt_g.executeQuery();	


		while(rs_g.next())
		{

			boolean receive_sell=rs_g.getBoolean("Receive_Sell");
			
			String receive_currency= rs_g.getString("Receive_CurrencyId");
			
			double receive_total= rs_g.getDouble("Local_Total");
			
			
			boolean returned=rs_g.getBoolean("R_Return");
			double inv_total=rs_g.getDouble("InvLocalTotal");
			
			double templocal_local=inv_total;
			

			if((receive_sell)&&(!returned))
			{
				purchaseaccount +=inv_total;
				total_purchase +=receive_total;
				if("0".equals(receive_currency))
					{import_total += templocal_local;}
				else
					{local_total += templocal_local;}
			}
		}
		pstmt_g.close();
		}
		catch(Exception e){
			System.out.println("Exception in PurchaseSaleGroupAccount.java method getPurchaseGroupAccount() : "+e);
		}

		return purchaseaccount;

	}//getPurchaseGroupAccount() end



//// not here


	public double getPurchaseReturnGroupAccount(Connection con, java.sql.Date D1, java.sql.Date D2, String company_id, String purchasesalegroup_id)
	//get the purchase account group wise
	{
		double purchasereturn=0;
		double import_total=0;
		double local_total=0;
		double total_purchase=0;
		double inv_total=0;
		try{
		String query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Active=1  and Receive_FromId not like "+company_id+"  and Opening_Stock=0 and Active=1 and PurchaseSaleGroup_Id="+purchasesalegroup_id+" order by receive_date ,receive_no";
		pstmt_g = con.prepareStatement(query);

		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);	
		pstmt_g.setString(3,company_id); 
		rs_g = pstmt_g.executeQuery();	


		while(rs_g.next())
		{

			boolean receive_sell=rs_g.getBoolean("Receive_Sell");
			String receive_currency= rs_g.getString("Receive_CurrencyId");
			
			double receive_total= rs_g.getDouble("Local_Total");
			double templocal_local=inv_total;
			
			boolean returned=rs_g.getBoolean("R_Return");
		    inv_total=rs_g.getDouble("InvLocalTotal");
			
			

			if((!receive_sell)&&(returned))
			{
				purchasereturn += inv_total;
			}
		}
		pstmt_g.close();
		}
		catch(Exception e){
			System.out.println("Exception in PurchaseSaleGroupAccount.java method getPurchaseReturnGroupAccount() : "+e);
		}

		return purchasereturn;

	}//getPurchaseReturnGroupAccount() end



	public double getSaleGroupAccount(Connection con, java.sql.Date D1, java.sql.Date D2, String company_id, String purchasesalegroup_id)
	//get the sale account group wise
	{
		double saleaccount=0;
		double export_total=0;
		double local_total=0;
		double sales=0;
		double inv_total=0;
		try{
		String query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Active=1  and Receive_FromId not like "+company_id+"  and Opening_Stock=0 and Active=1 and PurchaseSaleGroup_Id="+purchasesalegroup_id+" order by receive_date ,receive_no";
		pstmt_g = con.prepareStatement(query);

		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);	
		pstmt_g.setString(3,company_id); 
		rs_g = pstmt_g.executeQuery();	


		while(rs_g.next())
		{

			boolean receive_sell=rs_g.getBoolean("Receive_Sell");
			double templocal_local=inv_total;
			String receive_currency= rs_g.getString("Receive_CurrencyId");

			double receive_total= rs_g.getDouble("Local_Total");

			boolean returned=rs_g.getBoolean("R_Return");
			 inv_total=rs_g.getDouble("InvLocalTotal");
			
			
			if((!receive_sell)&&(!returned))
			{
				sales +=receive_total;
				saleaccount += inv_total;
				 if("0".equals(receive_currency))
					{export_total += templocal_local;}
				else
					{local_total += templocal_local;}

			}
		}
		pstmt_g.close();
		}
		catch(Exception e){
			System.out.println("Exception in PurchaseSaleGroupAccount.java method getSaleGroupAccount() : "+e);
		}

		return saleaccount;

	}//getSaleGroupAccount() end


	public double getSaleReturnGroupAccount(Connection con, java.sql.Date D1, java.sql.Date D2, String company_id, String purchasesalegroup_id)
	//get the sale account group wise
	{
		double salereturn=0;
		double import_total=0;
		double local_total=0;
		double total_purchase=0;
		double inv_total=0;
		try{
		String query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Active=1  and Receive_FromId not like "+company_id+"  and Opening_Stock=0 and Active=1 and PurchaseSaleGroup_Id="+purchasesalegroup_id+" order by receive_date ,receive_no";
		pstmt_g = con.prepareStatement(query);

		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);	
		pstmt_g.setString(3,company_id); 
		rs_g = pstmt_g.executeQuery();	


		while(rs_g.next())
		{

			boolean receive_sell=rs_g.getBoolean("Receive_Sell");

			double templocal_local=inv_total;
			String receive_currency= rs_g.getString("Receive_CurrencyId");
			
			double receive_total= rs_g.getDouble("Local_Total");

			boolean returned=rs_g.getBoolean("R_Return");
			 inv_total=rs_g.getDouble("InvLocalTotal");
			
			

			if((receive_sell)&&(returned))
			{
				salereturn +=inv_total;
			}
		}
		pstmt_g.close();
		}
		catch(Exception e){
			System.out.println("Exception in PurchaseSaleGroupAccount.java method getSaleReturnGroupAccount() : "+e);
		}

		return salereturn;

	}//getSaleReturnGroupAccount() end



	public static void main(String[] args) throws Exception
	{

		//Stock l = new Stock();
	
	}
}

