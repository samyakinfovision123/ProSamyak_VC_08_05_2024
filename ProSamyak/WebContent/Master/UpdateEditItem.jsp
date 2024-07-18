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

String command  = request.getParameter("command");
//out.print("<br>command=" +command);
//System.out.println("Inside Updeate Account");
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	try	{
		 conp=C.getConnection();

String lot_id= request.getParameter("lot_id");	
//out.print("<br>-lot_id"+lot_id);

String lot_no= request.getParameter("lot_no");	
//out.print("<br>-lot_no"+lot_no);

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
String query = " Update Lot set Lot_Name=?,Lot_Description=?,Lot_Referance=?,Lot_Location=?, Modified_On=?,Modified_By=?,Modified_MachineName=? ,ReorderQuantity=? where lot_id="+lot_id;//7
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

//-----------Lot table ompleted----------------------------------------------
C.returnConnection(conp);

response.sendRedirect("EditLot.jsp?command=edit&message=Item <font class='msgcolor2'>"+lot_no+"</font> Successfully Updated");
}catch(Exception e11){ 
out.println("<font color=red> FileName : UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}


%>








