

<!-- 
For Run the System Run:-

append to the url in the browser 
Samyak/ConsignmentAvailQtySystemRun1.jsp?command=Samyak07



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
		 out.println("<font color=red> FileName :ConsignmentAvailQtySystemRun1.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 1;
       String update_query="";
       
	   String first_query="";
	   String second_query="";
      //distinct(main.Receive_Id) AS MainReceiveId   
	// 
	  
	  
	
		second_query="SELECT RT.ReceiveTransaction_Id, R.Receive_Sell, RT.Quantity, RT.Available_Quantity FROM Receive_Transaction AS RT, Receive AS R WHERE   RT.Active=1  and R.Active=1 and RT.Receive_Id = R.Receive_Id and R.Purchase=0 And R.Opening_Stock=0 And R.Return=0";
	
	  	  
		pstmt_p = conp.prepareStatement(second_query);
	
		rs_p = pstmt_p.executeQuery();
		//out.print("<br>83 secondQuery=="+second_query);
		while(rs_p.next()) 
		{
	  
			int rt_id=rs_p.getInt("ReceiveTransaction_Id");
			boolean Receive_Sell = rs_p.getBoolean("Receive_Sell");
			double qty = rs_p.getDouble("Quantity");
			double available_qty = rs_p.getDouble("Available_Quantity");
 
			double confirm_ret_qty=0;
			
			String cgtReceiveIdQuery = "SELECT sum(Quantity) as cgtConfirmReturnCount FROM Receive_Transaction where Consignment_ReceiveId="+rt_id+" and Active=1";
			
			pstmt_g = cong.prepareStatement(cgtReceiveIdQuery);
			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				confirm_ret_qty = rs_g.getDouble("cgtConfirmReturnCount");
			}
			pstmt_g.close();

			double calc_available_qty = qty - confirm_ret_qty;
			if(calc_available_qty != available_qty)
			{
				update_query="Update Receive_Transaction  set Available_Quantity="+calc_available_qty+" where ReceiveTransaction_Id="+rt_id+" and Active=1";
				pstmt_h = conh.prepareStatement(update_query);
				tempx += pstmt_h.executeUpdate();
				pstmt_h.close();
			}
        			
	    }
	  
	  	pstmt_p.close();	

		out.print("<br>System Run Finished");


C.returnConnection(conh);
C.returnConnection(conp);
C.returnConnection(cong);

}

}catch(Exception e)
  {
	out.print("<br>137  The error in file ConsignmentAvailQtySystemRun1.jsp"+e);
  }
%>









			
			
			
			