
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;

import javax.servlet.http.*;

import java.util.Enumeration;

public class PurchasePersonServlet extends HttpServlet {

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	PurchasePersonList purchaseperson_list = new PurchasePersonList();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String purchaseperson_name = req.getParameter("PurchasePerson_name");
    String isNext = req.getParameter("isNext");
    
	//System.out.println("action="+action);
    //System.out.println("company_id="+company_id);
   // System.out.println("party_name="+party_name);
    //System.out.println("isNext="+isNext);
	
    if ((action != null)) {

      if ("getSubGroupLedger".equals(action)) {
		
		
	//System.out.println("location_name Nil="+location_name);
	purchaseperson_list.getPurchasePersonIdName(company_id,purchaseperson_name,isNext);
      } 

	  
    }

    String lotlistXml = purchaseperson_list.toXml();
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
