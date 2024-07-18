package NipponBean.Lists;

public class OverDueReportRow {
  private String receiveId;
  private String receiveNo;
  private String partyName;
  private String partyId;
  private String receiveDate;
  private String dueDate;
  private int overdueDays;
  private double total;
  private double received;
  private double balance;

  public String getReceiveId() {
	return receiveId;
  }

  public String getReceiveNo() {
	return receiveNo;
  }

  public String getPartyName() {
	return partyName;
  }

  public String getPartyId() {
	return partyId;
  }

  public String getReceiveDate() {
	return receiveDate;
  }

  public String getDueDate() {
	return dueDate;
  }

  public int getOverdueDays() {
	return overdueDays;
  }

  public double getTotal() {
	return total;
  }

  public double getReceived() {
	return received;
  }

  public double getBalance() {
	return balance;
  }

public OverDueReportRow(String receiveId, String receiveNo, String partyName, String partyId, String receiveDate, String dueDate, int overdueDays, double total, double received, double balance) {
	this.receiveId = receiveId;
	this.receiveNo = receiveNo;
	this.partyName = partyName;
	this.partyId = partyId;
	this.receiveDate = receiveDate;
	this.dueDate = dueDate;
	this.overdueDays = overdueDays;
	this.total = total;
	this.received = received;
	this.balance = balance;
  }
 
  
}