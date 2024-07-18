<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
ResultSet rs_p= null;
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
String samyakError="8";
try{
String command=request.getParameter("command");
String party_id=request.getParameter("party_id");

int tempx=0;
if(command.equals("Samyak"))
{
%>
<html>
<head>
<title>Samyak System Run </title>
</head>
<%
// Code for connection start here
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
String query="";
cong=C.getConnection();
//conp=C.getConnection();
double local_total_tran1=0;
double dollar_total_tran1=0;

int counter=0;
int counter_salereceipet=0;
int counter_settlement=0;
int journal_counter=0;



double local_total=0;
double dollar_total=0;


double pd_local_total=0;
double pd_dollar_total=0;



double settlement_local_total=0;
double settlement_dollar_total=0;

double add_total_local=0;
double add_total_dollar=0;

double sub_total_local=0;
double sub_total_dollar=0;

String Journal_Query="";
String Journal_Query1="";
String salereceipet="";
String settlementquery="";
String mainquery="";



double local_total_jr0=0;
double dollar_total_jr0=0;



double local_total_tran_jr1=0;
double dollar_total_tran_jr1=0;




double pd_local_total_pur=0;
double pd_dollar_total_pur=0;


//variables for sum of on acccount purchase

double settlement_local_total_pur=0;
double settlement_dollar_total_pur=0;
//variables for sum of settlement purchase



// variables for purchase diff table

double add_local_purchase1=0;
double subtract_local_purchase1=0;
double add_dollar_purchase1=0;
double subtract_dollar_purchase1=0;





//code for sale receipet start here 



//query for selecting journal vouchers of Sale  type=0


//journal query for transaction type=0


Journal_Query="select count(*) as TOTALCOUNT from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=0 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId and L.Ledger_Type=1";





pstmt_g = cong.prepareStatement(Journal_Query);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
counter=rs_g.getInt("TOTALCOUNT");
}
pstmt_g.close();
samyakError="104";
String vno[]=new String[counter];
double local_amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String comp_id[]=new String[counter];
String led_id[]=new String[counter];




Journal_Query="select V.Voucher_No as VNO,(FT.Local_Amount) as FTLocal_Amount,FT.Dollar_Amount as FTDollar,FT.For_HeadId as Company_Id ,L.Ledger_Id as LedgerId from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=0 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId and L.Ledger_Type=1";
pstmt_g = cong.prepareStatement(Journal_Query);
rs_g=pstmt_g.executeQuery();
samyakError="117";
int k=0;
while(rs_g.next()) 	
{
vno[k]=rs_g.getString("VNO");
local_amount[k]=rs_g.getDouble("FTLocal_Amount");
dollar_amount[k]=rs_g.getDouble("FTDollar");
comp_id[k]=rs_g.getString("Company_Id");
led_id[k]=rs_g.getString("LedgerId");
k++;
}
samyakError="128";
pstmt_g.close();

out.print("<br><font color=red>Journal Vouchers Sum Sale(Transaction Type=0)</font>");
%>

<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Journal Vouchers (Trans - 0(Sale)</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party Id</td>
<td>Ledger Id</td>

</tr>


<%
for(int h=0;h<counter;h++)
{
%>
	<tr>
<td><%=h+1%></td>
<td><%=vno[h]%></td>
<td><%=local_amount[h]%></td>
<td><%=dollar_amount[h]%></td>
<td><%=comp_id[h]%></td>
<td><%=led_id[h]%></td>




</tr>
<%
local_total+=str.mathformat(local_amount[h],4);
dollar_total+=str.mathformat(dollar_amount[h],4);

}%>
	<tr><td colspan=2>Total</td><td><%=local_total%></td><td><%=dollar_total%></td></tr>
</table>
<%
//Jornal query sale type=1

Journal_Query1="select count(*) as TOTALCOUNT_jr1 from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=1 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId   and L.Ledger_Type=1";





pstmt_g = cong.prepareStatement(Journal_Query1);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
journal_counter=rs_g.getInt("TOTALCOUNT_jr1");
}
pstmt_g.close();
samyakError="188";
String vno11[]=new String[journal_counter];
double local_amount11[]=new double[journal_counter];
double dollar_amount11[]=new double[journal_counter];
String comp_id11[]=new String[journal_counter];
String led_id11[]=new String[journal_counter];




Journal_Query1="select V.Voucher_No as VNO,(FT.Local_Amount) as FTLocal_Amount,FT.Dollar_Amount as FTDollar,FT.For_HeadId as Company_Id ,L.Ledger_Id as LedgerId from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=1 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId   and L.Ledger_Type=1";
pstmt_g = cong.prepareStatement(Journal_Query1);
rs_g=pstmt_g.executeQuery();
samyakError="201";
int k1=0;
while(rs_g.next()) 	
{
vno11[k1]=rs_g.getString("VNO");
//out.print("<br>205 vno11[k1]="+vno11[k1]);
local_amount11[k1]=rs_g.getDouble("FTLocal_Amount");
dollar_amount11[k1]=rs_g.getDouble("FTDollar");
comp_id11[k1]=rs_g.getString("Company_Id");
led_id11[k1]=rs_g.getString("LedgerId");
k1++;
}
samyakError="212";
pstmt_g.close();

out.print("<br><font color=red>Journal Vouchers SumTransaction Type=1)</font>");
%>

<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Journal Vouchers</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party Id</td>
<td>Ledger Id</td>

</tr>


<%
for(int h1=0;h1<journal_counter;h1++)
{
%>
	<tr>
<td><%=h1+1%></td>
<td><%=vno11[h1]%></td>
<td><%=local_amount11[h1]%></td>
<td><%=dollar_amount11[h1]%></td>
<td><%=comp_id11[h1]%></td>
<td><%=led_id11[h1]%></td>




</tr>
<%
local_total_tran1+=str.mathformat(local_amount11[h1],4);
dollar_total_tran1+=str.mathformat(dollar_amount11[h1],4);

}%>
	<tr><td colspan=2>Total</td><td><%=local_total_tran1%></td><td><%=dollar_total_tran1%></td></tr>
</table>




<%
/////////////////////////////////////
salereceipet="select count(*) as TOTALCOUNT1 from Voucher as V,Payment_Details as PD,Financial_Transaction as FT  where PD.Voucher_Id=V.Voucher_Id and V.Voucher_Type=8 and PD.For_HeadId=0 and PD.Transaction_Type=0 and PD.Active=1 and V.Active=1 and FT.Voucher_Id=PD.Voucher_Id and FT.For_Head=9 and FT.For_HeadId ="+party_id;

pstmt_g = cong.prepareStatement(salereceipet);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
counter_salereceipet=rs_g.getInt("TOTALCOUNT1");
}
pstmt_g.close();

