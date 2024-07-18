<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
//Use it only before yearend
try{
String command=request.getParameter("command");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
if(command.equals("Nippon05")){


// Code for connection start here
ResultSet rs_g= null;
ResultSet rs_p= null;
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
		 out.println("<font color=red> FileName : 	getDifferentRTs.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


java.sql.Date D1 = new java.sql.Date(104,3,1);
java.sql.Date D2 = new java.sql.Date(104,11,15);
String query="";

query="Select * from  Receive  where  Purchase=0 and Receive_Sell=1 and [return]=0 and Receive_Date between ? and ? and Company_id=? and Active=1"; 


pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
pstmt_g.setString(3,"1");  //for the company Classic of japan
rs_g = pstmt_g.executeQuery();	
int count=0;
while(rs_g.next())
	{count++;}pstmt_g.close();
//out.print("<br>count=" +count);
java.sql.Date receive_date[]= new java.sql.Date[count]; 
java.sql.Date due_date[]= new java.sql.Date[count];  
int receive_id[]=new int[count];
String receive_no[]=new String[count];
String sold_toid[]=new String[count];
double qty[]=new double[count];
double av_qty[]=new double[count];
double rt_qty[]=new double[count];
double soldqty[]=new double[count];
double total[]=new double[count];
double final_total[]=new double[count];
double cgt_total[]=new double[count];

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
pstmt_g.setString(3,"1"); 
rs_g = pstmt_g.executeQuery();	
int c=0;
while(rs_g.next())
	{
	
		receive_id[c]=rs_g.getInt("receive_id");
		receive_no[c]=rs_g.getString("receive_no");
		receive_date[c]=rs_g.getDate("Receive_Date");
		due_date[c]=rs_g.getDate("Due_Date");
		sold_toid[c]= rs_g.getString("Receive_FromId");
		qty[c]=rs_g.getDouble("Receive_Quantity");
		cgt_total[c]=rs_g.getDouble("Local_Total");

		c++;
	}
pstmt_g.close();

int total_rt_entries=0;
c=0;
for(int k=0; k<count; k++)
	{
	query="Select * from receive_transaction where Active =1  and  receive_id=? ";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+receive_id[k]); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
		{c++;}
	pstmt_g.close();

	
	int counter=c;
	String lot_id[]=new String[counter];
	int receiveid[]=new int[counter];
	int rt_id[]=new int[counter];
	double quantity[]=new double[counter];
	double avl_qty[]=new double[counter];
	double rtn_qty[]=new double[counter];
	double tracked_rtn_qty[]=new double[counter];
	double local[]=new double[counter];
	String R_Date[]=new String[counter];
	String party_id[]=new String[counter];

	c=0;
	query="Select * from receive_transaction as RT, receive as R where R.Active =1 and RT.Active  and  RT.receive_id=? and R.Receive_Id=RT.Receive_Id";
	pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+receive_id[k]); 
	rs_g = pstmt_g.executeQuery();	

	while(rs_g.next())
	{
		rt_id[c]=rs_g.getInt("receivetransaction_id");
		receiveid[c]=rs_g.getInt("receive_id");
		quantity[c]=rs_g.getDouble("Quantity");
		avl_qty[c]=rs_g.getDouble("Available_Quantity");
		rtn_qty[c]=rs_g.getDouble("Return_Quantity");
		lot_id[c]=rs_g.getString("lot_id");
		R_Date[c]=rs_g.getString("Receive_Date");
		party_id[c]=rs_g.getString("Receive_FromId");
		c++;
	}
	pstmt_g.close();
	


	int z=0;
	for(int i=0; i<counter; i++)
	{	
	
		query="Select sum(Quantity) as returnQty from Receive as R, Receive_Transaction as RT where RT.Consignment_ReceiveId="+rt_id[i]+" and RT.lot_id="+lot_id[i]+" and R.Receive_Sell=0 and R.Purchase=0 and R.Return=1 and R.Receive_Id=RT.Receive_Id and R.Active=1 and RT.Active=1";

		pstmt_p = conp.prepareStatement(query);
		rs_p = pstmt_p.executeQuery();	
		while(rs_p.next())
		{
			tracked_rtn_qty[i] = rs_p.getDouble("returnQty");
		}
		pstmt_p.close();
	
		if(tracked_rtn_qty[i] != rtn_qty[i])
		{
			out.print("<br>"+z+" Receive_Id:"+receiveid[i]);
			out.print("&nbsp;&nbsp;&nbsp;Date:"+R_Date[i]);
			out.print("&nbsp;&nbsp;&nbsp;ReceiveTransaction_Id:"+rt_id[i]);
			out.print("&nbsp;&nbsp;&nbsp;Lot_Id:"+lot_id[i]);
			out.print("&nbsp;&nbsp;&nbsp;Quantity:"+quantity[i]);
			out.print("&nbsp;&nbsp;&nbsp;Return Quantity:"+rtn_qty[i]);
			out.print("&nbsp;&nbsp;&nbsp;Tracked Returned Qty 	:"+tracked_rtn_qty[i]);
			total_rt_entries++;
			z++;
						
		}//end of not equal check
	
	}//for
		
out.print("<br><br>");


}//for
out.print("<br><br>End of list<bt>Total Receive_Transaction with difference rows="+total_rt_entries);
//conp.commit();
C.returnConnection(cong);
C.returnConnection(conp);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  //conp.rollback();
  out.println("<font color=red> FileName : getDifferentRts.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
