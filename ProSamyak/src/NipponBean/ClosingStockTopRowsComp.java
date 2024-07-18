package NipponBean;

import java.util.*;
import NipponBean.*;

public class ClosingStockTopRowsComp implements Comparator
{
	public int compare(Object obj1,Object obj2)
	{
		int compared = 0;
		String orderType = ((ClosingStockList)obj1).getOrderType();
		
		if("quantity".equals(orderType))
		{
			Double compareColValue1 = ((ClosingStockList)obj1).getCarats();
			Double compareColValue2 = ((ClosingStockList)obj2).getCarats();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("localrate".equals(orderType))
		{
			Double compareColValue1 = ((ClosingStockList)obj1). getLocalRate();
			Double compareColValue2 = ((ClosingStockList)obj2). getLocalRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("dollarrate".equals(orderType))
		{
			Double compareColValue1 = ((ClosingStockList)obj1). getDollarRate();
			Double compareColValue2 = ((ClosingStockList)obj2). getDollarRate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("localamount".equals(orderType))
		{
			Double compareColValue1 = ((ClosingStockList)obj1). getLocalAmount();
			Double compareColValue2 = ((ClosingStockList)obj2). getLocalAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}

		if("dollaramount".equals(orderType))
		{
			Double compareColValue1 = ((ClosingStockList)obj1). getDollarAmount();
			Double compareColValue2 = ((ClosingStockList)obj2). getDollarAmount();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}
		return compared;
	}
};