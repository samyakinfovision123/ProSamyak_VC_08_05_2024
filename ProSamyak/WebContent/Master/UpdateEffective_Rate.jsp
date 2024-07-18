<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.* " %>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect"/>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array"/>
<jsp:useBean   id="G" class="NipponBean.GetDate" />
<jsp:useBean   id="FD" class="NipponBean.format" />
<%    
			ResultSet rs_p= null;

			Connection conp = null;
			
			PreparedStatement pstmt_p=null;
			
			conp=C.getConnection();
			int tot=0;
//////////////////////////////////////////////

			String user_id= ""+session.getValue("user_id");
			String user_level= ""+session.getValue("user_level");
			String machine_name=request.getRemoteHost();
			String company_id= ""+session.getValue("company_id");
			String yearend_id= ""+session.getValue("yearend_id");
		//out.println("<br>comapny_id="+company_id);
			
			
			String user_name=""+A.getName(conp,"User", user_id);

		String command  = request.getParameter("command");
//out.print("<br>29 Command="+command);
/////////////////////////////////////////////////////
	        String Lot_No1 = request.getParameter("Lot_No");
	        //String Lot_No111 = request.getParameter("lotno0");



//out.print("<br>32 Lot_No111="+Lot_No111);

			String active=request.getParameter("abc");
   
			java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	

			


			java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());



		
		     String	Lot_No = request.getParameter("Lot_No");
			//out.print("<br>48 Lot_No="+Lot_No);

			String equery="select count(*) as ctot from Lot where Lot_No='"+Lot_No+"' And Active=1";

			pstmt_p=conp.prepareStatement(equery);
			rs_p=pstmt_p.executeQuery();

			while(rs_p.next())
			{
				tot=rs_p.getInt("ctot");
			}

			


	//String command = request.getParameter("command");

	//conp = C.getConnection();
	String EffectiveRate_Id= ""+L.get_master_id(conp,"Effective_Rate");
	String Lot="";

	C.returnConnection(conp);	



