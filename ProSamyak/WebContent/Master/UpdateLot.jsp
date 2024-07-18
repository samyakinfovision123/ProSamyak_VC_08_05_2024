<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="LHB"   class="NipponBean.LotHistoryBean" />
<jsp:useBean id="S"   class="NipponBean.Stock" />

<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


</head>

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
int usDlr= Integer.parseInt(""+session.getValue("usDlr"));
ResultSet rs_p= null;
ResultSet rs_g= null;
Connection conp = null;
Connection cong = null;
Connection cong1 = null;
	//Connection conp2 = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;

cong=C.getConnection();

java.sql.Date from_date_new = YED.getDate(cong, "YearEnd", "From_Date", " where company_id="+company_id+" and yearend_id="+yearend_id);

java.sql.Date to_date_new = YED.getDate(cong, "YearEnd", "To_Date", "  where company_id="+company_id+" and yearend_id="+yearend_id);

String company_name= A.getName(cong,"companyparty",company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;

String command  = request.getParameter("command");
//String datevalue = 
String created_on = request.getParameter("datevalue");
String condition = " where company_id="+company_id+" and yearend_id="+yearend_id;
java.sql.Date cr_date = YED.getDate(cong, "YearEnd", "From_Date", condition);
int crdd=cr_date.getDate();
crdd--;
cr_date.setDate(crdd);

C.returnConnection(cong);


//Add Lot Start Here.
if("ADD LOT".equals(command))
{ 

  conp=C.getConnection();
  cong=C.getConnection();
  cong1=C.getConnection();

	//out.print("<br>67 ADD");
String cut_id= request.getParameter("Cut_Id");
//out.print("<br>80 cut_id=>"+cut_id);
String color_id= request.getParameter("Color_Id");
String purity_id= request.getParameter("Purity_Id");
String OwnerCategory_Id=request.getParameter("OwnerCategory_Id");
String fluorescence_id= request.getParameter("Fluorescence_Id");
String shape_id =request.getParameter("Shape_Id");
String lab_id= request.getParameter("Lab_Id");
String polish_id= request.getParameter("Polish_Id");
String tableincusion_id= request.getParameter("TableIncusion_Id");
String symmetry_id= request.getParameter("Symmetry_Id");
String luster_id= request.getParameter("luster_id");
String total_depth= request.getParameter("total_depth");
String crown_angle= request.getParameter("crown_angle");
String table_per= request.getParameter("table_per");
String size_id= request.getParameter("size_id");
String dollar_amt=request.getParameter("dollar_amt");
String local_amt=request.getParameter("local_amt");
//out.println("<br>102 dollar_amt="+dollar_amt);
//out.println("<br>103 local_amt="+local_amt);

String country_id= request.getParameter("Country_id");
String shade_id= request.getParameter("shade_id");
String blackinclusion= request.getParameter("Blackinclusion_id");
String openinclusion= request.getParameter("openinclusion_id");
String description= request.getParameter("Description_Id");
String size1= request.getParameter("Size_Id");
String location_id0= request.getParameter("location_id0");
//out.print("<br>123 location_id0="+location_id0);
//out.print("<br>296 description="+description);
//out.print("<br>297 size1="+size1);
String weight= request.getParameter("weight");
String Group_Id=request.getParameter("Group_Id");
//out.print("<br>100 Group_Id="+Group_Id);
String purchase_price= request.getParameter("purchase_price");
String Selling_price= request.getParameter("selling_price");
//out.print("<br>243 Selling_price="+Selling_price);

	
	
     String query="";
     int a=1;
	 String detail ="";
	if(request.getParameter("os") != null)
	detail= request.getParameter("os");	

	//if(detail.equals("yes"))
	created_on=format.format(cr_date);

	String datevalue= request.getParameter("opdatevalue");
	String lotcategory_id="";
	String lotsubcategory_id="";
	String unit_id="";
try
{

//System.out.println("154 conp get");


//--------------Finding  lotcategory_id --------------------------
String selectquery ="Select LotCategory_Id from Master_LotCategory where LotCategory_Name='Diamond' and  Company_id=?"; 
//out.print(selectquery);
pstmt_g = cong.prepareStatement(selectquery);
pstmt_g.setString (1,company_id);
//out.print("<br>46" +selectquery);
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{
//	out.print("123=>");
	lotcategory_id =rs_g.getString("LotCategory_Id");
	//out.print("<br>107 lotcategory_id"+lotcategory_id);
}
pstmt_g.close();

//------------------lotsubcategory_id---------------------------------

selectquery ="Select LotSubCategory_Id from Master_LotSubCategory where LotSubCategory_Name='Diamond' and  Company_id=?"; 
//out.print(selectquery);
pstmt_g = cong.prepareStatement(selectquery);
pstmt_g.setString (1,company_id);
//out.print("<br>46" +selectquery); 
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
	{
		lotsubcategory_id =rs_g.getString("LotSubCategory_Id");
		//out.print(lotsubcategory_id);
	}
pstmt_g.close();
//--------------------------------------------------------------

selectquery ="Select Unit_Id from Master_Unit where Unit_Name='Carats' and  Company_id=?"; 
//out.print(selectquery);
pstmt_g = cong.prepareStatement(selectquery);
pstmt_g.setString (1,company_id);

//out.print("<br>132" +selectquery);
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
	//out.print("123");
		unit_id =rs_g.getString("Unit_Id");
	//out.print(unit_id);
	}
pstmt_g.close();
//----------------------------------------------------------------

boolean flag =false; 

if("yes".equals(detail)){flag=true;}
//out.print("<br>flag=>"+flag);


String lot_id= ""+L.get_master_id(cong,"Lot");
int int_lot_id=Integer.parseInt(lot_id);
//out.print("<br>210 int_lot_id="+int_lot_id);
///////////////////
//LotLocation
String dia_id= ""+L.get_master_id(cong,"Diamond");
int int_dia_id=Integer.parseInt(dia_id);

String loc_id= ""+L.get_master_id(cong,"LotLocation");
int int_loc_id=Integer.parseInt(loc_id);

String receivetransaction_id= ""+L.get_master_id(cong,"Receive_Transaction");
int int_rt_id=Integer.parseInt(receivetransaction_id);

String receive_id= ""+L.get_master_id(cong,"Receive");
int int_receive_id=Integer.parseInt(receive_id);
String effective_id= ""+L.get_master_id(cong,"Effective_Rate");
int int_effective_id=Integer.parseInt(effective_id);
String lot_no= request.getParameter("lot_no");	
String reference= request.getParameter("reference");	
String lot_name= request.getParameter("lot_name");
String lot_description=request.getParameter("lot_description");
String diameter= request.getParameter("diameter");
String lot_location= request.getParameter("lot_location");

lot_location=A.getNameCondition(cong,"Master_Location","Location_Name"," where Location_Id="+location_id0);
//out.print("<br>241 lot_location="+lot_location);
String reorderquantity=request.getParameter("reorderquantity");

//---------------------------------------------------------
//int level=cong.getTransactionIsolation();
//cong.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

String select_diamond="select count(*) as Total from Diamond D ,Lot L  where D_Size="+size1+" and Description_Id="+description+" and L.Lot_Id=D.Lot_Id";
//out.print("<br>306 select_diamond="+select_diamond);
pstmt_g = cong.prepareStatement(select_diamond);
int totalcount=0;
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
	{

        totalcount= rs_g.getInt("Total");

//		out.print("<br>313 totalcount ="+totalcount);
	}
//out.print("<br>314 totalcount ="+totalcount);
pstmt_g.close();

//conp.setTransactionIsolation(level);

//if no lot present with same desciption and size id
totalcount=0;
if(totalcount==0)

	{

		String selectquery1 ="Select Lot_Id from lot where lot_no=? and  company_id=?"; 
		pstmt_g = cong.prepareStatement(selectquery1);
		pstmt_g.setString (1,lot_no);		
		pstmt_g.setString (2,company_id);	
//		out.print("<br>46" +selectquery1);
		rs_g = pstmt_g.executeQuery();	

		int i=0;

	while(rs_g.next())
{
	i++;
}
pstmt_g.close();

if(i==0)//checking same lot present or not
{
//--------------------------------------------------------------
//conp1.setAutoCommit(false);
//conp2.setAutoCommit(false);

String  super_company="select count(*) as MCPCOUNT from Master_CompanyParty where Super=1 and Company=1";

pstmt_g = cong.prepareStatement(super_company);
rs_g = pstmt_g.executeQuery();	
int adminCount=0;
while(rs_g.next())
{
	adminCount=rs_g.getInt("MCPCOUNT");
}
pstmt_g.close();

//out.print("<br>284  adminCount="+adminCount);
int adminCount2=adminCount;
String Compnay_party_id[]=new String[adminCount];
String Compnay_MainLocationId[]=new String[adminCount];


super_company="select distinct(CompanyParty_Id) from Master_CompanyParty where Super=1 and Company=1 and Company_Id=0 and Active=1";
pstmt_g = cong.prepareStatement(super_company);

rs_g = pstmt_g.executeQuery();	
int adminCompCount=0;
int count1=0;
while(rs_g.next())
{
	Compnay_party_id[count1]=rs_g.getString("CompanyParty_Id");
   
    
//out.print("<br>332 Compnay_party_id=>"+Compnay_party_id[count1]);


String MainLocationconpition= " where company_id="+Compnay_party_id[count1]+" and Location_Name='Main' and Active=1";


Compnay_MainLocationId[count1]=A.getNameCondition(cong1, "Master_Location", "Location_Id"," "+MainLocationconpition);



//out.print("<br>338 Compnay_MainLocationId :" +Compnay_MainLocationId[count1]);
count1=count1+1;

}
	//int count=id_counter;
for (int count=0;count<adminCount;count++)
	{  
	
String y_id=A.getNameCondition(cong,"YearEnd","YearEnd_Id"," where Company_Id="+Compnay_party_id[count]);

	conp.setAutoCommit(false);

	String  query1 = " INSERT INTO Lot ( Lot_Id, Company_Id,Lot_No, Lot_Name,Lot_Description, Lot_Referance,Lot_Location,LotCategory_Id   ,LotSubCategory_Id,Unit_Id,Carats,Available_Carats  ,ReorderQuantity,Purchase,Created_On,Created_By, Modified_On,    Modified_By,Modified_MachineName,YearEnd_Id,Active) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?)";//18

//out.print("<br>322 query="+query1);

pstmt_p = conp.prepareStatement(query1);

//out.print("<br>231 query="+query1);

pstmt_p.setString (1,""+(int_lot_id));	

//out.print("<br>234 int_lot_id="+int_lot_id);

pstmt_p.setString (2,""+Compnay_party_id[count]);	

//out.print("<br>340 Compnay_party_id[count]="+Compnay_party_id[count]);

pstmt_p.setString (3,lot_no);	

//out.print("<br>337 lot_no="+lot_no);
pstmt_p.setString (4,lot_no);	
//out.print("<br>339 lot_no="+lot_no);
pstmt_p.setString (5,""+int_lot_id);	

pstmt_p.setString (6,reference);

pstmt_p.setString (7, lot_location);
//out.print("<br>348 lot_location= "+lot_location);
pstmt_p.setString (8,lotcategory_id);	
pstmt_p.setString (9,lotsubcategory_id);	
pstmt_p.setString (10,unit_id);
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	// indicate new diamond-> created_on
pstmt_p.setString (13,reorderquantity);	
pstmt_p.setBoolean (14,true);	

//out.print("<br>248 created on :"+created_on);
pstmt_p.setString(15,""+format.getDate(created_on));	

pstmt_p.setString (16, user_id);	
pstmt_p.setString (17,""+today_date);
pstmt_p.setString (18, user_id);
pstmt_p.setString (19, machine_name);
pstmt_p.setString (20,y_id);
pstmt_p.setBoolean (21,true);	
//out.print("<br>369 befor execute");
 a = pstmt_p.executeUpdate();
out.print("<br>371 After execute");
 out.print("<br>357 <font color=red>Lot Updated a=></font>"+a);
  
  // k_t++;
pstmt_p.close();




//out.print("<br>400y_id= "+y_id);
String query2 = " INSERT INTO Diamond (Lot_Id,Cut_Id,Color_Id,Purity_Id, Fluorescence_Id,Shape_Id,Lab_Id,Polish_Id, TableIncusion_Id,Symmetry_Id,Luster_Id,Country_Id ,Selling_Price,Purchase_Price,Rapnet_Price,Rapnet_Date ,Total_Depth,Table_Perecentage,Crown_Angle,D_Size, Shade_Id,Openinclusion_Id,Blackinclusion_Id,Weight,YearEnd_Id,Diameter,Description_Id,OwnerCategory_Id,Group_Id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?,?, ?,?,?,?, ? )";//26
//out.print("<br>320 query ="+query2);

pstmt_p = conp.prepareStatement(query2);

pstmt_p.setString (1,""+(int_lot_id));		
//out.print("<br>int_lot_id="+int_lot_id);
pstmt_p.setString(2,cut_id);
//out.print("<br>cut_id="+cut_id);
pstmt_p.setString(3,color_id);		
pstmt_p.setString(4,purity_id);

pstmt_p.setString(5,fluorescence_id);		
pstmt_p.setString(6,shape_id);		
pstmt_p.setString(7,lab_id);		
pstmt_p.setString(8,polish_id);	

pstmt_p.setString(9,tableincusion_id);		
pstmt_p.setString(10,symmetry_id);		
pstmt_p.setString(11,luster_id);		
pstmt_p.setString(12,country_id);

if(Compnay_party_id[count].equals(company_id))
{
	pstmt_p.setString(13,Selling_price);
	//System.out.print("<br>Selling_Price="+Selling_price);
	pstmt_p.setString(14,purchase_price);		
}
else
{
	pstmt_p.setString(13,"0");
	//System.out.print("<br>Selling_Price="+Selling_price);
	pstmt_p.setString(14,"0");		
}
pstmt_p.setString(15,"0");		
pstmt_p.setString(16,""+today_date);

pstmt_p.setString(17,total_depth);		
pstmt_p.setString(18,table_per);		
pstmt_p.setString(19,crown_angle);		
pstmt_p.setString(20,size1);		

pstmt_p.setString(21,shade_id);		
pstmt_p.setString(22,openinclusion);		
pstmt_p.setString(23,blackinclusion);		
pstmt_p.setString(24,weight);		
pstmt_p.setString(25,y_id);		
pstmt_p.setString(26,diameter);		
pstmt_p.setString(27,description);
pstmt_p.setString(28,OwnerCategory_Id);
pstmt_p.setString(29,Group_Id);
System.out.println("<br>274 Group_Id="+Group_Id);
 a = pstmt_p.executeUpdate();
out.println("<br>406<font color=red> Diamond  updated=</font>"+a);

pstmt_p.close();
//--------Complete  Diamond Table----------------------

//System.out.println("conp closed=440");
//out.println("<br>408 flag="+flag);
if(flag==true)
{
		double carats = Double.parseDouble(request.getParameter("carats"));


		String currency= request.getParameter("currency");
		String pcs= request.getParameter("diamonds");
		double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
		double rate= Double.parseDouble(request.getParameter("rate"));
		double total= rate * carats;
		double local_price=0;
		double dollar_price=0;
		double local_total=0;
		double dollar_total=0;
		String currency_id="";
		String Location_Id=request.getParameter("Location_Id");


if("local".equals(currency))
	{


		local_price= rate;
		local_total= carats * rate;
		dollar_price = rate / exchange_rate ;
		dollar_total = dollar_price * carats;

		currency_id=I.getLocalCurrency(cong,company_id);


	//out.print("<br>438 currency_id=-"+currency_id);
	
	
	}

else{
		dollar_price= rate;
		dollar_total= carats * rate;
		local_price = rate * exchange_rate ;
		local_total = local_price * carats;
		currency_id="0";
}
//------------------------------------------------------------
		
		//String Loc_id=int_loc_id

			String 	lotlocquery="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id,Active) values(?,?,?,?, ?,?,'"+format.getDate(today_string)+"',? ,?,?,?)";
			pstmt_p = conp.prepareStatement(lotlocquery);
			//out.print("<br> 453 LotLocation query="+lotlocquery);
			pstmt_p.setString (1,""+(int_loc_id));	
	//out.print("<br> ALocation_Id  "+ALocation_Id[i]);
			pstmt_p.setString (2,Compnay_MainLocationId[count]);
			//out.print("<br>474  Location_Id  "+location_id0);

			pstmt_p.setString (3,""+(int_lot_id));	
	//		out.print("<br> Lot_Id  "+Lot_Id);
			//pstmt_p.setString (4,company_id);
			pstmt_p.setString (4,""+Compnay_party_id[count]);
			
			if(Compnay_party_id[count].equals(company_id))
			{
				pstmt_p.setString (5,""+carats);	
				pstmt_p.setString (6, ""+carats);	
			}
			else
			{
				pstmt_p.setString (5,""+0);	
				pstmt_p.setString (6, ""+0);	
			}
			pstmt_p.setString (7, user_id);		
			pstmt_p.setString (8, machine_name);		
			pstmt_p.setString (9,y_id);		
			pstmt_p.setBoolean (10,true);		
			int a435 = pstmt_p.executeUpdate();
			out.print("<br>513 <font color=red> LotLocation updated=</font>="+a435);
			
			pstmt_p.close();



//------------------------------------------------------------


		query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_CurrencyId,Exchange_Rate,Receive_ExchangeRate,Receive_Total,    Local_Total, Dollar_Total, Company_Id,Purchase,    Opening_Stock, Modified_On, Modified_By, Modified_MachineName,   Receive_Quantity , Stock_Date,YearEnd_Id,Active) values (?,?,'"+format.getDate(created_on)+"',? ,?,?,?,? ,?,?,?,?,? ,?, ?,?,?,'"+format.getDate(created_on)+"',?,?)";

		pstmt_p = conp.prepareStatement(query);


			pstmt_p.setString (1,""+(int_receive_id));	
			//out.print("<br>receive_id="+receive_id);
			pstmt_p.setString (2,"OP-"+(int_receive_id));	
			//out.println("<br>2");
			pstmt_p.setString (3, "1");	
			pstmt_p.setString (4,""+currency_id);	
			pstmt_p.setString (5,""+exchange_rate);	
			//out.println("<br>5");

			pstmt_p.setString (6, ""+exchange_rate);	
			pstmt_p.setString (7, ""+total);
			//out.println("<br>7");
			if(Compnay_party_id[count].equals(company_id))
			{
				pstmt_p.setString (8,""+ local_amt);	
				pstmt_p.setString (9, ""+dollar_amt);	
			}
			else
			{
				pstmt_p.setString (8,""+ 0);	
				pstmt_p.setString (9, ""+0);	
			}
			pstmt_p.setString (10, ""+Compnay_party_id[count]);			

			pstmt_p.setBoolean (11,true);	
			pstmt_p.setBoolean (12,true);
			pstmt_p.setString(13,""+today_date);

			//out.print("<br>today_date="+today_date);

			pstmt_p.setString (14,user_id);		
			pstmt_p.setString (15,machine_name);

			if(Compnay_party_id[count].equals(company_id))
			{
				pstmt_p.setString (16, ""+carats);	
			}
			else
			{
				pstmt_p.setString (16, ""+0);	
			}
			pstmt_p.setString (17,y_id);	
			pstmt_p.setBoolean (18,true);	
//out.println("Before Query <br>"+query);

			int a224 = pstmt_p.executeUpdate();
			out.print("<br>510 <font color=red> Receive updated=</font>="+a224);

			pstmt_p.close();


	
//out.println("After Query <br>"+query);
//----------Recive Table Completed -------------------

	//out.print("<br>586 Today_date="+today_date);
	
	
	query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id,       Quantity, Available_Quantity, Receive_Price, Local_Price,    Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive,Location_Id,Pieces,YearEnd_Id,Dollar_Amount,Local_Amount,Active) values (?,?,?,?, ?,?,?,?, ?,'"+today_date+"', ?,? ,?,?,?, ?,?,?,?)";

		pstmt_p = conp.prepareStatement(query);

		//out.print("<br>query="+query);
		//int_rt_id
		//pstmt_p.setString (1,receivetransaction_id);		
		pstmt_p.setString (1,""+(int_rt_id));

		//pstmt_p.setString (2,receive_id);	

		pstmt_p.setString (2,""+(int_receive_id));	

		pstmt_p.setString (3, "1");	

		//pstmt_p.setString (4,lot_id);			
		pstmt_p.setString (4,""+(int_lot_id));

		if(Compnay_party_id[count].equals(company_id))
		{
			pstmt_p.setString (5,""+carats);	
			pstmt_p.setString (6, ""+carats);	

			pstmt_p.setString (7, ""+rate);
			pstmt_p.setString (8,""+local_price);	
			pstmt_p.setString (9, ""+dollar_price);	
		}
		else
		{
			pstmt_p.setString (5,""+0);	
			pstmt_p.setString (6, ""+0);	

			pstmt_p.setString (7, ""+rate);
			pstmt_p.setString (8,""+1);	
			pstmt_p.setString (9, ""+1);	
		}

		pstmt_p.setString (10, user_id);		
		pstmt_p.setString (11, machine_name);		
		pstmt_p.setBoolean (12,true);	
		pstmt_p.setString (13,Compnay_MainLocationId[count]);	
		pstmt_p.setString (14,pcs);	
		pstmt_p.setString (15,y_id);
		if(Compnay_party_id[count].equals(company_id))
		{
			pstmt_p.setString (16,dollar_amt);	
			pstmt_p.setString (17,local_amt);
		}
		else
		{
			pstmt_p.setString (16,"0");	
			pstmt_p.setString (17,"0");
		}
		pstmt_p.setBoolean (18,true);	
		int a245 = pstmt_p.executeUpdate();
		out.print("<br>510 <font color=red> Receive_Transaction updated=</font>="+a245);
		pstmt_p.close();

//-------Receisve Transaction Table is completed ----------
	
		String conpition1=" where Company_Id="+Compnay_party_id[count];
		java.sql.Date from_date = YED.getDate(cong, "YearEnd", "From_Date", conpition1);

		
      //conp2=C.getConnection();
	
	query="Insert into Effective_Rate (EffectiveRate_Id, Lot_Id, Company_Id, Effective_Date, Selling_Price,  Purchase_Price,Modified_On, Modified_By, Modified_MachineName,Active,YearEnd_Id) values (?,?,?,'"+from_date+"', ?,?,'"+today_date+"', ?,?,?,?)";
   // out.print("<br>640 query="+query);
	pstmt_p = conp.prepareStatement(query);
	//out.print("<br>643 query="+query);
	pstmt_p.setString (1,""+(int_effective_id));
	pstmt_p.setString (2,""+(int_lot_id));
	pstmt_p.setString (3, ""+Compnay_party_id[count]);	
	if(Compnay_party_id[count].equals(company_id))
	{
		pstmt_p.setString(4,Selling_price);
		pstmt_p.setString(5,purchase_price);	
	}
	else
	{
		pstmt_p.setString(4,"0");
		pstmt_p.setString(5,"0");	
	}
	/*
	pstmt_p.setString(6,"0");	
	pstmt_p.setString(7,"0");	
	pstmt_p.setString(8,"0");	
	pstmt_p.setString(9,"0");	
	pstmt_p.setString(10,"0");	
	pstmt_p.setString(11,"0");	
	*/
	pstmt_p.setString (6, user_id);	
	pstmt_p.setString (7, machine_name);	
	pstmt_p.setBoolean (8,true);
	pstmt_p.setString (9,y_id);	
	int a2455 = pstmt_p.executeUpdate();
	
	out.print("<br>661 <font color=red> Effective_Rate=</font>="+a2455);
   pstmt_p.close();
	
	//C.returnConnection(conp2);

	////end of insert code of Effective_Rate table
	
	}//end inner if
	
	//out.print("<br>564 k_t=>"+k_t);
	
	

	//System.out.println("After query result a is "+a);

int_lot_id++;
int_loc_id++;
int_receive_id++;
int_rt_id++;
int_effective_id++;
//k_t++;
//out.print("<br> 583 count="+count);
} /////// end of while loop
out.print("<br>662<font color=#0000FF>  adminCount updated=</font>"+adminCount);

conp.commit();
C.returnConnection(cong);
C.returnConnection(cong1);
C.returnConnection(conp);
response.sendRedirect("NewLot.jsp?message=Lot No <font color=blue> "+lot_no+" </font> successfully added");

}
else
{
%>
<html>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body background='../Buttons/BGCOLOR.JPG' >
	<br><center>
	<font class='star1'><b>Lot No <%=lot_no%> already Exist
	</font></b>
	<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
</body>
</html>

	<%
	
	}

}
else
{
	//C.returnConnection(cong);
	//C.returnConnection(conp);
 %> 
<html>
	<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body background='../Buttons/BGCOLOR.JPG' >
	<br><center>
	<font class='star1'><b>Please select proper Description and Size as combination already exist 
	</font></b>
	<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
</body>
</html>
<%
	}//if end


}catch(Exception Samyak45){

conp.rollback();
C.returnConnection(cong1);
C.returnConnection(cong);
C.returnConnection(conp);
//C.returnConnection(conm);
out.println("<br><font color=red><h2> FileName : UpdateLot.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'>");
}



