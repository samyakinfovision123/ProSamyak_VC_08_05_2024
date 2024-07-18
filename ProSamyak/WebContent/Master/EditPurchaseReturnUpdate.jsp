<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"  class="NipponBean.Array" />
<jsp:useBean id="C" scope="application"  class="NipponBean.Connect" />
<jsp:useBean id="I"  class="NipponBean.Inventory" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />


<%

ResultSet rs_g= null;
Connection conp = null;
 PreparedStatement pstmt_p=null;
 try	
{
	conp=C.getConnection();
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
<title>Samyak Software -India</title>
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
String today_string=format.format(D) ;

//out.print(" DATE today_date "+today_date);

// logic to get local currecy 
String local_currencyid= I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
//String base_exchangerate= I.getLocalExchangeRate(company_id);


String command=request.getParameter("command");
//out.println("command"+command);

if("UPDATE".equals(command))
{
try{
 String receive_id=request.getParameter("receive_id");
//out.println("<br>receive_id:"+receive_id);
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


int receive_lots=counter-deletedcount;
//out.print("<br>82 receive_lots"+receive_lots);

 //out.println("<br>Total Nos of old Rows:"+iold_lots);
 
String consignment_no = request.getParameter("consignment_no");
String ref_no = request.getParameter("ref_no");
String description=
request.getParameter("description");
//out.print("<br>consignment_no "+consignment_no);
String oldreceive_no = request.getParameter("oldreceive_no");
int no_i=0;
//out.println("oldreceive_no:"+oldreceive_no);
//out.println("consignment_no:"+consignment_no);
String purchasesalegroup_id=""+request.getParameter("purchasesalegroup_id");

String Consignment_ReceiveId = request.getParameter("Consignment_ReceiveId");

//--------------------------------------------------------------------------------------
//String newConsignment_ReceiveId[] = new String[receive_lots]; 


if(oldreceive_no.equals(consignment_no))
{ 
//out.println("Same");
}
else
{ 
String noquery="Select * from  Receive where Receive_No=? and company_id=?";
//out.print("<br>noquery"+noquery);
pstmt_p = conp.prepareStatement(noquery);
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
C.returnConnection(conp);

	%><body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
	<%
out.print("<br><center>Sale No "+consignment_no+ "already exist. </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1'></center>");
}
else
	{
 
String query="";
String consignment_date = request.getParameter("datevalue");
//out.print("consignment_date"+consignment_date);

String stockdate = request.getParameter("stockdate");
 //out.print("stockdate----------------------------------------         "+stockdate);

String salesperson_id=request.getParameter("salesperson_id");
String stockdateold= request.getParameter("stockdateold");
 //out.print("consignment_date"+consignment_date);
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);

String exchange_ratequery="Select * from Master_ExchangeRate where Exchange_Date=?";
pstmt_p=conp.prepareStatement(exchange_ratequery);
pstmt_p.setString(1,""+format.getDate(stockdate));
rs_g=pstmt_p.executeQuery();
int exchange=0;
//out.println("<br>102121212121 exchange_rate is"+exchange_rate);

while(rs_g.next())
		{
			exchange++;
		}
	pstmt_p.close();



if(exchange==0)
		{
		//out.print("if exchage_rate");
			int exchangerate_id= L.get_master_id(conp,"Master_ExchangeRate");
					//out.print("<br>exchangerate_id "+exchangerate_id);

			String currencyid=A.getNameCondition(conp,"Master_Currency","Currency_Id","where company_id="+company_id);
					//out.print("<br>icurrencyid "+currencyid);

			exchange_ratequery="Insert into Master_ExchangeRate(ExchangeRate_Id,Currency_Id,Exchange_Date,Exchange_Rate,Modified_By,Modified_On,Modified_MachineName,YearEnd_Id) values(?,?,?,?,?,?,?,?)";
			//out.print(exchange_ratequery);
			pstmt_p=conp.prepareStatement(exchange_ratequery);
			pstmt_p.setInt(1,exchangerate_id);
			pstmt_p.setString(2,currencyid);
				//out.print("<br>icurrencyid "+currencyid);

			pstmt_p.setString(3,""+format.getDate(stockdate));
			//out.print("<br>stockdate "+stockdate);
			
			pstmt_p.setDouble(4,exchange_rate);
			//out.print("<br>exchange_rate "+exchange_rate);

			pstmt_p.setString(5,user_id);
			//out.print("<br>user_id "+user_id);

			pstmt_p.setString(6,format.format(today_date));
			//out.print("<br>today_date "+today_date);

			pstmt_p.setString(7,machine_name);
			//out.print("<br>machine_name "+machine_name);
			pstmt_p.setString(8,yearend_id);
			int a177=pstmt_p.executeUpdate();
			pstmt_p.close();
			//out.print("<br> No of rows Master_ExchageRate "+a177);
		}



String due_date = request.getParameter("finalduedate");
int duedays = Integer.parseInt(request.getParameter("finalduedays"));

//out.print("<br>duedays "+duedays);

String currency = request.getParameter("currency");
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
//---------------------------------------
String newConsignment_ReceiveId[] = new String[counter]; 

String receivetransaction_originalid[]=new String[counter];
double oldquantity[]=new double[counter];
double oldavailable_quantity[]=new double[counter];
double oldreturn_quantity[]=new double[counter];
//---------------------------------------

String deleted[]=new String[counter];
String lot_id[]= new String[counter]; 
String newlot_id[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String lotno[]=new String[counter];
int deletedflag[] = new int[counter];
String pcs[]=new String[counter];
double old_quantity[]=new double[counter];
double quantity[]=new double[counter];
double rate[]=new double[counter];
double local_price[]=new double[counter];
double dollar_price[]=new double[counter];
double amount[]=new double[counter];
double local_amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String remarks[]=new String[counter];
//out.print("<br><font color=red>counter=" +counter+"</font>");
//out.println("<br>102 exchange_rate is"+exchange_rate);
String responce_sale="";

double totquantity=0;
double InvTotal=0;
for (int i=0;i<counter;i++)
{
//	out.print("<br>********** i -----> "+i);
receivetransaction_id[i]= ""+request.getParameter("receivetransaction_id"+i);
//out.print("<br> 250 receivetransaction_id[i] :"+receivetransaction_id[i]);
//out.println("<br>receivetransaction_id[i]"+receivetransaction_id[i]);


newlot_id[i]=""+request.getParameter("newlotid"+i);
 //out.print("<br>newlotid[i] "+newlot_id[i]);

deleted[i]=request.getParameter("deleted"+i);
//out.print("<br>deleted"+deleted[i]);


lotno[i]=""+request.getParameter("lotno"+i);

lot_id[i]=A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No='"+lotno[i]+"' and company_id="+company_id);
//out.print("<br>lot_id[p]"+lot_id[i]);


location_id[i]=""+request.getParameter("location_id"+i);
 //out.print("<br>location_id[i] "+location_id[i]);
//out.print("<br>  i -----> "+i);

newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
 //out.print("<br>newlocation_id[i] "+newlocation_id[i]);

pcs[i]=""+request.getParameter("pcs"+i);
//out.print("<br>pcs[i][i] "+pcs[i]);

old_quantity[i]= Double.parseDouble(request.getParameter("old_quantity"+i));
//out.println("<br>278 old_quantity[i]"+old_quantity[i]+"</font>");

quantity[i]= Double.parseDouble(request.getParameter("quantity"+i));
//out.println("<br>281 quantity[i]"+quantity[i]);
	

rate[i]= Double.parseDouble(request.getParameter("rate"+i)); 
amount[i]= Double.parseDouble(request.getParameter("amount"+i)); 

if(!("yes".equals(deleted[i])))
{
	InvTotal+=amount[i];
	deletedflag[i]=0;
}
else
	deletedflag[i]=1;

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

if(!"0".equals(Consignment_ReceiveId))
{
	int nn=0;
	int ntemp = 0;
	for (int i=0;i<counter;i++)
	{
	//	out.print("<br>317 Inside for");

		query="Select Consignment_ReceiveId from Receive_Transaction where ReceiveTransaction_Id=?";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,receivetransaction_id[i]);
		rs_g = pstmt_p.executeQuery();	
	//	out.print("<br> 323 receivetransaction_id[i] :"+receivetransaction_id[i]);
		while(rs_g.next())
			{
				newConsignment_ReceiveId[i]=rs_g.getString("Consignment_ReceiveId");
				//out.print("<br>323 newConsignment_ReceiveId[i]"+newConsignment_ReceiveId[i]);
				nn++;
			}//while
			pstmt_p.close();
	}



	for (int i=0;i<counter;i++)
	{

		query="Select * from Receive_Transaction where ReceiveTransaction_Id=?";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,newConsignment_ReceiveId[i]);
		rs_g = pstmt_p.executeQuery();	
	//	int nn=0;
		ntemp=0;
		while(rs_g.next())
			{

				
				oldquantity[i]=rs_g.getDouble("Quantity");
				oldavailable_quantity[i]=rs_g.getDouble("Available_Quantity");
				oldreturn_quantity[i]=rs_g.getDouble("Return_Quantity");

				//out.print("<br>343 oldquantity[i]"+oldquantity[i]);
				//out.print("<br>344 oldavailable_quantity[i]"+oldavailable_quantity[i]);
				//out.print("<br>345 oldreturn_quantity[i]"+oldreturn_quantity[i]+"<br>");
				

				ntemp++;
			}//while
			pstmt_p.close();
	}

double diff = 0;
double  tempoldreturn_quantity = 0;
//out.print("369 upto here");
	for (int i=0;i<counter;i++)
	{
		 diff = 0;
         tempoldreturn_quantity = 0;


			if(deletedflag[i]==0)
			{
				 
				//out.print("<br>379 old_quantity[i]"+old_quantity[i]);
				//out.print("<br>380 quantity[i]"+quantity[i]);

					 diff = old_quantity[i]-quantity[i];
					 tempoldreturn_quantity = oldreturn_quantity[i];

					//out.print("<br>379 diff"+diff+"<br>"); 		
					//out.print("<br>380 tempoldreturn_quantity"+tempoldreturn_quantity); 		
					
						oldreturn_quantity[i] =tempoldreturn_quantity - diff; 
						oldavailable_quantity[i] = oldquantity[i] - oldreturn_quantity[i];

					//out.print("<br>385 oldreturn_quantity[i]"+oldreturn_quantity[i]);
					//out.print("<br>386 oldavailable_quantity[i]"+oldavailable_quantity[i]);
			}
			else if(deletedflag[i]==1)
			{
						oldreturn_quantity[i] = oldreturn_quantity[i]-old_quantity[i]; 
						oldavailable_quantity[i] = oldquantity[i] - oldreturn_quantity[i];

					//out.print("<br>383 oldreturn_quantity[i]"+oldreturn_quantity[i]);
					//out.print("<br>384 oldavailable_quantity[i]"+oldavailable_quantity[i]);

					
			}

	}
	for (int i=0;i<counter;i++)
	{
		query="Update Receive_Transaction set Available_Quantity= ?,Return_Quantity = ? where ReceiveTransaction_Id=? ";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setDouble(1,oldavailable_quantity[i]);
		pstmt_p.setDouble(2,oldreturn_quantity[i]);
		pstmt_p.setString(3,newConsignment_ReceiveId[i]);		
		int a393 = pstmt_p.executeUpdate();
		pstmt_p.close();


		query="Update Receive_Transaction set Quantity=?, Available_Quantity=? where ReceiveTransaction_Id=? ";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setDouble(1,quantity[i]);
		pstmt_p.setDouble(2,quantity[i]);
		pstmt_p.setString(3,receivetransaction_id[i]);
		int a402 = pstmt_p.executeUpdate();
		pstmt_p.close();


		
	}	
}
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


double difference=Double.parseDouble(request.getParameter("difference"));
double difference_local=0,difference_dollar=0;
String diffdebit=request.getParameter("diffdebit");
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
InvDollarTotal=InvTotal * exchange_rate;
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
int insertLotLocation_id=L.get_master_id(conp,"LotLocation");

for(int i=0; i<count; i++)
{
//out.print("<br> receivetransaction_id "+receivetransaction_id[i]);



query="Select * from  LotLocation where Lot_Id=? and Location_id=? and Active=1";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(query);
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


if("yes".equals(deleted[i]))
{
//	out.print("<br>Inside If");
//	out.print("<br>Quantity  "+quantity[i] );

//out.print("<br>before->fincarats"+fincarats);
//out.print("<br>before->phycarats"+phycarats);

phycarats=phycarats+old_quantity[i];
fincarats=fincarats+old_quantity[i];


query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString(1,"0"); 
pstmt_p.setDouble(1,fincarats); 
pstmt_p.setDouble(2,phycarats); 
pstmt_p.setString (3, user_id);		
pstmt_p.setString (4, machine_name);		
pstmt_p.setString(5,lot_id[i]); 
pstmt_p.setString(6,location_id[i]); 
pstmt_p.setString(7,company_id); 
//out.println("Before Query <br>"+query);
 int a417 = pstmt_p.executeUpdate();
//out.println("<br>Data Successfully updated in lot table <br>");
pstmt_p.close();


query="Update Receive_Transaction set active= ? where ReceiveTransaction_Id=? ";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1, false);		
pstmt_p.setString(2,receivetransaction_id[i]);		
  a417 = pstmt_p.executeUpdate();





}//end if deleted purchase

else
	{
//out.print("<br> Lot_id "+lot_id[i]);
//out.print("<br> newlot_id "+newlot_id[i]);

//out.print("<br> location_id "+location_id[i]);
//out.print("<br> newlocation_id "+newlocation_id[i]);
	totquantity=totquantity+quantity[i];
		//out.print("<br><b>------------------------Lot No & Location UnChanged1111111111111111111111111111111111111</b>");

if(lot_id[i].equals(newlot_id[i]) && location_id[i].equals(newlocation_id[i]))
	{

		//out.print("<br><b>------------------------Lot No & Location UnChanged--------------------------</b>");

		query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setDouble(1,fincaratsnew); 
		//out.print("<br><b>LotLocation New Qty Updated "+fincaratsnew+"</b>");
		pstmt_p.setDouble(2,phycaratsnew); 
		//out.print("<br><b>LotLocation New Qty Updated "+phycaratsnew+"</b>");
		pstmt_p.setString (3, user_id);		
		pstmt_p.setString (4, machine_name);		
		pstmt_p.setString(5,lot_id[i]); 
		pstmt_p.setString(6,location_id[i]); 
		pstmt_p.setString(7,company_id); 

		int a417 = pstmt_p.executeUpdate();
//		out.print("<br>Row update LotLocation -------->"+a417 );
		pstmt_p.close();


	}//end if Lot or Location is not changed
else
	{
		query="select * from LotLocation where Lot_Id=? and Location_Id=?"; 
		pstmt_p = conp.prepareStatement(query);
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
		pstmt_p.setDouble(1,originalphy); 
		pstmt_p.setDouble(2,originalfin); 
		pstmt_p.setString(3,lot_id[i]); 
		pstmt_p.setString(4,location_id[i]); 

		int a528=pstmt_p.executeUpdate();
		pstmt_p.close();
//		out.print("1111111111111111111111111111111111111Ulta LotLocation");

		query="select * from LotLocation where Lot_Id=? and Location_Id=?";
		pstmt_p=conp.prepareStatement(query);
		pstmt_p.setString(1,""+newlot_id[i]);
//		out.print("<br>Lot-Id<font color=red>"+newlot_id[i]+"</font>");
		pstmt_p.setString(2,""+newlocation_id[i]);
//		out.print("<br>Location_Id<font color=red>"+newlocation_id[i]+"</font>");

		rs_g=pstmt_p.executeQuery();
		int lotlocationpresent=0;
		double newlotlocationcarats=0;
		double newlotlocationav_carats=0;

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
			//out.print("333333333333333333333333333333333Insert");

			


			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Carats, Available_Carats, Optimum_Quantity, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?, ?,?,?,?, ?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);

			pstmt_p.setString(1,""+insertLotLocation_id);
			pstmt_p.setString(2,newlocation_id[i]);
			
			pstmt_p.setString(3,company_id);
			pstmt_p.setString(4,newlot_id[i]);
			pstmt_p.setDouble(5,quantity[i]);
			pstmt_p.setDouble(6,quantity[i]);
			
			pstmt_p.setString(7,"0");
			pstmt_p.setString(8,format.format(today_date));
			pstmt_p.setString(9,user_id);
			pstmt_p.setString(10,machine_name);
			pstmt_p.setString(11,yearend_id);
			int a571=pstmt_p.executeUpdate();
			pstmt_p.close();
    		
			insertLotLocation_id=insertLotLocation_id+1;
			//out.print("<br> LotLocation Row Inserted <br> No of Rows "+a571);

		}//end if newlot is not present at new location 
		else
		{
			//Update
//---Update quantity for new lot & location's record in lotlocation i.e new quantity added---
//out.print("4444444444444444444444444444444444Update");

			newlotlocationcarats=newlotlocationcarats-quantity[i];
			newlotlocationav_carats=newlotlocationav_carats-quantity[i];

			query="Update LotLocation set Carats=?, Available_Carats=?, Modified_On=?, Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_Id=?";
			pstmt_p=conp.prepareStatement(query);
			pstmt_p.setDouble(1,newlotlocationcarats);
			pstmt_p.setDouble(2,newlotlocationav_carats);
			pstmt_p.setString(3,format.format(today_date));
			pstmt_p.setString(4,""+user_id);
			pstmt_p.setString(5,""+machine_name);
			pstmt_p.setString(6,newlot_id[i]);
			pstmt_p.setString(7,newlocation_id[i]);

			int a601=pstmt_p.executeUpdate();
			pstmt_p.close();

			//out.print("<br> LotLocation Updated");
		}//end new lot is not present at new location

	}
/*
query="Select * from Receive_Transaction where Receive_Id=? and Active=1";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,Consignment_ReceiveId); 
	rs_g = pstmt_p.executeQuery();	
	int n=0;
	while(rs_g.next())
		{
				receivetransaction_originalid[n]=rs_g.getString("Consignment_ReceiveId");
				receivetransaction_originalid[n]=rs_g.getString("Consignment_ReceiveId");
				receivetransaction_originalid[n]=rs_g.getString("Consignment_ReceiveId");
				receivetransaction_originalid[n]=rs_g.getString("Consignment_ReceiveId");


				 
				double originalquantity[]=new String[counter];
				double available_originalquantity[]=new String[counter];
				double return_originalquantity[]=new String[counter];


		}
pstmt_p.close();
*/
//out.print("<br> 668 updating prev");
		query="Update Receive_Transaction set Lot_Id=?, Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, Dollar_Price=?, Pieces=?, Remarks=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Location_Id=? where ReceiveTransaction_Id=?";
		
		//out.print("<br> 640 receivetransaction_id[i]"+receivetransaction_id[i]);

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,newlot_id[i]);
		pstmt_p.setDouble(2,quantity[i]);
		pstmt_p.setDouble(3,quantity[i]);
		pstmt_p.setDouble(4,rate[i]);
		pstmt_p.setDouble(5,local_price[i]);
		pstmt_p.setDouble(6,dollar_price[i]);
		pstmt_p.setString(7,""+pcs[i]);
		pstmt_p.setString(8,""+remarks[i]);
		pstmt_p.setString(9,format.format(today_date));
		pstmt_p.setString(10,""+user_id);
		pstmt_p.setString(11,machine_name);
		pstmt_p.setString(12,newlocation_id[i]);
		pstmt_p.setString(13,receivetransaction_id[i]);

		int a653=pstmt_p.executeUpdate();
		pstmt_p.close();
/*
		query="Select Consignment_ReceiveId from Receive_Transaction where Receive_Id=?";
		pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,receivetransaction_id[i]);
	rs_g = pstmt_p.executeQuery();	
	int nn=0;
	while(rs_g.next())
		{
			newConsignment_ReceiveId[nn]=rs_g.getString("Consignment_ReceiveId");
			nn++;
		}//while

pstmt_p.close();

	query="Select * from Receive_Transaction where Receive_Id=?";
    pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,newConsignment_ReceiveId[i]);
	rs_g = pstmt_p.executeQuery();	
	int nn=0;
	while(rs_g.next())
		{
			newConsignment_ReceiveId[nn]=rs_g.getString("Consignment_ReceiveId");
			nn++;
		}//while

pstmt_p.close();

*/

		
		//out.print("<br>Receive Transaction Updated");
	}//end else
}//for original rows edited

