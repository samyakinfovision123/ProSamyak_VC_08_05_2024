<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<%

Connection conp=null;
Connection cong=null;
Connection conq=null;
//Connection conm=null;

ResultSet rs_g= null;
ResultSet rs_p= null;
ResultSet rs_q=null;
//ResultSet rs_m=null;

PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_q=null;
//PreparedStatement pstmt_m=null;

String query="";
String company_id= request.getParameter("company_id");

try	
{
	cong=C.getConnection();
	conp=C.getConnection();
	conq=C.getConnection();
	//conm=C.getConnection();
}
catch(Exception e)
{ 
 out.println("Error : "+ e);
}
%>
<html>
<head><title>Trial Balance Report</title></head>
<body> 
<table border=1 align=center>
<tr>
<th colspan=2>&nbsp;</th>
<th>Sr.No</th>
<th>Voucher No.</th>
<th>Voucher Date</th>
<th>Voucher Amount</th>
<th>Status</th>
<th>Difference</th>
</tr>
<%
try
{
String Voucher_Id="";
java.sql.Date Voucher_Date=null;
String Voucher_No="";
String Receive_Id="";
String Lot_Id="";
int Voucher_Type=0;
int Reference_Count=0;
int Receive_CurrencyId=0;
int d=0;
int Sr_No=0;
double total_diff=0;

double Voucher_Total=0;


 
query="select Voucher_Id, Voucher_No, Voucher_Type, Voucher_Date, Local_Total from Voucher where  Active=1 and Referance_VoucherId=0 and company_id="+company_id;
pstmt_p=conp.prepareStatement(query);
//pstmt_p.setString(1,company_id);
rs_p=pstmt_p.executeQuery();
 
while(rs_p.next())
{
 
 
 Voucher_Id=rs_p.getString("Voucher_Id");
 Voucher_No=rs_p.getString("Voucher_No");
 Voucher_Type=rs_p.getInt("Voucher_Type");
 Voucher_Date=rs_p.getDate("Voucher_Date");
 Voucher_Total=rs_p.getDouble("Local_Total");

 

 if(Voucher_Type==1 || Voucher_Type==2 || Voucher_Type==3 || Voucher_Type==10 || Voucher_Type==11  )
 {
   	 //Sr_No++;
	 int Receive_Lots=0;
	 double Rate=0;
	 double Quantity=0;
	 double Receive_Total=0;
     double InvTotal=0;
     double tempInvTotal=0;
	 int  ConsignmentReceive_Id=0;
	 
	 
	 //select sum( Quantity * Local_Price )  as RT_InvTotal, sum( R.InvLocalTotal)  as R_InvTotal  from Receive_Transaction RT, Receive R  where RT.Receive_Id=12124 and   R.Receive_Id=12124

	 query="select Receive_Id, Local_Total, InvLocalTotal, Receive_Lots from Receive where Receive_Id=? and Active=true and company_id="+company_id;
 
     pstmt_g=cong.prepareStatement(query);
     pstmt_g.setString(1,Voucher_No);
     rs_g=pstmt_g.executeQuery();
     //out.print("<br>104");
     while(rs_g.next())
     {
       Receive_Id=rs_g.getString("Receive_Id");
	   Receive_Total=rs_g.getDouble("Local_Total");
       InvTotal=rs_g.getDouble("InvLocalTotal");
	   Receive_Lots=rs_g.getInt("Receive_Lots");
       //out.print("<br>104 Receive_Lots"+Receive_Lots);
      if(Receive_Lots>0)
	  {
	  query="select Lot_Id, Quantity, Local_Price, Consignment_ReceiveId from Receive_Transaction where Active=1 and Receive_Id=?";

	  pstmt_q=conq.prepareStatement(query);
	  pstmt_q.setString(1,Receive_Id);
	  rs_q=pstmt_q.executeQuery();
      //out.print("<br>119 Receive_Id "+Receive_Id);
	  while(rs_q.next())
	  {
		  Lot_Id=rs_q.getString("Lot_Id");
          //tempInvTotal=rs_q.getDouble("Local_Price");
		  ConsignmentReceive_Id=rs_q.getInt("Consignment_ReceiveId");
		  Quantity=rs_q.getDouble("Quantity");
          Rate=rs_q.getDouble("Local_Price");

		  if(ConsignmentReceive_Id>0 && Voucher_Type==11)//sale return
	      {
		    Rate=Double.parseDouble(A.getNameCondition(cong,"Receive_Transaction","Local_Price"," where ReceiveTransaction_Id="+ConsignmentReceive_Id+" and   Lot_Id="+Lot_Id+" and Active=true"));
          }

		  tempInvTotal+=(Quantity* Rate);
		 tempInvTotal=Math.round(tempInvTotal);
	  
	  }
	  pstmt_q.close();

		 InvTotal=Math.round(InvTotal);
      
	  //double diff=Math.abs(str.mathformat(tempInvTotal-InvTotal,0));
	  double diff=(str.mathformat(tempInvTotal-InvTotal,0));
       total_diff=total_diff+diff;

       if(diff>0)
	   { %>
	   <tr>
		 <td align=right>RT:<%=tempInvTotal%></td>
		 <td align=right>Inv:<%=InvTotal%></td>
		 <td align=right><%=++Sr_No%></td>
		 <td><%=Voucher_No%></td>
		 <td><%=format.format(Voucher_Date)%></td>
		 <td align=right><%=Voucher_Total%></td>
		 <td>ReceiveTransaction Total!=InvTotal</td>
		 <td align=right><%=diff%></td>
       </tr>
<%	  }
	  }//if(Receive_Lots>0)
	   
     }
     pstmt_g.close();
     
	 double diff9=Math.abs(Voucher_Total-Receive_Total);

	 if(diff9>1)
	 {%>
       <tr>
		 <td align=right><%=++Sr_No%></td>
		 <td><%=Voucher_No%></td>
		 <td><%=format.format(Voucher_Date)%></td>
		 <td align=right><%=Voucher_Total%></td>
		 <td>Voucher_Total !=Receive_Total</td>
		 <td align=right><%=str.mathformat(diff9,0)%></td>
       </tr>
<%	 }
	 
 }//if Voucher_type=1,2,3,10,11
 else if(Voucher_Type==4 || Voucher_Type==5 || Voucher_Type==6 || Voucher_Type==7)
 {
	 //Sr_No++;
	 boolean Transaction_Type=false;
	 double Amount=0;
	 double FTAmount_DR=0;
	 double FTAmount_CR=0;
  
	 query="select Transaction_Type, Local_Amount from Financial_Transaction where Voucher_Id=? and Active=1 and company_id="+company_id;
     
	 pstmt_g=cong.prepareStatement(query);
     pstmt_g.setString(1,Voucher_Id);
     rs_g=pstmt_g.executeQuery();
       
	 while(rs_g.next())
	 {
        Transaction_Type=rs_g.getBoolean("Transaction_Type");
		//Amount=rs_g.getDouble("Amount");

		if(Transaction_Type) //credit
		 {FTAmount_CR+=str.mathformat(rs_g.getDouble("Local_Amount"),0);}
		else
		 {FTAmount_DR+=str.mathformat(rs_g.getDouble("Local_Amount"),0);}
	 }
	 pstmt_g.close();
	  
	 double diff1=Math.abs(Voucher_Total-FTAmount_CR);
	   
	 if(diff1>1)
	 {%>
       <tr>
		 <td align=right><%=++Sr_No%></td>
		 <td><%=Voucher_No%></td>
		 <td><%=format.format(Voucher_Date)%></td>
		 <td align=right><%=Voucher_Total%></td>
		 <td>Voucher_Total !=FTAmount_CR</td>
		 <td align=right><%=str.mathformat(diff1,0)%></td>
       </tr>
<%	 }

	 double diff2=Math.abs(Voucher_Total -FTAmount_DR);
	 if(diff2>1)
	 {%>
       <tr>
		 <td align=right><%=++Sr_No%></td>
		 <td><%=Voucher_No%></td>
		 <td><%=format.format(Voucher_Date)%></td>
		 <td align=right><%=Voucher_Total%></td>
		 <td>Voucher_Total !=FTAmount_DR</td>
		 <td align=right><%=str.mathformat(diff2,0)%></td>
       </tr>
<%	 }
 }//if Voucher_type=4,5,6,7
 else if(Voucher_Type==8 || Voucher_Type==9 || Voucher_Type==12 || Voucher_Type==13)
 {
	 //Sr_No++;
	 boolean Transaction_Type=false;
	 
	 double FT_DR_Amount=0;
	 double FT_CR_Amount=0;
	 double FTAmount=0;
	 double PDAmount=0;
	 double FTAmount_Total=0;
      
	 query="select count(*) as Reference_Count from Voucher where Referance_VoucherId=? and Active=1 and company_id="+company_id;
  
     pstmt_g=cong.prepareStatement(query);
     pstmt_g.setString(1,Voucher_Id);
     rs_g=pstmt_g.executeQuery();
       
	 while(rs_g.next())
	 { Reference_Count=rs_g.getInt("Reference_Count"); }
     pstmt_g.close();  
	     
	 	 query="select Transaction_Type, Local_Amount from Financial_Transaction where Voucher_Id=? and Active=1 and company_id="+company_id;

		 pstmt_g=cong.prepareStatement(query);
         pstmt_g.setString(1,Voucher_Id);
         rs_g=pstmt_g.executeQuery();
         
	     while(rs_g.next())
	     { 
			 Transaction_Type=rs_g.getBoolean("Transaction_Type");
			 if(Transaction_Type)
			 { 
		FT_CR_Amount=str.mathformat(rs_g.getDouble("Local_Amount"),0); 
             }
			 else
			 {
		FT_DR_Amount=str.mathformat(rs_g.getDouble("Local_Amount"),0);
			 }
			 
		}
         pstmt_g.close(); 	 
             
if(Reference_Count > 0)
	 {  
	     
	     query="select sum( Local_Amount) as PDAmount from Payment_Details where Voucher_Id=? and Active=1 and company_id="+company_id;

		 pstmt_g=cong.prepareStatement(query);
         pstmt_g.setString(1,Voucher_Id);
         rs_g=pstmt_g.executeQuery();

	     while(rs_g.next())
	     { PDAmount=rs_g.getDouble("PDAmount");}
		 pstmt_g.close(); 	
		 
        double diff3=Math.abs(FT_CR_Amount-PDAmount);

		if(diff3>1 && Transaction_Type)
                   {%>
					  <tr>
		              <td align=right><%=++Sr_No%></td>
		              <td><%=Voucher_No%></td>
		              <td><%=format.format(Voucher_Date)%></td>
		              <td align=right><%=Voucher_Total%></td>
			          <td>FT_CR_Amount !=PDAmount</td>
			          <td align=right><%=str.mathformat(diff3,0)%></td>
                      </tr>
                 <%} 
		double diff4=Math.abs(FT_DR_Amount-PDAmount);

		if(diff4>1 && !Transaction_Type)
                   {%>
					  <tr>
		              <td align=right><%=++Sr_No%></td>
		              <td><%=Voucher_No%></td>
		              <td><%=format.format(Voucher_Date)%></td>
		              <td align=right><%=Voucher_Total%></td>
			          <td>FT_DR_Amount !=PDAmount</td>
			          <td align=right><%=str.mathformat(diff4,0)%></td>
                      </tr>
                 <%}
			
	 }//if(Reference_Count > 0)
         double diff5=Math.abs(Voucher_Total-FT_CR_Amount);
         double diff6=Math.abs(Voucher_Total-FT_DR_Amount);

		 if(diff5>1 && diff6>1)
         {%>
          <tr>
		     <td align=right><%=++Sr_No%></td>
		     <td><%=Voucher_No%></td>
		     <td><%=format.format(Voucher_Date)%></td>
		     <td align=right><%=Voucher_Total%></td>
			 <td>Voucher_Total !=FT Amount</td>
			 <td align=right><%=str.mathformat(diff5,0)%></td>
          </tr>
<%	     }
	 

	 if(Voucher_Type==12 || Voucher_Type==13) //PN
	 {
		 double PNAmount=0;
		 //Sr_No++;

		 query="select PN_LocalAmount from PN where RefVoucher_Id=? and Active=1 and company_id="+company_id;

		 pstmt_g=cong.prepareStatement(query);
         pstmt_g.setString(1,Voucher_Id);
         rs_g=pstmt_g.executeQuery();

	     while(rs_g.next())
	     { PNAmount=str.mathformat(rs_g.getDouble("PN_LocalAmount"),0);}
         
		 pstmt_g.close();
         
		 double diff7=Math.abs(Voucher_Total-PNAmount);

		 if(diff7>1)
		 {%>
          <tr>
		     <td align=right><%=++Sr_No%></td>
		     <td><%=Voucher_No%></td>
		     <td><%=format.format(Voucher_Date)%></td>
		     <td align=right><%=Voucher_Total%></td>
			 <td>PNAmount!=Voucher_Total</td>
			 <td align=right><%=str.mathformat(diff7,0)%></td>
          </tr>
<%	     }
	 }

 }//if Voucher_type=8,9,12,13
 
}//while(rs_p.next())
pstmt_p.close();
%>
<tr><td>Diff=</td>
<td><%=total_diff%></td></tr>
</table>
</body>
</html>
<%
C.returnConnection(cong);
C.returnConnection(conp);
C.returnConnection(conq);
//C.returnConnection(conm);
}
catch(Exception e)
{
C.returnConnection(cong);
C.returnConnection(conp);
C.returnConnection(conq);
//C.returnConnection(conm);
out.print("<br> Exception 42 : "+e );
}
%>