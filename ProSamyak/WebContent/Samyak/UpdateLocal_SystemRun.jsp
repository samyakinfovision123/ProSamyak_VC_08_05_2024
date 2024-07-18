

<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/UpdateLocal_SystemRun.jsp?command=Samyak07
-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>
<%
	Connection cong = null;
	Connection conp = null;
    
	PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

	ResultSet rs_g=null;
	ResultSet rs_p=null;
%>
<html>
	<head>
	<title>Stock Ageing Report</title></head>
			<body bgcolor=white >

			<table  bordercolor=skyblue border=0  align=center width='50%'>
			
			<tr>
				<th><font color=red>Type</font></th>
				<th><font color=red>Company Name</font></th> 
				<th><font color=red>Total</font></th>
				<th><font color=red>Local Id</font></th>
				<th><font color=red>Normal Id</font></th>
				
			</tr>
			<tr><td colspan=5><font color=#33FFFF><hr ></font></td></tr>
<%

try
{
	String command=request.getParameter("command");

	if(command.equals("Samyak07"))
	{
		try	
		{
			cong=C.getConnection();
			conp=C.getConnection();  
		}
		catch(Exception Samyak31)
		{ 
		
			 C.returnConnection(cong);
			 C.returnConnection(conp);  
			 out.println("<font color=red> FileName : 	UpdateToByNosSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}

		int cnt=0;

		String Query="select count(*) as cnt from Master_CompanyParty where Super=1 and Active=1";
	
		pstmt_g=cong.prepareStatement(Query);

		rs_g=pstmt_g.executeQuery();

		while(rs_g.next()) 	
		{
			cnt=rs_g.getInt("cnt");
		}
		pstmt_g.close();
	
		String CompanyParty_Id[]=new String[cnt];
		String CompanyParty_Name[]=new String[cnt];
		int i=0;

		Query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where Super=1 and Active=1";

		pstmt_g=cong.prepareStatement(Query);

		rs_g=pstmt_g.executeQuery();
	
		while(rs_g.next()) 	
		{
			CompanyParty_Id[i]=rs_g.getString("CompanyParty_Id");
		    CompanyParty_Name[i]=rs_g.getString("CompanyParty_Name");
			i++;
		}
		pstmt_g.close();

		String Local="";
		String Normal="";
		String Local_Id="";
		String Normal_Id="";
	
		for(i=0;i<cnt;i++)
		{
			int count=0;

			String selectQuery="select count(*) as count from Master_PurchaseSaleGroup where Company_Id ="+CompanyParty_Id[i]+" AND (PurchaseSaleGroup_Type = 1) and PurchaseSaleGroup_Name In('Local','Normal')";

			pstmt_g=cong.prepareStatement(selectQuery);

			rs_g=pstmt_g.executeQuery();
	
			while(rs_g.next()) 	
			{
				count=rs_g.getInt("count");
			}
			pstmt_g.close();

			String PurchaseSaleGroup_Id[]=new String[count];
			String PurchaseSaleGroup_Name[]=new String[count];
			if(count>1)
			{
				selectQuery="select PurchaseSaleGroup_Id, PurchaseSaleGroup_Name from Master_PurchaseSaleGroup where Company_Id ="+CompanyParty_Id[i]+" AND (PurchaseSaleGroup_Type = 1) and PurchaseSaleGroup_Name In('Local','Normal')";

				pstmt_g=cong.prepareStatement(selectQuery);

				rs_g=pstmt_g.executeQuery();
				int k=0;	
			
				while(rs_g.next()) 	
				{
			
					PurchaseSaleGroup_Id[k]=rs_g.getString("PurchaseSaleGroup_Id");
					PurchaseSaleGroup_Name[k]=rs_g.getString("PurchaseSaleGroup_Name");
				
					if("Local".equals(PurchaseSaleGroup_Name[k]))
					{
						Local=PurchaseSaleGroup_Name[k];
						Local_Id=PurchaseSaleGroup_Id[k];
						//out.print("<br>124 Local="+Local);
						//out.print("<br>124 Local_Id="+Local_Id);
					}
					else
					{
						Normal=PurchaseSaleGroup_Name[k];
						Normal_Id=PurchaseSaleGroup_Id[k];
						//out.print("<br>131 Normal="+Normal);
						//out.print("<br>132 Normal_Id="+Normal_Id);
					}
					k++;

					//out.print("<br>136 Normal_Id="+Normal_Id);
		
				}
				pstmt_g.close();

				String updateQuery="Update Receive set PurchaseSaleGroup_Id="+Local_Id+" where Company_Id="+ CompanyParty_Id[i]+" AND PurchaseSaleGroup_Id= "+Normal_Id+" "  ;
				
				pstmt_p = conp.prepareStatement(updateQuery);
				int counter = pstmt_p.executeUpdate();
			%>
				
			<tr>
				
				<td align=center><font color=blue>Sale</font></td> 
				<td align=center><%=CompanyParty_Name[i]%></td>
				<td align=center><%=counter%></td>
				<td align=center><%=Local_Id%></td>
				<td align=center><%=Normal_Id%></td>
			</tr>
				
		<%
			}	
		
			int count1=0;

			String selectQuery1="select count(*) as count1 from Master_PurchaseSaleGroup where Company_Id ="+CompanyParty_Id[i]+" AND (PurchaseSaleGroup_Type = 0) and PurchaseSaleGroup_Name In('Local','Normal')";

			pstmt_g=cong.prepareStatement(selectQuery1);

			rs_g=pstmt_g.executeQuery();
	
			while(rs_g.next()) 	
			{
				count1=rs_g.getInt("count1");
			}
			pstmt_g.close();

			String PurchaseSaleGroup_Id1[]=new String[count1];
			String PurchaseSaleGroup_Name1[]=new String[count1];
			if(count1>1)
			{
				selectQuery1="select PurchaseSaleGroup_Id, 	PurchaseSaleGroup_Name from Master_PurchaseSaleGroup where Company_Id ="+CompanyParty_Id[i]+" AND (PurchaseSaleGroup_Type = 0) and PurchaseSaleGroup_Name In('Local','Normal')";

				pstmt_g=cong.prepareStatement(selectQuery1);

				rs_g=pstmt_g.executeQuery();
				int k=0;	
			
				while(rs_g.next()) 	
				{
			
					PurchaseSaleGroup_Id1[k]=rs_g.getString("PurchaseSaleGroup_Id");
					PurchaseSaleGroup_Name1[k]=rs_g.getString("PurchaseSaleGroup_Name");
				
					if("Local".equals(PurchaseSaleGroup_Name[k]))
					{
						Local=PurchaseSaleGroup_Name1[k];
						Local_Id=PurchaseSaleGroup_Id1[k];
						//out.print("<br>124 Local="+Local);
						//out.print("<br>124 Local_Id="+Local_Id);
					}
					else
					{
						Normal=PurchaseSaleGroup_Name1[k];
						Normal_Id=PurchaseSaleGroup_Id1[k];
						//out.print("<br>131 Normal="+Normal);
						//out.print("<br>132 Normal_Id="+Normal_Id);
					}
					k++;

					//out.print("<br>136 Normal_Id="+Normal_Id);
		
				}
				pstmt_g.close();

				String updateQuery="Update Receive set PurchaseSaleGroup_Id="+Local_Id+" where Company_Id="+ CompanyParty_Id[i]+" AND PurchaseSaleGroup_Id= "+Normal_Id+" "  ;
				
				pstmt_p = conp.prepareStatement(updateQuery);
				int counter = pstmt_p.executeUpdate();
				//out.print("<br>147 counter="+counter);
				
		%>
			<tr>
				
				<td align=center><font color=#FF00FF>Purchase</font></td> 
				<td align=center><%=CompanyParty_Name[i]%></td>
				<td align=center><%=counter%></td>
				<td align=center><%=Local_Id%></td>
				<td align=center><%=Normal_Id%></td>
			</tr>
			<tr><td colspan=5><hr></td></tr>
		<%


			}

		}
		conp.commit(); 
		
		C.returnConnection(cong);
		C.returnConnection(conp);
	} //if
} //try
catch(Exception e)
{
	conp.rollback();
	
	C.returnConnection(cong);
	C.returnConnection(conp);  
	out.print("<br>87 The error in file UpdateToByNosSystemRun.jsp"+e);

}
%>
</body >
</html>
			