<!--
System Run to Match Due Date According Due Days in Receive Table

http://localhost:8080/Nippon/Samyak/ABCDueDate.jsp?command=Nippon05&Due_Date=mm/dd/yyyy&Receive_Id=  -->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
Connection cong = null;

String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

try
	{
	String command=request.getParameter("command");
	String Due_Date=request.getParameter("Due_Date");
	String Receive_Id=request.getParameter("Receive_Id");
if(command.equals("Nippon05"))
	{
	int a25=0;
	String query="";
	
	ResultSet rs_g= null;
	PreparedStatement pstmt_g=null;

try	{
	cong=C.getConnection();
	}
catch(Exception Samyak31)
	{
	out.println("<font color=red> FileName : 	ABCDueDate.jsp<br>Bug No Samyak31 : "+ Samyak31);
	}

	query="UPDATE Receive SET Due_Date=?, Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+" where receive_id=?";

				pstmt_g = cong.prepareStatement(query);
				pstmt_g.setString(1,""+Due_Date);
				pstmt_g.setString(2,""+Receive_Id);
				a25 = pstmt_g.executeUpdate();
				pstmt_g.close();

C.returnConnection(cong);
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
</body>
</html>
<%
}//If Part
}//Try Part
catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
   
  out.println("<font color=red> FileName : ABCDueDate.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
%>