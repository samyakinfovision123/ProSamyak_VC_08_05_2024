<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
/*String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_name= A.getName("companyparty",company_id);
*/
String company_id= "1";//+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");


ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
/*try	{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtStockReport.jsp<br>Bug No e31 : "+ e31);}*/
try{

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String local_currency= I.getLocalCurrency(company_id);
int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
//out.print("<BR>d="+d);
String local_symbol= I.getLocalSymbol(company_id);
String currency_name=A.getName("Master_Currency", "Currency_Name","Currency_id",local_currency);

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
out.print("<br>command=" +command);

if("Stock".equals(command))
	{
try	{
	cong=C.getConnection();}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtStockReport.jsp<br>Bug No e31 : "+ e31);}

//out.print("<br>44order_by=");
String query="";
query="Select * from Lot_old where  Company_id=?  order by lot_id";
out.print("<br>53query="+query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();
int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
out.print("<br>57 lotcount " +count);
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
String lot_name[]= new String[count]; 
String Lot_Description[]= new String[count]; 
String Lot_Referance[]= new String[count]; 
String Lot_Location[]= new String[count]; 
String cut_id[]= new String[count]; 
String color_id[]= new String[count]; 
String purity_id[]= new String[count]; 
String fluorescence_id[]= new String[count]; 
String shape_id[]= new String[count]; 
String lab_id[]= new String[count]; 
String polish_id[]= new String[count]; 
String tableincusion_id[]= new String[count]; 
String symmetry_id[]= new String[count]; 
String luster_id[]= new String[count]; 
String Drwg_FileName[]= new String[count]; 
boolean Active[]=new boolean[count];
String Created_On[]= new String[count]; 
String Created_By[]= new String[count]; 
boolean Diamond[]=new boolean[count];
String Client_No[]= new String[count]; 
String Total_Weight[]= new String[count]; 
String Gross_Weight[]= new String[count]; 
String Metal_Weight[]= new String[count]; 
String Item_TypeId[]= new String[count]; 
String Country_Id[]= new String[count]; 
String Treatment_Id[]= new String[count]; 
String Color_StoneId[]= new String[count]; 
String Gold_Id[]= new String[count]; 
String Platinum_Id[]= new String[count]; 
String Gold_Qty[]= new String[count]; 
String Platinum_Qty[]= new String[count]; 
String Selling_Price[]= new String[count]; 
String Tag_Price[]= new String[count]; 
String Total_Depth[]= new String[count]; 
String Table_Perecentage[]= new String[count]; 
String Crown_Angle[]= new String[count]; 
String Size[]= new String[count]; 
String Shade_Id[]= new String[count]; 
String Openinclusion_Id[]= new String[count]; 
String Blackinclusion_Id[]= new String[count]; 
String Weight[]= new String[count]; 

double carats[]=new double[count];
double local_price[]=new double[count];
double dollar_price[]=new double[count];
double pcarats[]=new double[count];
double plocal_price[]=new double[count];
double pdollar_price[]=new double[count];
double ccarats[]=new double[count];
double clocal_price[]=new double[count];
double cdollar_price[]=new double[count];
double per_carats[]=new double[count];
double sale_carats[]=new double[count];
double per_ccarats[]=new double[count];
double sale_ccarats[]=new double[count];

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		lot_name[c]=rs_g.getString("Lot_Name");
		 cut_id[c]=rs_g.getString("cut_id");
		 color_id[c]=rs_g.getString("color_id");
		 purity_id[c]=rs_g.getString("purity_id");
		 fluorescence_id[c]= rs_g.getString("fluorescence_id");
		 shape_id[c]=rs_g.getString("shape_id");
		 lab_id[c]=rs_g.getString("lab_id");
		 polish_id[c]=rs_g.getString("polish_id");
		 tableincusion_id[c]= rs_g.getString("tableincusion_id");
		 symmetry_id[c]=rs_g.getString("symmetry_id");
		 luster_id[c]=rs_g.getString("luster_id");
		 Drwg_FileName[c]=rs_g.getString("Drwg_FileName");
		 Active[c]=rs_g.getBoolean("Active");
		 Created_On[c]=rs_g.getString("Created_On");
		 Created_By[c]=rs_g.getString("Created_By");
 		 Diamond[c]=rs_g.getBoolean("Diamond");
		 Client_No[c]=rs_g.getString("Client_No");
		 Total_Weight[c]=rs_g.getString("Total_Weight");
		 Gross_Weight[c]=rs_g.getString("Gross_Weight");
		 Metal_Weight[c]=rs_g.getString("Metal_Weight");
		 Item_TypeId[c]=rs_g.getString("Item_TypeId");
		 Country_Id[c]=rs_g.getString("Country_Id");
		 Treatment_Id[c]=rs_g.getString("Treatment_Id");
		 Color_StoneId[c]=rs_g.getString("Color_StoneId");
		 Gold_Id[c]=rs_g.getString("Gold_Id");
		 Platinum_Id[c]=rs_g.getString("Platinum_Id");
		 Gold_Qty[c]=rs_g.getString("Gold_Qty");
		 Platinum_Qty[c]=rs_g.getString("Platinum_Qty");
		 Selling_Price[c]=rs_g.getString("Selling_Price");
		 Tag_Price[c]=rs_g.getString("Tag_Price");
		 Total_Depth[c]=rs_g.getString("Total_Depth");
		 Table_Perecentage[c]=rs_g.getString("Table_Perecentage");
		 Crown_Angle[c]=rs_g.getString("Crown_Angle");
		 Size[c]=rs_g.getString("Size");
		 Shade_Id[c]=rs_g.getString("Shade_Id");
		 Openinclusion_Id[c]=rs_g.getString("Openinclusion_Id");
		 Blackinclusion_Id[c]=rs_g.getString("Blackinclusion_Id");
		 Weight[c]=rs_g.getString("Weight");



		c++;
		}
		pstmt_g.close();

out.print("<br> 178 Selected from old Lot table");

query="Select * from  Receive_Transaction RT, Receive R where  R.Company_id=? and R.Active=1  and R.receive_id=RT.receive_id order by R.receive_date,R.Receive_id";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//out.print("<br>101count=" +count);
String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		purchase[c]=rs_g.getString("purchase");
//		out.print("<br>purchase=" +purchase[c]);
		receive_sell[c]=rs_g.getString("receive_sell");
//		out.print("&nbsp;&nbsp;receive_sell=" +receive_sell[c]);
		lotid[c]=rs_g.getString("Lot_id");
 //	out.print("&nbsp;lotid[c]="+lotid[c]);
		qty[c]=rs_g.getDouble("Available_Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
// 	out.print("&nbsp;localprice[c]="+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		
		c++;
		}
		pstmt_g.close();
		C.returnConnection(cong);
out.print("<br> 222 Receive Receive_Transaction query for qty rate");	
int j=0;
double localp=0;
double localp_temp=0;
double tqty=0;
double tqty_temp=0;
double dollarp=0;
double dollarp_temp=0;
double temp=0;
double temp1=0;
double inwardqty=0;
double outwardqty=0;
double closingdqty=0;
double inwardtot=0;
double outwardtot=0;
double closingtot=0;
int k=0;
//out.print("<br>Lot Id &nbsp;&nbsp;Lot No &nbsp;&nbsp; carats&nbsp;&nbsp; local_price");

for(int i=0; i<counter; i++)
{
k=0;
j=0;
localp=0;
localp_temp=0;
tqty=0;
tqty_temp=0;
dollarp=0;
dollarp_temp=0;
temp=0;
temp1=0;
inwardqty=0;
outwardqty=0;
closingdqty=0;
inwardtot=0;
outwardtot=0;
closingtot=0;
while(j<count)
{

if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
	//qty[j]=Math.abs(qty[j]);
//qty[j]= Double.parseDouble(str.mathformat(""+qty[j],3));

 tqty_temp =tqty;
// out.print("<br>tqty_temp="+tqty_temp);
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

//carats[i] +=qty[j];
/*dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
//  out.print("<br>localp_temp="+localp_temp);

localp=0;
if(0==(tqty))
		{
localp=0;
dollarp=0;
		}
else{

 localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
 dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
}
temp=localprice[j]*qty[j];
temp1=localp*tqty;*/
 inwardqty +=qty[j];
 closingdqty +=tqty;
 inwardtot +=temp;
 closingtot +=temp1;
 per_carats[i]+=qty[j];


	}

else if((lot_id[i].equals(lotid[j]))&("0".equals(receive_sell[j])) &("1".equals(purchase[j])))
	{
//	qty[j]=Math.abs(qty[j]);
//qty[j]= Double.parseDouble(str.mathformat(""+qty[j],3));

//out.print("<br>sale="+qty[j]);
 tqty =tqty - qty[j];
//carats[i]=carats[i]-qty[j];
//out.print("&nbsp;&nbsp;qty="+tqty);
//out.print("&nbsp;&nbsp;Local="+localp);
//out.print("&nbsp;&nbsp;Dollar="+dollarp);
/*temp=localprice[j]*qty[j];
temp1=localp*tqty;*/
outwardqty +=qty[j];
outwardtot +=temp;
closingdqty +=tqty;
closingtot +=temp1;
sale_carats[i] +=qty[j];
}

j++;
}
 carats[i]=tqty;
 //local_price[i]=localp;
// dollar_price[i]=dollarp;
/*
 try{ 
		new Double(""+localp);
		local_price[i]=localp;
	}catch(Exception e) 
	{
	local_price[i]=0;
	}
 try{ 
		new Double(""+dollarp);
		dollar_price[i]=dollarp;
	}catch(Exception e) 
	{
	dollar_price[i]=0;
	}
 
*/
 
 
 
 pcarats[i]=0;
 plocal_price[i]=0;
 pdollar_price[i]=0;
 ccarats[i]=0;
 clocal_price[i]=0;
 cdollar_price[i]=0;
//out.print("<br>"+lot_id[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+lot_no[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+carats[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+local_price[i]);
//out.print("&nbsp;&nbsp;dollar_price="+dollar_price[i]);

}

out.print("<br> 359 Financial ");
for(int i=0; i<counter; i++)
{
k=0;
j=0;
localp=0;
localp_temp=0;
tqty=0;
tqty_temp=0;
dollarp=0;
dollarp_temp=0;
temp=0;
temp1=0;
inwardqty=0;
outwardqty=0;
closingdqty=0;
inwardtot=0;
outwardtot=0;
closingtot=0;
while(j<count)
{
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("0".equals(purchase[j])) )
	{
 tqty_temp =tqty;
// out.print("<br>tqty_temp="+tqty_temp);
 tqty +=qty[j];
//carats[i] +=qty[j];
tqty=str.mathformat(tqty,3);
/*dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
//  out.print("<br>localp_temp="+localp_temp);

localp=0;
if(0==(tqty))
		{
localp=0;
dollarp=0;
		}
else{

 localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;


 dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
}
temp=localprice[j]*qty[j];
temp1=localp*tqty;*/
 inwardqty +=qty[j];
 closingdqty +=tqty;
 inwardtot +=temp;
 closingtot +=temp1;
 per_ccarats[i]+=qty[j];


	}

else if((lot_id[i].equals(lotid[j]))&("0".equals(receive_sell[j])) &("0".equals(purchase[j])))
	{

//out.print("<br>sale="+qty[j]);
 tqty =tqty - qty[j];
//carats[i]=carats[i]-qty[j];
//out.print("&nbsp;&nbsp;qty="+tqty);
//out.print("&nbsp;&nbsp;Local="+localp);
//out.print("&nbsp;&nbsp;Dollar="+dollarp);
/*temp=localprice[j]*qty[j];
temp1=localp*tqty;*/
outwardqty +=qty[j];
outwardtot +=temp;
closingdqty +=tqty;
closingtot +=temp1;
sale_ccarats[i] +=qty[j];
}

j++;
}
ccarats[i]=tqty;
 clocal_price[i]=0+localp;

//out.print("<br>clocal_price[i]"+clocal_price[i]);
//out.print("<br>localp"+localp);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+lot_no[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+carats[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+local_price[i]);
//out.print("&nbsp;&nbsp;dollar_price="+dollar_price[i]);

}
out.print("<br>447 Physical(Consignment)");
double total=0;
double subtotal=0;
double local_total=0;
double csubtotal=0;
double clocal_total=0;
double psubtotal=0;
double plocal_total=0;
double per_total=0;
double sale_total=0;
double per_ctotal=0;
double sale_ctotal=0;
double p_total=0;




