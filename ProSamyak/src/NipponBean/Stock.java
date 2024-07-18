package NipponBean;

import java.util.*;
import java.sql.*;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;

import NipponBean.*;

public class Stock {
	Connect1 C = null;

	Connection cong = null;

	ResultSet rs_g = null;

	PreparedStatement pstmt_g = null;

	public Stock() {
		/*
		 * try{ C = new Connect1(); }catch(Exception e){
		 * System.out.println("Exception 21 ::- "+e);}
		 */
	}

	public double stockValue(Connection con, java.sql.Date D1,
			String company_id, String type, int d) {
		try {
			// cong=C.getConnection();

			String query = "";
			if ("Opening".equals(type)) {
				query = "Select * from Lot where created_on < ?  and Company_id=? and Active=1 order by Lot_id";
			} else {
				query = "Select * from Lot where created_on <= ?  and Company_id=? and Active=1   order by Lot_id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int count = 0;
			while (rs_g.next())
			{
				count++;
			}
			pstmt_g.close();
			int counter = count;
			String lot_id[] = new String[count];
			String lot_no[] = new String[count];
			double carats[] = new double[count];
			double local_price[] = new double[count];
			double dollar_price[] = new double[count];
			double pcarats[] = new double[count];
			double plocal_price[] = new double[count];
			double pdollar_price[] = new double[count];
			double ccarats[] = new double[count];
			double clocal_price[] = new double[count];
			double cdollar_price[] = new double[count];
			double per_carats[] = new double[count];
			double sale_carats[] = new double[count];
			double per_ccarats[] = new double[count];
			double sale_ccarats[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			while (rs_g.next()) {
				lot_id[c] = rs_g.getString("Lot_id");
				lot_no[c] = rs_g.getString("Lot_No");
				c++;
			}
			pstmt_g.close();

			if ("Opening".equals(type)) {
				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			} else {

				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			c = 0;
			while (rs_g.next()) {

				lotid[c] = rs_g.getString("Lot_id");
				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				dollarprice[c] = rs_g.getDouble("Dollar_Price");

				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");

				c++;
			}
			pstmt_g.close();
			// C.returnConnection(cong);

			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			int k = 0;
			for (int i = 0; i < counter; i++) {

				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {
							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_carats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_carats[i] += qty[j];
					}

					j++;
				}
				carats[i] = tqty;

				try {
					new Double("" + localp);
					local_price[i] = localp;
				} catch (Exception e) {
					local_price[i] = 0;
				}
				try {
					new Double("" + dollarp);
					dollar_price[i] = dollarp;
				} catch (Exception e) {
					dollar_price[i] = 0;
				}

				pcarats[i] = 0;
				plocal_price[i] = 0;
				pdollar_price[i] = 0;
				ccarats[i] = 0;
				clocal_price[i] = 0;
				cdollar_price[i] = 0;

			}

			for (int i = 0; i < counter; i++) {
				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;

						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_ccarats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_ccarats[i] += qty[j];
					}

					j++;
				}
				ccarats[i] = tqty;
				clocal_price[i] = localp;

			}
			double total = 0;
			double local_total = 0;
			double dollar_total = 0;
			double dollar_subtotal = 0;
			double local_subtotal = 0;
			for (int i = 0; i < counter; i++) {
				/* To handle exponent value start */
				/*
				 * if(carats[i]<0) {if((carats[i])> -0.001 ) {carats[i]=0.0;}
				 * }else{if(carats[i]<0.001){carats[i]=0.0;}}
				 */
				/* To handle exponent value End */

				total += carats[i];
				dollar_subtotal = dollar_price[i] * carats[i];
				local_subtotal = carats[i] * local_price[i];
				local_total += str.mathformat(local_subtotal, d);
				dollar_total += dollar_subtotal;
			}

			return local_total;
		} catch (Exception Samyak109) {// C.returnConnection(cong);
			return 0;
		}
		// finally{C.returnConnection(cong); }

	}// stockValue

