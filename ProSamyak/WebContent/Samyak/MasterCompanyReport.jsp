
<%@ page language="java" 
import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Connect"/>

<%
Connection	conn=A.getConnection();
String query="";
PreparedStatement sqlStatement=null;
ResultSet rs=null;
String partyName="";
double purchaseLocal=0,purchaseDollar=0,saleLocal=0,saleDollar=0,pnLocal=0,pnDollar=0,pnDiff=0,saleDiff=0,purchaseDiff=0;
int transcurrency=0;
try{

query="select CompanyParty_Name,Purchase_AdvanceLocal,Purchase_AdvanceDollar,Sale_AdvanceLocal,Sale_AdvanceDollar,PN_AdvanceLocal,PN_AdvanceDollar,Transaction_Currency from Master_CompanyParty  where Super=0  order by CompanyParty_Name";
sqlStatement=conn.prepareStatement(query);
rs=sqlStatement.executeQuery();

%>
<html>
<head>
	<title>Master Company Party Cal.</title>
</head>

<body>
<form>
<table border=1 width="90%" cellspacing=0>
<tr>
	<td colspan=11 align=center>Company party Difference Report</td>
</tr>
<tr>
	<td>Company Party name</td>
	<td>Purchase_AdvanceLocal</td>
	<td>Purchase_AdvanceDollar</td>
	<td> Purchase Diff</td>
	<td>Sale_AdvanceLocal</td>
	<td>Sale_AdvanceDollar</td>
	<td>Sale Diff</td>
	<td>PN_AdvanceLocal</td>
	<td>PN_AdvanceDollar</td>
	<td>Pn DIff</td>
	<td>Transaction Currency</td>
</tr>
<%while(rs.next())
{
partyName=rs.getString("CompanyParty_Name");
purchaseLocal=rs.getDouble("Purchase_AdvanceLocal");
purchaseDollar=rs.getDouble("Purchase_AdvanceDollar");
saleLocal=rs.getDouble("Sale_AdvanceLocal");
saleDollar=rs.getDouble("Sale_AdvanceDollar");
pnLocal=rs.getDouble("PN_AdvanceLocal");
pnDollar=rs.getDouble("PN_AdvanceDollar");
transcurrency=rs.getInt("Transaction_Currency");
purchaseDiff=purchaseLocal-(purchaseDollar*7.8);
saleDiff=saleLocal-(saleDollar*7.8);
pnDiff=pnLocal-(pnDollar*7.8);

%>
<tr>
	<td><%=partyName%></td>
	<td><%=str.format(""+purchaseLocal,2)%></td>
	<td><%=str.format(""+(purchaseDollar * 7.8),2)%></td>
	<td><%=str.format(""+purchaseDiff,2)%></td>
	<td><%=str.format(""+saleLocal,2)%></td>
	<td><%=str.format(""+(saleDollar * 7.8),2)%></td>
	<td><%=str.format(""+saleDiff,2)%></td>
	<td><%=str.format(""+pnLocal,2)%></td>
	<td><%=str.format(""+(pnDollar * 7.8),2)%></td>
	<td><%=str.format(""+pnDiff,2)%></td>
	<%if(transcurrency ==0){%>
	<td>Dollar</td>
	<%}else{%>
	<td>Local</td>
	<%}%>
</tr>
	
<%
}
	}
catch(Exception e)
{out.print("Exception "+e);}
%>
</table>
</body>
</html>






