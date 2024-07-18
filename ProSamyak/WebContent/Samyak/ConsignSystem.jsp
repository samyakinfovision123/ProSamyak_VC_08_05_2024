

<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/UpdateToByNosSystemRun.jsp?command=Samyak07



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
		 out.println("<font color=red> FileName : 	UpdateToByNosSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 0;
       String update_query="";
       
	   String first_query="";
	   String second_query="";
      
	  first_query="SELECT  main.Receive_Id AS MainReceiveId, sec.Receive_Id AS SecReceiveid,  th.Receive_Id AS ConsignmentReturnid FROM Receive AS main, Receive AS sec, Receive AS th WHERE sec.Receive_Sell=False And sec.Purchase=True And main.Purchase=False And main.Receive_Sell=False And main.Receive_Id=sec.Consignment_ReceiveId And main.Opening_Stock=False And sec.Opening_Stock=False And sec.Return=False And sec.Return=False And sec.Consignment_ReceiveId>0 And sec.Cgt_ReturnConfirm>0  And sec.Cgt_ReturnConfirm>0 and sec.Active=true and main.Receive_FromId=  sec.Receive_FromId and th.Consignment_ReceiveId=main.Receive_Id and th.Receive_Sell=true and th.Purchase=false and th.Opening_Stock=false and sec.Consignment_ReceiveId=main.Receive_Id and th.Return=true and th.Receive_FromId=main.Receive_FromId and th.Active=true";
	  
	
	   pstmt_g = cong.prepareStatement(first_query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	
	
	  {
		  int main_rid=rs_g.getInt("MainReceiveId");
		   
		  //String main_rno=rs_g.getString("mainReceiveno");
		   
		  int sec_rid=rs_g.getInt("SecReceiveid");
		   
		  int th_rid=rs_g.getInt("ConsignmentReturnid");
		   
		   
		second_query="SELECT mainRT11.ReceiveTransaction_Id as m11Id, mainRT11.Quantity as  m11Qty, mainRT22.ReceiveTransaction_Id as m22Id, mainRT22.Quantity as m22Qty FROM Receive_Transaction AS mainRT11, Receive_Transaction AS mainRT22 WHERE mainRT11.Receive_Id="+main_rid+" and mainRT22.Consignment_ReceiveId=mainRT11.ReceiveTransaction_Id and mainRT11.Active=1 and mainRT22.Active=1 GROUP BY mainRT11.ReceiveTransaction_Id, mainRT11.Quantity, mainRT22.ReceiveTransaction_Id, mainRT22.Quantity";

		pstmt_g = cong.prepareStatement(second_query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	
	
	  {
			
			
        int main_rid=rs_g.getInt("m11Id");
		   
		  //String main_rno=rs_g.getString("mainReceiveno");
		   
		  int mainQty1=rs_g.getInt("m11Qty");
		   
		  int sec_rt_id=rs_g.getInt("m22Id");

		int secQty1+=rs_g.getInt("m22Qty");

      out.print("<br>95secQty1"+secQty1);
      }
	  }
}
}catch(Exception e)
  {
	out.print("<br>101  The error in file UpdateToByNosSystemRun.jsp"+e);
  }
%>









			
			
			
			