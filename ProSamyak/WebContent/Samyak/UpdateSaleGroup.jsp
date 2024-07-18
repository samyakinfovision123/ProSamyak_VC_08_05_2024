
<%//URL Path = "Samyak/UpdateSaleGroup.jsp?command=Nippon"
%>
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<% 
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

try	
{
	cong=C.getConnection();
	conp=C.getConnection();
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	
	int year=D.getYear();
	int dd=D.getDate();
	int mm=D.getMonth();
	java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
	
	String command = request.getParameter("command");

	if("Nippon".equals(command))
	{
		String selectQuery = "Select count(*) as count from Receive r,Master_CompanyParty MCP where R.Receive_fromId=MCP.CompanyParty_Id and r.Company_id=4 and r.Purchase=1 and r.Receive_sell=0 and r.Active=1 and r.R_Return=0 and r.Receive_FromId <> 4 and r.receive_fromid in (Select companyparty_id from Master_CompanyParty where companyparty_name not like '%AMY_HK'and active=1 and sale=1 and super=0 and company_id=4 ) and r.purchasesalegroup_id in (49)";

		pstmt_g = cong.prepareStatement(selectQuery);
		 
		rs_g = pstmt_g.executeQuery();

		int count = 0;

		while(rs_g.next())
		{
			count = rs_g.getInt("count");
		}
		pstmt_g.close();

		String vch_no[] = new String[count];
		String cust_name[] = new String[count];

		selectQuery = "Select * from Receive r,Master_CompanyParty MCP where  R.Receive_fromId=MCP.CompanyParty_Id and r.Company_id=4 and r.Purchase=1 and r.Receive_sell=0 and r.Active=1 and r.R_Return=0 and r.Receive_FromId <> 4 and r.receive_fromid in (Select companyparty_id from Master_CompanyParty where companyparty_name not like '%AMY_HK'and active=1 and sale=1 and super=0 and company_id=4 ) and r.purchasesalegroup_id in (49)";

		pstmt_g = cong.prepareStatement(selectQuery);
		 
		rs_g = pstmt_g.executeQuery();

		int i = 0;

		while(rs_g.next())
		{
			vch_no[i] = rs_g.getString("receive_no");
			cust_name[i] = rs_g.getString("CompanyParty_Name");
			i++;
		}
		pstmt_g.close();

%>
	<html><head><title>UpdateSaleGroup</title>
		<script language=javascript src="../Samyak/ListBoxMultiple.js"></script>
		<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
		
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<body>
	<form name="mainform" action="UpdateSaleGroup.jsp">
	<table align=center border=1 cellspacing=0>
		<tr ><th align=center colspan=3>Update Sale Group</th></tr>	
		<tr bgcolor=#009999>
			<th width="2%" >Sr No</th>
			<th width="9%">Vch. No</th>
			<th width="18%" >Customer</th>
		</tr>
	
<%	int srno = 1;
	for(int j=0;j<count;j++)
	{
%>
		<tr>
			<td><%=srno%></td>
			<td><%=vch_no[j]%></Td>
			<td><%=cust_name[j]%></Td>
		<tr>
<%
		srno++;
	}//end for j
%>
	<tr>
		<td align=center colspan=3><input type=submit value='Update' name=command class='Button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" ></td>
	</tr>
<%
	}//end command Nippon

	if("Update".equals(command))
	{
		
		String selectQuery = "Select count(*) as count from Receive r,Master_CompanyParty MCP where R.Receive_fromId=MCP.CompanyParty_Id and r.Company_id=4 and r.Purchase=1 and r.Receive_sell=0 and r.Active=1 and r.R_Return=0 and r.Receive_FromId <> 4 and r.receive_fromid in (Select companyparty_id from Master_CompanyParty where companyparty_name not like '%AMY_HK'and active=1 and sale=1 and super=0 and company_id=4 ) and r.purchasesalegroup_id in (49)";

		pstmt_g = cong.prepareStatement(selectQuery);
		 
		rs_g = pstmt_g.executeQuery();

		int count = 0;

		while(rs_g.next())
		{
			count = rs_g.getInt("count");
		}
		pstmt_g.close();

		String vch_no[] = new String[count];
		String cust_id[] = new String[count];
		String cust_name[] = new String[count];

		selectQuery = "Select CompanyParty_Id from Receive r,Master_CompanyParty MCP where  R.Receive_fromId=MCP.CompanyParty_Id and r.Company_id=4 and r.Purchase=1 and r.Receive_sell=0 and r.Active=1 and r.R_Return=0 and r.Receive_FromId <> 4 and r.receive_fromid in (Select companyparty_id from Master_CompanyParty where companyparty_name not like '%AMY_HK'and active=1 and sale=1 and super=0 and company_id=4 ) and r.purchasesalegroup_id in (49)";

		pstmt_g = cong.prepareStatement(selectQuery);
		 
		rs_g = pstmt_g.executeQuery();

		int i = 0;

		while(rs_g.next())
		{
			cust_id[i] = rs_g.getString("CompanyParty_Id");
			i++;
		}
		pstmt_g.close();
		
		for(int j=0;j<count;j++)
		{
			String updateQuery = "Update Receive set purchasesalegroup_id=7,Modified_MachineName='Samyak_"+D+"' where Receive_FromId="+cust_id[j];

			pstmt_p = conp.prepareStatement(updateQuery);

			int a140 = pstmt_p.executeUpdate();
		}
%>
	<script language=javascript>
	alert("Updated Successfully");
	window.close();
	</script>
<%
	}//end command Update

	C.returnConnection(conp);
	C.returnConnection(cong);

}//end try
catch(Exception e31)
{ 
	C.returnConnection(conp);
	C.returnConnection(cong);

	out.println("<font color=red> FileName : CgtReport.jsp<br>Bug No e31 : "+ e31);
} //end catch Exception e31

%>
</form>
</body>
</html>
