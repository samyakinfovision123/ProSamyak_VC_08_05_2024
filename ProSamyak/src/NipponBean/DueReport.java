package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
import NipponBean.*;

public class DueReport
{
	
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	List Master_Salesperson = new ArrayList();
	List Master_CompanyParty = new ArrayList();
	List Master_PurchaseSaleGroup = new ArrayList();
	
	ResultSet rs = null;
	ResultSet rs_p = null;
	ResultSet rs_g = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt_p = null;
	PreparedStatement pstmt_g = null;

	///////////////////////////////////////////////////////
	//Start : method to load company names and salesperson
	//names and PurchaseSaleGroupName
	///////////////////////////////////////////////////////
	public void loadMasters(Connection con)
	{
		String errLine = "25";

		try{
			//loading the Master_Salesperson and Master_CompanyParty tables data for particulars
			errLine = "29";
			String query = "Select CompanyParty_Name from Master_CompanyParty";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				Master_CompanyParty.add(rs.getString("CompanyParty_Name"));
			}
			rs.close();
			pstmt.close();
			errLine = "39";

			query = "Select Salesperson_Name from Master_Salesperson";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				Master_Salesperson.add(rs.getString("Salesperson_Name"));
			}
			rs.close();
			pstmt.close();
			errLine = "50";


