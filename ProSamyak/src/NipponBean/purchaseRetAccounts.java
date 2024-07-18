package NipponBean;
import NipponBean.*;
public class purchaseRetAccounts
{
		String pursaleGroupName="";
		double groupPurchaseLocalAmount=0;
		double groupPurchaseDollarAmount=0;

		public String getpursaleGroupName()
		{
			return  pursaleGroupName;
		}

		public double getgroupPurchaseLocalAmount()
		{
			return groupPurchaseLocalAmount;
		}
		
		public double getgroupPurchaseDollarAmount()
		{
			return groupPurchaseDollarAmount;
		}

		 purchaseRetAccounts(String pursaleGroupName , double groupPurchaseLocalAmount ,  double groupPurchaseDollarAmount )
		{
			this.pursaleGroupName=pursaleGroupName;
			this.groupPurchaseLocalAmount=groupPurchaseLocalAmount;
			this.groupPurchaseDollarAmount=groupPurchaseDollarAmount;
		}


	}