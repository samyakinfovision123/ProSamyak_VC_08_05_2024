
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;

import javax.servlet.http.*;

import java.util.Enumeration;

public class SalePurchaseGroupPersonServlet extends HttpServlet {

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	SalePurchaseGroupPersonList salepurchasegroupperson_list = new SalePurchaseGroupPersonList();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String groupsalepurchaseperson_type = req.getParameter("groupsalepurchaseperson_type");
    String purchasesalegroup_name = req.getParameter("PurchaseSaleGroup_name");
    String isNext = req.getParameter("isNext");
    
	//System.out.println("action="+action);
    //System.out.println("company_id="+company_id);
   // System.out.println("party_name="+party_name);
    //System.out.println("isNext="+isNext);
	
    if ((action != null)) {

      if ("getSubGroupLedger".equals(action)) {
		
		
	//System.out.println("location_name Nil="+location_name);
	salepurchasegroupperson_list.getSalePurchaseGroupPersonIdName(company_id,groupsalepurchaseperson_type,purchasesalegroup_name,isNext);
      } 

	  
    }

    String lotlistXml = salepurchasegroupperson_list.toXml();
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
