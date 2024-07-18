<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
 <jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String errLine="400";


ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
 try	{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : EditVouchers.jsp<br>Bug No e31 : "+ e31);} 

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));


java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//String today_string=format.format(D);
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
String message=request.getParameter("message"); 

try{

if("Next".equals(command))
{
 
//out.println("Inside Next");
//java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

int dd1 = Integer.parseInt(request.getParameter("dd1"));
int mm1 = Integer.parseInt(request.getParameter("mm1"));
int yy1 = Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>D1=" +D1);
int dd2 = Integer.parseInt(request.getParameter("dd2"));
int mm2 = Integer.parseInt(request.getParameter("mm2"));
int yy2 = Integer.parseInt(request.getParameter("yy2"));
java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>D2=" +D2);
String type= request.getParameter("voucher_type");
String temp_receive_id= request.getParameter("receive_id");

//out.print("<br>66 type="+type);
//out.print("<br>temp_receive_id= " +temp_receive_id);
String voucher_name[]=new String[101];
voucher_name[1]="Sale Invoice"; 
voucher_name[2]="Purchase Invoice"; 
voucher_name[3]="Stock Transfer"; 
voucher_name[4]="Contra"; 
voucher_name[5]="Payment"; 
voucher_name[6]="Receipt";
voucher_name[7]="Journal";
voucher_name[8]="Sales Receipt"; 
 voucher_name[9]="Purchase Payment"; 
voucher_name[10]="Purchase Return";
voucher_name[11]="Sales Return"; 
voucher_name[12]="PN Sales Receipt";
voucher_name[13]="PN Purchase Payment"; 
voucher_name[98]="Split"; 
voucher_name[99]="Warehouse Transfer"; 
voucher_name[100]="Reverse Warehouse Transfer"; 
String party_id= request.getParameter("party_id");
//out.print("<br>party_id= " +party_id);



String desc="";
double local=0;
double dollar=0;
double local_tot=0;
double dollar_tot=0;
if("3".equals(type) || "98".equals(type) || "99".equals(type) || "100".equals(type))
	{
	String query="";
	if("3".equals(type))
	{
		if("0".equals(temp_receive_id) || temp_receive_id==null) 
		{
			query="Select * from Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId like "+company_id+" and Purchase=1 and (Receive_Sell=0 or StockTransfer_Type=7) and SalesPerson_Id<>-1 and Consignment_ReceiveId=0 and Active=1 order by Receive_date ,Receive_no";
		}
		else
		{
			query="Select * from Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId like "+company_id+" and Purchase=1 and (Receive_Sell=0 or StockTransfer_Type=7) and SalesPerson_Id<>-1 and Consignment_ReceiveId=0 and receive_id="+temp_receive_id+" and Active=1 order by Receive_date ,Receive_no";
		
			//out.print("query="+query);
		}
	}
	if("98".equals(type))
		{
		query="Select * from Receive where Receive_Date between ? and ? and company_id=? and Receive_FromId like "+company_id+" and Purchase=1 and Receive_Sell=0 and StockTransfer_Type=4 and SalesPerson_Id<>-1 and Consignment_ReceiveId<>0 and Active=1";
		}
	if("99".equals(type))
		{//Using lot_SrNo=0 condition to remove repeated rows see NewSalesPersonTransfer.jsp
		query="Select * from Receive R, Receive_Transaction RT  where R.Receive_Date between ? and ? and R.Company_id=? and R.Receive_FromId like "+company_id+" and R.Purchase=1 and R.Receive_Sell=0 and R.StockTransfer_Type=2 and R.SalesPerson_Id=-1 and R.Active=1 and RT.Consignment_ReceiveId=0 and lot_SrNo=0 and RT.Receive_Id=R.Receive_Id and R.Receive_Id NOT IN (Select RT.Consignment_ReceiveId from Receive R, Receive_Transaction RT  where R.Receive_Date between ? and ? and R.Company_id=? and R.Receive_FromId like "+company_id+" and R.Purchase=1 and R.Receive_Sell=0 and R.StockTransfer_Type=2 and R.SalesPerson_Id=-1 and R.Active=1 and RT.Consignment_ReceiveId<>0 and  RT.Receive_Id=R.Receive_Id) order by Receive_date ,Receive_no";
		}
	if("100".equals(type))
		{
		query="Select * from Receive R, Receive_Transaction RT  where R.Receive_Date between ? and ? and R.Company_id=? and R.Receive_FromId like "+company_id+" and R.Purchase=1 and R.Receive_Sell=0 and R.StockTransfer_Type=2 and R.SalesPerson_Id=-1 and R.Active=1 and RT.Consignment_ReceiveId<>0 and RT.Receive_Id=R.Receive_Id order by Receive_date ,Receive_no";
		}
	
	//out.print("<br>107 Query="+query);
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,company_id); 
	if("99".equals(type))
		{
		pstmt_g.setString(4,""+D1);
		pstmt_g.setString(5,""+D2);	
		pstmt_g.setString(6,company_id); 
		}
	rs_g = pstmt_g.executeQuery();	
	
%>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<META HTTP-EQUIV="Expires" CONTENT="0">
</HEAD>

<body bgcolor=white background="../Buttons/BGCOLOR.JPG" >
<form action='CancelInventoryVouchers.jsp' name=f1 method=post >

<table align=center bordercolor=skyblue border=0 cellspacing=0 width="100%">
<tr><td colspan=2><%=company_name%></td> </tr>
<tr><td colspan=2>
<table align=right  border=1 cellspacing=0 width="90%">
<tr ><th colspan=6 class="thcolor">Cancel <%=voucher_name[Integer.parseInt(type)]%> Voucher 
<%if("99".equals(type))
	out.print("<br>(only those vouchers shown for whom there is no reverse Warehouse Transfer)");%>
</th></tr>
<tr><th colspan=5>From  <%=format.format(D1)%> -To <%=format.format(D2)%> </th></tr>
<tr>
<th align=left width='10%'>Sr No</th> 
<th align=left width='15%'>Voucher No</th> 
<th width='10%'>Date</th> 
 <th align=right width='20%'> Amount(<%=local_symbol%>)</th> 
<th width='45%'>&nbsp;&nbsp;Narration</th> 

<input type=hidden name=voucher_type value="<%=type%>">
</tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 -->
<%
	//out.print("<br>155 type="+type);
int m=1;
int i=0;
	while(rs_g.next())
	{
	//System.out.println("160 inside Receive next**********");
	String receive_id= rs_g.getString("Receive_id");
	String voucher_no= rs_g.getString("Receive_no");
	String cgtRec_Id= rs_g.getString("Consignment_ReceiveId");
	//out.print("<br>164 **********cgtRec_Id="+cgtRec_Id);
	boolean active=rs_g.getBoolean("Active");
	String Narration=rs_g.getString("CgtDescription");



	String voucher_id=A.getNameCondition(conp,"Voucher", "Voucher_id","Where Voucher_No='"+receive_id+"' and voucher_type=3");
	//out.print("<br>138 voucher_id"+voucher_id);
	String StockTransfer_Type=rs_g.getString("StockTransfer_Type");
	String st="checked";
	String old="";
	if(active){st=""; old="active";}
	%>
<tr>
<input type=hidden name=voucher_id<%=i%> value="<%=voucher_id%>">
<input type=hidden name=receive_id<%=i%> value="<%=receive_id%>">
<input type=hidden name=cgtRec_Id<%=i%> value="<%=cgtRec_Id%>">
<input type=hidden name=old<%=i%> value="<%=old%>">
<input type=hidden name="StockTransfer_Type<%=i%>" value="<%=StockTransfer_Type%>">




<TD><input type=checkbox name=cancel<%=i%> value=yes <%=st%>>  <%=m++%></td>
<TD> <A href= "../Inventory/InvStockTransferDetail_SalePurchase.jsp?Receive_Id=<%=receive_id%>&StockTransfer_Type=<%=StockTransfer_Type%>&command=Default&mesage=Default" target=_blank><%=voucher_no%></td>
<TD align=center> <%=format.format(rs_g.getDate("Receive_Date"))%> </td>

<%
 local=rs_g.getDouble("Local_Total");
 local_tot +=local;
 String description="-"; 

%>
<TD align=right><%=str.format(""+local,d)%></td>
<!-- <TD align=right><%=str.format(""+dollar,2)%></td> -->
 <!-- <TD>&nbsp;&nbsp;<%//=description%></td> -->
 <TD>&nbsp;&nbsp;<%=Narration%></td>
</tr>
<%
i++;
}
		pstmt_g.close();
%>
<input type=hidden name=counter value="<%=i%>">

<!-- <tr><td colspan=8> <hr></td></tr>
 --><tr>
<TD align=right colspan=4><b>Total&nbsp;&nbsp; <%=str.format(""+local_tot,d)%> </b></td>
<td>&nbsp;</td>
</tr>
<tr><td align=center colspan=5>
	<input type=submit value='Update' name=command class='Button1' >
</td></tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 --></table>

<tr><td colspan=2 align=right><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>
</form>
<%


	}
else{

String query="";
String condition="";
String dispaly="";
if("1".equals(type))//sale
	{condition="Receive_Sell=0 and R_Return=0 and opening_Stock=0 ";}

         // and Consignment_ReceiveId=0

else if("2".equals(type))//Purchase
	{condition="Receive_Sell=1 and R_Return=0 and opening_Stock=0 ";}
	
	// and Consignment_ReceiveId=0

else if("10".equals(type))//Purchase Return
	{condition="Receive_Sell=0 and R_Return=1 and opening_Stock=0";}
else if("11".equals(type))//Sale Return
	{condition="Receive_Sell=1 and R_Return=1 and opening_Stock=0";}

if("0".equals(party_id))
{
query="Select * from  Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId not like "+company_id+" and Active=1 and purchase=1 and "+condition+" order by Receive_Date,Receive_No";
//out.print("<br>Query="+query);

dispaly="ALL";
}//if party_id=0

else{
dispaly=A.getName(conp,"CompanyParty",party_id);
	 query="Select * from  Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId="+party_id+" and Active=1 and purchase=1 and "+condition+" order by Receive_Date,Receive_No";
}//else party
//out.print("<br>215 Query="+query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);
pstmt_g.setString(3,company_id); 
//pstmt_g.setString(4,type); 
rs_g = pstmt_g.executeQuery();	
	
%>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<body bgcolor=white background="../Buttons/BGCOLOR.JPG" >
<form action='CancelInventoryVouchers.jsp' name=f1 method=post >

<table align=center bordercolor=skyblue border=0 cellspacing=0 width="100%">
<tr><td colspan=2><%=company_name%></td> </tr>
<tr><td colspan=2>
<table align=right  border=1 cellspacing=0 width="90%">
<tr><th colspan=6 class="thcolor">Cancel <%=voucher_name[Integer.parseInt(type)]%> Voucher For  <%=dispaly%></th></tr>
<tr><th colspan=5>From  <%=format.format(D1)%> -To <%=format.format(D2)%> </th></tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 -->
<tr>
<th align=left width='10%'>Sr No</th> 
<th align=left width='15%'>Voucher No</th> 
<th width='10%'>Date</th> 
 <th align=right width='20%'> Amount(<%=local_symbol%>)</th> 
<th width='45%'>&nbsp;&nbsp;Narration</th> 

<input type=hidden name=voucher_type value="<%=type%>">
</tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 -->
<%
int m=1;
int i=0;
while(rs_g.next())
		{
boolean active=rs_g.getBoolean("Active");
String receive_id=rs_g.getString("receive_id");
String voucher_no=rs_g.getString("Receive_No");
String st="checked";
String old="";
if(active){st=""; old="active";}
String voucher_id=A.getNameCondition(conp,"Voucher","Voucher_id","Where Voucher_No='"+receive_id+"' and Voucher_type="+type+"");
%>
<tr>
<input type=hidden name=voucher_id<%=i%> value="<%=voucher_id%>">
<input type=hidden name=receive_id<%=i%> value="<%=receive_id%>">
<input type=hidden name=old<%=i%> value="<%=old%>">
<%
String pdquery="select *  from Payment_Details where For_HeadId="+receive_id+" and Active=1";
//out.print("<br>232 voucher_id= "+voucher_id);
pstmt_p=conp.prepareStatement(pdquery);
rs_p=pstmt_p.executeQuery();
double pdcount=0;
while(rs_p.next())
	{
		pdcount++;
	}
	pstmt_p.close();
//out.print("<br> 281 dcount "+pdcount);
if(pdcount==0)
	{
	
	//out.print("<br>307 m=>"+m);
%>

<TD><input type=checkbox name=cancel<%=i%> value=yes <%=st%>>  <%=m++%></td>


<TD>
	<%

if("1".equals(type))//sale
	{out.print("<A href='../Inventory/InvDetailReport.jsp?command=sale&receive_id="+receive_id+"' target=_blank>"+voucher_no+" </A>");}

else if("2".equals(type))//Purchase
	{out.print("<A href='../Inventory/InvDetailReport.jsp?command=purchase&receive_id="+receive_id+"' target=_blank>"+voucher_no+" </A>");
	}
else if("10".equals(type))//Purchase Return
	{out.print("<A href='../Inventory/PurchaseReturnInvoice.jsp?command=sale&receive_id="+receive_id+"' target=_blank>"+voucher_no+" </A>");}
else if("11".equals(type))//Sale Return
	{out.print("<A href='../Inventory/PurchaseReturnInvoice.jsp?command=purchase&receive_id="+receive_id+"' target=_blank>"+voucher_no+" </A>");}

	%>
	</td>




<TD align=center> <%=format.format(rs_g.getDate("Receive_Date"))%> </td>

<%
 local=rs_g.getDouble("Local_Total");
 dollar=rs_g.getDouble("Dollar_Total");
 local_tot +=local;
 dollar_tot +=dollar;
 String description=A.getNameCondition(conp,"Voucher","Description","Where Voucher_No='"+receive_id+"' and Voucher_type="+type+"");
// if(rs_g.wasNull()){desc="";}
	%>
<TD align=right><%=str.format(""+local,d)%></td>
<!-- <TD align=right><%=str.format(""+dollar,2)%></td> -->
 <TD>&nbsp;&nbsp;<%=description%></td>
</tr>
<%}//if pdcount==0
i++;
}
		pstmt_g.close();

%>
<input type=hidden name=counter value="<%=i%>">

<!-- <tr><td colspan=8> <hr></td></tr>
 --><tr>
<TD align=right colspan=4><b>Total&nbsp;&nbsp; <%=str.format(""+local_tot,d)%> </b></td>
<td>&nbsp;</td>
</tr>
<tr><td align=center colspan=5>
	<input type=submit value='Update' name=command class='Button1' >
</td></tr>
<!-- <tr><td colspan=8> <hr></td></tr>
 --></table>

<tr><td colspan=2 align=right><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>
</form>
<%



}//else

		C.returnConnection(cong);
		C.returnConnection(conp);

}//if Next 
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>






