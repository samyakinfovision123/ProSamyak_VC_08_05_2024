package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class Voucher 
{
	private	Connection conp		= null;
	private	Connection cong		= null;
	PreparedStatement pstmt_p=null;
	PreparedStatement pstmt_g=null;
	ResultSet rs_g = null;
	ResultSet rs = null;
	//Connect1 C =null;
	public Voucher()
	{
		/* try{C=new Connect1();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/

	}

	public String getVoucherArray(Connection con, String html_name,String str, String Company_id, String type)
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
	 //conp=C.getConnection();
	String query ="select * from Capital  where active=1 and Company_id="+Company_id+" order by Capital_name ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("Capital_id").trim();		
		 String temp = rs.getString("Capital_name").trim();
		  html_array = html_array +"<option value='C:"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
//		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();

 query ="select * from Asset  where active=1 and Company_id="+Company_id+" order by Asset_name ";
	 i=0;
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = conp.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	//String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("Asset_id").trim();		
		 String temp = rs.getString("Asset_name").trim();
		 
		 html_array = html_array +"<option value='A:"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//C.returnConnection(conp);




		return html_array;
	}
	catch(Exception e)
	{
		// C.returnConnection(conp);
	 System.out.println(" Error in getVoucherArray is = "+e);
	 	 return "err";
	}
 //finally{C.returnConnection(cong); }

	}//


public static String AutoNumberPurchaseSettlement(Connection con, String company_id)
{
	Connection cong	= null;
	PreparedStatement pstmt_g	= null;
	ResultSet rs_g	= null;
	try
	{
		String voucher_no="PS-";

		String query="select count(distinct(Payment_No)) as voucher_count from Payment_Details where Transaction_Type=1 and Payment_Mode=0 and For_Head=10 and  Voucher_Id=0 and company_id = "+company_id;

		pstmt_g = con.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();	
		int voucher_count=0;
		while(rs_g.next())
		{
			voucher_count=rs_g.getInt("voucher_count");
		}
	    pstmt_g.close();
		
		voucher_count++;
		voucher_no="PS-"+voucher_count;
	return voucher_no;
	}
	catch(Exception e)
	{ 
		System.out.println("Error in AutoNumberPurchaseSettlement is = "+e);
			return "err";
	}
}

// for sale Settlement

public static String AutoNumberSaleSettlement(Connection con, String company_id)
{
	Connection cong	= null;
	PreparedStatement pstmt_g	= null;
	ResultSet rs_g	= null;
	try
	{
		String voucher_no="SS-";
		
		String query="select count(distinct(Payment_No)) as voucher_count from Payment_Details where Transaction_Type=0 and Payment_Mode=0 and For_Head=9 and  Voucher_Id=0 and Company_Id="+company_id;

		pstmt_g = con.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();	
		int voucher_count=0;
		while(rs_g.next())
		{
			voucher_count=rs_g.getInt("voucher_count");
		}
	    pstmt_g.close();
		
		voucher_count++;
		voucher_no="SS-"+voucher_count;
	//System.out.println("voucher_no===="+voucher_no);
	return voucher_no;
	}
	catch(Exception e)
	{
			System.out.println("Error in AutoNumberSaleSettlement is = "+e);
				return "err";

	}
}


public static String getAutoNumber(Connection con,int voucher_type ,String voucher_currency, String company_id)
{
		//Connect C =null;

	Connection cong	= null;
	PreparedStatement pstmt_g	= null;
	ResultSet rs_g	= null;

try{

	//C = new Connect();	

// cong=C.getConnection();


String voucher_no[]=new String[20];
voucher_no[0]=""; 
voucher_no[1]="S";  //Sales Local
voucher_no[2]="P"; //Purchase Local
voucher_no[3]="ST"; //Stock Transfer
voucher_no[4]="FC"; //Contra
voucher_no[5]="FP";//Payment 
voucher_no[6]="FR";  //Receipt
voucher_no[7]="FJ"; //Journal
voucher_no[8]="FSR"; //Sales Receipt
voucher_no[9]="FPP"; //Purchase Payment
voucher_no[10]="PR"; //Purchase Return
voucher_no[11]="SR"; //Sales Return
voucher_no[12]="PNR"; //PN Sales Receipt
voucher_no[13]="PNP"; //PN Purchase Payment
voucher_no[14]="CS"; //Consignment Sales
voucher_no[15]="CP"; // Consignment Purchase
voucher_no[16]="SE"; // Sales Export
voucher_no[17]="PI"; // Purchase Import
voucher_no[18]="CSR"; // Purchase Import
voucher_no[19]="CPR"; // Purchase Import

String v_no="";
String condition="";
if(voucher_type<=13)
{
if((voucher_type==1)||(voucher_type==2))
	{
	//condition= "and Voucher_currency="+voucher_currency;
	}
String query="Select count(*) as voucher_count from Voucher where company_id=? and voucher_type=? "+condition ;
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id); 
pstmt_g.setString(2,""+voucher_type); 
rs_g = pstmt_g.executeQuery();	
int voucher_count=0;
while(rs_g.next())
{voucher_count=rs_g.getInt("voucher_count");}
pstmt_g.close();
voucher_count++;

v_no=voucher_no[voucher_type]+"-"+voucher_count;
if((voucher_type==1)&&("0".equals(voucher_currency)))
	{v_no=voucher_no[16]+"-"+voucher_count;}
if((voucher_type==2)&&("0".equals(voucher_currency)))
	{v_no=voucher_no[17]+"-"+voucher_count;}
if(voucher_type==3)
	{
	query="Select * from Receive where company_id=? and receive_fromId="+company_id+" and StockTransfer_Type > 0";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
 voucher_count=0;
while(rs_g.next())
{
int StockTransfer_Type=rs_g.getInt("StockTransfer_Type");
if((StockTransfer_Type==6)||(StockTransfer_Type==7))
	{voucher_count++;}
	voucher_count++;
	
}

voucher_count++;
pstmt_g.close();
//System.out.println("voucher_count="+voucher_count);
	v_no=voucher_no[3]+"-"+((voucher_count+1)/2);}


}//if(voucher_type<=13)
else
{
	if(voucher_type==14)
	{
condition ="and receive_sell=0";}
else if(voucher_type==15)
	{condition ="and receive_sell=1";}
else if(voucher_type==19)
	{condition ="and receive_sell=0 and R_Return=1";}
else{condition ="and receive_sell=1 and R_Return=1";}
String query="Select count(*) as voucher_count from Receive where company_id=? and purchase=0 "+condition ;
//System.out.println(query);
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,company_id); 
rs_g = pstmt_g.executeQuery();	
int voucher_count=0;
while(rs_g.next())
{voucher_count=rs_g.getInt("voucher_count");}
pstmt_g.close();
//C.returnConnection(cong);


voucher_count++;
v_no=voucher_no[voucher_type]+"-"+voucher_count;

	}


return v_no;
	}
	catch(Exception e)
	{ //C.returnConnection(cong);
		System.out.println("Error in getAutoNumber is = "+e);
			return "err";
	}
	//finally{C.returnConnection(cong); }

}


public static String getAutoNumber_Order(Connection con,int voucher_type , String company_id)
{
		//Connect C =null;

	
	
	String v_no;
	Connection cong	= null;
	PreparedStatement pstmt_g	= null;
	ResultSet rs_g	= null;

try{

	//C = new Connect();	
	// cong=C.getConnection();
	System.out.println("company_id="+company_id);
	System.out.println("voucher_type="+voucher_type);
	
	String voucher_no[]=new String[2];

	voucher_no[0]="SO";  //Sales Local

	voucher_no[1]="PO"; //Purchase Local

	if(voucher_type==1)
	{
	
	String query="Select count(*) as voucher_count from Order_Sell where  Active=1 and company_id=? and Order_Type=?" ;

	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	pstmt_g.setString(2,""+voucher_type); 
	rs_g = pstmt_g.executeQuery();	
	int voucher_count=0;
	while(rs_g.next())
	{
		voucher_count=rs_g.getInt("voucher_count");
		System.out.println("voucher_count="+voucher_count);
	}
		 pstmt_g.close();
		 voucher_count++;

	v_no="SO-"+(voucher_count+1);

} //if(voucher_type==1)
else
{
	
	String query="Select count(*) as voucher_count from Order_Sell where  Active=1 and company_id=? and Order_Type=?" ;



	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	pstmt_g.setString(2,""+voucher_type); 
	rs_g = pstmt_g.executeQuery();	
	int voucher_count=0;
	while(rs_g.next())
	{
		voucher_count=rs_g.getInt("voucher_count");
		
	}
    pstmt_g.close();
	voucher_count++;

	v_no="PO-"+(voucher_count+1);

} // else

System.out.println("v_no=>"+v_no);
return v_no;
}
catch(Exception e)
{ //C.returnConnection(cong);
		System.out.println(" error in getAutoNumber_Order is ="+e);
		return "err";
}


} //getAutoNumber_Order(Connection,String,String)


//end for get Auto number from order table


	public static void main(String[] args) 
	{
	
	
	//System.out.println("Hello World!");
	Voucher A = new Voucher();
	try{

	}catch(Exception e){System.out.print(e);}
	
	}
}


