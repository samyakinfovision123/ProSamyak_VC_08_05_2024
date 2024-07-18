<!-- 
use of systemrun for Updating the Dollar Ledger opening balance in Ledger table.

type the url in the browser 
Nippon/Samyak/LedgerDollarCredit.jsp?command=Samyak06
-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>


<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
String errLine="18";
Connection conp = null;

try{

String command=request.getParameter("command");

if(command.equals("Samyak06")){

	ResultSet rs_g= null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	errLine="37";
	

out.print("<br>System Run Started...");

String query="Update Ledger set opening_dollarBalance=(opening_localBalance/exchange_rate) where exchange_rate>0"; 
//out.print("<br> After Query =" +query);
pstmt_p = conp.prepareStatement(query);
int tempx = pstmt_p.executeUpdate();
out.print("<br>Rows Updated ="+tempx);
pstmt_p.close();

out.print("<br>System Run Completed...");

}//if command equals samyak06
}catch(Exception e){
	C.returnConnection(conp);
	out.println("Exception at Line "+errLine+" bug is :"+e);
}//eo catch
%>
		  