<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
//Use it only once for saving the old R.Receive_No into the Voucher's Ref No and And then renumbering the R.Receive_No for sale and Purchase and for cgt save the old R.Receive_No into the Receive's CgtRef_No and then renumber the R.Receive_no
try{
String command=request.getParameter("command");
out.print("<br>10 Command"+command);
//String company_id=request.getParameter("company_id");
String company_id= "1";

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
if(command.equals("Nippon05")){


// Code for connection start here
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
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	updateSaleReceiveNo.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


String query="";

/*
//////////////////////////////////////////////////////////////////
/// Start : Financial Local Sale Autonumbering                 ///
//////////////////////////////////////////////////////////////////
//get all the sale type vouchers
*/
query="Select count(*) as counter from Voucher where Voucher_Type=1 and Voucher_Currency=true and company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int count=0;
while(rs_g.next())
	{
	count = rs_g.getInt("counter");
	}
pstmt_g.close();

//out.print("<br>Total Receive_No to Change=" +count);

//Get the Receive_Ids to be changed
String Receive_Id1[] = new String[count];
String Voucher_Id1[] = new String[count];
query="Select Voucher_No, Voucher_Id from Voucher where Voucher_Type=1 and Voucher_Currency=true and company_id="+company_id+" order by Voucher_Date, Voucher_Id"; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int c=0;
while(rs_g.next())
	{
		Receive_Id1[c] = rs_g.getString("Voucher_No");
		Voucher_Id1[c] = rs_g.getString("Voucher_Id");
		c++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Ids got =" +c);

//getting all the Receive_no for the given Receive_Ids
String Receive_No1[] = new String[count];
c=0;
for(int i=0; i<count; i++)
{
	query="Select Receive_No from Receive where  company_id="+company_id+" and Receive_Id="+Receive_Id1[i]; 
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		Receive_No1[c] = rs_g.getString("Receive_No");
		c++;
	}
	pstmt_g.close();
}
//out.print("<br>Total Receive_Nos got =" +c);


//Setting current Receive_No as Ref_no in vouchers
int refUpdated1=0;
for(int i=0; i<count; i++)
{
	
	query="Update Voucher set Ref_No='"+Receive_No1[i]+"' where company_id="+company_id+" and Voucher_Id="+Voucher_Id1[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated1 += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of Ref_No updated="+refUpdated1);


//Renumbering the sale Receive number order with ordering done on Voucher_Date
int receiveNoUpdated1 =0;
String newReceive_No1 = "S-";
for(int i=0; i<count; i++)
{
	String	tempReceive_No1=newReceive_No1+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No1+"' where Receive_Id="+Receive_Id1[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated1 += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No updated="+receiveNoUpdated1);
out.print("<br>End of Local Sale");
//out.print("<br><b>End of task</b>");
//out.print("<br><b>End of local sale</b>");
out.print("<br> line no. 125 <b>********************</b>");

//////////////////////////////////////////////////////////////////
///		End : Financial Local Sale Autonumbering               ///
//////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////
/// Start : Financial Export Sale Autonumbering                 ///
//////////////////////////////////////////////////////////////////
//get all the sale type vouchers
// sale for dollar currency

//String query1="";
int sale_dollar_count=0;
int sale_dollar_count_c=0;

out.print("<br> line no. 142 <b>Start of dollar sale </b>");
query="Select count(*) as counter from Voucher where Voucher_Type=1 and Voucher_Currency=false and company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 sale_dollar_count=0;
while(rs_g.next())
	{sale_dollar_count = rs_g.getInt("counter");}
pstmt_g.close();
//out.print("<br>Total Receive_No to Change=" +sale_dollar_count);

//Get the Receive_Ids to be changed
String Receive_Id2[] = new String[sale_dollar_count];
String Voucher_Id2[] = new String[sale_dollar_count];
query="Select Voucher_No, Voucher_Id from Voucher where Voucher_Type=1 and Voucher_Currency=false and company_id="+company_id+" order by Voucher_Date, Voucher_Id"; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 sale_dollar_count_c=0;
while(rs_g.next())
	{
		Receive_Id2[sale_dollar_count_c] = rs_g.getString("Voucher_No");
		Voucher_Id2[sale_dollar_count_c] = rs_g.getString("Voucher_Id");
		sale_dollar_count_c++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Ids got =" +sale_dollar_count_c);

//getting all the Receive_no for the given Receive_Ids
String Receive_No2[] = new String[sale_dollar_count];
sale_dollar_count_c=0;
for(int i=0; i<sale_dollar_count; i++)
{
	query="Select Receive_No from Receive where  company_id="+company_id+" and Receive_Id="+Receive_Id2[i]; 
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		Receive_No2[sale_dollar_count_c] = rs_g.getString("Receive_No");
		sale_dollar_count_c++;
	}
	pstmt_g.close();
}
//out.print("<br>Total Receive_Nos got =" +sale_dollar_count_c);


//Setting current Receive_No as Ref_no in vouchers
int refUpdated2=0;
for(int i=0; i<sale_dollar_count; i++)
{
	
	query="Update Voucher set Ref_No='"+Receive_No2[i]+"' where company_id="+company_id+" and Voucher_Id="+Voucher_Id2[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated2 += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of Ref_No updated="+refUpdated2);


//Renumbering the sale Receive number order with ordering done on Voucher_Date
int receiveNoUpdated2 =0;
String newReceive_No2 = "SE-";
for(int i=0; i<sale_dollar_count; i++)
{
	String tempReceive_No2=newReceive_No2+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No2+"' where Receive_Id="+Receive_Id2[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated2 += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No updated="+receiveNoUpdated2);

out.print("<br><b>End of task</b>");
out.print("<br> line no .220 <b>End of Sale dollar</b>");



//////////////////////////////////////////////////////////////////
///		End : Financial Dollar Sale Autonumbering               ///
//////////////////////////////////////////////////////////////////


///Consignment Sale   ////

//out.print("<br> line no. 230 <b>Start of Consignment Sale task</b>");
int consignment_sale_count=0;
int consignment_sale_count_c=0;
query="Select count(*) as Voucher_count from Receive where Purchase=0 and Receive_Sell=0 and Return=0 and  company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 consignment_sale_count=0;
while(rs_g.next())
	{consignment_sale_count = rs_g.getInt("Voucher_count");}
pstmt_g.close();

//out.print("<br> line no. 241 Total Receive_No to Change=" +consignment_sale_count);

String Receive_Id[] = new String[consignment_sale_count];
//String Voucher_Id[] = new String[count];
String Receive_No[] = new String[consignment_sale_count];

query="Select Receive_No, Receive_Id from Receive where Purchase=0 and Receive_Sell=0 and Return=0 and  company_id="+company_id+" order by Receive_Date, Receive_Id"; 

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
consignment_sale_count_c=0;
while(rs_g.next())
	{
		Receive_Id[consignment_sale_count_c] = rs_g.getString("Receive_Id");
		
		Receive_No[consignment_sale_count_c] = rs_g.getString("Receive_No");
	    //out.print("<br> line no. 259 Receive_no"+Receive_No[consignment_sale_count_c]);
		consignment_sale_count_c++;
	//out.print("<br>line no. 261 Sale Count c value "+consignment_sale_count_c);
	}
//out.print("<br>line no. 263  Sale Count c value "+consignment_sale_count_c);
pstmt_g.close();
//out.print("<br> line no 265 Total Receive_Nos got =" +consignment_sale_count_c);

//out.print("<br>Total Receive_Ids got =" +c);
int refUpdated_consignment_sale=0;


//out.print("<br> line no. 266  consignment_sale_count"+consignment_sale_count);

for(int i=0; i<consignment_sale_count; i++)
{
	
	query="Update Receive set CgtRef_No='"+Receive_No[i]+"' where company_id="+company_id+" and Receive_Id="+Receive_Id[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated_consignment_sale += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>line no. 282 No. of CgtRef_No updated="+refUpdated_consignment_sale);


int receiveNoUpdated_consignment_sale =0;
String newReceive_No_consignment_sale = "CS-";
for(int i=0; i<consignment_sale_count; i++)
{
	String	tempReceive_No_consignment_sale=newReceive_No_consignment_sale+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No_consignment_sale+"' where Receive_Id="+Receive_Id[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated_consignment_sale += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No for Consignment Sale updated="+receiveNoUpdated_consignment_sale);

out.print("<br><b>End of task</b>");
out.print("<br> line no. 290 <b>end  of Consignment Sale task</b>");

///end of consignment sale

///Start  Consignment Sale Return




//out.print("<br> line no. 299 <b>Start of Consignment Sale return task</b>");

query="Select count(*) as Voucher_count from Receive where Purchase=0 and Receive_Sell=1and Return=1 and  company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 //out.print("<br>286Query "+query);
 int sale_return_count=0;
while(rs_g.next())
	{sale_return_count = rs_g.getInt("Voucher_count");
   out.print("<br>292 SaleCount"+sale_return_count);
}
pstmt_g.close();

//out.print("<br>Total Receive_No to Change=" +sale_return_count);

String Receive_Id3[] = new String[sale_return_count];
//String Voucher_Id[] = new String[count];
String Receive_No3[] = new String[sale_return_count];

query="Select Receive_No, Receive_Id from Receive where Purchase=0 and Receive_Sell=1 and Return=1 and  company_id="+company_id+" order by Receive_Date, Receive_Id"; 

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int c1=0;
while(rs_g.next())
	{
		Receive_Id3[c1] = rs_g.getString("Receive_Id");
		Receive_No3[c1] = rs_g.getString("Receive_No");
		c1++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Nos got =" +c1);

//out.print("<br>Total Receive_Ids got =" +c);
int refUpdated3=0;
for(int i=0; i<sale_return_count; i++)
{
	
	query="Update Receive set CgtRef_No='"+Receive_No3[i]+"' where company_id="+company_id+" and Receive_Id="+Receive_Id3[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated3 += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of CgtRef_No updated="+refUpdated3);


int receiveNoUpdated3 =0;
String newReceive_No3 = "CSR-";
for(int i=0; i<sale_return_count; i++)
{
	String	tempReceive_No3=newReceive_No3+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No3+"' where Receive_Id="+Receive_Id3[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated3 += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No updated="+receiveNoUpdated3);



out.print("<br> line no. 363 <b>end of  of Consignment Sale   Return task</b>");



///end of consignment sell return


//code for local purchase


//out.print("<br> line no. 373 <b>Start of Local Purchase task</b>");


query="Select count(*) as counter from Voucher where Voucher_Type=2 and Voucher_Currency=true and company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int purchase_count=0;
while(rs_g.next())
	{
	purchase_count = rs_g.getInt("counter");
	}
pstmt_g.close();

//out.print("<br>Total Receive_No to Change=" +purchase_count);

//Get the Receive_Ids to be changed
String Receive_Id_purchase[] = new String[purchase_count];
String Voucher_Id_purchase[] = new String[purchase_count];
query="Select Voucher_No, Voucher_Id from Voucher where Voucher_Type=2 and Voucher_Currency=true and company_id="+company_id+" order by Voucher_Date, Voucher_Id"; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int purchase_c=0;
while(rs_g.next())
	{
		Receive_Id_purchase[purchase_c] = rs_g.getString("Voucher_No");
		Voucher_Id_purchase[purchase_c] = rs_g.getString("Voucher_Id");
		purchase_c++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Ids got =" +purchase_c);

//getting all the Receive_no for the given Receive_Ids
String Receive_No_purchase[] = new String[purchase_count];
purchase_c=0;
for(int i=0; i<purchase_count; i++)
{
	query="Select Receive_No from Receive where  company_id="+company_id+" and Receive_Id="+Receive_Id_purchase[i]; 
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		Receive_No_purchase[purchase_c] = rs_g.getString("Receive_No");
		purchase_c++;
	}
	pstmt_g.close();
}
//out.print("<br>Total Receive_Nos got =" +purchase_c);


//Setting current Receive_No as Ref_no in vouchers
int refUpdated_purchase=0;
for(int i=0; i<purchase_count; i++)
{
	
	query="Update Voucher set Ref_No='"+Receive_No_purchase[i]+"' where company_id="+company_id+" and Voucher_Id="+Voucher_Id_purchase[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated_purchase += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of Ref_No updated="+refUpdated_purchase);


//Renumbering the sale Receive number order with ordering done on Voucher_Date
int receiveNoUpdated_purchase =0;
String newReceive_No_purchase = "P-";
for(int i=0; i<purchase_count; i++)
{
	String	tempReceive_No_purchase=newReceive_No_purchase+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No_purchase+"' where Receive_Id="+Receive_Id_purchase[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated_purchase += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No updated="+receiveNoUpdated_purchase);

out.print("<br><b>End of task</b>");
out.print("<br> line no. 457 <b>End of Local Purchase task</b>");



///end of local purchase

// start of dollar purchase


//out.print("<br> line no. 373 <b>Start of Dollar Purchase task</b>");


query="Select count(*) as counter from Voucher where Voucher_Type=2 and Voucher_Currency=false and company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int dollar_purchase_count=0;
while(rs_g.next())
	{
	dollar_purchase_count = rs_g.getInt("counter");
	}
pstmt_g.close();

//out.print("<br>Total Receive_No to Change=" +dollar_purchase_count);

//Get the Receive_Ids to be changed
String Receive_Id_purchase_dollar[] = new String[dollar_purchase_count];
String Voucher_Id_purchase_dollar[] = new String[dollar_purchase_count];
query="Select Voucher_No, Voucher_Id from Voucher where Voucher_Type=2 and Voucher_Currency=false and company_id="+company_id+" order by Voucher_Date, Voucher_Id"; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int purchase_c_dollar=0;
while(rs_g.next())
	{
		Receive_Id_purchase_dollar[purchase_c_dollar] = rs_g.getString("Voucher_No");
		Voucher_Id_purchase_dollar[purchase_c_dollar] = rs_g.getString("Voucher_Id");
		purchase_c_dollar++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Ids got =" +purchase_c_dollar);

//getting all the Receive_no for the given Receive_Ids
String Receive_No_purchase_dollar[] = new String[dollar_purchase_count];
purchase_c_dollar=0;
for(int i=0; i<dollar_purchase_count; i++)
{
	query="Select Receive_No from Receive where  company_id="+company_id+" and Receive_Id="+Receive_Id_purchase_dollar[i]; 
	pstmt_g = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		Receive_No_purchase_dollar[purchase_c_dollar] = rs_g.getString("Receive_No");
		purchase_c_dollar++;
	}
	pstmt_g.close();
}
//out.print("<br>Total Receive_Nos got =" +purchase_c_dollar);


//Setting current Receive_No as Ref_no in vouchers
int refUpdated_purchase_dollar=0;
for(int i=0; i<dollar_purchase_count; i++)
{
	
	query="Update Voucher set Ref_No='"+Receive_No_purchase[i]+"' where company_id="+company_id+" and Voucher_Id="+Voucher_Id_purchase[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated_purchase_dollar += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of Ref_No updated="+refUpdated_purchase_dollar);


//Renumbering the sale Receive number order with ordering done on Voucher_Date
receiveNoUpdated_purchase =0;
newReceive_No_purchase = "PI-";
for(int i=0; i<dollar_purchase_count; i++)
{
	String	tempReceive_No_purchase=newReceive_No_purchase+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No_purchase+"' where Receive_Id="+Receive_Id_purchase[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated_purchase += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No updated="+receiveNoUpdated_purchase);

out.print("<br><b>End of task</b>");
out.print("<br> line no. 457 <b>End of Local Purchase task</b>");



/// end of dollar purchase



//start of consignment purchase


//out.print("<br> line no. 466 <b>Start of Consignment  Purchase task</b>");
int consignment_purchase_count=0;
int conginment_purchase_c=0;
query="Select count(*) as Consignment_Purchase_count from Receive where Purchase=0 and Receive_Sell=1 and Return=0 and  company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 consignment_purchase_count=0;
while(rs_g.next())
	{consignment_purchase_count = rs_g.getInt("Consignment_Purchase_count");
	}
pstmt_g.close();

//out.print("<br>Total Receive_No to Change=" +consignment_purchase_count);

String Receive_Id_consignmet_purchase[] = new String[consignment_purchase_count];
String Receive_No_consignment_purchase[] = new String[consignment_purchase_count];

query="Select Receive_No, Receive_Id from Receive where Purchase=0 and Receive_Sell=1 and Return=0 and  company_id="+company_id+" order by Receive_Date, Receive_Id"; 

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
conginment_purchase_c=0;
while(rs_g.next())
	{
		Receive_Id_consignmet_purchase[conginment_purchase_c] = rs_g.getString("Receive_Id");
		Receive_No_consignment_purchase[conginment_purchase_c] = rs_g.getString("Receive_No");
		conginment_purchase_c++;
	}
pstmt_g.close();
//out.print("<br>Total Receive_Nos got =" +conginment_purchase_c);

//out.print("<br>Total Receive_Ids got =" +conginment_purchase_c);
int refUpdated_consignment_purchase=0;
for(int i=0; i<consignment_purchase_count; i++)
{
	
	query="Update Receive set CgtRef_No='"+Receive_No_consignment_purchase[i]+"' where company_id="+company_id+" and Receive_Id="+Receive_Id_consignmet_purchase[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated_consignment_purchase += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>line no. 520 No. of CgtRef_No updated="+refUpdated_consignment_purchase);


int receiveNoUpdated_consignment_purchase =0;
String newReceive_No_consignment_purchase = "CP-";
for(int i=0; i<consignment_purchase_count; i++)
{
	String	tempReceive_No_consignment_purchase=newReceive_No_consignment_purchase+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No_consignment_purchase+"' where Receive_Id="+Receive_Id_consignmet_purchase[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated_consignment_purchase += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No for Consignment Sale updated="+receiveNoUpdated_consignment_purchase);

out.print("<br><b>End of task</b>");
out.print("<br> line no. 530 <b>End  of Consignment  Purchase task</b>");


///end of consignment purchase






/// start of consignment purchase return
//out.print("<br> line no. 552 <b>Start   of Consignment  Purchase Return task</b>");


int consignment_purchase_return_count=0;
int conginment_purchase_return_c=0;
query="Select count(*) as Consignment_Purchase_return_count from Receive where Purchase=0 and Receive_Sell=0 and Return=1 and  company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
 consignment_purchase_return_count=0;
while(rs_g.next())
	{consignment_purchase_return_count = rs_g.getInt("Consignment_Purchase_return_count");
	}
pstmt_g.close();

//out.print("<br>line no. 566 Total Receive_No to Change=" +consignment_purchase_return_count);

String Receive_Id_consignmet_purchase_return[] = new String[consignment_purchase_return_count];

String Receive_No_consignment_purchase_return[] = new String[consignment_purchase_return_count];

query="Select Receive_No, Receive_Id from Receive where Purchase=0 and Receive_Sell=0 and Return=1 and  company_id="+company_id+" order by Receive_Date, Receive_Id"; 

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
conginment_purchase_return_c=0;
while(rs_g.next())
	{
		Receive_Id_consignmet_purchase_return[conginment_purchase_return_c] = rs_g.getString("Receive_Id");
		Receive_No_consignment_purchase_return[conginment_purchase_return_c] = rs_g.getString("Receive_No");
		conginment_purchase_return_c++;
	}
pstmt_g.close();
//out.print("<br>line no. 584 Total Receive_Nos got =" +conginment_purchase_return_c);

//out.print("<br>Total Receive_Ids got =" +conginment_purchase_c);
int refUpdated_consignment_purchase_return=0;
for(int i=0; i<consignment_purchase_return_count; i++)
{
	
	query="Update Receive set CgtRef_No='"+Receive_No_consignment_purchase_return[i]+"' where company_id="+company_id+" and Receive_Id="+Receive_Id_consignmet_purchase_return[i]; 

	pstmt_g = cong.prepareStatement(query);
	refUpdated_consignment_purchase_return += pstmt_g.executeUpdate();	
	pstmt_g.close();
}
//out.print("<br>No. of CgtRef_No updated="+refUpdated_consignment_purchase_return);


int receiveNoUpdated_consignment_purchase_return =0;
String newReceive_No_consignment_purchase_return = "CPR-";
for(int i=0; i<consignment_purchase_return_count; i++)
{
	String	tempReceive_No_consignment_purchase_return=newReceive_No_consignment_purchase_return+(i+1);
	query="Update Receive set Receive_No='"+tempReceive_No_consignment_purchase_return+"' where Receive_Id="+Receive_Id_consignmet_purchase_return[i]; 


	pstmt_g = cong.prepareStatement(query);
	receiveNoUpdated_consignment_purchase_return += pstmt_g.executeUpdate();
	pstmt_g.close();
	
}
//out.print("<br>No. of Receive_No for Consignment Sale updated="+receiveNoUpdated_consignment_purchase_return);

out.print("<br><b>End of task</b>");

out.print("<br> line no. 606 <b>End   of Consignment  Purchase Return task</b>");

//// end of consignment purchase return

out.print("<br><font color=red size=5>System run complete</font>");


C.returnConnection(cong);
C.returnConnection(conp);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : updateSaleReceiveNo.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
