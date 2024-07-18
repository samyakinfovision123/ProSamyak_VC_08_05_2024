<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<%
String user_id= ""+session.getValue("user_id");

Connection cong = null;
try{

	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;	
 
	cong=C.getConnection();


//String query="Update Master_User set Logged_In=? where user_id=?";
//pstmt_p = cong.prepareStatement(query);
//pstmt_p.setBoolean(1,false);
//pstmt_p.setString (2,user_id);
//int a692 = pstmt_p.executeUpdate();
//pstmt_p.close();

C.returnConnection(cong);

}
	catch(Exception Dove89)
	{ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : SparklerSession.jsp <br>Bug No Dove89 :"+ Dove89 +"</font>");
	}

session.putValue("user_id","");
session.putValue("user_level",""+"");
session.putValue("outlet_id","");
session.invalidate();
response.sendRedirect("../index.html");
%>
