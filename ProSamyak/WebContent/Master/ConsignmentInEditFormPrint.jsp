

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />

<html>
<head>
<title>Samyak Software -India</title>
<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT">

<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<% 
String ErrLine="0";
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try{
	try	
	{
		cong=C.getConnection();
	}
	catch(Exception Samyak60)
	{ 
		out.println("<br><font color=red> FileName : InvSell_New.jsp<br>Bug No Samyak60 : "+ Samyak60);
	}

	String user_name = ""+session.getValue("user_name");
	int user_level = Integer.parseInt(""+session.getValue("user_level"));
	String company_id= ""+session.getValue("company_id");
	//out.print("<br> 52 company_id"+company_id);
	String yearend_id= ""+session.getValue("yearend_id");
	String local_currencysymbol= I.getLocalSymbol(cong,company_id);
	String local_currency= I.getLocalCurrency(cong,company_id);
	int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
	//out.print("<br> Welcome new Edit Purchase........");

	String command=request.getParameter("command");
	
	if(command.equals("pedit"))
	{
	ErrLine="56";
		String receive_id=request.getParameter("receive_id");
		//out.print("<br> receive_id"+receive_id);
		
		int pdcount=0;
		
		//out.print("<br> ref_no"+ref_no);
		
		java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date stockdate = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date receive_date = new java.sql.Date(System.currentTimeMillis());
		double exchange_rate=0,ctax=0,discount=0,total=0,org_receivetotal=0,subtotal=0,Difference_Amount=0,Inv_Total=0,Inv_LocalTotal=0,Receive_quantity=0;
		int counter=0,currency_id=0;
		String Broker_Id="";
		double squantity=0,InvTotalAmount=0,totalamount=0,totalLocalamount=0,InvTotalLocalAmount=0;
		String receive_no="",companyparty_id="",receive_companyid="",receive_byname="",receive_fromname="",duedays="",salesperson_id="",narr="",ref_no="",purchasesalegroup_id="",category_id="";
		String status="unCheck";
		String query="Select * from Receive where Receive_Id=?";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id); 
		ErrLine="76";
		rs_g = pstmt_g.executeQuery();	

		while(rs_g.next())
		{
			receive_no=rs_g.getString("Receive_No");
			receive_date=rs_g.getDate("Receive_Date");
			counter=rs_g.getInt("Receive_Lots");
			//out.print("<br> 87 counter"+counter);
			Receive_quantity=rs_g.getDouble("Receive_Quantity");
			//out.print("<br> 87 Receive_quantity"+Receive_quantity);
			currency_id=rs_g.getInt("Receive_CurrencyId");
				if(0 == currency_id){d=2;}
			exchange_rate=rs_g.getDouble("Exchange_rate");
			ctax=rs_g.getDouble("Tax");
			discount=rs_g.getDouble("discount");
			total= str.mathformat(rs_g.getDouble("Receive_Total"),d);
			org_receivetotal=total;
			
			totalamount=rs_g.getDouble("Dollar_total");
			totalLocalamount=rs_g.getDouble("Local_total");

			companyparty_id=rs_g.getString("Receive_FromId");
			
			receive_fromname=rs_g.getString("Receive_FromName");

			receive_companyid=rs_g.getString("Company_Id");
			receive_byname=rs_g.getString("Receive_ByName");
			due_date=rs_g.getDate("Due_Date");
			stockdate=rs_g.getDate("Stock_Date");
			duedays=rs_g.getString("Due_Days");
			salesperson_id=rs_g.getString("SalesPerson_Id");
			Difference_Amount=rs_g.getDouble("Difference_Amount");
			Inv_Total=rs_g.getDouble("InvDollartotal");
			Inv_LocalTotal=rs_g.getDouble("InvLocaltotal");	purchasesalegroup_id=rs_g.getString("PurchaseSaleGroup_Id");
			category_id=rs_g.getString("Receive_Category");
			ref_no=rs_g.getString("cgtref_No");
			//out.print("<br> purchasesalegroup_id"+purchasesalegroup_id);
			Broker_Id = rs_g.getString("Broker_Id");
		}//..while end
		pstmt_g.close();
		InvTotalAmount = Inv_Total;
		InvTotalLocalAmount = Inv_LocalTotal;
		squantity = Receive_quantity;
		//if(counter == 0)
		//{
			//counter=1;
		//}
		if("null".equals(salesperson_id))
		{
			salesperson_id=""+0;
		}
		double originalQuantity[]=new double[counter];
		double returnQuantity[]=new double[counter];
		double ghat[]=new double[counter];
		double quantity[]=new double[counter];
		double rate[]=new double[counter];
		//new..
		double Local_Price[] = new double[counter];
		double LocalEffective_Price[] = new double[counter];
		double Dollar_Price[] = new double[counter];
		double DollarEffective_Price[] = new double[counter];
		//end..
		double amount[]=new double[counter];
		//double Localamount[]=new double[counter];
		double rejection[]=new double[counter];
		double rejectionQty[]=new double[counter];
		double Localamount[]=new double[counter];
		String lotDiscount[]=new String[counter];
		double ctax_amt=0,temp_amt=0,discount_amt=0;
		String remarks[]=new String[counter]; 
		String receivetransaction_id[]=new String[counter]; 
		String lot_id[]=new String[counter]; 
		String location_id[]=new String[counter]; 
		String lot_no[]=new String[counter]; 
		String pcs[]=new String[counter];
		double calcqty[]=new double[counter]; 
		query="Select * from Receive_Transaction where Receive_Id=? and Active=1";
		pstmt_p = cong.prepareStatement(query);
		pstmt_p.setString(1,receive_id); 
		//out.print("<br> 150 receive_id"+receive_id);
		ErrLine="150";
		rs_p = pstmt_p.executeQuery();	
		//out.print("<br> 152 query"+query);
		int n=0;
		while(rs_p.next())
		{
			receivetransaction_id[n]=rs_p.getString("ReceiveTransaction_id");
			lot_id[n]=rs_p.getString("Lot_Id");
			//out.print("<br> 141  receivetransaction_id"+receivetransaction_id[n]);
			
			originalQuantity[n]=rs_p.getDouble("Original_Quantity");
			quantity[n]= rs_p.getDouble("Quantity");
			ErrLine="163";
			Local_Price[n] = rs_p.getDouble("Local_Price");
			LocalEffective_Price[n] = rs_p.getDouble("LocalEffective_Price");
			Dollar_Price[n] = rs_p.getDouble("Dollar_Price");
			
			DollarEffective_Price[n] = rs_p.getDouble("DollarEffective_Price");
			pcs[n]=rs_p.getString("Pieces");
			rejection[n]=rs_p.getDouble("Rejection_Percent");
			rejectionQty[n]=rs_p.getDouble("Rejection_Quantity");
			lotDiscount[n]=rs_p.getString("Lot_Discount");
			remarks[n]=rs_p.getString("Remarks");
			//out.print("<br> remarks"+remarks[n]);
			returnQuantity[n]= rs_p.getDouble("Return_Quantity");

			location_id[n]=rs_p.getString("Location_Id");

			amount[n]= str.mathformat((quantity[n] * Dollar_Price[n]),d) ;
			Localamount[n]=str.mathformat((quantity[n] * Local_Price[n]),d);
			subtotal += amount[n]; 
			calcqty[n]=originalQuantity[n]-returnQuantity[n];
			ghat[n]=calcqty[n]-quantity[n];
			//rate[n]=str.mathformat(rate[n],3);
			n++;

		}//while()....
		pstmt_p.close();

		discount_amt = subtotal * (discount/100);
		temp_amt = subtotal - discount_amt;
		ctax_amt = temp_amt * (ctax/100);
		total= temp_amt + ctax_amt;
		String company_name="";
		String companyparty_name="";
		for (int i=0;i<counter;i++)
		{
			lot_no[i]=A.getName(cong,"Lot", "Lot_No", lot_id[i]);
		}//for

		String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+receive_companyid;
		pstmt_p = cong.prepareStatement(company_query);
		rs_g=pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
			company_name= rs_g.getString("CompanyParty_Name");
		}
		pstmt_p.close();
		String company_queryy="select * from Master_CompanyParty where active=1 and companyparty_id="+companyparty_id;
		pstmt_p = cong.prepareStatement(company_queryy);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
			//out.println("Inside While 50");
			companyparty_name= rs_g.getString("CompanyParty_Name");	
		}
		pstmt_p.close();
		
		String disloc="",disdol="",local_currencysymbol_Show="";
		String currencyCondition="";

		if(0 == currency_id)
		{
			currencyCondition="Dollar_Amount";
			disdol="checked";
			local_currencysymbol_Show="$";
		}
		else
		{
			currencyCondition="Local_Amount";
			local_currencysymbol_Show=local_currencysymbol;
			disloc="checked";
		}
		int lcounter=0;
		String QueryLedger_Count="select count(*) as counter from Financial_Transaction where For_HeadId !=13 and Receive_Id="+receive_id;
		pstmt_p = cong.prepareStatement(QueryLedger_Count);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
			lcounter=rs_g.getInt("counter");
		}
		pstmt_p.close();
		String Ledger_Id[]=new String[lcounter];
		double Lamount[]=new double[lcounter];
		double LocalLamount[]=new double[lcounter];
		int Transaction_Type[]=new int[lcounter];
		int Transaction_Id[]=new int[lcounter];
		double ledgerPercentage[]=new double[lcounter]; 
		QueryLedger_Count="select Tranasaction_id,Transaction_Type,Ledger_Id,Dollar_Amount,Local_Amount,Cheque_No from Financial_Transaction where For_HeadId !=13 and Receive_Id="+receive_id;
		pstmt_p = cong.prepareStatement(QueryLedger_Count);
		rs_g = pstmt_p.executeQuery();
		int i=0;
		while(rs_g.next()) 	
		{
			Transaction_Id[i]=rs_g.getInt("Tranasaction_id");
			Transaction_Type[i]=rs_g.getInt("Transaction_Type");
			//out.print("<br> 234 Transaction_Type"+Transaction_Type[i]);
			Ledger_Id[i]=rs_g.getString("Ledger_Id");
			//out.print("<br> 234 Ledger_Id"+Ledger_Id[i]);
			Lamount[i]=rs_g.getDouble("Dollar_Amount");
			
			LocalLamount[i]=rs_g.getDouble("Local_Amount");
			
			ledgerPercentage[i]=rs_g.getDouble("Cheque_No");
			//out.print("<br> Lamount"+Lamount[i]);
			i++;
		}
		pstmt_p.close();
		//load the lot details
	String Lot_No[] = new String[counter];
	int Desciption_Id[] = new int[counter];
	String Desciption_Name[] = new String[counter];
	int Size_Id[] = new int[counter];
	String Size_Name[] = new String[counter];

	for ( i=0;i<counter;i++)
	{
		String lotQuery = "SELECT Lot_No, D_Size, Description_Id FROM Lot L, Diamond D WHERE L.Lot_Id=D.Lot_Id AND D.Lot_Id="+lot_id[i]+" AND L.Active=1";
	
		pstmt_g = cong.prepareStatement(lotQuery);
		rs_g = pstmt_g.executeQuery();
	
		while(rs_g.next())
		{
			Lot_No[i] = rs_g.getString("Lot_No");
			Size_Id[i] = rs_g.getInt("D_Size");
			Desciption_Id[i] = rs_g.getInt("Description_Id");
		}
		pstmt_g.close();

		Desciption_Name[i] = A.getNameCondition(cong, "Master_Description", "Description_Name", " WHERE Active=1 and Description_Id="+Desciption_Id[i]);

		Size_Name[i] = A.getNameCondition(cong, "Master_Size", "Size_Name", " WHERE Active=1 and Size_Id="+Size_Id[i]);
	}
		

		%>
		<html>
		<head><title>Samyak Software</title>
		</head>
		<body background="../Buttons/BGCOLOR.JPG" >
		<form name=mainform action="NewEditpurchaseAddNext.jsp" method="post" onsubmit="return onSubmitValidateForm()">
			

			<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
				<tr>
					<th colspan=8 align=center>Edit Purchase </th>
				</tr>	
			</table>
			<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
			<%
				ErrLine="258";
			%>
			<td >No :
				<%=receive_no%>
			</td>
			<td >Ref No :
				<%=ref_no%>
			</td>
			<td >Currency :
			<%	if(0 == currency_id)
				{%>
					Local
			<%	}
				else
				{%>
					Dollar
			<%	}
			%>
			</td>
				<td >To :
				<%=companyparty_name%>
				</td>
			<td >Purchase Group:</td>
			<td>	<%=A.getNameCondition(cong,"Master_PurchaseSaleGroup","purchasesalegroup_name","where Active=1 and purchasesalegroup_id="+purchasesalegroup_id+" and  PurchaseSaleGroup_Type=1 and company_id="+company_id)%>
			</td>
			</tr>
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		<td colspan=1 width="15%">
		Invoice Date
		</td>
		<td  width="15%">
			<%=format.format(receive_date)%></td>	
		<td colspan=1  width="14%">Due Days</td>
		<td><%=duedays%></td>
		<td colspan=1  width="15%">
			Due Date
		</td>
		<td  width="15%">
			<%=format.format(due_date)%></td>

		</tr>
		<tr>
			
			<td >Location </td>
			<td > 							
			<%if(counter != 0)
			{%>	<%=A.getNameCondition(cong,"Master_Location","Location_Name","where location_id="+location_id[0]+"   and company_id="+company_id)%>
			<%}%>
			</td>
			<td >Category</td>
			<td>
				<%=A.getNameCondition(cong,"Master_LotCategory","Lotcategory_Name","where Lotcategory_id="+category_id+" and  company_id="+company_id)%>
			</td>
				
		</tr>
			<tr>
			<td >Exchange Rate</td>
			<td><%=str.format(exchange_rate)%></td>
			

			<td >Purchase Person </td>
			<td><%=A.getNameCondition(cong,"Master_SalesPerson","salesperson_name","where PurchaseSale=1 and Active=1 and company_id="+company_id+"") %>
			</td>

			<td >Broker</td>
			<td>	<%=A.getNameCondition(cong,"Master_SalesPerson","salesperson_name","where PurchaseSale=2 and Active=1 and company_id="+company_id+"")%>
			</td>
			
		</tr>	
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2 name=t1>
	<tr>
		<td>Sr No/Delete</td>
		<td>Lot No</td>
		<td>Desc </td>
		<td>Size</td>
		<td>Original Qty</td>
		<td>Return Qty</td>
		<td>Ghat Qty</td>
		<td>Selection Qty</td>
		 <td>Rate ($)</td>
		<td>Rate (Rs)</td>
		<td>Amount $ </td>
		<td>Amount (Rs)</td>
		<td>Lot Discount %</td>
		<td>Remarks</td>
	</tr>

