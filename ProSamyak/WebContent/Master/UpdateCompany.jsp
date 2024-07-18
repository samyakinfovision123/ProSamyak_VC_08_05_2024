<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<% 
String user_id= ""+session.getValue("user_id");
//out.print("user_id"+user_id);
user_id="1";
//out.print("user_id"+user_id);
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

	//System.out.println("Inside UpdateCompany.jsp");
	Connection conp = null;
	Connection conm = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_m=null;
	ResultSet rs_g = null;
	/*try{conp=C.getConnection();}
	catch(Exception Samyak11)
	{out.println("<font color=red>FileName:UpdateCompany.jsp <br>Bug No Samyak11 :"+ Samyak11 +"</font>");}*/


String command   = request.getParameter("command");
//out.println("command is "+command);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String d1=format.format(D);
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

if("ADD Company".equals(command))
{
	if("0".equals(company_id))
	{

try{
	conp=C.getConnection();
	conm=C.getConnection();
//out.println(" CREATE Company");
String companyparty_name =request.getParameter("companyparty_name");
//out.println(companyparty_name);
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
String active =request.getParameter("active");

//out.println(active);
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String sr_no=request.getParameter("sr_no");

String query = " Select * from Master_companyparty where super=1 and company=1 and companyparty_Name=?";
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1,companyparty_name);
	rs_g = pstmt_p.executeQuery();
	int company_exist =0;
	while(rs_g.next())
		{
		company_exist++;
		}//while
		pstmt_p.close();

if(company_exist>0)
	{
	//C.returnConnection(conp);

	out.print("<body bgcolor=ffffee background='../Buttons/BGCOLOR.JPG'>" );
	out.print("<center>Company "+companyparty_name+" alredy exists</center><br>" );
	out.print("<center><input type=button name=command value=Back  class='Button1' onclick='history.go(-1)'></center>" );

	}
else{
String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
String yearend_id= ""+L.get_master_id(conp,"YearEnd");


query = " INSERT INTO Master_companyparty (companyparty_Id, companyparty_Name, Category_Code,  Address1, Address2, Address3,City, Pin, Country, Super, Company, Income_TaxNo, Sales_TaxNo, Phone_Off, Phone_resi,  Mobile, Email, website, Person1, Person2, Fax, Active,Sr_No,YearEnd_Id ) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";
out.println("<br>"+query);		
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1, ""+companyparty_id);	//	out.print("<br >1 "+companyparty_id);
pstmt_p.setString (2, companyparty_name);	//out.print("<br >2 "+companyparty_name);
pstmt_p.setString (3, category_code);	//out.print("<br >3 "+category_code);
pstmt_p.setString (4, address1);			//out.print("<br >4 "+address1);
pstmt_p.setString (5, address2);			//out.print("<br >5 "+address2);
pstmt_p.setString (6, address3);			//out.print("<br >6 "+address3);
pstmt_p.setString (7, city);			//out.print("<br >7"+city);
pstmt_p.setString (8, pin);			//out.print("<br >8"+pin);
pstmt_p.setString (9, country);	//out.print("<br >9 "+country);	
pstmt_p.setBoolean (10,true); //out.print("<br > 10 Company");	
pstmt_p.setBoolean (11,true); //out.print("<br > 10 Company");	
pstmt_p.setString (12, income_taxno);	//		out.print("<br > 11 "+income_taxno);
pstmt_p.setString (13, sales_taxno);	//		out.print("<br > 12 "+sales_taxno);
pstmt_p.setString (14, phone_off);		//	out.print("<br > 13 "+phone_off);
pstmt_p.setString (15, phone_resi);			//out.print("<br >14 resi "+phone_resi);	
pstmt_p.setString (16, mobile);	//out.print("<br> 13"+mobile);	
pstmt_p.setString (17, email);	//out.print("<br> 14"+email);	
pstmt_p.setString (18, website); //out.print("<br> 17"+website);	
out.print("<br > ok mmm"+website);	
pstmt_p.setString (19, person1);	//	out.print("<br> 18"+person1);	
pstmt_p.setString (20, person2);	//	out.print("<br> 19"+person2);
pstmt_p.setString (21, fax_no);		//out.print("<br> 20"+fax_no);	
pstmt_p.setBoolean (22, flag);		//out.print("<br> 21"+active);	
pstmt_p.setString (23, sr_no);    //  out.print("<br> 22"+sr_no); 
pstmt_p.setString (24, yearend_id);  

int a = pstmt_p.executeUpdate();
//System.out.println(" Added Successfully: " +a);
//out.println(" Added Successfully: " +a);
pstmt_p.close();


/* 
	YearEnd Insertion Start...

*/
String from_date= request.getParameter("from_date");
String to_date= request.getParameter("to_date");


//out.print("from_date"+from_date);
 query="Insert into YearEnd (YearEnd_Id, Company_Id, From_Date, To_Date, Freeze, Modified_By, Modified_On,Modified_MachineName) values (?,?,'"+format.getDate(from_date)+"','"+format.getDate(to_date)+"',? ,?,'"+format.getDate(today_string)+"',?)";
String temp_freeze="0";

pstmt_p = conp.prepareStatement(query);

//out.print("<BR>80" +query);
pstmt_p.setString (1,yearend_id);	
//out.print("<br >yearend_id"+yearend_id);
pstmt_p.setString (2,companyparty_id);
//out.print("<br > companyparty_id"+companyparty_id);
pstmt_p.setString (3,temp_freeze);			
//out.print("<br >to_date "+to_date);
pstmt_p.setString (4,user_id);
//out.print("<br >user_id "+1);
pstmt_p.setString (5, machine_name);			
//out.print("<br >machine_name"+machine_name);
int a152 = pstmt_p.executeUpdate();
//out.println(" Updated Successfully: " +a152);
pstmt_p.close();

/* 
	YearEnd Insertion End...

*/

/* 
	Master_Currency Insertion Start...

*/


String currency_name= request.getParameter("currency_name");
String currency_symbol= request.getParameter("currency_symbol");
String base_exchangerate= request.getParameter("base_exchangerate");
String decimal_places= request.getParameter("decimal_places");
boolean local_currency=true;
String currency_id= ""+L.get_master_id(conp,"Master_Currency");

//out.print("<BR>currency_id="+currency_id);
 
 query="Insert into Master_Currency (Currency_Id, Currency_Name, Currency_Symbol, Base_ExchangeRate, Local_Currency, Company_id, Decimal_Places,Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values (?,?,?,? ,?,?,?,?,'"+format.getDate(today_string)+"',?,?)";
//columns (fields) 10

//out.print("<BR>185 " +query);
//out.print("<br >5ppp "+local_currency);

pstmt_m = conm.prepareStatement(query);
//out.print("<BR>80" +query);
pstmt_m.setString (1,""+ currency_id);	
//out.print("<br >1 "+currency_id);
pstmt_m.setString (2, ""+currency_name);
//out.print("<br >2 "+currency_name);
pstmt_m.setString (3,""+ currency_symbol);			//out.print("<br >3 "+currency_symbol);
//out.print("<br >4 "+base_exchangerate);
pstmt_m.setString (4,""+ base_exchangerate);	
pstmt_m.setBoolean (5, local_currency);			//out.print("<br >5 "+local_currency);
pstmt_m.setString (6,""+ companyparty_id);			//out.print("<br >6 "+user_id);
//out.print("<br>203 companyparty_id= "+companyparty_id);
pstmt_m.setString (7, ""+decimal_places);			//out.print("<br >6 "+user_id);
pstmt_m.setString (8, ""+user_id);			//out.print("<br >6 "+user_id);
//pstmt_p.setDate (9, D);//			out.print("<br >7"+D);
pstmt_m.setString (9,""+ machine_name);			//out.print("<br >8"+machine_name);
pstmt_m.setString (10,""+yearend_id);			
//out.print("<br>209 yearend_id="+yearend_id);
int a130 = pstmt_m.executeUpdate();
//out.print(" <BR>205 Updated Successfully: " +a130);
//out.println(" <br>206 <font color=#666600>Updated Successfully:</font> " +a);
pstmt_m.close();

/* 
	Master_Currency Insertion End...

*/

out.print("<br>214 ");
String account_id= ""+L.get_master_id(conp,"Master_Account");
 query = " INSERT INTO Master_Account ( Account_Id,Company_Id,Account_Name,Account_Number,Bank_Id, AccountType_Id ,Description, Opening_LocalBalance, Opening_DollarBalance, Opening_ExchangeRate, Opening_Date, Net_LocalBalance, Net_DollarBalance, Exchange_Rate, Modified_By, Modified_On, Modified_MachineName, Transaction_Currency,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,'"+format.getDate(today_string)+"',?, ?,?,?,'"+format.getDate(today_string)+"', ?,?,?)";

//total columns = 17
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+ account_id);		
//out.print("<br>1 "+account_id);
pstmt_p.setString (2, companyparty_id);		//out.print("<br>2 "+companyparty_id);
pstmt_p.setString (3,"PN Account");
//out.print("<br>3 ");
pstmt_p.setString (4, "PN Account");	
//out.print("<br>3 ");
pstmt_p.setString (5, "bank_id");	
//out.print("<br>4");
pstmt_p.setString (6,"5");
pstmt_p.setString (7, "description");
pstmt_p.setString (8, "0");
pstmt_p.setString (9,"0");	
pstmt_p.setString (10,"1");
pstmt_p.setString (11,"0");
pstmt_p.setString (12,"0");
pstmt_p.setString (13,"1");
pstmt_p.setString (14, user_id);		
pstmt_p.setString (15, machine_name);
pstmt_p.setBoolean(16, true);
pstmt_p.setString (17,yearend_id);		
//out.print("<br> 8"+machine_name);	
//out.println("Before Query <br>"+query);
int a182 = pstmt_p.executeUpdate();
out.print("<br>244 a182=> "+a182);




String sundrytype_id= ""+L.get_master_id(conp,"Master_SubGroup");

query = " INSERT INTO Master_SubGroup( SubGroup_Id, Company_Id , For_HeadId, SubGroup_Name, SubGroup_Code, Sr_No,Active,YearEnd_Id) values(?,?,?,?, ?,?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, sundrytype_id);	//	out.print("<br >1 "+sundrytype_id);
pstmt_p.setString (2,companyparty_id);
pstmt_p.setString (3,"17");
//out.print("<br >2aa ");
pstmt_p.setString (4,"Taxes & Duties" );
pstmt_p.setString (5, "Taxes & Duties");			pstmt_p.setString (6,sundrytype_id);		//	out.print("<br >5 "+sundrytype_id);
pstmt_p.setBoolean (7, true);	
pstmt_p.setString (8,yearend_id);		//	
//out.println("Before Query <br>"+query);
int a201 = pstmt_p.executeUpdate();

String ledger_id= ""+L.get_master_id(conp,"Ledger");
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Opening_Balance, Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,YearEnd_Id) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?,?,? )";
out.print("<BR><font color=#CC0033>267 Query</font>" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,companyparty_id);
//out.print("<br >2 "+companyparty_id);
pstmt_p.setString (3,"17");
//out.print("<br >3 ");
pstmt_p.setString (4,ledger_id);
//out.print("<br >4 ");
pstmt_p.setString (5,"C. Tax");
pstmt_p.setString (6,sundrytype_id);
//out.print("<br >4 "+sundrytype_id);
pstmt_p.setString (7,"sundrytype_code");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
//out.print("<br >9 "+machine_name);
pstmt_p.setString (10,"0");
pstmt_p.setString (11,"0");
pstmt_p.setString (12,"0");
pstmt_p.setString (13,"1");
pstmt_p.setString (14,yearend_id);
int aledger = pstmt_p.executeUpdate();
out.print("<BR><font color=#CC0033>291 aledger</font>" +aledger);
pstmt_p.close();

