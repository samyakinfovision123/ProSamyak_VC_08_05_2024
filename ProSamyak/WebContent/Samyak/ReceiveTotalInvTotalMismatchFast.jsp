<!-- 
System run to correct Receive_Total and InvTotal mismatch in the invoices.

type the url in the browser 
http://localhost:8080/Nippon/Samyak/ReceiveTotalInvTotalMismatchFast.jsp?command=Samyak06
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
String errLine="17";
Connection cong = null;
Connection conp = null;
String remote_host=null;
int d = 0;
int usDlr = 2;

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
	errLine="35";
	

	
	
	out.print("<br>System Run Started...");

	String query="";

	//store the RT local and dollar totals grouped by receive_id 
	HashMap RTLocalAmt = new HashMap();
	HashMap RTDollarAmt = new HashMap();
	String RTQuery = "Select RT.Receive_Id, SUM(RT.Quantity*RT.Local_Price) as RTLocalTotal, SUM(RT.Quantity*RT.Dollar_Price) as RTDollarTotal from Receive_Transaction RT, Receive R where RT.Active=1 and R.Receive_Date >= '2006-04-01' and R.Receive_Id=RT.Receive_Id and R.Active=1 group by RT.Receive_Id";
	pstmt_p = conp.prepareStatement(RTQuery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next()) 
	{
		String rId = rs_p.getString("Receive_Id");
		Double RTLocalTotal = new Double(rs_p.getDouble("RTLocalTotal"));
		Double RTDollarTotal = new Double(rs_p.getDouble("RTDollarTotal"));

		RTLocalAmt.put(rId, RTLocalTotal);
		RTDollarAmt.put(rId, RTDollarTotal);
	}
	pstmt_p.close();
	errLine="58";
	
	//store the RT local and dollar totals grouped by receive_id and transaction type wise. Type0 appended to variable indicates Transaction_Type=0, similarly for 1.
	HashMap FTLocalAmtType0 = new HashMap();
	HashMap FTDollarAmtType0 = new HashMap();
	HashMap FTLocalAmtType1 = new HashMap();
	HashMap FTDollarAmtType1 = new HashMap();
	String FTQuery = "Select Receive_Id, Sum(Local_Amount) as LocalAmt, Sum(Dollar_Amount) as DollarAmt from Financial_Transaction where Transaction_Type = 0 and Active=1 and Transaction_Date >= '2006-04-01' group by Receive_Id";
	pstmt_p = conp.prepareStatement(FTQuery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next()) 
	{
		String rId = rs_p.getString("Receive_Id");
		Double Local_Amount = new Double(rs_p.getDouble("LocalAmt"));
		Double Dollar_Amount = new Double(rs_p.getDouble("DollarAmt"));

		FTLocalAmtType0.put(rId, Local_Amount);
		FTDollarAmtType0.put(rId, Dollar_Amount);
	}
	pstmt_p.close();
	errLine="78";


