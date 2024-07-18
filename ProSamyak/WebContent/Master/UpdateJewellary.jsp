<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>

<% 
//System.out.print("Inside jewellary");

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

//nout.print("<br>yearend_id="+yearend_id);
//String company_name= A.getName("companyparty",company_id);
//out.print("<br>comapny_name="+company_name);
//String user_name=A.getName("User",user_id);
//out.print("<br>user_name="+user_name);

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date yearstart=null;
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

String command  = request.getParameter("command");
//out.print("<br>command=" +command);
//System.out.println("command "+command);
	ResultSet rs_g= null;
	Connection conp = null;
	Connection cong = null;
	PreparedStatement pstmt_p=null;
	
//		out.println("command is "+command);

String created_on=request.getParameter("datevalue");
java.sql.Date cr_date=format.getDate(created_on);

//created_on=format.format(Config.financialYearStart());
//out.print("<br> created_on "+created_on);
//------ADD NEW LOT For Jewelary----------------------

if("ADD".equals(command))
{

	String datevalue= request.getParameter("opdatevalue");
	String lotcategory_id="";
	String lotsubcategory_id="";
	String unit_id="";
try{

//----------Finding  lotcategory_id --------------------------
String selectquery ="Select * from Master_LotCategory where LotCategory_Name='Jewelry' and  Company_id=?"; 
//out.print(selectquery);
conp=C.getConnection();
cong=C.getConnection();

pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,company_id);

//out.print("<br>46" +selectquery);
rs_g = pstmt_p.executeQuery();	

while(rs_g.next())
	{
//	out.print("<br>lotcategory_id=>");
		lotcategory_id =rs_g.getString("LotCategory_Id");
//		out.print(lotcategory_id);
	}

pstmt_p.close();

//---------lotsubcategory_id-------------------


	selectquery ="Select * from Master_LotSubCategory where LotSubCategory_Name='Jewelry' and  Company_id=?"; 
//out.print(selectquery);
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,company_id);

//out.print("<br>46" +selectquery); 
rs_g = pstmt_p.executeQuery();	

while(rs_g.next())
	{
//	out.print("<br>lotsubcategory_id=>");
		lotsubcategory_id =rs_g.getString("LotSubCategory_Id");
//		out.print(lotsubcategory_id);
	}

pstmt_p.close();

//---------------------------------------------------------------------------
 selectquery ="Select * from Master_Unit where Unit_Name='Pieces' and  Company_id=?"; 
//out.print(selectquery);
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,company_id);

//out.print("<br>46" +selectquery);
rs_g = pstmt_p.executeQuery();	

while(rs_g.next())
	{
//	out.print("<br>unit_id=>");
		unit_id =rs_g.getString("Unit_Id");
//		out.print(unit_id);
	}

pstmt_p.close();

//-----------------------------------------------------------
String detail ="";
detail= request.getParameter("detail");	
//out.print("<br>detail=>"+detail);
boolean flag =false; 
if("yes".equals(detail)){flag=true;}
//out.print("<br>flag=>"+flag);


String lot_id= ""+L.get_master_id(conp,"Lot");
//out.print("<br>lot_id=>"+lot_id);

String lot_no= request.getParameter("lot_no");
//out.print("<br>lot_no=>"+lot_no);

String reference= request.getParameter("reference");	
//out.print("<br>reference=>"+reference);

String lot_name= request.getParameter("lot_name");
//out.print("<br>lot_name=>"+lot_name);

String lot_description= request.getParameter("Description");
//out.print("<br>lot_description=>"+lot_description);

String lot_location= request.getParameter("lot_location");
//out.print("<br>lot_location=>"+lot_location);

String reorderquantity=request.getParameter("reorderquantity");
//out.print("<br>reorderquantity=>"+reorderquantity);


//--------------------------------------------------------------------
String selectquery1 ="Select * from lot where lot_no=? and  company_id=? and Active=1"; 
pstmt_p = conp.prepareStatement(selectquery1);
pstmt_p.setString (1,lot_no);		
pstmt_p.setString (2,company_id);	
//out.print("<br>46" +selectquery1);
rs_g = pstmt_p.executeQuery();	

int i=0;

while(rs_g.next())
{
	i++;
}
pstmt_p.close();
//out.print("<br>i=>"+i+"<br>i=>");

