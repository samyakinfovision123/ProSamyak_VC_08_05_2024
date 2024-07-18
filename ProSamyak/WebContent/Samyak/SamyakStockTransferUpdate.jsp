<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String company_id= "1";//+session.getValue("company_id");

ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try{

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String local_currency= I.getLocalCurrency(company_id);
int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
//out.print("<BR>d="+d);
String local_symbol= I.getLocalSymbol(company_id);
String currency_name=A.getName("Master_Currency", "Currency_Name","Currency_id",local_currency);

int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
out.print("<br>command=" +command);
if("Transfer".equals(command))
	{
try{
String query="";

query="select Voucher_No from Voucher where Voucher_Type=3 and company_id="+company_id;
cong=C.getConnection();
conp=C.getConnection();
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
int Receive_Id=0;
String rquery="";
while(rs_g.next())
	{
Receive_Id=rs_g.getInt("Voucher_No");
out.print("<br> 47 Receive_Id= "+Receive_Id);
rquery="Update Receive set StockTransfer_Type=1 where Receive_Id="+Receive_Id;

pstmt_p=conp.prepareStatement(rquery);
int a50=pstmt_p.executeUpdate();
pstmt_p.close();
	}
pstmt_g.close();
C.returnConnection(conp);
C.returnConnection(cong);
}catch (Exception e) {out.print(e); }




	}
}catch(Exception e) {out.print(e); }	
	%>






