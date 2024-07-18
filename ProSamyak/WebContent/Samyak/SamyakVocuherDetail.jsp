<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
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
<body bgcolor=#AAD2FF onContextMenu="disrtclick()">
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
<table align=center  border=1 cellspacing=0 width=100%>
<tr>
<th>Sr No</th>
<th>voucher Type</th>
<th>No. of Records</th>
</tr>

<%
int totalcounter=0;
for (int i=1;i<=22;i++)
	{
String query="Select * from Voucher  where Voucher_type=? and Referance_Voucherid=0"; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+i); 
rs_g = pstmt_g.executeQuery();	
int vcounter=0;
while(rs_g.next()) 
{
vcounter=vcounter+1;
}
totalcounter=totalcounter+vcounter;
%>

<tr>
<th><%=i%></th>
<th><%=i%></th>
<th align=right><%=vcounter%> </th>
</tr>
<%
}
%>
<tr>
<th></th>
<th>Total</th>
<th align=right><%=totalcounter%></th>
</tr>


%>
</table>
</BODY>
</HTML>

<%
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











