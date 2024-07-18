package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  CustomerVendorDetail
{
	ResultSet rs=null;
	PreparedStatement pstmt=null;
	
	double local_opening_dr=0;
	double local_opening_cr=0;
	double local_trans_dr=0;
	double local_trans_cr=0;
	double local_closing_dr=0;
	double local_closing_cr=0;

	double dollar_opening_dr=0;
	double dollar_opening_cr=0;
	double dollar_trans_dr=0;
	double dollar_trans_cr=0;
	double dollar_closing_dr=0;
	double dollar_closing_cr=0;

	int firstIndex;
	int lastIndex;

	List allPartyList = new ArrayList();
	List allLedgerList = new ArrayList();
	
	customerVendorDetailTrans openingRow;

	//get the exchange gainloss upto a given date
	public double partyExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, String type) 
	{
		double ExchangeGainLoss = 0;
		String Receive_Sell = "";
		if("sale".equals(type))
			Receive_Sell="0";
		else
			Receive_Sell="1";

		try{
		
		String query="";
		query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and PD.Transaction_Date <=? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell="+Receive_Sell+" order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			ExchangeGainLoss += ( rs.getDouble("Exchange_Rate")*rs.getDouble("Dollar_Amount")  )	- rs.getDouble("Local_Amount");
		}//while
		rs.close();
		pstmt.close();
		
		}catch(Exception e)
		{
			System.out.println("Exception in partyExchangeGainLoss(D1) :" +e);
		}

		if("sale".equals(type))
			return ExchangeGainLoss;
		else
			return ExchangeGainLoss * -1;
	}//exchangeGainLoss


	//get the exchange gainloss within a given date range
	public double partyExchangeGainLoss(Connection con,String party_id, String company_id,java.sql.Date D1, java.sql.Date D2, String type) 
	{
		double ExchangeGainLoss = 0;
		String Receive_Sell = "";
		if("sale".equals(type))
			Receive_Sell="0";
		else
			Receive_Sell="1";

		try{

		String query="";
		query="Select * from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and R.Receive_FromId="+party_id+" and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell="+Receive_Sell+" order by R.Receive_id";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);	
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		while(rs.next()) 
			{
				ExchangeGainLoss += ( rs.getDouble("Exchange_Rate")*rs.getDouble("Dollar_Amount")  )	- rs.getDouble("Local_Amount");
			}
		rs.close();
		pstmt.close();
		}
		catch(Exception e)
		{
			System.out.print("Exception in partySaleExchangeGainLoss(D1, D2) :" +e);
		}
		if("sale".equals(type))
			return ExchangeGainLoss;
		else
			return ExchangeGainLoss * -1;
	}//exchangeGainLoss 

	//CustomerVendorDetailRow between the dates D1 and D2 for a party group
	public void CustomerVendorDetailAllRows(String[] ledgerId, Connection conp, java.sql.Date D1, java.sql.Date D2, String[] party_id, String company_id, String type, String ctaxLedgerId)
	{

		allPartyList.clear();
		allLedgerList.clear();
		List totalList = new ArrayList();
		//from the ledger_ids and party_ids create the criteria
		
		String tempParty="(";
		for(int i=0; i<party_id.length; i++)
		{
			if("(".equals(tempParty))
				{tempParty+=party_id[i];}
			else
				{tempParty+=","+party_id[i];}
		}		
		tempParty+=")";

		String tempLedger="(";
		for(int i=0; i<ledgerId.length; i++)
		{
			if("(".equals(tempLedger))
				{
					if( !("".equals(ledgerId)) )
						tempLedger+=ledgerId[i];
				}
			else
				{
					if( !("".equals(ledgerId)) )
						tempLedger+=","+ledgerId[i];
				}
		}		
		tempLedger+=")";

		String errLine="136";
		String voucherType_condition = "";
		if( "sale".equals(type) )
			voucherType_condition = "(V.voucher_type=1 Or V.Voucher_type=11)";
		else
			voucherType_condition = "(V.voucher_type=2 Or V.Voucher_type=10)";
		
		try{
			//getting sales/purchase, sales return/puchase return
			String query1 = "SELECT DISTINCT (V.Voucher_Id), V.Voucher_Date, V.Voucher_Type, V.Local_Total, V.Dollar_Total, R.Receive_FromId FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE "+voucherType_condition+" And v.voucher_id=FT.Voucher_Id And R.Receive_FromId IN "+tempParty+" and FT.Receive_Id=R.Receive_Id and V.company_id="+company_id+" and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 order by R.Receive_FromId, V.Voucher_Id ";

			errLine="147";
			pstmt = conp.prepareStatement(query1);
			rs = pstmt.executeQuery();
			errLine="150";
				
			while(rs.next())
			{
				errLine="154";
				
				int voucher_Type = rs.getInt("Voucher_Type");

				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				
				double local_total = rs.getDouble("Local_Total");
				double dollar_total = rs.getDouble("Dollar_Total");
				int party_idInt = rs.getInt("Receive_FromId");
				errLine="159";

				double local_cr = 0;
				double local_dr = 0;
				double dollar_cr = 0;
				double dollar_dr = 0;

				if(voucher_Type == 2 || voucher_Type == 11)
				{
					local_cr = local_total;
					dollar_cr = dollar_total;
				}
				if(voucher_Type == 10 || voucher_Type == 1)
				{
					local_dr = local_total;
					dollar_dr = dollar_total;
				}
				
				errLine="177";
				customerVendorDetailTrans newRow = new customerVendorDetailTrans(party_idInt, voucher_Date, local_dr, local_cr, dollar_dr, dollar_cr);

				allPartyList.add(newRow);
				errLine="181";
			}
			rs.close();
			pstmt.close();

			//getting Purchase Payment/Sales Receipt , PN Purchase Payment/PN Sales Receipt & Journal
			String query2 = "SELECT V.Voucher_Id, V.Voucher_Date, V.Voucher_Type, FT.Local_Amount, FT.Dollar_Amount, FT.Transaction_Type, FT.Ledger_Id FROM Financial_Transaction AS FT, Voucher AS V WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id IN "+tempLedger+" and V.company_id="+company_id+" and V.Active=1 and FT.Active=1 order by FT.Ledger_Id";

			errLine="189";
			pstmt = conp.prepareStatement(query2);
			rs = pstmt.executeQuery();
			errLine="192";
			
			while(rs.next())
			{
				errLine="196";
				String voucher_Id = rs.getString("Voucher_Id");
				int voucher_Type = rs.getInt("Voucher_Type");
				java.sql.Date voucher_Date = rs.getDate("Voucher_Date");
				
				Boolean Transaction_Type = rs.getBoolean("Transaction_Type");
				
				double local_total = rs.getDouble("Local_Amount");
				double dollar_total = rs.getDouble("Dollar_Amount");
				
				int ledger_idInt = rs.getInt("Ledger_Id");
				errLine="203";

				double local_cr = 0;
				double local_dr = 0;
				double dollar_cr = 0;
				double dollar_dr = 0;

				if(!Transaction_Type)
				{
					local_dr = local_total;
					dollar_dr = dollar_total;
				}
				if(Transaction_Type)
				{
					local_cr = local_total;
					dollar_cr = dollar_total;
				}

				
				errLine="222";
				customerVendorDetailTrans newRow = new customerVendorDetailTrans(ledger_idInt, voucher_Date, local_dr, local_cr, dollar_dr, dollar_cr);

				allLedgerList.add(newRow);
				errLine="226";
			}
			rs.close();
			pstmt.close();


		
		}
		catch(Exception Samyak109)
		{
			System.out.println("Exception after line "+errLine+" in CustomerVendorDetailAllRows() in CustomerVendorDetail.java "+Samyak109);
		}

		//System.out.println(allPartyList.size());
		//System.out.println(allLedgerList.size());

	}//end of CustomerVendorDetailAllRows()


	//CustomerVendorDetailRow between the dates D1 and D2 for a customer/vendor
	public String CustomerVendorDetailRow(String ledgerId, Connection conp, java.sql.Date D1, java.sql.Date D2, double local_opening, double dollar_opening, String party_id, String company_id, String type, String ctaxLedgerId)
	{
		
		List totalList = new ArrayList();

		//initialise all the global variable
		local_opening_dr=0;
		local_opening_cr=0;
		local_trans_dr=0;
		local_trans_cr=0;
		local_closing_dr=0;
		local_closing_cr=0;

		dollar_opening_dr=0;
		dollar_opening_cr=0;
		dollar_trans_dr=0;
		dollar_trans_cr=0;
		dollar_closing_dr=0;
		dollar_closing_cr=0;

		firstIndex=0;
		lastIndex=0;

		if("".equals(ledgerId))
		{
			return "" + local_opening_dr +"#"+ local_opening_cr +"#"+ local_trans_dr +"#"+ local_trans_cr +"#"+ local_closing_dr +"#"+ local_closing_cr +"#"+ dollar_opening_dr +"#"+ dollar_opening_cr +"#"+ dollar_trans_dr +"#"+ dollar_trans_cr +"#"+ dollar_closing_dr +"#"+ dollar_closing_cr ;

		}
		//start getting the transactions
		String errLine="136";
		try{
			errLine="154";
			
			//get the objects from partyList for the current party id

			for(int k=0; k<allPartyList.size(); k++)
			{
				customerVendorDetailTrans newRow = (customerVendorDetailTrans) allPartyList.get(k);

				if( newRow.getPartyORledger_id() == Integer.parseInt(party_id) )
				{
					totalList.add(newRow);
				}
			}
			
			errLine="181";
			//get the objects from ledgerList for the current ledger id

			for(int k=0; k<allLedgerList.size(); k++)
			{
				customerVendorDetailTrans newRow = (customerVendorDetailTrans) allLedgerList.get(k);

				if( newRow.getPartyORledger_id() == Integer.parseInt(ledgerId) )
				{
					totalList.add(newRow);
				}
			}
			

		
		}
		catch(Exception Samyak109)
		{
			return "Exception after line "+errLine+" in CustomerVendorDetailRow() in CustomerVendorDetail.java "+Samyak109;
		}
		
		if(totalList.size()==0)
		{
			//get the opening balance
			customerVendorDetailTrans openingRow = getOpening(conp, D1, local_opening, dollar_opening,company_id, party_id, totalList, type);

			List dateRangeList = new ArrayList();
			dateRangeList.add(openingRow);
		
			calulateTrans(dateRangeList, conp, party_id, company_id, D1, D2, type);

			return "" + local_opening_dr +"#"+ local_opening_cr +"#"+ local_trans_dr +"#"+ local_trans_cr +"#"+ local_closing_dr +"#"+ local_closing_cr +"#"+ dollar_opening_dr +"#"+ dollar_opening_cr +"#"+ dollar_trans_dr +"#"+ dollar_trans_cr +"#"+ dollar_closing_dr +"#"+ dollar_closing_cr ;

		}
		else
		{
			ComparingDate1 comp = new ComparingDate1();
			
			//sort the list
			Collections.sort(totalList, comp);

			//get the opening balance
			customerVendorDetailTrans openingRow = getOpening(conp, D1, local_opening, dollar_opening,company_id, party_id, totalList, type);
		
			//get last index as per the toDate
			lastIndex = getLastIndex(D2, totalList);
		
			//get the sublist of transactions between fromDate and toDate
			List dateRangeList = new ArrayList();
			dateRangeList = totalList.subList(firstIndex, lastIndex);
			dateRangeList.add(0, openingRow);

			//System.out.println("party id="+party_id);
			
			calulateTrans(dateRangeList, conp, party_id, company_id, D1, D2, type);

			//System.out.println(party_id+" : "+dateRangeList.size());

			return "" + local_opening_dr +"#"+ local_opening_cr +"#"+ local_trans_dr +"#"+ local_trans_cr +"#"+ local_closing_dr +"#"+ local_closing_cr +"#"+ dollar_opening_dr +"#"+ dollar_opening_cr +"#"+ dollar_trans_dr +"#"+ dollar_trans_cr +"#"+ dollar_closing_dr +"#"+ dollar_closing_cr ;
		}		
	}//CustomerVendorDetailRow()


	//returns the opening balance row for the given party
	public customerVendorDetailTrans getOpening(Connection con, java.sql.Date fromDate, double opening, double dopening, String company_id, String party_id, List totalList, String type)
	{
		
		String errLine="275";
		try{
		java.sql.Date voucher_Date = fromDate;
		Boolean Transaction_Type = true;// for credit
		
		double op_local_cr = 0;
		double op_local_dr = 0;
		double op_dollar_cr = 0;
		double op_dollar_dr = 0;
		
		if( opening > 0)
		{
			op_local_dr = opening;
			op_dollar_dr = dopening;
		}
		else
		{
			op_local_cr = opening * -1;
			op_dollar_cr = dopening * -1;
		}
		
		errLine="296";

		if(totalList.size() != 0)
		{
			for(int i=0; i<totalList.size(); i++)
			{
				firstIndex = i;
				customerVendorDetailTrans row = (customerVendorDetailTrans)totalList.get(i);
				errLine="304";

				if(row.getVoucher_Date().compareTo(fromDate) < 0)
				{
					op_local_cr += row.getLocalAmt_Cr();
					op_local_dr += row.getLocalAmt_Dr();
					op_dollar_cr += row.getDollarAmt_Cr();
					op_dollar_dr += row.getDollarAmt_Dr();
					firstIndex=i+1;
				}
				else
					break;

				errLine="317";
			}//end for

			double purchase_gainloss = partyExchangeGainLoss(con, party_id, company_id,fromDate, type);
			
			if (purchase_gainloss < 0){
				op_local_dr +=purchase_gainloss*-1;
			}else{ 
				op_local_cr +=purchase_gainloss;}

			errLine="327";
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
		errLine="345";

		

		openingRow = new customerVendorDetailTrans(0, voucher_Date, op_local_dr, op_local_cr, op_dollar_dr, op_dollar_cr);
	
		}
		catch(Exception e){
			System.out.println("Exception in getOpening() in CustomerVendorDetail after Line:"+errLine+" is "+e);
		}
		return openingRow;
	}//getOpening()

	public int getLastIndex(java.sql.Date toDate, List totalList)
	{
		if(totalList.size() != 0)
		{
			for(int i=firstIndex; i<totalList.size(); i++)
			{
				customerVendorDetailTrans row = (customerVendorDetailTrans)totalList.get(i);
		
				if(row.getVoucher_Date().compareTo(toDate) > 0)
				{
					lastIndex =i;	
					return lastIndex;			
				}
			}//end for
		}//end if
		lastIndex =totalList.size();	
		return lastIndex;
	}//end getLastIndex()

	void calulateTrans(List dateRangeList, Connection conp, String party_id, String company_id, java.sql.Date D1, java.sql.Date D2, String type)
	{
		customerVendorDetailTrans openingRow = (customerVendorDetailTrans)dateRangeList.get(0);
		
		local_opening_dr = openingRow.getLocalAmt_Dr();
		local_opening_cr = openingRow.getLocalAmt_Cr();
		dollar_opening_dr = openingRow.getDollarAmt_Dr();
		dollar_opening_cr = openingRow.getDollarAmt_Cr();

		for(int j=1; j<dateRangeList.size(); j++)
		{
			customerVendorDetailTrans transRow = (customerVendorDetailTrans)dateRangeList.get(j);
			local_trans_dr += transRow.getLocalAmt_Dr();
			local_trans_cr += transRow.getLocalAmt_Cr();
			dollar_trans_dr += transRow.getDollarAmt_Dr();
			dollar_trans_cr += transRow.getDollarAmt_Cr();
		}
		
		double exchangeGainLoss = partyExchangeGainLoss(conp, party_id, company_id, D1, D2, type);

		local_closing_dr = local_opening_dr + local_trans_dr;
		local_closing_cr = local_opening_cr + local_trans_cr;
		dollar_closing_dr = dollar_opening_dr + dollar_trans_dr;
		dollar_closing_cr = dollar_opening_cr + dollar_trans_cr;

		if(exchangeGainLoss < 0)
		{
			local_closing_dr += exchangeGainLoss * -1;
			local_trans_dr += exchangeGainLoss * -1;
		}
		else
		{
			local_closing_cr += exchangeGainLoss;
			local_trans_cr += exchangeGainLoss;
		}
		CustomerVendorReport cvd=new CustomerVendorReport();
		String temp_sale_gain_loss_both="";
		if("sale".equals(type))
		{
			temp_sale_gain_loss_both=cvd.partySaleExchangeGainLossDollar(conp,party_id,company_id,D1,D2);
		}
		else
		{
			temp_sale_gain_loss_both=cvd.partyPurchaseExchangeGainLossDollar(conp,party_id,company_id,D1,D2);
		}
		StringTokenizer sale_gain_loss_both=new StringTokenizer(temp_sale_gain_loss_both,"#");
		String sale_local=sale_gain_loss_both.nextToken();	
		//String sale_dollar=sale_gain_loss_both.nextToken();	
		double sale_gainloss=Double.parseDouble(sale_local);
		//double sale_gainloss_dollar=Double.parseDouble(sale_dollar);
		//if(sale_gainloss_dollar < 0)
		//{
		//	dollar_closing_dr += sale_gainloss_dollar * -1;
		//	dollar_trans_dr += sale_gainloss_dollar * -1;
		//}
		//else
		//{
		//	dollar_closing_cr += sale_gainloss_dollar;
		//	dollar_trans_cr += sale_gainloss_dollar;
		//}
		
	}//end calculateTrans()

	public static void main(String[] args) throws Exception
	{

		CustomerVendorDetail l = new CustomerVendorDetail();

	}
}//close of class


