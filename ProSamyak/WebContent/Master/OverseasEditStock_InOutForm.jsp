<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<html>
<head>
<title>Samyak Software </title>
<script language="JavaScript">

function disrtclick()
{
	//window.event.returnValue=0;
}
</script>

<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT language=javascript src="../Samyak/SamyakYearEndDate.js"></script>

<SCRIPT language=javascript src="../Samyak/Samyakmultidate.js"></script>

<SCRIPT language=javascript src="../Samyak/actb.js"></script>

<SCRIPT language=javascript src="../Samyak/common.js"></script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<% 
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection conp = null;
Connection cong = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;

try	
{
	conp=C.getConnection();
	cong=C.getConnection();
}
catch(Exception Samyak31)
{ 
out.println("<font color=red> FileName : Stock_InOut.jsp<br>Bug No Samyak31 : "+ Samyak31);
}
//out.println("<br> 49");
String errLine="50";
String user_name = ""+session.getValue("user_name");
int user_level = Integer.parseInt(""+session.getValue("user_level"));
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String loginLocation_id= A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id);

String companyparty_id=""+ company_id;
String company_name="";
String company_address="";
String company_city="";
String company_country="";
String company_phone_off="";

String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+company_id;
pstmt_p = conp.prepareStatement(company_query);
//System.out.println(company_query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
	//System.out.println("Inside While 50");
	company_name= rs_g.getString("CompanyParty_Name");	company_address= rs_g.getString("Address1");	
	company_city= rs_g.getString("City");		
	company_country= rs_g.getString("Country");		
	company_phone_off= rs_g.getString("Phone_Off");		
}
pstmt_p.close();

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_date=format.format(D);
String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+2,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);


// logic to get local currecy 
String local_currencyid=local_currency;
String local_currencysymbol= local_symbol;
String base_exchangerate= I.getLocalExchangeRate(conp,company_id);
String local_currencyname= ""; //A.getName("Currency",local_currencyid);
// end of local currecy logic
String command = request.getParameter("command");
 //out.println("<center>command is "+command+"</center>");
String location_id0=""+request.getParameter("location_id0");
//String currency1=request.getParameter("currency");	
location_id0="11";

//String oldLotRows= request.getParameter("oldLotRows");
//String lotRows= request.getParameter("lotRows");
//int oldRow=0;
//oldRow=Integer.parseInt(oldLotRows);
//String lotidnew[]= request.getParameterValues("lotidnew");
//String lotidn[]= request.getParameterValues("lotidn");

//for(int j=0; j<oldRow ;j++)
//{
//	out.print("<br>117 lotidnew="+lotidnew[j]);
//}
//for(int j=0; j<oldRow ;j++)
//{
//	out.print("<br>127 lotno="+request.getParameter("lotno"+j));
//}


String companyparty_name= request.getParameter("companyparty_name");
companyparty_name="ABC ";
String purchasesalegroup_id= request.getParameter("purchasesalegroup_id");
purchasesalegroup_id="11";
String duedays= request.getParameter("duedays");
duedays="11";
String duedate= request.getParameter("duedate");
duedate=today_date;
String category_id= request.getParameter("category_id");
category_id="11";
String purchaseperson_id= request.getParameter("purchaseperson_id");
purchaseperson_id="11";
String broker_id=request.getParameter("broker_id");
broker_id="11";
String broker_remarks= request.getParameter("broker_remarks");
broker_remarks="11";
String ReceiveBy_Name= request.getParameter("ReceiveBy_Name");
ReceiveBy_Name="abc person";


