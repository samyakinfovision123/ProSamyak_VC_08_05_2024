<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="L"   class="NipponBean.login" />
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<% 
String user_id="1";// as user is admin
String company_id= ""+session.getValue("company_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
//String yearend_id= ""+session.getValue("yearend_id");

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
//System.out.println("Inside Updeate Account");
	ResultSet rs_g= null;
	Connection conp = null;
	Connection conm = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_m=null;
	
if("Save".equals(command))
{
try{
	conp=C.getConnection();
	conm=C.getConnection();

String query = "";
String user_companyid=""+company_id;
String CompanyParty_Id= request.getParameter("CompanyParty_Id");

if("0".equals(company_id))
{
user_companyid=CompanyParty_Id;
}

//out.print("Command is "+command);
String user_name		=request.getParameter("user_name");	

 query = " Select * from Master_User where  company_id="+user_companyid+" and user_Name=?";	
 pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1,user_name);
	rs_g = pstmt_p.executeQuery();
	int company_exist =0;
	while(rs_g.next())
		{
		company_exist++;
		}//while
		pstmt_p.close();
//C.returnConnection(conp);
if(company_exist>0)
	{
	C.returnConnection(conp);
	out.print("<body bgcolor=ffffee background='../Buttons/BGCOLOR.JPG'>" );
	out.print("<center><font class='star1'>User "+user_name+" alredy exists for the selected Company</font></center><br>" );
	out.print("<center><input type=button name=command value=Back class='Button1' onclick='history.go(-1)'></center>" );
        
	}
else{                             

//conp=C.getConnection();


String user_password	=request.getParameter("user_password");
String priviledge_level= request.getParameter("priviledge_level");
String department_id= request.getParameter("department_id");

String user_newid= ""+L.get_master_id(conp,"Master_user");
String yearend_id=A.getNameCondition(conp,"YearEnd","YearEnd_Id", "Where  company_id="+user_companyid+" and active=1");
out.print("<br> 75 yearend_id"+yearend_id);
//conm
query = " INSERT INTO Master_User ( User_Id,Company_Id, User_Name, User_Password, Priviledge_Level, department_id, CreatedBy_Id, Created_On, Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values(?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',  ?, '"+format.getDate(today_string)+"', ?,?)";

//total columns = 11
//Department_Id
//
	out.print("<br> 90 query"+query);
pstmt_m = conm.prepareStatement(query);
pstmt_m.setString (1,""+ user_newid);		
//out.print("<br>1user_newid"+user_newid);
pstmt_m.setString (2,""+user_companyid);
//out.print("<br>2 company_id"+user_companyid);
pstmt_m.setString(3,""+user_name);
//out.print("<br>3 user_name"+user_name);
pstmt_m.setString (4,""+user_password);	
//out.print("<br>4 user_password"+user_password);
pstmt_m.setString (5,""+priviledge_level);	
//out.print("<br>5priviledge_level "+priviledge_level);
pstmt_m.setString (6,""+department_id);	
//out.print("<br>6"+department_id);
pstmt_m.setString (7,""+ user_id);
//out.print("<br> 6user_id"+user_id);	
pstmt_m.setString (8,""+ user_id);
//out.print("<br> 7user_id"+user_id);	
pstmt_m.setString (9, ""+machine_name);
//out.print("<br> 8machine_name"+machine_name);	
pstmt_m.setString (10,""+yearend_id);
//out.println("Before Update User Query <br>"+query);
int a = pstmt_m.executeUpdate();

out.println("<br>115 Success(a)=>"+a);
//C.returnConnection(conm);

response.sendRedirect("NewUser.jsp?message=User <font color=blue> "+user_name+" </font>successfully Added");
}
}catch(Exception Samyak45){ 
out.println("<br><font color=red><h2> FileName : UpdateUser.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}
}//if Save





if("Update".equals(command))
{
try{
	conp=C.getConnection();
String query = "";

int counter= Integer.parseInt(request.getParameter("counter"));
// out.print("<br>counter="+counter);
String userid[]=new String[counter];
String user_name[]=new String[counter];
String user_password[]=new String[counter];
String priviledge_level[]=new String[counter];
String department_id[]=new String[counter];
boolean active[]=new boolean[counter];

//out.print("Command is "+command);
for(int i=0; i<counter; i++)
{
// out.print("<br>");
userid[i]=request.getParameter("user_id"+i);	
user_name[i]=request.getParameter("user_name"+i);	
// out.print("user_name[i]"+user_name[i]);
user_password[i]	=request.getParameter("user_password"+i);
priviledge_level[i]= request.getParameter("priviledge_level"+i);
department_id[i]= request.getParameter("department_id"+i);
String act=request.getParameter("active"+i);
//out.print("act="+act);
active[i]=false;
if("yes".equals(act))
	{active[i]=true;}

}//for 
// out.print("<br>142Command is "+command);
boolean flag=true;
C.returnConnection(conp);
/*
 for(int i=0; i<counter; i++)
	{
// out.print("<br>priviledge_level[i] "+priviledge_level[i]);
// out.print("user_level= "+user_level);

 if(Integer.parseInt(priviledge_level[i]) < Integer.parseInt(user_level))
		{
out.print("<body bgcolor=ffffee background=../Buttons/BGCOLOR.JPG >");
out.print("<center><font color=red><h2>Can't Give the level Higher than yourself</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'></center>");
flag=false;
	 break;}

 }//for*/
if(flag)
	{
conp=C.getConnection();

 int final_flag=0;
String u_id="";
for(int i=0; i<counter; i++)
{
 query = " Select * from Master_User where  company_id="+company_id+" and user_Name=?";	
 pstmt_p  = conp.prepareStatement(query);
	pstmt_p.setString(1,user_name[i]);
	rs_g = pstmt_p.executeQuery();
	int company_exist =0;
	while(rs_g.next())
		{
		u_id=rs_g.getString("user_id");
		//out.print("<br>u_id="+u_id);
		//out.print("&nbsp;&nbsp;user_id="+userid[i]);
		company_exist++;
		}//while
		pstmt_p.close();
	//		C.returnConnection(conp);

if((u_id.equals(userid[i]))||(company_exist==0))
	{	final_flag=1;
}
else{
C.returnConnection(conp);
	out.print("<body bgcolor=ffffee background='../Buttons/BGCOLOR.JPG'>" );
	out.print("<center><font class='star1'>User "+user_name[i]+" alredy exists for the selected Company</font></center><br>" );
	out.print("<center><input type=button name=command value=Back class='Button1' onclick='history.go(-1)'></center>" );
final_flag=0;
break;
	}
}//for

if(final_flag>0)
{
//	conp=C.getConnection();

for(int i=0; i<counter; i++)
{

query = " Update Master_User set User_Name=?, User_Password=?, Priviledge_Level=?, department_id=?,  Modified_By=?, Modified_On='"+D+"', Modified_MachineName=?, Active=? where User_Id=? ";

pstmt_p = conp.prepareStatement(query);
//pstmt_p.setString (1,company_id);
pstmt_p.setString(1,user_name[i]);
pstmt_p.setString (2,user_password[i]);	
pstmt_p.setString (3,priviledge_level[i]);	
pstmt_p.setString (4,department_id[i]);	
pstmt_p.setString (5, user_id);
pstmt_p.setString (6, machine_name);
pstmt_p.setBoolean(7,active[i]);
pstmt_p.setString (8,""+ userid[i]);	

//out.print("<br> 8machine_name"+machine_name);	
//out.println("Before Update User Query <br>"+query);
int a = pstmt_p.executeUpdate();
pstmt_p.close();
}//for
C.returnConnection(conp);

response.sendRedirect("EditUser.jsp?command=edit&message=User successfully Updated");
}
	}//flag
//	C.returnConnection(conp);
}catch(Exception Samyak45){ 
out.println("<br><font color=red><h2> FileName : UpdateUser.jsp <br>Bug No Samyak45 :"+ Samyak45 +"</h2></font><input type=button name=command value='BACK' class='Button1' onClick='history.go(-1)'>");
}
}//if Update
%>








