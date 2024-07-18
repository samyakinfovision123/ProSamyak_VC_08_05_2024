<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<!-- 
For Run the System Run:-
This file is used for the show all confirm sale invoices 
having different party name than orignal Consignment Sale Invoices


 type the url in the browser 
Samyak/Nippon/Samyak/ShowConfirmSale_DifferentPartName.jsp?command=Samyak07



-->

<%
try{
String command=request.getParameter("command");

if(command.equals("Samyak07"))
	{
	
	
	
	ResultSet rs_p= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
	     
		 
		 }
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	ftqtysystemrun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);


String query="SELECT  main.Receive_No as  MNO, main.Receive_Date as MRDate,   mpmain.CompanyParty_Name as MCompanyParty_Name, sec.Receive_No as SReceive_No,  sec.Receive_Date as SReceive_Date ,mpsec.CompanyParty_Name as SCompanyParty_Name  FROM Receive AS main, Receive AS sec ,Master_CompanyParty as mpmain,Master_CompanyParty as mpsec WHERE sec.Receive_Sell=False And sec.Purchase=True And main.Purchase=False And main.Receive_Sell=False And main.Receive_Id=sec.Consignment_ReceiveId And main.Receive_FromId<>sec.Receive_FromId And main.Opening_Stock=False And sec.Opening_Stock=False And sec.Return=False And sec.Return=False And sec.Consignment_ReceiveId>0 And sec.Cgt_ReturnConfirm>0  And sec.Cgt_ReturnConfirm>0 and main.Receive_FromId=mpmain.CompanyParty_Id and sec.Receive_FromId=mpsec.CompanyParty_Id ";






pstmt_p=conp.prepareStatement(query);

rs_p=pstmt_p.executeQuery();


String mrid="";
String srid="";
String srno="";
String mrno="";
String mrfromid="";
String srfromid="";
String sconsignmentid="";
String mconsignmentid="";

double count=0;
double total_booked=0;
double total_pending=0;
double total_pendinglocal=0;
double total_used=0;
double total_exchange=0;
%>
<html>
<head>
	<title>Samyak Software</title>
<script language="JavaScript">
	function disrtclick()
{
//window.event.returnValue=0;
}
</script>
</head>
<link href='../Samyak/reportcss.css' rel=stylesheet type='text/css'>

<body bgcolor=#ffffff onContextMenu="disrtclick()">
<form action="EditForwardBooking.jsp" name=f1  >
	<table align=right bordercolor=skyblue border=0 cellspacing=0 width="100%">
	<tr><th colspan=2> Detail Cancelled Report </th></tr>
	<tr><td align=right><%//=company_name%></td></tr>
	<tr>
		<td>
		<table align=center bordercolor=skyblue border=0 cellspacing=0 width="100%">
		<tr bgcolor=#009999>
			<th class='th4'> No</th>
<th class='th4'>Consignment<br>Sale. No.</th>

			<th class='th4'>Consignment <br> Sale Date</th>
			<th class='th4'>Party Name</th>
			<th class='th4'>Confirm<br>Sale No</th>
			<th class='th4'>Confirm<br> Sale Date</th>
			<th class='th4'>Party Name</th>

			</tr>
<%
	while(rs_p.next())
		{


%>
		<tr>
			<td align=center><%=count+1%></td>
	
			<td align=center><%=rs_p.getString("MNO")%></td>
			
		<td align=center><%=format.format(rs_p.getDate("MRDate"))%>
			</td>
		<td align=center><%=rs_p.getString("MCompanyParty_Name")%>
				</td>
	        <td align=center><%=rs_p.getString("SReceive_No")%></td>
	        <td align=center><%=format.format(rs_p.getDate("SReceive_Date"))%></td>
	       <td align=center><%=rs_p.getString("SCompanyParty_Name")%></td>
			
	
		</tr>
		
		<tr></tr>
		<tr></tr>
		<tr></tr>
<% 
		count++;
		}
%>
	
		</table>	
	</td></tr>

	<tr><td align=right>Run Date <%=format.format(D)%></td></tr>

	</table>

</form>
</body>
</html>

<%	
	C.returnConnection(conp);
	}

}catch(Exception e) { out.print("<br>updateconfirmcancel.jsp Bug:-- "+e); }
%>


