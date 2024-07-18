<!-- Consingment In Start 06-03-05 -->
<%@ page language="java" import="java.io.*,java.sql.*,java.util.*,NipponBean.*" errorPage="errorpage.jsp" %>

<jsp:useBean id="A" class="NipponBean.Array" />
<jsp:useBean id="AC" class="NipponBean.ArrayCSS" />
<jsp:useBean id="C" scope="application" class="NipponBean.Connect" />
<jsp:useBean id="I" class="NipponBean.Inventory" />
<jsp:useBean id="G" class="NipponBean.GetDate" />
<jsp:useBean id="YED"  class="NipponBean.YearEndDate" />

<script language=javascript src="../Samyak/SamyakYearEndDate.js"> </script>
<script language=javascript src="../Samyak/Samyakmultidate.js">
</script>
<script language="javascript" src="../Samyak/Samyakcalendar.js"></script>
<script language="javascript" src="../Samyak/Samyakdate.js"></script>
<script language="javascript" src="../Samyak/SamyakNewDate.js"></script>
<script language="javascript" src="../Samyak/lw_layers.js"></script>
<script language="javascript" src="../Samyak/LW_MENU.JS"></script>
<script language="javascript" src="../Samyak/drag.js"></script>
<script language=javascript src="../Samyak/ajax1.js"></script>
<script language=javascript src="../Samyak/Lot.js"></script>
<script language=javascript src="../Samyak/actb.js"></script>
<script language=javascript src="../Samyak/common.js"></script>
<script language=javascript src="../Samyak/SamyakRestriction.js"></script>
<link href='../Samyak/Samyakcss.css' rel=stylesheet type='text/css'>
<meta http-equiv="expires" content="tue, 20 oct 1998 23:00: gmt">
<TITLE> Edit BrokerPurhasePerson </TITLE>
<Html>
	<Body bgcolor=#FFD3A8>
		
		
		
		<%java.sql.Date D4 = new
		java.sql.Date(System.currentTimeMillis());
		%>

			
			<IFRAME name=top  src="../Master/NewBrokerPerson.jsp?command=Default&message=Default" marginwidth="0" marginheight="10" hspace="0" vspace="0" frameborder="0" scrolling="no" width='100%'  height='20%'  >
			
			

			<IFRAME name=bottom  src="../Master/SalesPerson.jsp?command=Default&message=Broker&marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="auto" width='100%' height='80%' >
			
			 
		</Body>
</Html>