int s=1;

int temp_lot_loc_id=0;
temp_lot_loc_id=L.get_master_id(conp,"LotLocation");

for(int i=0; i< counter; i++)
{

total += carats[i];
subtotal= carats[i] *local_price[i];
local_total +=str.mathformat(subtotal,d);
csubtotal= ccarats[i] *clocal_price[i];
clocal_total +=str.mathformat(csubtotal,d);
psubtotal= subtotal+ csubtotal;
//out.print("<br>carats[i]="+carats[i]);
//out.print("<br>ccarats[i]="+ccarats[i]);
pcarats[i]=carats[i]+ccarats[i];
//out.print("<br>pcarats[i]="+pcarats[i]);
//pcarats[i]= Double.parseDouble(str.format(pcarats[i],3));
//out.print("<br>pcarats[i]="+pcarats[i]);

plocal_total+=str.mathformat(psubtotal,d);
 per_total +=per_carats[i];
sale_total += sale_carats[i];
 per_ctotal +=per_ccarats[i];
 sale_ctotal +=sale_ccarats[i];
p_total +=pcarats[i];
out.print("<br>488 Physical(Consignment)");

try	{
	conp=C.getConnection();}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtStockReport.jsp<br>Bug No e31 : "+ e31);}

query = " INSERT INTO Lot ( Lot_Id, Company_Id,Lot_No, Lot_Name,   Lot_Description, Lot_Referance,Lot_Location,LotCategory_Id   ,LotSubCategory_Id,Unit_Id,Carats,Available_Carats  ,ReorderQuantity,Created_On,Created_By, Modified_On,    Modified_By,Modified_MachineName, Drwg_FileName, Active) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";//20
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1,lot_id[i]);		
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,lot_no[i]);	
pstmt_p.setString (4,lot_name[i]);			
pstmt_p.setString (5,Lot_Description[i]);	
pstmt_p.setString (6,Lot_Referance[i]);
pstmt_p.setString (7, Lot_Location[i]);	
if(Diamond[i])
	{
pstmt_p.setString (8,"1");	//lotcategory_id
pstmt_p.setString (9,"1");	//lotsubcategory_id
pstmt_p.setString (10,"1"); //unit
	}
