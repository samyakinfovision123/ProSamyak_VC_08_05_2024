/*
----------------------------------------------------------------------------------------------
* ModifiedBy		Date				Status		Reasons
----------------------------------------------------------------------------------------------
* Mr Ganesh         22-04-2011          Done        add to MVC design pattern         
----------------------------------------------------------------------------------------------
*/

package NipponBean;
import java.sql.*;
import java.util.*;

public class YearEndDate {
Connection cong = null;
ResultSet rs_g=null;
PreparedStatement pstmt_g=null;
Connection conp = null;
ResultSet rs_p=null;
PreparedStatement pstmt_p=null;
//Connect c;
//NipponBean.Array A;
static String errLine="14";

public YearEndDate()
	{
		try{
		//c=new Connect();
			//A=new NipponBean.Array();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}
	}
 
 
 java.sql.Date yearendfromdate; 
 java.sql.Date yearendtodate; 

int openingyearend_id=0;
String temp_id="";
java.sql.Date D1 = new java.sql.Date(System.currentTimeMillis());
//java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);

 
public String returnCurrentFinancialYear( Connection cong ,PreparedStatement pstmt_g,ResultSet rs_g, String yearend_id, String company_id)
 {
  String year="";
  try{

		errLine="39";
		String myquery="select From_Date,To_Date from  YearEnd where YearEnd_Id="+yearend_id+"and Company_Id="+company_id;
		pstmt_g = cong.prepareStatement(myquery);
		rs_g = pstmt_g.executeQuery();	

		while(rs_g.next()){
		    yearendfromdate=rs_g.getDate("From_Date"); 
		    yearendtodate=rs_g.getDate("To_Date"); 
		}
		pstmt_g.close();
		errLine="49";
		year = yearendfromdate +"#"+yearendtodate;
		
  }catch(Exception e){
	  System.out.print("<BR>EXCEPTION in YearEndDate.java at Line="+errLine+"is "+e);
	 }
 return year;
}

public String returnYearEndId(Connection cong ,PreparedStatement pstmt_g,ResultSet rs_g, java.sql.Date date, String company_id)
	{
     String askedyearend_id="0";
	 java.sql.Date tempdate= new java.sql.Date(System.currentTimeMillis()); 
	 String yearend_id = "0";
	 try{
     
	  String myquery1="select YearEnd_id,From_Date,To_Date from YearEnd where Company_Id="+company_id+" order by From_Date";
      pstmt_g = cong.prepareStatement(myquery1);
	  rs_g = pstmt_g.executeQuery();	
	  //System.out.println(myquery1);
	  //System.out.println(rs_g);
	  while(rs_g.next())
	    {
           yearend_id=rs_g.getString("YearEnd_id");
	       java.sql.Date yearendfromdate=rs_g.getDate("From_Date"); 
           java.sql.Date yearendtodate=rs_g.getDate("To_Date"); 
		   tempdate = yearendtodate;
		   int datecount1,datecount2;
 
           datecount1=date.compareTo(yearendfromdate);
	
	       if(datecount1>=0) {
		
		      datecount2=date.compareTo(yearendtodate);
		      if(datecount2<=0) {
				 //System.out.println("YearEnd_id ="+yearend_id+" : Date "+date+" : FDate "+yearendfromdate+" : TDate "+yearendtodate);
				 return  yearend_id;
				 
			  }	
			 }
			else {
				return yearend_id;
				
			}
		}
		
		int compareDate;
        compareDate=date.compareTo(tempdate);
		if(compareDate > 0)
			return yearend_id;

		
	}catch(Exception e){
		System.out.print("<BR>EXCEPTION in YearEndDate.java at Line="+errLine+"is "+e);}

	return askedyearend_id;
 }

/*
public String returnNextYearEndId(Connection cong ,PreparedStatement pstmt_g,ResultSet rs_g, String yearend_id, String company_id)
	{

	String newyearend_id="";

	try{

	String Fyear = returnCurrentFinancialYear(cong , pstmt_g, rs_g, yearend_id, company_id);

	StringTokenizer splityear = new StringTokenizer(Fyear,"#");
	String tempFromDate = (String)splityear.nextElement();
	String tempToDate = (String)splityear.nextElement();

	StringTokenizer enddate = new StringTokenizer(tempToDate,"-");
	
	int endyear=Integer.parseInt((String)enddate.nextElement());
	int endmonth=Integer.parseInt((String)enddate.nextElement());
	String endday= (String)enddate.nextElement();
	StringTokenizer splitendday = new StringTokenizer(endday," ");
	int splittedendday = Integer.parseInt((String)splitendday.nextElement());

	//created new dates for next financial year from the current year end date
	java.sql.Date newFinancialYearStart = new java.sql.Date( endyear-1900, endmonth-1, splittedendday+1);
	java.sql.Date newFinancialYearEnd = new java.sql.Date( endyear+1-1900 , endmonth-1, splittedendday);


	String ys = format.format(newFinancialYearStart);
	String yd = format.format(newFinancialYearEnd);
	

	String query = "Select yearend_id from YearEnd where From_Date=? and To_Date=? and Company_Id=?";

	pstmt_p = conp.prepareStatement(query);
	pstmt_p.setString(1,ys);
	pstmt_p.setString(2,yd);
	pstmt_p.setString(3,company_id);
	rs_g = pstmt_p.executeQuery();

	rs_g.next();

	newyearend_id = rs_g.getString("yearend_id");
	}catch(Exception e){
		System.out.println("Exception "+e);}

	return newyearend_id;
 }

*/


public java.sql.Date getDate(Connection con,String table,String column, String condition) throws Exception
	{
	java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
	int year=date.getYear();
	int dd=01;
	int mm=date.getMonth();
	date = new java.sql.Date((year+1),(mm),dd);
	try{
  	 //conp=c.getConnection();
	String query ="select "+column+" from "+table+" "+condition+"" ;
	//System.out.println("query="+query);
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	
	while(rs.next()) 	
	{
	 date = rs.getDate(column);
	// System.out.println("Name "+name);
	}

	pstmt_p.close();
	//c.returnConnection(conp);

	
		}
catch(Exception e)
	{	System.out.print("<BR>EXCEPTION in YearEndDate.java at Line="+errLine+"is "+e);

	}//
return date;
	}

 public static void main(String[] args) throws Exception
	{

		YearEndDate y = new YearEndDate();

	}

}




		
	