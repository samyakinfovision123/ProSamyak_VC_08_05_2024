package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  Warehouse
{
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_p=null;
	PreparedStatement pstmt_p=null;
	NipponBean.Array A;
	NipponBean.format format;
	NipponBean.str str;
	
	public	Warehouse()
		{
			A=new NipponBean.Array();
			format = new NipponBean.format();
			str = new NipponBean.str();
		}



//get Warehouse transfer's details
public String getWarehouseDetails(Connection conp, Connection cong, String sReceive_Id, String current_location_id, String StockTransfer_Type, String company_id, int d) 
{
try{
	
	double sale_addition=0;
	double sale_addition1=0;
	double sale_return1=0;
	double consignment_sale1=0;
	double consignment_sale_return1=0;
	double consignment_sale_confirm1=0;
	double reverse_lot_transfer1=0;
	double lot_pending_location1=0;


	double reverseLotTransferAmt = 0;
	double cgtSaleAmt = 0;
	double cgtSaleReturnAmt = 0;
	double cgtSaleConfirmAmt = 0;
	double saleAmt = 0;
	double saleReturnAmt = 0;
	double pendingAmt = 0;


	String query="";
	String Receive_No="";
	String Receive_Date="";
	String Stock_Date="";
	double Exchange_Rate=0;
	double Local_Total=0;
	double dLocal_Total=0;
	double Dollar_Total=0;
	int scounter=0;
	int dcounter=0;
	
	query="select * from Receive where Receive_Id="+sReceive_Id;
	

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	while(rs_p.next())
		{
			Receive_No=rs_p.getString("Receive_No");
			Receive_Date=format.format(rs_p.getDate("Receive_Date"));
			scounter=rs_p.getInt("Receive_Lots");
			Exchange_Rate=rs_p.getDouble("Exchange_Rate");
			Local_Total=rs_p.getDouble("Local_Total");
			Dollar_Total=rs_p.getDouble("Dollar_Total");
			Stock_Date=format.format(rs_p.getDate("Stock_Date"));
			
//			StockTransfer_Type=rs_p.getString("StockTransfer_Type");
		}
	pstmt_p.close();
	
	
	String slotid[]=new String[scounter];
	String sdrawing[]=new String[scounter];
	String slocation_id[]=new String[scounter];
	double sqty[]=new double[scounter];
	double srate[]=new double[scounter];
	double samount[]=new double[scounter];
	double stotalqty=0;
	
	double reverseLotTransferRate[] = new double[scounter];
	double cgtSaleRate[] = new double[scounter];
	double cgtSaleReturnRate[] = new double[scounter];
	double cgtSaleConfirmRate[] = new double[scounter];
	double saleRate[] = new double[scounter];
	double saleReturnRate[] = new double[scounter];
	
	
if(!("6".equals(StockTransfer_Type)))
		{
//	out.print("<br> 163 Except Gain");
	query="select Lot_Id, Quantity, Local_Price,Location_Id from Receive_Transaction where Receive_Id="+sReceive_Id+" order by ReceiveTransaction_Id, Lot_SrNo";

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int s=0;
	while(rs_p.next())
		{
			slotid[s]=rs_p.getString("Lot_Id");
			sdrawing[s]=A.getNameCondition(conp,"Lot","Drwg_FileName","where Lot_Id="+slotid[s]);
			sqty[s]=rs_p.getDouble("Quantity");
//			out.print("<br> sqty["+s+"]"+sqty[s]);
			stotalqty=stotalqty+sqty[s];
			srate[s]=rs_p.getDouble("Local_Price");
			samount[s]=Double.parseDouble(str.mathformat(""+(sqty[s]*srate[s]),d) );
			slocation_id[s]=rs_p.getString("Location_Id");
			s++;
		}
	pstmt_p.close();

		}


for(int i=0;i<scounter;i++)
{				  
	double TotalSale=0; 
	double TotalSaleReturn=0; 
	//double sale_addition=0;
	//double sale_addition1=0;
	//get all the sales from the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and Purchase=1 and R.R_Return=0 and RT.consignment_ReceiveId=0 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i];
	
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int SaleNum=0; //Total Sales
	while(rs_p.next())	  
	{
		SaleNum++;		  
	}
	//out.print("<br>310 SaleNum :"+SaleNum);
	pstmt_p.close();

	int sale_consignment_RtId[] = new int[SaleNum];

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	
	int z=0;
	while(rs_p.next())	  
	{
		sale_consignment_RtId[z]=rs_p.getInt("ReceiveTransaction_Id");
		//out.print("<br>324 sale_consignment_RtId["+z+"]"+sale_consignment_RtId[z]);
		TotalSale+=rs_p.getDouble("Quantity");					saleRate[i] = rs_p.getDouble("Local_Price");

		z++;
	} 
	pstmt_p.close();

	//out.print("<br>352 Total Sale : "+TotalSale);
		
	//getting the sales return total against the above sales at the current location

	for(int k=0; k<SaleNum; k++)
	{
					
		//sale return
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=1 and R.Purchase=1 and R.R_Return=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+sale_consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalSaleReturn+=rs_p.getDouble("Quantity");
			saleReturnRate[i]=rs_p.getDouble("Local_Price");
		}
		
		
	}
	//out.print("<br>372 TotalSaleReturn:"+TotalSaleReturn);
	pstmt_p.close();



	//get all the consignment sales from the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and Purchase=0 and R.R_Return=0 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i];
	
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int cgtSaleNum=0; //Total Consignment Sales
	while(rs_p.next())	  
	{
		cgtSaleNum++;		  
	}
	//out.print("<br>310 cgtSaleNum :"+cgtSaleNum);
	pstmt_p.close();

	int consignment_RtId[] = new int[cgtSaleNum];

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	

	z=0;
	double TotalCgtSale=0;
	while(rs_p.next())	  
	{
		consignment_RtId[z]=rs_p.getInt("ReceiveTransaction_Id");
		//out.print("<br>324 consignment_RtId["+z+"]"+consignment_RtId[z]);
		TotalCgtSale+=rs_p.getDouble("Quantity");				cgtSaleRate[i] = rs_p.getDouble("Local_Price");			  

		z++;
	} 
	pstmt_p.close();
	//getting the consignment sales return total and consignment sales confirm total against the above consignemnt sales at the current location

	double TotalCgtSaleReturn=0;
	double TotalCgtSaleConfirm=0;
	for(int k=0; k<cgtSaleNum; k++)
	{
					
		//consignment sale return
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=1 and R.Purchase=0 and R.R_Return=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalCgtSaleReturn+=rs_p.getDouble("Quantity");
			cgtSaleReturnRate[i] = rs_p.getDouble("Local_Price");
		}
						
		//consignment sale confirm
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and R.Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalCgtSaleConfirm+=rs_p.getDouble("Quantity");
			cgtSaleConfirmRate[i] = rs_p.getDouble("Local_Price");
		}
	}
	//out.print("<br>357 TotalCgtSaleReturn:"+TotalCgtSaleReturn);
	//out.print("<br>358 TotalCgtSaleConfirm:"+TotalCgtSaleConfirm);
	pstmt_p.close();


	//Start : get the total quantity for the lot transfers for current lot_id to the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+"and R.Receive_Date<=? and R.Receive_Id<="+(sReceive_Id+1)+" order by R.Receive_date ,R.Receive_no";
	
	pstmt_p=conp.prepareStatement(query);
	pstmt_p.setDate(1, format.getDate(Receive_Date));
	rs_p=pstmt_p.executeQuery();
	
	double remainingSale=TotalSale;
	double remainingSaleReturn=TotalSaleReturn;

	double remainingCgtSale=TotalCgtSale;
	double remainingCgtSaleConfirm=TotalCgtSaleConfirm;
	double remainingCgtSaleReturn=TotalCgtSaleReturn;

	double TotalQty=0;  
	double currQty=0;  
	double orgCurrQty=0;  
	while(rs_p.next())	  
	{
			  
	int r_id = rs_p.getInt("Receive_Id");

	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+(r_id-1)+" order by R.Receive_date ,R.Receive_no";
					
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		double revLotTrans=0;
		while(rs_g.next())	  
			{
				revLotTrans+=rs_g.getDouble("Quantity");
			}
		pstmt_g.close();

		currQty=rs_p.getDouble("Quantity");
		
		
		TotalQty=currQty;  //quantity before reverse Lot Transfer
		currQty=currQty-revLotTrans;
		orgCurrQty = currQty;//store the original current quantity

		//balancing the sale quantities and consignment quantities with the lot quantity
		if(remainingSaleReturn >= TotalQty)
		{
			TotalSaleReturn = TotalQty;
			remainingSaleReturn-=TotalQty;
		}
		else
		{
			TotalSaleReturn = remainingSaleReturn;
			remainingSaleReturn=0;
		}

		if(remainingSale >= TotalQty)
		{
			TotalSale = TotalQty;
			remainingSale-=TotalQty;
			TotalCgtSale=0;
			TotalCgtSaleReturn=0;
			TotalCgtSaleConfirm=0;
		}
		else
		{
		TotalSale = remainingSale;
		remainingSale=0;
		currQty = currQty - TotalSale;
		
		if(remainingCgtSaleConfirm>=currQty)
			{
			TotalCgtSaleConfirm=currQty;
			remainingCgtSaleConfirm=remainingCgtSaleConfirm-currQty;
			
			TotalCgtSale = currQty;
			
			remainingCgtSale=remainingCgtSale-currQty; 
			
			TotalCgtSaleReturn=0;

			} 
		else
			{
			TotalCgtSaleConfirm=remainingCgtSaleConfirm;
			
			if((remainingCgtSaleReturn + remainingCgtSaleConfirm)>=currQty)
			{
				TotalCgtSaleReturn = currQty - TotalCgtSaleConfirm; 
				remainingCgtSaleReturn=remainingCgtSaleReturn-TotalCgtSaleReturn;	
				
				TotalCgtSale = currQty;
				remainingCgtSale=remainingCgtSale-currQty;
				
			}
			else
			{
				TotalCgtSale = remainingCgtSale;

				if(remainingCgtSale>=currQty)
				{
					TotalCgtSale=currQty;
					remainingCgtSale=remainingCgtSale-currQty;
				}
				else
				{
					TotalCgtSale=remainingCgtSale;
					remainingCgtSale=0;
				}
				TotalCgtSaleReturn = remainingCgtSaleReturn;
				remainingCgtSaleReturn=0;

			}
			remainingCgtSaleConfirm=0;

			}
		}
		}
		pstmt_p.close();
		
		//Start : get the total quantity for the reverse lot transfers for current lot transfer
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+sReceive_Id+" order by R.Receive_date ,R.Receive_no";
		
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		double reverseLotTransferred=0;
		while(rs_p.next())	  
			{
				reverseLotTransferred+=rs_p.getDouble("Quantity");
				reverseLotTransferRate[i] = rs_p.getDouble("Local_Price");
			}
		pstmt_p.close();
		//out.print("<br>453 reverseLotTransferred :"+reverseLotTransferred);
					
		double pending = 0;
		pending = (orgCurrQty - TotalCgtSale -TotalSale) + TotalCgtSaleReturn + TotalSaleReturn;
		
		sale_addition+=TotalSale;
		sale_return1+=TotalSaleReturn;
		consignment_sale1+=TotalCgtSale;
		consignment_sale_return1+=TotalCgtSaleReturn;
		consignment_sale_confirm1+=TotalCgtSaleConfirm;
		reverse_lot_transfer1+=reverseLotTransferred;
		lot_pending_location1+=pending;

		reverseLotTransferAmt += reverseLotTransferred * reverseLotTransferRate[i];
		cgtSaleAmt += TotalCgtSale * cgtSaleRate[i];
		cgtSaleReturnAmt += TotalCgtSaleReturn * cgtSaleReturnRate[i];
		cgtSaleConfirmAmt += TotalCgtSaleConfirm * cgtSaleConfirmRate[i];
		saleAmt += TotalSale * saleRate[i];
		saleReturnAmt += TotalSaleReturn * saleReturnRate[i];
		pendingAmt += pending * srate[i];

		}//end of for loop to print each row of the lots
	return reverse_lot_transfer1+"#"+reverseLotTransferAmt+"#"+consignment_sale1+"#"+cgtSaleAmt+"#"+consignment_sale_return1+"#"+cgtSaleReturnAmt+"#"+consignment_sale_confirm1+"#"+cgtSaleConfirmAmt+"#"+sale_addition+"#"+saleAmt+"#"+sale_return1+"#"+saleReturnAmt+"#"+lot_pending_location1+"#"+pendingAmt;
 
}catch(Exception e)	{
	System.out.print("<BR>EXCEPTION in getWarehouseDetails() =" +e);
	return ""+e;

}

}//getWarehouseDetails



