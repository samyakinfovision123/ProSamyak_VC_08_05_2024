package NipponBean;

import NipponBean.*;

public class ClosingStockList
{
	int lot_id;
	String lot_no;   
	int desc;
	int size;
	int group;
	double carats;
	double localRate;
	double localAmount;
	double dollarRate;
	double dollarAmount;
	String orderType;
	
	public int getLot_id()
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
    
	public double getCarats()
	{ 
		return this.carats;
	}

	public double getLocalRate()
	{
		return this.localRate;
	}

	public double getLocalAmount()
	{
		return this.localAmount;
	}

	public double getDollarRate()
	{
		return this.dollarRate;
	}

	public double getDollarAmount()
	{
		return this.dollarAmount;
	}

	public String getOrderType()
	{ 
		return this.orderType;
	}
    
	public ClosingStockList(int lot_id, String lot_no, int desc, int size, int group, double carats, double localRate, double localAmount, double dollarRate, double dollarAmount, String orderType)
    {
		this.lot_id = lot_id;
		this.lot_no = lot_no;
		this.desc = desc;
		this.size = size;
		this.group = group;
		this.carats = carats;
		this.localRate = localRate;
		this.localAmount = localAmount;
		this.dollarRate = dollarRate;
		this.dollarAmount = dollarAmount;
		this.orderType = orderType;
	}

}