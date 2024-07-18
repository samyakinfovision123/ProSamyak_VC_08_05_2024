package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.*;
import NipponBean.*;

public class  PartyOpeningClosing
{
	ResultSet rs=null;
	PreparedStatement pstmt=null;
	
	HashMap partyName = new HashMap();

	HashMap saleExchGainLossUpto = new HashMap();
	HashMap saleExchGainLossFromTo = new HashMap();
	HashMap purchaseExchGainLossUpto = new HashMap();
	HashMap purchaseExchGainLossFromTo = new HashMap();

	//sale
	HashMap saleLocalOpening = new HashMap();
	HashMap saleDollarOpening = new HashMap();	
	HashMap saleLocalUpto = new HashMap();
	HashMap saleLocalFromTo = new HashMap();
	HashMap saleReturnLocalUpto = new HashMap();
	HashMap saleReturnLocalFromTo = new HashMap();
	HashMap saleDollarUpto = new HashMap();
	HashMap saleDollarFromTo = new HashMap();
	HashMap saleReturnDollarUpto = new HashMap();
	HashMap saleReturnDollarFromTo = new HashMap();
	//following HashMaps stores the FSR, PNR and J entries for sale into Dr and Cr types depending on Transaction_Type in FT
	HashMap saleOtherLocalDrUpto = new HashMap();
	HashMap saleOtherLocalDrFromTo = new HashMap();
	HashMap saleOtherLocalCrUpto = new HashMap();
	HashMap saleOtherLocalCrFromTo = new HashMap();
	HashMap saleOtherDollarDrUpto = new HashMap();
	HashMap saleOtherDollarDrFromTo = new HashMap();
	HashMap saleOtherDollarCrUpto = new HashMap();
	HashMap saleOtherDollarCrFromTo = new HashMap();


	//purchase
	HashMap purchaseLocalOpening = new HashMap();
	HashMap purchaseDollarOpening = new HashMap();	
	HashMap purchaseLocalUpto = new HashMap();
	HashMap purchaseLocalFromTo = new HashMap();
	HashMap purchaseReturnLocalUpto = new HashMap();
	HashMap purchaseReturnLocalFromTo = new HashMap();
	HashMap purchaseDollarUpto = new HashMap();
	HashMap purchaseDollarFromTo = new HashMap();
	HashMap purchaseReturnDollarUpto = new HashMap();
	HashMap purchaseReturnDollarFromTo = new HashMap();
	//following HashMaps stores the FPP, PNP and J entries for sale into Dr and Cr types depending on Transaction_Type in FT
	HashMap purchaseOtherLocalDrUpto = new HashMap();
	HashMap purchaseOtherLocalDrFromTo = new HashMap();
	HashMap purchaseOtherLocalCrUpto = new HashMap();
	HashMap purchaseOtherLocalCrFromTo = new HashMap();
	HashMap purchaseOtherDollarDrUpto = new HashMap();
	HashMap purchaseOtherDollarDrFromTo = new HashMap();
	HashMap purchaseOtherDollarCrUpto = new HashMap();
	HashMap purchaseOtherDollarCrFromTo = new HashMap();

