<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="GD"   class="NipponBean.GetDate" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="R"  scope="application"    class="NipponBean.rapSearch" />

<%
//This is the normal file 
//No. of lines = 321
	//System.out.print(" Inside GL_Index.jsp");	
	Connection cong = null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;	

String user_name="";
String user_pass="";
String user_id="";
String company_id="";
String yearend_id="";
String	user_id1="";
int user_level = 100;
boolean flag = false;


//Loads Rapaport files into Collections in memory- from rapSearch.java (NipponBean.rapSearch)
//R.loadRapaportCollection();
//System.out.println("<BR> 24 indexNippon - Rap Collection Loaded");
//System.out.println("*****************************************");
yearend_id = request.getParameter("yearend_id");
//System.out.println("32 yearend_id="+yearend_id);
company_id = request.getParameter("company_id");
//System.out.println("34 company_id="+company_id);
//System.out.println("\n");
user_id = request.getParameter("user_id");
//System.out.println("35 user_id="+user_id);
//System.out.println("\n");
user_name = request.getParameter("user_name");
//System.out.println("37 user_name="+user_name);
user_pass = request.getParameter("user_pass");
//System.out.println("39 user_pass="+user_pass);
String command = request.getParameter("command");
//System.out.println("41Command "+command);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date validity = new java.sql.Date(System.currentTimeMillis());
String query = "";
try{

if("LOGIN".equals(command))
{
	//System.out.println("<br>52 Inside LOGIN");
	query ="select * from Master_User where User_Name='"+user_name+"' and User_Password='"+user_pass+"'  and active=1"; 

	cong=C.getConnection();

	pstmt_g  = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();
	int i=0;
//System.out.println("<br>61 Before While ");
	while(rs_g.next()) 
			{ i++;
			user_id = rs_g.getString("User_Id");
			//System.out.println("**************** user_id1="+user_id);
			company_id = rs_g.getString("Company_id");
			//System.out.println("<br>57 company_id="+company_id);
			
			}
			pstmt_g.close();

//out.print("<br><font color=#660066>Sam</font>");

	if(i==1)
	{
		
		if("0".equals(company_id))
			{
				session.putValue("company_id","0");
				session.putValue("yearend_id",yearend_id);
				session.putValue("user_id",user_id);
				session.putValue("user_level",""+user_level);
				session.putValue("user_name",""+user_name);
				C.returnConnection(cong);
				response.sendRedirect("Home/AdminHomepage.html");
			}

		//out.print("../indexNippon.jsp?user_pass="+user_pass+"&user_name="+user_name+"&company_id="+company_id+"&command=Select");
		C.returnConnection(cong);

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
		}
		pstmt_g.close();

		C.returnConnection(cong);

	%>
		<HTML>
		<HEAD>
		<title>Samyak Software </title>
		<link href='Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
		</HEAD>

		<BODY background="Buttons/BGCOLOR.JPG">
		<form action=indexNippon.jsp method=post name=login>
		<table border=0 bordercolor=red align=center cellspacing=0  width=600 height=600 cellpadding=0>
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

	else
	{
		C.returnConnection(cong);
		response.sendRedirect("index1.html");
	}

	
}//LOGIN
}catch(Exception Samyak89)
{ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : index.jsp <br>Bug No Samyak89 :"+ Samyak89 +"</font>");
}


/****************************************************/
if("Select".equals(command))
{
try{

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
		//System.out.println("<br>indexNippon.jsp 195 maxyearend_id=> "+maxyearend_id);
		//System.out.println("<br>indexNippon.jsp 195 company_id=> "+company_id);
		
		pstmt_g.close();
		
		C.returnConnection(cong);
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
	//out.print("<br>224  query=" +query);
	pstmt_g  = cong.prepareStatement(query);
	//pstmt_g.setString(1,user_name);
	//pstmt_g.setString(2,user_pass);
	rs_g = pstmt_g.executeQuery();
	i=0;
	while(rs_g.next()) 
	{
		uyearend_id[i]=rs_g.getString("YearEnd_Id");
		//out.print("<br>233 uyearend_id[i]="+uyearend_id[i]);
		uyearend_string[i]=GD.format(rs_g.getDate("From_Date"))+"-"+GD.format(rs_g.getDate("To_Date"));
		//out.print("<br>235 uuyearend_string[i]="+uyearend_string[i]);

		i++;
	}
	pstmt_g.close();



	//C.returnConnection(cong);

%>
<HTML>
<HEAD>
<title>Samyak Software </title>
<link href='Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY background="Buttons/BGCOLOR.JPG">
<form action=indexNippon.jsp method=post name=login>
<table border=0 bordercolor=red align=center cellspacing=0  width=600 height=600 cellpadding=0>
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
C.returnConnection(cong);
}
catch(Exception Samyak89)
{ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : indexNippon.jsp <br>Bug No Samyak89 :"+ Samyak89 +"</font>");}
}// "Select


/****************************************************/
if("Financial Year".equals(command))
{

	company_id = request.getParameter("company_id");
	query ="select * from Master_User where User_Name = '"+user_name+"' and User_Password = '"+user_pass+"'  and Active=1 and Company_Id="+company_id+""; 
	//out.print("<br> query277=> "+query);

try{

	cong=C.getConnection();	
	pstmt_g  = cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	//out.print("295SAmyak");
	while(rs_g.next()) 
	{ 
		flag = true;
		user_id = rs_g.getString("User_Id");
		//System.out.println("292 <font color=red> user_id=</font> "+user_id);
		company_id = rs_g.getString("company_Id");
		//System.out.println("<br>294 <font color=red> company_id=</font> "+company_id);
		//System.out.println("<br>299 flag="+flag);
		user_level = rs_g.getInt("Priviledge_Level");
		//System.out.println("<br>308 <font color=red> user_level=</font> "+user_level);
			
		validity=rs_g.getDate("Valid_Upto");
        //out.print("<br>296<font color=red> validity=</font> "+validity);
	}
	pstmt_g.close();
	C.returnConnection(cong);

	boolean v_flag=D.before(validity);
	//out.print("<br>299 D"+D);
	//out.print("<br>300 validity"+validity);
	//out.print("<br>299 vality=" +v_flag);
	if(v_flag)
		{flag=true;}
	else
		{flag=false;}
}
catch(Exception Samyak109)
{ 
	C.returnConnection(cong);
	out.println("<font color=red> FileName : index.jsp <br>Bug No Samyak109 :"+ Samyak109 +"</font>");
}

out.print("<br>303 flag=>"+flag);
//flag=true;
if(flag) //if user is valid user
{	
	String machine_name=request.getRemoteHost();
	//out.print();
	//System.out.println("314 User:- "+user_name +" logged from Machine:-"+machine_name);
	session.putValue("yearend_id",yearend_id);
	//System.out.println("indexNippon.jsp 316 yearend_id "+yearend_id);
	// +" logged from Machine:-"+machine_name);
	session.putValue("user_id",user_id);

	//System.out.println("319 user_id= "+user_id);
	session.putValue("company_id",company_id);
	//System.out.println("321 company_id= "+company_id);
	session.putValue("user_level",""+user_level);
	//System.out.println("323 user_level= "+user_level);
	session.putValue("user_name",""+user_name);
	//System.out.println("325 user_name= "+user_name);
	session.setMaxInactiveInterval(10800);	
	//to the real path from the virtual path
	//System.out.println("<br>316 ");
	//out.println(application.getRealPath("Samyak"));
	response.sendRedirect("Home/Samyak.jsp");
}
else
{ 
	//response.sendRedirect("index1.html");
}
}//financial year

%>