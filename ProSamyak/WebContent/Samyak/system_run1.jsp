<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="C" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<% 
/*************************************************
This System Run  is for  Diamond ,Jewellery ,Mix category add in table 
To run this file 
1.find a veriable "old_receive_no" and 
2.Set it to first Receive no in table 
3.Run FILE
*/
try{
String user_id= ""+session.getValue("user_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
String company_id= ""+session.getValue("company_id");

ResultSet rs_g= null;
Connection conp = null;
Connection conc = null;
PreparedStatement pstmt_p=null;
PreparedStatement pstmt_c=null;
try	{
	conp=C.getConnection();
	conc=C.getConnection();
}
catch(Exception e31){ 
	out.println("<font color=red> FileName : BankTransaction.jsp<br>Bug No e31 : "+ e31);}
	String query="";
 java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
 
String company_name= A.getName(conp,"companyparty",company_id);
String local_currency= I.getLocalCurrency(conp,company_id);
int  d= Integer.parseInt(A.getName(conp,"Master_Currency", "Decimal_Places","Currency_id",local_currency));

String command=request.getParameter("command");
out.print(command);
String message=""+request.getParameter("message"); 

if("Default".equals(message))
{}
else{out.println("<br><center><font class='submit1'> "+message+"</font></center><br>");}


if("Default".equals(command))
{
out.print("Inside");
	boolean Di=false;
	boolean Jw=false;
	String old_receive_no="OP-1";
	String new_receive_no="";
	String category="";
	String updatequery="";
	int receive_id=0;
  query="select r.receive_id,receive_no , LotCategory_Id from receive r,receive_transaction rt ,lot l where r.receive_id=rt.receive_id and rt.lot_id=l.lot_id and r.opening_stock=0 order by r.receive_id";

pstmt_p = conp.prepareStatement(query);
rs_g = pstmt_p.executeQuery();

while(rs_g.next()) 	
{

 	receive_id=Integer.parseInt(rs_g.getString("receive_id"));
	out.print("-"+receive_id);
 	new_receive_no=rs_g.getString("receive_no");
 	//out.print("<br>new_receive_no"+new_receive_no+ "<-is equal->"+old_receive_no);
	category=rs_g.getString("LotCategory_Id");
	
//out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;category"+category);

			if(new_receive_no.equals(old_receive_no))
			{
			//out.print("Inside Equal");


				if("1".equals(category))
				{
				Di=true;
				}
				if("2".equals(category))
				{
				Jw=true;
				}
				

			}//end if
			else
			{
				if( (Di==true )&& (Jw==true))
				{
				//out.print("<br>Update Receive as MIX");
updatequery="update receive set Receive_Category=0 where receive_id= "+(receive_id-1);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();
				


				Di=false;Jw=false;
				}
				else
				{
						if( (Di==true ))
						{
					//	out.print("<br>Update Receive as Diamond");

updatequery="update receive set Receive_Category=1 where receive_id= "+(receive_id-1);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();

						Di=false;Jw=false;
						}
					
						if((Jw==true))
						{
						//out.print("<br>Update Receive as Jewelary");
updatequery="update receive set Receive_Category=2 where receive_id= "+(receive_id-1);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();
						Di=false;Jw=false;
						}
			    
				
				conc.commit();
				}
					//--------------------
			
							if("1".equals(category))
				{
				Di=true;
				}
				if("2".equals(category))
				{
				Jw=true;
				}
					//--------------
			
			
			}//end else new_receive_no is not equls old_receive_no
			
			
			
			
			
			
			//out.print("<br>Di "+Di + "<---->Jw"+Jw );
			









old_receive_no=new_receive_no;
 }//end while
//--------------------------------------------------------------------

					//----For Last Row Only  

				if( (Di==true )&& (Jw==true))
				{
				out.print("<br>Update Receive as MIX");
updatequery="update receive set Receive_Category=0 where receive_id= "+(receive_id);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();
				


				Di=false;Jw=false;
				}
				else
				{
						if( (Di==true ))
						{
						out.print("<br>Update Receive as Diamond");

updatequery="update receive set Receive_Category=1 where receive_id= "+(receive_id);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();

						Di=false;Jw=false;
						}
					
						if((Jw==true))
						{
						out.print("<br>Update Receive as Jewelary");
updatequery="update receive set Receive_Category=2 where receive_id= "+(receive_id);
pstmt_c = conc.prepareStatement(updatequery);
int a691 = pstmt_c.executeUpdate();
pstmt_c.close();
						Di=false;Jw=false;
						}
			    }
					//----//----For Last Row Only end---------------


C.returnConnection(conp);
C.returnConnection(conc);


}//end command=default
 









}
catch(Exception e31){ 
	out.println("<font color=red> FileName : BankTransaction.jsp<br>Bug No e31 : "+ e31);}

%>