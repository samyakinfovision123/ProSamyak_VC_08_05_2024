<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A"  class="NipponBean.Array" />
<jsp:useBean id="C" scope="application"  class="NipponBean.Connect" />
<jsp:useBean id="I"  class="NipponBean.Inventory" />
<jsp:useBean id="S"  class="NipponBean.Stock" />

<% 
ResultSet rs_g= null;
ResultSet rs_p= null;
Connection cong = null;
Connection conp = null;
PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;
try	{
	//cong=C.getConnection();
	conp=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtReport.jsp<br>Bug No e31 : "+ e31);}

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
//String company_name= A.getName("companyparty",company_id);
String local_symbol= I.getLocalSymbol(conp,company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));




String companyparty_id=""+ company_id;
String company_name="";
String company_address="";
String company_city="";
String company_country="";
String company_phone_off="";

String company_query="select * from Master_CompanyParty where active=1 and companyparty_id="+company_id;
pstmt_p = conp.prepareStatement(company_query);
//System.out.println(company_query);
rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 	
	{
//	System.out.println("Inside While 50");
	company_name= rs_g.getString("CompanyParty_Name");	company_address= rs_g.getString("Address1");	
	company_city= rs_g.getString("City");		
	company_country= rs_g.getString("Country");		
	company_phone_off= rs_g.getString("Phone_Off");		
	}
pstmt_p.close();
//C.returnConnection(conp);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String command=request.getParameter("command");
//out.print("<br>command=" +command);
try{

if("Default".equals(command))
	{
	%>
<head>
<title>Stock Transfer Report</title>
<script>
function disrtclick()
{
window.event.returnValue=0;
}
</script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<%
//	out.print("<br>69 ");
			String query="";
	int sReceive_Id=Integer.parseInt(request.getParameter("Receive_Id"));
	//out.print("<br> 75 sReceive_Id"+sReceive_Id);
	int dReceive_Id=0;
	
	String StockTransfer_Type=request.getParameter("StockTransfer_Type");
//	out.print("<br> 75 StockTransfer_Type "+StockTransfer_Type);
	String Receive_No="";
	String Receive_Date="";
	String Stock_Date="";
//	String description="";
	//+request.getParameter("description");
//	 String ref_no="";
	//+request.getParameter("ref_no");


	 String temp_v_id = ""+A.getNameCondition(conp,"Voucher","Voucher_Id"," where Voucher_No='"+sReceive_Id+"'");
	//out.print("<br> 47 sReceive_Id"+sReceive_Id);
	//out.print("<br> 47 temp_v_id"+temp_v_id);
	String ref_no= ""+A.getNameCondition(conp,"Voucher","Ref_No", "where Voucher_Id="+temp_v_id);
	//out.print("<br> 47"+ref_no);
	//	 out.print("<br> 86 ref_no"+ref_no);

	String description=""+A.getNameCondition(conp,"Voucher","Description","where Voucher_Id="+temp_v_id);

	double Exchange_Rate=0;
	double Local_Total=0;
	double dLocal_Total=0;
	double Dollar_Total=0;
//	String StockTransfer_Type="";
	int scounter=0;
	int dcounter=0;
/*	try	{
	//cong=C.getConnection();
	conp=C.getConnection();
	}catch(Exception e31){ 
	out.println("<font color=red> FileName : CgtReport.jsp<br>Bug No e31 : "+ e31);} 
*/
	if("7".equals(StockTransfer_Type))
		{
	dReceive_Id=sReceive_Id;
	sReceive_Id=0;
	query="select * from Receive where Receive_Id="+dReceive_Id;
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	while(rs_p.next())
		{
			Receive_No=rs_p.getString("Receive_No");
			Receive_Date=format.format(rs_p.getDate("Receive_Date"));
			dcounter=rs_p.getInt("Receive_Lots");
			Exchange_Rate=rs_p.getDouble("Exchange_Rate");
			dLocal_Total=rs_p.getDouble("Local_Total");
			Dollar_Total=rs_p.getDouble("Dollar_Total");
			Stock_Date=format.format(rs_p.getDate("Stock_Date"));
//			StockTransfer_Type=rs_p.getString("StockTransfer_Type");
		}
		scounter=0;
	pstmt_p.close();
		}//if 7 (Gain)
		else
		{
	query="select * from Receive where Receive_Id="+sReceive_Id;
	

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	while(rs_p.next())
		{
			Receive_No=rs_p.getString("Receive_No");
			Receive_Date=format.format(rs_p.getDate("Receive_Date"));
			scounter=rs_p.getInt("Receive_Lots");
			Exchange_Rate=rs_p.getDouble("Exchange_Rate");
			Local_Total=rs_p.getDouble("Local_Total");
			Dollar_Total=rs_p.getDouble("Dollar_Total");
			Stock_Date=format.format(rs_p.getDate("Stock_Date"));
//			StockTransfer_Type=rs_p.getString("StockTransfer_Type");
		}
	pstmt_p.close();
	dReceive_Id=sReceive_Id+1;

	query="select * from Receive where Receive_Id="+dReceive_Id+" and Receive_No='"+Receive_No+"'";
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	while(rs_p.next())
		{
			dcounter=rs_p.getInt("Receive_Lots");
			dLocal_Total=rs_p.getDouble("Local_Total");

		}

		}//if !=7
	String slotid[]=new String[scounter];
	String sdrawing[]=new String[scounter];
	String slocation_id[]=new String[scounter];
	double sqty[]=new double[scounter];
	double srate[]=new double[scounter];
	double samount[]=new double[scounter];
	String sReceiveTransaction_Id[]=new String[scounter];
	boolean sMov_WtdAvg[]=new boolean[scounter];
	double stotalqty=0;

	String dlotid[]=new String[dcounter];
	String ddrawing[]=new String[dcounter];
	String dlocation_id[]=new String[dcounter];
	double dqty[]=new double[dcounter];
	double drate[]=new double[dcounter];
	double damount[]=new double[dcounter];
	boolean dMov_WtdAvg[]=new boolean[dcounter];
	String dReceiveTransaction_Id[]=new String[dcounter];
	double dtotalqty=0;

if(!("7".equals(StockTransfer_Type)))
		{
//	out.print("<br> 163 Except Gain");
	query="select ReceiveTransaction_Id,Lot_Id, Quantity, Local_Price,Location_Id, Mov_WtdAvg  from Receive_Transaction where Receive_Id="+sReceive_Id+" order by Lot_SrNo";

	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int s=0;
	while(rs_p.next())
		{
//					out.print("<br> 175 sReceive_Id "+sReceive_Id);
			sReceiveTransaction_Id[s] = rs_p.getString("ReceiveTransaction_Id");
			slotid[s]=rs_p.getString("Lot_Id");
//			out.print("<br> 178 slotid "+slotid[s]);

			sdrawing[s]=A.getNameCondition(conp,"Lot","Drwg_FileName","where Lot_Id="+slotid[s]);
			sqty[s]=rs_p.getDouble("Quantity");
//			out.print("<br> sqty["+s+"]"+sqty[s]);
			stotalqty=stotalqty+sqty[s];
			srate[s]=rs_p.getDouble("Local_Price");
			samount[s]=Double.parseDouble(str.mathformat(""+(sqty[s]*srate[s]),d) );
			slocation_id[s]=rs_p.getString("Location_Id");
			sMov_WtdAvg[s]=rs_p.getBoolean("Mov_WtdAvg");
//			out.print("<br> 188 mwa "+sMov_WtdAvg[s]);
			s++;
		}
	pstmt_p.close();

		}

if(!("6".equals(StockTransfer_Type)))
		{
//	out.print("<br> 163 Except Loss");

	query="select ReceiveTransaction_Id,Lot_Id, Quantity, Local_Price,Location_Id ,Mov_WtdAvg from Receive_Transaction where Receive_Id="+dReceive_Id+" order by Lot_SrNo";
	pstmt_p=conp.prepareStatement(query);
	rs_p=pstmt_p.executeQuery();
	int ds=0;
	while(rs_p.next())
		{
			dReceiveTransaction_Id[ds] = rs_p.getString("ReceiveTransaction_Id");
			dlotid[ds]=rs_p.getString("Lot_Id");
			ddrawing[ds]=A.getNameCondition(conp,"Lot","Drwg_FileName","where Lot_Id="+dlotid[ds]);
			dqty[ds]=rs_p.getDouble("Quantity");
			dtotalqty=dtotalqty+dqty[ds];

			drate[ds]=rs_p.getDouble("Local_Price");
			damount[ds]=Double.parseDouble(str.mathformat(""+(dqty[ds]*drate[ds]),d));
			dlocation_id[ds]=rs_p.getString("Location_Id");
			dMov_WtdAvg[ds]=rs_p.getBoolean("Mov_WtdAvg");
			ds++;
		}
	pstmt_p.close();

		}
//C.returnConnection(conp);

for(int i=0;i<scounter;i++)
		{
//			out.print("<br> 211 slotid "+slotid[i]);
//			out.print("<br> 212 sdrawing "+sdrawing[i]);
//			out.print("<br> 213 slotid "+sqty[i]);
//			out.print("<br> 214 srate "+srate[i]);
//			out.print("<br> 215 samount "+samount[i]);
//			out.print("<br> 216 slocation_id "+slocation_id[i]);
		}

for(int i=0;i<dcounter;i++)
		{
//			out.print("<br> 221 dlotid "+dlotid[i]);
//			out.print("<br> 222 ddrawing "+ddrawing[i]);
//			out.print("<br> 223 dlotid "+dqty[i]);
//			out.print("<br> 224 drate "+drate[i]);
//			out.print("<br> 225 damount "+damount[i]);
//			out.print("<br> 226 dlocation_id "+dlocation_id[i]);
		}
%>


<% if(("4".equals(StockTransfer_Type)) || ("6".equals(StockTransfer_Type)) || ("5".equals(StockTransfer_Type)) || ("7".equals(StockTransfer_Type)))
		{
//out.print("<br> inside all");
//out.print("here");
%>
	
<script language=javascript>

function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No "); 
name.focus();}
}// validate


function scalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<scounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.sqty<%=i%>.value);	
<%	}
%>
	totqty = totqty.toFixed(3); 
	