<%
if("Update".equals(command))
{
try{ 
	conp.setAutoCommit(false);
	//cong.setAutoCommit(false);
String query="";
String type= ""+request.getParameter("voucher_type");
int counter= Integer.parseInt(request.getParameter("counter"));
String voucher_id[]= new String[counter];
String receive_id[]= new String[counter];
String cgtRec_Id[]= new String[counter];

String StockTransfer_Type[]= new String[counter];
boolean cancel[]= new boolean[counter];
boolean oldactive[]= new boolean[counter];
int lot_count=0;
int avil_count=0;
//System.out.println("440 Voucher_type:"+type);
//out.print("<br> 402 counter="+counter);
errLine="431";
for(int i=0; i<counter; i++)
{

voucher_id[i]= ""+request.getParameter("voucher_id"+i);
//out.print("<br>378 voucher_id[i]"+voucher_id[i]);
receive_id[i]= ""+request.getParameter("receive_id"+i);
cgtRec_Id[i]= ""+request.getParameter("cgtRec_Id"+i);
//System.out.println("<br>439 **********cgtRec_Id="+cgtRec_Id[i]);
StockTransfer_Type[i]=request.getParameter("StockTransfer_Type"+i);

String temp= ""+request.getParameter("cancel"+i);
//
	
	//System.out.println("454 temp="+temp);
cancel[i]=true;
if("yes".equals(temp))
	{cancel[i]=false;}
oldactive[i]=false;
String tempr=""+request.getParameter("old"+i);
if("active".equals(tempr))
	{oldactive[i]=true;}
}//for
errLine="451";
//String StockTransfer_Type=request.getParameter("StockTransfer_Type");
//System.out.println("464 counter="+counter);
if("98".equals(type))
{
	for(int i=0; i<counter; i++)
	{
		
		if(!cancel[i])
		{

		query="Select * from Receive_Transaction where  receive_id=?";
		pstmt_g = conp.prepareStatement(query);
		//pstmt_g.setString(1,receive_id[i]);
		pstmt_g.setString(1,cgtRec_Id[i]);
		//System.out.println("477 cgtRec_Id[i]="+cgtRec_Id[i]);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
			{lot_count++;}
		pstmt_g.close();
		//}
		//System.out.println("483 lot_count="+lot_count);
	//}//end of for 447
	//System.out.println("<br>471 ^^^^^^^^^lot_count="+lot_count);

	String AvailRT_Id[]=new String[lot_count];
	String Lot_Id[]=new String[lot_count];
	String Location_Id[]=new String[lot_count];
	String Receive_Sell[]=new String[lot_count];
	double Quantity[]=new double[lot_count];
	
	double AvailQuantity[]=new double[lot_count];
	String RT_IDUpdate[]=new String[lot_count];
	String Lot_IdUpdate[]=new String[lot_count];
	String Receive_Sell1="";
	String Lot_Id1="";
	String Location_Id1="";
	String AvailRT_Id1="";
	double Quantity1=0;
	lot_count=0;
	avil_count=0;
	//for(int i=0; i<counter; i++)
	//{
	
	//if(!cancel[i])
	//{
		
		String availQtyQuery="select ReceiveTransaction_Id, Available_Quantity from Receive_Transaction where Receive_Id=?";

		pstmt_g = conp.prepareStatement(availQtyQuery);
		pstmt_g.setString(1,cgtRec_Id[i]);
		
		rs_g = pstmt_g.executeQuery();	

		while(rs_g.next())
		{
	 		RT_IDUpdate[avil_count]=rs_g.getString("ReceiveTransaction_Id");			
	   		AvailQuantity[avil_count]=rs_g.getDouble("Available_Quantity");
		
		avil_count++;
		}
		pstmt_g.close();

	errLine="512";
	query="Select * from Receive_Transaction where receive_id=?";
	//System.out.println("<br>487 In Receive_Transaction selection");
	pstmt_g = conp.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
	//System.out.println("531 receive_id[i]:"+receive_id[i]);
	while(rs_g.next())
	{
		Receive_Sell1=A.getNameCondition(conp,"Receive","Receive_Sell","Where Receive_id="+receive_id[i]);
		Lot_Id1=rs_g.getString("Lot_Id");
		//System.out.println("536 Lot_Id1:"+Lot_Id1);
		Location_Id1=rs_g.getString("Location_Id");
		Quantity1=rs_g.getDouble("Quantity");
		AvailRT_Id1=rs_g.getString("ST_RTId");

		
		for(int m=0;m<avil_count;m++)
		{
		
		if(AvailRT_Id1.equals(RT_IDUpdate[m]))
		{
		Receive_Sell[m]=Receive_Sell1;
		Lot_Id[m]=Lot_Id1;
		Location_Id[m]=Location_Id1;
		Quantity[m]=Quantity1;
		AvailRT_Id[m]=AvailRT_Id1;
				
		}
		
			
		}//for
		lot_count++;
	}
	pstmt_g.close();

	for(int n=0;n<avil_count;n++)
		{
		
		if("".equals(Quantity[n]))
		{
		Receive_Sell[n]="0";
		Lot_Id[n]="0";
		Location_Id[n]="0";
		Quantity[n]=0;
		AvailRT_Id[n]="0";
				
		}
		}

		//for(int m=0; m<avil_count; m++)
		//{
		//System.out.println("<br>552 ####Quantity="+m+"="+Quantity[m]);
		//System.out.println("<br>552 ####AvailQuantity="+m+"="+AvailQuantity[m]);
		//}
		

		errLine="568";
		
		
		//System.out.println("<br>506 ^^^^^^^^^lot_count="+lot_count);

		for(int k=0; k<avil_count; k++)
		{
		
		
	
		errLine="578";
		
			
			AvailQuantity[k]=AvailQuantity[k] + Quantity[k];
			//System.out.println("596 AvailQuantity="+k+"="+AvailQuantity[k]);

			query="Update Receive_Transaction set Available_Quantity=?, Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where ReceiveTransaction_Id=?";
			//System.out.println("<br>533 In Receive_Transaction Update** ");
			pstmt_p= conp.prepareStatement(query);
			pstmt_p.setString (1,""+AvailQuantity[k]);
			pstmt_p.setString (2,""+user_id);		
			pstmt_p.setString (3,""+machine_name);
			pstmt_p.setString (4,""+RT_IDUpdate[k]);

			int a500=pstmt_p.executeUpdate();
			//System.out.println("604 query:"+query);
			pstmt_p.close();
			
		}
	//}	//end of if cancel 476
	//}// end of for 473
	
	errLine="599";
	//update LotLocation table
	for(int j=0; j<lot_count; j++)
	{
	//out.print("<br> 506 i:"+i);
	//out.print("<br> 506 lot_id"+i+":"+Lot_Id[i]);
	//out.print("<br> 506 location_id"+i+":"+Location_Id[i]);
	//System.out.println("<br>533 In LotLocation Update** ");
	String today_string=format.format(D);
	//if(!("7".equals(StockTransfer_Type[i])))
	//	{

		query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
			//out.print("<br>517query" +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,Lot_Id[j]); 
		pstmt_p.setString(2,Location_Id[j]); 
		pstmt_p.setString(3,company_id); 
		rs_g = pstmt_p.executeQuery();
		//out.print("<br>523");
		double fincarats=0;
		double phycarats=0;
		int p=0;
		while(rs_g.next()) 	
		{
			fincarats= rs_g.getDouble("Carats");	
			phycarats= rs_g.getDouble("Available_Carats");	
			p++;
		}
		pstmt_p.close();
	//System.out.println("641 phycarats:"+phycarats);
	if("0".equals(Receive_Sell[j]))
		{
		fincarats = fincarats + Quantity[j];
		phycarats = phycarats + Quantity[j];
		}
	else {
		fincarats = fincarats - Quantity[j];
		phycarats = phycarats - Quantity[j];
	//}
	query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
	//out.print("<br>543 query" +query);
	pstmt_p = conp.prepareStatement(query);
	//pstmt_p.setString(1,"0"); 
	pstmt_p.setString(1,""+fincarats); 
	pstmt_p.setString(2,""+phycarats); 
	pstmt_p.setString (3, user_id);		
	pstmt_p.setString (4, machine_name);		
	pstmt_p.setString(5,Lot_Id[j]); 
	//System.out.println("660 Lot_Id[j]:"+Lot_Id[j]);
	pstmt_p.setString(6,Location_Id[j]); 
	pstmt_p.setString(7,company_id); 
	//out.println("Before Query <br>"+query);
	int a417 = pstmt_p.executeUpdate();
	//out.println("<br>Data Successfully updated in lot table <br>");
	pstmt_p.close();
		}
	//out.print("<br> 556 i:"+i);
	}//for
	
	
	}
		
	}//end of for 447

	errLine="663";
}
else if("3".equals(type) || "99".equals(type) || "100".equals(type))
{

	for(int i=0; i<counter; i++)
	{
		if(!("7".equals(StockTransfer_Type[i])))
		{

		if(!cancel[i])
		{

		query="Select * from Receive_Transaction where  receive_id=?";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id[i]);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
			{lot_count++;}
		pstmt_g.close();
		if(!("6".equals(StockTransfer_Type[i])))
		{
			String temp_receiveid=""+(Integer.parseInt(receive_id[i])+1);
			query="Select * from Receive_Transaction where  receive_id=?";

			pstmt_g = cong.prepareStatement(query);
			pstmt_g.setString(1,temp_receiveid);
			rs_g = pstmt_g.executeQuery();	
			while(rs_g.next())
				{lot_count++;}

			pstmt_g.close();
		}
		}
		}
	}//for
//out.print("<br> 451 lot_count:"+lot_count);
String Lot_Id[]=new String[lot_count];
String Location_Id[]=new String[lot_count];
String Receive_Sell[]=new String[lot_count];
double Quantity[]=new double[lot_count];

lot_count=0;
for(int i=0; i<counter; i++)
{
	if(!("7".equals(StockTransfer_Type[i])))
		{

	if(!cancel[i])
	{

	query="Select * from Receive_Transaction where  receive_id=?";

	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
	{
		Receive_Sell[lot_count]=A.getNameCondition(conp,"Receive","Receive_Sell","Where Receive_id="+receive_id[i]);
		Lot_Id[lot_count]=rs_g.getString("Lot_Id");
		Location_Id[lot_count]=rs_g.getString("Location_Id");
		Quantity[lot_count]=rs_g.getDouble("Quantity");
		lot_count++;
	}
	pstmt_g.close();

	if(!("6".equals(StockTransfer_Type[i])))
		{
		String temp_receiveid=""+(Integer.parseInt(receive_id[i])+1);

		query="Select * from Receive_Transaction where  receive_id=?";

		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,temp_receiveid);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
			{
			Receive_Sell[lot_count]=A.getNameCondition(conp,"Receive","Receive_Sell","Where Receive_id="+temp_receiveid);
			Lot_Id[lot_count]=rs_g.getString("Lot_Id");
			Location_Id[lot_count]=rs_g.getString("Location_Id");
			Quantity[lot_count]=rs_g.getDouble("Quantity");
			lot_count++;
			}
		pstmt_g.close();
		}
	}
		}
}//for

//out.print("<br> 502 lot_count:"+lot_count);
errLine="753";
for(int i=0; i<lot_count; i++)
	{
	//out.print("<br> 506 i:"+i);
	//out.print("<br> 506 lot_id"+i+":"+Lot_Id[i]);
	//out.print("<br> 506 location_id"+i+":"+Location_Id[i]);

	String today_string=format.format(D);
	//if(!("7".equals(StockTransfer_Type[i])))
	//	{

		query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
			//out.print("<br>517query" +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,Lot_Id[i]); 
		pstmt_p.setString(2,Location_Id[i]); 
		pstmt_p.setString(3,company_id); 
		rs_g = pstmt_p.executeQuery();
		//out.print("<br>523");
		double fincarats=0;
		double phycarats=0;
		int p=0;
		while(rs_g.next()) 	
		{
			fincarats= rs_g.getDouble("Carats");	
			phycarats= rs_g.getDouble("Available_Carats");	
			p++;
		}
		pstmt_p.close();
	
	if("0".equals(Receive_Sell[i]))
		{
		fincarats = fincarats + Quantity[i];
		phycarats = phycarats + Quantity[i];
		}
	else {
		fincarats = fincarats - Quantity[i];
		phycarats = phycarats - Quantity[i];
//}
query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
//out.print("<br>543 query" +query);
pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString(1,"0"); 
pstmt_p.setString(1,""+fincarats); 
pstmt_p.setString(2,""+phycarats); 
pstmt_p.setString (3, user_id);		
pstmt_p.setString (4, machine_name);		
pstmt_p.setString(5,Lot_Id[i]); 
pstmt_p.setString(6,Location_Id[i]); 
pstmt_p.setString(7,company_id); 
//out.println("Before Query <br>"+query);
int a417 = pstmt_p.executeUpdate();
//out.println("<br>Data Successfully updated in lot table <br>");
pstmt_p.close();
		}
	//out.print("<br> 556 i:"+i);
	}//for


	}//if

