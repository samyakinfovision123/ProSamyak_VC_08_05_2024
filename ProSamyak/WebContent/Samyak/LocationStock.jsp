<!--  
To change page break lines print  find s% in the file and change the number to get the desired output

-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
/*String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");*/
String machine_name=request.getRemoteHost();
String company_id= "1";//+session.getValue("company_id");
String company_name= A.getName("companyparty",company_id);

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{cong=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtStockReport.jsp<br>Bug No e31 : "+ e31);}

try{
String local_currency= I.getLocalCurrency(company_id);
int d= Integer.parseInt(A.getName("Master_Currency", "Decimal_Places","Currency_id",local_currency));
//out.print("<BR>d="+d);
String local_symbol= I.getLocalSymbol(company_id);
String currency_name=A.getName("Master_Currency", "Currency_Name","Currency_id",local_currency);


int method= 0; //Integer.parseInt(request.getParameter("method"));
//out.print("<br>method=>"+method);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int year=D.getYear();
year =year-1;

int dd=D.getDate();
int mm=D.getMonth();
java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
String command=request.getParameter("command");
//out.print("<br>command=" +command);
int dd1 = 11;//Integer.parseInt(request.getParameter("dd1"));
int mm1 = 06;//Integer.parseInt(request.getParameter("mm1"));
int yy1 = 2004;//Integer.parseInt(request.getParameter("yy1"));
java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
D1=D;
/*String order_by= request.getParameter("order_by");
String report_location= request.getParameter("report_location");
String dispaly_qty= request.getParameter("dispaly_qty");
String dispaly_loc= request.getParameter("dispaly_loc");*/
String condition="";
String report_name="Category ";
String loc_query="Select count(*) as location_count from Master_Location where company_id=?" ;
pstmt_g = cong.prepareStatement(loc_query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
int location_count=0;
while(rs_g.next())
{
	location_count=rs_g.getInt("location_count");
}
pstmt_g.close();
int location_id[]=new int[location_count];
String Location_Name[]=new String[location_count];

loc_query="Select * from Master_Location where company_id=?" ;
pstmt_g = cong.prepareStatement(loc_query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
int lc=0;
while(rs_g.next())
{
location_id[lc]=rs_g.getInt("location_id");
Location_Name[lc]=rs_g.getString("Location_Name");
lc++;
}
pstmt_g.close();

C.returnConnection(cong);

if("Stock".equals(command) )
{
	cong=C.getConnection();
out.print("Stock");
//out.print("<br>44order_by=" +order_by);
String query="";



query="Select * from Lot where created_on <= ?  and Company_id=?  order by Lot_Id";
//out.print("<br>phy query"+query);                             //This condition comes from above if statments 
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
out.print("<br>57" +count);

C.returnConnection(cong);

if(count==0)
{
	response.sendRedirect("../Home/Homepage.jsp");

}
else
{
cong=C.getConnection();
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
String uom[]= new String[count];
double carats[]=new double[count];
double local_price[]=new double[count];
double dollar_price[]=new double[count];
double pcarats[]=new double[count];
double plocal_price[]=new double[count];
double pdollar_price[]=new double[count];
double ccarats[]=new double[count];
double clocal_price[]=new double[count];
double cdollar_price[]=new double[count];
double per_carats[]=new double[count];
double sale_carats[]=new double[count];
double per_ccarats[]=new double[count];
double sale_ccarats[]=new double[count];
double locphy_carats[][]=new double[count][location_count];
double locfin_carats[][]=new double[count][location_count];

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		uom[c]=A.getName("Unit",rs_g.getString("Unit_id"));
		c++;
		}
		pstmt_g.close();
//out.print("<br>70");



query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id order by R.Stock_Date,R.Receive_id";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//out.print("<br>101count=" +count);
String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];
int locationId[]=new int[count];
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
	//---------------------------------------------------------
			lotid[c]=rs_g.getString("Lot_id");
 //	out.print("&nbsp;lotid[c]="+lotid[c]);
		qty[c]=rs_g.getDouble("Available_Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
// 	out.print("&nbsp;localprice[c]="+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		locationId[c]=rs_g.getInt("Location_id");
//-------------------------------------------------------------------
		receive_sell[c]=rs_g.getString("receive_sell");
//		out.print("&nbsp;&nbsp;receive_sell=" +receive_sell[c]);
 
		purchase[c]=rs_g.getString("purchase");
//		out.print("<br>purchase=" +purchase[c]);

		c++;
		}
		pstmt_g.close();


int j=0;
double localp=0;
double localp_temp=0;
double tqty=0;
double tqty_temp=0;
double dollarp=0;
double dollarp_temp=0;
double temp=0;
double temp1=0;
double inwardqty=0;
double outwardqty=0;
double closingdqty=0;
double inwardtot=0;
double outwardtot=0;
double closingtot=0;
int k=0;
//out.print("<br>Lot Id &nbsp;&nbsp;Lot No &nbsp;&nbsp; carats&nbsp;&nbsp; local_price");

for(int i=0; i<counter; i++)
{

k=0;
j=0;
localp=0;
localp_temp=0;
tqty=0;
tqty_temp=0;
dollarp=0;
dollarp_temp=0;
temp=0;
temp1=0;
inwardqty=0;
outwardqty=0;
closingdqty=0;
inwardtot=0;
outwardtot=0;
closingtot=0;
for(lc=0; lc<location_count; lc++)
{
locphy_carats[i][lc]=0;
locfin_carats[i][lc]=0;
k=0;
while(k<count)
{
if(lot_id[i].equals(lotid[k]))
	{
	//out.print("<br>255");
	if(("1".equals(receive_sell[k]))&("1".equals(purchase[k])))
	{if(location_id[lc]==locationId[k])
		{
		locfin_carats[i][lc]+=qty[k];
		locphy_carats[i][lc]+=qty[k];
		//out.print("&nbsp;&nbsp;261" +locphy_carats[i][lc]);

		}
	}//if purchase

else if(("1".equals(receive_sell[k]))&("0".equals(purchase[k])))
	{if(location_id[lc]==locationId[k])
		{locphy_carats[i][lc]+=qty[k];}
	}//if cgtpurchase

else if(("0".equals(receive_sell[k]))&("1".equals(purchase[k])))
	{if(location_id[lc]==locationId[k])
		{
	locfin_carats[i][lc] =locfin_carats[i][lc] - qty[k];
	locphy_carats[i][lc] =locphy_carats[i][lc] - qty[k];
	}
	}//if sale

else if(("0".equals(receive_sell[k]))&("0".equals(purchase[k])))
	{if(location_id[lc]==locationId[k])
		{locphy_carats[i][lc] =locfin_carats[i][lc] - qty[k];}
	}//if cgtsale

	}//if lot-id
	k++;
	}//while
}//for
while(j<count)
{
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
// out.print("<br>tqty_temp="+tqty_temp);
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);
//carats[i] +=qty[j];
dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
//  out.print("<br>localp_temp="+localp_temp);

localp=0;
if(0==(tqty))
		{
localp=0;
dollarp=0;
		}
else{

 localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
 dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
}
temp=localprice[j]*qty[j];
temp1=localp*tqty;
 inwardqty +=qty[j];
 closingdqty +=tqty;
 inwardtot +=temp;
 closingtot +=temp1;
 per_carats[i]+=qty[j];


	}

else if((lot_id[i].equals(lotid[j]))&("0".equals(receive_sell[j])) &("1".equals(purchase[j])))
	{

//out.print("<br>sale="+qty[j]);
 tqty =tqty - qty[j];
//carats[i]=carats[i]-qty[j];
//out.print("&nbsp;&nbsp;qty="+tqty);
//out.print("&nbsp;&nbsp;Local="+localp);
//out.print("&nbsp;&nbsp;Dollar="+dollarp);
temp=localprice[j]*qty[j];
temp1=localp*tqty;
outwardqty +=qty[j];
outwardtot +=temp;
closingdqty +=tqty;
closingtot +=temp1;
sale_carats[i] +=qty[j];
}

j++;
}
 carats[i]=tqty;
 //local_price[i]=localp;
// dollar_price[i]=dollarp;

 try{ 
		new Double(""+localp);
		local_price[i]=localp;
	}catch(Exception e) 
	{
	local_price[i]=0;
	}
 try{ 
		new Double(""+dollarp);
		dollar_price[i]=dollarp;
	}catch(Exception e) 
	{
	dollar_price[i]=0;
	}
 

 
 
 
 pcarats[i]=0;
 plocal_price[i]=0;
 pdollar_price[i]=0;
 ccarats[i]=0;
 clocal_price[i]=0;
 cdollar_price[i]=0;
//out.print("<br>"+lot_id[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+lot_no[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+carats[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+local_price[i]);
//out.print("&nbsp;&nbsp;dollar_price="+dollar_price[i]);

}
double locphy_tot[]=new double[location_count];
double locfin_tot[]=new double[location_count];
for(int i=0; i<counter; i++)
{
k=0;
j=0;
localp=0;
localp_temp=0;
tqty=0;
tqty_temp=0;
dollarp=0;
dollarp_temp=0;
temp=0;
temp1=0;
inwardqty=0;
outwardqty=0;
closingdqty=0;
inwardtot=0;
outwardtot=0;
closingtot=0;
while(j<count)
{
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("0".equals(purchase[j])) )
	{
 tqty_temp =tqty;
// out.print("<br>tqty_temp="+tqty_temp);
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);
//carats[i] +=qty[j];
dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
//  out.print("<br>localp_temp="+localp_temp);

localp=0;
if(0==(tqty))
		{
localp=0;
dollarp=0;
		}
else{

 localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
 dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
}
temp=localprice[j]*qty[j];
temp1=localp*tqty;
 inwardqty +=qty[j];
 closingdqty +=tqty;
 inwardtot +=temp;
 closingtot +=temp1;
 per_ccarats[i]+=qty[j];


	}

else if((lot_id[i].equals(lotid[j]))&("0".equals(receive_sell[j])) &("0".equals(purchase[j])))
	{

//out.print("<br>sale="+qty[j]);
 tqty =tqty - qty[j];
//carats[i]=carats[i]-qty[j];
//out.print("&nbsp;&nbsp;qty="+tqty);
//out.print("&nbsp;&nbsp;Local="+localp);
//out.print("&nbsp;&nbsp;Dollar="+dollarp);
temp=localprice[j]*qty[j];
temp1=localp*tqty;
outwardqty +=qty[j];
outwardtot +=temp;
closingdqty +=tqty;
closingtot +=temp1;
sale_ccarats[i] +=qty[j];
}

j++;
}
ccarats[i]=tqty;
 clocal_price[i]=localp;
//out.print("<br>"+lot_id[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+lot_no[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+carats[i]);
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+local_price[i]);
//out.print("&nbsp;&nbsp;dollar_price="+dollar_price[i]);

}//or