int toby_nos=ledgers;
for(int i=0;i<org_ledgers;i++)
{
if("yes".equals(findeleted[i]))
{toby_nos --;
query="Update Financial_Transaction set Active=? where Tranasaction_Id="+org_transacionid[i]; 
pstmt_p=conp.prepareStatement(query);
pstmt_p.setBoolean(1,false);
int a678=pstmt_p.executeUpdate();
//out.print("<br>675 FT "+a674);
pstmt_p.close();

}
else{
query="Update Financial_Transaction set For_Head=?, For_HeadId=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Ledger_Id=?, Exchange_Rate=?, Transaction_Date=?, Tranasaction_No=?, ReceiveFrom_LedgerId=?, Active=? where Tranasaction_Id="+org_transacionid[i];

pstmt_p=conp.prepareStatement(query);

String for_head=A.getNameCondition(conp,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
//out.print("<br>642");
pstmt_p.setString(1,""+for_head);

String forhead_id=A.getNameCondition(conp,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);
//out.print("<br>646");
pstmt_p.setString(2,""+forhead_id);
pstmt_p.setString(3,""+debitcredit[i]);

pstmt_p.setDouble(4,acamount[i]);
pstmt_p.setDouble(5,acamount_local[i]);
pstmt_p.setDouble(6,acamount_dollar[i]);

pstmt_p.setString(7,""+format.getDate(today_string));
pstmt_p.setString(8,""+user_id);
pstmt_p.setString(9,""+machine_name);
pstmt_p.setString(10,""+ledger[i]);
pstmt_p.setDouble(11,exchange_rate);
pstmt_p.setString(12,""+format.getDate(consignment_date));
pstmt_p.setString(13,""+consignment_no);

String ReceiveFrom_LedgerId=A.getNameCondition(conp,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2");
//out.print("<br>663");
pstmt_p.setString(14,""+ReceiveFrom_LedgerId);
pstmt_p.setBoolean(15,true);

int a674=pstmt_p.executeUpdate();
//out.print("<br>675 FT "+a674);
pstmt_p.close();
}
}

int newreceivetransaction_id=L.get_master_id(conp,"Receive_Transaction");

	int newinsertLotLocation_id=L.get_master_id(conp,"LotLocation");

for(int i=count; i<counter; i++)
{
		
		//out.print("For Added");
		totquantity=totquantity+quantity[i];

		query="select * from LotLocation where Lot_Id=? and Location_Id=?";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,newlot_id[i]); 
		pstmt_p.setString(2,newlocation_id[i]);
		rs_g=pstmt_p.executeQuery();
		
		int newlotlocation=0;
		double addlotlocationcarat=0;
		double addlotlocationav_carat=0;

		while(rs_g.next())
		{
			newlotlocation++;
			addlotlocationcarat=rs_g.getDouble("Carats");
			addlotlocationav_carat=rs_g.getDouble("Available_Carats");
		}
		
		pstmt_p.close();

//		out.print("<br> Select LotLocation");
		if(newlotlocation==0)
		{
			//Insert
//			out.print("<br> Inside if Present");
		

			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+newinsertLotLocation_id);
			pstmt_p.setString(2,newlocation_id[i]);
			pstmt_p.setString(3,company_id);
			pstmt_p.setString(4,newlot_id[i]);
			
			pstmt_p.setDouble(5,quantity[i]);
			pstmt_p.setDouble(6,quantity[i]);
			pstmt_p.setString(7,format.format(today_date));
			pstmt_p.setString(8,user_id);
			pstmt_p.setString(9,machine_name);
			pstmt_p.setString(11,yearend_id);
			int ax=pstmt_p.executeUpdate();
			pstmt_p.close();
newinsertLotLocation_id=newinsertLotLocation_id+1;
//		out.print("<br> Insert LotLocation");


		}
		else
		{
			//Update

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

	//		out.print("<br> Update LotLocation");

		}
//out.print("////////// ");

//		int newreceivetransaction_id=L.get_master_id(conp,"Receive_Transaction");

            //out.print("823 newreceivetransaction_id"+newreceivetransaction_id);

		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Quantity, Available_Quantity, Receive_Price, Local_Price, Dollar_Price, Pieces, Remarks, Modified_On, Modified_By, Modified_MachineName, Location_Id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";

		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,""+newreceivetransaction_id);
	//	out.print(" <br>newreceivetransaction_id "+ newreceivetransaction_id);
		pstmt_p.setString(2,""+receive_id);
