	package NipponBean;
	import NipponBean.*;
	public class saleAccounts
	{
		String pursaleGroupName="";
		double groupSalesLocalAmount=0;
		double groupSalesDollarAmount=0;

		public String getpursaleGroupName()
		{
			return  pursaleGroupName;
		}

		public double getgroupSalesLocalAmount()
		{return groupSalesLocalAmount;}
		public double getgroupSalesDollarAmount()
		{ return groupSalesDollarAmount;}

		 saleAccounts(String pursaleGroupName , double groupSalesLocalAmount ,  double groupSalesDollarAmount )
		{
			this.pursaleGroupName=pursaleGroupName;
			this.groupSalesLocalAmount=groupSalesLocalAmount;
			this.groupSalesDollarAmount=groupSalesDollarAmount;
		}


	}