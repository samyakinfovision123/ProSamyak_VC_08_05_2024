<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="C"   class="NipponBean.Connect" />
<jsp:useBean id="F" class="NipponBean.format" />

 <%Connection cong = null;
try{
	String user_id= ""+session.getValue("user_id");
	//out.print("userid->"+user_id)
	String user_level= ""+session.getValue("user_level");
	String company_id= ""+session.getValue("company_id");
    //out.print("<br>company_id"+company_id);
	String machine_name=request.getRemoteHost();
	//out.print("<br> 10  user_id="+user_id+"user_level="+user_level+"machine_name="+machine_name);
	//java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	 

 
	 PreparedStatement pstmt_g=null;
	 ResultSet rs_g = null;	

	 cong=C.getConnection();

	 java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	
	 //int goldCount=0;
	 /*String	query="select GoldRate_Id from Master_GoldRate where GoldRate_Date=?";
	
	 pstmt_g=cong.prepareStatement(query);
	 pstmt_g.setString(1,""+D);
	 
	 rs_g=pstmt_g.executeQuery();
	 while(rs_g.next())
	 goldCount++;
	 pstmt_g.close();
	//out.print("<br>goldCount"+goldCount);
 	C.returnConnection(cong);*/

	/*if(goldCount == 0)
	 {
	  response.sendRedirect("GoldRate.jsp?command=Default");
	 }*/
	

 %>
<html>
<head>
	<link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css">
</head>

<body Bgcolor=#CCCCFF>



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
</SCRIPT>

 
<body style="margin:0px"   link=white Alink=white vlink=white  onLoad="startclock()" link=white Alink=white vlink=white bgcolor=#00308F>
<form name="homepage" >
<input type=hidden name='companyId' value=<%=company_id%>>
<table width='100%' height=100% bordercolor=#33FF00 border=0 bgcolor=#00308F>
<!-- <table border=0 cellspacing=0 cellpadding=0 width='100%'> 
style= "background:URL('../top_apple.jpg' ); width=100%'"
-->
<tr>
	<td HEIGHT="2" class=white>
<b>Date:<%=F.format(D)%></b>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<b>Time:</b><INPUT TYPE="text" NAME="face" SIZE=10 VALUE ="....Initializing...." readonly	class="iprdonly1">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;


User:&nbsp;<%=A.getNameCondition(cong,"Master_User","User_Name","where User_Id="+user_id)%></b>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%=A.getNameCondition(cong,"Master_CompanyParty","CompanyParty_Name","where CompanyParty_Id="+company_id)%>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

	
  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<a href='right.html' target='right'>Clear Screen</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;


<a href='../Design/SparklerSession.jsp' target='_parent'>Logout</a></td>
		

</tr>
<tr><td><IMG SRC="../top_sparkler.jpg" WIDTH="100%" HEIGHT="100" BORDER=0 ALT=""> </td></tr>

</table>	
	<script type='text/javascript'>function Go(){return}</script>
<!-- 	<script type='text/javascript' src='HorizontalFrames_var.js'> </script>
 -->	
 <script language="JavaScript">
  /***********************************************
*	(c) Ger Versluis 2000 version 13.00 27 June 2004          *
*	You may use this script on non commercial sites.	          *
*	www.burmees.nl/menu			          *
*	You may remove all comments for faster loading	          *		
************************************************/
var cuurr_date=new Date();
var NoOffFirstLineMenus=1;			// Number of main menu  items
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
	var FontFamily="Courier new,Verdana, comic sans ms,technical,arial";	// Font family menu items
	var FontSize=12;				// Font size menu items
	var FontBold=0;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered="center";		// Item text position left, center or right
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


// Menu tree:
// MenuX=new Array("ItemText","Link","background image",number of sub elements,height,width,"bgcolor","bghighcolor",
//	"fontcolor","fonthighcolor","bordercolor","fontfamily",fontsize,fontbold,fontitalic,"textalign","statustext");
// Color and font variables defined in the menu tree take precedence over the global variables
// Fontsize, fontbold and fontitalic are ignored when set to -1.
// For rollover images ItemText or background image format is:  "rollover?"+BaseHref+"Image1.jpg?"+BaseHref+"Image2.jpg" 

	
	var companyId="";
	companyId= document.homepage.companyId.value;
	
	
Menu1=new Array("Create","","",6,20,120,"","","","","","",14,1,-1,"left","");
	


Menu1_1=new Array("Company",'../Master/NewCompany.jsp?message=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");


/*Menu1_2=new Array("ShowRoom",'../Master/NewShowRoom.jsp?condition=allow&command=Default&message=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");


//Menu1_3=new Array("Outlet","","",1,20,120,"","","","","","",-1,1,-1,"left","");

Menu1_3=new Array("Outlet Detail",'../Master/OutletDetails.jsp?condition=allow&command=Default&message=Default',"",0,20,120,"","","","",""," ",-1,1,-1,"left","");*/


Menu1_2=new Array("User",'../Master/addUser.jsp?command=Default&message=Default&condition=allow',"",0,20,120,"","","","","","",-1,1,-1,"left","");

Menu1_3=new Array("Edit","","",2,20,120,"","","","",""," ",-1,1,-1,"left","");

Menu1_3_1=new Array("Company",'../Master/EditCompany.jsp?command=edit&message=masters',"",0,20,120,"","","","","","",-1,1,-1,"left","");
/*Menu1_5_2=new Array("ShowRoom",'../Master/EditShowroom.jsp?command=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");
Menu1_5_3=new Array("Outlet",'../Master/EditOutletDetails.jsp?command=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");*/

Menu1_3_2=new Array("User",'../Master/EditUser.jsp?command=edit&message=Default&condition=allow',"",0,20,120,"","","","","","",-1,1,-1,"left","");

//Menu1_6=new Array("Company",'../Master/NewCompany.jsp?message=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");

Menu1_4=new Array("Menu Admin",'../Menu/Admin.jsp?command=default',"",0,20,120,"","","","","","",-1,1,-1,"left","");

/*Menu1_5=new Array("User Access",'../Menu/UserAcccessLevels.jsp?command=default',"",0,20,120,"","","","","","",-1,1,-1,"left","");


 //Menu1_6=new Array("User Login",'../Menu/Login.jsp?command=default',"",0,20,120,"","","","","","",-1,1,-1,"left","");*/


 Menu1_5=new Array("Edit Menu ",'../Menu/EditAdmin.jsp?command=default',"",0,20,120,"","","","","","",-1,1,-1,"left","");



//Menu1_10=new Array("Report >>","","",1,20,120,"","","","",""," ",-1,1,-1,"left","");

//Menu1_10_1=new Array("Item Report",'../FG/AdminItemReport.jsp?command=Default',"",0,20,120,"","","","","","",-1,1,-1,"left","");
//Menu1_11_3=new Array("Outlet ",'../Master/CancelOutlet.jsp?command=Default&message=Default&condition=allow',"",0,20,120,"","","","","","",-1,1,-1,"left","");


Menu1_6=new Array("Access Edit",'../Menu/UserAcccessLevels1.jsp?command=default',"",0,20,120,"","","","",""," ",-1,1,-1,"left","");
  </script>
 
<script type='text/javascript' src='menu13_compact.js'></script>
<noscript>Your browser does not support script</noscript>

</form>
</body>
</html>

<%	
 //end else i.e. Gold rate is inserted
C.returnConnection(cong);
}catch(Exception Dove89){ 
	C.returnConnection(cong);

out.println("<font color=red> FileName : indexIspat.jsp <br>Bug No Dove89 :"+ Dove89 +"</font>");}

 
%>
