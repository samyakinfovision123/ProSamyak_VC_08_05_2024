package NipponBean;
import java.util.*;
import java.sql.*;
import NipponBean.*;
public class  NipponMethod
{
	Connection cong = null;
	Connection conp = null;
	ResultSet rs_g=null;
	Connect c;
	
	PreparedStatement pstmt_g=null;
	PreparedStatement pstmt_p=null;
	public	NipponMethod()
		{}


public int get_repeat_id(Connection con,String table,String coloumn,String strvalue) throws Exception
	{
	 //conp=c.getConnection();
	String query ="select "+coloumn+" from "+table+" where "+coloumn+"='"+strvalue+"'";
	//System.out.println("query"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 
	{ 
	 i++;
	
	}
//	System.out.println("i="+i);
	pstmt_p.close();

	if (i== 0)
	{
		return 0;
	}else{
	
	    return 1;
	  }	

	//
	}
//---------------------------------------Ambalal


public int get_repeat_id_condition(Connection con,String table,String coloumn,String strvalue,String condition) throws Exception
{
	 //conp=c.getConnection();
	String query ="select "+coloumn+" from "+table+" where "+coloumn+"='"+strvalue+"' and "+condition+"";
	//System.out.println("query"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 
	{ 
	 i++;
	
	}
//	System.out.println("i="+i);
	pstmt_p.close();

	if (i== 0)
	{
		return 0;
	}else{
	
	    return 1;
	  }	

	//
	}
//=======================================================

public String getDesign_Name(Connection con,String refDesignNo,String condition)
{

try{

String getDesignId="Select DesignGroup_Id from DesignSubGroup where DesignSubGroup_No=?";

pstmt_p=con.prepareStatement(getDesignId);
pstmt_p.setString(1,refDesignNo);

ResultSet rs_m=pstmt_p.executeQuery();
int design_id=0;
while (rs_m.next())
{
	design_id=rs_m.getInt("DesignGroup_Id");
}
pstmt_p.close();

String query="Select DesignGroup_No  from DesignGroup where DesignGroup_id=? and "+condition ;
pstmt_p=con.prepareStatement(query);
pstmt_p.setInt(1,design_id);
ResultSet rs = pstmt_p.executeQuery();
String  design_Name="";
while(rs.next()) 
{
 design_Name=rs.getString("DesignGroup_No");
}
return ""+design_Name;

}catch(Exception e)
 {//	c.returnConnection(conp);
		return ""+e;}


}
//=======================================================

public String getDesign_wt(Connection con,String table,String condition)
{
try{
String getDesignWt="Select * from "+table+""+condition;

pstmt_p=con.prepareStatement(getDesignWt);
ResultSet rs_m=pstmt_p.executeQuery();
int design_id=0;
double totalDiamond_wt=0;
double totalStone_wt=0;
double total_wt=0;
while (rs_m.next())
{
	totalDiamond_wt =rs_m.getDouble("Total_Diamon_Wt");
	totalStone_wt	=rs_m.getDouble("Total_ColorStone_Wt");
}

total_wt=totalDiamond_wt+totalStone_wt;

pstmt_p.close();

return ""+total_wt;

}catch(Exception e)
 {//	c.returnConnection(conp);
		return ""+e;}





}
//=======================================================
public String getDesign_id(Connection con,String condition)
{
try{
String query="Select Design_Id from Flute_Detail "+condition ;
pstmt_p=con.prepareStatement(query);
ResultSet rs = pstmt_p.executeQuery();
 int design_id=0;
while(rs.next()) 
{
 design_id=rs.getInt("Design_Id");

}
return ""+design_id;

}catch(Exception e)
 {//	c.returnConnection(conp);
		return ""+e;}

}

public int getCount_No(Connection con,String tablename,String fieldname , String condition)throws Exception
{
String query="Select count("+fieldname+")as counter from "+tablename+" "+condition ;
pstmt_p=con.prepareStatement(query);
ResultSet rs = pstmt_p.executeQuery();
//int flute_id=1;
int counter=0;
while(rs.next()) {
counter=rs.getInt("counter");
}
pstmt_p.close();
counter++;
return counter;

}





//---------------------Lalit Method-------------------------
public String getMasterArray(Connection con,String table, String html_name,String str)
{
		
	try{
	// conp=c.getConnection();
	String query ="select * from Master_"+table+"  order by "+table+"_name ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onchange='TakeMenu()'>";
	while(rs.next())
		{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(table+"_name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	} //getMasterArray Method

//----------------Manoj Method Final------------------------


public String getMasterArray(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
	System.out.println("230 query->"+query);
	int i=0;

	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next())
	{i++;}
pstmt_p.close();

	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}
//----------------------------------for Multiple selection by Dnyanesh------- 

public String getMasterArrayMultiple(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
	System.out.println("281 query->"+query);
	//int i=0;
	//pstmt_p = con.prepareStatement(query);
	//ResultSet rs = pstmt_p.executeQuery();
	//while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' multiple size=5";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' selected>select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}


//----------------------------------for Multiple selection by Sujit------- 

public String getMasterArraySameMultiple(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select distinct("+coloumn_Name+") from "+table+ condition+""; 
//	System.out.println("query->"+query);
	//int i=0;
	//pstmt_p = con.prepareStatement(query);
	//ResultSet rs = pstmt_p.executeQuery();
	//while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' multiple size=5";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' selected>select</option>";
	while(rs.next())
		{
		 //String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp +"'"; 
		 if(temp.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}

//----------------------------Comparision with Name by manoj ----
public String getMasterArrayName(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
//	System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}


//------------------------------------------------------------------------------



//--------------------------------Coloumn id and coloumn name same ---------------
public String getMasterArraySame(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_Name,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
	// System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 //String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp +"'"; 
		 if(temp.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}



//---------------------------------------------------------------------------




public String getMasterArray(Connection con,String table, String condition , String html_name,String str,String coloumn_id,String coloumn_Name,String All)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition +"";
	//System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'  >";
	if("1".equals(All))
	{
		html_array = html_array + "<option value='0'>All</option>";
	}  
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}




public String getMasterArrayCondition(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String number,String argument)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
	//System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	
	 html_array=html_array+ " onChange='TakeMenu"+number+"("+argument+")'";
	
  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}


//-----------------------------------------------------------------------

public String getMasterArrayToFrom(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name1,String coloumn_Name2,String script,String number)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
//	System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name1).trim();
		 String temp2 = rs.getString(coloumn_Name2).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" To "+temp2+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}

public double getGoldRate(double pureGoldRate,double loss,double ConveredTo,String flag)
{
//flag=1 Gold Rate with consideration of loss
//flag=0 Gold Rate without consideration of loss
double newGoldRate=0;
if(flag.equals("1"))
{
newGoldRate=(pureGoldRate*(1+(1*(loss/100)))*(ConveredTo/24));
}

if(flag.equals("0"))
{
 newGoldRate=(pureGoldRate*(ConveredTo/24));
}

return newGoldRate;

}//end getGold Rate






//method for appending the text such as setting tabindex or making readonly
//directly write code in last parameter


public String getMasterArrayAppend(Connection con,String table, String condition ,String html_name,String str,String order,String coloumn_id,String coloumn_Name,String script,String number, String lastString)
	{
		
	try{
	// conp=c.getConnection();
	String query ="select * from "+table+ condition+" order by "+order+"";
//	System.out.println("query->"+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'";
//with onclick event than script=1
//No Script script=0
	if(script.equals("1"))
		{
		  html_array=html_array+ " onChange='TakeMenu"+number+"()'";
		}

  html_array=html_array + " " + lastString + ">";

  html_array= html_array + "<option value='-1' >select</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn_Name).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//	c.returnConnection(conp);
		//System.out.println("Error="+e);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}








	public static void main(String[] args) throws Exception
	{}
}

