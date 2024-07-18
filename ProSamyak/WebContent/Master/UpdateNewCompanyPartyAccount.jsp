<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
//System.out.println("Inside UpdateParty.jsp");

Connection conp = null;
PreparedStatement pstmt_p=null;
ResultSet rs_g = null;
	
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;

String command   = request.getParameter("command");
//out.println("command is "+command);
String errLine="34";
if("SAVE".equals(command))
{
try{
	 conp=C.getConnection();
	//out.println(" CREATE Party");
	String query="";
	String companyparty_name =request.getParameter("companyparty_name");
	//out.println(companyparty_name);
	query = " Select * from Master_companyparty where  company_id="+company_id+" and companyparty_Name=?";
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1,companyparty_name);
	rs_g = pstmt_p.executeQuery();
	int company_exist =0;
	while(rs_g.next())
		{
		company_exist++;
		}//while
		pstmt_p.close();


 
	 query = " Select Account_Name from Master_Account where Account_name ='"+companyparty_name+"' and company_id="+company_id;
	pstmt_p  = conp.prepareStatement(query);
	
	rs_g = pstmt_p.executeQuery();
	
	while(rs_g.next())
		{
		company_exist++;
		}//while
		pstmt_p.close();
if(company_exist>0)
	{
C.returnConnection(conp);

	out.print("<body bgcolor=ffffee background='../Buttons/BGCOLOR.JPG'>" );
	out.print("<center><font class='star1'>Account "+companyparty_name+" alredy exists</font></center><br>" );
	out.print("<center><input type=button name=command value=Back class='Button1' onclick='history.go(-1)'></center>" );

	}
else{                             

String category_code =request.getParameter("category_code");
String address1	=request.getParameter("address1");
String address2	=request.getParameter("address2");
String address3	=request.getParameter("address3");
String city	=request.getParameter("city");	
String pin	=request.getParameter("pin");
String country	=request.getParameter("country");
String income_taxno= request.getParameter("income_taxno");
String sales_taxno= request.getParameter("sales_taxno");
String phone_off= request.getParameter("phone_off");
String phone_resi= request.getParameter("phone_resi");
String mobile=request.getParameter("mobile");
String email=request.getParameter("email");	
String website =request.getParameter("website");
String person1 =request.getParameter("person1");
String person2 =request.getParameter("person2");
String fax_no =request.getParameter("fax_no");	
String opening_date=request.getParameter("datevalue");
String currency=request.getParameter("currency");
String currency_limit=request.getParameter("currency_limit");
String credit_limit= request.getParameter("credit_limit");
String salesperson_id= request.getParameter("salesperson_id");
String purchaseperson_id= request.getParameter("purchaseperson_id");

String salespartygroup_id= request.getParameter("salespartygroup_id");
String purchasepartygroup_id= request.getParameter("purchasepartygroup_id");
String interest= request.getParameter("interest");

boolean currency_flag=true; //true=local=1;
int currency_limit_flag=1; //true=local=1;
if("local".equals(currency)){currency_flag=true;}
if("dollar".equals(currency)){currency_flag=false;}
if("local".equals(currency_limit)){currency_limit_flag=1;}
if("dollar".equals(currency_limit)){currency_limit_flag=0;}
String sr_no           =request.getParameter("sr_no");

String shikesho =request.getParameter("shikesho");
String duedays="";
	duedays =request.getParameter("duedays");

String closing =request.getParameter("closing");
String payment =request.getParameter("payment");
String sale =request.getParameter("sale");
out.println("<br> 102 sale="+sale);
String purchase =request.getParameter("purchase");
out.println("<br> 104 purchase="+purchase);
String pn =request.getParameter("pn");
out.println("<br> 106 pn="+pn);
String other=request.getParameter("check_amount");
out.println("<br> 108 other="+other);
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
out.println("<br>110 exchange_rate is"+exchange_rate);
double opening_salesbalance =0+Double.parseDouble(request.getParameter("opening_salesbalance"));
double opening_purchasebalance = Double.parseDouble(request.getParameter("opening_purchasebalance"));
double opening_pnbalance = Double.parseDouble(request.getParameter("opening_pnbalance"));
double opening_otherbalance=0.0;
//out.println("<br>110 opening_salesbalance is"+opening_salesbalance);
//out.println("<br>110 opening_purchasebalance is"+opening_purchasebalance);
out.println("<br>110 opening_pnbalance is"+opening_pnbalance);

String main_ledger=request.getParameter("main_ledger");
	out.println("<br> 112 main_ledger="+main_ledger);
String SubGroup=request.getParameter("SubGroup");
	out.println("<br> 114 SubGroup="+SubGroup);
String subgroup_name=request.getParameter("subgroup_name");
	out.println("<br> 116 subgroup_name="+subgroup_name);
String category=request.getParameter("category");
	out.println("<br> 118 category="+category);
double ledger_amount=Double.parseDouble(request.getParameter("ledger_amount"));
	out.println("<br> 120 ledger_amount="+ledger_amount);
String credit_limit_per_day=request.getParameter("credit_limit_per_day");
boolean sale_flag =false; 
boolean purchase_flag =false; 
boolean pn_flag =false; 
boolean shikesho_flag =false; 
boolean other_flag=false;
if("yes".equals(shikesho)){shikesho_flag=true;}
if("yes".equals(sale)){sale_flag=true;}
else{opening_salesbalance=0;}
if("yes".equals(purchase)){purchase_flag=true;}
else{opening_purchasebalance=0;}
if("yes".equals(pn)){pn_flag=true;}
else{opening_pnbalance=0;}
if("yes".equals(other)){other_flag=true;}
else{opening_pnbalance=0;}
out.print("<br> 135 sale_flag"+sale_flag);
out.print("<br> 136 purchase_flag"+purchase_flag);
out.print("<br> 137 pn_flag "+pn_flag);
out.print("<br> 137 other_flag "+other_flag);

if(main_ledger.equals("sale"))
{
	opening_salesbalance=ledger_amount;
	out.print("<br> 135 main ledger is sale ");
}
if(main_ledger.equals("purchase"))
{
	opening_purchasebalance=ledger_amount;
	out.print("<br> 154 main ledger is purchase");
}
if(main_ledger.equals("others"))
{
	opening_otherbalance=ledger_amount;
	out.print("<br> 158 main ledger is others");
}

String Head_Name=A.getName(conp,"Master_FinanceHeads","Head_Name","Head_Id",category);
	out.print("<br> 165 Head_Name"+Head_Name);

String sale_creditdebit= request.getParameter("sale_creditdebit");
String purchase_creditdebit= request.getParameter("purchase_creditdebit");
String pn_creditdebit= request.getParameter("pn_creditdebit");
String main_ledger_amount=request.getParameter("main_ledger_amount");
out.print("<br> 146 main_ledger_amount"+main_ledger_amount);
if("Debit".equals(sale_creditdebit))
{opening_salesbalance=0-opening_salesbalance;}
if("Debit".equals(purchase_creditdebit))
{opening_purchasebalance=0-opening_purchasebalance;}
if("Debit".equals(pn_creditdebit))
{opening_pnbalance=0-opening_pnbalance;}

if("Debit".equals(main_ledger_amount))
{ledger_amount=0-ledger_amount;}


double sale_localbalance=0;
double sale_dollarbalance=0;
double purchase_localbalance=0;
double purchase_dollarbalance=0;
double pn_localbalance=0;
double pn_dollarbalance=0;
double other_dollarbalance=0;
double other_localbalance=0;
double local_ledger_amount=0;
double dollar_ledger_amount=0;
String currency_id="";
if ("dollar".equals(currency))
{
	//local_currencysymbol="$";
	//currency_id="0";
purchase_dollarbalance=opening_purchasebalance;
sale_dollarbalance=opening_salesbalance;
pn_dollarbalance=opening_pnbalance;
other_dollarbalance=opening_otherbalance;
dollar_ledger_amount=opening_pnbalance;
other_localbalance= 
purchase_localbalance= opening_purchasebalance*exchange_rate;
sale_localbalance=opening_salesbalance*exchange_rate;
pn_localbalance=opening_pnbalance*exchange_rate;
other_localbalance=opening_otherbalance * exchange_rate;
local_ledger_amount=opening_pnbalance*exchange_rate;

}//if
else{
	//currency_id=local_currencyid;
purchase_localbalance=opening_purchasebalance;
pn_localbalance=opening_pnbalance;
sale_localbalance=opening_salesbalance;
other_localbalance= opening_otherbalance;

local_ledger_amount=opening_pnbalance;

purchase_dollarbalance= opening_purchasebalance/exchange_rate;
pn_dollarbalance=opening_pnbalance/exchange_rate;
sale_dollarbalance=opening_salesbalance/exchange_rate;
other_dollarbalance = opening_otherbalance / exchange_rate;
dollar_ledger_amount=opening_pnbalance/exchange_rate;

}//else if dollar

conp.setAutoCommit(false);
String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
 query = " INSERT INTO Master_companyparty (companyparty_Id, companyparty_Name, Category_Code,  Address1, Address2, Address3, City, Pin, Country, Company, Company_Id, Income_TaxNo, Sales_TaxNo, Phone_Off, Phone_resi, Mobile, Email, website, Person1, Person2, Fax, Active, Sr_No, Transaction_Currency, Opening_Date, Opening_RLocalBalance, Opening_RDollarBalance, Opening_RExchangeRate, Net_RLocalBalance, Net_RDollarBalance, RExchange_Rate, Opening_PLocalBalance, Opening_PDollarBalance, Opening_PExchangeRate, Net_PLocalBalance, Net_PDollarBalance, PExchange_Rate, Opening_PNLocalBalance, Opening_PNDollarBalance, Opening_PNExchangeRate, Sale,Purchase, PN, Modified_By, Modified_On, Modified_MachineName, Payment_Date, Closing_Date,Credit_Limit,Shikesho, Purchase_AdvanceLocal, Sale_AdvanceLocal, PN_AdvanceLocal, Purchase_AdvanceDollar, Sale_AdvanceDollar, PN_AdvanceDollar,Due_Days ,SalesPerson_Id,YearEnd_Id,PerDay_CreditLimit,CreditLimit_Currency) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,'"+format.getDate(opening_date)+"', ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',  ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?)";
//out.println("<br>"+query);		
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1, companyparty_id);
//out.print("<br >1 "+companyparty_id);
pstmt_p.setString (2, companyparty_name);
//out.print("<br >2 "+companyparty_name);
pstmt_p.setString (3, category_code);
//out.print("<br >3 "+category_code);
pstmt_p.setString (4, address1);
//out.print("<br >4 "+address1);
pstmt_p.setString (5, address2);
//out.print("<br >5 "+address2);
pstmt_p.setString (6, address3);
//out.print("<br >6 "+address3);
pstmt_p.setString (7, city);
//out.print("<br >7"+city);
pstmt_p.setString (8, pin);
//out.print("<br >8"+pin);
pstmt_p.setString (9, country);
//out.print("<br >9 "+country);	
pstmt_p.setBoolean (10,false);
//out.print("<br > 10 Company");	
pstmt_p.setString (11, company_id);
//out.print("<br > 11 "+company_id);
pstmt_p.setString (12, income_taxno);
//out.print("<br > 11 "+income_taxno);
pstmt_p.setString (13, sales_taxno);
//out.print("<br > 12 "+sales_taxno);
pstmt_p.setString (14, phone_off);
//out.print("<br > 13 "+phone_off);
pstmt_p.setString (15, phone_resi);
//out.print("<br >14 resi "+phone_resi);	
pstmt_p.setString (16, mobile);	
//out.print("<br> 13"+mobile);	
pstmt_p.setString (17, email);
//out.print("<br> 14"+email);	
pstmt_p.setString (18, website);
//out.print("<br> 17"+website);	
//out.print("<br > ok mmm"+website);	
pstmt_p.setString (19, salesperson_id);
//out.print("<br> 18"+person1);	
pstmt_p.setString (20, purchaseperson_id);
//out.print("<br> 19"+person2);
pstmt_p.setString (21, fax_no);
//out.print("<br> 20"+fax_no);	
pstmt_p.setBoolean (22, true);
pstmt_p.setString (23, companyparty_id);
//out.print("<br> 22"+companyparty_id); 
pstmt_p.setBoolean (24,currency_flag);		
pstmt_p.setDouble (25,sale_localbalance);
	//out.print("<br>226 sale_localbalance="+sale_localbalance);	
pstmt_p.setDouble (26,sale_dollarbalance);
	//out.print("<br> 228sale_dollarbalance=>"+sale_dollarbalance);	
pstmt_p.setDouble (27, exchange_rate);
//out.print("<br> 2307"+user_id);	
pstmt_p.setDouble (28, sale_localbalance);
	//out.print("<br>232 sale_localbalance="+sale_localbalance);	
pstmt_p.setDouble (29, sale_dollarbalance);
	//out.print("<br> 7"+user_id);	
pstmt_p.setString (30,""+ exchange_rate);		 
pstmt_p.setDouble (31, purchase_localbalance);
	//out.print("<br> 293  purchase_localbalance"+purchase_dollarbalance);	
pstmt_p.setDouble (32, purchase_dollarbalance);
	//out.print("<br> 295  purchase_dollarbalance"+purchase_dollarbalance);	
pstmt_p.setString (33,""+ exchange_rate);
//out.print("<br> 7"+user_id);	
pstmt_p.setDouble (34, purchase_localbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setDouble (35, purchase_dollarbalance);
//out.print("<br> 135"+user_id);	
pstmt_p.setString (36,""+ exchange_rate);
pstmt_p.setDouble (37, pn_localbalance);
//out.print("<br> pn_localbalance"+pn_localbalance);	
pstmt_p.setDouble (38, pn_dollarbalance);
//out.print("<br> 306 pn_dollarbalance"+pn_dollarbalance);	
pstmt_p.setString (39,""+ exchange_rate);		 
pstmt_p.setBoolean (40, sale_flag);
pstmt_p.setBoolean (41, purchase_flag);
pstmt_p.setBoolean (42, pn_flag);
pstmt_p.setString (43,user_id);	
pstmt_p.setString (44,machine_name);
pstmt_p.setString (45,payment);
pstmt_p.setString (46,closing);
pstmt_p.setString (47,credit_limit);
pstmt_p.setBoolean (48,shikesho_flag);
pstmt_p.setDouble (49, purchase_localbalance);
	//out.print("<br>255 purchase_localbalance "+purchase_localbalance);
pstmt_p.setDouble (50,((sale_localbalance)*-1));
	//out.print("<br>255 sale_localbalance "+sale_localbalance);
pstmt_p.setDouble (51, pn_localbalance);
pstmt_p.setDouble (52,(purchase_dollarbalance));
	//out.print("<br>255 sale_dollarbalance"+sale_dollarbalance);
pstmt_p.setDouble (53,((sale_dollarbalance)*-1));
	//out.print("<br>255 sale_dollarbalance"+sale_dollarbalance);
pstmt_p.setDouble (54, pn_dollarbalance);

pstmt_p.setString (55,""+duedays);
pstmt_p.setString (56,""+salesperson_id);
pstmt_p.setString (57,yearend_id);
pstmt_p.setString (58,credit_limit_per_day);
out.print("<br>255 credit_limit_per_day"+credit_limit_per_day);
pstmt_p.setString (59,""+currency_limit_flag);



int a140 = pstmt_p.executeUpdate();
//System.out.println(" <font color=red>Added Successfully: " +a140+" pn_flag:-"+pn_flag);
//out.println(" Added Successfully139: " +a140);
pstmt_p.close();

int ledger_id=Integer.parseInt(""+L.get_master_id(conp,"Ledger"));

query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id,MainLedger) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?, ?,?,?,?)";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,company_id);
//out.print("<br >2 "+company_id);
pstmt_p.setString (3,"14");
//out.print("<br >3 ");
pstmt_p.setString (4,companyparty_id);
//out.print("<br >4 ");
pstmt_p.setString (5,companyparty_name+" Sales");
//out.print("<br> 323 companyparty_name "+companyparty_name);
pstmt_p.setString (6,"1");
//out.print("<br >4 "+"1");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
pstmt_p.setBoolean (10, sale_flag);
pstmt_p.setString (11,yearend_id);
pstmt_p.setDouble (12,sale_localbalance);
pstmt_p.setDouble (13,sale_localbalance);
pstmt_p.setDouble (14,sale_dollarbalance);
pstmt_p.setString (15,""+exchange_rate);
pstmt_p.setString (16,""+salespartygroup_id);
pstmt_p.setString (17,""+interest);


