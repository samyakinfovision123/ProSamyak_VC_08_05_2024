package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class ConsignmentConfirmReceiveIdNoListPurchase {

  
  
  Connection cong=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  
  String receive_id[]=new String[1];
  String receive_no1[]=new String[1];
  String receive_lots[]=new String[1];
  java.sql.Date receive_Date = new java.sql.Date(System.currentTimeMillis());

  Connect C;
  
  /**
   * Creates a new Cart instance
   */
  public ConsignmentConfirmReceiveIdNoListPurchase() {
    
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
  public void getIdNumberPurchase(String company_id,String receive_no,String isNext) {

	  String errLine = "52";	
	  
	  
	  try{
		
		//System.out.println("<br>54 receive_no="+receive_no);
		boolean isNoDate=receive_no.contains("-");
		String query="";
		if(!(isNoDate))
		{
			//System.out.println("58 Under If");
			StringTokenizer str=new StringTokenizer(receive_no,"/");
			errLine="60";
				int dd1=Integer.parseInt(str.nextToken());
				int mm1=Integer.parseInt(str.nextToken());
				int yy1=Integer.parseInt(str.nextToken());
			errLine="64";
			java.sql.Date InputDate = new java.sql.Date((yy1-1900),(mm1-1),dd1);
			
			//mm1=mm1-1;
			//yy1=yy1-1900;
            cong = C.getConnection();
			if("PurchaseNext".equals(isNext))
			{
				
				query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and company_id="+company_id+" and receive_date > '"+InputDate+"' order by receive_date";
			}
			if("PurchasePrev".equals(isNext))
			{
				query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and company_id="+company_id+" and  receive_date < '"+InputDate+"' order by receive_date desc";
				
			}
			if("Edit".equals(isNext))
			{
				//dd1=dd1;
				query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and  company_id="+company_id+" and receive_date = '"+InputDate+"' order by receive_date";
					
			}
			if("PurchaseFirst".equals(isNext))
			{
				query="Select top 1 receive_id, receive_no, receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and company_id="+company_id+" order by receive_date";

			}
			if("PurchaseLast".equals(isNext))
			{
				query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and company_id="+company_id+"  order by receive_date desc ";


				
			}

			pstmt_g = cong.prepareStatement(query);
			//System.out.println("<br>102 query = "+query);
			rs_g = pstmt_g.executeQuery();
			int cnt=0;
			while(rs_g.next()) 	
			{
				receive_id[cnt]=rs_g.getString("receive_id");
				receive_Date=rs_g.getDate("receive_date");
				receive_lots[cnt]=rs_g.getString("receive_lots");	//receive_no1[cnt]=format.format(receive_no1[cnt]);
				//System.out.println("<br>110 receive_id"+receive_id[cnt]);
				cnt++;
				break;
				
			}	
			rs_g.close();
			pstmt_g.close();
			//System.out.println("receive_id[0]"+receive_id[0]);
			//System.out.println("receive_no1[0]"+receive_no1[0]);
			//java.sql.Date D4 = new java.sql.Date(yy1,mm1,dd1);
			//receive_id[0]="0";
			receive_no1[0]=""+format.format(receive_Date);
			if(null==receive_id[0])
			{
				receive_id[0]="0";	
				receive_no1[0]=""+format.format(InputDate);
				receive_lots[0]="0";
			}
			//System.out.println("124 receive_no1[0]="+receive_no1[0]);
			//System.out.println("receive_id[0]"+receive_id[0]);
			//System.out.println("receive_no1[0]"+receive_no1[0]);
			//System.out.println("receive_no1[0]"+receive_lots[0]);

			C.returnConnection(cong);	
		
		}
		else
		{
			//System.out.println("133 Under else");
		cong = C.getConnection();
		errLine = "96";
		if("PurchaseNext".equals(isNext))
		{
			query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0  and receive_id >( select  Receive_id from Receive  where company_id="+company_id+" and Active =1  and Active=1 and receive_Id=Receive_Id and company_id="+company_id+" and receive_no like '"+receive_no+"') order by receive_id";
		}
		if("PurchasePrev".equals(isNext))
		{
			query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and receive_id <( select receive_id from Receive where company_id="+company_id+" and receive_no like '"+receive_no+"') order by receive_id desc";

			//System.out.println("receive_no"+receive_no);
		}
		if("Edit".equals(isNext))
		{
			
			query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0 and receive_id =( select receive_id from Receive where company_id="+company_id+" and receive_no like '"+receive_no+"') order by receive_id ";

			
		}
		if("PurchaseFirst".equals(isNext))
		{
			
			query="Select top 1  receive_id,receive_no ,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0  order by receive_date";
		}
		if("PurchaseLast".equals(isNext))
		{
			
			query="select receive_id,receive_no,receive_date,receive_lots from Receive where company_id="+company_id+" and receive_sell=1 and purchase=1 and stocktransfer_type=0 and active=1 and R_Return=0 and Opening_Stock=0 and consignment_receiveid > 0  order by R.receive_id desc";


		}
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		int cnt=0;
		while(rs_g.next()) 	
		{
			receive_id[cnt]=rs_g.getString("receive_id");
			receive_no1[cnt]=rs_g.getString("receive_no");
			receive_Date=rs_g.getDate("receive_date");
			receive_lots[cnt]=rs_g.getString("receive_lots");
			//System.out.println("receive_id"+receive_id[cnt]);
			cnt++;
			break;

		}	
		rs_g.close();
		pstmt_g.close();
		System.out.println("receive_id[0]"+receive_id[0]);
		System.out.println("receive_no1[0]"+receive_no1[0]);
	System.out.println("isNext"+isNext);
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
	//System.out.println("receive_no1.length="+receive_no1[0]);	
    for (int i=0;i<receive_no1.length;i++) {
    
	  String str_receive_no=receive_no1[i];
	 //replace the ampersand in the code by &amp;
     if(null!=str_receive_no)
	 {
	  StringBuffer tempNo = new StringBuffer(str_receive_no);
	  if( (str_receive_no).indexOf('&') != -1 )
		{
			tempNo = tempNo.replace( (str_receive_no).indexOf("&"), ((str_receive_no).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	 // System.out.println("tempNo"+tempNo);
	 
	 String str_receive_id=receive_id[i];
	 StringBuffer tempId = new StringBuffer(str_receive_id);
	 if( (str_receive_id).indexOf('&') != -1 )
	 {
			tempId = tempId.replace( (str_receive_id).indexOf("&"), ((str_receive_id).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
	 }
// System.out.println("tempId"+tempId);
String str_receive_date=format.format(receive_Date);
 StringBuffer tempdate = new StringBuffer(str_receive_date);
	if( (str_receive_date).indexOf('&') != -1 )
	 {
			tempdate = tempdate.replace( (str_receive_date).indexOf("&"), ((str_receive_date).indexOf("&"))+1, "&amp;");
	 }
 //System.out.println("tempdate"+tempdate);
 String str_receive_lots=receive_lots[i];
	 StringBuffer templots = new StringBuffer(str_receive_lots);
	 if( (str_receive_id).indexOf('&') != -1 )
	 {
			templots = templots.replace( (str_receive_lots).indexOf("&"), ((str_receive_lots).indexOf("&"))+1, "&amp;");
			
	 } 
	//System.out.println("237 templots"+templots);
	//System.out.println("238  templots"+templots);
	 xml.append("<ReceiveIdNumber>\n");
		 
		  xml.append("<ReceiveId>");
		  xml.append(tempId);
		  xml.append("</ReceiveId>\n");
		  
		  xml.append("<ReceiveNo>");
		  xml.append(tempNo);
		  xml.append("</ReceiveNo>\n");
		  		 
		  xml.append("<ReceiveDate>");
		  xml.append(tempdate);
		  xml.append("</ReceiveDate>\n");

		  xml.append("<ReceiveLots>");
		  xml.append(templots);
		  xml.append("</ReceiveLots>\n");

		  xml.append("</ReceiveIdNumber>\n");
    
	 } //if
	}
    
    xml.append("</IdList>\n");
    
	//System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
