var errfound = false;

function fnCheckMultiDate(astrDate1,astrFieldName)
{
	astrDate=astrDate1.value
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
			astrDate1.select();
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition = lstrDate.indexOf("/", 0);
	lintSecondSlashPosition = lstrDate.indexOf("/", lintFirstSlashPosition + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition != 2) || (lintSecondSlashPosition != 5) || (lstrDate.length != 10))
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
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
		astrDate1.select();
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	
	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			astrDate1.select();
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
			astrDate1.select();
			return false;
		}			
	}	
	
	
	//var return_flag = true;

   
var current = Date.UTC(lintYear,lintMonth-1,lintDay,00,00,00);

var last =Date.UTC(2008,02,31,00,00,00);
var intial =Date.UTC(2005,03,01,00,00,00);

//alert("current="+current);
//alert("last="+last);
//alert("intial="+intial);

var return_flag = true;
if((current>=intial)&&(current<=last))
	{return_flag=true;}
else{
alert("Date should be between 01/04/2005 and 31/03/2007");
astrDate1.select();
	return_flag=false;
}	
	return return_flag;
}//fnCheckDate




function fnCheckMultiDate1(astrDate1,astrFieldName)
{
	astrDate=astrDate1.value
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
			astrDate1.select();
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition = lstrDate.indexOf("/", 0);
	lintSecondSlashPosition = lstrDate.indexOf("/", lintFirstSlashPosition + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition != 2) || (lintSecondSlashPosition != 5) || (lstrDate.length != 10))
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
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
		astrDate1.select();
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	
	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			astrDate1.select();
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
			astrDate1.select();
			return false;
		}			
	}	
	
	
	//var return_flag = true;

   
var current = Date.UTC(lintYear,lintMonth-1,lintDay,00,00,00);

var last =Date.UTC(2005,02,31,00,00,00);
var intial =Date.UTC(2004,03,01,00,00,00);

//alert("current="+current);
//alert("last="+last);
//alert("intial="+intial);

var return_flag = true;
if((current>=intial)&&(current<=last))
	{return_flag=true;}
	
	return return_flag;
}//fnCheckDate



function addDueDays(astrDate1,astrFieldName, dueDateElem, elem)
{
astrDate=astrDate1.value
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
			astrDate1.select();
			return false;
		}
		if (lstrTemp == "/") lintSlashCount++ ;
	}
	
	//Check for slash count and date string length.
	if (lintSlashCount != 2) 
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
		return false;
	}
	
	//Getting the positions of two slashes in the date string.
	lintFirstSlashPosition = lstrDate.indexOf("/", 0);
	lintSecondSlashPosition = lstrDate.indexOf("/", lintFirstSlashPosition + 1);
	
	//Check that the positions of the two slashes ('/') are 2 and 5 only.
	if ((lintFirstSlashPosition != 2) || (lintSecondSlashPosition != 5) || (lstrDate.length != 10))
	{
		alert (astrFieldName + " should be in DD/MM/YYYY format");
		astrDate1.select();
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
		astrDate1.select();
		return false;
	}
	
	//Check for Month validity
	if ((lintMonth < 1) || (lintMonth > 12)) 
	{
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	
	//Check for Day validity
	if ((lintDay < 1) || (lintDay > 31))
	{	
		alert (astrFieldName + " should be valid date");
		astrDate1.select();
		return false;
	}
	else
	{	//Check for Day validity for months with 30 days only.
		if ((lintDay > 30) && ((lintMonth == 4) || (lintMonth == 6) || (lintMonth == 9) || (lintMonth == 11)))
		{
			alert (astrFieldName + " should be valid date");
			astrDate1.select();
			return false;
		}
		//Is the year is a leap year?
		//alert('Hello');
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
			
			alert (astrFieldName + " should be valid date");
			astrDate1.select();
			return false;
		}			
	}	
	
	
	//var return_flag = true;

var isValidDueDays = validate(elem,0);
if(isValidDueDays == false)
	return false;
/*
var calcDate  = parseInt(lintDay) + parseInt(elem.value)+1;
var calculatedDuedate = new Date(lintYear,lintMonth,calcDate,00,00,00);
var calculatedDate = calculatedDuedate.getUTCDate();
var calculatedMonth = calculatedDuedate.getUTCMonth();
*/

var initialDate = new Date(lintYear,lintMonth-1,lintDay);

var initialDate_time = initialDate.getTime();

var timeElapsed = initialDate_time+(parseInt(elem.value) * 1000 * 60 * 60 * 24);

var calculatedDuedate = new Date(timeElapsed);

//alert(calculatedDuedate.toDateString());

var calculatedDate = calculatedDuedate.getDate();
var calculatedMonth = calculatedDuedate.getMonth();
calculatedMonth++;
var calculatedDuedate1=calculatedDuedate.getUTCFullYear();
//calculatedDuedate1++;

if ( calculatedDate ==1 || calculatedDate ==2 || calculatedDate ==3 || calculatedDate ==4 || calculatedDate ==5 || calculatedDate ==6 || calculatedDate ==7 || calculatedDate ==8 || calculatedDate ==9 )
{
	calculatedDate = "0" + calculatedDate;
}

if ( calculatedMonth ==1 || calculatedMonth ==2 || calculatedMonth ==3 || calculatedMonth ==4 || calculatedMonth ==5 || calculatedMonth ==6 || calculatedMonth ==7 || calculatedMonth ==8 || calculatedMonth ==9 )
{
	calculatedMonth = "0" + calculatedMonth;
}
if(calculatedDate=="01" && calculatedMonth=="01")
	{
		calculatedDuedate1++;
	}
var dateStr= calculatedDate+"/"+calculatedMonth+"/"+calculatedDuedate1;

dueDateElem.value = dateStr;

var return_flag = true;
return return_flag;
	
}


function checkDiscount(elem)
{
	var discount = elem.value;

	var candidateValues = discount.split(':');

	for(i=0; i<candidateValues.length; i++)
	{
		var data = candidateValues[i];
		if(isNaN(data))
		{
			alert("Please Enter the discount value properly");
			elem.focus();
			elem.select();
			return false;
		}
	}

}