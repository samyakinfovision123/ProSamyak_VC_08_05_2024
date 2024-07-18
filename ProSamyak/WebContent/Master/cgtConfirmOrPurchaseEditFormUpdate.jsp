<!-- Currently in this file Only "Regular" purchase type is coded.
Cash Type purchase is to be coded
09-03-2006
-->
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
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;


try{


try	
{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception Samyak60)
{ 
out.println("<br><font color=red> FileName : cgtConfirmOrPurchase.jsp<br>Bug No Samyak60 : "+ Samyak60);
}
String user_id= ""+session.getValue("user_id");
String machine_name=request.getRemoteHost();
String user_name = ""+session.getValue("user_name");
int user_level = Integer.parseInt(""+session.getValue("user_level"));
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

String company_name="";
String company_address="";
String company_city="";
String company_country="";
String company_phone_off="";
String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+company_id;
pstmt_g = cong.prepareStatement(company_query);
//System.out.println(company_query);
rs_g = pstmt_g.executeQuery();
	while(rs_g.next()) 	
	{
	company_name= rs_g.getString("CompanyParty_Name");	
	company_address= rs_g.getString("Address1");	
	company_city= rs_g.getString("City");		
	company_country= rs_g.getString("Country");		
	company_phone_off= rs_g.getString("Phone_Off");	
	}
pstmt_g.close();
String local_currencyid=I.getLocalCurrency(cong,company_id);
String local_currencysymbol= I.getLocalSymbol(cong,company_id);
//out.print("<br>local_currencysymbol"+local_currencysymbol);
String base_exchangerate= I.getLocalExchangeRate(cong,company_id);


java.sql.Date D4 = new
java.sql.Date(System.currentTimeMillis());
String date=""+format.format(D4);
String startDate = format.format(YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));
//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(cong,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);



java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date invoice_datetemp = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Chanchal_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_date=stoday_day+"/"+stoday_month+"/"+today_year;
// end of today_date in dd/mm/yyyy format

// logic to get local currecy 
// end of local currecy logic
String command = request.getParameter("command");
String refReceive_Id = request.getParameter("Receive_Id");
String currReceive_Id = "0";
String EditType = request.getParameter("EditType");

String lots = request.getParameter("oldLotRows");
int lotRows= Integer.parseInt(lots);
String condition="and Super=0  and Purchase=1 and active=1";

int oldLedgerRows = Integer.parseInt(request.getParameter("oldLedgerRows"));
int newLedgerRows = 0;
int newLotRows = 0;


int flag1 = 0;
if("SAVE".equals(command) )
{

boolean dataCommitted = false; //just used for redirecting decision purpose
 
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid));
 
//Reading the data from the previous file

int invalidLots = 0;

int totalLots = 0;
int totalLedgers = 0;