if(i==0)//checking same lot present or not
{

//----------------------------------------------------------------------

//if(flag)
//	{
		//cr_date=Config.financialYearStart();
		String condition = " where company_id="+company_id+" and yearend_id="+yearend_id;
		cr_date = YED.getDate(conp, "YearEnd", "From_Date", condition);
		int crdd=cr_date.getDate();
		crdd--;
		//cr_date.setString(""+crdd);
		created_on=format.format(cr_date);
//	}
conp.setAutoCommit(false);

String query = " INSERT INTO Lot ( Lot_Id, Company_Id,Lot_No, Lot_Name,   Lot_Description, Lot_Referance,Lot_Location,LotCategory_Id   ,LotSubCategory_Id,Unit_Id,Carats,Available_Carats  ,ReorderQuantity,Created_On,Created_By, Modified_On,    Modified_By,Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,'"+format.getDate(created_on)+"',?,'"+format.getDate(today_string)+"',?,?,?)";//18
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1,lot_id);	
//out.print("<br>194 lot_id="+lot_id);
pstmt_p.setString (2,company_id);	
//out.print("<br>196 company_id="+company_id);
pstmt_p.setString (3,lot_no);	
//out.print("<br>198 lot_no="+lot_no);
pstmt_p.setString (4,lot_no);			
pstmt_p.setString (5,lot_description);
//out.print("<br>201 lot_description="+lot_description);
pstmt_p.setString (6,reference);
//out.print("<br>203 reference="+reference);
pstmt_p.setString (7, lot_location);
//out.print("<br>205 lot_location="+lot_location);
pstmt_p.setString (8,lotcategory_id);
//out.print("<br>207 lotcategory_id="+lotcategory_id);
pstmt_p.setString (9,lotsubcategory_id);
//out.print("<br>209 lotsubcategory_id="+lotsubcategory_id);
pstmt_p.setString (10,unit_id);
//out.print("<br>211 unit_id="+unit_id);
pstmt_p.setDouble(11,0);	
pstmt_p.setDouble(12,0);	// indicate new diamond-> created_on
pstmt_p.setString (13,reorderquantity);
//out.print("<br>215 reorderquantity="+reorderquantity);
pstmt_p.setString (14, user_id);	
//out.print("<br>217 user_id="+user_id);
pstmt_p.setString (15, user_id);
//out.print("<br>219 user_id="+user_id);
pstmt_p.setString (16, machine_name);
//out.print("<br>221 machine_name="+machine_name);
pstmt_p.setString (17,yearend_id);
//out.print("<br>223 yearend_id="+yearend_id);
int a=0;
try{

 a = pstmt_p.executeUpdate();

}catch(Exception Samyak45){ 
out.println("<br><font color=blue><h2>"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}
pstmt_p.close();

//-------------Lot Update Complete Here -----------------------------

	String client_no= request.getParameter("client_no");
	//out.print("<br>client_no=>"+client_no);
	
	String total_weight= request.getParameter("total_weight");
	//out.print("<br>total_weight=>"+total_weight);

	String gross_weight= request.getParameter("gross_weight");
	//out.print("<br>gross_weight=>"+gross_weight);

	String metal_weight= request.getParameter("metal_weight");
	//out.print("<br>metal_weight=>"+metal_weight);

	String item_typeid= request.getParameter("item_typeid");
	//out.print("<br>item_typeid=>"+item_typeid);

	String country_id= request.getParameter("country_id");
	//out.print("<br>country_id=>"+country_id);

	String treatment_id= request.getParameter("treatment_id");
	//out.print("<br>treatment_id=>"+treatment_id);

	String colorstone_id= request.getParameter("colorstone_id");
	//out.print("<br>colorstone_id=>"+colorstone_id);

	String gold_id= request.getParameter("gold_id");
	//out.print("<br>gold_id=>"+gold_id);

	String platinum_id= request.getParameter("platinum_id");
	//out.print("<br>platinum_id=>"+platinum_id);

	String gold_qty= request.getParameter("gold_qty");
	//out.print("<br>gold_qty=>"+gold_qty);

	String platinum_qty= request.getParameter("platinum_qty");
	//out.print("<br>platinum_qty=>"+platinum_qty);

	String selling_price= request.getParameter("selling_price");
	//out.print("<br>selling_price=>"+selling_price);

	String tag_price= request.getParameter("tag_price");
	//out.print("<br>tag_price=>"+tag_price);

	String shape_id= request.getParameter("shape_id");
	//out.print("<br>shape_id=>"+shape_id);

	String numberofstones= request.getParameter("numberofstones");
	//out.print("<br>numberofstones=>"+numberofstones);

	String Book_No= request.getParameter("Book_No");
	//out.print("<br>Book_No=>"+Book_No);

	String GroupCode_Id= request.getParameter("GroupCode_Id");
	//out.print("<br>GroupCode_Id=>"+GroupCode_Id);

	String Supplier_Id= request.getParameter("Supplier_Id");
	//out.print("<br>Supplier_Id=>"+Supplier_Id);

	String Diamond_Weight= request.getParameter("Diamond_Weight");
//	out.print("<br>Diamond_Weight=>"+Diamond_Weight);

	String ColorStone_Weight= request.getParameter("ColorStone_Weight");
//	out.print("<br>ColorStone_Weight=>"+ColorStone_Weight);

	String GoldMetaltype_Id= request.getParameter("GoldMetaltype_Id");
//	out.print("<br>GoldMetaltype_Id=>"+GoldMetaltype_Id);

	String Price_Code= request.getParameter("Price_Code");
//	out.print("<br>Price_Code=>"+Price_Code);

	query = " INSERT INTO Jewelry (Lot_Id,Client_No,Total_Weight,Gross_Weight, Metal_Weight,Item_TypeId,Country_Id,Treatment_Id, Color_StoneId,Gold_Id,Platinum_Id,Gold_Qty, Platinum_Qty,Selling_Price,Tag_Price,Shape_Id,   Number_Of_stones,Book_No ,GroupCode_Id , Diamond_Weight,ColorStone_Weight ,GoldMetaltype_Id ,Price_Code,Supplier_Id,YearEnd_Id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?,?, ?,?,?,?,?)";//24


pstmt_p = conp.prepareStatement(query);

pstmt_p.setString(1,lot_id);		
pstmt_p.setString(2,client_no);		
pstmt_p.setString(3,total_weight);		
pstmt_p.setString(4,gross_weight);

pstmt_p.setString(5,metal_weight);		
pstmt_p.setString(6,item_typeid);		
pstmt_p.setString(7,country_id);		
pstmt_p.setString(8,treatment_id);	

pstmt_p.setString(9,colorstone_id);		
pstmt_p.setString(10,gold_id);		
pstmt_p.setString(11,platinum_id);		
pstmt_p.setString(12,gold_qty);

pstmt_p.setString(13,platinum_qty);		
pstmt_p.setString(14,selling_price);		
pstmt_p.setString(15,tag_price);		
pstmt_p.setString(16,shape_id);

pstmt_p.setString(17,numberofstones);		
pstmt_p.setString(18,Book_No);		
pstmt_p.setString(19,GroupCode_Id);		
pstmt_p.setString(20,Diamond_Weight);		

pstmt_p.setString(21,ColorStone_Weight);		
pstmt_p.setString(22,GoldMetaltype_Id);		
pstmt_p.setString(23,Price_Code);		
pstmt_p.setString(24,Supplier_Id);		
pstmt_p.setString(25,yearend_id);		

 a = pstmt_p.executeUpdate();
pstmt_p.close();

//---------------------------Complete  Jewelry Table--------------------------------------

if(flag==true)
{

double carats = Double.parseDouble(request.getParameter("carats"));
//out.print("<br>carats=>"+carats);
//datevalue="31/03/2004";
String receive_id= ""+L.get_master_id(conp,"Receive");
String currency= request.getParameter("currency");
String location_id= request.getParameter("location_id");
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
double rate= Double.parseDouble(request.getParameter("rate"));
double total= rate * carats;

double local_price=0;
double dollar_price=0;
double local_total=0;
double dollar_total=0;
String currency_id="";

if("local".equals(currency))
	{
local_price= rate;
local_total= carats * rate;
dollar_price = rate / exchange_rate ;
dollar_total = dollar_price * carats;

currency_id=I.getLocalCurrency(conp,company_id);
	}

else{
dollar_price= rate;
dollar_total= carats * rate;
local_price = rate * exchange_rate ;
local_total = local_price * carats;
currency_id="0";
}
//---------------------------------------------------------------------
		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+format.getDate(today_string)+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br> 141"+query);
		pstmt_p.setString (1, ""+ L.get_master_id(cong,"LotLocation"));	
//		out.print("<br> LotLocation_Id  "+L.get_master_id("LotLocation"));

		pstmt_p.setString (2,location_id);
//		out.print("<br> location_id  "+location_id[i]);

		pstmt_p.setString (3,""+lot_id);
//		out.print("<br> Lot_Id  "+Lot_Id);
		pstmt_p.setString (4,company_id);
		
		pstmt_p.setString (5,""+carats);	
//		out.print("<br> AQuantity  "+AQuantity[i]);

		pstmt_p.setString (6, ""+carats);	
		pstmt_p.setString (7, user_id);		
		pstmt_p.setString (8, machine_name);		
		pstmt_p.setString (9,yearend_id);		
		int a435 = pstmt_p.executeUpdate();
		pstmt_p.close();

//----------------------------------------
query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_CurrencyId,Exchange_Rate,Receive_ExchangeRate,Receive_Total,    Local_Total, Dollar_Total, Company_Id,Purchase,    Opening_Stock, Modified_On, Modified_By, Modified_MachineName,   Receive_Quantity,Stock_Date,YearEnd_Id ) values (?,?,'"+format.getDate(datevalue)+"',? ,?,?,?,? ,?,?,?,?,? ,?, ?,?,?,'"+format.getDate(datevalue)+"',?)";

pstmt_p = conp.prepareStatement(query);


pstmt_p.setString (1, receive_id);		
pstmt_p.setString (2,"OP-"+receive_id);	
//out.print("<br>2");
pstmt_p.setString (3, "1");	
pstmt_p.setString (4,currency_id);	
pstmt_p.setString (5,""+exchange_rate);	
//out.print("<br>5");

pstmt_p.setString (6, ""+exchange_rate);	
pstmt_p.setString (7, ""+total);
//out.print("<br>7");
pstmt_p.setString (8,""+local_total);	
pstmt_p.setString (9, ""+dollar_total);	
pstmt_p.setString (10,company_id);			

pstmt_p.setBoolean (11,true);	
pstmt_p.setBoolean (12,true);
pstmt_p.setString(13,""+today_date);

pstmt_p.setString (14,user_id);		
pstmt_p.setString (15,machine_name);
pstmt_p.setString (16, ""+carats);	
pstmt_p.setString (17,yearend_id);
//out.println("Before Query <br>"+query);

int a224 = pstmt_p.executeUpdate();
pstmt_p.close();

	//------------------Recive Table Completed ------------------------------------
String receivetransaction_id= ""+L.get_master_id(conp,"Receive_Transaction");

query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id,       Quantity, Available_Quantity, Receive_Price, Local_Price,    Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive ,location_id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,'"+today_date+"', ?,? ,?,?,?)";

pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1,receivetransaction_id);		
pstmt_p.setString (2,receive_id);	
pstmt_p.setString (3, "1");	

pstmt_p.setString (4,lot_id);			
pstmt_p.setString (5,""+carats);	
pstmt_p.setString (6, ""+carats);	

pstmt_p.setString (7, ""+rate);
pstmt_p.setString (8,""+local_price);	
pstmt_p.setString (9, ""+dollar_price);	

pstmt_p.setString (10, user_id);		
pstmt_p.setString (11, machine_name);		
pstmt_p.setBoolean (12,true);	
pstmt_p.setString (13,location_id);	
pstmt_p.setString (14,yearend_id);	

int a245 = pstmt_p.executeUpdate();
//out.println("Receive Transaction query Executed:"+a224);
pstmt_p.close();

//------------------------Receisve Transaction Table is completed -----------------------


	}//end inner if


conp.commit();

C.returnConnection(conp);
C.returnConnection(cong);

//System.out.println("After query result a is "+a);
response.sendRedirect("NewJewellary.jsp?message=Lot No <font color=blue> "+lot_no+" </font>successfully Added");

}
else
{
C.returnConnection(conp);
C.returnConnection(cong);

out.println("<body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Lot No <font color=blue>"+lot_no+" </font>already exists.</font></b><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end
//C.returnConnection(conp);
}catch(Exception Samyak45){ 
conp.rollback();
C.returnConnection(conp);
C.returnConnection(cong);

out.println("<br><font color=red><h2> FileName : UpdateLot.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'>");}



} //if ADD LOT jwelery



