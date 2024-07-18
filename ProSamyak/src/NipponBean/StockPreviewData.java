
// Work done by Ravindra

package NipponBean;

import NipponBean.*;

public class StockPreviewData
{
	String group_id = "";
	String lot_id = "";
	String lot_no = "";
	String uom = "";
	String description_id = "";
	String size_id = "";
	String unit_id = "";
	
	public String getGroupId()
	{
		return this.group_id;
	}//end public int getGroupId()

	public String getLotId()
	{ 
		return this.lot_id;
	}//end public int getLotId()

	public String getLotNo()
	{ 
		return this.lot_no;
	}//end public int getLotNo()

	public String getUom()
	{ 
		return this.uom;
	}//end public int getUom()
		
	public String getDescriptionId()
	{
		return this.description_id;
	}//end public int getDescriptionId()

	public String getSizeId()
	{
		return this.size_id;
	}//end public int getSizeId()

	public String getUnitId()
	{
		return this.unit_id;
	}//end public int getSizeId()

	public StockPreviewData(String lot_id, String lot_no, String uom, String size_id, String group_id, String description_id,String unit_id)
    {
		this.lot_id = lot_id;
		this.lot_no = lot_no;
		this.uom = uom;
		this.size_id = size_id;
		this.group_id = group_id;
		this.description_id = description_id;
		this.unit_id = unit_id;
	}//end StockPreviewData constructer

}//end StockPreviewData class