package NipponBean;

import java.io.*;
import NipponBean.*;


public class StockInOutDataDisplay
{
		int sReceive_Id =0;
		String sType =" ";
		String sReceive_No =" ";
		
		String sReceive_Date = "";

		String St_type =" ";
		String sReceive_Lots =" ";
		String dReceive_Lots =" ";
		
		double sReceive_Quantity =0;
		double dReceive_Quantity =0;

		double sLocal_Total =0;
		double dLocal_Total =0;

		double sDollar_Total =0;
		double dDollar_Total =0;

		int Party_id=0;

	public int getReceiveId()
	{ 
		return this.sReceive_Id;
	}
	public String getsType()
	{ 
		return this.sType;
	}
	
	public String getReceiveNo()
	{ 
		return this.sReceive_No;
	}

	public String getReceiveDate()
	{
		return this.sReceive_Date;
	}

	public String getStocktype()
	{ 
		return this.St_type;
	}

	public String getSorceReceiveLots()
	{ 
		return this.sReceive_Lots;
	}

	public String getDestinationReceive_Lots()
	{ 
		return this.dReceive_Lots;
	}
	
	public double getSourceQuantity()
	{ 
		return this.sReceive_Quantity;
	}

	public double getDestinationQuantity()
	{
		return this.dReceive_Quantity;
	}

	public double getSourceLocalTotal()
	{ 
		return this.sLocal_Total;
	}

	public double getDestinationLocalTotal()
	{ 
		return this.dLocal_Total;
	}

	public double getSourceDollarTotal()
	{ 
		return this.sDollar_Total;
	}

	public double getDestinationDollarTotal()
	{ 
		return this.dDollar_Total;
	}
	public int getPartyId()
	{ 
		return this.Party_id;
	}
	
	public StockInOutDataDisplay(int receive_id,String sType,String receiveNo,String receiveDate,String st_type,String sReceive_lots,String dReceive_lots,double sReceive_quantity,double dReceive_quantity,double sLocal_total,double dLocal_total,double sDollar_total,double dDollar_total,int Party_Id)
    {
		this.sReceive_Id = receive_id;
		this.sType = sType;
		this.sReceive_No = receiveNo;
		this.sReceive_Date = receiveDate;
		
		this.St_type = st_type;
		
		this.sReceive_Lots=sReceive_lots;
		this.dReceive_Lots=dReceive_lots;

		this.sReceive_Quantity=sReceive_quantity;
		this.dReceive_Quantity=dReceive_quantity;
		
		this.sLocal_Total=sLocal_total;
		this.dLocal_Total=dLocal_total;

		this.sDollar_Total=sDollar_total;
		this.dDollar_Total=dDollar_total;

		this.Party_id=Party_Id;
	
	}//end constructer New_MemoInData ( String-5 , Date-3 ,  String-8 )
}//end class New_MemoInData
