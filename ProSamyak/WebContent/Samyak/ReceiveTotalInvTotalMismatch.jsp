<!-- 
System run to correct Receive_Total and InvTotal mismatch in the invoices.

type the url in the browser 
http://localhost:8080/Nippon/Samyak/ReceiveTotalInvTotalMismatch.jsp?command=Samyak06
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
String errLine="17";
Connection cong = null;
Connection conp = null;

try{
String command=request.getParameter("command");
if(command.equals("Samyak06"))
{

	ResultSet rs_g= null;
	ResultSet rs_p= null;
    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	cong=C.getConnection();
	errLine="32";
	

	out.print("<br>System Run Started...");

	String query="Select count(*) as counter from Receive"; 
	pstmt_g = cong.prepareStatement(query);


	rs_g = pstmt_g.executeQuery();	
	int counter=0;

	while(rs_g.next()) 
	{
		counter=rs_g.getInt("counter");
	}

	pstmt_g.close();
	errLine="50";

	
	
	

	
%>
	<Center>
	<table border=1>
	<tr>
		<th>Sr. No.</th>	
		<th>Receive Id</th>	
		<th>Receive No</th>	
		<th>Company</th>			
		<th>R.Local_Total</th>	
		<th>R.Dollar_Total</th>	
		<th>InvLocalTotal</th>	
		<th>InvDollarTotal</th>	

		<th>Calculated R.Local_Total</th>	
		<th>Calculated R.Dollar_Total</th>	
		<th>Calculated InvLocalTotal</th>	
		<th>Calculated InvDollarTotal</th>	
		<!-- <th>ProActive</th>	 -->
		<th>Inv</th>	
	</tr>
	<form action="ReceiveTotalInvTotalMismatch.jsp" method=post>
	<%
	int rowCount=0;
	
	java.sql.Date startDate = new java.sql.Date(106, 03, 01);

	String receiveQuery = "Select * from Receive where Receive_Date >= ? and Active=1 and Purchase=1 and StockTransfer_Type=0";
	pstmt_g = cong.prepareStatement(receiveQuery);
	pstmt_g.setDate(1, startDate);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next()) 
	{
		int Receive_Id = rs_g.getInt("Receive_Id");
		String Receive_No = rs_g.getString("Receive_No");
		boolean Receive_Sell = rs_g.getBoolean("Receive_Sell");
		double Local_Total = rs_g.getDouble("Local_Total");
		double Dollar_Total = rs_g.getDouble("Dollar_Total");
		double InvLocalTotal = rs_g.getDouble("InvLocalTotal");
		double InvDOllarTotal = rs_g.getDouble("InvDOllarTotal");
		
		int Receive_CurrencyId = rs_g.getInt("Receive_CurrencyId");
		String company_id = rs_g.getString("company_id");
		
		
		double RTLocalTotal = 0;
		double RTDollarTotal = 0;
		String RTQuery = "Select SUM(Quantity*Local_Price) as RTLocalTotal, SUM(Quantity*Dollar_Price) as RTDollarTotal from Receive_Transaction where Receive_Id="+Receive_Id+" and Active=1";
		pstmt_p = conp.prepareStatement(RTQuery);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next()) 
		{
			RTLocalTotal = rs_p.getDouble("RTLocalTotal");
			RTDollarTotal = rs_p.getDouble("RTDollarTotal");
		}
		pstmt_p.close();
		
		errLine="110";
		
		double FTLocalAmount = 0;
		double FTDollarAmount = 0;
		String FTQuery = "Select Transaction_Type, Local_Amount, Dollar_Amount from Financial_Transaction where Receive_Id="+Receive_Id+" and Active=1";
		pstmt_p = conp.prepareStatement(FTQuery);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next()) 
		{
			boolean FTTransaction_Type = rs_p.getBoolean("Transaction_Type");
			double Local_Amount = rs_p.getDouble("Local_Amount");
			double Dollar_Amount = rs_p.getDouble("Dollar_Amount");

			if(FTTransaction_Type && Receive_Sell)//purchase
			{
				FTLocalAmount -= Local_Amount;
				FTDollarAmount -= Dollar_Amount;
			}
			else if(!FTTransaction_Type && Receive_Sell)//purchase
			{
				FTLocalAmount += Local_Amount;
				FTDollarAmount += Dollar_Amount;
			}
			else if(!FTTransaction_Type && !Receive_Sell)//sell
			{
				FTLocalAmount -= Local_Amount;
				FTDollarAmount -= Dollar_Amount;
			}
			else if(FTTransaction_Type && !Receive_Sell)//sell
			{
				FTLocalAmount += Local_Amount;
				FTDollarAmount += Dollar_Amount;
			}
		}
		pstmt_p.close();

		errLine="146";

		String clearedInv = " ";
		boolean ProActive = false; //used to indicate if any PD entries are punched or not
		
		String PDQuery = "Select Payment_No, Transaction_Date from Payment_Details where Active=1 and For_HeadId="+Receive_Id+"";
		
		pstmt_p = conp.prepareStatement(PDQuery);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next()) 
		{
			clearedInv += "  " +rs_p.getString("Payment_No") + " : " +format.format(rs_p.getDate("Transaction_Date"));

			ProActive=true;
		}
		pstmt_p.close();

		errLine="163";

		double ActualInvLocalTotal = RTLocalTotal;
		double ActualInvDollarTotal = RTDollarTotal;
		double ActualLocal_Total = RTLocalTotal + FTLocalAmount;
		double ActualDollar_Total = RTDollarTotal + FTDollarAmount;
		
		if( 
			(   (Receive_CurrencyId != 0) &&
				(str.mathformat(ActualLocal_Total, 3) != str.mathformat(Local_Total, 3) )
			) 
			|| 
			( 
			    (Receive_CurrencyId == 0) && (str.mathformat(ActualDollar_Total, 3) != str.mathformat(Dollar_Total, 3) )
			) 
		  )
		{
		%>
		<tr>
			<td><%=(rowCount+1)%></td>	
			<td><%=Receive_Id%></td>	
			<td><%=Receive_No%></td>	
			<td><%=A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Name", " Where companyparty_id="+company_id)%></td>	
			<td><%=str.mathformat(Local_Total, 3)%></td>	
			<td><%=str.mathformat(Dollar_Total, 3)%></td>	
			<td><%=str.mathformat(InvLocalTotal, 3)%></td>	
			<td><%=str.mathformat(InvDOllarTotal, 3)%></td>	

			<td><%=str.mathformat(ActualLocal_Total, 3)%></td>	
			<td><%=str.mathformat(ActualDollar_Total, 3)%></td>	
			<td><%=str.mathformat(ActualInvLocalTotal, 3)%></td>	
			<td><%=str.mathformat(ActualInvDollarTotal, 3)%></td>	
			<!-- <td><%//=ProActive%></td>	 -->
			<td><%=clearedInv%></td>	

			<input type="hidden" name="Receive_Id" value="<%=Receive_Id%>">
			<input type="hidden" name="Receive_No" value="<%=Receive_No%>">
			<input type="hidden" name="company_id" value="<%=company_id%>">
			<input type="hidden" name="ActualLocal_Total" value="<%=str.mathformat(ActualLocal_Total ,3)%>">
			<input type="hidden" name="ActualDollar_Total" value="<%=str.mathformat(ActualDollar_Total ,3)%>">
			<input type="hidden" name="ActualInvLocalTotal" value="<%=str.mathformat(ActualInvLocalTotal ,3)%>">
			<input type="hidden" name="ActualInvDollarTotal" value="<%=str.mathformat(ActualInvDollarTotal ,3)%>">
			<input type="hidden" name="ProActive" value="<%=ProActive%>">
			<input type="hidden" name="clearedInv" value="<%=clearedInv%>">
			<input type="hidden" name="Receive_CurrencyId" value="<%=Receive_CurrencyId%>">
		</tr>


		<%
			rowCount++;
		}
	}//end of while
	pstmt_g.close();
	errLine="211";

	%>
	<input type=hidden name="rowCount" value="<%=rowCount%>" >		
	<tr>
		<td colspan=13 align=center><input type="submit" name=command value="Update"></td>
	</tr>
	</form>
	</table>
	</Center>

