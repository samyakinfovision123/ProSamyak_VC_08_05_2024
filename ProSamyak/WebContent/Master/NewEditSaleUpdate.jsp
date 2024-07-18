<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="L"   class="NipponBean.login"/>
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />

<html>
<head>
<title>Samyak Software -India</title>


</head>
<% 
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

String errLine = "31";

try{


	try	
	{
		cong=C.getConnection();
		conp=C.getConnection();
	}
	catch(Exception Samyak60)
	{ 
	out.println("<br><font color=red> FileName : cgtConfirmOrPurchaseUpdate.jsp<br>Bug No Samyak60 : "+ Samyak60);
	}
	
	
	String user_id= ""+session.getValue("user_id");
	String machine_name=request.getRemoteHost();
	String user_name = ""+session.getValue("user_name");
	int user_level = Integer.parseInt(""+session.getValue("user_level"));
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	int yearend_id1=Integer.parseInt(yearend_id);
	int tempCompany_Id = Integer.parseInt(company_id);
	String company_name="";
	
	String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+company_id;
	pstmt_g = cong.prepareStatement(company_query);
	rs_g = pstmt_g.executeQuery();
		while(rs_g.next()) 	
		{
			company_name= rs_g.getString("CompanyParty_Name");	
			
		}
	pstmt_g.close();
	String local_currencyid1=I.getLocalCurrency(cong,company_id);
	int local_currencyid=Integer.parseInt(local_currencyid1);
	String local_currencysymbol= I.getLocalSymbol(cong,company_id);
	//out.print("<br>local_currencysymbol"+local_currencysymbol);
	String base_exchangerate= I.getLocalExchangeRate(cong,company_id);

	errLine = "75";
	java.sql.Date D4 = new
	java.sql.Date(System.currentTimeMillis());
	String date=""+format.format(D4);
	
	
	java.sql.Date temp_endDate=YED.getDate(cong,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
	int temp_dd1=temp_endDate.getDate();
	int temp_mm1=temp_endDate.getMonth();
	int temp_yy1=temp_endDate.getYear();
	temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
	String endDate = format.format(temp_endDate);
	String pendingPurchase=request.getParameter("pendingPurchase");

	errLine = "88";

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date invoice_datetemp = new java.sql.Date(System.currentTimeMillis());

	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_date=stoday_day+"/"+stoday_month+"/"+today_year;
// end of today_date in dd/mm/yyyy format
	String command = request.getParameter("command");
	String cgtPurPending = request.getParameter("cgtPurPending");
	String refReceive_Id = request.getParameter("Receive_Id");
	String currReceive_Id = "0";
	errLine = "107";
	String againstRec_Id = "0";

	String lots = request.getParameter("oldLotRows");
	errLine = "111";
	int lotRows= Integer.parseInt(lots);
	//int NewlotRows= Integer.parseInt(Newlots);
	errLine = "113";
	String condition="and Super=0  and Purchase=1 and active=1";
	//int newLedgerRows = 0;
	int newLotRows = 0;
	int directSave = 0;
	errLine = "115";
	
	
	int oldLedgerRows = Integer.parseInt(request.getParameter("oldLedgerRows"));
	
	int tempcounter = Integer.parseInt(request.getParameter("tempcounter"));
	int tempOldLedgercounter = Integer.parseInt(request.getParameter("tempOldLedgercounter"));
	int newLedgerRows = oldLedgerRows - tempOldLedgercounter;
	int newLotrows= lotRows - tempcounter;
	errLine = "121";
	int flag1 = 0;
	int receive_id =Integer.parseInt(request.getParameter("receive_id"));
	String purchase_no = request.getParameter("purchase_no");
	out.print("<br> purchase_no"+purchase_no);
	if("SAVE".equals(command)  )
	{

		boolean dataCommitted = false; //just used for redirecting decision purpose
		 
		int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid1));
		 
		//Reading the data from the previous file
errLine = "137";
		int invalidLots = 0;
		
		out.print("<br> receive_id"+receive_id);
		
		String ref_no = request.getParameter("ref_no");
		String currency = request.getParameter("currency");
		String companyparty_name = request.getParameter("companyparty_name");
		int companyparty_id=Integer.parseInt(request.getParameter("companyparty_id"));

		int newCompanyParty_Id=Integer.parseInt(A.getNameCondition(cong,"Master_CompanyParty","CompanyParty_Id","where Active=1 and Company_id="+tempCompany_Id+"and companyParty_name like '"+companyparty_name+"'"));


errLine = "151";
		int purchasesalegroup_id =Integer.parseInt(request.getParameter("purchasesalegroup_id"));
errLine = "153";
		String datevalue = request.getParameter("datevalue");
		int duedays =Integer.parseInt(request.getParameter("duedays"));
		String duedate = request.getParameter("duedate");
		String purchase_type = request.getParameter("purchase_type");
errLine = "158";
		String tempLocation=request.getParameter("location_id0");
	
		int location_id0 = Integer.parseInt(tempLocation);
	
errLine = "160";
		int category_id =Integer.parseInt(request.getParameter("category_id"));
		double exchange_rate =Double.parseDouble(request.getParameter("exchange_rate"));
errLine = "162";		
		int purchaseperson_id =Integer.parseInt( request.getParameter("purchaseperson_id"));
		String Broker_Id = request.getParameter("Broker_Id");
errLine = "157";	
		String broker_remarks = request.getParameter("broker_remarks");
		String pendingSales = request.getParameter("pendingSales");

	// reading data from previous lot.......
errLine = "162";
		String againstRT_Id[] = new String[lotRows];
		String rtid[] = new String[lotRows];
		int lotid[] = new int[lotRows];
		String split[] = new String[lotRows];
		String lotno[] = new String[lotRows];
		String description[] = new String[lotRows];
		String dsize[] = new String[lotRows];
		double originalQty[] = new double[lotRows];
		double returnQty[] = new double[lotRows];
		double ghat[] = new double[lotRows];
		String rejection[] = new String[lotRows];
		String newrejection[] = new String[lotRows];
		String rejectionQty[] = new String[lotRows];
		double qty[] = new double[lotRows];
		double rate[] = new double[lotRows];
		double effrate[] = new double[lotRows];
		double localrate[] = new double[lotRows];
		double efflocalrate[] = new double[lotRows];
		double amount[] = new double[lotRows];
		double Localamount[] = new double[lotRows];
		String remarks[] = new String[lotRows];
		String lotDiscount[] = new String[lotRows];
		String ot_Id[]=new String[lotRows];
		String new_Sale[]=new String[lotRows];
		int receivetransaction_id[]=new int[lotRows];

		for(int i=0;i<lotRows;i++)
		{
			lotid[i] =Integer.parseInt(request.getParameter("lot_id"+i));
			lotno[i] = request.getParameter("lotno"+i);
			description[i] = request.getParameter("description"+i);
			dsize[i] = request.getParameter("dsize"+i);
			originalQty[i] =Double.parseDouble(request.getParameter("originalQuantity"+i));
			
			returnQty[i] =Double.parseDouble(request.getParameter("returnQuantity"+i));
		
			ghat[i] =Double.parseDouble(request.getParameter("ghat"+i));
		
			rejection[i] = request.getParameter("rejection"+i);
			newrejection[i] = request.getParameter("newrejection"+i);
			rejectionQty[i] = request.getParameter("rejectionQty"+i);
			qty[i] =Double.parseDouble(request.getParameter("quantity"+i));
			rate[i] =Double.parseDouble(request.getParameter("rate"+i));
			
			effrate[i] =Double.parseDouble(request.getParameter("effrate"+i));
			
			localrate[i] =Double.parseDouble(request.getParameter("localrate"+i));
			
			efflocalrate[i] =Double.parseDouble(request.getParameter("efflocalrate"+i));
			
			amount[i] =Double.parseDouble(request.getParameter("amount"+i));
			Localamount[i] =Double.parseDouble(request.getParameter("Localamount"+i));
			remarks[i] = request.getParameter("remarks"+i);
			lotDiscount[i] = request.getParameter("lotDiscount"+i);
					
		}//for..
errLine = "231";
		for(int i=0;i<tempcounter;i++)
		{
			receivetransaction_id[i]=Integer.parseInt(request.getParameter("receivetransaction_id"+i));
			new_Sale[i]=request.getParameter("New_Sale"+i);
		}
errLine = "236";
		// for Delete Lot
		String DelLots[]= new String[tempcounter];
		int DelCounter=0;
		if(lotRows > 1 )
		{
			for(int i=0;i<tempcounter;i++)
			{
				DelLots[i]=request.getParameter("checkBox"+i);
				if(DelLots[i].equals("Delete"))
				{
					DelCounter++;
					
				}
				
			}
		}
		//end delete lot..
errLine = "253";
		 String Transaction_Id[]=new String[tempOldLedgercounter];
		// for old ledger
		 for( int j=0;j<tempOldLedgercounter;j++)
		{
			Transaction_Id[j]=request.getParameter("Transaction_Id"+j);
		}
		// end old ledger
errLine = "240";
		double qtyTotal =Double.parseDouble( request.getParameter("totalsquantity"));

		double InvTotalAmount =Double.parseDouble( request.getParameter("InvTotalAmount"));
	
		double InvTotalLocalAmount =Double.parseDouble( request.getParameter("InvTotalLocalAmount"));
errLine = "246";
		double amountTotal =Double.parseDouble( request.getParameter("totalamount"));
errLine = "248";
		double localamountTotal =Double.parseDouble(request.getParameter("totalLocalamount"));
		String narration = request.getParameter("narration");
errLine = "247";
		//Read the values of the old ledger rows
		String ledger[] = new String[oldLedgerRows];
		
		double ledgerPercent[] = new double[oldLedgerRows];
		String ledgerAmount[] = new String[oldLedgerRows];
		String ledgerLocalAmount[] = new String[oldLedgerRows];
		String debitcredit[] = new String[oldLedgerRows];
		for(int i=0; i<oldLedgerRows; i++)
		{
			ledger[i] = request.getParameter("ledger"+i);
			ledgerPercent[i] = Double.parseDouble(request.getParameter("ledgerPercent"+i));
			ledgerAmount[i] = request.getParameter("Lamount"+i);
			ledgerLocalAmount[i] = request.getParameter("LocalLamount"+i);
			debitcredit[i] = request.getParameter("debitcredit"+i);
		}
		String amountFinalTotal = request.getParameter("totalamount");
errLine = "252";
		//variables for ghat entry
		double ghatQtyTotal=0;
		double ghatReceiveLocalAmount=0;
		double ghatReceiveDollarAmount=0;

		double ghatLotLocalAmount[] = new double[lotRows];
		double ghatLotDollarAmount[] = new double[lotRows];
		int templotrows = lotRows - DelCounter;
		
		int ghatReceive_id=0;
//out.print("<br> 292  receive_id"+receive_id);
		String query1 ="select receive_id from receive where consignment_receiveid="+receive_id;
		pstmt_p = cong.prepareStatement(query1);
//out.print("<br> 302  query1"+query1);

		rs_p = pstmt_p.executeQuery();
		while(rs_p.next())
		{
			ghatReceive_id = rs_p.getInt("receive_id");
			
		}
		pstmt_p.close();
//out.print("<br> 302  ghatReceive_id"+ghatReceive_id);
int ghatReceiveTransaction_id[]=new int[tempcounter];

	for(int k=0;k<tempcounter;k++)
	{

		//int ghatReceiveTransaction_id=0;
		query1 ="select receivetransaction_id from receive_transaction where consignment_receiveid="+receivetransaction_id[k];
		pstmt_p = cong.prepareStatement(query1);
		rs_p = pstmt_p.executeQuery();
		while(rs_p.next())
		{
			ghatReceiveTransaction_id[k] = rs_p.getInt("receivetransaction_id");
			
		}
		pstmt_p.close();
	}

int for_head[]=new int[oldLedgerRows]; 
int forhead_id[]=new int[oldLedgerRows];
String  DelLedger[]=new String[tempOldLedgercounter];
int ReceiveFrom_LedgerId=0;
if (tempOldLedgercounter != 0)
{
	for(int k=0;k<tempOldLedgercounter;k++)
	{
		for_head[k]=Integer.parseInt(A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[k]));
		forhead_id[k]=Integer.parseInt(A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[k]));

		DelLedger[k]=request.getParameter("delLedger"+k);
	}
	ReceiveFrom_LedgerId=Integer.parseInt(A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+newCompanyParty_Id+" and Ledger_Type=2"));
}
if(newLedgerRows != 0)
{
	for(int k=tempOldLedgercounter;k<oldLedgerRows;k++)
	{
		for_head[k]=Integer.parseInt(A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[k]));
		forhead_id[k]=Integer.parseInt(A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[k]));
	}
}
		int transaction_id=L.get_master_id(cong,"Financial_Transaction");
		int testvoucher_id =0;

		query1 ="select voucher_id from voucher where voucher_no='"+receive_id+"'";
			pstmt_p = cong.prepareStatement(query1);
			rs_p = pstmt_p.executeQuery();
			while(rs_p.next())
			{
				testvoucher_id = rs_p.getInt("voucher_id");
			}
			pstmt_p.close();
	int Receivetransaction_id1= L.get_master_id(cong,"Receive_Transaction");

		String Narration = request.getParameter("narration");
		String NarrationTemp=request.getParameter("NarrationTemp");
		String TempNarration="";
		String TempNarration1="";
		StringTokenizer stknizer= new StringTokenizer(NarrationTemp,",");
		while(stknizer.hasMoreTokens())
		{
			TempNarration=stknizer.nextToken();
			TempNarration1=TempNarration1+" "+TempNarration;
		}


		conp.setAutoCommit(false);

		//Update receive table  
		String query="update receive set Receive_Lots=?, Receive_Quantity=?, Receive_CurrencyId=?, Exchange_Rate=?, Receive_ExchangeRate=?, Receive_Total=?, Local_Total=?, Dollar_Total=?, Receive_FromId=?,Receive_FromName=?, Company_Id=?, Receive_ByName=?, Due_Days=?, Due_Date=?, Modified_On=?, Modified_By=?, Modified_MachineName=?,SalesPerson_Id=?,InvTotal=?, InvLocalTotal=?, InvDollarTotal=?, Receive_Category=?, YearEnd_Id=?,PurchaseSaleGroup_Id=?,CgtDescription=?,Broker_Id=? where receive_id="+receive_id;
		pstmt_p = conp.prepareStatement(query);
		
		//out.print("<br> 290 templotrows"+templotrows);
		pstmt_p.setInt (1,templotrows);
		pstmt_p.setDouble (2,qtyTotal);
		if("Local".equals(currency))
			pstmt_p.setInt (3,local_currencyid);	
		else
			pstmt_p.setInt (3,0);
		pstmt_p.setDouble (4,exchange_rate);
		pstmt_p.setDouble (5,exchange_rate);
		if("Local".equals(currency))
		{pstmt_p.setDouble (6,localamountTotal);}
		else{pstmt_p.setDouble (6,amountTotal);}
		pstmt_p.setDouble (7,localamountTotal);
		pstmt_p.setDouble (8,amountTotal);
		pstmt_p.setInt (9,newCompanyParty_Id);
		pstmt_p.setString (10,""+ companyparty_name);
		pstmt_p.setInt (11,tempCompany_Id);
		pstmt_p.setString (12,user_name);		
		pstmt_p.setInt (13,duedays);	
		pstmt_p.setString (14, ""+format.getDate(duedate));	
		pstmt_p.setString (15, ""+D);	
		pstmt_p.setString (16, ""+user_id);	
		pstmt_p.setString (17, machine_name);
		pstmt_p.setInt (18,purchaseperson_id);
		if("Local".equals(currency))
			pstmt_p.setDouble (19,InvTotalLocalAmount);
		else
			pstmt_p.setDouble (19,InvTotalAmount); 
		pstmt_p.setDouble (20,InvTotalLocalAmount);
		pstmt_p.setDouble (21,InvTotalAmount);
		pstmt_p.setInt (22,category_id);
		pstmt_p.setInt (23,yearend_id1);
		pstmt_p.setInt (24,purchasesalegroup_id);
		pstmt_p.setString (25,TempNarration1);
		pstmt_p.setString (26,""+Broker_Id);
		//pstmt_p.setString (25,0);
