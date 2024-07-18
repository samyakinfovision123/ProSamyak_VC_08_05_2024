package NipponBean;
import java.util.*;
import java.sql.*;
import NipponBean.*;

public class  Query
{
	Connection cong = null;
	Connect1 c;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	public	Query()
		{
		 /*try{c=new Connect1();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}
*/
		}
	
public String getDepartmentName(Connection con,String name) throws Exception
	{
	// cong=c.getConnection();
	String query ="select * from Master_Department where Department_Code like '"+name+"'";
	pstmt_g = con.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	
	String department = "";
	
	while(rs_g.next())
		{
		 department = rs_g.getString("name"); 
		}
	    pstmt_g.close();
		//c.returnConnection(cong);
	return department;	
	}
	public static void main(String[] args) throws Exception
	{

		Query l = new Query();
	
	}
}


