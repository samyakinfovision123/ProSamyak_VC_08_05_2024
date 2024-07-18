/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

package samyak.beans;

import java.sql.Timestamp;

public class EngineerAssignmentDestributionBean 
{
	
	private long assignmentId ;
	private String assignmentName ;
	private String assignmentDescription ;
	
	private long projectId;
	private long engineerId;
	private Timestamp startedOn;
	
	private Timestamp targetOn;
	private Timestamp completeOn;
	private long statusId;
	
	private long analysisId;
	private long codingId;
	private long testingId;
	
	private long deploymentId;
	private long typeId;
	private long priorityId;
	
	private Timestamp modifiendOn;
	private String modifiedBy ;
	private String modifiedMachineName ;
	
	private Boolean active ;
	private long referenceAssignmentID ;
	private long assignByEngId;
	
	private long transactionType;

	public EngineerAssignmentDestributionBean()
	{
		
	}
	
	public long getAssignmentId() {
		return assignmentId;
	}

	public void setAssignmentId(long assignmentId) {
		this.assignmentId = assignmentId;
	}

	public String getAssignmentName() {
		return assignmentName;
	}

	public void setAssignmentName(String assignmentName) {
		this.assignmentName = assignmentName;
	}

	public String getAssignmentDescription() {
		return assignmentDescription;
	}

	public void setAssignmentDescription(String assignmentDescription) {
		this.assignmentDescription = assignmentDescription;
	}

	public long getProjectId() {
		return projectId;
	}

	public void setProjectId(long projectId) {
		this.projectId = projectId;
	}

	public long getEngineerId() {
		return engineerId;
	}

	public void setEngineerId(long engineerId) {
		this.engineerId = engineerId;
	}

	public Timestamp getStartedOn() {
		return startedOn;
	}

	public void setStartedOn(Timestamp startedOn) {
		this.startedOn = startedOn;
	}

	public Timestamp getTargetOn() {
		return targetOn;
	}

	public void setTargetOn(Timestamp targetOn) {
		this.targetOn = targetOn;
	}

	public Timestamp getCompleteOn() {
		return completeOn;
	}

	public void setCompleteOn(Timestamp completeOn) {
		this.completeOn = completeOn;
	}

	public long getStatusId() {
		return statusId;
	}

	public void setStatusId(long statusId) {
		this.statusId = statusId;
	}

	public long getAnalysisId() {
		return analysisId;
	}

	public void setAnalysisId(long analysisId) {
		this.analysisId = analysisId;
	}

	public long getCodingId() {
		return codingId;
	}

	public void setCodingId(long codingId) {
		this.codingId = codingId;
	}

	public long getTestingId() {
		return testingId;
	}

	public void setTestingId(long testingId) {
		this.testingId = testingId;
	}

	public long getDeploymentId() {
		return deploymentId;
	}

	public void setDeploymentId(long deploymentId) {
		this.deploymentId = deploymentId;
	}

	public long getTypeId() {
		return typeId;
	}

	public void setTypeId(long typeId) {
		this.typeId = typeId;
	}

	public long getPriorityId() {
		return priorityId;
	}

	public void setPriorityId(long priorityId) {
		this.priorityId = priorityId;
	}

	public Timestamp getModifiendOn() {
		return modifiendOn;
	}

	public void setModifiendOn(Timestamp modifiendOn) {
		this.modifiendOn = modifiendOn;
	}

	public String getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public String getModifiedMachineName() {
		return modifiedMachineName;
	}

	public void setModifiedMachineName(String modifiedMachineName) {
		this.modifiedMachineName = modifiedMachineName;
	}

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	public long getReferenceAssignmentID() {
		return referenceAssignmentID;
	}

	public void setReferenceAssignmentID(long referenceAssignmentID) {
		this.referenceAssignmentID = referenceAssignmentID;
	}

	public long getAssignByEngId() {
		return assignByEngId;
	}

	public void setAssignByEngId(long assignByEngId) {
		this.assignByEngId = assignByEngId;
	}

	public long getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(long transactionType) {
		this.transactionType = transactionType;
	}
	
	

}