pstmt_p.setString (18,""+companyparty_id);

if(main_ledger.equals("sale"))
	pstmt_p.setBoolean(19,true);
else
	pstmt_p.setBoolean(19,false);




//out.print("<br >9 "+machine_name);
int aledger1 = pstmt_p.executeUpdate();
pstmt_p.close();
System.out.println(" <font color=red> ledger 1Added Successfully: " +aledger1+" pn_flag:-"+pn_flag);
ledger_id=ledger_id+1;
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate, PartyGroup_Id,ParentCompanyParty_Id,MainLedger) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?,?,?,?)";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,company_id);
//out.print("<br >2 "+company_id);
pstmt_p.setString (3,"14");
//out.print("<br >3 ");
pstmt_p.setString (4,companyparty_id);
//out.print("<br >4 ");
pstmt_p.setString (5,companyparty_name+" Purchase");
pstmt_p.setString (6,"2");
//out.print("<br >4 "+"2");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
pstmt_p.setBoolean (10, purchase_flag);
pstmt_p.setString (11,yearend_id);
pstmt_p.setDouble (12,purchase_localbalance);
pstmt_p.setDouble (13,purchase_localbalance);
pstmt_p.setDouble (14,purchase_dollarbalance);
pstmt_p.setString (15,""+exchange_rate);
pstmt_p.setString (16,""+purchasepartygroup_id);
pstmt_p.setString (17,""+companyparty_id);