String purchase_no = request.getParameter("purchase_no");
String ref_no = request.getParameter("ref_no");
String currency = request.getParameter("currency");
String companyparty_name = request.getParameter("companyparty_name");
String companyparty_id = request.getParameter("companyparty_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String datevalue = request.getParameter("datevalue");
String duedays = request.getParameter("duedays");
String duedate = request.getParameter("duedate");
String purchase_type = request.getParameter("purchase_type");
String location_id0 = request.getParameter("location_id0");
String category_id = request.getParameter("category_id");
String exchange_rate = request.getParameter("exchange_rate");
String purchaseperson_id = request.getParameter("purchaseperson_id");
String broker_id = request.getParameter("broker_id");
String broker_remarks = request.getParameter("broker_remarks");

//Reading the data of the previous lots.
String rtid[] = new String[lotRows];
String delete[] = new String[lotRows];
String lotid[] = new String[lotRows];
String oldlotid[] = new String[lotRows];
String lotno[] = new String[lotRows];
String description[] = new String[lotRows];
String dsize[] = new String[lotRows];
String originalQty[] = new String[lotRows];
String returnQty[] = new String[lotRows];
String rejection[] = new String[lotRows];
String rejectionQty[] = new String[lotRows];
String qty[] = new String[lotRows];
String oldqty[] = new String[lotRows];
String rate[] = new String[lotRows];
String effrate[] = new String[lotRows];
String localrate[] = new String[lotRows];
String efflocalrate[] = new String[lotRows];
String amount[] = new String[lotRows];
String localamount[] = new String[lotRows];
String remarks[] = new String[lotRows];
String lotDiscount[] = new String[lotRows];

for(int i=0; i<lotRows; i++)
{
	rtid[i] = request.getParameter("rtid"+i);
	delete[i] = request.getParameter("delete"+i);
	if(! "yes".equals(delete[i]))
	{
		totalLots++;
	}
	lotid[i] = request.getParameter("lotid"+i);
	oldlotid[i] = request.getParameter("oldlotid"+i);
	lotno[i] = request.getParameter("lotno"+i);
	description[i] = request.getParameter("description"+i);
	dsize[i] = request.getParameter("dsize"+i);
	originalQty[i] = request.getParameter("originalQty"+i);
	returnQty[i] = request.getParameter("returnQty"+i);
	rejection[i] = request.getParameter("rejection"+i);
	rejectionQty[i] = request.getParameter("rejectionQty"+i);
	qty[i] = request.getParameter("qty"+i);
	oldqty[i] = request.getParameter("oldqty"+i);
	rate[i] = request.getParameter("rate"+i);
	effrate[i] = request.getParameter("effrate"+i);
	localrate[i] = request.getParameter("localrate"+i);
	efflocalrate[i] = request.getParameter("efflocalrate"+i);
	amount[i] = request.getParameter("amount"+i);
	localamount[i] = request.getParameter("localamount"+i);
	remarks[i] = request.getParameter("remarks"+i);
	lotDiscount[i] = request.getParameter("lotDiscount"+i);

}


String originalQtyTotal = request.getParameter("originalQtyTotal");
String returnQtyTotal = request.getParameter("returnQtyTotal");
String rejectQtyTotal = request.getParameter("rejectQtyTotal");
String qtyTotal = request.getParameter("qtyTotal");
String amountTotal = request.getParameter("amountTotal");
String localamountTotal = request.getParameter("localamountTotal");
String narration = request.getParameter("narration");

//Read the values of the old ledger rows
String ledger[] = new String[oldLedgerRows];
String ftid[] = new String[oldLedgerRows];
String deleteLedger[] = new String[oldLedgerRows];
String ledgerPercent[] = new String[oldLedgerRows];
String ledgerAmount[] = new String[oldLedgerRows];
String ledgerLocalAmount[] = new String[oldLedgerRows];
String debitcredit[] = new String[oldLedgerRows];

for(int i=0; i<oldLedgerRows; i++)
{
	ledger[i] = request.getParameter("ledger"+i);
	ftid[i] = request.getParameter("ftid"+i);
	deleteLedger[i] = request.getParameter("deleteLedger"+i);
	if(! "yes".equals(deleteLedger[i]))
	{
		totalLedgers++;
	}
	ledgerPercent[i] = request.getParameter("ledgerPercent"+i);
	ledgerAmount[i] = request.getParameter("ledgerAmount"+i);
	ledgerLocalAmount[i] = request.getParameter("ledgerLocalAmount"+i);
	debitcredit[i] = request.getParameter("debitcredit"+i);
}

		
//read the last pages final amounts
String amountFinalTotal = request.getParameter("amountFinalTotal");
String localamountFinalTotal = request.getParameter("localamountFinalTotal");

conp.setAutoCommit(false);

//Inserting the data into the Receive Table

String Receive_id =	refReceive_Id;

String query = " UPDATE Receive SET Receive_Sell=?, Receive_No=?, Receive_Date=?, Receive_Lots=?, Receive_Quantity=?, Receive_CurrencyId=?, Exchange_Rate=?, Receive_ExchangeRate=?, Tax=?, Discount=?, Receive_Total=?, Local_Total=?, Dollar_Total=?, Receive_FromId=?, Receive_FromName=?, Company_Id=?, Receive_ByName=?, Purchase=?, Due_Days=?, Due_Date=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Opening_Stock=?, SalesPerson_Id=?, ProActive=?, R_Return=?, Stock_Date=?, Difference_Amount=?, Difference_LocalAmount=?, Difference_DollarAmount=?, InvTotal=?, InvLocalTotal=?, InvDollarTotal=?, Receive_Category=?, YearEnd_Id=?, PurchaseSaleGroup_Id=?, CgtRef_No=?, CgtDescription=?, Broker_Id=?, Broker_Formula=? WHERE Receive_Id=?";

pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean (1, true);		
pstmt_p.setString (2,purchase_no);
//out.print("<br> purchase_no:"+purchase_no);
pstmt_p.setString (3,""+format.getDate(datevalue));
//out.print("<br> datevalue:"+datevalue);
pstmt_p.setString (4,""+totalLots);
//out.print("<br> lotRows:"+lotRows);
pstmt_p.setString (5,""+qtyTotal);
//out.print("<br> originalQtyTotal:"+qtyTotal);
if("local".equals(currency))
	pstmt_p.setString (6,""+local_currencyid);			
else
	pstmt_p.setString (6,"0");			

//out.print("<br> currency:"+currency);
//out.print("<br> local_currencyid:"+local_currencyid);
pstmt_p.setString (7,""+exchange_rate);	
//out.print("<br> exchange_rate:"+exchange_rate);
pstmt_p.setString (8, ""+exchange_rate);
pstmt_p.setString (9, "0");
pstmt_p.setString (10,"0");	

if("local".equals(currency))
	pstmt_p.setString (11, ""+localamountFinalTotal);	
else
	pstmt_p.setString (11, ""+amountFinalTotal);	

//out.print("<br> currency:"+currency);
pstmt_p.setString (12, ""+localamountFinalTotal);	
//out.print("<br> localamountFinalTotal:"+localamountFinalTotal);
pstmt_p.setString (13, ""+amountFinalTotal);
//out.print("<br> amountFinalTotal:"+amountFinalTotal);
pstmt_p.setString (14, ""+companyparty_id);
//out.print("<br> companyparty_id:"+companyparty_id);
pstmt_p.setString (15,""+ companyparty_name);		
//out.print("<br> companyparty_name:"+companyparty_name);
pstmt_p.setString (16,company_id);	
//out.print("<br> company_id:"+company_id);
pstmt_p.setString (17,user_name);		
//out.print("<br> user_name:"+user_name);
pstmt_p.setBoolean (18, true);		
pstmt_p.setString (19, ""+duedays);	
//out.print("<br> duedays:"+duedays);
pstmt_p.setString (20, ""+format.getDate(duedate));	
//out.print("<br> duedate:"+duedate);
pstmt_p.setString (21, ""+D);	
//out.print("<br> D:"+D);
pstmt_p.setString (22, ""+user_id);	
//out.print("<br> user_id:"+user_id);
pstmt_p.setString (23, machine_name);	
//out.print("<br> machine_name:"+machine_name);
pstmt_p.setBoolean (24, false);	
pstmt_p.setString (25, ""+purchaseperson_id);	
//out.print("<br> purchaseperson_id:"+purchaseperson_id);
pstmt_p.setBoolean (26, false);
pstmt_p.setBoolean (27, false);
pstmt_p.setString (28,""+format.getDate(datevalue));	
//out.print("<br> datevalue:"+datevalue);
pstmt_p.setString (29, "0");
pstmt_p.setString (30, "0");
pstmt_p.setString (31, "0");

if("local".equals(currency))
	pstmt_p.setString (32, ""+localamountTotal);	
else
	pstmt_p.setString (32, ""+amountTotal);	

pstmt_p.setString (33, ""+localamountTotal);
//out.print("<br> localamountTotal:"+localamountTotal);
pstmt_p.setString (34, ""+amountTotal);
//out.print("<br> amountTotal:"+amountTotal);
pstmt_p.setString (35,""+category_id);
//out.print("<br> category_id:"+category_id);
pstmt_p.setString (36,""+yearend_id);
//out.print("<br> yearend_id:"+yearend_id);
pstmt_p.setString (37,""+purchasesalegroup_id);
//out.print("<br> purchasesalegroup_id:"+purchasesalegroup_id);
pstmt_p.setString (38,ref_no);
pstmt_p.setString (39,narration);
pstmt_p.setString (40,""+broker_id);
//out.print("<br> broker_id:"+broker_id);
pstmt_p.setString (41,broker_remarks);
pstmt_p.setString (42, ""+Receive_id);
//out.print("<br> Receive_id:"+Receive_id);

int a224 = pstmt_p.executeUpdate();
pstmt_p.close();


//Inserting Data in Receive_Transaction
int Receivetransaction_id= L.get_master_id(cong,"Receive_Transaction");

for(int i=0; i<lotRows; i++)
{
	if( "0".equals(rtid[i]) && "yes".equals(delete[i]) )//new row with deleted checkbox checked
		{ continue ;}

	else if ( !("0".equals(rtid[i])) && "yes".equals(delete[i]) )//old row with deleted checkbox checked
	{
		query="UPDATE Receive_Transaction SET Active=0 WHERE ReceiveTransaction_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1, ""+rtid[i]);	

		int a245 = pstmt_p.executeUpdate();
		pstmt_p.close();
	}

	else if (  !("0".equals(rtid[i])) && !("yes".equals(delete[i])) )//old row with deleted checkbox unchecked
	{
		query="UPDATE Receive_Transaction SET  Receive_Id=?, Lot_SrNo=?, Lot_Id=?, Original_Quantity=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, LocalEffective_Price=?, Dollar_Price=?, DollarEffective_Price=?, Local_Amount=?, Dollar_Amount=?, Pieces=?, Remarks=? , Return_Quantity=?, Rejection_Percent=?, Rejection_Quantity=?, Lot_Discount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Location_id=?, Consignment_ReceiveId=?, YearEnd_Id=? WHERE ReceiveTransaction_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1,""+Receive_id);
		//out.print("<br> Receive_id:"+Receive_id);	
		pstmt_p.setString (2, ""+i);
		pstmt_p.setString (3,lotid[i]);
		//out.print("<br> lotid:"+lotid[i]);	
		pstmt_p.setString (4,""+originalQty[i]);	
		//out.print("<br> originalQty:"+originalQty[i]);	
		pstmt_p.setString (5, ""+qty[i]);	
		//out.print("<br> qty:"+qty[i]);	
		pstmt_p.setString (6, ""+qty[i]);
		//out.print("<br> qty:"+qty[i]);	
		pstmt_p.setString (7,rate[i]);	
		//out.print("<br> rate:"+rate[i]);	
		pstmt_p.setString (8,localrate[i]);	
		//out.print("<br> localrate:"+localrate[i]);	
		pstmt_p.setString (9, ""+efflocalrate[i]);	
		//out.print("<br> efflocalrate:"+efflocalrate[i]);	
		pstmt_p.setString (10,""+rate[i]);	
		//out.print("<br> rate:"+rate[i]);	
		pstmt_p.setString (11, effrate[i]);		
		//out.print("<br> effrate:"+effrate[i]);	
		pstmt_p.setString (12, localamount[i]);		
		//out.print("<br> localamount:"+localamount[i]);	
		pstmt_p.setString (13, amount[i]);		
		//out.print("<br> amount:"+amount[i]);	
		pstmt_p.setString (14, "0");		
		pstmt_p.setString (15, remarks[i]);		
		//out.print("<br> remarks:"+remarks[i]);	
		pstmt_p.setString (16,returnQty[i]);
		//out.print("<br> returnQty:"+returnQty[i]);	
		pstmt_p.setString (17,rejection[i]);
		//out.print("<br> rejection:"+rejection[i]);	
		pstmt_p.setString (18,rejectionQty[i]);
		//out.print("<br> rejectionQty:"+rejectionQty[i]);	
		pstmt_p.setString (19,lotDiscount[i]);
		//out.print("<br> lotDiscount:"+lotDiscount[i]);	
		pstmt_p.setString (20,""+D);
		//out.print("<br> D:"+D);	
		pstmt_p.setString (21,""+user_id);
		//out.print("<br> user_id:"+user_id);	
		pstmt_p.setString (22,machine_name);
		//out.print("<br> machine_name:"+machine_name);	
		pstmt_p.setString (23,location_id0);
		//out.print("<br> location_id0:"+location_id0);	
		pstmt_p.setString (24,rtid[i]);
		//out.print("<br> RT_Id:"+rtid[i]);	
		pstmt_p.setString (25,yearend_id);
		//out.print("<br> yearend_id:"+yearend_id);	
		pstmt_p.setString (26, ""+rtid[i]);	
		//out.print("<br><br> Receivetransaction_id:"+Receivetransaction_id);
		
		int a245 = pstmt_p.executeUpdate();
		pstmt_p.close();

	}

	else if (  "0".equals(rtid[i]) && !("yes".equals(delete[i])) )//new row with deleted checkbox unchecked
	{

		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, LocalEffective_Price, Dollar_Price, DollarEffective_Price, Local_Amount, Dollar_Amount, Pieces,Remarks , Return_Quantity, Rejection_Percent, Rejection_Quantity, Lot_Discount, Modified_On, Modified_By, Modified_MachineName, Location_id, Consignment_ReceiveId, YearEnd_Id ) values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? )";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1, ""+Receivetransaction_id);	
		//out.print("<br><br> Receivetransaction_id:"+Receivetransaction_id);
		pstmt_p.setString (2,""+Receive_id);
		//out.print("<br> Receive_id:"+Receive_id);	
		pstmt_p.setString (3, ""+i);
		pstmt_p.setString (4,lotid[i]);
		//out.print("<br> lotid:"+lotid[i]);	
		pstmt_p.setString (5,""+originalQty[i]);	
		//out.print("<br> originalQty:"+originalQty[i]);	
		pstmt_p.setString (6, ""+qty[i]);	
		//out.print("<br> qty:"+qty[i]);	
		pstmt_p.setString (7, ""+qty[i]);
		//out.print("<br> qty:"+qty[i]);	
		pstmt_p.setString (8,rate[i]);	
		//out.print("<br> rate:"+rate[i]);	
		pstmt_p.setString (9,localrate[i]);	
		//out.print("<br> localrate:"+localrate[i]);	
		pstmt_p.setString (10, ""+efflocalrate[i]);	
		//out.print("<br> efflocalrate:"+efflocalrate[i]);	
		pstmt_p.setString (11,""+rate[i]);	
		//out.print("<br> rate:"+rate[i]);	
		pstmt_p.setString (12, effrate[i]);		
		//out.print("<br> effrate:"+effrate[i]);	
		pstmt_p.setString (13, localamount[i]);		
		//out.print("<br> localamount:"+localamount[i]);	
		pstmt_p.setString (14, amount[i]);		
		//out.print("<br> amount:"+amount[i]);	
		pstmt_p.setString (15, "0");		
		pstmt_p.setString (16, remarks[i]);		
		//out.print("<br> remarks:"+remarks[i]);	
		pstmt_p.setString (17,returnQty[i]);
		//out.print("<br> returnQty:"+returnQty[i]);	
		pstmt_p.setString (18,rejection[i]);
		//out.print("<br> rejection:"+rejection[i]);	
		pstmt_p.setString (19,rejectionQty[i]);
		//out.print("<br> rejectionQty:"+rejectionQty[i]);	
		pstmt_p.setString (20,lotDiscount[i]);
		//out.print("<br> lotDiscount:"+lotDiscount[i]);	
		pstmt_p.setString (21,""+D);
		//out.print("<br> D:"+D);	
		pstmt_p.setString (22,""+user_id);
		//out.print("<br> user_id:"+user_id);	
		pstmt_p.setString (23,machine_name);
		//out.print("<br> machine_name:"+machine_name);	
		pstmt_p.setString (24,location_id0);
		//out.print("<br> location_id0:"+location_id0);	
		pstmt_p.setString (25,rtid[i]);
		//out.print("<br> RT_Id:"+rtid[i]);	
		pstmt_p.setString (26,yearend_id);
		//out.print("<br> yearend_id:"+yearend_id);	

		
		int a245 = pstmt_p.executeUpdate();
		pstmt_p.close();

		Receivetransaction_id++;
	}
	
	
}
	

