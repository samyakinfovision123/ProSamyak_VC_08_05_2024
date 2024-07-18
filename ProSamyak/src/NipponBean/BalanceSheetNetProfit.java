package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class BalanceSheetNetProfit
{
	
  PreparedStatement pstmt_g=null;
  PreparedStatement pstmt_p=null;
  ResultSet rs_g=null;
  String errLine="12";
  String net_Profit_local_dollar="";
  int d=4;
  int i=0;
  private java.util.Date D1=null;
  public String getNetProfit(Connection cong,java.sql.Date D2,double final_opening,double final_closing,double dollarFinal_opening,double dollarFinal_closing,String company_id,String yearend_id)
  {
	try
	{
	YearEndDate YED=new YearEndDate();
	YearEndFinance YEF=new YearEndFinance();
	java.sql.Date D1 = YED.getDate(cong,"Yearend","From_Date", " where yearend_id="+yearend_id);
	java.sql.Date openDate=new java.sql.Date((D1.getYear()),(D1.getMonth()),(D1.getDate()-1));
	//System.out.println("25 openDate ="+openDate.toString());
	
	
	String stockOpenQuery="select ClosingQuantity,ClosingLocalAmount,ClosingDollarAmount,stockdescription,Modified_On from Stock where ClosingDate='"+openDate+"' and company_id="+company_id+" and Active=1";
		
	//out.println("stockOpenQuery="+stockOpenQuery);
	pstmt_g = cong.prepareStatement(stockOpenQuery);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next()) 	
	{
		//openingQty=rs_g.getDouble("ClosingQuantity");
		final_opening=rs_g.getDouble("ClosingLocalAmount");
		dollarFinal_opening=rs_g.getDouble("ClosingDollarAmount");
		
	}
	pstmt_g.close();
	
	
	String query="Select R.receive_id,R.Receive_Sell,R.Exchange_Rate, PD.Local_Amount, PD.Dollar_Amount from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId  and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0 and R.Active=1 and PD.Active=1 and R.R_Return=0 and R.Receive_CurrencyId=0 order by R.Receive_id";

	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
		
	double purchase_local_currency =0;
	double sale_local_currency =0;

	double purchase_LC =0;   // purchase local currency gain or loss
	double sale_LC =0;  // sale local currency gain or loss
						//for individual while loop for same receive id 
	double t_purchase_LC =0; // purchase local currency gain or loss
	double t_sale_LC =0;		// sale local currency gain or loss

	double FINAL_GAINLOSS=0;
	double DOLLAR_FINAL_GAINLOSS=0;
	double t_old_exrate = 0;
	double t_total_dollar = 0;
	int t_receiveid =0;
	double t_purchase_gainloss=0;	
	double t_purchase_gainloss_dollar=0;	
	double PURCHASE_GAINLOSS = 0;
	double PURCHASE_GAINLOSS_DOLLAR = 0;
	boolean flag = false;
		
	double st_old_exrate = 0;
	double st_total_dollar = 0;
	int st_receiveid =0;
	double st_purchase_gainloss=0;	
	double st_purchase_gainloss_dollar=0;	
	double salePURCHASE_GAINLOSS = 0;
	double salePURCHASE_GAINLOSS_DOLLAR=0;
	boolean sflag = false;

	while(rs_g.next()) 
	{
		t_receiveid = rs_g.getInt("receive_id");
	
		if(rs_g.getBoolean("Receive_Sell"))//purchase
		{
			t_old_exrate = rs_g.getDouble("Exchange_Rate");
			double local_amount  = rs_g.getDouble("Local_Amount");
			double dollar_amount = rs_g.getDouble("Dollar_Amount");	
			t_total_dollar = t_total_dollar + dollar_amount; 
			t_purchase_gainloss = (t_old_exrate*dollar_amount) - (local_amount);
			t_purchase_gainloss_dollar=(t_purchase_gainloss)/t_old_exrate;
			PURCHASE_GAINLOSS = PURCHASE_GAINLOSS + str.mathformat(t_purchase_gainloss,d);
			PURCHASE_GAINLOSS_DOLLAR = PURCHASE_GAINLOSS_DOLLAR + str.mathformat(t_purchase_gainloss_dollar,d);
		}
		else //sale
		{
			st_old_exrate = rs_g.getDouble("Exchange_Rate");
			double slocal_amount  = rs_g.getDouble("Local_Amount");
			double sdollar_amount = rs_g.getDouble("Dollar_Amount");	
			st_total_dollar = st_total_dollar + sdollar_amount; 
				
			st_purchase_gainloss = (st_old_exrate*sdollar_amount) - (slocal_amount);
			st_purchase_gainloss_dollar=st_purchase_gainloss/st_old_exrate;
				
			salePURCHASE_GAINLOSS = salePURCHASE_GAINLOSS + str.mathformat(st_purchase_gainloss,d);
			salePURCHASE_GAINLOSS_DOLLAR = salePURCHASE_GAINLOSS_DOLLAR + str.mathformat(st_purchase_gainloss_dollar,d);
				//total transaction amoun 
		}//else
	}//while


	FINAL_GAINLOSS=PURCHASE_GAINLOSS-salePURCHASE_GAINLOSS;
	DOLLAR_FINAL_GAINLOSS=PURCHASE_GAINLOSS_DOLLAR-salePURCHASE_GAINLOSS_DOLLAR;	//DOLLAR_FINAL_GAINLOSS=FINAL_GAINLOSS/Double.parseDouble(base_exchangerate);
	

	/******   For Sale ,Purchase,Sale Return ,Purchase Return   ****/
	query="select * from Ledger where For_Head=17 and company_id="+company_id+" and Ledger_Name='C. Tax'";
	//System.out.println(" 876 ");
	pstmt_p=cong.prepareStatement(query);

	rs_g=pstmt_p.executeQuery();
	//System.out.println(" 880 ");
	String cforhead_id="";
	String cTaxledger_id="";
	while(rs_g.next())
	{
			cforhead_id=rs_g.getString("For_HeadId");
			cTaxledger_id=rs_g.getString("Ledger_Id");
	}
	pstmt_p.close();
	
	
	
	query = "Select count(*) as groupcount from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id;

	//out.print(query);	
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	int groupcount=0;
	while(rs_g.next())
	{
		groupcount = rs_g.getInt("groupcount");
	}
	pstmt_g.close();

	errLine = "75";	

	int pursaleGroupId[]= new int[groupcount];
	String pursaleGroupName[]= new String[groupcount];
	int pursaleGroupType[]= new int[groupcount];

	double groupPurchaseQuantity[]=new double[groupcount];
	double groupPurchaseLocalAmount[]=new double[groupcount];
	double groupPurchaseDollarAmount[]=new double[groupcount];
	double purchaseQuantityTotal=0;
	double purchaseLocalAmountTotal=0;
	double purchaseDollarAmountTotal=0;

	double groupSalesQuantity[]=new double[groupcount];
	double groupSalesLocalAmount[]=new double[groupcount];
	double groupSalesDollarAmount[]=new double[groupcount];
	double salesQuantityTotal=0;
	double salesLocalAmountTotal=0;
	double salesDollarAmountTotal=0;


	double groupPurchaseReturnQuantity[]=new double[groupcount];
	double groupPurchaseReturnLocalAmount[]=new double[groupcount];
	double groupPurchaseReturnDollarAmount[]=new double[groupcount];
	double purchaseReturnQuantityTotal=0;
	double purchaseReturnLocalAmountTotal=0;
	double purchaseReturnDollarAmountTotal=0;


	double groupSalesReturnQuantity[]=new double[groupcount];
	double groupSalesReturnLocalAmount[]=new double[groupcount];
	double groupSalesReturnDollarAmount[]=new double[groupcount];
	double salesReturnQuantityTotal=0;
	double salesReturnLocalAmountTotal=0;
	double salesReturnDollarAmountTotal=0;
	errLine="569";
	query = "Select * from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" order by PurchaseSaleGroup_Name";

	//out.print(query);	
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	int c=0;
	while(rs_g.next())
	{
		pursaleGroupId[c] = rs_g.getInt("PurchaseSaleGroup_Id");
		pursaleGroupType[c] = rs_g.getInt("PurchaseSaleGroup_Type");
		pursaleGroupName[c] = rs_g.getString("PurchaseSaleGroup_Name");
		c++;
	}
	pstmt_g.close();
	errLine="584";

	/* Take PurchaseSaleGroup_Id for purchase_retun group */ 
	int purchase_return_group=0;
	query = "Select PurchaseSaleGroup_Id from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" and PurchaseSaleGroup_Type=0 and PurchaseSaleGroup_Name='HK_SalesR'";

	//out.print(query);	
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	
	while(rs_g.next())
	{
		purchase_return_group=rs_g.getInt("PurchaseSaleGroup_Id");
	}
	pstmt_g.close();
	errLine="600";
	/* End for PurchaseSaleGroup_Id for purchase_retun group */
	
	/* Take PurchaseSaleGroup_Id for sale_retun group */
	errLine="605";

	int sale_return_group=0;
	query = "Select PurchaseSaleGroup_Id from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" and PurchaseSaleGroup_Type=1 and PurchaseSaleGroup_Name='Local'";

	//out.print(query);	
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	
	while(rs_g.next())
	{
		sale_return_group=rs_g.getInt("PurchaseSaleGroup_Id");
	}
	pstmt_g.close();

	/* End for PurchaseSaleGroup_Id for purchase_retun group */
	errLine = "116";

	double Receive_Quantity = 0;
	double Local_Total = 0;
	double Dollar_Total = 0;
	String Receive_No="";



	//Start Purchase=2 
	for(int im=0; im<groupcount; im++)
	{
		query="Select R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Financial_Transaction FT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and FT.Ledger_Id="+cTaxledger_id+" and V.Active=1 and R.receive_id=FT.Receive_Id and V.Voucher_Id=FT.voucher_Id";
		if(pursaleGroupId[im]==sale_return_group)
		{
			query+=" and R.PurchaseSaleGroup_Id=0";
		}
		else
		{
			query+=" and R.PurchaseSaleGroup_Id="+pursaleGroupId[im]+"";
		}
	
		//out.print("query" + query);
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);
		pstmt_g.setString(3,company_id); 
		pstmt_g.setString(4,"2"); //Purchase
		rs_g = pstmt_g.executeQuery();
		errLine = "170";	
		while(rs_g.next())
		{
			Receive_No = rs_g.getString("Receive_No");
			Receive_Quantity = rs_g.getDouble("Receive_Quantity");
			Local_Total = rs_g.getDouble("InvLocalTotal");
			Dollar_Total = rs_g.getDouble("InvDollarTotal");
			groupPurchaseQuantity[im]=groupPurchaseQuantity[im]+Receive_Quantity;
			groupPurchaseLocalAmount[im]=groupPurchaseLocalAmount[im]+Local_Total;
			groupPurchaseDollarAmount[im]=groupPurchaseDollarAmount[im]+Dollar_Total;
			purchaseQuantityTotal=purchaseQuantityTotal+Receive_Quantity;
			purchaseLocalAmountTotal=purchaseLocalAmountTotal+Local_Total;
			purchaseDollarAmountTotal=purchaseDollarAmountTotal+Dollar_Total;	
		}
			
	}//		
	//End Purchase=2 


	//Start Sales (voucher_type==1
	for(int im=0; im<groupcount; im++)
	{
		query="Select R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Financial_Transaction FT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and FT.Ledger_Id="+cTaxledger_id+" and V.Active=1 and R.receive_id=FT.Receive_Id and V.Voucher_Id=FT.voucher_Id"; 
		if(pursaleGroupId[im]==purchase_return_group)
		{
			query+=" and R.PurchaseSaleGroup_Id=0";
		}
		else
		{
			query+=" and R.PurchaseSaleGroup_Id="+pursaleGroupId[im]+"";
		}
		//out.print("query" + query);
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);
		pstmt_g.setString(3,company_id); 
		pstmt_g.setString(4,"1"); //Sales
		rs_g = pstmt_g.executeQuery();
		errLine = "170";	
		while(rs_g.next())
		{
			Receive_No = rs_g.getString("Receive_No");
			Receive_Quantity = rs_g.getDouble("Receive_Quantity");
			Local_Total = rs_g.getDouble("InvLocalTotal");
			Dollar_Total = rs_g.getDouble("InvDollarTotal");
			groupSalesQuantity[im]=groupSalesQuantity[im]+Receive_Quantity;
			groupSalesLocalAmount[im]=groupSalesLocalAmount[im]+Local_Total;
			groupSalesDollarAmount[im]=groupSalesDollarAmount[im]+Dollar_Total;
			salesQuantityTotal=salesQuantityTotal+Receive_Quantity;
			salesLocalAmountTotal=salesLocalAmountTotal+Local_Total;
			salesDollarAmountTotal=salesDollarAmountTotal+Dollar_Total;	
				
		}
			
	}//		
	//End Sales=1 


	//Start PurchaseReturn (voucher_type==10
	for(int im=0; im<groupcount; im++)
	{
		query="Select R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Financial_Transaction FT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and FT.Ledger_Id="+cTaxledger_id+" and V.Active=1 and R.receive_id=FT.Receive_Id and V.Voucher_Id=FT.voucher_Id";
		if(pursaleGroupId[im]==purchase_return_group)
		{
			query+=" and R.PurchaseSaleGroup_Id="+pursaleGroupId[im];
		}
		else
		{
			query+=" and R.PurchaseSaleGroup_Id=0";
		}
		//out.print("query" + query);
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);
		pstmt_g.setString(3,company_id); 
		pstmt_g.setString(4,"1"); //PurchaseReturn
		rs_g = pstmt_g.executeQuery();
		errLine = "170";	
		while(rs_g.next())
		{
			Receive_No = rs_g.getString("Receive_No");
			Receive_Quantity = rs_g.getDouble("Receive_Quantity");
			Local_Total = rs_g.getDouble("InvLocalTotal");
			Dollar_Total = rs_g.getDouble("InvDollarTotal");
			groupPurchaseReturnQuantity[im]=groupPurchaseReturnQuantity[im]+Receive_Quantity;
			groupPurchaseReturnLocalAmount[im]=groupPurchaseReturnLocalAmount[im]+Local_Total;
			groupPurchaseReturnDollarAmount[im]=groupPurchaseReturnDollarAmount[im]+Dollar_Total;
			purchaseReturnQuantityTotal=purchaseReturnQuantityTotal+Receive_Quantity;
			purchaseReturnLocalAmountTotal=purchaseReturnLocalAmountTotal+Local_Total;
			purchaseReturnDollarAmountTotal=purchaseReturnDollarAmountTotal+Dollar_Total;

		}
			
	}//		
	//End PurchaseReturn=10 

	//Start SalesReturn (voucher_type==11
	for(int im=0; im<groupcount; im++)
	{
		query="Select R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Financial_Transaction FT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and FT.Ledger_Id="+cTaxledger_id+" and V.Active=1 and R.receive_id=FT.Receive_Id and V.Voucher_Id=FT.voucher_Id";
		if(pursaleGroupId[im]==sale_return_group)
		{
			query+=" and R.PurchaseSaleGroup_Id="+pursaleGroupId[im];
		}
		else
		{
			query+=" and R.PurchaseSaleGroup_Id=0";
		}
	
	
		//out.print("query" + query);
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);
		pstmt_g.setString(3,company_id); 
		pstmt_g.setString(4,"2"); //SalesReturn
		rs_g = pstmt_g.executeQuery();
		errLine = "170";	
		while(rs_g.next())
		{
			Receive_No = rs_g.getString("Receive_No");
			Receive_Quantity = rs_g.getDouble("Receive_Quantity");
			Local_Total = rs_g.getDouble("InvLocalTotal");
			Dollar_Total = rs_g.getDouble("InvDollarTotal");
			groupSalesReturnQuantity[im]=groupSalesQuantity[im]+Receive_Quantity;
			groupSalesReturnLocalAmount[im]=groupSalesReturnLocalAmount[im]+Local_Total;
			groupSalesReturnDollarAmount[im]=groupSalesReturnDollarAmount[im]+Dollar_Total;
			salesReturnQuantityTotal=salesReturnQuantityTotal+Receive_Quantity;
			salesReturnLocalAmountTotal=salesReturnLocalAmountTotal+Local_Total;
			salesReturnDollarAmountTotal=salesReturnDollarAmountTotal+Dollar_Total;	
				
		}
			
	}//		
	//End SalesReturn=10 

	/******   End  For Sale ,Purchaes ,Sale Return ,Purchase Return  ****/ 
 
	double gross_profit =  (salesLocalAmountTotal + final_closing + purchaseReturnLocalAmountTotal) - (final_opening + purchaseLocalAmountTotal + salesReturnLocalAmountTotal);

	double dollarGross_profit =  (salesDollarAmountTotal + dollarFinal_closing + purchaseReturnDollarAmountTotal) - (dollarFinal_opening + purchaseDollarAmountTotal + salesReturnDollarAmountTotal);

  
	/**** Get Indirect Income ****/
	
	double total_indirectincome=0;
	double dollarTotal_indirectincome=0;
	errLine="445";
	query="Select * from Ledger where Company_id=? and For_Head="+12+" and Active=1 and yearend_id="+ yearend_id+ " order by Ledger_Name";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();	
	 i=0;
	while(rs_g.next())
	{
		i++;
	}//while
	pstmt_g.close();
	int  ic_counter=i;
	// out.print("<br>counter" +i);
	int ic_ledgerid[]=new int[i];
	int ic_forheadid[]=new int[i];
	double in_income[]=new double[i];
	double dollarIn_income[]=new double[i];
	String ic_ledgername[]=new String[i]; 
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();	
	i=0;
	while(rs_g.next())
	{
	ic_ledgerid[i]=rs_g.getInt("Ledger_Id");
	ic_forheadid[i]=rs_g.getInt("For_HeadId");
	ic_ledgername[i]=rs_g.getString("Ledger_Name");

		
	// To get Opening of Indirect Income //
	String opening_amt1= YEF.LedgerClosingBalance(cong,""+ic_ledgerid[i],openDate,d,yearend_id,company_id);
		
	StringTokenizer tokens1 = new StringTokenizer(opening_amt1, "#");
	double local_opening = Double.parseDouble((String)tokens1.nextElement());
	double dollar_opening = Double.parseDouble((String)tokens1.nextElement());
		
	//End to get Opening of Indirect Income //
		
	// To get closing for Indirect Income //
	String closing_amt1= YEF.LedgerClosingBalance(cong,""+ic_ledgerid[i],D2,d,yearend_id,company_id);

	StringTokenizer tokens = new StringTokenizer(closing_amt1, "#");
	double local_closing = Double.parseDouble((String)tokens.nextElement());
	double dollar_closing = Double.parseDouble((String)tokens.nextElement());
   //End for closing for Indirect Income //
		
	in_income[i]=(local_closing-local_opening);
	dollarIn_income[i]=(dollar_closing-dollar_opening);

	//in_expense[i]=rs_g.getDouble("Opening_LocalBalance");
	total_indirectincome +=in_income[i];
	dollarTotal_indirectincome +=dollarIn_income[i];
	i++;
	}//while
	pstmt_g.close();

	/****  end Indirect Income ****/

	/****  For Direct Expenses  ****/
	query="Select * from Ledger where Company_id=? and For_Head="+6+" and Active=1 and yearend_id="+yearend_id+" order by Ledger_Name";
	
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id);
	rs_g = pstmt_g.executeQuery();	
	i=0;
	while(rs_g.next())
	{
		i++;
	}//while
	pstmt_g.close();
	int counter=i;
	
	int ledger_id[]=new int[i];
	int for_headid[]=new int[i];
	double expense[]=new double[i];
	double dollarExpense[]=new double[i];
	double total_expense=0;
	double dollarTotal_expense=0;
	String ledger_name[]=new String[i]; 
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();	
	i=0;

	while(rs_g.next())
	{
		ledger_id[i]=rs_g.getInt("Ledger_Id");
		for_headid[i]=rs_g.getInt("For_HeadId");
		ledger_name[i]=rs_g.getString("Ledger_Name");
		
		// To get Opening of expenses //
		String opening_amt1= YEF.LedgerClosingBalance(cong,""+ledger_id[i],openDate,d,yearend_id,company_id);
	
		StringTokenizer tokens1 = new StringTokenizer(opening_amt1, "#");
		double local_opening = Double.parseDouble((String)tokens1.nextElement());
		double dollar_opening = Double.parseDouble((String)tokens1.nextElement());
		
		//End to get Opening of expenses  //
		// To get closing of expenses //
		String closing_amt1= YEF.LedgerClosingBalance(cong,""+ledger_id[i],D2,d,yearend_id,company_id);
	
		StringTokenizer tokens = new StringTokenizer(closing_amt1, "#");
		double local_closing = Double.parseDouble((String)tokens.nextElement());
		double dollar_closing = Double.parseDouble((String)tokens.nextElement());
		expense[i]=(local_closing-local_opening);
		dollarExpense[i]=(dollar_closing-dollar_opening);
		total_expense +=expense[i];
		dollarTotal_expense +=dollarExpense[i];
		//End of closing of expenses //
		
		i++;
	}//while
	pstmt_g.close();

   /**** End Of Direct Expenses ****/

   /**** For Indirect Income ****/
	double total_indirectrexpense=0;
	double dollarTotal_indirectrexpense=0;
	
	query="Select * from Ledger where Company_id=? and For_Head="+13+" and Active=1 and yearend_id=" + yearend_id + " order by Ledger_Name";
	
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();	
	 i=0;
	while(rs_g.next())
	{
		i++;
	}//while	
	pstmt_g.close();
	
	int  in_counter=i;
	int ledgerid[]=new int[i];
	int forheadid[]=new int[i];
	double in_expense[]=new double[i];
	double dollarIn_expense[]=new double[i];
	String ledgername[]=new String[i]; 
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();

	i=0;
	while(rs_g.next())
	{
		ledgerid[i]=rs_g.getInt("Ledger_Id");
		forheadid[i]=rs_g.getInt("For_HeadId");
		ledgername[i]=rs_g.getString("Ledger_Name");
		// To get Opening of Indirect Expense Ledger   //
		String opening_amt1= YEF.LedgerClosingBalance(cong,""+ledgerid[i],openDate,d,yearend_id,company_id);
	
		StringTokenizer tokens1 = new StringTokenizer(opening_amt1, "#");
		double local_opening = Double.parseDouble((String)tokens1.nextElement());
		double dollar_opening = Double.parseDouble((String)tokens1.nextElement());
		
		//End to get Opening of Indirect Expense Ledger   //
		
		//To get Closing of Indirect Expense Ledger //
		String closing_amt1= YEF.LedgerClosingBalance(cong,""+ledgerid[i],D2,d,yearend_id,company_id);
		errLine="397";
	
		StringTokenizer tokens = new StringTokenizer(closing_amt1, "#");
		double local_closing = Double.parseDouble((String)tokens.nextElement());
		double dollar_closing = Double.parseDouble((String)tokens.nextElement());
		
		//end to get Closing of Indirect Expenses //
		
		in_expense[i]=(local_closing-local_opening);
		dollarIn_expense[i]=(dollar_closing-dollar_opening);
		total_indirectrexpense +=in_expense[i];
		dollarTotal_indirectrexpense +=dollarIn_expense[i];
		
		i++;
	}//while
	pstmt_g.close();
	/*** end Of Indirect Income ***/

	double net_profit =gross_profit - total_indirectrexpense -total_expense -total_indirectincome +FINAL_GAINLOSS;

	double dollarNet_profit =dollarGross_profit - dollarTotal_indirectrexpense -dollarTotal_expense -dollarTotal_indirectincome;
  
  
	//System.out.println("net_profit="+net_profit);
	//System.out.println("dollarNet_profit="+dollarNet_profit);
	
	net_Profit_local_dollar=net_profit+"#"+dollarNet_profit;
	}
	catch(Exception e)
	{
		System.out.println("Exception e="+"errLine="+errLine);
	}
	finally
	{
		return net_Profit_local_dollar;
	}
  } //getNetProfit()
}