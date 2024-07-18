

/*
--------------------------------------------------------------------------------------------------------
Sr.No	ModifiedBy		Date            Reasons
--------------------------------------------------------------------------------------------------------
1)      Mr Ganesh      22-04-2011       add class for MVC
2)      ParagJ         26-12-2023       Set Date From 2020 To 2030 
--------------------------------------------------------------------------------------------------------
*/

package NipponBean;
import java.util.*;
import java.sql.*;
import NipponBean.*;
public class login
{
	Connection cong = null;
	Connection conp = null;
	ResultSet rs_g=null;
	//Connect1 c;
	NipponBean.Array A;
	PreparedStatement pstmt_g=null;
	PreparedStatement pstmt_p=null;
	String errLine="14";
	public	login()
		{
		 try{
			// c=new Connect1();
			 A=new NipponBean.Array();
	     }catch(Exception e15){ System.out.print("Error in Connection"+e15);}
		}
	
public int get_master_id(Connection con,String table) throws Exception
	{
	// conp=c.getConnection();
	//System.out.print("25 Inside login.java ");

	String query ="select count(*) as cnt from "+table;
	//System.out.print("query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		
		{
		i=rs.getInt("cnt");
		}
	pstmt_p.close();
	i++;
	//conp.close();
	//c.returnConnection(conp);
	//System.out.print("38 Inside login.java i="+i);
	return i;
	}
//RVB120510
public int get_master_id(Connection con,String table ,String coloumn,int i)throws Exception
{
	//System.out.println(coloumn);
	String query ="select Lot_Id from "+table+" where Lot_No=?";
		int Lot_id=0;
		
		pstmt_p = con.prepareStatement(query);
		pstmt_p.setString(1, coloumn);
		ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		
		{
		Lot_id=rs.getInt("Lot_Id");
		}
	pstmt_p.close();
	return Lot_id;


}// RVB120510

public int get_master_id(Connection con,String table,String coloumn) throws Exception
	{
//conp=c.getConnection();
//
int cnt=0;
String query ="select count(*) as cnt from "+table;
//System.out.print("query);
int i=1;
pstmt_p = con.prepareStatement(query);
ResultSet rs = pstmt_p.executeQuery();
while(rs.next()) 		
{
i=rs.getInt("cnt");
}
pstmt_p.close();
i++;
//
return i;
}

public String getDescription(Connection con,String lot_id)
{
//System.out.println("lot_id="+lot_id);
	try
	{
	 //conp=c.getConnection();

	String ret_desc="";
	//String cut[]={"ID","H&C-3X","H&C","H&A-3X","H&A", "3X","EX","VG","GD","FAIR","WEAK","OTHER CUT","-"};
	//String color[]={"D","E","F","G","H","I","J","K","L", "M","N","O","P","Q","S","T","U","Z","OTHER","-"};
	//String purity[]={"IF","VVS1","VVS2","VS1","VS2","SI1", "SI2","SI3","I1","I2","I3","I4","I5","I6","I7","OTHER","-"};
	String cut_id=""; 
	String color_id=""; 
	String purity_id=""; 
	int category_id=0;
	String company_id="";
	String description="";
	String name="";
	String lot_no="";
	String weight="";
	String quality="";
	String query="Select company_id,Lot_Name,Lot_Description,LotCategory_Id,X5MF from Lot where lot_id=?";
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setString(1,lot_id);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 
	{
		//lot_no=rs_g.getString("lot_no");
		company_id=rs_g.getString("company_id");
		name=rs_g.getString("Lot_Name");
		description=rs_g.getString("Lot_Description");
		if (rs_g.wasNull())
		{
			description="-";
		}

		if (rs_g.wasNull())
		{
			name="-";
		}
		category_id=rs_g.getInt("LotCategory_Id");
		quality = rs_g.getString("X5MF");
		if (rs_g.wasNull())
		{
			quality="";
		}
		//System.out.println("quality="+quality+"---For lot_id="+lot_id);
	}
	pstmt_p.close();

	int dia_category= Integer.parseInt(A.getNameCondition(con,"Master_LotCategory","LotCategory_Id", "Where LotCategory_Name='Diamond' and company_id="+company_id+""));

	int jew_category= Integer.parseInt(A.getNameCondition(con,"Master_LotCategory","LotCategory_Id", "Where LotCategory_Name='Jewelry' and company_id="+company_id+""));

	if(category_id ==dia_category )
	{
		query="Select cut_id,color_id,purity_id from Diamond where lot_id=?";
		pstmt_p = con.prepareStatement(query);
		pstmt_p.setString(1,lot_id);
		rs_g = pstmt_p.executeQuery();
		while(rs_g.next()) 
		{
			cut_id=A.getName(con,"Cut",rs_g.getString("cut_id"));
			if(("None".equals(cut_id))||("NONE".equals(cut_id)))
			{
				cut_id="-";
			}
			color_id=A.getName(con,"Color",rs_g.getString("color_id"));
			if(("None".equals(color_id))||("NONE".equals(color_id)))
			{
				color_id="-";
			}

			purity_id=A.getName(con,"Purity",rs_g.getString("purity_id"));
			if(("None".equals(purity_id))||("NONE".equals(purity_id)))
			{
				purity_id="-";
			}

			//weight=rs_g.getString("Weight");
		}	
		pstmt_p.close();
    	//c.returnConnection(conp);

		ret_desc="["+color_id+"/"+purity_id+"/"+cut_id+","+quality+"]";
	}
	else if(category_id == jew_category)
	{
		ret_desc="["+description+","+quality+"]";
	}
	else 
	{
		ret_desc="["+name+"/"+description+"]"; 
	}
	//System.out.println("ret_desc="+ret_desc);
	return ret_desc;
}
catch(Exception e)
		{//c.returnConnection(conp);
System.out.print("<BR>EXCEPTION in login.java at Line="+errLine+"is "+e);
	return ""+e;}
////finally{c.returnConnection(conp); }

	}//getDescription



public HashMap getDescriptionNew(Connection con, String company_id)
{
	HashMap lotDesc = new HashMap();
	try{
 
	//get the lot description for the diamond lot
	String query="Select L.Lot_Id, Lot_Name, Lot_Description, cut_name, color_name, purity_name from Lot L, Diamond D, Master_Cut MC, Master_Color MCr, Master_Purity MP where L.Lot_Id = D.Lot_Id and MC.cut_id = D.cut_id and MCr.color_id = D.color_id and MP.Purity_Id = D.Purity_Id and L.Active=1 and L.Company_Id="+company_id+" and L.LotCategory_Id IN (Select LotCategory_Id from Master_LotCategory Where LotCategory_Name='Diamond' and company_id="+company_id+")";
	pstmt_p = con.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 
	{

		String lot_id=rs_g.getString("Lot_Id");
		String lot_name=rs_g.getString("Lot_Name");
		if (rs_g.wasNull())
			{lot_name="-";}
		String description=rs_g.getString("Lot_Description");
		if (rs_g.wasNull())
			{description="-";}
		String cut_name=rs_g.getString("cut_name");
		if(("NONE".equalsIgnoreCase(cut_name)))
			{cut_name="-";}
		String color_name=rs_g.getString("color_name");
		if(("NONE".equalsIgnoreCase(color_name)))
			{color_name="-";}
		String purity_name=rs_g.getString("purity_name");
		if(("NONE".equalsIgnoreCase(purity_name)))
			{purity_name="-";}

		String retDesc = "["+color_name+"/"+purity_name+"/"+cut_name+"]" ;

		lotDesc.put(lot_id, retDesc);

	}
	pstmt_p.close();
	errLine = "182";

	//get the lot description for the jewelery lot
	query="Select L.Lot_Id, Lot_Name, Lot_Description from Lot L where L.Active=1 and L.Company_Id="+company_id+" and L.LotCategory_Id IN (Select LotCategory_Id from Master_LotCategory Where LotCategory_Name='Jewelry' and  company_id="+company_id+")";
	pstmt_p = con.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 
	{

		String lot_id=rs_g.getString("Lot_Id");
		String lot_name=rs_g.getString("Lot_Name");
		if (rs_g.wasNull())
			{lot_name="-";}
		String description=rs_g.getString("Lot_Description");
		if (rs_g.wasNull())
			{description="-";}
		
		String retDesc = "["+description+"]" ;

		lotDesc.put(lot_id, retDesc);

	}
	pstmt_p.close();
	errLine = "205";

	//get the lot description for the other types of lot
	query="Select L.Lot_Id, Lot_Name, Lot_Description from Lot L where L.Active=1 and L.Company_Id="+company_id+" and L.LotCategory_Id NOT IN (Select LotCategory_Id from Master_LotCategory Where (LotCategory_Name='Jewelry' OR LotCategory_Name='Diamond')and company_id="+company_id+")";
	pstmt_p = con.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 
	{

		String lot_id=rs_g.getString("Lot_Id");
		String lot_name=rs_g.getString("Lot_Name");
		if (rs_g.wasNull())
			{lot_name="-";}
		String description=rs_g.getString("Lot_Description");
		if (rs_g.wasNull())
			{description="-";}
		
		String retDesc = "["+lot_name+"/"+description+"]" ;

		lotDesc.put(lot_id, retDesc);

	}
	pstmt_p.close();


	}
	catch(Exception e)
	{
		System.out.print("<BR>EXCEPTION in getDescriptionNew() in login.java at Line="+errLine+" is "+e);
	}
	
	return lotDesc;

}//getDescriptionNew



/*	public static String format(java.sql.Date D)
	{ 
	String str = D.getDate() + ":"+ (Integer.parseInt((D.getMonth)+1))+":"+(Integer.parseInt((D.getYear)+1900));
	return str;
	}*/
	
public static String date(java.sql.Date D, String date ,String month,String year)
	{	
	String monthtext[]={"Jan", "Feb", "Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}; 
	int d=0,m=0,y=0;
	try {
		d = D.getDate();	m = D.getMonth()+1;	y = D.getYear()+1900;
		}catch(Exception e){ 
							d=0;m=0;y=2000;
							} 
	
	String temp ="<select name="+date+">";

	for (int dd=1;dd<32;dd++) 
		{
		temp +=" <option value="+dd;
			if(dd == d){  temp +=" selected ";}	
			temp+= "> "+dd+" </option> ";
		} 
	
	 temp +=" </select> <select name="+month +" > ";

	for (int mm=1;mm<13;mm++) 
		{
		temp +=" <option value="+mm;
			if(mm == m){  temp +=" selected ";}	
			temp+= "> "+monthtext[mm-1]+" </option> ";
		} 
	
	 temp +=" </select> <select name="+year +"  > ";
	for (int yy=2020;yy<2030;yy++) 
		{
		temp +=" <option value="+yy;
			if(yy == y){  temp +=" selected ";}	
			temp+= "> "+(yy)+" </option> ";
		} 
	return temp;
	}
	
	public static String date1(java.sql.Date D, String date ,String month,String year)
	{	
	String monthtext[]={"Jan", "Feb", "Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}; 
	int d=0,m=0,y=0;
	try {
		d = D.getDate();	m = D.getMonth()+1;	y = D.getYear()+1900;
		}catch(Exception e){ 
							d=0;m=0;y=2000;
							} 
	
	String temp ="<select name="+date+" onChange=change()>";

	for (int dd=1;dd<32;dd++) 
		{
		temp +=" <option value="+dd;
			if(dd == d){  temp +=" selected ";}	
			temp+= "> "+dd+" </option> ";
		} 
	
	 temp +=" </select> <select name="+month +" onChange=change() > ";

	for (int mm=1;mm<13;mm++) 
		{
		temp +=" <option value="+mm;
			if(mm == m){  temp +=" selected ";}	
			temp+= "> "+monthtext[mm-1]+" </option> ";
		} 
	
	 temp +=" </select> <select name="+year +" onChange=change() > ";
	for (int yy=2000;yy<2020;yy++) 
		{
		temp +=" <option value="+yy;
			if(yy == y){  temp +=" selected ";}	
			temp+= "> "+(yy)+" </option> ";
		} 
	return temp;
	}

	public static String date(java.sql.Date D, String month,String year)
	{	
	String monthtext[]={"Jan", "Feb", "Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}; 
	int d=0,m=0,y=0;
	try {
		d = D.getDate();	m = D.getMonth()+1;	y = D.getYear()+1900;
		}catch(Exception e){ 
							d=0;m=0;y=2000;
							} 
	
		
	String temp =" </select> <select name="+month +" > ";

	for (int mm=1;mm<13;mm++) 
		{
		temp +=" <option value="+mm;
			if(mm == m){  temp +=" selected ";}	
			temp+= "> "+monthtext[mm-1]+" </option> ";
		} 
	
	 temp +=" </select> <select name="+year +"  > ";
	for (int yy=2000;yy<2020;yy++) 
		{
		temp +=" <option value="+yy;
			if(yy == y){  temp +=" selected ";}	
			temp+= "> "+(yy)+" </option> ";
		} 
	return temp;
	}

		

	public static void main(String[] args) throws Exception
	{}}