if("Save".equals(command))
{
try{
//out.print("<br>23");
 conp=C.getConnection();
 cong=C.getConnection();
String lot_no= request.getParameter("lot_no");	
created_on = request.getParameter("datevalue");
String client_no= request.getParameter("client_no");	
String lot_name= request.getParameter("lot_name");
String lot_description= request.getParameter("lot_description");
String lot_location= request.getParameter("lot_location");

String total_weight= request.getParameter("total_weight");
String gross_weight= request.getParameter("gross_weight");
String metal_weight= request.getParameter("metal_weight");


String lot_id= ""+L.get_master_id(conp,"Lot");

String item_typeid= request.getParameter("item_typeid");
String country_id= request.getParameter("country_id");
String treatment_id= request.getParameter("treatment_id");
String shape_id= request.getParameter("shape_id");
String colorstone_id= request.getParameter("colorstone_id");
String gold_id= request.getParameter("gold_id");
String gold_qty= request.getParameter("gold_qty");
String platinum_id= request.getParameter("platinum_id");
String platinum_qty= request.getParameter("platinum_qty");
String selling_price= request.getParameter("selling_price");
String tag_price= request.getParameter("tag_price");

//out.print("<br>43platinum_qty"+platinum_qty);

double carats = Double.parseDouble(request.getParameter("carats"));
String diamonds = request.getParameter("diamonds");
String currency= request.getParameter("currency");
double rate= Double.parseDouble(request.getParameter("rate"));
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
double local_price=0;
double dollar_price=0;
double local_total=0;
double dollar_total=0;
double total= rate * carats;
String currency_id="";


if("local".equals(currency))
	{
local_price= rate;
local_total= carats * rate;
dollar_price = rate / exchange_rate ;
dollar_total = dollar_price * carats;
currency_id=I.getLocalCurrency(conp,company_id);
	}

else{
dollar_price= rate;
dollar_total= carats * rate;
local_price = rate * exchange_rate ;
local_total = local_price * carats;
currency_id="0";
}



String selectquery ="Select * from lot where lot_no=? and  company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,lot_no);		
pstmt_p.setString (2,company_id);	
//out.print("<br>46" +selectquery);
rs_g = pstmt_p.executeQuery();	
int i=0;
while(rs_g.next()){i++; }
pstmt_p.close();

if(i<1)
{

String query = " INSERT INTO Lot ( Lot_Id, Company_Id,Lot_No, Lot_Name, Lot_Description, Lot_Referance, Lot_Location,Carats, Diamond_Pieces, Available_Carats, Purchase,Shape_Id, Created_On, Created_By, Modified_On, Modified_By, Modified_MachineName,Diamond,Client_No,Total_Weight,Gross_Weight,Metal_Weight,Item_TypeId,Country_Id,Treatment_Id,Color_StoneId,Gold_Id,Platinum_Id,Gold_Qty,Platinum_Qty,Selling_Price,Tag_Price,YearEnd_Id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, '"+format.getDate(created_on)+"',?,'"+format.getDate(today_string)+"', ?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?)";
//total columns 28
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,lot_id);		
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,lot_no);	
pstmt_p.setString (4,lot_name);			
pstmt_p.setString (5,lot_description);	
pstmt_p.setString (6,"new jewllary");	
pstmt_p.setString (7,lot_location);	

pstmt_p.setString (8,""+carats);	
pstmt_p.setString (9, diamonds);	
pstmt_p.setString (10, ""+carats);			
pstmt_p.setBoolean (11,true);	


pstmt_p.setString (12,shape_id);		
pstmt_p.setString (13, user_id);		
pstmt_p.setString (14, user_id);		
pstmt_p.setString (15, machine_name);		
//out.print("<br> 10machine_name"+machine_name);	

/*		-----For jewellary------------					*/
pstmt_p.setBoolean (16,false);	
/*		-----For jewellary------------					*/
//for jewellary Diamond field is false;	

pstmt_p.setString (17,client_no);	
pstmt_p.setString (18,total_weight);	
pstmt_p.setString (19,gross_weight);	
pstmt_p.setString (20,metal_weight);	
pstmt_p.setString (21,item_typeid);			
pstmt_p.setString (22,country_id);			
pstmt_p.setString (23,treatment_id);			
pstmt_p.setString (24,colorstone_id);			
pstmt_p.setString (25,gold_id);			
pstmt_p.setString (26,platinum_id);			
pstmt_p.setString (27,gold_qty);			
pstmt_p.setString (28,platinum_qty);			
pstmt_p.setString (29,selling_price);			
pstmt_p.setString (30,tag_price);			
pstmt_p.setString (31,yearend_id);			

//out.println("Before Query <br><font color=blue>"+query+"</font>");
int a122 = pstmt_p.executeUpdate();
pstmt_p.close();
//out.println("Opening Stock for jewelry updated Successfully"+a122);


///****************************
String receive_id= ""+L.get_master_id(conp,"Receive");
query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_CurrencyId, Exchange_Rate, Receive_ExchangeRate, Receive_Total, Local_Total, Dollar_Total, Company_Id,Purchase, Opening_Stock, Modified_On, Modified_By, Modified_MachineName, Receive_Quantity,YearEnd_Id ) values (?,?,'"+format.getDate(created_on)+"',? ,?,?,?,? ,?,?,?,?,? ,'"+format.getDate(today_string)+"', ?,?,?,?)";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, receive_id);		
pstmt_p.setString (2,"OP-"+receive_id);	
//out.print("<br>2");
pstmt_p.setString (3, "1");	
pstmt_p.setString (4,currency_id);			
pstmt_p.setString (5,""+exchange_rate);	
//out.print("<br>5");
pstmt_p.setString (6, ""+exchange_rate);	
pstmt_p.setString (7, ""+total);
//out.print("<br>7");
pstmt_p.setString (8,""+local_total);	
pstmt_p.setString (9, ""+dollar_total);	
pstmt_p.setString (10, company_id);			
pstmt_p.setBoolean (11,true);	
pstmt_p.setBoolean (12,true);	
pstmt_p.setString (13, user_id);		
pstmt_p.setString (14, machine_name);		//out.print("<br> 8"+machine_name);	
pstmt_p.setString (15, ""+carats);	
pstmt_p.setString (16,yearend_id);	
//out.print("<br> 8"+machine_name);	
//out.println("Before Query <br>"+query);
int a224 = pstmt_p.executeUpdate();
pstmt_p.close();
//System.
//out.println("Receive query Executed:"+a224);