String voucherno[]=new String[counter_salereceipet];
String comp_id1[]=new String[counter_salereceipet];
String ledger_id1[]=new String[counter_salereceipet];
double pd_local_amount[]=new double[counter_salereceipet];
double pd_dollar_amount[]=new double[counter_salereceipet];

salereceipet="select V.Voucher_No as VNO,PD.Local_Amount as PDLocal,PD.Dollar_Amount as PDDollar, FT.For_HeadId as Company_Id, FT.Ledger_Id as Ledger_Id from Voucher as V,Payment_Details as PD,Financial_Transaction as FT  where PD.Voucher_Id=V.Voucher_Id and V.Voucher_Type=8 and PD.For_HeadId=0 and PD.Transaction_Type=0 and PD.Active=1 and V.Active=1 and FT.Voucher_Id=PD.Voucher_Id and FT.For_Head=9 and FT.For_HeadId ="+party_id;

pstmt_g = cong.prepareStatement(salereceipet);
rs_g=pstmt_g.executeQuery();
int s=0;
while(rs_g.next()) 	
{
voucherno[s]=rs_g.getString("VNO");
pd_local_amount[s]=rs_g.getDouble("PDLocal");
pd_dollar_amount[s]=rs_g.getDouble("PDDollar");
comp_id1[s]=rs_g.getString("Company_Id");
ledger_id1[s]=rs_g.getString("Ledger_Id");
s++;
}
samyakError="135";
pstmt_g.close();
out.print("<br><font color=red>On Account Vouchers Sum</font>");
%>
<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of ON Account Vouchers</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party_Id</td>
<td>Ledger_id</td>

</tr>


