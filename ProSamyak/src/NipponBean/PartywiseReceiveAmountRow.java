package NipponBean;
import java.util.*;
import java.io.*;
import NipponBean.*;

public class PartywiseReceiveAmountRow
{
	int receive_fromId;
	double janamount;
	double febamount;
	double maramount;
	double apramount;
	double mayamount;
	double junamount;
	double julamount;
	double augamount;
	double sepamount;
	double octamount;
	double novamount;
	double decamount;
	//double beforeAprilamount;

	public int getreceive_fromId()
	{
		return this.receive_fromId;
	}
	public double getjanamount()
	{
		return this.janamount;
	}
	public double getfebamount()
	{
		return this.febamount;
	}
	public double getmaramount()
	{
		return this.maramount;
	}
	public double getapramount()
	{
		return this.apramount;
	}
	public double getmayamount()
	{
		return this.mayamount;
	}
	public double getjunamount()
	{
		return this.junamount;
	}
	public double getjulamount()
	{
		return this.julamount;
	}
	public double getaugamount()
	{
		return this.augamount;
	}
	public double getsepamount()
	{
		return this.sepamount;
	}
	public double getoctamount()
	{
		return this.octamount;
	}
	public double getnovamount()
	{
		return this.novamount;
	}
	public double getdecamount()
	{
		return this.decamount;
	}
	//public double getBeforeAprilamount()
	//{
	//	return this.beforeAprilamount;
//	}
	
	PartywiseReceiveAmountRow(int receive_fromId,double janamount,double febamount,double maramount,double apramount,double mayamount,double junamount,double julamount,	double augamount,double sepamount,double octamount,	double novamount,double decamount)
	{
		this.receive_fromId=receive_fromId;
		this.janamount=janamount;
		this.febamount=febamount;
		this.maramount=maramount;
		this.apramount=apramount;
		this.mayamount=mayamount;
		this.junamount=junamount;
		this.julamount=julamount;
		this.augamount=augamount;
		this.sepamount=sepamount;
		this.octamount=octamount;
		this.novamount=novamount;
		this.decamount=decamount;
		//this.beforeAprilamount=beforeAprilamount;

	}
}
