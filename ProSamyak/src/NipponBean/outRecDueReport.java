package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
import NipponBean.*;

public class outRecDueReport
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
	public void newloadMasters(Connection con)
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

public ArrayList newgetDueReportRows(Connection cong, Connection conp, java.sql.Date fromDate, java.sql.Date tillDate, String companyparty_id, String sentsalesperson_id, String orderby, String type, String company_id, String datecondition, String sentpurchasesalegroup_id)
	{
		String errLine = "79";
		
		java.sql.Date currDate = new java.sql.Date(System.currentTimeMillis());
		//System.out.println("83 currDate = "+currDate);
		
		
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
		
		//System.out.println("<br>144 query = "+query);

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
				pstmt_p.setString(1, ""+currDate);
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
			System.out.println("Exception in newgetDueReportRows() in DueReport after Line:"+errLine+" is "+e);
		}
		return report;
	}
	//////////////////////////////////////////////////////
	//End : method to get the report rows
	//////////////////////////////////////////////////////

}