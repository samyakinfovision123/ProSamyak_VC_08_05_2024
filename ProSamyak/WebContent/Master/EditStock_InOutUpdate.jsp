<!--  	Created By:- Dattatraya Gade
		File:- ConsignmentCompareUpdate.jsp
		Date:- 09/03/2006                          -->


<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" isThreadSafe="false"%>

<jsp:useBean id="L"   class="NipponBean.login"/>
<jsp:useBean id="A"   class="NipponBean.Array"/>
<jsp:useBean id="C" scope="application" class="NipponBean.Connect"/>
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<jsp:useBean id="F" class="NipponBean.format" />



<% String errLine="15";

	Connection conp= null;
	Connection cong= null;
			
	try{

		ResultSet rs_p= null;
		ResultSet rs_g= null;

		PreparedStatement pstmt_p= null;
		PreparedStatement pstmt_g= null;
		
		cong= C.getConnection();	
		conp= C.getConnection();
		
	errLine= "30";
	String user_id= ""+session.getValue("user_id");

	String user_name= A.getName(cong,"User",user_id);
	//out.print("<br>32 user_name="+user_name);
	

	String user_level= ""+session.getValue("user_level");
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	String machine_name= request.getRemoteHost();
	//String company_name= A.getName(conp,"companyparty",company_id);
	String logincompany_name= A.getName(cong,"companyparty",company_id);
	
	String loginLocation_id= A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id);

	//String loginparty_id= A.getNameCondition(conp,"Master_CompanyParty", "CompanyParty_Id","where CompanyParty_Name='"+logincompany_name+"' and Company_Id="+company_id+" and Active=1");
	String local_currency=I.getLocalCurrency(cong,company_id);
	int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

	java.sql.Date D= new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	String command= request.getParameter("command");
	//out.print("<br>65 command="+command);
	String party_id=  request.getParameter("party_id");
	//String location_id0= request.getParameter("location_id0");
		
	errLine="67";
