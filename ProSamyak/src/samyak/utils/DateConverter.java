/*
 <!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
 Sr No ModifiedBy		Date		Status		Reasons


-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		23/10/2010	start 		this class is used for differanted date format  
* 2    Mr Ganesh		27-10-2010  done        date convert 
* 3    Prashant          03-11-2010    version Control     	versioncontrol LS-1.1	
* 4    Rupesh 			04/11/2010	done		version control WIP-LS Finalise
* 5    Rupesh 			10/12/2010	done		added method 			 			
	-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

package samyak.utils;

import java.sql.Timestamp;
import java.util.StringTokenizer;

public class DateConverter {
	
	
	
	public static Timestamp getTimestamp(String str) {
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(str,"/");
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] "time"+  );
		T.setDate(DD[0]);
		T.setMonth((DD[1]-1));
		T.setYear(DD[2]-1900);
		//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] +"time\t"+T );
		return T;
	}
	
		public static Timestamp getTimestampDueDate(String str) {
			java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
			int[] DD =new int [3];
			StringTokenizer strt = new StringTokenizer(str,"/");
			DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
			DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
			DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
			//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] "time"+  );
			T.setDate((DD[0]+15));
			T.setMonth((DD[1]-1));
			T.setYear(DD[2]-1900);
			//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] +"time\t"+T );
			return T;
		}
		
	public static Timestamp getTimestampMethod(java.sql.Date str1) {
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		String str =String.valueOf(str1);
		
		int d=str1.getDay();
		int m=str1.getMonth();
		int y=str1.getYear();
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(str,"/");
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		System.out.println(" DD "+ d + " MM "+ m + " YYYY "+ y  );
		T.setDate(d);
		T.setMonth(m);
		T.setYear(y);
		//T.setMinutes();
		return T;
	}
	public static Timestamp getTimestampMethod(java.sql.Date str1,String type) {
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		String str =String.valueOf(str1);
		
		int d=str1.getDay();
		int m=str1.getMonth();
		int y=str1.getYear();
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(str,type);
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		System.out.println(" DD "+ d + " MM "+ m + " YYYY "+ y  );
		T.setDate(d);
		T.setMonth(m);
		T.setYear(y);
		//T.setMinutes();
		return T;
	}

	public static Timestamp getTimestamp(String str,String type) {
		java.sql.Timestamp T  = new java.sql.Timestamp(System.currentTimeMillis());
		int[] DD =new int [3];
		StringTokenizer strt = new StringTokenizer(str,type);
		DD[0] = Integer.parseInt(strt.nextToken().trim()); // DD
		DD[1] = Integer.parseInt(strt.nextToken().trim()); // MM
		DD[2] = Integer.parseInt(strt.nextToken().trim()); // YYYY
		//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] "time"+  );
		T.setDate(DD[0]);
		T.setMonth((DD[1]-1));
		T.setYear(DD[2]-1900);
		//System.out.println(" DD "+ DD[0] + " MM "+ DD[1] + " YYYY "+ DD[2] +"time\t"+T );
		return T;
	}
}
