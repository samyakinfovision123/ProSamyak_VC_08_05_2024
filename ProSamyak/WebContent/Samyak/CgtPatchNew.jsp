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
String query="Select * from Receive R, receive_Transaction RT  where R.Purchase=0 and R.Active=1 and R.Return=0 and R.opening_stock=0 and R.receive_id=RT.receive_id and RT.Active=1";

	pstmt_p=conp.prepareStatement(query);
    
	rs_g = pstmt_p.executeQuery();	
int i=0;
    while(rs_g.next())
	{i++;
	}
	pstmt_p.close();
int count=i;
String rec_id[]=new String[count];
String rt_id[]=new String[count];
String lot_id[]=new String[count];
String sr_no[]=new String[count];
double av_qty[]=new double[count];
double rt_qty[]=new double[count];
double qty[]=new double[count];
double soldqty[]=new double[count];

    out.print("<br>count="+count);    


	pstmt_p=conp.prepareStatement(query);
		rs_g = pstmt_p.executeQuery();	
 i=0;
    while(rs_g.next())
	{
		rec_id[i]=rs_g.getString("Receive_Id");
		rt_id[i]=rs_g.getString("ReceiveTransaction_Id");
		lot_id[i]=rs_g.getString("lot_id");
		sr_no[i]=rs_g.getString("Lot_SrNo");
		qty[i]=rs_g.getDouble("quantity");
		rt_qty[i]=rs_g.getDouble("Return_Quantity");
		i++;
	}
	pstmt_p.close();
int n=0;
for(i=0; i<count; i++)
	{
	 query="Select * from Receive R, receive_Transaction RT  where R.Purchase=1 and R.Active=1 and R.Return=0 and R.opening_stock=0 and R.receive_id=RT.receive_id  and RT.Consignment_ReceiveId=? and RT.Active=1 and R.Consignment_ReceiveId <> 0";

pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,rt_id[i]); 
	rs_g = pstmt_g.executeQuery();	
	while(rs_g.next())
		{
		soldqty[i] += rs_g.getDouble("quantity");
		n++;
		}
pstmt_g.close();
}
for(i=0; i<count; i++)
	{
	//	soldqty[i]=qty[i]-rt_qty[i]-av_qty[i];
av_qty[i]=qty[i]-rt_qty[i]-soldqty[i];

   // out.print("<br>av_qty[i]="+av_qty[i]);    

	}



for(n=0; n<count; n++)
	{
query="Update  Receive_Transaction set Available_Quantity=? where ReceiveTransaction_Id=?";
pstmt_g = cong.prepareStatement(query);
	pstmt_g.setString(1,""+av_qty[n]); 
	pstmt_g.setString(2,""+rt_id[n]); 
   int ay60=pstmt_g.executeUpdate();
   pstmt_g.close();

}

//-----------------------------------------------------------
%>
<html>
<head>
<script language=javascript>
function confirm ()
{
	alert("Data save Sucessfully");
	window.close();


}


</script>

</head>
	<body onload="confirm()">
</body>
	</html>

<% 
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