sundrytype_id= ""+L.get_master_id(conp,"Master_SubGroup");
query = " INSERT INTO Master_SubGroup( SubGroup_Id, Company_Id , For_HeadId, SubGroup_Name, SubGroup_Code, Sr_No,Active,YearEnd_Id) values(?,?,?,?, ?,?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, sundrytype_id);		out.print("<br >1 "+sundrytype_id);
pstmt_p.setString (2,companyparty_id);
pstmt_p.setString (3,"13");
pstmt_p.setString (4,"Discount");
//out.print("<br >3 "+sundrytype_name);
pstmt_p.setString (5,"Discount");		
//out.print("<br >4 "+"Discount");
pstmt_p.setString (6,sundrytype_id);			out.print("<br >5 "+sundrytype_id);
pstmt_p.setBoolean (7, true);		
out.print("<br> 6"+active);	
//out.println("Before Query <br>"+query);
pstmt_p.setString (8,yearend_id);			
int a244 = pstmt_p.executeUpdate();
//System.out.println("After query result a is "+a);

String indexpledger_id= ""+L.get_master_id(conp,"Ledger");
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Opening_Balance, Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,YearEnd_Id) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?, ?,? )";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,indexpledger_id);	
//out.print("<br >1 "+indexpledger_id);
pstmt_p.setString (2,companyparty_id);
//out.print("<br >2 "+companyparty_id);
pstmt_p.setString (3,"13");
//out.print("<br >3 ");
pstmt_p.setString (4,sundrytype_id);
//out.print("<br >4 ");
pstmt_p.setString (5,"Discount");
pstmt_p.setString (6,sundrytype_id);
//out.print("<br >4 "+sundrytype_id);
pstmt_p.setString (7,"Discount");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
pstmt_p.setString (10,"0");
pstmt_p.setString (11,"0");
pstmt_p.setString (12,"0");
pstmt_p.setString (13,"0");

