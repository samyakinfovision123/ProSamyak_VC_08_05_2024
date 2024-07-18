package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class LotList {

  private ArrayList lotArraylist;
  private int total;
  Connection cong=null;
  Connection cong1=null;
  Connection conp=null;
  ResultSet rs_g=null;
  ResultSet rs_g1=null;
  ResultSet rs_p=null;
  PreparedStatement pstmt_g=null;
  PreparedStatement pstmt_g1=null;
  PreparedStatement pstmt_p=null;

  Connect C;
  rapSearch R;


  /**
   * Creates a new Cart instance
   */
  public LotList() {
    lotArraylist = new ArrayList();
	total=0;
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
  public void getLots(String company_id, String desc, String size, String comparedate) {

	  String errLine = "52";	

	  try{
		cong = C.getConnection();
		cong1 = C.getConnection();
		
		String query="";
		total =0;
		
		query="Select L.Lot_Id, L.Lot_No from Diamond D, Master_Size MS, Master_Description MD, Lot L where L.Lot_Id=D.Lot_Id and L.Company_id="+company_id+" and D.D_Size=MS.Size_Id and MS.Size_Name='"+size+"' and D.Description_Id=MD.Description_Id and MD.Description_Name = '"+desc+"' and L.Active=1 and MS.Active=1 and MD.Active=1";
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "60";
		while(rs_g.next()) 	
		{
			long Lot_Id = rs_g.getLong("Lot_Id");
			String Lot_No = rs_g.getString("Lot_No");
			
			String queryRateQuery="Select ER.Effective_Date, ER.Selling_Price, ER.Purchase_Price from Effective_Rate ER, Lot L where L.Lot_Id=ER.Lot_Id and L.Lot_Id="+Lot_Id+" and L.Active=1 and ER.Active=1 and ER.Company_Id="+company_id+" order by Effective_Date desc ";

			//System.out.println("queryRateQuery="+queryRateQuery);
			//System.out.println("<br>comparedate="+comparedate);

			java.sql.Date invoiceDate = format.getDate(comparedate);

			//System.out.println("invoiceDate = "+invoiceDate);
			double Selling_Price=0;
			double Purchase_Price=0;

			errLine = "80";
			pstmt_g1=cong1.prepareStatement(queryRateQuery);
			rs_g1=pstmt_g1.executeQuery();
			while(rs_g1.next())
			{
				java.sql.Date Effective_Date=rs_g1.getDate("Effective_Date");
					
				if(invoiceDate.equals(Effective_Date) || invoiceDate.after(Effective_Date))
				{
					Selling_Price=rs_g1.getDouble("Selling_Price");
					Purchase_Price=rs_g1.getDouble("Purchase_Price");
					break;
				}//end if
			}//end while
			rs_g1.close();
			pstmt_g1.close();
			errLine = "96";

			Lot tempLot = new Lot(Lot_Id, Lot_No, desc, size, Selling_Price, Purchase_Price);
			lotArraylist.add(tempLot);
			total++;
			errLine = "101";
		}
		rs_g.close();
		pstmt_g.close();


		C.returnConnection(cong);
		C.returnConnection(cong1);
	  }
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  C.returnConnection(cong1);
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	  }
  }

/**
   * gets all the lots
   */
  public void getDescSize(String company_id, String Lot_No, String comparedate) {

	  String errLine = "124";	

	  try{
		cong = C.getConnection();
		cong1 = C.getConnection();
		
		String query="";
		total =0;
		
		query="Select L.Lot_Id, MD.Description_Name, MS.Size_Name from Diamond D, Master_Size MS, Master_Description MD, Lot L where L.Lot_Id=D.Lot_Id and L.Company_id="+company_id+" and D.D_Size=MS.Size_Id and D.Description_Id=MD.Description_Id and L.Lot_No = '"+Lot_No+"' and L.Active=1 and MS.Active=1 and MD.Active=1";
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "138";
		while(rs_g.next()) 	
		{
			long Lot_Id = rs_g.getLong("Lot_Id");
			String desc = rs_g.getString("Description_Name");
			String size = rs_g.getString("Size_Name");
			
			String queryRateQuery="Select ER.Effective_Date, ER.Selling_Price, ER.Purchase_Price from Effective_Rate ER, Lot L where L.Lot_Id=ER.Lot_Id and L.Lot_Id="+Lot_Id+" and L.Active=1 and ER.Active=1 and ER.Company_Id="+company_id+" order by Effective_Date desc ";

			//System.out.println("queryRateQuery="+queryRateQuery);
			//System.out.println("<br>comparedate="+comparedate);

			java.sql.Date invoiceDate = format.getDate(comparedate);

			//System.out.println("invoiceDate = "+invoiceDate);
			double Selling_Price=0;
			double Purchase_Price=0;

			errLine = "156";
			pstmt_g1=cong1.prepareStatement(queryRateQuery);
			rs_g1=pstmt_g1.executeQuery();
			while(rs_g1.next())
			{
				java.sql.Date Effective_Date=rs_g1.getDate("Effective_Date");
					
				if(invoiceDate.equals(Effective_Date) || invoiceDate.after(Effective_Date))
				{
					Selling_Price=rs_g1.getDouble("Selling_Price");
					Purchase_Price=rs_g1.getDouble("Purchase_Price");
					break;
				}//end if
			}//end while
			rs_g1.close();
			pstmt_g1.close();
			errLine = "172";

			Lot tempLot = new Lot(Lot_Id, Lot_No, desc, size, Selling_Price, Purchase_Price);
			lotArraylist.add(tempLot);
			total++;
			errLine = "177";
		}
		rs_g.close();
		pstmt_g.close();


		C.returnConnection(cong);
		C.returnConnection(cong1);
	  }
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  C.returnConnection(cong1);
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	  }
  }
	  
  /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<LotList generated=\""+System.currentTimeMillis()+"\" total=\""+getTotal()+"\">\n");

    for (Iterator I = lotArraylist.iterator() ; I.hasNext() ; ) {
      Lot tempLot = (Lot)I.next();
	   //replace the ampersand in the code by &amp;
      StringBuffer tempName = new StringBuffer(tempLot.getLotNo());
	  if( (tempLot.getLotNo()).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (tempLot.getLotNo()).indexOf("&"), ((tempLot.getLotNo()).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);

	  StringBuffer tempDesc = new StringBuffer(tempLot.getDescription());
	  if( (tempLot.getDescription()).indexOf('&') != -1 )
		{
			tempDesc = tempDesc.replace( (tempLot.getDescription()).indexOf("&"), ((tempLot.getDescription()).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempDesc);
		}

	  StringBuffer tempSize = new StringBuffer(tempLot.getSize());
	  if( (tempLot.getSize()).indexOf('&') != -1 )
		{
			tempSize = tempSize.replace( (tempLot.getSize()).indexOf("&"), ((tempLot.getSize()).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempSize);
		}

      xml.append("<Lot>\n");
		  xml.append("<lotid>");
			xml.append(tempLot.getLotId());
		  xml.append("</lotid>\n");
		  xml.append("<lotno>");
			xml.append(tempName);
		  xml.append("</lotno>\n");
		   xml.append("<description>");
			xml.append(tempDesc);
		  xml.append("</description>\n");
		   xml.append("<size>");
			xml.append(tempSize);
		  xml.append("</size>\n");
		  xml.append("<salerate>");
			xml.append(tempLot.getSaleRate());
		  xml.append("</salerate>\n");
		  xml.append("<purchaserate>");
			xml.append(tempLot.getPurchaseRate());
		  xml.append("</purchaserate>\n");
	  xml.append("</Lot>\n");
    }
    
    xml.append("</LotList>\n");
    return xml.toString();
  }

  private int getTotal() {
    return total;
  }
}
