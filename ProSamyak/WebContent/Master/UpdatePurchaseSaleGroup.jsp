<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;

String command  = request.getParameter("command");


ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;

if("SAVE".equals(command))
{
try{
	conp=C.getConnection();
	String purchasesalegroup_id= request.getParameter("purchasesalegroup_id");
	String purchasesalegroup_name		=request.getParameter("purchasesalegroup_name");	
	String purchasesalegroup_code= request.getParameter("purchasesalegroup_code");
	String active= request.getParameter("active");
	String purchasesalegroup_type = request.getParameter("purchasesalegroup_type");
	boolean flag =false; 
	if("yes".equals(active)){flag=true;}


	String selectquery ="Select PurchaseSaleGroup_id from Master_PurchaseSaleGroup where  PurchaseSaleGroup_name ='"+purchasesalegroup_name+"' and PurchaseSaleGroup_id !="+purchasesalegroup_id+" and PurchaseSaleGroup_type="+purchasesalegroup_type+" and  company_id="+company_id;
	
	pstmt_p = conp.prepareStatement(selectquery);
		rs_g = pstmt_p.executeQuery();	
		//out.print("query="+selectquery);
		int idcount=0;
		while(rs_g.next())
		{
			idcount++;
		}
		pstmt_p.close();

		//out.print("<br> 705 count = "+idcount);

		if(idcount<1)
		{
	String query ="Update Master_PurchaseSaleGroup set PurchaseSaleGroup_Name=?, PurchaseSaleGroup_Code=?, active=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where PurchaseSaleGroup_Id=?";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString (1,purchasesalegroup_name);
	pstmt_p.setString (2,purchasesalegroup_code);
	pstmt_p.setBoolean(3,flag);
	pstmt_p.setString (4, user_id);
	pstmt_p.setDate (5,today_date);
	pstmt_p.setString(6,machine_name);
	pstmt_p.setString (7,purchasesalegroup_id);	   
	int a = pstmt_p.executeUpdate();
	pstmt_p.close();
//out.print("type="+purchasesalegroup_type);
	C.returnConnection(conp);
	//out.print("type="+purchasesalegroup_type);
if("0".equals(purchasesalegroup_type))
		{
				response.sendRedirect("EditPurchaseSaleGroup.jsp?command=Edit1&purchasesalegroup_id="+purchasesalegroup_id+"&message3=Sale Group <font color=blue> "+purchasesalegroup_name+"  </font> successfully Updated");
		}else
		{
			
			//out.print("type="+purchasesalegroup_type);
			response.sendRedirect("EditPurchaseSaleGroup.jsp?command=Edit1&purchasesalegroup_id="+purchasesalegroup_id+"&message3=Purchase Group <font color=blue> "+purchasesalegroup_name+"  </font> successfully Updated");	
		}

	}
		else
	{
		C.returnConnection(conp);
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=3 color=red><b>Group Person <font color=blue>"+ purchasesalegroup_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}
}
catch(Exception e233){ 
	C.returnConnection(conp);

	out.println("<br><font color=red><h2> FileName : UpdatePurchaseSaleGroup.jsp <br>Bug No e233 :"+ e233 +"</h2></font>");}
}//if UPDATE PURCHASESALE*/
%>








