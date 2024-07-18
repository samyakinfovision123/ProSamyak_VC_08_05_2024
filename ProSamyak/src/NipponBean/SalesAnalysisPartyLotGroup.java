package NipponBean;
import java.util.*;
import java.sql.*;


public class SalesAnalysisPartyLotGroup
{
	List<String> lot_group_id_list = new ArrayList<String>();
	List<String> new_lot_group_id_list = new ArrayList<String>();
	List companyParty_id_list = new ArrayList();
	Map lots=new HashMap();
	Map final_lots=new HashMap();
	Map lot_group_map=new HashMap();
	Map lot_sale_rate_map=new HashMap(); 
	String party_list="";
	String lot_list="";
	ResultSet rs = null;
	ResultSet rs_g = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt_g = null;
	String errLine="20";
	String group_list="(";
	Stock S;
	public SalesAnalysisPartyLotGroup()
	{
		S=new Stock();
		lots.clear();
		final_lots.clear();
		lot_group_map.clear();
		lot_sale_rate_map.clear();
		lot_group_id_list.clear();
		new_lot_group_id_list.clear();
		companyParty_id_list.clear();
	}

	 /*
	  *Start : method to load ledger names and account names
	 */
	
	public void loadgroups(Connection cong,String lot_group_id[],String companyParty_id[],
			String company_id)
		
