<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 

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
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

try{
int receive_id=0;
double receive_total=0; 
double  local_total=0;
double  dollar_total=0;
int Receive_CurrencyId=0;
double exchange_rate=0;

String query="Select * from Receive  where Receive_sell=1 and purchase=1 and Active=1 and Return=0 and Opening_Stock=0 and Receive_FromId<>company_id ";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;

while(rs_g.next()) 	
{
receive_total=rs_g.getDouble("Receive_Total");
receive_id=rs_g.getInt("Receive_Id");
/*
local_total=rs_g.getDouble("Local_Total");
dollar_total=rs_g.getDouble("Dollar_Total");
*/
exchange_rate=rs_g.getDouble("Receive_ExchangeRate");
 Receive_CurrencyId=rs_g.getInt("Receive_CurrencyId");

if(Receive_CurrencyId==0)
	{
	local_total=receive_total*exchange_rate;
	dollar_total=receive_total;
	}
else
	{
	dollar_total=receive_total/exchange_rate;
	local_total=receive_total;
	}

String updatequery="Update Receive set Local_Total="+local_total+" ,Dollar_Total="+dollar_total+" where Receive_id="+receive_id;
pstmt_p=conp.prepareStatement(updatequery);
int a62=pstmt_p.executeUpdate();
pstmt_p.close();

updatequery="Update Voucher set Local_Total="+local_total+" , Dollar_Total="+dollar_total+" where Voucher_No=?";
pstmt_p=conp.prepareStatement(updatequery);
pstmt_p.setString(1,""+receive_id);
//out.print("<br>67");
int a69=pstmt_p.executeUpdate();
//out.print("<br>69");
pstmt_p.close();

}
pstmt_g.close();
C.returnConnection(conp);
C.returnConnection(cong);

%>
<html>
	<head>
<title></title>
<script language="JavaScript">
function f1()
{
alert("Data Sucessfully Updated");
 window.close(); 
} 
</script>
	</head>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML>
<%
}catch(Exception e) { out.print(e); }
%>








