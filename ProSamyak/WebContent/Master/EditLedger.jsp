<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<%
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();

	Connection conp = null;
	PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;
	try{
		conp=C.getConnection();
	}catch(Exception Samyak13)
	{ 
	out.println("<font color=red> FileName : EditLedger.jsp <br>Bug No Samyak13 :"+ Samyak13 +"</font>");
	}

String command = request.getParameter("command");
//out.println(command);
String message = request.getParameter("message"); 
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

if("masters".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center><br>");}

	%>

<% 
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<% 

	if("edit".equals(command))
	{
%>
<form action="EditLedger.jsp?command=SELECT&message=masters" method=post >
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
	<th colspan=2 bgcolor="skyblue">Select Group </th>
</tr>

<tr><td>Under</td>
<td>
<select name=category>

<option value='3'>Capital </option>
<option value='15'>Current Assets</option>
<option value='17'>Current Liabilities</option>
<option value='6'>Direct Expenses </option>
<option value='2'>Fixed Asset</option>
<option value='13'>Indirect Expenses </option>
<option value='12'>Indirect Income </option>
<option value='5'>Investment</option>
<option value='7'>Loan(Liabilities) </option>
<option value='11'>Loan & Advances </option>
<option value='16'>Misc Expenditure</option>
<option value='18'>Reserves & Surplus</option>


<!-- <option value='6' >Sundry Expenses</option>
 --></Select>


</td>
</tr>
<tr>
	<td colspan=2 align=center>
	<INPUT type=submit  name=command  value='SELECT' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
	</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
</html>
</body>
<%

	C.returnConnection(conp);

}
%>

<%
try{
	if("SELECT".equals(command))
	{
	int Freeze=0;
	String Newq="Select max(Freeze) as Freeze from YearEnd where Company_Id="+company_id+" and Active=1";

	pstmt_p=conp.prepareStatement(Newq);
	
	rs_g=pstmt_p.executeQuery();

	while(rs_g.next())
		{
		Freeze=rs_g.getInt("Freeze");
		}
		pstmt_p.close();
 
String category=request.getParameter("category");
//out.println("<br>121 category="+category);
//out.println("<br>122 company_id="+company_id);
String query = "Select * from Ledger where Company_id=?  and For_Head=? order by Ledger_Name";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,category); 
	rs_g = pstmt_p.executeQuery();	
	int n=0;
	while(rs_g.next())
	{
		n++;
	}
	pstmt_p.close();
//	out.println("<BR>"+n);
	int counter=n;
	String ledger_id[]=new String[counter]; 
	String ledger_name[]=new String[counter]; 
	String ledger_type[]=new String[counter]; 
	String description[]=new String[counter]; 
	String exchange_rate[]=new String[counter]; 
	double opening_localbalance[]=new double[counter]; 
	double opening_balance[]=new double[counter]; 
	double opening_dollarbalance[]=new double[counter]; 
	String active[]=new String[counter]; 
	boolean ledgerpresent[]=new boolean[counter];
	String Ledger_Currency[]=new String[counter]; 

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,category); 
	rs_g = pstmt_p.executeQuery();	
	 n=0;
	while(rs_g.next())
	{
	ledger_id[n]=rs_g.getString("Ledger_Id");	
	ledger_name[n]=rs_g.getString("Ledger_Name");	
	ledger_type[n]=rs_g.getString("Ledger_Type");	
	description[n]=rs_g.getString("Description");	
	opening_localbalance[n]= rs_g.getDouble("Opening_LocalBalance");	
	opening_balance[n]= rs_g.getDouble("Opening_Balance");	
	opening_dollarbalance[n]= rs_g.getDouble("Opening_DollarBalance");	
	exchange_rate[n]=rs_g.getString("Exchange_Rate");	
	active[n]=rs_g.getString("active");	

	if (opening_localbalance[n]==opening_balance[n])
		{
		
		Ledger_Currency[n]="Local";
		}
else
		{
		Ledger_Currency[n]="Dollar";
		}
	n++;}
		pstmt_p.close();
for(int i=0; i<counter; i++)
{
ledgerpresent[i]=false;
query = "Select * from Financial_Transaction where Company_id=? and Ledger_Id=? and Active=1";
pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,company_id); 
	pstmt_p.setString(2,ledger_id[i]); 
	rs_g = pstmt_p.executeQuery();	
	while(rs_g.next())
	{ledgerpresent[i]=true;}
		pstmt_p.close();

}

String category_name= A.getNameCondition(conp,"Master_FinanceHeads","Head_Name","Where Head_id="+category+"" );
%>
<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action='UpdateLedger.jsp' method=post>
<table border=1  cellspacing=0 cellpadding=2 align=center>
<tr><th colspan=8> <%=category_name%></th></tr>
<tr bgcolor="skyblue">
	<th>Sr .No</th> <th>Name</th><th>Type</th> <th>Description</th><th colspan=2>Opening Balance(<%=local_symbol%>)</th><th>Ex-Rate</th> <th>Active</th></tr>
