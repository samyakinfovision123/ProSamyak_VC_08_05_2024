<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<%
String errLine="9";
ResultSet rs_g= null;
Connection conp = null;
Connection cong = null;
Connection conm = null;
Connection conlot = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_m=null;
try	
{
	conp=C.getConnection();
	cong=C.getConnection();
	conm=C.getConnection();
	conlot=C.getConnection();
}
catch(Exception e31)
{ 
out.println("<font color=red> FileName : InvSell.jsp<br>Bug No e31 : "+ e31);
}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String user_name=A.getName(conp,"User",user_id);
String yearend_id= ""+session.getValue("yearend_id");

////out.print("<br>user_name="+user_name);
%>
<html>
<head>
<title>  Samyak Software </title>
<script language="JavaScript">
function disrtclick()
{
window.event.returnValue=0;
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>

<% 

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
String today_string= format.format(D);

//out.print(" DATE today_date "+today_date);

// logic to get local currecy 
String local_currencyid= I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
//String base_exchangerate= I.getLocalExchangeRate(company_id);

errLine="64";
String command=request.getParameter("command");
//out.println("command"+command);
//C.returnConnection(conp);
//out.print("<br>67");
if("UPDATE".equals(command))
{
try{
String category_id=request.getParameter("category_id");
String receive_id=request.getParameter("receive_id");
String purchasesalegroup_id=request.getParameter("purchasesalegroup_id");
errLine="75";
//out.println("<br>receive_id:"+receive_id);
/*String ref_no="";
String description="";
String tempv="";
tempv=""+A.getNameCondition(conp,"Voucher","Voucher_Id","where Voucher_No='"+receive_id+"'");
ref_no=""+A.getNameCondition(conp,"Voucher","Ref_No","where Voucher_Id="+tempv);
out.print("<br>72 ref_no"+ref_no);
description=""+A.getNameCondition(conp,"Voucher","Description","where Voucher_Id="+tempv);
out.print("<br>74description "+description);*/
int cash_id=Integer.parseInt(request.getParameter("cash_id"));


int Fv_id=Integer.parseInt(request.getParameter("Finv_id"));
//out.print("<br>78 Fv_id "+Fv_id);

int  Iv_id=Integer.parseInt(request.getParameter("Inv_id"));
//out.print("<br>81 Iv_id "+Iv_id);
errLine="93";
String lots = request.getParameter("no_lots");
int total_lots=Integer.parseInt(lots);
int counter=total_lots-2;
//out.print("<br>counter "+counter);

String old_lots = request.getParameter("old_lots");

int deletedcount = Integer.parseInt(request.getParameter("deletedcount"));
//out.print("<br>deletedcount "+deletedcount );


int iold_lots=Integer.parseInt(old_lots);
//out.println("<br><font color=red>Old lots:</font>"+iold_lots);

int count=iold_lots;
errLine="109";
//out.print("<br>109");
int receive_lots=counter-deletedcount;
//out.print("<br>receive_lots"+receive_lots);

 //out.println("<br>Total Nos of old Rows:"+iold_lots);
 
String consignment_no = request.getParameter("consignment_no");
//out.print("<br>consignment_no "+consignment_no);
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
String oldreceive_no = request.getParameter("oldreceive_no");
int no_i=0;
//out.println("oldreceive_no:"+oldreceive_no);
//out.println("consignment_no:"+consignment_no);

if(oldreceive_no.equals(consignment_no))
{ 
//out.println("Same");
}
else
{ 
	errLine="131";
String noquery="Select * from  Receive where Receive_No=? and company_id=? and Receive_Sell=1";
//out.print("<br>noquery"+noquery);
pstmt_p = cong.prepareStatement(noquery);
pstmt_p.setString(1,consignment_no); 
pstmt_p.setString(2,company_id); 
rs_g = pstmt_p.executeQuery();

	while(rs_g.next()) 	
	{
	no_i++;
	}
	pstmt_p.close();
}
	if(no_i > 0)
	{
			//C.returnConnection(conp);
	%><body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
	<%
out.print("<br><center>Sale No "+consignment_no+ "already exist. </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1'></center>");
}
else
	{
	//out.print("<br>153=>under else ");
String query="";
String consignment_date = request.getParameter("datevalue");
//out.print("consignment_date"+consignment_date);
//out.print("<br>157=>");
String stockdate = request.getParameter("stockdate");
//out.print("stockdate----------------------------------------         "+stockdate);
//out.print("<br>160=>");
String salesperson_id=request.getParameter("salesperson_id");
String stockdateold= request.getParameter("stockdateold");
 //out.print("consignment_date"+consignment_date);
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);

String exchange_ratequery="Select * from Master_ExchangeRate where Exchange_Date=?";
pstmt_p=cong.prepareStatement(exchange_ratequery);
pstmt_p.setString(1,""+format.getDate(stockdate));
//out.print("<br>170=>"+stockdate);
rs_g=pstmt_p.executeQuery();
//out.print("<br>172=>");
int exchange=0;
//out.println("<br>102121212121 exchange_rate is"+exchange_rate);
//out.print("<br>175=>");
	while(rs_g.next())
		{
			//out.print("<br>178=>");
			exchange++;
		}
//	out.print("<br>181=>");
	pstmt_p.close();
//	out.print("<br>183=>");
conp.setAutoCommit(false);


//out.print("<br>187=>");
errLine="189";
if(exchange==0)
		{
		//out.print("<br> 191 ->if exchage_rate");
			int exchangerate_id= L.get_master_id(cong,"Master_ExchangeRate");
					//out.print("<br>exchangerate_id "+exchangerate_id);

			String currencyid=A.getNameCondition(cong,"Master_Currency","Currency_Id","where company_id="+company_id);
					//out.print("<br>icurrencyid "+currencyid);

			exchange_ratequery="Insert into Master_ExchangeRate(ExchangeRate_Id,Currency_Id,Exchange_Date,Exchange_Rate,Modified_By,Modified_On,Modified_MachineName,YearEnd_Id) values(?,?,?,?,?,?,?,?)";
			//out.print(exchange_ratequery);
			pstmt_p=conp.prepareStatement(exchange_ratequery);
			pstmt_p.setInt(1,exchangerate_id);
			pstmt_p.setString(2,currencyid);
				//out.print("<br>icurrencyid "+currencyid);

			pstmt_p.setString(3,""+format.getDate(stockdate));
			//out.print("<br>stockdate "+stockdate);
			
			pstmt_p.setString(4,""+exchange_rate);
			//out.print("<br>exchange_rate "+exchange_rate);

			pstmt_p.setString(5,user_id);
			//out.print("<br>user_id "+user_id);

			pstmt_p.setString(6,""+(today_date));
			//out.print("<br>today_date "+today_date);

			pstmt_p.setString(7,machine_name);
			//out.print("<br>machine_name "+machine_name);
			pstmt_p.setString(8,yearend_id);
			//out.print("<br>220=>");
			int a177=pstmt_p.executeUpdate();
			//out.print("<br>222=>");
			//out.print("<br> 206 No of rows Master_ExchageRate "+a177);
			pstmt_p.close();
		}


//out.print("<br>227=>");
String due_date = request.getParameter("finalduedate");
int duedays = Integer.parseInt(request.getParameter("finalduedays"));

//out.print("<br>duedays "+duedays);

String currency = request.getParameter("currency");
//out.print("<br>currency"+currency);
String companyparty_id= request.getParameter("companyparty_id");
 //out.println("111138company id is= "+companyparty_id);
String companyparty_name="";
String address1="";
String city="";
String country="";
String phone_off="";
String company_type="";

boolean receive_type= false; 
if("1".equals(company_type))
{receive_type=true;}

String receivetransaction_id[]=new String[counter];
String deleted[]=new String[counter];
String lot_id[]= new String[counter]; 
String newlot_id[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String lotno[]=new String[counter];

String pcs[]=new String[counter];
double old_quantity[]=new double[counter];
double originalQuantity[]=new double[counter];
double returnQuantity[]=new double[counter];
double ghat[]=new double[counter];
double quantity[]=new double[counter];
double rate[]=new double[counter];
double local_price[]=new double[counter];
double dollar_price[]=new double[counter];
double amount[]=new double[counter];
double local_amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String lotDiscount[]=new String[counter];
String remarks[]=new String[counter];
//out.print("<br><font color=red>counter=" +counter+"</font>");
//out.println("<br>102 exchange_rate is"+exchange_rate);
String responce_sale="";
//out.print("<br>269");
double totquantity=0;
double InvTotal=0;
for (int i=0;i<counter;i++)
{

//	out.print("<br>********** i -----> "+i);
receivetransaction_id[i]= ""+request.getParameter("receivetransaction_id"+i);
//out.println("<br>receivetransaction_id[i]"+receivetransaction_id[i]);


newlot_id[i]=""+request.getParameter("newlotid"+i);
 //out.print("<br>newlotid[i] "+newlot_id[i]);

deleted[i]=request.getParameter("deleted"+i);
//out.print("<br>deleted"+deleted[i]);


lotno[i]=""+request.getParameter("lotno"+i);

lot_id[i]=A.getNameCondition(conlot,"Lot","Lot_Id","where Lot_No='"+lotno[i]+"' and company_id="+company_id);
//out.print("<br>276 lot_id[p]"+lot_id[i]);


location_id[i]=""+request.getParameter("location_id"+i);
 //out.print("<br>location_id[i] "+location_id[i]);
//out.print("<br>  i -----> "+i);

newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
 //out.print("<br>newlocation_id[i] "+newlocation_id[i]);

pcs[i]=""+request.getParameter("pcs"+i);
//out.print("<br>pcs[i][i] "+pcs[i]);

old_quantity[i]= Double.parseDouble(request.getParameter("old_quantity"+i));
//out.println("<br><font color=red>old_quantity[i]"+old_quantity[i]+"</font>");
originalQuantity[i]= Double.parseDouble(request.getParameter("originalQuantity"+i));
returnQuantity[i]= Double.parseDouble(request.getParameter("returnQuantity"+i));
ghat[i]= Double.parseDouble(request.getParameter("ghat"+i));
quantity[i]= Double.parseDouble(request.getParameter("quantity"+i));
//out.println("<br>quantity[i]"+quantity[i]);
	

rate[i]= Double.parseDouble(request.getParameter("rate"+i)); 
amount[i]= Double.parseDouble(request.getParameter("amount"+i)); 
lotDiscount[i]=request.getParameter("lotDiscount"+i); 
if(!("yes".equals(deleted[i])))
{
	InvTotal+=amount[i];
}
if ("dollar".equals(currency))
	{
	dollar_price[i]=rate[i];
	dollar_amount[i]=amount[i];
	local_price[i]= rate[i] * exchange_rate;
	local_amount[i]= amount[i] * exchange_rate;
	responce_sale="export";
	}//if
else{
	dollar_price[i]=rate[i] / exchange_rate;
	dollar_amount[i]=amount[i] / exchange_rate;
	local_price[i]= rate[i]  ;
	local_amount[i]= amount[i] ;
	responce_sale="local";

}//else

remarks[i]=""+request.getParameter("remarks"+i); 
}//end for
//out.print("<br>totquantity "+totquantity);

int ledgers=Integer.parseInt(request.getParameter("ledgers"));
//out.print("<br>299 ledgers"+ledgers);
int org_ledgers=Integer.parseInt(request.getParameter("org_ledgers"));
//out.print("<br>301 org_ledgers"+org_ledgers);
String org_transacionid[]=new String[ledgers];
String findeleted[]=new String[ledgers];
String ledger[]=new String[ledgers];
double acamount[]=new double[ledgers];
String debitcredit[]=new String[ledgers];
double acamount_local[]=new double[ledgers];
double acamount_dollar[]=new double[ledgers];
errLine="351";
for (int i=0;i<ledgers;i++)
{
org_transacionid[i]=""+request.getParameter("org_transacionid"+i);
//out.print("<br>312 org_transacionid[i] "+org_transacionid[i]);
findeleted[i]=""+request.getParameter("findeleted"+i);
//out.print("<br>314 org_transacionid[i] "+org_transacionid[i]);
ledger[i]=request.getParameter("ledger"+i);
//out.print("<br>316 org_transacionid[i] "+org_transacionid[i]);
acamount[i]=Double.parseDouble(request.getParameter("acamount"+i));

//out.print("<br>318 org_transacionid[i] "+org_transacionid[i]);
if ("dollar".equals(currency))
	{
		acamount_local[i]=acamount[i] * exchange_rate;
		acamount_dollar[i]=acamount[i];
	}
else
	{
		acamount_dollar[i]=acamount[i] / exchange_rate;
		acamount_local[i]=acamount[i];
	}

debitcredit[i]=request.getParameter("debitcredit"+i);

if("-1".equals(debitcredit[i]))
	{
		debitcredit[i]="1";
	}
else{
	debitcredit[i]="0";
	}

//out.print("<br>336 org_transacionid[i] "+org_transacionid[i]);
}

double subtotal = Double.parseDouble(request.getParameter("subtotal"));
//out.print("<br>subtotal"+subtotal);
double discount =0;
//Double.parseDouble(request.getParameter("discount"));
//out.print("<br>discount"+discount);
double ctax = Double.parseDouble(request.getParameter("ctax"));
 //out.print("<br>ctax"+ctax);
double discount_amt =0;
//Double.parseDouble(request.getParameter("discount_amt"));
//out.print("<br>discount_amt"+discount_amt);
double ctax_amt = Double.parseDouble(request.getParameter("ctax_amt"));
//out.print("<br>ctax_amt"+ctax_amt);
double total = Double.parseDouble(request.getParameter("total"));
//out.print("<br>total"+total);

//out.print("<br>400");
double difference=Double.parseDouble(request.getParameter("difference"));
double difference_local=0,difference_dollar=0;
String diffdebit=request.getParameter("diffdebit");
//out.print("<br>404");
if("-1".equals(diffdebit))
	{}
else{difference= difference *-1;	}

if ("dollar".equals(currency))
	{
		difference_dollar=difference;
		difference_local=difference*exchange_rate;
	}
else
	{
		difference_local=difference;
		difference_dollar=difference/exchange_rate;
	}

double local_total=0;
double dollar_total=0;
boolean voucher_currency=false;
double InvLocalTotal=0;
double InvDollarTotal=0;
double ctax_amtlocal=0;
double ctax_amtdollar=0;
//out.print("<br>427");
String currency_id="";
if ("dollar".equals(currency))
	{
	voucher_currency=false;
	local_currencysymbol="$";
	currency_id="0";
	dollar_total= total;
	local_total= total * exchange_rate;
		ctax_amtlocal=ctax_amt * exchange_rate;
	ctax_amtdollar=ctax_amt;
	InvLocalTotal=InvTotal * exchange_rate;
	InvDollarTotal=InvTotal;

}//if
else{
	voucher_currency=true;
	currency_id=local_currencyid;
	local_total= total;
	dollar_total= total / exchange_rate ;
		ctax_amtdollar=ctax_amt / exchange_rate;
	ctax_amtlocal=ctax_amt;
InvDollarTotal=InvTotal / exchange_rate;
	InvLocalTotal=InvTotal;

}//else
int j=0;
int flag= 0;
int final_flag=1; 
double carats[]=new double[counter] ;
double av_carats[]=new double[counter] ;
double receive_quantity=0;
//out.print("******** ");
if(final_flag==1)	
{
cong.setTransactionIsolation(java.sql.Connection.TRANSACTION_READ_UNCOMMITTED);
//out.print("<br>449 count="+count);

int temp_lot_loc_id=0;
temp_lot_loc_id=L.get_master_id(conp,"LotLocation");
for(int i=0; i<count; i++)
{
//out.print("<br> receivetransaction_id "+receivetransaction_id[i]);


//out.print("<br>455");
//out.print("<br>456 lot_id[i]="+lot_id[i]);
//out.print("<br>457 location_id[i]="+location_id[i]);

query="Select * from  LotLocation where Lot_Id=? and Location_id=? and Active=1";
//out.print("<br>457 query=" +query);
pstmt_p = cong.prepareStatement(query);
pstmt_p.setString(1,lot_id[i]); 
pstmt_p.setString(2,location_id[i]); 

 rs_g = pstmt_p.executeQuery();
double fincarats=0;
double phycarats=0;

int p=0;
	while(rs_g.next()) 	
	{
	fincarats= rs_g.getDouble("Carats");
//	out.print("<br>before->fincarats"+fincarats);
	phycarats= rs_g.getDouble("Available_Carats");
//	out.print("<br>before->phycarats"+phycarats);
	p++;
	}

//	out.print("******************p "+p);
	pstmt_p.close();
double fincaratsnew=0;
double phycaratsnew=0;

fincaratsnew=fincarats+(old_quantity[i]-quantity[i]);
phycaratsnew=phycarats+(old_quantity[i]-quantity[i]);
//out.print("<br>New LotLocation Qty->fincarats"+fincaratsnew);
//out.print("<br>New LotLocation Qty->phycarats"+phycaratsnew);

//out.print("<br>502");
if("yes".equals(deleted[i]))
{
//	out.print("<br>Inside If");
//	out.print("<br>Quantity  "+quantity[i] );

//out.print("<br>before->fincarats"+fincarats);
//out.print("<br>before->phycarats"+phycarats);

phycarats=phycarats+old_quantity[i];
fincarats=fincarats+old_quantity[i];

//out.print("<br>514");
query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString(1,"0"); 
pstmt_p.setString(1,""+fincarats); 
pstmt_p.setString(2,""+phycarats); 
pstmt_p.setString (3, user_id);		
pstmt_p.setString (4, machine_name);		
pstmt_p.setString(5,lot_id[i]); 
pstmt_p.setString(6,location_id[i]); 
pstmt_p.setString(7,company_id); 
//out.println("Before Query <br>"+query);
 int a417 = pstmt_p.executeUpdate();
out.println("<br>507 Data Successfully updated in lot table <br>");
pstmt_p.close();


query="Update Receive_Transaction set active= ? where ReceiveTransaction_Id=? ";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1, false);		
pstmt_p.setString(2,receivetransaction_id[i]);		
  a417 = pstmt_p.executeUpdate();
 pstmt_p.close();
//out.println("<br>494 Data Successfully updated in RT table <br>");



//out.print("<br>542");
}//end if deleted purchase

else
	{
	//out.print("<br>547 else loop");
//out.print("<br> Lot_id "+lot_id[i]);
//out.print("<br> newlot_id "+newlot_id[i]);

//out.print("<br> location_id "+location_id[i]);
//out.print("<br> newlocation_id "+newlocation_id[i]);
	totquantity=totquantity+quantity[i];
		//out.print("<br><b>------------------------Lot No & Location UnChanged1111111111111111111111111111111111111</b>");
//out.print("<br>555");
if(lot_id[i].equals(newlot_id[i]) && location_id[i].equals(newlocation_id[i]))
	{

		//out.print("<br><b>------------------------Lot No & Location UnChanged--------------------------</b>");

		query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString(1,""+fincaratsnew); 
		//out.print("<br><b>LotLocation New Qty Updated "+fincaratsnew+"</b>");
		pstmt_p.setString(2,""+phycaratsnew); 
		//out.print("<br><b>LotLocation New Qty Updated "+phycaratsnew+"</b>");
		pstmt_p.setString (3, user_id);		
		pstmt_p.setString (4, machine_name);		
		pstmt_p.setString(5,lot_id[i]); 
		pstmt_p.setString(6,location_id[i]); 
		pstmt_p.setString(7,company_id); 
		//out.print("<br>574");
		int a417 = pstmt_p.executeUpdate();
		//out.print("<br>541 Row update LotLocation -------->"+a417 );
		pstmt_p.close();
		//out.print("<br>578");

	}//end if Lot or Location is not changed
else
	{

		//out.print("<br>584 ");
		query="select * from LotLocation where Lot_Id=? and Location_Id=?"; 
		pstmt_p = cong.prepareStatement(query);
		pstmt_p.setString(1,lot_id[i]); 
		pstmt_p.setString(2,location_id[i]); 

		 rs_g = pstmt_p.executeQuery();
		double originalphy=0;
		double originalfin=0;
		 while(rs_g.next())
		{
			originalphy=rs_g.getDouble("Carats");
			originalfin=rs_g.getDouble("Available_Carats");
		}

		pstmt_p.close();
		originalphy=originalphy+old_quantity[i];
		originalfin=originalfin+old_quantity[i];
//		out.print("<br>originalphy "+originalphy);
//		out.print("<br>originalfin "+originalfin);
		
		query="Update LotLocation set Carats=?, Available_Carats=? where Lot_Id=? and Location_Id=?";
		pstmt_p=conp.prepareStatement(query);
		pstmt_p.setString(1,""+originalphy); 
		pstmt_p.setString(2,""+originalfin); 
		pstmt_p.setString(3,lot_id[i]); 
		pstmt_p.setString(4,location_id[i]); 

		int a528=pstmt_p.executeUpdate();
		pstmt_p.close();
		//out.print("577 Ulta LotLocation");

		query="select * from LotLocation where Lot_Id=? and Location_Id=?";
		pstmt_p=cong.prepareStatement(query);
		pstmt_p.setString(1,""+newlot_id[i]);
//		out.print("<br>Lot-Id<font color=red>"+newlot_id[i]+"</font>");
		pstmt_p.setString(2,""+newlocation_id[i]);
//		out.print("<br>Location_Id<font color=red>"+newlocation_id[i]+"</font>");

		rs_g=pstmt_p.executeQuery();
		int lotlocationpresent=0;
		double newlotlocationcarats=0;
		double newlotlocationav_carats=0;
	//	out.print("<br>627");
		while(rs_g.next())
		{
			lotlocationpresent++;
			newlotlocationcarats=rs_g.getDouble("Carats");
			newlotlocationav_carats=rs_g.getDouble("Available_Carats");

		}
		pstmt_p.close();
		//out.print("2222222222222222222222222222222222222Ulta LotLocation "+lotlocationpresent+" <br>");		


		
		if(lotlocationpresent==0)  //no Record for new lot & new location
		{

		//	out.print("<br>641");
			//out.print("333333333333333333333333333333333Insert");
			//int insertLotLocation_id=L.get_master_id(conp,"LotLocation");
			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Carats, Available_Carats, Optimum_Quantity, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?, ?,?,?,?, ?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);

			//pstmt_p.setString(1,""+insertLotLocation_id);
			pstmt_p.setString (1,""+temp_lot_loc_id);
			
			pstmt_p.setString(2,newlocation_id[i]);
			
			pstmt_p.setString(3,company_id);
			pstmt_p.setString(4,newlot_id[i]);
			pstmt_p.setDouble(5,quantity[i]);
			pstmt_p.setDouble(6,quantity[i]);
			
			pstmt_p.setString(7,"0");
			pstmt_p.setString(8,""+(today_date));
			pstmt_p.setString(9,user_id);
			pstmt_p.setString(10,machine_name);
			pstmt_p.setString(11,yearend_id);
			int a571=pstmt_p.executeUpdate();
			pstmt_p.close();
		//	out.print("<br>661");
    		//out.print("<br>622 LotLocation Row Inserted <br> No of Rows "+a571);
temp_lot_loc_id=temp_lot_loc_id+1;
		}//end if newlot is not present at new location 
		else
		{

		//	out.print("<br>668");
			//Update
//---Update quantity for new lot & location's record in lotlocation i.e new quantity added---
//out.print("4444444444444444444444444444444444Update");

			newlotlocationcarats=newlotlocationcarats-quantity[i];
			newlotlocationav_carats=newlotlocationav_carats-quantity[i];

			query="Update LotLocation set Carats=?, Available_Carats=?, Modified_On=?, Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_Id=?";
			pstmt_p=conp.prepareStatement(query);
			pstmt_p.setString(1,""+newlotlocationcarats);
			pstmt_p.setString(2,""+newlotlocationav_carats);
			pstmt_p.setString(3,""+(today_date));
			pstmt_p.setString(4,""+user_id);
			pstmt_p.setString(5,""+machine_name);
			pstmt_p.setString(6,newlot_id[i]);
			pstmt_p.setString(7,newlocation_id[i]);

			int a601=pstmt_p.executeUpdate();
			pstmt_p.close();

			//out.print("<br>647 LotLocation Updated");
		}//end new lot is not present at new location
	//out.print("<br>691");
	}
	//out.print("<br>694");
		query="Update Receive_Transaction set Lot_Id=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, Dollar_Price=?, Pieces=?, Remarks=?, Original_Quantity=?, Return_Quantity=?, Lot_Discount=? , Modified_On=?, Modified_By=?, Modified_MachineName=?, Location_Id=? where ReceiveTransaction_Id=?";
		
		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,newlot_id[i]);
		pstmt_p.setString(2,""+quantity[i]);
		pstmt_p.setString(3,""+quantity[i]);
		pstmt_p.setDouble(4,rate[i]);
		pstmt_p.setDouble(5,local_price[i]);
		pstmt_p.setDouble(6,dollar_price[i]);
		pstmt_p.setString(7,""+pcs[i]);
		pstmt_p.setString(8,""+remarks[i]);
		pstmt_p.setDouble(9,originalQuantity[i]);
		pstmt_p.setDouble(10,+returnQuantity[i]);
		pstmt_p.setString(11,""+lotDiscount[i]);
		pstmt_p.setString(12,""+(today_date));
		pstmt_p.setString(13,""+user_id);
		pstmt_p.setString(14,machine_name);
		pstmt_p.setString(15,newlocation_id[i]);
		pstmt_p.setString(16,receivetransaction_id[i]);

		int a653=pstmt_p.executeUpdate();
		pstmt_p.close();
		//out.print("<br>671 Receive Transaction Updated");
	}//end else
	//out.print("<br>717");
}//for original rows edited
errLine="722";
int toby_nos=ledgers;
for(int i=0;i<org_ledgers;i++)
{
	errLine="727";
if("yes".equals(findeleted[i]))
{toby_nos --;
query="Update Financial_Transaction set Active=? where Tranasaction_Id="+org_transacionid[i];
errLine="731";
pstmt_p=conp.prepareStatement(query);
errLine="732";
pstmt_p.setBoolean(1,false);
//int a678=pstmt_p.executeUpdate();
//out.print("<br>684 FT ");
pstmt_p.close();
errLine="737";
}
else{
	//out.print("<br>727");
//	out.print("<br>734");
query="Update Financial_Transaction set For_Head=?, For_HeadId=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Ledger_Id=?, Exchange_Rate=?, Transaction_Date=?, Tranasaction_No=?, ReceiveFrom_LedgerId=?, Active=? where Tranasaction_Id="+org_transacionid[i];
//out.print("<br>744");
pstmt_p=conp.prepareStatement(query);
//out.print("<br>746 query=="+query);

String for_head=A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
//out.print("<br>749 for_head="+for_head);
pstmt_p.setString(1,""+for_head);

String forhead_id=A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);

pstmt_p.setString(2,""+forhead_id);
//out.print("<br>754 forhead_id="+forhead_id);

pstmt_p.setString(3,""+debitcredit[i]);
//out.print("<br>757 debitcredit[i]="+debitcredit[i]);
pstmt_p.setDouble(4,acamount[i]);
//out.print("<br>759 acamount[i]="+acamount[i]);
pstmt_p.setDouble(5,acamount_local[i]);
//out.print("<br>758");
pstmt_p.setDouble(6,acamount_dollar[i]);
//out.print("<br>759");
//out.print("<br>751");
pstmt_p.setString(7,""+format.getDate(today_string));
//out.print("<br>764");
pstmt_p.setString(8,""+user_id);
//out.print("<br>766");
pstmt_p.setString(9,""+machine_name);
//out.print("<br>768");
pstmt_p.setString(10,""+ledger[i]);
//out.print("<br>770 ledger[i]="+ledger[i]);
pstmt_p.setString(11,""+exchange_rate);
//out.print("<br>772 exchange_rate="+exchange_rate);
pstmt_p.setString(12,""+format.getDate(consignment_date));
//out.print("<br>774 consignment_date="+format.getDate(consignment_date));
pstmt_p.setString(13,""+consignment_no);
//out.print("<br>776 consignment_no="+consignment_no);
String ReceiveFrom_LedgerId=A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=1");
//out.print("<br>777 ReceiveFrom_LedgerId="+ReceiveFrom_LedgerId);
pstmt_p.setString(14,""+ReceiveFrom_LedgerId);
//out.print("<br>779 ReceiveFrom_LedgerId="+ReceiveFrom_LedgerId);
pstmt_p.setBoolean(15,true);
//out.print("<br>781");
int a674=pstmt_p.executeUpdate();
//out.print("<br>783 a674 ="+a674);
pstmt_p.close();

//out.print("<br>786");
}
}
//out.print("<br>784");
int newreceivetransaction_id= L.get_master_id(cong,"Receive_Transaction");
	//out.print("<br>786 counter="+counter);
for(int i=count; i<counter; i++)
{
		
		//out.print("<br>789For Added");
		totquantity=totquantity+quantity[i];
	//out.print("<br>779");
	//out.print("<br>792");
		query="select * from LotLocation where Lot_Id=? and Location_Id=?";
		pstmt_p = cong.prepareStatement(query);
		//out.print("<br>795 query="+query);
		
		pstmt_p.setString(1,newlot_id[i]); 
		pstmt_p.setString(2,newlocation_id[i]);
		rs_g=pstmt_p.executeQuery();
		
		int newlotlocation=0;
		double addlotlocationcarat=0;
		double addlotlocationav_carat=0;
     //out.print("<br>803");
		while(rs_g.next())
		{
			newlotlocation++;
			addlotlocationcarat=rs_g.getDouble("Carats");
			//out.print("<br>808");
			addlotlocationav_carat=rs_g.getDouble("Available_Carats");
		//out.print("<br>810");
		}
		
		pstmt_p.close();

//		out.print("<br> Select LotLocation");
		if(newlotlocation==0)
		{
			//Insert
			//out.print("<br>803 Inside if Present");
			int newinsertLotLocation_id=L.get_master_id(conp,"LotLocation");

			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+newinsertLotLocation_id);
			pstmt_p.setString(2,newlocation_id[i]);
			pstmt_p.setString(3,company_id);
			//out.print("<br>828");
			pstmt_p.setString(4,newlot_id[i]);
			//out.print("<br>813");
			pstmt_p.setString(5,""+quantity[i]);
			//out.print("<br>831");
			pstmt_p.setString(6,""+quantity[i]);
			pstmt_p.setString(7,""+(today_date));
			pstmt_p.setString(8,user_id);
			pstmt_p.setString(9,machine_name);
			pstmt_p.setString(10,yearend_id);
			int ax=pstmt_p.executeUpdate();
			pstmt_p.close();
		//out.print("<br>774 Insert LotLocation");


		}
		else
		{
			//Update
			
		//	out.print("<br>830 ");
			addlotlocationcarat=addlotlocationcarat-quantity[i];
			addlotlocationav_carat=addlotlocationav_carat-quantity[i];
			
//			out.print("<br> Select LotLocation");

			query="Update LotLocation set Carats=?, Available_Carats=? where Lot_Id=? and Location_Id=?";
			pstmt_p=conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+addlotlocationcarat);
			pstmt_p.setString(2,""+addlotlocationav_carat);

			pstmt_p.setString(3,""+newlot_id[i]);
			pstmt_p.setString(4,""+newlocation_id[i]);

			int bx=pstmt_p.executeUpdate();

	//	out.print("<br>846 Update LotLocation");
			pstmt_p.close();
		}
