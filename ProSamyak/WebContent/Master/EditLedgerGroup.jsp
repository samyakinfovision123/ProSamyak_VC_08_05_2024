<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="C"  scope="application" class="NipponBean.Connect" />

<%
String errLine="8";
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String machine_name=request.getRemoteHost();

	ResultSet rs_g = null;
	Connection conp = null;
	Connection cong = null;
	Connection cong1 = null;
	PreparedStatement pstmt_g=null;
	PreparedStatement pstmt_p=null;
	String query="";
java.sql.Date D=new java.sql.Date(System.currentTimeMillis());

try{
String command=request.getParameter("command");
String message=request.getParameter("message");
//out.print("<br>14 message = "+message);
if("edit".equals(command))
	{
	%>
<html>
<head>
	<title>Edit Ledger Group - Samyak Software</title>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<script language="javascript">
	function GroupCheck()
		{
			if(document.mainform.From_GroupId.value==document.mainform.To_GroupId.value)
			{
				alert ("From and To Groups Cannot be the Same");
				return false;
			}
			else
			{
				return true;
			}
		}
	</script>
</head>
<body background="../Buttons/BGCOLOR.JPG" >
<form name="mainform" method="post" action="EditLedgerGroup.jsp" onsubmit="return GroupCheck()">
<table align="center" border="0">
<tr><td align="center"><font class="msgred"><% if(!("masters".equals(message))) {out.print(message);}%></font></td></tr>
<tr><td>
<table  border="1" cellspacing="0" cellpadding="0" width="20%" align="center">
	<tr bgcolor="skyblue">
		<th colspan="2">Edit Ledger Group</td>
	</tr>
	<tr>
		<td>From</td>
		<td>
			<select name="From_GroupId">
				<option value='3'>Capital</option>
				<option value='15'>Current Assets</option>
				<option value='17'>Current Liabilities</option>
				<option value='6'>Direct Expenses</option>
				<option value='2'>Fixed Asset</option>
				<option value='13'>Indirect Expenses</option>
				<option value='12'>Indirect Income</option>
				<option value='5'>Investment</option>
				<option value='7'>Loan(Liabilities)</option>
				<option value='11'>Loan & Advances</option>
				<option value='16'>Misc Expenditure</option>
				<option value='18'>Reserves & Surplus</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>To</td>
		<td>
			<select name="To_GroupId">
				<option value='3'>Capital</option>
				<option value='15' selected>Current Assets</option>
				<option value='17'>Current Liabilities</option>
				<option value='6'>Direct Expenses</option>
				<option value='2'>Fixed Asset</option>
				<option value='13'>Indirect Expenses</option>
				<option value='12'>Indirect Income</option>
				<option value='5'>Investment</option>
				<option value='7'>Loan(Liabilities)</option>
				<option value='11'>Loan & Advances</option>
				<option value='16'>Misc Expenditure</option>
				<option value='18'>Reserves & Surplus</option>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="Submit" name="command" value="Next" Class="button1" onmouseover="this.className='button1_over'" onmouseout="this.className='button1'"></td>
	</tr>
</table>	
</td></tr></table>			
</form>
</body>
</html>	
<%	}//if("edit".equals(command))

if("Next".equals(command))
	{
	errLine="109";
	String From_GroupId=request.getParameter("From_GroupId");

      //out.print("<br>108 From_GroupId "+From_GroupId);

	String To_GroupId=request.getParameter("To_GroupId");
//	out.print("<br>87 To_GroupId "+To_GroupId);
	
	cong=C.getConnection();
	conp=C.getConnection();
	
	query="select count(*) as ledgercount from Ledger where For_Head="+From_GroupId+" and Active=1 and Company_Id="+company_id;
	
	pstmt_g=cong.prepareStatement(query);
	rs_g=pstmt_g.executeQuery();
	int ledgercount=0;
	while(rs_g.next())
		{
			ledgercount=rs_g.getInt("ledgercount");
		}
	pstmt_g.close();
	out.print("<br>113 ledgercount "+ledgercount);
	
	String Ledger_Id[]=new String[ledgercount];
	String For_Head[]=new String[ledgercount];
	String For_HeadId[]=new String[ledgercount];
	String Ledger_Name[]=new String[ledgercount];
	String Ledger_Type[]=new String[ledgercount];

	query="select * from Ledger where For_Head="+From_GroupId+" and Active=1 and Company_Id="+company_id+" order by Ledger_Id";
	pstmt_g=cong.prepareStatement(query);
	int i=0;
	rs_g=pstmt_g.executeQuery();
	while(rs_g.next())
		{
		Ledger_Id[i]=rs_g.getString("Ledger_Id");
//		out.print("<br>127 Ledger_Id[i] "+Ledger_Id[i]);

		For_Head[i]=rs_g.getString("For_Head");
//		out.print("<br>129 For_Head[i] "+For_Head[i]);

		For_HeadId[i]=rs_g.getString("For_HeadId");
//		out.print("<br>131 For_HeadId[i] "+For_HeadId[i]);

		Ledger_Name[i]=rs_g.getString("Ledger_Name");
//		out.print("<br>133 Ledger_Name[i] "+Ledger_Name[i]);

		Ledger_Type[i]=rs_g.getString("Ledger_Type");
//		out.print("<br>136 Ledger_Type[i] "+Ledger_Type[i]+"<br>");

		i++;
		}
	pstmt_g.close();
	errLine="162";
	
%>
<html>
<head>
	<title>Samyak Software</title>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<script language="javascript">
	function onSubmitValidate()
		{
		var counter=0;
		<% for(int j=0;j<ledgercount;j++)
			{%>
				if(document.mainform.select<%=j%>.checked)
				{
					counter++;
				}
		<%	}%>
//		alert("counter "+counter)

		if(counter==0)
			{
				alert("Please Select atleast one Ledger")
				return false;
			}
		else
			{
				return true;
			}
		}
	</script>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form name="mainform" method="post" action="EditLedgerGroup.jsp" onsubmit="return onSubmitValidate()">
<table borderColor=silver align=center border=1 cellspacing=0 cellpadding=2>
<tr bgcolor="skyblue">
	<td>Select Ledgers to Change its Group to <%=A.getNameCondition(conp,"Master_FinanceHeads","Head_Name","where Head_Id="+To_GroupId)%></td>
</tr>
<tr>
	<td>
	<table bordercolor=silver border=1 width="100%">
		<tr>
			<th>Sr. No.</th>
			<th>Ledger Name</th>
		<%	if( !( ("6".equals(To_GroupId)) || ("12".equals(To_GroupId)) || ("13".equals(To_GroupId)) ) ){%>
			<th>To Subgroup</th>
		<%}%>
		</tr>
		<input type="hidden" name="From_GroupId" value="<%=From_GroupId%>">
		<input type="hidden" name="To_GroupId" value="<%=To_GroupId%>">
		<% for(int j=0;j<ledgercount;j++)
		{%>
		<tr>
			<td><%=j+1%><input type="Checkbox" name="select<%=j%>" value="yes"></td>
			
			<input type="hidden" name="Ledger_Id<%=j%>" value="<%=Ledger_Id[j]%>">

			<input type="hidden" name="For_Head<%=j%>" value="<%=For_Head[j]%>">

			<input type="hidden" name="For_HeadId<%=j%>" value="<%=For_HeadId[j]%>">

			<input type="hidden" name="Ledger_Type<%=j%>" value="<%=Ledger_Type[j]%>">

			
			<td><%=Ledger_Name[j]%><input type="hidden" name="Ledger_Name<%=j%>" value="<%=Ledger_Name[j]%>"></td>
		
		<%	if( !( ("6".equals(To_GroupId)) || ("12".equals(To_GroupId)) || ("13".equals(To_GroupId)) ) ){%>
			<td><%=A.getMasterArrayCondition(conp,"SubGroup","To_SubGroup"+j,"", "where For_HeadId="+To_GroupId+"",company_id) %></td>
		<%}
		else{%>
			<input type="hidden" name="To_SubGroup<%=j%>" value="0">
		<%}%>
		</tr>
		<%}//for%>
		<input type="hidden" name="ledgercount" value="<%=ledgercount%>">
	</table>
	</td>
</tr>
<tr>
	<td align="center"><input type="submit" name="command" value="Update" class="button1" onmouseover="this.className='button1_over'" onmouseout="this.className='button1'"></td>
</tr>
</table>
</form>
</body>
</html>
<%
		C.returnConnection(conp);
		C.returnConnection(cong);

	}//if("Next".equals(command))

if("Update".equals(command))
	{
errLine="255";	
	//out.print("<br>222 command "+command);
	int ledgercount=Integer.parseInt(request.getParameter("ledgercount"));
	out.print("<br>235 ledgercount "+ledgercount+"<br>");
	
	String From_GroupId=request.getParameter("From_GroupId");
	String To_GroupId=request.getParameter("To_GroupId");

	String select[]=new String[ledgercount];
	String Ledger_Id[]=new String[ledgercount];
	String For_Head[]=new String[ledgercount];
	String For_HeadId[]=new String[ledgercount];
	String Ledger_Name[]=new String[ledgercount];
	String Ledger_Type[]=new String[ledgercount];
	String To_SubGroup[]=new String[ledgercount];
	for(int i=0;i<ledgercount;i++)
		{
			select[i]=request.getParameter("select"+i);
//			out.print("<br>246 select[i] "+select[i]);

			Ledger_Id[i]=request.getParameter("Ledger_Id"+i);
//			out.print("<br>249 Ledger_Id[i] "+Ledger_Id[i]);

			For_Head[i]=request.getParameter("For_Head"+i);
//			out.print("<br>252 For_Head[i] "+For_Head[i]);

			For_HeadId[i]=request.getParameter("For_HeadId"+i);
//			out.print("<br>255 For_HeadId[i] "+For_HeadId[i]);

			Ledger_Name[i]=request.getParameter("Ledger_Name"+i);
//			out.print("<br>258 Ledger_Name[i] "+Ledger_Name[i]);

			Ledger_Type[i]=request.getParameter("Ledger_Type"+i);
//			out.print("<br>261 Ledger_Type[i] "+Ledger_Type[i]);

			To_SubGroup[i]=request.getParameter("To_SubGroup"+i);
//			out.print("<br>264 To_SubGroup[i] "+To_SubGroup[i]+"<br>");
		}//for
errLine="293";	
conp=C.getConnection();
cong=C.getConnection();
conp.setAutoCommit(false);
	
	for(int i=0;i<ledgercount;i++)
		{
			if("yes".equals(select[i]))
			{
				
				if( "6".equals(To_GroupId) || "12".equals(To_GroupId) || "13".equals(To_GroupId) )
				{
					query="Insert into Master_SubGroup(SubGroup_Id, Yearend_Id, Company_Id, For_HeadId, SubGroup_Name, SubGroup_Code, Sr_No, Modified_By, Modified_On, Modified_MachineName) values(?,?,?,?,?, ?,?,?,?, ?)";
					
					pstmt_p=conp.prepareStatement(query);
					
					String SubGroup_Id=""+L.get_master_id(cong,"Master_SubGroup");
					pstmt_p.setString(1,SubGroup_Id);
					pstmt_p.setString(2,yearend_id);			
					pstmt_p.setString(3,company_id);
					pstmt_p.setString(4,To_GroupId);
					pstmt_p.setString(5,Ledger_Name[i]);
					pstmt_p.setString(6,Ledger_Name[i]);
					pstmt_p.setString(7,SubGroup_Id);
					pstmt_p.setString(8,user_id);
					pstmt_p.setString(9,""+D);
					pstmt_p.setString(10,machine_name);
					pstmt_p.executeUpdate();
					pstmt_p.close();

					query="Update Ledger set For_Head=? , For_HeadId=? where Ledger_Id="+Ledger_Id[i]+" and Company_Id="+company_id+" and Yearend_Id="+yearend_id;
					pstmt_p=conp.prepareStatement(query);
					pstmt_p.setString(1,To_GroupId);
					pstmt_p.setString(2,SubGroup_Id);
					pstmt_p.executeUpdate();
					pstmt_p.close();
					
					query="Update Financial_transaction set For_Head=?, For_HeadId=? where Ledger_Id="+Ledger_Id[i]+" and Company_Id="+company_id+" and Yearend_Id="+yearend_id;;
					pstmt_p=conp.prepareStatement(query);
					pstmt_p.setString(1,To_GroupId);
					pstmt_p.setString(2,SubGroup_Id);
					pstmt_p.executeUpdate();
					pstmt_p.close();
	errLine="336";
					query="Insert into LedgerChangeLog (LedgerChangeLog_Id, Company_Id, Ledger_Id, OldFor_Head, OldFor_HeadId, OldLedger_Type, NewFor_Head, NewFor_HeadId, NewLedger_Type, Modified_On, Modified_By, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?,?)";
					pstmt_p=conp.prepareStatement(query);
					String LedgerChangeLog_Id=""+L.get_master_id(cong,"LedgerChangeLog");
					pstmt_p.setString(1,LedgerChangeLog_Id);
					pstmt_p.setString(2,company_id);
					pstmt_p.setString(3,Ledger_Id[i]);
					pstmt_p.setString(4,For_Head[i]);
					pstmt_p.setString(5,For_HeadId[i]);
					pstmt_p.setString(6,Ledger_Type[i]);
					pstmt_p.setString(7,To_GroupId);
					pstmt_p.setString(8,SubGroup_Id);
					pstmt_p.setString(9,Ledger_Type[i]);
					pstmt_p.setString(10,""+D);
					pstmt_p.setString(11,user_id);
					pstmt_p.setString(12,machine_name);
					pstmt_p.executeUpdate();
					pstmt_p.close();
				}
			else{	
				
				query="Update Ledger set For_Head=? , Ledger_Type=? where Ledger_Id="+Ledger_Id[i]+" and Company_Id="+company_id+" and Yearend_Id="+yearend_id;;
				pstmt_p=conp.prepareStatement(query);
				pstmt_p.setString(1,To_GroupId);
				pstmt_p.setString(2,To_SubGroup[i]);
				pstmt_p.executeUpdate();
				pstmt_p.close();
				
				query="Update Financial_transaction set For_Head=?, For_HeadId=? where Ledger_Id="+Ledger_Id[i]+" and Company_Id="+company_id+" and Yearend_Id="+yearend_id;;
				pstmt_p=conp.prepareStatement(query);
				pstmt_p.setString(1,To_GroupId);
				pstmt_p.setString(2,To_SubGroup[i]);
				pstmt_p.executeUpdate();
				pstmt_p.close();
		errLine="370";			
				query="Insert into LedgerChangeLog (LedgerChangeLog_Id, Company_Id, Ledger_Id, OldFor_Head, OldFor_HeadId, OldLedger_Type, NewFor_Head, NewFor_HeadId, NewLedger_Type, Modified_On, Modified_By, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?,?)";
				
				pstmt_p=cong.prepareStatement(query);
				
				String LedgerChangeLog_Id= ""+L.get_master_id(cong,"LedgerChangeLog");
				
				pstmt_p.setString(1,LedgerChangeLog_Id);
				pstmt_p.setString(2,company_id);
				pstmt_p.setString(3,Ledger_Id[i]);
				pstmt_p.setString(4,For_Head[i]);
				pstmt_p.setString(5,For_HeadId[i]);
				pstmt_p.setString(6,Ledger_Type[i]);
				pstmt_p.setString(7,To_GroupId);
				pstmt_p.setString(8,For_HeadId[i]);
				pstmt_p.setString(9,To_SubGroup[i]);
				pstmt_p.setString(10,""+D);
				pstmt_p.setString(11,user_id);
				pstmt_p.setString(12,machine_name);
				
				pstmt_p.executeUpdate();
				pstmt_p.close();
				
				}
			}//if("yes".equals(select[i]))
		}//for
	conp.commit();
	C.returnConnection(conp);
	C.returnConnection(cong);
	errLine="400";
	response.sendRedirect("EditLedgerGroup.jsp?command=edit&message=Data Updated Successfully");
	}//if("Update".equals(command))
}catch(Exception e)
{out.print("<br>Exception  "+e); conp.rollback();}
%>
