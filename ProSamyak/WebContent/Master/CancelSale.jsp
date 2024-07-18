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
try
	{
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
String date=""+format.format(D);
try
{

if("Next".equals(command))
{
 		//java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
		String today_string= format.format(D);

		int dd1 = Integer.parseInt(request.getParameter("dd1"));
		int mm1 = Integer.parseInt(request.getParameter("mm1"));
		int yy1 = Integer.parseInt(request.getParameter("yy1"));
		java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
		int dd2 = Integer.parseInt(request.getParameter("dd2"));
		int mm2 = Integer.parseInt(request.getParameter("mm2"));
		int yy2 = Integer.parseInt(request.getParameter("yy2"));
		java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
		String type= request.getParameter("voucher_type");
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
		String receiveid_foredit=request.getParameter("receive_id");
		//out.println("receiveid_foredit="+receiveid_foredit);
		String desc="";
		double local=0;
		double dollar=0;
		double local_tot=0;
		double dollar_tot=0;
		String query="";
		String condition="";
		String dispaly="";
		if("1".equals(type))//sale
		{
			if("0".equals(receiveid_foredit))
			{
				condition="Receive_Sell=0 and R_Return=0 and opening_Stock=0 ";
			}
			else
			{
				condition="Receive_Sell=0 and Receive_No='"+receiveid_foredit+"' and R_Return=0 and opening_Stock=0" ;
			}
		} // and Consignment_ReceiveId=0

if("0".equals(party_id))
{
	query="Select * from  Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId not like "+company_id+" and Active=1 and purchase=1 and "+condition+" order by Receive_Date,Receive_No";
	dispaly="ALL";
}//if party_id=0
else{
	 dispaly=A.getName(conp,"CompanyParty",party_id);
	 query="Select * from  Receive where Receive_Date between ? and ? and Company_id=? and Receive_FromId="+party_id+" and Active=1 and purchase=1 and "+condition+" order by Receive_Date,Receive_No";
	}//else party


pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);
pstmt_g.setString(3,company_id); 

rs_g = pstmt_g.executeQuery();	
	
%>
<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<META HTTP-EQUIV="Expires" CONTENT="0">

</HEAD>

<body bgcolor=white background="../Buttons/BGCOLOR.JPG" >
<form action='CancelSale.jsp' name=f1 method=post >

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
//out.println("152 voucher_no="+voucher_no);
String st="checked";
String old="";
if(active)
{
	st="";
	old="active";
}
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

<tr>
<TD align=right colspan=4><b>Total&nbsp;&nbsp; <%=str.format(""+local_tot,d)%> </b></td>
<td>&nbsp;</td>
</tr>
<tr><td align=center colspan=5>
	<input type=submit value='Update' name=command class='Button1' >
</td></tr>
</table>

<tr><td colspan=2 align=right><font class='td1'>	Run Date <%=format.format(D)%> </font>
</td></tr>
</table>
</form>
<%
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
	cong.setAutoCommit(false);
	String query="";
	String type= ""+request.getParameter("voucher_type");
	int counter= Integer.parseInt(request.getParameter("counter"));
	String voucher_id[]= new String[counter];
	String receive_id[]= new String[counter];
	String streceive_id[]=new String[counter];
	String cgtRec_Id[]= new String[counter];
	//String streceive_id[]=null;
	String StockTransfer_Type[]= new String[counter];
	boolean cancel[]= new boolean[counter];
	boolean oldactive[]= new boolean[counter];
	int lot_count=0;
	int avil_count=0;
	errLine="268";
	//out.print("<br>269 counter="+counter);
	for(int i=0; i<counter; i++)
	{
		voucher_id[i]= ""+request.getParameter("voucher_id"+i);
		receive_id[i]= ""+request.getParameter("receive_id"+i);
		cgtRec_Id[i]= ""+request.getParameter("cgtRec_Id"+i);
		//out.print("<br>275 receive_id["+i+"]="+receive_id[i]);
		//out.print("<br>276 voucher_id["+i+"]="+voucher_id[i]);
		//out.print("<br>277 cgtRec_Id["+i+"]="+cgtRec_Id[i]);
		StockTransfer_Type[i]=request.getParameter("StockTransfer_Type"+i);

		String temp= ""+request.getParameter("cancel"+i);
		//out.print("<br>275 temp="+temp);
		cancel[i]=true;
		if("yes".equals(temp))
		{cancel[i]=false;}
		oldactive[i]=false;
		String tempr=""+request.getParameter("old"+i);
		if("active".equals(tempr))
		{oldactive[i]=true;}
		
	}//for
//out.print("<br>291 counter="+counter);
//out.print("<br>292 lot_count="+lot_count);
for(int i=0; i<counter; i++)
{  
	if(!cancel[i])
	 {
		query="Select * from Receive_Transaction where  receive_id=?";
        errLine="298";
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,receive_id[i]);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{lot_count++;}
		pstmt_g.close();
	 }
} //for
//out.print("<br>307 lot_count="+lot_count);
errLine="308";
String Lot_Id[]=new String[lot_count];
String Location_Id[]=new String[lot_count];
String R_Id[]=new String[lot_count];
String RT_Id[]=new String[lot_count];
String ghat_RT_Id[]=new String[lot_count];
double Quantity[]=new double[lot_count];
int j=0;
lot_count=0;
for(int i=0; i<counter; i++)
{
	
	
	
	String query2="Select receive_id from receive where Consignment_ReceiveId=?";
    errLine="323";
	 pstmt_g = cong.prepareStatement(query2);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
	
	
	while(rs_g.next())
	{
       streceive_id[i]=rs_g.getString("receive_id");
      //out.print("<br>355 streceive_id["+s+"]="+streceive_id[s]);

	  
	}
	pstmt_g.close();
	if(!cancel[i])
	{
	query="Select * from Receive where  receive_id=? and  Consignment_ReceiveId=0";

	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
errLine="344";
	String companyparty_id="";
	double InvLocalTotal=0;
	double InvDollarTotal=0;
	
	while(rs_g.next())
	{
	  companyparty_id=rs_g.getString("Receive_FromId");
	  InvLocalTotal=rs_g.getDouble("InvLocalTotal");
	  InvDollarTotal=rs_g.getDouble("InvDollarTotal");
      receive_id[j]=rs_g.getString("receive_id");	  
	  //out.print("<br>355 receive_id["+j+"]="+receive_id[j]);	
	j++;
	}
	pstmt_g.close();
    int stcounter=0;
	String query1="Select count(*)as stcounter from receive where Consignment_ReceiveId=?"; 
	pstmt_g = cong.prepareStatement(query1);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
	{
      stcounter=rs_g.getInt("stcounter");
	}
	pstmt_g.close();
	//out.print("<br>369 stcounter="+stcounter);
	/*String query2="Select receive_id from receive where Consignment_ReceiveId=?";
    errLine="346";
	 pstmt_g = cong.prepareStatement(query2);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
	streceive_id=new String[stcounter];
	while(rs_g.next())
	{
       streceive_id[i]=rs_g.getString("receive_id");
      //out.print("<br>355 streceive_id["+s+"]="+streceive_id[s]);
	}
	pstmt_g.close();*/

	query="Select * from Receive_Transaction where  receive_id=?";
	errLine="389";
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
	//out.print("<br>349 R_Id["+lot_count+"]="+R_Id[lot_count]);
	//out.print("<br>404 RT_Id["+lot_count+"]="+RT_Id[lot_count]);
	lot_count++;
	}
	pstmt_g.close();
	errLine="408";
	int p=0;
	//out.print("<br>410 i="+i);
	//out.print("<br>384 streceive_id[i]="+streceive_id[i]);
	//query="Select * from Receive_Transaction where  receive_id=?";
	//errLine="382";
	//pstmt_g = cong.prepareStatement(query);
	//pstmt_g.setString(1,streceive_id[i]);
	//rs_g = pstmt_g.executeQuery();
	//while(rs_g.next())
	//{
	//out.print("<br>388");
	//R_Id[p]=rs_g.getString("Receive_Id");
	//ghat_RT_Id[p]=rs_g.getString("ReceiveTransaction_Id");
	//Lot_Id[p]=rs_g.getString("Lot_Id");
	//Location_Id[p]=rs_g.getString("Location_Id");
	//Quantity[p]=rs_g.getDouble("Quantity");
	//out.print("<br>394 ghat_RT_Id["+p+"]="+ghat_RT_Id[p]);
	//p++;
	//}
	//pstmt_g.close();
 }
}//for
errLine="431";


