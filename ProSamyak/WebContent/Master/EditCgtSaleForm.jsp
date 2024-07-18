<!--            Modified By=>Dattatraya 
				Date=>30/12/2005
				Add/Modify Funtions=>
					 calcTotal(),finalTotal(),calcLedgerRow(),
					 calcDebitCredit(), CtaxCal()
-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="I"    class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
 try	{
	conp=C.getConnection();
	cong=C.getConnection();
	}
catch(Exception e31)
	{ 
	out.println("<font color=red> FileName : EditSale.jsp<br>Bug No e31 : "+ e31);
	}

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
 //out.print("<br><center><font color=red>command=" +command+"</font></center>");
C.returnConnection(conp);
C.returnConnection(cong);

%>



<%
try{

if("CgtSaleEdit".equals(command))
{

	conp=C.getConnection();
	cong=C.getConnection();  
	//out.println("Inside Sale Edit ");
	String receive_id=request.getParameter("receive_id");
	//out.print("<br>receive_id=" +receive_id);

	java.sql.Date due_date = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date stockdate = new java.sql.Date(System.currentTimeMillis());
	double exchange_rate=0;
	double ctax = 0;
	double discount = 0;
	double total = 0;
	double subtotal=0;
	int counter=0;
	java.sql.Date receive_date = new java.sql.Date(System.currentTimeMillis());
	String receive_no="";
	String currency_id="";
	String companyparty_id="";
	String receive_companyid="";
	String receive_byname="";
	String receive_fromname="";
	String duedays="";
	String salesperson_id="";
	String ref_no="";//request.getParameter("ref_no");
	String description="";
	String purchasesalegroup_id="";
	String receive_category_id="";
	String query="Select * from Receive where Receive_Id=?";
	//out.println("Query12"+query);
	pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id); 
		rs_g = pstmt_g.executeQuery();	

	String local_currencyid=I.getLocalCurrency(conp,company_id);
	String local_currencysymbol= I.getLocalSymbol(conp,company_id);
	String currency_symbol=I.getSymbol(conp,currency_id);
	//int d=0;
	if("0".equals(currency_id)){currency_symbol="US $";
	String currency_name="US Dollar"; d=2;}
	else{
	local_currency= I.getLocalCurrency(conp,company_id);
	 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
	String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
	}
		while(rs_g.next())
			{
	receive_no=rs_g.getString("Receive_No");
	receive_date=rs_g.getDate("Receive_Date");
	counter=rs_g.getInt("Receive_Lots");
	currency_id=rs_g.getString("Receive_CurrencyId");
	exchange_rate=rs_g.getDouble("Exchange_rate");
	ctax=rs_g.getDouble("Tax");
	total= rs_g.getDouble("Receive_Total");
	companyparty_id=rs_g.getString("Receive_FromId");
	receive_fromname=rs_g.getString("Receive_FromName");
	receive_companyid=rs_g.getString("Company_Id");
	receive_byname=rs_g.getString("Receive_ByName");
	due_date=rs_g.getDate("Due_Date");
	 stockdate=rs_g.getDate("Stock_Date");
	//out.print("stockdate1=="+stockdate);
	duedays=rs_g.getString("Due_Days");
	salesperson_id=rs_g.getString("SalesPerson_Id");
	receive_category_id=rs_g.getString("Receive_Category");
	purchasesalegroup_id=rs_g.getString("PurchaseSaleGroup_Id");
	ref_no=rs_g.getString("CgtRef_No");
    
	if(rs_g.wasNull())
				{
		
		//ref_no=rs_g.getString("");
		  
		  ref_no="";
				
				}

	description=rs_g.getString("CgtDescription");
	if(rs_g.wasNull())
				{
		//ref_no=rs_g.getString("");
		  description="";
				
				}


	}
	pstmt_g.close();
	//out.print("<br>67 currency_id=" +currency_id);

	String today_string= format.format(receive_date);


	company_name="";
	String company_address="";
	String company_city="";
	String company_country="";
	String company_phone_off="";

	String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+receive_companyid;
	pstmt_p = conp.prepareStatement(company_query);
	//out.println("<BR>"+company_query);
	rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
		//out.println("Inside While 50");
		company_name= rs_g.getString("CompanyParty_Name");	company_address= rs_g.getString("Address1");	
		company_city= rs_g.getString("City");		
		company_country= rs_g.getString("Country");		
		company_phone_off= rs_g.getString("Phone_Off");		
		}
	pstmt_p.close();

	//out.println("<BR>counter= "+counter);
	//out.println("<BR>company id is= "+companyparty_id);
	String companyparty_name="";
	String address1="";
	String city="";
	String country="";
	String phone_off="";

	String company_queryy="select * from Master_CompanyParty where active=1 and companyparty_id="+companyparty_id;
	pstmt_p = conp.prepareStatement(company_queryy);
	//out.println("<br>"+company_queryy);
	rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 	
		{
		//out.println("Inside While 50");
		companyparty_name= rs_g.getString("CompanyParty_Name");		
		address1= rs_g.getString("Address1");		
		city= rs_g.getString("City");		
		country= rs_g.getString("Country");		
		phone_off= rs_g.getString("Phone_Off");		

		}
	pstmt_p.close();

	//out.println("<br>Outsude  While 59");

	double quantity[]=new double[counter];
	double rate[]=new double[counter];
	double amount[]=new double[counter];
	double ctax_amt=0;
	double temp_amt=0;
	//double discount_amt=0;
	String remarks[]=new String[counter]; 
	String receivetransaction_id[]=new String[counter]; 
	String lot_id[]=new String[counter]; 
	String lot_no[]=new String[counter]; 
	String location_id[]=new String[counter]; 
	String pcs[]=new String[counter];

	query="Select * from Receive_Transaction where Receive_Id=? and active=1";
	pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id); 
		rs_g = pstmt_g.executeQuery();	
		int n=0;
		while(rs_g.next())
			{
	receivetransaction_id[n]=rs_g.getString("ReceiveTransaction_id");
	lot_id[n]=rs_g.getString("Lot_Id");
	location_id[n]=rs_g.getString("location_id");
	//out.print("<br>locaation_id "+location_id[n]);
	quantity[n]= rs_g.getDouble("Available_Quantity");
	rate[n]= rs_g.getDouble("Receive_Price"); 
	pcs[n]=rs_g.getString("Pieces");
	remarks[n]=rs_g.getString("Remarks"); 
	amount[n]= str.mathformat((quantity[n] * rate[n]),d) ;
	subtotal += str.mathformat(amount[n],d); 
	n++;
			}//while

	pstmt_g.close();

	//discount_amt = subtotal * (discount/100);
	temp_amt = subtotal ;
	//	- discount_amt;
	ctax_amt = str.mathformat((temp_amt * (ctax/100)),d);
	total= str.mathformat((temp_amt + ctax_amt),d);
	//out.print("<br>subtotal=" +subtotal);
	//out.print("<br>ctax_amt=" +ctax_amt);
	//out.print("<br>total=" +total);

	for (int i=0;i<counter;i++)
	{
	lot_no[i]=A.getName(conp,"Lot", "Lot_No", lot_id[i]);
	}//for
	/*
	String local_currencyid=I.getLocalCurrency(conp,company_id);
	String local_currencysymbol= I.getLocalSymbol(conp,company_id);
	String currency_symbol=I.getSymbol(conp,currency_id);
	//int d=0;
	if("0".equals(currency_id)){currency_symbol="US $";
	String currency_name="US Dollar"; d=2;}
	else{
	local_currency= I.getLocalCurrency(conp,company_id);
	 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
	String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
	}
	*/
	%>
	<html>
	<head><title>Samyak Software</title>
	<script language="JavaScript">
	<%
		String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Sale=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
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
	pstmt_g.close();
	out.print("var companyArray=new Array("+companyArray+");");


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


%>
	function nullvalidation(name)
	{
	if(name.value =="") 
	{ 
	alert("Please Enter No"); 
	name.focus();}
	}// validate

//added by Datta

