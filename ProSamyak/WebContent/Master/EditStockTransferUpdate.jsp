<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />



<% 
Connection cong = null;
ResultSet rs_p= null;
ResultSet rs_g= null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_q=null;

try	{
		cong=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}


int user_id= Integer.parseInt(""+session.getValue("user_id"));

String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//String company_name= A.getName("companyparty",company_id);
String local_symbol= I.getLocalSymbol(cong,company_id);
String local_currency= I.getLocalCurrency(cong,company_id);
int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

//out.print("<br>company_id"+company_id);
int StockTransfer_Type = Integer.parseInt(request.getParameter("StockTransfer_Type"));
out.print("<br>StockTransfer_Type ="+StockTransfer_Type);
if(StockTransfer_Type!=6 && StockTransfer_Type!=7)
{

int sReceive_Id = Integer.parseInt(request.getParameter("sReceive_Id"));
//out.print("<br>sReceive_Id ="+sReceive_Id);
int dReceive_Id = Integer.parseInt(request.getParameter("dReceive_Id"));
String stocktransfer_no = request.getParameter("stocktransfer_no");
String description=""+request.getParameter("description");
//out.print("<br> 44 description"+description);
String ref_no=""+request.getParameter("ref_no");
//out.print("<br> 46 ref_no"+ref_no);

int scounter = Integer.parseInt(request.getParameter("scounter"));
//out.print("<br>scounter"+scounter);

int dcounter = Integer.parseInt(request.getParameter("dcounter"));
//out.print("<br>dcounter"+dcounter);

//out.print("<br>StockTransfer_Type ="+StockTransfer_Type);
double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
String stockdate = request.getParameter("stockdate");
String stotalqty = request.getParameter("stotalqty");

double stotalamt = Double.parseDouble(request.getParameter("stotalamt"));
double dtotalamt = Double.parseDouble(request.getParameter("dtotalamt"));
String dtotalqty = request.getParameter("dtotalqty");

double sdollaramt=0;
double ddollaramt=0;
out.print("<br>StockTransfer_Type ="+StockTransfer_Type);
if(exchange_rate>0)
{
	sdollaramt= stotalamt/exchange_rate;
	ddollaramt= dtotalamt/exchange_rate;
}
else
{
	sdollaramt= stotalamt;
	sdollaramt= stotalamt/exchange_rate;
}

//out.print("<br>65 stotalamt ="+stotalamt+"<br> dtotalamt ="+dtotalamt+"<br>sdollaramt="+sdollaramt);


String query="select count(*) as receiveno from Receive where Receive_No = '"+stocktransfer_no+"' and (Receive_Id <>"+sReceive_Id+" and Receive_Id <> "+ dReceive_Id +") and company_id="+company_id;

try
{


pstmt_q=cong.prepareStatement(query);
rs_g= pstmt_q.executeQuery();
int receiveNo =0;

while(rs_g.next())
{
	receiveNo = rs_g.getInt("receiveno");  
}
//out.print("<br>receiveNo"+receiveNo);
pstmt_q.close();


%>
<html>
<HTML>
<HEAD>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body>
<%
	//if(!receiveNo.equals("0"))
 if(receiveNo>=1)
	{
	 C.returnConnection(cong);

%>
<table width="100%" align="center">
<tr align="center">
<td><font color="red">Transfer No. is already present in database.</td>
	</tr>
	<tr>
<td align=center><input type=button name="command" value="Back" onclick="history.go(-2)" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>

</tr>

</table>
<%
	}
String reciveUpdate = "update Receive set Receive_No=?,Receive_Date=?,Stock_Date=?,Exchange_Rate=?,Receive_ExchangeRate=?,Receive_lots=?,Receive_Quantity=?, Receive_Total=?,Local_Total=?,Dollar_Total=? where Receive_Id=?";



pstmt_p = cong.prepareStatement(reciveUpdate);

pstmt_p.setString(1,stocktransfer_no);
pstmt_p.setString(2,""+format.getDate(stockdate));
pstmt_p.setString(3,""+format.getDate(stockdate));
pstmt_p.setString(4,""+exchange_rate);
pstmt_p.setString(5,""+exchange_rate);
pstmt_p.setInt(6,scounter);
pstmt_p.setString(7,stotalqty);
pstmt_p.setString(8,""+stotalamt);
pstmt_p.setString(9,""+stotalamt);
pstmt_p.setString(10,""+sdollaramt);
pstmt_p.setInt(11,sReceive_Id);
//out.print("<br> 141 ");
int a136=pstmt_p.executeUpdate(); 
//out.print("<br> 142 a136"+a136);
pstmt_p.close();

 
pstmt_p = cong.prepareStatement(reciveUpdate);

pstmt_p.setString(1,stocktransfer_no);
pstmt_p.setString(2,""+format.getDate(stockdate));
pstmt_p.setString(3,""+format.getDate(stockdate));
pstmt_p.setString(4,""+exchange_rate);
pstmt_p.setString(5,""+exchange_rate);
pstmt_p.setInt(6,dcounter);
pstmt_p.setString(7,dtotalqty);
pstmt_p.setString(8,""+dtotalamt);
pstmt_p.setString(9,""+dtotalamt);
pstmt_p.setString(10,""+ddollaramt);
pstmt_p.setInt(11,dReceive_Id);

//out.print("<br> 141 ");
//int a136=pstmt_p.executeUpdate(); 

int a153=pstmt_p.executeUpdate();
//out.print("<br> 142 a153"+a153);
pstmt_p.close();
 

	String VoucherUpdate = "update Voucher set Voucher_Date=?,Exchange_Rate=?,Voucher_Total=?,Local_Total=?,Dollar_Total=?,Modified_On=?,Modified_By=?,Modified_MachineName=?,Description=?,Ref_no=? where Voucher_No=?";

	pstmt_p = cong.prepareStatement(VoucherUpdate);

	pstmt_p.setString(1,""+format.getDate(stockdate));
    pstmt_p.setString(2,""+exchange_rate);
	pstmt_p.setString(3,""+stotalamt);
    pstmt_p.setString(4,""+stotalamt);
    pstmt_p.setString(5,""+sdollaramt);
	pstmt_p.setString(6,""+D);
	pstmt_p.setInt(7,user_id);
	pstmt_p.setString(8,machine_name);
    pstmt_p.setString(9,""+description);
	pstmt_p.setString(10,""+ref_no);
	pstmt_p.setInt(11,sReceive_Id);
	
	
	int a170=pstmt_p.executeUpdate();
//out.print("<br> 142 a170 "+a170);
	pstmt_p.close();

	pstmt_p = cong.prepareStatement(VoucherUpdate);

	pstmt_p.setString(1,""+format.getDate(stockdate));
    pstmt_p.setString(2,""+exchange_rate);
	pstmt_p.setString(3,""+dtotalamt);
    pstmt_p.setString(4,""+dtotalamt);
    pstmt_p.setString(5,""+ddollaramt);
	pstmt_p.setString(6,""+D);
	pstmt_p.setInt(7,user_id);
	pstmt_p.setString(8,machine_name);
    pstmt_p.setString(9,""+description);
	pstmt_p.setString(10,""+ref_no);
	//pstmt_p.setInt(11,sReceive_Id);
	pstmt_p.setInt(11,dReceive_Id);
	
//out.print("<br> 142 a185:");

	int a185=pstmt_p.executeUpdate();
//out.print("<br> 142 a185:"+a185);
		pstmt_p.close();


int slotid[] = new int[scounter]; 
int slocation_id[] = new int[scounter]; 
int old_slotid[] = new int[scounter]; 
int old_slocation_id[] = new int[scounter]; 
double sqty[] = new double[scounter]; 
double old_sqty[] = new double[scounter]; 
double old_srate[] = new double[scounter]; 
double srate[] = new double[scounter]; 

double smwa[] = new double[scounter]; 
boolean smwaflag[] = new boolean[scounter]; 
double dollarsmwa[]= new double[scounter]; 

//out.print("<br>");

//{
int sReceiveTransaction_Id[]= new int[scounter]; 

for(int i=0;i<scounter;i++)
{
    srate[i] = Double.parseDouble(request.getParameter("srate"+i));

	old_srate[i] = Double.parseDouble(request.getParameter("old_srate"+i));
//	out.print("srate[i] = "+srate[i]);
//	out.print("old_srate[i] = "+old_srate[i]);

	int temp = 	Integer.parseInt(request.getParameter("smwaflag"+i));
	
	if(temp==1)
	{
		smwaflag[i] = true;	
	}
	else
	{
		smwaflag[i] = false;	
	}
	
//	out.print("smwaflag[i] = "+smwaflag[i]);

	sReceiveTransaction_Id[i] = Integer.parseInt(request.getParameter("sReceiveTransaction_Id"+i));
//	out.print("sReceiveTransaction_Id[i] = "+sReceiveTransaction_Id[i]);

	slotid[i] = Integer.parseInt(request.getParameter("slotid"+i));
//	out.print("slotid[i] = "+slotid[i]);
	slocation_id[i] = Integer.parseInt(request.getParameter("slocation_id"+i));
//	out.print("slocation_id[i] = "+slocation_id[i]);
		old_slotid[i] = Integer.parseInt(request.getParameter("old_slotid"+i));
//		out.print("old_slotid[i] = "+old_slotid[i]);
	old_slocation_id[i] = Integer.parseInt(request.getParameter("old_slocation_id"+i));
//	out.print("old_slocation_id[i] = "+old_slocation_id[i]);
	sqty[i] = Double.parseDouble(request.getParameter("sqty"+i));
//	out.print("sqty[i] = "+sqty[i]);
	old_sqty[i] = Double.parseDouble(request.getParameter("old_sqty"+i));
//	out.print("old_sqty[i] = "+old_sqty[i]);

	smwa[i] = Double.parseDouble(request.getParameter("smwa"+i));
//	out.print("<br>smwa[i]="+smwa[i]);
//	out.print("<br>srate[i]="+srate[i]);
//	out.print("<br>smwaflag[i]="+smwaflag[i]);
	
int flag =0; 
	if(( smwaflag[i]==true ) && (srate[i] == smwa[i]) )
	{
		smwaflag[i] = true;	
		flag = 1;
	}
	else if(( smwaflag[i]==true ) && (srate[i] != smwa[i])  )
	{
	//	out.print("here");
		smwaflag[i] = false;
		smwa[i] = srate[i];
	//	out.print("<br>new smwa[i]="+smwa[i]);
		flag = 1;

	}

	else if(( smwaflag[i]==false ) && (srate[i] == smwa[i]) )
	{
		smwaflag[i] = true;	
		flag = 1;
	}
	else if(( smwaflag[i]==false ) && (srate[i] != smwa[i]) )
	{
	//	out.print("here");
		smwaflag[i] = false;
		smwa[i] = srate[i];
	//	out.print("<br>new smwa[i]="+smwa[i]);
	//	flag = 1;

	}
//	out.print("<br>smwaflag[i]="+smwaflag[i]);

	
//	out.print("smwa[i] = "+smwa[i]);

	 if(exchange_rate>0)
	{
		dollarsmwa[i]= smwa[i]/exchange_rate;

	}
	else
	{
		dollarsmwa[i]= smwa[i];
	}
	
}
//int temp=0;


int dlotid[] = new int[dcounter]; 
int dlocation_id[] = new int[dcounter]; 
int old_dlotid[] = new int[dcounter]; 
int old_dlocation_id[] = new int[dcounter]; 
double dqty[] = new double[dcounter]; 
double old_dqty[] = new double[dcounter]; 
double dmwa[] = new double[dcounter]; 
double old_drate[] = new double[dcounter]; 
double drate[] = new double[dcounter]; 
boolean dmwaflag[] = new boolean[dcounter]; 
double dollardmwa[] = new double[dcounter]; 
//out.print("<br>");
int dReceiveTransaction_Id[]= new int[dcounter]; 

for(int i=0;i<dcounter;i++)
{
      drate[i] = Double.parseDouble(request.getParameter("drate"+i));

	old_drate[i] = Double.parseDouble(request.getParameter("old_drate"+i));
//	out.print("drate[i] = "+drate[i]);
//	out.print("old_drate[i] = "+old_drate[i]);

	int temp = 	Integer.parseInt(request.getParameter("dmwaflag"+i));
	
	if(temp==1)
	{
		dmwaflag[i] = true;	
	}
	else
	{
		dmwaflag[i] = false;	
	}
	
//	out.print("dmwaflag[i] = "+dmwaflag[i]);

	dReceiveTransaction_Id[i] = Integer.parseInt(request.getParameter("dReceiveTransaction_Id"+i));
//	out.print("dReceiveTransaction_Id[i] = "+dReceiveTransaction_Id[i]);
	dlotid[i] = Integer.parseInt(request.getParameter("dlotid"+i));
//	out.print("dlotid[i] = "+dlotid[i]);
	dlocation_id[i] = Integer.parseInt(request.getParameter("dlocation_id"+i));
//	out.print("dlocation_id[i] = "+dlocation_id[i]);
	old_dlotid[i] = Integer.parseInt(request.getParameter("old_dlotid"+i));
//	out.print("old_dlotid[i] = "+old_dlotid[i]);
	old_dlocation_id[i] = Integer.parseInt(request.getParameter("old_dlocation_id"+i));
//	out.print("old_dlocation_id[i] = "+old_dlocation_id[i]);
	dqty[i] = Double.parseDouble(request.getParameter("dqty"+i));
//	out.print("dqty[i] = "+dqty[i]);

	old_dqty[i] = Double.parseDouble(request.getParameter("old_dqty"+i));
//	out.print("old_dqty[i] = "+old_dqty[i]);

	dmwa[i] = Double.parseDouble(request.getParameter("dmwa"+i));

	int flag = 0;
	if(( dmwaflag[i]==true ) && (drate[i] == dmwa[i]) )
	{

		dmwaflag[i] = true;	
		flag = 1;
	}
	else if(( dmwaflag[i]==true ) && (drate[i] != dmwa[i]) && flag!=1 )
	{
		dmwaflag[i] = false;
		dmwa[i] = drate[i];
		flag = 1;
	}
	else if(( dmwaflag[i]==false ) && (drate[i] == dmwa[i]) && flag!=1 )
	{
		dmwaflag[i] = true;	
		flag = 1;
	}
	else if(( dmwaflag[i]==false ) && (drate[i] != dmwa[i]) && flag!=1 )
	{
//		out.print("here");
		dmwaflag[i] = false;
		dmwa[i] = drate[i];
	//	out.print("<br>new dmwa[i]="+dmwa[i]);
//		flag=1 

	}


	if(exchange_rate>0)
	{
		dollardmwa[i]= dmwa[i]/exchange_rate;

	}
	else
	{
		dollardmwa[i]= dmwa[i];
	}
	
}
double sdiff;
double ddiff;
double old_prevCarats=0;
double new_prevCarats=0;

double available_old_prevCarats=0;
double available_new_prevCarats=0;

double prevCarats=0;
double available_prevCarats=0;
double newprevCarats=0;
double available_newprevCarats=0;
double new_scarats=0;
double scarats=0;
double available_scarats=0;
double old_scarats=0;
double dcarats=0;
double available_dcarats=0;
double old_dcarats=0;


double available_old_scarats=0;

double available_old_dcarats=0;


for(int i=0;i<scounter;i++)
{
//-----------------------------------------Source---------------------------------

if((old_slotid[i] == slotid[i]) && (old_slocation_id[i] == slocation_id[i]) && (old_sqty[i] == sqty[i]) )
	{
		/*
		prevCarats = Double.parseDouble(A.getNameCondition("LotLocation","Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
		
		

		available_prevCarats = Double.parseDouble(A.getNameCondition("LotLocation","Available_Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id));


		

		available_scarats = available_prevCarats ;
		scarats = prevCarats;
		
		
		out.print("<br>scarats ="+scarats);
		out.print("available_scarats ="+available_scarats);
		*/
		
	}

if((old_slotid[i] == slotid[i]) && (old_slocation_id[i] == slocation_id[i]) && (old_sqty[i] != sqty[i]) )
	{

	//	out.print("<br>inside if qty  changed");
		sdiff = old_sqty[i] - sqty[i];
		//out.print("sdiff = "+sdiff);

		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
		
	//	out.print("prevCarats ="+prevCarats);

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id));


	//	out.print("available_prevCarats ="+available_prevCarats);

		available_scarats = available_prevCarats + sdiff;
		scarats = prevCarats + sdiff;
		
		
//		out.print("<br>scarats ="+scarats);
//		out.print("available_scarats ="+available_scarats);
		String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	pstmt_p = cong.prepareStatement(locationUpdate);

	pstmt_p.setInt(1,slocation_id[i]);
	pstmt_p.setInt(2,slotid[i]);
	pstmt_p.setString(3,""+scarats);
	pstmt_p.setString(4,""+available_scarats);
	pstmt_p.setInt(5,slocation_id[i]);
	pstmt_p.setInt(6,slotid[i]);

	int a321=pstmt_p.executeUpdate();
//out.print("<br> 142 a321"+a321);
	pstmt_p.close();
		


	}

if((old_slotid[i] != slotid[i]) || (old_slocation_id[i] != slocation_id[i]))
	{
//		out.print("inside any one changed");
		

		

		old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
	//	out.print("<br>old_prevCarats"+old_prevCarats);

		available_old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
//		out.print("<br>available_old_prevCarats"+available_old_prevCarats);


		old_scarats = old_prevCarats + old_sqty[i];
		available_old_scarats = available_old_prevCarats + old_sqty[i];

	//	out.print("<br>old_scarats"+old_scarats);
	//	out.print("<br>available_old_scarats"+available_old_scarats);
		
		String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
		pstmt_p = cong.prepareStatement(locationUpdate);

		pstmt_p.setInt(1,old_slocation_id[i]);
		pstmt_p.setInt(2,old_slotid[i]);
		pstmt_p.setString(3,""+old_scarats);
		pstmt_p.setString(4,""+available_old_scarats);
		pstmt_p.setInt(5,old_slocation_id[i]);
		pstmt_p.setInt(6,old_slotid[i]);

		int a303=pstmt_p.executeUpdate();
//out.print("<br> 142 a303 "+a303);
		pstmt_p.close();


		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ slocation_id[i] + " and Lot_Id = " + slotid[i] +" and  Company_Id ="+company_id) );
		
	//	out.print("<br>prevCarats ="+prevCarats);

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ slocation_id[i] + " and Lot_Id = " + slotid[i] +" and  Company_Id ="+company_id) );
		
	//	out.print("<br>available_prevCarats ="+available_prevCarats);

		

				
		scarats = prevCarats - sqty[i];
		available_scarats = prevCarats - sqty[i];

