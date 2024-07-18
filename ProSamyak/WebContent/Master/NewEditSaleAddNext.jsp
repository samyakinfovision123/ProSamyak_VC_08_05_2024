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
	//out.print("<br> Welcome newIndiaEditAddNext Sale........");
	String Command=request.getParameter("command");
	//out.print("<br>57 Command"+Command);

	ErrLine="59";
	int oldLedgerRows =Integer.parseInt(request.getParameter("oldLedgerRows"));
	int counter=Integer.parseInt(request.getParameter("counter"));
	int tempcounter=Integer.parseInt(request.getParameter("tempcounter"));
	int tempOldLedgercounter=Integer.parseInt(request.getParameter("tempOldLedgercounter"));
	//out.print("<br> 61 oldLedgerRows"+oldLedgerRows);
	int newLedgerRows = 0;
	int newLotRows = 0;
	int lcounter=oldLedgerRows;
	ErrLine="63";
	String addType = request.getParameter("addType");
	if("ledger".equals(addType))
	{
		newLedgerRows = Integer.parseInt(request.getParameter("addLotsLedgers"));
		//out.print("<br>  73 newLedgerRows"+newLedgerRows);

	}
	ErrLine="71";
	if("lot".equals(addType))
	{
		newLotRows = Integer.parseInt(request.getParameter("addLotsLedgers"));
		//out.print("<br> 73 newLotRows"+newLotRows);

	}
	
		//out.print("<br> Under Add ");

		//Reading the data from the previous file

		String consignment_no = request.getParameter("consignment_no");
		
		String ref_no = request.getParameter("RefNo");
		String receive_id = request.getParameter("receive_id");
		//out.print("<br> 92 receive_id"+receive_id);
		String currency =request.getParameter("currency");
		//out.print("<br> currency"+currency);
		String Tempcurrency_id =request.getParameter("currency_id");
		int currency_id = Integer.parseInt(Tempcurrency_id);
		//out.print("<br> currency_id"+currency_id);
		String companyparty_name = request.getParameter("companyparty_name");
		
		String companyparty_id = request.getParameter("companyparty_id");
		//out.print("<br> companyparty_id"+companyparty_id);
		String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
		
		String datevalue = request.getParameter("datevalue");
		
		String duedays = request.getParameter("duedays");
		
		String duedate = request.getParameter("duedate");
		
		String purchase_type = request.getParameter("purchase_type");
		
		String location_id0 = request.getParameter("location_id0");
		//out.print("<br> location_id0"+location_id0);
		String category_id = request.getParameter("category_id");
		
		String exchange_rate = request.getParameter("exchange_rate");
		
		String salesperson_id = request.getParameter("salesperson_id");
		//out.print("<br>121  salesperson_id"+salesperson_id);
		String Broker_Id = request.getParameter("Broker_Id");
		//out.print("<br>121  broker_id"+Broker_Id);
		String broker_remarks = request.getParameter("broker_remarks");
		String ot_Id1=request.getParameter("OT_Id0");
		String new_sale1=request.getParameter("New_Sale0");

		String disloc="",disdol="",local_currencysymbol_Show="";
		String currencyCondition="";
		if("Dollar".equals(currency))
		{
			//currencyCondition="Dollar_Amount";
			disdol="checked";
			local_currencysymbol_Show="$";
		}
		else
		{
			//currencyCondition="Local_Amount";
			local_currencysymbol_Show=local_currencysymbol;
			disloc="checked";
		}

		int i=0,t=0,j=0;
		//Reading the data of the previous lots.
		int lotRows=counter;
		String originalQuantity[]=new String[counter];
		String returnQuantity[]=new String[counter];
		String ghat[]=new String[counter];
		String quantity[]=new String[counter];
		String rejection[] = new String[lotRows];
		String newrejection[] = new String[lotRows];
		String rejectionQty[] = new String[lotRows];
		String rate[] = new String[lotRows];
		String effrate[] = new String[lotRows];
		String localrate[] = new String[lotRows];
		String efflocalrate[] = new String[lotRows];
		String amount[] = new String[lotRows];
		String Localamount[] = new String[lotRows];
		//String amount[]=new String[counter];
		String lotDiscount[]=new String[counter];
		int ctax_amt=0,temp_amt=0,discount_amt=0;
		String remarks[]=new String[counter]; 
		String receivetransaction_id[]=new String[tempcounter]; 
		String lot_id[]=new String[counter]; 
		String location_id[]=new String[counter]; 
		String lot_no[]=new String[counter]; 
		String description[]=new String[counter]; 
		String size[]=new String[counter]; 
		String pcs[]=new String[counter];
		double calcqty[]=new double[counter]; 
		for(i=0;i<counter;i++)
		{
				lot_no[i]=request.getParameter("lotno"+i);
				description[i]=""+request.getParameter("description"+i);
				//out.print("<br> description"+description[i])
				lot_id[i]=""+request.getParameter("lot_id"+i);
				size[i]=""+request.getParameter("dsize"+i);

				originalQuantity[i]=request.getParameter("originalQuantity"+i);
				returnQuantity[i]=request.getParameter("returnQuantity"+i);
				ghat[i]=request.getParameter("ghat"+i);
				quantity[i]=request.getParameter("quantity"+i);
				rejection[i] = request.getParameter("rejection"+i);
				newrejection[i] = request.getParameter("newrejection"+i);
				rejectionQty[i] = request.getParameter("rejectionQty"+i);
				rate[i] = request.getParameter("rate"+i);
				//out.print("<br> 189 rate"+rate[i]);

				effrate[i] = request.getParameter("effrate"+i);
				//out.print("<br> 189 effrate"+effrate[i]);

				localrate[i] = request.getParameter("localrate"+i);
				//out.print("<br> 189 localrate"+localrate[i]);

				efflocalrate[i] = request.getParameter("efflocalrate"+i);
				//out.print("<br> 189 efflocalrate"+efflocalrate[i]);

				amount[i] = request.getParameter("amount"+i);
				Localamount[i] = request.getParameter("Localamount"+i);
				lotDiscount[i]=request.getParameter("lotDiscount"+i);
				remarks[i]=request.getParameter("remarks"+i);
				//out.print("<br> 189 remarks"+remarks[i]);

				lot_id[i]=request.getParameter("lotid"+i);
				
	
		}

		for(i=0;i<tempcounter;i++)
		{
			receivetransaction_id[i]=request.getParameter("receivetransaction_id"+i);

			//out.print("<br> 196 receivetransaction_id"+receivetransaction_id[i]);
				//out.print("<br> 189 lot_id"+lot_id[i]);

		}
		
		ErrLine="214";
		String DelLots[]= new String[tempcounter];
		String check="";
		if(counter > 1 )
		{
			for( i=0;i<tempcounter;i++)
			{
				DelLots[i]=request.getParameter("checkBox"+i);
				
			}
		}
		//String totalsquantity=
		double squantity=Double.parseDouble(request.getParameter("totalsquantity"));
		double InvTotalAmount=Double.parseDouble(request.getParameter("InvTotalAmount"));