	{
		try
		{
			
			errLine="34";
			lot_group_id_list=Arrays.asList(lot_group_id);
			companyParty_id_list=Arrays.asList(companyParty_id);
			party_list="(";
			int i=0;
			for(i=0;i<(companyParty_id.length-1);i++)
			{
				party_list+=companyParty_id[i]+",";
			} //for
			
			party_list+=companyParty_id[i]+",-1)";
			errLine="45";
			group_list="(";
			int j=0;
			for(j=0;j<(lot_group_id.length-1);j++)
			{
				group_list+=lot_group_id[j]+",";
			} //for
			
			group_list+=lot_group_id[j]+",-1)";
			errLine="54";
			
			String str_query="select D.lot_id,D.group_id from Diamond as D,Lot as L where " +
					"D.lot_id=L.lot_id and L.company_id="+company_id+" and  " +
							"D.group_id in "+group_list+" order by group_id";
			//System.out.println("str_query="+str_query);
			pstmt_g =cong.prepareStatement(str_query,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			rs_g = pstmt_g.executeQuery();
			String temp_str_lot_id="";
			while(rs_g.next())
			{
				//System.out.println("62 temp_str_lot_id="+temp_str_lot_id);
				if (rs_g.isFirst())
				{
					// System.out.println("65
					// temp_str_lot_id="+temp_str_lot_id);
					String str_lot = rs_g.getString("lot_id");

					String str_group = rs_g.getString("group_id");
					temp_str_lot_id += "-1," + str_lot;
					new_lot_group_id_list.add(str_group);
					// System.out.println("67
					// temp_str_lot_id="+temp_str_lot_id);
				}
				else
				{
					//System.out.println("73 temp_str_lot_id="+temp_str_lot_id);
					String str_lot=rs_g.getString("lot_id");	
					String str_group=rs_g.getString("group_id");
					String str=(String)new_lot_group_id_list.get(new_lot_group_id_list.size()-1);
					//System.out.println("str_group="+str_group);
					//System.out.println("str="+str);
					if(str_group.equals(str))
					{
						
						temp_str_lot_id+=","+str_lot;
						if(rs_g.isLast())
						{
							//System.out.println(" 88 temp_str_lot_id="+temp_str_lot_id);
							//System.out.println("90 HELLO="+(new_lot_group_id_list.size()-1));
							lot_group_map.put((String)new_lot_group_id_list.get(new_lot_group_id_list.size()-1),temp_str_lot_id);
						}
					}
					else
					{
						
						int idx=(new_lot_group_id_list.size()-1);
						
						//System.out.println("98 HELLO="+(new_lot_group_id_list.size()-1));
						lot_group_map.put((String)new_lot_group_id_list.get(new_lot_group_id_list.size()-1),temp_str_lot_id);
						new_lot_group_id_list.add(str_group);
						temp_str_lot_id="-1,"+str_lot;
						if(rs_g.isLast())
						{
							lot_group_map.put((String)new_lot_group_id_list.get(new_lot_group_id_list.size()-1),temp_str_lot_id);
						}
					}	
				}
			
			
			}//while()
		pstmt_g.close();
		
		
		errLine="84";
		//System.out.println("lot_group_map="+lot_group_map.size());
		} //try
		catch(Exception e)
		{
			System.out.println("Exception e="+e+" errLine="+errLine);
		} //catch(Exception)
	}
	
	//End : method to load ledger names and account names
	
	//Start : making all the sales calculations
	public Map getSalesTransactionForAllLot(Connection cong,Connection conp, java.sql.Date fromDate,
			java.sql.Date toDate,java.sql.Date cost_rate_date,String company_id,String reportyearend_id,String cost_rate_type)
	{

		try
		{
			//System.out.println("147");
			String str_query="select D.lot_id,D.group_id from Diamond as D,Lot as L " +
					"where D.lot_id=L.lot_id and L.company_id="+company_id+" and  " +
							"D.group_id in "+group_list+" order by group_id";
			pstmt_g =cong.prepareStatement(str_query);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next())
			{
				String lotid=rs_g.getString("lot_id");
				String str_rates= ""+S.lotRateLocalDollar(conp, Integer.parseInt(lotid),"0", toDate,
						company_id,reportyearend_id,"both", cost_rate_type);
				StringTokenizer str_tokens=new StringTokenizer(str_rates,"#");
				
				String costRate=str_tokens.nextToken();
				String localCostRate=str_tokens.nextToken();
				lot_sale_rate_map.put(lotid,costRate+"#"+localCostRate);
				
			}
			pstmt_g.close();
			
			errLine="101";
			str_query="select R.Receive_FromId, D.Group_Id,MG.Group_Name,Sum(Quantity) as Qty, " +
					"Sum(Dollar_Price * Quantity) as dollarAmt,Sum(Local_Price * Quantity) as localAmt " +
					"from Receive R,Receive_Transaction RT,Diamond as D,Master_Group as MG where " +
					"R.Purchase=1 and R.Receive_sell=0 and R.Opening_Stock=0 and R.R_Return=0 " +
					"and R.Stocktransfer_Type=0 and R.Receive_Id=RT.Receive_Id and R.Active=1 " +
					"and RT.lot_Id=D.lot_Id and MG.group_id=D.group_Id and D.group_Id in "+group_list+" " +
					"and R.Receive_FromId in "+party_list+" and RT.Active=1 and R.company_id="+company_id+
					" and R.Receive_Date>=? and R.Receive_Date<=? group by D.Group_Id,MG.Group_Name," +
					"R.Receive_FromId";
			//System.out.println(str_query);
			pstmt_g =cong.prepareStatement(str_query);
			pstmt_g.setString(1,""+fromDate);
			pstmt_g.setString(2,""+toDate);
			rs_g = pstmt_g.executeQuery();
			int row_counter=0;
			String receive_from_id="";
			String group_id="";
			String group_name="";
			double qty=0;
			double local_sale_amount=0;
			double dollar_sale_amount=0;
			double dollar_cost_amount_total=0;
			double local_sale_rate=0;
			double dollar_sale_rate=0;
			double local_cost_rate=0;
			double dollar_cost_rate=0;
			double local_cost_amount=0;
			double dollar_cost_amount=0;
			double profitloss_local=0;
			double profitloss_dollar=0;
		
			
			aa:while(rs_g.next())
			{
				row_counter=0;
				receive_from_id=rs_g.getString("Receive_FromId");
				group_id=rs_g.getString("Group_Id");
				group_name=rs_g.getString("Group_Name");
				qty=rs_g.getDouble("Qty");
				dollar_sale_amount=rs_g.getDouble("dollarAmt");
				local_sale_amount=rs_g.getDouble("localAmt");
				
				errLine="144";
				String lotid=(String)lot_group_map.get(group_id);
				
				//System.out.println("lot_group_map.size()="+lot_group_map.size());
				//System.out.println("lotid="+lotid);
				//System.out.println("group_id="+group_id);
				//System.out.println("receive_from_id="+receive_from_id);
				//System.out.print("lotid="+lotid);
				String lotid_array[]=lotid.split(",");
				errLine="147";
				double costRatePerTransTotal=0;
				double localCostRatePerTransTotal=0;
				
				/*
				 * Get lot_id included in transaction
				 */
					
				ArrayList<String> temp_lot_id_list=new ArrayList<String>();
				String str_lot_id="select  distinct(RT.Lot_Id) as cnt from Receive R,Receive_Transaction RT where R.Purchase=1 and R.Receive_sell=0 and R.Opening_Stock=0 and R.R_Return=0 and R.Stocktransfer_Type=0 and R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.Receive_Date>='"
					+ fromDate
					+ "' and R.Receive_Date<='"
					+ toDate
					+ "' and R.Receive_FromId="
					+ receive_from_id
					+ " and RT.Lot_Id in("
					+ lotid + ")";
				pstmt =cong.prepareStatement(str_lot_id);
				//System.out.println("str_lot_id="+str_lot_id);
				rs = pstmt.executeQuery();
				while(rs.next())
				{
					temp_lot_id_list.add(rs.getString("cnt"));
				}
				pstmt.close();
				/*
				 * End To Get lot_id included in transaction
				 */
				
				
				for(int i=0;i<lotid_array.length;i++)
				{
					if(temp_lot_id_list.contains(lotid_array[i]))
					{
					//System.out.println("lot array="+lotid_array[i]);
					//System.out.println("lot_sale_rate_map.size="+lot_sale_rate_map.size());
					String str=(String)lot_sale_rate_map.get(lotid_array[i]);
					if(str==null)
					  continue aa;
					//System.out.println("str="+str);
					StringTokenizer tokens=new StringTokenizer(str,"#");
					String str1=tokens.nextToken();
					String str2=tokens.nextToken();
					//System.out.println("str="+str);
					//System.out.println("str1="+str1);
					//System.out.println("str2="+str2);
					
					costRatePerTransTotal +=Double.parseDouble(str2);
				
					localCostRatePerTransTotal +=Double.parseDouble(str1);					
					row_counter++;
					}
				}
				/*
				 * clear lot_id list
				 */
				temp_lot_id_list.clear();
				//System.out.println("183 costRatePerTransTotal="+costRatePerTransTotal);
				errLine="159";
				dollar_sale_rate=dollar_sale_amount/qty;
				local_sale_rate=local_sale_amount/qty;
				
				dollar_cost_rate=costRatePerTransTotal/row_counter;
				local_cost_rate=localCostRatePerTransTotal/row_counter;
				
				dollar_cost_amount=qty*dollar_cost_rate;
				local_cost_amount=qty*local_cost_rate;
				
				profitloss_dollar = dollar_sale_amount-dollar_cost_amount;
				profitloss_local = local_sale_amount-local_cost_amount;

				SalesRow srow=new SalesRow(receive_from_id,group_id,group_name,qty,local_sale_rate,
						local_sale_amount,local_cost_rate,local_cost_amount,profitloss_local,
						dollar_sale_rate,dollar_sale_amount,dollar_cost_rate,dollar_cost_amount,
						profitloss_dollar,0,0,0,0,0);
				lots.put(receive_from_id+"&"+group_id,srow);
				final_lots.put(receive_from_id+"&"+group_id,srow);
				//System.out.println("lots="+lots.size());
				//System.out.println("final_lots="+final_lots.size());
			} //while
			pstmt_g.close();
			errLine="162";
			Iterator iterator=companyParty_id_list.iterator();
			while(iterator.hasNext())
			{
				String temp_party_id=(String)iterator.next(); 
				
				Set set=lots.keySet();
				Iterator itr=set.iterator();
				double qty_total=0;
				double local_sale_amount_total=0;
				double dollar_sale_amount_total=0;
				double local_cost_amount_total=0;
				double profitloss_local_total=0;
				while(itr.hasNext())
				{
					String key1=(String)itr.next();	
					SalesRow srow=(SalesRow)lots.get(key1);
					if(srow.getReceiveFromId().equals(temp_party_id))
					{
						qty_total+=srow.getQty();
						local_sale_amount_total+=srow.getLocalSaleAmount();
						dollar_sale_amount_total+=srow.getDollarSaleAmount();
						local_cost_amount_total+=srow.getLocalCostAmount();
						profitloss_local_total+=srow.getProfitLossLocal();	
						dollar_cost_amount_total+=srow.getDollarCostAmount();
					} //if(srow.getReceiveFromId().equals(temp_party_id))

				} //while
				//System.out.println("qty_total="+qty_total);
				Set final_set=final_lots.keySet();
				Iterator final_itr=final_set.iterator();
				
				while(final_itr.hasNext())
				{
					String key1=(String)final_itr.next();	
					SalesRow srow=(SalesRow)final_lots.get(key1);
					if(srow.getReceiveFromId().equals(temp_party_id))
					{
						double temp_qty=srow.getQty();
						//System.out.println("temp_qty="+temp_qty);
						srow.setCaratsAvg(temp_qty*(100)/qty_total);
						
						double temp_sale_amount=srow.getLocalSaleAmount();
						srow.setSaleAvg(temp_sale_amount*(100)/local_sale_amount_total);
						
						double temp_profit_loss=srow.getProfitLossLocal();
						double temp_cost_amont_local=srow.getLocalCostAmount();
						
						if(temp_cost_amont_local!=0)
						{
							srow.setProfitPerLocal(temp_profit_loss*(100)/temp_cost_amont_local);
						}
						else
						{
							srow.setProfitPerLocal(0);
						}
						temp_profit_loss=srow.getProfitLossDollar();
						double temp_cost_amont_dollar=srow.getDollarCostAmount();
						if(temp_cost_amont_local!=0)
						{
							srow.setProfitPerDollar(temp_profit_loss*(100)/temp_cost_amont_dollar);
						}
						else
						{
							srow.setProfitPerDollar(0);
						}
						temp_profit_loss=srow.getProfitLossLocal();
						srow.setProfitLossPer(temp_profit_loss*(100)/profitloss_local_total);
					
				  } //if

				} //while

			} //while
		}//try
		catch(Exception e)
		{
			System.out.println("Exception e="+e+" errLine="+errLine);
		}
		finally
		{
			return final_lots;
		}
	} //public void getSalesTransactionForAllLot(Connection cong, java.sql.Date fromDate, java.sql.Date toDate,java.sql.Date cost_rate_date,String company_id,String reportyearend_id,String cost_rate_type)
	//End : method to load ledger names and account names

public class SalesRow
{
	private String receive_from_id;
	private String group_id;
	private String group_name;
	private double qty;
	private double local_sale_rate;
	private double local_sale_amount;
	private double local_cost_rate;
	private double local_cost_amount;
	private double profitloss_local;
	private double dollar_sale_rate;
	private double dollar_sale_amount;
	private double dollar_cost_rate;
	private double dollar_cost_amount;
	private double profitloss_dollar;
	private double carats_avg;
	private double sale_avg;
	private double local_profit_per;
	private double dollar_profit_per;
	private double profitloss_per;
	
