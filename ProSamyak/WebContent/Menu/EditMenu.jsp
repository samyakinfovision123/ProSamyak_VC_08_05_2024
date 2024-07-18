<%@ page language = "java" import = "java.sql.*,java.io.*, java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,NipponBean.*" %>
<jsp:useBean id="ConnectDB" scope='application' class="NipponBean.Connect" />
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="L" class="NipponBean.login" />
<jsp:useBean id="AM" class="NipponBean.NipponMethod" />
<jsp:useBean id="format" class="NipponBean.format" />

<%


Connection con1 = null;    //connection for first level
Connection con2 = null;	   //connection for second level
Connection con3 = null;	   //connection for third level
Connection con4 = null;    //connection for forth level
Connection conDelete = null;    //connection for forth level

con1 =ConnectDB.getConnection();
con2 =ConnectDB.getConnection();
con3 =ConnectDB.getConnection();
con4 =ConnectDB.getConnection();
conDelete =ConnectDB.getConnection();

PreparedStatement pstmt4 = null;
PreparedStatement pstmt3 = null;
PreparedStatement pstmt1 = null;
PreparedStatement pstmt2 = null;
PreparedStatement pstmtDelete = null;

ResultSet rs1 = null;
ResultSet rs4 = null;
ResultSet rs3 = null;
ResultSet rs2 = null;
Connection conIns = null;    //connection for first level
conIns =ConnectDB.getConnection();
PreparedStatement pstmtIns = null;

