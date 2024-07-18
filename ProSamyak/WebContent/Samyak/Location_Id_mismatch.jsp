
<!--  System Run to find entries in Receive and Receive_transaction in which RT.Location_Id is updated wrongly.Due to this there was diff in Closing of Locations.

http://localhost:8080/Nippon/Samyak/Location_Id_mismatch.jsp?command=Nippon05 -->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<%
Connection cong = null;

String errLine="12";
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
try{
	String command=request.getParameter("command");
	//String company_id=request.getParameter("company_id");
	if(command.equals("Nippon05"))
	{
		//out.print("<br>21 command ="+command);
		String query="";
		ResultSet rs_g= null;

		PreparedStatement pstmt_g=null;
	
	try	{ cong=C.getConnection();}
		catch(Exception Samyak31)
		{ out.println("<font color=red> FileName : 	Location_Id_mismatch.jsp<br>Bug No Samyak31 : "+ Samyak31);}
%>

<form action="Location_Id_mismatch.jsp" method=post>
<table border=1 bordercolor=blue width="100%">
<th colspan=7 align=center>Location_Id Mismatch Data</th>
<tr>
<td align=center><b>Sr No</td>
<td align=center><b>Receive_Id</td>
<td align=center><b>Receive_No</td>
<td align=center><b>Company_Id</td>
<td align=center><b>Receive_Date</td>
<td align=center><b>ReceiveTransaction_Id</td>
<td align=center><b>Location_Id</td>
</tr>

	
<%		int Receive_Id=0,Company_Id=0,ReceiveTransaction_Id=0;
		int Location_Id=0,hiddenCount=0;	
		java.sql.Date Receive_Date =new java.sql.Date(System.currentTimeMillis());
		String Receive_No="";

		for(int x=1;x<7;x++)
		{
		
        query="select R.Receive_Id,R.Receive_No,R.Company_Id,R.Receive_Date,RT.ReceiveTransaction_Id,RT.Location_Id from Receive_Transaction RT, Receive R  where R.Company_Id="+x+" and R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Location_Id not In (Select Location_Id from Master_Location where Company_Id="+x+")";  

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
		//out.print("<br>58 query="+query);
		while (rs_g.next())
		{
			Receive_Id=rs_g.getInt("Receive_Id");
			Receive_No=rs_g.getString("Receive_No");
			Company_Id=rs_g.getInt("Company_Id");
			Receive_Date=rs_g.getDate("Receive_Date");
			ReceiveTransaction_Id=rs_g.getInt("ReceiveTransaction_Id");
			Location_Id=rs_g.getInt("Location_Id");

		%>
          <tr>
		  <td><%=hiddenCount+1%></td>
	      <td align=center><%=Receive_Id%></td>
	      <td align=center><%=Receive_No%></td>
	      <td align=center><%=Company_Id%></td>
	      <td align=center><%=Receive_Date%></td>
	      <td align=center><%=ReceiveTransaction_Id%></td>
	      <td align=center><%=Location_Id%></td>
    	  		  
		  		
		</tr>
		<%
		}	//end of 'While'
		
		pstmt_g.close();
		
		}//end of 'for'

		
		
		//out.print("<br>94 hiddenCount="+hiddenCount);
if(hiddenCount>0)
{
%>
	<tr>
	<td>
	<input type="hidden" name=hiddenCount value=<%=hiddenCount%>>
	<input type=submit name=command value=Update>
	</td>
	</tr>
<%}%>
</table>
</form>
	<%
	C.returnConnection(cong);
	} //command=Nippon05


}catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
  out.print("<font color=red> FileName : Location_Id_mismatch.jsp<br>Bug No Samyak31 :"+Samyak31+"errline="+errLine);
 }

%>
	