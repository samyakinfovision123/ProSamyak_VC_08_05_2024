

<!-- 
For Run the System Run:-

 type the url in the browser 
Samyak/Nippon/Samyak/UpdateToByNosSystemRun.jsp?command=Samyak07



-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp"%>

<jsp:useBean id="L" class="NipponBean.login"/>
<jsp:useBean id="A" class="NipponBean.Array"/>
<jsp:useBean id="C" class="NipponBean.Connect"/>

<%
try{
String command=request.getParameter("command");

if(command.equals("Samyak07")){
	
	
	
	ResultSet rs_g= null;

    Connection cong = null;
    Connection conp = null;

    PreparedStatement pstmt_g=null;
    PreparedStatement pstmt_p=null;

    try	{
		cong=C.getConnection();
		conp=C.getConnection();
	     
		 
		 }
	catch(Exception Samyak31)
		{ 
		 out.println("<font color=red> FileName : 	UpdateToByNosSystemRun.jsp<br>Bug No Samyak31 : "+ Samyak31);
		}



		int tempx = 0;
       String update_query="";
       
	   String first_query="";
      
	  first_query="SELECT V.Voucher_Id,V.Voucher_No, ToBy_Nos, Count(FT.Active) AS FTActiveQty FROM Voucher AS V INNER JOIN Financial_Transaction AS FT ON V.Voucher_Id = FT.Voucher_Id WHERE FT.Active=True and  V.Voucher_Type=1 or V.Voucher_Type=2 or V.Voucher_Type=10 or V.Voucher_Type=11 GROUP BY V.voucher_Id, V.Voucher_No, ToBy_Nos order by V.Voucher_No";
	
	  pstmt_g = cong.prepareStatement(first_query);
	
	   rs_g = pstmt_g.executeQuery();
	
	   while(rs_g.next()) 	
	
	  {
		   int voucher_id=rs_g.getInt("Voucher_Id");
		   
		   String voucher_no=rs_g.getString("Voucher_No");
		   
		   String toby_nos=rs_g.getString("ToBy_Nos");
		   int toby_nos_int=Integer.parseInt(toby_nos);
		   //out.print("<br>");
		   String ftactive=rs_g.getString("FTActiveQty");
		   int ftactive_int=Integer.parseInt(ftactive);
     
	   if((toby_nos_int!=(ftactive_int-1))  )
			{
         

			 update_query="Update Voucher set ToBy_Nos="+(ftactive_int-1)+" where Voucher_Id="+voucher_id;

			 pstmt_g = cong.prepareStatement(update_query);
			 tempx = pstmt_g.executeUpdate();
			 out.print("Data Successfully Updated ! ");
		
		    }
	
	 }

		pstmt_g.close();


}

}catch(Exception e)
  {
	out.print("<br>87 The error in file UpdateToByNosSystemRun.jsp"+e);
  }
%>