<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>
<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");
String table_name=request.getParameter("table_name");

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
		 out.println("<font color=red> FileName : 	UpdateYeadEnd_Id.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}
// Code for connection end here


/* 	Code for Diff Company_Id in a Given Table
Start    		*/


String query="Select Distinct company_id from "+	table_name+"";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int diffCompanyCount=0;
while(rs_g.next())
{
diffCompanyCount=diffCompanyCount+1;
//out.print("<br> diffCompanyCount"+diffCompanyCount);
}
pstmt_g.close();

/* 	Code for Diff Company_Id in a Given Table
End  		*/



/* 	Code for to get Diff YearEnd_Id for diff Company_Id from YearEnd Table */

String company_id[]=new String[diffCompanyCount] ;
String yearend_id[]=new String[diffCompanyCount] ;

pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();	
int tempn=0;
while(rs_g.next())
{
String condition="Where company_id="+company_id[tempn];
//+"and From_date='01/04/2004'";
company_id[tempn]=rs_g.getString("Company_id");
//out.print("<br>company_id[ "+tempn+" ]"+company_id[tempn]);
yearend_id[tempn]=A.getNameCondition(cong,"YearEnd","YearEnd_Id","Where company_id="+company_id[tempn]+" and active=1");
out.print("<br>company_id[ "+tempn+" ]"+company_id[tempn]);
out.print("<br>yearend_id[ "+tempn+" ]"+yearend_id[tempn]);
tempn=tempn+1;
}
pstmt_g.close();
out.print("<br>83");
/* 	Code for to get Diff YearEnd_Id for diff Company_Id from YearEnd Table */




/* 	Code for to update YearEnd_Id for in a given Table 
Start
*/

int tempi=0;
int tempx=0;

for( tempi=0;tempi<diffCompanyCount;tempi++)
{
	if(!("0".equals(company_id[tempi])))
	{
		out.print("97");
		query="Update "+table_name+" set YearEnd_Id=? where company_id=?";
		//out.print("<br> i"+i+" query" +query+"receive_id[i]"+receive_id[i]);
		pstmt_g = cong.prepareStatement(query);
		pstmt_g.setString(1,""+yearend_id[tempi]); 
		out.print("<br>yearend_id"+tempi+" "+yearend_id[tempi]);
		pstmt_g.setString(2,""+company_id[tempi]); 
		out.print("<br>company_id"+tempi+" "+company_id[tempi]);
		out.print("<br>"+query);
		tempx = pstmt_g.executeUpdate();
	}
}

/* 	Code for to update YearEnd_Id for in a given Table 
End
*/
out.println("YearEnd_Id Updated successfully"+tempx);
pstmt_g.close();






C.returnConnection(cong);








}
else
	{
 	 out.print("<br>Please contact to Samyak Super Admin at admin@esamyak.com or at www.esamyak.com <br>");
	}
}
catch(Exception Samyak31)
 { 
  out.println("<font color=red> FileName : UpdateYeadEnd_Id.jsp<br>Bug No Samyak31 :"+Samyak31);
 }
 

%>
