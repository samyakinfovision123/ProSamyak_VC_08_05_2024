<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
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
String company_id=request.getParameter("company_id");
//out.print("<br>Please Pass the company_id in the address line");
if("null".equals(company_id))
{company_id="1";}
//out.print("<br>company_id="+company_id);
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


//String query="Select * from Receive where Receive_quantity=0 and Company_id=1 and Receive_fromid not like 1 and Receive_sell=0 and Purchase=1 and Active=1 and Return=0";
cong=C.getConnection();
String query="Select * from Receive  where Purchase=1 and Active=1 and Return=0 and company_id="+company_id+" and Opening_Stock=0 order by Receive_date ,Receive_no";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
//out.println("counter is="+counter);

String receive_id[]= new String[counter];
double receive_local_total[]= new double[counter];
double voucher_local_total[]= new double[counter];
int voucher_type[]=new int[counter]; 
String receive_no[]=new String[counter]; 
int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
receive_id[i]=rs_g.getString("Receive_ID");
receive_no[i]=rs_g.getString("Receive_No");
receive_local_total[i]=rs_g.getDouble("Local_Total");
i=i+1;
}//while
//out.println("<br>50 counter"+counter);

for(i=0; i<counter; i++)
	{

query="Select * from Voucher  where   (voucher_type=1 or voucher_type=2) and voucher_no=? and Active=1 order by voucher_date ,voucher_no";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
voucher_type[i]=rs_g.getInt("voucher_type");
voucher_local_total[i]=rs_g.getDouble("Local_Total");

}
pstmt_g.close();

	}
out.print("<table border=1 bordercolor=green align=center cellspacing=2>");
out.print("<tr><th>no<th>Receive No<th>Type<th>R-total<th>V-total");
int k=0;
for(i=0; i< counter; i++)
	{
double temp=str.mathformat(receive_local_total[i],0)- str.mathformat(voucher_local_total[i],0);
if(temp>0)
		{
out.print("<tr>");
out.print("<td>"+(++k)+"</td>");
out.print("<td>"+receive_no[i]+"</td>");
if(1==voucher_type[i])
			{out.print("<td>Sale</td>");}
else{out.print("<td>Purchase</td>");}
out.print("<td>"+receive_local_total[i]+"</td>");
out.print("<td>"+voucher_local_total[i]+"</td>");
out.print("</tr>");
		}

	}

out.print("</table>");

%>
</body>
</html>
<%
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











