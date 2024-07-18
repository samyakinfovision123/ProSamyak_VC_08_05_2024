
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;
import javax.servlet.http.*;

import java.util.Enumeration;

public class GetIdServlet extends HttpServlet
{

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException 
  {
	  Enumeration headers = req.getHeaderNames();
	  while (headers.hasMoreElements())
	  {
		String header  =(String) headers.nextElement();
		//System.out.println(header+": "+req.getHeader(header));
	  }

	//getIdList idlist=null;
	//getIdLedgerList idlegerlist=null;
    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String name = req.getParameter("name");
    String date_value = req.getParameter("date_value");
    String currency= req.getParameter("currency");
    System.out.println("action="+action);
    System.out.println("name="+name);
	
    if ((action != null))
	{
		if ("getsetId".equals(action))
		{
			getIdList idlist= new getIdList();
			idlist.getIdNameFromTable(company_id, name,date_value,currency);
			String lotlistXml = idlist.toXml();
		    res.setContentType("text/xml");
			//System.out.println("lotlistXml="+lotlistXml);
		    res.getWriter().write(lotlistXml);	
		} //if 
		if ("getsetLedgerId".equals(action))
		{
			String party_id=req.getParameter("party_id");
			getLedgerIdList idledgerlist=new getLedgerIdList();
			idledgerlist.getLedgerIdNameFromTable(company_id,party_id);
			String ledgerlistXml = idledgerlist.toXml();
		    res.setContentType("text/xml");
			//System.out.println("lotlistXml="+lotlistXml);
		    res.getWriter().write(ledgerlistXml);	
		} //if
		if ("getsetCashBankLedgerId".equals(action))
		{
			getCashBankLedgerIdList idlist= new getCashBankLedgerIdList();
			idlist.getIdNameFromTable(company_id, name);
			String lotlistXml = idlist.toXml();
		    res.setContentType("text/xml");
			//System.out.println("lotlistXml="+lotlistXml);
		    res.getWriter().write(lotlistXml);	
		} //if 
	} //if
 }

  public void doGet(HttpServletRequest req, HttpServletResponse res) 
	  throws java.io.IOException {
    // Bounce to post, for debugging use
    // Hit this servlet directly from the browser to see XML
    doPost(req,res);
  }

}
