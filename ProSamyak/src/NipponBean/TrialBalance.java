package NipponBean;
import java.io.*;
import java.util.*;
import java.sql.*;
import NipponBean.*;
public class  TrialBalance
{
//	NipponBean.Array A= new 	NipponBean.Array();

	Connection conp = null;
	Connection cong = null;
	
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	//Connect c;

	ResultSet rs_g=null;
	public	TrialBalance()
		{
		/* try{c=new Connect1();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/
		}
	
	
public String insertBalance(Connection con,String company_id,String for_head, String for_headid, String head_name, String opening_balance, String transation_debit, String transation_credit, String closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();

	String query=" Insert  into Balance(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?) ";
pstmt_p = con.prepareStatement(query);

pstmt_p.setString (1, company_id);
pstmt_p.setString (2, for_head);
pstmt_p.setString (3, for_headid);
pstmt_p.setString (4, head_name);
pstmt_p.setString (5, opening_balance);
pstmt_p.setString (6, transation_debit);
pstmt_p.setString (7, transation_credit);
pstmt_p.setString (8, closing_balance);
pstmt_p.setDate (9, D1);
pstmt_p.setDate(10, D2);
pstmt_p.setTimestamp(11,run_date);
//System.out.print(run_date);
pstmt_p.setString (12, userid);
pstmt_p.setString (13, machinrname);
pstmt_p.setString (14, yearend_id);
int a = pstmt_p.executeUpdate();

pstmt_p.close();
//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}

public String insertBalanceDouble(Connection con,String company_id,String for_head, String for_headid, String head_name, double opening_balance, double transation_debit, double transation_credit, double closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();

	String query=" Insert  into Balance(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?) ";
pstmt_p = con.prepareStatement(query);

pstmt_p.setString (1, company_id);
pstmt_p.setString (2, for_head);
pstmt_p.setString (3, for_headid);
pstmt_p.setString (4, head_name);
pstmt_p.setDouble (5, opening_balance);
pstmt_p.setDouble (6, transation_debit);
pstmt_p.setDouble (7, transation_credit);
pstmt_p.setDouble (8, closing_balance);
pstmt_p.setDate (9, D1);
pstmt_p.setDate(10, D2);
pstmt_p.setTimestamp(11,run_date);
//System.out.print(run_date);
pstmt_p.setString (12, userid);
pstmt_p.setString (13, machinrname);
pstmt_p.setString (14, yearend_id);
int a = pstmt_p.executeUpdate();

pstmt_p.close();
//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}





//overloaded method to insert the ledger_id
public String insertBalance(Connection con,String company_id,String for_head, String for_headid, String head_name, String opening_balance, String transation_debit, String transation_credit, String closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id, String ledger_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();

	String query=" Insert  into Balance(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id,ledger_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) ";
	pstmt_p = con.prepareStatement(query);

	pstmt_p.setString (1, company_id);
	pstmt_p.setString (2, for_head);
	pstmt_p.setString (3, for_headid);
	pstmt_p.setString (4, head_name);
	pstmt_p.setString (5, opening_balance);
	pstmt_p.setString (6, transation_debit);
	pstmt_p.setString (7, transation_credit);
	pstmt_p.setString (8, closing_balance);
	pstmt_p.setDate (9, D1);
	pstmt_p.setDate(10, D2);
	pstmt_p.setTimestamp(11,run_date);
	//System.out.print(run_date);
	pstmt_p.setString (12, userid);
	pstmt_p.setString (13, machinrname);
	pstmt_p.setString (14, yearend_id);
	pstmt_p.setString (15, ledger_id);
	int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}


///start for double methom 
//overloaded method to insert the ledger_id
public String insertBalanceDouble(Connection con,String company_id,String for_head, String for_headid, String head_name, double opening_balance, double transation_debit, double transation_credit, double closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id, String ledger_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();

	String query=" Insert  into Balance(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id,ledger_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) ";
	pstmt_p = con.prepareStatement(query);

	pstmt_p.setString (1, company_id);
	pstmt_p.setString (2, for_head);
	pstmt_p.setString (3, for_headid);
	pstmt_p.setString (4, head_name);
	pstmt_p.setDouble (5, opening_balance);
	pstmt_p.setDouble (6, transation_debit);
	pstmt_p.setDouble (7, transation_credit);
	pstmt_p.setDouble (8, closing_balance);
	pstmt_p.setDate (9, D1);
	pstmt_p.setDate(10, D2);
	pstmt_p.setTimestamp(11,run_date);
	//System.out.print(run_date);
	pstmt_p.setString (12, userid);
	pstmt_p.setString (13, machinrname);
	pstmt_p.setString (14, yearend_id);
	pstmt_p.setString (15, ledger_id);
	int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}


//end for double method

public String insertProfit(Connection con,String company_id,String for_head, String for_headid, String head_name, String opening_balance, String transation_debit, String transation_credit, String closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();
	String query=" Insert  into ProfitLoss(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?) ";
pstmt_p = con.prepareStatement(query);

pstmt_p.setString (1, company_id);
pstmt_p.setString (2, for_head);
pstmt_p.setString (3, for_headid);
pstmt_p.setString (4, head_name);
pstmt_p.setString (5, opening_balance);
pstmt_p.setString (6, transation_debit);
pstmt_p.setString (7, transation_credit);
pstmt_p.setString (8, closing_balance);
pstmt_p.setDate (9, D1);
pstmt_p.setDate(10, D2);
pstmt_p.setTimestamp(11,run_date);
//System.out.print(run_date);
pstmt_p.setString (12, userid);
pstmt_p.setString (13, machinrname);
pstmt_p.setString (14, yearend_id);
int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}

public String insertProfitDouble(Connection con,String company_id,String for_head, String for_headid, String head_name, double opening_balance, double transation_debit, double transation_credit, double closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();
	String query=" Insert  into ProfitLoss(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?) ";
pstmt_p = con.prepareStatement(query);

pstmt_p.setString (1, company_id);
pstmt_p.setString (2, for_head);
pstmt_p.setString (3, for_headid);
pstmt_p.setString (4, head_name);
pstmt_p.setDouble (5,opening_balance);
pstmt_p.setDouble (6,transation_debit);
pstmt_p.setDouble (7,transation_credit);
pstmt_p.setDouble (8,closing_balance);
pstmt_p.setDate (9, D1);
pstmt_p.setDate(10, D2);
pstmt_p.setTimestamp(11,run_date);
//System.out.print(run_date);
pstmt_p.setString (12, userid);
pstmt_p.setString (13, machinrname);
pstmt_p.setString (14, yearend_id);
int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}




//Overloaded method to insert ledger_id in the ProfitLoss table
public String insertProfit(Connection con,String company_id,String for_head, String for_headid, String head_name, String opening_balance, String transation_debit, String transation_credit, String closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id, String ledger_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();
	String query=" Insert  into ProfitLoss(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id,ledger_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) ";
	pstmt_p = con.prepareStatement(query);

	pstmt_p.setString (1, company_id);
	pstmt_p.setString (2, for_head);
	pstmt_p.setString (3, for_headid);
	pstmt_p.setString (4, head_name);
	pstmt_p.setString (5, opening_balance);
	pstmt_p.setString (6, transation_debit);
	pstmt_p.setString (7, transation_credit);
	pstmt_p.setString (8, closing_balance);
	pstmt_p.setDate (9, D1);
	pstmt_p.setDate(10, D2);
	pstmt_p.setTimestamp(11,run_date);
	//System.out.print(run_date);
	pstmt_p.setString (12, userid);
	pstmt_p.setString (13, machinrname);
	pstmt_p.setString (14, yearend_id);
	pstmt_p.setString (15, ledger_id);
	int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}

///Start of double profit loss method

public String insertProfitDouble(Connection con,String company_id,String for_head, String for_headid, String head_name, double opening_balance, double transation_debit, double transation_credit, double closing_balance, java.sql.Date D1 , java.sql.Date D2, String userid, String machinrname,String yearend_id, String ledger_id) throws Exception
	{
	
			try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
try{
	java.sql.Timestamp run_date = new java.sql.Timestamp(System.currentTimeMillis());

	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());
	int itoday_day=D.getDate();
	String stoday_day=""+itoday_day;
	if (itoday_day < 10){stoday_day="0"+itoday_day;}
	int itoday_month=(D.getMonth()+1);
	String stoday_month=""+itoday_month;
	if (itoday_month < 10) {stoday_month="0"+itoday_month;}
	int today_year=(D.getYear()+1900);
	String today_string= stoday_day+"/"+stoday_month+"/"+today_year;
	 //conp=c.getConnection();
	String query=" Insert  into ProfitLoss(company_id, for_head, for_headid, head_name, opening_balance, transation_debit, transation_credit, closing_balance, Opening_Date, Closing_Date, Modified_On, Modified_By, Modified_MachineName,yearend_id,ledger_id)values(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) ";
	pstmt_p = con.prepareStatement(query);

	pstmt_p.setString (1, company_id);
	pstmt_p.setString (2, for_head);
	pstmt_p.setString (3, for_headid);
	pstmt_p.setString (4, head_name);
	pstmt_p.setDouble (5, opening_balance);
	pstmt_p.setDouble (6, transation_debit);
	pstmt_p.setDouble (7, transation_credit);
	pstmt_p.setDouble (8, closing_balance);
	pstmt_p.setDate (9, D1);
	pstmt_p.setDate(10, D2);
	pstmt_p.setTimestamp(11,run_date);
	//System.out.print(run_date);
	pstmt_p.setString (12, userid);
	pstmt_p.setString (13, machinrname);
	pstmt_p.setString (14, yearend_id);
	pstmt_p.setString (15, ledger_id);
	int a = pstmt_p.executeUpdate();

	pstmt_p.close();
	//c.returnConnection(conp);

		return ""+a;

         }catch(Exception e )
             {//c.returnConnection(conp);
		 System.out.println("TrialBalance.java Exception :"+e);
 	return ""+e;    }
	//finally{c.returnConnection(cong); }

	}

///end of double profit loss method


	public static void main(String[] args) throws Exception
	{
TrialBalance t=new TrialBalance();
		
	}
}


