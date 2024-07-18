package NipponBean;
import java.sql.*;
public class Connect1
{
	 	Connection cong = null;
	public	Connect1()
		{
			
		}
public Connection getConnection()	
	{

	 try{
		 Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		 cong=DriverManager.getConnection("jdbc:odbc:Nippon","Admin","nippon05");
		 }catch(Exception e)
			 { 
			 System.out.println("Error in connection::-- "+e);
			 return null;
			 }
	
	return cong;
	}

public Connection getConnection(String DSN, String user_id, String password)	
	{
	 	Connection cong = null;
	 try{
		 Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		 cong=DriverManager.getConnection("jdbc:odbc:"+DSN,user_id,password);
		 }catch(Exception e)
			 { 
			 System.out.println(e);
			 return null;
			 }
	
	return cong;
	}


public void returnConnection (Connection returned)	
	{try{
	returned.close();
}catch(Exception e){ }
	}//metod

}


