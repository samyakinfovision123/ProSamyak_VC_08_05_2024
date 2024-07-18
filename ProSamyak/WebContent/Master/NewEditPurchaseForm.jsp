

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
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
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
	//System.out.println("command"+command);
	String message=request.getParameter("message");

	if(message.equals("save"))
	{
		String Receiv_no=request.getParameter("Receive_no");
		out.print("<br><b><center><font class=msgblue >  Purchase no :- </font><font class=msgred >"+Receiv_no+"</font><font class=msgblue > updated successfully </font></center></b>");

	}
	//out.print("<br> command"+command);
	if(command.equals("pedit"))
	{
	ErrLine="56";
		String receive_id=request.getParameter("receive_id");
		//out.print("<br> receive_id"+receive_id);
		int Iv_id=Integer.parseInt(request.getParameter("Iv_id"));
		int Fv_id=Integer.parseInt(request.getParameter("Fv_id"));
		int pdcount=0;
		String Inv_id=""+Iv_id;
		String Finv_id=""+Fv_id;
		ErrLine="57";
		String tempv=""+A.getNameCondition(cong,"Voucher","Voucher_Id"," where Voucher_No='"+receive_id+"'");
	ErrLine="72";	
		String ref_no=""+A.getNameCondition(cong,"Voucher","Ref_No"," where Voucher_Id="+tempv);
		//out.print("<br> ref_no"+ref_no);
		if(Fv_id==0 && Iv_id==0)
		{
	ErrLine="77";
			String pdquery="select * from Payment_Details where (For_Head=9 or For_Head=10) and Active=1 and For_HeadId="+receive_id;

			pstmt_p=cong.prepareStatement(pdquery);
			rs_g=pstmt_p.executeQuery();

			while(rs_g.next())
			{
				pdcount++;
			}
			pstmt_p.close();
			Inv_id=A.getNameCondition(cong,"Voucher","Voucher_Id","where Voucher_No='"+receive_id+"' and Voucher_Type=2 and Active=1");
ErrLine="88";
			//out.print("<br>76 Inv_id "+Inv_id);

			Finv_id=A.getNameCondition(cong,"Voucher","Voucher_Id","where Referance_VoucherId="+receive_id+" and Voucher_Type=9 and Active=1");

			if("".equals(Finv_id))
			{
				Finv_id="0";
			}

	}
ErrLine="99";
		java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date stockdate = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date receive_date = new java.sql.Date(System.currentTimeMillis());
		java.sql.Date split_date = new java.sql.Date(System.currentTimeMillis());

		double exchange_rate=0,ctax=0,discount=0,total=0,org_receivetotal=0,subtotal=0,Difference_Amount=0,Inv_Total=0,Inv_LocalTotal=0,Receive_quantity=0;
		int counter=0,currency_id=0;
		String Broker_Id="";
		double squantity=0,InvTotalAmount=0,totalamount=0,totalLocalamount=0,InvTotalLocalAmount=0;
		String receive_no="",companyparty_id="",receive_companyid="",receive_byname="",receive_fromname="",duedays="",salesperson_id="",narration="",refno="",purchasesalegroup_id="",category_id="";
		String status="unCheck";
		String query="Select * from Receive where Active=1 and Receive_Id=?";
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
			//out.print("<br> purchasesalegroup_id"+purchasesalegroup_id);

			narration = rs_g.getString("CgtDescription");
			if(rs_g.wasNull()){narration="";}
			Broker_Id = rs_g.getString("Broker_Id");
		}//..while end
		pstmt_g.close();
//System.out.println(" 159 narration"+narration);
		InvTotalAmount = Inv_Total;
		InvTotalLocalAmount = Inv_LocalTotal;
		squantity = Receive_quantity;
		double PT_LocalAmount=0.0;
		double PT_DollarAmount=0.0;
		double TotalPT_LocalAmount=0.0;
		double TotalPT_DollarAmount=0.0;
		int Flag=0;
		int PFlag=0;
		query="select Local_Amount,Dollar_Amount from payment_Details where active=1 and For_HeadId="+receive_id;
		pstmt_p = cong.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next())
		{
			PFlag=1;
			PT_LocalAmount=rs_p.getDouble("Local_Amount");
			PT_DollarAmount=rs_p.getDouble("Dollar_Amount");
			
			TotalPT_LocalAmount +=PT_LocalAmount;
			TotalPT_DollarAmount +=PT_DollarAmount;

		}
		pstmt_p.close();

		if (currency_id == 0)
		{
			if(TotalPT_DollarAmount == total  || TotalPT_DollarAmount > total)
			{%>
				<html>
				<head><title>Samyak Software</title></head>
				<body>
					<center> <br><br><h3><font color=red> Sorry,For The Voucher Payment is Done.. Then.. You Cant Edit This Voucher.. </font></h3></center>
				</body></html>
				
			<%	Flag=1;
				}
		}
		if (currency_id != 0)
		{
				if(TotalPT_LocalAmount == total  || TotalPT_LocalAmount > total)
				{ %>
					<html>
				<head><title>Samyak Software</title></head>
				<body>
				<center><br><br>	<h3><font color=red> Sorry,For This Voucher Payment is Done.. Then.. You Cant Edit This Voucher..</font> </h3>
				</center></body></html>
					
				<% Flag=1;
		}

  }


if(Flag == 0)
{
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
		int receivetransaction_id[]=new int[counter]; 
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
			receivetransaction_id[n]=rs_p.getInt("ReceiveTransaction_id");
			lot_id[n]=rs_p.getString("Lot_Id");
			//System.out.print("<br> 141  receivetransaction_id"+receivetransaction_id[n]);
			
			originalQuantity[n]=rs_p.getDouble("Original_Quantity");
			quantity[n]= rs_p.getDouble("Quantity");
			ErrLine="256";
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
ErrLine="271";
			amount[n]= str.mathformat((quantity[n] * Dollar_Price[n]),d) ;
			Localamount[n]=str.mathformat((quantity[n] * Local_Price[n]),d);
			subtotal += amount[n]; 
			calcqty[n]=originalQuantity[n]-returnQuantity[n];
			ghat[n]=calcqty[n]-quantity[n];
			//rate[n]=str.mathformat(rate[n],3);
			n++;

		}//while()....
		pstmt_p.close();
ErrLine="282";
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
		
		String RT_ID="0";
		for(int i=0;i<receivetransaction_id.length;i++)
		{
			if(i==0){RT_ID=""+receivetransaction_id[i];}
			else{RT_ID=RT_ID+","+receivetransaction_id[i];}
		}
	ErrLine="301";	
// Aceesing Split Quantity From DataBase......
		

		//System.out.println(" 303 length"+receivetransaction_id.length);
ErrLine="304";	

	//System.out.println("307 RT_ID"+RT_ID);
		int SplitCounter=0;
		double totalSplit_Quantity=0.0;
		query="select Receive_Id,original_Quantity,ST_RTID from receive_transaction  where active=1 and ST_RTId in("+RT_ID+")";
		
ErrLine="307";	
		pstmt_p = cong.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next())
		{SplitCounter++;}
		pstmt_p.close();
		query="select Receive_Id,original_Quantity,ST_RTID from receive_transaction  where active=1 and ST_RTId in("+RT_ID+")";
		pstmt_p = cong.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		int r=0;
		double Split_Quantity[]= new double[SplitCounter];
		int splitFlag=0,splitReceive_Id=0;
		String sprtid="0";
