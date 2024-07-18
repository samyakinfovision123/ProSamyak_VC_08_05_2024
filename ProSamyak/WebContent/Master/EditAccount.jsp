<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="I"    class="NipponBean.Inventory" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<%
//System.out.print(" Inside Account Edit");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String errLine="13";

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
try
	{
		conp=C.getConnection(); 	
	}catch(Exception e14){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e14 :"+ e14 +"</font>");}

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
String base_exchangerate= I.getLocalExchangeRate(conp,company_id);
errLine="28";
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String command = request.getParameter("command");
String type = request.getParameter("type");
//	out.print("<br>"+command);
String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);

%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
function Validate()
	{
var flag;
      
	  
		flag=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag==false)
		return false;





	errfound = false;

	if(document.mainform.account_name.value == "")
		{
		alert("Please enter Account's name.");
		document.mainform.account_name.select();
		return errfound;
		}
	else 
		{
			var tempA=document.mainform.account_name.value;
			if(tempA.length < 4)
			{
			alert("Please enter Account's name Properly. Must be more than three characters");
			document.mainform.account_name.select();
			return errfound;
			}
		else
			{
			if(document.mainform.account_number.value == "")
				{
				alert("Please enter Account no.");
				document.mainform.account_number.select();
				return errfound;
				}
			else
				{
				return !errfound;
				}
			}

}
	}//validate

</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<% 
errLine="111";
if("edit".equals(command))
{
try{
String temp_name="Account";
String AccountQuery = "";
//out.print("<br> 88 type "+type);
if("cash".equals(type))
	{
temp_name="Cash";
		AccountQuery = "select * from Master_Account where  company_id= "+company_id+" and   yearend_id="+yearend_id+" and  AccountType_Id=6 order  by  Account_Name";

	//out.print(AccountQuery);
	}
	else {
		AccountQuery = "select * from Master_Account where  company_id="+company_id+"  and  yearend_id="+yearend_id+"  and (AccountType_Id=1 or AccountType_Id=5) order by  Account_Name";
	
	 //out.print(AccountQuery);
	}
	
	
	pstmt_p  = conp.prepareStatement(AccountQuery);
	rs_g = pstmt_p.executeQuery();
	int counter =0;
	while(rs_g.next())
	{counter++;}
//	out.println(counter);
	pstmt_p.close();
	int m =0;
	String account_id[]=new String[counter] ;
	String account_name[]=new String[counter] ;
	String account_number[]=new String[counter] ;
	//company_id[]=new String[counter];
	 //yearend_id[]=new String[counter];
	
	pstmt_p  = conp.prepareStatement(AccountQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		account_id[m]= rs_g.getString("Account_Id");
		account_name[m]=rs_g.getString("Account_Name");
		account_number[m]=rs_g.getString("Account_Number");
		//company_id[m]=rs_g.getString("company_id");
		//yearend_id[m]=rs_g.getString("yearend_id");
//out.println("1:"+account_id[m]+" 2:"+account_name[m]+" 3:"+account_number[m]);
		m++;
		}
	pstmt_p.close();
%>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4 bgcolor="skyblue">Select <%=temp_name%> Name for Edit</th>
</tr>

<tr>
<th>Sr No </th>
<th><%=temp_name%> No. </th>
<th><%=temp_name%> Name </th>
</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>
<td><%=account_number[m]%></td>
<td>
	<a  href="EditAccount.jsp?command=SelectedAccountName&account_id=<%=account_id[m]%>&type=<%=type%>"> 
<%=account_name[m]%> </a>
</td>
</tr>
<%
}// endof for m loop
		
C.returnConnection(conp);
}//try end

catch(Exception e233){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e233 :"+ e233 +"</font>" +"errLine="+errLine);}
	}	//endif of edit.equals(command)	