try
{
int j=0;
int k=0;
int m=0;
int n=0;
int i = 0 ;

int [] MenuID = new int[1000];
int [] ParentID = new int[1000];
String [] MenuName=new String[1000];
Boolean [] Child = new Boolean[1000];
int [] MenuID1 = new int[50];
Boolean [] Child1 = new Boolean[500];
int [] MenuID2 = new int[500];
Boolean [] Child2 = new Boolean[500];
int [] MenuID3 = new int[500];
Boolean [] Child3 = new Boolean[500];
int [] PosID = new int[1000];
int [] PosIDS = new int[1000];
int [] UserIDS = new int[1000];
boolean flag =false;

String command=request.getParameter("command");
int UserId = 0;//Integer.parseInt(request.getParameter("UserID"));
int EntityID = Integer.parseInt(request.getParameter("EntityID"));
//out.print("UserID"+UserId);
  int p=0;
	//	SELECTS ALL ROWS IN DATABASE AND STORE IT IN DIFFERENT ARRAYS
if(command.equals("default"))
	{
	String sql = "select MId, MName, ParentID, Child from MenuMaster where EID="+EntityID+" Order by ParentID,SrNo";
	pstmt1 = con1.prepareStatement(sql);
	rs1= pstmt1.executeQuery();
	//out.println("<center><h2> Menu</h2></center>");
	
		while(rs1.next())
		{
		MenuID[i] = rs1.getInt("MId");     
		MenuName[i]=rs1.getString("MName");
		ParentID[i]=rs1.getInt("ParentID");
		Child[i] =rs1.getBoolean("Child");
		i++;				//first level counter
		}
		pstmt1.close();
	sql = "select count(*)as counter from MenuMaster where ParentID = -1 and EID="+EntityID+""; 
	pstmt1 = con1.prepareStatement(sql);
	rs1= pstmt1.executeQuery();
	int cnt = 0;
		while(rs1.next())
		{
			cnt = rs1.getInt("counter");
		}
		pstmt1.close();
	//out.println("counter"+cnt);
%>
<html>
<head>

<script language="JavaScript">
<!--
function tb(str)
{
window.open(str,"_blank", ["Top=50","Left=70","Toolbar=no", "Location=0","Menubar=yes","Height=500","Width=900", "Resizable=yes","Scrollbars=yes","status=no"])
}
//-->
</script>

<link href="../Samyak/Samyakcss.css" rel="stylesheet" type="text/css">
<link href="../Samyak/tablecss.css" rel="stylesheet" type="text/css">
</head>

<body class=bgimage onload = "" bgcolor=#ffFFee background="../Buttons/BGCOLOR.JPG">
<%
String entity[]=new String[4];
entity[0]="";
entity[1]="Global";
entity[2]="India";
entity[3]="Overseas";
	
%>
	<table align=center id=table21 width="70%">
	<% if (EntityID==2){%>
	<tr><th colspan=6> Global Menu </th></tr>
	<%}%>
	<% if (EntityID==3)
	{%>
	<tr><th colspan=6> India Menu </th></tr>
	<%}%>
	<% if (EntityID==4)
	{%>
	<tr><th colspan=6> Overseas Menu </th></tr>
	<%}%>
	
<tr>
	<th>Sr No</th>
	<th>Menu</th>
	<th>Sub- Menu(L1) </th>
	<th>Sub- Menu(L2) </th>
	<th>Sub- Menu(L3) </th>
<!-- 	<th>Sub- Menu(L4) </th>
 -->	<%

	//	FOR EACH  MENU CHECK ITS CHILD(FIRST LEVEL)
int u=1;
int v=1;
int w=1;
int x=1;
	for(j=0;j<cnt;j++)
		{
		if(Child[j]== true)
			{%> 
		
		
		<tr><td align="right" ><%=u++%>&nbsp;</td>
			<td ><a href="javascript:tb(' EditRow.jsp?command=Default&MenuId=<%=MenuID[j]%>&EntityID=<%=EntityID%>')" ><%=MenuName[j]%></a></td>
			<td >&nbsp;&nbsp;</td>
			<td >&nbsp;&nbsp;</td>
			<td >&nbsp;&nbsp;</td>
		
<%
	
// IF CHILD PROPERTY TRUE THEN SEARCH ALL CHILDS(SECOND LEVEL)

		String Query = "select MId, Child, MName from MenuMaster where ParentID = "+MenuID[j]+" order by SrNo";
					//second level counter
		pstmt2 = con2.prepareStatement(Query);
	    rs2= pstmt2.executeQuery();
	//	int [] MenuID1 = new int[50];
	//	Boolean [] Child1 = new Boolean[50];
		k=0;
		v=1;
		while(rs2.next())
		{
			MenuID1[k] = rs2.getInt("MId");
			Child1 [k] = rs2.getBoolean("Child");
%>
		<tr>	
			<td  align = "right"><%=(u-1)+"."+(v++)%>&nbsp;&nbsp;</td>
				<td align="center" >&nbsp;</td>
			<td ><a href="javascript:tb(' EditRow.jsp?command=Default&MenuId=<%=MenuID1[k]%>&EntityID=<%=EntityID%>')"> <%=rs2.getString("MName")%></a></td>
				<td >&nbsp;&nbsp;</td>
				<td >&nbsp;&nbsp;</td>
		</tr>
					
	<%
		//FOR EACH SUCH CHILD CHECK HIS FOLLOWER CHILD(THIRD LEVEL)

		if(Child1[k] == true)
			{
				//third level counter
				//int [] MenuID2 = new int[50];
				//Boolean [] Child2 = new Boolean[50];
		
				Query = "select MId, Child, MName  from MenuMaster where ParentID = "+MenuID1[k]+" order by SrNo";
				pstmt3 = con3.prepareStatement(Query);
				rs3= pstmt3.executeQuery();
				String temp;
				  m=0;
				  w=1;
				while(rs3.next())
				{
					MenuID2[m] = rs3.getInt("MId");
					Child2 [m] =rs3.getBoolean("Child");
					//out.println(MennuID2[m]);
					temp= rs3.getString("MName");
%>
					<tr>
						<td  align="right" ><%=(u-1)+"."+(v-1)+"."+(w++)%>&nbsp;&nbsp; </td>
						<td align="center" >&nbsp;</td>
						<td align="center" >&nbsp;</td>
			<td ><a href="javascript:tb(' EditRow.jsp?command=Default&MenuId=<%=MenuID2[m]%>&EntityID=<%=EntityID%>')"><%=temp%></a></td>
						<td >&nbsp;&nbsp;</td>
					</tr>
	
						
<%			// AND HIS NEXT CHILD(FORTH LEVEL)
				if(Child2[m]==true)
					{
						//fourth level counter
						//int [] MenuID3 = new int[50];
						//Boolean [] Child3 = new Boolean[50];
						Query = "select MId, Child, MName from MenuMaster where ParentID = "+MenuID2[m]+" order by SrNo";
						pstmt4 = con4.prepareStatement(Query);
						rs4 = pstmt4.executeQuery();
						 n=0;
						 x=1;
						while(rs4.next())
						{
							MenuID3[n] = rs4.getInt("MId");
							Child3 [n] = rs4.getBoolean("Child");
%>						<tr>
						
						<td  align="right" >
						<%=(u-1)+"."+(v-1)+"."+(w-1)+"."+(x++)%></td>
						<td >&nbsp;&nbsp;<td>
						<td align="center" >&nbsp;</td>
			<td ><a href="javascript:tb(' EditRow.jsp?command=Default&MenuId=<%=MenuID3[n]%>&EntityID=<%=EntityID%>')" > <%=rs4.getString("MName")%></a></td>
						</tr>
<%						n++;
						}	 
						pstmt4.close();

					}

				m++;}//end while
				
				pstmt3.close();
		}//end if
		k++;
	}//end While
	
	pstmt2.close();%>
		
	
	<br>

	<%}//end if
	else
	{
		break;
	}
}//end for
%>
	</table>
 <%
/*out.println("J="+j);
out.println("K="+k);
out.println("M="+m);
out.println("N="+n);*/
  %>
<%
  //set the counters for each level

  String sql1 = "select count(*) as counter from MenuMaster ";
int counter=0;
	pstmt2 = con2.prepareStatement(sql1);
	rs2 = pstmt2.executeQuery();
while(rs2.next())
{
	counter = rs2.getInt("counter") +12;
}

int [] MID = new int[counter];
int [] PID = new int[counter];
Boolean [] Childcnt = new Boolean[counter];
 sql = "select * from MenuMaster order by Sequence, SrNo  ";
	 //out.print("sql" +sql);
	pstmt1 = con1.prepareStatement(sql);
	rs1= pstmt1.executeQuery();
	//out.println("<center><h2> Menu</h2></center>");
		int cnti=0;
		while(rs1.next())
		{
		MID[cnti] = rs1.getInt("MId");     
		PID[cnti]=rs1.getInt("ParentID");
		Childcnt[cnti] = rs1.getBoolean("Child");
		cnti++;
		//first level counter
		}
	//	out.print("I...."+cnti);
		pstmt1.close();
	 
 int MENULOOP1 =j; // from array to be taken
int current_counter1=0;
int counterFirst=0;
int counterSecond=0;
int counterThird=0;
int counterForth=0;
int [] FirstCnt = new int[counter];   //
int [] SecondCnt = new int[counter];
int [] ThirdCnt = new int[counter];
int [] ForthCnt = new int[counter];
int s=0;int r=0;int q=0;int p1 =0;
int flag1 =0;int flag2 =0;int flag3 =0;int flag4 =0;
for(int menuloop=1; menuloop <= MENULOOP1; menuloop++)
	{
	   
		int cnt_menu_id = MID[current_counter1];
		current_counter1++;
		//out.print("Current Counter  "+current_counter1);//shows current counter

		while(PID[current_counter1] == cnt_menu_id)  //checks the current variable 
 
		{	
			//out.print("<br> Inside while 1 ");
			int cnt_menu_id_L1 = MID[current_counter1];
			current_counter1++;
				
			while(PID[current_counter1] == cnt_menu_id_L1)
				{
			//	out.print("<br> Inside while 2 ");
				int cnt_menu_id_L2 = MID[current_counter1];
				current_counter1++;
					
				while(PID[current_counter1] == cnt_menu_id_L2)
					{
						//out.print("<br> Inside while 3 ");
						int cnt_menu_id_L3 = MID[current_counter1];
						current_counter1++;
					//  out.print("<br>Here120<br>");
					  //out.print("<br> current_counter1.."+current_counter1);
						counterForth++;                           
						//P1++;
						flag1 = 1;
					}	// while 3
						if(flag1==1)
						{
							p1=p1+1;
							flag1=0;
							ForthCnt[p1]=counterForth;
							counterForth=0;		
						}
								
					 	
					counterThird++;
				//N1++;
				
				flag2=1;
				}	// while 2
				if(flag2==1)
				{	
					//out.print("Third Counter------"+counterThird);
					q=q+1;
					//out.print("<br>Position q"+q);
					ThirdCnt[q]=counterThird;
					flag2=0;
				}
				counterThird=0;
					
		counterSecond++;
		//M1++;		
			
			flag3=1;
		}
			if(flag3==1)
			{
				r=r+1;
				flag3=0;
			 SecondCnt[r]=counterSecond++;
			 //out.print("<br>counterSecond./../../...."+counterSecond);
			  counterSecond =0;
			}
			
		
		
	counterFirst++;
	//L1++;
//out.print("<br>before line 166 after for loop");
flag4=1;
	}

	//out.print("<br>line 170 after for loop");


		if(flag4==1)
		{
			s=s+1;
			flag4=0;
			FirstCnt[s]= counterFirst;
	 	counterFirst =0;
		}
		
/*out.print("<br>177 p"+p1);
out.print("<br>q"+q);
out.print("<br>r"+r);
out.print("<br>s"+s);*/

for(int j1=0;j1<=p1;j1++)
{	//  out.print("<br>Position"+j1);
//	out.print("<br>Forth Cnt===="+ForthCnt[j1]);
}
//out.print("<br> 182 for(int j=0;j<=p;j++)");

for(int j1=0;j1<=q;j1++)
{	//out.print("<br>Position"+j1);
	//out.print("<br>Third Cnt===="+ThirdCnt[j1]);
}
//out.print("<br>");

for(int j1=0;j1<=r;j1++)
{	// out.print("<br>Position"+j1);
	//out.print("<br>second Cnt===="+SecondCnt[j1]);
}
//out.print("<br>");
 for(int j1=0;j1<=s;j1++)
{	// out.print("<br>Position"+j1);
	//out.print("<br>First Cnt===="+FirstCnt[j1]);
}

%>

  <script>	
	  
  function isExist(fieldName)
{
	   var counter=document.theForm.length;
        
        for(var i=0;i<counter;i++)
	    { 
			if(document.theForm.elements[i].name==fieldName)
			{
	    			 	return true;		
			}

		} 
        return false;
}
  	 function CheckIfChecked()
		{	
	<%	
		for(int j1=0;j1<j;j1++)
		{
		%>
			 
		   if(document.theForm.check<%=j1%>.checked == true)
			{	
			<%	int kk=1;
				for(int k1=0;k1<SecondCnt[kk];k1++)
				{
					%>
					if(isExist(check<%=j1%><%=k1%>))
					{
					document.theForm.check<%=j1%><%=k1%>.disabled =false;
					
					}
				<%	kk++;
					}%>
			}
		 <%}%>
		}
		
		
  
 </script> 	 

	<table>
		<!-- <tr>
		<td colspan = 4 width="100" height="19" align="center">
		<input type="submit" name="command" value="Next">
		</td></tr>  -->
		
	</table>
		<input type="hidden" name = "counter" value = "">
		
		<input type ="hidden"name ="posValue" value ="">
		<input type ="hidden"name ="UserID" value ="<%=UserId%>">
		<input type ="hidden"name ="EntityID" value ="<%=EntityID%>">


		
<%		
	ConnectDB.returnConnection(conDelete);
	ConnectDB.returnConnection(con1);
	ConnectDB.returnConnection(con2);
	ConnectDB.returnConnection(con3);
	ConnectDB.returnConnection(con4);
	ConnectDB.returnConnection(conIns);	
	}
		
		
	%>

</form>	
</center>
	</body>
	</html>
<%
	
}
catch(Exception e)
{
	ConnectDB.returnConnection(conDelete);
	ConnectDB.returnConnection(con1);
	ConnectDB.returnConnection(con2);
	ConnectDB.returnConnection(con3);
	ConnectDB.returnConnection(con4);
	ConnectDB.returnConnection(conIns);
	
	out.println(e);
}
//-------------------------------------------------------------------------------
%>	
