<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,RoyalBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L" class="RoyalBean.login" />
<jsp:useBean id="A" class="RoyalBean.Array" />
<jsp:useBean id="C"  scope="application" class="RoyalBean.Connect" />
<jsp:useBean id="I" class="RoyalBean.Inventory" />
<jsp:useBean id="S" class="RoyalBean.Stock" />
<jsp:useBean id="G" class="RoyalBean.GetDate" />

<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

try{
int current_id=0; 
int total_rows=0;

%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body>

<%
//String query="UPDATE Receive SET Return=0 WHERE Purchase=1 and Consignment_ReceiveId=0 and opening_stock=0";
String query="UPDATE Receive SET Return=0 WHERE Purchase=1 and consignment_ReceiveId=0 and opening_stock=0 and Return=1";
pstmt_g = cong.prepareStatement(query);
int a308 = pstmt_g.executeUpdate();
out.println("<center><br> Samyak Run Successful "+a308);
out.println("<br> Successfully Updated Rows "+a308);
out.println("<br><b><font color=green>Please Close this window </font></b><br></center>");
%>
<script language="JavaScript">
function f1()
{
alert("Data Sucessfully Updated");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
<%

pstmt_g.close();
%>
</body>
</html>
<%
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakRun1.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>




