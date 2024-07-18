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
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
		//out.println("command is "+command);


if("ADD".equals(command))
{

try{
String location_name	=request.getParameter("location_name");	
String location_code	=request.getParameter("location_code");


 	 conp=C.getConnection();


	String selectquery ="Select * from Master_Location where Location_Name=? and company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,location_name);		
//pstmt_p.setString (2,location_code);		
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

String location_no= ""+L.get_master_id(conp,"Master_Location");
String location_description=request.getParameter("location_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String query = " INSERT INTO Master_Location ( Location_Id,company_Id, Location_Code ,Location_Name, Location_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,location_no);		
//out.print("<br >1 "+location_no);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,location_code);	
//out.print("<br >2aa "+location_code);
pstmt_p.setString (4, location_name);
//out.print("<br >3 "+location_name);
pstmt_p.setString (5, location_description);			
//out.print("<br >4 "+location_description);
pstmt_p.setString (6,sr_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (7, flag);	
//out.print("<br> 6"+active);	
pstmt_p.setString (8, user_id);		
pstmt_p.setString (9, machine_name);	
pstmt_p.setString (10,yearend_id);	
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();
//out.println("Before Query <br>a"+a);
//System.out.println("After query result a is "+a);
C.returnConnection(conp);


response.sendRedirect("NewLocation.jsp?commadn=Default&message=Location  <font color=blue><B> "+location_name+"</B> </font>successfully Added");

	}

else
{ 

	C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=3 color=red><b>Location <font color=blue>"+location_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end

//C.returnConnection(conp);
}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD CATEGORY


if("SAVE".equals(command))
{

	try {
	//out.print("<BR>116<br>");
	 	 conp=C.getConnection();

	String location_id="";
	String location_code="";
	String location_name="";
	String location_description="";
	String sr_no="";

	boolean activeflag=false;
	String str="";
	//out.print("<BR>116<br>");

	location_id= request.getParameter("location_id");
	location_code= request.getParameter("location_code");
	location_name = request.getParameter("location_name");
	//out.print("<BR>116<br>");

	location_description = request.getParameter("location_description");
	sr_no= request.getParameter("sr_no");	
//out.print("<BR>128<br>");

if("yes".equals(request.getParameter("active")))
		{ activeflag=true; }
	//out.print("<BR>before querylocation_description"+location_description);
	String selectquery ="Select * from Master_Location where Location_Name=? and Location_id!="+location_id+" and company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,location_name);		
//pstmt_p.setString (2,location_code);		
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
	String query1 = "Update  Master_Location set  Location_Code=?,  Location_Name=?, Location_Description=?, sr_no=?, active=? where Location_Id=?";
	//out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,location_code);
	pstmt_p.setString(2,location_name);	
	pstmt_p.setString(3,location_description);
	pstmt_p.setString(4,sr_no);		
	pstmt_p.setBoolean(5,activeflag);		
	pstmt_p.setString(6,location_id);
	int a = pstmt_p.executeUpdate();
	out.print("location_id a "+location_id+"yes"+a);
	C.returnConnection(conp);

response.sendRedirect("NewLocation.jsp?command=Default&message=<B>Master Location <font color=blue>"+location_name+"</font> successfully updated.</B>");
	}else
		{
			C.returnConnection(conp);
			out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=3 color=red>Location <font color=blue>"+ location_name+" </font>already exists.</font><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
		}

	}catch(Exception e93)
	{ 
		C.returnConnection(conp);
	out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +"</font>");}
	
}//Update Location
%>








