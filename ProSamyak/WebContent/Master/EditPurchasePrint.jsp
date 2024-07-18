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
if("PurchaseReport".equals(command))
{

%>
<body  onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<table align=center bordercolor=skyblue border=0 cellspacing=0>

</td></tr>
<tr><td>
	<form action=EditPurchase.jsp name=f1 method=post >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Select Purchase to Edit
	</th></tr>
	<tr><th>From</th>	<td align="center"><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td align="center"><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Account</th>
    <TD align="center">   
<%=A.getMasterArrayAll(conp,"Companyparty","party_id","",company_id)%> </td></tr>
	<tr><td align=center colspan=2 >
	<input type=submit value='Edit Purchase' name=command class='Button1' >
	<input type=hidden value='<%=category_code%>' name="category_code">

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

if("Edit Purchase".equals(command))
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
//String Category_Code= request.getParameter("category_code");
//out.print("<br>111 Category_Code="+Category_Code);
double total_saleaccount=0;

//out.print("<br>party=" +party_id);
String query="";

if("0".equals(party_id))
{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=1  and Receive_Sell=1 and Active=1 and R_Return=0 and Opening_Stock=0  and Consignment_ReceiveId=0 order by Receive_Date,Receive_No,Receive_Id";
}
//receive=0 specifies that the receive is consignment receive
else{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=?  and Receive_FromId="+party_id+" and Purchase=1 and Receive_Sell=1 and Active=1 and R_Return=0 and Opening_Stock=0 and Consignment_ReceiveId=0 order by Receive_Date,Receive_No,Receive_Id";
}
//out.print("<br>112 query="+query);
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
//out.print("<br>After 120 query=");
	rs_g = pstmt_g.executeQuery();	

//out.print("<br>After 123 query=");
%>
<html><head><title>Samyak Software</title>
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
<!-- <td align=right>Run Date:<%=format.format(D)%></td> --><tr>
<tr><td colspan=2>
<table align=center border=1 cellspacing=0>
<tr><th colspan=13>
Edit Purchase Report </th>
<tr>
<th>Sr No</th>
<th>No</th>
<th>Ref.No</th>
<th>To</th>
<th>Purchase</th>
<th>Date</th>
<th>Lots</th>
<th>Due Date</th>
<th>Quantity</th>
<th>Local Total</th>
<th>C. Tax</th>
<th>Total</th>
<th>Dollar Total($)</th>
</tr>
<%
	int i=1;
double local_total=0; 
double tlocal_total=0; 
double tax_total=0; 
double dollar_total=0;
double reportcurrency_id=0;
double qty=0;
double tot_qty=0;
double local=0; 
double tlocal=0; 
double dollar=0; 
double tax=0;
double ctax_local=0;

	while(rs_g.next())
		{
String Receive_id =rs_g.getString("Receive_id");
boolean proactive = rs_g.getBoolean("ProActive");
int Iv_id=0;
int Fv_id=0;

boolean cashflag=false;
if(proactive)
{
String v_query="select Voucher_Id from Voucher where Voucher_No='"+Receive_id+"' and Voucher_Type=2 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Iv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();
v_query="select Voucher_Id from Voucher where Referance_VoucherId="+Iv_id+" and Voucher_Type=9 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Fv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();

	if(Fv_id>0)
	{
		cashflag=true;
	}

}
if((!proactive) || (proactive && cashflag))
	{
//	out.print("Inside if Dollar");

reportcurrency_id=rs_g.getDouble("Receive_CurrencyId");
String dispaly_bgcolor="yellow";
String display_sale="Import";
String receive_from=rs_g.getString("Receive_FromId");
if(receive_from.equals(company_id))
{}
else{
if(reportcurrency_id==0)
{
display_sale="Import";
dispaly_bgcolor="white";
}else 
{
display_sale="Local";
dispaly_bgcolor="silver";
}
if(reportcurrency_id==0)
{

%>
<%
String pdquery="select *  from Payment_Details where For_HeadId="+Receive_id+" and Active=1";
//out.print("<br>232 query= "+query);
pstmt_p=conp.prepareStatement(pdquery);
rs_p=pstmt_p.executeQuery();
double pdcount=0;
while(rs_p.next())
	{
		pdcount++;
	}
	pstmt_p.close();
if((pdcount==0) || (cashflag))
	{
%>
<tr >

<td>
	<%=i++%></td>
	<%
	if ("3".equals(category_code))
		{%>
<td><A href= "NewEditPurchaseFormPrint.jsp?command=pedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_blank>
	<%=rs_g.getString("Receive_no")%></a></td>

	<%}
	else{%>
<td><A href= "EditPurchaseForm.jsp?command=pedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_self>
	<%=rs_g.getString("Receive_no")%></a></td>
	
	<%}%>
<td><%=A.getNameCondition(conp,"Voucher","ref_no","where Voucher_No='"+Receive_id+"'")%></td>
<td><%=A.getName(conp,"CompanyParty",receive_from)%>  </td>
<td bgcolor=<%=dispaly_bgcolor%>><%=display_sale%></td>

<td><%=format.format(rs_g.getDate("Receive_Date"))%> </td>
<td><%=rs_g.getString("Receive_Lots")%></td>
<td><%=format.format(rs_g.getDate("Due_Date"))%></td>
<%
local=rs_g.getDouble("Local_Total");
dollar=rs_g.getDouble("Dollar_Total");
qty=rs_g.getDouble("Receive_Quantity");
tax=rs_g.getDouble("Tax");
tot_qty += qty;
local_total += local;
dollar_total += dollar;
ctax_local=local- local /((tax/100)+1);
tlocal=local-ctax_local;
tax_total +=ctax_local;
tlocal_total +=tlocal;
	%>
<td align=right> <%=str.format(""+qty,3)%></td>
<td align=right><%=str.format(""+tlocal,d)%></td>
<td align=right><%=str.format(""+ctax_local,d)%></td>
<td align=right><%=str.format(""+local,d)%></td>
<td align=right><%=str.format(""+dollar,2)%></td>

</tr>

<%	}//if pdcount==0
	}
		}//else
	}
	}
		pstmt_g.close();
		total_saleaccount +=tlocal_total;
	%>
<tr><td align=right colspan=8><b>Total</b></td>
<td align=right><%=str.format(""+tot_qty,3)%></td>
<td align=right><%=str.format(""+tlocal_total,d)%></td>
<td align=right><%=str.format(""+tax_total,d)%></td>
<td align=right><%=str.format(""+local_total,d)%></td>
<td align=right> <%=str.format(""+dollar_total,2)%></td>
</tr>
<%
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	
 local_total=0; 
tlocal_total=0; 
tax_total=0; 
dollar_total=0;
reportcurrency_id=0;
qty=0;
tot_qty=0;
local=0; 
tlocal=0; 
dollar=0; 
tax=0;
ctax_local=0;
while(rs_g.next())
{
String Receive_id =rs_g.getString("Receive_id");
boolean proactive = rs_g.getBoolean("ProActive");
int Iv_id=0;
int Fv_id=0;

boolean cashflag=false;
if(proactive)
{
String v_query="select Voucher_Id from Voucher where Voucher_No='"+Receive_id+"' and Voucher_Type=2 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Iv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();
v_query="select Voucher_Id from Voucher where Referance_VoucherId="+Iv_id+" and Voucher_Type=9 and Active=1";
pstmt_p=conp.prepareStatement(v_query);
rs_p=pstmt_p.executeQuery();
while(rs_p.next())
{Fv_id=rs_p.getInt("Voucher_Id");}
pstmt_p.close();

	if(Fv_id>0)
	{
		cashflag=true;
	}

}
if((!proactive) || (proactive && cashflag))
	{
reportcurrency_id=rs_g.getDouble("Receive_CurrencyId");
String dispaly_bgcolor="yellow";
String display_sale="Import";
String receive_from=rs_g.getString("Receive_FromId");
if(receive_from.equals(company_id))
{}
else{
if(reportcurrency_id==0)
{
display_sale="Import";
dispaly_bgcolor="white";
}else 
{
display_sale="Local";
dispaly_bgcolor="silver";
}
if(reportcurrency_id==0)
{}
else{
%>
<%
String pdquery="select *  from Payment_Details where For_HeadId="+Receive_id+" and Active=1";
//out.print("<br>232 query= "+query);
pstmt_p=conp.prepareStatement(pdquery);
rs_p=pstmt_p.executeQuery();
double pdcount=0;
while(rs_p.next())
	{
		pdcount++;
	}
	pstmt_p.close();
if((pdcount==0) || (cashflag))
	{
%>

<tr>
<td>
<%=i++%></td>
<%
	if ("3".equals(category_code))
		{%>
<td><A href= "NewEditPurchaseFormPrint.jsp?command=pedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_self>
	<%=rs_g.getString("Receive_no")%></a></td>

	<%}
	else{%>
<td><A href= "EditPurchaseForm.jsp?command=pedit&receive_id=<%=Receive_id%>&Iv_id=<%=Iv_id%>&Fv_id=<%=Fv_id%>" target=_blank>
	<%=rs_g.getString("Receive_no")%></a></td>
	
	<%}%>
<td><%=A.getNameCondition(conp,"voucher","Ref_No","where Voucher_No='"+Receive_id+"'")%></td>
<td><%=A.getName(conp,"CompanyParty",receive_from)%>  </td>
<td bgcolor=<%=dispaly_bgcolor%>><%=display_sale%></td>

<td>
		<%=format.format(rs_g.getDate("Receive_Date"))%></td>
<td><%=rs_g.getString("Receive_Lots")%></td>
<td><%=format.format(rs_g.getDate("Due_Date"))%></td>
<%local=rs_g.getDouble("Local_Total");
dollar=rs_g.getDouble("Dollar_Total");
qty=rs_g.getDouble("Receive_Quantity");
tax=rs_g.getDouble("Tax");
tot_qty += qty;
local_total += local;
dollar_total += dollar;
ctax_local=local- local /((tax/100)+1);
tlocal=local-ctax_local;
tax_total +=ctax_local;
tlocal_total +=tlocal;%>
<td align=right><%=str.format(""+qty,3)%></td>
<td align=right><%=str.format(""+tlocal,d)%></td>
<td align=right><%=str.format(""+ctax_local,d)%></td>
<td align=right><%=str.format(""+local,d)%></td>
<td align=right><%=str.format(""+dollar,2)%></td></tr>
<%	}//if pdcount==0
	}
	}//else
	}
	}
	pstmt_g.close();
	total_saleaccount +=tlocal_total;
 
%>
<tr>
<td align=right colspan=8><b>Total</b></td>
<td align=right><%=str.format(""+tot_qty,3)%></td>
<td align=right><%=str.format(""+tlocal_total,d)%></td>
<td align=right><%=str.format(""+tax_total,d)%></td>
<td align=right><%=str.format(""+local_total,d)%></td>
<td align=right> <%=str.format(""+dollar_total,2)%></td>
</tr>
<tr><td align=right colspan=7><b>Total Purchase</b></td>
<td align=right></td>
<td align=right> <%=str.format(""+total_saleaccount,d)%></td>
</tr>
</table>
</td></tr>
<!-- <tr><td colspan=2><hr></td><tr> -->
<tr><td align=right COLSPAN=2><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>

<%

C.returnConnection(conp);
C.returnConnection(cong);

}//if Receive 
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>