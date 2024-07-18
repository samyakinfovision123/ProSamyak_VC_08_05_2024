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


var company_id_header;
var receive_no_header;
var isNext_header;
var ele_name_header;
var rec_id_header;
var button_pressed_header;

function getNextSalePerson_header(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	
	receive_no_header=Treceive_no;
	//alert("receive_no_header="+receive_no_header);
	company_id_header=Tcompany_id;
	//alert("company_id_header="+company_id_header);
	isNext_header=TisNext;
//	alert("isNext_header="+isNext_header);
	ele_name_header=Tname.value;
	//alert("ele_name_header="+ele_name_header);
	rec_id_header=TId;
	//alert("rec_id_header="+TId);
	
	button_pressed_header=TButton;
	//alert("button_pressed_header="+button_pressed_header);
	
	getXmlNextSalePersonIdName_header();
	
} //getNextReceiveNo

function getXmlNextSalePersonIdName_header()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getSalePersonIdName_header);
 
	req.open("POST", "../SalePerson.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id_header+"&SalePerson_name="+receive_no_header+"&isNext="+isNext_header);
 
} //getXmlSubGroup()



function getSalePersonIdName_header(lotXML) {

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
	   alert("Sale Person Not Found");
	  
	   rec_id_header.value=rec_id_header.value;
	   ele_name_header.value=ele_name_header.value;
	   return ;
	 }
   
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var r_id=lot.getElementsByTagName("ReceiveId")[0].firstChild.nodeValue;
	 
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 
	// var account_type = lot.getElementsByTagName("AccountType")[0].firstChild.nodeValue;

  //	alert("Id="+r_id);
	 rec_id_header.value=r_id;
	 //alert("r_id"+r_id);
	 //alert( " rec_id_header.value"+rec_id_header.value);
	 receive_no_header.value=r_no;
	 ele_name_header.value=r_no;
	//document.new_mainform.cancel_receiveid=r_id;	
	document.new_mainform.cancel_invno.value=r_no;
	//document.new_mainform.cancel_receiveid.value=r_id;
	editCancel('2');
   }
	
	
}
 
}