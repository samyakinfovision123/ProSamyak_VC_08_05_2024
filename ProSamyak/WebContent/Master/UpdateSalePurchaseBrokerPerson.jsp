<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String errLine="10";
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
String salesperson_id=request.getParameter("salesperson_id");
String salepurchasebroker_id=request.getParameter("salepurchasebroker_id");
		//out.print("<br> 702 salesperson_id = "+salesperson_id);


String command  = request.getParameter("command");
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
		//out.println("command is "+command);



if("SAVE".equals(command))
{

	try {
	//out.print("<BR>116<br>");
	 	 conp=C.getConnection();
errLine="38";

	
		
		String salesperson_name=request.getParameter("salesperson_name");	
		//out.print("<br> 705 salesperson_name = "+salesperson_name);

		//out.print("<br> 705 company_id = "+company_id);
		
		String address1=request.getParameter("address1");	
		String address2=request.getParameter("address2");	
		String address3=request.getParameter("address3");	
		String city=request.getParameter("city");	
		String pin=request.getParameter("pin");	
		String country=request.getParameter("country");	
		String mobile=request.getParameter("mobile");	
		String phone_o=request.getParameter("phone_o");	
		String phone_r=request.getParameter("phone_r");	
		String fax=request.getParameter("fax");	
		String email=request.getParameter("email");
		String commission=request.getParameter("commission");
		String active=request.getParameter("active");
	errLine="60";	
		boolean active_flag =false; 
		
		if("yes".equals(active))
		{
			active_flag=true;
		}
		//String message=request.getParameter("message");

	//	String lotNoExistQuery="Select Lot_Id from Lot where Lot_No=? AND Lot_Id!=? and company_id="+company_id+"";


		String selectquery ="Select SalesPerson_id from Master_SalesPerson where  SalesPerson_name ='"+salesperson_name+"' and purchasesale="+salepurchasebroker_id+" and SalesPerson_id !="+salesperson_id+" and company_id="+company_id;

		pstmt_p = conp.prepareStatement(selectquery);
		rs_g = pstmt_p.executeQuery();	
		int idcount=0;
		while(rs_g.next())
		{
			idcount++;
		}
		pstmt_p.close();

		//out.print("<br> 705 count = "+idcount);

		if(idcount<1)
		{
				String query ="Update Master_SalesPerson set SalesPerson_Name=?, Address1=?, Address2=?, Address3=?, City=?, Pin=?, Country=?, Mobile=?, Phone_O=?, Phone_R=?, Fax=?, Email=? ,Modified_On='"+format.getDate(today_string)+"', Modified_By=?, Modified_MachineName=?, active=?, commission="+commission+" where SalesPerson_Id=?";
errLine="88";
		pstmt_p = conp.prepareStatement(query);
		
		pstmt_p.setString (1,""+salesperson_name);
		//out.print("<br> 92 salesperson_name="+salesperson_name);
		pstmt_p.setString (2,""+address1);
		//out.print("<br> address1="+address1);
		pstmt_p.setString (3,""+address2);
		//out.print("<br> address2="+address2);
		pstmt_p.setString (4,""+address3);
		//out.print("<br> address3="+address3);
		pstmt_p.setString (5,""+city);
		//out.print("<br> city="+city);
		pstmt_p.setString (6,""+pin);
		//out.print("<br> pin="+pin);
		pstmt_p.setString (7,""+country);
		//out.print("<br> country="+country);
		pstmt_p.setString (8,""+mobile);
		//out.print("<br> mobile="+mobile);
		pstmt_p.setString (9,""+phone_o);
		//out.print("<br> phone_o="+phone_o);
		pstmt_p.setString (10,""+phone_r);
		//out.print("<br> phone_r="+phone_r);
		pstmt_p.setString (11,""+fax);
		//out.print("<br> fax="+fax);
		pstmt_p.setString (12,""+email);
		//out.print("<br> email="+email);
		pstmt_p.setString (13, user_id);
		//out.print("<br> user_id="+user_id);
		pstmt_p.setString (14, ""+machine_name);
		out.print("<br> machine_name="+machine_name);
		pstmt_p.setBoolean (15,active_flag);
		//out.print("<br> active_flag="+active_flag);
		pstmt_p.setString (16,""+salesperson_id);		
		//out.print("<br> salesperson_id="+salesperson_id);
errLine="106";
		int a = pstmt_p.executeUpdate();
errLine="108";
		C.returnConnection(conp);
if("0".equals(salepurchasebroker_id))
	{
	
		C.returnConnection(conp);	response.sendRedirect("EditSalePurchaseBrokerPerson.jsp?command=Default&salesperson_id="+salesperson_id+"&salepurchasebroker_id=0&message=Sale Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}else if("1".equals(salepurchasebroker_id))
	{
	
	C.returnConnection(conp);	response.sendRedirect("EditSalePurchaseBrokerPerson.jsp?command=Default&salesperson_id="+salesperson_id+"&salepurchasebroker_id=1&message=Purchase Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}else
	{
	
	C.returnConnection(conp);	response.sendRedirect("EditSalePurchaseBrokerPerson.jsp?command=Default&salesperson_id="+salesperson_id+"&salepurchasebroker_id=2&message=Broker Person <font color=blue> "+salesperson_name+" </font>Updated Successfully");
	}
}
	else
{ 

	
	if("0".equals(salepurchasebroker_id))
	{
		C.returnConnection(conp);
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=5 color=red><b>Sale Person <font color=blue>"+ salesperson_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}else if("1".equals(salepurchasebroker_id))
	{
		C.returnConnection(conp);
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=5 color=red><b>Purchase Person <font color=blue>"+ salesperson_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}else
	{
	
	C.returnConnection(conp);
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background='../Buttons/BGCOLOR.JPG' ><center><font face=times new roman size=5 color=red><h2>Broker Person <font color=blue>"+ salesperson_name+" </font>already exists.</h2><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}
}
	
}catch(Exception e93)
	{ 
	C.returnConnection(conp);
	out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +" Error On"+errLine+"</font>");}
}//Update SalesPerson
%>








