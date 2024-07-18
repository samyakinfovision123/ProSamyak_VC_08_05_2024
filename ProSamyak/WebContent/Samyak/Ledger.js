// Timestamp of list that page was last updated with
var lastUpdate = 0;

var lotIdHiddenId;
var lotNoTextBoxId;
var descTextBoxId;
var sizeTextBoxId;
var rateTextBoxId;
var focusTextBoxId;

var salepuchase;

var company_id;
var lotno;
var desc;
var size;
var comparedate;

var ledger_group_id;
var subgroup_id_name="<select name=subGroup>";

function getSubGroup(group_id,Tcompany_id)
{
	ledger_group_id=group_id;
	company_id=Tcompany_id;
	getXmlSubGroup();
	
} //getSubGroup()



function getXmlSubGroup()
{
	
	var req = newXMLHttpRequest();

	req.onreadystatechange = getReadyStateHandler(req, updateLedger);
 
	req.open("POST", "../ledger.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&group_id="+ledger_group_id);
 
} //getXmlSubGroup()

/*fetch date for subgroup  */
function updateLedger(lotXML) {
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

	var LotList = lotXML.getElementsByTagName("LotList")[0];
	var generated = LotList.getAttribute("generated");

	if (generated > lastUpdate) {
	lastUpdate = generated;

	var lots = LotList.getElementsByTagName("Lot");
	
	if(lots.length==0)
	 {
	   alert("SubGroup Not Found");
	   //document.getElementById(rateTextBoxId).value="1";
	   //document.getElementById(lotIdHiddenId).value="";
	   //document.getElementById(focusTextBoxId).focus();
	   //document.getElementById(focusTextBoxId).select();
	 }
   var ele=document.getElementById("SubGroup")
   ele.options.length=0;
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var subgroup_id=lot.getElementsByTagName("SubgroupId")[0].firstChild.nodeValue;
	 var subgroup_name = lot.getElementsByTagName("SubgroupName")[0].firstChild.nodeValue;
    
	 ele.options[I]=new Option(subgroup_name,subgroup_id,false,false);
   }
	
	
}
 


}