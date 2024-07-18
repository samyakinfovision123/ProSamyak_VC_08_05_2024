
// Work done by Ravindra

package NipponBean;

import java.io.*;
import NipponBean.*;


public class New_MemoInData
{
	String receivetransaction_id = "";
	String receive_id = "";
	String receiveNo = "";
	String party_id = "";
	String party_name = "";
	String receiveLot = "";
	String lotNo = "";
	String qty = "";
	String invLocalRate = "";
	String invLocalTotal = "";
	String invDollarRate = "";
	String invDollarTotal = "";
	
	java.sql.Date receiveDate = null;
	java.sql.Date stockDate = null;
	java.sql.Date dueDate = null;
	
	String dueDays = "";
	String purchaseperson = "";
	String exchangeRate = "";
	String currency = "";
	String category = "";
	String narration = "";
	String refNo = "";
	String orderBy = "";
	String financialledger = "";

	String Original_Qty = "";
	String Return_Qty = "";
	String Rejection_Qty = "";
	String Qty = "";
	String rejection_Per = "";
	String lot_Discount = "";

	double ledger_total = 0; 
	double Ghat_Qty = 0;
		
	public String getReceiveId()
	{ 
		return this.receive_id;
	}

	public String getPartyId()
	{ 
		return this.party_id;
	}

	public String getPartyName()
	{ 
		return this.party_name;
	}

	public String getReceiveNo()
	{ 
		return this.receiveNo;
	}

	public String getReceiveLot()
	{ 
		return this.receiveLot;
	}

	public String getQuantity()
	{ 
		return this.qty;
	}

	public String getInvLocalRate()
	{ 
		return this.invLocalRate;
	}
	
	public String getInvLocalTotal()
	{ 
		return this.invLocalTotal;
	}

	public String getInvDollarRate()
	{
		return this.invDollarRate;
	}

	public String getInvDollarTotal()
	{
		return this.invDollarTotal;
	}

	public java.sql.Date getReceiveDate()
	{
		return this.receiveDate;
	}

	public java.sql.Date getStockDate()
	{
		return this.stockDate;
	}

	public java.sql.Date getDueDate()
	{
		return this.dueDate;
	}

	public String getdueDays()
	{
		return this.dueDays;
	}

	public String getPurchaseperson()
	{
		return this.purchaseperson;
	}

	public String getExchangeRate()
	{
		return this.exchangeRate;
	}

	public String getCurrency()
	{
		return this.currency;
	}

	public String getCategory()
	{
		return this.category;
	}

	public String getNarration()
	{
		return this.narration;
	}

	public String getRefNo()
	{
		return this.refNo;
	}

	public String getOrderType()
	{ 
		return this.orderBy;
	}

	public String getOriginalQty()
	{ 
		return this.Original_Qty;
	}

	public String getReturnQty()
	{ 
		return this.Return_Qty;
	}

	public double getGhatQty()
	{ 
		return this.Ghat_Qty;
	}

	public String getRejectionQty()
	{ 
		return this.Rejection_Qty;
	}

	public String getRejectionPer()
	{ 
		return this.rejection_Per;
	}

	public String getLotDiscount()
	{ 
		return this.lot_Discount;
	}

	public String getLotNo()
	{ 
		return this.lotNo;
	}

	public double getLedgerTotal()
	{ 
		return this.ledger_total;
	}
	
	
	New_MemoInData(String receive_id,String party_id,String party_name,String receiveNo,String receiveLot,java.sql.Date receiveDate,java.sql.Date stockDate,java.sql.Date dueDate,String dueDays,String exchangeRate,String currency,String narration,String category,String refNo,String purchaseperson,String orderBy)
    {
		this.receive_id = receive_id;
		this.party_id = party_id;
		this.party_name = party_name;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.receiveDate = receiveDate;
		this.stockDate = stockDate;
		this.dueDate = dueDate;
		this.dueDays = dueDays;
		this.exchangeRate = exchangeRate;
		this.currency = currency;
		this.narration = narration;
		this.category = category;
		this.refNo = refNo;
		this.purchaseperson = purchaseperson;
		this.orderBy = orderBy;
	}//end constructer New_MemoInData ( String-5 , Date-3 ,  String-8 )

	New_MemoInData(String receive_id,String Original_Qty,String Return_Qty,String Rejection_Qty,String Qty,String rejection_Per,String invLocalTotal,String invDollarTotal)
	{
		this.receive_id = receive_id;
		this.Original_Qty = Original_Qty;
		this.Return_Qty = Return_Qty;
		this.Rejection_Qty = Rejection_Qty;
		this.qty = Qty;
		this.rejection_Per = rejection_Per;
		this.invLocalTotal = invLocalTotal;
		this.invDollarTotal = invDollarTotal;
	}//end constructer New_MemoInData ( String-8 )

