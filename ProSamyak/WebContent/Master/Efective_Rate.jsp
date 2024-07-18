<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>


<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect"/>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array"/>
<jsp:useBean   id="G" class="NipponBean.GetDate" />
<jsp:useBean   id="FD" class="NipponBean.format" />
<%
			ResultSet rs_g= null;

			Connection cong = null;
			
			PreparedStatement pstmt_g=null;
			
			cong=C.getConnection();

			String user_id= ""+session.getValue("user_id");
			String user_level= ""+session.getValue("user_level");
			String machine_name=request.getRemoteHost();
			String company_id= ""+session.getValue("company_id");
			String yearend_id= ""+session.getValue("yearend_id");

			Boolean b=(Boolean)session.getValue("onBlurDescSize");
			boolean onBlurDescSize=b.booleanValue();	



%>

<HTML>
<TITLE> Edit Lot No</TITLE>
<HEAD>
	<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

</HEAD>
<SCRIPT LANGUAGE="JavaScript">
<!--

<%
	String message=request.getParameter("message");
	String Flag=request.getParameter("Flag");

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	
	String today_date=format.format(D);
	System.out.println("<br>55 today_date1="+today_date);
	
	//System.out.print("D="+D);
	java.sql.Date invoice_datetemp = new java.sql.Date(System.currentTimeMillis());

	String descQuery = "Select Description_Name from Master_Description where Active=1 order by Sr_No";
		
	pstmt_g = cong.prepareStatement(descQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String descArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			descArray += "\"" +rs_g.getString("Description_Name") +"\"";
		}
		else
		{
			descArray += "\"" +rs_g.getString("Description_Name") +"\",";
		}
	}
	pstmt_g.close();
	out.print("var descArray=new Array("+descArray+");");


	String sizeQuery = "Select Size_Name from Master_Size where Active=1 order by Sr_No";
		
	pstmt_g = cong.prepareStatement(sizeQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
	String sizeArray = "";
	while(rs_g.next()) 	
	{
		if(rs_g.isLast())
		{
			sizeArray += "\"" +rs_g.getString("Size_Name") +"\"";
		}
		else
		{
			sizeArray += "\"" +rs_g.getString("Size_Name") +"\",";
		}
	}
	pstmt_g.close();

	out.print("var sizeArray=new Array("+sizeArray+");");

	String lotNoQuery = "Select Lot_No from Lot where Active=1 and Company_Id="+company_id+" order by Lot_No";
		
	pstmt_g = cong.prepareStatement(lotNoQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();
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
	pstmt_g.close();
	out.print("var lotNoArray=new Array("+lotNoArray+");");
	C.returnConnection(cong);
%>
//-->
function CheckMe()
{
	//document.Efective_Rate.action="UpdateEffective_Rate.jsp?command=Go";
	//document.Efective_Rate.target="effrate_display";
	//document.Efective_Rate.submit();
}


</SCRIPT>

<BODY background="../Buttons/BGCOLOR.JPG">
<%
	int i=0;
	if("true".equals(Flag))
	{

//out.print("<br>173 message="+message);
%>
<H3 align=center><FONT color=red><%=message%></FONT><H3>
<%
	}
%>
<FORM name="Efective_Rate" action="UpdateEffective_Rate.jsp" target="effrate_display">
<TABLE border=1 bordercolor="skyblue" align=center cellspacing=0 cellpadding=2 >
	<TR>
	<TD>
	<TABLE border=1 align=center>
		<TR bgColor=skyblue align=center>
			<TD colspan=6>Lot No</TD>
		</TR>
		<TR>
			<TD>Lot No</TD>
			<TD><input type=text size=7 name=lotno<%=i%> value="" id=lotno<%=i%> style="text-align:left;" onblur="getDescSize('<%=company_id%>', document.Efective_Rate.lotno<%=i%>.value, document.Efective_Rate.datevalue.value, 'lotid<%=i%>','description<%=i%>', 'dsize<%=i%>', 'effrate<%=i%>', 'description<%=i%>', 'purchase' );CheckMe();" autocomplete=off accesskey='F8'></TD>
		<!-- <td>Description</td> -->
		<input type=hidden name=description<%=i%> size=7 value="" style="text-align:left" id=description<%=i%>>

		<!-- <td>Size</td> -->
		<input type=hidden name=dsize<%=i%> size=7 value=""  style="text-align:left" id=dsize<%=i%> 
		
		<%/*
		if(onBlurDescSize)
		{
			out.println("onblur=\"getLots('"+company_id+"', document.Efective_Rate.description"+i+".value, document.Efective_Rate.dsize"+i+".value, document.Efective_Rate.datevalue.value, 'lotid"+i+"','lotno"+i+"', 'effrate"+i+"', 'description"+i+"', 'purchase' ); \" ");
		}*/
		%>>		
		  
<input type=hidden name=effrate<%=i%> value="0" id=effrate<%=i%>>
<input type=hidden name=lotid<%=i%> value="0" id=lotid<%=i%>>
<input type=hidden name=datevalue value="<%=today_date%>" id=datevalue>

	</TR>
	<TR align=center>
	<!-- <TD colspan=2><INPUT type=submit name=command value="Go"></TD> -->
	<TD align=center colspan=6>
	<!-- <input type=Button name=command value="Go" class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> -->
	<input type='hidden' name='command' value='Go'>
	</td>
			
			<INPUT type=hidden name="abc" value="Yes">
		</TR>
		<script language="javascript">

			var lobj<%=i%> = new  actb(document.getElementById('lotno<%=i%>'), lotNoArray);
			
			var dobj<%=i%> = new  actb(document.getElementById('description<%=i%>'), descArray);
			
			var sobj<%=i%> = new  actb(document.getElementById('dsize<%=i%>'), sizeArray);

			function nochk(elem,deci){
				validate(elem, deci);
			}
		</script>	



	
	</TABLE>
	</TD>
	</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>