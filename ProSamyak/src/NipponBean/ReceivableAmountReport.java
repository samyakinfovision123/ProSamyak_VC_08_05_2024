package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
import NipponBean.*;

public class ReceivableAmountReport
{
	
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	List Master_Salesperson = new ArrayList();
	List Master_CompanyParty = new ArrayList();
	List Master_PurchaseSaleGroup = new ArrayList();
	HashMap oldReceiveAmount=new HashMap();
	ResultSet rs = null;
	ResultSet rs_p = null;
	ResultSet rs_g = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt_p = null;
	PreparedStatement pstmt_g = null;
	String errLine="22";
	String xData="";

	///////////////////////////////////////////////////////
	//Start : method to load company names and salesperson
	//names and PurchaseSaleGroupName
	///////////////////////////////////////////////////////
	public void loadMasters(Connection con)
	{
		 errLine = "25";

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


	public ArrayList getPartywiseSell(Connection cong,Connection conp,String company_id,String CompanyParty_Id, java.sql.Date fromDate ,java.sql.Date toDate,String currency)
	{
		//System.out.println("CompanyParty_Id"+CompanyParty_Id);
		//System.out.println("fromDate"+fromDate);
		int mm1=fromDate.getMonth();
		int dd1=fromDate.getDate();
		int yy1=fromDate.getYear();

		int yy2=toDate.getYear();
		yy2=(yy2+1900);
		int tempyy1=(yy1+1900);

		
		//System.out.println("Todate Year"+yy2);
		//System.out.println("Todate Year"+tempyy1);

		ArrayList ReceivableAmount=new ArrayList();
		java.sql.Date fromDate1=new java.sql.Date(yy1-1,mm1,dd1);
		int backOneYear=fromDate1.getYear();
		backOneYear=(backOneYear+1900);
		dd1=31;
		mm1=03;
		java.sql.Date toDate1=new java.sql.Date(yy1,mm1-1,dd1);
		
		//System.out.println("backOneYear"+backOneYear);
		//System.out.println("yy1"+yy1);
		//yy1=(yy1+1900);
		//System.out.println("toDate1"+toDate1);
		int i=0;
		int receive_fromid=0,oldreceive_fromId=0;
		int mm=0;
		int YY=0;
			errLine="87";		
			double janAmountLocal=0.0;
			double febAmountLocal=0.0;
			double marAmountLocal=0.0;
			double aprAmountLocal=0.0;
			double mayAmountLocal=0.0;
			double junAmountLocal=0.0;
			double julAmountLocal=0.0;
			double augAmountLocal=0.0;
			double sepAmountLocal=0.0;
			double octAmountLocal=0.0;
			double novAmountLocal=0.0;
			double decAmountLocal=0.0;
			double janAmountDollar=0.0;
			double febAmountDollar=0.0;
			double marAmountDollar=0.0;
			double aprAmountDollar=0.0;
			double mayAmountDollar=0.0;
			double junAmountDollar=0.0;
			double julAmountDollar=0.0;
			double augAmountDollar=0.0;
			double sepAmountDollar=0.0;
			double octAmountDollar=0.0;
			double novAmountDollar=0.0;
			double decAmountDollar=0.0;

			double LocalAmount=0.0,DollarAmount=0.0;
		double BeforeAprilDollarAmount=0.0;
		double BeforeAprilLocalAmount=0.0;
			try{

errLine="117";
// consignment_receiveid=0 and
				String query="select   Receive_fromId,sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal,  Month(Due_Date) as MM, Year(Due_Date) as YY ,Receive_Fromname from receive   where active=1 and   receive_sell=0  and purchase=1 and  company_id="+company_id+" and Due_Date between ? and ? and Receive_fromId in ("+CompanyParty_Id+") group by Month(Due_Date) ,Year(Due_Date), Receive_fromId,Receive_Fromname  order by Receive_Fromname";
				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setDate(1,fromDate1);
				pstmt_g.setDate(2,toDate);
errLine="122";
				rs_g=pstmt_g.executeQuery();
				while(rs_g.next())
				{
					receive_fromid=rs_g.getInt("Receive_fromId");
					LocalAmount=rs_g.getDouble("localtotal");
					DollarAmount=rs_g.getDouble("dollartotal");

					mm=rs_g.getInt("MM");
					YY=rs_g.getInt("YY");
					//System.out.println("YY"+YY);
					//if(yy2 == YY)
					//{
						//System.out.println("Years are Equals");
					//}
					if(i==0)
					{oldreceive_fromId=receive_fromid;}

					if(oldreceive_fromId==receive_fromid)
					{

						if(backOneYear ==YY && mm >= 4 || tempyy1 == YY && mm < 4)
						{
							BeforeAprilLocalAmount +=LocalAmount;
							BeforeAprilDollarAmount +=DollarAmount;
						
						}else
						if(mm==1 && yy2 == YY)
						{
							janAmountLocal=LocalAmount;
							janAmountDollar=DollarAmount;
						}else if(mm==2 && yy2 == YY)
						{
							febAmountLocal=LocalAmount;
							febAmountDollar=DollarAmount;
						}else if(mm==3 && yy2 == YY)
						{
							marAmountLocal=LocalAmount;
							marAmountDollar=DollarAmount;
						}else if(mm==4 && tempyy1 == YY)
						{
							aprAmountLocal=LocalAmount;
							aprAmountDollar=DollarAmount;
						}else if(mm==5 && tempyy1 == YY)
						{
							mayAmountLocal=LocalAmount;
							mayAmountDollar=DollarAmount;
						}else if(mm==6 && tempyy1 == YY)
						{
							junAmountLocal=LocalAmount;
							junAmountDollar=DollarAmount;
						}else if(mm==7 && tempyy1 == YY)
						{
							julAmountLocal=LocalAmount;
							julAmountDollar=DollarAmount;
						}else if(mm==8 && tempyy1 == YY)
						{
							augAmountLocal=LocalAmount;
							augAmountDollar=DollarAmount;
						}else if(mm==9 && tempyy1 == YY)
						{
							sepAmountLocal=LocalAmount;
							sepAmountDollar=DollarAmount;
						}else if(mm==10 && tempyy1 == YY)
						{
							octAmountLocal=LocalAmount;
							octAmountDollar=DollarAmount;
						}else if(mm==11 && tempyy1 == YY)
						{
							novAmountLocal=LocalAmount;
							novAmountDollar=DollarAmount;
						}else if(mm==12 && tempyy1 == YY)
						{
							decAmountLocal=LocalAmount;
							decAmountDollar=DollarAmount;
						}
					}
					else
					{
						


						/*String BeForeApril="select  sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal  from receive   where active=1 and   receive_sell=0  and purchase=1 and  company_id="+company_id+" and Due_Date between ? and ? and Receive_fromId="+oldreceive_fromId; 
						pstmt_p=conp.prepareStatement(BeForeApril);
						pstmt_p.setDate(1,fromDate1);
						pstmt_p.setDate(2,toDate1);
errLine="122";
						rs_p=pstmt_p.executeQuery();
						while(rs_p.next())
						{
						BeforeAprilLocalAmount=rs_p.getDouble("localtotal");
						BeforeAprilDollarAmount=rs_p.getDouble("dollartotal");

						}
						pstmt_p.close(); */
errLine="188";
						if("local".equals(currency))
						{
							ReceivableAmountReportRow RARR=new ReceivableAmountReportRow(oldreceive_fromId,janAmountLocal,febAmountLocal,marAmountLocal,aprAmountLocal,mayAmountLocal,junAmountLocal,julAmountLocal,augAmountLocal,sepAmountLocal,octAmountLocal,novAmountLocal,decAmountLocal,BeforeAprilLocalAmount);
							ReceivableAmount.add(RARR);
						oldreceive_fromId = receive_fromid;
						}
						else
						{
							ReceivableAmountReportRow RARR=new ReceivableAmountReportRow(oldreceive_fromId,janAmountDollar,febAmountDollar,marAmountDollar,aprAmountDollar,mayAmountDollar,junAmountDollar,julAmountDollar,augAmountDollar,sepAmountDollar,octAmountDollar,novAmountDollar,decAmountDollar,BeforeAprilDollarAmount);
							ReceivableAmount.add(RARR);
						oldreceive_fromId = receive_fromid;

						}
						
						
						BeforeAprilDollarAmount=0.0;
						BeforeAprilLocalAmount=0.0;
						 janAmountLocal=0.0;febAmountLocal=0.0; marAmountLocal=0.0;aprAmountLocal=0.0;  mayAmountLocal=0.0;junAmountLocal=0.0; julAmountLocal=0.0; augAmountLocal=0.0;  sepAmountLocal=0.0;octAmountLocal=0.0; novAmountLocal=0.0;decAmountLocal=0.0;
						 janAmountDollar=0.0; febAmountDollar=0.0; marAmountDollar=0.0; aprAmountDollar=0.0; mayAmountDollar=0.0; junAmountDollar=0.0; julAmountDollar=0.0; augAmountDollar=0.0; sepAmountDollar=0.0; octAmountDollar=0.0; novAmountDollar=0.0; decAmountDollar=0.0;

						 if(backOneYear ==YY && mm >= 4 || tempyy1 ==YY && mm <= 3)
						{
							BeforeAprilLocalAmount +=LocalAmount;
							BeforeAprilDollarAmount +=DollarAmount;
						
						}else if(mm==1)
						{
							janAmountLocal=LocalAmount;
							janAmountDollar=DollarAmount;
						}else if(mm==2)
						{
							febAmountLocal=LocalAmount;
							febAmountDollar=DollarAmount;
						}else if(mm==3)
						{
							marAmountLocal=LocalAmount;
							marAmountDollar=DollarAmount;
						}else if(mm==4 && tempyy1 == YY)
						{
							aprAmountLocal=LocalAmount;
							aprAmountDollar=DollarAmount;
						}else if(mm==5 && tempyy1 == YY)
						{
							mayAmountLocal=LocalAmount;
							mayAmountDollar=DollarAmount;
						}else if(mm==6 && tempyy1 == YY)
						{
							junAmountLocal=LocalAmount;
							junAmountDollar=DollarAmount;
						}else if(mm==7 && tempyy1 == YY)
						{
							julAmountLocal=LocalAmount;
							julAmountDollar=DollarAmount;
						}else if(mm==8 && tempyy1 == YY)
						{
							augAmountLocal=LocalAmount;
							augAmountDollar=DollarAmount;
						}else if(mm==9 && tempyy1 == YY)
						{
							sepAmountLocal=LocalAmount;
							sepAmountDollar=DollarAmount;
						}else if(mm==10 && tempyy1 == YY)
						{
							octAmountLocal=LocalAmount;
							octAmountDollar=DollarAmount;
						}else if(mm==11 && tempyy1 == YY)
						{
							novAmountLocal=LocalAmount;
							novAmountDollar=DollarAmount;
						}else if(mm==12 && tempyy1 == YY)
						{
							decAmountLocal=LocalAmount;
							decAmountDollar=DollarAmount;
						}

					}
					i++;
					
				}
				pstmt_g.close();
				
			/*	String BeForeApril="select  sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal  from receive   where active=1 and   receive_sell=0  and purchase=1 and  company_id="+company_id+" and Due_Date between ? and ? and Receive_fromId="+oldreceive_fromId; 
				pstmt_p=conp.prepareStatement(BeForeApril);
				pstmt_p.setDate(1,fromDate1);
				pstmt_p.setDate(2,toDate1);
errLine="122";	rs_p=pstmt_p.executeQuery();
				while(rs_p.next())
				{
					BeforeAprilLocalAmount=rs_p.getDouble("localtotal");
					BeforeAprilDollarAmount=rs_p.getDouble("dollartotal");
				}
				pstmt_p.close(); */

				if("local".equals(currency))
				{
					ReceivableAmountReportRow RARR=new ReceivableAmountReportRow(oldreceive_fromId,janAmountLocal,febAmountLocal,marAmountLocal,aprAmountLocal,mayAmountLocal,junAmountLocal,julAmountLocal,augAmountLocal,sepAmountLocal,octAmountLocal,novAmountLocal,decAmountLocal,BeforeAprilLocalAmount);
					ReceivableAmount.add(RARR);
					
				}
				else
				{
					ReceivableAmountReportRow RARR=new ReceivableAmountReportRow(oldreceive_fromId,janAmountDollar,febAmountDollar,marAmountDollar,aprAmountDollar,mayAmountDollar,junAmountDollar,julAmountDollar,augAmountDollar,sepAmountDollar,octAmountDollar,novAmountDollar,decAmountDollar,BeforeAprilDollarAmount);
					ReceivableAmount.add(RARR);
					
				}
				//System.out.println(" getPartywiseSell query="+query);
				
			}
			catch(Exception e)
			{
				System.out.println("Error Occure @ ReceiableAmountReport @ Line"+errLine+" "+e);
			}

			return ReceivableAmount;

	} // getPartywiseSell

	public ArrayList getPartywiseReceiveAmount(Connection cong,Connection conp,String company_id,String CompanyParty_Id, java.sql.Date fromDate ,java.sql.Date toDate,String currency)
	{
		ArrayList ReceiveAmount=new ArrayList();
		ArrayList ReceivableAmount=new ArrayList();
		
		int i=0;
		int receive_fromid=0,oldreceive_fromId=0;
		int mm=0;
			errLine="87";		
			double janAmountLocal=0.0;
			double febAmountLocal=0.0;
			double marAmountLocal=0.0;
			double aprAmountLocal=0.0;
			double mayAmountLocal=0.0;
			double junAmountLocal=0.0;
			double julAmountLocal=0.0;
			double augAmountLocal=0.0;
			double sepAmountLocal=0.0;
			double octAmountLocal=0.0;
			double novAmountLocal=0.0;
			double decAmountLocal=0.0;
			double janAmountDollar=0.0;
			double febAmountDollar=0.0;
			double marAmountDollar=0.0;
			double aprAmountDollar=0.0;
			double mayAmountDollar=0.0;
			double junAmountDollar=0.0;
			double julAmountDollar=0.0;
			double augAmountDollar=0.0;
			double sepAmountDollar=0.0;
			double octAmountDollar=0.0;
			double novAmountDollar=0.0;
			double decAmountDollar=0.0;

			double LocalAmount=0.0,DollarAmount=0.0;
			
			//double LocalAmount=0.0,DollarAmount=0.0;
			double BeforeAprilDollarAmount=0.0;
			double BeforeAprilLocalAmount=0.0;

			try{

errLine="309";
// consignment_receiveid=0 and

				String query="Select Receive_FromId, Month(Due_Date) as MM, Year(Due_Date) as YY,Sum(PD.Local_Amount) As localtotal,Sum(PD.Dollar_Amount) As dollartotal, Receive_FromName from Payment_Details PD, Receive R where PD.For_HeadId=R.Receive_Id and PD.For_Head=9 and PD.Active=1 and R.Active=1 and R.Company_Id="+company_id+" and R.Due_Date between ? and ? and R.Receive_fromId in ("+CompanyParty_Id+")  group by Receive_FromId, Month(Due_Date), Year(Due_DAte),Receive_FromName order by Receive_FromName";
					
				
				//"select   Receive_fromId,sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal,  Month(Due_Date) as MM, Year(Due_Date) as YY  from receive   where active=1 and  consignment_receiveid=0 and  receive_sell=0  and purchase=1 and  company_id="+company_id+" and receive_Date between ? and ? and Receive_fromId in ("+CompanyParty_Id+") group by Month(Due_Date) ,Year(Due_Date), Receive_fromId  order by receive_fromid";
			
				pstmt_g=cong.prepareStatement(query);
				pstmt_g.setDate(1,fromDate);
				pstmt_g.setDate(2,toDate);
errLine="318";
				rs_g=pstmt_g.executeQuery();
				while(rs_g.next())
				{
					receive_fromid=rs_g.getInt("Receive_fromId");
					mm=rs_g.getInt("MM");
					LocalAmount=rs_g.getDouble("localtotal");
					DollarAmount=rs_g.getDouble("dollartotal");
		
					if(i==0)
					{oldreceive_fromId=receive_fromid;}

					if(oldreceive_fromId==receive_fromid)
					{
						if(mm==1)
						{
							janAmountLocal=LocalAmount;
							janAmountDollar=DollarAmount;
						}else if(mm==2)
						{
							febAmountLocal=LocalAmount;
							febAmountDollar=DollarAmount;
						}else if(mm==3)
						{
							marAmountLocal=LocalAmount;
							marAmountDollar=DollarAmount;
						}else if(mm==4)
						{
							aprAmountLocal=LocalAmount;
							aprAmountDollar=DollarAmount;
						}else if(mm==5)
						{
							mayAmountLocal=LocalAmount;
							mayAmountDollar=DollarAmount;
						}else if(mm==6)
						{
							junAmountLocal=LocalAmount;
							junAmountDollar=DollarAmount;
						}else if(mm==7)
						{
							julAmountLocal=LocalAmount;
							julAmountDollar=DollarAmount;
						}else if(mm==8)
						{
							augAmountLocal=LocalAmount;
							augAmountDollar=DollarAmount;
						}else if(mm==9)
						{
							sepAmountLocal=LocalAmount;
							sepAmountDollar=DollarAmount;
						}else if(mm==10)
						{
							octAmountLocal=LocalAmount;
							octAmountDollar=DollarAmount;
						}else if(mm==11)
						{
							novAmountLocal=LocalAmount;
							novAmountDollar=DollarAmount;
						}else if(mm==12)
						{
							decAmountLocal=LocalAmount;
							decAmountDollar=DollarAmount;
						}
					}
					else
					{
						
						if("local".equals(currency))
						{
							PartywiseReceiveAmountRow PRAR=new PartywiseReceiveAmountRow(oldreceive_fromId,janAmountLocal,febAmountLocal,marAmountLocal,aprAmountLocal,mayAmountLocal,junAmountLocal,julAmountLocal,augAmountLocal,sepAmountLocal,octAmountLocal,novAmountLocal,decAmountLocal);
							ReceiveAmount.add(PRAR);
						oldreceive_fromId = receive_fromid;
						}
						else
						{
							PartywiseReceiveAmountRow PRAR=new PartywiseReceiveAmountRow(oldreceive_fromId,janAmountDollar,febAmountDollar,marAmountDollar,aprAmountDollar,mayAmountDollar,junAmountDollar,julAmountDollar,augAmountDollar,sepAmountDollar,octAmountDollar,novAmountDollar,decAmountDollar);
							ReceiveAmount.add(PRAR);
						oldreceive_fromId = receive_fromid;

						}
						
						 janAmountLocal=0.0;febAmountLocal=0.0; marAmountLocal=0.0;aprAmountLocal=0.0;  mayAmountLocal=0.0;junAmountLocal=0.0; julAmountLocal=0.0; augAmountLocal=0.0;  sepAmountLocal=0.0;octAmountLocal=0.0; novAmountLocal=0.0;decAmountLocal=0.0;
						 janAmountDollar=0.0; febAmountDollar=0.0; marAmountDollar=0.0; aprAmountDollar=0.0; mayAmountDollar=0.0; junAmountDollar=0.0; julAmountDollar=0.0; augAmountDollar=0.0; sepAmountDollar=0.0; octAmountDollar=0.0; novAmountDollar=0.0; decAmountDollar=0.0;
						if(mm==1)
						{
							janAmountLocal=LocalAmount;
							janAmountDollar=DollarAmount;
						}else if(mm==2)
						{
							febAmountLocal=LocalAmount;
							febAmountDollar=DollarAmount;
						}else if(mm==3)
						{
							marAmountLocal=LocalAmount;
							marAmountDollar=DollarAmount;
						}else if(mm==4)
						{
							aprAmountLocal=LocalAmount;
							aprAmountDollar=DollarAmount;
						}else if(mm==5)
						{
							mayAmountLocal=LocalAmount;
							mayAmountDollar=DollarAmount;
						}else if(mm==6)
						{
							junAmountLocal=LocalAmount;
							junAmountDollar=DollarAmount;
						}else if(mm==7)
						{
							julAmountLocal=LocalAmount;
							julAmountDollar=DollarAmount;
						}else if(mm==8)
						{
							augAmountLocal=LocalAmount;
							augAmountDollar=DollarAmount;
						}else if(mm==9)
						{
							sepAmountLocal=LocalAmount;
							sepAmountDollar=DollarAmount;
						}else if(mm==10)
						{
							octAmountLocal=LocalAmount;
							octAmountDollar=DollarAmount;
						}else if(mm==11)
						{
							novAmountLocal=LocalAmount;
							novAmountDollar=DollarAmount;
						}else if(mm==12)
						{
							decAmountLocal=LocalAmount;
							decAmountDollar=DollarAmount;
						}

					}
					i++;
					
				}
				pstmt_g.close();

					
				if("local".equals(currency))
				{
					PartywiseReceiveAmountRow PRAR=new PartywiseReceiveAmountRow(oldreceive_fromId,janAmountLocal,febAmountLocal,marAmountLocal,aprAmountLocal,mayAmountLocal,junAmountLocal,julAmountLocal,augAmountLocal,sepAmountLocal,octAmountLocal,novAmountLocal,decAmountLocal);
					ReceiveAmount.add(PRAR);
				}
				else
				{
					PartywiseReceiveAmountRow PRAR=new PartywiseReceiveAmountRow(oldreceive_fromId,janAmountDollar,febAmountDollar,marAmountDollar,aprAmountDollar,mayAmountDollar,junAmountDollar,julAmountDollar,augAmountDollar,sepAmountDollar,octAmountDollar,novAmountDollar,decAmountDollar);
					ReceiveAmount.add(PRAR);
						
				}
				//System.out.println("i="+i);
			}
			catch(Exception e)
			{
				System.out.println("Error Occure @ ReceiableAmountReport @ Line"+errLine+" "+e);
			}

			return ReceiveAmount;

	}

	public HashMap getReceivableofoldAmount(Connection cong,Connection conp,String Company_Id,String CopmpanyParty_Id,java.sql.Date fromDate,java.sql.Date toDate ,String currency ) 
	{
		int mm1=fromDate.getMonth();
		int dd1=fromDate.getDate();
		int yy1=fromDate.getYear();
		java.sql.Date fromDate1=new java.sql.Date(yy1-1,mm1,dd1);
		dd1=31;
		mm1=03;
		java.sql.Date toDate1=new java.sql.Date(yy1,mm1-1,dd1);
		//System.out.println("fromDate1"+fromDate1);
		//System.out.println("toDate1"+toDate1);
		double BeforeAprilDollarAmount=0.0;
		double BeforeAprilLocalAmount=0.0;
		try
		{
			String BeforeAprilData="Select R.Receive_fromId , Sum(PD.Local_Amount) As localtotal,Sum(PD.Dollar_Amount) As dollartotal  from Payment_Details PD, Receive R where PD.For_HeadId=R.Receive_Id and PD.For_Head=9 and PD.Active=1 and R.Active=1 and R.Company_Id="+Company_Id+" and  R.Due_Date between ? and ? and R.Receive_fromId in("+CopmpanyParty_Id+") group by Receive_fromId";
						
				pstmt_p=conp.prepareStatement(BeforeAprilData);
				pstmt_p.setDate(1,fromDate1);
				pstmt_p.setDate(2,toDate1);
				rs_p=pstmt_p.executeQuery();
				while(rs_p.next())
				{
					int Receive_FromId=rs_p.getInt("Receive_fromId");
					BeforeAprilLocalAmount=rs_p.getDouble("localtotal");
					BeforeAprilDollarAmount=rs_p.getDouble("dollartotal");
				//	System.out.println("Receive_FromId"+Receive_FromId);
					if(currency.equals("local"))
					{
						oldReceiveAmount.put(Receive_FromId,BeforeAprilLocalAmount);
					}
					else{
						oldReceiveAmount.put(Receive_FromId,BeforeAprilDollarAmount);
					}
				
				}
				pstmt_p.close();
			
				
				//System.out.println("BeforeAprilLocalAmount"+BeforeAprilLocalAmount);
				//System.out.println("BeforeAprilDollarAmount"+BeforeAprilDollarAmount);

			
		}
		catch (Exception e)
		{
			System.out.println("Error Occure @ "+e);
		}

		return  oldReceiveAmount;

	}


	public String getLotNo(Connection cong,String Company_Id)
	{
		String Lot_No="";
		CallableStatement cstmt_g=null;
		try
		{
			String lotNoQuery = "Select Lot_No,Lot_id from Lot where Active=1 and  Company_Id="+Company_Id+" order by Lot_No";
		
			pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_UPDATABLE);
			rs_g = pstmt_g.executeQuery();
			rs_g.last();
			int counter=rs_g.getRow();
			String lotNoArray[]=new String[counter];
			String Lotid[]=new String[counter];
			rs_g.beforeFirst();
			int i=0;
			while(rs_g.next()) 	
			{
				lotNoArray[i]= rs_g.getString("Lot_No");
				Lotid[i]= rs_g.getString("Lot_id");
				i++;
			}
			pstmt_g.close();

			
			xData=xData+"'<root>";
			//xData = xData +"<States lotid=32/>";
			//xData = xData +"<States lotid=44/>";
			//xData = xData +"<States lotid=50/>";

			for(i=0;i<5;i++)
			{
				//out.print("<br>Under For"+xmlData);

				xData = xData +"<States lotid=\""+Lotid[i]+"\"/>";
			
			} 
			xData=xData+"</root>'";
			System.out.println("xmlData"+xData);
			cstmt_g=cong.prepareCall("{call GetRegions_XML(?)}");
			cstmt_g.setString(1,xData);
			rs_g=cstmt_g.executeQuery();
			while(rs_g.next())
			{
				String lot_no=rs_g.getString("Lot_No");
				System.out.println("lot_no"+lot_no);
			}	
			cstmt_g.close(); 

		}
		catch (Exception e)
		{
			System.out.println("Error occure @ "+e);
		}
		return xData;

	}
	
