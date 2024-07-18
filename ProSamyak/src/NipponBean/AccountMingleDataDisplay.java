package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;

public class AccountMingleDataDisplay
{
		java.sql.Date Inv_Date=null;
		java.sql.Date Due_Date=null;
		java.sql.Date GressDue_Date=null;
	

		String Perticulars[];
		String Voucher_Type =" ";
		String Voucher_No =" ";
		String Ref_No =" ";
		
		double debitLocal =0;
		double creditLocal =0;

		double debitDollar =0;
		double creditDollar =0;

		double closingLocal =0;
		double closingDollar =0;
	
	public java.sql.Date getInvDate()
	{
		return this.Inv_Date;
	}

	public java.sql.Date getDueDate()
	{
		return this.Due_Date;
	}

	public java.sql.Date getGressDueDate()
	{
		return this.GressDue_Date;
	}
		
	public String[] getPerticulars()
	{ 
		return this.Perticulars;
	}
	
	public String getVoucherType()
	{ 
		return this.Voucher_Type;
	}

	public String getVoucherNo()
	{ 
		return this.Voucher_No;
	}
	public String getRefNo()
	{
		return this.Ref_No;
	}
	
	public double getDebitLocal()
	{ 
		return this.debitLocal;
	}

	public double getCreditLocal()
	{
		return this.creditLocal;
	}
	public double getDebitDollar()
	{
		return this.debitDollar;
	}
	public double getCreditDollar()
	{
		return this.creditDollar;
	}

	public double getclosingLocal()
	{ 
		return this.closingLocal;
	}
	public double getclosingDollar()
	{ 
		return this.closingDollar;
	}
		
	public AccountMingleDataDisplay( java.sql.Date InvDate,java.sql.Date DueDate, java.sql.Date GressDueDate, String[] Perticulars,String Voucher_Type,String Voucher_No,String Ref_No,double debitLocal,double creditLocal,double debitDollar,double creditDollar,double closingLocal,double closingDollar)
    {
		this.Inv_Date = InvDate;
		this.Due_Date = DueDate;
		this.GressDue_Date = GressDueDate;
		
		this.Perticulars = Perticulars;
		this.Voucher_Type=Voucher_Type;
		this.Voucher_No=Voucher_No;
		this.Ref_No=Ref_No;

		this.debitLocal=debitLocal;
		this.creditLocal=creditLocal;
		this.debitDollar=debitDollar;
		this.creditDollar=creditDollar;

		this.closingLocal=closingLocal;
		this.closingDollar=closingDollar;

	}//end constructer New_MemoInData ( String-5 , Date-3 ,  String-8 )
}//end class New_MemoInData


