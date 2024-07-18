package samyak.database;
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2		Anil			23-04-2011	Done		To Access on Server

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import samyak.beans.EngineerAssignmentDestributionBean;
import samyak.beans.masterEngineerBean;
import samyak.beans.notPersistenBean;

public class EngineerAssignmentDestributionDb 
{

	public  EngineerAssignmentDestributionDb()
	{
		
	}
	
	public int insertEngineerAssignmentDestribution(Connection conp , EngineerAssignmentDestributionBean obj )throws Exception
	{
		int returbval =0;
		PreparedStatement  pstmt_p=null;
		
		String Query ="Insert into EngineerAssignmentDestribution " +
						"( assignmentId  ,assignmentName,         assignmentDescription," +
						"  projectId,    engineerId ,             startedOn, " +
						" targetOn,      completeOn,               statusId,"  +
						
						"analysisId,     codingId,                 testingId ," +
						"deploymentId,    typeId ,                  priorityId ," +
						"modifiendOn ,    modifiedBy ,             modifiedMachineName ,"+
						
						" active,         referenceAssignmentID,    assignByEngId," +
						"transactionType )"+
						"values (?,?,?,?,  ?,?,?,?,  ?,?,?,?,  ?,?,?,?, ?,?,?,?, ?,?  ) ";
		
		pstmt_p=conp.prepareStatement(Query);
		
		pstmt_p.setLong(1, obj.getAssignmentId());
		pstmt_p.setString(2, obj.getAssignmentName());
		pstmt_p.setString(3, obj.getAssignmentDescription());
		
		pstmt_p.setLong(4,obj.getPriorityId());
		pstmt_p.setLong(5,obj.getEngineerId());
		pstmt_p.setTimestamp(6, obj.getStartedOn());
		
		pstmt_p.setTimestamp(7, obj.getStartedOn());
		pstmt_p.setTimestamp(8, obj.getCompleteOn());
		pstmt_p.setLong(9,obj.getStatusId());
		
		pstmt_p.setLong(10,obj.getAnalysisId());
		pstmt_p.setLong(11, obj.getCodingId());
		pstmt_p.setLong(12, obj.getTestingId());
		
		pstmt_p.setLong(13, obj.getDeploymentId());
		pstmt_p.setLong(14,obj.getTypeId());
		pstmt_p.setLong(15,obj.getPriorityId());
		
		pstmt_p.setTimestamp(16, obj.getModifiendOn());
		pstmt_p.setString(17,obj.getModifiedBy());
		pstmt_p.setString(18,obj.getModifiedMachineName());
		
		pstmt_p.setBoolean(19, obj.getActive());
		pstmt_p.setLong(20,obj.getReferenceAssignmentID());
		pstmt_p.setLong(21,obj.getAssignByEngId());
		
		pstmt_p.setLong(22,obj.getTransactionType());
		System.out.println( " start data insert");
	    returbval=pstmt_p.executeUpdate();
		System.out.println(" data succusefully add ");
		
		return returbval;
	}
	