<%
	C.returnConnection(cong);
	C.returnConnection(conp);

}//if command equals samyak08


if(command.equals("Update"))
{

	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	cong=C.getConnection();
	errLine="237";
	

	out.print("<br>System Run Continued...");

	int a417 = 0;

	String rowCountStr = request.getParameter("rowCount");
	int rowCount = Integer.parseInt(rowCountStr);

	if(rowCount > 0)
	{
		String Receive_Id[] = request.getParameterValues("Receive_Id");
		String Receive_No[] = request.getParameterValues("Receive_No");
		String company_id[] = request.getParameterValues("company_id");
		
		String ActualLocal_Total[] = request.getParameterValues("ActualLocal_Total") ;
		String ActualDollar_Total[] = request.getParameterValues("ActualDollar_Total") ;
		String ActualInvLocalTotal[] = request.getParameterValues("ActualInvLocalTotal") ;
		String ActualInvDollarTotal[] = request.getParameterValues("ActualInvDollarTotal") ;
		
		String ProActive[] = request.getParameterValues("ProActive");
		String clearedInv[] = request.getParameterValues("clearedInv");
		String Receive_CurrencyId[] = request.getParameterValues("Receive_CurrencyId");



		for(int i=0; i<rowCount; i++)
		{
			String Receive_Total = "";
			String InvTotal = "";

			if("0".equals(Receive_CurrencyId[i]))
			{
				Receive_Total = ActualDollar_Total[i];
				InvTotal = ActualInvDollarTotal[i];
			}
			else
			{
				Receive_Total = ActualLocal_Total[i];
				InvTotal = ActualInvLocalTotal[i];
			}

			//if("false".equals(ProActive[i]))
			//{
				String query="UPDATE Receive SET Receive_Total="+Receive_Total+", Local_Total="+ActualLocal_Total[i]+", Dollar_Total="+ActualDollar_Total[i]+", InvTotal="+InvTotal+", InvLocalTotal="+ActualInvLocalTotal[i]+", InvDollarTotal="+ActualInvDollarTotal[i]+" where Receive_Id="+Receive_Id[i];

				pstmt_p = conp.prepareStatement(query);
				a417 += pstmt_p.executeUpdate();
				pstmt_p.close();

				query="UPDATE Voucher SET Voucher_Total="+Receive_Total+", Local_Total="+ActualLocal_Total[i]+", Dollar_Total="+ActualDollar_Total[i]+" where Voucher_No='"+Receive_Id[i]+"'";

				pstmt_p = conp.prepareStatement(query);
				a417 += pstmt_p.executeUpdate();
				pstmt_p.close();
				errLine="282";
			//}//end 
		}
	
		out.print("<br>Total Rows updated :"+(a417/2));
		out.print("<br>For Following Rows also update the corresponding Payments/Receipts"+(a417/2));
		%>
		<Center>
		<table border=1>
		<tr>
			<th>Receive Id</th>	
			<th>Receive No</th>	
			<th>Company</th>	
			<th>Inv</th>	
		</tr>

		<%
		for(int i=0; i<rowCount; i++)
		{
			if("true".equals(ProActive[i]))
			{
		%>
			<tr>
				<td><%=Receive_Id[i]%></td>	
				<td><%=Receive_No[i]%></td>	
				<td><%=A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Name", " Where companyparty_id="+company_id[i])%></td>	
				<td><%=clearedInv[i]%></td>				
			</tr>

		<%
			}
		}
	
		%></table></center><%
	}//end of if rowCount>0

	C.returnConnection(cong);
	C.returnConnection(conp);


	
	out.print("<br>System Run Completed .");


}//if command equals update

}
catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.println("Exception at Line "+errLine+" bug is :"+e);
}//eo catch
%>
		  