	ArrayList a1=new ArrayList();
	public ArrayList getSellAmount(Connection cong,Connection conp,String company_id,String CompanyParty_Id, java.sql.Date fromDate ,java.sql.Date toDate,String currency)
	{
		System.out.println("fromDate"+fromDate);
		System.out.println("toDate"+toDate);
		int dd1=fromDate.getDate();
		int mm1=fromDate.getMonth();
		int yy1=fromDate.getYear();
		mm1=mm1+1;
		yy1=yy1+1900;
		int dd2=toDate.getDate();
		int mm2=toDate.getMonth();
		int yy2=toDate.getYear();
		yy2=yy2+1900;
		mm2=mm2+1;
		System.out.println("DD1:"+dd1+"mm1"+mm1+"yy1"+yy1);
		System.out.println("DD2:"+dd2+"mm2"+mm2+"yy2"+yy2);
			int mcount=0;
			int ycount=0;
			int ymonth=12;
		try
		{
			if(yy1==yy2)
			{
				mcount=mm2-mm1;
			}else{
					if(yy1 != yy2)
					{
						ycount=yy2-yy1;
						mcount=12-mm1;
						if(ycount==1)
						{
							mcount=mcount+mm2;
						}else{
							ymonth= 12 * (ycount-1);
							mcount +=ymonth;
							mcount +=mm2;
						}
					} 
			}
			
			System.out.println("Mcount"+mcount);
			int oldReceiveFrom_Id=0;
			int receive_fromid=0;
			 
			
			double localAmout[][]=new double[mcount][mcount];

			
			String Query="";
			
			String query="select   Receive_fromId,sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal,  Month(Due_Date) as MM, Year(Due_Date) as YY ,Receive_Fromname from receive   where active=1 and   receive_sell=0  and purchase=1 and  company_id="+company_id+" and Due_Date between ? and ? and Receive_fromId in ("+CompanyParty_Id+") group by Month(Due_Date) ,Year(Due_Date), Receive_fromId,Receive_Fromname  order by Receive_Fromname";
			pstmt_g=cong.prepareStatement(query);
			pstmt_g.setDate(1,fromDate);
			pstmt_g.setDate(2,toDate);
			rs_g=pstmt_g.executeQuery();
			while(rs_g.next())
			{

				//int receive_fromid=rs_g.getInt("Receive_fromId");
				double LocalAmount=rs_g.getDouble("localtotal");
				double DollarAmount=rs_g.getDouble("dollartotal");

				int mm=rs_g.getInt("MM");
				int YY=rs_g.getInt("YY");
				String Receive_FromName=rs_g.getString("Receive_Fromname");
				//partyAmountMonthYear PAMY=new partyAmountMonthYear(DollarAmount,mm,YY,receive_fromid,Receive_FromName);
					
			}
			pstmt_g.close();

		}catch (Exception e)
		{
			
		} 
		
		return a1;
	}

HashMap OutStanding=new HashMap();

