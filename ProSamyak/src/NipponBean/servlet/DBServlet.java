
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;
import javax.servlet.http.*;

import java.util.Enumeration;

public class DBServlet extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      
    }

	DataList datalist = new DataList();

    String action = req.getParameter("action");
    String table_name = req.getParameter("table_name");
    String column_name = req.getParameter("column_name");
    String condition = req.getParameter("condition");
    String company_id = req.getParameter("company_id");
        
    if ((action != null)) {

      if ("getData".equals(action)) {
		
        datalist.getData(table_name,column_name,condition,company_id);
      } 

	  
    }

    String datalistXml = datalist.toXml();
    res.setContentType("text/xml");
    res.getWriter().write(datalistXml);
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {
    // Bounce to post, for debugging use
    // Hit this servlet directly from the browser to see XML
    doPost(req,res);
  }

}
