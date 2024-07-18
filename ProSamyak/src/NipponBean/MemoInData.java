
// Work done by Ravindra

package NipponBean;

import java.io.*;
import NipponBean.*;


public class MemoInData
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

	double ledger_total = 0; 
	double grand_ledgerTotal = 0;   
	double totalPurchaseQty = 0;
	double totalReturnQty = 0;
	double totalPendingQty = 0;
	
	public String getPartyId()
	{ 
		return this.party_id;
	}

	public String getPartyName()
	{ 
		return this.party_name;
	}

	public String getReceiveTransactionId()
	{ 
		return this.receivetransaction_id;
	}
	
	public String getReceiveId()
	{ 
		return this.receive_id;
	}

	public String getReceiveNo()
	{ 
		return this.receiveNo;
	}

	public String getReceiveLot()
	{ 
		return this.receiveLot;
	}

	public String getLotNo()
	{ 
		return this.lotNo;
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

	public double getLedgerTotal()
	{
		return this.ledger_total;
	}

	public double getTotalPurchaseQty()
	{
		return this.totalPurchaseQty;
	}

	public double getTotalReturnQty()
	{
		return this.totalReturnQty;
	}

	public double getTotalPendingQty()
	{
		return this.totalPendingQty;
	}

	public MemoInData()
	{

	}
	
	//8,3,8,1
	public MemoInData(String party_id, String party_name, String receive_id, String receiveNo, String receiveLot, String qty, String invLocalTotal, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate, java.sql.Date stockDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double ledger_total)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
		this.invLocalTotal = invLocalTotal;
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

//10,3,8,1
	public MemoInData(String party_id, String party_name, String receive_id, String receiveNo, String receiveLot, String qty, String invLocalRate, String invLocalTotal, String invDollarRate, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate,java.sql.Date stockDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double ledger_total, String lotNo)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.lotNo = lotNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
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
//9,3,8,1
	public MemoInData(String party_id, String party_name, String receivetransaction_id, String receive_id, String receiveNo, String receiveLot, String qty, String invLocalTotal, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate, java.sql.Date stockDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double ledger_total)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receivetransaction_id = receivetransaction_id;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
		this.invLocalTotal = invLocalTotal;
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
//10,3,8,1
	public MemoInData(String party_id, String party_name, String receivetransaction_id, String receive_id, String receiveNo, String receiveLot, String lotNo, String qty, String invLocalTotal, String invDollarTotal, java.sql.Date receiveDate,java.sql.Date dueDate,java.sql.Date stockDate,String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo, String orderBy, double ledger_total)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receivetransaction_id = receivetransaction_id;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.lotNo = lotNo;
		this.qty = qty;
		this.invLocalTotal = invLocalTotal;
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
//9,3,8,3
	public MemoInData(String party_id, String party_name, String receivetransaction_id, String receive_id, String receiveNo, String receiveLot, String qty, String invLocalTotal, String invDollarTotal, java.sql.Date receiveDate, java.sql.Date stockDate,java.sql.Date dueDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double totalPurchaseQty , double totalReturnQty, double totalPendingQty)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receivetransaction_id = receivetransaction_id;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.qty = qty;
		this.invLocalTotal = invLocalTotal;
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
		this.totalPurchaseQty = totalPurchaseQty;
		this.totalReturnQty = totalReturnQty;
		this.totalPendingQty = totalPendingQty;
		
	}
//12,3,8,3
	public MemoInData(String party_id, String party_name, String receivetransaction_id, String receive_id, String receiveNo, String receiveLot, String lotNo, String qty, String invLocalRate, String invLocalTotal,  String invDollarRate, String invDollarTotal, java.sql.Date receiveDate, java.sql.Date stockDate,java.sql.Date dueDate, String dueDays, String purchaseperson, String exchangeRate, String currency, String category, String narration, String refNo,String orderBy, double totalPurchaseQty , double totalReturnQty, double totalPendingQty)
    {
		this.party_id = party_id;
		this.party_name = party_name;
		this.receivetransaction_id = receivetransaction_id;
		this.receive_id = receive_id;
		this.receiveNo = receiveNo;
		this.receiveLot = receiveLot;
		this.lotNo = lotNo;
		this.qty = qty;
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
		this.totalPurchaseQty = totalPurchaseQty;
		this.totalReturnQty = totalReturnQty;
		this.totalPendingQty = totalPendingQty;
	}
}
