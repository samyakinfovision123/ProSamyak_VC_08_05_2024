<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%


try{
String command=request.getParameter("command");
//String table_name="Ledger";
int tempx=0;
if(command.equals("Nippon05")){
//out.print("<br>23Hans");
String query="";
%>

<% 

// Code for connection start here
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;

try	{
	 cong=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	InsertDefaultValues.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here

//table 1



query="Update Asset Set YearEnd_Id=0";
pstmt_g = cong.prepareStatement(query);
int a = pstmt_g.executeUpdate();
out.print("<br>Default values for YearEnd_Id is inserted.");

//table2
	query="Update  Capital set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    //out.print("<br> line no 48.");
//table 3

query="Update  Balance set YearEnd_Id=0 , Ledger_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	//out.print("<br> line no 53 .");
	out.print("<br>Default values for YearEnd_Id is  inserted.");
    out.print("<br>Default values for Ledger_Id is inserted"); 


//table 4

query="Update  Cash set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 5

    query="Update  Diamond set YearEnd_Id=0 , Diameter=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

    out.print("<br>Default values for Diameter is inserted.");
	
//table 6

query="Update  Financial_Transaction set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted"); 


//table 7

query="Update  ForwardBooking set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted");
	


//table 8 Investment

query="Update  Investment set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	

//table 9
  query="Update  Jewelry set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted .");
	


//table 10

   query="Update  Ledger set YearEnd_Id=0 , Closing_Balance=0 , Closing_LocalBalance=0 , Closing_DollarBalance=0 , Closing_ExchangeRate=0 , PartyGroup_Id=0 , Interest=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	

    out.print("<br>Default values for Closing_Balance inserted");
	
   
    out.print("<br>Default values for Closing_LocalBalance is inserted  ");
   out.print("<br>Default values for Closing_DollarBalance inserted ");
   
   out.print("<br>Default values for Closing_ExchangeRate inserted .");//
	  
   out.print("<br>Default values for PartyGroup_Id is inserted.");
   
   out.print("<br>Default values for Interest is inserted."); 
   
//table 11 Liability

query="Update  Liability set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	
//table 12

query="Update  Loan set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	



//table 13

query="Update  PN set YearEnd_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	

//table 14 ProfitLoss

query="Update  ProfitLoss set YearEnd_Id=0 , Ledger_Id=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    out.print("<br>Default values for Ledger_Id is inserted.");
	

//table 15 Receive


query="Update  Receive set YearEnd_Id=0 , PurchaseSaleGroup_Id=0 , CgtRef_No='' , CgtDescription=''";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
     out.print("<br>Default values for PurchaseSaleGroup_Id is inserted.");
	 

     out.print("<br>Default values for CgtRef_No inserted.");
	 
    
	 out.print("<br>Default values for CgtDescription inserted .");
	 
//table 16 Receive_Transaction

query="Update  Receive_Transaction set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 17 Sheikisho

query="Update  Seikisho set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 18 Voucher

	query="Update  Voucher set YearEnd_Id=0 , Ref_No=''";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    out.print("<br>Default values for Ref_No is inserted .");
	


//table 19 Lot 

    query="Update  Lot set YearEnd_Id=0 , RapaportLocal_Rate=0 , RapaportDollar_Rate=0 , GIA_Filename='' ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    out.print("<br>Default values for RapaportLocal_Rate is  inserted .");
    out.print("<br>Default values for RapaportDollar_Rate is  inserted.");
	

    out.print("<br>Default values for GIA_Filename is inserted  ");
	


//table 20 LotLocation

    query="Update  LotLocation set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 21 Master_Account

 query="Update  Master_Account set YearEnd_Id=0 , Closing_Balance=0 , Closing_LocalBalance=0 , Closing_DollarBalance=0 , Closing_ExchangeRate=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    
	out.print("<br>Default values for Closing_Balance is inserted.");
	
    out.print("<br>Default values for Closing_LocalBalance  is inserted.");
	

    out.print("<br>Default values for Closing_DollarBalance is  inserted.");
	

   out.print("<br>Default values for Closing_ExchangeRate is  inserted. ");
