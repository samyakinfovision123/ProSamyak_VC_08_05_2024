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
/*try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}*/

try{
int current_id=0; 
int total_rows=0;

cong=C.getConnection();
//String query="Select * from Receive where Receive_quantity=0 and Company_id=1 and Receive_fromid not like 1 and Receive_sell=0 and Purchase=1 and Active=1 and Return=0";

String query="Select * from Receive  where Receive_sell=0 and Active=1 and Return=0 and company_id=1 and Consignment_ReceiveId >0 order by Receive_date ,Receive_no";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter is="+counter);

String receive_id[]= new String[counter];
String refreceive_id[]= new String[counter];
String voucher_id[]= new String[counter];

int i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
receive_id[i]=rs_g.getString("Receive_ID");
refreceive_id[i]=rs_g.getString("Consignment_ReceiveId");

out.println("<br>counter is="+counter+" receive_id[i] "+receive_id[i]+"&nbsp;&nbsp;refreceive_id[i]="+refreceive_id[i]);
i=i+1;
}//while
for(i=0; i<counter; i++)
	{
query="Select * from Voucher where voucher_type=1 and  voucher_no=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,refreceive_id[i]);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
voucher_id[i]=rs_g.getString("Voucher_id");
out.print("<br>"+i+"=voucher_id[i]="+voucher_id[i]);
}
pstmt_g.close();
	}
for(i=0; i<counter; i++)
	{
query="Update Voucher set voucher_No=? where  Voucher_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,receive_id[i]); 
pstmt_g.setString(2,voucher_id[i]); 
int a308 = pstmt_g.executeUpdate();
out.println("<br>"+i+"=a308"+a308);
pstmt_g.close();


	}
//out.println("<br>761245counter"+counter);

pstmt_g.close();
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











