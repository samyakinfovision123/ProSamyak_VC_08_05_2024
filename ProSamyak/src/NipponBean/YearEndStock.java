package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;

import NipponBean.*;

public class  YearEndStock 
{
	Connect1 C =null;

	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	PreparedStatement pstmt_p=null;
	public	YearEndStock()
		{
			/* try{
	C = new Connect1();	
			 }catch(Exception e){ System.out.println("Exception 21 ::- "+e);}*/
		}


public double stockValue(Connection con, java.sql.Date D1,String company_id, String type,int d, String yearend_id)
	{
try{
		//cong=C.getConnection();

String query="";
if("Opening".equals(type))
		{
query="Select * from Lot where created_on < ?  and Company_id=? and Active=1 order by Lot_id";
		}
else{
query="Select * from Lot where created_on <= ?  and Company_id=? and Active=1   order by Lot_id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
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

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();



if("Opening".equals(type))
		{
query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
		}
else{

query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 

rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		
		lotid[c]=rs_g.getString("Lot_id");
		//qty[c]=rs_g.getDouble("Available_Quantity");
		qty[c]=rs_g.getDouble("Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
		dollarprice[c]=rs_g.getDouble("Dollar_Price");

		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
		//System.out.println("Year End Id : "+rs_g.getString("Receive_Id"));
		
		
		c++;
		}
		pstmt_g.close();
//C.returnConnection(cong);


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
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
 localp=0;
tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
 if(0==(tqty) || (tqty_temp+qty[j]==0) )
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


 tqty =tqty - qty[j];
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

}

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
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;

localp=0;
tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
if(0==(tqty) || (tqty_temp+qty[j] == 0) )
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


 tqty =tqty - qty[j];
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

}
double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;
for(int i=0; i< counter; i++)
{
/*To handle exponent value start*/
/*if(carats[i]<0)
	{if((carats[i])> -0.001 )
		{carats[i]=0.0;}
	}else{if(carats[i]<0.001){carats[i]=0.0;}}*/
/*To handle exponent value End*/

total += carats[i];
 dollar_subtotal=dollar_price[i] * carats[i];
local_subtotal=carats[i] * local_price[i];
local_total +=str.mathformat(local_subtotal,d);
 dollar_total +=dollar_subtotal;
}


return local_total;
}catch(Exception Samyak109)
	{//C.returnConnection(cong);
return 0;
	}
//finally{C.returnConnection(cong); }

	}//stockValue



public double stockValue(Connection con, java.sql.Date D1,String company_id, String type,int d, String condition, String yearend_id)
{
try{
		//cong=C.getConnection();

String query="";
if("Opening".equals(type)){
	query="Select * from Lot where created_on < ?  and Company_id=? and Active=1  "+condition+" order by Lot_id";
}
else{
	query="Select * from Lot where created_on <= ?  and Company_id=? and Active=1  "+condition+" order by Lot_id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
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

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();

if("Closing".equals(type)){
	//Start : dynamically getting nextyearend_id
	YearEndDate YED = new YearEndDate();
	GetDate GD = new GetDate();
	String Fyear = YED.returnCurrentFinancialYear(con , pstmt_p, rs_g, yearend_id, company_id);

	StringTokenizer splityear = new StringTokenizer(Fyear,"#");
	String tempFromDate = (String)splityear.nextElement();
	String tempToDate = (String)splityear.nextElement();

	StringTokenizer enddate = new StringTokenizer(tempToDate,"-");
	
	int endyear=Integer.parseInt((String)enddate.nextElement());
	int endmonth=Integer.parseInt((String)enddate.nextElement());
	String endday= (String)enddate.nextElement();
	StringTokenizer splitendday = new StringTokenizer(endday," ");
	int splittedendday = Integer.parseInt((String)splitendday.nextElement());

	//created new dates for next financial year from the current year end date
	java.sql.Date newFinancialYearStart = new java.sql.Date( endyear-1900, endmonth-1, splittedendday+1);
	java.sql.Date newFinancialYearEnd = new java.sql.Date( endyear+1-1900 , endmonth-1, splittedendday);


	String ys = GD.format(newFinancialYearStart);
	String yd = GD.format(newFinancialYearEnd);

	//System.out.println(ys+" : "+yd);
	query = "Select yearend_id from YearEnd where From_Date=? and To_Date=? and Company_Id="+company_id;
	
	//System.out.println(query);
	pstmt_p = con.prepareStatement(query);
	//pstmt_p.setString(1,ys);
	//pstmt_p.setString(2,yd);
	pstmt_p.setDate(1,newFinancialYearStart);
	pstmt_p.setDate(2,newFinancialYearEnd);
	//pstmt_p.setString(3,company_id);
	rs_g = pstmt_p.executeQuery();

	if(rs_g.next())  {
		yearend_id = rs_g.getString("yearEnd_id");
	}
	pstmt_p.close();
	//End : dynamically getting nextyearend_id
}

//System.out.println("YearEnd Id : "+yearend_id);


if("Opening".equals(type))	{
	query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
}
else{
	query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id);
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

//System.out.println("Count = "+count);


String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{

		lotid[c]=rs_g.getString("Lot_id");
		qty[c]=rs_g.getDouble("Quantity");
		//qty[c]=rs_g.getDouble("Available_Quantity");
		//System.out.println("Qty of "+c+" is ="+qty[c]);
		localprice[c]=rs_g.getDouble("Local_Price");
		//System.out.println("Price of "+c+" is ="+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");

		receive_sell[c]=rs_g.getString("Receive_sell");
		purchase[c]=rs_g.getString("purchase");
		
		
		c++;
		}
		pstmt_g.close();

//C.returnConnection(cong);
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
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
localp=0;

tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
if(0==(tqty_temp + qty[j]))
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


 tqty =tqty - qty[j];
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

}

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
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;

localp=0;
tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
if(0==(tqty)  || (tqty_temp + qty[j]==0))
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


 tqty =tqty - qty[j];
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

}
double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;
for(int i=0; i< counter; i++)
{
/*To handle exponent value start*/
/*if(carats[i]<0)
	{if((carats[i])> -0.001 )
		{carats[i]=0.0;}
	}else{if(carats[i]<0.001){carats[i]=0.0;}}*/
/*To handle exponent value End*/

total += carats[i];
 dollar_subtotal=dollar_price[i] * carats[i];
local_subtotal=carats[i] * local_price[i];
local_total +=str.mathformat(local_subtotal,d);
 dollar_total +=dollar_subtotal;
}


return local_total;
}catch(Exception Samyak109)
	{
	System.out.println("YES Samyak 109: " +Samyak109 );
	C.returnConnection(con);
    return 0;
	}
//finally{C.returnConnection(cong); }

	}//stockValue

