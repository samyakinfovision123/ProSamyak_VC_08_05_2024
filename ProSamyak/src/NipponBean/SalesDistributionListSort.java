package NipponBean;

import java.util.*;
import NipponBean.*;

public class SalesDistributionListSort
{
	public SalesDistributionListSort()
	{}

	public ArrayList orderTable(ArrayList tableToSort, String sortColName, String sortOrder)
	{
		if("asc".equals(sortOrder))
		{
			if("mainCol".equals(sortColName))
			{
				compareMainColAsc comp = new compareMainColAsc();
				Collections.sort(tableToSort, comp);
			}
			if("carats".equals(sortColName))
			{
				compareCaratsAsc comp = new compareCaratsAsc();
				Collections.sort(tableToSort, comp);
			}
			if("saleAmount".equals(sortColName))
			{
				compareSaleAmountAsc comp = new compareSaleAmountAsc();
				Collections.sort(tableToSort, comp);
			}
			if("profitloss_per".equals(sortColName))
			{
				compareProfitloss_perAsc comp = new compareProfitloss_perAsc();
				Collections.sort(tableToSort, comp);
			}

		}

		if("desc".equals(sortOrder))
		{
			if("mainCol".equals(sortColName))
			{
				compareMainColDesc comp = new compareMainColDesc();
				Collections.sort(tableToSort, comp);
			}
			if("carats".equals(sortColName))
			{
				compareCaratsDesc comp = new compareCaratsDesc();
				Collections.sort(tableToSort, comp);
			}
			if("saleAmount".equals(sortColName))
			{
				compareSaleAmountDesc comp = new compareSaleAmountDesc();
				Collections.sort(tableToSort, comp);
			}
			if("profitloss_per".equals(sortColName))
			{
				compareProfitloss_perDesc comp = new compareProfitloss_perDesc();
				Collections.sort(tableToSort, comp);
			}

		}

		return tableToSort;
	}
}



class compareMainColAsc implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	    String mainCol1 = ((SalesDistributionList)obj1).getMainCol();
		String mainCol2 =  ((SalesDistributionList)obj2).getMainCol();
	   
		return ((mainCol1).compareTo(mainCol2));		
	}	
}

class compareMainColDesc implements Comparator 
{
   public int compare(Object obj1,Object obj2)
	{
	    String mainCol1 = ((SalesDistributionList)obj1).getMainCol();
		String mainCol2 =  ((SalesDistributionList)obj2).getMainCol();
	   
		return ((mainCol2).compareTo(mainCol1));		
	   
	}	
}

class compareCaratsAsc implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	    Double carats1 = ((SalesDistributionList)obj1).getCarats();
		Double carats2 =  ((SalesDistributionList)obj2).getCarats();
	   
		return ((carats1).compareTo(carats2));		
	}	
}

class compareCaratsDesc implements Comparator 
{
   public int compare(Object obj1,Object obj2)
	{
	    Double carats1 = ((SalesDistributionList)obj1).getCarats();
		Double carats2 =  ((SalesDistributionList)obj2).getCarats();
	   
		return ((carats2).compareTo(carats1));		
	}		
}

class compareSaleAmountAsc implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	    Double saleAmount1 = ((SalesDistributionList)obj1).getSaleAmount();
		Double saleAmount2 =  ((SalesDistributionList)obj2).getSaleAmount();
	   
		return ((saleAmount1).compareTo(saleAmount2));		
	}	
}

class compareSaleAmountDesc implements Comparator 
{
   public int compare(Object obj1,Object obj2)
	{
	    Double saleAmount1 = ((SalesDistributionList)obj1).getSaleAmount();
		Double saleAmount2 =  ((SalesDistributionList)obj2).getSaleAmount();
	   
		return ((saleAmount2).compareTo(saleAmount1));		
	}		
}


class compareProfitloss_perAsc implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	    Double profitloss_per1 = ((SalesDistributionList)obj1).getProfitloss_perLocal();
		Double profitloss_per2 =  ((SalesDistributionList)obj2).getProfitloss_perLocal();
	   
		return ((profitloss_per1).compareTo(profitloss_per2));		
	}	
}

class compareProfitloss_perDesc implements Comparator 
{
   public int compare(Object obj1,Object obj2)
	{
	    Double profitloss_per1 = ((SalesDistributionList)obj1).getProfitloss_perLocal();
		Double profitloss_per2 =  ((SalesDistributionList)obj2).getProfitloss_perLocal();
	   
		return ((profitloss_per2).compareTo(profitloss_per1));		
	}		
}

