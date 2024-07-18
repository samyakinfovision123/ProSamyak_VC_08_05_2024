<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<% 

Connection conp=null;
PreparedStatement pstmt_p=null;
String query="";



try{

	try
	{
	conp=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }



	query="insert into Master_Shade (Shade_Id,Shade_Name,Shade_Description,Sr_No, active) values(?,?,?,?,?)"; 
	
	pstmt_p=conp.prepareStatement(query);

	pstmt_p.setString(1,""+23);
	pstmt_p.setString(2,"VLY");
	pstmt_p.setString(3,"VLY");
	pstmt_p.setString(4,""+23);
	pstmt_p.setBoolean(5,true);

	int a=pstmt_p.executeUpdate();
	pstmt_p.close();

    C.returnConnection(conp);
%>
	<script language="JavaScript">
	alert("Updated Successfully")
	window.close();
	</script>
<%
}catch(Exception e){ conp.rollback();
out.print("Outermost try "+e);}
%>

