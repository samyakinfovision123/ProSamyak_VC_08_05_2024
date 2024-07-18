<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
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

if("edit".equals(command))
{

//out.print("<br> command "+command);
	if(!("Default".equals(message)))
	{
		out.print("<br> "+message);
	}

String FB_Id=request.getParameter("FB_Id");

String query="select * from ForwardBooking where FB_Id="+FB_Id;
pstmt_p=conp.prepareStatement(query);

rs_p=pstmt_p.executeQuery();
String FB_No="";
String Ref_No="";
String Booking_Date="";
String From_Date="";
String To_Date="";
String Original_Amount="";
String Used_Amount="";
String Pending_Amount="";
String Booked_ExchangeRate="";
String Bank_Name="";
String Description="";
while(rs_p.next())
	{
		FB_No=rs_p.getString("FB_No");
		Ref_No=rs_p.getString("Ref_No");
		Booking_Date=format.format(rs_p.getDate("Booking_Date"));
		From_Date=format.format(rs_p.getDate("From_Date"));
		To_Date=format.format(rs_p.getDate("To_Date"));
		Original_Amount=rs_p.getString("Original_Amount");
		Used_Amount=rs_p.getString("Used_Amount");
		Pending_Amount=rs_p.getString("Pending_Amount");
		Booked_ExchangeRate=rs_p.getString("Booked_ExchangeRate");
		Bank_Name=rs_p.getString("Bank_Name");
		Description=rs_p.getString("Description");
	}
	pstmt_p.close();

%>

<html>
<head>
	<title>Samyak Software</title>
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>

<script language=javascript>
	function nullvalidation(name)
	{
		if(name.value=="")
		{
			alert("Please Enter Value");
			name.focus();
		}
	}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee background="../Buttons/BGCOLOR.JPG">
<form action="EditForwardBookingUpdate.jsp" name=mainform  method=post>
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=10> Edit Forward Booking</th></tr>
<tr>
<td>Entry No</td>
<td><input type=text name=FB_Id size=5 onBlur='return nullvalidation(this)' value="<%=FB_Id%>" readonly style="text-align:right"></td>
</tr>

<tr>
<td>Deal No</td>
<td><input type=text name=FB_No size=5 onBlur='return nullvalidation(this)' value="<%=FB_No%>"></td>
</tr>
<tr>
	<td>Reference No.</td>
	<td><input type=text name=Ref_No size=5 value="<%=Ref_No%>"></td>
</tr>
<tr>
<td colspan=2 align=left><!-- Date --> <input type=text name='Booking_Date' size=8 maxlength=10 value="<%=Booking_Date%>"
onblur='return  fnCheckMultiDate(this,"Date")'>	
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.Booking_Date, \"dd/mm/yyyy\")' value='Booking Date' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script> 
</td>
</tr>
<tr>
	<td>Rate of Booking</td>
	<td><input type=text name="Booked_ExchangeRate" value="<%=str.mathformat(Booked_ExchangeRate,2)%>" size="7" style="text-align:right"></td>
</tr>
<tr>
	<td>Amount Booked</td>
	<td><input type=text name="Original_Amount" value="<%=str.mathformat(Original_Amount,2)%>" size=7 style="text-align:right" onblur="validate(this,2)"></td>
</tr>
<tr>
<td colspan=2 align=left><!-- Date --> <input type=text name='From_Date' size=8 maxlength=10 value="<%=From_Date%>"
onblur='return  fnCheckMultiDate(this,"Date")'>	
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.From_Date, \"dd/mm/yyyy\")' value='Booked From' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script> 
</td>	
</tr>

<tr>
<td colspan=2 align=left><!-- Date --> <input type=text name='To_Date' size=8 maxlength=10 value="<%=To_Date%>"
onblur='return  fnCheckMultiDate(this,"Date")'>	
<script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.To_Date, \"dd/mm/yyyy\")' value='Booked To' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script> 
</td>	
</tr>
<tr>
	<td>Bank Name</td>
	<td><%=A.getMasterArrayCondition(conp,"Account","Bank_Name",Bank_Name,"Where AccountType_Id=1",company_id)%></td>
</tr>
<tr>
	<td>Description</td>
	<td><input type=text name=Description value="<%=Description%>"></td>
</tr>

<tr>
	<td colspan=2 align=center><input type=submit name="command" value="Update" class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
</tr>
</table>
</form>
</body>
</html>




<%
C.returnConnection(conp);
}
}catch(Exception e) { out.print("<br> EditForwardBooking.jsp Bug::-- "+e); }

%>






