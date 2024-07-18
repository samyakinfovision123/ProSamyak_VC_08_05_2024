<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
Connection cong = null;
String errline="7";
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
query="Select count(*) as voucherCount from Receive as R, Voucher as V , Financial_Transaction as FT where R.active=1 and V.active=1 and R.Receive_Date <> V.Voucher_Date and V.Voucher_Id=FT.Voucher_Id and R.Receive_Id=FT.Receive_ID ";   

pstmt_g = cong.prepareStatement(query);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
//out.print("<br>48 voucherquery="+voucherquery);
int voucherCount=0;
while (rs_g.next())
	{
	voucherCount=rs_g.getInt("voucherCount");
	}
//out.print("<br>vouchercount="+voucherCount);
pstmt_g.close();

int voucher_id[]=new int[voucherCount];
int receive_id[]=new int[voucherCount];
String voucher_no[]=new String[voucherCount];
java.sql.Date voucher_date[] =new java.sql.Date[voucherCount];
java.sql.Date receive_date[] =new java.sql.Date[voucherCount];

query="Select v.Voucher_ID,Voucher_Date,V.Voucher_No,R.Receive_Id,R.Receive_Date from Receive as R, Voucher as V , Financial_Transaction as FT where R.active=1 and V.active=1 and R.Receive_Date <> V.Voucher_Date and V.Voucher_Id=FT.Voucher_Id and R.Receive_Id=FT.Receive_ID ";   

pstmt_g = cong.prepareStatement(query);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
int k=0;
while(rs_g.next())
{
	voucher_date[k]=rs_g.getDate("Voucher_Date");
	receive_date[k]=rs_g.getDate("Receive_Date");
	voucher_id[k]=rs_g.getInt("Voucher_Id");
	receive_id[k]=rs_g.getInt("Receive_Id");
	voucher_no[k]=rs_g.getString("Voucher_No");
	k++;
}
pstmt_g.close();
%>
<form>
<table border=1 bordercolor=blue width="100%">
<tr>
<td align=center><b>Voucher_Id</td>
<td align=center><b>Receive_Id</td>
<td align=center><b>Voucher_No</td>
<td align=center><b>Voucher_Date</td>
<td align=center><b>Receive_Date</td>
</tr>
<%
for(int i=0; i<voucherCount; i++)
	{
	%>
<tr>
<td align=center><%=voucher_id[i]%></td>
<td align=center><%=receive_id[i]%></td>
<td align=center><%=voucher_no[i]%></td>
<td align=center><%=format.format(voucher_date[i])%></td>
<td align=center><%=format.format(receive_date[i])%></td>
<INPUT TYPE="hidden" name=voucher_id<%=i%> value=<%=voucher_id[i]%>>
<INPUT TYPE="hidden" name=receive_id<%=i%> value=<%=receive_id[i]%>>
<INPUT TYPE="hidden" name=voucher_no<%=i%> value=<%=voucher_no[i]%>>
<INPUT TYPE="hidden" name=voucher_date<%=i%> value=<%=format.format(voucher_date[i])%>>
<INPUT TYPE="hidden" name=receive_date<%=i%> value=<%=format.format(receive_date[i])%>>
</tr>
<input type=hidden name=voucherCount value=<%=voucherCount%> >
<%
	}
	if (voucherCount>0)
	{
%>
<tr>
<td align=center colspan=5><input type=submit name=command value=Update></td>
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
	String voucherCountStr = request.getParameter("voucherCount");
	int voucherCount = Integer.parseInt(voucherCountStr);
int voucher_id[]=new int[voucherCount];
int receive_id[]=new int[voucherCount];
String voucher_no[]=new String[voucherCount];
java.sql.Date voucher_date[] =new java.sql.Date[voucherCount];
java.sql.Date receive_date[] =new java.sql.Date[voucherCount];
 errline="120";
 out.print("<br>voucherCount="+voucherCount);

for(int i=0; i<voucherCount; i++)
	{
errline="124";
voucher_id[i]=Integer.parseInt(request.getParameter("voucher_id"+i));
 errline="126";
 receive_id[i]=Integer.parseInt(request.getParameter("receive_id"+i));
 errline="128";
 voucher_no[i]=request.getParameter("voucher_no"+i);
 errline="130";
 //out.print("<br>"+request.getParameter("voucher_date"+i));
 //out.print("<br>"+request.getParameter("receive_date"+i));
 voucher_date[i]=format.getDate(request.getParameter("voucher_date"+i));
 errline="132";
 //out.print("<br>"+request.getParameter("receive_date"+i));
 receive_date[i]=format.getDate(request.getParameter("receive_date"+i));
 errline="134";

query1="UPDATE Voucher SET Voucher_Date='"+receive_date[i]+"' where Voucher_Id="+voucher_id[i];

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
}
	
}
catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
  out.println("<font color=red> FileName : UpdateReceiveDate.jsp<br>Bug No Samyak31 :"+Samyak31+"errline="+errline);
 }
 
%>
