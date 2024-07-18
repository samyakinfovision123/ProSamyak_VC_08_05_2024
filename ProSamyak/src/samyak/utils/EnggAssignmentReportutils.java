/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 1		Anil			23-04-2011	Done		To Access on Server

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

package samyak.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class EnggAssignmentReportutils
{
	
	public ArrayList<String>  getArrayList(Connection con,String Query ) throws Exception
	{
	PreparedStatement pstmtg = null;	
	ArrayList<String> retuList = new ArrayList<String>();
//	System.out.println("querytttttttttttttt "+Query);
	pstmtg = con.prepareStatement(Query);
	ResultSet rs = pstmtg.executeQuery();
	int key=0;
	while(rs.next()) 	
	{
		retuList.add(key , rs.getString(1));
		key++;
	}
	rs.close();
	pstmtg.close();

	return retuList;
	}
	
	
	

}
