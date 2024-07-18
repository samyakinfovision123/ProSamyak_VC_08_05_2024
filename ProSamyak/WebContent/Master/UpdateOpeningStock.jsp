<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />

<%	
	try{
	Connection cong=null;
	Connection conp=null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;
	String query="";
	try
	{
	cong=C.getConnection();
	conp=C.getConnection();
	conp.setAutoCommit(false);
	cong.setAutoCommit(false);
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }

	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	String company_name= A.getName(conp,"companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String today_string=format.format(D);
	String servername=request.getServerName();


	String command=request.getParameter("command"); 
//	out.print("<br>"+command);
	
	String message=request.getParameter("message"); 
//	out.print("<br>"+message);

	String lotLocation=request.getParameter("lotLocation"); 
//	out.print("<br>"+lotLocation);

	String rateAmount=request.getParameter("rateAmount"); 
//	out.print("<br>"+rateAmount);

	String Currency=request.getParameter("Currency"); 
//	out.print("<br>"+Currency);

	String currency_id="";
	if("lotno".equals(lotLocation))
	{
	
	if("local".equals(Currency))
	{
		currency_id=I.getLocalCurrency(conp,company_id);
	}
	else
	{
		currency_id="0";
	}
	

	String Lot_No=request.getParameter("Lot_No"); 
//	out.print("<br>"+Lot_No);
	
	int Lot_Id=Integer.parseInt(A.getNameCondition(conp,"Lot","Lot_Id","where Lot_No='"+Lot_No+"'"));
//	out.print("<br>"+Lot_Id);

	int locationAbsent=Integer.parseInt(request.getParameter("locationAbsent"));
//	out.print("<br>"+locationAbsent);

	String chk[]=new String[locationAbsent];
	String ALocation_Id[]=new String[locationAbsent];
	String AUnit_Id[]=new String[locationAbsent];
	double AQuantity[]=new double[locationAbsent];
	double AExchange_Rate[]=new double[locationAbsent];
	double ALocalRate[]=new double[locationAbsent];
	double ALocalAmount[]=new double[locationAbsent];
	double ADollarRate[]=new double[locationAbsent];
	double ADollarAmount[]=new double[locationAbsent];
	double Amount[]=new double[locationAbsent];
	double Rate[]=new double[locationAbsent];
	int countl[]=new int[locationAbsent];
	int lotlocation_id=L.get_master_id(conp,"LotLocation");
	int receive_id= L.get_master_id(conp,"Receive");
	int receivetransaction_id= L.get_master_id(conp,"Receive_Transaction");

	for(int i=0;i<locationAbsent;i++)
	{
//	out.print("For");
	chk[i]=request.getParameter("chk"+i);

	if("yes".equals(chk[i]))
	{
//		out.print("Inside Yes");
		ALocation_Id[i]=request.getParameter("ALocation_Id"+i);
		AUnit_Id[i]=request.getParameter("AUnit_Id"+i);
		AQuantity[i]=Double.parseDouble(request.getParameter("AQuantity"+i));
		AExchange_Rate[i]=Double.parseDouble(request.getParameter("AExchange_Rate"+i));
		if("rate".equals(rateAmount))
		{
			Rate[i]=Double.parseDouble(request.getParameter("ARateAmount"+i));
			Amount[i]=Rate[i]*AQuantity[i];
			if("local".equals(Currency))
			{
			
			ALocalRate[i]=Rate[i];
			ADollarRate[i]=Rate[i]/AExchange_Rate[i];
			ALocalAmount[i]=ALocalRate[i]*AQuantity[i];
			ADollarAmount[i]=ADollarRate[i]*AQuantity[i];
			}
			else//doller rate
			{
			ADollarRate[i]=Rate[i];
			ALocalRate[i]=Rate[i]*AExchange_Rate[i];
			ADollarAmount[i]=ADollarRate[i]*AQuantity[i];
			ALocalAmount[i]=ADollarAmount[i]*AQuantity[i];
			}
		}
		else//amount
		{
			Amount[i]=Double.parseDouble(request.getParameter("ARateAmount"+i));
			Rate[i]=Amount[i]/AQuantity[i];
			if("local".equals(Currency))
			{
			ALocalAmount[i]=Amount[i];
			ADollarAmount[i]=Amount[i]/AExchange_Rate[i];
			ALocalRate[i]=ALocalAmount[i]/AQuantity[i];//**
			ADollarRate[i]=ADollarAmount[i]/AQuantity[i];
			}
			else//doller
			{
			ADollarAmount[i]=Amount[i];
			ALocalAmount[i]=Amount[i]*AExchange_Rate[i];
			ADollarRate[i]=ADollarAmount[i]/AQuantity[i];
			ALocalRate[i]=ALocalAmount[i]/AQuantity[i];
			}
		}
		
		query="select * from LotLocation where Lot_Id="+Lot_Id+" and Location_Id="+ALocation_Id[i];
		pstmt_g=cong.prepareStatement(query);
//		out.print("<br>"+query);
		
		rs_g=pstmt_g.executeQuery();
		
		int count=0;
		countl[i]=0;
		while(rs_g.next())
		{
			countl[i]=count++;
		}
		pstmt_g.close();


	}//if
	}//for
boolean count_flag=true;
for(int i=0;i<locationAbsent;i++)
	{
	if("yes".equals(chk[i]))
	{
		if(countl[i]!=0)
		{

//			out.print("The Lot is being Purchased from the location you selected you can't add Opening Stock");
%>			<html>
				<head>
					<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
				</head>
			<body background='../Buttons/BGCOLOR.JPG' >
				<br><center>
				<font class='star1'><b>The Lot 
				<font class='msgcolor2'><%=Lot_No%> </font>is being Purchased to the location you selected you can't add Opening Stock.</font></b>
				<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
			</body>
			</html> 
<%	
			count_flag=false;		
				C.returnConnection(cong);	
				C.returnConnection(conp);	
break;
					}
else{count_flag=true;}

	}
	}//for


if(count_flag)
		{

for(int i=0;i<locationAbsent;i++)
	{
	if("yes".equals(chk[i]))
	{

		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+format.getDate(today_string)+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br> 141"+query);
		pstmt_p.setString (1, ""+lotlocation_id);	
//		out.print("<br> LotLocation_Id  "+L.get_master_id(conp,"LotLocation"));

		pstmt_p.setString (2,ALocation_Id[i]);
//		out.print("<br> ALocation_Id  "+ALocation_Id[i]);

		pstmt_p.setString (3,""+Lot_Id);
//		out.print("<br> Lot_Id  "+Lot_Id);
		pstmt_p.setString (4,company_id);
		
		pstmt_p.setString (5,""+AQuantity[i]);	
//		out.print("<br> AQuantity  "+AQuantity[i]);

		pstmt_p.setString (6, ""+AQuantity[i]);	
		pstmt_p.setString (7, user_id);		
		pstmt_p.setString (8, machine_name);		
		pstmt_p.setString (9,yearend_id);		
		int a435 = pstmt_p.executeUpdate();
		pstmt_p.close();
//		out.print("<br>152 "+a435);

		java.sql.Date Dopeningdate=Config.financialYearStart();
		int crdd=Dopeningdate.getDate();
		crdd--;
		Dopeningdate.setDate(crdd);
		
		
		//String openingdate=format.format(Dopeningdate);
		
		//setting the opening date depending on the current financial year
		String Fyear = YED.returnCurrentFinancialYear(cong , pstmt_g, rs_g, yearend_id, company_id);

		StringTokenizer splityear = new StringTokenizer(Fyear,"#");
		String tempFromDate = (String)splityear.nextElement();
		String tempToDate = (String)splityear.nextElement();

		StringTokenizer startdate = new StringTokenizer(tempFromDate,"-");
		int counter=startdate.countTokens();

		int startyear=Integer.parseInt((String)startdate.nextElement());
		int startmonth=Integer.parseInt((String)startdate.nextElement());
		String startday= (String)startdate.nextElement();
		StringTokenizer splitstartday = new StringTokenizer(startday," ");
		int splittedstartday = Integer.parseInt((String)splitstartday.nextElement());

		//created new date for inserting the opening stock
		java.sql.Date newopeningStockDate = new java.sql.Date( startyear-1900, startmonth-1, splittedstartday-1);


		String openingdate = format.format(newopeningStockDate);
		out.print(openingdate);
		query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_CurrencyId,Exchange_Rate,Receive_ExchangeRate,Receive_Total,    Local_Total, Dollar_Total, Company_Id,Purchase,    Opening_Stock, Modified_On, Modified_By, Modified_MachineName,   Receive_Quantity, stock_date,YearEnd_Id ) values (?,?,'"+format.getDate(openingdate)+"',? ,?,?,?,? ,?,?,?,?,? ,?, ?,?,?,'"+format.getDate(openingdate)+"',?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br>"+query);

		pstmt_p.setString (1, ""+receive_id);		
		pstmt_p.setString (2,"OP-"+receive_id);	
//		out.print("<br>2");
		pstmt_p.setString (3, "1");	
		pstmt_p.setString (4,currency_id);	
		pstmt_p.setString (5,""+AExchange_Rate[i]);	
//		out.print("<br>5");

		pstmt_p.setString (6, ""+AExchange_Rate[i]);	
		pstmt_p.setString (7, ""+Amount[i]);
//		out.print("<br>7");
		pstmt_p.setString (8,""+ALocalAmount[i]);	
		pstmt_p.setString (9, ""+ADollarAmount[i]);	
		pstmt_p.setString (10,company_id);			

		pstmt_p.setBoolean (11,true);	
		pstmt_p.setBoolean (12,true);
		pstmt_p.setString(13,""+format.getDate(today_string));

		pstmt_p.setString (14,user_id);		
		pstmt_p.setString (15,machine_name);


		pstmt_p.setString (16, ""+AQuantity[i]);	
		pstmt_p.setString (17,yearend_id);	
//		out.println("Before Query <br>"+query);


		int a224 = pstmt_p.executeUpdate();
		pstmt_p.close();

		//------------------Recive Table Completed ------------------------------------

		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id,       Quantity, Available_Quantity, Receive_Price, Local_Price,    Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive,Location_Id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,'"+format.getDate(today_string)+"', ?,? ,?,?,?)";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1,""+receivetransaction_id);		
		pstmt_p.setString (2,""+receive_id);	
		pstmt_p.setString (3, "1");	

		pstmt_p.setString (4,""+Lot_Id);			
		pstmt_p.setString (5,""+AQuantity[i]);	
		pstmt_p.setString (6, ""+AQuantity[i]);	

		pstmt_p.setString (7, ""+Rate[i]);
		pstmt_p.setString (8,""+ALocalRate[i]);	
		pstmt_p.setString (9, ""+ADollarRate[i]);	

		pstmt_p.setString (10, user_id);		
		pstmt_p.setString (11, machine_name);		
		pstmt_p.setBoolean (12,true);	
		pstmt_p.setString (13,ALocation_Id[i]);	
		pstmt_p.setString (14,yearend_id);	

		int a245 = pstmt_p.executeUpdate();
//		out.println("<br> 211 Receive Transaction query Executed:"+a224);
		pstmt_p.close();
		

		query="Update Lot Set Created_On='"+format.getDate(openingdate)+"' where Lot_Id="+Lot_Id;
		pstmt_p=conp.prepareStatement(query);
		int a261= pstmt_p.executeUpdate();
		pstmt_p.close();

		lotlocation_id++;
		receive_id++;
		receivetransaction_id++;


         	
		
		}//if
	}//for
		conp.commit();
		cong.commit();
		C.returnConnection(cong);	
		C.returnConnection(conp);	

response.sendRedirect("OpeningStock.jsp?command=Default&message=<center><font color=red>The Opening Stock for Lot No.</font><font color=blue>"+Lot_No+"</font> <font color=red>is successfully added</font></center>");
	}//flag

int active=0;
	for(int l=0;l<locationAbsent;l++)
	{
		
		if("yes".equals(chk[l]))
		{
			active++;
		}
	}
	

	if(active==0)
	{
		C.returnConnection(cong);	
			C.returnConnection(conp);	

%> 			 <html>
				<head>
					<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
				</head>
			<body background='../Buttons/BGCOLOR.JPG' >
				<br><center>
				<font class='star1'><b>You haven't selected any Location for Lot No.
				<font class='msgcolor2'><%=Lot_No%> </font>To add Opening Stock for.</font></b>
				<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
			</body>
			</html> 

<%	}

	}//if lot no
//---------------------Lot No Over----------------------------	
out.print("<br>369 lotLocation="+lotLocation);
if("location".equals(lotLocation))
{

if("local".equals(Currency))
	{
		currency_id=I.getLocalCurrency(conp,company_id);
	}
	else
	{
		currency_id="0";
	}
int Present=0;
int Absent=0;
	
Present=Integer.parseInt(request.getParameter("present"));
//	out.print("<br>"+Present);

 Absent=Integer.parseInt(request.getParameter("absent"));
//	out.print("<br>"+Absent);



//	String Lot_No=request.getParameter("Lot_No"); 
//	out.print("<br>"+Lot_No);
	
	int Location_Id= Integer.parseInt(request.getParameter("Location_Id"));
//	out.print("<br>"+Lot_Id);

//	int locationAbsent=Integer.parseInt(request.getParameter("locationAbsent"));
	//out.print("<br>"+Absent);
	long ALot_Id[]=new long[Absent];

	String chk[]=new String[Absent];
	String AUnit_Id[]=new String[Absent];
	double AQuantity[]=new double[Absent];
	double AExchange_Rate[]=new double[Absent];
	double ALocalRate[]=new double[Absent];
	double ALocalAmount[]=new double[Absent];
	double ADollarRate[]=new double[Absent];
	double ADollarAmount[]=new double[Absent];
	double Amount[]=new double[Absent];
	double Rate[]=new double[Absent];
	int countl[]=new int[Absent];
	int receivetransaction_id= L.get_master_id(conp,"Receive_Transaction");
	int lotlocation_id=L.get_master_id(conp,"LotLocation");
	int receive_id= L.get_master_id(conp,"Receive");

	int updated=0;
	for(int i=0;i<Absent;i++)
	{
//	out.print("For");
	chk[i]=request.getParameter("chk"+i);

	if("yes".equals(chk[i]))
	{
//		out.print("Inside Yes");

		ALot_Id[i]=Long.parseLong(request.getParameter("ALot_Id"+i));
		AUnit_Id[i]=request.getParameter("AUnit_Id"+i);
		AQuantity[i]=Double.parseDouble(request.getParameter("AQuantity"+i));
		AExchange_Rate[i]=Double.parseDouble(request.getParameter("AExchange_Rate"+i));

		
		if("rate".equals(rateAmount))
		{
			Rate[i]=Double.parseDouble(request.getParameter("ARateAmount"+i));
			Amount[i]=Rate[i]*AQuantity[i];
			if("local".equals(Currency))
			{
			
			ALocalRate[i]=Rate[i];
			ADollarRate[i]=Rate[i]/AExchange_Rate[i];
			ALocalAmount[i]=ALocalRate[i]*AQuantity[i];
			ADollarAmount[i]=ADollarRate[i]*AQuantity[i];
			}
			else
			{
			ADollarRate[i]=Rate[i];
			ALocalRate[i]=Rate[i]*AExchange_Rate[i];
			ADollarAmount[i]=ADollarRate[i]*AQuantity[i];
			ALocalAmount[i]=ADollarAmount[i]*AQuantity[i];
			}
		}
		else
		{
			Amount[i]=Double.parseDouble(request.getParameter("ARateAmount"+i));
			Rate[i]=Amount[i]/AQuantity[i];
			if("local".equals(Currency))
			{
			ALocalAmount[i]=Amount[i];
			ADollarAmount[i]=Amount[i]/AExchange_Rate[i];
			ALocalRate[i]=ALocalAmount[i]/AQuantity[i];
			ADollarRate[i]=ADollarAmount[i]/AQuantity[i];
			}
			else
			{
			ADollarAmount[i]=Amount[i];
			ALocalAmount[i]=Amount[i]*AExchange_Rate[i];
			ADollarRate[i]=ADollarAmount[i]/AQuantity[i];
			ALocalRate[i]=ALocalAmount[i]/AQuantity[i];
			}
		}
		
		query="select * from LotLocation where Lot_Id="+ALot_Id[i]+" and Location_Id="+Location_Id;
		pstmt_g=cong.prepareStatement(query);
//		out.print("<br>"+query);
		
		rs_g=pstmt_g.executeQuery();
		
		int count=0;
		countl[i]=0;
		while(rs_g.next())
		{
			countl[i]=count++;
		}
		pstmt_g.close();


	}
	}//for

boolean count_flag=true;
for(int i=0;i<Absent;i++)
	{
	if("yes".equals(chk[i]))
	{
		if(countl[i]!=0)
		{
//			out.print("The Lot is being Purchased from the location you selected you can't add Opening Stock");
%>			<html>
				<head>
					<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
				</head>
			<body background='../Buttons/BGCOLOR.JPG' >
				<br><center>
				<font class='star1'><b>The Lot
				<font class='msgcolor2'><%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+ALot_Id[i])%> </font>is being Purchased to the location you selected you can't add Opening Stock.</font></b>
				<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
			</body>
			</html> 
<%	
			count_flag=false;		
				C.returnConnection(cong);	
				C.returnConnection(conp);	
break;
					}
else{count_flag=true;}

	}
	}//for


if(count_flag)
		{

for(int i=0;i<Absent;i++)
	{
	if("yes".equals(chk[i]))
	{
		query="Insert into LotLocation (LotLocation_Id, Location_Id, Lot_Id, Company_Id, Carats, Available_Carats, Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,'"+format.getDate(today_string)+"',? ,?,?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br> 141"+query);
		pstmt_p.setString (1, ""+lotlocation_id);	
//		out.print("<br> LotLocation_Id  "+L.get_master_id(conp,"LotLocation"));

		pstmt_p.setString (2,""+Location_Id);
//		out.print("<br> ALocation_Id  "+ALocation_Id[i]);

		pstmt_p.setString (3,""+ALot_Id[i]);
//		out.print("<br> Lot_Id  "+Lot_Id);
		pstmt_p.setString (4,company_id);
		
		pstmt_p.setString (5,""+AQuantity[i]);	
//		out.print("<br> AQuantity  "+AQuantity[i]);

		pstmt_p.setString (6, ""+AQuantity[i]);	
		pstmt_p.setString (7, user_id);		
		pstmt_p.setString (8, machine_name);	
		pstmt_p.setString (9,yearend_id);	
		int a435 = pstmt_p.executeUpdate();
		pstmt_p.close();
//		out.print("<br>152 "+a435);
		lotlocation_id++;
		//String openingdate1="31/03/2004";


		//setting the opening date depending on the current financial year
		String Fyear = YED.returnCurrentFinancialYear(cong , pstmt_g, rs_g, yearend_id, company_id);

		StringTokenizer splityear = new StringTokenizer(Fyear,"#");
		String tempFromDate = (String)splityear.nextElement();
		String tempToDate = (String)splityear.nextElement();

		StringTokenizer startdate = new StringTokenizer(tempFromDate,"-");
		int counter=startdate.countTokens();

		int startyear=Integer.parseInt((String)startdate.nextElement());
		int startmonth=Integer.parseInt((String)startdate.nextElement());
		String startday= (String)startdate.nextElement();
		StringTokenizer splitstartday = new StringTokenizer(startday," ");
		int splittedstartday = Integer.parseInt((String)splitstartday.nextElement());

		//created new date for inserting the opening stock
		java.sql.Date newopeningStockDate = new java.sql.Date( startyear-1900, startmonth-1, splittedstartday-1);


		String openingdate1 = format.format(newopeningStockDate);
		
		query="Insert into Receive (Receive_Id, Receive_No, Receive_Date, Receive_Lots, Receive_CurrencyId,Exchange_Rate,Receive_ExchangeRate,Receive_Total,    Local_Total, Dollar_Total, Company_Id,Purchase,    Opening_Stock, Modified_On, Modified_By, Modified_MachineName,   Receive_Quantity, stock_date,YearEnd_Id) values (?,?,'"+format.getDate(openingdate1)+"',? ,?,?,?,? ,?,?,?,?,? ,?, ?,?,?,'"+format.getDate(openingdate1)+"',?)";
		pstmt_p = conp.prepareStatement(query);
//		out.print("<br>"+query);

		pstmt_p.setString (1,""+receive_id);		
		pstmt_p.setString (2,"OP-"+receive_id);	
//		out.print("<br>2");
		pstmt_p.setString (3, "1");	
		pstmt_p.setString (4,currency_id);	
		pstmt_p.setString (5,""+AExchange_Rate[i]);	
//		out.print("<br>5");

		pstmt_p.setString (6, ""+AExchange_Rate[i]);	
		pstmt_p.setString (7, ""+Amount[i]);
//		out.print("<br>7");
		pstmt_p.setString (8,""+ALocalAmount[i]);	
		pstmt_p.setString (9, ""+ADollarAmount[i]);	
		pstmt_p.setString (10,company_id);			

		pstmt_p.setBoolean (11,true);	
		pstmt_p.setBoolean (12,true);
		pstmt_p.setString(13,""+format.getDate(today_string));

		pstmt_p.setString (14,user_id);		
		pstmt_p.setString (15,machine_name);


		pstmt_p.setString (16, ""+AQuantity[i]);	
		pstmt_p.setString (17,yearend_id);
//		out.println("Before Query <br>"+query);

		int a224 = pstmt_p.executeUpdate();
		pstmt_p.close();

	
		//------------------Recive Table Completed ------------------------------------

		query="Insert into Receive_Transaction (ReceiveTransaction_Id, Receive_Id, Lot_SrNo, Lot_Id,       Quantity, Available_Quantity, Receive_Price, Local_Price,    Dollar_Price, Modified_On, Modified_By, Modified_MachineName, ProActive,Location_Id,YearEnd_Id) values (?,?,?,?, ?,?,?,?, ?,'"+format.getDate(today_string)+"', ?,? ,?,?,?)";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setString (1,""+receivetransaction_id);		
		pstmt_p.setString (2,""+receive_id);	
		pstmt_p.setString (3, "1");	

		pstmt_p.setString (4,""+ALot_Id[i]);			
		pstmt_p.setString (5,""+AQuantity[i]);	
		pstmt_p.setString (6, ""+AQuantity[i]);	

		pstmt_p.setString (7, ""+Rate[i]);
		pstmt_p.setString (8,""+ALocalRate[i]);	
		pstmt_p.setString (9, ""+ADollarRate[i]);	

		pstmt_p.setString (10, user_id);		
		pstmt_p.setString (11, machine_name);		
		pstmt_p.setBoolean (12,true);	
		pstmt_p.setString (13,""+Location_Id);	
		pstmt_p.setString (14,yearend_id);	
		int a245 = pstmt_p.executeUpdate();

//		out.println("<br> 211 Receive Transaction query Executed:"+a224);
		pstmt_p.close();
		

		query="Update Lot set Created_On=? where Lot_Id="+ALot_Id[i];
		pstmt_p=conp.prepareStatement(query);
		pstmt_p.setString(1,""+format.getDate(openingdate1));
		int a528 = pstmt_p.executeUpdate();
		//out.print("<br>645 a528 : "+a528);
		pstmt_p.close();
		receivetransaction_id++;
		updated++;

			receive_id++;


		}//end else lot is not purchased from location
	}//for
String temploc=A.getName(conp,"Location",""+Location_Id);

	conp.commit();
	cong.commit();
	C.returnConnection(cong);	
	C.returnConnection(conp);	

		response.sendRedirect("OpeningStock.jsp?command=Default&message=<center><font color=blue>The Opening Stock for Location</font><font color=red>"+temploc+"</font> <font color=blue>is successfully added</font></center>");

	}//flag
//	out.print("<br>updated "+updated);

int active=0;
	for(int l=0;l<Absent;l++)
	{
		
		if("yes".equals(chk[l]))
		{
			active++;
		}
	}

	if(active==0)
	{

%> 			 <html>
				<head>
					<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
				</head>
			<body background='../Buttons/BGCOLOR.JPG' >
				<br><center>
				<font class='star1'><b>You haven't selected any Lot for Location
				<font class='msgcolor2'><%=A.getName(conp,"Location",""+Location_Id)%> </font>To add Opening Stock for.</font></b>
				<br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>
			</body>
			</html> 

<%			C.returnConnection(cong);	
		C.returnConnection(conp);	

	}//if not selected


	}//if location wise	


		conp.commit();
		cong.commit();
	}catch(Exception e) { out.print("<br> Bug 548"+e); }


%>








