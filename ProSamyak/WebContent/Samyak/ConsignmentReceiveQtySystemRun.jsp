

<!-- 
For Run the System Run:-

append to the url in the browser 
Samyak/ConsignmentReceiveQtySystemRun.jsp?command=Samyak07



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
	  
	  
	
		second_query="SELECT R.Receive_Id, R.Receive_Quantity FROM Receive AS R WHERE R.Active=1";
	
	  	  
		pstmt_p = conp.prepareStatement(second_query);
	
		rs_p = pstmt_p.executeQuery();
		//out.print("<br>83 secondQuery=="+second_query);
		while(rs_p.next()) 
		{
	  
			int r_id=rs_p.getInt("Receive_Id");
			double receive_qty = rs_p.getDouble("Receive_Quantity");
			 
            double quantity = 0;
			String qtyQuery = "SELECT sum(Quantity) as qty FROM Receive_Transaction where Receive_Id="+r_id+" and Active=1";
			
			pstmt_g = cong.prepareStatement(qtyQuery);
			rs_g = pstmt_g.executeQuery();

			while(rs_g.next())
			{
				quantity = rs_g.getDouble("qty");
			}
			pstmt_g.close();

			if(receive_qty != quantity)
			{
				update_query="Update Receive  set Receive_Quantity="+quantity+" where Receive_Id="+r_id+" and Active=1";
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
	out.print("<br>137  The error in file ConsignmentReceiveQtySystemRun.jsp"+e);
  }
%>









			
			
			
			