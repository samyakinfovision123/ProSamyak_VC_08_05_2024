package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class LotHistoryBean
{
	
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_p=null;
	
	double purchase_qty=0;
	double purchase_local_amount=0;
	double purchase_dollar_amount=0;

	double mixIn_qty=0;
	double mixIn_local_amount=0;
	double mixIn_dollar_amount=0;

	double sale_qty=0;
	double sale_local_amount=0;
	double sale_dollar_amount=0;

	double mixOut_qty=0;
	double mixOut_local_amount=0;
	double mixOut_dollar_amount=0;

	
	double consignment_sale_qty;
	double consignment_sale_local_amount;
	double consignment_sale_dollar_amount;

	double consignment_purchase_qty;
	double consignment_purchase_local_amount;
	double consignment_purchase_dollar_amount;
	
	double qty=0;
	double local_amount=0;
	double dollar_amount=0;
	String receive_sell;
	String purchase;
	String receive_from_id;
	HashMap lot_map=new HashMap();
	public LotHistoryBean()
	{
	}

	public HashMap getSalePurchaseMixInOut(Connection cong,String lot_id,java.sql.Date D1,java.sql.Date D2,String company_id,String yearend_id)
	{
		
		try
		{
		String query="SELECT R.Receive_id, RT.Consignment_Receiveid, Receive_no, Receive_FromId,Lot_SrNo, receive_sell, purchase, opening_stock, R_Return, StockTransfer_Type,Stock_Date, Receive_Date,Due_Date, Local_Price, Dollar_Price, Quantity,RT.Remarks FROM Receive_Transaction AS RT, Receive AS R WHERE ((RT.Lot_Id)="+lot_id+") And ((R.Receive_Id)=RT.receive_id) And (((R.Stock_Date) Between '"+D1+"' And '"+D2+"') And ((R.Active)=1) And ((RT.Active)=1) And ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) And ((R.YearEnd_Id)="+yearend_id+")) AND ( R.Opening_Stock=0 or ( R.Opening_Stock = 1 AND R.R_Return = 0) ) ORDER BY R.Stock_Date, R.Receive_Sell, R.Receive_Id";
		
		pstmt_g = cong.prepareStatement(query);
		System.out.println("query="+query);
		
		rs_g  = pstmt_g.executeQuery();
	
		while(rs_g.next())
		{
			receive_from_id=rs_g.getString("Receive_FromId");
			receive_sell=rs_g.getString("receive_sell");
			purchase=rs_g.getString("purchase");
			local_amount=rs_g.getDouble("Local_Price");
			dollar_amount=rs_g.getDouble("Dollar_Price");
			qty=rs_g.getDouble("Quantity");
		
			if(("0".equals(receive_sell))&&("1".equals(purchase)))
			{
				if(receive_from_id.equals(company_id))
				{
					mixOut_qty+=qty;
					mixOut_local_amount+=local_amount*(qty);
					mixOut_dollar_amount+=dollar_amount*(qty);

				}
				else
				{
					sale_qty+=qty;
					sale_local_amount+=local_amount*(qty);
					sale_dollar_amount+=dollar_amount*(qty);
				
				}
			}
			if(("1".equals(receive_sell))&&("1".equals(purchase)))
			{
				if(receive_from_id.equals(company_id))
				{
					mixIn_qty+=qty;
					mixIn_local_amount+=local_amount*(qty);
					mixIn_dollar_amount+=dollar_amount*(qty);
				}
				else
				{
					purchase_qty+=qty;
					purchase_local_amount+=local_amount*(qty);
					purchase_dollar_amount+=dollar_amount*(qty);
				}
			}

			if(("0".equals(receive_sell))&&("0".equals(purchase)))
			{
				consignment_sale_qty+=qty;
				consignment_sale_local_amount+=local_amount*(qty);
				consignment_sale_dollar_amount+=dollar_amount*(qty);
			}

			if(("1".equals(receive_sell))&&("0".equals(purchase)))
			{
				consignment_purchase_qty+=qty;
				consignment_purchase_local_amount+=local_amount*(qty);
				consignment_purchase_dollar_amount+=dollar_amount*(qty);
			}


		}
		pstmt_g.close();
		
		LotHistoryRow lothistoryrow=new LotHistoryRow("Purchase",purchase_qty,purchase_local_amount,purchase_dollar_amount);

		lot_map.put("Purchase",lothistoryrow);
		
		lothistoryrow=new LotHistoryRow("Sale",sale_qty,sale_local_amount,sale_dollar_amount);
		
		lot_map.put("Sale",lothistoryrow);
		
		lothistoryrow=new LotHistoryRow("Mix In",mixIn_qty,mixIn_local_amount,mixIn_dollar_amount);
		
		lot_map.put("Mix In",lothistoryrow);
		
		lothistoryrow=new LotHistoryRow("Mix Out",mixOut_qty,mixOut_local_amount,mixOut_dollar_amount);
		
		lot_map.put("Mix Out",lothistoryrow);	
	
		
		lothistoryrow=new LotHistoryRow("Consignment Sale",consignment_sale_qty,consignment_sale_local_amount,consignment_sale_dollar_amount);
		lot_map.put("Consignment Sale",lothistoryrow);	

		lothistoryrow=new LotHistoryRow("Consignment Purchase",consignment_purchase_qty,consignment_purchase_local_amount,consignment_purchase_dollar_amount);
		lot_map.put("Consignment Purchase",lothistoryrow);
		
		
		
		}//try
		catch(Exception e)
		{
			System.out.println("e="+e);
		}
		finally
		{
			return lot_map;
		}
	} //getSalePurchaseMixInOut
}

