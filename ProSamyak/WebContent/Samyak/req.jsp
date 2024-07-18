
<!-- 
The jsp file is made for updating the entry of invoice in the Payment_Details table and set Active=0  

-->

<!-- 

Keys for execution

Samyak/Nippon/Samyak/ConsignmentSystemRun.jsp?command=Nippon05

-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{

String command=request.getParameter("command");

if(command.equals("Nippon05")){
	
	
	
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
	   String update_query="";
     //double  recordcount=0;

//out.print("<br>69 Samyak");


query="select main.Receive_Id  as FID ,main.Receive_No as FRNO, sec.Receive_Id as SID ,sec.Receive_No as SRNO from Receive main, Receive sec where main.Receive_Id=sec.Consignment_ReceiveId  and main.Receive_sell=sec.Receive_Sell  and main.Purchase=0 and  sec.purchase=1 and main.Opening_Stock=sec.Opening_Stock and sec.Active=0  and main.Return=0 and sec.Return=0"; 
pstmt_g = cong.prepareStatement(query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	

           {
		   int receive_id_main=rs_g.getInt("FID");
		 
		  String receive_no_main=rs_g.getString("FRNO");
		   
		   int receive_id_sec=rs_g.getInt("SID");
		 
		   String receive_no_sec=rs_g.getString("SRNO");
		   
		   		        	  
			 update_query="Update Receive_Transaction set Active=0 where Receive_Id="+receive_id_sec;
			 pstmt_g = cong.prepareStatement(update_query);
			 tempx = pstmt_g.executeUpdate();
			 out.print("Data Successfully Updated ! ");
		
		    }
	
	 }




}catch(Exception e)
  {
	out.print("<br>79 The error in file ftqtysystem_run.jsp"+e);
  }
%>



</BODY>
</HTML>