//out.print("////////// ");
	//	int newreceivetransaction_id= L.get_master_id(conp,"Receive_Transaction");

		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Original_Quantity, Quantity, Available_Quantity, Receive_Price, Local_Price, Dollar_Price, Pieces, Remarks, Return_Quantity, Lot_Discount, Modified_On, Modified_By, Modified_MachineName, Location_Id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?)";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+newreceivetransaction_id);
	//	out.print(" <br>newreceivetransaction_id "+ newreceivetransaction_id);
		pstmt_p.setString(2,""+receive_id);
//		out.print(" <br>receive_id "+ receive_id);
		pstmt_p.setString(3,""+newreceivetransaction_id);
//		out.print(" <br>newreceivetransaction_id "+newreceivetransaction_id );
		pstmt_p.setString(4,""+newlot_id[i]);
//		out.print(" <br> newlot_id[i]"+newlot_id[i] );
		pstmt_p.setDouble(5,originalQuantity[i]);
		pstmt_p.setString(6,""+quantity[i]);
//		out.print(" <br>quantity[i] "+quantity[i] );
		pstmt_p.setString(7,""+quantity[i]);
//		out.print(" <br>quantity[i] "+quantity[i] );
		pstmt_p.setDouble(8,rate[i]);
//		out.print(" <br>rate[i] "+ rate[i]);
		pstmt_p.setDouble(9,local_price[i]);