errLine = "318";
		int a224 = pstmt_p.executeUpdate();
		pstmt_p.close();
		out.print("<br> 310 Update data on receive.."+a224);
		errLine = "312";
		//end Update receive table  

		//Update Data in Receive_Transaction
		out.print("<br> 335 tempcounter"+tempcounter);
		int i=0;
		if(tempcounter != 0)
		{
			errLine = "339";
			for( i=0; i<tempcounter; i++)
			{
	
			//out.print("<br> 343 tempcounter"+tempcounter);
			errLine = "344";
			query="update Receive_Transaction set Lot_Id=?, Original_Quantity=?, Quantity=?,Receive_Price=?, Local_Price=?, LocalEffective_Price=?, Dollar_Price=?, DollarEffective_Price=?, Local_Amount=?, Dollar_Amount=?, Remarks=?,Return_Quantity=?,Lot_Discount=?,Modified_On=?, Modified_By=?, Modified_MachineName=?,Active=? where receivetransaction_id="+receivetransaction_id[i];
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setInt(1,lotid[i]);
			pstmt_p.setDouble(2,originalQty[i]);	
			//out.print("<br>347 receivetransaction_id[i] "+receivetransaction_id[i]);
			pstmt_p.setDouble(3,qty[i]);	
			//pstmt_p.setString (3,""+qty[i]);	
			if("Local".equals(currency))
				{pstmt_p.setDouble(4,localrate[i]);}	
			else{pstmt_p.setDouble(4,rate[i]);	}

			pstmt_p.setDouble (5,localrate[i]);	
			pstmt_p.setDouble (6,efflocalrate[i]);	
			pstmt_p.setDouble (7,rate[i]);	
			pstmt_p.setDouble (8,effrate[i]);	
			pstmt_p.setDouble (9,Localamount[i]);		
			pstmt_p.setDouble (10,amount[i]);	
			pstmt_p.setString (11, remarks[i]);		
			pstmt_p.setDouble (12,returnQty[i]);
			pstmt_p.setString (13,lotDiscount[i]);
			pstmt_p.setString (14,""+D);
			pstmt_p.setString (15,""+user_id);
			pstmt_p.setString (16,machine_name);
			
			if(lotRows > 1 )
			{
			errLine = "371";	
			//out.print("<br> DelLots[i]="+DelLots[i]);
				if(DelLots[i].equals("Delete"))
				{
					errLine = "374";	
					pstmt_p.setString (17,"0");
				}
				else
				{

						errLine = "379";	
						out.print("<br>382 elsePart=");
						pstmt_p.setString (17,"1");

						ghatQtyTotal += ghat[i];

						ghatLotLocalAmount[i] =ghat[i] * efflocalrate[i];
						ghatLotDollarAmount[i] = ghat[i] * effrate[i];
					

						ghatReceiveLocalAmount += ghatLotLocalAmount[i];
						ghatReceiveDollarAmount += ghatLotDollarAmount[i];

					
				errLine = "389";
			}
			}
			else{

					pstmt_p.setString (17,"1");

					//calculations for the ghat entry
					ghatQtyTotal += ghat[i];

					ghatLotLocalAmount[i] =ghat[i] * efflocalrate[i];
					ghatLotDollarAmount[i] = ghat[i] * effrate[i];

					ghatReceiveLocalAmount += ghatLotLocalAmount[i];
					ghatReceiveDollarAmount += ghatLotDollarAmount[i];
			} 
			errLine = "401";
			int a245 = pstmt_p.executeUpdate();
			pstmt_p.close();
			out.print("<br> 355 Update data on receive_transaction.."+a245);
		}

	}//end if
