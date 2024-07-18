/** 
*  SRL			start		12-07-2010		Shital - Rupesh - Lotan
*
**/

package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface SamYakActInterface {
	public ServiceForword perform(HttpServlet servlet,HttpServletRequest req, HttpServletResponse res) 
	throws IOException,ServletException;

}
