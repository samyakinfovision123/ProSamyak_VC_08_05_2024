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
public class ArrayCSS 
{
	String errLine="8";
	private	Connection conp		= null;
	private	PreparedStatement pstmt_p=null;
	ResultSet rs= null;
//	Connect1 c;
 	public ArrayCSS()
	{
	/*try{
		c=new Connect1();

		}catch(Exception e15){ System.out.print("Error in Connection"+e15);}*/
	}
	
	


	
	public String getMasterArrayCondition(Connection con, String table, String html_name,String str,String condition)
	{
		try{
				errLine="28";
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
				System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
	 //conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+"";
//	System.out.println("query is "+query);
	int i=0;
	
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
	while(rs.next())
	{
		 String temp1 = rs.getString(table+"_id").trim();		
		 String temp = rs.getString(table+"_name").trim();
		 
		 html_array = html_array +"<option value='"+temp1 +"'"; 
		 if(temp1.equals(str)){ html_array = html_array +" selected ";}
		 html_array = html_array +" > "+temp+" </option> ";
		}
		html_array = html_array +" </select> ";
		//  System.out.println(html_array);
		pstmt_p.close();
		//	c.returnConnection(conp);

		return html_array;
	}
    catch(Exception e)
	{//c.returnConnection(conp);
	    System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
	    return ""+e;
    }
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive
    
    public String getMasterArrayConditionOther(Connection con, String table, String html_name,String str,String condition)
    {
        try{
                errLine="28";
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
                System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
                return "<select name=Diajewel ><option ></option></select> ";
             }
    
    try{
     //conp=c.getConnection();
    String query ="select "+table+"_id,"+table+"_name_JP from Master_"+table+" "+condition+"";
//  System.out.println("query is "+query);
    int i=0;
    
    pstmt_p = con.prepareStatement(query);
    rs = pstmt_p.executeQuery();
    String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
    while(rs.next())
    {
         String temp1 = rs.getString(table+"_id").trim();       
         String temp = rs.getString(table+"_name_JP").trim();
         
         html_array = html_array +"<option value='"+temp1 +"'"; 
         if(temp1.equals(str)){ html_array = html_array +" selected ";}
         html_array = html_array +" > "+temp+" </option> ";
        }
        html_array = html_array +" </select> ";
        //  System.out.println(html_array);
        pstmt_p.close();
        //  c.returnConnection(conp);

        return html_array;
    }
    catch(Exception e)
    {//c.returnConnection(conp);
        System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
        return ""+e;
    }
  //finally{c.returnConnection(conp);  }

    }//getMasterArrayNoActive
    


	//start:Method for Other Language
    public String getMasterArrayConditionOther(Connection con,String table, String html_name,String str,String condition, String Company_id)
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
             }catch(IOException e )
             { 
                return "<select name=Diajewel ><option ></option></select> ";
             }
    
    try{
    // conp=c.getConnection();
    String query ="select "+table+"_id,"+table+"_name_JP from Master_"+table+" "+condition+" and Company_id="+Company_id+" and Active=1 order by "+table+"_name";
//  System.out.println("query is "+query);
    int i=0;
    
    pstmt_p = con.prepareStatement(query);
    rs = pstmt_p.executeQuery();
    String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
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
  return ""+e;}
  //finally{c.returnConnection(conp);  }

    }//getMasterArrayNoActive


    //end:Method for Other Language
    
    
    
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
				System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select Account_id,Account_name from Master_Account where AccountType_Id=6 and Company_Id="+company_id+" and Active=1";
//	System.out.println("query is "+query);
	int i=0;
	errLine="103";
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'> ";
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
	System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
 return ""+e;}
 //finally{c.returnConnection(conp);  }

	}//getCashAccounts

////getArray

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
				System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
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
	rs = pstmt_p.executeQuery();
	errLine="200";
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
System.out.println("Error in ArrayCSS.java at Line="+errLine+"is "+e);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//








