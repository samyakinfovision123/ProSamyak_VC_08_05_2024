 /***********************************************
*	(c) Ger Versluis 2000 version 13.00 27 June 2004          *
*	You may use this script on non commercial sites.	          *
*	www.burmees.nl/menu			          *
*	You may remove all comments for faster loading	          *		
************************************************/
var cuurr_date=new Date();


		

	var NoOffFirstLineMenus=10;			// Number of main menu  items
						// Colorvariables:
						// Color variables take HTML predefined color names or "#rrggbb" strings
						//For transparency make colors and border color ""
	var LowBgColor="#000033";			// Background color when mouse is not over
	var HighBgColor="#ffffff";			// Background color when mouse is over
	var FontLowColor="#ffffff";			// Font color when mouse is not over
	var FontHighColor="#000033";			// Font color when mouse is over
	var BorderColor="#ffffff";			// Border color
	var BorderWidthMain=1;			// Border width main items
	var BorderWidthSub=1;			// Border width sub items
 	var BorderBtwnMain=1;			// Border width between elements main items
	var BorderBtwnSub=1;			// Border width between elements sub items
	var FontFamily="comic sans ms,technical,arial";	// Font family menu items
	var FontSize=12;				// Font size menu items
	var FontBold=0;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered="center";		// Item text position left, center or right
	var MenuCentered="left";			// Menu horizontal position can be: left, center, right
	var MenuVerticalCentered="center";		// Menu vertical position top, middle,bottom or static
	var ChilSamyakrlap=.2;			// horizontal overlap child/ parent
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
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
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
						//	<script type="text/javascript">var SetMenu="2_2_1";</script>
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
	var BuildOnDemand=0;			// 1/0 When set to 1 the sub menus are build when the parent is moused over
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

	function d(str)
{
window.open(str,"_blank", ["Top=50","Left=170","Toolbar=no", "Location=0","Menubar=no","Height=700","Width=700", "Resizable=no","Scrollbars=no","status=no"])
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

Menu1=new Array("Purchase","","",5,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_1=new Array("Local",'../Inventory/InvReceive.jsp?command=Default&lots=1&message=Default&purchase=Local&pieces=no&ledgers=0&receive_id=Samyak&invoicedate="+cuurr_date+"',"",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_2=new Array("Import","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_3=new Array("Return","","",3,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_3_1=new Array("Purchase","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_3_2=new Array("Local","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_3_3=new Array("Import","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");

	Menu1_4=new Array("Reports","","",5,20,100,"","","","","","",-1,-1,-1,"","Purchase");

	Menu1_4_1=new Array("Book","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_4_2=new Array("Book Detailed","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_4_3=new Array("Register","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_4_4=new Array("Payment","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_4_5=new Array("Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_5=new Array("Edit","","",2,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_5_1=new Array("Purchase","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu1_5_2=new Array("Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Purchase");

Menu2=new Array("sale","","",5,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_1=new Array("Local","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_2=new Array("Export","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_3=new Array("Return","","",3,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_3_1=new Array("sale","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_3_2=new Array("Local","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_3_3=new Array("Export","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4=new Array("Reports","","",6,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_1=new Array("Book","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_2=new Array("Book Detailed","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_3=new Array("Register","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_4=new Array("Receipt","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_5=new Array("Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_4_6=new Array("Person","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_5=new Array("Edit","","",2,20,100,"","","","","","",-1,-1,-1,"","Purchase");
	Menu2_5_1=new Array("sale","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");
	Menu2_5_2=new Array("Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","sale");

Menu3=new Array("Consignment","","",6,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_1=new Array("Purchase","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_2=new Array("Sale","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_3=new Array("Purchase R/C","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_4=new Array("Sale R/C","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5=new Array("Reports","","",2,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1=new Array("Purchase","","",4,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1_1=new Array("Book","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1_2=new Array(" Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1_3=new Array(" Status","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_1_4=new Array("Analysis", "file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_2=new Array("Sale","","",4,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_2_1=new Array("Book","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_2_2=new Array(" Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_2_3=new Array(" Status","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_5_2_4=new Array("Analysis", "file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6=new Array("Edit","","",6,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_1=new Array("Purchase","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_2=new Array("Purchase Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_3=new Array("Purchase Confirm","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_4=new Array("Sale","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_5=new Array("Sale Return","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");
Menu3_6_6=new Array("Sale Confirm","file.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Consignment");

Menu4=new Array("Inventory","","",7,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_1=new Array("Add New","","",7,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_1=new Array("Diamond","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_2=new Array("Jewelry","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_3=new Array("Item","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_4=new Array("Location","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_5=new Array("Unit","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_6=new Array("Category","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_1_7=new Array("Sub Category","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_2=new Array("Opening Stock","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_3=new Array("Optimum. Qty","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_4=new Array("Stock Transfer","","",6,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_1=new Array("Location","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_2=new Array("Lot","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_3=new Array("Manufacturing","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_4=new Array("Melting","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_5=new Array("Loss","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_4_6=new Array("Gain","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");


Menu4_5=new Array("Picture","","",2,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_5_1=new Array("Upload","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_5_2=new Array("Modify","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6=new Array("Reports","","",9,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6_1=new Array("Stock","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_2=new Array("Location Stock","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_3=new Array("Stock Summary","","",4,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_3_1=new Array("Local","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_3_2=new Array("Dollar","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_3_3=new Array("Diamond","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_3_4=new Array("Jewelry","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6_4=new Array("Stock Transfer","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_5=new Array("Lot History","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_6=new Array("Lot Movement","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_7=new Array("Lot Matrix","","",4,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6_7_1=new Array("Diamond","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_7_2=new Array("Jewelry","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_7_3=new Array("Opening Diamond","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_7_4=new Array("opening Jewelry","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6_8=new Array("Alert","","",2,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_8_1=new Array("Reorder Point","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_6_8_2=new Array("Optimum. Qty ","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");

Menu4_6_9=new Array("Picture","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");


Menu4_7=new Array("Edit","","",6,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_1=new Array("Opening Stock","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_2=new Array("Lot","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_3=new Array("Location","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_4=new Array("Category","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_5=new Array("SubCategory","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");
Menu4_7_6=new Array("Unit","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","Inventory");



//Menu4=new Array("Open in new","javascript:NewWin=window.open(\"file.htm\",\"NWin\");window[\"NewWin\"].focus()","",0,20,100,"purple","yellow","yellow","purple","","",-1,1,-1,"","");
Menu5=new Array("Open in top","javascript:top.location.href=\"file.htm\"","rollover?"+BaseHref+"fclose.gif?"+BaseHref+"fopen.gif",2,20,100,"","","","","","arial",8,1,1,"right","");
	Menu5_1=new Array("Example 5.1 ","file.htm","",0,20,180,"black","green","yellow","blue","yellow","times new roman",10,-1,-1,"left","");
	Menu5_2=new Array("Example 5.2 ","file52.htm","",0,30,0,"black","white","yellow","blue","yellow","technical",14,1,1,"center","");
	Menu6=new Array("Example 3","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","");
Menu7=new Array("Example 3","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","");
Menu8=new Array("Example 3","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","");
Menu9=new Array("Example 3","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","");
Menu10=new Array("Example 3","file3.htm","",0,20,100,"","","","","","",-1,-1,-1,"","");




