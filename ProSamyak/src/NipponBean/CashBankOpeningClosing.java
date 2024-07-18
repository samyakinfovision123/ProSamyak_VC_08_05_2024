package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
import NipponBean.*;
		
		public class CashBankOpeningClosing
		{
			//Connection cong1 = null;
			ResultSet rs_g1=null;
			PreparedStatement pstmt_g1=null;
			//Connection cong = null;
			ResultSet rs_g=null;
			PreparedStatement pstmt_g=null;
			Connection conp = null;
			ResultSet rs_p=null;
			PreparedStatement pstmt_p=null;
			String errorline="0";
			NipponBean.Array A=new NipponBean.Array(); 
			NipponBean.YearEndIdNew YEDID = new NipponBean.YearEndIdNew();
			NipponBean.YearEndFinance YEF =new NipponBean.YearEndFinance();

			
			public String getcashBankOpeningClosing(Connection cong1,Connection conp,String account_id,java.sql.Date D,String company_id,String currency,String Book ,java.sql.Date D4,String reportyearend_id)
			{
				double rlocal=0;
				double rdollar=0;
				double db_localamount =0;
				double db_dollaramount = 0;
				double cr_localamount=0;
				double cr_dollaramount=0;
						
			try{
				
				errorline="34";
				//out.print("<br>:76"+account_id);
				int accountid=Integer.parseInt(account_id);
				if(true)
				{
			  		   
				String account_no="";
				String account_name= "";
				boolean transaction_currency=false;
				double double_bankclosingamount=0;
				double locale=0;

				int d=2;
				String bankclosing_amt= YEF.ClosingBankBalance(cong1,""+accountid,company_id,D,d,reportyearend_id);
				//double_bankclosingamount=Double.parseDouble(bankclosing_amt);
				errorline="49";
				//String LTrans_DbCrTotal= //""+F.ClosingBankBalanceDollar(cong,""+accountid,company_id,D4,d);
				//System.out.println("51 accountid"+accountid);
				//System.out.println(" company_id"+company_id);
				//System.out.println("D"+D);
				//System.out.println("reportyearend_id"+reportyearend_id);
				String LTrans_DbCrTotal=""+YEF.ClosingBankBalanceDollar(cong1,""+accountid,company_id,D,d,reportyearend_id);

				//System.out.println("*************<br>310 LTrans_DbCrTotal222="+LTrans_DbCrTotal);
				errorline="53";
				//System.out.println("LTrans_DbCrTotal"+LTrans_DbCrTotal);
				StringTokenizer Lst = new StringTokenizer(LTrans_DbCrTotal,"/");
				errorline="55";
				String LTrans_Dbtotal = (String)Lst.nextElement();
				String LTrans_Crtotal = (String)Lst.nextElement();
				
				//System.out.println("*************<br>310 LTrans_Dbtotal222="+LTrans_Dbtotal+" LTrans_Crtotal="+LTrans_Crtotal);
				errorline="59";
				double opening_localbalance= (Double.parseDouble(LTrans_Dbtotal));
				double opening_dollarbalance= (Double.parseDouble(LTrans_Crtotal)); 

				//System.out.println(" 61 opening_localbalance"+opening_localbalance);
				//System.out.println("62 opening_dollarbalance"+opening_dollarbalance);


				String voucher_name[]=new String[23];
				voucher_name[0]="";
				voucher_name[1]="Sales";  
				voucher_name[2]="Purchase"; 
				voucher_name[3]="Stock Transfer";
				voucher_name[4]="Contra"; 
				voucher_name[5]="Payment"; 
				voucher_name[6]="Receipt";  
				voucher_name[7]="Journal";
				voucher_name[8]="Sales Receipt"; 
				voucher_name[9]="Purchase Payment"; 
				voucher_name[10]="Purchase Return"; 
				voucher_name[11]="Sales Return"; 
				voucher_name[12]="PN Sales Receipt"; 
				voucher_name[13]="PN Purchase Payment";
				voucher_name[14]="Journal (Sales Receipt)"; 
				voucher_name[15]="Journal (Purchase Payment)"; 
				voucher_name[16]="Journal (Account)"; 
				voucher_name[17]="Journal (Sale to sale)"; 
				voucher_name[18]="Journal (Purchase to Purchase)"; 
				voucher_name[19]="Journal (Sales Payment)"; 
				voucher_name[20]="Journal (Purchase Receipt)";
				voucher_name[21]="Journal (PN Payment)"; 
				voucher_name[22]="Journal (PN Receipt)"; 
				
				int j=0;
				//rlocal=double_bankclosingamount;
				errorline="94";
				rlocal=opening_localbalance;
				rdollar=opening_dollarbalance;
				
				if (rlocal >= 0) 
				{
								
						//=======change for respective addition======	
						db_localamount =double_bankclosingamount;
						db_dollaramount = opening_dollarbalance;


				} 
				else 
				{

						//========change for respective addition======
						cr_localamount = double_bankclosingamount*-1;
						cr_dollaramount = opening_dollarbalance *-1;

				} 
				
				//Taking YearEnd Ids in ArrayList and making calculations according
				ArrayList year_endIdArray=YEDID.getYearEndIdsNew(cong1, D4,D,company_id);
				//out.println("553 year_endIdArray size="+year_endIdArray.size());
				errorline="119";	
				//System.out.println("127 year_endIdArray"+year_endIdArray.size());

				for(int k=0; k<year_endIdArray.size(); k++)
				{
				
					//System.out.println("132 Under For Loop");

					reportyearend_id = ((Integer)(year_endIdArray.get(k))).toString();
					
					
					String query="Select *	from Voucher V, Financial_Transaction FT where V.Voucher_id=FT.Voucher_id  and V.Voucher_Date between ? and ? and V.company_id=? and FT.For_Head=1 and V.YearEnd_Id="+reportyearend_id+" and FT.For_HeadId="+account_id+" and FT.Active=1 and V.Active=1"; 
					//Transaction_Date,
				
					pstmt_g = cong1.prepareStatement(query);
					//System.out.println("127 query"+query);
					//System.out.println("127 D4"+D4);
					//System.out.println("127 D"+D);
					pstmt_g.setString(1,""+D); 
					pstmt_g.setString(2,""+D4
						);
					pstmt_g.setString(3,company_id); 
					rs_g = pstmt_g.executeQuery();
					
					int i=0;
					while(rs_g.next()) 	
					{
						int to_by=rs_g.getInt("ToBy_Nos");
						int ft_voucher_id=rs_g.getInt("Voucher_id");
						int ft_id=rs_g.getInt("Tranasaction_Id");
						int trans_type= rs_g.getInt("Transaction_Type");
						double vlocal= rs_g.getDouble("Local_Amount");
						double vdollar= rs_g.getDouble("Dollar_Amount");
						//System.out.println(" 151 vlocal"+vlocal);
							//System.out.println(" 152 vdollar"+vdollar);
						int voucher_type=rs_g.getInt("voucher_type");

						String voucher_no=rs_g.getString("voucher_no");
						java.sql.Date voucher_date=rs_g.getDate("Voucher_Date");
						int ref_voucherid=rs_g.getInt("Referance_VoucherId");
							
						//added by Datta for showing Ref No. and Exchange Rate
						//int refno=Integer.parseInt(rs_g.getString("Ref_No"));
						String refno= rs_g.getString("Ref_No");
								
						//int exchrate= Integer.parseInt(rs_g.getString("Exchange_Rate"));
						String exchrate= rs_g.getString("Exchange_Rate");
						String v_description= A.getName(cong1,"Voucher","Description","Voucher_Id",""+ft_voucher_id);

						if(to_by==2)
						{
							String ledger_id= "";
							String forhead="";
							String  forhead_id="";

							if(trans_type==1)
							{
									  //*make one query of three
									  ledger_id=A.getNameCondition(cong1,"Financial_Transaction","Ledger_id","Where Voucher_id="+ft_voucher_id+" and transaction_type=0" );
									  forhead = A.getNameCondition(cong1,"Financial_Transaction","For_Head","Where Voucher_id="+ft_voucher_id+" and transaction_type=0" );
									  forhead_id = A.getNameCondition(cong1,"Financial_Transaction","For_HeadId","Where Voucher_id="+ft_voucher_id+" and transaction_type=0" );
							}
							else
							{
									  ledger_id=A.getNameCondition(cong1,"Financial_Transaction","Ledger_id","Where Voucher_id="+ft_voucher_id+" and transaction_type=1" );
									  forhead = A.getNameCondition(cong1,"Financial_Transaction","For_Head","Where Voucher_id="+ft_voucher_id+" and transaction_type=1" );
									  forhead_id = A.getNameCondition(cong1,"Financial_Transaction","For_HeadId","Where Voucher_id="+ft_voucher_id+" and transaction_type=1" );
							}
								
							//Showing values in Report 
									
														
									
							if("1".equals(forhead))
						{
							String accountName=""+A.getName(cong1,"Account",""+forhead_id);
						
						
										

							// Start of Code for PN Party clarence display

						if("PN Account".equals(accountName))
						{
							
							String pnQuery="";
							int To_FromId=0;
				  
							pnQuery="SELECT To_FromId from PN where Voucher_Id="+ft_voucher_id+" and  Active=1";
							pstmt_g1 = cong1.prepareStatement(pnQuery);
						 
							rs_g1 = pstmt_g1.executeQuery();
							while(rs_g1.next()) 	
							{
								  To_FromId=rs_g1.getInt("To_FromId");
							}
							pstmt_g1.close();

							String toStringPartyId=""+To_FromId;
							String  pnLedgerParty=A.getName(cong1,"Master_CompanyParty", "CompanyParty_Name","CompanyParty_Id",toStringPartyId);
							
						}//if PN Account

						// End of Code for PN Party clarence display
					}//if 1".equals(forhead)
					else
					{
						
					}
					 

						
					if(0==(trans_type))
					{
						rlocal += vlocal;
						rdollar += vdollar;
						db_localamount +=vlocal;
						
						db_dollaramount +=vdollar;
					

					}//end of 691 if(0==(trans_type))
					else
					{
						rlocal =rlocal - vlocal;
						rdollar =rdollar - vdollar;
						cr_localamount +=vlocal;
						
						cr_dollaramount +=vdollar;
								
						
					}//end of else 750
					

				}//end of 613 if(to_by==2)
				else
				{
								
					if(0==(trans_type))
					{
			
						rlocal += vlocal;
						rdollar += vdollar;
						db_localamount +=vlocal;
							
						db_dollaramount +=vdollar;

					}
					else
					{
						rlocal =rlocal - vlocal;
						rdollar =rdollar - vdollar;
						cr_localamount +=vlocal;
								
						cr_dollaramount +=vdollar;
						
					}// end of 925 else

								
				
						
					//To show Description of Transaction
					String vquery="";
					vquery="Select * from Voucher V, Financial_Transaction FT  where V.Voucher_id=FT.Voucher_id and FT.Voucher_id=? and V.Active=1 and FT.Active=1 and FT.Tranasaction_Id not like "+ft_id+" order by V.Voucher_Date, FT.Tranasaction_Id ";
								
					pstmt_p = conp.prepareStatement(vquery);
					pstmt_p.setString(1,""+ft_voucher_id); 
					rs_p= pstmt_p.executeQuery();
					while(rs_p.next()) 	
					{
						//int ft_voucher_id=rs.getInt("Voucher_id");
						String ledger_id=rs_p.getString("Ledger_id");
						String forhead=rs_p.getString("For_Head");
						int forhead_id=rs_p.getInt("For_Headid");
						int transaction_type= rs_p.getInt("Transaction_Type");
						double local= rs_p.getDouble("Local_Amount");
						double dollar= rs_p.getDouble("Dollar_Amount");
						String iv_description=rs_p.getString("Description");
					
						//System.out.println(" 298 local"+local);
					}//end of 1008 while(rs.next())
								
					pstmt_p.close();
					
					
				}// end of 819 else to_by

							i++;
						
						}//end of 589 while(rs_g.next())
						
						rs_g.close();
						pstmt_g.close();
						
						//System.out.println(" 314 rlocal"+rlocal);
					//System.out.println(" 314 rdollar"+rdollar);

					// if YearEnd_Id==0 there should be no addition
						if(!reportyearend_id.equals("0"))
						{
							if(rlocal>0)
							{
								cr_localamount +=rlocal;
								cr_dollaramount +=rdollar;
								
							}
							else
								{
								db_localamount +=(rlocal*-1);
								db_dollaramount +=(rdollar*-1);
								
								}	
						}
					}//end of 553 for(int k=0; k<year_endIdArray.size(); k++)
					
				//System.out.println(" 334 cr_localamount"+cr_localamount);
				//System.out.println(" 334 db_dollaramount"+db_dollaramount);
				
				}//if  
				 
				}catch(Exception Samyak339)
				{
					System.out.println("Error in  Samyak339 line"+errorline+"="+Samyak339);
				}
				String temp="";
				String newRLocal=str.mathformat(""+rlocal,2);
				String newRDollar=str.mathformat(""+rdollar,2);
				
				if(currency.equals("local"))
				{
						temp = newRLocal;
				}
				else if(currency.equals("dollar"))
				{
						temp = newRDollar;
				}else if(currency.equals("both"))
				{
						//System.out.print("Under both");
						temp = newRLocal+"#"+newRDollar;
				}
				//System.out.print("363 rlocal "+newRLocal+":rdollar :"+newRDollar);
				//System.out.print("364 temp "+currency+":"+temp);
				return temp;
			}
		}