//	FTQuery = "Select Receive_Id, Sum(Local_Amount) as LocalAmt, Sum(Dollar_Amount), Sum(Dollar_Amount) as DollarAmt from Financial_Transaction where Transaction_Type = 1 and Active=1 group by Receive_Id";
FTQuery = "Select Receive_Id, Sum(Local_Amount) as LocalAmt, Sum(Dollar_Amount), Sum(Dollar_Amount) as DollarAmt from Financial_Transaction where Transaction_Type = 1 and Transaction_Date >= '2006-04-01' and Active=1 group by Receive_Id";
	pstmt_p = conp.prepareStatement(FTQuery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next()) 
	{
		String rId = rs_p.getString("Receive_Id");
		Double Local_Amount = new Double(rs_p.getDouble("LocalAmt"));
		Double Dollar_Amount = new Double(rs_p.getDouble("DollarAmt"));

		FTLocalAmtType1.put(rId, Local_Amount);
		FTDollarAmtType1.put(rId, Dollar_Amount);
	}
	pstmt_p.close();
	errLine="94";

	//get the various receipts/payments against the punched sales/purchases
	HashMap pdInv = new HashMap();
	//String PDQuery = "Select Payment_No, Transaction_Date, For_HeadId from Payment_Details where Active=1 and For_HeadId <> 0 order by  For_HeadId";
	String PDQuery = "Select Payment_No, Transaction_Date, For_HeadId from Payment_Details where Active=1 and Transaction_Date >= '2006-04-01' and For_HeadId <> 0 order by  For_HeadId";		
	pstmt_p = conp.prepareStatement(PDQuery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next()) 
	{
		String thisclearedInv = "  " +rs_p.getString("Payment_No") + " : " +format.format(rs_p.getDate("Transaction_Date"));

		String id = rs_p.getString("For_HeadId");

		if(pdInv.containsKey(id))
		{
			thisclearedInv = pdInv.get(id) + thisclearedInv;
		}
		pdInv.put(id, thisclearedInv);
	}
	pstmt_p.close();
	errLine = "115";
	
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
	<form action="ReceiveTotalInvTotalMismatchFast.jsp" method=post>
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
		String strReceive_Id = ""+Receive_Id;
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
		
		if(RTLocalAmt.containsKey(strReceive_Id))
		{
			RTLocalTotal = ((Double)(RTLocalAmt.get(strReceive_Id))).doubleValue();
		}
		if(RTDollarAmt.containsKey(strReceive_Id))
		{
			RTDollarTotal = ((Double)(RTDollarAmt.get(strReceive_Id))).doubleValue();
		}
		
		errLine="175";
		
		double FTLocalAmount = 0;
		double FTDollarAmount = 0;
		
		
		if(Receive_Sell)//purchase
		{
			if(FTLocalAmtType1.containsKey(strReceive_Id))
			{
				FTLocalAmount -= ((Double)(FTLocalAmtType1.get(strReceive_Id))).doubleValue();
			}
			if(FTDollarAmtType1.containsKey(strReceive_Id))
			{
				FTDollarAmount -= ((Double)(FTDollarAmtType1.get(strReceive_Id))).doubleValue();
			}

			if(FTLocalAmtType0.containsKey(strReceive_Id))
			{
				FTLocalAmount += ((Double)(FTLocalAmtType0.get(strReceive_Id))).doubleValue();
			}
			if(FTDollarAmtType0.containsKey(strReceive_Id))
			{
				FTDollarAmount += ((Double)(FTDollarAmtType0.get(strReceive_Id))).doubleValue();
			}
						
		}
		else if(!Receive_Sell)//sale
		{
			if(FTLocalAmtType1.containsKey(strReceive_Id))
			{
				FTLocalAmount += ((Double)(FTLocalAmtType1.get(strReceive_Id))).doubleValue();
			}
			if(FTDollarAmtType1.containsKey(strReceive_Id))
			{
				FTDollarAmount += ((Double)(FTDollarAmtType1.get(strReceive_Id))).doubleValue();
			}

			if(FTLocalAmtType0.containsKey(strReceive_Id))
			{
				FTLocalAmount -= ((Double)(FTLocalAmtType0.get(strReceive_Id))).doubleValue();
			}
			if(FTDollarAmtType0.containsKey(strReceive_Id))
			{
				FTDollarAmount -= ((Double)(FTDollarAmtType0.get(strReceive_Id))).doubleValue();
			}
		}

		errLine="223";

		String clearedInv = " ";
		boolean ProActive = false; //used to indicate if any PD entries are punched or not
		
		if(pdInv.containsKey(strReceive_Id))  
		{
			clearedInv = (String)pdInv.get(strReceive_Id);
			ProActive=true;
		}

		errLine="234";

		double ActualInvLocalTotal = RTLocalTotal;
		double ActualInvDollarTotal = RTDollarTotal;
		double ActualLocal_Total = RTLocalTotal + FTLocalAmount;
		double ActualDollar_Total = RTDollarTotal + FTDollarAmount;
		
		if( 
			(   (Receive_CurrencyId != 0) &&
				(Math.abs(str.mathformat(ActualLocal_Total, d) - str.mathformat(Local_Total, d)) > 1 )
			) 
			|| 
			( 
			    (Receive_CurrencyId == 0) && (Math.abs(str.mathformat(ActualDollar_Total, usDlr) - str.mathformat(Dollar_Total, usDlr)) > 1 )
			)
			|| 
			(   (Receive_CurrencyId != 0) &&
				(Math.abs(str.mathformat(ActualInvLocalTotal, d) - str.mathformat(InvLocalTotal, d)) > 1 )
			) 
			|| 
			(   (Receive_CurrencyId != 0) &&
				(Math.abs(str.mathformat(ActualInvDollarTotal, d) - str.mathformat(InvDOllarTotal, d)) > 1 )
			) 
			
		  )
		{
		%>
		<tr>
			<td><%=(rowCount+1)%></td>	
			<td><%=Receive_Id%></td>	
			<td><%=Receive_No%></td>	
			<td><%=A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Name", " Where companyparty_id="+company_id)%></td>	
			<td align=right><%=str.format1(""+Local_Total, d)%></td>	
			<td align=right><%=str.format1(""+Dollar_Total, usDlr)%></td>	
			<td align=right><%=str.format1(""+InvLocalTotal, d)%></td>	
			<td align=right><%=str.format1(""+InvDOllarTotal, usDlr)%></td>	

			<td align=right><%=str.format1(""+ActualLocal_Total, d)%></td>	
			<td align=right><%=str.format1(""+ActualDollar_Total, usDlr)%></td>	
			<td align=right><%=str.format1(""+ActualInvLocalTotal, d)%></td>	
			<td align=right><%=str.format1(""+ActualInvDollarTotal, usDlr)%></td>	
			<!-- <td><%//=ProActive%></td>	 -->
			<td><%=clearedInv%></td>	

			<input type="hidden" name="Receive_Id" value="<%=Receive_Id%>">
			<input type="hidden" name="Receive_No" value="<%=Receive_No%>">
			<input type="hidden" name="company_id" value="<%=company_id%>">
			<input type="hidden" name="ActualLocal_Total" value="<%=str.mathformat(ActualLocal_Total ,d)%>">
			<input type="hidden" name="ActualDollar_Total" value="<%=str.mathformat(ActualDollar_Total ,usDlr)%>">
			<input type="hidden" name="ActualInvLocalTotal" value="<%=str.mathformat(ActualInvLocalTotal ,d)%>">
			<input type="hidden" name="ActualInvDollarTotal" value="<%=str.mathformat(ActualInvDollarTotal , usDlr)%>">
			<input type="hidden" name="ProActive" value="<%=ProActive%>">
			<input type="hidden" name="clearedInv" value="<%=clearedInv%>">
			<input type="hidden" name="Receive_CurrencyId" value="<%=Receive_CurrencyId%>">
		</tr>


		<%
			rowCount++;
		}
	}//end of while
	pstmt_g.close();
	errLine="287";

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
	errLine="313";
	
	remote_host=request.getRemoteHost();
	out.print("<br>System Run Continued...");

	int a417 = 0;

	String rowCountStr = request.getParameter("rowCount");
	int rowCount = Integer.parseInt(rowCountStr);
	java.sql.Date D = new
	java.sql.Date(System.currentTimeMillis());
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
				String query="UPDATE Receive SET Receive_Total="+Receive_Total+", Local_Total="+ActualLocal_Total[i]+", Dollar_Total="+ActualDollar_Total[i]+",Modified_MachineName="+"'samyak"+remote_host+" "+format.format(D)+"' ,  InvTotal="+InvTotal+", InvLocalTotal="+ActualInvLocalTotal[i]+", InvDollarTotal="+ActualInvDollarTotal[i]+" where Receive_Id="+Receive_Id[i];

				//out.println("query="+query);
				pstmt_p = conp.prepareStatement(query);
				a417 += pstmt_p.executeUpdate();
				pstmt_p.close();
				errLine="376";
				query="UPDATE Voucher SET Voucher_Total="+Receive_Total+", Local_Total="+ActualLocal_Total[i]+", Dollar_Total="+ActualDollar_Total[i]+",Modified_MachineName="+"'samyak"+remote_host+" "+format.format(D)+"'"+	
				" where Voucher_No='"+Receive_Id[i]+"'";

				pstmt_p = conp.prepareStatement(query);
				a417 += pstmt_p.executeUpdate();
				pstmt_p.close();
				errLine="369";
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
		  