String receivetransaction_id= ""+L.get_master_id(conp,"Receive_Transaction");
query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Quantity, Available_Quantity, Receive_Price, Local_Price, Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive,YearEnd_id ) values (?,?,?,?, ?,?,?,?, ?,'"+format.getDate(today_string)+"', ?,? ,?,?)";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, receivetransaction_id);		
pstmt_p.setString (2,receive_id);	
//out.print("<br>2");
pstmt_p.setString (3, "1");	
pstmt_p.setString (4,lot_id);			
pstmt_p.setString (5,""+carats);	
//out.print("<br>5");
pstmt_p.setString (6, ""+carats);	
pstmt_p.setString (7, ""+rate);
out.print("<br>7");
pstmt_p.setString (8,""+local_price);	
pstmt_p.setString (9, ""+dollar_price);	
pstmt_p.setString (10, user_id);		
pstmt_p.setString (11, machine_name);		
pstmt_p.setBoolean (12,true);	
pstmt_p.setString (13,yearend_id);		
//out.print("<br> 8"+machine_name);	
//out.println("Before Query <br>"+query);
int a245 = pstmt_p.executeUpdate();
//out.println("Receive Transaction query Executed:"+a224);
pstmt_p.close();
//System.out.println("After query result a is "+a245);
C.returnConnection(conp);
C.returnConnection(cong);