//		out.print(" <br>receive_id "+ receive_id);
		pstmt_p.setString(3,""+newreceivetransaction_id);
//		out.print(" <br>newreceivetransaction_id "+newreceivetransaction_id );
		pstmt_p.setString(4,""+newlot_id[i]);
//		out.print(" <br> newlot_id[i]"+newlot_id[i] );
      
		pstmt_p.setDouble(5,quantity[i]);
//		out.print(" <br>quantity[i] "+quantity[i] );
		pstmt_p.setDouble(6,quantity[i]);
//		out.print(" <br>quantity[i] "+quantity[i] );
		pstmt_p.setDouble(7,rate[i]);
//		out.print(" <br>rate[i] "+ rate[i]);
		pstmt_p.setDouble(8,local_price[i]);
//		out.print(" <br>local_price[i] "+local_price[i] );
		
		pstmt_p.setDouble(9,dollar_price[i]);
//		out.print(" <br> dollar_price[i]"+ dollar_price[i]);
		pstmt_p.setString(10,""+pcs[i]);
//		out.print(" <br>pcs[i] "+pcs[i] );
		pstmt_p.setString(11,""+remarks[i]);
//		out.print(" <br>remarks[i] "+remarks[i] );
		pstmt_p.setString(12,format.format(today_date));
