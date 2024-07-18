
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;
import javax.servlet.http.*;

import java.util.Enumeration;

public class LotDetailsServlet extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      
    }

	LotDetailsList lotlist = new LotDetailsList();

    String action = req.getParameter("action");
    String company_id = req.getParameter("company_id");
    String yearend_id = req.getParameter("yearend_id");
    String lot_no = req.getParameter("lot_no");
        
    if ((action != null)) {

      if ("getLotDetails".equals(action)) {
		
        lotlist.getLots(lot_no,company_id,yearend_id);
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
