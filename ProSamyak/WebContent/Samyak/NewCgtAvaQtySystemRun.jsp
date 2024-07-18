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
		ResultSet rs_g= null;
		ResultSet rs_p = null;
		ResultSet rs_q = null;
		ResultSet rs_r = null;
		ResultSet rs_s = null;
		
		PreparedStatement pstmt_g=null;
	    PreparedStatement pstmt_p=null;
		PreparedStatement pstmt_q=null;
		PreparedStatement pstmt_r=null;
		PreparedStatement pstmt_s=null;
errLine="25";
		int Counter=0;
%>
<%
		try	
		{
			cong=C.getConnection();
			conp=C.getConnection();
		}
		catch(Exception Samyak31)
		{ 
errLine="36";			 
			 out.print("<font color=red> FileName : 	UpdateToByNosSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
%>
<%
		String query="Select count(*) as Counter from  Receive R, Receive_Transaction RT  where  R.Purchase=0  and R.R_Return=0 and R.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Active=1 and R.Company_Id IN(1,2,3,4)";

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
errLine="45";
		while(rs_g.next())
		{
			Counter=rs_g.getInt("Counter");
		}
		pstmt_g.close();

		String first_query="";
		String second_query="";
		String third_query="";
		String ReceiveTransaction_Id="";
errLine="57";
		double Quantity=0;
		double Available_Quantity=0;
		double Return_Quantity=0;
		double total_qty =0;
		double total_purqty=0;
		double add_totret=0;
		double sub_totret=0;
		int p=0;
		int q=0;
		String command = request.getParameter("command");
		
errLine="67";
//		if(null==command)
if(command.equals("Nippon05"))
		{
errLine="70";
%>
		
		<form name="frm" method=post action="NewCgtAvaQtySystemRun.jsp?command=update">
		
		<center><u><H3>Check for Available Quantity</H3></u></center>	
		
		<table align=center bordercolor=skyblue border=1 cellspacing=1 cellpadding=1 width="70">
			
		<tr>
		 	<th align=center><B>Receive<br>Transaction_Id</B></th>
			<th align=center><B>Quantity</B></th>
			<th align=center><B>Available<br>Quantity</B></th>
			<th align=center><B>Return<br>Quantity</B></th>
			<th align=center><B>TotalPurchase<br>Quantity</B></th>
			<th align=center><B>TotalReturn<br>Quantity</B></th>
			<th align=center><B>ADD(TotPur+TotRet)</B></th>
		</tr>

<!-- ********  Code For Displaing Available Quantity *********--->

<%
		  first_query="Select RT.ReceiveTransaction_Id, RT.Quantity, RT.Available_Quantity,RT.Return_Quantity from  Receive R, Receive_Transaction RT  where  R.Purchase=0  and R.R_Return=0 and R.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Active=1 and R.Company_Id IN(1,2,3,4)";
errLine="92";
		  pstmt_g = cong.prepareStatement(first_query);
		  rs_g = pstmt_g.executeQuery();
		  
		  while(rs_g.next()) 	
		  {
			 ReceiveTransaction_Id= rs_g.getString("ReceiveTransaction_Id");
			 Quantity=rs_g.getDouble("Quantity");
		   Available_Quantity=rs_g.getDouble("Available_Quantity");
			 Return_Quantity=rs_g.getDouble("Return_Quantity");
errLine="103";
			 second_query="Select sum(RT.Quantity) as TotalPurchaseQuantity from  Receive R, Receive_Transaction RT  where  R.Active=1 and 	R.Receive_Id=RT.Receive_Id and R.Purchase=1 and RT.Active=1 and 	RT.consignment_ReceiveId="+ReceiveTransaction_Id;

			 pstmt_p = cong.prepareStatement(second_query);
			 rs_p = pstmt_p.executeQuery();
		  
			 while(rs_p.next()) 	
			 {
				 total_qty = rs_p.getDouble("TotalPurchaseQuantity");
			 }
			 pstmt_p.close();
errLine="114";
			third_query="Select sum(RT.Quantity) as TotalReturnQuantity from  Receive R, Receive_Transaction RT  where  R.Active=1 and R.Receive_Id=RT.Receive_Id and R.Purchase=0 and RT.Active=1 and RT.consignment_ReceiveId="+ReceiveTransaction_Id;

			pstmt_q = cong.prepareStatement(third_query);
			rs_q = pstmt_q.executeQuery();

			while(rs_q.next()) 	
			{
				 total_purqty = rs_q.getDouble("TotalReturnQuantity");
			}
errLine="124";
		     	 add_totret = total_qty + total_purqty;
				 sub_totret = Quantity -add_totret;
				 pstmt_q.close();
errLine="128";
			if(str.mathformat((Quantity-add_totret),2)!= str.mathformat(Available_Quantity,2))
			{
%>	
		<tr>	
			<td width="15%" align=right><%=ReceiveTransaction_Id%></td>
			<td width="25%" align=right><%=str.mathformat(Quantity,2)%></td>
			<td width="25%" align=right><%=str.mathformat(Available_Quantity,2)%>
			</td>
			<td width="25%" align=right><%=str.mathformat(Return_Quantity,2)%>
			</td>		
			<td width="25%" align=right><%=str.mathformat(total_qty,2)%></td>
			<td width="25%" align=right><%=str.mathformat(total_purqty,2)%></td>
			<td width="25%" align=right><%=str.mathformat(add_totret,2)%></td>
		</tr>

			<input type=hidden name=ReceiveTransaction_Id1<%=p%> value=<%=ReceiveTransaction_Id%>>
			<input type=hidden name=Quantity1<%=p%> value=<%=Quantity%>>
			<input type=hidden name=sub_totret1<%=p%> value=<%=sub_totret%>>
			<input type=hidden name=add_totret1<%=p%> value=<%=add_totret%>>
			<input type=hidden name=Available_Quantity1<%=p%> value=<%=Available_Quantity%>>
			<input type=hidden name=Return_Quantity1<%=p%> value=<%=Return_Quantity%>>

<%			p++;
		}//if block end
  }// while  rs_g ()
 errLine="154";
%>
	<input type=hidden name=psize value=<%=p%>>
<%
	pstmt_g.close(); 
%>
</table>
<br><br><br><br>


<!-- ***********  Code For Displaing Return Quantity ***********--->

<center><u><H3>Check for Return Quantity</H3></u></center>
<table align=center bordercolor=skyblue border=1 cellspacing=1 cellpadding=1 width="70">
		<tr>
		 	<th align=center><B>Receive<br>Transaction_Id</B></th>
			<th align=center><B>Quantity</B></th>
			<th align=center><B>Available<br>Quantity</B></th>
			<th align=center><B>Return<br>Quantity</B></th>
			<th align=center><B>TotalPurchase<br>Quantity</B></th>
			<th align=center><B>TotalReturn<br>Quantity</B></th>
		</tr>
<%
		  first_query="Select RT.ReceiveTransaction_Id, RT.Quantity, RT.Available_Quantity,RT.Return_Quantity from  Receive R, Receive_Transaction RT  where  R.Purchase=0  and R.R_Return=0 and R.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Active=1 and R.Company_Id IN(1,2,3,4)";

		  pstmt_q = cong.prepareStatement(first_query);
		  rs_q = pstmt_q.executeQuery();
errLine="180";
		
		  while(rs_q.next()) 	
		  {
			 ReceiveTransaction_Id= rs_q.getString("ReceiveTransaction_Id");
			 Quantity=rs_q.getDouble("Quantity");
		   	 Available_Quantity=rs_q.getDouble("Available_Quantity");
			 Return_Quantity=rs_q.getDouble("Return_Quantity");
	
			 second_query="Select sum(Rt.Quantity) as TotalPurchaseQuantity from  Receive R, Receive_Transaction RT  where  R.Active=1 and 	R.Receive_Id=RT.Receive_Id and R.Purchase=1 and RT.Active=1 and 	RT.consignment_ReceiveId="+ReceiveTransaction_Id;
errLine="190";
			 pstmt_r = cong.prepareStatement(second_query);
			 rs_r = pstmt_r.executeQuery();
		  
			 while(rs_r.next()) 	
			 {
				 total_qty = rs_r.getDouble("TotalPurchaseQuantity");
			 }
			 pstmt_r.close();
errLine="199";
			third_query="Select sum(RT.Quantity) as TotalReturnQuantity from  Receive R, Receive_Transaction RT  where  R.Active=1 and R.Receive_Id=RT.Receive_Id and R.Purchase=0 and RT.Active=1 and RT.consignment_ReceiveId="+ReceiveTransaction_Id;

			pstmt_s = cong.prepareStatement(third_query);
			rs_s = pstmt_s.executeQuery();

			while(rs_s.next()) 	
			{
				 total_purqty = rs_s.getDouble("TotalReturnQuantity");
			}
		     	 add_totret = total_qty + total_purqty;
				 sub_totret = Quantity -add_totret;
			 pstmt_s.close();
errLine="213";	
			 if(str.mathformat(Return_Quantity,2)!= str.mathformat(total_purqty,2))
			 {
errLine="215";
%>

			<tr>	
				<td width="15%" align=right><%=ReceiveTransaction_Id%></td>
				<td width="25%" align=right><%=str.mathformat(Quantity,2)%></td>
				<td width="25%" align=right><%=str.mathformat(Available_Quantity,2)
				%></td>
				<td width="25%" align=right><%=str.mathformat(Return_Quantity,2)
				%></td>		
				<td width="25%" align=right><%=str.mathformat(total_qty,2)%></td>
				<td width="25%" align=right><%=str.mathformat(total_purqty,2)%></td>
			</tr>
			
				<input type=hidden name=ReceiveTransaction_Id2<%=q%> value=<%=ReceiveTransaction_Id%>>
				<input type=hidden name=total_purqty2<%=q%> value=<%=total_purqty%>>
				<input type=hidden name=ReturnQuantity2<%=q%> value=<%=Return_Quantity%>>

<%				q++;
			}// if for table 2
		}//while rs_q next()
%>
	<input type=hidden name=qsize value=<%=q%>>
<%
	pstmt_q.close(); 
%>
</table>
<BR><BR><BR>
<center>
<%if( p!=0 || q!=0)
	{
%>
<Input type=submit value=update name=command></center>
<%}
else
{
}
%>
</form>
<%
}//if null command
%>


<!-- **************  for UPDATE query **************--->
<%
if("update".equals(command))
{
errLine="254";
	int psize1 =Integer.parseInt(request.getParameter("psize"));
	
	int qsize1 =Integer.parseInt(request.getParameter("qsize"));
	
errLine="261";
	String ReceiveTransactionId1="";
	double update_quantity=0;
	double update_subtotret=0;
	double update_addtotret=0;
	double update_AvailableQuantity=0;
	double update_ReturnQuantity=0;

	String ReceiveTransactionId2="";
	double update_totalpurqty2=0;
	double update_ReturnQuantity2=0;
	double update_subtotret2=0;

for(int s=0;s<psize1;s++)
{
	ReceiveTransactionId1 =request.getParameter("ReceiveTransaction_Id1"+s);

	update_quantity =Double.parseDouble(request.getParameter("Quantity1"+s));

	update_addtotret =Double.parseDouble(request.getParameter("add_totret1"+s));

	update_subtotret =Double.parseDouble(request.getParameter("sub_totret1"+s));
	
	update_AvailableQuantity =Double.parseDouble(request.getParameter("Available_Quantity1"+s));
	if(str.mathformat(update_quantity-update_addtotret,2)!= str.mathformat(update_AvailableQuantity,2))
	{
		String updatequery1="UPDATE Receive_Transaction SET Available_Quantity="+update_subtotret+" where 		ReceiveTransaction_Id ="+ReceiveTransactionId1; 
	
	    pstmt_s = cong.prepareStatement(updatequery1);
    	int a = pstmt_s.executeUpdate();
	    pstmt_s.close();
	}//if block end
}//first for loop end

for(int t=0;t<qsize1;t++)
{
	ReceiveTransactionId2 =request.getParameter("ReceiveTransaction_Id2"+t);
	
	update_totalpurqty2 =Double.parseDouble(request.getParameter("total_purqty2"+t));

	update_ReturnQuantity2=Double.parseDouble(request.getParameter("ReturnQuantity2"+t));
	

	 if(str.mathformat(update_ReturnQuantity2,2)!= str.mathformat(update_totalpurqty2,2))
	 {
		String updatequery2="UPDATE Receive_Transaction SET Return_Quantity="+update_totalpurqty2+" where 		ReceiveTransaction_Id ="+ReceiveTransactionId2; 

	    pstmt_s = cong.prepareStatement(updatequery2);
    	int b = pstmt_s.executeUpdate();
	    pstmt_s.close();
	 }//if block end*/
}//for loop end
%>
	<center><BR><BR><BR>
	<H1>Data is Successfully Updated !!!</H1>
	</center>
<%
	}//if update block end
C.returnConnection(cong);
	C.returnConnection(conp);
}//try block

catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.print("<br>87 The error in file Noname1.jsp ="+e+"and err on ="+errLine);
}
%>