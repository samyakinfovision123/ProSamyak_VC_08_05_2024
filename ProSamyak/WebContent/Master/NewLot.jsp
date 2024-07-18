<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="AC"   class="NipponBean.ArrayCSS" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />

<% int samyakerror=0;

Connection conp = null;
ResultSet rs_g = null;
PreparedStatement pstmt_p = null;
try	{
	conp=C.getConnection();
	}
catch(Exception e31){ 
	out.println("<font color=red> Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String company_name= A.getName(conp,"companyparty",company_id);
 String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String text="jpg";
String servername=request.getServerName();


//out.print("<br>2");
//out.print("<br>text="+text);

String today_string=format.format(D);
String condition="where Company_Id="+company_id;
java.sql.Date DS = Config.financialYearStart();
int dd=DS.getDate()-1;
//DS.setString(""+dd);

String command = request.getParameter("command");
String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
String lot_id=""+ L.get_master_id(conp,"Lot");
try{
%>
<html>
<head>
<title>Samyak Software - India</title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>

<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>

<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>


<SCRIPT LANGUAGE="JavaScript">

<%
String lotNoQuery = "Select Lot_No from Lot where Active=1 and  Company_Id="+company_id+" order by Lot_No";
		
	pstmt_p = conp.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_p.executeQuery();
	String lotNoArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\"";
		}
		else
		{
			lotNoArray += "\"" +rs_g.getString("Lot_No") +"\",";
		}
	}
	pstmt_p.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");


%>

function tbnew(str)
{
window.open(str,"_blank", ["Top=70","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=400","Width=500", "Resizable=yes","Scrollbars=yes","status=no"])
}




</SCRIPT>
<script language='javascript'>
var errfound = false;


function calAmount()
	{
		document.mainform.rate.value
	}

function LocalValidate()
	{
	errfound = false;
	if(isNaN(document.mainform.test_amt.value))
				{
				alert("Please enter Quantity & Rate Properly.");
				return false;
				}
			else
				{
				return !errfound;
				}
		
	}

function calcTotal(name)
{
//validate(name)
//if("dollar".equals(currency)

//if(


//alert ("Ok Inside CalcTotal");
//alert ("This is Dollar Amt.");
document.mainform.dollar_amt.value=(document.mainform.carats.value*document.mainform.rate.value);

var tempDollarValue = parseFloat(document.mainform.dollar_amt.value);
tempDollarValue = tempDollarValue.toFixed(<%=d%>);
document.mainform.dollar_amt.value = tempDollarValue;
//alert("After Dollar calculation");

//alert ("This is Local Amt.");

document.mainform.local_amt.value=(document.mainform.carats.value*document.mainform.rate.value)*(document.mainform.exchange_rate.value);
//alert("After Local calculation");

var tempLocalValue = parseFloat(document.mainform.local_amt.value);
tempLocalValue = tempLocalValue.toFixed(<%=d%>);
document.mainform.local_amt.value = tempLocalValue;

if(document.mainform.rate.value=="0"){
	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

if(document.mainform.test_amt.value != ((document.mainform.carats.value)*(document.mainform.rate.value)))
{
if(document.mainform.test_amt.value > ((document.mainform.carats.value)*(document.mainform.rate.value)))
{	document.mainform.rate.value=document.mainform.test_amt.value  / document.mainform.carats.value;}

else{
document.mainform.test_amt.value=document.mainform.carats.value*document.mainform.rate.value;}
}//if
}


function show()
{
	var el = document.getElementById("info_span1");
	if(document.mainform.specification.checked)
	{
		el.style.display="block";
	}
	else
	{
		el.style.display="none";
	}
	
	
}

</script>

</head>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG" onload='show();document.mainform.lot_no.select();'>
<form action="UpdateLot.jsp" method=post name=mainform onsubmit="return LocalValidate();">
<table align=center bordercolor="skyblue" border=1 cellspacing=0 cellpadding=2 width='100%' >
<tr><td>
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor="skyblue">
<th colspan=4 align=center>
Add New Diamond Lot
</th>  
</tr>
<tr>
	<td>&nbsp;</td>
	<td >
		Ref. No <font class="star1">*</font>
	</td>
	<td colSpan=3>
		<input type=text name=lot_no id=lot_no size=6 value='' autocomplete=off>
		<script language="javascript">

			var lobj = new  actb(document.getElementById('lot_no'), lotNoArray);
			
		</script>	
		<script language='javascript'>
		//if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Created On' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
		</script> 
		<input type=hidden name='datevalue' size=6 maxlength=10 value="<%=today_string%>" onblur='return  fnCheckDate(this.value,"Date")'>	
		<input type=hidden name=datevalue1 value="<%=format.format(DS)%>">	
	</td>

</tr>
<!-- <tr>
    <td>Name <font class="star1">*</font></td>
    <td colSpan=3> <INPUT type=text name=lot_name size=30> </td>
</tr> -->
<!-- <tr>
    <td>Company </td>
    <td colSpan=3><%=company_name%></td>
</tr> -->

<tr>
    <td >Description <font class="star1">*</font>
    <a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Description')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<td>

		<%//=A.getMasterArray(conp,"Description","Description_Id","") %>

	<%=A.getMasterArray(conp,"Description","Description_Id' style='width:125;","") %>
	</td> 
	
 <td>Size <font class="star1">*</font>	 <a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Size')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
 <td><%//=A.getMasterArrayCondition(conp,"Size","may","","")%>
	<%=A.getMasterArray(conp,"Size","Size_Id' style='width:125;","")
	 %> 
<%//=A.getMasterArray(conp,"Size","Size_Id","") %>
</td>

</tr>
<!--	   <INPUT type=hidden name=lot_location size=30 value="Main"> 
-->
<!-- <tr>
    <td>Location</font></td>
    <td colSpan=3> <INPUT type=text name=lot_location size=30 value="Main"> </td>
</tr>
 -->	
<tr><td>Group
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Group')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<td> 
  <%//=A.getMasterArrayCondition(conp,"GroupCode","may","","")%>
 <%=A.getMasterArraySrNo(conp,"Group","Group_Id' style='width:125;","") %>

<%//=A.getMasterArray(conp,"Group","Group_Id","") %>

<!--
public String getMasterArrayCondition(Connection con, String table, String html_name,String str,String condition)
-->
</td>

<td>Owner Category<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=OwnerCategory')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
 <td>
<%=A.getMasterArraySrNo(conp,"OwnerCategory","OwnerCategory_Id' style='width:125;","") %>

<%//=A.getMasterArray(conp,"OwnerCategory","OwnerCategory_Id","") %>




</td>
</tr>
<!-- <tr>
	<td>Selling Price</td>
	<td>US $ --><Input type="hidden" name="selling_price" style="text-align:right" size=5 value=0>
	<!-- Rs.<Input type="text" name="Rs" style="text-align:right" size=5></td> -->
	<!-- <td>Purchase Price</td>
	<td>US $ --><Input type="hidden" name="purchase_price" style="text-align:right" size=5 value=0>
	<!-- Rs.<Input type="text" name="Rs" style="text-align:right" size=5> --><!-- </td>
</tr> -->

<tr>

	<td>Shape
		<a	href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Shape')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<%//=A.getMasterArrayCondition(conp,"Shape","may","","")%>
<%=A.getMasterArraySrNo(conp,"Shape","Shape_Id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Shape","Shape_Id","") %>	
	
	</td>
	
	<td>Cut
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Cut')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<%//=A.getMasterArrayCondition(conp,"Cut","may","","")%>
<%=A.getMasterArraySrNo(conp,"Cut","Cut_Id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Cut","Cut_Id","") %>	


</td>
<td>Color
		<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Color')"><img src="../Buttons/add.jpg" height="10" width="10"></a>

<%=A.getMasterArraySrNo(conp,"Color","Color_Id' style='width:125;","") %>
</td>
<td>Purity (Clarity)
<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Purity')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<%=A.getMasterArraySrNo(conp,"Purity","Purity_Id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Purity","Purity_Id","") %>
</td>
</tr>
</TABLE>
<%//----------Opening Stock Detail ------------%>
<%	
				int locCount=0;
		//PreparedStatement pstmt_p = null;
		ResultSet rs_p=null;
		
		 query="select count(Location_Id) as counter from Master_Location where company_id="+company_id+" and Active=1";
		 //out.print("<br>query="+query);
		pstmt_p=conp.prepareStatement(query);
		try{
		rs_p=pstmt_p.executeQuery();
		}catch(Exception e) { out.print(e); }
		while(rs_p.next())
		{
			//locCount=Integer.parseInt(rs_p.getString("counter"));
			locCount=1;
		}
pstmt_p.close();
	if(locCount==1)
	{

%>


<tr><td colspan=2>
<table border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr bgcolor=skyblue>
<th colspan=6 align="center" ><b>Opening Stock Details</b> <Input type=checkbox name=os value=yes checked OnClick='this.checked=true'><b> Check Here
</th>	
</tr>
<tr>
<!-- <td align="left" colspan=1>Currency  <input type=radio name=currency value=local checked> Local <input type=radio name=currency value=dollar>Dollar
</td> -->
<td colspan=1 align="left">Exchange Rate/$ <font class="star1">*</font></td>
	<td>   <input type=text  name=exchange_rate value='<%=str.format(I.getLocalExchangeRate(conp,company_id))%>' size=7 align ="left" onblur='validate(this,3)' style="text-align:right">
</td>
<td>Location </td>
<td>Main
		

<input type=hidden name=location_id0 value="<%=A.getNameCondition(conp,"Master_Location","Location_Id","where company_id="+company_id+"and location_name='Main'  and Active=1") %> ">

</td>


<!--<td>	</td>
-->
<!-- 
<td><%//=A.getMasterArrayCondition("Location","Location_Id","","where company_id="+company_id+" order by location_id")%></td> -->
</tr>


 <!--<td>Pcs. <!-- <font class="star1">*</font><br> --><input type= hidden name=diamonds size=7 style="text-align:right" value='0' onblur='validate(this,0)'> <!-- </td> -->
 <tr>
<td>Quantiy (Carats)<font class="star1">*</font><br><input type= text name=carats size=7 style="text-align:right" value='0'  OnBlur='validate(this,3)'> </td>
<td>Rate/Unit(US-$)<br>
<input type=text name=rate value='1' size=7 style="text-align:right"  OnBlur='return calcTotal(this)'> 
&nbsp;&nbsp;</td>
<td colspan=1>Amount(US-$)<br><input type=text name=dollar_amt value="0"  size=10 style="text-align:right" OnBlur='return calcTotal(this)'></td>
<td colspan=1>Amount(<%=local_symbol%>) <br><input type=text name=local_amt value="0"  size=10 style="text-align:right" OnBlur='return calcTotal(this)'></td>
</tr>
<%
}
else
{%>
	<input type=hidden name=os value="No">
<%}
%>
<input type=hidden name=test_amt value="0"  size=10 style="text-align:right">
<tr align=center>
<th colspan=2 align=center>
<input type=submit
  name=command  value='ADD LOT' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</th>
<th colspan=2 align=center>
<input type=submit  name=command  value='EDIT LOT' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> 
</th>
</tr>
</table>
</td>
</tr>

<tr>
<th colspan=6 align=center bgcolor=skyblue >Specifications&nbsp;<Input type=checkbox name=specification  OnClick='show();'><b> Check Here</th>
</tr>

<tr>
<td colspan=2>
<span id="info_span1">
<table  border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >
<tr>
<td>Diameter</td><td><input type=text name=diameter value=0 size=7 style="text-align:right" onblur='validate(this,3)' ></td>
<td>Weight<br></td>
	<td><input type=text name=weight value=0 size=7 style="text-align:right" onblur='validate(this,3)'></td>


	</tr>
<tr>

	<td>Flourescene
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Fluorescence')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	<br>	<%//=A.getMasterArrayCondition(conp,"Fluorescence","may","","")%>
	<%=A.getMasterArraySrNo(conp,"Fluorescence","Fluorescence_Id' style='width:125;","") %>
	
	<%//=A.getMasterArray(conp,"Fluorescence","Fluorescence_Id","") %>
	
	
	
	
	</td>


	<td>Lab
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Lab')"><img src="../Buttons/add.jpg" height="10" width="10"></a>		
	<br>
		<%//=A.getMasterArrayCondition(conp,"Lab","may","","")%> 
<%=A.getMasterArraySrNo(conp,"Lab","Lab_Id' style='width:125;","")%>

<%//=A.getMasterArray(conp,"Lab","Lab_Id","") %>


</td>
	<td>Polish
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Polish')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
<br>
		<%//=A.getMasterArrayCondition(conp,"Polish","may","","")%>
	
	<%=A.getMasterArraySrNo(conp,"Polish","Polish_Id' style='width:125;","")%>
	<%//=A.getMasterArray(conp,"Polish","Polish","") %>

	
	
	
	</td>

<td>Symmetry
	
<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Symmetry')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
	<br>
	<%//=A.getMasterArrayCondition(conp,"Symmetry","may","","")%>
<%=A.getMasterArraySrNo(conp,"Symmetry","Symmetry_Id' style='width:125;","")%>
	<%//=A.getMasterArray(conp,"Symmetry","Symmetry_Id","") %>



</td>
</tr>

<tr>
<td >TableIncusion
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=TableIncusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>	
<br>
<%//=A.getMasterArrayCondition(conp,"TableIncusion","may","","")%>
<%=A.getMasterArraySrNo(conp,"TableIncusion","TableIncusion_Id' style='width:125;","")%>

<%//=A.getMasterArray(conp,"TableIncusion","TableIncusion_Id","") %>


</td>



<td>Luster
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Luster')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<br>
	<%=A.getMasterArraySrNo(conp,"Luster","luster_id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Luster","luster_id","") %>
	
	</td>

<td >Country Of Origin
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Country')"><img src="../Buttons/add.jpg" height="10" width="10"></a>
<br>
	<%//=A.getMasterArrayCondition(conp,"Country","may","","")%>

<%=A.getMasterArraySrNo(conp,"Country","Country_id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Country","Country_id","") %>


</td>
<td colspan=3>Shade
	<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Shade')"><img src="../Buttons/add.jpg" height="10" width="10"></a>		

<br>
	<%=A.getMasterArraySrNo(conp,"Shade","shade_id' style='width:125;","") %>
	<%//=A.getMasterArray(conp,"Shade","shade_id","") %>	
	
	</td>

</tr>
<tr>
<td>Black Inclusion<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Blackinclusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>		
<br>
	<%//=A.getMasterArrayCondition(conp,"Blackinclusion","may","","")  %>
<%=A.getMasterArraySrNo(conp,"Blackinclusion","Blackinclusion_id' style='width:125;","") %>
<%//=A.getMasterArray(conp,"Blackinclusion","Blackinclusion_id","") %>	

</td>
<td colspan=5>Open Inclusion<a href="javascript:tbnew('../Master/NewMaster.jsp?message=Default&MASTER=Openinclusion')"><img src="../Buttons/add.jpg" height="10" width="10"></a>		
<br>  
	<%=A.getMasterArraySrNo(conp,"Openinclusion","openinclusion_id' style='width:125;","") %>

<%//=A.getMasterArray(conp,"Openinclusion","openinclusion_id","") %>	

</td>
</tr>
</table>
</td>
</tr>


</table>
</td></tr>
</table>
</span>
</form>
</body>
</html>
<% 
   C.returnConnection(conp);	
}catch(Exception Samyak170)
	{ 
	C.returnConnection(conp);
	out.println("<font color=red> FileName : NewLot.jsp <br>Bug No Samyak170 :"+ Samyak170 +"</font>");
	}
	%>