public String stockStatus(Connection con,java.sql.Date D1,String company_id, String rlotid, String yearend_id)

{
try{
		//cong=C.getConnection();

String query="";
query="Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
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

pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();

query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.Purchase=1 and RT.Lot_id="+rlotid+" and R.receive_id=RT.receive_id and R.yearend_id=? and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		lotid[c]=rs_g.getString("Lot_id");
		qty[c]=rs_g.getDouble("Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		

		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
		
		
		c++;
		}
		//System.out.println("c =="+c);
		//System.out.println("lotid[c] = ");
		pstmt_g.close();
//C.returnConnection(cong);

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
 double rate=0;
String status="";
int k=0;
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
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
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


 tqty =tqty - qty[j];
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
//rate=local_price[i];
}

/*double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;*/
for(int i=0; i< counter; i++)
{
if(rlotid.equals(lot_id[i]))
	{
status =""+ carats[i];
status=status + "/" + local_price[i] ;
 status= status + "/"+ dollar_price[i] ;

	}
}

//System.out.println("Before return"+status);
return status;
}catch(Exception Samyak109){//C.returnConnection(cong);
//System.out.println("Error after");
return "";
	}
//finally{C.returnConnection(cong); }

	}//Stock Status




//start of method for getting physical stock status
public String physicalStockStatus(Connection con,java.sql.Date D1,String company_id, String rlotid, String yearend_id)

