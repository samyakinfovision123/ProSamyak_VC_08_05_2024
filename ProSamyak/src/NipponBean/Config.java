package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;
public class  Config
{
    
    

    public static String getFilePath() throws Exception
	{		
		String line = "";
        String  path=""; 
		FileReader fr;
        int length=0;
		  try
		  {
	
			fr = new FileReader("C:\\SamyakSoft\\Tomcat5.0\\webapps\\ROOT\\WEB-INF\\classes\\NipponBean\\Config.txt"); 
			
			BufferedReader br= new BufferedReader(fr);


		   	
		    while((line=br.readLine())!=null)
		    {
		
				line = line.trim();
        
                length = line.length();
				
                String tocompare = line.substring(0,5);
		
				if(tocompare.equals("path="))
                {
				    path = line.substring(6,(length-1)); 	
                   
                }   
			}
	
    
			fr.close();
		    	
		    		      		     
		  }catch(IOException e){System.out.println(e);}		

		  return(path);
        

	}
	
//------------

    public static String getBarcodeStatus() throws Exception
	{		
		String line="";
        String  barcode=""; 
		FileReader fr;
        int length=0;
		  try
		  {
	
			fr = new FileReader("C:\\SamyakSoft\\Tomcat5.0\\webapps\\ROOT\\WEB-INF\\classes\\NipponBean\\Config.txt"); 
			
			BufferedReader br= new BufferedReader(fr);


		   	
		    while((line=br.readLine())!=null)
		    {
		
				line = line.trim();
        
                length = line.length();
				
                String tocompare = line.substring(0,8);
		
				if(tocompare.equals("barcode="))
                {
				    barcode = line.substring(9,(length-1)); 	
                }   
			}
	
    
			fr.close();
		    	
		    		      		     
		  }catch(IOException e){System.out.println(e);}		

		  return(barcode);
        

	}//getBarcodeStaus
	


//-------------

	public Config()
	{
	}


	
	public static String financialYear()
		{
String inital="31/03/2004";
String last="31/03/2005";
String final_year=inital+"#"+last;
return final_year;
		}
	

	public static java.sql.Date financialYearStart()
		{
String inital="31/03/2004";
//String final_year=inital;
java.sql.Date final_year = new java.sql.Date((104),(03),01);

return final_year;
		}

	public static java.sql.Date financialYearEnd()
		{

String last="31/03/2005";
//String final_year=last;
java.sql.Date final_year = new java.sql.Date((105),(02),31);

return final_year;
		}


public static String getRoot()
{
return "C";
}//
/*
public static void main(String args[])
{
String path = getFilePath();
	System.out.println("path ="+path+":");
}
*/
}

