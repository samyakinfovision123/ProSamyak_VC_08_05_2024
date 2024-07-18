package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class getIdList {

  
  
  Connection cong=null;
  Connection conp=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  int d=3;
  String g_name="";
  String g_id="";
  Connect C;
  NipponBean.Array A;
  CustomerVendorReport CVR;
  CashBankGroup CG;
  YearEndDate YED;
  String query="";
  String id_name_column="";
  String str_Id="";
  String str_Name="";
  double local_closing  =0;	
  double dollar_closing =0;	
  
public getIdList() 
{
    try
	{
		C = new Connect();
		A = new NipponBean.Array();
		CVR = new CustomerVendorReport();
		YED=new YearEndDate();
		CG=new CashBankGroup();
	}
	catch(Exception e)
	{
		System.out.println("Exception in LotList() in LotList="+e);
	}
	
}

public void getIdNameFromTable(String company_id, String name,String date_value,String currency)
{
	String errLine = "52";	
	try
	{
		cong = C.getConnection();
		conp = C.getConnection();
		
		if(!("".equals(name)))
		{
			errLine = "48";
			query="Select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where CompanyParty_Name='"+name+"' and company_id="+company_id+" and active=1";
			System.out.println("query="+query);
			System.out.println("cong="+cong);
			//System.out.println("query="+query);
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Party#";
				g_id+=rs_g.getString("CompanyParty_Id");
				g_name=rs_g.getString("companyParty_Name");	
				
			} //while
			rs_g.close();
			pstmt_g.close();
			
			errLine = "61";
			query="Select Ledger_Id,Ledger_Name from Ledger where Ledger_Name='"+name+"' and company_id="+company_id+" and active=1 and for_head<>14 and ParentCompanyParty_Id=0";
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Led#";
				g_id+=rs_g.getString("Ledger_Id");
				g_name=rs_g.getString("Ledger_Name");	
			} //while
			rs_g.close();
			pstmt_g.close();
			errLine = "72";
			String account_type="";
			query="Select Account_Id,Account_Name,AccountType_Id from Master_Account where AccountType_Id IN (1, 6) and  company_Id="+company_id+" and Account_Name='"+name+"'";
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				g_id="Bank#";
				g_id+=rs_g.getString("Account_Id");
				g_name=rs_g.getString("Account_Name");	
				account_type=rs_g.getString("AccountType_Id");	
				
			} //while
			rs_g.close();
			pstmt_g.close();
		
			java.sql.Date D1=format.getDate(date_value);
			java.sql.Date D2=D1;
			String party_id_array[]=g_id.split("#");
			System.out.println("g_id="+g_id);
			System.out.println("party_id_array[0]="+party_id_array[0]);

			if("Bank".equals(party_id_array[0]))
			{
				System.out.println("Line 113");
				System.out.println("conp="+conp);
				System.out.println("pstmt_g="+pstmt_g);
				System.out.println("rs_g ="+rs_g);
				System.out.println("D1 ="+D1);
				System.out.println("company_id="+company_id);
				String reportyearend_id = YED.returnYearEndId(conp , pstmt_g, rs_g, D1, company_id);
				
				System.out.println("reportyearend_id="+reportyearend_id);
				ArrayList reportRows = CG.getAccountRows(conp, company_id,"1", reportyearend_id, D1,D2);

				double totalLocalOpening_Dr =0; 
				double totalDollarOpening_Dr =0;
				double totalLocalOpening_Cr =0; 
				double totalDollarOpening_Cr =0;
				double totalLocalTrans_Dr =0;
				double totalDollarTrans_Dr =0;
				double totalLocalTrans_Cr =0;
				double totalDollarTrans_Cr =0;
				double totalLocalClosing_Dr =0;
				double totalDollarClosing_Dr =0;
				double totalLocalClosing_Cr =0; 
				double totalDollarClosing_Cr =0;

			for(int i=0; i<reportRows.size(); i++)
			{
				CashBankGroupRow row = (CashBankGroupRow)reportRows.get(i);
				if(party_id_array[1].equals(row.getAccountId()))
				{
						totalLocalOpening_Dr += row.getLocalOpening_Dr();
						totalDollarOpening_Dr += row.getDollarOpening_Dr();
						totalLocalOpening_Cr += row.getLocalOpening_Cr();
						totalDollarOpening_Cr += row.getDollarOpening_Cr();
						totalLocalTrans_Dr += row.getLocalTrans_Dr();
						totalDollarTrans_Dr += row.getDollarTrans_Dr();
						totalLocalTrans_Cr += row.getLocalTrans_Cr();
						totalDollarTrans_Cr += row.getDollarTrans_Cr();
						totalLocalClosing_Dr += row.getLocalClosing_Dr();
						totalDollarClosing_Dr += row.getDollarClosing_Dr();
						totalLocalClosing_Cr += row.getLocalClosing_Cr();
						totalDollarClosing_Cr += row.getDollarClosing_Cr();
				}
			
				
			}
			double total_local_closing=totalLocalClosing_Dr+totalLocalClosing_Cr*(-1);
			//out.println("total_local_closing="+total_local_closing);

			double total_dollar_closing=totalDollarClosing_Dr+totalDollarClosing_Cr*(-1);
			
			local_closing=Double.parseDouble(str.mathformat(""+total_local_closing,3));
			dollar_closing=Double.parseDouble(str.mathformat(""+total_dollar_closing,2));
			} //if
			else
			{
			String party_id=party_id_array[1];
			System.out.println("party_id="+party_id);
			String salesAccLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", " where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=1 and Active=1");
			//out.print("<br> 169 salesAccLedgerId"+salesAccLedgerId);
			String purchaseAccLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", " where For_Head=14 and For_HeadId="+party_id+" and Ledger_Type=2 and Active=1");
	
			//out.print("<br> 169 purchaseAccLedgerId"+purchaseAccLedgerId);
			String ctaxLedgerId = A.getNameCondition(cong, "Ledger", "Ledger_Id", "where company_id="+company_id+" and Active=1 and For_Head=17 and Ledger_Name='C. Tax'");
			
			
			double credit_limit				=0;
			double opening_sundrycreditors	=0;
			double opening_sundrydebtors	=0;
			double dopening_sundrycreditors	=0;
			double dopening_sundrydebtors	=0;
			
			query=" Select credit_limit, Transaction_Currency, Opening_PLocalBalance, Opening_RLocalBalance, Opening_PDollarBalance, Opening_RDollarBalance from Master_CompanyParty where CompanyParty_Id=".concat(party_id);
			//out.print("<BR>133 query=" +query);
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();	
			while(rs_g.next())
			{
				
				credit_limit= str.mathformat(rs_g.getDouble("credit_limit"),d);

				//party_currency= rs_g.getString("Transaction_Currency");
				
		
				opening_sundrycreditors = str.mathformat(rs_g.getDouble("Opening_PLocalBalance"),d);
		 
				opening_sundrydebtors = str.mathformat(rs_g.getDouble("Opening_RLocalBalance"),d);
		 
				dopening_sundrycreditors = str.mathformat(rs_g.getDouble("Opening_PDollarBalance"),2);
	
				dopening_sundrydebtors = str.mathformat(rs_g.getDouble("Opening_RDollarBalance"),2);

			}
			pstmt_g.close();
			
			String ledgerQuery="select count(*) as counter from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt_g=conp.prepareStatement(ledgerQuery);
			rs_g=pstmt_g.executeQuery();
			int lcount=0;
			while(rs_g.next())
			{
				lcount=rs_g.getInt("counter");
				
			}
			pstmt_g.close();

			double Opening_LocalBalance[]=new double[lcount];
			double Opening_DollarBalance[]=new double[lcount];
			
			ledgerQuery="select Opening_LocalBalance,Opening_DollarBalance from ledger where parentCompanyParty_id="+party_id+" and For_Head!=14 and For_HeadId!="+party_id;
			pstmt_g=conp.prepareStatement(ledgerQuery);
			rs_g=pstmt_g.executeQuery();
			int r=0;
			while(rs_g.next())
			{
				Opening_LocalBalance[r]=rs_g.getDouble("Opening_LocalBalance");
				Opening_DollarBalance[r]=rs_g.getDouble("Opening_DollarBalance");

				r++;
			}
			pstmt_g.close();
			
			
			List salesList = new ArrayList();
			List purchaseList = new ArrayList();
			List ledgerList =new ArrayList();
			List mingledList = new ArrayList();
			
			System.out.println("salesAccLedgerId="+salesAccLedgerId);
			System.out.println("D1="+D1);
			System.out.println("D2="+D2);
			System.out.println("opening_sundrydebtors="+opening_sundrydebtors);
			System.out.println("dopening_sundrydebtors="+dopening_sundrydebtors);
			System.out.println("party_id="+party_id);
			System.out.println("ctaxLedgerId="+ctaxLedgerId);
			CVR.loadMasters(conp);
			salesList = CVR.getSalesTransaction(salesAccLedgerId, conp, cong, D1, D2, opening_sundrydebtors, dopening_sundrydebtors, company_id, party_id, ctaxLedgerId);
			
			purchaseList = CVR.getPurchaseTransaction(purchaseAccLedgerId, conp, cong, D1, D2, opening_sundrycreditors, dopening_sundrycreditors, company_id, party_id, ctaxLedgerId);
			
			ledgerList =  CVR.getLedgerTransaction(conp, cong, D1, D2,Opening_LocalBalance,Opening_DollarBalance,company_id, party_id, ctaxLedgerId);
			mingledList = CVR.mingleList(salesList, purchaseList,ledgerList);

			for(int i=0; i<mingledList.size(); i++)
			{
				customerVendorReportRow row = (customerVendorReportRow)mingledList.get(i);
				//Voucher_Id =(String)row.getVoucher_Id();
				//NewLedger_Id=(String)row.getLedgerId();
				//String Ledger_Name="";
				/*if(h.containsKey(NewLedger_Id))
				{
					Ledger_Name=(String)h.get(NewLedger_Id);
				}*/
			
				local_closing += row.getLocalAmt_Dr();
				local_closing -= row.getLocalAmt_Cr();
				//out.print("<br> under for local_closing "+local_closing);
				dollar_closing += row.getDollarAmt_Dr();
				dollar_closing -= row.getDollarAmt_Cr();
			}
			local_closing=Double.parseDouble(str.mathformat(""+local_closing,3));
			dollar_closing=Double.parseDouble(str.mathformat(""+dollar_closing,2));
			System.out.println("local_closing="+local_closing);
			System.out.println("dollar_closing="+dollar_closing);

			System.out.println("date_value="+date_value);
			System.out.println("currency="+currency);
			} //else
		} //if("".equals(table))
		
		C.returnConnection(cong);
		C.returnConnection(conp);
	} //try
	catch(Exception e)
	{
		  C.returnConnection(cong);
		  C.returnConnection(conp);
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	} //catch(Exception)
  }

 /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<IdList generated=\""+System.currentTimeMillis()+"\">\n");

   
      String str_group_name=g_name;
	  //System.out.println("str_group_name="+str_group_name);
	   
	   //replace the ampersand in the code by &amp;
      StringBuffer tempName = new StringBuffer(g_name);
	  if( (str_group_name).indexOf('&') != -1 )
		{
			tempName = tempName.replace( (str_group_name).indexOf("&"), ((str_group_name).indexOf("&"))+1, "&amp;");
		}
	

	 String str_group_id=g_id;
	 StringBuffer tempNo = new StringBuffer(g_id);
	 if( (str_group_id).indexOf('&') != -1 )
	 {
			tempNo = tempNo.replace( (str_group_id).indexOf("&"), ((str_group_id).indexOf("&"))+1, "&amp;");
	 }

	 xml.append("<IdName>\n");
		 
		  xml.append("<ColumnId>");
		  xml.append(tempNo);
		  xml.append("</ColumnId>\n");
		  
		  xml.append("<ColumnName>");
		  xml.append(tempName);
		  xml.append("</ColumnName>\n");
		  
		  xml.append("<LocalClosing>");
		  xml.append(local_closing);
		  xml.append("</LocalClosing>\n");
		  
		  xml.append("<DollarClosing>");
		  xml.append(dollar_closing);
		  xml.append("</DollarClosing>\n");	
	 
	 xml.append("</IdName>\n");
   
    
    xml.append("</IdList>\n");
    System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