<%
if(scounter>0)
	{%>
document.mainform.stotalqty.value=totqty;
<%	}%>


}// calcTotal

function dcalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<dcounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.dqty<%=i%>.value);	

<%	} %>
	totqty = totqty.toFixed(3); 
<%
if(dcounter>0)
	{%>
document.mainform.dtotalqty.value=totqty;
<%	}%>
}// calcTotal


function onSubmitValidate1()
	{

//alert("onSubmitValidate");
<%
if(scounter>0)
	{%>
	scalcTotal(document.mainform.sqty0);
<%	}%>

<%
if(dcounter>0)
	{%>
	dcalcTotal(document.mainform.dqty0);
<%	}%>
//	{
				<%
				for(int i=0;i<scounter;i++)
				{%>

			if(document.mainform.slotno<%=i%>.value=="")
				{

					alert("Lot No can not be blank");
					return false;
				}
				else
					{
/*					if(parseFloat(document.mainform.srate<%=i%>.value)==0)
						{
//						alert("Rate Could not be zero");
//						return false;
						}*/
					}
			<%}%>
<%
				for(int i=0;i<dcounter;i++)
				{%>
			if(document.mainform.dlotno<%=i%>.value=="")
				{
					alert("Lot No can not be blank");
					return false;
				}
			else
				{
/*					if(parseFloat(document.mainform.drate<%=i%>.value)==0)
						{
						alert("Rate Could not be zero");
						return false;
						}*/
					}
			<%}%>
//alert("dcounter "+<%//=dcounter%>);
<% for(int i=0;i<scounter;i++)
		{
		for(int j=0;j<dcounter;j++)
			{%>
//			alert("Source "+document.mainform.slotno<%=i%>.value);
//			alert("destination "+document.mainform.dlotno<%=j%>.value);
				if(document.mainform.slotno<%=i%>.value==document.mainform.dlotno<%=j%>.value)
				{
					alert("Source and destination lots can not be same");
					document.mainform.dlotno<%=j%>.select();
					return false;
				}
		<%	}
		}%>
	a= fnCheckDate(document.mainform.datevalue.value,"Date")
		if(a==false)
		{
		return false;
		}
		else
		{
<%
if( (dcounter>0) && (scounter>0) )
	{%>
		if(parseFloat(document.mainform.stotalqty.value)== parseFloat(document.mainform.dtotalqty.value))
			{
				return true;
			}
		else
			{
			<%
				if("3".equals(StockTransfer_Type))
				{%>
				alert("Source and Destination Quantity should Match");
				return false;
			<%	}%>
			}
	<%}%>

		}
//	}
	}//onSubmitValidate


</script>



<%}
if("1".equals(StockTransfer_Type))
	{
%>
<script language=javascript>

function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No "); 
name.focus();}
}// 

function dcalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<dcounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.dqty<%=i%>.value);	
		totqty = totqty.toFixed(3); 

<%	}
if(dcounter>0)
	{%>
document.mainform.dtotalqty.value=totqty;
document.mainform.stotalqty.value=totqty;
<%
for(int j=0;j<scounter;j++)
	{%>
document.mainform.sqty<%=j%>.value = document.mainform.dqty<%=j%>.value;

<%}
}%>
}// dalcTotal

function scalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<scounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.sqty<%=i%>.value);	
		totqty = totqty.toFixed(3); 

<%	
	
}
if(scounter>0)
	{%>
document.mainform.stotalqty.value=totqty;
document.mainform.dtotalqty.value=totqty;
<%
for(int j=0;j<scounter;j++)
	{%>	

	 document.mainform.dqty<%=j%>.value = document.mainform.sqty<%=j%>.value;

<%	}
	} %>
}

