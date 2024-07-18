<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

try{
int current_id=0; 
int total_rows=0;


//String query="Select * from Receive where Receive_quantity=0 and Company_id=1 and Receive_fromid not like 1 and Receive_sell=0 and Purchase=1 and Active=1 and Return=0";

String query="Select * from Receive  where  Purchase=1 and Receive_sell=0 and Active=1 and Return=0 and company_id=1 order by Receive_date ,Receive_no";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter ="+counter);

String receive_id[]= new String[counter];
//double receive_quantity[]= new double[counter];
double receive_total[]= new double[counter];
double ex_rate[]= new double[counter];
double local_total[]= new double[counter];
double dollar_total[]= new double[counter];
double tax[]= new double[counter];
double dis[]= new double[counter];
int receive_currency[]= new int[counter];

int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
receive_id[i]=rs_g.getString("Receive_ID");
receive_currency[i]=rs_g.getInt("Receive_CurrencyId");
ex_rate[i]=rs_g.getDouble("Exchange_rate");
tax[i]=rs_g.getDouble("Tax");
dis[i]=rs_g.getDouble("Discount");

//out.println("<br>counter is="+counter+" receive_id[i] "+receive_id[i]);
i=i+1;
}//while
//out.println("<br>761245counter"+counter);

for( i=0;i<counter;i++)
{
query="Select * from Receive_Transaction where Receive_Id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]); 
rs_g = pstmt_g.executeQuery();
double tot=0;
while(rs_g.next()) 	
{
double qty=rs_g.getDouble("Quantity");
double temp=rs_g.getDouble("Receive_Price");
 tot +=qty *temp;
}	
pstmt_g.close();
//out.print("<br>tot="+tot);
receive_total[i]=tot-(tot*dis[i]/100);
receive_total[i]=receive_total[i]+(receive_total[i]*tax[i]/100);
//out.print("<br>receive_total="+receive_total[i]);
//out.print("<br>ex_rate="+ex_rate[i]);
//out.print("<br>receive_currency="+receive_currency[i]);

if(0==receive_currency[i])
	{
dollar_total[i]=receive_total[i];
local_total[i]=receive_total[i]*ex_rate[i];
	}
else{
	local_total[i]=receive_total[i];
	dollar_total[i]=receive_total[i]/ex_rate[i];
}
//out.print("<br>local_total="+local_total[i]);
//out.print("<br>dollar_total="+dollar_total[i]);

}//for
//out.println("<br>103");
boolean flag_currency=true;
//out.print("<table> <tr><th>id<th>r-tot<th>local<th>dollar");
for( i=0;i<counter;i++)
{
//out.print("<tr>");
//out.print("<td>"+receive_id[i]);
//out.print("<td>"+receive_total[i]);
//out.print("<td>"+local_total[i]);
//out.print("<td>"+dollar_total[i]);
}
//out.println("<br>108");

for( i=0;i<counter;i++)
{
query="Update  Receive  set Receive_Total=?, Local_Total=?, Dollar_Total=? where Receive_ID=? ";
//out.print("<br> i"+i+" query" +query+"receive_id[i]"+receive_id[i]);
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+receive_total[i]); 
pstmt_g.setString(2,""+local_total[i]); 
pstmt_g.setString(3,""+dollar_total[i]); 
pstmt_g.setString(4,""+receive_id[i]); 
int a308 = pstmt_g.executeUpdate();
//out.println("<br>a308"+a308);
pstmt_g.close();

query="Update Voucher set Voucher_total=?, Local_Total=?, Dollar_Total=? where voucher_type=1 and voucher_no=?";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+receive_total[i]); 
pstmt_g.setString(2,""+local_total[i]); 
pstmt_g.setString(3,""+dollar_total[i]); 
pstmt_g.setString(4,""+receive_id[i]); 
int a130 = pstmt_g.executeUpdate();
//out.println("<br>a130"+a130);
pstmt_g.close();

}//for

out.println("<br>Samyak System Run 100% successfull");
%>


<%

C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











