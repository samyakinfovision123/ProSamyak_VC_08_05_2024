package samyak.proSamyakAction;

import java.io.PrintStream;
import java.sql.Date;
import javax.servlet.http.*;
import service.ParentAction;

public class Reporting extends ParentAction
{

    public Reporting()
    {
    }

    public String perform(HttpServletRequest req, HttpServletResponse res)
    {
label0:
        {
            HttpSession session = null;
            String EngineerId = req.getParameter("masterEngineerTable");
            String yearmonth = req.getParameter("yearmonth");
            String ReportDay = req.getParameter("day");
            int abc = 7;
            String command = req.getParameter("command");
            long engineerId = 0L;
            String engineerName = "";
            String presentquery = "";
            String attendQuery = "";
            String TodayString = "";
            System.out.println("Time is");
            Date currentTime = new Date(System.currentTimeMillis());
            System.out.println((new StringBuilder("Time is==============")).append(currentTime).toString());
            Date D = new Date(System.currentTimeMillis());
            System.out.println((new StringBuilder("D=")).append(D).toString());
            int year1 = D.getYear();
            int dd1 = D.getDate() - 1;
            int mm1 = D.getMonth();
            Date Dprevious = new Date(year1, mm1, dd1);
            System.out.println(Dprevious);
            try
            {
                session = req.getSession(false);
                String usernameid = String.valueOf(session.getValue("user_id"));
                if(!"Report".equalsIgnoreCase(command))
                    break label0;
                req.setAttribute("EngId", EngineerId);
                req.setAttribute("currentTime", currentTime);
                req.setAttribute("usernameid", usernameid);
                req.setAttribute("ReportDay", ReportDay);
                System.out.println((new StringBuilder("  eng Id ")).append(EngineerId).toString());
                System.out.println((new StringBuilder(" usernameid  ")).append(usernameid).toString());
            }
            catch(Exception e)
            {
                e.printStackTrace();
                e.getMessage();
                return "error-page";
            }
            return "ReportView";
        }
        return "Report-View";
    }
}