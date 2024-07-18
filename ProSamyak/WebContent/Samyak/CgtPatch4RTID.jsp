<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<% 

ResultSet rs_g= null;
ResultSet rs_q= null;
ResultSet rs_p= null;
Connection conp = null;
Connection cong = null;
Connection conr = null;
Connection cn = null;

PreparedStatement pstmt_p=null;
PreparedStatement pstmt_q=null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_r=null;
String receive_id1="";
double ReceiveTransaction_Id = 0;
double Lot_Id = 0;
double Consignment_ReceiveId = 0;
double ReceiveTransaction_Id1 = 0;
String checkqry = "";
boolean purchase=true;
boolean return1=true;
String qry="";
String innerQuery="";
   System.out.println("Start of System Run");    
    out.print("Start of System Run");    

try	{conp=C.getConnection();
cong=C.getConnection();
conr=C.getConnection();
cn=C.getConnection();
	String query="select RT.ReceiveTransaction_Id as ReceiveTransaction_Id1,RT.Lot_Id as Lot_Id1, RT.Consignment_ReceiveId as Consignment_ReceiveId1   from Receive R, Receive_transaction RT  where R.Receive_Id = RT.Receive_Id and ((R.Purchase=0 and R.Return=1)  or (R.Purchase=1 and RT.Consignment_ReceiveId <> 0))";

	pstmt_p=conp.prepareStatement(query);
    
	rs_g = pstmt_p.executeQuery();	

    while(rs_g.next())
	{
			ReceiveTransaction_Id =Double.parseDouble(rs_g.getString("ReceiveTransaction_Id1"));
			Lot_Id = Double.parseDouble(rs_g.getString("Lot_Id1"));
		Consignment_ReceiveId =Double.parseDouble(rs_g.getString("Consignment_ReceiveId1"));

	    checkqry = "select Purchase,Return from Receive where Receive_Id ="+ Consignment_ReceiveId;
		pstmt_q=cong.prepareStatement(checkqry);
		rs_q=pstmt_q.executeQuery();
		purchase=true;
		return1=true;

			while(rs_q.next())
			{
				purchase=rs_q.getBoolean("Purchase");
				return1=rs_q.getBoolean("Return");
			}
	    
		pstmt_q.close();

		if((!purchase) && (!return1))
		{

			qry = "select ReceiveTransaction_Id from Receive_transaction where Receive_Id = ? and Lot_Id = ?"; 
		 	pstmt_q=cong.prepareStatement(qry);
			pstmt_q.setDouble(1,Consignment_ReceiveId); 
			pstmt_q.setDouble(2,Lot_Id); 
			rs_q = pstmt_q.executeQuery();
			while(rs_q.next())
			{
				ReceiveTransaction_Id1=Double.parseDouble(rs_q.getString("ReceiveTransaction_Id"));
			}
			pstmt_q.close();
			  
			innerQuery = "update receive_transaction set Consignment_ReceiveId = ? where ReceiveTransaction_Id= ?";
		pstmt_q=cong.prepareStatement(innerQuery);
			pstmt_q.setDouble(1,ReceiveTransaction_Id1); 
			pstmt_q.setDouble(2,ReceiveTransaction_Id); 
	 	   int ay60=pstmt_q.executeUpdate();
			pstmt_q.close(); 
//    System.out.print("<BR>ay60="+ay60);    
    out.print("ay60="+ay60);    

		}//if
	}
	pstmt_p.close();

//------------------------This part is 4 recalculating  available_quantity--------------------------------------------

 query = "select distinct(r.receive_id) from Receive r , Receive_Transaction  rt  where  r.receive_id =  rt.receive_id and ((purchase=0 and receive_sell=1 and return=0 ) or (purchase=0 and receive_sell=0 and return=0 ))   and r.active=1 and rt.Receivetransaction_Id <> any (select Consignment_ReceiveId from Receive_Transaction where Active = 1)";	
  
  pstmt_q = cong.prepareStatement(query);

  rs_q = pstmt_q.executeQuery();	
  
  while(rs_q.next())
  {	  
      receive_id1 = rs_q.getString("receive_id");
	  //out.print("<br>receive_id1"+receive_id1);
	  query = "select Receivetransaction_Id,Quantity from  Receive_Transaction where receive_id = "+ receive_id1 +" and Consignment_ReceiveId = 0 and Active = 1"; 

	  pstmt_g = cn.prepareStatement(query);  
	  rs_g = pstmt_g.executeQuery();
	  
	//  int counter = 0; 
	  double sum = 0;
	  double Quantity=0;
	  while(rs_g.next()) 
	  {
		  String  rtid =     rs_g.getString("Receivetransaction_Id"); 
          //out.print("<br>rtid"+rtid);

		  Quantity=rs_g.getDouble("Quantity");

		  query = "select  sum(Available_Quantity) as sumall from Receive_Transaction where  Consignment_ReceiveId="+rtid+" and active=1";

			pstmt_p=conp.prepareStatement(query);
			rs_p = pstmt_p.executeQuery();
			rs_p.next();

			sum= rs_p.getDouble("sumall");

			//out.print("<br>sum"+sum);

			pstmt_p.close();

			Quantity = Quantity-sum; 

            //out.print("<br>Quantity"+Quantity); 

		query = "Update  Receive_Transaction set Available_Quantity =" + Quantity + " where  Receivetransaction_Id=" + rtid + "  and active=1";

		pstmt_r=conr.prepareStatement(query);
  	    int ay116=pstmt_r.executeUpdate();
		pstmt_r.close(); 
    out.print("<BR>ay116="+ay116);    
 //   System.out.print("<BR>ay116="+ay116);    

        
	//	  counter++;
	  }



  }

	pstmt_g.close();

//-----------------------------------------------------------
    out.print("Updated Successfully");    
	C.returnConnection(conp);
	C.returnConnection(conr);
	C.returnConnection(cong);
	C.returnConnection(cn);
}
catch(Exception e31){ 
	C.returnConnection(conp);
	C.returnConnection(cong);
	out.println("<font color=red> FileName : Cash.jsp<br>Bug No e31 : "+ e31);}
%>