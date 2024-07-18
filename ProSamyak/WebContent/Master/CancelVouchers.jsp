<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"  class="NipponBean.login" />
<jsp:useBean id="A"  class="NipponBean.Array" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect"/>
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;

try	
{
	cong=C.getConnection();
}
catch(Exception e31)
{ 
	out.println("<font color=red> FileName : EditVouchers.jsp<br>Bug No e31 : "+ e31);
}


String company_name= A.getName(cong,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


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
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}

function selectActionPage() 
{
	if(document.InventoryForm.voucher_type.value == 2)
	{
		document.InventoryForm.action="CancelPurchase.jsp";
	}
	if(document.InventoryForm.voucher_type.value == 1)
	{
		document.InventoryForm.action="CancelSale.jsp";
	}
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">

<form action="CancelVouchers.jsp" name=f1  >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Cancel Vouchers 
	</th></tr>
	<tr><th>From</th>	<td><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Voucher Type&nbsp;&nbsp;</th>
	<td><Select name=voucher_type >
	<option value='4'>Contra</option>
	<option value='5'>Payment</option>
	<option value='6'>Receipt</option>
	<option value='8'>Sales Receipt</option>
	<option value='9'>Purchase Payment</option>
 	<option value='12'>PN Sales Receipt</option>
	<option value='13'>PN Purchase Payment</option>
 	</select></td></tr>
	<tr><td align=center colspan=2>
	<input type=submit value='Next' name=command class='Button1' >
</td></tr>
	</table>
	</form>			


<form action="CancelJournal.jsp" name="JournalForm">
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Cancel Journals
	</th></tr>
	<tr><th>From</th>	<td><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Voucher Type&nbsp;&nbsp;</th>
	<td><Select name=voucher_type >
	<option value='7'>Journal</option>
	<option value='77'>Set-Off Journal</option>
 	</select></td></tr>
	<tr><td align=center colspan=2>
	<input type=submit value='Next' name=command class='Button1' >
</td></tr>
	</table>
	</form>		


<form action = 'CancelInventoryVouchers.jsp' name="InventoryForm" onsubmit="selectActionPage();" >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Cancel Inventory Vouchers 
	</th></tr>
	
	<tr><th>From</th>	<td><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Voucher Type&nbsp;&nbsp;</th>
	<td><Select name=voucher_type onchange="selectActionPage();">
	<option value='1'>Sales</option>
	<option value='2'>Purchase</option>
	<option value='11'>Sales Return</option>
	<option value='10'>Purchase Return</option>
    <!--Below transfer have the value field values that are not actually the voucher type values in Master_Voucher table-->
	<option value='3'>Stock Transfer</option>
	<option value='98'>Split</option>
	<option value='99'>Warehouse Transfer</option>
	<option value='100'>Reverse Warehouse Transfer</option>
 	</select></td></tr>
<tr><th>Account</th><TD>
	<%=A.getMasterArrayAll(cong,"Companyparty","party_id","",company_id)%> </td></tr>
	<input type=hidden name=receive_id value='0'>
	<tr><td align=center colspan=2>
	<input type=submit value='Next' name=command class='Button1' >
</td></tr>
	</table>
	</form>			

<%
C.returnConnection(cong);


}//if Default



}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>
<%


