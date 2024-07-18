package NipponBean;
import java.util.*;
import java.io.*;
import NipponBean.*;

public class LotHistoryRow
{
	String type;
	double qty;
	double local_amount;
	double dollar_amount;
	
	public LotHistoryRow(String type,double qty,double local_amount,double dollar_amount)
	{
		this.type=type;
		this.qty=qty;
		this.local_amount=local_amount;
		this.dollar_amount=dollar_amount;
	}

	public String getType()
	{
		return this.type;
	}
	public double getQty()
	{
		return this.qty;
	}
	public double getLocalAmount()
	{
		return this.local_amount;
	}
	public double getDollarAmount()
	{
		return this.dollar_amount;
	}
}