else{
errLine="815";
for(int i=0; i<counter; i++)
{

//out.print("<br> 437 <br>");

	if(!cancel[i])
	{
query="Select * from Receive_Transaction where  receive_id=?";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]);
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
	{lot_count++;}
pstmt_g.close();
	}
}//for

//out.print("<br> 452 <br>");

String Lot_Id[]=new String[lot_count];
String Location_Id[]=new String[lot_count];
String R_Id[]=new String[lot_count];
String RT_Id[]=new String[lot_count];
double Quantity[]=new double[lot_count];

 lot_count=0;
for(int i=0; i<counter; i++)
{
if(!cancel[i])
	{

query="Select * from Receive where  receive_id=? and  Consignment_ReceiveId=0";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]);
rs_g = pstmt_g.executeQuery();

String companyparty_id="";
double InvLocalTotal=0;
double InvDollarTotal=0;
while(rs_g.next())
	{
companyparty_id=rs_g.getString("Receive_FromId");
 InvLocalTotal=rs_g.getDouble("InvLocalTotal");
 InvDollarTotal=rs_g.getDouble("InvDollarTotal");
}
pstmt_g.close();

query="Select * from Receive_Transaction where  receive_id=?";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
	{
R_Id[lot_count]=rs_g.getString("Receive_Id");
RT_Id[lot_count]=rs_g.getString("ReceiveTransaction_Id");
Lot_Id[lot_count]=rs_g.getString("Lot_Id");
Location_Id[lot_count]=rs_g.getString("Location_Id");
Quantity[lot_count]=rs_g.getDouble("Quantity");
	lot_count++;}
