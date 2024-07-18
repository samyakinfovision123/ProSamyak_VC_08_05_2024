<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%// System.out.println("Inside GL_New.jsp");%>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<% 
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;
Connection conp = null;

PreparedStatement pstmt_g=null;
Connection cong = null;

try	{conp=C.getConnection();
cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
//System.out.println("Master_Comapnyparty User Id"+user_id);
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String user_name= ""+session.getValue("user_name");
//System.out.println("User Name"+user_name);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);


//out.print("<br>25 startDate"+startDate);
String command = request.getParameter("command");
//System.out.println("command is "+command);
String message=request.getParameter("message"); 
//String name   = request.getParameter("name"); 
String account_no=request.getParameter("account_no");
//out.println("account_no="+account_no);
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
String companyparty_id= ""+L.get_master_id(conp,"Master_companyparty");
//System.out.println("companyparty id is "+companyparty_id);
try{
%>
<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/Samyakdate.js"></script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/Ledger.js"></script>

<script language=javascript src="../Samyak/ReceiveID_Number.js"></script>

<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script language="javascript">
	<%
			
			

			String temp_sale_person_id="";
			String temp_purchase_person_id="";
			String companyQuery="";
			String na_sale_person_id="";
			String na_purchase_person_id="";
			//System.out.println("user_name="+user_name);
			//System.out.println("user_level="+user_level);
			if("15".equals(user_level))
			{
				
				//out.println("user_name="+user_name);
				String sale_purchase_person="select * from Master_SalesPerson where (Salesperson_name='"+user_name+"') and (purchasesale=0) and active=1 ";
				pstmt_g = cong.prepareStatement(sale_purchase_person);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next()) 	
				{
					temp_sale_person_id=rs_g.getString("SalesPerson_Id");
				}
				sale_purchase_person="select * from Master_SalesPerson where (Salesperson_name='"+user_name+"') and (purchasesale=1) and active=1 ";
				pstmt_g = cong.prepareStatement(sale_purchase_person);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next()) 	
				{
					temp_purchase_person_id=rs_g.getString("salesPerson_Id");
				}
				
				/*  Get Id for --- NA --- SalesPerson */
				sale_purchase_person="select * from Master_SalesPerson where (Salesperson_name=' ---NA--- ') and (purchasesale=0) and active=1 ";
				pstmt_g = cong.prepareStatement(sale_purchase_person);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next()) 	
				{
					na_sale_person_id=rs_g.getString("SalesPerson_Id");
				}
					
				/* End of Get Id for --- NA --- SalesPerson */
				
				/*  Get Id for --- NA --- PurchasePerson */
				sale_purchase_person="select * from Master_SalesPerson where (Salesperson_name=' ---NA--- ') and (purchasesale=0) and active=1 ";
				pstmt_g = cong.prepareStatement(sale_purchase_person);
				rs_g = pstmt_g.executeQuery();
				while(rs_g.next()) 	
				{
					na_purchase_person_id=rs_g.getString("SalesPerson_Id");
				}
					
				/* End of Get Id for --- NA --- PurchasePerson */
				String person_condition="";
				if(!("".equals(temp_sale_person_id)))
				{
						person_condition+=" and (person1='"+temp_sale_person_id+"' or person1='"+na_sale_person_id+"')";
				}
				if(!("".equals(temp_purchase_person_id)))
				{
						person_condition+=" and (person2='"+temp_purchase_person_id+"' or person2='"+na_purchase_person_id+"')";
				}
				companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Company_Id="+company_id+""+person_condition+" order by CompanyParty_Name";
			} //if("15".equals(user_level))
			else
			{
				companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Company_Id="+company_id+" order by CompanyParty_Name";
			} //else
			String companyArray_temp ="";
			String companyArray="";
			
			System.out.println("companyQuery="+companyQuery);
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			 companyQuery = "Select Account_Name from Master_Account where Company_Id="+company_id+" order by Account_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\"";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			int len=companyArray_temp.length();
			String companyArray_tokenizer=companyArray_temp.substring(1,(len-1));
			String companyArray_sort[]=companyArray_tokenizer.split("\",\"");
			java.util.Arrays.sort(companyArray_sort,java.text.Collator.getInstance());
			
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(i==0)
				{
					companyArray=companyArray+"\""+companyArray_sort[i];
					
				}
				if(i==(companyArray_sort.length-1))
				{
					companyArray=companyArray+companyArray_sort[i]+"\"";
					
					break;
				}
				if(!(i==0)&&!(i==(companyArray_sort.length-1)))
				{
					if(i==1)
					{
					companyArray=companyArray+"\",\""+companyArray_sort[i]+"\",\"";
					}
					else
					{
					companyArray=companyArray+companyArray_sort[i]+"\",\"";
					
					}	
						
					
				}
			}
			out.print("var companyArray=new Array("+companyArray+");");
		%>
	</script>
	
	

