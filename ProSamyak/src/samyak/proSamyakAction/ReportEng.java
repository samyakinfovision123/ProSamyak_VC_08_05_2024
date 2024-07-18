package samyak.proSamyakAction;
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        report created
* * 2		Anil			23-04-2011	Done		To Access on Server
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import NipponBean.Connect;
import java.sql.Date;
import samyak.utils.OldMethodOveride;
import service.ParentAction;

public class ReportEng  extends ParentAction
{

	@Override
	public String perform(HttpServletRequest req, HttpServletResponse res) {
		// TODO Auto-generated method stub
		HttpSession session =null;
		String EngineerId = req.getParameter("masterEngineerTable");
		String yearmonth = req.getParameter("yearmonth");
		
		String command =req.getParameter("command");
		try
		{
			
			
			session =req.getSession(false);
			String usernameid =String.valueOf(session.getValue("user_id"));
		
			if ("Report".equalsIgnoreCase(command))
		    {
			req.setAttribute("EngId", EngineerId);
			req.setAttribute("yearmonth", yearmonth);
			req.setAttribute("usernameid", usernameid);	
			System.out.println("  eng Id "+EngineerId);
			System.out.println(" usernameid  "+usernameid);
		    return "ReportInOut-View" ;		
		  }
			
		}catch (Exception e) 
		{
			
			e.printStackTrace() ;
			e.getMessage() ;
			return "error-page" ;
		}
		
		return "Report-View";
	}

}
