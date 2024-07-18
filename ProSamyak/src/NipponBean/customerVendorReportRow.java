package NipponBean;
import java.util.*;
import java.io.*;
import NipponBean.*;

public class customerVendorReportRow
{
	String voucher_Id;
	java.sql.Date voucher_Date;
	String particulars[];
	String voucher_Type;
	String voucher_No;
	String voucher_Link;
	String ref_No;
	double localAmt_Dr;
	double localAmt_Cr;
	double local_closing;
	double dollarAmt_Dr;
	double dollarAmt_Cr;
	double dollar_closing;
	String narration;
	String receiveId;
	String ledgerId;
	java.sql.Date Due_Date;
	String Due_Days="";

	public String getVoucher_Id()
	{ 
		return this.voucher_Id;
	}
	
	public java.sql.Date getVoucher_Date()
	{ 
		return this.voucher_Date;
	}

    public String[] getParticulars()
	{ 
		return this.particulars;
	}

    public String getVoucher_Type()
	{ 
		return this.voucher_Type;
	}

	public String getVoucher_No()
	{ 
		return this.voucher_No;
	}

	public String getVoucher_Link()
	{ 
		return this.voucher_Link;
	}
    
	public String getRef_No()
	{ 
		return this.ref_No;
	}

    public double getLocalAmt_Dr()
	{ 
		return this.localAmt_Dr;
	}
    
	public double getLocalAmt_Cr()
	{ 
		return this.localAmt_Cr;
	}
	
	public double getDollarAmt_Dr()
	{ 
		return this.dollarAmt_Dr;
	}

	public double getDollarAmt_Cr()
	{ 
		return this.dollarAmt_Cr;
	}
    
	public String getNarration()
	{ 
		return this.narration;
	}

	public String getReceiveId()
	{ 
		return this.receiveId;
	}
	public String getLedgerId()
	{ 
		return this.ledgerId;
	}
	public java.sql.Date getDueDate()
	{ 
		return this.Due_Date;
	}
	public String getDueDays()
	{ 
		return this.Due_Days;
	}

	customerVendorReportRow(String voucher_Id, java.sql.Date voucher_Date, String[] particulars, String voucher_Type, String voucher_No, String voucher_Link, String ref_No, double localAmt_Dr, double localAmt_Cr, double dollarAmt_Dr, double dollarAmt_Cr, String narration, String receiveId ,String ledgerId,java.sql.Date Due_Date,String Due_Days)
    {
		this.voucher_Id = voucher_Id;
		this.voucher_Date = voucher_Date;
		this.particulars = particulars;
		this.voucher_Type = voucher_Type;
		this.voucher_No = voucher_No;
		this.voucher_Link = voucher_Link;
		this.ref_No = ref_No;
		this.localAmt_Dr = localAmt_Dr;
		this.localAmt_Cr = localAmt_Cr;
		this.dollarAmt_Dr = dollarAmt_Dr;
		this.dollarAmt_Cr = dollarAmt_Cr;
		this.narration = narration; 
		this.receiveId = receiveId; 
		this.ledgerId = ledgerId;
		this.Due_Date = Due_Date;
		this.Due_Days = Due_Days;
	}

}