//		out.print(" <br>local_price[i] "+local_price[i] );
		
		pstmt_p.setDouble(10,dollar_price[i]);
//		out.print(" <br> dollar_price[i]"+ dollar_price[i]);
		pstmt_p.setString(11,""+pcs[i]);
//		out.print(" <br>pcs[i] "+pcs[i] );
		pstmt_p.setString(12,""+remarks[i]);
		pstmt_p.setDouble(13,returnQuantity[i]);
		pstmt_p.setString(14,""+lotDiscount[i]);
//		out.print(" <br>remarks[i] "+remarks[i] );
		pstmt_p.setString(15,""+(today_date));
//		out.print(" <br>today_date "+format.format(today_date) );
		
		pstmt_p.setString(16,""+user_id);
//		out.print(" <br>user_id "+ user_id);
		pstmt_p.setString(17,""+machine_name);
//		out.print(" <br>machine_name "+machine_name );
		pstmt_p.setString(18,""+newlocation_id[i]);
//		out.print(" <br>newlocation_id "+newlocation_id[i] );
		pstmt_p.setString(19,yearend_id);
		int a722=pstmt_p.executeUpdate();
		pstmt_p.close();
		//out.print("893 ");


newreceivetransaction_id++;
}//end for added rows insertion in receive_transaction
//out.print("<br>917");
int transaction_id=L.get_master_id(cong,"Financial_Transaction");