	public SalesRow(String receive_from_id,String group_id,String group_name,
			double qty,double local_sale_rate,double local_sale_amount,
			double local_cost_rate,double local_cost_amount,double profitloss_local,
			double dollar_sale_rate,double dollar_sale_amount,double dollar_cost_rate,
			double dollar_cost_amount,double profitloss_dollar,double carats_avg,double sale_avg,
			double local_profit_per,double dollar_profit_per,double profitloss_per)
	{
		this.receive_from_id=receive_from_id;
		this.group_id=group_id;
		this.group_name=group_name;
		this.qty=qty;
		this.local_sale_rate=local_sale_rate;
		this.local_sale_amount=local_sale_amount;
		this.local_cost_rate=local_cost_rate;
		this.local_cost_amount=local_cost_amount;
		this.profitloss_local=profitloss_local;
		this.dollar_sale_rate=dollar_sale_rate;
		this.dollar_sale_amount=dollar_sale_amount;
		this.dollar_cost_rate=dollar_cost_rate;
		this.dollar_cost_amount=dollar_cost_amount;
		this.profitloss_dollar=profitloss_dollar;
		this.carats_avg=carats_avg;
		this.sale_avg=sale_avg;
		
		this.local_profit_per=local_profit_per;
		this.dollar_profit_per=dollar_profit_per;
		this.profitloss_per=profitloss_per;

	}
	
