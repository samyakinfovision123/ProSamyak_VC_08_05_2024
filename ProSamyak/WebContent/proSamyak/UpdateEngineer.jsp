<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();

java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//System.out.print(format.format(D));
//out.print("today_date==>"+today_date);
String command  = request.getParameter("command");
String message  = request.getParameter("message");
String Master=request.getParameter("Master");
String master=request.getParameter("master");

System.out.print("Master==>"+Master);
System.out.print("master==>"+master);

ResultSet rs= null;
Connection con = null;
PreparedStatement pstmt=null;

if("Add".equals(command))
{
try
{
	con=C.getConnection();
	String name	= request.getParameter("name1");	
	String description = request.getParameter("description1");
	
	//System.out.println("name"+name+"Name Lenght="+name.length());
	//name=name.trim();
	//System.out.println("name"+name+"Name Lenght="+name.length());

	String selectquery ="Select * from master"+Master+"  where "+master+"Name=?"; 
	pstmt = con.prepareStatement(selectquery);
	pstmt.setString (1,name);		
	int nameexist=0;
	rs = pstmt.executeQuery();	
	while(rs.next())
	{nameexist++;}
	pstmt.close();

	if(nameexist<1)
	{
		String mId= ""+L.get_master_id(con,"master"+Master+"");
		String sr_No=request.getParameter("sr_no");
		String active=request.getParameter("active");
		int flag = 0; 
		if("yes".equals(active)){flag =1;}
		String query = " INSERT INTO master"+Master+" ( "+master+"Id, "+master+"Name, "+master+"Description, srNo,modifiedOn, modifiedBy, modifiedMachineName,active) values(?,?,?,?, ?,?,?,?)";

		pstmt = con.prepareStatement(query);
		pstmt.setString (1,mId);		
		pstmt.setString (2,name);	
		pstmt.setString (3,description);	
		pstmt.setString (4,sr_No);
		pstmt.setDate (5, D);			
		pstmt.setString (6,user_id);			
		pstmt.setString (7,machine_name);	
		pstmt.setInt (8, flag);		
		//out.println("Before Query <br>"+query);
		int a = pstmt.executeUpdate();
		C.returnConnection(con);
		//out.println("Before Query <br>a"+a);
		//System.out.println("After query result a is "+a);
		response.sendRedirect("NewEngineer.jsp?command=Default&Master="+Master+"&master="+master+"&message="+Master+" <font color=blue>"+name+" </font>successfully Added");
	}
	else
	{
		C.returnConnection(con);

		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Engineer <font color=blue>"+name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
	}//if end
}catch(Exception e4)
{ 
	C.returnConnection(con);
	out.println("Samyak Bug is"+e4);
}
}//if ADD ENGINEER



if("Edit".equals(command))
{
	//out.print("<BR> In Edit ");
	try
	{
		if("Default".equals(message))
		{
			
		}else if(message!=null)
		{
			out.println("<center><font class='message1'> "+message+"</font></center>");
		}

		con=C.getConnection();
		String query="";
	
		query="Select "+master+"Id,srNo,"+master+"Name,"+master+"description  from master"+Master+""; 
		pstmt = con.prepareStatement(query);
		rs=pstmt.executeQuery();
	%>
	<html>
	<head>
<!--	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>-->
	</head>

<body background="../Buttons/BGCOLOR.JPG">

	<form name="EditForm">
	<table border=1 align=center>
	<tr bgColor=#99CCFF >
	<th colspan=3>Select <%=Master%> Name For Edit</th>
	</tr>
	<tr>
	<th>Sr.No</th>
	<th>Name</th>
	<th>Description</th>
	</tr>
	<%
	String id = null ;
	while(rs.next())
	{
	%>
		<tr>
			<td><%=rs.getInt("srNo")%></td>
			<td><a href="EditEngineer.jsp?command=Edit&Master=<%=Master%>&master=<%=master%>&Id=<%=rs.getString(""+master+"Id")%>">
			<%=rs.getString(""+master+"Name")%></a></td>
			<td><%=rs.getString(""+master+"Description")%></td>	
		</tr>
	<%
	}
	C.returnConnection(con);
	}
	catch(Exception e)
	{
		C.returnConnection(con);
		out.print(e.getMessage());
	}
}
	%>
		</table>
		</form>
	</body>
</html>
	


<%
if("Update".equals(command))
{
	try 
	{
		con=C.getConnection();

		String name="";
		String description="";
		String sr_no="";
		String Id="";

		int activeflag=0;
		String str="";

		Id= request.getParameter("mId");
		name = request.getParameter("name1");
		//System.out.println("name"+name);
		//name=name.trim();
		//System.out.println("name"+name+"name Length");

		description = request.getParameter("desc");
		sr_no= request.getParameter("sr_no");	
		
		String selectquery ="Select * from master"+Master+"  where "+master+"Name=? AND "+master+"Id!=?"; 
		pstmt = con.prepareStatement(selectquery);
		pstmt.setString (1,name);		
		pstmt.setString (2,Id);		
		int nameexist=0;
		rs = pstmt.executeQuery();	
		while(rs.next())
		{nameexist++;}
		//out.print("nameexist"+nameexist);
		pstmt.close();

		if(nameexist<1)
		{
		
		//System.out.println("nameexist====================>>>>>>>>>>>>"+nameexist);

		if("yes".equals(request.getParameter("active")))
		{ activeflag=1; }
		//out.print("<BR>before queryunit_description"+unit_description);
		String query1 = "Update  master"+Master+" set  "+master+"Name=?, "+master+"Description=?, modifiedOn=?, modifiedBy=?, modifiedMachineName=?,  active=? where "+master+"Id="+Id+"";
		//out.print("<BR> query=" +query1);

		pstmt = con.prepareStatement(query1);
	
		pstmt.setString (1,name);	
		pstmt.setString (2,description);	
		pstmt.setDate (3, today_date);			
		pstmt.setString (4,user_id);			
		pstmt.setString (5,machine_name);	
		//out.print("<br> 6"+active);	
		pstmt.setInt (6, activeflag);		
	
		int aa = pstmt.executeUpdate();
		pstmt.close();

		C.returnConnection(con);

		response.sendRedirect("UpdateEngineer.jsp?command=Edit&Master="+Master+"&master="+master+"&message=Master "+Master+"  <FONT  COLOR='#0000CC'>"+name+"</FONT> successfully updated.");
		}
		else
		{
			C.returnConnection(con);

			out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Engineer <font color=blue>"+name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
		}
	}catch(Exception e93)
	{ 
		C.returnConnection(con);
		out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +"</font>");
	}
}//Update Unit
%>





