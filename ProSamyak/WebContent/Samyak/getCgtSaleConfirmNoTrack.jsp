<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<html>
<head></head>
<body>
<table border=1>
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


int newcount=0;
for(int i=0; i<count; i++)
	{
		if(sold_qty[i] != 0)
		{
			query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=1 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+Lot_Id[i]+" and RT.Quantity="+sold_qty[i]+" and Receive_FromId="+Receive_FromId[i]+" and RT.Consignment_ReceiveId="+RT_Id[i]+" order by R.Receive_Id, RT.ReceiveTransaction_Id";

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
			
			if(!rs_g.next())
			{ newcount++;}
			pstmt_g.close();
		}
	}


String newR_Id[] = new String[newcount];
String newRT_Id[] = new String[newcount];
String newLot_Id[] = new String[newcount];
String newReceive_FromId[] = new String[newcount];
double newsold_qty[] = new double[newcount];

c=0;
for(int i=0; i<count; i++)
	{
		if(sold_qty[i] != 0)
		{
			query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=1 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+Lot_Id[i]+" and RT.Quantity="+sold_qty[i]+" and Receive_FromId="+Receive_FromId[i]+" and RT.Consignment_ReceiveId="+RT_Id[i]+" order by R.Receive_Id, RT.ReceiveTransaction_Id";

			pstmt_g = cong.prepareStatement(query);
			rs_g = pstmt_g.executeQuery();
				
			if(!rs_g.next())
			{ 
				newR_Id[c] = R_Id[i];
				newRT_Id[c] = RT_Id[i];
				newLot_Id[c] = Lot_Id[i];
				newReceive_FromId[c] = Receive_FromId[i];
				newsold_qty[c]=sold_qty[i];
				c++;
			}
			pstmt_g.close();
		}
	}


int finalcount=0;
for(int i=0; i<newcount; i++)
	{
		
		query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=1 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+newLot_Id[i]+" and RT.Quantity="+newsold_qty[i]+" and Receive_FromId="+newReceive_FromId[i]+" and RT.Consignment_ReceiveId=0 order by R.Receive_Id, RT.ReceiveTransaction_Id";

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
			
		while(rs_g.next())
		{	finalcount++;	}
		pstmt_g.close();
	}


%>
<tr>
	<th>Consignment Sale ReceiveID</th>
	<th>Cgt RT_Id</th>
	<th>Sale ReceiveId</th>
	<th>Sale RT_Id</th>
	<th>LotId</th>
	<th>Quantity</th>
</tr>
<%
double sum=0;

String cgt_R_Id[] = new String[finalcount];
String cgt_RT_Id[] = new String[finalcount];
String cgt_Lot_Id[] = new String[finalcount];
String fin_R_Id[] = new String[finalcount];
String fin_RT_Id[] = new String[finalcount];
String fin_Lot_Id[] = new String[finalcount];
c=0;
for(int i=0; i<newcount; i++)
	{
		
		query="Select * from  Receive as R, Receive_Transaction as RT where  R.Purchase=1 and R.Receive_Sell=0 and R.return=0 and Company_id="+company_id+" and R.Active=1 and RT.Active=1 and R.Receive_Id=RT.Receive_Id and RT.Lot_Id="+newLot_Id[i]+" and RT.Quantity="+newsold_qty[i]+" and Receive_FromId="+newReceive_FromId[i]+" and RT.Consignment_ReceiveId=0 order by R.Receive_Id, RT.ReceiveTransaction_Id";

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
			
		while(rs_g.next())
		{
			cgt_R_Id[c] = newR_Id[i];
			cgt_RT_Id[c] = newRT_Id[i];
			cgt_Lot_Id[c] = newLot_Id[i];			
			
			out.print("<tr>");
			out.print("<td>"+newR_Id[i]+"</td>");
			out.print("<td>"+newRT_Id[i]+"</td>");

			fin_R_Id[c] = rs_g.getString("Receive_Id");
			out.print("<td>"+fin_R_Id[c]+"</td>");

			fin_RT_Id[c] = rs_g.getString("ReceiveTransaction_Id");
			out.print("<td>"+fin_RT_Id[c]+"</td>");
			
			fin_Lot_Id[c] = rs_g.getString("Lot_Id");
			out.print("<td>"+fin_Lot_Id[c]+"</td>");
			
			double tempQuantity = rs_g.getDouble("Quantity");
			sum+=tempQuantity;

			out.print("<td>"+tempQuantity+"</td>");
			out.print("</tr>");
			c++;
		}
		pstmt_g.close();
	}
out.print("<tr><td colspan=6>Sum of Quantity="+sum+"</td></tr>");

//Updating the Consignment_ReceiveId

//getting the distinct Cgt_RID, CGT_RTID, Lot_Id

String dist_cgt_RT_Id[] = new String[finalcount];
String dist_fin_RT_Id[] = new String[finalcount];
int z=0;
dist_cgt_RT_Id[0]=cgt_RT_Id[0];
dist_fin_RT_Id[0]=fin_RT_Id[0];

for(int i=1; i<finalcount; i++)
	{
		if( (cgt_R_Id[i]==cgt_R_Id[i-1]) && (cgt_RT_Id[i]==cgt_RT_Id[i-1]) && (cgt_Lot_Id[i]==cgt_Lot_Id[i-1]))	
			{continue;}
		else
		{
			dist_cgt_RT_Id[z]=cgt_RT_Id[i];
			dist_fin_RT_Id[z]=fin_RT_Id[i];
			z++;
		}

	}


int updateTotal=0;
for(int i=0; i<z; i++)
	{
		
		query = "Update Receive_Transaction Set Consignment_ReceiveId="+dist_cgt_RT_Id[i]+" where ReceiveTransaction_Id="+dist_fin_RT_Id[i];
		
		pstmt_g = cong.prepareStatement(query);
		//updateTotal += pstmt_g.executeUpdate();
			
		pstmt_g.close();
		

	}
out.print("<tr><td colspan=6>Rows Updated="+updateTotal+"</td></tr>");





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
</table>
</body>
</html>