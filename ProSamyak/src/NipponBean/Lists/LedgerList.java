package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class LedgerList {

  
  
  Connection cong=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  
  String group_name[]=new String[0];
  String gid[]=new String[0];

  Connect C;
  


  /**
   * Creates a new Cart instance
   */
  public LedgerList() {
    
	try{
		C = new Connect();
	}
	catch(Exception e)
	  {
		System.out.println("Exception in LotList() in LotList="+e);
	  }
	
  }

  /**
   * gets all the lots
   */
  public void getLedgerSubgroup(String company_id, String group_id) {

	  String errLine = "52";	

	  try{
		cong = C.getConnection();
		
		
		String query="";
		
		
		query="select count(*) as counter from Master_subGroup where company_id="+company_id+" and for_headId="+group_id;
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "60";
		int count=0;
		while(rs_g.next()) 	
		{
			count=rs_g.getInt("counter");
		}	
		gid=new String[count];
		group_name=new String[count];
		
		
		rs_g.close();
		pstmt_g.close();
		errLine = "96";
		query="select SubGroup_Id,SubGroup_Name from Master_subGroup where company_id="+company_id+" and for_headId="+group_id;
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		int cnt=0;
		while(rs_g.next()) 	
		{
			gid[cnt]=rs_g.getString("SubGroup_Id");
			group_name[cnt]=rs_g.getString("SubGroup_Name");
			cnt++;
		}	
		rs_g.close();
		pstmt_g.close();

		C.returnConnection(cong);
		
	  }
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	  }
  }

/**
   * gets all the lots
*/
  
  /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<LotList generated=\""+System.currentTimeMillis()+"\">\n");

    for (int i=0;i<group_name.length;i++) {
      String str_group_name=group_name[i];
	  //System.out.println("str_group_name="+str_group_name);
	   
	   //replace the ampersand in the code by &amp;
      StringBuffer tempName = new StringBuffer(str_group_name);
	  if( (str_group_name).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (str_group_name).indexOf("&"), ((str_group_name).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);

	 String str_group_id=gid[i];
	 StringBuffer tempNo = new StringBuffer(str_group_id);
	 if( (str_group_id).indexOf('&') != -1 )
	 {
			tempNo = tempNo.replace( (str_group_id).indexOf("&"), ((str_group_id).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
	 }

	 xml.append("<Lot>\n");
		 
		  xml.append("<SubgroupId>");
		  xml.append(tempNo);
		  xml.append("</SubgroupId>\n");
		  
		  xml.append("<SubgroupName>");
		  xml.append(tempName);
		  xml.append("</SubgroupName>\n");
		  		 
	 
	 xml.append("</Lot>\n");
    }
    
    xml.append("</LotList>\n");
    
	return xml.toString();
  }

  
}