//============================================================
	

	if(command.equals("Update"))
	{
	
	String sreceive_Id=request.getParameter("sreceive_Id");
	String dreceive_Id=request.getParameter("dreceive_Id");
	String StockTransfer_Type=request.getParameter("StockTransfer_Type");
	String message=request.getParameter("message");
	String lotno=""+request.getParameter("lotno");
	String cgtNo=""+request.getParameter("cgtNo");
	String currency=""+request.getParameter("currency");	
	//out.print("<br>102 currency="+currency);

	//int daddlots=Integer.parseInt(request.getParameter("daddlots"));
	//int saddlots=Integer.parseInt(request.getParameter("saddlots"));
	
	int sold_lots=Integer.parseInt(request.getParameter("sold_lots"));
	int dold_lots=Integer.parseInt(request.getParameter("dold_lots"));
	int Tempsold_lots=Integer.parseInt(request.getParameter("Tempsold_lots"));
	int Tempdold_lots=Integer.parseInt(request.getParameter("Tempdold_lots"));
	
	//int scounter=sold_lots+saddlots;
	//int dcounter=dold_lots+daddlots;
	String againstRec_Id=""+request.getParameter("againstRec_Id");	
	String strRT_Id=""+request.getParameter("strRT_Id");	
	
	int scounter=Integer.parseInt(request.getParameter("scounter"));
	int dcounter=Integer.parseInt(request.getParameter("dcounter"));
	int scount= scounter;
    //out.print("<br>97 scounter="+scounter);
	errLine="100";
	String stocktransfer_no=request.getParameter("stocktransfer_no");
	String ref_no=request.getParameter("ref_no");
	String datevalue=request.getParameter("datevalue");
	//String stockdate=request.getParameter("stockdate");
	String currency_id="";
	//String consignment_no=request.getParameter("consignment_no");
	//String ref_no=request.getParameter("ref_no");
	
	errLine="109";
	String companyparty_name=request.getParameter("companyparty_name");
	companyparty_name="Abc Diamonds";
	//String companyparty_id=request.getParameter("companyparty_id");
	//String companyparty_id= A.getNameCondition(cong,"Master_CompanyParty","CompanyParty_id","where CompanyParty_Name="+companyparty_name+" and Active=1 and company_id="+company_id);
	String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
	purchasesalegroup_id="1";
	//String datevalue=request.getParameter("datevalue");
	
	String duedays=request.getParameter("duedays");
	duedays="1";
	String duedate=request.getParameter("duedate");
	duedate=datevalue;
	errLine="122";
	String category_id=request.getParameter("category_id");
	category_id="1";
	errLine="125";
	double exchange_rate=0;
	exchange_rate= Double.parseDouble(request.getParameter("exchange_rate"));
	//out.print("<br>136 exchange_rate="+exchange_rate);
	errLine="129";
	String purchaseperson_id=request.getParameter("purchaseperson_id");
	purchaseperson_id="1";
	errLine="170";
	//out.print("<br>137 purchaseperson_id="+purchaseperson_id);
	String broker_id=request.getParameter("broker_id");
	broker_id="1";
	String broker_remarks=request.getParameter("broker_remarks");
	broker_remarks="1+1";
	errLine="138";
	String Ref_Company_Description ="1+1";
	//java.sql.Date TD=format.getDate(datevalue);
	//java.sql.Date SD=format.getDate(stockdate);
	//String exchange_rate=request.getParameter("exchange_rate");
	String description=""+request.getParameter("description");
	errLine="144";
	String rowNo[]=new String[scounter];
	String againstRT_Id[]=new String[scounter];
	String slotno[]=new String[scounter];
	String slotid[]=new String[scounter];
	String sdescriptionname[]=new String[scounter];
	String ssizename[]=new String[scounter];
	double sRT_Id[]=new double[scounter];

	double sqty[]=new double[scounter];
	double spendingqty[]=new double[scounter];
	double savailQty[]=new double[scounter];
	double srate[]=new double[scounter]; 
	double samount[]=new double[scounter];
	double slocalrate[]=new double[scounter];
	double slocalamount[]=new double[scounter];
	
	String sremark[]=new String[scounter];
	String slocation_id[]=new String[scounter];
	String from_location[]=new String[scounter];
	String slocation_idCombo[]=new String[scounter];
	String sRec_Price[]=new String[scounter];
	
	
	for(int i=0;i<scounter;i++)
		{
		

		rowNo[i]=request.getParameter("rowNo"+i);
		againstRT_Id[i]=request.getParameter("againstRT_Id"+i);
		slotno[i]=request.getParameter("slotno"+i);

		slotid[i]=request.getParameter("slotid"+i);
		//out.print("<br>218 slotid[i]="+slotid[i]);
		from_location[i]=request.getParameter("from_location"+i);
		sdescriptionname[i]=request.getParameter("sdescriptionname"+i);
		ssizename[i]=request.getParameter("ssizename"+i);
		errLine="179";
		sRT_Id[i]=Double.parseDouble(request.getParameter("sReceiveTransaction_Id"+i));
		//out.print("<br>225 sRT_Id[i]="+sRT_Id[i]);
		errLine="182";
		sqty[i]=Double.parseDouble(request.getParameter("sqty"+i));
		spendingqty[i]=Double.parseDouble(request.getParameter("spendingqty"+i));
		
		//savailQty[i]=(soriginalQty[i]-sqty[i]);
		srate[i]=Double.parseDouble(request.getParameter("srate"+i));
		samount[i]=Double.parseDouble(request.getParameter("samount"+i));
		slocalrate[i]=Double.parseDouble(request.getParameter("slocalrate"+i));
		slocalamount[i]=Double.parseDouble(request.getParameter("slocalamount"+i));
	
		sremark[i]=request.getParameter("sremark"+i);	
			
		//slocation_id[i]=request.getParameter("slocation_id"+i);
		slocation_id[i]=loginLocation_id;
		slocation_idCombo[i]=request.getParameter("slocation_idCombo"+i);
	}// end of scounter

	double stotalqty= Double.parseDouble(request.getParameter("stotalqty"));
	
	double stotalamount= Double.parseDouble(request.getParameter("stotalamount"));
	double slocaltotalamount= Double.parseDouble(request.getParameter("slocaltotalamount"));

	errLine="204";
	String dlotno[]=new String[dcounter];
	String dlotid[]=new String[dcounter];
	String ddescriptionname[]=new String[dcounter];
	String dsizename[]=new String[dcounter];
	double dRT_Id[]=new double[dcounter];

	double dqty[]=new double[dcounter];

	double drate[]=new double[dcounter];
	double damount[]=new double[dcounter];
	double dlocalrate[]=new double[dcounter];
	double dlocalamount[]=new double[dcounter];
	
	String dremark[]=new String[dcounter];
	String dlocation_id[]=new String[dcounter];

	String dlocation_idCombo[]=new String[dcounter];
	String to_location[]=new String[dcounter];
	for(int i=0;i<dcounter;i++)
	{						
		dlotno[i]=request.getParameter("dlotno"+i);

		dlotid[i]=request.getParameter("dlotid"+i);		
		//out.print("<br>284 dlotid[i]="+dlotid[i]);
		ddescriptionname[i]=request.getParameter("ddescriptionname"+i);
		dsizename[i]=request.getParameter("dsizename"+i);
		to_location[i]=request.getParameter("to_location"+i);
		dqty[i]=Double.parseDouble(request.getParameter("dqty"+i));
		dRT_Id[i]=Double.parseDouble(request.getParameter("dReceiveTransaction_Id"+i));
		drate[i]=Double.parseDouble(request.getParameter("drate"+i));
		damount[i]= Double.parseDouble(request.getParameter("damount"+i));

		double dlocrate=0;
		dlocrate=((drate[i])*exchange_rate);
		dlocalrate[i]=dlocrate;
		dlocalamount[i]=Double.parseDouble(request.getParameter("dlocalamount"+i));
	
		dremark[i]=request.getParameter("dremark"+i);
		//dlocation_id[i]=request.getParameter("dlocation_id"+i);
		dlocation_id[i]=loginLocation_id;
		dlocation_idCombo[i]=request.getParameter("dlocation_idCombo"+i);
	
	  }// end of dcounter

	double dtotalqty= Double.parseDouble(request.getParameter("dtotalqty"));
	double dtotalamount= Double.parseDouble(request.getParameter("dtotalamount"));
	double dlocaltotalamount= Double.parseDouble(request.getParameter("dlocaltotalamount"));
	
	errLine="253";
  	double Rec_Total=0;
    double total_amount=0;
    double totalLocalamt=0; 
    double totalDollaramt=0;
		
	boolean voucher_currency=false;
	String voucher_currency1= "";
		
	if("local".equals(currency))
		{
		voucher_currency=true;
		voucher_currency1="1";
		currency_id=local_currency;
		Rec_Total=slocaltotalamount;
		totalLocalamt= str.mathformat(slocaltotalamount,d);
		
		totalDollaramt=str.mathformat(stotalamount, 2);
		} 

		if("dollar".equals(currency))
		{
		voucher_currency=false;
		voucher_currency1="0";
		currency_id="0";
		Rec_Total=stotalamount;
		totalDollaramt= str.mathformat(stotalamount,2);		
	    totalLocalamt=str.mathformat(slocaltotalamount,d);
		}


		String query="select count(*) as receive_no from Receive where Receive_No = '"+stocktransfer_no+"' and (Receive_Id ="+sreceive_Id+" and Receive_Id = "+ dreceive_Id +") and company_id="+company_id;

		//out.print("<BR>323 query="+query);
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		errLine="346";
		int stkTranfcount=0;
		while(rs_g.next())
		{
			String receive_no=rs_g.getString("Receive_No");
			if(receive_no.equals(stocktransfer_no))
			{
				stkTranfcount++;
			}
		}
		pstmt_g.close();

		if(stkTranfcount>0)
		{	
		   stocktransfer_no=Voucher.getAutoNumber(cong,3,voucher_currency1,company_id);
				
		}// end of if stkTranfcount

	errLine="307";

	/*###############################################################

					  "Receive Table" for Sale  Source

    ###############################################################*/
	

	//int Receive_Id= L.get_master_id(cong,"Receive");
	//System.out.println("<br>355 Receive_Id"+Receive_Id);
	String remar="";
	conp.setAutoCommit(false);
	
	errLine="385";
	 query="Update Receive set Receive_Sell=?, Receive_No=?, Receive_Date=?, Receive_Lots=?, Receive_Quantity=?, Receive_CurrencyId=?, Exchange_Rate=?, Receive_ExchangeRate=?, Tax=?, Discount=?, Receive_Total=?, Local_Total=?, Dollar_Total=?, Receive_FromId=?, Receive_FromName=?, Company_Id=?, Receive_ByName=?, Receive_Internal=?, Purchase=?, Due_Days=?, Due_Date=?, Remarks=?, SalesPerson_Id=?, Consignment_ReceiveId=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Active=?, ProActive=?, R_Return=?, Stock_Date=?, InvTotal=?, InvLocalTotal=?, InvDollarTotal=?, Receive_Category=?, StockTransfer_Type=?, YearEnd_Id=?, PurchaseSaleGroup_Id=?, CgtRef_No=?,CgtDescription=?, Broker_Id=?, Broker_Formula=? where Receive_Id=?";
	//out.print("<br>325 query=>"+query);
	pstmt_p = conp.prepareStatement(query);
	errLine="389";
	pstmt_p.setBoolean (1,false);//Receive_Sell
	pstmt_p.setString (2,""+stocktransfer_no);//Receive_No, 
	pstmt_p.setString (3,""+F.getDate(datevalue));//Receive_Date, 
	pstmt_p.setString (4,""+scounter);//Receive_Lots, 
	pstmt_p.setString (5,""+stotalqty);//Receive_Quantity, 
	errLine="396";
	//out.println("<br> 387 stotalqty="+stotalqty);
	pstmt_p.setString (6,""+currency_id);//Receive_CurrencyId
	pstmt_p.setString (7,""+exchange_rate);//Exchange_Rate
	pstmt_p.setString (8,""+exchange_rate);//Receive_ExchangeRate
	pstmt_p.setString (9,"0");//Tax
	pstmt_p.setString (10,"0");//Discount
	pstmt_p.setDouble (11,Rec_Total);//Receive_Total 
	pstmt_p.setDouble (12,totalLocalamt);//Local_Total
	pstmt_p.setDouble (13,totalDollaramt);//Dollar_Total
	pstmt_p.setString (14,""+company_id);
	errLine="342";
	//Receive_FromId=companyparty_id
	pstmt_p.setString (15,""+logincompany_name);
	//Receive_FromName=companyparty_name
	//out.println("<br> 387 logincompany_name="+logincompany_name);
	pstmt_p.setString (16,""+company_id);//Company_Id
	pstmt_p.setString (17,"0");//Receive_ByName
	pstmt_p.setBoolean (18,true);//Receive_Internal
	pstmt_p.setBoolean (19,true);//Purchase
	pstmt_p.setString (20,""+duedays);//Due_Days  duedate category_id
	pstmt_p.setString (21,""+F.getDate(duedate));//Due_Date
	pstmt_p.setString (22,""+remar);//Remarks
	pstmt_p.setString (23,""+purchaseperson_id);//SalesPerson_Id
	pstmt_p.setString (24,"0");//Consignment_ReceiveId
	pstmt_p.setString (25,""+D);//Modified_On
	pstmt_p.setString (26,""+user_id);//Modified_By
	pstmt_p.setString (27,""+machine_name);//Modified_MachineName
	pstmt_p.setBoolean (28,true);//Active
	pstmt_p.setBoolean (29,true);//ProActive
	pstmt_p.setBoolean (30,false);//R_Return
	pstmt_p.setString (31,""+F.getDate(datevalue));
	pstmt_p.setDouble (32,Rec_Total);//InvTotal
	pstmt_p.setDouble (33,totalLocalamt);//InvLocalTotal
	pstmt_p.setDouble (34,totalDollaramt);//InvDollarTotal
	
	errLine="367";
	pstmt_p.setString (35,""+category_id);//Receive_Category
	pstmt_p.setString (36,"4");//StockTransfer_Type
	pstmt_p.setString (37,""+yearend_id);//YearEnd_Id
	pstmt_p.setString (38,""+purchasesalegroup_id);//PurchaseSaleGroup_Id 												
	pstmt_p.setString (39,""+ref_no);//CgtRef_No
	pstmt_p.setString (40,""+description);//CgtDescription
	pstmt_p.setString (41,""+broker_id);//Broker_Id
	pstmt_p.setString (42,""+broker_remarks);//Broker_Formula
	errLine="376";
	pstmt_p.setString (43,""+sreceive_Id);
	errLine="378";
	int a274 = pstmt_p.executeUpdate();  
	//System.out.println("<br>218 Data updated in Receive a274=>"+a274);
	pstmt_p.close();
	
	errLine="383";
	
	/*############################################################

				 " Voucher Table" for sale  Source

	#############################################################*/

	//out.print("<bR>424 **************Voucher Table Insertion  strart*****");
	int testvoucher_id=L.get_master_id(cong,"Voucher");
	//System.out.println("441 ********************Inside Voucher ");

	String voucher_type= "3"; 
	// (Purchase) See voucher Table Design 
	String inSaleVoucherQuery="Update Voucher set Company_Id=?, Voucher_Type=?, Voucher_Date='"+F.getDate(datevalue)+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?,YearEnd_Id=?,Ref_No=? where Voucher_No=?";
	//out.print("<br>query6=" +query);
	pstmt_p = conp.prepareStatement(inSaleVoucherQuery);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,voucher_type);		
	//out.print("<br>486 Voucher_No="+Receive_id_new);
	pstmt_p.setString (3,"0");
	pstmt_p.setBoolean(4,voucher_currency);
	pstmt_p.setString (5,""+exchange_rate);
	pstmt_p.setDouble (6,Rec_Total);
	pstmt_p.setDouble (7,totalLocalamt);
	pstmt_p.setDouble (8,totalDollaramt);
	pstmt_p.setString (9,description);
	pstmt_p.setString (10,user_id);	
	pstmt_p.setString (11,machine_name);
	pstmt_p.setString (12,yearend_id);
	pstmt_p.setString (13,ref_no);
	pstmt_p.setString (14,sreceive_Id);
	
	int a691 = pstmt_p.executeUpdate();
	 //System.out.println("<br>452************<font color=red> Update Voucher</font>"+a691);
	pstmt_p.close();

	errLine="420";
	
	/*############################################################

					  "Receive_Transaction" for Sale =Source

    ############################################################*/

	//int Receivetransaction_id= L.get_master_id("Receive_Transaction");
	int Receivetransaction_id= L.get_master_id(cong,"Receive_Transaction");
	//System.out.println("432 **Receivetransaction_id ="+Receivetransaction_id);
	int LotLocation_id=L.get_master_id(cong,"LotLocation");
	//out.print("<br>480************<font color=red>LotLocation_id</font>"+LotLocation_id);
	//String query1="Select RreceiveTransaction_id fron Receive_Transaction where Receive_Id="
	
	String local_rate[]=new String[scounter];
	String localEff_rate[]=new String[scounter];
	String dollar_rate[]=new String[scounter];
	String dollarEff_rate[]=new String[scounter];
	String local_amount[]=new String[scounter];
	String dollar_amount[]=new String[scounter];
	String Rec_Price[]=new String[scounter];
	
	int temp_lot_loc_id=0;
	temp_lot_loc_id=L.get_master_id(conp,"LotLocation");
	for(int i=0; i<Tempsold_lots; i++)//counter= no of Rows
	{
		voucher_currency= false;
	

		double local_total= 0;
		double dollar_total= 0;

		
		if ("dollar".equals(currency))
		{
		voucher_currency=false;
		currency_id="0";
			
		dollar_amount[i]=str.mathformat(""+samount[i],2);
		local_amount[i]=str.mathformat(""+slocalamount[i],2);
		 
		dollar_rate[i]=""+srate[i];
		dollarEff_rate[i]=""+srate[i];
		local_rate[i]=str.mathformat(""+slocalrate[i],2);
		localEff_rate[i]=str.mathformat(""+slocalrate[i],2);

		Rec_Price[i]= ""+srate[i];	
		
		
		}//if
		else
		{   //for "local"
		voucher_currency=true;
		currency_id=local_currency;
			
		local_amount[i]=str.mathformat(""+slocalamount[i],d);
		dollar_amount[i]=str.mathformat(""+samount[i],d);
		  
		local_rate[i]=""+slocalrate[i];
		localEff_rate[i]=""+slocalrate[i];
		dollar_rate[i]=str.mathformat(""+srate[i],2);
		dollarEff_rate[i]=str.mathformat(""+srate[i],2);

		Rec_Price[i]= ""+slocalrate[i];	
			
		}//else

	errLine="605";
	//Receivetransaction_id += i;
	//out.print("<br>619 sRT_Id["+i+"]="+sRT_Id[i]);
	query="Update Receive_Transaction set Receive_Id=?, Lot_SrNo=?, Lot_Id=?, Original_Quantity=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, LocalEffective_Price=?, Dollar_Price=?, DollarEffective_Price=?,	Local_Amount=?, Dollar_Amount=?, Pieces=?, Remarks=?, Return_Quantity=?, Rejection_Percent=?, Rejection_Quantity=?, Lot_Discount=?, Ref_Company_Description=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?,  Location_id=?, Active=?, Consignment_ReceiveId=?, YearEnd_Id=?, ST_RTId=? where ReceiveTransaction_Id=?";

	pstmt_p = conp.prepareStatement(query);
	//out.println("<br>fine till 605="+query);
	pstmt_p.setString (1,""+sreceive_Id);	
	pstmt_p.setString (2,""+i);
	pstmt_p.setString (3,""+slotid[i]);
	pstmt_p.setString (4,""+sqty[i]);//original	
    pstmt_p.setString (5,""+sqty[i]);//quantity
	pstmt_p.setString (6,""+sqty[i]);//Avail quantity
	pstmt_p.setString (7, ""+Rec_Price[i]);//Receive_Price
	pstmt_p.setString (8,""+local_rate[i]);	
	pstmt_p.setString (9,""+local_rate[i]);//localEff_rate	
	pstmt_p.setString (10,""+dollar_rate[i]);	
	pstmt_p.setString (11,""+dollar_rate[i]);//dollarEff_rate

	pstmt_p.setString (12,""+local_amount[i]);//Local_Amount
	pstmt_p.setString (13,""+dollar_amount[i]);//dollar_Amount
	pstmt_p.setString (14, "0");	//Pecies
	pstmt_p.setString (15,""+sremark[i]);	
	     
	pstmt_p.setString (16,"0");//	Return_Quantity	
	pstmt_p.setString (17,"0");//Rejection_Percent
	pstmt_p.setString (18,"0");//Rejection_Quantity
	pstmt_p.setString (19,"0");//Lot_Discount
	pstmt_p.setString (20, Ref_Company_Description); 			

	pstmt_p.setString (21,""+user_id);		
	pstmt_p.setString (22,""+machine_name);		
	//pstmt_p.setString (24,""+slocation_id[i]);		
	pstmt_p.setString (23,""+loginLocation_id);
	pstmt_p.setBoolean (24, true);		
	pstmt_p.setString (25,"0");//Consignment_ReceiveId		
	pstmt_p.setString (26,""+yearend_id);//yearend_id		
	pstmt_p.setString (27,"0");//ST_RTId		
	pstmt_p.setDouble (28,sRT_Id[i]);//ST_RTId		
	errLine="528";

	int a593 = pstmt_p.executeUpdate();
	//System.out.println("<br>593 Data updated in Receive_Transaction"+a593);
	errLine="531";

	pstmt_p.close();
	//out.println("<br> *** After Before Query 271<br>");
	errLine="535";

	/*############################################################

		   "Receive_Transaction" update for Sale =Source

    ############################################################*/
	//out.println("627 ***********Inside Receive_Transaction Select and update*************");

	/*String selAvailQtyQry="select Available_Quantity from Receive_Transaction where ReceiveTransaction_Id=0";//+againstRT_Id[i];

	pstmt_g= cong.prepareStatement(selAvailQtyQry);
	rs_g= pstmt_g.executeQuery();
	
	double availQuantity=0;
	while(rs_g.next())
	{
		availQuantity=rs_g.getDouble("Available_Quantity");
	}
	pstmt_g.close();
	
	availQuantity =(availQuantity - sqty[i]);

	String updateAvailAQtyQry="update Receive_Transaction set Available_Quantity=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where ReceiveTransaction_Id=?";
	
	pstmt_p= conp.prepareStatement(updateAvailAQtyQry);

	pstmt_p.setString (1,""+availQuantity);
	out.println("<br>635 *********savailQty="+savailQty[i]);	
	pstmt_p.setString (2,""+user_id);		
	pstmt_p.setString (3,""+machine_name);
	pstmt_p.setString (4,""+againstRT_Id[i]);

	int a649= pstmt_p.executeUpdate();
	out.print("<br>650 Data updated in Receive_Transaction"+a649);
	//out.println("<br>Data Successfully updated in RT table <br>");
	pstmt_p.close();

*/

	/*############################################################

					  "Lot Location" for Sale =Source

    ############################################################*/
	//System.out.println("657 ***********Inside Lot Location ");
	
	int level = cong.getTransactionIsolation();
	cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

	query="Select Carats, Available_Carats from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
	//out.print("<br>query" +query);
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,slotid[i]); 
	//System.out.println("<br>665 slotid="+slotid[i]);	
	pstmt_g.setString(2,slocation_id[i]); 
	//System.out.println("<br>667 slocation_id="+slocation_id[i]);	

	pstmt_g.setString(3,company_id);
	//System.out.println("<br>670 company_id="+company_id);	

	rs_g = pstmt_g.executeQuery();
	double fincarats=0;
	double phycarats=0;
	int p=0;

		while(rs_g.next()) 	
		{
		fincarats= rs_g.getDouble("Carats");	
		phycarats= rs_g.getDouble("Available_Carats");	
		p++;
		}
		pstmt_g.close();
		cong.setTransactionIsolation(level);

		phycarats = (phycarats - sqty[i]);
	

	if(p>0)
	   {
		//System.out.println("617 ***********Inside Lot Location Update");

		query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
		//out.print("<br>query" +query);
		pstmt_p = conp.prepareStatement(query);
		//pstmt_p.setString(1,"0"); 
		pstmt_p.setString(1,""+fincarats);
		pstmt_p.setString(2,""+phycarats);
		pstmt_p.setString (3,""+user_id);		
		pstmt_p.setString (4,""+machine_name);
		pstmt_p.setString(5,""+slotid[i]); 
		pstmt_p.setString(6,""+loginLocation_id); 
		pstmt_p.setString(7,""+company_id); 
		
		int a643 = pstmt_p.executeUpdate();
		//out.print("<br>643Data updated in Lotlocation"+a643);
		//System.out.println(" 633 <br>Data Successfully updated in lot table <br>");
		pstmt_p.close();
			
	   }
	else{
		//System.out.println("672***********Inside Lot Location Insert");

		//out.print("<br>666 LotLocation_id="+LotLocation_id);
		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1,""+temp_lot_loc_id);	
		pstmt_p.setString (2,""+loginLocation_id);
		pstmt_p.setString (3,""+slotid[i]);
		pstmt_p.setString (4,""+company_id);
		pstmt_p.setString (5,""+fincarats);	
		pstmt_p.setString (6,""+phycarats);	
		pstmt_p.setString (7,""+user_id);		
		pstmt_p.setString (8,""+machine_name);		
		pstmt_p.setString (9,""+yearend_id);		
		int a662 = pstmt_p.executeUpdate();
		pstmt_p.close();
		temp_lot_loc_id=temp_lot_loc_id+1;
		//System.out.println("<br>695 LotLocation_id="+LotLocation_id);
		//System.out.println("<br>697 Data updated in Lotlocation"+a662);
		}

	//Receivetransaction_id++;
	
	}// End of for Counter

