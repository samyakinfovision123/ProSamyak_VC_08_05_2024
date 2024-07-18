<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean id="YED"  scope="application" class="NipponBean.YearEndDate" />

<%
try{

	ResultSet rs_g = null;
	Connection conp = null;
	Connection conm = null;
	PreparedStatement pstmt_p=null;

	
	conp=C.getConnection();
	conm=C.getConnection();

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	//out.print("<br>20 D="+D);
	String today_string= format.format(D);

	String yearend_id= ""+session.getValue("yearend_id");
	//System.out.println(" 28 yearend_id"+yearend_id);
	String freeze=A.getNameCondition(conp,"Yearend","Freeze","where yearend_id="+yearend_id+"");

	//out.print("<br> 20 freeze"+freeze);

	int newyearend_id=0;
	boolean all_yearEndStep1=true; 
	String company_id= ""+session.getValue("company_id");
	//System.out.println("32 company_id="+company_id);
	String user_id= ""+session.getValue("user_id");
	//System.out.println("34 user_id="+user_id);
	int int_companyid=Integer.parseInt(company_id);
	//System.out.println("36 int_companyid="+int_companyid);
	String company_name= A.getName(conp,"companyparty",company_id);
	//System.out.println("38 company_name="+company_name);
	String user_name= A.getName(conp,"User",user_id);
	//System.out.println("40 user_name="+user_name);
	
	C.returnConnection(conp);

	String local_currencysymbol="";
	String today_exrate="";
	String loc_currency="";
	int d=0;
	if (int_companyid > 0)
	{
		conp=C.getConnection();

		local_currencysymbol= I.getLocalSymbol(conp,company_id);
		//out.println("local_currencysymbol"+local_currencysymbol);
		String local_currencyid=I.getLocalCurrency(conp,company_id);
		//out.print("<br>54 local_currencyid="+local_currencyid);
		loc_currency=A.getNameCondition(conp,"Master_Currency","Currency_Name","where Currency_Id="+local_currencyid+"");
		//System.out.println("56 loc_currency=="+loc_currency);

		int currency_id=Integer.parseInt(local_currencyid);

		//out.println("local_currencyid"+local_currencyid);
		//System.out.println("59 currency_id"+currency_id);

		//out.println("today_string:"+today_string);


		String query="Select * from Master_ExchangeRate where Exchange_Date=?	and  Currency_Id=?";
		//out.print("<br>65^^^query^^^"+query);
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+D);
		pstmt_p.setString(2,""+currency_id);	
		rs_g = pstmt_p.executeQuery();
		//System.out.println("70 QUERY="+query);

		String localsymbol ="";
		int i=0;
		while(rs_g.next())
		{
			i++;
			today_exrate=rs_g.getString("Exchange_Rate");
			//System.out.println("80 today_exrate="+today_exrate);
		}
		//while
		pstmt_p.close();

		query="SELECT max(yearend_id) as maxy_id from yearend where company_id=?";

		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+company_id);
		rs_g = pstmt_p.executeQuery();
		//out.println("<br>"+query);

		while(rs_g.next())
		{
			newyearend_id =rs_g.getInt("maxy_id");			
		}
		//while
		pstmt_p.close();

		//C.returnConnection(conp);
		//System.out.println(" 101 newyearend_id"+newyearend_id);

		//System.out.println("<br> i is 12321312::::="+i);	
		//System.out.println("104 'i'=>"+i);
		if (i>0)
		{	
			//System.out.println("Inside condition i>0=>");
			//conp=C.getConnection();
			//System.out.println("//////////////////////////");
			//System.out.println("currency_id="+currency_id);
			//System.out.println("//////////////////////////");
			d=	Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",""+currency_id));
			//System.out.println("<br>109 d=="+d);
			//out.println("<b><font color=navy size=1><marquee>Today's Exchange Rate is "+local_currencysymbol+" "+str.format(today_exrate,d)+" / US $</font></b></marquee>");
			//C.returnConnection(conp);
		}
		else
		{
			C.returnConnection(conp);
			response.sendRedirect("TodayExchangeRate.jsp?command=Default&message=Default");
			//System.out.println("<font color=red >Today Exchange Rate not Present</font>");
		}
		C.returnConnection(conp);
	}//if 

	if (int_companyid <= 0)
	{
		response.sendRedirect("AdminLeft.jsp");
	}
	else 
	{
		conp=C.getConnection();
		String base_exchangerate= I.getLocalExchangeRate(conp,company_id);
		C.returnConnection(conp);

%>

<html>
<head>
	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT LANGUAGE="JavaScript">
var timerID = null
var timerRunning = false

function stopclock(){
    if(timerRunning)
        clearTimeout(timerID)
    timerRunning = false
}

function startclock(){
    stopclock()
    showtime()
}

function showtime(){
    var now = new Date()
    var hours = now.getHours()
    var minutes = now.getMinutes()
    var seconds = now.getSeconds()
    var timeValue = "" + ((hours > 12) ? hours - 12 : hours)
    timeValue  += ((minutes < 10) ? ":0" : ":") + minutes
    timeValue  += ((seconds < 10) ? ":0" : ":") + seconds
    timeValue  += (hours >= 12) ? " P.M." : " A.M."
    document.clock.face.value = timeValue 
    timerID = setTimeout("showtime()",1000)
    timerRunning = true
}
</SCRIPT>
	</head>
<body background="../Buttons/BGCOLOR.JPG"  bgcolor="#ffffff" style="margin:0px" onLoad="startclock()">
<form name="clock" onSubmit="0">
<table border=0 cellspacing=0 cellpadding=0 width='100%' bgcolor=#00308F bordercolor=#33FF00 >

<tr><td HEIGHT="2" class=white>
	Date:<%=today_string%>  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Time:<INPUT TYPE="text" NAME="face" SIZE=10 VALUE ="....Initializing...." readonly	class="iprdonly1">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	User:<%=user_name%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<%=company_name%> 
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Local Currency:<%=loc_currency%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Exchange Rate:<%=str.format(today_exrate,2)%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	
 <a href='SamyakSession.jsp' target=_parent>
<font color="white">Logout</font> </a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href='../right.html' target=right><font color="white">
Clear Screen</font></a> 
</td></tr>
<tr><td><IMG SRC="../top_sparkler.jpg" WIDTH="100%" HEIGHT="80" BORDER=0 ALT=""> </td></tr>

	</table>
	
<%
//out.print("<br>191 yearend_id="+yearend_id);
/*
String startDate =""+A.getNameCondition(conm,"YearEnd","From_Date","where YearEnd_Id="+yearend_id );
System.out.println("<br>193 startDate="+startDate);
String endDate =""+A.getNameCondition(conm,"YearEnd","To_Date","where YearEnd_Id="+yearend_id );
System.out.println("<br>195 endDate="+endDate);




String startDate1 = format.format(YED.getDate(conm,"YearEnd","From_Date","where YearEnd_Id="+yearend_id));

//System.out.println("<br> 193 startDate1=="+startDate1);
String endDate1 =format.format(YED.getDate(conm,"YearEnd","To_Date","where  YearEnd_Id="+yearend_id));
//sSystem.out.println("<br> 195 endDate1=="+endDate1);
 */
 C.returnConnection(conm);

%>


</form>
	<script type='text/javascript'>function Go(){return}</script>
	<script type='text/javascript' >


			var local_currencysymbol='<%=local_currencysymbol%>';
		var cuurr_date='<%=today_string%>';


	var NoOffFirstLineMenus=8;		
	var LowBgColor="#00308F";			
	var HighBgColor="white";			
	var FontLowColor="white";			
	var FontHighColor="#00308F";		
	var BorderColor="#6666FF";	
	
	var BorderWidthMain=1;			
	var BorderWidthSub=1;			
 	var BorderBtwnMain=1;			
	var BorderBtwnSub=1;			
	var FontFamily="Tahoma,technical,arial";	
	var FontSize=13;				
	var FontBold=0;				
	var FontItalic=0;				
	var MenuTextCentered="left";		 
	var MenuCentered="left";			
	var MenuVerticalCentered="left";		
	var ChilSamyakrlap=.1;			
	var ChildVerticalOverlap=.1;			
	var StartTop=0;				
	var StartLeft=0;				
	var VerCorrect=0;				
	var HorCorrect=0;				
	var DistFrmFrameBrdr=0;			
	var LeftPaddng=8;				
	var TopPaddng=-1;				
	var FirstLineHorizontal=1;			
	var MenuFramesVertical=0;			
	var DissapearDelay=1000;			
	var UnfoldDelay=100;			
	var TakeOverBgColor=1;			
	var FirstLineFrame="navig";			
	var SecLineFrame="right";			
	var DocTargetFrame="right";		
	var TargetLoc="MenuPos";			
	var MenuWrap=1;				
	var RightToLeft=0;				
	var BottomUp=0;				
	var UnfoldsOnClick=0;			
	var BaseHref="";				
					
	var Arrws=[BaseHref+"tri.gif",5,10,BaseHref+"tridown.gif",10,5,BaseHref+"trileft.gif",5,10,BaseHref+"triup.gif",10,5];

					

	var MenuUsesFrames=1;			

	var RememberStatus=0;			
	var BuildOnDemand=0;			
	var BgImgLeftOffset=5;			
	var ScaleMenu=0;				

	var HooverBold=0;				
	var HooverItalic=0;				
	var HooverUnderLine=1;			
	var HooverTextSize=0;			
	var HooverVariant=0;			

	var MenuSlide="";
	var MenuSlide="progid:DXImageTransform.Microsoft.RevealTrans(duration=.5, transition=19)";
	var MenuSlide="progid:DXImageTransform.Microsoft.GradientWipe(duration=.5, wipeStyle=1)";

	var MenuShadow="";
	var MenuShadow="progid:DXImageTransform.Microsoft.DropShadow(color=#888888, offX=2, offY=2, positive=1)";
	var MenuShadow="progid:DXImageTransform.Microsoft.Shadow(color=#888888, direction=135, strength=3)";

	var MenuOpacity="";
	var MenuOpacity="progid:DXImageTransform.Microsoft.Alpha(opacity=75)";

	function BeforeStart(){return}
	function AfterBuild(){return}
	function BeforeFirstOpen(){return}
	function AfterCloseAll(){return}

	function d(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=yes", "Location=0","Menubar=yes","Height=700","Width=700", "Resizable=yes","Scrollbars=yes","status=no"])
}

	function dnew1(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=700", "Resizable=yes","Scrollbars=yes","status=no"])
}
	
	function dd(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=no","Height=500","Width=600", "Resizable=no","Scrollbars=no","status=no"])
}	
	
	
	
	
	function j(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=no","Height=500","Width=700", "Resizable=no","Scrollbars=no","status=no"])
}

function tb(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=700", "Resizable=yes","Scrollbars=yes","status=no"])
}

// Menu tree:
// MenuX=new Array("ItemText","Link","background image",number of sub elements,height,width,"bgcolor","bghighcolor",
//	"fontcolor","fonthighcolor","bordercolor","fontfamily",fontsize,fontbold,fontitalic,"textalign","statustext");
// Color and font variables defined in the menu tree take precedence over the global variables
// Fontsize, fontbold and fontitalic are ignored when set to -1.
// For rollover images ItemText or background image format is:  "rollover?"+BaseHref+"Image1.jpg?"+BaseHref+"Image2.jpg" 

Menu1=new Array("Purchase","","",4,20,100,"","","","","","",-1,-1,-1,"center","Accounting Software - Purchase");


<%
	if("0".equals(freeze))
	{
 %>
	Menu1_1=new Array("Purchase In","../Consignment/cgtConfirmOrPurchase.jsp?command=Default&lots=3&stock=no&invoicedate="+cuurr_date+"&Receive_Id=0","",0,20,100,"","","","","","",-1,-1,-1,"","Accounting Software - Purchase");


<%
	}
else
	{
%>
	Menu1_1=new Array("Local","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
<%
	}
%>
	Menu1_2=new Array("Pending Split ","../Consignment/cgtPendingSplitReport.jsp?command=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

	Menu1_3=new Array("Reports >","","",1,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

	Menu1_3_1=new Array("Book","../Inventory/InvReport.jsp?command=PurchaseReport&message=Default&pieces=no&summary=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

	Menu1_4=new Array("Edit >","","",1,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase ");
	
<%
	if("0".equals(freeze))
	{
%>
	//Menu1_4_1=new Array("Purchase","../Master/EditPurchase.jsp?command=PurchaseReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	Menu1_4_1=new Array("Purchase","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	
<%
	}
else
	{
%>
	Menu1_4_1=new Array("Purchase","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
<%
	}
%>

//////////////////////////////////
//blocked old links             //
//////////////////////////////////

<%
//	if("0".equals(freeze))
//	{
     
	 %>
//	Menu1_1=new Array("Local","../Inventory/InvReceive.jsp?command=Default&lots=1&message=Default&purchase=Local&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");


<%
//	}
//else
//	{
		%>
//Menu1_1=new Array("Local","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
<%
//	}
%>
	
<%
//	if("0".equals(freeze))
//	{
     
	 %>
//Menu1_2=new Array("Dollar","../Inventory/InvReceive.jsp?command=Default&lots=1&message=Default&purchase=Import&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase ");
<%
//	}
//else
//	{
		%>

//Menu1_2=new Array("Dollar","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase ");
<%//}%>

//	Menu1_3=new Array("Return >","","",3,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

<%
//	if("0".equals(freeze))
//	{
     
	 %>

//	Menu1_3_1=new Array("Purchase (Inv)","../Inventory/ReturnPurchase.jsp?command=PurchaseReport&message=masters","",0,20,120,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	
	<%
//	}
//else
//	{
		%>


//Menu1_3_1=new Array("Purchase (Inv)","","",0,20,120,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
<%//}%>

<%
//	if("0".equals(freeze))
//	{
     
	 %>

//	Menu1_3_2=new Array("Local","../Inventory/ReturnPurchaseWOInv.jsp?command=Default&lots=1&message=Default&sale=Local&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,120,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	<%
//	}
//else
//	{
		%>

//	Menu1_3_2=new Array("Local","","",0,20,120,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");


	<%//}%>
	
	<%

//if("0".equals(freeze))
//	{
     
	 %>
//	Menu1_3_3=new Array("Dollar","../Inventory/ReturnPurchaseWOInv.jsp?command=Default&lots=1&message=Default&sale=Export&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

<%
//	}
//else
//	{
		%>


//Menu1_3_3=new Array("Dollar","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
<%// }%>

//	Menu1_4=new Array("Reports >","","",6,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

	//Menu1_4_1=new Array("Book","../Inventory/InvReport.jsp?command=PurchaseReport&message=Default&pieces=no&summary=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
//	Menu1_4_1=new Array("Book","../Inventory/InvReportNew.jsp?command=PurchaseReport&message=Default&pieces=no&summary=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

//	Menu1_4_2=new Array("Summary Report","../Inventory/InvReport.jsp?command=PurchaseReport&message=Default&pieces=no&summary=yes","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

//	Menu1_4_3=new Array("Book Detailed","../Inventory/InvReportDetail.jsp?command=PurchaseReport&message=Default&pieces=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	
//	Menu1_4_4=new Array("Register","../Inventory/InvRegister.jsp?command=PurchaseReport&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
//	Menu1_4_5=new Array("Payment","../Inventory/InvFinanceReport.jsp?command=PurchaseReport","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
//	Menu1_4_6=new Array("Return","../Report/ReturnReport.jsp?command=PurchaseReturn","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	
//	Menu1_5=new Array("Edit >","","",2,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase ");
	
	<%

//if("0".equals(freeze))
//	{
     
	 %>
	
	
//	Menu1_5_1=new Array("Purchase","../Master/EditPurchase.jsp?command=PurchaseReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
	
	<%
//	}
//else
//	{
		%>

//Menu1_5_1=new Array("Purchase","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");
			<%
//				}
			%>
	

<%

//if("0".equals(freeze))
//	{
     
	 %>
//	Menu1_5_2=new Array("Return","../Master/EditPurchaseReturn.jsp?command=SaleReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");

<%
//	}
//else
//	{
		%>
//Menu1_5_2=new Array("Return","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");


<%
//	}
%>


Menu2=new Array("Sale","","",4,20,100,"","","","","","",-1,-1,-1,"center","  Accounting Software - Sale");

<%
if("0".equals(freeze))
{
%>
	Menu2_1=new Array("Sale","../Inventory/InvSell_New.jsp?command=Default&lots=3&sale=Local&message=Default&pieces=no&stock=no&ledgers=0&Receive_Id=0&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
<%
}
else
{
%>
	Menu2_1=new Array("Sale","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
<%
}
%>

<%

//if("0".equals(freeze))
//	{
     
	 %>
	
//	Menu2_1=new Array("Local","../Inventory/InvSell.jsp?command=Default&lots=1&sale=Local&message=Default&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
//	}
//else
//	{
		%>

//Menu2_1=new Array("Local","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

<% 
	//}
%>
	

<%

//if("0".equals(freeze))
//	{
     
	 %>
	
	
//	Menu2_2=new Array("Dollar","../Inventory/InvSell.jsp?command=Default&lots=1&sale=Export&message=Default&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
//	}
//else
//	{
		%>

//	Menu2_2=new Array("Dollar","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
//	}
	%>
	


//	Menu2_3=new Array("Return >","","",3,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");



    	<%

//if("0".equals(freeze))
//	{
     
	 %>
//	Menu2_3_1=new Array("Sale (Inv)","../Inventory/ReturnSale.jsp?command=SaleReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

    <%
//	}
//else
//	{
		%>

//Menu2_3_1=new Array("Sale (Inv)","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");


<%
	//}
%>


<%

//if("0".equals(freeze))
//	{
     
	 %>
//	Menu2_3_2=new Array("Local","../Inventory/ReturnSaleWOInv.jsp?command=Default&lots=1&message=Default&purchase=Local&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	
	 <%
//	}
//else
//	{
		%>

//	Menu2_3_2=new Array("Local","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	
	<%
	//}
	%>



<%

//if("0".equals(freeze))
//	{
     
	 %>
//	Menu2_3_3=new Array("Dollar","../Inventory/ReturnSaleWOInv.jsp?command=Default&lots=1&message=Default&purchase=Export&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
//	}
//else
//	{
		%>

//Menu2_3_3=new Array("Dollar","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

			<%
//			}
			%>
	
	
	
	Menu2_2=new Array("Reports >","","",9,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	//Menu2_4_1=new Array("Book","../Inventory/InvReport.jsp?command=SaleReport&message=Default&pieces=no&summary=no","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_1=new Array("Book","../Inventory/InvReportNew.jsp?command=SaleReport&message=Default&pieces=no&summary=no","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_2=new Array("Summary","../Inventory/InvReport.jsp?command=SaleReport&message=Default&pieces=no&summary=yes","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_3=new Array("Book Detailed","../Inventory/SaleInvReportDetail.jsp?command=SaleReport&message=Default&pieces=no","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_4=new Array("Register","../Inventory/InvRegister.jsp?command=SaleReport&message=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_5=new Array("Receipt","../Inventory/InvFinanceReport.jsp?command=SaleReport","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_6=new Array("Return","../Report/SaleReturnReport1.jsp?command=SaleReturn","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_7=new Array("Sales Person","../Inventory/InvSalesPersonReport.jsp?command=SalesPerson","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_8=new Array("Interest Calculation","../Inventory/InterestCalculation.jsp?command=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	Menu2_2_9=new Array("Sales Order","../Inventory/SaleOrderReport.jsp?command=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

	
	
	
	
//	Menu2_5=new Array("Edit >","","",2,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");


	<%

//if("0".equals(freeze))
//	{
     
	 %>
	/*
	// Menu2_5_1=new //Array("Sale","../Master/EditSale.jsp?command=SaleReport&message=m//asters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting //Software - Sale");
	*/
//	Menu2_5_1=new Array("Sale ","../Master/EditSale1.jsp?command=SaleReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

   <%
//	}
//else
//	{
		%>
//Menu2_5_1=new //Array("Sale","","",0,20,100,"","","","","","",-1,-1,-1,"","  //Accounting Software - Sale");
//Menu2_5_1=new Array("Sale ","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

<%
//}
%>

  <%

//if("0".equals(freeze))
//	{
     
	 %>

//	Menu2_5_2=new Array("Return","../Master/EditSaleReturn.jsp?command=PurchaseReport&message=masters","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

  
   <%
//	 }
//else
//	{
		%>

// Menu2_5_2=new Array("Return","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");

  <%
	  //}
 %>

<%

if("0".equals(freeze))
	{
     
%>
	
	Menu2_3=new Array("Sale Order","../Inventory/SaleOrder1.jsp?command=Default&lots=1&sale=Local&message=Default&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
	}
else
	{
%>

Menu2_3=new Array("Sale Order","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");


<% }
%>

<%

if("0".equals(freeze))
	{
     
%>
	
	Menu2_4=new Array("SO Close","../Inventory/SaleOrderClose.jsp?command=Purchase&message=masters&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");
	<%
	}
else
	{
%>

Menu2_4=new Array("SO Close","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Sale");


<% }
%>

Menu3=new Array("Consignment","","",10,20,140,"","","","","","",-1,-1,-1,"center","  Accounting Software - Consignment");


<%

if("0".equals(freeze))
	{
     
	 %>
Menu3_1=new Array("Purchase","../Consignment/CgtReceive.jsp?command=Default&lots=1&stock=no&invoicedate="+cuurr_date+"","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
  <%
	 }
else
	{
		%>

Menu3_1=new Array("Purchase","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%

if("0".equals(freeze))
	{
     
	 %>

Menu3_2=new Array("Sale","../Consignment/CgtSell.jsp?command=Default&lots=1&stock=no&invoicedate="+cuurr_date+"","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
   <%
	 }
else
	{
		%>

   Menu3_2=new Array("Sale","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

   <%}%>


<%

if("0".equals(freeze))
	{
     
	 %>
Menu3_3=new Array("Purchase R/C","../Consignment/CgtReceiveReturnConfrime.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");


  <%
	 }
else
	{
		%>

Menu3_3=new Array("Purchase R/C","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%

if("0".equals(freeze))
	{
     
	 %>

Menu3_4=new Array("Sale R/C","../Consignment/CgtSellConfrimReturn.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
		%>

Menu3_4=new Array("Sale R/C","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%}%>

Menu3_5=new Array("Reports >","","",3,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_1=new Array("Purchase >","","",5,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_1_1=new Array("Book","../Consignment/CgtReport.jsp?command=PurchaseReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_1_2=new Array(" Return","../Consignment/ReturnReport.jsp?command=ReturnReport","",0,20,140,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1_3=new Array(" Status","../Consignment/CurrentStatusReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_1_4=new Array("Analysis", "../Consignment/CurrentStatusReport.jsp?command=DefaultAnalysis","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_1_5=new Array("Confirm", "../Consignment/InvReportAnalysis.jsp?command=PurchaseReport&message=Default&pieces=no","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2=new Array("Sale >","","",5,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2_1=new Array("Book","../Consignment/CgtReport.jsp?command=SaleReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2_2=new Array(" Return","../Consignment/SaleReturnReport.jsp?command=SaleReturnReport","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2_3=new Array(" Status","../Consignment/SaleCurrentStatusReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2_4=new Array("Analysis", "../Consignment/SaleCurrentStatusReport.jsp?command=SaleDetailAnalysis","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_2_5=new Array("Confirm", "../Consignment/InvReportAnalysis.jsp?command=SaleReport&message=Default&pieces=no&summary=no","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
Menu3_5_3=new Array("Cgt In Confirm Note", "../Report/CgtConfirmNoteSelection.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");


Menu3_6=new Array("Edit >","","",6,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%

if("0".equals(freeze))
	{
     
	 %>



Menu3_6_1=new Array("Purchase","../Master/EditCgtPurchase.jsp?command=PurchaseReport&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
		%>

Menu3_6_1=new Array("Purchase","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu3_6_2=new Array("Purchase Return","../Consignment/EditCgtPurchaseReturn.jsp?command=PurchaseReturnEdit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
		%>

Menu3_6_2=new Array("Purchase Return","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu3_6_3=new Array("Purchase Confirm","../Consignment/EditCgtPurchaseConfirm.jsp?command=PurchaseConfirmEdit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
		%>
Menu3_6_3=new Array("Purchase Confirm","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu3_6_4=new Array("Sale","../Master/EditCgtSale.jsp?command=SaleReport&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
		%>
Menu3_6_4=new Array("Sale","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu3_6_5=new Array("Sale Return","../Consignment/EditCgtSaleReturn.jsp?command=SaleReturnEdit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%
	 }
else
	{
%>
Menu3_6_5=new Array("Sale Return","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu3_6_6=new Array("Sale Confirm","../Consignment/EditCgtSaleConfirm.jsp?command=SaleConfirmEdit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%
	 }
else
	{
%>
Menu3_6_6=new Array("Sale Confirm","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

Menu3_7=new Array("Cgt In ","../Consignment/cgtIn.jsp?command=Default&lots=3&stock=no&invoicedate="+cuurr_date+"","",0,20,140,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_8=new Array("Cgt In Confirm ","../Consignment/CgtInConfirm.jsp?command=Default&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","Consignment");

Menu3_9=new Array("Pending Compare ","../Consignment/cgtPendingCompareReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Purchase");


<%
if("0".equals(freeze))
{
%>
Menu3_10=new Array("Cgt Out","../Consignment/CgtSellNew.jsp?command=Default&lots=3&stock=no&invoicedate="+cuurr_date+"","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
  <%
	 }
else
	{
		%>

Menu3_10=new Array("Cgt Out","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>


Menu4=new Array("Inventory","","",9,20,100,"","","","","","",-1,-1,-1,"center","  Accounting Software - Inventory");



Menu4_1=new Array("Add New >","","",8,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");


<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_1_1=new Array("Diamond", "javascript:d(\"../Master/NewLot.jsp?message=Default\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_1_1=new Array("Diamond", "","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_2=new Array("Eff. Rate","javascript:dnew1(\"../Master/Efective_Rate.jsp?Flag=false&message=Default\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>

Menu4_1_2=new Array("Eff. Rate","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_3=new Array("Jewelry","javascript:d(\"../Master/NewJewellary.jsp?command=Default&message=masters\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>

Menu4_1_3=new Array("Jewelry","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_4=new Array("Item","javascript:d(\"../Master/NewItem.jsp?command=Category&message=Default\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>

Menu4_1_4=new Array("Item","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_5=new Array("Location","../Master/NewLocation.jsp?command=Default&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_1_5=new Array("Location","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>



<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_6=new Array("Unit","../Master/NewUnit.jsp?command=Default&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>

Menu4_1_6=new Array("Unit","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_1_7=new Array("Category","../Master/NewCategory.jsp?command=Default&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_1_7=new Array("Category","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>


Menu4_1_8=new Array("Sub Category","../Master/NewSubCategory.jsp?command=Default&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_1_8=new Array("Sub Category","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");


	<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_2=new Array("Opening Stock","../Master/OpeningStock.jsp?command=Default&message=Default","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>

Menu4_2=new Array("Opening Stock","","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_3=new Array("Optimum. Qty","../Master/OptimumQuantity.jsp?command=Default&message=Default","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");


<%
	 }
else
	{
%>

Menu4_3=new Array("Optimum. Qty","","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>



Menu4_4=new Array("Stock Transfer >","","",9,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_4_1=new Array("Location","../Inventory/LocationTransfer.jsp?command=Default&lots=1&StockTransfer_Type=2","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_4_1=new Array("Location","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>



Menu4_4_2=new Array("Lot","../Inventory/LotTransfer.jsp?command=Default&lots=1&StockTransfer_Type=1","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_4_2=new Array("Lot","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_4_3=new Array("Manufacturing","../Inventory/StockTransferType.jsp?command=Default&slots=1&dlots=1&StockTransfer_Type=4","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>

Menu4_4_3=new Array("Manufacturing","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>


Menu4_4_4=new Array("Melting","../Inventory/StockTransferType.jsp?command=Default&slots=1&dlots=1&StockTransfer_Type=5","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");


<%
	 }
else
	{
%>

Menu4_4_4=new Array("Melting","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_4_5=new Array("Loss","../Inventory/StockTransferType.jsp?command=Default&slots=1&dlots=0&StockTransfer_Type=6","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>


Menu4_4_5=new Array("Loss","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_4_6=new Array("Gain","../Inventory/StockTransferType.jsp?command=Default&slots=0&dlots=1&StockTransfer_Type=7","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>

Menu4_4_6=new Array("Gain","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_4_7=new Array("Auto Gain Loss" ,"../Report/stockGainLoss.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

<%
	 }
else
	{
%>
Menu4_4_7=new Array("Auto Gain Loss" ,"","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_4_8=new Array("Warehouse Transfer","../Inventory/warehouseTransfer.jsp?command=Default&lots=1&StockTransfer_Type=2","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_4_8=new Array("Warehouse Transfer","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_4_9=new Array("Stock-In/Out","../Inventory/Stock_InOut.jsp?command=Default&lots=1&message=xyz&StockTransfer_Type=4","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_4_9=new Array("Stock-In/Out","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

Menu4_5=new Array("Picture >","","",2,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");


<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_5_1=new Array("Upload","../Inventory/PictureUploadForm.jsp?message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_5_1=new Array("Upload","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_5_2=new Array("Modify","../Master/PictureModifyForm.jsp?message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_5_2=new Array("Modify","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>



Menu4_6=new Array("GIA-Rapaport >","","",2,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_6_1=new Array("Upload","../Inventory/GIARapaportUploadForm.jsp?message=Default","",0,20,100,"","","","","","",-1,-1,-1,""," Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_6_1=new Array("Upload","","",0,20,100,"","","","","","",-1,-1,-1,""," Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_6_2=new Array("Modify","../Master/GIARapaportModifyForm.jsp?message=Default","",0,20,100,"","","","","","",-1,-1,-1,""," Accounting Software - Inventory");
<%
	 }
else
	{
%>

Menu4_6_2=new Array("Modify","","",0,20,100,"","","","","","",-1,-1,-1,""," Accounting Software - Inventory");
<%}%>

Menu4_7=new Array("Reports >","","",16,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

//Menu4_7_1=new Array("Stock","../Report/CgtStReport.jsp?command=StockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
//Menu4_7_2=new Array("Location Stock","../Report/LocationReport.jsp?command=StockReport&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_1=new Array("Stock","../Report/CgtStReportNew.jsp?command=StockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_2=new Array("Location Stock","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_3=new Array("Stock Summary >","","",2,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_3_1=new Array("Local","../Inventory/InvStockSummaryNew.jsp?command=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_3_2=new Array("Dollar","../Inventory/InvStockSummarydollarNew.jsp?command=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
//Menu4_7_3_3=new Array("Diamond","../Report/StockReportSummaryDiamond.jsp?command=StockReport&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
//Menu4_7_3_4=new Array("Jewelry","../Report/StockReportSummary.jsp?command=StockReport&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_4=new Array("Stock Transfer","../Inventory/InvStockTransferReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
//Menu4_7_5=new Array("Lot History","../Report/LotHistory.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_5=new Array("LotHistory","../Report/LotHistoryNew.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");




Menu4_7_6=new Array("Lot Movement","../Report/LotMovement.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_7=new Array("Lot Matrix >","","",4,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_7_1=new Array("Diamond","../Report/DiamondLot.jsp?command=Default","",0,20,130,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_7_2=new Array("Jewelry","../Report/NewjewelryLot1.jsp?command=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_7_3=new Array("Opening Diamond","../Report/OpeningStockMatrix.jsp?command=Default&message=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_7_4=new Array("Opening Jewelry","../Report/OpeningStockMatrix.jsp?command=Default&message=Default","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_8=new Array("Alert >","","",2,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_8_1=new Array("Reorder Qty","javascript:tb(\"../Report/AlertReorder.jsp?command=Default\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_8_2=new Array("Optimum Qty ","javascript:tb(\"../Report/AlertOptimum.jsp?command=Default\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_9=new Array("Picture","../Report/Picture.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

//Menu4_7_10=new Array("Stock Verfication","../Report/StockVerification.jsp?command=StockReport&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_10=new Array("Phy. Stock Ver. ","../Report/PhysicalStockVerificationReport.jsp?command=PhysicalStockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_11=new Array("Location Stock Report","../Report/CgtStLocationReport.jsp?command=StockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_12=new Array("Warehouse Transfer","../Inventory/NewSalesPersonTransferReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_7_13=new Array("Lot Location History","../Report/LotLocationHistory.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_14=new Array("LotMovement Report","../Report/LotmovementReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_15=new Array("Fast Stock","../Report/CgtStReportFast.jsp?command=StockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
Menu4_7_16=new Array("Global Stock","../Report/GlobalStReportFast.jsp?command=StockReport&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

Menu4_8=new Array("Edit >","","",7,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_8_1=new Array("Opening Stock","../Master/EditOpeningStock.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>

Menu4_8_1=new Array("Opening Stock","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_8_2=new Array("Lot","../Master/EditLot.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_8_2=new Array("Lot","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_8_3=new Array("Location","../Master/EditLocation.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_8_3=new Array("Location","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_8_4=new Array("Category","../Master/EditCategory.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
	Menu4_8_4=new Array("Category","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
	<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_8_5=new Array("Sub Category","../Master/EditSubCategory.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%
	 }
else
	{
%>
Menu4_8_5=new Array("Sub Category","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_8_6=new Array("Unit","../Master/EditUnit.jsp?command=edit&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>

	Menu4_8_6=new Array("Unit","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu4_8_7=new Array("Stock Transfer","../Master/EditStockTransferReport.jsp?command=Default&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_8_7=new Array("Stock Transfer","","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>
//Menu4_8_8=new Array("Warehouse Transfer","../Master/EditSalesPersonTransferReport.jsp?command=Default&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
//Menu4_8_9=new Array("Reverse Warehouse Transfer","../Master/EditReverseStockTransferReport.jsp?command=Default&message=Default","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
if("0".equals(freeze))
	{
     
	 %>

Menu4_9=new Array("Phy. Stock Ver.","../Inventory/PhysicalStockVerification.jsp?command=Default&lots=1","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");

<%
	 }
else
	{
%>
Menu4_9=new Array("Phy. Stock Ver.","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Inventory");
<%}%>

Menu5=new Array("General Ledger","","",5,20,110,"","","","","","",-1,-1,-1,"Center","  Accounting Software - General Ledger");




Menu5_1=new Array("Create >" ,"","",13,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_1=new Array("Add Ledger Group","../Finance/SundryType.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>
Menu5_1_1=new Array("Add Ledger Group","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


Menu5_1_2=new Array("Asset >","","",5,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_2_1=new Array("Fixed Assets","../Finance/Assets.jsp?command=newAsset&message=Default","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>
Menu5_1_2_1=new Array("Fixed Assets","","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_2_2=new Array("Investment","../Finance/Investment.jsp?command=Default&message=Default","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
%>

Menu5_1_2_2=new Array("Investment","","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_2_3=new Array("Current Assets","../Finance/CurrentAsset.jsp?command=Default&message=Default","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>

Menu5_1_2_3=new Array("Current Assets","","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_2_4=new Array("Loan & Advance","../Finance/LoanGiven.jsp?command=Default&message=Default","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>

Menu5_1_2_4=new Array("Loan & Advance","","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_2_5=new Array("Miscellaneous  Exp.","../Finance/MiscExp.jsp?command=Default&message=Default","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
%>

Menu5_1_2_5=new Array("Miscellaneous  Exp.","","",0,20,135,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>



Menu5_1_3=new Array("Liabilities >","","",4,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_3_1=new Array("Capital","../Finance/Capital.jsp?command=Default&message=Default","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>
Menu5_1_3_1=new Array("Capital","","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>


Menu5_1_3_2=new Array("Reserve & Surplus","../Finance/CurrentLiabilities.jsp?command=Expense&message=Default","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
%>
Menu5_1_3_2=new Array("Reserve & Surplus","","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_3_3=new Array("Loan Liabilites","../Finance/Loan.jsp?command=Default&message=Default","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
%>
Menu5_1_3_3=new Array("Loan Liabilites","","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_3_4=new Array("Current Liabilities & Provision","../Finance/CurrentLiabilities.jsp?command=CurrentLiabilities&message=Default","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
%>

Menu5_1_3_4=new Array("Current Liabilities & Provision","","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_4=new Array("Indirect Income","../Finance/Indirect.jsp?command=Income&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
%>
Menu5_1_4=new Array("Indirect Income","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

Menu5_1_5=new Array("Expenses >" ,"","",2,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_5_1=new Array("Direct Expenses","../Finance/SundryType.jsp?command=Sundry&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_1_5_1=new Array("Direct Expenses","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_5_2=new Array("Indirect Expenses","../Finance/Indirect.jsp?command=Expense&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_5_2=new Array("Indirect Expenses","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_6=new Array("Customer/Vendor A/C" ,"../Master/NewParty.jsp?message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_6=new Array("Customer/Vendor A/C" ,"","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_7=new Array("Bank Account","../Master/NewAccount.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_1_7=new Array("Bank Account","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_1_8=new Array("Cash","../Master/NewAccount.jsp?command=Default&message=Default&type=cash","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_8=new Array("Cash","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_9=new Array("Forward Booking","../Finance/ForwardBooking.jsp?command=Add&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_9=new Array("Forward Booking","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>



Menu5_1_10=new Array("Cost Head Group","../Master/NewCostHeadGroup.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_1_10=new Array("Cost Head Group","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_11=new Array("Cost Head  SubGroup","../Master/NewCostHeadSubGroup.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_11=new Array("Cost Head  SubGroup","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_12=new Array("Add Party Group","../Finance/PartyGroupType.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_12=new Array("Add Party Group","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_1_13=new Array("Add PurchaseSale Group","../Finance/PurchaseSaleGroupType.jsp?command=Default&message=Default","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_1_13=new Array("Add PurchaseSale Group","","",0,20,155,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>


Menu5_2=new Array("Journal","../Finance/CommonJournal.jsp?command=Default&message=Default","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_2=new Array("Journal","","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_3=new Array("Set-Off Journal","../Finance/SetOffJournal.jsp?command=Default&message=Default","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>
Menu5_3=new Array("Set-Off Journal","","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

Menu5_4=new Array("Financial Reports >","","",10,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

//Menu5_4_1=new Array("Customer / Vendor //A/C","../Report/PartyReport.jsp?command=Default","",0,20,150,"","",""//,"","","",-1,-1,-1,"","  Accounting Software - General Ledger");


Menu5_4_1=new Array("Customer / Vendor A/C","../Report/PartyReportFast.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

//Menu5_4_3=new Array("Ledger //Book","../Report/LedgerBook1.jsp?command=Default","",0,20,150,"","","//","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_2=new Array("Ledger Book ","../Report/LedgerBookNew.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_3=new Array("Journal Register","../Report/JournalRegister.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_4=new Array("Day Book","../Report/DayBook.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5=new Array("Trial Balance >","","",6,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_5_1=new Array("Detailed("+local_currencysymbol+")","javascript:tb(\"../Report/TrialBalanceFast.jsp?command=Default\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5_2=new Array("Detailed (US$)","javascript:tb(\"../Report/TrailBalanceDollar.jsp?command=Dollar\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5_3=new Array("Condensed("+local_currencysymbol+")","javascript:tb(\"../Report/TrialBalanceFastCondensed.jsp\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5_4=new Array("Condensed(US$)","javascript:tb(\"../Report/TrailBalanceDollarCondensed.jsp?command=Dollar\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5_5=new Array("Group("+local_currencysymbol	+")","javascript:tb(\"../Report/TrialBalanceGroup.jsp\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
Menu5_4_5_6=new Array("Interlinked("+local_currencysymbol	+")","javascript:tb(\"../Report/TrialBalanceFastGroup.jsp\")","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");


Menu5_4_6=new Array("Profit/Loss","../Report/ProfitLossReport.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_7=new Array("Balance Sheet","../Report/BalanceSheet.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_8=new Array("Sheikesho","../Report/Sheikesho.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_9=new Array("Ex-Gain/Loss","../Report/ExGainLoss.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

Menu5_4_10=new Array("Ex-Rate","../Report/ExchangeReport.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");


Menu5_5=new Array("Edit  >","","",11,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_1=new Array("Customer/Vendor A/C" ,"../Master/EditParty.jsp?command=edit&message=masters","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_1=new Array("Customer/Vendor A/C" ,"","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_2=new Array("Bank Account","../Master/EditAccount.jsp?command=edit","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_2=new Array("Bank Account","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_3=new Array("Cash","../Master/EditAccount.jsp?command=edit&type=cash","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_3=new Array("Cash","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_5_4=new Array("Group","../Master/EditGroup.jsp?command=edit&message=masters","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_5_4=new Array("Group","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu5_5_5=new Array("Forward Booking","../Master/EditForwardBooking.jsp?command=edit&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_5=new Array("Forward Booking","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_6=new Array("Cost Head","../Master/EditCostHeadGroup.jsp?command=edit&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>
Menu5_5_6=new Array("Cost Head","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_7=new Array("Cost Head Sub Group","../Master/EditCostHeadSubGroup.jsp?command=edit&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_7=new Array("Cost Head Sub Group","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_8=new Array("Ledger","../Master/EditLedger.jsp?command=edit&message=masters","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_8=new Array("Ledger","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_9=new Array("Ledger Group", "../Master/EditLedgerGroup.jsp?command=edit&message=masters","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_9=new Array("Ledger Group", "","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_10=new Array("Party Group","../Master/EditPartyGroup.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");
<%
	 }
else
	{
	%>

Menu5_5_10=new Array("Party Group","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu5_5_11=new Array("PurchaseSale Group","../Master/EditPurchaseSaleGroup.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%
	 }
else
	{
	%>

Menu5_5_11=new Array("PurchaseSale Group","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - General Ledger");

<%}%>


Menu6=new Array("Money Manager","","",6,20,120,"","","","","","",-1,-1,-1,"center","  Accounting Software - Money Manager");



Menu6_1=new Array("Vouchers >","","",7,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");


<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_1_1=new Array("Contra","../Finance/Contra.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>
Menu6_1_1=new Array("Contra","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_1_2=new Array("Payment","../Finance/Payment.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>

Menu6_1_2=new Array("Payment","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_1_3=new Array("Purchase Payment","../Finance/PurchasePayment1.jsp?command=Default&message=Default&changedate=none","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>


Menu6_1_3=new Array("Purchase Payment","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");


<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_1_4=new Array("FB Import Payment","../Finance/FBImportPayment.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

  Menu6_1_4=new Array("FB Import Payment","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
  <%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_1_5=new Array("Recepit","../Finance/Receipt.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>

Menu6_1_5=new Array("Recepit","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_1_6=new Array("Sales  Receipt","../Finance/SalesReceipt1.jsp?command=Default&message=Default&changedate=none","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>

Menu6_1_6=new Array("Sales  Receipt","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_1_7=new Array("Bank Reconciliation","../Report/BankReconciliation.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>
Menu6_1_7=new Array("Bank Reconciliation","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

Menu6_2=new Array("Promissary Note (PN) >","","",5,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");


<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_2_1=new Array("Receipt","../Finance/PNReceipt.jsp?command=Default&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>
Menu6_2_1=new Array("Receipt","","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>


Menu6_2_2=new Array("Payment","../Finance/PNPayment.jsp?command=Default&message=Default","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>
Menu6_2_2=new Array("Payment","","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>



Menu6_2_3=new Array("PN Settlement >","","",3,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_2_3_1=new Array("Auto Receipt","javascript:tb(\"../Finance/PNAutoSettlementForm.jsp?command=Settlement&type=receipt\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

Menu6_2_3_1=new Array("Auto Receipt","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_2_3_2=new Array("Auto Payment","javascript:tb(\"../Finance/PNAutoSettlementForm.jsp?command=Settlement&type=payment\")","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%
	 }
else
	{
	%>

Menu6_2_3_2=new Array("Auto Payment","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>

Menu6_2_3_3=new Array("Settelment","../Report/PNBook.jsp?command=Settle&message=Default","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

Menu6_2_3_3=new Array("Settelment","","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>


<%
if("0".equals(freeze))
	{
     
	 %>


Menu6_2_4=new Array("Loan(Discounted)","javascript:tb(\"../Finance/PNLoan.jsp?command=Default&message=Default\")","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>
Menu6_2_4=new Array("Loan(Discounted)","","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>



Menu6_2_5=new Array("Report","javascript:tb(\"../Finance/PNReport.jsp?command=Default&message=Default\")","",0,20,200,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");




Menu6_3=new Array("Cash & Bank Books >","","",7,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

Menu6_3_1=new Array("Cash Book","../Report/CashBook.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_2=new Array("Bank Book","../Report/BankBook.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_3=new Array("Cash Book New","../Report/CashBookNew.jsp?command=Cash","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_4=new Array("Bank Book New","../Report/CashBookNew.jsp?command=Bank","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_5=new Array("Reconciliation Report","../Report/BankReconciliationAll.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_6=new Array("PN Book","../Report/PNBookNew.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
Menu6_3_7=new Array("PN Register","../Report/PNBook.jsp?command=Default","",0,20,150,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_4=new Array("Print Voucher","../Report/PrintVouchers.jsp?command=print&message=masters","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

Menu6_4=new Array("Print Voucher","","",0,20,145,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_5=new Array("Edit Voucher","../Master/EditVouchers.jsp?command=edit&message=masters","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

Menu6_5=new Array("Edit Voucher","","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu6_6=new Array("Finance","../Home/Finance.jsp","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");

<%
	 }
else
	{
	%>

Menu6_6=new Array("Finance","","",0,20,110,"","","","","","",-1,-1,-1,"","  Accounting Software - Money Manager");
<%}%>

Menu7=new Array("Administrator","","",5,20,115,"","","","","","",-1,-1,-1,"center","  Accounting Software - Administrator");

Menu7_1=new Array("Update Trial Balance","../Report/NewTrailBalance.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

Menu7_2=new Array("Add >","","",2,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%
if("0".equals(freeze))
	{
     
	 %>

Menu7_2_1=new Array("User","../Master/NewUser.jsp?message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");



<%
	 }
else
	{
	%>

		Menu7_2_1=new Array("User","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
		<%}%>

		<%
if("0".equals(freeze))
	{
     
	 %>
		Menu7_2_2=new Array("Sales Person","../Master/SalesPerson.jsp?command=Default&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>
Menu7_2_2=new Array("Sales Person","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>



Menu7_3=new Array("Edit >","","",5,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
if("0".equals(freeze))
	{
     
	 %>
Menu7_3_1=new Array("Sales Person","../Master/EditSalesPerson.jsp?command=edit&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>

Menu7_3_1=new Array("Sales Person","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>
<%
if("0".equals(freeze))
	{
     
	 %>
 Menu7_3_2=new Array("Exchange Rate","../Master/EditLocalCurrency.jsp?command=update&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>

 Menu7_3_2=new Array("Exchange Rate","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu7_3_3=new Array("Local Currency","../Master/EditLocalCurrency.jsp?command=edit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%
	 }
else
	{
	%>

Menu7_3_3=new Array("Local Currency","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu7_3_4=new Array("Currency","../Master/EditMasters.jsp?command=Currency&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>

Menu7_3_4=new Array("Currency","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>

<%
if("0".equals(freeze))
	{
     
	 %>
Menu7_3_5=new Array("User","../Master/EditUser.jsp?command=edit&message=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%
	 }
else
	{
	%>
Menu7_3_5=new Array("User","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>

     
Menu7_4=new Array("Cancel >","","",5,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
 



<%
if("0".equals(freeze))
	{
%>
Menu7_4_1=new Array("Voucher Cancel","../Master/CancelVouchers.jsp?command=edit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>
Menu7_4_1=new Array("Voucher Cancel","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>



<%
if("0".equals(freeze))
	{%>

Menu7_4_2=new Array("Cgt. In","../Consignment/CancelCgtPurchaseSale.jsp?command=Purchase&message=masters","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
	%>

Menu7_4_2=new Array("Cgt. In","","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%
if("0".equals(freeze))
	{%>
Menu7_4_3=new Array("Cgt. Out","../Consignment/CancelCgtPurchaseSale.jsp?command=Sale&message=masters","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");

<%
	 }
else
	{
	%>

Menu7_4_3=new Array("Cgt. Out","","",0,20,130,"","","","","","",-1,-1,-1,"","  Accounting Software - Consignment");
<%}%>

<%
if("0".equals(freeze))
	{%>

 Menu7_4_4=new Array("Cgt. In Confirm", "../Consignment/CancelCgtInConfirm.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%
	 }
else
	{
	%>
 Menu7_4_4=new Array("Cgt. In Confirm", "","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
 
 <%}%>

<%
if("0".equals(freeze))
	{%>
Menu7_4_5=new Array("Cgt. Out Confirm", "../Consignment/CancelCgtReturnConfirmseprateSale.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%
	 }
else
	{
	%>
Menu7_4_5=new Array("Cgt. Out Confirm", "","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");
<%}%>





<%
if("0".equals(freeze))
	{%>

Menu7_5=new Array("Update Physical Stock","javascript:dd(\"../Report/updatephysicalstock.jsp?command=Default\")","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");







<%
	 }
else
	{
	%>

Menu7_5=new Array("Update Physical Stock Balance","","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - Administrator");

<%}%>










Menu8=new Array("MIS Reports" ,"","",10,20,140,"","","","","","",-1,-1,-1,"center","  Accounting Software - MIS Reports");
Menu8_1=new Array("Customer/Vendor A/C Summary" ,"../Report/PartyOpening.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

/*
Menu8_2=new Array("Acnt MIS Smry" ,"../Report/MisPartyReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
*/

Menu8_2=new Array("Ledger Summary" ,"../Report/OpeningBalance.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

Menu8_3=new Array("Forward Booking" ,"javascript:tb(\"../Report/ForwardBookingReport.jsp?command=Default&message=Defalut\")","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

Menu8_4=new Array("Due Report" ,"../Report/OverDueReport.jsp?command=Default&message=Defalut'","",0,20,140,"","","","","","",-1,-1,-1,"","MIS Reports");

//Menu8_6=new Array("Party Due Report" ,"../Report/PartyAgeing.jsp?command=Default&message=Defalut'","",0,20,140,"","","","","","",-1,-1,-1,"","MIS Reports");

Menu8_5=new Array("Cancelled Vouchers" ,"../Report/CancelledVouchers.jsp?command=edit&message=masters","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

/*
Menu8_8=new Array("Difference A/C >" ,"","",2,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
Menu8_8_1=new Array("Purchase" ,"../Inventory/InvReport.jsp?command=PurchaseReport&message=Default&hcommand=Difference&summary=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
Menu8_8_2=new Array("Sale" ,"../Inventory/InvReport.jsp?command=SaleReport&message=Default&hcommand=Difference&summary=no","",0,20,100,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
*/


Menu8_6=new Array("Cost Center" ,"../Report/CostCenterReportNew.jsp?command=Default&message=Defalut","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");



Menu8_7=new Array("Special Reports >","","",10,25,100,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");


Menu8_7_1=new Array("Cgt. Summary" ,"../Report/MisCgtSummary.jsp?command=Default&message=Defalut","",0,20,160,"","","","","","",-1,-1,-1,"","Accounting Software - MIS Reports");
Menu8_7_2=new Array("Cust./Vendor A/C Mingle" ,"../Report/Accountmingle.jsp?command=Default&message=Defalut","",0,20,160,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
Menu8_7_3=new Array("Lot Sale Summary" ,"../Report/MisLotSummary.jsp?command=Default&message=Defalut","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_4=new Array("Seiksho Summary" ,"../Report/MisSeikshoSummary.jsp?command=Default&message=Defalut","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_5=new Array("Summary Books" ,"../Report/MisSummaryBooks.jsp?command=Default&message=Defalut","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_6=new Array("MIS Party Over Limit" ,"../Report/PartyOverLimitReport.jsp?command=Default","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_7=new Array("Pending Cgt. Report" ,"../Report/PendingCgtReport.jsp?command=Default","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_8=new Array("Warehouse Report" ,"../Report/WarehouseReport.jsp?command=Default","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_9=new Array("Warehouse Pending" ,"../Report/WarehousePendingReport.jsp?command=Default","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");
Menu8_7_10=new Array("MIS PN Report" ,"../Report/PNReportNew.jsp?command=Default","",0,20,160,"","","","","","",-1,-1,-1,""," Accounting Software - MIS Reports");


Menu8_8=new Array("Party Group Report" ,"../Report/PartyGroupOpening.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

//Menu8_9=new Array("Cust. Vendor Detail" ,"../Report/CustomerVendorDetailReport.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");
Menu8_9=new Array("Cust. Vendor Detail(New)" ,"../Report/CustomerVendorDetailReportFast.jsp?command=Default","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

Menu8_10=new Array("Cust./Party List" ,"javascript:tb(\"../Report/PartyList.jsp?command=Default\")","",0,20,140,"","","","","","",-1,-1,-1,"","  Accounting Software - MIS Reports");

Menu9=new Array("YearEnd","","",3,25,100,"","","","","","",-1,-1,-1,"center","  Accounting Software - YearEnd");
<%
boolean yearEndStep1=true; 
int int_yearend_id=Integer.parseInt(yearend_id);
if(newyearend_id > int_yearend_id)
	{
	yearEndStep1=false; 
	}

if(yearEndStep1)
	{
%>
	Menu9_1=new Array("Year End Step 1","../YearEnd/YearEnd.jsp?command=Default&message=Defalut","",0,20,150,"","","","","","",-1,-1,-1,"","Step 1 - Year End");
<%
	}
else
	{
%>
	Menu9_1=new Array("Step 1 Done","","",0,20,150,"","","","","","",-1,-1,-1,"","Step 1 - Year End");
<%	} 

if("0".equals(freeze))
	{
%>

Menu9_2=new Array("Closing Stock Edit 2","../Master/EditClosingStock.jsp?command=edit&message=Default","",0,20,150,"","","","","","",-1,-1,-1,"","Step 2 - Year End");

	Menu9_3=new Array("Year End Step 3","../YearEnd/YearEndLedger.jsp?command=Default&message=Defalut","",0,20,150,"","","","","","",-1,-1,-1,"","Step 3 - Year End");

	<%
	}
else
	{
%>
	Menu9_2=new Array("Step2 Done","","",0,20,150,"","","","","","",-1,-1,-1,"","Step 2 - Year End");

	Menu9_3=new Array("Step 3 Done","","",0,20,150,"","","","","","",-1,-1,-1,"","Step 3 - Year End");

	<%	} %>

</script>
	<script type='text/javascript' src='menu13_compact.js'></script>
<noscript>Your browser does not support script</noscript>
<!-- <IFRAME NAME="right" SRC="right.html" WIDTH="100%" HEIGHT="100%" border=2 frameborder=2>
	</IFRAME> 
 -->
</body>
</html>

<%

}

}
catch(Exception Samyak188){ 
out.println("<font color=red> FileName : Homepage.jsp <br>Bug No Samyak188 <br>Please Contact Super Admin <br> Error : Local Currency Undefined   <br> or "+ Samyak188 +"</font>");}
%>