String refReceive_Id = request.getParameter("refReceive_Id");
String currReceive_Id = request.getParameter("currReceive_Id");
//out.println("<br>158 currReceive_Id="+currReceive_Id);
errLine="157";
try{
if("Default". equals(command))
{
errLine="164";
String sreceive_Id = request.getParameter("Receive_Id");
//out.print("<br> 166 sreceive_Id="+sreceive_Id);
String dreceive_Id=""+(Integer.parseInt(sreceive_Id)+1);

//out.print()
errLine="167";

String temp_v_id = ""+A.getNameCondition(conp,"Voucher","Voucher_Id"," where Voucher_No='"+sreceive_Id+"'");
String ref_no= ""+A.getNameCondition(conp,"Voucher","Ref_No", "where Voucher_Id="+temp_v_id);
	//out.print("<br> 173"+ref_no);
	 
String description=""+A.getNameCondition(conp,"Voucher","Description","where Voucher_Id="+temp_v_id);

errLine="177";
//String slots = request.getParameter("slots");
String sreceive_currencyId="";
java.sql.Date ReceiveDate = new java.sql.Date(System.currentTimeMillis());
int scounter=0;
String query1="Select Receive_Date,Receive_Lots,receive_currencyId from receive where receive_id="+sreceive_Id;
pstmt_p=conp.prepareStatement(query1);
rs_g = pstmt_p.executeQuery();
while(rs_g.next())
{
  ReceiveDate=rs_g.getDate("Receive_Date");
  scounter=rs_g.getInt("Receive_Lots");
  sreceive_currencyId=rs_g.getString("receive_currencyId");
}
pstmt_p.close();
//ReceiveDate=format.format(ReceiveDate);
int dcounter=scounter;
int Tempsold_lots =scounter;
int Tempdold_lots =Tempsold_lots;

//int  scounter=1;//Integer.parseInt(request.getParameter("scounter"));
//int  dcounter=1;//Integer.parseInt(request.getParameter("dcounter"));
//String dlots = request.getParameter("dlots");
String message=request.getParameter("message");
String StockTransfer_Type=request.getParameter("StockTransfer_Type");
String voucher_no=request.getParameter("voucher_no");

String currency="";//+request.getParameter("currency");
//out.print("<br>206 currency="+sreceive_currencyId);
if("0".equals(sreceive_currencyId))
{
currency="dollar";
}
else
{currency="local";}
//String cgtNo=""+request.getParameter("cgtNo");
//String againstRec_Id = request.getParameter("againstRec_Id");
errLine="196";
String slotid[]=new String[scounter];
String slocation_id[]=new String[scounter];
	double sqty[]=new double[scounter];
	double srate[]=new double[scounter];
	double sdollarrate[]=new double[scounter];
	double samount[]=new double[scounter];
	double sdollaramount[]=new double[scounter];
	String sReceiveTransaction_Id[]=new String[scounter];
	
	double stotalqty=0;
	double stotalamount=0;
	double stotaldollaramount=0;
	String dlotid[]=new String[dcounter];
	String dlocation_id[]=new String[dcounter];
	double dqty[]=new double[dcounter];
	double drate[]=new double[dcounter];
	double ddollarrate[]=new double[dcounter];
	double damount[]=new double[dcounter];
	double ddollaramount[]=new double[dcounter];
	String dReceiveTransaction_Id[]=new String[dcounter];
	String dRemarks[]=new String[dcounter];
	double dtotalqty=0;
	double dtotalamount=0;
	double dtotaldollaramount=0;
	errLine="221";
String query="";
//	out.print("<br> 163 Except Gain");
	query="select ReceiveTransaction_Id,Lot_Id, Quantity, Local_Price,Dollar_Price,Location_Id from Receive_Transaction where Receive_Id="+sreceive_Id+" order by Lot_SrNo";

	pstmt_p=conp.prepareStatement(query);
	rs_g=pstmt_p.executeQuery();
	errLine="228";
	int s=0;
	while(rs_g.next())
		{
			errLine="233";
			sReceiveTransaction_Id[s] = rs_g.getString("ReceiveTransaction_Id");
			slotid[s]=rs_g.getString("Lot_Id");
		//out.print("<br> slotid[s]"+slotid[s]);	
			sqty[s]=rs_g.getDouble("Quantity");
			stotalqty+=sqty[s];
			srate[s]=rs_g.getDouble("Local_Price");
			sdollarrate[s]=rs_g.getDouble("Dollar_Price");
			

errLine="241";	samount[s]=Double.parseDouble(str.mathformat(""+(sqty[s]*srate[s]),d) );
	sdollaramount[s]=Double.parseDouble(str.mathformat(""+(sqty[s]*sdollarrate[s]),3) );
	stotalamount+=samount[s];
	stotaldollaramount+=sdollaramount[s];
			slocation_id[s]=rs_g.getString("Location_Id");
			s++;
		}
	pstmt_p.close();
		
	//System.out.print("<br> 163 Except dreceive_Id"+dreceive_Id);

	query="select ReceiveTransaction_Id,Lot_Id, Quantity, Local_Price,Dollar_Price,Remarks,Location_Id from Receive_Transaction where Receive_Id="+dreceive_Id+" order by Lot_SrNo";
	errLine="253";
	pstmt_g=cong.prepareStatement(query);
	rs_p=pstmt_g.executeQuery();
	int ds=0;
	while(rs_p.next())
		{
			dReceiveTransaction_Id[ds] = rs_p.getString("ReceiveTransaction_Id");
			dlotid[ds]=rs_p.getString("Lot_Id");
			
			dqty[ds]=rs_p.getDouble("Quantity");
			
			dtotalqty+=dqty[ds];
			drate[ds]=rs_p.getDouble("Local_Price");
			ddollarrate[ds]=rs_p.getDouble("Dollar_Price");
			dRemarks[ds]=rs_p.getString("Remarks");
		//System.out.print("dRemarks"+dRemarks[ds]);
	damount[ds]=Double.parseDouble(str.mathformat(""+(dqty[ds]*drate[ds]),d) );
	ddollaramount[ds]=Double.parseDouble(str.mathformat(""+(dqty[ds]*ddollarrate[ds]),3) );
	dtotalamount+=damount[ds];
	dtotaldollaramount+=ddollaramount[ds];
			dlocation_id[ds]=rs_p.getString("Location_Id");
		//out.print("dlocation_id[ds]"+dlocation_id[ds]);
			ds++;
		}
		errLine="275";
	pstmt_g.close();
		

	String Lot_No[] = new String[dcounter];
	int Desciption_Id[] = new int[dcounter];
	String Desciption_Name[] = new String[dcounter];
	int Size_Id[] = new int[dcounter];
	String Size_Name[] = new String[dcounter];
//ErrLine="441";
	for (int  i=0;i<dcounter;i++)
	{
		String lotQuery = "SELECT Lot_No, D_Size, Description_Id FROM Lot L, Diamond D WHERE L.Lot_Id=D.Lot_Id AND D.Lot_Id="+dlotid[i]+" AND L.Active=1";
	
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

 if("4".equals(StockTransfer_Type) /*&& srcLotPresent*/)
 {%>



	<script language="javascript">

	function nullvalidation(name)
	{
	if(name.value =="") 
	{ 
	alert("Please Enter No "); 
	name.focus();
	}
	}// validate

	<%
	String descQuery = "Select Description_Name from Master_Description where Active=1 order by Sr_No";
		
	pstmt_p = conp.prepareStatement(descQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var descArray=new Array("+descArray+");");


	String sizeQuery = "Select Size_Name from Master_Size where Active=1 order by Sr_No";
		
	pstmt_p = conp.prepareStatement(sizeQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
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
	pstmt_p.close();
	out.print("var sizeArray=new Array("+sizeArray+");");
	
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

	errLine="329";
	%>

	</script>
	
	<script language="javascript">
	
	
	function chkQuantity(RowNum)
	{
		var quantity= "sqty"+RowNum;
		var origQty= "spendingqty"+RowNum;

		if(document.mainform.elements[quantity].value > document.mainform.elements[origQty].value)
		{
			alert("Quantity should not be greater than Original Quantity");
		
			document.mainform.elements[quantity].value=document.mainform.elements[origQty].value;

			document.mainform.elements[quantity].setfocus=true;

			return false;
		}
		else
		{
			return true;
		}

	}// end of chkQuantity


	
	function calcAmounts(rowNum)
	{
		//alert("Dest");
		//var exch_rate=<%=str.format(base_exchangerate)%>;
		var exch_rate=document.mainform.exchange_rate.value;
		var rate = "drate"+rowNum;// dollar rate
		var localrate="dlocalrate"+rowNum;
		var quantity = "dqty"+rowNum;
		var amount = "damount"+rowNum;//dollar amount
		var localamount = "dlocalamount"+rowNum;//local amount
		
		
		if(document.mainform.currency[1].checked)
		{
			document.mainform.elements[localrate].value=parseFloat(document.mainform.elements[rate].value)*(parseFloat(exch_rate));
		}
		if(document.mainform.currency[0].checked)
		{
			document.mainform.elements[rate].value=(parseFloat(document.mainform.elements[localrate].value)/(parseFloat(exch_rate))).toFixed(3);
		}
		validate(document.mainform.elements[quantity],3) 
		
		document.mainform.elements[amount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value)).toFixed(3);

		document.mainform.elements[localamount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value) * parseFloat(exch_rate)).toFixed(3);

		/* calculate QtTotal */
		
		temp_QtTotal=parseFloat(document.mainform.dtotalqty.value);
		//alert("temp_QtTotal="+temp_QtTotal);
		temp_QtTotal=temp_QtTotal-oldqt;
		temp_QtTotal=temp_QtTotal+parseFloat(document.mainform.elements[quantity].value);
		document.mainform.dtotalqty.value=temp_QtTotal.toFixed(3);
		//document.mainform.sqty0.value=temp_QtTotal.toFixed(3);
		
		
		//alert('for Dollar Total');
		/* calculate     Dollar    Amount */
		temp_AmtTotal=parseFloat(document.mainform.dtotalamount.value);
		
		temp_AmtTotal=temp_AmtTotal-oldamt;
		//alert('temp_AmtTotal2='+temp_AmtTotal);	
		temp_AmtTotal=temp_AmtTotal+parseFloat(document.mainform.elements[amount].value);
		//alert('temp_AmtTotal2='+temp_AmtTotal);	
		document.mainform.dtotalamount.value=temp_AmtTotal.toFixed(3);
		
		
		/* calculate    Local    Amount */
		temp_LocalAmtTotal=parseFloat(document.mainform.dlocaltotalamount.value);
		temp_LocalAmtTotal=temp_LocalAmtTotal-oldlamt;
		temp_LocalAmtTotal=temp_LocalAmtTotal+parseFloat(document.mainform.elements[localamount].value);
		document.mainform.dlocaltotalamount.value=temp_LocalAmtTotal.toFixed(3);

		//document.mainform.elements[localrate].value=(temp_LocalAmtTotal/temp_QtTotal).toFixed(3);
		//return true;
			
	
	//  for source lot

		var srate = "srate"+rowNum;// dollar rate
		var slocalrate="slocalrate"+rowNum;
		var squantity = "sqty"+rowNum;
		var samount = "samount"+rowNum;//dollar amount
		var slocalamount = "slocalamount"+rowNum;//local amount
		document.mainform.elements[srate].value=document.mainform.elements[rate].value;
		document.mainform.elements[slocalrate].value=document.mainform.elements[localrate].value;
		document.mainform.elements[squantity].value=document.mainform.elements[quantity].value;
		document.mainform.elements[samount].value=document.mainform.elements[amount].value;
		document.mainform.elements[slocalamount].value=document.mainform.elements[localamount].value;
		document.mainform.stotalqty.value=document.mainform.dtotalqty.value;
		//alert("document.mainform.stotalqty.value="+document.mainform.stotalqty.value);	document.mainform.stotalamount.value=document.mainform.dtotalamount.value;
		document.mainform.slocaltotalamount.value=document.mainform.dlocaltotalamount.value;

	}
	
	
	function setSourceLot(slot)
	{
		document.mainform.saddlots.value=slot.value;
		//alert(document.mainform.saddlots.value);
	}
	oldqt=0;
	oldamt=0;
	oldlamt=0;
	/*function setOldSrcQt(rowNum)
	{
			//alert('Cols num'+rowNum);
			var oldquantity="sqty"+rowNum;
			oldqt=parseFloat(document.mainform.elements[oldquantity].value);	
			//alert('oldqt='+oldqt);
			
			var oldsamount="samount"+rowNum;
			oldamt=parseFloat(document.mainform.elements[oldsamount].value);	
			//alert('oldqt='+oldqt);

			var oldslocalamount="slocalamount"+rowNum;
			oldlamt=parseFloat(document.mainform.elements[oldslocalamount].value);	
			//alert('oldqt='+oldqt);
			
			return true;
	 }*/
	
	function setOldDestQt(rowNum)
	{
			
			//alert('rowNum='+rowNum);
			var oldquantity="dqty"+rowNum;
			oldqt=parseFloat(document.mainform.elements[oldquantity].value);	
			//alert('oldqt='+oldqt);
			
			var oldsamount="damount"+rowNum;
			oldamt=parseFloat(document.mainform.elements[oldsamount].value);	
			//alert('oldqt='+oldamt);

			var oldslocalamount="dlocalamount"+rowNum;
			oldlamt=parseFloat(document.mainform.elements[oldslocalamount].value);	
			//alert('oldqt='+oldlamt);
			
			return true;
	 }
	function calRateAmount()
	{
			//alert("RateAmount");
		/*	var slots=document.mainform.scounter1.value;
			var dlots=document.mainform.dcounter.value;
			//alert("slots="+slots);
			//alert("dlots="+dlots);
			for(cnt=0;cnt<slots;cnt++)
			{
				
				setOldSrcQt(cnt);
				calcAmounts1(cnt);
			}
			for(cnt=0;cnt<dlots;cnt++)
			{
				
				setOldDestQt(cnt);
				calcAmounts(cnt);
			}
			*/

			
		/*setOldSrcQt("0");
		calcAmounts1("0");
		setOldDestQt("0");
		calcAmounts("0");*/

		
	
	}
	/*function calcAmounts1(rowNum)
	{
		//alert("hi datta here");
		//alert('row='+rowNum);
		//var exch_rate=<%=str.format(base_exchangerate)%>;
		var exch_rate=1;//document.mainform.exchange_rate.value;
		var rate = "srate"+rowNum;// dollar rate
		var localrate="slocalrate"+rowNum;
		var quantity = "sqty"+rowNum;
		var amount = "samount"+rowNum;//dollar amount
		var localamount = "slocalamount"+rowNum;//local amount
		
		
		if(document.mainform.currency[1].checked)
		{
		document.mainform.elements[localrate].value=parseFloat(document.mainform.elements[rate].value)*(parseFloat(exch_rate));
		}
		if(document.mainform.currency[0].checked)
		{
			document.mainform.elements[rate].value=(parseFloat(document.mainform.elements[localrate].value)/(parseFloat(exch_rate))).toFixed(3);
		}
		validate(document.mainform.elements[quantity],3) 
		
		document.mainform.elements[amount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value)).toFixed(3);

		document.mainform.elements[localamount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value) * parseFloat(exch_rate)).toFixed(3);

		 calculate QtTotal 
		//alert('for Qt Total');
		temp_QtTotal=parseFloat(document.mainform.stotalqty.value);
		alert("temp_QtTotal="+temp_QtTotal);
		alert("oldqt="+oldqt);
		temp_QtTotal=temp_QtTotal-oldqt;
		temp_QtTotal=temp_QtTotal+parseFloat(document.mainform.elements[quantity].value);
		document.mainform.stotalqty.value=temp_QtTotal.toFixed(3);

		
		//alert('for Dollar Total');
		 calculate     Dollar    Amount
		temp_AmtTotal=parseFloat(document.mainform.stotalamount.value);
		//alert('temp_AmtTotal1='+temp_AmtTotal);
		//alert('oldamt='+oldamt);
		temp_AmtTotal=temp_AmtTotal-oldamt;
		//alert('temp_AmtTotal2='+temp_AmtTotal);	
		temp_AmtTotal=temp_AmtTotal+parseFloat(document.mainform.elements[amount].value);
		//alert('temp_AmtTotal2='+temp_AmtTotal);	
		document.mainform.stotalamount.value=temp_AmtTotal.toFixed(3);
		
		
		 calculate    Local    Amount 
		temp_LocalAmtTotal=parseFloat(document.mainform.slocaltotalamount.value);
		temp_LocalAmtTotal=temp_LocalAmtTotal-oldlamt;
		temp_LocalAmtTotal=temp_LocalAmtTotal+parseFloat(document.mainform.elements[localamount].value);
		document.mainform.slocaltotalamount.value=temp_LocalAmtTotal.toFixed(3);
		//alert("1349 temp_LocalAmtTotal"+temp_LocalAmtTotal);
		//return true;
			
	}*/
	/*function calcAmounts2(rowNum)
	{
		
		var rate = "drate"+rowNum;// dollar rate
		var localrate="dlocalrate"+rowNum;
		var quantity = "dqty"+rowNum;
		var amount = "damount"+rowNum;//dollar amount
		var localamount = "dlocalamount"+rowNum;//local amount
		
		var srate = "srate"+rowNum;// dollar rate
		var slocalrate="slocalrate"+rowNum;
		var squantity = "sqty"+rowNum;
		var samount = "samount"+rowNum;//dollar amount
		var slocalamount = "slocalamount"+rowNum;//local amount
		//document.mainform.elements[squantity].value=document.mainform.elements[quantity].value;
		document.mainform.elements[srate].value=document.mainform.elements[rate].value
		document.mainform.elements[slocalrate].value=document.mainform.elements[localrate].value
		document.mainform.elements[samount].value=document.mainform.elements[amount].value
		document.mainform.elements[slocalamount].value=document.mainform.mainform.elements[localamount].value
		document.mainform.stotalamount.value=document.mainform.dtotalamount.value;
		document.mainform.slocaltotalamount.value=document.mainform.dlocaltotalamount.value;
		return true;
				
	}*/

	function checkCurrency()
	{
			
			if(document.mainform.currency[0].checked)
			{
					
					for(i=0;i<<%=scounter%>;i++)
					{
					var slocalrate="slocalrate"+i;
					var srate="srate"+i;
					
					document.mainform.elements[slocalrate].readOnly=false;
					document.mainform.elements[slocalrate].style.backgroundColor="FFFFFF";
					document.mainform.elements[srate].readOnly=true;
					document.mainform.elements[srate].style.backgroundColor="CCCCFF";
					
					}
					for(i=0;i<<%=dcounter%>;i++)
					{
					var dlocalrate="dlocalrate"+i;
					var drate="drate"+i;
					
					document.mainform.elements[dlocalrate].readOnly=false;
					document.mainform.elements[dlocalrate].style.backgroundColor="FFFFFF";
					document.mainform.elements[drate].readOnly=true;
					document.mainform.elements[drate].style.backgroundColor="CCCCFF";
					
					}

			}
			if(document.mainform.currency[1].checked) 
			{
					
					for(i=0;i<<%=scounter%>;i++)
					{
					var slocalrate="slocalrate"+i;
					var srate="srate"+i;
					document.mainform.elements[srate].readOnly=false;
					document.mainform.elements[srate].style.backgroundColor="FFFFFF";
					document.mainform.elements[slocalrate].readOnly=true;
					document.mainform.elements[slocalrate].style.backgroundColor="CCCCFF";	
					
					}
					for(i=0;i<<%=dcounter%>;i++)
					{
					var dlocalrate="dlocalrate"+i;
					var drate="drate"+i;
					document.mainform.elements[drate].readOnly=false;
					document.mainform.elements[drate].style.backgroundColor="FFFFFF";
					document.mainform.elements[dlocalrate].readOnly=true;
					document.mainform.elements[dlocalrate].style.backgroundColor="CCCCFF";	
					
					}
			}
	}
	function setCurrency()
	{
		checkCurrency();
	}
	</script>
	<!--endof ScriptDefaultform start at 106-->
	<META HTTP-EQUIV="Expires" CONTENT="0">
	</head>

	<body bgColor=#ffffee  onLoad="document.mainform.ref_no.focus();" background="../Buttons/BGCOLOR.JPG">
	<FORM name=mainform action="OverseasEditStock_InOutForm.jsp" method=post>
	<input type=hidden name=lotno value=<%//=strLotNo%>>
	<input type=hidden name=strRT_Id value=<%//=strRT_Id%>>
	<input type=hidden name=cgtNo value=<%//=cgtNo%>>
	<input type=hidden name=no_lots value=<%//=scounter%>>
	<input type=hidden name=lotfocus>
	<input type="hidden" name="StockTransfer_Type" value="<%="4"%>">
	<input type=hidden name="sold_lots" value="<%=scounter%>">
	<input type=hidden name="Tempsold_lots" value="<%=Tempsold_lots%>">
	<input type=hidden name="Tempdold_lots" value="<%=Tempdold_lots%>">
	<input type=hidden name="dold_lots" value="<%=dcounter%>">
	<input type=hidden name="sreceive_Id" value="<%=sreceive_Id%>">
	<input type=hidden name="dreceive_Id" value="<%=dreceive_Id%>">
	<input type=hidden name="scounter1" value="<%=scounter%>">
	<input type=hidden name="dcounter" value="<%=dcounter%>">
	<%errLine="646";%>

 <TABLE align=center borderColor=Skyblue border=1 WIDTH="85%">

 <tr>
 <th colspan=10 align=center> Edit Stock In / Out</th>
 </tr>
 <tr>
	<td colspan=10>
	<table >
	<tr>
	<td colspan=2>Inv No:
	<input type=text name=stocktransfer_no size=5 onBlur='return nullvalidation(this)' value="<%=voucher_no%>"
	style="text-align:left;background:#CCCCFF" readonly>
	</td>
	<td colspan=2>Ref. No:
	<input type=text name=ref_no value="<%=ref_no%> " size=10 maxlength=10 onfocus="this.select();" tabindex=1 ></td>
	<td colspan=2><script language='javascript'>
	if(!document.layers) {
	document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value=' Transfer Date' tabindex=2 style='font-size:11px ; width:100'> ")
		} 
	</script>
	<input type=text name=datevalue size=8 value="<%=format.format(ReceiveDate)%>" tabindex=3 onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);' onfocus="this.select();" OnKeyUp="checkMe(this);"></td>
	<td colspan=2>Currency:
	<%if("local".equals(currency)){%>
	<input type=radio name=currency value=local tabindex=4 checked
	onclick="mainform.currency.value='local';checkCurrency()">Local
	<input type=radio name=currency value=dollar onclick="mainform.currency.value='Dollar';checkCurrency()">Dollar
	</td>
	<%}
	if("dollar".equals(currency))
	{
	%>
	<input type=radio name=currency value=local tabindex=4 
	 onclick="mainform.currency.value='local';checkCurrency()">Local
	<input type=radio name=currency value=dollar checked onclick="mainform.currency.value='Dollar';checkCurrency()">Dollar
	</td>
	<%}%>
	<td>&nbsp;</td>
	<td colspan=2>Exchange Rate:
	<input type=text name=exchange_rate value="<%=str.mathformat(""+base_exchangerate,2)%>" tabindex=5 size=4 onBlur="validate(this,2); calRateAmount();" style="text-align:right" onfocus="this.select();">
	</td>
	</tr>
	</table>
	</td></tr>
<tr>
<td>
	<table bordercolor=silver border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >	
<% if(dcounter>0)
		{
%>

<tr>
<th colspan=8> Source Lots </th><th colspan=2 bordercolor=skyblue> Destination Lots</th>
</tr>
<tr>
	<td>Sr. No.</td>
	<td>From <br>Location</td>
	<td>Lot No.</td> 
	<td>Qty</td>
    <td>Rate ($)</td>
	<td>Rate (<%=local_symbol%>)</td>
	<td>Amount ($)</td>
	<td>Amount (<%=local_symbol%>)</td>
	<td bordercolor=skyblue>To<br>Location</td>
	<td bordercolor=skyblue>Destination Lot No.</td>
	<td>Remarks</td>
 	
 </tr>
<%
for(int i=0;i<dcounter;i++)
	{%>
<tr>
	<td><%=i+1%></td>
	 <td ><%=A.getMasterArrayCondition(conp,"Location","slocation_id"+i,slocation_id[i],"where company_id="+company_id+" and Active=1")%></td>

	<td><input type=text name="slotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+slotid[i])%>" size=5  id="slotno<%=i%>" onblur="getDescSize('<%=company_id%>', document.mainform.dlotno<%=i%>.value, document.mainform.datevalue.value, 'slotid<%=i%>','ddescriptionname<%=i%>', 'dsizename<%=i%>', 'drate<%=i%>', 'ddescriptionname<%=i%>', 'purchase' );" autocomplete=off onfocus="this.select();">
	<input type=hidden name="slotid<%=i%>" value="" id="slotid<%=i%>"
	></td>
     
	<input type=hidden name="ddescriptionname<%=i%>" value="<%=Desciption_Name[i]%>" size=5 style="text-align:left" id="ddescriptionname<%=i%>" autocomplete=off onfocus="this.select();">
	<input type=hidden name="dsizename<%=i%>" value="<%=Size_Name[i]%>" size=5 style="text-align:left" id="dsizename<%=i%>" onfocus="this.select();">
	<!-- code for destination location -->
	<%//=A.getMasterArrayCondition(conp,"Location","to_location"+i,"","where company_id="+company_id+" and Active=1")%>	
	<input type=hidden name=to_location<%=i%>>
	
	
	<td><input type=text name="dqty<%=i%>" value="<%=dqty[i]%>"  size=5 style="text-align:right" onFocus="this.select(); return setOldDestQt('<%=i%>');" onBlur="return calcAmounts('<%=i%>'); " >
	</td>
	<input type=hidden name="dReceiveTransaction_Id<%=i%>" value="<%=dReceiveTransaction_Id[i]%>" 	>
    
	<%if(currency.equals("dollar"))
	{%> 	
	<td>
		<input type=text  name="drate<%=i%>" value="<%=ddollarrate[i]%>"  size=5 style="text-align:right" id="drate<%=i%>"
		onBlur="return calcAmounts('<%=i%>'); " onFocus="this.select(); return setOldDestQt('<%=i%>');">
	</td>
			<td><input type=text name="dlocalrate<%=i%>" value="<%=drate[i]%>"  style="text-align:right;background:#CCCCFF" size=5 readOnly onBlur="return calcAmounts('<%=i%>');" onFocus="this.select(); return setOldDestQt('<%=i%>');">
		</td>
	<%}%>

		
	<%if(currency.equals("local"))
	{%>
	
	<td><input type=text name="drate<%=i%>" value="<%=ddollarrate[i]%>"  style="text-align:right;background:#CCCCFF" id="drate<%=i%>" size=5 readOnly onfocus="this.select();return setOldDestQt('<%=i%>');" >
	</td>
	<td>
	<input type=text name="dlocalrate<%=i%>" value="<%=drate[i]%>" size=5 style="text-align:right" onBlur="return calcAmounts('<%=i%>'); " onFocus="this.select(); return setOldDestQt('<%=i%>');"></td>
	<%}%>

	<td><input type=text name="damount<%=i%>" value="<%=ddollaramount[i]%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();" ></td>

	<td><input type=text name="dlocalamount<%=i%>" value="<%=damount[i]%>" style="text-align:right;background:#CCCCFF" readonly size=5 onfocus="this.select();"></td>
		<td bordercolor=skyblue><%=A.getMasterArrayCondition(conp,"Location","tolocation_id"+i,dlocation_id[i],"where company_id="+company_id+" and Active=1")%></td>
	

	<td bordercolor=skyblue><input type=text name="dlotno<%=i%>" id="dlotno<%=i%>" value="<%=Lot_No[i]%>" size=5  onblur="return calcAmounts1('<%=i%>');" autocomplete=off onfocus="this.select();">
	<input type=hidden name="dlotid<%=i%>" id="dlotid<%=i%>" value="0" size=5>
	</td>



	<td><input type=text name="dremark<%=i%>" value="<%=dRemarks[i]%>" style="text-align:right" size=5  onfocus="this.select();">
	
	
	

	<input type=hidden name="dlocation_id<%=i%>" value="<%=dlocation_id[i]%>" style="text-align:right" size=5>	
	</td>

	<script language="javascript">
	
	var lobj<%=i%> =new  actb(document.getElementById('dlotno<%=i%>'),lotNoArray);
	
	var dobj<%=i%> =new  actb(document.getElementById('ddescriptionname<%=i%>'),descArray);
	
	var sobj<%=i%> = new  actb(document.getElementById('dsizename<%=i%>'),sizeArray);
	
	</script>	
	

</tr>
<%	}%>
<tr>
	<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
	<td><input type=text name="dtotalqty" value="<%=dtotalqty%>" size=5 style="text-align:right;background:#CCCCFF" readOnly onfocus="this.select();"></td>
	<td colspan=2>&nbsp;</td>
	<td><input type=text name="dtotalamount" value="<%=dtotaldollaramount%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();">
	</td>	
	<td>
	<input type=text name="dlocaltotalamount" value="<%=dtotalamount%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"></td>
	<td>&nbsp;</td>
</tr>



<%}
else	
	{%>

<tr>
	<td height="140" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
	<input type=hidden name="dcounter" value="0">
	<input type=hidden name="daddlots" value="0">

</tr>
<%	}%>


<% if(scounter>0)
		{%>


<%
	double totQuantity=0;
	double totamount=0;
	double totlocalamount=0;

	for(int i=0;i<scounter;i++)
	{%>
	
	<input type=hidden name=rowNo<%=i%> value="<%//=rowNo[i]%>"><!-- this is for use in JScript Fn in Save to diasable checkbox of splitting -->
	<input type=hidden name=againstRT_Id<%=i%> value="<%//=againstRT_Id[i]%>">
	
	<%//=descriptionname[i]%>
	
	<input type=hidden name="sdescriptionname<%=i%>" id="sdescriptionname<%=i%>" value="" size=5 >
	<%//=sizename[i]%>
	<input type=hidden name="ssizename<%=i%>" id="ssizename<%=i%>" value=""  size=5
		>
		<%//=A.getMasterArrayCondition(conp,"Location","from_location"+i,"","where company_id="+company_id+" and Active=1")%>	
		
		<input type=hidden name=from_location<%=i%> value=<%=A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id)%>>
		<input type=hidden  name="sqty<%=i%>" value="<%=sqty[i]%>" size=5 style="text-align:right">
		<input type=hidden name="spendingqty<%=i%>" value="<%//=pendingqty[i]%>" size=5>
		<input type=hidden name="sReceiveTransaction_Id<%=i%>" value="<%=sReceiveTransaction_Id[i]%>" 	>
		<%//out.print("<br>899 sReceiveTransaction_Id[i]="+sReceiveTransaction_Id[i]);%>
	<%if(currency.equals("dollar"))
		{%>
		
			<input type=hidden  name="srate<%=i%>" value="<%=sdollarrate[i]%>" size=5 style="text-align:right" id="srate<%=i%>" >
			
			<input type=hidden  name="slocalrate<%=i%>" value="<%=srate[i]%>" style="text-align:right;background:#CCCCFF" size=5 >
		
		<%}%>
	
	<%if(currency.equals("local"))
		{%>
			<input type=hidden name="srate<%=i%>" value="<%=sdollarrate[i]%>" style="text-align:right;background:#CCCCFF" id="srate<%=i%>" size=5 readOnly >
		
			<input type=hidden name="slocalrate<%=i%>" value="<%=srate[i]%>" size=5 style="text-align:right" >
		
		
		<%}%>
	
	<input type=hidden name="samount<%=i%>" value="<%=sdollaramount[i]%>" size=5 style="text-align:right;background:#CCCCFF" readonly  >

	<input type=hidden name="slocalamount<%=i%>" value="<%=samount[i]%>" style="text-align:right;background:#CCCCFF" readonly  size=5>

	<input type=hidden name="sremark<%=i%>" value="<%=description%>" style="text-align:right" size=5 >
	
	<input type=hidden name="slocation_id<%=i%>" value="<%=slocation_id[i]%>" style="text-align:right" size=5>	
	
<script language="javascript">
	
	
	var lobj<%=i%> =new  actb(document.getElementById('slotno<%=i%>'),lotNoArray);
	
	var dobj<%=i%> =new  actb(document.getElementById('sdescriptionname<%=i%>'),descArray);
	
	var sobj<%=i%> = new  actb(document.getElementById('ssizename<%=i%>'),sizeArray);
	
	</script>
<%	
	//totQuantity += Double.parseDouble(quantity[i]);
	//totamount += Double.parseDouble(amount[i]);
	//totlocalamount =+ Double.parseDouble(localamount[i]);
}%>

	
	
	<!-- <td colspan=2 align=right>Total :&nbsp;&nbsp;</td> -->
	
	<td><input type=hidden name="stotalqty" value="<%=stotalqty%>" size=5 ></td>
	
	<input type=hidden name="stotalamount" value="<%=stotaldollaramount%>" size=5 >
	
	<input type=hidden name="slocaltotalamount" value="<%=stotalamount%>" size=5 >
	
	
	<!-- <input type=hidden name="saddlots" value="1"> -->
	<input type=hidden name=againstRec_Id value="<%//=againstRec_Id%>">
	

<%}
%>

</table>
</td>
</tr>
<table align=center borderColor=Skyblue border=1 WIDTH="86%">
<tr>
<td colspan=12>Narration
<input type=text size=100 name=description value="<%=description%>" onfocus="this.select();"></td>
</tr>
<tr>
	


	 <td colspan=1 align=right>Add Lots: 
	 <input type=text name="daddlots" value="1" size=4 style="text-align:right" onfocus="this.select();"></td>
		
	 <td align=center><input type="submit" name="command" value="Add" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
 
	<td  align=center> 
		<input type="submit" name="command" value="Next" tabindex=14 class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
	</td>
</td>
</tr>
	</table>
<%errLine="659";
		C.returnConnection(conp);	
		C.returnConnection(cong);	
}
else
{
	C.returnConnection(conp);	
	C.returnConnection(cong);	
	%>
	<script>
	function toClose()
	{
		alert("Lot No Does Not Exist");
		window.close();
	}
	</script>
	<body  onLoad='toClose()' >
	</body>
<%}
}
}catch(Exception e)
	{ 
		C.returnConnection(conp);	
		C.returnConnection(cong);	
		out.print("File EditStock_InoutForm.jsp Bug "+e+"errLine="+errLine); 
	}


    /*########################################################## 
	
						      "ADD"

	 ##########################################################*/