pstmt_g.close();


if("10".equals(type)) 
	{
	query = "update Master_CompanyParty set Purchase_AdvanceLocal=Purchase_AdvanceLocal-?,Purchase_AdvanceDollar=Purchase_AdvanceDollar-? where CompanyParty_Id=?";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1, ""+InvLocalTotal);
pstmt_p.setString (2, ""+InvDollarTotal);
pstmt_p.setString (3, companyparty_id);
int a459 = pstmt_p.executeUpdate();
pstmt_p.close();


	}
if("11".equals(type))
		{

	query = "update Master_CompanyParty set Sale_AdvanceLocal=Sale_AdvanceLocal-?,Sale_AdvanceDollar=Sale_AdvanceDollar-? where CompanyParty_Id=?";
pstmt_p = conp.prepareStatement(query);

pstmt_p.setString (1, ""+InvLocalTotal);
pstmt_p.setString (2, ""+InvDollarTotal);
pstmt_p.setString (3, companyparty_id);
int a459 = pstmt_p.executeUpdate();
pstmt_p.close();

}
	}
}//for
errLine="909";
for(int i=0; i<lot_count; i++)
	{

if("10".equals(type) || "11".equals(type))
	{
	//out.print("<br> 480 <br>");

		String temp_receiveid= A.getNameCondition(conp,"Receive_Transaction","Consignment_ReceiveId","where ReceiveTransaction_Id="+RT_Id[i]);
		//out.print("<br> 480 temp_receiveid="+temp_receiveid);
		//out.print("<br> 480 R_Id[i]="+R_Id[i]);
		String returnquery="select * from Receive_Transaction where ReceiveTransaction_Id="+temp_receiveid;
		pstmt_p=conp.prepareStatement(returnquery);
		rs_g=pstmt_p.executeQuery();
		String lot_id="";
		double Return_Quantity=0;
		String ReceiveTransaction_Id="";
		while(rs_g.next())
		{
		lot_id=rs_g.getString("Lot_Id");
		Return_Quantity=rs_g.getDouble("Return_Quantity");
		ReceiveTransaction_Id=rs_g.getString("ReceiveTransaction_Id");
		//out.print("<br> 480 ReceiveTransaction_Id="+ReceiveTransaction_Id);

		if(Lot_Id[i].equals(lot_id))
			{
		Return_Quantity=Return_Quantity-Quantity[i];
		String updatequery="Update Receive_Transaction set Return_Quantity=? where ReceiveTransaction_Id="+ReceiveTransaction_Id;
		pstmt_g=conp.prepareStatement(updatequery);

				pstmt_g.setDouble(1,Return_Quantity);

				int a498=pstmt_g.executeUpdate();
				pstmt_g.close();
			}

		}
		pstmt_p.close();

	}

}//for

