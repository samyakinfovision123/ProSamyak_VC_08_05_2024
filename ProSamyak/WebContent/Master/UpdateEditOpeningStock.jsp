<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<%
	String command=request.getParameter("command"); 
//	out.print("<br>"+command);
	
	String message=request.getParameter("message"); 

	if(!("Default".equals(message)))
	{
	out.print("<br><b> "+message+"</b>");
	}
    
	Connection cong = null;
	try	{cong=C.getConnection();
	}
	catch(Exception e31){ 
	out.println("<font color=red> FileName : LotMovement.jsp<br>Bug No e31 : "+ e31);}
  
	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String company_name= A.getName(cong,"companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();

	String Lot_No=request.getParameter("Lot_No"); 

	
	int Lot_Id=Integer.parseInt(A.getNameCondition(cong,"Lot","Lot_Id","where Lot_No='"+Lot_No+"'"));

	String lotLocation=request.getParameter("lotLocation"); 
       
    String currency_id="";
	if("lotno".equals(lotLocation))
	{
	if("local".equals(Currency))
	{
		currency_id=I.getLocalCurrency(cong,company_id);
	}
	else
	{
		currency_id="0";
	}
	
     C.returnConnection(cong);      
	//Connection cong=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;
/*
	try
	{
	cong=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }
*/
if("Update".equals(command))
{
//	String lotLocation=request.getParameter("lotLocation"); 
//	out.print("<br>"+lotLocation);

	String rateAmount=request.getParameter("rateAmount"); 
//	out.print("<br>"+rateAmount);

	String Currency=request.getParameter("Currency"); 
//	out.print("<br>"+Currency);

/*	String currency_id="";
	if("lotno".equals(lotLocation))
	{
	if("local".equals(Currency))
	{
		currency_id=I.getLocalCurrency(company_id);
	}
	else
	{
		currency_id="0";
	}
*/	
//	String Lot_No=request.getParameter("Lot_No"); 
//	out.print("<br>"+Lot_No);
	
//	int Lot_Id=Integer.parseInt(A.getNameCondition("Lot","Lot_Id","where Lot_No='"+Lot_No+"'"));
//	out.print("<br>"+Lot_Id);

	int counter=Integer.parseInt(request.getParameter("counter"));
//	out.print("<br>"+locationAbsent);

	String chk[]=new String[counter];
	String ALocation_Id[]=new String[counter];
	String AUnit_Id[]=new String[counter];
	double AQuantity[]=new double[counter];
	double AExchange_Rate[]=new double[counter];
	double ALocalRate[]=new double[counter];
	double ALocalAmount[]=new double[counter];
	double ADollarRate[]=new double[counter];
	double ADollarAmount[]=new double[counter];
	double Amount[]=new double[counter];
	double Rate[]=new double[counter];

	for(int i=0;i<counter;i++)
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
}//if Yes
}//For


%>








