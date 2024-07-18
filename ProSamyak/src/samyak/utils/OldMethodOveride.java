package samyak.utils;
/*
<!-- 
	

created on 14/04/2010	by MR Ganesh
	
-->

<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
 Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1   Mr Ganesh	    14-04-2011  Done       add atttendant model
* 2   Mr Ganesh     22-04-2011  Done       report created 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class OldMethodOveride {
	
	public int getNameCondition(Connection con,String table,String coloum, String condition) throws Exception
	{
			int retuenVal=0;
			PreparedStatement pstmt_p=null;
			String query ="select "+coloum+" from "+table+" "+condition;
			pstmt_p = con.prepareStatement(query);
			System.out.println("Pro query "+query);
			ResultSet rs = pstmt_p.executeQuery();
			
			while(rs.next()) 	
			{
				retuenVal =Integer.parseInt(rs.getString(coloum).trim());
			}
			pstmt_p.close();
			
			return retuenVal;
				

	}//
	public int getNameConditionCriteri(Connection con,String table,String coloum, String condition) throws Exception
	{
			int retuenVal=0;
			PreparedStatement pstmt_p=null;
			String query ="select "+coloum+" from "+table+" "+condition;
			pstmt_p = con.prepareStatement(query ,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			System.out.println("Pro query "+query);
			ResultSet rs = pstmt_p.executeQuery();
			
			while(rs.next()) 	
			{
				retuenVal =Integer.parseInt(rs.getString(coloum).trim());
			}
			pstmt_p.close();
			
			return retuenVal;
				

	}//

		public String getMonth (Short months) 
	{
		String returnStr=null;
		
		switch (months) 
		{
		case 1:
			returnStr="Jan";
			break;
		case 2:
			returnStr="Feb";
			break;
		case 3:
			returnStr="Mar";
			break;
		case 4:	
			returnStr="Apr";
			break;
		case 5:
			returnStr="May";
			break;
		case 6:
			returnStr="Jun";
			break;
		case 7:
			returnStr="Jul";
			break;
		case 8:
			returnStr="Aug";
			break;
		case 9:
			returnStr="Sept";
			break;
		case 10:
			returnStr="Oct";
			break;
		case 11:
			returnStr="Nov";
			break;
		
		default:
			returnStr="Dec";
			break;
		}
		
		return returnStr;
	}
	
	
	public String getNameCondition(Connection con,String Query) throws Exception
	{

	PreparedStatement pstmt_p=null;
	//System.out.println("querytttttttttttttt "+Query);
	pstmt_p = con.prepareStatement(Query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	while(rs.next()) 	
	{
	 name = rs.getString(1);
	 System.out.println( " return  "+name );
	}
	pstmt_p.close();

	return name;
	}
	
	
	public String passQuery (Connection cong  , String Query  ,String ColoumName)throws Exception
	{
	
	String QtyAmt="0";	
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;
		 pstmt_g = cong.prepareStatement(Query);
		// System.out.println("Query " +Query);
		 rs_g = pstmt_g.executeQuery();
		
		while (rs_g.next())
		{
			
			QtyAmt=rs_g.getString(ColoumName);
			
			
			
		}
		
		
		return QtyAmt;
	}

	public String getDay(int day) 
	{
		String returnvalue="0";
		
		switch (day) 
		{
		case 1:
			returnvalue="01";
			break;
		case 2:
			returnvalue="02";
			break;
		case 3:
			returnvalue="03";
			break;
		case 4:	
			returnvalue="04";
			break;
		case 5:
			returnvalue="05";
			break;
		case 6:
			returnvalue="06";
			break;
		case 7:
			returnvalue="07";
			break;
		case 8:
			returnvalue="08";
			break;
		
		default:
			returnvalue="09";
			break;
		}
	
		
		return returnvalue;
	}
	
}
