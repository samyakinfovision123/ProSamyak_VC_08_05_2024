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
/*try	{
 	 conp=C.getConnection();
		}catch(Exception e11){ 
		out.println("<font color=red> FileName : GL_UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}*/
		//out.println("command is "+command);


if("Add".equals(command))
{

try{
	conp=C.getConnection();
String costheadgroup_name	=request.getParameter("costheadgroup_name");	
String costheadgroup_code	=request.getParameter("costheadgroup_code");


	String selectquery ="Select * from Master_costheadgroup where costheadgroup_Name=? and company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
pstmt_p.setString (1,costheadgroup_name);		
//pstmt_p.setString (2,lotcategory_code);		
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

String costheadgroup_no= ""+L.get_master_id(conp,"Master_costheadgroup");
String costheadgroup_description= request.getParameter("costheadgroup_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String query = " INSERT INTO Master_costheadgroup ( costheadgroup_Id,company_Id, costheadgroup_Code ,costheadgroup_Name, costheadgroup_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,costheadgroup_no);		
//out.print("<br >1 "+costheadgroup_no);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,costheadgroup_code);	
//out.print("<br >2aa "+costheadgroup_code);
pstmt_p.setString (4, costheadgroup_name);
//out.print("<br >3 "+costheadgroup_name);
pstmt_p.setString (5, costheadgroup_description);			
//out.print("<br >4 "+costheadgroup_description);
pstmt_p.setString (6,sr_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (7, flag);	
//out.print("<br> 6"+active);	
pstmt_p.setString (8, user_id);		
pstmt_p.setString (9, machine_name);	
pstmt_p.setString (10,yearend_id);	
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();
pstmt_p.close();
String costheadsubgroup_id= ""+L.get_master_id(conp,"Master_costheadsubgroup");

query = " INSERT INTO Master_costheadsubgroup( costheadsubgroup_Id,company_Id,costheadgroup_id, costheadsubgroup_Code ,costheadsubgroup_Name, costheadsubgroup_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,costheadsubgroup_id);		
//out.print("<br >1 "+subcategory_id);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,costheadgroup_no);	
pstmt_p.setString (4,costheadgroup_code);	
//out.print("<br >2aa "+costheadsubgroup_code);
pstmt_p.setString (5, costheadgroup_name);
//out.print("<br >3 "+costheadsubgroup_name);
pstmt_p.setString (6, costheadgroup_description);			
//out.print("<br >4 "+costheadsubgroup_description);
pstmt_p.setString (7,"1");			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (8, flag);	
//out.print("<br> 8"+flag);	
pstmt_p.setString (9, user_id);		
pstmt_p.setString (10, machine_name);	
pstmt_p.setString (11,yearend_id);	
//out.println("Before Query <br>"+query);
int a109 = pstmt_p.executeUpdate();
pstmt_p.close();
C.returnConnection(conp);
//out.println("Before Query <br>a"+a);
//System.out.println("After query result a is "+a);

response.sendRedirect("NewCostHeadGroup.jsp?commadn=Default&message=CostHeadGroup  "+costheadgroup_name+" successfully Added");

	}
else
{
		C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='msgred'><b>CostHeadGroup <font class='msgblue'>"+costheadgroup_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end


}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD 


if("Update CostHeadGroup".equals(command))
{

	try {
	//out.print("<BR>116<br>");
	conp=C.getConnection();

	String CostHeadGroup_id="";
	String CostHeadGroup_code="";
	String CostHeadGroup_name="";
	String CostHeadGroup_description="";
	String sr_no="";

	boolean activeflag=false;
	String str="";
	//out.print("<BR>116<br>");

	CostHeadGroup_id= request.getParameter("CostHeadGroup_id");
	CostHeadGroup_code= request.getParameter("CostHeadGroup_code");
	CostHeadGroup_name = request.getParameter("CostHeadGroup_name");
	//out.print("<BR>116<br>");

	CostHeadGroup_description = request.getParameter("CostHeadGroup_description");
	sr_no= request.getParameter("sr_no");	
//out.print("<BR>128<br>");
if("yes".equals(request.getParameter("active")))
		{ activeflag=true; }
	//out.print("<BR>before queryCostHeadGroup_description"+CostHeadGroup_description);




	String query1 = "Update  Master_CostHeadGroup set  CostHeadGroup_Code=?,  CostHeadGroup_Name=?, CostHeadGroup_Description=?, sr_no=?, active=? where CostHeadGroup_Id=?";
	//out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,CostHeadGroup_code);
	pstmt_p.setString(2,CostHeadGroup_name);	
	pstmt_p.setString(3,CostHeadGroup_description);
	pstmt_p.setString(4,sr_no);		
	pstmt_p.setBoolean(5,activeflag);		
	pstmt_p.setString(6,CostHeadGroup_id);
	int a = pstmt_p.executeUpdate();
	//out.print("CostHeadGroup_id a "+CostHeadGroup_id+"yes"+a);
	pstmt_p.close();
	C.returnConnection(conp);
	
response.sendRedirect("EditCostHeadGroup.jsp?command=edit&message=Master Cost Head Group "+CostHeadGroup_name+" successfully updated.");

	}catch(Exception e93)
	{ 
	out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +"</font>");}
	
}//Update Category
%>








