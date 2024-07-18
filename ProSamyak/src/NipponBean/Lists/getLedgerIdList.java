package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class getLedgerIdList
{
  Connection cong=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  
  String g_name[]=null;
  String g_id[]=null;
  Connect C;
  String query="";
  String id_name_column="";
  String str_Id="";
  String str_Name="";
  public getLedgerIdList() 
  {
    try
	{
		C = new Connect();
	}
	catch(Exception e)
	{
		System.out.println("Exception in LotList() in LotList="+e);
	}
	
}

public void getLedgerIdNameFromTable(String company_id,String party_id)
{
	String errLine = "42";	
	try
	{
		cong = C.getConnection();
		
			errLine = "48";
			int row_counter=0;
			query="Select count(*) as row_counter from Ledger where ParentCompanyParty_Id="+party_id+" and company_id="+company_id+" and active=1";
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				row_counter=rs_g.getInt("row_counter");
			} //while
			rs_g.close();
			pstmt_g.close();
			g_id=new String[row_counter];
			g_name=new String[row_counter];
			
			query="Select Ledger_Id,Ledger_Type from Ledger where ParentCompanyParty_Id="+party_id+" and company_id="+company_id+" and active=1";
			System.out.println("query="+query);
			System.out.println("cong="+cong);
			//System.out.println("query="+query);
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			int i=0;
			while(rs_g.next())
			{
				g_id[i]="Party#"+rs_g.getString("Ledger_Id");
				g_name[i]=rs_g.getString("Ledger_Type");	
				
				i++;
			} //while
			rs_g.close();
			pstmt_g.close();
		C.returnConnection(cong);
	} //try
	catch(Exception e)
	{
		  C.returnConnection(cong);
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	} //catch(Exception)
  }

 /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<LedgersIdList generated=\""+System.currentTimeMillis()+"\">\n");

   
     for (int i=0;i<g_name.length;i++) {
      String str_group_name=g_name[i];
	  //System.out.println("str_group_name="+str_group_name);
	   
	   //replace the ampersand in the code by &amp;
      StringBuffer tempName = new StringBuffer(str_group_name);
	  if( (str_group_name).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (str_group_name).indexOf("&"), ((str_group_name).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);

	 String str_group_id=g_id[i];
	 StringBuffer tempNo = new StringBuffer(str_group_id);
	 if( (str_group_id).indexOf('&') != -1 )
	 {
			tempNo = tempNo.replace( (str_group_id).indexOf("&"), ((str_group_id).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
	 }

	 xml.append("<LedgersIdName>\n");
		 
		  xml.append("<LedgerId>");
		  xml.append(tempNo);
		  xml.append("</LedgerId>\n");
		  
		  xml.append("<LedgerName>");
		  xml.append(tempName);
		  xml.append("</LedgerName>\n");
		  		 
	 
	 xml.append("</LedgersIdName>\n");
    }   
    
    xml.append("</LedgersIdList>\n");
    System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
