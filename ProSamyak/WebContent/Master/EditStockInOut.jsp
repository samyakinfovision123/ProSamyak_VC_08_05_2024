<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 

ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
	conp=C.getConnection();
	cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
String category_code= A.getNameCondition(conp,"Master_CompanyParty","Category_Code","where CompanyParty_Id ="+company_id);
//out.print("<br>30 category_code="+category_code);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
 //out.print("<br>command=" +command);
try{
%>
<html><head><title>Samyak Software</title>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}

//background='exambg.gif'
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<!--  -->
<%
if("StockInOutReport".equals(command))
{
String Receive_No=request.getParameter("Receive_No");
%>
<body  onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<table align=center bordercolor=skyblue border=0 cellspacing=0>
</td></tr>
<tr><td>
	<form action=EditStockInOut.jsp name=f1 method=post >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<%
if 	(Receive_No !=null){%>
<tr>
		<td colspan=6 align=center>
			<%
		out.println("<b><font color=#6600CC > Data successfully Updated for Stock Transfer "+Receive_No+"</bold></b>");
		%>
		<td>
		</tr>
<%}%>
	<tr bgcolor=skyblue><th colspan=2>
	Select Stock In-Out to Edit
	</th></tr>
	<tr><th>From</th>	<td align="center"><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td align="center"><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><td align=center colspan=2 >
	<input type=submit value='Edit Stock' name=command class='Button1' >
	<input type=hidden value='<%=category_code%>' name="category_code">
	<input type=hidden value='3' name="voucher_type">

</td>
</tr>
</table>
</form>			
<%

	C.returnConnection(conp);
	C.returnConnection(cong);

}//if SaleReport
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>
</BODY>
</HTML>
<%
try{

if("Edit Stock".equals(command))
	{

 
int dd1 = Integer.parseInt(request.getParameter("dd1"));
int mm1 = Integer.parseInt(request.getParameter("mm1"));
int yy1 = Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>101 D1=" +D1);
int dd2 = Integer.parseInt(request.getParameter("dd2"));
int mm2 = Integer.parseInt(request.getParameter("mm2"));
int yy2 = Integer.parseInt(request.getParameter("yy2"));
java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>D2=" +D2);
String party_id= request.getParameter("party_id");
String Category_Code= request.getParameter("category_code");
//out.print("<br>111 Category_Code="+Category_Code);
double total_saleaccount=0;
String type= request.getParameter("voucher_type");
//out.print("<br>type= " +type);
String voucher_name[]=new String[4];
voucher_name[3]="Stock Transfer"; 
//out.print("<br>party=" +party_id);
double local_tot=0;
double dollar_tot=0;
 double Qty_tot=0;
String query="";
//out.print("<br> type="+type);
if("3".equals(type))
		{
		query="Select * from Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId like "+company_id+" and Purchase=1 and (Receive_Sell=0 or StockTransfer_Type=7) and SalesPerson_Id<>-1 and Consignment_ReceiveId=0 and Active=1 order by Receive_date ,Receive_Id";
		}
//out.print("<br> query="+query);

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
//out.print("<br>After 120 query=");
	rs_g = pstmt_g.executeQuery();	

//out.print("<br>After 123 query=");
%>
<html><head><title>Samyak Software</title>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}
//background='exambg.gif'
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body  onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<table align=center border=0 cellspacing=0>
<tr><td>Company:<%=company_name%></td> 
<tr><td colspan=2>
<table align=center border=1 cellspacing=0>
<tr><th colspan=6>
Edit Stock In-Out Report </th>
<tr>
<th class='th4'>Sr No</th>
<th class='th4'>No</th>
<th class='th4'>Date</th>
<th class='th4'>Quantity  <br> (Source)</th>
<th class='th4'>Local Total (<%=local_symbol%>) <br> (Source)</th>
<th class='th4'>Dollar Total ($) <br> (Source)</th>
<input type=hidden name=voucher_type value="<%=type%>">
</tr>
<%
	//out.print("<br>155 type="+type);
int i=0;
	while(rs_g.next())
	{
	//System.out.println("160 inside Receive next**********");
	String receive_id= rs_g.getString("Receive_id");
	String voucher_no= rs_g.getString("Receive_no");
	String cgtRec_Id= rs_g.getString("Consignment_ReceiveId");
	boolean active=rs_g.getBoolean("Active");
	String voucher_id=A.getNameCondition(conp,"Voucher", "Voucher_id","Where Voucher_No='"+receive_id+"' and voucher_type=3");
	//out.print("<br>138 voucher_id"+voucher_id);
	String StockTransfer_Type=rs_g.getString("StockTransfer_Type");
//out.print("<br>138 StockTransfer_Type"+StockTransfer_Type);
	double Receive_Quantity=rs_g.getDouble("Receive_Quantity");
	double local=rs_g.getDouble("Local_Total");
	double dollar=rs_g.getDouble("Dollar_Total");
	%>
<tr >
<input type=hidden name=voucher_id<%=i%> value="<%=voucher_id%>">
<input type=hidden name=voucher_no value="<%=voucher_no%>">
<input type=hidden name=receive_id<%=i%> value="<%=receive_id%>">
<input type=hidden name="StockTransfer_Type<%=i%>" value="<%=StockTransfer_Type%>">
<td>
	<%=++i%></td>
<td><A href= "../Master/EditStock_InOutForm.jsp?Receive_Id=<%=receive_id%>&StockTransfer_Type=<%=StockTransfer_Type%>&voucher_no=<%=voucher_no%>&command=Default&mesage=Default" target=_self><%=voucher_no%></td></td>
<td><%=format.format(rs_g.getDate("Receive_Date"))%></td>
<td align=right><%=str.format(""+Receive_Quantity)%></td>
<%
 local_tot +=local;
 dollar_tot +=dollar;
 Qty_tot +=Receive_Quantity;
	%>
<td align=right><%=str.format(""+local,d)%></td>
<td align=right><%=str.format(""+dollar,3)%></td>
</tr>
<%
i++;
}
		pstmt_g.close();
%>
<input type=hidden name=counter value="<%=i%>">
<tr>
<TD align=right colspan=3 ><b>Total </b></td>
<TD align=right ><b> <%=str.format(""+Qty_tot,3)%> </b></td>
<TD align=right ><b> <%=str.format(""+local_tot,d)%> </b></td>
<TD align=right ><b> <%=str.format(""+dollar_tot,3)%> </b></td>

</tr>
<%

C.returnConnection(conp);
C.returnConnection(cong);

}//if Receive 
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>