errLine = "378";
	//END UPDATE RECEIVE_TRANSACTION....
int ghatCgtRTId[]=new int[newLotrows];
	//***INSERT DATA IN  RECEIVE_TRANSACTION FOR NEW LOTS..
	if(newLotrows != 0)
	{
	errLine = "414";	
		
		errLine = "416";
		for(i=tempcounter;i<lotRows;i++)
		{
			
			errLine = "419";
			int j=0;
				

				query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price, Local_Amount, Dollar_Amount, Pieces,Remarks , Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount, Modified_On, Modified_By, Modified_MachineName, Location_id, YearEnd_Id) values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?)";
				pstmt_p = conp.prepareStatement(query);
				pstmt_p.setInt (1,Receivetransaction_id1);	
//out.print("<br>Receivetransaction_id1"+Receivetransaction_id1);
				againstRT_Id[i]=""+Receivetransaction_id1;// To send next page
				pstmt_p.setInt(2,receive_id);
				pstmt_p.setInt(3,i);
				pstmt_p.setInt(4,lotid[i]);
				pstmt_p.setDouble(5,originalQty[i]);	
				pstmt_p.setDouble(6,qty[i]);	
				if("yes".equals(split[i]))
				{
					pstmt_p.setDouble(7,qty[i]);
				}
				else
				{
					pstmt_p.setDouble (7,0);
					directSave++;
				}
						
				if("Local".equals(currency))
					pstmt_p.setDouble(8,localrate[i]);	
				else
					pstmt_p.setDouble(8,rate[i]);	
				pstmt_p.setDouble (9,localrate[i]);	
				out.print("<br>localrate"+localrate[i]);
				pstmt_p.setDouble (10,efflocalrate[i]);	
				out.print("<br>efflocalrate"+efflocalrate[i]);
				pstmt_p.setDouble (11,rate[i]);	
				out.print("<br>rate"+rate[i]);
				pstmt_p.setDouble (12,effrate[i]);
				out.print("<br>effrate"+effrate[i]);
				pstmt_p.setDouble (13,Localamount[i]);		
				pstmt_p.setDouble (14,amount[i]);		
				pstmt_p.setInt (15,0);		
				pstmt_p.setString (16,""+remarks[i]);		
				pstmt_p.setDouble (17,returnQty[i]);
				if(!("0".equals(refReceive_Id)))
				{
					pstmt_p.setInt (18,0);
				}
				else
				{
					pstmt_p.setInt (18,0);
				}
				pstmt_p.setInt (19,0);
				pstmt_p.setString (20,""+lotDiscount[i]);
				pstmt_p.setString (21,""+D);
				pstmt_p.setString (22,""+user_id);
				pstmt_p.setString (23,""+machine_name);
				pstmt_p.setInt (24,location_id0);
				//pstmt_p.setString (25,""+rtid[i]);
				pstmt_p.setInt (25,yearend_id1);
				//pstmt_p.setString (27,""+ot_Id[i]+":"+new_Sale[i]);
	errLine = "477";
				int a245 = pstmt_p.executeUpdate();
				pstmt_p.close();

				//calculations for the ghat entry
			ghatQtyTotal += ghat[i];

			ghatLotLocalAmount[i] = ghat[i] * efflocalrate[i];
			ghatLotDollarAmount[i] = ghat[i] * effrate[i];

			ghatReceiveLocalAmount += ghatLotLocalAmount[i];
			ghatReceiveDollarAmount += ghatLotDollarAmount[i];
			ghatCgtRTId[j]=	Receivetransaction_id1;
			j++;
			Receivetransaction_id1 ++;
			out.print("<br> 431 Insert data On RT for new Lots.."+i+"uPADET "+a245);
		}//END..FOR
	}//END IF
	//*** End INSERT DATA ON RECEIVE_TRANSACTION FOR NEW LOTS..

	//UPDATE THE GHAT ENTRY IN RECEIVE...
	//VARIABLES FOR GHAT ENTRY...
		
		
				
		 query="update receive set Receive_Lots=?, Receive_Quantity=?, Receive_CurrencyId=?, Exchange_Rate=?, Receive_ExchangeRate=?, Receive_Total=?, Local_Total=?, Dollar_Total=?, Receive_FromId=?,Receive_FromName=?, Company_Id=?, Receive_ByName=?,Due_Date=?, Modified_On=?, Modified_By=?,Modified_MachineName=?,SalesPerson_Id=?,InvTotal=?, InvLocalTotal=?, InvDollarTotal=?, Receive_Category=?, YearEnd_Id=? where receive_id="+ghatReceive_id;
		 pstmt_p = conp.prepareStatement(query);
		 pstmt_p.setInt (1,templotrows);
		 pstmt_p.setDouble (2,ghatQtyTotal);
		if("Local".equals(currency))
			pstmt_p.setInt (3,local_currencyid);			
		else
			pstmt_p.setInt (3,0);
		pstmt_p.setDouble (4,exchange_rate);	
		pstmt_p.setDouble (5,exchange_rate);
		if("Local".equals(currency))
			pstmt_p.setDouble (6,ghatReceiveLocalAmount);	
		else
			pstmt_p.setDouble (6,ghatReceiveDollarAmount);	
		
		pstmt_p.setDouble (7, ghatReceiveLocalAmount);	
		pstmt_p.setDouble (8, ghatReceiveDollarAmount);
		pstmt_p.setInt (9, tempCompany_Id);
		pstmt_p.setString (10,""+ company_name);		
		pstmt_p.setInt (11,tempCompany_Id);	
		pstmt_p.setString (12,user_name);		
		pstmt_p.setString (13, ""+format.getDate(datevalue));	
		pstmt_p.setString (14, ""+D);	
		pstmt_p.setString (15, ""+user_id);	
		pstmt_p.setString (16, machine_name);	
		pstmt_p.setInt (17,purchaseperson_id);	
		//pstmt_p.setString (18,""+format.getDate(datevalue));	
		if("Local".equals(currency))
			pstmt_p.setDouble (18,ghatReceiveLocalAmount);	
		else
			pstmt_p.setDouble (18,ghatReceiveDollarAmount);	
		pstmt_p.setDouble (19, ghatReceiveLocalAmount);
		pstmt_p.setDouble (20, ghatReceiveDollarAmount);
		pstmt_p.setInt (21,category_id);
		pstmt_p.setInt (22,yearend_id1);
