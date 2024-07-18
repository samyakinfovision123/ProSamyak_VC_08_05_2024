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
//out.print("<br>46"+company_id);
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
String today_string=format.format(D);


String command  = request.getParameter("command");
//out.print("command"+command);
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
//out.print("<br>46"+company_id);
//out.print("<br>46"+company_id);
String costheadgroup_id	=request.getParameter("costheadgroup_id");
String costheadsubgroup_name	=request.getParameter("costheadsubgroup_name");	
String costheadsubgroup_code	=request.getParameter("costheadsubgroup_code");
String costheadsubgroup_description =request.getParameter("costheadsubgroup_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
//out.print("<br>active"+active);
//out.print("<br>49"+company_id);
String selectquery ="Select * from Master_costheadsubgroup where costheadgroup_id=? and costheadsubgroup_Name=? and Company_id=?"; 
pstmt_p = conp.prepareStatement(selectquery);
//out.print("<br>52"+company_id);
pstmt_p.setString (1,costheadgroup_id);		
pstmt_p.setString (2,costheadsubgroup_name);		
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

String costheadsubgroup_id= ""+L.get_master_id(conp,"Master_costheadsubgroup");

boolean flag =false; 
if("yes".equals(active)){flag=true;}

String query = " INSERT INTO Master_costheadsubgroup( costheadsubgroup_Id,company_Id,costheadgroup_id, costheadsubgroup_Code ,costheadsubgroup_Name, costheadsubgroup_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?,'"+format.getDate(today_string)+"',?,?,?)";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,costheadsubgroup_id);		
//out.print("<br >1 "+subcategory_id);
pstmt_p.setString (2,company_id);	
pstmt_p.setString (3,costheadgroup_id);	
pstmt_p.setString (4,costheadsubgroup_code);	
//out.print("<br >2aa "+costheadsubgroup_code);
pstmt_p.setString (5, costheadsubgroup_name);
//out.print("<br >3 "+costheadsubgroup_name);
pstmt_p.setString (6, costheadsubgroup_description);			
//out.print("<br >4 "+costheadsubgroup_description);
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
pstmt_p.close();
C.returnConnection(conp);
response.sendRedirect("NewCostHeadSubGroup.jsp?commadn=Default&message=Cost Head SubGroup "+costheadsubgroup_name+" successfully Added");

	}
else
{
	String valcostheadgroup =  A.getName(conp,"costheadgroup",costheadgroup_id);
		C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='msgred'><b>Cost Head SubGroup <font class='msgblue'>"+costheadsubgroup_name+" </font>already exists , For The Cost Head Group <font class='msgblue'> "+valcostheadgroup+"</font> </font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end



}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD 


if("Update".equals(command))
{

	try {
		 conp=C.getConnection();
	int counter  = 0;
	counter = Integer.parseInt(request.getParameter("counter"));
	String costheadgroup_id=request.getParameter("CostHeadGroup_id");
//	out.print("<br> 120 costheadgroup_id "+costheadgroup_id);
	String costheadsubgroup_id[]=new String[counter];
	String costheadsubgroup_code[]=new String[counter];
	String costheadsubgroup_name[]=new String[counter];
	String costheadsubgroup_description[]=new String[counter];
	String sr_no[]=new String[counter];
	boolean active[]=new boolean[counter];
	String str="";
//	out.print("<BR>Inside UpdateCategoryMaster"+counter);

	for(int i=0;i<counter ;i++)
	{
		//out.print("<Br>");
		costheadsubgroup_id[i] = request.getParameter("costheadsubgroup_id"+i);
//		out.print("&nbsp;"+costheadsubgroup_id[i]);
		costheadsubgroup_code[i]= request.getParameter("costheadsubgroup_code"+i);
//		out.print("&nbsp;");
		costheadsubgroup_name[i] = request.getParameter("costheadsubgroup_name"+i);
//		out.print("&nbsp;");
		costheadsubgroup_description[i] = request.getParameter("costheadsubgroup_description"+i);
		sr_no[i] = request.getParameter("sr_no"+i);	
//		out.print("&nbsp;");
	if("yes".equals(request.getParameter("active"+i)))
		{ active[i] =true; }
	}
//out.print("<BR>before query"+counter);
	for( int i=0; i < counter ; i++)
	{
	String query1 = "Update  Master_costheadsubgroup set  costheadsubgroup_Code=?,  costheadsubgroup_Name=?, costheadsubgroup_Description=?, sr_no=?, active=? where costheadsubgroup_Id=?";
//	out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,costheadsubgroup_code[i]);
//	out.print("setString1:"+costheadsubgroup_code[i]);
	pstmt_p.setString(2,costheadsubgroup_name[i]);	
	pstmt_p.setString(3,costheadsubgroup_description[i]);
	pstmt_p.setString(4,sr_no[i]);		
	pstmt_p.setBoolean(5,active[i]);		
	pstmt_p.setString(6,costheadsubgroup_id[i]);
	int a = pstmt_p.executeUpdate();
//	out.print("<br>159 a "+a);
	}
String costhead=A.getName(conp,"costheadgroup",costheadgroup_id);
//out.print("<br> 333 +"+A.getName("costheadgroup",costheadgroup_id));
	pstmt_p.close();
	C.returnConnection(conp);

response.sendRedirect("EditCostHeadSubGroup.jsp?command=edit&message=Cost Sub Head of "+costhead+" successfully updated.&costheadgroup_id="+costhead);
}
	catch(Exception e93)
	{ 
	out.println("<br><font color=red> FileName : GL_UpdateCategory.jsp <br>Bug No e93 :"+ e93 +"</font>");}
	
}//ifUpdateCategoryMaster
%>








