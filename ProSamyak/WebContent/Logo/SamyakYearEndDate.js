var errfound = false;

function fnCheckDate(astrDate,astrFieldName,sdate,edate)
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

for (lintCount = 0; lintCount < lstrDate.length; lintCount++)
{
lstrTemp = lstrDate.substring(lintCount, lintCount + 1);
if (lstrValidCharacters.indexOf(lstrTemp) == -1) 
{
			alert (astrFieldName + " should be valid date in DD/MM/YYYY format");
			mainform.datevalue.select();
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}

	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
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
		return false;
	}

	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		mainform.datevalue.select();
		return false;
	}

	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		mainform.datevalue.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			mainform.datevalue.select();
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
			return false;
		}	
		
	
	}

// start of startdate

var lstrDate1 = sdate				//Local variable containing the argument
var lstrYear1 = "";					//Contains string representation of year
var lstrMonth1 = "";					//Contains string representation of month
var lstrDay1 = "";					//Contains string representation of day
var lintYear1;						//Contains integer representation of year
var lintMonth1;						//Contains integer representation of month
var lintDay1;						//Contains integer representation of day
var lstrValidCharacters1 = "0123456789/";	//Contains valid character that can (should) be there in the date string
var lintCount1;						//Temporary variable for counting etc.
var lintSlashCount1 = 0;				//COntains the no. of slashs('/') in the date string
var lstrTemp1 = "";					//Temporary variable that contains single characters if the date string
var lintFirstSlashPosition1;			//Contains the position of first occurance of '/' in date string
var lintSecondSlashPosition1;		//Contains the position of second occurance of '/' in date string
//Check for valid characters.
for (lintCount1 = 0; lintCount1 < lstrDate1.length; lintCount1++)
{
lstrTemp1 = lstrDate1.substring(lintCount1, lintCount1 + 1);
if (lstrValidCharacters1.indexOf(lstrTemp1) == -1) 
{
			alert (sdate+ " should be valid date in DD/MM/YYYY format");
			mainform.datevalue.select();
			return false;
		}
		if (lstrTemp1 == "/") lintSlashCount1++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount1 != 2) 
	{
		alert (sdate + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition1 = lstrDate1.indexOf("/", 0);
	lintSecondSlashPosition1 = lstrDate1.indexOf("/", lintFirstSlashPosition1 + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition1 != 2) || (lintSecondSlashPosition1 != 5) || (lstrDate1.length != 10))
	{
		alert (sdate + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}
	//Above two checks also ensure that the day and month are of 2 digits and year of 4.
	
	//Getting the three tokens (Month, Day, and Year) into three strings.
	lstrDay1 = lstrDate1.substring(0, lintFirstSlashPosition1);
	lstrMonth1 = lstrDate1.substring(lintFirstSlashPosition1 + 1, lintSecondSlashPosition1);
	lstrYear1 = lstrDate1.substring(lintSecondSlashPosition1 + 1, lstrDate1.length);
	//alert(lstrYear1);
	//Converting the strings into integers.
	lintMonth1 = parseInt(lstrMonth1 ,10);
	lintDay1 = parseInt(lstrDay1,10);
	lintYear1 = parseInt(lstrYear1,10);

	//Checking if Month, Day and Year are valid integers.
	if ((isNaN(lintMonth1)) || (isNaN(lintDay1)) || (isNaN(lintYear1))) 
	{
		alert (sdate + " should be valid date in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth1 < 1) || (lintMonth1 > 12)) 
	{
		alert (sdate + " should be valid date");
		mainform.datevalue.select();
		return false;
	}
	
	//Check for Day validity
	if ((lintDay1 < 1) || (lintDay1 > 31))
	{	
		alert (sdate + " should be valid date");
		mainform.datevalue.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay1 > 30) && ((lintMonth1 == 4) || (lintMonth1 == 6) || (lintMonth1 == 9) || (lintMonth1 == 11)))
		{
			alert (sdate + " should be valid date");
			mainform.datevalue.select();
			return false;
		}
		//Is the year is a leap year?
		if ((lintYear1 % 400) == 0)
		{
			lblnLeapYear1 = true;
		}
		else if ((lintYear1 % 100) == 0)
			{
				lblnLeapYear1 = false;
			}
			else if ((lintYear1 % 4) == 0)
				{
					lblnLeapYear1 = true;
				}
			else
				{
					lblnLeapYear1 = false;
				}
		//Check for Day validity for February.
		if ((lintMonth1 == 2) && (((lblnLeapYear1 == false) && (lintDay1 > 28)) || ((lblnLeapYear1 == true) && (lintDay1 > 29))))
		{
			alert (sdate + " should be valid date")
			mainform.datevalue.select();
			return false;
			
		}
	}
//end of start date
//start of enddate

var lstrDate2 = edate				//Local variable containing the argument
var lstrYear2 = "";					//Contains string representation of year
var lstrMonth2 = "";					//Contains string representation of month
var lstrDay2 = "";					//Contains string representation of day
var lintYear2;						//Contains integer representation of year
var lintMonth2;						//Contains integer representation of month
var lintDay2;						//Contains integer representation of day
var lstrValidCharacters2 = "0123456789/";	//Contains valid character that can (should) be there in the date string
var lintCount2;						//Temporary variable for counting etc.
var lintSlashCount2 = 0;				//COntains the no. of slashs('/') in the date string
var lstrTemp2 = "";					//Temporary variable that contains single characters if the date string
var lintFirstSlashPosition2;			//Contains the position of first occurance of '/' in date string
var lintSecondSlashPosition2;		//Contains the position of second occurance of '/' in date string
//Check for valid characters.
for (lintCount2 = 0; lintCount2 < lstrDate2.length; lintCount2++)
{
lstrTemp2 = lstrDate2.substring(lintCount2, lintCount2 + 1);
if (lstrValidCharacters2.indexOf(lstrTemp2) == -1) 
{
			alert (edate+ " should be valid date in DD/MM/YYYY format");
			mainform.datevalue.select();
			return false;
		}
		if (lstrTemp2 == "/") lintSlashCount2++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount2 != 2) 
	{
		alert (edate + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition2 = lstrDate2.indexOf("/", 0);
	lintSecondSlashPosition2 = lstrDate2.indexOf("/", lintFirstSlashPosition2 + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition2 != 2) || (lintSecondSlashPosition2 != 5) || (lstrDate1.length != 10))
	{
		alert (edate + " should be in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}
	//Above two checks also ensure that the day and month are of 2 digits and year of 4.
	
	//Getting the three tokens (Month, Day, and Year) into three strings.
	lstrDay2 = lstrDate2.substring(0, lintFirstSlashPosition2);
	lstrMonth2 = lstrDate2.substring(lintFirstSlashPosition2 + 1, lintSecondSlashPosition2);
	lstrYear2 = lstrDate2.substring(lintSecondSlashPosition2 + 1, lstrDate2.length);
	
	//Converting the strings into integers.
	lintMonth2 = parseInt(lstrMonth2 ,10);
	lintDay2 = parseInt(lstrDay2,10);
	lintYear2 = parseInt(lstrYear2,10);
//	alert(	lintYear2);
	//Checking if Month, Day and Year are valid integers.
	if ((isNaN(lintMonth2)) || (isNaN(lintDay2)) || (isNaN(lintYear2))) 
	{
		alert (edate + " should be valid date in DD/MM/YYYY format");
		mainform.datevalue.select();
		return false;
	}

	//Check for Month validity
	if ((lintMonth2 < 1) || (lintMonth2 > 12)) 
	{
		alert (edate + " should be valid date");
		mainform.datevalue.select();
		return false;
	}

	//Check for Day validity
	if ((lintDay2 < 1) || (lintDay2 > 31))
	{	
		alert (edate + " should be valid date");
		mainform.datevalue.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay2 > 30) && ((lintMonth2 == 4) || (lintMonth2 == 6) || (lintMonth1 == 9) || (lintMonth1 == 11)))
		{
			alert (edate + " should be valid date");
			mainform.datevalue.select();
			return false;
		}
		//Is the year is a leap year?
		if ((lintYear2 % 400) == 0)
		{
			lblnLeapYear2 = true;
		}
		else if ((lintYear2 % 100) == 0)
			{
				lblnLeapYear2 = false;
			}
			else if ((lintYear2 % 4) == 0)
				{
					lblnLeapYear2 = true;
				}
			else
				{
					lblnLeapYear2 = false;
				}

		//Check for Day validity for February.
		if ((lintMonth2 == 2) && (((lblnLeapYear2 == false) && (lintDay2 > 28)) || ((lblnLeapYear2 == true) && (lintDay2 > 29))))
		{
			alert (edate + " should be valid date")
			mainform.datevalue.select();
			//return false;
			
		}
	}	
//end of enddate



var current = Date.UTC(lintYear,lintMonth-1,lintDay,00,00,00);
var last =Date.UTC(lintYear2,lintMonth2-1,lintDay2,00,00,00);
var first =Date.UTC(lintYear1,lintMonth1-1,lintDay1,00,00,00);

var return_flag = true;
if((current>=first)&&(current<=last))
	{return_flag=true;}
else{
alert("Date should be between"+sdate+" and "+edate);
//astrDate.select();
	return_flag=false;
}	
	
	return return_flag;
}
// fncheckdate









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
name.focus();
return false;}
if(name.value<0) { alert("Value could not be Negative "); name.value="0"; name.select(); return false;}
if(isNaN(name.value)) 
{ alert("Please Enter Number Properly"); name.focus(); return false;}
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
return false;
}
	}
return true;
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










