/*
 *  1)  Rupesh         Pending        22-7-2010         started
 */
package service;
import NipponBean.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Uservalidation {
 
	
	public int Checkvalidation(Connection conp,long companyId,String condition,String table) throws SQLException
	{
		String query ="Select * from Master_"+table+" where  company_id="+companyId+" and "+table+"_Name=?";
		PreparedStatement pstmt_p  = conp.prepareStatement(query);
		System.out.println(query);
		 pstmt_p.setString(1,condition);
		 ResultSet rs_g = pstmt_p.executeQuery();
		 int company_exist =0;
		String alreadyExist="";
		 while(rs_g.next())
		 {
			company_exist++;
			alreadyExist = alreadyExist + "  "+condition+"_name";
		 }//while
		 pstmt_p.close();
		System.out.println("company_exist"+company_exist);
		 return company_exist;

	}
	public int Checkemail(Connection conp,long companyId, String email) throws SQLException
	{
		String query ="Select * from Master_CompanyParty where active=1 and  email=?";
		PreparedStatement pstmt_p  = conp.prepareStatement(query);
		pstmt_p.setString(1,email);
System.out.println("Email"+query);
		ResultSet rs_g = pstmt_p.executeQuery();
		 
		 int email_exist =0;
		 String alreadyExist="";
		
		 while(rs_g.next())
		 {
			email_exist++;
			alreadyExist = alreadyExist + " | "+ email ;	 
		 }//while
		
		 pstmt_p.close(); 
		return email_exist;

	}
	
	

}
