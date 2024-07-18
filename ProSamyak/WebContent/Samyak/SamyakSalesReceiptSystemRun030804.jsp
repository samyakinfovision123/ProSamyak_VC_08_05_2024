<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
//String user_id= ""+session.getValue("user_id");
//String user_level= ""+session.getValue("user_level");
//String machine_name=request.getRemoteHost();
String company_id= "1";
String company_name= A.getName("companyparty",company_id);
String local_currency= I.getLocalCurrency(company_id);

String local_symbol= I.getLocalSymbol(company_id);
int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtReport.jsp<br>Bug No e31 : "+ e31);}

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
//String command=request.getParameter("command");
//out.print("<br>command=" +command);

try{
java.sql.Date D1 = Config.financialYearStart();
//out.print("<br>D1=" +D1);
java.sql.Date D2 = Config.financialYearEnd();
//out.print("<br>D2=" +D2);
String party_id="0"; //request.getParameter("party_id");
String order_by="1"; //request.getParameter("order_by");


//out.print("<br>party=" +party_id);
String query="";

if("0".equals(party_id))
{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=? and Receive_FromId not like "+company_id+" and Purchase=1 and Receive_sell=0 and Active=1 and Return=0 order by  "+order_by+", Receive_date ,Receive_no";

}
//Receive=0 specifies that the Receive is consignment Receive
else{
query="Select * from Receive  where Receive_Date between ? and ? and Company_id=?  and Receive_FromId="+party_id+" and Purchase=1 and Receive_Sell=0 and Active=1 and Return=0 order by "+order_by+", Receive_no";
}

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	int n=0;
	while(rs_g.next())
		{n++;}
		pstmt_g.close();
int counter=n;
//out.print("<br>counter=" +counter);
String receive_id[]=new String[counter];
String receive_no[]=new String[counter];
String receive_fromid[]=new String[counter];
String receive_lots[]=new String[counter];
java.sql.Date receive_date[] = new java.sql.Date[counter];
java.sql.Date due_date[] = new java.sql.Date[counter];
double local[] =new double[counter];
double dollar[] =new double[counter];
double qty[] =new double[counter];
double rlocal[] =new double[counter];
double rdollar[] =new double[counter];
double plocal[] =new double[counter];
double pdollar[] =new double[counter];
int rcurrency[] =new int[counter];
boolean proactive[] =new boolean[counter];
double local_total=0; 
double dollar_total=0; 
double rlocal_total=0; 
double rdollar_total=0; 
double plocal_total=0; 
double pdollar_total=0; 

double receive_tot=0;
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	rs_g = pstmt_g.executeQuery();	
	n=0;
	while(rs_g.next())
		{
 receive_id[n] =rs_g.getString("Receive_id");		
receive_no[n]=rs_g.getString("receive_no");
receive_fromid[n]=rs_g.getString("Receive_FromId");
receive_date[n]=rs_g.getDate("Receive_Date");
receive_lots[n]=rs_g.getString("Receive_Lots");
rcurrency[n]=rs_g.getInt("Receive_CurrencyId");
due_date[n]=rs_g.getDate("Due_Date");
local[n] =rs_g.getDouble("Local_Total");
dollar[n] =rs_g.getDouble("Dollar_Total");
qty[n] =rs_g.getDouble("Receive_Quantity");
local[n]=str.mathformat(local[n],d);
dollar[n]=str.mathformat(dollar[n],2);

n++;
	}
		pstmt_g.close();
int m=0;
for(int i=0; i<counter; i++)
{
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 ";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{m++;}
		pstmt_g.close();


}//for
int count=m;
//out.print("<br>count=" +count);
String for_headid[]=new String[count];
double local_amount[] =new double[count];
double dollar_amount[] =new double[count];

 m=0;
for(int i=0; i<counter; i++)
{
query="Select * from Payment_Details where For_Head=9 and Transaction_Type=0 and For_HeadId=? and Active=1 ";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
for_headid[m]=rs_g.getString("For_HeadId");
local_amount[m] =rs_g.getDouble("Local_Amount");
dollar_amount[m] =rs_g.getDouble("Dollar_Amount");
local_amount[m]=str.mathformat(local_amount[m],d);
dollar_amount[m]=str.mathformat(dollar_amount[m],2);
		m++;}
	pstmt_g.close();
}//for

//out.print("<br>207count=" +count);
int j=0;
for(int i=0; i<counter; i++)
{
j=0;
rlocal[i] =0;
rdollar[i]=0;
while(j< count)
	{
	if(receive_id[i].equals(for_headid[j]))
		{
		rlocal[i] += local_amount[j];
		rdollar[i] += dollar_amount[j];
		}
	j++;
	}
}//for

for(int i=0; i<counter; i++)
{
plocal[i] =local[i] - rlocal[i];
pdollar[i] =dollar[i]-rdollar[i];
 proactive[i]=false;
if (rcurrency[i] ==0)
	{
if(pdollar[i]==0){ proactive[i]=true;}
	}
else{if(plocal[i]==0){ proactive[i]=true;}
}


receive_tot += qty[i];
local_total += local[i];
dollar_total += dollar[i];
 rlocal_total +=rlocal[i]; 
 rdollar_total +=rdollar[i]; 
 plocal_total += plocal[i]; 
 pdollar_total += pdollar[i];
}//for

%>
<html><head><title>Samyak Software</title>
<script language="JavaScript">
function disrtclick()
{
window.event.returnValue=0;
}

//background='exambg.gif'
</script></head>
<link href='../Samyak/reportcss.css' rel=stylesheet type='text/css'>

<body bgcolor=white onContextMenu="disrtclick()" >

<table align=center  border=0 cellspacing=0 width='100%'>
<tr>
<td colspan=2 align=center> <%=company_name%></td>
</tr>

<tr ><th colspan=2>
  Samyak Sales Receipt System Run Report</th></tr>
</tr>
<%
 j=1;
%>
<tr>
<td align=center>Start : <%=j++%></td>
</tr>
<%
for(int i=0; i<counter; i++)
{
	query="Update Receive set ProActive=? where Receive_Id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setBoolean(1,proactive[i]);
pstmt_g.setString (2,receive_id[i]);
int a692 = pstmt_g.executeUpdate();
pstmt_g.close();

%>


<%
}//for
C.returnConnection(cong);

%>
<tr>
<td align=center>End : <%=j++%></td>
</tr>
<tr><th colspan=2>Samyak System Run Successful.
</th></tr>

</table>
<script language="JavaScript">
function f1()
{
alert("System Run Successful.");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML>
<%
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>