//end of getArray




	
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
				return "<select name=Diajewel ><option ></option></select> ";
             }
	
	try{
  	// conp=c.getConnection();
	String query ="select "+table+"_id,"+table+"_name from Master_"+table+" "+condition+" and Company_id="+Company_id+" and Active=1 order by "+table+"_name";
	System.out.println("query is "+query);
	int i=0;
	
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
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
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getMasterArrayNoActive



	public String getArrayConditionAll(Connection con,String table, String html_name,String str,String condition,String coloumn_id,String coloumn)
	{
		try{
				errLine="292";
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
	String query ="select "+coloumn_id+","+coloumn+" from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
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
		pstmt_p.close();
	//	c.returnConnection(conp);
		return html_array;
	}catch(Exception e)
		{	//c.returnConnection(conp);
  return ""+e;}
  //finally{c.returnConnection(conp);  }

	}//getArrayConditionAll


		public String getArrayCondition(Connection con,String table, String html_name,String str,String condition,String coloumn_id,String coloumn)
	{
		try{
				errLine="292";
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
	String query ="select "+coloumn_id+","+coloumn+" from "+table+" "+condition+"  order by "+coloumn+"";
//	System.out.println("query is "+query);
	int i=0;
	
	pstmt_p = con.prepareStatement(query);
	rs = pstmt_p.executeQuery();
	String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
	//html_array += "<option value='0'>All</option>";
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

	}//getArrayCondition
		
		public String getMasterArrayConditionNew(Connection con,String table, String html_name,String value,String str,String condition)
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
		String query ="select "+value+","+table+"_name from Master_"+table+" "+condition+" and Active=1 order by "+table+"_name";
		System.out.println("query is "+query);
		int i=0;
		
		pstmt_p = con.prepareStatement(query);
		rs = pstmt_p.executeQuery();
		String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
		while(rs.next())
			{
			 String temp1 = rs.getString(value).trim();		
			 String temp = rs.getString(table+"_name").trim();
			 
			 html_array = html_array +"<option value='"+temp1 +"'"; 
			 if(temp1.equals(str)){ html_array = html_array +" selected ";}
			 html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
//			System.out.println(html_array);
			pstmt_p.close();
			//c.returnConnection(conp);
			return html_array;
		}catch(Exception e)
			{	//c.returnConnection(conp);
	  return ""+e;}
	  //finally{c.returnConnection(conp);  }

		}//getMasterArrayConditionNew ASS 21-12-2010

		public String getMasterArrayConditionNew1(Connection con,String table, String html_name,String value,String str,String condition)
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
		String query ="select "+value+","+table+"Name from Master_"+table+" "+condition+" order by "+table+"Id";
		System.out.println("query is "+query);
		int i=0;
		
		pstmt_p = con.prepareStatement(query);
		rs = pstmt_p.executeQuery();
		String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
		while(rs.next())
			{
			 String temp1 = rs.getString(value).trim();		
			 String temp = rs.getString(table+"Name").trim();
			 
			 html_array = html_array +"<option value='"+temp1 +"'"; 
			 if(temp1.equals(str)){ html_array = html_array +" selected ";}
			 html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
//			System.out.println(html_array);
			pstmt_p.close();
			//c.returnConnection(conp);
			return html_array;
		}catch(Exception e)
			{	//c.returnConnection(conp);
	  return ""+e;}
	  //finally{c.returnConnection(conp);  }

		}//getMasterArrayConditionNew ASS 21-12-2010
		public String getMasterArrayConditionOptionValue(Connection con,String table, String html_name,String value,String str,String condition) //Prashant-21-02-2011
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
		String query ="select "+value+","+table+"Name from Master_"+table+" "+condition+" order by "+table+"Id";
		System.out.println("query is "+query);
		int i=0;
		
		pstmt_p = con.prepareStatement(query);
		rs = pstmt_p.executeQuery();
		String html_array ="<select name='"+html_name+"' style='width:100;font-size:12;'>";
		html_array=html_array+"<option value='0'>ALL</option>";
		while(rs.next())
			{
			 String temp1 = rs.getString(value).trim();		
			 String temp = rs.getString(table+"Name").trim();
			 
			 html_array = html_array +"<option value='"+temp1 +"'"; 
			 if(temp1.equals(str)){ html_array = html_array +" selected ";}
			 html_array = html_array +" > "+temp+" </option> ";
			}
			html_array = html_array +" </select> ";
//			System.out.println(html_array);
			pstmt_p.close();
			//c.returnConnection(conp);
			return html_array;
		}catch(Exception e)
			{	//c.returnConnection(conp);
	  return ""+e;}
	  //finally{c.returnConnection(conp);  }

		}//getMasterArrayConditionNew ASS 21-12-2010
public static void main(String[] args) 
	{
	
	
	//System.out.println("Hello World!");
	ArrayCSS A = new ArrayCSS();
	try{

	}catch(Exception e){System.out.print(e);}
	
	}



}


