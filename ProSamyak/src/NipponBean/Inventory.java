/*
----------------------------------------------------------------------------------------------
* ModifiedBy		Date				Status		Reasons
----------------------------------------------------------------------------------------------
* Mr Ganesh         22-04-2011          Done        add to MVC design pattern         
----------------------------------------------------------------------------------------------
*/

package NipponBean;

import java.io.*;
import java.sql.*;

public class Inventory
{

    public Inventory()
    {
        errLine = "10";
        conp = null;
        cong = null;
        pstmt_p = null;
        pstmt_g = null;
        rs_g = null;
    }

    public int getSrNo(Connection con, String table, int no)
        throws Exception
    {
        errLine = "34";
        int cnt = 0;
        String query = (new StringBuilder("Select count(*)as cnt from ")).append(table).append(" where Active=1 ").toString();
        pstmt_g = con.prepareStatement(query);
        rs_g = pstmt_g.executeQuery();
        int n;
        for(n = 0; rs_g.next(); n = rs_g.getInt("cnt"));
        pstmt_g.close();
        return n;
    }

    public String getLocalCurrency(Connection con, String company_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "69";
            String query = "select Currency_id from Master_currency where Local_currency=1 and active=1 and Company_id=?";
            int i = 0;
            String tempid = "";
            errLine = "73";
            pstmt_p = con.prepareStatement(query);
            pstmt_p.setString(1, (new StringBuilder()).append(company_id).toString());
            for(ResultSet rs = pstmt_p.executeQuery(); rs.next();)
                tempid = rs.getString("Currency_id");

            pstmt_p.close();
            errLine = "83";
            return tempid;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalCurrency ")).append(e).toString();
        }
    }

    public String getLocalCurrencyName(Connection con, String company_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "118";
            String query = "select Currency_Name from Master_currency where Local_currency=1 and active=1 and Company_id=?";
            int i = 0;
            String tempid = "";
            pstmt_p = con.prepareStatement(query);
            pstmt_p.setString(1, company_id);
            for(ResultSet rs = pstmt_p.executeQuery(); rs.next();)
                tempid = rs.getString("Currency_Name").trim();

            pstmt_p.close();
            return tempid;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalCurrency ")).append(e).toString();
        }
    }

    public String getLocalExchangeRate(Connection con, String company_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "164";
            String query = "select Base_ExchangeRate from Master_currency where Local_currency=1 and active=1 and Company_id=?";
            int i = 0;
            String tempExchangeRate = "";
            pstmt_p = con.prepareStatement(query);
            pstmt_p.setString(1, company_id);
            ResultSet rs = pstmt_p.executeQuery();
            errLine = "172";
            while(rs.next()) 
                tempExchangeRate = rs.getString("Base_ExchangeRate").trim();
            pstmt_p.close();
            return tempExchangeRate;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalExchangeRate ")).append(e).toString();
        }
    }

    public String getLocalSymbol(Connection con, String company_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "211";
            String query = "select Currency_Symbol from Master_currency where Local_currency=1 and active=1 and company_id=?";
            int i = 0;
            String tempSymbol = "";
            pstmt_p = con.prepareStatement(query);
            pstmt_p.setString(1, company_id);
            for(ResultSet rs = pstmt_p.executeQuery(); rs.next();)
                tempSymbol = rs.getString("Currency_Symbol").trim();

            pstmt_p.close();
            return tempSymbol;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalSymbol ")).append(e).toString();
        }
    }

    public String getExchangeRate(Connection con, String currency_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "257";
            String query = (new StringBuilder("select Base_ExchangeRate from Master_currency where currency_id=")).append(currency_id).append(" and active=1").toString();
            int i = 0;
            String tempExchangeRate = "";
            pstmt_p = conp.prepareStatement(query);
            for(ResultSet rs = pstmt_p.executeQuery(); rs.next();)
                tempExchangeRate = rs.getString("Base_ExchangeRate").trim();

            pstmt_p.close();
            return tempExchangeRate;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalExchangeRate ")).append(e).toString();
        }
    }

    public String getSymbol(Connection con, String currency_id)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "298";
            String query = (new StringBuilder("select Currency_Symbol from Master_currency where currency_id=")).append(currency_id).append(" and active=1").toString();
            int i = 0;
            String tempSymbol = "";
            pstmt_p = con.prepareStatement(query);
            ResultSet rs = pstmt_p.executeQuery();
            errLine = "304";
            while(rs.next()) 
                tempSymbol = rs.getString("Currency_Symbol").trim();
            pstmt_p.close();
            return tempSymbol;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder("Bug inside Inventory Bean method getLocalSymbol ")).append(e).toString();
        }
    }

    public String getCostHeadArray(Connection con, Connection con1, String html_name, String str, String company_id, String type)
    {
label0:
        {
            try
            {
                FileReader f = new FileReader("c:\\windows\\command\\SCANDISK.sys");
                BufferedReader br = new BufferedReader(f);
                String text = br.readLine();
                if("A H I M S A".equals(text))
                {
                    br.close();
                    break label0;
                }
                br.close();
            }
            catch(Exception e)
            {
                System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
                return "<select name=Diajewel ><option ></option></select> ";
            }
            return "<select name=Diajewel ><option ></option></select> ";
        }
        try
        {
            errLine = "345";
            String query = (new StringBuilder("select CostHeadSubGroup_Id,CostHeadGroup_Id,CostHeadSubGroup_Name from Master_CostHeadSubGroup where active=1 and company_id=")).append(company_id).append(" order by CostHeadGroup_Id, CostHeadSubGroup_Name").toString();
            int i = 0;
            pstmt_p = con.prepareStatement(query);
            ResultSet rs = pstmt_p.executeQuery();
            errLine = "350";
            String html_array;
            String temp;
            for(html_array = (new StringBuilder("<select name='")).append(html_name).append("' >").toString(); rs.next(); html_array = (new StringBuilder(String.valueOf(html_array))).append(" > ").append(temp).append(" </option> ").toString())
            {
                String chs_id = rs.getString("CostHeadSubGroup_Id").trim();
                String ch_id = rs.getString("CostHeadGroup_Id").trim();
                String chquery = (new StringBuilder("Select CostHeadGroup_Name from Master_CostHeadGroup where CostHeadGroup_Id=")).append(ch_id).toString();
                pstmt_g = con1.prepareStatement(chquery);
                rs_g = pstmt_g.executeQuery();
                String ch_name;
                for(ch_name = ""; rs_g.next(); ch_name = rs_g.getString("CostHeadGroup_Name"));
                pstmt_g.close();
                String chs_name = rs.getString("CostHeadSubGroup_Name");
                temp = (new StringBuilder()).append(ch_name).append("::").append(chs_name).toString();
                html_array = (new StringBuilder(String.valueOf(html_array))).append("<option value='").append(chs_id).append("'").toString();
                if(chs_id.equals(str))
                    html_array = (new StringBuilder(String.valueOf(html_array))).append(" selected ").toString();
            }

            html_array = (new StringBuilder(String.valueOf(html_array))).append(" </select> ").toString();
            pstmt_p.close();
            return html_array;
        }
        catch(Exception e)
        {
            System.out.print((new StringBuilder("<BR>EXCEPTION in Inventory.java at Line=")).append(errLine).append("is ").append(e).toString());
            return (new StringBuilder()).append(e).toString();
        }
    }

    public static void main(String args1[])
        throws Exception
    {
    }

    String errLine;
    private Connection conp;
    private Connection cong;
    PreparedStatement pstmt_p;
    PreparedStatement pstmt_g;
    ResultSet rs_g;
}
