<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");
String company_id=request.getParameter("company_id");
if(command.equals("Nippon05"))
{
out.print("<br>16 command ="+command);
String query="";
String voucherquery="";


ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
try	{ cong=C.getConnection();}
catch(Exception Samyak31)
{ out.println("<font color=red> FileName : 	InsertDefaultValues.jsp<br>Bug No Samyak31 : "+ Samyak31);}


voucherquery="select count(*) as voucherCount from Voucher where Voucher_Type=1 or Voucher_Type=2 or Voucher_Type=3 or Voucher_Type=10 or Voucher_Type=11 and active=1 and company_id="+company_id;   

pstmt_g = cong.prepareStatement(voucherquery);
//out.println("<BR>"+company_query);
rs_g = pstmt_g.executeQuery();
out.print("<br>48 voucherquery="+voucherquery);
int voucherCount=0;
while(rs_g.next())
	{
	voucherCount=rs_g.getInt("voucherCount");
	}
pstmt_g.close();

out.print("<br>54 voucherCount="+voucherCount);

int voucher_id[]=new int[voucherCount];
int voucher_no_int[]=new int[voucherCount];
String voucher_no[]=new String[voucherCount];

java.sql.Date voucher_datev1[] =new java.sql.Date[voucherCount];
voucherquery="select Voucher_Id,Voucher_Date,Voucher_No from Voucher where Voucher_Type=1 or Voucher_Type=2 or Voucher_Type=3 or Voucher_Type=10 or Voucher_Type=11 and active=1 and company_id="+company_id;   
pstmt_g = cong.prepareStatement(voucherquery);

rs_g=pstmt_g.executeQuery();
int k=0;
while(rs_g.next())
{
	voucher_datev1[k]=rs_g.getDate("Voucher_Date");
	voucher_id[k]=rs_g.getInt("Voucher_Id");
	voucher_no[k]=rs_g.getString("Voucher_No");
	voucher_no_int[k]=Integer.parseInt(voucher_no[k]);
	k++;
}

out.print("<br> Got Voucher numbers");

for(int i=0; i<voucherCount; i++)
	{
		String query1 = "Select * from Receive as R, Voucher as V where R.active=1 and V.active=1 and R.Receive_Date <> V.Voucher_Date and R.Receive_Id="+voucher_no_int[i]+" and V.Voucher_No = ? and V.company_id="+company_id;
		pstmt_g = cong.prepareStatement(query1);
		pstmt_g.setString(1, voucher_no[i]);
		//out.print("<br>query1 : "+query1);
		rs_g=pstmt_g.executeQuery();
	
		while(rs_g.next())
		{
			out.print("<br> Receive_Id:"+rs_g.getString("Receive_Id"));
			out.print("&nbsp;&nbsp;&nbsp;Voucher_No:"+rs_g.getString("VOucher_No"));
			out.print("&nbsp;&nbsp;&nbsp; Voucher_Date:"+rs_g.getString("Voucher_Date"));
			out.print("&nbsp;&nbsp;&nbsp; Receive_Date:"+rs_g.getString("Receive_Date"));
		}


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
  //C.returnConnection(cong);
  out.println("<font color=red> FileName : UpdateReceiveDate.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 
%>
