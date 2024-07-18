package NipponBean;

import NipponBean.*;

public class SalesDistributionList
{
	String mainCol;   //This column can be a lot no., party name or salesperson name
	String desc;
	String size;
	String extraCol;  //Use this column to store some extra information

	double carats;
	double saleRate;
	double localSaleRate;
	double saleAmount;
	double localSaleAmount;
	double costRate;
	double localCostRate;
	double costAmount;
	double localCostAmount;
	double caratsAvg;
	double saleAvg_local;
	double saleAvg_dollar;
	double profitloss_local;
	double profitloss_dollar;
	double profit_per_local;
	double profit_per_dollar;
	double profitloss_per_local;
	double profitloss_per_dollar;

	public String getMainCol()
	{ 
		return this.mainCol;
	}
	
	public String getDesc()
	{ 
		return this.desc;
	}

    public String getSize()
	{ 
		return this.size;
	}
    
	public String getExtraCol()
	{ 
		return this.extraCol;
	}
	
	public double getCarats()
	{ 
		return this.carats;
	}

	public double getSaleRate()
	{ 
		return this.saleRate;
	}

	public double getLocalSaleRate()
	{ 
		return this.localSaleRate;
	}

	public double getSaleAmount()
	{ 
		return this.saleAmount;
	}

	public double getLocalSaleAmount()
	{ 
		return this.localSaleAmount;
	}

	public double getCostRate()
	{ 
		return this.costRate;
	}

	public double getLocalCostRate()
	{ 
		return this.localCostRate;
	}

	public double getCostAmount()
	{ 
		return this.costAmount;
	}

	public double getLocalCostAmount()
	{ 
		return this.localCostAmount;
	}

	public double getCaratsAvg()
	{ 
		return this.caratsAvg;
	}

	public double getSaleAvgLocal()
	{ 
		return this.saleAvg_local;
	}
	public double getSaleAvgDollar()
	{ 
		return this.saleAvg_dollar;
	}
	public double getProfitlossLocal()
	{ 
		return this.profitloss_local;
	}
	public double getProfitlossDollar()
	{ 
		return this.profitloss_dollar;
	}
	public double getProfit_perLocal()
	{ 
		return this.profit_per_local;
	}
	public double getProfit_perDollar()
	{ 
		return this.profit_per_dollar;
	}
	public double getProfitloss_perLocal()
	{ 
		return this.profitloss_per_local;
	}
    public double getProfitloss_perDollar()
	{ 
		return this.profitloss_per_dollar;
	}
	public SalesDistributionList(String mainCol, String desc, String size, String extraCol, double carats, double saleRate, double localSaleRate, double saleAmount, double localSaleAmount, double costRate, double localCostRate, double costAmount, double localCostAmount, double caratsAvg, double saleAvg_local,double saleAvg_dollar, double profitloss_local,double profitloss_dollar, double profit_per_local, double profit_per_dollar, double profitloss_per_local,double profitloss_per_dollar)
    {
		this.mainCol = mainCol;
		this.desc = desc;
		this.size = size;
		this.extraCol = extraCol;
		this.carats = carats;
		this.saleRate = saleRate;
		this.localSaleRate = localSaleRate;
		this.saleAmount = saleAmount;
		this.localSaleAmount = localSaleAmount;
		this.costRate = costRate;
		this.localCostRate = localCostRate;
		this.costAmount = costAmount;
		this.localCostAmount = localCostAmount;
		this.caratsAvg = caratsAvg;
		this.saleAvg_local = saleAvg_local;
		this.saleAvg_dollar= saleAvg_dollar;
		this.profitloss_local = profitloss_local;
		this.profitloss_dollar = profitloss_dollar;
		this.profit_per_local = profit_per_local;
		this.profit_per_dollar = profit_per_dollar;
		this.profitloss_per_local = profitloss_per_local;
		this.profitloss_per_dollar = profitloss_per_dollar;
	}

}