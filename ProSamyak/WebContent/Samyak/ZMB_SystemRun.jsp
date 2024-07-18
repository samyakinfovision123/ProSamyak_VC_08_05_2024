
 <!--  
Use of System Run:- to Change ZMB  Master_CompanyParty Part's Default Currency
Type in url:-/Samyak/ZMB_SystemRun.jsp?command=Samyak


-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<%

Connection conp=null;
PreparedStatement pstmt_p=null;
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

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
	
	int i=0;
	query="update Master_CompanyParty set Transaction_Currency=0 , Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+" where CompanyParty_ID=73";
	pstmt_p=conp.prepareStatement(query);
	i=pstmt_p.executeUpdate();
	pstmt_p.close();
	C.returnConnection(conp);
	out.print("Rows Updated ="+i);
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
	<h3>  System Run completed Successfully </h3>

</body>
</html>


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