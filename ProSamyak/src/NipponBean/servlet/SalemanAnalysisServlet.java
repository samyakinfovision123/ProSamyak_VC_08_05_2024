
package NipponBean.servlet;

import NipponBean.*;
import NipponBean.Lists.*;

import javax.servlet.http.*;

import java.util.Enumeration;

public class SalemanAnalysisServlet extends HttpServlet {

  /**
   * get the reports and output them
   */
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws java.io.IOException {

    Enumeration headers = req.getHeaderNames();
    while (headers.hasMoreElements()) {
      String header  =(String) headers.nextElement();
      //System.out.println(header+": "+req.getHeader(header));
    }

	
    String action = req.getParameter("action");    
	//System.out.println("action="+action);

    if ((action != null)) {

      if ("PerDayCreditExcess".equals(action)) {
		  PerDayCreditExcessReport report = new PerDayCreditExcessReport();

		  String salesperson_id = req.getParameter("salesperson_id");
		  String company_id = req.getParameter("company_id");
  		  int dd1=Integer.parseInt(req.getParameter("dd1"));
		  int mm1=Integer.parseInt(req.getParameter("mm1"));
		  int yy1=Integer.parseInt(req.getParameter("yy1"));
		  int dd2=Integer.parseInt(req.getParameter("dd2"));
		  int mm2=Integer.parseInt(req.getParameter("mm2"));
		  int yy2=Integer.parseInt(req.getParameter("yy2"));

		  java.sql.Date fromDate = new java.sql.Date((yy1-1900),(mm1-1),dd1);
		  java.sql.Date toDate = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	
		  report.getReportRows(salesperson_id, company_id, fromDate, toDate);
			

		  String reportXml = report.toXml();
		  res.setContentType("text/xml");
		  //System.out.println("lotlistXml="+lotlistXml);
		  res.getWriter().write(reportXml);
		
	  } 

	  if ("OverDueReport".equals(action)) {
		  OverDueReport report = new OverDueReport();

		  String salesperson_id = req.getParameter("salesperson_id");
		  String company_id = req.getParameter("company_id");
  		  int dd1=Integer.parseInt(req.getParameter("dd1"));
		  int mm1=Integer.parseInt(req.getParameter("mm1"));
		  int yy1=Integer.parseInt(req.getParameter("yy1"));
		  int dd2=Integer.parseInt(req.getParameter("dd2"));
		  int mm2=Integer.parseInt(req.getParameter("mm2"));
		  int yy2=Integer.parseInt(req.getParameter("yy2"));

		  java.sql.Date fromDate = new java.sql.Date((yy1-1900),(mm1-1),dd1);
		  java.sql.Date toDate = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	
		  report.getReportRows(salesperson_id, company_id, fromDate, toDate);
			

		  String reportXml = report.toXml();
		  res.setContentType("text/xml");
		  //System.out.println("lotlistXml="+lotlistXml);
		  res.getWriter().write(reportXml);
		
	  } 


	  if ("CreditExcess".equals(action)) {
		  CreditExcessReport report = new CreditExcessReport();

		  String salesperson_id = req.getParameter("salesperson_id");
		  String company_id = req.getParameter("company_id");
  		  int dd1=Integer.parseInt(req.getParameter("dd1"));
		  int mm1=Integer.parseInt(req.getParameter("mm1"));
		  int yy1=Integer.parseInt(req.getParameter("yy1"));
		  int dd2=Integer.parseInt(req.getParameter("dd2"));
		  int mm2=Integer.parseInt(req.getParameter("mm2"));
		  int yy2=Integer.parseInt(req.getParameter("yy2"));

		  java.sql.Date fromDate = new java.sql.Date((yy1-1900),(mm1-1),dd1);
		  java.sql.Date toDate = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	
		  report.getReportRows(salesperson_id, company_id, fromDate, toDate);
			

		  String reportXml = report.toXml();
		  res.setContentType("text/xml");
		  //System.out.println("lotlistXml="+lotlistXml);
		  res.getWriter().write(reportXml);
		
	  } 
    }

   
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) 
	  throws java.io.IOException {
    // Bounce to post, for debugging use
    // Hit this servlet directly from the browser to see XML
    doPost(req,res);
  }

}
