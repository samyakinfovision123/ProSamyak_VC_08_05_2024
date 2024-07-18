package NipponBean;

import java.util.*;
import NipponBean.*;

public class StockPreviewTopRowsComp implements Comparator
{
	public int compare(Object obj1,Object obj2)
	{
		int compared = 0;
		String orderType = ((StockPreviewList)obj1).getOrderType();

		if("openingcarats".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1).getOpeningcarats();
			Double compareColValue2 = ((StockPreviewList)obj2).getOpeningcarats();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("openinglocalrate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getOpeningLocalRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getOpeningLocalRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("openingdollarrate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getOpeningDollarRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getOpeningDollarRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("openinglocalamount".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getOpeningLocalAmount();
			Double compareColValue2 = ((StockPreviewList)obj2). getOpeningLocalAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("openingdollaramount".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getOpeningDollarAmount();
			Double compareColValue2 = ((StockPreviewList)obj2). getOpeningDollarAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}



		if("purchase".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1).getPurchase();
			Double compareColValue2 = ((StockPreviewList)obj2).getPurchase();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("cgtin".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getCgtin();
			Double compareColValue2 = ((StockPreviewList)obj2). getCgtin();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("mixin".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getMixin();
			Double compareColValue2 = ((StockPreviewList)obj2). getMixin();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("totalin".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getTotalin();
			Double compareColValue2 = ((StockPreviewList)obj2). getTotalin();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("localAvgPurRate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getLocalAvgPurRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getLocalAvgPurRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("dollarAvgPurRate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getDollarAvgPurRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getDollarAvgPurRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}


		
		if("sale".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1).getSale();
			Double compareColValue2 = ((StockPreviewList)obj2).getSale();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("cgtout".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getCgtout();
			Double compareColValue2 = ((StockPreviewList)obj2). getCgtout();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("mixout".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getMixout();
			Double compareColValue2 = ((StockPreviewList)obj2). getMixout();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("totalout".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getTotalout();
			Double compareColValue2 = ((StockPreviewList)obj2). getTotalout();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("localAvgSaleRate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getLocalAvgSaleRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getLocalAvgSaleRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("dollarAvgSaleRate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getDollarAvgSaleRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getDollarAvgSaleRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		
		if("closingcarats".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1).getClosingcarats();
			Double compareColValue2 = ((StockPreviewList)obj2).getClosingcarats();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("closinglocalrate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getClosingLocalRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getClosingLocalRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("closingdollarrate".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getClosingDollarRate();
			Double compareColValue2 = ((StockPreviewList)obj2). getClosingDollarRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("closinglocalamount".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getClosingLocalAmount();
			Double compareColValue2 = ((StockPreviewList)obj2). getClosingLocalAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("closingdollaramount".equals(orderType))
		{
			Double compareColValue1 = ((StockPreviewList)obj1). getClosingDollarAmount();
			Double compareColValue2 = ((StockPreviewList)obj2). getClosingDollarAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}
		return compared;
	}
};