	public HashMap getOutStasndingAmount(Connection cong,String company_id,String CompanyParty_Id, java.sql.Date fromDate ,String currency)
	{

		
		
		try
		{
			String Query="select   Receive_fromId,sum(Local_total)as localtotal , sum(Dollar_Total) as dollartotal from receive   where active=1 and   receive_sell=0   and purchase=1 and  company_id="+company_id+" and Due_Date < ? and  Receive_fromId in  ("+CompanyParty_Id+") group by receive_fromId  order by receive_fromId ";
			pstmt_g=cong.prepareStatement(Query,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt_g.setDate(1,fromDate);
			rs_g=pstmt_g.executeQuery();
			rs_g.last();
			int counter=rs_g.getRow();
			rs_g.beforeFirst();
			double sell_amount[]=new double[counter];
			int receivefrom_Id[]=new int[counter];
			int i=0;
			while(rs_g.next())
			{
				receivefrom_Id[i]=rs_g.getInt("Receive_fromId");
				if(currency.equals("local"))
				{
					sell_amount[i]=rs_g.getInt("localtotal");
				}else{
					sell_amount[i]=rs_g.getInt("dollartotal");
				}
				i++;
			}
			pstmt_g.close();

			HashMap Receive_Amount= new HashMap();
			HashMap ReceiveFromID= new HashMap();

			String QueryReceived="Select Receive_FromId,sum(PD.Local_Amount) As localtotal,Sum(PD.Dollar_Amount) As dollartotal from Payment_Details PD, Receive R where PD.For_HeadId=R.Receive_Id and PD.For_Head=9 and PD.Active=1 and R.Active=1 and R.Company_Id="+company_id+" and R.Due_Date < ? and R.Receive_fromId in ("+CompanyParty_Id+")  group by Receive_FromId order by Receive_FromId ";

			pstmt_g=cong.prepareStatement(QueryReceived,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt_g.setDate(1,fromDate);
			rs_g=pstmt_g.executeQuery();
			rs_g.last();
			int rowCount=rs_g.getRow();
			rs_g.beforeFirst();
			double Received_amount[]=new double[rowCount];
			int receivefromId[]=new int[rowCount];
			i=0;
			while(rs_g.next())
			{
				receivefromId[i]=rs_g.getInt("Receive_fromId");
				if(currency.equals("local"))
				{
					Received_amount[i]=rs_g.getInt("localtotal");
				}else{
					Received_amount[i]=rs_g.getInt("dollartotal");
				}

				Receive_Amount.put(i,Received_amount[i]);
				ReceiveFromID.put(receivefromId[i],i);
				i++;
			}
			pstmt_g.close();
			
			for(i=0;i<counter;i++ )
			{
				if(ReceiveFromID.containsKey(receivefrom_Id[i]))
				{
					int k=(Integer)ReceiveFromID.get(receivefrom_Id[i]);
					double tempAmount=(Double)Receive_Amount.get(k);
					sell_amount[i] = sell_amount[i] - tempAmount;
					//System.out.println("tempAmount"+tempAmount);
				}

				OutStanding.put(receivefrom_Id[i],sell_amount[i]);

				//System.out.println("receivefrom_Id"+receivefrom_Id[i]);
				//System.out.println("Sell Amount"+sell_amount[i]);
			}
			

		}
		catch (Exception e)
		{
			System.out.println("Error Occure "+e);
		}

		return OutStanding;
	}
}