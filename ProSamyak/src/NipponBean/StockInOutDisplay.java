package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;


public class StockInOutDisplay
{

		int sReceive_Id;
		String sReceive_No;
		String sType;
		String sReceive_Date;
		double sReceive_Quantity;
		double sLocal_Total;
		double sDollar_Total;

public  StockInOutDisplay(int sReceive_Id,String sReceive_No,String sType,String sReceive_Date,double sReceive_Quantity,double sLocal_Total,double sDollar_Total)
{
	this.sReceive_Id=sReceive_Id;
	this.sReceive_No=sReceive_No;
	this.sType=sType;
	this.sReceive_Date=sReceive_Date;
	this.sReceive_Quantity=sReceive_Quantity;
	this.sLocal_Total=sLocal_Total;
	this.sDollar_Total=sDollar_Total;
	

}//StockInOutDisplay()

public int getReceive_Id()
{
	return sReceive_Id;
} 
public String getsReceive_No()
{
	return sReceive_No;
} 
public String getsType()
{
	return sType;
} 
public String getsReceive_Date()
{
	return sReceive_Date;
} 
public double getsReceive_Quantity()
{
	return sReceive_Quantity;
} 
public double getsLocal_Total()
{
	return sLocal_Total;
} 
public double getsDollar_Total()
{
	return sDollar_Total;
} 

} //StockInOutDisplay