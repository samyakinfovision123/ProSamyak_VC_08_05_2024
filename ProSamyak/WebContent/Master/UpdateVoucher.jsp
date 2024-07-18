<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;

	String query="";
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
int dd1=D.getDate();
int mm1=D.getMonth()+1;
int yy1=D.getYear()+1900;

int dd2=D.getDate();
int mm2=D.getMonth()+1;
int yy2=D.getYear()+1900;
//String company_name= A.getName("companyparty",company_id);
//String local_currency= I.getLocalCurrency(company_id);
String command=request.getParameter("command");
if("Update".equals(command))
{
try{ 

	conp=C.getConnection();
	conp.setAutoCommit(false);
String voucher_no=""+request.getParameter("voucher_no");
String ref_no=""+request.getParameter("ref_no");
String type= ""+request.getParameter("voucher_type");
double total= Double.parseDouble(request.getParameter("credit_total"));
double debit_total= Double.parseDouble(request.getParameter("debit_total"));
//out.println("counter "+counter);
String from_india=request.getParameter("from_india");
query="";
//out.print("<br>type:"+type);
if(total==debit_total)
{
//out.print("<br>11:"+total);
double exchange_rate= Double.parseDouble(request.getParameter("exchange_rate"));
//out.print("<br>12exrate:"+exchange_rate);

String voucher_id=request.getParameter("voucher_id");
int v_old=Integer.parseInt(voucher_id);
int v_id=0;
String noquery="Select * from  Voucher where Company_Id=? and Voucher_No=?";
//out.print("<br>94 query" +query);
pstmt_p = conp.prepareStatement(noquery);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
int no_exist=0;
while(rs_g.next()) 	
{
v_id=rs_g.getInt("voucher_id");
if (rs_g.wasNull())
{v_id=0;}
no_exist++;}
pstmt_p.close();

if((no_exist > 0)&&(v_id != v_old))
{
	C.returnConnection(conp);
	%>

<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>


<%
out.print("<br><center><font class='star1'>Voucher No "+voucher_no+ " already exist.</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}

else
	{



//out.print("<br>voucher_id"+voucher_id);
//out.print("<br>v_id"+v_id);
String datevalue=""+request.getParameter("datevalue");
String currency= request.getParameter("currency");
String description= request.getParameter("description");
//String to_by=""+request.getParameter("to_by");
//out.println("to_by is "+to_by);
int count_actual= Integer.parseInt(request.getParameter("counter"));
int counter=count_actual;
//out.println("79 counter is "+counter);
boolean voucher_currency=false;
double localamt=0;
double dollaramt=0;
//out.println("<br><font color=red>currency</font>:"+currency);
if ("local".equals(currency))
{
localamt=total;
dollaramt= localamt/exchange_rate;
voucher_currency=true;
}
else
{
dollaramt=total;
localamt= dollaramt*exchange_rate;
voucher_currency=false;
}
//out.println("<font color=red>localamt</font>:"+localamt);
//out.println("<font color=red>dollaramt</font>:"+dollaramt);



String srno[]=new String[counter];
String type_toby[]=new String[counter]; 
String account_id[]=new String[counter];
double amount[]=new double[counter];
double local_amount[]=new double[counter];
double dollar_amount[]=new double[counter];
String remarks[]=new String[counter];
String for_head[]=new String[counter];
String for_headid[]=new String[counter];
String ledger_id[]=new String[counter];
String ledger_type[]=new String[counter];

boolean mode[]=new boolean[counter];
String ft_id[]=new String[counter];
//out.println("count_actual"+count_actual);
for (int i=0;i<count_actual;i++)
{
//srno[i]=""+request.getParameter("srno"+i);
//out.print("srno"+i+" "+srno[i]);
type_toby[i]=""+request.getParameter("type_toby"+i);
account_id[i]=""+request.getParameter("account_id"+i);
amount[i]=Double.parseDouble(request.getParameter("amount"+i)); 
remarks[i]=""+request.getParameter("remarks"+i); 
ft_id[i]=""+request.getParameter("ft_id"+i);
}

//out.println("Outside for 123 --");
// type_toby[counter]=to_by;
//out.println("<br><font color=red>v_type="+type+"</font>");
for (int i=0;i<count_actual;i++)
{
//out.println("<br>srno"+i+":"+srno[i]);
//out.println("<font color=red>type_toby"+i+":</font>"+type_toby[i]);
//out.println(",account_id"+i+":"+account_id[i]);
//out.println(",amount"+i+":"+amount[i]);
//out.println(",remarks"+i+":"+remarks[i]);
//out.println(",ft_id"+i+":"+ft_id[i]);
ledger_id[i]=account_id[i];
if("4".equals(type))
{
for_headid[i]=account_id[i];
for_head[i]="1";
if("0".equals(account_id[i]))
	{
	for_head[i]="4";}
ledger_id[i]="0";
mode[i]=true;
if("to".equals(type_toby[i]))
	{
	mode[i]=false;}

}

else if("5".equals(type))//PAYMENT
{
for_headid[i]=account_id[i];
for_head[i]="1";
if("0".equals(account_id[i]))
{for_head[i]="4";}
//mode=true= debit false=credit
mode[i]=true;
ledger_id[i]="0";

if("by".equals(type_toby[i]))
{
mode[i]=false;
query="Select * from Ledger where Ledger_id="+account_id[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
for_head[i]=rs_g.getString("For_Head");
for_headid[i]=rs_g.getString("For_HeadId");
ledger_id[i]=account_id[i];

}

pstmt_p.close();
}
}

else if("6".equals(type))//RECEIPT
{
ledger_id[i]="0";
for_headid[i]=account_id[i];
for_head[i]="1";
if("0".equals(account_id[i]))
{for_head[i]="4";}
//mode=true= debit false=credit
mode[i]=false;
if("to".equals(type_toby[i]))
{
mode[i]=true;
query="Select * from Ledger where Ledger_id="+account_id[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
for_head[i]=rs_g.getString("For_Head");
for_headid[i]=rs_g.getString("For_HeadId");
ledger_id[i]=account_id[i];

}
pstmt_p.close();
}
}
else//JOURNAL
{
query="Select * from Ledger where Ledger_id="+account_id[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
for_head[i]=rs_g.getString("For_Head");
for_headid[i]=rs_g.getString("For_HeadId");
ledger_type[i]=rs_g.getString("Ledger_type");
ledger_id[i]=account_id[i];

}
pstmt_p.close();
mode[i]=false;
if("to".equals(type_toby[i]))
	{mode[i]=true;}

}
//out.println("<br><font color=blue>for_head="+for_head[i]);
//out.println("<br>for_headid="+for_headid[i]+"</font>");
//out.println("<br>ledger_id="+ledger_id[i]+"</font>");
if ("local".equals(currency))
	{
	local_amount[i]=amount[i];
	dollar_amount[i]= local_amount[i]/exchange_rate;
	}
else
	{
	dollar_amount[i]=amount[i];
	local_amount[i]= dollar_amount[i]*exchange_rate;
	}
//out.print("<br> 151 --");
}

//out.print("<br> for 155 --");


//out.println("<br>669 voucher_id="+voucher_id);

if("7".equals(type))
{
String old_currency=request.getParameter("old_currency");
double oldex_rate= Double.parseDouble(request.getParameter("oldex_rate"));
int old_ledgerid[]=new int[count_actual];
int temp_ledgerid[]=new int[count_actual];
double  old_amount[]=new double[count_actual];
double oldlocal_amount[]=new double[counter];
double olddollar_amount[]=new double[counter];

for (int i=0;i<count_actual;i++)
{
old_ledgerid[i]=Integer.parseInt(request.getParameter("old_ledgerid"+i));
old_amount[i]=Double.parseDouble(request.getParameter("old_amount"+i));
temp_ledgerid[i]=Integer.parseInt(ledger_id[i]);
if ("local".equals(old_currency))
	{
	oldlocal_amount[i]=old_amount[i];
	olddollar_amount[i]= oldlocal_amount[i]/oldex_rate;
	}
else
	{
	olddollar_amount[i]=old_amount[i];
	oldlocal_amount[i]= olddollar_amount[i]*oldex_rate;
	}


}
String oldfor_head[]=new String[count_actual];
String oldfor_headid[]=new String[count_actual];
String oldledger_type[]=new String[count_actual];

for (int i=0;i<count_actual;i++)
{
query="Select * from Ledger where Ledger_id="+old_ledgerid[i]+"";
pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();
while(rs_g.next()) 	
{
oldfor_head[i]=rs_g.getString("For_Head");
oldfor_headid[i]=rs_g.getString("For_HeadId");
oldledger_type[i]=rs_g.getString("Ledger_type");

}
pstmt_p.close();
}
String pn_accountid= A.getNameCondition(conp,"Master_Account","account_id","Where Account_Name='PN Account' and Company_id="+company_id+" ");

query="Update Voucher set  Company_Id=?, Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? ,Ref_No=? where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);


pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no);		
//out.println("<br >2 :0");
pstmt_p.setString (3,""+counter);
//out.println("<br >5 "+counter);
pstmt_p.setBoolean(4,voucher_currency);
pstmt_p.setString (5,""+exchange_rate);
pstmt_p.setString (6,""+total);	
pstmt_p.setString (7,""+localamt);	
pstmt_p.setString (8,""+dollaramt);
pstmt_p.setString (9,description);
pstmt_p.setString (10,user_id);	
pstmt_p.setString (11,machine_name);	
pstmt_p.setString(12,ref_no);
pstmt_p.setString (13,""+voucher_id);		
//out.println("<br >machine_name "+machine_name);
//out.println("<br >voucher_id "+voucher_id);

int a691 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>Updated Successfully: ?</font>" +a691+" voucher_id "+voucher_id);
pstmt_p.close();

//int tranasaction_id= L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
for (int i=0;i<count_actual;i++)
{
if(temp_ledgerid[i]==old_ledgerid[i])
	{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);		

	}
else{
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();



if("14".equals(for_head[i]))
	{

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
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
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
advpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
advpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");
advpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
// sign changed of operation on 24/05/04 by Samyak113 after dissussion with  Samyak114
	//Start Samyak113 
	{
	advsale_localbalance= advsale_localbalance - oldlocal_amount[i] + local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance - olddollar_amount[i] + dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance + oldlocal_amount[i] - local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance + olddollar_amount[i] - dollar_amount[i];
	}
	//End Samyak113 
}

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance= advpurchase_localbalance + oldlocal_amount[i] - local_amount[i];
	advpurchase_dollarbalance= advpurchase_dollarbalance + olddollar_amount[i] - dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance= advpurchase_localbalance - oldlocal_amount[i] + local_amount[i];
	advpurchase_dollarbalance= advpurchase_dollarbalance - olddollar_amount[i] + dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];
String pn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);


if(mode[i])
	{
advpn_localbalance = advpn_localbalance + oldlocal_amount[i] - local_amount[i];
advpn_dollarbalance= advpn_dollarbalance + olddollar_amount[i] - dollar_amount[i];
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,""+(amount[i]*-1));		
pstmt_p.setString (5,""+(local_amount[i]*-1));		
pstmt_p.setString (6,""+(dollar_amount[i]*-1));		
pstmt_p.setString (7,""+exchange_rate);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,""+voucher_id);
pstmt_p.setString (11,pn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance - oldlocal_amount[i] + local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance - olddollar_amount[i] + dollar_amount[i];
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,""+(amount[i]*1));		
pstmt_p.setString (5,""+(local_amount[i]*1));		
pstmt_p.setString (6,""+(dollar_amount[i]*1));		
pstmt_p.setString (7,""+exchange_rate);		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,""+voucher_id);
pstmt_p.setString (11,pn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}


}//if 

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+advsale_localbalance);
pstmt_p.setString (2,""+advsale_dollarbalance);
pstmt_p.setString (3,""+advpurchase_localbalance);
pstmt_p.setString (4,""+advpurchase_dollarbalance);
pstmt_p.setString (5,""+advpn_localbalance);
pstmt_p.setString (6,""+advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();




	}//if for_head=14




}//if----------------------------

