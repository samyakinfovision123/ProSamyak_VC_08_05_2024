<!-- 
	 URL Path = Nippon/Samyak/EffectiveRateSystemRun.jsp?command=Samyak06 
	 This System Run is made to update the effective rate to opening purchase rate as on 01/04/2003 for which effective rate is 0 
-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<jsp:useBean id="S" class="NipponBean.str"/>
<%
		Connection cong = null;
	    Connection conp = null;
		String errLine="";
%>
<%
	try
	{
String command=request.getParameter("command");

if(command.equals("Samyak06")){

		ResultSet rs_g= null;
		PreparedStatement pstmt_g=null;
		PreparedStatement pstmt_s=null;
		int Counter=0;

		try	
		{
			cong=C.getConnection();
		}
		catch(Exception Samyak31)
		{ 
			 out.print("Samyak31 : "+ Samyak31);
		}

		String query="select RT.Local_Price,RT.Receive_Price, ER.Purchase_Price ,RT.Lot_Id  as Counter from Receive R,Receive_transaction RT,Effective_Rate ER where opening_stock=1 and RT.Receive_Id=R.Receive_Id and Receive_Date='2006-03-31' and RT.Lot_Id=ER.Lot_Id and RT.Receive_Price <> ER.Purchase_Price and ER.Purchase_Price=0";

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();

		while(rs_g.next())
		{
			Counter ++; 
		}
		pstmt_g.close();
		out.print("<br> Number Of rows affected are :-  "+Counter);
%>
				<!-- Query for Update -->
<%

		String updatequery="Update Effective_Rate  set Effective_Rate.Purchase_Price=RT.Receive_Price, Effective_Rate.Modified_MachineName='SAMYAK 2006-07-12' from Receive R,Receive_transaction RT where R.opening_stock=1 and RT.Receive_Id=R.Receive_Id and Effective_Rate.Effective_Date='2006-04-01' and R.Receive_Date='2006-03-31' and RT.Lot_Id=Effective_Rate.Lot_Id and RT.Dollar_Price <> Effective_Rate.Purchase_Price and Effective_Rate.Purchase_Price=0"; 
	
	    pstmt_s = cong.prepareStatement(updatequery);
    	int a = pstmt_s.executeUpdate();
	    pstmt_s.close();
		out.print("<br>"+Counter +"  Number of lines is Updated");
		out.print("<br>System Run is completed");

%>

<%
	C.returnConnection(cong);
	C.returnConnection(conp);
}//command
}//try block
catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("<br>87 The error in file Noname1.jsp ="+e+"and err on ="+errLine);
}
%>