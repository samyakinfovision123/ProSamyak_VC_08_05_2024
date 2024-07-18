<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<html>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</head>

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
ResultSet rs_p= null;

Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

try	
{

conp=C.getConnection();


}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditVouchers.jsp<br>Bug No e31 : "+ e31);}


String company_name= A.getName(conp,"companyparty",company_id);

String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_date=format.format(D);
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
String message=request.getParameter("message"); 
try
{
if("Update".equals(command))
{
 
//out.print("<br> command "+command);
String FB_Id=request.getParameter("FB_Id");
String FB_No=request.getParameter("FB_No");
String Ref_No=request.getParameter("Ref_No");
String Booking_Date=request.getParameter("Booking_Date");
String From_Date=request.getParameter("From_Date");
String To_Date=request.getParameter("To_Date");
String Original_Amount=request.getParameter("Original_Amount");
String Booked_ExchangeRate=request.getParameter("Booked_ExchangeRate");
String Bank_Name=request.getParameter("Bank_Name");
String Description=request.getParameter("Description");

int FB_count=0;

String query="select count(*)  as counter from ForwardBooking where FB_No='"+FB_No+"' and FB_Id <>"+FB_Id;

pstmt_p=conp.prepareStatement(query);
rs_p = pstmt_p.executeQuery();
while(rs_p.next())
	{
		FB_count=rs_p.getInt("counter");
	}
pstmt_p.close();
//out.print("<br> FB_count"+FB_count);
if(FB_count > 0)
	{
	
	
	C.returnConnection(conp);
%>
<body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
	<%
out.print("<br><center><font color=red>Deal No "+FB_No+ " already exist. </center>");
out.print("<br><center><input type=button  class='button1' name=command value=BACK onClick='history.go(-1)' ></center>");	}
else
	{

query="Update ForwardBooking set FB_No=?, Ref_No=?, Booking_Date=?, From_Date=?, To_Date=?, Original_Amount=?, Booked_ExchangeRate=?,Pending_Amount=?, Bank_Name=?, Description=? where FB_Id="+FB_Id;

pstmt_p=conp.prepareStatement(query);

pstmt_p.setString(1,FB_No);
pstmt_p.setString(2,Ref_No);
pstmt_p.setString(3,""+format.getDate(Booking_Date));
pstmt_p.setString(4,From_Date);

pstmt_p.setString(5,To_Date);
pstmt_p.setString(6,Original_Amount);
pstmt_p.setString(7,Booked_ExchangeRate);
pstmt_p.setString(8,Original_Amount);
pstmt_p.setString(9,Bank_Name);

pstmt_p.setString(10,Description);

int a72=pstmt_p.executeUpdate();
pstmt_p.close();
C.returnConnection(conp);

//out.print("<br> a72= "+a72);

response.sendRedirect("EditForwardBooking.jsp?command=edit&message=Default");
}//if FB_No not present
}

}catch(Exception e) { out.print("<br>EditForwardBookingUpdate.jsp Bug::-- "+e); }
%>



</html>



