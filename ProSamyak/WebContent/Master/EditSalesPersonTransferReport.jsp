<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
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
	cong=C.getConnection();
//	conp=C.getConnection();
}catch(Exception e31){ 
	out.println("<font color=red> FileName : SalesPersonTransferReport.jsp<br>Bug No e31 : "+ e31);} 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(cong,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=01;
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
C.returnConnection(cong);

try{
if("Default".equals(command))
	{
	%>
<head>
<script>
function disrtclick()
{
window.event.returnValue=0;
}
</script>
</head>
<body background="../Buttons/BGCOLOR.JPG">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<table align=center bordercolor=skyblue border=0 cellspacing=0>

</td></tr>
<tr><td>
	<form action=EditSalesPersonTransferReport.jsp name=f1  target=_blank>
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Edit Warehouse Transfer
	</th></tr>
	<tr><th>From</th>	<td><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr>
	<th>SalesPerson</th>
	<td><%=A.getMasterArrayCondition(cong,"Location","location_id","","where company_id="+company_id)%></td>
	</tr>
<!--
	<tr>
	
	<th>Type</th>
	<td><select name="StockTransfer_Type">
	<option value=0>All</option>
	<option value=1>Lot to Lot</option>
	<option value=2>Location Transfer</option>
-->
	<!--<option value=3>transfer at Diff. Rates</option>-->
<!--<option value=4>Manufacturing</option>
	<option value=5>Melting</option>
	<option value=6>Loss / Wastage</option>
	<option value=7>Gain</option>
	</select></td>
	</tr>
-->	
<input type="hidden" name="StockTransfer_Type" value=2>
 <tr><td align=center colspan=2 >
	<input type=submit value='Next' name=command class='Button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
</td>
</tr>
</table>
</form>			
</BODY>
</HTML>

<%
}//if SaleReport

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>

<%


try{
if("Next".equals(command))
	{


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
String party_id= request.getParameter("party_id");
String location_id=request.getParameter("location_id");
String location_name = A.getNameCondition(cong,"Master_Location", "Location_Name", " where location_id="+location_id+"");
double total_saleaccount=0;
String StockTransfer_Type=request.getParameter("StockTransfer_Type");
//out.print("<br> 111 StockTransfer_Type "+StockTransfer_Type);
//out.print("<br>party=" +party_id);
try	{
	cong=C.getConnection();
	conp=C.getConnection();
}catch(Exception e31){ 
	out.println("<font color=red> FileName : SalesPersonTransferReport.jsp<br>Bug No e31 : "+ e31);}

String query="";
//Receive_sell=0=sale 1=purchase

//  R ,Receive_Transaction RT     where R.receive_id=RT.receive_id and R.Receive_Date between ? and ? and R.Company_id=? and R.Receive_FromId like "+company_id+" and R.Purchase=1 and R.Receive_sell=0 and R.Active=1 order by R.Receive_date ,R.Receive_no";

String condition ="";

	if(!("0".equals(StockTransfer_Type)))
		{
			condition = " and StockTransfer_Type="+StockTransfer_Type;
		}

	//16-08-2005 refine the query as there r repeated rows for multiple lots
	//Using lot_SrNo=0 condition to remove repeated rows
	

	query="Select * from Receive as R, Receive_Transaction as RT where R.Receive_Date between ? and ? and R.Receive_FromId="+company_id+"and R.Active=1"+condition+" and R.company_id="+company_id+" and RT.location_id="+location_id+" and R.Receive_Id=RT.Receive_Id and R.Receive_Sell=1 and lot_SrNo=0  and RT.Consignment_ReceiveId=0 and R.SalesPerson_Id=-1 order by R.Receive_date ,R.Receive_no";

	pstmt_g = cong.prepareStatement(query);

	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	

	rs_g = pstmt_g.executeQuery();	
	int scounter=0;

	while(rs_g.next())
		{
			scounter++;
		}
//		out.print("<br>144 scounter "+scounter);
	pstmt_g.close();

		int sReceive_Id[]=new int[scounter];
		String sReceive_No[]=new String[scounter];
		String sReceive_Date[]=new String[scounter];
		String sReceive_Sell[]=new String[scounter];
		String sType[]=new String[scounter];
		String St_type[]=new String[scounter];
		String sReceive_Lots[]=new String[scounter];
		double sReceive_Quantity[]=new double[scounter];
		double sLocal_Total[]=new double[scounter];
		double sDollar_Total[]=new double[scounter];

		pstmt_g = cong.prepareStatement(query);

		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);	

		rs_g = pstmt_g.executeQuery();	
		int g=0;
		while(rs_g.next())
		{
			sReceive_Id[g]=rs_g.getInt("Receive_Id");
			sReceive_No[g]=rs_g.getString("Receive_No");
			sReceive_Sell[g]=rs_g.getString("Receive_Sell");
			sReceive_Date[g]=format.format(rs_g.getDate("Receive_Date"));
			sType[g]=rs_g.getString("StockTransfer_Type");

//			out.print("<br> sType[g] "+sType[g]);
			if("0".equals(sReceive_Sell[g]))
				{ sReceive_Id[g]+=1; 
  				  //St_type[g]="Reverse Location Transfer";
				}
			else
				{ sReceive_Id[g]-=1;
				  //St_type[g]="Location Transfer";
				}
			
			St_type[g]="Location Transfer";
			sReceive_Lots[g]=rs_g.getString("Receive_Lots");
			sReceive_Quantity[g]=rs_g.getDouble("Receive_Quantity");
			sLocal_Total[g]=rs_g.getDouble("Local_Total");
			sDollar_Total[g]=rs_g.getDouble("Dollar_Total");

			g++;
		}
	pstmt_g.close();

C.returnConnection(conp);
C.returnConnection(cong);

%>
<html><head><title>Edit Warehouse Transfer Report - Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}

</script></head>
<link href='../Samyak/reportcss.css' rel=stylesheet type='text/css'>

<body bgcolor=white>
<table align=center border=0 cellspacing=0 width='90%'>
<tr><td align="right">Company:<%=company_name%></td> 
<!-- <td align=right>Run Date:<%=format.format(D)%></td> --></tr>
	<tr><th colspan=2>
 Edit Warehouse Transfer Report for <%=location_name%></th></tr>
<tr><th colspan=2> From:<%=format.format(D1)%> - To: <%=format.format(D2)%></th></tr>

<tr><td colspan=2>
<table align=center border=1 cellspacing=0 width='100%'>

<tr bgcolor=#009999>
<th class='th4'>Sr No</th>
<th class='th4'>No</th>
<th class='th4'>Date</th>
<th class='th4'>Stock Trasfer Type</th>
<th class='th4'>No. of Lots</th>
<th class='th4'>Quantity</th>
<th class='th4'>Local Total (<%=local_symbol%>)</th>
<th class='th4'>Dollar Total ($)</th>
</tr>
<%
for(int i=0;i<scounter;i++)
	{%>
		<tr>
		<td><%=i+1%></td>
		<td><a href="EditSalesPersonTransferDetail.jsp?Receive_Id=<%=sReceive_Id[i]%>&StockTransfer_Type=<%=sType[i]%>&command=Default&mesage=Default&currentLocation=<%=location_id%>" target="_blank"> <%=sReceive_No[i]%></a> <input type=hidden name="sReceive_Id<%=i%>" value="<%=sReceive_Id[i]%>"></td>
		<td><%=sReceive_Date[i]%></td>
		<td><%=St_type[i]%></td>

	<%	if(!("7".equals(sType[i])))
		{%>
		<td align=right><%=sReceive_Lots[i]%></td>
	<%	}
	else{%>
		<td align=right> - </td>
	<%	}	%>

	
	<%	if(!("7".equals(sType[i])))
		{%>
		<td align=right><%=str.format(""+sReceive_Quantity[i])%></td>
	<%	}
	else{%>
		<td align=right> - </td>
	<%	}	%>


	<%	if(!("7".equals(sType[i])))
		{%>
		<td align=right><%=str.format(""+sLocal_Total[i])%></td>
	<%	}
	else{%>
		<td align=right> - </td>
	<%	}	%>


	<%	if(!("7".equals(sType[i])))
		{%>
		<td align=right><%=str.format(""+sDollar_Total[i])%></td>
	<%	}
	else{%>
		<td align=right> - </td>
	<%	}	%>


		</tr>
<%	}


}//if Receive 

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>









