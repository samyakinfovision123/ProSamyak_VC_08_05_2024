
var table_name;
var column_name;
var condition;
var company_id;

function getDataFromTable(Ttable_name,Tcolumn_name,Tcondition,Tcompany_id)
{
	table_name=Ttable_name;
	column_name=Tcolumn_name;
	condition=Tcondition;	
	company_id=Tcompany_id;	
	getXmlData();
	
} //getSubGroup()



function getXmlData()
{
	
	var req = newXMLHttpRequest();

	req.onreadystatechange = getReadyStateHandler(req, getData);
 
	req.open("POST", "../DBServlet.do", true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	req.send("action=getData&table_name="+table_name+"&column_name="+column_name+"&company_id="+company_id+"&condition="+condition);
 
} //getXmlSubGroup()

/*fetch date for subgroup  */
function getData(lotXML) {
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

	var LotList = lotXML.getElementsByTagName("DBData")[0];
	var generated = LotList.getAttribute("generated");

	if (generated > lastUpdate) {
	lastUpdate = generated;

	var lots = LotList.getElementsByTagName("DBColumn");
	
	if(lots.length==0)
	 {
	   alert("SubGroup Not Found");
	   
	 }
	
	for (var I = 0 ; I < lots.length ; I++) {
	
     var lot = lots[I];
     var column_name_value=lot.getElementsByTagName("ColumnName")[0].firstChild.nodeValue;
     var location_name=lot.getElementsByTagName("LocationName")[0].firstChild.nodeValue;
	 var due_days=lot.getElementsByTagName("DueDays")[0].firstChild.nodeValue;
	 //alert("column_name_value="+column_name_value);
	 //alert("location_name="+location_name);
	 for(cnt=0;cnt<document.mainform.purchaseperson_id.options.length;cnt++)
	 {
		if(document.mainform.purchaseperson_id.options[cnt].value==column_name_value)
		{
		
		document.mainform.purchaseperson_id.options[cnt].selected=true;
		}
	} //for
	
	if((location_name!=-1))
	{
		for(cnt=0;cnt<document.mainform.location_id0.options.length;cnt++)
		{
		if(document.mainform.location_id0.options[cnt].value==location_name)
		{
			document.mainform.location_id0.options[cnt].selected=true;
		}
	} //for
	document.mainform.duedays.value=due_days;
	}

	}
	
	

}
 


}