//		out.print("<br>scarats ="+scarats);
//		out.print("<br>available_scarats ="+available_scarats);


		String locationUpdate1 = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	pstmt_p = cong.prepareStatement(locationUpdate1);

	pstmt_p.setInt(1,slocation_id[i]);
	pstmt_p.setInt(2,slotid[i]);
	pstmt_p.setString(3,""+scarats);
	pstmt_p.setString(4,""+available_scarats);
	pstmt_p.setInt(5,slocation_id[i]);
	pstmt_p.setInt(6,slotid[i]);

	int a321=pstmt_p.executeUpdate();
//out.print("<br> 142 a321"+a321);
	pstmt_p.close();
	}
	

	
	String ReceiveTransactionUpdate = "update Receive_Transaction set Lot_Id=?,Quantity=?,Available_Quantity=?,Receive_Price=?,Local_Price=?,Dollar_Price=?,Modified_On=?,Modified_By=?,Modified_MachineName=?,Location_id=?,Mov_WtdAvg=? where ReceiveTransaction_Id=?";
	pstmt_p = cong.prepareStatement(ReceiveTransactionUpdate);
	 
	pstmt_p.setInt(1,slotid[i]);
	pstmt_p.setString(2,""+sqty[i]);
	pstmt_p.setString(3,""+sqty[i]);
	pstmt_p.setString(4,""+smwa[i]);
	pstmt_p.setString(5,""+smwa[i]);
	pstmt_p.setString(6,""+dollarsmwa[i]);
	pstmt_p.setString(7,""+D);
	pstmt_p.setInt(8,user_id);
	pstmt_p.setString(9,machine_name);
	pstmt_p.setInt(10,slocation_id[i]);
	pstmt_p.setBoolean(11,smwaflag[i]);
	pstmt_p.setInt(12,sReceiveTransaction_Id[i]);

	int a485=pstmt_p.executeUpdate();
