package NipponBean;

import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

//this bean is used to return salemanwise monthly sales for the graphical report
public class SalesmanMonthlySales
{
	private String salesmanNames[]; //names of the salesman
	private String xMonths[]; //the labels on X axis
	private double sales[][]; //monthly sales per salesman
	private String links[][]; //stores links for each point

	private String month[]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep" ,"Oct","Nov","Dec"};

	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;

	Connect C;

   /**
   * Creates a new instance
   */
	public SalesmanMonthlySales() {
		try{
			C = new Connect();		
		}
		catch(Exception e){
			System.out.println("Exception in SalesmanMonthlySales() in SalesmanMonthlySales.java="+e);
		}
		
	}

	
	public String[] getSalesmanNames(){
		return salesmanNames;
	}

	public String[] getXMonths(){
		return xMonths;
	}

	public double[][] getSales(){
		return sales;
	}

	public String[][] getLinks(){
		return links;
	}
	
	//calculates the monthly sales of the salesperson_id sent of the given company between the selected date range
	public void calcMonthlySales(String company_id, String salesperson_id[], java.sql.Date fromDate, java.sql.Date toDate)
	{
		String errLine = "52";
		String query = "";
				
		try{
			cong = C.getConnection();
				
			int dd1 = fromDate.getDate();
			int mm1 = fromDate.getMonth()+1;
			int yy1 = fromDate.getYear()+1900;
			int dd2 = toDate.getDate();
			int mm2 = toDate.getMonth()+1;
			int yy2 = toDate.getYear()+1900;

			int periods=0;
			int salesmanCnt=salesperson_id.length;

			//read the fromdate and todate and generate the month labels on the X-axis

			java.sql.Date FirstDate = new java.sql.Date((yy1-1900),(mm1-1), dd1);
		
			java.sql.Date LastDate = new java.sql.Date((yy2-1900),(mm2-1), dd2);

			Calendar tmpFromDate = Calendar.getInstance();
			Calendar tmpToDate = Calendar.getInstance();
			Calendar tmpLastDate = Calendar.getInstance();

			tmpFromDate.set(yy1, mm1-1, dd1);
			tmpLastDate.set(yy2, mm2-1, dd2);
			
			tmpToDate.set(yy1, mm1-1, tmpFromDate.getActualMaximum(5));

			tmpLastDate.set(yy2, mm2-1,	tmpLastDate.getActualMaximum(5));
			
			while(tmpToDate.compareTo(tmpLastDate)<=0)
			{
				java.sql.Date fdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
				
				java.sql.Date tdate = new java.sql.Date(tmpToDate.get(1)-1900, tmpToDate.get(2), tmpToDate.get(5));

				periods++;				
				
				tmpFromDate.set(tdate.getYear()+1900, tdate.getMonth(), tdate.getDate()+1);
			
				java.sql.Date tmpfdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
				
				tmpToDate.set(tmpfdate.getYear()+1900,tmpfdate.getMonth(), tmpFromDate.getActualMaximum(5));	
	
			}//while tmp loop
			errLine="103";

			tmpFromDate.set(yy1, mm1-1, dd1);
			tmpLastDate.set(yy2, mm2-1, dd2);
			
			tmpToDate.set(yy1, mm1-1, tmpFromDate.getActualMaximum(5));

			tmpLastDate.set(yy2, mm2-1,	tmpLastDate.getActualMaximum(5));
			xMonths = new String[periods];
			int dy = 0;		
			while(tmpToDate.compareTo(tmpLastDate)<=0)
			{
				java.sql.Date fdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
				
				java.sql.Date tdate = new java.sql.Date(tmpToDate.get(1)-1900, tmpToDate.get(2), tmpToDate.get(5));
				
				errLine="117";
				xMonths[dy] = "" + month[tmpFromDate.get(2)] + "-0" + (tmpFromDate.get(1)-2000);
				
				
				tmpFromDate.set(tdate.getYear()+1900, tdate.getMonth(), tdate.getDate()+1);
			
				java.sql.Date tmpfdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
				
				tmpToDate.set(tmpfdate.getYear()+1900,tmpfdate.getMonth(), tmpFromDate.getActualMaximum(5));

				dy++;
			}//while tmp loop
			errLine="128";


			//read the salesman names to be displayed as lines in the line graph
			String strSId = "-1";
			for(int i=0; i<salesperson_id.length; i++)
			{
				strSId += ", "+salesperson_id[i];
			}

			strSId = "("+strSId+")";

			salesmanNames = new String[salesmanCnt];
			query ="Select Salesperson_Name from Master_Salesperson where company_id="+company_id+" and active=1 and salesperson_id in "+strSId+" order by Salesperson_Id";

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			int c=0;
			while(rs_g.next())
			{
				salesmanNames[c] = rs_g.getString("Salesperson_Name");	
				c++;
			}
			rs_g.close();
			pstmt_g.close();
			errLine = "153";


			//getting the monthly salesman wise sales of a company
			ArrayList salepersonId = new ArrayList();
			ArrayList saleAmt = new ArrayList();
			ArrayList salePeriod = new ArrayList();

			query ="Select Salesperson_id, Sum(Local_Total) as LocalSales, Month(Receive_Date) as MM, Year(Receive_Date) as YY from Receive where Purchase=1 and Receive_sell=0 and Active=1 and R_Return=0 and Opening_Stock=0 and StockTransfer_Type=0 and company_id="+company_id+" and salesperson_id in "+strSId+" and Receive_Date between ? and ? group by salesperson_id, Month(Receive_Date), Year(Receive_Date) order by salesperson_id, Year(Receive_Date), Month(Receive_Date)";

			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setDate(1, fromDate);
			pstmt_g.setDate(2, toDate);
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				String spId = rs_g.getString("Salesperson_id");
				salepersonId.add(spId);	
				double amt = rs_g.getDouble("LocalSales");
				saleAmt.add(amt);
				int mon = rs_g.getInt("MM");
				int yr = rs_g.getInt("YY");
				java.sql.Date period = new java.sql.Date(yr-1900, mon-1, 1);
				salePeriod.add(period);
					
			}
			rs_g.close();
			pstmt_g.close();
			errLine = "183";

			sales = new double[periods][salesmanCnt];
			links = new String[periods][salesmanCnt];

			//get the actual sales figures
			for(int i=0; i<salesmanCnt; i++)
			{
				String spId = salesperson_id[i];
				int fIdx = salepersonId.indexOf(spId);
				int lIdx = salepersonId.lastIndexOf(spId);
			
				if(fIdx == -1)
				{
					for(int j=0; j<periods; j++)		
					{
						sales[j][i] = 0;						
					}
				}
				else
				{
					errLine="202";
					List tmpSaleAmt = saleAmt.subList(fIdx, lIdx+1);
					List tmpSalePeriod = salePeriod.subList(fIdx, lIdx+1);

					errLine="206";
					tmpFromDate.set(yy1, mm1-1, dd1);
					tmpLastDate.set(yy2, mm2-1, dd2);
			
					tmpToDate.set(yy1, mm1-1, tmpFromDate.getActualMaximum(5));

					tmpLastDate.set(yy2, mm2-1,	tmpLastDate.getActualMaximum(5));
					int k=0;
					while(tmpToDate.compareTo(tmpLastDate)<=0)
					{
						java.sql.Date compareddate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), 1);

						if(tmpSalePeriod.contains(compareddate))
						{
							int idx = tmpSalePeriod.indexOf(compareddate);
							double sAmt = ((Double)tmpSaleAmt.get(idx)).doubleValue();
							sales[k][i] = sAmt;
						}
						else
						{
							sales[k][i] = 0;							
						}

						java.sql.Date fdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
						
						java.sql.Date tdate = new java.sql.Date(tmpToDate.get(1)-1900, tmpToDate.get(2), tmpToDate.get(5));
						
						
						tmpFromDate.set(tdate.getYear()+1900, tdate.getMonth(), tdate.getDate()+1);
					
						java.sql.Date tmpfdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
						
						tmpToDate.set(tmpfdate.getYear()+1900,tmpfdate.getMonth(), tmpFromDate.getActualMaximum(5));
			
						k++;
					}//while tmp loop
				}
			}

			
			//get the links required
			for(int i=0; i<salesmanCnt; i++)
			{
				tmpFromDate.set(yy1, mm1-1, dd1);
				tmpLastDate.set(yy2, mm2-1, dd2);
			
				tmpToDate.set(yy1, mm1-1, tmpFromDate.getActualMaximum(5));

				tmpLastDate.set(yy2, mm2-1,	tmpLastDate.getActualMaximum(5));
				int k=0;
				while(tmpToDate.compareTo(tmpLastDate)<=0)
				{
					//java.sql.Date compareddate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), 1);

					links[k][i] = "&salesperson_id="+salesperson_id[i]+"&company_id="+company_id+"&dd1=1&mm1="+(tmpFromDate.get(2)+1)+"&yy1="+tmpFromDate.get(1)+"&dd2="+tmpToDate.get(5)+"&mm2="+(tmpToDate.get(2)+1)+"&yy2="+tmpToDate.get(1);
					
					java.sql.Date fdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
						
					java.sql.Date tdate = new java.sql.Date(tmpToDate.get(1)-1900, tmpToDate.get(2), tmpToDate.get(5));
						
						
					tmpFromDate.set(tdate.getYear()+1900, tdate.getMonth(), tdate.getDate()+1);
					
					java.sql.Date tmpfdate = new java.sql.Date(tmpFromDate.get(1)-1900, tmpFromDate.get(2), tmpFromDate.get(5));
						
					tmpToDate.set(tmpfdate.getYear()+1900,tmpfdate.getMonth(), tmpFromDate.getActualMaximum(5));
			
					k++;
				}//while tmp loop
			}


			C.returnConnection(cong);
		}catch(Exception e)
		{
			C.returnConnection(cong);
			System.out.println("Exception in file SalesmanMonthlySales.java at method calcMonthlySales() after line="+errLine+" :" +e);
		}
	
	}//calcMonthlySales


	
	
	
	
}	