errLine = "507";
		int a807 = pstmt_p.executeUpdate();
errLine = "509";
		pstmt_p.close();
		out.print("<br> 510 Update ghatdata on receive.."+a807);
//END OF GHAT ENTTRY UPDATE IN RECEIVE

//UPDATE OF GHATDATA FOR EACH LOT IN THE RECEIVE_TRANSACTION
		if(tempcounter != 0)
		{
		for( i=0; i<tempcounter; i++)
		{
			
		
			query="update Receive_Transaction set Lot_Id=?, Original_Quantity=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, LocalEffective_Price=?, Dollar_Price=?, DollarEffective_Price=?, Local_Amount=?, Dollar_Amount=?, Remarks=? ,Lot_Discount=? , Modified_On=? , Modified_By=?, Modified_MachineName=?,Active=? where ReceiveTransaction_Id="+ghatReceiveTransaction_id[i];
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setInt(1,lotid[i]);
			pstmt_p.setDouble (2,ghat[i]);
			//out.print("<br> 533 ghat"+ghat[i]);
			pstmt_p.setDouble(3,ghat[i]);	
			pstmt_p.setDouble(4,ghat[i]);

			if("Local".equals(currency))
				pstmt_p.setDouble(5,localrate[i]);	
			else
				pstmt_p.setDouble(5,rate[i]);	
	
			pstmt_p.setDouble (6,localrate[i]);	
			pstmt_p.setDouble (7,efflocalrate[i]);	
			pstmt_p.setDouble (8,rate[i]);	
			pstmt_p.setDouble (9,effrate[i]);		
			pstmt_p.setDouble (10,ghatLotLocalAmount[i]);		
			pstmt_p.setDouble (11,ghatLotDollarAmount[i]);		
			pstmt_p.setString (12,""+ remarks[i]);		
			pstmt_p.setString (13,""+lotDiscount[i]);
			pstmt_p.setString (14,""+D);
			pstmt_p.setString (15,""+user_id);
			pstmt_p.setString (16,""+machine_name);
			if(lotRows > 1)
			{
				if(DelLots[i].equals("Delete"))
				{
					pstmt_p.setString (17,"0");
				}
				else{

					pstmt_p.setString (17,"1");
				}
			}else
			{
					pstmt_p.setString (17,"1");
			}
			errLine = "554";
			int a424 = pstmt_p.executeUpdate();
			pstmt_p.close();
			out.print("<br> 555 Update ghatdata on receive_transaction for old lot.."+i+"upadte"+a424);
		} 
	}
