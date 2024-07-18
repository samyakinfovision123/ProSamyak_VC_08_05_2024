<!--   http://samyak2:8080/Nippon/Samyak/LedgerToMCP.jsp?command=Samyak06&company_id=5-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />
<jsp:useBean id="YED"   class="NipponBean.YearEndDate" />
<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
String errLine="18";
try{
String machine_name=request.getRemoteHost();
String user_id= "1";

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
out.print("<br> 23 D"+D);
String today_string= format.format(D);
out.print("<br> 25 today_string"+today_string);
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
out.print("<br> 24 command="+command);



if(command.equals("Samyak06"))
{
errLine="32";
cong=C.getConnection();
int counter=0;
String ledgerQuery="select count(*) as counter from Ledger where For_Head<>14 and Company_id="+company_id+" AND (ParentCompanyParty_Id=0 or ISNULL(ParentCompanyParty_Id,100)=100)";

errLine="27";
pstmt_g = cong.prepareStatement(ledgerQuery);
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
	counter=rs_g.getInt("counter");
}
pstmt_g.close();

out.print("<br> 46 counter ="+counter);
int ledger_id[]=new int[counter];
String ledgerName[]=new String[counter];


ledgerQuery="select Ledger_Id,Ledger_Name from Ledger where For_Head<>14 and Company_id="+company_id+" AND (ParentCompanyParty_Id=0 or ISNULL(ParentCompanyParty_Id,100)=100)";
pstmt_g = cong.prepareStatement(ledgerQuery);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
int k=0;
while(rs_g.next())
{
	ledger_id[k]=rs_g.getInt("Ledger_Id");
	ledgerName[k]=rs_g.getString("Ledger_Name");
	k++;
}
pstmt_g.close();

errLine="65";


int companyparty_id= Integer.parseInt(""+L.get_master_id(cong,"Master_companyparty"));
int newledger_id= Integer.parseInt(""+L.get_master_id(cong,"Ledger"));
int SalePerson_Id =Integer.parseInt(""+A.getNameCondition(cong,"Master_SalesPerson","SalesPerson_Id","where purchaseSale=0 and active=1 and company_Id="+company_id));
out.println("<BR> 70 SalePerson_Id="+SalePerson_Id);
int yearEnd_Id =Integer.parseInt(""+A.getNameCondition(cong,"YearEnd","YearEnd_Id","where active=1 and company_Id="+company_id));
out.println("<BR> 70 yearEnd_Id="+yearEnd_Id);
java.sql.Date openingDate = YED.getDate(cong,"YearEnd","From_Date","where YearEnd_Id="+yearEnd_Id);

out.print("<br> 77 openingDate"+openingDate);
int salespartygroup_id =Integer.parseInt(""+A.getNameCondition(cong,"Master_PartyGroup","partygroup_id","where Group_Type=0 and Active=1 and company_id="+company_id));
out.print("<br> 77 salespartygroup_id ="+salespartygroup_id);

int purchasepartygroup_id =Integer.parseInt(""+A.getNameCondition(cong,"Master_PartyGroup","partygroup_id","where Group_Type=1 and Active=1 and company_id="+company_id));
out.print("<br> 77 purchasepartygroup_id ="+purchasepartygroup_id);
String  exchangeRate=I.getLocalExchangeRate(cong,company_id);
out.print("86 exchangeRate"+exchangeRate);

errLine="81";
for(int i=0;i<counter;i++)
{
out.print("<br>76  counter"+i);
errLine="85";
//Opening_RExchangeRate,RExchange_Rate,Opening_PExchangeRate,PExchange_Rate
String mcpQuery="INSERT INTO Master_companyparty (companyparty_Id, companyparty_Name,Company, Company_Id, Active,Opening_Date,Transaction_Currency,Opening_RExchangeRate,RExchange_Rate,Opening_PExchangeRate,PExchange_Rate,Sale,Purchase, PN, Modified_By, Modified_On, Modified_MachineName, SalesPerson_Id,YearEnd_Id)values(?,?,?,?,?,'"+openingDate+"' ,?,?,?,?,?,?,?, ?,?,'"+D+"',?,?,?)";
pstmt_g = cong.prepareStatement(mcpQuery);
pstmt_g.setString (1,""+companyparty_id);
pstmt_g.setString (2,""+ledgerName[i]);
pstmt_g.setString (3,"0");
pstmt_g.setString (4,""+company_id);
pstmt_g.setBoolean(5, true);
pstmt_g.setBoolean(6, true);
pstmt_g.setString (7,exchangeRate);
pstmt_g.setString (8,exchangeRate);
pstmt_g.setString (9,exchangeRate);
pstmt_g.setString (10,exchangeRate);


pstmt_g.setBoolean(11, true);//sale
pstmt_g.setBoolean(12, true);//purchase
pstmt_g.setBoolean(13, false);//pn
pstmt_g.setString (14,"1");
errLine="97";
String temp1="Samyak"+machine_name+":"+today_string;
pstmt_g.setString (15,temp1);
pstmt_g.setString (16,""+SalePerson_Id);
pstmt_g.setString (17,""+yearEnd_Id);
errLine="101";
int a140 = pstmt_g.executeUpdate();
errLine="103";
out.println(" Added Successfully139: " +a140);
pstmt_g.close();

errLine="103";
///Ledger 
//Sale
String query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id) values (?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"', ?,?,?,?  ,?,?,?,?, ?,?)";
//out.print("<BR>90" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.clearParameters();
pstmt_g.setString (1,""+newledger_id);	
pstmt_g.setString (2,company_id);
pstmt_g.setString (3,"14");
pstmt_g.setString (4,""+companyparty_id);
pstmt_g.setString (5,""+ledgerName[i]+" Sales");
pstmt_g.setString (6,"1");
//out.print("<br >4 "+"1");
pstmt_g.setString (7,"1");	//admin
pstmt_g.setString (8,machine_name);
pstmt_g.setBoolean (9,true);
pstmt_g.setString (10,""+yearEnd_Id);
pstmt_g.setDouble (11,0);
pstmt_g.setDouble (12,0);
pstmt_g.setDouble (13,0);
pstmt_g.setString (14,"1");
pstmt_g.setString (15,""+salespartygroup_id);
pstmt_g.setString (16,"0");
pstmt_g.setString (17,""+companyparty_id);
out.print("<br >9 "+machine_name);
int aledger1 = pstmt_g.executeUpdate();
pstmt_g.close();


errLine="133";
//Purchase
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id) values (?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?, ?,?,?)";
//out.print("<BR>90" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.clearParameters();
pstmt_g.setString (1,""+(newledger_id+1));	
pstmt_g.setString (2,company_id);
pstmt_g.setString (3,"14");
pstmt_g.setString (4,""+companyparty_id);
pstmt_g.setString (5,""+ledgerName[i]+" Purchase");
pstmt_g.setString (6,"2");
//out.print("<br >4 "+"1");
pstmt_g.setString (7,"1");	//admin
pstmt_g.setString (8,machine_name);
pstmt_g.setBoolean (9,true);
pstmt_g.setString (10,""+yearEnd_Id);
pstmt_g.setDouble (11,0);
pstmt_g.setDouble (12,0);
pstmt_g.setDouble (13,0);
pstmt_g.setString (14,"1");
pstmt_g.setString (15,""+purchasepartygroup_id);
pstmt_g.setString (16,"0");
pstmt_g.setString (17,""+companyparty_id);
out.print("<br >9 "+machine_name);
int aledger2 = pstmt_g.executeUpdate();
out.print("167 aledger2="+aledger2);
pstmt_g.close();
errLine="160";
//pn
query="Insert into Ledger (Ledger_Id, Company_Id, For_Head, For_headId, Ledger_Name, Ledger_Type, Modified_By, Modified_On, Modified_MachineName,Active,YearEnd_Id,Opening_Balance,Opening_LocalBalance,Opening_DollarBalance,Exchange_Rate,PartyGroup_id,Interest,ParentCompanyParty_Id) values (?,?,?,?, ?,?,?, '"+format.getDate(today_string)+"',?,?,?,? ,?,?,?, ?,?,?)";
//out.print("<BR>90" +query);
pstmt_g = cong.prepareStatement(query);
pstmt_g.clearParameters();
pstmt_g.setString (1,""+(newledger_id+2));	
pstmt_g.setString (2,company_id);
pstmt_g.setString (3,"14");
pstmt_g.setString (4,""+companyparty_id);
pstmt_g.setString (5,""+ledgerName[i]+" PN");
pstmt_g.setString (6,"3");
//out.print("<br >4 "+"1");
pstmt_g.setString (7,"1");	//admin
pstmt_g.setString (8,machine_name);
pstmt_g.setBoolean (9,false);
pstmt_g.setString (10,""+yearEnd_Id);
pstmt_g.setDouble (11,0);
pstmt_g.setDouble (12,0);
pstmt_g.setDouble (13,0);
pstmt_g.setString (14,"1");
pstmt_g.setString (15,""+purchasepartygroup_id);
pstmt_g.setString (16,"0");
pstmt_g.setString (17,""+companyparty_id);

out.print("<br >9 "+machine_name);
int aledger3 = pstmt_g.executeUpdate();
pstmt_g.close();
errLine="188";

//LEdger
query="Update Ledger  set ParentCompanyParty_Id=?, MainLedger=?,    Modified_MachineName=? where Ledger_Id=?";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString (1,""+companyparty_id);		
	pstmt_g.setBoolean (2,true);
	pstmt_g.setString (3,machine_name);
	pstmt_g.setString (4,""+ledger_id[i]);		
	int a196 = pstmt_g.executeUpdate();
	pstmt_g.close();
///Ledger
companyparty_id=companyparty_id+1;
newledger_id=newledger_id+3;
}


errLine="204";
out.println("<h1> System Run Completed </h1>");
cong.commit();
}//if
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	C.returnConnection(cong);
	out.println("<br><font color=red> FileName : LedgerToMCP.jsp<br>Bug No Samyak160 : "+ Samyak160+"errLine="+errLine);}
%>