/* For Insert New Rows*/
		
  
	
	//out.print("<br>839 sold_lots="+sold_lots);
	//out.print("<br>840 scounter="+scounter);
	for(int i=Tempsold_lots; i<scounter; i++)//counter= no of Rows
	{
		
		//Receivetransaction_id= 									L.get_master_id(cong,"Receive_Transaction");
	
	   //out.print("<br>675 Receivetransaction_id="+Receivetransaction_id);
		
		voucher_currency= false;

		double local_total= 0;
		double dollar_total= 0;

		
		if ("dollar".equals(currency))
		{
		voucher_currency=false;
		currency_id="0";
			
		dollar_amount[i]=str.mathformat(""+samount[i],2);
		local_amount[i]=str.mathformat(""+slocalamount[i],2);
		 
		dollar_rate[i]=""+srate[i];
		dollarEff_rate[i]=""+srate[i];
		local_rate[i]=str.mathformat(""+slocalrate[i],2);
		localEff_rate[i]=str.mathformat(""+slocalrate[i],2);

		Rec_Price[i]= ""+srate[i];	
		
		
		}//if
		else
		{   //for "local"
		voucher_currency=true;
		currency_id=local_currency;
			
		local_amount[i]=str.mathformat(""+slocalamount[i],d);
		dollar_amount[i]=str.mathformat(""+samount[i],d);
		  
		local_rate[i]=""+slocalrate[i];
		localEff_rate[i]=""+slocalrate[i];
		dollar_rate[i]=str.mathformat(""+srate[i],2);
		dollarEff_rate[i]=str.mathformat(""+srate[i],2);

		Rec_Price[i]= ""+slocalrate[i];	
			
		}//else

	errLine="886";
	//Receivetransaction_id += i;
	
	query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price,	Local_Amount, Dollar_Amount, Pieces, Remarks, Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount, Ref_Company_Description, Modified_On, Modified_By, Modified_MachineName,  Location_id, Active, Consignment_ReceiveId, YearEnd_Id, ST_RTId) values (?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?,'"+D+"', ?,?,?,?,?,?,?)";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString (1,""+Receivetransaction_id);		
	//System.out.println("<br>895 Receivetransaction_id="+Receivetransaction_id);
	pstmt_p.setString (2,""+sreceive_Id);	
	pstmt_p.setString (3,""+i);
	pstmt_p.setString (4,""+slotid[i]);
	pstmt_p.setString (5,""+sqty[i]);//original	
    pstmt_p.setString (6,""+sqty[i]);//quantity
	pstmt_p.setString (7,""+sqty[i]);//Avail quantity
	pstmt_p.setString (8, ""+Rec_Price[i]);//Receive_Price
	pstmt_p.setString (9,""+local_rate[i]);	
	pstmt_p.setString (10,""+local_rate[i]);//localEff_rate	
	pstmt_p.setString (11,""+dollar_rate[i]);	
	pstmt_p.setString (12,""+dollar_rate[i]);//dollarEff_rate

	pstmt_p.setString (13,""+local_amount[i]);//Local_Amount
	pstmt_p.setString (14,""+dollar_amount[i]);//dollar_Amount
	
	pstmt_p.setString (15, "0");	//Pecies
	pstmt_p.setString (16,""+sremark[i]);	
	  
	pstmt_p.setString (17,"0");//	Return_Quantity	
	pstmt_p.setString (18,"0");//Rejection_Percent
	pstmt_p.setString (19,"0");//Rejection_Quantity
	pstmt_p.setString (20,"0");//Lot_Discount
	pstmt_p.setString (21, Ref_Company_Description); 			        //Ref_Company_Description
	pstmt_p.setString (22,""+user_id);		
	pstmt_p.setString (23,""+machine_name);		
	//pstmt_p.setString (24,""+slocation_id[i]);		
	pstmt_p.setString (24,""+loginLocation_id);
	pstmt_p.setBoolean (25, true);		
	pstmt_p.setString (26,"0");//Consignment_ReceiveId		
	pstmt_p.setString (27,""+yearend_id);//yearend_id		
	pstmt_p.setString (28,"0");//ST_RTId		
	errLine="754";

	int a593 = pstmt_p.executeUpdate();
	errLine="757";

	pstmt_p.close();
	//System.out.println(" 762 <br> *** After Before Query 271<br>");
	errLine="761";

	Receivetransaction_id++;
	}//for
	
	//out.print("<BR><font color=skyblue>700 ALL TABLES UPDATED SUCCESSFULLY FOR SOURCE MODULE</font>");
	//System.out.println(" 767 <BR><font color=skyblue>700 ALL TABLES UPDATED SUCCESSFULLY FOR SOURCE MODULE</font>");
	errLine="766";

		Rec_Total=0;
		total_amount=0;
		totalLocalamt=0; 
		totalDollaramt=0;

	if("local".equals(currency))
		{
		voucher_currency=true;
		voucher_currency1="1";
		currency_id=local_currency;
		Rec_Total= dlocaltotalamount;
		totalLocalamt= str.mathformat(dlocaltotalamount,d);
		
		totalDollaramt=str.mathformat(dtotalamount, 2);
		} 

		if("dollar".equals(currency))
		{
		voucher_currency=false;
		voucher_currency1="0";
		currency_id="0";
		Rec_Total= dtotalamount;
		totalDollaramt= str.mathformat(dtotalamount,2);		
	    totalLocalamt=str.mathformat(dlocaltotalamount,d);
		}



	/*###############################################################

		   **** "Receive Table" for Sale  Destination ***

    ###############################################################*/
	
	//Receive_Id=Receive_Id+1;
	errLine="1013";
	//System.out.print("733****************Inside Receive");
