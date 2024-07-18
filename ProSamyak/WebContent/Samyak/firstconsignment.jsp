

<!-- 
use of systemrun for the cancellation of 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/firstconsignment.jsp?command=Samyak07



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
      
	  first_query="select main.Receive_Id as mainReceiveid,main.Receive_No as mainReceiveno, sec.Receive_Id as secReceiveid,sec.Receive_No as secReceiveno,sec.Active as SActive  from Receive main, Receive sec where main.Receive_Id=sec.Consignment_ReceiveId  and main.Receive_sell=sec.Receive_Sell  and main.Purchase=false and  sec.purchase=true and main.Opening_Stock=sec.Opening_Stock   and main.Return=0 and sec.Return=0 and sec.active= false";
	  
	
	  pstmt_g = cong.prepareStatement(first_query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	
	
	  {
		  int main_rid=rs_g.getInt("mainReceiveid");
		   
		  String main_rno=rs_g.getString("mainReceiveno");
		   
		  int sec_rid=rs_g.getInt("secReceiveid");
		   
		   String sec_rno=rs_g.getString("secReceiveno");
		   
		   boolean sactive1=rs_g.getBoolean("SActive");

			update_query="Update Receive_Transaction  set Active="+sactive1+" where Receive_Id="+sec_rid;
		    pstmt_g = cong.prepareStatement(update_query);
			tempx = pstmt_g.executeUpdate();
		    out.print("Data Successfully Updated ! ");
	  }//eo while
	}//eo if
}catch(Exception e){
	System.out.println("The Exception is:"+e);
}//eo catch
%>
		  