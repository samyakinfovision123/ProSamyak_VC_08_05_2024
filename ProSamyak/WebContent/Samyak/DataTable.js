// get Lot Details

var ele;
var div_ele;
var lot_no;
var company_id;
var yearend_id;
function getLotDetails(ele,div_ele_id,temp_company_id,temp_yearend_id)
{
	
	ele=ele;
	div_ele=document.getElementById(div_ele_id);
	//alert("div_ele="+div_ele);
	lot_no=ele.value;
	company_id=temp_company_id;
	yearend_id=temp_yearend_id;
	
	getXmlLotDetails();
	
} //getSubGroup()



function getXmlLotDetails()
{
	
	var req = newXMLHttpRequest();

	req.onreadystatechange = getReadyStateHandler(req, setlotDetails);
 
	req.open("POST", "../lotDetails.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getLotDetails&company_id="+company_id+"&lot_no="+lot_no+"&yearend_id="+yearend_id);
 
} //getXmlSubGroup()

/*fetch date for subgroup  */
function setlotDetails(lotXML) {
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

	var LotList = lotXML.getElementsByTagName("LotDetailsList")[0];
	var generated = LotList.getAttribute("generated");

	if (generated > lastUpdate) {
	lastUpdate = generated;

	var lots = LotList.getElementsByTagName("Qty");
	
	if(lots.length==0)
	 {
	   alert("SubGroup Not Found");
	   //document.getElementById(rateTextBoxId).value="1";
	   //document.getElementById(lotIdHiddenId).value="";
	   //document.getElementById(focusTextBoxId).focus();
	   //document.getElementById(focusTextBoxId).select();
	 }
	
	for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var fin_qty=lot.getElementsByTagName("FinancialQty")[0].firstChild.nodeValue;
	 var phy_qty=lot.getElementsByTagName("PhysicalQty")[0].firstChild.nodeValue;
	 
	 if(div_ele.children(0))
	 {
		var oChild=div_ele.children(0);	
		div_ele.removeChild(oChild);
	 }
	 var oTable = document.createElement("TABLE");
	 oTable.setAttribute("width","100%");
	 oTable.style.setAttribute("border","1px solid #330000");
	 oTable.style.setAttribute("backgroundColor","#FFFFFF");
	 
	 
	 
	 
	 var oTBody = document.createElement("TBODY");
	 oTable.appendChild(oTBody);
	 div_ele.appendChild(oTable);
	 
	 
	 var oRow = document.createElement("TR");
	 
	 oTBody.appendChild(oRow);
	 
	 var oCol = document.createElement("TD");
	 oCol.style.setAttribute("border","1px solid #330000;");
	 oCol.style.setAttribute("backgroundColor","#FFFFFF");
	 
	 oRow.appendChild(oCol);
	 oCol.innerText="FinancialQty";
	 
	 oCol = document.createElement("TD");
	 oCol.style.setAttribute("border","1px solid #330000;");

	 oRow.appendChild(oCol);
	 oCol.innerText=fin_qty;
	
	 	  
	 oRow = document.createElement("TR");
	 oTBody.appendChild(oRow);
	 
	 oCol = document.createElement("TD");
	 oCol.style.setAttribute("border","1px solid #330000;");

	 oRow.appendChild(oCol);
	 oCol.innerText="PhysicalQty";
	 
	 oCol = document.createElement("TD");
	 oCol.style.setAttribute("border","1px solid #330000;");

	 oRow.appendChild(oCol);
	 oCol.innerText=phy_qty;

	 div_ele.height=20*2;

	}
	
	
}
 


}