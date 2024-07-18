<!-- 
System run to update incorrect category code of the companies

type the url in the browser 
http://localhost:8080/Nippon/Samyak/SysRunCompanyParty_CategoryId.jsp?command=Samyak08
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
String errLine="17";
Connection cong = null;
Connection conp = null;

try{
String command=request.getParameter("command");
if(command.equals("Samyak08"))
{

	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	cong=C.getConnection();
	errLine="31";
	

	out.print("<br>System Run Started...");

	String query="Select count(*) as counter from Master_CompanyParty"; 
	pstmt_g = cong.prepareStatement(query);


	rs_g = pstmt_g.executeQuery();	
	int counter=0;

	while(rs_g.next()) 
	{
		counter=rs_g.getInt("counter");
	}

	pstmt_g.close();
	errLine="49";
%>
	<Center>
	<table border=1>
	<tr>
		<th>Company Party Id</th>	
		<th>Company Party Name</th>	
		<th>Current Category Code</th>	
		<th>Correct Category Code</th>	
	</tr>
	<form action="SysRunCompanyParty_CategoryId.jsp" method=post>
	<%
	String query1="Select *  from Master_CompanyParty ";  
	//out.print("<br> After Query =" +query);
	pstmt_g = cong.prepareStatement(query1);

	rs_g = pstmt_g.executeQuery();	
	int rowCount = 0;
	while(rs_g.next()) 
	{

		int CompParty_Id=rs_g.getInt("CompanyParty_Id");
		String CompParty_Name=rs_g.getString("CompanyParty_Name");
		String CatCode=rs_g.getString("Category_Code");
		if( (! "4".equals(CatCode)) && (CompParty_Id>0 && CompParty_Id<5) )
		{	
		%>
			<Tr>	
				<Td><%=CompParty_Id%></Td>
				<Td><%=CompParty_Name%></Td>
				<Td><%=CatCode%></Td>
				<Td><%="4"%></Td>
				<input type=hidden name="companyparty_id<%=rowCount%>" 	value="<%=CompParty_Id%>" >
				<input type=hidden name="newCategory_Code<%=rowCount%>" value="4" >
			</Tr>
			<%
			rowCount++;	
		}


		if( (! "3".equals(CatCode)) && (CompParty_Id>4 && CompParty_Id<7) )
		{	
		%>
			<Tr>	
				<Td><%=CompParty_Id%></Td>
				<Td><%=CompParty_Name%></Td>
				<Td><%=CatCode%></Td>
				<Td><%="3"%></Td>
				<input type=hidden name="companyparty_id<%=rowCount%>" value="<%=CompParty_Id%>" >
				<input type=hidden name="newCategory_Code<%=rowCount%>" value="3" >
			</Tr>
		<%
			rowCount++;	
		}


		if( (! "0".equals(CatCode))  && CompParty_Id>6 )
		{	
		%>
			<Tr>	
				<Td><%=CompParty_Id%></Td>
				<Td><%=CompParty_Name%></Td>
				<Td><%=CatCode%></Td>
				<Td><%="0"%></Td>
				<input type=hidden name="companyparty_id<%=rowCount%>" value="<%=CompParty_Id%>" >
				<input type=hidden name="newCategory_Code<%=rowCount%>" value="0" >
			</Tr>
		<%
			rowCount++;	
		}
		
	
	}

	pstmt_g.close();
	errLine="124";
	%>
	<input type=hidden name="rowCount" value="<%=rowCount%>" >		
	<tr>
		<td colspan=4 align=center><input type="submit" name=command value="Update"></td>
	</tr>
	</form>
	</table>
	</Center>

<%
	C.returnConnection(cong);
	C.returnConnection(conp);

}//if command equals samyak08


if(command.equals("Update"))
{

	ResultSet rs_g= null;
    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;
	conp=C.getConnection();
	cong=C.getConnection();
	errLine="149";
	

	out.print("<br>System Run Continued...");

	int a417 = 0;

	String rowCountStr = request.getParameter("rowCount");
	int rowCount = Integer.parseInt(rowCountStr);
	if(rowCount > 0)
	{
		for(int i=0; i<rowCount; i++)
		{
			String companyparty_id = request.getParameter("companyparty_id"+i);
			String code = request.getParameter("newCategory_Code"+i);

			String query="UPDATE Master_CompanyParty SET Category_Code="+code+", Modified_By=0,Modified_MachineName='SamyakSystemRun' where CompanyParty_Id="+companyparty_id;
			pstmt_p = conp.prepareStatement(query);
			a417 += pstmt_p.executeUpdate();
			pstmt_p.close();
			errLine="169";
		}
	}

	C.returnConnection(cong);
	C.returnConnection(conp);


	out.print("<br>Total Rows updated :"+a417);
	out.print("<br>System Run Completed .");


}//if command equals update

}
catch(Exception e)
{
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.println("Exception at Line "+errLine+" bug is :"+e);
}//eo catch
%>
		  