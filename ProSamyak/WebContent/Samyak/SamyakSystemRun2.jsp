<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<html><head><title>Samyak System Run 2, - Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
window.event.returnValue=0;
}
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgcolor=#AAD2FF onContextMenu="disrtclick()">
Start
<% 

ResultSet rs_g= null;
ResultSet rs= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_l=null;
	Connection conp = null;
	Connection conl = null;
	PreparedStatement pstmt_p=null;

try{ cong=C.getConnection();
	 conp=C.getConnection();}
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
//String query="Select Distinct Receive_Id from Receive_Transaction";
String query="Select * from Receive where opening_stock=0";

//String query="Select Receive_Id,Lot_id from Receive R, Receive_Transaction RT where R.Receive_id=RT.Receive_id and R.opening_Stock=0 and ( RT.Lot_SrNo=1 or RT.Lot_SrNo=0)";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{counter++;}

pstmt_g.close();
String Receive_Id[]=new String[counter];
String Lot_id[]=new String[counter];
String Category_Id[]=new String[counter];

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int i=0;
while(rs_g.next()) 	
{

 Receive_Id[i]=rs_g.getString("Receive_Id");
//out.print("Receive_ID"+Receive_Id);
//Lot_id[i]=rs_g.getString("Lot_Id"); 
// Category_Id[i]= A.getNameCondition("Lot","LotCategory_Id","where Lot_Id="+Lot_id[i]+"");
i++;
}
pstmt_g.close();

for(i=0; i<counter; i++)
	{
String requery="Select LOt_id from Receive_Transaction where Receive_Id="+Receive_Id[i]+" and ( Lot_SrNo=1 or Lot_SrNo=0)";

pstmt_g = cong.prepareStatement(requery);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
Lot_id[i]=rs_g.getString("Lot_Id"); 
 Category_Id[i]= A.getNameCondition("Lot","LotCategory_Id","where Lot_Id="+Lot_id[i]+"");
}
pstmt_g.close();

}

out.println("Dist counter is="+counter);
out.println("Samyak System Run 2 Complted Successfully");


for(i=0; i<counter; i++)
	{

String Upquery="Update Receive Set Receive_Category="+Category_Id[i]+" where Receive_Id="+Receive_Id[i]+ "";
pstmt_p = conp.prepareStatement(Upquery);
int a577 = pstmt_p.executeUpdate();
out.print("<BR>a577="+a577);
pstmt_p.close();

	}
out.println("Dist counter is="+counter);
out.println("Samyak System Run 2 Complted Successfully");
%>



<%

C.returnConnection(conp);
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>









