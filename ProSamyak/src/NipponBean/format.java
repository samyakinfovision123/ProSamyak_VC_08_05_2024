/*
----------------------------------------------------------------------------------------------
* ModifiedBy		Date				Status		Reasons
----------------------------------------------------------------------------------------------
* Mr Ganesh         22-04-2011          Done        add to MVC design pattern         
----------------------------------------------------------------------------------------------
*/
package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
public class  format
{

	
	private	Connection conp		= null;
	private	PreparedStatement pstmt_p=null;
	public format()
	{
	}


	
	public static String format(java.sql.Date D)
		{
			int m =D.getMonth()+1;
			String month=""+m;
			if(m <= 9)
			{month= "0"+m; }
			if(D  == null ) { return "  -  ";}
			else {
int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String final_date= stoday_day+"/"+stoday_month+"/"+today_year;
return final_date;

			}
		}//method
	


public static String getDueDate(String initial_date, int due_days)
{
int temp=0;

StringTokenizer st = new StringTokenizer(initial_date,"/");
String DD = st.nextToken();
String MM = st.nextToken();
String YY = st.nextToken();
initial_date = MM+"/"+DD+"/"+YY;

java.util.Date D = new java.util.Date(initial_date);
//System.out.print(" Date "+D);
temp=D.getDate();
temp = temp + due_days;
D.setDate(temp);

int itoday_day=D.getDate();
String stoday_day=""+itoday_day;
if (itoday_day < 10){stoday_day="0"+itoday_day;}
int itoday_month=(D.getMonth()+1);
String stoday_month=""+itoday_month;
if (itoday_month < 10) {stoday_month="0"+itoday_month;}
int today_year=(D.getYear()+1900);
String final_date= stoday_day+"/"+stoday_month+"/"+today_year;
return final_date;
}//method





public static String getDueDays(String initial_date, String due_date)
{
int days=0;

StringTokenizer st = new StringTokenizer(initial_date,"/");
String DD = st.nextToken();
String MM = st.nextToken();
String YY = st.nextToken();
initial_date = MM+"/"+DD+"/"+YY;
java.util.Date D = new java.util.Date(initial_date);



StringTokenizer st1 = new StringTokenizer(due_date,"/");
String DD1 = st1.nextToken();
String MM1 = st1.nextToken();
String YY1 = st1.nextToken();
due_date = MM1+"/"+DD1+"/"+YY1;
java.util.Date DueDate = new java.util.Date(due_date);
//System.out.print(" Date "+D);


boolean before_flag=D.before(DueDate);
if(before_flag)
	{
java.util.Date temp_Date=D;
while((DueDate.compareTo(temp_Date))!= 0)
	{
	days++;
	int temp = temp_Date.getDate();
	temp =temp +1;
	temp_Date.setDate(temp);
}//while
}
else{
java.util.Date temp_Date=DueDate;
while((D.compareTo(temp_Date))!= 0)
	{
	days++;
	int temp = temp_Date.getDate();
	temp =temp +1;
	temp_Date.setDate(temp);
}//while

}
return ""+days;
}//method

public static java.sql.Date getDate(String strdate)
	{
		StringTokenizer st = new StringTokenizer(strdate,"/");
		int DD = Integer.parseInt(st.nextToken());
		int MM =Integer.parseInt(st.nextToken())-1;
		int YY =Integer.parseInt(st.nextToken())-1900;
		java.sql.Date SD =  new java.sql.Date(YY,MM,DD);
		return SD;
	}//method

public static String getOverDueDays(String initial_date, String due_date)
{
int days=0;

StringTokenizer st = new StringTokenizer(initial_date,"/");
String DD = st.nextToken();
String MM = st.nextToken();
String YY = st.nextToken();
initial_date = MM+"/"+DD+"/"+YY;
java.util.Date D = new java.util.Date(initial_date);



StringTokenizer st1 = new StringTokenizer(due_date,"/");
String DD1 = st1.nextToken();
String MM1 = st1.nextToken();
String YY1 = st1.nextToken();
due_date = MM1+"/"+DD1+"/"+YY1;
java.util.Date DueDate = new java.util.Date(due_date);
//System.out.print(" Date "+D);


boolean before_flag=D.after(DueDate);
if(before_flag)
	/*{
java.util.Date temp_Date=D;
while((DueDate.compareTo(temp_Date))!= 0)
	{
	days++;
	int temp = temp_Date.getDate();
	temp =temp +1;
	temp_Date.setDate(temp);
}//while
}

else*/{
java.util.Date temp_Date=DueDate;
while((D.compareTo(temp_Date))!= 0)
	{
	days++;
	int temp = temp_Date.getDate();
	temp =temp +1;
	temp_Date.setDate(temp);
}//while

}

return ""+days;
}//method

}//class