else{
//out.print("<br>Under Construction");


if((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])!=14))
	{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();

query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
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
advsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
advpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
advpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
advpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");
advpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance + oldlocal_amount[i] ;
	advsale_dollarbalance= advsale_dollarbalance + olddollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance - oldlocal_amount[i] ;
	advsale_dollarbalance= advsale_dollarbalance - olddollar_amount[i] ;
	}
}

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance= advpurchase_localbalance + oldlocal_amount[i] ;
	advpurchase_dollarbalance= advpurchase_dollarbalance + olddollar_amount[i] ;
	}
	else
	{
	advpurchase_localbalance= advpurchase_localbalance - oldlocal_amount[i] ;
	advpurchase_dollarbalance= advpurchase_dollarbalance - olddollar_amount[i] ;
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];
String pn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);


if(mode[i])
	{
advpn_localbalance = advpn_localbalance + oldlocal_amount[i] ;
advpn_dollarbalance= advpn_dollarbalance + olddollar_amount[i] ;
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,"0");		
pstmt_p.setString (5,"0");		
pstmt_p.setString (6,"0");		
pstmt_p.setString (7,"0");		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,pn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance - oldlocal_amount[i] ;
	advpn_dollarbalance= advpn_dollarbalance - olddollar_amount[i] ;
