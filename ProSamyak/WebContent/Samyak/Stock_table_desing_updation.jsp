
 <!--  
Use of System Run:- Add column to Master_Account Table
How to Run System Run:-
Type in url:-/Samyak/Stock_table_desing_updation.jsp?command=Samyak


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
	
	query="ALTER TABLE stock ALTER COLUMN ClosingQuantity numeric(19, 4)  not null ";
	pstmt_p=conp.prepareStatement(query);
	int i1=pstmt_p.executeUpdate();
	pstmt_p.close();
	
	
	query="ALTER TABLE stock ALTER COLUMN ClosingLocalAmount numeric(19, 4)  not null ";
	pstmt_p=conp.prepareStatement(query);
	int i2=pstmt_p.executeUpdate();
	pstmt_p.close();

	query="ALTER TABLE stock ALTER COLUMN ClosingDollarAmount numeric(19, 4)  not null ";
	pstmt_p=conp.prepareStatement(query);
	int i3=pstmt_p.executeUpdate();
	pstmt_p.close();
	
	C.returnConnection(conp);





%>	
	
	
	<h2>  Column Updated Successfully In Stock Table</h2>
	<br>
	<h2>  System Run completed Successfully </h2>

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