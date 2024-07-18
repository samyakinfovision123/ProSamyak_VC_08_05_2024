package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class StockPreview
{
	private	PreparedStatement pstmt_g = null;
	private	PreparedStatement pstmt_g1 = null;
	private ResultSet rs_g = null;
	private ResultSet rs_g1 = null;

	ArrayList stockDataList = new ArrayList();
	
	HashMap idMap = new HashMap();
	HashMap Group_Name = new HashMap();
	HashMap Size_Name = new HashMap();
	HashMap Description_Name= new HashMap();
	
	String countquery = "";
	String groupquery = "";
	String exchnage_rateQuery = "";
	String query = "";
	
	int errLine = 26;

	public HashMap getIdMap(Connection cong,String company_id)
	{
		try
		{
			query = "Select Unit_Id,Unit_Name from Master_Unit where company_id="+company_id; 

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			errLine = 62;
			int Count = 0;

			while(rs_g.next())
			{
				String unitId = rs_g.getString("Unit_Id");
				String unitName = rs_g.getString("Unit_Name");

				idMap.put(unitId,unitName);
			}
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("78 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return idMap; 
	
	}//end public HashMap getIdMap(Connection cong,String company_id)

	public String getPurchaseSaleGroupId(Connection cong,String column,String table,String condition)
	{
		String purchaseSaleGroupId = "";

		try
		{
			query = "Select "+column+" from "+table+""+condition; 

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			errLine = 95;
			while(rs_g.next())
			{
				purchaseSaleGroupId = rs_g.getString(column);
			}
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("106 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return purchaseSaleGroupId; 
	
	}//end public int getPurchaseSaleGroupId(Connection cong,String column,String table,String condition)
	
	public int getCount(Connection cong,String table,String condition)
	{
		int Count = 0;

		try
		{
			countquery = "Select count(*) as Group_Count from "+table+""+condition; 

			pstmt_g = cong.prepareStatement(countquery);
			rs_g = pstmt_g.executeQuery();
			errLine = 123;
			while(rs_g.next())
			{
				Count = rs_g.getInt("Group_Count");
			}
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("134 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return Count; 
	
	}//end public int getCount(Connection cong,String table,String condition)

	public String[] getIdList(Connection cong,String column,String table,String condition,String order_by)
	{
		String selectedgroup_id[] = null;

		try
		{
			//loading all the group ids when a lot_no wise display is selected
			
			groupquery = "Select count(distinct(MG."+column+")) as groupCount from "+table+""+condition;
			errLine = 154;	
			
			pstmt_g =cong.prepareStatement(groupquery);
			rs_g = pstmt_g.executeQuery();

			int groupCount=0;
			
			while(rs_g.next())
			{
				groupCount = rs_g.getInt("groupCount");
			}
			rs_g.close();
			pstmt_g.close();

			selectedgroup_id = new String[groupCount];

			groupquery = "Select distinct( MG."+column+") from "+table+""+condition;
			errLine = 154;	
			
			pstmt_g =cong.prepareStatement(groupquery);
			rs_g = pstmt_g.executeQuery();

			int c=0;
			
			while(rs_g.next())
			{
				selectedgroup_id[c] = rs_g.getString(column);
				c++;
			}
			rs_g.close();
			pstmt_g.close();

			//groupIdList = "(" + groupIdList + ")";

		}//end try
		catch (Exception e)
		{
			System.out.println("174 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return selectedgroup_id; 
	
	}//end public String getIdList(Connection cong,String column,String table,String condition)

	public Double getExchangeRate(Connection cong,java.sql.Date D,String company_id)
	{
		double exchange_rate = 0;

		try
		{
			exchnage_rateQuery = "Select exchange_rate from Master_ExchangeRate where exchange_date='"+D+"' and yearend_id in (select yearend_id from YearEnd where company_id="+company_id+")";
			errLine = 188;	
			pstmt_g =cong.prepareStatement(exchnage_rateQuery);
			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				exchange_rate = Double.parseDouble(rs_g.getString("exchange_rate"));
			}
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("202 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return exchange_rate; 
	
	}//end public Double getExchangeRate(Connection cong,java.sql.Date D,String company_id)

	public HashMap getGroupName(Connection cong,String column1,String column2,String table,String condition)
	{
		try
		{
			query = "Select "+column1+", "+column2+" from "+table+""+condition;
			errLine = 214;
			
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();

			errLine = 217;	
			
			while(rs_g.next())
			{
				Group_Name.put(rs_g.getInt(column1), rs_g.getString(column2));
			}
			rs_g.close();
			pstmt_g.close();
			
			
		}//end try
		catch (Exception e)
		{
			System.out.println("230 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return Group_Name; 
	
	}//end public Hashtable getGroupName(Connection cong,String column1,String column2,String table,String condition)
	
	public HashMap getSizeName(Connection cong,String column1,String column2,String table,String condition)	
	{
		try
		{
			query = "Select "+column1+", "+column2+" from "+table+""+condition;
			errLine = 214;
			
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();

			errLine = 217;	
			
			while(rs_g.next())
			{
				Size_Name.put(rs_g.getString(column1), rs_g.getString(column2));
			}
			rs_g.close();
			pstmt_g.close();
			
			
		}//end try
		catch (Exception e)
		{
			System.out.println("230 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return Size_Name; 
	
	}//end public Hashtable getSizeName(Connection cong,String column1,String column2,String table,String condition)

	public HashMap getDescriptionName(Connection cong,String column1,String column2,String table,String condition)	
	{
		try
		{
			query = "Select "+column1+", "+column2+" from "+table+""+condition;
			errLine = 214;
			
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();

			errLine = 217;	
			
			while(rs_g.next())
			{
				Description_Name.put(rs_g.getString(column1), rs_g.getString(column2));
			}
			rs_g.close();
			pstmt_g.close();
						
		}//end try
		catch (Exception e)
		{
			System.out.println("230 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return Description_Name; 
	
	}//end public Hashtable getDescriptionName(Connection cong,String column1,String column2,String table,String condition)
	
	public ArrayList getData(Connection cong,String column,String table,String condition,String order_by,String company_id)
	{
		try
		{
			//loading all the group ids when a lot_no wise display is selected
			
			//int count = getCount(cong,table,condition);

			idMap = getIdMap(cong,company_id);

			String group_id = "";
			String lot_id = "";
			String lot_no = "";
			String uom = "";
			String description_id = "";
			String size_id = "";
			
			String unit_id = "";

			query = "Select "+column+" from "+table+""+condition+"order by L."+order_by;
			
			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			
			while(rs_g.next())
			{
				group_id = rs_g.getString("Group_Id");
				lot_id = rs_g.getString("Lot_id");
				unit_id = rs_g.getString("Unit_id");
				lot_no = rs_g.getString("Lot_No");
				uom = (String)idMap.get(unit_id);
				description_id = rs_g.getString("Description_Id");
				size_id = rs_g.getString("D_Size");
				StockPreviewData spData = new StockPreviewData(lot_id,lot_no,uom,size_id,group_id,description_id,unit_id);

				stockDataList.add(c,spData);
				
				c++;
			}
			rs_g.close();
			pstmt_g.close();

		}//end try
		catch (Exception e)
		{
			System.out.println("285 Error in file StockPreview at Line " + errLine + " and Error is : "+e);
		}//end catch (Exception e)
	
		return stockDataList; 
	
	}//end public String getData(Connection cong,String column,String table,String condition,String order_by,String company_id)

}//end StockPreview