try{
if("Next".equals(command))
{

//out.println("Inside Next");
//java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

int dd1 = Integer.parseInt(request.getParameter("dd1"));
int mm1 = Integer.parseInt(request.getParameter("mm1"));
int yy1 = Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>D1=" +D1);
int dd2 = Integer.parseInt(request.getParameter("dd2"));
int mm2 = Integer.parseInt(request.getParameter("mm2"));
int yy2 = Integer.parseInt(request.getParameter("yy2"));
java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>D2=" +D2);
String type=request.getParameter("voucher_type");
String voucher_name[]=new String[14];
voucher_name[0]=""; 
voucher_name[1]="Sale Invoice"; 
voucher_name[2]="Purchase Invoice"; 
voucher_name[3]="Stock Transfer"; 
voucher_name[4]="Contra"; 
voucher_name[5]="Payment"; 
voucher_name[6]="Receipt";
voucher_name[7]="Journal";
voucher_name[8]="Sales Receipt"; 
voucher_name[9]="Purchase Payment"; 
voucher_name[10]="Purchase Return";
voucher_name[11]="Sales Return"; 
voucher_name[12]="PN Sales Receipt"; 
voucher_name[13]="PN Purchase Payment"; 



String desc="";
double local=0;
double dollar=0;
double local_tot=0;
double dollar_tot=0;
String query="Select * from Voucher where   Voucher_Date between ? and ? and Company_id=? and Referance_VoucherId=0 and voucher_type=? and Active=1 order by Voucher_Date,Voucher_No";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setDate(2,D2);
pstmt_g.setString(3,company_id); 
pstmt_g.setString(4,type); 
rs_g = pstmt_g.executeQuery();	
	
%>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=white background="../Buttons/BGCOLOR.JPG" >
<form action=Cancelvoucher1.jsp name=f1 method=post >

<table align=center bordercolor=skyblue border=0 cellspacing=0 width="100%">
<tr><td colspan=2><%=company_name%></td> </tr>
<tr><td colspan=2>
<table align=right  border=1 cellspacing=0 width="90%">
<tr bgcolor="skyblue"><th colspan=6>Cancel <%=voucher_name[Integer.parseInt(type)]%> Voucher </th></tr>
<tr><th colspan=5>From  <%=format.format(D1)%> -To <%=format.format(D2)%> </th></tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 -->
<tr>
<th align=left width='10%'>Sr No</th> 
<th align=left width='15%'>Voucher No</th> 
<th width='10%'>Date</th> 
 <th align=right width='20%'> Amount(<%=local_symbol%>)</th> 
<th width='45%'>&nbsp;&nbsp;Narration</th> 

<input type=hidden name=voucher_type value="<%=type%>">
</tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 -->
<%
int m=1;
int i=0;
while(rs_g.next())
		{
String Voucher_id=rs_g.getString("Voucher_id");
boolean active=rs_g.getBoolean("Active");
String st="checked";
String old="";
if(active){st=""; old="active";}
%>
<tr>
<input type=hidden name=voucher_id<%=i%> value="<%=Voucher_id%>">
<input type=hidden name=old<%=i%> value="<%=old%>">

<TD><input type=checkbox name=cancel<%=i%> value=yes <%=st%>>  <%=m++%></td>
<TD><a href="../Report/Printvoucher1.jsp?voucher_type=<%=type%>&voucher_id=<%=Voucher_id%> " target=_blank> <%=rs_g.getString("Voucher_No")%></a></td>
<TD align=center> <%=format.format(rs_g.getDate("Voucher_Date"))%> </td>

<%
 local=rs_g.getDouble("Local_Total");
 dollar=rs_g.getDouble("Dollar_Total");
 local_tot +=local;
 dollar_tot +=dollar;
 String description=rs_g.getString("Description");
 if(rs_g.wasNull()){desc="";}
	%>
<TD align=right><%=str.format(""+local,d)%></td>
<!-- <TD align=right><%=str.format(""+dollar,2)%></td> -->
 <TD>&nbsp;&nbsp;<%=description%></td>
</tr>
<%
i++;
}
		pstmt_g.close();
%>
<input type=hidden name=counter value="<%=i%>">

<!-- <tr><td colspan=8> <hr></td></tr>
 --><tr>
<TD align=right colspan=4><b>Total&nbsp;&nbsp; <%=str.format(""+local_tot,d)%> </b></td>
<td>&nbsp;</td>
</tr>
<tr><td align=center colspan=5>
	<input type=submit value='Update' name=command class='Button1' >
</td></tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 --></table>

<tr><td colspan=2 align=right><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>
</form>
<%
	C.returnConnection(cong);

}//if Next 


}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>