	public EngineerAssignmentDestributionBean selectEngineerAssignmentDestributionDb(Connection cong  , long engineerId) throws Exception 
	{
		EngineerAssignmentDestributionBean empObj = new EngineerAssignmentDestributionBean();
		String query="Select * from EngineerAssignmentDestribution  where active =1 and engineerId ="+engineerId;
		
		System.out.println("user id pass "+query);
		PreparedStatement pstmt_g = null;
		pstmt_g = cong.prepareStatement(query);
		ResultSet rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		
		empObj.setEngineerId(rs_g.getLong("assignmentId"));
		empObj.setAssignmentName(rs_g.getString("assignmentName"));
		empObj.setAssignmentDescription(rs_g.getString("assignmentDescription"));
		
		empObj.setProjectId(rs_g.getLong("projectId"));
		empObj.setEngineerId(rs_g.getLong("engineerId"));
		empObj.setStartedOn(rs_g.getTimestamp("startedOn"));
		
		empObj.setTargetOn(rs_g.getTimestamp("targetOn"));
		empObj.setCompleteOn(rs_g.getTimestamp("completeOn"));
		empObj.setStatusId(rs_g.getLong("statusId"));
		
		empObj.setAnalysisId(rs_g.getLong("analysisId"));
		empObj.setCodingId(rs_g.getLong("codingId"));
		empObj.setTestingId(rs_g.getLong("testingId"));
		
		empObj.setDeploymentId(rs_g.getLong("deploymentId"));
		empObj.setTypeId(rs_g.getLong("typeId"));
		empObj.setPriorityId(rs_g.getLong("priorityId"));
		
		
		empObj.setModifiendOn(rs_g.getTimestamp("modifiendOn"));
		empObj.setModifiedBy(rs_g.getString("modifiedBy"));
		empObj.setModifiedMachineName(rs_g.getString("modifiedMachineName"));
		
		empObj.setActive(rs_g.getBoolean("active"));
		empObj.setReferenceAssignmentID(rs_g.getLong("referenceAssignmentID"));
		empObj.setAssignByEngId(rs_g.getLong("assignByEngId"));
		
		empObj.setTransactionType(rs_g.getLong("transactionType"));
		}
		
		
		return empObj ;
		
	}

	public EngineerAssignmentDestributionBean selectEngineerAssignmentDestributionDbRelation(Connection cong  , long engineerId) throws Exception 
	{
		EngineerAssignmentDestributionBean empObj = new EngineerAssignmentDestributionBean();
		String query="Select * from EngineerAssignmentDestribution  where active =1 and engineerId ="+engineerId;
		
		PreparedStatement pstmt_g = null;
		pstmt_g = cong.prepareStatement(query);
		ResultSet rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		
		empObj.setEngineerId(rs_g.getLong("assignmentId"));
		empObj.setAssignmentName(rs_g.getString("assignmentName"));
		empObj.setAssignmentDescription(rs_g.getString("assignmentDescription"));
		
		empObj.setProjectId(rs_g.getLong("projectId"));
		empObj.setEngineerId(rs_g.getLong("engineerId"));
		empObj.setStartedOn(rs_g.getTimestamp("startedOn"));
		
		empObj.setTargetOn(rs_g.getTimestamp("targetOn"));
		empObj.setCompleteOn(rs_g.getTimestamp("completeOn"));
		empObj.setStatusId(rs_g.getLong("statusId"));
		
		empObj.setAnalysisId(rs_g.getLong("analysisId"));
		empObj.setCodingId(rs_g.getLong("codingId"));
		empObj.setTestingId(rs_g.getLong("testingId"));
		
		empObj.setDeploymentId(rs_g.getLong("deploymentId"));
		empObj.setTypeId(rs_g.getLong("typeId"));
		empObj.setPriorityId(rs_g.getLong("priorityId"));
		
		
		empObj.setModifiendOn(rs_g.getTimestamp("modifiendOn"));
		empObj.setModifiedBy(rs_g.getString("modifiedBy"));
		empObj.setModifiedMachineName(rs_g.getString("modifiedMachineName"));
		
		empObj.setActive(rs_g.getBoolean("active"));
		empObj.setReferenceAssignmentID(rs_g.getLong("referenceAssignmentID"));
		empObj.setAssignByEngId(rs_g.getLong("assignByEngId"));
		
		empObj.setTransactionType(rs_g.getLong("transactionType"));
		}
		
		
		return empObj ;
		
	}

	public notPersistenBean selectReport(Connection cong  , long engineerId , String yyyy ,String dd ,String mm) throws Exception 
	{
		String query="select EMD.assignmentId,  EMD.priorityId , EMD.assignmentName,"+ 
		" ME.engineerName , MP.projectName , ME2.engineerName as assignmentBy ,EMD.TypeId,MT.TypeName,MPR.PriorityName"+
		" from EngineerAssignmentDestribution EMD , masterEngineer ME ,  masterEngineer ME2 ,masterProject MP ,MasterType MT,MasterPriority MPR"+ 
		" where EMD.engineerId = ME.engineerId  and EMD.Active=ME.Active "+
		" and EMD.assignByEngId = ME2.engineerId and EMD.Active =MP.Active  and MP.projectId = EMD.projectId "+
		" and EMD.TypeId=MT.TypeId and EMD.PriorityId=MPR.PriorityId and MT.Active=1 and MPR.ACtive=1"+
		" and EMD.engineerId="+engineerId+
		" and  month(startedOn)="+mm+" and day(startedOn)= "+dd +" and year(startedOn)="+yyyy ;

		//System.out.println("join Query "+query);
		notPersistenBean empObj = new notPersistenBean();
		PreparedStatement pstmt_g = null;
		pstmt_g = cong.prepareStatement(query);
		ResultSet rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		
		empObj.setAssignmentId(rs_g.getLong("assignmentId"));
		empObj.setPriorityId(rs_g.getLong("priorityId"));
		empObj.setAssignmentName(rs_g.getString("assignmentName"));
		empObj.setEngineerName(rs_g.getString("engineerName"));
		
		empObj.setProjectName(rs_g.getString("projectName"));
		empObj.setAssignmentBy(rs_g.getString("assignmentBy"));
		empObj.setTypeId(rs_g.getLong("TypeId"));
		empObj.setTypeName(rs_g.getString("TypeName"));
		empObj.setPriorityName(rs_g.getString("PriorityName"));
		
		}
		
		
		return empObj ;
		
	}


	public notPersistenBean selectReport(Connection cong  , long engineerId ) throws Exception 
	{
		String query="select EMD.assignmentId, EMD.assignmentName,"+ 
		" ME.engineerName , MP.projectName , ME2.engineerName as assignmentBy "+
		" from EngineerAssignmentDestribution EMD , masterEngineer ME ,  masterEngineer ME2 ,masterProject MP "+ 
		" where EMD.engineerId = ME.engineerId  and EMD.Active=ME.Active and  ME.CurrentActive=1"+
		" and EMD.assignByEngId = ME2.engineerId and EMD.Active =MP.Active  and MP.projectId = EMD.projectId "+
		" and EMD.engineerId="+engineerId ;
		//" and  month(startedOn)="+mm+" and day(startedOn)= "+dd +" and year(startedOn)="+yyyy ;

		//System.out.println("join Query "+query);
		notPersistenBean empObj = new notPersistenBean();
		PreparedStatement pstmt_g = null;
		pstmt_g = cong.prepareStatement(query);
		ResultSet rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		
		empObj.setAssignmentId(rs_g.getLong("assignmentId"));
		empObj.setAssignmentName(rs_g.getString("assignmentName"));
		empObj.setEngineerName(rs_g.getString("engineerName"));
		
		empObj.setProjectName(rs_g.getString("projectName"));
		empObj.setAssignmentBy(rs_g.getString("assignmentBy"));
		
		}
		
		
		return empObj ;
		
	}


	
}
