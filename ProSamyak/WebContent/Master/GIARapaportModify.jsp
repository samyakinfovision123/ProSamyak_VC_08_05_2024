<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />

<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");
String command = request.getParameter("command");
String servername=request.getServerName();
//out.print("<br>servername=" +servername);
String root=Config.getRoot();
//out.print("<br>root="+root);

ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try
{ 
	String filename	= "";
	String name		= "";
	String value	= "";
	String Lot_No = "";
	String lotid = "";
	String lot_command = "";
	
	
	try	
	{
		 conp=C.getConnection();
	}
	catch(Exception e11)
	{ 
		out.println("<font color=red> FileName : UpdateSupplier.jsp <br>Bug No e11 :"+ e11 +"</font>");
	}
	
	MultipartRequest multi = new MultipartRequest(request,""+root+":\\SamyakSoft\\Tomcat5.0\\webapps\\Root\\Samyak\\Nippon\\Picture",5*1024*1024);
%>

<html> 
<head>
<title>GIA Rapaport Upload Test</title>
</head>	
<body background="../Buttons/BGCOLOR.JPG">
<!--<h1>UploadTest</h1>
<h3>Params:</h3> 
<pre>-->
<%
	
	Enumeration params = multi.getParameterNames();
	while(params.hasMoreElements())
	{
		name = (String)params.nextElement();
		 value = multi.getParameter(name);
		 Lot_No = value;
		 //out.print("<br > Lot_No = "+Lot_No);

		 name = (String)params.nextElement();
		 value = multi.getParameter(name);
		 lot_command = value;
		 //out.print("<br > lot_command = "+lot_command);

		}
		//out.println("<pre>");
		//out.println("<h3>Files:</h3>");
	Enumeration files = multi.getFileNames();
	while(files.hasMoreElements())
	{
		name = (String) files.nextElement();
		filename = multi.getFilesystemName(name);
		String type = multi.getContentType(name);
		File f = multi.getFile(name);
		//out.println("name : "+name);
		//out.println("filename : "+filename);
		//out.println("type: "+type);
		if(f != null)
		{
			//out.println(" length: "+f.length());
			//out.println();
		}
		//out.println("</pre>");
	}
		//out.print("<br> 83 Company Id"   +company_id);
	
command= "Update";

String query="Select * from  Lot Where lot_no=?  and company_id="+company_id+" ";
pstmt_p = conp.prepareStatement(query);
pstmt_p.setString(1,""+Lot_No);
rs_g = pstmt_p.executeQuery();
int i=0;
String gia_filename="";
boolean flag=true;
while(rs_g.next())
{
	lotid=rs_g.getString("Lot_No");
	//out.print("<br> 97 Lot Id  "+lotid);
	gia_filename=rs_g.getString("GIA_FileName");
	//out.print("<br> GIA filename  "+gia_filename);
	if("None".equals(gia_filename))
	{
		flag=false;
	}
	i++;
}pstmt_p.close();
///out.print("<br>84 i="+i);
if((i>0)&(flag==true))
{
	if("Update".equals(command))
	{
		 query ="Update Lot set GIA_Filename=? where Lot_No=? ";
	     pstmt_p = conp.prepareStatement(query);
         pstmt_p.setString(1,filename);				
		 //out.print("4");
	     pstmt_p.setString(2,Lot_No);	
         //out.print("7");
		 int a = pstmt_p.executeUpdate();
		 pstmt_p.close();
		 //out.print(" Successfully Modified. Please Close this window a "+a);
		 C.returnConnection(conp);
	
	response.sendRedirect("GIARapaportModifyForm.jsp?message=Modified GIA Rapaport For Lot No <font color=blue> "+Lot_No+"</font>");

	}//if Update Close

}
else
{
		C.returnConnection(conp);

		out.print("<br><center>Lot no "+Lot_No+" does not exist or their is no picture Uploaded against it </center>");
		out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
}
//out.print(" command  "+command);	
}
catch (Exception e)
{
	out.println("<br> Exception is "+e);
}
finally
{
	C.returnConnection(conp);
}
%>








