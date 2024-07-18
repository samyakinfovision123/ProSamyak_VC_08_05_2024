/*
Samyak Software 04/10/05
class name -  getYearEndIds

<<<method- getYrEndIds(Connection conp, java.sql.Date startDate,java.sql.Date 		endDate, String company_id)
-----Call this method with necessary parameters to get an ArrayList of Year End Ids that fall into the period between 'startdate' and 'endDate; >>>	
*/


package NipponBean;
import java.sql.*;
import NipponBean.*;
import java.util.*;

public class getYearEndIds
{

	public getYearEndIds()
	{
	
	}


	public ArrayList getYrEndIds(Connection conp, java.sql.Date startDate,java.sql.Date endDate, String company_id)
	{		
		ArrayList YearIdList=new ArrayList();
	try{
		ResultSet rs_g=null;
		PreparedStatement pstmt_g=null;

		String query="select * from YearEnd where company_id="+company_id+"";
		

	
		pstmt_g= conp.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();

		java.sql.Date from_date = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date to_date = new java.sql.Date(System.currentTimeMillis());
    	
		int yearEndId;
		int state=0;
		
		//state: 0=nothing found; 1=1st found; 2=last found or last already found
		while(rs_g.next())
		{
			yearEndId=rs_g.getInt("YearEnd_Id");
			from_date=rs_g.getDate("From_Date");
			to_date=rs_g.getDate("To_Date");
			
			
			if((state==0)&&(from_date.compareTo(startDate)<=0)&&(to_date.compareTo(startDate)>=0))
			{
				YearIdList.add(new Integer(yearEndId));
				state=1;//1st found
				continue;
			}
			if(state==1)
			{
				if(endDate.compareTo(to_date)>=0)
				{
					YearIdList.add(new Integer(yearEndId));
					
					continue;
				}
				else{
				   		if((endDate.compareTo(from_date)>=0)&&(endDate.compareTo(to_date)<0))
						{
							YearIdList.add(new Integer(yearEndId));	
							state=2;//last found
						}
						else
						{ state=2;// last already found
						}
				
					 }
			 }
			
		  }//end of while
		pstmt_g.close();

	 }//end of try
	catch(Exception e)
		{
		System.out.println("Exception in getYearEndIds : "+e);
		}
		
		return YearIdList;
	
	}// end of method -getYrEndIds()
}//end of class
