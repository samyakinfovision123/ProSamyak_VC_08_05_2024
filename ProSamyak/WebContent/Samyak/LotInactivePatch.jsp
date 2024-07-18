<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>


<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect"/>

<%
try	
{
Connection conp = null;
PreparedStatement pstmt_p=null;
ResultSet rs_g=null;
try	
{
	conp=C.getConnection();
}
catch(Exception e31)
{out.println("<font color=red> FileName : Bug No e16 : "+ e31);}


out.print("<br> 19 UP");

String query="Update Lot set Active=0 where Lot_id = any  (select distinct(RT.Lot_Id) from Receive R , Receive_Transaction RT where R.Receive_Id = RT.Receive_Id and R.Opening_Stock = 1 and R.Receive_Quantity = 0 and RT.Lot_Id <> any ( select RT.Lot_Id from Receive R , Receive_Transaction RT where R.Receive_Id = RT.Receive_Id and R.Opening_Stock = 0 ))";


//String query=" select Lot_Id from Receive R , Receive_Transaction RT where R.Receive_Id = RT.Receive_Id and R.Opening_Stock = 0 ";

out.print("<br> query :" +query);

pstmt_p = conp.prepareStatement(query);

out.print("<br> 26 UP");
int a32 = pstmt_p.executeUpdate();
out.print("<br>Down");
pstmt_p.close();
	
C.returnConnection(conp);
}
catch(Exception e31)
{out.println("<font color=red> FileName : Bug No e31 : "+ e31);}
%>