//get Warehouse transfer's details
public String getWarehousePending(Connection conp, Connection cong, String sReceive_Id, String current_location_id, String StockTransfer_Type, String company_id, int d) 
{
try{
	
	double sale_addition=0;
	double sale_addition1=0;
	double sale_return1=0;
	double consignment_sale1=0;
	double consignment_sale_return1=0;
	double consignment_sale_confirm1=0;
	double reverse_lot_transfer1=0;
	double lot_pending_location1=0;


	double pendingAmt = 0;


	String query="";
	String Receive_No="";
	String Receive_Date="";
	String Stock_Date="";
	double Exchange_Rate=0;
	double Local_Total=0;
	double dLocal_Total=0;
	double Dollar_Total=0;
	int scounter=0;
	int dcounter=0;
	
	query="select * from Receive where Receive_Id="+sReceive_Id;
	

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	while(rs_p.next())
		{
			Receive_No=rs_p.getString("Receive_No");
			Receive_Date=format.format(rs_p.getDate("Receive_Date"));
			scounter=rs_p.getInt("Receive_Lots");
			Exchange_Rate=rs_p.getDouble("Exchange_Rate");
			Local_Total=rs_p.getDouble("Local_Total");
			Dollar_Total=rs_p.getDouble("Dollar_Total");
			Stock_Date=format.format(rs_p.getDate("Stock_Date"));
			
//			StockTransfer_Type=rs_p.getString("StockTransfer_Type");
		}
	pstmt_p.close();
	
	
	String slotid[]=new String[scounter];
	String sdrawing[]=new String[scounter];
	String slocation_id[]=new String[scounter];
	double sqty[]=new double[scounter];
	double srate[]=new double[scounter];
	double samount[]=new double[scounter];
	double stotalqty=0;
	
		
	
if(!("6".equals(StockTransfer_Type)))
		{
//	out.print("<br> 163 Except Gain");
	query="select Lot_Id, Quantity, Local_Price,Location_Id from Receive_Transaction where Receive_Id="+sReceive_Id+" order by ReceiveTransaction_Id, Lot_SrNo";

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int s=0;
	while(rs_p.next())
		{
			slotid[s]=rs_p.getString("Lot_Id");
			sdrawing[s]=A.getNameCondition(conp,"Lot","Drwg_FileName","where Lot_Id="+slotid[s]);
			sqty[s]=rs_p.getDouble("Quantity");
//			out.print("<br> sqty["+s+"]"+sqty[s]);
			stotalqty=stotalqty+sqty[s];
			srate[s]=rs_p.getDouble("Local_Price");
			samount[s]=Double.parseDouble(str.mathformat(""+(sqty[s]*srate[s]),d) );
			slocation_id[s]=rs_p.getString("Location_Id");
			s++;
		}
	pstmt_p.close();

		}


for(int i=0;i<scounter;i++)
{				  
	double TotalSale=0; 
	double TotalSaleReturn=0; 
	//double sale_addition=0;
	//double sale_addition1=0;
	//get all the sales from the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and Purchase=1 and R.R_Return=0 and RT.consignment_ReceiveId=0 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i];
	
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int SaleNum=0; //Total Sales
	while(rs_p.next())	  
	{
		SaleNum++;		  
	}
	//out.print("<br>310 SaleNum :"+SaleNum);
	pstmt_p.close();

	int sale_consignment_RtId[] = new int[SaleNum];

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	
	int z=0;
	while(rs_p.next())	  
	{
		sale_consignment_RtId[z]=rs_p.getInt("ReceiveTransaction_Id");
		//out.print("<br>324 sale_consignment_RtId["+z+"]"+sale_consignment_RtId[z]);
		TotalSale+=rs_p.getDouble("Quantity");					
		z++;
	} 
	pstmt_p.close();

	//out.print("<br>352 Total Sale : "+TotalSale);
		
	//getting the sales return total against the above sales at the current location

	for(int k=0; k<SaleNum; k++)
	{
					
		//sale return
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=1 and R.Purchase=1 and R.R_Return=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+sale_consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalSaleReturn+=rs_p.getDouble("Quantity");
		}
		
		
	}
	//out.print("<br>372 TotalSaleReturn:"+TotalSaleReturn);
	pstmt_p.close();



	//get all the consignment sales from the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and Purchase=0 and R.R_Return=0 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i];
	
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int cgtSaleNum=0; //Total Consignment Sales
	while(rs_p.next())	  
	{
		cgtSaleNum++;		  
	}
	//out.print("<br>310 cgtSaleNum :"+cgtSaleNum);
	pstmt_p.close();

	int consignment_RtId[] = new int[cgtSaleNum];

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	

	z=0;
	double TotalCgtSale=0;
	while(rs_p.next())	  
	{
		consignment_RtId[z]=rs_p.getInt("ReceiveTransaction_Id");
		//out.print("<br>324 consignment_RtId["+z+"]"+consignment_RtId[z]);
		TotalCgtSale+=rs_p.getDouble("Quantity");				

		z++;
	} 
	pstmt_p.close();
	//getting the consignment sales return total and consignment sales confirm total against the above consignemnt sales at the current location

	double TotalCgtSaleReturn=0;
	double TotalCgtSaleConfirm=0;
	for(int k=0; k<cgtSaleNum; k++)
	{
					
		//consignment sale return
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=1 and R.Purchase=0 and R.R_Return=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalCgtSaleReturn+=rs_p.getDouble("Quantity");
		}
						
		//consignment sale confirm
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type<>2 and R.Receive_Sell=0 and R.Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+consignment_RtId[k];
	
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())	  
		{
			TotalCgtSaleConfirm+=rs_p.getDouble("Quantity");
		}
	}
	//out.print("<br>357 TotalCgtSaleReturn:"+TotalCgtSaleReturn);
	//out.print("<br>358 TotalCgtSaleConfirm:"+TotalCgtSaleConfirm);
	pstmt_p.close();


	//Start : get the total quantity for the lot transfers for current lot_id to the current location
	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and RT.Location_Id="+current_location_id+" and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+"and R.Receive_Date<=? and R.Receive_Id<="+(sReceive_Id+1)+" order by R.Receive_date ,R.Receive_no";
	
	pstmt_p=conp.prepareStatement(query);
	pstmt_p.setDate(1, format.getDate(Receive_Date));
	rs_p=pstmt_p.executeQuery();
	
	double remainingSale=TotalSale;
	double remainingSaleReturn=TotalSaleReturn;

	double remainingCgtSale=TotalCgtSale;
	double remainingCgtSaleConfirm=TotalCgtSaleConfirm;
	double remainingCgtSaleReturn=TotalCgtSaleReturn;

	double TotalQty=0;  
	double currQty=0;  
	double orgCurrQty=0;  
	while(rs_p.next())	  
	{
			  
	int r_id = rs_p.getInt("Receive_Id");

	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+(r_id-1)+" order by R.Receive_date ,R.Receive_no";
					
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		double revLotTrans=0;
		while(rs_g.next())	  
			{
				revLotTrans+=rs_g.getDouble("Quantity");
			}
		pstmt_g.close();

		currQty=rs_p.getDouble("Quantity");
		
		
		TotalQty=currQty;  //quantity before reverse Lot Transfer
		currQty=currQty-revLotTrans;
		orgCurrQty = currQty;//store the original current quantity

		//balancing the sale quantities and consignment quantities with the lot quantity
		if(remainingSaleReturn >= TotalQty)
		{
			TotalSaleReturn = TotalQty;
			remainingSaleReturn-=TotalQty;
		}
		else
		{
			TotalSaleReturn = remainingSaleReturn;
			remainingSaleReturn=0;
		}

		if(remainingSale >= TotalQty)
		{
			TotalSale = TotalQty;
			remainingSale-=TotalQty;
			TotalCgtSale=0;
			TotalCgtSaleReturn=0;
			TotalCgtSaleConfirm=0;
		}
		else
		{
		TotalSale = remainingSale;
		remainingSale=0;
		currQty = currQty - TotalSale;
		
		if(remainingCgtSaleConfirm>=currQty)
			{
			TotalCgtSaleConfirm=currQty;
			remainingCgtSaleConfirm=remainingCgtSaleConfirm-currQty;
			
			TotalCgtSale = currQty;
			
			remainingCgtSale=remainingCgtSale-currQty; 
			
			TotalCgtSaleReturn=0;

			} 
		else
			{
			TotalCgtSaleConfirm=remainingCgtSaleConfirm;
			
			if((remainingCgtSaleReturn + remainingCgtSaleConfirm)>=currQty)
			{
				TotalCgtSaleReturn = currQty - TotalCgtSaleConfirm; 
				remainingCgtSaleReturn=remainingCgtSaleReturn-TotalCgtSaleReturn;	
				
				TotalCgtSale = currQty;
				remainingCgtSale=remainingCgtSale-currQty;
				
			}
			else
			{
				TotalCgtSale = remainingCgtSale;

				if(remainingCgtSale>=currQty)
				{
					TotalCgtSale=currQty;
					remainingCgtSale=remainingCgtSale-currQty;
				}
				else
				{
					TotalCgtSale=remainingCgtSale;
					remainingCgtSale=0;
				}
				TotalCgtSaleReturn = remainingCgtSaleReturn;
				remainingCgtSaleReturn=0;

			}
			remainingCgtSaleConfirm=0;

			}
		}
		}
		pstmt_p.close();
		
		//Start : get the total quantity for the reverse lot transfers for current lot transfer
		query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 and R.StockTransfer_Type=2 and R.Receive_Sell=1 and Purchase=1 and R.company_id="+company_id+" and RT.lot_id="+slotid[i]+" and RT.Consignment_ReceiveId="+sReceive_Id+" order by R.Receive_date ,R.Receive_no";
		
		pstmt_p=conp.prepareStatement(query);
		rs_p=pstmt_p.executeQuery();
		double reverseLotTransferred=0;
		while(rs_p.next())	  
			{
				reverseLotTransferred+=rs_p.getDouble("Quantity");
			}
		pstmt_p.close();
		//out.print("<br>453 reverseLotTransferred :"+reverseLotTransferred);
					
		double pending = 0;
		pending = (orgCurrQty - TotalCgtSale -TotalSale) + TotalCgtSaleReturn + TotalSaleReturn;
		
		sale_addition+=TotalSale;
		sale_return1+=TotalSaleReturn;
		consignment_sale1+=TotalCgtSale;
		consignment_sale_return1+=TotalCgtSaleReturn;
		consignment_sale_confirm1+=TotalCgtSaleConfirm;
		reverse_lot_transfer1+=reverseLotTransferred;
		lot_pending_location1+=pending;

		pendingAmt += pending * srate[i];

		}//end of for loop to print each row of the lots
	return lot_pending_location1+"#"+pendingAmt;
 
}catch(Exception e)	{
	System.out.print("<BR>EXCEPTION in getWarehousePending() =" +e);
	return ""+e;

}

}//getWarehousePending





	public static void main(String[] args) throws Exception
	{

		Warehouse wh = new Warehouse();
	
	}
}


