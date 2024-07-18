package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class getCashBankLedgerIdList {

  
  
  Connection cong=null;
  Connection conp=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  int d=3;
  String g_name="";
  String g_id="";
  Connect C;
  NipponBean.Array A;
  
  String query="";
  String id_name_column="";
  String str_Id="";
  String str_Name="";
  double local_closing  =0;	
  double dollar_closing =0;	
  
public getCashBankLedgerIdList() 
{
    try
	{
		C = new Connect();
		A = new NipponBean.Array();
	} //try
	catch(Exception e)
	{
		System.out.println("Exception in LotList() in LotList="+e);
	} //catch(Exception)
	
}

public void getIdNameFromTable(String company_id, String name)
{
	String errLine = "52";	
	try
	{
		cong = C.getConnection();
		conp = C.getConnection();
		
		if(!("".equals(name)))
		{
			errLine = "48";
			query="Select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where CompanyParty_Name='"+name+"' and company_id="+company_id+" and active=1";
			System.out.println("query="+query);
			System.out.println("cong="+cong);
			//System.out.println("query="+query);
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Party#";
				g_id+=rs_g.getString("CompanyParty_Id");
				g_name=rs_g.getString("companyParty_Name");	
			} //while
			rs_g.close();
			pstmt_g.close();
			
			errLine = "61";
			/*query="Select Ledger_Id,Ledger_Name from Ledger where Ledger_Name='"+name+"' and company_id="+company_id+" and active=1 and for_head<>14 and ParentCompanyParty_Id=0";
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Led#";
				g_id+=rs_g.getString("Ledger_Id");
				g_name=rs_g.getString("Ledger_Name");	
			} //while
			rs_g.close();
			pstmt_g.close();*/
			errLine = "72";
			String account_type="";
			query="Select Account_Id,Account_Name,AccountType_Id from Master_Account where AccountType_Id IN (1, 6) and  company_Id="+company_id+" and Account_Name='"+name+"'";
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Bank#";
				g_id+=rs_g.getString("Account_Id");
				g_name=rs_g.getString("Account_Name");	
				account_type=rs_g.getString("AccountType_Id");	
				if("1".equals(account_type))
				{
					String temp_g_id[]=g_id.split("#");	
					g_id="Bank#"+temp_g_id[1];
				}
				if("6".equals(account_type))
				{
					String temp_g_id[]=g_id.split("#");	
					g_id="Cash#"+temp_g_id[1];
				}
			} //while
			rs_g.close();
			pstmt_g.close();
		
		
		} //if("".equals(table))
		
		C.returnConnection(cong);
		C.returnConnection(conp);
	} //try
	catch(Exception e)
	{
		  C.returnConnection(cong);
		  C.returnConnection(conp);
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	} //catch(Exception)
  }

 /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<IdList generated=\""+System.currentTimeMillis()+"\">\n");

   
      String str_group_name=g_name;
	  //System.out.println("str_group_name="+str_group_name);
	   
	   //replace the ampersand in the code by &amp;
      StringBuffer tempName = new StringBuffer(g_name);
	  if( (str_group_name).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (str_group_name).indexOf("&"), ((str_group_name).indexOf("&"))+1, "&amp;");
		}
	

	 String str_group_id=g_id;
	 StringBuffer tempNo = new StringBuffer(g_id);
	 if( (str_group_id).indexOf('&') != -1 )
	 {
			tempNo = tempNo.replace( (str_group_id).indexOf("&"), ((str_group_id).indexOf("&"))+1, "&amp;");
	 }

	 xml.append("<IdName>\n");
		 
		  xml.append("<ColumnId>");
		  xml.append(tempNo);
		  xml.append("</ColumnId>\n");
		  
		  xml.append("<ColumnName>");
		  xml.append(tempName);
		  xml.append("</ColumnName>\n");
		  		  	 
	 xml.append("</IdName>\n");
   
    
    xml.append("</IdList>\n");
    //System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
