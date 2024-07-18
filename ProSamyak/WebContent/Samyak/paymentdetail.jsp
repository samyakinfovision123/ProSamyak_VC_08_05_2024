
<!-- 
This file is used for the seeing the records of confirm sale invoices 
having different company names other than Consignment sale invoices
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
			
		pstmt_g = cong.prepareStatement(update_query);
		tempx = pstmt_g.executeUpdate();
	    out.print("Data Successfully Updated ! ");
		
		 
	
	 }

}catch(Exception e)
{
out.print("Exception in PaymentDetailsModification.jsp"+e);
}

%>




































query="Update Receive_Transaction RT1,Receive_Transaction RT2 set RT1.Available_Quantity=(RT1.Available_Quantity+RT2.Available_Quantity) where RT1.ReceiveTransaction_Id=RT2.Consignment_ReceiveId and RT2.Active=0  and RT1.Consignment_ReceiveId=0";
out.print("<br>a601 b4 ");
            //pstmt_g=conp.prepareStatement();
			pstmt_g = conp.prepareStatement(query);
			int a601=pstmt_g.executeUpdate();
			//out.print("<br>77a601 "+a601);
			pstmt_g.close();

    out.print("<font color=red>Data Successfully Updated</font>");
}	  
}catch(Exception e)
  {
	out.print("<br>79 The error in file ConsignmentSystemRun.jsp"+e);
  }
%>