//out.print("<br >9 "+machine_name);
pstmt_p.setString (14,yearend_id);
int indexpledger = pstmt_p.executeUpdate();
pstmt_p.close();




//Start 1 Adding of Profit Loss A/C ledger under Reserve - Surplus Ledger Type
sundrytype_id= ""+L.get_master_id(conp,"Master_SubGroup");

query = " INSERT INTO Master_SubGroup( SubGroup_Id, Company_Id , For_HeadId, SubGroup_Name, SubGroup_Code, Sr_No,Active,YearEnd_Id) values(?,?,?,?, ?,?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, sundrytype_id);	
//	out.print("<br >1 "+sundrytype_id);
pstmt_p.setString (2,companyparty_id);
pstmt_p.setString (3,"18");
//out.print("<br >2aa ");
pstmt_p.setString (4,"Profit Loss A/C" );
pstmt_p.setString (5, "Profit Loss A/C");			pstmt_p.setString (6,sundrytype_id);		
//	out.print("<br >5 "+sundrytype_id);
pstmt_p.setBoolean (7, true);	
pstmt_p.setString (8,yearend_id);		
//out.println("Before Query <br>"+query);
int a203 = pstmt_p.executeUpdate();

out.print("<br>364 a203"+a203);
ledger_id= ""+L.get_master_id(conp,"Ledger");
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Opening_Balance, Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,YearEnd_Id) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,?,?,?,?,? )";
out.print("<BR><font color=#3399FF>367 Query</font>" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,companyparty_id);
//out.print("<br >2 "+companyparty_id);
pstmt_p.setString (3,"18");
//out.print("<br >3 ");
pstmt_p.setString (4,ledger_id);
//out.print("<br >4 ");
pstmt_p.setString (5,"Profit Loss A/C");
pstmt_p.setString (6,sundrytype_id);
//out.print("<br >4 "+sundrytype_id);
pstmt_p.setString (7,"Used to store the profit/loss");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
//out.print("<br >9 "+machine_name);
pstmt_p.setString (10,"0");
pstmt_p.setString (11,"0");
pstmt_p.setString (12,"0");
pstmt_p.setString (13,"1");
pstmt_p.setString (14,yearend_id);
out.print("<br>397 Adding Profit Loss A/C Ledger");
aledger = pstmt_p.executeUpdate();
pstmt_p.close();
out.print("<br>400 Profit Loss A/C Ledger Added");
//End 1 Adding of Profit Loss A/C ledger under Reserve - Surplus Ledger Type






String salesperson_id= ""+L.get_master_id(conp,"Master_SalesPerson");

 query = "INSERT INTO Master_SalesPerson( SalesPerson_Id, Company_Id, SalesPerson_Name, Address1,Address2, Address3, City,Pin,Country,Mobile,Phone_O,Phone_R,Fax,Email,Modified_On, Modified_By, Modified_MachineName,Sr_No,YearEnd_Id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,'"+format.getDate(today_string)+"',?,?,?,?)";

//total columns = 17
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+salesperson_id);		
pstmt_p.setString (2,""+companyparty_id);
pstmt_p.setString (3,"Self");
pstmt_p.setString (4, address1);
pstmt_p.setString (5, address2);
pstmt_p.setString (6, address3);
pstmt_p.setString (7, city);
pstmt_p.setString (8, pin);
pstmt_p.setString (9, country);
pstmt_p.setString (10,""+mobile);
pstmt_p.setString (11,""+phone_off);
pstmt_p.setString (12,""+phone_resi);
pstmt_p.setString (13,""+fax_no);
pstmt_p.setString (14,""+email);
pstmt_p.setString (15, user_id);
pstmt_p.setString (16, machine_name);
pstmt_p.setString (17,""+salesperson_id);		
pstmt_p.setString (18,yearend_id);
int a254 = pstmt_p.executeUpdate();
out.print("<br>425 ");

pstmt_p.close();




//Start : Adding a default PartyGroup named 'Normal' for the Super Company
String partygrouptype_id= ""+L.get_master_id(conp,"Master_PartyGroup");

 query = " INSERT INTO Master_PartyGroup( PartyGroup_Id, Company_Id , Group_Type, PartyGroup_Name, PartyGroup_Code, Sr_No,Active,YearEnd_Id,Modified_By,Modified_On,Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";
out.print("<br>436 query=>"+query);
//total columns =11
//pstmt_p = conp.prepareStatement(query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, partygrouptype_id);		
out.print("<br>441 partygrouptype_id= "+partygrouptype_id);
pstmt_p.setString (2, companyparty_id);
out.print("<br>443 companyparty_id= "+companyparty_id);
pstmt_p.setString (3, "0");
out.print("<br>445 companyparty_id= ");
pstmt_p.setString (4, "Normal Sales");
pstmt_p.setString (5, "Normal Sales");			
pstmt_p.setString (6, partygrouptype_id);			
out.print("<br>449 partygrouptype_id= "+partygrouptype_id);
pstmt_p.setBoolean (7, true);

out.print("<br>451 partygroup= ");
pstmt_p.setString (8,yearend_id);	
out.print("<br>454 yearend_id=>>> "+yearend_id);
pstmt_p.setString (9,user_id);
out.print("<br>456 user_id=>>> "+user_id);