{
String line="955";
//System.out.println("DDD");
//System.out.println("DDD");
try{
		//cong=C.getConnection();

String query="";
query="Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();
line="965";
int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;

String lot_id[]= new String[count];
String lot_no[]= new String[count];
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


line="988";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();
line="993";
int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();

//get the opening physical stock
query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and R.Receive_Sell=1 and Opening_Stock=1 and R_Return=0 and RT.Active=1 and RT.Lot_id="+rlotid+" and R.receive_id=RT.receive_id and R.yearend_id=? and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();
line="1011";

 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//System.out.println("1021 Count "+count);

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

double openingQty=0;
double financialQty=0;
double openingLocalPrice=0;
double openingDollarPrice=0;

c=0;
while(rs_g.next())
		{
		double tempQty=rs_g.getDouble("Quantity");
		financialQty+=tempQty;

		if(rs_g.getBoolean("Receive_Sell") && rs_g.getBoolean("Purchase") && rs_g.getBoolean("Opening_Stock"))
			{
			openingQty+=rs_g.getDouble("Available_Quantity");
			}
		else
			{
			openingQty+=tempQty;
			}
		//	rs_g.getDouble("Available_Quantity");

		openingLocalPrice+=rs_g.getDouble("Local_Price");
		openingDollarPrice+=rs_g.getDouble("Dollar_Price");
		c++;
		}
		pstmt_g.close();



//add the other consignment transactions to the opening quantity
query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and (R.purchase=0  or (R.purchase=1 and RT.Consignment_ReceiveId <>0)) and RT.Active=1 and RT.Lot_id="+rlotid+" and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();
line="1055";

 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//System.out.println("1060 Count "+count);
String receive_id[]= new String[count];
String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
int Consignment_ReceiveId[]= new int[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		receive_id[c]=rs_g.getString("Receive_Id");
		Consignment_ReceiveId[c]=rs_g.getInt("Consignment_ReceiveId");

//System.out.println("1081 receive_id[c]"+c+":"+receive_id[c]);

		lotid[c]=rs_g.getString("Lot_id");
//		qty[c]=rs_g.getDouble("Available_Quantity");
		qty[c]=rs_g.getDouble("Quantity");
		//System.out.println("1081 Available Qty"+c+":"+qty[c]);
		localprice[c]=rs_g.getDouble("Local_Price");
		dollarprice[c]=rs_g.getDouble("Dollar_Price");

		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
		
		
		c++;
		}
		pstmt_g.close();
//C.returnConnection(cong);
line="1091";
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
 double rate=0;
String status="";
int k=0;
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
if(
	(lot_id[i].equals(lotid[j]))
	&
		(
		("1".equals(receive_sell[j]))&(("0".equals(purchase[j])))
		||
		(("0".equals(receive_sell[j]))& 
		("1".equals(purchase[j])& Consignment_ReceiveId[j] !=0))
		) 
  )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
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

else if

(
	(lot_id[i].equals(lotid[j]))
	&
		(
		("0".equals(receive_sell[j]))&(("0".equals(purchase[j])))
		||
		(("1".equals(receive_sell[j]))& 
		("1".equals(purchase[j])& Consignment_ReceiveId[j] !=0))
		) )

	{


 tqty =tqty - qty[j];
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


	
//rate=local_price[i];
}

/*double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;*/


line="1210";
for(int i=0; i< counter; i++)
{
if(rlotid.equals(lot_id[i]))
	{
	carats[i]+=openingQty-financialQty;
	status =""+ carats[i];
	status=status + "/" + local_price[i];
	status= status + "/"+ dollar_price[i];

	}
}

//System.out.println("Before return");
return status;
}
catch(Exception Samyak109)
	{//C.returnConnection(cong);
System.out.println("Line :"+line+" Physical Stock Status Exception : "+Samyak109);
return "";
	}
//finally{C.returnConnection(cong); }

	}//Physical Stock Status



public String locationStockStatus(Connection con,java.sql.Date D1,String company_id, String rlotid, String location_id,String yearend_id)
{
try{
		//cong=C.getConnection();

String query="";
query="Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
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

pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();

query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.Purchase=1 and RT.Lot_id="+rlotid+" and RT.Location_Id="+location_id+" and R.receive_id=RT.receive_id and R.yearend_id=?  order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		lotid[c]=rs_g.getString("Lot_id");
		qty[c]=rs_g.getDouble("Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		
		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
		
		
		c++;
		}
		pstmt_g.close();
//C.returnConnection(cong);

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
 double rate=0;
String status="";
int k=0;
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
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
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


 tqty =tqty - qty[j];
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
//rate=local_price[i];
}

/*double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;*/
for(int i=0; i< counter; i++)
{
if(rlotid.equals(lot_id[i]))
	{
status =""+ carats[i];
status=status + "/" + local_price[i] ;
 status= status + "/"+ dollar_price[i] ;

	}
}


return status;
}catch(Exception Samyak109){//C.returnConnection(cong);
 System.out.println("Exception : "+Samyak109);
 return "";
	}
//finally{C.returnConnection(cong); }

	}//Location Stock Status



//start of method for getting physical stock status locationwise
public String locationPhysicalStockStatus(Connection con,java.sql.Date D1,String company_id, String rlotid, String location_id,String yearend_id)

