package NipponBean;
import java.util.*;
import java.io.*;
import NipponBean.*;

public class DueReportRow
{
	int Receive_Id;
	String receive_no;
	int Receive_fromid;
	java.sql.Date Receive_Date;
	int duedays;
	java.sql.Date Due_Date;
	int overduedays;
	double Receive_Total;
	double Local_Total;
	double Dollar_Total;
	int salesperson_id;
	String Company_Party_Name;
	String Salesperson_Name;
	double ReceivedLocal_Total;
	double ReceivedDollar_Total;
	double Local_Balance;
	double Dollar_Balance;
	String Ref_No;
	int PurchaseSaleGroup_Id;
	String PurchaseSaleGroup_Name;
	

	public int getReceive_Id()
	{ 
		return this.Receive_Id;
	}
	
	public String getReceive_no()
	{ 
		return this.receive_no;
	}

    public int getReceive_fromid()
	{ 
		return this.Receive_fromid;
	}

	public int getDuedays()
	{ 
		return this.duedays;
	}

    public java.sql.Date getReceive_Date()
	{ 
		return this.Receive_Date;
	}

	public java.sql.Date getDue_Date()
	{ 
		return this.Due_Date;
	}

	public int getOverduedays()
	{ 
		return this.overduedays;
	}

	public double getReceive_Total()
	{ 
		return this.Receive_Total;
	}
    
	public double getLocal_Total()
	{ 
		return this.Local_Total;
	}

    public double getDollar_Total()
	{ 
		return this.Dollar_Total;
	}
    
	public int getSalesperson_id()
	{ 
		return this.salesperson_id;
	}
	
	public String getCompany_Party_Name()
	{ 
		return this.Company_Party_Name;
	}

	public String getSalesperson_Name()
	{ 
		return this.Salesperson_Name;
	}
    
	public double getReceivedLocal_Total()
	{ 
		return this.ReceivedLocal_Total;
	}

	public double getReceivedDollar_Total()
	{ 
		return this.ReceivedDollar_Total;
	}

	public double getLocal_Balance()
	{ 
		return this.Local_Balance;
	}

	public double getDollar_Balance()
	{ 
		return this.Dollar_Balance;
	}

	public String getRef_No()
	{ 
		return this.Ref_No;
	}

	public int getPurchaseSaleGroup_Id()
	{ 
		return this.PurchaseSaleGroup_Id;
	}
	
	public String getPurchaseSaleGroup_Name()
	{ 
		return this.PurchaseSaleGroup_Name;
	}

	DueReportRow(int Receive_Id, String receive_no, int Receive_fromid, java.sql.Date Receive_Date, int duedays, java.sql.Date Due_Date, int overduedays, double Receive_Total, double Local_Total, double Dollar_Total, int salesperson_id, String Company_Party_Name,	String Salesperson_Name, double ReceivedLocal_Total, double ReceivedDollar_Total, double Local_Balance, double Dollar_Balance, String Ref_No, int PurchaseSaleGroup_Id, String PurchaseSaleGroup_Name)
    {
		this.Receive_Id = Receive_Id;
		this.receive_no = receive_no;
		this.Receive_fromid = Receive_fromid;
		this.Receive_Date = Receive_Date;
		this.duedays = duedays;
		this.Due_Date = Due_Date;
		this.overduedays = overduedays;
		this.Receive_Total = Receive_Total;
		this.Local_Total = Local_Total;
		this.Dollar_Total = Dollar_Total;
		this.salesperson_id = salesperson_id;
		this.Company_Party_Name = Company_Party_Name;
		this.Salesperson_Name = Salesperson_Name;
		this.ReceivedLocal_Total = ReceivedLocal_Total; 
		this.ReceivedDollar_Total = ReceivedDollar_Total; 
		this.Local_Balance = Local_Balance; 
		this.Dollar_Balance = Dollar_Balance; 
		this.Ref_No = Ref_No; 
		this.PurchaseSaleGroup_Id = PurchaseSaleGroup_Id; 
		this.PurchaseSaleGroup_Name = PurchaseSaleGroup_Name; 
	}

}