C.returnConnection(cong);
C.returnConnection(cong1);
C.returnConnection(conp);

} 
//if ADD LOT
%>
<!--  code for edit command -->






<%
if("EDIT LOT".equals(command))
{
  
  conp=C.getConnection();
  cong=C.getConnection();

try
	{
String lotno=request.getParameter("lot_no");
int lot_id=11;




String  super_company="select count(*) as MCPCOUNT from Master_CompanyParty where Super=1 and Company=1 and Company_Id=0  and Active=1";
pstmt_g = cong.prepareStatement(super_company);
rs_g = pstmt_g.executeQuery();	
int adminCount=0;
while(rs_g.next())
{
	adminCount=rs_g.getInt("MCPCOUNT");
}
pstmt_g.close();
int adminCount2=adminCount;
String Compnay_party_id[]=new String[adminCount];
String Compnay_MainLocationId[]=new String[adminCount];

super_company="select distinct(CompanyParty_Id) from Master_CompanyParty where Super=1 and Company=1 and Company_Id=0 and Active=1";
pstmt_g = cong.prepareStatement(super_company);
rs_g = pstmt_g.executeQuery();	
int adminCompCount=0;
int count1=0;
while(rs_g.next())
{
Compnay_party_id[count1]=rs_g.getString("CompanyParty_Id");
String MainLocationconpition= " where company_id="+Compnay_party_id[count1]+" and Location_Name='Main' and Active=1";
Compnay_MainLocationId[count1]=A.getNameCondition(cong1, "Master_Location", "Location_Id"," "+MainLocationconpition);
count1=count1+1;
}


///Start of active lot checkbox permission
boolean showActiveCheckbox=true;
String lotActiveQuery="select count(*) as lotIdCount from Lot where Lot_No='"+lotno+"'";
pstmt_g = cong.prepareStatement(lotActiveQuery);
rs_g = pstmt_g.executeQuery();	
int countDiffLots=0;
while(rs_g.next())
{
	countDiffLots=rs_g.getInt("lotIdCount");
}
pstmt_g.close();
//out.print("<br> 767 countDiffLots"+countDiffLots);
String diffLotId[]=new String[countDiffLots];


lotActiveQuery="select Lot_Id from Lot where Lot_No='"+lotno+"'";
pstmt_g = cong.prepareStatement(lotActiveQuery);
rs_g = pstmt_g.executeQuery();	
int k=0;
while(rs_g.next())
{
diffLotId[k]=rs_g.getString("Lot_Id");
k++;
}
pstmt_g.close();

//out.print("<br> 778 k"+k);
double lotGlobalQuantity=0;
double activeLotQty=0;

for (k=0;k<countDiffLots;k++)
{
String lotQuantiyQuery="Select RT.Quantity from Receive R, Receive_Transaction RT where R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+diffLotId[k]+"";
pstmt_g = cong.prepareStatement(lotQuantiyQuery);
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{
activeLotQty=Double.parseDouble(rs_g.getString("Quantity"));

}
pstmt_g.close();
//out.print("<br>791  diffLotId[k]="+diffLotId[k]+" activeLotQty ="+activeLotQty+"");
lotGlobalQuantity=lotGlobalQuantity+activeLotQty;
}
//out.print("<br> 800 lotGlobalQuantity="+lotGlobalQuantity);
if (lotGlobalQuantity >0)
{
showActiveCheckbox=false;
}

///end of active lot checkbox permission


int lotcategory_id=0;//[]=new int[adminCount];
int lot_id1=0;//new int[adminCount];
String location_new="";//new String[adminCount];

int index=count1;
String query11="Select *  from  Lot where Lot_No='"+lotno+"'  and  Company_Id="+company_id;//[index];

pstmt_p = conp.prepareStatement(query11);
rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
   lotcategory_id=Integer.parseInt(rs_g.getString("LotCategory_Id"));
	lot_id1=Integer.parseInt(rs_g.getString("Lot_Id"));
    location_new=rs_g.getString("Lot_Location");
	//out.print("<br>lot_id "+lot_id1);
	//out.print("<br>LotCategory_Id "+lotcategory_id);
	//out.print("<br>company_id "+company_id);
	}
 	pstmt_p.close();
	
	String Loc_id_new=A.getNameCondition(conp,"LotLocation","Location_Id"," where Lot_Id="+lot_id1);
	
if(lot_id1 > 0)
{
String us_rate1="";
String dollar_amt1="";
double dollar_amt11=0;
double local_amt11=0;
String local_amt1="";
String exec_rate="";
double exec_rate1=0;
String qtys="";
double qtys1=0;
String location_id_1="";
//"Select R.Receive_Id,RT.ReceiveTransaction_Id from Receive R, Receive_Transaction RT where R.Purchase=1 and R.Receive_Sell=1 and R.R_Return=0 and R.StockTransfer_Type=0 and R.Receive_id=RT.Receive_Id and R.Opening_Stock=1 and  RT.Lot_Id="+templot_id+"and RT.Location_Id="+location_id0+" and R.company_id="+company_id;


String new_query="Select R.Dollar_Total as rd,R.Local_Total as rl,R.Receive_ExchangeRate as rexec,R.Receive_Quantity as rqty,RT.Location_Id as rtlocid  from Receive R, Receive_Transaction RT where R.Purchase=1 and R.Receive_Sell=1 and R.R_Return=0 and R.StockTransfer_Type=0 and R.Receive_id=RT.Receive_Id and  R.Opening_Stock=1 and   RT.Lot_Id="+lot_id1+" and R.company_id="+company_id;
pstmt_p = conp.prepareStatement(new_query);
rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
{
dollar_amt11=rs_g.getDouble("rd");
//out.print("<br>882 dollar_amt1="+dollar_amt1);

local_amt11=rs_g.getDouble("rl");
exec_rate1=rs_g.getDouble("rexec");
qtys1=rs_g.getDouble("rqty");
location_id_1=rs_g.getString("rtlocid");
}
pstmt_p.close();


double rate_new=dollar_amt11/qtys1;

if(Double.isNaN(rate_new) || Double.isInfinite(rate_new))
		rate_new = 0;

String str_rate1=""+rate_new;
String str_rate=str.mathformat(""+rate_new,3);
 us_rate1=str.mathformat(""+rate_new,3);

//out.print("<br> 871 us_rate1 "+us_rate1);
dollar_amt1=str.mathformat(""+dollar_amt11,3);
//out.print("<br> 871 dollar_amt1 "+dollar_amt1);
exec_rate=str.mathformat(""+exec_rate1,3);
local_amt1=str.mathformat(""+local_amt11,3);
qtys=str.mathformat(""+qtys1,3);

%>
<html>
<title> Edit Lot No</title>
<head>

	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<SCRIPT LANGUAGE="JavaScript" src="Scripting.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakcalendar.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakdate.js">
	</SCRIPT>
	<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
	<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
	</script>
	<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>


<SCRIPT LANGUAGE="JavaScript">
<%
String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
	pstmt_p = conp.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
	String lotNoArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\"";
		}
		else
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\",";
		}
	}
	pstmt_p.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");


