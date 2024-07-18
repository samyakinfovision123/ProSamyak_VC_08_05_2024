package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Pattern;
import java.sql.*;
import NipponBean.*;


public class PerDayCreditExcessReport {

  private ArrayList reportlist;

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
  format F;
  str S;
  Inventory I;
  NipponBean.Array A;

  int d;


  /**
   * Creates a new report instance
   */
  public PerDayCreditExcessReport() {
    reportlist = new ArrayList();

	try{
		C = new Connect();
		F = new format();
		S = new str();
		I = new Inventory();
		A = new NipponBean.Array();
	}
	catch(Exception e)
	  {
		System.out.println("Exception in LotList() in LotList="+e);
	  }
	
  }

  /**
   * gets all the report rows
   */
  public void getReportRows(String salesperson_id, String company_id, java.sql.Date fromDate, java.sql.Date toDate) {

	  String errLine = "47";	

	  try{
		cong = C.getConnection();
		cong1 = C.getConnection();

		String local_currency= I.getLocalCurrency(cong,company_id);
		d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

		double perdaySaleTotal = 0;
		double excessTotal = 0;
		
		String query="";
				
		query="Select MCP.CompanyParty_Id, MCP.CompanyParty_Name, Receive_Date, Sum(Local_Total) as perdaySale, MCP.PerDay_CreditLimit from Receive R, Master_CompanyParty MCP where Receive_Date between ? and ? and R.Company_id="+company_id+" and R.Receive_FromId = MCP.CompanyParty_Id and MCP.Super=0 and MCP.Active=1 and R.Purchase=1 and R.Receive_sell=0 and R.Active=1 and R_Return=0 and R.SalesPerson_Id="+salesperson_id+" group by MCP.CompanyParty_Id, MCP.CompanyParty_Name, Receive_Date, MCP.PerDay_CreditLimit having Sum(Local_Total) > MCP.PerDay_CreditLimit order by Receive_Date, MCP.CompanyParty_Name";
		
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setDate(1, fromDate);
		pstmt_g.setDate(2, toDate);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "60";
		while(rs_g.next()) 	
		{
			String mcpId = rs_g.getString("CompanyParty_Id");
			String mcpName = rs_g.getString("CompanyParty_Name");
			java.sql.Date receiveDate = rs_g.getDate("Receive_Date");
			String saleDate = F.format(receiveDate);
			double perdaySale = rs_g.getDouble("perdaySale");
			double PerDay_CreditLimit = rs_g.getDouble("PerDay_CreditLimit");
			double excess =0;

			if(perdaySale > PerDay_CreditLimit)
			{
				excess = perdaySale - PerDay_CreditLimit;
			}

			perdaySaleTotal+=perdaySale;
			excessTotal+=excess;

			PerDayCreditExcessReportRow tempRow = new PerDayCreditExcessReportRow(mcpId, mcpName, saleDate, perdaySale, PerDay_CreditLimit, excess);
			reportlist.add(tempRow);
			errLine = "101";
		}
		rs_g.close();
		pstmt_g.close();

		PerDayCreditExcessReportRow tempRow = new PerDayCreditExcessReportRow("-", "Total",  "-", perdaySaleTotal, 0, excessTotal);
		reportlist.add(tempRow);

		C.returnConnection(cong);
		C.returnConnection(cong1);
	  }
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  C.returnConnection(cong1);
		  System.out.println("Exception in getReportRows() in PerDayCreditExcessReport.java after line="+errLine+" : "+e);
	  }
  }

	  
  /**
   * @return XML representation of report rows
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<Report generated=\""+System.currentTimeMillis()+"\" >\n");

    for (Iterator I = reportlist.iterator() ; I.hasNext() ; ) {
      PerDayCreditExcessReportRow tempRow = (PerDayCreditExcessReportRow)I.next();
	   //replace the ampersand in the code by &amp;
      String tempName = (tempRow.getPartyName());
	  if( (tempRow.getPartyName()).indexOf('&') != -1 )
		{
			tempName = (tempRow.getPartyName()).replaceAll("&", "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);

	  xml.append("<ReportRow>\n");
		  xml.append("<partyid>");
			xml.append(tempRow.getPartyId());
		  xml.append("</partyid>\n");
		  xml.append("<partyname>");
			xml.append(tempName);
		  xml.append("</partyname>\n");
		   xml.append("<saledate>");
			xml.append(tempRow.getSaleDate());
		  xml.append("</saledate>\n");
		   xml.append("<perdaysale>");
			xml.append(S.format3(""+tempRow.getPerdaySale(), d));
		  xml.append("</perdaysale>\n");
		  xml.append("<perdaycreditlimit>");
			xml.append(S.format3(""+tempRow.getPerdayCreditLimit(), d));
		  xml.append("</perdaycreditlimit>\n");
		  xml.append("<excess>");
			xml.append(S.format3(""+tempRow.getExcess(), d));
		  xml.append("</excess>\n");
	  xml.append("</ReportRow>\n");
    }
    
    xml.append("</Report>\n");
    return xml.toString();
  }

  
}