ErrLine="314";	
		
		int tempST_RTID=0,NewtempST_RTID=0,tempStore=0;
		double tempSplitQuantity=0.0;
		while(rs_p.next())
		{
			//System.out.println(" Start in while");
			splitFlag=1;
			
			splitReceive_Id=rs_p.getInt("Receive_Id");
			tempSplitQuantity=rs_p.getDouble("original_Quantity");
			//Split_Quantity[r]
			tempST_RTID=rs_p.getInt("ST_RTID");
			if(tempST_RTID == NewtempST_RTID)
			{
				tempStore++;
				r=r-tempStore;
				Split_Quantity[r]+=tempSplitQuantity;
				r=r+tempStore;
				Split_Quantity[r]=Split_Quantity[r-tempStore];
//System.out.println(" 317 Split_Quantity under if"+r+""+Split_Quantity[r]);
				
			}
			else{
					Split_Quantity[r]=tempSplitQuantity;
//System.out.println(" 317 Split_Quantity under "+r+" else"+ Split_Quantity[r]);
				}

			NewtempST_RTID=tempST_RTID;

			//totalSplit_Quantity +=Split_Quantity[r];
			if(r==0){sprtid=""+splitReceive_Id;}
			else{sprtid=sprtid+","+splitReceive_Id;}
			r++;
			
		}
		pstmt_p.close();
ErrLine="355";	

		for(int k=0;k<Split_Quantity.length;k++)
		{
			//System.out.println(" 358 Split_Quantity"+Split_Quantity[k]);
		}
	ErrLine="351";		
		HashMap h=new HashMap();
		int ParentReceive_Id[]= new int[SplitCounter];
	//	System.out.println("332 sprtid"+sprtid);
		query="select original_Quantity,ST_RTID from receive_transaction where active=1 and receive_id in ("+sprtid+")";
	//System.out.println("336 query"+query);
		pstmt_p = cong.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		r=0;
ErrLine="360";	
		int qtity=0;
		while(rs_p.next())
		{
			qtity=rs_p.getInt("original_Quantity");
			ParentReceive_Id[r]=rs_p.getInt("ST_RTID");

			h.put(ParentReceive_Id[r],Split_Quantity[r]);
			//System.out.println("372 ParentReceive_Id"+ParentReceive_Id[r]+"Split_Quantity"+Split_Quantity[r]);
			r++;
		}
		pstmt_p.close();
ErrLine="370";	
		if(splitFlag == 1)
		{
			query="select Receive_Date from receive where active=1 and receive_id="+splitReceive_Id;
			pstmt_p = cong.prepareStatement(query);
			rs_p = pstmt_p.executeQuery();	
			while(rs_p.next())
			{
				split_date=rs_p.getDate("Receive_Date");
			}
			pstmt_p.close();
		}
		//System.out.println("333 splitFlag "+splitFlag);
		//System.out.println("334 split_date "+split_date);
// End Of Accessing Split Quantity.........	
		String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+receive_companyid;
		pstmt_p = cong.prepareStatement(company_query);
		rs_g=pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
			company_name= rs_g.getString("CompanyParty_Name");
		}
		pstmt_p.close();
ErrLine="394";	
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
ErrLine="398";

String temp="C. Tax";
int tempLedger=0;
	String QueryLedger_Count="select ledger_id  from ledger where For_Head =17 and ledger_name like  '"+temp+"' and Active=1 and  company_id="+company_id;
	pstmt_p = cong.prepareStatement(QueryLedger_Count);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
		{
			tempLedger=rs_g.getInt("ledger_id");
		}
	pstmt_p.close();
		int lcounter=0;
		QueryLedger_Count="select count(*) as counter from Financial_Transaction where For_Head !=17 and Ledger_Id !="+tempLedger+" and Active=1 and Receive_Id="+receive_id;
		pstmt_p = cong.prepareStatement(QueryLedger_Count);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
			lcounter=rs_g.getInt("counter");
		}
		pstmt_p.close();
ErrLine="408";	
//System.out.println(" 409 lcounter"+lcounter);
		String Ledger_Id[]=new String[lcounter];
		double Lamount[]=new double[lcounter];
		double LocalLamount[]=new double[lcounter];
		int Transaction_Type[]=new int[lcounter];
		int Transaction_Id[]=new int[lcounter];
		double ledgerPercentage[]=new double[lcounter]; 
		QueryLedger_Count="select Tranasaction_id,Transaction_Type,Ledger_Id,Dollar_Amount,Local_Amount,Cheque_No from Financial_Transaction where For_Head !=17 and Active=1 and  Ledger_Id !="+tempLedger+" and Receive_Id="+receive_id;
		pstmt_p = cong.prepareStatement(QueryLedger_Count);
		rs_g = pstmt_p.executeQuery();
		int i=0;