%>

<!--
function tb(str)
{
window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=no"])
}
//-->

function tbnew(str)
{
window.open(str,"_blank", ["Top=70","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=400","Width=500", "Resizable=yes","Scrollbars=yes","status=no"])
}


function calcTotal(name)
{
//validate(name)
//if("dollar".equals(currency)

//if(


//alert ("Ok Inside CalcTotal");
//alert ("This is Dollar Amt.");
document.mainform.dollar_amt.value=(document.mainform.carats.value*document.mainform.rate.value);

var tempDollarValue = parseFloat(document.mainform.dollar_amt.value);
tempDollarValue = tempDollarValue.toFixed(<%=d%>);
document.mainform.dollar_amt.value = tempDollarValue;
//alert("After Dollar calculation");

//alert ("This is Local Amt.");

document.mainform.local_amt.value=(document.mainform.carats.value*document.mainform.rate.value)*(document.mainform.exchange_rate.value);
//alert("After Local calculation");

var tempLocalValue = parseFloat(document.mainform.local_amt.value);
tempLocalValue = tempLocalValue.toFixed(<%=d%>);
document.mainform.local_amt.value = tempLocalValue;

if(document.mainform.rate.value=="0"){
	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

if(document.mainform.test_amt.value != ((document.mainform.carats.value)*(document.mainform.rate.value)))
{
if(document.mainform.test_amt.value > ((document.mainform.carats.value)*(document.mainform.rate.value)))
{	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

else{
document.mainform.test_amt.value=document.mainform.carats.value*document.mainform.rate.value;}
}//if
}

function show()
{
	var el = document.getElementById("info_span1");
	if(document.mainform.specification.checked)
	{
		el.style.display="block";
	}
	else
	{
		el.style.display="none";
	}
	
	
}

</SCRIPT>

</head>

<%

String query="";
//conp=C.getConnection();
//out.print("<br>1039 lot_id1="+lot_id1);
//query="Select *  from  Diamond where Lot_Id="+lot_id;
query="Select *  from  Diamond where Lot_Id="+lot_id1;
//out.print(query);
		pstmt_p = conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();
//out.print("<br>755 lot_id1="+lot_id1);
String cut_id=""; 
String color_id=""; 
String purity_id=""; 
String fluorescence_id=""; 
String shape_id=""; 
String lab_id=""; 
String polish_id=""; 
String tableincusion_id=""; 
String symmetry_id=""; 
String luster_id=""; 
String lot_description=""; 
String lot_location=""; 
double total_depth=0;
double crown_angle=0;
double table_per= 0;
String size_id= "";
String country_id= "";
String shade_id= "";
String blackinclusion= "";
String openinclusion= "";
double weight= 0;
double purchase_price= 0;
double selling_price= 0;
String diameter="";
String Description_Id="";
String Group_Id="";
String OwnerCategory_Id="";

//String filename = "";
	
while(rs_g.next()) 	
	{

cut_id=rs_g.getString("cut_id");
//out.print(cut_id);
	
color_id=rs_g.getString("color_id");
purity_id=rs_g.getString("purity_id");
fluorescence_id= rs_g.getString("fluorescence_id");
shape_id=rs_g.getString("shape_id");
//out.print("<br>893 shape_id=>"+shape_id);

lab_id=rs_g.getString("lab_id");
polish_id=rs_g.getString("polish_id");
tableincusion_id= rs_g.getString("tableincusion_id");
symmetry_id=rs_g.getString("symmetry_id");
luster_id=rs_g.getString("luster_id");

country_id=rs_g.getString("country_id");

total_depth= rs_g.getDouble("Total_Depth");
crown_angle= rs_g.getDouble("Crown_Angle");
table_per= rs_g.getDouble("Table_Perecentage");

shade_id= rs_g.getString("Shade_Id");
blackinclusion= rs_g.getString("Blackinclusion_Id");
openinclusion= rs_g.getString("Openinclusion_Id");
/************ get description and  size  */
Description_Id= rs_g.getString("Description_Id");
size_id= rs_g.getString("D_Size");
/************ get description  and  size */
//out.print("<br>1106 size_id="+size_id);

selling_price= rs_g.getDouble("Selling_Price");
purchase_price= rs_g.getDouble("Purchase_Price");
weight= rs_g.getDouble("Weight");
//out.print("<br>1014 weight"+weight);
diameter= rs_g.getString("Diameter");
//out.print("<br>1015diameter"+diameter);
Group_Id= rs_g.getString("Group_Id");
//out.print("<br>1114 Group_Id="+Group_Id);

OwnerCategory_Id= rs_g.getString("OwnerCategory_Id");

if(rs_g.wasNull())
	diameter="0";
}//end while

pstmt_p.close();

//C.returnConnection(conp);
double reorderquantity=0;
String Lot_No="";
String Lot_Name="";
String Lot_Description="";
String Lot_Referance="";
String Lot_Location="";
String Lot_Active="";
String tempCheck="";
String description="";

query="Select *  from  Lot where Lot_Id="+lot_id1;
	
//out.print("<br> 182="+query);
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
	{
	reorderquantity= rs_g.getDouble("ReorderQuantity");
	//out.print("<br> reorderquantity="+reorderquantity);
	Lot_No= rs_g.getString("Lot_No");
	//out.print("<br> Lot_No="+Lot_No);
	Lot_Name= rs_g.getString("Lot_Name");
	//out.print("<br> Lot_Name="+Lot_Name);
	Lot_Referance= rs_g.getString("Lot_Referance");
	if(rs_g.wasNull())
	Lot_Referance="";
	//out.print("<br> Lot_Referance="+Lot_Referance);
	Lot_Location= rs_g.getString("Lot_Location");
	//out.print("<br> Lot_Location="+Lot_Location);
	Lot_Active=rs_g.getString("Active");
//	out.print("<br>1011 Lot_Active:"+Lot_Active);
		if("1".equals(Lot_Active))
		{tempCheck = " checked " ;}
	}
pstmt_p.close();

	String lot_no1=A.getNameCondition(conp,"Lot","Lot_No"," where Lot_Id="+lot_id); %>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='show();document.mainform.lot_no.select();'>
<form action="UpdateLot.jsp" method=post name=mainform>
<table align=center bordercolor="skyblue" border=1 cellspacing=0 cellpadding=2 width='100%' >
<tr><td>
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<%
int dd1=from_date_new.getDate();
int mm1=(from_date_new.getMonth()+1);
int yy1=(from_date_new.getYear()+1900);

int dd2=to_date_new.getDate();
int mm2=(to_date_new.getMonth()+1);
int yy2=(to_date_new.getYear()+1900);
%>
<tr bgcolor="skyblue">
<th colspan=6>
	Edit Lot No.<a href="../Report/LotHistoryNew.jsp?dd1=<%=dd1%>&mm1=<%=mm1%>&yy1=<%=yy1%>&dd2=<%=dd2%>&mm2=<%=mm2%>&yy2=<%=yy2%>&lotno=<%=Lot_No%>&remark=yes&due_date=yes&fcq=yes&currencyin=Both&command=HISTORY" target="_blank"><%=Lot_No%></a>
</th>  
</tr>

<tr>
	<td>&nbsp;</td>
	<td>No<font value='<%=Lot_No%>' class="star1">*</font></td>
	<td colspan=2>

	
		<input type=text name=lot_no id=lot_no size=10 align=left value='<%=Lot_No%>' autocomplete=off align=left>
	</td>
		<input type=hidden  name=old_lot_no size=30 value='<%=Lot_No%>'>
		<script language="javascript">

			var lobj = new  actb(document.getElementById('lot_no'), lotNoArray);
			
		</script>	
	<input type=hidden name=templot_id size=30 value='<%=lot_id1%>'>

<script language='javascript'>
	
</script> 
		<input type=hidden name='datevalue' size=6 maxlength=10 value="07/09/2005" onblur='return  fnCheckDate(this.value,"Date")'>	
		<input type=hidden name=datevalue1 value="31/03/2004">	
	
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>


<tr>
<td >Description<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Description')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
</td>
<td>
<%=A.getMasterArray(conp,"Description","Description_Id\' style=\'width:120 ",Description_Id) %>
</td>
<td>
Size
<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Size')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
</td>
<td>
<%=A.getMasterArray(conp,"Size","size_id\' style=\'width:120",size_id) %></td>

</td>
<td >Group
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Group')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
</td>
<td>
	<%=A.getMasterArray(conp,"Group","Group_Id\' style=\'width:120",Group_Id) %>
</td>	
	
</tr>
<INPUT type=hidden name=lot_location size=30 value="Main"> 

<Input type="hidden" name="selling_price" value='<%=str.mathformat(""+selling_price,2)%>' style="text-align:right" size=7>

<Input type="hidden" name="purchase_price" style="text-align:right" value='<%=str.mathformat(""+purchase_price,2)%>' size=7>
<tr>
	<td>
	Owner Category<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=OwnerCategory')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
	</td>
	<td>
	<%=A.getMasterArray(conp,"OwnerCategory","OwnerCategory_Id\' style=\'width:120",OwnerCategory_Id) %>
	</td>
	<td>Shape
		<a	href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Shape')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
		<%=A.getMasterArray(conp,"shape","shape_id\' style=\'width:120",shape_id)%>
	</td>
	<td>Cut
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Cut')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
		<%=A.getMasterArray(conp,"cut","cut_id\' style=\'width:120",cut_id)%>
	</td>
</tr>

<tr>
	<td>Color
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Color')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
	<%=A.getMasterArray(conp,"color","color_id\' style=\'width:120",color_id) %>
	</td>
	<td>Purity (Clarity)
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Purity')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
		<%=A.getMasterArray(conp,"purity","purity_id\' style=\'width:120",purity_id) %>
	</td>

	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>

<tr><td colspan=6>
<table border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=6 align="center"><b>Opening Stock Details</b> <Input type=checkbox name=os value=yes checked OnClick='this.checked=true'><b> Check Here
</th>	
</tr>

<tr>
<td align="left">Exchange Rate/$ <font class="star1">*</font></td>
<td><input type=text  name=exchange_rate value='<%=exec_rate%>' size=7 align ="left" onblur='validate(this,3)' style="text-align:right" >
</td>
	

<td>Location</td><td> Main </td>
<input type=hidden name=location_id0 value="<%=A.getNameCondition(conp,"Master_Location","Location_Id","where company_id="+company_id+"and location_name='Main' and Active=1")%>">


<td>Quantiy (Carats)<font class="star1">*</font></td>
<td><input type= text name=carats size=7 style="text-align:right" value='<%=qtys%>'   OnBlur='validate(this,3)'>
</td>
</tr>

<tr>
<td>Rate/Unit(US-$)</td>
<td><input type=text name=rate value='<%=us_rate1%>' size=7 style="text-align:right"  OnBlur='return calcTotal(this)'> 
</td>

<td colspan=1>Amount(US-$)</td>
<td><input type=text name=dollar_amt value=<%=dollar_amt1%>  size=10 style="text-align:right"  OnBlur='return calcTotal(this)'>
</td>

<td colspan=1>Amount(<%=local_symbol%>)</td>
<td><input type=text name=local_amt value="<%=local_amt1%>"  size=10 style="text-align:right" OnBlur='return calcTotal(this)'>
</td>
</tr>

<input type=hidden name=test_amt value="0"  size=10 style="text-align:right">

<tr>
<th colspan=6 align=center bgcolor=skyblue >Specifications&nbsp;<Input type=checkbox name=specification  OnClick='show();'><b> Check Here</th>
</tr>

<tr>
<td colspan=6>
<span id="info_span1">
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr>
<td>Diameter</td>
<td><input type=text name=diameter value="<%=str.mathformat(""+diameter,3)%>" size=7 style="text-align:right" onblur='validate(this,3)' >
</td>


<td>Weight</td>
<td><input type=text name=weight value='<%=str.mathformat(""+weight,2)%>' size=7 style="text-align:right" onblur='validate(this,3)'>
</td>
<td>Flourescene
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Fluorescence')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
</td>
<td><%=A.getMasterArray(conp,"Fluorescence","fluorescence_id\' style=\'width:120",fluorescence_id)%>
</td>
</tr>

<tr>
<td>Lab
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Lab')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
</td>
<td><%=A.getMasterArray(conp,"Lab","lab_id\' style=\'width:120",lab_id) %>
</td>

<td>Polish
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Polish')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
</td>
<td><%=A.getMasterArray(conp,"polish","polish_id\' style=\'width:120",polish_id)%>
</td>

<td>Symmetry
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=symmetry')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
</td>
<td><%=A.getMasterArray(conp,"symmetry","symmetry_id\' style=\'width:120",symmetry_id) %>
</td>
</tr>
<tr>
	<td >Table  Incusion
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=TableIncusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>	<%=A.getMasterArray(conp,"TableIncusion","tableincusion_id\' style=\'width:120",tableincusion_id) %>
	</td>


	<td>Luster
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=luster')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	</td><td><%=A.getMasterArray(conp,"luster","luster_id\' style=\'width:120",luster_id) %>
	</td>

	<td >Country Of Origin
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Country')"><img src="../Buttons/add.jpg" height="10" width="10">
		</a>
	</td>
	<td>
	<%=A.getMasterArraySrNo(conp,"Country","country_id\' style=\'width:120",country_id) %>
	</td>

	
</tr>
<tr>
	<td >Shade
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Shade')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
		<%=A.getMasterArray(conp,"Shade","shade_id\' style=\'width:120",shade_id) %>
	</td>

	<td>Black Inclusion
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Blackinclusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td><%=A.getMasterArray(conp,"Blackinclusion","blackinclusion\' style=\'width:120",blackinclusion) %>
	</td>
	
	<td colspan=1>Open Inclusion
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Openinclusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	</td>
	<td>
	 <%=A.getMasterArray(conp,"Openinclusion","openinclusion\' style=\'width:120",openinclusion) %> 
	</td>
</tr>

</table>
</span>

<tr>
<td colspan=6 align=center bgcolor=skyblue>
<%
if(showActiveCheckbox)
	{
%>
<B>Active Lot
</B><input type=checkbox name=activeLot value=yes <%=tempCheck%>>
<% }
else 
	{ %>	<B>Quantity Present</B>
<input type=hidden name=activeLot value=yes>

<% } //else
%>
</td>
</tr>
</td>

</tr>



<%

int lot_id_new=0;
String str1="select lot_id from Lot where lot_no='"+lotno+"' and company_id="+company_id;

pstmt_g = cong.prepareStatement(str1);
rs_g = pstmt_g.executeQuery();	

while(rs_g.next())
{
	lot_id_new=rs_g.getInt("lot_id");
}
pstmt_g.close();
//out.println("1455 "+str.mathformat("1234.3456",2));

HashMap lot_history=LHB.getSalePurchaseMixInOut(cong,""+lot_id_new,from_date_new,to_date_new,company_id,yearend_id);
%>
<tr>
	<td colspan=3>
		<table  border=1 style='border:1px solid #000000'>
		<tr>
			<th >&nbsp;</th>
			<th >Carats</th>
			<th >Amount(HKD)</th>
			<th >Amount($)</th>
		</tr>
		
		<tr>
			<th>Opening</th>
			<td style='text-align:right'><%=str.format(""+qtys,3)%></td>
			<td style='text-align:right'><%=str.format(""+local_amt1,d)%></td>
			<td style='text-align:right'><%=str.format(""+dollar_amt1,usDlr)%></td>
		</tr>
		<%
			LotHistoryRow purchase_row=(LotHistoryRow)lot_history.get("Purchase");
				
		%>
		
		<%
		LotHistoryRow mix_in_row=(LotHistoryRow)lot_history.get("Mix In");
		%>
		<tr><th>Total In </th><td style='text-align:right'><%=str.format(""+(purchase_row.getQty()+mix_in_row.getQty()),3)%></td><td style='text-align:right'><%=str.format(""+(mix_in_row.getLocalAmount()+purchase_row.getLocalAmount()),d)%></td><td style='text-align:right'><%=str.format(""+(mix_in_row.getDollarAmount()+purchase_row.getDollarAmount()),usDlr)%></td></tr>
		
		<%
		LotHistoryRow sale_row=(LotHistoryRow)lot_history.get("Sale");
		%>

		
		
		<%
		LotHistoryRow mix_out_row=(LotHistoryRow)lot_history.get("Mix Out");
		%>

		<tr><th>Total Out </th><td style='text-align:right'><%=str.format(""+(mix_out_row.getQty()+sale_row.getQty()),3)%></td><td style='text-align:right'><%=str.format(""+(mix_out_row.getLocalAmount()+sale_row.getLocalAmount()),d)%></td><td style='text-align:right'><%=str.format(""+(mix_out_row.getDollarAmount()+sale_row.getDollarAmount()),usDlr)%></tr>
		
		<%
		double closing_qty=Double.parseDouble(qtys)+(purchase_row.getQty()+mix_in_row.getQty())-(sale_row.getQty()+mix_out_row.getQty());
		double closing_local_amount=Double.parseDouble(local_amt1)+(purchase_row.getLocalAmount()+mix_in_row.getLocalAmount())-(sale_row.getLocalAmount()+mix_out_row.getLocalAmount());
		double closing_dollar_amount=Double.parseDouble(dollar_amt1)+(purchase_row.getDollarAmount()+mix_in_row.getDollarAmount())-(sale_row.getDollarAmount()+mix_out_row.getDollarAmount());
		%>
		
		<tr><th>Closing </th><td style='text-align:right'><%=str.format(""+closing_qty,3)%></td><td style='text-align:right'><%=str.format(""+closing_local_amount,d)%></td><td style='text-align:right'><%=str.format(""+closing_dollar_amount,usDlr)%></td>
		</tr>	  
		</table>
	</td>
	<%
	double localPurchaseRate = S.lotRate(cong, lot_id_new, "0", to_date_new, company_id, yearend_id, "local", "PurchaseRate");
	
	double dollarPurchaseRate = S.lotRate(cong, lot_id_new, "0", to_date_new, company_id, yearend_id, "dollar", "PurchaseRate");

	double localAvgPurchaseRate = S.lotRate(cong, lot_id_new, "0", to_date_new, company_id, yearend_id, "local", "AvgPur");

	double dollarAvgPurchaseRate = S.lotRate(cong, lot_id_new, "0", to_date_new, company_id, yearend_id, "dollar", "AvgPur");
	
	%>	
		<td colspan=3 valign='top'>
		<table border=1 style='border:1px solid #000000'>
		<tr><th>&nbsp;</th><th>Rate(<%=local_symbol%>)</th><th>Rate($)</th></tr>
		<tr><th>Effective Market Price </th><td style='text-align:right'><%=str.format(""+localPurchaseRate,d)%></td><td style='text-align:right'><%=str.format(""+dollarPurchaseRate,usDlr)%></td></tr>

		<tr><th>Average Purchase Price  </th><td style='text-align:right'><%=str.format(""+localAvgPurchaseRate,d)%></td><td style='text-align:right'><%=str.format(""+dollarAvgPurchaseRate,usDlr)%></td></tr>

		</table>
		</td>
		</tr>
		<tr>
		<th  colspan=6 >
		<input type=submit  name=command  value='Update' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
		</th>
		</tr>
</table>


</table>

</form>
</body>
</html>

<%

}//if lotexist
else

		{
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG'> <br><center><font class='message1'><b> Lot No <font color=blue>"+lotno+"</font> doesnot exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
		
		}
}catch(Exception e31)
{ 
C.returnConnection(conp);
out.println("<font color=red> FileName : EditLot.jsp<br>Bug No e31 : "+ e31);
}



