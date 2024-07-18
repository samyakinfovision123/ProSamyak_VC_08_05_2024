/** 
*  SRL			start		12-07-2010		Shital - Rupesh - Lotan
*
**/

package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Sale extends ParentAction{
	public String perform(HttpServletRequest req,HttpServletResponse res)
	{
		System.out.println("Inside The Sale Action");
		return "v2-purchase";
	}
}