//out.println("<br>87 pn_id="+pn_id);
query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+party_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,"0");		
pstmt_p.setString (5,"0");		
pstmt_p.setString (6,"0");		
pstmt_p.setString (7,"0");		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,pn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}


}//if 

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+advsale_localbalance);
pstmt_p.setString (2,""+advsale_dollarbalance);
pstmt_p.setString (3,""+advpurchase_localbalance);
pstmt_p.setString (4,""+advpurchase_dollarbalance);
pstmt_p.setString (5,""+advpn_localbalance);
pstmt_p.setString (6,""+advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


}//if((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])!=14))

else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])!=14))
	{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();
//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();


	}//else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])!=14))


else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])==14))
	{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);		

	}
else{
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();



query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
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
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit


if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance-local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance-dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance+local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance+dollar_amount[i];
	}
}//if 

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance=advpurchase_localbalance-local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance-dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance=advpurchase_localbalance+local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance+dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];

	if(mode[i])
	{
advpn_localbalance=advpn_localbalance-local_amount[i];
advpn_dollarbalance=advpn_dollarbalance-dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+format.getDate(datevalue)+"','"+format.getDate(datevalue)+"',?,?, ?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setString (5,""+(amount[i]*-1));		
pstmt_p.setString (6,""+(local_amount[i]*-1));		
pstmt_p.setString (7,""+(dollar_amount[i]*-1));		
pstmt_p.setString (8,""+exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Payment");		
pstmt_p.setString (10,"bank_name");	
pstmt_p.setBoolean(11,false);	
pstmt_p.setBoolean(12,false);	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
//out.print("<br >22 "+machine_name);
pstmt_p.setString(17,yearend_id);
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}
	else
	{
	advpn_localbalance= advpn_localbalance+local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance+dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+format.getDate(datevalue)+"','"+format.getDate(datevalue)+"',?,?, ?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setString (5,""+(amount[i]*1));		
pstmt_p.setString (6,""+(local_amount[i]*1));		
pstmt_p.setString (7,""+(dollar_amount[i]*1));		
pstmt_p.setString (8,""+exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Receipt");		
pstmt_p.setString (10,"bank_name");	
pstmt_p.setBoolean(11,false);	
pstmt_p.setBoolean(12,false);	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
//out.print("<br >22 "+machine_name);
pstmt_p.setString(17,yearend_id);
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}

	}//if
query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+advsale_localbalance);
pstmt_p.setString (2,""+advsale_dollarbalance);
pstmt_p.setString (3,""+advpurchase_localbalance);
pstmt_p.setString (4,""+advpurchase_dollarbalance);
pstmt_p.setString (5,""+advpn_localbalance);
pstmt_p.setString (6,""+advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


	}//else if ((Integer.parseInt(oldfor_head[i])!=14)&&(Integer.parseInt(for_head[i])==14))