errLine="434";
//out.print("<br>435 Counter="+counter);
boolean flag =false;
for(int i=0; i<receive_id.length;i++)
{
	if(oldactive[i]!=cancel[i])
	{
	//out.print("<br>415 RT_Id[i]="+RT_Id[i]);
	//out.print("<br>416 ghat_RT_Id[i]="+ghat_RT_Id[i]);
	  //out.print("<br>416 receive_id["+i+"]="+receive_id[i]);
	  //out.print("<br>416 streceive_id["+i+"]="+streceive_id[i]);
	  //out.print("<br>416 voucher_id["+i+"]="+voucher_id[i]);
	
	query="Update Voucher set Active=?  where Voucher_Id=?";
	errLine="448";
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,voucher_id[i]);		
	int a625 = pstmt_p.executeUpdate();
	pstmt_p.close();

    //To cancel ghat entry row.
    query="Update Voucher set Active=?  where Voucher_no=?";
	errLine="457";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,streceive_id[i]);		
	int a626 = pstmt_p.executeUpdate();
	pstmt_p.close();

	errLine="1182";
	query="Update Financial_Transaction set Active=?  where Voucher_Id=?";
	errLine="467";
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,voucher_id[i]);		
	int a67 = pstmt_p.executeUpdate();
	pstmt_p.close();

	query="Update Receive set Active=?  where Receive_Id=?";
	errLine="477";
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,receive_id[i]);		
	int a77 = pstmt_p.executeUpdate();
	pstmt_p.close();

    //To cancel ghat entry row.
    query="Update Receive set Active=?  where Receive_Id=?";
	errLine="487";
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,streceive_id[i]);		
	int a78 = pstmt_p.executeUpdate();
	pstmt_p.close();

  /* int lotcounter=0;        
    query="Select count(*) as lotcounter from receive_transaction where receive_id=? and active=1";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,receive_id[i]);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
	{
      lotcounter=rs_g.getInt("lotcounter");
	}
    pstmt_g.close();
	for(int n=0;n<lotcounter;n++)
	{
	out.print("<br>485 RT_Id["+n+"]="+RT_Id[n]);
	out.print("<br>485 ghat_RT_Id["+n+"]="+ghat_RT_Id[n]);
  */
	//out.print("<br>511 receive_id["+i+"]="+receive_id[i]);

	query="Update Receive_Transaction set Active=?  where receive_id=?";
	errLine="513";
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,receive_id[i]);		
	int a98 = pstmt_p.executeUpdate();
	pstmt_p.close();
	//out.print("<br>521 streceive_id["+i+"]="+streceive_id[i]);

	//To cancel ghat entry row.
	query="Update Receive_Transaction set Active=?  where receive_id=?";
	errLine="524";
	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setBoolean(1,false); 
	pstmt_p.setString(2,streceive_id[i]);		
	int a99 = pstmt_p.executeUpdate();
	pstmt_p.close();
	
