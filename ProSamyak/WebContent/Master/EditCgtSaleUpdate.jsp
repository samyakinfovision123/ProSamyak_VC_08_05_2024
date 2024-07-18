<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%!int samyakerror=0;%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<%
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

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



String user_name=A.getName(conp,"User",user_id);
//out.print("<br>user_name="+user_name);
%>
<html>
<head>
<title> Samyak Software </title>
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
String today_string= format.format(D);

//out.print(" DATE today_date "+today_date);

// logic to get local currecy 
String local_currencyid= I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
//String base_exchangerate= I.getLocalExchangeRate(company_id);


String soldCompNo=request.getParameter("soldCompNo");
//out.print("<br> 119 soldCompNo = "+soldCompNo);

String SendForLocation_id = "0";

if(! "0".equals(soldCompNo))
{
	SendForLocation_id=request.getParameter("Loca_id");
	//out.print("<br> 119 SendForLocation_id = "+SendForLocation_id);
}



String command=request.getParameter("command");
//out.println("command"+command);

if("UPDATE".equals(command))
{
try{
	
	String receive_category_id=request.getParameter("receive_category_id");
 //out.print("<br>70category_id:"+category_id1);
	String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String receive_id=request.getParameter("receive_id");
//out.println("<br>receive_id:"+receive_id);
String lots = request.getParameter("no_lots");
//out.println("<br><font color=red>TotalLots Counter</font>lots"+lots);
int counter=Integer.parseInt(lots)-1;
//out.print("Counter "+counter);

int total_lots=Integer.parseInt(lots);
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
//int counter=total_lots-2;
//out.println("<br><font color=red>Total Nos of Rows:</font>"+counter);

String old_lots = request.getParameter("old_lots");

int deletedcount = Integer.parseInt(request.getParameter("deletedcount"));
//out.print("<br>deletedcount "+deletedcount );


int iold_lots=Integer.parseInt(old_lots);
//out.println("<br><font color=red>Old lots:</font>"+iold_lots);
int count=iold_lots;


int receive_lots=counter-deletedcount;
//out.print("<br>receive_lots"+receive_lots);

 //out.println("<br>Total Nos of old Rows:"+iold_lots);
 
String consignment_no = request.getParameter("consignment_no");
//out.print("<br>consignment_no "+consignment_no);
String oldreceive_no = request.getParameter("oldreceive_no");
int no_i=0;
String salesperson_id = request.getParameter("salesperson_id");
//out.print("salesperson_id"+salesperson_id);





//out.println("oldreceive_no:"+oldreceive_no);
//out.println("consignment_no:"+consignment_no);
if(oldreceive_no.equals(consignment_no))
{ 
//out.println("Same");
}
else
{ 
String noquery="Select * from  Receive where Receive_No=? and company_id=? and Receive_Sell=1";
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

	%>
	<body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
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

String stockdateold= request.getParameter("stockdateold");
// out.print("consignment_date"+consignment_date);
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);

String exchange_ratequery="Select * from Master_ExchangeRate where Exchange_Date=?";
pstmt_p=conp.prepareStatement(exchange_ratequery);
pstmt_p.setString(1,""+format.getDate(consignment_date));
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
//		out.print("if exchage_rate");
			int exchangerate_id= L.get_master_id(conp,"Master_ExchangeRate");
//					out.print("<br>exchangerate_id "+exchangerate_id);

			String currencyid=A.getNameCondition(conp,"Master_Currency","Currency_Id","where company_id="+company_id);
//					out.print("<br>icurrencyid "+currencyid);

			exchange_ratequery="Insert into Master_ExchangeRate(ExchangeRate_Id,Currency_Id,Exchange_Date,Exchange_Rate,Modified_By,Modified_On,Modified_MachineName,YearEnd_Id) values(?,?,?,?,?,?,?,?)";
//			out.print(exchange_ratequery);
			pstmt_p=conp.prepareStatement(exchange_ratequery);
			pstmt_p.setInt(1,exchangerate_id);
			pstmt_p.setString(2,currencyid);
//					out.print("<br>icurrencyid "+currencyid);

			pstmt_p.setString(3,""+format.getDate(consignment_date));
//			out.print("<br>stockdate "+stockdate);
			pstmt_p.setString(4,""+exchange_rate);
//			out.print("<br>exchange_rate "+exchange_rate);

			pstmt_p.setString(5,user_id);
//			out.print("<br>user_id "+user_id);

			pstmt_p.setString(6,""+(today_date));
//			out.print("<br>today_date "+today_date);

			pstmt_p.setString(7,machine_name);
//			out.print("<br>machine_name "+machine_name);
			pstmt_p.setString (8,yearend_id);
			int a177=pstmt_p.executeUpdate();
//			out.print("<br> No of rows Master_ExchageRate "+a177);
		}



String due_date = request.getParameter("finalduedate");
int duedays = Integer.parseInt(request.getParameter("finalduedays"));


String currency = request.getParameter("currency");
String continue_anyway = request.getParameter("continue_anyway");
//out.println("<br>97 currency is"+currency);
String companyparty_id= request.getParameter("companyparty_id");
// out.println("111138company id is= "+companyparty_id);
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

for (int i=0;i<counter;i++)
{
//	out.print("<br>********** i -----> "+i);
receivetransaction_id[i]= ""+request.getParameter("receivetransaction_id"+i);
//out.println("<br>receivetransaction_id[i]"+receivetransaction_id[i]);

lot_id[i]=request.getParameter("lotid"+i);
//out.print("<br>lot_id[p]"+lot_id[i]);

newlot_id[i]=""+request.getParameter("newlotid"+i);
// out.print("<br>newlotid[i] "+newlot_id[i]);

deleted[i]=request.getParameter("deleted"+i);
//out.print("<br>deleted"+deleted[i]);


lotno[i]=""+request.getParameter("lotno"+i);


location_id[i]=""+request.getParameter("location_id"+i);
// out.print("<br>location_id[i] "+location_id[i]);
//out.print("<br>  i -----> "+i);

newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
// out.print("<br>newlocation_id[i] "+newlocation_id[i]);
pcs[i]=""+request.getParameter("pcs"+i);
 //out.print("<br>pcs[i][i] "+pcs[i]);

old_quantity[i]= Double.parseDouble(request.getParameter("old_quantity"+i));
//out.println("<br><font color=red>old_quantity[i]"+old_quantity[i]+"</font>");

quantity[i]= Double.parseDouble(request.getParameter("quantity"+i));
//out.println("<br>quantity[i]"+quantity[i]);
	
	totquantity=totquantity + quantity[i];

rate[i]= Double.parseDouble(request.getParameter("rate"+i)); 
amount[i]= Double.parseDouble(request.getParameter("amount"+i)); 

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
//	out.print("<br> <font color =blue  >totquantity </font>"+totquantity);
samyakerror=298; 
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
samyakerror=313; 

//out.print("<br>duedays"+duedays);
//out.print("<br>214");

double local_total=0;
double dollar_total=0;
boolean voucher_currency=false;

String currency_id="";
if ("dollar".equals(currency))
	{
	voucher_currency=false;
	local_currencysymbol="$";
	currency_id="0";
	dollar_total= total;
	local_total= total * exchange_rate;
}//if
else{
	voucher_currency=true;
	currency_id=local_currencyid;
	local_total= total;
	dollar_total= total / exchange_rate ;
}//else
samyakerror=337; 
int j=0;
int flag= 0;
int final_flag=1; 
double carats[]=new double[counter] ;
double av_carats[]=new double[counter] ;
double receive_quantity=0;
//out.print("******** ");
if(final_flag==1)	
{
samyakerror=347; 
int insertLotLocation_id=L.get_master_id(conp,"LotLocation");
samyakerror=349; 
for(int i=0; i<count; i++)// for orignal rows only
{
//out.print("<br> receivetransaction_id "+receivetransaction_id[i]);
//out.print("<br>***************************-------->i="+i);
//out.print("<br>Quantity -->"+quantity[i]);
//out.print("<br>old Quantity -->"+old_quantity[i]);
//out.print("<br>Table=Lotlocatin ");
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
	//fincarats= rs_g.getDouble("Carats");
 	//out.print("<br>before->fincarats"+fincarats);
	phycarats= rs_g.getDouble("Available_Carats");
//	out.print("<br>before->phycarats"+phycarats);
	p++;
	}

//	out.print("******************p "+p);
	pstmt_p.close();
double fincaratsnew=0;
double phycaratsnew=0;

//fincaratsnew=fincarats-(old_quantity[i]-quantity[i]);
//out.print("<br>fincaratsnew "+fincaratsnew);
samyakerror=384; 
phycaratsnew=phycarats+(old_quantity[i]-quantity[i]);
//out.print("<br> 386 phycaratsnew "+phycaratsnew);
double  oldfincarat =0;
double  oldphycarat =0;
//	out.print("<br> <font color =red  >deleted </font>"+deleted[i]);

if("yes".equals(deleted[i]))
{
 //	out.print("<br> <font color =green  >totquantity </font>"+totquantity);
	//out.print("<br> <font color =green  >quantity </font>"+quantity[i]);

	totquantity=totquantity - quantity[i];
//	out.print("<br> <font color =red  >totquantity </font>"+totquantity);
//	out.print("<br> <font color =red  >quantity </font>"+quantity[i]);
//	out.print("<br>-********-**--totquantity "+totquantity);
//	out.print("<br>Inside Deleted");
 //	out.print("<br>Quantity  "+quantity[i] );

//out.print("<br>before->fincarats"+fincarats);
// out.print("<br>before->phycarats"+phycarats);
samyakerror=405; 
phycarats=phycarats+old_quantity[i];
//fincarats=fincarats-old_quantity[i];
 //	out.print("<br>After->fincarats"+fincarats);
 //	out.print("<br>After->phycarats"+phycarats);

samyakerror=410; 
query="Update LotLocation  set  Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
samyakerror=412;
pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString(1,"0"); 
//pstmt_p.setString(1,""+fincarats); 
pstmt_p.setString(1,""+phycarats); 
pstmt_p.setString (2, user_id);		
pstmt_p.setString (3, machine_name);		
pstmt_p.setString(4,lot_id[i]); 
pstmt_p.setString(5,location_id[i]); 
pstmt_p.setString(6,company_id); 
//out.println("Before Query <br>"+query);
samyakerror=424; 
  int a417 = pstmt_p.executeUpdate();
samyakerror=426; 
/// out.println("<br>Data Successfully updated in lot table <br>"+a417);
pstmt_p.close();

query="Update Receive_Transaction set active= ? where ReceiveTransaction_Id=? ";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString(1,"0");		
pstmt_p.setString(2,receivetransaction_id[i]);		
 a417 = pstmt_p.executeUpdate();
// out.println("<br>Data Successfully updated in lot table <br>"+a417);






}//end if deleted purchase

else
	{
//out.print("Inside Not deleted  ");
samyakerror=448; 
//out.print("<br> Lot_id "+lot_id[i]);
//out.print("<br> newlot_id "+newlot_id[i]);

//out.print("<br> location_id "+location_id[i]);
//out.print("<br> newlocation_id "+newlocation_id[i]);

if(lot_id[i].equals(newlot_id[i]) && location_id[i].equals(newlocation_id[i]))
	{
		query="Update LotLocation  set  Available_Carats=?,   Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

		pstmt_p = conp.prepareStatement(query);

		//pstmt_p.setString(1,""+fincaratsnew); 
		pstmt_p.setString(1,""+phycaratsnew);
//		out.print("<br>***********LotLocation"+phycaratsnew);
		pstmt_p.setString (2, user_id);		
		pstmt_p.setString (3, machine_name);		
		pstmt_p.setString(4,lot_id[i]); 
		pstmt_p.setString(5,location_id[i]); 
		pstmt_p.setString(6,company_id); 
samyakerror=469; 
	 	int a417 = pstmt_p.executeUpdate();
samyakerror=471; 
//	out.print("<br>Row update LotLocation -------->"+a417 );
		pstmt_p.close();



	}//end if Lot or Location is not changed
else
	{
//	out.print("<br>Inside Change inlot location or lot id ");
samyakerror=481; 
		query="select * from LotLocation where Lot_Id=? and Location_Id=?"; 
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,lot_id[i]); 
		pstmt_p.setString(2,location_id[i]); 
		samyakerror=486;
		 rs_g = pstmt_p.executeQuery();
		 samyakerror=488; 
		double originalphy=0;
		double originalfin=0;
//out.print("<br>Table=Lotlocation ");
		 while(rs_g.next())
		{
			//originalphy=rs_g.getDouble("Carats");
			originalfin=rs_g.getDouble("Available_Carats");
		}

		pstmt_p.close();
		//originalphy=originalphy-old_quantity[i];
		//out.print("<br>Back reflection originalfin"+originalfin);
//out.print("<br>old_quantity"+old_quantity[i]);
		originalfin=originalfin+old_quantity[i];
 //		out.print("<br>originalphy "+originalphy);
	//	out.print("<br>originalfin "+originalfin);
		
		query="Update LotLocation set   Available_Carats=? where Lot_Id=? and Location_Id=?";
		pstmt_p=conp.prepareStatement(query);
		//pstmt_p.setString(1,""+originalphy); 
		pstmt_p.setString(1,""+originalfin); 
//		out.print("<br>This is the back reflactionin lotlocation->"+originalfin);
		pstmt_p.setString(2,lot_id[i]); 
		pstmt_p.setString(3,location_id[i]); 
samyakerror=505;
 	int a528=pstmt_p.executeUpdate();//these are back reflactions
		pstmt_p.close();
 //	out.print(" <br>Rows updated  LotLocation"+a528);

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
		//newlotlocationcarats=rs_g.getDouble("Carats");
		newlotlocationav_carats=rs_g.getDouble("Available_Carats");

		}
		pstmt_p.close();
	//	out.print("2222222222222222222222222222222222222Ulta LotLocation "+lotlocationpresent+" <br>");		
		if(lotlocationpresent==0)  //no Record for new lot & new location
		{
//			out.print("333333333333333333333333333333333Insert");
			
			double temp1=0-quantity[i];
			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Carats, Available_Carats, Optimum_Quantity, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?, ?,?,?,?, ?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);

			pstmt_p.setString(1,""+insertLotLocation_id);
			pstmt_p.setString(2,newlocation_id[i]);
			
			pstmt_p.setString(3,company_id);
			pstmt_p.setString(4,newlot_id[i]);
			pstmt_p.setString(5,""+0);
			pstmt_p.setString(6,""+temp1);
			
			pstmt_p.setString(7,"0");
			pstmt_p.setString(8,""+(today_date));
			pstmt_p.setString(9,user_id);
			pstmt_p.setString(10,machine_name);
			pstmt_p.setString (11,yearend_id);
			int a571=pstmt_p.executeUpdate();
			pstmt_p.close();
			insertLotLocation_id++;
//			out.print("<br> LotLocation Row Inserted <br> No of Rows "+a571);

		}//end if newlot is not present at new location 
		else
		{
			//Update
//---Update quantity for new lot & location's record in lotlocation i.e new quantity added---
//out.print("4444444444444444444444444444444444Update");
			//newlotlocationcarats=newlotlocationcarats+quantity[i];
			newlotlocationav_carats=newlotlocationav_carats-quantity[i];

			query="Update LotLocation set   Available_Carats=?, Modified_On=?, Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_Id=?";
			pstmt_p=conp.prepareStatement(query);
			//pstmt_p.setString(1,""+newlotlocationcarats);
			pstmt_p.setString(1,""+newlotlocationav_carats);
			pstmt_p.setString(2,""+(today_date));
			pstmt_p.setString(3,""+user_id);
			pstmt_p.setString(4,""+machine_name);
			pstmt_p.setString(5,newlot_id[i]);
			pstmt_p.setString(6,newlocation_id[i]);

	 	int a601=pstmt_p.executeUpdate();
			pstmt_p.close();
//			out.print("<br>Rows inserted in lotlocation "+a601 );
		
	}//end new lot is not present at new location

	}
//--------
		query="Update Receive_Transaction set Lot_Id=?,Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, Dollar_Price=?, Pieces=?, Remarks=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, Location_Id=? where ReceiveTransaction_Id=?";
		
		pstmt_p=conp.prepareStatement(query);

		pstmt_p.setString(1,newlot_id[i]);
		pstmt_p.setString(2,""+quantity[i]);
		pstmt_p.setString(3,""+quantity[i]);
		pstmt_p.setDouble(4,rate[i]);
		pstmt_p.setDouble(5,local_price[i]);
		pstmt_p.setDouble(6,dollar_price[i]);
		pstmt_p.setString(7,""+pcs[i]);
		pstmt_p.setString(8,""+remarks[i]);
		pstmt_p.setString(9,""+(today_date));
		pstmt_p.setString(10,""+user_id);
		pstmt_p.setString(11,machine_name);
		pstmt_p.setString(12,newlocation_id[i]);
		pstmt_p.setString(13,receivetransaction_id[i]);
samyakerror=609; 
		int a653=pstmt_p.executeUpdate();
samyakerror=411; 
		pstmt_p.close();

//---------
	}//end else
}//for original rows edited


