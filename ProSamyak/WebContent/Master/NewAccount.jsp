<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<% 

try{
String yearend_id= ""+session.getValue("yearend_id");
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
String command = request.getParameter("command");
String type = request.getParameter("type");
//out.print("<BR>command="+command);
Connection conp = null;
PreparedStatement pstmt_p=null;
ResultSet rs_g= null;

try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}


String startDate = format.format(YED.getDate(conp,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//out.print("<br>43=>  "+startDate);
java.sql.Date temp_endDate=YED.getDate(conp,"YearEnd","To_Date","where YearEnd_Id="+yearend_id);
int temp_dd1=temp_endDate.getDate();
int temp_mm1=temp_endDate.getMonth();
int temp_yy1=temp_endDate.getYear();
temp_endDate=new java.sql.Date(temp_yy1+1,temp_mm1,temp_dd1); 
String endDate = format.format(temp_endDate);



if("Default".equals(command))
{

%>
<HTML>
<HEAD>
<TITLE> Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
var errfound = false;
function Validate()
	{
	
	
	var flag1;
      
	   flag1=	fnCheckDate(document.mainform.datevalue.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);
		if(flag1==false)
			return false;
	
	
	errfound = false;

	if(document.mainform.account_name.value == "")
		{
		alert("Please enter Account's name.");
		document.mainform.account_name.select();
		return errfound;
		}
	else {
			var tempA=document.mainform.account_name.value;
			if(tempA.length < 4)
			{
			alert("Please enter Account's name Properly. Must be more than three characters");
			document.mainform.account_name.select();
			return errfound;
			}
		else if(document.mainform.account_no.value == "")
		{
		alert("Please enter Account no.");
		document.mainform.account_no.select();
		return errfound;
		}
		else if(document.mainform.bank_id.value == "")
		{
		alert("Please enter Bank Name.");
		document.mainform.bank_id.select();
		return errfound;
		}
			else{
				return !errfound;
				}
		}// else 


}//validate

function fnCheckInteger(astrFieldValue,astrFieldName)
{
	var RefString="1234567890";
	var InString = astrFieldValue;	

	//check only the characters present in RefString are entered

	for (Count=0; Count < InString.length; Count++)  
	{			
        if (RefString.indexOf (InString.substring (Count, Count+1))==-1)  
		{
				alert(astrFieldName + " should be Integer");
				mainform.qty_order_point.select();
				return (false);
		}// if
     }// for
     return true;
}
</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/SamyakYearEndDate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<%
	String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String sr_no= ""+L.get_master_id(conp,"Master_Account");
String temp="Bank";
if("cash".equals(type))
	{temp="Cash";}
%>
<br>

<form name=mainform action=UpdateAccount.jsp method=post onsubmit="return Validate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="2">Add New <%=temp%> Account</th>
</tr>
<!-- <tr>
	<td>Sr. No.</td>
	<td ><%=sr_no%></td>
</tr> -->
<tr>
	<td><%=temp%> Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=account_name ></td>
</tr>
<tr>
	<td ><%=temp%> No.<font class="star1">*</font> </td>
	<td > <input type=text size=20 name=account_no ></td>
</tr>
<%
if("cash".equals(type))
	{
%>
	<input type=hidden  name=accounttype_id  value='6'> 
	<input type=hidden name=bank_id  value=self>  

	<%
	}
	else{
	%>
<tr>
	<td> Branch Name<font class="star1">*</font></td>
	<td><input type=text size=20 name=bank_id > <%//=A.getMasterArray("Bank","bank_id","",company_id)%></td>
</tr>
<input type=hidden size=20 name=accounttype_id  value='1'>  
<%}%>
<tr>
	<td>Description.</td>
	<td ><input type=text size=40 name=description ></td>
</tr>

<tr>
<td>Opening Date</td>
<td colspan=3> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date",<%out.print("\""+startDate+"\"");%>,<%out.print("\""+endDate+"\"");%>);'>

<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Select' style='font-size:11px ; width:50'>")}
</script>
</td>
</tr>
<tr>
<td>Currency</td>
<td><input type=radio size=4 name=currency value=local checked>Local&nbsp;<input type=radio size=4 name=currency value=dollar>Dollar</td>
</tr>
<tr>
<td>Main Account</td>
<td><input type=checkbox name=main_account value=main_account selected></td>
</tr>

<tr>
	<%
	//String exec=I.getLocalExchangeRate(conp,company_id);
//out.print("<br>200exec=>"+exec);
%>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=3 name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>'  onBlur='validate(this)'></td>
</tr>
<tr>
<td>Opening Balance</td>
<td>
<input type=text size=6 name="opening_balance" value=0 onBlur='validate(this)' style="text-align:right;"><Select name=credit_debit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
</tr>
<input type=hidden name=command1 value='Default' >
<input type=hidden name=type  value=<%=type%>>  
<tr>
	<td align=center colspan="2"><input type=submit value='SUBMIT' name=command class='Button1'>
	</td>
</tr>
</table>
</table>
</form>
</BODY>
</HTML>
<%
	C.returnConnection(conp);	
		
	} //if Default

