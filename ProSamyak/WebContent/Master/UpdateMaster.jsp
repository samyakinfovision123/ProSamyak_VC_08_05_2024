
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<% 
String newcommand = request.getParameter("newcommand");
//out.print("<br>Command is "+ newcommand );
String MASTER= request.getParameter("MASTER");
//out.print("<br> Table is "+ MASTER );
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

//out.print(MASTER);
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

String check = request.getParameter("flag");
String command  = request.getParameter("command");
ResultSet rs_g= null;
Connection cong = null;
Connection conp = null;
Statement st=null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
/*try	{
 	 conp=C.getConnection();
		}catch(Exception e11){ 
		out.println("<font color=red> FileName : GL_UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");}*/
		//out.println("command is "+command);


if("Add MASTER".equals(command))
{

try{
	cong=C.getConnection();
	conp=C.getConnection();
String MASTER_name	=request.getParameter("MASTER_name");	



	String selectquery ="Select * from Master_"+MASTER +" where "+MASTER +"_name=? "; 
pstmt_g = cong.prepareStatement(selectquery);
pstmt_g.setString (1,MASTER_name);
//out.print("<br>52"+MASTER_name);
//pstmt_p.setString (2,lotcategory_code);		
//pstmt_p.setString (2,company_id);	
//out.print("<br>54"+selectquery);
int nameexist=0;
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{nameexist++;}
//out.print("<br> nameexist"+nameexist);
pstmt_g.close();


if(nameexist<1)
	{

String MASTER_no= ""+L.get_master_id(cong,"Master_"+MASTER +"");
String MASTER_description=request.getParameter("MASTER_description");
String sr_no=request.getParameter("sr_no");
String active=request.getParameter("active");
boolean flag =false; 
if("yes".equals(active)){flag=true;}
String query="";
if(MASTER.equals("Description"))
		{

query = " INSERT INTO Master_"+MASTER +" ( "+MASTER+"_Id, "+MASTER +"_Name, "+MASTER +"_Desc, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?, ?,?,'"+format.getDate(today_string)+"',?,?,?)";

		}
		else{
 query = " INSERT INTO Master_"+MASTER +" ( "+MASTER+"_Id, "+MASTER +"_Name, "+MASTER+"_Description, Sr_No,Active,Modified_On, Modified_By, Modified_MachineName,YearEnd_Id) values(?,?,?, ?,?,'"+format.getDate(today_string)+"',?,?,?)";
out.print("<br >70 query"+query);
		}
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString (1,MASTER_no);		
//out.print("<br >1 "+category_no);
//pstmt_p.setString (2,MASTER_code);	
pstmt_p.setString (2,MASTER_name);	
//out.print("<br >2aa "+lotcategory_code);
pstmt_p.setString (3, MASTER_description);
//out.print("<br >3 "+lotcategory_name);
//pstmt_p.setString (5, lotcategory_description);			
//out.print("<br >4 "+lotcategory_description);
pstmt_p.setString (4,sr_no);			
//out.print("<br >5 "+sr_no);
pstmt_p.setBoolean (5, flag);	
//out.print("<br> 6"+active);	
pstmt_p.setString (6, user_id);		
pstmt_p.setString (7, machine_name);	
pstmt_p.setString (8,yearend_id);
//out.println("Before Query <br>"+query);
int a = pstmt_p.executeUpdate();
//out.println("Before Query <br>a"+a);
//System.out.println("After query result a is "+a);
pstmt_p.close();
C.returnConnection(conp);
C.returnConnection(cong);
//out.print("NewMaster.jsp?command=Default&message="+MASTER+"  <font color=blue>"+MASTER_name+" </font>successfully Added");

response.sendRedirect("../Master/NewMaster.jsp?MASTER="+MASTER+"&command=Default&message="+MASTER_name+" Successfully Added");

	}
else
{
		C.returnConnection(conp);
		C.returnConnection(cong);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Category <font color=blue>"+MASTER_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end


}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if ADD CATEGORY
%>



<!-- edit command -------------->


<%
if("Update".equals(command))
{
//out.print("<br >In Update");
try{
	cong=C.getConnection();
	conp=C.getConnection();
String MASTER_name	=request.getParameter("MASTER_name");	
int  active1  = 0;
String MASTER_Sr	=request.getParameter("sr_no");	
String MASTER_id	=request.getParameter("MASTER_id");	
String MASTER_desc	=request.getParameter("MASTER_description");	
String active = "0";
//out.print("<br >Before if loop"+request.getParameter("active"));
if("yes".equals(request.getParameter("active"))){
	//out.print("<br >In if loop");
	active = "1";	
}
 MASTER	=request.getParameter("MASTER");	
String query="";
//String selectquery ="Select * from Master_"+MASTER +" where "+MASTER +"_name=?  "; 
String selectquery ="Select * from Master_"+MASTER +" where "+MASTER +"_name=? AND "+MASTER+"_id!=?"; 
pstmt_g = cong.prepareStatement(selectquery);
pstmt_g.setString (1,MASTER_name);
pstmt_g.setString (2,MASTER_id);

//out.println("<br>149::Active= "+active);

//out.print("<br>54"+selectquery);
int nameexist=0;
rs_g = pstmt_g.executeQuery();	
while(rs_g.next())
{nameexist++;}
//out.print("<br> nameexist"+nameexist);
pstmt_g.close();
int tempflag1 = 0;
boolean tempflag=false;
if(nameexist<1)
	{
	tempflag=false;
if(active.equals("yes"))
		{
	tempflag=true;
	tempflag1 = 1 ;
		}

//System.out.println("master id= "+MASTER_id);
//System.out.println("flag "+tempflag);
//out.print("<br>160::"+MASTER);
if(MASTER.equals("Description"))
		{
 
 query="update Master_"+MASTER+" set "+MASTER+"_Name='"+MASTER_name+"', "+MASTER+"_Desc='"+MASTER_desc+"',Sr_No='"+MASTER_Sr+"',Active="+active+" where "+MASTER+"_Id="+MASTER_id;
		}
		else{

 query="update Master_"+MASTER+" set "+MASTER+"_Name='"+MASTER_name+"', "+MASTER+"_Description='"+MASTER_desc+"',Sr_No='"+MASTER_Sr+"',Active="+active+" where "+MASTER+"_Id="+MASTER_id;

		}


//,Active='"+active+"'
//out.println("<br>164 query= "+query);


pstmt_g = cong.prepareStatement(query);
//pstmt_g.setBoolean(1,tempflag);
int aa = pstmt_g.executeUpdate();
//out.print("<BR>175aa="+aa);
pstmt_g.close();
response.sendRedirect("../Master/NewMaster.jsp?MASTER="+MASTER+"&command=Default&message="+MASTER_name+" Successfully Added");

}
else
{
		C.returnConnection(conp);
		C.returnConnection(cong);

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font face=times new roman size=1 color=red><b>Category <font color=blue>"+MASTER_name+" </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}//if end




		C.returnConnection(conp);
		C.returnConnection(cong);

}catch(Exception e4){ 
	out.println("Samyak Bug is"+e4);
}
}//if Update 
%>






<%
if("Edit".equals(newcommand))
{
	//out.print("<BR> In Edit ");
	try
	{

		cong=C.getConnection();
		String query="";
	
	
	if(MASTER.equals("Description"))
		{
	query="Select "+MASTER+"_Id,"+MASTER+"_Name,"+MASTER+"_Desc,Sr_No  from Master_"+MASTER+" order by "+MASTER+"_Name"; 
		}
		else{
query="Select "+MASTER+"_Id,"+MASTER+"_Name,"+MASTER+"_Description,Sr_No  from Master_"+MASTER+" order by "+MASTER+"_Name"; 

		}
	
	
	
	//String query="Select *  from Master_"+MASTER; 
//	out.print("<br>125:"+query);
	pstmt_g = cong.prepareStatement(query);
	rs_g=pstmt_g.executeQuery();
	
%>
	<html>
	<head>
<!--	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>-->
</HEAD>

<body background="../Buttons/BGCOLOR.JPG">

	<form name="EditForm" action="EditMaster.jsp">
	<table border=1 align=center>
	<tr bgColor=#99CCFF >
	<th colspan=3>Select <%=MASTER%> Name For Edit</th>
	</tr>
	<tr>
	<th>Sr.No</th>
	<th>Name</th>
	<th>Description</th>
	</tr>
	<%
	String id = null ;
     //System.out.println("263id = ....");
	while(rs_g.next())
	{
		id=rs_g.getString(MASTER+"_Id");
		//System.out.println("266id="+id);
	%>
		<tr>
		<td><%=rs_g.getInt("Sr_No")%></td>
	<td><a href="../Master/EditMaster.jsp?newname=<%=rs_g.getInt("Sr_No")%>&master=<%=MASTER%>&id=<%=id%>"><%=rs_g.getString(MASTER+"_Name")%></a></td>
		
		<%if(MASTER.equals("Description"))
		{	
		%>
		
		<td><%=rs_g.getString(MASTER+"_Desc")%></td>
		
		<%}
		else{
%>
<td><%=rs_g.getString(MASTER+"_Description")%></td>
		<%}
		
		
		%>
		
		
		</tr>
	<%
	}
	C.returnConnection(cong);
	}
	catch(Exception e)
	{
		C.returnConnection(cong);
		out.print(e.getMessage());
	}
	%>
		</table>
	</form>
		</body>
		</html>
<%

}
%>
<%
if("Update Category".equals(command))
{

	try {
		conp=C.getConnection();
	//out.print("<BR>116<br>");


	String lotcategory_id="";
	String lotcategory_code="";
	String lotcategory_name="";
	String lotcategory_description="";
	String sr_no="";

	boolean activeflag=false;
	String str="";
	//out.print("<BR>116<br>");

	lotcategory_id= request.getParameter("lotcategory_id");
	lotcategory_code= request.getParameter("lotcategory_code");
	lotcategory_name = request.getParameter("lotcategory_name");
	//out.print("<BR>116<br>");

	lotcategory_description = request.getParameter("lotcategory_description");
	sr_no= request.getParameter("sr_no");	
//out.print("<BR>128<br>");
if("yes".equals(request.getParameter("active")))
		{ activeflag=true; }
	//out.print("<BR>before querylotcategory_description"+lotcategory_description);
	String query1 = "Update  Master_lotCategory set  lotCategory_Code=?,  lotCategory_Name=?, lotCategory_Description=?, sr_no=?, active=? where lotCategory_Id=?";
	//out.print("<BR> query=" +query1);
	pstmt_p = conp.prepareStatement(query1);
	pstmt_p.clearParameters();
	pstmt_p.setString(1,lotcategory_code);
	pstmt_p.setString(2,lotcategory_name);	
	pstmt_p.setString(3,lotcategory_description);
	pstmt_p.setString(4,sr_no);		
	pstmt_p.setBoolean(5,activeflag);		
	pstmt_p.setString(6,lotcategory_id);
	int a = pstmt_p.executeUpdate();
	
	pstmt_p.close();
	C.returnConnection(conp);
//	out.print("lotcategory_id a "+lotcategory_id+"yes"+a);
response.sendRedirect("EditCategory.jsp?command=edit&message=Master Category "+lotcategory_name+" successfully updated.");

	}catch(Exception e93)
	{ 
	out.println("<br><font color=red> Samyak Bug is  <br>Bug No e93 :"+ e93 +"</font>");}
	
}//Update Category
%>








