<!--
System Run to Update Receive_Internal column in Receive table

http://localhost:8080/Nippon/Samyak/UpdateReceive_InternalSystemRun.jsp?command=Nippon05
 -->
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<%
Connection cong = null;
String errLine="9";
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
try{
	String command=request.getParameter("command");
	//String company_id=request.getParameter("company_id");
	if(command.equals("Nippon05"))
	{
		//out.print("<br>16 command ="+command);
		String query="";
		ResultSet rs_g= null;

		PreparedStatement pstmt_g=null;
	
	try	{ cong=C.getConnection();}
		catch(Exception Samyak31)
		{ out.println("<font color=red> FileName : 	UpdateReceive_InternalSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);}
%>
<form action="UpdateReceive_InternalSystemRun.jsp" method=post>
<table border=1 bordercolor=blue width="100%">
<tr>
<td align=center><b>Sr No</td>
<td align=center><b>Receive_Id</td>
</tr>


<%		int counter=0;
        query="Select count(*) as counter from receive where purchase=1 and active=1 and receive_sell=0 and company_id=1 and receive_internal=1 and receive_id in(Select challan_no from receive where receive_sell=1 and stockTransfer_type=0 and active=0)";  

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
			
		while (rs_g.next())
		{
			counter=rs_g.getInt("counter");
		}	
		//out.print("<br>37 *** counter="+counter);
		pstmt_g.close();

        int Receive_id[]=new int[counter];  
		String Receive_No[]=new String[counter];
		java.sql.Date Receive_Date[] =new java.sql.Date[counter];
        boolean Receive_Internal[]=new boolean[counter];  

		query="Select Receive_Id,Receive_No,Receive_Date,Receive_Internal from receive where purchase=1 and active=1 and receive_sell=0 and company_id=1 and receive_internal=1 and receive_id in(Select challan_no from receive where receive_sell=1 and stockTransfer_type=0 and active=0)";  

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
		int k=0;	
		while (rs_g.next())
		{
			Receive_id[k]=rs_g.getInt("Receive_Id");
			Receive_No[k]=rs_g.getString("Receive_No");
			Receive_Date[k]=rs_g.getDate("Receive_Date");
			Receive_Internal[k]=rs_g.getBoolean("Receive_Internal");
		k++;
		}	
		
		pstmt_g.close();
	int hiddenCount=0;	
	for(int i=0; i<counter; i++)
		{

		int count=0;
		query="Select count (*) as count  from receive where receive_sell=1 and challan_no="+Receive_id[i]+" and active=1";   

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();

		while (rs_g.next())
		{
			count=rs_g.getInt("count");
        
		 if(count==0)
		{
			 %>
          <tr>
		  <td><%=hiddenCount+1%></td>
	      <td align=center><%=Receive_id[i]%>

			<input type="hidden" name=Receive_id<%=hiddenCount%> value=<%=Receive_id[i]%>>
		 </td>
		</tr>
		<%
		  
		  hiddenCount++;
		}//if(count==0)

		}//while
		pstmt_g.close();
	

		}//for
		//out.print("<br>103 hiddenCount="+hiddenCount);
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
	}//command=Nippon05

if(command.equals("Update"))
	{
    out.print("<br>System Run Continued...");
	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    cong=C.getConnection();
	int a417 = 0;
	errLine="124";
	String query1="";
	int receiveCount = Integer.parseInt(request.getParameter("hiddenCount"));
	int Receive_id[]=new int[receiveCount];
	//out.print("<br>128 receiveCount="+receiveCount);
	errLine="127";
	for(int j=0; j<receiveCount; j++)
	{
	 Receive_id[j]=Integer.parseInt(request.getParameter("Receive_id"+j));
    //out.print("<br>129 Receive_id="+Receive_id[j]); 
    
	query1="Update Receive set Receive_Internal=?,Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+"  where Receive_Id="+Receive_id[j];

		pstmt_g = cong.prepareStatement(query1);
		pstmt_g.setBoolean(1,false);
		a417 += pstmt_g.executeUpdate();
	errLine="138";	
	pstmt_g.close();
	}//for receiveCount
	out.print("<br>Number of rows Updated "+a417+" successfully");
	errLine="142";
	C.returnConnection(cong);
	out.println("<br>System Run Completed.");
%>
	<html>
<head>
<title>Samyak System Run</title>
<script language="JavaScript">
function f1()
{
alert("System Run Completed");
window.close(); 
} 
</script>
<body background="../Buttons/BGCOLOR.JPG" onLoad='f1()' > 
</body>
</html>
<%	}//Update
}
catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
  out.println("<font color=red> FileName : UpdateReceive_InternalSystemRun.jsp<br>Bug No Samyak31 :"+Samyak31+"errline="+errLine);
 }

%>