try
	{

	if("Add".equals(command))
	{
	errLine="697";
	String message=request.getParameter("message");
	String lotno=""+request.getParameter("lotno");
	String strRT_Id=""+request.getParameter("strRT_Id");
	String againstRec_Id=""+request.getParameter("againstRec_Id");
	String cgtNo=""+request.getParameter("cgtNo");
	String currency=""+request.getParameter("currency");
	String sreceive_Id=""+request.getParameter("sreceive_Id");
	String dreceive_Id=""+request.getParameter("dreceive_Id");
	
	int daddlots=Integer.parseInt(request.getParameter("daddlots"));
	int saddlots=daddlots;//Integer.parseInt(request.getParameter("saddlots"));
	errLine="1021";
	
	int sold_lots=Integer.parseInt(request.getParameter("sold_lots"));
	
	int Tempsold_lots=Integer.parseInt(request.getParameter("Tempsold_lots"));
	//out.print("<br> 1030 Tempsold_lots="+Tempsold_lots);
	
	int Tempdold_lots=Integer.parseInt(request.getParameter("Tempdold_lots"));
	
	int dold_lots=Integer.parseInt(request.getParameter("dold_lots"));
	
	String stotalqty=request.getParameter("stotalqty");
	String stotalamount=""+request.getParameter("stotalamount");
	String slocaltotalamount=request.getParameter("slocaltotalamount");
	String dtotalqty=""+request.getParameter("dtotalqty");
	String dtotalamount=request.getParameter("dtotalamount");
	String dlocaltotalamount=""+request.getParameter("dlocaltotalamount");
	//out.print("<br> 1045 sold_lots "+sold_lots);
	//out.print("<br> 1045 saddlots "+saddlots);
	int scounter=sold_lots+saddlots;
	int dcounter=dold_lots+daddlots;
	errLine="1034";
	
	String StockTransfer_Type=request.getParameter("StockTransfer_Type");

	String ref_no=""+request.getParameter("ref_no");
	String description=""+request.getParameter("description");
	errLine="720";

	if(("4".equals(StockTransfer_Type)) )
	{
	%>

    <script language="javascript">
	function nullvalidation(name)
	{
	if(name.value =="") 
	{ 
	alert("Please Enter No "); 
	name.focus();}
	}// validate



	<%
		String descQuery = "Select Description_Name from Master_Description where Active=1 order by Sr_No";
			
		pstmt_p = conp.prepareStatement(descQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt_p.executeQuery();
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
		pstmt_p.close();
		out.print("var descArray=new Array("+descArray+");");


		String sizeQuery = "Select Size_Name from Master_Size where Active=1 order by Sr_No";
			
		pstmt_p = conp.prepareStatement(sizeQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt_p.executeQuery();
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
		pstmt_p.close();
		out.print("var sizeArray=new Array("+sizeArray+");");
		
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

	</script>


	<script language="javascript">
	
	
	function chkQuantity(RowNum)
	{
		var quantity= "sqty"+RowNum;
		var origQty= "spendingqty"+RowNum;

		if(document.mainform.elements[quantity].value > document.mainform.elements[origQty].value)
		{
			alert("Quantity should not be greater than Original Quantity");
		
			document.mainform.elements[quantity].value=document.mainform.elements[origQty].value;

			document.mainform.elements[quantity].setfocus=true;

			return false;
		}
		else{
			return true;
		}

	}// end of chkQuantity


	
	function calcAmounts(rowNum)
	{
		//alert("Dest");
		//var exch_rate=<%=str.format(base_exchangerate)%>;
		var exch_rate=document.mainform.exchange_rate.value;
		var rate = "drate"+rowNum;// dollar rate
		var localrate="dlocalrate"+rowNum;
		var quantity = "dqty"+rowNum;
		var amount = "damount"+rowNum;//dollar amount
		var localamount = "dlocalamount"+rowNum;//local amount
		
		
		if(document.mainform.currency[1].checked)
		{
			document.mainform.elements[localrate].value=parseFloat(document.mainform.elements[rate].value)*(parseFloat(exch_rate));
		}
		if(document.mainform.currency[0].checked)
		{
			document.mainform.elements[rate].value=(parseFloat(document.mainform.elements[localrate].value)/(parseFloat(exch_rate))).toFixed(3);
		}
		validate(document.mainform.elements[quantity],3) 
		
		document.mainform.elements[amount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value)).toFixed(3);

		document.mainform.elements[localamount].value = (parseFloat(document.mainform.elements[quantity].value) * parseFloat(document.mainform.elements[rate].value) * parseFloat(exch_rate)).toFixed(3);

		/* calculate QtTotal */
		
		temp_QtTotal=parseFloat(document.mainform.dtotalqty.value);
		//alert("temp_QtTotal="+temp_QtTotal);
		temp_QtTotal=temp_QtTotal-oldqt;
		temp_QtTotal=temp_QtTotal+parseFloat(document.mainform.elements[quantity].value);
		document.mainform.dtotalqty.value=temp_QtTotal.toFixed(3);
		
		/* calculate     Dollar    Amount */
		temp_AmtTotal=parseFloat(document.mainform.dtotalamount.value);
		
		temp_AmtTotal=temp_AmtTotal-oldamt;
		
		temp_AmtTotal=temp_AmtTotal+parseFloat(document.mainform.elements[amount].value);
		//alert('temp_AmtTotal2='+temp_AmtTotal);	
		document.mainform.dtotalamount.value=temp_AmtTotal.toFixed(3);
		
		
		/* calculate    Local    Amount */
		temp_LocalAmtTotal=parseFloat(document.mainform.dlocaltotalamount.value);
		temp_LocalAmtTotal=temp_LocalAmtTotal-oldlamt;
		temp_LocalAmtTotal=temp_LocalAmtTotal+parseFloat(document.mainform.elements[localamount].value);
		document.mainform.dlocaltotalamount.value=temp_LocalAmtTotal.toFixed(3);

				
	//  for source lot

		var srate = "srate"+rowNum;// dollar rate
		var slocalrate="slocalrate"+rowNum;
		var squantity = "sqty"+rowNum;
		var samount = "samount"+rowNum;//dollar amount
		var slocalamount = "slocalamount"+rowNum;//local amount
		document.mainform.elements[srate].value=document.mainform.elements[rate].value;
		document.mainform.elements[slocalrate].value=document.mainform.elements[localrate].value;
		document.mainform.elements[squantity].value=document.mainform.elements[quantity].value;
		document.mainform.elements[samount].value=document.mainform.elements[amount].value;
		document.mainform.elements[slocalamount].value=document.mainform.elements[localamount].value;
		document.mainform.stotalqty.value=document.mainform.dtotalqty.value;
		//alert("document.mainform.stotalqty.value="+document.mainform.stotalqty.value);	document.mainform.stotalamount.value=document.mainform.dtotalamount.value;
		document.mainform.slocaltotalamount.value=document.mainform.dlocaltotalamount.value;

	}
	
	
	function setSourceLot(slot)
	{
		document.mainform.saddlots.value=slot.value;
		//alert(document.mainform.saddlots.value);
	}
	oldqt=0;
	oldamt=0;
	oldlamt=0;
	
	
	function setOldDestQt(rowNum)
	{
			
			//alert('rowNum='+rowNum);
			var oldquantity="dqty"+rowNum;
			oldqt=parseFloat(document.mainform.elements[oldquantity].value);	
			//alert('oldqt='+oldqt);
			
			var oldsamount="damount"+rowNum;
			oldamt=parseFloat(document.mainform.elements[oldsamount].value);	
			//alert('oldqt='+oldamt);

			var oldslocalamount="dlocalamount"+rowNum;
			oldlamt=parseFloat(document.mainform.elements[oldslocalamount].value);	
			//alert('oldqt='+oldlamt);
			
			return true;
	 }
	function calRateAmount()
	{

		
	
	}
	

	function checkCurrency()
	{
			
			if(document.mainform.currency[0].checked)
			{
					
					for(i=0;i<<%=scounter%>;i++)
					{
					var slocalrate="slocalrate"+i;
					var srate="srate"+i;
					
					document.mainform.elements[slocalrate].readOnly=false;
					document.mainform.elements[slocalrate].style.backgroundColor="FFFFFF";
					document.mainform.elements[srate].readOnly=true;
					document.mainform.elements[srate].style.backgroundColor="CCCCFF";
					
					}
					for(i=0;i<<%=dcounter%>;i++)
					{
					var dlocalrate="dlocalrate"+i;
					var drate="drate"+i;
					
					document.mainform.elements[dlocalrate].readOnly=false;
					document.mainform.elements[dlocalrate].style.backgroundColor="FFFFFF";
					document.mainform.elements[drate].readOnly=true;
					document.mainform.elements[drate].style.backgroundColor="CCCCFF";
					
					}

			}
			if(document.mainform.currency[1].checked) 
			{
					
					for(i=0;i<<%=scounter%>;i++)
					{
					var slocalrate="slocalrate"+i;
					var srate="srate"+i;
					document.mainform.elements[srate].readOnly=false;
					document.mainform.elements[srate].style.backgroundColor="FFFFFF";
					document.mainform.elements[slocalrate].readOnly=true;
					document.mainform.elements[slocalrate].style.backgroundColor="CCCCFF";	
					
					}
					for(i=0;i<<%=dcounter%>;i++)
					{
					var dlocalrate="dlocalrate"+i;
					var drate="drate"+i;
					document.mainform.elements[drate].readOnly=false;
					document.mainform.elements[drate].style.backgroundColor="FFFFFF";
					document.mainform.elements[dlocalrate].readOnly=true;
					document.mainform.elements[dlocalrate].style.backgroundColor="CCCCFF";	
					
					}
			}
	}
	function setCurrency()
	{
		checkCurrency();
	}
	</script>

	<!--end of ScriptDefaultform start at 106-->
	</head>

	<body bgColor=#ffffee  onLoad="document.mainform.ref_no.focus();setCurrency()" background="../Buttons/BGCOLOR.JPG">
	<!-- <FORM name=mainform action="Stock_InOut.jsp" onSubmit='return onSubmitValidate()' method=post> -->
	<FORM name=mainform action="OverseasEditStock_InOutForm.jsp" method=post
	Onsubmit="return calcAmounts2();">
	<input type=hidden name=lotno value=<%=lotno%>>
	<input type=hidden name=sreceive_Id value=<%=sreceive_Id%>>
	<input type=hidden name=dreceive_Id value=<%=dreceive_Id%>>
	<input type=hidden name=strRT_Id value=<%=strRT_Id%>>
	<input type=hidden name=againstRec_Id value=<%=againstRec_Id%>>
	<input type=hidden name=cgtNo value=<%=cgtNo%>>
	<input type=hidden name=no_lots value=<%=scounter%>>
	<input type=hidden name=lotfocus >
	<input type="hidden" name="StockTransfer_Type" value="<%=StockTransfer_Type%>">
	<%//out.print("<br>1459 sold_lots="+sold_lots);%>
	<input type=hidden name="sold_lots" value="<%=scounter%>">
	
	<input type=hidden name="Tempsold_lots" value="<%=Tempsold_lots%>">
	<input type=hidden name="Tempdold_lots" value="<%=Tempdold_lots%>">
	
	<input type=hidden name="dold_lots" value="<%=dcounter%>">
	<!-- <input type=hidden name="saddlots" value="<%//=saddlots%>"> -->  
	<% //out.println("<br> 1440 scounter="+scounter);%>
	<input type=hidden name="scounter1" value="<%=scounter%>">
	<input type=hidden name="dcounter" value="<%=dcounter%>">
<TABLE borderColor=Skyblue align=center border=1 WIDTH="85%" cellspacing=0 cellpadding=2 >

	<%if("saved".equals(message))
	{%>
		<tr>
		<th colspan=6 align=center><font class=star1>Data Sucessfully Saved For Stock Transfer No <font color=blue> <%=request.getParameter("oldstocktransfer_no")%></font> </font></th>
		</tr>
	<%}%>

	<tr>
	<th colspan=6 align=center>Stock In/Out</th>
	</tr>
	<tr>
	<td colspan=6>
	<table><tr>
	<td>Inv No:
	<input type=text name=stocktransfer_no size=5 onBlur='return nullvalidation(this)' value="<%=request.getParameter("stocktransfer_no")%>"
	style="text-align:left;background:#CCCCFF" readonly onfocus="this.select();">
	</td>

	<td>Ref No:<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10 onfocus="this.select();"></td>
	<td ><script language='javascript'>
	if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Transfer Date' style='font-size:11px ; width:100'> ")} </script><input type=text name=datevalue size=8 value='<%=request.getParameter("datevalue")%>' onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);' onfocus="this.select();">
	</td>
	<td>Currency:
	<%
		if(currency.equals("local"))
		{
	%>
		  <input type=radio name=currency value=local checked
		  onclick="mainform.currency.value='local';checkCurrency()">Local
		  <input type=radio name=currency value=dollar 			onclick="mainform.currency.value='local';checkCurrency()">Dollar	<%	}
		if(currency.equals("dollar"))
		{
	%>
			<input type=radio name=currency value=local 
			onclick="mainform.currency.value='local';checkCurrency()">Local
			<input type=radio name=currency value=dollar checked 			onclick="mainform.currency.value='local';checkCurrency()">Dollar
		
	<%	
		}
	%>
	<td>&nbsp;</td>
	</td>
	
	
	<td colspan=2>Exchange Rate:<input type=text name=exchange_rate value="<%=str.mathformat(""+base_exchangerate,2)%>" size=4 onBlur="validate(this,2); calRateAmount();" style="text-align:right" onfocus="this.select();"></td>
		</tr></table></td>
	</tr>
	<tr>
	<td>
	<table bordercolor=silver border=1 WIDTH="100%" cellspacing=0 cellpadding=2 height="100%">	
	<% if(scounter>0)
			{
		
		%>
		
	
	<%
	for(int i=0;i<sold_lots;i++)
	{
	String rowNo=request.getParameter("rowNo"+i);	
	String againstRT_Id=request.getParameter("againstRT_Id"+i);	
	String slotno=request.getParameter("slotno"+i);	
	String sdescriptionname=request.getParameter("sdescriptionname"+i);	
	String ssizename=request.getParameter("ssizename"+i);	
	String sqty=request.getParameter("sqty"+i);	
	String spendingqty=request.getParameter("spendingqty"+i);	
	String srate=request.getParameter("srate"+i);	
	String samount=request.getParameter("samount"+i);	
	String slocalrate=request.getParameter("slocalrate"+i);	
	String slocalamount=request.getParameter("slocalamount"+i);	
	String sremark=request.getParameter("sremark"+i);	
	String slocation_id=request.getParameter("slocation_id"+i);	
	String from_location=request.getParameter("from_location"+i);	
	String sReceiveTransaction_Id=request.getParameter("sReceiveTransaction_Id"+i);
	%>
		<!-- <td><%=i+1%></td> -->
		<input type=hidden name="rowNo<%=i%>" value="<%=rowNo%>">
		<input type=hidden name="againstRT_Id<%=i%>" value="<%=againstRT_Id%>">
			
		<%//=sdescriptionname%>
		<input type=hidden name="sdescriptionname<%=i%>" value="<%=sdescriptionname%>" id="sdescriptionname<%=i%>" size=5> 
		
		<%//=ssizename%>
		<input type=hidden name="ssizename<%=i%>" value="<%=ssizename%>" id="ssizename<%=i%>" size=5>
		
		<!-- code for source location  -->
		<!-- <td>
		<%=A.getMasterArrayCondition(conp,"Location","from_location"+i,from_location,"where company_id="+company_id+" and Active=1")%>	
		</td> -->
			
		<input type=hidden name="from_location<%=i%>" value=<%=A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id)%>>
			
		<!-- <input type=text name="sqty<%//=i%>" value="<%//=sqty%>" size=7 style="text-align:right" onBlur="return chkQuantity('<%//=i%>')"> -->
		<input type=hidden name="sqty<%=i%>" value="<%=sqty%>" size=7 >
			
		<input type=hidden name="spendingqty<%=i%>" value="<%=spendingqty%>">
		
		<input type=hidden name="sReceiveTransaction_Id<%=i%>" value="<%=sReceiveTransaction_Id%>" size=7 >
			
         
		<%
		//out.println("1493 currency="+currency);	
		if(currency.equals("dollar"))
		{%>
		    <input type=hidden name="srate<%=i%>" value="<%=srate%>" size=5 style="text-align:right">			
			<input type=hidden name="slocalrate<%=i%>" value="<%=slocalrate%>">
		
		<%
		}%>

		<%if(currency.equals("local"))
		{
		%>
		<input type=hidden name="srate<%=i%>" value="<%=srate%>" >
		<input type=hidden name="slocalrate<%=i%>" value="<%=slocalrate%>" size=5>
        <%}%>

		<input type=hidden name="samount<%=i%>" value="<%=samount%>" size=5 >

		<input type=hidden name="slocalamount<%=i%>" value="<%=slocalamount%>" size=5>

		<input type=hidden name="sremark<%=i%>" value="<%=sremark%>">
		<!-- <input type=hidden name="slocation_id<%//=i%>" value="<%//=slocation_id%>"> -->
		
	<script language="javascript">
	
	 var lobj<%=i%> =new  actb(document.getElementById('slotno<%=i%>'),lotNoArray); 
	
	 var dobj<%=i%> =new  actb(document.getElementById('sdescriptionname<%=i%>'),descArray);
	
	 var sobj<%=i%> = new  actb(document.getElementById('ssizename<%=i%>'),sizeArray);
	
	</script>	
			
	<%	}%>
	<%
	errLine="1600";
	for(int i=sold_lots;i<scounter;i++)
			{
		//out.println("<br>1646 scounter="+scounter);
		%>
			<!-- <input type=text name="slotno<%=i%>" value="" size=5 id="slotno<%=i%>" onfocus="this.select();">
			<input type=hidden name="slotid<%=i%>" value="" size=5 id="slotid<%=i%>">	 -->
			
			<%//=sdescriptionname%>
			<input type=hidden name="sdescriptionname<%=i%>" value="" size=5 id="sdescriptionname<%=i%>"> 
		
		<%//=ssizename%>
			<input type=hidden name="ssizename<%=i%>" value="" size=5 id="ssizename<%=i%>">
		
		<!-- code for source location  -->
			<input type=hidden name="from_location<%=i%>" value=<%=A.getNameCondition(conp,"Master_Location","location_id","where location_name='Main' and company_id="+company_id)%>>
			
			<input type=hidden name="sqty<%=i%>" value="0" size=7 style="text-align:right">
			<!-- <input type=text name="sqty<%//=i%>" value="" size=7 style="text-align:right" onBlur="return chkQuantity('<%//=i%>')"> -->
			<input type=hidden name="sReceiveTransaction_Id<%=i%>" value="0" size=7 >
			
			<input type=hidden name="spendingqty<%=i%>" value="">
		<%if(currency.equals("dollar"))
		{%>
			<input type=hidden name="srate<%=i%>" value="1" size=5 style="text-align:right" id="srate<%=i%>">
			<input type=hidden name="slocalrate<%=i%>" value="1">
		
		<%}%>

		<%if(currency.equals("local"))
		{%>
			
		<input type=hidden name="srate<%=i%>" value="1" > 
					
		<input type=hidden name="slocalrate<%=i%>" value="1" size=5>

		<%}%>

		<input type=hidden name="samount<%=i%>" value="0" size=5 >
		<input type=hidden name="slocalamount<%=i%>" value="0">

		<input type=hidden name="sremark<%=i%>" value="">
				
		<!-- <input type=hidden name="slocation_id<%//=i%>" value="" size=5> -->
		<!-- <td><%=i+1%></td>
		<td><input type=text name="slotno<%//=i%>" value="#" size=5></td>

		<td colspan=2>			<%//=A.getMasterArray(conp,"Location","slocation_idCombo"+i,"",company_id)%>
		</td> -->

		<!-- <td><input type=text name="sqty<%//=i%>" value="0" size=7 style="text-align:right" onblur="scalcTotal(this)"></td> -->
		<!-- 	<td><input type=text name="srate<%//=i%>" value="0" size=7 style="text-align:right"></td>
		-->
	<script language="javascript">
	
	var lobj<%=i%> =new  actb(document.getElementById('slotno<%=i%>'),lotNoArray);
	
	var dobj<%=i%> =new  actb(document.getElementById('sdescriptionname<%=i%>'),descArray);
	
	var sobj<%=i%> = new  actb(document.getElementById('ssizename<%=i%>'),sizeArray);
	
	</script>
	 <%	}%>
	
	<%
	//String stotalqty=request.getParameter("stotalqty");		 
	//String stotalamount=request.getParameter("stotalamount");		 
	//String slocaltotalamount=request.getParameter("slocaltotalamount");		 
	 %>
		
		<input type=hidden name="stotalqty" value="<%=stotalqty%>" size=7 >
		<input type=hidden name="stotalamount" value="<%=stotalamount%>" size=5 >
		<input type=hidden name="slocaltotalamount" value="<%=slocaltotalamount%>" size=5 >
		
		<input type=hidden name="scounter" value="0"> 
		<!-- <input type=hidden name="saddlots" value="0"> -->
		
		
		<%}
	else{%>
	<tr>
		<td height="140" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
		 <input type=hidden name="scounter" value="0">
		<!-- <input type=hidden name="saddlots" value="0">
 -->
	</tr>

	<%}%>
	
	<% if(dcounter>0)
			{
	
		%>
	<tr>
	<th colspan=8>Source  Lots</th> <th colspan=2 bordercolor=skyblue> Destination Lots</th>
	</tr>
	<tr>
		<td>Sr. No.</td>
		
		<!-- <td>Desc.</td>
		<td>Size</td> -->
		<td>From<br>Location</td>
		<td>Lot No.</td>
		<td>Qty</td>
		<td>Rate ($)</td>
		<td>Rate (<%=local_symbol%>)</td>
		<td>Amount ($)</td> 
		<td>Amount (<%=local_symbol%>)</td>
		<td bordercolor=skyblue>To<br>Location</td>
		<td bordercolor=skyblue>Destination<br> Lot No.</td>
		<td>Remark</td>
	</tr>
	<%errLine="1022";
	for(int i=0;i<dold_lots;i++)
	{
	String dlotno=request.getParameter("dlotno"+i);	
	String dlotid=request.getParameter("dlotid"+i);	
	String slotid=request.getParameter("slotid"+i);	
	String ddescriptionname=request.getParameter("ddescriptionname"+i);	
	String dsizename=request.getParameter("dsizename"+i);	
	String tolocation_id=request.getParameter("tolocation_id"+i);	
	
	String dqty=request.getParameter("dqty"+i);	
	String drate=request.getParameter("drate"+i);	
	String damount=request.getParameter("damount"+i);	
	String dlocalrate=request.getParameter("dlocalrate"+i);	
	String dlocalamount=request.getParameter("dlocalamount"+i);	
	String dremark=request.getParameter("dremark"+i);	
	String dlocation_id=request.getParameter("dlocation_id"+i);	
	String to_location=request.getParameter("tolocation_id"+i);
	String slotno=request.getParameter("slotno"+i);	
	String slocation_id=request.getParameter("slocation_id"+i);	
System.out.println("slocation_id"+slocation_id);
	String dReceiveTransaction_Id=request.getParameter("dReceiveTransaction_Id"+i);	
	
	%>
	<tr> 
		<td><%=i+1%></td>
		<td ><%=A.getMasterArrayCondition(conp,"Location","slocation_id"+i,slocation_id,"where company_id="+company_id+" and Active=1")%></td>

		<td><input type=text name="slotno<%=i%>" value="<%=slotno%>" size=5 id="slotno<%=i%>" onblur="getDescSize('<%=company_id%>', document.mainform.slotno<%=i%>.value, document.mainform.datevalue.value, 'slotid<%=i%>','ddescriptionname<%=i%>', 'dsizename<%=i%>', 'drate<%=i%>', 'ddescriptionname<%=i%>', 'purchase' );" autocomplete=off onfocus="this.select();">
		<input type=hidden name="slotid<%=i%>" value="<%=slotid%>" id="slotid<%=i%>"></td>
		<input type=hidden name="ddescriptionname<%=i%>" value="<%=ddescriptionname%>" size=5 style="text-align:left" id="ddescriptionname<%=i%>" autocomplete=off onfocus="this.select();">
		
		<input type=hidden name="dsizename<%=i%>" value="<%=dsizename%>" size=5 style="text-align:left" id="dsizename<%=i%>" >

		<!-- code for Destination location  -->
		<!-- <td>
		<%=A.getMasterArrayCondition(conp,"Location","to_location"+i,to_location,"where company_id="+company_id+" and Active=1")%>	
		</td> -->
	
		
		<td><input type=text name="dqty<%=i%>" value="<%=dqty%>" size=5 style="text-align:right" onFocus="this.select(); return setOldDestQt('<%=i%>');" onBlur="return calcAmounts(<%=i%>)" ></td>
		
		<input type=hidden name="dReceiveTransaction_Id<%=i%>" value="<%=dReceiveTransaction_Id%>" size=7 >
		
		<%if(currency.equals("dollar"))
		{%>
			
			<td><input type=text name="drate<%=i%>" value="<%=drate%>" size=5 style="text-align:right" id="drate<%=i%>" onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); " onfocus="this.select();"></td>
			
			<td><input type=text name="dlocalrate<%=i%>" value="<%=dlocalrate%>" style="text-align:right;background:#CCCCFF"  size=5 readOnly onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); ">
			</td>
		<%}%>

		
		
		<%if(currency.equals("local"))
		{%>
			
			<td>
			<input type=text name="drate<%=i%>" value="<%=drate%>" style="text-align:right;background:#CCCCFF" id="drate<%=i%>" size=5  onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); " readOnly>
			</td>
			<td>
			<input type=text name="dlocalrate<%=i%>" value="<%=dlocalrate%>" size=5 style="text-align:right" onfocus="this.select();"  onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); "></td>
			
			<%}%>

		<td><input type=text name="damount<%=i%>" value="<%=damount%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"></td>

		<td><input type=text name="dlocalamount<%=i%>" value="<%=dlocalamount%>" style="text-align:right;background:#CCCCFF" readonly size=5 onfocus="this.select();"></td>
		
		<td bordercolor=skyblue><%=A.getMasterArrayCondition(conp,"Location","tolocation_id"+i,tolocation_id,"where company_id="+company_id+" and Active=1")%></td>
		

		<td bordercolor=skyblue>
		<input type=text name="dlotno<%=i%>" value="<%=dlotno%>" size=5 id="dlotno<%=i%>" onblur="return calcAmounts1(<%=i%>)" autocomplete=off onfocus="this.select();">
			<input type=hidden name="dlotid<%=i%>" value="" size=5 id="dlotid<%=i%>" >
		</td>
			
		
		<td>
			<input type=text name="dremark<%=i%>" value="<%=dremark%>" style="text-align:right" size=5 onfocus="this.select();"></td>
			<input type=hidden name="dlocation_id<%=i%>" value="<%=dlocation_id%>" style="text-align:right" size=5>
		

		<script language="javascript">
		var lobj<%=i%> =new  actb(document.getElementById('dlotno<%=i%>'),lotNoArray);
		var dobj<%=i%> = new  actb(document.getElementById('ddescriptionname<%=i%>'),descArray);
		var sobj<%=i%> = new  actb(document.getElementById('dsizename<%=i%>'),sizeArray);
		</script>	
    
		<script language="javascript">
		var lobj<%=i%> =new  actb(document.getElementById('slotno<%=i%>'),lotNoArray);
		var dobj<%=i%> =new  actb(document.getElementById('sdescriptionname<%=i%>'),descArray);
		var sobj<%=i%> = new  actb(document.getElementById('ssizename<%=i%>'),sizeArray);
		</script>

	</tr>
	<%	}%>

	<%errLine="1086";
	for(int i=dold_lots;i<dcounter;i++)
	{%>
	<tr>
		<td><%=i+1%></td>

		<td bordercolor=skyblue><%=A.getMasterArrayCondition(conp,"Location","slocation_id"+i,"","where company_id="+company_id+" and Active=1")%></td>

		<td><input type=text name="slotno<%=i%>" value="#" size=5 onblur="getDescSize('<%=company_id%>', document.mainform.slotno<%=i%>.value, document.mainform.datevalue.value, 'slotid<%=i%>','ddescriptionname<%=i%>', 'dsizename<%=i%>', 'drate<%=i%>', 'ddescriptionname<%=i%>', 'purchase' );" autocomplete=off onfocus="this.select();">
		<input type=hidden name="slotid<%=i%>" value=""></td>
		
		<input type=hidden name="ddescriptionname<%=i%>" value="" size=5 style="text-align:left" id="ddescriptionname<%=i%>" autocomplete=off onfocus="this.select();">
		<input type=hidden name="dsizename<%=i%>" value="" size=5 style="text-align:left" id="dsizename<%=i%>" >
        <input type=hidden name="dReceiveTransaction_Id<%=i%>" value="0" size=7 >
        <!-- column for Destination  location  -->
		

		<td>
			<input type=text name="dqty<%=i%>" value="0" size=5 style="text-align:right" onFocus="this.select(); return setOldDestQt('<%=i%>');" onBlur="return calcAmounts(<%=i%>)" >
		</td>
		
		<%if(currency.equals("dollar"))
		{%>
			
			<td>
			<input type=text name="drate<%=i%>" value="1" size=5 id="drate<%=i%>" style="text-align:right" 
			onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); " onfocus="this.select();"></td>

			<td><input type=text name="dlocalrate<%=i%>" value="1" style="text-align:right;background:#CCCCFF"  size=5 readOnly onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); ">
			</td>
		<%}%>
		
		<%if(currency.equals("local"))
		{%>
		<td>	
		<input type=text name="drate<%=i%>" value="1" id="drate<%=i%>" style="text-align:right;background:#CCCCFF" size=5 readOnly  onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); "></td>
		
		<td>
			<input type=text name="dlocalrate<%=i%>" value="1" size=5 style="text-align:right" onfocus="this.select();" onBlur="setOldDestQt('<%=i%>'); calcAmounts('<%=i%>'); "></td>
		<%}%>
		
		<td><input type=text name="damount<%=i%>" value="0" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"></td>
		<td><input type=text name="dlocalamount<%=i%>" value="0" style="text-align:right;background:#CCCCFF" readonly size=5 onfocus="this.select();"></td>
		
		<td><%=A.getMasterArrayCondition(conp,"Location","tolocation_id"+i,"","where company_id="+company_id+" and Active=1")%></td>
		
		<td><input type=text name="dlotno<%=i%>" value="#" size=5 id="dlotno<%=i%>"  autocomplete=off onfocus="this.select();">
		<input type=hidden name="dlotid<%=i%>" value="" size=5 id="dlotid<%=i%>" >
		</td>
		
		
		<td>
			<input type=text name="dremark<%=i%>" value="" style="text-align:right" size=5 onfocus="this.select();">

			<input type=hidden name="dlocation_id<%=i%>" value="1" style="text-align:right" size=5>
		</td>
    <script language="javascript">
	
	
	var lobj<%=i%> =new  actb(document.getElementById('slotno<%=i%>'),lotNoArray);
	
	var dobj<%=i%> =new  actb(document.getElementById('sdescriptionname<%=i%>'),descArray);
	
	var sobj<%=i%> = new  actb(document.getElementById('ssizename<%=i%>'),sizeArray);
	
	</script>

		<script language="javascript">
		
		
		var lobj<%=i%> =new  actb(document.getElementById('dlotno<%=i%>'),lotNoArray);

		var dobj<%=i%> = new  actb(document.getElementById('ddescriptionname<%=i%>'),descArray);
		
		var sobj<%=i%> = new  actb(document.getElementById('dsizename<%=i%>'),sizeArray);
		
		</script>	
		
	</tr>
	<%	}%>
	<tr>
		<td colspan=2 align=right>Total :&nbsp;&nbsp;</td>
		<td><input type=text name="dtotalqty" value="<%=dtotalqty%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"></td>
        <td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><input type=text name="dtotalamount" value="<%=dtotalamount%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"> </td>
		
		<td>
		<input type=text name="dlocaltotalamount" value="<%=dlocaltotalamount%>" size=5 style="text-align:right;background:#CCCCFF" readonly onfocus="this.select();"></td>
		<td>&nbsp;</td>
	</tr>
	<%}
	else	
		{%>

	<tr>
		<td height="140" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
		<input type=hidden name="dcounter" value="0">
		<input type=hidden name="daddlots" value="0">

	</tr>
	<%	}%>

	
	</table>
	</td>
	</tr>
		<TABLE borderColor=Skyblue border=1 align=center WIDTH="85%" cellspacing=0 cellpadding=2 >
	<tr>
	<td colspan=6>  Narration 
	<input type=text size=50  name=description value="<%=description%>" onfocus="this.select();"></td>
	</tr>


	<tr>
		<td align=left><input type="button" name="command" value="Back" class="button1" onclick="history.back(1)" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
		<!-- <td colspan=1 align=left>Add Source Lots :  -->
		<input type=hidden name="saddlots" value="0" size=4 style="text-align:right" OnBlur="setSourceLot(this);" onfocus="this.select();">			
		<td colspan=1 align=left>Add Lots : 
		<input type=text name="daddlots" value="1" size=4 style="text-align:right" onfocus="this.select();"></td>
		<td>
		<input type="submit" name="command" value="Add" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
		<input type="submit" name="command" value="Next" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
		</td>
	</tr>
