<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="G" class="NipponBean.GetDate" />

<% 
ResultSet rs_g= null;
ResultSet rs_p= null;

Connection conp = null;
Connection cong = null;

PreparedStatement pstmt_p=null;
PreparedStatement pstmt_g=null;

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

try{
//out.print("<br>16 Here");

String query="";
conp=C.getConnection();
cong=C.getConnection();
int ledgercount=0;
query="select * from Ledger order by Ledger_Id";
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
while(rs_g.next())
	{
		double Opening_DollarBalance=0;
		double Opening_LocalBalance=rs_g.getDouble("Opening_LocalBalance");
//		out.print("<br>37 Opening_LocalBalance "+Opening_LocalBalance);

		double Exchange_Rate=rs_g.getDouble("Exchange_Rate");
//		out.print("<br>37 Exchange_Rate "+Exchange_Rate);
		
		if(Opening_LocalBalance!=0 && Exchange_Rate!=0)
		{
		Opening_DollarBalance=Opening_LocalBalance/Exchange_Rate;
//		out.print("<br>37 Opening_DollarBalance "+Opening_DollarBalance);
		}


		query="Update Ledger set Opening_DollarBalance=?";
		pstmt_p=conp.prepareStatement(query);
		pstmt_p.setDouble(1,Opening_DollarBalance);
		int a19=pstmt_p.executeUpdate();
		pstmt_p.close();
	}
pstmt_g.close();
//out.print("<br>24 Here");
//double sfdd=8787.0233/0;
query="select count(*) as ledgercount from Ledger";
pstmt_p=conp.prepareStatement(query);
rs_g=pstmt_p.executeQuery();

while(rs_g.next())
{
	ledgercount=rs_g.getInt("ledgercount");
}
pstmt_p.close();

//out.print("<br>36 Here");

int Ledger_Id[]=new int[ledgercount];
int Company_Id[]=new int[ledgercount];
int For_Head[]=new int[ledgercount];
int For_HeadId[]=new int[ledgercount];
String Ledger_Name[]=new String[ledgercount];
int Ledger_Type[]=new int[ledgercount];
double Opening_LocalBalance[]=new double[ledgercount];
double Opening_DollarBalance[]=new double[ledgercount];
double Exchange_Rate[]=new double[ledgercount];

query="select * from Ledger order by Ledger_Id";
pstmt_p=conp.prepareStatement(query);
rs_g=pstmt_p.executeQuery();
int i=0;
//out.print("<br>52 Here ledgercount "+ledgercount);

while(rs_g.next())
{
	Ledger_Id[i]=rs_g.getInt("Ledger_Id");
	Company_Id[i]=rs_g.getInt("Company_Id");
	For_Head[i]=rs_g.getInt("For_Head");
	For_HeadId[i]=rs_g.getInt("For_HeadId");
	Ledger_Name[i]=rs_g.getString("Ledger_Name");
	Ledger_Type[i]=rs_g.getInt("Ledger_Type");
	Opening_LocalBalance[i]=rs_g.getDouble("Opening_LocalBalance");
	Opening_DollarBalance[i]=rs_g.getDouble("Opening_DollarBalance");
	Exchange_Rate[i]=rs_g.getDouble("Exchange_Rate");
	i++;
}
pstmt_p.close();

for(int j=0;j<ledgercount;j++)
{
//	out.print("<br>73 "+j);
	if(For_Head[j]==14)
	{
		if(Ledger_Type[j]==1)
		{
			Opening_LocalBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_RLocalBalance","where CompanyParty_Id="+For_HeadId[j]));
			Opening_DollarBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_RDollarBalance","where CompanyParty_Id="+For_HeadId[j]));
		}
		if(Ledger_Type[j]==2)
		{
			Opening_LocalBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_PLocalBalance","where CompanyParty_Id="+For_HeadId[j]));
			Opening_DollarBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_PDollarBalance","where CompanyParty_Id="+For_HeadId[j]));
		}
		if(Ledger_Type[j]==3)
		{
			Opening_LocalBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_PNLocalBalance","where CompanyParty_Id="+For_HeadId[j]));
			Opening_DollarBalance[j]=Double.parseDouble(A.getNameCondition(cong,"Master_CompanyParty","Opening_PNDollarBalance","where CompanyParty_Id="+For_HeadId[j]));
		}
	}
query="Insert into ClosingBalance(ClosingBalance_Id, Company_Id, For_Head, For_HeadId, Ledger_Id, Head_Name, Closing_BalanceLocal, Closing_BalanceDollar, Closing_Date, Modified_On, Modified_By, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?,?)";

pstmt_p=conp.prepareStatement(query);
int ClosingBalance_Id=L.get_master_id(conp,"ClosingBalance");
java.sql.Date Closing_Date=Config.financialYearStart();
//out.print("<br> 97 Closing_Date "+Closing_Date);
String StrClosingDate=G.getDueDate(format.format(Closing_Date),-1);
//out.print("<br> 99 StrClosingDate "+StrClosingDate);

pstmt_p.setString(1,""+ClosingBalance_Id);

pstmt_p.setString(2,""+Company_Id[j]);
pstmt_p.setString(3,""+For_Head[j]);
pstmt_p.setString(4,""+For_HeadId[j]);
pstmt_p.setString(5,""+Ledger_Id[j]);
//out.print("<br> 103 "+Closing_Date);

pstmt_p.setString(6,""+Ledger_Name[j]);
pstmt_p.setString(7,""+Opening_LocalBalance[j]);
pstmt_p.setString(8,""+Opening_DollarBalance[j]);
pstmt_p.setDate(9,format.getDate(StrClosingDate));
//out.print("<br> 110 Closing_Date "+Closing_Date);

pstmt_p.setDate(10,D);
pstmt_p.setString(11,"0");
pstmt_p.setString(12,"Samyak36");
//out.print("<br> 115 Closing_Date "+Closing_Date);

int a124=pstmt_p.executeUpdate();
pstmt_p.close();

}
C.returnConnection(conp);
C.returnConnection(cong);
%>
<html>
	<head>
		<script language=javascript>
			alert("Data Successfully Updated")
			window.close()
		</script>
	</head>
	<body>
	
	</body>
</html>
<%
}catch(Exception e){
C.returnConnection(conp);
C.returnConnection(cong);
	out.print("<br> 111 Exception "+e);}
%>