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
String query="Select * from Receive  where Purchase=1 and Consignment_ReceiveId <> 0 and Active=1 and Return=0 and opening_stock=0";

	pstmt_p=conp.prepareStatement(query);
    
	rs_g = pstmt_p.executeQuery();	
int i=0;
    while(rs_g.next())
	{i++;
	}
	pstmt_p.close();
int count=i;
String cft_recid[]=new String[count];
String recid[]=new String[count];


	pstmt_p=conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();	
 i=0;
    while(rs_g.next())
	{
		recid[i]=rs_g.getString("Receive_Id");
		cft_recid[i]=rs_g.getString("Consignment_ReceiveId");
		i++;
	}
	pstmt_p.close();

int n=0;
for(i=0; i<count; i++)
	{
query="Select * from Receive_Transaction where Receive_Id=? and Active=1 and Consignment_ReceiveId=0";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,recid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{n++;
		}
pstmt_g.close();
}

int counter=n;
    out.print("<br>counter="+counter);    

String rt_id[]=new String[counter];
String lot_id[]=new String[counter];
String lot_srno[]=new String[counter];
String rc_id[]=new String[counter];
String cgr_id[]=new String[counter];
String upcgr_id[]=new String[counter];

n=0;
for(i=0; i<count; i++)
	{
query="Select * from Receive_Transaction where Receive_Id=? and Active=1 and Consignment_ReceiveId=0";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,recid[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
		rt_id[n]=rs_g.getString("ReceiveTransaction_Id");
		lot_id[n]=rs_g.getString("lot_id");
		lot_srno[n]=rs_g.getString("Lot_SrNo");
		rc_id[n]=recid[i];
		cgr_id[n]=cft_recid[i];

		n++;
		}
pstmt_g.close();
}
    out.print("<br>counter="+counter);    

for(n=0; n<counter; n++)
	{
query="Select * from Receive_Transaction where Receive_Id=? and Active=1 and lot_id=? and Lot_SrNo=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,cgr_id[n]); 
	pstmt_g.setString(2,lot_id[n]); 
	pstmt_g.setString(3,lot_srno[n]); 
	rs_g = pstmt_g.executeQuery();	
		while(rs_g.next())
		{
		upcgr_id[n]=rs_g.getString("ReceiveTransaction_Id");
    out.print("<br>upcgr_id="+upcgr_id[n]);    

		}
pstmt_g.close();

}


for(n=0; n<counter; n++)
	{
query="Update  Receive_Transaction set Consignment_ReceiveId=? where ReceiveTransaction_Id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,upcgr_id[n]); 
	pstmt_g.setString(2,rt_id[n]); 
   int ay60=pstmt_g.executeUpdate();

}

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