if(main_ledger.equals("purchase"))
	pstmt_p.setBoolean(18,true);
else
	pstmt_p.setBoolean(18,false);

//out.print("<br >9 "+machine_name);
int aledger2 = pstmt_p.executeUpdate();

pstmt_p.close();

ledger_id=ledger_id+1;
query=query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,ParentCompanyParty_Id,MainLedger) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?,?,?)";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,company_id);
//out.print("<br >2 "+company_id);
pstmt_p.setString (3,"14");
//out.print("<br >3 ");
pstmt_p.setString (4,companyparty_id);
//out.print("<br >4 ");
pstmt_p.setString (5,companyparty_name+" PN");
pstmt_p.setString (6,"3");
//out.print("<br >4 "+"3");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
pstmt_p.setBoolean (10, pn_flag);
pstmt_p.setString (11,yearend_id);
pstmt_p.setDouble (12,local_ledger_amount);
pstmt_p.setDouble (13,local_ledger_amount);
pstmt_p.setDouble (14,dollar_ledger_amount);
pstmt_p.setString (15,""+exchange_rate);
pstmt_p.setString (16,""+companyparty_id);

if(main_ledger.equals("pn"))
	pstmt_p.setBoolean(17,true);
else
pstmt_p.setBoolean(17,false);


//out.print("<br >9 "+machine_name);
int aledger3 = pstmt_p.executeUpdate();
pstmt_p.close();

/********    To Add  other ledger    *************/


