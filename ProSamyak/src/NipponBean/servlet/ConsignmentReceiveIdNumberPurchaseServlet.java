
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;

import javax.servlet.http.*;

import java.util.Enumeration;

public class ConsignmentReceiveIdNumberPurchaseServlet extends HttpServlet {

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	ConsignmentReceiveIdNoListPurchase receiveid_list = new ConsignmentReceiveIdNoListPurchase();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String receive_no = req.getParameter("receive_no");
    String isNext = req.getParameter("isNext");
    
	//System.out.println("action="+action);
    //System.out.println("company_id="+company_id);
    //System.out.println("receive_no="+receive_no);
    //System.out.println("isNext="+isNext);
	
    if ((action != null)) {

      if ("getSubGroupLedger".equals(action)) {
			receiveid_list.getIdNumberPurchase(company_id,receive_no,isNext);
      } 

	  
    }

    String lotlistXml = receiveid_list.toXml();
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
