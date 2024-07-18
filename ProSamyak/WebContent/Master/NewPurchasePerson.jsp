<!-- Consingment In Start 06-03-05 -->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />
<%
String errLine="14";
%>
<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/Samyakdate.js"></script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/ReceiveID_Number.js"></script>
<script language=javascript src="../Samyak/PurchasePerson.js"></script>


<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<html>
<body>


<% 
try{
 errLine="40";

	ResultSet rs_g= null;
	Connection cong = null;
	PreparedStatement pstmt_g=null;
	cong=C.getConnection();

	String user_name = ""+session.getValue("user_name");
	int user_level = Integer.parseInt(""+session.getValue("user_level"));
	
	errLine="22";
	
	String company_id= ""+session.getValue("company_id");
	String yearend_id= ""+session.getValue("yearend_id");
	%>
<script language="javascript">

	
	<%
		errLine="72";
			String PurchasePersonArray = "";
			String PurchasePersonId = "";
			String PurchasePersonQuery = "Select SalesPerson_Name,SalesPerson_Id from Master_SalesPerson where Active in(1,0) and Company_Id="+company_id+" and purchasesale=1 order by SalesPerson_Name";
		errLine="76";		
			pstmt_g = cong.prepareStatement(PurchasePersonQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					PurchasePersonId += "\"" +rs_g.getString("SalesPerson_Id")+"\"";
					PurchasePersonArray += "\"" +rs_g.getString("SalesPerson_Name")+"\"";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					PurchasePersonId +="\"" +rs_g.getString("SalesPerson_Id")+"\",";
					PurchasePersonArray += "\"" +rs_g.getString("SalesPerson_Name") +"\",";
				}
			}
			pstmt_g.close();
		errLine="223";	
			out.print("var PurchasePersonArray=new Array("+PurchasePersonArray+");");
			//out.print("var LocationId=new Array("+LocationId+");");
		%>
	
	</script>
		<%
errLine="24";
	
	String lastInvoice_No=A.getNameCondition(cong, "Receive", "Receive_No", "where Active=1 and Purchase=1 and Receive_Sell=1 and R_Return=0 and Opening_Stock=0 and STockTransfer_Type=0 and company_id="+company_id+" order by Receive_Id");
	
	java.sql.Date lastInvoice_Date=new java.sql.Date(System.currentTimeMillis());
	
	lastInvoice_Date=YED.getDate(cong, "Receive", "Receive_Date", "where Active=1 and Purchase=1 and Receive_Sell=1 and R_Return=0 and Opening_Stock=0 and STockTransfer_Type=0 and company_id="+company_id+" order by Receive_Id");
	
	C.returnConnection(cong);
%>

<!-----   For Add,Edit and Cancel Button ----->

<SCRIPT LANGUAGE="JavaScript">
var last_button_pressed="5";

function editCancel(no)
{
	if(no==1)
	{
		last_button_pressed="1";
		
		<%java.sql.Date inv_date1=new java.sql.Date(System.currentTimeMillis());%>	

		var str="../Master/SalesPerson.jsp?command=Default&message=Purchase";
		
		window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
	}//if(no==1)
	
	if(no==2)
	{
		last_button_pressed="2";
	
	//	var str="../Master/EditSalesPerson.jsp?command=edit&message=Purchase";
//var str="../Master/EditPurchasePerson.jsp?command=Default&salesperson_id="+document.new_mainform.cancel_receiveid.value;
var str="../Master/EditSalePurchaseBrokerPerson.jsp?command=Default&salepurchasebroker_id=1&salesperson_id="+document.new_mainform.cancel_receiveid.value;

		window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
	
	}//if(no==2)

	
	if(no==3)
	{
		last_button_pressed="3";	
		
		var str="../Master/EditSalesPerson.jsp?command=edit&message=Purchase&Purchaseview=yes";

		window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);

	}//if(no==3)

} //editCancel

function form_submit()
{
	last_button_pressed="2"; 

	getNextPurchasePerson_header(document.new_mainform.cancel_invno.value,'<%=company_id%>','Edit',document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,last_button_pressed);
	return false;
} 
function check()
{
	getNextPurchasePerson_header(document.new_mainform.cancel_invno.value,'<%=company_id%>',"Edit",document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,last_button_pressed);
		
	
}
function getNextNo(s)
{	
	
	getNextPurchasePerson_header(document.new_mainform.cancel_invno.value,'<%=company_id%>',s,document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,last_button_pressed);

	
}


</SCRIPT>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">
<form name='new_mainform' method='post' OnSubmit="return form_submit();">

<center>
<table  border=1 bordercolor=#FFDCB9  cellpadding=2 cellspacing=2>

<tr bgcolor=#FFDCB9>
	<td>
		<input type=button name=command value="NEW" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick="editCancel('1')">
	</td>
	<td>
	


		<input type='text' name='cancel_invno' onfocus="this.select();" value="" maxlength='10' size='15'  id=cancel_invno  autocomplete=off OnBlur="check();">
		
		<input type='hidden' name='cancel_receiveid' value="0">
		<input type='hidden' name='cancel_locationid' value="">
	</td>
	
<SCRIPT LANGUAGE="JavaScript">

var PurchasePersonobj = new  actb(document.getElementById('cancel_invno'), PurchasePersonArray);



</SCRIPT>


<%
	if(user_level == 5)
	{
%>
	<td >&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=button name=command value="EDIT" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick="editCancel('2')">
	</td>
<%
	}
	else
	{
%>
	<td >&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=button name=command value="EDIT" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick="editCancel('2')" disabled>
	</td>

<%
	}
%>

	<td >&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=button name=CANCEL value="VIEW" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onClick="editCancel('3')" >
	</td>
	<td>
		<input type=button style='width:80' name=FIRST value="FIRST" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyFirst");'>
	</td>
	<td>
		<input type=button style='width:80' name=NEXT value="NEXT" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyNext");'>
	</td>
	<td>
		<input type=button  style='width:80' name=PREV value="PREV" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyPrev");'>
	</td>
	
	<td>
		<input type=button  style='width:80' name=LAST value="LAST" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyLast");'>
	</td>
 </tr>
</table> 
<%
}catch(Exception Samyak499)
{ out.println("<br><font color=red> FileName : NewPurchasePerson.jsp Bug No Samyak499 : "+ Samyak499+"Error on"+errLine);
}
%>
</center>
</form>
<!----    End for Add,Edit and Cancel Button ---->
</body>
</html>
