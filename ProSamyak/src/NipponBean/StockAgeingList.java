package NipponBean;

import NipponBean.*;

public class StockAgeingList
{
	int lot_id;
	String lot_no;   
	int desc;
	int size;
	int group;
	double carats;
	double closingLocalRate;
	double closingLocalAmount;
	double closingDollarRate;
	double closingDollarAmount;
	double ageingPerPeriod[];
	double localRatePerPeriod[];
	double localAmountPerPeriod[];
	double dollarRatePerPeriod[];
	double dollarAmountPerPeriod[];
	String orderIndex;
	String orderType;
	String orderByType;
	
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

	public double[] getAgeingPerPeriod()
	{ 
		return this.ageingPerPeriod;
	}

	public double[] getLocalRatePerPeriod()
	{ 
		return this.localRatePerPeriod;
	}


	public double[] getLocalAmountPerPeriod()
	{ 
		return this.localAmountPerPeriod;
	}

	public double[] getDollarRatePerPeriod()
	{ 
		return this.dollarRatePerPeriod;
	}

	public double[] getDollarAmountPerPeriod()
	{ 
		return this.dollarAmountPerPeriod;
	}

	public String getOrderIndex()
	{ 
		return this.orderIndex;
	}

	public String getOrderType()
	{ 
		return this.orderType;
	}
    
	public String getOrderByType()
	{ 
		return this.orderByType;
	}

	public StockAgeingList(int lot_id, String lot_no, int desc, int size, int group, double carats, double closingLocalRate, double closingLocalAmount, double closingDollarRate, double closingDollarAmount, double ageingPerPeriod[], double localRatePerPeriod[], double localAmountPerPeriod[], double dollarRatePerPeriod[], double dollarAmountPerPeriod[],String orderIndex, String orderType, String orderByType)
    {
		this.lot_id = lot_id;
		this.lot_no = lot_no;
		this.desc = desc;
		this.size = size;
		this.group = group;
		this.carats = carats;
		this.closingLocalRate = closingLocalRate;
		this.closingLocalAmount = closingLocalAmount;
		this.closingDollarRate = closingDollarRate;
		this.closingDollarAmount = closingDollarAmount;
		this.ageingPerPeriod = ageingPerPeriod;
		this.localRatePerPeriod = localRatePerPeriod;
		this.localAmountPerPeriod = localAmountPerPeriod;
		this.dollarRatePerPeriod = dollarRatePerPeriod;
		this.dollarAmountPerPeriod = dollarAmountPerPeriod;
		this.orderIndex = orderIndex;
		this.orderType = orderType;
		this.orderByType = orderByType;
	}

}