ErrLine="419";
		while(rs_g.next()) 	
		{

	ErrLine="423";		Transaction_Id[i]=rs_g.getInt("Tranasaction_id");
	ErrLine="424";
			Transaction_Type[i]=rs_g.getInt("Transaction_Type");
			//out.print("<br> 234 Transaction_Type"+Transaction_Type[i]);
			Ledger_Id[i]=rs_g.getString("Ledger_Id");
			//out.print("<br> 234 Ledger_Id"+Ledger_Id[i]);
			Lamount[i]=rs_g.getDouble("Dollar_Amount");
		ErrLine="428";	
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
ErrLine="441";
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
		<script language="JavaScript">
		<%
			String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
			pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			String lotNoArray = "";
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					lotNoArray += "\"" +rs_g.getString("Lot_No") +"\"";
				}
				else
				{
					lotNoArray += "\"" +rs_g.getString("Lot_No") +"\",";
				}
			}
			pstmt_g.close();
			out.print("var lotNoArray=new Array("+lotNoArray+");");




			String descQuery = "Select Description_Name from Master_Description where Active=1 order by Sr_No";
		
			pstmt_g = cong.prepareStatement(descQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			String descArray = "";
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					descArray += "\"" +rs_g.getString("Description_Name") +"\"";
				}
				else
				{
					descArray += "\"" +rs_g.getString("Description_Name") +"\",";
				}
			}
			pstmt_g.close();
			out.print("var descArray=new Array("+descArray+");");


			String sizeQuery = "Select Size_Name from Master_Size where Active=1 order by Sr_No";
		
			pstmt_g = cong.prepareStatement(sizeQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			String sizeArray = "";
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					sizeArray += "\"" +rs_g.getString("Size_Name") +"\"";
				}
				else
				{
					sizeArray += "\"" +rs_g.getString("Size_Name") +"\",";
				}
			}
			pstmt_g.close();
			out.print("var sizeArray=new Array("+sizeArray+");");




			String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Sale=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
			pstmt_p = cong.prepareStatement(companyQuery,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			ErrLine="173";
			rs_g = pstmt_p.executeQuery();
			String companyArray = "";
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\"";
				}
				else
				{
					companyArray += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
				}
			}
			pstmt_p.close();
			out.print("var companyArray=new Array("+companyArray+");");
		
			
		%>
			function CallOnLoad()
			{
			
			}


		function recalculateQty(rowNum)
		{
			
			var orgQtyName = "originalQuantity"+rowNum;
			var retQtyName = "returnQuantity"+rowNum;
			var ghatName = "ghat"+rowNum;
			
			var qtyName = "quantity"+rowNum;
			var oldtotalSquantity=document.mainform.totalsquantity.value;
			var oldfinalquantity =document.mainform.elements[qtyName].value;

			var finalquantity = parseFloat(document.mainform.elements[orgQtyName].value) - parseFloat(document.mainform.elements[retQtyName].value) - parseFloat(document.mainform.elements[ghatName].value);

//alert("finalquantity"+finalquantity);

			finalquantity=parseFloat(finalquantity).toFixed(2);
			
			if(finalquantity < 0)
			{
				alert("Quantity will be Negative for row:"+(parseInt(rowNum)+1));
				return false;
			}
			
			var splitFlag=document.mainform.splitFlag.value;
			//alert(splitFlag);
			if(splitFlag == 1 )
			{
				var split="Split_Quantity"+rowNum;
				var split_Quantity =parseFloat(document.mainform.elements[split].value);
				//alert("654 split_Quantity"+split_Quantity);
				//alert("655 finalquantity"+finalquantity);

				if (finalquantity < split_Quantity)
				{
					alert("Quantity will be less than Split Quantity "+ split_Quantity +"  For this row:"+(parseInt(rowNum)+1));
					document.mainform.elements[orgQtyName].select();
					return false;
				}
			}

			document.mainform.elements[qtyName].value = parseFloat(finalquantity).toFixed(3);
			
			var NewSquantityTotal=parseFloat(finalquantity+(oldtotalSquantity - oldfinalquantity));
			document.mainform.totalsquantity.value=parseFloat(NewSquantityTotal).toFixed(3);
			return true;
		}
	
		</script>
		<script language="javascript">
		function calculateEffLocalRate(rowNum)
		{
			//alert('function called for local ');
			var qtyName = "quantity"+rowNum;
			var LocalrateName = "efflocalrate"+rowNum;	
			var Localrate = "localrate"+rowNum;	
			var Localamt="Localamount"+rowNum;
			var rateName = "rate"+rowNum;
			var effrateName = "effrate"+rowNum;	
			var amt="amount"+rowNum;
			var lotdiscountName = "lotDiscount"+rowNum;
			
	// $ rate find
			var LocalRateValue=parseFloat(document.mainform.elements[LocalrateName].value);
			var localRate=LocalRateValue;
			//alert("localrate "+localRate);
			//new
			var lotDiscount = document.mainform.elements[lotdiscountName].value;
			var discountPercents = lotDiscount.split(':');
			for(i=0; i<discountPercents.length; i++)
			{
				
				var discount = discountPercents[i];
				
				if(isNaN(discount))
				{
					return false;
				}
				localRate = localRate + (localRate * discount) / 100;
				
			}
			//old
			document.mainform.elements[Localrate].value=localRate.toFixed(3);
			//alert('localRate'+localRate);
			var exchange_rate= parseFloat(document.mainform.exchange_rate.value);
				
			var RateValue=LocalRateValue / exchange_rate;
			//alert('RateValue'+RateValue);
			//alert('RateValue'+localRate / exchange_rate);
			document.mainform.elements[rateName].value=(localRate / exchange_rate).toFixed(3);
				
			document.mainform.elements[effrateName].value=RateValue.toFixed(3);
// end $ rate find	
			var Localold_amount = parseFloat(document.mainform.elements[Localamt].value);
			var old_amount = parseFloat(document.mainform.elements[amt].value);
			
			
			var new_localamount = parseFloat(document.mainform.elements[qtyName].value) * parseFloat(document.mainform.elements[Localrate].value);
			
			var newamount= parseFloat(document.mainform.elements[qtyName].value) * (document.mainform.elements[rateName].value);
			//alert('newamount'+newamount);
			document.mainform.elements[Localamt].value=new_localamount.toFixed(3);
			document.mainform.elements[amt].value=newamount.toFixed(3);



			var new_localtotal = document.mainform.InvTotalLocalAmount.value - Localold_amount + new_localamount;

			var new_total = document.mainform.InvTotalAmount.value - old_amount + newamount;
			
			var oldLocalTotalAmount= document.mainform.totalLocalamount.value;

			var newLocalTOtalAmount= new_localamount +(oldLocalTotalAmount - Localold_amount);
			
			var oldTotalAmount = document.mainform.totalamount.value;

			var newTotalAmount = newamount + (oldTotalAmount - old_amount)

			document.mainform.InvTotalLocalAmount.value = new_localtotal.toFixed(<%=d%>);

			document.mainform.InvTotalAmount.value = new_total.toFixed(<%=d%>);


			document.mainform.totalamount.value=newTotalAmount.toFixed(<%=d%>);
			document.mainform.totalLocalamount.value=newLocalTOtalAmount.toFixed(<%=d%>);
			


		}
		function calculateEffRate(rowNum)
		{
			//alert('function for daller called');

			var qtyName = "quantity"+rowNum;
			var rate = "rate"+rowNum;	
			var rateName = "effrate"+rowNum;	
			var amt="amount"+rowNum;
			var LocalrateName = "localrate"+rowNum;	
			var effLocalrateName = "efflocalrate"+rowNum;	
			var Localamt="Localamount"+rowNum;
			var lotdiscountName = "lotDiscount"+rowNum;
			var RateValue=parseFloat(document.mainform.elements[rateName].value);

			var Rate=RateValue;
//new
			var lotDiscount = document.mainform.elements[lotdiscountName].value;
			var discountPercents = lotDiscount.split(':');

			for(i=0; i<discountPercents.length; i++)
			{
				var discount = discountPercents[i];
				if(isNaN(discount))
				{
					return false;
				}
				Rate = Rate + (Rate * discount) / 100;
			}
//old..
			document.mainform.elements[rate].value=Rate.toFixed(3);

			var old_Localamount = parseFloat(document.mainform.elements[Localamt].value);
			var old_amount = parseFloat(document.mainform.elements[amt].value);
			
			//alert('function1 called');
		
			//  local rate find
			

			var exchange_rate= parseFloat(document.mainform.exchange_rate.value);

			var LocalRate=parseFloat( RateValue * exchange_rate);
			
			document.mainform.elements[LocalrateName].value=(Rate * exchange_rate).toFixed(3)

			var new_Localamount = parseFloat(document.mainform.elements[qtyName].value) * (document.mainform.elements[LocalrateName].value) ;
			document.mainform.elements[Localamt].value=new_Localamount.toFixed(3);
			document.mainform.elements[effLocalrateName].value=LocalRate.toFixed(3);

			// end local rate find	
				
			//for dollar
			var new_amount = parseFloat(document.mainform.elements[qtyName].value) * (document.mainform.elements[rate].value);

			document.mainform.elements[amt].value=new_amount.toFixed(3);
	
			var localtotal = document.mainform.InvTotalAmount.value - old_amount + new_amount;
			document.mainform.InvTotalAmount.value = localtotal.toFixed(<%=d%>);

			var oldLtotalamount=document.mainform.totalamount.value;
			var newtotalamount = new_amount + (oldLtotalamount - old_amount) ;
			document.mainform.totalamount.value=newtotalamount.toFixed(<%=d%>);

			
			//end
			var oldLtotalLocalamount=document.mainform.totalLocalamount.value;
			
			var new_localtotal = document.mainform.InvTotalLocalAmount.value - old_Localamount + new_Localamount;
			
			document.mainform.InvTotalLocalAmount.value = new_localtotal.toFixed(<%=d%>);
			
			
			var newtotalLocalamount = new_Localamount + (oldLtotalLocalamount - old_Localamount);	

			document.mainform.totalLocalamount.value=newtotalLocalamount.toFixed(<%=d%>);


		}
		function changeCurrency()
		{
				document.mainform.currency.value='local';

				for(var i=0; i<<%=counter%>; i++)
				{
					var rateName = "effrate"+i;
					var localrateName = "efflocalrate"+i;
					document.mainform.elements[rateName].readOnly = true;
					document.mainform.elements[localrateName].readOnly = false;

					document.mainform.elements[rateName].style.backgroundColor = "#CCCCFF";
					document.mainform.elements[localrateName].style.backgroundColor = "#FFFFFF";
				}
		
				if(document.mainform.currency[1].checked)
				{
					document.mainform.currency.value='dollar'
					for(var i=0; i<<%=counter%>; i++)
					{
						var rateName = "effrate"+i;
						var localrateName = "efflocalrate"+i;
						document.mainform.elements[rateName].readOnly = false;
						document.mainform.elements[localrateName].readOnly = true;

						document.mainform.elements[rateName].style.backgroundColor = "#FFFFFF";
						document.mainform.elements[localrateName].style.backgroundColor = "#CCCCFF";
					}
				}
			}
			
		function onSubmitValidateForm()
		{
			//alert("function called");
			
			if(document.mainform.companyparty_name.value=="")
			{
				alert("Please Enter Customer/Party Name");
				document.mainform.companyparty_name.focus();
				document.mainform.companyparty_name.select();
				return false;
			}
			else if(document.mainform.companyparty_name.value.length < 3)
			{
				alert("Customer/Party Name Must Be Atleast 3 Characters");
				document.mainform.companyparty_name.focus();
				document.mainform.companyparty_name.select();
				return false;
			}
				
			for(var z=0; z<<%=counter%>; z++)
			{
				if(!recalculateQty(z))
				{
					return false;
				}
			}
			var command=document.mainform.button.value;
			
			if(command == "NEXT")
			{
				if(!lotCheck())
				{
					return false;
				}
			}else
			{
				var LLval=document.mainform.addLotsLedgers.value
				if(LLval == "0")
				{
					alert('Plz Enter value How many Lots/Ledger u want Add..');
					return false;
				}
			}
	
		
		var TotalPT_DollarAmount = parseFloat(document.mainform.TotalPT_DollarAmount.value);

		var TotalPT_LocalAmount=parseFloat(document.mainform.TotalPT_LocalAmount.value);

		var totalAmount =parseFloat(document.mainform.totalamount.value);
		var totalLocalAmount =parseFloat(document.mainform.totalLocalamount.value);
		if(command == "NEXT")
		{
		if (document.mainform.currency[1].checked)
		{
			
			if(TotalPT_DollarAmount > totalAmount )
			{	alert("Sorry Invoice Amount is Less Than .. ");
				return false;
			}
			
		}
		else		
		{	if( totalLocalAmount < TotalPT_LocalAmount )
			{	alert("Sorry Invoice Amount is Less Than .. ");
				return false;
			}
			
		}
		}
		var totalSplit_Quantity=parseFloat(document.mainform.totalSplit_Quantity.value);

		var totalsquantity=parseFloat(document.mainform.totalsquantity.value);
		
		/*if( totalsquantity < totalSplit_Quantity )
		{ alert(" Sorry , Invoice Total Quantity is less than.. Is  Split Quantity");
			//return false;
		} */
		
		narrationCall();
		return true;

	}

		function lotCheck()
		{			
			var flag=0;
			for(var z=0; z<<%=counter%>; z++)
			{	if(<%=counter%> > 1)
				{	var a="checkBox"+z;
					if(document.mainform.elements[a].checked)
					{flag ++;}
				}
			}
			
			if(<%=counter%> > 1)
			{	if(flag == <%=counter%>)
				{alert('you cant Delete all lots.. ');
				return false;}
			}
			return true;
		}

		function mecall(rownum)
		{
			//alert('me'+rownum);
			var a="checkBox"+rownum;
			var lotno="lotno"+rownum;
			var description="description"+rownum;
			var dsize="dsize"+rownum;
			var originalQuantity="originalQuantity"+rownum;
			var returnQuantity="returnQuantity"+rownum;
			var ghat="ghat"+rownum;
			var quantity="quantity"+rownum;
			var effrate="effrate"+rownum;
			var efflocalrate="efflocalrate"+rownum;
			var amount="amount"+rownum;
			var Localamount="Localamount"+rownum;
			var lotDiscount="lotDiscount"+rownum;
			if(document.mainform.elements[a].checked)
			{	
			//totalquantity subtract
				var tsqt=parseFloat(document.mainform.totalsquantity.value);

				document.mainform.totalsquantity.value= (tsqt - document.mainform.elements[quantity].value).toFixed(3);
			//Inv total.. subtract
				var InvTotal=parseFloat(document.mainform.InvTotalAmount.value);
				document.mainform.InvTotalAmount.value=(InvTotal - document.mainform.elements[amount].value).toFixed(3);
			//Inv Localtotal.. subtract
				var InvLocalTotal=parseFloat(document.mainform.InvTotalLocalAmount.value);
				document.mainform.InvTotalLocalAmount.value=(InvLocalTotal - document.mainform.elements[Localamount].value).toFixed(3);
			//totalamount
				var totalamount=parseFloat(document.mainform.totalamount.value);
				document.mainform.totalamount.value=( totalamount - parseFloat(document.mainform.elements[amount].value)).toFixed(3);
			//totalLocalamount
				var totalLocalamount=parseFloat(document.mainform.totalLocalamount.value);
				document.mainform.totalLocalamount.value=( totalLocalamount - parseFloat(document.mainform.elements[Localamount].value)).toFixed(3);

				document.mainform.elements[lotno].readOnly=true;
				document.mainform.elements[description].readOnly=true;
				document.mainform.elements[dsize].readOnly=true;
				document.mainform.elements[originalQuantity].readOnly=true;
				document.mainform.elements[returnQuantity].readOnly=true;
				document.mainform.elements[ghat].readOnly=true;
				document.mainform.elements[quantity].readOnly=true;
				document.mainform.elements[effrate].readOnly=true;
				document.mainform.elements[efflocalrate].readOnly=true;
				document.mainform.elements[amount].readOnly=true;
				document.mainform.elements[Localamount].readOnly=true;
				document.mainform.elements[lotDiscount].readOnly=true;
			}else
			{
				
				//totalquantity subtract
				var tsqt=parseFloat(document.mainform.totalsquantity.value);
				
				document.mainform.totalsquantity.value= ( tsqt + parseFloat(document.mainform.elements[quantity].value)).toFixed(3);
				//Inv total.. subtract
				var InvTotal=parseFloat(document.mainform.InvTotalAmount.value);
				document.mainform.InvTotalAmount.value=(InvTotal + parseFloat(document.mainform.elements[amount].value)).toFixed(3);
			//Inv Localtotal.. subtract
				var InvLocalTotal=parseFloat(document.mainform.InvTotalLocalAmount.value);
				document.mainform.InvTotalLocalAmount.value=( InvLocalTotal + parseFloat(document.mainform.elements[Localamount].value)).toFixed(3);
			//totalamount
				var totalamount=parseFloat(document.mainform.totalamount.value);
				document.mainform.totalamount.value=( totalamount + parseFloat(document.mainform.elements[amount].value)).toFixed(3);
			//totalLocalamount
				var totalLocalamount=parseFloat(document.mainform.totalLocalamount.value);
				document.mainform.totalLocalamount.value=( totalLocalamount + parseFloat(document.mainform.elements[Localamount].value)).toFixed(3);

				document.mainform.elements[lotno].readOnly=false;
				document.mainform.elements[description].readOnly = false;
				document.mainform.elements[dsize].readOnly=false;
				document.mainform.elements[originalQuantity].readOnly=false;
				document.mainform.elements[returnQuantity].readOnly= false;
				document.mainform.elements[ghat].readOnly=false;
				document.mainform.elements[quantity].readOnly=false;
				document.mainform.elements[effrate].readOnly=false;
				document.mainform.elements[efflocalrate].readOnly =false;
				document.mainform.elements[amount].readOnly=false;
				document.mainform.elements[Localamount].readOnly= false;
				document.mainform.elements[lotDiscount].readOnly= false;
			} 
				
}