if("Bank_OD".equals(command))
{

%>
<HTML>
<HEAD>
<TITLE>Samyak Software</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
var errfound = false;
function Validate()
	{
	errfound = false;

	if(document.mainform.account_name.value == "")
		{
		alert("Please enter Account's name.");
		document.mainform.account_name.select();
		return errfound;
		}
	else {
			var tempA=document.mainform.account_name.value;
			if(tempA.length < 4)
			{
			alert("Please enter Account's name Properly. Must be more than three characters");
			document.mainform.account_name.select();
			return errfound;
			}
		else if(document.mainform.account_no.value == "")
		{
		alert("Please enter Account no.");
		document.mainform.account_no.select();
		return errfound;
		}
		else if(document.mainform.bank_id .value == "")
		{
		alert("Please enter Bank Name.");
		document.mainform.bank_id .select();
		return errfound;
		}
			else{
				return !errfound;
				}
		}// else 

	
}//validate

function fnCheckInteger(astrFieldValue,astrFieldName)
{
	var RefString="1234567890";
	var InString = astrFieldValue;	

	//check only the characters present in RefString are entered

	for (Count=0; Count < InString.length; Count++)  
	{			
        if (RefString.indexOf (InString.substring (Count, Count+1))==-1)  
		{
				alert(astrFieldName + " should be Integer");
				mainform.qty_order_point.select();
				return (false);
		}// if
     }// for
     return true;
}
</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<%
	String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String sr_no= ""+L.get_master_id(conp,"Master_Account");
%>
<br>

<form name=mainform action=UpdateAccount.jsp method=post onsubmit="return Validate();">
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
	<th align=center colspan="2">Add New O/D Account</th>
</tr>
<!-- <tr>
	<td>Sr. No.</td>
	<td ><%=sr_no%></td>
</tr> -->
<tr>
	<td>Account Name<font class="star1">*</font></td> 
	<td colspan=3> <input type=text size=30 name=account_name ></td>
</tr>
<tr>
	<td >Account No.<font class="star1">*</font> </td>
	<td > <input type=text size=20 name=account_no ></td>
</tr>
<tr>
	<td>Bank Ajay Name<font class="star1">*</font></td>
	<td><input type=hidden size=5 name=bank_id > <%//=A.getMasterArray("Bank","bank_id","",company_id)%></td>
</tr>
<input type=hidden size=20 name=accounttype_id  value='4'>  <%//=A.getMasterArray("AccountType","accounttype_id","")%>
<tr>
	<td>Description.</td>
	<td ><input type=text size=40 name=description ></td>
</tr>

<tr>
<td>Opening Date</td>
<td colspan=3> <input type=text name='datevalue' size=8 maxlength=10 value="<%=today_string%>"
onblur='return  fnCheckDate(this.value,"Date")'>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Select' style='font-size:11px ; width:50'>")}
</script>
</td>
</tr>
<tr>
<td>Currency</td>
<td><input type=radio size=4 name=currency value=local checked>Local&nbsp;<input type=radio size=4 name=currency value=dollar>Dollar</td>
</tr>

<tr>
<td>Main Account</td>
<td><input type=checkbox name=main_account value=main_account selected></td>
</tr>

<tr>
<td>Exchange Rate/$ <font class="star1">*</font></td>
<td colspan=2><input type=text size=3 name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>'  onBlur='validate(this)'></td>
</tr>
<tr>
<td>Opening Balance</td>
<td>
<input type=text size=6 name="opening_balance" value=0 onBlur='validate(this)' style="text-align:right;"><Select name=credit_debit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select></td>
</tr>
<input type=hidden name=command1 value='Bank_OD' >
<tr>
	<td align=center colspan="2"><input type=submit value='SUBMIT' name=command>
	</td>
</tr>
</table>
</table>
</form>
</BODY>
</HTML>
<% } //if Bank_OD
}catch(Exception e){out.print("<br>New Account.jsp Exception 352 "+e);}
%>