//out.print("<br> 142 a485"+a485);
		pstmt_p.close();


}	
//-----------------------------------------------------------------------------------
//out.print("<br>");
//-----------------------------------------Destination---------------------------------
for(int i=0;i<dcounter;i++)
{
if((old_dlotid[i] == dlotid[i]) && (old_dlocation_id[i] == dlocation_id[i]) && (old_dqty[i] == dqty[i]))
	{
	//	out.print("<br>nothinh is changed");


/*

		prevCarats = Double.parseDouble(A.getNameCondition("LotLocation","Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

		available_prevCarats = Double.parseDouble(A.getNameCondition("LotLocation","Available_Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

		
		dcarats = prevCarats;
		available_dcarats = available_prevCarats;
		out.print("<br>dcarats ="+dcarats);
		out.print("<br>available_dcarats ="+available_dcarats);		
*/
	}

if((old_dlotid[i] == dlotid[i]) && (old_dlocation_id[i] == dlocation_id[i]) && (old_dqty[i] != dqty[i]) )
	{
	//	out.print("<br>dest inside if qty  changed");

		ddiff = old_dqty[i] - dqty[i];

	//	out.print("ddiff :"+ddiff);

		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

//		out.print("<br>prevCarats ="+prevCarats);
///out.print("<br>available_prevCarats ="+available_prevCarats);
		
		dcarats = prevCarats - ddiff;
		available_dcarats = available_prevCarats - ddiff;
	//	out.print("<br>dcarats ="+dcarats);
	//	out.print("<br>available_dcarats ="+available_dcarats);

			String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	
	pstmt_p = cong.prepareStatement(locationUpdate);

	pstmt_p.setInt(1,dlocation_id[i]);
	pstmt_p.setInt(2,dlotid[i]);
	pstmt_p.setString(3,""+dcarats);
	pstmt_p.setString(4,""+available_dcarats);
	pstmt_p.setInt(5,dlocation_id[i]);
	pstmt_p.setInt(6,dlotid[i]);

	int a335=pstmt_p.executeUpdate();

	pstmt_p.close();

	}

if((old_dlotid[i] != dlotid[i]) || (old_dlocation_id[i] != dlocation_id[i]))
	{
	//	out.print("<br>dest inside if any one changed");
		old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_dlocation_id[i] + " and Lot_Id = " + old_dlotid[i] +" and  Company_Id ="+company_id) );

		available_old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_dlocation_id[i] + " and Lot_Id = " + old_dlotid[i] +" and  Company_Id ="+company_id) );
		
	//	out.print("<br>old_prevCarats"+old_prevCarats);
	//	out.print("<br>available_old_prevCarats"+available_old_prevCarats);
		

		old_dcarats = old_prevCarats - old_dqty[i];
		available_old_dcarats = available_old_prevCarats - old_dqty[i];

	//	out.print("<br>old_dcarats"+old_dcarats);
	//	out.print("<br>available_old_dcarats"+available_old_dcarats);
		
		String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
		pstmt_p = cong.prepareStatement(locationUpdate);

		pstmt_p.setInt(1,old_dlocation_id[i]);
		pstmt_p.setInt(2,old_dlotid[i]);
		pstmt_p.setString(3,""+old_dcarats);
		pstmt_p.setString(4,""+available_old_dcarats);
		pstmt_p.setInt(5,old_dlocation_id[i]);
		pstmt_p.setInt(6,old_dlotid[i]);

		int a303=pstmt_p.executeUpdate();

		pstmt_p.close();


		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ dlocation_id[i] + " and Lot_Id = " + dlotid[i] +" and  Company_Id ="+company_id) );

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ dlocation_id[i] + " and Lot_Id = " + dlotid[i] +" and  Company_Id ="+company_id) );
		
	//	out.print("<br>prevCarats ="+prevCarats);
	//	out.print("<br>available_prevCarats ="+available_prevCarats);
		
		dcarats = prevCarats + dqty[i];
		available_dcarats = available_prevCarats + dqty[i];
	//	out.print("<br>dcarats ="+dcarats);
	//	out.print("<br>available_dcarats ="+available_dcarats);


			String locationUpdate1 = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	
	pstmt_p = cong.prepareStatement(locationUpdate1);

	pstmt_p.setInt(1,dlocation_id[i]);
	pstmt_p.setInt(2,dlotid[i]);
	pstmt_p.setString(3,""+dcarats);
	pstmt_p.setString(4,""+available_dcarats);
	pstmt_p.setInt(5,dlocation_id[i]);
	pstmt_p.setInt(6,dlotid[i]);

	int a335=pstmt_p.executeUpdate();

	pstmt_p.close();

	}


		String ReceiveTransactionUpdate = "update Receive_Transaction set Lot_Id=?,Quantity=?,Available_Quantity=?,Receive_Price=?,Local_Price=?,Dollar_Price=?,Modified_On=?,Modified_By=?,Modified_MachineName=?,Location_id=?,Mov_WtdAvg=? where ReceiveTransaction_Id=?";
	pstmt_p = cong.prepareStatement(ReceiveTransactionUpdate);
	 
	pstmt_p.setInt(1,dlotid[i]);
	pstmt_p.setString(2,""+dqty[i]);
	pstmt_p.setString(3,""+dqty[i]);
	pstmt_p.setString(4,""+dmwa[i]);
	pstmt_p.setString(5,""+dmwa[i]);
	pstmt_p.setString(6,""+dollardmwa[i]);
	pstmt_p.setString(7,""+D);
	pstmt_p.setInt(8,user_id);
	pstmt_p.setString(9,machine_name);
	pstmt_p.setInt(10,dlocation_id[i]);
	pstmt_p.setBoolean(11,dmwaflag[i]);
	pstmt_p.setInt(12,dReceiveTransaction_Id[i]);

	int a600=pstmt_p.executeUpdate();

		pstmt_p.close();



}
//--------------------------------------------------------------------------------------

