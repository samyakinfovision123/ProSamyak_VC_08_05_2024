package NipponBean.Lists;

public class CreditExcessReportRow {
  private String partyId;
  private String partyName;
  private double closing;
  private double creditLimit;
  private double excess;

  public String getPartyId() {
	return partyId;
  }

  
  public String getPartyName() {
	return partyName;
  }

  
  public double getClosing() {
	return closing;
  }

  public double getCreditLimit() {
	return creditLimit;
  }

  public double getExcess() {
	return excess;
  }

public CreditExcessReportRow(String partyId, String partyName, double closing, double creditLimit, double excess) {
	this.partyId = partyId;
	this.partyName = partyName;
	this.closing = closing;
	this.creditLimit = creditLimit;
	this.excess = excess;
  }
 
  
}