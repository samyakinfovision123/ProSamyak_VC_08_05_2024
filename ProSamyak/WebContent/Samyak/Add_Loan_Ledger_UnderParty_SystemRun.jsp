
 <!--  
Use of System Run:- Add Loan Ledger  Under Party 
How to Run System Run:-
Type in url:-/Samyak/Add_Loan_Ledger_UnderParty_SystemRun.jsp?command=Samyak&company_id=


-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<%

Connection conp=null;
Connection cong=null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_g1=null;
ResultSet rs_g=null;
ResultSet rs_g1=null;
String errLine="25";
String query="";
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
java.sql.Date D1 = new java.sql.Date(System.currentTimeMillis());

// To insert head_id , for_head_id and ledger_type assign value to the following variables . 

String for_head="11";
String for_head_id="11";
String ledger_type="";

String  ledger_name="";
if(command.equals("Samyak")&&!("".equals(company_id)))
{%>
	<html>
		<head><title>Add Column</title></head>
		<body> 

<%
	try
	{
		int ledger_id=0;
		errLine="47";
		C = new Connect();
		conp=C.getConnection();
		cong=C.getConnection();
		//out.println("cong="+cong);
		//out.println("conp="+conp);
		out.println("System Run started....<br>");
		
		String for_head_and_id="select SubGroup_Id from Master_SubGroup where company_id="+company_id+" and for_headId=11";
		pstmt_g=cong.prepareStatement(for_head_and_id);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
			ledger_type=rs_g.getString("SubGroup_Id");
			break;
		} //while()
		pstmt_g.close();

		errLine="50";
		String count_ledger_id="select count(*) as row_counter from Ledger";
		pstmt_g=cong.prepareStatement(count_ledger_id);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
			ledger_id=rs_g.getInt("row_counter");
		} //while()
		pstmt_g.close();
		
		errLine="59";
		String company_party_id="select For_HeadId,Ledger_Name from Ledger where for_head=14 and active=1 and ledger_type=1 and company_id="+company_id;
		pstmt_g=cong.prepareStatement(company_party_id);
		rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
			//get company_party_id
			
			String party_id=rs_g.getString("For_HeadId");
			ledger_name=rs_g.getString("Ledger_Name");
			//out.println("#### party_id="+party_id);
			
			String str=ledger_name;
			int length1=str.lastIndexOf("Sales");
			String other_ledger_name=str.substring(0,(length1-1));
			
			errLine="74";
			int counter=0;
			String  str_counter_ledger="select count(*) as r_counter from Ledger where ParentCompanyParty_Id="+party_id;
			pstmt_g1=cong.prepareStatement(str_counter_ledger);
			rs_g1 = pstmt_g1.executeQuery();	
			while(rs_g1.next())
			{
				counter=rs_g1.getInt("r_counter");
			} //while()
			
			//out.println("party_id="+party_id);
			//out.println("counter="+counter);
			
			if(counter==3)
			{
				String main_ledger="Update Ledger Set MainLedger=1 where company_id="+company_id+" and ledger_type=1 and parentCompanyParty_Id="+party_id;
				pstmt_p=conp.prepareStatement(main_ledger);
				int row_updated1 = pstmt_p.executeUpdate();
				pstmt_p.close();
				
				//Insert other ledger for Party
				String  str_query="insert into ledger (ledger_id  ,company_id,for_head,for_headId,ledger_name, ledger_type,description,Modified_By,Modified_On,Modified_MachineName,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,active,YearEnd_Id,closing_Balance,Closing_LocalBalance,Closing_DollarBalance,PartyGroup_Id,Interest,ParentCompanyParty_Id,MainLedger) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				ledger_id+=1;
				pstmt_p=conp.prepareStatement(str_query);
				pstmt_p.setString(1,""+(ledger_id));
				pstmt_p.setString(2,""+company_id);
				pstmt_p.setString(3,""+for_head);
				pstmt_p.setString(4,""+for_head_id);
				pstmt_p.setString(5,""+other_ledger_name);
				pstmt_p.setString(6,""+ledger_type);
				pstmt_p.setString(7,"Description");
				pstmt_p.setString(8,"5");
				pstmt_p.setDate(9,D1);
				pstmt_p.setString(10,"127.0.0.1");
				pstmt_p.setDouble(11,0);
				pstmt_p.setDouble(12,0);
				pstmt_p.setDouble(13,0);
				pstmt_p.setDouble(14,43.00);
				pstmt_p.setBoolean(15,true);
				pstmt_p.setString(16,"6");
				pstmt_p.setDouble(17,0);
				pstmt_p.setDouble(18,0);
				pstmt_p.setDouble(19,0);
				pstmt_p.setString(20,"0");
				pstmt_p.setDouble(21,0);
				pstmt_p.setString(22,party_id);
				pstmt_p.setBoolean(23,false);
				errLine="100";
				int row_updated = pstmt_p.executeUpdate();	
				errLine="102";
				pstmt_p.close();
			}
		} //while()
		pstmt_g.close();
	
		C.returnConnection(conp);
		C.returnConnection(cong);
	out.println("System Run Completed....<br>");
	} //try
	catch(Exception e)
	{
		C.returnConnection(conp);
		C.returnConnection(cong);
		out.print("<br> Exception 42 : "+e+"errLine="+errLine );
	} //catch
} //if(command.equals("Samyak"))
else
{%>
	
	<h2> Invalid Parameter </h2>
<%}%>
		</body>
	</html> 