<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;

String command  = request.getParameter("command");


ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;

if("UPDATE PARTY GROUP".equals(command))
{
try{
	conp=C.getConnection();
	String partygroup_id= request.getParameter("partygroup_id");
	String partygroup_name		=request.getParameter("partygroup_name");	
	String partygroup_code= request.getParameter("partygroup_code");
	String active= request.getParameter("active");
	boolean flag =false; 
	if("yes".equals(active)){flag=true;}

	String query ="Update Master_PartyGroup set PartyGroup_Name=?, PartyGroup_Code=?, active=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where PartyGroup_Id=?";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString (1, partygroup_name);
	pstmt_p.setString (2,partygroup_code);
	pstmt_p.setBoolean(3,flag);
	pstmt_p.setString (4, user_id);
	pstmt_p.setString (5,""+today_date);
	pstmt_p.setString(6,machine_name);
	pstmt_p.setString (7,partygroup_id);	   
	int a = pstmt_p.executeUpdate();
	pstmt_p.close();
	C.returnConnection(conp);

	response.sendRedirect("EditPartyGroup.jsp?command=Default&message=Party Group <font color=blue> "+partygroup_name+"  </font> successfully Updated");

}
catch(Exception e233){ 
	out.println("<br><font color=red><h2> FileName : UpdatePartyGroup.jsp <br>Bug No e233 :"+ e233 +"</h2></font>");}
}//if UPDATE PARTY GROUP*/
%>








