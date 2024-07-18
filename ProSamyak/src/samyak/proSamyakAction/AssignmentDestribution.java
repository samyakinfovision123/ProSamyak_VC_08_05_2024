/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
package samyak.proSamyakAction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.StringTokenizer;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.ParentAction;
import NipponBean.Connect;
import NipponBean.login;
import samyak.beans.EngineerAssignmentDestributionBean;
import samyak.database.EngineerAssignmentDestributionDb;
import samyak.utils.OldMethodOveride;
import samyak.utils.Utility;
public class AssignmentDestribution extends ParentAction
{

	@Override
	public String perform(HttpServletRequest req, HttpServletResponse res)
	{
		// TODO Auto-generated method stub
		Timestamp T = new Timestamp(System.currentTimeMillis());
		System.out.println(" AssignmentDestribution.java loging In at "+T);
		String command = req.getParameter("command");
		
		Connection conp=null;
		Connection cong=null;
		ResultSet rsg=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmtg=null;
		login L = new login ();
		HttpSession session ;
		Connect C = new Connect();
		OldMethodOveride condition = new OldMethodOveride();
		EngineerAssignmentDestributionDb insertAttendantDbObj = new EngineerAssignmentDestributionDb ();
		EngineerAssignmentDestributionBean insertAttendantBeanObj = new EngineerAssignmentDestributionBean(); 
		Utility utility = new Utility();
		if("Save".equals(command))
		{
			
				try 
				{
				conp=C.getConnection();
				cong=C.getConnection();
				
			 	session = req.getSession(false);
			 	String date11 = req.getParameter("StartedOn");
				StringTokenizer st1=new StringTokenizer(date11,"/");
				int d22 = Integer.parseInt(st1.nextToken());
				int m22 = Integer.parseInt(st1.nextToken());
				int y22 = Integer.parseInt(st1.nextToken());
				java.sql.Date StartedOn =new java.sql.Date((y22-1900),m22-1,d22);
				
				String date12 = req.getParameter("targetOn");
				StringTokenizer st2=new StringTokenizer(date12,"/");
				int d11 = Integer.parseInt(st2.nextToken());
				int m11 = Integer.parseInt(st2.nextToken());
				int y11 = Integer.parseInt(st2.nextToken());
				java.sql.Date targetOn =new java.sql.Date((y11-1900),m11-1,d11);
				
				String ename="";
				String pname="";
					
				String projectname = req.getParameter("projectname");
				String engineername = req.getParameter("engineername");
				String AssignmentName=req.getParameter("AssignmentName");
				String AssignmentByEngineername =req.getParameter("AssignmentByEngineername");
				String description=req.getParameter("description");
				String typename = req.getParameter("atype");
				String priorityname = req.getParameter("priorityname");
				String statusname=req.getParameter("statusname");
		        String assignmentId=String.valueOf(L.get_master_id(cong,"EngineerAssignmentDestribution"));
		        String machinename = req.getRemoteHost();
				long userid	=  Long.parseLong(""+session.getValue("user_id"));
				Timestamp currentTime  = new Timestamp(System.currentTimeMillis());
				long projectId=condition.getNameConditionCriteri(conp, "masterProject", "projectId", " where Active=1 and projectName ='"+projectname+"'");
				long EngineerId =condition.getNameConditionCriteri(conp, "masterEngineer", "engineerId", " where Active=1 and engineerName like '"+engineername+"'");
				long AssignmentByEngineernameId =condition.getNameConditionCriteri(conp, "masterEngineer", "engineerId", " where Active=1 and engineerName like '"+AssignmentByEngineername+"'");
				//long prioritynameId=condition.getNameConditionCriteri(conp, "masterPriority", "priorityId", " where Active=1 and priorityName like '"+priorityname+"'");
				//long typenameId =condition.getNameConditionCriteri(conp, "masterType", "typeId", " where Active=1 and typeName like '"+typename+"'"); 
				
				System.out.println();
				System.out.println(" name id "+projectId);
				System.out.println("name  "+projectname);
				
				if(projectId==0)
				{
					return "AssignmentDestributionSecond-View" ;
				}
				if(EngineerId==0)
				{
					return "AssignmentDestributionSecond-View" ;
				
				}
				insertAttendantBeanObj.setAssignmentId(Long.parseLong(assignmentId));
		        insertAttendantBeanObj.setAssignmentName(AssignmentName);
		        insertAttendantBeanObj.setAssignmentDescription(description);
		        
		        insertAttendantBeanObj.setProjectId(projectId);
		        insertAttendantBeanObj.setEngineerId(EngineerId);
		        insertAttendantBeanObj.setStartedOn(utility.getTimestamp(date11));
		        
		        insertAttendantBeanObj.setTargetOn(utility.getTimestamp(date12));
		        insertAttendantBeanObj.setCompleteOn(utility.getTimestamp(date12));
		        insertAttendantBeanObj.setStatusId(0);
		        
		        insertAttendantBeanObj.setAnalysisId(0);
		        insertAttendantBeanObj.setCodingId(0);		        
		        insertAttendantBeanObj.setDeploymentId(0);
		      
		        insertAttendantBeanObj.setTypeId(Long.parseLong(typename));
		        insertAttendantBeanObj.setPriorityId(Long.parseLong(priorityname));
		        insertAttendantBeanObj.setModifiendOn(currentTime);
		        
		        insertAttendantBeanObj.setModifiedBy(String.valueOf(userid));
		        insertAttendantBeanObj.setModifiedMachineName(machinename);
		        insertAttendantBeanObj.setActive(true);
		        
		        insertAttendantBeanObj.setReferenceAssignmentID(0);
		        insertAttendantBeanObj.setAssignByEngId(AssignmentByEngineernameId);
		        insertAttendantBeanObj.setTransactionType(0);
		        
		        insertAttendantDbObj.insertEngineerAssignmentDestribution(conp, insertAttendantBeanObj);
		        String message= "command=Default&message= <b><font size=4 color='#FF661C'> Record Added Successfully</font></b>." ;
				req.setAttribute("message", message);	
				
			  }
				catch (Exception e) 
				{
					// TODO: handle exception
					e.printStackTrace();
					return "error-page";
				}
				finally
				{
					C.returnConnection(cong);
					C.returnConnection(conp);
				}
	 
		}// Save Command
		

		
		System.out.println(" AssignmentDestribution.java loging Out at "+T);
		return "AssignmentDestribution-View";
	}
	
	

}