class customerVendorDetailTrans
{
	int partyORledger_id;
	java.sql.Date voucher_Date;
	double localAmt_Dr;
	double localAmt_Cr;
	double dollarAmt_Dr;
	double dollarAmt_Cr;

	public int getPartyORledger_id()
	{ 
		return this.partyORledger_id;
	}
	
	public java.sql.Date getVoucher_Date()
	{ 
		return this.voucher_Date;
	}

    public double getLocalAmt_Dr()
	{ 
		return this.localAmt_Dr;
	}
    
	public double getLocalAmt_Cr()
	{ 
		return this.localAmt_Cr;
	}
	
	public double getDollarAmt_Dr()
	{ 
		return this.dollarAmt_Dr;
	}

	public double getDollarAmt_Cr()
	{ 
		return this.dollarAmt_Cr;
	}
    
	customerVendorDetailTrans(int partyORledger_id, java.sql.Date voucher_Date,  double localAmt_Dr, double localAmt_Cr, double dollarAmt_Dr, double dollarAmt_Cr)
    {
		this.partyORledger_id = partyORledger_id;
		this.voucher_Date = voucher_Date;
		this.localAmt_Dr = localAmt_Dr;
		this.localAmt_Cr = localAmt_Cr;
		this.dollarAmt_Dr = dollarAmt_Dr;
		this.dollarAmt_Cr = dollarAmt_Cr;
	}

}

//use to sort the list of transactions on date
class ComparingDate1 implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   java.sql.Date date1 = ((customerVendorDetailTrans)obj1).getVoucher_Date();
	   java.sql.Date date2 = ((customerVendorDetailTrans)obj2).getVoucher_Date();
	  
	   return ((date1).compareTo(date2));	 
	}	
}

