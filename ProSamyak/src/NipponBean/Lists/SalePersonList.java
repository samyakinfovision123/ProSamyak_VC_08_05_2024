package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class SalePersonList {

  
  
  Connection cong=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  
  String saleperson_id[]=new String[100];
  String saleperson_name1[]=new String[100];

  Connect C;
  


  /**
   * Creates a new Cart instance
   */
  public SalePersonList() {
    
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
  public void getSalePersonIdName(String company_id,String saleperson_name,String isNext) {

	  String errLine = "52";	
	  
	  
	  try{
		
		//System.out.println("###### party_name="+party_name);
		boolean isNoDate=true;//party_name.contains("-");
		String query="";
		if(!(isNoDate))
		{
			//System.out.println("#### 59");
			StringTokenizer str=new StringTokenizer(saleperson_name,"/");
			errLine="60";
				int dd1=Integer.parseInt(str.nextToken());
				int mm1=Integer.parseInt(str.nextToken());
				int yy1=Integer.parseInt(str.nextToken());
			errLine="64";
			
			
			mm1=mm1-1;
			yy1=yy1-1900;

			if("PartyNext".equals(isNext))
			{
				if(mm1<=11)
				dd1=dd1+1;
			}
			if("PartyPrev".equals(isNext))
			{
				if(mm1>=0)
				dd1=dd1-1;
			}
			if("Edit".equals(isNext))
			{
				dd1=dd1;
			}
			if("PartyFirst".equals(isNext))
			{
				dd1=1;
				mm1=0;
			}
			if("PartyLast".equals(isNext))
			{
				dd1=31;
				mm1=11;
			}
			java.sql.Date D4 = new java.sql.Date(yy1,mm1,dd1);
			saleperson_id[0]="0";
			saleperson_name1[0]=""+format.format(D4);
			//System.out.println("party_name1[0]="+party_name1[0]);
				
		
		}
		else
		{
		cong = C.getConnection();
		errLine = "96";
//System.out.println("location_name="+location_name);
				
		if("PartyNext".equals(isNext))
		{
			query="select top 1 SalesPerson_Id,SalesPerson_Name from Master_SalesPerson where active in(1,0) and company_id="+company_id+" and SalesPerson_name >'"+saleperson_name+"' and purchasesale=0 order by SalesPerson_name"; 
		}
		errLine = "110";
		if("PartyPrev".equals(isNext))
		{
			query="select top 1 SalesPerson_Id,SalesPerson_Name from Master_SalesPerson where active in(1,0)  and company_id="+company_id+" and SalesPerson_name  <'"+saleperson_name+"'and purchasesale=0 order by SalesPerson_name desc";
		}
		errLine = "115";
		if("Edit".equals(isNext))
		{
			query="select SalesPerson_Id,SalesPerson_Name from Master_SalesPerson where active in(1,0)and purchasesale=0 and company_id="+company_id+" and SalesPerson_name like '"+saleperson_name+"'";
		}
		errLine = "120";
		if("PartyFirst".equals(isNext))
		{
			query="select top 1 SalesPerson_Id,SalesPerson_Name from Master_SalesPerson where active in(1,0) and purchasesale=0 and company_id="+company_id+" order by SalesPerson_Name"; 
			//System.out.print("#### query="+query);
		}
		errLine = "126";
		
		if("PartyLast".equals(isNext))
		{//System.out.println("129 *******isLast="+isNext);
			query="select top 1 SalesPerson_Id,SalesPerson_Name from Master_SalesPerson where active in(1,0)and purchasesale=0  and company_id="+company_id+" order by SalesPerson_Name desc";
			//System.out.print("#### query="+query);
		}
		errLine = "131";
		//System.out.println("isNext = "+isNext);
		//System.out.println("query = "+query);
		pstmt_g = cong.prepareStatement(query);
		errLine = "135";
		
		rs_g = pstmt_g.executeQuery();
		int cnt=0;
		while(rs_g.next()) 	
		{
			errLine = "138";
			saleperson_id[cnt]=rs_g.getString("SalesPerson_Id");
			saleperson_name1[cnt]=rs_g.getString("SalesPerson_Name");
	//System.out.println("location_name1[cnt]"+location_name1[cnt]);
			cnt++;
			break;
		}	
		rs_g.close();
		pstmt_g.close();
		//System.out.println("party_id[0]"+party_id[0]);
		//System.out.println("party_name1[0]"+party_name1[0]);

		C.returnConnection(cong);
		} //else
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
    xml.append("<IdList generated=\""+System.currentTimeMillis()+"\">\n");
	//System.out.println("location_name1.length="+location_name1[0]);	
    for (int i=0;i<saleperson_name1.length;i++) {
    
	  String str_saleperson_name=saleperson_name1[i];
	 //replace the ampersand in the code by &amp;
     if(null!=str_saleperson_name)
	 {
	  StringBuffer tempNo = new StringBuffer(str_saleperson_name);
	  if( (str_saleperson_name).indexOf('&') != -1 )
		{
			tempNo = tempNo.replace( (str_saleperson_name).indexOf("&"), ((str_saleperson_name).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);
	 
	 String str_saleperson_id=saleperson_id[i];
	 StringBuffer tempId = new StringBuffer(str_saleperson_id);
	 if( (str_saleperson_id).indexOf('&') != -1 )
	 {
			tempId = tempId.replace( (str_saleperson_id).indexOf("&"), ((str_saleperson_id).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
	 }

	 xml.append("<ReceiveIdNumber>\n");
		 
		  xml.append("<ReceiveId>");
		  xml.append(tempId);
		  xml.append("</ReceiveId>\n");
		  
		  xml.append("<ReceiveNo>");
		  xml.append(tempNo);
		  xml.append("</ReceiveNo>\n");
		  		 
	 
	 xml.append("</ReceiveIdNumber>\n");
    
	 } //if
	}
    
    xml.append("</IdList>\n");
    
	System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
