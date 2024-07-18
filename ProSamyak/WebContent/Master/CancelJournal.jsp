<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
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
String voucher_name7="Journal";
String voucher_name77="Set-Off Journal";




String desc="";
double local=0;
double dollar=0;
double local_tot=0;
double dollar_tot=0;
String query="";
if("7".equals(type))
	{
	query="Select * from Voucher as V where   V.Voucher_Date between ? and ? and V.Company_id=? and V.Referance_VoucherId=0 and V.voucher_type=? and V.Active=1 and V.Voucher_Id NOT IN (Select Voucher_Id from Payment_Details)  order by V.Voucher_Date, V.Voucher_No";
	}

if("77".equals(type))
	{
	query="Select * from Voucher as V where   V.Voucher_Date between ? and ? and V.Company_id=? and V.Referance_VoucherId=0 and V.voucher_type=? and V.Active=1 and V.Voucher_Id IN (Select Voucher_Id from Payment_Details)  order by V.Voucher_Date, V.Voucher_No";
	}

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);
pstmt_g.setString(3,company_id); 
pstmt_g.setString(4,"7"); //Voucher type is same for both set-off journal and journal
rs_g = pstmt_g.executeQuery();	
	
%>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=white background="../Buttons/BGCOLOR.JPG" >
<form action=CancelJournal1.jsp name=f1 method=post >

<table align=center bordercolor=skyblue border=0 cellspacing=0 width="100%">
<tr><td colspan=2><%=company_name%></td> </tr>
<tr><td colspan=2>
<table align=right  border=1 cellspacing=0 width="90%">
<tr bgcolor="skyblue"><th colspan=6>Cancel 
	<%if("7".equals(type))
		{out.print(voucher_name7);}
	  if("77".equals(type))
		{out.print(voucher_name77);}
	%> Voucher </th></tr>
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
<TD><a href="../Report/Printvoucher1.jsp?voucher_type=7&voucher_id=<%=Voucher_id%> " target=_blank> <%=rs_g.getString("Voucher_No")%></a></td>
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









