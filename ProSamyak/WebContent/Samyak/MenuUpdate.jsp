<!--
System Run to update the number of child count in the MenuMaster which is null in some rows

http://localhost:8080/Nippon/Samyak/MenuUpdate.jsp?command=Samyak06  -->
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
// Code for connection start here
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;


try{
String command=request.getParameter("command");
//String table_name="Ledger";
int tempx=0;
if(command.equals("Samyak06")){
//out.print("<br>23Hans");
String query="";

try	{
	 cong=C.getConnection();
	 conp=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	MenuUpdate.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

// Code for connection end here



query="Select count(*) as counter from MenuMaster";
//company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int count=0;
while(rs_g.next())

{
	count = rs_g.getInt("counter");
    //out.print("<br>46 Counter's value "+count);
}
pstmt_g.close();

String Menu_Id[] = new String[count];
int Child_No[] = new int[count];

query="Select MId, ParentId from MenuMaster";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	

int c=0;
while(rs_g.next())
{
	Menu_Id[c] = rs_g.getString("MId");

	String Cquery="Select count(*) as counter from MenuMaster where Active=1 and ParentId="+Menu_Id[c];
	pstmt_p = conp.prepareStatement(Cquery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next())
	{
		Child_No[c] = rs_p.getInt("counter");
	}
	rs_p.close();
	pstmt_p.close();

	c++;
}
pstmt_g.close();

for(int i=0; i<Menu_Id.length; i++)
{
	String sqlUpdate = "Update MenuMaster set No_Child=? where MID=? ";

	pstmt_p = conp.prepareStatement(sqlUpdate);
	pstmt_p.setInt(1, Child_No[i]);
	pstmt_p.setString(2, Menu_Id[i]);
	pstmt_p.executeUpdate();
	pstmt_p.close();

}

out.print("<br>System run complete");
}
C.returnConnection(cong);
C.returnConnection(conp);
}
catch(Exception Samyak31)
 { 
	C.returnConnection(cong);
	C.returnConnection(conp);

	out.println("<font color=red> FileName : MenuUpdate.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
