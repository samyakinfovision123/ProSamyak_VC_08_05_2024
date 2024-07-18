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
if(command.equals("Update Data")){
//out.print("<br>23Hans");
String query="";

try	{
	 cong=C.getConnection();
	 conp=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	lotMismatch.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

// Code for connection end here

int count = Integer.parseInt(request.getParameter("count"));

String Receive_Id[] = new String[count];
int newReceive_Lots[] = new int[count];
for(int i=0; i<count; i++)
{
	Receive_Id[i] = request.getParameter("Receive_Id"+i);
	newReceive_Lots[i] = Integer.parseInt(request.getParameter("RTLotCount"+i));
}

int rowsUpdate =0;
out.print("Starting System Run");
for(int i=0; i<count; i++)
{
	query="Update Receive Set Receive_Lots="+newReceive_Lots[i]+" Where Receive_Id="+Receive_Id[i];
	pstmt_g = cong.prepareStatement(query);

	rowsUpdate += pstmt_g.executeUpdate();	
	pstmt_g.close();

}
out.print("System Run Complete.<br> "+rowsUpdate+" rows updated");


C.returnConnection(cong);
C.returnConnection(conp);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
	C.returnConnection(cong);
	C.returnConnection(conp);

	out.println("<font color=red> FileName : lotMismatch.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
