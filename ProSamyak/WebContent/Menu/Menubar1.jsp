<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="Lo" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

<%
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
//out.print("<br>user_id"+user_id);

//String company_id= ""+session.getValue("company_id");
//out.print("<br>company_id"+company_id);

String today_string= format.format(D);

try
{

Connection conp = null;    //connection for first level
Connection cong = null;	   //connection for second level

conp =ConnectDB.getConnection();
cong =ConnectDB.getConnection();

PreparedStatement pstmt_p = null;
PreparedStatement pstmt_g = null;

ResultSet rs_g = null;
ResultSet rs_p = null;
%>
<%

int i =0;
 int EntityID = Integer.parseInt(request.getParameter("EntityId"));
 int UserID = Integer.parseInt(request.getParameter("UserID"));

//find the counter

String sql1 = "select count(*) as counter from UserAuthority where UserID="+UserID+" and Active=1";
int counter=0;
	pstmt_p = conp.prepareStatement(sql1);
	rs_p = pstmt_p.executeQuery();
while(rs_p.next())
{
	counter = rs_p.getInt("counter") ;
}
pstmt_p.close();

int MId[]=new int[counter];
int P_id[]=new int[counter];
int No_c[]=new int[counter];
String link[]=new String[counter];
String MName[]=new String[counter];
String Menu_No[]=new String[counter];

 sql1 = "select MId, Menu_No, Child_Count from UserAuthority where UserID="+UserID+" and Active=1";
	pstmt_p = conp.prepareStatement(sql1);
	rs_p = pstmt_p.executeQuery();
 i=0;
while(rs_p.next())
{

MId[i] = rs_p.getInt("MId") ;
Menu_No[i] = rs_p.getString("Menu_No") ;
No_c[i] = rs_p.getInt("Child_Count") ;
i++;
}
pstmt_p.close();

int ParentsCounter=0;
for(i=0; i< counter; i++)
{
 sql1 = "select MName, ParentID, Link from MenuMaster where MId="+MId[i]+" and Active=1";

	pstmt_p= conp.prepareStatement(sql1);
	rs_p = pstmt_p.executeQuery();

while(rs_p.next())
{

MName[i] = rs_p.getString("MName") ;
//out.print("<br>MName[i]="+MName[i]);
P_id[i] = rs_p.getInt("ParentID") ;
//out.print("<br>84 P_id[i] "+P_id[i] );
if(-1==P_id[i])
	{
	ParentsCounter++;
	}
//No_c[i] = rs_p.getInt("No_Child") ;
link[i] = rs_p.getString("Link") ;
if(rs_p.wasNull())
	{link[i]="-";}
}
pstmt_p.close();

}//for

	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
String JS="";

	// Menu tree:
// MenuX=new Array("ItemText","Link","background image",number of sub elements,height,width,"bgcolor","bghighcolor",
//	"fontcolor","fonthighcolor","bordercolor","fontfamily",fontsize,fontbold,fontitalic,"textalign","statustext");
// Color and font variables defined in the menu tree take precedence over the global variables
// Fontsize, fontbold and fontitalic are ignored when set to -1.
// For rollover images ItemText or background image format is:  "rollover?"+BaseHref+"Image1.jpg?"+BaseHref+"Image2.jpg" 


		int m=1;
		String Menu="";
		i=0;
		int mid[]=new int[10];
		String cuurr_date=today_string;
	
while(i< counter)
{
	int h=0;
String org=link[i];
String search="cuurr_date";
String sub=today_string;
h=org.indexOf(search);
StringBuffer sb=new StringBuffer(link[i]);
String result="";
if(h> 0)
	{
sb.replace(h,(h+10), sub);
	}
//link[i]=sb;
/*int h=1;
do{

if(h != -1)
	{
	result=org.substring(0, h);
	result = result + sub;
	result = result + org.substring(h + search.length());
	org=result;
	}
}while(h !=1);*/
link[i]=result;

	 Menu = Menu_No[i]+" = new Array(\""+MName[i]+"\",  \""+sb+"\",\"\", "+No_c[i]+", 20, 100, \"\", \"\", \"\", \"\", \"\", \"\", -1,-1,-1,\"\", \"design\" );  ";
	JS = JS + Menu;
	
	i++;
	}//first if

	
	




out.print("JS:--> "+JS);
//JS = "<sript language = \"javascript\">" + JS + "</script>";

//String JSVariable= "var NoOffFirstLineMenus=5;"; 
//JSVariable =JSVariable + "var LowBgColor=\"#BB0000\"; var HighBgColor=\"#FF6600\"; var FontLowColor=\"#ffffff\"; var	FontHighColor=\"#ffffff\";var BorderColor=\"#ffffff\";var BorderWidthMain=1;var BorderWidthSub=1;var BorderBtwnMain=1; var BorderBtwnSub=1; var FontFamily=\"comic sans ms,technical,arial\"; var FontSize=12; var FontBold=0;var FontItalic=0; var MenuTextCentered=\"center\"; var MenuCentered=\"left\";var MenuVerticalCentered=\"center\"; var ChildOverlap=.2; var ChildVerticalOverlap=.2; var StartTop=0;var StartLeft=0; var VerCorrect=0; var HorCorrect=0; var DistFrmFrameBrdr=0;	var LeftPaddng=3; var TopPaddng=-1; var FirstLineHorizontal=1; var MenuFramesVertical=0;	var DissapearDelay=1000; var UnfoldDelay=100; var TakeOverBgColor=1; var FirstLineFrame=\"navig\";	var SecLineFrame=\"right\"; var DocTargetFrame=\"right\"; var TargetLoc=\"MenuPos\"; var MenuWrap=1; var RightToLeft=0; var BottomUp=0; var UnfoldsOnClick=0; var BaseHref=\"\";" ;	


//JSVariable = JSVariable +"var Arrws=[BaseHref+\"tri.gif\",5,10,BaseHref+\"tridown.gif\",10,5,BaseHref+\"trileft.gif\",5,10,BaseHref+\"triup.gif\",10,5];var MenuUsesFrames=1;var RememberStatus=0;	var BuildOnDemand=0;var BgImgLeftOffset=5;var ScaleMenu=0;var HooverBold=0;var HooverItalic=0;var HooverUnderLine=0;var HooverTextSize=0;var HooverVariant=0;var MenuSlide=\"\";var MenuSlide=\"progid:DXImageTransform.Microsoft.RevealTrans(duration=.5, transition=19)\";var MenuSlide=\"progid:DXImageTransform.Microsoft.GradientWipe(duration=.5, wipeStyle=1)\";var MenuShadow=\"\";var MenuShadow=\"progid:DXImageTransform.Microsoft.DropShadow(color=#888888, offX=0, offY=0, positive=0)\";var MenuShadow=\"progid:DXImageTransform.Microsoft.Shadow(color=#888888, direction=135, strength=0)\";var MenuOpacity=\"\";var MenuOpacity=\"progid:DXImageTransform.Microsoft.Alpha(opacity=100)\";function BeforeStart(){return}function AfterBuild(){return}function BeforeFirstOpen(){return}function AfterCloseAll(){return}";

//JS = JSVariable +JS;
//out.print("<BR><BR><br>JS...."+JS);
%>
<html>
<head></head>
<body style="margin:0px">

	<script type='text/javascript'>function Go(){return}</script>
 <script language="JavaScript">
var cuurr_date='<%=today_string%>';
var company_code='3';

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

<%=JS%>
</script>

	<script type='text/javascript'>function Go(){return}</script>
	<script>
		
	var cuurr_date='<%=today_string%>';

	 </script>
	
<script type='text/javascript' src='../Home/menu13_compact.js'></script>
<noscript>Your browser does not support script</noscript>


</body>
</html>


</body>
</html>






<%

}
catch(Exception e)
{
	//ConnectDB.returnConnection(con1);
	//ConnectDB.returnConnection(con2);
	//ConnectDB.returnConnection(con3);
	out.println(e);
}
%>