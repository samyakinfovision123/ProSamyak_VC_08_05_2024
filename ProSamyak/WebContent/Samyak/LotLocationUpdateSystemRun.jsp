 <!--  
Use of System Run:- Set Available carats and Carats as Physical Quantity and Financial Quantity

How to Run System Run:-
Type in url:-/Samyak/LotLocationUpdateSystemRun.jsp?command=Samyak


-->




<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<jsp:useBean   id="YED" class="NipponBean.YearEndDate" />
<% 
Connection cong = null;
Connection conp = null;

String errLine = "14";

ResultSet rs_g= null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

String user_id= ""+session.getValue("user_id");
//out.print()
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//String company_name= A.getName(cong,"companyparty",company_id);
String lotdescriptionf = "";
String grossprofitf="";
String combinef = "";
String conditionf = "";
String differencef="";
String rangeStartf="";
String rangeEndf="";
String selectedgroup_id[] = new String[0];
String groupIdList = "-999";
errLine = "37";	
	

	cong=C.getConnection();
    conp=C.getConnection();

		

	
	


	
	
	
	
		String lotLocationCondition="";
		String condition="";
		String report_name="Category ";

	   String company_query="";


		String lotRangeStart="";
		String lotRangeEnd="";
		String command=request.getParameter("command");