int ledger_id3=Integer.parseInt(""+L.get_master_id(conp,"Ledger"));

query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id,MainLedger) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?, ?,?,?,?)";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledger_id3);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,company_id);
//out.print("<br >2 "+company_id);
pstmt_p.setString (3,category);
//out.print("<br >3 ");
pstmt_p.setString (4,category);
//out.print("<br >4 ");
pstmt_p.setString (5,companyparty_name);
pstmt_p.setString (6,SubGroup);
//out.print("<br >4 "+"1");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);


pstmt_p.setBoolean (10,other_flag);

pstmt_p.setString (11,yearend_id);
pstmt_p.setDouble (12,other_localbalance);
pstmt_p.setDouble (13,other_localbalance);
pstmt_p.setDouble (14,other_dollarbalance);
pstmt_p.setString (15,""+exchange_rate);
pstmt_p.setString (16,""+salespartygroup_id);
pstmt_p.setString (17,""+interest);


pstmt_p.setString (18,""+companyparty_id);

if(main_ledger.equals("others".trim()))
	pstmt_p.setBoolean(19,true);
else	
    pstmt_p.setBoolean(19,false);

int aledger4 = pstmt_p.executeUpdate();
pstmt_p.close();
/********** End of other ledger   **********/
conp.commit();

C.returnConnection(conp);


response.sendRedirect("NewCompanyPartyAccount.jsp?message=Account <font color=blue> "+companyparty_name+" </font>successfully Added."+"&account_no=Party");
}
}catch(Exception Samyak82){ 
	out.println("<font color=red> FileName : UpdateCompany.jsp <br>Bug No Samyak82 :"+ Samyak82 +"</font>");}
}
// if ADD Comapny