pstmt_p.setString(10,""+format.getDate(today_string));	

pstmt_p.setString (11,machine_name);
int a447 = pstmt_p.executeUpdate();
out.print("<br>452 a447=>"+a447);
pstmt_p.close();

partygrouptype_id= ""+L.get_master_id(conp,"Master_PartyGroup");

 query = " INSERT INTO Master_PartyGroup( PartyGroup_Id, Company_Id , Group_Type, PartyGroup_Name, PartyGroup_Code, Sr_No,Active,YearEnd_Id,Modified_By,Modified_On,Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";

//total columns =11
pstmt_p = conp.prepareStatement(query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, partygrouptype_id);		
pstmt_p.setString (2, companyparty_id);
pstmt_p.setString (3, "1");
pstmt_p.setString (4, "Normal Purchase");
pstmt_p.setString (5, "Normal Purchase");			
pstmt_p.setString (6, partygrouptype_id);			
pstmt_p.setBoolean (7, true);		
pstmt_p.setString (8,yearend_id);	
pstmt_p.setString (9,user_id);	
pstmt_p.setString(10,""+format.getDate(today_string));	
pstmt_p.setString (11,machine_name);
a447 = pstmt_p.executeUpdate();

pstmt_p.close();


//Start : Adding a default PurchaseSale Group named 'Normal' for the Super Company
String purchasesalegrouptype_id= ""+L.get_master_id(conp,"Master_PurchaseSaleGroup");

query = " INSERT INTO Master_PurchaseSaleGroup( PurchaseSaleGroup_Id, Company_Id , PurchaseSaleGroup_Type, PurchaseSaleGroup_Name, PurchaseSaleGroup_Code, Sr_No, Active, YearEnd_Id, Modified_By, Modified_On, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, purchasesalegrouptype_id);		
pstmt_p.setString (2,companyparty_id);
pstmt_p.setString (3,"0");
pstmt_p.setString (4, "Normal");
pstmt_p.setString (5, "Normal");		
pstmt_p.setString (6,purchasesalegrouptype_id);			
pstmt_p.setBoolean (7, true);		
pstmt_p.setString (8,yearend_id);	
pstmt_p.setString (9,user_id);	
pstmt_p.setString(10,""+format.getDate(today_string));
pstmt_p.setString (11,machine_name);	

	
int a491 = pstmt_p.executeUpdate();
out.print("<br>497 a491=>"+a491);
pstmt_p.close();


purchasesalegrouptype_id= ""+L.get_master_id(conp,"Master_PurchaseSaleGroup");

query = " INSERT INTO Master_PurchaseSaleGroup( PurchaseSaleGroup_Id, Company_Id , PurchaseSaleGroup_Type, PurchaseSaleGroup_Name, PurchaseSaleGroup_Code, Sr_No, Active, YearEnd_Id, Modified_By, Modified_On, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, purchasesalegrouptype_id);		
pstmt_p.setString (2,companyparty_id);
pstmt_p.setString (3,"1");
pstmt_p.setString (4, "Normal");
pstmt_p.setString (5, "Normal");		
pstmt_p.setString (6,purchasesalegrouptype_id);			
pstmt_p.setBoolean (7, true);		
pstmt_p.setString (8,yearend_id);	
pstmt_p.setString (9,user_id);	
pstmt_p.setString(10,""+format.getDate(today_string));	
pstmt_p.setString (11,machine_name);	

	
int a513 = pstmt_p.executeUpdate();
out.print("<br>520 a513=>"+a513);
pstmt_p.close();




String Nippon="Diamond";
int lotcategory_id= L.get_master_id(conp,"Master_LotCategory");
int lotsubcategory_id= L.get_master_id(conp,"Master_LotSubCategory");
int unit_id= L.get_master_id(conp,"Master_Unit");
String unit="Carats";

for(int co=1;co<=2;co++)
{
query="insert into Master_LotCategory (LotCategory_Id,Company_id,LotCategory_Code,LotCategory_Name, LotCategory_Description,Modified_By,Modified_On,Modified_MachineName, Sr_No,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?)";

//out.print(query);

pstmt_p=conp.prepareStatement(query);


pstmt_p.clearParameters();


pstmt_p.setString(1,""+ lotcategory_id);
//out.print("<br> lotcategory_id "+lotcategory_id);

pstmt_p.setString (2,""+companyparty_id);
//out.print("<br>companyparty_id "+companyparty_id);

pstmt_p.setString (3,Nippon);
//out.print("<br>Nippon "+Nippon);

pstmt_p.setString (4, Nippon);

pstmt_p.setString (5, Nippon);

pstmt_p.setString (6,""+user_id);
//out.print("<br>user_id "+user_id);

pstmt_p.setString (7, ""+format.getDate(d1));
//out.print("<br>d1 "+d1);

pstmt_p.setString (8, machine_name);
//out.print("<br>machine_name "+machine_name);

pstmt_p.setString (9, ""+co);
//out.print("<br>co "+co);
pstmt_p.setString (10,yearend_id);

try{
int z=pstmt_p.executeUpdate();
}catch(Exception e){out.print("<font color=blue> FileName : UpdateCompany.jsp <br>Bug No Samyak333 :"+ e + "</font>");}
pstmt_p.close();

query="insert into Master_LotSubCategory (LotSubCategory_Id,Company_id,LotCategory_Id,LotSubCategory_Code, LotSubCategory_Name, LotSubCategory_Description,Modified_By,Modified_On,Modified_MachineName, Sr_No,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,?)";

//out.print(query);

pstmt_p=conp.prepareStatement(query);


pstmt_p.clearParameters();

pstmt_p.setString (1,""+lotsubcategory_id);
//out.print("<br> lotsubcategory_id "+lotsubcategory_id);

pstmt_p.setString (2,""+companyparty_id);
//out.print("<br>companyparty_id "+companyparty_id);

pstmt_p.setString (3,""+lotcategory_id);
//out.print("<br> lotcategory_id "+lotcategory_id);

pstmt_p.setString (4, Nippon);

pstmt_p.setString (5, Nippon);

pstmt_p.setString (6, Nippon);

pstmt_p.setString (7,""+user_id);
//out.print("<br>user_id "+user_id);

pstmt_p.setString (8, ""+format.getDate(d1));
//out.print("<br>d1 "+d1);

pstmt_p.setString (9, machine_name);
//out.print("<br>machine_name "+machine_name);

pstmt_p.setString (10, ""+co);
//out.print("<br>co "+co);
pstmt_p.setString (11,yearend_id);
try{
int y=pstmt_p.executeUpdate();
}catch(Exception e){out.print("<font color=green> FileName : UpdateCompany.jsp <br>Bug No Samyak393 :"+ e + "</font>");}

Nippon="Jewelry";
lotcategory_id++;
//out.print("<br>lotsubcategory_id "+lotsubcategory_id);
lotsubcategory_id++;
//out.print("<br>Nippon "+Nippon);

pstmt_p.close();


query="insert into Master_Unit (Unit_Id,Company_id,Unit_Name,Unit_Code, Unit_Description, Modified_By,Modified_On,Modified_MachineName, Sr_No,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?)";

//out.print(query);

pstmt_p=conp.prepareStatement(query);


pstmt_p.clearParameters();

pstmt_p.setString (1,""+unit_id);
//out.print("<br> unit_id "+unit_id);

pstmt_p.setString (2,""+companyparty_id);
//out.print("<br>companyparty_id "+companyparty_id);

pstmt_p.setString (3,""+unit);
//out.print("<br> unit "+unit);

pstmt_p.setString (4, unit);

pstmt_p.setString (5, unit);


pstmt_p.setString (6,""+user_id);
//out.print("<br>user_id "+user_id);

pstmt_p.setString (7, ""+format.getDate(d1));
//out.print("<br>d1 "+d1);

pstmt_p.setString (8, machine_name);
//out.print("<br>machine_name "+machine_name);

pstmt_p.setString (9, ""+co);
//out.print("<br>co "+co);
pstmt_p.setString (10,yearend_id);
try{
int x=pstmt_p.executeUpdate();
}catch(Exception e){out.print("<font color=yellow> FileName : UpdateCompany.jsp <br>Bug No Samyak393 :"+ e + "</font>");}

unit="Pieces";
unit_id++;
pstmt_p.close();
}
//---------------------------Category / Subcategory / Unit Comlete------------------------

