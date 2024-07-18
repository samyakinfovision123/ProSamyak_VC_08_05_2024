
/*
created on 14/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		14/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
package samyak.utils;

import java.sql.Date;


public class htmlincoreJava 
{

	public  htmlincoreJava() 
	{
		
	}
	
	public String getOneThirtyOne(String month ) 
	{
		String returnValue ="";
		
		Date date = new Date (System.currentTimeMillis());
		String getyy=String.valueOf(date.getYear()) ;
		String getyyyy = String.valueOf(Long.parseLong(getyy) + 1900 ); 
		
		returnValue = returnValue +"<td> 01/"+month +"/"+getyyyy+ "</td>" ;
		returnValue = returnValue +"<td> 02/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 03/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 04/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 05/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 06/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 07/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 08/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 09/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 10/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 11/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 12/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 13/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 14/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 15/"+month +"/"+getyyyy + "</td>" ;
		
		returnValue = returnValue +"<td> 16/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 17/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 18/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 19/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 20/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 21/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 22/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 23/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 24/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 25/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 26/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 27/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 28/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 29/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 30/"+month +"/"+getyyyy + "</td>" ;
		returnValue = returnValue +"<td> 31/"+month +"/"+getyyyy + "</td>" ;
		
		System.out.println(returnValue);
		return returnValue;
	}
}