if("UPDATE".equals(command))
{
try{
errLine="482";
conp=C.getConnection();
errLine="483";
//out.println("Update Party");
conp.setAutoCommit(false);
String companyparty_id	=
request.getParameter("companyparty_id");
//out.println("<br> <font color=blue>Update CompanyParty id is</font> "+companyparty_id);
String companyparty_name =request.getParameter("companyparty_name");
String main_ledger=request.getParameter("main_ledger");
out.println("<br> main_ledger " +main_ledger);

String presentquery="select * from Master_CompanyParty where companyparty_id<>"+companyparty_id+" and company_id="+company_id+" and companyparty_name=?";
pstmt_p=conp.prepareStatement(presentquery);
pstmt_p.setString(1, companyparty_name);
rs_g=pstmt_p.executeQuery();
int present=0;
while(rs_g.next())
{
	present++;
}
//out.print("<br>present"+present);
pstmt_p.close();
errLine="504";
if(null==request.getParameter("sale"))
{
	
	String str_ledger_exist="select  count(*) as counter from Receive where Purchase=1 and Receive_sell=0 and Opening_Stock=0 and Stocktransfer_Type=0 and Active=1 and Receive_FromId="+companyparty_id;	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	int rows=0;
	while(rs_g.next())
	{
		rows=rs_g.getInt("counter");
	}
	pstmt_p.close();

	str_ledger_exist="select ledger_id from ledger where For_HeadId="+companyparty_id+" and ledger_type=1 and active=1";	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	String ledger_id="";
	while(rs_g.next())
	{
		ledger_id=rs_g.getString("ledger_id");
	}
	pstmt_p.close();

	str_ledger_exist="select count(*) as counter from Financial_Transaction where ReceiveFrom_LedgerId="+ledger_id +" and active=1";	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	int rows1=0;
	while(rs_g.next())
	{
		rows1=rs_g.getInt("counter");
	}
	pstmt_p.close();
	if((rows+rows1)>0)
	{
				C.returnConnection(conp);
				out.print("<html> <head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'></head><body><br><center><font class=msgred> This Ledger already exists in transaction You can not remove it </font></center>");
				out.print("<br><center><input type=button name=command value=Back onclick=history.back(1) class=button1></center></body></html>");
	}

}
if(null==request.getParameter("purchase"))
{
	String str_ledger_exist="select  count(*) as counter from Receive where Purchase=1 and Receive_sell=1 and Opening_Stock=0 and Stocktransfer_Type=0 and Active=1 and Receive_FromId="+companyparty_id;	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	int rows=0;
	while(rs_g.next())
	{
		rows=rs_g.getInt("counter");
	}
	pstmt_p.close();

	str_ledger_exist="select ledger_id from ledger where For_HeadId="+companyparty_id+" and ledger_type=2 and active=1";	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	String ledger_id="";
	while(rs_g.next())
	{
		ledger_id=rs_g.getString("ledger_id");
	}
	pstmt_p.close();

	str_ledger_exist="select count(*) as counter from Financial_Transaction where ReceiveFrom_LedgerId="+ledger_id +" and active=1";	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	int rows1=0;
	while(rs_g.next())
	{
		rows1=rs_g.getInt("counter");
	}
	pstmt_p.close();
	if((rows+rows1)>0)
	{
				C.returnConnection(conp);
				out.print("<html> <head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'></head><body><br><center><font class=msgred> This Ledger already exists in transaction You can not remove it </font></center>");
				out.print("<br><center><input type=button name=command value=Back onclick=history.back(1) class=button1></center></body></html>");
	}

	

}
if(null==request.getParameter("check_amount"))
{
		
	out.println("<br> 649");
	String str_ledger_exist="select ledger_id from ledger where PartyGroup_Id="+companyparty_id+" and active=1";	
	pstmt_p=conp.prepareStatement(str_ledger_exist);
	
	rs_g=pstmt_p.executeQuery();
	String ledger_id="0";
	while(rs_g.next())
	{
		ledger_id=rs_g.getString("ledger_id");
	}
	pstmt_p.close();

	int rows1=0;
	if(!(ledger_id.equals("0")))
	{
		str_ledger_exist="select count(*) as counter from Financial_Transaction where Ledger_Id="+ledger_id +" and active=1";	
		pstmt_p=conp.prepareStatement(str_ledger_exist);
	
		out.println("str_ledger_exist="+str_ledger_exist);
		rs_g=pstmt_p.executeQuery();
		
		while(rs_g.next())
		{
			rows1=rs_g.getInt("counter");
		}
		pstmt_p.close();
	}

	if((rows1)>0)
	{
		C.returnConnection(conp);
		out.print("<html> <head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'></head><body><br><center><font class=msgred> This Ledger already exists in transaction You can not remove it </font></center>");
		out.print("<br><center><input type=button name=command value=Back onclick=history.back(1) class=button1></center></body></html>");
	}

}
if(present!=0)
{
	C.returnConnection(conp);

	out.print("<html> <head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'></head><body><br><center><font class=msgred> The Account name already exists please select another name </font></center>");
	out.print("<br><center><input type=button name=command value=Back onclick=history.back(1) class=button1></center></body></html>");
}
else
{	
errLine="515";
String category_code =""+request.getParameter("category_code");
String currency =request.getParameter("currency");
String currency_limit =request.getParameter("currency_limit");
boolean flag_currecny=false; 
int flag_currecny_limit=0; 
if("local".equals(currency)){flag_currecny=true;}
if("local".equals(currency_limit)){flag_currecny_limit=1;}
String sale =request.getParameter("sale");
String purchase =request.getParameter("purchase");
String pn =request.getParameter("pn");
pn="no";
//out.print("<br>pn="+pn);
//out.print("<br>sale="+sale);
//out.print("<br>purchase="+purchase);
String check_amount=request.getParameter("check_amount");
String address1	=request.getParameter("address1");
String address2	=request.getParameter("address2");
String address3	=request.getParameter("address3");
String city	=request.getParameter("city");	
String pin	=request.getParameter("pin");
String country	=request.getParameter("country");
String income_taxno= request.getParameter("income_taxno");
String sales_taxno= request.getParameter("sales_taxno");
String phone_off= request.getParameter("phone_off");
String phone_resi= request.getParameter("phone_resi");
String mobile=request.getParameter("mobile");
String email=request.getParameter("email");	
String website =request.getParameter("website");
String person1 =request.getParameter("person1");
String person2 =request.getParameter("person2");
String fax_no =request.getParameter("fax_no");	
String active =request.getParameter("active");
//System.out.println("active="+active);
String closing =request.getParameter("closing");
String payment =request.getParameter("payment");
String credit_limit= request.getParameter("credit_limit");
String shikesho =request.getParameter("shikesho");
String salesperson_id=request.getParameter("salesperson_id");
String duedays=request.getParameter("duedays");
String datevalue =request.getParameter("datevalue");
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);

double opening_salesbalance =0+Double.parseDouble(request.getParameter("opening_salesbalance"));
//out.println("<br>102 opening_salesbalance is"+opening_salesbalance);
errLine="594";
double opening_purchasebalance = Double.parseDouble(request.getParameter("opening_purchasebalance"));
//out.println("<br>102 opening_purchasebalance"+opening_purchasebalance);

double opening_pnbalance = Double.parseDouble(request.getParameter("opening_pnbalance"));
//out.println("<br>102 opening_pnbalance is"+opening_pnbalance);

errLine="595";
double advsale_locbalance= Double.parseDouble(request.getParameter("advsale_locbalance"));
double advpurchase_locbalance = Double.parseDouble(request.getParameter("advpurchase_locbalance"));
double advpn_locbalance = Double.parseDouble(request.getParameter("advpn_locbalance"));

double advsale_dolbalance = Double.parseDouble(request.getParameter("advsale_dolbalance"));
double advpurchase_dolbalance= Double.parseDouble(request.getParameter("advpurchase_dolbalance"));
double advpn_dolbalance= Double.parseDouble(request.getParameter("advpn_dolbalance"));

String isDrCr=request.getParameter("isDrCr");




errLine="604";
double oldsale_locbalance= Double.parseDouble(request.getParameter("oldsale_locbalance"));
double oldpurchase_locbalance = Double.parseDouble(request.getParameter("oldpurchase_locbalance"));
double oldpn_locbalance = Double.parseDouble(request.getParameter("oldpn_locbalance"));

double oldsale_dolbalance = Double.parseDouble(request.getParameter("oldsale_dolbalance"));
double oldpurchase_dolbalance= Double.parseDouble(request.getParameter("oldpurchase_dolbalance"));
double oldpn_dolbalance= Double.parseDouble(request.getParameter("oldpn_dolbalance"));
errLine="618";
double interest= Double.parseDouble(request.getParameter("interest"));
errLine="614";
//double 
String salespartygroup_id = request.getParameter("salespartygroup_id");
String purchasepartygroup_id = request.getParameter("purchasepartygroup_id");

String category=request.getParameter("category");
String subgroup_name=request.getParameter("subgroup_name");
String SubGroup=request.getParameter("SubGroup");
//String main_ledger_amount=request.getParameter("main_ledger_amount");
String main_ledger_amount=request.getParameter("isDrCr");
//out.print("<br> 656 category"+category);

//out.print("<br> 656 main_ledger_amount"+main_ledger_amount);
String credit_limit_per_day=request.getParameter("credit_limit_per_day");

double opening_othersbalance =0.00;
double ledger_amount=Double.parseDouble(request.getParameter("opening_amount"));

//out.println(active);
//out.print("<br> 656 ledger_amount"+ledger_amount);
boolean shikesho_flag =false; 

if("yes".equals(shikesho)){shikesho_flag=true;}
boolean sale_flag =false; 
boolean purchase_flag =false; 
boolean pn_flag =false; 
boolean flag =false; 
boolean other_flag=false;
if("yes".equals(active))
{
	flag=true;
	if("yes".equals(sale)){sale_flag=true;}
	else{opening_salesbalance=0;}
	if("yes".equals(purchase)){purchase_flag=true;}
	else{opening_purchasebalance=0;}
	if("yes".equals(pn))
	{pn_flag=true;}
	else{opening_pnbalance=0;}
	if("yes".equals(check_amount)){other_flag=true;}
	else{opening_pnbalance=0;}
}
else
{
	sale_flag =false; 
	purchase_flag =false; 
	pn_flag =false; 
	other_flag=false;
}

//out.print("<br> 656 sale_flag"+sale_flag);
//out.print("<br> 657 purchase_flag"+purchase_flag);
//out.print("<br> 658 pn_flag"+pn_flag);
//out.print("<br> other_flag="+other_flag);
errLine="614";
String sale_creditdebit= request.getParameter("sale_creditdebit");
String purchase_creditdebit= request.getParameter("purchase_creditdebit");
String pn_creditdebit= request.getParameter("pn_creditdebit");
///out.println("<br ><font color=blue>pn_creditdebit"+pn_creditdebit+"</font>");

if("Debit".equals(sale_creditdebit))
{opening_salesbalance=0-opening_salesbalance;}
if("Debit".equals(purchase_creditdebit))
{opening_purchasebalance=0-opening_purchasebalance;}
if("Debit".equals(pn_creditdebit))
{opening_pnbalance=0-opening_pnbalance;}
if("Debit".equals(main_ledger_amount))
{ledger_amount=0-ledger_amount;}


if(main_ledger.equals("sale"))
{
	opening_salesbalance=ledger_amount;
	opening_purchasebalance=0.0;
	opening_pnbalance=0.0;
	opening_othersbalance=0.0;
}
if(main_ledger.equals("purchase"))
{
	opening_purchasebalance=ledger_amount;
	opening_salesbalance=0.0;
	opening_pnbalance=0.0;
	opening_othersbalance=0.0;
}
if(main_ledger.equals("others"))
{
	opening_othersbalance=ledger_amount;
	opening_salesbalance=0.0;
	opening_purchasebalance=0.0;
	opening_pnbalance=0.0;
}

double sale_localbalance=0;
double sale_dollarbalance=0;
double purchase_localbalance=0;
double purchase_dollarbalance=0;
double pn_localbalance=0;
double pn_dollarbalance=0;
double other_dollarbalance=0;
double other_localbalance=0;
double ledger_localbalance=0;
double ledger_dollarbalance=0;

String Head_Name=A.getName(conp,"Master_FinanceHeads","Head_Name","Head_Id",category);
	//out.print("<br> 165 Head_Name"+Head_Name);

//out.println("<font color=red>currency"+currency+"</font>");
String currency_id="";
if ("dollar".equals(currency))
	{
	//local_currencysymbol="$";
	//currency_id="0";
		purchase_dollarbalance=opening_purchasebalance;
		sale_dollarbalance=opening_salesbalance;
		pn_dollarbalance=opening_pnbalance;
		ledger_dollarbalance=ledger_amount;
		other_dollarbalance = opening_othersbalance;

		purchase_localbalance= opening_purchasebalance*exchange_rate;
		sale_localbalance=opening_salesbalance*exchange_rate;
		pn_localbalance=opening_pnbalance*exchange_rate;
		other_localbalance = opening_othersbalance * exchange_rate;
		ledger_localbalance=ledger_amount*exchange_rate;
}//if
else{
	//currency_id=local_currencyid;
		purchase_localbalance=opening_purchasebalance;
		pn_localbalance=opening_pnbalance;
		sale_localbalance=opening_salesbalance;
		ledger_localbalance=ledger_amount;
		other_localbalance= opening_othersbalance;

		purchase_dollarbalance= opening_purchasebalance/exchange_rate;
		pn_dollarbalance=opening_pnbalance/exchange_rate;
		sale_dollarbalance=opening_salesbalance/exchange_rate;
		ledger_dollarbalance=ledger_amount/exchange_rate;
		other_dollarbalance= opening_othersbalance / exchange_rate;
}//else if dollar

/* 
	test
*/
/*out.print("<br>advsale_locbalance "+advsale_locbalance);
out.print("<br>oldsale_locbalance "+oldsale_locbalance);
out.print("<br>sale_localbalance "+sale_localbalance);*/
advsale_locbalance = advsale_locbalance + oldsale_locbalance - sale_localbalance;
//out.print("<br>advsale_locbalance final "+advsale_locbalance+"</font>");

/*          
test	
*/

advpurchase_locbalance = advpurchase_locbalance - oldpurchase_locbalance + purchase_localbalance;
advpn_locbalance = advpn_locbalance - oldpn_locbalance + pn_localbalance; 

/*
test
*/
//out.print("<br>advsale_dolbalance "+advsale_dolbalance);
//out.print("<br>111111111111oldsale_dolbalance "+oldsale_dolbalance);
//out.print("<br>sale_dollarbalance "+sale_dollarbalance);
advsale_dolbalance = advsale_dolbalance + oldsale_dolbalance - sale_dollarbalance;
//out.print("<br>advsale_dolbalance final "+advsale_dolbalance+"</font>");

/*
test	
*/

advpurchase_dolbalance= advpurchase_dolbalance - oldpurchase_dolbalance + purchase_dollarbalance;
advpn_dolbalance= advpn_dolbalance - oldpn_dolbalance  + pn_dollarbalance;


//query="Select * from Receive where Receive_FromId=?";
//pstmt_p = conp.prepareStatement(query);
//rs_g=pstmt_p.

String sr_no =request.getParameter("sr_no");
//out.println("12312312<br>Sr_No"+sr_no);
//pn_flag
//active=22
errLine="707";
String query = "Update Master_companyparty set companyparty_Name=?,  Category_Code=?,  Address1=?, Address2=?, Address3=?, City=?, Pin=?, Country=?, Company=?,Income_TaxNo=?, Sales_TaxNo=?, Phone_Off=?,Phone_resi=?, Mobile=?, Email=?, website=?, Person1=?, Person2=?, Fax=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Active=?, Transaction_Currency=?, Opening_Date='"+format.getDate(datevalue)+"', Opening_RLocalBalance=?, Opening_RDollarBalance=?, Opening_RExchangeRate=?, Net_RLocalBalance=?, Net_RDollarBalance=?, RExchange_Rate=?, Opening_PLocalBalance=?, Opening_PDollarBalance=?, Opening_PExchangeRate=?, Net_PLocalBalance=?,Net_PDollarBalance=?,PExchange_Rate=?, Opening_PNLocalBalance=?,Opening_PNDollarBalance=?, Opening_PNExchangeRate=?, Sale=?, Purchase=?, PN=?, Payment_Date=?, Closing_Date=?, Credit_Limit=?,Shikesho=?, Purchase_AdvanceLocal=?, Sale_AdvanceLocal=?, PN_AdvanceLocal=?, Purchase_AdvanceDollar=?, Sale_AdvanceDollar=?, PN_AdvanceDollar=?, Due_Days=?, SalesPerson_Id=?,PerDay_CreditLimit=?,CreditLimit_Currency=? where companyparty_Id=?"; 

//out.println("<br>"+query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,companyparty_name);
//out.print("<br>1 "+companyparty_name);
pstmt_p.setString (2,category_code);	
//out.print("<br>2 "+category_code);
pstmt_p.setString (3,address1);		
//out.print("<br >4 "+address1);
pstmt_p.setString (4,address2);
//out.print("<br >5 "+address2);
pstmt_p.setString (5,address3);
//out.print("<br >6 "+address3);
pstmt_p.setString (6,city);
//out.print("<br>7"+city);
pstmt_p.setString (7,pin);
//out.print("<br>8"+pin);
pstmt_p.setString (8,country);
//out.print("<br>9 "+country);	
pstmt_p.setBoolean (9,false); 
//out.print("<br> 10 Company");	
pstmt_p.setString (10,income_taxno);
//out.print("<br> 11 "+income_taxno);
pstmt_p.setString (11,sales_taxno);
//out.print("<br> 12 "+sales_taxno);
pstmt_p.setString (12,phone_off);
//out.print("<br> 13 "+phone_off);
pstmt_p.setString (13,phone_resi);
//out.print("<br>14 resi "+phone_resi);	
pstmt_p.setString (14,mobile);	//out.print("<br>15"+mobile);	
pstmt_p.setString (15,email);	//out.print("<br>16"+email);	
pstmt_p.setString (16,website); //out.print("<br>17"+website);	
pstmt_p.setString (17,person1);//out.print("<br>18"+person1);	
pstmt_p.setString (18,person2);
//out.print("<br>19"+person2);
pstmt_p.setString (19,fax_no);	//out.print("<br>20"+fax_no);	
pstmt_p.setString (20,user_id);	
pstmt_p.setString (21,machine_name);
pstmt_p.setBoolean(22,flag);
//out.print("<br>active flag21"+flag);	
pstmt_p.setBoolean(23,flag_currecny);
//out.print("<br>23 flag_currecny"+flag_currecny);	
pstmt_p.setDouble (24,sale_localbalance);
//out.print("<font color=red><br> sale_localbalance 24:"+sale_localbalance+"</font>");	
//out.print("<br> 2400000000");	

pstmt_p.setDouble (25,sale_dollarbalance);

//out.print("<br>  sale_dollarbalance 25"+sale_dollarbalance);	
pstmt_p.setString (26,""+exchange_rate);
//out.print("<br> 26"+exchange_rate);	
pstmt_p.setDouble (27,sale_localbalance);
//out.print("<br> sale_localbalance"+sale_localbalance);	
pstmt_p.setDouble (28,sale_dollarbalance);
//out.print("<br> sale_dollarbalance"+sale_dollarbalance);	
pstmt_p.setString (29,""+exchange_rate);

pstmt_p.setDouble (30,purchase_localbalance);
//out.print("<font color=blue><br> 30 purchase_localbalance "+purchase_localbalance+"</font>");	
pstmt_p.setDouble (31,purchase_dollarbalance);
//out.print("<br> 31"+purchase_dollarbalance);	
pstmt_p.setString (32,""+exchange_rate);
//out.print("<br> 32"+exchange_rate);	
pstmt_p.setDouble (33,purchase_localbalance);
//out.print("<br> 33 purchase_localbalance"+purchase_localbalance);	
pstmt_p.setDouble (34,purchase_dollarbalance);
//out.print("<br> purchase_dollarbalance"+purchase_dollarbalance);	
pstmt_p.setString (35,""+exchange_rate);
pstmt_p.setDouble (36,pn_localbalance);
//out.print("<font color=red><br> 34"+pn_localbalance+"</font>");	
pstmt_p.setDouble (37,pn_dollarbalance);
pstmt_p.setString (38,""+exchange_rate);		 
pstmt_p.setBoolean(39,sale_flag);
//out.print("<br>39 sale_flag "+sale_flag);	
pstmt_p.setBoolean(40, purchase_flag);
//out.print("<br>40 purchase flag "+purchase_flag);	
pstmt_p.setBoolean(41,pn_flag);
//out.print("<br>41 pn_flag "+pn_flag);	
pstmt_p.setString (42,payment);
pstmt_p.setString (43,closing);
pstmt_p.setString (44,credit_limit);
pstmt_p.setBoolean(45,shikesho_flag);
pstmt_p.setDouble (46,advpurchase_locbalance);
pstmt_p.setDouble (47,advsale_locbalance);
//out.print("<br >advsale_locbalance"+advsale_locbalance);
pstmt_p.setDouble (48,advpn_locbalance);
pstmt_p.setDouble (49,advpurchase_dolbalance);
pstmt_p.setDouble (50,advsale_dolbalance);
//out.print("<br >advsale_dolbalance "+advsale_dolbalance);
pstmt_p.setDouble (51,advpn_dolbalance);
pstmt_p.setString (52,""+duedays);
pstmt_p.setString (53,""+salesperson_id);
pstmt_p.setString (54,""+credit_limit_per_day);
pstmt_p.setString (55,""+flag_currecny_limit);
pstmt_p.setString (56,companyparty_id);
//out.print("<br >42 "+companyparty_id);
  
int a = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a);
//out.println("<br>706 Updated Successfully:" +a);
pstmt_p.close();

errLine="806";


String saleledger_id= A.getNameCondition(conp,"Ledger","Ledger_id","Where For_head=14 and for_headid="+companyparty_id+" and company_id="+company_id+" and Ledger_Type=1" );
out.println("<font color=blue>sale Ledger Id is </blue>"+saleledger_id);

query="Update Ledger set Active=?, Ledger_name=? ,Opening_Balance=?,Opening_LocalBalance=?,Opening_DollarBalance=?,Exchange_Rate=?,PartyGroup_Id=?,Interest=?,ParentCompanyParty_Id=?,MainLedger=? where Ledger_id=? " ;

pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,sale_flag);
pstmt_p.setString (2, companyparty_name+" Sales");
//out.println("companyparty_name="+companyparty_name);
 pstmt_p.setDouble(3,sale_localbalance);
