<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="S" class="NipponBean.str" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="YED" class="NipponBean.YearEndDate" />

 <%
Connection conp = null;
 String user_id= ""+session.getValue("user_id");
//out.print("<br> User_Id"+user_id);
String user_level= ""+session.getValue("user_level");
//out.print("<br> user_level"+user_level);
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String user_name= ""+session.getValue("user_name");
//java.sql.Date D = new java.sql.Date();
int int_companyid=Integer.parseInt(company_id);

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

//String NewDate=format.format(D);
//out.print("<br> 27 Newdate"+NewDate);
int year=(D.getYear()+1900);

	int method= 0; 
	int dd=D.getDate();
	 String dd1=""+dd;
     if (dd < 10)
	  {
	   dd1="0"+dd;
	  }
	//out.print("<br> 31 dd :"+dd1);
	int mm=D.getMonth();
	mm=mm+1;
	String mm1=""+mm;
    if (mm < 10)
	  {
		mm1="0"+mm;
	  }
	//out.print("<br>33 mm:"+mm1);



try{

	 PreparedStatement pstmt_g=null;
	 PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;	
	ResultSet rs_p = null;	

	conp=C.getConnection();
	String newlocation_id="";
%>
<HTML>
<HEAD>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>



<META NAME="Author" CONTENT="Samyak Software , www.esamyak.com">
<link href='Dove/dovecss.css' rel=stylesheet type='text/css'>
<script language="JavaScript">
	function callme()
	{
		var categorycode=document.f1.categoryCode.value;
		var newlocation_id=document.f1.newlocation_id.value;
		var UserLevel=document.f1.userLevel.value;
		var dd1=document.f1.dd1.value;
		var mm1=document.f1.mm1.value;
		var year=document.f1.year.value;
		//alert("dd1"+dd1);
		//		alert("mm1"+mm1);
		//				alert("year"+year);
		if(UserLevel==15)
		{

			window.open("../Report/CgtStockReportFast.jsp?dd1="+dd1+"&mm1="+mm1+"&yy1="+year+"&location_id="+newlocation_id+"&order_by=lot_no&ratetype=AvgPur&group_by=lot_no&category_id=0&subcategory_id=0&showamount=yes&currency=dollar&rangeStart=-0.03&rangeEnd=-999999&range=include&lotRangeStart=&lotRangeEnd=&SaveStock=no&command=Financial+Stock","_blank", ["Top=50","Left=100" , "Height=300", "Width=300","Toolbar=no", "Location=0", "Menubar=yes", "Resizable=yes", "Scrollbars=yes", "status=yes"])
		}
		else
		{
			window.open("../Report/CgtStockReportFast.jsp?dd1="+dd1+"&mm1="+mm1+"&yy1="+year+"&location_id=0&order_by=lot_no&ratetype=AvgPur&group_by=lot_no&category_id=0&subcategory_id=0&showamount=yes&currency=dollar&rangeStart=-0.03&rangeEnd=-999999&range=include&lotRangeStart=&lotRangeEnd=&SaveStock=no&command=Financial+Stock","_blank", ["Top=50","Left=100" , "Height=300", "Width=300","Toolbar=no", "Location=0", "Menubar=yes", "Resizable=yes", "Scrollbars=yes", "status=yes"])
		}

	}
</script>

</HEAD>


<BODY class=bgimage Width='100%' scroll=no background="../Buttons/BGCOLOR.JPG">
<form name=f1>
<center>
<%
	if (int_companyid > 0)
{
	

	String Category_Code = A.getNameCondition(conp,"Master_CompanyParty", "Category_Code", " Where companyparty_id="+company_id);
		
	newlocation_id= A.getNameCondition(conp,"Master_Location", "Location_id","where Location_Name Like '"+user_name+"' and company_id="+company_id);	

	if("3".equals(Category_Code)||"4".equals(Category_Code))
	{

	%>
	<input type=hidden name=userLevel value=<%=user_level%>>
	<input type=hidden name=categoryCode value=<%=Category_Code%>>
	<input type=hidden name=newlocation_id value=<%=newlocation_id%>>
	<input type=hidden name=dd1 value=<%=dd1%>>
	<input type=hidden name=mm1 value=<%=mm1%>>
	<input type=hidden name=year value=<%=year%>>
	
	
	<%
	
	}
}


%>
	</center>
<table border=0 cellspacing=0 valign="bottom" height="97%" align="Center">
<tr><th valign="bottom" class="balance"><a href='http://www.eSamyak.com' target='_blank'>
<img src='../SamyakLogo.gif' height="40" border=0><br>Samyak Software, India</a><br>All Rights Reserved.</td></tr>
</table>
</form>
</BODY>
</HTML>
<%

	C.returnConnection(conp);

	 
}catch(Exception Dove89){ 
	C.returnConnection(conp);

out.println("<font color=red> FileName : Homepage.jsp <br>Bug No Dove89 :"+ Dove89 +" after line : </font>");
}

 
%>


	