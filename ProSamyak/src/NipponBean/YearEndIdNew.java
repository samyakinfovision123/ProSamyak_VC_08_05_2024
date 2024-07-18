/* 
	Samyak Software	16/12/2005

	Written By: Dattatraya

	<<<method- getYrEndIdsNew(Connection conp, java.sql.Date startDate,java.sql.Date endDate, String company_id)
			-----Call this method with necessary parameters to get an ArrayList of Year End Ids that fall into the period between 'startdate' and 'endDate; >>>	

	Aim:if the startDate is before the entries in the database start then it should consider the first Year from which entries start &
		endDate is after the year in which last entry is done then it should consider the last Year.
	1)Returns -1 =>if Start Date & End Date are before entries in DataBase start 
	2)Returns -2 =>if Start Date is after To_Date of last YearEnd.

*/

package NipponBean;
import java.sql.*;
import java.util.*;
import NipponBean.*;

public class YearEndIdNew
{
	public YearEndIdNew()
	{

	}

	public ArrayList getYearEndIdsNew(Connection conp, java.sql.Date startDate, java.sql.Date endDate, String company_id)
	{
		ArrayList YearEndIdList= new ArrayList();
		 try{
			ResultSet rs_g= null;
			PreparedStatement pstmt_g= null;

			String query= "select * from YearEnd where company_id="+company_id+"";

			pstmt_g= conp.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			
			rs_g= pstmt_g.executeQuery();


			java.sql.Date from_date = new java.sql.Date(System.currentTimeMillis());
			java.sql.Date to_date = new java.sql.Date(System.currentTimeMillis());
    	
			int yearEndId;
			int state=0;
			
			/*use it:pstmt_g= conp.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE,
                                      ResultSet.CONCUR_READ_ONLY);

				rs_g.last();
			to_date= rs_g.getDate("To_Date");
			
			//If the start Date is after the to_date of last YearEnd
			System.out.println("48 inside YearEndIdNew.java to_date="+to_date);
			if(startDate.after(to_date))
			{
				YearEndIdList.add(new Integer(-2));
				pstmt_g.close();
				break out;
			}
			rs_g.first();*/
			Finish: while(rs_g.next())
			{
				 yearEndId= rs_g.getInt("YearEnd_Id");
				 from_date= rs_g.getDate("From_Date");
				 to_date= rs_g.getDate("To_Date");
				

				//Checks wheather both start date & end date  			 are before database entries start.
				 if(startDate.before(from_date) && endDate.before(from_date))
				{
					YearEndIdList.add(new Integer(-1));
					//YearEndIdList.add(from_date);
					//YearEndIdList.add(to_date);
					//return YearEndIdList;
					break Finish;
					
				 }

				 if(startDate.before(from_date) && (endDate.after(from_date) || endDate.equals(from_date) ))
				 {
				  startDate= from_date;
				 }
				
				 if((state==0)&&(from_date.compareTo(startDate)<=0)&&(to_date.compareTo(startDate)>=0))
				 {
					YearEndIdList.add(new Integer (yearEndId));
					//YearEndIdList.add(new java.sql.Date (from_date));
					//YearEndIdList.add(new java.sql.Date (to_date));

					state = 1;
					continue;
				 }
				
				 if(state==1)
				 {
					if(endDate.compareTo(to_date)>=0)
					 {
						YearEndIdList.add(new Integer (yearEndId));
						continue;
					 }
					 else
					 {
						if((endDate.compareTo(from_date)>=0)&&(endDate.compareTo(to_date)<0))
						{
							YearEndIdList.add(new Integer (yearEndId));
							state = 2;
						}
						else
						 {
							 state = 2;
						 }
					 }
				 }//end of if(state==1) 

		//if start date & end date are selected such that they are after the To_date of 1st YearEnd
			if((state==0)&&(from_date.compareTo(startDate)<=0)&&(to_date.compareTo(startDate)<0))
				{
					YearEndIdList.add(new Integer(yearEndId));
					state=1;
					continue;
				}
			}//end of while

			pstmt_g.close();
	}//end of try
	catch(Exception e)
		{
		System.out.println("Exception in getYearEndIds : "+e);
		}
		
		return YearEndIdList;
	}
} 