//	out.print("<br> <font color =red  >totquantity </font>"+totquantity);

// out.print("Beleow operations are for Rows adde afterwards ");
samyakerror=622; 
int newreceivetransaction_id=L.get_master_id(conp,"Receive_Transaction"); 
int newinsertLotLocation_id=L.get_master_id(conp,"LotLocation");
samyakerror=625; 
//out.print("<br> 626 counter ="+counter);
for(int i=count; i<counter; i++)
{   
		query="select * from LotLocation where Lot_Id=? and Location_Id=?";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,newlot_id[i]); 
		pstmt_p.setString(2,newlocation_id[i]);
		samyakerror=632;
		rs_g=pstmt_p.executeQuery();
		samyakerror=634;
		int newlotlocation=0;
			//		double addlotlocationcarat=0;
			double addlotlocationav_carat=0;

		while(rs_g.next())
		{
			newlotlocation++;
							//addlotlocationcarat=rs_g.getDouble("Carats");
				addlotlocationav_carat=rs_g.getDouble("Available_Carats");

		}
		
		pstmt_p.close();
//		out.print("<br> Select LotLocation");
		if(newlotlocation==0)
		{
			//Insert
//			out.print("<br> Inside if Present");
			

			query="insert into LotLocation(LotLocation_Id, Location_Id, Company_Id, Lot_Id, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,?)";
			pstmt_p=conp.prepareStatement(query);
			
			pstmt_p.setString(1,""+newinsertLotLocation_id);
///			out.print("***********newinsertLotLocation_id"+newinsertLotLocation_id);

			pstmt_p.setString(2,newlocation_id[i]);
			pstmt_p.setString(3,company_id);
			pstmt_p.setString(4,newlot_id[i]);
			
			//pstmt_p.setString(5,""+quantity[i]);
//			out.print("***********Lotlocation"+quantity[i]);
			pstmt_p.setString(5,""+quantity[i]);
			pstmt_p.setString(6,""+(today_date));
			pstmt_p.setString(7,user_id);
			pstmt_p.setString(8,machine_name);
			pstmt_p.setString(9,yearend_id);
					samyakerror=672;
			int ax=pstmt_p.executeUpdate();
					samyakerror=674;
			pstmt_p.close();
//			out.print("<br>Rows inserted in lotlocation  -->"+ax);
newinsertLotLocation_id++;
//		out.print("<br> Insert LotLocation");


		}//end if of lot n lotlocation check
		else
		{
			//Update
	//		addlotlocationcarat=addlotlocationcarat+quantity[i];
			addlotlocationav_carat=addlotlocationav_carat - quantity[i];
			
//			out.print("<br> Select LotLocation");

			query="Update LotLocation set  Available_Carats=? where Lot_Id=? and Location_Id=?";
			pstmt_p=conp.prepareStatement(query);
			
			//pstmt_p.setString(1,""+addlotlocationcarat);
			pstmt_p.setString(1,""+addlotlocationav_carat);
//			out.print("***********Lotlocation"+addlotlocationav_carat);

//			out.print("***********newinsertLotLocation_id"+newlocation_id[i]);

			pstmt_p.setString(2,""+newlot_id[i]);
			pstmt_p.setString(3,""+newlocation_id[i]);

			int bx=pstmt_p.executeUpdate();

//			out.print("<br> Update LotLocation rows--->"+bx);

		}//end else

		//int newreceivetransaction_id=L.get_master_id(conp,"Receive_Transaction");
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

		pstmt_p.setString(5,""+quantity[i]);
