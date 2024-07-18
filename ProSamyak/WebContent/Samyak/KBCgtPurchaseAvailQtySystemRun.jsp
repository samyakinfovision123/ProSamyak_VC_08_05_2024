<!-- 
For Run the System Run:-

append to the url in the browser 
Samyak/KBCgtPurchaseAvailQtySystemRun.jsp?command=SamyakKB
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");

if(command.equals("SamyakKB")){
	
	
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
    out.println("<font color=red> FileName : KBCgtPurchaseAvailQtySystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
}


//get all the RT rows which corresponds to the Consignment Purchases in the System.
String query = "SELECT COUNT(*) as rtCount FROM Receive_Transaction RT, Receive R WHERE RT.Receive_Id=R.Receive_Id AND R.Purchase=0 AND R.Receive_Sell=1 AND R.R_Return=0 AND R.Opening_Stock=0 AND R.StockTransfer_Type=0 AND R.Active=1 and RT.Active=1";
int rtCount = 0;

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
{
	rtCount = rs_g.getInt("rtCount");
}
pstmt_g.close();		

String rtId[] = new String[rtCount];
double qty[] = new double[rtCount];
double oldRejectQty[] = new double[rtCount];

query = "SELECT ReceiveTransaction_Id, Quantity, Rejection_Quantity FROM Receive_Transaction RT, Receive R WHERE RT.Receive_Id=R.Receive_Id AND R.Purchase=0 AND R.Receive_Sell=1 AND R.R_Return=0 AND R.Opening_Stock=0 AND R.StockTransfer_Type=0 AND R.Active=1 and RT.Active=1";

int c=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next())
{
	rtId[c] = rs_g.getString("ReceiveTransaction_Id");
	qty[c] = rs_g.getDouble("Quantity");
	oldRejectQty[c] = rs_g.getDouble("Rejection_Quantity");
	c++;
}
pstmt_g.close();		


//out.print("<table border=1>");
for(int i=0; i<rtCount; i++)
{
	//get all the consignment confirmed against each RT row as the return rows are already punched while entering the Cgt In entry and then update the Available Quantity accordingly

	String sumquery = "SELECT Quantity AS purchaseSum,  RT.ReceiveTransaction_Id, Rejection_Quantity FROM Receive_Transaction RT, Receive R WHERE RT.Receive_Id=R.Receive_Id AND R.Purchase=1 AND R.Receive_Sell=1 AND R.R_Return=0 AND R.Opening_Stock=0 AND R.StockTransfer_Type=0 AND RT.Consignment_ReceiveId="+rtId[i]+" AND R.Active=1 and RT.Active=1";

	double purchaseSum=0;
	double newRejectQty=0;
	String confirmRT_Id = "";
	pstmt_g = cong.prepareStatement(sumquery);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next())
	{
		purchaseSum = rs_g.getDouble("purchaseSum");
		confirmRT_Id = rs_g.getString("ReceiveTransaction_Id");
		newRejectQty = rs_g.getDouble("Rejection_Quantity");
	}
	pstmt_g.close();		

	double ghatSum=0;
	if(! "".equals(confirmRT_Id))
	{
		//Also get the ghat entry for the lot
		sumquery = "SELECT SUM(Quantity) AS ghatSum FROM Receive_Transaction RT, Receive R WHERE RT.Receive_Id=R.Receive_Id AND R.Purchase=1 AND R.Receive_Sell=1 AND R.R_Return=0 AND R.Opening_Stock=0 AND R.StockTransfer_Type=7 AND RT.Consignment_ReceiveId="+confirmRT_Id+" AND R.Active=1 and RT.Active=1";


		pstmt_g = cong.prepareStatement(sumquery);
		rs_g = pstmt_g.executeQuery();
		while(rs_g.next())
		{
			ghatSum = rs_g.getDouble("ghatSum");
		}
		pstmt_g.close();	
	}
	double availQty = qty[i] + oldRejectQty[i] - purchaseSum - ghatSum - newRejectQty;
	
	//out.print("<tr>");
	//out.print("<td>"+rtId[i]);
	//out.print("</td>");
	//out.print("<td>"+qty[i]);
	//out.print("</td>");
	//out.print("<td>"+availQty);
	//out.print("</td>");
	//out.print("</tr>");
	//Update the respective RT row with the available quantity
	String updateAvailQtyQuery = "UPDATE Receive_Transaction SET Available_Quantity=? WHERE ReceiveTransaction_Id="+rtId[i]+" ";

	pstmt_p = conp.prepareStatement(updateAvailQtyQuery);
	pstmt_p.setDouble(1, availQty);
	int a90 = pstmt_p.executeUpdate();
	pstmt_p.close();		


}
//out.print("</table>");
out.print("<br>System Run Completed");

C.returnConnection(conp);
C.returnConnection(cong);

}

}catch(Exception e)
  {
	out.print("<br>137  The error in file KBCgtPurchaseAvailQtySystemRun.jsp"+e);
  }
%>









			
			
			
			