<%
for(int m=0;m<counter_salereceipet;m++)
{
%>
	<tr>
<td><%=m+1%></td>
<td><%=voucherno[m]%></td>
<td><%=pd_local_amount[m]%></td>
<td><%=pd_dollar_amount[m]%></td>
<td><%=comp_id1[m]%></td>
<td><%=ledger_id1[m]%></td>
</tr>
<%
pd_local_total+=pd_local_amount[m];
pd_dollar_total+=pd_dollar_amount[m];

}%>
	<tr><td colspan=2>Total</td><td><%=pd_local_total%></td><td><%=pd_dollar_total%></td></tr>
</table>

<%


	
settlementquery="select count(*) as TOTALCOUNT2 from Payment_Details as PD,Receive as R,Master_CompanyParty as M where PD.Voucher_Id=0 and PD.For_HeadId=R.Receive_Id and PD.For_Head=9 and R.Receive_FromId=M.CompanyParty_Id and PD.Active=1 and R.Active=1 and R.Receive_FromId="+party_id;
	pstmt_g = cong.prepareStatement(settlementquery);
	rs_g=pstmt_g.executeQuery();

	while(rs_g.next()) 	
	{
	counter_settlement=rs_g.getInt("TOTALCOUNT2");
	}
	pstmt_g.close();

	String settlement_no[]=new String[counter_settlement];
	String part_idd[]=new String[counter_settlement];
	double settlement_local_amount[]=new double[counter_settlement];
	double settlement_dollar_amount[]=new double[counter_settlement];
	//double settlement_local_total=0;
	//double settlement_dollar_total=0;

	settlementquery="select PD.Payment_No as PNO,PD.Local_Amount as PDLocal,PD.Dollar_Amount as PDDollar,R.Receive_FromId as Company_Id  from Payment_Details as PD,Receive as R,Master_CompanyParty as M where PD.Voucher_Id=0 and PD.For_HeadId=R.Receive_Id and PD.For_Head=9 and  R.Receive_FromId=M.CompanyParty_Id and PD.Active=1 and R.Active=1 and R.Receive_FromId="+party_id;
	pstmt_g = cong.prepareStatement(settlementquery);
	rs_g=pstmt_g.executeQuery();
	int i=0;

   while(rs_g.next()) 	
   {
	settlement_no[i]=rs_g.getString("PNO");
	settlement_local_amount[i]=rs_g.getDouble("PDLocal");
	settlement_dollar_amount[i]=rs_g.getDouble("PDDollar");
	part_idd[i]=rs_g.getString("Company_Id");
i++;
}
samyakError="367";
pstmt_g.close();
out.print("<br><font color=red>Settlement Vouchers Sum</font>");




%>
<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Settlement Vouchers</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>PartyId </td>

</tr>


<%
for(int m=0;m<counter_settlement;m++)
{
%>
	<tr>
<td><%=m+1%></td>
<td><%=settlement_no[m]%></td>
<td><%=settlement_local_amount[m]%></td>
<td><%=settlement_dollar_amount[m]%></td>
<td><%=part_idd[m]%></td>
</tr>
<%
settlement_local_total+=str.mathformat(settlement_local_amount[m],4);
settlement_dollar_total+=str.mathformat(settlement_dollar_amount[m],4);

}%>
	<tr><td colspan=2>Total</td><td><%=str.mathformat(settlement_local_total,4)%></td><td><%=str.mathformat(settlement_dollar_total,4)%></td></tr>
</table>
<%
out.print("<br><font color=#CC0000>*************End of Sale**********************</font>");
out.print("<br>");


out.print("<br><font color=#009966>*********Start of Purchase***********</font>");

String Journal_Query_purchase="";



int counter_pur_jr=0;


Journal_Query_purchase="select count(*) as TOTALCOUNT_pur from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=0 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId and L.Ledger_Type=2";





pstmt_g = cong.prepareStatement(Journal_Query_purchase);
rs_g=pstmt_g.executeQuery();

while(rs_g.next()) 	
{
counter_pur_jr=rs_g.getInt("TOTALCOUNT_pur");
}
//out.print("<br>426 counter_pur_jr"+counter_pur_jr);
pstmt_g.close();
samyakError="430";
String vno_pur_jr0[]=new String[counter_pur_jr];
double local_amount_pur_jr0[]=new double[counter_pur_jr];
double dollar_amount_pur_jr0[]=new double[counter_pur_jr];
String comp_id_jr0[]=new String[counter_pur_jr];
String led_id_jr0[]=new String[counter_pur_jr];