//}

//else{
%>


<SCRIPT LANGUAGE="JavaScript">
//alert("Lot doesn,t present");
</SCRIPT>
	<%
//C.returnConnection(conp);
//C.returnConnection(cong);

//response.sendRedirect("NewLot.jsp?message=Lot No <font color=blue> "+lotno+" </font>Cannot be  Exist");


//}



C.returnConnection(conp);
C.returnConnection(cong);

}/// end of if (Properties)


if("Update".equals(command))
{   

	String samyakErrorLine=""+1727;
	cong=C.getConnection();
	conp=C.getConnection();
try
{

String lot_no= request.getParameter("lot_no");
String old_lot_no= request.getParameter("old_lot_no");
int templot_id=Integer.parseInt(request.getParameter("templot_id"));
String size=request.getParameter("size_id");
String Group_Id=request.getParameter("Group_Id");
String OwnerCategory_Id=request.getParameter("OwnerCategory_Id");
//System.out.println(" 1472 Group_Id="+Group_Id);
String size_id=size;
//System.out.println(" 1465 size_id="+size_id);

String location_id0=request.getParameter("location_id0");
out.println("location_id0="+location_id0);
String desc_id=request.getParameter("Description_Id");
String lot_description=desc_id;


double carats = Double.parseDouble(request.getParameter("carats"));
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));