//out.println("sale_localbalance="+sale_localbalance);
 pstmt_p.setDouble(4,sale_localbalance);
 //out.println("sale_localbalance="+sale_localbalance);
 pstmt_p.setDouble(5,sale_dollarbalance);
 //out.println("sale_dollarbalance="+sale_dollarbalance);
 pstmt_p.setDouble(6,exchange_rate);
 //out.println("exchange_rate="+exchange_rate);
 pstmt_p.setString(7,""+salespartygroup_id);
 //out.println("salespartygroup_id="+salespartygroup_id);
 pstmt_p.setString(8,""+interest);
 //out.println("interest="+interest);
 
 pstmt_p.setString(9,companyparty_id);	
//out.println("companyparty_id="+companyparty_id);
 if("sale".equals(main_ledger))
	pstmt_p.setBoolean(10,true);
 else
	pstmt_p.setBoolean(10,false);
pstmt_p.setString(11,saleledger_id);
//out.println("saleledger_id="+saleledger_id);
int a489 = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a489);
//out.println("<br>730 Updated Successfully:a489" +a489);
pstmt_p.close();
errLine="833";
String purchaseledger_id= A.getNameCondition(conp,"Ledger","Ledger_id","Where For_head=14 and for_headid="+companyparty_id+" and company_id="+company_id+" and Ledger_Type=2" );
//out.println("<font color=blue>Purchase Ledger Id is </blue>"+purchaseledger_id);
query=query="Update Ledger set Active=?, Ledger_name=? ,Opening_Balance=?,Opening_LocalBalance=?,Opening_DollarBalance=?,Exchange_Rate=?,PartyGroup_id=?,ParentCompanyParty_Id=?,MainLedger=? where Ledger_id=? " ;
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,purchase_flag);
pstmt_p.setString (2, companyparty_name+" Purchase");
pstmt_p.setDouble(3,purchase_localbalance);
pstmt_p.setDouble(4,purchase_localbalance);
pstmt_p.setDouble(5,purchase_dollarbalance);
pstmt_p.setString(6,""+exchange_rate);
pstmt_p.setString(7,""+purchasepartygroup_id);