//** END OF GHAT UPDATE RECEIVE_TRANSACTION..
//**INSERT GHATDATA FOR EACH NEW LOT IN RECEIVE_TRANSACTION
	if(newLotrows != 0)
	{
		
		for(i=tempcounter;i<lotRows;i++)
		{
			int j=0;
				
				query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price, Local_Amount, Dollar_Amount, Pieces,Remarks , Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount, Modified_On, Modified_By, Modified_MachineName, Location_id, Consignment_ReceiveId, YearEnd_Id, ST_RTId ) values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )";

				pstmt_p = conp.prepareStatement(query);

				pstmt_p.setInt (1,Receivetransaction_id1);
				out.print("<br> Receivetransaction_id1"+Receivetransaction_id1);
				pstmt_p.setInt (2,ghatReceive_id);
//out.print("<br>ghatReceive_id"+ghatReceive_id);
				pstmt_p.setString (3,""+i);
				pstmt_p.setInt(4,lotid[i]);
				pstmt_p.setDouble (5,ghat[i]);	
				pstmt_p.setDouble (6,ghat[i]);	
				pstmt_p.setDouble (7,ghat[i]);
				if("Local".equals(currency))
					pstmt_p.setDouble(8,localrate[i]);	
				else
					pstmt_p.setDouble(8,rate[i]);	
	
				pstmt_p.setDouble (9,localrate[i]);	
				
				pstmt_p.setDouble (10,efflocalrate[i]);	
					
				pstmt_p.setDouble (11,rate[i]);	
				
				pstmt_p.setDouble (12,effrate[i]);		
				
				pstmt_p.setDouble (13,ghatLotLocalAmount[i]);		
				
				pstmt_p.setDouble (14,ghatLotDollarAmount[i]);		
				
				pstmt_p.setString (15,"0");		
				pstmt_p.setString (16,"");		
				pstmt_p.setString (17,"0");
				pstmt_p.setString (18,"0");
				pstmt_p.setString (19,"0");
				pstmt_p.setString (20,"");
				pstmt_p.setString (21,""+D);
				
				pstmt_p.setString (22,""+user_id);
					
				pstmt_p.setString (23,""+machine_name);
					
				pstmt_p.setInt (24,location_id0);
				
				pstmt_p.setString (25,""+ghatCgtRTId[j]);
				
				pstmt_p.setInt (26,yearend_id1);
		errLine = "702";		
				pstmt_p.setString (27,"0");
		errLine = "704";
				int a873 = pstmt_p.executeUpdate();

				pstmt_p.close();
		errLine = "645";
				Receivetransaction_id1++;
				j++;
				out.print("<br> 535 insert ghat  data On RT for new Lots.."+i+"uPADTE ->"+a873);

		}
	}
