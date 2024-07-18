<!-- 
use of systemrun for the cancellation of 

type the url in the browser 
Nippon/Samyak/updateLotCategory.jsp?command=Samyak06
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String errLine="18";
String command=request.getParameter("command");

if(command.equals("Samyak06")){
	
	
	
	ResultSet rs_g= null;
	ResultSet rs_p= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
		errLine="37";
	  	 }
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red>  errLine: "+errLine+"bug is"+ Samyak31);
		}

out.print("<br> System Run Started..."


String query="UPDATE LOT SET lOTCATEGORY_ID=1 ,LOTSUBCATEGORY_ID=1 WHERE COMPANY_ID=1";
pstmt_p = conp.prepareStatement(query);
int a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 1"+a417);
pstmt_p.close();
	
query="UPDATE LOT SET lOTCATEGORY_ID=3 ,LOTSUBCATEGORY_ID=3 WHERE COMPANY_ID=2";
pstmt_p = conp.prepareStatement(query);
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 2"+a417);
pstmt_p.close();

query="UPDATE LOT SET lOTCATEGORY_ID=5 ,LOTSUBCATEGORY_ID=5 WHERE COMPANY_ID=3";
pstmt_p = conp.prepareStatement(query);
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 3"+a417);

query="UPDATE LOT SET lOTCATEGORY_ID=7 ,LOTSUBCATEGORY_ID=7 WHERE COMPANY_ID=4";
pstmt_p = conp.prepareStatement(query);
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 4"+a417);

query="UPDATE LOT SET lOTCATEGORY_ID=9 ,LOTSUBCATEGORY_ID=9 WHERE COMPANY_ID=5";
pstmt_p = conp.prepareStatement(query);
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 5"+a417);

query="UPDATE LOT SET lOTCATEGORY_ID=11 ,LOTSUBCATEGORY_ID=11 WHERE COMPANY_ID=6";
pstmt_p = conp.prepareStatement(query);
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company 6"+a417);

out.print("<br> System Run Completed Successfully."

}catch(Exception e){
	out.println("Exception at Line "+errLine+" bug is :"+e);
}//eo catch
%>
		  