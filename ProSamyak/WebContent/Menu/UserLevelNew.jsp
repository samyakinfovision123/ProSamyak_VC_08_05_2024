<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

<%
String errLine="9";
String user_id= ""+session.getValue("user_id");
//out.print("<br>10 user_id="+user_id);
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

PreparedStatement pstmt_p = null;
PreparedStatement pstmt_g = null;
PreparedStatement pstmt_q = null;
PreparedStatement pstmt_r = null;
PreparedStatement pstmt_s = null;
PreparedStatement pstmt = null;

ResultSet rs_g = null;
ResultSet rs_p = null;
ResultSet rs_q = null;
ResultSet rs_r = null;
ResultSet rs_s = null;
ResultSet rs = null;

Connection conp = null;    //connection for first level
Connection cong = null;	   //connection for second level
Connection conq = null;	   //connection for third level
Connection conr = null;	   //connection for third level
Connection cons = null;	   //connection for third level
Connection con = null;	   //connection for third level
//out.print("<br>34");
try{
conp =ConnectDB.getConnection();

}
catch(Exception e)
{out.print("<br>Exception="+e);}
//out.print("38");

try
{

String command=request.getParameter("command");
String no=request.getParameter("UserID");
//out.print("<br>49 No->"+no);
int UserId=-1;
if(no!=null)
{
	
 UserId = Integer.parseInt(no);
 //out.print("<br> 55 UserId = "+UserId);
}
//out.print("<BR>UserID"+UserId);
//out.print("EntityID:"+request.getParameter("EntityID"));
int EntityID = Integer.parseInt(request.getParameter("EntityID"));
//out.print("<br>60 EntityID="+EntityID);
  int p=0;

errLine="63";
//	SELECTS ALL ROWS IN DATABASE AND STORE IT IN DIFFERENT ARRAYS
if(command.equals("default"))
{



//out.println("<br>95");
String company_id=A.getNameCondition(conp, "Master_User", "Company_id", "where user_id="+UserId+" and active=1");

String company_code="";
String company_name="";
int ccode=0;
//out.println("<br>company_id="+company_id);
if("-1".equals(company_id))
{
	company_name = "Global";
	ccode=2; //for global
	
}
else
{
	company_code=A.getNameCondition(conp, "Master_CompanyParty","Category_Code","where CompanyParty_Id="+company_id+" ");
	//out.println("<br>100 company_code="+company_code);

	company_name= A.getName(conp,"companyparty",company_id);
	//out.println("<br>73 company_name="+company_name);
	ccode=Integer.parseInt(company_code);
	//out.println("<br>91 ccode="+ccode);
}

errLine="93";
int j=0;
int k=0;
int m=0;
int n=0;
int i = 0 ;
int cnt = 0;
String	sql_count = "select count(*)as counter from MenuMaster where EID="+ccode+" and Active=1" ; 
pstmt_p = conp.prepareStatement(sql_count);
rs_p= pstmt_p.executeQuery();
while(rs_p.next())
{
	cnt = rs_p.getInt("counter");
}
pstmt_p.close();
//out.print("<BR> cnt "+cnt);
int counter=cnt;
%>
<html>
<head>

<!-- SCRIPT CHECKS THE NO OF CHECK BOX AND RETURNS THE MENUID -->

<script language = "javascript">


function findIndexOfField(fieldName)
{
	var frmIndex=0;
	counter=document.forms[frmIndex].length
        
    for(i=0;i<counter;i++)
	{ 
		if(document.forms[frmIndex].elements[i].name==fieldName)
		{
					return i		
		}

	} 
	return -1
}

//out.print("<BR>123 counter "+counter);

function chkall(noc, k)
{
alert("iNSIDE chkall noc=" + noc);
alert("iNSIDE chkall k=" + k);

	var c=0;
for(j=0; j <= noc; j++ )
	{
//alert("iNSIDE Fot");
var n=0;
 n=8 * c;
 var d=0;
 d= 6 *c;
document.forms[0].elements[k+n].checked=true;
var s=findIndexOfField("no_c<%=3%>");
//alert("s="+s);
//var n1=document.forms[0].elements[k+ (6*c)].value;
//alert("n1="+n1);


c=(parseInt(c)+1);

	}
	

	

}//function


function   chk()
		{
<%



for(i=0; i<counter; i++)
{
%>

if(document.mainform.check<%=i%>.checked)
{
var k=findIndexOfField("check<%=i%>");
var noc=document.mainform.no_c<%=i%>.value;
//alert("noc="+noc);
if(noc > 0)
	{
//alert("iNSIDE IF");
	chkall(noc, k);
	}
		
}//if chked
<% }//for
%>

		}//function



</script>

	<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
	<link href='../Samyak/tablecss.css' rel=stylesheet type='text/css'>

</head>

<body class=bgimage onload = "" bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
	<center>
	<form  name = "mainform" method = "post" action = "UserLevelNew.jsp"  >
<table align=center  cellspacing=0 cellpadding=0 width="70%" id=table21>
<tr>
<th colspan=5>User Access For User <%=A.getNameCondition(conp,"Master_User","User_Name", "where user_id="+UserId)%> of  <%=company_name%></th></tr>
<tr>
<th>Main Menu</th>
<th>Menu </th>
<th>Sub Menu (L1)</th>
<th>Sub Menu (L2)</th>
<th>Sub Menu (L3)</th>
</tr>

<%
	cong =ConnectDB.getConnection();
	conq =ConnectDB.getConnection();
	conr =ConnectDB.getConnection();
	cons =ConnectDB.getConnection();
	con =ConnectDB.getConnection();
	//out.print("<br>211 UserId="+UserId);
	i=0;
	String check="";
	
	String sql = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child,Active from MenuMaster where EID="+ccode+" and parentid=-1  Order by Menu_No ,SrNo ";

	pstmt_p = conp.prepareStatement(sql);
	rs_p= pstmt_p.executeQuery();
	i=0;
		while(rs_p.next())
		{
			int m_id=rs_p.getInt("MId");
			check=A.getNameCondition(con, "UserAuthority", "Active", "where UserId="+UserId+" and MId="+m_id+" and Eid="+ccode+" order by modified_on ");
			boolean menuActive = rs_p.getBoolean("Active");

			int p_id=rs_p.getInt("ParentID");
			boolean f1=rs_p.getBoolean("Child");
			int no_c=rs_p.getInt("No_Child");
			//out.print("<BR>224 check 1= "+check);
			//out.print("<BR>224 m_id 1= "+m_id);
if(menuActive)
{
%>



<tr>
<td align=right>
<%if("1".equals(check)){%>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
<%}else{%>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick="" >
<%}%>
	<input type=hidden name=m_id<%=i%> value=<%=m_id%>>
	<input type=hidden name=menu_level<%=i%> value=0>
	</td>  
<td><%=rs_p.getString("MName")%> </td> 

	<input type=hidden name=p_id<%=i%> value=<%=p_id%>>
	<input type=hidden name=Child<%=i%> value=<%=f1%>>
	<td>
		<input type=hidden name=SrNo<%=i%> value=<%=rs_p.getInt("SrNo")%>></td> 
	<td>
		<input type=hidden name=Menu_No<%=i%> value=<%=rs_p.getInt("Menu_No")%>> </td> 
	
	<td><%//=no_c%></td>
	<input type=hidden name=no_c<%=i%> value=<%=no_c%>>

<%
}
else
{
%>
<input type="hidden" name="check<%=i%>" value=no>
<input type=hidden name=m_id<%=i%> value=<%=m_id%>>
<input type=hidden name=menu_level<%=i%> value=0>
<input type=hidden name=p_id<%=i%> value=<%=p_id%>>
<input type=hidden name=Child<%=i%> value=<%=f1%>>
<input type=hidden name=SrNo<%=i%> value=<%=rs_p.getInt("SrNo")%>>
<input type=hidden name=Menu_No<%=i%> value=<%=rs_p.getInt("Menu_No")%>> 
<input type=hidden name=no_c<%=i%> value=<%=no_c%>>


<%
}
	i++;
if(f1)
{


	String sql1 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child, Active from MenuMaster where EID="+ccode+" and  parentid="+m_id+"  Order by Menu_No ,SrNo ";

	pstmt_g = cong.prepareStatement(sql1);
	rs_g= pstmt_g.executeQuery();
	while(rs_g.next())
	{
	   int m_id1=rs_g.getInt("MId");
       String check1=A.getNameCondition(con, "UserAuthority", "Active", "where UserId="+UserId+" and MId="+m_id1+" and Eid="+ccode+" order by modified_on ");
       errLine="280";
	   boolean menuActive1 = rs_g.getBoolean("Active");

	   int p_id1=rs_g.getInt("ParentID");
       boolean f2=rs_g.getBoolean("Child");
	   int no_c1=rs_g.getInt("No_Child");

	   //out.print("309 check1 for userid="+UserId+" m_id1="+m_id1+" and Eid="+ccode+" is = "+check1);
    
if(menuActive1)
{
%>
<tr>
<td>&nbsp;</td>
<td align=right>
<%if("1".equals(check1)){%>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
<%}else{%>
<input type = "checkbox" name ="check<%=i%>" value =yes >
<%}%>

		<%
%>  	<input type=hidden name=m_id<%=i%> value=<%=m_id1%>>
	<input type=hidden name=menu_level<%=i%> value=1>
 </td>  
<td>		<%=rs_g.getString("MName")%></td> 
		
		<input type=hidden name=p_id<%=i%> value=<%=p_id1%>>
<input type=hidden name=Child<%=i%> value=<%=f2%>>

<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_g.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_g.getInt("Menu_No")%>> </td> 

<!-- <td><%//=no_c1%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c1%>>

<%
}
else
{%>
<input type = "hidden" name ="check<%=i%>" value =no >
<input type=hidden name=m_id<%=i%> value=<%=m_id1%>>
<input type=hidden name=menu_level<%=i%> value=1>
<input type=hidden name=p_id<%=i%> value=<%=p_id1%>>
<input type=hidden name=Child<%=i%> value=<%=f2%>>
<input type=hidden name=SrNo<%=i%> value=<%=rs_g.getInt("SrNo")%>>
<input type=hidden name=Menu_No<%=i%> value=<%=rs_g.getInt("Menu_No")%>>
<input type=hidden name=no_c<%=i%> value=<%=no_c1%>>

<%
}
		i++;

if(f2)
{




String sql2 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child, Active from MenuMaster where EID="+ccode+" and  parentid="+m_id1+"  Order by Menu_No ,SrNo ";

	pstmt_q = conq.prepareStatement(sql2);
	rs_q= pstmt_q.executeQuery();
	while(rs_q.next())
	{	
		int m_id2=rs_q.getInt("MId");
		String check2=A.getNameCondition(con, "UserAuthority", "Active", "where UserId="+UserId+" and MId="+m_id2+" and Eid="+ccode+" order by modified_on ");
		boolean menuActive2 = rs_q.getBoolean("Active");

		
		int p_id2=rs_q.getInt("ParentID");
		boolean f3=rs_q.getBoolean("Child");
		int no_c2=rs_q.getInt("No_Child");

if(menuActive2)
{
%>
<tr>
<td colspan=2>&nbsp;</td>
<td align=right>		
<%if("1".equals(check2)){%>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
<%}else{%>
<input type = "checkbox" name ="check<%=i%>" value =yes >
<%}%>
	<%
%>  	<input type=hidden name=m_id<%=i%> value=<%=m_id2%>>
	<input type=hidden name=menu_level<%=i%> value=2>
 </td>  
<td>		<%=rs_q.getString("MName")%></td> 
		
			<input type=hidden name=p_id<%=i%> value=<%=p_id2%>>
<input type=hidden name=Child<%=i%> value=<%=f3%>>

<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_q.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_q.getInt("Menu_No")%>> </td> 


<!-- <td><%//=no_c2%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c2%>>

<%
}
else
{
%>
<input type = "hidden" name ="check<%=i%>" value =no >
<input type=hidden name=m_id<%=i%> value=<%=m_id2%>>
<input type=hidden name=menu_level<%=i%> value=2>
<input type=hidden name=p_id<%=i%> value=<%=p_id2%>>
<input type=hidden name=Child<%=i%> value=<%=f3%>>
<input type=hidden name=SrNo<%=i%> value=<%=rs_q.getInt("SrNo")%>>
<input type=hidden name=Menu_No<%=i%> value=<%=rs_q.getInt("Menu_No")%>>
<input type=hidden name=no_c<%=i%> value=<%=no_c2%>>
<%
}
		i++;

if(f3)
{

errLine="361";
String sql3 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child, Active from MenuMaster where EID="+ccode+" and  parentid="+m_id2+" Order by Menu_No ,SrNo ";

	pstmt_r = conr.prepareStatement(sql3);
	rs_r= pstmt_r.executeQuery();
	while(rs_r.next())
	{
	     int m_id3=rs_r.getInt("MId");
         String check3=A.getNameCondition(con, "UserAuthority", "Active", "where UserId="+UserId+" and MId="+m_id3+" and Eid="+ccode+" order by modified_on ");
		 boolean menuActive3=rs_r.getBoolean("Active");

		 
		int p_id3=rs_r.getInt("ParentID");
		boolean f4=rs_r.getBoolean("Child");
		int no_c3=rs_r.getInt("No_Child");

if(menuActive3)
{
%>
<tr>
<td colspan=3>&nbsp;</td>
<td align=right>		
<%if("1".equals(check3)){%>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
<%}else{%>
<input type = "checkbox" name ="check<%=i%>" value =yes >
<%}%>
	<%
%>   	<input type=hidden name=m_id<%=i%> value=<%=m_id3%>>
	<input type=hidden name=menu_level<%=i%> value=3>
</td>  
<td>		<%=rs_r.getString("MName")%></td> 
		
			<input type=hidden name=p_id<%=i%> value=<%=p_id3%>>
<input type=hidden name=Child<%=i%> value=<%=f4%>>

<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_r.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_r.getInt("Menu_No")%>> </td> 
		

<!-- <td><%//=no_c3%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c3%>>

<%
}
else
{%>
<input type = "hidden" name ="check<%=i%>" value =no >
<input type=hidden name=m_id<%=i%> value=<%=m_id3%>>
<input type=hidden name=menu_level<%=i%> value=3>
<input type=hidden name=p_id<%=i%> value=<%=p_id3%>>
<input type=hidden name=Child<%=i%> value=<%=f4%>>
<input type=hidden name=SrNo<%=i%> value=<%=rs_r.getInt("SrNo")%>>
<input type=hidden name=Menu_No<%=i%> value=<%=rs_r.getInt("Menu_No")%>>
<input type=hidden name=no_c<%=i%> value=<%=no_c3%>>
<%
}
		i++;

if(f4)
{


String sql4 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child, Active from MenuMaster where EID="+ccode+" and  parentid="+m_id3+" Order by Menu_No ,SrNo ";

	pstmt_s = cons.prepareStatement(sql4);
	rs_s= pstmt_s.executeQuery();
	while(rs_s.next())
	{
		int m_id4=rs_s.getInt("MId");
		String check4=A.getNameCondition(con, "UserAuthority", "Active", "where UserId="+UserId+" and MId="+m_id4+" and Eid="+ccode+" order by modified_on");
		boolean menuActive4 = rs_s.getBoolean("Active");

		int p_id4=rs_s.getInt("ParentID");
		boolean f5=rs_s.getBoolean("Child");
		int no_c4=rs_s.getInt("No_Child");

if(menuActive4)
{
%>
<tr>
<td colspan=4>&nbsp;</td>
<td align=right>	
<%if("1".equals(check4)){%>	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
<%}else{%>
<input type = "checkbox" name ="check<%=i%>" value =yes >
<%}%>		<%
%>  	<input type=hidden name=m_id<%=i%> value=<%=m_id4%>>
	<input type=hidden name=menu_level<%=i%> value=4>
 </td>  
<td>		<%=rs_s.getString("MName")%></td> 
		
<input type=hidden name=p_id<%=i%> value=<%=p_id4%>>
<input type=hidden name=Child<%=i%> value=<%=f5%>>
<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_s.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_s.getInt("Menu_No")%>> </td> 
		

<!-- <td><%//=no_c4%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c4%>>

<%
}
else
{%>
<input type = "hidden" name ="check<%=i%>" value =no >
<input type=hidden name=m_id<%=i%> value=<%=m_id4%>>
<input type=hidden name=menu_level<%=i%> value=4>
<input type=hidden name=p_id<%=i%> value=<%=p_id4%>>
<input type=hidden name=Child<%=i%> value=<%=f5%>>
<input type=hidden name=SrNo<%=i%> value=<%=rs_s.getInt("SrNo")%>>
<input type=hidden name=Menu_No<%=i%> value=<%=rs_s.getInt("Menu_No")%>>
<input type=hidden name=no_c<%=i%> value=<%=no_c4%>>
<%
}
		i++;

//if(f5)
//{}//if


		}//while f4

pstmt_s.close();



}//if


		}//while f3

pstmt_r.close();



}//if


		}//while f2

pstmt_q.close();


}//if


		}//while f1

pstmt_g.close();

}//if f1

}//while

pstmt_p.close();

//out.print("<br>counter="+i);


	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(conq);
	ConnectDB.returnConnection(conr);
	ConnectDB.returnConnection(cons);
	ConnectDB.returnConnection(con);
%>
<tr>
<input type=hidden name=UserID value=<%=UserId%>>
<input type=hidden name=EntityID value=<%=ccode%>>
<input type=hidden name=counter value=<%=i%>>

<td colspan=5 align=center>
<input type=submit name=command value='Save' class='button1'  onmouseover="this.className='button1_over';" onmouseout="this.className='button1';"	
> 
	<!-- onclick="return confirm('Are You Sure ?')" -->
	</td>
</tr>
</table>
</form>
</body>
</html>

		

</form>	
</center>
	</body>
	</html>
<%
	}//if command=default
		
		
if("Save".equals(command))
{
	cong =ConnectDB.getConnection();
	int counter=Integer.parseInt(request.getParameter("counter"));
//out.print("<br>523 counter="+counter);

int m_id[]=new int[counter];
int p_id[]=new int[counter];
int SrNo[]=new int[counter];
int Menu_No[]=new int[counter];
int Child_Count[]=new int[counter];
int no_c[]=new int[counter];
String Child[]=new String[counter];
String check[]=new String[counter];
String menu[]=new String[counter];
int menu_level[]=new int[counter];
int mid1[]=new int[10];


errLine="537";
//<input type=hidden name=menu_level value=0>
for(int i=0; i < counter; i++)
{
m_id[i]=Integer.parseInt(request.getParameter("m_id"+i));
//out.print("<br>538 m_id[i]="+m_id[i]);
menu_level[i]= Integer.parseInt(request.getParameter("menu_level"+i));
p_id[i]=Integer.parseInt(request.getParameter("p_id"+i));
SrNo[i]=Integer.parseInt(request.getParameter("SrNo"+i));
//out.print("<br>542 SrNo[i]="+SrNo[i]);
Menu_No[i]=Integer.parseInt(request.getParameter("Menu_No"+i));
//out.print("<br>544 Menu_No[i]="+Menu_No[i]);
no_c[i]=Integer.parseInt(request.getParameter("no_c"+i));
//out.print("<br>546 no_c[i]="+no_c[i]);
Child[i]=(request.getParameter("Child"+i));
check[i]=(request.getParameter("check"+i));
//System.out.println("<br>554 check[i]="+check[i]);
/*if(p_id[i]==-1)
	{menu[i]=""+f; 
mid1[f]=m_id[i];
f++;
}*/
Child_Count[i]=0;
}//for

int f=1;
int s=1;
int t=1;
int fr=1;
int fcount=f;
//menu[0]="Menu1";


for(int i=0; i < counter; i++)
{
	int c=0;
	for(int j=i; j<counter; j++)
	{
		if(("yes".equals(check[i]))&&("yes".equals(check[j])))
		{
			if(m_id[i]==p_id[j])
			{c++;}
		}//if
	}//for j
	Child_Count[i]=c;
}//for i

//out.print("<br>580 check[j]="+check[j]);
//out.print("<br>596");

for(int i=0; i < counter; i++)
{
	if("yes".equals(check[i]))
	{
		if(menu_level[i]==0)
		{
			menu[i]="Menu"+f;
			f++;
			s=1;
			t=1;
			fr=1;
		}

		if(menu_level[i]==1)
		{
			menu[i]="Menu"+(f-1)+"_"+s;
			s++;
			t=1;
			fr=1;
		}

		if(menu_level[i]==2)
		{
			menu[i]="Menu"+(f-1)+"_"+(s-1)+"_"+t;
			t++;
			fr=1;
		}

		if(menu_level[i]==3)
		{
			menu[i]="Menu"+(f-1)+"_"+(s-1)+"_"+(t-1)+"_"+fr;
			fr++;
		}
	}// if checked
	

	//out.print("<br>636 menu["+i+"] = "+menu[i]);
}//for
//out.print("<br>627 counter="+counter);
int finalcount=counter;

//System.out.println("<br>629 finalcount="+finalcount);


String Query = "select count(*) as COUNTER from UserAuthority where UserID="+UserId+" ";
int ua_cnt = 0;
pstmt_g = cong.prepareStatement(Query);
rs_g = pstmt_g.executeQuery();
//System.out.println("636 Query="+Query);
while(rs_g.next())
{
	ua_cnt  = rs_g.getInt("COUNTER");
	//out.print("<br> 651 ua_cnt="+ua_cnt);
}
pstmt_g.close();

//System.out.println("<br>644 ua_cnt="+ua_cnt);
if(ua_cnt==0)
{
	int UserAuthority_id=L.get_master_id(conp,"UserAuthority");
	String sql = "Insert into UserAuthority (ID, UserID, MId, Eid, Modified_By ,Modified_On,Menu_No,Child_Count, Active) values(?,?,?,?, ?,?,?,?, ?);";	
	int z=0; //to change the Menu_no fields
	for(int i=0; i < counter; i++)
	{

		if("yes".equals(check[i]))
		{
				pstmt_p= conp.prepareStatement(sql);
				pstmt_p.setString(1,""+UserAuthority_id);
				pstmt_p.setString(2,""+UserId);
				pstmt_p.setString(3,""+m_id[i]);
				pstmt_p.setString(4,""+EntityID);
				pstmt_p.setString(5,""+1); //for Admin
				pstmt_p.setString(6,""+D);
				pstmt_p.setString(7,""+menu[z++]);
				pstmt_p.setString(8,""+Child_Count[i]);
				pstmt_p.setString(9,""+1);
				int a=pstmt_p.executeUpdate();
				pstmt_p.close();
	//			out.println("<br>a="+a);
				UserAuthority_id++;

		}//if(check[i])
	}//for
	//out.print("<br>627counter="+counter);
}//if ua_cnt==0
else
{

	String ua_id[]=new String[ua_cnt];
	Query = "select ID from UserAuthority where UserID="+UserId+" ";
	int ut= 0;
	pstmt_p = conp.prepareStatement(Query);
	rs_p = pstmt_p.executeQuery();
	while(rs_p.next())
	{
		ua_id[ut]  = rs_p.getString("ID");
		ut++;
	}
	pstmt_p.close();
	//out.println("<br>637 ua_cnt="+ua_cnt);
	//out.println("<br>637 finalcount="+finalcount);
	
	String sql = "";	

		//out.println("<br>644 finalcount="+finalcount);
		//out.println("<br>U_A count="+ua_cnt);
		
errLine="694";
		for(int i=0; i < ua_cnt; i++)
		{
			//out.println("<br>ua_id[i]="+ua_id[i]);
			//out.println("<br>ua_id[i]="+m_id[i]);
			//out.println("<br>ua_id[i]="+menu[i]);
			//out.println("<br>ua_id[i]="+Child_Count[i]);
			if("yes".equals(check[i]))
			{
				sql = "Update  UserAuthority set  UserID=?, MId=?, Eid=?, Modified_By =? ,Modified_On =?,Menu_No =?, Child_Count=?, Active=? where ID=?";	

				pstmt_p= conp.prepareStatement(sql);
				
				pstmt_p.setString(1,""+UserId);
				//out.print("<br>i="+i+" 708 UserId"+UserId);
				pstmt_p.setString(2,""+m_id[i]);
				//out.print(" m_id[i]"+m_id[i]);
				pstmt_p.setString(3,""+EntityID);
			//out.print(" EntityID"+EntityID);
				pstmt_p.setString(4,""+1); //for admin
			//out.print("<br> 708 UserId"+UserId);
				pstmt_p.setString(5,""+D);
			//out.print("<br> 708 UserId"+UserId);
				pstmt_p.setString(6,""+menu[i]);
			//out.print(" menu[i]"+menu[i]);
				pstmt_p.setString(7,""+Child_Count[i]);
			//out.print(" 708 Child_Count[i]"+Child_Count[i]);
				pstmt_p.setString(8,""+1);
				pstmt_p.setString(9,""+ua_id[i]);
			//out.print("723 ua_id[i]"+ua_id[i]);

				errLine="716";
				int a=pstmt_p.executeUpdate();
				errLine="718";
				pstmt_p.close();
				//out.println("<br>a="+a);

			}//if(check[i])

			else
			{
				sql = "Update  UserAuthority set  Active=? where ID=?";	
				pstmt_p= conp.prepareStatement(sql);
				pstmt_p.setBoolean(1,false);
				pstmt_p.setString(2,""+ua_id[i]);
				errLine="730";
				int a=pstmt_p.executeUpdate();
				errLine="732";
				pstmt_p.close();

			}
		}//for



	int UserAuthority_id=L.get_master_id(conp,"UserAuthority");
	sql = "Insert into UserAuthority (ID, UserID, MId, Eid, Modified_By ,Modified_On,Menu_No,Child_Count, Active) values(?,?,?,?, ?,?,?,?, ?);";	
	for(int i=ua_cnt; i < counter; i++)
	{
	
			pstmt_p= conp.prepareStatement(sql);
			pstmt_p.setString(1,""+UserAuthority_id);
			pstmt_p.setString(2,""+UserId);
			pstmt_p.setString(3,""+m_id[i]);
			pstmt_p.setString(4,""+EntityID);
			pstmt_p.setString(5,""+1); //for Admin
			pstmt_p.setString(6,""+D);
			pstmt_p.setString(7,""+menu[i]);
			pstmt_p.setString(8,""+Child_Count[i]);
			if("yes".equals(check[i]))
			{
				pstmt_p.setString(9,"1");
			}
			else
			{
				pstmt_p.setString(9,"0");
			}
			errLine="762";
			int a=pstmt_p.executeUpdate();
			errLine="764";
			pstmt_p.close();
			//out.println("<br>a="+a);
			UserAuthority_id++;

		
	}//for


}//else
	conp.commit();
	//out.print("commited");
	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(conq);
	ConnectDB.returnConnection(conr);
	ConnectDB.returnConnection(cons);
	ConnectDB.returnConnection(con);
response.sendRedirect("../Menu/UserAcccessLevels1.jsp?command=default&UserID="+UserId+"&EntityID="+EntityID);
//out.print("<br> 792 Saved Successfully.");
}//if("Save".equals(command))
	
}//try
catch(Exception e)
{	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(conq);
	ConnectDB.returnConnection(conr);
	ConnectDB.returnConnection(cons);
	ConnectDB.returnConnection(con);
	

	out.println("ErrLine at"+errLine+" Exception is "+e);
}
//-------------------------------------------------------------------------------
%>	
