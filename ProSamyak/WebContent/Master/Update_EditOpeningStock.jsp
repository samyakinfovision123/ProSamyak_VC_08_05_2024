<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C" scope="application"  class="NipponBean.Connect" />
<jsp:useBean id="I"  class="NipponBean.Inventory" />
<%try{

	String command=request.getParameter("command"); 
 	//out.print("<br>command"+command);
	
	String message=request.getParameter("message"); 

	if(!("Default".equals(message) || message==null))
	{
	out.print("<br><b>message"+message+"</b>");
	}

	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	//String company_name= A.getName("companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String servername=request.getServerName();

	Connection cong=null;
	Connection conp=null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;

	/*try
	{
	conp=C.getConnection();
	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }*/

if("Update".equals(command))
{
	//String currency_id="";

 	conp=C.getConnection();
 	cong=C.getConnection();
	String rateAmount=request.getParameter("rateAmount"); 
 	//out.print("<br>"+rateAmount);

	String Currency=request.getParameter("Currency"); 
 	//out.print("<br>Currency"+Currency);

		int  m=Integer.parseInt(request.getParameter("present")); 
 	//out.print("<br>m=>"+m);
	

		double orgreceiveaomunt[]=new double[m];
		
	double localaomunt[]=new double[m];
	double localrate[]=new double[m];
	double dolleramount[]=new double[m];
	double dollerrate[]=new double[m];

	double exchangrate[]=new double[m];
	double lotid[]=new double[m];
	double quantity[]=new double[m];
	double old_quantity[]=new double[m];

	double ReceiveTransaction_Id[]=new double[m];
	double Receive_Id[]=new double[m];
	double Location_Id[]=new double[m];
    	//conp=C.getConnection();  

out.print("**");
for(int k=0;k<m;k++)
{ 		
	
	
	out.print("<br>73"); Location_Id[k]=Double.parseDouble(request.getParameter("Location_Id"+k)); 
	out.print("Location_Id"+Location_Id[k]);
	
	
	ReceiveTransaction_Id[k]=Double.parseDouble(request.getParameter("ReceiveTransaction_Id"+k));
	//out.print("<br>ReceiveTransaction_Id"+k+ReceiveTransaction_Id[k]);

	Receive_Id[k]=Double.parseDouble(request.getParameter("Receive_Id"+k));
	out.print("<br>Receive_Id"+k+Receive_Id[k]);

		lotid[k]=Double.parseDouble(request.getParameter("lot_id"+k));
		out.print("<br>84 lotid"+k+lotid[k]);

		exchangrate[k]=Double.parseDouble(request.getParameter("ExchangRate"+k));
		quantity[k]=Double.parseDouble(request.getParameter("quantity"+k));
		old_quantity[k]=Double.parseDouble(request.getParameter("old_quantity"+k));
//		out.print("<br>Quantity"+k+quantity[k]);

double temp=0;
double temprate=0;

			if("local".equals(Currency))
			{
				if("amount".equals(rateAmount))
				{
						localaomunt[k]=Double.parseDouble(request.getParameter("localaomunt"+k)); 
						temp=localaomunt[k];
						//out.print(" localaomunt"+k+"-"+localaomunt[k]);
						dolleramount[k]=(localaomunt[k])/(exchangrate[k]);
						//out.print(" || dolleramount"+k+"-"+dolleramount[k]);
						localrate[k]=(localaomunt[k])/(quantity[k]);
						//out.print(" || localrate"+k+"-"+localrate[k]);
						dollerrate[k]=dolleramount[k]/quantity[k];
						//out.print(" || dollerrate"+k+"-"+dollerrate[k]);

				}
				else 
				{

					localrate[k]=Double.parseDouble(request.getParameter("localrate"+k)); 
					temprate=localrate[k];
 					//out.print(" localrate"+k+"-"+localrate[k]);
					localaomunt[k]=(quantity[k])*(localrate[k]);
 					//out.print(" localaomunt"+k+"-"+localaomunt[k]);
					dollerrate[k]=(localrate[k])/(exchangrate[k]);
 					//out.print(" dollerrate"+k+"-"+dollerrate[k]);
					dolleramount[k]=(dollerrate[k])*(quantity[k]);
 				//	out.print(" dolleramount"+k+"-"+dolleramount[k]);

				}
				orgreceiveaomunt[k] = localaomunt[k];
			}
			else//Doller
			{
				if("amount".equals(rateAmount))
				{
					dolleramount[k]=Double.parseDouble(request.getParameter("dolleramount"+k)); 
						temp=dolleramount[k];
 					//out.print(" dolleramount"+k+"-"+dolleramount[k]);
					dollerrate[k]=(dolleramount[k])/(quantity[k]);
					//out.print(" dollerrate"+k+"-"+dollerrate[k]);
					localaomunt[k]=(dolleramount[k])*(exchangrate[k]);
					//out.print(" localaomunt"+k+"-"+localaomunt[k]);
					localrate[k]=(localaomunt[k])/(quantity[k]);
					//out.print(" localrate"+k+"-"+localrate[k]);

				}
				else//rate
				{

					dollerrate[k]=Double.parseDouble(request.getParameter("dollerrate"+k)); 
					temprate=dollerrate[k];
					//out.print(" dollerrate"+k+"-"+dollerrate[k]);
					localrate[k]=((dollerrate[k])*(exchangrate[k]));
					//out.print(" localrate"+k+"-"+localrate[k]);
					dolleramount[k]=((dollerrate[k])*(quantity[k]));
 					//out.print(" dolleramount"+k+"-"+dolleramount[k]);
					localaomunt[k]=((localrate[k])*(quantity[k]));
					//out.print(" localaomunt"+k+"-"+localaomunt[k]);
				}
				orgreceiveaomunt[k] = dolleramount[k];
			}//end  doller else
out.print("155");
try{
	//	conp=C.getConnection();
		String query="select * from LotLOcation where Lot_Id=? and Location_Id=?";
		out.print("<br>159");
		pstmt_p = cong.prepareStatement(query);
	 	pstmt_p.setDouble (1,lotid[k]);	
	 	pstmt_p.setDouble(2,Location_Id[k]);
		rs_g = pstmt_p.executeQuery();
		double lotlocation_oldfinqty=0;
		double lotlocation_oldphyqty=0;
		while(rs_g.next())
		{
			lotlocation_oldfinqty=rs_g.getDouble("Carats");
			lotlocation_oldphyqty=rs_g.getDouble("Available_Carats");
		}

		lotlocation_oldfinqty=lotlocation_oldfinqty-(old_quantity[k]-quantity[k]);
		lotlocation_oldphyqty=lotlocation_oldphyqty-(old_quantity[k]-quantity[k]);

		query="Update  LotLocation set Company_Id= ?,Carats= ?,Available_Carats= ? , Modified_On= ?, Modified_By=?, Modified_MachineName=? where Location_Id= ? and Lot_Id= ? ";

		//out.print(query);
		pstmt_p = conp.prepareStatement(query);
		
	 	pstmt_p.setString (1, company_id);	
	 	//out.print("<br>company_id[k]"+company_id);

		pstmt_p.setDouble (2,lotlocation_oldfinqty);	
		//out.print("<br>quantity[k]"+quantity[k]);
	 	pstmt_p.setDouble (3,lotlocation_oldphyqty);	
	 	pstmt_p.setString (4,""+D);	
	 	pstmt_p.setString (5,user_id);	
	 	pstmt_p.setString (6,machine_name);	
	 	pstmt_p.setDouble(7,Location_Id[k]);	
	 	pstmt_p.setDouble (8,lotid[k]);	
 
		int a224 = pstmt_p.executeUpdate();
		//out.print("<br>a224 "+a224);
		pstmt_p.close();
//*****************************************************************************
String currency_id="";
if("local".equals(Currency))
	{
		currency_id=I.getLocalCurrency(conp,company_id);
	}
	else
	{
		currency_id="0";
	}

//out.print("**");

query="Update Receive set Receive_CurrencyId=? ,Exchange_Rate=?,Receive_ExchangeRate=?,Receive_Total= ?,    Local_Total=?, Dollar_Total=?, Company_Id=?,Modified_On=?,   Modified_By=?, Modified_MachineName=?,   Receive_Quantity=? where Receive_Id=?";


		pstmt_p = conp.prepareStatement(query);
 	out.print("<br>211 "+query);

		pstmt_p.setString (1, currency_id);		
		pstmt_p.setString (2,""+exchangrate[k]);	
 		//out.print("<br>2");
		pstmt_p.setString (3,""+ exchangrate[k]);	

		pstmt_p.setString (4,""+orgreceiveaomunt[k]);	

		pstmt_p.setString (5,""+localaomunt[k]);	
//		out.print("<br>5");

		pstmt_p.setString (6, ""+dolleramount[k]);	
		pstmt_p.setString (7, ""+company_id);
//		out.print("<br>7");
	 	pstmt_p.setString (8,""+D);	

	 	pstmt_p.setString (9,user_id);	
	 	pstmt_p.setString (10,machine_name);	

		pstmt_p.setString(11,""+quantity[k]);

		pstmt_p.setString(12,""+Receive_Id[k]);
		
		  a224 = pstmt_p.executeUpdate();
		pstmt_p.close();
//out.print("as**");

	//*****************************************************************

	query="Update Receive_Transaction set Quantity=?,Available_Quantity=?,Receive_Price=?, Local_Price=?    ,Dollar_Price=?, Modified_On=?, Modified_By=?, Modified_MachineName=?, ProActive=?,Location_Id=? where ReceiveTransaction_Id=?";
	
		pstmt_p = conp.prepareStatement(query);
//out.print("<br> quantity[k]" +quantity[k] );
//out.print("<br>temprate " + temprate);
//out.print("<br>localrate[k] " + localrate[k]);
//out.print("<br> Location_Id[k]" +Location_Id[k] );
//out.print("<br> ReceiveTransaction_Id[k]" +ReceiveTransaction_Id[k] );


		pstmt_p.setDouble (1,quantity[k]);	
		pstmt_p.setDouble (2,quantity[k]);	
//out.print("as**");

		pstmt_p.setDouble(3,temprate);	
		pstmt_p.setDouble(4,localrate[k]);	
		pstmt_p.setDouble(5,dollerrate[k]);	

	 	pstmt_p.setString (6,""+D);	
	 	pstmt_p.setString (7,""+user_id);	
	 	pstmt_p.setString (8,machine_name);	

		pstmt_p.setBoolean (9,true);	
	 	pstmt_p.setDouble(10,Location_Id[k]);	
		pstmt_p.setDouble(11,ReceiveTransaction_Id[k]);	

//out.print("3as**");

		  a224 = pstmt_p.executeUpdate();
		pstmt_p.close();

//out.print("4as**");


	pstmt_p.close();
	
	response.sendRedirect("EditOpeningStock.jsp?command=edit&message=<center><font class=msgred>Data Successfully Updated</font></center>");



	
	}catch(Exception e) { out.print("<br> ::<font color=Red >"+e+"</font>"); }



out.print("<br>287 End of For loop");

} //end for

	C.returnConnection(conp);
	C.returnConnection(cong);

}




	}catch(Exception e) { out.print("<br> Error While connecting with the Database:::<font color=Red >"+e+"</font>"); }

%>


