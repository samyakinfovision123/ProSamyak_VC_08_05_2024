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
/*try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}*/

try{
int current_id=0; 
int total_rows=0;

%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body>

<table align=center  border=1 cellspacing=0>
<tr> 
<th colspan=5>
Samyak Run 
</th>
</tr>
<tr>
<td>Voucher ID</td>
<td>Voucher No</td>
<td>Voucher Total</td>
<td>Voucher Local</td>
<td>Voucher Dollar</td>
</tr>
<%
cong=C.getConnection();
String query="Select * from Voucher where Voucher_Total=0 and (Voucher_type=1 or Voucher_type=2 or Voucher_type=3)";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=1;
while(rs_g.next()) 	
{
counter=counter+1;
}
//out.println("counter is="+counter);
String voucher_id[]= new String[counter];
String voucher_no[]= new String[counter];
int receive_currencyid[]= new int[counter];
double exchange_rate[]= new double[counter];
double receive_total[]= new double[counter];
double local_total[]=new double[counter];
double dollar_total[]=new double[counter];

int i=0;
query="Select * from Voucher where Voucher_Total=0";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
voucher_id[i]=rs_g.getString("Voucher_ID");
voucher_no[i]=rs_g.getString("Voucher_No");
//out.println("counter is="+counter+" voucher_id[i] "+voucher_id[i]+"voucher_no[i]  "+voucher_no[i]);
%>
<%
i=i+1;
}//while
out.println("<br>76counter"+counter);

for( i=0;i<counter-1;i++)
{
out.println("<br>voucher_no[i]"+i+" " +voucher_no[i]);
query="Select * from Receive where Receive_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,voucher_no[i]); 
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
receive_currencyid[i]=rs_g.getInt("Receive_CurrencyId");
exchange_rate[i]=rs_g.getFloat("Exchange_Rate");
receive_total[i]=rs_g.getFloat("Receive_Total");
local_total[i]=rs_g.getFloat("Local_Total");
dollar_total[i]=rs_g.getFloat("Dollar_Total");
}	
%>
<Tr>
<td><%=voucher_id[i]%></td>
<td><%=voucher_no[i]%></td>
<td><%=receive_currencyid[i]%></td>
<td><%=exchange_rate[i]%></td>
<td><%=receive_total[i]%></td>
<td><%=local_total[i]%></td>
<td><%=dollar_total[i]%></td>
</tr>
<%
}//for
out.println("<br>103");
boolean flag_currency=true;
for( i=0;i<counter-1;i++)
{
query="Update  Voucher  set Voucher_Total=?, Local_Total=?, Dollar_Total=?, Exchange_Rate=?, Voucher_Currency=? where Voucher_Id=? ";
out.print("<br> i"+i+" query" +query+"voucher_id[i]"+voucher_id[i]);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+receive_total[i]); 
pstmt_g.setString(2,""+local_total[i]); 
pstmt_g.setString(3,""+dollar_total[i]); 
pstmt_g.setString(4,""+exchange_rate[i]); 

if(receive_currencyid[i] == 0)
	{flag_currency=false;}
out.println("<br>flag_currency"+flag_currency);
pstmt_g.setBoolean (5,flag_currency);
pstmt_g.setString(6,voucher_id[i]); 
int a308 = pstmt_g.executeUpdate();
out.println("<br>a308"+a308);
pstmt_g.close();
}//for
out.println("<br>Update Successfully116");
%>


</body>
</html>
<%
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











