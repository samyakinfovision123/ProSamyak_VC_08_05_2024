

<!-- 
use of systemrun for the cancellation of 
For Run the System Run:-

append to the url in the browser 
Samyak/SetActiveFalseOfCancelledReceived1.jsp?command=Samyak07



-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
ResultSet rs_g= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	
try{
String command=request.getParameter("command");
	cong=C.getConnection();
	conp=C.getConnection();

if(command.equals("Samyak07")){
	
	
	
	
    



	 int tempx = 0;
     String update_query="";
       
	 String first_query="";
      
	 first_query="select Receive_Id from Receive where Active= 0";
	  
	 pstmt_g = cong.prepareStatement(first_query);
	 rs_g = pstmt_g.executeQuery();
	
	  while(rs_g.next()) 	
	  {
		  int rid=rs_g.getInt("Receive_Id");
		  
		  update_query="Update Receive_Transaction  set Active=0 where Receive_Id="+rid;
		  pstmt_p = conp.prepareStatement(update_query);
		  tempx += pstmt_p.executeUpdate();
		  pstmt_p.close();
	  }//eo while
	  pstmt_g.close();
	  out.print("<br>"+tempx+" rows updated");
	  out.print("<br>System Run Complete");
	
	
	

	
	}//eo if
	C.returnConnection(conp);
    C.returnConnection(cong);
}catch(Exception e){

	C.returnConnection(conp);
    C.returnConnection(cong);
	System.out.println("The Exception is:"+e);
}//eo catch
%>
		  