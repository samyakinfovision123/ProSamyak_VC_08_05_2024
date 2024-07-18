<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
if(command.equals("Nippon05"))
{
out.print("<br>16 command ="+command);
String query="";
String voucherquery="";


ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{ cong=C.getConnection();}
catch(Exception Samyak31)
{ out.println("<font color=red> FileName : 	InsertDefaultValues.jsp<br>Bug No Samyak31 : "+ Samyak31);}


voucherquery="select count(*) as voucherCount from Voucher where Voucher_Type=1 or Voucher_Type=2 or Voucher_Type=3 or Voucher_Type=10 or Voucher_Type=11 and active=1 and company_id="+company_id;   

pstmt_g = cong.prepareStatement(voucherquery);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
out.print("<br>48 voucherquery="+voucherquery);
int voucherCount=0;
while(rs_g.next())
	{
	voucherCount=rs_g.getInt("voucherCount");
	}
pstmt_g.close();

out.print("<br>54 voucherCount="+voucherCount);

int voucher_id[]=new int[voucherCount];
int voucher_no_int[]=new int[voucherCount];
String voucher_no[]=new String[voucherCount];

java.sql.Date voucher_datev1[] =new java.sql.Date[voucherCount];
voucherquery="select Voucher_Id,Voucher_Date,Voucher_No from Voucher where Voucher_Type=1 or Voucher_Type=2 or Voucher_Type=3 or Voucher_Type=10 or Voucher_Type=11 and active=1 and company_id="+company_id;   
pstmt_g = cong.prepareStatement(voucherquery);

rs_g=pstmt_g.executeQuery();
int k=0;
while(rs_g.next())
{
	voucher_datev1[k]=rs_g.getDate("Voucher_Date");
	voucher_id[k]=rs_g.getInt("Voucher_Id");
	voucher_no[k]=rs_g.getString("Voucher_No");
	voucher_no_int[k]=Integer.parseInt(voucher_no[k]);
	k++;
}


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


int receiveCount=k;

///Receive table

int dd=31;
int mm=2;
int year=D.getYear();
year =year+1900;

java.sql.Date receive_date = new java.sql.Date((year),(mm),dd);
//java.sql.Date =new java.sql.Date((year),(mm));
//out.print("<br>86vno"+vno);

String hquery="select count(*) as diffReceiveCount from Receive  where purchase=1 and active=1 and Company_Id="+company_id;
pstmt_g = cong.prepareStatement(hquery);
rs_g = pstmt_g.executeQuery();
int diffReceiveCount=0;	
while(rs_g.next())
	{
	diffReceiveCount=rs_g.getInt("diffReceiveCount");
	}
out.print("<br> 94 diffReceiveCount="+diffReceiveCount);
int receive_Id[]=new int[diffReceiveCount];


java.sql.Date r_receive_date[] =new java.sql.Date[diffReceiveCount];

String hquery="select  Receive_Id,Receive_Date  from Receive  where purchase=1 and active=1 and Company_Id="+company_id;
pstmt_g = cong.prepareStatement(hquery);

rs_g=pstmt_g.executeQuery();
int c=0;
while(rs_g.next())
{
	receive_Id[c]=rs_g.getInt("Receive_Id");
	r_receive_date[c]=rs_g.getDate("Receive_Date");
	c++;
}


C.returnConnection(cong);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
	// C.returnConnection(cong);
  out.println("<font color=red> FileName : UpdateReceiveDate.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
