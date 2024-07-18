
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;
import javax.servlet.http.*;

import java.util.Enumeration;

public class LedgerServlet extends HttpServlet {

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	LedgerList ledgerlist = new LedgerList();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String group_id = req.getParameter("group_id");
    //System.out.println("action="+action);
    //System.out.println("group_id="+group_id);
	
    if ((action != null)) {

      if ("getSubGroupLedger".equals(action)) {
		
		ledgerlist.getLedgerSubgroup(company_id, group_id);
      } 

	  
    }

    String lotlistXml = ledgerlist.toXml();
    res.setContentType("text/xml");
    //System.out.println("lotlistXml="+lotlistXml);
	res.getWriter().write(lotlistXml);
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) 
	  throws java.io.IOException {
    // Bounce to post, for debugging use
    // Hit this servlet directly from the browser to see XML
    doPost(req,res);
  }

}
