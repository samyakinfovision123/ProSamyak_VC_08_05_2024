
<!--  System Run to find and Update entries Financial_Transaction Table which are inactive and corresponding Transaction_id entries in Voucher also inactive. 
 http://localhost:8080/Nippon/Samyak/Update_FTRows_SystemRun.jsp?command=Nippon05 -->

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
		{ out.println("<font color=red> FileName : 	Update_FTRows_SystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);}
%>

<form action="Update_FTRows_SystemRun.jsp" method=post>
<table border=1 bordercolor=blue width="100%">
<tr>
<td align=center><b>Sr No</td>
<td align=center><b>Transaction_Id</td>
<td align=center><b>Voucher_Id</td>
<td align=center><b>Voucher_No</td>
</tr>


<%		int counter=0;
        query="Select count(*) as counter from voucher V,voucher V1,Financial_Transaction FT  where V.voucher_type in (8,9) and V.Active = 0 and V.Referance_VOucherId <> 0 and V1.voucher_id=V.Referance_VoucherId and V1.Active=1 and FT.voucher_id=V.Voucher_ID ";  

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
			
		while (rs_g.next())
		{
			counter=rs_g.getInt("counter");
		}	
		//out.print("<br>52 *** counter="+counter);
		pstmt_g.close();

        int Transaction_id[]=new int[counter];  
        int Voucher_Id[]=new int[counter];  
		String Voucher_No[]=new String[counter];
		java.sql.Date Voucher_Date[] =new java.sql.Date[counter];
        //boolean Receive_Internal[]=new boolean[counter];  

		query="Select FT.Tranasaction_Id,V.Voucher_Id,V.Voucher_No,V.Voucher_Date from voucher V,voucher V1,Financial_Transaction FT  where V.voucher_type in (8,9) and V.Active = 0 and V.Referance_VOucherId <> 0 and V1.voucher_id=V.Referance_VoucherId and V1.Active=1 and FT.voucher_id=V.Voucher_ID ";  

		pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();
		int k=0;	
		while (rs_g.next())
		{
			Transaction_id[k]=rs_g.getInt("Tranasaction_id");
			Voucher_Id[k]=rs_g.getInt("Voucher_Id");
			Voucher_No[k]=rs_g.getString("Voucher_No");
			Voucher_Date[k]=rs_g.getDate("Voucher_Date");
		k++;
		}	
		
		pstmt_g.close();
	int hiddenCount=0;	
	for(int i=0; i<counter; i++)
		{

		%>
          <tr>
		  <td><%=hiddenCount+1%></td>
	      <td align=center><%=Transaction_id[i]%>
    	  <input type="hidden" name=Transaction_id<%=hiddenCount%> value=<%=Transaction_id[i]%>>
		  </td>
		  <td align=center><%=Voucher_Id[i]%></td>
		  <input type="hidden" name=Voucher_Id<%=hiddenCount%> value=<%=Voucher_Id[i]%>>
		  <td align=center><%=Voucher_No[i]%></td>		
		</tr>
		<%
		  
		  hiddenCount++;
		}//for
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

if(command.equals("Update"))
	{
    out.print("<br>System Run Continued...");
	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    cong=C.getConnection();
	int a417 = 0;
	errLine="118";
	String query1="";
	String query2="";
	int receiveCount = Integer.parseInt(request.getParameter("hiddenCount"));
	int Transaction_id[]=new int[receiveCount];
	int Voucher_Id[]=new int[receiveCount];
	//out.print("<br>124 receiveCount="+receiveCount);
	errLine="125";
	for(int j=0; j<receiveCount; j++)
	{
	 Transaction_id[j]=Integer.parseInt(request.getParameter("Transaction_id"+j));
     Voucher_Id[j]=Integer.parseInt(request.getParameter("Voucher_Id"+j));
    //out.print("<br>130 Transaction_id="+Transaction_id[j]); 
    
	query1="Update Financial_Transaction set active=1, Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+" where Tranasaction_Id ="+Transaction_id[j];

		pstmt_g = cong.prepareStatement(query1);
		a417 += pstmt_g.executeUpdate();
		out.print("<br>Updated Financial_Transaction ="+Transaction_id[j]);
	errLine="136";	
	pstmt_g.close();
	
	query2="Update Voucher set active=1, Modified_MachineName='"+"Samyak:"+machine_name+":"+today_string+"'"+" where Voucher_Id ="+Voucher_Id[j];

		pstmt_g = cong.prepareStatement(query2);
		a417 += pstmt_g.executeUpdate();
	errLine="143";	
	pstmt_g.close();
	out.print("<br>Updated Voucher ="+Voucher_Id[j]);

	}//for receiveCount
	out.print("<br>Number of rows Updated "+a417+" successfully");
	errLine="148";
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
<%}	//Update
}catch(Exception Samyak31)
 { 
  C.returnConnection(cong);
  out.print("<font color=red> FileName : Update_FTRows_SystemRun.jsp<br>Bug No Samyak31 :"+Samyak31+"errline="+errLine);
 }

%>
	