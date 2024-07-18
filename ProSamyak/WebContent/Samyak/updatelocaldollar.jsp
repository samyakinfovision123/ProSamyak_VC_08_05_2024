<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try{
String command=request.getParameter("command");
//out.print("<br>command:"+command);
int tempx=0;
if(command.equals("Samyak")){
//out.print("<br>23Hans");
String query="";
%>

<% 

// Code for connection start here


try	{
	 cong=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	Updatelocaldollar.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

// Code for connection end here

query="Select * from Receive where Active=1 and round  (InvLocalTotal/Receive_exchangeRate,2)<>round(InvDollarTotal,2)";
//company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
out.print("<form action='updatelocaldollar.jsp' method=post>");
out.print("<table border=1>");
out.print("<tr>");
out.print("<th>Sr No.</th>");
out.print("<th>Receive_Id</th>");
out.print("<th>Receive_No</th>");
out.print("<th>InvLocalTotal</th>");
out.print("<th>Receive_exchangeRate</th>");
out.print("<th>Calculated InvDollarTotal</th>");
out.print("<th>InvDollarTotal</th>");
out.print("</tr>");
int srno=0;
while(rs_g.next())

{
	String Receive_Id = rs_g.getString("Receive_Id");
	String Receive_No = rs_g.getString("Receive_No");
	String InvLocalTotal = rs_g.getString("InvLocalTotal");
	String Receive_exchangeRate = rs_g.getString("Receive_exchangeRate");
	double InvDollarTotal = Double.parseDouble(rs_g.getString("InvDollarTotal"));

	double calculatedInvDollarTotal = Double.parseDouble(InvLocalTotal)/Double.parseDouble(Receive_exchangeRate);

	if(Math.round(InvDollarTotal) != Math.round(calculatedInvDollarTotal) )
	{
		out.print("<tr>");
		out.print("<td>"+(++srno)+"</td>");
		out.print("<td>"+Receive_Id+"</td>");
		out.print("<td>"+Receive_No+"</td>");
		out.print("<td>"+InvLocalTotal+"</td>");
		out.print("<td>"+Receive_exchangeRate+"</td>");
		out.print("<td>"+str.format(""+calculatedInvDollarTotal, 2)+"</td>");
		out.print("<td>"+str.format(""+InvDollarTotal, 2)+"</td>");
		%>
			<input type="hidden" name="Receive_Id<%=(srno-1)%>" value="<%=Receive_Id%>">
			<input type="hidden" name="newInvDollarTotal<%=(srno-1)%>" value="<%=calculatedInvDollarTotal%>">
		<%		
		out.print("</tr>");
	}		
}
pstmt_g.close();
if(srno != 0)
{
%>
	<tr>
	<input type="hidden" name="count" value="<%=srno%>">
	<td colspan=7 align=center>
	<input type="submit" name="command" value="Update Data">
	</td>
	</tr>
<%
}
else
{%>
	<tr>
	<td align=center colspan=7>
		No records found
	</td>
	<tr>
	
<%}
out.print("</table>");

pstmt_g.close();

C.returnConnection(cong);
}//command = Samyak

else if("Update Data".equals(command))
{
	String query="";

	try	{
	 cong=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	Updatelocaldollar.jsp<br>Bug No Samyak31 : "+ Samyak31);
	}

	// Code for connection end here

	int count = Integer.parseInt(request.getParameter("count"));

	String Receive_Id[] = new String[count];
	double newInvDollarTotal[] = new double[count];
	for(int i=0; i<count; i++)
	{
		Receive_Id[i] = request.getParameter("Receive_Id"+i);
		newInvDollarTotal[i] = Double.parseDouble(request.getParameter("newInvDollarTotal"+i));
	}

	int rowsUpdate =0;
	out.print("<br>Starting System Run");
	for(int i=0; i<count; i++)
	{
		query="Update Receive Set InvDollarTotal="+newInvDollarTotal[i]+" Where Receive_Id="+Receive_Id[i];
		pstmt_g = cong.prepareStatement(query);

		rowsUpdate += pstmt_g.executeUpdate();	
		pstmt_g.close();
	}
	out.print("<br>System Run Complete.<br> "+rowsUpdate+" rows updated");

	C.returnConnection(cong);
}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
	C.returnConnection(cong);
    out.println("<font color=red> FileName : Updatelocaldollar.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
