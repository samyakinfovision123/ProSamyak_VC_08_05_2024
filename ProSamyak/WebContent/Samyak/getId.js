// Timestamp of list that page was last updated with
var lastUpdate = 0;


var company_id;
var name_element;
var id_element;
var name_value;
var date_value;
var currency;

function getIdByName(TName_value,TName_element,TId_element,TCompany_id,TDate,TCurrency)
{
	//alert("TName_value="+TName_value);
	//alert("TName_element="+TName_element);
	//alert("TId_element="+TId_element);
	//alert("TCompany_id="+TCompany_id);
	//alert("TDate="+TDate);
	// alert("TCurrency="+TCurrency);

	name_value=TName_value;
	name_element=TName_element;
	id_element=TId_element;
	company_id=TCompany_id;
	date_value=TDate;
	currency=TCurrency;
	//alert("Hello"+TName_value);
	if(currency)
	{
		currency="local";
	}
	else
	{
		currency="dollar";
	}
	getXmlIdByName();
	
} //getSubGroup()



function getXmlIdByName()
{
	
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, setId);
	req.open("POST", "../GetId.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	req.send("action=getsetId&company_id="+company_id+"&name="+name_value+"&date_value="+date_value+"&currency="+currency);
 
} //getXmlSubGroup()

/*fetch date for subgroup  */
function setId(lotXML)
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
			var local_closing=lot.getElementsByTagName("LocalClosing")[0].firstChild.nodeValue;
			
			var dollar_closing=lot.getElementsByTagName("DollarClosing")[0].firstChild.nodeValue;
			
			//alert("local_closing="+local_closing);
			//alert("dollar_closing="+dollar_closing);

			var temp_g_id=new Array();
			temp_g_id=g_id.split("#");
			//alert("temp_g_id1="+temp_g_id[0]);
			//alert("temp_g_id2="+temp_g_id[1]);
			
			//alert("name_element="+name_element);
			if("To"==name_element)
			{
				var ele=document.getElementById("sub_ledgers1");
				ele.options.length=0;
				//alert("g_id="+g_id);
				// prev code  // id_element.value=g_id;
				if(local_closing<0)
				{	
				document.mainform.to_local_closing.value=local_closing*(-1)+"  Cr";
				}
				else
				{
				document.mainform.to_local_closing.value=local_closing+"  Dr";
				}
				if(dollar_closing<0)
				{
				document.mainform.to_dollar_closing.value=dollar_closing*(-1)+"  Cr";
				}
				else
				{
				document.mainform.to_dollar_closing.value=dollar_closing+"  Dr";
				}
				if("local"==currency)
				{
				
					if(local_closing<0)
					{
						document.mainform.to_closing_balance.value=""+local_closing*(-1)+"  Cr";
					}
					else
					{
						document.mainform.to_closing_balance.value=""+local_closing+"  Dr";
					}
					
					
				}
				else
				{
					if(dollar_closing<0)
					{
						document.mainform.to_closing_balance.value=""+dollar_closing*(-1)+"	 Cr";
					}
					else
					{
						document.mainform.to_closing_balance.value=""+dollar_closing+"  Dr";
					}
					
				}
				
			if("Party"==temp_g_id[0])
			{
				ele.disabled=false;
				getXmlsubLedgersByName(temp_g_id[1]);
			}//if
			else
			{
				ele.disabled=true;
				id_element.value=g_id;
				document.mainform.settlement.focus();
			}//else*/
			} //if("To"==name_element)
			else
			{
				var ele=document.getElementById("sub_ledgers");
				ele.options.length=0;
				if(local_closing<0)
				{
					document.mainform.from_local_closing.value=local_closing*(-1)+"  Cr";
				}
				else
				{
					document.mainform.from_local_closing.value=local_closing+"  Dr";
				}
			if(dollar_closing<0)
			{
				document.mainform.from_dollar_closing.value=dollar_closing*(-1)+"  Cr";
			}
			else
			{
				document.mainform.from_dollar_closing.value=dollar_closing+"  Dr";
			}
				if("local"==currency)
				{
				
					if(local_closing<0)
					{
						
						local_closing=(parseFloat(local_closing)).toFixed(3);	document.mainform.closing_balance.value=""+local_closing*(-1)+"  Cr";
					}
					else
					{
						local_closing=(parseFloat(local_closing)).toFixed(3);	document.mainform.closing_balance.value=""+local_closing+"  Dr";
					}
					
					
				}
				else
				{
					if(dollar_closing<0)
					{
						dollar_closing=(parseFloat(dollar_closing)).toFixed(2);
						document.mainform.closing_balance.value=""+dollar_closing*(-1)+"  Cr";
					}
					else
					{
						dollar_closing=(parseFloat(dollar_closing)).toFixed(2);	document.mainform.closing_balance.value=""+dollar_closing+"  Dr";
					}
					
				}
				if("Party"==temp_g_id[0])
				{
					ele.disabled=false;
					getXmlsubLedgersByName(temp_g_id[1]);
				}//if
				else
				{
					ele.disabled=true;
					id_element.value=g_id;
					document.mainform.drcr.focus();
				}//else*/
			}
		} //for
	} //if
}

function getXmlsubLedgersByName(party_id)
{
	//alert(" 89");
	//alert("party_id="+party_id);
	var req = newXMLHttpRequest();
	req.onreadystatechange = getReadyStateHandler(req, setLedgerId);
	req.open("POST", "../GetId.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	req.send("action=getsetLedgerId&company_id="+company_id+"&party_id="+party_id);
}

function setLedgerId(lotXML)
{
	//alert("104");
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

	var LotList = lotXML.getElementsByTagName("LedgersIdList")[0];
	var generated = LotList.getAttribute("generated");

	if (generated > lastUpdate) 
	{
		lastUpdate = generated;
		var lots = LotList.getElementsByTagName("LedgersIdName");
		if(lots.length==0)
		{
			alert("SubGroup Not Found");
		} //if
		if("From"==name_element)
		{
			var ele=document.getElementById("sub_ledgers");
		}
		else
		{
			var ele=document.getElementById("sub_ledgers1");
		}
		ele.options.length=0;
		for (var I = 0 ; I < lots.length ; I++)
		{
			var lot = lots[I];
			var g_id=lot.getElementsByTagName("LedgerId")[0].firstChild.nodeValue;
			var g_name = lot.getElementsByTagName("LedgerName")[0].firstChild.nodeValue;
			var ledger_type="";
			//alert("g_name="+g_name);
			//alert("g_id="+g_id);
			if(g_name==1)
			{
				//alert("Sale");
				ledger_type="Sale";	
			}
			if(g_name==2)
			{
				//alert("Purchase");
				ledger_type="Purchase";	
			}
			if(g_name==3)
			{
				//alert("Pn");
				ledger_type="Pn";
			}
			if(g_name>3)
			{
				//alert("Other");
				ledger_type="Other";
			}

			ele.options[I]=new Option(ledger_type,g_id,false,false);
		} //for
	} //if
}