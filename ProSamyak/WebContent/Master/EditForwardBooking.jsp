<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
cong=C.getConnection();
conp=C.getConnection();
	}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditVouchers.jsp<br>Bug No e31 : "+ e31);}

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
String message=request.getParameter("message"); 

try{
if("edit".equals(command))
	{
	if( ! ("Default".equals (message) ) )
		{
		out.print("<br>"+message);
		}%>
	
<html>
<head>
	<title>Samyak Software</title>
<script language="JavaScript">
	function disrtclick()
{
//window.event.returnValue=0;
}
</script>
</head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<form action="EditForwardBooking.jsp" name=f1  >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2> Edit Forward Bookings</th></tr>
	<tr><th>Bank</th>	<td><%=A.getArrayConditionAll(conp,"Master_Account","account_id","","Where AccountType_Id=1 and company_id="+company_id,"Account_Id","Account_Name")%>
</td></tr>
	<tr><th>Expiring on or before</th>	<td><%=L.date(D,"dd1","mm1","yy1")  %></td></tr>
	<tr><td align=center colspan=2>
	<input type=submit value='Next' name=command class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
</td></tr>
	</table>
	</form>			

</body>
</html>
<%	
C.returnConnection(conp);
C.returnConnection(cong);

}//end command
}catch(Exception e) { out.print("<br>EditForwardBooking.jsp Bug ::--- "+e);}

try{
if("Next".equals(command))
{
 String account_id=request.getParameter("account_id");
String condition="";
if(!("0".equals(account_id)))
	{
	condition=" and Bank_Name="+account_id;
	}
//out.print("<br> 78 account_id "+account_id);
int dd1 = Integer.parseInt(request.getParameter("dd1"));
int mm1 = Integer.parseInt(request.getParameter("mm1"));
int yy1 = Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);

String exp_date=format.format(D1);
//out.print("<br> 85  exp_date "+exp_date);

int counter=0;

String query="select count(FB_Id) as counter from ForwardBooking where To_Date<=? and company_id="+company_id+""+condition;

pstmt_p=conp.prepareStatement(query);

pstmt_p.setString(1,""+D1);

rs_p=pstmt_p.executeQuery();

while(rs_p.next())
	{
		counter=rs_p.getInt("counter");
	}
pstmt_p.close();
//out.print("<br> 89 counter = "+counter);

query="select * from ForwardBooking where To_Date<=? and company_id="+company_id+" and FB_Flag=0"+condition;

pstmt_p=conp.prepareStatement(query);


pstmt_p.setString(1,""+D1);
rs_p=pstmt_p.executeQuery();

%>
<html>
<head>
	<title>Samyak Software</title>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<form action="EditForwardBooking.jsp" name=f1  >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=10> Edit Forward Bookings</th></tr>
<th class='th4'>Sr. No.</th>
<th class='th4'>FB. No.</th>
<th class='th4'>Ref. No.</th>
<th class='th4'>Booking Date</th>
<th class='th4'>From Date</th>
<th class='th4'>To Date</th>
<th class='th4'>Booked Amount</th>
<!-- <th class='th4'>Pending Amount</th>-->
 <th class='th4'>Booked <br> Exchange Rate</th>
<th class='th4'>Bank Name</th>
<%
int i=0;
while(rs_p.next())
	{
String FB_Id=rs_p.getString("FB_Id");	

int pd_count=0;
String pd_query="select * from Payment_Details where FB_Id="+FB_Id+" and active=1";

pstmt_g=cong.prepareStatement(pd_query);

rs_g=pstmt_g.executeQuery();

	while(rs_g.next())
		{
			pd_count++;
		}
pstmt_g.close();
	if(pd_count==0)
		{
	%>
<tr>
	<td><%=i+1%></td>
	<td><a href="EditForwardBookingForm.jsp?command=edit&message=Default&FB_Id=<%=FB_Id%>"><%=rs_p.getString("FB_No")%></a></td>
	<td><%=rs_p.getString("Ref_No")%></td>
	<td><%=format.format(rs_p.getDate("Booking_Date"))%></td>
	<td><%=format.format(rs_p.getDate("From_Date"))%></td>
	<td><%=format.format(rs_p.getDate("To_Date"))%></td>
	<td align=right><%=str.format(rs_p.getString("Original_Amount"),2)%></td>
<!-- 	<td align=right><%//=str.format(rs_p.getString("Pending_Amount"),2)%></td>-->	
 <td align=right><%=str.format(rs_p.getString("Booked_ExchangeRate"),2)%> </td>
	<td><%=A.getNameCondition(conp,"Master_Account","Account_Name","where Account_Id="+rs_p.getString("Bank_Name"))%></td>
</tr>
<%
	i++;
		}
	}
pstmt_p.close();
C.returnConnection(conp);
C.returnConnection(cong);

%>


<%
}//end command=next

}catch(Exception e) { out.print("<br> ForwardBooking.jsp Bug::--  "+e); }  
%>






