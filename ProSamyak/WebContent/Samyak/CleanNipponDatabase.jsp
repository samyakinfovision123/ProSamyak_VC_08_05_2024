<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  class="NipponBean.Connect" />

<%
try{
String command=request.getParameter("command");
String message=request.getParameter("message");

if(command.equals("Default") && message.equals("Yes")) {

%>
<html>
<head>
	<title>Clean Database- Samyak Software</title>
	<script language="javascript">
	function ChkAlert() {
	alert("You are deleting all the data "); 
	}
	</script>
</head>
<body onLoad="return ChkAlert()">
<form action="CleanOrangeDatabase.jsp" method=post>
<input type=hidden name='command' value="<%=command%>">
<input type=hidden name='message' value="<%=message%>">
</body>
</html>
<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
String query="";
try	{
	cong=C.getConnection();
	}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : CleanDatabase.jsp<br>Bug No Samyak32 : "+ Samyak31);}
//table1
	query="delete from Asset";
	pstmt_g = cong.prepareStatement(query);
	int a = pstmt_g.executeUpdate();
	out.print("<br>Asset Data deleted");
   
   
   //table2
	query="delete from Capital";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Capital Data deleted");
	
	
	//table3
	query="delete from Investment";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Investment Data deleted");
      
	  //table4
	query="delete from Liability";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Liability Data deleted");
    
	
	//table5
	query="delete from Loan";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Loan Data deleted");
   
   //table6
	query="delete from Seikisho";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Seikisho Data deleted");
//table7
	query="delete from Cash";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Cash Data deleted");
    
	 //table8
	query="delete from Master_CostHeadSubGroup";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_CostHeadSubGroup Data deleted");
	
	   //table9
	query="delete from Master_CostHeadGroup";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_CostHeadGroup Data deleted");


   //table10
	query="delete from Master_ExchangeRate";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_ExchangeRate Data deleted");
	
	//table11
	query="delete from Master_Currency";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_Currency Data deleted");


    //table12
	query="delete from Master_SalesPerson";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_SalesPerson Data deleted");
	
	//table13

	query="delete from Master_SubGroup";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_SubGroup Data deleted");

	//table14
	query="delete from Diamond";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Diamond Data deleted");

	query="delete from Jewelry";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Jewelry Data deleted");

//table15
	query="delete from Ledger";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Ledger Data deleted");

//table16
	query="delete from ForwardBooking";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>ForwardBooking Data deleted");


//table17
	query="delete from Master_Account";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_Account Data deleted");

//table18
	query="delete from Balance";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Balance Data deleted");

//table19
	query="delete from ProfitLoss";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>ProfitLoss Data deleted");

//table20
	query="delete from Payment_Details";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Payment_Details Data deleted");

//table21
	query="delete from PN";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>PN Data deleted");

//table22
	query="delete from Receive_Transaction";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Receive_Transaction Data deleted");
//table23
	query="delete from Receive";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Receive Data deleted");
	//table24
	query="delete from LotLocation";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>LotLocation Data deleted");
	//table25
	query="delete from Master_Location";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_Location Data deleted");
//table26
	query="delete from Financial_Transaction";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Financial_Transaction Data deleted");
//table27
	query="delete from Voucher";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Voucher Data deleted");
//table28
	query="delete from Lot";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Lot Data deleted");
	
	//Due the lot is required to me empty this is shifted here upto Master_Unit
//table29
	query="delete from Master_LotSubCategory";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_LotSubCategory Data deleted");
//table30
	query="delete from Master_LotCategory";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_LotCategory Data deleted");

        //table31
	query="delete from Master_Unit";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_Unit Data deleted");

//sequence changed for SQL Server 2000 as there were some constraints
//table34
	query="delete from YearEnd";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>YearEnd Data deleted");
	

 //table32
	query="delete from Master_CompanyParty";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_CompanyParty Data deleted");
	
	
	/*query="delete from Master_PaymentTerm";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_PaymentTerm Data deleted");
*/
/*query="delete from Master_Consignee";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_Consignee Data deleted");
*/	

//table33
	query="delete from Master_User where User_Id<>1";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_User Data deleted");
	
	//table35
	query="delete from PhysicalVerification";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>PhysicalVerification Data deleted");
	
	//table36
	query="delete from LedgerChangeLog";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>LedgerChangeLog Data deleted");

	//table37
	query="delete from Master_PartyGroup";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_PartyGroup Data deleted");

//table38
	query="delete from Master_PurchaseSaleGroup";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Master_PurchaseSaleGroup Data deleted");


	
	
	
	
	C.returnConnection(cong);

	out.print("<br><font color=REd> Please contact to Samyak super admin </font>");
	


}else{
	out.print("<br>Please contact to super admin");
	}

}catch(Exception e)
{ out.print("Error is"+e);}
%>

