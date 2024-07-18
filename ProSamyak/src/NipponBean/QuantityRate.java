package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  QuantityRate{
	
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connection conp = null;
	ResultSet rs_p=null;
	PreparedStatement pstmt_p=null;
	Connect C;
	NipponBean.Array A;
    getYearEndIds GY;
    YearEndDate YED;
    YearEndStock YES; 
    str str1;
    format format1;
///Start close1
	public	QuantityRate()
		{
			try{
		
		
		  C = new Connect();
		  
		  A=new NipponBean.Array();

          GY=new getYearEndIds();
	    
		  YED=new YearEndDate();
	    
		  YES= new YearEndStock();
	    
		  str1=new str();
	     
		  format1=new format();



		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}
		}


//end of close 1





public String ClosingQuantityRate(Connection con,java.sql.Date D1,String company_id,String lot_id,String reportyearend_id)
{

int lot_id1=Integer.parseInt(lot_id);

//System.out.println("\n");
//System.out.println("\n"+"62  lot_id  =>"+lot_id1);
//System.out.println("\n"+"63  D1 =>"+D1);
//System.out.println("\n"+"64 company_id  =>"+company_id);
//System.out.println("\n"+"65 reportyearend_id  =>"+reportyearend_id);


int d=2;
int c,count=0;

String query="";
String line="";
/*
//lot details fetched here
try{
query="Select * from Lot where created_on <= ?  and Company_id=? "; 

      


pstmt_g = con.prepareStatement(query);
pstmt_g.setDate(1,D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();

// count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();


}catch(Exception e)
		{
			System.out.print("Exception in First Query  :" +e);
		}
//out.print("<br>120 count:" +count);

//int counter =count;
//String lot_id[]= new String[count];


*/






String lot_no="";
String uom="";
double carats=0;
double local_price=0;
double dollar_price=0;
double pcarats=0;
double plocal_price=0;
double pdollar_price=0;
double ccarats=0;
double clocal_price=0;
double cdollar_price=0;
double per_carats=0;
double sale_carats=0;
double per_ccarats=0;
double sale_ccarats=0;

double ConfirmPurQty=0;
double ConfirmSaleQty=0;
double gross=0;
double gross_purchase=0;
double gross_sale=0;
double gross_pur_qty=0;
double gross_sale_qty=0;


//System.out.println("\n");
//System.out.println("line 137 ");

/*


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

double ConfirmPurQty[]=new double[count];
double ConfirmSaleQty[]=new double[count];

double gross[]=new double[count];
double gross_purchase[]=new double[count];
double gross_sale[]=new double[count];
double gross_pur_qty[]=new double[count];
double gross_sale_qty[]=new double[count];
*/
/*

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setDate(1,D1);
	pstmt_g.setString(2,company_id); 
	rs_g = pstmt_g.executeQuery();

int c=0;
while(rs_g.next())
		{
		//lot_id[c]=rs_g.getString("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		uom[c]=A.getName(cong,"Unit",rs_g.getString("Unit_id"));
		c++;
		}
		pstmt_g.close();
//out.print("<br>201");

// relation betn receieve and recieve transaction

*/






try{
//System.out.println("\n");
//System.out.println("Line no. 172 Start of first query");
//System.out.println("\n");
//System.out.println(" line 198 ");
//System.out.println("\n");

query="Select RT.ReceiveTransaction_Id, RT.Consignment_ReceiveId,RT.Lot_id, R.purchase, R.receive_sell, R.R_Return, R.Opening_Stock,  RT.Available_Quantity, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total from  Receive R, Receive_Transaction RT where  R.Stock_Date <= ? and R.Company_id=? and R.Active=1  and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id = ? and RT.Lot_id="+lot_id1+" order by R.Stock_Date, R.Receive_Sell, R.Receive_Id,RT.ReceiveTransaction_id";


//System.out.println("\n");
//System.out.println("205 lot_id1 "+lot_id1);
//System.out.println("\n");
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,reportyearend_id); 
//System.out.println(" line no. 211.");
rs_g = pstmt_g.executeQuery();

   count=0;
	//System.out.println("\n");
	//System.out.println("188   Count "+count);
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();

//System.out.println("\n");

//System.out.println("line no.225 ");

//System.out.println("227  count =>" +count);

}catch(Exception e)
		{

			//System.out.println("\n");
			//System.out.println("Exception line no. 233  :" +e);
			
			//System.out.print("Exception in Second query on Line 188 :" +e);
		   //System.out.println("\n");
		
		}
/*
String lotid="";
String purchase="";	
String receive_sell="";	
String returned="";	
String opening_stock="";	

double localprice=0;
double dollarprice=0;
double qty=0;
double available_qty=0;
int  Consignment_ReceiveId=0;
int RT_Id;
int R_Id;	
		
	*/	


	int counter =count;
		
	//line=""+231;	
String lotid[]= new String[count];
String purchase[]= new String[count];
String receive_sell[]= new String[count];
String returned[]= new String[count];
String opening_stock[]= new String[count];
double localprice[]=new double[count];
double dollarprice[]=new double[count];
double qty[]=new double[count];
double available_qty[]=new double[count];

int Consignment_ReceiveId[]=new int[count];
int RT_Id[]=new int[count];
int R_Id[]=new int[count];


//System.out.print("\n");
//System.out.print(" line no.  276");
//System.out.print("\n");
double rec_total[]=new double[count];
try{
//System.out.print(" line no.  280");
pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,reportyearend_id); 
	rs_g = pstmt_g.executeQuery();
//System.out.print("\n");
//System.out.print(" line no.  287");
//System.out.print("\n");
c=0;
while(rs_g.next())
		{
		RT_Id[c]=rs_g.getInt("ReceiveTransaction_Id");
		//System.out.println("1.292 RT_Id[c]"+RT_Id[c]);
		
		
	receive_sell[c]=rs_g.getString("receive_sell");	
opening_stock[c]=rs_g.getString("Opening_Stock");	Consignment_ReceiveId[c]=rs_g.getInt("Consignment_ReceiveId");
		//System.out.println("2.294 Consignment_ReceiveId[c]"+Consignment_ReceiveId[c]);
		
		
		rec_total[c]=rs_g.getDouble("Receive_Total");
		
		purchase[c]=rs_g.getString("purchase");
		//System.out.println("3.297 purchase[c]"+purchase[c]);
		
		
//System.out.println("4.300 receive_sell[c]"+receive_sell[c]);
		returned[c]=rs_g.getString("R_Return");
		//System.out.println("5.302 returned[c]"+returned[c]);
		
		//System.out.println("6.304 opening_stock[c]"+opening_stock[c]);

		lotid[c]=rs_g.getString("Lot_id");
		//System.out.println("7.307 lotid[c]"+lotid[c]);
		
		qty[c]=rs_g.getDouble("Quantity");
		available_qty[c]=rs_g.getDouble("Available_Quantity");
		//System.out.println("8.308 available_qty[c]"+available_qty[c]);
		
		
		//System.out.println("9.312 qty[c]"+qty[c]);
		localprice[c]=rs_g.getDouble("Local_Price");
	//System.out.println("10.314 localprice[c]"+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		//System.out.println("11.315 dollarprice[c]"+dollarprice[c]);
		
		
		
		//System.out.println("12.320 rec_total[c]"+rec_total[c]);
		c++;
		}
		pstmt_g.close();
	//C.returnConnection(cong);
}catch(Exception e){
   //System.out.println("\n");
    //System.out.println("line no. 319 ");

	System.out.println("Error on line  321"+e);
    //System.out.println("\n");
  }

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