%>
<html><head><title>Samyak Software</title>
</head>

<%
double total=0;
double subtotal=0;
double csubtotal=0;
double clocal_total=0;
double psubtotal=0;
double plocal_total=0;
double per_total=0;
double sale_total=0;
double per_ctotal=0;
double sale_ctotal=0;
double p_total=0;
double local_subtotal=0;
double dollar_subtotal=0;
double local_total=0;
double phylocal_total=0;
double phydollar_total=0;




int s=1;

for(int i=0; i< counter; i++)
{
total += carats[i];
subtotal= carats[i] *local_price[i];
local_total +=str.mathformat(subtotal,d);
csubtotal= ccarats[i] *clocal_price[i];
clocal_total +=str.mathformat(csubtotal,d);
psubtotal= subtotal+ csubtotal;
pcarats[i]=carats[i]+ccarats[i];
plocal_total+=str.mathformat(psubtotal,d);
 per_total +=per_carats[i];
sale_total += sale_carats[i];
 per_ctotal +=per_ccarats[i];
 sale_ctotal +=sale_ccarats[i];
p_total +=pcarats[i];
 //if("0".equals(report_location))
	//{
for(lc=0; lc<location_count; lc++)
		{

local_subtotal=locphy_carats[i][lc]* local_price[i];
dollar_subtotal=locphy_carats[i][lc]* dollar_price[i];
phylocal_total += str.mathformat(local_subtotal,d);
phydollar_total += str.mathformat(dollar_subtotal,2);
locphy_tot[lc] += locphy_carats[i][lc];
locfin_tot[lc] += locfin_carats[i][lc];
String  locquery="Update LotLocation set Carats=? ,Available_Carats=? Where Lot_Id=? and Location_Id=?";
pstmt_g = cong.prepareStatement(locquery);
pstmt_g.setString(1,""+locfin_carats[i][lc]); 
pstmt_g.setString(2,""+locphy_carats[i][lc]); 
pstmt_g.setString(3,""+lot_id[i]); 
pstmt_g.setString(4,""+location_id[lc]); 
int a308 = pstmt_g.executeUpdate();
//out.println("<br>a561"+a308);
pstmt_g.close();


		}//FOR

}//OUTER FOR
C.returnConnection(cong);

response.sendRedirect("../Home/Homepage.jsp");
}//end else i.e. count != 0



}//if Physical Stock 

}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
%>
</BODY>
</HTML>











