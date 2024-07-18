<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="S" class="NipponBean.str" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="YED" class="NipponBean.YearEndDate" />

<%
String user_id= ""+session.getValue("user_id");
//out.print("<br> User_Id"+user_id);
String user_level= ""+session.getValue("user_level");
//out.print("<br> user_level"+user_level);
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String category_code= ""+session.getValue("category_code");
String user_name= ""+session.getValue("user_name");
//out.print("<br> Company_id"+company_id);
int int_companyid=Integer.parseInt(company_id);
//System.out.print("<br>user_id"+user_id);
//out.print("<br>user_id="+user_id);
//out.print("<br>company_id="+company_id);
String errLine="15";
Connection cong = null;
Connection conp = null;
try{
	 PreparedStatement pstmt_g=null;
	 PreparedStatement pstmt_p=null;
	ResultSet rs_g = null;		
	ResultSet rs_p = null;	
 try{
	cong=C.getConnection();
	}catch(Exception e11){ 
	out.println("<font color=red> FileName : IndexIspat.jsp <br>Bug No e32 :"+ e11 +"</font>");}

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);
int newyearend_id=0;
String local_currencysymbol="";
String today_exrate="";
String loc_currency="";
String company_name = "";
String financial_year="";
String newlocation_id="";
int d=0;
if (int_companyid > 0)
{
conp=C.getConnection();
String Category_Code = A.getNameCondition(conp,"Master_CompanyParty", "Category_Code", " Where companyparty_id="+company_id);
//out.print("<br> Category Code "+Category_Code);	
company_name = A.getNameCondition(conp,"Master_CompanyParty", "CompanyParty_Name", " Where companyparty_id="+company_id);

local_currencysymbol= I.getLocalSymbol(conp,company_id);
String local_currencyid=I.getLocalCurrency(conp,company_id);
//out.print("<br>54 local_currencyid="+local_currencyid);
loc_currency=A.getNameCondition(conp,"Master_Currency","Currency_Name","where Currency_Id="+local_currencyid+"");
//System.out.println("56 loc_currency=="+loc_currency);

int currency_id=Integer.parseInt(local_currencyid);

//out.println("local_currencyid"+local_currencyid);
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

	java.sql.Date startDate = YED.getDate(conp, "YearEnd", "From_Date", " Where yearend_id="+newyearend_id);
	java.sql.Date endDate = YED.getDate(conp, "YearEnd", "To_Date", " Where yearend_id="+newyearend_id);

	financial_year = format.format(startDate) + " To " + format.format(endDate);

	if (i>0)
	{	
		d=	Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",""+currency_id));
	}
	else
	{
		C.returnConnection(conp);
		C.returnConnection(cong);
		response.sendRedirect("TodayExchangeRate.jsp?command=Default&message=Default");
	}
	
	C.returnConnection(conp);
}//if 





int i =0;

String sql1 = "select count(*) as counter from UserAuthority where UserID="+user_id+" and Active=1";
//System.out.print("<br>sql1"+sql1);



int counter=0;
	pstmt_g = cong.prepareStatement(sql1);
	
	rs_g = pstmt_g.executeQuery();
while(rs_g.next())
{
	counter = rs_g.getInt("counter") ;
}
//System.out.print("<br>counter "+counter );
pstmt_g.close();

int MId[]=new int[counter];
int P_id[]=new int[counter];
int No_c[]=new int[counter];
String link[]=new String[counter];
String MName[]=new String[counter];
String Menu_No[]=new String[counter];
String Menu_Width[]=new String[counter];

 sql1 = "select MId, Menu_No, Child_Count from UserAuthority where UserID="+user_id+" and Active=1";
//System.out.println("<br>UserAuthority"+sql1);
	pstmt_g = cong.prepareStatement(sql1);
	rs_g= pstmt_g.executeQuery();
	//System.out.println("sql1->"+sql1);
 i=0;
while(rs_g.next())
{

MId[i] = rs_g.getInt("MId") ;
Menu_No[i] = rs_g.getString("Menu_No") ;
No_c[i] = rs_g.getInt("Child_Count") ;
i++;
}
pstmt_g.close();

int ParentsCounter=0;

//System.out.println("<br> No_c[i]: "+No_c.length);	
//out.println("<br> No_c[i]: "+No_c.length);	