for(int i=0; i<lot_count; i++)
	{
	String today_string=format.format(D);
query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,Lot_Id[i]); 
pstmt_p.setString(2,Location_Id[i]); 
pstmt_p.setString(3,company_id); 
rs_g = pstmt_p.executeQuery();
double fincarats=0;
double phycarats=0;
int p=0;
	while(rs_g.next()) 	
	{
	fincarats= rs_g.getDouble("Carats");	
	phycarats= rs_g.getDouble("Available_Carats");	
	p++;
	}
	pstmt_p.close();
if(("1".equals(type))||("10".equals(type)))
		{
fincarats = fincarats + Quantity[i];
phycarats = phycarats + Quantity[i];
		}
else {
fincarats = fincarats - Quantity[i];
phycarats = phycarats - Quantity[i];
}
query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
//out.print("<br>query" +query);
pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString(1,"0"); 
pstmt_p.setString(1,""+fincarats); 
pstmt_p.setString(2,""+phycarats); 
pstmt_p.setString (3, user_id);		
pstmt_p.setString (4, machine_name);		
pstmt_p.setString(5,Lot_Id[i]); 
pstmt_p.setString(6,Location_Id[i]); 
pstmt_p.setString(7,company_id); 
//out.println("Before Query <br>"+query);
int a417 = pstmt_p.executeUpdate();
//out.println("<br>Data Successfully updated in lot table <br>");
pstmt_p.close();




	}//for

}//else 
errLine="1003";
//out.print("<br>928 Counter="+counter);
boolean flag =false;
for(int i=0; i<counter; i++)
{
if(oldactive[i]==cancel[i])
	{flag=true;}	

  if("98".equals(type))// for split
  {
	int r_id=0;
	//if(("4".equals(StockTransfer_Type[i])))
		//{
			r_id=Integer.parseInt(receive_id[i])+1;
		//}
	
	// for source
	query="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";

errLine="1021";
	//out.println("<BR>90" +query);
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,"3");		
	pstmt_p.setString(3,receive_id[i]);		
	int a67 = pstmt_p.executeUpdate();
	pstmt_p.close();

		// for destination
		query="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";
errLine="1033";
		//out.println("<BR>90" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,"3");		
		pstmt_p.setString(3,""+r_id);		
		int a342 = pstmt_p.executeUpdate();
		pstmt_p.close();
	
	// for source
	query="Update Receive set Active=?  where Receive_Id=?";
errLine="1045";
	//out.println("<BR>611" +query);
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,receive_id[i]);		
	int a77 = pstmt_p.executeUpdate();
	pstmt_p.close();


		// for destination
		query="Update Receive set Active=?  where Receive_Id=?";

		//out.println("<BR>622" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,""+r_id);		
		int a363 = pstmt_p.executeUpdate();
		pstmt_p.close();
		
	
	//Start : Code to delete the entries in the Receive_Transaction
	query="Update Receive_Transaction set Active=?  where Receive_Id=?";

	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,receive_id[i]);		
	int a812 = pstmt_p.executeUpdate();
	pstmt_p.close();

	query="Update Receive_Transaction set Active=?  where Receive_Id=?";

	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,""+r_id);		
	int a821 = pstmt_p.executeUpdate();
	pstmt_p.close();
	//End : Code to delete the entries in the Receive_Transaction
	