<script>
function ValidLength(item,len)
	{
		return (item.length >= len);
	}
function ValidEmail(item)
	{
		if (!ValidLength(item, 5))
		return false;
		if (item.indexOf ('@', 0) == -1)
		return false;
		return true
	}

var errfound = false;
function Validate()
	{

	
	if(document.mainform.is_ledger[0].checked)
	{
				
		errfound = false;
		if(document.getElementById('companyparty_name').value == "")
		{
		alert("Please enter Customer/Vendor Account's name.");
		document.getElementById('companyparty_name').focus();
		return errfound;
		}
		else
		{
			var tempA=document.getElementById('companyparty_name').value;
			if(tempA.length < 2)
			{
			alert("Please enter Customer/Vendor Account's name Properly. Must be more than two characters");
			document.getElementById('companyparty_name').focus();
			return errfound;
			}
			else
			{
				if(document.getElementById('sale').checked || document.getElementById('purchase')|| document.getElementById('check_amount'))
				{
					
					//if(document.mainform.check_button.value=="SAVE")
					//{					
						document.mainform.action='../Master/UpdateNewCompanyPartyAccount.jsp';
						document.mainform.submit();	
						return !errfound;
					//}
					//else
					//{
						
					//	submitMe("EDIT");
					//	return !errfound;
					//}
				}
				else
				{
					alert("Please Select One of the Customer/Vendor Account type (Sale / Purchase /PN) ");
					return errfound;
				}
			}
		}
	}//if
	if(document.mainform.is_ledger[1].checked)
	{
		//alert('Cash');
		//alert(document.getElementById('account_name').value);
		
		var errfound = false;
		
			var flag1=true;
			flag1=	fnCheckDate(document.getElementById('datevalue').value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
			//alert(flag1);
			if(flag1==false)
				return false;
			
			errfound = false;
			//alert("135="+document.mainform.account_name.value);
			
			if(document.getElementById('companyparty_name').value == "")
			{
			alert("Please enter Account's name.");
			document.getElementById('companyparty_name').select();
			return errfound;
			}
			else
			{
				var tempA=document.getElementById('companyparty_name').value;
				if(tempA.length < 2)
				{
					alert("Please enter Account's name Properly. Must be more than two characters");
					document.getElementById('companyparty_name').select();
					return errfound;
				}
				else
				{
					
					//if(document.mainform.check_button.value=="SAVE")
					//{					
						document.mainform.action='../Master/UpdateAccount.jsp?accounttype_id=6&bank_id=self&account_no=Cash';
						document.mainform.submit();
						return !errfound;
				//	}
				//	else
				//	{
					//	submitMe("EDIT");
				//		return !errfound;
				//	}
				}
			}// else 
	} //if
	if(document.mainform.is_ledger[2].checked)
	{
		var errfound = false;
		var flag1=true;
		flag1=	fnCheckDate(document.getElementById('datevalue').value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
			
		if(flag1==false)
			return false;
			
		errfound = false;
		//alert("135="+document.mainform.account_name.value);
			
		if(document.getElementById('companyparty_name').value == "")
		{
			alert("Please enter Account's name.");
			document.getElementById('companyparty_name').select();
			return errfound;
		}
		else
		{
			var tempA=document.getElementById('companyparty_name').value;
			if(tempA.length < 2)
			{
				alert("Please enter Account's name Properly. Must be more than two characters");
				document.getElementById('companyparty_name').select();
				return errfound;
			}
			else
			{
				//if(document.mainform.check_button.value=="SAVE")
				//{										
					document.mainform.action='../Master/UpdateAccount.jsp?accounttype_id=1&bank_id=Bank&account_no=Bank';
					document.mainform.submit();
			}
		}// else 
	} //if
	}
function EnableOtherLedger()
{
	
} //EnableOtherLedger()

function showSubGroup(gp)
{
		//alert("Hello");	
		var companyid=<%=company_id%>
		var group=gp;
		getSubGroup(gp,companyid);
}//

</script>
<script>
function setFoucs()
{
		
		
		var td_ele=document.getElementById('table_display');
		var ele=document.getElementById('ledger_display');
		var other_info_span=document.getElementById('other_info');
		var cash_span_ele=document.getElementById('cash_span');
		var bank_span_ele=document.getElementById('bank_span');
		<%if("Party".equals(account_no)){%>
		
		document.mainform.is_ledger[0].checked=true;
		td_ele.innerHTML=ele.innerHTML+other_info_span.innerHTML;
		document.getElementById("td_id").style.visibility="Visible";
		<%}
		if("Cash".equals(account_no)){
		%>		
		
		document.mainform.is_ledger[1].checked=true;
		td_ele.innerHTML=cash_span_ele.innerHTML;
		document.getElementById("td_id").style.visibility="Hidden";
		<%}
		if("Bank".equals(account_no)){%>
		
		document.mainform.is_ledger[2].checked=true;
		td_ele.innerHTML=bank_span_ele.innerHTML;
		document.getElementById("td_id").style.visibility="Hidden";
			<%}%>
		this.document.mainform.companyparty_name.focus();
		
		
		
}
function ShowHideInfo()
{
		
		var v=document.getElementById("info_span");
		var button_id1=document.getElementById("button3");
		var button_id2=document.getElementById("button2");
		var td_ele=document.getElementById('table_display');
		var ele=document.getElementById('ledger_display');
		var other_info_span=document.getElementById('other_info');
		
		//var td_id_ele=document.getElementById("td_id");
		if(document.getElementById('other_info_name').checked)
		{
			
			v.style.visibility="Visible";	
			button_id1.style.visibility="Hidden";
		}
		else
		{
			
			button_id1.style.visibility="Visible";
			v.style.visibility="Hidden";	
			
		}
}		

function showCashBankLedger()
{
	this.document.mainform.companyparty_name.focus();
	var ele=document.getElementById('ledger_display');
	var v=document.getElementById('info_span');
	var cl=document.getElementById('Cur_Limt');
	cl.visibility="hidden";
	var cash_span_ele=document.getElementById('cash_span');
	var bank_span_ele=document.getElementById('bank_span');
	var td_ele=document.getElementById('table_display');
	
	
	var button_id1=document.getElementById("button1");
	var button_id2=document.getElementById("button2");
	if(document.mainform.is_ledger[0].checked)
	{
		
		var other_info_span=document.getElementById('other_info');
		td_ele.innerHTML=ele.innerHTML+other_info_span.innerHTML;
		getSubGroup(2,<%=company_id%>);
		//document.mainform.other_info_name.style.visibility="Visible";
		document.getElementById("td_id").style.visibility="Visible";
		if(document.mainform.other_info_name.checked)
		{
			
			v.style.visibility="Visible";
			button_id1.style.visibility="Hidden";
		}
		
		
	}
	if(document.mainform.is_ledger[1].checked)
	{
		//document.mainform.other_info_name.style.visibility="Hidden";
		document.getElementById("td_id").style.visibility="Hidden";
		td_ele.innerHTML=cash_span_ele.innerHTML;
	}
	if(document.mainform.is_ledger[2].checked)
	{
		
		document.getElementById("td_id").style.visibility="Hidden";
		td_ele.innerHTML=bank_span_ele.innerHTML;
		
	}

}
function submitMe(button_pressed)
{
	
	if(button_pressed=='EDIT')
	{
		document.mainform.check_button.value="EDIT";

		getNameId(document.mainform.companyparty_name.value);	
	}
	if(button_pressed=='SAVE')
	{
		document.mainform.check_button.value="SAVE";
		document.mainform.action='../Master/UpdateNewCompanyPartyAccount.jsp?command=SAVE';
		document.mainform.submit();
	}

} //submitMe()

function getNameId(party_name)
{
	getNextCompanyParty(party_name,'<%=company_id%>','Edit',document.mainform.companyparty_name,document.mainform.companyparty_id,'2')
			
}

function submitMeForCash(button_pressed)
{

	
	if(button_pressed=='SAVE')
	{
		document.mainform.action='../Master/UpdateCashBankAccount.jsp?command=SUBMIT&accounttype_id=6&bank_id=Cash&account_no=Cash';
	
		document.mainform.submit();
	}


}


function submitMeForBank(button_pressed)
{

	
	if(button_pressed=='SAVE')
	{
		document.mainform.action='../Master/UpdateCashBankAccount.jsp?command=SUBMIT&accounttype_id=1&bank_id=Bank&account_no=Bank';
	
		document.mainform.submit();
	}


}
function editCancel(no)
{
	
}


function cfun(str)
{
	alert(str);
window.open(str,"_blank", ["Top=2","Left=50","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=600", "Resizable=yes","Scrollbars=yes","status=Yes"])
}


function tb1(str)
{
	window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=yes"]);
}

</script>
</head>




<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onLoad='setFoucs();getSubGroup(2,<%=company_id%>);showCashBankLedger();' >
<form  name='mainform' method='post' onsubmit="return Validate();" >
<input type=hidden name=active value=yes>
<input type =hidden name= category_code value=0>

<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor="skyblue">
<th colspan=4 align=center>
 Add New Account</th>
</tr>

<tr><td colspan=4><hr></hr> </td></tr>
<tr>
		
			<td colspan=1 align=center><input type=radio name='is_ledger' value='ledger' checked onClick='showCashBankLedger();' TABINDEX="-3">Ledger</td>
			<td colspan=1 align=center><input type=radio name='is_ledger' value='cash' onClick='showCashBankLedger();' TABINDEX="-4">Cash </td>
			<td colspan=1 align=center><input type=radio name='is_ledger' value='bank' onClick='showCashBankLedger();' TABINDEX="-5">Bank </td>
</tr>
<tr><td colspan=4><hr></hr> </td></tr>
<tr>
	<td>Name <font class="star1">*</font></td>
    
	<td colSpan=2><INPUT type=text name='companyparty_name' id='companyparty_name' size=30   autocomplete=off TABINDEX="1"> 

	<INPUT type=Button  name=command  value='EDIT' class='Button1' id="button1" OnClick="submitMe(this.value);" style='width:60' TABINDEX="2"></td>  
	
	<INPUT type=hidden name='CompanyParty_Id' id='companyparty_id'  value='0'>
	
	<input type=hidden name='check_button' value='EDIT'>
	
	<script language="javascript">
		var companyobj = new  actb(document.getElementById('companyparty_name'), companyArray);	
	</script>
	
	
<td><script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Opening Date' style='font-size:11px ; width:70' TABINDEX=\"3\">")}
</script>
<input type=text name='datevalue' id='datevalue' size=8 maxlength=10 value="<%=startDate%>" TABINDEX="4"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>
</td>
</tr>
<tr>
<td>Currency <font class="star1">*</font></td>
<td><input type=radio size=4 name=currency value=local checked TABINDEX="5">Local&nbsp;<input type=radio size=4 name=currency value=dollar TABINDEX="6">Dollar</td>
<td></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;Opening Balance<input type=text size=10 name=ledger_amount value=0 	TABINDEX="7"			style="text-align:right" >
<Select name=main_ledger_amount TABINDEX="8">
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
</td>
</tr>
<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td><input type=text size=4 name=exchange_rate value=
'<%=str.format(I.getLocalExchangeRate(conp,company_id))%>'  onBlur='validate(this)' style="text-align:right" TABINDEX="9"></td>
<td>&nbsp;&nbsp;</td>
</tr>
<tr>
	<td>Due Days</td> 
    <td><input type=text name=duedays value="0" style="text-align:right" size=4 onblur="return validate(this,0)" TABINDEX="10"></td>
</tr>
<span id="Cur_Limt">
<tr>
	<td colspan=4><hr></td>
</tr>
<tr>
	<td >Credit Limit Currency <font class="star1">*</font></td>
<td><input type=radio size=4 name=currency_limit value=local checked TABINDEX="11">Local&nbsp;<input type=radio size=4 name=currency_limit value=dollar TABINDEX="12">Dollar</td>
</tr>
<tr>
<td>Credit Limit</td> 
    <td><input type=text size=4 name="credit_limit" value=0 onBlur='validate(this)' style="text-align:right" TABINDEX="13"></td>
    <td>Credit Limit Per Day</td>
	<td><input type=text size=4 name="credit_limit_per_day" value=0 onBlur='validate(this)' style="text-align:right" TABINDEX="14"></td>
</tr>
</span>
</table>
<table border=0 WIDTH="100%" cellspacing=0 cellpadding=2>
	<tr>
		<td id='table_display' >
		
		</td>
	</tr>
</table>

<span id='other_info' style='visibility:Visible'>
</span>

<span style="visibility:Hidden" id="info_span">


<table borderColor=yellow border=0 WIDTH="100%" cellspacing=0 cellpadding=2>


<!-- 
/*********************** Down *******************************/ -->


<tr>
	<td colspan=4 align=center >Other<input type=checkbox name=check_amount id='check_amount' value=yes checked onclick="EnableOtherLedger();" TABINDEX='24'>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Sale
	
	<input type=checkbox name=sale id='sale' value=yes checked TABINDEX='25'>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	
	Purchase
	<input type=checkbox name=purchase id='purchase' value=yes checked TABINDEX='26'></td>

</tr>

<tr>
    <td>P.O.Box </td>
    <td colSpan=3><INPUT type=text name=address1 size=50 TABINDEX='27'> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 TABINDEX='28'></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=1><INPUT  type=text name=address3 size=25 TABINDEX='29'></td> 
    <td>City</td> 
    <td><INPUT  type=text name=city TABINDEX='30'></td> 
</tr>

<tr>
    <td>Pin</td> 
    <td><INPUT  type=text name=pin TABINDEX='31'></td> 
    <td>Country <font class="star1">*</font></td> 
    <td><INPUT type=text  name=country value='India' TABINDEX='32'></td>
</tr> 

<tr>
    <td>Income Tax No</td> 
    <td><INPUT  type=text name=income_taxno TABINDEX='33'></td> 
    <td>Sales Tax No</td> 
    <td><INPUT  type=text name=sales_taxno TABINDEX='34'></td>
</tr>

<tr>
    <td>Phone (O)</td> 
    <td><INPUT  type=text name=phone_off TABINDEX='35'></td> 
    <td>Phone (R)</td> 
    <td><INPUT  type=text name=phone_resi TABINDEX='36'></td>
</tr>

<tr>
    <td>Fax</td> 
    <td><INPUT  type=text name=fax_no TABINDEX='37'></td>
	<td>Mobile</td>
    <td><INPUT  type=text name=mobile TABINDEX='38'></td>
</tr>	

<tr>
    <td>Email</td> 
    <td><INPUT  type=text name=email TABINDEX='39'></td>
    <td>Website</td> 
    <td><INPUT  type=text name=website TABINDEX='40'></td>
	

<tr>
    
    <td>Interest rate (%)</td>
    <td><input type=text name=interest value="0" style="text-align:right" size=7 onblur="return validate(this,2)" TABINDEX='41'></td>
</tr>
<INPUT  type=hidden name=person1>
<INPUT type=hidden  name=person2>
<TR align=center>
<TD colspan=4>
	<INPUT type=Button  name=command  value='SAVE' class='Button1' name="button2" OnClick="submitMe(this.value);" TABINDEX='42'> 
</td>
</tr>
</table>
</span>


<!--             /******************* END ***************************/   -->





<span id='ledger_display' style='visibility:Hidden'>
<table borderColor=green border=0 WIDTH="100%" cellspacing=0 cellpadding=2>
<tr>
	<td colspan=6><hr></hr></td>
</tr>
<tr>
	<th >Main Ledger</th>
	<td></td>
	<td><input type=radio name=main_ledger value=sale checked TABINDEX="15"> Sale</td>
	<td><input type=radio name=main_ledger value=purchase TABINDEX="15">Purchase</td>
	<td><input type=radio name=main_ledger value='others' TABINDEX="15">Others  &nbsp;&nbsp;Amount</td>
</tr>
<tr>
	<td colspan=6><hr></hr></td>

</tr>

<tr>
	 <td>Others</td><td>&nbsp;</td>

<td>Ledger Group  
<!-- <a href="javascript:tb1('../Finance/SundryType.jsp?command=Default&message=Default')" >
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'> -->
<!-- </a> -->
</td>
<td><select name=category style="width:150;font-size:12" OnChange="showSubGroup(this.value);" TABINDEX="16"> 

	<option value='2' selected>Fixed Asset</option>
	<option value='15'>Current Assets</option>
	<option value='17'>Current Liabilities</option>
	<option value='16'>Misc Expenditure</option>
	<option value='18'>Reserves & Surplus</option>
	<option value='5'>Investment</option>
	<option value='7'>Loan(Liabilities) </option>
	<option value='11'>Loan & Advances </option>
	<option value='3'>Capital </option>
	<option value='6'>Expenses </option>
	<option value='12'>Indirect Income </option>
	<option value='13'>Indirect Expense </option>
	</select></td>
	
<td colspan=1 align=left>SubGroup

<a href="javascript:tb1('../Finance/SundryType.jsp?command=Default&message=Default')" >
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'>
</a>

</td>
	<td><select name=SubGroup id=SubGroup TABINDEX="17" style="width:150;font-size:12"></select></td>	
</tr>
<tr>
 <td>Sales</td>	 <td>&nbsp;</td>
 <input type=hidden size=4 name="opening_salesbalance" value=0 onBlur='validate(this)' style="text-align:right">

<td>Sales Party Group : 
<a href="javascript:tb1('../Finance/PartyGroupType.jsp?command=Default&message=Default')" >
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'>
</a>
</td>	
<td>
<%=AC.getMasterArrayCondition(conp,"PartyGroup","salespartygroup_id\'    TABINDEX=\'18",A.getNameCondition(conp,"Master_PartyGroup","partygroup_id","where PartyGroup_Name='Normal' and Group_Type=0 and company_id="+company_id),"where Active=1 and Group_Type=0",company_id)%></td>

	<td>Sales Person 
	<a href="javascript:tb1('../Master/SalePersonFrame.jsp?command=Default&message=Sale')">
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'>
</a>
	</td>
	<%if("15".equals(user_level))
	{	
		String sersonId=A.getNameCondition(conp,"Master_SalesPerson","SalesPerson_Id","where SalesPerson_Name='"+user_name+"' and active=1 and PurchaseSale=0");

		//System.out.println("SalsPerson Id "+sersonId);
		if(sersonId.equals(""))
		{//System.out.println("Under this");
		%><td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id\' TABINDEX=\'19","","where company_id="+company_id+" and PurchaseSale=0")%></td>
		<%}
		else
		{%>
			<td><%=user_name%><td>
			<input type=hidden name='salesperson_id' value=<%=sersonId%>>
		<%}
	}
	else
	{%>
		<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","salesperson_id\' TABINDEX=\'20","","where company_id="+company_id+" and PurchaseSale=0")%></td>
	<%}%>

</tr>

<tr>
 <td>Purchase</td>	<td>&nbsp;</td> 
 <input type=hidden size=4 name="opening_purchasebalance" value=0 onBlur='validate(this)' style="text-align:right">

<td>Purchase Party Group : 

<a href="javascript:tb1('../Finance/PartyGroupType.jsp?command=Default&message=Default')" >
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'>
</a>

</td>
<td>	<%=AC.getMasterArrayCondition(conp,"PartyGroup","purchasepartygroup_id\'  TABINDEX=\'21",A.getNameCondition(conp,"Master_PartyGroup","partygroup_id","where PartyGroup_Name='Normal' and Group_Type=1 and company_id="+company_id),"where Active=1 and Group_Type=1",company_id)%></td>

<td>Purchase Person
<a href="javascript:tb1('../Master/PurchasePersonFrame.jsp?command=Default&message=Purchase')">
	<img src="../Buttons/add.jpg" height="8" width="8" target='bottom'>
</a>
</td>
	<%if("15".equals(user_level))
	{	
		String personId=A.getNameCondition(conp,"Master_SalesPerson","SalesPerson_Id","where SalesPerson_Name='"+user_name+"' and active=1 and PurchaseSale=1");
		if(personId.equals(""))
		{%><td>
			<%=AC.getMasterArrayCondition(conp,"SalesPerson","purchaseperson_id\' TABINDEX=\'22" ,"","where company_id="+company_id+" and PurchaseSale=1")%>
			</td>
		<%}
		else
			{%>
				<td><%=user_name%></td>
				<input type=hidden name='purchaseperson_id' value=<%=personId%>>	
		<%}
	}else{%>
	<td><%=AC.getMasterArrayCondition(conp,"SalesPerson","purchaseperson_id\' TABINDEX=\'22" ,"","where company_id="+company_id+" and PurchaseSale=1")%></td>
	<%}%>
</tr>

<tr>
<td colspan=3 id='td_id' align=center>Other Information<input type=checkbox name=other_info_name id='other_info_name' OnClick="ShowHideInfo();" TABINDEX='23'><td colspan=3 align='center'> 

<INPUT type=Button  name=command  value='SAVE' class='Button1' id="button3" OnClick="submitMe(this.value);" TABINDEX='24'>  </td>

</tr>

<tr><td colspan=6><hr bgcolor=skyblue></hr></td></tr>
<!-- For new ledger   -->


<!-- <tr><td colspan=4><hr bgcolor=skyblue></hr></td></tr> -->
</table>	
</span>	





<input type=hidden name=pn value=no>
<!-- Opening Balance --> <input type=hidden size=4 name="opening_pnbalance" value=0 onBlur='validate(this)' style="text-align:right">
<input type=hidden name=pn_creditdebit value='Credit'>
	





<!-- <td><!-- Credit Limit </td><td> -->
<input type=hidden size=8 name="credit_limit" value=0 onBlur='validate(this)' style="text-align:right"><!-- </td> -->



<!--<td> Shikesho --><input type=hidden size=8 name="shikesho" value='no' ><!-- Due Days </td>
<td>--><input type=hidden name=duedays value="0" style="text-align:right" size=7 onblur="return validate(this,0)"><!-- </td> -->

<input type=hidden name="closing" value='13'>
<input type=hidden name="payment" value='1'>

<input type=hidden name=interest value="0" style="text-align:right" size=7 onblur="return validate(this,2)">

<!-- /****************** bank and cash ***********************************/
 -->

<span id='cash_span' style='visibility:Hidden'>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2>

<tr>
<td>Main Account &nbsp;&nbsp;&nbsp;&nbsp;<input type=checkbox name=main_account value=main_account selected TABINDEX="15"></td>
<td></td>
</tr>

<input type=hidden name=command1 value='Default' >
<input type=hidden name=type  value=''>  
<tr>
	<td align=center colspan="4"><input type=Button value='SAVE' name=command class='Button1' OnClick="submitMeForCash(this.value);" TABINDEX="16">
	</td>
</tr>
</table>
</span>


<span id='bank_span' style='visibility:Hidden'>
<table borderColor=blue border=0 WIDTH="100%" cellspacing=0 cellpadding=2>

<tr>
<td>Main Account &nbsp;&nbsp;&nbsp;&nbsp;<input type=checkbox name=main_account value=main_account selected  TABINDEX="15"> </td>
<td></td>
</tr>

<input type=hidden name=command1 value='Default' >
<input type=hidden name=type  value=''>  
<tr>
	<td align=center colspan="2"><input type=Button value='SAVE' name=command class='Button1' OnClick="submitMeForBank(this.value);" TABINDEX="16">
	</td>
</tr>
</table>
<!-- /************************End  Bank and Cash *************************/
 --></span>

</td>
</tr>
</TABLE>
</form>
</BODY>
</HTML>
<% 
	C.returnConnection(conp);	
	C.returnConnection(cong);	
	
}
catch(Exception e170){ 
	C.returnConnection(conp);	
	C.returnConnection(cong);
	out.println("<font color=red> FileName : GL_NewParty.jsp <br>Bug No e170 :"+ e170 +"</font>");
	}
	%>








