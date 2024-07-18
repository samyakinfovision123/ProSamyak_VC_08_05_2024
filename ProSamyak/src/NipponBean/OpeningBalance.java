package NipponBean;
import java.util.*;
import java.sql.*;
import NipponBean.*;

public class  OpeningBalance
{
	Connection cong = null;
	ResultSet rs_g=null;
	PreparedStatement pstmt_g=null;
	Connect1 c;
	double opening_localbalance = 0;
	double opening_dollarbalance = 0;
	
	public	OpeningBalance()
		{
 		/* try{c=new Connect1();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}
*/
		}


public String  nextOpeningBalance(Connection con,java.sql.Date D1,String company_id)
{

try{
	String query="";
	// cong=c.getConnection();



	query ="Select *from Cash where company_id=?";
	pstmt_g = con.prepareStatement(query);
	pstmt_g.setString(1,company_id); 
	rs_g = pstmt_g.executeQuery();
while(rs_g.next())
	{
	opening_localbalance = rs_g.getDouble("Opening_LocalBalance");
	opening_dollarbalance = rs_g.getDouble("Opening_DollarBalance");
	}
	//System.out.print("38:"+opening_localbalance);
			
	


double rlocal=0;
double rdollar=0;
query="Select * from Financial_Transaction where Transaction_Date < ?  and company_id=? and For_Head=4 and Active=1 order by Transaction_Date,Voucher_id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();	
int i=0;
while(rs_g.next()) 	
{i++;}

pstmt_g.close();

int counter =i;
int ftvoucher_id[]=new int[counter];
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,company_id); 
rs_g = pstmt_g.executeQuery();
i=0;
while(rs_g.next()) 	
{
ftvoucher_id[i]=rs_g.getInt("Voucher_id");
i++;
}
pstmt_g.close();


int k=0;
for(i=0; i<counter; i++)
{

query="Select * from Financial_Transaction where Transaction_Date < ? and Voucher_id=? and For_Head not like 4  and Active=1 order by Transaction_Date,Tranasaction_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+ftvoucher_id[i]); 
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{k++;}pstmt_g.close();

}//for
//System.out.print("<br>84 Counter k:=" +k);

int count =k;
int ft_voucher_id[]=new int[count];
String ledger_id[]=new String[count]; 
String forhead_id[]=new String[count]; 
String transaction_type[]=new String[count];
double local[]=new double[count];
double dollar[]=new double[count];

k=0;
for(i=0; i<counter; i++)
{

query="Select * from Financial_Transaction where Transaction_Date < ? and Voucher_id=? and For_Head not like 4 and Active=1 order by Transaction_Date,Tranasaction_Id";
pstmt_g = con.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+ftvoucher_id[i]); 
rs_g = pstmt_g.executeQuery();
while(rs_g.next()) 	
{
ft_voucher_id[k]=rs_g.getInt("Voucher_id");
forhead_id[k]=rs_g.getString("For_Headid");
ledger_id[k]=rs_g.getString("Ledger_id");

transaction_type[k]= rs_g.getString("Transaction_Type");
local[k]=rs_g.getDouble("Local_Amount");
//System.out.print("local[k]="+local[k]);
dollar[k]=rs_g.getDouble("Dollar_Amount");
k++;
}pstmt_g.close();


}//for
//c.returnConnection(cong);
/*int voucher_type[]=new int[count];
java.sql.Date voucher_date[] = new java.sql.Date[count];
String voucher_no[]=new String[count]; 
for(i=0; i<count; i++)
{
query=	"Select * from  Voucher where Voucher_id=?";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+ft_voucher_id[i]); 
rs_g = pstmt_g.executeQuery();
//out.print("<br>94 query fired" +query);
while(rs_g.next()) 	
{
voucher_type[i]=rs_g.getInt("voucher_type");
voucher_no[i]=rs_g.getString("voucher_no");
voucher_date[i]=rs_g.getDate("Voucher_Date");
}
pstmt_g.close();

}//for
*/
 rlocal=opening_localbalance;
 rdollar=opening_dollarbalance;
double db_localamount =opening_localbalance;
double db_dollaramount = opening_dollarbalance;
double cr_localamount=0;
double cr_dollaramount=0;

k=1;
for(i=0; i<count; i++)
{

if("1".equals(transaction_type[i]))
{
rlocal += local[i];
rdollar += dollar[i];
db_localamount +=local[i];
db_dollaramount +=dollar[i];
}
else{
rlocal =rlocal - local[i];
rdollar =rdollar - dollar[i];
cr_localamount +=local[i];
//System.out.print("cr_localamount=>"+cr_localamount);
cr_dollaramount +=dollar[i];
}
}//for

if(rlocal>0)
		{
cr_localamount +=rlocal;

//System.out.print("161"+cr_localamount);
cr_dollaramount +=rdollar;

	}
else{
db_localamount +=(rlocal*-1);

db_dollaramount +=(rdollar*-1);
}
return ""+rlocal;
}catch(Exception Samyak109){//c.returnConnection(cong);
	return ""+Samyak109;}
	////finally{c.returnConnection(cong); }

}

public static void main(String[] args) throws Exception
	{

		OpeningBalance l = new OpeningBalance();
	
	}
}