errLine="1087";
	}
else if("3".equals(type) || "99".equals(type) || "100".equals(type))
	{
	int r_id=0;
	if(("7".equals(StockTransfer_Type[i])))
		{
			r_id=Integer.parseInt(receive_id[i]);
		}
		else
		{
			r_id=Integer.parseInt(receive_id[i])+1;

		}
	query="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";

	//out.println("<BR>90" +query);
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,"3");		
	pstmt_p.setString(3,receive_id[i]);		
	int a67 = pstmt_p.executeUpdate();
	pstmt_p.close();

	//if(!("6".equals(StockTransfer_Type[i])))
		{

		query="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";

		//out.println("<BR>90" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,"3");		
		pstmt_p.setString(3,""+r_id);		
		int a342 = pstmt_p.executeUpdate();
		pstmt_p.close();
		}
	query="Update Receive set Active=?  where Receive_Id=?";

	//out.println("<BR>611" +query);
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,receive_id[i]);		
	int a77 = pstmt_p.executeUpdate();
	pstmt_p.close();

	//if(!("6".equals(StockTransfer_Type[i])))
		{
		query="Update Receive set Active=?  where Receive_Id=?";

		//out.println("<BR>622" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,""+r_id);		
		int a363 = pstmt_p.executeUpdate();
		pstmt_p.close();
		}
	
	//Start : Code to delete the entries in the Receive_Transaction
	query="Update Receive_Transaction set Active=?  where Receive_Id=?";

	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,receive_id[i]);		
	int a812 = pstmt_p.executeUpdate();
	pstmt_p.close();

	query="Update Receive_Transaction set Active=?  where Receive_Id=?";

	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,cancel[i]); 
	pstmt_p.setString(2,""+r_id);		
	int a821 = pstmt_p.executeUpdate();
	pstmt_p.close();
	//End : Code to delete the entries in the Receive_Transaction
	

	}
