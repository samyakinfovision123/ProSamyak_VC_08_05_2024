
package NipponBean.Lists;

public class Lot {
  private long lotId;
  private String lotNo;
  private String description;
  private String size;
  private double salerate;
  private double purchaserate;
	


  public Lot(long lotId, String lotNo, String description, String size, double salerate, double purchaserate) {
    this.lotId=lotId;
    this.lotNo=lotNo;
    this.description=description;
    this.size=size;
    this.salerate=salerate;
    this.purchaserate=purchaserate;
  }

  public long getLotId() {
    return lotId;
  }

  public String getLotNo() {
    return lotNo;
  }

  public String getDescription() {
    return description;
  }

  public String getSize() {
    return size;
  }

  public double getSaleRate() {
    return salerate;
  }

  public double getPurchaseRate() {
    return purchaserate;
  }
}