//		out.print(" <br>today_date "+format.format(today_date) );
		
		pstmt_p.setString(13,""+user_id);
//		out.print(" <br>user_id "+ user_id);
		pstmt_p.setString(14,""+machine_name);
//		out.print(" <br>machine_name "+machine_name );
		pstmt_p.setString(15,""+newlocation_id[i]);
//		out.print(" <br>newlocation_id "+newlocation_id[i] );
		pstmt_p.setString(16,yearend_id);
		int a722=pstmt_p.executeUpdate();

//out.print("\\\\\\\\\\\\\\ ");
         newreceivetransaction_id++;


}//end for added rows insertion in receive_transaction

int transaction_id=L.get_master_id(conp,"Financial_Transaction");

String testvoucher_id= A.getNameCondition(conp,"Voucher","Voucher_Id","Where Voucher_Type=10 and Voucher_No='"+receive_id+"'" );

//out.print("<br> 806 testvoucher_id="+testvoucher_id);
String voucher_type= "10"; // See voucher Table Design 

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

String for_head=A.getNameCondition(conp,"Ledger","For_Head","where Ledger_Id="+ledger[i]);
pstmt_p.setString(5,""+for_head);
//out.print("<br>821 for_head "+for_head);

String forhead_id=A.getNameCondition(conp,"Ledger","For_HeadId","where Ledger_Id="+ledger[i]);
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
String ReceiveFrom_LedgerId=A.getNameCondition(conp,"Ledger","Ledger_Id","where For_Head=14 and For_HeadId="+companyparty_id+" and Ledger_Type=2");
//out.print("<br>843 ReceiveFrom_LedgerId "+ReceiveFrom_LedgerId);

