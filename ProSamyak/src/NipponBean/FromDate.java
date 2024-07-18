package NipponBean;
import java.sql.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;
public class FromDate 
{
	//private	Connection conp;	
	
	private	PreparedStatement pstmt_p=null;
	ResultSet rs_g=null;
//	Connect1 c;
 	public FromDate()
	{
	
	}

	public Date getFirstVoucherDate(Connection conp,String table,String column,
	String condition)
	{
		java.sql.Date D = null;//new java.sql.Date(System.currentTimeMillis());
		try
		{
			
			String strQuery="select top 1 "+column+" from "+table+
			" where "+condition; 

			//System.out.println("strQuery="+strQuery);
			pstmt_p=conp.prepareStatement(strQuery);
			rs_g=pstmt_p.executeQuery();
			while(rs_g.next())
			{
				D=rs_g.getDate(column);
			} //while
			return (D);
		} //try
		catch(Exception e)
		{
			System.out.println (e) ;
			return( D);
		} //catch(Exception e)
	} //getFirstVoucherDate
	
} //FromDate