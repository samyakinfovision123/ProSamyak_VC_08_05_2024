<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<%
Connection conp=null;
PreparedStatement pstmt_p=null;
ResultSet rs_g=null;
ResultSet rs_p=null;

try{
	conp=C.getConnection();
	}catch(Exception e){out.print(e);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String yearend_id=""+session.getValue("yearend_id");
String company_name= A.getName(conp,"companyparty",company_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
java.sql.Date DS = Config.financialYearStart();
int dd=DS.getDate()-1;
//DS.setString(""+dd);
String today_string=format.format(D);

String text="jpg";
String servername=request.getServerName();

String command = request.getParameter("command");
//out.print(command);
String message=request.getParameter("message"); 
String lotcategory_id=request.getParameter("lotcategory_id");

if("Category".equals(command))
{

if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}


String query="";


//query="select * from Master_LotCategory where LotCategory_Name <>'Diamond' or LotCategory_Name <>'Jewelry' and Company_id=?" ;

try
{%>
<html>

<head>
<title>Samyak Software -India</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
	<form action="NewItem.jsp?message=Default" method=post name=mainform>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='50%'>
			<tr>
				<td><table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
					<tr bgcolor="skyblue">
					<th colspan=4 align=center>Select Item Category</th> </tr>
					<tr>
					<td width='25%'>Category</td>
					<td colspan=3 width='75%'> <%=A.getMasterArrayCondition(conp,"LotCategory","lotcategory_id","","where LotCategory_Name NOT IN ('Diamond','Jewelry') and Company_id="+company_id)%></td>
					</tr>
					<tr>
						<td colspan=4 align=center><input type=submit value=Next name=command class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
<%
	C.returnConnection(conp);	

} catch(Exception e) {out.print(e);}
						
}%>

<% 


/*if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}
*/
if("Next".equals(command))
{
try{
	
%>
<html>

<head>
<title>Samyak Software -India</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript src="..\Samyak\Samyakcalendar.js"></SCRIPT>
	<SCRIPT language=javascript src="..\Samyak\Samyakdate.js"></SCRIPT>

<script language=javascript>

function LocalValidate()
{
errfound = false;

if(document.mainform.lot_no.value == "")
	{
	alert("Please enter Lot No.");
	document.mainform.lot_no.focus();
	return errfound;
	}
	else
	{
		if(document.mainform.lot_name.value == "")
		{
				alert("Please enter Lot name.");
				document.mainform.lot_name.focus();
				return errfound;
		}

		else
		{

			return !errfound;
		}

	}

}	

function calcTotal(name)
{
//validate(name)
//alert ("Ok Inside CalcTotal");

if((document.mainform.amount.value=="0")||(document.mainform.amount.value==""))
{
document.mainform.amount.value=document.mainform.qty.value*document.mainform.rate.value;
//alert ("Ok Inside if");

}
if(document.mainform.rate.value=="0"){
	document.mainform.rate.value=document.mainform.amount.value  / document.mainform.qty.value;}

if(document.mainform.amount.value != ((document.mainform.qty.value)*(document.mainform.rate.value)))
{
if(document.mainform.amount.value > ((document.mainform.qty.value)*(document.mainform.rate.value)))
{	document.mainform.rate.value=document.mainform.amount.value  / document.mainform.qty.value;}

else{
document.mainform.amount.value=document.mainform.qty.value*document.mainform.rate.value;}
}//if
}

</script>
</head>

<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='document.mainform.lot_no.select();'>
	<form action="UpdateItem.jsp?message=Default" method=post name=mainform onsubmit="return LocalValidate();">
		<input type=hidden name=lotcategory_id value=<%=lotcategory_id%>>
		<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2 width='100%'>
			<tr>
				<td><table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
					<tr bgcolor="skyblue">
						<th colspan=4 align=center>Add New Item</th>  
					</tr>
					<tr>
						<td>Sub Category</td>
						<td colspan=3> <%=A.getMasterArrayCondition(conp,"LotSubCategory","lotsubcategory_id","","where lotcategory_id="+lotcategory_id+" and Company_Id="+company_id)%> </td>
					<tr><td>No <font class="star1">*</font></td>
						<td colSpan=1><input type=text name=lot_no size=6 value='1'></td>
						
						<td colspan=2>
<script language='javascript'>
//if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Created On' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
</script> 
								<input type=hidden name='datevalue' size=6 maxlength=10 value="<%=today_string%>" onblur='return  fnCheckDate(this.value,"Date")'>
						</td>
					<input type=hidden name=opdatevalue value="<%=format.format(DS)%>">	

					</tr>
					<tr>
						<td>Name <font class="star1">*</font></td>
						<td colSpan=3> <INPUT type=text name=lot_name size=27> </td>
					</tr>
					<tr><td>Description</td>
						<td colSpan=3> <INPUT type=text name=lot_description size=27> </td>
					</tr>
					<tr>
						<td>Reference</td>
						<td colSpan=3> <INPUT type=text name=lot_referance size=27> </td>
					</tr>
						<INPUT type=hidden name=lot_location size=27 value="Main">
<!-- 					<tr>
						<td>Location</font></td>
						<td colSpan=3> <INPUT type=text name=lot_location size=27 value="Main"> </td>
					</tr>
 -->					<tr>
						<td>Reorder Quantity</td>
						<td ><input type=text name=reorder_qty size="6" value="0" onblur='validate(this,3)' style="text-align:right"></td>
						<td> Unit of Measurement</td>
								<td><%=A.getMasterArrayCondition(conp,"Unit","unit_id","","where Company_Id="+company_id+"")%></td>
					</tr>
<%	
				int locCount=0;
		
		String query="select count(Location_Id) as counter from Master_Location where company_id="+company_id+" and Active=1";
		pstmt_p=conp.prepareStatement(query);
		try{
		rs_p=pstmt_p.executeQuery();
		}catch(Exception e) { out.print(e); }
		while(rs_p.next())
		{
			locCount=Integer.parseInt(rs_p.getString("counter"));
		}
 pstmt_p.close();

	if(locCount==1)
	{

%>
					<tr>
						<td colspan=13><table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
							<tr bgcolor="skyblue">
								<td colspan=13 align=center bgcolor=skyblue><b>Opening Stock  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><input type=checkbox name=os value="yes" checked> Check Here</td>
							</tr>
							<tr>
								<td>Currency</td>
								<td ><input type=radio name=currency value="Local" checked>Local
									<input type=radio name=currency value="Dollar" >Dollar
								</td>
								<td>Exchange Rate/$ <font class="star1">*</font></td>
								<td colspan=2><input type=text name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>' size=6 onblur='validate(this,2)' style="text-align:right"></td>
								<td>Location </td>
								<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where company_id="+company_id+" and Active=1")%><input type=hidden name=location_id value="<%=A.getNameCondition(conp,"Master_Location","Location_Id","where company_id="+company_id+" and Active=1") %> "></td>

							</tr>
							<tr>
								
								
								<td>Quantity <font class="star1">*</font></td>
								<td><input type=text name=qty value="0" onblur='validate(this,3)' size="6" style="text-align:right"></td>
								<td>Rate/Unit</td>
								<td colspan=2><input type=text name=rate value="1" size="6" style="text-align:right"></td>
							
								<td colspan=1 align=left>Amount</td>
								<td colspan=2 align=left><input type=text name=amount value="0" OnBlur='return calcTotal(this)' size="6" style="text-align:right"></td>
							</tr>
							
							</table>
						</td>
					</tr>
<%
}

else
	{%>
			<input type=hidden name=os value="No">
<%	}
						
%>				</table>
				</td>
			</tr>
			<tr>
				<td colspan=13 align=center><input type=submit name=command value="ADD" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
			</tr>
		</table>
	</form>
</body>
</html>

<%

 C.returnConnection(conp);
}catch(Exception e){out.print(e);}}%>
