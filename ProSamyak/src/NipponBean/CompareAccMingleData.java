package NipponBean;

import java.util.*;
import java.sql.*;
import NipponBean.*;

public class CompareAccMingleData implements Comparator
{
	public int compare(Object obj1,Object obj2)
	{
		int compared = 0;
	
			java.sql.Date compareColValue1 =  ((AccountMingleDataDisplay)obj1).getGressDueDate();
		
			java.sql.Date compareColValue2 =  ((AccountMingleDataDisplay)obj2).getGressDueDate();

			//comparing in descending order
			compared =	(compareColValue1).compareTo(compareColValue2);
		return compared;
	}
};
