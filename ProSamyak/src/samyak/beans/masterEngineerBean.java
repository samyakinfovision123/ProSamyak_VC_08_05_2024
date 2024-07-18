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

public class masterEngineerBean 
{
	private long engineerId ;
	private String engineerName;
	private String  engineerDescription;
	
	private long  srNo ;
	private Timestamp modifiedOn ;
	private String modifiedBy;
	
	private String modifiedMachineName;
	private boolean active ;
	private long DesgnationId ;
	
	private Timestamp JoinDate ;
	private Timestamp birthDate ;
	private long Contactnumber;
	
	private String Address ;
	
	public masterEngineerBean ()
	{
		
	}

	public long getEngineerId() {
		return engineerId;
	}

	public void setEngineerId(long engineerId) {
		this.engineerId = engineerId;
	}

	public String getEngineerName() {
		return engineerName;
	}

	public void setEngineerName(String engineerName) {
		this.engineerName = engineerName;
	}

	public String getEngineerDescription() {
		return engineerDescription;
	}

	public void setEngineerDescription(String engineerDescription) {
		this.engineerDescription = engineerDescription;
	}

	public long getSrNo() {
		return srNo;
	}

	public void setSrNo(long srNo) {
		this.srNo = srNo;
	}

	public Timestamp getModifiedOn() {
		return modifiedOn;
	}

	public void setModifiedOn(Timestamp modifiedOn) {
		this.modifiedOn = modifiedOn;
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

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	public long getDesgnationId() {
		return DesgnationId;
	}

	public void setDesgnationId(long desgnationId) {
		DesgnationId = desgnationId;
	}

	public Timestamp getJoinDate() {
		return JoinDate;
	}

	public void setJoinDate(Timestamp joinDate) {
		JoinDate = joinDate;
	}

	public Timestamp getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(Timestamp birthDate) {
		this.birthDate = birthDate;
	}

	public long getContactnumber() {
		return Contactnumber;
	}

	public void setContactnumber(long contactnumber) {
		Contactnumber = contactnumber;
	}

	public String getAddress() {
		return Address;
	}

	public void setAddress(String address) {
		Address = address;
	}

	
	
	
}
