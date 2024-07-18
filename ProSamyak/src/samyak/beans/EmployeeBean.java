package samyak.beans;
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

import java.sql.Timestamp;

public class EmployeeBean 
{
	private long employeeId ; 
	private String firstName ; 
	private String  middleName;
	private String  lastName ;
	private Timestamp  JoinDate ;
	private Timestamp  birthDate ;
	private boolean  active ;
	private long  Contactnumber ;
	private String  Address ;
	private long  masterUserId ;
	private String  Desination ;
	
	public EmployeeBean()
	{
		
	}

	public long getEmployeeId() {
		return employeeId;
	}

	public void setEmployeeId(long employeeId) {
		this.employeeId = employeeId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
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

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
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

	public long getMasterUserId() {
		return masterUserId;
	}

	public void setMasterUserId(long masterUserId) {
		this.masterUserId = masterUserId;
	}

	public String getDesination() {
		return Desination;
	}

	public void setDesination(String desination) {
		Desination = desination;
	}
	
	
	
}