pstmt_p.setString(18,""+ReceiveFrom_LedgerId);
//out.print("<br>Financial Transaction");

pstmt_p.setDouble(19,exchange_rate);
//out.print("<br>Financial Transaction "+exchange_rate);
pstmt_p.setString(20,yearend_id);
int a525 = pstmt_p.executeUpdate();
//out.println(" <BR><br><font color=red>Financial_Transaction Updated Successfully: ?</font>" +a525);
pstmt_p.close();

transaction_id++;

}



//out.print("<br>865");

String transaction_idctax= A.getNameCondition(conp,"Financial_Transaction","Tranasaction_Id","where Voucher_Id="+testvoucher_id+" and Ledger_Id="+A.getNameCondition(conp,"Ledger","Ledger_Id","where Ledger_Name='C. Tax' and company_id="+company_id));

query="Update Financial_Transaction set Amount=?, Local_Amount=?, Dollar_Amount=? where Tranasaction_Id=?";

pstmt_p=conp.prepareStatement(query);

pstmt_p.setDouble(1,ctax_amt);
pstmt_p.setDouble(2,ctax_amtlocal);
pstmt_p.setDouble(3,ctax_amtdollar);
pstmt_p.setString(4,""+transaction_idctax);

int a823=pstmt_p.executeUpdate();
								
	String party_name= A.getName(conp,"companyparty",companyparty_id);
	String cmpy_name=A.getName(conp,"companyparty",company_id);

	query="Update Receive set Receive_No=?,Receive_Date=?,Receive_Lots=? ,Receive_Quantity=? ,Exchange_Rate=?,Receive_ExchangeRate=?,Tax= ?,Receive_Total=?,   Local_Total= ?,Dollar_Total= ?,Receive_FromId= ? ,Receive_FromName= ?     ,Company_Id= ?,Receive_ByName= ? ,Due_Days= ? ,Due_Date= ?   ,Modified_On= ?,Modified_By=?,Modified_MachineName= ?,stock_date=?,SalesPerson_Id=? , Difference_Amount=?, Difference_LocalAmount=?, Difference_DollarAmount=?, InvTotal=?,InvLocalTotal=?, InvDollarTotal=?,     PurchaseSaleGroup_Id="+purchasesalegroup_id+" where Receive_Id=?";
	pstmt_p=conp.prepareStatement(query);
	
		pstmt_p.setString(1,""+consignment_no); 
		//out.print("<br>consignment_no "+consignment_no);
		pstmt_p.setString(2,""+format.getDate(consignment_date)); 
		//out.print("<br>consignment_date "+consignment_date);
		pstmt_p.setString(3,""+(counter-deletedcount)); 