for(i=0; i< counter; i++)
{
 sql1 = "select MName, ParentID, Menu_Width, Link from MenuMaster where MId="+MId[i]+" and Active=1";
//System.out.println("<br>MenuMaster"+sql1);
	pstmt_g= cong.prepareStatement(sql1);
	rs_g = pstmt_g.executeQuery();
//System.out.println("<br> Before while 1111111111111111 ");	
while(rs_g.next())
{

MName[i] = rs_g.getString("MName") ;
//System.out.print("<br>MName[i]="+MName[i]);
P_id[i] = rs_g.getInt("ParentID") ;
//System.out.print("<br>84 P_id[i] "+P_id[i] );
if(-1==P_id[i])
	{
	ParentsCounter++;
	}
//No_c[i] = rs_p.getInt("No_Child") ;
Menu_Width[i] = rs_g.getString("Menu_Width") ;
link[i] = rs_g.getString("Link") ;
if(rs_g.wasNull())
	{link[i]="-";}
//out.print("<br>128 link["+i+"]"+link[i]);
}
pstmt_g.close();
if(link[i]==null)
	{link[i]="-";}
}//for


String JS="";
		int m=1;
		String Menu="";
		i=0;
		//int mid[]=new int[10];
	String cuurr_date=today_string;

//System.out.println("<br>Before while 2222222222222222222222 ");	

//out.print("<br>counter="+counter);

while(i< counter)
{
	
errLine="148";
int h=0;
errLine="150";
String org=link[i];
errLine="152";
String search="cuurr_date";
errLine="154";
String sub=today_string;
errLine="156";
//out.print("<br>Link["+i+"] = "+link[i]);
h=org.indexOf(search);
int h2 = org.indexOf(search, (h+1));
int h3 = org.indexOf("today_exrate");
errLine="158";
StringBuffer sb=new StringBuffer(link[i]);
errLine="160";
String result="";

//System.out.println("<br>inside while Before if ");	
//out.print("<br>Menu_No:"+Menu_No[i]);
//out.print("<br>MName:"+MName[i]);
//out.print("<br>sb:"+sb);
//out.print("<br>No_c:"+No_c[i]);
//out.print("<br>Menu_Width:"+Menu_Width[i]);
if(h> 0)
	{
sb.replace(h,(h+10), sub);
	}
if(h2> 0)
	{
sb.replace(h2,(h2+10), sub);
	}
if(h3> 0)
	{
sb.replace(h3,(h3+12), today_exrate);
	}

	 Menu = Menu_No[i]+" = new Array(\""+MName[i]+"\",  \""+sb+"\",\"\", "+No_c[i]+", 20, "+Menu_Width[i]+", \"\", \"\", \"\", \"\", \"\", \"\", -1,-1,-1,\"\", \"design\" );  ";
	JS = JS + Menu;
	//out.print("<br>JS="+JS);
	i++;
	}//first if
//System.out.print("<br>JS="+JS);
 %>
<html>
<head>
	<link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css">
<link href="../Samyak/tablecss.css" rel="stylesheet" type="text/css">
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
    document.homepage.face.value = timeValue 
    timerID = setTimeout("showtime()",1000)
    timerRunning = true
}


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
</SCRIPT>

 </head>

<body style="margin:0px"   link=white Alink=white vlink=white  onLoad="startclock()" link=white Alink=white vlink=white bgcolor=#00308F>
<form name="homepage" >
<input type=hidden name='companyId' value=<%=company_id%>>

<table width='100%' height=100% bordercolor=#33FF00 border=0 bgcolor=#00308F>
<tr valign=top>
<td HEIGHT="2" class=white>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<b>Date:<%=format.format(D)%></b>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<b>Time:</b><INPUT TYPE="text" NAME="face" SIZE=10 VALUE ="....Initializing...." readonly	class="iprdonly1">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	User:&nbsp;<%=A.getNameCondition(cong,"Master_User","User_Name","where User_Id="+user_id)%></b>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Company:&nbsp;<%=company_name%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href='right.jsp' target='right'>Clear Screen</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href='../Design/SparklerSession.jsp' target='_parent'>Logout</a>
</td>
</tr>
<%
if("3".equals(category_code))
	{

	}
	else {
	%>
<tr><td><IMG SRC="../top_sparkler.jpg" WIDTH="100%" HEIGHT="100" BORDER=0 ALT=""> </td>
</tr> 
<%}%>
</table>

	<script type='text/javascript'>function Go(){return}</script>
 <script language="JavaScript">
var cuurr_date='<%=today_string%>';