/* if("1".equals(type) || "2".equals(type))
	{
	if(!cancel[i])
		{
			//out.print("<br>511 receive_id["+i+"]="+receive_id[i]);
			//out.print("<br>512 streceive_id="+streceive_id);
            String strQuery="Select * from Receive_Transaction where Receive_Id="+receive_id[i];
			errLine="1220";
			pstmt_g = cong.prepareStatement(strQuery);
			rs_g=pstmt_g.executeQuery();	
			while(rs_g.next())
			{
				String rt_Id=rs_g.getString("ReceiveTransaction_Id");
				String oref_Text=rs_g.getString("OT_RefText");
				String ref_Text[]=oref_Text.split(":");
				//out.print("<br>519 rt_Id="+rt_Id);
				
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
	}//if(!cancel[i])
	query="select * from Voucher where Active=1 and Referance_VoucherId="+voucher_id[i];
	errLine="1252";

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
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setBoolean(1,cancel[i]); 
			pstmt_p.setString(2,""+ref_voucher);		
			int a696 = pstmt_p.executeUpdate();
			pstmt_p.close();

			query="Update Financial_Transaction set Active=?  where Voucher_Id=?";
			errLine="1275";
		
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setBoolean(1,cancel[i]); 
			pstmt_p.setString(2,""+ref_voucher);		
			int a706 = pstmt_p.executeUpdate();
			pstmt_p.close();
			query="Update Payment_Details set Active=?  where Voucher_Id=?";
			errLine="1285";
			pstmt_p = conp.prepareStatement(query);
			pstmt_p.setBoolean(1,cancel[i]); 
			pstmt_p.setString(2,""+ref_voucher);		
			int a716 = pstmt_p.executeUpdate();
			pstmt_p.close();
		}
	}//if
    */
  }
}//for

errLine="1298";

conp.commit();
cong.commit();

C.returnConnection(conp);
C.returnConnection(cong);
//C.returnConnection(conp);
//C.returnConnection(cong);
//response.sendRedirect("CancelVouchers.jsp?command=edit&&message=Data Sucessfully Updated");
response.sendRedirect("../Inventory/indiaSell.jsp?command=Default&lots=6&sale=Local&message=Default&pieces=no&stock=no&ledgers=2&Receive_Id=0&invoicedate="+date);
}catch(Exception e)
	{
		conp.rollback();
		cong.rollback();
		C.returnConnection(conp);
		C.returnConnection(cong);
		out.print("<BR>631 FileName: Master:CancelSale.jsp and EXCEPTION is:"+e+" errLine="+errLine);
	}

%>
<!-- <SCRIPT LANGUAGE="JavaScript">

function closeWindow()
	{
		alert("Voucher deleted successfully");
		
		window.close();
	}

</SCRIPT>
<Html>
	<body OnLoad="closeWindow();">
	</body>
</Html> -->
<%}//if(Update)

%>

