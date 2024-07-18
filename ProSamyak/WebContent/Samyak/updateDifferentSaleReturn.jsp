<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<%
//Use it only before yearend


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
		 out.println("<font color=red> FileName : 	getDifferentRTs.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


try{
String command=request.getParameter("command");

if(command.equals("Nippon05")){

java.sql.Date D = new java.sql.Date(105,2,30);

java.sql.Date D1 = new java.sql.Date(104,3,1);
java.sql.Date D2 = new java.sql.Date(104,9,15);
String query="";

query="Select * from  Receive  where  Purchase=0 and Receive_Sell=0 and [return]=0 and Receive_Date between ? and ? and Company_id=? and Active=1"; 


pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
pstmt_g.setString(3,"1");  //for the company Classic of japan
rs_g = pstmt_g.executeQuery();	
int count=0;
while(rs_g.next())
	{count++;}pstmt_g.close();
//out.print("<br>count=" +count);
java.sql.Date receive_date[]= new java.sql.Date[count]; 
java.sql.Date due_date[]= new java.sql.Date[count];  
int receive_id[]=new int[count];
String receive_no[]=new String[count];
String sold_toid[]=new String[count];
String party_id[]=new String[count];
//double qty[]=new double[count];
double av_qty[]=new double[count];
double rt_qty[]=new double[count];
double soldqty[]=new double[count];
double total[]=new double[count];
double final_total[]=new double[count];
double cgt_total[]=new double[count];

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+D1);
	pstmt_g.setString(2,""+D2);	
	pstmt_g.setString(3,"1"); 
	rs_g = pstmt_g.executeQuery();	
	int c=0;
	while(rs_g.next())
		{
	
		receive_id[c]=rs_g.getInt("receive_id");
		receive_no[c]=rs_g.getString("receive_no");
		receive_date[c]=rs_g.getDate("Receive_Date");
		due_date[c]=rs_g.getDate("Due_Date");
		party_id[c]=sold_toid[c]= rs_g.getString("Receive_FromId");
		//qty[c]=rs_g.getDouble("Receive_Quantity");
		cgt_total[c]=rs_g.getDouble("Local_Total");
		c++;
	}
pstmt_g.close();

/*
int count=1;
int c=0;
String query="";
int receive_id[]=new int[count];
receive_id[0]=11919;
*/

c=0;
for(int k=0; k<count; k++)
	{
	query="Select * from receive_transaction where Active =1  and  receive_id=? ";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+receive_id[k]); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
		{c++;}
	pstmt_g.close();

	
	int counter=c;
	String lot_id[]=new String[counter];
	int receiveid[]=new int[counter];
	int rt_id[]=new int[counter];
	double quantity[]=new double[counter];
	double avl_qty[]=new double[counter];
	double rtn_qty[]=new double[counter];
	double tracked_rtn_qty[]=new double[counter];
	double local[]=new double[counter];
	String location_id[]=new String[counter];
	double local_price[]=new double[counter];
	String R_Date[]=new String[counter];

	c=0;
	query="Select * from receive_transaction as RT, receive as R where R.Active =1 and RT.Active  and  RT.receive_id=? and R.Receive_Id=RT.Receive_Id";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+receive_id[k]); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		rt_id[c]=rs_g.getInt("receivetransaction_id");
		receiveid[c]=rs_g.getInt("receive_id");
		quantity[c]=rs_g.getDouble("Quantity");
		avl_qty[c]=rs_g.getDouble("Available_Quantity");
		rtn_qty[c]=rs_g.getDouble("Return_Quantity");
		local_price[c]=rs_g.getDouble("local_price");
		lot_id[c]=rs_g.getString("lot_id");
		location_id[c]=rs_g.getString("Location_Id");
		R_Date[c]=rs_g.getString("Receive_Date");
		c++;
	}
	pstmt_g.close();
	

	boolean cgtsaleret = false;
	int z=0;
	for(int i=0; i<counter; i++)
	{	
		query="Select sum(Quantity) as returnQty from Receive as R, Receive_Transaction as RT where RT.Consignment_ReceiveId="+rt_id[i]+" and RT.lot_id="+lot_id[i]+" and R.Receive_Sell=1 and R.Purchase=0 and R.Return=1 and R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1";

		pstmt_p = conp.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next())
		{
			tracked_rtn_qty[i] = rs_p.getDouble("returnQty");
		}
		pstmt_p.close();

		if(tracked_rtn_qty[i] != rtn_qty[i])
		{
			out.print("<br>"+z+" Receive_Id:"+receiveid[i]);
			out.print("&nbsp;&nbsp;&nbsp;Date:"+R_Date[i]);
			out.print("&nbsp;&nbsp;&nbsp;ReceiveTransaction_Id:"+rt_id[i]);
			out.print("&nbsp;&nbsp;&nbsp;Lot_Id:"+lot_id[i]);
			out.print("&nbsp;&nbsp;&nbsp;Quantity:"+quantity[i]);
			out.print("&nbsp;&nbsp;&nbsp;Return Quantity:"+rtn_qty[i]);
			out.print("&nbsp;&nbsp;&nbsp;Tracked Returned Qty 	:"+tracked_rtn_qty[i]);
			z++;
			cgtsaleret=true;
		}//end of not equal check
	}//for
	
		
	//get the lots that are to be returned in a array and then make a cgt sale return against them
	int receive_lot = z;
	int return_subtotal = z;
	double local_total=0;
	double dollar_total=0;


	String cgtsalereturn_lot_id[] = new String[z];
	String cgtsalereturn_rt_id[] = new String[z];
	String cgtsalereturn_location_id[] = new String[z];
	double cgtsalereturn_qty[] = new double[z];
	double cgtsalereturn_rate[] = new double[z];
	double cgtsalereturn_price[] = new double[z];
	double cgtsalereturn_returnQty[] = new double[z];
	int y=0;
	for(int i=0; i<counter; i++)
	{	
		if(tracked_rtn_qty[i] != rtn_qty[i])
		{
			cgtsalereturn_lot_id[y] = lot_id[i];
			out.print("<br>192 cgtsalereturn_lot_id["+y+"]"+cgtsalereturn_lot_id[y]);
			cgtsalereturn_rt_id[y] = ""+rt_id[i];
			out.print("<br>194 cgtsalereturn_rt_id["+y+"]"+cgtsalereturn_rt_id[y]);
			cgtsalereturn_location_id[y] = location_id[i];
			cgtsalereturn_qty[y] = rtn_qty[i];
			cgtsalereturn_rate[y] = local_price[i];
			cgtsalereturn_returnQty[y] = rtn_qty[i] - tracked_rtn_qty[i];
			cgtsalereturn_price[y] = cgtsalereturn_returnQty[y] * local_price[i];
			local_total += cgtsalereturn_price[y];
			y++;
		}//end of not equal check
		
	}//for
	dollar_total = local_total / 110;  //exchange rate taken as 110.00
	
	
	//conp.setAutoCommit(false);

	String t_currency=A.getNameCondition(cong,"Master_CompanyParty","Transaction_Currency","where CompanyParty_Id="+party_id[k]);
	String currency_id= I.getLocalCurrency(conp,"1");
	String companyparty_name = A.getNameCondition(cong,"Master_CompanyParty","CompanyParty_Name","where CompanyParty_Id="+party_id[k]);
	double exchange_rate=110;
	String ctax="0";

	String return_invoice_no="A"+Voucher.getAutoNumber(cong,18,t_currency,"1");
	String Receive_id_new= ""+L.get_master_id(cong,"Receive");
	String Receive_id_return=Receive_id_new;
	//out.print("<br>222 cgtsaleret="+cgtsaleret);
	
	if(cgtsaleret)
	{
		out.print("<br>Inserting into Receive");
	query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_Quantity, Receive_CurrencyId, Exchange_Rate, Receive_ExchangeRate,   Tax,Discount, Receive_Total, Local_Total,  Dollar_Total, Receive_FromId, Receive_FromName, Company_Id,         Receive_ByName, Receive_Internal, Purchase, Due_Days,     Due_Date, SalesPerson_id, Consignment_ReceiveId, Modified_On,   Modified_By, Modified_MachineName, Stock_Date, InvTotal,        InvLocalTotal,InvDollarTotal,[Return],receive_sell,cgt_returnconfirm,YearEnd_Id,CgtRef_No,CgtDescription) values (?,?,'"+D+"',?         ,? ,?,?,?       ,? ,?,?,?      ,?,?,?,?      ,?,?,?,? ,'"+D+"' ,?, ?, '"+D+"',      ?,?,'"+D+"',?     ,?,?,?,?,    ?,?,?,?)";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString (1, Receive_id_new);
	pstmt_p.setString (2,return_invoice_no);	
	pstmt_p.setString (3,""+receive_lot);
	pstmt_p.setString (4,""+return_subtotal);
	pstmt_p.setString (5,""+currency_id);	
	pstmt_p.setString (6,""+exchange_rate); 
	pstmt_p.setString (7, ""+exchange_rate);
	pstmt_p.setString (8,""+ctax);//tax		
	pstmt_p.setString (9,"0");	//discount
	pstmt_p.setString (10, ""+local_total); //sum of qty of lots 
	pstmt_p.setString (11, ""+local_total);	//sum of qty of lots
	pstmt_p.setString (12, ""+dollar_total);	//sum of qty of lots divide by 110
	pstmt_p.setString (13, party_id[k]);//Receive_FromId	
	pstmt_p.setString (14,""+ companyparty_name);	//Receive_FromName	
	pstmt_p.setString (15,"1");	//company_id
	pstmt_p.setString (16,"fsd");		//receive_byName
	pstmt_p.setBoolean (17, false);	//Receive_Internal	
	pstmt_p.setBoolean (18, false);	//Purchase	
	pstmt_p.setString (19, "0");//due Days	
	pstmt_p.setString (20, "0");	//sale persoanid
	pstmt_p.setString (21,""+receive_id[k]);//Consignment_ReceiveId	
	pstmt_p.setString (22, ""+5);		
	pstmt_p.setString (23, "Samyak2");			
	pstmt_p.setString (24,""+local_total);		
	pstmt_p.setString (25,""+local_total);	
	pstmt_p.setString (26,""+dollar_total);	
	pstmt_p.setBoolean (27, true);	//Return
	pstmt_p.setBoolean (28, true);	//Receive_sell
	pstmt_p.setString (29,"0");	
	pstmt_p.setString (30,"1"); //1st yearend id given for fsd	
	pstmt_p.setString (31,"Samyaks ACSR");	
	pstmt_p.setString (32,"Samyaks ACSR");	

	int a224 = pstmt_p.executeUpdate();
	pstmt_p.close();


	//no of lot in Perticular Purchase i.e.Entry in Receive no  of enter in RT

	int Receivetransaction_id= L.get_master_id(cong,"Receive_Transaction");

	for(int n=0; n < receive_lot; n++)
	{
		double qty=cgtsalereturn_returnQty[n];//Return Quantity
		String rt_lot_id=cgtsalereturn_lot_id[n] ;
		out.print("<br>273 rt_lot_id["+n+"]"+rt_lot_id);
		double orignal_rate=local_price[n];

		String pcs= "0";
		String rt_location_id= cgtsalereturn_location_id[n];
		String remarks="Samyaks ACSR";

		String receivetransaction_id= cgtsalereturn_rt_id[n];
		out.print("<br>273 receivetransaction_id["+n+"]"+receivetransaction_id);
			
		double rt_local_price=0;
		double rt_dollar_price=0;
		rt_local_price=orignal_rate;
		rt_dollar_price=rt_local_price / exchange_rate;
		//-----------------------Insert Into RT Against Return-------------------
		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Quantity, Available_Quantity, Receive_Price, Local_Price,     Dollar_Price,Pieces,Remarks ,Modified_On,   Modified_By, Modified_MachineName, Location_Id,Consignment_ReceiveId,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,?,?,'"+D+"', ?,? ,?,?,?)";


		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setInt(1,(Receivetransaction_id));	
		pstmt_p.setString (2,Receive_id_new);	
		pstmt_p.setString (3, ""+n);
		pstmt_p.setString (4,rt_lot_id);	
		pstmt_p.setString (5,""+qty);	//quantity
		pstmt_p.setString (6, ""+qty);	//Available_Quantity
		pstmt_p.setString (7,""+orignal_rate);
		pstmt_p.setString (8,""+rt_local_price);
		pstmt_p.setString (9, ""+rt_dollar_price);	
		pstmt_p.setString (10, ""+pcs);	//pices
		pstmt_p.setString (11,""+remarks);	
		pstmt_p.setString (12, ""+5);
		pstmt_p.setString (13, "Samyak2");	
		pstmt_p.setString (14, rt_location_id);	
		pstmt_p.setString (15,""+receivetransaction_id);	
		pstmt_p.setString (16,"1");	


		int a245 = pstmt_p.executeUpdate();



		//out.print("<br>------------------------Now Insert Compled and  Update Start Here For Return");
 
		 query="Select Carats,Available_Carats from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,rt_lot_id); 
		pstmt_p.setString(2,rt_location_id); 
		pstmt_p.setString(3,"1"); 
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

		phycarats = phycarats + qty;
		query="Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_By=?, Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+fincarats); 
		pstmt_p.setString(2,""+phycarats); 
		pstmt_p.setString (3, ""+5);		
		pstmt_p.setString (4, "Samyak");		
		pstmt_p.setString(5,rt_lot_id); 
		pstmt_p.setString(6,rt_location_id); 
		pstmt_p.setString(7,"1"); 
		int a417 = pstmt_p.executeUpdate(); 
		pstmt_p.close(); 
		
		Receivetransaction_id++;

	}//end for of RT

	//conp.commit();
	out.print("<br><font color=red>Consignment Sale returned="+Receive_id_new+"</font><br>");	
	}

}//for
out.print("<br><b>Successfull</b><br>");	
	
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
  //conp.rollback();
  C.returnConnection(cong);
  C.returnConnection(conp);
  out.println("<font color=red> FileName : updateDifferentRreturn.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