//System.out.println("\n");
//System.out.println("line no. 345 ");
//System.out.println("\n");
//System.out.println("355 counter => "+counter);
for(int i=0; i< counter; i++)
	{
	//System.out.println("\n");
	//System.out.println("line no. 358 ");
	//System.out.println("\n");
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
//System.out.println("377 count => "+count);
//System.out.println("378 J's value "+j);
while(j<count)
{
	//System.out.println("\n");
//System.out.println("381 count => "+count);
//System.out.println("\n");

	if((lot_id.equals(lotid[j]))&("1".equals(receive_sell[j]))& 		("1".equals(purchase[j])) )//Financial Purchase 
	{
	tqty_temp =tqty;
	
	
	if( (Consignment_ReceiveId[j] != 0)  )
		{
		 ConfirmPurQty += qty[j];
		 qty[j]=0;
		}
	if("1".equals(opening_stock[j]))
		{
			tqty +=available_qty[j];
			//out.print("<br>Opening "+available_qty[j]);
			gross_pur_qty+=available_qty[j];
		}
	else
		{
			tqty +=qty[j];
			//out.print("<br>Purchase "+qty[j]);
			gross_pur_qty+=qty[j];
		}
	
	tqty=str.mathformat(tqty,3);
	dollarp_temp=dollarp;
	dollarp=0;
	localp_temp= localp;
	localp=0;
	// gross calci
	gross_purchase +=(qty[j]*localprice[j]);

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
	 per_carats+=qty[j];
	 //out.print("<br> Purchase  lot_id="+lot_id[i]+":RT_ID:"+RT_Id[j]+"qty "+qty[j]);
	} 

else if((lot_id.equals(lotid[j]))&("0".equals(receive_sell[j])) &("1".equals(purchase[j])))
	{

	
	if( (Consignment_ReceiveId[j] != 0))
		{
		 ConfirmSaleQty += qty[j];
		 qty[j]=0;
		}
	//out.print("<br>sale="+qty[j]);
	 tqty =tqty - qty[j];
	
	temp=localprice[j]*qty[j];
	temp1=localp*tqty;
	outwardqty +=qty[j];
	outwardtot +=temp;
	closingdqty +=tqty;
	closingtot +=temp1;
	sale_carats+=qty[j];


	// gross calci
	gross_sale +=(qty[j]*localprice[j]);
	gross_sale_qty+=qty[j];
 //out.print("<br> Sale lot_id="+lot_id[i]+":RT_ID:"+RT_Id[j]+"qty "+qty[j]);
}
j++;
}



 /// start from here 



 carats=tqty;
 //System.out.println("\n");
 //System.out.println(" 474  carats  "+carats);

 try{ 
		new Double(""+localp);
		local_price=localp;
	}catch(Exception e) 
	{
	local_price=0;
	}
 try{ 
		new Double(""+dollarp);
		dollar_price=dollarp;
	}catch(Exception e) 
	{
	dollar_price=0;
	}

//**********start copy 
 pcarats=0;
 plocal_price=0;
 pdollar_price=0;
 ccarats=0;
 clocal_price=0;
 cdollar_price=0;


}




