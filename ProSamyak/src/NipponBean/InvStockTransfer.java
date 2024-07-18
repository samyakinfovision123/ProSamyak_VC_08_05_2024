package NipponBean;
import java.util.*;
import java.io.*;
import java.sql.*;
import NipponBean.*;


public class InvStockTransfer
{

		double source_qty_total =0;
		double dest_qty_total=0 ;
		double source_local_total =0;
		double dest_local_total =0;
		double source_dollar_total =0;
		double dest_dollar_total =0;
		String result="";
		String errLine="";
public String getStockTransferTotal(Connection cong,int dd1,int mm1,int yy1,int dd2,int mm2,int yy2,String sourceLocation_id,String destinationLocation_id,String company_id)
{

//System.out.println("sourceLocation_id="+sourceLocation_id);
//System.out.println("destinationLocation_id="+destinationLocation_id);
String quantity_total="";
String local_amt_total="";
String dollar_amt_total="";
//Array A=new Array();
try
 {
	
	ResultSet rs_g= null;


	PreparedStatement pstmt_g=null;

	java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);

	java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
	
	if(sourceLocation_id.equals("0"))
	{
	   String  query="select Sum(RT.Quantity) as quantity_total,Sum(Rt.Quantity*RT.Local_Price) as local_amt_total,Sum(Rt.Quantity*RT.Dollar_Price) as dollar_amt_total from Receive R, Receive_Transaction RT where R.REceive_Id=RT.Receive_Id and  R.Receive_FromId="+company_id+" and R.Purchase=1 and R.Receive_Date between ? and ? and R.Receive_Sell=1 and R.Active=1 and RT.Active=1 and R.company_id="+company_id+" and RT.Location_Id="+destinationLocation_id;
	   pstmt_g = cong.prepareStatement(query);
	   pstmt_g.setString(1,""+D1);
	   pstmt_g.setString(2,""+D2);	
	   rs_g = pstmt_g.executeQuery();	
	   while(rs_g.next())
		{
			quantity_total=rs_g.getString("quantity_total");
			if(rs_g.wasNull()){quantity_total="0";}
			
			local_amt_total=rs_g.getString("local_amt_total");
			if(rs_g.wasNull()){local_amt_total="0";}
			
			dollar_amt_total=rs_g.getString("dollar_amt_total");
			if(rs_g.wasNull()){dollar_amt_total="0";}
		
		} //while
	
	} //if(sourceLocation_id.equals("0"))

	if(destinationLocation_id.equals("0"))
	{
	   String  query="select Sum(RT.Quantity) as quantity_total,Sum(Rt.Quantity*RT.Local_Price) as local_amt_total,Sum(Rt.Quantity*RT.Dollar_Price) as dollar_amt_total from Receive R, Receive_Transaction RT where R.REceive_Id=RT.Receive_Id and  R.Receive_FromId="+company_id+" and R.Purchase=1 and R.Receive_Date between ? and ? and R.Receive_Sell=0 and R.Active=1 and RT.Active=1 and R.company_id="+company_id+" and RT.Location_Id="+sourceLocation_id;
	   pstmt_g = cong.prepareStatement(query);
	   pstmt_g.setString(1,""+D1);
	   pstmt_g.setString(2,""+D2);	
	   rs_g = pstmt_g.executeQuery();	
	   while(rs_g.next())
		{
			quantity_total=rs_g.getString("quantity_total");
			if(rs_g.wasNull()){quantity_total="0";}
	
			local_amt_total=rs_g.getString("local_amt_total");
			if(rs_g.wasNull()){local_amt_total="0";}
			
			dollar_amt_total=rs_g.getString("dollar_amt_total");
			if(rs_g.wasNull()){dollar_amt_total="0";}
			
		} //while
	
	} //if(destinationLocation_id.equals("0"))

     result=""+quantity_total+"#"+local_amt_total+"#"+dollar_amt_total;
 } 	//try
/* try{
ResultSet rs_g= null;
ResultSet rs_p= null;

PreparedStatement pstmt_g=null;
PreparedStatement pstmt_p=null;


errLine="109";

java.sql.Date D1 = new java.sql.Date((yy1-1900),(mm1-1),dd1);
//out.print("<br>D1=" +D1);

java.sql.Date D2 = new java.sql.Date((yy2-1900),(mm2-1),dd2);
//out.print("<br>D2=" +D2);
String party_id= 
	"";//request.getParameter("party_id");
String sourceLocationName="";
String destinationLocationName="";
//String sourceLocation_id= request.getParameter("sourceLocation_id");
//out.print("<br>124sourceLocation_id"+sourceLocation_id);
if("0".equals(sourceLocation_id)){
sourceLocationName="ALL";}
else{
sourceLocationName=A.getName(cong,"Location",sourceLocation_id);
}

//String destinationLocation_id= request.getParameter("destinationLocation_id");
//out.print("<br>132 destinationLocation_id"+destinationLocation_id);

if("0".equals(destinationLocation_id))
		{destinationLocationName="ALL";}
else{
  destinationLocationName=A.getName(cong,"Location",destinationLocation_id);
}
double total_saleaccount=0;
String StockTransfer_Type="";//request.getParameter("StockTransfer_Type");
String strTransfer_Type=""+StockTransfer_Type;
//out.print("<br> 144 StockTransfer_Type "+StockTransfer_Type);
//out.print("<br>party=" +party_id);

errLine="131";
String query="";
String condition ="";
query="Select * from Receive where Receive_Date between ? and ? and Receive_FromId="+company_id+" and Purchase=1 and Receive_Sell=0 and Active=1"+condition+" and company_id="+company_id+" order by Receive_Date,Receive_No";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
rs_g = pstmt_g.executeQuery();	
int scounter=0;
while(rs_g.next())
{
	scounter++;
}
pstmt_g.close();
//out.print("<br> 144 scounter"+scounter);
errLine="146";




int sReceive_Id[]=new int[scounter];
String sReceive_No[]=new String[scounter];
String sReceive_Date[]=new String[scounter];
String sType[]=new String[scounter];
String St_type[]=new String[scounter];
String sReceive_Lots[]=new String[scounter];
String sLocation_id[]=new String[scounter];
double sReceive_Quantity[]=new double[scounter];
double sLocal_Total[]=new double[scounter];
double sDollar_Total[]=new double[scounter];

int dReceive_Id[]=new int[scounter];
String dReceive_No[]=new String[scounter];
String dReceive_Date[]=new String[scounter];
String dType[]=new String[scounter];
String dt_type[]=new String[scounter];
String dReceive_Lots[]=new String[scounter];
String dLocation_id[]=new String[scounter];
double dReceive_Quantity[]=new double[scounter];
double dLocal_Total[]=new double[scounter];
double dDollar_Total[]=new double[scounter];

query="Select * from Receive where Receive_Date between ? and ? and Receive_FromId="+company_id+" and Purchase=1 and Receive_Sell=0 and Active=1"+condition+" and company_id="+company_id+" order by Receive_Date,Receive_No";
errLine="188";			
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);	
rs_g = pstmt_g.executeQuery();	
int g=0;
while(rs_g.next())
{
sReceive_Id[g]=rs_g.getInt("Receive_Id");
sReceive_No[g]=rs_g.getString("Receive_No");
sReceive_Date[g]=format.format(rs_g.getDate("Receive_Date"));
sType[g]=rs_g.getString("StockTransfer_Type");
String cgtRId = rs_g.getString("Consignment_ReceiveId");
if("1".equals(sType[g]))
{ St_type[g]="Lot to lot"; }
else if("2".equals(sType[g]))
{St_type[g]="Location Transfer";}
else if("3".equals(sType[g]))
{St_type[g]="Diff. Rates";}
else if("4".equals(sType[g]))
{	
if(! "0".equals(cgtRId))
{	
St_type[g]="Split";					
}
else{St_type[g]="Mixing";}	
}
else if("5".equals(sType[g]))
{		St_type[g]="Melting";}
else if("6".equals(sType[g]))
{		St_type[g]="Loss / Wastage";}
else if("7".equals(sType[g]))
{		St_type[g]="Gain";}
			
		sReceive_Lots[g]=rs_g.getString("Receive_Lots");
		sReceive_Quantity[g]=rs_g.getDouble("Receive_Quantity");
		sLocal_Total[g]=rs_g.getDouble("Local_Total");
		sDollar_Total[g]=rs_g.getDouble("Dollar_Total");
		if(!("6".equals(sType[g])))
		{
		if(!("7".equals(sType[g])))
		dReceive_Id[g]=sReceive_Id[g]+1;
		else
		dReceive_Id[g]=sReceive_Id[g];
		String pquery="select * from Receive where Receive_Id="+dReceive_Id[g];
		pstmt_p=conp.prepareStatement(pquery);
		rs_p=pstmt_p.executeQuery();
		while(rs_p.next())
		{
		dReceive_Lots[g]=rs_p.getString("Receive_Lots");
		dReceive_Quantity[g]=rs_p.getDouble("Receive_Quantity");
		dLocal_Total[g]=rs_p.getDouble("Local_Total");
		dDollar_Total[g]=rs_p.getDouble("Dollar_Total");
		}
		pstmt_p.close();
		}
		g++;
	}
pstmt_g.close();
//New.
errLine="230";

//out.print("condition"+condition);
query="select Max(RT.Location_Id) as Location_Id from Receive R, Receive_Transaction RT where R.Receive_Date between ? and ? and R.Receive_FromId="+company_id+" and R.Purchase=1 and R.Receive_Sell=0 and R.Active=1 and RT.Active=1 and R.company_id="+company_id+" and R.Receive_Id=RT.Receive_Id group by R.Receive_ID,R.Receive_Date,R.Receive_No order by R.Receive_Date,R.Receive_No";
errLine="232";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);
rs_g=pstmt_g.executeQuery();
int m=0;
while(rs_g.next())
{
	sLocation_id[m]=rs_g.getString("Location_id");
	//out.print("<bR>261 m="+m+"sLocation_id[m]"+sLocation_id[m]);

	m++;

}
errLine="242";
pstmt_g.close();

query="select Max(RT.Location_Id) as Location_Id from Receive R, Receive_Transaction RT where R.Receive_Date between ? and ? and R.Receive_FromId="+company_id+" and R.Purchase=1 and R.Receive_Sell=1 and R.Active=1 and RT.Active=1 and R.company_id="+company_id+" and R.Receive_Id=RT.Receive_Id group by R.Receive_ID,R.Receive_Date,R.Receive_No order by R.Receive_Date,R.Receive_No";
errLine="232";
pstmt_g = cong.prepareStatement(query);
pstmt_g.setString(1,""+D1);
pstmt_g.setString(2,""+D2);
rs_g=pstmt_g.executeQuery();
//out.print("<br> 271 m="+m);
m=0;
while(rs_g.next())
{
	dLocation_id[m]=rs_g.getString("Location_id");
	m++;
}errLine="242";
pstmt_g.close();
//C.returnConnection(conp);
//C.returnConnection(cong);

for(int i=0;i<scounter;i++)
{
	

//Start 0 and 0	
	if("0".equals(sourceLocation_id) && "0".equals(destinationLocation_id))
	{

		source_qty_total +=sReceive_Quantity[i];
		dest_qty_total +=dReceive_Quantity[i];
		source_local_total +=sLocal_Total[i];
		dest_local_total +=dLocal_Total[i];
		source_dollar_total +=sDollar_Total[i];
		dest_dollar_total +=dDollar_Total[i];



	}//if

//end of 0 0

//start of S and 0	
	if(!("0".equals(sourceLocation_id)) && "0".equals(destinationLocation_id))
		{


if("2".equals(sType[i]) && sourceLocation_id.equals(sLocation_id[i]))
			{
//out.print("<bR>344 i="+i+" sLocation_id[i]"+sLocation_id[i]+ " sourceLocation_id="+sourceLocation_id);

	source_qty_total +=sReceive_Quantity[i];
	dest_qty_total +=dReceive_Quantity[i];
	source_local_total +=sLocal_Total[i];
	dest_local_total +=dLocal_Total[i];
	source_dollar_total +=sDollar_Total[i];
	dest_dollar_total +=dDollar_Total[i];	
	
	}//if "2".equals(St_type[i]) && sourceLocation_id.equals(sLocation_id[i])
		}//(!("0".equals(sourceLocation_id)) && 

//end of s and 0


//start of 0 and d	
	if("0".equals(sourceLocation_id) && !("0".equals(destinationLocation_id)))
		{


if("2".equals(sType[i]) && destinationLocation_id.equals(dLocation_id[i]))
			{
//out.print("<bR>344 i="+i+" dLocation_id[i]"+dLocation_id[i]+ " destinationLocation_id="+destinationLocation_id);

	source_qty_total +=sReceive_Quantity[i];
	dest_qty_total +=dReceive_Quantity[i];
	source_local_total +=sLocal_Total[i];
	dest_local_total +=dLocal_Total[i];
	source_dollar_total +=sDollar_Total[i];
	dest_dollar_total +=dDollar_Total[i];
	}//if "2".equals(St_type[i]) && sourceLocation_id.equals(sLocation_id[i])
		}//(!("0".equals(sourceLocation_id)) && 

//end of 0 and d
	
//start of s and d	
	if(!("0".equals(sourceLocation_id)) && !("0".equals(destinationLocation_id)))
		{


if("2".equals(sType[i]) &&  sourceLocation_id.equals(sLocation_id[i])&& destinationLocation_id.equals(dLocation_id[i]) )

			{
//out.print("<bR>344 i="+i+" dLocation_id[i]"+dLocation_id[i]+ " destinationLocation_id="+destinationLocation_id);

	source_qty_total +=sReceive_Quantity[i];
	dest_qty_total +=dReceive_Quantity[i];
	source_local_total +=sLocal_Total[i];
	dest_local_total +=dLocal_Total[i];
	source_dollar_total +=sDollar_Total[i];
	dest_dollar_total +=dDollar_Total[i];	
	
	
	
	}//if "2".equals(St_type[i]) && sourceLocation_id.equals(sLocation_id[i])
		}//(!("0".equals(sourceLocation_id)) && 

//end of s and d

}//for




} */
	catch(Exception e)
	{
			System.out.print("<BR> 350 EXCEPTION error line="+errLine+"error is:" +e);
			return ("<BR> 350 EXCEPTION error line="+errLine+"error is:" +e);
			//C.returnConnection(conp);
            //C.returnConnection(cong);
			//C.returnConnection(cong);
	}

  
  
  return result; 

}//getInvStockTransferTotal()
} //InvStockTransfer