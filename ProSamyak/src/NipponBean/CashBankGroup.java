package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  CashBankGroup
{
	ResultSet rs=null;
	PreparedStatement pstmt=null;

	HashMap accountName = new HashMap();

	//stores the opening of the accounts
	HashMap accountLocalOpening = new HashMap();
	HashMap accountDollarOpening = new HashMap();

	//stores the transactions between a given period
	HashMap accountLocalTransDr = new HashMap();
	HashMap accountLocalTransCr = new HashMap();
	HashMap accountDollarTransDr = new HashMap();
	HashMap accountDollarTransCr = new HashMap();

	//stores the closing of the accounts
	//HashMap accountLocalClosing = new HashMap();
	//HashMap accountDollarClosing = new HashMap();
	
	
	//method that will give the opening for the accounts in a selected Finance Head at a given date
	public void getAccountOpening(Connection con, String company_id, String For_Head, String yearendId, java.sql.Date D1)
	{
		String errLine = "34";
		String query = "";
		accountName.clear();
		accountLocalOpening.clear();
		accountDollarOpening.clear();

		try{
		
		
		query="Select Account_Id, Account_Name, Opening_LocalBalance, Opening_DollarBalance from Master_Account where Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Account_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Account_Id");
			String name = rs.getString("Account_Name");
			Double lopen = new Double ( rs.getDouble("Opening_LocalBalance") );
			Double dopen = new Double ( rs.getDouble("Opening_DollarBalance") );
		
			accountName.put(id, name);
			accountLocalOpening.put(id, lopen);
			accountDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "62";

		//get all the dr. enteries for the given account group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.For_HeadId, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and FT.transaction_type=0 and FT.Transaction_Date < ? and FT.For_Head="+For_Head+" group by FT.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");

			double localOpening = ((Double)accountLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)accountDollarOpening.get(id)).doubleValue();

			localOpening += rs.getDouble("addLocalAmt");
			dollarOpening += rs.getDouble("addDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			accountLocalOpening.put(id, lopen);
			accountDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "92";

		//get all the cr. enteries for the given account group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.For_HeadId, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and FT.transaction_type=1 and FT.Transaction_Date < ? and FT.For_Head="+For_Head+" group by FT.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");

			double localOpening = ((Double)accountLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)accountDollarOpening.get(id)).doubleValue();

			localOpening -= rs.getDouble("delLocalAmt");
			dollarOpening -= rs.getDouble("delDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			accountLocalOpening.put(id, lopen);
			accountDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "122";
		}catch(Exception e)
		{
			System.out.println("Exception in file CashBankGroup.java at method getAccountOpening() after line="+errLine+" :" +e);
		}
	
	}//getAccountOpening


	//method that will give the transactions for the accounts in a selected Finance Head for a given date range
	public void getAccountTrans(Connection con, String company_id, String For_Head, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "134";
		String query = "";
	
		try{
		
		//get all the dr. enteries for the given account group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.For_HeadId, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT where FT.Company_Id ="+company_id+" and FT.Active=1 and FT.transaction_type=0 and  FT.Transaction_Date between ? and ? and FT.For_Head="+For_Head+" group by FT.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");

			Double lopen = new Double ( rs.getDouble("addLocalAmt") );
			Double dopen = new Double ( rs.getDouble("addDollarAmt") );
		
			accountLocalTransDr.put(id, lopen);
			accountDollarTransDr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "161";

		//get all the cr. enteries for the given account group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.For_HeadId, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT where FT.Company_Id ="+company_id+" and FT.Active=1 and FT.transaction_type=1 and  FT.Transaction_Date between ? and ? and FT.For_Head="+For_Head+" group by FT.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");

			Double lopen = new Double ( rs.getDouble("delLocalAmt") );
			Double dopen = new Double ( rs.getDouble("delDollarAmt") );
		
			accountLocalTransCr.put(id, lopen);
			accountDollarTransCr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "185";

		}catch(Exception e)
		{
			System.out.println("Exception in file CashBankGroup.java at method getAccountTrans() after line="+errLine+" :" +e);
		}
	
	}//getAccountTrans

	//method that will give the opening, transactions and closing for the accounts in a selected Finance Head for a given date range
	public ArrayList getAccountRows(Connection con, String company_id, String For_Head, String yearendId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "197";
		String query = "";
		ArrayList reportList = new ArrayList();
	
		try{
		getAccountOpening(con, company_id, For_Head, yearendId, D1);
		getAccountTrans(con, company_id, For_Head, D1, D2);

		query="Select Account_Id from Master_Account where Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Account_Id";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Account_Id");

			String name = (String)accountName.get(id);
		
			//get the opening
			double localOpening = 0;
			double dollarOpening = 0;

			double localOpening_Dr = 0;
			double dollarOpening_Dr = 0;
			double localOpening_Cr = 0;
			double dollarOpening_Cr = 0;
			
			if(accountLocalOpening.containsKey(id))
			{
				localOpening = ((Double)accountLocalOpening.get(id)).doubleValue();

				if(localOpening > 0 )
					localOpening_Dr = localOpening;
				else
					localOpening_Cr = localOpening * -1;
			}
			if(accountDollarOpening.containsKey(id))
			{
				dollarOpening = ((Double)accountDollarOpening.get(id)).doubleValue();

				if(dollarOpening > 0 )
					dollarOpening_Dr = dollarOpening;
				else
					dollarOpening_Cr = dollarOpening * -1;
			}


			//get the transactions
			double localTrans_Dr = 0;
			double dollarTrans_Dr = 0;
			double localTrans_Cr = 0;
			double dollarTrans_Cr = 0;
			if(accountLocalTransDr.containsKey(id))
			{
				localTrans_Dr = ((Double)accountLocalTransDr.get(id)).doubleValue();
			}
			if(accountDollarTransDr.containsKey(id))
			{
				dollarTrans_Dr = ((Double)accountDollarTransDr.get(id)).doubleValue();
			}
			if(accountLocalTransCr.containsKey(id))
			{
				localTrans_Cr = ((Double)accountLocalTransCr.get(id)).doubleValue();
			}
			if(accountDollarTransCr.containsKey(id))
			{
				dollarTrans_Cr = ((Double)accountDollarTransCr.get(id)).doubleValue();
			}


			//calculate the closing
			double localClosing = 0;
			double dollarClosing = 0;

			double localClosing_Dr = 0;
			double dollarClosing_Dr = 0;
			double localClosing_Cr = 0;
			double dollarClosing_Cr = 0;

			localClosing = localOpening_Dr + localTrans_Dr - (localOpening_Cr + localTrans_Cr);
			dollarClosing = dollarOpening_Dr + dollarTrans_Dr - (dollarOpening_Cr + dollarTrans_Cr);

			if(localClosing > 0)
				localClosing_Dr = localClosing;
			else
				localClosing_Cr = localClosing * -1;

			if(dollarClosing > 0)
				dollarClosing_Dr = dollarClosing;
			else
				dollarClosing_Cr = dollarClosing * -1;


			CashBankGroupRow agr = new CashBankGroupRow(id, name,	localOpening_Dr, dollarOpening_Dr, localOpening_Cr,  dollarOpening_Cr, localTrans_Dr, dollarTrans_Dr, localTrans_Cr, dollarTrans_Cr, localClosing_Dr,	 dollarClosing_Dr, localClosing_Cr, dollarClosing_Cr);
			reportList.add(agr);
		
		}//while
		rs.close();
		pstmt.close();
		errLine = "297";
		
		}catch(Exception e)
		{
			System.out.println("Exception in file CashBankGroup.java at method getAccountRows() after line="+errLine+" :" +e);
		}

		return reportList;	
	}//getAccountRows
}	

