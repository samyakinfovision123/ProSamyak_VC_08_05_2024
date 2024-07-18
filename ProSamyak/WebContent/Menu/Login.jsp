<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>

<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

 <%
	String command = request.getParameter("command");
	Connection con=null;
	con=ConnectDB.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 %>
<%
try
{
if(command.equals("default"))
{%> 
	<html>
	<head>
	<title>User Login</title>
	<link href='../Dove/dovecss.css' rel='stylesheet' style='text/css'>
	<script language ="javascript">


			function submitForm()
			{	
				if(document.theForm.Entity.value=="HO")
				{
					document.theForm.EntityID.value ="1"; 
					document.theForm.EntityValue.value ="HO"; 
				}
				if(document.theForm.Entity.value== "Company")
				{
				document.theForm.EntityID.value	="2";
				document.theForm.EntityValue.value	="Company";
				}
				
				document.theForm.submit();
			}
</script>
</head>
<body>
<center>
<table align=center bordercolor=skyblue  border=1 cellspacing=2 cellpadding=2 width="450">
<tr>
<th class='td6' colspan=2 align=center>User Login</th>
<form name ="theForm" action ="Login.jsp?command=user" method ="post" onSubmit ="verify(this)">
</tr>
<tr><td align="center" > Entity </td>
<td align="center" >
   <select name ="Entity" onChange="submitForm()">
		 <option value ="Select" Selected>Select</option>
		 <option value ="HO" >H.O.</option>
		 <option value ="Company" >Company</option>
		</select></td>
		<input type ="hidden" name = "EntityID" value ="">
		<input type ="hidden" name = "EntityValue" value ="">

</td><tr>
</form>
</table>
</center>
</body>
</html>

<%	ConnectDB.returnConnection(con);
}//command
	
if(command.equals("user"))
{
	//out.print("inside User command");
	String EntityValue =request.getParameter("EntityValue");
	int EntityID = Integer.parseInt(request.getParameter("EntityID"));
	
%>
<html>
<head>
<link href="../Dove/dovecss.css" rel=stylesheet style="text/css">
	<script language ="javascript">
	function Test()
	{
		if(document.theForm.UserName.value==0)
		{
			alert('Please Enter User Name');
			document.theForm.UserName.focus();
			return false;
		}
		if(document.theForm.Password.value==0)
		{
			alert('Please Enter Password');
			document.theForm.Password.focus();
			return false;
		}
		return true;

	}
	function submitForm()
	{	
		document.theForm.submit();
	}
	</script>
</head>
<body class=bgimage>
<br>
<br>
<center>
					
<table align=center bordercolor=skyblue  border=1 cellspacing=2 cellpadding=2 width="450">
<tr>
<th class="td6" colspan=2>User Login</th>
</tr>
<form name ="theForm" action ="Login.jsp?EntityID=<%=EntityID%>" method ="post" >
<input type ="hidden" name ="EntityID" value ="<%=EntityID%>">
<tr>
	<td class=td4 align="center" >UserName <font class=star1>*</font></td>
	<td class=td4 align="center" ><input type ="text" name ="UserName"> </td>
</tr>
<tr>
	<td class=td4 align="center" >Password <font class=star1>*</font></td>
	<td class=td4 align="center" ><input type ="text" name ="Password"> </td>	
</tr>
<tr>
	<td align="right" ><input type ="submit" name ="command" class=button1 value="Login" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick='return Test()'> </td>
	<td align="center" ><input type ="submit" name ="command" class=button1 value="Cancel" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> </td>
</form>
</center>
</table>
</body>
</html>
	<%
     ConnectDB.returnConnection(con);
	}//command
	if(command.equals("Login"))
	{
		int EntityId = Integer.parseInt(request.getParameter("EntityID"));
		int UserID = 0;


		

	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;	
 
	Connection cong=ConnectDB.getConnection();
	

	String user_name="";
	String user_pass="";
	String user_id="";
	String name="",pass="",company_id="";
	String outlet_id="";
	int user_level = 100;
	int Region_Id = 1;
	boolean flag = false,adminflag=false,Logged_In=false;

	user_name = request.getParameter("UserName");
	//out.print("<br>User_name="+user_name);
	user_pass = request.getParameter("Password");
	//out.print("<br>user_pass="+user_pass);

	//String command = request.getParameter("command");
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date validity = new java.sql.Date(System.currentTimeMillis());


	String query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1 "; 

	pstmt_g  = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();
	int i=0;
	while(rs_g.next()) 
		{
			i++;
		}
	pstmt_g.close();

out.print("i="+i);
out.print("UserName="+user_name);
out.print("User_Pass"+user_pass);

if(i==1)
{
	 query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1 "; 

	 pstmt_g  = cong.prepareStatement(query);
	 rs_g = pstmt_g.executeQuery();

	 while(rs_g.next()) 
		{ 
			
			flag = true;
			user_id = rs_g.getString("User_Id");
			name=rs_g.getString("User_Name");
			pass=rs_g.getString("User_Password");
			user_level = rs_g.getInt("Priviledge_Level");
			validity=rs_g.getDate("Valid_Upto");
			//Region_Id=rs_g.getInt("Region_Id");
			company_id = rs_g.getString("company_Id");
			//Logged_In = rs_g.getBoolean("Logged_In");
			
		if(user_pass.equals(pass)&&user_name.equals(name)&&user_level==5&&(!(Logged_In)))
		{	adminflag=true;
			
		}
		}
	pstmt_g.close();


 query="Update Master_User set Logged_In=? where user_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setBoolean(1,true);
pstmt_g.setString (2,user_id);
int a692 = pstmt_g.executeUpdate();
pstmt_g.close();
	//C.returnConnection(cong);
out.print("Validity="+validity);
	///boolean v_flag=D.before(validity); //to be added later on
if(!(Logged_In))
	{
boolean v_flag=true;
out.print("v_flag="+v_flag);

	if(v_flag&&adminflag)
	{
	
	//C.returnConnection(cong);
	


	session.putValue("user_id",user_id);
	session.putValue("company_id",company_id);
	session.putValue("user_level",""+user_level);
	//session.putValue("Region_Id",""+Region_Id);
    session.putValue("outlet_id",""+outlet_id);
System.out.println("Inside if");
//	response.sendRedirect("Home/AdminFrame.html");
response.sendRedirect("Home/Dove.jsp?Flag=admin");	
	}

if(v_flag)
{flag=true;}
else
{flag=false;}
	}
if((flag)&&!(Logged_In)) //if user is valid user
{	
	System.out.println("254 Inside if");
	String machine_name=request.getRemoteHost();
	System.out.println("\nUser:- "+user_name +" logged from Machine:-"+machine_name);
	System.out.println("\nuser_level:- "+user_level);
	session.putValue("user_id",user_id);
	session.putValue("company_id",company_id);
	session.putValue("user_level",""+user_level);
//	session.putValue("Region_Id",""+Region_Id);
	session.putValue("outlet_id",""+outlet_id);
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

	ConnectDB.returnConnection(cong);

	if(goldCount == 0)
		response.sendRedirect("Home/GoldRate.jsp?command=Default");
	else
		*/
	//ConnectDB.returnConnection(cong);
	//response.sendRedirect("/Home/Dove.jsp");
response.sendRedirect("Menubar1.jsp?EntityId=3&UserID="+user_id); 
//System.out.println(" 284Inside if");
}
else
{ 
	//System.out.println("288 Inside if");
 ConnectDB.returnConnection(cong);
if(!(Logged_In))
	{

response.sendRedirect("index1.html?command=Default&msg= Invalid User Name or Password");
	}
else{
	response.sendRedirect("index2.html?command=Default&msg=  User already logged in");
}
}

}
else //if no user found 
{
	ConnectDB.returnConnection(cong);
if(!(Logged_In))
	{

response.sendRedirect("index1.html?command=Default&msg= Invalid User Name or Password");
	}
else{
	response.sendRedirect("index2.html?command=Default&msg=  User already logged in");
}
}
ConnectDB.returnConnection(cong);
ConnectDB.returnConnection(con);

	}//command
}//try
catch(Exception e)
{
	ConnectDB.returnConnection(con);
	out.print(e);
}
	%>
		