function setRatesAfterLotFetch(rowNum)
		{
			var rateName = "rate"+rowNum;	
			var effrateName = "effrate"+rowNum;	
			var localrateName = "localrate"+rowNum;	
			var efflocalrateName = "efflocalrate"+rowNum;

			document.mainform.elements[rateName].value = document.mainform.elements[effrateName].value;

			document.mainform.elements[localrateName].value = parseFloat(document.mainform.elements[rateName].value) * parseFloat(document.mainform.exchange_rate.value);

			document.mainform.elements[efflocalrateName].value = document.mainform.elements[localrateName].value;
	
		}
function setOtherRates(rowNum)
{
	//alert('setOtherRates called');
	var rateName = "rate"+rowNum;	
	var effrateName = "effrate"+rowNum;	
	var localrateName = "localrate"+rowNum;	
	var efflocalrateName = "efflocalrate"+rowNum;

	<%
	if(currency_id != 0)
	{
		out.print("if(document.mainform.currency[0].checked )");
	}
	else
	{
		out.print("if(document.mainform.currency.value == \"local\" )");
	}
	%>
	{
		//alert('set others called for dollar');
		document.mainform.elements[localrateName].value = document.mainform.elements[efflocalrateName].value;

		document.mainform.elements[rateName].value = (parseFloat(document.mainform.elements[localrateName].value) / parseFloat(document.mainform.exchange_rate.value));

		document.mainform.elements[effrateName].value = document.mainform.elements[rateName].value;
		calculateEffRate(rowNum);

	}
	else
	{
		//alert('set others rate called for local');
		document.mainform.elements[rateName].value = document.mainform.elements[effrateName].value;

		document.mainform.elements[localrateName].value = (parseFloat(document.mainform.elements[rateName].value) * parseFloat(document.mainform.exchange_rate.value));

		document.mainform.elements[efflocalrateName].value = document.mainform.elements[localrateName].value;
		calculateEffLocalRate(rowNum);
	}
}