//Updating data into the voucher table
String testvoucher_id=A.getNameCondition(cong, "Voucher", "Voucher_Id" ," WHERE Voucher_No='"+Receive_id+"'");

query="UPDATE Voucher SET  Company_Id=?, Voucher_Type=?, Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=?, Description=?, Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, YearEnd_Id=?, Ref_No=? WHERE Voucher_Id=?";

pstmt_p = conp.prepareStatement(query);
		
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,"2");		
pstmt_p.setString(3,Receive_id);		
pstmt_p.setString (4,""+(totalLedgers));

if("local".equals(currency))
	pstmt_p.setString (5, "1");	
else
	pstmt_p.setString (5, "0");	

pstmt_p.setString (6,""+exchange_rate);

if("local".equals(currency))
	pstmt_p.setString (7, ""+localamountFinalTotal);	
else
	pstmt_p.setString (7, ""+amountFinalTotal);	

pstmt_p.setString (8,localamountFinalTotal);	
pstmt_p.setString (9,amountFinalTotal);
pstmt_p.setString (10,narration);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,yearend_id);
pstmt_p.setString (14,ref_no);
pstmt_p.setString (15,""+testvoucher_id);

int a691 = pstmt_p.executeUpdate();

pstmt_p.close();

//out.print("<br><br> Voucher Query Complete");