response.sendRedirect("../Master/OpeningStockjewellary.jsp?message=Jewelery Lot No <font color=blue> "+lot_no+" </font>successfully Added");
//-----------------------------------

//response.sendRedirect("NewJewellary.jsp?message=Jewelery for Lot No <font color=blue> "+lot_no+" </font>successfully Added");
}
else
{
C.returnConnection(conp);
C.returnConnection(cong);

out.println("<BODY background='../Buttons/BGCOLOR.JPG'><center><font color=red face=times new roman size=1 > <b>Jewellary No <font color=blue>"+lot_no+"</font> already exists. </b></font> <br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
}//if end
//C.returnConnection(conp);
}catch(Exception Samyak45){ 
out.println("<br><font color=red><h2> FileName : UpdateLot.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}

}

if("Update".equals(command))
{
try{
	
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
itoday_day=D.getDate();
stoday_day=""+itoday_day;
if(itoday_day < 10){stoday_day="0"+itoday_day;}
itoday_month=(D.getMonth()+1);
stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
today_year=(D.getYear()+1900);
today_string=stoday_day+"/"+stoday_month+"/"+today_year;
// end of today_date in dd/mm/yyyy format

//out.print("<br>23today_string"+today_string);
String lot_id= request.getParameter("lot_id");	
//out.print("<br>23lot_id"+lot_id);
created_on = request.getParameter("datevalue");
//out.print("<br>23created_on"+created_on);
String client_no= request.getParameter("client_no");	
String lot_name= request.getParameter("lot_name");
String lot_description= request.getParameter("lot_description");
String lot_location= request.getParameter("lot_location");
String total_weight= request.getParameter("total_weight");
String gross_weight= request.getParameter("gross_weight");
String metal_weight= request.getParameter("metal_weight");
String item_typeid= request.getParameter("Itemtype_id");
String country_id= request.getParameter("country_id");
String treatment_id= request.getParameter("treatment_id");
String shape_id= request.getParameter("shape_id");
String colorstone_id= request.getParameter("colorstone_id");
String gold_id= request.getParameter("gold_id");
String gold_qty= request.getParameter("gold_qty");
String platinum_id= request.getParameter("platinum_id");
String platinum_qty= request.getParameter("platinum_qty");
String selling_price= request.getParameter("selling_price");
String tag_price= request.getParameter("tag_price");
//out.println("Line no 370");
{
String query = "Update Lot set Lot_Name=?, Lot_Description=?, Lot_Location=?, Shape_Id=?,  Created_On='"+format.getDate(created_on)+"', Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=? ,Client_No=?,Total_Weight=?, Gross_Weight=?, Metal_Weight=?,Item_TypeId=?, Country_Id=?,Treatment_Id=?, Color_StoneId=?,Gold_Id=?, Platinum_Id=?,Gold_Qty=?,Platinum_Qty=?,Selling_Price=?, Tag_Price=? where Lot_Id=?";
conp=C.getConnection();
cong=C.getConnection();
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,lot_name);			
pstmt_p.setString (2,lot_description);	
pstmt_p.setString (3,lot_location);		
pstmt_p.setString (4,shape_id);			
pstmt_p.setString (5,user_id);
//out.println("<br>Line no 380");
pstmt_p.setString (6,machine_name);			
pstmt_p.setString (7,client_no);			
pstmt_p.setString (8,total_weight);			
pstmt_p.setString (9,gross_weight);			
//out.println("<br>Line no 385");
pstmt_p.setString (10,metal_weight);			
//out.println("<br>Line no 387");
pstmt_p.setString (11,item_typeid);			
//out.println("<br>Line no 389");
pstmt_p.setString (12,country_id);			
//out.println("<br>Line no 391");
pstmt_p.setString (13,treatment_id);			
//out.println("<br>Line no 393");
pstmt_p.setString (14,colorstone_id);			
pstmt_p.setString (15,gold_id);			
pstmt_p.setString (16,platinum_id);	
pstmt_p.setString (17,gold_qty);	
pstmt_p.setString (18,platinum_qty);	
pstmt_p.setString (19,selling_price);		
pstmt_p.setString (20,tag_price);		
pstmt_p.setString (21,lot_id);		
//out.print("<br>398lot_id"+lot_id);	
//out.println("Before Query <br>"+query);
int a165 = pstmt_p.executeUpdate();
//out.println("<br><br>Updated"+a165);
pstmt_p.close();
C.returnConnection(conp);
C.returnConnection(cong);

response.sendRedirect("EditJewelry.jsp?command=edit&message=Lot No <font color=blue> "+lot_name+" </font>successfully Updated");
}
//C.returnConnection(conp);
}catch(Exception Samyak45){ 
out.println("<br><font color=red><h2> FileName : UpdateLot.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}

}//if Update
//conp.close();
%>








