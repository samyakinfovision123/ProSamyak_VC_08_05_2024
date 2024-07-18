package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Pattern;
import java.sql.*;
import NipponBean.*;


public class OverDueReport {

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
  public OverDueReport() {
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
		System.out.println("Exception in OverDueReport() in OverDueReport="+e);
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

		double invTotal=0;
		double recTotal=0;
		double balTotal=0;
		
		String query="";
				
		query="(select R.Receive_Id, Receive_No, Receive_FromName, Receive_FromId, Receive_Date, Due_Date, R.Local_Total, Sum(PD.Local_Amount) as paymentReceived, DATEDIFF(dd , Due_Date , ? ) as overdueDays from receive R, payment_details PD where R.company_id="+company_id+" and salesperson_id="+salesperson_id+" and proactive=0 and R.Purchase=1 and R.Receive_sell=0 and R.Active=1 and R_Return=0 and pd.For_HeadId=R.Receive_Id and pd.For_Head=9 and R.Due_Date Between ? and ? and PD.Active=1 group by R.Receive_Id, Receive_No, Receive_FromName, Receive_FromId, Receive_Date, Due_Date, R.Local_Total having (Sum(R.Local_Total)-Sum(PD.Local_Amount)) > 0.005 ) UNION (select R.Receive_Id, Receive_No, Receive_FromName, Receive_FromId, Receive_Date, Due_Date, R.Local_Total, 0, DATEDIFF(dd , Due_Date , ? ) as overdueDays from receive R where R.company_id="+company_id+" and salesperson_id="+salesperson_id+" and proactive=0 and R.Purchase=1 and R.Receive_sell=0 and R.Active=1 and R_Return=0 and R.Due_Date Between ? and ? and R.Receive_Id NOT IN (Select Distinct(For_HeadId) from payment_details where Active=1 and company_id="+company_id+") ) order by Receive_FromName, Receive_Date";
		
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setDate(1, toDate);
		pstmt_g.setDate(2, fromDate);
		pstmt_g.setDate(3, toDate);
		pstmt_g.setDate(4, toDate);
		pstmt_g.setDate(5, fromDate);
		pstmt_g.setDate(6, toDate);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		errLine = "60";
		while(rs_g.next()) 	
		{
			String rId = rs_g.getString("Receive_Id");
			String rNo = rs_g.getString("Receive_No");
			String mcpName = rs_g.getString("Receive_FromName");
			String mcpId = rs_g.getString("Receive_FromId");
			java.sql.Date receiveDate = rs_g.getDate("Receive_Date");
			String rDate = F.format(receiveDate);
			java.sql.Date dueDate = rs_g.getDate("Due_Date");
			String dDate = F.format(dueDate);

			double total = rs_g.getDouble("Local_Total");
			double paymentReceived = rs_g.getDouble("paymentReceived");
			double balance = total - paymentReceived;

			int overdueDays = rs_g.getInt("overdueDays");
			
			invTotal+=total;
			recTotal+=paymentReceived;
			balTotal+=balance;

			OverDueReportRow tempRow = new OverDueReportRow(rId, rNo,  mcpName, mcpId, rDate, dDate, overdueDays, total, paymentReceived, balance);
			reportlist.add(tempRow);
			errLine = "101";
		}
		rs_g.close();
		pstmt_g.close();

		OverDueReportRow tempRow = new OverDueReportRow("-", "Total",  "Total","-", "-", "-", 0, invTotal, recTotal, balTotal);
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
      OverDueReportRow tempRow = (OverDueReportRow)I.next();
	   //replace the ampersand in the code by &amp;
      String tempName = (tempRow.getPartyName());
	  if( (tempRow.getPartyName()).indexOf('&') != -1 )
		{
			tempName = (tempRow.getPartyName()).replaceAll("&", "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);

	  xml.append("<ReportRow>\n");
		  xml.append("<rid>");
			xml.append(tempRow.getReceiveId());
		  xml.append("</rid>\n");
		  xml.append("<rno>");
			xml.append(tempRow.getReceiveNo());
		  xml.append("</rno>\n");
		  xml.append("<partyname>");
			xml.append(tempName);
		  xml.append("</partyname>\n");
		  xml.append("<partyid>");
			xml.append(tempRow.getPartyId());
		  xml.append("</partyid>\n");
		  xml.append("<receivedate>");
			xml.append(tempRow.getReceiveDate());
		  xml.append("</receivedate>\n");
		  xml.append("<duedate>");
			xml.append(tempRow.getDueDate());
		  xml.append("</duedate>\n");
		  xml.append("<overduedays>");
			xml.append(tempRow.getOverdueDays());
		  xml.append("</overduedays>\n");
		  xml.append("<total>");
			xml.append(S.format3(""+tempRow.getTotal(), d));
		  xml.append("</total>\n");
		  xml.append("<received>");
			xml.append(S.format3(""+tempRow.getReceived(), d));
		  xml.append("</received>\n");
		  xml.append("<balance>");
			xml.append(S.format3(""+tempRow.getBalance(), d));
		  xml.append("</balance>\n");
	  xml.append("</ReportRow>\n");
    }
    
    xml.append("</Report>\n");
    return xml.toString();
  }

  
}