function onSubmitValidate1()
{
	var flag=0;
<% for(int i=0;i<scounter;i++)
	{%>
		if( (document.mainform.slocation_id<%=i%>.value==document.mainform.dlocation_id<%=i%>.value) && (document.mainform.slotno<%=i%>.value==document.mainform.dlotno<%=i%>.value) )
		{
			alert("Lot & Location of Source and Destination can not be same");
			flag=flag+1;
		}

		if(document.mainform.slotno<%=i%>.value=="")
		{
			alert("Please Enter Lot No")
			flag=flag+1;
		}
		
	

		if(document.mainform.sqty<%=i%>.value=="")
		{
			alert("Source Quantity Field should not be blank");
			flag=flag+1;
			return false;
		}
		if(document.mainform.dqty<%=i%>.value=="")
		{
			alert("Destination Quantity Field should not be blank");
			flag=flag+1;
			return false;
		}
		/*
		var qty=parseFloat(document.mainform.quantity<%=i%>.value);
	//	dcalcTotal(this)

		if(qty==0)
		{
			alert("Quantity Field should not be Zero");
			flag=flag+1;
		}
		*/
<%	}%>
//	alert (flag);
	if(flag==0)
	{
//	alert("If");
	return true;
	}
	else
	{
//	alert("Else");
	return false;
	}
}

</script>



<%}
if("2".equals(StockTransfer_Type))
	{
%>

<script language=javascript >


function nullvalidation(name)
{
if(name.value =="") 
{ 
alert("Please Enter No "); 
name.focus();}
}// 

function scalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<scounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.sqty<%=i%>.value);	
		totqty = totqty.toFixed(3); 

<%	
	
}
if(scounter>0)
	{%>
document.mainform.stotalqty.value=totqty;
document.mainform.dtotalqty.value=totqty;
<%
for(int j=0;j<scounter;j++)
	{%>	

	 document.mainform.dqty<%=j%>.value = document.mainform.sqty<%=j%>.value;

<%	}
	} %>
}

function copyLotNo(name)
{
//nullvalidation(name)
//alert(name)
<%
if(scounter>0)
	{

for(int j=0;j<scounter;j++)
	{%>	
	if(name == 1 )
		{
			document.mainform.dlotno<%=j%>.value =document.mainform.slotno<%=j%>.value
        }   
     if(name == 2 )
		{
			document.mainform.slotno<%=j%>.value =document.mainform.dlotno<%=j%>.value
		}
<%	}
	} %>
}


function dcalcTotal(name)
{
validate(name,3)
//alert ("Ok Inside CalcTotal");
var totqty=0;

<%
for(int i=0;i<dcounter;i++)
	{%>
		totqty+=parseFloat(document.mainform.dqty<%=i%>.value);	
		totqty = totqty.toFixed(3); 

<%	}
if(dcounter>0)
	{%>
document.mainform.dtotalqty.value=totqty;
document.mainform.stotalqty.value=totqty;
<%
for(int j=0;j<scounter;j++)
	{%>
document.mainform.sqty<%=j%>.value = document.mainform.dqty<%=j%>.value;

<%}
}%>
}// dalcTotal




function onSubmitValidate1()
{
	var flag=0;
<% for(int i=0;i<scounter;i++)
	{%>
		if(document.mainform.slocation_id<%=i%>.value==document.mainform.dlocation_id<%=i%>.value)
		{
			alert("Source and Destination Location can not be same");
			flag=flag+1;
		}

		if(document.mainform.slotno<%=i%>.value=="")
		{
			alert("Please Enter Lot No")
			flag=flag+1;
		}
		
		
		if(document.mainform.sqty<%=i%>.value=="")
		{
			alert("Quantity Field should not be blank");
			flag=flag+1;
			return false;
		}
		
		var qty=parseFloat(document.mainform.sqty<%=i%>.value);
		if(qty==0)
		{
			alert("Quantity Field should not be Zero");
			flag=flag+1;
		}
<%	}%>
//	alert (flag);
	if(flag==0)
	{
//	alert("If");
	return true;
	}
	else
	{
//	alert("Else");
	return false;
	}
}

</script>



<%}%>




<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js"></SCRIPT>
<SCRIPT language=javascript 
src="../Samyak/Samyakmultidate.js">
</script>

<SCRIPT language=javascript >

function copyDate(name,field)
{
flag = fnCheckMultiDate(name,field)
//	alert(field);
if(flag==true)
{
		if(field=="Transfer Date")
			document.mainform.stockdate.value = document.mainform.datevalue.value;		
		
		if(field=="Stock Date")
			document.mainform.datevalue.value = document.mainform.stockdate.value; 

// alert()
	return true
}
else
	return false
}
</SCRIPT>

</head>

	<body background="../Buttons/BGCOLOR.JPG">



	<FORM name=mainform
action="EditStockTransfer.jsp"  method=post>
<input type=hidden name=no_lots value=<%=scounter%>>
<input type=hidden name=lotfocus>
<input type="hidden" name="StockTransfer_Type" value="<%=StockTransfer_Type%>">
<input type=hidden name="sold_lots" value="<%=scounter%>">
<input type=hidden name="dold_lots" value="<%=dcounter%>">
<input type=hidden name="sReceive_Id" value="<%=sReceive_Id%>">
<input type=hidden name="dReceive_Id" value="<%=dReceive_Id%>">
 <input type=hidden name="scounter" value="<%=scounter%>">
 <input type=hidden name="dcounter" value="<%=dcounter%>">

<TABLE borderColor=#6f6f6f cellSpacing=0 cellPadding=0 width="100%" align=right 
border=0>
  <TBODY>
  <TR>
   <TD>
     <TABLE borderColor=#e4e4e4 cellSpacing=0 cellPadding=0 rules=cols 
      width="95%" align=right border=0>
       <TBODY>
        <TR>
         <TD>
<TABLE borderColor=#6f6f6f cellSpacing=0 cellPadding=0 rules=cols 
  width="100%" align=center border=1>
   <TBODY>
   <TR>
    <TH align=middle colSpan=8>STOCK TRANSFER</TH></TR>
    <TR><TD>
   <TABLE borderColor=#6633ff cellSpacing=0 cellPadding=0 
   width="100%" align=right border=1>
  <TBODY>
  <TR><TD align=right colSpan=7>
  <TABLE borderColor=#d9d9d9 cellSpacing=0 cellPadding=0 
   width="100%" border=1>
   <TBODY>
    <TR> <TD align=right width="80%" colSpan=7></TD>
    <TD width="10%">Transfer No :</TD>
    <TD width="10%"><input type=text name=stocktransfer_no size=5 onBlur='return nullvalidation(this)' value="<%=Receive_No%>"></TD></TR>
   <TR><TD align=right width="80%" colspan=7></TD>
		<TD WIDTH="10%">Ref.No :</TD>
		<TD WIDTH="10%"><input type=text name=ref_no size=10 value="<%=ref_no%> " maxlength=10></TD></TR>


	<TD align=right width="80%" colSpan=7></TD>
    <TD width="10%"><!-- Due Date : --></TD>
     <TD width="10%"></TD></TR>
     <TR>
      <TD align=right width="70%" colSpan=6></TD>
		<TD width="30%" align=right colSpan=3>
     <script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.datevalue, \"dd/mm/yyyy\")' value='Transfer Date' style='font-size:11px ; width:100'> ")} </script><input type=text name='datevalue' size=8 value="<%=Receive_Date%>" onblur='return copyDate(this,"Transfer Date")'></td>
             </TR>
 <TR><TD align=right width="70%" colSpan=6></TD>
  <TD width="30%" align=right colSpan=3><script language='javascript'>
