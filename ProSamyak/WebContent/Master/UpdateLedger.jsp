<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String today_string= format.format(D);

String command= request.getParameter("command");


	ResultSet rs_g = null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	

String errline="20";



if("UPDATE".equals(command))
{
try{
	 	 conp=C.getConnection();
String category_name= request.getParameter("category_name");
int counter= Integer.parseInt(request.getParameter("counter"));
//out.print("<br>counter=" +counter);

String ledger_id[]=new String[counter]; 
String Ledger_Currency[]=new String[counter];

String ledger_name[]=new String[counter]; 
String description[]=new String[counter]; 
String type[]=new String[counter]; 
double opening_localbalance[]=new double[counter]; 
String creditdebit[]=new String[counter]; 
double exchange_rate[]=new double[counter]; 
boolean active[]=new boolean[counter];
double opening_dollarbalance[]=new double[counter]; 
double value=0;
for(int i=0; i<counter; i++)
	{
	errline="41";
ledger_id[i]=request.getParameter("ledger_id"+i);
ledger_name[i]= request.getParameter("ledger_name"+i);
type[i]= request.getParameter("type"+i);
description[i]= request.getParameter("description"+i);
opening_localbalance[i]=Double.parseDouble(request.getParameter("opening_localbalance"+i));
//out.print("<br>52 opening_localbalance[i]="+opening_localbalance[i]);
creditdebit[i]= request.getParameter("creditdebit"+i);
//out.print("<br>54 creditdebit[i]="+creditdebit[i]);
exchange_rate[i]=Double.parseDouble(request.getParameter("exchange_rate"+i));
opening_dollarbalance[i]=Double.parseDouble(request.getParameter("opening_dollarbalance"+i));
//out.print("<br> opening_dollarbalance[i]="+opening_dollarbalance[i]);

if ("Debit".equals(creditdebit[i]))
		{
opening_localbalance[i]=opening_localbalance[i];
out.print("62 Debit opening_localbalance[i]="+opening_localbalance[i]);
		}
	else
		{
		opening_localbalance[i]=opening_localbalance[i]*-1;
out.print("67 Credit opening_localbalance[i]="+opening_localbalance[i]);
		}
if(opening_localbalance[i]==0)
{
	opening_dollarbalance[i]=0;	
}
else
{
	opening_dollarbalance[i]=opening_localbalance[i]/exchange_rate[i];
}
//out.print("<br>75 opening_localbalance[i]="+opening_localbalance[i]);
errline="49";
String act=
request.getParameter("active"+i);
Ledger_Currency[i]=request.getParameter("Ledger_Currency"+i);
//out.print("<br>34 Ledger_Currency[i]="+Ledger_Currency[i]);
//out.print(act);
active[i]=false;
if("yes".equals(act)){active[i]=true;}
	}//for

for (int i=0 ; i<counter; i++)
	{
String query="Update  Ledger set  Ledger_Name=?, Ledger_Type=?,Description=?,Opening_Balance=?, Opening_LocalBalance=?, Opening_DollarBalance=?, Exchange_Rate=?, Active=?, Modified_By=?, Modified_On=?, Modified_MachineName=? where Ledger_Id=?";
//out.print("<BR>" +query);

errline="68";
pstmt_p = conp.prepareStatement(query);
//out.print("<BR>70" +query);
pstmt_p.setString (1, ledger_name[i]);
//out.print("<BR>ledger_name=" +ledger_name[i]);
pstmt_p.setString (2, type[i]);
//out.print("<BR>type=" +type[i]);
pstmt_p.setString (3, description[i]);
//out.print("<BR>description=" +description[i]);
errline="74";

if ("Local".equals(Ledger_Currency))
		{
pstmt_p.setDouble (4, opening_localbalance[i]);
		}
else {
pstmt_p.setDouble (4, opening_dollarbalance[i]);
}

pstmt_p.setDouble (5, opening_localbalance[i]);
//out.print("<BR>opening_localbalance=" +opening_localbalance[i]);
pstmt_p.setDouble (6, opening_dollarbalance[i]);
//out.print("<BR>opening_dollarbalance=" +opening_dollarbalance[i]);
errline="78";
pstmt_p.setDouble (7, exchange_rate[i]);
//out.print("<BR>exchange_rate=" +exchange_rate[i]);
pstmt_p.setBoolean (8, active[i]);
//out.print("<BR>active=" +active[i]);
errline="81";
pstmt_p.setString (9, user_id);
//out.print("<BR>user_id=" +user_id);
//out.print("<br >6 "+user_id);
pstmt_p.setString (10,""+D);//			out.print("<br >7"+D);
pstmt_p.setString (11, machine_name);	
//out.print("<BR>machine_name=" +machine_name);
//out.print("<br >8"+machine_name);
pstmt_p.setString (12, ledger_id[i]);
//out.print("<BR>ledger_id=" +ledger_id[i]);
//out.print("<br >1 "+ledger_id[i]);
errline="86";
int a = pstmt_p.executeUpdate();
//out.print("<br >a "+a);
//System.out.println(" <BR>Updated Successfully: " +a);
//out.println("<BR>87 Updated Successfully: " +a);
pstmt_p.close();
errline="90";
}//for
//out.println("<br> Updated Successfully" );
C.returnConnection(conp);
errline="96";
response.sendRedirect("EditLedger.jsp?command=edit&message=Data For "+category_name+" Successfully Updated.");
}
catch(SQLException Samyak154)
{
//out.print("<h3><font color=red>Currency "+currency_name[i]+" Already Exists<BR> ");
//	out.print("<tr align=center><td><input type=button name=command value='BACK' onClick='history.go(-1)'>");
out.println("FileName : UpdateGroup.jsp Bug no e154="+Samyak154+"errline="+errline);
}

}

%>