//		//out.print("<br> "+);
		pstmt_p.setDouble(4,totquantity); 
		//out.print("<br> totquantity"+totquantity);

		pstmt_p.setDouble(5,exchange_rate); 
		//out.print("<br> exchange_rate"+exchange_rate);
		pstmt_p.setDouble(6,exchange_rate); 
		//out.print("<br>exchange_rate "+exchange_rate);
		pstmt_p.setDouble(7,ctax); 
		//out.print("<br>ctax "+ctax);
		pstmt_p.setDouble(8,total); 
		//out.print("<br>total "+total);

		pstmt_p.setDouble(9,local_total); 
		//out.print("<br>local_total "+local_total);
		pstmt_p.setDouble(10,dollar_total); 
		//out.print("<br>dollar_total "+dollar_total);
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

		pstmt_p.setString(17,""+format.format(today_date)); 
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
		pstmt_p.setString(28,""+receive_id);

//out.print("<br>737 Last update inreceive ----->");
		int ay=pstmt_p.executeUpdate();
//out.print("Last update inreceive ----->" +ay);
//---------------------------------------------------

//out.print("<br> 1184 local_total"+local_total);
//out.print("<br> 1185 difference_local"+difference_local);
//out.print("<br> 1186 InvLocalTotal"+InvLocalTotal);
//---------------------------------------------------
double old_local_total = Double.parseDouble(request.getParameter("old_total"));
double old_dollar_total = old_local_total/exchange_rate;

