package NipponBean;
import NipponBean.*;
public class saleReturnAccounts
{
	String pursaleGroupReturnName="";
	double groupSalesReturnLocalAmount=0;
	double groupSalesReturnDollarAmount=0;
	public String getpursaleGroupName()
	{
		return  pursaleGroupReturnName;
	}

	public double getgroupSalesReturnLocalAmount()
	{return groupSalesReturnLocalAmount;}
	public double getgroupSalesReturnDollarAmount()
	{ return groupSalesReturnDollarAmount;}

	 saleReturnAccounts(String pursaleGroupReturnName , double groupSalesReturnLocalAmount , double groupSalesReturnDollarAmount )
	{
		this.pursaleGroupReturnName=pursaleGroupReturnName;
		this.groupSalesReturnLocalAmount=groupSalesReturnLocalAmount;
		this.groupSalesReturnDollarAmount=groupSalesReturnDollarAmount;
	}

}