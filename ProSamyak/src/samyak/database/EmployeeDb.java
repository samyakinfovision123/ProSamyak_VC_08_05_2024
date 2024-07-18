package samyak.database;
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import samyak.beans.EmployeeBean;

public class EmployeeDb
{

	public EmployeeDb()
	{
		
	}
	
public EmployeeBean selectEmployeeDb(Connection cong  , long employeeId) throws Exception 
{
	EmployeeBean empObj = new EmployeeBean();
	String query="Select * from Employee  where masterUserId = "+employeeId;
	
	PreparedStatement pstmt_g = null;
	pstmt_g = cong.prepareStatement(query);
	ResultSet rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
	
	empObj.setEmployeeId(rs_g.getLong("employeeId"));
	empObj.setFirstName(rs_g.getString("firstName"));
	empObj.setMiddleName(rs_g.getString("middleName"));
	
	empObj.setLastName(rs_g.getString("lastName"));
	empObj.setJoinDate(rs_g.getTimestamp("JoinDate"));
	empObj.setBirthDate(rs_g.getTimestamp("birthDate"));
	
	empObj.setActive(rs_g.getBoolean("active"));
	empObj.setAddress(rs_g.getString("Address"));
	empObj.setContactnumber(rs_g.getLong("Contactnumber"));
	
	empObj.setDesination(rs_g.getString("Desination"));
	empObj.setMasterUserId(rs_g.getLong("masterUserId"));
	}
	
	
	return empObj ;
	
}

public EmployeeBean[]  selectEmployeeDbMulti(Connection cong  , String condition , long counter) throws Exception 
{
	EmployeeBean empObj [] = new EmployeeBean[Integer.parseInt(String.valueOf(counter))];
	String query="Select * from Employee  " +condition;
	
	PreparedStatement pstmt_g = null;
	pstmt_g = cong.prepareStatement(query);
	ResultSet rs_g = pstmt_g.executeQuery();
	int i=0 ;
	while(rs_g.next())
	{
	 empObj [i] = new EmployeeBean() ;
	empObj[i].setEmployeeId(rs_g.getLong("employeeId"));
	empObj[i].setFirstName(rs_g.getString("firstName"));
	empObj[i].setMiddleName(rs_g.getString("middleName"));
	
	empObj[i].setLastName(rs_g.getString("lastName"));
	empObj[i].setJoinDate(rs_g.getTimestamp("JoinDate"));
	empObj[i].setBirthDate(rs_g.getTimestamp("birthDate"));
	
	empObj[i].setActive(rs_g.getBoolean("active"));
	empObj[i].setAddress(rs_g.getString("Address"));
	empObj[i].setContactnumber(rs_g.getLong("Contactnumber"));
	
	empObj[i].setDesination(rs_g.getString("Desination"));
	empObj[i].setMasterUserId(rs_g.getLong("masterUserId"));
	i++;
	}
	
	
	return empObj ;
	
}

}
