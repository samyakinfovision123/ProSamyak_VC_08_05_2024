package NipponBean;
import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import NipponBean.*;

public class  GlobalOpeningClosingStock
{
	Connection cong = null;
	Connection conp = null;
	ResultSet rs_g= null;
	PreparedStatement pstmt_g=null;
	String errLine="15";
	String qtyLocalAmtDollarAmt="";
	Array A=new Array();
	Inventory I=new Inventory();
	YearEndDate YED=new YearEndDate();
public String getOpeningClosingStock(Connection cong,Connection conp,int dd1,int mm1,int yy1,String location_id,String ratetype,String category_id,String subcategory_id,String company_id)
{
try
	{
String order_by="lot_no";
String group_by="lot_no";
String Strshowamount="yes";
String currency="both";
String rangeStart="0.00";
String rangeEnd="0.00";
String range="exclude";
//String lotRangeStart="";
//String lotRangeEnd="";
String command="Financial Stock";

if(company_id == null || "-1".equals(company_id))
{
	//company_id = request.getParameter("company_id");
}

String baseCurrencySymbol= "";//+session.getValue("baseCurrencySymbol");
String localCurrencySymbol= I.getLocalSymbol(cong,company_id);
//System.out.println("42 localCurrencySymbol="+localCurrencySymbol);
String company_name= A.getName(cong,"companyparty",company_id);

String lotdescriptionf = "";
String summary = "";
String showamount = "";
String showTopRows = "";
//String currency = "both";
String grossprofitf="";
String combinef = "";
String conditionf = "";
String differencef="";
String rangeStartf=rangeStart;
String rangeEndf=rangeEnd;
String selectedgroup_id[] = new String[0];
//String group_by = "";
String groupIdList = "-999";
String groupTableName = "";
String groupColName = "";
String groupColNmName = "";
//String ratetype = "EffPurchaseRate"; //default Purchase Rate 
String rateName = "Eff. Purchase Price"; //default Purchase Rate 
double exchange_rate=0;

errLine = "56";	
	//if(request.getParameter("ratetype") != null)
		//ratetype = request.getParameter("ratetype");

	if("EffPurchaseRate".equals(ratetype))
		rateName = "Eff. Purchase Price";
	else if("EffSaleRate".equals(ratetype))
		rateName = "Eff. Sale Price";
	else if("Running".equals(ratetype))
		rateName = "Running Rate";
	else if("AvgPur".equals(ratetype))
		rateName = "Avg. Purchase";
	else if("OpeningRate".equals(ratetype))
		rateName = "Opening Rate";
	else if("LastPurchaseRate".equals(ratetype))
		rateName = "Last Purchase Rate";
	else if("LastSaleRate".equals(ratetype))
		rateName = "Last Sale Rate";

	//if(showTopRows != null) 
		//showTopRows = showTopRows; 
	
	//if(showamount= null) 
	//	showamount = request.getParameter("showamount"); 

	//if(request.getParameter("summary") != null) 
	//	summary = request.getParameter("summary"); 

	//if(request.getParameter("currency") != null) 
	//	currency = request.getParameter("currency"); 

	//if(request.getParameter("lotdescription") != null) 
	//	lotdescriptionf = request.getParameter("lotdescription"); 

	//if(request.getParameter("grossprofit") != null) 
	//	grossprofitf = request.getParameter("grossprofit"); 
	
	//if(request.getParameter("rangeStart") != null) 
	//	rangeStartf = request.getParameter("rangeStart"); 
	
	double start=Double.parseDouble(rangeStartf);
	
	//if(request.getParameter("rangeEnd") != null) 
	//	rangeEndf = request.getParameter("rangeEnd"); 
	
	double  end=Double.parseDouble(rangeEndf);
	String selectrange = "exclude";
   errLine = "113";	 
	//if(request.getParameter("range") != null) 
	//	selectrange = request.getParameter("range"); 

	//if(request.getParameter("group_by") != null) 
	//	group_by = request.getParameter("group_by"); 

	//if("yes".equals(showTopRows)) //show top rows by lot no
	//	group_by = "lot_no";

	//if(request.getParameter("group_id") != null)
	//	selectedgroup_id = request.getParameterValues("group_id");
	String group_id1="";
	for(int i=0; i<selectedgroup_id.length; i++)
	{
		//out.print("<br>59 group_id["+i+"]="+group_id[i]);
		groupIdList += "," + selectedgroup_id[i];
	}

	groupIdList = "(" + groupIdList + ")";
	
	String groupIdCondition = "";

	String lotRangeSelect1= "";//request.getParameter("lotRangeSelect");
    if(! "yes".equals(lotRangeSelect1))
	{
		if( "group".equals(group_by) )
		{
			groupIdCondition += " and Group_Id IN "+groupIdList;
			groupTableName = "Master_Group";
			groupColName = "Group_Id";
			groupColNmName = "Group_Name";
		}
		if( "clarity".equals(group_by) )
		{
			groupIdCondition += " and Purity_Id IN "+groupIdList;
			groupTableName = "Master_Purity";
			groupColName = "Purity_Id";
			groupColNmName = "Purity_Name";
		}
		if( "cut".equals(group_by) )
		{
			groupIdCondition += " and Cut_Id IN "+groupIdList;
			groupTableName = "Master_Cut";
			groupColName = "Cut_Id";
			groupColNmName = "Cut_Name";
		}
		if( "color".equals(group_by) )
		{
			groupIdCondition += " and Color_Id IN "+groupIdList;
			groupTableName = "Master_Color";
			groupColName = "Color_Id";
			groupColNmName = "Color_Name";
		}
		if( "lot_no".equals(group_by) )
		{
			try
			{
				errLine = "151";
				groupIdList = "-999";
				groupTableName = "Master_Group";
				groupColName = "Group_Id";
				groupColNmName = "Group_Name";

				String groupquery="";
				//loading all the group ids when a lot_no wise display is selected
				groupquery="Select count(*) as Group_Count from "+groupTableName+" where  active=1";
				//System.out.print(groupquery);
				pstmt_g =cong.prepareStatement(groupquery);
				rs_g = pstmt_g.executeQuery();

				int groupCount=0;
				while(rs_g.next())
				{
					groupCount = rs_g.getInt("Group_Count");
				}
				pstmt_g.close();

				selectedgroup_id = new String[groupCount];
						
				errLine = "173";
				groupquery="Select "+groupColName+" from "+groupTableName+" where  active=1 order by "+groupColName+"";
				//System.out.print(groupquery);
				pstmt_g =cong.prepareStatement(groupquery);
				rs_g = pstmt_g.executeQuery();

				int c=0;
				while(rs_g.next())
				{
					selectedgroup_id[c] = rs_g.getString(groupColName);
					c++;
				}
				pstmt_g.close();

				for(int i=0; i<selectedgroup_id.length; i++)
				{
					groupIdList += "," + selectedgroup_id[i];
				}

				groupIdList = "(" + groupIdList + ")";
				groupIdCondition += " and "+groupColName+" IN "+groupIdList;
				//System.out.println(groupIdCondition);
				
			}
			catch (Exception e)
			{
				//C.returnConnection(cong);
				//C.returnConnection(conp);
				System.out.println("<BR>"+errLine+"EXCEPTION="+e);
			}

			groupIdCondition += " and Group_Id IN "+groupIdList;
			groupTableName = "Master_Group";
			groupColName = "Group_Id";
			groupColNmName = "Group_Name";
		}
		
	}
	else//if lot range is selected then use this block
	{
		errLine = "213";
		try
		{
			if( "group".equals(group_by) )
			{
				groupTableName = "Master_Group";
				groupColName = "Group_Id";
				groupColNmName = "Group_Name";
			}
			if( "lot_no".equals(group_by) ) //use to get the data not for display for lot_no wise display
			{
				groupTableName = "Master_Group";
				groupColName = "Group_Id";
				groupColNmName = "Group_Name";
			}
			if( "clarity".equals(group_by) )
			{
				groupTableName = "Master_Purity";
				groupColName = "Purity_Id";
				groupColNmName = "Purity_Name";
			}
			if( "cut".equals(group_by) )
			{
				groupTableName = "Master_Cut";
				groupColName = "Cut_Id";
				groupColNmName = "Cut_Name";
			}
			if( "color".equals(group_by) )
			{
				groupTableName = "Master_Color";
				groupColName = "Color_Id";
				groupColNmName = "Color_Name";
			}
			if(group_id1== null )
			{

				groupIdList = "-999";
				errLine = "250";

				String groupquery="";
				//loading all the group ids when a lot range is selected
				groupquery="Select count(*) as Group_Count from "+groupTableName+" where  active=1";
				//System.out.print(groupquery);
				pstmt_g =cong.prepareStatement(groupquery);
				rs_g = pstmt_g.executeQuery();

				int groupCount=0;
				while(rs_g.next())
				{
					groupCount = rs_g.getInt("Group_Count");
				}
				pstmt_g.close();

				selectedgroup_id = new String[groupCount];
				errLine = "267";
						
				groupquery="Select "+groupColName+" from "+groupTableName+" where  active=1 order by "+groupColName+"";
				//System.out.print(groupquery);
				pstmt_g =cong.prepareStatement(groupquery);
				rs_g = pstmt_g.executeQuery();

				int c=0;
				while(rs_g.next())
				{
					selectedgroup_id[c] = rs_g.getString(groupColName);
					c++;
				}
				pstmt_g.close();

				for(int i=0; i<selectedgroup_id.length; i++)
				{
					groupIdList += "," + selectedgroup_id[i];
				}

				groupIdList = "(" + groupIdList + ")";
				groupIdCondition += " and "+groupColName+" IN "+groupIdList;
				//System.out.println(groupIdCondition);
			}
		}
		catch (Exception e)
		{
			//C.returnConnection(cong);
			//C.returnConnection(conp);
			System.out.println("<BR>"+errLine+"EXCEPTION="+e);
		}
	}

	errLine = "300";
	java.sql.Date D = new java.sql.Date(System.currentTimeMillis());

	java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());

	try{

		String startdatequery = "Select From_Date from YearEnd where yearend_id IN (Select MIN(yearend_id) from YearEnd where company_id="+company_id+" and Active=1)";

		pstmt_g = cong.prepareStatement(startdatequery);
		rs_g  = pstmt_g.executeQuery();
		errLine = "311";
		
		while(rs_g.next())
		{
			startDate = rs_g.getDate("From_Date");
		}
		pstmt_g.close();
	}
	catch (Exception e)
	{
		//C.returnConnection(cong);
		//C.returnConnection(conp);
		System.out.println("<BR>"+errLine+"EXCEPTION="+e);
	}

	int sdd1 = startDate.getDate();
	int smm1 = startDate.getMonth() + 1;
	int syy1 = startDate.getYear() + 1900;

	errLine = "330";
	//System.out.println("At 147 company_id="+company_id);
	//System.out.println("At 147 cong="+cong);
	
	String local_currency= I.getLocalCurrency(cong,company_id);
	int d= Integer.parseInt(A.getName(cong,"Master_Currency", "Decimal_Places","Currency_id",local_currency));
	errLine = "354";
	String local_symbol= I.getLocalSymbol(cong,company_id);
	String currency_name=A.getName(cong,"Master_Currency", "Currency_Name","Currency_id",local_currency);
	errLine = "357";
	int year=D.getYear();
	year =year-1;
	int method= 0; 
	int dd=D.getDate();
	int mm=D.getMonth();
	
	java.sql.Date Dprevious = new java.sql.Date((year),(mm),dd);
	//String command=request.getParameter("command");
	String SaveStock="";//request.getParameter("SaveStock");

	//int dd1 = Integer.parseInt(request.getParameter("dd1"));
	//int mm1 = Integer.parseInt(request.getParameter("mm1"));
	//int yy1 = Integer.parseInt(request.getParameter("yy1"));
	java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
	String reportyearend_id = YED.returnYearEndId(cong , pstmt_g, 	rs_g, D1, company_id);

	//String order_by= request.getParameter("order_by");
	//String category_id= request.getParameter("category_id");
	//String subcategory_id= request.getParameter("subcategory_id");
	//String location_id= request.getParameter("location_id");
	String lotLocationCondition="";
	String condition="";
	String report_name="Category ";
	errLine = "360";

	//out.print("<br>Start : "+start+"  End : "+end );
if("0".equals(category_id))
{
condition= condition + ""; 
report_name=report_name + "ALL";
}
else
{
condition=condition + "and LotCategory_Id="+category_id+""; 
report_name =report_name + A.getName(conp,"LotCategory",category_id);
}
report_name=report_name +" & SubCategory ";

if("0".equals(subcategory_id))
{condition=condition + ""; report_name=report_name + "ALL";}
else
{condition= condition + "and LotSubCategory_Id="+subcategory_id+""; 
report_name=report_name+ A.getName(conp,"LotSubCategory",subcategory_id);} 

report_name=report_name +" & Location ";
if("0".equals(location_id))
{
	lotLocationCondition=lotLocationCondition + "";
	report_name=report_name + "ALL";
}
else
{	
	lotLocationCondition= lotLocationCondition + "and RT.Location_Id="+location_id+""; 
	report_name=report_name+ A.getName(conp,"Location",location_id);
} 

errLine = "393";
String lotRangeStart="";
String lotRangeEnd="";

String lotRangeSelect="";// request.getParameter("lotRangeSelect");
if("yes".equals(lotRangeSelect))
{
  //lotRangeStart = request.getParameter("lotRangeStart");
  //lotRangeEnd = request.getParameter("lotRangeEnd");	
	condition = condition + " and lot_no between '"+lotRangeStart+"' and '"+lotRangeEnd+"' ";

	report_name=report_name+ "<br> Lot Range from : "+lotRangeStart+" to : "+lotRangeEnd;
}

try

{
	errLine = "410";
	String exchnage_rateQuery1="Select exchange_rate from Master_ExchangeRate where exchange_date='"+D+"' and yearend_id in (select yearend_id from YearEnd where company_id="+company_id+")";
	pstmt_g =cong.prepareStatement(exchnage_rateQuery1);
	rs_g = pstmt_g.executeQuery();

	while(rs_g.next())
	{
		exchange_rate=Double.parseDouble(rs_g.getString("exchange_rate"));
	}
	pstmt_g.close();
	//out.print("<br>158 exchange_rate="+exchange_rate);

	String query="";
	//loading the masters once for size, description and group names
	query="Select "+groupColName+", "+groupColNmName+" from "+groupTableName+" where  active=1 order by "+groupColName+"";
	//out.print(query);
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	errLine = "429";	

	Hashtable Group_Name = new Hashtable();

	while(rs_g.next())
	{
		Group_Name.put(rs_g.getInt(groupColName), rs_g.getString(groupColNmName));
	}
	pstmt_g.close();
	

	query="Select Size_Id, Size_Name from Master_Size where  active=1 order by size_id";
	//out.print(query);
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	errLine = "445";	

	Hashtable Size_Name = new Hashtable();

	while(rs_g.next())
	{
		Size_Name.put(rs_g.getInt("Size_Id"), rs_g.getString("Size_Name"));
	}
	pstmt_g.close();
	

	query="Select Description_Id, Description_Name from Master_Description where  active=1 order by Description_id";
	//out.print(query);
	pstmt_g =cong.prepareStatement(query);
	rs_g = pstmt_g.executeQuery();

	errLine = "461";	

	Hashtable Description_Name= new Hashtable();

	while(rs_g.next())
	{
		Description_Name.put(rs_g.getInt("Description_Id"), rs_g.getString("Description_Name"));
	}
	pstmt_g.close();
	

	//loading the diamond stock as per the selection criteria
	errLine = "473";	
	String lotcondition="where active=1";

	query="Select L.Lot_id, L.Lot_No, L.Unit_id, D.D_Size, D."+groupColName+", D.Description_Id from Lot L, Diamond D where L.Lot_Id=D.Lot_Id and active=1 and created_on <='"+D1+"' and Company_id="+company_id+" "+condition+" "+groupIdCondition+" order by L."+order_by;
	
	//out.print(query);
	
	pstmt_g =cong.prepareStatement(query,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rs_g = pstmt_g.executeQuery();

	int count=0;
	
	rs_g.last();
	count=rs_g.getRow();
	rs_g.beforeFirst();
	
	int counter =count;
	//out.print("counter"+counter);

	errLine = "492";	

	long lot_id[]= new long[count];
	String lot_no[]= new String[count];
	String uom[]= new String[count];
	int description_id[]= new int[count];
	int size_id[]= new int[count];
	int group_id[]= new int[count];

	double carats[]=new double[count];
	double local_price[]=new double[count];
	double dollar_price[]=new double[count];
	double pcarats[]=new double[count];
	double plocal_price[]=new double[count];
	double pdollar_price[]=new double[count];
	double ccarats[]=new double[count];
	double clocal_price[]=new double[count];
	double cdollar_price[]=new double[count];
	double per_carats[]=new double[count];
	double sale_carats[]=new double[count];
	double per_ccarats[]=new double[count];
	double sale_ccarats[]=new double[count];
	double ConfirmPurQty[]=new double[count];
	double ConfirmSaleQty[]=new double[count];
	
	double gross[]=new double[count];
	double gross_purchase[]=new double[count];
	double gross_sale[]=new double[count];
	double gross_pur_qty[]=new double[count];
	double gross_sale_qty[]=new double[count];
	
	//Array -- For Quantity
	double consignment_in_qty[]=new double[count];
	double consignment_out_qty[]=new double[count];
	double consignment_sale_return_qty[]=new double[count];
	double consignment_sale_confirm_qty[]=new double[count];
	double consignment_purchase_return_qty[]=new double[count];
	double consignment_purchase_confirm_qty[]=new double[count];
	double consignment_inward_qty[]=new double[count];
	double consignment_outward_qty[]=new double[count];

	double financial_in_qty[]=new double[count];
	double financial_out_qty[]=new double[count];
	double financial_sale_qty[]=new double[count];
	double financial_sale_return_qty[]=new double[count];
	double financial_purchase_qty[]=new double[count];
	double financial_purchase_return_qty[]=new double[count];
	double opening_stock_qty[]=new double[count];
	double stock_transfer_qty[]=new double[count];


	
	double gross_purchase_var =0.0;
	double gross_sale_var =0.0;
	double gross_purchase_qty_var=0.0;
	double gross_sale_qty_var =0.0;

	//Variables -- For Quantity
	double consignment_in_qty_var=0;
	double consignment_out_qty_var=0;
	double consignment_sale_return_qty_var=0;
	double consignment_sale_confirm_qty_var=0;
	double consignment_purchase_return_qty_var=0;
	double consignment_purchase_confirm_qty_var=0;
	double financial_in_qty_var=0;
	double financial_out_qty_var=0;
	double financial_sale_qty_var=0;
	double financial_sale_return_qty_var=0;
	double financial_sale_confirm_qty_var=0;
	double financial_purchase_qty_var=0;
	double financial_purchase_return_qty_var=0;
	double opening_stock_qty_var=0;
	double stock_transfer_qty_var=0;

	
	int c=0;

	while(rs_g.next())
	{
		lot_id[c]=rs_g.getLong("Lot_id");
		lot_no[c]=rs_g.getString("Lot_No");
		//out.print("<br>"+lot_no[c]+" #lot_id["+c+"]="+lot_id[c]);
		uom[c]=A.getName(cong,"Unit",rs_g.getString("Unit_id"));
		size_id[c]=rs_g.getInt("D_Size");
		group_id[c]=rs_g.getInt(groupColName);
		description_id[c]=rs_g.getInt("Description_Id");
		c++;
	}

	pstmt_g.close();


	//calculating lot's effective rates for opening and closing date if purchase rate or sale rate is selected
	Hashtable HashEffectiveRate = new Hashtable();
	if(ratetype.equals("EffPurchaseRate"))
	{
		String lotIdSet = "-1";
		for(int i=0;i<lot_id.length;i++)
		{
			lotIdSet += ", " + lot_id[i];
		} //for

		String strQuery="SELECT Lot_Id, Purchase_Price FROM Effective_Rate ER1 WHERE Lot_Id IN ( "+lotIdSet+" ) and Effective_Date IN(SELECT MAX(Effective_Date) FROM Effective_Rate ER2 WHERE  Effective_Date <= '"+D1+"' and ER1.Lot_Id=ER2.Lot_Id and active=1)and active =1 "; 
		
		//out.print("<br>503 strQuery="+strQuery);
		pstmt_g =cong.prepareStatement(strQuery);
		rs_g = pstmt_g.executeQuery();
		boolean gotRate = false;
		while(rs_g.next())
		{
			HashEffectiveRate.put(rs_g.getLong("Lot_Id"), rs_g.getDouble("Purchase_Price"));
			gotRate = true;
		} //end of while
		pstmt_g.close();

		if(!gotRate)
		{
			for(int i=0;i<lot_id.length;i++)
			{
				Double norate  = 0.0;
				HashEffectiveRate.put(lot_id[i], norate);
			}
		}
	}

	if(ratetype.equals("EffSaleRate"))
	{
		String lotIdSet = "-1";
		for(int i=0;i<lot_id.length;i++)
		{
			lotIdSet += ", " + lot_id[i];
		} //for

		String strQuery="SELECT Lot_Id, Selling_Price FROM Effective_Rate ER1 WHERE Lot_Id IN ( "+lotIdSet+" ) and Effective_Date IN(SELECT MAX(Effective_Date) FROM Effective_Rate ER2 WHERE  Effective_Date <= '"+D1+"' and ER1.Lot_Id=ER2.Lot_Id and Active=1) and Active=1"; 
		
		//out.print("<br>503 strQuery="+strQuery);
		pstmt_g =cong.prepareStatement(strQuery);
		rs_g = pstmt_g.executeQuery();
		boolean gotRate = false;
		while(rs_g.next())
		{
			HashEffectiveRate.put(rs_g.getLong("Lot_Id"), rs_g.getDouble("Selling_Price"));
			gotRate = true;
		} //end of while
		pstmt_g.close();

		if(!gotRate)
		{
			for(int i=0;i<lot_id.length;i++)
			{
				Double norate  = 0.0;
				HashEffectiveRate.put(lot_id[i], norate);
			}
		}
	}

	if(ratetype.equals("LastPurchaseRate"))
	{
		//initialise the hashtable with zero
		for(int i=0;i<lot_id.length;i++)
		{
				Double norate  = 0.0;
				HashEffectiveRate.put(lot_id[i], norate);
		}

		String lotIdSet = "-1";
		for(int i=0;i<lot_id.length;i++)
		{
			lotIdSet += ", " + lot_id[i];
		} //for

		String strQuery="SELECT Lot_Id, Dollar_Price FROM Receive_Transaction RT1 WHERE Lot_Id IN ( "+lotIdSet+" ) and ReceiveTransaction_Id IN (SELECT MAX(ReceiveTransaction_Id) FROM Receive R, Receive_Transaction RT2 WHERE  R.Stock_Date <= '"+D1+"' and RT1.Lot_Id=RT2.Lot_Id and R.Receive_Sell=1 and R.Purchase=1 and StockTransfer_Type=0 and R.R_Return=0 and R.Opening_Stock=0 and R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id)"; 
		
		//out.print("<br>503 strQuery="+strQuery);
		pstmt_g =cong.prepareStatement(strQuery);
		rs_g = pstmt_g.executeQuery();
	
		while(rs_g.next())
		{
			HashEffectiveRate.put(rs_g.getLong("Lot_Id"), rs_g.getDouble("Dollar_Price"));
		} //end of while
		pstmt_g.close();

		
	}

	if(ratetype.equals("LastSaleRate"))
	{
		for(int i=0;i<lot_id.length;i++)
		{
			Double norate  = 0.0;
			HashEffectiveRate.put(lot_id[i], norate);
		}
		String lotIdSet = "-1";
		for(int i=0;i<lot_id.length;i++)
		{
			lotIdSet += ", " + lot_id[i];
		} //for

		String strQuery="SELECT Lot_Id, Dollar_Price FROM Receive_Transaction RT1 WHERE Lot_Id IN ( "+lotIdSet+" ) and ReceiveTransaction_Id IN (SELECT MAX(ReceiveTransaction_Id) FROM Receive R, Receive_Transaction RT2 WHERE  R.Stock_Date <= '"+D1+"' and RT1.Lot_Id=RT2.Lot_Id and R.Receive_Sell=0 and R.Purchase=1 and StockTransfer_Type=0 and R.R_Return=0 and  R.Opening_Stock=0 and R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id)"; 
		
		//out.print("<br>503 strQuery="+strQuery);
		pstmt_g =cong.prepareStatement(strQuery);
		rs_g = pstmt_g.executeQuery();
		boolean gotRate = false;
		while(rs_g.next())
		{
			HashEffectiveRate.put(rs_g.getLong("Lot_Id"), rs_g.getDouble("Dollar_Price"));
		} //end of while
		pstmt_g.close();
	}
	
	//now divide the lots into some fixed proportion and then fire the query

	int lotIndex = 0; //points to first lot in the list
	int brkPoint = counter / 50;
	int ik=0;
	int divstart = 0;
	int divend = 0;

	double localp=0;
	double localp_temp=0;
	double tqty=0;
	double totalQty=0;
	double totalQty_avgPurchase=0;
	double tqty_temp=0;
	double dollarp=0;
	double dollarp_temp=0;
	double tqty_temp_avgPurchase=0;

	errLine = "666";	
	while(divstart < counter)
	{
		divend += brkPoint;
		if(brkPoint==0)
			divend=counter-1;
	// relation betn receieve and recieve	_transaction
		String condn="";
	
		//out.print("<br>257 lot_no["+divend+"] :"+lot_no[divend]);

		String lotIdSet = "-1";
		for(int z=divstart; z<=divend; z++)
		{
			lotIdSet += ", " + lot_id[z];
		}


		condn = "and L.lot_Id IN ( "+lotIdSet+") ";

		
		query="Select RT.ReceiveTransaction_Id,RT.Receive_Id,  RT.Consignment_ReceiveId, R.purchase, R.receive_sell, R.R_Return, R.StockTransfer_Type,R.Opening_Stock, RT.Lot_id, RT.Available_Quantity, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id  and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? "+condn+" "+lotLocationCondition+" order by L."+order_by+", R.Stock_Date, R.Receive_Sell desc, R.Receive_Id, RT.ReceiveTransaction_id ";

		//System.out.print("query" + query);

		pstmt_g = cong.prepareStatement(query , ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		pstmt_g.setString(1,""+D1);
		pstmt_g.setString(2,company_id); 
		pstmt_g.setString(3,reportyearend_id); 
		//out.print("<br> "+reportyearend_id);

		rs_g = pstmt_g.executeQuery();

		count=0;
		rs_g.last();
		count=rs_g.getRow();
		rs_g.beforeFirst();
		
		
		long lotid[]= new long[count];
		boolean purchase[]= new boolean[count];
		boolean receive_sell[]= new boolean[count];
		boolean returned[]= new boolean[count];
		boolean opening_stock[]= new boolean[count];
		double localprice[]=new double[count];
		double dollarprice[]=new double[count];
		double qty[]=new double[count];
		double available_qty[]=new double[count];
		long Consignment_ReceiveId[]=new long[count];
		long RT_Id[]=new long[count];
		long R_Id[]=new long[count];
		double rec_total[]=new double[count];
		int stocktransfer_type[] = new int[count];

		errLine = "720";	
		c=0;
		
		while(rs_g.next())
		{
			RT_Id[c]=rs_g.getLong("ReceiveTransaction_Id");
			R_Id[c]=rs_g.getLong("Receive_Id");    	Consignment_ReceiveId[c]=rs_g.getLong("Consignment_ReceiveId");
			purchase[c]=rs_g.getBoolean("purchase");//b
			receive_sell[c]=rs_g.getBoolean("receive_sell");//b
			//out.print("<br>receive_sell[c]="+receive_sell[c]);
			returned[c]=rs_g.getBoolean("R_Return");//b
			stocktransfer_type[c]=rs_g.getInt("StockTransfer_Type");
			opening_stock[c]=rs_g.getBoolean("Opening_Stock");//b
			lotid[c]=rs_g.getLong("Lot_id");
			//out.print("<br>lotid[c]="+lotid[c]);
			available_qty[c]=rs_g.getDouble("Available_Quantity");
			qty[c]=rs_g.getDouble("Quantity");
			localprice[c]=rs_g.getDouble("Local_Price");
			dollarprice[c]=rs_g.getDouble("Dollar_Price");
			rec_total[c]=rs_g.getDouble("Receive_Total");
			c++;
		}

		pstmt_g.close();
		
		int j=0;
		long currentLotId = -1;
		
		if(count > 0 && lotid[j] == lot_id[lotIndex] )
			currentLotId=lotid[j]; //if lot present make it the current lot

		errLine = "751";
		
		//for all the transactions obtained from the query do calculations for each lot
			
		while(j < count)
		{
			//out.print("<br>divstart"+divstart);
			//out.print("<br>divend"+divend);
			//out.print("<br>count"+count);
			//out.print("<br>j"+j);

			//Lot Checking.
			if(currentLotId != lotid[j])//if the lot id changed
			{
				errLine = "765";
				ik = lotIndex;
								
				if(counter != 1)
					lotIndex++;
				
				currentLotId = lot_id[lotIndex];
				
				errLine = "773";
				//out.print("<br>currentLotId"+currentLotId);
				// out.print("<br>lotid[j]"+lotid[j]);
				
				consignment_in_qty[ik]=consignment_in_qty_var;
				consignment_out_qty[ik]=consignment_out_qty_var ;
				consignment_sale_return_qty[ik]=consignment_sale_return_qty_var;
				consignment_sale_confirm_qty[ik]=consignment_sale_confirm_qty_var;
				consignment_purchase_return_qty[ik]=consignment_purchase_return_qty_var;
				consignment_purchase_confirm_qty[ik]=consignment_purchase_confirm_qty_var;

				financial_in_qty[ik]=financial_in_qty_var;
				financial_out_qty[ik]=financial_out_qty_var ;
				financial_sale_qty[ik]=financial_sale_qty_var;
				financial_sale_return_qty[ik]=financial_sale_return_qty_var;
				financial_purchase_qty[ik]=financial_purchase_qty_var;
				financial_purchase_return_qty[ik]=financial_purchase_return_qty_var;
				opening_stock_qty[ik]=opening_stock_qty_var;
				stock_transfer_qty[ik]=stock_transfer_qty_var	;
			
				// code for calculation for gross profit  
				if((gross_purchase_qty_var == 0) || (gross_purchase_var == 0) || (gross_sale_qty_var == 0))
						gross[ik]=0.0;
				else
					gross[ik]=( (100 * (gross_sale_var/gross_sale_qty_var)) / (gross_purchase_var/gross_purchase_qty_var) ) - 100;
				
				if("Physical Stock".equals(command))
				{
					//stores the physical quantity
					carats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];

					carats[ik]=str.mathformat(carats[ik],3);	

					if(ratetype.equals("OpeningRate"))
					{
						local_price[ik]=localp;//localp;
						dollar_price[ik]=dollarp;//dollarp;
					}
					
					if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate") )
					{
						dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
						local_price[ik]=(dollar_price[ik]*exchange_rate);
					}	
					
					if(ratetype.equals("AvgPur"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
					if(ratetype.equals("Running"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
					
				}
					
			
				if("Financial Stock".equals(command))
				{
					//stores the financial quantity
					carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];

					carats[ik]=str.mathformat(carats[ik],3);	

					if(ratetype.equals("OpeningRate"))
					{
						local_price[ik]=localp;//localp;
						dollar_price[ik]=dollarp;//dollarp;
					}
					
					if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
					{
						dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
						local_price[ik]=(dollar_price[ik]*exchange_rate);
					}	
					
					if(ratetype.equals("AvgPur"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
					if(ratetype.equals("Running"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}

				}

				if("Detailed Stock".equals(command))
				{
					//stores the difference between cgt inward quantity and cgt outward quantity
					carats[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik]-consignment_out_qty[ik]+consignment_sale_return_qty[ik]+consignment_sale_confirm_qty[ik];
					carats[ik]=str.mathformat(carats[ik],3);
					
					//stores the physical quantity
					pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
					pcarats[ik]=str.mathformat(pcarats[ik],3);

					if(ratetype.equals("OpeningRate"))
					{
						local_price[ik]=localp;//localp;
						dollar_price[ik]=dollarp;//dollarp;
					}
					
					if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
					{
						dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
						local_price[ik]=(dollar_price[ik]*exchange_rate);
					}	
					
					if(ratetype.equals("AvgPur"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
					if(ratetype.equals("Running"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}

				}

				if("MIS Stock".equals(command))
				{
					//stores the financial quantity
					carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];
					carats[ik]=str.mathformat(carats[ik],3);	

					//stores the physical quantity
					pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
					pcarats[ik]=str.mathformat(pcarats[ik],3);

					//calculation of cgt inward and outward quantity
					consignment_inward_qty[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik];
					consignment_outward_qty[ik]= consignment_out_qty[ik]-consignment_sale_return_qty[ik]-consignment_sale_confirm_qty[ik];

					if(ratetype.equals("OpeningRate"))
					{
						local_price[ik]=localp;//localp;
						dollar_price[ik]=dollarp;//dollarp;
					}
					
					if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
					{
						dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
						local_price[ik]=(dollar_price[ik]*exchange_rate);
					}	
					
					if(ratetype.equals("AvgPur"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
					if(ratetype.equals("Running"))
					{
						local_price[ik]=localp;
						dollar_price[ik]=dollarp;
					}
				}

				consignment_in_qty_var=0;
				consignment_out_qty_var=0;
				consignment_sale_return_qty_var=0;
				consignment_sale_confirm_qty_var=0;
				consignment_purchase_return_qty_var=0;
				consignment_purchase_confirm_qty_var=0;
				financial_in_qty_var=0;
				financial_out_qty_var=0;
				financial_sale_qty_var=0;
				financial_sale_return_qty_var=0;
				financial_sale_confirm_qty_var=0;
				financial_purchase_qty_var=0;
				financial_purchase_return_qty_var=0;
				opening_stock_qty_var=0;
				stock_transfer_qty_var	=0;

				gross_sale_var=0;
				gross_sale_qty_var=0;
				gross_purchase_var=0;
				gross_purchase_qty_var=0;

				localp=0;
				localp_temp=0;
				tqty=0;
				totalQty=0;
				totalQty_avgPurchase=0;
				tqty_temp_avgPurchase=0;
				tqty_temp=0;
				dollarp=0;
				dollarp_temp=0;
	
				continue;
			}//end of if
			//else calculate the various parameters for the given lot id
			errLine = "971";
			// Financial Purcahse/Receive -1 . 
			if((receive_sell[j]==true) && (purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) && (stocktransfer_type[j]==0) && (Consignment_ReceiveId[j]== 0)) 
			{
				tqty_temp = totalQty;
				totalQty+=qty[j];

				tqty_temp_avgPurchase=totalQty_avgPurchase;
				totalQty_avgPurchase+=qty[j];
			
				financial_purchase_qty_var +=qty[j];
				financial_in_qty_var += qty[j];
			
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;

				totalQty = str.mathformat(totalQty, 3);
				totalQty_avgPurchase=str.mathformat(totalQty_avgPurchase, 3);


				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				

				if(ratetype.equals("Running"))
				{
					if((totalQty)== 0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						if(localp_temp == 0)
							{localp_temp=localprice[j];}
						if(dollarp_temp == 0)
							{dollarp_temp=dollarprice[j];}


						localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
						dollarp	=((dollarp_temp * tqty_temp) +( qty[j]*dollarprice[j]))  /(tqty_temp +  qty[j]) ;
					}	
				}//Running
				
				if(ratetype.equals("AvgPur"))
				{
					if((totalQty_avgPurchase)== 0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						localp=((localp_temp * tqty_temp_avgPurchase) +(qty[j]*localprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
						dollarp	=((dollarp_temp * tqty_temp_avgPurchase) +( qty[j]*dollarprice[j]))  /(tqty_temp_avgPurchase +  qty[j]) ;
					}	
				} //AvgPur
				if(ratetype.equals("OpeningRate"))
				{
					localp=localp_temp;
					dollarp=dollarp_temp;					
				} //OpeningRate
				localp = Math.abs(localp);
				dollarp = Math.abs(dollarp);
				//out.print("<br>462 finanacial purchase Localp for"+lotid[j]+"="+localp);
				//out.print("<br>462 finanacial purchase dollarp for"+lotid[j]+"="+dollarp);
				//out.print("<br>Fin. Pur totalQty="+totalQty);
			}

			// Financial Sale.
			else if((receive_sell[j]==false) && (purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) && (stocktransfer_type[j]==0) && (Consignment_ReceiveId[j]==0))
			{	
				totalQty-=qty[j];
				financial_sale_qty_var += qty[j];
				financial_out_qty_var += qty[j];
				
				totalQty = str.mathformat(totalQty, 3);
				
				gross_sale_qty_var+=qty[j];
				gross_sale_var += (qty[j]*localprice[j]);
				
				//out.print("<br>Fin. Sale totalQty="+totalQty);
			}	
			// consignment purchase -1
			else if((receive_sell[j]==true) && (purchase[j]==false) && (returned[j]==false) && (opening_stock[j]==false)) 
			{
							  
				consignment_in_qty_var+=qty[j];

				totalQty = str.mathformat(totalQty, 3);
				consignment_in_qty_var=str.mathformat(consignment_in_qty_var,3);

				//out.print("<br>Cgt. purchase totalQty="+totalQty);
			}

			//Consignment Sale. -1 
			else
			if(( (receive_sell[j]==false) &&(purchase[j]==false) && (returned[j]==false) && (opening_stock[j]==false) ))
			{
				consignment_out_qty_var=consignment_out_qty_var + qty[j];

				totalQty = str.mathformat(totalQty, 3);
						
				consignment_out_qty_var=str.mathformat(consignment_out_qty_var,3);
				//out.print("<br>Cgt. Sale totalQty="+totalQty);
			}
			
			//Coinsignment Sale Return.
			else if((receive_sell[j]==true) && (purchase[j]==false) && (returned[j]==true))
			{
													
				consignment_sale_return_qty_var +=qty[j];

				totalQty = str.mathformat(totalQty, 3);
				consignment_sale_return_qty_var=str.mathformat(consignment_sale_return_qty_var,3);
				//out.print("<br>Cgt. Sale Return totalQty="+totalQty);
			}

			//Consignment Sale Confirm -1 .
			else 
			if( (receive_sell[j]==false) &&(purchase[j]==true) 				&&(returned[j]==false) && (opening_stock[j]==false) && (Consignment_ReceiveId[j] != 0))
			{		
				totalQty-=qty[j];
				consignment_sale_confirm_qty_var =consignment_sale_confirm_qty_var 
					+qty[j];
				financial_out_qty_var += qty[j];

				totalQty = str.mathformat(totalQty, 3);

				gross_sale_qty_var += qty[j];
				gross_sale_var +=(qty[j]*localprice[j]);
				
				//out.print("<br>Cgt. Sale Confirm totalQty="+totalQty);
			}
			
			//Financial sale return -1 .
			else
			if( (receive_sell[j]==true) && (purchase[j]==true) 				&(returned[j]==true) && (opening_stock[j]==false) )
			{
				tqty_temp=totalQty;
				totalQty+=qty[j];
				tqty_temp_avgPurchase=totalQty_avgPurchase;
				totalQty_avgPurchase+=qty[j];

				financial_sale_return_qty_var +=qty[j];
				financial_in_qty_var += qty[j];

				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				
				financial_sale_return_qty_var=str.mathformat(financial_sale_return_qty_var,3);
				totalQty = str.mathformat(totalQty, 3);
				totalQty_avgPurchase=str.mathformat(totalQty_avgPurchase, 3);
				
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;
					// gross calci
			
				if(ratetype.equals("Running"))
				{
					if((totalQty)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						if(localp_temp == 0)
							{localp_temp=localprice[j];}
						if(dollarp_temp == 0)
							{dollarp_temp=dollarprice[j];}

						localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
					}	
				}
				if(ratetype.equals("AvgPur"))
				{
					if((totalQty_avgPurchase)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						localp=((localp_temp * tqty_temp_avgPurchase) +(qty[j]*localprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp_avgPurchase) +(qty[j]*dollarprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
					}	
			    }
				if(ratetype.equals("OpeningRate"))
				{
					localp=localp_temp;
					dollarp=dollarp_temp;					
				} //OpeningRate
				localp = Math.abs(localp);
				dollarp = Math.abs(dollarp);
				//out.print("<br>586 finanacial sale return Localp for"+lotid[j]+"="+localp);
				//out.print("<br>Fin. Sale Return totalQty="+totalQty);
			}
			// Stopped
			//Financial Purchase Return.
			else 
			if( (receive_sell[j]==false) &&(purchase[j]==true) && (returned[j]==true) && (opening_stock[j]==false)  )
			{		
				totalQty-=qty[j];
				financial_purchase_return_qty_var =financial_purchase_return_qty_var 
					+qty[j];

				totalQty = str.mathformat(totalQty, 3);
				financial_out_qty_var += qty[j];

				gross_sale_qty_var +=(qty[j]);
				gross_sale_var +=(qty[j]*localprice[j]);
				
				//out.print("<br>Fin. Purchase Return totalQty="+totalQty);
			}
			//Consignment Purchase Return.

			else 
			if( (receive_sell[j]==false) &&(purchase[j]==false) 				&&(returned[j]==true) && (opening_stock[j]==false))
			{		
				
				consignment_purchase_return_qty_var =consignment_purchase_return_qty_var 			+qty[j];

				totalQty = str.mathformat(totalQty, 3);

				//out.print("<br>Cgt. Purchase Return totalQty="+totalQty);
			}

			//Consignment Purchase Confirm.
			else 
			if( (receive_sell[j]==true) &&(purchase[j]==true) &&(returned[j]==false) && (opening_stock[j]==false) && !(Consignment_ReceiveId[j] == 0))
			{		
				tqty_temp = totalQty;
				totalQty+=qty[j];

				tqty_temp_avgPurchase=totalQty_avgPurchase;
				totalQty_avgPurchase+=qty[j];

				consignment_purchase_confirm_qty_var =consignment_purchase_confirm_qty_var				+qty[j];
				financial_in_qty_var += qty[j];

				totalQty = str.mathformat(totalQty, 3);
				totalQty_avgPurchase=str.mathformat(totalQty_avgPurchase, 3);

				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);
				
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;
						
				if(ratetype.equals("Running"))
				{
					if((totalQty)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						if(localp_temp == 0)
							{localp_temp=localprice[j];}
						if(dollarp_temp == 0)
							{dollarp_temp=dollarprice[j];}

						localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
					}	
				} //Running

				if(ratetype.equals("AvgPur"))
				{
					if((totalQty_avgPurchase)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						localp=((localp_temp * tqty_temp_avgPurchase) +(qty[j]*localprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp_avgPurchase) +(qty[j]*dollarprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
					}	

				}
				if(ratetype.equals("OpeningRate"))
				{
					localp=localp_temp;
					dollarp=dollarp_temp;					
				} //OpeningRate
				localp = Math.abs(localp);
				dollarp = Math.abs(dollarp);
				
				//out.print("<br>586 Cgt. purchase confirm Localp for"+lotid[j]+"="+localp);
				//out.print("<br>586 Cgt. purchase confirm Dollarp for"+lotid[j]+"="+dollarp);

				//out.print("<br>Cgt. Purchase Confirm totalQty="+totalQty);
			}
			//opening_stock
			else
			if( (receive_sell[j]==true) &&(purchase[j]==true) 				&&(returned[j]==false) && (opening_stock[j]==true) &&    (Consignment_ReceiveId[j] == 0))
			{		
				tqty_temp=totalQty;
				totalQty+=qty[j];
				tqty_temp_avgPurchase=totalQty_avgPurchase;
				totalQty_avgPurchase+=qty[j];
					
				opening_stock_qty_var +=available_qty[j];
				financial_in_qty_var += available_qty[j];

				gross_purchase_qty_var +=(available_qty[j]);
				gross_purchase_var +=(available_qty[j]*localprice[j]);
				
				opening_stock_qty_var=str.mathformat(opening_stock_qty_var,3);

				totalQty = str.mathformat(totalQty, 3);
				totalQty_avgPurchase=str.mathformat(totalQty_avgPurchase, 3);	
			
				dollarp_temp=dollarp; 
				dollarp=0;	
				localp_temp= localp;  
				localp=0;

				if(ratetype.equals("Running"))
				{
					
					if((opening_stock_qty_var)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						if(localp_temp == 0)
							{localp_temp=localprice[j];}
						if(dollarp_temp == 0)
							{dollarp_temp=dollarprice[j];}

						localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
						
					}
				} //Running
				if(ratetype.equals("AvgPur"))
				{
					if((opening_stock_qty_var)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						localp=((localp_temp *tqty_temp_avgPurchase) +(qty[j]*localprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
						dollarp=((dollarp_temp * tqty_temp_avgPurchase) +(qty[j]*dollarprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
					
					}
				} //AvgPur
				if(ratetype.equals("OpeningRate"))
				{
					if((opening_stock_qty_var)==0)
					{
						localp=0;
						dollarp=0;
					}
					else
					{
						localp=localprice[j];
						dollarp=dollarprice[j];					
					}
				} //OpeningRate
				localp = Math.abs(localp);
				dollarp = Math.abs(dollarp);
				//out.print("<br>713 opening stock Localp for"+lotid[j]+"="+localp);
				//out.print("<br>Opening Stock totalQty="+totalQty);
				
			}

			// Stock Transfer. -1
			if((purchase[j]==true) && (returned[j]==false) && (opening_stock[j]==false) &&   (stocktransfer_type[j] != 0)) 
			{
				if(receive_sell[j]==true){
				
				tqty_temp=totalQty;
				totalQty+=qty[j];

				tqty_temp_avgPurchase=totalQty_avgPurchase;
				totalQty_avgPurchase+=qty[j];
			
				gross_purchase_qty_var +=(qty[j]);
				gross_purchase_var +=(qty[j]*localprice[j]);

				stock_transfer_qty_var +=qty[j];
				financial_in_qty_var += qty[j];
				totalQty = str.mathformat(totalQty, 3);
				totalQty_avgPurchase=str.mathformat(totalQty_avgPurchase, 3);
				stock_transfer_qty_var=str.mathformat(stock_transfer_qty_var,3);

				dollarp_temp=dollarp;
				dollarp=0;
				localp_temp= localp;
				localp=0;

				if(ratetype.equals("Running"))
					{
						if(0==(totalQty))
						{
								localp=0;
								dollarp=0;
						}
						else
						{
							if(localp_temp == 0)
								{localp_temp=localprice[j];}
							if(dollarp_temp == 0)
								{dollarp_temp=dollarprice[j];}
				
							localp=((localp_temp * tqty_temp) +(qty[j]*localprice[j]))  /(tqty_temp + qty[j]) ;
							dollarp=((dollarp_temp * tqty_temp) +(qty[j]*dollarprice[j]))  /(tqty_temp + qty[j]) ;
						}
					} //Running
					if(ratetype.equals("AvgPur"))
					{
						if(0==(totalQty_avgPurchase))
						{
								localp=0;
								dollarp=0;
						}
						else
						{
				
							localp=((localp_temp * tqty_temp_avgPurchase) +(qty[j]*localprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
							dollarp=((dollarp_temp * tqty_temp_avgPurchase) +(qty[j]*dollarprice[j]))  /(tqty_temp_avgPurchase + qty[j]) ;
						}
					
					} //AvgPur
					if(ratetype.equals("OpeningRate"))
					{
						localp=localp_temp;
						dollarp=dollarp_temp;					
					} //OpeningRate
					localp = Math.abs(localp);
					dollarp = Math.abs(dollarp);
				//out.print("<br>744 stock transfer IN Localp for"+lotid[j]+"="+localp);
				//out.print("<br>stock transfer IN totalQty="+totalQty);
				}

			else{
				totalQty-=qty[j];
				stock_transfer_qty_var -=qty[j];
				totalQty = str.mathformat(totalQty, 3);

				gross_sale_qty_var +=(qty[j]);
				gross_sale_var +=(qty[j]*localprice[j]);
				stock_transfer_qty_var=str.mathformat(stock_transfer_qty_var,3);
				financial_out_qty_var += qty[j];
				//out.print("<br>stock transfer OUT totalQty="+totalQty);
				}
				
			}// last if close
			j++;
			
		}// end of while
		//code to calculate the data for the last item row
		
		if(count > 0)
		{
			errLine = "1442";
			if(counter != 1)
				ik++;
			
			
			consignment_in_qty[ik]=consignment_in_qty_var;
			consignment_out_qty[ik]=consignment_out_qty_var ;
			consignment_sale_return_qty[ik]=consignment_sale_return_qty_var;
			consignment_sale_confirm_qty[ik]=consignment_sale_confirm_qty_var;
			consignment_purchase_return_qty[ik]=consignment_purchase_return_qty_var;
			consignment_purchase_confirm_qty[ik]=consignment_purchase_confirm_qty_var;

			financial_in_qty[ik]=financial_in_qty_var;
			financial_out_qty[ik]=financial_out_qty_var ;
			financial_sale_qty[ik]=financial_sale_qty_var;
			financial_sale_return_qty[ik]=financial_sale_return_qty_var;
			financial_purchase_qty[ik]=financial_purchase_qty_var;
			financial_purchase_return_qty[ik]=financial_purchase_return_qty_var;
			opening_stock_qty[ik]=opening_stock_qty_var;
			stock_transfer_qty[ik]=stock_transfer_qty_var	;

			// code for calculation for gross profit  
			if((gross_purchase_qty_var == 0) || (gross_purchase_var == 0) || (gross_sale_qty_var == 0))
					gross[ik]=0.0;
			else
				gross[ik]=( (100 * (gross_sale_var/gross_sale_qty_var)) / (gross_purchase_var/gross_purchase_qty_var) ) - 100;
			
				
			if("Physical Stock".equals(command))
			{
				carats[ik]= consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
				carats[ik]=str.mathformat(carats[ik],3);	
				
				if(ratetype.equals("OpeningRate"))
				{
					local_price[ik]=localp;//localp;
					dollar_price[ik]=dollarp;//dollarp;
				}
				
				if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
				{
					dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
					local_price[ik]=(dollar_price[ik]*exchange_rate);
				}	
				
				if(ratetype.equals("AvgPur"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}
				if(ratetype.equals("Running"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}

			}
			
			if("Financial Stock".equals(command))
			{
				//stores the financial quantity
				carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];
				carats[ik]=str.mathformat(carats[ik],3);	

				if(ratetype.equals("OpeningRate"))
				{
					local_price[ik]=localp;//localp;
					dollar_price[ik]=dollarp;//dollarp;
				}
				
				if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
				{
					dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
					local_price[ik]=(dollar_price[ik]*exchange_rate);
				}	
				
				if(ratetype.equals("AvgPur"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}
				if(ratetype.equals("Running"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}


			}

			if("Detailed Stock".equals(command))
			{
				carats[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik]-consignment_out_qty[ik]+consignment_sale_return_qty[ik]+consignment_sale_confirm_qty[ik];
				carats[ik]=str.mathformat(carats[ik],3);

				pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
				pcarats[ik]=str.mathformat(pcarats[ik],3);

				if(ratetype.equals("OpeningRate"))
				{
					local_price[ik]=localp;//localp;
					dollar_price[ik]=dollarp;//dollarp;
				}
				
				if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") || ratetype.equals("LastSaleRate"))
				{
					dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
					local_price[ik]=(dollar_price[ik]*exchange_rate);
				}	
				
				if(ratetype.equals("AvgPur"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}
				if(ratetype.equals("Running"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}

			}

			if("MIS Stock".equals(command))
			{
				//stores the financial quantity
				carats[ik]= financial_purchase_qty[ik]+opening_stock_qty[ik]+consignment_purchase_confirm_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_sale_confirm_qty[ik]-financial_purchase_return_qty[ik];
				carats[ik]=str.mathformat(carats[ik],3);	

				//stores the physical quantity
				pcarats[ik]=  consignment_in_qty[ik]+consignment_sale_return_qty[ik]+financial_purchase_qty[ik]+opening_stock_qty[ik]+financial_sale_return_qty[ik]+stock_transfer_qty[ik]-financial_sale_qty[ik]-consignment_purchase_return_qty[ik]-consignment_out_qty[ik]-financial_purchase_return_qty[ik];
				pcarats[ik]=str.mathformat(pcarats[ik],3);

				//calculation of cgt inward and outward quantity
				consignment_inward_qty[ik]= consignment_in_qty[ik]-consignment_purchase_return_qty[ik]-consignment_purchase_confirm_qty[ik];
				consignment_outward_qty[ik]= consignment_out_qty[ik]-consignment_sale_return_qty[ik]-consignment_sale_confirm_qty[ik];

				if(ratetype.equals("OpeningRate"))
				{
					local_price[ik]=localp;//localp;
					dollar_price[ik]=dollarp;//dollarp;
				}
				
				if(ratetype.equals("EffPurchaseRate") || ratetype.equals("EffSaleRate") || ratetype.equals("LastPurchaseRate") ||
				ratetype.equals("LastSaleRate"))
				{
					dollar_price[ik]=(Double)HashEffectiveRate.get(lot_id[ik]);
					local_price[ik]=(dollar_price[ik]*exchange_rate);
				}	
				
				if(ratetype.equals("AvgPur"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}
				if(ratetype.equals("Running"))
				{
					local_price[ik]=localp;
					dollar_price[ik]=dollarp;
				}

			}
			
		}//end of block for the last lot
		errLine = "1605";
		if( (divend + brkPoint) < (counter-1) )
		{
			divstart = divend + 1;
			//out.print("<br>divstart="+divstart);
		}
		else
		{
			divstart = divend + 1;
			brkPoint = counter - divstart;
			
			//out.print("<br>brkPoint="+brkPoint);
			//out.print("<br>divstart last="+divstart);
		}

	
	}//end of divide logic block

//display for physical and financial stock report display
//out.print("<br> 1692");
if( "Financial Stock".equals(command) || "Physical Stock".equals(command) )
{

	//System.out.println("1706");
	qtyLocalAmtDollarAmt="";
	double grandamount2=0;
	double grandamount4=0;
	double grandamount6=0; 
	

	double originalQty=0;
	double originalLocalAmount=0;
	double originalDollarAmount=0;
	String originalStockDescription="";

		
if( ! "yes".equals(summary) && !"lot_no".equals(group_by) && !"yes".equals(showTopRows) )
{
	//System.out.println(" 1721");
	int decColspan = 0;

	if(! "both".equals(currency) && ! "yes".equals(showamount))
	{
		decColspan = 3;
	}
	else if(! "both".equals(currency) &&  "yes".equals(showamount))
	{
		decColspan = 2;
	}
	else if( "both".equals(currency) &&  ! "yes".equals(showamount))
	{
		decColspan = 2;
	}
	
	//getting all the group ids that have the displayable lots
	//this logic is used to not display groups not haveing any lots to display as per the selection criteria
	ArrayList lotsGroupId = new ArrayList();
	for(int i=0; i< counter; i++)
	{
		pcarats[i]=carats[i];
	
		if(start > end)	
		{
			double tempst = start;
			start = end;
			end = tempst;
		}
	    
		if(selectrange.equals("include")) 
		{	
			if(pcarats[i]>=start && pcarats[i]<=end) 
			{ lotsGroupId.add(""+group_id[i]);  }
		} 

		if(selectrange.equals("exclude"))
		{
		    if(pcarats[i]<start || pcarats[i]>end) 
			{ lotsGroupId.add(""+group_id[i]); }
		}
			
	}//for


	for(int gCnt=0; gCnt < selectedgroup_id.length; gCnt++)
	{
		String currGroupId = ""+selectedgroup_id[gCnt];
		int noOfLotsInGroup = Collections.frequency(lotsGroupId, currGroupId);
		if(noOfLotsInGroup == 0)
			continue;

		int dispGroupId = Integer.parseInt(selectedgroup_id[gCnt]);	
		String dispGroupName = (String)Group_Name.get(dispGroupId);
		
		 double amount1=0;
		double amount2=0;
		double amount3=0;
		double amount4=0;
		double amount5=0;
		double amount6=0;
		double amount7=0;
		double amount8=0;
		double amount9=0;

		
		double total=0;
		double subtotal=0;
		double csubtotal=0;
		double clocal_total=0;
		double psubtotal=0;
		double plocal_total=0;
		double per_total=0;
		double sale_total=0;
		double per_ctotal=0;
		double sale_ctotal=0;
		double p_total=0;
		double local_subtotal=0;
		double dollar_subtotal=0;
		double local_total=0;
		double phylocal_total=0;
		double phydollar_total=0;
		

		int s=1;

		for(int i=0; i< counter; i++)
		{
			String lotGroupId = ""+group_id[i];
			if(! lotGroupId.equals(selectedgroup_id[gCnt]) )
				continue;
		/*To handle exponent value End*/
		//System.out.printlnln("<br>"+carats[i]);
			total += carats[i];
			subtotal= carats[i] *local_price[i];
			local_total +=str.mathformat(subtotal,d);
			csubtotal= ccarats[i] *clocal_price[i];
			//System.out.println("<br>"+local_price[i]);
			clocal_total +=str.mathformat(csubtotal,d);
			psubtotal= subtotal+ csubtotal;

			pcarats[i]=carats[i];
			//System.out.println("<br>695 i : "+pcarats[i]);
			plocal_total+=str.mathformat(psubtotal,d);
			per_total +=per_carats[i];
			sale_total += sale_carats[i];
			per_ctotal +=per_ccarats[i];
			sale_ctotal +=sale_ccarats[i];
			p_total +=pcarats[i];

			try
			{
				local_subtotal=pcarats[i]* local_price[i];
			}
			catch(Exception e )
			{
				System.out.println("<br color=red> e "+e);
			}
			try
			{
				dollar_subtotal=pcarats[i]* dollar_price[i];
			}
			catch(Exception e )
			{
				System.out.println("<br color=red> e "+e);
			}
			//System.out.println("<br>688 i : "+i);

			phylocal_total += str.mathformat(local_subtotal,d);

			
			if(start > end)	
			{
				double tempst = start;
				start = end;
				end = tempst;
			}
			if(selectrange.equals("include")) 
			{	
				if(pcarats[i]>=start && pcarats[i]<=end) 
				{ 
						amount1+=pcarats[i];
						amount3+=local_subtotal;
						amount5+= dollar_subtotal;
				}
			} 
			if(selectrange.equals("exclude"))
			{
				if(pcarats[i]<start || pcarats[i]>end) 
				{
				    amount1+=pcarats[i];
					amount3+=local_subtotal;
					amount5+= dollar_subtotal;
				}
			}
				
		}//for

		amount2+=amount1;
		amount4+=amount3;
		amount6+=amount5;
		
		grandamount2 += amount2;
		grandamount4 += amount4;
		grandamount6 += amount6;
	}//end of for loop displaying data for each group	
	
	
	qtyLocalAmtDollarAmt=""+grandamount2+"#"+grandamount4+"#"+grandamount4;
    return qtyLocalAmtDollarAmt;
	
}//end of one type of display that is groupwise detailed 

if( "yes".equals(summary) && !"lot_no".equals(group_by) && !"yes".equals(showTopRows))
{
		//System.out.println(" 1896");
	int srno = 1;
	
	//getting all the group ids that have the displayable lots
	//this logic is used to not display groups not haveing any lots to display as per the selection criteria
	ArrayList lotsGroupId = new ArrayList();
	for(int i=0; i< counter; i++)
	{
		pcarats[i]=carats[i];
	
		if(start > end)	
		{
			double tempst = start;
			start = end;
			end = tempst;
		}
	    
		if(selectrange.equals("include")) 
		{	
			if(pcarats[i]>=start && pcarats[i]<=end) 
			{ lotsGroupId.add(""+group_id[i]);  }
		} 

		if(selectrange.equals("exclude"))
		{
		    if(pcarats[i]<start || pcarats[i]>end) 
			{ lotsGroupId.add(""+group_id[i]); }
		}
			
	}//for


	
	for(int gCnt=0; gCnt < selectedgroup_id.length; gCnt++)
	{
		String currGroupId = ""+selectedgroup_id[gCnt];
		int noOfLotsInGroup = Collections.frequency(lotsGroupId, currGroupId);
		if(noOfLotsInGroup == 0)
			continue;

	
		int dispGroupId = Integer.parseInt(selectedgroup_id[gCnt]);	
		String dispGroupName = (String)Group_Name.get(dispGroupId);
				
		double amount1=0;
		double amount2=0;
		double amount3=0;
		double amount4=0;
		double amount5=0;
		double amount6=0;
		double amount7=0;
		double amount8=0;
		double amount9=0;

		
		double total=0;
		double subtotal=0;
		double csubtotal=0;
		double clocal_total=0;
		double psubtotal=0;
		double plocal_total=0;
		double per_total=0;
		double sale_total=0;
		double per_ctotal=0;
		double sale_ctotal=0;
		double p_total=0;
		double local_subtotal=0;
		double dollar_subtotal=0;
		double local_total=0;
		double phylocal_total=0;
		double phydollar_total=0;
		

		int s=1;

		for(int i=0; i< counter; i++)
		{
			String lotGroupId = ""+group_id[i];
			if(! lotGroupId.equals(selectedgroup_id[gCnt]) )
				continue;
		/*To handle exponent value End*/
		//System.out.printlnln("<br>"+carats[i]);
			total += carats[i];
			subtotal= carats[i] *local_price[i];
			local_total +=str.mathformat(subtotal,d);
			csubtotal= ccarats[i] *clocal_price[i];
			//System.out.println("<br>"+local_price[i]);
			clocal_total +=str.mathformat(csubtotal,d);
			psubtotal= subtotal+ csubtotal;

			pcarats[i]=carats[i];
			//System.out.println("<br>695 i : "+pcarats[i]);
			plocal_total+=str.mathformat(psubtotal,d);
			per_total +=per_carats[i];
			sale_total += sale_carats[i];
			per_ctotal +=per_ccarats[i];
			sale_ctotal +=sale_ccarats[i];
			p_total +=pcarats[i];

			try
			{
				local_subtotal=pcarats[i]* local_price[i];
			}
			catch(Exception e )
			{
				System.out.println("<br color=red> e "+e);
			}
			try
			{
				dollar_subtotal=pcarats[i]* dollar_price[i];
			}
			catch(Exception e )
			{
				System.out.println("<br color=red> e "+e);
			}
			//System.out.println("<br>688 i : "+i);

			phylocal_total += str.mathformat(local_subtotal,d);

			
			if(start > end)	
			{
				double tempst = start;
				start = end;
				end = tempst;
			}
			
			if(selectrange.equals("include")) 
			{	
			
				if(pcarats[i]>=start && pcarats[i]<=end) 
				{  
					amount1+=pcarats[i];
					amount3+=local_subtotal;
					amount5+= dollar_subtotal;
				}
			} 

			if(selectrange.equals("exclude"))
			{
			   if(pcarats[i]<start || pcarats[i]>end) 
				{	
					amount1+=pcarats[i];
					amount3+=local_subtotal;
					amount5+= dollar_subtotal;
				}
			}
				
		}//for

		
		
		
		
		amount2+=amount1;
		
		amount4+=amount3; 
		
		amount6+=amount5;
			
		grandamount2 += amount2;
		grandamount4 += amount4;
		grandamount6 += amount6;
	}//end of for loop displaying data for each group	
	

	qtyLocalAmtDollarAmt=""+grandamount2 +"#"+grandamount4+"#"+grandamount6;
    return qtyLocalAmtDollarAmt;
	
	
	
}//end of one type of display that is groupwise summary with amount

if( "lot_no".equals(group_by) && !"yes".equals(showTopRows))
{
	//System.out.println("2071");
	
	double amount1=0;
	double amount2=0;
	double amount3=0;
	double amount4=0;
	double amount5=0;
	double amount6=0;
	double amount7=0;
	double amount8=0;
	double amount9=0;

	
	double total=0;
	double subtotal=0;
	double csubtotal=0;
	double clocal_total=0;
	double psubtotal=0;
	double plocal_total=0;
	double per_total=0;
	double sale_total=0;
	double per_ctotal=0;
	double sale_ctotal=0;
	double p_total=0;
	double local_subtotal=0;
	double dollar_subtotal=0;
	double local_total=0;
	double phylocal_total=0;
	double phydollar_total=0;
		

	int s=1;

	for(int i=0; i< counter; i++)
	{
		/*To handle exponent value End*/
		//System.out.printlnln("<br>"+carats[i]);
		total += carats[i];
		subtotal= carats[i] *local_price[i];
		local_total +=str.mathformat(subtotal,d);
		csubtotal= ccarats[i] *clocal_price[i];
		//System.out.println("<br>"+local_price[i]);
		clocal_total +=str.mathformat(csubtotal,d);
		psubtotal= subtotal+ csubtotal;
		pcarats[i]=carats[i];
		//System.out.println("<br>695 i : "+pcarats[i]);
		plocal_total+=str.mathformat(psubtotal,d);
		per_total +=per_carats[i];
		sale_total += sale_carats[i];
		per_ctotal +=per_ccarats[i];
		sale_ctotal +=sale_ccarats[i];
		p_total +=pcarats[i];
		try
		{
			local_subtotal=pcarats[i]* local_price[i];
		}
		catch(Exception e )
		{
			System.out.println("<br color=red> e "+e);
		}
		try
		{
			dollar_subtotal=pcarats[i]* dollar_price[i];
		}
		catch(Exception e )
		{
			System.out.println("<br color=red> e "+e);
		}
		//System.out.println("<br>688 i : "+i);

		phylocal_total += str.mathformat(local_subtotal,d);

			
		if(start > end)	
		{
			double tempst = start;
			start = end;
			end = tempst;
		}
		 if(selectrange.equals("include")) 
		 {	
	
			if(pcarats[i]>=start && pcarats[i]<=end) 
				{  
										 
					amount1+=pcarats[i];
					amount3+=local_subtotal;
					amount5+= dollar_subtotal;
				
			    }
		} 

		if(selectrange.equals("exclude"))
		{
				
		   if(pcarats[i]<start || pcarats[i]>end) 
			{
				amount1+=pcarats[i];
				amount3+=local_subtotal;
				amount5+= dollar_subtotal;
			}
		}
				
		}//for

		
		 
		
		
		
		amount2+=amount1;
			
		amount4+=amount3;
		
		amount6+=amount5;
		
		
		
		grandamount2 += amount2;
		grandamount4 += amount4;
		grandamount6 += amount6;
	
	
        qtyLocalAmtDollarAmt=""+grandamount2+"#"+grandamount4+"#"+grandamount6;
		return qtyLocalAmtDollarAmt;
		
	
		
	
}//end of one type of display that is lotnowise detailed 

if( "yes".equals(showTopRows))
{
	int noOfRows = 0;//Integer.parseInt(request.getParameter("noOfRows"));
	String topRowsOrder = "0";//request.getParameter("topRowsOrder");

	//add the complete lot data to a arraylist and sort them
	ArrayList completeLotList = new ArrayList();
	for(int i=0; i< counter; i++)
	{
		double localSubtotal= carats[i] * local_price[i];
		double dollarSubtotal= carats[i] * dollar_price[i];

		ClosingStockList CSL = new ClosingStockList((int)lot_id[i], lot_no[i], description_id[i], size_id[i],  group_id[i], carats[i], local_price[i], localSubtotal, dollar_price[i], dollarSubtotal, topRowsOrder);

		completeLotList.add(CSL);

	}//for

	ClosingStockTopRowsComp comp = new ClosingStockTopRowsComp();
	Collections.sort(completeLotList, comp);

	int listSize = 0;

	if(noOfRows < completeLotList.size())
		listSize = noOfRows;
	else
		listSize = completeLotList.size();

	int decColspan = 0;

	if(! "both".equals(currency) && ! "yes".equals(showamount))
	{
		decColspan = 3;
	}
	else if(! "both".equals(currency) &&  "yes".equals(showamount))
	{
		decColspan = 2;
	}
	else if( "both".equals(currency) &&  ! "yes".equals(showamount))
	{
		decColspan = 2;
	}

	String topRowsOrderName = "";
	if("quantity".equals(topRowsOrder))
		topRowsOrderName = "Quantity";
	else if("localamount".equals(topRowsOrder))
		topRowsOrderName = "Amount("+local_symbol+")";
	else if("dollaramount".equals(topRowsOrder))
		topRowsOrderName = "Amount($)";
	else if("localrate".equals(topRowsOrder))
		topRowsOrderName = "Rate("+local_symbol+")";
	else if("dollarrate".equals(topRowsOrder))
		topRowsOrderName = "Rate($)";

		
				
	

	
	double amount1=0;
	double amount2=0;
	double amount3=0;
	double amount4=0;
	double amount5=0;
	double amount6=0;
	double amount7=0;
	double amount8=0;
	double amount9=0;

	
	int s=1;

	for(int i=0; i< listSize; i++)
	{
		ClosingStockList CSL = (ClosingStockList)completeLotList.get(i);
		
		
			
			if("0".equals(location_id))
			{
			
			}
			else
			{
			
			}
			
			amount1+=CSL.getCarats();
			amount3+=CSL.getLocalAmount();
			amount5+= CSL.getDollarAmount();
			
			

				
		}//for

		
		
		
		
		amount2+=amount1; 
			

		amount4+=amount3;  
		
		
		 amount6+=amount5;
		 
		

	
		grandamount2 += amount2;
		grandamount4 += amount4;
		grandamount6 += amount6;
	
	    qtyLocalAmtDollarAmt=""+grandamount2+"#"+grandamount4+"#"+grandamount6;
        return qtyLocalAmtDollarAmt;
		
}//end of one type of display that is top rows
if("yes".equals(SaveStock))
{	

	String stockOpenQuery="select ClosingQuantity,ClosingLocalAmount,ClosingDollarAmount,StockDescription from Stock where ClosingDate='"+D1+"' and company_id="+company_id+" and Active=1";
		pstmt_g = cong.prepareStatement(stockOpenQuery);
		rs_g = pstmt_g.executeQuery();
		boolean dataPresent=false;
		while(rs_g.next()) 	
		{
		originalQty=rs_g.getDouble("ClosingQuantity");
		originalLocalAmount=rs_g.getDouble("ClosingLocalAmount");
		originalDollarAmount=rs_g.getDouble("ClosingDollarAmount");
		originalStockDescription=rs_g.getString("StockDescription");
		if (rs_g.wasNull())
			{originalStockDescription="";}
		dataPresent=true;
		}

pstmt_g.close();

 if(dataPresent) {

 } 

}//end of if yes saveStock

}//end of if Physical Stock or Financial Stock Report

if("Detailed Stock".equals(command))
{
	double subtotal=0;
	double psubtotal=0;
	
	double purchase_total=0;
	double sale_total=0;
	double fin_balance_total=0;
	double fin_amt_total=0;

	double cgt_purchase_total=0;
	double cgt_sale_total=0;
	double cgt_balance_total=0;

	double phy_balance_total=0;
	double phy_amt_total=0;


	int lastS =0;
	int s=1;
	for(int i=0; i< counter; i++)
	{

	subtotal= (financial_in_qty[i]-financial_out_qty[i]) *local_price[i];
	psubtotal= pcarats[i] * local_price[i];

	purchase_total += financial_in_qty[i];
	sale_total += financial_out_qty[i];
	fin_balance_total += (financial_in_qty[i]-financial_out_qty[i]);
	fin_amt_total += subtotal;
	cgt_purchase_total += consignment_in_qty[i];
	cgt_sale_total +=consignment_out_qty[i];
	cgt_balance_total += carats[i];
	phy_balance_total += pcarats[i];
	phy_amt_total += psubtotal;
	

	if(0==(s%26) && s != lastS)
	{
		lastS = s;
	}
	
	
	}//for

	
	
	
		 
	





}//end of if Detail Stock

if("MIS Stock".equals(command))
{


double psubtotal=0;
double fin_balance_total=0;
double cgt_balance_total=0;
double phy_balance_total=0;
double phy_amt_total=0;


int lastS=0;
int s=1;
for(int i=0; i< counter; i++)
{

	ccarats[i] = consignment_inward_qty[i] - consignment_outward_qty[i];

	psubtotal= pcarats[i] * local_price[i];

	fin_balance_total += carats[i];
	cgt_balance_total += ccarats[i];
	phy_balance_total += pcarats[i];
	phy_amt_total += psubtotal;
	
if(0==(s%35) && lastS != s)
{
	lastS = s;

}//end of if


}//end of for




 

}//end of if MIS Stock
//C.returnConnection(cong);
//C.returnConnection(conp);
}catch(Exception e)
{
	//C.returnConnection(cong);
	//C.returnConnection(conp);
	System.out.println("<BR>"+errLine+"EXCEPTION="+e);
}
	} //try
	catch(Exception e)
	{
		System.out.println("e="+e+" errLine="+errLine);
	}
	return qtyLocalAmtDollarAmt;
} //getOpeningClosing Stock
}

