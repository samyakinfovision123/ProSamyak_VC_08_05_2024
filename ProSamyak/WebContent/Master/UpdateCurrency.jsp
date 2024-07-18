<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String today_string= format.format(D); 

//out.print("<br> today_string= "+today_string+"<br>D="+D);

String command= request.getParameter("command");


	ResultSet rs_g = null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
/*	try	{
	 	 conp=C.getConnection();
	}catch(Exception Samyak22){ 
	out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No Samyak22 :"+ Samyak22 +"</font>");}*/




if("Update".equals(command))
{
int counter = Integer.parseInt(request.getParameter("counter"));
String date_array[] = new String[counter];
String ex_array[] = new String[counter];
String ex_id[] = new String[counter];
try	{
	 	 conp=C.getConnection();
	}catch(Exception Samyak22){ 
	out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No Samyak22 :"+ Samyak22 +"</font>");}

String exchangerate_id= ""+L.get_master_id(conp,"Master_ExchangeRate");

for(int i=0,j=0; i < counter;i++)
	{
	try{
//		conp=C.getConnection();
	date_array[i]  =  request.getParameter("date"+i); 
	ex_array[i]  =  request.getParameter("rate"+i); 
	ex_id[i]  =  request.getParameter("ex_id"+i); 

	String status = request.getParameter("query"+i);
//	out.print("<br> Date "+date_array[i] +" rate"+ex_array[i] +" status "+status);
	
	
	String currency_id = I.getLocalCurrency(conp,company_id);

	if("insert".equals(status))
		{
		String query="Insert into Master_ExchangeRate(ExchangeRate_Id,Currency_Id, Exchange_Date,Exchange_Rate,Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values (?,?,'"+format.getDate(date_array[i])+"',?,  ?,'"+format.getDate(today_string)+"',?,?)";
		//columns (fields) 7

		pstmt_p = conp.prepareStatement(query);
//		out.print("<BR>57" +query);
		pstmt_p.clearParameters();
		pstmt_p.setString (1,""+(Integer.parseInt(exchangerate_id)+j));	
//		out.print("<br >1 "+exchangerate_id);
		pstmt_p.setString (2, currency_id);
//		out.print("<br >2 "+currency_id);
		pstmt_p.setString (3, ex_array[i]);	
		pstmt_p.setString (4, user_id);
//		out.print("<br>4 "+user_id);
		pstmt_p.setString (5, machine_name);			
//		out.print("<br >8"+machine_name);
		pstmt_p.setString(6,yearend_id);
		int a66 = pstmt_p.executeUpdate();
		//System.out.println(" <BR>Master Exchange rate Updated Successfully: " +a66);
//		out.println("<BR><font color=red>Master Exchange rate Updated Successfully: </font>" +a66);
		pstmt_p.close();
		j++;

		}//if insert
		else 
		{
		String query="Update  Master_ExchangeRate set  Exchange_Rate=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? where Exchangerate_Id=?";
//		out.print("<BR>" +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString (1, ex_array[i]);	
//		out.print("<br>1 "+ex_array[i]);
		pstmt_p.setString (2, user_id);
//		out.print("<br>2 "+user_id);
		pstmt_p.setString (3,machine_name);
//		out.print("<br>3"+machine_name);
		pstmt_p.setString(4, ex_id[i]);	
//		out.print("<br>4"+ex_id[i]);
		int a89 = pstmt_p.executeUpdate();
//		out.println("<BR>Master ExchangeRate Successfully Update");
		pstmt_p.close();
			C.returnConnection(conp);

		response.sendRedirect("EditMasters.jsp?message=Exchange Rate Updated Successfully.");
		}
	
	}catch(Exception e94){out.print("e94 "+e94);}

	}
		//	C.returnConnection(conp);
}//if Update

//out.println("Today's Date is "+D);
//  Start of Code to take today_date in dd/mm/yyyy format     'i' stands for int & 's' for String at start of variable name. Samyak Software_080903



out.print("<BR>command=" +command);

if("SUBMIT".equals(command))
{
String currency_name= request.getParameter("currency_name");
String CompanyParty_Id= request.getParameter("CompanyParty_Id");

if("0".equals(company_id))
{
company_id=CompanyParty_Id;
}

try{
	conp=C.getConnection();
String currency_symbol= request.getParameter("currency_symbol");
String base_exchangerate= request.getParameter("base_exchangerate");
String decimal_places= request.getParameter("decimal_places");
String local= request.getParameter("local");
//out.print("<BR>local=" +local);
String str="";
boolean local_currency=false;
String flag ="true";
if("yes".equals(local))
{
	str="checked";
	local_currency=true;
	String query="Select * from Master_Currency where Local_Currency=1 and Company_id="+company_id+"";
	pstmt_p  = conp.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	int i=0;
	while(rs_g.next())
		{
		i++;
		}//while
		pstmt_p.close();

//		out.print("<BR>i=" +i);
if(i> 0)
	{
	flag="false";
	}//if 
else{local_currency=true; out.print("<BR>" +local_currency);}

}

%>
<HTML>
<HEAD>
<TITLE>Jainam Technologies</TITLE>
</HEAD>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<BODY bgcolor=#ffFFee>
<%
if("false".equals(flag))
	{
	C.returnConnection(conp);
	out.print("<h3><font color=red>One Local Currency Already Exists<BR> ");
	out.print("<tr align=center><td><input type=button  class='Button1'name=command value='BACK' onClick='history.go(-1)'>");
	}
else{	
String currency_id= ""+L.get_master_id(conp,"Master_Currency");
//out.print("<BR>currency_id="+currency_id);
String query="Insert into Master_Currency (Currency_Id, Currency_Name, Currency_Symbol, Base_ExchangeRate, Local_Currency, Company_id, Decimal_Places,Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values (?,?,?,? ,?,?,?,?,'"+format.getDate(today_string)+"',?,?)";
//columns (fields) 10

//out.print("<BR>" +query);
//out.print("<br >5ppp "+local_currency);

pstmt_p = conp.prepareStatement(query);
//out.print("<BR>80" +query);
pstmt_p.setString (1, currency_id);	
//out.print("<br >1 "+currency_id);
pstmt_p.setString (2, currency_name);
//out.print("<br >2 "+currency_name);
pstmt_p.setString (3, currency_symbol);			//out.print("<br >3 "+currency_symbol);
//out.print("<br >4 "+base_exchangerate);
pstmt_p.setString (4, base_exchangerate);	
pstmt_p.setBoolean (5, local_currency);			//out.print("<br >5 "+local_currency);
pstmt_p.setString (6, company_id);			//out.print("<br >6 "+user_id);
pstmt_p.setString (7, ""+decimal_places);			//out.print("<br >6 "+user_id);
pstmt_p.setString (8, user_id);			//out.print("<br >6 "+user_id);
//pstmt_p.setDate (9, D);//			out.print("<br >7"+D);
pstmt_p.setString (9, machine_name);			//out.print("<br >8"+machine_name);
pstmt_p.setString(10,yearend_id);
int a = pstmt_p.executeUpdate();
//System.out.println(" <BR>Updated Successfully: " +a);
//out.println(" Updated Successfully: " +a);
pstmt_p.close();
C.returnConnection(conp);
response.sendRedirect("NewCurrency.jsp?message=Currency <font color=blue>"+currency_name+"</font> successfully Added.");
}//else
}
catch(SQLException Samyak93)
{
	C.returnConnection(conp);

out.print("<h3><font color=red>Currency "+currency_name+" Already Exists<BR> ");
	out.print("<tr align=center><td><input type=button  class='Button1' name=command value='BACK' onClick='history.go(-1)'>");
	out.println("FileName:UpdateCurrency.jsp Bug no e93="+Samyak93);
}
catch(Exception Samyak144){ 
	out.println("<font color=red> FileName : GL_UpdateCurrency.jsp <br>Bug No Samyak144 :"+ Samyak144 +"</font>");}
}//if submit

if("Update Currency".equals(command))
{
try	{
	 	 conp=C.getConnection();
	}catch(Exception Samyak22){ 
	out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No Samyak22 :"+ Samyak22 +"</font>");}	
try{

int counter= Integer.parseInt(request.getParameter("counter"));
out.print("<br>counter=" +counter);
int count =Integer.parseInt(request.getParameter("count"));
out.print("<br>count=" +count);
String local="";
if(count> 0)
	{local="";}
else{
local=request.getParameter("local");}
out.print("<br>local="+local);
String currency_id[]=new String[counter]; 
String currency_name[]=new String[counter]; 
String currency_symbol[]=new String[counter]; 
String base_exchangerate[]=new String[counter]; 
boolean flag[]=new boolean[counter];
boolean active[]=new boolean[counter];
for(int i=0; i<counter; i++)
	{
currency_id[i]=request.getParameter("currency_id"+i);
currency_name[i]= request.getParameter("currency_name"+i);
currency_symbol[i]= request.getParameter("currency_symbol"+i);
base_exchangerate[i]= request.getParameter("base_exchangerate"+i);
String act=
request.getParameter("active"+i);
//out.print(act);
active[i]=false;
if("yes".equals(act)){active[i]=true;}
	}//for
for(int i=0; i < counter; i++)
	{
flag[i]=false;
if(local.equals(currency_id[i]))
{flag[i]=true;}

	}//for

for (int i=0 ; i<counter; i++)
	{

String query="Update  Master_Currency set  Currency_Name=?, Currency_Symbol=?, Base_ExchangeRate=?, Local_Currency=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where Currency_Id=?";
out.print("<BR>" +query);


pstmt_p = conp.prepareStatement(query);
//out.print("<BR>80" +query);
pstmt_p.setString (1, currency_name[i]);
//out.print("<br >2 "+currency_name);
pstmt_p.setString (2, currency_symbol[i]);			//out.print("<br >3 "+currency_symbol);
out.print("<br >4 "+base_exchangerate[i]);
pstmt_p.setString (3, base_exchangerate[i]);	
pstmt_p.setBoolean (4, flag[i]);			//out.print("<br >5 "+local_currency);
pstmt_p.setString (5, user_id);			//out.print("<br >6 "+user_id);
pstmt_p.setString(6,""+D);//			out.print("<br >7"+D);
pstmt_p.setString (7, machine_name);			//out.print("<br >8"+machine_name);
pstmt_p.setString (8, currency_id[i]);	
out.print("<br >1 "+currency_id[i]);
int a = pstmt_p.executeUpdate();
//System.out.println(" <BR>Updated Successfully: " +a);
out.println(" Updated Successfully: " +a);
pstmt_p.close();

}//for
C.returnConnection(conp);
response.sendRedirect("EditMasters.jsp?message= Currency data successfully updated."); 
}
catch(SQLException Samyak154)
{
//out.print("<h3><font color=red>Currency "+currency_name[i]+" Already Exists<BR> ");
//	out.print("<tr align=center><td><input type=button name=command value='BACK' onClick='history.go(-1)'>");
C.returnConnection(conp);
System.out.println("FileName : GL_UpdateCurrency.jsp Bug no e154="+Samyak154);
}
catch(Exception Samyak164){ 
out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No e164 :"+ Samyak164 +"</font>");}

}//if Update Currency


if("Update Local Currency".equals(command))
{
try{
out.println("Inside Update Local Currecy ");

String currency_id=""; 
String base_exchangerate="";
currency_id=request.getParameter("currency_id");
base_exchangerate=request.getParameter("base_exchangerate");

String UpdateQuery="Update  Master_Currency set  Base_ExchangeRate=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where Currency_Id=?";
out.print("<BR>" +UpdateQuery);
	 	 conp=C.getConnection();
pstmt_p = conp.prepareStatement(UpdateQuery);
pstmt_p.setString (1, base_exchangerate);	
out.print("<br>1 "+base_exchangerate);
pstmt_p.setString (2, user_id);
out.print("<br>2 "+user_id);
pstmt_p.setString(3,""+D);
out.print("<br>3"+D);
pstmt_p.setString (4,machine_name);
out.print("<br>4"+machine_name);
pstmt_p.setString(5, currency_id);	
out.print("<br>5"+currency_id);

int a = pstmt_p.executeUpdate();
out.println("232 Local Currency Updated Successfully: "+a);

String updateExTable="Select * from Master_ExchangeRate where Exchange_Date=? and  Currency_Id="+currency_id ;
//out.println("<br>"+query);
	pstmt_p  = conp.prepareStatement(updateExTable);
	pstmt_p.setString(1,""+D);
	rs_g = pstmt_p.executeQuery();
	String exchangerate_id="";
	int i=0;
	while(rs_g.next())
		{
		i++;
		exchangerate_id=rs_g.getString("Exchangerate_Id");
		}
UpdateQuery="Update  Master_ExchangeRate set  Exchange_Rate=?, Modified_By=?, Modified_On='"+format.getDate(today_string)+"', Modified_MachineName=? where Exchangerate_Id=?";
out.print("<BR>" +UpdateQuery);
pstmt_p = conp.prepareStatement(UpdateQuery);
pstmt_p.setString (1, base_exchangerate);	
out.print("<br>1 "+base_exchangerate);
pstmt_p.setString (2, user_id);
out.print("<br>2 "+user_id);
pstmt_p.setString (3,machine_name);
out.print("<br>3"+machine_name);
pstmt_p.setString(4, exchangerate_id);	
out.print("<br>4"+exchangerate_id);
out.print("<br>4"+exchangerate_id);
int a261 = pstmt_p.executeUpdate();
out.println("<BR>Master ExchangeRate Successfully Update");
pstmt_p.close();
response.sendRedirect("EditMasters.jsp?message=Local Currency Exchange Rate <font color=blue>"+base_exchangerate+"</font> successfully updated.");
C.returnConnection(conp);

}
catch(SQLException Samyak224)
{
System.out.println("FileName : UpdateLocalCurrency.jsp Bug no e224="+Samyak224);
}
catch(Exception Samyak228){ 
out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No Samyak228 :"+ Samyak228 +"</font>");}
}//if Update Local Currency



if("Today Save".equals(command))
{
try{
out.println("Inside Update Today Currency");
String currency_id=""; 
String base_exchangerate="";
currency_id=request.getParameter("currency_id");
base_exchangerate=request.getParameter("base_exchangerate");

String querycheck="Select * from Master_ExchangeRate where Exchange_Date=?	and  Currency_Id=?";

 conp=C.getConnection(); 
pstmt_p = conp.prepareStatement(querycheck);
pstmt_p.setString(1,""+D);
pstmt_p.setString(2,""+currency_id);	
rs_g = pstmt_p.executeQuery();
out.println("<br>123"+querycheck);


String today_exrate="";
int i=0;
while(rs_g.next())
		{
		i++;
		today_exrate=rs_g.getString("Exchange_Rate");
		}
		//while
		pstmt_p.close();
out.println("<br> <font color=red>i is =</font>"+i);	
if (i>0)
{	
response.sendRedirect("../Home/Homepage.jsp");
}
else
	{
	
String UpdateQuery="Update  Master_Currency set  Base_ExchangeRate=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where Currency_Id=?";
out.print("<BR>" +UpdateQuery);

pstmt_p = conp.prepareStatement(UpdateQuery);
pstmt_p.setString (1, base_exchangerate);	
out.print("<br>1 "+base_exchangerate);
pstmt_p.setString (2, user_id);
out.print("<br>2 "+user_id);
pstmt_p.setString(3,""+D);
out.print("<br>3"+D);
pstmt_p.setString (4,machine_name);
out.print("<br>4"+machine_name);
pstmt_p.setString(5, currency_id);	
out.print("<br>5"+currency_id);

int a = pstmt_p.executeUpdate();
out.println("Local Currency Updated Successfully:"+a);
pstmt_p.close();

String exchangerate_id= ""+L.get_master_id(conp,"Master_ExchangeRate");

String query="Insert into Master_ExchangeRate(ExchangeRate_Id,Currency_Id, Exchange_Date,Exchange_Rate,Modified_By, Modified_On, Modified_MachineName,YearEnd_Id) values (?,?,'"+D+"',?,  ?,'"+D+"',?,?)";
//columns (fields) 7

pstmt_p = conp.prepareStatement(query);
out.print("<BR>80" +query);
pstmt_p.setString (1, exchangerate_id);	
out.print("<br >1 "+exchangerate_id);
pstmt_p.setString (2, currency_id);
out.print("<br >2 "+currency_id);
pstmt_p.setString (3, base_exchangerate);	
pstmt_p.setString (4, user_id);
out.print("<br>4 "+user_id);
pstmt_p.setString (5, machine_name);			
out.print("<br >8"+machine_name);
pstmt_p.setString(6,yearend_id);
int a290 = pstmt_p.executeUpdate();
out.print("<br >a290 Updateded 888:"+a290);
//System.out.println(" <BR>Master Exchange rate Updated Successfully: " +a);
out.println("<BR><font color=red>Master Exchange rate Updated Successfully: </font>" +a290);
pstmt_p.close();
response.sendRedirect("../Home/Homepage.jsp");

//response.sendRedirect("../Samyak/LocationStock.jsp?command=Stock");
}//else
//response.sendRedirect("Editmasters.jsp?message=Local Currency Exchange Rate <font color=blue>"+base_exchangerate+"</font> successfully updated.");
C.returnConnection(conp);

}//try
catch(Exception Samyak228){ 
out.println("<font color=red> FileName : UpdateCurrency.jsp <br>Bug No Samyak228 :"+ Samyak228 +"</font>");}
}//TodaySave

%>








