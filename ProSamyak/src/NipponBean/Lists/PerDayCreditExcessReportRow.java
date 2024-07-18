package NipponBean.Lists;

public class PerDayCreditExcessReportRow {
  private String partyId;
  private String partyName;
  private String saleDate;
  private double perdaySale;
  private double perdayCreditLimit;
  private double excess;

  public String getPartyId() {
	return partyId;
  }

  public String getPartyName() {
	return partyName;
  }

  public double getPerdayCreditLimit() {
	return perdayCreditLimit;
  }

  public double getPerdaySale() {
	return perdaySale;
  }

  public String getSaleDate() {
	return saleDate;
  }
  
  public double getExcess() {
	return excess;
  }

public PerDayCreditExcessReportRow(String partyId, String partyName, String saleDate, double perdaySale, double perdayCreditLimit, double excess) {
	this.partyId = partyId;
	this.partyName = partyName;
	this.saleDate = saleDate;
	this.perdaySale = perdaySale;
	this.perdayCreditLimit = perdayCreditLimit;
	this.excess = excess;
  }
 
  
}