//table 22 Master_AccountType

query="Update  Master_AccountType set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 23 Master_Bank

query="Update  Master_Bank set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 24 Master_Blackinclusion

    query="Update  Master_Blackinclusion set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 25 Master_ClosingPayment
  query="Update  Master_ClosingPayment set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 26 Master_Color
 
    query="Update  Master_Color set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 27 Master_ColorStone

   query="Update  Master_ColorStone set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 28 Master_CompanyParty
    query="Update  Master_CompanyParty set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    //table 29 Master_CostHeadgroup


     query="Update  Master_CostHeadgroup set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

    //table 30 Master_CostHeadSubGroup
    query="Update  Master_CostHeadSubGroup set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
   //table 31 Master_Country

    query="Update  Master_Country set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 31 Master_Currency

    query="Update  Master_Currency set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 32 Master_Cut

    query="Update  Master_Cut set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    //table 33      Master_Department


     
    query="Update  Master_Department set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");


  //table 34  Master_ExchangeRate 

    query="Update  Master_ExchangeRate set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

  //table 35     Master_FinanceHeads
  
    query="Update  Master_FinanceHeads set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");


//table 36      Master_Fluoresence

    query="Update  Master_Fluorescence set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");


//table 37      Master_Gold

  query="Update  Master_Gold set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
// table 38 Master_GoldMetalType
    
	  query="Update  Master_GoldMetalType set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");


// table 39 Master_Groupcode
   
     query="Update  Master_Groupcode set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 40 Master_ItemType

    query="Update  Master_ItemType set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

  //table 41 Master_Lab

    query="Update  Master_Lab set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 42  Master_Location

	 query="Update  Master_Location set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 43 Master_LotCategory
    
	query="Update  Master_LotCategory set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 44 Master_LotSubCategory

     query="Update  Master_LotSubCategory set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
    //table 45 Master_Luster

    query="Update  Master_Luster set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 46 Master_Openinclusion

    query="Update  Master_Openinclusion set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 47 Master_Platinum

   
     query="Update  Master_Platinum set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");



//table 48 Master_Polish
   
     query="Update  Master_Polish set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 49 Master_PrivilidgeLevel

    query="Update  Master_PriviledgeLevel set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 50 Master_Purity

    query="Update  Master_Purity set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 51 Master_SalesPerson
   
    query="Update  Master_SalesPerson set YearEnd_Id=0 , Commission=0";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
     out.print("<br>Default values for Commission is inserted .");
	 //in "+tempx+ " rows");


//table 52 Master_Shade

   query="Update  Master_Shade set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
	//table 53 Master_Shape

     query="Update  Master_Shape set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 54 Master_Size


   query="Update  Master_Size set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

   //table 55 Master_SubGroup

    query="Update  Master_SubGroup set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 56 Master_Supplier

    query="Update  Master_Supplier set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 57 Master_Symmetry

   query="Update  Master_Symmetry set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 58 Master_TableInclusion

   query="Update  Master_TableIncusion set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
// table 59 Master_Treatement

   query="Update  Master_Treatment set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");


//table 60 Master_Unit
  
   query="Update  Master_Unit set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 61 Master_User

   query="Update  Master_User set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
//table 62 Master_VoucherType

    query="Update  Master_VoucherType set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");

//table 63 Payment_Details
   
    
    query="Update  Payment_Details set YearEnd_Id=0 ";
	pstmt_g = cong.prepareStatement(query);
	a = pstmt_g.executeUpdate();
	out.print("<br>Default values for YearEnd_Id is inserted.");
   

pstmt_g.close();

C.returnConnection(cong);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : InsertDefaultValues.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
