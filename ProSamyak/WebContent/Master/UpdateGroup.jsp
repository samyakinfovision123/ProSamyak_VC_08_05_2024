<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body>
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;

String command= request.getParameter("command");


	ResultSet rs_g = null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;




if("UPDATE".equals(command))
{
try{

	 	 conp=C.getConnection();



String category_name= request.getParameter("category_name");
int counter= Integer.parseInt(request.getParameter("counter"));
out.print("<br>counter=" +counter);
String subgroup_id[]=new String[counter]; 
String subgroup_name[]=new String[counter]; 
String subgroup_code[]=new String[counter]; 
boolean active[]=new boolean[counter];
for(int i=0; i<counter; i++)
	{
subgroup_id[i]=request.getParameter("subgroup_id"+i);
subgroup_name[i]= request.getParameter("subgroup_name"+i);
subgroup_code[i]= request.getParameter("subgroup_code"+i);
String act=
request.getParameter("active"+i);
//out.print("<br>"+act);
active[i]=false;
if("yes".equals(act)){active[i]=true;}
	}//for

for (int i=0 ; i<counter; i++)
	{

String query="Update  Master_SubGroup set  SubGroup_Name=?, SubGroup_Code=?, Active=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? where SubGroup_Id=?";
out.print("<BR>i="+i+"sq" +query);


pstmt_p = conp.prepareStatement(query);
//out.print("<BR>80" +query);
pstmt_p.setString (1, subgroup_name[i]);
//out.print("<br >1 "+subgroup_name[i]);

pstmt_p.setString (2, subgroup_code[i]);			
//out.print("<br >2 "+subgroup_code[i]);
pstmt_p.setBoolean (3, active[i]);			
//out.print("<br >3 "+active[i]);
pstmt_p.setString (4, user_id);			
//out.print("<br >6 "+user_id);
//pstmt_p.setDate (5, D);
//out.print("<br >7"+D);
pstmt_p.setString (5, machine_name);			out.print("<br >8"+machine_name);
pstmt_p.setString (6, subgroup_id[i]);	
//out.print("<br >7 "+subgroup_id[i]);
int a = pstmt_p.executeUpdate();
//System.out.println(" <BR>Updated Successfully: " +a);
//out.println("<BR>Updated Successfully: " +a);
pstmt_p.close();

}//for
//out.println("<br> Updated Successfully" );
C.returnConnection(conp);

response.sendRedirect("EditGroup.jsp?command=edit&message=Data For "+category_name+" Successfully Updated.");
}catch(SQLException Samyak154)
{
out.println("<br>FileName : UpdateGroup.jsp Bug no Samyak154="+Samyak154);
}
catch(Exception Samyak164){ 
out.println("<br><font color=red> FileName : UpdateGroup.jsp <br>Bug No Samyak164 :"+ Samyak164 +"</font>");}
}//if Update Currency



%>

</body>
</html>