String testvoucher_id= A.getNameCondition(cong,"Voucher","Voucher_Id","Where Voucher_Type=1 and Voucher_No='"+receive_id+"'" );
//out.print("<br>902");
//out.print("<br> 806 testvoucher_id="+testvoucher_id);
String voucher_type= "1"; // See voucher Table Design 
errLine="908";
	//out.print("<br> 809org_ledgers"+org_ledgers);
	//out.print("<br> ledgers"+ledgers);
for(int i=org_ledgers;i<ledgers;i++)
{
	//out.print("<br> 851");
	query="insert into Financial_Transaction (Tranasaction_Id,Company_Id,Voucher_Id,Sr_No, For_Head,For_HeadId,Transaction_Type,Amount, Local_Amount,Dollar_Amount,Modified_On,Modified_By, Modified_MachineName,Ledger_Id,Transaction_Date,Tranasaction_No, Receive_Id,ReceiveFrom_LedgerId,Exchange_Rate,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+transaction_id);
pstmt_p.setString(2,""+company_id);
pstmt_p.setString(3,""+testvoucher_id);
pstmt_p.setString(4,""+(i+1));
//out.print("<br>818 for_head ");

String for_head=A.getNameCondition(cong,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
pstmt_p.setString(5,""+for_head);
//out.print("<br>821 for_head "+for_head);

String forhead_id=A.getNameCondition(cong,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);
//out.print("<br>824 forhead_id "+forhead_id);

pstmt_p.setString(6,""+forhead_id);

pstmt_p.setString(7,""+debitcredit[i]);
pstmt_p.setDouble(8,acamount[i]);

pstmt_p.setDouble(9,acamount_local[i]);
pstmt_p.setDouble(10,acamount_dollar[i]);
pstmt_p.setString(11,""+format.getDate(today_string));
pstmt_p.setString(12,""+user_id);

pstmt_p.setString(13,""+machine_name);
pstmt_p.setString(14,""+ledger[i]);
pstmt_p.setString(15,""+format.getDate(consignment_date));
pstmt_p.setString(16,""+consignment_no);

pstmt_p.setString(17,""+receive_id);

String ReceiveFrom_LedgerId=A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=1");
//out.print("<br>843 ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);

pstmt_p.setString(18,""+ReceiveFrom_LedgerId);
//out.print("<br>Financial Transaction");

pstmt_p.setString(19,""+exchange_rate);
pstmt_p.setString(20,yearend_id);
//out.print("<br>Financial Transaction "+exchange_rate);
errLine="990";
int a525 = pstmt_p.executeUpdate();
//out.println(" <BR><br>904<font color=red>Financial_Transaction Updated Successfully: ?</font>" +a525);
pstmt_p.close();

transaction_id++;

}
//out.print("<br>960");

String transaction_idctax= A.getNameCondition(cong,"Financial_Transaction","Tranasaction_Id","where Voucher_Id="+testvoucher_id+" and Ledger_Id="+A.getNameCondition(conm,"Ledger","Ledger_Id","where Ledger_Name='C. Tax' and company_id="+company_id));

query="Update Financial_Transaction set Amount=?, Local_Amount=?, Dollar_Amount=? where Tranasaction_Id=?";

pstmt_p=conp.prepareStatement(query);

pstmt_p.setDouble(1,ctax_amt);
pstmt_p.setDouble(2,ctax_amtlocal);
pstmt_p.setDouble(3,ctax_amtdollar);
pstmt_p.setString(4,transaction_idctax);
//out.print("<br>972");
errLine="1011";
int a823=pstmt_p.executeUpdate();
//out.print("<br>974");
pstmt_p.close();
//out.println("<br>924 Data Successfully updated in lot table <br>");								
	String party_name= A.getName(cong,"companyparty",companyparty_id);
	String cmpy_name=A.getName(conp,"companyparty",company_id);
//out.print("<br>979");
	String narr="";
	//String refno=request.getParameter("refno");
	//out.print("<br> 942 purchasesalegroup_id : "+purchasesalegroup_id);
	
	query="Update Receive set Receive_No=?,Receive_Date=?,Receive_Lots=? ,Receive_Quantity=? ,Exchange_Rate=?,Receive_ExchangeRate=?,Tax= ?,Receive_Total=?,   Local_Total= ?,Dollar_Total= ?,Receive_FromId= ? ,Receive_FromName= ?     ,Company_Id= ?,Receive_ByName= ? ,Due_Days= ? ,Due_Date= ?   ,Modified_On= ?,Modified_By=?,Modified_MachineName= ?,stock_date=?,SalesPerson_Id=? , Difference_Amount=?, Difference_LocalAmount=?, Difference_DollarAmount=?, InvTotal=?,InvLocalTotal=?, InvDollarTotal=?,Receive_CurrencyId=?,Receive_Category=?, PurchaseSaleGroup_id="+purchasesalegroup_id+" where Receive_Id=?";

	pstmt_p=conp.prepareStatement(query);
	
		pstmt_p.setString(1,""+consignment_no); 
		//out.print("<br>consignment_no "+consignment_no);
		pstmt_p.setString(2,""+format.getDate(consignment_date)); 
		//out.print("<br>consignment_date "+consignment_date);
		pstmt_p.setString(3,""+(counter-deletedcount)); 
//		//out.print("<br> "+);
		pstmt_p.setString(4,""+totquantity); 
		//out.print("<br> totquantity"+totquantity);

		pstmt_p.setString(5,""+exchange_rate); 
		//out.print("<br> exchange_rate"+exchange_rate);
		pstmt_p.setString(6,""+exchange_rate); 
		//out.print("<br>exchange_rate "+exchange_rate);
		pstmt_p.setString(7,""+ctax); 
		//out.print("<br>ctax "+ctax);
		pstmt_p.setDouble(8,total); 
		//out.print("<br>total "+total);

		pstmt_p.setDouble(9,local_total); 
		//out.print("<br>local_total "+local_total);
		pstmt_p.setDouble(10,dollar_total); 
	//	out.print("<br>dollar_total "+dollar_total);
		pstmt_p.setString(11,""+companyparty_id); 
		//out.print("<br>companyparty_id "+companyparty_id);
		pstmt_p.setString(12,""+party_name); 
		//out.print("<br>party_name "+party_name);

		pstmt_p.setString(13,""+company_id); 
		//out.print("<br>company_id "+company_id);
		pstmt_p.setString(14,""+cmpy_name); 
		//out.print("<br>cmpy_name "+cmpy_name);
		pstmt_p.setString(15,""+duedays); 
		//out.print("<br>duedays "+duedays);
		pstmt_p.setString(16,""+format.getDate(due_date)); 
		//out.print("<br>due_date "+due_date);

		pstmt_p.setString(17,""+(today_date)); 
//		//out.print("<br> "+);
		
		pstmt_p.setString(18,""+user_id); 
		//out.print("<br>user_id "+user_id);
		pstmt_p.setString(19,""+machine_name); 
		//out.print("<br>machine_name "+machine_name);
		pstmt_p.setString(20,""+format.getDate(stockdate)); 
		//out.print("<br>stockdate "+stockdate);
		pstmt_p.setString(21,""+salesperson_id);
		//out.print("<br> salesperson_id"+salesperson_id);

pstmt_p.setDouble(22,difference);
pstmt_p.setDouble(23,difference_local);
pstmt_p.setDouble(24,difference_dollar);
	//out.print("<BR>951InvTotal="+InvTotal);

pstmt_p.setDouble(25,InvTotal);
pstmt_p.setDouble(26,InvLocalTotal);
pstmt_p.setDouble(27,InvDollarTotal);

pstmt_p.setString(28,""+currency_id);
//out.print("<br>currency_id"+currency_id);
		pstmt_p.setString(29,""+category_id);
		//pstmt_p.setString(30,narr);
		//pstmt_p.setString(31,refno);
		pstmt_p.setString(30,""+receive_id);

//out.print("<br>737 Last update inreceive ----->");
//out.print("<br>1052");
errLine="1091";
		int ay=pstmt_p.executeUpdate();
		pstmt_p.close();
//out.print("Last update inreceive ----->" +ay);
//out.print("<br>1054");
		//out.print("<br>1013voucherid"+testvoucher_id);

		query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(consignment_date)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?,ToBy_Nos=?,Ref_No=? where Voucher_Id=?";

	//	out.print("<BR>90" +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,receive_id);		
		//out.print("<br>1018 receiveid"+receive_id);
		//pstmt_p.setString(2,""+consignment_date);	
		//out.print("<br>1022consin"+consignment_date);
		pstmt_p.setString (2,""+exchange_rate);
		//out.print("<br>1020 exerate"+exchange_rate);
		pstmt_p.setDouble (3,total);	
		//out.print("<br>1026 vtotal"+total);
		pstmt_p.setDouble (4,local_total);	
		//out.print("<br>1028 ltotal"+local_total);
		pstmt_p.setDouble (5,dollar_total);
		//out.print("<br>1030dollar_total"+dollar_total);
		pstmt_p.setString (6,description);
		//out.print("<br>1032 desc"+description);
		/*pstmt_p.setString (8,narr);
		out.print("<br>1034 narr"+narr);*/
		pstmt_p.setString (7,user_id);	
		//out.print("<br>1036 uid"+user_id);
		pstmt_p.setString (8,machine_name);	
		//out.print("<br>1030m/c name"+machine_name);
		pstmt_p.setString (9,""+toby_nos);	
		//pstmt_p.setString(10,refno);
		pstmt_p.setString (10,ref_no);		
		//out.print("<br>1034ref_no"+ref_no);
		//out.print("<br>1034ref_no"+ref_no);
		pstmt_p.setString (11,""+testvoucher_id);		
		//out.print("<br>1038test"+testvoucher_id);
		//pstmt_p.setString (12,ref_no);		
errLine="1131";		
		int a6598 = pstmt_p.executeUpdate();

//out.print("<br>1042 a6598"+a6598);
		//out.println(" <BR><br>1023<font color=red>Voucher Updated Successfully: ?</font>" +a6598);
			pstmt_p.close();
		//out.print("<font class=star1><br><center>Data Successfully Updated.</center>");

	//-------------------------------------------------

 voucher_type=A.getNameCondition(cong,"Voucher","Voucher_Type","where Voucher_Id="+testvoucher_id);

/*
//---------------------------new block for tempFlag  13/01/2005 ------------------
String old_date=request.getParameter("old_date");
//out.print("<br>1056 old_date: "+old_date);
///out.print("<br>1057 consignment_date: "+consignment_date);
String temp_date="";

//out.print("<br>1060 old_date: "+temp1);
boolean temp = G.comapreDate(format.getDate(consignment_date),format.getDate(old_date));

//out.print("here");
if(temp)
{ temp_date=consignment_date;}
else
{ temp_date=old_date;}

String tempDate=G.getLastClosingDate(conp,company_id);
java.sql.Date LastClosingDate = format.getDate(tempDate);
boolean tempFlag = G.comapreDate(format.getDate(temp_date),LastClosingDate);
//------------------------------------------------------------------------------

if(tempFlag)
{
int testLog_id=L.get_master_id(conp,"Log");
query="Insert into Log (Log_Id, Company_Id, Voucher_No,Voucher_Date,  Voucher_Type, Insert_Update,  Actual_AmountLocal, Actual_AmountDollar,  Changed_AmountLocal, Changed_AmountDollar, Modified_On , Modified_By, Modified_MachineName, Active) values (?,?,?,'"+format.getDate(temp_date)+"', ?,?,?,?, ?,?,'"+D+"',?, ?,?)";

//out.print("<br>688  query6=" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+testLog_id);		
pstmt_p.setString(2,company_id); 
pstmt_p.setString(3,receive_id);
pstmt_p.setString(4,voucher_type);		

pstmt_p.setString (5,"1");    // 0 for insert or  1 for update
pstmt_p.setString (6,""+local_total);	
pstmt_p.setString (7,""+dollar_total);
pstmt_p.setString (8,""+local_total);
pstmt_p.setString (9,""+dollar_total);
pstmt_p.setString (10,user_id);	
pstmt_p.setString (11,machine_name);	

pstmt_p.setString (12,"1");	
int a = pstmt_p.executeUpdate();
//out.println(" <BR><br><font color=red>Voucher Updated Successfully: ?</font>" +a691);
pstmt_p.close();
}

//----------------------------
	*/
	
	
	//out.print("<br>1110Fv_id"+Fv_id);

	//out.print("<br>1112cashid"+cash_id);
//out.print("<br>1155");
	if(Fv_id==0 && cash_id>0)
	{
		int testvoucher_id1=L.get_master_id(conp,"Voucher");
		query="insert into voucher (Voucher_Id, Company_Id, Voucher_Type,Voucher_No, Voucher_Date, ToBy_Nos,  Voucher_Currency, Exchange_Rate, Voucher_Total, Local_Total, Dollar_Total , Description, Modified_By, Modified_On, Modified_MachineName,Referance_VoucherId,YearEnd_Id,Ref_No)values (?,?,?,?,'"+format.getDate(consignment_date)+"',?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";
		
		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+testvoucher_id1);
		pstmt_p.setString(2,company_id);
		pstmt_p.setString(3,"8");
		String vcurrency="";
		if(voucher_currency)
		{
			vcurrency="1";
		}
		else
		{
			vcurrency="0";
		}
		String v_no=Voucher.getAutoNumber(conp,8,vcurrency,company_id);
		pstmt_p.setString(4,""+v_no);
		pstmt_p.setString(5,"2");
		pstmt_p.setBoolean(6,voucher_currency);
		pstmt_p.setString(7,""+exchange_rate);
		pstmt_p.setDouble (8,total);	
		pstmt_p.setDouble (9,local_total);	
		pstmt_p.setDouble (10,dollar_total);
		pstmt_p.setString (11,description);
		//out.print("<br>1132 desc"+description);
		pstmt_p.setString (12,narr);
		pstmt_p.setString (13,user_id);	
		pstmt_p.setString (14,machine_name);
		//pstmt_p.setString(14,refno);
		pstmt_p.setString (15,""+testvoucher_id);	
		pstmt_p.setString(16,yearend_id);
		pstmt_p.setString(17,ref_no);
		//out.print("<br>1140 refno"+ref_no);
		//out.print("<br> 1193 ");
		errLine="1235";
		int a646=pstmt_p.executeUpdate();
		//out.print("<br> 1118");

		pstmt_p.close();

		transaction_id=L.get_master_id(conp,"Financial_Transaction");
		query="insert into Financial_Transaction (Tranasaction_Id,Company_Id,Voucher_Id,Sr_No, For_Head,For_HeadId,Transaction_Type,Amount, Local_Amount,Dollar_Amount,Modified_On,Modified_By, Modified_MachineName,Ledger_Id,Transaction_Date,Tranasaction_No, Receive_Id,ReceiveFrom_LedgerId,Exchange_Rate,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";

		pstmt_p=conp.prepareStatement(query);
//		out.print("<br> query "+query);

		pstmt_p.setString(1,""+transaction_id);
//		out.print("<br> transaction_id "+transaction_id);

		pstmt_p.setString(2,""+company_id);
//		out.print("<br> company_id "+company_id);

		pstmt_p.setString(3,""+testvoucher_id1);
//		out.print("<br> testvoucher_id1 "+testvoucher_id1);

		pstmt_p.setString(4,"1");
//		out.print("<br> total "+total);

		pstmt_p.setString(5,"1");
//		out.print("<br> total "+total);
		
		pstmt_p.setString(6,""+cash_id);
//		out.print("<br> cash_id "+cash_id);

		pstmt_p.setBoolean(7,false);
//		out.print("<br> total "+total);

		pstmt_p.setDouble (8,total);	
//		out.print("<br> total "+total);

		pstmt_p.setDouble (9,local_total);	
//		out.print("<br> local_total "+local_total);

		pstmt_p.setDouble (10,dollar_total);
//		out.print("<br> dollar_total"+dollar_total);

		pstmt_p.setString (11,""+format.getDate(today_string));
//		out.print("<br> today_string"+today_string);

		pstmt_p.setString (12,""+user_id);	
//		out.print("<br> user_id"+user_id);
		
		pstmt_p.setString (13,machine_name);	
//		out.print("<br> machine_name"+machine_name);
		
		pstmt_p.setString (14,"0");	
//		out.print("<br> today_string"+today_string);
		
		pstmt_p.setString (15,""+format.getDate(today_string));	
//		out.print("<br> today_string"+today_string);
		
		pstmt_p.setString (16,"0");	
//		out.print("<br> today_string"+today_string);
		
		pstmt_p.setString (17,"0");	
//		out.print("<br> today_string"+today_string);
		
		pstmt_p.setString (18,"0");	
//		out.print("<br> today_string"+today_string);

		pstmt_p.setString (19,""+exchange_rate);	
//		out.print("<br> exchange_rate"+exchange_rate);
	
		pstmt_p.setString(20,yearend_id);

	//	out.print("<br> 1264 ");
		int a676=pstmt_p.executeUpdate();
	//out.print("<br>1187 ");
		pstmt_p.close();

		transaction_id++;
		query="insert into Financial_Transaction (Tranasaction_Id,Company_Id,Voucher_Id,Sr_No, For_Head,For_HeadId,Transaction_Type,Amount, Local_Amount,Dollar_Amount,Modified_On,Modified_By, Modified_MachineName,Ledger_Id,Transaction_Date,Tranasaction_No, Receive_Id,ReceiveFrom_LedgerId,Exchange_Rate,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+transaction_id);
		pstmt_p.setString(2,""+company_id);
		pstmt_p.setString(3,""+testvoucher_id1);
		pstmt_p.setString(4,"2");

		pstmt_p.setString(5,"9");
		pstmt_p.setString(6,companyparty_id);
		pstmt_p.setBoolean(7,true);
		pstmt_p.setDouble (8,total);	
		pstmt_p.setDouble (9,local_total);	
		pstmt_p.setDouble (10,dollar_total);
		pstmt_p.setString (11,""+format.getDate(today_string));
		pstmt_p.setString (12,user_id);	
		pstmt_p.setString (13,machine_name);	
		pstmt_p.setString (14,""+A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head="+14+" and For_HeadId="+companyparty_id+" and Ledger_Type=1"));	
		pstmt_p.setString (15,""+format.getDate(today_string));	
		pstmt_p.setString (16,"0");	
		pstmt_p.setString (17,"0");	
		pstmt_p.setString (18,"0");	
		pstmt_p.setString (19,""+exchange_rate);	
		pstmt_p.setString(20,yearend_id);
//		out.print("<br> 750");
		int a706=pstmt_p.executeUpdate();
	//out.print("<br> 1218 ");
		pstmt_p.close();
		
		int payment_id=L.get_master_id(cong,"Payment_Details");
		query="insert into Payment_Details (Payment_Id, Voucher_Id, Company_Id, Payment_No, For_Head, For_HeadId, Transaction_Type, Transaction_Date, Payment_Mode, Amount, Local_Amount, Dollar_Amount, Exchange_Rate, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?)";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+payment_id);
		pstmt_p.setString(2,""+testvoucher_id1);
		pstmt_p.setString(3,""+company_id);
		pstmt_p.setString(4,v_no);

		pstmt_p.setString(5,"9");
		pstmt_p.setString(6,""+receive_id);
		pstmt_p.setBoolean(7,false);
		pstmt_p.setString(8,""+format.getDate(today_string));

		pstmt_p.setBoolean(9,true);
		pstmt_p.setDouble (10,total);	
		pstmt_p.setDouble (11,local_total);	
		pstmt_p.setDouble (12,dollar_total);
		
		pstmt_p.setString(13,""+exchange_rate);
		pstmt_p.setString (14,""+format.getDate(today_string));	
		pstmt_p.setString (15,user_id);	
		pstmt_p.setString (16,machine_name);	
		pstmt_p.setString(17,yearend_id);	
	
//		out.print("<br> 781 ");
		int a734=pstmt_p.executeUpdate();
		//out.print("<br> 1249 ");
		pstmt_p.close();

		query="Update Receive set ProActive=1 where Receive_Id="+receive_id;

		pstmt_p=conp.prepareStatement(query);

		int a916=pstmt_p.executeUpdate();
		pstmt_p.close();
	}