C.returnConnection(cong);

%>
<script language="JavaScript">
		alert("Stock Transfer Updated Successfully")
	window.close()
	</script>
<%


}catch(Exception e31){ 
	out.println("<font color=blue> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}

}


















if(StockTransfer_Type==6)
{
// Loss --------------Source----------
int sReceive_Id = Integer.parseInt(request.getParameter("sReceive_Id"));
String stocktransfer_no = request.getParameter("stocktransfer_no");

int scounter = Integer.parseInt(request.getParameter("scounter"));
//out.print("<br>scounter"+scounter);


//out.print("<br>StockTransfer_Type ="+StockTransfer_Type);

double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
//out.print("<br>exchange_rate"+exchange_rate);
String stockdate = request.getParameter("stockdate");
String stotalqty = request.getParameter("stotalqty");

double stotalamt = Double.parseDouble(request.getParameter("stotalamt"));
//out.print("<br>stotalamt"+stotalamt);
double sdollaramt=0;


if(exchange_rate>0)
{
	sdollaramt= stotalamt/exchange_rate;

}
else
{
	sdollaramt= stotalamt;
	sdollaramt= stotalamt/exchange_rate;
}


String query="select count(*) as receiveno from Receive where Receive_No = '"+stocktransfer_no+"' and Receive_Id <>"+sReceive_Id+" and company_id="+company_id;

try
{
try	{
//		cong=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}



pstmt_q=cong.prepareStatement(query);
rs_g= pstmt_q.executeQuery();
int receiveNo =0;
while(rs_g.next())
{
	receiveNo = rs_g.getInt("receiveno");  
}
//out.print("<br>receiveNo"+receiveNo);
pstmt_q.close();
C.returnConnection(cong);
%>
<html>
<HTML>
<HEAD>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body>
<%
	//if(!receiveNo.equals("0"))
 if(receiveNo>=1)
	{
%>
<table width="100%" align="center">
<tr align="center">
<td><font color="red">Transfer No. is already present in database.</td>
	</tr>
	<tr>
<td align=center><input type=button name="command" value="Back" onclick="history.go(-2)" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>

</tr>

</table>
<%
	}
String reciveUpdate = "update Receive set Receive_No=?,Receive_Date=?,Stock_Date=?,Exchange_Rate=?,Receive_ExchangeRate=?,Receive_lots=?,Receive_Quantity=?, Receive_Total=?,Local_Total=?,Dollar_Total=? where Receive_Id=?";

try	{
		cong=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}

pstmt_p = cong.prepareStatement(reciveUpdate);

pstmt_p.setString(1,stocktransfer_no);
pstmt_p.setString(2,""+format.getDate(stockdate));
pstmt_p.setString(3,""+format.getDate(stockdate));
pstmt_p.setString(4,""+exchange_rate);
pstmt_p.setString(5,""+exchange_rate);
pstmt_p.setInt(6,scounter);
pstmt_p.setString(7,stotalqty);
pstmt_p.setString(8,""+stotalamt);
pstmt_p.setString(9,""+stotalamt);
pstmt_p.setString(10,""+sdollaramt);
pstmt_p.setInt(11,sReceive_Id);

int a136=pstmt_p.executeUpdate(); 

pstmt_p.close();

 
 
int slotid[] = new int[scounter]; 
int slocation_id[] = new int[scounter]; 
int old_slotid[] = new int[scounter]; 
int old_slocation_id[] = new int[scounter]; 
double sqty[] = new double[scounter]; 
double old_sqty[] = new double[scounter];
double srate[] = new double[scounter]; 
double old_srate[] = new double[scounter];
double smwa[]=new double[scounter];
boolean smwaflag[]=new boolean[scounter];
double dollarsmwa[]=new double[scounter];

//out.print("<br>");
int sReceiveTransaction_Id[]= new int[scounter]; 

for(int i=0;i<scounter;i++)
{
    srate[i] = Double.parseDouble(request.getParameter("srate"+i));

	old_srate[i] = Double.parseDouble(request.getParameter("old_srate"+i));
//	out.print("srate[i] = "+srate[i]);
//	out.print("old_srate[i] = "+old_srate[i]);

	int temp = 	Integer.parseInt(request.getParameter("smwaflag"+i));
	
	if(temp==1)
	{
		smwaflag[i] = true;	
	}
	else
	{
		smwaflag[i] = false;	
	}
	
//	out.print("smwaflag[i] = "+smwaflag[i]);

	sReceiveTransaction_Id[i] = Integer.parseInt(request.getParameter("sReceiveTransaction_Id"+i));
//	out.print("sReceiveTransaction_Id[i] = "+sReceiveTransaction_Id[i]);

	slotid[i] = Integer.parseInt(request.getParameter("slotid"+i));
//	out.print("slotid[i] = "+slotid[i]);
	slocation_id[i] = Integer.parseInt(request.getParameter("slocation_id"+i));
//	out.print("slocation_id[i] = "+slocation_id[i]);
		old_slotid[i] = Integer.parseInt(request.getParameter("old_slotid"+i));
//		out.print("old_slotid[i] = "+old_slotid[i]);
	old_slocation_id[i] = Integer.parseInt(request.getParameter("old_slocation_id"+i));
//	out.print("old_slocation_id[i] = "+old_slocation_id[i]);
	sqty[i] = Double.parseDouble(request.getParameter("sqty"+i));
//	out.print("sqty[i] = "+sqty[i]);
	old_sqty[i] = Double.parseDouble(request.getParameter("old_sqty"+i));
//	out.print("old_sqty[i] = "+old_sqty[i]);

	smwa[i] = Double.parseDouble(request.getParameter("smwa"+i));
	//out.print("<br>smwa[i]="+smwa[i]);
	//out.print("<br>srate[i]="+srate[i]);
	//out.print("<br>smwaflag[i]="+smwaflag[i]);
	
int flag =0; 
	if(( smwaflag[i]==true ) && (srate[i] == smwa[i]) )
	{
		smwaflag[i] = true;	
		flag = 1;
	}
	else if(( smwaflag[i]==true ) && (srate[i] != smwa[i])  )
	{
	//	out.print("here");
		smwaflag[i] = false;
		smwa[i] = srate[i];
	//	out.print("<br>new smwa[i]="+smwa[i]);
		flag = 1;

	}

	else if(( smwaflag[i]==false ) && (srate[i] == smwa[i]) )
	{
		smwaflag[i] = true;	
		flag = 1;
	}
	else if(( smwaflag[i]==false ) && (srate[i] != smwa[i]) )
	{
		out.print("here");
		smwaflag[i] = false;
		smwa[i] = srate[i];
	//	out.print("<br>new smwa[i]="+smwa[i]);
	//	flag = 1;

	}
	//out.print("<br>smwaflag[i]="+smwaflag[i]);

	
//	out.print("smwa[i] = "+smwa[i]);

	 if(exchange_rate>0)
	{
		dollarsmwa[i]= smwa[i]/exchange_rate;

	}
	else
	{
		dollarsmwa[i]= smwa[i];
	}
	
}
//out.print("<br>");


double sdiff;

double old_prevCarats=0;
double new_prevCarats=0;

double available_old_prevCarats=0;
double available_new_prevCarats=0;

double prevCarats=0;
double available_prevCarats=0;
double newprevCarats=0;
double available_newprevCarats=0;
double new_scarats=0;
double scarats=0;
double available_scarats=0;
double old_scarats=0;


double available_old_scarats=0;



for(int i=0;i<scounter;i++)
{
//-----------------------------------------Source---------------------------------

if((old_slotid[i] == slotid[i]) && (old_slocation_id[i] == slocation_id[i]) && (old_sqty[i] == sqty[i]) )
	{
		//out.print("<br>inside if qty not changed");
		
	}

if((old_slotid[i] == slotid[i]) && (old_slocation_id[i] == slocation_id[i]) && (old_sqty[i] != sqty[i]) )
	{

		//out.print("<br>inside if qty  changed");
		sdiff = old_sqty[i] - sqty[i];
		//out.print("sdiff = "+sdiff);

		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
		
		//out.print("prevCarats ="+prevCarats);

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id));


		//out.print("available_prevCarats ="+available_prevCarats);

		available_scarats = available_prevCarats + sdiff;
		scarats = prevCarats + sdiff;
		
		
		//out.print("<br>scarats ="+scarats);
		//out.print("available_scarats ="+available_scarats);

			String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	pstmt_p = cong.prepareStatement(locationUpdate);

	pstmt_p.setInt(1,slocation_id[i]);
	pstmt_p.setInt(2,slotid[i]);
	pstmt_p.setString(3,""+scarats);
	pstmt_p.setString(4,""+available_scarats);
	pstmt_p.setInt(5,slocation_id[i]);
	pstmt_p.setInt(6,slotid[i]);

	int a321=pstmt_p.executeUpdate();

	pstmt_p.close();

		


	}

if((old_slotid[i] != slotid[i]) || (old_slocation_id[i] != slocation_id[i]))
	{
		out.print("inside any one changed");
		

		

		old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
		out.print("<br>old_prevCarats"+old_prevCarats);

		available_old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_slocation_id[i] + " and Lot_Id = " + old_slotid[i] +" and  Company_Id ="+company_id) );
		out.print("<br>available_old_prevCarats"+available_old_prevCarats);


		old_scarats = old_prevCarats + old_sqty[i];
		available_old_scarats = available_old_prevCarats + old_sqty[i];

		//out.print("<br>old_scarats"+old_scarats);
		//out.print("<br>available_old_scarats"+available_old_scarats);
		
		String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
		pstmt_p = cong.prepareStatement(locationUpdate);

		pstmt_p.setInt(1,old_slocation_id[i]);
		pstmt_p.setInt(2,old_slotid[i]);
		pstmt_p.setString(3,""+old_scarats);
		pstmt_p.setString(4,""+available_old_scarats);
		pstmt_p.setInt(5,old_slocation_id[i]);
		pstmt_p.setInt(6,old_slotid[i]);

		int a303=pstmt_p.executeUpdate();

		pstmt_p.close();


		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ slocation_id[i] + " and Lot_Id = " + slotid[i] +" and  Company_Id ="+company_id) );
		
		out.print("<br>prevCarats ="+prevCarats);

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ slocation_id[i] + " and Lot_Id = " + slotid[i] +" and  Company_Id ="+company_id) );
		
		out.print("<br>available_prevCarats ="+available_prevCarats);

		

				
		scarats = prevCarats - sqty[i];
		available_scarats = prevCarats - sqty[i];

	//	out.print("<br>scarats ="+scarats);
	//	out.print("<br>available_scarats ="+available_scarats);

			String locationUpdate1 = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	pstmt_p = cong.prepareStatement(locationUpdate1);

	pstmt_p.setInt(1,slocation_id[i]);
	pstmt_p.setInt(2,slotid[i]);
	pstmt_p.setString(3,""+scarats);
	pstmt_p.setString(4,""+available_scarats);
	pstmt_p.setInt(5,slocation_id[i]);
	pstmt_p.setInt(6,slotid[i]);

	int a321=pstmt_p.executeUpdate();

	pstmt_p.close();


	}

		String ReceiveTransactionUpdate = "update Receive_Transaction set Lot_Id=?,Quantity=?,Available_Quantity=?,Receive_Price=?,Local_Price=?,Dollar_Price=?,Modified_On=?,Modified_By=?,Modified_MachineName=?,Location_id=?,Mov_WtdAvg=? where ReceiveTransaction_Id=?";
	pstmt_p = cong.prepareStatement(ReceiveTransactionUpdate);
	 
	pstmt_p.setInt(1,slotid[i]);
	pstmt_p.setString(2,""+sqty[i]);
	pstmt_p.setString(3,""+sqty[i]);
	pstmt_p.setString(4,""+smwa[i]);
	pstmt_p.setString(5,""+smwa[i]);
	pstmt_p.setString(6,""+dollarsmwa[i]);
	pstmt_p.setString(7,""+D);
	pstmt_p.setInt(8,user_id);
	pstmt_p.setString(9,machine_name);
	pstmt_p.setInt(10,slocation_id[i]);
	pstmt_p.setBoolean(11,smwaflag[i]);
	pstmt_p.setInt(12,sReceiveTransaction_Id[i]);

	int a983=pstmt_p.executeUpdate();

		pstmt_p.close();



}//end of for	
C.returnConnection(cong);
%>
<script language="JavaScript">
		alert("Stock Transfer Updated Successfully")
	window.close()
	</script>