	//get the partywise exchange gainloss upto a date D1 and store it in the hashmaps with partyid as the key
	//for sale -ve value is Dr. +ve value is Cr.
	//for purchase +ve value is Dr. -ve value is Cr.
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void partyExchangeGainLoss(Connection con, String company_id, String partyIdCondn, java.sql.Date D1) 
	{
		String errLine = "70";
		String query="";

		try{
		//calculating for the sale upto a date
		
		query="Select Receive_FromId, SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date <? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=0 and R.Receive_FromId IN "+partyIdCondn+" group by Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double value = new Double(rs.getDouble("exchgainloss"));
			saleExchGainLossUpto.put(id, value);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "92";
		//calculating for the purchase upto a date
		
		query="Select Receive_FromId, SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date <? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=1 and R.Receive_FromId IN "+partyIdCondn+" group by Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double value = new Double(rs.getDouble("exchgainloss"));
			purchaseExchGainLossUpto.put(id, value);
		}//while
		rs.close();
		pstmt.close();
		errLine = "110";	

		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method partyExchangeGainLoss(D1) after line="+errLine+" :" +e);
		}
		
	}//exchangeGainLoss

	//get the partywise exchange gainloss between dates D1 and D2 and store it in the hashmaps with partyid as the key
	//for sale -ve value is Dr. +ve value is Cr.
	//for purchase +ve value is Dr. -ve value is Cr.
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void partyExchangeGainLoss(Connection con, String company_id, String partyIdCondn, java.sql.Date D1, java.sql.Date D2) 
	{
		String errLine = "125";
		String query="";

		try{
		//calculating for the sale for date range
		
		query="Select Receive_FromId, SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=0 and R.Receive_FromId IN "+partyIdCondn+" group by Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double value = new Double(rs.getDouble("exchgainloss"));
			saleExchGainLossFromTo.put(id, value);
		}//while
		rs.close();
		pstmt.close();

		errLine = "148";
		//calculating for the purchase for date range
		
		query="Select Receive_FromId, SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=1 and R.Receive_FromId IN "+partyIdCondn+" group by Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double value = new Double(rs.getDouble("exchgainloss"));
			purchaseExchGainLossFromTo.put(id, value);
		}//while
		rs.close();
		pstmt.close();
		errLine = "167";
		
		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method partyExchangeGainLoss(D1, D2) after line="+errLine+" :" +e);
		}
		
	}//exchangeGainLoss


	//get the sale and purchase exchange gainloss seperated by # between dates D1 and D2. Returns exchangeGainLoss as sale#pur
	//for sale -ve value is Cr. +ve value is Dr.
	//for purchase +ve value is Cr. -ve value is Dr.
	public String partyExchangeGainLoss(Connection con, String company_id, java.sql.Date D1, java.sql.Date D2) 
	{
		String errLine = "182";
		String query="";
		String exchGainLoss = "";

		try{
		//calculating for the sale for date range
		
		query="Select SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=0";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		double saleValue = 0;
		while(rs.next()) 
		{
			saleValue = rs.getDouble("exchgainloss");			
		}//while
		rs.close();
		pstmt.close();
		exchGainLoss = ""+saleValue+"#";

		errLine = "206";
		//calculating for the purchase for date range
		
		query="Select SUM( (R.Exchange_Rate * PD.Dollar_Amount) - PD.Local_Amount) as exchgainloss from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0  and R.Active=1 and R.R_Return=0  and R.Receive_CurrencyId=0 and PD.Active=1 and Receive_Sell=1 ";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		double purchaseValue = 0;
		while(rs.next()) 
		{
			purchaseValue = rs.getDouble("exchgainloss");
		}//while
		rs.close();
		pstmt.close();
		errLine = "224";
		exchGainLoss += purchaseValue;
		
		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method partyExchangeGainLoss(D1, D2) after line="+errLine+" :" +e);
		}
		return exchGainLoss;
		
	}//exchangeGainLoss

	//get sale transactions

	//get the partywise sales transactions upto a date D1 and store it in the hashmaps with partyid as the key
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void getSalesTransactions(Connection con, String company_id, String partyIdCondn, String ctaxLedgerId, java.sql.Date D1) 
	{
		String errLine = "241";
		String query="";

		try{
		//calculating for the sale invoices punched upto a date
		//values are added to the Dr.
		
		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as saleLocal, Sum(V.Dollar_Total) as saleDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=1 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date <? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleLocalUpto.put(id, localvalue);
			saleDollarUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "266";
		
		//calculating for the sale return invoices punched upto a date
		//values are added to the Cr.

		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as saleLocal, Sum(V.Dollar_Total) as saleDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=11 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date <? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleReturnLocalUpto.put(id, localvalue);
			saleReturnDollarUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "289";
		
		//calculating for the FSR, PNR, J invoices punched upto a date against a given party with FT.Transaction_Type=1
		//values are added to the Cr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as saleLocal, Sum(FT.Dollar_Amount) as saleDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=1  and FT.Transaction_Type=1 and V.Voucher_Date <? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleOtherLocalCrUpto.put(id, localvalue);
			saleOtherDollarCrUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "311";

		//calculating for the FSR, PNR, J invoices punched upto a date against a given party with FT.Transaction_Type=0
		//values are added to the Dr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as saleLocal, Sum(FT.Dollar_Amount) as saleDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=1  and FT.Transaction_Type=0 and V.Voucher_Date <? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleOtherLocalDrUpto.put(id, localvalue);
			saleOtherDollarDrUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "333";

		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getSalesTransactions(D1) after line="+errLine+" :" +e);
		}
	}//getSalesTransactions


	//get the partywise sales transactions between date D1 and D2 and store it in the hashmaps with partyid as the key
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void getSalesTransactions(Connection con, String company_id, String partyIdCondn, String ctaxLedgerId, java.sql.Date D1, java.sql.Date D2) 
	{
		String errLine = "346";
		String query="";

		try{
		//calculating for the sale invoices punched between a date range
		//values are added to the Dr.
		
		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as saleLocal, Sum(V.Dollar_Total) as saleDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=1 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date between ? and ? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleLocalFromTo.put(id, localvalue);
			saleDollarFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "372";
		
		//calculating for the sale return invoices punched between a date range
		//values are added to the Cr.

		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as saleLocal, Sum(V.Dollar_Total) as saleDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=11 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date between ? and ? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleReturnLocalFromTo.put(id, localvalue);
			saleReturnDollarFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "396";
		
		//calculating for the FSR, PNR, J invoices punched between a date range against a given party with FT.Transaction_Type=1
		//values are added to the Cr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as saleLocal, Sum(FT.Dollar_Amount) as saleDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=1  and FT.Transaction_Type=1 and V.Voucher_Date between ? and ? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleOtherLocalCrFromTo.put(id, localvalue);
			saleOtherDollarCrFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "419";

		//calculating for the FSR, PNR, J invoices punched between a date range against a given party with FT.Transaction_Type=0
		//values are added to the Dr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as saleLocal, Sum(FT.Dollar_Amount) as saleDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=1  and FT.Transaction_Type=0 and V.Voucher_Date between ? and ? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("saleLocal"));
			Double dollarvalue = new Double(rs.getDouble("saleDollar"));
			saleOtherLocalDrFromTo.put(id, localvalue);
			saleOtherDollarDrFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "442";

		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getSalesTransactions(D1, D2) after line="+errLine+" :" +e);
		}
	}//getSalesTransactions
	
	//get Purchase transaction
	
	//get the partywise purchase transactions upto a date D1 and store it in the hashmaps with partyid as the key
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void getPurchaseTransactions(Connection con, String company_id, String partyIdCondn, String ctaxLedgerId, java.sql.Date D1) 
	{
		String errLine = "456";
		String query="";

		try{
		//calculating for the purchase invoices punched upto a date
		//values are added to the Cr.
		
		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as purchaseLocal, Sum(V.Dollar_Total) as purchaseDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=2 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date <? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseLocalUpto.put(id, localvalue);
			purchaseDollarUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "481";
		
		//calculating for the purchase return invoices punched upto a date
		//values are added to the Dr.

		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as purchaseLocal, Sum(V.Dollar_Total) as purchaseDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=10 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date <? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseReturnLocalUpto.put(id, localvalue);
			purchaseReturnDollarUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "504";
		
		//calculating for the FPP, PNP, J invoices punched upto a date against a given party with FT.Transaction_Type=1
		//values are added to the Cr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as purchaseLocal, Sum(FT.Dollar_Amount) as purchaseDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=2  and FT.Transaction_Type=1 and V.Voucher_Date <? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseOtherLocalCrUpto.put(id, localvalue);
			purchaseOtherDollarCrUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "526";

		//calculating for the FPP, PNP, J invoices punched upto a date against a given party with FT.Transaction_Type=0
		//values are added to the Dr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as purchaseLocal, Sum(FT.Dollar_Amount) as purchaseDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=2  and FT.Transaction_Type=0 and V.Voucher_Date <? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseOtherLocalDrUpto.put(id, localvalue);
			purchaseOtherDollarDrUpto.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "548";

		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPurchaseTransactions(D1) after line="+errLine+" :" +e);
		}
	}//getPurchaseTransactions


	//get the partywise purchase transactions between date D1 and D2 and store it in the hashmaps with partyid as the key
	//partyIdCondn will contians all the party ids in the format e.g. (123, 333, 122) 
	public void getPurchaseTransactions(Connection con, String company_id, String partyIdCondn, String ctaxLedgerId, java.sql.Date D1, java.sql.Date D2) 
	{
		String errLine = "561";
		String query="";

		try{
		//calculating for the purchase invoices punched between a date range
		//values are added to the Cr.
		
		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as purchaseLocal, Sum(V.Dollar_Total) as purchaseDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=2 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date between ? and ? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseLocalFromTo.put(id, localvalue);
			purchaseDollarFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "587";
		
		//calculating for the purchase return invoices punched between a date range
		//values are added to the Dr.

		query="SELECT  R.Receive_FromId, Sum(V.Local_Total) as purchaseLocal, Sum(V.Dollar_Total) as purchaseDollar FROM Voucher AS V, Financial_Transaction AS FT, Receive AS R WHERE V.voucher_type=10 And v.voucher_id=FT.Voucher_Id And FT.Receive_Id=R.Receive_Id and R.Receive_Date between ? and ? and V.company_id=? and FT.Ledger_Id="+ctaxLedgerId+" and V.Active=1 and FT.Active=1 and R.Active=1 and R.Receive_FromId IN "+partyIdCondn+" group by R.Receive_FromId order by R.Receive_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("Receive_FromId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseReturnLocalFromTo.put(id, localvalue);
			purchaseReturnDollarFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "611";
		
		//calculating for the FPP, PNP, J invoices punched between a date range against a given party with FT.Transaction_Type=1
		//values are added to the Cr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as purchaseLocal, Sum(FT.Dollar_Amount) as purchaseDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=2  and FT.Transaction_Type=1 and V.Voucher_Date between ? and ? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseOtherLocalCrFromTo.put(id, localvalue);
			purchaseOtherDollarCrFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "634";

		//calculating for the FPP, PNP, J invoices punched between a date range against a given party with FT.Transaction_Type=0
		//values are added to the Dr.
		query="SELECT L.For_HeadId, Sum(FT.Local_Amount) as purchaseLocal, Sum(FT.Dollar_Amount) as purchaseDollar FROM Financial_Transaction AS FT, Voucher AS V, Ledger AS L WHERE V.Voucher_Id=FT.Voucher_Id and FT.Ledger_Id=L.Ledger_Id and L.Ledger_Type=2  and FT.Transaction_Type=0 and V.Voucher_Date between ? and ? and V.company_id=? and V.Active=1 and FT.Active=1 and L.For_HeadId IN "+partyIdCondn+" group by L.For_HeadId order by L.For_HeadId";

		pstmt = con.prepareStatement(query);
		pstmt.setString(1,""+D1);
		pstmt.setString(2,""+D2);
		pstmt.setString(3,company_id); 
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("For_HeadId");
			Double localvalue = new Double(rs.getDouble("purchaseLocal"));
			Double dollarvalue = new Double(rs.getDouble("purchaseDollar"));
			purchaseOtherLocalDrFromTo.put(id, localvalue);
			purchaseOtherDollarDrFromTo.put(id, dollarvalue);
		}//while
		rs.close();
		pstmt.close();
		
		errLine = "657";

		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPurchaseTransactions(D1, D2) after line="+errLine+" :" +e);
		}
	}//getPurchaseTransactions


	//method that will give the sales closing for the selected parties at a given date (increment the sent date by a 1 day i.e. to have 03/06/06 as closing date use the date 04/06/06 for calculations and it must be sent as parameters for D1 ## Also if you want opening of 03/06/06 than use the date 03/06/06 for calculations and it must be sent as parameters for D1)
	public HashMap getPartySalesClosing(Connection con, String company_id, String[] partyId, String ctaxLedgerId, java.sql.Date D1)
	{
		String errLine = "669";
		String query = "";
		HashMap salesClosing = new HashMap();
		try{
		
		String partyIdCondn = "(";

		for(int i=0; i<partyId.length; i++)
		{
			if("(".equals(partyIdCondn))
				partyIdCondn += partyId[i];
			else
				partyIdCondn += " ," + partyId[i];
		}
		
		partyIdCondn += ")";

		query = "Select CompanyParty_Id, CompanyParty_Name, Opening_RLocalBalance, Opening_RDollarBalance from Master_CompanyParty as MCP where MCP.Active=1 AND MCP.Company_Id="+company_id+" and CompanyParty_Id IN "+partyIdCondn+ " order by CompanyParty_Id";
		
		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("CompanyParty_Id");
			String name = rs.getString("CompanyParty_Name");
			Double slopen = new Double ( rs.getDouble("Opening_RLocalBalance") );
			Double sdopen = new Double ( rs.getDouble("Opening_RDollarBalance") );
		
			partyName.put(id, name);
			saleLocalOpening.put(id, slopen);
			saleDollarOpening.put(id, sdopen);
		}//while
		rs.close();
		pstmt.close();

		//calculating the exchange gain loss, sale and purchase for the given party upto date D1 and populating the HashMaps
	
		partyExchangeGainLoss(con, company_id, partyIdCondn, D1);
		getSalesTransactions(con, company_id, partyIdCondn, ctaxLedgerId, D1); 
	
		//now using the populated HashMaps to calculate the closing
		for(int i=0; i<partyId.length; i++)
		{
			//get the dollar value
			double dollarValue = ((Double)saleDollarOpening.get(partyId[i])).doubleValue();
					
			if(saleDollarUpto.containsKey(partyId[i]))
			{
				dollarValue += ((Double)saleDollarUpto.get(partyId[i])).doubleValue();
			}
			
			if(saleReturnDollarUpto.containsKey(partyId[i]))
			{
				dollarValue -= ((Double)saleReturnDollarUpto.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherDollarDrUpto.containsKey(partyId[i]))
			{
				dollarValue += ((Double)saleOtherDollarDrUpto.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherDollarCrUpto.containsKey(partyId[i]))
			{
				dollarValue -= ((Double)saleOtherDollarCrUpto.get(partyId[i])).doubleValue();
			}

			//get the local value
			double localValue = ((Double)saleLocalOpening.get(partyId[i])).doubleValue();
					
			if(saleLocalUpto.containsKey(partyId[i]))
			{
				localValue += ((Double)saleLocalUpto.get(partyId[i])).doubleValue();
			}
			
			if(saleReturnLocalUpto.containsKey(partyId[i]))
			{
				localValue -= ((Double)saleReturnLocalUpto.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherLocalDrUpto.containsKey(partyId[i]))
			{
				localValue += ((Double)saleOtherLocalDrUpto.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherLocalCrUpto.containsKey(partyId[i]))
			{
				localValue -= ((Double)saleOtherLocalCrUpto.get(partyId[i])).doubleValue();
			}
			
			if(saleExchGainLossUpto.containsKey(partyId[i]))
			{
				localValue -= ((Double)saleExchGainLossUpto.get(partyId[i])).doubleValue();
				//since -ve value is on Dr. side and +ve value is on Cr. side
			}
			//add exchange gain loss to the local value
			//System.out.println("localValue"+localValue);
			//System.out.println("dollarValue"+dollarValue);
		
			String closingValue = ""+localValue+"#"+dollarValue;	
			salesClosing.put(partyId[i], closingValue);
		}


		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPartySalesClosing() after line="+errLine+" :" +e);
		}

		return salesClosing;
	}//getPartySalesClosing

	
	//method that will give the sales closing for the selected parties at a given date (increment the sent date by a 1 day i.e. to have 03/06/06 as closing date use the date 04/06/06 for calculations and it must be sent as parameters)
	public HashMap getPartyPurchaseClosing(Connection con, String company_id, String[] partyId, String ctaxLedgerId, java.sql.Date D1)
	{
		String errLine = "787";
		String query = "";
		HashMap purchaseClosing = new HashMap();
		try{
		
		String partyIdCondn = "(";

		for(int i=0; i<partyId.length; i++)
		{
			if("(".equals(partyIdCondn))
				partyIdCondn += partyId[i];
			else
				partyIdCondn += " ," + partyId[i];
		}
		
		partyIdCondn += ")";

		query = "Select CompanyParty_Id, CompanyParty_Name, Opening_PLocalBalance, Opening_PDollarBalance from Master_CompanyParty as MCP where MCP.Active=1 AND MCP.Company_Id="+company_id+" and CompanyParty_Id IN "+partyIdCondn+ " order by CompanyParty_Id";
		
		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("CompanyParty_Id");
			String name = rs.getString("CompanyParty_Name");
			Double slopen = new Double ( rs.getDouble("Opening_PLocalBalance") );
			Double sdopen = new Double ( rs.getDouble("Opening_PDollarBalance") );
		
			partyName.put(id, name);
			purchaseLocalOpening.put(id, slopen);
			purchaseDollarOpening.put(id, sdopen);
		}//while
		rs.close();
		pstmt.close();

		//calculating the exchange gain loss, sale and purchase for the given party upto date D1 and populating the HashMaps
	
		partyExchangeGainLoss(con, company_id, partyIdCondn, D1);
		getPurchaseTransactions(con, company_id, partyIdCondn, ctaxLedgerId, D1); 
	
		//now using the populated HashMaps to calculate the closing
		for(int i=0; i<partyId.length; i++)
		{
			//dollar value
			double dollarValue = ((Double)purchaseDollarOpening.get(partyId[i])).doubleValue();
					
			if(purchaseDollarUpto.containsKey(partyId[i]))
			{
				dollarValue -= ((Double)purchaseDollarUpto.get(partyId[i])).doubleValue();
			}
			
			if(purchaseReturnDollarUpto.containsKey(partyId[i]))
			{
				dollarValue += ((Double)purchaseReturnDollarUpto.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherDollarDrUpto.containsKey(partyId[i]))
			{
				dollarValue += ((Double)purchaseOtherDollarDrUpto.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherDollarCrUpto.containsKey(partyId[i]))
			{
				dollarValue -= ((Double)purchaseOtherDollarCrUpto.get(partyId[i])).doubleValue();
			}

			//local value
			double localValue = ((Double)purchaseLocalOpening.get(partyId[i])).doubleValue();
					
			if(purchaseLocalUpto.containsKey(partyId[i]))
			{
				localValue -= ((Double)purchaseLocalUpto.get(partyId[i])).doubleValue();
			}
			
			if(purchaseReturnLocalUpto.containsKey(partyId[i]))
			{
				localValue += ((Double)purchaseReturnLocalUpto.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherLocalDrUpto.containsKey(partyId[i]))
			{
				localValue += ((Double)purchaseOtherLocalDrUpto.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherLocalCrUpto.containsKey(partyId[i]))
			{
				localValue -= ((Double)purchaseOtherLocalCrUpto.get(partyId[i])).doubleValue();
			}

			if(purchaseExchGainLossUpto.containsKey(partyId[i]))
			{
				localValue += ((Double)purchaseExchGainLossUpto.get(partyId[i])).doubleValue();
				//since +ve value is on Dr. side and -ve value is on Cr. side
			}
			String closingValue = ""+localValue+"#"+dollarValue;	
			purchaseClosing.put(partyId[i], closingValue);
		}


		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPartyPurchaseClosing() after line="+errLine+" :" +e);
		}
		return purchaseClosing;
	}//getPartyPurchaseClosing


	//method that will give the sale transactions for the selected parties for a given date range 
	public HashMap getPartySalesTrans(Connection con, String company_id, String[] partyId, String ctaxLedgerId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "903";
		String query = "";
		HashMap saleTrans = new HashMap();
		try{
		
		String partyIdCondn = "(";

		for(int i=0; i<partyId.length; i++)
		{
			if("(".equals(partyIdCondn))
				partyIdCondn += partyId[i];
			else
				partyIdCondn += " ," + partyId[i];
		}
		
		partyIdCondn += ")";
	

		//calculating the exchange gain loss, sale and purchase for the given party for date range D1-D2 and populating the HashMaps
	
		partyExchangeGainLoss(con, company_id, partyIdCondn, D1, D2);
		getSalesTransactions(con, company_id, partyIdCondn, ctaxLedgerId, D1, D2); 
	
		//now using the populated HashMaps to calculate the transactions
		for(int i=0; i<partyId.length; i++)
		{
			//dollar value
			double dollarValueDr = 0;
			double dollarValueCr = 0;
					
			if(saleDollarFromTo.containsKey(partyId[i]))
			{
				dollarValueDr += ((Double)saleDollarFromTo.get(partyId[i])).doubleValue();
			}
			
			if(saleReturnDollarFromTo.containsKey(partyId[i]))
			{
				dollarValueCr += ((Double)saleReturnDollarFromTo.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherDollarDrFromTo.containsKey(partyId[i]))
			{
				dollarValueDr += ((Double)saleOtherDollarDrFromTo.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherDollarCrFromTo.containsKey(partyId[i]))
			{
				dollarValueCr += ((Double)saleOtherDollarCrFromTo.get(partyId[i])).doubleValue();
			}

			//local value
			double localValueDr = 0;
			double localValueCr = 0;
					
			if(saleLocalFromTo.containsKey(partyId[i]))
			{
				localValueDr += ((Double)saleLocalFromTo.get(partyId[i])).doubleValue();
			}
			
			if(saleReturnLocalFromTo.containsKey(partyId[i]))
			{
				localValueCr += ((Double)saleReturnLocalFromTo.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherLocalDrFromTo.containsKey(partyId[i]))
			{
				localValueDr += ((Double)saleOtherLocalDrFromTo.get(partyId[i])).doubleValue();
			}
			

			if(saleOtherLocalCrFromTo.containsKey(partyId[i]))
			{
				localValueCr += ((Double)saleOtherLocalCrFromTo.get(partyId[i])).doubleValue();
			}

			if(saleExchGainLossFromTo.containsKey(partyId[i]))
			{
				double gainloss = ((Double)saleExchGainLossFromTo.get(partyId[i])).doubleValue();

				if(gainloss > 0)
					localValueCr += gainloss;
				else
					localValueDr += Math.abs(gainloss);
				//since +ve value is on Cr. side and -ve value is on Dr. side
			}

			String transValue = ""+localValueDr+"#"+localValueCr+"#"+dollarValueDr+"#"+dollarValueCr;	
			saleTrans.put(partyId[i], transValue);
		}


		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPartySalesTrans() after line="+errLine+" :" +e);
		}

		return saleTrans;
	}//getPartySalesTrans

	//method that will give the purchase transactions for the selected parties for a given date range 
	public HashMap getPartyPurchaseTrans(Connection con, String company_id, String[] partyId, String ctaxLedgerId, java.sql.Date D1, java.sql.Date D2)
	{
		String errLine = "1008";
		String query = "";
		HashMap purchaseTrans = new HashMap();
		try{
		
		String partyIdCondn = "(";

		for(int i=0; i<partyId.length; i++)
		{
			if("(".equals(partyIdCondn))
				partyIdCondn += partyId[i];
			else
				partyIdCondn += " ," + partyId[i];
		}
		
		partyIdCondn += ")";
	

		//calculating the exchange gain loss, sale and purchase for the given party for date range D1-D2 and populating the HashMaps
	
		partyExchangeGainLoss(con, company_id, partyIdCondn, D1, D2);
		getPurchaseTransactions(con, company_id, partyIdCondn, ctaxLedgerId, D1, D2); 
	
		//now using the populated HashMaps to calculate the transactions
		for(int i=0; i<partyId.length; i++)
		{
			//dollar value
			double dollarValueDr = 0;
			double dollarValueCr = 0;
					
			if(purchaseDollarFromTo.containsKey(partyId[i]))
			{
				dollarValueCr += ((Double)purchaseDollarFromTo.get(partyId[i])).doubleValue();
			}
			
			if(purchaseReturnDollarFromTo.containsKey(partyId[i]))
			{
				dollarValueDr += ((Double)purchaseReturnDollarFromTo.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherDollarDrFromTo.containsKey(partyId[i]))
			{
				dollarValueDr += ((Double)purchaseOtherDollarDrFromTo.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherDollarCrFromTo.containsKey(partyId[i]))
			{
				dollarValueCr += ((Double)purchaseOtherDollarCrFromTo.get(partyId[i])).doubleValue();
			}

			//local value
			double localValueDr = 0;
			double localValueCr = 0;
					
			if(purchaseLocalFromTo.containsKey(partyId[i]))
			{
				localValueCr += ((Double)purchaseLocalFromTo.get(partyId[i])).doubleValue();
			}
			
			if(purchaseReturnLocalFromTo.containsKey(partyId[i]))
			{
				localValueDr += ((Double)purchaseReturnLocalFromTo.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherLocalDrFromTo.containsKey(partyId[i]))
			{
				localValueDr += ((Double)purchaseOtherLocalDrFromTo.get(partyId[i])).doubleValue();
			}
			

			if(purchaseOtherLocalCrFromTo.containsKey(partyId[i]))
			{
				localValueCr += ((Double)purchaseOtherLocalCrFromTo.get(partyId[i])).doubleValue();
			}

			if(purchaseExchGainLossFromTo.containsKey(partyId[i]))
			{
				double gainloss = ((Double)purchaseExchGainLossFromTo.get(partyId[i])).doubleValue();

				if(gainloss > 0)
					localValueDr += gainloss;
				else
					localValueCr += Math.abs(gainloss);
				//since +ve value is on Dr. side and -ve value is on Cr. side
			}

			String transValue = ""+localValueDr+"#"+localValueCr+"#"+dollarValueDr+"#"+dollarValueCr;	
			purchaseTrans.put(partyId[i], transValue);
		}


		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPartyPurchaseTrans() after line="+errLine+" :" +e);
		}

		return purchaseTrans;
	}//getPartyPurchaseTrans


	//method that will give the PN closing in local and dollar seperated by # for selected partyIds at date D1 and stored in a HashMap that is partywise. -ve value means Cr and +ve value means Dr . For Closing pass the date incremented by 1 as the parameter i.e. to have 03/06/06 as closing date use the date 04/06/06 for calculations and it must be sent as parameters)
	public HashMap getPNClosing(Connection con, String company_id, String[] partyId, String pnAccountId, java.sql.Date D1)
	{
		String errLine = "1114";
		String query = "";
		HashMap pnClosing = new HashMap();
		try{
		
		String partyIdCondn = "(";

		for(int i=0; i<partyId.length; i++)
		{
			if("(".equals(partyIdCondn))
				partyIdCondn += partyId[i];
			else
				partyIdCondn += " ," + partyId[i];
		}
		
		partyIdCondn += ")";

		//get the PN Opening
		HashMap pnLocalOpening = new HashMap();
		HashMap pnDollarOpening = new HashMap();
		query = "Select CompanyParty_Id, CompanyParty_Name, Opening_PNLocalBalance, Opening_PNDollarBalance from Master_CompanyParty as MCP where MCP.Active=1 AND MCP.Company_Id="+company_id+" and CompanyParty_Id IN "+partyIdCondn+ " order by CompanyParty_Id";
		
		pstmt = con.prepareStatement(query);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("CompanyParty_Id");
			String name = rs.getString("CompanyParty_Name");
			Double pnlopen = new Double ( rs.getDouble("Opening_PNLocalBalance") );
			Double pndopen = new Double ( rs.getDouble("Opening_PNDollarBalance") );
		
			pnLocalOpening.put(id, pnlopen);
			pnDollarOpening.put(id, pndopen);
		}//while
		rs.close();
		pstmt.close();
		errLine = "1149";
	
		//get all the Cr transactions and store it in HashMap
		HashMap pnLocalAmtCr = new HashMap();
		HashMap pnDollarAmtCr = new HashMap();
		query = "Select PN.To_FromId, Sum(FT.Local_Amount) as localAmtCr, Sum(FT.Dollar_Amount) as dollarAmtCr from PN, Voucher V, Financial_Transaction FT where PN_Date < ? and V.Voucher_Id = FT.Voucher_Id and FT.For_HeadId="+pnAccountId+" and PN.Company_id="+company_id+" and PN.Active=1 and V.Active=1 and FT.Active=1 and Ledger_Id=0 and FT.For_Head=1 and FT.Transaction_Type=1 and (PN.Voucher_Id = V.Voucher_Id or refvoucher_Id = V.Voucher_Id) and PN.To_FromId IN "+partyIdCondn+"  group by PN.To_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1, D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("To_FromId");
			Double localAmtCr = new Double ( rs.getDouble("localAmtCr") );
			Double dollarAmtCr = new Double ( rs.getDouble("dollarAmtCr") );
		
			pnLocalAmtCr.put(id, localAmtCr);
			pnDollarAmtCr.put(id, dollarAmtCr);
		}//while
		rs.close();
		pstmt.close();
		errLine = "1170";

		//get all the Dr transactions and store it in HashMap
		HashMap pnLocalAmtDr = new HashMap();
		HashMap pnDollarAmtDr = new HashMap();
		query = "Select PN.To_FromId, Sum(FT.Local_Amount) as localAmtDr, Sum(FT.Dollar_Amount) as dollarAmtDr from PN, Voucher V, Financial_Transaction FT where PN_Date < ? and V.Voucher_Id = FT.Voucher_Id and FT.For_HeadId="+pnAccountId+" and PN.Company_id="+company_id+" and PN.Active=1 and V.Active=1 and FT.Active=1 and Ledger_Id=0 and FT.For_Head=1 and FT.Transaction_Type=0 and (PN.Voucher_Id = V.Voucher_Id or refvoucher_Id = V.Voucher_Id) and PN.To_FromId IN "+partyIdCondn+"  group by PN.To_FromId";

		pstmt = con.prepareStatement(query);
		pstmt.setDate(1, D1);
		rs = pstmt.executeQuery();	
		
		while(rs.next()) 
		{
			String id = rs.getString("To_FromId");
			Double localAmtDr = new Double ( rs.getDouble("localAmtDr") );
			Double dollarAmtDr = new Double ( rs.getDouble("dollarAmtDr") );
		
			pnLocalAmtDr.put(id, localAmtDr);
			pnDollarAmtDr.put(id, dollarAmtDr);
		}//while
		rs.close();
		pstmt.close();
		errLine = "1191";

		//compute the closing pn for the parties
		for(int i=0; i<partyId.length; i++)
		{
			double localValue = 0;
			double dollarValue = 0;

			
			if(pnLocalOpening.containsKey(partyId[i]))
			{
				localValue += ((Double)pnLocalOpening.get(partyId[i])).doubleValue();
			}
			if(pnDollarOpening.containsKey(partyId[i]))
			{
				dollarValue += ((Double)pnDollarOpening.get(partyId[i])).doubleValue();
			}
			if(pnLocalAmtDr.containsKey(partyId[i]))
			{
				localValue += ((Double)pnLocalAmtDr.get(partyId[i])).doubleValue();
			}
			if(pnDollarAmtDr.containsKey(partyId[i]))
			{
				dollarValue += ((Double)pnDollarAmtDr.get(partyId[i])).doubleValue();
			}
			if(pnLocalAmtCr.containsKey(partyId[i]))
			{
				localValue -= ((Double)pnLocalAmtCr.get(partyId[i])).doubleValue();
			}
			if(pnDollarAmtCr.containsKey(partyId[i]))
			{
				dollarValue -= ((Double)pnDollarAmtCr.get(partyId[i])).doubleValue();
			}


			String transValue = ""+localValue+"#"+dollarValue;	
			pnClosing.put(partyId[i], transValue);
		
		}
		errLine = "1232";


		}catch(Exception e)
		{
			System.out.println("Exception in file PartyOpeningClosing.java at method getPNClosing() after line="+errLine+" :" +e);
		}

		return pnClosing;
	}//getPNClosing
	

}	