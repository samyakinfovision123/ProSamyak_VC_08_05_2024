package NipponBean;

import NipponBean.*;

public class StockPreviewList
{
	long lot_id;
	String lot_no;   
	int desc;
	int size;
	int group;
	double openingcarats;
	double openingLocalRate;
	double openingLocalAmount;
	double openingDollarRate;
	double openingDollarAmount;

	double purchase;
	double cgtin;
	double mixin;
	double totalin;
	double localAvgPurRate;
	double dollarAvgPurRate;

	double sale;
	double cgtout;
	double mixout;
	double totalout;
	double localAvgSaleRate;
	double dollarAvgSaleRate;
	

	double closingcarats;
	double closingLocalRate;
	double closingLocalAmount;
	double closingDollarRate;
	double closingDollarAmount;
	String orderType;
	
	public long getLot_id()
	{ 
		return this.lot_id;
	}

	public String getLot_no()
	{ 
		return this.lot_no;
	}
	
	public int getDesc()
	{ 
		return this.desc;
	}

    public int getSize()
	{ 
		return this.size;
	}

	public int getGroup()
	{ 
		return this.group;
	}
    
	public double getOpeningcarats()
	{ 
		return this.openingcarats;
	}

	public double getOpeningLocalRate()
	{
		return this.openingLocalRate;
	}

	public double getOpeningLocalAmount()
	{
		return this.openingLocalAmount;
	}

	public double getOpeningDollarRate()
	{
		return this.openingDollarRate;
	}

	public double getOpeningDollarAmount()
	{
		return this.openingDollarAmount;
	}


	public double getPurchase()
	{ 
		return this.purchase;
	}

	public double getCgtin()
	{
		return this.cgtin;
	}

	public double getMixin()
	{
		return this.mixin;
	}

	public double getTotalin()
	{
		return this.totalin;
	}

	public double getLocalAvgPurRate()
	{
		return this.localAvgPurRate;
	}
	
	public double getDollarAvgPurRate()
	{
		return this.dollarAvgPurRate;
	}


	public double getSale()
	{ 
		return this.sale;
	}

	public double getCgtout()
	{
		return this.cgtout;
	}

	public double getMixout()
	{
		return this.mixout;
	}

	public double getTotalout()
	{
		return this.totalout;
	}

	public double getLocalAvgSaleRate()
	{
		return this.localAvgSaleRate;
	}
	
	public double getDollarAvgSaleRate()
	{
		return this.dollarAvgSaleRate;
	}


	public double getClosingcarats()
	{ 
		return this.closingcarats;
	}

	public double getClosingLocalRate()
	{
		return this.closingLocalRate;
	}

	public double getClosingLocalAmount()
	{
		return this.closingLocalAmount;
	}

	public double getClosingDollarRate()
	{
		return this.closingDollarRate;
	}

	public double getClosingDollarAmount()
	{
		return this.closingDollarAmount;
	}

	public String getOrderType()
	{ 
		return this.orderType;
	}
    
	public StockPreviewList(long lot_id, String lot_no, int desc, int size, int group, double openingcarats, double openingLocalRate, double openingLocalAmount, double openingDollarRate, double openingDollarAmount, double purchase, double cgtin, double mixin, double totalin, double localAvgPurRate,  double dollarAvgPurRate, double sale, double cgtout, double mixout, double totalout, double localAvgSaleRate,  double dollarAvgSaleRate, double closingcarats, double closingLocalRate, double closingLocalAmount, double closingDollarRate, double closingDollarAmount, String orderType)
    {
		this.lot_id = lot_id;
		this.lot_no = lot_no;
		this.desc = desc;
		this.size = size;
		this.group = group;
		this.openingcarats = openingcarats;
		this.openingLocalRate = openingLocalRate;
		this.openingLocalAmount = openingLocalAmount;
		this.openingDollarRate = openingDollarRate;
		this.openingDollarAmount = openingDollarAmount;

		this.purchase = purchase;
		this.cgtin = cgtin;
		this.mixin = mixin;
		this.totalin = totalin;
		this.localAvgPurRate = localAvgPurRate;
		this.dollarAvgPurRate = dollarAvgPurRate;

		this.sale = sale;
		this.cgtin = cgtout;
		this.mixout = mixout;
		this.totalout = totalout;
		this.localAvgSaleRate = localAvgSaleRate;
		this.dollarAvgSaleRate = dollarAvgSaleRate;

		this.closingcarats = closingcarats;
		this.closingLocalRate = closingLocalRate;
		this.closingLocalAmount = closingLocalAmount;
		this.closingDollarRate = closingDollarRate;
		this.closingDollarAmount = closingDollarAmount;
		
		this.orderType = orderType;
	}

}