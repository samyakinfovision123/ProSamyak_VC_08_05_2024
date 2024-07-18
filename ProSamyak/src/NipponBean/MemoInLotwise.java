package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class MemoInLotwise 
{
	private	PreparedStatement pstmt_g = null;
	private	PreparedStatement pstmt_g1 = null;
	private ResultSet rs_g = null;
	private ResultSet rs_g1 = null;

	double grand_ctax = 0;
	double grand_ledgerTotal=0;
	double Quantity=0;
	double Available_Quantity=0;
	double Return_Quantity=0;
	double totalPurchaseQty =0;
	double totalReturnQty = 0;
	double add_totret=0;
	double totalPendingQty = 0;

	HashMap itemCategoryMap = new HashMap();
	HashMap salespersonMap = new HashMap();
	HashMap referenceNoMap = new HashMap();
	HashMap partyMap = new HashMap();
	HashMap ctaxTotalMap = new HashMap();
	HashMap FTLocalAmountDrMap = new HashMap();
	HashMap FTLocalAmountCrMap = new HashMap();
	HashMap CgtPurchaseConfirmMap = new HashMap();//for Cgt 														Purchase Confirm 		
	HashMap CgtPurchaseReturnMap = new HashMap();//for Cgt 														Purchase Return 

	ArrayList CgtPurchaseArrayList = new ArrayList();//for Cgt 													Purchase
	ArrayList finalArrayList = new ArrayList();//for collection 										of all Objects		
	ArrayList finalArrayList1 = new ArrayList();//for collection 										of all Objects		
	
	String mapQuery = "";
	
	int errLine = 39;
		
	public HashMap getParty(Connection cong,String company_id)
	{
		try
		{
			//get the company party 

			mapQuery = "select CompanyParty_Id, CompanyParty_Name from Master_CompanyParty where Active=1 and company_id="+company_id+" order by CompanyParty_Id"; 

			pstmt_g = cong.prepareStatement(mapQuery);

			rs_g = pstmt_g.executeQuery();

			partyMap.put("0", "");

			while(rs_g.next())
			{
				String id = rs_g.getString("CompanyParty_Id");
				String name = rs_g.getString("CompanyParty_Name");

				partyMap.put(id, name);
			}//end of while
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return partyMap; //return HashMap of Party Name

	}//end HashMap getParty(String company_id)

	public HashMap getRefNo(Connection cong,String company_id)
	{
		try
		{
			//get the Ref No 

			mapQuery = "select Ref_No, Voucher_No from Voucher where (Voucher_Type=1 OR Voucher_Type=2) and Active=1 and company_id="+company_id+"";

			pstmt_g =cong.prepareStatement(mapQuery);
			rs_g = pstmt_g.executeQuery();

			referenceNoMap.put("0", "");

			while(rs_g.next())
			{
				String refNo = rs_g.getString("Ref_No");
				String receiveId = rs_g.getString("Voucher_No");

				referenceNoMap.put(receiveId, refNo);
			}//end of while

			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return referenceNoMap; //return HashMap of Ref No

	}//end HashMap getRefNo(Connection cong, String company_id)

	public HashMap getLotCategory(Connection cong,String company_id)
	{
		try
		{
			//get the lot category

			mapQuery = "select LotCategory_Id, LotCategory_Name from Master_LotCategory where Active=1 and company_id="+company_id+" order by LotCategory_Id"; 

			pstmt_g =cong.prepareStatement(mapQuery);

			rs_g = pstmt_g.executeQuery();

			itemCategoryMap.put("0", "");

			while(rs_g.next())
			{
				String id = rs_g.getString("LotCategory_Id");
				String name = rs_g.getString("LotCategory_Name");
				
				itemCategoryMap.put(id, name);

			}//end of while
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return itemCategoryMap; //return HashMap of Lot Category Name

	}//end HashMap getLotCategory(Connection cong, String company_id)
	
	public HashMap getSalesperson(Connection cong,String company_id)
	{
		try
		{
			//get the salesperson

			mapQuery = "select Salesperson_Id, Salesperson_Name from Master_Salesperson where Active=1 and company_id="+company_id+" order by Salesperson_Id"; 
			
			pstmt_g =cong.prepareStatement(mapQuery);
			
			rs_g = pstmt_g.executeQuery();

			salespersonMap.put("0", "");

			while(rs_g.next())
			{
				String id = rs_g.getString("Salesperson_Id");
				String name = rs_g.getString("Salesperson_Name");
				
				salespersonMap.put(id, name);

			}//end of while
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return salespersonMap; //return HashMap for Salesperson Name

	}//end HashMap getSalesperson(Connection cong, String company_id)
	
	public HashMap getCTax(Connection cong,String ctax_ledgerid, String company_id)
	{
		try
		{
			//calculate the ctax and store it in the HashMap
			
			String ctaxQuery="select Receive_Id, Sum(Local_Amount) as ctaxLocalAmount from Financial_Transaction where Active=1 and Receive_Id<>0 and Ledger_Id="+ctax_ledgerid+" and company_id="+company_id+" group by Receive_Id order by Receive_Id"; 
			
			pstmt_g = cong.prepareStatement(ctaxQuery);
			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				String receiveId = rs_g.getString("Receive_Id");
				Double ctaxAmt = new Double(rs_g.getDouble("ctaxLocalAmount"));
				
				ctaxTotalMap.put(receiveId, ctaxAmt);
			
			}//end of while
			rs_g.close();
			pstmt_g.close();
		
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return ctaxTotalMap; //return HashMap of C.Tax

	}//end HashMap getCTax(Connection cong,String ctax_ledgerid, 		String company_id)

	public HashMap getFTLocalAmountDr(Connection cong,String ctax_ledgerid,String company_id)
	{
		try
		{
			//calculate the other ledgers whose values to be added and store it in the HashMap
			
			String FTLocalAmountDrQuery="select Receive_Id, Sum(Local_Amount) as addAmount from Financial_Transaction where Active=1 and Transaction_Type=0 and Receive_Id<>0 and Ledger_Id<>"+ctax_ledgerid+" and company_id="+company_id+" group by Receive_Id order by Receive_Id"; 
			
			pstmt_g =cong.prepareStatement(FTLocalAmountDrQuery);
			
			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				String receiveId = rs_g.getString("Receive_Id");
				Double localAmt = new Double(rs_g.getDouble("addAmount"));

				FTLocalAmountDrMap.put(receiveId, localAmt);

			}//end of while
			rs_g.close();
			pstmt_g.close();
		
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return FTLocalAmountDrMap; //return HashMap for 											FTLocalAmountDr

	}//end HashMap getFTLocalAmountDr(Connection cong,String ctax_ledgerid,String company_id)

	public HashMap getFTLocalAmountCr(Connection cong,String ctax_ledgerid, String company_id)
	{
		try
		{
			//calculate the other ledgers whose values to be deleted and store it in the HashMap
			
			String FTLocalAmountCrQuery="select Receive_Id, Sum(Local_Amount) as deleteAmount from Financial_Transaction where Active=1 and Transaction_Type=1 and Receive_Id<>0 and Ledger_Id<>"+ctax_ledgerid+" and company_id="+company_id+" group by Receive_Id order by Receive_Id"; 
			
			pstmt_g =cong.prepareStatement(FTLocalAmountCrQuery);
			
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next())
			{
				String receiveId = rs_g.getString("Receive_Id");
				Double localAmt = new Double(rs_g.getDouble("deleteAmount"));
			
				FTLocalAmountCrMap.put(receiveId, localAmt);
			
			}//end of while
			rs_g.close();
			pstmt_g.close();
			
		
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return FTLocalAmountCrMap; //return HashMap for 											FTLocalAmountCr

	}//end HashMap getFTLocalAmountCr(Connection cong,String ctax_ledgerid, String company_id)
	
	public ArrayList getCgtPurchaseArray(Connection cong, String selectQuery, String company_id, java.sql.Date D1, java.sql.Date D2, String str, String orderBy) throws Exception
	{
		try
		{
			errLine = 39;

			Array A = new Array(); 
			
			String ctax_ledgerid = A.getNameCondition(cong,"Ledger","ledger_id","where For_Head=17 and Ledger_Name='C. Tax' and company_id="+company_id);
			
			partyMap = getParty(cong,company_id);//HashMap for Party
			itemCategoryMap = getLotCategory(cong,company_id);//HashMap 											for LotCategory
			salespersonMap = getSalesperson(cong,company_id);//HashMap 										for Salesperson	
			referenceNoMap = getRefNo(cong,company_id);//HashMap 										for Ref No			
			
			ctaxTotalMap = getCTax(cong,ctax_ledgerid,company_id);//HashMap 													for C.Tax
			FTLocalAmountDrMap =
			getFTLocalAmountDr(cong,ctax_ledgerid,company_id);//HashMap 									for FTLocalAmountDr
			FTLocalAmountCrMap =getFTLocalAmountCr(cong,ctax_ledgerid,company_id);//HashMa									p for FTLocalAmountCr
			pstmt_g = cong.prepareStatement(selectQuery);

			pstmt_g.setDate(1,D1);
			pstmt_g.setDate(2,D2);
			pstmt_g.setString(3,company_id);

			rs_g = pstmt_g.executeQuery();

			int id = 0;

			while(rs_g.next())
			{
				String receive_id = rs_g.getString("Receive_Id"); 
				String party_id = rs_g.getString("Receive_FromId");
				String party_name = (String)partyMap.get(party_id);
				String receiveNo = rs_g.getString("Receive_No");
				String lotNo = rs_g.getString("Lot_No");
				String receiveLot = rs_g.getString("Receive_Lots");
			
				String qty = rs_g.getString("Quantity");
				String invLocalRate = rs_g.getString("Local_Price");	String invDollarRate = rs_g.getString("Dollar_Price");					
				double invLocalTotal = Double.parseDouble(invLocalRate) * Double.parseDouble(qty);
				
				String newinvLocalTotal = ""+invLocalTotal;
				
				double invDollarTotal = Double.parseDouble(invDollarRate) * Double.parseDouble(qty);
				
				String newinvDollarTotal = ""+invDollarTotal;
				
				java.sql.Date receiveDate = rs_g.getDate("Receive_Date"); 
				java.sql.Date stockDate = rs_g.getDate("Stock_Date"); 
				java.sql.Date dueDate = rs_g.getDate("Due_Date"); 
				
				String dueDays = rs_g.getString("Due_Days");
				String exchangeRate = rs_g.getString("Exchange_Rate");
				String receive_currencyId = rs_g.getString("Receive_CurrencyId"); 
				String SalesPerson_Id = rs_g.getString("SalesPerson_Id");
				String currency = "";

				if("0".equals(receive_currencyId)) 
				{
					currency = "Dollar"; 

				}//end if receive_currencyId = 0
				else
				{
					currency = "Local"; 

				}//end else receive_currencyId = 0

				String narration = rs_g.getString("Remarks");

				if(rs_g.wasNull())
				{	
					narration = "";

				}//end if rs_g.wasNull

				String purchaseperson = "";
				
				if(salespersonMap.containsKey(SalesPerson_Id))
				{
					purchaseperson = (String) salespersonMap.get(SalesPerson_Id);
				}
				else
				{
					purchaseperson = "";
				}
								
				String category_id = rs_g.getString("Receive_Category");
				String category = (String)itemCategoryMap.get(category_id);
				
				if("".equals(category))
					category = "ALL";
				
				String refNo = "";

				double ctax_amt=0;
				double ledger_total=0;
				double ledgerTotalDr = 0;
				double ledgerTotalCr = 0;
								
				if("Confirm".equals(str))
				{
					
					errLine = 296;
					if(referenceNoMap.containsKey(receive_id))
					{	
						refNo = (String)referenceNoMap.get(receive_id);
					}
					else
					{
						refNo = " - ";	
					}

					if(ctaxTotalMap.containsKey(receive_id))
					{
						ctax_amt =((Double)ctaxTotalMap.get(receive_id)).doubleValue();
					}
					else
					{
						ctax_amt = 0;
					}
					grand_ctax += ctax_amt;
					
					if(FTLocalAmountDrMap.containsKey(receive_id))
					{
						ledgerTotalDr =					((Double)FTLocalAmountDrMap.get(receive_id)).doubleValue();
					}
					else
					{
						ledgerTotalDr = 0;
					}
					if(FTLocalAmountCrMap.containsKey(receive_id))
					{
						ledgerTotalCr =((Double)FTLocalAmountCrMap.get(receive_id)).doubleValue();
					}
					else
					{
						ledgerTotalCr = 0;
					}
					
					ledger_total = ledgerTotalDr - ledgerTotalCr;
					
				}//end if str=Confirm
				else
				{
					errLine = 308;
					refNo = rs_g.getString("CgtRef_No");

					if("".equals(refNo))
					refNo = " - ";
				
				}//end else str=Confirm
				//System.out.println("orderBy="+orderBy);				
				MemoInData Memo = new MemoInData(party_id,party_name,receive_id,receiveNo,receiveLot, qty,invLocalRate,newinvLocalTotal,invDollarRate,newinvDollarTotal,receiveDate,dueDate,stockDate,dueDays,purchaseperson,exchangeRate,currency,category,narration,refNo,orderBy,ledger_total,lotNo);

				finalArrayList.add(id,Memo);
					
				id++;
		
			}//end while rs_g
			pstmt_g.close();
			
			CompareData comp = new CompareData();
			Collections.sort(finalArrayList, comp);
								
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return finalArrayList; //return ArrayList is collection of all 						Object that has a separate value
	
	}//end String getCgtPurchaseArray(Connection con, String selectQuery, String company_id, java.sql.Date D1, java.sql.Date D2, String str)


	public ArrayList getCgtAnalysisArray(Connection cong, String selectQuery, String company_id, java.sql.Date D1, java.sql.Date D2, String str, String orderBy) throws Exception
	{
		try
		{
			errLine = 443;
			partyMap = getParty(cong,company_id);//HashMap for Party
			itemCategoryMap = getLotCategory(cong,company_id);//HashMap 											for LotCategory
			salespersonMap = getSalesperson(cong,company_id);//HashMap 										for Salesperson	
			referenceNoMap = getRefNo(cong,company_id);//HashMap 												for Ref No	
			String selectQuery1 = "Select * from " + selectQuery; 
			
			selectQuery1 = selectQuery1 + " order by R.Receive_Id";
			
			pstmt_g = cong.prepareStatement(selectQuery1);

			pstmt_g.setDate(1,D1);
			pstmt_g.setDate(2,D2);
			pstmt_g.setString(3,company_id);

			rs_g = pstmt_g.executeQuery();

			int id = 0;

			while(rs_g.next())
			{
				String ReceiveTransaction_Id = rs_g.getString("ReceiveTransaction_Id");
				String receive_id = rs_g.getString("Receive_Id"); 
				String party_id = rs_g.getString("Receive_FromId");
				String party_name = (String)partyMap.get(party_id);
				String receiveNo = rs_g.getString("Receive_No");
				String receiveLot = rs_g.getString("Receive_Lots");
				String lot_No = rs_g.getString("Lot_No");
				String qty =rs_g.getString("Quantity");
				String Available_Quantity = rs_g.getString("Available_Quantity");
				String Return_Quantity = rs_g.getString("Return_Quantity");
				String invLocalTotal1 = rs_g.getString("Local_Total");	
				String invDollarTotal1 = rs_g.getString("Dollar_Total");					
				String invDollarTotal = rs_g.getString("Dollar_Price");					
				String invLocalTotal = rs_g.getString("Local_Price");					
				java.sql.Date receiveDate = rs_g.getDate("Receive_Date"); 
				java.sql.Date stockDate = rs_g.getDate("Stock_Date"); 
				java.sql.Date dueDate = rs_g.getDate("Due_Date"); 
				
				String dueDays = rs_g.getString("Due_Days");
				String exchangeRate = rs_g.getString("Exchange_Rate");
				String receive_currencyId = rs_g.getString("Receive_CurrencyId"); 
				String SalesPerson_Id = rs_g.getString("SalesPerson_Id");
				String currency = "";

				if("0".equals(receive_currencyId)) 
				{
					currency = "Dollar"; 

				}//end if receive_currencyId = 0
				else
				{
					currency = "Local"; 

				}//end else receive_currencyId = 0

				String narration = rs_g.getString("Remarks");

				if(rs_g.wasNull())
				{	
					narration = "--";

				}//end if rs_g.wasNull
				String purchaseperson = "";
				
				if(salespersonMap.containsKey(SalesPerson_Id))
				{
					purchaseperson = (String) salespersonMap.get(SalesPerson_Id);
				}
				else
				{
					purchaseperson = "";
				}
								
				String category_id = rs_g.getString("Receive_Category");
				String category = (String)itemCategoryMap.get(category_id);
				
				if("".equals(category))
					category = "ALL";
				
				String refNo = refNo = rs_g.getString("CgtRef_No");

				if("".equals(refNo))
					refNo = " - ";
				
				double ledger_total = 0;

				MemoInData Memo = new MemoInData(party_id,party_name,ReceiveTransaction_Id,receive_id,receiveNo,receiveLot,lot_No,qty,invLocalTotal,invDollarTotal,receiveDate,dueDate,stockDate,dueDays,purchaseperson,exchangeRate,currency,category,narration,refNo,orderBy,ledger_total);
				
				CgtPurchaseArrayList.add(id,Memo);
					
				id++;
		
			}//end while rs_g
			pstmt_g.close();

			String selectQuery2 = "Select Receivetransaction_id from " + selectQuery; 
			
			String query = "Select RT.Consignment_ReceiveId,sum(RT.Quantity)as totalPurchaseQuantity from  Receive R, Receive_Transaction RT  where  R.Active=1 and R.Receive_Id=RT.Receive_Id and R.Purchase=1 and RT.Active=1 and RT.consignment_ReceiveId in (" + selectQuery2 + ") group by RT.Consignment_ReceiveId order by RT.Consignment_ReceiveId";

			pstmt_g = cong.prepareStatement(query);

			pstmt_g.setDate(1,D1);
			pstmt_g.setDate(2,D2);
			pstmt_g.setString(3,company_id);

			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				String Consignment_ReceiveId = rs_g.getString("Consignment_ReceiveId");
				double qty = rs_g.getDouble("totalPurchaseQuantity");
				
				CgtPurchaseConfirmMap.put(Consignment_ReceiveId,qty);
			}
			pstmt_g.close();

			query = "Select RT.Consignment_ReceiveId,sum(RT.Quantity) as totalReturnQuantity from  Receive R, Receive_Transaction RT where R.Active=1 and R.Receive_Id=RT.Receive_Id and R.Purchase=0 and RT.Active=1 and RT.consignment_ReceiveId in (" + selectQuery2 + ") group by RT.Consignment_ReceiveId order by RT.Consignment_ReceiveId";

			pstmt_g = cong.prepareStatement(query);

			pstmt_g.setDate(1,D1);
			pstmt_g.setDate(2,D2);
			pstmt_g.setString(3,company_id);

			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				String Consignment_ReceiveId = rs_g.getString("Consignment_ReceiveId");
				double qty = rs_g.getDouble("totalReturnQuantity");
				
				CgtPurchaseReturnMap.put(Consignment_ReceiveId,qty);

			}
			pstmt_g.close();
					
			for(int key = 0; key<CgtPurchaseArrayList.size(); key++)
			{	
				double invLocalTotal = 0;
				double invDollarTotal = 0;
				double totalPurchaseQty = 0;
				double totalReturnQty = 0;
				double totalPendingQty = 0;

				String newinvLocalTotal = "";
				String newinvDollarTotal = "";
			
				MemoInData obj1 = (MemoInData)CgtPurchaseArrayList.get(key);

				String partyId = obj1.getPartyId();
				String partyName = obj1.getPartyName();
				String receiveTransactionId = obj1.getReceiveTransactionId();
				String receiveId = obj1.getReceiveId();
				String receiveNo = obj1.getReceiveNo();
				String receiveLot = obj1.getReceiveLot();
				String lotNo = obj1.getLotNo();
				String newtotalQty = obj1.getQuantity();
				String invLocalRate = obj1.getInvLocalTotal();
				String invDollarRate = obj1.getInvDollarTotal();

				java.sql.Date receiveDate = obj1.getReceiveDate();
				java.sql.Date stockDate = obj1.getStockDate();
				java.sql.Date dueDate = obj1.getDueDate();
				
				String dueDays = obj1.getdueDays();
				String purchaseperson = obj1.getPurchaseperson();
				String exchangeRate = obj1.getExchangeRate();
				String currency = obj1.getCurrency();
				String category = obj1.getCategory();
				String narration = obj1.getNarration();
				String refNo = obj1.getRefNo();
				String orderType = obj1.getOrderType();

				if(CgtPurchaseConfirmMap.containsKey(obj1.getReceiveTransactionId()))
					totalPurchaseQty = ((Double)CgtPurchaseConfirmMap.get(obj1.getReceiveTransactionId())).doubleValue();
				else
					totalPurchaseQty = 0;

				if(CgtPurchaseReturnMap.containsKey(obj1.getReceiveTransactionId()))
					totalReturnQty = ((Double)CgtPurchaseReturnMap.get(obj1.getReceiveTransactionId())).doubleValue();
				else
					totalReturnQty = 0;
	
				totalPendingQty = Double.parseDouble(newtotalQty) - (totalPurchaseQty + totalReturnQty);

				invLocalTotal = Double.parseDouble(invLocalRate) * totalPendingQty;
				newinvLocalTotal = "" + invLocalTotal;

				invDollarTotal = Double.parseDouble(invDollarRate) * totalPendingQty;
				newinvDollarTotal = "" + invDollarTotal;
	
				MemoInData Memo = new MemoInData(partyId,partyName,receiveTransactionId,receiveId,receiveNo,receiveLot,lotNo,newtotalQty,invLocalRate,newinvLocalTotal,invDollarRate,newinvDollarTotal,receiveDate,stockDate,dueDate,dueDays,purchaseperson,exchangeRate,currency,category,narration,refNo,orderType,totalPurchaseQty,totalReturnQty,totalPendingQty);

				finalArrayList.add(key,Memo);

				
			}//end for i

			if("Pending".equals(str))
			{
				int keyValue = 0;
				for(int k = 0; k<finalArrayList.size(); k++)
				{
					MemoInData Memo1 = (MemoInData)	finalArrayList.get(k);

					if(Memo1.getTotalPendingQty() >= 0.0001 || Memo1.getTotalPendingQty() <= -0.0001)
					{
						finalArrayList1.add(keyValue,Memo1);
						keyValue++;
					}
				}

				CompareData comp = new CompareData();
				Collections.sort(finalArrayList1, comp);
			}
			else
			{
				CompareData comp = new CompareData();
				Collections.sort(finalArrayList, comp);
			}			
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file MemoInLotwise at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		if("Pending".equals(str))
		{
			return finalArrayList1; //return ArrayList is collection 			of all Object that has a separate value
		}
		else
		{
			return finalArrayList; //return ArrayList is collection 				of all Object that has a separate value
		}
	
	}//end String getCgtAnalysisArray(Connection con, String selectQuery, String company_id, java.sql.Date D1, java.sql.Date D2, String str)

}//end class MemoInLotwise


			
		
				
		
		
