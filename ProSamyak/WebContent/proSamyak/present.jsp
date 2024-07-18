
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy				Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    Shrikant,Ganesh Girnar	17/05/2011	 Start 		Adding present button for today's present engineers 
* 1   Shrikant,Ganesh Girnar	17/05/2011	 Done 		Adding present button for today's present engineers
-->


<%@ page language="java" import="java.sql.Connection ,java.sql.Timestamp,java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"	pageEncoding="utf-8"
contentType="text/html; charset=utf-8"	%>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED" class="NipponBean.YearEndDate" /> 
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />


<%
Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs_g=null;
long engineerId=0;
String engineerName="";
String presentquery="";

List engId=new ArrayList();
String attendQuery="";
String TodayString="";
System.out.println("Time is");

java.sql.Date currentTime = new java.sql.Date(System.currentTimeMillis());
Timestamp f1=new Timestamp(System.currentTimeMillis());
System.out.println("Time is=============="+currentTime);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
int dd=D.getDate()+1;
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String invoicedate=format.format(Dprevious);
System.out.println(Dprevious);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<table border=1 cellspacing=1 align=center>
<tr>
<td colspan=4 align=center>Today's Present Engineers Information
</td></tr>
<tr>
<td >Sr No.</td>
<td align=center>Engineer Name</td>

</tr>

<%

try{
	con=C.getConnection();
	System.out.println("Time is");
	int count=1;
	

presentquery= "	select DISTINCT  m.engineername from Attendance a,masterengineer m where  a.time between '"+f1+"'and '"+Dprevious+"' and a.engineerid=m.engineerid";
System.out.println("presentquery"+presentquery);

pstmt=con.prepareStatement(presentquery);
rs_g=pstmt.executeQuery();
while(rs_g.next())
{
	//engId.add(rs_g.getLong("engineerId"));
	
%>
<tr>
<td><%=count++%></td>
<td align=center><%=rs_g.getString("engineerName") %></td>
</tr>
<% 
//count++;
}

pstmt.close();	

}catch(Exception e)
{
	System.out.println(e);
}
%>

</table>
</body>
</html>