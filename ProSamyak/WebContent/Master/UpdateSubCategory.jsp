<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
out.print("<br>46"+company_id);
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
//out.print("command"+command);
ResultSet rs_g= null;
Connection conp = null;

PreparedStatement pstmt_p=null;


if("Add Sub Category".equals(command))
{

try{
	 conp=C.getConnection();
//out.print("<br>46"+company_id);
//out.print("<br>46"+company_id);
String lotcategory_id	=request.getParameter("lotcategory_id");
String lotsubcategory_name	=request.getParameter("lotsubcategory_name");	
String lotsubcategory_code	=request.getParameter("lotsubcategory_code");
String lotsubcategory_description =request.getParameter("lotsubcategory_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
//out.print("<br>active"+active);
//out.print("<br>49"+company_id);
String selectquery ="Select * from Master_LotSubCategory where LotCategory_Id=? and LotSubCategory_Name=? and Company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
//out.print("<br>52"+company_id);
pstmt_p.setString (1,lotcategory_id);		
pstmt_p.setString (2,lotsubcategory_name);		
pstmt_p.setString (3,company_id);	
//out.print("<br>46"+company_id);
int nameexist=0;
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
{nameexist++;}
//out.print("nameexist"+nameexist);
pstmt_p.close();
if(nameexist<1)
	{

String subcategory_id= ""+L.get_master_id(conp,"Master_LotSubCategory");
//out.print("subcategory_id"+subcategory_id);
boolean flag =false; 
if("yes".equals(active)){flag=true;}

String query = " INSERT INTO Master_LotSubCategory ( LotSubCategory_Id,company_Id,LotCategory_Id, LotSubCategory_Code ,LotSubCategory_Name, LotSubCategory_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,subcategory_id);		
//out.print("<br >1 "+subcategory_id);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,lotcategory_id);	
pstmt_p.setString (4,lotsubcategory_code);	
//out.print("<br >2aa "+lotcategory_code);
pstmt_p.setString (5, lotsubcategory_name);
//out.print("<br >3 "+lotcategory_name);
pstmt_p.setString (6, lotsubcategory_description);			
//out.print("<br >4 "+lotcategory_description);
pstmt_p.setString (7,sr_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (8, flag);	
//out.print("<br> 8"+flag);	
pstmt_p.setString (9, user_id);		
pstmt_p.setString (10, machine_name);	
pstmt_p.setString (11,yearend_id);	
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();
//out.println("After Query <br>a"+a);
//System.out.println("After query result a is "+a);
C.returnConnection(conp);

response.sendRedirect("NewSubCategory.jsp?commadn=Default&message=Sub Category  <font color=blue>"+lotsubcategory_name+"</font> successfully Added");

	}
else
{
	C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Category <font color=blue>"+lotsubcategory_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end


}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD CATEGORY


if("Update".equals(command))
{

	try {
	 conp=C.getConnection();	
	int counter  = 0;
	counter = Integer.parseInt(request.getParameter("counter"));
	String lotcategory_id=request.getParameter("lotcategory_id");
	String lotsubcategory_id[]=new String[counter];
	String lotsubcategory_code[]=new String[counter];
	String lotsubcategory_name[]=new String[counter];
	String lotsubcategory_description[]=new String[counter];
	String sr_no[]=new String[counter];
	boolean active[]=new boolean[counter];
	String str="";
	out.print("<BR>Inside UpdateCategoryMaster"+counter);

	for(int i=0;i<counter ;i++)
	{
		//out.print("<Br>");
		lotsubcategory_id[i] = request.getParameter("lotsubcategory_id"+i);
//		out.print("&nbsp;"+lotsubcategory_id[i]);
		lotsubcategory_code[i]= request.getParameter("lotsubcategory_code"+i);
//		out.print("&nbsp;");
		lotsubcategory_name[i] = request.getParameter("lotsubcategory_name"+i);
//		out.print("&nbsp;");
		lotsubcategory_description[i] = request.getParameter("lotsubcategory_description"+i);
		sr_no[i] = request.getParameter("sr_no"+i);	
//		out.print("&nbsp;");
	if("yes".equals(request.getParameter("active"+i)))
		{ active[i] =true; }
	}
//out.print("<BR>before query"+counter);
	for( int i=0; i < counter ; i++)
	{
	String query1 = "Update  Master_LotSubCategory set  LotSubCategory_Code=?,  LotSubCategory_Name=?, LotSubCategory_Description=?, sr_no=?, active=? where LotSubCategory_Id=?";
//	out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,lotsubcategory_code[i]);
//	out.print("setString1:"+lotsubcategory_code[i]);
	pstmt_p.setString(2,lotsubcategory_name[i]);	
	pstmt_p.setString(3,lotsubcategory_description[i]);
	pstmt_p.setString(4,sr_no[i]);		
	pstmt_p.setBoolean(5,active[i]);		
	pstmt_p.setString(6,lotsubcategory_id[i]);
	int a = pstmt_p.executeUpdate();
	out.print(" a "+a);
	}

String valLotCategory = A.getName(conp,"LotCategory",lotcategory_id);
C.returnConnection(conp);	
response.sendRedirect("EditSubCategory.jsp?command=edit&message=Sub Categories of "+valLotCategory+" successfully updated.");
}
	catch(Exception e93)
	{ 
	out.println("<br><font color=red> FileName : GL_UpdateCategory.jsp <br>Bug No e93 :"+ e93 +"</font>");}
	
}//ifUpdateCategoryMaster
%>








