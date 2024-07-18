
 <!--  
Use of System Run:- Add Loan Ledger  Under Party 
How to Run System Run:-
Type in url:-/Samyak/Set_ParentCompanyParty_Id.jsp?command=Samyak&company_id=


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
PreparedStatement pstmt_g1=null;
ResultSet rs_g=null;
ResultSet rs_g1=null;
String errLine="25";
String query="";
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
java.sql.Date D1 = new java.sql.Date(System.currentTimeMillis());

// To insert head_id , for_head_id and ledger_type assign value to the following variables . 

String for_head="11";
String for_head_id="11";
String ledger_type="";

String  ledger_name="";
if(command.equals("Samyak")&&!("".equals(company_id)))
{%>
	<html>
		<head><title>Add Column</title></head>
		<body> 

<%
	try
	{
		conp=C.getConnection();
		query="Update Ledger set ParentcompanyParty_Id=for_headId where (parentCompanyParty_Id=0 or isNull(parentCompanyParty_Id,100)=100) and for_head=14 and company_id="+company_id;
		pstmt_p=conp.prepareStatement(query);
		int row_updated1 = pstmt_p.executeUpdate();
		pstmt_p.close();
		
		C.returnConnection(cong);
		out.println("System Run Completed....<br>");
	} //try
	catch(Exception e)
	{
		C.returnConnection(conp);
		out.print("<br> Exception 42 : "+e+"errLine="+errLine );
	} //catch
} //if(command.equals("Samyak"))
else
{%>
	
	<h2> Invalid Parameter </h2>
<%}%>
		</body>
	</html> 