Journal_Query_purchase="select V.Voucher_No as VNO,(FT.Local_Amount) as FTLocal_Amount,FT.Dollar_Amount as FTDollar,FT.For_HeadId as Company_Id ,L.Ledger_Id as LedgerId from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=0 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId and L.Ledger_Type=2";
pstmt_g = cong.prepareStatement(Journal_Query_purchase);
rs_g=pstmt_g.executeQuery();
//out.print("<br>443 Journal_Query_purchase="+Journal_Query_purchase);

int kj=0;
while(rs_g.next()) 	
{
vno_pur_jr0[kj]=rs_g.getString("VNO");


local_amount_pur_jr0[kj]=rs_g.getDouble("FTLocal_Amount");

dollar_amount_pur_jr0[kj]=rs_g.getDouble("FTDollar");

comp_id_jr0[kj]=rs_g.getString("Company_Id");

led_id_jr0[kj]=rs_g.getString("LedgerId");

kj++;
}
samyakError="457";
pstmt_g.close();

out.print("<br><font color=red>Journal Vouchers Sum For Purchase(Transaction Type=0)</font>");
%>

<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Journal Vouchers</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party Id</td>
<td>Ledger Id</td>

</tr>


<%
for(int hj=0;hj<counter_pur_jr;hj++)
{
%>
	<tr>
<td><%=hj+1%></td>
<td><%=vno_pur_jr0[hj]%></td>
<td><%=local_amount_pur_jr0[hj]%></td>
<td><%=dollar_amount_pur_jr0[hj]%></td>
<td><%=comp_id_jr0[hj]%></td>
<td><%=led_id_jr0[hj]%></td>




</tr>
<%
local_total_jr0+=str.mathformat(local_amount_pur_jr0[hj],4);
dollar_total_jr0+=str.mathformat(dollar_amount_pur_jr0[hj],4);

}%>
	<tr><td colspan=2>Total</td><td><%=local_total_jr0%></td><td><%=dollar_total_jr0%></td></tr>
</table>





<%

///////////////////////////////////////////////


int journal_counter1=0;

String Journal_Query_purchase1="";
samyakError="511";
Journal_Query_purchase1="select count(*) as TOTALCOUNT111_new1 from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=1 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId and L.Ledger_Type=2";





pstmt_g = cong.prepareStatement(Journal_Query_purchase1);
rs_g=pstmt_g.executeQuery();
samyakError="520";
while(rs_g.next()) 	
{
journal_counter1=rs_g.getInt("TOTALCOUNT111_new1");
}
pstmt_g.close();
//out.print("<br>540 jr counter ="+journal_counter1);
samyakError="526";
String vno_pur_jr1[]=new String[journal_counter1];
double local_amount_pur_jr1[]=new double[journal_counter1];
double dollar_amount_pur_jr1[]=new double[journal_counter1];
String comp_id_jr1[]=new String[journal_counter1];
String led_id_jr1[]=new String[journal_counter1];




Journal_Query_purchase1="select V.Voucher_No as VNO,(FT.Local_Amount) as FTLocal_Amount,FT.Dollar_Amount as FTDollar,FT.For_HeadId as Company_Id ,L.Ledger_Id as LedgerId from Voucher as V,Financial_Transaction as FT,Ledger as L ,Master_CompanyParty as M where V.Voucher_Id=FT.Voucher_Id and V.Voucher_Type=7 and FT.Transaction_Type=1 and FT.For_HeadId="+party_id+" and FT.Ledger_Id=L.Ledger_Id and FT.Active=1 and V.Active=1 and M.CompanyParty_Id=FT.For_HeadId  and L.Ledger_Type=2";
pstmt_g = cong.prepareStatement(Journal_Query_purchase1);
rs_g=pstmt_g.executeQuery();
samyakError="554";

int z=0;
while(rs_g.next()) 	
{
vno_pur_jr1[z]=rs_g.getString("VNO");
//out.print("<br> 559 vno_pur_jr["+z+"]="+vno_pur_jr1[z]);
local_amount_pur_jr1[z]=rs_g.getDouble("FTLocal_Amount");
//out.print("<br>561 local_amount_pur_jr["+z+"]="+local_amount_pur_jr1[z]);
dollar_amount_pur_jr1[z]=rs_g.getDouble("FTDollar");
//out.print("<br>564 dollar_amount_pur_jr["+z+"]="+dollar_amount_pur_jr1[z]);
comp_id_jr1[z]=rs_g.getString("Company_Id");
led_id_jr1[z]=rs_g.getString("LedgerId");
z++;
}
samyakError="569";
pstmt_g.close();

