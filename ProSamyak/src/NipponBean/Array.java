
/*
----------------------------------------------------------------------------------------------
* ModifiedBy		Date				Status		Reasons
----------------------------------------------------------------------------------------------
* Mr Ganesh         22-04-2011          Done        add to MVC design pattern         
----------------------------------------------------------------------------------------------
*/

package NipponBean;
import java.util.*;

import java.io.*;
import java.sql.*;
import NipponBean.*;
public class Array 
{
	static String errLine="14";
	private	Connection conp		= null;
	private	PreparedStatement pstmt_p=null;
	private PreparedStatement pstmt_g=null;
	private ResultSet rs_g=null;
	public  int sizeid=0;
	public  int colorid=0;
		
//	Connect1 c;
	//static String errLine="";
 	public Array()
	{
	/*try{
		c=new Connect1();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/
	}
	
 	public String getMasterArrayConditionStock(Connection con, String table, String html_name,String str,String condition , String id  , String coloum)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+id+"  , "+coloum+" from "+table+" "+condition+"";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString(id).trim();		
		 String temp = rs.getString(coloum).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//C.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

 	public String getMasterArrayStock(Connection con, String table, String html_name,String str,String condition , String id  , String coloum)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+id+"  , "+coloum+" from "+table+" "+condition+"";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()'  >";
	while(rs.next())
		{
		 String temp1 = rs.getString(id).trim();		
		 String temp = rs.getString(coloum).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//C.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
 	public String getMasterArrayNoChange(Connection con, String table, String html_name,String str,String condition , String id  , String coloum)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+id+"  , "+coloum+" from "+table+" "+condition+"";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()' >";
	while(rs.next())
		{
		 String temp1 = rs.getString(id).trim();		
		 String temp = rs.getString(coloum).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//C.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

 	
	public String getPriviledgeLevelArray(Connection con,String html_name, String value) throws Exception
	{
		
	try{
				errLine="31";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("46 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	try{
	// conp=c.getConnection();
	
	String query ="select Priviledge_Id,priviledge_Name from Master_PriviledgeLevel  where active=1 order by Sr_No";

	int level_no = Integer.parseInt(value);
	int i=0;
	errLine="56";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs_g = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs_g.next())
		{
		String temp_level = rs_g.getString("Priviledge_Id");
		String temp_code = rs_g.getString("priviledge_Name");
		html_array = html_array +"<option value='"+temp_level +"'"; 
		if(temp_level.equals(value)){ html_array = html_array +" selected ";}
		html_array = html_array +" > "+temp_code+" </option> ";
		}
		html_array = html_array +" </select> ";
//	System.out.println(html_array);
	pstmt_p.close();
errLine="74";
	//c.returnConnection(conp);

	
	return html_array;
	}
	catch(Exception e ){
	System.out.println("81 Error in Array.java at Line="+errLine+"is "+e);
		//c.returnConnection(conp);
	return ""+e;
}
//finally{c.returnConnection(conp); }
	}//method
	
	public String getPriviledgeLevelArray(Connection con, String html_name, String Priviledge_Id,String value) throws Exception
	{
	try{
	// conp=c.getConnection();
	errLine="90";
	String query ="select Priviledge_Id,priviledge_Name from Master_PriviledgeLevel where Priviledge_Id >? and  active=1 order by Sr_No";

	int level_no = Integer.parseInt(Priviledge_Id);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setInt(1,level_no);
	ResultSet rs_g = pstmt_p.executeQuery();
	while(rs_g.next()) 		{i++; }
	
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setInt(1,level_no);
	rs_g = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs_g.next())
		{
		String temp_level = rs_g.getString("Priviledge_Id");
		String temp_code = rs_g.getString("priviledge_Name");

		html_array = html_array +"<option value='"+temp_level +"'"; 
		if(temp_level.equals(value)){ html_array = html_array +" selected ";}
		html_array = html_array +" > "+temp_code+" </option> ";
		}
		html_array = html_array +" </select> ";
	//System.out.println(html_array);
	pstmt_p.close();
	//c.returnConnection(conp);

	return html_array;
	}catch(Exception e){//c.returnConnection(conp);
	System.out.println("122 Error in Array.java at Line="+errLine+"is "+e);
	return ""+e ;}
	}

//-------------------------Get Party Array-------------------------------------		
public String getPartyArray(Connection con, String html_name,String str,String type, String company_id)
	{
	//System.out.println("113 Inside the method");
		try{
				errLine="128";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("146 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
		// conp=c.getConnection();
	String query ="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where active=1 and super=0 and company_id="+company_id+"";
	
	if("Purchase".equals(type))
	{
		query=query+" and purchase=1  ";
	}

	if("PN".equals(type))
	{
		query=query+" and PN=1 ";
	}
	
	if("Sale".equals(type))
	{
		query=query+" and Sale=1 ";
	}

	
	query = query + "  order by CompanyParty_Name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	
	while(rs.next()) 		
	{
		i++;
	}
	
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();

	String html_array ="<select name='"+html_name+"' >";

	if(type.equals("Sale"))
	{ 
		 html_array = html_array +"<option value='0'>All (Local-Export) </option> <option value='l'>All-Local</option><option value='d'>All-Export</option>"; 
    }
	else if(type.equals("Purchase"))
	{
		 html_array = html_array +"<option value='0'>All (Local-Import) </option> <option value='l'>All-Local</option><option value='d'>All-Import</option>"; 
	}

//System.out.println("176 ");
	while(rs.next())
		{
		 String temp1 = rs.getString("CompanyParty_Id").trim();		
		 String temp = rs.getString("CompanyParty_Name").trim();
		 errLine="195";

		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str))
			{
			 html_array = html_array +" selected ";
			}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
	//System.out.println(html_array);
		//pstmt_p.close();
		//c.returnConnection(conp);
		//System.out.print("under try");
		return html_array;
	
	}
	
	catch(Exception e)
		{ 	//c.returnConnection(conp);
	System.out.println("219 Error in Array.java at Line="+errLine+"is "+e);
			return ""+e;}
			//finally{c.returnConnection(conp);}

	}//
//--------------------------------------------------------------------------------------------------------------------------------------------
	public String getMasterArrayToolTip(Connection con,String table, String html_name,String str)
	{
		try{
			String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 order by "+table+"_name ";
			
			pstmt_p = con.prepareStatement(query);
			ResultSet rs = pstmt_p.executeQuery();
			String html_array ="<select name='"+html_name+"'>";
			while(rs.next())
			{
				String temp1 = rs.getString(table+"_id").trim();
				String temp = rs.getString(table+"_name").trim();
				html_array = html_array +"<option value='"+temp1 +"'";
				if(temp1.equals(str)){
					html_array = html_array +" selected ";
				}
				html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
			//System.out.println(html_array);
			pstmt_p.close();
		
			return html_array;
		}
		catch(Exception e)
		{
			System.out.println("275 Error in Array.java at Line="+errLine+"is "+e);
			return ""+e;
		}
	}

	public String getMasterArray(Connection con,String table, String html_name,String str)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				 System.out.println("244 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	// conp=c.getConnection();
	//System.out.println("str = "+str);
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 order by "+table+"_name ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
	System.out.println("275 Error in Array.java at Line="+errLine+"is "+e);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}//

	public String getMasterArrayALL(Connection con,String table, String html_name,String str)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				 System.out.println("244 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 order by "+table+"_name ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array += "<option value='0'>All</option>";
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
	System.out.println("275 Error in Array.java at Line="+errLine+"is "+e);
		return ""+e;}
		//finally{c.returnConnection(conp); }

	}//

	public String getMasterArrayCondition(Connection con, String table, String html_name,String str,String condition,double tempStr)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+"";
//	System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array = html_array + "<option value=0 selected>ALL</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(table+"_name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +"  ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	public String getMasterArrayCondition(Connection con, String table, String html_name,String str,String condition)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+"";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//C.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	
	
	
	public String getStockShape(Connection con, String html_name, String str)
	{
	try{
	 //conp=c.getConnection();
	String query ="select ShapeId ,ShapeName from StockShape where active=1 ";
	
	int i=0;
	errLine="299";
	//System.out.println("query "+query);
	pstmt_p = con.prepareStatement(query);
	
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()){i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("ShapeId").trim();	
		 String temp = rs.getString("ShapeName").trim();
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str))
		 { 
			 html_array = html_array +" selected ";
		 }
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
	
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	
	}//getMasterArrayNoActive
	
	public String getStockSize(Connection con ,  String html_name  , String str)
	{
	try{
	 //conp=c.getConnection();
	String query ="select SizeId ,SizeName from StockShapeSize where active=1 ";
	
	int i=0;
	errLine="299";
	
	pstmt_p = con.prepareStatement(query);
	
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()){i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("SizeId").trim();	
		 String temp = rs.getString("SizeName").trim();
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
	
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	
	}//getMasterArrayNoActive
	
	//100
	public String getStockSizeChange(Connection cong, String html_name, String str ,String condition)
	{ 
		String 	html_array = "";
		try {
	//String 	query ="Select LotSubCategory_Id,LotSubCategory_Name from Master_LotSubCategory where Active=1 and  Company_Id="+company_id+" and LotCategory_Id="+lotCategoryId+" order by LotSubCategory_Name";
	String query ="select SizeId ,SizeName from StockShapeSize where active=1  and  StockShId  ="+condition ;
	//System.out.println("query "+query);
	pstmt_g = cong.prepareStatement(query);
		rs_g = pstmt_g.executeQuery();

	
		html_array ="<select name='html_name'>";
		
		while(rs_g.next())
		{
			 String temp1 = rs_g.getString("SizeId");		
			 String temp = rs_g.getString("SizeName");
			 if(!"null".equals(condition )){
				 if(temp1.equals(condition)){
					html_array = html_array +"<option value='"+temp1 +"' selected>"+temp+"</option>";
				 }
				 else{
					 html_array = html_array +"<option value='"+temp1 +"'>"+temp+"</option>";
				 }
			 }
			 else{
				 html_array = html_array +"<option value='"+temp1 +"'>"+temp+"</option>"; 
			 }

		}

		html_array = html_array +" </select> ";
		pstmt_g.close();	
		//System.out.println(html_array);
		
	}catch (Exception e){
		System.out.println("error in Array.java  file "+e);
		
	}
	return html_array;
	}
	
	
	
	public String getStockColor(Connection con, String html_name, String str)
	{
	try{
	 //conp=c.getConnection();
	String query ="select Sizeid,SizeName from StockShSz where active=1 ";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("SizeId").trim();		
		 String temp = rs.getString("SizeName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
	
	
	
	
	public String getStockSizeColor(Connection con, String stockszid, String html_name, String str )
	{
	try{
	 //conp=c.getConnection();
	String query ="select Colorid,ColorName from StockShapeSizeColor where sizeid="+stockszid+" and active=1 ";
//System.out.println("query color table  iscccccccccccccccc "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()'  >";
	int j=1;
	while(rs.next())
		{
		 String temp1 = rs.getString("ColorId").trim();		
		 String temp = rs.getString("ColorName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 
		 if(j==Integer.parseInt(str)||temp1.equalsIgnoreCase(str)||j==1)
			{ html_array = html_array +" selected ";
			 colorid= rs.getInt("ColorId");
			 }
			 html_array = html_array +" > "+temp+" </option> ";
			 j++;
			}
		 
		
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	public String getStockQuality(Connection con, String stockszid, String html_name, String str )
	{
	try{
	 //conp=c.getConnection();
	String query ="select QualityId,QualityName from StockShapeSizeColorQuality where Colorid ="+stockszid+" and active=1 ";
//System.out.println("query color table else   iscccccccccccccccc "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'   >";
	while(rs.next())
		{
		 String temp1 = rs.getString("QualityId").trim();		
		 String temp = rs.getString("QualityName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	
	
	public String getStockShapeSize(Connection con, String stockshid, String html_name, String str)// 608
	{
	try{
	 //conp=c.getConnection();
		//sizeid=Integer.parseInt(str);
		String query ="select Sizeid,SizeName from StockShapeSize where Shapeid="+stockshid+" and active=1 ";
	//System.out.println("query is shshshshsh "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()' >";
	int j=1;
	while(rs.next())
		{
		 String temp1 = rs.getString("SizeId").trim();		
		 String temp = rs.getString("SizeName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		/* if(temp1.equalsIgnoreCase(str))
		 { html_array = html_array +" selected ";
		   sizeid=rs.getInt("SizeId");
		   System.out.println("sizeid"+sizeid);
		 } */
		 if(j==Integer.parseInt(str)||temp1.equalsIgnoreCase(str)||j==1)
		 { html_array = html_array +" selected ";
		   sizeid=rs.getInt("SizeId");
		   //System.out.println("sizeid***********"+sizeid);
		 }
		 html_array = html_array +" > "+temp+" </option> ";
		 j++;
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
	public String getStockShapeSize2(Connection con, String stockshid, String html_name, String str)// 608
	{
	try{
	 //conp=c.getConnection();
	String query ="select Sizeid,SizeName from StockShapeSize where Shapeid="+stockshid+" and active=1 ";
	//System.out.println("query is "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("SizeId").trim();		
		 String temp = rs.getString("SizeName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str))
		 { html_array = html_array +" selected ";
		 }
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
	
	public String getStockShape2(Connection con, String html_name, String str)
	{
	try{
	 //conp=c.getConnection();
	String query ="select ShapeId ,ShapeName from StockShape where active=1 ";
	
	int i=0;
	errLine="299";
	
	pstmt_p = con.prepareStatement(query);
	
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()){i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'onChange='change()' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("ShapeId").trim();	
		 String temp = rs.getString("ShapeName").trim();
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str))
		 { 
			 html_array = html_array +" selected ";
		 }
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
	
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	
	}//getMasterArrayNoActive

	
	public String getStockSizeColor2(Connection con, String stockszid, String html_name, String str )
	{
	try{
	 //conp=c.getConnection();
	String query ="select Colorid,ColorName from StockShapeSizeColor where sizeid="+stockszid+" and active=1 ";
//System.out.println("query color table  isccccccccccccccccc "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' onChange='change()'  >";
	int j=1;
	while(rs.next())
		{
		 String temp1 = rs.getString("ColorId").trim();		
		 String temp = rs.getString("ColorName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(j==Integer.parseInt(str)||temp1.equalsIgnoreCase(str)||j==1)
		{ html_array = html_array +" selected ";
		 colorid= rs.getInt("ColorId");
		 }
		 html_array = html_array +" > "+temp+" </option> ";
		 j++;
		}
	
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
	public String getStockSizeColorQ(Connection con, String colorid, String html_name, String str )
	{
	try{
	 //conp=c.getConnection();
	String query ="select QualityId ,QualityName from StockShapeSizeColorQuality where Colorid ="+colorid+" and active=1 ";
//System.out.println("query color table if  isccccccccccccccccc "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'   >";
	while(rs.next())
		{
		 String temp1 = rs.getString("QualityId").trim();		
		 String temp = rs.getString("QualityName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	
	
	public String getStockSizeColorQuality(Connection con, String colorid, String html_name, String str )
	{
	try{
	 //conp=c.getConnection();
	String query ="select Colorid,ColorName from StockShapeSizeColorQuality where colorid ="+colorid+" and active=1 ";
//System.out.println("query color table  isccccccccccccccccc "+query);
	int i=0;
	errLine="299";
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"'   >";
	while(rs.next())
		{
		 String temp1 = rs.getString("ColorId").trim();		
		 String temp = rs.getString("ColorName").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equalsIgnoreCase(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
	
	
	public String getMasterArrayConditionSelect(Connection con, String table, String html_name,String str,String condition,String country_code)
	{
		try
		{
			FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
			BufferedReader br = new BufferedReader(f);
			String text=br.readLine();
			if("A H I M S A".equals(text))
			{ 
				br.close();				
			}
			else
			{ 
				br.close();				
				return "<select name=Diajewel ><option ></option></select> ";
			}
        }
		catch(IOException e )
        { 
			System.out.println("298 Error in Array.java at Line="+errLine+"is "+e);
			return "<select name=Diajewel ><option ></option></select> ";
        }
	
		try
		{
			//conp=c.getConnection();
			String query ="";
			if("US".equals(country_code))
			{
				query = "select "+table+"_id,"+table+"_name from Master_"+table+" "+condition;
			}
			else
			{
				query = "select "+table+"_id,"+table+"_name_native as "+table+"_name from Master_"+table+" "+condition;
			}
	//System.out.println("query is "+query);
	//System.out.println("486 **** html_name = "+html_name);
			int i=0;
			errLine="299";
			pstmt_p = con.prepareStatement(query);
			ResultSet rs = pstmt_p.executeQuery();
			while(rs.next())
			{
				i++;
			}
			pstmt_p.close();

			pstmt_p = con.prepareStatement(query);
			rs = pstmt_p.executeQuery();
			String html_array ="<select name='"+html_name+"'>";
			html_array = html_array +"<option value=-1>Select</option>";
			while(rs.next())
			{
				String temp1 = rs.getString(table+"_id").trim();		
				String temp = rs.getString(table+"_name").trim();
		 
				html_array = html_array +"<option value='"+temp1 +"'"; 
				if(temp1.equals(str)){ html_array = html_array +" selected ";}
				html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
	//System.out.println(html_array);
			pstmt_p.close();
			//	c.returnConnection(conp);

			return html_array;
		}
		catch(Exception e)
		{
			//c.returnConnection(conp);
			System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
			return ""+e;
		}
		//finally{c.returnConnection(conp);  }

	}
//----------------------------------------------------------------

	public String getCashAccounts(Connection con,String html_name,String str,String company_id,String type)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				 System.out.println("355 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select Account_id,Account_name from Master_Account where AccountType_Id=6 and Company_Id="+company_id+" and Active=1";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 
	{
		i++; 
	}
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' > ";
	if("0".equals(type))
	{
		html_array=html_array+"<option value='0'>Regular</option>";
	}
	else
		{
		html_array=html_array+"<option value='0'>Regular</option>";
		}
	while(rs.next())
		{
		 String temp1 = rs.getString("Account_id").trim();		
		 String temp = rs.getString("Account_name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);

		return html_array;
	}catch(Exception e)
		{//c.returnConnection(conp);
	System.out.println("395 Error in Array.java at Line="+errLine+"is "+e);
 return ""+e;}
 //finally{c.returnConnection(conp);  }

	}//getCashAccounts


//-----------------------------------------------------------------
public String getMasterArraySrNo(Connection con,String table, String html_name,String str)
	{
		try{
				errLine="395";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("421 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 order by Sr_No  ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next())
	{
		i++;
	}
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{//c.returnConnection(conp);
	System.out.println("451 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//ORDER BY SR_NO



public String getMasterArraySrNoAll(Connection con,String table, String html_name,String str)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("476 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 order by Sr_No";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array += "<option value='0'>All</option>";

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
		{	//c.returnConnection(conp);
	System.out.println("509 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//ORDER BY SR_NO

	
	public String getMasterArray(Connection con,String table, String html_name,String str, String Company_id)
	{
		try{
				errLine="504";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("534 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 and Company_id="+Company_id+" order by "+table+"_name ";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("565 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//

	public String getArray(Connection con,String table, String html_name,String str, String Company_id,String type)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("588 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="";
	if("Payment".equals(type))
		{
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head not like 12 and Company_id="+Company_id+" order by "+table+"_name ";
	}
	else if("Journal".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and  Company_id="+Company_id+" order by "+table+"_name ";
	}

else if("Party".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head like 14 and Company_id="+Company_id+" order by "+table+"_name ";
	}

else if("Ledger".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head not like 14 and Company_id="+Company_id+" order by "+table+"_name ";
	}

else if("Indirect_Expense".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head  like 13 and Company_id="+Company_id+" order by "+table+"_name ";
	}

else if("Indirect_Income".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head  like 12 and Company_id="+Company_id+" order by "+table+"_name ";
	}
else if("Expense".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and (For_Head=6 or For_Head=12 or For_Head=13) and Company_id="+Company_id+" order by "+table+"_name ";
}

else if("PN Loan".equals(type)){
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head=7 and Company_id="+Company_id+" order by "+table+"_name ";
}

	else{
query ="select "+table+"_id,"+table+"_name from "+table+"   where active=1 and For_Head not like 13  and Company_id="+Company_id+" order by "+table+"_name ";
	}
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		//c.returnConnection(conp);

		pstmt_p.close();
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
	System.out.println("653 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//



public String getMasterArraySrNo(Connection con,String table, String html_name,String str, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { System.out.println("677 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 and Company_id="+Company_id+" order by Sr_No";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("707 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//ORDER BY SR_NO


	public String getMasterArrayNoActive(Connection con,String table, String html_name,String str, String Company_id)
	{
		try{
				errLine="697";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("732 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  //	 conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" where Company_id="+Company_id+"  order by "+table+"_name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("762 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//getMasterArrayNoActive

	public String getMasterArrayCondition(Connection con,String table, String html_name,String str,String condition, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("785 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+" and Company_id="+Company_id+" and Active=1 order by "+table+"_name";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("816 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive


	public String getMasterArrayConditionActive(Connection con,String table, String html_name,String str,String condition, String Company_id)
	{
		try{
				errLine="802";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("841 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+" and Company_id="+Company_id+" order by "+table+"_name";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("872 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive

	//start:For Other Langauge
 public String getMasterArrayConditionActiveOther(Connection con,String table, String html_name,String str,String condition, String Company_id)
 {
   try
   {
                errLine="802";
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text=br.readLine();
                if("A H I M S A".equals(text))
                    { 
                    br.close();             
        
                    }
                else{ 
                    br.close();             
                    return "<select name=Diajewel ><option ></option></select> ";
                    }
             }catch(IOException e )
             { 
                System.out.println("841 Error in Array.java at Line="+errLine+"is "+e);
                return "<select name=Diajewel ><option ></option></select> ";
             }
    
    try{
     //conp=c.getConnection();
    String query ="select "+table+"_id,"+table+"_name_JP from Master_"+table+" "+condition+" and Company_id="+Company_id+" order by "+table+"_name";
//  System.out.println("query is "+query);
    int i=0;
    pstmt_p = con.prepareStatement(query);
    ResultSet rs = pstmt_p.executeQuery();
    while(rs.next())        {i++; }
    pstmt_p = con.prepareStatement(query);
    rs = pstmt_p.executeQuery();
    String html_array ="<select name='"+html_name+"' >";
    while(rs.next())
        {
         String temp1 = rs.getString(table+"_id").trim();       
         String temp = rs.getString(table+"_name_JP").trim();
         
         html_array = html_array +"<option value='"+temp1 +"'"; 
         if(temp1.equals(str)){ html_array = html_array +" selected ";}
         html_array = html_array +" > "+temp+" </option> ";
        }
        html_array = html_array +" </select> ";
//      System.out.println(html_array);
        pstmt_p.close();
        //c.returnConnection(conp);
        return html_array;
    }catch(Exception e)
        {   //c.returnConnection(conp);
    System.out.println("872 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

    }//getMasterArrayNoActive
    
    //end:For Other Language
	public String getArrayConditionAll(Connection con,String table, String html_name,String str,
            String condition,String coloumn_id,String coloumn)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }
             catch(IOException e )
             { 
				System.out.println("901 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select "+coloumn_id+","+coloumn+" from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array += "<option value='0'>All</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
errLine="900";
		pstmt_p.close();
	//	c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
	System.out.println("934 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getArrayConditionAll







public String getMasterArrayConditionLot(Connection con,String html_name,String str,String condition)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("963 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  //	 conp=c.getConnection();
	String query ="select Lot_id,Lot_no from Lot "+condition+" Order by Lot_id" ;
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("Lot_id").trim();		
		 String temp = rs.getString("Lot_no").trim();
		 
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
		{	//c.returnConnection(conp);
	System.out.println("994 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//getMasterArrayCondition




public String getMasterArrayCountry(Connection con,String table, String html_name,String str, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1020 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name,city,country from Master_"+table+" where active=1 and Company_id="+Company_id+" order by "+table+"_name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	errLine="1000";
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(table+"_name").trim();
		String city=rs.getString("city").trim();		 
		String country = rs.getString("country").trim();		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+", "+city+", "+country+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
	System.out.println("1052 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}// master country




public String getMasterArrayAll(Connection con,String table, String html_name,String str, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				 System.out.println("1078 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 and Company_id="+Company_id+" order by "+table+"_name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array += "<option value='0'>All</option>";
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
		{	//c.returnConnection(conp);
	System.out.println("1109 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//

	public String getMasterArray(Connection con,String table, String html_name,String str, String Company_id, String condition)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1132 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	errLine="1104";
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition;
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
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
		{	//c.returnConnection(conp);
	System.out.println("1165 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//

//----------------------------------------------------------------------------------------
public String getMasterArrayAll(Connection con,String table, String html_name,String str, String Company_id, String condition)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1132 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	errLine="1104";
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition;
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array += "<option value='0'>All</option>";
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
		{	//c.returnConnection(conp);
	System.out.println("1165 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//

//----------------------------------------------------------------------------------------

public String getMasterArrayAccount(Connection con,String html_name,String str, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1190 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();

	String query ="select Account_Id,Account_Name from Master_Account where active=1 and Company_id="+Company_id+" order by Account_Name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
//	html_array += "<option value='0'>Cash</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString("Account_Id").trim();		
		 String temp = rs.getString("Account_Name").trim();
		 
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
	System.out.println("1223 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//


public String getMasterArrayAccount(Connection con,String html_name,String str, String Company_id,String type)
	{
		try{
				errLine="1195";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1248 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();

String query ="";
	if("Normal".equals(type))
		{
	 query ="select Account_Id,Account_Name from Master_Account   where active=1 and Company_id="+Company_id+" and Account_name not like 'PN Account' order by Account_Name";
		}
	else if("PN".equals(type))
		{
	 query ="select Account_Id,Account_Name from Master_Account   where active=1 and Company_id="+Company_id+" and Account_name not like 'PN Account' and AccountType_Id=1 order by Account_Name";
		}

else{
	 query ="select Account_Id,Account_Name from Master_Account   where active=1 and Company_id="+Company_id+" order by Account_Name";
}
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
//	html_array += "<option value='0'>Cash</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString("Account_Id").trim();		
		 String temp = rs.getString("Account_Name").trim();
		 
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
		{	//c.returnConnection(conp);
	System.out.println("1292 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//




	public String getCurrencyArray(Connection con,String html_name,String str ,String Company_id)
	{
try{
  	// conp=c.getConnection();
	String query ="select Currency_id,Currency_name from Master_Currency   where active=1 and Company_id="+Company_id+" order by Currency_name";
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	html_array =html_array + "<option value='0'>Dollar</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString("Currency_id").trim();		
		 String temp = rs.getString("Currency_name").trim();
		 
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
		{	//c.returnConnection(conp);
	System.out.println("1330 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//

public String getCompanyPartyArray(Connection con,String type, String html_name,String str, String Company_id)
	{
		try{
				errLine="1298";
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1354 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query="";	
	if("company".equals(type))
		{
	query ="select * from Master_CompanyParty  where company=1 and active=1 and Company_id="+Company_id+" order by companyparty_name";
		}
	else{
	query ="select companyparty_id,companyparty_name from Master_CompanyParty  where company=0 and active=1 and Company_id="+Company_id+" order by companyparty_name";
	}
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString("companyparty_id").trim();		
		 String temp = rs.getString("companyparty_name").trim();
		 
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
		{	
		//c.returnConnection(conp);
		System.out.println("1392 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//




public String getMasterArrayCondition(Connection con,String table, String html_name,String condition, String Coloum ,java.sql.Date D1, java.sql.Date D2)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("1418 Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+Coloum+" from "+table+" "+condition+" order by "+table+"_id";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setString(1,""+D1);
	pstmt_p.setString(2,""+D2);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	pstmt_p.setString(1,""+D1);
	pstmt_p.setString(2,""+D2);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	while(rs.next())
		{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(Coloum).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
//		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);
		errLine="1405";
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
	System.out.println("1445 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp); }

	}//getMasterArrayNoActive

public String getName(Connection con,String table,String Id) throws Exception
	{
try{
  	// conp=c.getConnection();
	String query ="select "+table+"_Name from Master_"+table+" where "+table+"_Id="+Id+"" ;
	//System.out.println("query="+query);
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	String master= ""+table+"_Name";
	//System.out.println("master=" +master);
	while(rs.next()) 	
	{
//		 name = rs.getString("City_Name");
	 name = rs.getString(table+"_Name").trim();
	}

	pstmt_p.close();
	//c.returnConnection(conp);
	return name;
	}catch(Exception e)
	{	//c.returnConnection(conp);
	System.out.println("1482 Error in Array.java at Line="+errLine+"is "+e);
return ""+e;}
//finally{c.returnConnection(conp); }

	}





public String getName(Connection con,String table,String coloum, String Id) throws Exception
	{
	try{
  	// conp=c.getConnection();
	String query ="select "+coloum+" from "+table+" where "+table+"_Id="+Id+"" ;
	//System.out.println("query="+query);
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	String master= ""+table + "_Name";
	//System.out.println("master=" +master);
	while(rs.next()) 	
	{
//		 name = rs.getString("City_Name");
	 name = rs.getString(coloum).trim();
	}

	pstmt_p.close();
	//c.returnConnection(conp);

	return name;
	}catch(Exception e)
	{	//c.returnConnection(conp);
	System.out.println("1515 Error in Array.java at Line="+errLine+"is "+e);
return ""+e;}
//finally{c.returnConnection(conp); }

	}


public String getName(Connection con,String table,String coloum,String coloumid , String Id) throws Exception
	{
try{errLine="1524";
  	 //conp=c.getConnection();
	String query ="select "+coloum+" from "+table+" where "+coloumid+"="+Id+"" ;
	//System.out.println("query="+query);
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	String master= ""+table + "_Name";
	//System.out.println("master=" +master);
	while(rs.next()) 	
	{
//		 name = rs.getString("City_Name");
	 name = rs.getString(coloum).trim();
	}

	pstmt_p.close();
	//c.returnConnection(conp);
	return name;
}catch(Exception e)
	{	//c.returnConnection(conp);
System.out.println("1544 Error in Array.java at Line="+errLine+"is "+e);
return ""+e;}
//finally{c.returnConnection(conp); }

	}

public String getNameCondition(Connection con,String table,String coloum, String condition) throws Exception
	{
	try{
	String query ="select "+coloum+" from "+table+" "+condition;
	//System.out.println("query=====aaaaaaaaa "+query);
	pstmt_p = con.prepareStatement(query);
	
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	while(rs.next()) 	
	{
	 name = rs.getString(coloum).trim();
	}
	pstmt_p.close();

	return name;
		}
catch(Exception e)
	{	
System.out.println("1578 Error in Array.java at Line="+errLine+"is "+e);
return "";}
	}//

public String getNameConditionSum(Connection con,String table,String coloum,String cl, String condition)
	{
try{
  	 //conp=c.getConnection();
	String query ="select "+coloum+" as "+cl+" from "+table+" "+condition+"" ;
	//System.out.println("query="+query);
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	while(rs.next()) 	
	{
	 name = rs.getString(cl).trim();
//	 	System.out.println("Samyak1"+name);

	}

	pstmt_p.close();
	//c.returnConnection(conp);

//	System.out.println("1name"+name);
	
	return name;
	}
catch(Exception e)
	{	//c.returnConnection(conp);
System.out.println("1608  Error in Array.java at Line="+errLine+"is "+e);
return "0";}
//finally{c.returnConnection(conp); }

}

//--------------------------------------------------------------------
	public String getCategoryArray(Connection con,String table, String html_name,String str,String condition,String coloumn_id,String coloumn,String flag)
{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Royal ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				System.out.println("Error in Array.java at Line="+errLine+"is "+e);
				return "<select name=Royal ><option ></option></select> ";
             }
	
	try{
  //	 conp=c.getConnection();
	String query ="select "+coloumn_id+","+coloumn+" from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' >";
	if(flag=="1")//flag=1 means array for Report
	{
	html_array += "<option value='999'>All</option><option value='0'>Mixed</option>";
	}
	errLine="1600";
	if(flag=="0")//flag=0 means array for sale/purchase
	{
		html_array += "<option value='0'>Mixed</option>";
	}

	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn).trim();
		 
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
		{	//c.returnConnection(conp);
	System.out.println("1674 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}
//------------------------------------------------------------------------

// getMasterArrayCondition For Multiple
	public String getMasterArrayConditionMultiple(Connection con,String table, String html_name,String str,String condition, String Company_id)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select * from Master_"+table+" "+condition+" and Company_id="+Company_id+" and Active=1 order by "+table+"_name";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' multiple size=3 style='width:100;font-size:12;'>";
	html_array = html_array +" <option value=0 selected>All</option> ";
	while(rs.next())
		{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(table+"_name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +"";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
		//c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
  return "22"+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
// End multiple 
/*public String getNameCondition(Connection con,String table,String coloum, String condition) throws Exception
{
try
{
	String query ="select * from "+table+" "+condition+"" ;

	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	String name="";
	
	while(rs.next()) 	
	{
		 name = rs.getString(coloum).trim();
	}
	pstmt_p.close();
	
	return name;
}
catch(Exception e)
{	
	return ""+e;}
}//
*/
//getArrayConditionalAllMultiple..
	public String getArrayConditionAllMultiple(Connection con,String table, String html_name,String str,String condition,String coloumn_id,String coloumn)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select * from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' multiple size=3 style='width:100;font-size:12;'>";
	html_array += "<option value='0' selected>All</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getArrayConditionAll

//Start PAD-04/09/09
	
	public String WIPStatus(Connection con,String table,String html_name,String str,String wip_id){
		
	
			// conp=c.getConnection();
			//System.out.println("str = "+str);
			String html_array="";
			String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 and "+table+"_id in("+wip_id +")";
			int i=0;
			try{
			pstmt_p = con.prepareStatement(query);
			ResultSet rs = pstmt_p.executeQuery();
			while(rs.next()) 		{i++; }
			pstmt_p = con.prepareStatement(query);
			rs = pstmt_p.executeQuery();
			 html_array ="<select name='"+html_name+"' >";
			while(rs.next())
				{
				 String temp1 = rs.getString(table+"_id").trim();		
				 String temp = rs.getString(table+"_name").trim();
				 
				 html_array = html_array +"<option value='"+temp1 +"'"; 
				 if(temp1.equals(str)){ html_array = html_array +" selected ";}
				 html_array = html_array +" > "+temp+" </option> ";
				}
				html_array = html_array +" </select> ";
//				System.out.println(html_array);
				pstmt_p.close();
			}catch(Exception e){
				
				System.out.println("e"+e);
			}
				//c.returnConnection(conp);

				return html_array;
			
			
			
		
			
		}

	public String getCountryArray(Connection con,String table,String html_name,String str){
		
		
		// conp=c.getConnection();
		//System.out.println("str = "+str);
		String html_array="";
		String query ="select "+table+"_id,"+table+"_name from Master_"+table+"   where active=1 ";
		int i=0;
		try{
		pstmt_p = con.prepareStatement(query);
		ResultSet rs = pstmt_p.executeQuery();
		while(rs.next()) 		{i++; }
		pstmt_p = con.prepareStatement(query);
		rs = pstmt_p.executeQuery();
		 html_array ="<select name='"+html_name+"' >";
		while(rs.next())
			{
			 String temp1 = rs.getString(table+"_id").trim();		
			 String temp = rs.getString(table+"_name").trim();
			 
			 html_array = html_array +"<option value='"+temp1 +"'"; 
			 if(temp1.equals(str)){ html_array = html_array +" selected ";}
			 html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
//			System.out.println(html_array);
			pstmt_p.close();
		}catch(Exception e){
			
			System.out.println("e"+e);
		}
			//c.returnConnection(conp);

			return html_array;
		
		
		
	
		
	}
	
	public String getArrayConditionAllMultiple1(Connection con,String table, String html_name,String str,String condition,String coloumn_id,String coloumn)
	{
		try{
				FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
				BufferedReader br = new BufferedReader(f);
				String text=br.readLine();
				if("A H I M S A".equals(text))
					{ 
					br.close();				
		
					}
				else{ 
					br.close();				
					return "<select name=Diajewel ><option ></option></select> ";
					}
             }catch(IOException e )
             { 
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	 //conp=c.getConnection();
	String query ="select * from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' multiple size=3>";
	html_array += "<option value='0' selected>All</option>";
	while(rs.next())
		{
		 String temp1 = rs.getString(coloumn_id).trim();		
		 String temp = rs.getString(coloumn).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
//		System.out.println(html_array);
		pstmt_p.close();
	//	c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
  return ""+e;}
  //finally{c.returnConnection(conp);  }
//End PAD-04/09/09
	}//getArrayConditionAll

	public String getDropDown( Connection con, String  table, String setcolname ,String getcolname , String htmlname ,  String str , String condition)
	{
		
	try{
	
	String query ="select " +getcolname+" ,"+setcolname+"  from "+table +" "+condition ;
	//System.out.println("query is "+query);
	int i=0;

	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+htmlname+"' id='"+htmlname+"'  >";
	while(rs.next())
		{
		 String temp1 = rs.getString(setcolname).trim();		
		 String temp = rs.getString(getcolname).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	

		return html_array;
	}catch(Exception e)
		{
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  

	}

	public String getDropDownChangeEvent( Connection con, String  table, String setcolname ,String getcolname , String htmlname ,  String str , String condition)
	{
		
	try{
	
	String query ="select " +getcolname+" ,"+setcolname+"  from "+table +" "+condition ;
	//System.out.println("query is "+query);
	int i=0;

	pstmt_p = con.prepareStatement(query);
	ResultSet rs = pstmt_p.executeQuery();
	while(rs.next()) 		{i++; }
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+htmlname+"' id='"+htmlname+"' onChange='change()' >";
	while(rs.next())
		{
		 String temp1 = rs.getString(setcolname).trim();		
		 String temp = rs.getString(getcolname).trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//System.out.println(html_array);
		pstmt_p.close();
	

		return html_array;
	}catch(Exception e)
		{
	System.out.println("331 Error in Array.java at Line="+errLine+"is "+e);
  return ""+e;}
  

	}

	public static void main(String[] args) 
	{
	
	
	//System.out.println("Hello World!");
	Array A = new Array();
	try{

	}catch(Exception e){System.out.print("1820 error at "+errLine+"in Array.java is  "+e+" ");}
	
	}
	
	
	
}