else{

query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));	

if(("14".equals(for_head[i]))&&("3".equals(ledger_type[i])))
	{
pstmt_p.setString (4,"1");
pstmt_p.setString (5,pn_accountid);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);	
pstmt_p.setString (13,"0");	
pstmt_p.setString (14,""+ft_id[i]);		

	}
else{
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
}
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();


query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+oldfor_headid[i]); 
rs_g = pstmt_p.executeQuery();
//out.print("<br>94 query fired" +query);
double oadvsale_localbalance=0;
double oadvsale_dollarbalance=0;
double oadvpurchase_localbalance=0;
double oadvpurchase_dollarbalance=0;
double oadvpn_localbalance=0;
double oadvpn_dollarbalance=0;

while(rs_g.next()) 	
{
oadvsale_localbalance= rs_g.getDouble("Sale_AdvanceLocal");
oadvsale_dollarbalance= rs_g.getDouble("Sale_AdvanceDollar");
oadvpurchase_localbalance= rs_g.getDouble("Purchase_AdvanceLocal");
oadvpurchase_dollarbalance= rs_g.getDouble("Purchase_AdvanceDollar");
oadvpn_localbalance= rs_g.getDouble("PN_AdvanceLocal");
oadvpn_dollarbalance= rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit

if ("1".equals(oldledger_type[i]))
	{
	if(mode[i])
	{
	oadvsale_localbalance= oadvsale_localbalance + oldlocal_amount[i] ;
	oadvsale_dollarbalance= oadvsale_dollarbalance + olddollar_amount[i];
	}
	else
	{
	oadvsale_localbalance= oadvsale_localbalance - oldlocal_amount[i] ;
	oadvsale_dollarbalance= oadvsale_dollarbalance - olddollar_amount[i] ;
	}
}

if ("2".equals(oldledger_type[i]))
	{
	if(mode[i])
	{
	oadvpurchase_localbalance= oadvpurchase_localbalance + oldlocal_amount[i] ;
	oadvpurchase_dollarbalance= oadvpurchase_dollarbalance + olddollar_amount[i] ;
	}
	else
	{
	oadvpurchase_localbalance= oadvpurchase_localbalance - oldlocal_amount[i] ;
	oadvpurchase_dollarbalance= oadvpurchase_dollarbalance - olddollar_amount[i] ;
	}
	}//if 

if ("3".equals(oldledger_type[i]))
	{
String oparty_id=oldfor_headid[i];
String opn_id=A.getNameCondition(conp,"PN","PN_Id","Where RefVoucher_id="+voucher_id);


if(mode[i])
	{
oadvpn_localbalance = oadvpn_localbalance + oldlocal_amount[i] ;
oadvpn_dollarbalance= oadvpn_dollarbalance + olddollar_amount[i] ;

query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+oparty_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,"0");		
pstmt_p.setString (5,"0");		
pstmt_p.setString (6,"0");		
pstmt_p.setString (7,"0");		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,opn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	oadvpn_localbalance= oadvpn_localbalance - oldlocal_amount[i] ;
	oadvpn_dollarbalance= oadvpn_dollarbalance - olddollar_amount[i] ;

query="Update PN set Company_Id=?,TO_FromId=?, PN_No=?, PN_Date='"+format.getDate(datevalue)+"', Payment_Date='"+format.getDate(datevalue)+"', PN_Amount=?, PN_LocalAmount=?, PN_DollarAmount=?, PN_ExchangeRate=?, Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, RefVoucher_id=? where PN_Id=?";

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,company_id);		
pstmt_p.setString (2,""+oparty_id);		
pstmt_p.setString (3,""+voucher_no);		
pstmt_p.setString (4,"0");		
pstmt_p.setString (5,"0");		
pstmt_p.setString (6,"0");		
pstmt_p.setString (7,"0");		
pstmt_p.setString (8,""+user_id);	
pstmt_p.setString (9,""+machine_name);	
pstmt_p.setString (10,"0");
pstmt_p.setString (11,opn_id);		
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();
	}






}//if 


