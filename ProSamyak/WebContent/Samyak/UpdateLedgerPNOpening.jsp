<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
//Use it only before yearend
try{
String command=request.getParameter("command");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
if(command.equals("Nippon05")){


// Code for connection start here
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;

try	{
	 cong=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	UpdateLedgerPNOpening.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


/* 	Code for getting Diff Super Companies in MCP
Start    		*/

String query="Select count(*) as counter from Master_CompanyParty where super=1 and company=1";
int count=0;
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
while(rs_g.next())
	{
		count = rs_g.getInt("counter");
	}
out.print("<br>No. of Super companies="+count);
int company_id[] = new int[count];


query="Select * from Master_CompanyParty where super=1 and company=1";
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
int c=0;
while(rs_g.next())
	{
		company_id[c] = rs_g.getInt("companyparty_id");
		c++;
	}
out.print("<br>Got Super company ids");


for(int i=0; i<count; i++)
	{
		query = "Select count(*) as partyCount from Master_CompanyParty where super=0 and company=0 and company_id="+company_id[i];
		
		int partyCount=0;
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		while(rs_g.next())
		{
		partyCount = rs_g.getInt("partyCount");
		}
		out.print("<br>No. parties ="+partyCount+" for Super company="+company_id[i]);

		int party_id[] = new int[partyCount];
		double Opening_PNLocalBalance[] = new double[partyCount];
		double Opening_PNDollarBalance[] = new double[partyCount];
		double Opening_PNExchangeRate[] = new double[partyCount];
		boolean Transaction_Currency[] = new boolean[partyCount];




		query = "Select * from Master_CompanyParty where super=0 and company=0 and PN=1 and company_id="+company_id[i];
		c=0;
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		while(rs_g.next())
		{
		party_id[c] = rs_g.getInt("companyparty_id");
		Opening_PNLocalBalance[c] = rs_g.getDouble("Opening_PNLocalBalance");
		Opening_PNDollarBalance[c] = rs_g.getDouble("Opening_PNDollarBalance");
		Opening_PNExchangeRate[c] = rs_g.getDouble("Opening_PNExchangeRate");
		Transaction_Currency[c] = rs_g.getBoolean("Transaction_Currency");
		c++;
		}

		out.print("<br>No. parties ="+partyCount+" for Super company="+company_id[i]);
		out.print("<br>Updating there Ledgers");

		for(int j=0; j<partyCount; j++)
		{
			double Opening_Balance=0;
			
			if(Transaction_Currency[j])
			{
				Opening_Balance = Opening_PNLocalBalance[j];
			}
			else
			{
				Opening_Balance = Opening_PNDollarBalance[j];
			}
			
			query = "Update Ledger set Opening_Balance=?, Opening_LocalBalance=?, Opening_DollarBalance=?, Exchange_Rate=? where For_Head=14 and Ledger_Type=3 and For_HeadId="+party_id[j];
			
			pstmt_g=cong.prepareStatement(query);
			pstmt_g.setString(1, ""+Opening_Balance);
			pstmt_g.setString(2, ""+Opening_PNLocalBalance[j]);
			pstmt_g.setString(3, ""+Opening_PNDollarBalance[j]);
			pstmt_g.setString(4, ""+Opening_PNExchangeRate[j]);
			int a = pstmt_g.executeUpdate();
		
		}
		
		out.print("<br>Ledgers Updated <br>");




	}



C.returnConnection(cong);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : UpdateLedgerPNOpening.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
