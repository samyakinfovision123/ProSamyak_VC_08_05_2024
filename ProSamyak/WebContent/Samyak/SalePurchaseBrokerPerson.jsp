<!--   http://samyak2:8080/Nippon/Samyak/SalePurchaseBrokerPerson.jsp -->

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

try{


cong=C.getConnection();
int total_pur_person=0;
String str_total_person="select count(*) as total_pur_person from Master_SalesPerson where purchaseSale=1 and company_id in (1,2,3,4)";

errLine="27";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
	total_pur_person=rs_g.getInt("total_pur_person");
}
pstmt_g.close();

if(total_pur_person>5)
{
	out.println("<h1> System Run Allready executed </h1>");
}
else
{

 str_total_person="select count(*) as total_person from Master_SalesPerson";

errLine="27";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
int total_person=0;
while(rs_g.next()) 	
{
	total_person=rs_g.getInt("total_person");
}
out.println("total_person ="+total_person);
pstmt_g.close();

errLine="38";
str_total_person="SELECT     count(*) as counter FROM         Master_SalesPerson WHERE (Company_id IN (1, 2, 3, 4))";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
	counter=rs_g.getInt("counter");
}
out.println("counter ="+counter);
pstmt_g.close();

errLine="50";
String company_id_array[]=new String[counter];
String person_name_array[]=new String[counter];
String year_end_array[]=new String[counter];

str_total_person="SELECT company_id,salesperson_Name,yearend_id FROM  Master_SalesPerson WHERE (Company_id IN (1, 2, 3, 4))";
pstmt_g = cong.prepareStatement(str_total_person);
rs_g = pstmt_g.executeQuery();
counter=0;
while(rs_g.next()) 	
{
	company_id_array[counter]=rs_g.getString("company_id");
	person_name_array[counter]=rs_g.getString("salesperson_Name");
	year_end_array[counter]=rs_g.getString("yearend_id");
	counter++;
}
pstmt_g.close();
errLine="66";
cong.setAutoCommit(false);
for(int i=0;i<company_id_array.length;i++)
{
	total_person++;
	

String insert_person="Insert into Master_SalesPerson(SalesPerson_Id,Company_id,SalesPerson_Name,Modified_On,Modified_By,Modified_MachineName,Active,Sr_No,YearEnd_Id,PurchaseSale) values (?,?,?,"+D+",?,?,?,?,?,?)";
	pstmt_g = cong.prepareStatement(insert_person);
	pstmt_g.setString(1,""+total_person);
	out.println("total_person="+total_person);
	pstmt_g.setString(2,""+company_id_array[i]);
	out.println("company_id_array[i]="+company_id_array[i]);
	pstmt_g.setString(3,""+person_name_array[i]);
	out.println("person_name_array[i]="+person_name_array[i]);
	pstmt_g.setString(4,""+user_id);
	out.println("user_id="+user_id);
	pstmt_g.setString(5,""+machine_name);
	out.println("machine_name="+machine_name);
	pstmt_g.setString(6,"1");
	pstmt_g.setString(7,""+total_person);
	out.println("total_person="+total_person);
	pstmt_g.setString(8,""+year_end_array[i]);
	out.println("year_end_array[i]="+year_end_array[i]);
	pstmt_g.setString(9,"1");
	errLine="82";
	int row_updated=pstmt_g.executeUpdate();
	out.println("<br>");
	pstmt_g.close();
	errLine="84";
}
for(int i=0;i<company_id_array.length;i++)
{
	total_person++;
	String insert_person="Insert into Master_SalesPerson(SalesPerson_Id,Company_id,SalesPerson_Name,Modified_On,Modified_By,Modified_MachineName,Active,Sr_No,YearEnd_Id,PurchaseSale) values(?,?,?,"+D+",?,?,?,?,?,?)";
	pstmt_g = cong.prepareStatement(insert_person);
	pstmt_g.setString(1,""+total_person);
	pstmt_g.setString(2,""+company_id_array[i]);
	pstmt_g.setString(3,""+person_name_array[i]);
	
	pstmt_g.setString(4,""+user_id);
	pstmt_g.setString(5,""+machine_name);
	pstmt_g.setString(6,"1");
	pstmt_g.setString(7,""+total_person);
	pstmt_g.setString(8,""+year_end_array[i]);
	pstmt_g.setString(9,"2");
	int row_updated=pstmt_g.executeUpdate();
	pstmt_g.close();
}

out.println("<h1> System Run Completed </h1>");
cong.commit();
}
C.returnConnection(cong);
}catch(Exception Samyak160){ 
	C.returnConnection(cong);
	out.println("<br><font color=red> FileName : SalePurchaseBrokerPerson.jsp<br>Bug No Samyak160 : "+ Samyak160+"errLine="+errLine);}
%>