errLine="1343";
	if(Fv_id>0 && cash_id==0)
	{
		query="Update Voucher Set Active=0 where Voucher_Id="+Fv_id;
		
		pstmt_p=conp.prepareStatement(query);
//		out.print("<br> 1179 ");
		int a1180=pstmt_p.executeUpdate();	
//		out.print("<br> 1181 ");
		pstmt_p.close();

		query="Update Financial_Transaction set Active=0 where Voucher_Id="+Fv_id;
		pstmt_p=conp.prepareStatement(query);
//		out.print("<br> 1186 ");
		int a1187=pstmt_p.executeUpdate();
//		out.print("<br> 1188 ");

		pstmt_p.close();

		query="Update Payment_Details set Active=0 where Voucher_Id="+Fv_id;
		pstmt_p=conp.prepareStatement(query);
		
//		out.print("<br> 1195 ");
		int a1196=pstmt_p.executeUpdate();
//		out.print("<br> 1195 ");
		pstmt_p.close();

		query="Update Receive Set ProActive=0 where Receive_Id="+receive_id;
		pstmt_p=conp.prepareStatement(query);

		int a1200 = pstmt_p.executeUpdate();
		pstmt_p.close();
	}
//out.print("<br>1328fid"+Fv_id);
//out.print("<br>1329cashid"+cash_id);
	if(Fv_id>0 && cash_id>0)
	{
		query="Update Voucher set Voucher_Date=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where voucher_id="+Fv_id;
		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+format.getDate(consignment_date));
		pstmt_p.setString(2,""+exchange_rate);
		pstmt_p.setDouble (3,total);	
		pstmt_p.setDouble (4,local_total);	

		pstmt_p.setDouble (5,dollar_total);
		pstmt_p.setString (6,""+user_id);	
		pstmt_p.setString (7,""+format.getDate(today_string));	
		pstmt_p.setString (8,""+machine_name);	
		
		int a1219=pstmt_p.executeUpdate();
		pstmt_p.close();

		query="Update Financial_Transaction set For_HeadId=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Exchange_Rate=?, Transaction_Date=? where Voucher_Id="+Fv_id+" and For_Head=1";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+cash_id);
		pstmt_p.setDouble (2,total);	
		pstmt_p.setDouble (3,local_total);	
		pstmt_p.setDouble (4,dollar_total);

		pstmt_p.setString (5,""+format.getDate(today_string));	
		pstmt_p.setString (6,""+user_id);	
		pstmt_p.setString (7,""+machine_name);	
		pstmt_p.setString(8,""+exchange_rate);
		
		pstmt_p.setString(9,""+format.getDate(consignment_date));
		errLine="1449";
		int a1237=pstmt_p.executeUpdate();
		pstmt_p.close();
	

		query="Update Financial_Transaction set For_HeadId=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Ledger_Id=?, Exchange_Rate=?, Transaction_Date=? where Voucher_Id="+Fv_id+" and For_Head=9";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+companyparty_id);
		pstmt_p.setDouble (2,total);	
		pstmt_p.setDouble (3,local_total);	
		pstmt_p.setDouble (4,dollar_total);

		pstmt_p.setString (5,""+format.getDate(today_string));	
		pstmt_p.setString (6,""+user_id);	
		pstmt_p.setString (7,""+machine_name);	
		pstmt_p.setString (8,""+A.getNameCondition(cong,"Ledger","Ledger_Id","where For_Head="+14+" and For_HeadId="+companyparty_id+" and Ledger_Type=1"));	
		pstmt_p.setString(9,""+exchange_rate);
		
		pstmt_p.setString(10,""+format.getDate(consignment_date));
		errLine="1470";
		int a1256=pstmt_p.executeUpdate();
		pstmt_p.close();
	}


		
		
		}//if final-flag

		conp.commit();
		
	}//else invoice no is not present in recive
errLine="1443";	cong.setTransactionIsolation(java.sql.Connection.TRANSACTION_READ_COMMITTED);
	C.returnConnection(conp);
	C.returnConnection(cong);
	C.returnConnection(conm);
	C.returnConnection(conlot);

}//end try 
catch(Exception Samyak499)
{ 
	conp.rollback();
C.returnConnection(conp);
C.returnConnection(cong);
C.returnConnection(conm);
C.returnConnection(conlot);

out.println("<br><font color=red> errLine at "+errLine+" FileName : InvSellUpdate.jsp Bug No Samyak499 : "+ Samyak499);
}
}//end if ('Update')

%>

<script language="JavaScript">
function f1()
{
alert("Data Sucessfully Updated");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML>







