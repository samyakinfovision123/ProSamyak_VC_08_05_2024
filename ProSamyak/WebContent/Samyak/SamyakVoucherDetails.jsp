<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}
%>

<html><head><title>Samyak vocuher Details - Samyak Software</title>
<script language="JavaScript">
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgcolor=#AAD2FF >
<%
try{
%>
<table align=center  border=1 cellspacing=0 width=60%>
<tr><td>
<table align=center  border=1 cellspacing=0 width=100%>
<tr> 
<th colspan=5>
Samyak Voucher Check </th>
</tr>
</table>
</td></tr>
<tr><td>
<table align=center  border=1 cellspacing=0 width=60%>
<tr>
<th>Sr No</th>
<th>Voucher Type</th>
<th>No.of <br>Records</th>
</tr>

<%
int totalcounter=0;
String voucher_name[]=new String[15];
voucher_name[0]=""; 
voucher_name[1]="Sales";  
voucher_name[2]="Purchase"; 
voucher_name[3]="Stock Transfer";
voucher_name[4]="Contra"; 
voucher_name[5]="Payment"; 
voucher_name[6]="Receipt";  voucher_name[7]="Journal";
voucher_name[8]="Sales Receipt"; 
voucher_name[9]="Purchase Payment"; 
voucher_name[10]="Purchase Return"; 
voucher_name[11]="Sales Return"; 
voucher_name[12]="PN Sales Receipt"; 
voucher_name[13]="PN Purchase Payment";
/* voucher_name[14]="Journal (Sales Receipt)"; 
voucher_name[15]="Journal (Purchase Payment)"; 
voucher_name[16]="Journal (Account)"; 
voucher_name[17]="Journal (Sale to sale)"; 
voucher_name[18]="Journal (Purchase to Purchase)"; 
voucher_name[19]="Journal (Sales Payment)"; 
voucher_name[20]="Journal (Purchase Receipt)"; 
voucher_name[21]="Journal (PN Payment)"; 
voucher_name[22]="Journal (PN Receipt)"; 
*/
for (int i=1;i<=13;i++)
	{
String query="Select * from Voucher  where Voucher_type=? and Referance_Voucherid=0 and active=1"; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+i); 
rs_g = pstmt_g.executeQuery();	
int vcounter=0;
while(rs_g.next()) 
{
vcounter=vcounter+1;
}
pstmt_g.close();
totalcounter=totalcounter+vcounter;
%>

<tr>
<th><%=i%></th>
<th align=left><%//=i%>&nbsp;<%=voucher_name[i]%></th>
<th align=right><%=vcounter%> </th>
</tr>
<%
}
%>
<tr>
<th colspan=2>Total</th>
<th align=right><%=totalcounter%></th>
</tr>



</table>
</BODY>
</HTML>

<%
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>









