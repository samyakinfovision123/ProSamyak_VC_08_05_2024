package samyak.beans;
/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 
* 2    MR Ganesh        22-04-2011  done        add Eng Id 
* 3    Mr Gnaesh	    26-04-2011  done        add remark coloums 
* 4		Anil			26-04-2011  done        TL 2 Version Control
------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.sql.Timestamp;

public class attendant
{
	
	private long attendantId;
	private long engineerId;
	private Timestamp time;
	
	private boolean Active;
	private String remark ;
	
	public attendant()
	{
		
	}

	
	




	public long getAttendantId() {
		return attendantId;
	}

	public void setAttendantId(long attendantId) {
		this.attendantId = attendantId;
	}



	public long getEngineerId() {
		return engineerId;
	}

	public void setEngineerId(long engineerId) {
		this.engineerId = engineerId;
	}

	public Timestamp getTime() {
		return time;
	}

	public void setTime(Timestamp time) {
		this.time = time;
	}


	public boolean isActive() {
		return Active;
	}

	public void setActive(boolean active) 
	{
		Active = active;
	}

	public String getRemark()
	{
		return remark;
	}

	public void setRemark(String remark) 
	{
		this.remark = remark;
	}

		

}
