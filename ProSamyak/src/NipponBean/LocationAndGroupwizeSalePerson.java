package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.*;
import NipponBean.*;

public class  LocationAndGroupwizeSalePerson
{
	ResultSet rs_g=null;
	PreparedStatement pstmt=null;
	Vector salesPerson_Id;
	SalesPerson sp;
	
	
	public Vector getSalesPersonForGroupAndLocation(Connection cong,String company_id,String voucher_type,java.sql.Date from_date,java.sql.Date to_date,String location_id,String group_id)
	{
			
		try
		{
			salesPerson_Id=new Vector();
			salesPerson_Id.clear();
			/*String str_query="Select sum(distinct(V.voucher_Id)),sum(R.Receive_Quantity) as R_Qty,R.purchasesaleGroup_Id,R.SalesPerson_Id,sum(R.InvLocalTotal) as L_Tot,sum(R.InvDollarTotal) as D_Tot from  Receive R, voucher V  ,Receive_Transaction RT where V.voucher_Date between '"+from_date+"' and '"+to_date+"' and R.Company_id="+company_id+" and V.Voucher_Type="+voucher_type+" and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)	and V.Active=1 and StockTransfer_type=0 and R.receive_id=RT.Receive_Id and R.PurchaseSaleGroup_Id in("+group_id+") and RT.Location_Id="+location_id+" group by R.purchasesaleGroup_Id,R.SalesPerson_Id";
			System.out.println("str_query="+str_query);*/
			String str_query="Select sum(V.voucher_Id),sum(R.Receive_Quantity) as R_Qty,R.purchasesaleGroup_Id,R.SalesPerson_Id,sum(R.InvLocalTotal) as L_Tot,sum(R.InvDollarTotal) as D_Tot from  Receive R, voucher V where V.voucher_Date between '"+from_date+"' and '"+to_date+"' and R.Company_id="+company_id+" and V.Voucher_Type="+voucher_type+" and R.Active=1 and V.voucher_no=convert(nvarchar(15),R.Receive_Id)and V.Active=1 and StockTransfer_type=0 and R.PurchaseSaleGroup_Id in("
			+group_id+") and  R.Receive_Id in (Select RT.Receive_Id from receive_Transaction as RT where  RT.Location_id="+location_id+" group by RT.Receive_Id) group by purchasesaleGroup_Id,SalesPerson_Id order by R.purchasesaleGroup_Id";
			pstmt=cong.prepareStatement(str_query);
			rs_g=pstmt.executeQuery();
			
			int i=0;
			while(rs_g.next())
			{
				double qty=rs_g.getDouble("R_Qty");
				int sales_per_Id=rs_g.getInt("SalesPerson_Id");
				double loca_tot=rs_g.getDouble("L_Tot");
				double dol_toa=rs_g.getDouble("D_Tot");
				sp=new SalesPerson();
				sp.setQuantity(qty);
				sp.setId(sales_per_Id);
				sp.setLocalTotal(loca_tot);
				sp.setDollarTotal(dol_toa);
				salesPerson_Id.add(i,sp);
				i++;
			}
			pstmt.close();
	
	  }//try
	  catch(Exception e)
	  {
		System.out.println("e="+e);
	  }
	  finally
	  {
		return salesPerson_Id;
	  }
	}
} //LocationAndGroupwizeSalePerson

