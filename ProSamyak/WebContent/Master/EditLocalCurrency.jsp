<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<jsp:useBean id="C"  scope="application" class="NipponBean.Connect" />


<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	Connection cong = null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;
 	try{
		cong=C.getConnection();
		}
	catch(Exception Samyak40){ 
	out.println("<br><font color=red> FileName : EditLocalcurrecy.jsp <br>Bug No Samyak40 :"+ Samyak40 +"</font>");} 

%>

<HTML>
<HEAD>
<TITLE>Samyak Software</TITLE>
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
</script>
</HEAD>


<BODY bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" vlink="blue">

<%
	String command   = request.getParameter("command");
	//out.println("command :"+command);


try{
if("edit".equals(command))
{
 
String message = request.getParameter("message"); 
if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}


String LocalQuery="";
String currency_id =""; 		
String currency_name="";		
String currency_symbol="";		
double base_exchangerate=0;	
int counter=0;

LocalQuery = "select * from Master_Currency where local_currency=1 and company_id="+company_id;

//out.println("<br>LocalQuery :"+LocalQuery);

pstmt_g  = cong.prepareStatement(LocalQuery);
rs_g = pstmt_g.executeQuery();

while(rs_g.next())
{
 counter++;
 currency_id=rs_g.getString("Currency_Id");
 currency_name=rs_g.getString("Currency_Name");
 currency_symbol=rs_g.getString("Currency_Symbol").trim();
 base_exchangerate=Double.parseDouble(rs_g.getString("Base_ExchangeRate"));
}
pstmt_g.close();
//out.println("<br>counter :"+counter);
 
%>

<form action=UpdateCurrency.jsp method=post >
	<table align=center cellspacing=0 border=1 bordercolor=skyblue cellspacing=0>

	<tr class="thcolor"><th colspan=3>Edit Local Currency </th></tr>

	<tr>
		<th>Symbol</th>
		<th>Name</th>
		<th>Exchange Rate<br> per US $</th>
	</tr>
	
<input type=hidden name=currency_id value=<%=currency_id%>>

	<tr>
		<td align=center><%=currency_symbol%></td>
		<td align=center><%=currency_name%></td>
		<td align=center><input type=text name=base_exchangerate value="<%=str.format(base_exchangerate)%>" size=4  onBlur='ValidateNumber(this)'></td>
	</tr>

	<tr>
	<td colspan=3 align=center>
	<input type=submit name=command value='Update Local Currency' class='Button2' >
	</td>
	</tr>
<tr>
<td align=center valign=middle>
<A href="../Master/EditCompany.jsp?command=CompanySelected&message=masters&CompanyParty_Id=<%=(company_id)+123%>" target="_blank">
<!-- <img src='../Buttons/HOUSE.GIF'  border=0> -->
</a>
</td>
</tr>
</table>

</form>	
<%
	C.returnConnection(cong);



}//if Currency 
}catch(Exception Samyak127){ 
out.println("<br><font color=red> FileName : EditLocalCurrecny.jsp <br>Bug No Samyak108 :"+ Samyak127 +"</font>");}
%>
<%
try{
if("update".equals(command))
{
%>
<form action=EditLocalCurrency.jsp >
<table align=center border=1 cellspacing=0>
	<tr><th colspan=2 class="thcolor" >Modify Ex-Rate 
	<tr><td>From <td><%=L.date(D,"dd1","mm1","yy1")  %> </td></tr>
	<tr><td>To Next	 
			<td>
				<select name=counter>
				<option value=1> 1 </option>	
				<option value=2> 2 </option>	
				<option value=3> 3 </option>	
				<option value=4> 4 </option>	
				<option value=5> 5 </option>	
				<option value=6> 6 </option>	
				<option value=7> 7 </option>	
				<option value=8> 8 </option>	
				<option value=9> 9 </option>	
				<option value=10> 10</option>	
				</select>	
				Days </td></tr>
	<tr align=center><td colspan=2> <input type=submit name=command value='Show To Modify' class='Button1'>
</form>
<%

		C.returnConnection(cong);

	}//if Currency 
}catch(Exception Samyak145){ 
out.println("<br><font color=red> FileName : EditLocalCurrecny.jsp <br>Bug No Samyak145 :"+ Samyak145 +"</font>");}
%>

<%
try{
if("Show To Modify".equals(command))
{
		

	int counter = Integer.parseInt(request.getParameter("counter"));
	int dd1 = Integer.parseInt(request.getParameter("dd1"));
	int mm1 = Integer.parseInt(request.getParameter("mm1"));
	int yy1 = Integer.parseInt(request.getParameter("yy1"));
	java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
	
	int dd2 = dd1 + counter;
	java.sql.Date D2 = new java.sql.Date((yy1-1900),(mm1-1),dd2);
%>
<form name=f1 action=UpdateCurrency.jsp >
<table align=center border=1 cellspacing=0>
<tr>
	<td align=center>Date</td>
	<td align=center>Rate</td>
</tr>
<%	
	for(int i=0;i < counter; i++)
	{
	 dd2 = dd1 + i;
	 D2 = new java.sql.Date((yy1-1900),(mm1-1),dd2);

String currency_id = I.getLocalCurrency(cong,company_id);
//out.print(" currency_id "+currency_id);
String query = "select * from Master_ExchangeRate where Exchange_Date=? and currency_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D2);
pstmt_g.setString(2,currency_id);
rs_g = pstmt_g.executeQuery();

String ex_rate="0";
String ex_id ="0";
if(rs_g.next()) 
	{ 
		ex_rate = rs_g.getString("Exchange_Rate"); 
		ex_id   = rs_g.getString("ExchangeRate_Id"); 
		//out.print("ex_rate "+ex_rate);
	}
%>
	<tr>
	<td><input type=hidden name=date<%=i%> value='<%=format.format(D2)%>'>
	<%=format.format(D2) %></td>
	<td><input type=text name=rate<%=i %> value=<%=str.format(ex_rate) %> size=5></td>
	<%if("0".equals(ex_rate)) { %>
	<input type=hidden name=query<%=i %> value="insert" >
	<% } else { 
	%>
	<input type=hidden name=query<%=i %> value="update" >
	<input type=hidden name=ex_id<%=i %> value="<%=ex_id %>" >
	</tr>	
	

	<%	
	}	//else

}//for
%>
<tr align=center><Td colspan=2 ><input type=hidden name=counter value=<%=counter %>>
		<input type=submit name=command value=Update class='Button1'>
<%
	C.returnConnection(cong);

}//if Show To Modify
}catch(Exception Samyak108){ 
out.println("<br><font color=red> FileName : EditLocalCurrecny.jsp <br>Bug No Samyak108 :"+ Samyak108 +"</font>");}
%>

</BODY>
</HTML>
