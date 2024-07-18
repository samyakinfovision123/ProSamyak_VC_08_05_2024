
//	written	by Tan Ling	Wee	on 2 Dec 2001
//	last updated 20 June 2003
//	email :	fuushikaden@yahoo.com

	var prevdate="";
	 
	function checkMe(ele)
	{
		
		v=ele.value;
		if(v.length>=11)
		{
			alert("Invalid");
			ele.value=v.substr(0,(v.length-1));
		}
		else
		{
			for(i=0;i<v.length;i++)
			{	
				c=v.charCodeAt(i);
				//alert(c);
				if(((c>=48 && c<=57) || c==47 ))
				{
					if(c==47)
					{
			
					}
					else
					{
						if((v.length==2)&& v.lastIndexOf("/")==-1)
						{
							v=v+"/";
							ele.value=v;
							prevdate=v;
						}
						if((v.length==5) && v.lastIndexOf("/")==2)
						{
							var current_date=new Date();
							v=v+"/"+current_date.getYear();
							ele.value=v;
							prevdate=v;
						}
					}
				} //if
				else
				{
					var str1=v.substr(0,i);
					var str2=v.substr(i+1,(v.length-1));
					var s=prevdate.charAt(i);
					ele.value=str1+s+str2;
				} //else
			} //for	
		} //else
	}