if (!document.layers) {document.write("<input type=button class='button1' onclick='popUpCalendar(this, mainform.stockdate, \"dd/mm/yyyy\")' value='Stock Date' style='font-size:11px ; width:100'>")}
</script> 
<input type=text name='stockdate' size=8 maxlength=10 value="<%=Stock_Date%>" onblur='return  copyDate(this,"Stock Date")'>	</TD>
                           </TR>
<tr>
<td colspan=6></td>
<td   width="30%" align=right></td>
<input type=hidden name=currency value=local >
<td colspan=2  align=right>Exchange Rate <input type=text name=exchange_rate value="<%=str.mathformat(Exchange_Rate,2)%>" size=4 onBlur="validate(this,2)" style="text-align:right">
</td>
 <TR>
	</TBODY></TABLE></TD></TR>
<tr>
<td colspan=2>
<table bordercolor=silver border=1 WIDTH="100%" cellspacing=0 cellpadding=2 height="100%">	
<% if(scounter>0)
		{%>

<tr>
<th colspan=5>Source</th>
</tr>
<tr>
	<td>Sr. No.</td>
	<td>Lot No.</td>
	<td colspan=1>Location</td>
	<td>Qty</td>
	<td>Rate</td>
 </tr>
						
	  <%for(int i=0;i<scounter;i++)
		{%>
			 <tr>
		  	<td><%=i+1%></td>
	  <input type=hidden name="old_srate<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>">
 <input type=hidden name="old_sqty<%=i%>" value="<%=str.mathformat(""+sqty[i],3)%>">
 <input type=hidden name="old_slotid<%=i%>" value="<%=slotid[i]%>">
 <input type=hidden name="sReceiveTransaction_Id<%=i%>" value="<%=sReceiveTransaction_Id[i]%>">
 <input type=hidden name="old_slotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+slotid[i])%>">
 <input type=hidden name="old_slocation_id<%=i%>" value="<%=slocation_id[i]%>">
 <input type=hidden name="sMov_WtdAvg<%=i%>" value="<%=sMov_WtdAvg[i]%>">
<%
	if("2".equals(StockTransfer_Type))
	{
%>
	  <td>
		  <input type=text name="slotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+slotid[i])%>" size=7 onblur = "copyLotNo(1)">

		  </td>
<%
    }
	else
	{		
%>
	     <td>
		  <input type=text name="slotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+slotid[i])%>" size=7 >

		  </td>
<%
	}
%>
	 <td><%=A.getMasterArray(conp,"Location","slocation_id"+i,slocation_id[i],company_id)%></td>	
  <td ><input type=text name="sqty<%=i%>" value="<%=str.mathformat(""+sqty[i],3)%>" size=7 style="text-align:right" onblur="scalcTotal(this)">

	  </td>
 <td >
		<%if(sMov_WtdAvg[i]){
//******************************************************
	//  out.print("Inside smova if");
//******************************************************
		  %>
		  <input type=text name="srate<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>" size=7 style="text-align:right" readonly>  <input type=hidden name="firstsMov_WtdAvgflag<%=i%>" value="1">
		<%}else{
//******************************************************

	//		  		  out.print("Inside else smova if");
//******************************************************

			  %>
<input type=text name="srate<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>" size=7 style="text-align:right"><input type=hidden name="firstsMov_WtdAvgflag<%=i%>" value="0"> 
		<%}%>
		  

	 </td>
 </tr>
 <%}%>
<tr>
	<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
	<td><input type=text name="stotalqty" value="<%=str.mathformat(""+stotalqty,3)%>" size=7 style="text-align:right" readonly></td>
<!-- 	<td>&nbsp;</td>
 --></tr>
			<%}
else{%>
<tr>
	<td height="140" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Gain </font></td>
	<input type=hidden name="scounter" value="0">
	<input type=hidden name="saddlots" value="0">

</tr>
<%	}%>
</table>
</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>
<table bordercolor=silver border=1 WIDTH="100%" cellspacing=0 cellpadding=2 >	
<% if(dcounter>0)
		{%>

<tr>
<th colspan=5>Destination</th>
</tr>
<tr>
	<td>Sr. No.</td>
	<td>Lot No.</td>
	<td colspan=1>Location</td>
	<td>Qty</td>
	<td>Rate</td>
 </tr>
<%
for(int i=0;i<dcounter;i++)
		{%>
<tr>
	<td><%=i+1%></td>
		  <input type=hidden name="old_drate<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>">
 <input type=hidden name="old_dqty<%=i%>" value="<%=str.mathformat(""+dqty[i],3)%>">
 <input type=hidden name="old_dlotid<%=i%>" value="<%=dlotid[i]%>">
 <input type=hidden name="dReceiveTransaction_Id<%=i%>" value="<%=dReceiveTransaction_Id[i]%>">
 <input type=hidden name="old_dlotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+dlotid[i])%>">
 <input type=hidden name="old_dlocation_id<%=i%>" value="<%=dlocation_id[i]%>">
 <input type=hidden name="dMov_WtdAvg<%=i%>" value="<%=dMov_WtdAvg[i]%>">

<%
	if("2".equals(StockTransfer_Type))
	{
%>


	<td><input type=text name="dlotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+dlotid[i])%>" size=7 onblur = "copyLotNo(2)"></td>
<%
    }
	else
	{		
%>
		<td><input type=text name="dlotno<%=i%>" value="<%=A.getNameCondition(conp,"Lot","Lot_No","where Lot_Id="+dlotid[i])%>" size=7 ></td>
<%
    }
%>

 <td><%=A.getMasterArray(conp,"Location","dlocation_id"+i,dlocation_id[i],company_id)%></td>	
	 <td ><input type=text name="dqty<%=i%>" value="<%=str.mathformat(""+dqty[i],3)%>" size=7 style="text-align:right" onblur="dcalcTotal(this)"></td>
	<td ><%
	 if(dMov_WtdAvg[i])
	 {%>
		  <input type=text name="drate<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>" size=7 style="text-align:right" readonly> 
		  <input type=hidden name="firstdMov_WtdAvgflag<%=i%>" value="1"> 

		<%}
		else{%>
			<input type=text name="drate<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>" size=7 style="text-align:right"><input type=hidden name="firstdMov_WtdAvgflag<%=i%>" value="0">  
		<%
			}
		%> 
		</td>
</tr>
<%	}%>
<tr>
	<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
	<td><input type=text name="dtotalqty" value="<%=str.mathformat(""+dtotalqty,3)%>" size=7 style="text-align:right" readonly></td>
<!-- 	<td>&nbsp;</td>
 --></tr>

<%}
else	
	{%>

<tr>
	<td height="140" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
	<input type=hidden name="dcounter" value="0">
	<input type=hidden name="daddlots" value="0">

</tr>
<%	}%>
</table>
</td>
</tr>	
	
