<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
// Code for connection start here
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;


try{
String command=request.getParameter("command");
//String table_name="Ledger";
int tempx=0;
if(command.equals("Samyak")){
//out.print("<br>23Hans");
String query="";

try	{
	 cong=C.getConnection();
	 conp=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	lotMismatch.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

// Code for connection end here



query="Select count(*) as counter from Receive where Active=1";
//company_id="+company_id+""; 
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int count=0;
while(rs_g.next())

{
	count = rs_g.getInt("counter");
    //out.print("<br>46 Counter's value "+count);
}
pstmt_g.close();

String Receive_Id[] = new String[count];
String Receive_No[] = new String[count];
String company_id[] = new String[count];
int Receive_Lots[] = new int[count];
int RTLotCount[] = new int[count];
query="Select Receive_Id, Receive_No, Receive_Lots, company_id from Receive Where Active=1 order by company_id, Receive_No";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	

out.print("<form action='lotMismatchUpdate.jsp' method=post>");
out.print("<table border=1>");
out.print("<caption>List of mismatch lots in R and RT</caption>");
out.print("<tr>");
out.print("<th>Sr No.</th>");
out.print("<th>Company_Id</th>");
out.print("<th>Receive_Id</th>");
out.print("<th>Receive_No</th>");
out.print("<th>Receive_Lots</th>");
out.print("<th>RT Lot Count</th>");
out.print("</tr>");

int c=0;
int srno=0;
while(rs_g.next())

{
	Receive_Id[c] = rs_g.getString("Receive_Id");
	Receive_No[c] = rs_g.getString("Receive_No");
	Receive_Lots[c] = rs_g.getInt("Receive_Lots");
	company_id[c] = rs_g.getString("company_id");
	
	String RTquery="Select count(*) as counter from Receive_Transaction where Active=1 and Receive_Id="+Receive_Id[c];
	pstmt_p = conp.prepareStatement(RTquery);
	rs_p = pstmt_p.executeQuery();	
	while(rs_p.next())
	{
		RTLotCount[c] = rs_p.getInt("counter");
	}
	rs_p.close();
	pstmt_p.close();

	if(RTLotCount[c] != Receive_Lots[c])
	{

		out.print("<tr>");
		%>
		<input type="hidden" name="Receive_Id<%=srno%>" value="<%=Receive_Id[c]%>">
		<input type="hidden" name="RTLotCount<%=srno%>" value="<%=RTLotCount[c]%>">
		<%
		out.print("<td>"+(++srno)+"</td>");
		out.print("<td>"+company_id[c]+"</td>");
		out.print("<td>"+Receive_Id[c]+"</td>");
		out.print("<td>"+Receive_No[c]+"</td>");
		out.print("<td>"+Receive_Lots[c]+"</td>");
		out.print("<td>"+RTLotCount[c]+"</td>");
		out.print("</tr>");
	}
	c++;
}
pstmt_g.close();


C.returnConnection(cong);
C.returnConnection(conp);
if(srno!=0)
{
%>
	<tr>
	<td align=center colspan=6>
		<input type="submit" name="command" value="Update Data">
		<input type="hidden" name="count" value="<%=srno%>">
	</td>
	<tr>
<%}
else
{%>
	<tr>
	<td align=center colspan=6>
		No Such records
	</td>
	<tr>
	
<%}%>
</table>
<%
}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
	C.returnConnection(cong);
	C.returnConnection(conp);

	out.println("<font color=red> FileName : lotMismatch.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