{
String line="955";
try{
		//cong=C.getConnection();

String query="";
query="Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();
line="965";
int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
int counter =count;

String lot_id[]= new String[count];
String lot_no[]= new String[count];
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
//System.out.println("SS");

line="988";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,rlotid); 
pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();
line="993";
int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();

//get the opening physical stock
query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and R.Receive_Sell=1 and Opening_Stock=1 and R_Return=0 and RT.Active=1 and RT.Lot_id="+rlotid+" and RT.Location_id="+location_id+" and R.receive_id=RT.receive_id and R.yearend_id=? and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();
line="1011";

 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//System.out.println("1021 Count "+count);

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

double openingQty=0;
double financialQty=0;
double openingLocalPrice=0;
double openingDollarPrice=0;

c=0;
while(rs_g.next())
		{
		double tempQty=rs_g.getDouble("Quantity");
		financialQty+=tempQty;
		openingQty+=tempQty;
		//financialQty+=rs_g.getDouble("Quantity");
		//openingQty+=rs_g.getDouble("Available_Quantity");
		openingLocalPrice+=rs_g.getDouble("Local_Price");
		openingDollarPrice+=rs_g.getDouble("Dollar_Price");
		c++;
		}
		pstmt_g.close();



//add the other consignment transactions to the opening quantity
query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and (R.purchase=0  or (R.purchase=1 and RT.Consignment_ReceiveId <>0)) and RT.Active=1 and RT.Lot_id="+rlotid+" and RT.Location_id="+location_id+" and R.receive_id=RT.receive_id order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
//pstmt_g.setString(3,yearend_id); 
rs_g = pstmt_g.executeQuery();
line="1055";

 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//System.out.println("1060 Count "+count);
String receive_id[]= new String[count];
String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
int Consignment_ReceiveId[]= new int[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
//	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		receive_id[c]=rs_g.getString("Receive_Id");
		lotid[c]=rs_g.getString("Lot_id");
		qty[c]=rs_g.getDouble("Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		Consignment_ReceiveId[c]=rs_g.getInt("Consignment_ReceiveId");

//System.out.println("1081 receive_id[c]"+c+":"+receive_id[c]);
		
		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
		
//		qty[c]=rs_g.getDouble("Available_Quantity");
		
		//System.out.println("1081 Available Qty"+c+":"+qty[c]);
		
		c++;
		}

		//System.out.println("1682c= "+c);
		pstmt_g.close();
//C.returnConnection(cong);
line="1091";
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
 double rate=0;
String status="";
int k=0;
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
if(
	(lot_id[i].equals(lotid[j]))
	&
		(
		("1".equals(receive_sell[j]))&(("0".equals(purchase[j])))
		||
		(("0".equals(receive_sell[j]))& 
		("1".equals(purchase[j])& Consignment_ReceiveId[j] !=0))
		) 
  )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
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

else if

(
	(lot_id[i].equals(lotid[j]))
	&
		(
		("0".equals(receive_sell[j]))&(("0".equals(purchase[j])))
		||
		(("1".equals(receive_sell[j]))& 
		("1".equals(purchase[j])& Consignment_ReceiveId[j] !=0))
		) )

	{


 tqty =tqty - qty[j];
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


	
//rate=local_price[i];
}

/*double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;*/


line="1210";
for(int i=0; i< counter; i++)
{
if(rlotid.equals(lot_id[i]))
	{
	carats[i]+=openingQty-financialQty;
	status =""+ carats[i];
	status=status + "/" + local_price[i];
	status= status + "/"+ dollar_price[i];

	}
}


return status;
}
catch(Exception Samyak109)
	{//C.returnConnection(cong);
System.out.println("Line :"+line+" Physical Stock Status Exception : "+Samyak109);
return "";
	}
//finally{C.returnConnection(cong); }

	}//Location Physical Stock Status


