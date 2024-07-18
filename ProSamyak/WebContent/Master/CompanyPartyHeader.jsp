<!-- Consingment In Start 06-03-05 -->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />


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

<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<html>
<body>


<% 
ResultSet rs_g= null;
PreparedStatement pstmt_g=null;
Connection cong = null;
String user_name = ""+session.getValue("user_name");
int user_level = Integer.parseInt(""+session.getValue("user_level"));
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
try	
{	

	cong=C.getConnection();
}catch(Exception e31){ 
	C.returnConnection(cong);
out.println("<font color=red>Bug No e31 : "+ e31);}

%>
<!-----   For Add,Edit and Cancel Button ----->
<SCRIPT LANGUAGE="JavaScript">
var last_button_pressed="2";

function editCancel(no)
{
	if(no==1)
	{
		last_button_pressed="1";
		<%java.sql.Date inv_date1=new java.sql.Date(System.currentTimeMillis());%>	
		var str="../Master/NewCompanyPartyAccount.jsp?message=Default&account_no=Party";
		window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
	}//if(no==1)
	if(no==2)
	{
		
		last_button_pressed="2";
		
		if(document.new_mainform.account_type.value=="party_account")
		{
			if(document.new_mainform.cancel_invno.value!="")
			{
				var str="../Master/EditCompanyPartyAccount.jsp?CompanyParty_Id="+document.new_mainform.cancel_receiveid.value+"&command=PartySelected";
		
				window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
			
			}
		}
		
		if(document.new_mainform.account_type.value=="cash_account")
		{
			if(document.new_mainform.cancel_invno.value!="")
			{
				var str="../Master/EditCashBankAccount.jsp?command=SelectedAccountName&account_id="+document.new_mainform.cancel_receiveid.value+"&type=cash";
		
				window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
			
			}
		}
		
		if(document.new_mainform.account_type.value=="bank_account")
		{
			if(document.new_mainform.cancel_invno.value!="")
			{
				var str="../Master/EditCashBankAccount.jsp?command=SelectedAccountName&account_id="+document.new_mainform.cancel_receiveid.value+"&type=bank";
		
				
				window.open(str,"bottom", ["Top=100","Left=0","Toolbar=no", "Location=0","Menubar=yes","Height=600","Width=1200", "Resizable=yes","Scrollbars=yes","status=no"]);
			
			}
		}
	}//if(no==2)
	
	
} //editCancel
function checkDateValidity(ele)
{
	
	
	
} //checkMe()
function checkDate(th)
{
	
	if(document.new_mainform.cancel_invno.value!="")
	{
	//getNextCompanyParty(document.new_mainform.cancel_invno.value,'<%=company_id%>','Edit',document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,2);
	getNextCompanyParty_header(document.new_mainform.cancel_invno.value,'<%=company_id%>','Edit',document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,'2',document.new_mainform.account_type);
			
	return true;
	}
	
}

function setValue()
{
	
		document.new_mainform.cancel_invno.value="";
		document.new_mainform.cancel_invno.focus();
	
} //setValue
function getNextNo(s)
{
	getNextCompanyParty_header(document.new_mainform.cancel_invno.value,'<%=company_id%>',s,document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,'2',document.new_mainform.account_type)
		
	
}
function form_submit()
{
	last_button_pressed="2"; 
	getNextCompanyParty_header(document.new_mainform.cancel_invno.value,'<%=company_id%>','Edit',document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,'2',document.new_mainform.account_type)
	return false;
} 


//-->
</SCRIPT>

<form name='new_mainform' method='post' OnSubmit="return form_submit();">

<table width='100%'> 
<tr>
<td align='center'>
<table  border=1 bordercolor=#FFDCB9  cellpadding=2 cellspacing=2>
<tr bgcolor=#FFDCB9 width='100%'>
	<td ><input type=button name=command value="NEW" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" OnClick="editCancel(1);" style="width:60"></td>
	
	<input type='hidden' name='cancel_invno' onfocus="this.select();" value="" maxlength='10' size='15'  id=cancel_invno  autocomplete=off OnBlur="return checkDate(this);">
	
	<!-- <td ><input type=button name=command value="EDIT" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" OnClick="editCancel(2);"></td> -->
	
	<!-- <td >&nbsp;&nbsp;&nbsp;&nbsp;<input type=button name=CANCEL value="CANCEL" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" OnClick="editCancel(3);" ></td> -->
	
	
		
	<script language="javascript">
	<%
			try
			{
			String companyArray_temp ="";
			String companyArray="";
			String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where Active=1 and Company_Id="+company_id+" order by CompanyParty_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			 companyQuery = "Select Account_Name from Master_Account where Active=1 and Company_Id="+company_id+" order by Account_Name";
				
			pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
			rs_g = pstmt_g.executeQuery();
			
			while(rs_g.next()) 	
			{
				if(rs_g.isLast())
				{
					//Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\"";

				}
				else
				{
					///Party_Id += rs_g.getString("CompanyParty_Id");
					companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\",";
				}
			}
			pstmt_g.close();
			
			int len=companyArray_temp.length();
			String companyArray_tokenizer=companyArray_temp.substring(1,(len-1));
			String companyArray_sort[]=companyArray_tokenizer.split("\",\"");
			java.util.Arrays.sort(companyArray_sort,java.text.Collator.getInstance());
			
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(i==0)
				{
					companyArray=companyArray+"\""+companyArray_sort[i];
					
				}
				if(i==(companyArray_sort.length-1))
				{
					companyArray=companyArray+companyArray_sort[i]+"\"";
					
					break;
				}
				if(!(i==0)&&!(i==(companyArray_sort.length-1)))
				{
					if(i==1)
					{
					companyArray=companyArray+"\",\""+companyArray_sort[i]+"\",\"";
					}
					else
					{
					companyArray=companyArray+companyArray_sort[i]+"\",\"";
					
					}	
						
					
				}
			}
			out.print("var companyArray=new Array("+companyArray+");");
			C.returnConnection(cong);
			}
			catch(Exception e31)
			{ 
				C.returnConnection(cong);
				out.println("<font color=red>Bug No e31 : "+ e31);
			}

		%>
	</script>
	
		

		
		
		
		<input type='hidden' name='cancel_receiveid' value='0'>
		<input type='hidden' name='account_type' value='0'>
	
	<script language="javascript">
		
			var companyobj = new  actb(document.getElementById('cancel_invno'), companyArray);
			document.new_mainform.cancel_invno.value=companyArray[0];
			
			//getNextCompanyParty_header(document.new_mainform.cancel_invno.value,'<%=company_id%>','Edit',document.new_mainform.cancel_invno,document.new_mainform.cancel_receiveid,'2',document.new_mainform.account_type)
	</script>
	
	<td>
		<input type=button style='width:60' name=FIRST value="FIRST" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyFirst");'>
	</td>
	<td>
		<input type=button style='width:60' name=NEXT value="NEXT" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyNext");'>
	</td>
	<td>
		<input type=button  style='width:60' name=PREV value="PREV" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyPrev");'>
	</td>
	
	<td>
		<input type=button  style='width:60' name=LAST value="LAST" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" Onclick='getNextNo("PartyLast");'>
	</td>
	<td>
		
	</td>	

</tr>
</table> 
</td>
</tr>
</table>
</form>
<!----    End for Add,Edit and Cancel Button ---->
</body>
</html>