<%
}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}

}





if(StockTransfer_Type==7)
{
// Gain --------------Destination----------
int dReceive_Id = Integer.parseInt(request.getParameter("dReceive_Id"));
String stocktransfer_no = request.getParameter("stocktransfer_no");

int dcounter = Integer.parseInt(request.getParameter("dcounter"));
//out.print("<br>dcounter"+dcounter);


//out.print("<br>StockTransfer_Type ="+StockTransfer_Type);

double exchange_rate = Double.parseDouble(request.getParameter("exchange_rate"));
String stockdate = request.getParameter("stockdate");
String dtotalqty = request.getParameter("dtotalqty");

double dtotalamt = Double.parseDouble(request.getParameter("dtotalamt"));

double ddollaramt=0;


if(exchange_rate>0)
{
	ddollaramt= dtotalamt/exchange_rate;

}
else
{
	ddollaramt= dtotalamt;
}


String query="select count(*) as receiveno from Receive where Receive_No = '"+stocktransfer_no+"' and Receive_Id <>"+dReceive_Id+" and company_id="+company_id;

try
{
try	{
//		cong=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}



pstmt_q=cong.prepareStatement(query);
rs_g= pstmt_q.executeQuery();
int receiveNo =0;
while(rs_g.next())
{
	receiveNo = rs_g.getInt("receiveno");  
}
//out.print("<br>receiveNo"+receiveNo);
pstmt_q.close();
C.returnConnection(cong);
%>
<html>
<HTML>
<HEAD>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body>
<%
	//if(!receiveNo.equals("0"))
 if(receiveNo>=1)
	{
%>
<table width="100%" align="center">
<tr align="center">
<td><font color="red">Transfer No. is already present in database.</td>
	</tr>
	<tr>
<td align=center><input type=button name="command" value="Back" onclick="history.go(-2)" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>

</tr>

</table>
<%
	}

String reciveUpdate = "update Receive set Receive_No=?,Receive_Date=?,Stock_Date=?,Exchange_Rate=?,Receive_ExchangeRate=?,Receive_lots=?,Receive_Quantity=?, Receive_Total=?,Local_Total=?,Dollar_Total=? where Receive_Id=?";


try	{
		cong=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}

pstmt_p = cong.prepareStatement(reciveUpdate);

pstmt_p.setString(1,stocktransfer_no);
pstmt_p.setString(2,""+format.getDate(stockdate));
pstmt_p.setString(3,""+format.getDate(stockdate));
pstmt_p.setString(4,""+exchange_rate);
pstmt_p.setString(5,""+exchange_rate);
pstmt_p.setInt(6,dcounter);
pstmt_p.setString(7,dtotalqty);
pstmt_p.setString(8,""+dtotalamt);
pstmt_p.setString(9,""+dtotalamt);
pstmt_p.setString(10,""+ddollaramt);
pstmt_p.setInt(11,dReceive_Id);

int a136=pstmt_p.executeUpdate(); 

pstmt_p.close();

int dlotid[] = new int[dcounter]; 
int dlocation_id[] = new int[dcounter]; 
int old_dlotid[] = new int[dcounter]; 
int old_dlocation_id[] = new int[dcounter]; 
double dqty[] = new double[dcounter]; 
double old_dqty[] = new double[dcounter]; 
double drate[] = new double[dcounter]; 
double old_drate[] = new double[dcounter]; 
double dmwa[] = new double[dcounter]; 
boolean dmwaflag[] = new boolean[dcounter]; 
double dollardmwa[] = new double[dcounter]; 
int dReceiveTransaction_Id[]= new int[dcounter]; 

for(int i=0;i<dcounter;i++)
{
      drate[i] = Double.parseDouble(request.getParameter("drate"+i));

	old_drate[i] = Double.parseDouble(request.getParameter("old_drate"+i));
//	out.print("drate[i] = "+drate[i]);
//	out.print("old_drate[i] = "+old_drate[i]);

	int temp = 	Integer.parseInt(request.getParameter("dmwaflag"+i));
	
	if(temp==1)
	{
		dmwaflag[i] = true;	
	}
	else
	{
		dmwaflag[i] = false;	
	}
	
//	out.print("dmwaflag[i] = "+dmwaflag[i]);

	dReceiveTransaction_Id[i] = Integer.parseInt(request.getParameter("dReceiveTransaction_Id"+i));
//	out.print("dReceiveTransaction_Id[i] = "+dReceiveTransaction_Id[i]);
	dlotid[i] = Integer.parseInt(request.getParameter("dlotid"+i));
//	out.print("dlotid[i] = "+dlotid[i]);
	dlocation_id[i] = Integer.parseInt(request.getParameter("dlocation_id"+i));
//	out.print("dlocation_id[i] = "+dlocation_id[i]);
	old_dlotid[i] = Integer.parseInt(request.getParameter("old_dlotid"+i));
//	out.print("old_dlotid[i] = "+old_dlotid[i]);
	old_dlocation_id[i] = Integer.parseInt(request.getParameter("old_dlocation_id"+i));
//	out.print("old_dlocation_id[i] = "+old_dlocation_id[i]);
	dqty[i] = Double.parseDouble(request.getParameter("dqty"+i));
//	out.print("dqty[i] = "+dqty[i]);

	old_dqty[i] = Double.parseDouble(request.getParameter("old_dqty"+i));
//	out.print("old_dqty[i] = "+old_dqty[i]);

	dmwa[i] = Double.parseDouble(request.getParameter("dmwa"+i));

	int flag = 0;
	if(( dmwaflag[i]==true ) && (drate[i] == dmwa[i]) )
	{

		dmwaflag[i] = true;	
		flag = 1;
	}
	else if(( dmwaflag[i]==true ) && (drate[i] != dmwa[i]) && flag!=1 )
	{
		dmwaflag[i] = false;
		dmwa[i] = drate[i];
		flag = 1;
	}
	else if(( dmwaflag[i]==false ) && (drate[i] == dmwa[i]) && flag!=1 )
	{
		dmwaflag[i] = true;	
		flag = 1;
	}
	else if(( dmwaflag[i]==false ) && (drate[i] != dmwa[i]) && flag!=1 )
	{
//		out.print("here");
		dmwaflag[i] = false;
		dmwa[i] = drate[i];
	//	out.print("<br>new dmwa[i]="+dmwa[i]);
//		flag=1 

	}


	if(exchange_rate>0)
	{
		dollardmwa[i]= dmwa[i]/exchange_rate;

	}
	else
	{
		dollardmwa[i]= dmwa[i];
	}
	
}
 


double ddiff;
double old_prevCarats=0;
double new_prevCarats=0;

double available_old_prevCarats=0;
double available_new_prevCarats=0;

double prevCarats=0;
double available_prevCarats=0;
double newprevCarats=0;
double available_newprevCarats=0;




double dcarats=0;
double available_dcarats=0;
double old_dcarats=0;


double available_old_scarats=0;

double available_old_dcarats=0;


for(int i=0;i<dcounter;i++)
{
if((old_dlotid[i] == dlotid[i]) && (old_dlocation_id[i] == dlocation_id[i]) && (old_dqty[i] == dqty[i]))
	{
		//out.print("<br>dest inside if qty not changed");
		
	}

if((old_dlotid[i] == dlotid[i]) && (old_dlocation_id[i] == dlocation_id[i]) && (old_dqty[i] != dqty[i]) )
	{
	//	out.print("<br>dest inside if qty  changed");

		ddiff = old_dqty[i] - dqty[i];

	//	out.print("ddiff :"+ddiff);

		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+old_dlocation_id[i]+" and  Lot_Id="+old_dlotid[i]+" and  Company_Id ="+company_id));

	//	out.print("<br>prevCarats ="+prevCarats);
	//	out.print("<br>available_prevCarats ="+available_prevCarats);
		
		dcarats = prevCarats - ddiff;
		available_dcarats = available_prevCarats - ddiff;
//		out.print("<br>dcarats ="+dcarats);
//		out.print("<br>available_dcarats ="+available_dcarats);

			String locationUpdate1 = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	
			pstmt_p = cong.prepareStatement(locationUpdate1);

			pstmt_p.setInt(1,dlocation_id[i]);
			pstmt_p.setInt(2,dlotid[i]);
			pstmt_p.setString(3,""+dcarats);
			pstmt_p.setString(4,""+available_dcarats);
			pstmt_p.setInt(5,dlocation_id[i]);
			pstmt_p.setInt(6,dlotid[i]);

			int a335=pstmt_p.executeUpdate();


		int a1258=pstmt_p.executeUpdate();

			pstmt_p.close();

	}

if((old_dlotid[i] != dlotid[i]) || (old_dlocation_id[i] != dlocation_id[i]))
	{
//		out.print("<br>dest inside if any one changed");
		old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ old_dlocation_id[i] + " and Lot_Id = " + old_dlotid[i] +" and  Company_Id ="+company_id) );

		available_old_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ old_dlocation_id[i] + " and Lot_Id = " + old_dlotid[i] +" and  Company_Id ="+company_id) );
		
