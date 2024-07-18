<!--
System Run to Match Receive Date and Stock Date in Receive Table

http://localhost:8080/Nippon/Samyak/ReceiveStockDateMismatch.jsp?command=Nippon05  -->


<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
Connection cong = null;
String errline="7";
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
try{
String command=request.getParameter("command");
//String company_id=request.getParameter("company_id");
if(command.equals("Nippon05"))
{
//out.print("<br>16 command ="+command);
String query="";
ResultSet rs_g= null;

PreparedStatement pstmt_g=null;
try	{ cong=C.getConnection();}
catch(Exception Samyak31)
{ out.println("<font color=red> FileName : 	InsertDefaultValues.jsp<br>Bug No Samyak31 : "+ Samyak31);}

//out.print("<br>cong="+cong);
query="Select count(*) as receiveCount from Receive where active=1 and Receive_Date <> Stock_Date";   

pstmt_g = cong.prepareStatement(query);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
//out.print("<br>48 voucherquery="+voucherquery);
int receiveCount=0;
while (rs_g.next())
	{
	receiveCount=rs_g.getInt("receiveCount");
	}
//out.print("<br>35 receiveCount="+receiveCount);
pstmt_g.close();

int receive_id[]=new int[receiveCount];

String receive_no[]=new String[receiveCount];
java.sql.Date stock_date[] =new java.sql.Date[receiveCount];
java.sql.Date receive_date[] =new java.sql.Date[receiveCount];

query="Select Receive_Id,Receive_No,Receive_Date,Stock_Date from Receive where active=1 and Receive_Date <> Stock_Date";   
pstmt_g = cong.prepareStatement(query);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
int k=0;
while(rs_g.next())
{
	receive_id[k]=rs_g.getInt("Receive_Id");
	receive_no[k]=rs_g.getString("Receive_No");
	receive_date[k]=rs_g.getDate("Receive_Date");
	stock_date[k]=rs_g.getDate("Stock_Date");
	k++;
}
pstmt_g.close();
%>
<form action="ReceiveStockDateMismatch.jsp" method=post>
<table border=1 bordercolor=blue width="100%">
<tr>
<td align=center><b>Sr No</td>
<td align=center><b>Receive_Id</td>
<td align=center><b>Receive_No</td>
<td align=center><b>Receive_Date</td>
<td align=center><b>Stock_Date</td>
</tr>
<%
for(int i=0; i<receiveCount; i++)
	{
	%>
<tr>
<td><%=i+1%></td>
	<td align=center><%=receive_id[i]%></td>
<td align=center><%=receive_no[i]%></td>
<td align=center><%=format.format(receive_date[i])%></td>
<td align=center><%=format.format(stock_date[i])%></td>
<input type="hidden" name=receive_id<%=i%> value=<%=receive_id[i]%>>
<input type="hidden" name=receive_date<%=i%> value=<%=format.format(receive_date[i])%>>
</tr>

<%
	}
	if (receiveCount>0)
	{
%>
<tr>
<td align=center colspan=5>
<input type="hidden" name=receiveCount value=<%=receiveCount%>>
<input type=submit name=command value=Update></td>
</tr>
<%}%>
</table>
</form>
<%
C.returnConnection(cong);

}


if(command.equals("Update"))
{

	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    cong=C.getConnection();

out.print("<br>System Run Continued...");
int a417 = 0;
	String query1="";
	int receiveCount = Integer.parseInt(request.getParameter("receiveCount"));
	int receive_id[]=new int[receiveCount];
	java.sql.Date receive_date[] =new java.sql.Date[receiveCount];
 errline="120";
 out.print("<br>receiveCount="+receiveCount);

for(int i=0; i<receiveCount; i++)
	{
errline="124";
 receive_id[i]=Integer.parseInt(request.getParameter("receive_id"+i));
 errline="132";
 //out.print("<br>"+request.getParameter("receive_date"+i));
 receive_date[i]=format.getDate(request.getParameter("receive_date"+i));
 errline="134";

query1="UPDATE Receive SET Stock_Date='"+receive_date[i]+"', Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+" where receive_id="+receive_id[i];

				pstmt_g = cong.prepareStatement(query1);
				 errline="140";
				a417 += pstmt_g.executeUpdate();
				 errline="142";
				pstmt_g.close();
					//out.print("<br>receive_date="+receive_date[i]);
					//out.print("<br>voucher_id:"+voucher_id[i]);
					//out.print("<br>Total Rows updated :"+(a417));
	}	out.print("<br>Total Rows updated :"+(a417));
	 errline="136";
	 C.returnConnection(cong);


		 out.println("Data Successfully Updated ! ");
		 out.println("System Run Completed.");
		%>
		 <html>
<head>
<title>Samyak System Run</title>
<script language="JavaScript">
function f1()
{
alert("System Run Completed");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body>
</html>

<%
}	//update end
}
catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
  out.println("<font color=red> FileName : UpdateReceiveDate.jsp<br>Bug No Samyak31 :"+Samyak31+"errline="+errline);
 }
 
%>
