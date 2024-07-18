<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String errLine="7";
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
ResultSet rs= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
try	{
	conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : UpdateVoucher.jsp<br>Bug No Samyak31 : "+ e31);}

	String query="";
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

String company_name= A.getName(conp,"companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String command=request.getParameter("command");
if("Update".equals(command))
{
try{ 
	conp.setAutoCommit(false);

String type= ""+request.getParameter("voucher_type");


int counter= Integer.parseInt(request.getParameter("counter"));
errLine="43";
String voucher_id[]= new String[counter];
boolean cancel[]= new boolean[counter];
boolean oldactive[]= new boolean[counter];

for(int i=0; i<counter; i++)
{
voucher_id[i]=""+request.getParameter("voucher_id"+i);
String temp=""+request.getParameter("cancel"+i);
cancel[i]=true;
if("yes".equals(temp))
	{cancel[i]=false;}
oldactive[i]=false;
String tempr=""+request.getParameter("old"+i);
if("active".equals(tempr))
	{oldactive[i]=true;}
}

if("6".equals(type))
{
for(int i=0; i<counter; i++)
	{
if(!cancel[i])
		{

query="Select * from PN where Loan_VoucherId=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
int m=0;
int status=0;
while(rs_g.next())
		{
	status=rs_g.getInt("PN_Status");
	m++;}
pstmt_p.close();
 
 if((m > 0)&&(status==0))
{
query="Update  PN set PN_Loan=0, Loan_LedgerId=?, Loan_VoucherId=? where  PN_Status=0 and Loan_VoucherId=?"; 
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,"0");		
pstmt_p.setString(2,"0");		
pstmt_p.setString(3,voucher_id[i]);		
int a207 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Update Voucher set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);	
errLine="97";
int a67 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a77 = pstmt_p.executeUpdate();
pstmt_p.close();

}//else
else if(m==0)
{


	query="Update Voucher set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a67 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);	
errLine="133";
int a77 = pstmt_p.executeUpdate();
pstmt_p.close();

}//else
		}//cancel

	}//for

}//receipt
else{
for(int i=0; i<counter; i++)
{

query="Update Voucher set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a67 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a77 = pstmt_p.executeUpdate();
pstmt_p.close();


query="Update Payment_Details set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);	
errLine="175";
int a99 = pstmt_p.executeUpdate();
pstmt_p.close();


}//for
int m=0;
int rv=0;
for(int i=0; i<counter; i++)
{
query="Select * from Financial_Transaction where Voucher_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{m++;}
pstmt_p.close();


query="Select * from Voucher where Referance_VoucherId=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{rv++;}
pstmt_p.close();
}//for

int rv_count=rv;
String refvoucher_id[]=new String[rv_count]; 
boolean rv_cancel[]=new boolean[rv_count];
int count =m;
String for_head[]=new String[count]; 
String for_headid[]=new String[count]; 
String ledger_id[]=new String[count]; 
String ledger_type[]=new String[count]; 
String voucherid[]=new String[count]; 
boolean mode[]=new boolean[count]; 
double local[]=new double[count];
double dollar[]=new double[count];
//out.print("count ="+m);

m=0;
rv=0;
for(int i=0; i<counter; i++)
{
query="Select * from Financial_Transaction where Voucher_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{
	voucherid[m]=rs_g.getString("Voucher_id");
	for_head[m]=rs_g.getString("For_Head");
	for_headid[m]=rs_g.getString("For_Headid");
	mode[m]=rs_g.getBoolean("Transaction_Type");
	local[m]= str.mathformat(rs_g.getDouble("Local_Amount"),d);
	dollar[m]= str.mathformat(rs_g.getDouble("Dollar_Amount"),2);
	ledger_id[m]=rs_g.getString("ledger_id");
	ledger_type[m]=A.getNameCondition(conp,"Ledger", "Ledger_type", "where Ledger_Id="+ledger_id[m]+"");
	m++;}
pstmt_p.close();

query="Select * from Voucher where Referance_VoucherId=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{
refvoucher_id[rv]=rs_g.getString("Voucher_id");
rv_cancel[rv]=cancel[i];
	rv++;}
pstmt_p.close();
}//for

for(int i=0; i<rv_count; i++)
{

query="Update Voucher set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,rv_cancel[i]); 
pstmt_p.setString(2,refvoucher_id[i]);	
errLine="260";
int a172 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);

pstmt_p.setBoolean(1,rv_cancel[i]); 
pstmt_p.setString(2,refvoucher_id[i]);	
errLine="271";
int a182 = pstmt_p.executeUpdate();
pstmt_p.close();


}//for