//		out.print("<br>old_prevCarats"+old_prevCarats);
//		out.print("<br>available_old_prevCarats"+available_old_prevCarats);
		

		old_dcarats = old_prevCarats - old_dqty[i];
		available_old_dcarats = available_old_prevCarats - old_dqty[i];

//		out.print("<br>old_dcarats"+old_dcarats);
//		out.print("<br>available_old_dcarats"+available_old_dcarats);
		
		String locationUpdate = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
		pstmt_p = cong.prepareStatement(locationUpdate);

		pstmt_p.setInt(1,old_dlocation_id[i]);
		pstmt_p.setInt(2,old_dlotid[i]);
		pstmt_p.setString(3,""+old_dcarats);
		pstmt_p.setString(4,""+available_old_dcarats);
		pstmt_p.setInt(5,old_dlocation_id[i]);
		pstmt_p.setInt(6,old_dlotid[i]);

		int a303=pstmt_p.executeUpdate();

		pstmt_p.close();


		prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Carats","where Location_Id="+ dlocation_id[i] + " and Lot_Id = " + dlotid[i] +" and  Company_Id ="+company_id) );

		available_prevCarats = Double.parseDouble(A.getNameCondition(cong,"LotLocation","Available_Carats","where Location_Id="+ dlocation_id[i] + " and Lot_Id = " + dlotid[i] +" and  Company_Id ="+company_id) );
		