			query = "Select PurchaseSaleGroup_Name from Master_PurchaseSaleGroup";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				Master_PurchaseSaleGroup.add(rs.getString("PurchaseSaleGroup_Name"));
			}
			rs.close();
			pstmt.close();
			errLine = "63";
		}
		catch(Exception e)
		{
			System.out.println("Exception in loadMasters() in DueReport after Line:"+errLine+" is "+e);
		}

	}
	//////////////////////////////////////////////////////
	//End : method to load company names and salesperson
	//names
	//////////////////////////////////////////////////////


	public ArrayList getDueReportRows(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "79";
		//System.out.println("83 Inside getOverDueReportRows");


		ArrayList report = new ArrayList();
		GetDate G = new GetDate();
		try{
			String condition="";
			
			//condition for sale/purchase
			if(type.equals("10"))
			{
				condition=" and purchase=1 and receive_sell=1 and R_Return=0 and active=1 ";
			}
			else
			{
				condition=" and purchase=1 and receive_sell=0 and R_Return=0 and active=1";
			}

			//condition for date type
			String datecondn = "";
			if(datecondition.equals("invoicedate"))
			{
				datecondn=" and receive_date between ? and ? ";
			}
			else
			{
				datecondn=" and due_date between ? and ? ";
			}


			//Query calculating the Due Report from fromDate to tillDate
			
			String query=" select * from Receive where company_id="+ company_id +" "+datecondn+"  " + condition;

			if("0".equals(companyparty_id))//for All parties
			{}
			else//Not for All
			{
				query=query+ " and Receive_FromId IN ("+ companyparty_id +" )" ;
			}

			if("0".equals(sentsalesperson_id))//for All salespersons
			{}
			else//Not for All
			{
				query=query+ " and salesperson_id="+ sentsalesperson_id ;
			}

			if("0".equals(sentpurchasesalegroup_id))//for All purchasesalegroup
			{}
			else//Not for All
			{
				query=query+ " and purchasesalegroup_id="+ sentpurchasesalegroup_id ;
			}


			query=query + "  order by "+orderby ;	

			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString (1,""+fromDate);	
			pstmt_g.setString (2,""+tillDate);		
		
		System.out.println("<br>144 query = "+query);

			rs_g = pstmt_g.executeQuery();
			errLine = "141";

			while(rs_g.next())
			{
				int receive_id=rs_g.getInt("Receive_Id");
				String receive_no=rs_g.getString("receive_no");
				int Receive_CurrencyId=rs_g.getInt("Receive_CurrencyId");
				int Receive_fromid=rs_g.getInt("Receive_fromid");
				java.sql.Date Receive_Date=rs_g.getDate("Receive_Date");
				int duedays = rs_g.getInt("due_days");
				java.sql.Date Due_Date=rs_g.getDate("Due_Date");
				double Receive_Total=rs_g.getDouble("Receive_Total");
				double Local_Total=rs_g.getDouble("Local_Total");
				double Dollar_Total=rs_g.getDouble("Dollar_Total");
				int salesperson_id = rs_g.getInt("Salesperson_Id");
				int purchasesalegroup_id = rs_g.getInt("purchasesalegroup_id");
				
				String Company_Party_Name = (String)Master_CompanyParty.get( (Receive_fromid - 1) );
				String Salesperson_Name = (String)Master_Salesperson.get( (salesperson_id - 1) );
				String PurchaseSaleGroup_Name = "";
				if(purchasesalegroup_id == 0 )
				{}
				else
				{
					PurchaseSaleGroup_Name = (String)Master_PurchaseSaleGroup.get( (purchasesalegroup_id - 1) );
				}
		
				int overduedays = Integer.parseInt(G.getDueDays(format.format(Due_Date), format.format(D)));

				String refno = "";

				String refQuery = "Select Ref_No from Voucher where Voucher_No='"+receive_id+"'";
				pstmt_p = conp.prepareStatement(refQuery);
				rs_p = pstmt_p.executeQuery();

				while(rs_p.next())
				{
					refno=rs_p.getString("Ref_No");
					if(rs_p.wasNull())
						refno="";
				}
				pstmt_p.close();

				errLine = "183";
				//subquery for getting any received amount
				String query1=" select pd.Payment_No, pd.Amount, pd.Local_Amount, pd.Dollar_Amount from  Payment_Details pd where pd.For_HeadId=" + receive_id + " and pd.For_Head=" + type+" and  pd.Transaction_Date <= ? and pd.active=1 " ;

				//out.print("<br>query1-->"+query1);
				pstmt_p = conp.prepareStatement(query1);
				pstmt_p.setString(1, ""+tillDate);
				rs_p = pstmt_p.executeQuery();

				double total_Amount=0;
				double total_Local_Amount=0;
				double total_Dollar_Amount=0;

				while(rs_p.next())
				{
					String Payment_No=rs_p.getString("Payment_No");
					double Amount=rs_p.getDouble("Amount");
					double Local_Amount=rs_p.getDouble("Local_Amount");
					double Dollar_Amount=rs_p.getDouble("Dollar_Amount");
					total_Amount=total_Amount+Amount;
					total_Local_Amount=total_Local_Amount+Local_Amount;

					total_Dollar_Amount=total_Dollar_Amount+Dollar_Amount;

					errLine = "207";
				}//end of inner while
				pstmt_p.close();

				double outstanding_local =(Local_Total-total_Local_Amount);

				double outstanding_dollar =(Dollar_Total-total_Dollar_Amount);
if(( (Receive_CurrencyId !=0) &&  (str.mathformat(outstanding_local,3) >= 0.009))
||
((Receive_CurrencyId ==0) && (str.mathformat(outstanding_dollar,3)>= 0.009)))
			{
//System.out.println("224 Receive_CurrencyId="+Receive_CurrencyId+" outstanding_local"+str.mathformat(outstanding_local,3)+" outstanding_dollar"+str.mathformat(outstanding_dollar,3));	


//				if(str.mathformat(outstanding_dollar, 3) != 0 && str.mathformat(outstanding_local, 3) != 0)
//				{
					DueReportRow DRR = new DueReportRow(receive_id, receive_no, Receive_fromid, Receive_Date, duedays, Due_Date, overduedays, Receive_Total, Local_Total, Dollar_Total, salesperson_id, Company_Party_Name,	Salesperson_Name, total_Local_Amount, total_Dollar_Amount, outstanding_local, outstanding_dollar, refno, purchasesalegroup_id, PurchaseSaleGroup_Name);

					report.add(DRR);
				}
				errLine = "221";

			}//end outer while
			pstmt_g.close();
			errLine = "225";
			
		}
		catch(Exception e)
		{
			System.out.println("Exception in getDueReportRows() in DueReport after Line:"+errLine+" is "+e);
		}
		return report;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report rows
	//////////////////////////////////////////////////////


	public ArrayList getOverDueReportRows(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "241";
		ArrayList report = new ArrayList();
		GetDate G = new GetDate();
		try{
			String condition="";
			
			//condition for sale/purchase
			if(type.equals("10"))
			{
				condition=" and purchase=1 and receive_sell=1 and R_Return=0 and active=1 ";
			}
			else
			{
				condition=" and purchase=1 and receive_sell=0 and R_Return=0 and active=1";
			}

			//condition for date type
			String datecondn = "";
			if(datecondition.equals("invoicedate"))
			{
				datecondn=" and receive_date < ?";
			}
			if(datecondition.equals("duedate"))
			{
				datecondn=" and due_date < ?";
			}


			//Query calculating the Over Due Report till tillDate
			String query=" select * from Receive where company_id="+ company_id +"  "+datecondn+" and StockTransfer_Type=0 " + condition;

			if("0".equals(companyparty_id))//for All parties
			{}
			else//Not for All
			{
				query=query+ " and Receive_FromId IN ("+ companyparty_id +")" ;
			}

			if("0".equals(sentsalesperson_id))//for All salespersons
			{}
			else//Not for All
			{
				query=query+ " and salesperson_id="+ sentsalesperson_id ;
			}

			if("0".equals(sentpurchasesalegroup_id))//for All purchasesalegroup
			{}
			else//Not for All
			{
				query=query+ " and purchasesalegroup_id="+ sentpurchasesalegroup_id ;
			}


			query=query + "  order by "+orderby ;	

			//System.out.print("<br>query="+query);
			//get the overdues till the from date and their payments upto the till date
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString (1,""+fromDate);	
			//System.out.print("<br>173 fromDate"+fromDate);

			rs_g = pstmt_g.executeQuery();
			errLine = "303";
			while(rs_g.next())
			{
				int receive_id=rs_g.getInt("Receive_Id");
				String receive_no=rs_g.getString("receive_no");
				int Receive_CurrencyId=rs_g.getInt("Receive_CurrencyId");
				int Receive_fromid=rs_g.getInt("Receive_fromid");
				java.sql.Date Receive_Date=rs_g.getDate("Receive_Date");
				int duedays = rs_g.getInt("due_days");
				java.sql.Date Due_Date=rs_g.getDate("Due_Date");
				double Receive_Total=rs_g.getDouble("Receive_Total");
				double Local_Total=rs_g.getDouble("Local_Total");
				double Dollar_Total=rs_g.getDouble("Dollar_Total");
				int salesperson_id = rs_g.getInt("Salesperson_Id");
				int purchasesalegroup_id = rs_g.getInt("purchasesalegroup_id");
		
				String Company_Party_Name = (String)Master_CompanyParty.get( (Receive_fromid - 1) );
				String Salesperson_Name = (String)Master_Salesperson.get( (salesperson_id - 1) );
				String PurchaseSaleGroup_Name = "";
				if(purchasesalegroup_id == 0 )
				{}
				else
				{
					PurchaseSaleGroup_Name = (String)Master_PurchaseSaleGroup.get( (purchasesalegroup_id - 1) );
				}
		
				int overduedays = Integer.parseInt(G.getDueDays(format.format(Due_Date), format.format(D)));

				String refno = "";

				String refQuery = "Select Ref_No from Voucher where Voucher_No='"+receive_id+"'";
				pstmt_p = conp.prepareStatement(refQuery);
				rs_p = pstmt_p.executeQuery();

				while(rs_p.next())
				{
					refno=rs_p.getString("Ref_No");
					if(rs_p.wasNull())
						refno="";
				}
				pstmt_p.close();

				errLine = "344";
				//subquery for getting any received amount
				String query1=" select pd.Payment_No, pd.Amount, pd.Local_Amount, pd.Dollar_Amount from  Payment_Details pd where pd.For_HeadId=" + receive_id + " and pd.For_Head=" + type+" and  pd.Transaction_Date <= ? and pd.active=1" ;

				//out.print("<br>query1-->"+query1);
				pstmt_p = conp.prepareStatement(query1);
				pstmt_p.setString(1, ""+tillDate);
				rs_p = pstmt_p.executeQuery();

				double total_Amount=0;
				double total_Local_Amount=0;
				double total_Dollar_Amount=0;

				while(rs_p.next())
				{
					String Payment_No=rs_p.getString("Payment_No");
					double Amount=rs_p.getDouble("Amount");
					double Local_Amount=rs_p.getDouble("Local_Amount");
					double Dollar_Amount=rs_p.getDouble("Dollar_Amount");
					total_Amount=total_Amount+Amount;
					total_Local_Amount=total_Local_Amount+Local_Amount;
					total_Dollar_Amount=total_Dollar_Amount+Dollar_Amount;
					errLine = "366";
				}//end of inner while
				pstmt_p.close();

				double outstanding_local =(Local_Total-total_Local_Amount);

				double outstanding_dollar =(Dollar_Total-total_Dollar_Amount);

if(( (Receive_CurrencyId !=0) &&  (str.mathformat(outstanding_local,3) >= 0.009))
||
((Receive_CurrencyId ==0) && (str.mathformat(outstanding_dollar,3)>= 0.009)))
			{
//System.out.println("382 Receive_CurrencyId="+Receive_CurrencyId+" outstanding_local"+str.mathformat(outstanding_local,3)+" outstanding_dollar"+str.mathformat(outstanding_dollar,3));				
					DueReportRow DRR = new DueReportRow(receive_id, receive_no, Receive_fromid, Receive_Date, duedays, Due_Date, overduedays, Receive_Total, Local_Total, Dollar_Total, salesperson_id, Company_Party_Name,	Salesperson_Name, total_Local_Amount, total_Dollar_Amount, outstanding_local, outstanding_dollar, refno, purchasesalegroup_id, PurchaseSaleGroup_Name);

					report.add(DRR);
				}
			}//end outer while
			pstmt_g.close();
			
			errLine = "385";

			
		}
		catch(Exception e)
		{
			System.out.println("Exception in getOverDueReportRows() in DueReport after Line:"+errLine+" is "+e);
		}
		return report;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report's overdue rows	//////////////////////////////////////////////////////


	public ArrayList getPendingPNRows(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "399";
		ArrayList report = new ArrayList();
		GetDate G = new GetDate();
		try{
			String condition="";
			
			//condition for sale/purchase
			if(type.equals("10"))
			{
				condition=" and PN_Amount < 0 and Active=1 and PN_Status = 0";
			}
			else
			{
				condition=" and PN_Amount > 0 and Active=1 and PN_Status = 0";
			}

			//condition for date type
			String datecondn = "";
			if(datecondition.equals("invoicedate"))
			{
				datecondn=" and PN_Date <= ?";
			}
			if(datecondition.equals("duedate"))
			{
				datecondn=" and Payment_Date <= ?";
			}


			//Query calculating the Over Due Report till tillDate
			String query=" select * from PN where company_id="+ company_id +"  "+datecondn+" " + condition;

			if("0".equals(companyparty_id))//for All parties
			{}
			else//Not for All
			{
				query=query+ " and to_FromId IN ( "+ companyparty_id+ " )";
			}

			if("Receive_No".equals(orderby))
			{
				query=query + "  order by PN_No";	
			}
			if("Invoice_Date".equals(orderby))
			{
				query=query + "  order by PN_Date";	
			}
			
			//System.out.print("<br>query="+query);
			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString (1,""+tillDate);	
			//System.out.print("<br>173 fromDate"+fromDate);

			rs_g = pstmt_g.executeQuery();
			errLine = "452";
			while(rs_g.next())
			{
				int PN_Id=rs_g.getInt("PN_Id");
				String pn_no=rs_g.getString("pn_no");
				int to_fromid=rs_g.getInt("to_fromid");
				java.sql.Date PN_Date=rs_g.getDate("PN_Date");
				java.sql.Date Payment_Date=rs_g.getDate("Payment_Date");
				double PN_Amount=Math.abs(rs_g.getDouble("PN_Amount"));
				double PN_LocalAmount=Math.abs(rs_g.getDouble("PN_LocalAmount"));
				double PN_DollarAmount=Math.abs(rs_g.getDouble("PN_DollarAmount"));
				
				//currenctly storing dummy data
				int salesperson_id = 0;
				int purchasesalegroup_id = 0;
				
				String Company_Party_Name = (String)Master_CompanyParty.get( (to_fromid - 1) );
				String Salesperson_Name = "";
				String PurchaseSaleGroup_Name = "";
		
				int duedays = Integer.parseInt(G.getDueDays(format.format(PN_Date), format.format(Payment_Date)));
		
				int overduedays = Integer.parseInt(G.getDueDays(format.format(Payment_Date), format.format(tillDate)));

				String refno = "";

				errLine = "479";
	
				double outstanding_local = PN_LocalAmount;
				double outstanding_dollar = PN_DollarAmount;

				if(str.mathformat(outstanding_dollar, 3) != 0 && str.mathformat(outstanding_local, 3) != 0)
				{
					DueReportRow DRR = new DueReportRow(PN_Id, pn_no, to_fromid, PN_Date, duedays, Payment_Date, overduedays, PN_Amount, PN_LocalAmount, PN_DollarAmount, salesperson_id, Company_Party_Name,	Salesperson_Name, 0, 0, outstanding_local, outstanding_dollar, refno, purchasesalegroup_id, PurchaseSaleGroup_Name);

					report.add(DRR);
				}
			}//end outer while
			pstmt_g.close();
			
			errLine = "493";

			
		}
		catch(Exception e)
		{
			System.out.println("Exception in getPendingPNRows() in DueReport after Line:"+errLine+" is "+e);
		}
		return report;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report's pending PN	//////////////////////////////////////////////////////


	public ArrayList getOtherRecPay(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "508";
		//the following data contains the local value in the first index followed by dollar value in the next index
		ArrayList receiptPaymentData = new ArrayList();
		double onAccountLocalAmount = 0;
		double onAccountDollarAmount = 0;

		GetDate G = new GetDate();
		try{
			String condition="";
			
			//condition for sale/purchase
			if(type.equals("10")) //purchase
			{
				String Ledger_Id = "";
				
				String ledgerIdQuery = "Select Ledger_Id from Ledger where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2 and Active=1";

				pstmt_g = cong.prepareStatement(ledgerIdQuery);
	
				rs_g = pstmt_g.executeQuery();
				errLine = "528";
				while(rs_g.next())
				{
					Ledger_Id = rs_g.getString("Ledger_Id");
				}
				pstmt_g.close();

				//getting the FPP PNP of invoices punched earlier than period between from date and till date
				String PDQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V, Financial_Transaction FT where PD.For_Head=10 and PD.For_HeadId<>0 and (V.Voucher_Type=9  or V.Voucher_Type=13 or V.Voucher_Type=7 ) and V.Voucher_Id=FT.Voucher_Id and V.Voucher_Id=PD.Voucher_Id and FT.Ledger_Id="+Ledger_Id+" and PD.Transaction_Date between ? and ? and PD.Active=1 and FT.Active=1 and V.Active=1 and PD.For_HeadId NOT IN (Select Receive_Id from Receive where Receive_Sell=1 and Purchase=1 and Opening_Stock=0 and R_Return=0 and Active=1 and Receive_Date between ? and ?)";

				pstmt_g = cong.prepareStatement(PDQuery);
				//System.out.println("PDQuery="+PDQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				pstmt_g.setString (3,""+fromDate);	
				pstmt_g.setString (4,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "545";
				while(rs_g.next())
				{
					onAccountLocalAmount = rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount = rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();				
			}
			
			else //sale
			{
				String Ledger_Id = "";
				
				String ledgerIdQuery = "Select Ledger_Id from Ledger where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=1 and Active=1";

				pstmt_g = cong.prepareStatement(ledgerIdQuery);
	
				rs_g = pstmt_g.executeQuery();
				errLine = "564";
				while(rs_g.next())
				{
					Ledger_Id = rs_g.getString("Ledger_Id");
				}
				pstmt_g.close();

				//getting the FSR PNR of invoices punched earlier than period between from date and till date
				String PDQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V, Financial_Transaction FT where PD.For_Head=9 and PD.For_HeadId<>0 and (V.Voucher_Type=8  or V.Voucher_Type=12 or V.Voucher_Type=7) and V.Voucher_Id=FT.Voucher_Id and V.Voucher_Id=PD.Voucher_Id and FT.Ledger_Id="+Ledger_Id+" and PD.Transaction_Date between ? and ? and PD.Active=1 and FT.Active=1 and V.Active=1 and PD.For_HeadId NOT IN (Select Receive_Id from Receive where Receive_Sell=0 and Purchase=1 and Opening_Stock=0 and R_Return=0 and Active=1 and Receive_Date between ? and ?)";

				pstmt_g = cong.prepareStatement(PDQuery);
				//System.out.println("PDQuery="+PDQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				pstmt_g.setString (3,""+fromDate);	
				pstmt_g.setString (4,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "581";
				while(rs_g.next())
				{
					onAccountLocalAmount = rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount = rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();

				
			}
			//for sales this is credited value and for purchase this is debited value
			errLine = "593";
			Double localAmt = onAccountLocalAmount;
			Double DollarAmt = onAccountDollarAmount;
			receiptPaymentData.add(localAmt);
			receiptPaymentData.add(DollarAmt);
//System.out.println("localAmt"+localAmt);
//System.out.println("DollarAmt"+DollarAmt);

			errLine = "599";
			
		}
		catch(Exception e)
		{
			System.out.println("Exception in getOtherRecPay() in DueReport after Line:"+errLine+" is "+e);
		}
		return receiptPaymentData;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report's other SR's and PNR's 
	//or PP's or PNP's transactions between from date and 
	//till date of previous S or P invoices
	//////////////////////////////////////////////////////


	public ArrayList getOnAccountTrans(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "617";
		//the following data contains the local value in the first index followed by dollar value in the next index
		ArrayList onAccountData = new ArrayList();
		double onAccountLocalAmount = 0;
		double onAccountDollarAmount = 0;

		GetDate G = new GetDate();
		try{
			String condition="";
			//condition for sale/purchase
			if(type.equals("10")) //purchase
			{
				String Ledger_Id = "";
				
				String ledgerIdQuery = "Select Ledger_Id from Ledger where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2 and Active=1";

				pstmt_g = cong.prepareStatement(ledgerIdQuery);
	
				rs_g = pstmt_g.executeQuery();
				errLine = "637";
				while(rs_g.next())
				{
					Ledger_Id = rs_g.getString("Ledger_Id");
				}
				pstmt_g.close();

				//getting the on Account calculation for all the PNPs and FPPs between from date and till date
				String PDQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V, Financial_Transaction FT where PD.For_Head=10 and PD.For_HeadId=0 and (V.Voucher_Type=9  or V.Voucher_Type=13 ) and V.Voucher_Id=FT.Voucher_Id and V.Voucher_Id=PD.Voucher_Id and FT.Ledger_Id="+Ledger_Id+" and PD.Transaction_Date between ? and ? and PD.Active=1 and FT.Active=1 and V.Active=1";

				pstmt_g = cong.prepareStatement(PDQuery);
				//System.out.println("PDQuery="+PDQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "652";
				while(rs_g.next())
				{
					onAccountLocalAmount = rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount = rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();

				//get the Journal and setoff journal on account transactions for the given period

				String JQuery ="Select * from Voucher V, Financial_Transaction FT where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and V.Active=1 and FT.Active=1 and V.Voucher_Date Between ? and ? and FT.Ledger_Id="+Ledger_Id;

				pstmt_g = cong.prepareStatement(JQuery);
				//System.out.println("JQuery="+JQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "670";
				while(rs_g.next())
				{
					boolean Transaction_Type = rs_g.getBoolean("Transaction_Type");

					if(Transaction_Type)
					{
						onAccountLocalAmount -= rs_g.getDouble("Local_Amount");
						onAccountDollarAmount -= rs_g.getDouble("Dollar_Amount");
					}
					else
					{
						onAccountLocalAmount += rs_g.getDouble("Local_Amount");
						onAccountDollarAmount += rs_g.getDouble("Dollar_Amount");
					}

					String SetOffJQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V where PD.For_Head=10 and PD.For_HeadId<>0 and V.Voucher_Type=7 and V.Voucher_Id=PD.Voucher_Id and V.Voucher_Id="+rs_g.getString("Voucher_Id")+" and PD.Active=1 and V.Active=1 ";

					pstmt_p = conp.prepareStatement(SetOffJQuery);
					//System.out.println("SetOffJQuery="+SetOffJQuery);
					rs_p = pstmt_p.executeQuery();
					errLine = "691";
					while(rs_p.next())
					{
						onAccountLocalAmount -= rs_p.getDouble("onAccountLocalAmount");
						onAccountDollarAmount -= rs_p.getDouble("onAccountDollarAmount");
					}
					
					pstmt_p.close();					
				}
				pstmt_g.close();

				//getting the settlement entries against the selected party
				String SettlementQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount from Payment_Details PD, Receive R where PD.For_Head=10 and PD.For_HeadId=R.Receive_Id and PD.Voucher_Id=0 and PD.Transaction_Date between ? and ? and R.Receive_FromId="+companyparty_id+" and R.Receive_Sell=1 and Purchase=1 and PD.Active=1 and R.Active=1";

				pstmt_g = cong.prepareStatement(SettlementQuery);
				//System.out.println("SettlementQuery="+SettlementQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "710";
				while(rs_g.next())
				{
					onAccountLocalAmount -= rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount -= rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();
			
			}
			if(type.equals("9")) //purchase //sale
			{
				String Ledger_Id = "";
				
				String ledgerIdQuery = "Select Ledger_Id from Ledger where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=1 and Active=1";

				pstmt_g = cong.prepareStatement(ledgerIdQuery);
	
				rs_g = pstmt_g.executeQuery();
				errLine = "728";
				while(rs_g.next())
				{
					Ledger_Id = rs_g.getString("Ledger_Id");
				}
				pstmt_g.close();

				//getting the on Account calculation for all the PNRs and FSRs between from date and till date
				String PDQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V, Financial_Transaction FT where PD.For_Head=9 and PD.For_HeadId=0 and (V.Voucher_Type=8  or V.Voucher_Type=12 ) and V.Voucher_Id=FT.Voucher_Id and V.Voucher_Id=PD.Voucher_Id and FT.Ledger_Id="+Ledger_Id+" and PD.Transaction_Date between ? and ? and PD.Active=1 and FT.Active=1 and V.Active=1";

				pstmt_g = cong.prepareStatement(PDQuery);
				//System.out.println("PDQuery="+PDQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "743";
				while(rs_g.next())
				{
					onAccountLocalAmount = rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount = rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();

				//get the Journal and setoff journal on account transactions for the given period

				String JQuery ="Select * from Voucher V, Financial_Transaction FT where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and V.Active=1 and FT.Active=1 and V.Voucher_Date Between ? and ? and FT.Ledger_Id="+Ledger_Id;

				pstmt_g = cong.prepareStatement(JQuery);
				//System.out.println("JQuery="+JQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "761";
				while(rs_g.next())
				{
					boolean Transaction_Type = rs_g.getBoolean("Transaction_Type");

					if(Transaction_Type)
					{
						onAccountLocalAmount += rs_g.getDouble("Local_Amount");
						onAccountDollarAmount += rs_g.getDouble("Dollar_Amount");
					}
					else
					{
						onAccountLocalAmount -= rs_g.getDouble("Local_Amount");
						onAccountDollarAmount -= rs_g.getDouble("Dollar_Amount");
					}

					String SetOffJQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount  from Payment_Details PD, Voucher V where PD.For_Head=9 and PD.For_HeadId<>0 and V.Voucher_Type=7 and V.Voucher_Id=PD.Voucher_Id and V.Voucher_Id="+rs_g.getString("Voucher_Id")+" and PD.Active=1 and V.Active=1 ";

					pstmt_p = conp.prepareStatement(SetOffJQuery);
					//System.out.println("SetOffJQuery="+SetOffJQuery);
					rs_p = pstmt_p.executeQuery();
					errLine = "782";
					while(rs_p.next())
					{
						onAccountLocalAmount -= rs_p.getDouble("onAccountLocalAmount");
						onAccountDollarAmount -= rs_p.getDouble("onAccountDollarAmount");
					}
					
					pstmt_p.close();					
				}
				pstmt_g.close();

				//getting the settlement entries against the selected party
				String SettlementQuery = "Select Sum(PD.Local_Amount) as onAccountLocalAmount, Sum(PD.Dollar_Amount) as onAccountDollarAmount from Payment_Details PD, Receive R where PD.For_Head=9 and PD.For_HeadId=R.Receive_Id and PD.Voucher_Id=0 and PD.Transaction_Date between ? and ? and R.Receive_FromId="+companyparty_id+" and R.Receive_Sell=0 and Purchase=1 and PD.Active=1 and R.Active=1";

				pstmt_g = cong.prepareStatement(SettlementQuery);
				//System.out.println("SettlementQuery="+SettlementQuery);
				pstmt_g.setString (1,""+fromDate);	
				pstmt_g.setString (2,""+tillDate);	
				rs_g = pstmt_g.executeQuery();
				errLine = "801";
				while(rs_g.next())
				{
					onAccountLocalAmount -= rs_g.getDouble("onAccountLocalAmount");
					onAccountDollarAmount -= rs_g.getDouble("onAccountDollarAmount");

				}
				pstmt_g.close();
			}
		
			errLine = "811";
			Double localAmt = onAccountLocalAmount;
			Double DollarAmt = onAccountDollarAmount;
			onAccountData.add(localAmt);
			onAccountData.add(DollarAmt);

			errLine = "817";
			
		}
		catch(Exception e)
		{
			System.out.println("Exception in getOnAccountTrans() in DueReport after Line:"+errLine+" is "+e);
		}
		return onAccountData;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report's on account total 
	//transactions between from date and till date
	//////////////////////////////////////////////////////

	public ArrayList getGroupArrayList(ArrayList reportRows, String groupName)
	{
		String errLine = "833";
		ArrayList rowsList = new ArrayList();
		try{

			if("company".equals(groupName))
			{
				for(int i=0; i<reportRows.size(); i++)
				{
					DueReportRow DRR = (DueReportRow)reportRows.get(i);
					String partyid = "" + DRR.getReceive_fromid();
					rowsList.add(partyid);
				}
			}
			errLine = "846";

			if("salesperson".equals(groupName))
			{
				for(int i=0; i<reportRows.size(); i++)
				{
					DueReportRow DRR = (DueReportRow)reportRows.get(i);
					String spid = "" + DRR.getSalesperson_id();
					rowsList.add(spid);
				}
			}
			errLine = "857";

			if("duedate".equals(groupName))
			{
				for(int i=0; i<reportRows.size(); i++)
				{
					DueReportRow DRR = (DueReportRow)reportRows.get(i);
					java.sql.Date ddate = DRR.getDue_Date();
					rowsList.add(ddate);
				}
			}
			errLine = "868";

			if("purchasesalegroup".equals(groupName))
			{
				for(int i=0; i<reportRows.size(); i++)
				{
					DueReportRow DRR = (DueReportRow)reportRows.get(i);
					String psgid = ""+ DRR.getPurchaseSaleGroup_Id();
					rowsList.add(psgid);
				}
			}
			errLine = "879";


		}
		catch(Exception e)
		{
			System.out.println("Exception in getGroupArrayList() in DueReport after Line:"+errLine+" is "+e);
		}
		return rowsList;
	}
	//////////////////////////////////////////////////////
	//End : method to get the arraylists for grouping
	//////////////////////////////////////////////////////




}//end of class