String pn_accountid= A.getNameCondition(conp,"Master_Account","account_id","Where Account_Name='PN Account' and Company_id="+company_id+" ");
if("4".equals(type))
{
for(int i=0; i<counter; i++)
	{
if(!cancel[i])
		{

query="Update  PN set PN_Status=0, Voucher_id=? where Voucher_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,"0");		
pstmt_p.setString(2,voucher_id[i]);	
errLine="291";
int a207 = pstmt_p.executeUpdate();
pstmt_p.close();
		}

	}
}//contra

if("7".equals(type))
{
for(int i=0; i<counter; i++)
{
if((oldactive[i])&&(!cancel[i]))
	{

m=0;
while(m<count)
	{
if((voucher_id[i].equals(voucherid[m]))&&("14".equals(for_head[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>316 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[m]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");



advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

if ("1".equals(ledger_type[m]))
	{
	if(mode[m])
		// sign changed of operation on 24/05/04 by Samyak113 after dissussion with  Samyak114
	//Start Samyak113 
	{
	advsale_localbalance=advsale_localbalance - local[m];
	advsale_dollarbalance=advsale_dollarbalance - dollar[m];
	}
	else
	{
	advsale_localbalance= advsale_localbalance + local[m];
	advsale_dollarbalance=advsale_dollarbalance + dollar[m];
	}
	//End Samyak113
}//if 


if ("2".equals(ledger_type[m]))
	{
	if(mode[m])
	{
	advpurchase_localbalance = advpurchase_localbalance + local[m];
	advpurchase_dollarbalance = advpurchase_dollarbalance + dollar[m];
	}
	else
	{
 	advpurchase_localbalance = advpurchase_localbalance - local[m];
 	advpurchase_dollarbalance = advpurchase_dollarbalance - dollar[m];
	}
	}//if 

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setString (5,for_headid[m]);
errLine="378";
int a205 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a205 " +a205+"</font>");
pstmt_p.close();

		}//if major

	
if((voucher_id[i].equals(voucherid[m]))&&("1".equals(for_head[m])))

		{
query="update PN set Active =? where RefVoucher_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);	
errLine="393";
int a218 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a218 " +a218+"</font>");
pstmt_p.close();

		}
m++;
	}//while
}//if oldactive


else if((!oldactive[i])&&(cancel[i]))
	{

m=0;
while(m<count)
	{
if((voucher_id[i].equals(voucherid[m]))&&("14".equals(for_head[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>412 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[m]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;
double advpurchase_localbalance=0;
double advpurchase_dollarbalance=0;
double advpn_localbalance=0;
double advpn_dollarbalance=0;

while(rs_g.next()) 	
{
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");



advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

if ("1".equals(ledger_type[m]))
	{
	if(mode[m])
	{
	advsale_localbalance=advsale_localbalance - local[m];
	advsale_dollarbalance=advsale_dollarbalance - dollar[m];
	}
	else
	{
	advsale_localbalance= advsale_localbalance + local[m];
	advsale_dollarbalance=advsale_dollarbalance + dollar[m];
	}
}//if 


if ("2".equals(ledger_type[m]))
	{
	if(mode[m])
	{
	advpurchase_localbalance = advpurchase_localbalance - local[m];
	advpurchase_dollarbalance = advpurchase_dollarbalance - dollar[m];
	}
	else
	{
 	advpurchase_localbalance = advpurchase_localbalance + local[m];
 	advpurchase_dollarbalance = advpurchase_dollarbalance + dollar[m];
	}
	}//if 

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setDouble (3,advpurchase_localbalance);
pstmt_p.setDouble (4,advpurchase_dollarbalance);
pstmt_p.setString (5,for_headid[m]);
errLine="476";
int a305 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a305 " +a305+"</font>");
pstmt_p.close();

		}//if major

	
if((voucher_id[i].equals(voucherid[m]))&&("1".equals(for_head[m])))

		{
String temp="";
 temp=A.getNameCondition(conp,"PN","To_FromId","Where RefVoucher_id="+voucher_id+" and PN_Loan=0 and PN_Status=0 and Voucher_Id=0"  );
 if("".equals(temp))
			{
	 query="update PN set PN_Status=?,Voucher_Id =? where Voucher_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,false); 
pstmt_p.setString(2,"0"); 
pstmt_p.setString(3,voucher_id[i]);	
errLine="496";
int a319 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master ASDDG	 Party Updated  Successfully:a319 " +a319+"</font>");
pstmt_p.close();

			}
else{
query="update PN set Active =? where RefVoucher_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);	
errLine="507";
int a319 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master ASDDG	 Party Updated  Successfully:a319 " +a319+"</font>");
pstmt_p.close();
}
		}//if
m++;
	}//while
}
}//for
/*
for(int i=0; i<counter; i++)
{
query="Update Payment_Details set Active=?  where Voucher_Id=?";
//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,false); 
pstmt_p.setString(2,voucher_id[i]);		
int a419 = pstmt_p.executeUpdate();
pstmt_p.close();

query="Select * from Payment_Details where voucher_id="+voucher_id[i]+" and Active=0";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{
String recd_id=rs_g.getString("For_HeadId");
String recquery="Update Receive set Proactive=?  where Receive_Id=?";
//out.println("<BR>90" +query);
pstmt_g = conp.prepareStatement(recquery);
pstmt_g.setBoolean(1,false); 
pstmt_g.setString(2,recd_id);		
int a432 = pstmt_g.executeUpdate();
pstmt_g.close();
}
pstmt_p.close();
}*/


	}//if 7 Journal Voucher

//out.print("<br>217");

int pd=0;
for(int i=0; i<counter; i++)
{
query="Select * from Payment_Details where Voucher_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{pd++;}
pstmt_p.close();
}
int pd_count=pd;
String pdfor_head[]=new String[pd_count]; 
String pdfor_headid[]=new String[pd_count]; 
String pdvoucher_id[]=new String[pd_count]; 
boolean pdmode[]=new boolean[pd_count]; 
double pdlocal[]=new double[pd_count];
double pddollar[]=new double[pd_count];
int fb_id[]=new int[pd_count];


 pd=0;
for(int i=0; i<counter; i++)
{
query="Select * from Payment_Details where Voucher_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,voucher_id[i]);		
rs_g = pstmt_p.executeQuery();	
while(rs_g.next())
		{
	pdvoucher_id[pd]=rs_g.getString("Voucher_id");
	pdfor_head[pd]=rs_g.getString("For_Head");
	pdfor_headid[pd]=rs_g.getString("For_Headid");
	pdmode[pd]=rs_g.getBoolean("Transaction_Type");
	pdlocal[pd]= str.mathformat(rs_g.getDouble("Local_Amount"),d);
	pddollar[pd]= str.mathformat(rs_g.getDouble("Dollar_Amount"),2);
	fb_id[pd]=rs_g.getInt("FB_Id");

	pd++;}
pstmt_p.close();
}

//out.print("<br>440");

if(("8".equals(type))||("9".equals(type))|| ("12".equals(type))||("13".equals(type)))
	{

 

for(int i=0; i<counter; i++)
{
//out.print("<br>oldactive[i]="+oldactive[i]);

if(("8".equals(type))||("12".equals(type)))
{
if((oldactive[i])&&(!cancel[i]))
	{
String party_id= A.getNameCondition(conp,"Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id[i]+" and transaction_type=1" );
//out.print("<br>455party_id="+party_id);

m=0;
while(m<pd_count)
	{
if((voucher_id[i].equals(pdvoucher_id[m]))&&("9".equals(pdfor_head[m]))&&("0".equals(pdfor_headid[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>609 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+party_id); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;

while(rs_g.next()) 	
{
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
}
pstmt_p.close();

advsale_localbalance = advsale_localbalance - pdlocal[m];
advsale_dollarbalance =advsale_dollarbalance -
pddollar[m];
query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+advsale_localbalance);
pstmt_p.setString (2,""+advsale_dollarbalance);
pstmt_p.setString (3,party_id);
errLine="640";
int a205 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a205 " +a205+"</font>");
pstmt_p.close();



		}//if major

	
m++;
	}//while
}//if oldactive


else if((!oldactive[i])&&(cancel[i]))
	{
String party_id= A.getNameCondition(conp,"Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id[i]+" and transaction_type=1" );
//out.print("<br>502party_id="+party_id);

m=0;
while(m<count)
	{
if((voucher_id[i].equals(pdvoucher_id[m]))&&("9".equals(pdfor_head[m]))&&("0".equals(pdfor_headid[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>656 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+party_id); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;

while(rs_g.next()) 	
{
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
}
pstmt_p.close();

advsale_localbalance = advsale_localbalance + pdlocal[m];
advsale_dollarbalance =advsale_dollarbalance +
pddollar[m];
query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setString (3,party_id);
errLine="690";
int a305 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a305 " +a305+"</font>");
pstmt_p.close();
		}//if major

	
m++;
	}//while
}

}//if(("8".equals(type))||("12".equals(type)))

else{

if((oldactive[i])&&(!cancel[i]))
	{
String party_id= A.getNameCondition(conp,"Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id[i]+" and transaction_type=0" );
//out.print("<br>455party_id="+party_id);

m=0;
while(m<pd_count)
	{
if((voucher_id[i].equals(pdvoucher_id[m]))&&("10".equals(pdfor_head[m]))&&("0".equals(pdfor_headid[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>705 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+party_id); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;

while(rs_g.next()) 	
{
advsale_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
}
pstmt_p.close();

advsale_localbalance = advsale_localbalance - pdlocal[m];
advsale_dollarbalance =advsale_dollarbalance -
pddollar[m];
query="Update Master_CompanyParty set Purchase_AdvanceLocal=?, Purchase_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble (1,advsale_localbalance);
pstmt_p.setDouble (2,advsale_dollarbalance);
pstmt_p.setString (3,party_id);
errLine="740";
int a205 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a205 " +a205+"</font>");
pstmt_p.close();

		}//if major

	
m++;
	}//while



}//if oldactive


else if((!oldactive[i])&&(cancel[i]))
	{
String party_id= A.getNameCondition(conp,"Financial_Transaction","For_HeadId","Where Voucher_id="+voucher_id[i]+" and transaction_type=0" );
//out.print("<br>502party_id="+party_id);

m=0;
while(m<count)
	{
if((voucher_id[i].equals(pdvoucher_id[m]))&&("10".equals(pdfor_head[m]))&&("0".equals(pdfor_headid[m])))
		{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>755 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+party_id); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double advsale_localbalance=0;
double advsale_dollarbalance=0;

while(rs_g.next()) 	
{
advsale_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
}
pstmt_p.close();

advsale_localbalance = advsale_localbalance + pdlocal[m];
advsale_dollarbalance =advsale_dollarbalance +
pddollar[m];
query="Update Master_CompanyParty set Purchase_AdvanceLocal=?, Purchase_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble(1,advsale_localbalance);
pstmt_p.setDouble(2,advsale_dollarbalance);
pstmt_p.setString (3,party_id);
errLine="791";
int a305 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a305 " +a305+"</font>");
pstmt_p.close();
		}//if major

	
m++;
	}//while
}

}//else type= 9 || 13

if(!cancel[i])
	{
query="update PN set Active =? where RefVoucher_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,cancel[i]); 
pstmt_p.setString(2,voucher_id[i]);		
int a648 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a648 " +a648+"</font>");
pstmt_p.close();


m=0;
while(m < pd_count)
	{
	if(pdvoucher_id[m].equals(voucher_id[i]))
		{

	query="Update Receive set Proactive=? where receive_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setBoolean(1,false);
pstmt_p.setString (2,pdfor_headid[m]);
errLine="825";
int a552 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a552" +a552+"</font>");
pstmt_p.close();


	if(fb_id[m]>0)
	{
query="Select * from ForwardBooking where FB_Id="+fb_id[m]+"";

//out.print("<br>146 query" +query);
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double fb_pending=0;
double fb_used=0;

while(rs_g.next()) 	
{
fb_used= rs_g.getDouble("Used_amount");
fb_pending= rs_g.getDouble("Pending_amount");
//out.print("<br> 818 "+m+" Pending amount database "+fb_pending);

//out.print("<br> 820 "+m+" Used amount database "+fb_used);
}
pstmt_p.close();

fb_pending +=pddollar[m];
//out.print("<br> 825 "+m+" Pending amount calculated "+fb_pending);

fb_used =fb_used - pddollar[m];
//out.print("<br> 828 "+m+" Used amount calculated "+fb_used);

query="Update ForwardBooking set Pending_Amount=? ,Used_Amount=?, FB_Flag=0 where FB_Id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setDouble(1,fb_pending);		
pstmt_p.setDouble(2,fb_used);		
pstmt_p.setString(3,""+fb_id[m]);		
errLine="863";
int a729 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a729" +a729+"</font>");
pstmt_p.close();

	}
		}
m++;
	}//while


	}//(!cancel[i])
}//for




/*for(int i=0; i<pd_count; i++)
		{


		}*/


	}//if type==8 sales receipt

//out.print("<br>675");
%>
<!-- <script language="JavaScript">
function f1()
{
alert("Data Sucessfully Updated ");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML> -->
<%
}//else


conp.commit();

C.returnConnection(conp);

response.sendRedirect("CancelVouchers.jsp?command=edit&&message=Data Sucessfully Updated");


}
catch(Exception Samyak444){ 
	conp.rollback();
C.returnConnection(conp);

out.println("<br><font color=red> errLine="+errLine+" FileName : CancelVoucher1.jsp Bug No Samyak444 : "+ Samyak444);
}
}//if Update
%>










