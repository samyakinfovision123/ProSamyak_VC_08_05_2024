package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  LedgerGroup
{
	ResultSet rs=null;
	PreparedStatement pstmt=null;

	HashMap ledgerName = new HashMap();

	//stores the opening of the ledgers
	HashMap ledgerLocalOpening = new HashMap();
	HashMap ledgerDollarOpening = new HashMap();

	//stores the transactions between a given period
	HashMap ledgerLocalTransDr = new HashMap();
	HashMap ledgerLocalTransCr = new HashMap();
	HashMap ledgerDollarTransDr = new HashMap();
	HashMap ledgerDollarTransCr = new HashMap();

	//stores the closing of the ledgers
	//HashMap ledgerLocalClosing = new HashMap();
	//HashMap ledgerDollarClosing = new HashMap();
	
	//method that will give the opening for the ledgers in a selected Finance Head at a given date
	public void getLedgerOpening(Connection con, String company_id, String For_Head,  String yearendId, java.sql.Date D1)
	{
		String errLine = "34";
		String query = "";
		ledgerName.clear();
		ledgerLocalOpening.clear();
		ledgerDollarOpening.clear();

		try{
		
		
		query="Select Ledger_Id, Ledger_Name, Opening_LocalBalance, Opening_DollarBalance from Ledger where For_Head="+For_Head+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");
			String name = rs.getString("Ledger_Name");
			Double lopen = new Double ( rs.getDouble("Opening_LocalBalance") );
			Double dopen = new Double ( rs.getDouble("Opening_DollarBalance") );
		
			ledgerName.put(id, name);
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "62";

		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head="+For_Head+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening += rs.getDouble("addLocalAmt");
			dollarOpening += rs.getDouble("addDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "92";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head="+For_Head+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening -= rs.getDouble("delLocalAmt");
			dollarOpening -= rs.getDouble("delDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "122";
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerOpening() after line="+errLine+" :" +e);
		}
	
	}//getLedgerOpening


	//method that will give the transactions for the ledgers in a selected Finance Head for a given date range
	public void getLedgerTrans(Connection con, String company_id, String For_Head, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "134";
		String query = "";
	
		try{
		
		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head="+For_Head+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("addLocalAmt") );
			Double dopen = new Double ( rs.getDouble("addDollarAmt") );
		
			ledgerLocalTransDr.put(id, lopen);
			ledgerDollarTransDr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "161";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head="+For_Head+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("delLocalAmt") );
			Double dopen = new Double ( rs.getDouble("delDollarAmt") );
		
			ledgerLocalTransCr.put(id, lopen);
			ledgerDollarTransCr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "185";

		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerTrans() after line="+errLine+" :" +e);
		}
	
	}//getLedgerTrans

	//method that will give the opening, transactions and closing for the ledgers in a selected Finance Head for a given date range
	public ArrayList getLedgerRows(Connection con, String company_id, String For_Head, String yearendId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "197";
		String query = "";
		ArrayList reportList = new ArrayList();
	
		try{
		getLedgerOpening(con, company_id, For_Head, yearendId, D1);
		getLedgerTrans(con, company_id, For_Head, D1, D2);

		query="Select Ledger_Id from Ledger where For_Head="+For_Head+" and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			String name = (String)ledgerName.get(id);
		
			//get the opening
			double localOpening = 0;
			double dollarOpening = 0;

			double localOpening_Dr = 0;
			double dollarOpening_Dr = 0;
			double localOpening_Cr = 0;
			double dollarOpening_Cr = 0;
			
			if(ledgerLocalOpening.containsKey(id))
			{
				localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

				if(localOpening > 0 )
					localOpening_Dr = localOpening;
				else
					localOpening_Cr = localOpening * -1;
			}
			if(ledgerDollarOpening.containsKey(id))
			{
				dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

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
			if(ledgerLocalTransDr.containsKey(id))
			{
				localTrans_Dr = ((Double)ledgerLocalTransDr.get(id)).doubleValue();
			}
			if(ledgerDollarTransDr.containsKey(id))
			{
				dollarTrans_Dr = ((Double)ledgerDollarTransDr.get(id)).doubleValue();
			}
			if(ledgerLocalTransCr.containsKey(id))
			{
				localTrans_Cr = ((Double)ledgerLocalTransCr.get(id)).doubleValue();
			}
			if(ledgerDollarTransCr.containsKey(id))
			{
				dollarTrans_Cr = ((Double)ledgerDollarTransCr.get(id)).doubleValue();
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


			LedgerGroupRow lgr = new LedgerGroupRow(id, name,	localOpening_Dr, dollarOpening_Dr, localOpening_Cr,  dollarOpening_Cr, localTrans_Dr, dollarTrans_Dr, localTrans_Cr, dollarTrans_Cr, localClosing_Dr,	 dollarClosing_Dr, localClosing_Cr, dollarClosing_Cr);
			reportList.add(lgr);
		
		}//while
		rs.close();
		pstmt.close();
		errLine = "297";
		
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerRows() after line="+errLine+" :" +e);
		}

		return reportList;	
	}//getLedgerRows

	//method that will give the opening for the ledgers in a selected Finance Head at a given date
	public void getLedgerOpening(Connection con, String company_id, String yearendId, java.sql.Date D1)
	{
		String errLine = "34";
		String query = "";
		ledgerName.clear();
		ledgerLocalOpening.clear();
		ledgerDollarOpening.clear();

		try{
		
		
		query="Select Ledger_Id, Ledger_Name, Opening_LocalBalance, Opening_DollarBalance from Ledger where For_Head<>14 and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by For_Head, Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");
			String name = rs.getString("Ledger_Name");
			Double lopen = new Double ( rs.getDouble("Opening_LocalBalance") );
			Double dopen = new Double ( rs.getDouble("Opening_DollarBalance") );
		
			ledgerName.put(id, name);
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "62";

		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head<>14 group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening += rs.getDouble("addLocalAmt");
			dollarOpening += rs.getDouble("addDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "92";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head<>14 group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening -= rs.getDouble("delLocalAmt");
			dollarOpening -= rs.getDouble("delDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "122";
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerOpening() after line="+errLine+" :" +e);
		}
	
	}//getLedgerOpening


	//method that will give the transactions for the ledgers in a selected Finance Head for a given date range
	public void getLedgerTrans(Connection con, String company_id, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "134";
		String query = "";
	
		try{
		
		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head<>14 group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("addLocalAmt") );
			Double dopen = new Double ( rs.getDouble("addDollarAmt") );
		
			ledgerLocalTransDr.put(id, lopen);
			ledgerDollarTransDr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "161";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head<>14 group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("delLocalAmt") );
			Double dopen = new Double ( rs.getDouble("delDollarAmt") );
		
			ledgerLocalTransCr.put(id, lopen);
			ledgerDollarTransCr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "185";

		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerTrans() after line="+errLine+" :" +e);
		}
	
	}//getLedgerTrans

	//method that will give the opening, transactions and closing for the ledgers in a selected Finance Head for a given date range
	public ArrayList getLedgerRows(Connection con, String company_id, String yearendId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "197";
		String query = "";
		ArrayList reportList = new ArrayList();
	
		try{
		getLedgerOpening(con, company_id, yearendId, D1);
		getLedgerTrans(con, company_id, D1, D2);

		query="Select Ledger_Id from Ledger where For_Head<>14 and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by For_Head, Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			String name = (String)ledgerName.get(id);
		
			//get the opening
			double localOpening = 0;
			double dollarOpening = 0;

			double localOpening_Dr = 0;
			double dollarOpening_Dr = 0;
			double localOpening_Cr = 0;
			double dollarOpening_Cr = 0;
			
			if(ledgerLocalOpening.containsKey(id))
			{
				localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

				if(localOpening > 0 )
					localOpening_Dr = localOpening;
				else
					localOpening_Cr = localOpening * -1;
			}
			if(ledgerDollarOpening.containsKey(id))
			{
				dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

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
			if(ledgerLocalTransDr.containsKey(id))
			{
				localTrans_Dr = ((Double)ledgerLocalTransDr.get(id)).doubleValue();
			}
			if(ledgerDollarTransDr.containsKey(id))
			{
				dollarTrans_Dr = ((Double)ledgerDollarTransDr.get(id)).doubleValue();
			}
			if(ledgerLocalTransCr.containsKey(id))
			{
				localTrans_Cr = ((Double)ledgerLocalTransCr.get(id)).doubleValue();
			}
			if(ledgerDollarTransCr.containsKey(id))
			{
				dollarTrans_Cr = ((Double)ledgerDollarTransCr.get(id)).doubleValue();
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


			LedgerGroupRow lgr = new LedgerGroupRow(id, name,	localOpening_Dr, dollarOpening_Dr, localOpening_Cr,  dollarOpening_Cr, localTrans_Dr, dollarTrans_Dr, localTrans_Cr, dollarTrans_Cr, localClosing_Dr,	 dollarClosing_Dr, localClosing_Cr, dollarClosing_Cr);
			reportList.add(lgr);
		
		}//while
		rs.close();
		pstmt.close();
		errLine = "297";
		
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerRows() after line="+errLine+" :" +e);
		}

		return reportList;	
	}//getLedgerRows
//method that will give the opening, transactions and closing for the ledgers in a selected Finance Head for a given date range with their ledger Subgroup
public ArrayList getLedgerRows(Connection con, String company_id, String For_Head, String Ledger_type, String yearendId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "197";
		String query = "";
		ArrayList reportList = new ArrayList();
	
		try{
		getLedgerOpening(con, company_id, For_Head,Ledger_type, yearendId, D1);
		getLedgerTrans(con, company_id, For_Head,Ledger_type, D1, D2);

		query="Select Ledger_Id from Ledger where For_Head="+For_Head+" and ledger_type="+Ledger_type+"  and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			String name = (String)ledgerName.get(id);
		
			//get the opening
			double localOpening = 0;
			double dollarOpening = 0;

			double localOpening_Dr = 0;
			double dollarOpening_Dr = 0;
			double localOpening_Cr = 0;
			double dollarOpening_Cr = 0;
			
			if(ledgerLocalOpening.containsKey(id))
			{
				localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

				if(localOpening > 0 )
					localOpening_Dr = localOpening;
				else
					localOpening_Cr = localOpening * -1;
			}
			if(ledgerDollarOpening.containsKey(id))
			{
				dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

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
			if(ledgerLocalTransDr.containsKey(id))
			{
				localTrans_Dr = ((Double)ledgerLocalTransDr.get(id)).doubleValue();
			}
			if(ledgerDollarTransDr.containsKey(id))
			{
				dollarTrans_Dr = ((Double)ledgerDollarTransDr.get(id)).doubleValue();
			}
			if(ledgerLocalTransCr.containsKey(id))
			{
				localTrans_Cr = ((Double)ledgerLocalTransCr.get(id)).doubleValue();
			}
			if(ledgerDollarTransCr.containsKey(id))
			{
				dollarTrans_Cr = ((Double)ledgerDollarTransCr.get(id)).doubleValue();
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


			LedgerGroupRow lgr = new LedgerGroupRow(id, name,	localOpening_Dr, dollarOpening_Dr, localOpening_Cr,  dollarOpening_Cr, localTrans_Dr, dollarTrans_Dr, localTrans_Cr, dollarTrans_Cr, localClosing_Dr,	 dollarClosing_Dr, localClosing_Cr, dollarClosing_Cr);
			reportList.add(lgr);
		
		}//while
		rs.close();
		pstmt.close();
		errLine = "297";
		
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerRows() after line="+errLine+" :" +e);
		}

		return reportList;	
	}//getLedgerRows

public void getLedgerOpening(Connection con, String company_id, String For_Head, String Ledger_type, String yearendId, java.sql.Date D1)
	{
		String errLine = "34";
		String query = "";
		ledgerName.clear();
		ledgerLocalOpening.clear();
		ledgerDollarOpening.clear();

		try{
		
		
		query="Select Ledger_Id, Ledger_Name, Opening_LocalBalance, Opening_DollarBalance from Ledger where For_Head="+For_Head+" and Ledger_type="+Ledger_type+"  and Company_Id =" +company_id+ " and YearEnd_Id="+yearendId+" order by Ledger_Name";

		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");
			String name = rs.getString("Ledger_Name");
			Double lopen = new Double ( rs.getDouble("Opening_LocalBalance") );
			Double dopen = new Double ( rs.getDouble("Opening_DollarBalance") );
		
			ledgerName.put(id, name);
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "62";

		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head="+For_Head+"  and L.Ledger_type="+Ledger_type+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening += rs.getDouble("addLocalAmt");
			dollarOpening += rs.getDouble("addDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "92";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.YearEnd_Id="+yearendId+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date < ? and L.For_Head="+For_Head+" and L.Ledger_type="+Ledger_type+" group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			double localOpening = ((Double)ledgerLocalOpening.get(id)).doubleValue();

			double dollarOpening = ((Double)ledgerDollarOpening.get(id)).doubleValue();

			localOpening -= rs.getDouble("delLocalAmt");
			dollarOpening -= rs.getDouble("delDollarAmt");

			Double lopen = new Double ( localOpening );
			Double dopen = new Double ( dollarOpening );
		
			ledgerLocalOpening.put(id, lopen);
			ledgerDollarOpening.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "122";
		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerOpening() after line="+errLine+" :" +e);
		}
	
	}//getLedgerOpening

public void getLedgerTrans(Connection con, String company_id, String For_Head, String Ledger_type,  java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "134";
		String query = "";
	
		try{
		
		//get all the dr. enteries for the given ledger group
		//the FT.transaction_type is 0 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as addLocalAmt, Sum(FT.Dollar_Amount) as addDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=0 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head="+For_Head+"  and L.Ledger_type="+Ledger_type+"  group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("addLocalAmt") );
			Double dopen = new Double ( rs.getDouble("addDollarAmt") );
		
			ledgerLocalTransDr.put(id, lopen);
			ledgerDollarTransDr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "161";

		//get all the cr. enteries for the given ledger group
		//the FT.transaction_type is 1 for this condition
		query = "Select FT.Ledger_Id, Sum(FT.Local_Amount) as delLocalAmt, Sum(FT.Dollar_Amount) as delDollarAmt from Financial_Transaction FT, Ledger L where FT.Company_Id ="+company_id+" and FT.Active=1  and L.Active=1 and FT.transaction_type=1 and L.Ledger_Id=FT.Ledger_Id and FT.Transaction_Date between ? and ? and L.For_Head="+For_Head+"  and L.Ledger_type="+Ledger_type+"  group by FT.Ledger_Id";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1,D1);
		pstmt.setDate(2,D2);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Ledger_Id");

			Double lopen = new Double ( rs.getDouble("delLocalAmt") );
			Double dopen = new Double ( rs.getDouble("delDollarAmt") );
		
			ledgerLocalTransCr.put(id, lopen);
			ledgerDollarTransCr.put(id, dopen);
		}//while
		rs.close();
		pstmt.close();

		errLine = "185";

		}catch(Exception e)
		{
			System.out.println("Exception in file LedgerGroup.java at method getLedgerTrans() after line="+errLine+" :" +e);
		}
	
	}//getLedgerTrans



}	

