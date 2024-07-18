<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"    class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 
try{
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;

String query="";
cong=C.getConnection();

query="Select Voucher_Id from Voucher where Voucher_Type=1 or Voucher_Type=2 or Voucher_Type=9 or Voucher_Type=10 order by Voucher_Id";
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();

while(rs_g.next())
{
 String Voucher_Id="";
String inner_query="";
Voucher_Id=rs_g.getString("Voucher_Id");
//out.print("<br> 30 Voucher_Id "+Voucher_Id);
inner_query="Select count(*) as counter from Financial_Transaction where Voucher_Id="+Voucher_Id+" and (For_Head<>17 and For_HeadId<>1)";
pstmt_p=cong.prepareStatement(inner_query);
rs_p=pstmt_p.executeQuery();
int ToBy=0;
while(rs_p.next())
	{
		ToBy=rs_p.getInt("counter");
	}
pstmt_p.close();
//out.print("<br> 40 ToBy "+ToBy);

inner_query="Update Voucher set ToBy_Nos="+ToBy+" where Voucher_Id="+Voucher_Id+"";
pstmt_p=cong.prepareStatement(inner_query);
int a43=pstmt_p.executeUpdate();
//out.print("<br> a43 "+a43);

pstmt_p.close();
}
pstmt_g.close();

C.returnConnection(cong);

out.print("<br>53  Updated Successfully");
}catch(Exception e)  { out.print("<br> Exception 54 "+e); }  
%>






