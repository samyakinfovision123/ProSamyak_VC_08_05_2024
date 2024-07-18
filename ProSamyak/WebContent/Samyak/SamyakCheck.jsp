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


%>
<html><head><title>Samyak Check - Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
window.event.returnValue=0;
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgcolor=#AAD2FF onContextMenu="disrtclick()">

<%
try{
String command = request.getParameter("command");
//out.println("command "+command);
String company_id=request.getParameter("company_id");
String condition="";
int dd1 = 01;
//Integer.parseInt(request.getParameter("dd1"));
int mm1 = 4;
//Integer.parseInt(request.getParameter("mm1"));
int yy1 = 2004;
//Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>From " +format.format(D1));
int dd2 = 31;
//Integer.parseInt(request.getParameter("dd2"));
int mm2 = 3;
//Integer.parseInt(request.getParameter("mm2"));
int yy2 = 2005;
//Integer.parseInt(request.getParameter("yy2"));
java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>To " +format.format(D2));
String query="";
int Rcounter=0;
int Rcounter1=0;
int Vcounter=0;
int Vcounter1=0;
int Pcounter=0;
int Pcounter1=0;


if("Samyak".equals(command))
{

int current_id=0; 
int total_rows=0;

%>
<table align=center  border=1 cellspacing=0 width=60%>
<tr><td>
<table align=center  border=1 cellspacing=0 width=100%>
<tr> 
<th colspan=5>
Samyak Check (<%= format.format(D1)%> - <%= format.format(D2)%> )
</th>
</tr>
</table>
</td></tr>
<tr><td>
<table align=center  border=1 cellspacing=0 width=100%>
<tr>
<th>Sr No</th>
<th>Table Name</th>
<th>Current Id</th>
<th>Last Row No</th>
<th>Difference</th>
</tr>

<%
current_id= L.get_master_id("Master_CompanyParty","CompanyParty_Id");
total_rows=L.get_master_id("Master_CompanyParty");
%>
<tr>
<td align="right">1</td>
<td>Master_CompanyParty</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>

<%
current_id= L.get_master_id("Master_User","User_ID");
total_rows=L.get_master_id("Master_User");
%>
<tr>
<td align="right">2</td>
<td>Master_User</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>
	

<%
current_id= L.get_master_id("Lot","Lot_Id");
total_rows=L.get_master_id("Lot");
%>
<tr>
<td align="right">3</td>
<td>Lot</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>


<%
current_id= L.get_master_id("Receive","Receive_Id");
total_rows=L.get_master_id("Receive");
%>
<tr>
<td align="right">4</td>
<td>Receive</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>

<%
current_id= L.get_master_id("Receive_Transaction","ReceiveTransaction_Id");
total_rows=L.get_master_id("Receive_Transaction");
%>
<tr>
<td align="right">5</td>
<td>Receive Transaction</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>


<%
current_id= L.get_master_id("Voucher","Voucher_Id");
total_rows=L.get_master_id("Voucher");
%>
<tr>
<td align="right">6</td>
<td>voucher</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>

<%
current_id= L.get_master_id("Financial_Transaction","Tranasaction_Id");
total_rows=L.get_master_id("Financial_Transaction");
%>
<tr>
<td align="right">7</td>
<td>Financial_Transaction</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>

<%
current_id= L.get_master_id("Payment_Details","Payment_Id");
total_rows=L.get_master_id("Payment_Details");
%>
<tr>
<td align="right">8</td>
<td>Payment_Details</td>
<td align="right"><%=current_id%></td>
<td align="right"><%=total_rows%></td>
<td align="right"><%=(current_id-total_rows)%></td>
</tr>

</table>
</td></tr>
<tr><td>
<%
String company_namex="";
if("".equals(company_id))
{company_namex="ALL";}
else{company_namex= A.getName("companyparty",company_id);}
%>
<table align=center  border=1 cellspacing=0 width=100%>
<tr><th colspan=5 ><font color=blue> Company :- <%=company_namex%></font></th></tr>
<tr>
<th width=10%>Sr No</th>
<th width=30%>Table</th>
<th width=20% align=right>Between</th>
<th width=20% align=right>All</th>
<th width=20% align=right>Difference</th>
</tr>

<%
if("".equals(company_id))
{condition="";}
else{condition="and company_id="+company_id+"";}
try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

query="Select * from Receive where Receive_Date between ? and ? "+condition+""; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Rcounter1=0;
while(rs_g.next()) 
{
Rcounter1=Rcounter1+1;
}
%>

<%
if("".equals(company_id))
{query="Select * from Receive"; }
else{ query="Select * from Receive where company_id="+company_id ;}
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Rcounter=0;
while(rs_g.next()) 
{
Rcounter=Rcounter+1;
}
%>
<tr>
<td align="right">1</td>
<td>Receive</td>
<td align="right"><%=Rcounter1%></td>
<td align="right"><%=Rcounter%></td>
<td align="right">

<%
if ((Rcounter1-Rcounter)!=0) 
{ %>
	<font color=red><b><%=(Rcounter1-Rcounter)%></b></font>
  <% } else {	%>
  <%=(Rcounter1-Rcounter)%> 
<% } %>
</td>
</tr>

<%
query="Select * from Voucher where Voucher_Date between ? and ? "+condition+""; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Vcounter1=0;
while(rs_g.next()) 
{
Vcounter1=Vcounter1+1;
}
pstmt_g.close();
C.returnConnection(cong);
%>

<%
if("".equals(company_id))
{query="Select * from Voucher"; }
else{
	try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}
query="Select * from Voucher  where company_id="+company_id ;
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Vcounter=0;
while(rs_g.next()) 
{
Vcounter=Vcounter+1;
}
%>
<% } %>

<tr>
<td align="right">2</td>
<td>Voucher</td>
<td align="right"><%=Vcounter1%></td>
<td align="right"><%=Vcounter%></td>
<td align="right">

<%
if ((Vcounter1-Vcounter)!=0) 
{ %>
	<font color=red><b><%=(Vcounter1-Vcounter)%></b></font>
  <% } else {	%>
  <%=(Vcounter1-Vcounter)%> 
<% } %>
</td>
</tr>

<%
query="Select * from Payment_Details where Transaction_Date between ? and ? "+condition+""; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Pcounter1=0;
while(rs_g.next()) 
{
Pcounter1=Pcounter1+1;
}
%>

<%
if("".equals(company_id))
{query="Select * from Payment_Details"; }
else{ query="Select * from Payment_Details  where company_id="+company_id ;
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);
//pstmt_g.setString(3,company_id); 
rs_g = pstmt_g.executeQuery();	
Pcounter=0;
while(rs_g.next()) 
{
Pcounter=Pcounter+1;
}
%>

<% } %>
<tr>
<td align="right">3</td>
<td>Payment Details</td>
<td align="right"><%=Pcounter1%></td>
<td align="right"><%=Pcounter%></td>
<td align="right">

