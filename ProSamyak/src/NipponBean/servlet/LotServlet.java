
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;
import javax.servlet.http.*;

import java.util.Enumeration;

public class LotServlet extends HttpServlet {

  /**
   * Updates Cart, and outputs XML representation of contents
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	LotList lotlist = new LotList();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String comparedate = req.getParameter("comparedate");
        
    if ((action != null)) {

      if ("getLots".equals(action)) {
		String desc = req.getParameter("desc");
		String size = req.getParameter("size");
        lotlist.getLots(company_id, desc, size, comparedate);
      } 

	  if("getDescSize".equals(action)){
		String lotno = req.getParameter("lotno");
        lotlist.getDescSize(company_id, lotno, comparedate);
	  }
    }

    String lotlistXml = lotlist.toXml();
    res.setContentType("text/xml");
    res.getWriter().write(lotlistXml);
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {
    // Bounce to post, for debugging use
    // Hit this servlet directly from the browser to see XML
    doPost(req,res);
  }

}