</table>
</table>
	<%	errLine="1181";
		C.returnConnection(conp);	
		C.returnConnection(cong);	
	}
	}//End of Add
	}
	catch(Exception e994)
		{
			C.returnConnection(conp);
			C.returnConnection(cong);	
			out.print("<br>1927 File EditStock_InOutForm.jsp Bug e994= "+e994+" errLine="+errLine);  
		}

	



	/*############################################################
	
						  "Next" Start 
	
	#############################################################*/

 errLine="1205";
try
{
if("Next".equals(command))
{

String StockTransfer_Type=request.getParameter("StockTransfer_Type");
if(("3".equals(StockTransfer_Type)) || ("4".equals(StockTransfer_Type)) || ("5".equals(StockTransfer_Type)) || ("6".equals(StockTransfer_Type)) || ("7".equals(StockTransfer_Type)) )
{
	//out.println("<br> 1385");
	String message=request.getParameter("message");
	String lotno=""+request.getParameter("lotno");
	String strRT_Id=""+request.getParameter("strRT_Id");
	String againstRec_Id=""+request.getParameter("againstRec_Id");
	
	String cgtNo=""+request.getParameter("cgtNo");
	String currency=""+request.getParameter("currency");
	//out.print("<br>2022 currency="+currency);

	int daddlots=Integer.parseInt(request.getParameter("daddlots"));
	int saddlots=Integer.parseInt(request.getParameter("daddlots"));
    
	int sold_lots=Integer.parseInt(request.getParameter("sold_lots"));
	int dold_lots=Integer.parseInt(request.getParameter("dold_lots"));
	int Tempsold_lots=Integer.parseInt(request.getParameter("Tempsold_lots"));
	int Tempdold_lots=Integer.parseInt(request.getParameter("Tempdold_lots"));
	//int scounter=sold_lots+saddlots;
	//int dcounter=dold_lots+daddlots;
		
	int scounter=Integer.parseInt(request.getParameter("scounter1"));
	int dcounter=Integer.parseInt(request.getParameter("dcounter"));
	errLine="1955";
	String stocktransfer_no=request.getParameter("stocktransfer_no");
	String ref_no=""+request.getParameter("ref_no");
	String datevalue=request.getParameter("datevalue");
	String sreceive_Id=request.getParameter("sreceive_Id");
	String dreceive_Id=request.getParameter("dreceive_Id");
	
	//java.sql.Date TD=format.getDate(datevalue);
	//java.sql.Date SD=format.getDate(stockdate);
	String exchange_rate=request.getParameter("exchange_rate");
	
	String description=""+request.getParameter("description");
	String rowNo[]=new String[scounter];
	String againstRT_Id[]=new String[scounter];
	String slotno[]=new String[scounter];
	String slotid[]=new String[scounter];
	String sdescriptionname[]=new String[scounter];
	String ssizename[]=new String[scounter];
	//String sreceive_Id[]=new String[scounter];
	//String dreceive_Id[]=new String[scounter];
	String sReceiveTransaction_Id[]=new String[scounter];
	double sqty[]=new double[scounter];
	double spendingqty[]=new double[scounter];

	double srate[]=new double[scounter];
	double samount[]=new double[scounter];
	double slocalrate[]=new double[scounter];
	double slocalamount[]=new double[scounter];
	
	String sremark[]=new String[scounter];
	String slocation_id[]=new String[scounter];

	String slocation_idCombo[]=new String[scounter];
	String from_location[]=new String[scounter];
	
	boolean sqtyflag[]=new boolean[scounter];
	boolean slocationflag[]=new boolean[scounter];
	boolean slotflag[]=new boolean[scounter];
	

	double chkSourceQty=0;
	double chkDestinationQty=0;
	int souceInvalidLotNos=0;
	errLine="2038";


	for(int i=0;i<scounter;i++)
		{
			//out.println("<br> 1464");
			sqtyflag[i]=false;
			slocationflag[i]=false;
			slotflag[i]=false;
            //sreceive_Id[i]=request.getParameter("sreceive_Id"+i);
			
			rowNo[i]=request.getParameter("rowNo"+i);
			againstRT_Id[i]=request.getParameter("againstRT_Id"+i);
			slotno[i]=request.getParameter("slotno"+i);
			if(slotno[i].equals("#")){souceInvalidLotNos=souceInvalidLotNos+1;}
			from_location[i]=""+request.getParameter("from_location"+i);
						
			//to_location[i]=""+request.getParameter("to_location"+i);
			sdescriptionname[i]=request.getParameter("sdescriptionname"+i);
			ssizename[i]=request.getParameter("ssizename"+i);

			sReceiveTransaction_Id[i]=request.getParameter("sReceiveTransaction_Id"+i);
			sqty[i]=Double.parseDouble(request.getParameter("sqty"+i));
			//out.println("<br>2100 sqty="+sqty[i]);
			chkSourceQty +=sqty[i];
			spendingqty[i]=0;//Double.parseDouble(request.getParameter("spendingqty"+i));
			
			srate[i]=Double.parseDouble(request.getParameter("srate"+i));
			samount[i]=Double.parseDouble(request.getParameter("samount"+i));
			slocalrate[i]=Double.parseDouble(request.getParameter("slocalrate"+i));
			slocalamount[i]=Double.parseDouble(request.getParameter("slocalamount"+i));
	
			sremark[i]=request.getParameter("sremark"+i);	
			
			slocation_id[i]=request.getParameter("slocation_id"+i);
		System.out.println(" 2129 slocation_id"+slocation_id[i]);	slocation_idCombo[i]=request.getParameter("slocation_idCombo"+i);
				
			errLine="2047";
			String query="select count(Lot_Id) as lotcount from Lot where Active=1 and Lot_No='"+slotno[i]+"'";
			pstmt_p=conp.prepareStatement(query);
			rs_g=pstmt_p.executeQuery();
			int lotcount=0;
			while(rs_g.next())
			{
				lotcount=rs_g.getInt("lotcount");
			}
			pstmt_p.close();
			//out.print("<br>1514 lotcount="+lotcount);
			if(lotcount>0)
			{
				slotflag[i]=true;
				query="select Lot_Id from Lot where Lot_No='"+slotno[i]+"' and company_id="+company_id+" and Active=1";
				//out.println("<br> query="+query);
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				while(rs_g.next())
				{
					slotid[i]=rs_g.getString("Lot_Id");
					//srate[i]=S.stockRate(conp,SD,company_id,slotid[i]);		

				}
				pstmt_p.close();
		

				//query="select count(Lot_Id) as locationcount from LotLocation where Lot_Id="+slotid[i]+" and Location_Id="+slocation_id[i];
				//pstmt_p=conp.prepareStatement(query);
				//rs_g=pstmt_p.executeQuery();
				//int locationcount=0;
				//while(rs_g.next())
				//{
					//locationcount=rs_g.getInt("locationcount");
				//}
				//pstmt_p.close();
//			out.print("<br>704");

				//if(locationcount>0)
				//{
					slocationflag[i]=true;
					//query="select Available_Carats from LotLocation where Lot_Id="+slotid[i]+" and Location_Id="+slocation_id[i];
					//pstmt_p=conp.prepareStatement(query);
					//rs_g=pstmt_p.executeQuery();
					//double Available_Carats=0;
					//while(rs_g.next())
					//{
						//Available_Carats=rs_g.getDouble("Available_Carats");
					//}
					//pstmt_p.close();
					//out.print("<br>717");
					//if(Available_Carats>=sqty[i])
					//{
						sqtyflag[i]=true;
					//}
				//}
			}//if
			///out.println("<br> 1561");
	//-------------		
		} //for
	errLine="2133";
	String dlotno[]=new String[dcounter];
	String dlotid[]=new String[dcounter];
	String ddescriptionname[]=new String[dcounter];
	String dsizename[]=new String[dcounter];
	String dReceiveTransaction_Id[]=new String[dcounter];

	double dqty[]=new double[dcounter];

	double drate[]=new double[dcounter];
	double damount[]=new double[dcounter];
	double dlocalrate[]=new double[dcounter];
	double dlocalamount[]=new double[dcounter];
	
	String dremark[]=new String[dcounter];
	String dlocation_id[]=new String[dcounter];

	String dlocation_idCombo[]=new String[dcounter];
	String to_location[]=new String[dcounter];
	
	boolean dqtyflag[]= new boolean[dcounter];
	boolean dlocationflag[]= new boolean[dcounter];
	boolean dlotflag[]= new boolean[dcounter];
	int destInvalidLotNos=0;
	for(int i=0;i<dcounter;i++)
	{
		
		dqtyflag[i]=true;
		dlocationflag[i]=true;
		dlotflag[i]=false;
		
		dlotno[i]=request.getParameter("dlotno"+i);
		if(dlotno[i].equals("#"))
			{destInvalidLotNos=destInvalidLotNos+1;}
		ddescriptionname[i]=request.getParameter("ddescriptionname"+i);
		dsizename[i]=request.getParameter("dsizename"+i);
		dReceiveTransaction_Id[i]=request.getParameter("dReceiveTransaction_Id"+i);
		dqty[i]=Double.parseDouble(request.getParameter("dqty"+i));
		//out.print("<br>1210 dqty="+dqty[i]);
		to_location[i]=""+request.getParameter("to_location"+i);
		chkDestinationQty +=dqty[i];

		drate[i]=Double.parseDouble(request.getParameter("drate"+i));
		damount[i]=Double.parseDouble(request.getParameter("damount"+i));

		double dlocrate=0;
		dlocrate=((drate[i])*Double.parseDouble(exchange_rate));
		dlocalrate[i]=dlocrate;
		dlocalamount[i]=(dqty[i] * dlocalrate[i]);
	
		dremark[i]=request.getParameter("dremark"+i);
		dlocation_id[i]=request.getParameter("tolocation_id"+i);
	System.out.println(" 2242 dlocation_id"+dlocation_id[i]);
    	dlocation_idCombo[i]=request.getParameter("dlocation_idCombo"+i);
		errLine="2159";
		String query="select count(Lot_Id) as lotcount from Lot where Lot_No='"+dlotno[i]+"'";
		pstmt_p=conp.prepareStatement(query);
		rs_g=pstmt_p.executeQuery();
		int lotcount=0;

		    while(rs_g.next())
			{
				lotcount=rs_g.getInt("lotcount");
			}
			pstmt_p.close();
			if(lotcount>0)
			{
				dlotflag[i]=true;
				query="select Lot_Id from Lot where Lot_No='"+dlotno[i]+"' and company_id="+company_id;
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				while(rs_g.next())
				{
					dlotid[i]=rs_g.getString("Lot_Id");
					//drate[i]=S.stockRate(conp,SD,company_id,dlotid[i]);		
				}
				pstmt_p.close();

				errLine="2183";
				query="select count(Lot_Id) as locationcount from LotLocation where Lot_Id="+dlotid[i]+" and Location_Id="+dlocation_id[i];
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				int locationcount=0;
				while(rs_g.next())
				{
					locationcount=rs_g.getInt("locationcount");
				}
				pstmt_p.close();
				
				errLine="1244";
				if(locationcount>0)
				{
					dlocationflag[i]=true;
					query="select Available_Carats from LotLocation where Lot_Id="+dlotid[i]+" and Location_Id="+dlocation_id[i];
					pstmt_p=conp.prepareStatement(query);
					rs_g=pstmt_p.executeQuery();
					double Available_Carats=0;
					while(rs_g.next())
					{
						Available_Carats=rs_g.getDouble("Available_Carats");
					}
					pstmt_p.close();
					if(Available_Carats>=dqty[i])
					{
						dqtyflag[i]=true;
					}
				}
			}
			errLine="1260"+i;
		}// end of dcounter
		

	// Check wheather Source & Destination quantities are equal
chkSourceQty=str.mathformat(chkSourceQty,3);
chkDestinationQty=str.mathformat(chkDestinationQty,3);
	if(chkSourceQty != chkDestinationQty)
	{%>
		<center>
		<font color=red>Source Quantity <%=chkSourceQty%> and <br> Destination Quantity <%=chkDestinationQty%> must be same </font></center>
		<center><input type=button name=command value="BACK" 			onclick='history.go(-1)' class='button1'>
		</center>
			
	<%
	C.returnConnection(conp);
	C.returnConnection(cong);
	}
	else{%>


	<HTML>
	<HEAD>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

	<script language=javascript>

	
	function calcTotal()
	{
		var stotal=0;
		var dtotal=0;

		<%	
		if(souceInvalidLotNos >= destInvalidLotNos)
		{
		scounter=scounter-souceInvalidLotNos;
		dcounter=dcounter-souceInvalidLotNos;
		}
		else
		{
		scounter=scounter-destInvalidLotNos;
		dcounter=dcounter-destInvalidLotNos;
		}			
		for(int i=0;i<scounter;i++)
		{%>
			var stot=parseFloat(document.mainform.sqty<%=i%>.value)*parseFloat(document.mainform.srate<%=i%>.value);
			document.mainform.samount<%=i%>.value=stot;
			stotal=parseFloat(stotal)+parseFloat(stot);
		<%}%>

		stotal=stotal.toFixed(<%=d%>);
		document.mainform.stotalamt.value= stotal;

		<%
		for(int i=0;i<dcounter;i++)
		{%>
			var dtot=parseFloat(document.mainform.dqty<%=i%>.value)*parseFloat(document.mainform.drate<%=i%>.value);
			document.mainform.damount<%=i%>.value=dtot;
			dtotal=parseFloat(dtotal)+parseFloat(dtot);
		<%}%>

		dtotal=dtotal.toFixed(<%=d%>);
		document.mainform.dtotalamt.value= dtotal;

	}// end of calcTotal()
	</script>


</HEAD>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<%
boolean sfinalflag[]=new boolean[scounter];
boolean dfinalflag[]=new boolean[dcounter];
boolean sfflag=true;
boolean dfflag=true;
	for(int i=0;i<scounter;i++)
		{
		sfinalflag[i]=false;
			if(!slotflag[i])
			{%>
				<center><font class='msgred'>Lot No. <%=slotno[i]%> Does not exist.</font></center>
		   <%}
			else
			{
				if(!slocationflag[i])
				{%>
				<center><font class='msgred'>Lot No. <%=slotno[i]%> is not present at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+slocation_id[i])%>.</font></center>
			   <%}
				else
				{
					if(!sqtyflag[i])
					{%>
					<center><font class='msgred'>Lot No. <%=slotno[i]%> has insufficient quantity at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+slocation_id[i])%>.</font></center>
				<%	}
					else
					{
					sfinalflag[i]=true;
					}
				}
			}

		}
	for(int i=0;i<scounter;i++)
		{
			if(!sfinalflag[i])
			{%>
				<!-- <center><input type=button name=command value="Back" onclick="history.back(1)"></center> -->
		<%		sfflag=false;
				break;
			}
			else
			{
				sfflag=true;
			}

		}

	for(int i=0;i<dcounter;i++)
		{
		dfinalflag[i]=false;
			if(!dlotflag[i])
			{%>
				<center><font class='msgred'>Lot No. <%=dlotno[i]%> Does not exist.</font></center>
		<%	}
			else
			{
				if(!dlocationflag[i])
				{%>
				<center><font class='msgred'>Lot No. <%=dlotno[i]%> is not present at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+dlocation_id[i])%>.</font></center>
			<%	}
				else
				{
					if(!dqtyflag[i])
					{%>
					<center><font class='msgred'>Lot No. <%=dlotno[i]%> has insufficient quantity at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+dlocation_id[i])%>.</font></center>
				<%	}
					else
					{
					dfinalflag[i]=true;
					}
				}
			}

		}

	for(int i=0;i<dcounter;i++)
		{
			if(!dfinalflag[i])
			{%>
				<!-- <center><input type=button name=command value="Back" onclick="history.back(1)"></center> -->
		<%		dfflag=false;
				break;
			}
			else
			{
				dfflag=true;
			}

		}
