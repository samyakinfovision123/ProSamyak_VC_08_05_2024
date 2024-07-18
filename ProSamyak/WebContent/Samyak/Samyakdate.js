
/*
Modified by Parin to add default date as Today's date if the entered date is wrong
Date : 20-11-2008
*/

/*
--------------------------------------------------------------------------------------------------
SrNo	Date		By			Code			Reasons		
-------------------------------------------------------------------------------------------------------
1		01/09/09	Chanchal	CVD010909		To set max date till 2015 hardcoded in utc format 
------------------------------------------------------------------------------------------------------
*/

var errfound = false;

function fnCheckDate(astrDate,astrFieldName)
{
var lstrDate = astrDate				//Local variable containing the argument
var lstrYear = "";					//Contains string representation of year
var lstrMonth = "";					//Contains string representation of month
var lstrDay = "";					//Contains string representation of day
var lintYear;						//Contains integer representation of year
var lintMonth;						//Contains integer representation of month
var lintDay;						//Contains integer representation of day
var lstrValidCharacters = "0123456789/";	//Contains valid character that can (should) be there in the date string
var lintCount;						//Temporary variable for counting etc.
var lintSlashCount = 0;				//COntains the no. of slashs('/') in the date string
var lstrTemp = "";					//Temporary variable that contains single characters if the date string
var lintFirstSlashPosition;			//Contains the position of first occurance of '/' in date string
var lintSecondSlashPosition;		//Contains the position of second occurance of '/' in date string
//Check for valid characters.
var today=new Date();
var tDate=today.getDate();
var tMonth=today.getMonth()+1;
var tYear=today.getYear();
if(tDate<9)
	tDate = "0"+tDate;
if(tMonth<9)
	tMonth = "0"+tMonth;
todayDate=tDate+"/"+tMonth+"/"+tYear;
for (lintCount = 0; lintCount < lstrDate.length; lintCount++)
{
lstrTemp = lstrDate.substring(lintCount, lintCount + 1);
if (lstrValidCharacters.indexOf(lstrTemp) == -1) 
{
			alert (astrFieldName + " should be valid date in DD/MM/YYYY format");
			mainform.datevalue.select();
			mainform.datevalue.value=todayDate;
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		mainform.datevalue.value=todayDate;
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition = lstrDate.indexOf("/", 0);
	lintSecondSlashPosition = lstrDate.indexOf("/", lintFirstSlashPosition + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition != 2) || (lintSecondSlashPosition != 5) || (lstrDate.length != 10))
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		mainform.datevalue.value=todayDate;
		return false;
	}
	//Above two checks also ensure that the day and month are of 2 digits and year of 4.
	
	//Getting the three tokens (Month, Day, and Year) into three strings.
	lstrDay = lstrDate.substring(0, lintFirstSlashPosition);
	lstrMonth = lstrDate.substring(lintFirstSlashPosition + 1, lintSecondSlashPosition);
	lstrYear = lstrDate.substring(lintSecondSlashPosition + 1, lstrDate.length);
	
	//Converting the strings into integers.
	lintMonth = parseInt(lstrMonth ,10);
	lintDay = parseInt(lstrDay,10);
	lintYear = parseInt(lstrYear,10);
	
	//Checking if Month, Day and Year are valid integers.
	if ((isNaN(lintMonth)) || (isNaN(lintDay)) || (isNaN(lintYear))) 
	{
		alert (astrFieldName + " should be valid date in DD/MM/YYYY format");
		mainform.datevalue.select();
		mainform.datevalue.value=todayDate;
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		mainform.datevalue.select();
		mainform.datevalue.value=todayDate;
		return false;
	}
	
	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		mainform.datevalue.select();
		mainform.datevalue.value=todayDate;
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			mainform.datevalue.select();
			mainform.datevalue.value=todayDate;
			return false;
		}
		//Is the year is a leap year?
		if ((lintYear % 400) == 0)
		{
			lblnLeapYear = true;
		}
		else if ((lintYear % 100) == 0)
			{
				lblnLeapYear = false;
			}
			else if ((lintYear % 4) == 0)
				{
					lblnLeapYear = true;
				}
			else
				{
					lblnLeapYear = false;
				}
		//Check for Day validity for February.
		if ((lintMonth == 2) && (((lblnLeapYear == false) && (lintDay > 28)) || ((lblnLeapYear == true) && (lintDay > 29))))
		{
			alert (astrFieldName + " should be valid date")
			mainform.datevalue.select();
			mainform.datevalue.value=todayDate;
			return false;
		}	
		

	}
/*	lintMonth = parseInt(lstrMonth ,10);
	lintDay = parseInt(lstrDay,10);
	lintYear = parseInt(lstrYear,10);
today_date=new Date();
var dd=today_date.getDate();
intial_date=new Date("April 01,2004,00:00:00");
final_date=new Date("March 31,2005,00:00:00");
*/	

