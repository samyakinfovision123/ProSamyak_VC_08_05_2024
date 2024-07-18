<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<%	


	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	//String company_name= A.getName("companyparty",company_id);
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	String today_string=format.format(D);
	String servername=request.getServerName();

	Connection cong=null;
	Connection conp=null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g=null;
	String query="";
	
	String command=request.getParameter("command"); 
//	out.print("<br>"+command);
	try{
	if("Update".equals(command))
	{
		 cong=C.getConnection();
	String message=request.getParameter("message"); 
//	out.print("<br>"+message);

	String hcommand=request.getParameter("hcommand"); 
//	out.print("<br>"+lotLocation);
	try{
	if("lotno".equals(hcommand))
	{
	String Lot_Id=request.getParameter("Lot_Id"); 
//	out.print("<br>"+Lot_No);
	
	String Lot_No=A.getNameCondition(cong,"Lot","Lot_No","where Lot_Id="+Lot_Id);
	int counter=Integer.parseInt(request.getParameter("counter"));
//	out.print("<br> counter"+counter);
	for(int i=0;i<counter;i++)
	{
//		out.print("For");
		double Optimum_Quantity=Double.parseDouble(request.getParameter("Optimum_Quantity"+i));
//		out.print("<br> Optimum_Quantity"+Optimum_Quantity);
		long Location_Id=Long.parseLong(request.getParameter("Location_Id"+i));
//		out.print("<br> Location_Id"+Location_Id);
		query="Update LotLocation set Optimum_Quantity="+Optimum_Quantity+" where Lot_Id="+Lot_Id+" and Location_id="+Location_Id;
//		out.print(query+"<br>");
		pstmt_g=cong.prepareStatement(query);
		int a=pstmt_g.executeUpdate();
	}
	C.returnConnection(cong);
		response.sendRedirect("OptimumQuantity.jsp?command=Default&message=<center><font color=red size=4pts>Optimum Quantity for Lot No. </font><font color=blue size=4pts>"+Lot_No+"</font><font color=red size=4pts> is successfully Updated</font></center>");

	}
		}catch(Exception e){ out.print(e);}


//---------------------------------
	try{
	if("location".equals(hcommand))
	{

	String Location_Id=request.getParameter("Location_Id");
//	out.print("<br> Location_Id "+Location_Id);
String Location_Name=A.getNameCondition(cong,"Master_Location","Location_Name","where Location_Id="+Location_Id);
	int counter=Integer.parseInt(request.getParameter("counter"));
//	out.print("<br> counter"+counter);
		for(int i=0;i<counter;i++)
		{
//			out.print("For");
			double Optimum_Quantity=Double.parseDouble(request.getParameter("Optimum_Quantity"+i));
//			out.print("<br> Optimum_Quantity"+Optimum_Quantity);
			long Lot_Id=Long.parseLong(request.getParameter("Lot_Id"+i));
//			out.print("<br> Lot_Id"+Lot_Id);
			query="Update LotLocation set Optimum_Quantity="+Optimum_Quantity+" where Lot_Id="+Lot_Id+" and Location_id="+Location_Id;
//			out.print(query+"<br>");
			pstmt_g=cong.prepareStatement(query);
			int a=pstmt_g.executeUpdate();
		}
	C.returnConnection(cong);	

	response.sendRedirect("OptimumQuantity.jsp?command=Default&message=<center><font color=red size=4pts>Optimum Quantity for Location </font><font color=blue size=4pts>"+Location_Name+"</font><font color=red size=4pts> is successfully Updated</font></center>");

	}

	}catch(Exception e){ out.print(e);}
	}	}catch(Exception e){ out.print(e);}

%>









