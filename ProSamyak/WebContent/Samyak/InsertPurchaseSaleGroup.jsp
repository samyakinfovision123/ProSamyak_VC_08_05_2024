<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
if(command.equals("Nippon05")){

%>
<!--
<html>
<head>
	<title>Update YearEnd_Id - Samyak Software</title>
	<script language="javascript">
	function ChkAlert() {
	alert("Updating all columns with YearEnd_Id"); 
	}
	</script>
</head>
</html>
-->

<% 

// Code for connection start here
ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;

try	{
	 cong=C.getConnection();
	}
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	InsertPurchaseSaleGroup.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


/* 	Code for Diff Company_Id in a Given Table
Start    		*/


String query="Select * from YearEnd";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int Count=0;
while(rs_g.next())
{
Count=Count+1;
}
pstmt_g.close();


/* 	Code for to get Diff YearEnd_Id for diff Company_Id from YearEnd Table */

String company_id[]=new String[Count] ;
String yearend_id[]=new String[Count] ;

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int tempn=0;
while(rs_g.next())
{
company_id[tempn]=rs_g.getString("Company_id");
yearend_id[tempn]=rs_g.getString("YearEnd_id");
tempn=tempn+1;
}
pstmt_g.close();





/* 	Code to insert rows in Master_PurchaseSaleGroup Table 
Start
*/

int tempi=0;
int tempx=0;

for( tempi=0;tempi<Count;tempi++)
{
out.print("<br>87");
//Start : Adding a default PurchaseSale Group named 'Normal' for the Super Company
String purchasesalegrouptype_id= ""+L.get_master_id(cong,"Master_PurchaseSaleGroup");

query = " INSERT INTO Master_PurchaseSaleGroup( PurchaseSaleGroup_Id, Company_Id , PurchaseSaleGroup_Type, PurchaseSaleGroup_Name, PurchaseSaleGroup_Code, Sr_No, Active, YearEnd_Id, Modified_By, Modified_On, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString (1, purchasesalegrouptype_id);		
pstmt_g.setString (2,company_id[tempi]);
pstmt_g.setString (3,"0");
pstmt_g.setString (4, "Normal");
pstmt_g.setString (5, "Normal");		
pstmt_g.setString (6,purchasesalegrouptype_id);			
pstmt_g.setBoolean (7, true);		
pstmt_g.setString (8,yearend_id[tempi]);	
pstmt_g.setString (9,"1");	
pstmt_g.setString (10,""+D);	
pstmt_g.setString (11,"Samyak2");	

	
int a491 = pstmt_g.executeUpdate();
pstmt_g.close();


purchasesalegrouptype_id= ""+L.get_master_id(cong,"Master_PurchaseSaleGroup");

query = " INSERT INTO Master_PurchaseSaleGroup( PurchaseSaleGroup_Id, Company_Id , PurchaseSaleGroup_Type, PurchaseSaleGroup_Name, PurchaseSaleGroup_Code, Sr_No, Active, YearEnd_Id, Modified_By, Modified_On, Modified_MachineName) values(?,?,?,?, ?,?,?,?, ?,?,?)";

pstmt_g = cong.prepareStatement(query);
pstmt_g.setString (1, purchasesalegrouptype_id);		
pstmt_g.setString (2,company_id[tempi]);
pstmt_g.setString (3,"1");
pstmt_g.setString (4, "Normal");
pstmt_g.setString (5, "Normal");		
pstmt_g.setString (6,purchasesalegrouptype_id);			
pstmt_g.setBoolean (7, true);		
pstmt_g.setString (8,yearend_id[tempi]);	
pstmt_g.setString (9,"1");	
pstmt_g.setString (10,""+D);	
pstmt_g.setString (11,"Samyak2");	

	
int a513 = pstmt_g.executeUpdate();
pstmt_g.close();

}

/* 	
End
*/
out.println("PurchaseSaleGroup Inserted successfully"+tempx);

C.returnConnection(cong);

}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : InsertPurchaseSaleGroup.jsp<br>Bug No Samyak31 :"+Samyak31);
 }


%>