out.print("<br><font color=red>Journal Vouchers Sum Purchase(Transaction Type=1)</font>");
%>

<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Journal Vouchers</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party Id</td>
<td>Ledger Id</td>

</tr>


<%
	//journal_counter1
for(int t=0;t<journal_counter1; t++)
{
	//out.print("<br>594 journal_counter1="+journal_counter1);
	//out.print("<br>");
//out.print(t+1);
//out.print(vno_pur_jr1[t]);
//out.print(local_amount_pur_jr1[t]);
%>
	<tr>
<td><%=t+1%></td>
<td><%=vno_pur_jr1[t]%></td>
<td><%=local_amount_pur_jr1[t]%></td>
<td><%=dollar_amount_pur_jr1[t]%></td>
<td><%=comp_id_jr1[t]%></td>
<td><%=led_id_jr1[t]%></td>




</tr>
<%
local_total_tran_jr1+=str.mathformat(local_amount_pur_jr1[t],4);
dollar_total_tran_jr1+=str.mathformat(dollar_amount_pur_jr1[t],4);

}
samyakError="615";
%>
	<tr><td colspan=2>Total</td><td><%=str.mathformat(local_total_tran_jr1,4)%></td><td><%=str.mathformat(dollar_total_tran_jr1,4)%></td></tr>
</table>







<%
///////////for on account purchase
String salereceipet_jr="";
int counter_pur_onacct=0;
salereceipet_jr="select count(*) as TOTALCOUNT1 from Voucher as V,Payment_Details as PD,Financial_Transaction as FT  where PD.Voucher_Id=V.Voucher_Id and V.Voucher_Type=9 and PD.For_HeadId=0 and PD.Transaction_Type=1 and PD.Active=1 and V.Active=1 and FT.Voucher_Id=PD.Voucher_Id and FT.For_Head=10 and FT.For_HeadId ="+party_id;

pstmt_g = cong.prepareStatement(salereceipet_jr);
rs_g=pstmt_g.executeQuery();
samyakError="610";
while(rs_g.next()) 	
{
counter_pur_onacct=rs_g.getInt("TOTALCOUNT1");
}
pstmt_g.close();

String voucherno_pur[]=new String[counter_pur_onacct];
String comp_id1_pur[]=new String[counter_pur_onacct];
String ledger_id1_pur[]=new String[counter_pur_onacct];
double pd_local_amount_pur[]=new double[counter_pur_onacct];
double pd_dollar_amount_pur[]=new double[counter_pur_onacct];

salereceipet_jr="select V.Voucher_No as VNO,PD.Local_Amount as PDLocal,PD.Dollar_Amount as PDDollar, FT.For_HeadId as Company_Id, FT.Ledger_Id as Ledger_Id from Voucher as V,Payment_Details as PD,Financial_Transaction as FT  where PD.Voucher_Id=V.Voucher_Id and V.Voucher_Type=9 and PD.For_HeadId=0 and PD.Transaction_Type=1 and PD.Active=1 and V.Active=1 and FT.Voucher_Id=PD.Voucher_Id and FT.For_Head=10 and FT.For_HeadId ="+party_id;

pstmt_g = cong.prepareStatement(salereceipet_jr);
rs_g=pstmt_g.executeQuery();
samyakError="627";
int sp=0;
while(rs_g.next()) 	
{
voucherno_pur[sp]=rs_g.getString("VNO");
pd_local_amount_pur[sp]=rs_g.getDouble("PDLocal");
pd_dollar_amount_pur[sp]=rs_g.getDouble("PDDollar");
comp_id1_pur[sp]=rs_g.getString("Company_Id");
ledger_id1_pur[sp]=rs_g.getString("Ledger_Id");
sp++;
}
samyakError="638";
pstmt_g.close();
out.print("<br><font color=red>On Account Vouchers Sum(Purchase)</font>");
%>
<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of ON Account Vouchers(Purchase)</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>Party_Id</td>
<td>Ledger_id</td>

