package NipponBean;
import java.util.*;
import java.sql.*;
import java.io.*;

public class rapSearch
{
	//(1)add entry here to declare an ArrayList Collection for a new 'Shape'.CSV file//
	static List emeraldList = new ArrayList();
	static List pearList = new ArrayList();
	static List marquiseList = new ArrayList();
	static List roundList = new ArrayList();
	
	//(2)call this method to read files and load entries into ArrayList Collectin//
	public static void loadRapaportCollection()
	{
		//(3)add entry here to Add a new 'Shape'.CSV file//
		addToList("PEARS",pearList);
		addToList("MARQUIS",marquiseList);
		addToList("EMERLD",emeraldList);
		addToList("ROUND",roundList);

	}
	  	 
	public static void addToList(String shapeName,List xList)
	  {    
		  String text="";
		  FileReader f = null;
		try{
				f = new FileReader("C:\\SamyakSoft\\Tomcat5.0\\webapps\\ROOT\\Samyak\\Nippon\\Samyak\\Rapnet\\"+shapeName+".CSV");
				BufferedReader br = new BufferedReader(f);
								
			 while((text=br.readLine()) != null)
			    {
			    int firstComma= text.indexOf(",");
				int secondComma = text.indexOf(",",firstComma+1);
				int thirdComma = text.indexOf(",",secondComma+1);
				int fourthComma = text.indexOf(",",thirdComma+1);
				int fifthComma = text.indexOf(",",fourthComma+1);
				int sixthComma = text.indexOf(",",fifthComma+1);
				String addClarity= text.substring(firstComma+1,secondComma);
				String addColor= text.substring(secondComma+1,thirdComma);
				double addSizeFrom= Double.parseDouble(text.substring(thirdComma+1,fourthComma));
				double addSizeTo= Double.parseDouble(text.substring(fourthComma+1,fifthComma));
				int addRate= Integer.parseInt(text.substring(fifthComma+1,sixthComma));
				
				//Add parsed string to Arraylist
				xList.add(new objStructure(addClarity,addColor,addSizeFrom,addSizeTo,addRate));
                }
           }catch(IOException ioe )
              { System.out.println("Samyak Bean Bug 78 rapSearch: "+ioe);
               }catch(Exception e){
			    }finally{
							try{
							f.close();
								}catch(IOException e)
								   {System.out.println("Samyak Bean Bug 90  rapSearch: "+e); 
									}
						}
	  } //end of 'void addToList()'//

	
	//(4)call this method with shape name, clarity, color, size - to search for Rate//
	public static int searchRate(String searchListStr,String searchClarity,String searchColor,double searchSize)
	   {
		List searchList;
		try
		{

			//System.out.println("SearchListStr = " +searchListStr);
				

				//(5)add clause here to assign searchList with the 'ShapeName' // see (1) and (3)
				if(searchListStr.equals("EMERLD"))
					{searchList = emeraldList;
					}
				else
				    {if(searchListStr.equals("PEARS"))
						{searchList = pearList;
		                 //System.out.println("SearchList = Pear");
						}
					 else
						{if(searchListStr.equals("MARQUIS"))
						 	{ 
						 searchList = marquiseList;
						 //System.out.println("SearchList = Marquise");
						    }
							else
								{if(searchListStr.equals("ROUND"))
									{searchList = roundList;
									}
									else
									{
										throw new Exception("Incorrect Parameter - Shape Name");
									}
					
								}
				      	}					
					}
//-------------------------------------------------------------------------

				//System.out.println("Samyak Bean Bug 130  rapSearch: " );

		List filteredClarityList= filterClarity(searchList,searchClarity);
				//display(filteredClarityList);

				System.out.println("Samyak Bean Bug 135  rapSearch: " );

				List filteredColorList= filterColor(filteredClarityList,searchColor);
				//display(filteredColorList);

				System.out.println("Samyak Bean Bug 140  rapSearch: ");

				List filteredSize = filterSize(filteredColorList,searchSize);
				
				System.out.println("Samyak Bean Bug 144  rapSearch: ");

				if(filteredSize.size()>0)
				{
					System.out.println("Samyak Bean Bug 148  rapSearch: ");

					objStructure objStr = (objStructure)filteredSize.get(0); 
					return objStr.getRate();
				}
				else
				{
					System.out.println("More than one record found in search");
				}

			}
			catch(Exception e)
			{
				System.out.println("Samyak Bean Bug 133  rapSearch: " + e);
			}
			return -1;
		}

