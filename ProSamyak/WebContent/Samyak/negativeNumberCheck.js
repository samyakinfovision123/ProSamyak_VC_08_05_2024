function checkNegNumber(name ,d)
{
//	alert(name.value);

if(name.value =="")
	
{ 
	alert("Please Enter Number "); 
	name.value="0"+name.value ;
	name.focus();
	return false;
}

if(isNaN(name.value)) 
{ 
	alert("Please Enter Number Properly"); 
	name.focus();
	return false;
}

if(name.value.charAt(0) == ".") 
{ 
	name.value="0"+name.value+""; 
}

var val=name.value;
temp= new String(val);
var l=temp.length;
var ti=temp.indexOf(".") ;
if(ti>0)
{

	ti=ti + d + 1 ;
	if(l > ti)
	{ 
		alert("Please Enter Number Properly Should not exceed "+d+" Decimals");
		name.select();
		name.focus();
		return false;
	}
}

return true;
}