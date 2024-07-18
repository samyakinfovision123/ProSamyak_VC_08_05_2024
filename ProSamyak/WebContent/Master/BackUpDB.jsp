<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
ResultSet rs_p= null;
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
String samyakError="8";
try{
String command=request.getParameter("command");
int tempx=0;
//if(command.equals("Samyak"))
{
%>
<html>
<head>
<title></title>
</head>
<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<%
// Code for connection start here
String query="";
cong=C.getConnection();
conp=C.getConnection();

Calendar D = Calendar.getInstance();

DatabaseMetaData mtdt = cong.getMetaData();
//out.print("<br>"+mtdt.getURL());
String dbURL = mtdt.getURL();
String dbName="";
StringTokenizer strTkn = new StringTokenizer(dbURL, ";");
int counter=strTkn.countTokens();
for(int i=0; i<counter; i++)
{
	String token = (String)strTkn.nextElement();
	if(token.regionMatches(true, 0, "databasename", 0, 12))
	{
		dbName = token.substring(13);
		break;
	}
}
int itoday_day=D.get(Calendar.DATE);
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.get(Calendar.MONTH)+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.get(Calendar.YEAR));

String tdate = stoday_day + "-" + stoday_month + "-" + today_year;

int itoday_hr=D.get(Calendar.HOUR_OF_DAY );
String stoday_hr=""+itoday_hr;
if (itoday_hr < 10){stoday_hr="0"+itoday_hr;}
int itoday_min=D.get(Calendar.MINUTE);
String stoday_min=""+itoday_min;
if (itoday_min < 10) {stoday_min="0"+itoday_min;}

String ttime = stoday_hr + "-" + stoday_min;

String path=request.getParameter("path");

String backupPath = path + dbName + "_DB_" + tdate + "_" + ttime +".bak";
//out.print("<br>"+backupPath);

query = "BACKUP DATABASE ? TO DISK=? WITH INIT";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1, dbName);
pstmt_g.setString(2, backupPath);

int a = pstmt_g.executeUpdate();

if(a==0 || a==-1)
{
	out.print("<Center><br><font color=Red> <B>Database BackUp Process Successfully Completed.</B></font><br><BR><BR><font color=Blue><B>BackUp at :</B></font> "+backupPath+"<Center>");
}
pstmt_g.close();

C.returnConnection(cong);
C.returnConnection(conp);


}


}catch(Exception e)
{
C.returnConnection(conp);
C.returnConnection(cong);
out.print("<br><font color=red> Error Backing up database:-"+samyakError+"<br>Error is ="+e+"</font>");
}
%>
</BODY>
</HTML>