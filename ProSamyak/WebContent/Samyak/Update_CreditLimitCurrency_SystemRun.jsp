
 <!--  
Use of System Run:- Add column to Master_CompanyParty Table
How to Run System Run:-
Type in url:-/Samyak/Update_CreditLimitCurrency_SystemRun.jsp?command=Samyak


-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<%

Connection conp=null;
PreparedStatement pstmt_p=null;


String query="";
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
	query="ALTER TABLE Master_CompanyParty ADD CreditLimit_Currency numeric DEFAULT  0";
	pstmt_p=conp.prepareStatement(query);
	int i=pstmt_p.executeUpdate();
	pstmt_p.close();

	query="Update Master_CompanyParty Set CreditLimit_Currency=0";
	pstmt_p=conp.prepareStatement(query);
	i=pstmt_p.executeUpdate();
	pstmt_p.close();
	C.returnConnection(conp);
%>	
	<h3>  Column Added Successfully In Master_Account Table and set to default 0</h3>
	<br>
	<h3>  System Run completed Successfully </h3>

<%
		
}
catch(Exception e)
{
	C.returnConnection(conp);
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