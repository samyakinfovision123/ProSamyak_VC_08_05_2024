/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 1		Anil			23-04-2011	Done		To Access on Server

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
package samyak.beans;

public class notPersistenBean 
{
	
	private long  assignmentId ;
	private String assignmentName ;
	private String engineerName;
	
	private String projectName;
	private  String assignmentBy ;
	private  long  priorityId ;
	private String priorityName;
	private  long  typeId ;
	private String typeName;
	
	
	public notPersistenBean()
	{
		
	}
	
	
	public String getPriorityName() {
		return priorityName;
	}


	public void setPriorityName(String priorityName) {
		this.priorityName = priorityName;
	}


	public long getTypeId() {
		return typeId;
	}


	public void setTypeId(long typeId) {
		this.typeId = typeId;
	}


	public String getTypeName() {
		return typeName;
	}


	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}


	public long getPriorityId() {
		return priorityId;
	}


	public void setPriorityId(long priorityId) {
		this.priorityId = priorityId;
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
	public String getEngineerName() {
		return engineerName;
	}
	public void setEngineerName(String engineerName) {
		this.engineerName = engineerName;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public String getAssignmentBy() {
		return assignmentBy;
	}
	public void setAssignmentBy(String assignmentBy) {
		this.assignmentBy = assignmentBy;
	}

	
	
}
