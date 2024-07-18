package NipponBean;

/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		11/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    Mr ganesh        22-04-2011  Done        time problem
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.sql.*;
import javax.naming.*;
import javax.sql.*;


public class Connect
{
	String errLine="11";
	private DataSource dataSource = null;
	private static int connectionCount = 0;

	public Connect()
	{
	try{
		Context init = new InitialContext();
		
		Context ctx = (Context) init.lookup("java:comp/env");
		dataSource = (DataSource) ctx.lookup("jdbc/NipponTestDB");
		errLine="22";
	}
	catch (Exception ex)
		{
			System.out.println("Exception in Connect.java Connect() errLine"+errLine+" is " +ex);
		}
	}

	public Connection getConnection()
	{
		Connection con=null;
		try {
			con = dataSource.getConnection();
			errLine="35";
			connectionCount++;
			System.out.println("getConnection() open Connections = "+connectionCount);

		}
		catch (Exception ex)
		{
			System.out.println("Exception in Connect.java getConnection() errLine"+errLine+" is " +ex);
		}
    
		//System.out.println("open Connection con="+con);
		return con;
		
	}//method
public void returnConnection (Connection returned)	
{
try{
	if(returned!=null)
	{
		//System.out.println("Return Connection ="+returned);
		returned.close();
		errLine="58";
		connectionCount--;
		System.out.println("returnConnection() open Connections = "+connectionCount);
	}
	returned=null;
		

	}catch(Exception se){
		System.out.println("Exception in Connect.java returnConnection() errLine"+errLine+" is " +se);}
	}//method
}//class