query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+oadvsale_localbalance);
pstmt_p.setString (2,""+oadvsale_dollarbalance);
pstmt_p.setString (3,""+oadvpurchase_localbalance);
pstmt_p.setString (4,""+oadvpurchase_dollarbalance);
pstmt_p.setString (5,""+oadvpn_localbalance);
pstmt_p.setString (6,""+oadvpn_dollarbalance);
pstmt_p.setString (7,oldfor_headid[i]);
int a1123 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a1123 " +a1123+"</font>");
pstmt_p.close();



query= "Select * from Master_CompanyParty Where CompanyParty_Id=?";
//out.print("<br>791 query" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+for_headid[i]); 
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
advsale_localbalance=rs_g.getDouble("Sale_AdvanceLocal");
advsale_dollarbalance=rs_g.getDouble("Sale_AdvanceDollar");
advpurchase_localbalance=rs_g.getDouble("Purchase_AdvanceLocal");
advpurchase_dollarbalance=rs_g.getDouble("Purchase_AdvanceDollar");
advpn_localbalance=rs_g.getDouble("PN_AdvanceLocal");
advpn_dollarbalance=rs_g.getDouble("PN_AdvanceDollar");
}
pstmt_p.close();

//mode=true= debit false=credit


if ("1".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advsale_localbalance= advsale_localbalance-local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance-dollar_amount[i];
	}
	else
	{
	advsale_localbalance= advsale_localbalance+local_amount[i];
	advsale_dollarbalance= advsale_dollarbalance+dollar_amount[i];
	}
}//if 

