// Timestamp of list that page was last updated with
var lastUpdate = 0;


var company_id;
var name_element;
var id_element;
var name_value;
var date_value;
var currency;



function getCashBankLedgerIdByName(TName_value,TName_element,TId_element,TCompany_id)
{
	//alert("TName_value="+TName_value);
	//alert("TName_element="+TName_element);
	//alert("TId_element="+TId_element);
	//alert("TCompany_id="+TCompany_id);
	name_value=TName_value;
	name_element=TName_element;
	id_element=TId_element;
	company_id=TCompany_id;
	getXmlCashBankLedgerIdByName();
} //getCashBankLedgerId

function getXmlCashBankLedgerIdByName()
{
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, setCashBankLedgerId);
	req.open("POST", "../GetId.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	req.send("action=getsetCashBankLedgerId&company_id="+company_id+"&name="+name_value);
 
} //getXmlSubGroup()

/*fetch date for subgroup  */
function setCashBankLedgerId(lotXML)
{
	//alert("Hello");
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
	if (generated > lastUpdate) 
	{
		lastUpdate = generated;
		var lots = LotList.getElementsByTagName("IdName");
		if(lots.length==0)
		{
			alert("SubGroup Not Found");
		} //if
		for (var I = 0 ; I < lots.length ; I++)
		{
			var lot = lots[I];
			var g_id=lot.getElementsByTagName("ColumnId")[0].firstChild.nodeValue;
			var g_name = lot.getElementsByTagName("ColumnName")[0].firstChild.nodeValue;
			
			var temp_g_id=new Array();
			temp_g_id=g_id.split("#");
			//alert("temp_g_id1="+temp_g_id[0]);
			//alert("temp_g_id2="+temp_g_id[1]);
			if("Party"==temp_g_id[0])
			{
				document.f1.party_id.value=temp_g_id[1];
				document.f1.account_type.value=temp_g_id[0];
				//document.f1.action="../Home/PartyFinanceMingle.jsp?command=Next";
				//document.f1.submit();
			}
			if("Cash"==temp_g_id[0])
			{
				document.f1.account_id.value=temp_g_id[1];
				document.f1.account_type.value=temp_g_id[0];
				//document.f1.action="../Report/CashBankBookNew_Format.jsp?command=Next&BookType=Cash&orderby=vouchDate&exchrate=yes&refno=yes&bothCurrency=both";
				//document.f1.submit();
			}
			if("Bank"==temp_g_id[0])
			{
				document.f1.account_id.value=temp_g_id[1];
				document.f1.account_type.value=temp_g_id[0];
				//document.f1.action="../Report/CashBankBookNew_Format.jsp?command=Next&BookType=Bank&orderby=vouchDate&exchrate=yes&refno=yes&bothCurrency=both";
				//document.f1.submit();
			}
			//alert("name_element="+name_element);
			
		} //for
	} //if
}

