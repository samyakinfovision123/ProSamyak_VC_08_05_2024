
<%//URL Path = Samyak/CancelPurchaseReturn_SystemRun.jsp?command=Update&receive_id=&company_id=
%>

<%@ page language="java"          									import="java.io.*,java.sql.*,java.util.*,NipponBean.*" 			errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   							class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<%

ResultSet rs_g = null;
ResultSet rs_p = null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g = null;
PreparedStatement pstmt_p = null;

int errLine = 19;

try	
{
	cong = C.getConnection();
	conp = C.getConnection();

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	String command = request.getParameter("command");	
	String receive_id = request.getParameter("receive_id");	
	String company_id = request.getParameter("company_id");	
	String machine_name = "Samyak_"+D;

	if("Update".equals(command))
	{
		String query = "";
				
		query="Select * from Receive where receive_id=? and  purchase=1 and receive_sell=0 and Consignment_ReceiveId<>0 and r_Return=1 and company_id=?";
		
		pstmt_g = cong.prepareStatement(query);
		
		pstmt_g.setString(1,receive_id);
		pstmt_g.setString(2,company_id);
		
		rs_g = pstmt_g.executeQuery();

		String companyparty_id = "";
		String Challan_No = "";
		
		double InvLocalTotal=0;
		double InvDollarTotal=0;
		
		while(rs_g.next())
		{
			companyparty_id = rs_g.getString("Receive_FromId");
			InvLocalTotal = rs_g.getDouble("InvLocalTotal");
			InvDollarTotal = rs_g.getDouble("InvDollarTotal");
			Challan_No = rs_g.getString("Challan_No");
		}
		pstmt_g.close();

		query = "Select count(*) as lot_count from Receive_Transaction where  receive_id=?";

		pstmt_g = cong.prepareStatement(query);
		
		pstmt_g.setString(1,receive_id);
		
		rs_g = pstmt_g.executeQuery();	

		int lot_count = 0;

		while(rs_g.next())
		{
			lot_count = rs_g.getInt("lot_count");
		}
		pstmt_g.close();
		
		String Lot_Id[]=new String[lot_count];
		String Location_Id[]=new String[lot_count];
		String R_Id[]=new String[lot_count];
		String RT_Id[]=new String[lot_count];
		double Quantity[]=new double[lot_count];
		
		query="Select * from Receive_Transaction where  receive_id=?";
		
		pstmt_g = cong.prepareStatement(query);
		
		pstmt_g.setString(1,receive_id);

		rs_g = pstmt_g.executeQuery();

		lot_count = 0;

		while(rs_g.next())
		{
			R_Id[lot_count]=rs_g.getString("Receive_Id");
			RT_Id[lot_count]=rs_g.getString("ReceiveTransaction_Id");
			Lot_Id[lot_count]=rs_g.getString("Lot_Id");
			Location_Id[lot_count]=rs_g.getString("Location_Id");
			Quantity[lot_count]=rs_g.getDouble("Quantity");
			
			lot_count++;
		}
		pstmt_g.close();

		query = "update Master_CompanyParty set Purchase_AdvanceLocal=Purchase_AdvanceLocal-?,Purchase_AdvanceDollar=Purchase_AdvanceDollar-? where CompanyParty_Id=?";
		
		pstmt_p = conp.prepareStatement(query);
errLine = 108;
		pstmt_p.setString (1, ""+InvLocalTotal);
		pstmt_p.setString (2, ""+InvDollarTotal);
		pstmt_p.setString (3, companyparty_id);
		
		int a100 = pstmt_p.executeUpdate();
		
		pstmt_p.close();

		for(int i=0; i<lot_count; i++)
		{
			String temp_receiveid = A.getNameCondition(conp,"Receive_Transaction","Consignment_ReceiveId","where ReceiveTransaction_Id="+RT_Id[i]);
			
			String returnquery = "select * from Receive_Transaction where ReceiveTransaction_Id="+temp_receiveid;
			
			pstmt_g = cong.prepareStatement(returnquery);
			
			rs_g = pstmt_g.executeQuery();
			
			String lot_id = "";
			String ReceiveTransaction_Id = "";

			double Return_Quantity = 0;
					
			while(rs_g.next())
			{
				lot_id = rs_g.getString("Lot_Id");
				Return_Quantity = rs_g.getDouble("Return_Quantity");
				ReceiveTransaction_Id = rs_g.getString("ReceiveTransaction_Id");
		
				if(Lot_Id[i].equals(lot_id))
				{
					Return_Quantity = Return_Quantity - Quantity[i];
					
					String updatequery = "Update Receive_Transaction set Return_Quantity=? where ReceiveTransaction_Id="+ReceiveTransaction_Id;
					
					pstmt_p = conp.prepareStatement(updatequery);

					pstmt_p.setDouble(1,Return_Quantity);

					int a135 = pstmt_p.executeUpdate();

					pstmt_p.close();

				}//end if Lot_Id = lot_id

			}//end while rs_g
			pstmt_g.close();

		}//end for i
errLine = 158;
		for(int i=0; i<lot_count; i++)
		{
			String today_string = format.format(D);

			query="Select * from  LotLocation where Lot_Id=? and Location_id=? and company_id=? and Active=1";
			
			pstmt_g = cong.prepareStatement(query);
			
			pstmt_g.setString(1,Lot_Id[i]); 
			pstmt_g.setString(2,Location_Id[i]); 
			pstmt_g.setString(3,company_id); 
			
			rs_g = pstmt_g.executeQuery();
			
			double fincarats = 0;
			double phycarats = 0;
			
			int p = 0;

			while(rs_g.next()) 	
			{
				fincarats = rs_g.getDouble("Carats");	
				phycarats = rs_g.getDouble("Available_Carats");	
				
				p++;
			}
			pstmt_g.close();
					
			fincarats = fincarats + Quantity[i];
			phycarats = phycarats + Quantity[i];
			
			query = "Update LotLocation  set Carats=?, Available_Carats=?,   Modified_On='"+D+"', Modified_MachineName=? where Lot_Id=? and Location_id=? and company_id=?";
errLine = 191;
			pstmt_p = conp.prepareStatement(query);

			pstmt_p.setDouble(1,fincarats); 
			pstmt_p.setDouble(2,phycarats); 
			pstmt_p.setString(3, machine_name);		
			pstmt_p.setString(4,Lot_Id[i]); 
			pstmt_p.setString(5,Location_Id[i]); 
			pstmt_p.setString(6,company_id); 

			int a189 = pstmt_p.executeUpdate();
errLine = 202;
			pstmt_p.close();

		}//end for i
errLine = 206;
		query = "select Voucher_id from Voucher where Voucher_no='"+receive_id+"'";

		pstmt_g = cong.prepareStatement(query);

		rs_g = pstmt_g.executeQuery();

		String voucher_id = "";
			
		while(rs_g.next())
		{
			voucher_id = rs_g.getString("Voucher_Id");
		}
		pstmt_g.close();
errLine = 218;
		query="Update Voucher set Active=?  where Voucher_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,false); 
		pstmt_p.setString(2,voucher_id);		
		
		int a625 = pstmt_p.executeUpdate();
			
		pstmt_p.close();

errLine = 230;
		query="Update Financial_Transaction set Active=?  where Voucher_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,false); 
		pstmt_p.setString(2,voucher_id);		
		
		int a67 = pstmt_p.executeUpdate();
		
		pstmt_p.close();

		query="Update Receive set Active=?  where Receive_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,false); 
		pstmt_p.setString(2,receive_id);		
		
		int a77 = pstmt_p.executeUpdate();
		
		pstmt_p.close();

		query="Update Payment_Details set Active=?  where Voucher_Id=?";

		pstmt_p = conp.prepareStatement(query);

		pstmt_p.setBoolean(1,false); 
		pstmt_p.setString(2,voucher_id);		
		
		int a99 = pstmt_p.executeUpdate();
		
		pstmt_p.close();

		C.returnConnection(conp);
		C.returnConnection(cong);

	}//end if command Update
%>
	<script language=javascript>
	alert("Update Successfully");
	window.close();
	</script>
<%

}//end try
catch(Exception e31)
{ 
	C.returnConnection(conp);
	C.returnConnection(cong);

	out.println("<font color=red> FileName : CancelPurchaseReturn_SystemRun.jsp<br>Exception : "+ e31 +" ErrLine="+errLine);

} //end catch Exception e31 
		
%>		
		