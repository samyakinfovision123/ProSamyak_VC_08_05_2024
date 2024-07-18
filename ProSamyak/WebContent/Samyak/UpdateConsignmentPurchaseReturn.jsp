
<!-- http://samyak2:8080/Nippon/Samyak/UpdateConsignmentPurchaseReturn.jsp?company_id=2   -->
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;

String machine_name=request.getRemoteHost();
String user_id= "1";
String errLine="18";
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String company_id=request.getParameter("company_id");
try{


cong=C.getConnection();
String str_total_person="select count(*) as total_person from Master_SalesPerson where purchaseSale=0 and company_id="+company_id;

errLine="27";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
int total_person=0;
while(rs_g.next()) 	
{
	total_person=rs_g.getInt("total_person");
}
out.println("35 total_person ="+total_person);
pstmt_g.close();

errLine="38";
/*str_total_person="SELECT     count(*) as counter FROM         Master_SalesPerson WHERE (Company_id IN (1, 2, 3, 4))";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
	counter=rs_g.getInt("counter");
}
out.println("counter ="+counter);
pstmt_g.close();*/

errLine="50";
String company_id_array[]=new String[total_person];
String person_name_array[]=new String[total_person];
String person_id[]=new String[total_person];

str_total_person="select SalesPerson_Id, Company_id, SalesPerson_Name   from Master_SalesPerson where purchaseSale=0  and company_id="+company_id;
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
	person_id[counter]=rs_g.getString("SalesPerson_Id");
	company_id_array[counter]=rs_g.getString("company_id");
	person_name_array[counter]=rs_g.getString("salesperson_Name");
	
	counter++;
}
pstmt_g.close();
errLine="66";
out.println("69 Length="+person_id.length);
cong.setAutoCommit(false);
String purchase_person_id="";
for(int i=0;i<person_id.length;i++)
{
	errLine="73";
	String insert_person="Select SalesPerson_Id from Master_SalesPerson where salesPerson_Name='"+person_name_array[i]+"' and purchaseSale=1 and company_id="+company_id;
	pstmt_g = cong.prepareStatement(insert_person);
	rs_g = pstmt_g.executeQuery();
	while(rs_g.next()) 	
	{
			purchase_person_id=rs_g.getString("SalesPerson_Id");	
	}
	out.println("<br> purchase_person_id="+purchase_person_id);
	pstmt_g.close();
	errLine="83";
	insert_person="Update Receive set salesPerson_Id=? WHERE     (Company_Id = "+company_id+") AND (Receive_Sell = 0) AND (StockTransfer_Type = 0) AND (Active = 1) and (Purchase=0) AND (R_Return = 1) AND (Opening_Stock = 0)   and salesPerson_Id="+person_id[i];
	pstmt_g = cong.prepareStatement(insert_person);
	pstmt_g.setString(1,""+purchase_person_id);
	
	int row_updated=pstmt_g.executeUpdate();
	out.println("<br>row_updated="+row_updated);
	pstmt_g.close();
	errLine="84";
	out.println("salesPerson_Id="+person_id[i]);
}

out.println("<h1> System Run Completed </h1>");
cong.commit();
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	C.returnConnection(cong);
	out.println("<br><font color=red> FileName : SalePurchaseBrokerPerson.jsp<br>Bug No Samyak160 : "+ Samyak160+"errLine="+errLine);}
%>











