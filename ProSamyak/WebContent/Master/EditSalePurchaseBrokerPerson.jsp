<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<% 
	Connection conp = null;
	Connection cong = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;
	ResultSet rs_p = null;
	

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String company_id= ""+session.getValue("company_id");
String machine_name=request.getRemoteHost();
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
int itoday_day=D.getDate();
int count=0;
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
String command = request.getParameter("command");
//fout.print("<BR>command="+command);
String errLine="33";
String salesperson_id = request.getParameter("salesperson_id");
			//out.println("<br>"+salesperson_id);
String salepurchasebroker_id=request.getParameter("salepurchasebroker_id");
		//out.print("<br> salepurchasebroker_id="+salepurchasebroker_id);
try{	
	
	conp=C.getConnection();
	cong=C.getConnection();
if("Default".equals(command))
{
if("0".equals(salesperson_id))
	{
		if("0".equals(salepurchasebroker_id))
		{
			out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background=../Buttons/BGCOLOR.JPG><center><font color=red><h2>Please Select Sale Person Name</h2><input type=button name=command value='BACK' class='button1' onClick='history.go(-1)'  ></center>");
		}else if("1".equals(salepurchasebroker_id))
		{
			out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background=../Buttons/BGCOLOR.JPG><center><font color=red><h2>Please Select Purchase Person Name</h2><input type=button name=command value='BACK' class='button1' onClick='history.go(-1)'  ></center>");
		}else
		{
			out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background=../Buttons/BGCOLOR.JPG><center><font color=red><h2>Please Select Broker Person Name</h2><input type=button name=command value='BACK' class='button1' onClick='history.go(-1)'  ></center>");
		}
	}
	else
	{

	%>
<HTML>
<HEAD>
<TITLE>Samyak Software- India</TITLE>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	

<script>
var errfound = false;
function LocalValidate()
	{
	errfound = false;

	if(document.mainform.salesperson_name.value == "")
		{
		alert("Please enter Person name.");
		document.mainform.salesperson_name.select();
		return errfound;
		}
	else {
			var tempA=document.mainform.salesperson_name.value;
			if(tempA.length < 3)
			{
			alert("Please enter Person name Properly. Must be more than two characters");
			document.mainform.salesperson_name.select();
			return errfound;
			}
			else{
				return !errfound;
				}
		}// else 


}//validate

</script>
<SCRIPT language=javascript src="../Samyak/Samyakdate.js">
</script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</HEAD>

<BODY bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<br>

<form name=mainform action="UpdateSalePurchaseBrokerPerson.jsp" method=post onsubmit="return LocalValidate();">
<%	

String message=request.getParameter("message"); 	
if(message == null)
	{
	}else
	{
		out.println("<center><font class='submit1'> "+message+"</font></center>");
	}

	%>
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<%
	
			//out.println("<br>"+company_id);
	if("2".equals(salepurchasebroker_id))
		{
			String ActiveQuery = "select count(*)as counter from receive_transaction where receive_id in(select receive_id from receive where Broker_id="+salesperson_id+"and Active=1 and company_id="+company_id+")and  Active=1";

			pstmt_g = cong.prepareStatement(ActiveQuery);
			rs_p= pstmt_g.executeQuery();
			
			while(rs_p.next())
				{
					count=rs_p.getInt("counter");
				}
					pstmt_g.close();
				//out.print(" 109 count="+count);
		}
		else
		{
			String ActiveQuery = "select count(*)as counter from receive_transaction where receive_id in(select receive_id from receive where salesperson_id="+salesperson_id+"and Active=1 and company_id="+company_id+")and  Active=1";

			pstmt_g = cong.prepareStatement(ActiveQuery);
			rs_p= pstmt_g.executeQuery();
			
			while(rs_p.next())
				{
					count=rs_p.getInt("counter");
				}
					pstmt_g.close();
				//out.print(" 109 count="+count);
		}
 //String message=request.getParameter("message"); 
//	String message1=request.getParameter("message1"); 
	//out.print(" <br> 74 message1"+message1);



	
		
		message=request.getParameter("message");
		//out.print("<br>179 message="+message);
	
		String query = "select * from Master_SalesPerson where SalesPerson_Id=? and purchasesale=?";
		pstmt_p  = conp.prepareStatement(query);
		pstmt_p.setString(1,salesperson_id);
		pstmt_p.setString(2,salepurchasebroker_id);
		rs_g = pstmt_p.executeQuery();
		String salesperson_name="";
		String address1="";
		String address2="";
		String address3="";
		String city="";
		String pin="";
		String country="";
		String mobile="";
		String phone_o="";
		String phone_r="";
		String fax="";
		String email="";
		double commission=0;
		String active="";
		String activeyes="";
	while(rs_g.next())
	{
		 salesperson_name =rs_g.getString("SalesPerson_Name");
		if (rs_g.wasNull())
		{
			salesperson_name="";
		}
		address1=rs_g.getString("address1");
		
		if (rs_g.wasNull())
		{
			address1="";
		}

		 address2=rs_g.getString("address2");
		if (rs_g.wasNull())
		{
			address2="";
		}

		address3=rs_g.getString("address3");
		if (rs_g.wasNull())
		{
			address3="";
		}

		city=rs_g.getString("city");	
		if (rs_g.wasNull())
		{
			city="";
		}
		pin=rs_g.getString("pin");
		if (rs_g.wasNull())
		{
			pin="";
		}
		
		country=rs_g.getString("country");
		if (rs_g.wasNull())
		{
			country="";
		}
		mobile=rs_g.getString("mobile");
		if (rs_g.wasNull())
		{
			mobile="";
		}
		
		phone_o=rs_g.getString("phone_o");
		if (rs_g.wasNull())
		{
			phone_o="";
		}
		phone_r=rs_g.getString("phone_r");
		if (rs_g.wasNull())
		{phone_r="";}

		fax=rs_g.getString("fax");	
		if (rs_g.wasNull())
		{fax="";}
	
		email=rs_g.getString("email");	
		if (rs_g.wasNull())
		{email="";}

		commission=Double.parseDouble(rs_g.getString("commission"));	
		if (rs_g.wasNull())
		{commission=0.00;}

		active=rs_g.getString("Active");
		
		activeyes="";
		if("1".equals(active)){activeyes = " checked " ;}
	}
	%>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
<%
		if("0".equals(salepurchasebroker_id))
		{
%>
	<th align=center colspan="4">Edit Sale Person</th>
<%
		}
			else if("1".equals(salepurchasebroker_id))
		{
%>
	<th align=center colspan="4">Edit Purchase Person</th>
<%
		}
			else
		{
%>
	<th align=center colspan="4">Edit Broker Person</th>
<%}%>
</tr>

<tr>
<%
		if("0".equals(salepurchasebroker_id))
		{
%>
	<td>Sale Person Name<font class="star1">*</font></td> 
<%
		}
			else if("1".equals(salepurchasebroker_id))
		{
%>
	<td>Purchase Person Name<font class="star1">*</font></td> 
<%
		}
			else
		{
%>
	<td>Broker Person Name<font class="star1">*</font></td> 
<%}%>
	<td colspan=3> <input type=text size=30 name=salesperson_name Value="<%=salesperson_name%>"></td>
</tr>
<tr>
    <td>Address</td>
    <td colSpan=3><INPUT type=text name=address1 size=50 value="<%=address1%>"> </td>
</tr>

<tr>
    <td></td> 
    <td colSpan=3><INPUT type=text name=address2 size=50 value="<%=address2%>" ></td> 
</tr>

<tr>
    <td></td> 
    <TD colSpan=3><INPUT  type=text name=address3 size=50 Value="<%=address3%>"></td> 
</tr>
<tr>
<td>City</td> 
<td colspan=1><INPUT  type=text name=city Value="<%=city%>"></td> 
<td>Pin</td> 
<td><INPUT  type=text name=pin Value="<%=pin%>"></td> 
<tr>
<td>Country </td> 
<td colspan=1><INPUT type=text  name=country Value="<%=country%>"></td>
<td>Mobile</td> 
<td colspan=1><INPUT type=text  name=mobile Value="<%=mobile%>"></td>
</tr> 

<tr>
<td>Phone (0)</td> 
<td colspan=1><INPUT  type=text name=phone_o Value="<%=phone_o%>"></td> 
<td>Phone (R)</td> 
<td><INPUT  type=text name=phone_r Value="<%=phone_r%>"></td> 
</tr>
<tr>
<td>Fax </td> 
<td colspan=1><INPUT  type=text name=fax Value="<%=fax%>"></td> 
<td>Email</td> 
<td><INPUT  type=text name=email Value="<%=email%>"></td> 
</tr>
<tr>
<td>Commission (%) </td> 
<td colspan=3><INPUT  type=text name=commission size=5 Value="<%=str.format(""+commission,2)%>" onBlur='validate(this,2)' style="text-align:right"></td> 

</tr>
<tr>
<% 
	if(count==0)
		{
	%>
<td>Active</td> 
	<td><input type=checkbox name=active value=yes <%=activeyes%>></td>
<%
		}
	else{
	%>
<td></td>
<td><input type=hidden name=active value=yes <%=activeyes%>></td>
<%}%>
</tr>
<input type=hidden name=command1 value='Default' >
<input type=hidden name=message value='Broker' >
<input type=hidden name=salesperson_id Value="<%=salesperson_id%>" >
<input type=hidden name=salepurchasebroker_id Value="<%=salepurchasebroker_id%>" >
<tr>
	<td align=center colspan="4"><input type=submit   value='SAVE' name=command class="button1" >
	</td>
</tr>
</table>
<%//end while
//else{out.println("<center><font class='submit1'> "+message1+"</font></center>");}%>
</table>
</form>

</BODY>
</HTML>
<% }} //if Default
%>
<%	
	//response.sendRedirect("EditBrokerPurchasePerson.jsp?command=Default&salesperson_id=0");

	C.returnConnection(conp);
	C.returnConnection(cong);
}catch(Exception Samyak499)
{
	C.returnConnection(conp);
	C.returnConnection(cong);
	
			out.println("<br><font color=red> FileName : EditSalePerson.jsp Bug No Samyak499 : "+ Samyak499+"Error on"+errLine);
		
}
%>







