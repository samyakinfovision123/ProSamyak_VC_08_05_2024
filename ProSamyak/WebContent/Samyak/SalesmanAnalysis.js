// Timestamp of list that page was last updated with
var lastUpdate1 = 0;
var lastUpdate2 = 0;
var lastUpdate3 = 0;

var localCurrencySymbol="";
var thiscompany_id="";
var fdd=1;
var fmm=4;
var fyy=2006;
var tdd=31;
var tmm=3;
var tyy=2008;



/*
 * Call the reports methods to fetch all the three reports
 */
function getReports(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2, local_symbol) {
	
	getCreditExcess(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2);

	getPerDayCreditExcess(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2);

	getOverDue(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2);
	
	localCurrencySymbol = local_symbol;
	thiscompany_id = company_id;
	fdd = dd1;
	fmm = mm1;
	fyy = yy1;
	tdd = dd2;
	tmm = mm2;
	tyy = yy2;
}	




/*
 * get the per day credit excess using AJAX methods
 */
function getPerDayCreditExcess(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2)
{
 var req = newXMLHttpRequest();

 req.onreadystatechange = getReadyStateHandler(req, perDayCreditExcessReport);
 
 req.open("POST", "../SalesmanAnalysis.do", true);
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

 req.send("action=PerDayCreditExcess&salesperson_id="+salesperson_id+"&company_id="+company_id+"&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
 	
}


/*
 * per day credit excess report returned by the servlet
 */
function perDayCreditExcessReport(reportXML1)
{
 

 if(reportXML1.parseError.errorCode != 0 )
	{
		alert("errorCode: " + reportXML1.parseError.errorCode+ "\n" +
          "filepos: " + reportXML1.parseError.filepos + "\n" +
          "line: " + reportXML1.parseError.line + "\n" +
          "linepos: " + reportXML1.parseError.linepos + "\n" +
          "reason: " + reportXML1.parseError.reason + "\n" +
          "srcText: " + reportXML1.parseError.srcText + "\n" +
          "url: " + reportXML1.parseError.url);

	}
 var Report = reportXML1.getElementsByTagName("Report")[0];
 var generated = Report.getAttribute("generated");

 if (generated > lastUpdate1) {
   lastUpdate1 = generated;

   var reportrows = Report.getElementsByTagName("ReportRow");
   if(reportrows.length==1)
	{
		 htmlStr1 = "<center><font color='red'><b>No rows satisfying the criteria found</b></font></center>";
	}
   else
	{
		 htmlStr1="<DIV class=tableContainer id=data>";
		 htmlStr1+="<TABLE cellSpacing=0 border=1 width='100%' class=reportTable> <THEAD class=reportTable> <TR> <TD class=reportTable width='5%'>Sr No</TD><TD class=reportTable width='25%'>Party Name</TD> <TD class=reportTable width='10%'>Date</TD> <TD class=reportTable width='20%'>Total Sale on this Date ("+localCurrencySymbol+")</TD> <TD class=reportTable width='20%'>Credit Limit Per Day ("+localCurrencySymbol+")</TD> <TD class=reportTable width='20%'>Excess ("+localCurrencySymbol+")</TD> </TR> </THEAD> <TBODY>";
	}
   for (var I = 0 ; I < reportrows.length ; I++) {
	
     var row = reportrows[I];
     var partyid = row.getElementsByTagName("partyid")[0].firstChild.nodeValue;
     var partyname = row.getElementsByTagName("partyname")[0].firstChild.nodeValue;
     var saledate = row.getElementsByTagName("saledate")[0].firstChild.nodeValue;
     var perdaysale = row.getElementsByTagName("perdaysale")[0].firstChild.nodeValue;
     var perdaycreditlimit = row.getElementsByTagName("perdaycreditlimit")[0].firstChild.nodeValue;
     var excess = row.getElementsByTagName("excess")[0].firstChild.nodeValue;

	 if(partyname == "Total")
	 {
		htmltfootStr1 = "<TFOOT><TR> <TD align=left class=reportTable colspan=3 align=left>"+partyname+"</TD><TD align=right class=reportTable align=right>"+perdaysale+"</TD><TD align=right class=reportTable align=right>&nbsp;</TD> <TD align=right class=reportTable align=right>"+excess+"</TD></TR></TFOOT>";
	 }
	 else
	 {
		var datepart = saledate.split('/');

		htmlStr1+="<TR> <TD align=right class=reportTable>"+(I+1)+"</TD><TD align=left class=reportTable><A href='../Inventory/InvReport.jsp?dd1="+datepart[0]+"&mm1="+datepart[1]+"&yy1="+datepart[2]+"&dd2="+datepart[0]+"&mm2="+datepart[1]+"&yy2="+datepart[2]+"&location_id0=0&category_id=0&companyparty_id="+partyid+"&type=Invoice Date&purchasesalegroup_id=0&salesperson_id=0&broker_id=0&amount=yes&quantity=yes&ref_no=yes&currencyin=Local&order=ASCE&orderby1=Receive_Id&orderby2=Invoice_No&command=Sale&company_id="+thiscompany_id+"&summary=no&sFlag=0&category_code=4&user_level=5' target='_blank' style='color:#39c'>"+partyname+"</A></TD>    <TD align=left class=reportTable>"+saledate+"</TD> <TD align=right class=reportTable>"+perdaysale+"</TD><TD align=right class=reportTable>"+perdaycreditlimit+"</TD> <TD align=right class=reportTable>"+excess+"</TD></TR>";
	 }
   }

   if(reportrows.length>1)
   {
	 htmlStr1+="</TBODY>"+htmltfootStr1+"</TABLE></DIV>";
   }

	 document.getElementById("perDayExcessReport").innerHTML=htmlStr1;
}
 
}

/*
 * get the over due report using AJAX methods
 */
function getOverDue(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2)
{
 var req = newXMLHttpRequest();

 req.onreadystatechange = getReadyStateHandler(req, OverDueReport);
 
 req.open("POST", "../SalesmanAnalysis.do", true);
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

 req.send("action=OverDueReport&salesperson_id="+salesperson_id+"&company_id="+company_id+"&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
 	
}


/*
 * overdue report returned by the servlet
 */
function OverDueReport(reportXML2)
{
 

 if(reportXML2.parseError.errorCode != 0 )
	{
		alert("errorCode: " + reportXML2.parseError.errorCode+ "\n" +
          "filepos: " + reportXML2.parseError.filepos + "\n" +
          "line: " + reportXML2.parseError.line + "\n" +
          "linepos: " + reportXML2.parseError.linepos + "\n" +
          "reason: " + reportXML2.parseError.reason + "\n" +
          "srcText: " + reportXML2.parseError.srcText + "\n" +
          "url: " + reportXML2.parseError.url);

	}
 var Report = reportXML2.getElementsByTagName("Report")[0];
 var generated = Report.getAttribute("generated");

 if (generated > lastUpdate2) {
   lastUpdate2 = generated;

   var reportrows = Report.getElementsByTagName("ReportRow");
   if(reportrows.length==1)
	{
		 htmlStr2 = "<center><font color='red'><b>No rows satisfying the criteria found</b></font></center>";
	}
   else
	{
		 htmlStr2="<DIV class=tableContainer1 id=data1>";
		 htmlStr2+="<TABLE cellSpacing=0 border=1 width='100%' class=reportTable1> <THEAD class=reportTable1> <TR> <TD class=reportTable1>Sr No</TD><TD class=reportTable1>Receive No</TD> <TD class=reportTable1>Party Name</TD> <TD class=reportTable1>Receive Date</TD> <TD class=reportTable1>Due Date</TD> <TD class=reportTable1>OverDue Days</TD> <TD class=reportTable1>Total ("+localCurrencySymbol+")</TD> <TD class=reportTable1>Received ("+localCurrencySymbol+")</TD> <TD class=reportTable1>Balance ("+localCurrencySymbol+")</TD> </TR> </THEAD> <TBODY>";
	}
   for (var I = 0 ; I < reportrows.length ; I++) {
	
     var row = reportrows[I];
     var rid = row.getElementsByTagName("rid")[0].firstChild.nodeValue;
     var rno = row.getElementsByTagName("rno")[0].firstChild.nodeValue;
     var partyname = row.getElementsByTagName("partyname")[0].firstChild.nodeValue;
     var partyid = row.getElementsByTagName("partyid")[0].firstChild.nodeValue;
     var receivedate = row.getElementsByTagName("receivedate")[0].firstChild.nodeValue;
     var duedate = row.getElementsByTagName("duedate")[0].firstChild.nodeValue;
     var overduedays = row.getElementsByTagName("overduedays")[0].firstChild.nodeValue;
     var total = row.getElementsByTagName("total")[0].firstChild.nodeValue;
     var received = row.getElementsByTagName("received")[0].firstChild.nodeValue;
     var balance = row.getElementsByTagName("balance")[0].firstChild.nodeValue;

	 if(partyname == "Total")
	 {
		htmltfootStr2 = "<TFOOT><TR> <TD align=left class=reportTable1 colspan=6 align=left>"+partyname+"</TD><TD align=right class=reportTable1 align=right>"+total+"</TD><TD align=right class=reportTable1 align=right>"+received+"</TD> <TD align=right class=reportTable1 align=right>"+balance+"</TD></TR></TFOOT>";
	 }
	 else
	 {
		htmlStr2+="<TR> <TD align=left class=reportTable1>"+(I+1)+"</TD> <TD align=left class=reportTable1>"+rno+"</TD><TD align=left class=reportTable1><A href='../Report/OutstandingReceivables.jsp?dd1="+fdd+"&mm1="+fmm+"&yy1="+fyy+"&dd2="+tdd+"&mm2="+tmm+"&yy2="+tyy+"&datecondition=duedate&companyparty_id="+partyid+"&type=9&purchasesalegroup_id=0&salesperson_id=0&currency=local&orderby=Receive_No&groupby=customer&command=Show&company_id="+thiscompany_id+"' target='_blank' style='color:#39c'>"+partyname+"</A></TD>    <TD align=left class=reportTable1>"+receivedate+"</TD> <TD align=left class=reportTable1>"+duedate+"</TD> <TD align=right class=reportTable1>"+overduedays+"</TD> <TD align=right class=reportTable1>"+total+"</TD><TD align=right class=reportTable1>"+received+"</TD> <TD align=right class=reportTable1>"+balance+"</TD></TR>";
	 }
	 
   }

   if(reportrows.length>1)
   {
	 htmlStr2+="</TBODY>"+htmltfootStr2+"</TABLE></DIV>";
   }

	 document.getElementById("overdueReport").innerHTML=htmlStr2;
}
 
}

/*
 * get the credit excess using AJAX methods
 */
function getCreditExcess(salesperson_id, company_id, dd1, mm1, yy1, dd2, mm2, yy2)
{
 var req = newXMLHttpRequest();

 req.onreadystatechange = getReadyStateHandler(req, CreditExcessReport);
 
 req.open("POST", "../SalesmanAnalysis.do", true);
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

 req.send("action=CreditExcess&salesperson_id="+salesperson_id+"&company_id="+company_id+"&dd1="+dd1+"&mm1="+mm1+"&yy1="+yy1+"&dd2="+dd2+"&mm2="+mm2+"&yy2="+yy2);
 	
}


/*
 * credit excess report returned by the servlet
 */
function CreditExcessReport(reportXML3)
{
 

 if(reportXML3.parseError.errorCode != 0 )
	{
		alert("errorCode: " + reportXML3.parseError.errorCode+ "\n" +
          "filepos: " + reportXML3.parseError.filepos + "\n" +
          "line: " + reportXML3.parseError.line + "\n" +
          "linepos: " + reportXML3.parseError.linepos + "\n" +
          "reason: " + reportXML3.parseError.reason + "\n" +
          "srcText: " + reportXML3.parseError.srcText + "\n" +
          "url: " + reportXML3.parseError.url);

	}
 var Report = reportXML3.getElementsByTagName("Report")[0];
 var generated = Report.getAttribute("generated");

 if (generated > lastUpdate3) {
   lastUpdate3 = generated;

   var reportrows = Report.getElementsByTagName("ReportRow");
   if(reportrows.length==1)
	{
		 htmlStr3 = "<center><font color='red'><b>No rows satisfying the criteria found</b></font></center>";
	}
   else
	{
		 htmlStr3="<DIV class=tableContainer2 id=data2>";
		 htmlStr3+="<TABLE cellSpacing=0 border=1 width='100%' class=reportTable2> <THEAD class=reportTable2> <TR><TD class=reportTable2 width='5%'>Sr No</TD> <TD class=reportTable2 width='35%'>Party Name</TD> <TD class=reportTable2 width='20%'>Sales Closing ("+localCurrencySymbol+")</TD> <TD class=reportTable2 width='20%'>Credit Limit ("+localCurrencySymbol+")</TD> <TD class=reportTable2 width='20%'>Excess ("+localCurrencySymbol+")</TD> </TR> </THEAD> <TBODY>";
	}
   for (var I = 0 ; I < reportrows.length ; I++) {
	
     var row = reportrows[I];
     var partyid = row.getElementsByTagName("partyid")[0].firstChild.nodeValue;
     var partyname = row.getElementsByTagName("partyname")[0].firstChild.nodeValue;
     var closing = row.getElementsByTagName("closing")[0].firstChild.nodeValue;
     var creditlimit = row.getElementsByTagName("creditlimit")[0].firstChild.nodeValue;
     var excess = row.getElementsByTagName("excess")[0].firstChild.nodeValue;

	 if(partyname == "Total")
	 {
		htmltfootStr3 = "<TFOOT><TR> <TD align=left class=reportTable2 colspan=2 align=left>"+partyname+"</TD><TD align=right class=reportTable2 align=right>"+closing+"</TD><TD align=right class=reportTable2 align=right>&nbsp;</TD> <TD align=right class=reportTable2 align=right>"+excess+"</TD></TR></TFOOT>";
	 }
	 else
	 {
	
		htmlStr3+="<TR> <TD align=left class=reportTable2>"+(I+1)+"</TD><TD align=left class=reportTable2><A href='../Report/PartyReportFast.jsp?dd1="+fdd+"&mm1="+fmm+"&yy1="+fyy+"&dd2="+tdd+"&mm2="+tmm+"&yy2="+tyy+"&party_id="+partyid+"&sale=yes&currency=Local&orderby=transDate&command=Show&company_id="+thiscompany_id+"' target='_blank' style='color:#39c'>"+partyname+"</A></TD> <TD align=right class=reportTable2>"+closing+"</TD><TD align=right class=reportTable2>"+creditlimit+"</TD> <TD align=right class=reportTable2>"+excess+"</TD></TR>";
	 }
	 
   }

   if(reportrows.length>1)
   {
	 htmlStr3+="</TBODY>"+htmltfootStr3+"</TABLE></DIV>";
   }

	 document.getElementById("creditExcessReport").innerHTML=htmlStr3;
}
 
}