function calcTotal(name)
{
	var fieldname=name.name;
	var amountN = 0;
	var qtyN = 0;
	var rateN = 0;
	var d=<%=d%>;
	//if(document.mainform.currency[0].checked)
	//{
		//d=<%=d%>;
	//}
	validate(name,15)
    //alert ("Ok Inside CalcTotal"+d);
	var subtot = 0;
	var subtotal = 0;
	//var subtotal1 = calcLedgers();
	//subtotal = subtotal +subtotal1; 
	
	var counter=<%=counter%>;

	<%for(int i=0; i<counter; i++)
	{%>
		deletedName = "deleted"+i;
		lotName = "newlotno"+i;
		rateName = "rate"+i;
		amountName = "amount"+i;
		quantityName = "quantity"+i;
		hiddenamountName = "hiddenamount"+i;
		var amt=0;
		if(!(document.mainform.elements[deletedName].checked))
		{
		  if(fieldname!=null)
		  {
			if(document.mainform.elements[lotName].value!="#")
			{	
			  validate(document.mainform.elements[rateName],15);
			  validate(document.mainform.elements[amountName],d);
				   
			  if((document.mainform.elements[amountName].value=="0")||(
				document.mainform.elements[amountName].value==""))
			  {
				var amt1=(document.mainform.elements[quantityName].value) * (document.mainform.elements[rateName].value);
				amt1=amt1.toFixed(d);
				document.mainform.elements[amountName].value=amt1;
				document.mainform.elements[hiddenamountName].value=amt1;
			  }
				
			  if(document.mainform.elements[rateName].value=="0")
			  {		
				document.mainform.elements[rateName].value=(document.mainform.elements[amountName].value) / (document.mainform.elements[quantityName].value);
			  }
			
			  amountN=parseFloat(document.mainform.amount<%=i%>.value);
			  qtyN=parseFloat(document.mainform.quantity<%=i%>.value);
			  rateN=parseFloat(document.mainform.rate<%=i%>.value);

			  if( amountN!= (qtyN * rateN))
			  {
				if(amountN > (qtyN*rateN))
				{
				document.mainform.rate<%=i%>.value=((amountN)/(qtyN));
				}
				else
				{
				   amt=(qtyN * rateN);
				   amt=amt.toFixed(d);
				   document.mainform.amount<%=i%>.value = amt;
				   document.mainform.hiddenamount<%=i%>.value = amt;
				}
			   }//if
			 }
		   }
		//var amount11=document.mainform.amount<%=i%>.value;
		//subtotal=parseFloat(subtotal)+parseFloat(amount11);
		subtotal=parseFloat(subtotal)+parseFloat(amountN);
		
		if(amt != 0)
		{
			amt = amt - amountN;
			subtotal=parseFloat(subtotal)+parseFloat(amt);
		}
		 
		}//end of outer if
		
	<%}%>//end of for
	
		//subtotal=parseFloat(subtotal)+parseFloat(subtot);
		 subtotal=subtotal.toFixed(d);
		document.mainform.subtotal.value=subtotal;
		
		 
		 if(isNaN(subtotal))
		{ 
		return false;
		} 
		else{
			return true;
			}

}// calcTotalNew()

//No need to use finalTotal(); directly use calcTotal()


function calcTotalRow(name, deletedElem, lotnoElem, rateElem, amountElem, quantityElem, hiddenamountElem)
{
	var fieldname=name.name;
	var d=<%=d%>;

	//if(document.mainform.currency[0].checked)
	//{
		d=<%=d%>;
	//}
	validate(name,15)

	if(!(deletedElem.checked))
	{
	  if(fieldname!=null)
	  {
		if(lotnoElem.value!="#")
		{	
			validate(rateElem,15);
			validate(amountElem,d);

			if((amountElem.value=="0")||(amountElem.value==""))
			{
				var amt=(quantityElem.value) * (rateElem.value);
				amt=amt.toFixed(d);
				amountElem.value=amt;
				//document.mainform.hiddenamount.value=amt;
			}

			if(rateElem.value=="0")
			{
			rateElem.value=(amountElem.value) / (quantityElem.value);
			}

		if(amountElem.value != ((quantityElem.value)*(rateElem.value)))
		{
		 if(amountElem.value > ((quantityElem.value)*(rateElem.value)))
		 {
			rateElem.value=(amountElem.value) / (quantityElem.value);
		 }
		 else
		 {
			var amt=(quantityElem.value) * (rateElem.value);
			amt=amt.toFixed(d);
			amountElem.value=amt;
		 }
	    }//if 530
		
		var hiddenamt=parseFloat(hiddenamountElem.value);
		var subtotal=parseFloat(document.mainform.subtotal.value);
		
		subtotal=subtotal-hiddenamt;
		subtotal=subtotal.toFixed(d);
		
		var changedamt=parseFloat(amountElem.value);
		//alert("changedamt="+changedamt);
		var subtotal11=parseFloat(subtotal) + parseFloat(changedamt);
		
		subtotal=subtotal11.toFixed(d);
		//alert("subtotal33="+subtotal);
		document.mainform.subtotal.value=subtotal;
		document.mainform.total.value=subtotal;
		hiddenamountElem.value=changedamt;

		if(isNaN(subtotal))
	{ 
		return false;
	} 
	else{
		return true;
	}


	  }
	}
	}
}//end calcTotalRow()

//===============================================================



	function newlocation()
	{
	<%
	for(int i=0;i<counter;i++)
		{%>
		document.mainform.newlocation_id<%=i%>.value=document.mainform.masterlocation.value;
		<%}%>

	}

	function onLocalSubmitValidate()
		{
		newlocation();
		var finaltotal=document.mainform.total.value;
		if(isNaN(finaltotal))
		{ 
		alert("Please Enter all fields Properly");
		return false;
		} 
		else{
		return  fnCheckDate(document.mainform.datevalue.value,"Date")
		return true;
		}
		}//onSubmitValidate
	</script>

	<SCRIPT language=javascript 
	src="../Samyak/Samyakdate.js">
	</script>
	<SCRIPT language=javascript 
	src="../Samyak/Samyakmultidate.js">
	</script>
	<SCRIPT language=javascript 
	src="../Samyak/Samyakcalendar.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
	<script language=javascript src="../Samyak/actb.js"></script>
	<script language=javascript src="../Samyak/common.js"></script>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

	</head>

	<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus();showSales();' background="../Buttons/BGCOLOR.JPG">
	<FORM name=mainform
	action="EditCgtSaleForm.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
	<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=0>
	<tr><td colspan=3>
	<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
	<input type=hidden name=currency_id value=<%=currency_id%>>
	<input type=hidden name=oldreceive_no value=<%=receive_no%>>
	<input type=hidden name=receive_id value=<%=receive_id%>>
	<input type=hidden name=no_lots value=<%=counter+1%>>
	<input type=hidden name=old_lots value=<%=counter%>>

	<tr>
	<th colspan=10 align=center>Edit Consignment</th>
	</tr>

	<tr>
	<td colspan=1>No
	  <input type=text name=consignment_no size=5 value="<%=receive_no%>" onBlur='return nullvalidation(this)'></td>

	<td>Ref.No
	  <input type=text name=ref_no size=5 value="<%=ref_no%>"></td>
	<!--
	<td>To
	<%//=company_name%></td>-->

	<td colspan=1>From 
	<%
	String condition="Where Super=0  and Sale=1 and active=1";
	%>

	<input type=text onfocus="this.select()" name=companyparty_name value='<%=A.getNameCondition(conp,"Master_CompanyParty", "CompanyParty_Name", " Where CompanyParty_Id="+companyparty_id)%>'  size=15 id=companyparty_name autocomplete=off onBlur='showSales();'>

	<script language="javascript">
		var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
	</script>	

