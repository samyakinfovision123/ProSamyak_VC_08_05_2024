<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
 <% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try	
{
	conp=C.getConnection();
}
catch(Exception e31)
{ 
out.println("<font color=red> FileName : EditLot.jsp<br>Bug No e31 : "+ e31);
}



String company_name= A.getName(conp,"companyparty",company_id);
String servername=request.getServerName();

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());


String command = request.getParameter("command");
String message=request.getParameter("message"); 


if("Default".equals(message) || message==null)
{
}
else
{
	out.println("<center><font class='submit1'> "+message+"</font></center>");
}




String query="";

try{
if("edit".equals(command))
{

%>
<html>
<head>
<title> Samyak Software </title>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<SCRIPT LANGUAGE="JavaScript" src="Scripting.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakcalendar.js"></SCRIPT>
</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form action="EditLot.jsp?command=Next" name=f1 method=post>
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Edit Lot
</th>  
</tr>
<tr><td>Lot No <font class="star1">*</font></td>
	<td colSpan=1>
	<input type=text name=lot_no size=6 value='1'></td></tr>

<tr><td colspan=2 align=center> <input type="submit" name="command" value="Next" class='Button1'> </td></tr>
</table>
</td></tr>
</table>
</form>
</body>
</html>

<%
	C.returnConnection(conp);
	
}//if edit 


if("Next".equals(command))
	{	
 String lotno=request.getParameter("lot_no");
int lotcategory_id=0;
int lot_id=0;

query="Select *  from  Lot where Lot_No=? and Company_Id="+company_id;
//out.print("<br>91 query " +query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,lotno); 
//out.print("<br>lotno=" +lotno);

		rs_g = pstmt_p.executeQuery();
int count=0;
		while(rs_g.next())
		{
			count++;
		}
	pstmt_p.close();
 
	if(count!=0)
	{
 
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,lotno); 
		rs_g = pstmt_p.executeQuery();

	while(rs_g.next()) 	
	{
	 lotcategory_id=Integer.parseInt(rs_g.getString("LotCategory_Id"));
	lot_id=Integer.parseInt(rs_g.getString("Lot_Id"));

	//out.print("<br>lot_id "+lot_id);
	//out.print("<br>LotCategory_Id "+lotcategory_id);
	//out.print("<br>company_id "+company_id);
	}
 	pstmt_p.close();

	int category= Integer.parseInt(A.getNameCondition(conp,"Master_LotCategory","LotCategory_Id","where LotCategory_Name='Diamond' and company_id="+company_id));



	if(lotcategory_id==category)
	{
			C.returnConnection(conp);

	//out.print("<br> Diamond");
	response.sendRedirect("EditDiamond.jsp?lot_id="+lot_id);
	}
	else
		{
		category=Integer.parseInt(A.getNameCondition(conp,"Master_LotCategory","LotCategory_Id","where LotCategory_Name='Jewelry' and company_id="+company_id));

		  if(lotcategory_id==category)
			{
			  	C.returnConnection(conp);

		//	out.print("Inside EditJewelry");
		response.sendRedirect("EditJewelry.jsp?lot_id="+lot_id+"&Lot_No="+lotno);
			}
			else
			{
					C.returnConnection(conp);

		response.sendRedirect("EditItem.jsp?lot_id="+lot_id);

			}
		}





	}
	else{ 
	C.returnConnection(conp);
	out.print("Lot Does Not Exist");
	response.sendRedirect("EditLot.jsp?command=edit&message=Lot "+lotno+" does not exists");
}


}//if next
	}catch(Exception Samyak170){ 
	out.println("<font color=red> FileName : NewLot.jsp <br>Bug No Samyak170 :"+ Samyak170 +"</font>");}
	%>








