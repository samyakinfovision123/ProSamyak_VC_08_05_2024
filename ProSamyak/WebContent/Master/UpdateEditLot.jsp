
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
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
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	try	{
		 conp=C.getConnection();

//-------------------------------------------------------------------------


String lot_name= request.getParameter("lot_name");
//out.print("<br>lot_name-"+lot_name);

String lot_description= request.getParameter("lot_description");
//out.print("<br>lot_description-"+lot_name);

String cut_id= request.getParameter("cut_id");
//out.print("<br>cut_id-"+cut_id);

String color_id= request.getParameter("color_id");
//out.print("<br>-color_id"+color_id);

String purity_id= request.getParameter("purity_id");
//out.print("<br>-purity_id"+purity_id);


String fluorescence_id= request.getParameter("fluorescence_id");
//out.print("<br>fluorescence_id-"+fluorescence_id);

String shape_id= request.getParameter("shape_id");
//out.print("<br>shape_id-"+shape_id);

String lab_id= request.getParameter("lab_id");
//out.print("<br>lab_id-"+lab_id);

String polish_id= request.getParameter("polish_id");
//out.print("<br>-polish_id"+polish_id);

String tableincusion_id= request.getParameter("tableincusion_id");
//out.print("<br>-tableincusion_id"+tableincusion_id);

String symmetry_id= request.getParameter("symmetry_id");
//out.print("<br>-symmetry_id"+symmetry_id);

String luster_id= request.getParameter("luster_id");
//out.print("<br>luster_id-"+luster_id);

String total_depth= request.getParameter("total_depth");
//out.print("<br>total_depth-"+total_depth);

String crown_angle= request.getParameter("crown_angle");
//out.print("<br>crown_angle-"+crown_angle);

String table_per= request.getParameter("table_per");
//out.print("<br>table_per-"+table_per);

String size_id= request.getParameter("size_id");
//out.print("<br>size_id-"+size_id);

String country_id= request.getParameter("country_id");
//out.print("<br>-country_id"+country_id);

String shade_id= request.getParameter("shade_id");
//out.print("<br>shade_id-"+shade_id);

String blackinclusion= request.getParameter("blackinclusion");
//out.print("<br>blackinclusion-"+blackinclusion);
String openinclusion= request.getParameter("openinclusion");
//out.print("<br>openinclusion-"+openinclusion);

String weight= request.getParameter("weight");
//out.print("<br>weight-"+weight);

String purchase_price= request.getParameter("purchase_price");
//out.print("<br>purchase_price-"+purchase_price);

String Selling_price= request.getParameter("selling_price");
//out.print("<br>Selling_price-"+Selling_price);

String lot_referance = request.getParameter("Lot_Referance");
//out.print("<br>lot_referance-"+lot_referance);

String lot_location= request.getParameter("lot_location");
//out.print("<br>lot_location-"+lot_location);

String reorderquantity = request.getParameter("reorderquantity");
//out.print("<br>reorderquantity-"+reorderquantity);

//---------------------------------------------------------------------
String query = " Update Lot set Lot_Name=?,Lot_Description=?,Lot_Referance=?,Lot_Location=?, Modified_On=?,Modified_By=?,Modified_MachineName=? ,ReorderQuantity=? where lot_id="+lot_id;//8
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1,lot_name);			
pstmt_p.setString (2,lot_description);	
pstmt_p.setString (3,lot_referance);
pstmt_p.setString (4, lot_location);

pstmt_p.setString(5,""+D);		
pstmt_p.setString (6, user_id);		
pstmt_p.setString (7, machine_name);		
pstmt_p.setString (8, reorderquantity);		

int a = pstmt_p.executeUpdate();
pstmt_p.close();

//-----------Lot table ompleted---------------------


query ="Update Diamond set Cut_Id=?,Color_Id=?,Purity_Id=?,Fluorescence_Id=?, Shape_Id=?,Lab_Id=?,Polish_Id=?,TableIncusion_Id=?, Symmetry_Id=?,Luster_Id=?,Country_Id=?,Selling_Price=?, Purchase_Price=?,Table_Perecentage=?,Crown_Angle=?,D_Size=?, Shade_Id=?,Openinclusion_Id=?,Blackinclusion_Id=?,Weight=?,Total_Depth=? where lot_id="+lot_id;//21
//out.print(query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString(1,cut_id);		
pstmt_p.setString(2,color_id);		
pstmt_p.setString(3,purity_id);
pstmt_p.setString(4,fluorescence_id);		

pstmt_p.setString(5,shape_id);		
pstmt_p.setString(6,lab_id);		
pstmt_p.setString(7,polish_id);	
pstmt_p.setString(8,tableincusion_id);		

pstmt_p.setString(9,symmetry_id);		
pstmt_p.setString(10,luster_id);		
pstmt_p.setString(11,country_id);
pstmt_p.setString(12,Selling_price);		

pstmt_p.setString(13,purchase_price);		
pstmt_p.setString(14,table_per);
pstmt_p.setString(15,crown_angle);		
pstmt_p.setString(16,size_id);		


pstmt_p.setString(17,shade_id);		
pstmt_p.setString(18,openinclusion);		
pstmt_p.setString(19,blackinclusion);		
pstmt_p.setString(20,weight);		
pstmt_p.setString(21,total_depth);
//out.print("total_depth "+total_depth);

 a = pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<br>update successfully a="+a);
//conp.close();
C.returnConnection(conp);

}catch(Exception e11){ 
out.println("<font color=red> FileName : UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}

response.sendRedirect("EditLot.jsp?command=edit&message=Diamond Lot <font class='msgcolor2'>"+lot_no+"</font> Successfully Updated");

%>