<%
if ((Pcounter1-Pcounter)!=0) 
{ %>
	<font color=red><b><%=(Pcounter1-Pcounter)%></b></font>
  <% } else {	%>
  <%=(Pcounter1-Pcounter)%> 
<% } %>
</td>
</tr>

</table>
<%
C.returnConnection(cong);
}//if "Samyak".equals(command)


if("SuperCompany".equals(command))
{
	try	{cong=C.getConnection();
	}
	catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

String CompanyQuery = "select * from Master_CompanyParty where Super=true ";
	pstmt_g  = cong.prepareStatement(CompanyQuery);
	rs_g = pstmt_g.executeQuery();
	int counter =0;
	while(rs_g.next())
	{counter++;}
//	out.println(counter);
	pstmt_g.close();
	int m =0;
	String Scompany_id[]=new String[counter] ;
	String company_name[]=new String[counter] ;
	pstmt_g  = cong.prepareStatement(CompanyQuery);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
		{
		Scompany_id[m]= rs_g.getString("CompanyParty_Id");
		company_name[m]=rs_g.getString("CompanyParty_Name");
		m++;
		}
	pstmt_g.close();
	C.returnConnection(cong);
%>
<table align=center border=1 cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4>Details of Master Companies (<%=counter%>)</th>
</tr>

<tr>
<th>Sr No </th>
<th>Company Name</th>
<th>Company Id</th>
<th>Receive Voucher check</th>

</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>
<td><a href='../Samyak/SamyakCheck.jsp?command=Samyak&company_id=<%=Scompany_id[m]%>'>
<%=company_name[m]%></a></td>
<td><%=Scompany_id[m]%></td>
<td>
<a href='../Samyak/SamyakSaleReport.jsp?company_id=<%=Scompany_id[m]%>'>Check</a></td>
</tr>
<%
}// endof for m loop

%>
</table>
<% } //("SuperCompany".equals(command))


%>

</BODY>
</HTML>
<%
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