String location_id=""+L.get_master_id(conp,"Master_Location");
//out.print("<br> 888888888888888888888 *********");
//out.print("<br> location_id"+location_id);

query="insert into Master_Location (Location_Id,Company_id,Location_Code,Location_Name, Location_Description, Modified_By,Modified_On,Modified_MachineName, Sr_No,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?)";

//out.print(query);
pstmt_p=conp.prepareStatement(query);
pstmt_p.setString (1,location_id);
//out.print("<br> location_id "+location_id);
pstmt_p.setString (2,""+companyparty_id);
//out.print("<br>companyparty_id "+companyparty_id);
pstmt_p.setString (3,"Main");
pstmt_p.setString (4, "Main");
pstmt_p.setString (5, "Main");
pstmt_p.setString (6,""+user_id);
//out.print("<br>user_id "+user_id);
pstmt_p.setString (7, ""+format.getDate(d1));
//out.print("<br>d1 "+d1);
pstmt_p.setString (8, machine_name);
//out.print("<br>machine_name "+machine_name);
pstmt_p.setString (9, location_id);
pstmt_p.setString (10,yearend_id);
try{
int x=pstmt_p.executeUpdate();
//out.print("<br> x is "+x);
}catch(Exception e){out.print("<font color=yellow> FileName : UpdateCompany.jsp <br>Bug No Samyak393 :"+ e + "</font>");}
pstmt_p.close();

//-----------------------------------------------------------------------------------------


//---------------------------       Cost Head Name   ---------------------


String costheadgroup_no= ""+L.get_master_id(conp,"Master_costheadgroup");

//out.print("<br> 888888888888888888888 *********");
//out.print("<br> 484 costheadgroup_no"+costheadgroup_no);



 

 query = " INSERT INTO Master_costheadgroup ( costheadgroup_Id,company_Id, costheadgroup_Code ,costheadgroup_Name, costheadgroup_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,'"+format.getDate(today_string)+"',?,?,?)";


pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+costheadgroup_no);		
//out.print("<br >1 "+costheadgroup_no);
pstmt_p.setString (2,companyparty_id);	
pstmt_p.setString (3,"Main");	
//out.print("<br >2aa "+costheadgroup_code);
pstmt_p.setString (4, "Main");
//out.print("<br >3 "+costheadgroup_name);
pstmt_p.setString (5, "Main");			
//out.print("<br >4 "+costheadgroup_description);
pstmt_p.setString (6,""+costheadgroup_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (7,true);	
//out.print("<br> 6"+active);	
pstmt_p.setString (8, user_id);		
pstmt_p.setString (9, machine_name);	
//out.print("<br>+++++++++++++ 503");

pstmt_p.setString (10,yearend_id);	
try{
//out.print("<br> Before a505");
int a505 = pstmt_p.executeUpdate();
//out.print("<br> After a505"+a505);
}catch(Exception e){out.print("<font color=yellow> FileName : UpdateCompany.jsp <br>Bug No a505 :"+ e + "</font>");}
//out.print("<br>+++++++++++++ 508");
pstmt_p.close();

//-----------------------------------------------------------------------------------------



String costheadsubgroup_id= ""+L.get_master_id(conp,"Master_costheadsubgroup");

 query = " INSERT INTO Master_costheadsubgroup( costheadsubgroup_Id,company_Id,costheadgroup_id, costheadsubgroup_Code ,costheadsubgroup_Name, costheadsubgroup_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+costheadsubgroup_id);		
//out.print("<br >1 "+subcategory_id);
pstmt_p.setString (2,""+companyparty_id);	
pstmt_p.setString (3,""+costheadgroup_no);	
pstmt_p.setString (4,"General");	
//out.print("<br >2aa "+costheadsubgroup_code);
pstmt_p.setString (5,"General");
//out.print("<br >3 "+costheadsubgroup_name);
pstmt_p.setString (6,"General");			
//out.print("<br >4 "+costheadsubgroup_description);
pstmt_p.setString (7,""+costheadsubgroup_id);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (8,true);	
//out.print("<br> 8"+flag);	
pstmt_p.setString (9, user_id);		
pstmt_p.setString (10, machine_name);
pstmt_p.setString (11,yearend_id);
//out.println("Before Query <br>"+query);
try{
int a531 = pstmt_p.executeUpdate();
//out.print("a531 "+a531);
}catch(Exception e){out.print("<font color=yellow> FileName : UpdateCompany.jsp <br>Bug No a531 :"+ e + "</font>");}
pstmt_p.close();

// -------------------------- Start New Cash Account  Creation

String cashaccount_id= ""+L.get_master_id(conp,"Master_Account");
String op_date="01/04/2004";
//out.println("account_id"+account_id);
query = " INSERT INTO Master_Account ( Account_Id,Company_Id,Account_Name,Account_Number,Bank_Id, AccountType_Id ,Description, Opening_LocalBalance, Opening_DollarBalance, Opening_ExchangeRate,Opening_Date, Net_LocalBalance, Net_DollarBalance, Exchange_Rate, Modified_By, Modified_On, Modified_MachineName, Transaction_Currency,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,'"+format.getDate(op_date)+"',?, ?,?,?,'"+format.getDate(today_string)+"', ?,?,?)";

//total columns = 17
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+cashaccount_id);		
//out.print("<br>1 "+account_id);
pstmt_p.setString (2, companyparty_id);	
//out.print("<br>2 "+company_id);
pstmt_p.setString (3,"Cash");
//out.print("<br>3 "+account_name);
pstmt_p.setString (4, "Cash");	
//out.print("<br>4 "+account_no);
pstmt_p.setString (5, "Self");
//out.print("<br>5 "+bank_id);
pstmt_p.setString (6,"6");
//out.print("<br>6 "+accounttype_id);
pstmt_p.setString (7, "description");
//out.print("<br> 7"+description);	
pstmt_p.setString (8,""+0);		
//out.print("<br> 7"+opening_localbalance);	
pstmt_p.setString (9,""+0);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (10,""+0);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (11,""+0);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (12,""+0);	
//out.print("<br> 7"+user_id);	
pstmt_p.setString (13,""+0);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (14, user_id);	
//out.print("<br> 7"+user_id);	
pstmt_p.setString (15,machine_name);
pstmt_p.setBoolean(16,true);
pstmt_p.setString (17,yearend_id);
//out.print("<br> 8"+machine_name);	
//out.println("Before Query <br>"+query);
int a594 = pstmt_p.executeUpdate();

// -------------------------- End New Cash Account  Creation






C.returnConnection(conp);
C.returnConnection(conm);


//------------------

response.sendRedirect("NewCompany.jsp?message=Company <font color=blue> "+companyparty_name+" </font>successfully Added.");

}//else company_exist

}catch(Exception Samyak82){ 
	out.println("<font color=red> FileName : UpdateCompany.jsp <br>Bug No Samyak82 :"+ Samyak82 +"</font>");}



	}//if("0".equals(company_id))



else{
//out.println("<font color=blue> FileName : UpdateCompany.jsp <br>Bug No Samyak82 </font>");
String company =request.getParameter("company");
//out.println(company);
String category_code =request.getParameter("category_code");

String opening_date=request.getParameter("datevalue");
String currency=request.getParameter("currency");
boolean currency_flag=true; //true=local=1;
if("local".equals(currency)){currency_flag=true;}
if("dollar".equals(currency)){currency_flag=false;}
String sale =request.getParameter("sale");
String purchase =request.getParameter("purchase");
String pn =request.getParameter("pn");
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.println("<br>102 exchange_rate is"+exchange_rate);
double opening_salesbalance =0+Double.parseDouble(request.getParameter("opening_salesbalance"));
double opening_purchasebalance = Double.parseDouble(request.getParameter("opening_purchasebalance"));
double opening_pnbalance = Double.parseDouble(request.getParameter("opening_pnbalance"));

boolean sale_flag =false; 
boolean purchase_flag =false; 
boolean pn_flag =false; 
if("yes".equals(sale)){sale_flag=true;}
else{opening_salesbalance=0;}
if("yes".equals(purchase)){purchase_flag=true;}
else{opening_purchasebalance=0;}
if("yes".equals(pn)){pn_flag=true;}
else{opening_pnbalance=0;}

//System.out.println(sale_flag);
//System.out.println(purchase_flag);
//System.out.println(pn_flag);




String sale_creditdebit= request.getParameter("sale_creditdebit");
String purchase_creditdebit= request.getParameter("purchase_creditdebit");
String pn_creditdebit= request.getParameter("pn_creditdebit");
//out.println("Credit_Debit"+credit_debit);
if("Debit".equals(sale_creditdebit))
{opening_salesbalance=0-opening_salesbalance;}
if("Debit".equals(purchase_creditdebit))
{opening_purchasebalance=0-opening_purchasebalance;}
if("Debit".equals(pn_creditdebit))
{opening_pnbalance=0-opening_pnbalance;}



double sale_localbalance=0;
double sale_dollarbalance=0;
double purchase_localbalance=0;
double purchase_dollarbalance=0;
double pn_localbalance=0;
double pn_dollarbalance=0;

String currency_id="";
if ("dollar".equals(currency))
	{
	//local_currencysymbol="$";
	//currency_id="0";
purchase_dollarbalance=opening_purchasebalance;
sale_dollarbalance=opening_salesbalance;
pn_dollarbalance=opening_pnbalance;
purchase_localbalance= opening_purchasebalance*exchange_rate;
sale_localbalance=opening_salesbalance*exchange_rate;
pn_localbalance=opening_pnbalance*exchange_rate;
}//if
else{
	//currency_id=local_currencyid;
purchase_localbalance=opening_purchasebalance;
pn_localbalance=opening_pnbalance;
sale_localbalance=opening_salesbalance;
purchase_dollarbalance= opening_purchasebalance/exchange_rate;
pn_dollarbalance=opening_pnbalance/exchange_rate;
sale_dollarbalance=opening_salesbalance/exchange_rate;
}//else if dollar
	try{conp=C.getConnection();}
	catch(Exception Samyak11)
	{out.println("<font color=red>FileName:UpdateCompany.jsp <br>Bug No Samyak11 :"+ Samyak11 +"</font>");}
	String query = "select * from Master_CompanyParty where CompanyParty_Id=?";
	pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1, company);
	rs_g = pstmt_p.executeQuery();