else{
query="Update Voucher set Active=?  where Voucher_Id=?";
errLine="1173";
//out.println("<BR>633" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a625 = pstmt_p.executeUpdate();
pstmt_p.close();

errLine="1182";
query="Update Financial_Transaction set Active=?  where Voucher_Id=?";
errLine="1184";
//out.println("<BR>644" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a67 = pstmt_p.executeUpdate();
pstmt_p.close();


query="Update Receive set Active=?  where Receive_Id=?";
errLine="1195";
//out.println("<BR>655" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,receive_id[i]);		
int a77 = pstmt_p.executeUpdate();
pstmt_p.close();


query="Update Payment_Details set Active=?  where Voucher_Id=?";
errLine="1206";
//out.println("<BR>666" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a99 = pstmt_p.executeUpdate();
pstmt_p.close();
//out.print("<br>1213 i="+i);
//out.print("<br>1214 cancel["+i+"]="+cancel[i]);
//out.print("<br>1215 lot_count="+lot_count);
if("1".equals(type) || "2".equals(type))
{
if(!cancel[i])
		{
			String strQuery="Select * from Receive_Transaction where Receive_Id="+receive_id[i];
		errLine="1220";
			pstmt_g = cong.prepareStatement(strQuery);
			rs_g=pstmt_g.executeQuery();	
			while(rs_g.next())
			{
				String rt_Id=rs_g.getString("ReceiveTransaction_Id");
				String oref_Text=rs_g.getString("OT_RefText");
				String ref_Text[]=oref_Text.split(":");
		
				if(ref_Text.length>1)
				{
				errLine="1231";		
				StringTokenizer ot_Id=new StringTokenizer(ref_Text[0],"#");
				StringTokenizer new_sale=new StringTokenizer(ref_Text[1],"#");
				errLine="1234";		
				//System.out.println("ref_Text="+ref_Text[0]);
				//System.out.println("ref_Text="+ref_Text[1]);

				while (ot_Id.hasMoreTokens())
				{
					 String otId=ot_Id.nextToken();        
					 String nsale=new_sale.nextToken();
					 
					 String strUpdateQuery="Update Order_Transaction"+
					 " set Available_Quantity=Available_Quantity+"+nsale+"   where OrderTransaction_Id="+otId;
					errLine="1241"; //System.out.println("strUpdateQuery="+strUpdateQuery);
					 pstmt_p = conp.prepareStatement(strUpdateQuery);
					 int a=pstmt_p.executeUpdate();	
					 pstmt_p.close();
					 errLine="1245";
				} //while()
			
				}//if(ref_Text.length>1)
			} //while()
			pstmt_g.close();
			errLine="1249";
		}
query="select * from Voucher where Active=1 and Referance_VoucherId="+voucher_id[i];
errLine="1252";
//out.print("<br> 677 "+query);
pstmt_p=conp.prepareStatement(query);
int ref_voucher=0;

rs_g=pstmt_p.executeQuery();
while(rs_g.next())
	{
		ref_voucher=rs_g.getInt("Voucher_Id");
	}
pstmt_p.close();

if(ref_voucher!=0)
	{
		query="Update Voucher set Active=?  where Voucher_Id=?";
errLine="1265";
		//out.println("<BR>691" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,""+ref_voucher);		
		int a696 = pstmt_p.executeUpdate();
		pstmt_p.close();

		query="Update Financial_Transaction set Active=?  where Voucher_Id=?";
errLine="1275";
		//out.println("<BR>701" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,""+ref_voucher);		
		int a706 = pstmt_p.executeUpdate();
		pstmt_p.close();

		query="Update Payment_Details set Active=?  where Voucher_Id=?";
errLine="1285";
		//out.println("<BR>666" +query);
		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,cancel[i]); 
		pstmt_p.setString(2,""+ref_voucher);		
		int a716 = pstmt_p.executeUpdate();
		pstmt_p.close();
	}
	}
}//else
}//for
errLine="1298";

conp.commit();
//cong.commit();

C.returnConnection(conp);
C.returnConnection(cong);
//C.returnConnection(conp);
//C.returnConnection(cong);
response.sendRedirect("CancelVouchers.jsp?command=edit&&message=Data Sucessfully Updated");


}catch(Exception e)
	{
	conp.rollback();
	//cong.rollback();
    C.returnConnection(conp);
    C.returnConnection(cong);
	out.print("<BR>1315 EXCEPTION="+e+" errLine="+errLine);
	}
}//if
%>