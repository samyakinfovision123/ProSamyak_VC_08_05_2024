

<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/firstConsign1.jsp?command=Samyak07



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
      //distinct(main.Receive_Id) AS MainReceiveId   
	// 
	  first_query="SELECT count(*) as totalCount  AS MainReceiveId FROM Receive AS main  WHERE   main.Purchase=0 And main.Receive_Sell=0   And main.Opening_Stock=0   and main.Active=1 ";
	  
	pstmt_g = cong.prepareStatement(first_query);
	   
		  

	   
	   rs_g = pstmt_g.executeQuery();
	   
	   int count=0;

	  
	   while(rs_g.next()) 	
	
	  {
		  //c=0;
	     count=rs_g.getInt("totalCount");
		   
		  //String main_rno=rs_g.getString("mainReceiveno");
		   
		  //int sec_rid=rs_g.getInt("SecReceiveid");
		   
		  //int th_rid=rs_g.getInt("ConsignmentReturnid");
		   
		   out.print("<br>74 totalCount="+count);
	 
	
	 /*
	  second_query="SELECT DISTINCT (mainRT1.ReceiveTransaction_Id) as MRTT , mainRT1.Quantity as MRTQ, sum(mainRT2.Quantity) as SRTQ FROM Receive_Transaction AS mainRT1, Receive_Transaction AS mainRT2 WHERE   mainRT2.Consignment_ReceiveId=mainRT1.ReceiveTransaction_Id and mainRT1.Active=1  and mainRT2.Active=1 and mainRT1.Receive_Id="+main_rid+"  GROUP BY mainRT1.ReceiveTransaction_Id, mainRT1.Quantity";
	
	  //out.print("<br>83 secondQuery=="+second_query);
	  
	  //SELECT DISTINCT (mainRT1.ReceiveTransaction_Id), mainRT1.Quantity, sum(mainRT2.Quantity)
//FROM Receive_Transaction AS mainRT1, Receive_Transaction AS mainRT2
//WHERE mainRT1.Receive_Id=5 and //mainRT2.Consignment_ReceiveId=mainRT1.ReceiveTransaction_Id and 
//mainRT1.Active=true and mainRT2.Active=true
//GROUP BY mainRT1.ReceiveTransaction_Id, mainRT1.Quantity;

	  
	  
	  pstmt_g = cong.prepareStatement(second_query);
	
	   rs_g = pstmt_g.executeQuery();
	//out.print("<br>83 secondQuery=="+second_query);
	   while(rs_g.next()) 
		  {
	  int rtt_id=rs_g.getInt("MRTT");
	  out.print("<br>85 RT_Id="+rtt_id);
	  int rtt_qty=rs_g.getInt("MRTQ");
	  out.print("<br>87 MainQty="+rtt_qty);
	  int rtt_secqty=rs_g.getInt("SRTQ");
	  out.print("<br>89 Sum Quantity="+rtt_secqty);





//update_query="";
//updatequery="";
	  
	  //Update Receive_Transaction RT1,Receive_Transaction RT2 set //RT1.Available_Quantity=(RT1.Available_Quantity+RT2.Available_Qua//ntity) where RT1.ReceiveTransaction_Id=RT2.Consignment_ReceiveId //and RT2.Active=0  and RT1.Consignment_ReceiveId=0
	  
	  
	  c++;
	  
	  
	  }
	  out.print("<br>118 after second query:");
	//c++;	
	*/
	  }	
		
		/*
		
		second_query="SELECT distinct(mainRT1.ReceiveTransaction_Id) as MRT_id, mainRT1.Quantity as MRTQty, sum(mainRT2.Quantity) as AvlQty FROM Receive_Transaction AS mainRT1, Receive_Transaction AS mainRT2 WHERE mainRT1.Receive_Id="+ main_rid+"and mainRT2.Consignment_ReceiveId=mainRT1.ReceiveTransaction_Id and mainRT1.Active=1 and mainRT2.Active=1 GROUP BY mainRT1.ReceiveTransaction_Id, mainRT1.Quantity";

		pstmt_g = cong.prepareStatement(second_query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	
	
	  {
			
			
        int main_rid11=rs_g.getInt("MRT_id");
        out.print("<br>88 main_rid11=>"+main_rid11);
		int Main_Qty=rs_g.getInt("MRTQty");
		out.print("<br>90 Main_Qty=>"+Main_Qty);
		int AVL_QTY= rs_g.getInt("AvlQty");
		  
		  //String main_rno=rs_g.getString("mainReceiveno");
		   
		  

      out.print("<br>95secQty1=>"+AVL_QTY);
      }
	  }

*/
}
}catch(Exception e)
  {
	out.print("<br>137  The error in file FirstConsignmentSystemRun.jsp"+e);
  }
%>









			
			
			
			