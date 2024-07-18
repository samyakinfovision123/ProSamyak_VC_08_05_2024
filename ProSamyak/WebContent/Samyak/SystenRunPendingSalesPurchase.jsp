<!-- 
use of systemrun for the cancellation of the pending sales and purchase from Financial Transaction table to remove its reflection from Trial Balnce opening in ledgers.

type the url in the browser 
Nippon/Samyak/SystenRunPendingSalesPurchase.jsp?command=Samyak06
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
String errLine="18";
Connection cong = null;
Connection conp = null;

try{

String command=request.getParameter("command");
int dd1 =01;
int mm1 =04;
int yy1 =2006;
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>D1=" +D1);

if(command.equals("Samyak06")){

	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	cong=C.getConnection();
	errLine="37";
	

out.print("<br>System Run Started...");

String query="Select count(*) as counter from Financial_Transaction FT ,Voucher V where V.Voucher_Date < ? and V.Active=1 and V.Voucher_Id=FT.Voucher_Id and Ft.Local_Amount>0 and FT.Active=1"; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);

pstmt_g.setString(1,""+D1); 
rs_g = pstmt_g.executeQuery();	
int counter=0;
while(rs_g.next()) 
{
counter=rs_g.getInt("counter");
}
//out.print("<br>50 counter ="+counter);
pstmt_g.close();

String Tranasaction_Id[]= new String[counter];



query="Select Tranasaction_Id from Financial_Transaction FT ,Voucher V where V.Voucher_Date < ? and V.Active=1 and V.Voucher_Id=FT.Voucher_Id and Ft.Local_Amount>0 and FT.Active=1"; 
//out.print("<br> After Query =" +query);
pstmt_g = cong.prepareStatement(query);

pstmt_g.setString(1,""+D1); 
rs_g = pstmt_g.executeQuery();	
int x=0;
while(rs_g.next()) 
{
Tranasaction_Id[x]=rs_g.getString("Tranasaction_Id");
x++;
}
pstmt_g.close();

out.print("<br get FT_Id array ="+x);

for (int i=0;i<counter;i++)
	{
query="UPDATE Financial_Transaction SET Active=0, Modified_By=0,Modified_MachineName='SamyakSystemRun' where Tranasaction_Id="+Tranasaction_Id[i];
pstmt_p = conp.prepareStatement(query);
int a417 = pstmt_p.executeUpdate();
out.print("<br> i="+i+" Updated Successful "+a417);
pstmt_p.close();
	}


C.returnConnection(cong);
C.returnConnection(conp);


out.print("<br>Total Rows updated "+counter);
out.print("<br>System Run Completed .");
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




}//if command equals samyak06
}catch(Exception e){
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.println("Exception at Line "+errLine+" bug is :"+e);
}//eo catch
%>
		  