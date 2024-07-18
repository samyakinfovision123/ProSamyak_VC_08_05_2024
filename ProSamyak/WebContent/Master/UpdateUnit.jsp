<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
out.println("Today's Date is "+D);
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
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;


if("Add Unit".equals(command))
{

try{
	conp=C.getConnection();
String unit_name	=request.getParameter("unit_name");	
String unit_code	=request.getParameter("unit_code");


	String selectquery ="Select * from Master_unit where unit_Name=? and company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,unit_name);		
//pstmt_p.setString (2,unit_code);		
pstmt_p.setString (2,company_id);	
//out.print("<br>46"+selectquery);
int nameexist=0;
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
{nameexist++;}
//out.print("nameexist"+nameexist);
pstmt_p.close();


if(nameexist<1)
	{

String category_no= ""+L.get_master_id(conp,"Master_unit");
String unit_description=request.getParameter("unit_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String query = " INSERT INTO Master_unit ( unit_Id,company_Id, unit_Code ,unit_Name, unit_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,category_no);		
//out.print("<br >1 "+category_no);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,unit_code);	
//out.print("<br >2aa "+unit_code);
pstmt_p.setString (4, unit_name);
//out.print("<br >3 "+unit_name);
pstmt_p.setString (5, unit_description);			
//out.print("<br >4 "+unit_description);
pstmt_p.setString (6,sr_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (7, flag);	
//out.print("<br> 6"+active);	
pstmt_p.setString (8, user_id);		
pstmt_p.setString (9, machine_name);	
pstmt_p.setString (10,yearend_id);	
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();
C.returnConnection(conp);
//out.println("Before Query <br>a"+a);
//System.out.println("After query result a is "+a);
response.sendRedirect("NewUnit.jsp?commadn=Default&message=Unit  <font color=blue>"+unit_name+" </font>successfully Added");

	}
else
{
	C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Unit <font color=blue>"+unit_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end

}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD CATEGORY


if("Update Unit".equals(command))
{

	try {
		conp=C.getConnection();
	//out.print("<BR>116<br>");


	String unit_id="";
	String unit_code="";
	String unit_name="";
	String unit_description="";
	String sr_no="";

	boolean activeflag=false;
	String str="";
	//out.print("<BR>116<br>");

	unit_id= request.getParameter("unit_id");
	unit_code= request.getParameter("unit_code");
	unit_name = request.getParameter("unit_name");
	//out.print("<BR>116<br>");

	unit_description = request.getParameter("unit_description");
	sr_no= request.getParameter("sr_no");	
//out.print("<BR>128<br>");
if("yes".equals(request.getParameter("active")))
		{ activeflag=true; }
	//out.print("<BR>before queryunit_description"+unit_description);
	String query1 = "Update  Master_unit set  unit_Code=?,  unit_Name=?, unit_Description=?, sr_no=?, active=? where unit_Id=?";
	//out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,unit_code);
	pstmt_p.setString(2,unit_name);	
	pstmt_p.setString(3,unit_description);
	pstmt_p.setString(4,sr_no);		
	pstmt_p.setBoolean(5,activeflag);		
	pstmt_p.setString(6,unit_id);
	int a = pstmt_p.executeUpdate();
	out.print("unit_id a "+unit_id+"yes"+a);
C.returnConnection(conp);

response.sendRedirect("EditUnit.jsp?command=edit&message=Master Unit "+unit_name+" successfully updated.");
	}catch(Exception e93)
	{ 
	out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +"</font>");}
	
}//Update Unit
%>








