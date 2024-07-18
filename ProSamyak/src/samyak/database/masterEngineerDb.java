/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2		Anil			23-04-2011	Done		To Access on Server
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
package samyak.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import samyak.beans.masterEngineerBean;

public class masterEngineerDb 
{
	public  masterEngineerDb ()
	{
		
		
	}
	
	
public masterEngineerBean selectMasterEngineerDb(Connection cong  , long employeeId) throws Exception 
	{
		masterEngineerBean empObj = new masterEngineerBean();
		String query="Select * from masterEngineer  where active =1  and CurrentActive=1 and engineerId ="+employeeId;
		
		//System.out.println(" "+query);
		PreparedStatement pstmt_g = null;
		pstmt_g = cong.prepareStatement(query);
		ResultSet rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		
		empObj.setEngineerId(rs_g.getLong("engineerId"));
		empObj.setEngineerName(rs_g.getString("engineerName"));
		empObj.setEngineerDescription(rs_g.getString("engineerDescription"));
		
		empObj.setSrNo(rs_g.getLong("srNo"));
		empObj.setModifiedOn(rs_g.getTimestamp("modifiedOn"));
		empObj.setModifiedBy(rs_g.getString("modifiedBy"));
		
		empObj.setModifiedMachineName(rs_g.getString("modifiedMachineName"));
		empObj.setActive(rs_g.getBoolean("active"));
		empObj.setDesgnationId(rs_g.getLong("DesgnationId"));
		
		empObj.setJoinDate(rs_g.getTimestamp("JoinDate"));
		empObj.setBirthDate(rs_g.getTimestamp("birthDate"));
		empObj.setContactnumber(rs_g.getLong("Contactnumber"));
		
		empObj.setAddress(rs_g.getString("Address"));
			
		}
		
		
		return empObj ;
		
	}

public masterEngineerBean[]  selectMasterEngineerDb(Connection cong  , String condition , long counter) throws Exception 
{
	masterEngineerBean empObj [] = new masterEngineerBean[Integer.parseInt(String.valueOf(counter))];
	String query="Select * from masterEngineer  " +condition;
	
	PreparedStatement pstmt_g = null;
	pstmt_g = cong.prepareStatement(query);
	ResultSet rs_g = pstmt_g.executeQuery();
	int i=0 ;
	while(rs_g.next())
	{
		empObj[i] = new masterEngineerBean() ;
		empObj[i].setEngineerId(rs_g.getLong("engineerId"));
		empObj[i].setEngineerName(rs_g.getString("engineerName"));
		empObj[i].setEngineerDescription(rs_g.getString("engineerDescription"));
		
		empObj[i].setSrNo(rs_g.getLong("srNo"));
		empObj[i].setModifiedOn(rs_g.getTimestamp("modifiedOn"));
		empObj[i].setModifiedBy(rs_g.getString("modifiedBy"));
		
		empObj[i].setModifiedMachineName(rs_g.getString("modifiedMachineName"));
		empObj[i].setActive(rs_g.getBoolean("active"));
		empObj[i].setDesgnationId(rs_g.getLong("DesgnationId"));
		
		empObj[i].setJoinDate(rs_g.getTimestamp("JoinDate"));
		empObj[i].setBirthDate(rs_g.getTimestamp("birthDate"));
		empObj[i].setContactnumber(rs_g.getLong("Contactnumber"));
		
		empObj[i].setAddress(rs_g.getString("Address"));
			i++;
	}
	
	
	return empObj ;
	
}

}
