<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
//Use it only before yearend
try{
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
if(command.equals("Nippon05")){


// Code for connection start here
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

try	{
	 cong=C.getConnection();
	 conp=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	getCgtConfirmNoTrack.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here
int count=0;
String query="";
	
query="Select count(*) as counter from  Receive as R, Receive_Transaction as RT where  R.Purchase=0 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id";

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
	{
		count=rs_g.getInt("counter");
	}
pstmt_g.close();
out.print("<br>count="+count);


String R_Id[] = new String[count];
String RT_Id[] = new String[count];
String Lot_Id[] = new String[count];
String Receive_FromId[] = new String[count];
double qty[] = new double[count];
double available_qty[] = new double[count];
double return_qty[] = new double[count];
double sold_qty[] = new double[count];

query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=0 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id";

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int c=0;
while(rs_g.next())
	{
		R_Id[c] = rs_g.getString("Receive_Id");
		RT_Id[c] = rs_g.getString("ReceiveTransaction_Id");
		Lot_Id[c] = rs_g.getString("Lot_Id");
		Receive_FromId[c] = rs_g.getString("Receive_FromId");
		qty[c] = rs_g.getDouble("Quantity");
		available_qty[c] = rs_g.getDouble("Available_Quantity");
		return_qty[c] = rs_g.getDouble("Return_Quantity");
		sold_qty[c] = qty[c]-return_qty[c]-available_qty[c];
		c++;
	}
pstmt_g.close();
//out.print("<br><b>List of Consignment Confirm</b><br>");
out.print("<br><b>List of Consignment may not be Confirmed</b><br>");
double sum=0;
for(int i=0; i<count; i++)
	{
		if(sold_qty[i] != 0)
		{
			query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=1 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+Lot_Id[i]+" and RT.Quantity="+sold_qty[i]+" and Receive_FromId="+Receive_FromId[i]+" and RT.Consignment_ReceiveId=0 order by R.Receive_Id, RT.ReceiveTransaction_Id";

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next())
			{
				out.print("<br>Receive_Id="+rs_g.getString("Receive_Id"));
				out.print("&nbsp;&nbsp;&nbsp;ReceiveTransaction_Id="+rs_g.getString("ReceiveTransaction_Id"));
				out.print("&nbsp;&nbsp;&nbsp;Lot_Id="+rs_g.getString("Lot_Id"));
			
				double tempQuantity = rs_g.getDouble("Quantity");
				sum+=tempQuantity;

				out.print("&nbsp;&nbsp;&nbsp;Quantity="+tempQuantity);
				
			}
			pstmt_g.close();
		}
	}
	

out.print("<br>Sum of Quantity="+sum);
out.print("<br><br>End of list");



C.returnConnection(cong);
C.returnConnection(conp);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : getCgtConfirmNoTrack.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