// ** END OF INSERT NEW GHATDATA IN RECEIV_TRANSACTION
// UPDATE DATA INTO THE VOUCHER TABLE..
		query="update  Voucher set Voucher_Currency=?,Exchange_Rate=?,Voucher_Total=?, Local_Total=?, Dollar_Total=? ,Description=?, Modified_By=?, Modified_On=?, Modified_MachineName=?,YearEnd_Id=?,ref_no=? where voucher_no='"+receive_id+"'";
		
		pstmt_p = conp.prepareStatement(query);

		if("Local".equals(currency))
			pstmt_p.setString (1,"1");	
		else
			pstmt_p.setString (1,"0");	
		pstmt_p.setDouble (2,exchange_rate);
		if("Local".equals(currency))
			pstmt_p.setDouble (3,localamountTotal);
		else
			pstmt_p.setDouble (3,amountTotal);
		pstmt_p.setDouble (4,localamountTotal);
		pstmt_p.setDouble (5,amountTotal);
		pstmt_p.setString (6,narration);
		pstmt_p.setString (7,user_id);	
		pstmt_p.setString (8,""+D);
		pstmt_p.setString (9,machine_name);	
		pstmt_p.setInt (10,yearend_id1);
		pstmt_p.setString (11,""+ref_no);
errLine = "643";

		int a691 = pstmt_p.executeUpdate();

		pstmt_p.close();
