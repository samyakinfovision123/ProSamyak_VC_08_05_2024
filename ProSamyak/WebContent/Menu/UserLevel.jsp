<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

<%
String user_id= ""+session.getValue("user_id");
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
String today_string= format.format(D);

PreparedStatement pstmt_p = null;
PreparedStatement pstmt_g = null;
PreparedStatement pstmt_q = null;
PreparedStatement pstmt_r = null;
PreparedStatement pstmt_s = null;

ResultSet rs_g = null;
ResultSet rs_p = null;
ResultSet rs_q = null;
ResultSet rs_r = null;
ResultSet rs_s = null;


Connection conp = null;    //connection for first level
Connection cong = null;	   //connection for second level
Connection conq = null;	   //connection for third level
Connection conr = null;	   //connection for third level
Connection cons = null;	   //connection for third level
//out.print("31");
try{
conp =ConnectDB.getConnection();

}
catch(Exception e)
{out.print("<br>Exception="+e);}
//out.print("38");

try
{

String command=request.getParameter("command");
//out.print("<br>command="+command);
String no=request.getParameter("UserID");
//out.print("<br>No->"+no);
int UserId=-1;
if(no!=null)
{
	
 UserId = Integer.parseInt(no);
 //out.print("<br> 49 UserId = "+UserId);
}
//out.print("<BR>53 UserID"+UserId);
//out.print("EntityID:"+request.getParameter("EntityID"));
int EntityID = Integer.parseInt(request.getParameter("EntityID"));
//out.print("<BR>EntityID"+EntityID);
  int p=0;


//	SELECTS ALL ROWS IN DATABASE AND STORE IT IN DIFFERENT ARRAYS
if("default".equals(command))
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
}
//out.println("<br>75 ccode="+ccode);
//ccode=ccode +1;


int j=0;
int k=0;
int m=0;
int n=0;
int i = 0 ;
int cnt = 0;
String	sql_count = "select count(*)as counter from MenuMaster where  EID="+ccode+" and Active=1" ; 
	pstmt_p = conp.prepareStatement(sql_count);
	rs_p= pstmt_p.executeQuery();
		while(rs_p.next())
		{
			cnt = rs_p.getInt("counter");
		}
//out.print("<BR> cnt "+cnt);
pstmt_p.close();
	int counter=cnt;
boolean uaflag[]=new boolean[counter];
int usercount=0;
sql_count = "select count(*)as counter from UserAuthority where  EID="+ccode+" and Active=1 and userId="+UserId+"" ; 
	pstmt_p = conp.prepareStatement(sql_count);
	rs_p= pstmt_p.executeQuery();
		while(rs_p.next())
		{
			usercount = rs_p.getInt("counter");
		}
//out.print("<BR> usercount "+usercount);
pstmt_p.close();

if(usercount > 0)
{
int mid[]=new int[usercount];
sql_count = "select MID from UserAuthority where  EID="+ccode+" and Active=1 and userId="+UserId+"" ; 
	pstmt_p = conp.prepareStatement(sql_count);
	rs_p= pstmt_p.executeQuery();
	i=0;
		while(rs_p.next())
		{
			mid[i] = rs_p.getInt("MID");
			i++;
		}
pstmt_p.close();

int MID[]=new int[counter];

sql_count = "select MID from MenuMaster where  EID="+ccode+" and Active=1 " ; 
	pstmt_p = conp.prepareStatement(sql_count);
	rs_p= pstmt_p.executeQuery();
	i=0;
		while(rs_p.next())
		{
			MID[i] = rs_p.getInt("MID");
			i++;
		}
pstmt_p.close();

	for(i=0; i< counter; i++)
	{
		uaflag[i]=true;
	}


}
else{
	for(i=0; i< counter; i++)
	{uaflag[i]=true;}
}


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


