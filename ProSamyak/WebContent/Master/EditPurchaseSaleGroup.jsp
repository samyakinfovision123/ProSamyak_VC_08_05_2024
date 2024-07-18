<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"    class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="I"    class="NipponBean.Inventory" />

<%
	String user_id= ""+session.getValue("user_id");
	String user_level= ""+session.getValue("user_level");
	String machine_name=request.getRemoteHost();
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	//String purchasesalegroup_type = request.getParameter("purchasesalegroup_type");
	

	Connection conp = null;
	Connection cong = null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;
	ResultSet rs_p = null;

try
{
	conp=C.getConnection(); 	
	cong=C.getConnection(); 	

	String company_name= A.getName(conp,"companyparty",company_id);
	String local_symbol= I.getLocalSymbol(conp,company_id);
	String local_currency= I.getLocalCurrency(conp,company_id);
	String base_exchangerate= I.getLocalExchangeRate(conp,company_id);

	int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
	
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	
	String command = request.getParameter("command");
	//	out.print("<br>"+command);

%>

<html>
<head>
<title>Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<script>
function Validate()
	{
	errfound = false;

	if(document.mainform.purchasesalegroup_name.value == "")
		{
		alert("Please enter PurchaseSale Group's name.");
		document.mainform.purchasesalegroup_name.select();
		return errfound;
		}
	else 
		{
			var tempA=document.mainform.purchasesalegroup_name.value;
			if(tempA.length < 4)
				{
				alert("Please enter PurchaseSale Group's name Properly. Must be more than three characters");
				document.mainform.purchasesalegroup_name.select();
				return errfound;
				}
			else
				{
				return !errfound;
				}
       }
}//validate
</script>

<SCRIPT language=javascript src="../Samyak/Samyakdate.js"></script>
<SCRIPT language=javascript src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_layers.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../Samyak/lw_menu.js"></SCRIPT>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">

</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<% 
	if("Default".equals(command))
	{
%>

<form name=PurchaseSaleGroupType  action=EditPurchaseSaleGroup.jsp method=post>

<% 
	String message=request.getParameter("message"); 
//	out.print("<br> 87 message = "+message);

	String view =request.getParameter("view"); 
//	out.print("<br> 96 view = "+view);

	if("Default".equals(message))
	{}
	else
	{
		out.println("<center><font class='message1'> "+message+"</font></center>");
	}

%>
	<br>
	<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
	<tr><td>
	<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
	<tr bgcolor=skyblue><th colspan=4>Edit PurchaseSale Group </th>
	</tr>
	<tr><td>Select PurchaseSale Group Type</td>
	<td>
		<select name=purchasesalegroup_type>
			<option value='0'>Sales - Debitors</option>
			<option value='1'>Purchase - Creditors</option>
		</Select>
	</td>
	</tr>
	<tr>
		<td align=center colspan="2"><input type=submit value='Edit' name=command class='Button1' onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
	</td>
	</tr>
		<input type=hidden name=linkview value=<%=view%>>
</TABLE>
</td>
</tr>
</table>
</form>

<%
	}//end default
%>


<%

if("Edit".equals(command))
{
	String purchasesalegroup_type=request.getParameter("purchasesalegroup_type");

	String linkview=request.getParameter("view");
	
	String Query = "";

	if("yes".equals(linkview))
	{
		Query = "select * from Master_PurchaseSaleGroup where  company_id= "+company_id+" and  Active=1 and PurchaseSaleGroup_Type="+purchasesalegroup_type+" order  by  PurchaseSaleGroup_Name";
	}
	else
	{
		Query = "select * from Master_PurchaseSaleGroup where  company_id= "+company_id+" and  PurchaseSaleGroup_Type="+purchasesalegroup_type+" order  by  PurchaseSaleGroup_Name";
	}

	pstmt_p  = conp.prepareStatement(Query);
	rs_g = pstmt_p.executeQuery();
	int counter =0;
	while(rs_g.next())
	{counter++;}
//	out.println(counter);
	pstmt_p.close();
	int m =0;
	String purchasesalegroup_id[]=new String[counter] ;
	String purchasesalegroup_name[]=new String[counter] ;
		
	pstmt_p  = conp.prepareStatement(Query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
		{
		purchasesalegroup_id[m]= rs_g.getString("PurchaseSaleGroup_Id");
		purchasesalegroup_name[m]=rs_g.getString("PurchaseSaleGroup_Name");
		m++;
		}
	pstmt_p.close();
%>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 >
<tr><td>
<table borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<th colspan=4 bgcolor="skyblue">Select PurchaseSale Group Name for Edit</th>
</tr>

<tr>
<th>Sr No </th>
<th>PurchaseSale Group Name </th>
</tr>

<% 
int j=1;
for(m=0; m<counter; m++)
{
%>
<tr>
<td align="center"><%=j++%></td>

<%
	if("yes".equals(linkview))
	{
%>
<td><%=purchasesalegroup_name[m]%></td>
<%
	}
	else
	{
%>

<td>
	<a  href="EditPurchaseSaleGroup.jsp?command=SelectedPurchaseSaleGroupName&purchasesalegroup_id=<%=purchasesalegroup_id[m]%>"> 
<%=purchasesalegroup_name[m]%> </a>
</td>

<%
		}
%>
	
	
</tr>
<%
	}// endof for m loop
}	//endif of edit.equals(command)	

%>


<%
if("Edit1".equals(command))
{

	
	String purchasesalegroup_id = request.getParameter("purchasesalegroup_id");
	//out.print("<br> purchasesalegroup_id="+purchasesalegroup_id);
	if("0".equals(purchasesalegroup_id))
	{
		out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><BODY background=../Buttons/BGCOLOR.JPG><center><font color=red><h6>Please Select Group Person Name</h6><input type=button name=command value='BACK' class='button1' onClick='history.go(-1)'  ></center>");
	}else
		{
	String message3=request.getParameter("message3"); 
	//out.print("<br> 87 message = "+message3);
	String purchasesalegroup_name="";
	String purchasesalegroup_type="";
	String purchasesalegroup_code="";
	String tempCheck="";
	String active="";


	String EditQuery = "select * from Master_PurchaseSaleGroup where PurchaseSaleGroup_Id="+purchasesalegroup_id;
	//out.println(EditQuery);
	pstmt_p  = conp.prepareStatement(EditQuery);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next())
	{
		purchasesalegroup_name=rs_g.getString("PurchaseSaleGroup_Name");
		purchasesalegroup_type=rs_g.getString("PurchaseSaleGroup_Type");
		purchasesalegroup_code=rs_g.getString("PurchaseSaleGroup_Code");
		active=rs_g.getString("Active");
		if("1".equals(active))
		{
			tempCheck = " checked " ;
		}
	}
	pstmt_p.close();

	String ActiveQuery = "select count(*)as counter from receive_transaction where receive_id in(select receive_id from receive where company_id="+company_id+" and purchasesalegroup_id="+purchasesalegroup_id+" and Active=1)and  Active=1";
	


		pstmt_g = cong.prepareStatement(ActiveQuery);
		rs_p= pstmt_g.executeQuery();
		int count=0;
		while(rs_p.next())
		{
			count=rs_p.getInt("counter");
		}
		pstmt_g.close();
	//	out.print(" 234 count="+count);
%>

<form name=mainform  action="UpdatePurchaseSaleGroup.jsp" method=post onsubmit="return Validate();">
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<%
	if(message3 == null)
		{
		}else
		{
			out.println("<center><font class='message1'> "+message3+"</font></center>");
		}
	
%>
	<BR>
<TABLE borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<TABLE borderColor=#D9D9D9 border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr align=center bgcolor="skyblue">
<%
	if("0".equals(purchasesalegroup_type))
		{
%>
	<th align=center colspan="2">Edit Sale Group</th>
<%
		}else
			{
%>
	<th align=center colspan="2">Edit Purchase Group</th>
<%
			}
%>
</tr>
<input type=hidden size=20 name="purchasesalegroup_id" value="<%=purchasesalegroup_id%>" >
<input type=hidden size=20 name="purchasesalegroup_type" value="<%=purchasesalegroup_type%>" >

<tr>
<%
	if("0".equals(purchasesalegroup_type))
		{
%>
	<td>Sale Group Name <font class="star1">*</font></td>
<%
		}else
			{
%>
<td>Purchase Group Name <font class="star1">*</font></td>
<%
			}
%>
	<td colspan=3> <input type=text size=40 name=purchasesalegroup_name value="<%=purchasesalegroup_name%>"></td>
</tr>
<tr>
<%
	if("0".equals(purchasesalegroup_type))
		{
%>
	<td >Sale Group Code<font class="star1"></font> </td>
<%
		}else
			{
%>
	<td >Purchase Group Code<font class="star1"></font> </td>
<%}%>
	<td ><input type=text size=20 name=purchasesalegroup_code value="<%=purchasesalegroup_code%>"></td>
</tr>

<tr>
<%
	if(count==0)
		{
%>
	<td> Active</td> 
	<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>
<%
	}
	else
	{
%>
<td></td> 
<td><input type=hidden name=active value=yes <%=tempCheck%>></td>

<%}%>
</tr>
<tr>
	<td align=center colspan="2"><input type=submit value='SAVE' name=command class='Button1' >
	</td>
</tr>
</table> 
</table> 
</form>

<%
		}}// endif SelectedAccountName
C.returnConnection(conp);
C.returnConnection(cong);
}// try end
catch(Exception e233)
{ 
	C.returnConnection(conp);
	C.returnConnection(cong);

	out.print("<font color=red> FileName : EditPurchaseSaleGroup.jsp <br>Bug No e233 :"+ e233 +"</font>");
}//catch end

%>
</body>
</html>







