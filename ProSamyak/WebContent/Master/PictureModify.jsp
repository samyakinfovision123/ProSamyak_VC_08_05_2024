<%-- 
		Project	     --  Nippon
		File Name    --  PictureModify.jsp
		Modified By  --  Vaibhav Patil
		Description  --  Original File
		Date         --  December 30 2005
--%>

	<!--import packages-->
	<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

	<!--Beans we are using-->
	<jsp:useBean id="C"  scope="application"   class="NipponBean.Connect" />

<% 
	//JDBC.
	ResultSet rs_g= null;
	Connection conp = null;
	PreparedStatement pstmt_p=null;	
	
	//Take Connection.
	try	{
		conp=C.getConnection();
	}catch(Exception ce){	 
		out.println("Error In Connection "+ce);
	}//eo catch.

	//Values from session.
	String company_id= ""+session.getValue("company_id");

	//Get command
	String command = request.getParameter("command");
	
	//Get Root Drive eg. C or D.
	String root=Config.getRoot();
	//String root=Config.getPath();
	//out.print("<br>root="+root);

	try
	{
		//String Variables		
		String filename	= "";
		String name		= "";
		String value	= "";
		String lot_id = "";
		String lotid = "";
		String lot_command = "";
	
		MultipartRequest multi = new MultipartRequest(request,""+root+":\\SamyakSoft\\Tomcat5.0\\webapps\\Root\\Samyak\\Nippon\\Picture",5*1024*1024);
	%>
	<html> 
	<head><title>UploadTest</title>
	</head>	
	<body background="../Buttons/BGCOLOR.JPG">
	<%
	
		Enumeration params = multi.getParameterNames();
		
		while(params.hasMoreElements()){
			 name = (String)params.nextElement();
			 value = multi.getParameter(name);
			 lot_id = value;
			 //out.print("<br > lot_id = "+lot_id);

			 name = (String)params.nextElement();
			 value = multi.getParameter(name);
			 lot_command = value;
			//out.print("<br > lot_command = "+lot_command);
		}//eo while

		//out.println("<h3>Files:</h3>");
		Enumeration files = multi.getFileNames();

		while(files.hasMoreElements()){
			name = (String) files.nextElement();
			filename = multi.getFilesystemName(name);
			String type = multi.getContentType(name);
			File f = multi.getFile(name);
			//out.println("name : "+name);
			//out.println("filename : "+filename);
			//out.println("type: "+type);
			if(f != null){
				
			}//eo if.
		}//eo while
	
		command= "Update";

		String query="Select * from  Lot Where lot_no=?  and company_id="+company_id+" ";
		
		pstmt_p = conp.prepareStatement(query);
		pstmt_p.setString(1,""+lot_id);
		
		rs_g = pstmt_p.executeQuery();
		
		int i=0;
		String dfname="";
		boolean flag=true;
		
		while(rs_g.next()){
			lotid=rs_g.getString("Lot_id");
			dfname=rs_g.getString("Drwg_FileName");
		
			if("None".equals(dfname)){
				flag=false;
			}
			i++;
		}						//eo while
		rs_g.close();			//resultset closed
		pstmt_p.close();		//pstmt closed
		
		if((i>0)&(flag==true)){
			
			if("Update".equals(command)){
			
			   query ="Update Lot  set  Drwg_Filename=?  where Lot_Id=? ";
			   pstmt_p = conp.prepareStatement(query);
			   pstmt_p.setString(1,filename);				
			   pstmt_p.setString(2,lotid);	
	
			   int a = pstmt_p.executeUpdate();
			   pstmt_p.close();
	
			   C.returnConnection(conp);

			   response.sendRedirect("PictureModifyForm.jsp?message=Modified Picture For Lot No <font color=blue> "+lot_id+"</font>");
			}//eo if Update
		}//eo if
		else{
	
			C.returnConnection(conp);

			out.print("<br><center>Lot no "+lot_id+" does not exist or their is no picture Uploaded against it </center>");
			out.print("<br><center><input type=button name=command value=BACK onClick='history.go(-1)' class='button1' ></center>");
		}//eo else.
	}catch (Exception e){
		out.println("<br>Exception "+e);  
	}//eo catch
%>

<%--End Of PictureModify.jsp --%>