// END OF UPDATE VOUCHER TABLE

//UPDATE GHATDATA INTO THE VOUCHER TABLE
		query="update  Voucher set Voucher_Currency=? , Exchange_Rate=? , Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On=?, Modified_MachineName=?,YearEnd_Id=? where voucher_no='"+ghatReceive_id+"'";
		pstmt_p = conp.prepareStatement(query);

		if("Local".equals(currency))
			pstmt_p.setString (1, "1");	
		else
			pstmt_p.setString (1, "0");	
		pstmt_p.setDouble (2,exchange_rate);
		if("Local".equals(currency))
			pstmt_p.setString (3, ""+ghatReceiveLocalAmount);	
		else
			pstmt_p.setString (3, ""+ghatReceiveDollarAmount);	
		
		pstmt_p.setString (4, ""+ghatReceiveLocalAmount);	
		pstmt_p.setString (5, ""+ghatReceiveDollarAmount);
		pstmt_p.setString (6,narration);
		pstmt_p.setString (7,user_id);	
		pstmt_p.setString (8,""+D);
		pstmt_p.setString (9,machine_name);	
		pstmt_p.setInt (10,yearend_id1);
		
errLine = "726";
		int ra691 = pstmt_p.executeUpdate();
		pstmt_p.close();
		out.print("<br> 591 update..Voucher .."+ra691);
