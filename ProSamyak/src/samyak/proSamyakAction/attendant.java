package samyak.proSamyakAction;
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-o4-2011  Done        some change 
* 3    Mr Ganesh 		27-04-2011  Done       add coloum
* 4		Anil			26-04-2011  done        TL 2 Version Control
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.sql.Connection;
import java.sql.Timestamp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import NipponBean.Connect;
import NipponBean.login;

import samyak.database.attendantDb;
import service.ParentAction;

public class attendant  extends ParentAction
{

	@Override
	public String perform(HttpServletRequest req, HttpServletResponse res) 
	{
		HttpSession session = req.getSession(false);
		//System.out.println("action come ");
		Connection cong = null;
		Connect C = new Connect();
		login L = new login() ;
		
		int err=43;
		String time =req.getParameter("time");
		String user =req.getParameter("user");
		
		String remark = req.getParameter("remark");
		System.out.println("remark ="+remark);
		samyak.beans.attendant Objattendant = new samyak.beans.attendant () ;
		err=46;
		try {
			cong = C.getConnection();
			long attendantId= L.get_master_id(cong,"Attendance");
			attendantDb attendantDbObj = new attendantDb ();
			Objattendant.setAttendantId(attendantId);
			Objattendant.setEngineerId(Long.parseLong(user));
			Objattendant.setTime(Timestamp.valueOf(time));
			Objattendant.setActive(true);
			Objattendant.setRemark(remark);
			
			int returnVal =attendantDbObj.insertAttendantDb(cong, Objattendant);
			String setAttri = " <font color=red> Data is succefuly Save for </font>" ;
			req.setAttribute("Save", setAttri);
			
		}catch (Exception e) 
		{
		
			System.out.println(e);
			 return "error-page";
			 
		}finally{
			C.returnConnection(cong);
		}
		
		return "attendant-View";
	}

}
