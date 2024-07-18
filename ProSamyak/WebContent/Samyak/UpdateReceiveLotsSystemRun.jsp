

<!-- 
For Run the System Run:-

append to the url in the browser 
Samyak/UpdateReceiveLotsSystemRun.jsp?command=Samyak07



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
	catch(Exception Samyak31){
	 	out.println("<font color=red> FileName : 	UpdateReceiveLotsSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
	}

	int tempx = 0;
    String update_query="";
    String first_query="";
    out.print("<br>Starting System Run");
	  
	first_query="SELECT RT.Receive_Id, count(RT.ReceiveTransaction_Id) as RTCount, sum(RT.Quantity) as RTQuantity From Receive R, Receive_Transaction RT where R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1 group by RT.Receive_Id";
	
	pstmt_g = cong.prepareStatement(first_query);
	
	rs_g = pstmt_g.executeQuery();
	
	while(rs_g.next()) 	
	{
	   int receive_id=rs_g.getInt("Receive_Id");
	   int RTCount = rs_g.getInt("RTCount");
	double RTQuantity=rs_g.getDouble("RTQuantity");	   
	   String subQuery = "Select Receive_Lots,Receive_Quantity from Receive where Receive_Id="+receive_id;	  
	   pstmt_p = conp.prepareStatement(subQuery);
	
	   rs_p = pstmt_p.executeQuery();
	   int Receive_Lots=0;
	   double Receive_Quantity=0;
	   while(rs_p.next()) 	
	   {
		   Receive_Lots = rs_p.getInt("Receive_Lots");
		   Receive_Quantity = rs_p.getDouble("Receive_Quantity");
	   }
	   pstmt_p.close();

	   if(Receive_Lots!=RTCount || Receive_Quantity!=RTQuantity )
	   {
         
			update_query="Update Receive set Receive_Lots="+RTCount+" ,Receive_Quantity="+RTQuantity+" where Receive_Id="+receive_id;

			pstmt_p = conp.prepareStatement(update_query);
			tempx += pstmt_p.executeUpdate();
			pstmt_p.close();
			out.print("<br>Updated receive_id="+receive_id);
	   }
	  }

	  pstmt_g.close();

out.print("<br>"+tempx+" rows updated");
out.print("<br>System Run Complete");
C.returnConnection(cong);
C.returnConnection(conp);

}

}catch(Exception e)
  {
	out.print("<br>The error in file UpdateReceiveLotsSystemRun.jsp"+e);
  }
%>