/*
 <!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 

 Sr No ModifiedBy		Date		Status		Reasons

-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2010	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        add methods 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

package samyak.utils;

import java.sql.Timestamp;
import java.util.StringTokenizer;
import java.sql.Date;
public class Utility {
	
	
	public static Timestamp getTimestamp(String str) 
	{
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(str,"/");
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		

		T.setDate(DD[0]);
		T.setMonth(DD[1]-1);

	
		return T;
	}
	
	public static Timestamp getTimestampWithDate(Date date) 
	{
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		
		 String dateStr = String.valueOf(date); 
		 int month = date.getMonth();
		 int year = date.getYear();
		 int Day = date.getDay();
		 
		 
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(dateStr,"-");
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		

		T.setDate(DD[0]);
		T.setMonth(DD[1] +1 );
		T.setYear(year + 1990);
		
	
		return T;
	}
}
