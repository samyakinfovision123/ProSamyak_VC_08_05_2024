<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="C"  scope="application"    class="NipponBean.Connect" />
<jsp:useBean id="A"   class="NipponBean.Array"/>
<jsp:useBean id="L"   class="NipponBean.login" />
<jsp:useBean   id="G" class="NipponBean.GetDate" />
<jsp:useBean   id="FD" class="NipponBean.format" />

<% 
String user_id= ""+session.getValue("user_id");
String company_id= ""+session.getValue("company_id");
String yearend_id= ""+session.getValue("yearend_id");
String user_level= ""+session.getValue("user_level");
String machine_name=request.getRemoteHost();
java.sql.Date today_date = new java.sql.Date(System.currentTimeMillis());
java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

String command  = request.getParameter("command");

	ResultSet rs_g= null;
	ResultSet rs_p= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;
	





///////////
if("Update".equals(command))


{
	//out.print("<br>540 Welcome to update");
	
	conp=C.getConnection();
    //out.print("<br>540 Welcome to update");
	String eff_id="";


   java.sql.Date Effective_Date_new_check = new java.sql.Date(System.currentTimeMillis());   
   
java.sql.Date Effective_Date_max = new java.sql.Date(System.currentTimeMillis());   
   
	eff_id=request.getParameter("eff_id1");
	String LOT_ID=request.getParameter("lot_iddd_new");
	//out.print("<br>*****634 LOT_ID="+LOT_ID);
	String Lot_new=A.getNameCondition(conp,"Lot","Lot_No"," where Lot_Id="+LOT_ID+" and Company_Id="+company_id);
	String selling_price_hidden="";
	 selling_price_hidden=request.getParameter("selling_price_hidden");
	//out.print("<br>564 selling_price_hidden="+selling_price_hidden);
	
	String purchase_price_hidden=request.getParameter("purchase_price_hidden");
	//out.print("<br>572 purchase_price_hidden="+purchase_price_hidden);
	

	String pp3=request.getParameter("pp31");
	String lot_idd=request.getParameter("Lot");

	String pp4=request.getParameter("pp41");
	//out.print("<br>/////////////lot_idd pp41="+lot_idd);
	
	boolean active_id;
	String pp5=request.getParameter("pp51");
	//out.print("<br>575 pp51="+pp5);
	String id_check="";//request.getParameter("active_new");
	if(request.getParameter("active_new") != null) 
		id_check = request.getParameter("active_new");
	
	
	//out.print("<br>id_check="+id_check);
	if(id_check.equals("yes"))
		{
 active_id=true;

		}

		else{
active_id=false;

		}

	int total_count=0;
	//int int_id=Integer.parseInt(new_lot_id);
	String effective_date1=request.getParameter("eff_date_hidden");
java.sql.Date effective_date1_dateformat= FD.getDate(effective_date1);







//out.print("<br>105 effective_date1==="+effective_date1);






//String check_query="select count(*) Total from Effective_Rate where Effective_Date='"+format.getDate(effective_date1)+"' and Lot_Id="+LOT_ID+" and Active=1 and EffectiveRate_Id="+eff_id;
String check_query="select count(*) Total from Effective_Rate where Effective_Date='"+format.getDate(effective_date1)+"' and Lot_Id="+LOT_ID+" and Active=1 and EffectiveRate_Id<>"+eff_id;
//and EffectiveRate_Id="+eff_id;
//String check_query="select count(*) Total from Effective_Rate where Effective_Date='"+format.getDate(effective_date1)+"' and Lot_Id="+LOT_ID+" and Active=1 and EffectiveRate_Id="+eff_id;


pstmt_p = conp.prepareStatement(check_query);
//pstmt_p.setString(1,new_lot_id); 
rs_p = pstmt_p.executeQuery();
	while(rs_p.next()) 	
	{
total_count=rs_p.getInt("Total");



	}
//out.print("<br>106 main total_count="+total_count);
////

//out.print("<br>108 eff_id="+eff_id);


check_query="select Effective_Date  from Effective_Rate where  Active=1 and Lot_Id="+LOT_ID+" and EffectiveRate_Id="+eff_id;
pstmt_p = conp.prepareStatement(check_query);
//pstmt_p.setString(1,new_lot_id); 
rs_p = pstmt_p.executeQuery();
	while(rs_p.next()) 	
	{
Effective_Date_new_check=rs_p.getDate("Effective_Date");



	}







int diff_pre;










int diff;
//diff=effective_date1_dateformat.compareTo(Effective_Date_new_check);
diff=Effective_Date_new_check.compareTo(effective_date1_dateformat);



if((total_count==1)&& (diff)==0){

//if((total_count==1)&&((diff!=1)||(diff!=-1))){

	//||(total_count==1)){
//out.print("<br>828 ins first if");

	String update_query="Update Effective_Rate set Effective_Date=?,Selling_Price=?,Purchase_Price=?,P3=?,P4=?,P5=?,P6=?,P7=?,P8=?,Modified_On=?, Modified_By=?,Modified_MachineName=?,Active=?,YearEnd_Id=?  where EffectiveRate_Id=?";
	
	pstmt_p = conp.prepareStatement(update_query);
	
	//pstmt_p.setDate (1,lot_no);
	pstmt_p.setString(1,""+format.getDate(effective_date1));
	pstmt_p.setString (2,selling_price_hidden);

	pstmt_p.setString (3,purchase_price_hidden);
	
	pstmt_p.setString (4,pp3);
	pstmt_p.setString(5,pp4);
	pstmt_p.setString(6,pp5);
	pstmt_p.setString(7,"0");
	pstmt_p.setString(8,"0");
	pstmt_p.setString(9,"0");
    
	pstmt_p.setString(10,""+D);
	
	pstmt_p.setString(11,user_id);
	pstmt_p.setString(12,machine_name);
	pstmt_p.setBoolean(13,active_id);
	pstmt_p.setString(14,""+yearend_id);
	pstmt_p.setString(15,""+eff_id);


	
	
	int a = pstmt_p.executeUpdate();
	
	



C.returnConnection(conp);



response.sendRedirect("UpdateEffective_Rate.jsp?command=Go&lotno0="+Lot_new+"&message=Lot_No <font color=blue> "+Lot_new+"  </font> successfully Updated");

}

else{

////
//int diff;
//diff=effective_date1_dateformat.compareTo(Effective_Date_new_check);
//diff=Effective_Date_new_check.compareTo(effective_date1_dat//eformat);
//out.print("<br>243 old date Effective_Date_new_check==>"+Effective_Date_new_check);
//out.print("<br>");
//out.print("<br> 245 new User DAte effective_date1_dateformat==>"+effective_date1_dateformat);

//out.print("<br>247 dif>>>>>>>>>"+diff);
//out.print("<br>247 total_count>>>>>>>>>"+total_count);


if((total_count==0)&&((diff!=1)||(diff!=-1)))
	{
//out.print("<br>889ins second if");
String update_query="Update Effective_Rate set Effective_Date=?,Selling_Price=?,Purchase_Price=?,P3=?,P4=?,P5=?,P6=?,P7=?,P8=?,Modified_On=?, Modified_By=?,Modified_MachineName=?,Active=?,YearEnd_Id=?  where EffectiveRate_Id=?";
	
	pstmt_p = conp.prepareStatement(update_query);
	
	//pstmt_p.setDate (1,lot_no);
	pstmt_p.setString(1,""+format.getDate(effective_date1));
	pstmt_p.setString (2,selling_price_hidden);

	pstmt_p.setString (3,purchase_price_hidden);
	
	pstmt_p.setString (4,pp3);
	pstmt_p.setString(5,pp4);
	pstmt_p.setString(6,pp5);
	pstmt_p.setString(7,"0");
	pstmt_p.setString(8,"0");
	pstmt_p.setString(9,"0");
    
	pstmt_p.setString(10,""+D);
	
	pstmt_p.setString(11,user_id);
	pstmt_p.setString(12,machine_name);
	pstmt_p.setBoolean(13,active_id);
	pstmt_p.setString(14,""+yearend_id);
	pstmt_p.setString(15,""+eff_id);


	
	
	int a = pstmt_p.executeUpdate();
	
	





C.returnConnection(conp);







response.sendRedirect("UpdateEffective_Rate.jsp?command=Go&lotno0="+Lot_new+"&message=Lot_No <font color=blue> "+Lot_new+"  </font> successfully Updated");








    }

////
else{








out.println("<html><head><link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'> </head><body background='../Buttons/BGCOLOR.JPG' ><br><center><font class='message1'><b>This <font color=blue> Date  </font>already exists.</font></b><br><br><input type=button name=command value='BACK'  class='Button1' onClick='history.go(-1)'></center>");
C.returnConnection(conp);
}

} //big else

	
	
	
	//C.returnConnection(conp);
	}














%>








