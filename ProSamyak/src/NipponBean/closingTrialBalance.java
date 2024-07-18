package NipponBean;
import NipponBean.*;
import java.util.*;
import java.sql.*;

public class closingTrialBalance
{
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;
	ArrayList a1=new ArrayList();

	ArrayList SA=new ArrayList();
	ArrayList PA=new ArrayList();
	ArrayList SRA=new ArrayList();
	
	String purReturnString="";

	//saleAccounts abc=new saleAccounts();

	public ArrayList getExceGainLoss(Connection cong,String reporyearendId,String company_id,java.sql.Date D1,java.sql.Date D2)
	{
		
		
		String query="";
		String party_id="0";
		
	
		double purchase_local_currency=0,sale_local_currency =0;	double t_sale_LC =0;
		double FINAL_GAINLOSS=0,DOLLAR_FINAL_GAINLOSS=0,t_old_exrate=0, t_total_dollar=0,t_receiveid =0,t_purchase_gainloss=0,PURCHASE_GAINLOSS=0,PURCHASE_GAINLOSS_DOLLAR=0,st_old_exrate=0,st_total_dollar=0,st_purchase_gainloss=0, salePURCHASE_GAINLOSS=0,salePURCHASE_GAINLOSS_DOLLAR=0;
	try{
			query="Select R.receive_id,R.Receive_Sell,R.Exchange_Rate,PD.Local_Amount,PD.Dollar_Amount from Receive R, Payment_Details PD  where R.Receive_Id=PD.For_HeadId  and PD.Transaction_Date between ? and ? and R.Company_id=? and R.Purchase=1 and R.Opening_Stock=0 and R.Active=1 and PD.Active=1 and R.R_Return=0 and R.Receive_CurrencyId=0 order by R.Receive_id";
		//out.print("<br> After Query =" +query);
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString(1,""+D1);
			pstmt_g.setString(2,""+D2);	
			pstmt_g.setString(3,company_id); 
			rs_g = pstmt_g.executeQuery();	
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
					double t_purchase_gainloss_dollar=t_purchase_gainloss/t_old_exrate;
					
					PURCHASE_GAINLOSS = PURCHASE_GAINLOSS + t_purchase_gainloss;
					PURCHASE_GAINLOSS_DOLLAR=PURCHASE_GAINLOSS_DOLLAR+t_purchase_gainloss_dollar;

					//System.out.println("53 PURCHASE_GAINLOSS = "+PURCHASE_GAINLOSS);
				}
				else //sale
				{
					st_old_exrate = rs_g.getDouble("Exchange_Rate");
					double slocal_amount  = rs_g.getDouble("Local_Amount");
					double sdollar_amount = rs_g.getDouble("Dollar_Amount");	
					st_total_dollar = st_total_dollar + sdollar_amount; 
					st_purchase_gainloss = (st_old_exrate*sdollar_amount) - (slocal_amount);
					double st_purchase_gainloss_dollar=st_purchase_gainloss/st_old_exrate;
					salePURCHASE_GAINLOSS = salePURCHASE_GAINLOSS + st_purchase_gainloss;
					salePURCHASE_GAINLOSS_DOLLAR=salePURCHASE_GAINLOSS_DOLLAR+st_purchase_gainloss_dollar;

					//System.out.println(" 66  salePURCHASE_GAINLOSS = "+salePURCHASE_GAINLOSS);
				}//else
		}//while
	FINAL_GAINLOSS=PURCHASE_GAINLOSS-salePURCHASE_GAINLOSS;
	DOLLAR_FINAL_GAINLOSS=PURCHASE_GAINLOSS_DOLLAR-salePURCHASE_GAINLOSS_DOLLAR;
	
	
		a1.add(0,""+PURCHASE_GAINLOSS);
		a1.add(1,""+PURCHASE_GAINLOSS_DOLLAR);
		a1.add(2,""+salePURCHASE_GAINLOSS);
		a1.add(3,""+salePURCHASE_GAINLOSS_DOLLAR);
	}
	catch(Exception e)
		{
			System.out.println("Error Occure "+e);
	    }
		//System.out.println("FINAL_GAINLOSS"+FINAL_GAINLOSS+"a1 length"+a1.size());

		return a1;
	}

	

	public ArrayList getSalesAccounts(Connection cong,java.util.Date D1 , java.util.Date D2,String company_id )
	{
		try
		{

			String sales_return_group="";
			String sales_return_group_name="";
			String str_query="select PurchaseSaleGroup_Id,purchaseSaleGroup_Name from Master_PurchaseSaleGroup where purchaseSaleGroup_type=0 and purchaseSaleGroup_Name='HK_SalesR' and company_id="+company_id;
			pstmt_g =cong.prepareStatement(str_query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				sales_return_group=rs_g.getString("PurchaseSaleGroup_Id");
				sales_return_group_name=rs_g.getString("purchaseSaleGroup_Name");
		
			}
			pstmt_g.close();
			String query = "Select count(*) as groupcount from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id;
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			int groupcount=0;
			while(rs_g.next())
			{
				groupcount = rs_g.getInt("groupcount");
			}
			pstmt_g.close();

			String forlocal_purchaseSaleGroup_Id="";
			query ="SELECT * FROM Master_PurchaseSaleGroup  WHERE     (PurchaseSaleGroup_Type = 0) AND (Company_Id = "+company_id+") AND (PurchaseSaleGroup_Name ='Local')";
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				forlocal_purchaseSaleGroup_Id= rs_g.getString("purchaseSaleGroup_Id");
			}
			pstmt_g.close();

		double groupSalesQuantity[]=new double[groupcount];
		double groupSalesLocalAmount[]=new double[groupcount];
		double groupSalesDollarAmount[]=new double[groupcount];
		int pursaleGroupId[]= new int[groupcount];
		String pursaleGroupName[]= new String[groupcount];
		int pursaleGroupType[]= new int[groupcount];
		int c=0;
		int crcnt=0,drcnt=0;	
			query = "Select * from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" order by PurchaseSaleGroup_Name";
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
					pursaleGroupId[c] = rs_g.getInt("PurchaseSaleGroup_Id");
					pursaleGroupType[c] = rs_g.getInt("PurchaseSaleGroup_Type");
					pursaleGroupName[c] = rs_g.getString("PurchaseSaleGroup_Name");
					c++;
			}
			pstmt_g.close();
			String non_sales_return_group_list="";
			str_query="select PurchaseSaleGroup_Id from Master_PurchaseSaleGroup where purchaseSaleGroup_type=0  and company_id="+company_id;
			pstmt_g =cong.prepareStatement(str_query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				if(rs_g.isLast())
				{
					String str_list=rs_g.getString("PurchaseSaleGroup_Id");
					non_sales_return_group_list=non_sales_return_group_list+str_list;
				}
				else
				{
					String str_list=rs_g.getString("PurchaseSaleGroup_Id");
					non_sales_return_group_list=non_sales_return_group_list+str_list+",";
				}
				}
				pstmt_g.close();
				
				String non_purchase_return_group_list="";
				
				str_query="select PurchaseSaleGroup_Id from Master_PurchaseSaleGroup where purchaseSaleGroup_type=1 and  company_id="+company_id;
				pstmt_g =cong.prepareStatement(str_query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{
				if(rs_g.isLast())
				{
					String str_list=rs_g.getString("PurchaseSaleGroup_Id");
					non_purchase_return_group_list=non_purchase_return_group_list+str_list;
				}
				else
				{
					String str_list=rs_g.getString("PurchaseSaleGroup_Id");
					non_purchase_return_group_list=non_purchase_return_group_list+str_list+",";
				}
				}
				pstmt_g.close();

			double Receive_Quantity = 0;
			double Local_Total = 0;
			double Dollar_Total = 0;
			String Receive_No="";
			double groupSalesLocalAmount1=0;
			double groupSalesDollarAmount1=0;


		for(int im=0; im<groupcount; im++)
		{
			query="Select distinct(R.Receive_Id),R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Receive_Transaction RT where V.voucher_Date between ? and ? and R.Company_id=?	and V.Voucher_Type=? and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)	and V.Active=1 and StockTransfer_type=0 and R.receive_id=RT.Receive_Id ";
		
			if(sales_return_group.equals(""+pursaleGroupId[im]))
			{
				query=query+"and R.PurchaseSaleGroup_Id=0";
			}
			else
			{
				query=query+"and R.PurchaseSaleGroup_Id="+pursaleGroupId[im];
			}
			
		
		//out.print("query" + query);
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString(1,""+D1);
			pstmt_g.setString(2,""+D2);
			pstmt_g.setString(3,company_id); 
			pstmt_g.setString(4,"1"); //Sales
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next())
			{
				Receive_No = rs_g.getString("Receive_No");
				Local_Total = rs_g.getDouble("InvLocalTotal");
				Dollar_Total = rs_g.getDouble("InvDollarTotal");
				groupSalesQuantity[im]=groupSalesQuantity[im]+Receive_Quantity;
				groupSalesLocalAmount[im]=groupSalesLocalAmount[im]+Local_Total;
				groupSalesDollarAmount[im]=groupSalesDollarAmount[im]+Dollar_Total;
				
				//salesLocalAmountTotal=salesLocalAmountTotal+Local_Total;
				//salesDollarAmountTotal=salesDollarAmountTotal+Dollar_Total;	
			
			}
			if(groupSalesLocalAmount[im] !=0)
			{

				String  pursaleGroupName1=pursaleGroupName[im];
				  groupSalesLocalAmount1=groupSalesLocalAmount[im];
				  groupSalesDollarAmount1=groupSalesDollarAmount[im];
				
			//	System.out.println(" groupSalesLocalAmount1 = "+groupSalesLocalAmount1);
			//	System.out.println(" groupSalesDollarAmount1 = "+groupSalesDollarAmount1);
				
				NipponBean.saleAccounts sar =new NipponBean.saleAccounts(pursaleGroupName1 , groupSalesLocalAmount1 , groupSalesDollarAmount1);
				SA.add(sar);

			}// end if

		  }//end for
			
		}//end try
		catch(Exception e)
		{
			System.out.println("Error Occure @ SalesAccount methods in ClosingTrialBalance"+e);
		}

		return SA;
	}//getSalesAccounts()...


	public ArrayList getPurchaseAccounts(Connection cong,java.util.Date D1 , java.util.Date D2,String company_id )
	{
		try
		{
			String query = "Select count(*) as groupcount from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id;
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();

			int groupcount=0;
				while(rs_g.next())
				{
					groupcount = rs_g.getInt("groupcount");
				}
				pstmt_g.close();

		String forlocal_purchaseSaleGroup_Id="";
		query ="SELECT * FROM Master_PurchaseSaleGroup  WHERE     (PurchaseSaleGroup_Type = 0) AND (Company_Id = "+company_id+") AND (PurchaseSaleGroup_Name ='Local')";
				pstmt_g =cong.prepareStatement(query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{
					forlocal_purchaseSaleGroup_Id= rs_g.getString("purchaseSaleGroup_Id");
				}
				pstmt_g.close();
				String purchase_return_group="";
		String purchase_return_group_name="";
		String str_query="select PurchaseSaleGroup_Id,purchaseSaleGroup_Name from Master_PurchaseSaleGroup where purchaseSaleGroup_type=1 and purchaseSaleGroup_Name='Local' and  company_id="+company_id;
				pstmt_g =cong.prepareStatement(str_query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{	purchase_return_group=rs_g.getString("PurchaseSaleGroup_Id");
				purchase_return_group_name=rs_g.getString("purchaseSaleGroup_Name");
				}
				pstmt_g.close();

//System.out.println(" 4387 Under this");
		int pursaleGroupId[]= new int[groupcount];
		String pursaleGroupName[]= new String[groupcount];
		int pursaleGroupType[]= new int[groupcount];
		double groupPurchaseQuantity[]=new double[groupcount];
		double groupPurchaseLocalAmount[]=new double[groupcount];
		double groupPurchaseDollarAmount[]=new double[groupcount];
		int c=0;
		query = "Select * from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" order by PurchaseSaleGroup_Name";
				pstmt_g =cong.prepareStatement(query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{
					pursaleGroupId[c] = rs_g.getInt("PurchaseSaleGroup_Id");
					pursaleGroupType[c] = rs_g.getInt("PurchaseSaleGroup_Type");
					pursaleGroupName[c] = rs_g.getString("PurchaseSaleGroup_Name");
					c++;
				}
				pstmt_g.close();
		
		double Receive_Quantity = 0;
		double Local_Total = 0;
		double Dollar_Total = 0;
		String Receive_No="";
		//Start Sales (voucher_type==1)
		double base_salesLocalAmountTotal=0;
	for(int im=0; im<groupcount; im++)
	{
		query="Select distinct(R.Receive_Id),R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Receive_Transaction RT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)	and V.Active=1 and StockTransfer_type=0 and R.receive_id=RT.Receive_Id ";
			if(purchase_return_group.equals(""+pursaleGroupId[im]))
			{
				query=query+"and R.PurchaseSaleGroup_Id=0";
				//out.println("Group="+pursaleGroupId[im]);
				
			}
			else
			{
				query=query+"and R.PurchaseSaleGroup_Id="+pursaleGroupId[im];
				//out.println("Not Group="+pursaleGroupId[im]);
			}
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString(1,""+D1);
			pstmt_g.setString(2,""+D2);
			pstmt_g.setString(3,company_id); 
			pstmt_g.setString(4,"2"); //Purchase
			rs_g = pstmt_g.executeQuery();
			
		//out.println("For im="+im+"   "+pursaleGroupId[im]+"<br>");
			while(rs_g.next())
			{
				Receive_No = rs_g.getString("Receive_No");
				Receive_Quantity = rs_g.getDouble("Receive_Quantity");
				Local_Total = rs_g.getDouble("InvLocalTotal");
				Dollar_Total = rs_g.getDouble("InvDollarTotal");
				groupPurchaseQuantity[im]=groupPurchaseQuantity[im]+Receive_Quantity;
				groupPurchaseLocalAmount[im]=groupPurchaseLocalAmount[im]+Local_Total;
				groupPurchaseDollarAmount[im]=groupPurchaseDollarAmount[im]+Dollar_Total;
				
		   }

		  if(groupPurchaseLocalAmount[im] != 0)
		  {
			   String pursaleGroupName1= pursaleGroupName[im];
			   double groupPurchaseLocalAmount1=groupPurchaseLocalAmount[im];
			   double groupPurchaseDollarAmount1=groupPurchaseDollarAmount[im];

		   purchaseAccounts puraccts=new purchaseAccounts(pursaleGroupName1,groupPurchaseLocalAmount1,groupPurchaseDollarAmount1);

		   PA.add(puraccts);

		  }

		}//for..

		}catch (Exception e)
		{
			System.out.println("Error Occure @ ClosingTrialBalance in getPurchaseAccounts method"+e);
		}
			return PA;
	}//end getPurchaseAccounts


	public ArrayList getSaleReturnAccounts(Connection cong,java.util.Date D1 , java.util.Date D2,String company_id )
	{
		try
		{
			String query = "Select count(*) as groupcount from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id;
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			int groupcount=0;
				while(rs_g.next())
				{
					groupcount = rs_g.getInt("groupcount");
				}
				pstmt_g.close();

			String forlocal_purchaseSaleGroup_Id="";
			query ="SELECT * FROM Master_PurchaseSaleGroup  WHERE     (PurchaseSaleGroup_Type = 0) AND (Company_Id = "+company_id+") AND (PurchaseSaleGroup_Name ='Local')";
				pstmt_g =cong.prepareStatement(query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{
					forlocal_purchaseSaleGroup_Id= rs_g.getString("purchaseSaleGroup_Id");
				}
				pstmt_g.close();


		int pursaleGroupId[]= new int[groupcount];
		String pursaleGroupName[]= new String[groupcount];
		int pursaleGroupType[]= new int[groupcount];
		int c=0;
		query = "Select * from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id+" order by PurchaseSaleGroup_Name";
				pstmt_g =cong.prepareStatement(query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{
					pursaleGroupId[c] = rs_g.getInt("PurchaseSaleGroup_Id");
					pursaleGroupType[c] = rs_g.getInt("PurchaseSaleGroup_Type");
					pursaleGroupName[c] = rs_g.getString("PurchaseSaleGroup_Name");
					c++;
				}
				pstmt_g.close();
		
		String purchase_return_group="";
		String purchase_return_group_name="";
		String str_query="select PurchaseSaleGroup_Id,purchaseSaleGroup_Name from Master_PurchaseSaleGroup where purchaseSaleGroup_type=1 and purchaseSaleGroup_Name='Local' and  company_id="+company_id;
				pstmt_g =cong.prepareStatement(str_query);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next())
				{	purchase_return_group=rs_g.getString("PurchaseSaleGroup_Id");
				purchase_return_group_name=rs_g.getString("purchaseSaleGroup_Name");
				}
				pstmt_g.close();
		
			double Receive_Quantity = 0;
			double Local_Total = 0;
			double Dollar_Total = 0;
			String Receive_No="";
			double groupPurchaseReturnLocalAmount[]=new double[groupcount];
			double groupPurchaseReturnDollarAmount[]=new double[groupcount];
			int purreturncr=0,purreturndr=0;
			for(int im=0; im<groupcount; im++)
			{
				
				query="Select distinct(R.Receive_Id),R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Receive_Transaction RT where V.voucher_Date between ? and ? and R.Company_id=? and V.Voucher_Type=? and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)	and V.Active=1 and StockTransfer_type=0 and R.receive_id=RT.Receive_Id ";
				if(!(purchase_return_group.equals(""+pursaleGroupId[im])))
				{
					query=query+"and R.PurchaseSaleGroup_Id=0";
				}
				else
				{
					query=query+"and R.PurchaseSaleGroup_Id="+purchase_return_group;
				}
				//out.print("<br>Purchase 476 query" + query);
				pstmt_g = cong.prepareStatement(query);
				pstmt_g.setString(1,""+D1);
				pstmt_g.setString(2,""+D2);
				pstmt_g.setString(3,company_id); 
				pstmt_g.setString(4,"2"); //Purchase
				rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				Receive_No = rs_g.getString("Receive_No");
				Receive_Quantity = rs_g.getDouble("Receive_Quantity");
				Local_Total = rs_g.getDouble("InvLocalTotal");
				Dollar_Total = rs_g.getDouble("InvDollarTotal");
				groupPurchaseReturnLocalAmount[im]=groupPurchaseReturnLocalAmount[im]+Local_Total;
				groupPurchaseReturnDollarAmount[im]=groupPurchaseReturnDollarAmount[im]+Dollar_Total;
				//purchaseReturnQuantityTotal=purchaseReturnQuantityTotal+Receive_Quantity;
				//purchaseReturnLocalAmountTotal=purchaseReturnLocalAmountTotal+Local_Total;
				//purchaseReturnDollarAmountTotal=purchaseReturnDollarAmountTotal+Dollar_Total;
			}


			if(groupPurchaseReturnLocalAmount[im] != 0)
			{
							
				double PurReturnLocalAmount=groupPurchaseReturnLocalAmount[im];
				double PurReturnDollarAmount=groupPurchaseReturnDollarAmount[im];
				saleReturnAccounts SRAS=new saleReturnAccounts(purchase_return_group_name,PurReturnLocalAmount,PurReturnDollarAmount);

				 SRA.add(SRAS);

			}//end if


		}//for..

		}
		catch(Exception e)
		{
			System.out.println("Error Occure @ cloaingTrialBalance in getSaleReturn method"+e);
		}

		return SRA;

	}//getSaleReturnAccounts...........


	public String getPurchaseReturnAccounts(Connection cong,java.util.Date D1 , java.util.Date D2,String company_id123 )
	{
		try
		{

			String sales_return_group="";
			String sales_return_group_name="";

			String str_query="select PurchaseSaleGroup_Id,purchaseSaleGroup_Name from Master_PurchaseSaleGroup where purchaseSaleGroup_type=0 and purchaseSaleGroup_Name='HK_SalesR' and company_id="+company_id123;
			
			pstmt_g =cong.prepareStatement(str_query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				sales_return_group=rs_g.getString("PurchaseSaleGroup_Id");
				sales_return_group_name=rs_g.getString("purchaseSaleGroup_Name");
		
			}
			pstmt_g.close();
			
						
		double groupSalesRetLocalAmount=0;
		double groupSalesRetDollarAmount=0;
		
		int pursaleRetGroupId=0;
		String pursaleRetGroupName="";
		int pursaleRetGroupType=0;

			String query = "Select * from Master_PurchaseSaleGroup where Active=1 and Company_Id="+company_id123+" and PurchaseSaleGroup_Id="+sales_return_group;
			
			pstmt_g =cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
					pursaleRetGroupId = rs_g.getInt("PurchaseSaleGroup_Id");
					pursaleRetGroupType = rs_g.getInt("PurchaseSaleGroup_Type");
					pursaleRetGroupName = rs_g.getString("PurchaseSaleGroup_Name");
			}
			pstmt_g.close();
			
			double Receive_Quantity = 0;
			double Local_Total = 0;
			double Dollar_Total = 0;
	
			String Receive_No="";
			double groupSalesRetLocalAmount1=0;
			double groupSalesRetDollarAmount1=0;

			
			query="Select distinct(R.Receive_Id),R.Receive_No,R.Receive_Quantity, R.InvLocalTotal, R.InvDollarTotal from  Receive R, voucher V  ,Receive_Transaction RT where V.voucher_Date between ? and ? and R.Company_id=?	and V.Voucher_Type=? and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)	and V.Active=1 and StockTransfer_type=0 and R.receive_id=RT.Receive_Id and R.PurchaseSaleGroup_Id="+sales_return_group;
		
			
		//out.print("query" + query);
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString(1,""+D1);
			pstmt_g.setString(2,""+D2);
			pstmt_g.setString(3,company_id123); 
			pstmt_g.setString(4,"1"); //Sales
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next())
			{
				Receive_No = rs_g.getString("Receive_No");
				Local_Total = rs_g.getDouble("InvLocalTotal");
				Dollar_Total = rs_g.getDouble("InvDollarTotal");
				
				groupSalesRetLocalAmount=groupSalesRetLocalAmount+Local_Total;
				groupSalesRetDollarAmount=groupSalesRetDollarAmount+Dollar_Total;
				
			}
			if(groupSalesRetLocalAmount !=0)
			{

				String  pursaleGroupName11=pursaleRetGroupName;
				  groupSalesRetLocalAmount1=groupSalesRetLocalAmount;
				  groupSalesRetDollarAmount1=groupSalesRetDollarAmount;
				
				purReturnString = ""+pursaleGroupName11+","+groupSalesRetLocalAmount1+","+groupSalesRetDollarAmount1;	

			}// end if

	
		}//end try
		catch(Exception e)
		{
			System.out.println("Error Occure @ SalesAccount methods in ClosingTrialBalance"+e);
		}

		return purReturnString;
	}//getPurchaseAccounts()...

}