//now enter the financial_transaction rows

int transaction_id=L.get_master_id(cong,"Financial_Transaction");
for(int i=0;i<oldLedgerRows;i++)
{
	if( "0".equals(ftid[i]) && "yes".equals(deleteLedger[i]) )//new row with deleted checkbox checked
		{ continue ;}

	else if ( !("0".equals(ftid[i])) && "yes".equals(deleteLedger[i]) )//old row with deleted checkbox checked
	{
		query="UPDATE Financial_Transaction SET Active=0 WHERE Tranasaction_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1, ""+ftid[i]);	

		int a245 = pstmt_p.executeUpdate();
		pstmt_p.close();
	}

	else if (  !("0".equals(ftid[i])) && !("yes".equals(deleteLedger[i])) )//old row with deleted checkbox unchecked
	{
		query="UPDATE Financial_Transaction SET  Company_Id=?, Voucher_Id=?, Sr_No=?, For_Head=?, For_HeadId=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Ledger_Id=?, Transaction_Date=?, Tranasaction_No=?, Receive_Id=?, ReceiveFrom_LedgerId=?, Exchange_Rate=?, YearEnd_Id=?, Cheque_No=? WHERE Tranasaction_Id=?";
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString(1,""+company_id);
		//out.print("<br>company_id "+company_id);
		pstmt_p.setString(2,""+testvoucher_id);
		//out.print("<br>testvoucher_id "+testvoucher_id);
		pstmt_p.setString(3,""+(i+1));

		String for_head=A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
		pstmt_p.setString(4,""+for_head);
		//out.print("<br>for_head "+for_head);
		String forhead_id=A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);
		//out.print("<br>forhead_id "+forhead_id);
		pstmt_p.setString(5,""+forhead_id);
		
		if("1".equals(debitcredit[i]))
			pstmt_p.setString(6,"1");
		else
			pstmt_p.setString(6,"0");
		//out.print("<br>debitcredit "+debitcredit[i]);
		
		if("local".equals(currency))
			pstmt_p.setString (7, ""+ledgerLocalAmount[i]);	
		else
			pstmt_p.setString (7, ""+ledgerAmount[i]);	

		//out.print("<br>currency "+currency);
		pstmt_p.setString(8, ""+ledgerLocalAmount[i]);
		//out.print("<br>ledgerLocalAmount "+ledgerLocalAmount[i]);
		pstmt_p.setString(9, ""+ledgerAmount[i]);
		//out.print("<br>ledgerAmount "+ledgerAmount[i]);
		pstmt_p.setString(10,""+D);
		//out.print("<br>D "+D);
		pstmt_p.setString(11,""+user_id);
		//out.print("<br>user_id "+user_id);
		pstmt_p.setString(12,""+machine_name);
		//out.print("<br>machine_name "+machine_name);
		pstmt_p.setString(13,""+ledger[i]);
		//out.print("<br>ledger "+ledger[i]);
		pstmt_p.setString(14,""+format.getDate(datevalue));
		//out.print("<br>datevalue "+datevalue);
		pstmt_p.setString(15,""+purchase_no);
		//out.print("<br>purchase_no "+purchase_no);
		pstmt_p.setString(16,""+Receive_id);
		//out.print("<br>Receive_id "+Receive_id);

		String ReceiveFrom_LedgerId=A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2");

		pstmt_p.setString(17,""+ReceiveFrom_LedgerId);
		//out.print("<br>ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);
		pstmt_p.setString(18,""+exchange_rate);
		//out.print("<br>exchange_rate "+exchange_rate);
		pstmt_p.setString (19,yearend_id);
		//out.print("<br>yearend_id "+yearend_id);
		pstmt_p.setString (20,ledgerPercent[i]); //currently saving the ledger percentage in the field cheque_no of the FT
		//out.print("<br>ledgerPercent "+ledgerPercent[i]);
		pstmt_p.setString(21,""+ftid[i]);
		//out.print("<br>transaction_id "+transaction_id);

		int a525 = pstmt_p.executeUpdate();
		pstmt_p.close();
	}

	else if (  "0".equals(ftid[i]) && !("yes".equals(deleteLedger[i])) )//new row with deleted checkbox unchecked
	{
		query="insert into Financial_Transaction (Tranasaction_Id, Company_Id, Voucher_Id, Sr_No, For_Head, For_HeadId, Transaction_Type, Amount, Local_Amount, Dollar_Amount, Modified_On, Modified_By, Modified_MachineName, Ledger_Id, Transaction_Date, Tranasaction_No, Receive_Id, ReceiveFrom_LedgerId, Exchange_Rate, YearEnd_Id, Cheque_No) values (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)";
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString(1,""+transaction_id);
		//out.print("<br>transaction_id "+transaction_id);
		pstmt_p.setString(2,""+company_id);
		//out.print("<br>company_id "+company_id);
		pstmt_p.setString(3,""+testvoucher_id);
		//out.print("<br>testvoucher_id "+testvoucher_id);
		pstmt_p.setString(4,""+(i+1));

		String for_head=A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
		pstmt_p.setString(5,""+for_head);
		//out.print("<br>for_head "+for_head);
		String forhead_id=A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);
		//out.print("<br>forhead_id "+forhead_id);
		pstmt_p.setString(6,""+forhead_id);
		
		if("1".equals(debitcredit[i]))
			pstmt_p.setString(7,"1");
		else
			pstmt_p.setString(7,"0");
		//out.print("<br>debitcredit "+debitcredit[i]);
		
		if("local".equals(currency))
			pstmt_p.setString (8, ""+ledgerLocalAmount[i]);	
		else
			pstmt_p.setString (8, ""+ledgerAmount[i]);	

		//out.print("<br>currency "+currency);
		pstmt_p.setString(9, ""+ledgerLocalAmount[i]);
		//out.print("<br>ledgerLocalAmount "+ledgerLocalAmount[i]);
		pstmt_p.setString(10, ""+ledgerAmount[i]);
		//out.print("<br>ledgerAmount "+ledgerAmount[i]);
		pstmt_p.setString(11,""+D);
		//out.print("<br>D "+D);
		pstmt_p.setString(12,""+user_id);
		//out.print("<br>user_id "+user_id);
		pstmt_p.setString(13,""+machine_name);
		//out.print("<br>machine_name "+machine_name);
		pstmt_p.setString(14,""+ledger[i]);
		//out.print("<br>ledger "+ledger[i]);
		pstmt_p.setString(15,""+format.getDate(datevalue));
		//out.print("<br>datevalue "+datevalue);
		pstmt_p.setString(16,""+purchase_no);
		//out.print("<br>purchase_no "+purchase_no);
		pstmt_p.setString(17,""+Receive_id);
		//out.print("<br>Receive_id "+Receive_id);

		String ReceiveFrom_LedgerId=A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2");

		pstmt_p.setString(18,""+ReceiveFrom_LedgerId);
		//out.print("<br>ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);
		pstmt_p.setString(19,""+exchange_rate);
		//out.print("<br>exchange_rate "+exchange_rate);
		pstmt_p.setString (20,yearend_id);
		//out.print("<br>yearend_id "+yearend_id);
		pstmt_p.setString (21,ledgerPercent[i]); //currently saving the ledger percentage in the field cheque_no of the FT
		//out.print("<br>ledgerPercent "+ledgerPercent[i]);

		int a525 = pstmt_p.executeUpdate();
		pstmt_p.close();
		
		transaction_id++;
	}
}//end of for