	public String getReceiveFromId()
	{
		return this.receive_from_id;
	}
	public String getGroupId()
	{
		return this.group_id;
	}
	public String getGroupName()
	{
		return this.group_name;
	}
	public double getQty()
	{
		return this.qty;
	}
	public double getLocalSaleRate()
	{
		return this.local_sale_rate;
	}
	public double getLocalSaleAmount()
	{
		return this.local_sale_amount;
	}

	public double getLocalCostRate()
	{
		return this.local_cost_rate;
	}
	public double getLocalCostAmount()
	{
		return this.local_cost_amount;
	}
	public double getProfitLossLocal()
	{
		return this.profitloss_local;
	}
	public double getDollarSaleRate()
	{
		return this.dollar_sale_rate;
	}
	public double getDollarSaleAmount()
	{
		return this.dollar_sale_amount;
	}

	public double getDollarCostRate()
	{
		return this.dollar_cost_rate;
	}
	public double getDollarCostAmount()
	{
		return this.dollar_cost_amount;
	}
	public double getProfitLossDollar()
	{
		return this.profitloss_dollar;
	}
	public double getCaratsAvg()
	{
		return this.carats_avg;
	}
	public double getSaleAvg()
	{
		return this.sale_avg;
	}
	public double getProfitPerLocal()
	{
		return this.local_profit_per;
	}
	public double getProfitPerDollar()
	{
		return this.dollar_profit_per;
	}
	public double getProfitlossPer()
	{
		return this.profitloss_per;
	}


	public void setCaratsAvg(double carats_avg)
	{
		this.carats_avg=carats_avg;
	}
	public void setSaleAvg(double sale_avg)
	{
		this.sale_avg=sale_avg;
	}
	public void setProfitPerLocal(double local_profit_per)
	{
		this.local_profit_per=local_profit_per;
	}
	public void setProfitPerDollar(double dollar_profit_per)
	{
		this.dollar_profit_per=dollar_profit_per;
	}
	public void setProfitLossPer(double profitloss_per)
	{
		this.profitloss_per=profitloss_per;
	}
	
}
}

