
<%
/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		22/04/2011	start 		add one coloum  

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/

%>

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"   class="NipponBean.Connect" /> 
<jsp:useBean id="A" class="NipponBean.Array"/>
<html>
	<HEAD>
		<META HTTP-EQUIV="Expires" CONTENT="Tue, 20 Oct 1998 23:00: GMT">
	</HEAD>
</html>
<%
String errLine="4";
Connection cong = null;
String category_code=null;
boolean onBlurDescSize=false;
try{

	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;	

 //out.print("Yes");
	cong=C.getConnection();
 //out.print("<br> again yes ");
			
	String user_name="";
	String user_pass="";
	String user_id="";
	String empName="";
	String name="",pass="",company_id="";
	String yearend_id="0";
	int user_level = 100;
	//int user_name = 1;
	boolean flag = false,adminflag=false,Logged_In=false;

	user_name = request.getParameter("user_name");
	//System.out.print("<br>User_name="+user_name);
	user_pass = request.getParameter("user_pass");
	//System.out.print("<br>user_pass="+user_pass);

	String command = request.getParameter("command");
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date validity = new java.sql.Date(System.currentTimeMillis());
	errLine="34";


	String query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1 "; 
 //out.print("<br>before Query"+query);
	pstmt_g  = cong.prepareStatement(query);
 //out.print("<br> Query"+query);
	rs_g = pstmt_g.executeQuery();
	int i=0;
	while(rs_g.next()) 
		{
			i++;
		}
	pstmt_g.close();

//System.out.println("<br>48 i="+i);
System.out.println("User "+user_name+" Logged In");
//System.out.println("<br>50 User_Pass"+user_pass);
	errLine="52";
if(i==1)
{
	int a=0,b=0;
	 query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1 "; 

	 pstmt_g  = cong.prepareStatement(query);
	 rs_g = pstmt_g.executeQuery();

	 while(rs_g.next()) 
	 { 
			user_id = rs_g.getString("User_Id");
			name=rs_g.getString("User_Name");
			//out.print("User_Pass"+name);
			pass=rs_g.getString("User_Password");
			//out.print("User_Pass"+pass);
			user_level = rs_g.getInt("Priviledge_Level");
			validity=rs_g.getDate("Valid_Upto");
			//user_name=rs_g.getInt("user_name");
			company_id = rs_g.getString("company_Id");
			empName =rs_g.getString("EngineerId"); 
			
			if("1".equals(user_id) && "0".equals(company_id) && "admin".equals(name) && "admin".equals(pass))
			{
				Logged_In = true;
			}
			
			
			//Logged_In = rs_g.getBoolean("Logged_In");

			
			//	System.out.print("<br>74 user_level"+user_level);
			if(user_pass.equals(pass)&& user_name.equals(name)&& Logged_In==true)
			{	
			
				adminflag=true;
				a++;
				//System.out.println("outside");
				
			}
			else
			if(user_pass.equals(pass)&& user_name.equals(name)&& Logged_In== false)
			{
				b++;
				flag=true;

				//	System.out.println("inside");
			}
	}
	pstmt_g.close();
	
	String query1 ="select category_code from Master_CompanyParty where super=1 and companyParty_Id="+company_id;

	pstmt_g  = cong.prepareStatement(query1);
	rs_g = pstmt_g.executeQuery();

	while(rs_g.next()) 
	{ 
			category_code=rs_g.getString("category_code");
	}
	pstmt_g.close();
	int intCompanyId = Integer.parseInt(company_id);
	if(intCompanyId > 0)
	{

		int maxyearend_id=0;
		query="SELECT max(yearend_id) as maxy_id from yearend where company_id=?";

		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+company_id);
		rs_g = pstmt_g.executeQuery();

		while(rs_g.next())
			{
				maxyearend_id =rs_g.getInt("maxy_id");		
			}
		pstmt_g.close();

		yearend_id = ""+maxyearend_id;
	}

	errLine="137";
	if(adminflag==true)
	{
		//100
	//String empName = A.getNameCondition(cong , "masterEngineer", "engineerName", "  where active = 1  and ";	
	session.putValue("user_id",user_id);
	session.putValue("company_id",company_id);
	session.putValue("user_level",""+user_level);
	session.setAttribute("empName" ,empName) ;
	session.putValue("user_name",""+name);
    session.putValue("yearend_id",""+yearend_id);
    session.putValue("usDlr","2");
    session.putValue("exRateDec","4");
    session.putValue("baseCurrencySymbol","US $");
   	session.putValue("category_code",""+category_code);
	if("3".equals(category_code))
	{
		onBlurDescSize=true;
	}
	else
	{
		onBlurDescSize=false;
	}
	session.putValue("onBlurDescSize",new Boolean(onBlurDescSize));
//	response.sendRedirect("Home/AdminFrame.html");
	errLine="156";
	response.sendRedirect("Home/Samyak.jsp?Flag=admin");	
	}

//if(v_flag)
//{flag=true;}
else
//{flag=false;}
	
//if((flag)&&!(Logged_In)) //if user is valid user
if(flag==true)
{	
	//System.out.println("133"+a);
	//String machine_name=request.getRemoteHost();
	//System.out.println("\nUser:- "+user_name +" logged from Machine:-"+machine_name);
	//System.out.println("\nuser_level:- "+user_level);
	System.out.println("167 user_id=:- "+user_id+" = ");
	//100
	//String empName = A.getNameCondition(cong , "masterEngineer", "engineerName", "  where active = 1  and ";
	errLine="173";
	session.putValue("user_id",user_id);
	session.setAttribute("empName",empName);
	session.putValue("company_id",company_id);
	session.putValue("user_level",""+user_level);
	session.putValue("user_name",""+name);
	session.putValue("yearend_id",""+yearend_id);
	session.putValue("usDlr","2");
    session.putValue("exRateDec","4");
	session.putValue("baseCurrencySymbol","US $");
	session.putValue("category_code",""+category_code);
	if("3".equals(category_code))
	{
		onBlurDescSize=true;
	}
	else
	{
		onBlurDescSize=false;
	}
	session.putValue("onBlurDescSize",new Boolean(onBlurDescSize));
	//out.print("<br>Date="+D);
	/*int goldCount=0;
	query="select GoldRate_Id from Master_GoldRate where GoldRate_Date=?";
	
	pstmt_g=cong.prepareStatement(query);
	pstmt_g.setString(1,""+D);
	rs_g=pstmt_g.executeQuery();
	while(rs_g.next())
		goldCount++;
	pstmt_g.close();
	//out.println("\n goldCount"+goldCount);

	C.returnConnection(cong);

	if(goldCount == 0)
		response.sendRedirect("Home/GoldRate.jsp?command=Default");
	else
		*/
	//C.returnConnection(cong);
		System.out.println("202 from indexSparkler");
	response.sendRedirect("Home/Samyak.jsp");
		System.out.println("204 from indexSparkler");
		



}
else
{ 
 C.returnConnection(cong);
	if(!(Logged_In))
		{

		response.sendRedirect("index1.html?command=Default&msg= Invalid User Name or Password");
		}
	else{
			response.sendRedirect("index2.html?command=Default&msg=  User already logged in");
		}
}


}

else 
{
	C.returnConnection(cong);
	if(!(Logged_In))
		{

			response.sendRedirect("index1.html?command=Default&msg= Invalid User Name or Password");
		}
	else{
			response.sendRedirect("index2.html?command=Default&msg=  User already logged in");
		}
	
	
	
	
}
C.returnConnection(cong);

	errLine="233";

}
	catch(Exception Samyak89)
	{ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : indexSparkler.jsp <br>Bug No Samyak89 :"+ Samyak89 +" 	errLine= "+errLine+" </font>");
	}%>

