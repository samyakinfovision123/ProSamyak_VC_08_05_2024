
/*
----------------------------------------------------------------------------------------------
* ModifiedBy		Date				Status		Reasons
----------------------------------------------------------------------------------------------
* Mr Ganesh         22-04-2011          Done        add to MVC design pattern         
----------------------------------------------------------------------------------------------
*/
package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class GetDate 
{
	static String errLine="10";
	private	Connection conp		= null;
	Connect1 c;
	private	PreparedStatement pstmt_p=null;
	public GetDate()
	{
	/*try{c=new Connect1();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/
	}




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
}//





public static String getDueDays(String initial_date, String due_date)
{
int days=0;
errLine="50";
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
		}








public java.sql.Date getClosingDate(Connection con, int month,int year, String id)
	{
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	try{
	// conp=c.getConnection();

	String query ="select ClosingPayment_Description from Master_ClosingPayment where ClosingPayment_Id=? ";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setString(1,id);
	ResultSet rs = pstmt_p.executeQuery();
	int days=0;
	while(rs.next())
		{
		days=rs.getInt("ClosingPayment_Description");
		}
		pstmt_p.close();
		//c.returnConnection(conp);

int dd2 = 20;
errLine="150";
month=month-1;
int d[]={31,28,31,30,31,30,31,31,30,31,30,31};

if(days==0){dd2=01;}
else if(days==5){dd2=05;}
else if(days==10){dd2=10;}
else if(days==15){dd2=15;}
else if(days==20){dd2=20;}
else if(days==25){dd2=25;}
else if(days==32){dd2=d[month];}


else if(days==37){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=5;}
else if(days==42){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=10;}
else if(days==47){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=15;}
else if(days==49){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=17;}


else if(days==52){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=20;}
else if(days==57){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=25;}
else if(days==58){month +=1;
if(month>11){month= month-12; year+=1;}
dd2=26;}
else if(days==64)
{month +=1;
if(month>11){month= month-12; year+=1;} 
	dd2=d[month];
}

else if(days==69){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=5;}
else if(days==74){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=10;}
else if(days==79){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=15;}
else if(days==84){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=20;}

else if(days==89){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=25;}
else if(days==96){month +=2;
if(month>11){month= month-12; year+=1;}
dd2=d[month];}


else if(days==101){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=5;}

else if(days==106){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=10;}

else if(days==111){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=15;}

else if(days==116){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=20;}

else if(days==121){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=25;}

else if(days==126){month +=3;
if(month>11){month= month-12; year+=1;}
dd2=d[month];}

else if(days==131){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=5;}

else if(days==136){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=10;}

else if(days==141){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=15;}


else if(days==146){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=20;}

else if(days==151){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=25;}


else if(days==158){month +=4;
if(month>11){month= month-12; year+=1;}
dd2=d[month];}


else if(days==163){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=5;}


else if(days==168){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=10;}

else if(days==173){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=15;}

else if(days==178){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=20;}


else if(days==183){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=25;}

else if(days==190){month +=5;
if(month>11){month= month-12; year+=1;}
dd2=d[month];}


else if(days==195){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=5;}


else if(days==200){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=10;}

else if(days==205){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=15;}

else if(days==210){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=20;}

else if(days==215){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=25;}


else if(days==222){month +=6;
if(month>11){month= month-12; year+=1;}
dd2=d[month];}


else if(days==422)
{
errLine="321";
int temp=d[month];
int tmon=month+1;
if(tmon>11){tmon= tmon-12; temp +=d[tmon];}
else{temp +=d[month+1];}
tmon=month +2;
if(tmon>11){tmon= tmon-12; temp +=d[tmon];}
else{temp +=d[month+2];}

	month +=2;
if(month>11){month= month-12; year+=1;}
if(temp <= 90)
	{dd2=d[month];}
else{
int t1= temp-90;
dd2=d[month]-t1;
}
}


int mm2 = month;
int yy2 = year;
errLine="342";
	java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2),dd2);


		return D2;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.print("error in GetDate.java at errLine="+errLine+" bug is "+e);
		return D;}
//finally{c.returnConnection(conp); return D; }

	}//getRequiredDate








public String getFinalDueDays(Connection con,String invoice_date, String party_id)
	{
try{
StringTokenizer st = new StringTokenizer(invoice_date,"/");
String DD = st.nextToken();
String MM = st.nextToken();
String YY = st.nextToken();
String invoice_Date = MM+"/"+DD+"/"+YY;
int idd=Integer.parseInt(DD);
int imm=Integer.parseInt(MM);
int iyy=Integer.parseInt(YY);
java.sql.Date inv_date = new java.sql.Date((iyy-1900),(imm-1),idd);

 //conp=c.getConnection();
String query="select Payment_Date,Closing_Date,Due_Days from Master_CompanyParty where CompanyParty_Id=?";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setString(1,party_id);
	ResultSet rs = pstmt_p.executeQuery();
	int ddays=0;
	String cls_id="";
	String pay_id="";
	String return_days="";
	while(rs.next())
		{
		pay_id = rs.getString("Payment_Date"); 
		cls_id = rs.getString("Closing_Date");
		ddays = rs.getInt("Due_Days");
		}
		pstmt_p.close();
	//   	c.returnConnection(conp);


	java.sql.Date cls_date = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date pay_date = new java.sql.Date(System.currentTimeMillis());

cls_date=getClosingDate(con,imm,iyy,cls_id);
if("47".equals(cls_id))
	{cls_date=inv_date;}
boolean after_flag=inv_date.after(cls_date);
if(after_flag)
{cls_date=getClosingDate(con,(imm+1),iyy,cls_id);}
// System.out.println("\ncls_date="+cls_date);
//  System.out.println("\npay_id="+pay_id);
if(ddays==0)
	{
int cmm=(cls_date.getMonth()+1);
int cyy=(cls_date.getYear()+1900);

pay_date=getClosingDate(con,cmm,cyy,pay_id);
return_days=getDueDays(invoice_date,format(pay_date));
//  System.out.println("\ninvoice_date="+invoice_date);
// System.out.println("\npay_date="+pay_date);

}


else{
String temp=getDueDate(format(cls_date),ddays);
return_days=getDueDays(invoice_date,temp);
}
//  System.out.println("\nreturn_days="+return_days);

return return_days;
	}catch(Exception e)
		{//c.returnConnection(conp);
		return ""+e;}
//finally{c.returnConnection(conp); }

	}//getFinalDueDays


public java.sql.Date getDate(Connection con,String table, String column,  String condition)
{
	java.sql.Date fromDate = null; 

	try{
	String fromDateQuery = "select "+column+" from "+table+" "+condition;
	
	pstmt_p = con.prepareStatement(fromDateQuery);

	ResultSet rs = pstmt_p.executeQuery();

	while(rs.next())
	{
		fromDate = rs.getDate(column);	
	}
	pstmt_p.close();
	}
	catch(Exception e)
	{
		System.out.print(e);
	}
	return fromDate;
}



	public static void main(String[] args) 
	{
	
	
	//System.out.println("Hello World!");
	GetDate G = new GetDate();
	try{

	}catch(Exception e){System.out.print(e);}
	
	}
}