</tr>


<%
for(int m=0;m<counter_pur_onacct;m++)
{
%>
	<tr>
<td><%=m+1%></td>
<td><%=voucherno_pur[m]%></td>
<td><%=pd_local_amount_pur[m]%></td>
<td><%=pd_dollar_amount_pur[m]%></td>
<td><%=comp_id1_pur[m]%></td>
<td><%=ledger_id1_pur[m]%></td>
</tr>
<%
pd_local_total_pur+=str.mathformat(pd_local_amount_pur[m],4);
pd_dollar_total_pur+=str.mathformat(pd_dollar_amount_pur[m],4);

}%>
	<tr><td colspan=2>Total</td><td><%=pd_local_total_pur%></td><td><%=pd_dollar_total_pur%></td></tr>
</table>












<%
    int counter_settlement_pur=0;

	String settlementquery_pur="";
	
	settlementquery_pur="select count(*) as TOTALCOUNT2 from Payment_Details as PD,Receive as R,Master_CompanyParty as M where PD.Voucher_Id=0 and PD.For_HeadId=R.Receive_Id and R.Receive_FromId=M.CompanyParty_Id and PD.Active=1 and R.Active=1 and PD.For_Head=10 and  R.Receive_FromId="+party_id;
	pstmt_g = cong.prepareStatement(settlementquery_pur);
	rs_g=pstmt_g.executeQuery();
samyakError="696";
	while(rs_g.next()) 	
	{
	counter_settlement_pur=rs_g.getInt("TOTALCOUNT2");
	}
	pstmt_g.close();

	String settlement_no_pur[]=new String[counter_settlement_pur];
	String part_idd_pur[]=new String[counter_settlement_pur];
	double settlement_local_amount_pur[]=new double[counter_settlement_pur];
	double settlement_dollar_amount_pur[]=new double[counter_settlement_pur];
	//double settlement_local_total=0;
	//double settlement_dollar_total=0;

	settlementquery_pur="select PD.Payment_No as PNO,PD.Local_Amount as PDLocal,PD.Dollar_Amount as PDDollar,R.Receive_FromId as Company_Id  from Payment_Details as PD,Receive as R,Master_CompanyParty as M where PD.Voucher_Id=0 and PD.For_Head=10  and  PD.For_HeadId=R.Receive_Id and R.Receive_FromId=M.CompanyParty_Id and PD.Active=1 and R.Active=1 and R.Receive_FromId="+party_id;
	pstmt_g = cong.prepareStatement(settlementquery_pur);
	rs_g=pstmt_g.executeQuery();
	samyakError="713";
	int ip=0;

   while(rs_g.next()) 	
   {
	settlement_no_pur[ip]=rs_g.getString("PNO");
	settlement_local_amount_pur[ip]=rs_g.getDouble("PDLocal");
	settlement_dollar_amount_pur[ip]=rs_g.getDouble("PDDollar");
	part_idd_pur[ip]=rs_g.getString("Company_Id");
ip++;
}
samyakError="724";
pstmt_g.close();
out.print("<br><font color=red>Settlement Vouchers Sum</font>");




%>
<table border=1>
<tr>
<td colspan=2></td>	<td>Sum of Settlement Vouchers(purchase)</td>
</tr>	
<tr>
	<td>Sr.No</td>
<td>Voucher.No</td>
<td>Local Amount</td>
<td>Dollar Amount</td>
<td>PartyId </td>

</tr>


<%
for(int m=0;m<counter_settlement_pur;m++)
{
%>
	<tr>
<td><%=m+1%></td>
<td><%=settlement_no_pur[m]%></td>
<td><%=settlement_local_amount_pur[m]%></td>
<td><%=settlement_dollar_amount_pur[m]%></td>
<td><%=part_idd_pur[m]%></td>
</tr>
<%
settlement_local_total_pur+=str.mathformat(settlement_local_amount_pur[m],4);
settlement_dollar_total_pur+=str.mathformat(settlement_dollar_amount_pur[m],4);

}%>
	<tr><td colspan=2>Total</td><td><%=settlement_local_total_pur%></td><td><%=settlement_dollar_total_pur%></td></tr>
