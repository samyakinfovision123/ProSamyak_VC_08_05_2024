<!-- System Run to change the scale of the Purchase_AdvanceDollar column in the Master_CompanyParty table -->

<!-- System Run to change the supervisor priviledge name to salesperson in the Master_PriviledgeLevel table -->


<!-- type the url in the browser 
http://localhost:8080/Nippon/Samyak/AlterMCPColumnScale.jsp?command=Alter06 -->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  class="NipponBean.Connect" />

<%
try{
String command=request.getParameter("command");

if(command.equals("Alter06") ) {

%>
<html>
<head>
	
</head>
<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
String query="";
try	{
	cong=C.getConnection();
	}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : AlterMCPColumnScale.jsp<br>Bug No Samyak32 : "+ Samyak31);}

query="ALTER TABLE Master_CompanyParty ALTER COLUMN Purchase_AdvanceDollar numeric (18, 4) ";
pstmt_g = cong.prepareStatement(query);
int a = pstmt_g.executeUpdate();
out.print("<br> System Run part 1 Complete : "+a+" Rows affected");

query="Update Master_PriviledgeLevel Set Priviledge_Name='Salesperson', Priviledge_Desc='Salesperson' where Priviledge_Id=15";
pstmt_g = cong.prepareStatement(query);
a = pstmt_g.executeUpdate();
out.print("<br> System Run part 2 Complete : "+a+" Rows affected");
   
C.returnConnection(cong);

	


}
else{
	out.print("<br>Please contact to super admin");
}

}catch(Exception e)
{
	out.print("Error is"+e);
}
%>