pstmt_p.setString(8,""+companyparty_id);
if("purchase".equals(main_ledger))
	pstmt_p.setBoolean(9,true);
else
	pstmt_p.setBoolean(9,false);
pstmt_p.setString(10,purchaseledger_id);
int a577 = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a489);
//out.println("<br>749 Updated Successfully:a489" +a577);

pstmt_p.close();
errLine="856";
String pnledger_id= A.getNameCondition(conp,"Ledger","Ledger_id","Where For_head=14 and for_headid="+companyparty_id+" and company_id="+company_id+" and Ledger_Type=3" );
//out.println("<font color=blue>PN Ledger Id is </blue>"+pnledger_id);
query="Update Ledger set Active=?, Ledger_name=? ,Opening_Balance=?,Opening_LocalBalance=?,Opening_DollarBalance=?,Exchange_Rate=?,ParentCompanyParty_Id=?,MainLedger=? where Ledger_id=? " ;
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,pn_flag);
pstmt_p.setString (2, companyparty_name+" PN");
pstmt_p.setDouble(3,pn_localbalance);
pstmt_p.setDouble(4,pn_localbalance);
pstmt_p.setDouble(5,pn_dollarbalance);
pstmt_p.setString(6,""+exchange_rate);

pstmt_p.setString(7,companyparty_id);
if("pn".equals(main_ledger))
	pstmt_p.setBoolean(8,true);