else{
pstmt_p.setString (8,"2");	//lotcategory_id
pstmt_p.setString (9,"2");	//lotsubcategory_id
pstmt_p.setString (10,"2"); //unit
}
pstmt_p.setString(11,"0");	
pstmt_p.setString(12,"0");	// indicate new diamond-> created_on
pstmt_p.setString (13,"0");	//reorderquantity
out.print("<br>519 Created_On[i] "+Created_On[i]);
pstmt_p.setString(14,""+Created_On[i]);	
out.print("<br>521 ");

pstmt_p.setString (15, "2");	
pstmt_p.setString (16,""+Created_On[i]);
pstmt_p.setString (17, "2");
pstmt_p.setString (18, "Samyak");
pstmt_p.setString (19, Drwg_FileName[i]);
pstmt_p.setBoolean (20, Active[i]);
int a500 = pstmt_p.executeUpdate();
pstmt_p.close();

if(Diamond[i])
	{

query = " INSERT INTO Diamond (Lot_Id,Cut_Id,Color_Id,Purity_Id, Fluorescence_Id,Shape_Id,Lab_Id,Polish_Id, TableIncusion_Id,Symmetry_Id,Luster_Id,Country_Id ,Selling_Price,Purchase_Price,Rapnet_Price,Rapnet_Date ,Total_Depth,Table_Perecentage,Crown_Angle,D_Size, Shade_Id,Openinclusion_Id,Blackinclusion_Id,Weight,YearEnd_Id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?,?,?)";//24

pstmt_p = conp.prepareStatement(query);

pstmt_p.setString(1,lot_id[i]);		
pstmt_p.setString(2,cut_id[i]);		
pstmt_p.setString(3,color_id[i]);		
pstmt_p.setString(4,purity_id[i]);
pstmt_p.setString(5,fluorescence_id[i]);		
pstmt_p.setString(6,shape_id[i]);		
pstmt_p.setString(7,lab_id[i]);		
pstmt_p.setString(8,polish_id[i]);	
pstmt_p.setString(9,tableincusion_id[i]);		
pstmt_p.setString(10,symmetry_id[i]);		
pstmt_p.setString(11,luster_id[i]);		
pstmt_p.setString(12,Country_Id[i]);

pstmt_p.setString(13,Selling_Price[i]);		
pstmt_p.setString(14,Tag_Price[i]);		
pstmt_p.setString(15,"0");		
pstmt_p.setString(16,""+Created_On[i]);
pstmt_p.setString(17,Total_Depth[i]);		
pstmt_p.setString(18,Table_Perecentage[i]);		
pstmt_p.setString(19,Crown_Angle[i]);		
pstmt_p.setString(20,Size[i]);		
pstmt_p.setString(21,Shade_Id[i]);		
pstmt_p.setString(22,Openinclusion_Id[i]);		
pstmt_p.setString(23,Blackinclusion_Id[i]);		
pstmt_p.setString(24,Weight[i]);		
pstmt_p.setString (25,yearend_id);
 int a542 = pstmt_p.executeUpdate();
pstmt_p.close();
	}
