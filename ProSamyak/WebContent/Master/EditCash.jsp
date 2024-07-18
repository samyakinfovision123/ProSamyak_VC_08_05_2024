<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
//out.println("<font color=red> FileName : EditCash.jsp");

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String command=request.getParameter("command");


ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try	{
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : Cash.jsp<br>Bug No e31 : "+ e31);}



String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String CashQuery = "select * from Cash where  company_id=?";
pstmt_p  = conp.prepareStatement(CashQuery);
pstmt_p.setString (1,company_id);
//out.print("<br>CashQuery:"+CashQuery+"<br>company_id"+company_id);
rs_g = pstmt_p.executeQuery();
//out.print("<br>After CashQuery:"+CashQuery);
	int counter =0;
int cashpresent=0;
String cash_id="";
String opening_localbalance="";
String opening_dollarbalance="";
String opening_exchangerate="";
java.sql.Date opening_date = new java.sql.Date(System.currentTimeMillis());

String currency="";
double exrate=0;
double cash_amount=0;
String credit_debit="Credit";
String description="";
while(rs_g.next())
{
cashpresent++;
cash_id=rs_g.getString("Cash_Id");
opening_localbalance=rs_g.getString("opening_localbalance");
//out.print("<br>2currency:"+opening_localbalance);
opening_dollarbalance=rs_g.getString("opening_dollarbalance");
//out.print("<br>opening_dollarbalance:"+opening_dollarbalance);
opening_exchangerate=rs_g.getString("opening_exchangerate");
//out.print("<br>opening_exchangerate:"+opening_exchangerate);
opening_date=rs_g.getDate("Created_On");
//out.print("<br>1opening_date:"+opening_date);
description=rs_g.getString("Description");
currency=rs_g.getString("Transaction_Currency");
//out.print("<br>2currency:"+currency);
//out.print("<br>2:"+opening_exchangerate);
}
pstmt_p.close();
 
if(cashpresent>0)
{
	if(Double.parseDouble(opening_localbalance) >= 0)
	{
	credit_debit="Debit";
	}

 

if("Default".equals(command))
{
try{
%>
<html><head><title>Samyak Software - INDIA</title>
<script language="JavaScript">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" >
<form action="../Finance/CashUpdate.jsp" method=post name=mainform onSubmit='return onSubmitValidate(cash_amount,datevalue)'>

<input type=hidden  name=cash_id value=<%=cash_id%>
<table align=center border=2 bordercolor=skyblue>
<tr><td>
<table align=center border=1>

<tr>
<th align=center bgcolor=skyblue colspan=2>Update Opening Cash Balance
</th>
</tr>

<tr>
<td>Cash Opening Date</td>
<td colspan=1> <input type=text name='datevalue' size=8 maxlength=10 value="<%=format.format(opening_date)%>"
onblur='return  fnCheckDate(this.value,"Date")'>
<script language='JavaScript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Select' style='font-size:11px ; width:50'>")}
</script>
</td>
</tr>

<tr>
<td>Currency
<% if ("1".equals(currency)) {
cash_amount=Double.parseDouble(opening_localbalance);	
d=d;
%>

<input type=radio size=4 name=currency value=local checked>Local <input type=radio size=4 name=currency value=dollar>Dollar</td>
<% } else { 
cash_amount=Double.parseDouble(opening_dollarbalance);
d=2;
	%>
<input type=radio size=4 name=currency value=local > Local <input type=radio size=4 name=currency value=dollar checked>Dollar</td>
</td>
<% } %>


<td>Exchange Rate/$ <font class="star1">*</font>
<input type=text size=4 name=exrate value='<%=opening_exchangerate%>'  onBlur='validate(this)'></td>

</tr>

<tr>
<td>Cash Opening Balance</td>

<%
if("Debit".equals(credit_debit))
{	
%>
<td><input type=text size=4 name="cash_amount" value=<%=str.mathformat(""+cash_amount,d)%> onBlur='validate(this)'>
<Select name=Credit_Debit>
	<option value='Credit'>Dr</option>
	<option value='Debit'>Cr</option>
</select>
<% } else { %>
<td><input type=text size=4 name="cash_amount" value=<%=str.mathformat(""+(-(cash_amount)),d)%> onBlur='validate(this)'>
<Select name=Credit_Debit>
	<option value='Debit'>Cr</option>	
	<option value='Credit'>Dr</option>
</select>
<% } %>
</td>
</tr>

<tr>
<td>Description</td>
<td colspan=3><input type=text size=20 name=description value="<%=description%>"></td>
</tr>

<tr><td align=center colspan=4>
<input type=submit name=command value='Update' class='Button1'>
</td></tr>
</table>
</td></tr>
</table>
</FORM>
</BODY>
</HTML>
<% 
C.returnConnection(conp);

} //try 
	catch(Exception Samyak131){ 
	out.println("<font color=red> FileName : ../Master/EditCash.jsp<br>Bug No Samyak131 : "+ Samyak131);}
}//if
}//if cashpresent
else{
	C.returnConnection(conp);

out.print("<body bgcolor=ffffee background=../Buttons/BGCOLOR.JPG >");
out.print("<center><font color=red>Cash is not Present</font></center>");
}
%>