try{



	if("Save".equals(command))
	{  
		
		conp = C.getConnection();


		String Lot_Id=request.getParameter("Lot_Id");
		//out.print("<br>100 Lot_Id="+Lot_Id);
		String Effective_Date=request.getParameter("datevalue");
		String Selling_Price=request.getParameter("Selling_Price");
		String Purchase_Price=request.getParameter("Purchase_Price");
		String P3=request.getParameter("P3");
		String P4=request.getParameter("P4");
		String P5=request.getParameter("P5");


// date check for 

		int total_count1=0;

		String check_query1="select count(*) Total from Effective_Rate where Effective_Date='"+format.getDate(Effective_Date)+"' and Lot_id="+Lot_Id+" and Active=1";

		pstmt_p = conp.prepareStatement(check_query1);



		rs_p = pstmt_p.executeQuery();
	
			while(rs_p.next()) 	
			{
			total_count1=rs_p.getInt("Total");
		   }


		if(total_count1==0){


		
			String query="Insert into Effective_Rate(EffectiveRate_Id,Lot_Id,Effective_Date,Selling_Price,Purchase_Price,P3,P4,P5,Company_Id,Modified_On,Modified_By,Modified_MachineName,Active,YearEnd_Id)values(?,?,?,?,?,?,?,?,?,'"+today_date+"',?,?,?,?)";

			pstmt_p = conp.prepareStatement(query);

			pstmt_p.setString(1,EffectiveRate_Id);
			pstmt_p.setString(2,Lot_Id);
			pstmt_p.setString(3,""+format.getDate(Effective_Date));
			pstmt_p.setString(4,Selling_Price);
			pstmt_p.setString(5,Purchase_Price);
			pstmt_p.setString(6,P3);
			pstmt_p.setString(7,P4);
			pstmt_p.setString(8,P5);
			pstmt_p.setString(9,company_id);
			pstmt_p.setString (10, user_id);	
			pstmt_p.setString (11, machine_name);	
			pstmt_p.setBoolean (12,true);
			pstmt_p.setString (13,""+yearend_id);

			int a = pstmt_p.executeUpdate();	
			pstmt_p.close();

			String lot_no1=A.getNameCondition(conp,"Lot","Lot_No"," where Lot_Id="+Lot_Id);

	C.returnConnection(conp);
	boolean is_from_report=false; 
	is_from_report=Boolean.getBoolean(request.getParameter("is_from_report"));
	
	if(is_from_report)
	{
		response.sendRedirect("Efective_Rate.jsp?message= Record  of  <font color=blue>"+lot_no1+"</font> added&Flag=true");
	}
	else
	{						
		response.sendRedirect("UpdateEffective_Rate.jsp?lotno0="+lot_no1+"&description0=F+VVS.2&dsize0=4%2F4&effrate0=0.0&lotid0=3919&datevalue="+Effective_Date+"&command=Go&abc=Yes");
	}
  	
  
  }

///



else{

out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='message1'><b> Lot with Same <font color=blue> Date Record </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
C.returnConnection(conp);

}




////

//C.returnConnection(conp);

}//end of  SAVE COMMAND.
//out.println("177 command="+command);
if("Go".equals(command))
{     
conp=C.getConnection();
//out.print("<br>226 Again Go");
String Lot_No111 = request.getParameter("lotno0");
//out.print("<br> Lot_No111="+Lot_No111);
int num1=100;
%>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<%

   //out.print("<br>178 Lot_No111="+Lot_No111);


String query="";
String message="";//request.getParameter("message");
String salef = "";
    if(request.getParameter("message") != null) 
	{	
	message = request.getParameter("message");


out.println("<center><font class='submit1'> "+message+"</font></center>");
	}
	else{
num1++;
	}
//out.print("<br>message="+message);
   //if(message.equals("null")){
   
   /*if(message!=null){
	out.print("high");
   }
	 else{
		 
out.println("<center><font class='submit1'> "+message+"</font></center>");
	 }
	  */
	  String Lot_No2 = request.getParameter("Lot_No");
//Lot_No="1234";
	//out.print("<br>185 Lot_No="+Lot_No2);
	



	String new_lot_id1=A.getNameCondition(conp,"Lot","Lot_Id"," where Lot_No='"+Lot_No111+"' and Company_Id="+company_id );
	

 

	String description_Name1=""+A.getName(conp,"Description", A.getNameCondition(conp,"Diamond","Description_Id"," where Lot_Id="+new_lot_id1));


	String size_new1=""+A.getName(conp,"Size", A.getNameCondition(conp,"Diamond","D_Size"," where Lot_Id="+new_lot_id1));


	int tot1=0;
	String findlot="select count(*) as Lotfound from Lot where Lot_No='"+Lot_No111+"' And Active=1 and Company_Id="+company_id;

	pstmt_p=conp.prepareStatement(findlot);
	rs_p=pstmt_p.executeQuery();
    
	while(rs_p.next())
	{
		
		  tot1=rs_p.getInt("Lotfound");
	}//end

	//out.print("<br>243 tot1="+tot1);
    if(tot1<=0)
	  {
		//C.returnConnection(conp);
		//response.sendRedirect("Efective_Rate.jsp?message=Lot No  <font color=blue>"+Lot_No+"</font> does not exits.&Flag=true");
	  }



	
	 query="Select * from Lot where Lot_No='"+Lot_No111+"' AND Active=1 and Company_Id="+company_id;

	pstmt_p = conp.prepareStatement(query);
		
	rs_p = pstmt_p.executeQuery();	
				//out.print("<br>256 query="+query);
		while(rs_p.next())
		{
			Lot=rs_p.getString("Lot_Id");
		}//end while.
		//out.print("<br>261 Lot="+Lot);
		pstmt_p.close();
		

	

	
		int count_t=0;
		int counter=0;
		

		//conp=C.getConnection();
		
		query="Select count(*) as total from Effective_Rate where Active=1 and  Lot_Id="+Lot;

		pstmt_p = conp.prepareStatement(query);

		rs_p = pstmt_p.executeQuery();	

		while(rs_p.next())
		{
			count_t=rs_p.getInt("total");
		}//end while.

		java.sql.Date Effective_Date[]=new java.sql.Date [count_t];
		java.sql.Date Modified_On[]=new java.sql.Date [count_t];
		String Sale_price[]=new String[count_t];
		String Purchase_price[]=new String[count_t];
		String P3[]=new String[count_t];
		String P4[]=new String[count_t];
		String P5[]=new String[count_t];
		String eff_id[]=new String[count_t];
		String Modified_By[]=new String[count_t];
		String Modified_MachineName[]=new String[count_t];
        boolean  Active[]=new boolean[count_t];
		//out.print("<br>302 Lot=="+Lot);
		
		query="Select EffectiveRate_Id, Effective_Date,Selling_Price,Purchase_Price,P3,P4,P5 from Effective_Rate where Active=1 and Lot_Id="+Lot;
		
		pstmt_p = conp.prepareStatement(query);
	
		rs_p = pstmt_p.executeQuery();
		
		while(rs_p.next())
		{
			
			eff_id[counter]=rs_p.getString("EffectiveRate_Id");
			
			Effective_Date[counter]=rs_p.getDate("Effective_Date");
			Sale_price[counter]=rs_p.getString("Selling_Price");
			Purchase_price[counter]=rs_p.getString("Purchase_Price");
			P3[counter]=rs_p.getString("P3");
			P4[counter]=rs_p.getString("P4");
			P5[counter]=rs_p.getString("P5");
           
			counter++;
		}//end while.
%>		
<HTML>
<HEAD>
<TITLE> Edit Lot No</TITLE>
<SCRIPT language=javascript 
	src="../Samyak/Samyakcalendar.js">
</SCRIPT>
<SCRIPT language="Java">
	function Validate(name)
	{ 
		var flag11=true

		if(name.value=="")
		{
			alert("Please insert number");
	
			flag11=false;
			return flag11;
		}//end if name.value

		if(isNaN(name.value))
		{
			alert("Plz. insert number");

			name.value.select();
			flag11=false;
			return flag11;
		}//end if isNaN.
	}//end function Validate.


function tb(str)
{
window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=no","Height=600","Width=900", "Resizable=yes","Scrollbars=yes","status=no"])
}

</SCRIPT><CENTER></CENTER>
</HEAD>
<BODY background="../Buttons/BGCOLOR.JPG" OnLoad="window.parent.frames[0].Efective_Rate.lotno0.select();" >
	<FORM name="mainform" action="UpdateEffective_Rate.jsp" method=post>
		<LINK href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
		<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
	<TABLE border=1 bordercolor="skyblue" align=center cellspacing=0 cellpadding=2 >
	
	<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>

<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
	
	
	<TR>
	<TD>
			<TABLE border=1 align=center>
				<TR><TH colspan=8 align=center bgcolor=skyblue>        Effective Rate in($)</TH></TR>
				<tr>
<!-- <td colspan=2></td> -->	
<td colspan=2><b>Lot No:<%=Lot_No111%></b></td>
	<td colspan=3>
<b>Description:<%=description_Name1%></b></td>	
<td colspan=3>
<b>Size:<%=size_new1%></b></td>	

</tr>

                 <TR>
					<TD>SrNo</TD>
					<TD align=center>Effective Date</TD>
					<TD align=center>Selling Price</TD>
					<TD align=center>Market Price</TD>
					<TD align=center>P3</TD>
					<TD align=center>P4</TD>
					<TD align=center>P5</TD>
				</TR>
				<%
					int ct=0;
					for(int i=0;i<counter;i++)
					{
				%>
				<TR>
				<%
					ct=i;
					ct++;
				%>
					
				


<TD><A href= "UpdateEffective_Rate.jsp?command=editform&counter=<%=ct%>&eff_date=<%=format.format(Effective_Date[i])%>&sp=<%=Sale_price[i]%>&pp=<%=Purchase_price[i]%>&p3=<%=P3[i]%>&p4=<%=P4[i]%>&p5=<%=P5[i]%>&eff_id=<%=eff_id[i]%>&lot_id_new1=<%=Lot%>&Lot_No=<%=Lot_No111%>" ><%=ct%></a></td>
	

	<!-- target=_blank
		<a  href="EditAccount.jsp?command=SelectedAccountName&account_id=<%//=account_id[m]%>&type=<%//=type%>">			
				 -->
				
				<TD align=left>
						<%=format.format(Effective_Date[i])%>
					</TD>
					<TD align=right><%=str.mathformat(Sale_price[i],3)%></TD>
					<TD align=right>
					<%=str.mathformat(Purchase_price[i],3)%>
					</TD>
					<TD align=right><%=str.mathformat(P3[i],3)%></TD>
					<TD align=right><%=str.mathformat(P4[i],3)%></TD>
					<TD align=right><%=str.mathformat(P5[i],3)%></TD>
				</TR>
													
				
				<%
        			}//end for.


				%>




<SCRIPT LANGUAGE="JavaScript">

function nochk(elem,deci){
	//alert("335");
	//alert(deci);
				validate(elem, deci);
			}

</SCRIPT>

<TR align=center>
	<TH colspan=7 align=center bgcolor=skyblue>Effective Date</TH></TR>
</TR>
<TR>
	<!-- <TD align=center>Lot_No</TD> -->
	<TD align=center>
		<SCRIPT language='javascript'>
			 if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Effective Date' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}

			 	
		</SCRIPT>
	</TD>
			
	<TD align=center>Selling Price</TD>
	<TD align=center>Market Price</TD>
	<TD align=center>P3</TD>
	<TD align=center>P4</TD>
	<TD align=center>P5</TD>
</TR>
<TR>
	<!-- <TD align=center><%//=Lot_No%></TD> -->
			<Input type=hidden name="Lot_Id" 						value=<%=Lot%>>
		<% String invoicedate=format.format(D);%>
	<TD colspan=1 align=left><input type=text name='datevalue' size=7 		maxlength=10 value="<%=invoicedate%>"></TD>
	<TD><Input type="text" style="text-align:right" name="Selling_Price" 	size=7 value="0" onBlur="nochk(this,3)" ></TD>
	<TD><Input type="text" style="text-align:right" name="Purchase_Price" 	size=7 value="0"  onBlur="nochk(this,3)"></TD>
	<TD><Input type="text" style="text-align:right" name="P3" size=7 		value="0"  onBlur="nochk(this,3)"></TD>
	<TD><Input type="text" style="text-align:right" name="P4" size=7 		value="0"  onBlur="nochk(this,3)"></TD>
	<TD><Input type="text" style="text-align:right" name="P5" size=7 		value="0"  onBlur="nochk(this,3)"></TD>
</TR>
<TR>
	<!-- <TD align=center colspan=7><Input type=submit name=command 				value="Save">
	</TD> -->

<TD align=center colspan=2>
	<input type=submit name=command value="Save" class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';">
	
	</td>


<TD align=center colspan=2>
	<input type=button name=command value='Back'  class='Button1' onClick='history.go(-1)'>
		</td>

	
	<TD align=center colspan=2>
	<input type=submit name=command value="Close" class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"  >
	
	</td>
	
	
	
	
	</TR>
</TABLE>
</TD>
</TR>
</TABLE>
</FORM>
</BODY>
</HTML>












					<%
					pstmt_p.close();
					C.returnConnection(conp);
	}

	






//C.returnConnection(conp);




//}//end if Go.
%>

<%
///code for edit effective rate
if("editform".equals(command))
	{

//out.print("<br>315 editform code");


		String Lot_No_time=request.getParameter("Lot_No111");
		String eff_id=request.getParameter("eff_id");
		//out.print("<br>409 eff_id="+eff_id);
		String counter=request.getParameter("counter");
		//out.print("<br>386 counter"+counter);
		String eff_date=request.getParameter("eff_date");
		//out.print("<br>388 eff_date="+eff_date);
		String selling_price=request.getParameter("sp");
		//out.print("<br>562 selling_price="+selling_price);
		String purchase_price=request.getParameter("pp");
		//out.print("<br>392 purchase_price=>"+purchase_price);
		String pp3=request.getParameter("p3");
		//out.print("<br>394 pp3="+pp3);
		String pp4=request.getParameter("p4");
		//out.print("<br>396 pp4="+pp4);
		String pp5=request.getParameter("p5");
		String lot_id_new1_time=request.getParameter("lot_id_new1");
		//out.print("<br>446 lot_id_new1_time="+lot_id_new1_time);
		String active11="";
		String tempCheck="";
		tempCheck="checked";
%>

	<HTML>
<HEAD>
<TITLE> Edit Lot No</TITLE>
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
<BODY background="../Buttons/BGCOLOR.JPG" >
	<FORM name="mainform" action="UpdateEffective_Rate_new.jsp" method=post>
	<LINK href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<TABLE border=1 bordercolor="skyblue" align=center cellspacing=0 cellpadding=1 >
	<TR>
	<TD colspan=5>
	<TABLE border=1 align=center width="300" >
			<TR><TH colspan=7 align=center bgcolor=skyblue>Edit/Cancel Rate</TH>
			</TR>
			<TR  colspan=5>
					<TD align=center>SrNo</TD>
					
		<TD align=center>
		<SCRIPT language='javascript'>
			 if (!document.layers) {document.write("<input type=button class='datebtn' onclick='popUpCalendar(this, mainform.eff_date, \"dd/mm/yyyy\")' value='Effective Date' onmouseover=\"this.className='datebtn_over';\" onmouseout=\"this.className='datebtn';\">")}
		</SCRIPT>
		</TD>
		
<SCRIPT LANGUAGE="JavaScript">
<!--
function myfunction(){
	//alert("478");
document.mainform.purchase_price_hidden.value=document.mainform.purchase_price.value;
document.mainform.selling_price_hidden.value=document.mainform.selling_price.value;
document.mainform.pp41.value=document.mainform.pp4.value;
document.mainform.pp31.value=document.mainform.pp3.value;
document.mainform.pp51.value=document.mainform.pp5.value;
document.mainform.eff_date_hidden.value=document.mainform.eff_date.value;
//document.mainform.pp51.value=document.mainform.pp4.value;
return true;
}

function nochk(elem,deci){
	
				validate(elem, deci);
			}
//-->
</SCRIPT>
	
					<TD align=center width="5%">Selling Price</TD>
					<TD align=center width="5%">Market Price</TD>
					<TD align=center width="5%">P3</TD>
					<TD align=center width="5%">P4</TD>
					<TD align=center width="5%">P5</TD>
				</TR>
			<TR >

    <TD align=center><%=counter%><input type=checkbox name=active_new value=yes <%=tempCheck%>></TD>
   

		
					
					
   <TD colspan=1 align=left><input type=text name='eff_date' size=7 		maxlength=10 value="<%=eff_date%>"></TD>






				<TD><input type=text name=selling_price value='<%=str.mathformat(selling_price,3)%>' style="text-align:right" onBlur="nochk(this,3)" size=6>
				</TD>	
	
				
				
	
	<TD><input type=text name=purchase_price value='<%=str.mathformat(purchase_price,3)%>' style="text-align:right" onBlur="nochk(this,3)" size=6></TD>



		

					<TD ><input type=text name=pp3 value='<%=str.mathformat(pp3,3)%>' style="text-align:right" onBlur="nochk(this,3)" size=6></TD>

	    




					<TD><input type=text name=pp4 value='<%=str.mathformat(pp4,3)%>' style="text-align:right" onBlur="nochk(this,3)" size=6></TD>


						

					<TD><input type=text name=pp5 value='<%=str.mathformat(pp5,3)%>' style="text-align:right" onBlur="nochk(this,3)" size=6></TD>
				
					

					
					
					</TR>
	<tr>

		<input type=hidden name=selling_price_hidden value='<%=selling_price%>'>

		<input type=hidden name=purchase_price_hidden value='<%=purchase_price%>'>
      <input type=hidden name=pp31 value='<%=pp3%>'>
      <input type=hidden name=pp51 value='<%=pp5%>'>
	<input type=hidden name=pp41 value='<%=pp4%>'>
	<input type=hidden name=eff_id1 value='<%=eff_id%>'>
	<input type=hidden name=eff_date_hidden value='<%=eff_date%>'>
	<input type=hidden name=lot_iddd_new value='<%=lot_id_new1_time%>'>
	<input type=hidden name=lot_no_new value='<%=Lot_No_time%>'>

	<!-- <input type=submit name=command value='Update' class='Button1' onclick='return myfunction()'> -->
	
	<TD align=center colspan=7>
	<input type=submit name=command value="Update" class='button1'   onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"  onclick='return myfunction()'>
	
	</td>
	
	
	
	</tr>
	
	
	
	
	
	
	<%
	
	
	
	}//end of default form

if("Close".equals(command))
	{

%><SCRIPT LANGUAGE="JavaScript">
window.close();
</SCRIPT>
	<%}









%>

<%
/*
if("Update".equals(command))
	{
	
	
	conp=C.getConnection();
    //out.print("<br>540 Welcome to update");
	String eff_id="";


   java.sql.Date Effective_Date_new_check = new java.sql.Date(System.currentTimeMillis());   
   

	eff_id=request.getParameter("eff_id1");
	String LOT_ID=request.getParameter("lot_iddd_new");
	//out.print("<br>*****634 LOT_ID="+LOT_ID);
	String Lot_new=A.getNameCondition(conp,"Lot","Lot_No"," where Lot_Id="+LOT_ID+" and Company_Id="+company_id);
	String selling_price_hidden="";
	 selling_price_hidden=request.getParameter("selling_price_hidden");
	//out.print("<br>564 selling_price_hidden="+selling_price_hidden);
	
	String purchase_price_hidden=request.getParameter("purchase_price_hidden");
	//out.print("<br>572 purchase_price_hidden="+purchase_price_hidden);
	

	String pp3=request.getParameter("pp31");
	String lot_idd=request.getParameter("Lot");

	String pp4=request.getParameter("pp41");
	//out.print("<br>/////////////lot_idd pp41="+lot_idd);
	
	boolean active_id;
	String pp5=request.getParameter("pp51");
	//out.print("<br>575 pp51="+pp5);
	String id_check="";//request.getParameter("active_new");
	if(request.getParameter("active_new") != null) 
		id_check = request.getParameter("active_new");
	
	
	//out.print("<br>id_check="+id_check);
	if(id_check.equals("yes"))
		{
 active_id=true;

		}

		else{
active_id=false;

		}

	int total_count=0;
	//int int_id=Integer.parseInt(new_lot_id);
	String effective_date1=request.getParameter("eff_date_hidden");
java.sql.Date effective_date1_dateformat= FD.getDate(effective_date1);

//out.print("<br>658 *** int_id="+int_id);
out.print("<br>758 *** User Date effective_date1="+format.getDate(effective_date1));


String check_query="select count(*) Total from Effective_Rate where Effective_Date='"+format.getDate(effective_date1)+"' and Lot_Id="+LOT_ID+" and Active=1 and EffectiveRate_Id="+eff_id;

pstmt_p = conp.prepareStatement(check_query);
//pstmt_p.setString(1,new_lot_id); 
rs_p = pstmt_p.executeQuery();
	while(rs_p.next()) 	
	{
total_count=rs_p.getInt("Total");



	}
out.print("<br>774 total_count="+total_count);
////




check_query="select Effective_Date  from Effective_Rate where  Active=1 and Lot_Id="+LOT_ID+" and EffectiveRate_Id="+eff_id;
pstmt_p = conp.prepareStatement(check_query);
//pstmt_p.setString(1,new_lot_id); 
rs_p = pstmt_p.executeQuery();
	while(rs_p.next()) 	
	{
Effective_Date_new_check=rs_p.getDate("Effective_Date");



	}
out.print("<br>794 Existing Effective_Date_new_check="+Effective_Date_new_check);





//////





















if((total_count==1)){
	//||(total_count==1)){
out.print("<br>828 ins first if");

	String update_query="Update Effective_Rate set Effective_Date=?,Selling_Price=?,Purchase_Price=?,P3=?,P4=?,P5=?,P6=?,P7=?,P8=?,Modified_On=?, Modified_By=?,Modified_MachineName=?,Active=?,YearEnd_Id=?  where EffectiveRate_Id=?";
	
	pstmt_p = conp.prepareStatement(update_query);
	
	//pstmt_p.setDate (1,lot_no);
	pstmt_p.setString(1,""+format.getDate(effective_date1));
	pstmt_p.setString (2,selling_price_hidden);

	pstmt_p.setString (3,purchase_price_hidden);
	
	pstmt_p.setString (4,pp3);
	pstmt_p.setString(5,pp4);
	pstmt_p.setString(6,pp5);
	pstmt_p.setString(7,"0");
	pstmt_p.setString(8,"0");
	pstmt_p.setString(9,"0");
    
	pstmt_p.setString(10,""+D);
	
	pstmt_p.setString(11,user_id);
	pstmt_p.setString(12,machine_name);
	pstmt_p.setBoolean(13,active_id);
	pstmt_p.setString(14,""+yearend_id);
	pstmt_p.setString(15,""+eff_id);


	
	
	int a = pstmt_p.executeUpdate();
	
	



C.returnConnection(conp);


response.sendRedirect("Efective_Rate.jsp?message= Effective Rate Entries  of Lot No<font color=blue>"+Lot_new+"</font> Updated&Flag=true");


}

else{

////
int diff;
//diff=effective_date1_dateformat.compareTo(Effective_Date_new_check);
diff=Effective_Date_new_check.compareTo(effective_date1_dateformat);

out.print("<br>880 diff="+diff);
if((total_count==0)&&(diff!=1))
	{
out.print("<br>889ins second if");
String update_query="Update Effective_Rate set Effective_Date=?,Selling_Price=?,Purchase_Price=?,P3=?,P4=?,P5=?,P6=?,P7=?,P8=?,Modified_On=?, Modified_By=?,Modified_MachineName=?,Active=?,YearEnd_Id=?  where EffectiveRate_Id=?";
	
	pstmt_p = conp.prepareStatement(update_query);
	
	//pstmt_p.setDate (1,lot_no);
	pstmt_p.setString(1,""+format.getDate(effective_date1));
	pstmt_p.setString (2,selling_price_hidden);

	pstmt_p.setString (3,purchase_price_hidden);
	
	pstmt_p.setString (4,pp3);
	pstmt_p.setString(5,pp4);
	pstmt_p.setString(6,pp5);
	pstmt_p.setString(7,"0");
	pstmt_p.setString(8,"0");
	pstmt_p.setString(9,"0");
    
	pstmt_p.setString(10,""+D);
	
	pstmt_p.setString(11,user_id);
	pstmt_p.setString(12,machine_name);
	pstmt_p.setBoolean(13,active_id);
	pstmt_p.setString(14,""+yearend_id);
	pstmt_p.setString(15,""+eff_id);


	
	
	int a = pstmt_p.executeUpdate();
	
	
//out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br> <center> <font class='message1'> <b>Successfully updated <font color=blue>"+" </font></font></b><br><br></center>");





///out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br> <center> <font class='message1'> <b>Successfully updated <font color=blue>"+" </font></font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");




C.returnConnection(conp);


response.sendRedirect("Efective_Rate.jsp?message= Effective Rate Entries  of Lot No<font color=blue>"+Lot_new+"</font> Updated&Flag=true");











    }

////
else{








out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='message1'><b>This <font color=blue> Date  </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");

}

} //big else

	
	
	
	//C.returnConnection(conp);
	}

*/

//}

}catch(Exception e){
C.returnConnection(conp);
out.print("<br>897 Exception is="+e);
}


%>
















