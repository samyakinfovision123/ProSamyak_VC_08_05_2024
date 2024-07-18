package service;

import java.io.IOException;
import java.util.ResourceBundle;

import javax.servlet.GenericServlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This Class used to Forward the The response to Next JSP(View) Page
 * @author Manoj
*  SRL			start		12-07-2010		Shital - Rupesh - Lotan
*
**/
public class ServiceForword {
	private String urlKey;
	private boolean forward;
	
	public ServiceForword(String url)
	{
		this(url,true);
	}

	public ServiceForword(String url,boolean forward)
	{
		this.urlKey = url;
		this.forward = forward;
	}
	public String getUrlKey() {
		return urlKey;
	}

	public void route(GenericServlet servlet, HttpServletRequest req,HttpServletResponse res) 
	throws ServletException, IOException
	{
		String url = null;
		ServletContext ctx= null;
		ResourceBundle bundle = null;
		ctx =servlet.getServletContext();
		bundle = (ResourceBundle)ctx.getAttribute("mappings");
		url =  (String)bundle.getObject(urlKey);
		if(url == null)
		{
			//Code For Error page of action not found
			
		} else
		{
			if(forward)
			{
				ctx = servlet.getServletContext();
				ctx.getRequestDispatcher(res.encodeURL(url)).forward(req,res);
			} else
			{
				res.sendRedirect(res.encodeRedirectUrl(url));
			}
		}
	}
}
