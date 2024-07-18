<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>
<%
//System.out.print("Inside Samyak Session");
//out.println("Inside Samyak Session");
session.putValue("user_id","");
session.putValue("company_id","");
session.putValue("user_level",""+"");
response.sendRedirect("../index.html");
%>





