<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<html>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//out.print(company_id);
//String company_name= A.getName("companyparty",company_id);
//out.print("<br>comapny_name="+company_name);
//String user_name=A.getName("User",user_id);
//out.print("<br>user_name="+user_name);
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

String lot_id= request.getParameter("lot_id");	
//out.print("<br>-lot_id"+lot_id);

String lot_no= request.getParameter("lot_no");	
//out.print("<br>-lot_no"+lot_no);

String command  = request.getParameter("command");
//out.print("<br>command=" +command);
//System.out.println("Inside Updeate Account");
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	try	{
		 conp=C.getConnection();


String lot_name= request.getParameter("lot_name");
//out.print("<br>lot_name-"+lot_name);

String lot_description= request.getParameter("lot_description");
//out.print("<br>lot_description-"+lot_name);

String lot_referance = request.getParameter("Lot_Referance");
//out.print("<br>lot_referance-"+lot_referance);

String lot_location= request.getParameter("lot_location");
//out.print("<br>lot_location-"+lot_location);

String reorderquantity = request.getParameter("reorderquantity");
//out.print("<br>reorderquantity-"+reorderquantity);

//---------------------------------------------------------------------
String query = " Update Lot set Lot_Name=?,Lot_Description=?,Lot_Referance=?,Lot_Location=?, Modified_On=?,Modified_By=?,Modified_MachineName=?,ReorderQuantity=? where lot_id="+lot_id;//7
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1,lot_name);			
pstmt_p.setString (2,lot_description);	
pstmt_p.setString (3,lot_referance);
pstmt_p.setString (4, lot_location);

pstmt_p.setString(5,""+D);		
pstmt_p.setString (6, user_id);		
pstmt_p.setString (7, machine_name);
pstmt_p.setString (8, reorderquantity);		
//out.print("<br>reorderquantity="+reorderquantity);

int a = pstmt_p.executeUpdate();
pstmt_p.close();

//-----------Lot table ompleted---------------------------

	String client_no= request.getParameter("client_no");
//	out.print("<br>client_no=>"+client_no);
	
	String total_weight= request.getParameter("total_weight");
//	out.print("<br>total_weight=>"+total_weight);

	String gross_weight= request.getParameter("gross_weight");
//	out.print("<br>gross_weight=>"+gross_weight);

	String metal_weight= request.getParameter("metal_weight");
//	out.print("<br>metal_weight=>"+metal_weight);

	String item_typeid= request.getParameter("Itemtype_id");
//	out.print("<br>item_typeid=>"+item_typeid);

	String country_id= request.getParameter("country_id");
//	out.print("<br>country_id=>"+country_id);

	String treatment_id= request.getParameter("treatment_id");
//	out.print("<br>treatment_id=>"+treatment_id);

	String colorstone_id= request.getParameter("colorstone_id");
//	out.print("<br>colorstone_id=>"+colorstone_id);

	String gold_id= request.getParameter("gold_id");
//	out.print("<br>gold_id=>"+gold_id);

	String platinum_id= request.getParameter("platinum_id");
//	out.print("<br>platinum_id=>"+platinum_id);

	String gold_qty= request.getParameter("gold_qty");
//	out.print("<br>gold_qty=>"+gold_qty);

	String platinum_qty= request.getParameter("platinum_qty");
//	out.print("<br>platinum_qty=>"+platinum_qty);

	String selling_price= request.getParameter("selling_price");
//	out.print("<br>selling_price=>"+selling_price);

	String tag_price= request.getParameter("tag_price");
//	out.print("<br>tag_price=>"+tag_price);

	String shape_id= request.getParameter("shape_id");
//	out.print("<br>shape_id=>"+shape_id);

	String numberofstones= request.getParameter("number_of_stones");
//	out.print("<br>numberofstones=>"+numberofstones);

	String Book_No=request.getParameter("Book_No");
	//out.print("<BR>Book_No=  "+Book_No);

	String GroupCode_Id=request.getParameter("GroupCode_Id");
	//out.print("<BR>GroupCode_Id=  "+GroupCode_Id);

	String Supplier_Id=request.getParameter("Supplier_Id");
	//out.print("<BR>Supplier_Id=  "+Supplier_Id);

	String Diamond_Weight=request.getParameter("Diamond_Weight");
	//out.print("<BR>Diamond_Weight=  "+Diamond_Weight);

	String ColorStone_Weight=request.getParameter("ColorStone_Weight");
	//out.print("<BR>ColorStone_Weight=  "+ColorStone_Weight);

	String GoldMetaltype_Id=request.getParameter("GoldMetaltype_Id");
	//out.print("<BR>GoldMetaltype_Id=  "+GoldMetaltype_Id);

	String Price_Code=request.getParameter("Price_Code");
	//out.print("<BR>Price_Code=  "+Price_Code);

//----------------------------------------------------------


		query = "Update Jewelry set Client_No=?,Total_Weight=?,Gross_Weight=?,Metal_Weight=?, Item_TypeId=?,Country_Id=?,Treatment_Id=?,Color_StoneId=?, Gold_Id=?,Platinum_Id=?,Gold_Qty=?,Platinum_Qty=?, Selling_Price=?,Tag_Price=?,Shape_Id=?,Number_Of_stones=?,Book_No=?,GroupCode_Id=?,Supplier_Id=?,Diamond_Weight=?,ColorStone_Weight=?,GoldMetaltype_Id=?,Price_Code=? where lot_id="+lot_id;
		//16


pstmt_p = conp.prepareStatement(query);

	
pstmt_p.setString(1,client_no);		
pstmt_p.setString(2,total_weight);		
pstmt_p.setString(3,gross_weight);
pstmt_p.setString(4,metal_weight);		

pstmt_p.setString(5,item_typeid);		
pstmt_p.setString(6,country_id);		
pstmt_p.setString(7,treatment_id);	
pstmt_p.setString(8,colorstone_id);		

pstmt_p.setString(9,gold_id);		
pstmt_p.setString(10,platinum_id);		
pstmt_p.setString(11,gold_qty);
pstmt_p.setString(12,platinum_qty);		

pstmt_p.setString(13,selling_price);		
pstmt_p.setString(14,tag_price);		
pstmt_p.setString(15,shape_id);
pstmt_p.setString(16,numberofstones);		

pstmt_p.setString(17,Book_No);		
pstmt_p.setString(18,GroupCode_Id);		
pstmt_p.setString(19,Supplier_Id);		
pstmt_p.setString(20,Diamond_Weight);		

pstmt_p.setString(21,ColorStone_Weight);		
pstmt_p.setString(22,GoldMetaltype_Id);		
pstmt_p.setString(23,Price_Code);		

 a = pstmt_p.executeUpdate();
// out.print("<br>a==>"+a);
pstmt_p.close();

C.returnConnection(conp);
}catch(Exception e11){ 
out.println("<font color=red> FileName : UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}

response.sendRedirect("EditLot.jsp?command=edit&message= Jewelry Lot "+lot_no+" Successfully Updated");

%>








