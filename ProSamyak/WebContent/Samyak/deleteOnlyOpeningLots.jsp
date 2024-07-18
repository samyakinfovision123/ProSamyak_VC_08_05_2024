<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
//Use to delete the unused lots from the Japan d/b on 05/10/2005
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
		 out.println("<font color=red> FileName : 	getOnlyOpeningLots.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


String query="";
//getting the lot, there count and there sum
query= " SELECT Lot_Id, COUNT(*) AS Lcount, sum(quantity) as sum FROM       Receive_Transaction GROUP BY   Lot_Id  HAVING  (Lot_Id IN (SELECT DISTINCT Lot_Id  FROM Receive_Transaction))";

int lotcounter=0;
int candidate_lotcounter=0;
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
while(rs_g.next())
	{
		lotcounter++;
	}
pstmt_g.close();
int lot_id[] = new int[lotcounter];
int lot_count[] = new int[lotcounter];
double sum[] = new double[lotcounter];


int c=0;
pstmt_g=cong.prepareStatement(query);
rs_g=pstmt_g.executeQuery();
while(rs_g.next())
	{
		lot_id[c] = rs_g.getInt("Lot_Id");
		lot_count[c] = rs_g.getInt("Lcount");
		sum[c] = rs_g.getDouble("sum");
		if(lot_count[c]==1 && sum[c]==0)
			{candidate_lotcounter++;}
		c++;
	}

pstmt_g.close();

//filtering the lots having count=1 and sum=0
out.print("<br>candidate_lotcounter="+candidate_lotcounter);

int candidate_lot_id[] = new int[candidate_lotcounter];
c=0;
for(int i=0; i<lotcounter; i++)
	{
		if(lot_count[i]==1 && sum[i]==0)
		{
			candidate_lot_id[c]=lot_id[i];	
			c++;
		}

	}

out.print("<br>candidate_lotcounter taken ="+c);

//getting all RT_Ids and R_Ids for the candidate lot id
c=0;
String RT_id[] = new String[candidate_lotcounter];
String R_id[] = new String[candidate_lotcounter];
String lotcategory_id[] = new String[candidate_lotcounter];
String lotcategory_name[] = new String[candidate_lotcounter];
for(int i=0; i<candidate_lotcounter; i++)
{	
	query = "Select * from Receive_Transaction as RT, Receive as R where RT.Receive_Id=R.Receive_Id and RT.Lot_Id="+candidate_lot_id[i]+" and R.opening_stock=1 and R.return=0 and R.Purchase=1 and R.Receive_Sell=1 and R.Active=1 and RT.Active=1"; 
	pstmt_g=cong.prepareStatement(query);
	rs_g=pstmt_g.executeQuery();
	while(rs_g.next())
	{
		RT_id[c] = rs_g.getString("ReceiveTransaction_Id");
		//out.print("<br>"+i+"] &nbsp;RT_id="+RT_id[c]);
		R_id[c] = rs_g.getString("Receive_Id");
		//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;R_id="+R_id[c]);
		//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lot_id="+rs_g.getString("Lot_Id"));
		c++;
	}

	pstmt_g.close();
}

out.print("<br>Total Lots="+c);

//deleting the lots from the R, RT, Lot, Diamond, Jewelry
int RT_Deleted=0;
int R_Deleted=0;
int Lot_Deleted=0;
for(int i=0; i<c; i++)
{	
	query = "Update Receive_Transaction set Active=0 where ReceiveTransaction_Id="+RT_id[i]; 
	pstmt_g=cong.prepareStatement(query);
	int a112 = pstmt_g.executeUpdate();
	RT_Deleted+=a112;
	pstmt_g.close();

	query = "Update Receive set Active=0 where Receive_Id="+R_id[i]; 
	pstmt_g=cong.prepareStatement(query);
	int a121 = pstmt_g.executeUpdate();
	R_Deleted+=a121;
	pstmt_g.close();

	query = "Update Lot set Active=0 where Lot_Id="+candidate_lot_id[i]; 
	pstmt_g=cong.prepareStatement(query);
	int a132 = pstmt_g.executeUpdate();
	Lot_Deleted+=a132;
	pstmt_g.close();

	
}


out.print("<br>Lots Deleted="+Lot_Deleted);
out.print("<br>RT_ids Deleted="+RT_Deleted);
out.print("<br>R_ids Deleted="+R_Deleted);





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
	out.println("<font color=red> FileName : getOnlyOpeningLots.jsp<br>Bug No Samyak31 :"+Samyak31);
 }

%>