double rate= Double.parseDouble(request.getParameter("rate"));
double dollar_price=rate;
double local_price=rate*exchange_rate;

double total= rate * carats;
double local_total=total*exchange_rate;
double dollar_total=total;



samyakErrorLine="1741";
String lotNoExistQuery="Select Lot_Id from Lot where Lot_No=? AND Lot_Id!=? and company_id="+company_id+"";

pstmt_g = cong.prepareStatement(lotNoExistQuery);
pstmt_g.setString (1,lot_no);
pstmt_g.setString (2,""+templot_id);

int otherLotNo=0;
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{otherLotNo++;}
pstmt_g.close();

samyakErrorLine="1754";
String descSizeExistQuery="Select L.Lot_Id from Lot L, Diamond D where D.D_Size=? and D.Description_Id=? and L.Lot_Id<>? and company_id="+company_id+" and L.Lot_Id=D.Lot_Id";


pstmt_g = cong.prepareStatement(descSizeExistQuery);
pstmt_g.setString (1,size_id);
pstmt_g.setString (2,desc_id);
pstmt_g.setString (3,""+templot_id);

int otherDescSizeNo=0;
rs_g = pstmt_g.executeQuery();	
samyakErrorLine="1765";
while(rs_g.next())
{otherDescSizeNo++;}
pstmt_g.close();