var current = Date.UTC(lintYear,lintMonth-1,lintDay,00,00,00);

//Start CVD010909 - hardcoded date
var last =Date.UTC(2025,02,31,00,00,00);
var intial =Date.UTC(2006,03,01,00,00,00);
//Eng CVD010909

//alert("current="+current);
//alert("last="+last);
//alert("intial="+intial);

var return_flag = true;
if((current>=intial)&&(current<=last))
	{return_flag=true;}
else{
alert("Date should be between 01/04/2006 and 31/03/2025");
astrDate.select();
astrDate.value=todayDate;
	return_flag=false;
}	
	return return_flag;
}//fnCheckDate

function ValidDate(udate,fdate)
{
	
var userdate=udate;
var finstartdate=fdate;
var lintFirstSlashPosition1 = userdate.indexOf("/", 0);
var	lintSecondSlashPosition1 = userdate.indexOf("/", lintFirstSlashPosition1 + 1);


var lstrDay = userdate.substring(0, lintFirstSlashPosition1);
var	lstrMonth = userdate.substring(lintFirstSlashPosition1 + 1, lintSecondSlashPosition1);
var	lstrYear = userdate.substring(lintSecondSlashPosition1 + 1, userdate.length);

var lintMonth = parseInt(lstrMonth ,10);
var	lintDay = parseInt(lstrDay,10);
var	lintYear = parseInt(lstrYear,10);


var lintFirstSlashPosition2 = finstartdate.indexOf("/", 0);
var	lintSecondSlashPosition2 = finstartdate.indexOf("/", lintFirstSlashPosition2 + 1);


var lstrDay11 = finstartdate.substring(0, lintFirstSlashPosition2);
var	lstrMonth11 = finstartdate.substring(lintFirstSlashPosition2 + 1, lintSecondSlashPosition2);
var	lstrYear11 = finstartdate.substring(lintSecondSlashPosition2 + 1, finstartdate.length);

var lintMonth11 = parseInt(lstrMonth11 ,10);
var	lintDay11 = parseInt(lstrDay11,10);
var	lintYear11 = parseInt(lstrYear11,10);

var current = Date.UTC(lintYear,lintMonth-1,lintDay,00,00,00);

var checkDate =Date.UTC(lintYear11,lintMonth11-1,lintDay11,00,00,00);

if((current<checkDate))
{
alert("Please Select Proper Date");
return false;
}
else{
return true;
}
}

function disableHotKeys()
{	
	if(event.keyCode > 111 && event.keyCode < 124)
		{
		event.keyCode = 0;
		}
	window.status = event.keyCode;
	return false;
}
//document.onkeydown = disableHotKeys;

function validate(name)
{
//alert("Hello");
if(name.value =="") 
{ alert("Please Enter Number"); 
name.value="0"+name.value ;
name.select();
name.focus();}
if(isNaN(name.value)) 
{ alert("Please Enter Number Properly"); name.select(); name.focus();}
if(name.value.charAt(0) == ".") 
{ name.value="0"+name.value+""; }
var val=name.value;
 temp= new String(val);
 var l=temp.length;
var ti=temp.indexOf(".") ;
ti=ti +4;
if(l > ti){ alert("Please Enter Number Properly Should not exceed 3 Decimals"); name.select();}


}// validate


function validate(name ,d)
{
//	alert(name.value);

if(name.value =="")
	
{ alert("Please Enter Number "); 
name.value="0"+name.value ;
name.focus();}
if(name.value<0) { alert("Value could not be Negative "); name.value="0"; name.select(); }
if(isNaN(name.value)) 
{ alert("Please Enter Number Properly"); name.focus();}
if(name.value.charAt(0) == ".") 
{ name.value="0"+name.value+""; }
var val=name.value;
 temp= new String(val);
 var l=temp.length;
var ti=temp.indexOf(".") ;
if(ti>0)
	{
ti=ti + d + 1 ;
if(l > ti){ alert("Please Enter Number Properly Should not exceed "+d+" Decimals");
name.select();
name.focus();
}
	}
}// validate

function onSubmitValidate(name,datex)
	{
	if(name.value =="") 
	{ 
	alert("Please Enter All Fields Properly");
	return false;
	} 
	else
	{
		if (fnCheckDate(datex.value,"Date"))
		{return true;}
	else
		{return false;}
  	}
}//onSubmitValidate


function onSubmitValidateOne(name)
	{
	if(name.value =="") 
	{ 
	alert("Please Enter All Fields Properly");
	return false;
	} 
	else
	{
		return true;
  	}

	}//onSubmitValidateOne