//	Receive_Id= ""+L.get_master_id(cong,"Receive");
	//out.print("720 **************Destination Receive_Id"+Receive_Id);

	
	 query="Update Receive set Receive_Sell=?, Receive_No=?, Receive_Date=?, Receive_Lots=?, Receive_Quantity=?, Receive_CurrencyId=?, Exchange_Rate=?, Receive_ExchangeRate=?, Tax=?, Discount=?, Receive_Total=?, Local_Total=?, Dollar_Total=?, Receive_FromId=?, Receive_FromName=?, Company_Id=?, Receive_ByName=?, Receive_Internal=?, Purchase=?, Due_Days=?, Due_Date=?, Remarks=?, SalesPerson_Id=?, Consignment_ReceiveId=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Active=?, ProActive=?, R_Return=?, Stock_Date=?, InvTotal=?, InvLocalTotal=?, InvDollarTotal=?, Receive_Category=?, StockTransfer_Type=?, YearEnd_Id=?, PurchaseSaleGroup_Id=?, CgtRef_No=?,CgtDescription=?, Broker_Id=?, Broker_Formula=? where Receive_Id=?";
	//out.print("<br>725 query=>"+query);
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean (1,true);//Receive_Sell
	pstmt_p.setString (2,""+stocktransfer_no);//Receive_No, 
	pstmt_p.setString (3,""+F.getDate(datevalue));//Receive_Date, 
	pstmt_p.setString (4,""+dcounter);//Receive_Lots, 
	pstmt_p.setString (5,""+dtotalqty);//Receive_Quantity, 
	pstmt_p.setString (6,""+currency_id);//Receive_CurrencyId
	pstmt_p.setString (7,""+exchange_rate);//Exchange_Rate
	pstmt_p.setString (8,""+exchange_rate);//Receive_ExchangeRate
	pstmt_p.setString (9,"0");//Tax
	pstmt_p.setString (10,"0");//Discount
	pstmt_p.setDouble (11,Rec_Total);//Receive_Total 
	pstmt_p.setDouble (12,totalLocalamt);//Local_Total
	pstmt_p.setDouble (13,totalDollaramt);//Dollar_Total
	pstmt_p.setString (14,""+company_id);
							//Receive_FromId=companyparty_id
	pstmt_p.setString (15,""+logincompany_name); 
								//Receive_FromName=companyparty_name
	pstmt_p.setString (16,""+company_id);//Company_Id
	pstmt_p.setString (17,"0");//Receive_ByName
	pstmt_p.setBoolean (18,true);//Receive_Internal
	pstmt_p.setBoolean (19,true);//Purchase
	pstmt_p.setString (20,""+duedays);//Due_Days   
	pstmt_p.setString (21,""+F.getDate(duedate));//Due_Date
	pstmt_p.setString (22,"");//Remarks
	pstmt_p.setString (23,""+purchaseperson_id);//SalesPerson_Id
	pstmt_p.setString (24,"0");//Consignment_ReceiveId
	pstmt_p.setString (25,""+D);//Modified_On
	pstmt_p.setString (26,""+user_id);//Modified_By
	pstmt_p.setString (27,""+machine_name);//Modified_MachineName
	pstmt_p.setBoolean (28,true);//Active
	pstmt_p.setBoolean (29,true);//ProActive
	pstmt_p.setBoolean (30,false);//R_Return
	pstmt_p.setString (31,""+F.getDate(datevalue));//Stock_Date
	pstmt_p.setDouble (32,Rec_Total);//InvTotal
	pstmt_p.setDouble (33,totalLocalamt);//InvLocalTotal
	pstmt_p.setDouble (34,totalDollaramt);//InvDollarTotal
	pstmt_p.setString (35,""+category_id);//Receive_Category
	pstmt_p.setString (36,"4");//StockTransfer_Type
	pstmt_p.setString (37,""+yearend_id);//YearEnd_Id
	pstmt_p.setString (38,""+purchasesalegroup_id); 					
	pstmt_p.setString (39,""+ref_no);//CgtRef_No
	pstmt_p.setString (40,""+description);//CgtDescription
	pstmt_p.setString (41,""+broker_id);//Broker_Id
	pstmt_p.setString (42,""+broker_remarks);//Broker_Formula
	pstmt_p.setString (43,""+dreceive_Id);//Broker_Formula
	int a774 = pstmt_p.executeUpdate();  
	//System.out.println("<br><br>774 Data updated in Receive a274=>"+a774);
	pstmt_p.close();
	errLine="860";

		
	/*##############################################################

				 " Voucher Table" for sale  Destination

	###############################################################*/

	//out.print("<bR>788 **************Voucher Table Insertion  strart*****");
	testvoucher_id=testvoucher_id+1;