	public double stockValue(Connection con, java.sql.Date D1,
			String company_id, String type, int d, String condition) {
		try {
			// cong=C.getConnection();

			String query = "";
			if ("Opening".equals(type)) {
				query = "Select * from Lot where created_on < ?  and Company_id=? and Active=1  "
						+ condition + " order by Lot_id";
			} else {
				query = "Select * from Lot where created_on <= ?  and Company_id=? and Active=1  "
						+ condition + " order by Lot_id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();
			int counter = count;
			String lot_id[] = new String[count];
			String lot_no[] = new String[count];
			double carats[] = new double[count];
			double local_price[] = new double[count];
			double dollar_price[] = new double[count];
			double pcarats[] = new double[count];
			double plocal_price[] = new double[count];
			double pdollar_price[] = new double[count];
			double ccarats[] = new double[count];
			double clocal_price[] = new double[count];
			double cdollar_price[] = new double[count];
			double per_carats[] = new double[count];
			double sale_carats[] = new double[count];
			double per_ccarats[] = new double[count];
			double sale_ccarats[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			while (rs_g.next()) {
				lot_id[c] = rs_g.getString("Lot_id");
				lot_no[c] = rs_g.getString("Lot_No");
				c++;
			}
			pstmt_g.close();

			if ("Opening".equals(type)) {
				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			} else {

				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			c = 0;
			while (rs_g.next()) {

				lotid[c] = rs_g.getString("Lot_id");
				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				dollarprice[c] = rs_g.getDouble("Dollar_Price");

				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");

				c++;
			}
			pstmt_g.close();

			// C.returnConnection(cong);
			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			int k = 0;
			for (int i = 0; i < counter; i++) {

				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;
						if (0 == (tqty_temp + qty[j])) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_carats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_carats[i] += qty[j];
					}

					j++;
				}
				carats[i] = tqty;

				try {
					new Double("" + localp);
					local_price[i] = localp;
				} catch (Exception e) {
					local_price[i] = 0;
				}
				try {
					new Double("" + dollarp);
					dollar_price[i] = dollarp;
				} catch (Exception e) {
					dollar_price[i] = 0;
				}

				pcarats[i] = 0;
				plocal_price[i] = 0;
				pdollar_price[i] = 0;
				ccarats[i] = 0;
				clocal_price[i] = 0;
				cdollar_price[i] = 0;

			}

			for (int i = 0; i < counter; i++) {
				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;

						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_ccarats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_ccarats[i] += qty[j];
					}

					j++;
				}
				ccarats[i] = tqty;
				clocal_price[i] = localp;

			}
			double total = 0;
			double local_total = 0;
			double dollar_total = 0;
			double dollar_subtotal = 0;
			double local_subtotal = 0;
			for (int i = 0; i < counter; i++) {
				/* To handle exponent value start */
				/*
				 * if(carats[i]<0) {if((carats[i])> -0.001 ) {carats[i]=0.0;}
				 * }else{if(carats[i]<0.001){carats[i]=0.0;}}
				 */
				/* To handle exponent value End */

				total += carats[i];
				dollar_subtotal = dollar_price[i] * carats[i];
				local_subtotal = carats[i] * local_price[i];
				local_total += str.mathformat(local_subtotal, d);
				dollar_total += dollar_subtotal;
			}

			return local_total;
		} catch (Exception Samyak109) {// C.returnConnection(cong);
			return 0;
		}
		// finally{C.returnConnection(cong); }

	}// stockValue

	public double stockValue(Connection con, java.sql.Date D1,
			String company_id, String type) {
		try {
			// cong=C.getConnection();

			String query = "";
			if ("Opening".equals(type)) {
				query = "Select * from Lot where created_on < ?  and Company_id=? and Active=1  order by Lot_id";
			} else {
				query = "Select * from Lot where created_on <= ?  and Company_id=? and Active=1  order by Lot_id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();
			int counter = count;
			String lot_id[] = new String[count];
			String lot_no[] = new String[count];
			double carats[] = new double[count];
			double local_price[] = new double[count];
			double dollar_price[] = new double[count];
			double pcarats[] = new double[count];
			double plocal_price[] = new double[count];
			double pdollar_price[] = new double[count];
			double ccarats[] = new double[count];
			double clocal_price[] = new double[count];
			double cdollar_price[] = new double[count];
			double per_carats[] = new double[count];
			double sale_carats[] = new double[count];
			double per_ccarats[] = new double[count];
			double sale_ccarats[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			while (rs_g.next()) {
				lot_id[c] = rs_g.getString("Lot_id");
				lot_no[c] = rs_g.getString("Lot_No");
				c++;
			}
			pstmt_g.close();

			if ("Opening".equals(type)) {
				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date < ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			} else {

				query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			}
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			c = 0;
			while (rs_g.next()) {
				lotid[c] = rs_g.getString("Lot_id");
				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				dollarprice[c] = rs_g.getDouble("Dollar_Price");

				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");

				c++;
			}
			pstmt_g.close();
			// C.returnConnection(cong);

			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			int k = 0;
			for (int i = 0; i < counter; i++) {

				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_carats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_carats[i] += qty[j];
					}

					j++;
				}
				carats[i] = tqty;

				try {
					new Double("" + localp);
					local_price[i] = localp;
				} catch (Exception e) {
					local_price[i] = 0;
				}
				try {
					new Double("" + dollarp);
					dollar_price[i] = dollarp;
				} catch (Exception e) {
					dollar_price[i] = 0;
				}

				pcarats[i] = 0;
				plocal_price[i] = 0;
				pdollar_price[i] = 0;
				ccarats[i] = 0;
				clocal_price[i] = 0;
				cdollar_price[i] = 0;

			}

			for (int i = 0; i < counter; i++) {
				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;

						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_ccarats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("0".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_ccarats[i] += qty[j];
					}

					j++;
				}
				ccarats[i] = tqty;
				clocal_price[i] = localp;

			}
			double total = 0;
			double local_total = 0;
			double dollar_total = 0;
			double dollar_subtotal = 0;
			double local_subtotal = 0;
			for (int i = 0; i < counter; i++) {
				/* To handle exponent value start */
				/*
				 * if(carats[i]<0) {if((carats[i])> -0.001 ) {carats[i]=0.0;}
				 * }else{if(carats[i]<0.001){carats[i]=0.0;}}
				 */
				/* To handle exponent value End */

				total += carats[i];
				dollar_subtotal = dollar_price[i] * carats[i];
				local_subtotal = carats[i] * local_price[i];
				local_total += local_subtotal;
				dollar_total += dollar_subtotal;
			}

			return local_total;
		} catch (Exception Samyak109) {// C.returnConnection(cong);
			return 0;
		}
		// finally{C.returnConnection(cong); }

	}// stockValue

	public double stockRate(Connection con, java.sql.Date D1,
			String company_id, String rlotid) {
		try {
			// cong=C.getConnection();

			String query = "";
			query = "Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setString(1, rlotid);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();
			int counter = count;
			String lot_id[] = new String[count];
			String lot_no[] = new String[count];
			double carats[] = new double[count];
			double local_price[] = new double[count];
			double dollar_price[] = new double[count];
			double pcarats[] = new double[count];
			double plocal_price[] = new double[count];
			double pdollar_price[] = new double[count];
			double ccarats[] = new double[count];
			double clocal_price[] = new double[count];
			double cdollar_price[] = new double[count];
			double per_carats[] = new double[count];
			double sale_carats[] = new double[count];
			double per_ccarats[] = new double[count];
			double sale_ccarats[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setString(1, rlotid);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			while (rs_g.next()) {
				lot_id[c] = rs_g.getString("Lot_id");
				lot_no[c] = rs_g.getString("Lot_No");
				c++;
			}
			pstmt_g.close();

			query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.Purchase=1 and RT.Lot_id="
					+ rlotid
					+ " and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			c = 0;
			while (rs_g.next()) {

				lotid[c] = rs_g.getString("Lot_id");
				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				dollarprice[c] = rs_g.getDouble("Dollar_Price");
				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");
				c++;
			}
			pstmt_g.close();
			// C.returnConnection(cong);

			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			double rate = 0;
			int k = 0;
			for (int i = 0; i < counter; i++) {

				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_carats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_carats[i] += qty[j];
					}

					j++;
				}
				carats[i] = tqty;

				try {
					new Double("" + localp);
					local_price[i] = localp;
				} catch (Exception e) {
					local_price[i] = 0;
				}
				try {
					new Double("" + dollarp);
					dollar_price[i] = dollarp;
				} catch (Exception e) {
					dollar_price[i] = 0;
				}
				rate = local_price[i];
			}

			/*
			 * double total=0; double local_total=0; double dollar_total=0;
			 * double dollar_subtotal=0; double local_subtotal=0; for(int i=0; i<
			 * counter; i++) { total += carats[i];
			 * dollar_subtotal=dollar_price[i] * carats[i];
			 * local_subtotal=carats[i] * local_price[i]; local_total
			 * +=local_subtotal; dollar_total +=dollar_subtotal; }
			 */

			return rate;
		} catch (Exception Samyak109) {// C.returnConnection(cong);
			return 0;
		}
		// finally{C.returnConnection(cong); }

	}// stockRate

	public String stockStatus(Connection con, java.sql.Date D1,
			String company_id, String rlotid) {
		try {
			// cong=C.getConnection();

			String query = "";
			query = "Select * from Lot where Lot_id=?  and Company_id=? and Active=1  order by Lot_id";
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setString(1, rlotid);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();
			int counter = count;
			String lot_id[] = new String[count];
			String lot_no[] = new String[count];
			double carats[] = new double[count];
			double local_price[] = new double[count];
			double dollar_price[] = new double[count];
			double pcarats[] = new double[count];
			double plocal_price[] = new double[count];
			double pdollar_price[] = new double[count];
			double ccarats[] = new double[count];
			double clocal_price[] = new double[count];
			double cdollar_price[] = new double[count];
			double per_carats[] = new double[count];
			double sale_carats[] = new double[count];
			double per_ccarats[] = new double[count];
			double sale_ccarats[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setString(1, rlotid);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			int c = 0;
			while (rs_g.next()) {
				lot_id[c] = rs_g.getString("Lot_id");
				lot_no[c] = rs_g.getString("Lot_No");
				c++;
			}
			pstmt_g.close();

			query = "Select * from  Receive_Transaction RT, Receive R where  R.Stock_Date <=?  and R.Company_id=? and R.Active=1 and R.purchase=1 and RT.Active=1 and R.Purchase=1 and RT.Lot_id="
					+ rlotid
					+ " and R.receive_id=RT.receive_id and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id";
			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];

			pstmt_g = con.prepareStatement(query);
			pstmt_g.setDate(1, D1);
			pstmt_g.setString(2, company_id);
			rs_g = pstmt_g.executeQuery();

			c = 0;
			while (rs_g.next()) {

				lotid[c] = rs_g.getString("Lot_id");
				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				dollarprice[c] = rs_g.getDouble("Dollar_Price");

				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");

				c++;
			}
			pstmt_g.close();
			// C.returnConnection(cong);

			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			double rate = 0;
			String status = "";
			int k = 0;
			for (int i = 0; i < counter; i++) {

				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				while (j < count) {
					if ((lot_id[i].equals(lotid[j]))
							& ("1".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {
						tqty_temp = tqty;
						tqty += qty[j];
						tqty = str.mathformat(tqty, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;
						if (0 == (tqty)) {
							localp = 0;
							dollarp = 0;
						} else {

							localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
									/ (tqty_temp + qty[j]);
							dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
									/ (tqty_temp + qty[j]);
						}
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						inwardqty += qty[j];
						closingdqty += tqty;
						inwardtot += temp;
						closingtot += temp1;
						per_carats[i] += qty[j];

					}

					else if ((lot_id[i].equals(lotid[j]))
							& ("0".equals(receive_sell[j]))
							& ("1".equals(purchase[j]))) {

						tqty = tqty - qty[j];
						temp = localprice[j] * qty[j];
						temp1 = localp * tqty;
						outwardqty += qty[j];
						outwardtot += temp;
						closingdqty += tqty;
						closingtot += temp1;
						sale_carats[i] += qty[j];
					}

					j++;
				}
				carats[i] = tqty;

				try {
					new Double("" + localp);
					local_price[i] = localp;
				} catch (Exception e) {
					local_price[i] = 0;
				}
				try {
					new Double("" + dollarp);
					dollar_price[i] = dollarp;
				} catch (Exception e) {
					dollar_price[i] = 0;
				}
				// rate=local_price[i];
			}

			/*
			 * double total=0; double local_total=0; double dollar_total=0;
			 * double dollar_subtotal=0; double local_subtotal=0;
			 */
			for (int i = 0; i < counter; i++) {
				if (rlotid.equals(lot_id[i])) {
					status = "" + carats[i];
					status = status + "/" + local_price[i];
					status = status + "/" + dollar_price[i];

				}
			}

			return status;
		} catch (Exception Samyak109) {// C.returnConnection(cong);
			return "";
		}
		// finally{C.returnConnection(cong); }

	}// Stock Status

	public double getCurrentQty(Connection cn, int lot_id, int location_id,
			java.sql.Date D1, int phyfin)// 1=phy,0=fin
	{
		double returnphyqty = 0;
		double returnfinqty = 0;

		try {
			String query = "Select * from  Receive R, Receive_Transaction RT where  R.Active=1  and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id= ? and RT.Location_Id= ? and R.StockTransfer_Type not like 2 order by R.Stock_Date, R.Receive_Sell, R.Receive_Id,RT.ReceiveTransaction_id";

			pstmt_g = cn.prepareStatement(query);
			// pstmt_g.setString(1,""+D1);
			pstmt_g.setString(1, "" + lot_id);
			pstmt_g.setString(2, "" + location_id);

			rs_g = pstmt_g.executeQuery();
			int count = 0;
			while (rs_g.next()) {
				count++;
			}
			pstmt_g.close();

			// System.out.print("1454 count=" +count);
			String lotid[] = new String[count];
			String purchase[] = new String[count];
			String receive_sell[] = new String[count];
			String returned[] = new String[count];
			double localprice[] = new double[count];
			double dollarprice[] = new double[count];
			double qty[] = new double[count];
			int locationId[] = new int[count];

			pstmt_g = cn.prepareStatement(query);
			// pstmt_g.setString(1,""+D1);
			pstmt_g.setString(1, "" + lot_id);
			pstmt_g.setString(2, "" + location_id);

			rs_g = pstmt_g.executeQuery();
			int c = 0;
			while (rs_g.next()) {

				lotid[c] = rs_g.getString("Lot_id");
				// out.print("&nbsp;lotid[c]="+lotid[c]);

				qty[c] = rs_g.getDouble("Available_Quantity");
				localprice[c] = rs_g.getDouble("Local_Price");
				// out.print("&nbsp;localprice[c]="+localprice[c]);

				dollarprice[c] = rs_g.getDouble("Dollar_Price");
				locationId[c] = rs_g.getInt("Location_id");

				receive_sell[c] = rs_g.getString("receive_sell");
				purchase[c] = rs_g.getString("purchase");
				// out.print("<br>purchase=" +purchase[c]);

				returned[c] = rs_g.getString("R_Return");
				// out.print("&nbsp;&nbsp;receive_sell=" +receive_sell[c]);

				c++;
			}
			pstmt_g.close();

			int j = 0;
			double localp = 0;
			double localp_temp = 0;
			double tqty = 0;
			double tqty_temp = 0;
			double dollarp = 0;
			double dollarp_temp = 0;
			double temp = 0;
			double temp1 = 0;
			double inwardqty = 0;
			double outwardqty = 0;
			double closingdqty = 0;
			double inwardtot = 0;
			double outwardtot = 0;
			double closingtot = 0;
			int k = 0;
			for (int i = 0; i < count; i++) {
				k = 0;
				j = 0;
				localp = 0;
				localp_temp = 0;
				tqty = 0;
				tqty_temp = 0;
				dollarp = 0;
				dollarp_temp = 0;
				temp = 0;
				temp1 = 0;
				inwardqty = 0;
				outwardqty = 0;
				closingdqty = 0;
				inwardtot = 0;
				outwardtot = 0;
				closingtot = 0;
				if (("1".equals(receive_sell[i])) && ("1".equals(purchase[i]))) {
					returnphyqty = returnphyqty + qty[i];
					returnfinqty = returnfinqty + qty[i];
				}// purchase

				else if (("1".equals(receive_sell[i]))
						&& ("0".equals(purchase[i]))
						&& ("0".equals(returned[i]))) {
					returnphyqty = returnphyqty + qty[i];
				}// cgtpurchase

				else if (("0".equals(receive_sell[i]))
						&& ("1".equals(purchase[i]))) {
					returnphyqty = returnphyqty - qty[i];
					returnfinqty = returnfinqty - qty[i];
				}// sales

				else if (("0".equals(receive_sell[i]))
						&& ("0".equals(purchase[i]))
						&& ("0".equals(returned[i]))) {
					returnphyqty = returnphyqty - qty[i];
				}// cgtsale
				k++;
			}
		} catch (Exception e) {
			System.out.println("Exception 1558:: " + e);
		}
		if (phyfin == 1) {
			return returnphyqty;
		} else {
			return returnfinqty;
		}

	}// method

	public double lotRate(Connection con, int lot_id, String location_id,
			java.sql.Date D, String company_id, String reportyearend_id,
			String rateCurrencyType, String rateCalcType) {

		String errLine = "1586";
		double local_price = 0;
		double dollar_price = 0;
		double exchange_rate = 0;
		double rate = 0;
		double localAvgSalep = 0;
		double dollarAvgSalep = 0;
		String lotLocationCondition = "";
		String RTlotLocationCondition = "";

		if (!"0".equals(location_id)) {
			lotLocationCondition = lotLocationCondition + "and RT.Location_Id="
					+ location_id + "";
			RTlotLocationCondition = "and RT2.Location_Id=" + location_id + "";
		}

		try {
			if ("Running".equals(rateCalcType) || "AvgPur".equals(rateCalcType)
					|| "AvgSale".equals(rateCalcType)) {
				double localp = 0;
				double localp_temp = 0;
				double localAvgSalep_temp = 0;
				double tqty = 0;
				double tSaleqty = 0;
				double totalQty = 0;
				double totalSaleQty = 0;
				double tqty_temp = 0;
				double tSaleqty_temp = 0;
				double totalQty_avgPurchase = 0;
				double totalQty_avgSale = 0;
				double tqty_temp_avgPurchase = 0;
				double tqty_temp_avgSale = 0;
				double dollarp = 0;

				double dollarp_temp = 0;
				double dollarAvgSalep_temp = 0;

				String query = "Select RT.ReceiveTransaction_Id,RT.Receive_Id,  RT.Consignment_ReceiveId, R.purchase, R.receive_sell, R.R_Return, R.StockTransfer_Type,R.Opening_Stock, RT.Lot_id, RT.Available_Quantity, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id  and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? and L.lot_Id="
						+ lot_id
						+ " "
						+ lotLocationCondition
						+ " order by L.Lot_Id, R.Stock_Date, R.Receive_Sell desc, R.Receive_Id, RT.ReceiveTransaction_id ";

				//System.out.print("query" + query);

				pstmt_g = con.prepareStatement(query,
						ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				pstmt_g.setString(1, "" + D);
				pstmt_g.setString(2, company_id);
				pstmt_g.setString(3, reportyearend_id);
				// out.print("<br> "+reportyearend_id);

				rs_g = pstmt_g.executeQuery();

				int count = 0;
				rs_g.last();
				count = rs_g.getRow();
				rs_g.beforeFirst();

				long lotid[] = new long[count];
				boolean purchase[] = new boolean[count];
				boolean receive_sell[] = new boolean[count];
				boolean returned[] = new boolean[count];
				boolean opening_stock[] = new boolean[count];
				double localprice[] = new double[count];
				double dollarprice[] = new double[count];
				double qty[] = new double[count];
				double available_qty[] = new double[count];
				long Consignment_ReceiveId[] = new long[count];
				long RT_Id[] = new long[count];
				long R_Id[] = new long[count];
				double rec_total[] = new double[count];
				int stocktransfer_type[] = new int[count];

				errLine = "1644";
				int c = 0;

				while (rs_g.next()) {
					RT_Id[c] = rs_g.getLong("ReceiveTransaction_Id");
					R_Id[c] = rs_g.getLong("Receive_Id");
					Consignment_ReceiveId[c] = rs_g
							.getLong("Consignment_ReceiveId");
					purchase[c] = rs_g.getBoolean("purchase");// b
					receive_sell[c] = rs_g.getBoolean("receive_sell");// b
					// out.print("<br>receive_sell[c]="+receive_sell[c]);
					returned[c] = rs_g.getBoolean("R_Return");// b
					stocktransfer_type[c] = rs_g.getInt("StockTransfer_Type");
					opening_stock[c] = rs_g.getBoolean("Opening_Stock");// b
					lotid[c] = rs_g.getLong("Lot_id");
					// out.print("<br>lotid[c]="+lotid[c]);
					available_qty[c] = rs_g.getDouble("Available_Quantity");
					qty[c] = rs_g.getDouble("Quantity");
					//System.out.println(qty[c]+"#######");
					localprice[c] = rs_g.getDouble("Local_Price");
					dollarprice[c] = rs_g.getDouble("Dollar_Price");
					rec_total[c] = rs_g.getDouble("Receive_Total");
					c++;
				}

				pstmt_g.close();

				errLine = "1658";

				// for all the transactions obtained from the query do
				// calculations for each lot
				int j = 0;
				while (j < c) {
					errLine = "1675";
					// Financial Purcahse/Receive -1 .
					if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] == 0)
							&& (Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);

							}
							// System.out.print("<br>1725 localp"+localp);
							// System.out.print("<br>1726 dollarp"+dollarp);
						}// Running

						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);

							}
						} // AvgPur

						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);

					}

					// Financial Sale.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] == 0)
							&& (Consignment_ReceiveId[j] == 0)) {
						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						totalSaleQty = str.mathformat(totalSaleQty, 3);

						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}
						}// AvgSale

						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);
						// System.out.println("1779
						// localAvgSalep="+localAvgSalep);
						// System.out.println("1780
						// dollarAvgSalep="+dollarAvgSalep);
					} // End Financial Sale.
					// consignment purchase -1
					else if ((receive_sell[j] == true)
							&& (purchase[j] == false) && (returned[j] == false)
							&& (opening_stock[j] == false)) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Sale. -1
					else if (((receive_sell[j] == false)
							&& (purchase[j] == false) && (returned[j] == false) && (opening_stock[j] == false))) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Coinsignment Sale Return.
					else if ((receive_sell[j] == true)
							&& (purchase[j] == false) && (returned[j] == true)) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Sale Confirm -1 .
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (Consignment_ReceiveId[j] != 0)) {

						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];
						totalSaleQty = str.mathformat(totalSaleQty, 3);

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];
						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}

						}
						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);

					}

					// Financial sale return -1 .
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == true)
							&& (opening_stock[j] == false)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);
							}

							// System.out.print("1876 localp"+localp);
							// System.out.print("1877 dollarp"+dollarp);
						}// Running
						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
							}
						}
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}// AvgPur
					// Financial Purchase Return.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == true)
							&& (opening_stock[j] == false)) {
						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}
						}// AvgSale.
						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);

					}
					// Consignment Purchase Return.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == false) && (returned[j] == true)
							&& (opening_stock[j] == false)) {

						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Purchase Confirm.
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == false)
							&& !(Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);
							}
							// System.out.print("1971 localp"+localp);
							// System.out.print("1972 dollarp"+dollarp);
						} // Running

						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
							}

						}
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}
					// opening_stock
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == true)
							&& (Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {

							if ((qty[j]) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);

							}
							// System.out.print("2027 localp"+localp);
							// System.out.print("2028 dollarp"+dollarp);
						} // Running
						if (rateCalcType.equals("AvgPur")) {
							if ((qty[j]) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);

							}
						} // AvgPur
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}

					// Stock Transfer. -1
					if ((purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] != 0)) {
						if (receive_sell[j] == true) {

							tqty_temp = totalQty;
							totalQty += qty[j];
							totalQty = str.mathformat(totalQty, 3);

							tqty_temp_avgPurchase = totalQty_avgPurchase;
							totalQty_avgPurchase += qty[j];
							totalQty_avgPurchase = str.mathformat(
									totalQty_avgPurchase, 3);

							dollarp_temp = dollarp;
							dollarp = 0;
							localp_temp = localp;
							localp = 0;

							if (rateCalcType.equals("Running")) {
								if (0 == (totalQty)) {
									localp = 0;
									dollarp = 0;
								} else {
									if (localp_temp == 0) {
										localp_temp = localprice[j];
									}
									if (dollarp_temp == 0) {
										dollarp_temp = dollarprice[j];
									}

									localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
											/ (tqty_temp + qty[j]);
									dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
											/ (tqty_temp + qty[j]);
								}
								// System.out.print("2083 localp"+localp);
								// System.out.print("2084 dollarp"+dollarp);
							} // Running
							if (rateCalcType.equals("AvgPur")) {
								if (0 == (totalQty_avgPurchase)) {
									localp = 0;
									dollarp = 0;
								} else {

									localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
											/ (tqty_temp_avgPurchase + qty[j]);
									dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
											/ (tqty_temp_avgPurchase + qty[j]);
								}

							} // AvgPur
							localp = Math.abs(localp);
							dollarp = Math.abs(dollarp);
						}
						// AvgSale
						else {
							if (receive_sell[j] == false) {

								totalQty -= qty[j];
								totalQty = str.mathformat(totalQty, 3);

								tSaleqty_temp = totalSaleQty;
								totalSaleQty -= qty[j];
								totalSaleQty = str.mathformat(totalSaleQty, 3);

								tqty_temp_avgSale = totalQty_avgSale;
								totalQty_avgSale += qty[j];
								totalQty_avgSale = str.mathformat(
										totalQty_avgSale, 3);

								dollarAvgSalep_temp = dollarAvgSalep;
								dollarAvgSalep = 0;
								localAvgSalep_temp = localAvgSalep;
								localAvgSalep = 0;

								if (rateCalcType.equals("AvgSale")) {
									if (0 == (totalQty_avgSale)) {
										localAvgSalep = 0;
										dollarAvgSalep = 0;
									} else {

										localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
												/ (tqty_temp_avgSale + qty[j]);
										dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
												/ (tqty_temp_avgSale + qty[j]);
									}
								}// AvgSale

								localAvgSalep = Math.abs(localAvgSalep);
								dollarAvgSalep = Math.abs(dollarAvgSalep);
							}// if
						}

					}// last if close
					j++;
					// System.out.print("2124 dollarp"+dollarp);
					// System.out.print("2125 dollarAvgSalep"+dollarAvgSalep);
				}// end of while
				// code to calculate the data for the last item row

				errLine = "2002";

				local_price = localp;
				dollar_price = dollarp;

			}// end of running and avgpurchase rate calculation
			else if ("PurchaseRate".equals(rateCalcType)) {
				errLine = "2011";
				// String strQuery="SELECT Lot_Id, Purchase_Price FROM
				// Effective_Rate ER1 WHERE Lot_Id IN ( "+lot_id+" ) and
				// Effective_Date IN(SELECT MAX(Effective_Date) FROM
				// Effective_Rate ER2 WHERE Effective_Date <= '"+D+"' and
				// ER1.Lot_Id=ER2.Lot_Id) and Active=1";
				String strQuery = "SELECT Purchase_Price FROM Effective_Rate  WHERE  Effective_Date <= '"
						+ D + "' and Lot_Id=" + lot_id + "  and Active=1";
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Purchase_Price");
				} // end of while
				pstmt_g.close();
				errLine = "2021";

				java.sql.Date startDate = new java.sql.Date(System
						.currentTimeMillis());
				String exrateQuery = "Select exchange_rate from Master_ExchangeRate where exchange_date='"
						+ startDate
						+ "' and yearend_id in (select yearend_id from YearEnd where company_id="
						+ company_id + ")";
				pstmt_g = con.prepareStatement(exrateQuery);
				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					exchange_rate = rs_g.getDouble("exchange_rate");
				}
				pstmt_g.close();
				// System.out.println("exchange_rate="+exchange_rate);

				errLine = "2033";
				local_price = dollar_price * exchange_rate;
			}// end of purchase price calculation
			else if ("SaleRate".equals(rateCalcType)) {
				errLine = "2038";
				// String strQuery="SELECT Lot_Id, Selling_Price FROM
				// Effective_Rate ER1 WHERE Lot_Id IN ( "+lot_id+" ) and
				// Effective_Date IN(SELECT MAX(Effective_Date) FROM
				// Effective_Rate ER2 WHERE Effective_Date <= '"+D+"' and
				// ER1.Lot_Id=ER2.Lot_Id) and Active=1";
				String strQuery = "SELECT Selling_Price FROM Effective_Rate  WHERE  Effective_Date <= '"
						+ D + "' and Lot_Id=" + lot_id + "  and Active=1";
				// System.out.println(strQuery);
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Selling_Price");
				} // end of while
				pstmt_g.close();

				errLine = "2048";
				java.sql.Date startDate = new java.sql.Date(System
						.currentTimeMillis());
				String exrateQuery = "Select exchange_rate from Master_ExchangeRate where exchange_date='"
						+ startDate
						+ "' and yearend_id in (select yearend_id from YearEnd where company_id="
						+ company_id + ")";
				pstmt_g = con.prepareStatement(exrateQuery);
				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					exchange_rate = rs_g.getDouble("exchange_rate");
				}
				pstmt_g.close();

				errLine = "2059";
				local_price = dollar_price * exchange_rate;
			}// end of selling price calculation
			else if ("OpeningRate".equals(rateCalcType)) {
				String query = "Select RT.Local_Price, RT.Dollar_Price from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id and Opening_Stock=1 and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? and L.lot_Id="
						+ lot_id
						+ " "
						+ lotLocationCondition
						+ " order by L.Lot_Id, R.Stock_Date, R.Receive_Sell desc, R.Receive_Id, RT.ReceiveTransaction_id ";
				errLine = "2067";
				// System.out.print("query" + query);

				pstmt_g = con.prepareStatement(query);
				pstmt_g.setString(1, "" + D);
				pstmt_g.setString(2, company_id);
				pstmt_g.setString(3, reportyearend_id);
				// out.print("<br> "+reportyearend_id);

				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					local_price = rs_g.getDouble("Local_Price");
					dollar_price = rs_g.getDouble("Dollar_Price");
				}

				pstmt_g.close();

				errLine = "2084";
			}// end of opening rate calculation
			else if ("LastPurchaseRate".equals(rateCalcType)) {
				errLine = "2093";

				String strQuery = "SELECT  TOP 1 Dollar_Price,Local_Price FROM Receive R, Receive_Transaction RT2 WHERE RT2.Lot_Id ="
						+ lot_id
						+ "  and  R.Stock_Date <= '"
						+ D
						+ "' and R.Receive_Sell=1 and R.Purchase=1 and R.StockTransfer_Type=0 and R.R_Return=0 and  R.Opening_Stock=0  "
						+ RTlotLocationCondition
						+ " and   R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id order by RT2.ReceiveTransaction_Id desc";

				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Dollar_Price");
					local_price = rs_g.getDouble("Local_Price");
				} // end of while
				pstmt_g.close();
				errLine = "2103";
				dollar_price = str.mathformat(dollar_price, 3);
				local_price = str.mathformat(local_price, 3);

			}// end of last purchase price calculation
			else if ("LastSaleRate".equals(rateCalcType)) {
				errLine = "2122";

				String strQuery = "SELECT  TOP 1 Dollar_Price,Local_Price FROM Receive R, Receive_Transaction RT2 WHERE RT2.Lot_Id ="
						+ lot_id
						+ "  and  R.Stock_Date <= '"
						+ D
						+ "' and R.Receive_Sell=0 and R.Purchase=1 and R.StockTransfer_Type=0 and R.R_Return=0 and  R.Opening_Stock=0  "
						+ RTlotLocationCondition
						+ " and   R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id order by RT2.ReceiveTransaction_Id desc";

				// System.out.println("2291tttttttt="+strQuery);
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Dollar_Price");
					local_price = rs_g.getDouble("Local_Price");
				} // end of while
				pstmt_g.close();

				dollar_price = str.mathformat(dollar_price, 3);
				local_price = str.mathformat(local_price, 3);

			}// end of last selling price calculation

		} catch (Exception e) {
			System.out.println("Exception at line:" + errLine
					+ " in lotRate() in Stock.java =" + e);
		}

		if ("AvgSale".equals(rateCalcType)) {
			local_price = Math.abs(localAvgSalep);
			dollar_price = Math.abs(dollarAvgSalep);
		}

		if ("local".equals(rateCurrencyType))
			rate = local_price;
		if ("dollar".equals(rateCurrencyType))
			rate = dollar_price;

		return rate;
	}// end of lotRate
	public String lotRateLocalDollar(Connection con, int lot_id, String location_id,
			java.sql.Date D, String company_id, String reportyearend_id,
			String rateCurrencyType, String rateCalcType) {

		String errLine = "1586";
		double local_price = 0;
		double dollar_price = 0;
		double exchange_rate = 0;
		double local_rate = 0;
		double dollar_rate = 0;
		double localAvgSalep = 0;
		double dollarAvgSalep = 0;
		String lotLocationCondition = "";
		String RTlotLocationCondition = "";

		if (!"0".equals(location_id)) {
			lotLocationCondition = lotLocationCondition + "and RT.Location_Id="
					+ location_id + "";
			RTlotLocationCondition = "and RT2.Location_Id=" + location_id + "";
		}

		try {
			if ("Running".equals(rateCalcType) || "AvgPur".equals(rateCalcType)
					|| "AvgSale".equals(rateCalcType)) {
				double localp = 0;
				double localp_temp = 0;
				double localAvgSalep_temp = 0;
				double tqty = 0;
				double tSaleqty = 0;
				double totalQty = 0;
				double totalSaleQty = 0;
				double tqty_temp = 0;
				double tSaleqty_temp = 0;
				double totalQty_avgPurchase = 0;
				double totalQty_avgSale = 0;
				double tqty_temp_avgPurchase = 0;
				double tqty_temp_avgSale = 0;
				double dollarp = 0;

				double dollarp_temp = 0;
				double dollarAvgSalep_temp = 0;

				String query = "Select RT.ReceiveTransaction_Id,RT.Receive_Id,  RT.Consignment_ReceiveId, R.purchase, R.receive_sell, R.R_Return, R.StockTransfer_Type,R.Opening_Stock, RT.Lot_id, RT.Available_Quantity, RT.Quantity, RT.Local_Price, RT.Dollar_Price, R.Receive_Total from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id  and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? and L.lot_Id="
						+ lot_id
						+ " "
						+ lotLocationCondition
						+ " order by L.Lot_Id, R.Stock_Date, R.Receive_Sell desc, R.Receive_Id, RT.ReceiveTransaction_id ";

				//System.out.print("query" + query);

				pstmt_g = con.prepareStatement(query,
						ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				pstmt_g.setString(1, "" + D);
				pstmt_g.setString(2, company_id);
				pstmt_g.setString(3, reportyearend_id);
				// out.print("<br> "+reportyearend_id);

				rs_g = pstmt_g.executeQuery();

				int count = 0;
				rs_g.last();
				count = rs_g.getRow();
				rs_g.beforeFirst();

				long lotid[] = new long[count];
				boolean purchase[] = new boolean[count];
				boolean receive_sell[] = new boolean[count];
				boolean returned[] = new boolean[count];
				boolean opening_stock[] = new boolean[count];
				double localprice[] = new double[count];
				double dollarprice[] = new double[count];
				double qty[] = new double[count];
				double available_qty[] = new double[count];
				long Consignment_ReceiveId[] = new long[count];
				long RT_Id[] = new long[count];
				long R_Id[] = new long[count];
				double rec_total[] = new double[count];
				int stocktransfer_type[] = new int[count];

				errLine = "1644";
				int c = 0;

				while (rs_g.next()) {
					RT_Id[c] = rs_g.getLong("ReceiveTransaction_Id");
					R_Id[c] = rs_g.getLong("Receive_Id");
					Consignment_ReceiveId[c] = rs_g
							.getLong("Consignment_ReceiveId");
					purchase[c] = rs_g.getBoolean("purchase");// b
					receive_sell[c] = rs_g.getBoolean("receive_sell");// b
					// out.print("<br>receive_sell[c]="+receive_sell[c]);
					returned[c] = rs_g.getBoolean("R_Return");// b
					stocktransfer_type[c] = rs_g.getInt("StockTransfer_Type");
					opening_stock[c] = rs_g.getBoolean("Opening_Stock");// b
					lotid[c] = rs_g.getLong("Lot_id");
					// out.print("<br>lotid[c]="+lotid[c]);
					available_qty[c] = rs_g.getDouble("Available_Quantity");
					qty[c] = rs_g.getDouble("Quantity");
					//System.out.println(qty[c]+"#######");
					localprice[c] = rs_g.getDouble("Local_Price");
					dollarprice[c] = rs_g.getDouble("Dollar_Price");
					rec_total[c] = rs_g.getDouble("Receive_Total");
					c++;
				}

				pstmt_g.close();

				errLine = "1658";

				// for all the transactions obtained from the query do
				// calculations for each lot
				int j = 0;
				while (j < c) {
					errLine = "1675";
					// Financial Purcahse/Receive -1 .
					if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] == 0)
							&& (Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);

							}
							// System.out.print("<br>1725 localp"+localp);
							// System.out.print("<br>1726 dollarp"+dollarp);
						}// Running

						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);

							}
						} // AvgPur

						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);

					}

					// Financial Sale.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] == 0)
							&& (Consignment_ReceiveId[j] == 0)) {
						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						totalSaleQty = str.mathformat(totalSaleQty, 3);

						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}
						}// AvgSale

						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);
						// System.out.println("1779
						// localAvgSalep="+localAvgSalep);
						// System.out.println("1780
						// dollarAvgSalep="+dollarAvgSalep);
					} // End Financial Sale.
					// consignment purchase -1
					else if ((receive_sell[j] == true)
							&& (purchase[j] == false) && (returned[j] == false)
							&& (opening_stock[j] == false)) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Sale. -1
					else if (((receive_sell[j] == false)
							&& (purchase[j] == false) && (returned[j] == false) && (opening_stock[j] == false))) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Coinsignment Sale Return.
					else if ((receive_sell[j] == true)
							&& (purchase[j] == false) && (returned[j] == true)) {
						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Sale Confirm -1 .
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (Consignment_ReceiveId[j] != 0)) {

						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];
						totalSaleQty = str.mathformat(totalSaleQty, 3);

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];
						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}

						}
						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);

					}

					// Financial sale return -1 .
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == true)
							&& (opening_stock[j] == false)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);
							}

							// System.out.print("1876 localp"+localp);
							// System.out.print("1877 dollarp"+dollarp);
						}// Running
						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
							}
						}
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}// AvgPur
					// Financial Purchase Return.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == true) && (returned[j] == true)
							&& (opening_stock[j] == false)) {
						totalQty -= qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tSaleqty_temp = totalSaleQty;
						totalSaleQty -= qty[j];

						tqty_temp_avgSale = totalQty_avgSale;
						totalQty_avgSale += qty[j];

						totalQty = str.mathformat(totalQty, 3);
						totalQty_avgSale = str.mathformat(totalQty_avgSale, 3);

						dollarAvgSalep_temp = dollarAvgSalep;
						dollarAvgSalep = 0;
						localAvgSalep_temp = localAvgSalep;
						localAvgSalep = 0;

						if (rateCalcType.equals("AvgSale")) {
							if ((totalQty_avgSale) == 0) {
								localAvgSalep = 0;
								dollarAvgSalep = 0;
							} else {
								localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
								dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgSale + qty[j]);
							}
						}// AvgSale.
						localAvgSalep = Math.abs(localAvgSalep);
						dollarAvgSalep = Math.abs(dollarAvgSalep);

					}
					// Consignment Purchase Return.
					else if ((receive_sell[j] == false)
							&& (purchase[j] == false) && (returned[j] == true)
							&& (opening_stock[j] == false)) {

						totalQty = str.mathformat(totalQty, 3);
					}

					// Consignment Purchase Confirm.
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == false)
							&& !(Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {
							if ((totalQty) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);
							}
							// System.out.print("1971 localp"+localp);
							// System.out.print("1972 dollarp"+dollarp);
						} // Running

						if (rateCalcType.equals("AvgPur")) {
							if ((totalQty_avgPurchase) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
							}

						}
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}
					// opening_stock
					else if ((receive_sell[j] == true) && (purchase[j] == true)
							&& (returned[j] == false)
							&& (opening_stock[j] == true)
							&& (Consignment_ReceiveId[j] == 0)) {
						tqty_temp = totalQty;
						totalQty += qty[j];
						totalQty = str.mathformat(totalQty, 3);

						tqty_temp_avgPurchase = totalQty_avgPurchase;
						totalQty_avgPurchase += qty[j];
						totalQty_avgPurchase = str.mathformat(
								totalQty_avgPurchase, 3);

						dollarp_temp = dollarp;
						dollarp = 0;
						localp_temp = localp;
						localp = 0;

						if (rateCalcType.equals("Running")) {

							if ((qty[j]) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								if (localp_temp == 0) {
									localp_temp = localprice[j];
								}
								if (dollarp_temp == 0) {
									dollarp_temp = dollarprice[j];
								}

								localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
										/ (tqty_temp + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
										/ (tqty_temp + qty[j]);

							}
							// System.out.print("2027 localp"+localp);
							// System.out.print("2028 dollarp"+dollarp);
						} // Running
						if (rateCalcType.equals("AvgPur")) {
							if ((qty[j]) == 0) {
								localp = 0;
								dollarp = 0;
							} else {
								localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);
								dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
										/ (tqty_temp_avgPurchase + qty[j]);

							}
						} // AvgPur
						localp = Math.abs(localp);
						dollarp = Math.abs(dollarp);
					}

					// Stock Transfer. -1
					if ((purchase[j] == true) && (returned[j] == false)
							&& (opening_stock[j] == false)
							&& (stocktransfer_type[j] != 0)) {
						if (receive_sell[j] == true) {

							tqty_temp = totalQty;
							totalQty += qty[j];
							totalQty = str.mathformat(totalQty, 3);

							tqty_temp_avgPurchase = totalQty_avgPurchase;
							totalQty_avgPurchase += qty[j];
							totalQty_avgPurchase = str.mathformat(
									totalQty_avgPurchase, 3);

							dollarp_temp = dollarp;
							dollarp = 0;
							localp_temp = localp;
							localp = 0;

							if (rateCalcType.equals("Running")) {
								if (0 == (totalQty)) {
									localp = 0;
									dollarp = 0;
								} else {
									if (localp_temp == 0) {
										localp_temp = localprice[j];
									}
									if (dollarp_temp == 0) {
										dollarp_temp = dollarprice[j];
									}

									localp = ((localp_temp * tqty_temp) + (qty[j] * localprice[j]))
											/ (tqty_temp + qty[j]);
									dollarp = ((dollarp_temp * tqty_temp) + (qty[j] * dollarprice[j]))
											/ (tqty_temp + qty[j]);
								}
								// System.out.print("2083 localp"+localp);
								// System.out.print("2084 dollarp"+dollarp);
							} // Running
							if (rateCalcType.equals("AvgPur")) {
								if (0 == (totalQty_avgPurchase)) {
									localp = 0;
									dollarp = 0;
								} else {

									localp = ((localp_temp * tqty_temp_avgPurchase) + (qty[j] * localprice[j]))
											/ (tqty_temp_avgPurchase + qty[j]);
									dollarp = ((dollarp_temp * tqty_temp_avgPurchase) + (qty[j] * dollarprice[j]))
											/ (tqty_temp_avgPurchase + qty[j]);
								}

							} // AvgPur
							localp = Math.abs(localp);
							dollarp = Math.abs(dollarp);
						}
						// AvgSale
						else {
							if (receive_sell[j] == false) {

								totalQty -= qty[j];
								totalQty = str.mathformat(totalQty, 3);

								tSaleqty_temp = totalSaleQty;
								totalSaleQty -= qty[j];
								totalSaleQty = str.mathformat(totalSaleQty, 3);

								tqty_temp_avgSale = totalQty_avgSale;
								totalQty_avgSale += qty[j];
								totalQty_avgSale = str.mathformat(
										totalQty_avgSale, 3);

								dollarAvgSalep_temp = dollarAvgSalep;
								dollarAvgSalep = 0;
								localAvgSalep_temp = localAvgSalep;
								localAvgSalep = 0;

								if (rateCalcType.equals("AvgSale")) {
									if (0 == (totalQty_avgSale)) {
										localAvgSalep = 0;
										dollarAvgSalep = 0;
									} else {

										localAvgSalep = ((localAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * localprice[j]))
												/ (tqty_temp_avgSale + qty[j]);
										dollarAvgSalep = ((dollarAvgSalep_temp * tqty_temp_avgSale) + (qty[j] * dollarprice[j]))
												/ (tqty_temp_avgSale + qty[j]);
									}
								}// AvgSale

								localAvgSalep = Math.abs(localAvgSalep);
								dollarAvgSalep = Math.abs(dollarAvgSalep);
							}// if
						}

					}// last if close
					j++;
					// System.out.print("2124 dollarp"+dollarp);
					// System.out.print("2125 dollarAvgSalep"+dollarAvgSalep);
				}// end of while
				// code to calculate the data for the last item row

				errLine = "2002";

				local_price = localp;
				dollar_price = dollarp;

			}// end of running and avgpurchase rate calculation
			else if ("PurchaseRate".equals(rateCalcType)) {
				errLine = "2011";
				// String strQuery="SELECT Lot_Id, Purchase_Price FROM
				// Effective_Rate ER1 WHERE Lot_Id IN ( "+lot_id+" ) and
				// Effective_Date IN(SELECT MAX(Effective_Date) FROM
				// Effective_Rate ER2 WHERE Effective_Date <= '"+D+"' and
				// ER1.Lot_Id=ER2.Lot_Id) and Active=1";
				String strQuery = "SELECT Purchase_Price FROM Effective_Rate  WHERE  Effective_Date <= '"
						+ D + "' and Lot_Id=" + lot_id + "  and Active=1";
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Purchase_Price");
				} // end of while
				pstmt_g.close();
				errLine = "2021";

				java.sql.Date startDate = new java.sql.Date(System
						.currentTimeMillis());
				String exrateQuery = "Select exchange_rate from Master_ExchangeRate where exchange_date='"
						+ startDate
						+ "' and yearend_id in (select yearend_id from YearEnd where company_id="
						+ company_id + ")";
				pstmt_g = con.prepareStatement(exrateQuery);
				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					exchange_rate = rs_g.getDouble("exchange_rate");
				}
				pstmt_g.close();
				// System.out.println("exchange_rate="+exchange_rate);

				errLine = "2033";
				local_price = dollar_price * exchange_rate;
			}// end of purchase price calculation
			else if ("SaleRate".equals(rateCalcType)) {
				errLine = "2038";
				// String strQuery="SELECT Lot_Id, Selling_Price FROM
				// Effective_Rate ER1 WHERE Lot_Id IN ( "+lot_id+" ) and
				// Effective_Date IN(SELECT MAX(Effective_Date) FROM
				// Effective_Rate ER2 WHERE Effective_Date <= '"+D+"' and
				// ER1.Lot_Id=ER2.Lot_Id) and Active=1";
				String strQuery = "SELECT Selling_Price FROM Effective_Rate  WHERE  Effective_Date <= '"
						+ D + "' and Lot_Id=" + lot_id + "  and Active=1";
				// System.out.println(strQuery);
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Selling_Price");
				} // end of while
				pstmt_g.close();

				errLine = "2048";
				java.sql.Date startDate = new java.sql.Date(System
						.currentTimeMillis());
				String exrateQuery = "Select exchange_rate from Master_ExchangeRate where exchange_date='"
						+ startDate
						+ "' and yearend_id in (select yearend_id from YearEnd where company_id="
						+ company_id + ")";
				pstmt_g = con.prepareStatement(exrateQuery);
				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					exchange_rate = rs_g.getDouble("exchange_rate");
				}
				pstmt_g.close();

				errLine = "2059";
				local_price = dollar_price * exchange_rate;
			}// end of selling price calculation
			else if ("OpeningRate".equals(rateCalcType)) {
				String query = "Select RT.Local_Price, RT.Dollar_Price from  Receive R, Receive_Transaction RT, Lot L where R.Stock_Date <= ?  and R.Company_id=? and R.Active=1 and RT.Active=1 and R.receive_id=RT.receive_id and RT.Lot_Id = L.Lot_Id and Opening_Stock=1 and ( (R.StockTransfer_Type not like 2) OR (R.StockTransfer_Type=2 and SalesPerson_Id = -1) ) and L.active =1 and R.yearend_id = ? and L.lot_Id="
						+ lot_id
						+ " "
						+ lotLocationCondition
						+ " order by L.Lot_Id, R.Stock_Date, R.Receive_Sell desc, R.Receive_Id, RT.ReceiveTransaction_id ";
				errLine = "2067";
				// System.out.print("query" + query);

				pstmt_g = con.prepareStatement(query);
				pstmt_g.setString(1, "" + D);
				pstmt_g.setString(2, company_id);
				pstmt_g.setString(3, reportyearend_id);
				// out.print("<br> "+reportyearend_id);

				rs_g = pstmt_g.executeQuery();

				while (rs_g.next()) {
					local_price = rs_g.getDouble("Local_Price");
					dollar_price = rs_g.getDouble("Dollar_Price");
				}

				pstmt_g.close();

				errLine = "2084";
			}// end of opening rate calculation
			else if ("LastPurchaseRate".equals(rateCalcType)) {
				errLine = "2093";

				String strQuery = "SELECT  TOP 1 Dollar_Price,Local_Price FROM Receive R, Receive_Transaction RT2 WHERE RT2.Lot_Id ="
						+ lot_id
						+ "  and  R.Stock_Date <= '"
						+ D
						+ "' and R.Receive_Sell=1 and R.Purchase=1 and R.StockTransfer_Type=0 and R.R_Return=0 and  R.Opening_Stock=0  "
						+ RTlotLocationCondition
						+ " and   R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id order by RT2.ReceiveTransaction_Id desc";

				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Dollar_Price");
					local_price = rs_g.getDouble("Local_Price");
				} // end of while
				pstmt_g.close();
				errLine = "2103";
				dollar_price = str.mathformat(dollar_price, 3);
				local_price = str.mathformat(local_price, 3);

			}// end of last purchase price calculation
			else if ("LastSaleRate".equals(rateCalcType)) {
				errLine = "2122";

				String strQuery = "SELECT  TOP 1 Dollar_Price,Local_Price FROM Receive R, Receive_Transaction RT2 WHERE RT2.Lot_Id ="
						+ lot_id
						+ "  and  R.Stock_Date <= '"
						+ D
						+ "' and R.Receive_Sell=0 and R.Purchase=1 and R.StockTransfer_Type=0 and R.R_Return=0 and  R.Opening_Stock=0  "
						+ RTlotLocationCondition
						+ " and   R.Active=1 and RT2.Active=1 and R.Receive_Id=RT2.Receive_Id order by RT2.ReceiveTransaction_Id desc";

				// System.out.println("2291tttttttt="+strQuery);
				pstmt_g = con.prepareStatement(strQuery);
				rs_g = pstmt_g.executeQuery();
				while (rs_g.next()) {
					dollar_price = rs_g.getDouble("Dollar_Price");
					local_price = rs_g.getDouble("Local_Price");
				} // end of while
				pstmt_g.close();

				dollar_price = str.mathformat(dollar_price, 3);
				local_price = str.mathformat(local_price, 3);

			}// end of last selling price calculation

		} catch (Exception e) {
			System.out.println("Exception at line:" + errLine
					+ " in lotRate() in Stock.java =" + e);
		}

		if ("AvgSale".equals(rateCalcType)) {
			local_price = Math.abs(localAvgSalep);
			dollar_price = Math.abs(dollarAvgSalep);
		}

		if ("both".equals(rateCurrencyType))
		{
			local_rate = local_price;
			dollar_rate = dollar_price;
		}
		
		return local_rate+"#"+dollar_rate;
	}// end of lotRate

	public static void main(String[] args) throws Exception {

		Stock l = new Stock();

	}
}
