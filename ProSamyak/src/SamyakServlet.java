/*
created on 11/04/2011	by MR Ganesh
<!--
----------------------------------------------------------------------------------------------------------------------------------------------------------- 
Sr No ModifiedBy		Date		Status		Reasons
-----------------------------------------------------------------------------------------------------------------------------------------------------------
* 1    MR Ganesh		13/04/2011	start 		To separated between bussiness layer and presention layer and show view page 

------------------------------------------------------------------------------------------------------------------------------------------------------------
-->
*/
import java.io.IOException;
import java.util.ResourceBundle;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ServiceForword;
import service.ServiceGenerator;
import service.SamYakActInterface;

/**
 * This is a basic controller servlet for the Samyak project.
Following are steps involved in Controller
1. Controller receives a request
2. Controller decides the requested activities based on request parameters
3. Controller delegates tasks to be performed based on the request parameters
4. Controller delegates the next view to be shown 
 * @author Manoj
 *
 **/

public class SamyakServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ServiceGenerator generator = new ServiceGenerator();
	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);
		System.out.println("Inside Init");
		ResourceBundle bundle = null;
		bundle = ResourceBundle.getBundle("SamyakAct");
		getServletContext().setAttribute("mappings",bundle);
		//Add Code for All properties files loading and put them in to Context
	
	}
	public void service(HttpServletRequest req, HttpServletResponse res)
	{
		System.out.println("Inside Service");
		try
		{
			String pathQuery = req.getServletPath();
			String className = getServiceClassName(pathQuery);
			SamYakActInterface ClassInstance = null;
			synchronized(generator)
			{
				ClassInstance = generator.getClassInstance(className, getClass().getClassLoader());
			}
			if(ClassInstance == null || className.length()  == 0)
			{
				//Write Code here :  if action not found.
				//Ex. Error Page
				//Create A Error Page with different messages and set that message accordingly in request
				ServiceForword router = new ServiceForword("error-page");
				router.route(this, req, res);
			}		
			ServiceForword serviceForword = ClassInstance.perform(this,req, res);
			serviceForword.route(this,req,res);
			
		} catch(Exception E)
		{
			E.printStackTrace();
			try{
				//Write Code for Exception Handling and routing to Error Page
				ServiceForword serviceForword = new ServiceForword("error-page");
				serviceForword.route(this, req, res);
			}catch(IOException ioe)
			{
				ioe.printStackTrace();
			} catch(ServletException se)
			{
				se.printStackTrace();
			}
		} //End Catch
	} //End of Service method
	
	private String getServiceClassName(String pathQuery)
	{
		int slash = pathQuery.lastIndexOf("/");
		int period = pathQuery.lastIndexOf(".");
		String key = "";
		if(period > 0 && period > slash)
		{
			key = pathQuery.substring(slash+1,period);	
		}
		ResourceBundle bundle = null;
		ServletContext ctx = getServletContext();
		synchronized(ctx)
		{
			bundle = (ResourceBundle)ctx.getAttribute("mappings");
		}
		String actName = "";
		if(bundle!= null)
		{
			actName = (String)bundle.getObject(key);
		}
		return actName;
	}
} //End of Controller Servlet
