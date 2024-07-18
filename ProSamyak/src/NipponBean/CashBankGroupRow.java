package NipponBean;
import java.util.*;
import java.io.*;
import NipponBean.*;

public class CashBankGroupRow
{
	String accountId;
	String accountName;
	double localOpening_Dr;
	double dollarOpening_Dr;
	double localOpening_Cr;
	double dollarOpening_Cr;
	double localTrans_Dr;
	double dollarTrans_Dr;
	double localTrans_Cr;
	double dollarTrans_Cr;
	double localClosing_Dr;
	double dollarClosing_Dr;
	double localClosing_Cr;
	double dollarClosing_Cr;


	public double getDollarClosing_Cr() {
		return dollarClosing_Cr;
	}
	public double getDollarClosing_Dr() {
		return dollarClosing_Dr;
	}
	public double getDollarOpening_Cr() {
		return dollarOpening_Cr;
	}
	public double getDollarOpening_Dr() {
		return dollarOpening_Dr;
	}
	public double getDollarTrans_Cr() {
		return dollarTrans_Cr;
	}
	public double getDollarTrans_Dr() {
		return dollarTrans_Dr;
	}
	public String getAccountId() {
		return accountId;
	}
	public String getAccountName() {
		return accountName;
	}
	public double getLocalClosing_Cr() {
		return localClosing_Cr;
	}
	public double getLocalClosing_Dr() {
		return localClosing_Dr;
	}
	public double getLocalOpening_Cr() {
		return localOpening_Cr;
	}
	public double getLocalOpening_Dr() {
		return localOpening_Dr;
	}
	public double getLocalTrans_Cr() {
		return localTrans_Cr;
	}
	public double getLocalTrans_Dr() {
		return localTrans_Dr;
	}
	
	
	public CashBankGroupRow(String accountId, String accountName,		double localOpening_Dr, double dollarOpening_Dr, double localOpening_Cr, double dollarOpening_Cr, double localTrans_Dr, double dollarTrans_Dr, double localTrans_Cr, double dollarTrans_Cr, double localClosing_Dr,	double dollarClosing_Dr, double localClosing_Cr,	double dollarClosing_Cr) {

		this.accountId = accountId;
		this.accountName = accountName;
		this.localOpening_Dr = localOpening_Dr;
		this.dollarOpening_Dr = dollarOpening_Dr;
		this.localOpening_Cr = localOpening_Cr;
		this.dollarOpening_Cr = dollarOpening_Cr;
		this.localTrans_Dr = localTrans_Dr;
		this.dollarTrans_Dr = dollarTrans_Dr;
		this.localTrans_Cr = localTrans_Cr;
		this.dollarTrans_Cr = dollarTrans_Cr;
		this.localClosing_Dr = localClosing_Dr;
		this.dollarClosing_Dr = dollarClosing_Dr;
		this.localClosing_Cr = localClosing_Cr;
		this.dollarClosing_Cr = dollarClosing_Cr;
	}

}
