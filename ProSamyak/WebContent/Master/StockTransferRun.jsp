<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />

<html>
<head>
<title>  Samyak Software </title>
<script language="JavaScript">

function disrtclick()
{
//window.event.returnValue=0;
}
</script>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>

<% 
ResultSet rs_g= null;
ResultSet rs= null;
Connection conp = null;
Connection cong = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
try	
{
	conp=C.getConnection();
	cong=C.getConnection();
}
catch(Exception Samyak31)
{ 
out.println("<font color=red> FileName : StockTransfer.jsp<br>Bug No Samyak31 : "+ Samyak31);
}
try{
String command = request.getParameter("command");
//out.println("<center>command is "+command+"</center>");

String company_id= ""+session.getValue("company_id");
//out.println("<center>company_id is "+company_id+"</center>");

String user_name = ""+session.getValue("user_name");
int user_level = Integer.parseInt(""+session.getValue("user_level"));
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
String company_name=A.getName(cong,"CompanyParty",company_id);
//out.println("<center>company_name is "+company_name+"</center>");



java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_date=stoday_day+"/"+stoday_month+"/"+today_year;

//out.println("<center>today_date is "+today_date+"</center>");


if("Default".equals(command))
{



String stockdate= request.getParameter("stockdate");
String purchase= request.getParameter("purchase");
String consignment_no= request.getParameter("consignment_no");
int st_count=Integer.parseInt( request.getParameter("st_count"));
String type= request.getParameter("type");

String message=request.getParameter("message");
//int counter=no_lots;
//out.println("<br>81");

double ctax = 0;
double ex_rate = 0;
double qty_tot=0;
int counter=0;

String stquery="Select * from Receive  where stock_date > ? and Company_id=? and Receive_FromId like "+company_id+" and Purchase=1 and Receive_sell=0 and Active=1 order by Receive_date ,Receive_no";
//out.println("<br>81stquery="+stquery);

pstmt_g = cong.prepareStatement(stquery);
	pstmt_g.setString(1,stockdate);
	pstmt_g.setString(2,company_id); 
	rs = pstmt_g.executeQuery();	
	while(rs.next())
		{
//out.println("<br>Insude=");
String receive_id= rs.getString("receive_id");
//out.println("<br>receive_id="+receive_id);
counter=rs.getInt("Receive_Lots");
String receive_no=rs.getString("Receive_No");
//out.println("<br>103");
java.sql.Date receive_date =rs.getDate("stock_date");
//ctax=rs.getDouble("Tax");
ex_rate= rs.getDouble("Exchange_Rate");


String query="Select * from Receive R ,Receive_Transaction RT where R.receive_id=RT.receive_id  and R.receive_id="+receive_id+" order by R.Receive_date ,R.Receive_no";
//out.println("<br>query="+query);

pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();	
	int i=0;
double quantity[]=new double[counter];
double rate[]=new double[counter];
double amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String flot_id[]=new String[counter]; 
String tlot_id[]=new String[counter]; 
String frecdtrans_id[]=new String[counter];
String trecdtrans_id[]=new String[counter];
double local_tot=0; 
double dollar_tot=0; 
double total_qty=0;
double local_total=0; 
double tlocal_total=0; 
double dollar_total=0;
double qty=0;
double tot_qty=0;
double local=0; 
double tlocal=0; 
double dollar=0; 
int Receive_id =Integer.parseInt(receive_id);
int r_id=Receive_id+1;

while(rs_g.next())
		{
//String receive_from=rs_g.getString("Receive_FromId");
frecdtrans_id[i]=rs_g.getString("ReceiveTransaction_Id");
String lot_srno=rs_g.getString("Lot_SrNo");
flot_id[i]=rs_g.getString("Lot_Id");
tlot_id[i]=A.getNameCondition(cong,"Receive_Transaction","Lot_id","Where receive_id="+r_id+" and Lot_SrNo="+lot_srno+"");
trecdtrans_id[i]=A.getNameCondition(cong,"Receive_Transaction","ReceiveTransaction_Id","Where receive_id="+r_id+"  and Lot_id="+tlot_id[i]+"");

local=rs_g.getDouble("Local_Price");
qty=rs_g.getDouble("Quantity");
rate[i]=S.stockRate(receive_date,company_id,flot_id[i]);
quantity[i]=qty;
amount[i]=str.mathformat((rate[i]* quantity[i]),d);
local_total+=amount[i];	
dollar_amount[i]=str.mathformat((amount[i] /ex_rate),2);
dollar_total += dollar_amount[i];
i++;
}
pstmt_p.close();

//out.print("<BR>a160=");

	query="Update Receive  set Receive_Total="+local_total+", Local_Total="+local_total+" , Dollar_Total="+dollar_total+" where receive_id="+receive_id+" ";
	pstmt_p=conp.prepareStatement(query);
	int a166=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a166="+a166);

	query="Update Voucher  set Voucher_Total="+local_total+", Local_Total="+local_total+" , Dollar_Total="+dollar_total+" where Voucher_Type=3 and Voucher_No="+receive_id+" ";
	pstmt_p=conp.prepareStatement(query);
	int a167=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a167="+a167);


	query="Update Receive  set Receive_Total="+local_total+", Local_Total="+local_total+" , Dollar_Total="+dollar_total+" where receive_id="+r_id+" ";
	pstmt_p=conp.prepareStatement(query);
	int a171=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a171="+a171);

	query="Update Voucher  set Voucher_Total="+local_total+", Local_Total="+local_total+" , Dollar_Total="+dollar_total+" where Voucher_Type=3 and Voucher_No="+r_id+" ";
	pstmt_p=conp.prepareStatement(query);
	int a180=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a180="+a180);

for(i=0; i<counter; i++)
	{
double drate=rate[i]/ex_rate;
	query="Update Receive_Transaction  set Receive_Price="+rate[i]+", Local_Price="+rate[i]+" , Dollar_Price="+drate+" where ReceiveTransaction_Id="+frecdtrans_id[i]+" and Lot_Id="+flot_id[i]+"";
	pstmt_p=conp.prepareStatement(query);
	int a179=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a179="+a179);

	query="Update Receive_Transaction  set Receive_Price="+rate[i]+", Local_Price="+rate[i]+" , Dollar_Price="+drate+" where ReceiveTransaction_Id="+trecdtrans_id[i]+" and Lot_Id="+tlot_id[i]+"";
	pstmt_p=conp.prepareStatement(query);
	int a182=pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<BR>a182="+a182);


	}//for

//out.print("<BR>receive_id="+receive_id);
//out.print("<br>local_total="+str.format(""+local_total,d));

}//psmt_g.close();

pstmt_g.close();
C.returnConnection(conp);
C.returnConnection(cong);

response.sendRedirect("../Inventory/InvReceive.jsp?command=Royal&lots=1&message=saved&purchase="+purchase+"&consignment_no="+consignment_no);


}//end if ('Default')
C.returnConnection(conp);
C.returnConnection(cong);


}//end try 
catch(Exception Samyak87){ 
out.println("<br><font color=red> FileName : StockTransfer.jsp Bug No Samyak87 : "+ Samyak87);
}
%>

</BODY>
</HTML>








