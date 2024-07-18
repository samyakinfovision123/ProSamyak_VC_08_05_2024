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

/*
 *Constructor for new lot object 
 *
 */
function Lot(lot_id, lot_no, description, dsize, salerate, purchaserate){
     this.lot_id = lot_id;
     this.lot_no = lot_no;
     this.description = description;
     this.dsize = dsize;
	 this.salerate = salerate;
	 this.purchaserate = purchaserate;
}


/*
 * get the lots list 
 */
function getLots(Tcompany_id, TDesc, TSize, TDate, lotId, lotNo, rateId, focusId, rateType) {
	company_id = Tcompany_id;	
	desc = encodeURIComponent(TDesc) ;	
	size = encodeURIComponent(TSize);	
	comparedate = TDate;	
	
	lotIdHiddenId = lotId;
	lotNoTextBoxId = lotNo;
	rateTextBoxId = rateId;
	focusTextBoxId = focusId

	if(rateType == "sale")
		salepuchase = "sale";

	if(rateType == "purchase")
		salepuchase = "purchase";

	getXmlDataLot();
	
}	


/*
 * get the lots list description and size
 */
function getDescSize(Tcompany_id, TLotNo, TDate, lotId, descId, sizeId, rateId, focusId, rateType) {
	company_id = Tcompany_id;	
	lotno = encodeURIComponent(TLotNo);	
	comparedate = TDate;	
	
	lotIdHiddenId = lotId;
	descTextBoxId = descId;
	sizeTextBoxId = sizeId;
	rateTextBoxId = rateId;
	focusTextBoxId = focusId

	if(rateType == "sale")
		salepuchase = "sale";

	if(rateType == "purchase")
		salepuchase = "purchase";

	getXmlDataDescSize();
	
}	


/*
 * get the lots using the AJAX methods
 */
function getXmlDataLot()
{
 var req = newXMLHttpRequest();

 req.onreadystatechange = getReadyStateHandler(req, updateLotsList);
 
 req.open("POST", "../lot.do", true);
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

 req.send("action=getLots&company_id="+company_id+"&desc="+desc+"&size="+size+"&comparedate="+comparedate);
 	
}


/*
 * get the lots description and size using the AJAX methods
 */
function getXmlDataDescSize()
{
 var req = newXMLHttpRequest();

 req.onreadystatechange = getReadyStateHandler(req, updateLotsListDescSize);
 
 req.open("POST", "../lot.do", true);
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

 req.send("action=getDescSize&company_id="+company_id+"&lotno="+lotno+"&comparedate="+comparedate);
 	
}


/*
 * use the data fetched
 */

function updateLotsList(lotXML) {

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
	   alert("Lot not found");
	   document.getElementById(rateTextBoxId).value="1";
	   document.getElementById(lotIdHiddenId).value="";
	   document.getElementById(focusTextBoxId).focus();
	   document.getElementById(focusTextBoxId).select();
	 }
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var lotid = lot.getElementsByTagName("lotid")[0].firstChild.nodeValue;
     var lotno = lot.getElementsByTagName("lotno")[0].firstChild.nodeValue;
     var salerate = lot.getElementsByTagName("salerate")[0].firstChild.nodeValue;
     var purchaserate = lot.getElementsByTagName("purchaserate")[0].firstChild.nodeValue;

	 document.getElementById(lotIdHiddenId).value=lotid;
	 document.getElementById(lotNoTextBoxId).value=lotno;
	 if(salepuchase == "purchase")
		document.getElementById(rateTextBoxId).value=purchaserate;
	 if(salepuchase == "sale")
		document.getElementById(rateTextBoxId).value=salerate;

	 
   }
}
 
}


/*
 * use the data fetched
 */

function updateLotsListDescSize(lotXML) {

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
	   alert("Lot not found");
	   document.getElementById(rateTextBoxId).value="1";
	   document.getElementById(lotIdHiddenId).value="";
	   document.getElementById(focusTextBoxId).focus();
	   document.getElementById(focusTextBoxId).select();
	 }
   for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var lotid = lot.getElementsByTagName("lotid")[0].firstChild.nodeValue;
     var description = lot.getElementsByTagName("description")[0].firstChild.nodeValue;
     var dsize = lot.getElementsByTagName("size")[0].firstChild.nodeValue;
     var purchaserate = lot.getElementsByTagName("purchaserate")[0].firstChild.nodeValue;
	 var salerate = lot.getElementsByTagName("salerate")[0].firstChild.nodeValue;

	 document.getElementById(lotIdHiddenId).value=lotid;
	 document.getElementById(descTextBoxId).value=description;
	 document.getElementById(sizeTextBoxId).value=dsize;
	 if(salepuchase == "purchase")
		document.getElementById(rateTextBoxId).value=purchaserate;
	 if(salepuchase == "sale")
		document.getElementById(rateTextBoxId).value=salerate;
		
	 if(salepuchase == "purchaseEdit"){}
			//document.getElementById(rateTextBoxId).value=purchaserate;
	 
   }
}
 
}

