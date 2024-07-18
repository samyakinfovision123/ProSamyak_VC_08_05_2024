package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
import NipponBean.*;

public class CustomerVendorReport
{
	List saleList = new ArrayList();
	List purchaseList = new ArrayList();
	List ledgerList = new ArrayList();
	List pnList = new ArrayList();
	List totalSaleList = new ArrayList();
	List totalPurchaseList = new ArrayList();
	List totalPNList = new ArrayList();
	List totalLedgerList =new ArrayList();

	List Ledger = new ArrayList();
	List Master_Account = new ArrayList();
	
	int saleFirstIndex;
	int purchaseFirstIndex;
	int pnFirstIndex;
	int saleLastIndex;
	int purchaseLastIndex;
	int pnLastIndex;
	int ledgerFirstIndex;
	int ledgerLastIndex;
	customerVendorReportRow openingRow;
		
	ResultSet rs = null;
	ResultSet rs_g = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt_g = null;

	///////////////////////////////////////////////////////
	//Start : method to load ledger names and account names
	///////////////////////////////////////////////////////
	public void loadMasters(Connection con)
	{
		String errLine = "39";
		try{
			//loading the Ledger and Master_Account tables data for particulars
			errLine = "42";
			String query = "Select Ledger_Name from Ledger";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				Ledger.add(rs.getString("Ledger_Name"));
			}
			rs.close();
			pstmt.close();
			errLine = "52";

			query = "Select Account_Name from Master_Account";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				Master_Account.add(rs.getString("Account_Name"));
			}
			rs.close();
			pstmt.close();
			errLine = "63";
		}
		catch(Exception e)
		{
			System.out.println("Exception in loadMasters() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}

	}
	//////////////////////////////////////////////////////
	//End : method to load ledger names and account names
	//////////////////////////////////////////////////////

	////////////////////////////////////////////////////
	//Start : making all the sales calculations
	////////////////////////////////////////////////////

	public List getSalesTransaction(String ledgerId, Connection conp, Connection cong, java.sql.Date fromDate, java.sql.Date toDate, double opening_sundrydebtors, double dopening_sundrydebtors, String company_id, String party_id, String ctaxLedgerId)
	{
		String errLine = "80";
		saleList.clear();
		totalSaleList.clear();
		saleFirstIndex = 0;
		try{

			//getting Sale and Sale Return
			String query1 = "SELECT DISTINCT (V.Voucher_Id), V.Voucher_Date, V.Voucher_Type, R.Receive_No, V.Ref_no, V.Local_Total, V.Dollar_Total, V.Description, FT.ReceiveFrom_LedgerId, R.Receive_Id,R.Due_Date,R.Due_Days FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE (V.voucher_type=1 Or V.Voucher_type=11) And v.voucher_id=FT.Voucher_Id And R.Receive_FromId="+party_id+" and FT.Receive_Id=R.Receive_Id and V.company_id="+company_id+" and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1";

			errLine="86";
			pstmt = conp.prepareStatement(query1);
			rs = pstmt.executeQuery();
			errLine="89";
			
			while(rs.next())
			{
				errLine="93";
				String voucher_Id = rs.getString("Voucher_Id");
				
				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				
				int voucher_Type = rs.getInt("Voucher_Type");
										
				String voucher_No = rs.getString("Receive_No");
				String ref_no = rs.getString("Ref_no");
				double local_total = rs.getDouble("Local_Total");
				double dollar_total = rs.getDouble("Dollar_Total");
				String narration = rs.getString("Description");
				String Receive_Id = rs.getString("Receive_Id");
				
				java.sql.Date due_date = rs.getDate("Due_Date");
				String due_days=rs.getString("Due_Days");				
			
				
				String voucherType_Name="";
				String voucher_Link="";
				String particulars[]=new String[1];
				errLine="106";

				double local_total_cr = 0;
				double local_total_dr = 0;
				double dollar_total_cr = 0;
				double dollar_total_dr = 0;

				if(voucher_Type == 1)
				{
					local_total_dr = local_total;
					dollar_total_dr = dollar_total;
					particulars[0]="To Sale Account";
					voucherType_Name ="Sales";
					voucher_Link = "../Inventory/InvDetailReport.jsp?command=sale&receive_id="+Receive_Id;
				}
				if(voucher_Type == 11)
				{
					local_total_cr = local_total;
					dollar_total_cr = dollar_total;
					particulars[0]="By Sale Account";
					voucherType_Name ="Sales Return";
					voucher_Link = "../Inventory/PurchaseReturnInvoice.jsp?command=purchase&receive_id="+Receive_Id;
				}
				
				errLine="130";
				customerVendorReportRow newRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucherType_Name, voucher_No, voucher_Link, ref_no, local_total_dr, local_total_cr, dollar_total_dr, dollar_total_cr, narration,Receive_Id,ledgerId,due_date,due_days);

				totalSaleList.add(newRow);
				//System.out.print(totalList.size());
				errLine="135";
			}
			rs.close();
			pstmt.close();

			//getting Sales Receipt, PN Sales Receipt & Journal
			String query2 = "SELECT V.Voucher_Id, V.Voucher_Date, V.Voucher_Type, V.Voucher_No, V.Ref_no, FT.Local_Amount, FT.Dollar_Amount, FT.Transaction_Type, V.Description, FT.Tranasaction_Id FROM Financial_Transaction AS FT, Voucher AS V WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id="+ledgerId+" and V.company_id="+company_id+" and V.Active=1 and FT.Active=1";

			errLine="142";
			pstmt = conp.prepareStatement(query2);
			rs = pstmt.executeQuery();
			errLine="146";
			
			while(rs.next())
			{
				errLine="150";
				String voucher_Id = rs.getString("Voucher_Id");
				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				int voucher_Type = rs.getInt("Voucher_Type");
				String voucher_No = rs.getString("Voucher_No");
				String ref_no = rs.getString("Ref_no");
				if(rs.wasNull())
				{ref_no="";}
				double local_total = rs.getDouble("Local_Amount");
				double dollar_total = rs.getDouble("Dollar_Amount");
				Boolean Transaction_Type = rs.getBoolean("Transaction_Type");
				String narration = rs.getString("Description");
				String voucherType_Name="";
				String voucher_Link="";

				String Transaction_Id = rs.getString("Tranasaction_Id");
				
				
				errLine = "166";
				String subquery = "Select For_Head, For_HeadId, Ledger_Id, Transaction_Type from Financial_Transaction where Voucher_Id="+voucher_Id+" and Tranasaction_Id <> "+Transaction_Id+" and Active=1";

				pstmt_g = cong.prepareStatement(subquery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt_g.executeQuery();
				rs_g.last();
				int particularCount = rs_g.getRow();
				String particulars[] = new String[particularCount];
				rs_g.beforeFirst();
				int q=0;
				while(rs_g.next())
				{
					int For_Head = rs_g.getInt("For_Head");
					int For_HeadId = rs_g.getInt("For_HeadId");
					int Ledger_Id = rs_g.getInt("Ledger_Id");
					boolean transType = rs_g.getBoolean("Transaction_Type");
					if(For_Head == 1)
					{
						if(transType)
							particulars[q] = "To ("+ (String)Master_Account.get(For_HeadId-1) + ")";
						else
							particulars[q] = "By ("+ (String)Master_Account.get(For_HeadId-1) + ")";
					}
					else
					{	
						if(transType)
							particulars[q] = "To ("+ (String)Ledger.get(Ledger_Id-1) +")";
						else
							particulars[q] = "By ("+ (String)Ledger.get(Ledger_Id-1) +")";
					}
					q++;
				}
				rs_g.close();
				pstmt_g.close();
				errLine="200";

				double local_total_cr = 0;
				double local_total_dr = 0;
				double dollar_total_cr = 0;
				double dollar_total_dr = 0;

				if(!Transaction_Type)
				{
					local_total_dr = local_total;
					dollar_total_dr = dollar_total;
				}
				if(Transaction_Type)
				{
					local_total_cr = local_total;
					dollar_total_cr = dollar_total;
				}

				
				if(voucher_Type == 7)
				{
					voucherType_Name = "Journal";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}

				if(voucher_Type == 8)
				{
					voucherType_Name = "Sales Receipt";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}
				
				if(voucher_Type == 12)
				{
					voucherType_Name = "PN Sales Receipt";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}
				
				errLine="237";
				customerVendorReportRow newRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucherType_Name, voucher_No,voucher_Link, ref_no, local_total_dr, local_total_cr, dollar_total_dr, dollar_total_cr, narration,"0",ledgerId,voucher_Date,"0");

				totalSaleList.add(newRow);
				//System.out.print(totalList.size());
				errLine="242";
			}
			rs.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			System.out.println("Exception in getSalesTransaction() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		
		ComparingDate comp = new ComparingDate();
		
		//sort the list
		Collections.sort(totalSaleList, comp);
		
		//get the opening balance
		customerVendorReportRow openingRow = getSalesOpeningBalance(cong, fromDate, opening_sundrydebtors, dopening_sundrydebtors,company_id, party_id);
		
		//get last index as per the toDate
		saleLastIndex = getSaleLastIndex(toDate);
		
		//get the sublist of transactions between fromDate and toDate
		saleList = totalSaleList.subList(saleFirstIndex,saleLastIndex);
		saleList.add(0, openingRow);
		
		return saleList;
	}//getSalesTransaction()


	//returns the opening balance row for the given party
	public customerVendorReportRow getSalesOpeningBalance(Connection con, java.sql.Date fromDate, double opening_sundrydebtors, double dopening_sundrydebtors, String company_id, String party_id)
	{
		
		String errLine="275";
		try{
		String voucher_Id ="";
		java.sql.Date voucher_Date = fromDate;
		String voucher_Type = "";//to indicate value not that in Master_Voucher but opening balance
		String voucher_No = "";
		String ref_no = "";
		Boolean Transaction_Type = true;// for credit
		String narration = "";
		String particulars[] = new String[1];
		particulars[0] = "Opening Balance";

		double op_local_cr = 0;
		double op_local_dr = 0;
		double op_dollar_cr = 0;
		double op_dollar_dr = 0;
		
		if( opening_sundrydebtors > 0)
		{
			op_local_dr = opening_sundrydebtors;
			op_dollar_dr = dopening_sundrydebtors;
		}
		else
		{
			op_local_cr = opening_sundrydebtors * -1;
			op_dollar_cr = dopening_sundrydebtors * -1;
		}
		
		errLine="303";

		if(totalSaleList.size() != 0)
		{
			for(int i=0; i<totalSaleList.size(); i++)
			{
				saleFirstIndex = i;
				customerVendorReportRow row = (customerVendorReportRow)totalSaleList.get(i);
				errLine="311";

				if(row.getVoucher_Date().compareTo(fromDate) < 0)
				{
					op_local_cr += row.getLocalAmt_Cr();
					op_local_dr += row.getLocalAmt_Dr();
					op_dollar_cr += row.getDollarAmt_Cr();
					op_dollar_dr += row.getDollarAmt_Dr();
					saleFirstIndex=i+1;
				}
				else
					break;

				errLine="324";
			}//end for

			double sale_gainloss = partySaleExchangeGainLoss(con, party_id, company_id,fromDate);

			if (sale_gainloss < 0){
				op_local_dr +=sale_gainloss*-1;
			}else{ 
				op_local_cr +=sale_gainloss;}

			errLine="334";
			if(op_local_cr >= op_local_dr)
			{
				op_local_cr -= op_local_dr;
				op_local_dr = 0;
				op_dollar_cr -= op_dollar_dr;
				op_dollar_dr = 0;
			}
			else
			{
				op_local_dr -= op_local_cr;
				op_local_cr = 0;
				op_dollar_dr -= op_dollar_cr;
				op_dollar_cr = 0;
			}
			
		
		}//end if
		errLine="352";

		

		openingRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucher_Type, voucher_No, "", ref_no, op_local_dr, op_local_cr, op_dollar_dr, op_dollar_cr, narration,"0","",voucher_Date,"0");
	
		}
		catch(Exception e){
			System.out.println("Exception in getOpeningSalesBalance() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		return openingRow;
	}//getSalesOpeningBalance()

	public int getSaleFirstIndex()
	{
		return saleFirstIndex;
	}//getSaleFirstIndex()

	public int getSaleLastIndex(java.sql.Date toDate)
	{
		if(totalSaleList.size() != 0)
		{
			for(int i=saleFirstIndex; i<totalSaleList.size(); i++)
			{
				customerVendorReportRow row = (customerVendorReportRow)totalSaleList.get(i);
		
				if(row.getVoucher_Date().compareTo(toDate) > 0)
				{
					saleLastIndex =i;	
					return saleLastIndex;			
				}
			}//end for
		}//end if
		saleLastIndex =totalSaleList.size();	
		return saleLastIndex;
	}//end getSaleLastIndex()


	//get the sale exchange gainloss upto a given date
	public double partySaleExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1) 
	{
		double saleExchangeGainLoss = 0;
		try{

		//06-05-2006 : Added this query to avoid calculating the pending sales-purchases entries' exchange gainloss 
		java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());

		String startDateQuery = "Select From_Date from YearEnd Where company_id="+company_id+" and Active=1 and YearEnd_Id in (Select MIN(YearEnd_Id) from YearEnd Where company_id="+company_id+" and Active=1)";

		pstmt_g = con.prepareStatement(startDateQuery);
		rs_g = pstmt_g.executeQuery();
		while(rs_g.next()) 
		{
			startDate = rs_g.getDate("From_Date");
		}

		pstmt_g.close();
		
		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and  R.Receive_FromId="+party_id+" and (V.Voucher_Date <=? and V.Voucher_Date >=?) and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and V.Active=1 and Receive_Sell=0 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+startDate); 
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			saleExchangeGainLoss += ( rs.getDouble("Exchange_Rate")*rs.getDouble("Dollar_Amount")  )	- rs.getDouble("Local_Amount");
		}//while
		rs.close();
		pstmt.close();
		
		}catch(Exception e)
		{
			System.out.println("Exception in partySaleExchangeGainLoss(D1) :" +e);
		}
		return saleExchangeGainLoss;
	}//exchangeGainLoss


	//get the sale exchange gainloss upto a given date range
	public double partySaleExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
	{
		

		double saleExchangeGainLoss = 0;
		try{

		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and R.Receive_FromId="+party_id+" and V.Voucher_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and V.Voucher_Currency=0 and Receive_Sell=0 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);	
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		while(rs.next()) 
		{
			double ex_rate=rs.getDouble("Exchange_Rate");
			double dl_amt=rs.getDouble("Dollar_Amount");
			double lc_amt=rs.getDouble("Local_Amount");
			saleExchangeGainLoss += ((ex_rate*dl_amt)-lc_amt);
			
		}
		rs.close();
		pstmt.close();
		}
		catch(Exception e)
		{
			System.out.print("Exception in partySaleExchangeGainLoss(D1, D2) :" +e);
		}
		
		return saleExchangeGainLoss;
	}//exchangeGainLoss 
	
	//get the sale exchange gainloss upto a given date range
	public String partySaleExchangeGainLossDollar(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
	{
		//System.out.println("party_id="+party_id);
		//System.out.println("company_id="+company_id);
		//System.out.println("D1="+D1);
		//System.out.println("D2="+D2);

		double saleExchangeGainLoss = 0;
		double SaleExchangeGainLossDollar=0;
		try{

		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and R.Receive_FromId="+party_id+" and V.Voucher_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and V.Voucher_Currency=0 and Receive_Sell=0 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);	
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
			while(rs.next()) 
			{
				double ex_rate=rs.getDouble("Exchange_Rate");
				double dl_amt=rs.getDouble("Dollar_Amount");
				double lc_amt=rs.getDouble("Local_Amount");
				double local_ex_gain_loss= ((ex_rate*dl_amt)-lc_amt);
				double dollar_ex_gain_loss= local_ex_gain_loss/ex_rate;
				
				SaleExchangeGainLossDollar+=dollar_ex_gain_loss;
				saleExchangeGainLoss+=local_ex_gain_loss;
				//System.out.println("local_ex_gain_loss="+local_ex_gain_loss);
				//System.out.println("dollar_ex_gain_loss="+dollar_ex_gain_loss);
			}
				rs.close();
				pstmt.close();
		}
		catch(Exception e)
		{
			//System.out.print("Exception in partySaleExchangeGainLoss(D1, D2) :" +e);
		}
		
		String ex_gain_loss_local_dollar=""+saleExchangeGainLoss+"#"+SaleExchangeGainLossDollar;
		//System.out.println("ex_gain_loss_local_dollar="+ex_gain_loss_local_dollar);
		return ex_gain_loss_local_dollar;
	}//exchangeGainLoss 
	
	
	
	
	
	
	////////////////////////////////////////////////////
	//End : making all the sales calculations
	////////////////////////////////////////////////////



	////////////////////////////////////////////////////
	//Start : making all the purchase calculations
	////////////////////////////////////////////////////
	public List getPurchaseTransaction(String ledgerId, Connection conp, Connection cong, java.sql.Date fromDate, java.sql.Date toDate, double opening_sundrycreditors, double dopening_sundrycreditors, String company_id, String party_id, String ctaxLedgerId)
	{
		purchaseList.clear();
		totalPurchaseList.clear();
		purchaseFirstIndex=0;
		String errLine = "458";

		java.sql.Date Due_Date=null;
		String Due_Days="";
		
		try{
			
			String query1 = "SELECT DISTINCT (V.Voucher_Id), V.Voucher_Date, V.Voucher_Type, R.Receive_No, V.Ref_no, V.Local_Total, V.Dollar_Total, V.Description, FT.ReceiveFrom_LedgerId, R.Receive_Id ,R.Due_Date,R.Due_Days FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE (V.voucher_type=2 Or V.Voucher_type=10) And v.voucher_id=FT.Voucher_Id And R.Receive_FromId="+party_id+" and FT.Receive_Id=R.Receive_Id and V.company_id="+company_id+" and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1";

			errLine="463";
			pstmt = conp.prepareStatement(query1);
			rs = pstmt.executeQuery();
			errLine="466";
			
			while(rs.next())
			{
				errLine="470";
				String voucher_Id = rs.getString("Voucher_Id");
				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				int voucher_Type = rs.getInt("Voucher_Type");
				String voucher_No = rs.getString("Receive_No");
				String ref_no = rs.getString("Ref_no");
				double local_total = rs.getDouble("Local_Total");
				double dollar_total = rs.getDouble("Dollar_Total");
				String narration = rs.getString("Description");
				String Receive_Id = rs.getString("Receive_Id");
				
				Due_Date=rs.getDate("Due_Date");
				Due_Days=rs.getString("Due_Days");
				
				String voucherType_Name="";
				String voucher_Link="";
				String particulars[] = new String[1];
				errLine="483";

				double local_total_cr = 0;
				double local_total_dr = 0;
				double dollar_total_cr = 0;
				double dollar_total_dr = 0;

				if(voucher_Type == 2)
				{
					local_total_cr = local_total;
					dollar_total_cr = dollar_total;
					particulars[0]="By Purchase Account";
					voucherType_Name ="Purchase";
					voucher_Link = "../Inventory/InvDetailReport.jsp?command=purchase&receive_id="+Receive_Id;
				}
				if(voucher_Type == 10)
				{
					local_total_dr = local_total;
					dollar_total_dr = dollar_total;
					particulars[0]="To Purchase Account";
					voucherType_Name ="Purchase Return";
					voucher_Link = "../Inventory/PurchaseReturnInvoice.jsp?command=sale&receive_id="+Receive_Id;
				}
				
				errLine="507";
				customerVendorReportRow newRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucherType_Name, voucher_No, voucher_Link, ref_no, local_total_dr, local_total_cr, dollar_total_dr, dollar_total_cr, narration,Receive_Id,ledgerId,Due_Date,Due_Days);

				totalPurchaseList.add(newRow);
				//System.out.print(totalList.size());
				errLine="512";
			}
			rs.close();
			pstmt.close();

			//getting Purchase Payment, PN Purchase Payment & Journal
			String query2 = "SELECT V.Voucher_Id, V.Voucher_Date, V.Voucher_Type, V.Voucher_No, V.Ref_no, FT.Local_Amount, FT.Dollar_Amount, FT.Transaction_Type, V.Description, FT.Tranasaction_Id FROM Financial_Transaction AS FT, Voucher AS V WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id="+ledgerId+" and V.company_id="+company_id+" and V.Active=1 and FT.Active=1";

			errLine="520";
			pstmt = conp.prepareStatement(query2);
			rs = pstmt.executeQuery();
			errLine="523";
			
			while(rs.next())
			{
				errLine="527";
				String voucher_Id = rs.getString("Voucher_Id");
				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				int voucher_Type = rs.getInt("Voucher_Type");
				String voucher_No = rs.getString("Voucher_No");
				String ref_no = rs.getString("Ref_no");
				if(rs.wasNull())
				{ref_no="";}
				double local_total = rs.getDouble("Local_Amount");
				double dollar_total = rs.getDouble("Dollar_Amount");
				Boolean Transaction_Type = rs.getBoolean("Transaction_Type");
				String narration = rs.getString("Description");
				String voucherType_Name="";
				String voucher_Link="";
				errLine="539";

				String Transaction_Id = rs.getString("Tranasaction_Id");
				
				errLine = "543";
				String subquery = "Select For_Head, For_HeadId, Ledger_Id, Transaction_Type from Financial_Transaction where Voucher_Id="+voucher_Id+" and Tranasaction_Id <> "+Transaction_Id+" and Active=1";

				pstmt_g = cong.prepareStatement(subquery,  ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt_g.executeQuery();
				rs_g.last();
				int particularCount = rs_g.getRow();
				String particulars[] = new String[particularCount];
				rs_g.beforeFirst();
				int q=0;
				while(rs_g.next())
				{
					int For_Head = rs_g.getInt("For_Head");
					int For_HeadId = rs_g.getInt("For_HeadId");
					int Ledger_Id = rs_g.getInt("Ledger_Id");

					boolean transType = rs_g.getBoolean("Transaction_Type");
					if(For_Head == 1)
					{
						if(transType)
							particulars[q] = "To ("+ (String)Master_Account.get(For_HeadId-1) + ")";
						else
							particulars[q] = "By ("+ (String)Master_Account.get(For_HeadId-1) + ")";
					}
					else
					{	
						if(transType)
							particulars[q] = "To ("+ (String)Ledger.get(Ledger_Id-1) +")";
						else
							particulars[q] = "By ("+ (String)Ledger.get(Ledger_Id-1) +")";
					}
					q++;
				}
				rs_g.close();
				pstmt_g.close();
				errLine="578";

				double local_total_cr = 0;
				double local_total_dr = 0;
				double dollar_total_cr = 0;
				double dollar_total_dr = 0;

				if(!Transaction_Type)
				{
					local_total_dr = local_total;
					dollar_total_dr = dollar_total;
				}
				if(Transaction_Type)
				{
					local_total_cr = local_total;
					dollar_total_cr = dollar_total;
				}

				
				if(voucher_Type == 7)
				{
					voucherType_Name = "Journal";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}

				if(voucher_Type == 9)
				{
					voucherType_Name = "Purchase Payment";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}
				
				if(voucher_Type == 13)
				{
					voucherType_Name = "PN Purchase Payment";
					voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
				}
				
					System.out.println("<br> 733 Due_Date12 = "+Due_Date);
		System.out.println("<br> 734 Due_Days12 = "+Due_Days);

				errLine="615";
				customerVendorReportRow newRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucherType_Name, voucher_No,voucher_Link, ref_no, local_total_dr, local_total_cr, dollar_total_dr, dollar_total_cr, narration,"0",ledgerId,Due_Date,Due_Days);

				totalPurchaseList.add(newRow);
				//System.out.print(totalList.size());
				errLine="620";
			}
			rs.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			System.out.println("Exception in getPurchaseTransaction() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		
		
	
		
		ComparingDate comp = new ComparingDate();
		
		//sort the list
		Collections.sort(totalPurchaseList, comp);
		
		//get the opening balance
		customerVendorReportRow openingRow = getPurchaseOpeningBalance(cong, fromDate, opening_sundrycreditors, dopening_sundrycreditors,company_id, party_id,Due_Date,Due_Days);
		
		//get last index as per the toDate
		purchaseLastIndex = getPurchaseLastIndex(toDate);
		
		//get the sublist of transactions between fromDate and toDate
		purchaseList = totalPurchaseList.subList(purchaseFirstIndex,purchaseLastIndex);
		purchaseList.add(0, openingRow);
		
		return purchaseList;
	}//getpurchaseTransaction()


	//returns the opening balance row for the given party
	public customerVendorReportRow getPurchaseOpeningBalance(Connection con, java.sql.Date fromDate, double opening_sundrycreditors, double dopening_sundrycreditors, String company_id, String party_id,java.sql.Date Due_Date,String Due_Days)
	{
		
		String errLine="653";
		try{
		String voucher_Id ="";
		java.sql.Date voucher_Date = fromDate;
		String voucher_Type = "";//to indicate value not that in Master_Voucher but opening balance
		String voucher_No = "";
		String ref_no = "";
		Boolean Transaction_Type = true;// for credit
		String narration = "";
		String particulars[] = new String[1];
		
		java.sql.Date Due_DateOB=Due_Date;
		String Due_DaysOB=Due_Days;
		particulars[0] = "Opening Balance";

		double op_local_cr = 0;
		double op_local_dr = 0;
		double op_dollar_cr = 0;
		double op_dollar_dr = 0;
		
		if( opening_sundrycreditors > 0)
		{
			op_local_dr = opening_sundrycreditors;
			op_dollar_dr = dopening_sundrycreditors;
		}
		else
		{
			op_local_cr = opening_sundrycreditors * -1;
			op_dollar_cr = dopening_sundrycreditors * -1;
		}
		
		errLine="681";

		if(totalPurchaseList.size() != 0)
		{
			for(int i=0; i<totalPurchaseList.size(); i++)
			{
				purchaseFirstIndex = i;
				customerVendorReportRow row = (customerVendorReportRow)totalPurchaseList.get(i);
				errLine="689";

				if(row.getVoucher_Date().compareTo(fromDate) < 0)
				{
					op_local_cr += row.getLocalAmt_Cr();
					op_local_dr += row.getLocalAmt_Dr();
					op_dollar_cr += row.getDollarAmt_Cr();
					op_dollar_dr += row.getDollarAmt_Dr();
					purchaseFirstIndex=i+1;
				}
				else
					break;

				errLine="702";
			}//end for

			double purchase_gainloss = partyPurchaseExchangeGainLoss(con, party_id, company_id,fromDate);

			if (purchase_gainloss < 0){
				op_local_dr +=purchase_gainloss*-1;
			}else{ 
				op_local_cr +=purchase_gainloss;}

			errLine="712";
			if(op_local_cr >= op_local_dr)
			{
				op_local_cr -= op_local_dr;
				op_local_dr = 0;
				op_dollar_cr -= op_dollar_dr;
				op_dollar_dr = 0;
			}
			else
			{
				op_local_dr -= op_local_cr;
				op_local_cr = 0;
				op_dollar_dr -= op_dollar_cr;
				op_dollar_cr = 0;
			}
			
		
		}//end if
		errLine="730";

		System.out.println("<br> 841 Due_DateOB = "+Due_DateOB);
		System.out.println("<br> 842 Due_DaysOB = "+Due_DaysOB);

		openingRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucher_Type, voucher_No, "", ref_no, op_local_dr, op_local_cr, op_dollar_dr, op_dollar_cr, narration,"0","",Due_DateOB,Due_DaysOB);
	
		}
		catch(Exception e){
			System.out.println("Exception in getOpeningPurchaseBalance() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		return openingRow;
	}//getPurchaseOpeningBalance()

	public int getPurchaseFirstIndex()
	{
		return purchaseFirstIndex;
	}//getSaleFirstIndex()

	public int getPurchaseLastIndex(java.sql.Date toDate)
	{
		if(totalPurchaseList.size() != 0)
		{
			for(int i=purchaseFirstIndex; i<totalPurchaseList.size(); i++)
			{
				customerVendorReportRow row = (customerVendorReportRow)totalPurchaseList.get(i);
		
				if(row.getVoucher_Date().compareTo(toDate) > 0)
				{
					purchaseLastIndex =i;	
					return purchaseLastIndex;			
				}
			}//end for
		}//end if
		purchaseLastIndex =totalPurchaseList.size();	
		return purchaseLastIndex;
	}//end getPurchaseLastIndex()


	//get the Purchase exchange gainloss upto a given date
	public double partyPurchaseExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1) 
	{
		double purchaseExchangeGainLoss = 0;
		try{
		
		java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());

		//06-05-2006 : Added this query to avoid calculating the pending sales-purchases entries' exchange gainloss 
		String startDateQuery = "Select From_Date from YearEnd Where company_id="+company_id+" and Active=1 and YearEnd_Id in (Select MIN(YearEnd_Id) from YearEnd Where company_id="+company_id+" and Active=1)";

		pstmt_g = con.prepareStatement(startDateQuery);
		rs_g = pstmt_g.executeQuery();
		while(rs_g.next()) 
		{
			startDate = rs_g.getDate("From_Date");
		}

		pstmt_g.close();



		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and R.Receive_FromId="+party_id+" and (V.Voucher_Date <=? and V.Voucher_Date >=?) and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and V.Active=1 and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=1 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+startDate); 
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			purchaseExchangeGainLoss += ( rs.getDouble("Exchange_Rate")*rs.getDouble("Dollar_Amount")  )	- rs.getDouble("Local_Amount");
		}//while
		rs.close();
		pstmt.close();
		
		}catch(Exception e)
		{
			System.out.println("Exception in partyPurchaseExchangeGainLoss(D1) :"+e);
		}
		
		return purchaseExchangeGainLoss*-1;
	}//exchangeGainLoss


	//get the Purchase exchange gainloss upto a given date range
	public double partyPurchaseExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
	{
		double purchaseExchangeGainLoss = 0;
		try{

		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and  R.Receive_FromId="+party_id+" and V.Voucher_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and V.Active=1 and Receive_Sell=1 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);	
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		while(rs.next()) 
			{
				purchaseExchangeGainLoss += ( rs.getDouble("Exchange_Rate")*rs.getDouble("Dollar_Amount")  )	- rs.getDouble("Local_Amount");
			}
		rs.close();
		pstmt.close();
		}
		catch(Exception e)
		{
			System.out.print("Exception in partySaleExchangeGainLoss(D1, D2) :" +e);
		}
		return purchaseExchangeGainLoss*-1;
	}//exchangeGainLoss 

	
	//get the Purchase exchange gainloss upto a given date range
	public String partyPurchaseExchangeGainLossDollar(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2) 
	{
		double purchaseExchangeGainLoss = 0;
		double purchaseExchangeGainLoss_dollar = 0;
		try{

		String query="";
		query="Select * from Receive R, Payment_Details PD, Voucher V  where R.Receive_Id=PD.For_HeadId and V.Voucher_Id=PD.Voucher_Id and  R.Receive_FromId="+party_id+" and V.Voucher_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and V.Active=1 and Receive_Sell=1 order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);	
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		while(rs.next()) 
			{
				double ex_rate=rs.getDouble("Exchange_Rate");
				double dol_amt=rs.getDouble("Dollar_Amount");
				double loc_amt=rs.getDouble("Local_Amount");
				purchaseExchangeGainLoss +=((ex_rate*dol_amt)-loc_amt);
				purchaseExchangeGainLoss_dollar+=((ex_rate*dol_amt)-loc_amt)/ex_rate;
			}
			rs.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			System.out.print("Exception in partySaleExchangeGainLoss(D1, D2) :" +e);
		}
		String purchase_ex_gain_loss_dollar=""+purchaseExchangeGainLoss*(-1)+"#"+purchaseExchangeGainLoss_dollar*(-1);
		
		return purchase_ex_gain_loss_dollar;
	}//exchangeGainLoss 

	////////////////////////////////////////////////////
	//End : making all the purchase calculations
	////////////////////////////////////////////////////


	////////////////////////////////////////////////////
	//Start : making all the PN calculations
	////////////////////////////////////////////////////
	public List getPNTransaction(String pnAccountId, Connection conp, Connection cong, java.sql.Date fromDate, java.sql.Date toDate, double opening_pn, double dopening_pn, String company_id, String party_id)
	{
		pnList.clear();
		totalPNList.clear();
		pnFirstIndex=0;
		String errLine = "836";
		try{
			Vector voucherIds = new Vector();

			//getting all vouchers ids from the PN table
			String query1 = "Select Voucher_id, RefVoucher_Id from PN where To_FromId="+party_id+" and company_id="+company_id+" and Active=1";

			errLine="843";
			pstmt = conp.prepareStatement(query1);
			rs = pstmt.executeQuery();
			errLine="846";
			
			while(rs.next())
			{
				errLine="850";
				int voucher_Id = rs.getInt("Voucher_Id");
				int refvoucher_Id = rs.getInt("RefVoucher_Id");
			
				if(voucher_Id != 0)
					voucherIds.addElement(new Integer(voucher_Id));
				if(refvoucher_Id != 0)
					voucherIds.addElement(new Integer(refvoucher_Id));
			}
			rs.close();
			pstmt.close();
			

			Iterator itr= voucherIds.iterator();
			String vidCondition="(";

			while(itr.hasNext())
			{
			if("(".equals(vidCondition))
				{vidCondition=vidCondition+itr.next();}
			else
				{vidCondition=vidCondition+","+itr.next();}
			}		
			vidCondition+=")";

			if(voucherIds.size() > 0)
			{
				//getting all the vouchers corresponding the read voucher ids
					
				String query2 = "SELECT V.Voucher_Id, V.Voucher_Date, V.Voucher_Type, V.Voucher_No, V.Ref_no, FT.Local_Amount, FT.Dollar_Amount, FT.Transaction_Type, V.Description, FT.Tranasaction_Id FROM Financial_Transaction AS FT, Voucher AS V WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=0 and FT.For_Head=1 and FT.For_HeadId="+pnAccountId+" and V.company_id="+company_id+" and V.Active=1 and FT.Active=1 and V.Voucher_Id in "+vidCondition;

				errLine="881";
				pstmt = conp.prepareStatement(query2);
				rs = pstmt.executeQuery();
				errLine="884";
				
				while(rs.next())
				{
					errLine="888";
					String voucher_Id = rs.getString("Voucher_Id");
					java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
					int voucher_Type = rs.getInt("Voucher_Type");
					String voucher_No = rs.getString("Voucher_No");
					String ref_no = rs.getString("Ref_no");
					double local_total = rs.getDouble("Local_Amount");
					double dollar_total = rs.getDouble("Dollar_Amount");
					Boolean Transaction_Type = rs.getBoolean("Transaction_Type");
					String narration = rs.getString("Description");
					int Transaction_Id = rs.getInt("Tranasaction_Id");
					String voucherType_Name="";
					String voucher_Link="";
					errLine="901";

					double local_total_cr = 0;
					double local_total_dr = 0;
					double dollar_total_cr = 0;
					double dollar_total_dr = 0;

					String subQuery = "SELECT FT.Local_Amount, FT.Dollar_Amount, FT.Transaction_Type, FT.Tranasaction_Id FROM Financial_Transaction AS FT, Voucher AS V WHERE V.Voucher_Id=FT.Voucher_Id and Ledger_Id=0 and FT.For_Head=1 and FT.For_HeadId="+pnAccountId+" and V.company_id="+company_id+" and V.Active=1 and FT.Active=1 and (V.Voucher_Id ="+voucher_Id+" OR V.Referance_VoucherId="+voucher_Id+")";

					pstmt_g = cong.prepareStatement(subQuery);
					rs_g = pstmt_g.executeQuery();
					errLine="912";
					boolean notCalculated = true;

					while(rs_g.next())
					{
						errLine="917";

						double templocal_total = rs_g.getDouble("Local_Amount");
						double tempdollar_total = rs_g.getDouble("Dollar_Amount");
						Boolean tempTransaction_Type = rs_g.getBoolean("Transaction_Type");
						
						if(!tempTransaction_Type)
						{
							local_total_dr += templocal_total;
							dollar_total_dr += tempdollar_total;
						}
						if(tempTransaction_Type)
						{
							local_total_cr += templocal_total;
							dollar_total_cr += tempdollar_total;
						}

						if(local_total_dr > local_total_cr)
						{
							local_total_dr -= local_total_cr;
							local_total_cr = 0;
						}
						else
						{
							local_total_cr -= local_total_dr;
							local_total_dr = 0;
						}
						notCalculated=false;
					}
					rs_g.close();
					pstmt_g.close();
					errLine = "947";
					
					if(notCalculated)
					{
						if(!Transaction_Type)
						{
							local_total_dr = local_total;
							dollar_total_dr = dollar_total;
						}
						if(Transaction_Type)
						{
							local_total_cr = local_total;
							dollar_total_cr = dollar_total;
						}
					}

					errLine = "963";
					String particulars[] = new String[1];
					if(voucher_Type == 4 || voucher_Type == 7)
					{
						String subquery = "Select For_Head, For_HeadId, Ledger_Id, Transaction_Type from Financial_Transaction where Voucher_Id="+voucher_Id+" and Tranasaction_Id <> "+Transaction_Id+" and Active=1";
						
						errLine = "970";
						pstmt_g = cong.prepareStatement(subquery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						rs_g = pstmt_g.executeQuery();
						rs_g.last();
						int particularCount = rs_g.getRow();
						particulars = new String[particularCount];
						rs_g.beforeFirst();
						int q=0;
						while(rs_g.next())
						{	errLine="979";
							int For_Head = rs_g.getInt("For_Head");
							int For_HeadId = rs_g.getInt("For_HeadId");
							int Ledger_Id = rs_g.getInt("Ledger_Id");
							boolean transType = rs_g.getBoolean("Transaction_Type");
							if(For_Head == 1)
							{
								if(transType)
									particulars[q] = "To ("+ (String)Master_Account.get(For_HeadId-1) + ")";
								else
									particulars[q] = "By ("+ (String)Master_Account.get(For_HeadId-1) + ")";
							}
							else
							{	
								if(transType)
									particulars[q] = "To ("+ (String)Ledger.get(Ledger_Id-1) +")";
								else
									particulars[q] = "By ("+ (String)Ledger.get(Ledger_Id-1) +")";
							}
							q++;
						}
						rs_g.close();
						pstmt_g.close();
						errLine = "1001";

					}

					
					if(voucher_Type == 4)
					{
						voucherType_Name = "Contra";
						voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
					}
					if(voucher_Type == 7)
					{
						voucherType_Name = "Journal";
						voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
					}

					if(voucher_Type == 12)
					{
						particulars = new String[1]; 
						particulars[0]="By PN Account";
						voucherType_Name = "PN Sales Receipt";
						voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
					}
					
					if(voucher_Type == 13)
					{
						particulars = new String[1]; 
						particulars[0]="To PN Account";
						voucherType_Name = "PN Purchase Payment";
						voucher_Link = "../Report/Printvoucher1.jsp?voucher_type="+voucher_Type+"&voucher_id="+voucher_Id;
					}
					
					errLine="1033";
					customerVendorReportRow newRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucherType_Name, voucher_No,voucher_Link, ref_no, local_total_dr, local_total_cr, dollar_total_dr, dollar_total_cr, narration,"0","",voucher_Date,"0");

					totalPNList.add(newRow);
					//System.out.print(totalList.size());
					errLine="1038";
				}
				rs.close();
				pstmt.close();
			}//end of if
		}
		catch(Exception e)
		{
			System.out.println("Exception in getPNTransaction() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		
		ComparingDate comp = new ComparingDate();
		
		//sort the list
		Collections.sort(totalPNList, comp);
		
		//get the opening balance
		customerVendorReportRow openingRow = getPNOpeningBalance(cong, fromDate, opening_pn, dopening_pn,company_id, party_id);
		
		//get last index as per the toDate
		pnLastIndex = getPNLastIndex(toDate);
		
		//get the sublist of transactions between fromDate and toDate
		pnList = totalPNList.subList(pnFirstIndex,pnLastIndex);
		pnList.add(0, openingRow);
		
		return pnList;
	}//getPNTransaction()

	public customerVendorReportRow getPNOpeningBalance(Connection con, java.sql.Date fromDate, double opening_pn, double dopening_pn, String company_id, String party_id)
	{
		
		String errLine="1070";
		try{
		String voucher_Id ="";
		java.sql.Date voucher_Date = fromDate;
		String voucher_Type = "";//to indicate value not that in Master_Voucher but opening balance
		String voucher_No = "";
		String ref_no = "";
		Boolean Transaction_Type = true;// for credit
		String narration = "";
		String particulars[] = new String[1];
		particulars[0] = "Opening Balance";

		double op_local_cr = 0;
		double op_local_dr = 0;
		double op_dollar_cr = 0;
		double op_dollar_dr = 0;
		
		if( opening_pn > 0)
		{
			op_local_dr = opening_pn;
			op_dollar_dr = dopening_pn;
		}
		else
		{
			op_local_cr = opening_pn * -1;
			op_dollar_cr = dopening_pn * -1;
		}
		
		errLine="1098";

		if(totalPNList.size() != 0)
		{
			for(int i=0; i<totalPNList.size(); i++)
			{
				pnFirstIndex = i;
				customerVendorReportRow row = (customerVendorReportRow)totalPNList.get(i);
				errLine="1106";

				if(row.getVoucher_Date().compareTo(fromDate) < 0)
				{
					op_local_cr += row.getLocalAmt_Cr();
					op_local_dr += row.getLocalAmt_Dr();
					op_dollar_cr += row.getDollarAmt_Cr();
					op_dollar_dr += row.getDollarAmt_Dr();
					pnFirstIndex = i+1;
				}
				else
					break;

				errLine="1119";
			}//end for

			
			errLine="1123";
			if(op_local_cr >= op_local_dr)
			{
				op_local_cr -= op_local_dr;
				op_local_dr = 0;
				op_dollar_cr -= op_dollar_dr;
				op_dollar_dr = 0;
			}
			else
			{
				op_local_dr -= op_local_cr;
				op_local_cr = 0;
				op_dollar_dr -= op_dollar_cr;
				op_dollar_cr = 0;
			}
			
		
		}//end if
		errLine="1141";

		

		openingRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucher_Type, voucher_No, "", ref_no, op_local_dr, op_local_cr, op_dollar_dr, op_dollar_cr, narration,"0","",voucher_Date,"0");
	
		}
		catch(Exception e){
			System.out.println("Exception in getOpeningPNBalance() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		return openingRow;
	}//getPNOpeningBalance()

	public int getPNFirstIndex()
	{
		return pnFirstIndex;
	}//getPNFirstIndex()

	public int getPNLastIndex(java.sql.Date toDate)
	{
		if(totalPNList.size() != 0)
		{
			for(int i=pnFirstIndex; i<totalPNList.size(); i++)
			{
				customerVendorReportRow row = (customerVendorReportRow)totalPNList.get(i);
		
				if(row.getVoucher_Date().compareTo(toDate) > 0)
				{
					pnLastIndex =i;	
					return pnLastIndex;			
				}
			}//end for
		}//end if
		pnLastIndex =totalPNList.size();	
		return pnLastIndex;
	}//end getPNLastIndex()

	////////////////////////////////////////////////////
	//End : making all the PN calculations
	////////////////////////////////////////////////////
	////////////////////////////////////////////////////
	//Start : making all the Ledger calculations
	////////////////////////////////////////////////////
	public List getLedgerTransaction(Connection conp, Connection cong, java.sql.Date fromDate, java.sql.Date toDate,double Opening_LocalBalance[] ,double Opening_DollarBalance[],  String company_id, String party_id, String ctaxLedgerId)
	{
		YearEndIdNew GY=new YearEndIdNew();
		YearEndDate YED=new YearEndDate();
		NipponBean.Array A=new NipponBean.Array();
		ledgerList.clear();
		totalLedgerList.clear();
		ledgerFirstIndex=0;
		String errLine = "1241";
		String reportyearend_id = YED.returnYearEndId(cong , pstmt_g, rs_g,fromDate , company_id);//get YearEnd_Id of that /year
		try{
			String ledgerQuery="select count(*) as counter from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt=conp.prepareStatement(ledgerQuery);
			rs=pstmt.executeQuery();
			int lcount=0;
			while(rs.next())
			{
				lcount=rs.getInt("counter");
				
			}
			pstmt.close();

			String ledger_id[]=new String[lcount];
			//double Opening_LocalBalance[]=new double[lcount];
			//double Opening_DollarBalance[]=new double[lcount];
			ledgerQuery="select ledger_Id from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt=conp.prepareStatement(ledgerQuery);
			rs=pstmt.executeQuery();
			int r=0;
			while(rs.next())
			{
				ledger_id[r]=rs.getString("ledger_Id");
				r++;
			}
			pstmt.close();
			
			String voucher_name[]=new String[23];
			voucher_name[0]=""; 
			voucher_name[1]="Sales";  
			voucher_name[2]="Purchase"; 
			voucher_name[3]="Stock Transfer";
			voucher_name[4]="Contra"; 
			voucher_name[5]="Payment"; 
			voucher_name[6]="Receipt";
			voucher_name[7]="Journal";
			voucher_name[8]="Sales Receipt"; 
			voucher_name[9]="Purchase Payment"; 
			voucher_name[10]="Purchase Return"; 
			voucher_name[11]="Sales Return"; 
			voucher_name[12]="PN Sales Receipt"; 
			voucher_name[13]="PN Purchase Payment";
			voucher_name[14]="Journal (Sales Receipt)"; 
			voucher_name[15]="Journal (Purchase Payment)"; 
			voucher_name[16]="Journal (Account)"; 
			voucher_name[17]="Journal (Sale to sale)"; 
			voucher_name[18]="Journal (Purchase to Purchase)"; 
			voucher_name[19]="Journal (Sales Payment)"; 
			voucher_name[20]="Journal (Purchase Receipt)";
			voucher_name[21]="Journal (PN Payment)"; 
			voucher_name[22]="Journal (PN Receipt)"; 
			
			String NewLedger_Id="";
			 ArrayList year_endIdArray=GY.getYearEndIdsNew(cong, fromDate,toDate,company_id);
			// System.out.println("<br> 1274 year_endIdArray"+year_endIdArray.size());
			for(int k=0; k<year_endIdArray.size(); k++)
			{
				for(r=0;r<lcount;r++)
				{

				 reportyearend_id = ((Integer)(year_endIdArray.get(k))).toString();
				//System.out.println("<br> 1277 reportyearend_id"+reportyearend_id);
				//System.out.println("<br> 1278 ledger_id"+ledger_id[r]);
				NewLedger_Id = ledger_id[r];
				 String query="Select * from Financial_Transaction FT, Voucher V where FT.Transaction_Date between ? and ? and  FT.Ledger_id="+ledger_id[r]+" and FT.YearEnd_Id="+reportyearend_id+" and FT.Active=1 and V.Active=1 and FT.Voucher_Id=V.Voucher_Id order by FT.Transaction_Date, FT.Tranasaction_Id";
				
				pstmt = conp.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt.setString(1,""+fromDate);
				pstmt.setString(2,""+toDate);
				errLine = "1283";
				rs = pstmt.executeQuery();
				int m=0;
				rs.last();
				int particularCount = rs.getRow();
				String particulars[]= new String[particularCount];
				errLine = "1286";
				String ReceiveFrom_LedgerId="";
				rs.beforeFirst();
				while(rs.next())
				{
					
					String voucher_id=rs.getString("Voucher_Id");
					//System.out.println("1294 voucher_id"+voucher_id);
					String narration=rs.getString("Description");
					String transaction_type = rs.getString("Transaction_Type");
					double local=rs.getDouble("Local_Amount");
					double dollar=rs.getDouble("Dollar_Amount");
					
					errLine = "1295";
					String Voucher_No = rs.getString("Voucher_No");
					
			
					String exch = rs.getString("Exchange_Rate");

					java.sql.Date transaction_date = rs.getDate("Transaction_Date");
					ReceiveFrom_LedgerId=rs.getString("ReceiveFrom_LedgerId");
				//	System.out.println(" 1305 ReceiveFrom_LedgerId"+ReceiveFrom_LedgerId);
					String ref_no = rs.getString("Ref_No");
					

					String Voucher = Voucher_No;
					int voucher_type = rs.getInt("Voucher_Type");
					java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
					int v_type=0;
					errLine = "1315";
					String voucherType_Name="";
					String voucher_Link="";
					
					String type="";
					String for_head="";
					String tledger_id="";
					String for_headid="";
					errLine = "1322";
					String to_by="To";
					String voucher_No="";
					String recv_no="";
					String Referance_VoucherId="";
					double exc_rate=0;
					if("1".equals(transaction_type))
					{						
						to_by="By";

						String FTQuery="Select For_Head,Ledger_id,For_HeadId from Financial_Transaction where transaction_type=0 and Voucher_id="+voucher_id;
						errLine = "1335";
						pstmt_g=conp.prepareStatement(FTQuery);
						rs_g=pstmt_g.executeQuery();
						while(rs_g.next())
						{
							for_head=rs_g.getString("For_Head");
							tledger_id=rs_g.getString("Ledger_id");
							for_headid=rs_g.getString("For_HeadId");
						}
						pstmt_g.close();
					}
					else
					{
						 String FTQuery="Select For_Head,Ledger_id,For_HeadId from Financial_Transaction where transaction_type=1 and Voucher_id="+voucher_id+"";
						pstmt_g=conp.prepareStatement(FTQuery);
						errLine = "1350";
						rs_g=pstmt_g.executeQuery();
						errLine = "1352";
						while(rs_g.next())
						{
							for_head=rs_g.getString("For_Head");
							tledger_id=rs_g.getString("Ledger_id");
							for_headid=rs_g.getString("For_HeadId");
						}
						pstmt_g.close();
											
					}

					if("4".equals(for_head))
					{
						type="Cash";
					}
					else if("1".equals(for_head))
					{
						errLine = "1368";
						type=A.getName(cong,"Account",for_headid);
						
					}
					else if("".equals(for_head))
					{
						errLine = "1374";
						type=A.getNameCondition(cong,"Ledger","Ledger_Name","where Ledger_Id= "+ReceiveFrom_LedgerId+" and YearEnd_Id="+reportyearend_id);
							
					}
					else{
						errLine = "1378";
						type=A.getNameCondition(cong,"Ledger","Ledger_Name","Where For_Head="+for_head+" and For_HeadId="+for_headid+" and Ledger_id="+tledger_id+" and YearEnd_Id="+reportyearend_id);
						
						}

					String voucherQuery="select Voucher_type,Exchange_Rate,Voucher_No,Description from voucher where Voucher_Id="+voucher_id;
					pstmt_g=cong.prepareStatement(voucherQuery);
					errLine = "1384";
					rs_g=pstmt_g.executeQuery();
					while(rs_g.next())
					{
						 v_type=rs_g.getInt("Voucher_type");
						exc_rate=rs_g.getDouble("Exchange_Rate");
						 voucher_No=rs_g.getString("Voucher_No");
						String  v_description=rs_g.getString("Description");
					}
					pstmt_g.close();
					if((v_type==1)||(v_type==2)||(v_type==10)||(v_type==11))
					{
						
						 recv_no=A.getName(cong,"Receive","Receive_No","Receive_Id",voucher_No);
						errLine = "1384";
						if(v_type==1)
						{
							voucher_Link ="../Inventory/InvDetailReport.jsp?command=sale&receive_id="+voucher_No;
						}else if(v_type==2)
						{
								voucher_Link ="../Inventory/InvDetailReport.jsp?command=purchase&receive_id="+voucher_No;
						}else if(v_type==10)
						{
							voucher_Link="../Inventory/PurchaseReturnInvoice.jsp?command=sale&receive_id="+voucher_No;
						}else if(v_type==11)
						{
							voucher_Link="../Inventory/PurchaseReturnInvoice.jsp?command=purchase&receive_id="+voucher_No;
						}


					}else if((v_type==8)||(v_type==9)||(v_type==12)||(v_type==13))
					{
						errLine = "1402";
						 voucherQuery="select Referance_VoucherId from voucher where Voucher_Id="+voucher_id;
						pstmt_g=cong.prepareStatement(voucherQuery);
						rs_g=pstmt_g.executeQuery();
						while(rs_g.next())
						{
							
							Referance_VoucherId=rs_g.getString("Referance_VoucherId");
						}
						pstmt_g.close();
						voucher_Link="../Report/Printvoucher1.jsp?voucher_type="+v_type+"&voucher_id="+Referance_VoucherId;

					}else
					{
						voucher_Link ="../Report/Printvoucher1.jsp?voucher_type="+v_type+"&voucher_id="+voucher_id;
					
					}
				
					particulars[m] = to_by + type;
					voucherType_Name= voucher_name[v_type];
					//System.out.println("1439 particulars"+particulars[0]);
				//	System.out.println("1440 voucherType_Name"+voucherType_Name);
					double local_trans_cr=0;
					double local_trans_dr=0;
					double local_closing = 0;
					double dollar_closing = 0;
					double dollar_trans_cr=0;
					double dollar_trans_dr=0;
					double local_total_cr = 0;
					double local_total_dr = 0;
					double dollar_total_cr = 0;
					double dollar_total_dr = 0;

					if("0".equals(transaction_type))
					{
						local_trans_dr = local;
						dollar_trans_dr = dollar;
						local_closing += local;
						dollar_closing += dollar;
					}
					else
					{
						local_trans_cr = local;
						dollar_trans_cr = dollar;
						local_closing -= local;
						dollar_closing -= dollar;
					}
					local_total_dr += local_trans_dr;
					local_total_cr += local_trans_cr;
					dollar_total_dr += dollar_trans_dr;
					dollar_total_cr += dollar_trans_cr;
					//System.out.println()
				errLine = "1452";
				//System.out.println("1472 Before Return the List");
				if((v_type==1)||(v_type==2)||(v_type==10)||(v_type==11))
					{
						customerVendorReportRow newRow = new customerVendorReportRow(voucher_id, voucher_Date, particulars, voucherType_Name, recv_no,voucher_Link, ref_no, local_total_dr, local_total_cr,dollar_total_dr,dollar_total_cr, narration,"0",NewLedger_Id,voucher_Date,"0");

						totalLedgerList.add(newRow); 
						//System.out.println("1477 Under the if ");
					}else
					{
						customerVendorReportRow newRow = new customerVendorReportRow(voucher_id, voucher_Date, particulars, voucherType_Name, voucher_No,voucher_Link, ref_no,local_total_dr, local_total_cr,dollar_total_dr,dollar_total_cr, narration,"0",NewLedger_Id,voucher_Date,"0");

						totalLedgerList.add(newRow); 
					//	System.out.println("1482 Under the else ");
					}
					m++;
				}//while
			//	System.out.println("1486 after for loop k="+k);
			}
		}//for

		//	System.out.println("1489 after for loop");
		}//try..
		catch(Exception e)
		{
			System.out.println("Exception in getPurchaseTransaction() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		
		//System.out.println("1496 after try block");
		ComparingDate comp = new ComparingDate();
		
		//sort the list
		Collections.sort(totalLedgerList, comp);
		
		//get the opening balance
		customerVendorReportRow openingRow = getLedgerOpeningBalance(cong, fromDate, Opening_LocalBalance, Opening_DollarBalance,company_id, party_id);
		//System.out.println("1504 after try block");
		//get last index as per the toDate
		ledgerLastIndex = getLedgerLastIndex(toDate);
		//System.out.println("1507 ledgerLastIndex"+ledgerLastIndex);
		//get the sublist of transactions between fromDate and toDate
		ledgerList = totalLedgerList.subList(ledgerFirstIndex,ledgerLastIndex);
		//System.out.println("1510 after try block");
		ledgerList.add(0, openingRow);
		//System.out.println("1512 Return the List");
		return ledgerList;
	}//getLedgerTransaction()
	////////////////////////////////////////////////////
	//End : making all the Ledger calculations
	////////////////////////////////////////////////////
		public int getLedgerFirstIndex()
	{
		return ledgerFirstIndex;
	}//getSaleFirstIndex()

	public int getLedgerLastIndex(java.sql.Date toDate)
	{
		if(totalLedgerList.size() != 0)
		{
			for(int i=ledgerFirstIndex; i<totalLedgerList.size(); i++)
			{
				customerVendorReportRow row = (customerVendorReportRow)totalLedgerList.get(i);
		
				if(row.getVoucher_Date().compareTo(toDate) > 0)
				{
					ledgerLastIndex =i;	
					return ledgerLastIndex;			
				}
			}//end for
		}//end if
		ledgerLastIndex =totalLedgerList.size();	
		return ledgerLastIndex;
	}//end getledgereLastIndex()



	//returns the opening balance row for the given party
	public customerVendorReportRow getLedgerOpeningBalance(Connection con, java.sql.Date fromDate, double Opening_LocalBalance[], double Opening_DollarBalance[], String company_id, String party_id)
	{
		//System.out.println(" 1575 under method ");
		String errLine="653";
		try{
		String voucher_Id ="";
		java.sql.Date voucher_Date = fromDate;
		String voucher_Type = "";//to indicate value not that in Master_Voucher but opening balance
		String voucher_No = "";
		String ref_no = "";
		Boolean Transaction_Type = true;// for credit
		String narration = "";
		String particulars[] = new String[1];
		particulars[0] = "Opening Balance";

		double op_local_cr = 0;
		double op_local_dr = 0;
		double op_dollar_cr = 0;
		double op_dollar_dr = 0;
	for(int j=0; j<Opening_LocalBalance.length;j++)
	{
		//System.out.println("<br> Opening_LocalBalance[j]"+Opening_LocalBalance[j]);

		if( Opening_LocalBalance[j] > 0)
		{
			op_local_dr += Opening_LocalBalance[j];
			op_dollar_dr += Opening_DollarBalance[j];
		}
		else
		{
			op_local_cr += Opening_LocalBalance[j] * -1;
			op_dollar_cr += Opening_DollarBalance[j] * -1;
		}
		
		errLine="681";

		if(totalLedgerList.size() != 0)
		{
			//System.out.println(" 1608 under method 1st if "+totalLedgerList.size());
			for(int i=0; i<totalLedgerList.size(); i++)
			{
				ledgerFirstIndex = i;
				customerVendorReportRow row = (customerVendorReportRow)totalLedgerList.get(i);
				errLine="689";
		//System.out.println(" 1614 under method 1st for voucher date  "+row.getVoucher_Date());
				if(row.getVoucher_Date().compareTo(fromDate) < 0)
				{
					//System.out.println("1616 getLocalAmt_Cr"+row.getLocalAmt_Cr());
					//System.out.println("1617 getLocalAmt_Dr"+row.getLocalAmt_Dr());
					//System.out.println("1618 getDollarAmt_Cr"+row.getDollarAmt_Cr());
					//System.out.println("1619 getDollarAmt_Dr"+row.getDollarAmt_Dr());
					op_local_cr += row.getLocalAmt_Cr();
					op_local_dr += row.getLocalAmt_Dr();
					op_dollar_cr += row.getDollarAmt_Cr();
					op_dollar_dr += row.getDollarAmt_Dr();
					purchaseFirstIndex=i+1;
				}
				else
					break;

				errLine="702";
			}//end for

			
			errLine="712";
			if(op_local_cr >= op_local_dr)
			{
				op_local_cr -= op_local_dr;
			//	System.out.println("1638 op_local_cr"+op_local_cr);
				op_local_dr = 0;
				op_dollar_cr -= op_dollar_dr;
			//	System.out.println("1641 op_dollar_cr"+op_dollar_cr);
				op_dollar_dr = 0;
			}
			else
			{
				op_local_dr -= op_local_cr;
				op_local_cr = 0;
				op_dollar_dr -= op_dollar_cr;
				op_dollar_cr = 0;
			}
			
		
		}//end if
		errLine="730";

		
	}//end for	
		openingRow = new customerVendorReportRow(voucher_Id, voucher_Date, particulars, voucher_Type, voucher_No, "", ref_no, op_local_dr, op_local_cr, op_dollar_dr, op_dollar_cr, narration,"0","",voucher_Date,"0");
	//}//
		}
		catch(Exception e){
			System.out.println("Exception in getOpeningPurchaseBalance() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		return openingRow;
	}//getledgerOpeningBalance()



////////////////////////////////////////////////////
	//Start : making all the DayBook calculations
	////////////////////////////////////////////////////
	public List getDayBookTransaction(Connection conp, Connection cong, java.sql.Date fromDate, java.sql.Date toDate,double Opening_LocalBalance[] ,double Opening_DollarBalance[],  String company_id, String ctaxLedgerId)
	{
		YearEndIdNew GY=new YearEndIdNew();
		YearEndDate YED=new YearEndDate();
		NipponBean.Array A=new NipponBean.Array();
		ledgerList.clear();
		totalLedgerList.clear();
		ledgerFirstIndex=0;
		String errLine = "1241";
		String reportyearend_id = YED.returnYearEndId(cong , pstmt_g, rs_g,fromDate , company_id);//get YearEnd_Id of that /year
		try{
			String ledgerQuery="select count(*) as counter from ledger where company_id="+company_id;
			pstmt=conp.prepareStatement(ledgerQuery);
			rs=pstmt.executeQuery();
			int lcount=0;
			while(rs.next())
			{
				lcount=rs.getInt("counter");
				
			}
			pstmt.close();

			String ledger_id[]=new String[lcount];
			//double Opening_LocalBalance[]=new double[lcount];
			//double Opening_DollarBalance[]=new double[lcount];
			ledgerQuery="select ledger_Id from ledger where company_id="+company_id;
			pstmt=conp.prepareStatement(ledgerQuery);
			rs=pstmt.executeQuery();
			int r=0;
			while(rs.next())
			{
				ledger_id[r]=rs.getString("ledger_Id");
				r++;
			}
			pstmt.close();
			
			String voucher_name[]=new String[23];
			voucher_name[0]=""; 
			voucher_name[1]="Sales";  
			voucher_name[2]="Purchase"; 
			voucher_name[3]="Stock Transfer";
			voucher_name[4]="Contra"; 
			voucher_name[5]="Payment"; 
			voucher_name[6]="Receipt";
			voucher_name[7]="Journal";
			voucher_name[8]="Sales Receipt"; 
			voucher_name[9]="Purchase Payment"; 
			voucher_name[10]="Purchase Return"; 
			voucher_name[11]="Sales Return"; 
			voucher_name[12]="PN Sales Receipt"; 
			voucher_name[13]="PN Purchase Payment";
			voucher_name[14]="Journal (Sales Receipt)"; 
			voucher_name[15]="Journal (Purchase Payment)"; 
			voucher_name[16]="Journal (Account)"; 
			voucher_name[17]="Journal (Sale to sale)"; 
			voucher_name[18]="Journal (Purchase to Purchase)"; 
			voucher_name[19]="Journal (Sales Payment)"; 
			voucher_name[20]="Journal (Purchase Receipt)";
			voucher_name[21]="Journal (PN Payment)"; 
			voucher_name[22]="Journal (PN Receipt)"; 
			
			String NewLedger_Id="";
			 ArrayList year_endIdArray=GY.getYearEndIdsNew(cong, fromDate,toDate,company_id);
			// System.out.println("<br> 1274 year_endIdArray"+year_endIdArray.size());
			for(int k=0; k<year_endIdArray.size(); k++)
			{
				for(r=0;r<lcount;r++)
				{

				 reportyearend_id = ((Integer)(year_endIdArray.get(k))).toString();
				//System.out.println("<br> 1277 reportyearend_id"+reportyearend_id);
				//System.out.println("<br> 1278 ledger_id"+ledger_id[r]);
				NewLedger_Id = ledger_id[r];
				 String query="Select * from Financial_Transaction FT, Voucher V where FT.Transaction_Date between ? and ? and  FT.Ledger_id="+ledger_id[r]+" and FT.YearEnd_Id="+reportyearend_id+" and FT.Active=1 and V.Active=1 and FT.Voucher_Id=V.Voucher_Id order by FT.Transaction_Date, FT.Tranasaction_Id";
				
				pstmt = conp.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				pstmt.setString(1,""+fromDate);
				pstmt.setString(2,""+toDate);
				errLine = "1283";
				rs = pstmt.executeQuery();
				int m=0;
				rs.last();
				int particularCount = rs.getRow();
				String particulars[]= new String[particularCount];
				errLine = "1286";
				String ReceiveFrom_LedgerId="";
				rs.beforeFirst();
				while(rs.next())
				{
					
					String voucher_id=rs.getString("Voucher_Id");
					//System.out.println("1294 voucher_id"+voucher_id);
					String narration=rs.getString("Description");
					String transaction_type = rs.getString("Transaction_Type");
					double local=rs.getDouble("Local_Amount");
					double dollar=rs.getDouble("Dollar_Amount");
					
					errLine = "1295";
					String Voucher_No = rs.getString("Voucher_No");
					
			
					String exch = rs.getString("Exchange_Rate");

					java.sql.Date transaction_date = rs.getDate("Transaction_Date");
					ReceiveFrom_LedgerId=rs.getString("ReceiveFrom_LedgerId");
				//	System.out.println(" 1305 ReceiveFrom_LedgerId"+ReceiveFrom_LedgerId);
					String ref_no = rs.getString("Ref_No");
					

					String Voucher = Voucher_No;
					int voucher_type = rs.getInt("Voucher_Type");
					java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
					int v_type=0;
					errLine = "1315";
					String voucherType_Name="";
					String voucher_Link="";
					
					String type="";
					String for_head="";
					String tledger_id="";
					String for_headid="";
					errLine = "1322";
					String to_by="To";
					String voucher_No="";
					String recv_no="";
					String Referance_VoucherId="";
					double exc_rate=0;
					if("1".equals(transaction_type))
					{						
						to_by="By";

						String FTQuery="Select For_Head,Ledger_id,For_HeadId from Financial_Transaction where transaction_type=0 and Voucher_id="+voucher_id;
						errLine = "1335";
						pstmt_g=conp.prepareStatement(FTQuery);
						rs_g=pstmt_g.executeQuery();
						while(rs_g.next())
						{
							for_head=rs_g.getString("For_Head");
							tledger_id=rs_g.getString("Ledger_id");
							for_headid=rs_g.getString("For_HeadId");
						}
						pstmt_g.close();
					}
					else
					{
						 String FTQuery="Select For_Head,Ledger_id,For_HeadId from Financial_Transaction where transaction_type=1 and Voucher_id="+voucher_id+"";
						pstmt_g=conp.prepareStatement(FTQuery);
						errLine = "1350";
						rs_g=pstmt_g.executeQuery();
						errLine = "1352";
						while(rs_g.next())
						{
							for_head=rs_g.getString("For_Head");
							tledger_id=rs_g.getString("Ledger_id");
							for_headid=rs_g.getString("For_HeadId");
						}
						pstmt_g.close();
											
					}

					if("4".equals(for_head))
					{
						type="Cash";
					}
					else if("1".equals(for_head))
					{
						errLine = "1368";
						type=A.getName(cong,"Account",for_headid);
						
					}
					else if("".equals(for_head))
					{
						errLine = "1374";
						type=A.getNameCondition(cong,"Ledger","Ledger_Name","where Ledger_Id= "+ReceiveFrom_LedgerId+" and YearEnd_Id="+reportyearend_id);
							
					}
					else{
						errLine = "1378";
						type=A.getNameCondition(cong,"Ledger","Ledger_Name","Where For_Head="+for_head+" and For_HeadId="+for_headid+" and Ledger_id="+tledger_id+" and YearEnd_Id="+reportyearend_id);
						
						}

					String voucherQuery="select Voucher_type,Exchange_Rate,Voucher_No,Description from voucher where Voucher_Id="+voucher_id;
					pstmt_g=cong.prepareStatement(voucherQuery);
					errLine = "1384";
					rs_g=pstmt_g.executeQuery();
					while(rs_g.next())
					{
						 v_type=rs_g.getInt("Voucher_type");
						exc_rate=rs_g.getDouble("Exchange_Rate");
						 voucher_No=rs_g.getString("Voucher_No");
						String  v_description=rs_g.getString("Description");
					}
					pstmt_g.close();
					if((v_type==1)||(v_type==2)||(v_type==10)||(v_type==11))
					{
						
						 recv_no=A.getName(cong,"Receive","Receive_No","Receive_Id",voucher_No);
						errLine = "1384";
						if(v_type==1)
						{
							voucher_Link ="../Inventory/InvDetailReport.jsp?command=sale&receive_id="+voucher_No;
						}else if(v_type==2)
						{
								voucher_Link ="../Inventory/InvDetailReport.jsp?command=purchase&receive_id="+voucher_No;
						}else if(v_type==10)
						{
							voucher_Link="../Inventory/PurchaseReturnInvoice.jsp?command=sale&receive_id="+voucher_No;
						}else if(v_type==11)
						{
							voucher_Link="../Inventory/PurchaseReturnInvoice.jsp?command=purchase&receive_id="+voucher_No;
						}


					}else if((v_type==8)||(v_type==9)||(v_type==12)||(v_type==13))
					{
						errLine = "1402";
						 voucherQuery="select Referance_VoucherId from voucher where Voucher_Id="+voucher_id;
						pstmt_g=cong.prepareStatement(voucherQuery);
						rs_g=pstmt_g.executeQuery();
						while(rs_g.next())
						{
							
							Referance_VoucherId=rs_g.getString("Referance_VoucherId");
						}
						pstmt_g.close();
						voucher_Link="../Report/Printvoucher1.jsp?voucher_type="+v_type+"&voucher_id="+Referance_VoucherId;

					}else
					{
						voucher_Link ="../Report/Printvoucher1.jsp?voucher_type="+v_type+"&voucher_id="+voucher_id;
					
					}
				
					particulars[m] = to_by + type;
					voucherType_Name= voucher_name[v_type];
					//System.out.println("1439 particulars"+particulars[0]);
				//	System.out.println("1440 voucherType_Name"+voucherType_Name);
					double local_trans_cr=0;
					double local_trans_dr=0;
					double local_closing = 0;
					double dollar_closing = 0;
					double dollar_trans_cr=0;
					double dollar_trans_dr=0;
					double local_total_cr = 0;
					double local_total_dr = 0;
					double dollar_total_cr = 0;
					double dollar_total_dr = 0;

					if("0".equals(transaction_type))
					{
						local_trans_dr = local;
						dollar_trans_dr = dollar;
						local_closing += local;
						dollar_closing += dollar;
					}
					else
					{
						local_trans_cr = local;
						dollar_trans_cr = dollar;
						local_closing -= local;
						dollar_closing -= dollar;
					}
					local_total_dr += local_trans_dr;
					local_total_cr += local_trans_cr;
					dollar_total_dr += dollar_trans_dr;
					dollar_total_cr += dollar_trans_cr;
					//System.out.println()
				errLine = "1452";
				//System.out.println("1472 Before Return the List");
				if((v_type==1)||(v_type==2)||(v_type==10)||(v_type==11))
					{
						customerVendorReportRow newRow = new customerVendorReportRow(voucher_id, voucher_Date, particulars, voucherType_Name, recv_no,voucher_Link, ref_no, local_total_dr, local_total_cr,dollar_total_dr,dollar_total_cr, narration,"0",NewLedger_Id,voucher_Date,"0");

						totalLedgerList.add(newRow); 
						//System.out.println("1477 Under the if ");
					}else
					{
						customerVendorReportRow newRow = new customerVendorReportRow(voucher_id, voucher_Date, particulars, voucherType_Name, voucher_No,voucher_Link, ref_no,local_total_dr, local_total_cr,dollar_total_dr,dollar_total_cr, narration,"0",NewLedger_Id,voucher_Date,"0");

						totalLedgerList.add(newRow); 
					//	System.out.println("1482 Under the else ");
					}
					m++;
				}//while
			//	System.out.println("1486 after for loop k="+k);
			}
		}//for

		//	System.out.println("1489 after for loop");

		}//try..
		catch(Exception e)
		{
			System.out.println("Exception in getPurchaseTransaction() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		
		//System.out.println("1496 after try block");
		//ComparingDate comp = new ComparingDate();
		
		//sort the list
		//Collections.sort(totalLedgerList, comp);
		
		//get the opening balance
		//customerVendorReportRow openingRow = getLedgerOpeningBalance(cong, fromDate, Opening_LocalBalance, Opening_DollarBalance,company_id, party_id);
		//System.out.println("1504 after try block");
		//get last index as per the toDate
		//ledgerLastIndex = getLedgerLastIndex(toDate);
		//System.out.println("1507 ledgerLastIndex"+ledgerLastIndex);
		//get the sublist of transactions between fromDate and toDate
		//ledgerList = totalLedgerList.subList(ledgerFirstIndex,ledgerLastIndex);
		//System.out.println("1510 after try block");
		//ledgerList.add(0, openingRow);
		//System.out.println("1512 Return the List");
		//return ledgerList;
		return totalLedgerList;
	}//getLedgerTransaction()
	////////////////////////////////////////////////////
	//End : making all the DayBook calculations
	////////////////////////////////////////////////////





	////////////////////////////////////////////////////
	//Start : ordering of the list
	////////////////////////////////////////////////////
	public List orderList(List listToOrder, String orderType){
		if("voucherNo".equals(orderType))
		{
			ComparingPartyReportVoucherNo comp = new ComparingPartyReportVoucherNo();
			//sort the list
			Collections.sort(listToOrder, comp);
		}

		if("refNo".equals(orderType))
		{
			ComparingPartyReportRefNo comp = new ComparingPartyReportRefNo();
			//sort the list
			Collections.sort(listToOrder, comp);
		}

		if("voucherType".equals(orderType))
		{
			ComparingPartyReportVoucherType comp = new ComparingPartyReportVoucherType();
			//sort the list
			Collections.sort(listToOrder, comp);
		}

		return listToOrder;
	}
	////////////////////////////////////////////////////
	//End : ordering of the list
	////////////////////////////////////////////////////



	////////////////////////////////////////////////////
	//Start : mingling of the sale and purchase list and LedgerList
	////////////////////////////////////////////////////
	public List mingleList(List partySaleList, List partyPurchaseList,List partyLedgerList){
		String errLine = "1232";
		List mingledList = new ArrayList();

		try{
//System.out.println("1610 partyPurchaseListlist "+partyPurchaseList.size());
		customerVendorReportRow purOpeningRow = (customerVendorReportRow)partyPurchaseList.get(0);
		errLine = "1532";
		//System.out.println("1613 partySaleList size"+partySaleList.size());
		customerVendorReportRow saleOpeningRow = (customerVendorReportRow)partySaleList.get(0);
		errLine = "1535";
		
		//System.out.println("1617 list size"+partyLedgerList.size());
		customerVendorReportRow ledgerOpeningRow = (customerVendorReportRow)partyLedgerList.get(0);
		errLine = "1538";

		double localOpDr = purOpeningRow.getLocalAmt_Dr() + saleOpeningRow.getLocalAmt_Dr() + ledgerOpeningRow.getLocalAmt_Dr(); 
		
		//System.out.println("1621 getLocalAmt_Dr"+ledgerOpeningRow.getLocalAmt_Dr());

		double localOpCr = purOpeningRow.getLocalAmt_Cr() + saleOpeningRow.getLocalAmt_Cr()+ ledgerOpeningRow.getLocalAmt_Cr();
	
		//System.out.println("1624 getLocalAmt_Cr"+ledgerOpeningRow.getLocalAmt_Cr());


		double dollarOpDr = purOpeningRow.getDollarAmt_Dr() + saleOpeningRow.getDollarAmt_Dr()+ ledgerOpeningRow.getDollarAmt_Dr();
		
		//System.out.println("1628 getDollarAmt_Dr"+ledgerOpeningRow.getDollarAmt_Dr());


		double dollarOpCr = purOpeningRow.getDollarAmt_Cr() + saleOpeningRow.getDollarAmt_Cr() +ledgerOpeningRow.getDollarAmt_Cr();
		
		//System.out.println("1632 getDollarAmt_Dr"+ledgerOpeningRow.getDollarAmt_Cr());

		errLine = "1544";

		if(localOpDr > localOpCr)
		{
			localOpDr = localOpDr - localOpCr;
			localOpCr = 0;
		}
		else
		{
			localOpCr = localOpCr - localOpDr;
			localOpDr = 0;
		}
		if(dollarOpDr > dollarOpCr)
		{
			dollarOpDr = dollarOpDr - dollarOpCr;
			dollarOpCr = 0;
		}
		else
		{
			dollarOpCr = dollarOpCr - dollarOpDr;
			dollarOpDr = 0;
		}


		java.sql.Date voucher_Date = purOpeningRow.getVoucher_Date();
		java.sql.Date Due_Date = purOpeningRow.getDueDate();

		
		String particulars[] = new String[1];
		particulars[0] = "Opening Balance";
		errLine = "1270";

		customerVendorReportRow mingledOpeningRow = new customerVendorReportRow("", voucher_Date, particulars, "", "", "", "", localOpDr, localOpCr, dollarOpDr, dollarOpCr, "","0","",Due_Date,"0");
	
		partySaleList.remove(0); //removes the opening row
		partyPurchaseList.remove(0); //removes the opening row
		partyLedgerList.remove(0);
		errLine = "1276";

		//add the purchase and sale lists into a single list
		mingledList.addAll(partyPurchaseList);
		mingledList.addAll(partySaleList);
		mingledList.addAll(partyLedgerList);
		errLine = "1281";

		//sort this mixed list on transaction_date to mingle the sale and purchase transactions
		ComparingDate comp = new ComparingDate();
		Collections.sort(mingledList, comp);

		mingledList.add(0, mingledOpeningRow);
		errLine = "1288";
		}
		catch (Exception e)
		{	
			System.out.println("Exception in mingleList() in CustomerVendorReport after Line:"+errLine+" is "+e);
		}
		return mingledList;
	}
	////////////////////////////////////////////////////
	//End : mingling of the sale and purchase list 
	////////////////////////////////////////////////////

}//end of class


//use to sort the list of transactions on date
class ComparingDate implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   java.sql.Date date1 = ((customerVendorReportRow)obj1).getVoucher_Date();
	   java.sql.Date date2 = ((customerVendorReportRow)obj2).getVoucher_Date();
	  
	   return ((date1).compareTo(date2));	 
	}	
}


//use to sort the list on voucher no
class ComparingPartyReportVoucherNo implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   String voucherNo1 = ((customerVendorReportRow)obj1).getVoucher_No();
	   String voucherNo2 = ((customerVendorReportRow)obj2).getVoucher_No();
	  
	   return ((voucherNo1).compareToIgnoreCase(voucherNo2));	 
	}	
}

//use to sort the list on reference no
class ComparingPartyReportRefNo implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   String refNo1 = ((customerVendorReportRow)obj1).getRef_No();
	   String refNo2 = ((customerVendorReportRow)obj2).getRef_No();
	  
	   return ((refNo1).compareToIgnoreCase(refNo2));	 
	}	
}

//use to sort the list on voucher type
class ComparingPartyReportVoucherType implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   String voucherType1 = ((customerVendorReportRow)obj1).getVoucher_Type();
	   String voucherType2 = ((customerVendorReportRow)obj2).getVoucher_Type();
	  
	   return ((voucherType1).compareToIgnoreCase(voucherType2));	 
	}	
}