	New_MemoInData(String receive_id, String party_id, String party_name, String receiveNo, String receiveLot, java.sql.Date receiveDate, java.sql.Date stockDate, java.sql.Date dueDate, String dueDays, String exchangeRate, String currency, String narration, String category, String refNo, String invLocalTotal, String invDollarTotal, String purchaseperson, String orderBy, String Original_Qty, String Return_Qty, String Rejection_Qty, String Qty, String rejection_Per)
    {
		this.receive_id = receive_id;
		this.party_id = party_id;
		this.party_name = party_name;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.receiveDate = receiveDate;
		this.stockDate = stockDate;
		this.dueDate = dueDate;
		this.dueDays = dueDays;
		this.exchangeRate = exchangeRate;
		this.currency = currency;
		this.narration = narration;
		this.category = category;
		this.refNo = refNo;
		this.invLocalTotal = invLocalTotal;
		this.invDollarTotal = invDollarTotal;
		this.purchaseperson = purchaseperson;
		this.orderBy = orderBy;
		this.Original_Qty = Original_Qty;
		this.Return_Qty = Return_Qty;
		this.Rejection_Qty = Rejection_Qty;
		this.qty = Qty;
		this.rejection_Per = rejection_Per;
	}//end constructer New_MemoInData ( String-5 , Date-3 , String-15 )

	New_MemoInData(String receive_id, String party_id, String party_name, String receiveNo, String receiveLot, java.sql.Date receiveDate, java.sql.Date stockDate, java.sql.Date dueDate, String dueDays, String exchangeRate, String currency, String narration, String category, String refNo, String invLocalTotal, String invDollarTotal, String purchaseperson, String orderBy, String Original_Qty, String Return_Qty, String Rejection_Qty, String Qty, double ghatQty , String rejection_Per, double ledger_total)
    {
		this.receive_id = receive_id;
		this.party_id = party_id;
		this.party_name = party_name;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.receiveDate = receiveDate;
		this.stockDate = stockDate;
		this.dueDate = dueDate;
		this.dueDays = dueDays;
		this.exchangeRate = exchangeRate;
		this.currency = currency;
		this.narration = narration;
		this.category = category;
		this.refNo = refNo;
		this.invLocalTotal = invLocalTotal;
		this.invDollarTotal = invDollarTotal;
		this.purchaseperson = purchaseperson;
		this.orderBy = orderBy;
		this.Original_Qty = Original_Qty;
		this.Return_Qty = Return_Qty;
		this.Rejection_Qty = Rejection_Qty;
		this.qty = Qty;
		this.Ghat_Qty = ghatQty;
		this.rejection_Per = rejection_Per;
		this.ledger_total = ledger_total;

	}//end constructer New_MemoInData ( String-5 , Date-3 , String-15 , double-2 )

	New_MemoInData(String party_id, String party_name, String receive_id, String receiveNo, String receiveLot, String qty, String Original_Qty, String Return_Qty, String Rejection_Qty, String rejection_Per, String lot_Discount, String invLocalRate, String invLocalTotal, String invDollarRate, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate,java.sql.Date stockDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double ledger_total, String lotNo)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.lotNo = lotNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
		this.Original_Qty = Original_Qty;
		this.Return_Qty = Return_Qty;
		this.Rejection_Qty = Rejection_Qty;
		this.rejection_Per = rejection_Per;
		this.lot_Discount = lot_Discount;
		this.invLocalRate = invLocalRate;
		this.invLocalTotal = invLocalTotal;
		this.invDollarRate = invDollarRate;
		this.invDollarTotal = invDollarTotal;
		this.receiveDate = receiveDate;
		this.stockDate = stockDate;
		this.dueDate = dueDate;
		this.dueDays = dueDays;
		this.purchaseperson = purchaseperson;
		this.exchangeRate = exchangeRate;
		this.currency = currency;
		this.category = category;
		this.narration = narration;
		this.refNo = refNo;
		this.orderBy = orderBy;
		this.ledger_total = ledger_total;
	}

	New_MemoInData(String party_id, String party_name, String receive_id, String receiveNo, String receiveLot, String qty, String Original_Qty, String Return_Qty, String Rejection_Qty, double ghatQty, String rejection_Per, String lot_Discount, String invLocalRate, String invLocalTotal, String invDollarRate, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate,java.sql.Date stockDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double ledger_total, String lotNo)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.lotNo = lotNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
		this.Original_Qty = Original_Qty;
		this.Return_Qty = Return_Qty;
		this.Rejection_Qty = Rejection_Qty;
		this.Ghat_Qty = ghatQty;
		this.rejection_Per = rejection_Per;
		this.lot_Discount = lot_Discount;
		this.invLocalRate = invLocalRate;
		this.invLocalTotal = invLocalTotal;
		this.invDollarRate = invDollarRate;
		this.invDollarTotal = invDollarTotal;
		this.receiveDate = receiveDate;
		this.stockDate = stockDate;
		this.dueDate = dueDate;
		this.dueDays = dueDays;
		this.purchaseperson = purchaseperson;
		this.exchangeRate = exchangeRate;
		this.currency = currency;
		this.category = category;
		this.narration = narration;
		this.refNo = refNo;
		this.orderBy = orderBy;
		this.ledger_total = ledger_total;
	}


}//end class New_MemoInData
