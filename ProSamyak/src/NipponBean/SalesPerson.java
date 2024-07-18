package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.*;
import NipponBean.*;

public class SalesPerson
{
	private double qty;
	private double local_quantity;
	private double dollar_quantity;
	private int id;
	public SalesPerson()
	{
	}
	public void setQuantity(double qty)
	{
		 this.qty= qty;
	}
	public void setLocalTotal(double local_quantity)
	{
		this.local_quantity=local_quantity;
	}
	public void setDollarTotal(double dollar_quantity)
	{
		this.dollar_quantity=dollar_quantity;
	}
	public void setId(int id)
	{
		this.id=id;
	}
	public double getQuantity()
	{
		return qty;
	}
	public double getLocalTotal()
	{
		return local_quantity;
	}
	public double getDollarTotal()
	{
		return dollar_quantity;
	}
	public int getId()
	{
		return id;
	}
}