//		out.print("<br>prevCarats ="+prevCarats);
//		out.print("<br>available_prevCarats ="+available_prevCarats);
		
		dcarats = prevCarats + dqty[i];
		available_dcarats = available_prevCarats + dqty[i];
//		out.print("<br>dcarats ="+dcarats);
//		out.print("<br>available_dcarats ="+available_dcarats);




			String locationUpdate1 = "update LotLocation set Location_Id = ?,Lot_Id = ?,Carats = ?,Available_Carats = ? where Location_Id = ? and Lot_Id = ?";
	
			pstmt_p = cong.prepareStatement(locationUpdate1);

			pstmt_p.setInt(1,dlocation_id[i]);
			pstmt_p.setInt(2,dlotid[i]);
			pstmt_p.setString(3,""+dcarats);
			pstmt_p.setString(4,""+available_dcarats);
			pstmt_p.setInt(5,dlocation_id[i]);
			pstmt_p.setInt(6,dlotid[i]);

			int a335=pstmt_p.executeUpdate();


		int a1258=pstmt_p.executeUpdate();

			pstmt_p.close();






	}

			String ReceiveTransactionUpdate = "update Receive_Transaction set Lot_Id=?,Quantity=?,Available_Quantity=?,Receive_Price=?,Local_Price=?,Dollar_Price=?,Modified_On=?,Modified_By=?,Modified_MachineName=?,Location_id=?,Mov_WtdAvg=? where ReceiveTransaction_Id=?";
	pstmt_p = cong.prepareStatement(ReceiveTransactionUpdate);
	 
	pstmt_p.setInt(1,dlotid[i]);
	pstmt_p.setString(2,""+dqty[i]);
	pstmt_p.setString(3,""+dqty[i]);
	pstmt_p.setString(4,""+dmwa[i]);
	pstmt_p.setString(5,""+dmwa[i]);
	pstmt_p.setString(6,""+dollardmwa[i]);
	pstmt_p.setString(7,""+D);
	pstmt_p.setInt(8,user_id);
	pstmt_p.setString(9,machine_name);
	pstmt_p.setInt(10,dlocation_id[i]);
	pstmt_p.setBoolean(11,dmwaflag[i]);
	pstmt_p.setInt(12,dReceiveTransaction_Id[i]);

	int a600=pstmt_p.executeUpdate();

		pstmt_p.close();



} //end of for
C.returnConnection(cong);
%>
<script language="JavaScript">
		alert("Stock Transfer Updated Successfully")
	window.close()
	</script>
<%
}catch(Exception e31){ 
	out.println("<font color=red> FileName : StockTransferTypeUpdate.jsp<br>Bug No e31 : "+ e31);}

}
%>




