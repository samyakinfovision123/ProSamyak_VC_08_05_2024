package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Pattern;
import java.sql.*;
import NipponBean.*;


public class CreditExcessReport {

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
  PartyOpeningClosing POC;
  NipponBean.Array A;
  str S;
  Inventory I;

  int d;


  /**
   * Creates a new report instance
   */
  public CreditExcessReport() {
    reportlist = new ArrayList();

	try{
		C = new Connect();
		F = new format();
		POC = new PartyOpeningClosing();
		A = new NipponBean.Array();
		S = new str();
		I = new Inventory();
	}
	catch(Exception e)
	  {
		System.out.println("Exception in CreditExcessReport() in OverDueReport="+e);
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
		
		double closingTotal = 0;
		double excessTotal = 0;

		int companyCount=0;
		String query="";

		query = "Select count(*) as companyCount from Master_CompanyParty where company_id="+company_id+" and salesperson_id="+salesperson_id+" and active=1 and super=0";
		
		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();	
	
		while(rs_g.next()) 
		{
			companyCount = rs_g.getInt("companyCount");
		}//while
		rs_g.close();
		pstmt_g.close();

		String partyId[] = new String[companyCount];			
		String partyName[] = new String[companyCount];			
		double credit[] = new double[companyCount];			
		query="Select CompanyParty_Id, CompanyParty_Name, Credit_Limit from Master_CompanyParty where company_id="+company_id+" and salesperson_id="+salesperson_id+" and active=1 and super=0";
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "60";
		int c=0;
		while(rs_g.next()) 	
		{
			partyId[c] = rs_g.getString("CompanyParty_Id");
			partyName[c] = rs_g.getString("CompanyParty_Name");
			credit[c] = rs_g.getDouble("Credit_Limit");
			c++;			
			errLine = "101";
		}
		rs_g.close();
		pstmt_g.close();

		HashMap partySalesClosing = new HashMap();
		String ctaxLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");

		partySalesClosing = POC.getPartySalesClosing(cong, company_id,  partyId, ctaxLedgerId, toDate);

		for(int i=0; i<partyId.length; i++)
		{
			double closingSaleLocal = 0;
			double closingSaleDollar = 0;

			double excess = 0;
	
			//getting the sale
			String partyDrCr = "0#0";
		
			if(partySalesClosing.containsKey(partyId[i]))
			{
				partyDrCr = (String)partySalesClosing.get(partyId[i]);	
			
				StringTokenizer partyLst = new StringTokenizer(partyDrCr,"#");
				closingSaleLocal = Double.parseDouble( (String)partyLst.nextElement());
				closingSaleDollar = Double.parseDouble((String)partyLst.nextElement());
			}
		
			excess = closingSaleLocal - credit[i];

			if(excess > 0)
			{
				closingTotal+=closingSaleLocal;
				excessTotal+=excess;
				
				CreditExcessReportRow tempRow = new CreditExcessReportRow(partyId[i], partyName[i], closingSaleLocal, credit[i], excess);
				reportlist.add(tempRow);
			}

		}

		CreditExcessReportRow tempRow = new CreditExcessReportRow("-", "Total",  closingTotal, 0, excessTotal);
		reportlist.add(tempRow);

		C.returnConnection(cong);
		C.returnConnection(cong1);
	  }
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  C.returnConnection(cong1);
		  System.out.println("Exception in getReportRows() in OverDueReport.java after line="+errLine+" : "+e);
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
      CreditExcessReportRow tempRow = (CreditExcessReportRow)I.next();
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
		  xml.append("<closing>");
			xml.append(S.format3(""+tempRow.getClosing(), d));
		  xml.append("</closing>\n");
		  xml.append("<creditlimit>");
			xml.append(S.format3(""+tempRow.getCreditLimit(), d));
		  xml.append("</creditlimit>\n");
		  xml.append("<excess>");
			xml.append(S.format3(""+tempRow.getExcess(), d));
		  xml.append("</excess>\n");
	  xml.append("</ReportRow>\n");
    }
    
    xml.append("</Report>\n");
    return xml.toString();
  }

  
}
