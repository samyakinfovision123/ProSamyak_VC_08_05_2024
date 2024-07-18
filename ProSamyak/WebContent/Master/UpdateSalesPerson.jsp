<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="L" class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String user_level= ""+session.getValue("user_level");
String yearend_id= ""+session.getValue("yearend_id");
String machine_name=request.getRemoteHost();

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
//out.println("command"+command);

//System.out.println("Inside Updeate Account");
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	

if("Save".equals(command))
{
try{
	conp=C.getConnection();
//out.print("Command is "+command);
String salesperson_name=request.getParameter("salesperson_name");	
String address1=request.getParameter("address1");	
String address2=request.getParameter("address2");	
String address3=request.getParameter("address3");	
String city=request.getParameter("city");	
String pin=request.getParameter("pin");	
String country=request.getParameter("country");	
String mobile=request.getParameter("mobile");	
String phone_o=request.getParameter("phone_o");	
String phone_r=request.getParameter("phone_r");	
String fax=request.getParameter("fax");	
String email=request.getParameter("email");
String commission=request.getParameter("commission");
String message=request.getParameter("message");
//out.println("<br>69 message="+message);
String purchasesale="";
String selectquery="";
if("Sale".equals(message))
{
selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and purchaseSale=0 and  company_id="+company_id;
}
if("Purchase".equals(message))
{
selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and purchaseSale=1 and company_id="+company_id;
}
if("Broker".equals(message))
{
selectquery="Select * from Master_SalesPerson where SalesPerson_name='"+salesperson_name+"' and  purchaseSale=2 and company_id="+company_id;
}


//out.println("<br>69"+selectquery);
pstmt_p = conp.prepareStatement(selectquery);

rs_g = pstmt_p.executeQuery();	
int i=0;
//out.println("<br>74 query Executed"+selectquery);
while(rs_g.next()){i++;}
pstmt_p.close();
if(i<1)
{
String salesperson_id= ""+L.get_master_id(conp,"Master_SalesPerson");

String query = "INSERT INTO Master_SalesPerson( SalesPerson_Id, Company_Id, SalesPerson_Name, Address1,Address2, Address3, City,Pin,Country,Mobile,Phone_O,Phone_R,Fax,Email,Modified_On, Modified_By, Modified_MachineName,Sr_No,YearEnd_Id,Commission,PurchaseSale)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,'"+format.getDate(today_string)+"',?,?,?,?,?,?)";

//total columns = 17
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+salesperson_id);		
//out.print("<br> salesperson_id"+salesperson_id);	
pstmt_p.setString (2,""+company_id);
//out.print("<br> company_id"+company_id);	
pstmt_p.setString (3,""+salesperson_name);
//out.print("<br> salesperson_name"+salesperson_name);	
pstmt_p.setString (4,""+address1);
//out.print("<br> address1"+address1);	
pstmt_p.setString (5,""+address2);
//out.print("<br> address1"+address2);	
pstmt_p.setString (6,""+address3);
//out.print("<br> address3"+address3);	
pstmt_p.setString (7,""+city);
//out.print("<br> city"+city);	
pstmt_p.setString (8,""+pin);
//out.print("<br> pin"+pin);	
pstmt_p.setString (9,""+country);
//out.print("<br> country"+country);	
pstmt_p.setString (10,""+mobile);
//out.print("<br> mobile"+mobile);	
pstmt_p.setString (11,""+phone_o);
//out.print("<br> phone_o"+phone_o);	
pstmt_p.setString (12,""+phone_r);
//out.print("<br> phone_r"+phone_r);	
pstmt_p.setString (13,""+fax);
//out.print("<br> fax"+fax);	
pstmt_p.setString (14,""+email);
//out.print("<br> email"+email);	
//out.print("<br> today_string"+today_string);	
pstmt_p.setString (15, user_id);
//out.print("<br> user_id"+user_id);			
pstmt_p.setString (16, machine_name);
//out.print("<br> machine_name"+machine_name);	
pstmt_p.setString (17,""+salesperson_id);		
//out.print("<br> sr_no"+salesperson_id);	
pstmt_p.setString(18,yearend_id);
pstmt_p.setString(19,commission);
if("Sale".equals(message))
{
pstmt_p.setString(20,"0");
}
if("Purchase".equals(message))
{
pstmt_p.setString(20,"1");
}
if("Broker".equals(message))
{
pstmt_p.setString(20,"2");
}
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();

//out.println("After query result a is "+a);
C.returnConnection(conp);
if("Sale".equals(message))
{
	response.sendRedirect("SalesPerson.jsp?command=Default&message=Sale&message1=Sale Person <font color=blue> "+salesperson_name+"</font>Successfully Saved.");
}
else
	{}
if("Purchase".equals(message))
	{
	out.print("<br> "+message);
response.sendRedirect("SalesPerson.jsp?command=Default&message=Purchase&message1=Purchase Person <font color=blue> "+salesperson_name+" </font>Successfully Saved.");
}
else
	{}
if("Broker".equals(message))
{
response.sendRedirect("SalesPerson.jsp?command=Default&message=Broker&message1=Broker Person<font color=blue>"+salesperson_name+" </font>Successfully Saved.");
}
else
	{}
}
else
{
	C.returnConnection(conp);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background='../Buttons/BGCOLOR.JPG' ><center><font color=red><h2>"+message+"  Person <font color=blue> "+salesperson_name+"</font> Already Exists.</h2><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");
}//if end
}catch(Exception Samyak101){ 
out.println("<br><font color=red><h2> FileName : UpdateSalesPerson.jsp <br>Bug No Samyak101 :"+ Samyak101 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}
}//if SUBMIT
%>