</table>
<%
String Party_name="";
double op_rlocal=0;
double op_purlocal=0;
double op_rdollar=0;
double op_purdollar=0;
double net_rdollar=0;
double net_purrdollar=0;
double net_rlocal=0;
double net_purlocal=0;
double sale_adv_local=0;
double pur_adv_local=0;
double sale_adv_dollar=0;
double pur_adv_dollar=0;

mainquery="select CompanyParty_Name, Opening_RLocalBalance,Opening_RDollarBalance,Net_RLocalBalance,Net_RDollarBalance,Opening_PLocalBalance,Opening_PDollarBalance,Net_PLocalBalance,Net_PDollarBalance,Purchase_AdvanceLocal,Purchase_AdvanceDollar,Sale_AdvanceLocal,Sale_AdvanceDollar from Master_CompanyParty where CompanyParty_Id="+party_id+" and Active=1 ";
   pstmt_g = cong.prepareStatement(mainquery);
	rs_g=pstmt_g.executeQuery();

samyakError="783";
while(rs_g.next()) 	
   {
Party_name=rs_g.getString("CompanyParty_Name");
op_rlocal=rs_g.getDouble("Opening_RLocalBalance");
op_rdollar=rs_g.getDouble("Opening_RDollarBalance");
net_rlocal=rs_g.getDouble("Net_RLocalBalance");
net_rdollar=rs_g.getDouble("Net_RDollarBalance");
op_purlocal=rs_g.getDouble("Opening_PLocalBalance");
op_purdollar=rs_g.getDouble("Opening_PDollarBalance");
net_purlocal=rs_g.getDouble("Net_PLocalBalance");
net_purrdollar=rs_g.getDouble("Net_PDollarBalance");
pur_adv_local=rs_g.getDouble("Purchase_AdvanceLocal");
pur_adv_dollar=rs_g.getDouble("Purchase_AdvanceDollar");

sale_adv_local=rs_g.getDouble("Sale_AdvanceLocal");
sale_adv_dollar=rs_g.getDouble("Sale_AdvanceDollar");

out.print("<br><font color=red>MCP Table</font>");
  
   
   
   
   }
pstmt_g.close();
samyakError="842";
%><table border=1>
<tr>
<td colspan=3></td>	<td>Main Company Data</td><td colspan=3></td>
</tr>	
<tr bgcolor=#CCCCFF>
	<!-- <td>Sr.No</td> -->
<td>Party Name</td>
<td>Opening_RLocalBalance</td>
<td>Opening_RDollarBalance</td>
<td>Net_RLocalBalance</td>
<td>Net_RDollarBalance</td>
<td>Sale_AdvanceLocal </td>
<td>Sale_AdvanceDollar </td>
</tr>
	<tr>
	
	<!-- <td>1</td> -->
<td><%=Party_name%></td>
<td><%=op_rlocal%></td>
<td><%=op_rdollar%></td>
<td><%=net_rlocal%></td>
<td><%=net_rdollar%></td>
<td><%=sale_adv_local%></td>
<td><%=sale_adv_dollar%></td>

</tr>


	<tr bgcolor=#CCCCFF>
	<!-- <td>Sr.No</td> -->
<td>Party Name</td>
<td>Opening_PLocalBalance</td>
<td>Opening_PDollarBalance</td>
<td>Net_PLocalBalance</td>
<td>Net_PDollarBalance</td>
<td>Purchase_AdvanceLocal </td>
<td>Purchase_AdvanceDollar </td>
</tr>
	<tr>
<td><%=Party_name%></td>
<td><%=op_purlocal%></td>
<td><%=op_purdollar%></td>
<td><%=net_purlocal%></td>
<td><%=net_purrdollar%></td>
<td><%=pur_adv_local%></td>
<td><%=pur_adv_dollar%></td>
</tr>
	</table>
	<%//local_total+pd_local_total+local_total_tran1
		add_total_local=pd_local_total+local_total_tran1;
	   add_total_dollar=pd_dollar_total+dollar_total_tran1;
		sub_total_local=settlement_local_total+local_total;
	   sub_total_dollar=settlement_dollar_total+dollar_total;

   
 		
		double calculated_local=Math.abs(op_rlocal);
		double calculated_dollar=Math.abs(op_rdollar);
		
		
		double calc1=(calculated_local-sub_total_local)+add_total_local;
		//out.print("Total="+calc1);

		double calc1dollar=(calculated_dollar-sub_total_dollar)+add_total_dollar;
		double sale_calc_dollar=str.mathformat(calc1dollar,4);
