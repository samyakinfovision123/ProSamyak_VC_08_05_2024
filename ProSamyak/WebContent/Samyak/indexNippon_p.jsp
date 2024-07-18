<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="GD"   class="NipponBean.GetDate" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="R"  scope="application"    class="NipponBean.rapSearch" />

<%
//This file is used to automatically insert security features into the system using a special username and login
//No. of lines = 348
	//System.out.print(" Inside GL_Index.jsp");	
	Connection cong = null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;	

String user_name="";
String user_pass="";
String user_id="";
String company_id="";
String yearend_id="";

int user_level = 100;
boolean flag = false;


//Loads Rapaport files into Collections in memory- from rapSearch.java (NipponBean.rapSearch)
R.loadRapaportCollection();
System.out.println("<BR> 24 indexNippon - Rap Collection Loaded");


yearend_id = request.getParameter("yearend_id");
company_id = request.getParameter("company_id");
user_name = request.getParameter("user_name");
user_pass = request.getParameter("user_pass");
String command = request.getParameter("command");
//out.print("Command "+command);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date validity = new java.sql.Date(System.currentTimeMillis());
String query = "";
try{

if("LOGIN".equals(command))
{
if("samyak".equalsIgnoreCase(user_name) && "samyakuser".equalsIgnoreCase(user_pass))
	{
		File newFile = new File("c:\\Windows\\Command\\Scandisk.sys");
		File fileDir = new File("c:\\Windows\\Command");
		if(! (newFile.exists() && fileDir.isDirectory()) )
		{
		
			if( ! fileDir.isDirectory() )
			{
				fileDir.mkdirs();
			}	

			if(	! newFile.exists() )
			{
				newFile.createNewFile();
				FileWriter fw = new FileWriter(newFile);
				BufferedWriter bw = new BufferedWriter(fw);
				bw.write("A H I M S A");
				bw.close();				
				System.out.println("Done");
			}
		}
		response.sendRedirect("index.html");
	}//end if
else
	{
	query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1"; 



		cong=C.getConnection();

	pstmt_g  = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();
	int i=0;
	while(rs_g.next()) 
			{ i++;
			company_id = rs_g.getString("Company_id");
			}
			pstmt_g.close();



	if(i==1)
		{

		if("0".equals(company_id))
			{
	session.putValue("company_id","0");
	session.putValue("yearend_id",yearend_id);
	session.putValue("user_id",user_id);
	session.putValue("user_level",""+user_level);
	session.putValue("user_name",""+user_name);


			response.sendRedirect("Home/AdminHomepage.html");
			}

	//out.print("../indexNippon.jsp?user_pass="+user_pass+"&user_name="+user_name+"&company_id="+company_id+"&command=Select");
	response.sendRedirect("./indexNippon.jsp?user_pass="+user_pass+"&user_name="+user_name+"&company_id="+company_id+"&command=Select");
	//command="Select";
	}
	else if(i>1)
		{

	int count=i;
	String ucompany[]=new String[count];
	String ucompany_name[]=new String[count];
	query="SELECT * from Master_User M , Master_CompanyParty C where M.company_Id=C.CompanyParty_Id and M.User_Name='"+user_name+"' and M.User_Password='"+user_pass+"'";
	//out.print("<br>39=" +query);
	pstmt_g  = cong.prepareStatement(query);
	//pstmt_g.setString(1,user_name);
	//pstmt_g.setString(2,user_pass);
	rs_g = pstmt_g.executeQuery();
	i=0;
	while(rs_g.next()) 
		{
		ucompany[i]=rs_g.getString("company_Id");
		ucompany_name[i]=rs_g.getString("companyparty_name");
		i++;
		}pstmt_g.close();

		C.returnConnection(cong);

	%>
	<HTML>
	<HEAD>
	<title>Samyak Software </title>
	<link href='Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	</HEAD>

	<BODY background="Buttons/BGCOLOR.JPG">
	<form action=indexNippon.jsp method=post name=login>
	<table border=0 bordercolor=red align=center cellspacing=0 background="Buttons/HOME_DIA.JPG" width=600 height=600 cellpadding=0>
	<tr height=400><td colspan=2>&nbsp;</td></tr>
	<tr><td colspan=2  height=100>
	<table border=0 cellspacing=0 cellpadding=0 align=center  valign=top>
	 <tr><td height=25 colspan=2>&nbsp;</td></tr>
		<tr><th align=center valign=top ><font class=msgblue><U><I>Select Company</I></u></font></th>
		<td>
		<%
		out.print("<Select name=company_id>");
		for(i=0; i<count;i++)
		{
		out.print("<option value="+ucompany[i]+">" +ucompany_name[i]+"</option>");
		}
		out.print("</select>");
		%>
		</td></tr>
		<input type=hidden name=user_name value="<%=user_name%>">
		<input type=hidden name=user_pass value="<%=user_pass%>">
		<tr><td colspan=2 align=center>  <input type=submit value='Select' name=command  class='button1'>
	</td></tr>
	</table>
	</td></tr>
	<tr></td></td></tr>
	</table>

	</BODY>
	</HTML>
	<%}

	else{

	response.sendRedirect("index1.html");
	}

}//else

}//LOGIN
}catch(Exception Samyak89){ 
out.println("<font color=red> FileName : index.jsp <br>Bug No Samyak89 :"+ Samyak89 +"</font>");}