if ("2".equals(ledger_type[i]))
	{
	if(mode[i])
	{
	advpurchase_localbalance=advpurchase_localbalance-local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance-dollar_amount[i];
	}
	else
	{
	advpurchase_localbalance=advpurchase_localbalance+local_amount[i];
	advpurchase_dollarbalance=advpurchase_dollarbalance+dollar_amount[i];
	}
	}//if 

if ("3".equals(ledger_type[i]))
	{
String party_id=for_headid[i];

	if(mode[i])
	{
advpn_localbalance=advpn_localbalance-local_amount[i];
advpn_dollarbalance=advpn_dollarbalance-dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+format.getDate(datevalue)+"','"+format.getDate(datevalue)+"',?,?, ?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setString (5,""+(amount[i]*-1));		
pstmt_p.setString (6,""+(local_amount[i]*-1));		
pstmt_p.setString (7,""+(dollar_amount[i]*-1));		
pstmt_p.setString (8,""+exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Payment");		
pstmt_p.setString (10,"bank_name");	
pstmt_p.setBoolean(11,false);	
pstmt_p.setBoolean(12,false);	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
//out.print("<br >22 "+machine_name);
pstmt_p.setString(17,yearend_id);
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();

	}
	else
	{
	advpn_localbalance= advpn_localbalance+local_amount[i];
	advpn_dollarbalance= advpn_dollarbalance+dollar_amount[i];
String pn_id= ""+L.get_master_id(conp,"PN");
//out.println("<br>87 pn_id="+pn_id);
query="Insert into PN(PN_Id,Company_Id,TO_FromId, PN_No,PN_Date,Payment_Date,PN_Amount,PN_LocalAmount,PN_DollarAmount,PN_ExchangeRate,Location,Bank,PN_Loan,Pn_Status,Description,Modified_On,Modified_By,Modified_MachineName, RefVoucher_id,YearEnd_Id)values (?,?,?,?, '"+format.getDate(datevalue)+"','"+format.getDate(datevalue)+"',?,?, ?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,?)";
//18 columns +27/12/2003

pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,pn_id);		
//out.print("<br >1 "+pn_id);
pstmt_p.setString (2,company_id);		
//out.print("<br >2company_id:"+company_id);
pstmt_p.setString (3,""+party_id);		
//out.print("<br >to_fromid:"+party_id);
pstmt_p.setString (4,""+voucher_no);		
//out.print("<br >to_fromid:"+voucher_no);
pstmt_p.setString (5,""+(amount[i]*1));		
pstmt_p.setString (6,""+(local_amount[i]*1));		
pstmt_p.setString (7,""+(dollar_amount[i]*1));		
pstmt_p.setString (8,""+exchange_rate);		
//out.print("<br >exrate:"+exchange_rate);
pstmt_p.setString (9,"Journal PN_Receipt");		
pstmt_p.setString (10,"bank_name");	
pstmt_p.setBoolean(11,false);	
pstmt_p.setBoolean(12,false);	
pstmt_p.setString (13,"Journal PN_Receipt");	
pstmt_p.setString (14,""+user_id);	
//out.print("<br >21"+user_id);
pstmt_p.setString (15,""+machine_name);	
pstmt_p.setString (16,""+voucher_id);	
//out.print("<br >22 "+machine_name);
pstmt_p.setString(17,yearend_id);
int a322 = pstmt_p.executeUpdate();
//out.println(" <BR><font color=navy>Added Successfully:</font> " +a322);
pstmt_p.close();


	}

	}//if

