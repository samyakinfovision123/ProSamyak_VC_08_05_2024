<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<% 

String company_id= ""+session.getValue("company_id");
System.out.print("company_id"+company_id);


//out.print("<br>In Edit Master.jsp ");
String srno = request.getParameter("newname");
//out.print("<br>13 srno="+srno);
String MASTER = request.getParameter("master");
//out.print("<br>15 MASTER="+MASTER);
String id = request.getParameter("id");
//out.print("<br>15 Id= "+id);
ResultSet rs_g= null;
Connection conp = null;
PreparedStatement pstmt_p=null;
try	{conp=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : Cash.jsp<br>Bug No e31 : "+ e31);}



String query="";
%>
<HTML>
<HEAD>
<TITLE>Samyak Software- India </TITLE>

<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<script>
function Validate(name)
{ var flag11=true
	//alert("value");
	if(name.value=="")
	{
		alert("Please insert number");
	flag11=false;
		
	return flag11;
	}

if(isNaN(name.value))
	{
 alert("Plz. insert number");
   name.value.select();
	flag11=false;
		
	return flag11;

	}

}
</script>
</HEAD>

<body background="../Buttons/BGCOLOR.JPG">

<form name=EditMASTER  action="UpdateMaster.jsp" method=post >

<!-- onsubmit="return Validate();" -->
<%
String name1="";
String desc="";
String active="";
String tempCheck="";

if(MASTER.equals("Description"))
{

query="select "+MASTER+"_Name,"+MASTER+"_Desc ,Active from Master_"+MASTER+"  where "+MASTER+"_Id="+id;
//out.print("<br>29 query= "+query);
}
else{


query="select "+MASTER+"_Name,"+MASTER+"_Description ,Active from Master_"+MASTER+"  where "+MASTER+"_Id="+id;

}




pstmt_p = conp.prepareStatement(query);

rs_g = pstmt_p.executeQuery();	
int count=0;
while(rs_g.next())
{	
	name1=rs_g.getString(MASTER+"_Name");
	//out.print("<br>name1"+name1);
	
	
	if(MASTER.equals("Description"))
    {
	
	desc=rs_g.getString(MASTER+"_Desc");

	}
	else{

desc=rs_g.getString(MASTER+"_Description");

	}
	//out.print("<br>desc"+desc);
	active=rs_g.getString("Active");
	//out.print("<br>active"+active);
	
if("1".equals(active))
		{
	//out.print("<br>In If loop");
	tempCheck = " checked " ;}
		
}

%>


<table borderColor=skyblue align=center border=1 cellspacing=0 cellpadding=2>
<tr><td>
<table borderColor=#D9D9D9 border=1 width="100%" cellspacing=0 cellpadding=2 >

<tr bgcolor=skyblue>
<th colspan=4>Edit Master  <%=MASTER %> </th>
</tr>

<tr>
<td>Sr No</td>
<td><input type=text name=sr_no size=6 value='<%=srno%>' Onblur="Validate(this)" >
</tr>

<tr>
<td>Name <font class="star1">*</font></td>
<td colSpan=3><input type=text name=MASTER_name size=25  value="<%=name1%>"></td>
</tr>



<tr>
<td>Description <font class="star1">*</font></td>
<td colSpan=3><INPUT type=text name=MASTER_description size=25  value="<%=desc%>">
<input type=hidden name=sr_no size=6 value='1'>
</td>
</tr>
<tr><td>Active</td> 
<td><input type=checkbox name=active value=yes <%=tempCheck%>></td>

</tr>
<tr>
<td colspan=4 align='center'>
<input type=hidden name=MASTER value=<%=MASTER%>>
<input type=hidden name=MASTER_id value=<%=id%>>
<input type=submit name=command value='Update' class='Button1'>

</td>
</tr>

</table>
</td>
</tr>
</table>
</form>
</body>
</html>











