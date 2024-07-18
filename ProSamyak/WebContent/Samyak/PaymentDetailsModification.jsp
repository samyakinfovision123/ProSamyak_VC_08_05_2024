
<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/PaymentDetailsModification.jsp?command=Samyak07



-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" 
errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{

String command=request.getParameter("command");

if(command.equals("Samyak07")){
	
	
	
	ResultSet rs_g= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
	     
		 
		 }
	catch(Exception Samyak31)
		{ 
	out.println("<font color=red> FileName:ConsignmentSystem .jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 0;
       
       
	   //String first_query="";
	   String query="";
     //double  recordcount=0;



	  


		 query="Update Payment_Details set Active=0 where For_HeadId>0 and Amount=0 and Local_Amount=0 and Dollar_Amount=0";
			
		pstmt_g = cong.prepareStatement(query);
		tempx = pstmt_g.executeUpdate();
	    
		out.print("Data Successfully Updated ! ");
		
		 
	
	 }

}catch(Exception e)
{
out.print("Exception in PaymentDetailsModification.jsp"+e);
}

%>




































