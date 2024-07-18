
<!-- 
This file is used for the seeing the records of confirm sale invoices 
having different company names other than Consignment sale invoices
-->

<!-- 

Keys for execution

Samyak/Nippon/Samyak/ConsignmentSystemRun.jsp?command=Nippon05

-->

<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{

String command=request.getParameter("command");

if(command.equals("Nippon05")){
	
	
	
	ResultSet rs_g= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
	     
		 
		 }
	catch(Exception Samyak31)
		{ 
	out.println("<font color=red> FileName:ConsignmentSystem .jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 0;
       
       
	   //String first_query="";
	   String query="";
     //double  recordcount=0;

//out.print("<br>69 Samyak");

	  
////
int total_count_record;
query="select count(*) as totalcount from FROM Receive AS main, Receive AS sec, Master_CompanyParty AS mpmain, Master_CompanyParty AS mpsec WHERE sec.Receive_Sell=False And sec.Purchase=True And main.Purchase=False And main.Receive_Sell=False And main.Receive_Id=sec.Consignment_ReceiveId And main.Receive_FromId<>sec.Receive_FromId And main.Opening_Stock=False And sec.Opening_Stock=False And sec.Return=False And sec.Return=False And sec.Consignment_ReceiveId>0 And sec.Cgt_ReturnConfirm>0 And sec.Active=False And sec.Cgt_ReturnConfirm>0 and main.Receive_FromId=mpmain.CompanyParty_Id and sec.Receive_FromId=mpsec.CompanyParty_Id";
pstmt_g=cong.prepareStatement(query);

rs_g=pstmt_g.executeQuery();
	
	while(rs_g.next()) 	

	{
total_count_record=rs_g.getInt("totalcount");

    }
int count=total_count_record;
	out.print("<br>75 total_count_record="+total_count_record);
	
	
for(int i=0;i<count;i++)
	{


query="SELECT main.Receive_Id as MRID,main.Receive_No AS MRNO, main.Receive_Date AS MRDate, mpmain.CompanyParty_Name AS MCompanyParty_Name, sec.Receive_Id as SRID, sec.Receive_No AS SReceive_No, sec.Receive_Date AS  SReceive_Date,mpsec.CompanyParty_Name AS SCompanyParty_Name,main.Receive_FromId as MReceive_fromid,sec.Receive_FromId as SReceive_fromid FROM Receive AS main, Receive AS sec, Master_CompanyParty AS mpmain, Master_CompanyParty AS mpsec WHERE sec.Receive_Sell=False And sec.Purchase=True And main.Purchase=False And main.Receive_Sell=False And main.Receive_Id=sec.Consignment_ReceiveId And main.Receive_FromId<>sec.Receive_FromId And main.Opening_Stock=False And sec.Opening_Stock=False And sec.Return=False And sec.Return=False And sec.Consignment_ReceiveId>0 And sec.Cgt_ReturnConfirm>0 And sec.Active=False And sec.Cgt_ReturnConfirm>0 and main.Receive_FromId=mpmain.CompanyParty_Id and sec.Receive_FromId=mpsec.CompanyParty_Id";

pstmt_g=cong.prepareStatement(query);

rs_g=pstmt_g.executeQuery();
	
	while(rs_g.next()) 	

	{
		   int main_receive_id=rs_g.getInt("MRID");
		   
		   String main_receive_no=rs_g.getString("MRNO");
		   
		   java.sql.Date main_receive_date=rs_g.getDate("MRDate"));

           String main_company_partname=rs_g.getString("MCompanyParty_Name");
               
         
		int sec_receive_id=rs_g.getInt("SRID");

		String sec_receive_no=rs_g.getString("SReceive_No");


  java.sql.Date sec_receive_date=rs_g.getDate("SReceive_Date"));

 String sec_company_partname=rs_g.getString("SCompanyParty_Name")





			   int main_receivefrom_id=rs_g.getInt("MReceive_fromid");

		   
		   int sec_receivefrom_id=rs_g.getInt("SReceive_fromid");
		   
		   
		   String toby_nos=rs_g.getString("ToBy_Nos");
		   int toby_nos_int=Integer.parseInt(toby_nos);
		   //out.print("<br>");
		   String ftactive=rs_g.getString("FTActiveQty");
		   int ftactive_int=Integer.parseInt(ftactive);
     
	   if((toby_nos_int!=(ftactive_int-1))  )
			{
         //out.print("<br>67 toby_nos_int="+toby_nos_int);
         //out.print("<br>68 ftactive_int="+ftactive_int);

			 update_query="Update Payment_Details set Active=0 where Voucher_Id="+voucher_id;
			 pstmt_g = cong.prepareStatement(update_query);
			 tempx = pstmt_g.executeUpdate();
			 out.print("Data Successfully Updated ! ");
		
		    }
	
	 }







































query="Update Receive_Transaction RT1,Receive_Transaction RT2 set RT1.Available_Quantity=(RT1.Available_Quantity+RT2.Available_Quantity) where RT1.ReceiveTransaction_Id=RT2.Consignment_ReceiveId and RT2.Active=0  and RT1.Consignment_ReceiveId=0";
out.print("<br>a601 b4 ");
            //pstmt_g=conp.prepareStatement();
			pstmt_g = conp.prepareStatement(query);
			int a601=pstmt_g.executeUpdate();
			//out.print("<br>77a601 "+a601);
			pstmt_g.close();

    out.print("<font color=red>Data Successfully Updated</font>");
}	  
}catch(Exception e)
  {
	out.print("<br>79 The error in file ConsignmentSystemRun.jsp"+e);
  }
%>