//method to get the dollar value of the Stock Value method only change needed to get dollar values are done irrespective of the variable names
public double stockValueDollar(Connection con, java.sql.Date D1,String company_id, String type,int d, String condition, String yearend_id)
{
String errLine = "673";
try{
		//cong=C.getConnection();

String query="";
if("Opening".equals(type)){
	query="Select * from Lot where created_on < ?  and Company_id=? and Active=1  "+condition+" order by Lot_id";
}
else{
	query="Select * from Lot where created_on <= ?  and Company_id=? and Active=1  "+condition+" order by Lot_id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

int count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
errLine = "695";
int counter =count;
String lot_id[]= new String[count];
String lot_no[]= new String[count];
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

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		c++;
		}
		pstmt_g.close();
errLine = "726";
if("Closing".equals(type)){
	//Start : dynamically getting nextyearend_id
	YearEndDate YED = new YearEndDate();
	GetDate GD = new GetDate();
	String Fyear = YED.returnCurrentFinancialYear(con , pstmt_p, rs_g, yearend_id, company_id);

	StringTokenizer splityear = new StringTokenizer(Fyear,"#");
	String tempFromDate = (String)splityear.nextElement();
	String tempToDate = (String)splityear.nextElement();

	StringTokenizer enddate = new StringTokenizer(tempToDate,"-");
	
	int endyear=Integer.parseInt((String)enddate.nextElement());
	int endmonth=Integer.parseInt((String)enddate.nextElement());
	String endday= (String)enddate.nextElement();
	StringTokenizer splitendday = new StringTokenizer(endday," ");
	int splittedendday = Integer.parseInt((String)splitendday.nextElement());

	//created new dates for next financial year from the current year end date
	java.sql.Date newFinancialYearStart = new java.sql.Date( endyear-1900, endmonth-1, splittedendday+1);
	java.sql.Date newFinancialYearEnd = new java.sql.Date( endyear+1-1900 , endmonth-1, splittedendday);


	String ys = GD.format(newFinancialYearStart);
	String yd = GD.format(newFinancialYearEnd);

	//System.out.println(ys+" : "+yd);
	query = "Select yearend_id from YearEnd where From_Date=? and To_Date=? and Company_Id="+company_id;
	
	//System.out.println(query);
	pstmt_p = con.prepareStatement(query);
	//pstmt_p.setString(1,ys);
	//pstmt_p.setString(2,yd);
	pstmt_p.setDate(1,newFinancialYearStart);
	pstmt_p.setDate(2,newFinancialYearEnd);
	//pstmt_p.setString(3,company_id);
	rs_g = pstmt_p.executeQuery();

	if(rs_g.next())  {
		yearend_id = rs_g.getString("yearend_id");
	}
	pstmt_p.close();
	//End : dynamically getting nextyearend_id
}
errLine = "771";
//System.out.println("YearEnd Id : "+yearend_id);


if("Opening".equals(type))	{
	query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
}
else{
	query="Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
}
pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,yearend_id);
rs_g = pstmt_g.executeQuery();


 count=0;            
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

//System.out.println("Count = "+count);
errLine = "796";

String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];

pstmt_g = con.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,yearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;
while(rs_g.next())
		{
		lotid[c]=rs_g.getString("Lot_id");
		qty[c]=rs_g.getDouble("Quantity");
		//qty[c]=rs_g.getDouble("Available_Quantity");
		//System.out.println("Qty of "+c+" is ="+qty[c]);
		localprice[c]=rs_g.getDouble("Local_Price");
		//System.out.println("Price of "+c+" is ="+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		
		receive_sell[c]=rs_g.getString("receive_sell");
		purchase[c]=rs_g.getString("purchase");
				
		c++;
		}
		pstmt_g.close();
errLine = "826";
//C.returnConnection(cong);
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
if((lot_id[i].equals(lotid[j]))&("1".equals(receive_sell[j]))&("1".equals(purchase[j])) )
	{
 tqty_temp =tqty;
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;
localp=0;

tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
if(0==(tqty_temp + qty[j]))
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


 tqty =tqty - qty[j];
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
 

 errLine = "933";
 
 
 pcarats[i]=0;
 plocal_price[i]=0;
 pdollar_price[i]=0;
 ccarats[i]=0;
 clocal_price[i]=0;
 cdollar_price[i]=0;

}

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
 tqty +=qty[j];
 tqty=str.mathformat(tqty,3);

dollarp_temp=dollarp;
 dollarp=0;
 localp_temp= localp;

localp=0;
tqty_temp=str.mathformat(tqty_temp,3);
qty[j]=str.mathformat(qty[j],3);
if(0==(tqty)  || (tqty_temp + qty[j]==0))
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


 tqty =tqty - qty[j];
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

}
double total=0;
double local_total=0;
double dollar_total=0;
double dollar_subtotal=0;
double local_subtotal=0;
for(int i=0; i< counter; i++)
{
/*To handle exponent value start*/
/*if(carats[i]<0)
	{if((carats[i])> -0.001 )
		{carats[i]=0.0;}
	}else{if(carats[i]<0.001){carats[i]=0.0;}}*/
/*To handle exponent value End*/

total += carats[i];
 dollar_subtotal=dollar_price[i] * carats[i];
local_subtotal=carats[i] * local_price[i];
local_total +=str.mathformat(local_subtotal,d);
 dollar_total +=dollar_subtotal;
}

errLine = "1040";
return dollar_total;
}catch(Exception Samyak109)
	{
	System.out.println("YearEndStock method stockValueDollar Samyak 109 : " +Samyak109 +" after Line:"+errLine);
	return 0;
	}
//finally{C.returnConnection(cong); }

	}//stockValueDollar




	public static void main(String[] args) throws Exception
	{

		//Stock l = new Stock();
	
	}
}