//		out.print(" <br>quantity[i] "+quantity[i] );
		pstmt_p.setString(6,""+quantity[i]);
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
		pstmt_p.setString(12,""+(today_date));
//		out.print(" <br>today_date "+format.format(today_date) );
		
		pstmt_p.setString(13,""+user_id);
//		out.print(" <br>user_id "+ user_id);
		pstmt_p.setString(14,""+machine_name);
//		out.print(" <br>machine_name "+machine_name );
		pstmt_p.setString(15,""+newlocation_id[i]);
//		out.print(" <br>newlocation_id "+newlocation_id[i] );
		pstmt_p.setString(16,yearend_id);
		int a722=pstmt_p.executeUpdate();
//out.print("<br>Rows inserted inReceive Transaction (ADDED ROWS)--->"+a722);
//out.print("\\\\\\\\\\\\\\ ");

newreceivetransaction_id++;

}//end for added rows insertion in receive_transaction
 




samyakerror=756; 
				
		String party_name= A.getName(conp,"companyparty",companyparty_id);
		String cmpy_name=A.getName(conp,"companyparty",company_id);
//'"+format.getDate(consignment_date)+"'
				
				//out.print("<br>763 format.getDate(stockdate)="+format.getDate(stockdate));
		query="Update Receive set Receive_No=?,Receive_Date='"+format.getDate(consignment_date)+"',Receive_Lots=? ,Receive_Quantity=? ,Exchange_Rate=?,Receive_ExchangeRate=?,Tax= ?,Receive_Total=?,   Local_Total= ?,Dollar_Total= ?,Receive_FromId= ? ,Receive_FromName= ?     ,Company_Id= ?,Receive_ByName= ? ,Due_Days= ? ,Due_Date= '"+format.getDate(due_date)+"'   ,Modified_On= '"+today_date+"',Modified_By=?,Modified_MachineName= ?,stock_date='"+format.getDate(stockdate)+"',SalesPerson_Id=?,PurchaseSaleGroup_Id=?,Receive_Category=?,CgtRef_No=?,CgtDescription=?,sendForLocationId=?  where Receive_Id=?";
		
		pstmt_p=conp.prepareStatement(query);
		pstmt_p.setString(1,""+consignment_no); 
		//pstmt_p.setString(2,""+format.getDate(consignment_date)); 
		pstmt_p.setString(2,""+(counter-deletedcount)); 
	//out.print("<br> format.getDate(consignment_date)"+format.getDate(consignment_date));
		pstmt_p.setString(3,""+totquantity); 

		pstmt_p.setString(4,""+exchange_rate); 
		pstmt_p.setString(5,""+exchange_rate); 
		pstmt_p.setString(6,""+ctax); 
		pstmt_p.setDouble(7,total); 

		pstmt_p.setDouble(8,local_total); 
		pstmt_p.setDouble(9,dollar_total); 
		pstmt_p.setString(10,""+companyparty_id); 
		pstmt_p.setString(11,""+party_name); 

		pstmt_p.setString(12,""+company_id); 
		pstmt_p.setString(13,""+cmpy_name); 
		pstmt_p.setString(14,""+duedays); 
		//pstmt_p.setString(15,""+due_date); 
		//out.print("<br> 784  due_date"+due_date);

		//pstmt_p.setString(17,""+(today_date)); 
		pstmt_p.setString(15,""+user_id); 
		pstmt_p.setString(16,""+machine_name); 
		//pstmt_p.setString(17,""+format.getDate(consignment_date)); 
		pstmt_p.setString(17,""+salesperson_id);
		pstmt_p.setString(18,purchasesalegroup_id);
		pstmt_p.setString(19,receive_category_id);
		pstmt_p.setString(20,ref_no);
		pstmt_p.setString(21,description);
	//out.print("<br> 794 receive_id"+receive_id);	
		pstmt_p.setString(22,SendForLocation_id);
		pstmt_p.setString(23,""+receive_id);
samyakerror=796; 
		
		int ay=pstmt_p.executeUpdate();
//out.print("<br> 800 ay=="+ay);
samyakerror=800; 		
}//if final-flag 
	C.returnConnection(conp);
samyakerror=803; 
	}//else invoice no is not present in recive


}//end try 
catch(Exception Samyak499)
{ 

out.print("<BR> Error after ::- "+samyakerror);
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


 