query="Update Master_CompanyParty set Sale_AdvanceLocal=?, Sale_AdvanceDollar=?,Purchase_AdvanceLocal=?,Purchase_AdvanceDollar=?,PN_AdvanceLocal=?,PN_AdvanceDollar=? where Companyparty_id=?";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,""+advsale_localbalance);
pstmt_p.setString (2,""+advsale_dollarbalance);
pstmt_p.setString (3,""+advpurchase_localbalance);
pstmt_p.setString (4,""+advpurchase_dollarbalance);
pstmt_p.setString (5,""+advpn_localbalance);
pstmt_p.setString (6,""+advpn_dollarbalance);
pstmt_p.setString (7,for_headid[i]);
int a870 = pstmt_p.executeUpdate();
//out.println("<font color=Red> Master Company Party Updated  Successfully:a870 " +a870+"</font>");
pstmt_p.close();


}//else if ((Integer.parseInt(oldfor_head[i])==14)&&(Integer.parseInt(for_head[i])==14))



}//else


}//for




}
else{
query="Update Voucher set  Company_Id=?, Voucher_No=?, Voucher_Date='"+format.getDate(datevalue)+"', ToBy_Nos=?,  Voucher_Currency=?, Exchange_Rate=?, Voucher_Total=?, Local_Total=?, Dollar_Total=? , Description=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?,Ref_No=?  where Voucher_Id=?";

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);


pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,voucher_no);		
//out.println("<br >2 :0");
pstmt_p.setString (3,""+counter);
//out.println("<br >5 "+counter);
pstmt_p.setBoolean(4,voucher_currency);
pstmt_p.setString (5,""+exchange_rate);
pstmt_p.setString (6,""+total);	
pstmt_p.setString (7,""+localamt);	
pstmt_p.setString (8,""+dollaramt);
pstmt_p.setString (9,""+description);
pstmt_p.setString (10,""+user_id);	
pstmt_p.setString (11,""+machine_name);	
pstmt_p.setString (12,""+ref_no);
pstmt_p.setString (13,""+voucher_id);		
//out.println("<br >machine_name "+machine_name);
//out.println("<br >voucher_id "+voucher_id);

int a691 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>Updated Successfully: ?</font>" +a691+" voucher_id "+voucher_id);
pstmt_p.close();
//int tranasaction_id= L.get_master_id("Financial_Transaction");
//out.println("<br>150 tranasaction_id="+tranasaction_id);
for (int i=0;i<count_actual;i++)
{
query="Update Financial_Transaction set  Company_Id=?, Voucher_id=?,Sr_No=?, For_Head=?, For_HeadId=?, Description=?, Transaction_Type=?, Amount=?, Local_Amount=?, Dollar_Amount=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=?, Ledger_Id=?, Transaction_Date='"+format.getDate(datevalue)+"' where Tranasaction_Id=?";

//pstmt_p.setString (4,ledger_id[i]);

//out.println("<BR>90" +query);
pstmt_p = conp.prepareStatement(query);
pstmt_p.clearParameters();

//out.print("<br >1 "+tranasaction_id);
pstmt_p.setString(1,company_id); 
pstmt_p.setString(2,""+voucher_id);		
pstmt_p.setString(3,""+(i+1));		
pstmt_p.setString (4,for_head[i]);
//out.print("<br >3 "+for_head[i]);
pstmt_p.setString (5,account_id[i]);
pstmt_p.setString (6,remarks[i]);
pstmt_p.setBoolean(7,mode[i]);
pstmt_p.setString (8,""+amount[i]);	
pstmt_p.setString (9,""+local_amount[i]);	
pstmt_p.setString (10,""+dollar_amount[i]);
pstmt_p.setString (11,user_id);	
pstmt_p.setString (12,machine_name);
pstmt_p.setString (13,ledger_id[i]);
pstmt_p.setString (14,""+ft_id[i]);		
//out.println("<br >ft_id[i]"+ft_id[i]);
//out.print("<br >machine_name "+machine_name);
int a749 = pstmt_p.executeUpdate();
//out.printlnln(" <BR><font color=navy>****Updated FT Successfully: ?</font>" +a749+"ft_id[i]"+ft_id[i]);
pstmt_p.close();

}//for

}



conp.commit();

C.returnConnection(conp);

%>
<script language="JavaScript">
function f1()
{
var vno="<%=voucher_no%>";
alert("Data Sucessfully Updated for Voucher No "+vno+"");
 
<%
if("yes".equals(from_india))
{
	response.sendRedirect("../Report/DayBook_India.jsp?command=Next&bydate=Invoice_Date&currency=both&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
}
else
{
	response.sendRedirect("EditVouchers.jsp?command=edit&&message=Voucher "+voucher_no+" Updated Successfully");
}
%>
window.close();
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body> 
</BODY>
</HTML>
<%
//response.sendRedirect("EditVouchers.jsp?command=edit&&message=Voucher "+voucher_no+" Updated Successfully");
}//else moexist
}//if total
else {
C.returnConnection(conp);

%>
<body bgColor=#ffffee   background="../Buttons/BGCOLOR.JPG">
<%
out.print("<br><center><font class='star1'>Debit And Credit Total Should Be Equal</font> </center>");
out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}
}
catch(Exception Samyak444){ 
	conp.rollback();
out.println("<br><font color=red> FileName : UpdateVoucher.jsp Bug No Samyak444 : "+ Samyak444);
}
}//if Update
%>