function chkall(noc, k)
{
//alert("iNSIDE chkall noc=" + noc);
//alert("iNSIDE chkall k=" + k);

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
	<form  name = "mainform" method = "post" action = "UserLevel.jsp"  >
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

i=0;

	String sql = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child from MenuMaster where EID="+ccode+" and parentid=-1 and Active=1 Order by Menu_No ,SrNo ";

	pstmt_p = conp.prepareStatement(sql);
	rs_p= pstmt_p.executeQuery();
i=0;
		while(rs_p.next())
		{
%>
<tr>
<td align=right>
	<input type = "checkbox" name ="check<%=i%>" value =yes onClick=""  checked>
	<%
	int m_id=rs_p.getInt("MId");%>  
	<input type=hidden name=m_id<%=i%> value=<%=m_id%>>
	<input type=hidden name=menu_level<%=i%> value=0>
	</td>  
<td>		<%=rs_p.getString("MName")%> 
	</td> 
		<%
		int p_id=rs_p.getInt("ParentID");
		boolean f1=rs_p.getBoolean("Child");%>
<input type=hidden name=p_id<%=i%> value=<%=p_id%>>
<input type=hidden name=Child<%=i%> value=<%=f1%>>
<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_p.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_p.getInt("Menu_No")%>> </td> 
		<%
			int no_c=rs_p.getInt("No_Child");%>

<td><%//=no_c%></td>
<input type=hidden  name=no_c<%=i%> value=<%=no_c%>>

<%
	i++;
if(f1)
{


	String sql1 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child from MenuMaster where EID="+ccode+" and  parentid="+m_id+" and Active=1 Order by Menu_No ,SrNo ";

	pstmt_g = cong.prepareStatement(sql1);
	rs_g= pstmt_g.executeQuery();
		while(rs_g.next())
		{
%>
<tr>
<td>&nbsp;</td>
<td align=right>	<input type = "checkbox" name ="check<%=i%>" value =yes onClick="" checked>		<%
	int m_id1=rs_g.getInt("MId");
%>  	<input type=hidden  name=m_id<%=i%> value=<%=m_id1%>>
	<input type=hidden name=menu_level<%=i%> value=1>
 </td>  
<td>		<%=rs_g.getString("MName")%></td> 
		<%
		int p_id1=rs_g.getInt("ParentID");
		boolean f2=rs_g.getBoolean("Child");%>
		<input type=hidden  name=p_id<%=i%> value=<%=p_id1%>>
<input type=hidden name=Child<%=i%> value=<%=f2%>>

<td>		<input type=hidden  name=SrNo<%=i%> value=<%=rs_g.getInt("SrNo")%>></td> 
<td>	<input type=hidden  name=Menu_No<%=i%> value=<%=rs_g.getInt("Menu_No")%>> </td> 
		<%
			int no_c1=rs_g.getInt("No_Child");%>

<!-- <td><%//=no_c1%></td>
 -->	<input type=hidden  name=no_c<%=i%> value=<%=no_c1%>>

<%
		i++;

if(f2)
{




String sql2 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child from MenuMaster where EID="+ccode+" and  parentid="+m_id1+" and Active=1 Order by Menu_No ,SrNo ";

	pstmt_q = conq.prepareStatement(sql2);
	rs_q= pstmt_q.executeQuery();
		while(rs_q.next())
		{
%>
<tr>
<td colspan=2>&nbsp;</td>
<td align=right>		<input type = "checkbox" name ="check<%=i%>" value =yes onClick="" checked>	<%
	int m_id2=rs_q.getInt("MId");
%>  	<input type=hidden name=m_id<%=i%> value=<%=m_id2%>>
	<input type=hidden name=menu_level<%=i%> value=2>
 </td>  
<td>		<%=rs_q.getString("MName")%></td> 
		<%
		int p_id2=rs_q.getInt("ParentID");
		boolean f3=rs_q.getBoolean("Child");%>
			<input type=hidden name=p_id<%=i%> value=<%=p_id2%>>
<input type=hidden name=Child<%=i%> value=<%=f3%>>

<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_q.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_q.getInt("Menu_No")%>> </td> 
		<%
			int no_c2=rs_q.getInt("No_Child");%>

<!-- <td><%//=no_c2%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c2%>>

<%
		i++;

if(f3)
{


String sql3 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child from MenuMaster where EID="+ccode+" and  parentid="+m_id2+" and Active=1 Order by Menu_No ,SrNo ";

	pstmt_r = conr.prepareStatement(sql3);
	rs_r= pstmt_r.executeQuery();
		while(rs_r.next())
		{
%>
<tr>
<td colspan=3>&nbsp;</td>
<td align=right>		<input type = "checkbox" name ="check<%=i%>" value =yes onClick="" checked>	<%
	int m_id3=rs_r.getInt("MId");
%>   	<input type=hidden name=m_id<%=i%> value=<%=m_id3%>>
	<input type=hidden name=menu_level<%=i%> value=3>
</td>  
<td>		<%=rs_r.getString("MName")%></td> 
		<%
		int p_id3=rs_r.getInt("ParentID");
		boolean f4=rs_r.getBoolean("Child");%>
			<input type=hidden name=p_id<%=i%> value=<%=p_id3%>>
<input type=hidden name=Child<%=i%> value=<%=f4%>>

<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_r.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_r.getInt("Menu_No")%>> </td> 
		<%
			int no_c3=rs_r.getInt("No_Child");%>

<!-- <td><%//=no_c3%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c3%>>

<%
		i++;

if(f4)
{


String sql4 = "select MId, MName, ParentID, Child, SrNo, Menu_No, No_Child from MenuMaster where EID="+ccode+" and  parentid="+m_id3+" and Active=1 Order by Menu_No ,SrNo ";

	pstmt_s = cons.prepareStatement(sql4);
	rs_s= pstmt_s.executeQuery();
		while(rs_s.next())
		{
%>
<tr>
<td colspan=4>&nbsp;</td>
<td align=right>	<input type = "checkbox" name ="check<%=i%>" value =yes onClick="" checked>		<%
	int m_id4=rs_s.getInt("MId");
%>  	<input type=hidden name=m_id<%=i%> value=<%=m_id4%>>
	<input type=hidden name=menu_level<%=i%> value=4>
 </td>  
<td>		<%=rs_s.getString("MName")%></td> 
		<%
		int p_id4=rs_s.getInt("ParentID");
		boolean f5=rs_s.getBoolean("Child");%>
<input type=hidden name=p_id<%=i%> value=<%=p_id4%>>
<input type=hidden name=Child<%=i%> value=<%=f5%>>
<td>		<input type=hidden name=SrNo<%=i%> value=<%=rs_s.getInt("SrNo")%>></td> 
<td>	<input type=hidden name=Menu_No<%=i%> value=<%=rs_s.getInt("Menu_No")%>> </td> 
		<%
			int no_c4=rs_s.getInt("No_Child");%>

<!-- <td><%//=no_c4%></td>
 -->	<input type=hidden name=no_c<%=i%> value=<%=no_c4%>>

<%
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
int counter=Integer.parseInt(request.getParameter("counter"));
//out.print("<br>462counter="+counter);


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



//<input type=hidden name=menu_level value=0>
for(int i=0; i < counter; i++)
{
m_id[i]=Integer.parseInt(request.getParameter("m_id"+i));
menu_level[i]= Integer.parseInt(request.getParameter("menu_level"+i));
p_id[i]=Integer.parseInt(request.getParameter("p_id"+i));
SrNo[i]=Integer.parseInt(request.getParameter("SrNo"+i));
Menu_No[i]=Integer.parseInt(request.getParameter("Menu_No"+i));
no_c[i]=Integer.parseInt(request.getParameter("no_c"+i));
Child[i]=(request.getParameter("Child"+i));
check[i]=(request.getParameter("check"+i));
//out.print("<br>check[i]="+check[i]);
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

//out.print("<br>521counter="+counter);

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

	}//chk
}//for
//out.print("<br>568counter="+counter);
int finalcount=0;
for(int i=0; i < counter; i++)
{
if("yes".equals(check[i]))
{
/*out.print("<br>menu_level[i]="+menu_level[i]);
out.print("&nbsp;&nbsp;&nbsp;menu[i]="+menu[i]);
out.print("&nbsp;&nbsp;&nbsp;child[i]="+Child_Count[i]);*/
finalcount++;
}

}
//out.print("<br>583counter="+counter);
	//out.println("<br>finalcount="+finalcount);


String Query = "select count(*) as counter from UserAuthority where UserID="+UserId+" and Active=1";
int ua_cnt = 0;
pstmt_p = conp.prepareStatement(Query);
rs_p = pstmt_p.executeQuery();
while(rs_p.next())
{
	ua_cnt  = rs_p.getInt("counter");
}
pstmt_p.close();

//out.print("<br> 595 ua_cnt="+ua_cnt);
if(ua_cnt==0)
{
int UserAuthority_id=L.get_master_id(conp,"UserAuthority");
String sql = "Insert into UserAuthority (ID, UserID, MId, Eid, Modified_By ,Modified_On,Menu_No,Child_Count, Active) values(?,?,?,?, ?,?,?,?,?);";	
for(int i=0; i < counter; i++)
{
	if("yes".equals(check[i]))
	{
				pstmt_p= conp.prepareStatement(sql);
				pstmt_p.setString(1,""+UserAuthority_id);
				//out.print("<br>UserAuthority_id="+UserAuthority_id);
				pstmt_p.setString(2,""+UserId);
				//out.print("<br>UserId="+UserId);
				pstmt_p.setString(3,""+m_id[i]);
				//out.print("<br>m_id[i]="+m_id[i]);
				pstmt_p.setString(4,""+EntityID);
				//out.print("<br>EntityID="+EntityID);
				pstmt_p.setString(5,"1"); //for admin
				//out.print("<br>user_id="+user_id);
				pstmt_p.setString(6,""+D);
				//out.print("<br>D="+D);
				pstmt_p.setString(7,""+menu[i]);
				//out.print("<br>menu[i]="+menu[i]);
				pstmt_p.setString(8,""+Child_Count[i]);
				//out.print("<br>Child_Count[i]="+Child_Count[i]);
				pstmt_p.setString(9,"1");
				
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
Query = "select ID from UserAuthority where UserID="+UserId+" and Active=1";
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
if(ua_cnt <  finalcount)
{

String sql = "Update  UserAuthority set  UserID=?, MId=?, Eid=?, Modified_By =? ,Modified_On =?,Menu_No =?, Child_Count=? where ID=?";	

//out.println("<br>644 finalcount="+finalcount);

for(int i=0; i < ua_cnt; i++)
{
	if("yes".equals(check[i]))
	{
				pstmt_p= conp.prepareStatement(sql);
				
				pstmt_p.setString(1,""+UserId);
				//out.print("<br>UserId->"+UserId);
				pstmt_p.setString(2,""+m_id[i]);
				//out.print("<br>m_id[i]->"+m_id[i]);
				pstmt_p.setString(3,""+EntityID);
				//out.print("<br>EntityID->"+EntityID);
				pstmt_p.setString(4,""+1); //for admin
				pstmt_p.setString(5,""+D);
				//out.print("<br>D->"+D);
				pstmt_p.setString(6,""+menu[i]);
				//out.print("<br>menu[i]->"+menu[i]);
				pstmt_p.setString(7,""+Child_Count[i]);
				//out.print("<br>Child_Count[i]->"+Child_Count[i]);
				pstmt_p.setString(8,""+ua_id[i]);
				//out.print("<br>ua_id[i]->"+ua_id[i]);
				int a=pstmt_p.executeUpdate();
				pstmt_p.close();
		//		out.println("<br>a="+a);

	}//if(check[i])

	else
	{
		sql = "Update  UserAuthority set  Active=? where ID=?";	
			pstmt_p= conp.prepareStatement(sql);
			pstmt_p.setBoolean(1,false);
			pstmt_p.setString(2,""+ua_id[i]);
			int a=pstmt_p.executeUpdate();
			pstmt_p.close();

	}

}//for



int UserAuthority_id=L.get_master_id(conp,"UserAuthority");
 sql = "Insert into UserAuthority (ID, UserID, MId, Eid, Modified_By ,Modified_On,Menu_No,Child_Count, Active) values(?,?,?,?, ?,?,?,?,?);";	
for(int i=ua_cnt; i < counter; i++)
{
if("yes".equals(check[i]))
	{
				pstmt_p= conp.prepareStatement(sql);
				pstmt_p.setString(1,""+UserAuthority_id);
				pstmt_p.setString(2,""+UserId);
				pstmt_p.setString(3,""+m_id[i]);
				pstmt_p.setString(4,""+EntityID);
				pstmt_p.setString(5,""+1); //for admin
				pstmt_p.setString(6,""+D);
				pstmt_p.setString(7,""+menu[i]);
				pstmt_p.setString(8,""+Child_Count[i]);
				pstmt_p.setString(9,"1");
				int a=pstmt_p.executeUpdate();
				pstmt_p.close();
		//		out.println("<br>a="+a);
UserAuthority_id++;

	}//if(check[i])
}//for



}//if
else if(ua_cnt > finalcount)
{
	//out.println("<br>if(ua_cnt > finalcount)");
	//out.println("<br>counter="+counter);

String sql = "Update  UserAuthority set  UserID=?, MId=?, Eid=?, Modified_By =? ,Modified_On =?,Menu_No =?, Child_Count=? where ID=?";	
int z=0;
for(int i=0; i < counter; i++)
{
//	while(z < finalcount)
	{
if("yes".equals(check[i]))
	{
				pstmt_p= conp.prepareStatement(sql);
				pstmt_p.setString(1,""+UserId);
				pstmt_p.setString(2,""+m_id[i]);
				pstmt_p.setString(3,""+EntityID);
				pstmt_p.setString(4,""+user_id);
				pstmt_p.setString(5,""+D);
				pstmt_p.setString(6,""+menu[i]);
				pstmt_p.setString(7,""+Child_Count[i]);
				pstmt_p.setString(8,""+ua_id[z]);
				int a=pstmt_p.executeUpdate();
				pstmt_p.close();
			
			//	out.println("<br>aa  i ="+ i);
				z++;
	}//if(check[i])
	}//while
}//for

sql = "Update  UserAuthority set  Active=? where ID=?";	
for(int i=finalcount; i < ua_cnt; i++)
{
			pstmt_p= conp.prepareStatement(sql);
			pstmt_p.setBoolean(1,false);
			pstmt_p.setString(2,""+ua_id[i]);
			int a=pstmt_p.executeUpdate();
			pstmt_p.close();
			//out.println("<br>a="+a);

}//for

	}//else if(ua_cnt > counter)

}//else

	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(conq);
	ConnectDB.returnConnection(conr);
	ConnectDB.returnConnection(cons);
response.sendRedirect("../Menu/UserAcccessLevels.jsp?command=default");
}//if("Save".equals(command))
	
}//try
catch(Exception e)
{	ConnectDB.returnConnection(conp);
	ConnectDB.returnConnection(cong);
	ConnectDB.returnConnection(conq);
	ConnectDB.returnConnection(conr);
	ConnectDB.returnConnection(cons);
	
	
	out.println(e);
}
//-------------------------------------------------------------------------------
%>	
