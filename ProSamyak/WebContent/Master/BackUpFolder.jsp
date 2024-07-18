<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean   id="L" class="NipponBean.login" />
<jsp:useBean   id="A" class="NipponBean.Array" />
<jsp:useBean   id="C"  scope="application" class="NipponBean.Connect" />
<jsp:useBean   id="I" class="NipponBean.Inventory" />
<% 
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String command=request.getParameter("command");
//out.print("<br>command=" +command);
try{
if("Go".equals(command))
{
String prevPath=request.getParameter("prevPath");

File myFile = new File(prevPath);
String folders[] = myFile.list();
File subFolders[] = myFile.listFiles();
%>
<html><head><title>Samyak Software</title>
<META HTTP-EQUIV="Expires" CONTENT="0">
<script language="JavaScript">
function disrtclick()
{
//window.event.returnValue=0;
}

function setPath(val)
{
	var newPath = "<%=prevPath%>"  + val+ "/";
	window.parent.mainform.path.value = newPath;
}
function openSubFolder(val)
{
	document.mainform.action="BackUpFolder.jsp";
	document.mainform.prevPath.value="<%=prevPath%>" + val + "/";
	document.mainform.submit();
}

</script></head>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>

<body  onContextMenu="disrtclick()"  bgcolor=white link=black alink=black vlink=black>
<form name=mainform method=post>
<table border=0 cellspacing=0 width='100%' height='36'>
<tr>
	<td>
	<font color='black'><%=prevPath%><hr size=1 color=#000000>
	</td>
</tr>
<tr>
<td align=left>
<%
if(subFolders == null)
{
	out.print("<font color=red>Disk not present</font>");
}
else
{
	for(int i=0; i<folders.length; i++)
	{
		if(subFolders[i].isDirectory())
		{
		%>
		
			<a href="javascript:setPath('<%=subFolders[i].getName()%>')" style="text-decoration:none" onclick='this.style.backgroundColor="#3366FF";this.style.color="#FFFFFF";' ondeactivate='this.style.backgroundColor="#FFFFFF";this.style.color="#000000";'
			ondblclick="openSubFolder('<%=subFolders[i].getName()%>');";
			>
			<div width="100%">
			<img src="../Buttons/foldericon.png" width="16" height="16" border="0" alt="">		
			<%=subFolders[i].getName()%>
			</div>
			</a>
				
		<%		
		}
	}
}
%>
</td>
</tr>
<%
}
%>
</table>
<input type="hidden" name="command" value="Go">
<input type="hidden" name="prevPath" value="">
</form>
<%
}catch(Exception e){out.print("<BR>EXCEPTION=" +e);}
	%>
</BODY>
</HTML>






