package samyak.database;
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        add Eng Id
* 3    Mr Ganesh        27-04-2011  done        add new coloum add 
* 4		Anil			26-04-2011  done        TL 2 Version Control
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import samyak.beans.attendant;

public class attendantDb 
{
	public attendantDb() 
	{
		
	}
	
public int insertAttendantDb(Connection conp, attendant MAObj) throws SQLException
	{
		PreparedStatement  pstmt_p=null;
		String query="Insert into Attendance "+
		             "( attendantId  ,                             engineerId,               "+
		              " time, 		                  			   Active , 				 " +
		              " remark 										 )             			 " +                                                                                     
					   " values(?,?,?,?, ? )"; //05 field
		
		pstmt_p=conp.prepareStatement(query);
	
		pstmt_p.setLong(1, MAObj.getAttendantId());
		pstmt_p.setLong(2, MAObj.getEngineerId());
		pstmt_p.setTimestamp(3, MAObj.getTime());
		pstmt_p.setBoolean(4, MAObj.isActive());
		System.out.println("remark  " );
		pstmt_p.setString(5, MAObj.getRemark());
		System.out.println("insert  "+MAObj.getRemark());
		int queystatus=pstmt_p.executeUpdate();
		System.out.println("update  "+queystatus);
		return queystatus;
		
	}//insert Master Address
	

}
