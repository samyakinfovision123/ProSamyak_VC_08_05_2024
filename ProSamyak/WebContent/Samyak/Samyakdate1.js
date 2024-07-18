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
for (lintCount = 0; lintCount < lstrDate.length; lintCount++)
{
lstrTemp = lstrDate.substring(lintCount, lintCount + 1);
if (lstrValidCharacters.indexOf(lstrTemp) == -1) 
{
			alert (astrFieldName + " should be valid date in DD/MM/YYYY format");
			DefaultForm.consignment_date.select();
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		DefaultForm.consignment_date.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition = lstrDate.indexOf("/", 0);
	lintSecondSlashPosition = lstrDate.indexOf("/", lintFirstSlashPosition + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition != 2) || (lintSecondSlashPosition != 5) || (lstrDate.length != 10))
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		DefaultForm.consignment_date.select();
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
		DefaultForm.consignment_date.select();
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		DefaultForm.consignment_date.select();
		return false;
	}
	
	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		DefaultForm.consignment_date.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			DefaultForm.consignment_date.select();
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
			DefaultForm.consignment_date.select();
			return false;
		}			
	}	
	return true;
}//fnCheckDate

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
if(name.value =="") 
{ alert("Please Enter Number "); 
name.value="0"+name.value ;
name.focus();}
if(isNaN(name.value)) 
{ alert("Please Enter Number Properly"); name.select();}
if(name.value.charAt(0) == ".") 
{ name.value="0"+name.value+"0"; }
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