<tr>
<td >Narration <input type=text size=75 name=description value="<%=description%>"></td>
</tr>

<tr>
	<td colspan=8 align=center>
		<input type="submit" name="command" value="Next" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';" onclick="return onSubmitValidate1()">
	</td>
</tr>
</table>
			</tD></tr>
			</table>
</form>
</body>
</html>
<%
C.returnConnection(conp);

}

}catch(Exception e) { out.print("<br>file InvStockTransferDetails.jsp "+e); }


try
{
if("Next".equals(command))
	{
String StockTransfer_Type=request.getParameter("StockTransfer_Type");
/*if(("3".equals(StockTransfer_Type)) || ("4".equals(StockTransfer_Type)) || ("5".equals(StockTransfer_Type)) || ("6".equals(StockTransfer_Type)) || ("7".equals(StockTransfer_Type)) )
	{*/
int scounter=Integer.parseInt(request.getParameter("scounter"));
//out.print("<br>550 scounter "+scounter);
int dcounter=Integer.parseInt(request.getParameter("dcounter"));
//out.print("<br>552 dcounter "+dcounter);

String stocktransfer_no=request.getParameter("stocktransfer_no");

String description=""+request.getParameter("description");

String ref_no=""+request.getParameter("ref_no");

String datevalue=request.getParameter("datevalue");
String stockdate=request.getParameter("stockdate");
java.sql.Date SD=format.getDate(stockdate);
String exchange_rate=request.getParameter("exchange_rate");

String slotno[]=new String[scounter];
String slotid[]=new String[scounter];
boolean sqtyflag[]=new boolean[scounter];
boolean slocationflag[]=new boolean[scounter];
boolean slotflag[]=new boolean[scounter];
String slocation_id[]=new String[scounter];
String old_slocation_id[]=new String[scounter];
double sqty[]=new double[scounter];
double srate[]=new double[scounter];
double old_sqty[]=new double[scounter];
double old_srate[]=new double[scounter];
double new_srate[]=new double[scounter];
String old_slotno[]=new String[scounter];
String old_slotid[]=new String[scounter];
String sReceiveTransaction_Id[]=new String[scounter];
String firstsMov_WtdAvgflag[]=new String[scounter];
String query="";
//conp=C.getConnection();

String sReceive_Id = request.getParameter("sReceive_Id");
String dReceive_Id = request.getParameter("dReceive_Id");
//out.print("sReceive_Id = "+sReceive_Id);
//out.print("dReceive_Id = "+dReceive_Id);




for(int i=0;i<scounter;i++)
		{
			sqtyflag[i]=false;
			slocationflag[i]=false;
			slotflag[i]=false;

			slotno[i]=request.getParameter("slotno"+i);
	//		out.print("slotno[i] ="+slotno[i]);
			old_slotno[i]=request.getParameter("old_slotno"+i);
			old_slotid[i]=request.getParameter("old_slotid"+i);
			slocation_id[i]=request.getParameter("slocation_id"+i);
			old_slocation_id[i]= request.getParameter("old_slocation_id"+i);
			sqty[i]=Double.parseDouble(request.getParameter("sqty"+i));
			old_sqty[i]= Double.parseDouble(request.getParameter("old_sqty"+i));
			old_srate[i]= Double.parseDouble(request.getParameter("old_srate"+i));
			new_srate[i]= Double.parseDouble(request.getParameter("srate"+i));
			sReceiveTransaction_Id[i]=request.getParameter("sReceiveTransaction_Id"+i); 
			firstsMov_WtdAvgflag[i] = request.getParameter("firstsMov_WtdAvgflag"+i); 
if(slotno[i].equals(old_slotno[i]))
			{
	//out.print("<br>488");
	slotid[i]=old_slotid[i];
	srate[i]=S.stockRate(conp,SD,company_id,slotid[i]);
slotflag[i]=true;

	if(slocation_id[i].equals(old_slocation_id[i]))
				{
		slocationflag[i]=true;
					query="select Available_Carats from LotLocation where Lot_Id="+slotid[i]+" and Location_Id="+slocation_id[i];
					pstmt_p=conp.prepareStatement(query);
					rs_g=pstmt_p.executeQuery();
					double Available_Carats=0;
					while(rs_g.next())
					{
					Available_Carats=rs_g.getDouble("Available_Carats");
					}
					pstmt_p.close();
	
					Available_Carats +=old_sqty[i];

					if(Available_Carats >=sqty[i])
					{
						sqtyflag[i]=true;
					}
	
	}//if location
}
else{
			 query="select count(Lot_Id) as lotcount from Lot where Lot_No='"+slotno[i]+"'";
			pstmt_p=conp.prepareStatement(query);
			rs_g=pstmt_p.executeQuery();
			int lotcount=0;
			while(rs_g.next())
			{
				lotcount=rs_g.getInt("lotcount");
			}
			pstmt_p.close();
//			out.print("<br>681");
			if(lotcount>0)
			{
				slotflag[i]=true;
				query="select Lot_Id from Lot where Lot_No='"+slotno[i]+"'";
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				while(rs_g.next())
				{
					slotid[i]=rs_g.getString("Lot_Id");
					srate[i]=S.stockRate(conp,SD,company_id,slotid[i]);		

				}
				pstmt_p.close();
//			out.print("<br>693");

			}//else
}//else

if((!(slotno[i].equals(old_slotno[i])))||(!(slocation_id[i].equals(old_slocation_id[i]))))
			{
			query="select count(Lot_Id) as locationcount from LotLocation where Lot_Id="+slotid[i]+" and Location_Id="+slocation_id[i];
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				int locationcount=0;
				while(rs_g.next())
				{
					locationcount=rs_g.getInt("locationcount");
				}
				pstmt_p.close();
//			out.print("<br>704");

				if(locationcount>0)
				{
					slocationflag[i]=true;
					query="select Available_Carats from LotLocation where Lot_Id="+slotid[i]+" and Location_Id="+slocation_id[i];
					pstmt_p=conp.prepareStatement(query);
					rs_g=pstmt_p.executeQuery();
					double Available_Carats=0;
					while(rs_g.next())
					{
						Available_Carats=rs_g.getDouble("Available_Carats");
					}
					pstmt_p.close();
//			out.print("<br>717");
					if(Available_Carats>=sqty[i])
					{sqtyflag[i]=true;}
				}
			}
			
		}//for

	
String dlotno[]=new String[dcounter];
String dlotid[]=new String[dcounter];
boolean dqtyflag[]=new boolean[dcounter];
boolean dlocationflag[]=new boolean[dcounter];
boolean dlotflag[]=new boolean[dcounter];
String dlocation_id[]=new String[dcounter];
double dqty[]=new double[dcounter];
double drate[]=new double[dcounter];
String old_dlocation_id[]=new String[dcounter];
double old_dqty[]=new double[dcounter];
double old_drate[]=new double[dcounter];
double new_drate[]=new double[dcounter];
String old_dlotno[]=new String[dcounter];
String old_dlotid[]=new String[dcounter];
String dReceiveTransaction_Id[]=new String[dcounter];
String firstdMov_WtdAvgflag[] = new String[dcounter];
for(int i=0;i<dcounter;i++)
		{
			dqtyflag[i]=true;
			dlocationflag[i]=true;
			dlotflag[i]=false;

			dlotno[i]=request.getParameter("dlotno"+i);
			dlocation_id[i]=request.getParameter("dlocation_id"+i);
			dqty[i]=Double.parseDouble(request.getParameter("dqty"+i));
			old_dlotno[i]=request.getParameter("old_dlotno"+i);
			old_dlotid[i]=request.getParameter("old_dlotid"+i);
			old_dlocation_id[i]= request.getParameter("old_dlocation_id"+i);
			old_dqty[i]= Double.parseDouble(request.getParameter("old_dqty"+i));
			old_drate[i]= Double.parseDouble(request.getParameter("old_drate"+i));
			new_drate[i]= Double.parseDouble(request.getParameter("drate"+i));
			dReceiveTransaction_Id[i]=request.getParameter("dReceiveTransaction_Id"+i); 
			firstdMov_WtdAvgflag[i] = request.getParameter("firstdMov_WtdAvgflag"+i); 
//			drate[i]=Double.parseDouble(request.getParameter("drate"+i));			
if(dlotno[i].equals(old_dlotno[i]))
			{
	//out.print("<br>488");
	dlotid[i]=old_dlotid[i];
	drate[i]=S.stockRate(conp,SD,company_id,dlotid[i]);
dlotflag[i]=true;

	if(dlocation_id[i].equals(old_dlocation_id[i]))
				{
		dlocationflag[i]=true;
					query="select Available_Carats from LotLocation where Lot_Id="+dlotid[i]+" and Location_Id="+dlocation_id[i];
					pstmt_p=conp.prepareStatement(query);
					rs_g=pstmt_p.executeQuery();
					double Available_Carats=0;
					while(rs_g.next())
					{
					Available_Carats=rs_g.getDouble("Available_Carats");
					}
					pstmt_p.close();
//			out.print("<br>717");
Available_Carats +=old_dqty[i];
					if(Available_Carats >=dqty[i])
					{
						dqtyflag[i]=true;
					}
	
	}//if location
}
else{
			 query="select count(Lot_Id) as lotcount from Lot where Lot_No='"+dlotno[i]+"'";
			pstmt_p=conp.prepareStatement(query);
			rs_g=pstmt_p.executeQuery();
			int lotcount=0;
			while(rs_g.next())
			{
				lotcount=rs_g.getInt("lotcount");
			}
			pstmt_p.close();
//			out.print("<br>681");
			if(lotcount>0)
			{
				dlotflag[i]=true;
				query="select Lot_Id from Lot where Lot_No='"+dlotno[i]+"'";
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				while(rs_g.next())
				{
					dlotid[i]=rs_g.getString("Lot_Id");
					drate[i]=S.stockRate(conp,SD,company_id,dlotid[i]);		

				}
				pstmt_p.close();
//			out.print("<br>693");

			}//else
}//else

if((!(dlotno[i].equals(old_dlotno[i])))||(!(dlocation_id[i].equals(old_dlocation_id[i]))))
			{
			query="select count(Lot_Id) as locationcount from LotLocation where Lot_Id="+dlotid[i]+" and Location_Id="+dlocation_id[i];
				pstmt_p=conp.prepareStatement(query);
				rs_g=pstmt_p.executeQuery();
				int locationcount=0;
				while(rs_g.next())
				{
					locationcount=rs_g.getInt("locationcount");
				}
				pstmt_p.close();
//			out.print("<br>704");

				if(locationcount>0)
				{
					dlocationflag[i]=true;
					query="select Available_Carats from LotLocation where Lot_Id="+dlotid[i]+" and Location_Id="+dlocation_id[i];
					pstmt_p=conp.prepareStatement(query);
					rs_g=pstmt_p.executeQuery();
					double Available_Carats=0;
					while(rs_g.next())
					{
						Available_Carats=rs_g.getDouble("Available_Carats");
					}
					pstmt_p.close();
//			out.print("<br>717");
					if(Available_Carats>=dqty[i])
					{dqtyflag[i]=true;}
				}
			}

			
		}//for
//	C.returnConnection(conp);	
		%>
<HTML>
<HEAD>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script language="JavaScript">

function findIndexOfField(frmIndex,fieldName)
{
	    counter=document.forms[frmIndex].length
        
        for(i=0;i<counter;i++)
	    { 
			if(document.forms[frmIndex].elements[i].name==fieldName)
			{
	    			 	return i		
			}

		} 
        return -1
}

function setMvwa(frmIndex,fieldName,resetFieldName,newValue,oldValue)
{
	index = findIndexOfField(frmIndex,fieldName)
	resetFieldNameIndex = findIndexOfField(frmIndex,resetFieldName)

	if(index>=0)
	{	
		   if(document.forms[0].elements[index].checked)
			{
			    document.forms[0].elements[resetFieldNameIndex].value= newValue
       //         document.forms[0].elements[resetFieldNameIndex].disabled = true
				document.forms[0].elements[index].value= 1
				
			}
			else	
		    { 
		//		document.forms[0].elements[resetFieldNameIndex].disabled = false
				document.forms[0].elements[resetFieldNameIndex].value= oldValue
                document.forms[0].elements[index].value= 0
				
				   
			}   

		
	}	
 
}

</script>

<script language=javascript>
function calcTotal()
{
var stotal=0;
var dtotal=0;
<%
for(int i=0;i<scounter;i++)
	{%>
	var stot=parseFloat(document.mainform.sqty<%=i%>.value)*parseFloat(document.mainform.srate<%=i%>.value);
	document.mainform.samount<%=i%>.value=stot;
	stotal=parseFloat(stotal)+parseFloat(stot);
<%	}%>

stotal=stotal.toFixed(<%=d%>);
document.mainform.stotalamt.value= stotal;

<%
for(int i=0;i<dcounter;i++)
	{%>
	var dtot=parseFloat(document.mainform.dqty<%=i%>.value)*parseFloat(document.mainform.drate<%=i%>.value);
	document.mainform.damount<%=i%>.value=dtot;
	dtotal=parseFloat(dtotal)+parseFloat(dtot);
<%	}%>

dtotal=dtotal.toFixed(<%=d%>);
document.mainform.dtotalamt.value= dtotal;

}
</script>
</HEAD>
<body bgcolor=ffffee background="../Buttons/BGCOLOR.JPG">

<%
boolean sfinalflag[]=new boolean[scounter];
boolean dfinalflag[]=new boolean[dcounter];
boolean sfflag=true;
boolean dfflag=true;
	for(int i=0;i<scounter;i++)
		{
		sfinalflag[i]=false;
			if(!slotflag[i])
			{%>
				<center><font class='msgred'>Lot No. <%=slotno[i]%> Does not exist.</font></center>
		<%	}
			else
			{
				if(!slocationflag[i])
				{%>
				<center><font class='msgred'>Lot No. <%=slotno[i]%> is not present at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+slocation_id[i])%>.</font></center>
			<%	}
				else
				{
					if(!sqtyflag[i])
					{%>
					<center><font class='msgred'>Lot No. <%=slotno[i]%> has insufficient quantity at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+slocation_id[i])%>.</font></center>
				<%	}
					else
					{
					sfinalflag[i]=true;
					}
				}
			}

		}
	for(int i=0;i<scounter;i++)
		{
			if(!sfinalflag[i])
			{%>
				<!-- <center><input type=button name=command value="Back" onclick="history.back(1)"></center> -->
		<%		sfflag=false;
				break;
			}
			else
			{
				sfflag=true;
			}

		}

	for(int i=0;i<dcounter;i++)
		{
		dfinalflag[i]=false;
			if(!dlotflag[i])
			{%>
				<center><font class='msgred'>Lot No. <%=dlotno[i]%> Does not exist.</font></center>
		<%	}
			else
			{
				if(!dlocationflag[i])
				{%>
				<center><font class='msgred'>Lot No. <%=dlotno[i]%> is not present at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+dlocation_id[i])%>.</font></center>
			<%	}
				else
				{
					if(!dqtyflag[i])
					{%>
					<center><font class='msgred'>Lot No. <%=dlotno[i]%> has insufficient quantity at Location <%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+dlocation_id[i])%>.</font></center>
				<%	}
					else
					{
					dfinalflag[i]=true;
					}
				}
			}

		}

	for(int i=0;i<dcounter;i++)
		{
			if(!dfinalflag[i])
			{%>
				<!-- <center><input type=button name=command value="Back" onclick="history.back(1)"></center> -->
		<%		dfflag=false;
				break;
			}
			else
			{
				dfflag=true;
			}

		}