   static List filterClarity(List list, String filter_clarity)
	    {
    		//System.out.println("FilterClarity fn: 139");
    		//System.out.println("Filter_Clarity:"+filter_clarity);
		    ComparingClarity comp = new ComparingClarity();
			Collections.sort(list,comp);
			int listSize = list.size();
			//System.out.println("\n List Size in filterClarity fn:= "+listSize+"\n");
			
			int i =0;
			int startIndex=-1,endIndex=-1;
			boolean firstFound=false,secondFound=false;

    		 //System.out.println("FilterClarity fn: 142");

			while(listSize>0)
			{
				objStructure objStr = (objStructure)list.get(i); 

				if(filter_clarity.equals(objStr.getClarity()))
				 {
					if(firstFound==false)
						{ startIndex=i;
						  firstFound=true; 	
						}
					endIndex=i;					
				 }
				
				listSize--;
				i++;
			}
			 //System.out.println("FilterClarity fn: 200");
    		 //System.out.println("FilterClarity fn: startIndex= " + startIndex +" ,endIndex= " + endIndex);
			 List subFilteredClarityList=list.subList(0,0);
			
			if(firstFound)
			{
				subFilteredClarityList = list.subList(startIndex,endIndex+1);
			    		// System.out.println("FilterClarity fn: 203");
						 
			}
			return subFilteredClarityList;
		}
 


  static  List filterColor(List list, String filter_color)
	    {
		    ComparingColor comp = new ComparingColor();
			Collections.sort(list,comp);
			int listSize = list.size();
			//System.out.println("\nColor List Size =  "+listSize+"\n");
			
			int i =0;
			int startIndex=-1,endIndex=-1;
			boolean firstFound=false,secondFound=false;

			while(listSize>0)
			{
				objStructure objStr = (objStructure)list.get(i); 

				if(filter_color.equals(objStr.getColor()))
				 {
					if(firstFound==false)
						{ startIndex=i;
						  firstFound=true; 	
						}
					endIndex=i;					
				 }
				
				listSize--;
				i++;
			}
			List subFilteredColorList=list.subList(0,0);
			if(firstFound)
			{
			 subFilteredColorList = list.subList(startIndex,endIndex+1);
			}
			return subFilteredColorList;
		}
static	List filterSize(List list, Double filter_size)
	    {
			int listSize = list.size();
			int i =0;
			int startIndex=-1,endIndex=-1;
			boolean firstFound=false,secondFound=false;

			while(listSize>0)
			{
				objStructure objStr = (objStructure)list.get(i); 

			    if(filter_size>=objStr.getSizeFrom() && filter_size<=objStr.getSizeTo())
				 {
					
						if(firstFound==false)
						{ startIndex=i;
						  firstFound=true; 	
						}
					endIndex=i;					
				 }
				
				listSize--;
				i++;
			}	
			List subFilteredSizeList = list.subList(0,0);
			if(firstFound)
			{
				subFilteredSizeList = list.subList(startIndex,endIndex+1);
			}
			return subFilteredSizeList;
		}

static	void display(List list)
	   { 
		    Iterator itr = list.iterator();
			int i=1;
			while(itr.hasNext())
			{	Object element = itr.next();
				//System.out.println(i+" " + element + "\n");
				i++;
			}
			//System.out.println();
        }

}//end of class rapSearch//


class ComparingClarity implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   String str1 = ((objStructure)obj1).getClarity();
	   String str2 = ((objStructure)obj2).getClarity();
	   return ((str1).compareTo(str2));	 
	}	
}

class ComparingColor implements Comparator
{
   public int compare(Object obj1,Object obj2)
	{
	   String str1 = ((objStructure)obj1).getColor();
	   String str2 = ((objStructure)obj2).getColor();
	   return ((str1).compareTo(str2));
		 
	}	
}

//(6)this class defines the object Structure of the object stored in ArrayList()
class objStructure
{
	String clarity;
	String color;
	double size_from;
	double size_to;
	int rate;
    
    public String getClarity()
	{ return this.clarity;
	}
    public String getColor()
	{ return this.color;
	}
    public Double getSizeFrom()
	{ return this.size_from;
	}
    public Double getSizeTo()
	{ return this.size_to;
	}
    public int getRate()
	{ return this.rate;
	}

	objStructure(String clarity,String color,double size_from,double size_to,int rate)
    {
		this.clarity=clarity;
		this.color=color;
		this.size_from=size_from;
		this.size_to=size_to;
		this.rate=rate;
	}
	public String toString()
	{
		return clarity + " " + color + " " + size_from + " " + size_to + " " + rate;
	}
}
