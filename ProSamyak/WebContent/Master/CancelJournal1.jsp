<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
ResultSet rs= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
try	{
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CancelJournal1.jsp<br>Bug No Samyak31 : "+ e31);}

	String line="23";
	String query="";
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String command=request.getParameter("command");
out.print("<br>34 Command "+command);
if("Update".equals(command))
{
try{ 
	conp.setAutoCommit(false);

String type= ""+request.getParameter("voucher_type");


int counter= Integer.parseInt(request.getParameter("counter"));

out.print("<br>44 counter "+counter);

line="43";
String voucher_id[]= new String[counter];
boolean cancel[]= new boolean[counter];
boolean oldactive[]= new boolean[counter];

for(int i=0; i<counter; i++)
{
voucher_id[i]=""+request.getParameter("voucher_id"+i);
String temp=""+request.getParameter("cancel"+i);
cancel[i]=true;
if("yes".equals(temp))
	{cancel[i]=false;}
}
line="56";
for(int i=0; i<counter; i++)
{

query="Update Voucher set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a67 = pstmt_p.executeUpdate();
pstmt_p.close();


// update pn table

if("7".equals(type))
	{
query="Update PN  set Active=?  where RefVoucher_Id=?";

//out.println("<BR>80" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a6p = pstmt_p.executeUpdate();
pstmt_p.close();

	}

//end of update of PN




query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a77 = pstmt_p.executeUpdate();
pstmt_p.close();


query="Update Payment_Details set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a99 = pstmt_p.executeUpdate();
pstmt_p.close();


}//for

line="94";
if("7".equals(type))//cancel the journal voucher
{
for(int i=0; i<counter; i++)
{
if(!cancel[i])
	{
		
		//Revert changes in the PN total in MCP if any PN Ledger is affected
		
		query="Select * from PN where RefVoucher_id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		String companyparty_id="";
		String pn_localamt="";
		String pn_dollaramt="";

		int n=0;
		while(rs_g.next())
		{	
			companyparty_id = rs_g.getString("To_FromId");
			pn_localamt = rs_g.getString("PN_LocalAmount");
			pn_dollaramt = rs_g.getString("PN_DollarAmount");
			n++;
		}
		pstmt_p.close();
		//change PN total from PN_AdvanceLocal and PN_AdvanceDollar 
		if(n>0)
		{
			double PN_advLocal = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","PN_AdvanceLocal","where CompanyParty_Id="+companyparty_id));
			
			PN_advLocal = PN_advLocal - Double.parseDouble(pn_localamt);
			
			
			double PN_advDollar = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","PN_AdvanceDollar","where CompanyParty_Id="+companyparty_id));
			
			PN_advDollar = PN_advDollar - Double.parseDouble(pn_dollaramt);

			query="Update Master_CompanyParty set PN_AdvanceLocal=?, PN_AdvanceDollar=? where CompanyParty_Id=?";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setDouble(1,PN_advLocal);
			pstmt_p.setDouble(2,PN_advDollar);
			pstmt_p.setString(3,companyparty_id);
			int a135 = pstmt_p.executeUpdate();
			pstmt_p.close();
		}
		
		line="143";
		//Revert changes in the Sales total in MCP if any Sales Ledger is affected

		query="Select FT.Transaction_Type,FT.Local_Amount, FT.Dollar_Amount,   L.For_HeadId from Financial_Transaction as FT, Ledger as L where FT.Ledger_Id=L.Ledger_Id and L.For_Head=14 and L.Ledger_Type=1 and FT.Voucher_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		int ftcount=0;
		while(rs_g.next())
		{	
			ftcount++;
		}
		pstmt_p.close();


		String sMCP_Id[] = new String[ftcount];
		String sTransaction_Type[] = new String[ftcount];
		String sLocal_Amount[] = new String[ftcount];
		String sDollar_Amount[] = new String[ftcount];

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		int c=0;
		while(rs_g.next())
		{	
			
			//For sale account 1=credit and 0-debit
			sTransaction_Type[c] = rs_g.getString("Transaction_Type");

			sLocal_Amount[c] = rs_g.getString("Local_Amount");
			sDollar_Amount[c] = rs_g.getString("Dollar_Amount");
			sMCP_Id[c] = rs_g.getString("For_HeadId");
			
			c++;
		
		}
		pstmt_p.close();


		line="181";

		//change Sales total from Sales_AdvanceLocal and Sales_AdvanceDollar 
		for(int j=0; j<ftcount; j++)
		{
			double Sales_advLocal = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Sale_AdvanceLocal","where CompanyParty_Id="+sMCP_Id[j]));

			double Sales_advDollar = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Sale_AdvanceDollar","where CompanyParty_Id="+sMCP_Id[j]));;
			
			if( "1".equals(sTransaction_Type[j]) )
			//the value was credited in journal so debit it now from the Sale Advance Local and Sale Advance Dollar for cancellation
			{
				Sales_advLocal = Sales_advLocal - Double.parseDouble(sLocal_Amount[j]); 
				Sales_advDollar = Sales_advDollar - Double.parseDouble(sDollar_Amount[j]); 
			}

			if( "0".equals(sTransaction_Type[j]) )
			//the value was debited in journal so credit it now from the Sale Advance Local and Sale Advance Dollar for cancellation
			{
				Sales_advLocal = Sales_advLocal + Double.parseDouble(sLocal_Amount[j]); 		Sales_advDollar = Sales_advDollar + Double.parseDouble(sDollar_Amount[j]); 
			}
			
			query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=? where CompanyParty_Id=?";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setString(1,""+Sales_advLocal);
			pstmt_p.setString(2,""+Sales_advDollar);
			pstmt_p.setString(3,sMCP_Id[j]);
			int a205 = pstmt_p.executeUpdate();
			pstmt_p.close();
		}

		line="212";
		//Revert changes in the Purchase total in MCP if any Purchase Ledger is affected
		query="Select FT.Transaction_Type,FT.Local_Amount, FT.Dollar_Amount,   L.For_HeadId from Financial_Transaction as FT, Ledger as L where FT.Ledger_Id=L.Ledger_Id and L.For_Head=14 and L.Ledger_Type=2 and FT.Voucher_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		ftcount=0;
		while(rs_g.next())
		{	
			ftcount++;
		}
		pstmt_p.close();


		String pMCP_Id[] = new String[ftcount];
		String pTransaction_Type[] = new String[ftcount];
		String pLocal_Amount[] = new String[ftcount];
		String pDollar_Amount[] = new String[ftcount];

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		c=0;
		while(rs_g.next())
		{	
			
			//For sale account 1=credit and 0-debit
			pTransaction_Type[c] = rs_g.getString("Transaction_Type");

			pLocal_Amount[c] = rs_g.getString("Local_Amount");
			pDollar_Amount[c] = rs_g.getString("Dollar_Amount");
			pMCP_Id[c] = rs_g.getString("For_HeadId");
			
			c++;
		}
		pstmt_p.close();


		//out.print("<br>249 ftcount : "+ftcount+" and c : "+c);
		line="250";
		//change Purchase total from Purchase_AdvanceLocal and Purchase_AdvanceDollar 
		for(int j=0; j<ftcount; j++)
		{
			double Purchase_advLocal = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Purchase_AdvanceLocal","where CompanyParty_Id="+pMCP_Id[j]));

			double Purchase_advDollar = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Purchase_AdvanceDollar","where CompanyParty_Id="+pMCP_Id[j]));;

			if( "1".equals(pTransaction_Type[j]) )
			//the value was credited in journal so debit it now from the Purchase Advance Local and Purchase Advance Dollar for cancellation
			{
				Purchase_advLocal = Purchase_advLocal + Double.parseDouble(pLocal_Amount[j]); 
				Purchase_advDollar = Purchase_advDollar + Double.parseDouble(pDollar_Amount[j]); 
			}

			if( "0".equals(pTransaction_Type[j]) )
			//the value was debited in journal so credit it now from the Purchase Advance Local and Purchase Advance Dollar for cancellation
			{
				Purchase_advLocal = Purchase_advLocal - Double.parseDouble(pLocal_Amount[j]); 
				Purchase_advDollar = Purchase_advDollar - Double.parseDouble(pDollar_Amount[j]); 
			}
			
			query="Update Master_CompanyParty set Purchase_AdvanceLocal=?, Purchase_AdvanceDollar=? where CompanyParty_Id=?";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setString(1,""+Purchase_advLocal);
			pstmt_p.setString(2,""+Purchase_advDollar);
			pstmt_p.setString(3,pMCP_Id[j]);
			int a275 = pstmt_p.executeUpdate();
			pstmt_p.close();

		}


	}
	
}//for


}//if 7 Journal Voucher
line="290";


if("77".equals(type))//cancel the setoff journal voucher
{
for(int i=0; i<counter; i++)
{
if(!cancel[i])
	{
		
		
		line="301";
		//Get all the sales rows in payment details
		query="Select For_HeadId,Local_Amount, Dollar_Amount from Payment_Details where For_Head=9 and Voucher_Id=?";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		int pdcount=0;
		while(rs_g.next())
		{	pdcount++;	}

		String sReceive_Id[] = new String[pdcount];


		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		double pdSales_Local=0;
		double pdSales_Dollar=0;
		int c=0;
		while(rs_g.next())
		{	
			sReceive_Id[c]=rs_g.getString("For_HeadId");
			pdSales_Local+=rs_g.getDouble("Local_Amount");
			pdSales_Dollar+=rs_g.getDouble("Dollar_Amount");
			c++;
		}
		pstmt_p.close();
		//out.print("<br>317 pdSales_Local:"+pdSales_Local+" pdSales_Dollar:"+pdSales_Dollar);
		line="3298";
		//Revert changes in the Sales total in MCP if any Sales Ledger is affected
		query="Select FT.Transaction_Type,FT.Local_Amount, FT.Dollar_Amount,   L.For_HeadId from Financial_Transaction as FT, Ledger as L where FT.Ledger_Id=L.Ledger_Id and L.For_Head=14 and L.Ledger_Type=1 and FT.Voucher_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		

		String sMCP_Id = "";
		String sTransaction_Type= "";
		String sLocal_Amount = "";
		String sDollar_Amount = "";

		while(rs_g.next())
		{	
			
			//For sale account 1=credit and 0-debit
			sTransaction_Type = rs_g.getString("Transaction_Type");

			sLocal_Amount = rs_g.getString("Local_Amount");
			sDollar_Amount = rs_g.getString("Dollar_Amount");
			sMCP_Id = rs_g.getString("For_HeadId");
		
		}
		pstmt_p.close();

		//out.print("<br>343 sLocal_Amount:"+sLocal_Amount+" sDollar_Amount:"+sDollar_Amount);
		line="355";

		//change Sales total from Sales_AdvanceLocal and Sales_AdvanceDollar 
		double Sales_advLocal = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Sale_AdvanceLocal","where CompanyParty_Id="+sMCP_Id));

		double Sales_advDollar = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Sale_AdvanceDollar","where CompanyParty_Id="+sMCP_Id));;
			
		if( "1".equals(sTransaction_Type) )
		//the value was credited in journal so debit it now from the Sale Advance Local and Sale Advance Dollar for cancellation
		{
			Sales_advLocal = Sales_advLocal - (Double.parseDouble(sLocal_Amount) -  pdSales_Local); 
			Sales_advDollar = Sales_advDollar - (Double.parseDouble(sDollar_Amount) - pdSales_Dollar); 
		}

		if( "0".equals(sTransaction_Type) )
		//the value was debited in journal so credit it now from the Sale Advance Local and Sale Advance Dollar for cancellation
		{
			Sales_advLocal = Sales_advLocal + (Double.parseDouble(sLocal_Amount) -  pdSales_Local); 
			Sales_advDollar = Sales_advDollar + (Double.parseDouble(sDollar_Amount) - pdSales_Dollar); 
		}
			
		query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=? where CompanyParty_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+Sales_advLocal);
		pstmt_p.setString(2,""+Sales_advDollar);
		pstmt_p.setString(3,sMCP_Id);
		int a371 = pstmt_p.executeUpdate();
		pstmt_p.close();
		
		//out.print("<br>374 Sales_advLocal:"+Sales_advLocal+" Sales_advLocal:"+Sales_advLocal);
		line="386";
		
		for(int k=0;k<pdcount;k++)
		{
			query="Update Receive set ProActive=0 where Receive_Id=?";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setString(1,""+sReceive_Id[k]);
			int a394 = pstmt_p.executeUpdate();
			pstmt_p.close();
		}
		//out.print("<br>374 Sales_advLocal:"+Sales_advLocal+" Sales_advLocal:"+Sales_advLocal);
		line="398";



		//Get all the purchase rows in payment details
		query="Select For_HeadId,Local_Amount, Dollar_Amount from Payment_Details where For_Head=10 and Voucher_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		pdcount=0;
		while(rs_g.next())
		{	pdcount++;	}

		String pReceive_Id[] = new String[pdcount];


		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		double pdPurchase_Local=0;
		double pdPurchase_Dollar=0;
		c=0;
		while(rs_g.next())
		{	
			
		pReceive_Id[c]=rs_g.getString("For_HeadId");	pdPurchase_Local+=rs_g.getDouble("Local_Amount");
			pdPurchase_Dollar+=rs_g.getDouble("Dollar_Amount");
			
		}
		pstmt_p.close();
		//out.print("<br>392 pdPurchase_Local:"+pdPurchase_Local+" pdPurchase_Dollar:"+pdPurchase_Dollar);
		line="429";
		//Revert changes in the Purchase total in MCP if any Purchase Ledger is affected
		query="Select FT.Transaction_Type,FT.Local_Amount, FT.Dollar_Amount,   L.For_HeadId from Financial_Transaction as FT, Ledger as L where FT.Ledger_Id=L.Ledger_Id and L.For_Head=14 and L.Ledger_Type=2 and FT.Voucher_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		
		String pMCP_Id = "";
		String pTransaction_Type = "";
		String pLocal_Amount = "";
		String pDollar_Amount = "";

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,voucher_id[i]);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next())
		{	
			
			//For sale account 1=credit and 0-debit
			pTransaction_Type = rs_g.getString("Transaction_Type");

			pLocal_Amount = rs_g.getString("Local_Amount");
			pDollar_Amount = rs_g.getString("Dollar_Amount");
			pMCP_Id = rs_g.getString("For_HeadId");
		}
		pstmt_p.close();
		//out.print("<br>419 pLocal_Amount:"+pLocal_Amount+" pDollar_Amount:"+pDollar_Amount);
		line="456";
		//change Purchase total from Purchase_AdvanceLocal and Purchase_AdvanceDollar 
		double Purchase_advLocal = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Purchase_AdvanceLocal","where CompanyParty_Id="+pMCP_Id));

		double Purchase_advDollar = Double.parseDouble(A.getNameCondition(conp,"Master_CompanyParty","Purchase_AdvanceDollar","where CompanyParty_Id="+pMCP_Id));;

		if( "1".equals(pTransaction_Type) )
		//the value was credited in journal so debit it now from the Purchase Advance Local and Purchase Advance Dollar for cancellation
		{
			Purchase_advLocal = Purchase_advLocal + (Double.parseDouble(pLocal_Amount) - pdPurchase_Local); 
			Purchase_advDollar = Purchase_advDollar + (Double.parseDouble(pDollar_Amount) - pdPurchase_Dollar); 
		}

		if( "0".equals(pTransaction_Type) )
		//the value was debited in journal so credit it now from the Purchase Advance Local and Purchase Advance Dollar for cancellation
		{
			Purchase_advLocal = Purchase_advLocal - (Double.parseDouble(pLocal_Amount) - pdPurchase_Local); 
			Purchase_advDollar = Purchase_advDollar - (Double.parseDouble(pDollar_Amount) - pdPurchase_Local); 
		}
			
		query="Update Master_CompanyParty set Purchase_AdvanceLocal=?, Purchase_AdvanceDollar=? where CompanyParty_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+Purchase_advLocal);
		pstmt_p.setString(2,""+Purchase_advDollar);
		pstmt_p.setString(3,pMCP_Id);
		int a446 = pstmt_p.executeUpdate();
		pstmt_p.close();

		//out.print("<br>449 Purchase_advLocal:"+Purchase_advLocal+" Purchase_advDollar:"+Purchase_advDollar);
		
		for(int k=0;k<pdcount;k++)
		{
			query="Update Receive set ProActive=0 where Receive_Id=?";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setString(1,""+pReceive_Id[k]);
			int a493 = pstmt_p.executeUpdate();
			pstmt_p.close();
		}

	}
	
}//for


}//if 77 Setoff Journal Voucher

%>
<!-- <script language="JavaScript">
function f1()
{
alert("Data Sucessfully Updated ");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML> -->
<%



conp.commit();

C.returnConnection(conp);

response.sendRedirect("CancelVouchers.jsp?command=edit&&message=Data Sucessfully Updated");


}
catch(Exception Samyak444){ 
	conp.rollback();
C.returnConnection(conp);

out.println("<br><font color=red> FileName : CancelJournal1.jsp Bug No Samyak444 : "+ Samyak444 +" After Line : "+line);
}
}//if Update
%>