out.print("<br>");
out.print("<br>");

/// for purchase calculation





















%>
	<!-- Difference table for Sale -->
<table border=1>
	<tr bgcolor=#00FFCC><td colspan=2></td><td colspan=2>Difference Table For Sale
	</td><td colspan=2></td>
		<tr><td colspan=3>Local</td><td colspan=3>Dollar</td></tr>
	<tr>
	<td>Calculated</td>
	<td>From Database</td>
	<td>Difference</td><td>Calculated</td><td>From Database</td><td>Difference</td>
<tr><td><%=calc1%></td><td><%=sale_adv_local%></td><td ><%=(calc1-sale_adv_local)%></td><td><%=sale_calc_dollar%></td><td><%=sale_adv_dollar%></td><td><%=str.mathformat((sale_adv_dollar-calc1dollar),4)%></td></tr>
	


</tr>
	</table>
<!-- end of  Difference table for Sale -->
		

<!-- Difference table for Purchase -->

<!-- variales declaration for purchase -->
<%


double calculated_local_pur=Math.abs(op_purlocal);
double calculated_dollar_pur=Math.abs(op_purdollar);



add_local_purchase1=pd_local_total_pur+local_total_jr0;
subtract_local_purchase1=local_total_tran_jr1+settlement_local_total_pur;


add_dollar_purchase1=pd_dollar_total_pur+dollar_total_jr0;

 subtract_dollar_purchase1=dollar_total_tran_jr1+settlement_dollar_total_pur;


double calculated_pur_amt=(calculated_local_pur+add_local_purchase1)-subtract_local_purchase1;

//out.print();

double calculated_pur_amt_dollar=(calculated_dollar_pur+add_dollar_purchase1)-subtract_dollar_purchase1;
double dollarfirst_purchase=str.mathformat(calculated_pur_amt_dollar,4);
//out.print("<br>dollarfirst_purchase="+dollarfirst_purchase);
%>
<table border=1>
	<tr bgcolor=#00FFCC><td colspan=2></td><td colspan=2>Difference Table For Purchase
	</td><td colspan=2></td>
		<tr><td colspan=3>Local</td><td colspan=3>Dollar</td></tr>
	<tr><td>Calculated</td><td>From Database</td><td>Difference</td><td>Calculated</td><td>From Database</td><td>Difference</td>
<tr><td><%=calculated_pur_amt%></td><td><%=pur_adv_local%></td><td ><%=(calculated_pur_amt-pur_adv_local)%></td><td><%=dollarfirst_purchase%></td><td><%=pur_adv_dollar%></td><td><%=str.mathformat((dollarfirst_purchase-pur_adv_dollar),4)%></td></tr>
	</tr>
	</table>


<!-- end of Difference table for Purchase

//dollarfirst_purchase-pur_adv_dollar
-->
<%



//update query for purchase
int a417=1;
if((dollarfirst_purchase!=pur_adv_dollar)||(calculated_pur_amt!=pur_adv_local))
	{
String 
query_update="Update Master_CompanyParty set Purchase_AdvanceLocal="+calculated_pur_amt+", Purchase_AdvanceDollar="+dollarfirst_purchase+" where CompanyParty_Id="+party_id;

pstmt_p = cong.prepareStatement(query_update);
samyakError="1001";
a417 = pstmt_p.executeUpdate();
out.print("<br> Updated for company "+a417);
pstmt_p.close();

	}


///update query for sale
int a4171=1;

if((calc1!=sale_adv_local)||(sale_calc_dollar!=sale_adv_dollar))
	{
String 
query_update="Update Master_CompanyParty set Sale_AdvanceLocal="+calc1+", Sale_AdvanceDollar="+sale_calc_dollar+" where CompanyParty_Id="+party_id;

pstmt_p = cong.prepareStatement(query_update);
samyakError="1001";
a4171 = pstmt_p.executeUpdate();
out.print("<br> Updated for company "+a4171);
pstmt_p.close();

	}









	
	













	
		C.returnConnection(cong);//return connection


}///if command



}catch(Exception e)
{
//C.returnConnection(conp);
C.returnConnection(cong);
out.print("<br>900 samyakError :"+samyakError+"Bug is ="+e);
}
%>