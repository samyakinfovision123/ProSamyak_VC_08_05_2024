

<!-- 
For Run the System Run:-

append to the url in the browser 
Samyak/ConsignmentAvailQtySystemRun.jsp?command=Samyak07



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
		 out.println("<font color=red> FileName :ConsignmentAvailQtySystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 1;
       String update_query="";
       
	   String first_query="";
	   String second_query="";
      //distinct(main.Receive_Id) AS MainReceiveId   
	// 
	  
	  
	
		second_query="SELECT DISTINCT (mainRT1.ReceiveTransaction_Id) as MRTT , mainRT1.Quantity as MRTQ, sum(mainRT2.Quantity) as SRTQ FROM Receive_Transaction AS mainRT1, Receive_Transaction AS mainRT2 WHERE   mainRT2.Consignment_ReceiveId=mainRT1.ReceiveTransaction_Id and mainRT1.Active=1  and mainRT2.Active=1 and mainRT1.Receive_Id in(SELECT main.Receive_Id  AS MainReceiveId FROM Receive AS main  where main.Purchase=0 And main.Opening_Stock=0 And main.Active=1 And main.R_Return=0  group by main.Receive_Id) GROUP BY mainRT1.ReceiveTransaction_Id, mainRT1.Quantity";
	
	  
	  
	  
		pstmt_p = conp.prepareStatement(second_query);
	
		rs_p = pstmt_p.executeQuery();
		int count1=1;
		out.print("<br>83 secondQuery=="+second_query);
		while(rs_p.next()) 
		{
	  
			int rtt_id=rs_p.getInt("MRTT");
			out.print("<br> "+count1+" rtt_id="+rtt_id);
			double rtt_qty=rs_p.getDouble("MRTQ");
			//out.print("<br>");
			out.print("Quantity="+rtt_qty);
			double rtt_secqty=rs_p.getDouble("SRTQ");
			 
			//out.print("<br>");
			out.print("AvlQuantity=>"+rtt_secqty);


			update_query="Update Receive_Transaction  set Available_Quantity=(Quantity-"+rtt_secqty+") where ReceiveTransaction_Id="+rtt_id+" and  Consignment_ReceiveId=0 and Active=1";

            //out.print("<br>");
            
			//out.print("<br> Update Query=>"+update_query);
             
	        pstmt_h = conh.prepareStatement(update_query);
			tempx = pstmt_h.executeUpdate();
			//out.print("<br>");
			//out.print("Data Successfully Updated ! ");
			//out.print("<br>");
	 
			pstmt_h.close();
	    }
	  
	  	pstmt_p.close();	

		out.print("<br>System Run part 1 complete");
		out.print("<br>System Run part 2 started");

		String cgtSaleQuery = "SELECT ReceiveTransaction_Id FROM Receive R, Receive_Transaction RT where R.Purchase=0 And R.Receive_Sell=0 And R.Opening_Stock=0 And R.Active=1 And R.R_Return=0 and R.Receive_Id=RT.Receive_Id";
		
		pstmt_g = cong.prepareStatement(cgtSaleQuery);
		rs_g = pstmt_g.executeQuery();

		while(rs_g.next())
		{
			String RT_Id = rs_g.getString("ReceiveTransaction_Id");
			
			String cgtReceiveIdQuery = "SELECT count(*) as cgtRTIdCount FROM Receive_Transaction where Consignment_ReceiveId="+RT_Id+" and Active=1";
			
			pstmt_p = conp.prepareStatement(cgtReceiveIdQuery);
			rs_p = pstmt_p.executeQuery();

			int cgtRTIdCount = -1;
			while(rs_p.next())
			{
				cgtRTIdCount = rs_p.getInt("cgtRTIdCount");
			}
			pstmt_p.close();

			if(cgtRTIdCount==0)
			{
				String updateQuery = "Update Receive_Transaction Set Available_Quantity = Quantity where ReceiveTransaction_Id="+RT_Id;
			
				pstmt_p = conp.prepareStatement(updateQuery);
				int a = pstmt_p.executeUpdate();
				pstmt_p.close();
			}

		}
		pstmt_g.close();	
		out.print("<br>System Run part 2 complete");
		out.print("<br>System Run Finished");


C.returnConnection(conh);
C.returnConnection(conp);
C.returnConnection(cong);

}

}catch(Exception e)
  {
	out.print("<br>137  The error in file ConsignmentAvailQtySystemRun.jsp"+e);
  }
%>









			
			
			
			