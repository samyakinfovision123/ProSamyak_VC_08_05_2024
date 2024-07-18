<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


int dd1=D.getDate();
int mm1=D.getMonth()+1;
int yy1=D.getYear()+1900;

int dd2=D.getDate();
int mm2=D.getMonth()+1;
int yy2=D.getYear()+1900;
%>


<HTML><head>
	 <title>Home - Samyak Software -India</title>

<style>
a
{
    color: white;
    text-decoration: none
}
.normal
{
    background-color: #00308F;
    color: white
}
.hover
{
    background-color: black;
    color: white
}
</style>
</head>
<body background="../Buttons/BGCOLOR.JPG">
<TABLE border=0 width="100%" >
<TR>
	<TD colspan=2 align=center>
	<table border=0 width=500>
	<tr> 
		<td align=center class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Report/DayBook_New.jsp?command=Default" target=finance_right><font size=2> Day Book</font></A>
		</td>
		<td align=center class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Report/CashBookNewFinance.jsp?command=Cash" target=finance_right><font size=2>Cash Book</font></A>
		</td>
		<td align=center class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Report/CashBookNewFinance.jsp?command=Bank" target=finance_right><font size=2>Bank Book</font></A>
		</td>
		
	</tr>
	</table>
	</TD>
	
</TR>
<TR >
	<TD width="10%" valign=top >
	<table border=0>
	<tr> 
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/Contra.jsp?command=Default&message=Default" target=finance_right><font size=2>Contra</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/Payment.jsp?command=Default&message=Default" target=finance_right><font size=2>Payment</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/PurchasePayment1.jsp?command=Default&message=Default&changedate=none" target=finance_right><font size=2>Purchase Payment</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/Receipt.jsp?command=Default&message=Default" target=finance_right><font size=2>Receipt</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/SalesReceipt1.jsp?command=Default&message=Default&changedate=none" target=finance_right><font size=2>Sale Receipt</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/CommonJournal.jsp?command=Default&message=Default" target=finance_right><font size=2>Journal</font></A>
		</td>
	</tr>
	<tr>
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Finance/SetOffJournal.jsp?command=Default&message=Default" target=finance_right><font size=2>Set-Off-Journal</font></A>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>	
		<td class="normal" onMouseover="this.className='hover'" onMouseout="this.className='normal'">
		<A HREF="../Report/PrintVouchers.jsp?command=print&message=masters" target=finance_right><font size=2>Print Voucher</font></A>
		</td>
	</tr>
	</table>
	</TD>
	
	
	<TD valign=center >
		<IFRAME name=finance_right align=right src="../Report/DayBook_New.jsp?command=Next&bydate=Invoice_Date&dd1=<%=dd1%>&mm1=<%=mm1%>&yy1=<%=yy1%>&dd2=<%=dd2%>&mm2=<%=mm2%>&yy2=<%=yy2%>" marginwidth="10" marginheight="10" hspace="0" vspace="5" frameborder="0" scrolling="auto" align="right" width='100%'  height='510'></IFRAME>
	</TD>
</TR>
</TABLE>

</body>
</HTML>




