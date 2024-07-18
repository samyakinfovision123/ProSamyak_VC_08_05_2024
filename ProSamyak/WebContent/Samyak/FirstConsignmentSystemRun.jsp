

<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/FirstConsignmentSystemRun.jsp?command=Samyak07



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
	ResultSet rs_p= null;

    Connection cong = null;
    Connection conp = null;
    Connection conh = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
    PreparedStatement pstmt_h=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
		conh=C.getConnection();
	     
		 
		 }
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName :FirstConsignmentSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 1;
       String update_query="";
       
	   String first_query="";
	   String second_query="";
      //distinct(main.Receive_Id) AS MainReceiveId   
	// 
	  first_query="SELECT main.Receive_Id  AS MainReceiveId FROM Receive AS main, Receive AS sec, Receive AS th WHERE sec.Receive_Sell=0 And sec.Purchase=1 And main.Purchase=0 And main.Receive_Sell=0 And main.Receive_Id=sec.Consignment_ReceiveId And main.Opening_Stock=0 And sec.Opening_Stock=0 And sec.Return=0 And sec.Return=0 And sec.Consignment_ReceiveId>0 And sec.Cgt_ReturnConfirm>0  And sec.Cgt_ReturnConfirm>0 and sec.Active=1 and main.Receive_FromId=  sec.Receive_FromId and th.Consignment_ReceiveId=main.Receive_Id and th.Receive_Sell=1 and th.Purchase=0 and th.Opening_Stock=0 and sec.Consignment_ReceiveId=main.Receive_Id and th.Return=1 and th.Receive_FromId=main.Receive_FromId and th.Active=1 group by main.Receive_Id";
	  
	
	   pstmt_g = cong.prepareStatement(first_query);
	   //, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY
		  


	   
	   rs_g = pstmt_g.executeQuery();
	   
	   int c=0;

	   
	   while(rs_g.next()) 	
	
	  {
		  
		  int main_rid=rs_g.getInt("MainReceiveId");
		   
		  
		   out.print("<br>82<font color=#CC0000> MainReceiveId=</font>"+main_rid);
	 
	out.print("<br>");

second_query="SELECT DISTINCT (mainRT1.ReceiveTransaction_Id) as MRTT , mainRT1.Quantity as MRTQ, sum(mainRT2.Quantity) as SRTQ FROM Receive_Transaction AS mainRT1, Receive_Transaction AS mainRT2 WHERE   mainRT2.Consignment_ReceiveId=mainRT1.ReceiveTransaction_Id and mainRT1.Active=1  and mainRT2.Active=1 and mainRT1.Receive_Id="+main_rid+"  GROUP BY mainRT1.ReceiveTransaction_Id, mainRT1.Quantity";
	
	  
	  
	  
	  pstmt_p = conp.prepareStatement(second_query);
	
	   rs_p = pstmt_p.executeQuery();
	//out.print("<br>83 secondQuery=="+second_query);
	   while(rs_p.next()) 
		  {
	  
	  int rtt_id=rs_p.getInt("MRTT");
	  out.print("<br>98 Receive_Transction_Id="+rtt_id);
	  int rtt_qty=rs_p.getInt("MRTQ");
	  out.print("<br>");
	  out.print("<br>99 Quantity="+rtt_qty);
	  int rtt_secqty=rs_p.getInt("SRTQ");
	 
	  out.print("<br>");
	  out.print("<br>104 Sum of AvlQuantity=>"+rtt_secqty);






		update_query="Update Receive_Transaction  set Available_Quantity=(Quantity-"+rtt_secqty+") where ReceiveTransaction_Id="+rtt_id+" and  Consignment_ReceiveId=0 and Active=1";

             out.print("<br>");
            
			 out.print("<br> Update Query=>"+update_query);
             
	         pstmt_h = conh.prepareStatement(update_query);
			 tempx = pstmt_h.executeUpdate();
			 out.print("<br>");
			 out.print("Data Successfully Updated ! ");
	  out.print("<br>");
	  c++;
	  
	  
	  }
	  
	  }	
		
		
	
}
}catch(Exception e)
  {
	out.print("<br>137  The error in file FirstConsignmentSystemRun.jsp"+e);
  }
%>









			
			
			
			