<%for( i=0;i<counter;i++)
{ int t=i; t++;%>
	
	

	<tr name=tr<%=i%>>
		
		<td>&nbsp;&nbsp;<%=t%></td><td><%=lot_no[i]%></td>

		<td><%=Desciption_Name[i]%></td>

		<td align=right><%=Size_Name[i]%></td>

		<td align=right><%=originalQuantity[i]%></td>
		<td align=right><%=returnQuantity[i]%></td>
		<td align=right><%=str.mathformat(""+ghat[i],3)%></td>
		<td align=right><%=quantity[i]%></td>
			
		<td align=right>
		<%=str.format(DollarEffective_Price[i], 3)%>
		
		</td>
		<td align=right>
			<%=str.format(LocalEffective_Price[i], 3)%>
		
		</td>
		<!-- new End -->

		<td align=right><%=str.mathformat(""+amount[i],d)%></td>

		<td align=right><%=str.mathformat(""+Localamount[i],d)%></td>
		<td align=right><%=lotDiscount[i]%>
		
		</td>
		<td align=right><%=remarks[i]%></td> 
	</tr>

	
<%}
	int tempcounter=counter;
	int tempOldLedgercounter=lcounter;%>
		
	<tr>
		<td colspan=7>Inventory Total </td>
		<td align=right><%=squantity%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td align=right><%=str.format2(""+InvTotalAmount,d)%></td>
		<td align=right><%=str.format2(""+InvTotalLocalAmount,d)%></td>
	</tr>
	<%
		for(int j=0;j<lcounter;j++)
		{
	%>
		
	<tr>
			
		<td colspan=9 align=right><%=A.getNameCondition(cong,"Ledger","Ledger_Name","where ledger_id="+Ledger_Id[j]+" and company_id="+company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id)%></td>
		<td align=right><%=ledgerPercentage[j]%>%</td>
		<td align=right>
			<%=Lamount[j]%>
		</td>
		<td align=right>
			<%=LocalLamount[j]%>
		</td>
		<td>
			
			<%
				String Dr="",Cr="";
				if(Transaction_Type[j] == 1)
				{%>
					Cr
				<%}else{%>
					Dr
					
				<%	}%>
				
			
		</td>
		
	</tr>
	<%}%>


	</script>
	<tr>
		<td colspan=10>Total </td>
		<td align=right><%=str.format2(""+totalamount,d)%></td>
		<td align=right><%=str.format2(""+totalLocalamount,d)%></td>
	</tr>
	<tr>
		<td colspan=14> Narration <%//=narrationTop%>
	</tr>
	</table><br><br>

		</center>
		</form>
		</body>
		
	<%//end..sedit
	C.returnConnection(conp);
	C.returnConnection(cong);
	}
}//try...
catch(Exception e)
{
	C.returnConnection(conp);
	C.returnConnection(cong);

	out.print("<br> Error Is occure at line No:"+ErrLine+" and Error -"+e);
}
%>