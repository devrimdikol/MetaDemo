using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class StringOperations
{
    // Start is called before the first frame update
	public static bool BackwardsStringContains(string s1, string s2)
	{
		
		s1 = s1.ToLower();
		s2 = s2.ToLower();
		
		
		//Debug.Log(s1 + " --- " + s2);
		int index = s2.Length-1;
		for(int i = s1.Length-1; i >= 0; i--)
		{
			//Debug.Log(i + ".harfler " + s1[i] + "-" + s2[index]);
			
			if(s1[i] != s2[index])
				return false;
				
			index--;
		}
		
		return true;
	}
}
