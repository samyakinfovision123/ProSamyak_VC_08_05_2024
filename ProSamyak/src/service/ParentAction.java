/** 
*  SRL			start		12-07-2010		Shital - Rupesh - Lotan
*
**/

package service;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class ParentAction implements SamYakActInterface{
	
	public abstract String perform(HttpServletRequest req,HttpServletResponse res);
	public ServiceForword perform(HttpServlet servlet , HttpServletRequest req,HttpServletResponse res)
	{
		System.out.println("Inside ParentAction Perform");
		//Get DataBase Connection Here and Pass it as Parameter to Perform. (if required)
		String routPage = perform(req,res);
		// Exception 
		return new ServiceForword(routPage);
	}

}