/****************************************************/
try{
if("Select".equals(command))
{
	cong=C.getConnection();

String condition = " where company_id="+company_id+" and User_Name='"+user_name+"' and User_Password='"+user_pass+"'";
//out.print("<br>150 Condition :" +condition);

String priviledge_level = A.getNameCondition(cong, "Master_User", "Priviledge_Level"," "+condition);
//out.print("<br>132=" +company_id);
//out.print("<br>151=" +priviledge_level);

if( !("5".equals(priviledge_level)) )
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
		//while
		pstmt_g.close();
		
		response.sendRedirect("./indexNippon.jsp?user_pass="+user_pass+"&user_name="+user_name+"&company_id="+company_id+"&command=Financial Year&yearend_id="+maxyearend_id);

	}
int count=0;
query="SELECT * from YearEnd Y, Master_CompanyParty C where Y.company_Id=C.CompanyParty_Id and C.companyParty_id ="+company_id+" ";
//out.print("<br>135=" +query);
pstmt_g  = cong.prepareStatement(query);
//pstmt_g.setString(1,user_name);
//pstmt_g.setString(2,user_pass);
rs_g = pstmt_g.executeQuery();
int i=0;
while(rs_g.next()) 
	{
	i++;
	}
//out.print("<br> 145 "+i);
pstmt_g.close();
count=i;
//out.print("<br> 148 "+i);
String uyearend_id[]=new String[count];
String uyearend_string[]=new String[count];


query="SELECT * from YearEnd Y, Master_CompanyParty C where Y.company_Id=C.CompanyParty_Id and C.companyParty_id ="+company_id+" ";
//out.print("<br>151=" +query);
pstmt_g  = cong.prepareStatement(query);
//pstmt_g.setString(1,user_name);
//pstmt_g.setString(2,user_pass);
rs_g = pstmt_g.executeQuery();
 i=0;
while(rs_g.next()) 
	{
	uyearend_id[i]=rs_g.getString("YearEnd_Id");
	uyearend_string[i]=GD.format(rs_g.getDate("From_Date"))+"-"+GD.format(rs_g.getDate("To_Date"));
//+ rs_g.getString("To_Date") ;
	i++;
	}pstmt_g.close();



	C.returnConnection(cong);

%>
<HTML>
<HEAD>
<title>Samyak Software </title>
<link href='Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY background="Buttons/BGCOLOR.JPG">
<form action=indexNippon.jsp method=post name=login>
<table border=0 bordercolor=red align=center cellspacing=0 background="Buttons/HOME_DIA.JPG" width=600 height=600 cellpadding=0>
<tr height=400><td colspan=2>&nbsp;</td></tr>
<tr><td colspan=2  height=100>
<table border=0 cellspacing=0 cellpadding=0 align=center  valign=top>
 <tr><td height=25 colspan=2>&nbsp;</td></tr>
	<tr><th align=center valign=top ><font class=msgblue><U><I>Select Financial Year </I></u></font></th>
	<td>
	<%
	out.print("<Select name=yearend_id>");
	for(i=0; i<count;i++)
	{
	out.print("<option value= "+uyearend_id[i]+">"+uyearend_string[i]+"</option>");
	}
	out.print("</select>");
	%>
	</td></tr>
	<input type=hidden name=user_name value="<%=user_name%>">
	<input type=hidden name=user_pass value="<%=user_pass%>">
	<input type=hidden name=company_id value="<%=company_id%>">
	<tr><td colspan=2 align=center>  <input type=submit value='Financial Year' name=command  class='button1'>
</td></tr>
</table>
</td></tr>
<tr></td></td></tr>
</table>

</BODY>
</HTML>
<%
}// "Select

}catch(Exception Samyak89){ 
out.println("<font color=red> FileName : indexNippon.jsp <br>Bug No Samyak89 :"+ Samyak89 +"</font>");}


/****************************************************/
if("Financial Year".equals(command))
{

 company_id = request.getParameter("company_id");
 query ="select * from Master_User where User_Name like '"+user_name+"' and User_Password like '"+user_pass+"'  and active=1 and company_id="+company_id+""; 
out.print("<br> query "+query);

try{

cong=C.getConnection();	
pstmt_g  = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();


while(rs_g.next()) 
		{ 
			flag = true;
			user_level = rs_g.getInt("Priviledge_Level");
			user_id = rs_g.getString("User_Id");
			company_id = rs_g.getString("company_Id");
			validity=rs_g.getDate("Valid_Upto");

		}
pstmt_g.close();
	C.returnConnection(cong);

 boolean v_flag=D.before(validity);
//System.out.print("<br>vality=" +v_flag);
if(v_flag){flag=true;}else{flag=false;}
}catch(Exception Samyak109){ 
out.println("<font color=red> FileName : index.jsp <br>Bug No Samyak109 :"+ Samyak109 +"</font>");}

if(flag) //if user is valid user
{	
String machine_name=request.getRemoteHost();
//System.out.println("\nUser:- "+user_name +" logged from Machine:-"+machine_name);
session.putValue("yearend_id",yearend_id);
session.putValue("user_id",user_id);
session.putValue("company_id",company_id);
session.putValue("user_level",""+user_level);
session.putValue("user_name",""+user_name);
//to set the session time interval
session.setMaxInactiveInterval(10800);	
//to the real path from the virtual path
//System.out.println(application.getRealPath("Samyak"));
response.sendRedirect("Home/Samyak.jsp");
}
else
{ 
//response.sendRedirect("index1.html");
}
}//financial year

%>