if( (!(sfflag)) || (!(dfflag)) )
{	C.returnConnection(conp);	%>

<center><input type=button name=command value="Back" onclick="history.back(1)" class="button1"></center>
<%}
int setsmvwac=0;
int setdmvwac=0;

if(sfflag && dfflag)
{

%>

<FORM name=mainform
action="EditStockTransferUpdate.jsp?" method=post >
<input type=hidden name="scounter" value="<%=scounter%>">
<input type=hidden name="dcounter" value="<%=dcounter%>">
<input type=hidden name="StockTransfer_Type" value="<%=StockTransfer_Type%>">
<input type="hidden" name="sReceive_Id" value="<%=sReceive_Id%>">
<input type="hidden" name="dReceive_Id" value="<%=dReceive_Id%>">
<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
<tr>
<th colspan=2>Stock Transfer</th>
</tr>
<tr>
<td>
	<TABLE borderColor=skyblue align=center border=1  cellspacing=0 cellpadding=2>
	<tr>
	<td>Stock Transfer No.</td>
	<td><%=stocktransfer_no%><input type=hidden name="stocktransfer_no" value="<%=stocktransfer_no%>"></td>
	<td>
		
Ref. No<input type=text name=ref_no value="<%=ref_no%>" size=10 maxlength=10>
</td>
	
	<td>Transfer Date</td>
	<td><%=datevalue%><input type=hidden name="datevalue" value="<%=datevalue%>"></td>
	</tr>
	<tr>
	<td></td>
	<td></td>
	<td></td>
	<td>Stock Date</td>
	<td><%=stockdate%><input type=hidden name="stockdate" value="<%=stockdate%>"></td>
	</tr>
	<tr>
	<td></td>
	<td></td>
	<td></td>
	<td>Exchange Rate</td>
	<td><%=exchange_rate%><input type=hidden name="exchange_rate" value="<%=exchange_rate%>"></td>
	</tr>
	<% if(scounter>0)
		{%>

	<tr>
		<td colspan=2>
			<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
			<tr><th colspan=6>Source</th></tr>
			<tr>
				<td>Sr. No.</td>
				<td>Lot No.</td>
				<td>Location</td>
				<td>Quantity</td>
				<td>Rate</td>
				<td>Amount</td>
			<tr>
	<%double stotalqty=0;
	  double stotalamt=0;
		for(int i=0;i<scounter;i++)
		{%>
			<tr>
				<td><%=i+1%></td>
				<td><%=slotno[i]%><input type=hidden name="slotno<%=i%>" value="<%=slotno[i]%>"><input type=hidden name="slotid<%=i%>" value="<%=slotid[i]%>"><input type=hidden name="old_slotid<%=i%>" value="<%=old_slotid[i]%>"><input type=hidden name="sReceiveTransaction_Id<%=i%>" value="<%=sReceiveTransaction_Id[i]%>"></td>
				
				<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+slocation_id[i])%><input type=hidden name="slocation_id<%=i%>" value="<%=slocation_id[i]%>"><input type=hidden name="old_slocation_id<%=i%>" value="<%=old_slocation_id[i]%>"></td>
				<td align=right><%=str.format(""+sqty[i],3)%><input type=hidden name="sqty<%=i%>" value="<%=sqty[i]%>"><input type=hidden name="old_sqty<%=i%>" value="<%=old_sqty[i]%>"></td>
			<% stotalqty+=sqty[i];%>
					<%	//out.print("1418 old_sqty[i]"+old_sqty[i]); %>
<%
					
			 if(!StockTransfer_Type.equals("2"))  
			{  
				if(firstsMov_WtdAvgflag[i].equals("1"))
					{
				//	out.print("if firstsMov_WtdAvgflag[i]"+firstsMov_WtdAvgflag[i]);
%>					
				       	
						<td align=right><input type=text name="srate<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()"><input type=hidden name="smwa<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>"><input type=hidden name="smwaflag<%=i%>" value="<%=firstsMov_WtdAvgflag[i]%>"><input type=hidden name="old_srate<%=i%>" value="<%=old_srate[i]%>"></td>				
<%           
					}    
					else
                   {
				//		out.print("else firstsMov_WtdAvgflag[i]"+firstsMov_WtdAvgflag[i]);
						setsmvwac++;
%>						
						<td align=right><input type=text name="srate<%=i%>" value="<%=str.mathformat(""+new_srate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()"><input type=hidden name="smwa<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>"><input type=hidden name="smwaflag<%=i%>" value="0"><input type=hidden name="old_srate<%=i%>" value="<%=old_srate[i]%>">
			<input type="checkbox" name="setsmvwa<%=i%>"        onclick="setMvwa(0,'setsmvwa<%=i%>','srate<%=i%>','<%=str.mathformat(""+srate[i],d)%>','<%=str.mathformat(""+new_srate[i],d)%>' )"></td>		
						
<%	
			//	out.print(new_srate[i]);
					}  
			}
			else
			{				
%>

							<td align=right><input type=text name="srate<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()" readonly><input type=hidden name="smwa<%=i%>" value="<%=str.mathformat(""+srate[i],d)%>"><input type=hidden name="smwaflag<%=i%>" value="<%=firstsMov_WtdAvgflag[i]%>"><input type=hidden name="old_srate<%=i%>" value="<%=old_srate[i]%>"></td>				
<%

		
			 }
      %> 
				<td align=right><input type=text name="samount<%=i%>" value="<%=str.mathformat(""+(sqty[i]*srate[i]),d)%>" size=7 style="text-align:right" readonly></td>
			<% stotalamt+=sqty[i]*srate[i];%>
			<tr>
	<%	}%>
			<tr>
				<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
				<td align=right><%=str.format(""+stotalqty,3)%><input type=hidden name="stotalqty" value="<%=stotalqty%>"></td>
				<td>&nbsp;</td>
				<td align=right><input type=text name="stotalamt" value="<%=str.mathformat(""+stotalamt,d)%>" size=7 style="text-align:right" readonly></td>
			</tr>
			</table>
		</td>
<%}
else	
	{%>
<td colspan=2>
<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
<tr>
	<td height="88" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Gain </font></td>
	<input type=hidden name="scounter" value="0">
	<input type=hidden name="saddlots" value="0">
	<input type=hidden name="stotalqty" value="0">
	<input type=hidden name="stotalamt" value="0">

</tr>
	</table>	
</td>

<%	}%>

		<td></td>
				
