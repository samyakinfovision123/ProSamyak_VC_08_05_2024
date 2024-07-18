<!--  
	ModifiedOn                              Date                 Status                         Work
	PrashanB & Chanchal sir                 03-06-2016           Done                           Remove scope='application' 
-->


<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="C" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
//out.println("today_string:"+today_string);
%>

<HTML>
<HEAD>
<TITLE>Samyak Software, India</TITLE>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<script>
function validate(name)
	{
	if(name.value =="") { alert("Please Enter Properly"); name.focus();}
	}


function ValidateNumber(name)
{
	if(name.value =="") 
	{ 
		alert("Please Enter Number "); 
		name.focus();
	}

	if(isNaN(name.value)) 
	{	alert("Please Enter Number Properly"); 
		name.select();
	}

	if(name.value.charAt(0) == ".") 
	{ 
		name.value="0"+name.value+"0"; 
	}

}
// ValidateNumber 

function Samyakmessage()
{
//alert ("Please wait for some time, after clicking 'ok',  Sytem check will complete its process.");
}
</script>
</HEAD>


<BODY bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" vlink="blue">

<%
	String command   = request.getParameter("command");
	//out.println("command :"+command);

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{conp=C.getConnection();}
	catch(Exception Samyak40){ 
	out.println("<br><font color=red> FileName : TodayExchangeRate.jsp <br>Bug No Samyak40 :"+ Samyak40 +"</font>");}
String message = request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}

try{
if("Default".equals(command))
{
String LocalQuery="";
String currency_id =""; 		
String currency_name="";		
String currency_symbol="";		
double base_exchangerate=0;	
int counter=0;

LocalQuery = "select * from Master_Currency where local_currency=1 and company_id="+company_id;

//out.println("<br>LocalQuery :"+LocalQuery);

pstmt_p  = conp.prepareStatement(LocalQuery);
rs_g = pstmt_p.executeQuery();

while(rs_g.next())
{
 counter++;
 currency_id=rs_g.getString("Currency_Id");
 currency_name=rs_g.getString("Currency_Name");
 currency_symbol=rs_g.getString("Currency_Symbol").trim();
base_exchangerate=Double.parseDouble(rs_g.getString("Base_ExchangeRate"));
}
pstmt_p.close();
//out.println("<br>111base_exchangerate :"+base_exchangerate);
C.returnConnection(conp);

%>

<form action="../Master/UpdateCurrency.jsp" method=post >
	<table align=center cellspacing=0 border=1 bordercolor=skyblue cellspacing=0>

	<tr ><th colspan=3 bgcolor="skyblue">Exchange Rate for <%=today_string%> </th>
		
<td align=center><%//=currency_name%> <%//=currency_symbol%></td>
	<td align=center><input type=text name=base_exchangerate value="<%=str.format(base_exchangerate)%>" size=4  onBlur='ValidateNumber(this)' style="text-align:right"> <%=currency_symbol%> / US $</td>
		<td colspan=1 align=center>
	<input type=submit name=command value='Today Save' class='Button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
	</td>

	</tr>
	
<input type=hidden name=currency_id value=<%=currency_id%>>



</table>
</form>	
<%
}//if Currency 
}catch(Exception Samyak108){ 
out.println("<br><font color=red> FileName : TodayExchangeRate.jsp <br>Bug No Samyak108 :"+ Samyak108 +"</font>");}
%>
</BODY>
</HTML>