old_local_total =  local_total-old_local_total;
old_dollar_total =  dollar_total-old_dollar_total;

if("0".equals(Consignment_ReceiveId))
{
		query = "update Master_CompanyParty set Purchase_AdvanceLocal=Purchase_AdvanceLocal+?,Purchase_AdvanceDollar=Purchase_AdvanceDollar+? where CompanyParty_Id=?";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setDouble (1, old_local_total);
pstmt_p.setDouble (2, old_dollar_total);
pstmt_p.setString (3, companyparty_id);
int a459 = pstmt_p.executeUpdate();
pstmt_p.close();	
}		
//---------------------------------------------------
		query="Update  Voucher  set Voucher_No=?, Voucher_Date='"+format.getDate(consignment_date)+"',  Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? , ToBy_Nos=?,Ref_No=? where Voucher_Id=?";

	//	out.print("<BR>90" +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,receive_id);		
		pstmt_p.setDouble (2,exchange_rate);
		pstmt_p.setDouble (3,total);	
		pstmt_p.setDouble (4,local_total);	
		pstmt_p.setDouble (5,dollar_total);
		pstmt_p.setString (6,description);
		pstmt_p.setString (7,user_id);	
		pstmt_p.setString (8,machine_name);	
		pstmt_p.setString (9,""+toby_nos);	
		pstmt_p.setString (10,ref_no);	
		pstmt_p.setString (11,""+testvoucher_id);		
		int a6598 = pstmt_p.executeUpdate();


		//out.println(" <BR><br><font color=red>Voucher Updated Successfully: ?</font>" +a6598);
			pstmt_p.close();
		//out.print("<font class=star1><br><center>Data Successfully Updated.</center>");


		
			

}//if final-flag 

C.returnConnection(conp);
}//else invoice no is not present in recive
}//end try 
catch(Exception Samyak499)
{ 
	conp.rollback();
    C.returnConnection(conp); 
out.println("<br><font color=red> FileName : InvSellUpdate.jsp Bug No Samyak499 : "+ Samyak499);
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