String companyparty_name ="";
String address1="";
String address2="";
String address3="";
String city="";
String pin="";
String country="";
String income_taxno="";
String sales_taxno="";
String phone_off="";
String phone_resi="";
String mobile="";
String email="";
String website="";
String person1="";
String person2="";
String fax_no="";
	while(rs_g.next())
		{
companyparty_name= rs_g.getString("CompanyParty_Name");
if (rs_g.wasNull()){companyparty_name="";}
//out.println("<br>1:"+companyparty_name);
//out.println("<br>2:"+category_code);
 address1=rs_g.getString("address1");
if (rs_g.wasNull()){address1="";}
//out.println("<br>3:"+address1);
 address2    =rs_g.getString("address2");
if (rs_g.wasNull()){address2="";}
//out.println("<br>4:"+address2);
 address3=rs_g.getString("address3");
if (rs_g.wasNull())	{address3="";}
//out.println("<br>5:"+address2);
 city=rs_g.getString("city");	
if (rs_g.wasNull()){city="";}
//out.println("<br>6:"+city);
 pin=rs_g.getString("pin");
if (rs_g.wasNull())	{pin="";}
//out.println("<br>7:"+pin);
 country=rs_g.getString("country");
if (rs_g.wasNull()){country="";}
out.println("<br>8:"+country);
income_taxno =rs_g.getString("income_taxno");
if (rs_g.wasNull()){income_taxno="";}
//out.println("<br>9:"+income_taxno);
sales_taxno=rs_g.getString("sales_taxno");
if (rs_g.wasNull()){sales_taxno="";}
//out.println("<br>9:"+phone_off);
 phone_off=rs_g.getString("phone_off");
if (rs_g.wasNull()){phone_off="";}
//out.println("<br>9:"+phone_off);
phone_resi=rs_g.getString("phone_resi");
if (rs_g.wasNull()){phone_resi="";}
//out.println("<br>10:"+phone_resi);
 mobile	=rs_g.getString("mobile");
//out.println("<br>11 ccc:"+mobile);
if (rs_g.wasNull()){mobile="";}
//out.println("<br>11 ccc:"+mobile);
out.println("<br>11:"+mobile);
 email=rs_g.getString("email");	
if (rs_g.wasNull()){email="";}
//out.println("<br>12:"+email);
 website=rs_g.getString("website");
if (rs_g.wasNull()){website="";}
//out.println("<br>13:"+website);
 person1=rs_g.getString("person1");
if (rs_g.wasNull()){person1="";}
out.println("<br>14:"+person1);
person2	=rs_g.getString("person2");
if (rs_g.wasNull()){person2="";}
out.println("<br>15:"+person2);
 fax_no	=rs_g.getString("fax");	
out.println("<br>16:"+fax_no);
if (rs_g.wasNull())	{fax_no="";}
		}//while
pstmt_p.close();
try{
//out.println("<br>1:"+companyparty_name);
//System.out.println(" Added Successfully: ");
String yearend_id=A.getNameCondition(conp,"YearEnd","YearEnd_Id", "Where  company_id="+company_id+" and active=1");
out.print("<br> 75 yearend_id"+yearend_id);

String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
 query = " INSERT INTO Master_companyparty (companyparty_Id,GroupCompany_Id, companyparty_Name, Category_Code,  Address1, Address2, Address3,City, Pin, Country, Company,Company_Id, Income_TaxNo, Sales_TaxNo, Phone_Off, Phone_resi, Mobile, Email, website, Person1, Person2, Fax, Active,Sr_No, Transaction_Currency ,Opening_Date, Opening_RLocalBalance, Opening_RDollarBalance, Opening_RExchangeRate, Net_RLocalBalance, Net_RDollarBalance, RExchange_Rate, Opening_PLocalBalance, Opening_PDollarBalance, Opening_PExchangeRate, Net_PLocalBalance, Net_PDollarBalance, PExchange_Rate, Opening_PNLocalBalance,Opening_PNDollarBalance,Opening_PNExchangeRate,Sale,Purchase,PN,YearEnd_Id) values(?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,"+format.getDate(opening_date)+", ?,?,?,?, ?,?,?,?, ?,?,?,? ?,?,?,? ,?,?,?)";
//out.println("<br>"+query);		
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1, companyparty_id);
//out.print("<br >1 "+companyparty_id);
pstmt_p.setString(2, company);