<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
	</td><input type=hidden name="oldcompanyparty_id" value="<%=companyparty_id%>">

	<td>Sale Group	
		<%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>

	<td>Category</td>
		<td><%=AC.getArrayConditionAll(conp,"Master_LotCategory","receive_category_id", receive_category_id ,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%></td>


		<td>Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name="duedaysold" value="<%=duedays%>"></td>


	</tr>
	<tr>
	<td colspan=2>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ;' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script>
	<input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
	onblur='return  fnCheckMultiDate(this,"Invoice Date")'>
	</td>
<% //out.print("<br>703 stockdate=="+stockdate);%>
	<td colspan=1>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script>
	<input type=text name='stockdate' size=8 maxlength=10 value="<%=format.format(stockdate)%>"
	onblur='return  fnCheckMultiDate(this,"Stock Date")'><input type=hidden name="stockdateold" value="<%=format.format(stockdate)%>">
	</td>

	<td colspan=1>
	<script language='JavaScript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;  ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
	</script>
	<input type=text name='due_date' size=8 maxlength=10 value="<%=format.format(due_date)%>"
	onblur='return  fnCheckMultiDate(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=format.format(due_date)%>">
	</td>


	<td colspan=1 id="combo1" style='display:none'>Purchase Person</td>
		<td colspan=1>
		<%=A.getMasterArray(cong,"Location","Location_Name1' id='Location_Name1' style='display:none","","1")%>
		<%=A.getMasterArray(cong,"Location","Location_Name2' id='Location_Name2' style='display:none","","2")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name3' id='Location_Name3' style='display:none","","3")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name4' id='Location_Name4' style='display:none","","4")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name5' id='Location_Name5' style='display:none","","5")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name6' id='Location_Name6' style='display:none","","6")%>	
		
		<input type="hidden" name="soldCompNo" value="0">
	</td>
	</tr>