else
	pstmt_p.setBoolean(8,false);
pstmt_p.setString(9,pnledger_id);
int a589 = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a489);
//out.println("<br>767Updated Successfully:a489" +a589);
pstmt_p.close();
//Hans
errLine="879";

///// For Insertion or updation of Ledger  ///////
query="select count(*) as counter from Ledger where For_Head<>14 and ParentCompanyParty_Id="+companyparty_id+" and company_id="+company_id+"";  
pstmt_p = conp.prepareStatement(query);
rs_g=pstmt_p.executeQuery();
int cnt=0;
while(rs_g.next())
{	
	cnt=rs_g.getInt("counter");
} //while
pstmt_p.close();
errLine="890";
if(cnt!=0)
{
		errLine="893";
		String ledger_ledger_id= A.getNameCondition(conp,"Ledger","Ledger_id","Where For_head<>14 and parentCompanyParty_Id="+companyparty_id+" and company_id="+company_id+" and Ledger_Type not in(1,2,3)" );
		//out.println("<font color=blue>PN Ledger Id is </blue>"+pnledger_id);
		
		query="Update Ledger set Active=?, Ledger_name=? ,Opening_Balance=?,Opening_LocalBalance=?,Opening_DollarBalance=?,Exchange_Rate=?,For_Head=?,For_HeadId=?,Ledger_Type=?,ParentCompanyParty_Id=?,MainLedger=? where Ledger_id=? " ;
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setBoolean(1,other_flag);
		pstmt_p.setString (2, companyparty_name);
		pstmt_p.setDouble(3,other_localbalance);
		pstmt_p.setDouble(4,other_localbalance);
		pstmt_p.setDouble(5,other_dollarbalance);
		pstmt_p.setString(6,""+exchange_rate);
		pstmt_p.setString(7,""+category);
		pstmt_p.setString(8,""+category);
		pstmt_p.setString(9,""+SubGroup);
		pstmt_p.setString(10,companyparty_id);
		
		if("others".equals(main_ledger))
			pstmt_p.setBoolean(11,true);
		else
			pstmt_p.setBoolean(11,false);	
		pstmt_p.setString(12,ledger_ledger_id);

		a589 = pstmt_p.executeUpdate();
		//System.out.println("Updated Successfully:" +a489);
		//out.println("<br>767Updated Successfully:a489" +a589);
		pstmt_p.close();
}
else
{
	errLine="919";
	int ledger_id3=Integer.parseInt(""+L.get_master_id(conp,"Ledger"));

	query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id,MainLedger) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?, ?,?,?,?)";
	//out.print("<BR>90" +query);
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.clearParameters();
	pstmt_p.setString (1,""+ledger_id3);	
	//out.print("<br >1 "+ledger_id);
	pstmt_p.setString (2,company_id);
	//out.print("<br >2 "+company_id);
	pstmt_p.setString (3,category);
	//out.print("<br >3 ");
	pstmt_p.setString (4,category);
	//out.print("<br >4 ");
	pstmt_p.setString (5,companyparty_name);
	pstmt_p.setString (6,SubGroup);
	//out.print("<br >4 "+"1");
	pstmt_p.setString (7,"description");
	pstmt_p.setString (8,user_id);	
	pstmt_p.setString (9,machine_name);


	pstmt_p.setBoolean (10,other_flag);

	pstmt_p.setString (11,yearend_id);
	pstmt_p.setDouble (12,other_localbalance);
	pstmt_p.setDouble (13,other_localbalance);
	pstmt_p.setDouble (14,other_dollarbalance);
	pstmt_p.setString (15,""+exchange_rate);
	pstmt_p.setString (16,""+salespartygroup_id);
	pstmt_p.setString (17,""+interest);


	pstmt_p.setString (18,""+companyparty_id);

	if(main_ledger.equals("others".trim()))
		pstmt_p.setBoolean(19,true);
	else	
		pstmt_p.setBoolean(19,false);

	int aledger4 = pstmt_p.executeUpdate();
	pstmt_p.close();	
}
conp.commit();

C.returnConnection(conp);

response.sendRedirect("NewCompanyPartyAccount.jsp?command=Default&message=<font color=blue>"+companyparty_name+"</font> successfully Updated.&account_no=Party");


}//else present
}catch(Exception Samyak82){ 
out.println("<font color=red>FileName:UpdateCompany.jsp <br>Bug No Samyak82 :"+Samyak82+"errLine="+errLine+"</font>");}
}
//UPDATE Company
%>








