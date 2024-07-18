<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
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

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;

try	{cong=C.getConnection();
conp=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

try{
int current_id=0; 
int total_rows=0;

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;


//String query="Select * from Financial_Transaction where For_Head=10  order by Tranasaction_Id";
String query="Select * from voucher where voucher_type=11  order by voucher_Id";

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter is="+counter);
pstmt_g.close();

String voucher_id[]= new String[counter];
String voucher_no[]= new String[counter];
double voucher_total[]= new double[counter];
double local_total[]= new double[counter];
double dollar_total[]= new double[counter];

int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
voucher_id[i]=rs_g.getString("voucher_id");
voucher_no[i]=rs_g.getString("voucher_No");
voucher_total[i]=rs_g.getDouble("Voucher_Total");
local_total[i]=rs_g.getDouble("Local_Total");
dollar_total[i]=rs_g.getDouble("Dollar_Total");
i=i+1;
}//while
pstmt_g.close();

//out.println("<br>761245counter"+counter);
for( i=0;i<counter;i++)
{
query="update Receive  set Receive_Total=?, Local_Total=?, Dollar_Total=? where Receive_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, ""+voucher_total[i]);
pstmt_p.setString (2, ""+local_total[i]);
pstmt_p.setString (3, ""+dollar_total[i]);
pstmt_p.setString(4,voucher_no[i]);
int a577 = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a489);
out.println("Updated Successfully:a489" +a577);
pstmt_p.close();


}//for
out.println("<br>134");
out.println("<br>Update Successfully116");
%>


<%

C.returnConnection(conp);
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>









