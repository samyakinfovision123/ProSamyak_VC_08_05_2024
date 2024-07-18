package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class New_MemoIn 
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
	
	ArrayList CgtPurchaseArrayList1 = new ArrayList();//for Cgt Purchase
	ArrayList CgtPurchaseArrayList2 = new ArrayList();//for Cgt Purchase
	ArrayList finalArrayList = new ArrayList();//for collection of all 	                										Objects		
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
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
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return FTLocalAmountCrMap; //return HashMap for 											FTLocalAmountCr

	}//end HashMap getFTLocalAmountCr(Connection cong,String ctax_ledgerid, String company_id)
	
	public ArrayList getCgtPurchaseArray(Connection cong, String selectQuery1, String selectQuery2,String company_id, java.sql.Date D1, java.sql.Date D2, String str, String orderBy) throws Exception
	{
		try
		{
			errLine = 281;

			Array A = new Array(); 
			
			String ctax_ledgerid = A.getNameCondition(cong,"Ledger","ledger_id","where For_Head=17 and Ledger_Name='C. Tax' and company_id="+company_id);
			
			partyMap = getParty(cong,company_id);//HashMap for Party
			itemCategoryMap = getLotCategory(cong,company_id);//HashMap 											for LotCategory
			salespersonMap = getSalesperson(cong,company_id);//HashMap 										for Salesperson	
			referenceNoMap = getRefNo(cong,company_id);//HashMap 										for Ref No				
			ctaxTotalMap = getCTax(cong,ctax_ledgerid,company_id);//HashMap 													for C.Tax
			FTLocalAmountDrMap =
			getFTLocalAmountDr(cong,ctax_ledgerid,company_id);//HashMap 									for FTLocalAmountDr
			FTLocalAmountCrMap =getFTLocalAmountCr(cong,ctax_ledgerid,company_id);//HashMap for 										FTLocalAmountCr
			
			pstmt_g = cong.prepareStatement(selectQuery1);

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
				String receiveLot = rs_g.getString("Receive_Lots");

				java.sql.Date receiveDate = rs_g.getDate("Receive_Date"); 
				java.sql.Date stockDate = rs_g.getDate("Stock_Date"); 
				java.sql.Date dueDate = rs_g.getDate("Due_Date"); 

				String dueDays = rs_g.getString("Due_Days");
				String exchangeRate = rs_g.getString("Exchange_Rate");
				String receive_currencyId = rs_g.getString("Receive_CurrencyId"); 
				
				String currency = "";

				if("0".equals(receive_currencyId)) 
				{
					currency = "Dollar"; 

				}//end if receive_currencyId = 0
				else
				{
					currency = "Local"; 

				}//end else receive_currencyId = 0

				String narration = rs_g.getString("CgtDescription");

				if(rs_g.wasNull())
				{	
					narration = "---";

				}//end if rs_g.wasNull
				
				if(narration.equals(""))
					narration = "---";

				String category_id = rs_g.getString("Receive_Category");
				String category = (String)itemCategoryMap.get(category_id);
				
				if("".equals(category))
					category = "ALL";
				
				String refNo = "";
				
				if("Confirm".equals(str))
				{
					if(referenceNoMap.containsKey(receive_id))
					{	
						refNo = (String)referenceNoMap.get(receive_id);
					}//end if referenceNoMap.containsKey(receive_id)
					else
					{
						refNo = " - ";	
					}//end else
					
					refNo = rs_g.getString("CgtRef_No");

					if("".equals(refNo))
						refNo = " - ";
				}//end if str Confirm

				String SalesPerson_Id = rs_g.getString("SalesPerson_Id");
				
				String purchaseperson = "";

				if(salespersonMap.containsKey(SalesPerson_Id))
				{
					purchaseperson = (String) salespersonMap.get(SalesPerson_Id);
				}
				else
				{
					purchaseperson = "";
				}

				New_MemoInData Memo = new New_MemoInData(receive_id,party_id,party_name,receiveNo,receiveLot,receiveDate,stockDate,dueDate,dueDays,exchangeRate,currency,narration,category,refNo,purchaseperson,orderBy);
				
				CgtPurchaseArrayList1.add(id,Memo);
					
				id++;
		
			}//end while rs_g
			rs_g.close();
			pstmt_g.close();

			pstmt_g = cong.prepareStatement(selectQuery2);

			pstmt_g.setDate(1,D1);
			pstmt_g.setDate(2,D2);
			pstmt_g.setString(3,company_id);

			rs_g = pstmt_g.executeQuery();

			id = 0;

			while(rs_g.next())
			{
				String receive_id = rs_g.getString("Receive_Id"); 
				String Original_Qty = rs_g.getString("Original_Qty");
				String Return_Qty = rs_g.getString("Return_Qty");
				String Rejection_Qty = rs_g.getString("Rejection_Qty");
				String Qty = rs_g.getString("Qty");
				String rejection_Per = rs_g.getString("rejection_Per");
				String invLocalTotal = rs_g.getString("Local_Total");
				String invDollarTotal = rs_g.getString("Dollar_Total");
				
				New_MemoInData Memo = new New_MemoInData(receive_id,Original_Qty,Return_Qty,Rejection_Qty,Qty,rejection_Per,invLocalTotal,invDollarTotal);

				CgtPurchaseArrayList2.add(id,Memo);
					
				id++;
			}//end while rs_g
			rs_g.close();
			pstmt_g.close();

			if(CgtPurchaseArrayList1.size()==CgtPurchaseArrayList2.size())
			{
				for(int key1=0;key1<CgtPurchaseArrayList1.size();key1++ )
				{
					New_MemoInData Memo1 = (New_MemoInData)CgtPurchaseArrayList1.get(key1);
errLine = 432;
					for(int key2=0;key2<CgtPurchaseArrayList2.size();key2++ )
					{errLine = 432;
						New_MemoInData Memo2 = (New_MemoInData)CgtPurchaseArrayList2.get(key2);
						if(Memo1.getReceiveId().equals(Memo2.getReceiveId()))
						{
							New_MemoInData Memo = new New_MemoInData(Memo1.getReceiveId(),Memo1.getPartyId(),Memo1.getPartyName(),Memo1.getReceiveNo(),Memo1.getReceiveLot(),Memo1. getReceiveDate(),Memo1.getStockDate(),Memo1.getDueDate(),Memo1.getdueDays(),Memo1.getExchangeRate(),Memo1.getCurrency(),Memo1.getNarration(),Memo1.getCategory(),Memo1.getRefNo(),Memo2.getInvLocalTotal(),Memo2.getInvDollarTotal(),Memo1.getPurchaseperson(),Memo1.getOrderType(),Memo2.getOriginalQty(),Memo2.getReturnQty(),Memo2.getRejectionQty(),Memo2.getQuantity(),Memo2.getRejectionPer());
errLine = 439;
							finalArrayList.add(key1,Memo);	
							
						}//end if Memo1.getReceive_Id equals Memo2.getReceiveId
					}//end if for key2
				}//end if for key1
			}//end if for CgtPurchaseArrayList1.size equals CgtPurchaseArrayList2.size
			errLine = 445;
			New_CompareData comp = new New_CompareData();
			Collections.sort(finalArrayList, comp);
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return finalArrayList; //return ArrayList is collection of all 									Object that has a separate value
	
	}//end String getCgtPurchaseArray(Connection con, String selectQuery1, String selectQuery2 , String company_id, java.sql.Date D1, java.sql.Date D2, String str)

	public ArrayList getConfirmArray(Connection cong, String selectQuery1, String company_id, java.sql.Date D1, java.sql.Date D2, String str, String orderBy) throws Exception
	{
		try
		{
			errLine = 281;

			Array A = new Array(); 
			
			String ctax_ledgerid = A.getNameCondition(cong,"Ledger","ledger_id","where For_Head=17 and Ledger_Name='C. Tax' and company_id="+company_id);
			
			partyMap = getParty(cong,company_id);//HashMap for Party
			itemCategoryMap = getLotCategory(cong,company_id);//HashMap 											for LotCategory
			salespersonMap = getSalesperson(cong,company_id);//HashMap 										for Salesperson	
			referenceNoMap = getRefNo(cong,company_id);//HashMap 										for Ref No				
			ctaxTotalMap = getCTax(cong,ctax_ledgerid,company_id);//HashMap 													for C.Tax
			FTLocalAmountDrMap =
			getFTLocalAmountDr(cong,ctax_ledgerid,company_id);//HashMap 									for FTLocalAmountDr
			FTLocalAmountCrMap =getFTLocalAmountCr(cong,ctax_ledgerid,company_id);//HashMap for 										FTLocalAmountCr
			
			pstmt_g = cong.prepareStatement(selectQuery1);

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
				String receiveLot = rs_g.getString("Receive_Lots");
			
				java.sql.Date receiveDate = rs_g.getDate("Receive_Date"); 
				java.sql.Date stockDate = rs_g.getDate("Stock_Date"); 
				java.sql.Date dueDate = rs_g.getDate("Due_Date"); 

				String dueDays = rs_g.getString("Due_Days");
				String exchangeRate = rs_g.getString("Exchange_Rate");
				String receive_currencyId = rs_g.getString("Receive_CurrencyId"); 
				
				String currency = "";

				if("0".equals(receive_currencyId)) 
				{
					currency = "Dollar"; 

				}//end if receive_currencyId = 0
				else
				{
					currency = "Local"; 

				}//end else receive_currencyId = 0

				String narration = rs_g.getString("CgtDescription");

				if(rs_g.wasNull())
				{	
					narration = "---";

				}//end if rs_g.wasNull
				
				if(narration.equals(""))
					narration = "---";

				String category_id = rs_g.getString("Receive_Category");
				String category = (String)itemCategoryMap.get(category_id);
				
				if("".equals(category))
					category = "ALL";
				
				String refNo = "";
				
				if("Confirm".equals(str))
				{
					if(referenceNoMap.containsKey(receive_id))
					{	
						refNo = (String)referenceNoMap.get(receive_id);
					}//end if referenceNoMap.containsKey(receive_id)
					else
					{
						refNo = " - ";	
					}//end else
					
					refNo = rs_g.getString("CgtRef_No");

					if("".equals(refNo))
						refNo = " - ";
				}//end if str Confirm

				String SalesPerson_Id = rs_g.getString("SalesPerson_Id");

				String invLocalTotal = rs_g.getString("Local_Total");
				String invDollarTotal = rs_g.getString("Dollar_Total");
				
				String purchaseperson = "";

				if(salespersonMap.containsKey(SalesPerson_Id))
				{
					purchaseperson = (String) salespersonMap.get(SalesPerson_Id);
				}
				else
				{
					purchaseperson = "";
				}

				String Original_Qty = rs_g.getString("Original_Qty");
				String Return_Qty = rs_g.getString("Return_Qty");
				String Rejection_Qty = rs_g.getString("Rejection_Qty");
				String Qty = rs_g.getString("Qty");
				String rejection_Per = rs_g.getString("rejection_Per");

				double ghatQty = (Double.parseDouble(Original_Qty) - (Double.parseDouble(Return_Qty) + Double.parseDouble(Rejection_Qty) + Double.parseDouble(Qty))); 

				errLine = 296;
				/*if(referenceNoMap.containsKey(receive_id))
				{	
					refNo = (String)referenceNoMap.get(receive_id);
				}
				else
				{
					refNo = " - ";	
				}*/

				double ctax_amt=0;
				double ledger_total=0;
				double ledgerTotalDr = 0;
				double ledgerTotalCr = 0;

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
					ledgerTotalDr =	((Double)FTLocalAmountDrMap.get(receive_id)).doubleValue();
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
					
				New_MemoInData Memo = new New_MemoInData(receive_id, party_id, party_name, receiveNo, receiveLot, receiveDate, stockDate, dueDate, dueDays, exchangeRate, currency, narration, category, refNo, invLocalTotal, invDollarTotal, purchaseperson, orderBy, Original_Qty, Return_Qty, Rejection_Qty, Qty, ghatQty , rejection_Per, ledger_total);

				finalArrayList.add(id,Memo);
					
				id++;
		
			}//end while rs_g
			rs_g.close();
			pstmt_g.close();

			New_CompareData comp = new New_CompareData();
			Collections.sort(finalArrayList, comp);
		}//end try
		catch (Exception e)
		{
			System.out.println("Error in file New_MemoIn at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)

		return finalArrayList; //return ArrayList is collection of all 									Object that has a separate value
	
	}//end String getConfirmArray(Connection con, String selectQuery, String company_id, java.sql.Date D1, java.sql.Date D2, String str)

}//end class New_MemoIn


			
		
				
		
		
