<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 

String errLine="8";
try{
Connection cong = null;
Connection cong1 = null;

cong=C.getConnection();
cong1=C.getConnection();

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

String local_symbol= I.getLocalSymbol(cong,company_id);
String company_name= A.getName(cong,"companyparty",company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

C.returnConnection(cong);
C.returnConnection(cong1);

ResultSet rs_g= null;
ResultSet rs_g1= null;
ResultSet rs_p= null;

Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_g1=null;
PreparedStatement pstmt_p=null;

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
errLine="44";
String command=request.getParameter("command");
 //out.print("<br>1command=" +command);
String hcommand=request.getParameter("hcommand");
 //out.print("<br>hcommand=" +hcommand);
 String message=request.getParameter("message");
 //out.print("<br>message=" +message);
//end if
String date=""+format.format(D);

if("Next".equals(command))
{

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
	String party_id= request.getParameter("party_id");
	String receiveid_foredit=request.getParameter("receive_id");
	//out.print("<bR>party_id"+party_id);
	//out.print("<br>73 receiveid_foredit="+receiveid_foredit);
	String query="";
	String condition="";
	String conditionSplit="";

%>
<html>
<head>
<title>Samyak - Samyak Software</title>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<script language="JavaScript">

function disrtclick()
{
	//window.event.returnValue=0;
}
function tb(str)
{
	window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=no"])
}
</script>
</head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<body bgcolor=#ffffee onContextMenu="disrtclick()" background="../Buttons/BGCOLOR.JPG">
<form action=CancelPurchase.jsp name=f1 method=post>
<tr><td>
 </td></tr>
</table>
<table align=center  bordercolor=#A4A4A4 border=1 cellspacing=0>
<tr><td colspan=2 align=right> <%=company_name%></td> 
</tr>
<tr><td colspan=2>
<table align=center   bordercolor=#A4A4A4 border=1 cellspacing=0>
	<tr bgcolor=skyblue><th colspan=11>
	<input type=hidden name=party_id value='<%=party_id%>' >
Purchase Cancel Report</th>
<tr><th colspan=5>From  <%=format.format(D1)%> -To <%=format.format(D2)%> </th></tr>
<input type=hidden name=dd1 value=<%=dd1%>>
<input type=hidden name=mm1 value=<%=mm1%>>
<input type=hidden name=yy1 value=<%=yy1%>>
<input type=hidden name=dd2 value=<%=dd2%>>
<input type=hidden name=mm2 value=<%=mm2%>>
<input type=hidden name=yy2 value=<%=yy2%>>
<tr>
<tr>
<th>Sr No</th>
<th>Select</th>
<th>Invoice No</th>
<th colspan=4>Split Details</th>
</tr>
<%

	
if("0".equals(receiveid_foredit))
{
	condition=" and Receive_Sell=1 and R_Return=0 and opening_Stock=0 ";
}
else
{
	condition=" and Receive_Sell=1 and Receive_No='"+receiveid_foredit+"' and R_Return=0 and opening_Stock=0" ;
}
	

if("0".equals(party_id))
{
	
}
else 
{
	condition=condition+" and Receive_FromId="+party_id;
	conditionSplit=conditionSplit+" and R1.Receive_FromId="+party_id+" ";
}
//out.print("<br>condition"+condition);
//r - > confirm nr ->return 
try	{
	cong=C.getConnection();
	cong1=C.getConnection();
}
catch(Exception Samyak31){ 
out.println("<font color=red> FileName : CancelPurchase.jsp<br>Bug No Samyak31 : "+ Samyak31);}

//getting the list of Purchases for which splitting is done and hence not allowed for cancel and also getting there split invoice numbers
errLine="128";
//out.print("<br>150 conditionSplit="+conditionSplit);
ArrayList splitedPurchases = new ArrayList();
query="select R1.consignment_receiveid from Receive R1, Receive R2 where R1.active=1 and R1.purchase=1 and R1.receive_sell=0 and R1.R_Return =0 and R1.opening_stock=0  and R1.StockTransfer_Type=4  and R1.company_id="+company_id +" and R1.consignment_receiveid=R2.Receive_Id and R2.active=1 and R2.purchase=1 and R2.receive_sell=1 and R2.R_Return =0 and R2.opening_stock=0  and R2.StockTransfer_Type=0  and R1.company_id="+company_id +" and R2.consignment_receiveid=0  "+conditionSplit;

pstmt_g = cong.prepareStatement(query);
errLine="133";
rs_g = pstmt_g.executeQuery();
//out.print("<br>157 query="+query);
while(rs_g.next())
{
	String cgtReceive_Id = rs_g.getString("consignment_receiveid");
	//out.print("<br> cgtReceive_Id="+cgtReceive_Id);
	splitedPurchases.add(cgtReceive_Id);
}
pstmt_g.close();

//getting all the financial purchases for the given party
//out.print("<br>167 condition="+condition);
query="select Receive_id,Receive_no,R_Return from receive where active=1 and purchase=1 and receive_sell=1 and R_Return =0 and opening_stock=0  and consignment_receiveid = 0 and StockTransfer_Type=0 and Receive_Date between ? and ? and Yearend_Id="+yearend_id+" and company_id="+company_id +" and Active=1 "+condition+" and Receive_Id Not IN (Select For_HeadId from Payment_Details where Active=1) order by Receive_Date";

//out.println("query="+query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setDate(1,D1); 
pstmt_g.setDate(2,D2); 
rs_g = pstmt_g.executeQuery();	
//out.print("<br>155 query="+query);
int sr_no=1;
int j=0;
while(rs_g.next())
	{

		String receive_id=rs_g.getString("Receive_id");
		String Receive_no=rs_g.getString("Receive_no");
		String return_=rs_g.getString("R_Return");

		String splitInvNo = "";
		String Receive_ID = "";
		if(splitedPurchases.contains(receive_id))
		{
			String splitQuery = "Select Receive_No from Receive where Active=1 and Purchase=1 and Receive_Sell=1 and Opening_Stock=0 and R_Return=0 and StockTransfer_Type=4 and consignment_receiveid = "+receive_id+" and company_id="+company_id +" "+condition;
System.out.print("<br>188 splitQuery="+splitQuery);
//out.print("<br>188 condition="+condition);
			pstmt_g1 = cong1.prepareStatement(splitQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			rs_g1 = pstmt_g1.executeQuery();	
			while(rs_g1.next())
			{
				if(rs_g1.isLast())
				{
					splitInvNo += rs_g1.getString("Receive_No");
				}
				else
				{
					splitInvNo += rs_g1.getString("Receive_No") + ", ";
				}
								
errLine="178";
				System.out.println("212 splitInvNo"+splitInvNo);
			}
			pstmt_g1.close();
		}
		else
		{
			splitInvNo = "--";
		}
System.out.println("<br>210 splitInvNo="+splitInvNo);

%>
		<td><%=sr_no%></td>
		<td align="center">
		<%if("--".equals(splitInvNo))
		{%>
			<input type=checkbox name=selected<%=j%> value=yes >
		<%}
		else
		{%>	
			<input type=checkbox name="selected<%=j%>" onClick="splitCall(<%=j%>)">
			<input type=hidden name=splitInvNo<%=j%> value=<%=splitInvNo%> >
		<%}%>
		</td>
		<td><a href="javascript:tb('../Inventory/InvDetailReport.jsp?command=purchase&receive_id=<%=receive_id%>&refno=yes&pieces=no&printremark=null')" ><%=Receive_no%></a></td>
		<td align="center"><%=splitInvNo%></td>
		<input type=hidden name=operation<%=j%>  value=purchase >
		<input type=hidden name=purchase_receive_id<%=j%>  value=<%=receive_id%> >
		</tr>
	
<%		sr_no++;
		j++;
	}//end while
	%>
<tr>
	<td colspan=4 align=center>
	<input type=hidden name=count  value='<%=j%>' >

	<input class=button1 type=submit name=command value=update >
	</td>
</tr>
</table></form>
<script language="javascript">
function splitCall(rownum)
{
		//alert("Function callled");
		var splitse="selected"+rownum;
		var splitInvNo="splitInvNo"+rownum;
		//alert("Function called"+rownum);
		//alert("value"+document.f1.elements[splitse].value);
		if(document.f1.elements[splitse].checked)
		{
			var spliValue=document.f1.elements[splitInvNo].value;
			if(confirm("You want to Delete Split Stock Invoice.."+spliValue+"..?"))
			{
			}else
				{
					// alert("Uncheck");
					document.f1.elements[splitse].checked=false;
				}
			
		}else{//alert("UNchecked");
		}

}
</script>
	<%
	
	pstmt_g.close();
	C.returnConnection(cong);
	C.returnConnection(cong1);
//------------------------------------------------------------------------------

}//end if 

String resp_message="";
//******************************************

if(command.equals("update"))
{


	int count =Integer.parseInt(request.getParameter("count"));
	int dd1 =Integer.parseInt(request.getParameter("dd1"));
	int mm1 =Integer.parseInt(request.getParameter("mm1"));
	int yy1 =Integer.parseInt(request.getParameter("yy1"));
	int dd2 =Integer.parseInt(request.getParameter("dd2"));
	int mm2 =Integer.parseInt(request.getParameter("mm2"));
	int yy2 =Integer.parseInt(request.getParameter("yy2"));
	java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
	java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	System.out.println("299 D1"+D1);
	System.out.println("299 D2"+D2);
 errLine="234";
	try	{
		cong=C.getConnection();
		conp=C.getConnection();
		}
		catch(Exception Samyak31){ 
				out.println("<font color=red> FileName : CancelPurchase.jsp<br>Bug No Samyak31 : "+ Samyak31);
				}

System.out.println(" count"+count);
for(int j=0;j<count;j++)
{

	String selected=request.getParameter("selected"+j);
//System.out.println("selected"+selected);
	String operation=request.getParameter("operation"+j);
//System.out.println("operation"+operation);
 
	String purchase_receive_id=request.getParameter("purchase_receive_id"+j);
//System.out.println("purchase_receive_id"+purchase_receive_id);
	if("on".equals(selected))
	{
		selected="yes";

		int Receive_id=0;
		int r_id=0;
		if(operation.equals("purchase"))
		{
	String splQuery="select Receive_id from Receive where Receive_Date between ? and ? and company_id ="+company_id+" and	Receive_FromId like "+company_id+" and Purchase=1 and Receive_Sell=0 and StockTransfer_Type=4 and	 SalesPerson_Id<>-1 and Consignment_ReceiveId<>0 and Active=1 and consignment_receiveid="+purchase_receive_id;
		pstmt_g = cong.prepareStatement(splQuery);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,""+D2);
		rs_g = pstmt_g.executeQuery();
		while(rs_g.next())
		{
			Receive_id=rs_g.getInt("Receive_id");
			r_id = Receive_id+1;
			String query1="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";
		//out.println("<BR>90" +query);
				pstmt_p = conp.prepareStatement(query1);
				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,"3");		
				pstmt_p.setString(3,""+Receive_id);		
errLine="1021";
				int a67 = pstmt_p.executeUpdate();
				pstmt_p.close();

		// for destination
			query1="Update Voucher set Active=?  where Voucher_type=? and voucher_no=?";
errLine="1033";
		//out.println("<BR>90" +query);
				pstmt_p = conp.prepareStatement(query1);

				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,"3");		
				pstmt_p.setString(3,""+r_id);		
				int a342 = pstmt_p.executeUpdate();
				pstmt_p.close();
	
	// for source
		query1="Update Receive set Active=?  where Receive_Id=?";
errLine="1045";
	//out.println("<BR>611" +query);
				pstmt_p = conp.prepareStatement(query1);

				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,""+Receive_id);		
				int a77 = pstmt_p.executeUpdate();
				pstmt_p.close();


		// for destination
		query1="Update Receive set Active=?  where Receive_Id=?";

				//out.println("<BR>622" +query);
				pstmt_p = conp.prepareStatement(query1);

				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,""+r_id);		
				int a363 = pstmt_p.executeUpdate();
				pstmt_p.close();
		
	
	//Start : Code to delete the entries in the Receive_Transaction
		query1="Update Receive_Transaction set Active=?  where Receive_Id=?";

				pstmt_p = conp.prepareStatement(query1);

				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,""+Receive_id);		
				int a812 = pstmt_p.executeUpdate();
				pstmt_p.close();

		query1="Update Receive_Transaction set Active=?  where Receive_Id=?";

				pstmt_p = conp.prepareStatement(query1);

				pstmt_p.setBoolean(1,false); 
				pstmt_p.setString(2,""+r_id);		
				int a821 = pstmt_p.executeUpdate();
				pstmt_p.close();
		//End : Code to delete the entries in the Receive_Transaction
		

	}
  }

}
if("yes".equals(selected))
{
//out.print("<br>***************Inside selected");
if(operation.equals("purchase"))
{
	resp_message= resp_message + "<br>Purchase  :-"+A.getNameCondition(cong,"Receive","Receive_no","where receive_id="+purchase_receive_id);

	String query="select rt.consignment_receiveid,r.Receive_Quantity ,Quantity, rt.lot_srno,Lot_id,Location_Id,receivetransaction_id from receive r,receive_transaction rt where r.active=1 and r.receive_id=rt.receive_id and r.receive_id="+purchase_receive_id +"and r.company_id="+company_id; //it gives rows to be canceled
	// out.print("<br>Query"+query);
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();
	errLine="267";
	String receive_quantity="";
	String consignment_receive_id="";
	int sr_no=0;
	String lot_srno="";
	String Available_Quantity="";

	while(rs_g.next())
	{
 		String	purchase_receivetransaction_id=rs_g.getString("receivetransaction_id");
	
		//out.print("<br>purchase_receivetransaction_id"+purchase_receivetransaction_id);
		
		lot_srno=rs_g.getString("lot_srno");
	//	out.print("<br>lot_srno"+lot_srno);
		
		String lot_id=rs_g.getString("Lot_id");
	//	out.print("<br>lot_id"+lot_id);
		
		Available_Quantity=rs_g.getString("Quantity");//Since Available Quantity is set to zero to indicate that it is not used for split but direct stock transfer so instead of updating the values with Available_Quantity we use Quantity also there are no multiple confirmation against a cgt purchase

	//	out.print("<br>Quantity"+Available_Quantity);
		
		String location_id=rs_g.getString("location_id");
	//	out.print("<br>location_id"+location_id);

		consignment_receive_id=rs_g.getString("consignment_receiveid");
		//out.print("<br>consignment_receive_id"+consignment_receive_id);

		String receivetransaction_id=consignment_receive_id;//A.getNameCondition(cong,"Receive_Transaction","ReceiveTransaction_id","  where receive_id="+consignment_receive_id+"and lot_srno="+lot_srno);
		
		//Updating lot location
		query="update lotlocation set  Carats= Carats-"+Available_Quantity+"  where location_id="+location_id+" and company_id="+company_id+"and lot_id="+lot_id;
		//out.print("<br>Query--->"+query);
		pstmt_p = conp.prepareStatement(query);
int a298 = pstmt_p.executeUpdate(); 
		//out.print("<br><fomt color=red >Lotlocation Updated </font>"+a298);
		pstmt_p.close();
		errLine="305";
		query="update receive_transaction set active=0, Available_Quantity="+Available_Quantity+" where receivetransaction_id = "+purchase_receivetransaction_id;
		//out.print("<br>Query "+query);
		 pstmt_p = conp.prepareStatement(query);
 int a311 = pstmt_p.executeUpdate(); 
		// out.print("<br><fomt color=red >Receive Transaction unactive RT entaries Updated </font>"+a311);
		pstmt_p.close();

		
	}//end while of R RT Join

	pstmt_g.close();

	query="update receive set active=0 where receive_id="+purchase_receive_id;
	//out.print("<br>Query "+query);
	 pstmt_p = conp.prepareStatement(query);
int a318 = pstmt_p.executeUpdate(); 
	//out.print("<br><fomt color=red >Receive  unactive R entaries Updated </font>"+a318);
	pstmt_p.close();

	query="update receive set active=0 where Consignment_ReceiveId="+purchase_receive_id+" and Receive_Sell=1 and Purchase=1 and Opening_Stock=0 and R_Return=0 and StockTransfer_Type=7";
	//out.print("<br>Query "+query);
	pstmt_p = conp.prepareStatement(query);
int a319 = pstmt_p.executeUpdate(); 
	//out.print("<br><fomt color=red >Receive  unactive R entaries Updated </font>"+a318);
	pstmt_p.close();
    String ghat_receive_id="";
	query="select rt.receivetransaction_id,r.receive_id from receive r,receive_transaction rt where r.receive_id=rt.receive_id and r.Consignment_ReceiveId="+purchase_receive_id +"and r.company_id="+company_id+" and Receive_Sell=1 and Purchase=1 and Opening_Stock=0 and R_Return=0 and StockTransfer_Type=7"; //it gives rows of ghat to be canceled
	// out.print("<br>Query"+query);
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();
	errLine="336";

	while(rs_g.next())
	{
 		String	ghat_receivetransaction_id=rs_g.getString("receivetransaction_id");
	    ghat_receive_id=rs_g.getString("receive_id");
		query="update receive_transaction set active=0 where receivetransaction_id="+ghat_receivetransaction_id;
		//out.print("<br>Query "+query);
		 pstmt_p = conp.prepareStatement(query);
	 int a311 = pstmt_p.executeUpdate(); 
		// out.print("<br><fomt color=red >Receive Transaction unactive RT entaries Updated </font>"+a311);
		pstmt_p.close();
				
	}//end while of R RT Join
	//out.print("<br>357 ghat_receive_id="+ghat_receive_id);
	String voucher_id=A.getNameCondition(cong,"voucher","voucher_id","  where voucher_no='"+purchase_receive_id+"'");
	//out.print("<br>359 voucher_id"+voucher_id);

	query="update Financial_Transaction set active=0 where voucher_id="+voucher_id;
	//out.print("<br>Query "+query);
	 pstmt_p = conp.prepareStatement(query);
 int a411 = pstmt_p.executeUpdate(); 
	//out.print("<br><fomt color=red >FT unactive  entaries Updated </font>"+a411);
	pstmt_p.close();

	query="update voucher set active=0 where voucher_id="+voucher_id;
	//out.print("<br>Query "+query);
	 pstmt_p = conp.prepareStatement(query);
int a404 = pstmt_p.executeUpdate(); 
	//out.print("<br><fomt color=red >Voucher unactive  entaries Updated </font>"+a404);
	pstmt_p.close();
	errLine="367";
	//For ghat entry update.
	query="update voucher set active=0 where voucher_no='"+ghat_receive_id+"'";
	pstmt_p = conp.prepareStatement(query);
int c404 = pstmt_p.executeUpdate(); 
	pstmt_p.close();
}//end  Confirm if



}//end if selected

}//end for

C.returnConnection(conp);
C.returnConnection(cong);



resp_message=resp_message+"<br> are cancelled";
//out.print("<br>resp_message->"+resp_message);
 response.sendRedirect("../Consignment/cgtConfirmOrPurchase.jsp?command=Default&lots=3&invoicedate="+date+"&Receive_Id=0");
 //response.sendRedirect("CancelVouchers.jsp?command=edit&message="+resp_message+"&hcommand=ReturnConfrimecancelmsg");
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
function closeWindow()
{
	alert("Voucher deleted succesfully");
	window.close();
		
	
}
//-->
</SCRIPT>

<html>
<body OnLoad="closeWindow();">
	
</body>
</html>
<%
}//end command update

%>

<%
}
catch(Exception Samyak80){
	//conp.rollback();
//C.returnConnection(conp);
//C.returnConnection(cong);

 out.print("Exception in file:Master: CancelPurchase.jsp: and errLine ="+errLine+" "+Samyak80);
}

%>




