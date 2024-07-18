<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean id="A"   class="NipponBean.Array" />
<jsp:useBean id="C"  scope="application"  scope="application"   class="NipponBean.Connect" />
<jsp:useBean id="I"   class="NipponBean.Inventory" />
<jsp:useBean id="F"   class="NipponBean.Finance" />
<jsp:useBean id="S"   class="NipponBean.Stock" />
<jsp:useBean id="G"   class="NipponBean.GetDate" />

<% 

ResultSet rs_g= null;
Connection cong = null;
PreparedStatement pstmt_g=null;
/*try	{cong=C.getConnection();
}
catch(Exception Samyak31){ 
	out.println("<font color=red> FileName : TrailBalance2.jsp<br>Bug No Samyak31 : "+ Samyak31);}*/

try{
int current_id=0; 
int total_rows=0;

cong=C.getConnection();
//String query="Select * from Receive where Receive_quantity=0 and Company_id=1 and Receive_fromid not like 1 and Receive_sell=0 and Purchase=1 and Active=1 and Return=0";

String query="Select * from Master_CompanyParty ";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
int counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter is="+counter);
pstmt_g.close();

String c_id[]= new String[counter];
String name[]= new String[26];
 name[0]="A";
 name[1]="B";
 name[2]="C";
 name[3]="D";
 name[4]="E";
 name[5]="F";
 name[6]="G";
 name[7]="H";
 name[8]="I";
 name[9]="J";
 name[10]="K";
 name[11]="L";
 name[12]="M";
 name[13]="N";
 name[14]="O";
 name[15]="P";
 name[16]="Q";
 name[17]="R";
 name[18]="S";
 name[19]="T";
 name[20]="U";
 name[21]="V";
 name[22]="W";
 name[23]="X";
 name[24]="Y";
 name[25]="Z";


int i=0;
int j=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
c_id[i]=rs_g.getString("CompanyParty_id");

i=i+1;
}//while
pstmt_g.close();

for(i=0; i<counter; i++)
	{
query="Update Master_CompanyParty set CompanyParty_name=? where  CompanyParty_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,name[j]+ "BC Corp Ltd " +c_id[i]); 
pstmt_g.setString(2,c_id[i]); 
//int a308 = pstmt_g.executeUpdate();
pstmt_g.close();

/*query="Update Ledger set Ledger_Name=? where for_head=14 and for_HeadID=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,name[j]+"BC Corp Ltd"+c_id[i]); 
pstmt_g.setString(2,c_id[i]); 
int a308 = pstmt_g.executeUpdate();
pstmt_g.close();
*/
j++;
if(j>= 26)
		{j=j-26;}
	}
//out.println("<br>761245counter"+counter);





 query="Select * from Ledger ";
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
 counter=0;
while(rs_g.next()) 	
{
counter++;
}
out.println("counter is="+counter);
pstmt_g.close();

String l_id[]= new String[counter];

 i=0;
pstmt_g = cong.prepareStatement(query);
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
l_id[i]=rs_g.getString("Ledger_id");

i=i+1;
}//while
pstmt_g.close();

for(i=0; i<counter; i++)
	{
query="Update Ledger set Ledger_name=? where  Ledger_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,name[j]+" Test Ledger "+l_id[i]); 
pstmt_g.setString(2,l_id[i]); 
//int a308 = pstmt_g.executeUpdate();
pstmt_g.close();

j++;
if(j>25)
		{j=j-26;}
	}




C.returnConnection(cong);
}catch(Exception Samyak160){ 
	out.println("<br><font color=red> FileName : SamyakCheck.jsp<br>Bug No Samyak160 : "+ Samyak160);}
%>