//***************end copy


//start copy 
for(int i=0; i<counter; i++){
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
	//System.out.println("\n");
 //System.out.println("528  lotid[i]"+lotid[i]);
//System.out.println("\n");
try{
	             
	query="Select RT.ReceiveTransaction_Id, RT.Receive_Id, RT.Consignment_ReceiveId, R.purchase, R.receive_sell, R.R_Return, RT.Lot_id, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total, R.Opening_Stock from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and (R.purchase=0  or (R.purchase=1 and RT.Consignment_ReceiveId <>0)) and RT.Active=1 and RT.Lot_id="+lot_id1+" and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 and R.yearend_id=? order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";


pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
pstmt_g.setString(3,reportyearend_id); 

rs_g = pstmt_g.executeQuery();

 count=0;
	while(rs_g.next())
		{
		count++;
		}
		pstmt_g.close();
//out.print("<br>471count=" +count);

//System.out.println("<522> count"+count);


}catch(Exception e){

	//System.out.println("\n");
	System.out.println("Exception on line 528 "+e);
    //System.out.println("\n");
}
try{
	//System.out.println("\n");
	//System.out.println("line 537");
    pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,company_id); 
	pstmt_g.setString(3,reportyearend_id); 
	rs_g = pstmt_g.executeQuery();

c=0;

while(rs_g.next())
		{
		RT_Id[c]=rs_g.getInt("ReceiveTransaction_Id");
		R_Id[c]=rs_g.getInt("Receive_Id");
		receive_sell[c]=rs_g.getString("receive_sell");
		//out.print("<br>R_Id["+c+"]=" +R_Id[c]);
		Consignment_ReceiveId[c]=rs_g.getInt("Consignment_ReceiveId");
		purchase[c]=rs_g.getString("purchase");
//		out.print("<br>purchase=" +purchase[c]);
		
		returned[c]=rs_g.getString("R_Return");
//		out.print("&nbsp;&nbsp;receive_sell=" +receive_sell[c]);

		lotid[c]=rs_g.getString("Lot_id");
 //	out.print("&nbsp;lotid[c]="+lotid[c]);
		//qty[c]=rs_g.getDouble("Available_Quantity");
		qty[c]=rs_g.getDouble("Quantity");
		localprice[c]=rs_g.getDouble("Local_Price");
// 	out.print("&nbsp;localprice[c]="+localprice[c]);
		dollarprice[c]=rs_g.getDouble("Dollar_Price");
		rec_total[c]=rs_g.getDouble("Receive_Total");
		opening_stock[c]=rs_g.getString("Opening_Stock");
		c++;
		}
		pstmt_g.close();
	//C.returnConnection(cong);

}catch(Exception e){

	//System.out.println("\n");
	System.out.println("Exception on line 542 "+e);
}




	while(j<count){
		if(
			(lot_id.equals(lotid[j]))
			&
		    (
		      (("1".equals(receive_sell[j]))&("0".equals(purchase[j]))&("0".equals(returned[j])))
				||
		     (("1".equals(receive_sell[j]))&("0".equals(purchase[j]))&("1".equals(returned[j])))
			)		
		  )
		

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
			per_ccarats+=qty[j];

			gross_purchase +=(qty[j]*localprice[j]);

		}

		else 
		if
		(
		   (lot_id.equals(lotid[j]))
			&
			(
			 (("0".equals(receive_sell[j])) &("0".equals(purchase[j])) &("0".equals(returned[j])))
			   ||
  			 (("0".equals(receive_sell[j])) &("0".equals(purchase[j])) &("1".equals(returned[j])) &("0".equals(opening_stock[j])) )
			)
		)
		
			{

				tqty =tqty - qty[j];
				temp=localprice[j]*qty[j];
				temp1=localp*tqty;
				outwardqty +=qty[j];
				outwardtot +=temp;
				closingdqty +=tqty;
				closingtot +=temp1;
				//gross[i] -=(rec_total[j]);
				sale_ccarats +=qty[j];
			    
				gross_sale +=(qty[j]*localprice[j]);
 

				}

	j++;
	}