<%
for(int i=0; i<counter; i++)
{

String str1="";
if("1".equals(active[i]))
	{str1="checked";}
	%>
<tr>
<input type=hidden name=ledger_id<%=i%> value='<%=ledger_id[i]%>'>
<input type=hidden name=Ledger_Currency<%=i%> value='<%=Ledger_Currency[i]%>'>
<input type=hidden name=opening_dollarbalance<%=i%> value='<%=opening_dollarbalance[i]%>'>
<!-- <input type=hidden name=opening_localbalance<%=i%> value='<%//=opening_localbalance[i]%>'> -->
<td><%=i+1%></td>
<td>
<%if("C. Tax".equals(ledger_name[i]))
{out.print(ledger_name[i]+"<input type=hidden name=ledger_name"+i+" value='"+ledger_name[i]+"' </td>");
}
else{
		%>
		<input type=text name=ledger_name<%=i%> value='<%=ledger_name[i]%>' size=15></td>
<%}%>
<td> <%=A.getMasterArrayCondition(conp,"SubGroup","type"+i,ledger_type[i], "where For_HeadId="+category+"",company_id) %></td>
<td><input type=text name=description<%=i%> value='<%=description[i]%>' size=15></td>
<td >
<%//=(opening_localbalance[i])%>
<%
//out.print("<br>opening_localbalance="+opening_localbalance[i]);
if (Freeze==1){
if(opening_localbalance[i]<0)
	{
%><input type=text name=opening_localbalance<%=i%> value= '<%=str.mathformat(""+((opening_localbalance[i])*-1),d)%>' size=15 readonly style="background:#CCCCFF" style="text-align:right;">
</td><td>
<Select name=creditdebit<%=i%>disabled style="background:#CCCCFF" >
	<option value='Debit'>Dr</option>
	<option value='Credit' selected>Cr</option>
</select>
<%}else{%>
<input type=text name=opening_localbalance<%=i%> value= '<%=str.mathformat(""+opening_localbalance[i],d)%>'readonly size=15 style="text-align:right;"style="background:#CCCCFF" >
</td><td>
<Select name=creditdebit<%=i%> disabled style="background:#CCCCFF" >
	<option value='Debit'>Dr</option>
	<option value='Credit' selected>Cr</option>
</select>
<%}%>
</td>
<td>
<input type=text name=exchange_rate<%=i%> value='<%=str.format(""+(exchange_rate[i]))%>'style="background:#CCCCFF" readonly size=8 style="text-align:right;">
	</td>
	<%}else{
if(opening_localbalance[i]<0)
	{
%><input type=text name=opening_localbalance<%=i%> value= '<%=str.mathformat(""+((opening_localbalance[i])*-1),d)%>' size=15 style="text-align:right;">
</td><td>
<Select name=creditdebit<%=i%>>
	<option value='Debit'>Dr</option>
	<option value='Credit' selected>Cr</option>
</select>
<%}else{%>
<input type=text name=opening_localbalance<%=i%> value= '<%=str.mathformat(""+opening_localbalance[i],d)%>' size=15 style="text-align:right;">
</td><td>
<Select name=creditdebit<%=i%>>
	<option value='Debit'>Dr</option>
	<option value='Credit'>Cr</option>
</select>
<%}%>
</td>
<td>
<input type=text name=exchange_rate<%=i%> value='<%=str.format(""+(exchange_rate[i]))%>' size=8 style="text-align:right;">
	</td>

	<%}%>
<td>
<%
if (Freeze==1){
if("C. Tax".equals(ledger_name[i]))
{out.print("Active <input type=hidden name=active"+i+" value='yes'> " );
}
else if(ledgerpresent[i]){%>
<input type=hidden name=active<%=i%> disabled value='yes'>
		<%}else{%>
<input type=checkbox name=active<%=i%> disabled value='yes' <%=str1%>></td>
<%}
}else{
if("C. Tax".equals(ledger_name[i]))
{out.print("Active <input type=hidden name=active"+i+" value='yes'> " );
}
else if(ledgerpresent[i]){%>
<input type=hidden name=active<%=i%> value='yes'>
		<%}else{%>
<input type=checkbox name=active<%=i%> value='yes' <%=str1%>></td>
<%}%>

<%}%>
</tr>
<%}//for%>
<input type=hidden name=counter value='<%=counter%>'>
<input type=hidden name=category_name value='<%=category_name%>'>
<tr align=center>
<td colspan=8>
	<input type=submit  name=command  value='UPDATE' class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 

</td>
</tr>
</table></form>
<%
	C.returnConnection(conp);

}//if SELECT

}catch(Exception Samyak233){ 
	out.println("<br><font color=red> FileName : EditParty.jsp <br>Bug No Samyak233 :"+ Samyak233 +"</font>");} 
%>

</BODY>
</HTML>









