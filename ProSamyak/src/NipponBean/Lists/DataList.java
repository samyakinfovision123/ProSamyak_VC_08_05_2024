package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class DataList {

   Connect C;
   Connection cong;
   String table_column_name;
   String location_id;
   String due_days;
   public DataList() {
    
	try{
		C = new Connect();
		
	}
	catch(Exception e){
		System.out.println("Exception in LotList() in LotList="+e);
	}
	
  }

  /**
   * gets data from database
   */
  public void getData(String table_name,String column_name,String condition,String company_id) {

	  String errLine = "52";	
	  
	  PreparedStatement pstmt_g=null;
	  ResultSet rs_g=null;
	  try{
		cong = C.getConnection();
		String str_query="Select "+column_name+",due_days from "+table_name+" where "+condition+" and company_id="+company_id;
		//System.out.println("str_query="+str_query);
		pstmt_g = cong.prepareStatement(str_query);
		rs_g = pstmt_g.executeQuery();
		while(rs_g.next())
		{
			table_column_name=rs_g.getString(column_name);
			due_days=rs_g.getString("due_days");
			
		} //while

		str_query="Select Location_id from Master_Location where location_name=(Select SalesPerson_name from Master_SalesPerson where salesPerson_id="+table_column_name+") and company_id="+company_id; 
		//System.out.println("str_query="+str_query);
		pstmt_g = cong.prepareStatement(str_query);
		rs_g = pstmt_g.executeQuery();
		boolean is_salesperson_location=false;
		while(rs_g.next())
		{
			location_id=rs_g.getString("Location_id");
			is_salesperson_location=true;
		} //while
		if(!(is_salesperson_location))
		{
			location_id="-1";
		}
		pstmt_g.close();
		C.returnConnection(cong);
	  } //try
	  catch(Exception e){
		  C.returnConnection(cong);
		    System.out.println("Exception in getData() in DataList after line="+errLine+" : "+e);
	  } //catch
	  
  }


  /**
   * @return XML representation of lots details list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<DBData generated=\""+System.currentTimeMillis()+"\" >\n");

   
	 xml.append("<DBColumn>\n");
		 
		  xml.append("<ColumnName>");
		  xml.append(table_column_name);
		  xml.append("</ColumnName>\n");

		  xml.append("<DueDays>");
		  xml.append(due_days);
		  xml.append("</DueDays>\n");
		  
		  
		  xml.append("<LocationName>");
		  xml.append(location_id);
		  xml.append("</LocationName>\n");

	 xml.append("</DBColumn>\n");
   
    
    xml.append("</DBData>\n");
    //System.out.println("xml="+xml);
	return xml.toString();
    }
    
    
  }

 
