<!-- 
use of systemrun for the Updation of UserAuthority Table where
Menu punched twice.

append to the url in the browser 
Samyak/SystemRunMenu_07-06-2006.jsp?command=SamyakMenu



-->



<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*"%>
<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />
<%
	Connection conp=null;
	Connection cong=null;
	String Query1="";
	String errLine="20";
	try {

		String command=request.getParameter("command");

		if(command.equals("SamyakMenu"))
		{
	
		errLine="28";
		conp=C.getConnection();
		cong=C.getConnection();
		PreparedStatement pstmt_p=null;
		PreparedStatement pstmt_g=null;
		PreparedStatement pstmt_r=null;

		ResultSet rs_p=null;
		ResultSet rs_g=null;
		ResultSet rs_r=null;


		out.print("<br>System Run Started for Menu Updation");
		String query="";
		errLine="39";
		query="select count(*) as No_Of_User from Master_User";
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		int count=0;
		int tempCount=0;
		while(rs_g.next())
		{
		count=rs_g.getInt("No_Of_User");
		}
		//out.print("<br>48 count="+count);
		pstmt_g.close();
		errLine="50";
		int User_Id[]=new int[count];
		int q=0;
		query="select User_Id from Master_User";
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		//out.print("<br>56 query="+query);
		while(rs_g.next())
		{
		User_Id[q]=rs_g.getInt("User_Id");
		
		//out.print("<br>60 User_Id"+q+"= "+User_Id[q]);
		q=q+1;
		}
		pstmt_g.close();


		String tempUserId="";
		query="select User_Id from Master_User where user_Name Like '%Samyak1406%'";
		pstmt_g=cong.prepareStatement(query);
		rs_g=pstmt_g.executeQuery();
		//out.print("<br>56 query="+query);
		while(rs_g.next())
		{
		tempUserId=rs_g.getString("User_Id");
		
		//out.print("<br>60 User_Id"+q+"= "+User_Id[q]);
		}
		pstmt_g.close();

		//out.print("<br> tempUserId"+tempUserId);
		int t=0;
		//out.print("<br>67 count="+count);
		for(t=0;t<count;t++)
		{
			//out.print("<br>70 t="+t);
			query="select count(Menu_No) as counter,Menu_No,UserId from UserAuthority where UserId="+User_Id[t]+" group by Menu_no,UserId order by count(Menu_No) desc";
			errLine="42";

			pstmt_g=cong.prepareStatement(query);
			rs_g=pstmt_g.executeQuery();
			//out.print("<br>76 query="+query);
			int r=0;
			int counter=0;
			int U_Id=0;
			String Menu_No="";
			while(rs_g.next())
			{
				counter=rs_g.getInt("counter");
				//out.print("<br>100 counter="+counter);
				Menu_No=rs_g.getString("Menu_no");
				//out.print(" : Menu_No="+Menu_No);
				U_Id=rs_g.getInt("UserId");
				//out.print(" : User_id"+U_Id);
				errLine="52";

				tempCount=counter;
				if (counter>1)
				{
					int UserId=0;
					int ID=0;
					//out.print("<br>59 Sameer here="+counter);
					int i=0;
					//for (i=0;i<counter-1;i++)
					//{
					query="select ID,UserId from UserAuthority where Menu_No='"+Menu_No+"' and UserId="+U_Id+" ";

					pstmt_p=cong.prepareStatement(query);
					rs_p=pstmt_p.executeQuery();
					//out.print("<br>98 query="+query);
					int rp=0;
					while(rs_p.next())
					{
						//out.print("<br> rp"+rp);

						ID=rs_p.getInt("ID");
						UserId=rs_p.getInt("UserId");
						
						//out.print("<br>129 tempcounter="+tempCount);
					
						if(tempCount>1)
						{
							//out.print("<br>71 ID="+ID);
							//out.print("<br>134 counter="+counter);
							Query1="Update UserAuthority set UserId='"+tempUserId+"', Modified_By=1 where ID="+ID+" and UserId="+UserId+" ";
							errLine="72";
							pstmt_r=conp.prepareStatement(Query1);
							//out.print("<br>138 query="+Query1);
							int a=pstmt_r.executeUpdate();
							//out.print("<br>140 result is="+a);
							//pstmt_p.close();
							
							tempCount--;
						 }//end if(tempCount>1)
						 rp++;
					 }//while end here
					 pstmt_p.close();
				
				  }//end if (counter>1)
		
				//out.print("<br> while loop"+r);
				r++;

			}//'while' rs_g ends here
			pstmt_g.close();
			errLine="87";
		}//'for' ends here
	}// 'if' ends here.

	out.print("<br>System Run Completed for Menu Updation  successfully");	
		C.returnConnection(conp);
		C.returnConnection(cong);
		
	}//try
	catch(Exception e)
	{
		C.returnConnection(conp);
		C.returnConnection(cong);
		out.println("<br>Error at "+errLine+"in SystemRunMenu_07-06-2006.jsp is "+e);
	}
%>