//	testvoucher_id=L.get_master_id(conp,"Voucher");
	//System.out.print("804****************Inside Voucher");

	 voucher_type= "3";
	// (Purchase) See voucher Table Design 
	//out.print("<br>1605 voucher_id="+testvoucher_id);
	 inSaleVoucherQuery="Update Voucher set Company_Id=?, Voucher_Type=?,Voucher_Date='"+F.getDate(datevalue)+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=?, Description=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?,YearEnd_Id=?,Ref_No=? where Voucher_No=? ";
	//out.print("<br>query6=" +query);
	pstmt_p = conp.prepareStatement(inSaleVoucherQuery);
	pstmt_p.setString(1,""+company_id); 
	pstmt_p.setString(2,""+voucher_type);		
	//out.print("<br>486 Voucher_No="+Receive_id_new);
	pstmt_p.setString (3,"0");
	pstmt_p.setBoolean(4,voucher_currency);
	pstmt_p.setString (5,""+exchange_rate);
	pstmt_p.setDouble (6,Rec_Total);
	pstmt_p.setDouble (7,totalLocalamt);
	pstmt_p.setDouble (8,totalDollaramt);
	pstmt_p.setString (9,""+description);
	pstmt_p.setString (10,""+user_id);	
	pstmt_p.setString (11,""+machine_name);
	pstmt_p.setString (12,""+yearend_id);
	pstmt_p.setString (13,""+ref_no);
	pstmt_p.setString (14,""+dreceive_Id);
	
	int a816 = pstmt_p.executeUpdate();
	 //out.print("<br>816 ************<font color=red> Update Voucher</font>"+a816);

	 pstmt_p.close();
	errLine="900";

		/*#########################################################

			"Receive_Transaction" for Sale =Destination

    ##########################################################*/
	
	//int Receivetransaction_id= L.get_master_id("Receive_Transaction");
	//Receivetransaction_id=0;
	//Receivetransaction_id=Receivetransaction_id; //L.get_master_id(cong,"Receive_Transaction");

	//LotLocation_id=LotLocation_id;
	//LotLocation_id=L.get_master_id(cong,"LotLocation");

	String dlocal_rate[]=new String[dcounter];
	String dlocalEff_rate[]=new String[dcounter];
	String ddollar_rate[]=new String[dcounter];
	String ddollarEff_rate[]=new String[dcounter];
	String dlocal_amount[]=new String[dcounter];
	String ddollar_amount[]=new String[dcounter];
	String dRec_Price[]=new String[dcounter];
	//System.out.println("858***********##########dcounter="+dcounter);

	for(int i=0; i<dcounter; i++)//counter= no of Rows
	{
		
	//System.out.println("863****************Inside RT Destination");

		voucher_currency= false;

		
		double local_total= 0;
		double dollar_total= 0;
		
		//out.print("<br>1188 currency="+currency);

		if ("dollar".equals(currency))
		{
		voucher_currency=false;
		currency_id="0";
			
		ddollar_amount[i]=str.mathformat(""+damount[i],2);
		dlocal_amount[i]=str.mathformat(""+dlocalamount[i],2);
		 
		ddollar_rate[i]=""+drate[i];
		ddollarEff_rate[i]=""+drate[i];
		dlocal_rate[i]=str.mathformat(""+dlocalrate[i],2);
		dlocalEff_rate[i]=str.mathformat(""+dlocalrate[i],2);

		dRec_Price[i]= ""+drate[i];	
		
		
		}//if
		else
		{   //for "local"
		voucher_currency=true;
		currency_id=local_currency;
			
		
		ddollar_amount[i]=str.mathformat(""+damount[i],d);
		dlocal_amount[i]=str.mathformat(""+dlocalamount[i],2);  
		dlocal_rate[i]=str.mathformat(""+dlocalrate[i],2);
		//out.print("<br>901 dlocal_rate="+dlocalrate[i]);
		dlocalEff_rate[i]=str.mathformat(""+dlocalrate[i],2);
		ddollar_rate[i]=str.mathformat(""+drate[i],2);
		ddollarEff_rate[i]=str.mathformat(""+drate[i],2);

		dRec_Price[i]=""+str.mathformat(""+dlocalrate[i],2);	
			
		}//else

	errLine="1225";
	//Receivetransaction_id += i;
		//out.print("<br>911 RT START HERE"); 

	query="Update Receive_Transaction set Receive_Id=?, Lot_SrNo=?, Lot_Id=?, Original_Quantity=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, LocalEffective_Price=?, Dollar_Price=?, DollarEffective_Price=?,	Local_Amount=?, Dollar_Amount=?, Pieces=?, Remarks=?, Return_Quantity=?, Rejection_Percent=?, Rejection_Quantity=?, Lot_Discount=?, Ref_Company_Description=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=?,  Location_id=?, Active=?, Consignment_ReceiveId=?, YearEnd_Id=?, ST_RTId=? where ReceiveTransaction_Id=?";

	pstmt_p = conp.prepareStatement(query);
	//out.println("<br>fine till 252");
	pstmt_p.setString (1,""+dreceive_Id);	
	//out.print("<br>1234 dreceive_Id="+dreceive_Id);
	pstmt_p.setString (2,""+i);
	pstmt_p.setString (3,""+dlotid[i]);
	pstmt_p.setString (4,""+dqty[i]);//original	
    errLine="985";

	pstmt_p.setString (5,""+dqty[i]);//quantity
	pstmt_p.setString (6, ""+dqty[i]);	//Avail quantity
	pstmt_p.setString (7, ""+dRec_Price[i]);//Receive_Price
	errLine="990";

	pstmt_p.setString (8,""+dlocal_rate[i]);	
	pstmt_p.setString (9,""+dlocalEff_rate[i]);//localEff_rate	
	pstmt_p.setString (10,""+ddollar_rate[i]);	
	pstmt_p.setString (11,""+ddollarEff_rate[i]);//dollarEff_rate
	errLine="996";

	pstmt_p.setString (12,""+dlocal_amount[i]);//Local_Amount
	pstmt_p.setString (13,""+ddollar_amount[i]);//dollar_Amount
	errLine="1000";
	pstmt_p.setString (14, "0");	//Pecies
	pstmt_p.setString (15,""+dremark[i]);	
	errLine="1003";

	pstmt_p.setString (16,"0");//	Return_Quantity	
	pstmt_p.setString (17,"0");//Rejection_Percent
	pstmt_p.setString (18,"0");//Rejection_Quantity
	pstmt_p.setString (19,"0");//Lot_Discount
	pstmt_p.setString (20, ""+Ref_Company_Description); 										          //Ref_Company_Description
	pstmt_p.setString (21,""+user_id);		
	pstmt_p.setString (22,""+machine_name);		
	pstmt_p.setString (24,""+dlocation_id[i]);	//FromWHLocation_id	
	pstmt_p.setString (23,""+loginLocation_id);
	errLine="1014";
	pstmt_p.setBoolean (24, true);		
	pstmt_p.setString (25,"0");//Consignment_ReceiveId		
	pstmt_p.setString (26,""+yearend_id);//yearend_id		
	errLine="1018";	
	pstmt_p.setString (27,"0");//ST_RTId ie.StockTransfer RT_Id		
	pstmt_p.setDouble (28,dRT_Id[i]);//ST_RTId ie.StockTransfer RT_Id		
	//out.println("<br>Before Query 271<br>v"+query);
	errLine="1022";

	int a957 = pstmt_p.executeUpdate();
	//out.print("<br>957 Data updated in Receive_Transaction"+a957);
	errLine="1026";

	pstmt_p.close();
	//out.println("<br> *** After Before Query 271<br>");
		
	errLine="1031";
	/*#######################################################

					  "Lot Location" for Sale =Destination

    #########################################################*/
	
	//System.out.println("1057**************Inside Lot Location Destination");
	
	int level1= cong.getTransactionIsolation();

	cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

	query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
	//out.print("<br>query" +query);
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,""+dlotid[i]); 
	//System.out.println("1002**************dlotid="+dlotid[i]);

	pstmt_p.setString(2,""+loginLocation_id); //FromWHLocation_id
	//System.out.println("1005*********dlocation_id="+dlocation_id[i]);

	pstmt_p.setString(3,""+company_id); 
	rs_p = pstmt_p.executeQuery();
	double fincarats=0;
	double phycarats=0;
	int p=0;
		while(rs_p.next()) 	
		{
		fincarats= rs_p.getDouble("Carats");
		//System.out.println("1011**************fincarats="+fincarats);
		phycarats= rs_p.getDouble("Available_Carats");
		//System.out.println("1013**************phycarats="+phycarats);

		p++;
		}
		pstmt_p.close();
		cong.setTransactionIsolation(level1);
	phycarats = (phycarats + dqty[i]);
	
	if(p>0)
	   {
		//System.out.println("1023**************in update=");

		query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
		//out.print("<br>query" +query);
		pstmt_p = conp.prepareStatement(query);
		//pstmt_p.setString(1,"0"); 
		pstmt_p.setString(1,""+fincarats); 
		pstmt_p.setString(2,""+phycarats); 
		pstmt_p.setString (3,""+user_id);		
		pstmt_p.setString (4,""+machine_name);		
		pstmt_p.setString(5,""+dlotid[i]); 
		pstmt_p.setString(6,""+loginLocation_id);//FromWHLocation_id 
		pstmt_p.setString(7,""+company_id); 
		//out.println("Before Query <br>"+query);
		int a1008 = pstmt_p.executeUpdate();
		//out.print("<br>Data updated in Lotlocation"+a1008);
		//out.println("<br>Data Successfully updated in lot table <br>");
		pstmt_p.close();
			
	   }
	else{
		//System.out.println("1044**************in Insert LotLocation=");
		
		//out.print("<br>1051 LotLocation_id="+LotLocation_id);
		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1,""+LotLocation_id);		
		pstmt_p.setString (2,""+loginLocation_id);//FromWHLocation_id
		pstmt_p.setString (3,""+dlotid[i]);
		pstmt_p.setString (4,""+company_id);
		pstmt_p.setString (5,""+fincarats);	
		pstmt_p.setString (6,""+phycarats);	
		pstmt_p.setString (7,""+user_id);		
		pstmt_p.setString (8,""+machine_name);		
		pstmt_p.setString (9,""+yearend_id);		
		int a1027 = pstmt_p.executeUpdate();
		pstmt_p.close();
		LotLocation_id++;

		//out.print("<br>Data updated in Lotlocation"+a1027);
		//out.print("<br>Data updated in Lotlocation"+a1027);
		}

	//Receivetransaction_id++;
	//System.out.println("1058**************Inside End  LOtLocation");

	}// End of for Counter