ErrLine="231";
		double InvTotalLocalAmount=Double.parseDouble(request.getParameter("InvTotalLocalAmount"));
ErrLine="233";
		double TotalPT_DollarAmount=Double.parseDouble(request.getParameter("TotalPT_DollarAmount"));
ErrLine="234";
		double TotalPT_LocalAmount=Double.parseDouble(request.getParameter("TotalPT_LocalAmount"));
ErrLine="237";
		int PFlag=Integer.parseInt(request.getParameter("PFlag"));
ErrLine="239";

	String Narration=request.getParameter("narration");
	String NarrationTemp=request.getParameter("narrationtemp");
	if("ADD".equals(Command))
	{
		%><html>
		<head>
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

		function recalculateQty(rowNum)
		{
			//alert('alertcall');
			var orgQtyName = "originalQuantity"+rowNum;
			var retQtyName = "returnQuantity"+rowNum;
			var ghatName = "ghat"+rowNum;
			//var rejectQtyName = "rejectionQty"+rowNum;
			var qtyName = "quantity"+rowNum;
			var oldQty=document.mainform.elements[qtyName].value;
			var finalquantity = parseFloat(document.mainform.elements[orgQtyName].value) - parseFloat(document.mainform.elements[retQtyName].value) - parseFloat(document.mainform.elements[ghatName].value)
			
			if(finalquantity < 0)
			{
				alert("Quantity will be Negative for row:"+(parseInt(rowNum)+1));
				return false;
			}

			document.mainform.elements[qtyName].value = finalquantity.toFixed(3);

			var newtotalsquantity = document.mainform.totalsquantity.value - oldQty +finalquantity

			document.mainform.totalsquantity.value=newtotalsquantity.toFixed(3);
			return true;
		}

		</script>
		<script language="javascript">

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
		function changeCurrency()
		{
				document.mainform.currency.value='local';

				for(var i=0; i<<%=lotRows+newLotRows%>; i++)
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
					for(var i=0; i<<%=lotRows+newLotRows%>; i++)
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
				
				for(var z=0; z<<%=lotRows+newLotRows%>; z++)
				{
					if(!recalculateQty(z))
					{return false;}
				}
				var command=document.mainform.button.value;
			if(command == "NEXT")
			{
				if(!lotCheck())
				{
					return false;
				}
			}
				

		var TotalPT_DollarAmount=parseFloat(document.mainform.TotalPT_DollarAmount.value);

		var TotalPT_LocalAmount=parseFloat(document.mainform.TotalPT_LocalAmount.value);

//alert("TotalPT_LocalAmount"+TotalPT_LocalAmount);
//alert("TotalPT_DollarAmount"+TotalPT_DollarAmount);
		var totalAmount=parseFloat(document.mainform.totalamount.value);
		var totalLocalAmount=parseFloat(document.mainform.totalLocalamount.value);
	
		if(command == "NEXT")
		{
		if (document.mainform.currency[1].checked)
		{
			//alert("Undedr Dollar");
			if(totalAmount < TotalPT_DollarAmount)
			{
				alert("Sorry Invoice Amount is Less Than .. ");
				return false;
			}
			
		}
		else		
		{
			//alert("Under Local");
			//alert("totalLocalAmount"+totalLocalAmount);
			//alert("TotalPT_LocalAmount"+TotalPT_LocalAmount);

			if(totalLocalAmount < TotalPT_LocalAmount)
			{
				alert("Sorry Invoice Amount is Less Than .. ");
				return false;
			}
			
		}	
		}
			return true;

	}

	function lotCheck()
	{
	
		var flag=0;
		for(var z=0; z<<%=tempcounter%>; z++)
		{
			if(<%=lotRows+newLotRows %> > 1 && z < <%=tempcounter%>)
			{
				var a="checkBox"+z;
				if(document.mainform.elements[a].checked)
				{
					flag ++;
				}
			}
		
		}
	
	
		if(<%=lotRows+newLotRows %> > <%=tempcounter%>)
		{
			var bflag=0;
			if(flag == <%=tempcounter%>)
			{
				for(var z=<%=tempcounter%>; z<<%=lotRows+newLotRows %>; z++)
				{
					var lotid="lotid"+z;
					var lotidVal=document.mainform.elements[lotid].value;
					if(lotidVal == "")
					{
						bflag++;
					}
				
				}
				
			}
	
			var tempcount= <%=lotRows+newLotRows %> - <%=tempcounter%>;
			if (<%=tempcounter%> == flag && tempcount == bflag)
			{
				alert("You cant Delete all old..lots./ Plz insert value on New Lot..");
				return false;
			}
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


		</script>
		</head>
		<body background="../Buttons/BGCOLOR.JPG" >
		<form name=mainform action="NewEditSaleAddNext.jsp" method="post" onsubmit="return onSubmitValidateForm()">
			

			<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
				<tr>
					<th colspan=8 align=center>Edit Sale </th>
				</tr>	
			</table>
			<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
			<%
				ErrLine="258";
			%>
			<td >No :
				<input type=text name=consignment_no size=5 value="<%=consignment_no%>" readonly style="background:#CCCCFF">
			</td>
			<td >Ref No :
				<input type=text name=RefNo size=5 value="<%=ref_no%>">
			</td>
			<td >Currency :
				<input type=radio name=currency value="Local" <%=disloc%> onclick="changeCurrency();" >Local
				<input type=radio name=currency value="Dollar" <%=disdol%> onclick="changeCurrency();">Dollar
			</td>
			
			<td >To :
				<%if(PFlag ==1){ %>
				<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off readonly style="background:#CCCCFF">
				<%}else{%>
				<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
				<%}%>
				<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
				 <script language="javascript">
					var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
				</script>	
			</td>
		<td >Sale Group:</td>
			<td><%=AC.getMasterArrayCondition(cong,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%>
				
			</td>		
			
		</tr>
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		<td colspan=1>
		<script language='JavaScript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100'>")}
		</script>
		</td>
		<td>
			<input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>" OnKeyUp="checkMe(this);"></td>	
		<td colspan=1>Due Days</td>
		<td><input type=text name="duedays" value="<%=duedays%>"size=5 onBlur="return addDueDays(document.mainform.datevalue, 'Date', document.mainform.duedate, this);"></td>
		<td colspan=1>
			<script language='JavaScript'>
				if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.duedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ; width:100'>")}
			</script>
		</td>
		<td>
			<input type=text name='duedate' size=8 maxlength=10 	value="<%=duedate%>" OnKeyUp="checkMe(this)" onblur='calcDueDays()'></td>

		</tr>
		<tr>
			<td >Sales Type</td>
			<td>
				<select name=type style='width:100;font-size:12;'>
					<option value="0">Regular</option>
			</td>
			<td >Location </td>
			<td > 							
			<%if(counter != 0)
			{%>	<%=AC.getMasterArrayCondition(cong,"Location","masterlocation",location_id0,"where company_id="+company_id)%>
			<%}%>
			<input type=hidden name='location_id0' value="<%=location_id0%>" >
			</td>
			<td >Category</td>
			<td>
				<%=AC.getArrayConditionAll(cong,"Master_LotCategory","category_id","","where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
			</td>
				
		</tr>
			<tr>
			<td >Exchange Rate</td>
			<td><input type=text name=exchange_rate  value="<%=str.format(exchange_rate)%>" onBlur="validate(this,2)"  size=4 style="text-align:right"></td>
			<td>&nbsp;</td>
			
			<td >Sales Person </td>
			<td><%=AC.getMasterArrayCondition(cong,"SalesPerson","salesperson_id",salesperson_id,"where Active=1 and company_id="+company_id+"") %></td>
			<td>Broker</td>
			<td>	<%=AC.getMasterArrayCondition(cong,"SalesPerson","Broker_Id",""+Broker_Id,"where PurchaseSale=2 and Active=1 and company_id="+company_id+"")%>
			</td>
		</tr>	
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
	<tr>
		<td>Sr No/Delete</td>
		<td>Lot No</td>
		<td>Desc</td>
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
	<%for(i=0;i<lotRows;i++)
	{  t=i; t++;%>
	<tr>
		<% if(lotRows+newLotRows >1 && i < tempcounter )
		{		
			if(DelLots[i] == null)
			{
			%>		
				<td><%=t%>&nbsp;&nbsp;<input type=checkbox name=checkBox<%=i%> onClick="mecall(<%=i%>)"></td>
			<%}else{%>
				<td><%=t%>&nbsp;&nbsp;<input type=checkbox name=checkBox<%=i%> checked onClick="mecall(<%=i%>)"></td>	
		<%}
		}else{%><td><%=t%></td><%}%>
		<td><input type=text name=lotno<%=i%> id=newlotno<%=i%> autocomplete=off value="<%=lot_no[i]%>" size=7 style="text-align:right" onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'sale' ); " autocomplete=off onfocus="this.select()" ></td>
		<td><input type=text  name=description<%=i%> size=4 value="<%=description[i]%>" style="text-align:left" id=description<%=i%> autocomplete=off onfocus="this.select()" ></td>
		<td><input type=text  name=dsize<%=i%> size=4 value="<%=size[i]%>"  style="text-align:left" id=dsize<%=i%> autocomplete=off onfocus="this.select()">
		<td><input type=text name=originalQuantity<%=i%> value="<%=originalQuantity[i]%>"  size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<td><input type=text name=returnQuantity<%=i%> value="<%=returnQuantity[i]%>"  size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<td><input type=text name=ghat<%=i%> value="<%=str.mathformat(""+ghat[i],3)%>" size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<input type=hidden name=rejection<%=i%> value="<%=rejection[i]%>" onBlur="nochk(this,3)" >
		<input type=hidden name=newrejection<%=i%> value="<%=newrejection[i]%>" >
		<input type=hidden name=rejectionQty<%=i%> value="<%=rejectionQty[i]%>">
		<td><input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 style="text-align:right;background:#CCCCFF"></td>
		<!-- Add -->
		<td><input type=hidden name=rate<%=i%> size=7 value="<%=str.format1(rate[i], 3)%>"  style="text-align:right" id=rate<%=i%>>
		
		<input type=text onfocus="this.select()" size=5 name=effrate<%=i%> value="<%=str.format1(effrate[i], 3)%>"  style="text-align:right" onBlur="calculateEffRate('<%=i%>')" id=effrate<%=i%> <%if(currency_id != 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<td>
		<input type=hidden name=localrate<%=i%> value="<%=str.mathformat1(localrate[i],3)%>"  style="text-align:right" id=localrate<%=i%>>
		
		<input type=text onfocus="this.select()" name=efflocalrate<%=i%> value="<%=str.mathformat1(efflocalrate[i],3)%>"  style="text-align:right" size=7 id=efflocalrate<%=i%> onBlur="calculateEffLocalRate('<%=i%>')"
		<%if(currency_id == 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<!-- end -->
		<td><input type=text name=amount<%=i%> value="<%=str.mathformat1(""+amount[i],d)%>" size=7 style="text-align:right;background:#CCCCFF""></td>

		<td><input type=text name=Localamount<%=i%> value="<%=str.mathformat1(""+Localamount[i],d)%>" size=7 style="text-align:right;background:#CCCCFF"></td>

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
		<td>
			<input type=text name=remarks<%=i%>		value="<%=remarks[i]%>" size=7 style="text-align:right"></td> 
	</tr>

	
	<input type=hidden name=lotid<%=i%> value="<%=lot_id[i]%>">
	<!-- <input type=hidden name=lotno<%//=i%> value="<%//=lot_no[i]%>"> -->
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
	
<%}
		for(i=0;i<tempcounter;i++)
		{%>
			<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
		<%}
	for(i=lotRows;i<lotRows+newLotRows;i++)
	{
		t=i;t++;%><input type=hidden name=lotid<%=i%> value="" id=lotid<%=i%>>
		<% if(lotRows+newLotRows >1 )
		{%>
		<td><%=t%></td>
		<%}else{%><td><%=t%></td><%}%>
		
		<td><input type=text name=lotno<%=i%> id=lotno<%=i%> autocomplete=off value="" size=7 style="text-align:right" onblur="getDescSize('<%=company_id%>', document.mainform.lotno<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'sale' );" onfocus="this.select()" autocomplete=off></td>
		<td><input type=text  name=description<%=i%> size=4 value="" style="text-align:left" id=description<%=i%> autocomplete=off onfocus="this.select()" ></td>

		<td><input type=text  name=dsize<%=i%> size=4 value=""  style="text-align:left" id=dsize<%=i%> autocomplete=off onfocus="this.select()" onblur="getLots('<%=company_id%>', document.mainform.description<%=i%>.value, document.mainform.dsize<%=i%>.value, document.mainform.datevalue.value, 'lotid<%=i%>','lotno<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'sale' ); "></td>

		<td><input type=text name=originalQuantity<%=i%> value="0"  size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<td><input type=text name=returnQuantity<%=i%> value="0"  size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<td><input type=text name=ghat<%=i%> value="0" size=5 style="text-align:right" onBlur="return recalculateQty('<%=i%>')"></td>
		<input type=hidden name=rejection<%=i%> value="0>"  >
		<input type=hidden name=newrejection<%=i%> value="0" >
		<input type=hidden name=rejectionQty<%=i%> value="0">
		<td><input type=text name=quantity<%=i%> value="0" size=5 style="text-align:right;background:#CCCCFF"></td>
		<!-- Add -->
		<td>
			<input type=hidden name=rate<%=i%> size=7 value="1"  style="text-align:right" id=rate<%=i%>>
		
		<input type=text onfocus="this.select()" size=5 name=effrate<%=i%> value="1"  style="text-align:right" onBlur="calculateEffRate('<%=i%>')" id=effrate<%=i%> <%if(currency_id != 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<td>
		<input type=hidden name=localrate<%=i%> value="<%=1%>"  style="text-align:right" id=localrate<%=i%>>
		
		<input type=text onfocus="this.select()" name=efflocalrate<%=i%> value="<%=1%>"  style="text-align:right" size=7 id=efflocalrate<%=i%> onBlur="calculateEffLocalRate('<%=i%>')"
		<%if(currency_id == 0)
		{out.print("style=\"background:#CCCCFF\" readonly");}%>>
		</td>
		<!-- End -->
		<td><input type=text name=amount<%=i%> value="<%=0%>" size=7 style="text-align:right;background:#CCCCFF""></td>

		<td><input type=text name=Localamount<%=i%> value="<%=0%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name=lotDiscount<%=i%> value="" size=7 style="text-align:left" onBlur="checkDiscount(this);<%
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
		<td><input type=text value="" size=7 style="text-align:right" name=remarks<%=i%>></td> 
	</tr>
	<script language="javascript">
		//alert('lotno');
		var lobj<%=i%> = new  actb(document.getElementById('lotno<%=i%>'), lotNoArray);
		//alert('desc');
		var dobj<%=i%> = new  actb(document.getElementById('description<%=i%>'), descArray);
		//alert('size');
		var sobj<%=i%> = new  actb(document.getElementById('dsize<%=i%>'), sizeArray);
		
	</script>
		
<%	}

counter=lotRows+newLotRows;
lcounter=oldLedgerRows+newLedgerRows;
%>
	<input type=hidden name=receive_id value="<%=receive_id%>">
	<input type=hidden name=currency_id value="<%=currency_id%>">
	<input type=hidden name=counter value="<%=counter%>">
	<input type=hidden name=tempcounter value="<%=tempcounter%>">
	<input type=hidden name=tempOldLedgercounter value="<%=tempOldLedgercounter%>">
	<input type=hidden name=oldLedgerRows value="<%=lcounter%>">
	<input type=hidden name=lcounter value="<%=lcounter%>">
<input type=hidden name=PFlag value="<%=PFlag%>">
<tr>
		<td colspan=7>Inventory Total </td>
		<td><input type=text name="totalsquantity" value="<%=squantity%>" size=5 style="text-align:right;background:#CCCCFF"></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><input type=text name="InvTotalAmount" value="<%=InvTotalAmount%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name="InvTotalLocalAmount" value="<%=InvTotalLocalAmount%>" size=7 style="text-align:right;background:#CCCCFF"></td>
	</tr>
		

	<% String ledger[]=new String[oldLedgerRows];
	   String Lamount[]=new String[oldLedgerRows];
	   String LocalLamount[]=new String[oldLedgerRows];
	   String debitcredit[]=new String[oldLedgerRows];
	   String ledgerPercentage[]=new String[oldLedgerRows];
	   String Transaction_Id[]=new String[tempOldLedgercounter];
	   String DelLedger[]=new String[tempOldLedgercounter];
 for( j=0;j<tempOldLedgercounter;j++)
{
	Transaction_Id[j]=request.getParameter("Transaction_Id"+j);
	DelLedger[j]=request.getParameter("delLedger"+j);
	%>
		<input type=hidden name=Transaction_Id<%=j%>  value=<%=Transaction_Id[j]%> >
	<%
}
int lflag=0;
for( j=0;j<oldLedgerRows;j++)
{
		ledger[j]=request.getParameter("ledger"+j);
		ledgerPercentage[j]=request.getParameter("ledgerPercent"+j);
		Lamount[j]=request.getParameter("Lamount"+j);
		LocalLamount[j]=request.getParameter("LocalLamount"+j);
		debitcredit[j]=request.getParameter("debitcredit"+j);

	if(j<tempOldLedgercounter)
	{
		if(ledger[j].equals("1071"))
		{lflag=1;}
		if(ledger[j].equals("2003") && lflag == 1)
		{ lflag=0; %>
 			<tr>
				<td colspan=5 align=right>
				<font color=#FF3333>Delete </font><input type=checkBox name=delLedger<%=j%> onClick="LedgerCalculation(<%=j%>)">
				</td>
				<td colspan=4 align=right>
				<%=A.getArray(cong,"Ledger","ledger"+j,ledger[j],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td>
				<input type=text name=ledgerPercent<%=j%> value="<%=ledgerPercentage[j]%>" size=7 style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">%</td>
			<td>
				<input type=text  size=7 name=Lamount<%=j%> value="<%=Lamount[j]%>"  style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">
			</td>
			<td>
				<input type=text  size=7 name=LocalLamount<%=j%> value="<%=LocalLamount[j]%>"  style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">
			</td>
			<%if("-1".equals(debitcredit[j])) {%>
				<td>
					<select name= "debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)" >
						<option value="-1" selected>Dr</option>
						<option value="1">Cr</option>
					</select>
				</td>
			<%} else { %>
					<td>
						<select name="debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)">
							<option value="-1">Dr</option>
							<option value="1" selected>Cr</option>
						</select>
					</td>
					<%}%>
			</tr>

			<%}
		else{%>
		<tr>
			<td colspan=5 align=right>
				<font color=#FF3333>Delete </font><input type=checkBox name=delLedger<%=j%> onClick="LedgerCalculation(<%=j%>)">
			</td>
			<td colspan=4 align=right><%=A.getArray(cong,"Ledger","ledger"+j,ledger[j],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
			<td><input type=text name=ledgerPercent<%=j%> value="<%=ledgerPercentage[j]%>" size=7 style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">%</td>
			<td>
			<input type=text  size=7 name=Lamount<%=j%> value="<%=Lamount[j]%>"  style="text-align:right" onBlur="ledgerAmountChanged(<%=j%>)">
			</td>
			<td>
			<input type=text  size=7 name=LocalLamount<%=j%> value="<%=LocalLamount[j]%>"  style="text-align:right" onBlur="ledgerLocalAmountChanged(<%=j%>)">
			</td>
			<%if("-1".equals(debitcredit[j])) {%>
			<td>
			<select name= "debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)" >
				<option value="-1" selected>Dr</option>
				<option value="1">Cr</option>
			</select>
			</td>
		<%} else { %>
			<td>
				<select name="debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)">
					<option value="-1">Dr</option>
					<option value="1" selected>Cr</option>
				</select>
			</td>
			<%}%>
		
	</tr>
		<%	}

			
		}else{%>
	<tr>
		
		<td colspan=9 align=right><%=A.getArray(cong,"Ledger","ledger"+j,ledger[j],company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
		<td><input type=text name=ledgerPercent<%=j%> value="<%=ledgerPercentage[j]%>" size=7 style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">%</td>
		<td>
			<input type=text  size=7 name=Lamount<%=j%> value="<%=Lamount[j]%>"  style="text-align:right" onBlur="ledgerAmountChanged(<%=j%>)">
		</td>
		<td>
			<input type=text  size=7 name=LocalLamount<%=j%> value="<%=LocalLamount[j]%>"  style="text-align:right" onBlur="ledgerLocalAmountChanged(<%=j%>)">
		</td>
		<%if("-1".equals(debitcredit[j])) {%>
		<td>
			<select name= "debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)" >
				<option value="-1" selected>Dr</option>
				<option value="1">Cr</option>
			</select>
		</td>
		<%} else { %>
			<td>
				<select name="debitcredit<%=j%>" onchange="percentLedgerChanged(<%=j%>)">
					<option value="-1">Dr</option>
					<option value="1" selected>Cr</option>
				</select>
			</td>
			<%}%>
		
	</tr>
	
	<%}
	}
	for(j=oldLedgerRows;j<oldLedgerRows+newLedgerRows;j++)
	{%>
		<td colspan=9 align=right><%=A.getArray(cong,"Ledger","ledger"+j,"",company_id+" and Ledger_Name <> 'C. Tax' and yearend_id="+yearend_id ,"Ledger") %></td>
		<td><input type=text name=ledgerPercent<%=j%> value="0" size=7 style="text-align:right" onBlur="percentLedgerChanged(<%=j%>)">%</td>
		<td>
			<input type=text onfocus="this.select()" size=7 name=Lamount<%=j%> value="0"  style="text-align:right" onBlur="ledgerAmountChanged(<%=j%>)">
		</td>
		<td>
			<input type=text onfocus="this.select()" size=7 name=LocalLamount<%=j%> value="0"  style="text-align:right" onBlur="ledgerLocalAmountChanged(<%=j%>)">
		</td>
		<td>
			<select name= "debitcredit<%=j%>" onChange="percentLedgerChanged(<%=j%>)">
				<%String Dr="",Cr="";%>
				<option value="1">Cr</option>
				<option value="-1">Dr</option>
			
			</select>
		</td>
	</tr>
	<%}
		double totalamount=Double.parseDouble(request.getParameter("totalamount"));
		double totalLocalamount=Double.parseDouble(request.getParameter("totalLocalamount"));
	%>
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
					InvLocaltotal =InvLocaltotal + LedgerAmount;
					Invtotal =Invtotal + LedgerAmount1;
					
				}else
				{
					InvLocaltotal =InvLocaltotal - LedgerAmount;
					Invtotal =Invtotal - LedgerAmount1;
				}
			
			}
			var tempInvTotal=Invtotal;
			for(i=rowNum;i<<%=(oldLedgerRows+newLedgerRows)%>;i++)
			{
				LrPercentage="ledgerPercent"+i;
				DebCre="debitcredit"+i;
				LrAmount="Lamount"+i;
				LrLocalAmount="LocalLamount"+i;
				ledger="ledger"+i;
				ledgerId=document.mainform.elements[ledger].value;	DebCreValue=document.mainform.elements[DebCre].value;
				 LedgerPercentage=parseFloat(document.mainform.elements[LrPercentage].value);
				if(ledgerId == 2003 )
				{
					var PerAmount= (LedgerPercentage * InvLocaltotal)/(100 - LedgerPercentage)
					var PerAmount1=(LedgerPercentage * Invtotal) / (100 - LedgerPercentage )
					//alert(" Vattav called after insurance..");

				}else
				{
					var PerAmount=(LedgerPercentage /100) * InvLocaltotal;
					var PerAmount1=(LedgerPercentage /100) * Invtotal;
										
				}
				document.mainform.elements[LrLocalAmount].value=PerAmount.toFixed(3);
				document.mainform.elements[LrAmount].value=PerAmount1.toFixed(3);
				//document.mainform.elements[LrAmount].value=.toFixed(3);

				if(DebCreValue == 1)
				{
					InvLocaltotal =InvLocaltotal + PerAmount;
					Invtotal =Invtotal + PerAmount1;
				}
				else
				{
					InvLocaltotal =InvLocaltotal - PerAmount;
					Invtotal =Invtotal - PerAmount1;
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
					Invtotal =Invtotal + LedgerAmount;
					InvLocaltotal =InvLocaltotal + LedgerLocalAmount;
				}else
				{
					Invtotal =Invtotal - LedgerAmount;
					InvLocaltotal =InvLocaltotal - LedgerLocalAmount;
				}
			
			}
			
			for(i=rowNum;i<<%=(oldLedgerRows+newLedgerRows)%>;i++)
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
				document.mainform.elements[LrPercentage].value=LedgerPercentage.toFixed(2);
				
				LedgerPercentageValue =parseFloat( ( LedgerPercentage/ 100) * InvLocaltotal)

				//alert(LedgerPercentageValue);
				document.mainform.elements[LrLocalAmount].value=LedgerPercentageValue.toFixed(3);

				LAmountLocalValue=parseFloat(document.mainform.elements[LrLocalAmount].value);

				if(DebCreValue == 1)
				{
					Invtotal =Invtotal + LAmountValue;
					InvLocaltotal =InvLocaltotal + LAmountLocalValue;
				}
				else
				{
					Invtotal =Invtotal - LAmountValue;
					InvLocaltotal =InvLocaltotal - LAmountLocalValue;
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
					Invtotal =Invtotal + LedgerAmount;
					InvLocaltotal =InvLocaltotal + LedgerLocalAmount;
				}else
				{
					Invtotal =Invtotal - LedgerAmount;
					InvLocaltotal =InvLocaltotal - LedgerLocalAmount;
				}
			
			}
			var tempInvTotal=Invtotal;
			for(i=rowNum;i<<%=(oldLedgerRows+newLedgerRows)%>;i++)
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
				document.mainform.elements[LrPercentage].value=LedgerPercentage.toFixed(2);
				
				LedgerPercentageValue =parseFloat( ( LedgerPercentage/ 100) * Invtotal)

				//alert(LedgerPercentageValue);
				document.mainform.elements[LrAmount].value=LedgerPercentageValue.toFixed(3);

				LAmountValue=parseFloat(document.mainform.elements[LrAmount].value);

				if(DebCreValue == 1)
				{
					Invtotal =Invtotal + LAmountValue;
					InvLocaltotal =InvLocaltotal + LAmountLocalValue;
				}
				else
				{
					Invtotal =Invtotal - LAmountValue;
					InvLocaltotal =InvLocaltotal - LAmountLocalValue;
				}
				document.mainform.totalamount.value=Invtotal.toFixed(3);
				document.mainform.totalLocalamount.value=InvLocaltotal.toFixed(3);
			
			}

		}
		function setbuttonValue(v1)
		{document.mainform.button.value=v1;}
		
		function narrationCall()
		{
			var str=new Array();
			var narration=document.mainform.narration.value;
			str=narration.split(" ");
			document.mainform.narrationtemp.value=str;
		}
	</script>
		<input type=hidden name=counter value="<%=counter%>">
		<input type=hidden name=oldLotRows value="<%=counter%>">
		<input type=hidden name=oldLedgerRows value="<%=lcounter%>">
		<input type=hidden name=TotalPT_DollarAmount value="<%=TotalPT_DollarAmount%>">
		<input type=hidden name=TotalPT_LocalAmount value="<%=TotalPT_LocalAmount%>">
		<input type=hidden name=lcounter value="<%=lcounter%>">
	<tr>
		<td colspan=10>Total </td>
		<td><input type=text name=totalamount value="<%=totalamount%>" size=7 style="text-align:right;background:#CCCCFF"></td>
		<td><input type=text name=totalLocalamount value="<%=totalLocalamount%>" size=7 style="text-align:right;background:#CCCCFF"></td>
	</tr>
	<tr>
		<td colspan=14> Narration <input type=text onfocus="this.select()" name=narration size=100 value="<%=Narration%>" onBlur="narrationCall()">
		<input type=hidden name=narrationtemp value=<%=NarrationTemp%>>
	</tr>
	</table><br><br>
		<TABLE borderColor=skyblue WIDTH="100%" align=center border=0  cellspacing=0 cellpadding=2>
	<tr>
			<td><input type=button name=command value=BACK class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="history.go(-1);">
		</td>
		<td align=right>&nbsp; </td>
		<td align=right>
		Add&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=radio name=addType value="ledger" checked>Ledgers 
		
		<input type=radio name=addType value="lot">Lots </td>
		</td>
		<td width="5%">
		<input type=text onfocus="this.select()" name=addLotsLedgers size=2 value="1" onBlur="validate(this)" style="text-align:right" >
		<input type=hidden name=button value="">
		</td>
		<td width="25%">
		<input type=submit name=command value=ADD class='button1'   onmouseover="this.className='button1_over';"  onmouseout="this.className='button1';" onClick='setbuttonValue("ADD")'> 
		</td>
		<td width="25%">
		<input type=submit name=command  value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick='setbuttonValue("NEXT")'>
		</td>
	</tr>
</table>
	</body>
	</html>
	<%
	}//end ADD..Here
//-----------------------------------------------------------------//
	if("NEXT".equals(Command))
	{
		//int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currencyid));

		//out.print("<br> Next Command");
		ErrLine="1162";
		int oldCounter=Integer.parseInt(request.getParameter("counter"));
		int oldedgerRows=Integer.parseInt(request.getParameter("oldLedgerRows"));
		int invalidLots = 0;
		int blankLots = 0;
		//out.print("<br>  706 oldCounter"+oldCounter);
		//out.print("<br>  707 oldedgerRows"+oldedgerRows);
		double TotalAmount=Double.parseDouble(request.getParameter("totalamount"));
		double TotalLocalAmount=Double.parseDouble(request.getParameter("totalLocalamount"));
		//String Narration=request.getParameter("narration");

		%>
		<html>
		<head>
		</head>			
		<body background="../Buttons/BGCOLOR.JPG" >
		<form name=mainform action="NewEditSaleUpdate.jsp" method="post">
			
		<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		<th colspan=8 align=center>Edit Sale - Invoice </th>
		</tr>	
		</table>
		<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		</tr>
			<td >No : </td><td><%=consignment_no%></td>
			<input type=hidden  name=purchase_no value=<%=consignment_no%> >

			<td >Ref No :</td><td><%=ref_no%></td>
			<input type=hidden  name=ref_no value=<%=ref_no%> >
			<td >Currency :</td><td>
			<%if("Dollar".equals(currency))
			{%><input type=hidden name=currency value="Dollar">Dollar
			<%}else{%>
				<input type=hidden name=currency value="Local"> Local
			<%}%>	
			</td>
			<td >Sale Group: </td><td>
			<%=A.getName(cong,"PurchaseSaleGroup",purchasesalegroup_id)%>	
			<input type=hidden name=purchasesalegroup_id value="<%=purchasesalegroup_id%>">
			</td>	
				
			</td>
			<td >To :</td>
			<td><%=companyparty_name%>
			<input type=hidden name=companyparty_name value="<%=companyparty_name%>" id=companyparty_name>
			</td>
			
	</tr>
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
		<tr>
		<td colspan=1> Invoice Date :</td>
		<td colspan=1><%=datevalue%></td>
		<input type=hidden name='datevalue' value="<%=format.format(format.getDate(datevalue))%>">		
		<td colspan=1>Due Days</td>
		<td colspan=1><%=duedays%>
		<input type=hidden name='duedays' value="<%=duedays%>"></td>
		<td colspan=1>Due Date	</td>
		<td><%=duedate%> <input type=hidden name='duedate' value="<%=format.format(format.getDate(duedate))%>" >
		</td>
	</tr>
	<tr>
		<td >Sales Type :</td>
		<td >Regular</td>
		<td >Location </td>
		<td> 							
			<%if(counter != 0)
			{%>	<%=A.getName(cong,"Location",location_id0)%>	
				<input type=hidden name='location_id0' value="<%=location_id0%>" >
			<%}%>
		</td>
		<td >Category :</td>
		<td colspan=3>
			<%=A.getName(cong,"LotCategory",category_id)%>	
			<input type=hidden name='category_id' value="<%=category_id%>">
		</td>
		<td>&nbsp;</td>		
	</tr>
	<tr>
			<td >Exchange Rate </td>
			<td ><%=str.mathformat(exchange_rate,3)%>
			<input type=hidden name=exchange_rate  value="<%=str.mathformat(exchange_rate,3)%>" >
			</td>
			<td>&nbsp;</td>
			
			<td >Sale Person  </td>
			<td colspan=>
			<%=A.getName(cong,"SalesPerson",salesperson_id)%></td>
			<input type=hidden name='purchaseperson_id' value="<%=salesperson_id%>" >
			<td >Broker  </td>
			<td colspan=>
			<%=A.getName(cong,"SalesPerson",Broker_Id)%></td>
			<input type=hidden name='Broker_Id' value="<%=Broker_Id%>" >
	</tr>	
	</table>
	<TABLE borderColor=skyblue WIDTH="100%" align=center border=1  cellspacing=0 cellpadding=2>
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
		<%ErrLine="1276";
		for(i=0;i<oldCounter;i++)
		{  t=i; t++;
			if("".equals(lot_id[i]))
			{
				blankLots++;
				continue;
			}
			if(i<tempcounter && oldCounter > 1)
			{
				
				if( DelLots[i] == null )
				{%>	<input type=hidden name=checkBox<%=i%>><tr><%
					;}
				else{%>
					<input type=hidden name=checkBox<%=i%> value="Delete">
						<tr bgColor=#FFCCFF>
					<%}%>
				
			<%}else{%><tr><%}%>
			<td align=center><%=t%></td>
			<td align=right><%=lot_no[i]%>
				<input type=hidden name=lotno<%=i%> id=newlotno<%=i%>  value="<%=lot_no[i]%>" size=7 ></td>
			<td align=right><%=description[i]%>
				<input type=hidden  name=description<%=i%> size=7 value="<%=description[i]%>" id=description<%=i%>></td>
			<td align=right><%=size[i]%>
				<input type=hidden  name=dsize<%=i%> value="<%=size[i]%>" id=dsize<%=i%> ></td>
			<td align=right><%=originalQuantity[i]%>
				<input type=hidden name=originalQuantity<%=i%> value="<%=originalQuantity[i]%>"></td>
			<td align=right><%=returnQuantity[i]%>
				<input type=hidden name=returnQuantity<%=i%> value="<%=returnQuantity[i]%>"></td>
			<td align=right><%=str.mathformat(""+ghat[i],3)%>
				<input type=hidden name=ghat<%=i%> value="<%=str.mathformat(""+ghat[i],3)%>"></td>
			<td align=right><%=quantity[i]%>
				<input type=hidden name=quantity<%=i%> value="<%=quantity[i]%>"  ></td>
				<input type=hidden name=rejection<%=i%> value="<%=rejection[i]%>"  >
				<input type=hidden name=newrejection<%=i%> value="<%=newrejection[i]%>" >
				<input type=hidden name=rejectionQty<%=i%> value="<%=rejectionQty[i]%>">
			
			<!-- New -->
			<td align=right><%=effrate[i]%>
				<input type=hidden name=rate<%=i%>  value="<%=rate[i]%>" style="text-align:right" id=rate<%=i%>>
				<input type=hidden name=effrate<%=i%> value="<%=effrate[i]%>"  id=effrate<%=i%>></td>
				<%//out.print("<br> rate"+rate[i]+"effrate"+effrate[i]);%>
			<td align=right><%=efflocalrate[i]%>
				<input type=hidden name=localrate<%=i%> value="<%=localrate[i]%>"  style="text-align:right" id=localrate<%=i%>>
				<input type=hidden name=efflocalrate<%=i%> value="<%=efflocalrate[i]%>" 
				style="text-align:right" id=efflocalrate<%=i%>></td>
				<%//out.print("<br> localrate"+localrate[i]+"efflocalrate"+efflocalrate[i]);%>
			<td align=right><%=amount[i]%>
				<input type=hidden name=amount<%=i%> size=7 value="<%=amount[i]%>" ></td>
			<td align=right><%=Localamount[i]%>
				<input type=hidden name=Localamount<%=i%>  value="<%=Localamount[i]%>" ></td>
			<!-- End -->

			<td align=left><%=lotDiscount[i]%>
				<input type=hidden name=lotDiscount<%=i%> value="<%=lotDiscount[i]%>"></td>
			<td align=right><%=remarks[i]%><input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>"></td> 

			<input type=hidden name=lot_id<%=i%> value=<%=lot_id[i]%>>
			<% //out.print("<br> lot_id"+lot_id[i]);%>
		</tr>	
		
		<% 
		}
		ErrLine="1339";
		for(i=0;i<tempcounter;i++)
		{%>
			<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
		<%}
		%>	
		
					<tr>
				<td colspan=7>Inventory Total </td>
				<td align=right><%=squantity%><input type=hidden name="totalsquantity" value="<%=squantity%>"></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align=right> <%=InvTotalAmount%><input type=hidden name="InvTotalAmount" value="<%=InvTotalAmount%>" ></td>
				<td align=right> <%=InvTotalLocalAmount%><input type=hidden name="InvTotalLocalAmount" value="<%=InvTotalLocalAmount%>" ></td>
				<td>&nbsp;</td>
		</tr>
		<input type=hidden name=oldLedgerRows value=<%=oldLedgerRows%>>	
		<%ErrLine="1706";

			String ledger[]=new String[oldLedgerRows];
		    String Lamount[]=new String[oldLedgerRows];
		    String LocalLamount[]=new String[oldLedgerRows];
		    String debitcredit[]=new String[oldLedgerRows];
		    String ledgerPercentage[]=new String[oldLedgerRows];
		    String Transaction_Id[]=new String[tempOldLedgercounter];
		   String DelLedger[]=new String[tempOldLedgercounter];
		//out.print("<br> oldLedgerRows"+oldLedgerRows);
	 for( j=0;j<tempOldLedgercounter;j++)
	{
		Transaction_Id[j]=request.getParameter("Transaction_Id"+j);
		DelLedger[j]=request.getParameter("delLedger"+j);
		//System.out.println(" 1720 DelLedger[j]"+DelLedger[j]);
		%>
			<input type=hidden name=Transaction_Id<%=j%>  value=<%=Transaction_Id[j]%> >
			<input type=hidden name=delLedger<%=j%>  value=<%=DelLedger[j]%> >
		<%
	}
		ErrLine="1725";
		//System.out.println(" 1727 oldLedgerRows"+oldLedgerRows);
		 	for( j=0;j<oldLedgerRows;j++)
		 	{
					ledger[j]=request.getParameter("ledger"+j);
					
					ledgerPercentage[j]=request.getParameter("ledgerPercent"+j);
					Lamount[j]=request.getParameter("Lamount"+j);
					LocalLamount[j]=request.getParameter("LocalLamount"+j);
					debitcredit[j]=request.getParameter("debitcredit"+j); 
				
			//System.out.println(" 1737 ledger[j]"+ledger[j]);
			if(j< tempOldLedgercounter)
			{
				if(DelLedger[j] == null)
				{
				%><tr>
				
			  <%}else{%> <tr bgColor=#FFCCFF><%}
			}else{%><tr><%}
			%>

			<td colspan=9 align=right>
				<input type=hidden name="ledger<%=j%>" value="<%=ledger[j]%>">
				<%=A.getNameCondition(cong,"Ledger","Ledger_Name", " Where ledger_Id="+ledger[j]+" and yearend_id="+yearend_id+" And company_id="+company_id) %></td>
			<td align=right><%=ledgerPercentage[j]%> %
				<input type=hidden name=ledgerPercent<%=j%> value="<%=ledgerPercentage[j]%>"></td>
			<td align=right><%=Lamount[j]%>
				<input type=hidden name=Lamount<%=j%> value="<%=Lamount[j]%>" ></td>
			<td align=right><%=LocalLamount[j]%>
				<input type=hidden name=LocalLamount<%=j%> value="<%=LocalLamount[j]%>" ></td>

				<input type=hidden name=debitcredit<%=j%> value="<%=debitcredit[j]%>" >
			<%if("1".equals(debitcredit[j]))
				{%>
					<td>Cr</td>
				<%} else { %>
					<td>Dr</td>
				<%}%>
		</tr>
		
			<%}	
			oldCounter = oldCounter - blankLots;
			ErrLine="1402";
			%>
			
		<input type=hidden name=receive_id value="<%=receive_id%>">
		<input type=hidden name=counter value="<%=oldCounter%>">
		<input type=hidden name=tempcounter value="<%=tempcounter%>">
		<input type=hidden name=tempOldLedgercounter value="<%=tempOldLedgercounter%>">
		<input type=hidden name=oldLotRows value="<%=oldCounter%>">
		<input type=hidden name=oldLedgerRows value="<%=oldLedgerRows%>">
	<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
		<input type=hidden name=lcounter value="<%=oldLedgerRows%>">
		<tr>
			<td colspan=10 align=right>Total Amount :</td>
			<td align=right><%=TotalAmount%>
				<input type=hidden name="totalamount" value=<%=TotalAmount%>></td>
			<td align=right><%=TotalLocalAmount%>
				<input type=hidden name="totalLocalamount" value=<%=TotalLocalAmount%>></td>
		</tr>
		<tr>
			<td>Narration : </td>
			<td ><%=Narration%><input type=hidden name=narration value=<%=Narration%>> </td>
			<input type=hidden name=NarrationTemp value=<%=NarrationTemp%>> 
		</tr>
		
		</table>
			<br><br>
			<TABLE borderColor=skyblue WIDTH="100%" align=center border=0  cellspacing=0 cellpadding=2>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type=button name=command value=BACK class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="history.go(-1);">
			</td>
		
			<td>	<input type=submit name=command  value=SAVE class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" >
				</td>
		</table>	

		</form>
		</body>
		</html>
		<%
		

	}//end ..Next
	
	C.returnConnection(conp);
	C.returnConnection(cong);

}
catch(Exception e)
{
	C.returnConnection(conp);
	C.returnConnection(cong);
	out.print("<br> Error is occure at Line"+ErrLine+"Message "+e);
}

	%>
