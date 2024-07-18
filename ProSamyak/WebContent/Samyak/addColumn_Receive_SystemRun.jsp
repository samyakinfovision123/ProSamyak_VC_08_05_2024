
 <!--  
Use of System Run:- Add column to Receive Table
How to Run System Run:-
Type in url:-/Samyak/addColumn_Receive_SystemRun.jsp?command=Samyak


-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<%

Connection conp=null;
Connection cong=null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;


String query="";
String query1="";
String command=request.getParameter("command");
if(command.equals("Samyak"))
{
%>

<html>
<head><title>Add Column</title></head>
<body> 

<%
try
{
	
	conp=C.getConnection();
	cong=C.getConnection();

	query="ALTER TABLE Receive ADD sendForLocationId numeric Default 0";
	pstmt_p=conp.prepareStatement(query);
	int i=pstmt_p.executeUpdate();
	pstmt_p.close();
	C.returnConnection(conp);
	
	query1="Update Receive set sendForLocationId=0 ";
	pstmt_g=cong.prepareStatement(query1);
	int j=pstmt_g.executeUpdate();
	pstmt_g.close();
	C.returnConnection(cong);

%>	
	<h2>  Column Added Successfully In Receive Table</h2>
	<br>
	<h2>  System Run completed Successfully </h2>

<%
		
}
catch(Exception e)
{
	C.returnConnection(conp);
	C.returnConnection(cong);
	out.print("<br> Exception 42 : "+e );
}
} //if(command.equals("Samyak"))
else
{%>
	
	<h2> Invalid Parameter </h2>
<%}
%>
</body>
</html> 