errLine = "81";	
if(command.equals("Samyak"))
	{
try

{
	////



 int counter_company=0;
 int a417=1;

 java.sql.Date D1 = new java.sql.Date(System.currentTimeMillis());

 int year=D1.getYear();
 int dd=D1.getDate();
 int d1=dd + 1;
int mm=D1.getMonth();
 java.sql.Date Dnext = new java.sql.Date((year),(mm),d1);

year =year-1;
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
int presentcounter=0;
 company_query="select count(*) as LocationCount  from Master_Location where Active=1" ;  
 
 errLine = "109";	
 
//out.print("<br>111 company_query="+company_query);

pstmt_g = cong.prepareStatement(company_query);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
counter_company=rs_g.getInt("LocationCount");
}
//out.print("<br>103  D1="+D1);

pstmt_g.close();

	
	String party_id[]=new String[counter_company];
	String location_id[]=new String[counter_company];
	
	company_query="select Location_Id ,Company_Id from Master_Location where Active=1" ;
	pstmt_g = cong.prepareStatement(company_query);
    rs_g=pstmt_g.executeQuery();
    int hi=0;
   while(rs_g.next()) 	
   {
     location_id[hi]=rs_g.getString("Location_Id");
	
	 party_id[hi]=rs_g.getString("Company_Id");
  
	 hi++;
   }
  
   errLine = "117";	
   String location_count_query="";

	pstmt_g.close();

int k1=0;


for( k1=0;k1<counter_company;k1++)//loop for locationid and w.r.t. company id
		{
              //int ck=1;

			String reportyearend_id = YED.returnYearEndId(cong , pstmt_g, 	rs_g, Dprevious,  party_id[k1]);
		    
	        out.print("<br>");
		    out.print(" ("+k1+"). <font color=red>Party Id["+k1+"]=</font>"+party_id[k1]);

			out.print("  <font color=red>Location Id["+k1+"]=</font>"+location_id[k1]);
			out.print("  <font color=red>YearEnd Id["+k1+"]=</font>"+reportyearend_id);

			out.print("<br>");
			
			
			
		
		
		











	String query="";

	
	

	
	errLine = "156";	
	String lotcondition="where active=1";


	query="Select L.Lot_id, L.Lot_No from Lot L, Diamond D where L.Lot_Id=D.Lot_Id and active=1 and created_on <='"+D1+"' and Company_id="+party_id[k1]+" order by L.Lot_Id";
	//out.print(query);
	
	pstmt_g =cong.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();

	int count=0;
	
	rs_g.last();
	count=rs_g.getRow();
	rs_g.beforeFirst();
	
	int counter =count;
	//out.print("counter"+counter);

	errLine = "175";	

	long lot_id[]= new long[count];
	String lot_no[]= new String[count];
	String uom[]= new String[count];
	int description_id[]= new int[count];
	int size_id[]= new int[count];
	int group_id[]= new int[count];

	double carats[]=new double[count];
	double local_price[]=new double[count];
	double dollar_price[]=new double[count];
	double pcarats[]=new double[count];
	double plocal_price[]=new double[count];
	double pdollar_price[]=new double[count];
	double ccarats[]=new double[count];
	double clocal_price[]=new double[count];
	double cdollar_price[]=new double[count];
	double per_carats[]=new double[count];
	double sale_carats[]=new double[count];
	double per_ccarats[]=new double[count];
	double sale_ccarats[]=new double[count];
	double ConfirmPurQty[]=new double[count];
	double ConfirmSaleQty[]=new double[count];
	
	double gross[]=new double[count];
	double gross_purchase[]=new double[count];
	double gross_sale[]=new double[count];
	double gross_pur_qty[]=new double[count];
	double gross_sale_qty[]=new double[count];
	
	//Array -- For Quantity
	double consignment_in_qty[]=new double[count];
	double consignment_out_qty[]=new double[count];
	double consignment_sale_return_qty[]=new double[count];
	double consignment_sale_confirm_qty[]=new double[count];
	double consignment_purchase_return_qty[]=new double[count];
	double consignment_purchase_confirm_qty[]=new double[count];
	double consignment_inward_qty[]=new double[count];
	double consignment_outward_qty[]=new double[count];

	double financial_in_qty[]=new double[count];
	double financial_out_qty[]=new double[count];
	double financial_sale_qty[]=new double[count];
	double financial_sale_return_qty[]=new double[count];
	double financial_purchase_qty[]=new double[count];
	double financial_purchase_return_qty[]=new double[count];
	double opening_stock_qty[]=new double[count];
	double stock_transfer_qty[]=new double[count];


	
	double gross_purchase_var =0.0;
	double gross_sale_var =0.0;
	double gross_purchase_qty_var=0.0;
	double gross_sale_qty_var =0.0;

	//Variables -- For Quantity
	double consignment_in_qty_var=0;
	double consignment_out_qty_var=0;
	double consignment_sale_return_qty_var=0;
	double consignment_sale_confirm_qty_var=0;
	double consignment_purchase_return_qty_var=0;
	double consignment_purchase_confirm_qty_var=0;
	double financial_in_qty_var=0;
	double financial_out_qty_var=0;
	double financial_sale_qty_var=0;
	double financial_sale_return_qty_var=0;
	double financial_sale_confirm_qty_var=0;
	double financial_purchase_qty_var=0;
	double financial_purchase_return_qty_var=0;
	double opening_stock_qty_var=0;
	double stock_transfer_qty_var=0;

	
	int c=0;

	while(rs_g.next())
	{
		lot_id[c]=rs_g.getLong("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		
		
		c++;
	}

	pstmt_g.close();
	
	//now divide the lots into some fixed proportion and then fire the query

	int lotIndex = 0; //points to first lot in the list
	int brkPoint = counter / 50;
	int ik=0;
	int divstart = 0;
	int divend = 0;

	double localp=0;
	double localp_temp=0;
	double tqty=0;
	double totalQty=0;
	double tqty_temp=0;
	double dollarp=0;
	double dollarp_temp=0;

	errLine = "279";	
	while(divstart < counter)
	{
		divend += brkPoint;
		if(brkPoint==0)
			divend=counter-1;
	 
		String condn="";
	
		

		String lotIdSet = "-1";
		for(int z=divstart; z<=divend; z++)
		{
			lotIdSet += ", " + lot_id[z];
		}


		condn = "and L.lot_Id IN ( "+lotIdSet+") ";

		//out.print("<br>320 condn="+condn);
		query="Select RT.ReceiveTransaction_Id,RT.Receive_Id,  RT.Consignment_ReceiveId, R.purchase, R.receive_sell, R.R_Return, R.StockTransfer_Type,R.Opening_Stock, RT.Lot_id, RT.Available_Quantity, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and RT.Location_Id="+location_id[k1]+" and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id  and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? "+condn+" order by L.Lot_Id,  R.Stock_Date, R.Receive_Sell, R.Receive_Id, RT.ReceiveTransaction_id ";

		//out.print("query" + query);

		pstmt_g = cong.prepareStatement(query , ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,party_id[k1]); 
		pstmt_g.setString(3,reportyearend_id); 
		//out.print("<br> "+reportyearend_id);

		rs_g = pstmt_g.executeQuery();

		count=0;
		rs_g.last();
		count=rs_g.getRow();
		rs_g.beforeFirst();
		
		
		long lotid[]= new long[count];
		boolean purchase[]= new boolean[count];
		boolean receive_sell[]= new boolean[count];
		boolean returned[]= new boolean[count];
		boolean opening_stock[]= new boolean[count];
		double localprice[]=new double[count];
		double dollarprice[]=new double[count];
		double qty[]=new double[count];
		double available_qty[]=new double[count];
		long Consignment_ReceiveId[]=new long[count];
		long RT_Id[]=new long[count];
		long R_Id[]=new long[count];
		double rec_total[]=new double[count];
		int stocktransfer_type[] = new int[count];

		errLine = "333";	
		c=0;
		//out.print("<br>354 query" + query);
		while(rs_g.next())
		{
			RT_Id[c]=rs_g.getLong("ReceiveTransaction_Id");
			R_Id[c]=rs_g.getLong("Receive_Id");    	Consignment_ReceiveId[c]=rs_g.getLong("Consignment_ReceiveId");
			purchase[c]=rs_g.getBoolean("purchase");//b
			receive_sell[c]=rs_g.getBoolean("receive_sell");//b
			//out.print("<br>receive_sell[c]="+receive_sell[c]);
			returned[c]=rs_g.getBoolean("R_Return");//b
			stocktransfer_type[c]=rs_g.getInt("StockTransfer_Type");
			opening_stock[c]=rs_g.getBoolean("Opening_Stock");//b
			lotid[c]=rs_g.getLong("Lot_id");
			//out.print("<br>366 lotid["+c+"]="+lotid[c]);
			available_qty[c]=rs_g.getDouble("Available_Quantity");
			qty[c]=rs_g.getDouble("Quantity");
			localprice[c]=rs_g.getDouble("Local_Price");
			dollarprice[c]=rs_g.getDouble("Dollar_Price");
			rec_total[c]=rs_g.getDouble("Receive_Total");
			c++;
		}

		errLine = "356";
//out.print("<br>354 query" + query);
		pstmt_g.close();
		
		int j=0;
		long currentLotId = -1;
		
		if(count > 0 && lotid[j] == lot_id[lotIndex] )
			currentLotId=lotid[j]; //if lot present make it the current lot

		errLine = "366";
		
		//out.print("<br>385 count="+count);
			
		while(j < count)
		{
			//out.print("<br>389 lotid["+j+"]="+lotid[j]);
			if(currentLotId != lotid[j])//if the lot id changed
			{
				errLine = "375";
				ik = lotIndex;
					//out.print("<br>396 ik="+ik);			
				if(counter != 1)
					lotIndex++;
				
				currentLotId = lot_id[lotIndex];
				
				errLine = "383";
				
				
				consignment_in_qty[ik]=consignment_in_qty_var;
				consignment_out_qty[ik]=consignment_out_qty_var ;
				consignment_sale_return_qty[ik]=consignment_sale_return_qty_var;
				consignment_sale_confirm_qty[ik]=consignment_sale_confirm_qty_var;
				consignment_purchase_return_qty[ik]=consignment_purchase_return_qty_var;
				consignment_purchase_confirm_qty[ik]=consignment_purchase_confirm_qty_var;

				financial_in_qty[ik]=financial_in_qty_var;
				financial_out_qty[ik]=financial_out_qty_var ;
				financial_sale_qty[ik]=financial_sale_qty_var;
				financial_sale_return_qty[ik]=financial_sale_return_qty_var;
				financial_purchase_qty[ik]=financial_purchase_qty_var;
				financial_purchase_return_qty[ik]=financial_purchase_return_qty_var;
				opening_stock_qty[ik]=opening_stock_qty_var;
				stock_transfer_qty[ik]=stock_transfer_qty_var	;
			
				// code for calculation for gross profit  
				if((gross_purchase_qty_var == 0) || (gross_purchase_var == 0) || (gross_sale_qty_var == 0))
						gross[ik]=0.0;
				else
					gross[ik]=( (100 * (gross_sale_var/gross_sale_qty_var)) / (gross_purchase_var/gross_purchase_qty_var) ) - 100;
				
				
				
								

					carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];
					carats[ik]=str.mathformat(carats[ik],3);	

					//stores the physical quantity
					pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
					pcarats[ik]=str.mathformat(pcarats[ik],3);

					//calculation of cgt inward and outward quantity
					consignment_inward_qty[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik];
					consignment_outward_qty[ik]= consignment_out_qty[ik]-consignment_sale_return_qty[ik]-consignment_sale_confirm_qty[ik];

					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				// end of MIS Stock}

				consignment_in_qty_var=0;
				consignment_out_qty_var=0;
				consignment_sale_return_qty_var=0;
				consignment_sale_confirm_qty_var=0;
				consignment_purchase_return_qty_var=0;
				consignment_purchase_confirm_qty_var=0;
				financial_in_qty_var=0;
				financial_out_qty_var=0;
				financial_sale_qty_var=0;
				financial_sale_return_qty_var=0;
				financial_sale_confirm_qty_var=0;
				financial_purchase_qty_var=0;
				financial_purchase_return_qty_var=0;
				opening_stock_qty_var=0;
				stock_transfer_qty_var	=0;

				gross_sale_var=0;
				gross_sale_qty_var=0;
				gross_purchase_var=0;
				gross_purchase_qty_var=0;

				localp=0;
				localp_temp=0;
				tqty=0;
				totalQty=0;
				tqty_temp=0;
				dollarp=0;
				dollarp_temp=0;
	
				continue;
			}
			errLine = "464";
			// Financial Purcahse/Receive -1 . 

			if((receive_sell[j]==true) && (purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) && (stocktransfer_type[j]==0) && (Consignment_ReceiveId[j]== 0)) 
			{
				tqty_temp = totalQty;
				totalQty+=qty[j];
			
				financial_purchase_qty_var +=qty[j];
				financial_in_qty_var += qty[j];
			
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;

				totalQty = str.mathformat(totalQty, 3);

				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				

				if((totalQty)== 0)
				{
					localp=0;
					dollarp=0;
				}
				else
				{
					localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
					dollarp	=((dollarp_temp * tqty_temp) +( qty[j]*dollarprice[j]))  /(tqty_temp +  qty[j]) ;
				}	
				//out.print("<br>462 finanacial purchase Localp for"+lotid[j]+"="+localp);
				//out.print("<br>Fin. Pur totalQty="+totalQty);
			}

			// Financial Sale.
			else if((receive_sell[j]==false) && (purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) && (stocktransfer_type[j]==0) && (Consignment_ReceiveId[j]==0))
			{	
				totalQty-=qty[j];
				financial_sale_qty_var += qty[j];
				financial_out_qty_var += qty[j];
				
				totalQty = str.mathformat(totalQty, 3);
				
				gross_sale_qty_var+=qty[j];
				gross_sale_var += (qty[j]*localprice[j]);
				
				//out.print("<br>Fin. Sale totalQty="+totalQty);
			}	
			// consignment purchase -1
			else if((receive_sell[j]==true) && (purchase[j]==false) && (returned[j]==false) && (opening_stock[j]==false)) 
			{
							  
				consignment_in_qty_var+=qty[j];

				totalQty = str.mathformat(totalQty, 3);
				consignment_in_qty_var=str.mathformat(consignment_in_qty_var,3);

				//out.print("<br>Cgt. purchase totalQty="+totalQty);
			}

			//Consignment Sale. -1 
			else
			if(( (receive_sell[j]==false) &&(purchase[j]==false) && (returned[j]==false) && (opening_stock[j]==false) ))
			{
				consignment_out_qty_var=consignment_out_qty_var + qty[j];

				totalQty = str.mathformat(totalQty, 3);
						
				consignment_out_qty_var=str.mathformat(consignment_out_qty_var,3);
				//out.print("<br>Cgt. Sale totalQty="+totalQty);
			}
			
			//Coinsignment Sale Return.
			else if((receive_sell[j]==true) && (purchase[j]==false) && (returned[j]==true))
			{
													
				consignment_sale_return_qty_var +=qty[j];

				totalQty = str.mathformat(totalQty, 3);
				consignment_sale_return_qty_var=str.mathformat(consignment_sale_return_qty_var,3);
				//out.print("<br>Cgt. Sale Return totalQty="+totalQty);
			}

			//Consignment Sale Confirm -1 .
			else 
			if( (receive_sell[j]==false) &&(purchase[j]==true) 				&&(returned[j]==false) && (opening_stock[j]==false) && (Consignment_ReceiveId[j] != 0))
			{		
				totalQty-=qty[j];
				consignment_sale_confirm_qty_var =consignment_sale_confirm_qty_var 
					+qty[j];
				financial_out_qty_var += qty[j];

				totalQty = str.mathformat(totalQty, 3);

				gross_sale_qty_var += qty[j];
				gross_sale_var +=(qty[j]*localprice[j]);
				
				//out.print("<br>Cgt. Sale Confirm totalQty="+totalQty);
			}
			
			//Financial sale return -1 .
			else
			if( (receive_sell[j]==true) && (purchase[j]==true) 				&(returned[j]==true) && (opening_stock[j]==false) )
			{
				tqty_temp=totalQty;
				totalQty+=qty[j];

				financial_sale_return_qty_var +=qty[j];
				financial_in_qty_var += qty[j];

				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				
				financial_sale_return_qty_var=str.mathformat(financial_sale_return_qty_var,3);
				totalQty = str.mathformat(totalQty, 3);
				
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;
					// gross calci
			
				if((totalQty)==0)
				{
					localp=0;
					dollarp=0;
				}
				else
				{
					localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
					dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
				}	
				
			}
			// Stopped
			//Financial Purchase Return.
			else 
			if( (receive_sell[j]==false) &&(purchase[j]==true) && (returned[j]==true) && (opening_stock[j]==false)  )
			{		
				totalQty-=qty[j];
				financial_purchase_return_qty_var =financial_purchase_return_qty_var 
					+qty[j];

				totalQty = str.mathformat(totalQty, 3);
				financial_out_qty_var += qty[j];

				gross_sale_qty_var +=(qty[j]);
				gross_sale_var +=(qty[j]*localprice[j]);
				
				//out.print("<br>Fin. Purchase Return totalQty="+totalQty);
			}
			//Consignment Purchase Return.

			else 
			if( (receive_sell[j]==false) &&(purchase[j]==false) 				&&(returned[j]==true) && (opening_stock[j]==false))
			{		
				
				consignment_purchase_return_qty_var =consignment_purchase_return_qty_var 			+qty[j];

				totalQty = str.mathformat(totalQty, 3);

				//out.print("<br>Cgt. Purchase Return totalQty="+totalQty);
			}

			//Consignment Purchase Confirm.
			else 
			if( (receive_sell[j]==true) &&(purchase[j]==true) &&(returned[j]==false) && (opening_stock[j]==false) && !(Consignment_ReceiveId[j] == 0))
			{		
				totalQty+=qty[j];
				consignment_purchase_confirm_qty_var =consignment_purchase_confirm_qty_var				+qty[j];
				financial_in_qty_var += qty[j];

				totalQty = str.mathformat(totalQty, 3);

				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;
						
				if((totalQty)==0)
				{
					localp=0;
					dollarp=0;
				}
				else
				{
					localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
					dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
				}	
				
			}
			//opening_stock
			else
			if( (receive_sell[j]==true) &&(purchase[j]==true) 				&&(returned[j]==false) && (opening_stock[j]==true) &&    (Consignment_ReceiveId[j] == 0))
			{		
				tqty_temp=totalQty;
				totalQty+=qty[j];
					
				opening_stock_qty_var +=available_qty[j];
				financial_in_qty_var += available_qty[j];

				gross_purchase_qty_var +=(available_qty[j]);
				gross_purchase_var +=(available_qty[j]*localprice[j]);
				
				opening_stock_qty_var=str.mathformat(opening_stock_qty_var,3);

				totalQty = str.mathformat(totalQty, 3);
			
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;

				if((opening_stock_qty_var)==0)
				{
					localp=0;
					dollarp=0;
				}
				else
				{
					localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
					dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
				}
				
				
				
			}

			// Stock Transfer. -1
			if((purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) &&   (stocktransfer_type[j] != 0)) 
			{
				if(receive_sell[j]==true){
				
				tqty_temp=totalQty;
				totalQty+=qty[j];
			
				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);

				stock_transfer_qty_var +=qty[j];
				financial_in_qty_var += qty[j];
				totalQty = str.mathformat(totalQty, 3);
				stock_transfer_qty_var=str.mathformat(stock_transfer_qty_var,3);

				dollarp_temp=dollarp;
				dollarp=0;
				localp_temp= localp;
				localp=0;

				if(0==(totalQty)){
					localp=0;
					dollarp=0;
				}
				else{

					 localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
					 dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
				}

				
				}

			else{
				totalQty-=qty[j];
				stock_transfer_qty_var -=qty[j];
				totalQty = str.mathformat(totalQty, 3);

				gross_sale_qty_var +=(qty[j]);
				gross_sale_var +=(qty[j]*localprice[j]);
				stock_transfer_qty_var=str.mathformat(stock_transfer_qty_var,3);
				financial_out_qty_var += qty[j];
				//out.print("<br>stock transfer OUT totalQty="+totalQty);
				}
				
			}// last if close
			j++;
			
		}
		errLine = "748";
		// end of while
		//code to calculate the data for the last item row
		
		if(count > 0)
		{
			errLine = "754";
			if(counter != 1)
				ik++;
			
			
			consignment_in_qty[ik]=consignment_in_qty_var;
			consignment_out_qty[ik]=consignment_out_qty_var ;
			consignment_sale_return_qty[ik]=consignment_sale_return_qty_var;
			consignment_sale_confirm_qty[ik]=consignment_sale_confirm_qty_var;
			consignment_purchase_return_qty[ik]=consignment_purchase_return_qty_var;
			consignment_purchase_confirm_qty[ik]=consignment_purchase_confirm_qty_var;

			financial_in_qty[ik]=financial_in_qty_var;
			financial_out_qty[ik]=financial_out_qty_var ;
			financial_sale_qty[ik]=financial_sale_qty_var;
			financial_sale_return_qty[ik]=financial_sale_return_qty_var;
			financial_purchase_qty[ik]=financial_purchase_qty_var;
			errLine = "771";

			financial_purchase_return_qty[ik]=financial_purchase_return_qty_var;
			opening_stock_qty[ik]=opening_stock_qty_var;
			stock_transfer_qty[ik]=stock_transfer_qty_var	;

			// code for calculation for gross profit  
			if((gross_purchase_qty_var == 0) || (gross_purchase_var == 0) || (gross_sale_qty_var == 0))
					gross[ik]=0.0;
			else
				gross[ik]=( (100 * (gross_sale_var/gross_sale_qty_var)) / (gross_purchase_var/gross_purchase_qty_var) ) - 100;
			/*
				
//Start MIS
			if("MIS Stock".equals(command))
			{
			*/
				//stores the financial quantity
				carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];
				carats[ik]=str.mathformat(carats[ik],3);	

				//stores the physical quantity
				pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
				pcarats[ik]=str.mathformat(pcarats[ik],3);

				//calculation of cgt inward and outward quantity
				consignment_inward_qty[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik];
				consignment_outward_qty[ik]= consignment_out_qty[ik]-consignment_sale_return_qty[ik]-consignment_sale_confirm_qty[ik];

				local_price[ik]=localp;
				dollar_price[ik]=dollarp;

			//end of MIS block}
			
		}//end of block for the last lot
		errLine = "806";
		if( (divend + brkPoint) < (counter-1) )
		{
			divstart = divend + 1;
			//out.print("<br>divstart="+divstart);
		}
		else
		{
			divstart = divend + 1;
			brkPoint = counter - divstart;
				errLine = "816";
			//out.print("<br>brkPoint="+brkPoint);
			//out.print("<br>divstart last="+divstart);
		}

	
	}//end of divide logic block

