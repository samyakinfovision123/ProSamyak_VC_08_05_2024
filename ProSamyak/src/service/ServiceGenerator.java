package service;

import java.util.Hashtable;


/**
 * This class is used to generate instance of Action Class.
 * @author Manoj
*  SRL			start		12-07-2010		Shital - Rupesh - Lotan
*
**/
public class ServiceGenerator 
{
	private Hashtable actions = new Hashtable();
	
	public SamYakActInterface getClassInstance(String className,ClassLoader loader) throws ClassNotFoundException, IllegalAccessException, InstantiationException
	{
		System.out.println("actions:"+actions);
		SamYakActInterface action= (SamYakActInterface)actions.get(className);
		System.out.println("action:"+action);
		if(action == null){
			Class actionClass = loader.loadClass(className);
			System.out.println("actionClass1:"+actionClass);
			action = (SamYakActInterface)actionClass.newInstance();
			actions.put(className,action);
		}
		return action;
	}
}
