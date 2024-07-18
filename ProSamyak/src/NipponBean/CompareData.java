package NipponBean;

import java.util.*;
import java.sql.*;
import NipponBean.*;

public class CompareData implements Comparator
{
	public int compare(Object obj1,Object obj2)
	{
		int compared = 0;
		String orderType = ((MemoInData)obj1).getOrderType();
		
		if("Quantity".equals(orderType))
		{
			Double compareColValue1 = Double.parseDouble(((MemoInData)obj1).getQuantity());
			Double compareColValue2 = Double.parseDouble(((MemoInData)obj2).getQuantity());

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Quantity

		if("Local Amount".equals(orderType))
		{
			Double compareColValue1 = Double.parseDouble(((MemoInData)obj1).getInvLocalTotal());
			Double compareColValue2 = Double.parseDouble(((MemoInData)obj2).getInvLocalTotal());

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Local Amount

		if("Dollar Amount".equals(orderType))
		{
			Double compareColValue1 = Double.parseDouble(((MemoInData)obj1).getInvDollarTotal());
			Double compareColValue2 = Double.parseDouble(((MemoInData)obj2).getInvDollarTotal());

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Dollar Amount

		if("Receive Id".equals(orderType))
		{
			Double compareColValue1 = Double.parseDouble(((MemoInData)obj1).getReceiveId());
			Double compareColValue2 = Double.parseDouble(((MemoInData)obj2).getReceiveId());

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Receive Id

		/*if("Receive No".equals(orderType))
		{
			String compareColValue1 = ((MemoInData)obj1).getReceiveNo();
			String compareColValue2 = ((MemoInData)obj2).getReceiveNo();

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Receive No*/

		if("Receive FromName".equals(orderType))
		{
			String compareColValue1 = ((MemoInData)obj1).getPartyName();
			String compareColValue2 = ((MemoInData)obj2).getPartyName();

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Receive FromName

		if("Receive Date".equals(orderType))
		{
			java.sql.Date compareColValue1 =  ((MemoInData)obj1).getReceiveDate();
			java.sql.Date compareColValue2 =  ((MemoInData)obj2).getReceiveDate();

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Receive Date

		if("Stock Date".equals(orderType))
		{
			java.sql.Date compareColValue1 =  ((MemoInData)obj1).getStockDate();
			java.sql.Date compareColValue2 =  ((MemoInData)obj2).getStockDate();

			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Stock Date

		if("Due Date".equals(orderType))
		{
			java.sql.Date compareColValue1 =  ((MemoInData)obj1).getDueDate();
			java.sql.Date compareColValue2 =  ((MemoInData)obj2).getDueDate();


			//comparing in descending order
			compared =	(compareColValue2).compareTo(compareColValue1);
			
		}//end if orderType Stock Date

		return compared;
	}
};
