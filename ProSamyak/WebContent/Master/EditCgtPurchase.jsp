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
ResultSet rs_q= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_q=null;
try	{
	conp=C.getConnection();
	cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);}


String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));



java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
String message=request.getParameter("message");
//out.print("<br>message=" +message);

if("masters".equals(message))
	{}
else{out.print("<center><font color=red>"+message+"</font></center>");}

try{
%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">

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
	<form action=EditCgtPurchase.jsp name=f1 method=post >
	<table align=center bordercolor=skyblue border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=2>
	Select Consignment Purchase to Edit
	</th></tr>
	<tr><th>From</th>	<td align="center"><%=L.date(Dprevious,"dd1","mm1","yy1")  %></td></tr>
	<tr><th>To</th>		<td align="center"><%=L.date(D,"dd2","mm2","yy2")  %></td></tr>
	<tr><th>Account</th>
    <TD align="center">   
<%=A.getMasterArrayAll(conp,"Companyparty","party_id","",company_id)%> </td></tr>
	<tr><td align=center colspan=4 >
	<input type=submit value='Edit Cgt Purchase' name=command    		class='Button2' onmouseover="this.className='button2_over';" onmouseout="this.className='button2';">
<input type="hidden" name=message value=masters>

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

if("Edit Cgt Purchase".equals(command))
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
double total_saleaccount=0;

//out.print("<br>party=" +party_id);

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
Select Consignment Purchase to Edit</th>
<tr>
<th>Sr No</th>
<th>No</th>
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

/*
if("0".equals(party_id))
{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Purchase=0  and Receive_Sell=1 and Active=1 and Return=0 and Opening_Stock=0  and ProActive=0 order by receive_date ,receive_no";
}
//receive=0 specifies that the receive is consignment receive
else{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=?  and Receive_FromId="+party_id+" and Purchase=0 and Receive_Sell=1 and Active=1 and Return=0 and Opening_Stock=0  and ProActive=0 order by receive_date , receive_no";
}
//out.print("<br>query="+query);
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,D1);
	pstmt_g.setDate(2,D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
*/
String query="";
//------------------------------------------------------

if("0".equals(party_id))
{
 query = "select distinct(r.receive_id) from Receive r , Receive_Transaction  rt  where  r.Receive_Date  between  ?  and   ?  and  r.receive_id =  rt.receive_id and r.Company_Id="+company_id+" and purchase=0 and receive_sell=1 and R_Return=0   and r.active=1 and rt.Receivetransaction_Id <> any (select Consignment_ReceiveId from Receive_Transaction where Active = 1 )";	
}
else{

	query = "select distinct(r.receive_id) from Receive r , Receive_Transaction  rt  where  r.Receive_Date  between  ?  and   ?  and  r.receive_id =  rt.receive_id and r.Company_Id="+company_id+" and Receive_FromId="+party_id+" and purchase=0 and receive_sell=1 and R_Return=0   and r.active=1 and rt.Receivetransaction_Id <> any (select Consignment_ReceiveId from Receive_Transaction where Active = 1)";	

}
  pstmt_q = cong.prepareStatement(query);
  pstmt_q.setString(1,""+D1);
  pstmt_q.setString(2,""+D2);
  rs_q = pstmt_q.executeQuery();	

  String receive_id1 = "";
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

  while(rs_q.next())
  {	  
      receive_id1 = rs_q.getString("receive_id");
   // out.print("<br>167 receive_id1"+receive_id1);

	  query = "select Receivetransaction_Id from  Receive_Transaction where Consignment_ReceiveId = any( select Receivetransaction_Id  from  Receive_Transaction where receive_id = "+ receive_id1 +" and Consignment_ReceiveId = 0 and Active = 1 ) and Active =1"; 

	  pstmt_g = cong.prepareStatement(query);  
	  rs_g = pstmt_g.executeQuery();	
	  int counter = 0; 
	  while(rs_g.next()) 
	  {
		  rs_g.getString("Receivetransaction_Id"); 
		  counter++;
	  }
	 // out.print("<br>162 counter :"+counter); 
 

	  pstmt_g.close(); 

	  if(counter==0)
	  {
			  
			 query = "select * from Receive where receive_id ="+receive_id1; 

		

			pstmt_g = cong.prepareStatement(query);

			rs_g = pstmt_g.executeQuery();	

			//out.print("<br>235 out here");

	//--------------------------------------------------------





	%>

	<%

	while(rs_g.next())
	{
		String Receive_id =rs_g.getString("Receive_id");



		reportcurrency_id=rs_g.getDouble("Receive_CurrencyId");
		String dispaly_bgcolor="yellow";
		String display_sale="Import";
		String receive_from=rs_g.getString("Receive_FromId");
		//out.print("<br>258 Receive_id"+Receive_id);
        //out.print("<br>258 receive_from"+receive_from);
		//out.print("<br>258 company_id"+company_id);
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

		
        //out.print("<br>258 reportcurrency_id"+reportcurrency_id);

	//	if(reportcurrency_id==0)
	//	{
		//out.print("<br>218 Inside reportcurrency==0 ");
		%>
		<tr>

		<td>
			<%=i++%></td>
		<td><A href= "EditCgtPurchaseForm.jsp?command=CgtPurchaseEdit&receive_id=<%=Receive_id%>" target=_blank>
			<%=rs_g.getString("Receive_no")%></a></td>
		<td><%=A.getName(conp,"CompanyParty",receive_from)%>  </td>
		<td bgcolor=<%=dispaly_bgcolor%>><%=display_sale%></td>
		<td><%=format.format(rs_g.getDate("Receive_Date"))%></td>
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

		<%       //	}
		}//else

	  } // end of inner while
				pstmt_g.close();
				total_saleaccount +=tlocal_total;
			%>

		<%

	}//end of if(counter == 0)  
  }//while end
  %>
  <tr>
		<td align=right colspan=7><b>Total</b></td>
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



</BODY>
</HTML>








