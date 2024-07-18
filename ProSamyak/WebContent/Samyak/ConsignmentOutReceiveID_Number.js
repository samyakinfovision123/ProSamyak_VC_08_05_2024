// Timestamp of list that page was last updated with
var lastUpdate = 0;

var lotIdHiddenId;
var lotNoTextBoxId;
var descTextBoxId;
var sizeTextBoxId;
var rateTextBoxId;
var focusTextBoxId;



var company_id;
var receive_no;
var isNext;
var ele_name;
var rec_id;
var button_pressed;
var receivelots;
var date;
function getNextReceiveNo(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	receive_no=Treceive_no;
	company_id=Tcompany_id;
	isNext=TisNext;
	ele_name=Tname;
	rec_id=TId;
	button_pressed=TButton;
	getXmlNextReceiveNo();
	
} //getNextReceiveNo


function getNextReceiveNoPurchase(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton,Tlots,tdate)
{
	
	receive_no=Treceive_no;
	company_id=Tcompany_id;
	isNext=TisNext;
	ele_name=Tname;
	rec_id=TId;
	button_pressed=TButton;
	receivelots=Tlots;
	date=tdate;
	getXmlNextReceiveNoPurchase();
	
} //getNextReceiveNo

function getXmlNextReceiveNoPurchase()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getIdNumberPurchase);
 
	req.open("POST", "../ConsignmentOutReceiveIdNumberPurchase.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&receive_no="+receive_no+"&isNext="+isNext);
 
} //getXmlSubGroup()

function getIdNumberPurchase(lotXML) {
	if(lotXML.parseError.errorCode != 0 )
	{
		alert("errorCode: " + lotXML.parseError.errorCode+ "\n" +
          "filepos: " + lotXML.parseError.filepos + "\n" +
          "line: " + lotXML.parseError.line + "\n" +
          "linepos: " + lotXML.parseError.linepos + "\n" +
          "reason: " + lotXML.parseError.reason + "\n" +
          "srcText: " + lotXML.parseError.srcText + "\n" +
          "url: " + lotXML.parseError.url);

	}

	var LotList = lotXML.getElementsByTagName("IdList")[0];
	var generated = LotList.getAttribute("generated");

	if (generated > lastUpdate) {
	lastUpdate = generated;

	var lots = LotList.getElementsByTagName("ReceiveIdNumber");
	
	if(lots.length==0)
	 {
	   alert("Invoice Not Found");
	   rec_id.value=rec_id.value;
	   ele_name.value=ele_name.value;
	   return;
	 }
   
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var r_id=lot.getElementsByTagName("ReceiveId")[0].firstChild.nodeValue;
	
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 //alert(r_no);

	 var r_lots=lot.getElementsByTagName("ReceiveLots")[0].firstChild.nodeValue;
	 var r_date=lot.getElementsByTagName("ReceiveDate")[0].firstChild.nodeValue;
	
	 rec_id.value=r_id;
	 ele_name.value=r_no;
	 receivelots.value=r_lots;
	 //alert("receivelots"+receivelots.value);
	 date.value=r_date;
	 editCancel(button_pressed);

   }
	
	
}
 
}