var NoOffFirstLineMenus=<%=ParentsCounter%>;			// Number of main menu  items
						// Colorvariables:
						// Color variables take HTML predefined color names or "#rrggbb" strings
						//For transparency make colors and border color ""
	var LowBgColor="#00308F";			
	var HighBgColor="white";			
	var FontLowColor="white";			
	var FontHighColor="#00308F";		
	var BorderColor="#6666FF";			

	var BorderWidthMain=1;			// Border width main items
	var BorderWidthSub=1;			// Border width sub items
 	var BorderBtwnMain=1;			// Border width between elements main items
	var BorderBtwnSub=1;			// Border width between elements sub items
	var FontFamily="Verdana, comic sans ms,technical,arial";	// Font family menu items
	var FontSize=12;				// Font size menu items
	var FontBold=0;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered="left";		// Item text position left, center or right
	var MenuCentered="left";			// Menu horizontal position can be: left, center, right
	var MenuVerticalCentered="top";		// Menu vertical position top, middle,bottom or static
	var ChildOverlap=.2;			// horizontal overlap child/ parent
	var ChildVerticalOverlap=.2;			// vertical overlap child/ parent
	var StartTop=0;				// Menu offset x coordinate
	var StartLeft=0;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var DistFrmFrameBrdr=0;			// Distance between main menu and frame border
	var LeftPaddng=3;				// Left padding
	var TopPaddng=-1;				// Top padding. If set to -1 text is vertically centered
	var FirstLineHorizontal=1;			// Number defines to which level the menu must unfold horizontal; 0 is all vertical
	var MenuFramesVertical=0;			// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;			// delay before menu folds in
	var UnfoldDelay=100;			// delay before sub unfolds	
	var TakeOverBgColor=2;			// Menu frame takes over background color subitem frame
	var FirstLineFrame="navig";			// Frame where first level appears
	var SecLineFrame="right";			// Frame where sub levels appear
	var DocTargetFrame="right";		// Frame where target documents appear
	var TargetLoc="MenuPos";				// span id for relative positioning
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var BottomUp=0;				// enables/ disables Bottom up unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var BaseHref="";				// BaseHref lets you specify the root directory for relative links. 
						// The script precedes your relative links with BaseHref
						// For instance: 
						// when your BaseHref= "http://www.MyDomain/" and a link in the menu is "subdir/MyFile.htm",
						// the script renders to: "http://www.MyDomain/subdir/MyFile.htm"
						// Can also be used when you use images in the textfields of the menu
						// "MenuX=new Array("<img src=\""+BaseHref+"MyImage\">"
						// For testing on your harddisk use syntax like: BaseHref="file:///C|/MyFiles/Homepage/"

	var Arrws=[BaseHref+"tri.gif",5,10,BaseHref+"tridown.gif",10,5,BaseHref+"trileft.gif",5,10,BaseHref+"triup.gif",10,5];

						// Arrow source, width and height.
						// If arrow images are not needed keep source ""

	var MenuUsesFrames=1;			// MenuUsesFrames is only 0 when Main menu, submenus,
						// document targets and script are in the same frame.
						// In all other cases it must be 1

	var RememberStatus=0;			// RememberStatus: When set to 1, menu unfolds to the presetted menu item. 
						// When set to 2 only the relevant main item stays highligthed
						// The preset is done by setting a variable in the head section of the target document.
						// <head>
						//	<script type="text/javascript">var SetMenu="2_2_1"; 
						// </head>
						// 2_2_1 represents the menu item Menu2_2_1=new Array(.......

						// Below some pretty useless effects, since only IE6+ supports them
						// I provided 3 effects: MenuSlide, MenuShadow and MenuOpacity
						// If you don't need MenuSlide just leave in the line var MenuSlide="";
						// delete the other MenuSlide statements
						// In general leave the MenuSlide you need in and delete the others.
						// Above is also valid for MenuShadow and MenuOpacity
						// You can also use other effects by specifying another filter for MenuShadow and MenuOpacity.
						// You can add more filters by concanating the strings
	var BuildOnDemand=0;			// 1/0 When  'set to 1 the sub menus are build when the parent is moused over
	var BgImgLeftOffset=5;			// Only relevant when bg image is used as rollover
	var ScaleMenu=0;				// 1/0 When set to 0 Menu scales with browser text size setting

	var HooverBold=0;				// 1 or 0
	var HooverItalic=0;				// 1 or 0
	var HooverUnderLine=0;			// 1 or 0
	var HooverTextSize=0;			// 0=off, number is font size difference on hoover
	var HooverVariant=0;			// 1 or 0

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

function tb(str)
{
	//alert("ok");
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=700", "Resizable=yes","Scrollbars=yes","status=no"])
}
	
<%=JS%>
</script>
 
<script type='text/javascript' src='menu13_compact.js'></script>
<noscript>Your browser does not support script</noscript>


</body>
</html>

<%	
	C.returnConnection(cong);

	 
}catch(Exception Dove89){ 
	C.returnConnection(cong);

out.println("<font color=red> FileName : Homepage.jsp <br>Bug No Dove89 :"+ Dove89 +" after line : "+errLine+"</font>");}

 
%>