/* For Insert New Rows*/
		
  
	 
	 
	
	for(int i=Tempdold_lots; i<dcounter; i++)//counter= no of Rows
	{
		//Receivetransaction_id= 									L.get_master_id(cong,"Receive_Transaction");
	
	   //out.print("<br>1134 Receivetransaction_id="+Receivetransaction_id);
		
		voucher_currency= false;

		double local_total= 0;
		double dollar_total= 0;

		
		if ("dollar".equals(currency))
		{
		voucher_currency=false;
		currency_id="0";
			
		dollar_amount[i]=str.mathformat(""+damount[i],2);
		local_amount[i]=str.mathformat(""+dlocalamount[i],2);
		 
		dollar_rate[i]=""+drate[i];
		dollarEff_rate[i]=""+drate[i];
		local_rate[i]=str.mathformat(""+dlocalrate[i],2);
		localEff_rate[i]=str.mathformat(""+dlocalrate[i],2);

		Rec_Price[i]= ""+drate[i];	
		
		
		}//if
		else
		{   //for "local"
		voucher_currency=true;
		currency_id=local_currency;
			
		local_amount[i]=str.mathformat(""+dlocalamount[i],d);
		dollar_amount[i]=str.mathformat(""+damount[i],d);
		  
		local_rate[i]=""+dlocalrate[i];
		localEff_rate[i]=""+dlocalrate[i];
		dollar_rate[i]=str.mathformat(""+drate[i],2);
		dollarEff_rate[i]=str.mathformat(""+drate[i],2);

		Rec_Price[i]= ""+dlocalrate[i];	
			
		}//else

	errLine="1456";
	//Receivetransaction_id += i;
	
	query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price,	Local_Amount, Dollar_Amount, Pieces, Remarks, Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount, Ref_Company_Description, Modified_On, Modified_By, Modified_MachineName,  Location_id, Active, Consignment_ReceiveId, YearEnd_Id, ST_RTId) values (?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?,'"+D+"', ?,?,?,?,?,?,?)";

	pstmt_p = conp.prepareStatement(query);
	//out.println("<br>fine till 605="+query);
	pstmt_p.setString (1,""+Receivetransaction_id);		
	pstmt_p.setString (2,""+dreceive_Id);	
	pstmt_p.setString (3,""+i);
	pstmt_p.setString (4,""+dlotid[i]);
	pstmt_p.setString (5,""+dqty[i]);//original	
    pstmt_p.setString (6,""+dqty[i]);//quantity
	pstmt_p.setString (7,""+dqty[i]);//Avail quantity
	pstmt_p.setString (8, ""+Rec_Price[i]);//Receive_Price
	pstmt_p.setString (9,""+local_rate[i]);	
	pstmt_p.setString (10,""+local_rate[i]);//localEff_rate	
	pstmt_p.setString (11,""+dollar_rate[i]);	
	pstmt_p.setString (12,""+dollar_rate[i]);//dollarEff_rate

	pstmt_p.setString (13,""+local_amount[i]);//Local_Amount
	pstmt_p.setString (14,""+dollar_amount[i]);//dollar_Amount
	
	pstmt_p.setString (15, "0");	//Pecies
	pstmt_p.setString (16,""+dremark[i]);	
	      
	pstmt_p.setString (17,"0");//	Return_Quantity	
	pstmt_p.setString (18,"0");//Rejection_Percent
	pstmt_p.setString (19,"0");//Rejection_Quantity
	pstmt_p.setString (20,"0");//Lot_Discount
	pstmt_p.setString (21, Ref_Company_Description); 				          //Ref_Company_Description
	pstmt_p.setString (22,""+user_id);		
	pstmt_p.setString (23,""+machine_name);		
	//pstmt_p.setString (24,""+slocation_id[i]);		
	pstmt_p.setString (24,""+loginLocation_id);
	pstmt_p.setBoolean (25, true);		

	pstmt_p.setString (26,"0");//Consignment_ReceiveId		
	pstmt_p.setString (27,""+yearend_id);//yearend_id		
	pstmt_p.setString (28,"0");//ST_RTId		
	//out.println("Before Query 271<br>v"+query);
	errLine="1215";

	int a596 = pstmt_p.executeUpdate();
	//out.print("<br>593 Data updated in Receive_Transaction"+a596);
	errLine="1219";

	pstmt_p.close();
	//System.out.println(" 1226 <br> *** After Before Query 271<br>"+Receivetransaction_id);
	errLine="1223";
	Receivetransaction_id++;
	}//for

	//System.out.println("1193**************Inside End  Destination");
	
	 //out.print("<BR><font color=skyblue>1195 ALL TABLES UPDATED SUCCESSFULLY FOR DESTINATION MODULE</font>");
	conp.commit();
	C.returnConnection(conp);
	C.returnConnection(cong);
	errLine="1232";
	response.sendRedirect("EditStockInOut.jsp?command=StockInOutReport&Receive_No="+stocktransfer_no);
	%>

	<html>
	<body onload="uncheckUpdatependingQty();">
		<script language="javascript">
		function uncheckUpdatependingQty()
		{
			//onload="window.opener.mainform.splitBtn1.disabled=true;
						
			<%for(int i=0; i<scount; i++)
			{%>
				var sqty1=<%=sqty[i]%>;
				var spendingqty1=<%=spendingqty[i]%>;
				var rowno1=<%=rowNo[i]%>;
				var spendQty="pendingqty"+rowno1;
				var scheck="check"+rowno1;
				if(sqty1==spendingqty1)
				{
				spendingqty1=(parseFloat(spendingqty1)-parseFloat(sqty1));		
				window.opener.mainform.elements[spendQty].value= parseFloat(spendingqty1);
				window.opener.mainform.elements[scheck].disabled=true;
				}
				else{				
				spendingqty1=(parseFloat(spendingqty1)-parseFloat(sqty1));		
				window.opener.mainform.elements[spendQty].value= parseFloat(spendingqty1);
				
				}
				
			<%}%>
			window.close();
	
		}
		</script>
	
	</body>		
	</html>
	 <%
		  }// end of save ###########

	}// end of try
	catch(Exception eBant)
	{	
		conp.rollback();
		C.returnConnection(conp);
		C.returnConnection(cong);
		
	 	out.print("<BR>1310 Filename: EditStock_InOutUpdate.jsp and Bug No.="+eBant+" errLine="+errLine);
	}
%>