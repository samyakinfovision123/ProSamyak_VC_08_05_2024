// Timestamp of list that page was last updated with
var company_id_header;
var receive_no_header;
var isNext_header;
var ele_name_header;
var rec_id_header;
var button_pressed_header;
var account_type;
var ledger;
function getAccountTypeId(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton,Taccount_Type,TLedger)
{
	receive_no_header=Treceive_no;
	company_id_header=Tcompany_id;
	isNext_header=TisNext;
	ele_name_header=Tname;
	rec_id_header=TId;
	button_pressed_header=TButton;
	account_type=Taccount_Type;
	ledger=TLedger;
	
	getXmlgetAccountTypeId();
} //getNextReceiveNo

function getXmlgetAccountTypeId()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getXmlgetAccountTypeIdName);
 
	req.open("POST", "../CompanyParty.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id_header+"&party_name="+receive_no_header+"&isNext="+isNext_header);
 
} //getXmlSubGroup()


/*fetch date for subgroup  */
function getXmlgetAccountTypeIdName(lotXML) {
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
	   alert("Party Not Found");
	  
	   rec_id_header.value=rec_id_header.value;
	   ele_name_header.value=ele_name_header.value;
	   return ;
	 }
   
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var r_id=lot.getElementsByTagName("ReceiveId")[0].firstChild.nodeValue;
	 
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 
	 var account_type1 = lot.getElementsByTagName("AccountType")[0].firstChild.nodeValue;
	 
	 var ledger_id= lot.getElementsByTagName("LedgerId")[0].firstChild.nodeValue;

	 rec_id_header.value=r_id;
	 ele_name_header.value=r_no;
	 account_type.value=account_type1;
	 ledger.value=ledger_id;
	 //document.new_mainform.account_type.value=account_type;
	 //account_type.value=account_type;
	
	 editCancel('2');
   }
	
	
}
 
}