if("SelectedAccountName".equals(command))
	{
	try{
errLine="200";
	String account_id = request.getParameter("account_id");
//	String type = request.getParameter("type");
//	out.println(account_id);
	String account_name="";
	String account_number="";
	String bankparty_id="";
	String accounttype_id="";
	String description="";
    String isMainAccount="";
	boolean main_account=false;
	java.sql.Date op_date = new java.sql.Date(System.currentTimeMillis());
	String opening_exchangerate="";
	
	String active="";
	String tempCheck="";
	double exchange_rate=0;
	double Opening_LocalBalance=0;
	double Opening_DollarBalance=0;
	String transaction_currency="";
    errLine="219";
	


	String EditQuery = "select * from Master_Account where Account_Id="+account_id;
	//out.println(EditQuery);
	pstmt_p  = conp.prepareStatement(EditQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		account_name=rs_g.getString("Account_Name");
//		out.println("account_name:"+account_name);
		account_number=rs_g.getString("Account_Number");
//		out.println("account_number:"+account_number);
		bankparty_id=rs_g.getString("Bank_Id");
//		out.println("bankparty_id:"+bankparty_id);
		accounttype_id=rs_g.getString("AccountType_Id");
//		out.println("<br> 195 accounttype_id:"+accounttype_id);
		description=rs_g.getString("Description");
		if (rs_g.wasNull()){description="";}
		 exchange_rate=rs_g.getDouble("Exchange_Rate");
//		out.println("description:"+description);
		Opening_LocalBalance=rs_g.getDouble("Opening_LocalBalance");
		if (rs_g.wasNull()){Opening_LocalBalance=0;}
		Opening_DollarBalance=rs_g.getDouble("Opening_DollarBalance");
		if (rs_g.wasNull()){Opening_DollarBalance=0;}
		op_date=rs_g.getDate("Opening_Date");
		active=rs_g.getString("Active");
//		System.out.println("active:"+active);
		
			if("1".equals(active))
			{
				tempCheck = " checked " ;
			}
			transaction_currency=rs_g.getString("Transaction_Currency");
			isMainAccount=rs_g.getString("DisplayInEntryModule");
			//out.print("isMainAccount="+isMainAccount);
			if("1".equals(isMainAccount))
			{
				main_account=true;
			}
		}
		errLine="248";
		
		pstmt_p.close();
		errLine="254";
//System.out.println("activeyes:"+tempCheck);
String temp_name="Account";
if("6".equals(accounttype_id))
	{temp_name="Cash";	}
String local_checked="";
String dollar_checked="";
double Local_Balance=0;
//out.println("Opening_LocalBalance"+Opening_LocalBalance);
	if("1".equals(transaction_currency))
		{ local_checked = "checked" ;
		  Local_Balance	= Opening_LocalBalance;
		 }
	else {
		dollar_checked = "checked" ;
		Local_Balance = Opening_DollarBalance;
		d=2;
			}
	errLine="272";
		
	

//out.println("transaction_currency"+transaction_currency);
String today_string= format.format(op_date);
%>
<form name=mainform  action="UpdateAccount.jsp" method=post onsubmit="return Validate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="2">Update <%=temp_name%></th>
</tr>
<!-- <tr>
	<td>Sr. No.</td>
	<td><%=account_id%>
	<input type=hidden size=20 name="account_id" value="<%=account_id%>" >	
</td>
</tr> -->
<input type=hidden size=20 name="account_id" value="<%=account_id%>" >

<tr>
<td><%=temp_name%> Name <font class="star1">*</font></td> 

<%if("PN Account".equals(account_name))
	{out.print("<td colspan=3> PN Account <input type=hidden name=account_name value='"+account_name+"'></td>");
	}else{

	%>
		<td colspan=3> <input type=text size=40 name=account_name value="<%=account_name%>"></td>
<%}%>
	</tr>
<tr>
	<td ><%=temp_name%> No.<font class="star1">*</font> </td>
	<td > <input type=text size=20 name=account_number value="<%=account_number%>"></td>
</tr>

<!-- <tr>
<td> Account Type <%//=type%></td>
<td>
 -->		<%
if("cash".equals(type))
	{
%>
	<input type=hidden size=20 name=accounttype_id  value='<%=accounttype_id%>'> 
<%//=accounttype_id%>
	<input type=hidden size=20 name=bankparty_id  value=self>  
	<%
	}
	else{
	%>



<input type=hidden size=20 name=bankparty_id  value="<%=bankparty_id%>">
<%//=accounttype_id%>
<input type=hidden  size=1 name=accounttype_id value='<%=accounttype_id%>'>
	<%}%> <!-- (For Bank=1 and For Cash=6)
</td>
</tr> -->
<!-- <tr>
<td>Type</td>
<td><%//=A.getMasterArray("AccountType","accounttype_id",accounttype_id)%> </td>
</tr>
<tr>
 -->
<td>Description</td>
<td ><input type=text size=40 name=description value="<%=description%>"></td>
</tr>
<tr>
<td>Opening Date</td>
<td colspan=3> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date")'>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Select' style='font-size:11px ; width:50' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script>
</td>
</tr>
<tr>
<td>Currency</td>
<td><input type=radio size=4 name=currency value=local <%=local_checked%>>Local&nbsp;<input type=radio size=4 name=currency value=dollar <%=dollar_checked%>>Dollar</td>
</tr>

<td>Main Account</td>


<%if(main_account){

	%>
<td><input type=checkbox name=main_account value=main_account checked></td>
<%}else{
%>
<td><input type=checkbox name=main_account value=main_account ></td>
<%}%>
</tr>

<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=3 name=exchange_rate value='<%=str.mathformat(""+base_exchangerate,2)%>'  onBlur='validate(this)' style="text-align:right;"></td>
</tr>
<tr>
<td>Opening Balance</td>
<td>
<% 
if(Local_Balance>=0)
{ %>
<input type=text size=6 name="opening_balance" onBlur='validate(this)' value='<%=str.mathformat(""+Local_Balance,d)%>' style="text-align:right;">
<Select name=credit_debit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
<% } else { %>
<input type=text size=6 name="opening_balance" onBlur='validate(this)' value='<%=str.mathformat(""+(-(Local_Balance)),d)%>'>
<Select name=credit_debit>
	<option value='Debit'>Cr</option>
	<option value='Credit'>Dr</option>
</select>

<% } %>


</td>
</tr>

<tr><td>Active</td> 
	<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>
</tr>
<tr>
	<td align=center colspan="2"><input type=submit value='UPDATE ACCOUNT' name=command class='Button2' >
	</td>
</tr>
</table> 
</table> 
</form>

<%			
	C.returnConnection(conp);


	}// try end
catch(Exception e233){ 
	out.print("<font color=red> FileName : EditAccount.jsp <br>Bug No e233 :"+ e233 +"</font>" +"errLine="+errLine);}//catch end
	}// endif SelectedAccountName
	%>
</body>
</html>