<% if(dcounter>0)
		{%>

		<td colspan=2>
			<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
			<tr><th colspan=6>Destination</th></tr>
			<tr>
				<td>Sr. No.</td>
				<td>Lot No.</td>
				<td>Location</td>
				<td>Quantity</td>
				<td>Rate</td>
				<td>Amount</td>
			<tr>
	<%double dtotalqty=0;
	  double dtotalamt=0;
		for(int i=0;i<dcounter;i++)
		{%>
			<tr>
				<td><%=i+1%></td>
				<td><%=dlotno[i]%><input type=hidden name="dlotno<%=i%>" value="<%=dlotno[i]%>"><input type=hidden name="dlotid<%=i%>" value="<%=dlotid[i]%>"><input type=hidden name="old_dlotid<%=i%>" value="<%=old_dlotid[i]%>"><input type=hidden name="dReceiveTransaction_Id<%=i%>" value="<%=dReceiveTransaction_Id[i]%>"></td>
				<td><%=A.getNameCondition(conp,"Master_Location","Location_Name","where Location_Id="+dlocation_id[i])%><input type=hidden name="dlocation_id<%=i%>" value="<%=dlocation_id[i]%>"><input type=hidden name="old_dlocation_id<%=i%>" value="<%=old_dlocation_id[i]%>"></td>
				<td align=right><%=str.format(""+dqty[i],3)%><input type=hidden name="dqty<%=i%>" value="<%=dqty[i]%>" ><input type=hidden name="old_dqty<%=i%>" value="<%=old_dqty[i]%>"></td>
			<% dtotalqty+=dqty[i];%>
				<%	//out.print("1495 old_dlocation_id[i]"+old_dlocation_id[i]);
					//out.print("1495 dlocation_id[i]"+dlocation_id[i]);
				%>
<%
          if(!StockTransfer_Type.equals("2"))  
			{
				if(firstdMov_WtdAvgflag[i].equals("1"))
				{
	
				
%>
					
				<td align=right><input type=text name="drate<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()"><input type=hidden name="dmwa<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>"><input type=hidden name="dmwaflag<%=i%>" value="<%=firstdMov_WtdAvgflag[i]%>"><input type=hidden name="old_drate<%=i%>" value="<%=old_drate[i]%>"></td>
<%
					}
					else
			        {
						setdmvwac++;
%>
							<td align=right><input type=text name="drate<%=i%>" value="<%=str.mathformat(""+new_drate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()"><input type=hidden name="dmwa<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>"><input type=hidden name="dmwaflag<%=i%>" value="0"><input type=hidden name="old_drate<%=i%>" value="<%=old_drate[i]%>"><input type="checkbox" name="setdmvwa<%=i%>"        onclick="setMvwa(0,'setdmvwa<%=i%>','drate<%=i%>','<%=str.mathformat(""+drate[i],d)%>','<%=str.mathformat(""+new_drate[i],d)%>' )"></td>

<%
					}
				}
				else
			    {   				
%>
					
					<td align=right><input type=text name="drate<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>" size=7 style="text-align:right" onblur="calcTotal()" readonly><input type=hidden name="dmwa<%=i%>" value="<%=str.mathformat(""+drate[i],d)%>"><input type=hidden name="dmwaflag<%=i%>" value="<%=firstdMov_WtdAvgflag[i]%>"><input type=hidden name="old_drate<%=i%>" value="<%=old_drate[i]%>"></td>					
<%
	            }


%>
				<td align=right><input type=text name="damount<%=i%>" value="<%=str.mathformat(""+(dqty[i]*drate[i]),d)%>" size=7 style="text-align:right" readonly></td>
			<% dtotalamt+=dqty[i]*drate[i];%>
			</tr>
	<%	}%>
			<tr>
				<td colspan=3 align=right>Total :&nbsp;&nbsp;</td>
				<td align=right><%=str.format(""+dtotalqty,3)%><input type=hidden name="dtotalqty" value="<%=dtotalqty%>"></td>
				<td>&nbsp;</td>
				<td align=right><input type=text name="dtotalamt" value="<%=str.mathformat(""+dtotalamt,d)%>"  size=7 style="text-align:right" readonly></td>
			</tr>


	</table>
		</td>
<%}
else	
	{%>
<td colspan=2>
<TABLE bordercolor=silver align=center border=1  cellspacing=0 cellpadding=2 width="100%" height="100%">
<tr>
	<td height="88" align=center><font face="Embassy BT" size="72" color="#B0B0B0"> Loss / Wastage</font></td>
	<input type=hidden name="dcounter" value="0">
	<input type=hidden name="daddlots" value="0">
	<input type=hidden name="dtotalqty" value="0">
	<input type=hidden name="dtotalamt" value="0">

</tr>
	</table>	
</td>

<%	}%>
	</tr>
	</table>	
</td>
</tr>
	
<tr>
<td colspan=1>Narration <input type=text size=75 name=description value="<%=description%>"></td>
</tr>
<tr>
		<td align=left><input type=button name="command" value="Back" onclick="history.back(1)" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"> &nbsp <input type=submit name="command" value="Update" class="button1" onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"></td>
	</tr>
</table>
<%
}
		//}//type =3 
			C.returnConnection(conp);	
	}
}catch(Exception e) { out.print("<br> 551 "+e); }
%>
