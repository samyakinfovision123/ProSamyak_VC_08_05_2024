package NipponBean;

import java.util.*;
import NipponBean.*;

public class StockAgeingComparator implements Comparator
{
	public int compare(Object obj1,Object obj2)
	{
		int compared = 0;
		int orderIndex = Integer.parseInt(((StockAgeingList)obj1).getOrderIndex());
		String orderType = ((StockAgeingList)obj1).getOrderType();
		String orderByType = ((StockAgeingList)obj1).getOrderByType();
		
		if(orderIndex >= 0 && "quantity".equals(orderByType) )
		{
			double ageingPerPeriod1[] = ((StockAgeingList)obj1).getAgeingPerPeriod();
			double ageingPerPeriod2[] = ((StockAgeingList)obj2).getAgeingPerPeriod();

			Double compareColValue1 = ageingPerPeriod1[orderIndex];
			Double compareColValue2 = ageingPerPeriod2[orderIndex];

			if("asc".equals(orderType))
			{
				compared =	(compareColValue1).compareTo(compareColValue2);
			}
			if("desc".equals(orderType))
			{
				compared =	(compareColValue2).compareTo(compareColValue1);
			}
		}
		if(orderIndex >= 0 && "localAmount".equals(orderByType) )
		{
			double localAmountPerPeriod1[] = ((StockAgeingList)obj1).getLocalAmountPerPeriod();
			double localAmountPerPeriod2[] = ((StockAgeingList)obj2).getLocalAmountPerPeriod();

			Double compareColValue1 = localAmountPerPeriod1[orderIndex];
			Double compareColValue2 = localAmountPerPeriod2[orderIndex];

			if("asc".equals(orderType))
			{
				compared =	(compareColValue1).compareTo(compareColValue2);
			}
			if("desc".equals(orderType))
			{
				compared =	(compareColValue2).compareTo(compareColValue1);
			}
		}
		if(orderIndex >= 0 && "dollarAmount".equals(orderByType) )
		{
			double dollarAmountPerPeriod1[] = ((StockAgeingList)obj1).getDollarAmountPerPeriod();
			double dollarAmountPerPeriod2[] = ((StockAgeingList)obj2).getDollarAmountPerPeriod();

			Double compareColValue1 = dollarAmountPerPeriod1[orderIndex];
			Double compareColValue2 = dollarAmountPerPeriod2[orderIndex];

			if("asc".equals(orderType))
			{
				compared =	(compareColValue1).compareTo(compareColValue2);
			}
			if("desc".equals(orderType))
			{
				compared =	(compareColValue2).compareTo(compareColValue1);
			}
		}
		return compared;
	}
};