// END OF UPDATE GHATDATA IN VOUCHER 
// UPDATE FINANCIAL_TRANSACTION FOR EACH OLD LEDGER..
	 i=0;
		if (tempOldLedgercounter != 0)
		{
			for( i=0;i<tempOldLedgercounter;i++)
			{
				query="update financial_transaction set For_Head=?, For_HeadId=? ,Transaction_Type=? , Amount=? , Local_Amount=? , Dollar_Amount=? , Modified_On=? , Modified_By=? , Modified_MachineName=?, Ledger_Id=?, Active=?, ReceiveFrom_LedgerId=?,Exchange_Rate=? , YearEnd_Id=? , Cheque_No=? where for_HeadId != 13 and Tranasaction_Id="+Transaction_Id[i];
				pstmt_p = conp.prepareStatement(query);
				
				pstmt_p.setInt(1,for_head[i]);
				pstmt_p.setInt(2,forhead_id[i]);
			
				if("1".equals(debitcredit[i]))
					pstmt_p.setString(3,"1");
				else
					pstmt_p.setString(3,"0");
				if("Local".equals(currency))
					pstmt_p.setString (4, ""+ledgerLocalAmount[i]);	
				else
					pstmt_p.setString (4, ""+ledgerAmount[i]);	
					out.print("<br> ledgerLocalAmount"+ledgerLocalAmount[i]);
				pstmt_p.setString(5, ""+ledgerLocalAmount[i]);
				pstmt_p.setString(6, ""+ledgerAmount[i]);
				pstmt_p.setString(7,""+D);
				pstmt_p.setString(8,""+user_id);
				pstmt_p.setString(9,""+machine_name);
				pstmt_p.setString(10,""+ledger[i]);
				if(ledgerPercent[i]== 0.0 || DelLedger.equals("Delete"))
				{
					pstmt_p.setString(11,"0");
				}
				else
					{pstmt_p.setString(11,"1");
					}
				pstmt_p.setInt(12,ReceiveFrom_LedgerId);
				pstmt_p.setDouble(13,exchange_rate);
				pstmt_p.setInt (14,yearend_id1);
				pstmt_p.setDouble(15,ledgerPercent[i]); 
	errLine = "768";
				int a525 = pstmt_p.executeUpdate();
				pstmt_p.close();

				out.print("<br> update FT.. for old ledger..");
			}

		}
// END OF FINANCIAL_TRANSACTION UPDATE FOR EACH OLD LEDGER
//INSERT DATA OF NEW LEDGER IN FINANCIAL_TRANSACTION..
errLine = "778";
		if(newLedgerRows != 0)
		{
			
errLine = "793";
			for(i=tempOldLedgercounter;i<oldLedgerRows;i++)
			{
				if(ledgerPercent[i] == 0.0)
				{
				}
				else
				{
				query="insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_Id, Sr_No, For_Head, For_HeadId, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_On, Modified_By, Modified_MachineName, Ledger_Id, Transaction_Date, Tranasaction_No, Receive_Id, ReceiveFrom_LedgerId, Exchange_Rate, YearEnd_Id, Cheque_No) values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)";
				pstmt_p = conp.prepareStatement(query);
				pstmt_p.setString(1,""+transaction_id);
				pstmt_p.setInt(2,tempCompany_Id);
				pstmt_p.setString(3,""+testvoucher_id);
				pstmt_p.setString(4,""+(i+1));
errLine = "582";
				pstmt_p.setInt(5,for_head[i]);
errLine = "806";
				
				pstmt_p.setInt(6,forhead_id[i]);
				
				if("1".equals(debitcredit[i]))
					pstmt_p.setString(7,"1");
				else
					pstmt_p.setString(7,"0");
				if("Local".equals(currency))
					pstmt_p.setString (8, ""+ledgerLocalAmount[i]);	
				else
					pstmt_p.setString (8, ""+ledgerAmount[i]);	
errLine = "818";
				pstmt_p.setString(9, ""+ledgerLocalAmount[i]);
				pstmt_p.setString(10, ""+ledgerAmount[i]);
				pstmt_p.setString(11,""+D);
				pstmt_p.setString(12,""+user_id);
				pstmt_p.setString(13,""+machine_name);
				pstmt_p.setString(14,""+ledger[i]);
				pstmt_p.setString(15,""+format.getDate(datevalue));
				pstmt_p.setString(16,""+purchase_no);
				pstmt_p.setInt(17,receive_id);
				
	errLine = "829";
				pstmt_p.setInt(18,ReceiveFrom_LedgerId);
				pstmt_p.setDouble(19,exchange_rate);
	errLine = "832";
				pstmt_p.setInt (20,yearend_id1);
				pstmt_p.setDouble (21,ledgerPercent[i]);
	errLine = "835";
				int a525 = pstmt_p.executeUpdate();
				pstmt_p.close();
	errLine = "838";
				transaction_id++;
	errLine = "840";
				out.print("<br> Insert new Ledger in FT"+i);
				}
			}//end of for

		}
//END OF INSERT DATA..FOR NEW LEDHER IN FT..
	conp.commit();
	}//if

C.returnConnection(cong);
C.returnConnection(conp);
response.sendRedirect("../Master/NewEditSaleForm1.jsp?command=sedit&receive_id="+receive_id+"&Iv_id=0&Fv_id=0&message=save&Receive_no="+purchase_no);
}//try
catch(Exception e)
{
	conp.rollback();
	
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("<br> ErrorLine"+errLine+" :"+e);
}%>