else{
query = " INSERT INTO Jewelry (Lot_Id, Client_No, Total_Weight, Gross_Weight, Metal_Weight, Item_TypeId, Country_Id, Treatment_Id, Color_StoneId, Gold_Id, Platinum_Id, Gold_Qty, Platinum_Qty, Selling_Price, Tag_Price, Shape_Id,YearEnd_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?)";//24


pstmt_p = conp.prepareStatement(query);

pstmt_p.setString(1,lot_id[i]);		
pstmt_p.setString(2,Client_No[i]);		
pstmt_p.setString(3,Total_Weight[i]);		
pstmt_p.setString(4,Gross_Weight[i]);
pstmt_p.setString(5,Metal_Weight[i]);		
pstmt_p.setString(6,Item_TypeId[i]);		
pstmt_p.setString(7,Country_Id[i]);		
pstmt_p.setString(8,Treatment_Id[i]);	
pstmt_p.setString(9,Color_StoneId[i]);		
pstmt_p.setString(10,Gold_Id[i]);		
pstmt_p.setString(11,Platinum_Id[i]);		
pstmt_p.setString(12,Gold_Qty[i]);

pstmt_p.setString(13,Platinum_Qty[i]);		
pstmt_p.setString(14,Selling_Price[i]);		
pstmt_p.setString(15,Tag_Price[i]);		
pstmt_p.setString(16,shape_id[i]);
pstmt_p.setString (17,yearend_id);
int a579 = pstmt_p.executeUpdate();
pstmt_p.close();

}


	query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+Created_On[i]+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br> 141"+query);
		pstmt_p.setString (1, ""+temp_lot_loc_id);	
//L.get_master_id("LotLocation")
//		out.print("<br> LotLocation_Id  "+L.get_master_id("LotLocation"));

		pstmt_p.setString (2,"1");
//		out.print("<br> ALocation_Id  "+ALocation_Id[i]);

		pstmt_p.setString (3,""+lot_id[i]);
//		out.print("<br> Lot_Id  "+Lot_Id);
		pstmt_p.setString (4,company_id);
		pstmt_p.setString (5,str.mathformat(""+carats[i],3));		
		pstmt_p.setString (6,str.mathformat(""+pcarats[i],3));		
		pstmt_p.setString (7, "2");		
		pstmt_p.setString (8, "Samyak");		
		pstmt_p.setString (9,yearend_id);
		int a604 = pstmt_p.executeUpdate();
		pstmt_p.close();
temp_lot_loc_id++;

}//for

out.print("<br>412 New Lot ,Diamond, Jewelry, LotLocation");
//response.sendRedirect("../Master/CancelVouchers.jsp?command=edit&&message=Data Sucessfully Updated with Stock");
		C.returnConnection(conp);
out.print("<br> 619 Done Successfully");
}//if Detail Stock 

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>












