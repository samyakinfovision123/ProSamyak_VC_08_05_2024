package NipponBean.Lists;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import NipponBean.*;

/**
 * A simple lots list
 */
public class CompanyPartyList {

  
  
  Connection cong=null;
  ResultSet rs_g=null;
  
  PreparedStatement pstmt_g=null;
  
  String party_id[]=new String[1];
  String party_name1[]=new String[1];
  String account_type=null;
  String ledger_id=null;
  Connect C;
  
  String errLine = "26";	
  public CompanyPartyList() 
  { 
	try
	{
		C = new Connect();
	}
	catch(Exception e)
	{
		System.out.println("Exception in LotList() in LotList="+e);
	}
	
 }

 public void getPartyIdName(String company_id,String party_name,String isNext)
 {
	  
	  try
	  {
		
		
		String query="";
		cong = C.getConnection();
		errLine = "129";
		String companyArray_temp="";
		String companyQuery = "Select CompanyParty_Name from Master_CompanyParty where  Company_Id="+company_id+" order by CompanyParty_Name";
		pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt_g.executeQuery();
			
		while(rs_g.next()) 	
		{
			if(rs_g.isLast())
			{
				companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
			}
			else
			{
				companyArray_temp += "\"" +rs_g.getString("CompanyParty_Name") +"\",";
			}
		}
		pstmt_g.close();
		companyQuery = "Select Account_Name from Master_Account where Company_Id="+company_id+" order by Account_Name";
		pstmt_g = cong.prepareStatement(companyQuery, ResultSet.TYPE_SCROLL_INSENSITIVE,                   ResultSet.CONCUR_READ_ONLY);
		rs_g = pstmt_g.executeQuery();
			
		while(rs_g.next()) 	
		{
			if(rs_g.isLast())
			{
				companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\"";
			}
			else
			{
				companyArray_temp += "\"" +rs_g.getString("Account_Name") +"\",";
			}
		}
		pstmt_g.close();
			
		int len=companyArray_temp.length();
		String companyArray_tokenizer=companyArray_temp.substring(1,(len-1));
		String companyArray_sort[]=companyArray_tokenizer.split("\",\"");
		java.util.Arrays.sort(companyArray_sort,java.text.Collator.getInstance());
		
		if("PartyNext".equals(isNext))
		{
			String array_party_name="";
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(companyArray_sort[i].equals(party_name))
				{
					array_party_name=companyArray_sort[i+1];
				}//if

			}
			String account_type=isParty(company_id,array_party_name);
						
			if("party_account".equals(account_type))
			{
				query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where super=0 and company_id="+company_id+" and companyparty_name like '"+array_party_name+"'";
			}
			if("cash_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			if("bank_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			
			
		} //if("PartyNext".equals(isNext))
		if("PartyPrev".equals(isNext))
		{
			String array_party_name="";
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(companyArray_sort[i].equals(party_name))
				{
					array_party_name=companyArray_sort[i-1];
				}//if

			}
			String account_type=isParty(company_id,array_party_name);
			
			if("party_account".equals(account_type))
			{
				query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where active=1 and super=0 and company_id="+company_id+" and companyparty_name like '"+array_party_name+"'";
			}
			if("cash_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			if("bank_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			
			
			
		} //if("PartyPrev".equals(isNext))
		if("Edit".equals(isNext))
		{
			String account_type=isParty(company_id,party_name);
			if("party_account".equals(account_type))
			{
				query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where super=0 and company_id="+company_id+" and companyparty_name like '"+party_name+"'";
			}
			if("cash_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+party_name+"'";
			}
			if("bank_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+party_name+"'";
			}
		} //if("Edit".equals(isNext))
		if("PartyFirst".equals(isNext))
		{
			String array_party_name="";
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(companyArray_sort[i].equals(party_name))
				{
					array_party_name=companyArray_sort[0];
				}//if

			}
			String account_type=isParty(company_id,array_party_name);
			
			if("party_account".equals(account_type))
			{
				query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where active=1 and super=0 and company_id="+company_id+" and companyparty_name like '"+array_party_name+"'";
			}
			if("cash_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			if("bank_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			
			
		} //if("PartyFirst".equals(isNext))
		if("PartyLast".equals(isNext))
		{
			String array_party_name="";
			for(int i=0;i<companyArray_sort.length;i++)
			{
				if(companyArray_sort[i].equals(party_name))
				{
					array_party_name=companyArray_sort[(companyArray_sort.length-1)];
				}//if

			}
			String account_type=isParty(company_id,array_party_name);
			
			if("party_account".equals(account_type))
			{
				query="select CompanyParty_Id,CompanyParty_Name from Master_CompanyParty where active=1 and super=0 and company_id="+company_id+" and companyparty_name like '"+array_party_name+"'";
			}
			if("cash_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
			if("bank_account".equals(account_type))
			{
				query="select Account_Id as CompanyParty_Id,Account_Name as  CompanyParty_Name from Master_Account where company_id="+company_id+" and account_name like '"+array_party_name+"'";
			}
		} //if("PartyLast".equals(isNext))
		
		pstmt_g = cong.prepareStatement(query);
		//System.out.println("query = "+query);
		rs_g = pstmt_g.executeQuery();
		int cnt=0;
		while(rs_g.next()) 	
		{
			party_id[cnt]=rs_g.getString("CompanyParty_Id");
			party_name1[cnt]=rs_g.getString("CompanyParty_Name");
			cnt++;
			break;
		}	
		rs_g.close();
		pstmt_g.close();
		C.returnConnection(cong);
		} //try
	  catch(Exception e)
	  {
		  C.returnConnection(cong);
		  
		  System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	  }  //catch
		
		//System.out.println("party_id[0]"+party_id[0]);
		//System.out.println("party_name1[0]"+party_name1[0]);
} //getPartyIdName(String company_id,String party_name,String isNext)
		
public String isParty(String company_id,String party_name)
{
	try
	{
			String check_party_cashBank="select CompanyParty_Name as account_counter from Master_CompanyParty where companyparty_name ='"+party_name+"' and company_id="+company_id+"";
			
			pstmt_g = cong.prepareStatement(check_party_cashBank);
		
			rs_g = pstmt_g.executeQuery();
			errLine="112";
			while(rs_g.next())
			{
				account_type="party_account";
			}
			pstmt_g.close();

			
			check_party_cashBank="select ledger_Id from Ledger where ledger_name ='"+party_name+"' and company_id="+company_id+" and for_head<>14";
			
			pstmt_g = cong.prepareStatement(check_party_cashBank);
		
			rs_g = pstmt_g.executeQuery();
			errLine="112";
			while(rs_g.next())
			{
				ledger_id=rs_g.getString("ledger_Id");
			}
			pstmt_g.close();
			
			errLine = "115";	
			check_party_cashBank="select accounttype_id from Master_Account where account_name ='"+party_name+"' and company_id="+company_id+"";
			pstmt_g = cong.prepareStatement(check_party_cashBank);
			
			rs_g = pstmt_g.executeQuery();
			while(rs_g.next())
			{
				String str_type=rs_g.getString("accounttype_id");
				if("1".equals(str_type))
					account_type="bank_account";
				if("6".equals(str_type))
					account_type="cash_account";
			}
			pstmt_g.close();
			
	   
	} //try
	catch(Exception e)
	{
		 C.returnConnection(cong);
		  
		 System.out.println("Exception in getLots() in LotList after line="+errLine+" : "+e);
	 }  //catch
	return account_type;
} //isParty(String company_id,String party_name)
		

 /**
   * @return XML representation of lots list
   */
  public String toXml() {
    StringBuffer xml = new StringBuffer();
    xml.append("<?xml version=\"1.0\"?>\n");
    xml.append("<IdList generated=\""+System.currentTimeMillis()+"\">\n");
	//System.out.println("party_name1.length="+party_name1[0]);	
    for (int i=0;i<party_name1.length;i++) {
    
	  String str_party_name=party_name1[i];
	 //replace the ampersand in the code by &amp;
     if(null!=str_party_name)
	 {
	  StringBuffer tempNo = new StringBuffer(str_party_name);
	  if( (str_party_name).indexOf('&') != -1 )
		{
			tempNo = tempNo.replace( (str_party_name).indexOf("&"), ((str_party_name).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
		}
	  //System.out.println(tempName);
	 
	 String str_party_id=party_id[i];
	 StringBuffer tempId = new StringBuffer(str_party_id);
	 if( (str_party_id).indexOf('&') != -1 )
	 {
			tempId = tempId.replace( (str_party_id).indexOf("&"), ((str_party_id).indexOf("&"))+1, "&amp;");
			//System.out.println("Changed = "+tempName);
	 }

	 xml.append("<ReceiveIdNumber>\n");
		 
		  xml.append("<ReceiveId>");
		  xml.append(tempId);
		  xml.append("</ReceiveId>\n");
		  
		  xml.append("<ReceiveNo>");
		  xml.append(tempNo);
		  xml.append("</ReceiveNo>\n");
		  
		  xml.append("<AccountType>");
		  xml.append(account_type);
		  xml.append("</AccountType>\n");		 
	 
		  xml.append("<LedgerId>");
		  xml.append(ledger_id);
		  xml.append("</LedgerId>\n");
	 
	 xml.append("</ReceiveIdNumber>\n");
    
	 } //if
	}
    
    xml.append("</IdList>\n");
    
	System.out.println("xml="+xml);
	return xml.toString();
  }

  
}
