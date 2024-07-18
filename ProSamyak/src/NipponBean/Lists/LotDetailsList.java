package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class LotDetailsList {

   Connect C;
   Connection cong;
   String lot_id;	
   LotHistoryBean lotbean;
   
   YearEndStock yes;
   java.sql.Date from_date;
   java.sql.Date to_date;
   double financial_closingQty;
   double physical_closingQty;
   
   public LotDetailsList() {
    
	try{
		C = new Connect();
		lotbean=new LotHistoryBean();
		yes=new YearEndStock();
		
		from_date=new java.sql.Date(System.currentTimeMillis());
		to_date=new java.sql.Date(System.currentTimeMillis());
	}
	catch(Exception e){
		System.out.println("Exception in LotList() in LotList="+e);
	}
	
  }

  /**
   * gets all the lots
   */
  public void getLots(String lot_no,String company_id,String yearend_id) {

	  String errLine = "52";	
	  PreparedStatement pstmt_g=null;
	  ResultSet rs_g=null;
	  try{
		cong = C.getConnection();
		String query="Select Lot_Id from Lot where Lot_No=? and company_id=?";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,lot_no);
		pstmt_g.setString(2,company_id);
		//System.out.println("query="+query);
		
		rs_g  = pstmt_g.executeQuery();
	
		while(rs_g.next())
		{
			lot_id=rs_g.getString("Lot_Id");
		}
		pstmt_g.close();
		
	    query="Select From_date,To_date from YearEnd where yearend_id=?";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,yearend_id);
		//System.out.println("query="+query);
		//System.out.println("yearend_id="+yearend_id);
		rs_g  = pstmt_g.executeQuery();
		errLine = "67";
		while(rs_g.next())
		{
			errLine = "70";
			from_date=rs_g.getDate("From_date");
			to_date=rs_g.getDate("To_date");
		}
		pstmt_g.close();

		errLine = "78";
		
		HashMap lot_details=lotbean.getSalePurchaseMixInOut(cong,lot_id,from_date,to_date,company_id,yearend_id);

		//System.out.println("lot_details.size"+lot_details.size());
		LotHistoryRow purchase=(LotHistoryRow)lot_details.get("Purchase");
		LotHistoryRow mixed_in=(LotHistoryRow)lot_details.get("Mix In");
		LotHistoryRow sale=(LotHistoryRow)lot_details.get("Sale");
		LotHistoryRow mixed_out=(LotHistoryRow)lot_details.get("Mix Out");
		
		LotHistoryRow consignment_purchase=(LotHistoryRow)lot_details.get("Consignment Purchase");
		LotHistoryRow consignment_sale=(LotHistoryRow)lot_details.get("Consignment Sale");
		
		//System.out.println("purchase.getQty()="+purchase.getQty());
	    //System.out.println("mixed_in.getQty()="+mixed_in.getQty());
	    //System.out.println("sale.getQty()="+sale.getQty());
	   // System.out.println("mixed_out.getQty()="+mixed_out.getQty());
	   // System.out.println("consignment_purchase.getQty()="+consignment_purchase.getQty());
	   // System.out.println("consignment_sale.getQty()="+consignment_sale.getQty());
		
		
		from_date.setDate((from_date.getDate()-1));
		
		java.sql.Date current_date=new java.sql.Date(System.currentTimeMillis());
		current_date.setTime((current_date.getTime()+24*60*60*1000));
		//System.out.println("current_date="+current_date);
		
		String status=yes.stockStatus(cong,current_date,company_id,lot_id,yearend_id); 

		//System.out.println("status="+status);
		
		StringTokenizer Lst = new StringTokenizer(status,"/");
		double op_stk =Double.parseDouble( (String)Lst.nextElement());
		double loc_rate =Double.parseDouble( (String)Lst.nextElement());
		double dol_rate =Double.parseDouble( (String)Lst.nextElement());	
	  
	    
		
		String status1 =yes.physicalStockStatus(cong,current_date,company_id,lot_id,yearend_id);
		Lst = new StringTokenizer(status1,"/");
		double op_phystk =Double.parseDouble((String)Lst.nextElement());
		double loc_phyrate =Double.parseDouble( (String)Lst.nextElement());
		double dol_phyrate =Double.parseDouble( (String)Lst.nextElement());
		
		// System.out.println("117 status1="+status1);
		financial_closingQty=op_stk;
		C.returnConnection(cong);
		financial_closingQty=Double.parseDouble(str.format(""+financial_closingQty,3));
	
		physical_closingQty=op_phystk+op_stk;
		physical_closingQty=Double.parseDouble(str.format(""+physical_closingQty,3));
	  }
	  catch(Exception e){
		  C.returnConnection(cong);
		  
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	  }
  }


  /**
   * @return XML representation of lots details list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<LotDetailsList generated=\""+System.currentTimeMillis()+"\" >\n");

   //String str_group_name=""+closingQty;
	  
	  //System.out.println("str_group_name="+str_group_name);
	   
	   //replace the ampersand in the code by &amp;
     // StringBuffer tempName = new StringBuffer(str_group_name);
	  /*if( (str_group_name).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (str_group_name).indexOf("&"), ((str_group_name).indexOf("&"))+1, "&amp;");
		}
	

	 String str_group_id=g_id;
	 StringBuffer tempNo = new StringBuffer(g_id);
	 if( (str_group_id).indexOf('&') != -1 )
	 {
			tempNo = tempNo.replace( (str_group_id).indexOf("&"), ((str_group_id).indexOf("&"))+1, "&amp;");
	 }*/

	 xml.append("<Qty>\n");
		 
		  xml.append("<FinancialQty>");
		  xml.append(financial_closingQty);
		  xml.append("</FinancialQty>\n");

		  xml.append("<PhysicalQty>");
		  xml.append(physical_closingQty);
		  xml.append("</PhysicalQty>\n");
		  
		  
	 
	 xml.append("</Qty>\n");
   
    
    xml.append("</LotDetailsList>\n");
    //System.out.println("xml="+xml);
	return xml.toString();
    }
    
    
  }

 