function calcDueDays()
{
	
/******  Function to calculate differece
  of days between two dates *******/

	var date1_element=new Array();
	var date2_element=new Array();

	var date1=document.mainform.datevalue.value;
	date1_element=date1.split("/");
	var d1=date1_element[0];
	var m1=date1_element[1];
	var y1=date1_element[2];
	
	var date2=document.mainform.duedate.value;
	date2_element=date2.split("/");
	var d2=date2_element[0];
	var m2=date2_element[1];
	var y2=date2_element[2];

	var inv_date=new Date(y1,(m1-1),d1);
	var due_date=new Date(y2,(m2-1),d2);
	
	
	var  one_day_milliseconds=1000*60*60*24;
	var d1=inv_date.getTime();
	var d2=due_date.getTime();
	
	var difference_time=Math.abs(d1-d2);
	var days=Math.round(difference_time/one_day_milliseconds);
	document.mainform.duedays.value=days;
} //calcDueDays()

function checkSplitDate()
{
	var split_Flag=parseFloat(document.mainform.splitFlag.value);
	//alert("split_Flag"+split_Flag);
	if (split_Flag == 1)
	{
		var split_date= new Array()
		var date1_element= new Array()
		var date1=document.mainform.datevalue.value;
		date1_element=date1.split("/");
		var d1=date1_element[0];
		var m1=date1_element[1];
		var y1=date1_element[2];
		//alert("Invoice Date  d1"+d1+"m1"+m1+"y1"+y1);

		var splitd=document.mainform.split_date.value;
		split_date= splitd.split("/");
		var d11=split_date[0];
		var m11=split_date[1];
		var y11=split_date[2];
		//alert("split Date  d11"+d11+"m11"+m11+"y11"+y11);
		if(d11 > d1 || m11 > m1 || y11 > y1)
		{
			alert(" Sorry, This Date is Before Split date..  ")
			document.mainform.datevalue.focus();
			return false;
		}

		
	}
	return true;
}
</script>
</head>
		<body background="../Buttons/BGCOLOR.JPG" OnLoad="document.mainform.RefNo.focus();">
		<form name=mainform action="NewEditpurchaseAddNext.jsp" method="post" onsubmit="return onSubmitValidateForm()" >
			

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
				<input type=text name=consignment_no size=5 value="<%=receive_no%>" readonly style="background:#CCCCFF">
			</td>
			<td >Ref No :
				<input type=text name=RefNo size=5 value="<%=ref_no%>">
			</td>
			<td >Currency :
				<input type=radio name=currency value="Local" <%=disloc%> onclick="changeCurrency();">Local
				<input type=radio name=currency value="Dollar" <%=disdol%> onclick="changeCurrency();">Dollar
			</td>
				
			
			<td >To :
				<%if(PFlag == 1){%>
				<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off readonly style="background:#CCCCFF">
				<%}else{%>
				<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
				<%}%>
				<input type=hidden name=companyparty_id value="<%=companyparty_id%>">

				 <script language="javascript">
					var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
				</script>	
			</td>
			<td >Purchase Group:</td>
			<td>	<%=AC.getMasterArrayCondition(cong,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=1",company_id)%>
			</td>
				
				
			
		</tr>
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		<td colspan=1 width="15%">
		<script language='JavaScript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
		</script>
		</td>
		<td  width="15%">
			<input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(receive_date)%>" OnKeyUp="checkMe(this);" onBlur="return checkSplitDate()"></td>	
		<td colspan=1  width="14%">Due Days</td>
		<td><input type=text name="duedays" value="<%=duedays%>"size=5 onBlur="return addDueDays(document.mainform.datevalue, 'Date', document.mainform.duedate, this);"></td>
		<td colspan=1  width="15%">
			<script language='JavaScript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
			</script>
		</td>
		<td  width="15%">
			<input type=text name='duedate' size=8 maxlength=10 	value="<%=format.format(due_date)%>" OnKeyUp="checkMe(this)" onblur='calcDueDays()'></td>

		</tr>
		<tr>
			<input type=hidden name="pdcount" value="<%=pdcount%>">
		<% if( (Iv_id>0 && Fv_id>0) || pdcount==0 )
			{
			String FTcash_id=A.getNameCondition(conp,"Financial_Transaction","For_HeadId","where Voucher_Id="+Fv_id+" and For_Head=1 and Active=1");
	
		%>
		
			<%}%>
			<td >Location </td>
			<td > 							
			<%if(counter != 0)
			{%>	<%=AC.getMasterArrayCondition(cong,"Location","masterlocation",location_id[0],"where company_id="+company_id)%>
			<%}%>
			</td>
			<td >Category</td>
			<td>
				<%=AC.getArrayConditionAll(cong,"Master_LotCategory","category_id",category_id ,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
			</td>
				
		</tr>
			<tr>
			<td >Exchange Rate</td>
			<td><input type=text name=exchange_rate  value="<%=str.format(exchange_rate)%>" onBlur="validate(this,2)"  size=4 style="text-align:right"></td>
			

			<td >Purchase Person </td>
			<td><%=AC.getMasterArrayCondition(cong,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=1 and Active=1 and company_id="+company_id+"") %>
			</td>

			<td >Broker</td>
			<td>	<%=AC.getMasterArrayCondition(cong,"SalesPerson","Broker_Id",Broker_Id,"where PurchaseSale=2 and Active=1 and company_id="+company_id+"")%>
			</td>
			
		</tr>	
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2 name=t1>
	<tr>
		<td>Sr No/<font color=#FF3366><b>Delete</b></font></td>
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
	<input type=hidden name=rtid<%=i%> value="0" >
	

	<tr name=tr<%=i%>>

		<%if(splitFlag == 1)
		{
			if(h.containsKey(receivetransaction_id[i]))
			{%><td><%=t%></td><%}
			else{%><td><table border=1 bordercolor=skyblue><tr><td><%=t%></td><td>&nbsp;&nbsp;<input type=checkbox name="checkBox<%=i%>" onClick="mecall(<%=i%>)" ></td></tr></table></td><%}
		}
		else
		{
			
			if(counter >1 )
			{%>
				<td><%=t%>&nbsp;&nbsp;<input type=checkbox name="checkBox<%=i%>" onClick="mecall(<%=i%>)" ></td>
				<%}else{%><td><%=t%></td><%}
		}
			%>

		<td><input type=text name=lotno<%=i%> id=lotno<%=i%> autocomplete=off value="<%=lot_no[i]%>" size=7 style="text-align:right" onfocus="this.select()" 
		onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'purchaseEdit' ); " autocomplete=off  style="text-align:right;"
		<%if(splitFlag == 1)
		  {	if(h.containsKey(receivetransaction_id[i]))
			{ out.print(" readonly style=background:#CCCCFF");}}
		%>></td>

		<td><input type=text  name=description<%=i%> size=4 value="<%=Desciption_Name[i]%>" style="text-align:left" id=description<%=i%> autocomplete=off onfocus="this.select()" ></td>

		<td><input type=text  name=dsize<%=i%> size=4 value="<%=Size_Name[i]%>"  style="text-align:left" id=dsize<%=i%> autocomplete=off onfocus="this.select()" onblur="getLots('<%=company_id%>', document.mainform.description<%=i%>.value, document.mainform.dsize<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','lotno<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'purchaseEdit' ); ">

		<td><input type=text name=originalQuantity<%=i%> value="<%=originalQuantity[i]%>"  size=5 style="text-align:right" onBlur=" recalculateQty('<%=i%>'); setOtherRates('<%=i%>');" onfocus="this.select()"></td>
			<!-- ;  setRatesAfterLotFetch(<%//=i%>); -->
		<td><input type=text name=returnQuantity<%=i%> value="<%=returnQuantity[i]%>"  size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')" ></td>
		<td><input type=text name=ghat<%=i%> value="<%=str.mathformat(""+ghat[i],3)%>" size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')" ></td>
		<td><input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 style="text-align:right;background:#CCCCFF" readonly></td>
		<input type=hidden name=rejection<%=i%> value="<%=rejection[i]%>" onBlur="nochk(this,3)" >
		<input type=hidden name=newrejection<%=i%> value="0" >
		<input type=hidden name=rejectionQty<%=i%> value="<%=rejectionQty[i]%>">
		<!-- old -->
		<!-- <td><input type=text name=rate<%=i%> value="<%//=str.mathformat(""+rate[i],3)%>" size=7 style="text-align:right" onBlur="calculateEffLocalRate(<%//=i%>)"></td> -->
		<!-- end --
		New  ad -->
		<td><input type=hidden name=rate<%=i%> size=5 value="<%=str.format(Dollar_Price[i], 3)%>"  style="text-align:right" id=rate<%=i%>>
		
		<input type=text onfocus="this.select()" size=5 name=effrate<%=i%> value="<%=str.format(DollarEffective_Price[i], 3)%>"  style="text-align:right" onBlur="calculateEffRate('<%=i%>')" id=effrate<%=i%> <%if(currency_id != 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<td>
		<input type=hidden name=localrate<%=i%> value="<%=str.format(Local_Price[i], 3)%>"  style="text-align:right" id=localrate<%=i%>>
		
		<input type=text onfocus="this.select()" name=efflocalrate<%=i%> value="<%=str.format(LocalEffective_Price[i], 3)%>"  style="text-align:right" size=7 id=efflocalrate<%=i%> onBlur="calculateEffLocalRate('<%=i%>')"
		<%if(currency_id == 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<!-- new End -->

		<td><input type=text name=amount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>" size=7 style="text-align:right;background:#CCCCFF""></td>

		<td><input type=text name=Localamount<%=i%> value="<%=str.mathformat(""+Localamount[i],d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name=lotDiscount<%=i%> value="<%=lotDiscount[i]%>" size=7 style="text-align:left" onBlur="checkDiscount(this);<%
		if(currency_id != 0)
		{
			out.print("if(document.mainform.currency[1].checked )");
		}
		else
		{
			out.print("if(document.mainform.currency.value == \'dollar\' )");
		}
		%>
		{calculateEffRate('<%=i%>')} else {calculateEffLocalRate('<%=i%>')}"></td>
		<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=7 style="text-align:right"></td> 
	</tr>

	<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
	<input type=hidden name=lotid<%=i%> value="<%=lot_id[i]%>">
	
	<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
	<input type=hidden name=newlocation_id<%=i%> value="<%=location_id[i]%>">	
	<input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" >
	<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
	<input type=hidden name=hiddenamount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>">
	<script language="javascript">

		var lobj<%=i%> = new  actb(document.getElementById('lotno<%=i%>'), lotNoArray);
		
		var dobj<%=i%> = new  actb(document.getElementById('description<%=i%>'), descArray);

		var sobj<%=i%> = new  actb(document.getElementById('dsize<%=i%>'), sizeArray);
		
	</script>

	<%if(splitFlag == 1)
	 {
		if(h.containsKey(receivetransaction_id[i]))
		{ double sqt=(Double)h.get(receivetransaction_id[i]);
			%> 
			<input type=hidden name=Split_Quantity<%=i%> value="<%=sqt%>">
			<input type=hidden name=Split_RTID<%=i%> value="<%=receivetransaction_id[i]%>">

		 <%}else{
				%><input type=hidden name=Split_Quantity<%=i%> value="<%=0%>">
				<input type=hidden name=Split_RTID<%=i%> value="<%=0%>">
				<%}

	}else
		{%>
			<input type=hidden name=Split_Quantity<%=i%> value="<%=0%>">
			<input type=hidden name=Split_RTID<%=i%> value="<%=0%>">
		<%}
		//System.out.println("1294 ParentReceive_Id"+ParentReceive_Id[i]+"receivetransaction_id"+receivetransaction_id[i]);
	}
		 if(splitFlag == 1)
		{%>
			<input type=hidden name=split_date value=<%=format.format(split_date)%> >
		<%}
	int tempcounter=counter;
	int tempOldLedgercounter=lcounter;%>
		<input type=hidden name=receive_id value="<%=receive_id%>">
		<input type=hidden name=currency_id value="<%=currency_id%>">
		<input type=hidden name=counter value="<%=counter%>">
		<input type=hidden name=tempcounter value="<%=tempcounter%>">
		<input type=hidden name=tempOldLedgercounter value="<%=tempOldLedgercounter%>">
		<input type=hidden name=oldLotRows value="<%=counter%>">
		<input type=hidden name=oldLedgerRows value="<%=lcounter%>">

		<input type=hidden name=lcounter value="<%=lcounter%>">
		<input type=hidden name=TotalPT_DollarAmount value="<%=TotalPT_DollarAmount%>">
		<input type=hidden name=TotalPT_LocalAmount value="<%=TotalPT_LocalAmount%>">
		<input type=hidden name=totalSplit_Quantity value="<%=totalSplit_Quantity%>">
		<input type=hidden name=splitFlag value="<%=splitFlag%>">
		<input type=hidden name=SplitCounter value="<%=SplitCounter%>">
		<input type=hidden name=PFlag value="<%=PFlag%>">
		
		
	<tr>
		<td colspan=7>Inventory Total </td>
		<td><input type=text name="totalsquantity" value="<%=squantity%>" size=5 style="text-align:right;background:#CCCCFF"  readonly></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><input type=text name="InvTotalAmount" value="<%=str.format2(""+InvTotalAmount,d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name="InvTotalLocalAmount" value="<%=str.format2(""+InvTotalLocalAmount,d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>
	</tr>
	<%
		for(int j=0;j<lcounter;j++)
		{
	%>
		
	<tr>
			<input type=hidden name=Transaction_Id<%=j%> value=<%=Transaction_Id[j]%>>
		<td colspan=5 align=right>
			<font color=#FF3333>Delete </font><input type=checkBox name=delLedger<%=j%> onClick="LedgerCalculation(<%=j%>)">
		</td>
		<td colspan=4 align=right>
			<%=A.getArray(cong,"Ledger","ledger"+j,Ledger_Id[j],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
		<td><input type=text name=ledgerPercent<%=j%> value="<%=ledgerPercentage[j]%>" size=7 style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">%</td>
		<td>
			<input type=text onfocus="this.select()" size=7 name=Lamount<%=j%> value="<%=Lamount[j]%>"  style="text-align:right" onBlur="ledgerAmountChanged(<%=j%>)">
		</td>
		<td>
			<input type=text onfocus="this.select()" size=7 name=LocalLamount<%=j%> value="<%=LocalLamount[j]%>"  style="text-align:right" onBlur="ledgerLocalAmountChanged(<%=j%>)">
		</td>
		<td>
			<select name= "debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)" >
			<%
				String Dr="",Cr="";
				if(Transaction_Type[j] == 1)
				{%>
					<option value="1" selected>Cr</option>
					<option value="-1" >Dr</option>
				<%}else{%>
					<option value="1" >Cr</option>
					<option value="-1" selected>Dr</option>
					
				<%	}%>
				
			</select>
		</td>
		
	</tr>
	<%}%>
<script language="javascript">

		function LedgerCalculation(rowNum)
		{
			var delLedger="delLedger"+rowNum;
			var ledgerPercent="ledgerPercent"+rowNum;
			var Lamount="Lamount"+rowNum;
			var LocalLamount="LocalLamount"+rowNum;
			
			if(document.mainform.elements[delLedger].checked)
			{
				document.mainform.elements[ledgerPercent].value="0.0";
				var Lamountvalue=parseFloat(document.mainform.elements[Lamount].value);
				var LocalLamountvalue=parseFloat(document.mainform.elements[LocalLamount].value);
				document.mainform.elements[Lamount].value="0.0";
				document.mainform.elements[LocalLamount].value="0.0";
				var totalamount=parseFloat(document.mainform.totalamount.value);
				var totalLocalamount=parseFloat(document.mainform.totalLocalamount.value);
				totalamount= (totalamount - Lamountvalue);
				totalLocalamount = (totalLocalamount - LocalLamountvalue);
			document.mainform.totalamount.value=totalamount.toFixed(3);
			document.mainform.totalLocalamount.value= totalLocalamount.toFixed(3);
			document.mainform.elements[ledgerPercent].focus();
			document.mainform.elements[delLedger].value="Delete";
			}
			else{document.mainform.elements[delLedger].value="";
				}
		}
		
		function percentLedgerChanged(rowNum)
		{
			//alert('function called');

			
			var TotalAmount=0;
			var DebCre,LrAmount,LrLocalAmount;
			var DebCreValue;
			var LrPercentage;///="ledgerPercent"+rowNum;
			var LedgerPercentage; ///=parseFloat(document.mainform.elements[LrPercentage].value);
			var InvLocaltotal=parseFloat(document.mainform.InvTotalLocalAmount.value);
			var Invtotal=parseFloat(document.mainform.InvTotalAmount.value);
			for(i=0;i<rowNum;i++)
			{
				DebCre="debitcredit"+i;
				DebCreValue=document.mainform.elements[DebCre].value;
				LrLocalAmount="LocalLamount"+i;
				LrAmount="Lamount"+i;
				var LedgerAmount=parseFloat(document.mainform.elements[LrLocalAmount].value);
				var LedgerAmount1=parseFloat(document.mainform.elements[LrAmount].value);
				if(DebCreValue == 1)
				{
					InvLocaltotal =InvLocaltotal - LedgerAmount;
					Invtotal =Invtotal - LedgerAmount1;
					
				}else
				{
					InvLocaltotal =InvLocaltotal + LedgerAmount;
					Invtotal =Invtotal + LedgerAmount1;
				}
			
			}
			var tempInvTotal=InvLocaltotal;
			for(i=rowNum;i<<%=lcounter%>;i++)
			{
				LrPercentage="ledgerPercent"+i;
				DebCre="debitcredit"+i;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;	DebCreValue=document.mainform.elements[DebCre].value;
				 LedgerPercentage=parseFloat(document.mainform.elements[LrPercentage].value);
				var PerAmount=(LedgerPercentage /100) * InvLocaltotal;
				var PerAmount1=(LedgerPercentage /100) * Invtotal;
				document.mainform.elements[LrLocalAmount].value=PerAmount.toFixed(3);
				document.mainform.elements[LrAmount].value=PerAmount1.toFixed(3);
				//document.mainform.elements[LrAmount].value=.toFixed(3);

				if(DebCreValue == 1)
				{
					InvLocaltotal =InvLocaltotal - PerAmount;
					Invtotal =Invtotal - PerAmount1;
				}
				else
				{
					InvLocaltotal =InvLocaltotal + PerAmount;
					Invtotal =Invtotal + PerAmount1;
				}
				document.mainform.totalLocalamount.value=InvLocaltotal.toFixed(3);
				document.mainform.totalamount.value=Invtotal.toFixed(3);
			}
			
		}
		function ledgerAmountChanged(rowNum)
		{
			var TotalAmount=0;
			var DebCre,LrAmount,LrLocalAmount,LAmountLocalValue,LAmountValue;
			var DebCreValue;
			var LrPercentage;
			var LedgerPercentage,LedgerPercentageValue; 

			var Invtotal=parseFloat(document.mainform.InvTotalAmount.value);
			var InvLocaltotal=parseFloat(document.mainform.InvTotalLocalAmount.value);
			for(i=0;i<rowNum;i++)
			{
				DebCre="debitcredit"+i;
				DebCreValue=document.mainform.elements[DebCre].value;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;
				var LedgerAmount=parseFloat(document.mainform.elements[LrAmount].value);
				
				var LedgerLocalAmount=parseFloat(document.mainform.elements[LrLocalAmount].value);
				
				if(DebCreValue == 1)
				{
					Invtotal =Invtotal - LedgerAmount;
					InvLocaltotal =InvLocaltotal - LedgerLocalAmount;
				}else
				{
					Invtotal =Invtotal + LedgerAmount;
					InvLocaltotal =InvLocaltotal + LedgerLocalAmount;
				}
			
			}
			var tempInvTotal=Invtotal;
			for(i=rowNum;i<<%=lcounter%>;i++)
			{
				//alert('Second For');
				LrPercentage="ledgerPercent"+i;
				DebCre="debitcredit"+i;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;
				DebCreValue=document.mainform.elements[DebCre].value;
				LAmountValue=parseFloat(document.mainform.elements[LrAmount].value);
				
				LedgerPercentage=parseFloat((LAmountValue/Invtotal)*100);

				//alert(LedgerPercentage);
				document.mainform.elements[LrPercentage].value=LedgerPercentage.toFixed(3);
				
				LedgerPercentageValue =parseFloat( ( LedgerPercentage/ 100) * InvLocaltotal)

				//alert(LedgerPercentageValue);
				document.mainform.elements[LrLocalAmount].value=LedgerPercentageValue.toFixed(3);

				LAmountLocalValue=parseFloat(document.mainform.elements[LrLocalAmount].value);

				if(DebCreValue == 1)
				{
					Invtotal =Invtotal - LAmountValue;
					InvLocaltotal =InvLocaltotal - LAmountLocalValue;
				}
				else
				{
					Invtotal =Invtotal + LAmountValue;
					InvLocaltotal =InvLocaltotal + LAmountLocalValue;
				}
				document.mainform.totalamount.value=Invtotal.toFixed(3);
				document.mainform.totalLocalamount.value=InvLocaltotal.toFixed(3);
			
			}

		}
		function ledgerLocalAmountChanged(rowNum)
		{
			var TotalAmount=0;
			var DebCre,LrAmount,LrLocalAmount,LAmountLocalValue,LAmountValue;
			var DebCreValue;
			var LrPercentage;
			var LedgerPercentage,LedgerPercentageValue; 

			var Invtotal=parseFloat(document.mainform.InvTotalAmount.value);
			var InvLocaltotal=parseFloat(document.mainform.InvTotalLocalAmount.value);
			for(i=0;i<rowNum;i++)
			{
				DebCre="debitcredit"+i;
				DebCreValue=document.mainform.elements[DebCre].value;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;
				var LedgerAmount=parseFloat(document.mainform.elements[LrAmount].value);
				
				var LedgerLocalAmount=parseFloat(document.mainform.elements[LrLocalAmount].value);
				
				if(DebCreValue == 1)
				{
					Invtotal =Invtotal - LedgerAmount;
					InvLocaltotal =InvLocaltotal - LedgerLocalAmount;
				}else
				{
					Invtotal =Invtotal + LedgerAmount;
					InvLocaltotal =InvLocaltotal + LedgerLocalAmount;
				}
			
			}
			var tempInvTotal=Invtotal;
			for(i=rowNum;i<<%=lcounter%>;i++)
			{
				//alert('Second For');
				LrPercentage="ledgerPercent"+i;
				DebCre="debitcredit"+i;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;
				DebCreValue=document.mainform.elements[DebCre].value;
				LAmountLocalValue=parseFloat(document.mainform.elements[LrLocalAmount].value);
				
				LedgerPercentage=parseFloat((LAmountLocalValue/InvLocaltotal)*100);

				//alert(LedgerPercentage);
				document.mainform.elements[LrPercentage].value=LedgerPercentage.toFixed(3);
				
				LedgerPercentageValue =parseFloat( ( LedgerPercentage/ 100) * Invtotal)

				//alert(LedgerPercentageValue);
				document.mainform.elements[LrAmount].value=LedgerPercentageValue.toFixed(3);

				LAmountValue=parseFloat(document.mainform.elements[LrAmount].value);

				if(DebCreValue == 1)
				{
					Invtotal =Invtotal - LAmountValue;
					InvLocaltotal =InvLocaltotal - LAmountLocalValue;
				}
				else
				{
					Invtotal =Invtotal + LAmountValue;
					InvLocaltotal =InvLocaltotal + LAmountLocalValue;
				}
				document.mainform.totalamount.value=Invtotal.toFixed(3);
				document.mainform.totalLocalamount.value=InvLocaltotal.toFixed(3);
			
			}

		}
		function setbuttonValue(v1)
		{document.mainform.button.value=v1;}


	</script>
	<tr>
		<td colspan=10>Total </td>
		<td><input type=text name=totalamount value="<%=str.format2(""+totalamount,d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name=totalLocalamount value="<%=str.format2(""+totalLocalamount,d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>
	</tr>
	<tr>
		<td colspan=14> Narration <input type=text onfocus="this.select()" name=narration size=100 value="<%=narration%>" onBlur="narrationCall()">
		<input type=hidden name=narrationtemp value="">
	</tr>
	</table><br><br>
<TABLE borderColor=skyblue WIDTH="100%" align=center border=0  cellspacing=0 cellpadding=2>
	<tr>
		<td align=right>&nbsp; </td>
		<td align=right>
		Add&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=radio name=addType value="ledger" checked>Ledgers 
		<input type=hidden name=newLedgerRows value="0" > 
		
		<input type=radio name=addType value="lot">Lots </td>
		</td>
		<td width="5%">
		<input type=text onfocus="this.select()" name=addLotsLedgers size=2 value="0" onBlur="validate(this)" style="text-align:right" >
		</td>
		<td width="25%">
		<input type=submit name=command value=ADD class='button1'   onmouseover="this.className='button1_over';"  onmouseout="this.className='button1';" onClick='setbuttonValue("ADD")'> 
		</td>
		<input type=hidden name=button value="">
		<td width="25%">
		<input type=submit name=command  value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick='setbuttonValue("NEXT")'>
		</td>
	</tr>
</table>
		</center>
		</form>
		</body>
<script language="JavaScript">
		function narrationCall()
		{
			//alert("Function");
			//alert(document.mainform.narration.value);
			var str=new Array();
			var narration=document.mainform.narration.value;
			str=narration.split(" ");
			//alert(str);
			document.mainform.narrationtemp.value=str;
		}
</script>
		
	<%}//end..sedit
}// end flag..
	C.returnConnection(conp);
	C.returnConnection(cong);

}//try...
catch(Exception e)
{
	C.returnConnection(conp);
	C.returnConnection(cong);

	out.print("<br> Error Is occure at line No:"+ErrLine+" and Error -"+e);
}
%>