//out.print("<br><br>Ledgers inserted");
		int temp_lot_loc_id=0;
temp_lot_loc_id=L.get_master_id(conp,"LotLocation");

//Updating the lot location table
for(int i=0;i<lotRows;i++)
{

	if( (!("0".equals(oldlotid[i]))) && (!(lotid[i].equals(oldlotid[i])))   )//the lot itself is changed while editing
	{
		//adding the quantity for the new lot
		int level = cong.getTransactionIsolation();
		cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
		pstmt_g = cong.prepareStatement(query);

		pstmt_g.setString(1,""+lotid[i]); 
		pstmt_g.setString(2,""+location_id0); 
		pstmt_g.setString(3,""+company_id); 
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
		fincarats = fincarats  +  Double.parseDouble(qty[i]);
		phycarats = phycarats +  Double.parseDouble(qty[i]);
		


		if(p>0)
		{
			query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
		
			pstmt_p = conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+fincarats); 
			pstmt_p.setString(2,""+phycarats); 
			pstmt_p.setString (3, user_id);		
			pstmt_p.setString (4, machine_name);		
			pstmt_p.setString(5,lotid[i]); 
			pstmt_p.setString(6,location_id0); 
			pstmt_p.setString(7,company_id); 

			int a417 = pstmt_p.executeUpdate();
		
			pstmt_p.close();
		}
		else{
			
			query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D+"',? ,?,?)";
			pstmt_p = conp.prepareStatement(query);

			//pstmt_p.setString (1, ""+ L.get_master_id(cong,"LotLocation"));	
			pstmt_p.setString (1,""+temp_lot_loc_id);
			pstmt_p.setString (2,location_id0);
			pstmt_p.setString (3,lotid[i]);
			pstmt_p.setString (4,company_id);
			pstmt_p.setString (5,""+fincarats);	
			pstmt_p.setString (6, ""+phycarats);	
			pstmt_p.setString (7, user_id);		
			pstmt_p.setString (8, machine_name);		
			pstmt_p.setString (9,yearend_id);
		
			int a435 = pstmt_p.executeUpdate();
temp_lot_loc_id=temp_lot_loc_id+1;
			pstmt_p.close();
		}

		//submitting the quantity for the old lot
		level = cong.getTransactionIsolation();
		cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
		pstmt_g = cong.prepareStatement(query);

		pstmt_g.setString(1,""+oldlotid[i]); 
		pstmt_g.setString(2,""+location_id0); 
		pstmt_g.setString(3,""+company_id); 
		rs_g = pstmt_g.executeQuery();

		fincarats=0;
		phycarats=0;
		p=0;

		while(rs_g.next()) 	
		{
			fincarats= rs_g.getDouble("Carats");	
			phycarats= rs_g.getDouble("Available_Carats");	
			p++;
		}
		pstmt_g.close();
		cong.setTransactionIsolation(level);
		fincarats = fincarats - Double.parseDouble(oldqty[i]); 
		phycarats = phycarats - Double.parseDouble(oldqty[i]);
		
		
		if(p>0)
		{
			query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
		
			pstmt_p = conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+fincarats); 
			pstmt_p.setString(2,""+phycarats); 
			pstmt_p.setString (3, user_id);		
			pstmt_p.setString (4, machine_name);		
			pstmt_p.setString(5,oldlotid[i]); 
			pstmt_p.setString(6,location_id0); 
			pstmt_p.setString(7,company_id); 

			int a417 = pstmt_p.executeUpdate();
		
			pstmt_p.close();
		}
		else{
			
			query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D+"',? ,?,?)";
			pstmt_p = conp.prepareStatement(query);

			pstmt_p.setString (1, ""+ L.get_master_id(cong,"LotLocation"));	
			pstmt_p.setString (2,location_id0);
			pstmt_p.setString (3,oldlotid[i]);
			pstmt_p.setString (4,company_id);
			pstmt_p.setString (5,""+fincarats);	
			pstmt_p.setString (6, ""+phycarats);	
			pstmt_p.setString (7, user_id);		
			pstmt_p.setString (8, machine_name);		
			pstmt_p.setString (9,yearend_id);
		
			int a435 = pstmt_p.executeUpdate();

			pstmt_p.close();
		}

	}//end of if
	else
	{
		int level = cong.getTransactionIsolation();
		cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
		pstmt_g = cong.prepareStatement(query);

		pstmt_g.setString(1,""+lotid[i]); 
		pstmt_g.setString(2,""+location_id0); 
		pstmt_g.setString(3,""+company_id); 
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
		fincarats = fincarats - Double.parseDouble(oldqty[i]) +  Double.parseDouble(qty[i]);
		phycarats = phycarats - Double.parseDouble(oldqty[i]) +  Double.parseDouble(qty[i]);
		
		
		if(p>0)
		{
			query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
		
			pstmt_p = conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+fincarats); 
			pstmt_p.setString(2,""+phycarats); 
			pstmt_p.setString (3, user_id);		
			pstmt_p.setString (4, machine_name);		
			pstmt_p.setString(5,lotid[i]); 
			pstmt_p.setString(6,location_id0); 
			pstmt_p.setString(7,company_id); 

			int a417 = pstmt_p.executeUpdate();
		
			pstmt_p.close();
		}
		else{
			
			query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+D+"',? ,?,?)";
			pstmt_p = conp.prepareStatement(query);

			pstmt_p.setString (1, ""+ L.get_master_id(cong,"LotLocation"));	
			pstmt_p.setString (2,location_id0);
			pstmt_p.setString (3,lotid[i]);
			pstmt_p.setString (4,company_id);
			pstmt_p.setString (5,""+fincarats);	
			pstmt_p.setString (6, ""+phycarats);	
			pstmt_p.setString (7, user_id);		
			pstmt_p.setString (8, machine_name);		
			pstmt_p.setString (9,yearend_id);
		
			int a435 = pstmt_p.executeUpdate();

			pstmt_p.close();
		}

	}//end of else
}
//out.print("<br><br>Lot Location Updated");

conp.commit();
dataCommitted = true;

currReceive_Id = ""+Receive_id;


if( ("SAVE".equals(command) ) && dataCommitted)
{%>
<html>

	<head></head>
	<body background="../Buttons/BGCOLOR.JPG" >
	<script language="JavaScript">
	<!--
		alert("Data Updated Successfully");
		window.close();
	//-->
	</script>
	</body>
</html>
<%}

}//end if 

C.returnConnection(cong);
C.returnConnection(conp);

}
catch(Exception Samyak188){ 

conp.rollback();
%>
<html>

	<head></head>
	<body background="../Buttons/BGCOLOR.JPG" >
	<script language="JavaScript">
	<!--
		alert("Error : <%=Samyak188%>");
		window.close();
	//-->
	</script>
	</body>
</html>
<%
C.returnConnection(cong);
C.returnConnection(conp);
out.println("<font color=red> FileName : cgtConfirmOrPurchaseEditFormUpdate.jsp <br>Bug No Samyak188 <br>Please Contact Samyak Admin <br> bug is  "+ Samyak188 +"</font>");

}
%> 