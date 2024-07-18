<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<% 

Connection conp=null;
PreparedStatement pstmt_p=null;
ResultSet rs_g=null;
String query="";
int a=0;


try{
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String yearend_id= ""+session.getValue("yearend_id");

//out.print(machine_name);
String company_id= ""+session.getValue("company_id");

//String company_name= A.getName("companyparty",company_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string=stoday_day+"/"+stoday_month+"/"+today_year;

String text="jpg";
String servername=request.getServerName();
String command = request.getParameter("command");
String message=request.getParameter("message"); 

String lot_id="";
//lot_id=""+ L.get_master_id("Lot");
String lotcategory_id=request.getParameter("lotcategory_id");
//out.print("<br> lotcategory_id "+lotcategory_id);

String lotsubcategory_id=request.getParameter("lotsubcategory_id");
//out.print("<br> lotsubcategory_id "+lotsubcategory_id);

String lot_no=request.getParameter("lot_no");
//out.print("<br> lot_no "+lot_no);
/*try
{
	query="select * from Lot where Lot_No="+l;
	pstmt_p=conp.prepareStatement(query);
	rs_g=pstmt_p.executeQuery();
	int i=0;
	pstmt_p.close();
	while(rs_g.next())
	{
		i++;
	}
	
	if(i!=0)
	{
		response.sendRedirect("NewItem.jsp?Message=Lot Already Present");
	}


}catch(Exception e){out.print(e);}
*/
String created_on=request.getParameter("datevalue");
//out.print("<br> created_on "+created_on);
java.sql.Date Dcreated_on=format.getDate(created_on);

String lot_name=request.getParameter("lot_name");
//out.print("<br> lot_name "+lot_name);

String lot_description=request.getParameter("lot_description");
//out.print("<br> lot_description "+lot_description);

String lot_referance=request.getParameter("lot_referance");
//out.print("<br> lot_referance "+lot_referance);

String lot_location=request.getParameter("lot_location");
//out.print("<br> lot_location "+lot_location);

String reorder_qty=request.getParameter("reorder_qty");
//out.print("<br> reorder_qty "+reorder_qty);

String os=request.getParameter("os");
//out.print("<br> os "+os);

	String currency=request.getParameter("currency");
//out.print("<br> currency "+currency);

int icurrency=0;

if("Local".equals(currency))
{
	icurrency=1;
}
//out.print("<br> icurrency "+icurrency);
String exchange_rate=request.getParameter("exchange_rate");
//out.print("<br> exchange_rate "+exchange_rate);

String qty=request.getParameter("qty");
//out.print("<br> qty "+qty);

String rate=request.getParameter("rate");
//out.print("<br> rate "+rate);

String amount=request.getParameter("amount");
//out.print("<br> amount "+amount);

String location_id=request.getParameter("location_id");
//out.print("<br> location_id "+location_id);

boolean osflag=false;

if("yes".equals(os))
{
	osflag=true;

currency=request.getParameter("currency");
//out.print("<br> currency "+currency);

 icurrency=0;

if("Local".equals(currency))
{
	icurrency=1;
}
//out.print("<br> icurrency "+icurrency);

exchange_rate=request.getParameter("exchange_rate");
//out.print("<br> exchange_rate "+exchange_rate);

qty=request.getParameter("qty");
//out.print("<br> qty "+qty);

rate=request.getParameter("rate");
//out.print("<br> rate "+rate);

amount=request.getParameter("amount");
//out.print("<br> amount "+amount);

location_id=request.getParameter("location_id");
//out.print("<br> location_id "+location_id);

}
//out.print("<br> osflag "+osflag);


String unit_id=request.getParameter("unit_id");
//out.print("<br> unit_id "+unit_id);



if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

if("ADD".equals(command))
{
	try
	{
	conp=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }
//conp.commit();

	lot_id=""+ L.get_master_id(conp,"Lot");
  
	query="select * from Lot where Lot_No=? and Company_Id=?";
	pstmt_p=conp.prepareStatement(query);
	pstmt_p.setString(1,lot_no);
	pstmt_p.setString(2,company_id);
	rs_g=pstmt_p.executeQuery();
	int i=0;
	while(rs_g.next())
	{
		i++;
	}
	pstmt_p.close();

	if(i!=0)
	{
		C.returnConnection(conp);

		%>
<html>
	<head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>
<body background='../Buttons/BGCOLOR.JPG' >
	<br><center>
	<font class='star1'><b>Lot No 
	<font class='msgcolor2'><%=lot_no%> </font>already exists.</font></b>
	<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
</body>
		</html>
<%

//	response.sendRedirect("NewItem.jsp?command=Next&message=Lot Already Present");
	}

	else
	{
		//if(osflag==true)
		//{
//			created_on="31/03/2004";
			//Dcreated_on=Config.financialYearStart();

			String condition = " where company_id="+company_id+" and yearend_id="+yearend_id;
			Dcreated_on = YED.getDate(conp, "YearEnd", "From_Date", condition);
			int crdd=Dcreated_on.getDate();
			crdd--;
			Dcreated_on.setDate(crdd);
		//}
	conp.setAutoCommit(false);

	query="insert into Lot (Lot_Id,Company_Id,Lot_No,Lot_Name, Lot_Description,Lot_Referance,Lot_Location,LotCategory_Id, LotSubCategory_Id,Unit_Id,ReorderQuantity,Created_On, Created_By,Modified_On,Modified_By,Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?)"; 
	
	pstmt_p=conp.prepareStatement(query);

	pstmt_p.setString(1,lot_id);
	pstmt_p.setString(2,company_id);
	pstmt_p.setString(3,lot_no);
	pstmt_p.setString(4,lot_name);
	
	pstmt_p.setString(5,lot_description);
	pstmt_p.setString(6,lot_referance);
	pstmt_p.setString(7,lot_location);
	pstmt_p.setString(8,lotcategory_id);
	
	pstmt_p.setString(9,lotsubcategory_id);
	pstmt_p.setString(10,unit_id);
	pstmt_p.setString(11,reorder_qty);
	pstmt_p.setString(12,""+Dcreated_on);

	pstmt_p.setString(13,user_id);
	pstmt_p.setString(14,""+format.getDate(today_string));
	pstmt_p.setString(15,user_id);
	pstmt_p.setString(16,machine_name);
	pstmt_p.setString(17,yearend_id);

	a=pstmt_p.executeUpdate();
	pstmt_p.close();

	if(osflag==true)
	{

//------------------------------------------
		
		//String LotLocation_Id = ""+ L.get_master_id(conp,"LotLocation");
		
int temp_lot_loc_id=0;
temp_lot_loc_id=L.get_master_id(conp,"LotLocation");

		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+format.getDate(today_string)+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br> 141"+query);
		pstmt_p.setString (1, ""+temp_lot_loc_id );	
//		out.print("<br> LotLocation_Id  "+L.get_master_id("LotLocation"));

		pstmt_p.setString (2,location_id);
//		out.print("<br> ALocation_Id  "+ALocation_Id[i]);

		pstmt_p.setString (3,""+lot_id);
//		out.print("<br> Lot_Id  "+Lot_Id);
		pstmt_p.setString (4,company_id);
		
		pstmt_p.setString (5,""+qty);	
//		out.print("<br> AQuantity  "+AQuantity[i]);

		pstmt_p.setString (6, ""+qty);	
		pstmt_p.setString (7, user_id);		
		pstmt_p.setString (8, machine_name);
		pstmt_p.setString (9, yearend_id);
		int a435 = pstmt_p.executeUpdate();
		pstmt_p.close();
		temp_lot_loc_id=temp_lot_loc_id+1;
//-------------------------------------------------
	String receive_id=""+ L.get_master_id(conp,"Receive");
	String receive_no="OP-"+receive_id;
	String receive_date="31/03/2004";
	double local_total=0;
	double dollar_total=0;

	double amnt=Double.parseDouble(amount);
	double excgrt=Double.parseDouble(exchange_rate);
	
		if(icurrency==1)
		{
			local_total=amnt;
			dollar_total=amnt/excgrt;
		}
		else
		{
			local_total=amnt*excgrt;
			dollar_total=amnt;
		}
	
//	out.print("<br>local total "+local_total);
//	out.print("<br>287dollar total "+dollar_total);

 	query="insert into Receive(Receive_Id,Receive_No,Receive_Date,Receive_Lots, Receive_Quantity,Receive_CurrencyId,Exchange_Rate,Receive_ExchangeRate, Receive_Total,Local_Total,Dollar_Total,Receive_FromId, Receive_FromName,Company_Id,Receive_ByName,Receive_Internal, Opening_Stock,SalesPerson_Id,Modified_On,Modified_By, Modified_MachineName,Purchase,Stock_Date,YearEnd_Id) values ( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)";
	
	pstmt_p=conp.prepareStatement(query);

	pstmt_p.setString(1,receive_id);
	pstmt_p.setString(2,receive_no);
	pstmt_p.setString(3,""+format.getDate(receive_date));
	pstmt_p.setString(4,"1");
	
	pstmt_p.setString(5,qty);
	pstmt_p.setString(6,""+icurrency);
	pstmt_p.setString(7,exchange_rate);
	pstmt_p.setString(8,exchange_rate);
	
	pstmt_p.setString(9,amount);
	pstmt_p.setString(10,""+local_total);
	pstmt_p.setString(11,""+dollar_total);
	pstmt_p.setString(12,company_id);
	
	pstmt_p.setString(13,user_id);
	pstmt_p.setString(14,company_id);
	pstmt_p.setString(15,user_id);
	pstmt_p.setString(16,"1");
	
	pstmt_p.setBoolean(17,true);
	pstmt_p.setString(18,company_id);
	pstmt_p.setString(19,""+format.getDate(today_string));
	pstmt_p.setString(20,user_id);

	pstmt_p.setString(21,machine_name);
		pstmt_p.setBoolean(22,true);
//	out.print("<br>321 ");
		pstmt_p.setString(23,""+format.getDate(receive_date));
	pstmt_p.setString(24,yearend_id);

	a=pstmt_p.executeUpdate();
//		out.print("<br>324 a"+a);
	pstmt_p.close();

	String receivetransaction_id= ""+L.get_master_id(conp,"Receive_Transaction");
	
	double local_price=0;
	double dollar_price=0;
	double qtyd=Double.parseDouble(qty);
	double rated=Double.parseDouble(rate);

	String currency_id="";
	if(icurrency==1)
	{
	local_price= rated;
	local_total= qtyd * rated;
	dollar_price = rated / excgrt ;
	dollar_total = dollar_price * qtyd;
	currency_id=I.getLocalCurrency(conp,company_id);
	}

	else
	{
	dollar_price= rated;
	dollar_total= qtyd * rated;
	local_price = rated * excgrt ;
	local_total = local_price * qtyd;
	currency_id="0";
	}


	query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id, Quantity, Available_Quantity, Receive_Price, Local_Price, Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive,Location_Id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,'"+format.getDate(today_string)+"', ?,? ,?,?,?)";
	
	pstmt_p = conp.prepareStatement(query);

	pstmt_p.setString (1, receivetransaction_id);
	pstmt_p.setString (2,receive_id);	
	pstmt_p.setString (3, "1");	
	pstmt_p.setString (4,lot_id);			
	
	pstmt_p.setString (5,""+qty);	
	pstmt_p.setString (6, ""+qty);	
	pstmt_p.setString (7, ""+rate);
	pstmt_p.setString (8,""+local_price);	
	
	pstmt_p.setString (9, ""+dollar_price);	
	pstmt_p.setString (10, user_id);		
	pstmt_p.setString (11, machine_name);		
	pstmt_p.setBoolean (12,true);	
	pstmt_p.setString (13,location_id);	
	pstmt_p.setString (14,yearend_id);	

	a=pstmt_p.executeUpdate();
//		out.print("<br>376 Success "+a);

	

}
conp.commit();

C.returnConnection(conp);

	response.sendRedirect("NewItem.jsp?command=Category&message=Lot "+lot_no+ " Successfully Saved");


}


}

}catch(Exception e){ conp.rollback();
out.print("Outermost try "+e);}
%>








