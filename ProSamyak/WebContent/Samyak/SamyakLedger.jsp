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

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;

/*try	{cong=C.getConnection();
conp=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}*/

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

cong=C.getConnection();
String query="Select * from Ledger where For_Head=14 and Ledger_type=3 order by For_headid";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter is="+counter);

String ledger_id[]= new String[counter];
String ledger_name[]= new String[counter];
String for_headid[]= new String[counter];


int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
ledger_id[i]=rs_g.getString("Ledger_id");
ledger_name[i]=rs_g.getString("ledger_name");
for_headid[i]=rs_g.getString("for_headid");

i=i+1;
}//while
//out.println("<br>761245counter"+counter);
out.print("<table border=1 bordercolor=green align=center cellspacing=2>");
out.print("<tr><th>no<th>Ledger Name<th>Ledger_id<th>Party_id");
int k=0;

for( i=0;i<counter;i++)
{
out.print("<tr>");
out.print("<td>"+(++k)+"</td>");
out.print("<td>"+ledger_name[i]+"</td>");
out.print("<td>"+ledger_id[i]+"</td>");
out.print("<td>"+for_headid[i]+"</td>");
out.print("</tr>");
}/*
for( i=0;i<counter;i++)
{
query="update Ledger set Ledger_name=? , Ledger_type=? where ledger_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1, ledger_name[i]+" Sales");
pstmt_p.setString (2, "1");
pstmt_p.setString(3,ledger_id[i]);
int a577 = pstmt_p.executeUpdate();
//System.out.println("Updated Successfully:" +a489);
out.println("Updated Successfully:a489" +a577);
pstmt_p.close();


}//for
out.print("</table>");
int ledgerid=Integer.parseInt(""+L.get_master_id("Ledger"));


for( i=0;i<counter;i++)
	{
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active) values (?,?,?,?, ?,?,?,?, '"+today_string+"',?,? )";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledgerid);	
pstmt_p.setString (2,"1");
pstmt_p.setString (3,"14");
pstmt_p.setString (4,for_headid[i]);
pstmt_p.setString (5,ledger_name[i]+" Purchase");
pstmt_p.setString (6,"2");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,"1");	
pstmt_p.setString (9,"jainam5");
pstmt_p.setBoolean (10, true);
int aledger2 = pstmt_p.executeUpdate();
pstmt_p.close();

ledgerid=ledgerid+1;
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Description, Modified_By, Modified_On, Modified_MachineName,Active) values (?,?,?,?, ?,?,?,?, '"+today_string+"',?,? )";
//out.print("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
pstmt_p.setString (1,""+ledgerid);	
pstmt_p.setString (2,"1");
pstmt_p.setString (3,"14");
out.print("<br >3 ");
pstmt_p.setString (4,for_headid[i]);
out.print("<br >4 ");
pstmt_p.setString (5,ledger_name[i]+" PN");
pstmt_p.setString (6,"3");
out.print("<br >4 "+"3");
pstmt_p.setString (7,"description");
pstmt_p.setString (8,"1");	
pstmt_p.setString (9,"jaianm5");
pstmt_p.setBoolean (10, true);
int aledger3 = pstmt_p.executeUpdate();
pstmt_p.close();
ledgerid=ledgerid+1;

	}*/
out.println("<br>134");
out.println("<br>Update Successfully116");
%>


<%
	C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











