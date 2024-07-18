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


var company_id_header;
var receive_no_header;
var isNext_header;
var ele_name_header;
var rec_id_header;
var button_pressed_header;

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


function getNextReceiveNoPurchase(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	receive_no=Treceive_no;
	company_id=Tcompany_id;
	isNext=TisNext;
	ele_name=Tname;
	rec_id=TId;
	button_pressed=TButton;
	
	getXmlNextReceiveNoPurchase();
	
} //getNextReceiveNo

function getNextReceiveNoStockTransfer(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	
	
	receive_no=Treceive_no;
	company_id=Tcompany_id;
	isNext=TisNext;
	ele_name=Tname;
	rec_id=TId;
	button_pressed=TButton;
	
	getXmlNextReceiveNoStockTransfer();
	
} //getNextReceiveNo


function getNextCompanyParty(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	
	receive_no=Treceive_no;
	company_id=Tcompany_id;
	isNext=TisNext;
	ele_name=Tname;
	rec_id=TId;
	
	button_pressed=TButton;
	
	getXmlNextCompanyPartyIdName();
	
} //getNextReceiveNo


function getNextCompanyParty_header(Treceive_no,Tcompany_id,TisNext,Tname,TId,TButton)
{
	
	receive_no_header=Treceive_no;
	company_id_header=Tcompany_id;
	isNext_header=TisNext;
	ele_name_header=Tname;
	rec_id_header=TId;
	
	button_pressed_header=TButton;
	
	getXmlNextCompanyPartyIdName_header();
	
} //getNextReceiveNo


function getXmlNextReceiveNo()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getIdNumber);
 
	req.open("POST", "../ReceiveIdNumber.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&receive_no="+receive_no+"&isNext="+isNext);
 
} //getXmlSubGroup()



function getXmlNextReceiveNoPurchase()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getIdNumberPurchase);
 
	req.open("POST", "../ReceiveIdNumberPurchase.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&receive_no="+receive_no+"&isNext="+isNext);
 
} //getXmlSubGroup()

function getXmlNextReceiveNoStockTransfer()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getIdNumberStockTransfer);
 
	req.open("POST", "../ReceiveIdNumberStockTransfer.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&receive_no="+receive_no+"&isNext="+isNext);
 
} //getXmlSubGroup()

function getXmlNextCompanyPartyIdName()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getCompanyPartyIdName);
 
	req.open("POST", "../CompanyParty.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id+"&party_name="+receive_no+"&isNext="+isNext);
 
} //getXmlSubGroup()

function getXmlNextCompanyPartyIdName_header()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, getCompanyPartyIdName_header);
 
	req.open("POST", "../CompanyParty.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getSubGroupLedger&company_id="+company_id_header+"&party_name="+receive_no_header+"&isNext="+isNext_header);
 
} //getXmlSubGroup()


/*fetch date for subgroup  */
function getIdNumber(lotXML) {
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
	 //alert(" 162="+r_id);
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 //alert(" 164 ="+r_no);
	 rec_id.value=r_id;
	 ele_name.value=r_no;
	 editCancel(button_pressed);
   }
	
	
}
 
}



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
	 //alert(r_id);
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 //alert(r_no);
	 rec_id.value=r_id;
	 ele_name.value=r_no;
	 editCancel(button_pressed);
   }
	
	
}
 
}


function getIdNumberStockTransfer(lotXML) {
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
	 //alert(r_id);
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 //alert(r_no);
	 rec_id.value=r_id;
	 ele_name.value=r_no;
	 editCancel(button_pressed);
   }
	
	
}
 
}


function getCompanyPartyIdName(lotXML) {
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
	  
	   rec_id.value=rec_id.value;
	   ele_name.value=ele_name.value;
		document.mainform.action="../Master/NewCompanyPartyAccount.jsp?message=Default&account_no=Party";
		document.mainform.submit();
		return ;
	 }
   
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var r_id=lot.getElementsByTagName("ReceiveId")[0].firstChild.nodeValue;
	 //alert(r_id);
	 var r_no = lot.getElementsByTagName("ReceiveNo")[0].firstChild.nodeValue;
	 //alert(r_no);
	 
	 var account_type = lot.getElementsByTagName("AccountType")[0].firstChild.nodeValue;

	 rec_id.value=r_id;
	 ele_name.value=r_no;
		
	if(account_type=="party_account")
	{
		document.mainform.action='../Master/EditCompanyPartyAccount.jsp?command=PartySelected&CompanyParty_Id='+r_id;
		document.mainform.submit();
	}
	if(account_type=="cash_account")
	{
		document.mainform.action='../Master/EditCashBankAccount.jsp?command=SelectedAccountName&account_id='+r_id+'&type=cash';
		
		document.mainform.submit();
	}
	if(account_type=="bank_account")
	{
		document.mainform.action='../Master/EditCashBankAccount.jsp?command=SelectedAccountName&account_id='+r_id+'&type=bank';
		
		document.mainform.submit();
	}
	 //editCancel(button_pressed);
   }
	
	
}
 
}


function getCompanyPartyIdName_header(lotXML) {
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
	 
	 var account_type = lot.getElementsByTagName("AccountType")[0].firstChild.nodeValue;
	 
	 rec_id_header.value=r_id;
	 ele_name_header.value=r_no;
	 account_type.value=account_type;
	 document.new_mainform.account_type.value=account_type;
	 //document.f1.account_type.value=account_type;
	
	 editCancel('2');
   }
	
	
}
 
}