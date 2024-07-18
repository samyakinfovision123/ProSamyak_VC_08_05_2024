package NipponBean;
import java.util.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;

public class str
{

public static void main(String[] args) 
	{
		//System.out.println(toString(args[0],Integer.parseInt(args[1]),args[2],"lac"));
		//System.out.println(toString(args[0],Integer.parseInt(args[1]),args[2],"million"));
		//System.out.println(format(args[0],Integer.parseInt(args[1])));
	}
	
	public static String toString(String f, int no, String amount_type, String type) 
	{										
	if("string".equals(amount_type))
		{
	String array[] = new String[101];
	array[0] = "Zero";		array[1] = "One";		array[2] = "Two";
	array[3] = "Three";		array[4] = "Four";		array[5] = "Five";
	array[6] = "Six";		array[7] = "Seven";		array[8] = "Eight";
	array[9] = "Nine";		array[10] = "Ten";		
	
	array[11] = "Eleven";	array[12] = "Twelve";	array[13] = "Thirteen";	array[14] = "Fourteen";	array[15] = "Fifteen";
	array[16] = "Sixteen";	array[17] = "Seventeen";array[18] = "Eighteen";
	array[19] = "Nineteen";	array[20] = "Twenty";

	array[21] = "Twenty One";	array[22] = "Twenty Two";	array[23] = "Twenty Three";	
	array[24] = "Twenty Four";	array[25] = "Twenty Five";	array[26] = "Twenty Six";	
	array[27] = "Twenty Seven"; array[28] = "Twenty Eight";
	array[29] = "Twenty Nine";	array[30] = "Thirty";

	array[31] = "Thirty One";	array[32] = "Thirty Two";	array[33] = "Thirty Three";	
	array[34] = "Thirty Four";	array[35] = "Thirty Five";	array[36] = "Thirty Six";	
	array[37] = "Thirty Seven"; array[38] = "Thirty Eight";
	array[39] = "Thirty Nine";	array[40] = "Forty";

	array[41] = "Forty One";	array[42] = "Forty Two";	array[43] = "Forty Three";	
	array[44] = "Forty Four";	array[45] = "Forty Five";	array[46] = "Forty Six";	
	array[47] = "Forty Seven"; array[48] = "Forty Eight";
	array[49] = "Forty Nine";	array[50] = "Fifty";

	array[51] = "Fifty One";	array[52] = "Fifty Two";	array[53] = "Fifty Three";	
	array[54] = "Fifty Four";	array[55] = "Fifty Five";	array[56] = "Fifty Six";	
	array[57] = "Fifty Seven";  array[58] = "Fifty Eight";
	array[59] = "Fifty Nine";	array[60] = "Sixty";

	array[61] = "Sixty One";	array[62] = "Sixty Two";	array[63] = "Sixty Three";	
	array[64] = "Sixty Four";	array[65] = "Sixty Five";	array[66] = "Sixty Six";	
	array[67] = "Sixty Seven"; array[68] = "Sixty Eight";
	array[69] = "Sixty Nine";	array[70] = "Seventy";

	array[71] = "Seventy One";	array[72] = "Seventy Two";	array[73] = "Seventy Three";	
	array[74] = "Seventy Four";	array[75] = "Seventy Five";	array[76] = "Seventy Six";	
	array[77] = "Seventy Seven"; array[78] = "Seventy Eight";
	array[79] = "Seventy Nine";	array[80] = "Eighty";

	array[81] = "Eighty One";	array[82] = "Eighty Two";	array[83] = "Eighty Three";	
	array[84] = "Eighty Four";	array[85] = "Eighty Five";	array[86] = "Eighty Six";	
	array[87] = "Eighty Seven"; array[88] = "Eighty Eight";
	array[89] = "Eighty Nine";	array[90] = "Ninety";

	array[91] = "Ninety One";	array[92] = "Ninety Two";	array[93] = "Ninety Three";	
	array[94] = "Ninety Four";	array[95] = "Ninety Five";	array[96] = "Ninety Six";	
	array[97] = "Ninety Seven"; array[98] = "Ninety Eight";
	array[99] = "Ninety Nine";			array[100] = "Hundred";



		String str = ""+f;
		try{
			if(no == 0){ str = ""+Math.round(Double.parseDouble(f)); }
			}catch(Exception e){//System.out.print("e72 " +e) ;
			}
		double temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		String t2 = "";
		//System.out.println(t1);
		if(no >0) { t2 = ""+(String)st.nextElement(); }
		else {t2="";}
		
		
		//System.out.println(" T2 "+t2);

		long number  = Long.parseLong(t1);
			
		int last    = Integer.parseInt(""+(number % 10));
		number = number-last;
		int decimal = Integer.parseInt(""+(number % 100));
		decimal = decimal / 10;

		number = number-decimal;
		int hundred = Integer.parseInt(""+(number % 1000));
		hundred  = hundred /100;

		number = number-hundred;
		int thousand = Integer.parseInt(""+(number % 10000));
		thousand = thousand / 1000;

		number = number-thousand;
		int ten_thousand = Integer.parseInt(""+(number % 100000));
		ten_thousand = ten_thousand / 10000;

		number = number-ten_thousand;
		int lac = Integer.parseInt(""+(number % 1000000));
		lac = lac / 100000;

		number = number-lac;
		int million = Integer.parseInt(""+(number % 10000000));
		million = million /1000000;
			
		number = number-million;
		int crore = Integer.parseInt(""+(number % 100000000));
		crore = crore /10000000;

		number = number-crore;
		int tencrore = Integer.parseInt(""+(number % 1000000000));
		tencrore = tencrore /100000000;


		if(no > 0)
		{
		if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
				if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
		}//if no = 0


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
if("lac".equals(type))
		{
		String temp1 ="";
			if( (tencrore*10 +crore)!= 0)
	{temp1 = temp1 +" "+ array[tencrore*10 + crore]+" Crore ";}
			if(	(million*10 + lac) != 0)
	{temp1 = temp1 +" "+array[million*10 + lac]+" Lac";		}
			if((ten_thousand*10+thousand) != 0)
	{temp1 = temp1 +" "+array[ten_thousand*10+thousand] +" Thousand";}	
			if((hundred) != 0)	
	{temp1 = temp1 +" " +array[hundred] +" Hundred"; }
			if((decimal*10 + last)!=0 )
	{temp1 = temp1 +" "+array[decimal*10 + last];	}
	try{
	temp1 = temp1 +" And "+array[Integer.parseInt(t2)] +" Cents Only";
	}catch (Exception e){}		
		return temp1;
		}
	else{
		String temp1="";
			if((tencrore) != 0 )
		{temp1 = temp1 +array[tencrore]+" Hunderd "; }
			if((crore*10+million) != 0)
		{temp1 = temp1  +array[(crore*10)+million]+" Million ";	}
			if((lac) != 0 )		
		{temp1 =temp1 +array[lac]+" Hundred ";}
			if((ten_thousand*10+thousand)!= 0)
		{temp1 = temp1 + (array[ten_thousand*10+thousand])+" Thousand ";}
			if((hundred) != 0)
		{temp1 = temp1 + array[hundred] +" Hundred "; }
			if((decimal*10 + last) != 0)
		{temp1 = temp1 + array[decimal*10 + last]; }
try{
temp1 = temp1	+" And "+array[Integer.parseInt(t2)]+" Only";	
	}catch (Exception e){}		
		
		return temp1;
		}
//return "American "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last];
//return ""+(tencrore*10 + crore)+""+""+(million) +","+""+(lac)+""+""+(ten_thousand*10+thousand)+","+""+(hundred) +""+""+(decimal*10 + last);	
//return "";
}//if type= string
else { return ""; }
}

public static String format(String  f) 
{
	try{	
		String str = ""+f;
		String sign="";
		if( Float.parseFloat(f) < 0)
		{sign = "-"; 
		str = ""+(Float.parseFloat(f) * (-1));
		}
		
		float temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		//System.out.println(t1);
		String t2 = ""+(String)st.nextElement();
		//System.out.println(t2);
		if(t2.length() > 2)
		{		
			char c[] = t2.toCharArray();
			if(c[2] =='9')
			{

			temp = Float.parseFloat(""+f);
			temp = (float) (temp + 0.001);
			str=""+temp;
			//System.out.println("TEMP "+temp);
			}
			st = new StringTokenizer(str,".");
			t1 = (String)st.nextElement();
			//System.out.println(t1);
			t2 = ""+(String)st.nextElement();
			if(t2.length() > 2)
				{		
				t2= t2.substring(0,2);		
				}
			return t1+"."+t2;
	
		}
		else 
		{	
			if(t2.length() < 2) 	str = ""+f+"0";
			else str =""+f;
		return (sign +str);
		}
	}catch(Exception e){ return f;}
	}



public static double mathformat(double str, int no) 
{
//	System.out.println("251 Inside Numberformat");
	try {
          // get format for default locale
		  DecimalFormat DF =  new DecimalFormat("#.0");;
//		  System.out.println("260");
 if (no == 0 )
 {
 DF =  new DecimalFormat("#############");
 }
else if (no == 1 )
 {
 DF = new DecimalFormat("#############.0");
 }
else if (no == 2 )
 {
 DF = new DecimalFormat("#############.00");
 }
else if (no == 3 )
 {
 DF = new DecimalFormat("#############.000");
 }
else if (no == 4 )
 {
 DF = new DecimalFormat("#############.0000");
 }
		  double d2 = str;

//	  System.out.println("285");
//System.out.println("AAAAAAA"+DF.format(str));
return Double.parseDouble(DF.format(str));
	
	}catch(Exception e)
	{
	System.out.println("inside str.java (282)Samyak Bug is "+e);
	return str;
	}
}


public static String formatNonZero(String f, int no) 
	
//STart New
{

		
		
	try{
	String finalstring="";
	String str = f;
	String sign="";
	double temp_f=mathformat(Double.parseDouble(f),no);
	str=""+temp_f;
		if( temp_f < 0)
		{
			sign = "-"; 
			str = ""+temp_f * (-1.0);
		}
		if(temp_f == 0)
		{
			if(no ==0) {return "&nbsp"; }
			if(no ==1) {return "&nbsp";}
			if(no ==2) {return "&nbsp";}
			if(no ==3) {return "&nbsp";}
		}
//	double temp =Double.parseDouble(f);
	StringTokenizer st = new StringTokenizer(str,".");
	String t1 = (String)st.nextElement();
	
	String t2 = ""+(String)st.nextElement();
		if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
if(no > 0)
	{
		long number = 0;
	if(temp_f > 10000000)
		{
		//System.out.println(" > B ="+temp);
		number  =Math.round(temp_f) ;
		}
	else {
	 number  = Long.parseLong(t1);	
	}
if(number == 0)
	{
	return sign+"0."+t2;
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+"."+t2;
	}
else{
long number =0;
sign="";
if( temp_f < 0){ 
	number  =Math.round((temp_f * (-1)));	
	sign="-";
	} 
else {
		number  =Math.round(temp_f); ;	
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = BB+nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9;

	}	

return finalstring;
}catch(Exception e){ return ""+mathformat(f,no);}
}
//End 

public static String format1(String f, int no) 
{
	//  Old code is Blocked and New Code is added for JDK1.5  //
 /**** New Code For Number Formatting Added By Mukesh ****/	
	try
	{
		
		
		
		String str_pattern=",##0.";
		for(int cnt=0;cnt<no;cnt++)
		{
			str_pattern+="0";
		}
		double db=Double.parseDouble(f);
		db=(db==(-0.0))?0.0:db;
		DecimalFormat number_format=new DecimalFormat();
		number_format.setMaximumFractionDigits(no);
		number_format.setDecimalSeparatorAlwaysShown(true);
		number_format.applyPattern(str_pattern);
		return (""+(number_format.format(db)));
	}//try
	catch(Exception e)
	{
		return "Invalid Arguments To format1() ";
	}
/**** End Of New Code For Number Formatting  ****/		
	
/**** Following code is Old code ****/	
	/*try{
	String finalstring="";
	String str = f;
	String sign="";
	double temp_f=mathformat(Double.parseDouble(f),no);
	str=""+temp_f;
	if( temp_f < 0)
	{
		sign = "-"; 
		str = ""+temp_f * (-1.0);
	}
	if(temp_f == 0)
	{
			if(no ==0) {return "0"; }
			if(no ==1) {return "0.0";}
			if(no ==2) {return "0.00";}
			if(no ==3) {return "0.000";}
	}
//	double temp =Double.parseDouble(f);
	StringTokenizer st = new StringTokenizer(str,".");
	String t1 = (String)st.nextElement();
	
	String t2 = ""+(String)st.nextElement();
	if(t2.length() >= no)
	{		
		t2= t2.substring(0,no);		
	}
	else 
	{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
if(no > 0)
	{
		long number = 0;
	if(temp_f > 10000000)
		{
		//System.out.println(" > B ="+temp);
		number  =Math.round(temp_f) ;
		}
	else {
	 number  = Long.parseLong(t1);	
	}
if(number == 0)
	{
	return sign+"0."+t2;
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+"."+t2;
	}
else{
long number =0;
sign="";
if( temp_f < 0){ 
	number  =Math.round((temp_f * (-1)));	
	sign="-";
	} 
else {
		number  =Math.round(temp_f); ;	
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = BB+nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9;

	}	

return finalstring;
}catch(Exception e){ return ""+mathformat(f,no);}*/
}


public static String mathformat(String str, int no) 
{
//	System.out.println("251 Inside Numberformat");
/**** Old code block Removed and new code block is added By Mukesh ****/ 	
	try
	{
		String str_pattern="##0.";
		for(int cnt=0;cnt<no;cnt++)
		{
			str_pattern+="0";
		}
		double db=Double.parseDouble(str);
		db=(db==(-0.0))?0.0:db;
		DecimalFormat number_format=new DecimalFormat();
		number_format.setMaximumFractionDigits(no);
		number_format.setDecimalSeparatorAlwaysShown(true);
		number_format.applyPattern(str_pattern);
		return (""+(number_format.format(db)));
	}//try
	catch(Exception e)
	{
		return "Invalid Arguments To  mathformat";
	}
	/**** End Of Old code block Removed and new code block is added By Mukesh ****/ 	
	
	/**** Following Code is Old Code  ****/ 
	/*try {
          // get format for default locale
		  DecimalFormat DF =  new DecimalFormat("#.00");;
		 //System.out.println("589");
		 //String s1=str.substring(0,10);
		  //System.out.println("591 s1=>"+s1);
		 // System.out.println("590 str="+str);
		  double d = Double.parseDouble(str);
		   //System.out.println("592");
		   if(d==0)
		{
		return "0.00";
		}
boolean status = false;
if ( d >= 0 &&  d < 1)
{
	status = true;
	//System.out.println("601");
	//System.out.println( "STATUS  + TRUE " + d);
}

//		  System.out.println("260");
 if (no == 0 )
 {
 DF =  new DecimalFormat("#############");
 //System.out.println("609");
 
 }
else if (no == 1 )
 {
 DF = new DecimalFormat("#############.0");
 //System.out.println("615");
 }
else if (no == 2 )
 {
 DF = new DecimalFormat("#############.00");
 //System.out.println("620");
 }
else if (no == 3 )
 {
 DF = new DecimalFormat("#############.000");
//System.out.println("625");
 }
else if (no == 4 )
 {
 DF = new DecimalFormat("#############.0000");
//System.out.println("630");
 }

//	  System.out.println("285");
//System.out.println(DF.format(d));
if(status) { 
	//System.out.println("637");
return "0"+DF.format(d);

}
//System.out.println("640");
return ""+DF.format(d);
	}catch(Exception e)
	{
	System.out.println(" 635 str.java Samyak Bug is "+e);
	return ""+e;
	} */
}










public static String format(String str, int no) 
{
	//System.out.println("251 Inside format "+str);
/**** New Code for Number Formatting is Added By Mukesh ****/	
	try
	{
		String str_pattern=",##0.";
		for(int cnt=0;cnt<no;cnt++)
		{
			str_pattern+="0";
		}
		double db=Double.parseDouble(str);
		db=(db==(-0.0))?0.0:db;
		DecimalFormat number_format=new DecimalFormat();
		number_format.setMaximumFractionDigits(no);
		number_format.setDecimalSeparatorAlwaysShown(true);
		number_format.applyPattern(str_pattern);
		return (""+(number_format.format(db)));
	}//try
	catch(Exception e)
	{
		return "Invalid Arguments To  format";
	}
/**** End Of New Code for Number Formatting ****/	
/**** Following code is Old  Code	 ****/
	/*try {
 
NumberFormat CommaReturn = NumberFormat.getInstance(Locale.UK);

if(Double.parseDouble(str) ==0)
		{
		return "0.00";
		}

if((Double.parseDouble(str)) < 1 && (Double.parseDouble(str)) >=0)
		{
		return mathformat(str,no);
		}

String str1=mathformat(str, no);
String commanumber="0";
String t1="";
String t2="";
String temp="";
if(no>0)
		{
StringTokenizer st = new StringTokenizer(str1,".");
	 t1 = (String)st.nextElement();
//System.out.println("t111111="+t1);

	 t2 = ""+(String)st.nextElement();
//System.out.println("t222222222="+t2);

if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}

//System.out.println("BEFORE 666 < t1 "+t1);
//System.out.println("BEFORE 666 < t2 "+t2);


if(0==(Double.parseDouble(t1)))
		{commanumber="0";}
	else{
commanumber = CommaReturn.format((Double.parseDouble(t1)));
temp=commanumber +"."+ t2;

}
		}
else{commanumber = CommaReturn.format((Double.parseDouble(str1)));
temp=commanumber;

}
//System.out.println("mathformat"+str1);
//System.out.println("Comma Format uk"+commanumber);
//System.out.println("Comma Format ash"+temp);
return temp;



//return ""+DF.format(d);
	}catch(Exception e)
	{
	//System.out.println("Samyak Bug is "+e);
	return mathformat(str,no);
	//return mathformat1(str,no);
//	return str;
	} */
}



public static String format2(String str, int no) 
{
//	System.out.println("251 Inside Numberformat");
	try {
          // get format for default locale
		  DecimalFormat DF =  new DecimalFormat("#.0");;
//		  System.out.println("260");
 if (no == 0 )
 {
 DF =  new DecimalFormat("#############");
 }
else if (no == 1 )
 {
 DF = new DecimalFormat("#############.0");
 }
else if (no == 2 )
 {
 DF = new DecimalFormat("#############.00");
 }
else if (no == 3 )
 {
 DF = new DecimalFormat("#############.000");
 }
else if (no == 4 )
 {
 DF = new DecimalFormat("#############.0000");
 }
		  double d = Double.parseDouble(str);

//	  System.out.println("285");
//System.out.println(DF.format(d));
return ""+DF.format(d);
	}catch(Exception e)
	{
//	System.out.println("Samyak Bug is "+e);
	return ""+e;
	}
}




public static String mathformat1(String f, int no) 
{
	try{
	
	String finalstring="";
	String str = f;
	String sign="";
		if( Float.parseFloat(f) < 0)
		{
			sign = "-"; 
			str = ""+(Float.parseFloat(f) * (-1.0));
		}
		if( Float.parseFloat(f) == 0)
		{
			if(no ==0) {return "0"; }
			if(no ==1) {return "0.0";}
			if(no ==2) {return "0.00";}
			if(no ==3) {return "0.000";}
		}
	double temp =0;
	StringTokenizer st = new StringTokenizer(str,".");
	String t1 = (String)st.nextElement();
	
	String t2 = ""+(String)st.nextElement();
		if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
if(no > 0)
	{
long number  = Long.parseLong(t1);	

if(number == 0)
	{
	return sign+"0."+t2;
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB ="";}
if(number > 1000000 ) {  MM ="";}
if(number > 1000 ) {  HH ="";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+"."+t2;

	}
else{
long number =0;
sign="";
if( Double.parseDouble(f) < 0){ 
	number  = Math.round(Double.parseDouble(f) * (-1)) ;	
	sign="-";
	} 
else {
		number  = Math.round(Double.parseDouble(f) ) ;	
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 =
	""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB ="";}
if(number > 1000000 ) {  MM ="";}
if(number > 1000 ) {  HH ="";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = BB+nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9;

	}	

return finalstring;
}catch(Exception e){ return ""+f;}
}






public static String format(float f) 
{
	try{
		String str = ""+f;
		float temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		//System.out.println(t1);
		String t2 = ""+(String)st.nextElement();
		//System.out.println(t2);
		if(t2.length() > 2)
		{		
			char c[] = t2.toCharArray();
			if(c[2] =='6')
			{

			temp = Float.parseFloat(""+f);
			temp = (float) (temp + 0.001);
			str=""+temp;
			//System.out.println("TEMP "+temp);
			}
			st = new StringTokenizer(str,".");
			t1 = (String)st.nextElement();
			//System.out.println(t1);
			t2 = ""+(String)st.nextElement();
			if(t2.length() > 2)
				{		
				t2= t2.substring(0,2);		
				}
			return t1+"."+t2;
	
		}
		else 
		{	
			if(t2.length() < 2) 	str = ""+f+"0";
			else str =""+f;
		return str;
		}
	}catch(Exception e){ return ""+f;}
	}
	public static String format(double f) 
	{
	try{
		String str = ""+f;
		float temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		//System.out.println(t1);
		String t2 = ""+(String)st.nextElement();
		//System.out.println(t2);
		if(t2.length() > 2)
		{		
			char c[] = t2.toCharArray();
			if(c[2] =='6')
			{

			temp = Float.parseFloat(""+f);
			temp = (float) (temp + 0.001);
			str=""+temp;
			//System.out.println("TEMP "+temp);
			}
			st = new StringTokenizer(str,".");
			t1 = (String)st.nextElement();
			//System.out.println(t1);
			t2 = ""+(String)st.nextElement();
			if(t2.length() > 2)
				{		
				t2= t2.substring(0,2);		
				}
			return t1+"."+t2;
	
		}
		else 
		{	
			if(t2.length() < 2) 	str = ""+f+"0";
			else str =""+f;
		return str;
		}
	}catch(Exception e){ return ""+f;}
}  

	public static String format(double f ,int no) 
	{
	try{
		if(no==2)
		{
		String str = ""+f;
		float temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		//System.out.println(t1);
		String t2 = ""+(String)st.nextElement();
		//System.out.println(t2);
		if(t2.length() > 2)
		{		
			char c[] = t2.toCharArray();
			if(c[2] =='6')
			{

			temp = Float.parseFloat(""+f);
			temp = (float) (temp + 0.001);
			str=""+temp;
			//System.out.println("TEMP "+temp);
			}
			st = new StringTokenizer(str,".");
			t1 = (String)st.nextElement();
			//System.out.println(t1);
			t2 = ""+(String)st.nextElement();
			if(t2.length() > 2)
				{		
				t2= t2.substring(0,2);		
				}
			return t1+"."+t2;
	
		}
		else 
		{	
			if(t2.length() < 2) 	str = ""+f+"0";
			else str =""+f;
		return str;
		}
		}//if n=2
else{
		String str = ""+f;
		float temp =0;
		StringTokenizer st = new StringTokenizer(str,".");
		String t1 = (String)st.nextElement();
		//System.out.println(t1);
		String t2 = ""+(String)st.nextElement();

		//System.out.println(t2);
		if(t2.length() > 3)
		{		
			char c[] = t2.toCharArray();
			if((c[3] =='6')||(c[3] =='7')||(c[3] =='8')||(c[3] =='9'))
			{
		t2=t2.substring(0,3);
		String t3=t1+"."+t2;
			temp = Float.parseFloat(""+t3);
			temp = (float) (temp + 0.001);
			str=""+temp;
			//System.out.println("TEMP "+temp);
			}
			st = new StringTokenizer(str,".");
			t1 = (String)st.nextElement();
			//System.out.println(t1);
			t2 = ""+(String)st.nextElement();
			if(t2.length() > 3)
				{		
				t2= t2.substring(0,3);		
				}
			return t1+"."+t2;
	
		}
		else 
		{	
			if(t2.length() < 3) 	str = ""+f+"0";
			else str =""+f;
		return str;
		}
		}//if n=3




	}catch(Exception e){ return ""+f;}
}  




public static String format1finance(String f, int no) 
	{

		
		
	try{
	String finalstring="";
	String str = f;
	String sign="Dr";
	double temp_f=mathformat(Double.parseDouble(f),no);
	str=""+temp_f;
		if( temp_f < 0)
		{
			sign = "Cr"; 
			str = ""+temp_f * (-1.0);
		}
		if(temp_f == 0)
		{
			if(no ==0) {return "0"; }
			if(no ==1) {return "0.0";}
			if(no ==2) {return "0.00";}
			if(no ==3) {return "0.000";}
		}
//	double temp =Double.parseDouble(f);
	StringTokenizer st = new StringTokenizer(str,".");
	String t1 = (String)st.nextElement();
	
	String t2 = ""+(String)st.nextElement();
		if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
if(no > 0)
	{
		long number = 0;
	if(temp_f > 10000000)
		{
		//System.out.println(" > B ="+temp);
		number  =Math.round(temp_f) ;
		}
	else {
	 number  = Long.parseLong(t1);	
	}
if(number == 0)
	{
	return "0."+t2+sign;
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+"."+t2+sign;
	}
else{
long number =0;
sign="Dr";
if( temp_f < 0){ 
	number  =Math.round((temp_f * (-1)));	
	sign="Cr";
	} 
else {
		number  =Math.round(temp_f); ;	
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(number > 1000000000 ) {  BB =",";}
if(number > 1000000 ) {  MM =",";}
if(number > 1000 ) {  HH =",";}

if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = BB+nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+sign;

	}	

return finalstring;
}catch(Exception e){ return ""+mathformat(f,no);}
}

public static String Samyakformat(String f, int no, String symbol_for_zero, int symbol_Dr_Cr,int comma) 
{
/**** New Code Block  is Added By Mukesh					****/	

/*		Parameters for samyakformat() methods				   */
/*		String  f				= Number to be formated.       */
/*		int     no				= Number Of Decimal places.    */
/*		String  symbol_for_zero = Symbol To Be Replace For Zero*/

/*		int		symbol_Dr_Cr= For Dr  Cr Values after value.   */
/*			(if 1= Dr Cr is append	   )
/*			(if 0= Dr Cr is not append )

/*		int		comma			= For Display In Comma Format  */
/*			(if 1= Display In  Comma Format	   )
/*			(if 0= Display Without Comma Format )

/***************************** *********   *********  **********/	
	try
	{
	String finalstring="";
	String str = f;
	String sign="";
	String drcr_symbol="";
	double temp_f=mathformat(Double.parseDouble(f),no);
	str=""+temp_f;
		
	if(temp_f!=0)	
	{
			if( temp_f < 0)
			{
				if(symbol_Dr_Cr==0)
				{
					sign = "-"; 
					str = ""+temp_f * (-1.0);
				}
				else
				{
					str = ""+temp_f * (-1.0);	
					drcr_symbol=" Cr";				
				}
				
			}
			else
			{
				if(symbol_Dr_Cr==0)
				{
					sign="";
					str = ""+temp_f ;
				}
				else
				{
					str = ""+temp_f ;	
					drcr_symbol=" Dr";	
				}
			}
	} //if(temp_f!=0)
		
	if(temp_f == 0)
	{
		if("0".equals(symbol_for_zero))
		{
			if(no ==0) {return "0"; }
			if(no ==1) {return "0.0";}
			if(no ==2) {return "0.00";}
			if(no ==3) {return "0.000";}
		
		} //if("0".equals(symbol_for_zero))
		if("-".equals(symbol_for_zero))
		{
			return "-";
		}
		if("".equals(symbol_for_zero))
		{
			return "&nbsp;";
		}
	} //if(temp_f == 0)

	
	String str_pattern="";
	str_pattern=comma==1?",##0.":"##0.";
	
	for(int cnt=0;cnt<no;cnt++)
	{
			str_pattern+="0";
	}
	double db=Double.parseDouble(str);
	DecimalFormat number_format=new DecimalFormat();
	number_format.setMaximumFractionDigits(no);
	number_format.setDecimalSeparatorAlwaysShown(true);
	number_format.applyPattern(str_pattern);
	String final_string=sign+(number_format.format(db))+drcr_symbol;
	return final_string;
	} //try
	catch(Exception e)
	{
		return "Invalid Arguments To SamyakFormat()";
	}
	
	/**** End Of New Code Block ****/
	/**** Following Old Code is Blocked ****/ 	
	/*StringTokenizer st = new StringTokenizer(str,".");
	String t1 = (String)st.nextElement();
	
	String t2 = (String)st.nextElement();
		if(t2.length() >= no)
			{		
			t2= t2.substring(0,no);		
			}
		else 
			{	
				if(no == 1 ) {	t2 = t2+""; }
				if(no == 2)  	{	
						if(t2.length() == 1) { t2 = t2+"0"; }
					}			
				if(no == 3) 
						{	
						if(t2.length() == 1) { t2 = t2+"00"; }
						if(t2.length() == 2) { t2 = t2+"0"; }

					}			
				if(no == 4) 
					{	
						if(t2.length() == 1) { t2 = t2+"000"; }
						if(t2.length() == 2) { t2 = t2+"00"; }
						if(t2.length() == 3) { t2 = t2+"0"; }
					}			
			}
if(no > 0)
	{
		long number = 0;
	if(temp_f > 10000000)
		{
		//System.out.println(" > B ="+temp);
		number  =Math.round(temp_f) ;
		}
	else {
	 number  = Long.parseLong(t1);	
	}
if(number == 0)
	{
	return sign+"0."+t2;
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(comma == 1)
{
	if(number > 1000000000 ) {  BB =",";}
	if(number > 1000000 ) {  MM =",";}
	if(number > 1000 ) {  HH =",";}
}
if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9+"."+t2;
	}
else{
long number =0;
sign="";
if( temp_f < 0){ 
	number  =Math.round((temp_f * (-1)));	
	sign="-";
	} 
else {
		number  =Math.round(temp_f); ;	
	}

int last    = Integer.parseInt(""+(number % 10));
number = number-last;
int decimal = Integer.parseInt(""+(number % 100));
decimal = decimal / 10;

number = number-decimal;
int hundred = Integer.parseInt(""+(number % 1000));
hundred  = hundred /100;

number = number-hundred;
int thousand = Integer.parseInt(""+(number % 10000));
thousand = thousand / 1000;

number = number-thousand;
int ten_thousand = Integer.parseInt(""+(number % 100000));
ten_thousand = ten_thousand / 10000;

number = number-ten_thousand;
int lac = Integer.parseInt(""+(number % 1000000));
lac = lac / 100000;

number = number-lac;
int million = Integer.parseInt(""+(number % 10000000));
million = million /1000000;
	
number = number-million;
int crore = Integer.parseInt(""+(number % 100000000));
crore = crore /10000000;
//System.out.println(" crore 0 "+crore);

number = number-crore;
int tencrore = Integer.parseInt(""+(number % 1000000000));
tencrore = tencrore /100000000;
//System.out.println(" tencrore 0 "+tencrore);

number = number-tencrore;
//System.out.println(" number 1 "+number);
long hundredcrore = Long.parseLong(""+(number % Long.parseLong("10000000000")));
hundredcrore = hundredcrore /Long.parseLong("1000000000");
//System.out.println(" hundredcrore 1 "+hundredcrore);

number = number-hundredcrore;
long billion = Long.parseLong(""+(number % Long.parseLong("100000000000")));
billion = billion /Long.parseLong("10000000000");
//System.out.println(" billion 2 "+billion);

number = number-billion;
long billion10 = Long.parseLong(""+(number % Long.parseLong("1000000000000")));
billion10 = billion10 /Long.parseLong("100000000000");
//System.out.println(" billion10 "+billion10);


//System.out.println( " "+array[tencrore*10 + crore]+" Crore "+""+array[ million] +" Million"+","+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" Thousand"+","+array[hundred] +" Hundred"+" "+array[decimal*10 + last]);
//return " "+array[tencrore*10 + crore]+" "+" "+array[ million] +", "+" "+array[lac]+" Lac"+" "+array[ten_thousand*10+thousand]+" ,"+" "+array[hundred] +" Hundred"+" "+array[decimal*10 + last];	
String temp000 = ""; //billion10
String temp00 = "";
String temp0 = "";
String temp1 = "";
String temp2 = "";
String temp3 = "";
String temp4 = "";
String temp5 = "";
String temp6 = "";
String temp7 = "";
String temp8 = "";
String temp9 = "";
String nozero="";
String BB ="";
String MM ="";
String HH ="";
if(comma == 1)
{
	if(number > 1000000000 ) {  BB =",";}
	if(number > 1000000 ) {  MM =",";}
	if(number > 1000 ) {  HH =",";}
}
if(billion10 != 0) 	{temp000 = ""+(billion10); nozero="0";}	
else { temp000 = nozero;}

if(billion != 0) 	{temp00 = ""+(billion); nozero="0";}	
else { temp00 = nozero;}

//System.out.println(" temp 00 "+temp00);
if(hundredcrore != 0) 	{temp0 = ""+(hundredcrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp0 = nozero;}
if(tencrore != 0) 	{temp1 = BB+(tencrore); nozero="0";}	//System.out.println(" temp 1 "+temp1);
else { temp1 = BB+nozero;}
if(crore != 0) 	{temp2 = ""+(crore);  nozero="0"; }		
else { temp2 = nozero;}
if(million != 0) 	{temp3 = (million)+"";  nozero="0"; }	 
else { temp3 = ""+nozero;}
if( lac != 0)		{temp4 = MM+(lac);  nozero="0"; }		 
else { temp4 = MM+nozero;}
if(ten_thousand != 0){temp5 = ""+(ten_thousand);  nozero="0"; } 
else { temp5 = nozero;}
if(thousand!=0) 		{temp6 = ""+(thousand)+"";  nozero="0"; }	 
else { temp6 = nozero;}
if(hundred != 0)		{temp7 = HH+(hundred);  nozero="0";}	 
else { temp7 = HH+nozero;}
if(decimal != 0)		{temp8 = ""+(decimal);  nozero="0"; }	 
else { temp8 = nozero;}
if(last != 0)		{temp9 = ""+(last);   nozero="0";}			 
else { temp9 = nozero;}
finalstring= sign+temp000+temp00+temp0+temp1+temp2+temp3+temp4+temp5+temp6+temp7+temp8+temp9;
}

if(temp_f < 0 && flagdrcr==true)
{
 finalstring=finalstring+"Cr";
}
if(temp_f > 0 && flagdrcr==true)
{
 finalstring=finalstring+"Dr";
}	


return finalstring;
}
catch(Exception e)
{ 
	return ""+mathformat(f,no);
} */
}

//New method added 
public static String format3(String str, int no) 
{
//	System.out.println("251 Inside Numberformat");
	try {
          // get format for default locale
		  DecimalFormat DF =  new DecimalFormat("#.0");;
//		  System.out.println("260");
 if (no == 0 )
 {
 DF =  new DecimalFormat("###########,##0");
 }
else if (no == 1 )
 {
 DF = new DecimalFormat("###########,##0.0");
 }
else if (no == 2 )
 {
 DF = new DecimalFormat("###########,##0.00");
 }
else if (no == 3 )
 {
 DF = new DecimalFormat("###########,##0.000");
 }
else if (no == 4 )
 {
 DF = new DecimalFormat("###########,##0.0000");
 }
		  Double d = Double.parseDouble(str);

	  System.out.println(d);
System.out.println(DF.format(d));
return ""+DF.format(d);
	}catch(Exception e)
	{
//	System.out.println("Samyak Bug is "+e);
	return ""+e;
	}
}





}

