function validate_title()
{
	if(document.getElementById("title").value=="")
	{
		alert("Enter Assignment Title");
		document.getElementById("title").focus();
		return false;
	}
	return true;
}