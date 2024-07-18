<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<% 

String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String text="jpg";
String servername=request.getServerName();

try{
//FileReader f = new FileReader("/Master/PictureExtension.txt");
/*File f2=new File("PictureExtension.txt");
out.print("abs Path="+f2.getAbsolutePath());
out.print("<br>Path="+f2.getPath());
out.print("<br>Cannonical Path="+f2.getCanonicalPath());
//FileReader f = new FileReader("D:\\jswdk-1.0.1\\examples\\jsp\\FineStar\\Master\\PictureExtension.txt");
FileReader f = new FileReader("ftp://"+""+servername+""+":8080/examples/jsp/FineStar/Master/PictureExtension.txt\"");
out.print("<br>1");
//FileReader f = new FileReader("PictureExtension.txt");

BufferedReader br = new BufferedReader(f);
 text=br.readLine();
br.close();				*/
}
catch(Exception e11){ 
		out.println("<font color=red> FileName : NewLot.jsp <br>Bug No Samyak11 :"+ e11 +"</font>");}
//out.print("<br>2");
//out.print("<br>text="+text);
String today_string=format.format(D);


String command = request.getParameter("command");
String message=request.getParameter("message"); 
if("Default".equals(message))
{}
else{out.println("<center><font class='submit1'> "+message+"</font></center>");}

String query="";
try{
%>
<html>
<head>
<title> Samyak Software </title>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<SCRIPT language=javascript 
src="../Samyak/Samyakcalendar.js"></SCRIPT>

<script language='javascript'>
var errfound = false;

function LocalValidate()
	{
	errfound = false;
	if(document.NewLot.lot_name.value == "")
		{
		alert("Please enter Lot name.");
		document.NewLot.lot_name.focus();
		return errfound;
		}
			else
				{
				return !errfound;
				}
		
	}





</script>
<SCRIPT language=javascript 
src="../Samyak/Samyakdate.js">
</script>


<script language='javascript'>
var errfound = false;
function LocalValidate()
	{
	errfound = false;
	if(document.f1.lot_name.value == "")
		{
		alert("Please enter Lot name.");
		document.f1.lot_name.focus();
		return errfound;
		}
			else if(isNaN(document.f1.test_amt.value))
				{
				alert("Please enter Quantity & Rate Properly.");
				return false;
				}
			else
				{
				return !errfound;
				}
		
	}

function calcTotal(name)
{
//validate(name)
//alert ("Ok Inside CalcTotal");

if((document.f1.test_amt.value=="0")||(document.f1.test_amt.value=="")){
document.f1.test_amt.value=document.f1.carats.value*document.f1.rate.value;
//alert ("Ok Inside if");

}
if(document.f1.rate.value=="0"){
	document.f1.rate.value=document.f1.test_amt.value  / document.f1.carats.value;}

if(document.f1.test_amt.value != ((document.f1.carats.value)*(document.f1.rate.value)))
{
if(document.f1.test_amt.value > ((document.f1.carats.value)*(document.f1.rate.value)))
{	document.f1.rate.value=document.f1.test_amt.value  / document.f1.carats.value;}

else{
document.f1.test_amt.value=document.f1.carats.value*document.f1.rate.value;}
}//if
}



</script>

</head>