pstmt_p.setString (3, companyparty_name);
//out.print("<br >2 "+companyparty_name);
pstmt_p.setString (4, category_code);
//out.print("<br >3 "+category_code);
pstmt_p.setString (5, address1);
//out.print("<br >4 "+address1);
pstmt_p.setString (6, address2);
//out.print("<br >5 "+address2);
pstmt_p.setString (7, address3);
//out.print("<br >6 "+address3);
pstmt_p.setString (8, city);
//out.print("<br >7"+city);
pstmt_p.setString (9, pin);
//out.print("<br >8"+pin);
pstmt_p.setString (10, country);
//out.print("<br >9 "+country);	
pstmt_p.setBoolean (11,true); 
//out.print("<br > 10 Company");	
pstmt_p.setString (12, company_id);			
//out.print("<br > 11 "+company_id);
pstmt_p.setString (13, income_taxno);
//out.print("<br > 11 "+income_taxno);
pstmt_p.setString (14, sales_taxno);
//out.print("<br > 12 "+sales_taxno);
pstmt_p.setString (15, phone_off);
//out.print("<br > 13 "+phone_off);
pstmt_p.setString (16, phone_resi);
//out.print("<br >14 resi "+phone_resi);	
pstmt_p.setString (17, mobile);	out.print("<br> 13"+mobile);	
pstmt_p.setString (18, email);	out.print("<br> 14"+email);	
pstmt_p.setString (19, website); out.print("<br> 17"+website);	
//out.print("<br > ok mmm"+website);	
pstmt_p.setString (20, person1);
//out.print("<br> 18"+person1);	
pstmt_p.setString (21, person2);
//out.print("<br> 19"+person2);
pstmt_p.setString (22, fax_no);
//out.print("<br> 20"+fax_no);	
pstmt_p.setBoolean (23, true);		
pstmt_p.setString (24, companyparty_id);      
//out.print("<br> 22"+companyparty_id); 
pstmt_p.setBoolean (25,currency_flag);	
pstmt_p.setString (26, ""+sale_localbalance);
//out.print("<br> 7"+sale_dollarbalance);	
pstmt_p.setString (27,""+ sale_dollarbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (28,""+ exchange_rate);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (29,""+ sale_localbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (30,""+ sale_dollarbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (31,""+ exchange_rate);		 
pstmt_p.setString (32, ""+purchase_localbalance);
//out.print("<br> 7"+purchase_dollarbalance);	
pstmt_p.setString (33,""+ purchase_dollarbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (34,""+ exchange_rate);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (35,""+ purchase_localbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (36,""+ purchase_dollarbalance);
//out.print("<br> 135"+user_id);	
pstmt_p.setString (37,""+ exchange_rate);
pstmt_p.setString (38,""+ pn_localbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (39,""+ pn_dollarbalance);
//out.print("<br> 7"+user_id);	
pstmt_p.setString (40,""+ exchange_rate);		 
pstmt_p.setBoolean (41, sale_flag);
pstmt_p.setBoolean (42, purchase_flag);
pstmt_p.setBoolean (43, pn_flag);
pstmt_p.setString (44,yearend_id);		 
//System.out.println(" 395Added Successfully: ");
int a = pstmt_p.executeUpdate();
//System.out.println(" Added Successfully: " +a);
//out.println(" Added Successfully: " +a);
pstmt_p.close();


String ledger_id= ""+L.get_master_id(conp,"Ledger");
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values (?,?,?,?, ?,?,?,?, '"+format.getDate(today_string)+"',?,? )";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,ledger_id);	
//out.print("<br >1 "+ledger_id);
pstmt_p.setString (2,company_id);
//out.print("<br >2 "+company_id);
pstmt_p.setString (3,"14");
//out.print("<br >3 ");
pstmt_p.setString (4,companyparty_id);
//out.print("<br >4 ");
pstmt_p.setString (5,companyparty_name);
pstmt_p.setString (6,"0");
//out.print("<br >4 "+"0");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,user_id);	
pstmt_p.setString (9,machine_name);
//out.print("<br >9 "+machine_name);
pstmt_p.setString (10,yearend_id);
int aledger = pstmt_p.executeUpdate();
pstmt_p.close();


C.returnConnection(conp);
C.returnConnection(conm);


}catch(Exception Samyak82){ 
	out.println("<font color=red> FileName : UpdateCompany.jsp <br>Bug No Samyak82 :"+ Samyak82 +"</font>");}

//response.sendRedirect("NewCompany.jsp?message=Company <font color=blue> "+companyparty_name+" </font>successfully Added.");


}
}// if ADD Comapny


if("UPDATE".equals(command))
{
//if("0".equals(company_id))
{
try{
	conp=C.getConnection();
//out.println("<font color=blue>Update Company</font>");
String companyparty_id	=request.getParameter("companyparty_id");
//out.println("Update CompanyParty id is"+companyparty_id);
String companyparty_name =request.getParameter("companyparty_name");
//out.println("sdfadF" +companyparty_name);
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
String active =request.getParameter("active");
//out.println(active);
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String sr_no =request.getParameter("sr_no");
String query = " Update Master_companyparty set companyparty_Name=?, Category_Code=?,  Address1=?, Address2=?, Address3=?,City=?, Pin=?, Country=?, Company=?,Income_TaxNo=?, Sales_TaxNo=?, Phone_Off=?,Phone_resi=?, Mobile=?, Email=?, website=?, Person1=?, Person2=?, Fax=?, Active=?,Sr_No=? where companyparty_Id=?"; 
//out.print("<br >2 "+companyparty_name);
//out.println("<br>Update company query:"+query);		
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,companyparty_name);
//out.print("<br >2 "+companyparty_name);
pstmt_p.setString (2, category_code);
//out.print("<br >3 "+category_code);
pstmt_p.setString (3, address1);
//out.print("<br >4 "+address1);
pstmt_p.setString (4, address2);
//out.print("<br >5 "+address2);
pstmt_p.setString (5, address3);
//out.print("<br >6 "+address3);
pstmt_p.setString (6, city);
//out.print("<br >7"+city);
pstmt_p.setString (7, pin);	
//out.print("<br >8"+pin);
pstmt_p.setString (8, country);
//out.print("<br >9 "+country);	
pstmt_p.setBoolean (9,true); 
//out.print("<br > 10 Company");	
pstmt_p.setString (10, income_taxno);
//out.print("<br > 11 "+income_taxno);
pstmt_p.setString (11, sales_taxno);
//out.print("<br > 12 "+sales_taxno);
pstmt_p.setString (12, phone_off);
//out.print("<br > 13 "+phone_off);
pstmt_p.setString (13, phone_resi);
//out.print("<br >14 resi "+phone_resi);	
pstmt_p.setString (14, mobile);	
//out.print("<br> 13"+mobile);	
pstmt_p.setString (15, email);	
//out.print("<br> 14"+email);	
pstmt_p.setString (16, website);
//out.print("<br> 17"+website);	
//out.print("<br > ok mmm"+website);	
pstmt_p.setString (17, person1);
//out.print("<br> 18"+person1);	
pstmt_p.setString (18, person2);
//out.print("<br> 19"+person2);
pstmt_p.setString (19, fax_no);
//out.print("<br> 20"+fax_no);	
pstmt_p.setBoolean(20, flag);
//out.print("<br> 21"+active);	
pstmt_p.setString (21, sr_no); 
//out.print("<br> 22"+sr_no); 
pstmt_p.setString (22, companyparty_id);
//out.print("<br >1 "+companyparty_id);
  
int a = pstmt_p.executeUpdate();
//System.out.println(" Updated Successfully: " +a);
//out.println(" Updated Successfully: " +a);
pstmt_p.close();
conp.close();
	C.returnConnection(conp);
	C.returnConnection(conm);

//response.sendRedirect("EditCompany.jsp?command=edit&message='<font color=blue>"+companyparty_name+"</font>'  successfully Updated.");
%>
<html>
<head>
<title> Fine Star - Samyak Software </title>

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
<%
}catch(Exception Samyak82){ 
out.println("<font color=red> FileName : UpdateCompany.jsp <br>Bug No Samyak82 :"+ Samyak82 +"</font>");}
}//if("0".equals(company_id))
//else{
//}
}// UPDATE Company
%>