//System.out.println("686 per_ccarats"+lot_id1+"="+per_ccarats);
//System.out.println("687 sale_ccarats"+lot_id1+"="+sale_ccarats);

ccarats=tqty;
clocal_price=localp;



if((gross_pur_qty == 0) || (gross_purchase == 0) ||(gross_sale_qty == 0))
	gross=0.0;
else
	gross=( (100 * (gross_sale/gross_sale_qty)) / (gross_purchase/gross_pur_qty) ) - 100;
}




			
////end of copy

	





double amount1=0;
double amount2=0;
double amount3=0;
double amount4=0;
double amount5=0;
double amount6=0;
double amount7=0;
double amount8=0;
double amount9=0;

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

//String flag="";


int s=1;
int srno=1;

/***************


Now

paste

here



*/



//out.print("<br>650 counter : "+counter);
//int counter=count;
//return ""+pcarats+"/"+local_price;

///////
//System.out.println("\n");
//System.out.println("line no : 735  "+"Counter's value ="+counter);
/*for(int t=0; t< counter; t++){*/


total += carats;
subtotal= carats *local_price;
local_total +=str.mathformat(subtotal,d);
csubtotal= ccarats *clocal_price;
//out.print("<br>"+local_price[i]);
clocal_total +=str.mathformat(csubtotal,d);
psubtotal= subtotal+ csubtotal;
pcarats=carats+ccarats;
plocal_total+=str.mathformat(psubtotal,d);
 per_total +=per_carats;
sale_total += sale_carats;
 per_ctotal +=per_ccarats;
 sale_ctotal +=sale_ccarats;
	p_total +=pcarats;

//out.print("<br>680 i : "+i);

try{
local_subtotal=pcarats* local_price;
}catch(Exception e ){System.out.println("Exception on Line 758 "+e);}
try{
dollar_subtotal=pcarats* dollar_price;
}catch(Exception e ){System.out.println("Exception on line 761 "+e);}
//out.print("<br>688 i : "+i);

phylocal_total += str.mathformat(local_subtotal,d);

phydollar_total += str.mathformat(dollar_subtotal,2);
//out.print("<br>693 pcarats[i] : "+pcarats[i]);
///////////////if(str.mathformat(pcarats[i],3)!=0)
	/////////{

//return ""+pcarats+"/"+local_price;

	
 	/*
	
 
			

	  
	//} 
	
	
	
	
	///////////////}


/*}
*/

////////////////////////////////////////////////
	 

//C.returnConnection(cong);

return ""+pcarats+"/"+local_price;
}
}