///Lock removed for same desc and size so kept otherDescSizeNo value =0;

otherDescSizeNo=0;

///



//out.print("1765 otherLotNo"+otherLotNo);
//out.print("1766 otherDescSizeNo"+otherDescSizeNo);
if( (otherLotNo < 1) && (otherDescSizeNo < 1))	
{

String lot_reference= request.getParameter("lot_reference");
//out.print("<br>1776 Inside (otherLotNo < 1) && (otherDescSizeNo < 1)");
String dia=request.getParameter("diameter");
//out.print("<br> 475 Dia"+dia );
double diameter=Double.parseDouble(dia);
//out.print("<br> 477 Dia"+diameter);

String dep=request.getParameter("total_depth");
//out.print("<br> Total Depth"+dep);
double Total_Depth=0;//Double.parseDouble(dep);
//out.print("<br>Total Depth"+Total_Depth);

String per=request.getParameter("table_per");
double table_per=0;//Double.parseDouble(per);
//out.print("<br>Table Percentege"+table_per);

String angle=request.getParameter("crown_angle");
//out.print("<br> Total Depth"+dep);
double Crown_Angle=0;//Double.parseDouble(angle);
//out.print("<br>Total Depth"+Crown_Angle);

String quantity=request.getParameter("reorderquantity");
//out.print("<br> Total Depth"+quantity);
double reorderquantity=0;//Double.parseDouble(quantity);
//out.print("<br>Reorder Quantity"+reorderquantity);

String pprice=request.getParameter("purchase_price");
//out.print("<br> Total Depth"+pprice);
double Purchase_Price =Double.parseDouble(pprice);
//out.print("<br>Purchase Price"+Purchase_Price);

String sprice=request.getParameter("selling_price");
//out.print("<br> Total Depth"+ sprice);
double Selling_Price=Double.parseDouble(sprice);
//out.print("<br>Selling Price"+Selling_Price);

String nweight=request.getParameter("weight");
//out.print("<br> Total Depth"+nweight);
double Weight=Double.parseDouble(nweight);
//out.print("<br>Weight"+Weight);


String shape=request.getParameter("shape_id");
//out.print("<br> Shape"+shape);
String color=request.getParameter("color_id");
//out.print("<br> Color"+color);

String purity=request.getParameter("purity_id");
//out.print("<br> Purity"+purity);
String cut=request.getParameter("cut_id");
//out.print("<br> Cut"+cut);
String fluorescence=request.getParameter("fluorescence_id");
//out.print("<br> Fluorescence"+fluorescence);
String lab=request.getParameter("lab_id");
//out.print("<br> Lab"+lab);
String polish=request.getParameter("polish_id");
//out.print("<br> Polish"+polish);


String symmetry=request.getParameter("symmetry_id");
//out.print("<br>Symmetry"+symmetry);
String tableincusion=request.getParameter("tableincusion_id");
//out.print("<br> Tableincusion"+tableincusion);
String luster=request.getParameter("luster_id");
//out.print("<br>Luster"+luster);
String country=request.getParameter("country_id");
//out.print("<br> Country"+country);
String shade=request.getParameter("shade_id");
//out.print("<br> Shade"+shade);


String blackinclusion=request.getParameter("blackinclusion");
//out.print("<br> Blackinclusion"+blackinclusion);
String openinclusion=request.getParameter("openinclusion");

String activeLot=request.getParameter("activeLot");
boolean activeFlag =false; 
if("yes".equals(activeLot)){activeFlag=true;}
out.print("<br> 1435 activeFlag ="+activeFlag);

		int id_count=0;
		String count1_query="select count(*) as tot  from Lot L,Master_CompanyParty M where L.Lot_No='"+old_lot_no+"' and M.Super=1 and M.Company=1 and M.Company_Id=0 and L.Company_Id=M.CompanyParty_Id and M.Active=1";
		pstmt_g = cong.prepareStatement(count1_query);
		rs_g = pstmt_g.executeQuery();	
	
	while(rs_g.next())
	{
      id_count=rs_g.getInt(1);
     // out.print("<br>1776 id_count="+id_count);
	}
	pstmt_g.close();

int index=id_count;
//out.print("<br>1781 id_count="+id_count);

String lot_sec_id[]=new String[index];
String company_sec_id[]=new String[index];

count1_query="select L.Lot_Id as LotTD,M.CompanyParty_Id  as MCompanyId from Lot L,Master_CompanyParty M where L.Lot_No='"+old_lot_no+"' and M.Super=1 and M.Company=1 and M.Company_Id=0 and L.Company_Id=M.CompanyParty_Id";
	pstmt_g = cong.prepareStatement(count1_query);
	rs_g = pstmt_g.executeQuery();	
	int kb=0;
	while(rs_g.next())
	
	{
         lot_sec_id[kb]=rs_g.getString("LotTD");
         company_sec_id[kb]=rs_g.getString("MCompanyId");
		 kb++;
	}
	pstmt_g.close();



//out.print("<br>1774<font color=red>Description_Id=</font>"+desc_id);



//out.print("<br>comapny_name="+company_name);
out.print("<br> 467 lot description"+lot_description);
String query="";
for(int h=0; h<id_count;h++)
	{
query="Update Lot set Lot_No=?, Lot_Name=?, Lot_Description=?,  Lot_Referance=?, ReorderQuantity=?, Active=? where Lot_Id=?";
	
	out.print("<br> 1731 = "+query);
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString (1,lot_no);
	pstmt_p.setString (2,lot_no);
	pstmt_p.setString (3,lot_sec_id[h]);
	pstmt_p.setString (4,lot_reference);
	pstmt_p.setDouble(5,reorderquantity);
	pstmt_p.setBoolean(6,activeFlag);
	pstmt_p.setString(7,lot_sec_id[h]);
	
	out.print("<br> 1490 activeFlag ="+activeFlag);
	int a = pstmt_p.executeUpdate();
	out.print("<br> 1250 Updated Sucessfully In Lot Table"+a);
			
	pstmt_p.close();
	//C.returnConnection(conp);

String newquery="";
newquery="Update Diamond set Total_Depth=?,Table_Perecentage=?,Crown_Angle=?,Purchase_Price=?,Selling_Price=?,Weight=?,D_Size=?,Shape_Id=?,Color_Id=?,Purity_Id=?,Cut_Id=?,Fluorescence_Id=?,Lab_Id=?,Polish_Id=?,Symmetry_Id=?,TableIncusion_Id=?,Luster_Id=?,Country_Id=?,Shade_Id=?,Blackinclusion_Id=?,Openinclusion_Id=?,Diameter=?,Description_Id=?,Group_Id=?,OwnerCategory_Id=? where Lot_Id=?";  

	//out.print("<br> 569="+query);
	pstmt_p = conp.prepareStatement(newquery);
	pstmt_p.setDouble (1,Total_Depth);
	pstmt_p.setDouble (2,table_per);
	pstmt_p.setDouble (3,Crown_Angle);
	pstmt_p.setDouble (4,Purchase_Price);
	pstmt_p.setDouble (5,Selling_Price);
	pstmt_p.setDouble (6,Weight);
	pstmt_p.setString (7,size);
	pstmt_p.setString (8,shape);
	pstmt_p.setString (9,color);
	pstmt_p.setString (10,purity);
	pstmt_p.setString (11,cut);
	pstmt_p.setString (12,fluorescence);
	pstmt_p.setString (13,lab);
	pstmt_p.setString (14,polish);
	pstmt_p.setString (15,symmetry);
	pstmt_p.setString (16,tableincusion);
	pstmt_p.setString (17,luster);
	pstmt_p.setString (18,country);
	pstmt_p.setString (19,shade);
	pstmt_p.setString (20,blackinclusion);
	pstmt_p.setString (21,openinclusion);
	pstmt_p.setDouble (22,diameter);
	pstmt_p.setString (23,desc_id);
	pstmt_p.setString(24,Group_Id);
	pstmt_p.setString(25,OwnerCategory_Id);
	pstmt_p.setString(26,lot_sec_id[h]);
	int b = pstmt_p.executeUpdate();
	pstmt_p.close();
	out.print("<br> 572 Updated Sucessfully In Dimand Table"+b);
	//C.returnConnection(conp);
	//C.returnConnection(conm);
}//for loop


//opening stock Updation

String openStockQuery="Select R.Receive_Id,RT.ReceiveTransaction_Id from Receive R, Receive_Transaction RT where R.Purchase=1 and R.Receive_Sell=1 and R.R_Return=0 and R.StockTransfer_Type=0 and R.Receive_id=RT.Receive_Id and R.Opening_Stock=1 and  RT.Lot_Id="+templot_id+" and RT.Location_Id="+location_id0+" and R.company_id="+company_id;
out.print("<br>1718 location_id0="+location_id0);
pstmt_g = cong.prepareStatement(openStockQuery);


out.print("<br>1543 templot_id="+templot_id);
out.print("<br>1544 Before query openStockQuery="+openStockQuery);
rs_g = pstmt_g.executeQuery();
out.print("<br>1546 After query");
String Receive_Id="";
String ReceiveTransaction_Id="";

	while(rs_g.next()) 	
{
  Receive_Id=rs_g.getString("Receive_Id");
  out.print("<br> 1553 Receive_Id"+Receive_Id);
  ReceiveTransaction_Id=rs_g.getString("ReceiveTransaction_Id");
  out.print("<br> 1555 ReceiveTransaction_Id"+ReceiveTransaction_Id);

}
pstmt_p.close();


out.print("<br> 1561 test= ");
query="Update Receive set Receive_Quantity=?,Exchange_Rate=?,Receive_ExchangeRate=?,Receive_Total=?,Local_Total=?, Dollar_Total=?  where Receive_Id=?";
	
out.print("<br> 1731 = "+query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+carats);
pstmt_p.setString (2,""+exchange_rate);
pstmt_p.setString (3,""+exchange_rate);
pstmt_p.setString (4,""+total);
pstmt_p.setString (5,""+local_total);
pstmt_p.setString (6,""+total);
pstmt_p.setString (7,Receive_Id);
int R_int = pstmt_p.executeUpdate();
out.print("<br> 1628 R_int"+R_int);
pstmt_p.close();



query="Update Receive_Transaction set Quantity=?, Available_Quantity=?, Receive_Price=?, Local_Price=?, Dollar_Price=?, Local_Amount=?, Dollar_Amount=?  where ReceiveTransaction_Id=?";
	
out.print("<br> 1731 = "+query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+carats);
pstmt_p.setString (2,""+carats);
pstmt_p.setString (3,""+rate);
pstmt_p.setString (4,""+(rate*exchange_rate));
pstmt_p.setString (5,""+rate);
pstmt_p.setString (6,""+local_total);
pstmt_p.setString (7,""+total);
pstmt_p.setString (8,""+ReceiveTransaction_Id);
int RT_int = pstmt_p.executeUpdate();
out.print("<br> 1642 RT_int"+RT_int);
pstmt_p.close();

	//out.print("<br> 569="+query);


///



C.returnConnection(conp);
response.sendRedirect("NewLot.jsp?message=Lot No <font color=blue> "+lot_no+" </font>successfully Updated");     
out.print("<br>1594  all Successfull");	 

}//if otherLotNo

else
{
		C.returnConnection(conp);
		C.returnConnection(cong);

if ( (otherLotNo>0) && (otherDescSizeNo==0))
	{
out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br> <center> <font class='message1'> <b>other Lot <font color=blue>"+lot_no+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}
	else
	{
out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='message1'><b>other Lot with <font color=blue> Description or Size  </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}

}//else otherLotNo ,otherDescSizeNo

}
catch(Exception Samyak45){ 

out.println("<br><font color=red><h2> FileName : UpdateLot.jsp <br>Bug samyakErrorLine"+samyakErrorLine+ " Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}
C.returnConnection(conp);
C.returnConnection(cong);
}//if Update
%>