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
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
	cong=C.getConnection();
	conp=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}

try{
int current_id=0; 
int total_rows=0;

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String query="Select Lot_Id, Company_Id, Yearend_Id from Lot order by Lot_Id";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();

while(rs_g.next()) 	
{
	long Lot_Id=rs_g.getLong("Lot_Id");
	long Company_Id=rs_g.getLong("Company_Id");
	long Yearend_Id=rs_g.getLong("Yearend_Id");

	String subQuery = "Insert into Effective_Rate (EffectiveRate_Id, Lot_Id, Company_Id, Effective_Date, Selling_Price, Purchase_Price, YearEnd_Id) VALUES ("+Lot_Id+", "+Lot_Id+", "+Company_Id+", ?, "+Lot_Id+", "+Lot_Id+", "+Yearend_Id+")";

	pstmt_p = conp.prepareStatement(subQuery);
	pstmt_p.setString(1, ""+D);
	pstmt_p.executeUpdate();
	pstmt_p.close();

}//while
//out.println("<br>761245counter"+counter);
pstmt_g.close();

out.println("<br>Samyak System Run 100% successfull");
%>


<%

C.returnConnection(cong);
C.returnConnection(conp);
}catch(Exception Samyak160){ 
	C.returnConnection(cong);
	C.returnConnection(conp);
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











