

<!-- 
For Run the System Run:-

 type the url in the browser 
Nippon/Samyak/ExchangeRateRange_SystemRun.jsp?command=Samyak07
-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="I"    class="NipponBean.Inventory" />

<%

	String errLine="13";

	Connection conp = null;
	Connection cong = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_p = null;
	ResultSet rs_g = null;

%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<% 

String command=request.getParameter("command");

try
{
	if(command.equals("Samyak07"))
	{
		try	
		{
			cong=C.getConnection();
			conp=C.getConnection();  
		}
		catch(Exception Samyak31)
		{ 
			 C.returnConnection(cong);
			 C.returnConnection(conp);  
			 out.println("<font color=red> FileName : 	UpdateToByNosSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

		double percent=15d;
		int counter=0;

		String CompanyQuery = "select count(*) as counter from Master_CompanyParty MCP,Master_Currency MC where super=1 and MCP.Active=1 and MC.Active=1 and MCP.CompanyParty_Id=MC.Company_Id ";
	
		errLine="66";

		pstmt_g  = cong.prepareStatement(CompanyQuery);
		errLine="69";
		rs_g = pstmt_g.executeQuery();
		errLine="71";
		while(rs_g.next())
		{
			counter=rs_g.getInt("counter");
		}
		pstmt_g.close();

		String CompanyParty_Id[]=new String[counter];
		String CompanyParty_Name[]=new String[counter];
		String Currency_Id[]=new String[counter];
		String Base_ExchangeRate[]=new String[counter];
		int i=0;

		CompanyQuery = "select MCP.CompanyParty_Id,MCP.CompanyParty_Name,MC.Currency_Id,MC.Base_ExchangeRate from Master_CompanyParty MCP,Master_Currency MC where super=1 and MCP.Active=1 and MC.Active=1 and MCP.CompanyParty_Id=MC.Company_Id ";

		pstmt_g  = cong.prepareStatement(CompanyQuery);
		rs_g = pstmt_g.executeQuery();
		errLine="88";
		while(rs_g.next())
		{
			CompanyParty_Id[i]=rs_g.getString("CompanyParty_Id");
			CompanyParty_Name[i]=rs_g.getString("CompanyParty_Name");
			Currency_Id[i]=rs_g.getString("Currency_Id");
			Base_ExchangeRate[i]=rs_g.getString("Base_ExchangeRate");
			//out.print("<br>85 Base_ExchangeRate["+i+"]="+Base_ExchangeRate[i]);
			i++;
		}
		pstmt_g.close();

		int cnt=0;
		int cnt1=0;
		int cnt2=0;
		int cnt3=0;

%>
		<form action=InvRegister.jsp name=f1 method=post target=_blank>
		<table align=center  border=0 bordercolor=red cellspacing=0 width='90%'>
		<tr >
		<th align=center><font color=#0033FF> ExchangeRate Report Of Voucher</font></th></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>
		<table align=center bordercolor=skyblue border=1 cellspacing=0 width='90%'>
<%
		for(i=0;i<counter;i++)
		{
					/* Record get for Voucher Table */

			String selectVoucherQuery="select count(*) as cnt from Voucher where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectVoucherQuery);
			errLine="69";
			rs_g = pstmt_g.executeQuery();
			errLine="71";
			while(rs_g.next())
			{
				cnt=rs_g.getInt("cnt");
			}
			pstmt_g.close();

			String Voucher_Id[]=new String[cnt];
			String Voucher_Type[]=new String[cnt];
			String Voucher_No[]=new String[cnt];
			java.sql.Date Voucher_Date[]= new java.sql.Date[cnt]; 
			double Local_Total[]=new double[cnt];
			double Dollar_Total[]=new double[cnt];
			int j=0;
			
			selectVoucherQuery="select Voucher_Id,Voucher_Type,Voucher_No,Voucher_Date,Local_Total,Dollar_Total,Exchange_Rate from Voucher where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectVoucherQuery);
			errLine="129";
			rs_g = pstmt_g.executeQuery();
			errLine="131";
			while(rs_g.next())
			{
				Voucher_Id[j]=rs_g.getString("Voucher_Id");
				Voucher_Type[j]=rs_g.getString("Voucher_Type");
				Voucher_No[j]=rs_g.getString("Voucher_No");
				Voucher_Date[j]=rs_g.getDate("Voucher_Date");
				Local_Total[j]=rs_g.getDouble("Local_Total");
				Dollar_Total[j]=rs_g.getDouble("Dollar_Total");
							
				j++;
			}
			pstmt_g.close();

					
					/* Record get for Receive Table */


			String selectReceiveQuery="select count(*) as cnt1 from Receive where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectReceiveQuery);
			errLine="69";
			rs_g = pstmt_g.executeQuery();
			errLine="71";
			while(rs_g.next())
			{
				cnt1=rs_g.getInt("cnt1");
			}
			pstmt_g.close();

			String Receive_Id[]=new String[cnt1];
			String Receive_Quantity[]=new String[cnt1];
			String Receive_No[]=new String[cnt1];
			java.sql.Date Receive_Date[]= new java.sql.Date[cnt1]; 
			double Local_Total1[]=new double[cnt1];
			double Dollar_Total1[]=new double[cnt1];

			String ReceiveTransaction_Id[]=new String[cnt1];
			String Available_Quantity[]=new String[cnt1];
			String Lot_SrNo[]=new String[cnt1];
			java.sql.Date Return_On[]= new java.sql.Date[cnt1]; 
			double Local_Amount1[]=new double[cnt1];
			double Dollar_Amount1[]=new double[cnt1];

			 j=0;
			
			selectReceiveQuery="select Receive_Id,Receive_Quantity,Receive_No,Receive_Date,Local_Total,Dollar_Total from Receive where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectReceiveQuery);
			errLine="129";
			rs_g = pstmt_g.executeQuery();
			errLine="131";
			while(rs_g.next())
			{
				Receive_Id[j]=rs_g.getString("Receive_Id");
				Receive_Quantity[j]=rs_g.getString("Receive_Quantity");
				Receive_No[j]=rs_g.getString("Receive_No");
				Receive_Date[j]=rs_g.getDate("Receive_Date");
				Local_Total1[j]=rs_g.getDouble("Local_Total");
				Dollar_Total1[j]=rs_g.getDouble("Dollar_Total");

				String selectRTQuery="select ReceiveTransaction_Id,Available_Quantity,Lot_SrNo,Return_On,Local_Amount,Dollar_Amount from Receive_Transaction where Receive_Id="+Receive_Id[j]+" and Active=1";

				pstmt_p  = conp.prepareStatement(selectRTQuery);
				rs_p = pstmt_p.executeQuery();
				int t=0;
				while(rs_p.next())
				{
					ReceiveTransaction_Id[j]=rs_p.getString("ReceiveTransaction_Id");
					Available_Quantity[j]=rs_p.getString("Available_Quantity");
					Lot_SrNo[j]=rs_p.getString("Lot_SrNo");
					Return_On[j]=rs_p.getDate("Return_On");
					Local_Amount1[j]=rs_p.getDouble("Local_Amount");
					Dollar_Amount1[j]=rs_p.getDouble("Dollar_Amount");
				}
				pstmt_p.close();
				j++;
			}
			pstmt_g.close();


			/* Record get for Payment_Details Table */


			String selectPDQuery="select count(*) as cnt2 from Payment_Details where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectPDQuery);
			errLine="69";
			rs_g = pstmt_g.executeQuery();
			errLine="71";
			while(rs_g.next())
			{
				cnt2=rs_g.getInt("cnt2");
			}
			pstmt_g.close();

			String Payment_Id[]=new String[cnt2];
			String Transaction_Type[]=new String[cnt2];
			String Payment_No[]=new String[cnt2];
			java.sql.Date Transaction_Date[]= new java.sql.Date[cnt2]; 
			double Local_Amount[]=new double[cnt2];
			double Dollar_Amount[]=new double[cnt2];
			 j=0;
			
			selectPDQuery="select Payment_Id,Transaction_Type,Payment_No,Transaction_Date,Local_Amount,Dollar_Amount from Payment_Details where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectPDQuery);
			errLine="129";
			rs_g = pstmt_g.executeQuery();
			errLine="131";
			while(rs_g.next())
			{
				Payment_Id[j]=rs_g.getString("Payment_Id");
				Transaction_Type[j]=rs_g.getString("Transaction_Type");
				Payment_No[j]=rs_g.getString("Payment_No");
				Transaction_Date[j]=rs_g.getDate("Transaction_Date");
				Local_Amount[j]=rs_g.getDouble("Local_Amount");
				Dollar_Amount[j]=rs_g.getDouble("Dollar_Amount");
							
				j++;
			}
			pstmt_g.close();

			String selectFTQuery="select count(*) as cnt3 from Financial_Transaction where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectFTQuery);
			errLine="69";
			rs_g = pstmt_g.executeQuery();
			errLine="71";
			while(rs_g.next())
			{
				cnt3=rs_g.getInt("cnt3");
			}
			pstmt_g.close();

			String Tranasaction_Id[]=new String[cnt3];
			String Transaction_Type1[]=new String[cnt3];
			String Tranasaction_No1[]=new String[cnt3];
			java.sql.Date Transaction_Date1[]= new java.sql.Date[cnt3]; 
			double Local_Amount2[]=new double[cnt3];
			double Dollar_Amount2[]=new double[cnt3];
			 j=0;
			
			selectFTQuery="select Tranasaction_Id,Transaction_Type,Tranasaction_No,Transaction_Date,Local_Amount,Dollar_Amount from Financial_Transaction where Company_Id="+CompanyParty_Id[i]+" and Active=1";

			pstmt_g  = cong.prepareStatement(selectFTQuery);
			errLine="129";
			rs_g = pstmt_g.executeQuery();
			errLine="131";
			while(rs_g.next())
			{
				Tranasaction_Id[j]=rs_g.getString("Tranasaction_Id");
				Transaction_Type1[j]=rs_g.getString("Transaction_Type");
				Tranasaction_No1[j]=rs_g.getString("Tranasaction_No");
				Transaction_Date1[j]=rs_g.getDate("Transaction_Date");
				Local_Amount2[j]=rs_g.getDouble("Local_Amount");
				Dollar_Amount2[j]=rs_g.getDouble("Dollar_Amount");
						
				j++;
			}
			pstmt_g.close();

			errLine="142";
			double value=(percent*Double.parseDouble(Base_ExchangeRate[i]))/100;
			errLine="145";
			double maxValue=Double.parseDouble(Base_ExchangeRate[i]) + value;
			double minValue=Double.parseDouble(Base_ExchangeRate[i]) - value;
		
			if(cnt!=0)
			{
				int c=0;
				double ExchangeRate_Total=0.0;
				int flag=0;
				for(int k=0;k<cnt;k++)
				{
					ExchangeRate_Total=(Local_Total[k]/Dollar_Total[k]);
					
					if( ExchangeRate_Total > maxValue || ExchangeRate_Total< minValue)
					{
						c++;
						if(flag==0)
						{
%>
			<tr bgcolor=#336699><th colspan=7 align=center ><font color=#FFFFFF><%=CompanyParty_Name[i]%></font></th></tr>
			<tr bgcolor=#CC99CC><th colspan=7 align=center><font color=blue>Voucher</font></tr>
			<tr bgcolor=#CCCCFF>
				<th>Sr No</th>
				<th>Voucher_Id</th>
				<th>Voucher_Type</th>
				<th>Voucher_No</th>
				<th>Voucher_Date</th>
				<th>Local_Total</th>
				<th>Dollar_Total</th>
			</tr>
<%
							flag=1;
						}
%>
			<tr>
				<td><%=c%></td>
				<td><%=Voucher_Id[k]%></td>
				<td><%=Voucher_Type[k]%></td>
				<td><%=Voucher_No[k]%></td>
				<td><%=Voucher_Date[k]%></td>
				<td align=right><%=Local_Total[k]%></td>
				<td align=right><%=Dollar_Total[k]%></td>
			</tr>
		
<%
					}
				}
			}

			if(cnt1!=0)
			{
				int c=0;
				double ExchangeRate_Total=0.0;
				int flag=0;
				for(int k=0;k<cnt1;k++)
				{
					ExchangeRate_Total=(Local_Total1[k]/Dollar_Total1[k]);
										
					if( ExchangeRate_Total > maxValue || ExchangeRate_Total< minValue)
					{
						c++;
						if(flag==0)
						{
%>
			<tr bgcolor=#CC99CC><th colspan=7 align=center><font color=blue>Receive</font></tr>
			<tr bgcolor=#CCCCFF>
				<th>Sr No</th>
				<th>Receive_Id</th>
				<th>Receive_Quantity</th>
				<th>Receive_No</th>
				<th>Receive_Date</th>
				<th>Local_Total</th>
				<th>Dollar_Total</th>
			</tr>
<%
								flag=1;
						}
%>
			<tr>
				<td><%=c%></td>
				<td><%=Receive_Id[k]%></td>
				<td><%=Receive_Quantity[k]%></td>
				<td><%=Receive_No[k]%></td>
				<td><%=Receive_Date[k]%></td>
				<td align=right><%=Local_Total1[k]%></td>
				<td align=right><%=Dollar_Total1[k]%></td>
			</tr>

	<%
					}
				}
			}

			if(cnt1!=0)
			{
				int c=0;
				double ExchangeRate_Total=0.0;
				int flag=0;
				errLine="404";
				for(int k=0;k<cnt1;k++)
				{
					ExchangeRate_Total=(Local_Amount1[k]/Dollar_Amount1[k]);
					
					if( ExchangeRate_Total > maxValue || ExchangeRate_Total< minValue)
					{
						c++;
						if(flag==0)
						{
%>
			
			<tr bgcolor=#CC99CC><th colspan=7 align=center><font color=blue>Receive_Transaction</font></tr>
			<tr bgcolor=#CCCCFF>
				<th>Sr No</th>
				<th>ReceiveTransaction_Id</th>
				<th>Available_Quantity</th>
				<th>Lot_SrNo</th>
				<th>Return_On</th>
				<th>Local_Amount</th>
				<th>Dollar_Amount</th>
			</tr>
<%
								flag=1;
						 }
%>
			<tr>
				<td><%=c%></td>
				<td><%=ReceiveTransaction_Id[k]%></td>
				<td><%=Available_Quantity[k]%></td>
				<td><%=Lot_SrNo[k]%></td>
				<td><%=Return_On[k]%></td>
				<td align=right><%=Local_Amount1[k]%></td>
				<td align=right><%=Dollar_Amount1[k]%></td>
			</tr>
		
<%
					}
				}
			}		

			if(cnt2!=0)
			{
				int c=0;
				double ExchangeRate_Total=0.0;
				int flag=0;
				errLine="404";
				for(int k=0;k<cnt2;k++)
				{
					ExchangeRate_Total=(Local_Amount[k]/Dollar_Amount[k]);
										
					if( ExchangeRate_Total > maxValue || ExchangeRate_Total< minValue)
					{
						c++;
						if(flag==0)
						{
%>
			<tr bgcolor=#CC99CC><th colspan=7 align=center><font color=blue>Payment_Details</font></tr>
			<tr bgcolor=#CCCCFF>
				<th>Sr No</th>
				<th>Payment_Id</th>
				<th>Transaction_Type</th>
				<th>Payment_No</th>
				<th>Transaction_Date</th>
				<th>Local_Amount</th>
				<th>Dollar_Amount</th>
			</tr>
<%
							flag=1;
						 }
%>
			<tr>
				<td><%=c%></td>
				<td><%=Payment_Id[k]%></td>
				<td><%=Transaction_Type[k]%></td>
				<td><%=Payment_No[k]%></td>
				<td><%=Transaction_Date[k]%></td>
				<td align=right><%=Local_Amount[k]%></td>
				<td align=right><%=Dollar_Amount[k]%></td>
			</tr>
		
	<%
					}
				}
			}		

			if(cnt3!=0)
			{
				int c=0;
				double ExchangeRate_Total=0.0;
				int flag=0;
				errLine="404";
				for(int k=0;k<cnt3;k++)
				{
			 
					ExchangeRate_Total=(Local_Amount2[k]/Dollar_Amount2[k]);
						
					if( ExchangeRate_Total > maxValue || ExchangeRate_Total< minValue)
					{
						c++;
						if(flag==0)
						{

%>
			
			<tr bgcolor=#CC99CC><th colspan=7 align=center><font color=blue>Financial_Transaction</font></tr>
			<tr bgcolor=#CCCCFF>
				<th>Sr No</th>
				<th>Tranasaction_Id</th>
				<th>Transaction_Type</th>
				<th>Tranasaction_No</th>
				<th>Transaction_Date</th>
				<th>Local_Amount</th>
				<th>Dollar_Amount</th>
			</tr>
<%
							flag=1;
						}
%>
			<tr>
				<td><%=c%></td>
				<td><%=Tranasaction_Id[k]%></td>
				<td><%=Transaction_Type1[k]%></td>
				<td><%=Tranasaction_No1[k]%></td>
				<td><%=Transaction_Date1[k]%></td>
				<td align=right><%=Local_Amount2[k]%></td>
				<td align=right><%=Dollar_Amount2[k]%></td>
			</tr>
		
<%
						}
					}
				}

			}
%>
		</table>
		</td></tr>
		</table>
<%
	conp.commit(); 
	C.returnConnection(conp);
	C.returnConnection(cong);
	} //if
} //try
catch(Exception e)
{
	conp.rollback();
	
	C.returnConnection(cong);
	C.returnConnection(conp);  
	out.print("<br>87 The error in file UpdateToByNosSystemRun.jsp"+e);

}
%>
</form>
</body >
</html>