if( (!(sfflag)) || (!(dfflag)) )
{
		C.returnConnection(conp);	
		C.returnConnection(cong);	
	%>
<center><input type=button name=command value="Back" onclick="history.back(1)" class="button1"></center>
<%}
if(sfflag && dfflag)
{
%>

<FORM name=mainform
action="OverseasEditStock_InOutUpdate.jsp" method="post">

	<input type=hidden name=againstRec_Id value="<%=againstRec_Id%>">
	<input type=hidden name="strRT_Id" value="<%=strRT_Id%>">
	<input type=hidden name="scounter" value="<%=scounter%>">
	<input type=hidden name="dcounter" value="<%=dcounter%>">
	<input type=hidden name="sold_lots" value="<%=sold_lots%>">
	<input type=hidden name="dold_lots" value="<%=dold_lots%>">
	<input type=hidden name="saddlots" value="<%=saddlots%>">
	<input type=hidden name="daddlots" value="<%=daddlots%>">
	<input type=hidden name="Tempsold_lots" value="<%=Tempsold_lots%>">
	<input type=hidden name="Tempdold_lots" value="<%=Tempdold_lots%>">
	<input type=hidden name="StockTransfer_Type" value="<%=StockTransfer_Type%>">
	<input type=hidden name="sreceive_Id" value="<%=sreceive_Id%>">
	<input type=hidden name="dreceive_Id" value="<%=dreceive_Id%>">
	<input type=hidden name="ref_no" value="<%=ref_no%>">
	<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr>
	<th colspan=2>Stock Transfer</th>
</tr>
<tr>
<td colspan=2>
	<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
	<tr>
	<td>Transfer No. 
	<%=stocktransfer_no%><input type=hidden name="stocktransfer_no" value="<%=stocktransfer_no%>"></td>
	<td>Transfer Date:	<%=datevalue%><input type=hidden name="datevalue" value="<%=datevalue%>"></td>
	</tr>

	<% if(scounter>0)
		{%>

	<tr>
		<td colspan=2>
			<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
			<tr><th colspan=8>Source </th></tr>
			<tr>
				<!-- <td>Sr. No.</td>
				<td>Lot No.</td>
				<td>Location</td>
				<td>Quantity</td>
				<td>Rate</td>
				<td>Amount</td> -->
				

				 <td>Sr. No.</td> 
				<td>Lot No.</td> 
				<!-- <td>Desc.</td>
				<td>Size</td> -->
				 <td>From location</td> 
				 <td>Qty</td>
				 <td>Rate ($)</td> 
				 <td>Rate (<%=local_symbol%>)</td>
				 <td>Amount ($)</td>
				<td>Amount (<%=local_symbol%>)</td>
				<td>Remark</td>

			<tr>

		<%double stotalqty=0;
	      double stotalamt=0;
	      double slocaltotalamt=0;
	 for(int i=0;i<scounter;i++)
		  {%>
		<tr>
			<td><%=i+1%></td> 
			<td>
				<input type=hidden name=rowNo<%=i%> value="<%=rowNo[i]%>">
				<input type=hidden name=againstRT_Id<%=i%> value="<%=againstRT_Id[i]%>">

				<input type=hidden name="slotno<%=i%>" value="<%=slotno[i]%>">
					
				<input type=hidden name="slotid<%=i%>" value="<%=slotid[i]%>">
				<%=slotno[i]%>
			</td>	
			
				<%//=sdescriptionname[i]%>
				<input type=hidden name="sdescriptionname<%=i%>" value="<%=sdescriptionname[i]%>" >
			

			<%//=ssizename[i]%>
				<input type=hidden name="ssizename<%=i%>" value="<%=ssizename[i]%>">
			<input type=hidden name="sReceiveTransaction_Id<%=i%>" value="<%=sReceiveTransaction_Id[i]%>" 	>
			<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_id="+slocation_id[i])%></td>
			<input type=hidden name=from_location<%=i%> value="<%=slocation_id[i]%>">
			
			<td><%=str.mathformat(""+sqty[i],3)%>
				<input type=hidden name="sqty<%=i%>" value="<%=str.mathformat(""+sqty[i],3)%>" size=7 style="text-align:right">
				<input type=hidden name="spendingqty<%=i%>" value="<%=str.mathformat(""+spendingqty[i],3)%>">
			</td>
			
			
			<% stotalqty+=sqty[i];%>

		    <%//if(currency.equals("dollar"))
			//{
			%> 
		<input type=hidden name=exchange_rate value="<%=exchange_rate%>" size=4 onBlur="validate(this,2); calRateAmount();" style="text-align:right" onfocus="this.select();">
			
			<input type=hidden name="srate<%=i%>" value="<%=str.mathformat(""+srate[i],3)%>" size=5 style="text-align:right" >
			
			<input type=hidden name="slocalrate<%=i%>" value="<%=str.mathformat(""+slocalrate[i],3)%>" style="text-align:right">
		
		 <%//}
		 %>  

		 <%//if(currency.equals("local"))
		   //{
		 %>  
			
			<input type=hidden name="slocalrate<%=i%>" value="<%=str.mathformat(""+slocalrate[i],3)%>" size=5 style="text-align:right">
			<td><%=str.mathformat(""+srate[i],3)%>
			<input type=hidden name="srate<%=i%>" value="<%=srate[i]%>" style="text-align:right">
			</td>
			<td><%=str.mathformat(""+slocalrate[i],3)%></td>
		   <%//}
		   %> 
		<td align=right><%=str.mathformat(""+(sqty[i]*srate[i]),3)%>
		<input type=hidden name="samount<%=i%>" value="<%=samount[i]%>" style="text-align:right">
		</td>

		<td align=right><%=str.mathformat(""+(sqty[i]*slocalrate[i]),3)%>
			<input type=hidden name="slocalamount<%=i%>" value="<%=slocalamount[i]%>" style="text-align:right" size=5>
		</td>

		<td><%=dremark[i]%>
			<input type=hidden name="sremark<%=i%>" value="<%=dremark[i]%>" style="text-align:right">
			<input type=hidden name="slocation_id<%=i%>" value="<%=slocation_id[i]%>" style="text-align:right">
		</td>


			<% stotalamt+=sqty[i]*srate[i];
			   slocaltotalamt+=sqty[i]*slocalrate[i];%>
			
			<%//=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="//+slocation_id[i])%>
			

		<tr>
		<%	}
		
		//String stotalqty=request.getParameter("stotalqty");		 
		//String stotalamount=request.getParameter("stotalamount");		 
		//String slocaltotalamount=request.getParameter("slocaltotalamount");
		
		
		%>
			<tr>
				<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
				<td align=right><%=str.mathformat(""+stotalqty,3)%><input type=hidden name="stotalqty" value="<%=str.mathformat(""+stotalqty,3)%>"></td>
				<td colspan=2>&nbsp;</td>
				<td align=right><%=str.mathformat(""+stotalamt,d)%><input type=hidden name="stotalamount" value="<%=str.mathformat(""+stotalamt,d)%>" size=7 style="text-align:right" readonly></td>

				<td align=right>
					<%=str.mathformat(""+slocaltotalamt,d)%>
					<input type=hidden name="slocaltotalamount" value="<%=str.mathformat(""+slocaltotalamt,d)%>" size=7 style="text-align:right" readonly></td>
			</tr>
			</table>
		</td>
<%}
else	
	{%>
<td colspan=2>
<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
<tr>
	<td height="88" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Gain </font></td>
	<input type=hidden name="scounter" value="0">
	<input type=hidden name="saddlots" value="0">
	<input type=hidden name="stotalqty" value="0">
	<input type=hidden name="stotalamt" value="0">

</tr>
	</table>	
</td>

<%	}%>

		<td></td>
				
<% if(dcounter>0)
		{%>

		<td colspan=2>
			<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
			<tr><th colspan=8>Destination</th></tr>
			<tr>
				<!-- <td>Sr. No.</td>
				<td>Lot No.</td>
				<td>Location</td>
				<td>Quantity</td>
				<td>Rate</td>
				<td>Amount</td> -->
				
				<td>Sr. No.</td>
				<td>Lot No.</td>
				<!-- <td>Desc.</td>
				<td>Size</td> -->
				<td> To  Location</td> 
				<td>Qty</td>
				<td>Rate ($)</td>
				<td>Rate (<%=local_symbol%>)</td>
				<td>Amount ($)</td>
				<td>Amount (<%=local_symbol%>)</td>
				<td>Remark</td>

			<tr>

		<%double dtotalqty=0;
	     double dtotalamt=0;
	     double dlocaltotalamt=0;

		for(int i=0;i<dcounter;i++)
		{%>
			<tr>
				<td><%=i+1%></td>
				<td><%=dlotno[i]%>
					<input type=hidden name="dlotno<%=i%>" value="<%=dlotno[i]%>">
					<input type=hidden name="dlotid<%=i%>" value="<%=dlotid[i]%>">
				</td>
				
				<%//=ddescriptionname[i]%>
					<input type=hidden name="ddescriptionname<%=i%>" value="<%=ddescriptionname[i]%>" size=5 style="text-align:left" id="ddescriptionname<%=i%>">
				

				<%//=dsizename[i]%>
					<input type=hidden name="dsizename<%=i%>" value="<%=dsizename[i]%>" size=5 style="text-align:left" id="dsizename<%=i%>">
				<input type=hidden name="dReceiveTransaction_Id<%=i%>" value="<%=dReceiveTransaction_Id[i]%>" 	>
				<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_id="+dlocation_id[i])%></td>
				<input type=hidden name=to_location<%=i%> value="<%=dlocation_id[i]%>">

				<td align=right><%=str.mathformat(""+dqty[i],3)%>
				<input type=hidden name="dqty<%=i%>" value="<%=dqty[i]%>">
				</td>

			<% dtotalqty+=dqty[i];%>
				
				<%//if(currency.equals("dollar"))
				//{%> 
				<input type=hidden name="drate<%=i%>" value="<%=drate[i]%>" size=5 style="text-align:right" id="drate<%=i%>">
			
				<input type=hidden name="dlocalrate<%=i%>" value="<%=dlocalrate[i]%>" style="text-align:right">

				</td>
				 <%//}
				%>
		
		
			 <%//if(currency.equals("local"))
			//{
			%> 
				<td><%=drate[i]%>
				<input type=hidden name="dlocalrate<%=i%>" value="<%=dlocalrate[i]%>" size=5 style="text-align:right"></td>
				<td><%=dlocalrate[i]%>
				<input type=hidden name="drate<%=i%>" value="<%=drate[i]%>" style="text-align:right" id="drate<%=i%>">
				</td>
			 <%//}
			%>
			<td align=right><%=str.mathformat(""+(dqty[i]*drate[i]),d) %>
			<input type=hidden name="damount<%=i%>" value="<%=str.mathformat(""+(dqty[i]*drate[i]),d) %>" size=7 style="text-align:right"></td>
			<td align=right>
				<%=str.mathformat(""+(dqty[i]*dlocalrate[i]),d)%>
				<input type=hidden name="dlocalamount<%=i%>" value="<%=str.mathformat(""+(dqty[i]*dlocalrate[i]),d) %>" size=7 style="text-align:right">
			</td>
			
			<td><%=dremark[i]%>
				<input type=hidden name="dremark<%=i%>" value="<%=dremark[i]%>" style="text-align:right" size=5>
				<input type=hidden name="dlocation_id<%=i%>" value="<%=dlocation_id%>" style="text-align:right" size=5>
			</td>


			<% 
				dtotalamt+= (dqty[i]*drate[i]);
			   dlocaltotalamt += (dqty[i] * dlocalrate[i]);%>
			</tr>
	<%	}%>
			<tr>
				<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>

				<td align=right><%=str.mathformat(""+dtotalqty,3)%>
					<input type=hidden name="dtotalqty" value="<%=dtotalqty%>">
				</td>
				<td colspan=2>&nbsp;</td>
				<td align=right><%=str.mathformat(""+dtotalamt,d)%><input type=hidden name="dtotalamount" value="<%=str.mathformat(""+dtotalamt,d)%>"  size=7 style="text-align:right" readonly></td>

				<td align=right><%=str.mathformat(""+dlocaltotalamt,d)%>
				<input type=hidden name="dlocaltotalamount" value="<%=str.mathformat(""+dlocaltotalamt,d)%>"  size=7 style="text-align:right" readonly></td>
			</tr>
		</table>
		</td>
	<%}
	else	
	{%>
	<td colspan=2>
	<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
	<tr>
		<td height="88" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
		<input type=hidden name="dcounter" value="0">
		<input type=hidden name="daddlots" value="0">
		<input type=hidden name="dtotalqty" value="0">
		<input type=hidden name="dtotalamt" value="0">

	</tr>
	</table>	
</td>

<%	}%>
	</tr>
	</table>	
</td>
</tr>
<tr>
<td colspan=6>Narration :<%=description%>
<input type=hidden size=75 name=description value="<%=description%>">
		<input type=hidden name="scounter" value="<%=scounter%>">
		<input type=hidden name="dcounter" value="<%=dcounter%>">
		<input type=hidden name="currency" value="<%=currency%>">

		<input type=hidden name="companyparty_name" value="<%=companyparty_name%>">
		<input type=hidden name="purchasesalegroup_id" value="<%=purchasesalegroup_id%>">
		<input type=hidden name="duedays" value="<%=duedays%>">
		<input type=hidden name="duedate" value="<%=duedate%>">
		<input type=hidden name="category_id" value="<%=category_id%>">
		<input type=hidden name="purchaseperson_id" value="<%=purchaseperson_id%>">
		<input type=hidden name='broker_id'  value='<%=broker_id%>'>
		<input type=hidden name="broker_remarks" value="<%=broker_remarks%>">
		<input type=hidden name="ReceiveBy_Name" value="<%=ReceiveBy_Name%>">
		<input type=hidden name="loginLocation_id" value="<%=loginLocation_id%>">
	

	</td>
	</tr>

		<tr>
		<td align=left>
			<input type=button name="command" value="Back" onclick="history.back(1)" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
		</td>
		<td align=right><input type=submit name="command" value="Update" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
		</td>
	</tr>
</table>
</form>
	</body>
	</html>
<%
	C.returnConnection(conp);	
	C.returnConnection(cong);	


}
		  }// check sQty=dQty
		}//type =3 
	}
}catch(Exception e1750)
	{
		C.returnConnection(conp);	
		C.returnConnection(cong);	
		out.print("<br>2728 FileEditStock_InOutForm.jsp Bug e1750= "+e1750+" errLine="+errLine);
	}
%>


	