<script language="javascript">
		
	function showSales()
	{
		cname = document.mainform.companyparty_name.value;
		
		if("AMY_HK"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 1;
			var idName = "Location_Name"+1;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";	
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("MSN_SZ"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 2;
			var idName = "Location_Name"+2;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	

		}
		else if("SKG_SH"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 3;
			var idName = "Location_Name"+3;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("ABC_TP"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 4;
			var idName = "Location_Name"+4;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("KB_IND"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 5;
			var idName = "Location_Name"+5;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("TE_IND"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 6;
			var idName = "Location_Name"+6;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 0;
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "none";	
		}
	}

	function makeAllDisplayNone()
	{
		for(var i=1; i<7; i++)
		{
			var idName = "Location_Name"+i;
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "none";
		}
	}
    </script>





 
	<tr>
	 
	<td>Location</td>
	<td><%=AC.getMasterArrayCondition(conp,"Location","masterlocation",location_id[0],"where company_id="+company_id)%></td>
	<td><%
	if("0".equals(currency_id))
	{
	local_currencysymbol="US $";	
	%>
	<input type=hidden name=currency value=dollar> 

	<% } else {
	local_currencysymbol=local_currencysymbol;
	%> 
	<input type=hidden name=currency value=local> 
	<% } %>
	 <td>Sale Person
	  <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=0 and Active=1 and  company_id="+company_id+" order by SalesPerson_Name")%>
	</td>

	<td>Exchange Rate</td><td>  
	 <input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
	</td>
	</tr>

	</table>
	</td></tr>
	<tr><td>
	<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0>

	<tr>
	<td>Sr No</td>
	<td>Delete</td>
	<td>Lot No</td>
	<!-- <td>Location</td> -->
	<!-- <td>Pcs</td>
	 --><td>Quantity<br>(Carat)</td>
	<td>Rate / Unit</td>
	<td>Amount in <%=local_currencysymbol%></td>
	<td>Remarks</td>
	</tr>
	<% 
	for (int i=0;i<counter;i++)
	{
	%>
	<tr><td><%=i+1%></td>
	<td><input type="checkbox" name="deleted<%=i%>" value="yes"><!-- onclick='return calcTotal(document.mainform.ctax_amt)' --></td>
	<td>
	<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
	<input type=hidden name=lot_id<%=i%> value="<%=lot_id[i]%>">
	<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
	<input type=hidden name=newlocation_id<%=i%> value="<%=location_id[i]%>">
	<input type=hidden name=lotno<%=i%> value="<%=lot_no[i]%>">
	<input type=text name=newlotno<%=i%> id=newlotno<%=i%> value="<%=lot_no[i]%>" size=10 onBlur='return  nullvalidation(this)' autocomplete=off></td>
	<!-- 	<td><%//=A.getName("Location",location_id[i])%></td>-->
	<!--  <td> --><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this)" size=2 style="text-align:right"><!-- </td> -->
	<td>
		<input type=hidden name=old_quantity<%=i%> value="<%=quantity[i]%>">
		<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='validate(this,3)' style="text-align:right">
	</td>

	<td>
		<input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5  style="text-align:right">
	</td>

	<td>
		<input type=text name=amount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>" size=8 style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.newlotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)'>
		<!-- OnBlur='return calcTotal(this)'> -->
		<input type=hidden name=hiddenamount<%=i%> value="<%=str.mathformat(""+amount[i],d)%>">
	</td>

	<td><input type=text name=remarks<%=i%> value="<%=remarks[i]%>" size=8></td>
	</tr>
	<script language="javascript">

	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
			
</script>
	<%
	}
	%>

	<tr>
	<td colspan=1></td>
	<td colspan=4>Sub Total in <%=local_currencysymbol%></td>
	<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=str.mathformat(""+subtotal,d)%>" style="text-align:right"
	></td>
	<!-- OnBlur='return calcTotal(this)' -->
	<td colspan=1></td>
	</tr>

	<!-- 
		<tr>
	<td colspan=1></td>
	<td colspan=3>Discount (%)</td>
	<td colspan=1><input type=text name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"> </td>
	<td colspan=1><input type=text name=discount_amt size=8 readonly style="text-align:right" value="<%//=(discount*subtotal)%>"></td>
	<td colspan=2></td>
	</tr>
	--> 

	<tr>
	<td colspan=8></td>
	 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
	<td><input type=hidden name=ctax_amt size=8  style="text-align:right" value="0"></td>
	<td colspan=1></td>
	</tr>
	<tr>
	<td colspan=1></td>
	<td colspan=4>Total in <%=local_currencysymbol%></td>
	<td colspan=1><input type=text readonly name=total size=8 value="<%=str.mathformat(""+total,d)%>" style="text-align:right"></td>
	</tr>
	<tr>
	<td colspan=6> Narration <input type=text name=description size=75 tabindex=14 value="<%=description%>">
	</td>
	</tr>

	<tr>
	<td colspan=6 align=center>Add Lots 
		<input type=text name=addlots size=2 value="1" onBlur="validate(this)">
		<input type=submit name=command value=ADD  class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp;&nbsp;
		<input type=submit name=command value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"
		onclick="return calcTotal()"> 
	</td>
	</tr>
	</TABLE>

	</td>
	</tr>

	</table>
	</FORM>
	</body>
	</html>
	<%


	C.returnConnection(conp);
	C.returnConnection(cong);



	}   //end if CgtPurchaseEdit
	}
	catch(Exception e631){ 
	out.println("<font color=red> FileName : EditSale.jsp command=sedit<br>Bug No e631 : "+ e631);}



	%>
<!---------------------------------------------------------
							ADD Form Start
---------------------------------------------------------->

<%
try{
if("ADD".equals(command))
{

	conp=C.getConnection();
	cong=C.getConnection();

String receive_category_id=request.getParameter("receive_category_id");

int addlots=Integer.parseInt(request.getParameter("addlots"));

String oldreceive_no=request.getParameter("oldreceive_no");
String salesperson_id=request.getParameter("salesperson_id");
String receive_no=request.getParameter("receive_no");
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
String old_lots = request.getParameter("old_lots");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String consignment_no = request.getParameter("consignment_no");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> stock date "+stockdate );
String stockdateold = request.getParameter("stockdateold");
String due_date = request.getParameter("due_date");
String due_dateold = request.getParameter("due_dateold");
String receive_date=""+datevalue;
String currency = request.getParameter("currency");
String currency_id = request.getParameter("currency_id");
String exchange_rate = request.getParameter("exchange_rate");



String Location_Name1 = request.getParameter("Location_Name1");
String Location_Name2 = request.getParameter("Location_Name2");
String Location_Name3 = request.getParameter("Location_Name3");
String Location_Name4 = request.getParameter("Location_Name4");
String Location_Name5 = request.getParameter("Location_Name5");
String Location_Name6 = request.getParameter("Location_Name6");
String soldCompNo = request.getParameter("soldCompNo");




int nolots_old=Integer.parseInt(lots);
int counter=nolots_old;
String deleted[]=new String[counter];
String lotid[]=new String[counter];
String receivetransaction_id[]=new String[counter];
String lotno[]=new String[counter];
String newlotno[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
String pcs[]=new String[counter];
String old_quantity[]=new String[counter];
String quantity[]=new String[counter];
String rate[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];
 
for (int i=0;i<counter-1;i++)
{
deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted[i] "+deleted[i]);
lotid[i]=""+request.getParameter("lot_id"+i);
//out.print("Lot_id"+i+lotid[i]);
receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);

lotno[i]=""+request.getParameter("lotno"+i);
newlotno[i]=""+request.getParameter("newlotno"+i);
location_id[i]=""+request.getParameter("location_id"+i);
newlocation_id[i]=""+request.getParameter("newlocation_id"+i);

pcs[i]=""+request.getParameter("pcs"+i);
old_quantity[i]=""+request.getParameter("old_quantity"+i);
quantity[i]=""+request.getParameter("quantity"+i);
rate[i]=""+request.getParameter("rate"+i); 
amount[i]=""+request.getParameter("amount"+i); 
remarks[i]=""+request.getParameter("remarks"+i); 
}
String add_lots = request.getParameter("addlots");
int newlots=Integer.parseInt(add_lots);
int total_lots=counter+newlots;
String companyparty_name= request.getParameter("companyparty_name");
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");
String subtotal =""+ request.getParameter("subtotal");
String ctax =""+ request.getParameter("ctax");
//String discount =""+ request.getParameter("discount");
String total =""+ request.getParameter("total");
String duedays =""+ request.getParameter("duedays");
String duedaysold =""+ request.getParameter("duedaysold");

String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;

if ("dollar".equals(currency))
	{local_currencysymbol="$";}

if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{

local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}
%>

<html>
<head><title>Samyak Software</title>
<script language="JavaScript">
<%
String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Purchase=1 and Company_Id="+company_id+" order by CompanyParty_Name";
		
	pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
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
	pstmt_g.close();
	out.print("var companyArray=new Array("+companyArray+");");


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


%>
function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate



//added by Datta

function calcTotal(name)
{
	var fieldname=name.name;
	var amountN = 0;
	var qtyN = 0;
	var rateN = 0;
	var d=<%=d%>;
	//if(document.mainform.currency[0].checked)
	//{
		//d=<%=d%>;
	//}
	validate(name,15)
    //alert ("Ok Inside CalcTotal"+d);
	var subtot = 0;
	var subtotal = 0;
	//var subtotal1 = calcLedgers();
	//subtotal = subtotal +subtotal1; 
	
	//var counter=<%=counter%>;

	<%for(int i=0; i<(total_lots-1); i++)
	{%>
		deletedName = "deleted"+i;
		lotName = "newlotno"+i;
		rateName = "rate"+i;
		amountName = "amount"+i;
		quantityName = "quantity"+i;
		hiddenamountName = "hiddenamount"+i;
		var amt=0;
		if(!(document.mainform.elements[deletedName].checked))
		{
		  if(fieldname!=null)
		  {
			if(document.mainform.elements[lotName].value!="#")
			{	
			  validate(document.mainform.elements[rateName],15);
			  validate(document.mainform.elements[amountName],d);
				   
			  if((document.mainform.elements[amountName].value=="0")||(
				document.mainform.elements[amountName].value==""))
			  {
				var amt1=(document.mainform.elements[quantityName].value) * (document.mainform.elements[rateName].value);
				amt1=amt1.toFixed(d);
				document.mainform.elements[amountName].value=amt1;
				document.mainform.elements[hiddenamountName].value=amt1;
			  }
				
			  if(document.mainform.elements[rateName].value=="0")
			  {		
				document.mainform.elements[rateName].value=(document.mainform.elements[amountName].value) / (document.mainform.elements[quantityName].value);
			  }
			
			  amountN=parseFloat(document.mainform.amount<%=i%>.value);
			  qtyN=parseFloat(document.mainform.quantity<%=i%>.value);
			  rateN=parseFloat(document.mainform.rate<%=i%>.value);

			  if( amountN!= (qtyN * rateN))
			  {
				if(amountN > (qtyN*rateN))
				{
				 document.mainform.rate<%=i%>.value=((amountN)/(qtyN));
				}
				else
				{
				   amt=(qtyN * rateN);
				   amt=amt.toFixed(d);
				   document.mainform.amount<%=i%>.value = amt;
				   document.mainform.hiddenamount<%=i%>.value = amt;
				}
			   }//if
			 }
		   }
		//var amount11=document.mainform.amount<%=i%>.value;
		//subtotal=parseFloat(subtotal)+parseFloat(amount11);
		subtotal=parseFloat(subtotal)+parseFloat(amountN);
		
		if(amt != 0)
		{
			amt = amt - amountN;
			subtotal=parseFloat(subtotal)+parseFloat(amt);
		}
		 
		}//end of outer if
		 
	<%}%>//end of for
	
		//subtotal=parseFloat(subtotal)+parseFloat(subtot);
		subtotal=subtotal.toFixed(d);
		document.mainform.subtotal.value=subtotal;
		document.mainform.total.value=subtotal;

		if(isNaN(subtotal))
		{ 
			return false;
		} 
		else{
			return true;
			}
}// calcTotalNew()



function calcTotalRow(name, deletedElem, lotnoElem, rateElem, amountElem, quantityElem, hiddenamountElem)
{
	var fieldname=name.name;
	var d=<%=d%>;

	//if(document.mainform.currency[0].checked)
	//{
		//d=<%=d%>;
	//}
	validate(name,15)

	if(!(deletedElem.checked))
	{
	  if(fieldname!=null)
	  {
		if(lotnoElem.value!="#")
		{	
			validate(rateElem,15);
			validate(amountElem,d);

			if((amountElem.value=="0")||(amountElem.value==""))
			{
				var amt=(quantityElem.value) * (rateElem.value);
				amt=amt.toFixed(d);
				amountElem.value=amt;
				//document.mainform.hiddenamount.value=amt;
			}

			if(rateElem.value=="0")
			{
			rateElem.value=(amountElem.value) / (quantityElem.value);
			}

		if(amountElem.value != ((quantityElem.value)*(rateElem.value)))
		{
		 if(amountElem.value > ((quantityElem.value)*(rateElem.value)))
		 {
			rateElem.value=(amountElem.value) / (quantityElem.value);
		 }
		 else
		 {
			var amt=(quantityElem.value) * (rateElem.value);
			amt=amt.toFixed(d);
			amountElem.value=amt;
		 }
	    }//if 530
		
		var hiddenamt=parseFloat(hiddenamountElem.value);
		var subtotal=parseFloat(document.mainform.subtotal.value);
		
		subtotal=subtotal-hiddenamt;
		subtotal=subtotal.toFixed(d);
		
		var changedamt=parseFloat(amountElem.value);
		//alert("changedamt="+changedamt);
		var subtotal11=parseFloat(subtotal) + parseFloat(changedamt);
		
		subtotal=subtotal11.toFixed(d);
		//alert("subtotal33="+subtotal);
		document.mainform.subtotal.value=subtotal;
		document.mainform.total.value=subtotal;
		hiddenamountElem.value=changedamt;

		if(isNaN(subtotal))
		{ 
		return false;
		} 
		else{
			return true;
			}


	  }
	}
	}
}//end calcTotalRow()


function onLocalSubmitValidate()
	{
	//calcTotal();
	var finaltotal=document.mainform.total.value;
	if(isNaN(finaltotal))
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
	}//onSubmitValidate
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>

<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgColor=#ffffee onLoad='document.mainform.consignment_no.focus();showSales();' background="../Buttons/BGCOLOR.JPG">
<FORM name=mainform
action="EditCgtSaleForm.jsp" method=post onSubmit='return onLocalSubmitValidate()'>
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=0>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<input type=hidden name=currency_id value=<%=currency_id%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=no_lots value=<%=total_lots%>>
<tr >
<td colspan=7 align=center><b>Edit Consignment</b> </td>
</tr>

<tr>
<td>No 
  <input type=text name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'></td>

  <td>Ref.No 
  <input type=text name=ref_no size=5 value="<%=ref_no%>"></td>
  <!-- <td colspan=1>To : <%=company_name%></td> -->
<td>From
<input type=text onfocus="this.select()" name=companyparty_name value='<%=companyparty_name%>'  size=15 id=companyparty_name autocomplete=off>
 <script language="javascript">
	var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);
</script>	
<%
String condition="Where Super=0  and Sale=1 and active=1";

%>
<%//=A.getMasterArrayCondition(conp,"companyparty","companyparty_id",companyparty_id,condition ,company_id) %>
</td><input type=hidden name="oldcompanyparty_id" value="<%=oldcompanyparty_id%>">





<td>Sale Group
	<%=AC.getMasterArrayCondition(conp,"PurchaseSaleGroup","purchasesalegroup_id",purchasesalegroup_id,"where Active=1 and PurchaseSaleGroup_Type=0",company_id)%></td>

<td>Category</td>


<td><%=AC.getArrayConditionAll(conp,"Master_LotCategory","receive_category_id",receive_category_id,"where company_id="+company_id,"LotCategory_Id","LotCategory_Name")%>
	</td>



<td colspan=1>Due Days<input type=text name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"><input type=hidden name="duedaysold" value="<%=duedaysold%>"> </td></tr>




<tr>
<td colspan=2>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Invoice Date' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>	
<input type=text name='datevalue' size=8 maxlength=10 value="<%=datevalue%>"
onblur='return  fnCheckMultiDate(this,"Invoice Date")'></td>
 
<td colspan=1>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.sotckdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>	
<input type=text name='stockdate' size=8 maxlength=10 value="<%=stockdate%>"
onblur='return  fnCheckMultiDate(this,"Stock Date")'><input type=hidden name="stockdateold" value="<%=stockdateold%>">
</td>
 
<td colspan=1>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.due_date, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script></td>	
<td><input type=text name='due_date' size=8 maxlength=10 value="<%=due_date%>"
onblur='return  fnCheckMultiDate(this,"Due Date")'><input type=hidden name="due_dateold" value="<%=due_dateold%>"></td>

<td colspan=1 id="combo1" style='display:none'>Purchase Person</td>
		<td colspan=1>
		<%=A.getMasterArray(cong,"Location","Location_Name1' id='Location_Name1' style='display:none",Location_Name1,"1")%>
		<%=A.getMasterArray(cong,"Location","Location_Name2' id='Location_Name2' style='display:none",Location_Name2,"2")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name3' id='Location_Name3' style='display:none",Location_Name3,"3")%>	<%=A.getMasterArray(cong,"Location","Location_Name4' id='Location_Name4' style='display:none",Location_Name4,"4")%>	
		<%=A.getMasterArray(cong,"Location","Location_Name5' id='Location_Name5' style='display:none",Location_Name5,"5")%>	<%=A.getMasterArray(cong,"Location","Location_Name6' id='Location_Name6' style='display:none",Location_Name6,"6")%>	
		
		<input type="hidden" name="soldCompNo" value="<%=soldCompNo%>">
	</td>
</tr>



<script language="javascript">
		
	function showSales()
	{
		cname = document.mainform.companyparty_name.value;
		
		if("AMY_HK"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 1;
			var idName = "Location_Name"+1;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";	
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("MSN_SZ"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 2;
			var idName = "Location_Name"+2;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	

		}
		else if("SKG_SH"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 3;
			var idName = "Location_Name"+3;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("ABC_TP"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 4;
			var idName = "Location_Name"+4;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("KB_IND"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 5;
			var idName = "Location_Name"+5;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else if("TE_IND"==cname)
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 6;
			var idName = "Location_Name"+6;
	
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "block";
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "block";	
		}
		else
		{
			makeAllDisplayNone();
			document.mainform.soldCompNo.value = 0;
			purpersonNameId = document.getElementById("combo1");
			purpersonNameId.style.display = "none";	
		}
	}

	function makeAllDisplayNone()
	{
		for(var i=1; i<7; i++)
		{
			var idName = "Location_Name"+i;
			locationNameId = document.getElementById(idName);
			locationNameId.style.display = "none";
		}
	}
    </script>









<tr>
 
 <tr>
	 <td>Location</td><td><%=AC.getMasterArrayCondition(conp,"Location","location_id0",location_id[0],"where Active=1",company_id)%></td>

<%
if("0".equals(currency_id))
{
local_currencysymbol="US $";	
%>
<input type=hidden name=currency value=dollar> 

<% } else {
local_currencysymbol=local_currencysymbol;
%> 
<input type=hidden name=currency value=local> 
<% } %>
<td> Sale Person </td><td>
  <%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id",salesperson_id,"where PurchaseSale=0 and Active=1 and  company_id="+company_id+" order by SalesPerson_Name")%>
</td>
<td>Exchange Rate  
 <input type=text name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right">
</td>
</tr>
</table>

 </td></tr>
<tr><td>

 <table borderColor=#D9D9D9 align=center width=100% border=1  cellspacing=0 cellpadding=0>

 <tr>
<td>Sr No</td>
<td>Lot No</td>
<!-- <td>Location</td> -->
<!-- <td>Pcs</td>
 --><td>Quantity<br>(Carat)</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>

<% 
String temp1="";
for (int i=0;i<counter-1;i++)
{
	if("yes".equals(deleted[i]))
	{
		temp1="readonly";
		%>
			<tr bgcolor=red >
		<%
	}
		else
	{
			temp1="";
		%>
			<tr>
		<% }//end else
%>

	
<td><%=i+1%></td>
<td>
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">
<input type=hidden name="deleted<%=i%>" value="<%=deleted[i]%>">
<input type=hidden name=lot_id<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>">
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>">
<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>" size=10 onBlur='return nullvalidation(this)'>
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> value="<%=newlotno[i]%>"  size=10 <%=temp1%> > </td>

<!-- <td><%//=A.getName("Location",location_id[i])%></td> -->
<!-- <td> --><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this,3)" size=2 <%=temp1%> style="text-align:right"><!-- </td> -->
<td>
	<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
	<input type=text name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='validate(this,3)' <%=temp1%> style="text-align:right">
</td>

<td>
	<input type=text name=rate<%=i%> value="<%=rate[i]%>" size=5 <%=temp1%> style="text-align:right">
</td>

<td>
	<input type=text name=amount<%=i%> value="<%=amount[i]%>" size=8 <%=temp1%> style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.newlotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)'>
		<!-- OnBlur='return calcTotal(this)'> -->
	<input type=hidden name=hiddenamount<%=i%> value="<%=amount[i]%>">
</td>

<td>
	<input type=text <%=temp1%> name=remarks<%=i%> value="<%=remarks[i]%>" size=8>
</td>
</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>
<% //}//end if
}//end of first for in ADD



for (int i=counter-1;i<((counter-1)+addlots);i++)
{
%>

<tr><td><%=i+1%></td>
<td>
	<input type=hidden name="deleted<%=i%>" value="no">

<input type=hidden name=receivetransaction_id<%=i%>  value="noid">
<input type=text name=newlotno<%=i%> id=newlotno<%=i%> size=10 onBlur='return nullvalidation(this)' value=""></td>
<!-- <td><%//=A.getMasterArray("Location","location_id"+i,"",company_id)%>
</td> -->

<input type=hidden name="location_id<%=i%>" value="<%=location_id[0]%>">

<input type=hidden name="newlocation_id<%=i%>" value="<%=newlocation_id[0]%>">
<!-- <td> --><input type=hidden name=pcs<%=i%> value="0" onBlur="validate(this)" size=2 style="text-align:right"><!-- </td> -->

<td>
	<input type=hidden name=old_quantity<%=i%> value="0">
	<input type=text name=quantity<%=i%> value="1" size=5 OnBlur='validate(this,3)' style="text-align:right">
</td>

<td>
	<input type=text name=rate<%=i%> value="0" size=5 style="text-align:right">
</td>

<td>
	<input type=text name=amount<%=i%> value="0" size=8 style="text-align:right" OnBlur='return calcTotalRow(this, document.mainform.deleted<%=i%>, document.mainform.newlotno<%=i%>, document.mainform.rate<%=i%>, document.mainform.amount<%=i%>, document.mainform.quantity<%=i%>, document.mainform.hiddenamount<%=i%>)'>
		<!-- OnBlur='return calcTotal(this)'> -->
	<input type=hidden name=hiddenamount<%=i%> value="0">
</td>
<td><input type=text name=remarks<%=i%> value="" size=8></td>
</tr>
<script language="javascript">
	var lobj<%=i%> = new  actb(document.getElementById('newlotno<%=i%>'), lotNoArray);
</script>	
<%
}
%>

<tr>
<!-- <td colspan=1></td>
 --><td colspan=4>Sub Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"></td>
<td colspan=1></td>
</tr>
<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1><input type=text name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"> </td>
<td colspan=1><input type=text name=discount_amt size=8 readonly style="text-align:right" value=""></td>
<td colspan=2></td>
</tr>
 --><tr>
<td colspan=8></td>
 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
<td><input type=hidden name=ctax_amt size=8  style="text-align:right" value="0"></td>
<td colspan=1></td>
</tr>
<tr>
<!-- <td colspan=1></td>
 --><td colspan=4>Total in <%=local_currencysymbol%></td>
<td colspan=1><input type=text readonly name=total size=8 value="<%=total%>" style="text-align:right" ></td>
</tr>

<input type=hidden  name=salesperson_id  value='<%=salesperson_id%>' >
<tr>
	
<td colspan=6> Narration <input type=text name=description size=75 tabindex=14 value="<%=description%>"></td>

</tr>


<tr>
<td colspan=7 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp; &nbsp;&nbsp;
<input type=submit name=command value=NEXT class='button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="return calcTotal(this)"> </td>
</tr>
</TABLE>
</td>
</tr>
</table>
</FORM>
</BODY>
</HTML>
<%


C.returnConnection(conp);
C.returnConnection(cong);


}//if add
}
catch(Exception Samyak1031){ 
out.println("<font color=red> FileName : EditPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							ADD Form End 
--------------------------------------------------------  -->
<!---------------------------------------------------------
							NEXT Form Start
---------------------------------------------------------->

<%
try{

if("NEXT".equals(command))
{
	conp=C.getConnection();
	cong=C.getConnection();


	

String receive_category_id=request.getParameter("receive_category_id");

//int addlots=Integer.parseInt(request.getParameter("addlots"));
int addlots=0;
String receive_id=request.getParameter("receive_id");
String lots = request.getParameter("no_lots");
int Final_lots=(Integer.parseInt(lots));
//out.println("<center><br>Final lots: "+Final_lots+"</center>");
String old_lots = request.getParameter("old_lots");
 //out.println("<center><br>old_lots: "+old_lots+"</center>");
String oldreceive_no = request.getParameter("oldreceive_no");
String salesperson_id = request.getParameter("salesperson_id");
//out.print("salesperson_id"+salesperson_id);
String consignment_no = request.getParameter("consignment_no");
String datevalue = request.getParameter("datevalue");
String stockdate = request.getParameter("stockdate");
//out.print("<br> Stock Date "+stockdate);
String stockdateold = request.getParameter("stockdateold");
String ref_no=request.getParameter("ref_no");
String description=request.getParameter("description");

String companyparty_name= request.getParameter("companyparty_name");
String companyparty_id= A.getNameCondition(conp, "Master_CompanyParty", "CompanyParty_Id", " Where companyparty_name='"+companyparty_name+"' and company_id="+company_id );
String oldcompanyparty_id= request.getParameter("oldcompanyparty_id");
String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
String due_date = request.getParameter("due_date");
String due_dateold = request.getParameter("due_dateold");
String duedays =""+ request.getParameter("duedays");
String duedaysold =""+ request.getParameter("duedaysold");


String soldCompNo=request.getParameter("soldCompNo");

String Loca_id = "0";
String Loca_name = "";
if(! "0".equals(soldCompNo))
{
	Loca_id=request.getParameter("Location_Name"+soldCompNo);
	Loca_name = A.getName(cong,"Location",Loca_id);
}



int finalduedays=Integer.parseInt(duedays);
String finalduedate=format.getDueDate(datevalue,finalduedays);
if(duedaysold.equals(duedays))
	{
	if(due_date.equals(due_dateold))
		{
			if(!(companyparty_id.equals(oldcompanyparty_id)))
			{
			finalduedays= Integer.parseInt(G.getFinalDueDays(conp,datevalue, companyparty_id));
			finalduedate=format.getDueDate(datevalue,finalduedays);
			}
		}
	else
		{
			finalduedate=due_date;
			finalduedays=Integer.parseInt(format.getDueDays(datevalue,finalduedate));
		}	
	}

String receive_date=""+datevalue;
String currency = request.getParameter("currency");
String currency_id = request.getParameter("currency_id");
//out.println("Line No 979: currecy"+currency);

String exchange_rate = request.getParameter("exchange_rate");
int nolots_old=Integer.parseInt(lots);

int counter=Final_lots;//****

String lotid[]=new String[counter];
String newlotid[]=new String[counter];
String receivetransaction_id[]=new String[counter];
String lotno[]=new String[counter];
String newlotno[]=new String[counter];
 String pcs[]=new String[counter];
String old_quantity[]=new String[counter];
String quantity[]=new String[counter];
String rate[]=new String[counter];
String amount[]=new String[counter];
String remarks[]=new String[counter];
String deleted[]=new String[counter];
String location_id[]=new String[counter];
String newlocation_id[]=new String[counter];
double qtyinhand[]=new double[counter];


//out.print("acounter"+counter);
for (int i=0;i<counter-1;i++)
{

location_id[i]=""+request.getParameter("location_id"+i);
//out.print("<br>location_id[i]"+location_id[i]);

newlocation_id[i]=""+request.getParameter("newlocation_id"+i);
//out.print("<br> newlocation_id[i]"+newlocation_id[i]);

deleted[i]=""+request.getParameter("deleted"+i);
//out.print("<br>deleted-"+i+deleted[i]);

lotno[i]=""+request.getParameter("lotno"+i);
newlotno[i]=""+request.getParameter("newlotno"+i);
//out.print("<br>newlotno[i]="+newlotno[i]);



lotid[i]=""+request.getParameter("lot_id"+i);
//out.print("<br>Lotid"+lotid[i]);

newlotid[i]=A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No='"+newlotno[i]+"' and company_id="+company_id);
//out.print("<br> company_id= "+company_id);
// out.print("<br>newLotid"+newlotid[i]);

receivetransaction_id[i]=""+request.getParameter("receivetransaction_id"+i);

pcs[i]=""+request.getParameter("pcs"+i);

old_quantity[i]=""+request.getParameter("old_quantity"+i);

quantity[i]=""+request.getParameter("quantity"+i);

rate[i]=""+request.getParameter("rate"+i); 

amount[i]=""+request.getParameter("amount"+i); 

remarks[i]=""+request.getParameter("remarks"+i); 
}//end for

String querynewlot="";
String lotcount[]=new String[counter];
	int lotflag=0;
for(int i=0;i<counter-1;i++)
{
	//out.print("<br>For");

	querynewlot="select * from Lot where Lot_No='"+newlotno[i]+"' and company_id="+company_id;
	pstmt_p=conp.prepareStatement(querynewlot);
	rs_g=pstmt_p.executeQuery();
	while(rs_g.next())
	{
		lotcount[i]="yes";
		lotflag++;
	}
	

}
//out.print("<br>1252 lotflag "+lotflag);
//---Check For News Lot Present OR NOT  AND calculation For Quantity in hand after update------
for(int i=0;i<counter-1;i++)
{

	//------------calculation For Quantity in hand after update---------------------------------
double lotlocationqty=0;

String lotlocationquery="select * from LotLocation where Lot_id=? and Location_Id=?";
pstmt_p=conp.prepareStatement(lotlocationquery);
pstmt_p.setString(1,newlotid[i]);
//out.print("<br>newlotid"+newlotid[i]);
pstmt_p.setString(2,newlocation_id[i]);
//out.print("<br>newlocation_id"+newlocation_id[i]);
rs_g=pstmt_p.executeQuery();
while(rs_g.next())
{
	lotlocationqty=rs_g.getDouble("Available_Carats");
}
pstmt_p.close();
qtyinhand[i]=lotlocationqty+Double.parseDouble(old_quantity[i])-Double.parseDouble(quantity[i]);
//out.print("<br>qtyinhand[i]"+ qtyinhand[i]);
	//----------------END calculation For Quantity in hand after update----------------------------

	if(!("yes".equals(lotcount[i])))
	{
		 out.print("<br>Lot No "+newlotno[i]+"does not exists<br>");	
			
	}
}
//-------------------------------------------------------------------------------------
if(!(lotflag==counter-1))
{
	// C.returnConnection(conp);
	// C.returnConnection(cong);

	out.print("<input type=button name='command' value='Back' onclick='history.back(1)'>");
}
else
	{
String add_lots = request.getParameter("addlots");
//int newlots=Integer.parseInt(add_lots);
int newlots=0;
int total_lots=counter+newlots;
//out.println("Line No 979: total_lots"+total_lots);
String subtotal =""+ request.getParameter("subtotal");
String ctax =""+ request.getParameter("ctax");
//String discount =""+ request.getParameter("discount");
//double discount_amount= Double.parseDouble(subtotal)*Double.parseDouble(discount)/100;
double ctax_amount=
((Double.parseDouble(subtotal)*Double.parseDouble(ctax))/100);
double total_amount=
(Double.parseDouble(subtotal)+ctax_amount);
//	-discount_amount);

String total =""+ request.getParameter("total");


String local_currencyid=I.getLocalCurrency(conp,company_id);
String local_currencysymbol= I.getLocalSymbol(conp,company_id);
String currency_symbol=I.getSymbol(conp,currency_id);
//int d=0;
if ("dollar".equals(currency))
	{local_currencysymbol="$";
	}

if("0".equals(currency_id)){currency_symbol="US $";
String currency_name="US Dollar"; d=2;}
else{

local_currency= I.getLocalCurrency(conp,company_id);
 //d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
String currency_name=A.getName(conp,"Master_Currency", "Currency_Name","Currency_id",local_currency);
}

int no_i=0;
//out.println("oldreceive_no:"+oldreceive_no);
//out.println("consignment_no:"+consignment_no);
if(oldreceive_no.equals(consignment_no))
{ 
//out.println("Same");
}
else
{ 
	//conp=C.getConnection();

//out.println("Different");
String noquery="Select * from  Receive where Receive_No=? and company_id=? and Receive_Sell=1";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,consignment_no); 
pstmt_p.setString(2,company_id); 
rs_g = pstmt_p.executeQuery();

	while(rs_g.next()) 	
	{
	no_i++;
	}
	pstmt_p.close();
	//C.returnConnection(conp);
//out.print("<br>no_i" +no_i);
}
if(no_i > 0)
	{
%><body bgColor=#ffffee  background="../Buttons/BGCOLOR.JPG">
<%
out.print("<br><center>Sale No "+consignment_no+ " already exist. </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else{
	//conp=C.getConnection();

int j=0;
int flag= 0;
int final_flag=0; 
double carats[]=new double[counter] ;
double sell_quantity[]=new double[counter] ;
String lot_id[]= new String[counter];

for (int i=0;i<counter-1;i++)
{
j=0;
String query="Select * from  Lot where Lot_No=? and company_id=?";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,lotno[i]); 
//out.print("<br>lotno[i]=" +lotno[i]);
pstmt_p.setString(2,company_id); 
rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
	j++;
	lot_id[i]=rs_g.getString("Lot_Id");
	}
	pstmt_p.close();


}//for


//C.returnConnection(conp);

%>
<html>
<head>
<title>Samyak Software</title>
<script language="JavaScript">
function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No"); 
name.focus();}
}// validate

function validate(name)
{
	if(name.value =="") 
	{ alert("Please Enter Number "); 
	name.value="0"+name.value ;
	name.focus();}
	if(isNaN(name.value)) 
	{ alert("Please Enter Number Properly"); name.select();}
	if(name.value.charAt(0) == ".") 
	{ name.value="0"+name.value+"0"; }
	}// validate

function calcTotal(name)
	{
	validate(name)
	//alert ("Ok Inside CalcTotal");
	var subtotal=0;
<%
for(int i=0;i<(counter+addlots)-1;i++)
{
out.print("document.mainform.amount"+i+".value=(document.mainform.quantity"+i+".value) * (document.mainform.rate"+i+".value);");
out.print("subtotal=parseFloat(subtotal)+parseFloat(document.mainform.amount"+i+".value);");
}//end for 
%>
document.mainform.subtotal.value=subtotal;
//var discount_amt= (subtotal*document.mainform.discount.value)/100;
var temp_total= subtotal; 
//	- discount_amt;
var tax_amt= (temp_total*document.mainform.ctax.value)/100;
var finaltotal=temp_total + tax_amt;
document.mainform.total.value=finaltotal;
document.mainform.ctax_amt.value=tax_amt;
//document.mainform.discount_amt.value=discount_amt;

if(isNaN(subtotal))
{ 
return false;
} 
else{
return true;
}
}// calcTotal

function onSubmitValidate()
	{
	var finaltotal=document.mainform.total.value;
	if(isNaN(finaltotal))
	{ 
	alert("Please Enter all fields Properly");
	return false;
	} 
	else{
	return  fnCheckDate(document.mainform.datevalue.value,"Date")
	return true;
	}
	}//onSubmitValidate
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<SCRIPT language=javascript >

function setfocus1()
	{
	document.mainform.finalduedate.focus()
	}
</script>

</head>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<!-- onSubmit='return onSubmitValidate()' -->
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG" onload = "setfocus1()">
<FORM name=mainform
action="EditCgtSaleUpdate.jsp" method=post >

<TABLE borderColor=skyblue border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<tr><td>

<TABLE  borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<tr><td>


<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0 >
<input type=hidden  name=salesperson_id  value='<%=salesperson_id%>' >
<input type=hidden name=receive_id value=<%=receive_id%>>
<input type=hidden name=no_lots value='<%=counter%>'>
<input type=hidden name=old_lots value=<%=old_lots%>>
<input type=hidden name=oldreceive_no value=<%=oldreceive_no%>>

<input type=hidden name="stockdate" value="<%=stockdate%>">
<input type=hidden name="stockdateold" value="<%=stockdateold%>">

<input type=hidden name="due_dateold" value="<%=due_dateold%>">


<input type=hidden name="finalduedays" value="<%=finalduedays%>">

<input type=hidden name="stockdateold" value="<%=stockdateold%>">

<tr bgcolor=skyblue>
<th colspan=10 align=center>Edit Consignment</th>
</tr>
<tr><td colspan=10><hr></td></tr>
<tr>

	<td>No - <input type=hidden name=consignment_no size=5 value="<%=consignment_no%>" onBlur='return nullvalidation(this)'><%=consignment_no%> </td>
<td>Ref No - <input type=hidden name=ref_no size=5 value="<%=ref_no%>"><%=ref_no%> </td>



<td>To  : 
<%
String condition="Where Super=0  and Purchase=1 and active=1";
%>
<%
String party_name= A.getName(conp,"companyparty",companyparty_id);
	//=A.getMasterArrayCondition("companyparty","companyparty_id",companyparty_id,condition ,company_id) 

%>
<input type=hidden name=companyparty_id value="<%=companyparty_id%>">
<%=party_name%>
</td>
	<!--
<td colspan=1>From  : <%//=company_name%></td>-->
 


<td colspan=2>Sale Group : <%=A.getNameCondition(conp,"Master_PurchaseSaleGroup","PurchaseSaleGroup_Name","where PurchaseSaleGroup_Id="+purchasesalegroup_id)%>
<input type=hidden name=purchasesalegroup_id value='<%=purchasesalegroup_id%>'>
</td>

 	<td  colspan=2 >Due Days -<input type=hidden name=duedays size=1 value="<%=duedays%>" onBlur="validate(this)" style="text-align:right"> <input type=hidden name=duedaysold size=1 value="<%=duedaysold%>" onBlur="validate(this)" style="text-align:right"><%=duedays%></td></tr>


 


</tr>
<tr>
<td >Receive Date - <input type=hidden name=datevalue size=8 value="<%=receive_date%>" onblur='return  fnCheckDate(this.value,"Date")'><%=receive_date%></td>
  	<td>Stock Date</td><td><%=stockdate%></td>

<td>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.finalduedate, \"dd/mm/yyyy\")' value='Due Date' style='font-size:11px ;  ' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>
<input type=text name='finalduedate' size=5 maxlength=5 value="<%=finalduedate%>"
onblur='return  fnCheckMultiDate(this,"Due Date")' tabindex=1>
</td>

<td>Purchase Person : <%=Loca_name%>
<input type="hidden" name="Loca_id" value="<%=Loca_id%>">
<input type="hidden" name="soldCompNo" value="<%=soldCompNo%>">
</td>

 <%  int rec_cat_id=Integer.parseInt(receive_category_id);
	if(rec_cat_id==0) 
	{%>
<td>Category :All 
<input type=hidden name=receive_category_id value='<%=receive_category_id%>'>
</td>
 <%}

else
	{%>
<td>Category : <%=A.getNameCondition(conp,"Master_LotCategory","LotCategory_Name","where LotCategory_Id="+receive_category_id)%>
<input type=hidden name=receive_category_id value='<%=receive_category_id%>'>
</td>
	<%}%>
</tr>


<tr>
   <td>Location</td>
<td><%=A.getName(conp,"Location",newlocation_id[0])%></td>
</td>
 
<%
if("0".equals(currency_id))
{
local_currencysymbol="US $";	
%>
 <input type=hidden name=currency value=dollar> 
 
<% } else {
local_currencysymbol=local_currencysymbol;
%> 
 <input type=hidden name=currency value=local> 
<% } %> 
 

<td>Sales Person </td>
<td><%=A.getNameCondition(cong,"Master_SalesPerson","salesperson_Name","where salesperson_id="+salesperson_id + " and  company_id= "+company_id+"")%>
<input type=hidden name=salesperson_id value='<%=salesperson_id%>' >
</td>
<td colspan=1>Exchange Rate </td><td><input type=hidden name=exchange_rate value="<%=str.format(exchange_rate)%>" onBlur="validate(this)"  size=4 style="text-align:right"><%=str.format(exchange_rate)%>
</td>
</tr>

</table>
</td></tr>

<tr><td>&nbsp;</td></tr>

<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0>
<tr>
<td>Sr No</td>
<td>Lot No</td>
<!-- <td>Pcs</td>
 --><td>Quantity<br>(Carat)</td>
<td>Quantity<br>in Hand</td>
<td>Rate / Unit</td>
<td>Amount in <%=local_currencysymbol%></td>
<td>Remarks</td>
</tr>


<% 
	int deletedcount=0;
	String bg="";
for (int i=0;i<counter-1;i++)
{

	if("yes".equals(deleted[i]))
	{
	deletedcount++;
	bg="bgcolor=red";
	}
	else
	{
		bg="";
	}
	

%>
<tr <%=bg%>><td><%=i+1%></td>
<td>
<input type=hidden name=lotid<%=i%> value="<%=lotid[i]%>">
<input type=hidden name=newlotid<%=i%> value="<%=newlotid[i]%>">
<input type=hidden name=receivetransaction_id<%=i%> value="<%=receivetransaction_id[i]%>">

<input type=hidden name=lotno<%=i%> value="<%=lotno[i]%>"><%=newlotno[i]%> </td>
<input type=hidden name=deleted<%=i%> value='<%=deleted[i]%>' >
<input type=hidden name=newlotno<%=i%> value="<%=newlotno[i]%>">

<input type=hidden name=location_id<%=i%> value="<%=location_id[i]%>"> 
<input type=hidden name=newlocation_id<%=i%> value="<%=newlocation_id[i]%>"> 
<!-- <td align="right"> --><input type=hidden name=pcs<%=i%> value="<%=pcs[i]%>" onBlur="validate(this)" size=2 style="text-align:right"><%//=pcs[i]%><!-- </td> -->
<td align="right">
	<input type=hidden name=old_quantity<%=i%> value="<%=old_quantity[i]%>">
	<input type=hidden name=quantity<%=i%> value="<%=quantity[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right"><%=quantity[i]%>
</td>
		<% if(qtyinhand[i]<=0){%>
<td><font class=msgred><%=qtyinhand[i]%></font></td>
<%}else{%>
<td><%=qtyinhand[i]%></td>
<%}%>

<td align="right"><input type=hidden name=rate<%=i%> value="<%=rate[i]%>" size=5 OnBlur='return calcTotal(this)' style="text-align:right"><%=str.mathformat(rate[i],d)%></td>
<td align="right"><input type=hidden name=amount<%=i%> value="<%=amount[i]%>"  style="text-align:right" readonly><%=str.format(""+amount[i],d)%>
<%//=(str.format(""+(rate[i]*amount[i]),2))%> </td>
<td><input type=hidden name=remarks<%=i%> value="<%=remarks[i]%>" size=8><%=remarks[i]%></td>
</tr>

<%
}//end for
%>
</table>
</td>
</tr>


<input type=hidden name=deletedcount value='<%=deletedcount%>' >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=0>

<tr>
<td width=62% align=right> Sub Total in <%=local_currencysymbol%></td>
<td width=24% align="right"><input type=hidden name=subtotal size=8 readonly value="<%=subtotal%>" style="text-align:right"><%=str.format(""+subtotal,d)%></td>
</tr>

<!-- <tr>
<td colspan=1></td>
<td colspan=3>Discount (%)</td>
<td colspan=1 align="right"><input type=hidden name=discount size=8 OnBlur='return calcTotal(this)' value="<%//=discount%>" style="text-align:right"><%//=discount%></td>
<td colspan=1 align="right"><input type=hidden name=discount_amt size=8 readonly style="text-align:right" value="<%//=discount_amount%>"> <%//=str.format(""+discount_amount,d)%></td>
<td colspan=2></td>
</tr>
 -->
 

 <input type=hidden name=ctax size=8  value="0" style="text-align:right">
<input type=hidden name=ctax_amt size=8 OnBlur='return calcTotal(this)' style="text-align:right" value="0"></td>


<tr>

<td width=62% align=right>Total in <%=local_currencysymbol%></td>
<td width=24% align="right"><input type=hidden readonly name=total size=8 value="<%=total_amount%>" style="text-align:right"> <%=str.format(""+total_amount,d)%> </td>
</tr>
<tr>
<td align=left>Narration:
<%=description%></td><td><input type=hidden size=75 name=description value="<%=description%>"></td>

</tr>

<!--<tr><td colspan=2>&nbsp;</td></tr>-->
<td colspan=8 align=center>
<input type=button name=command value=BACK onClick='history.go(-1)'  class='button1' tabindex=3 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp; &nbsp;&nbsp;<input type=submit name=command value=UPDATE class='button1' tabindex=2 onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</tr>
</TABLE>
</td></tr>
</table>

</FORM>
</BODY>
</HTML>
<% 
	} // if no_i
//C.returnConnection(conp);
//C.returnConnection(cong);

}//end else lots present check

C.returnConnection(conp);
C.returnConnection(cong);
}//if Next

	
}
catch(Exception Samyak1031){ 
out.println("<font color=red> FileName : EdirPurchaseForm.jsp command=sedit<br>Bug No Samyak1031 : "+ Samyak1031);}
%>

<!-- --------------------------------------------------------
							NEXT Form End 
--------------------------------------------------------  -->