//display for physical and financial stock report display


/*

if("MIS Stock".equals(command))
{
	*/
	%>
<html>
<head>
<title>System run for update LotLocation</title>
<script language="JavaScript">
function disrtclick()
{
	//window.event.returnValue=0;
}

//background='exambg.gif'
</script>


<%

double psubtotal=0;
double fin_balance_total=0;
double cgt_balance_total=0;
double phy_balance_total=0;
double phy_amt_total=0;


int lastS=0;
int s=1;
int  newlotlocation_id= L.get_master_id(conp,"LotLocation");
for(int i=0; i< counter; i++)
{

	ccarats[i] = consignment_inward_qty[i] - consignment_outward_qty[i];

	psubtotal= pcarats[i] * local_price[i];

	fin_balance_total += carats[i];
	cgt_balance_total += ccarats[i];
	phy_balance_total += pcarats[i];
	phy_amt_total += psubtotal;
	
if(0==(s%35) && lastS != s)
{
	lastS = s;
%>
	

<%
}//end of if

//do not display rows with zero values
if( !(carats[i]==0 && consignment_inward_qty[i]==0 && consignment_outward_qty[i]==0 && ccarats[i]==0 && pcarats[i]==0) )
{
	//out.print("<br>["+i+"] zero rows");
	//out.print("<br>lot_no["+i+"]= "+lot_no[i]);

	String lot_id_new=A.getNameCondition(cong,"Lot","Lot_Id"," where Company_Id="+party_id[k1]+" and Lot_No='"+lot_no[i]+"' and  YearEnd_Id="+reportyearend_id);

	//out.print("<br> lot_id_new= "+lot_id_new);
//carats
	 out.print("<br>");
     out.print("<br> For Lot No.["+i+"]= "+lot_no[i]);
     out.print("<br> {Financial Qty} carats has been updated["+i+"]= "+carats[i]);
     out.print("<br> {Physical Qty} Available pcarats has been updated["+i+"]= "+pcarats[i]);
     out.print("<br>");
	//out.print("<br> location_id= "+location_id[k1]);




String query_select_presentLot="select count(*) as Present from LotLocation where Company_Id="+party_id[k1]+" and Location_Id="+location_id[k1]+"  and Lot_Id="+lot_id_new+" and YearEnd_Id="+reportyearend_id;

pstmt_g = cong.prepareStatement(query_select_presentLot);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
presentcounter=rs_g.getInt("Present");
}
//out.print("<br>951  presentcounter="+presentcounter);
errLine = "952";
pstmt_g.close();



if(presentcounter==1)
	{
	
	
	//out.print("<br><font color=#CC0033> Update Query Start.....</font>");

	String update_LotLocation="Update LotLocation set Carats="+carats[i]+", Available_Carats="+pcarats[i]+" where Location_Id="+location_id[k1]+" and Lot_Id="+lot_id_new+" and Company_Id="+party_id[k1]+" and YearEnd_Id="+reportyearend_id;

    pstmt_p = conp.prepareStatement(update_LotLocation);

    a417 = pstmt_p.executeUpdate();
    //out.print("<br> Updated  LoLocation Successfully: "+a417);

out.print("<br><font color=#CC0033> Update LotLocation Successfully:.....</font>");

   out.print("<br>");
   out.print("<br>-----------------*-----------------*---------*----------*-----------*-----------*--------------*-------------");
	}


	//int  newlotlocation_id= L.get_master_id(conp,"LotLocation");

	if(presentcounter==0)
	{
errLine = "948";  
//int  newlotlocation_id= L.get_master_id(conp,"LotLocation");
out.print("<br>950 <font color=#3333FF>Insert query start .....</font>");
//String insert_LotLocation="insert into LotLocation (LotLocation_Id,Location_Id,Company_Id,Lot_Id,Carats,Available_Carats,Modified_On,Modified_By,Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D1+"',?,?,?)";

String insert_LotLocation="insert into LotLocation (LotLocation_Id,Location_Id,Company_Id,Lot_Id,Carats,Available_Carats,Modified_On,Modified_By,Modified_MachineName,YearEnd_Id) values(?,?,?,?,?,?,'"+D1+"',?,?,?)";





pstmt_p=conp.prepareStatement(insert_LotLocation);
//out.print("<br> insert_LotLocation="+insert_LotLocation);
		pstmt_p.setString(1,""+newlotlocation_id);
		out.print("<br> 957 newlotlocation_id"+newlotlocation_id);
		pstmt_p.setString(2,location_id[k1]);
		out.print("<br> 957 location_id[k1]"+location_id[k1]);
		pstmt_p.setString(3,party_id[k1]);
		out.print("<br> 957 party_id[k1]"+party_id[k1]);

		pstmt_p.setString(4,lot_id_new);
		out.print("<br> 957 lot_id_new"+lot_id_new);
		//out.print("<br>961 lot_id_new="+lot_id_new);

		pstmt_p.setDouble(5,carats[i]);
		out.print("<br> 5 carats[i]"+carats[i]);
		pstmt_p.setDouble(6,pcarats[i]);
		out.print("<br> 6 pcarats[i]"+pcarats[i]);

		pstmt_p.setString(7,"999");
		out.print("<br> 7 999");
		//pstmt_p.setString(8,""+D1);
       //out.print("<br>968 D1="+D1);
		//pstmt_p.setString(7,"2");
		//out.print("<br>970 user_id="+user_id);
		pstmt_p.setString(8,""+machine_name);
		out.print("<br>8 machine_name="+machine_name);
		pstmt_p.setString (9,""+reportyearend_id);
		out.print("<br>9 machine_name="+machine_name);


		errLine = "973"; 
		int a408=pstmt_p.executeUpdate();
		errLine = "975";
		out.print("<br> 991 a408"+a408);
		pstmt_p.close();
		newlotlocation_id=newlotlocation_id+1;
		}

%>

<%
	//newlotlocation_id=newlotlocation_id+1;
}//end of if used for not displaying zero values rows

//newlotlocation_id=newlotlocation_id+1;
}//end of for
%>


<%
///////////}//end of if MIS Stock

}//end of loop of locationid

C.returnConnection(cong);
C.returnConnection(conp);

}catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("<BR> errLine = "+errLine+" at EXCEPTION="+e);
}

}//end of command of samyak
%>
</BODY>
</HTML>




