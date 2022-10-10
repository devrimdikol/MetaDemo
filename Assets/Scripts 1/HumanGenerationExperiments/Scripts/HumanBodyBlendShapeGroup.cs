using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanBodyBlendShapeGroup : MonoBehaviour
{
    
	public HumanBodyGenerator.Gender gender = HumanBodyGenerator.Gender.Female; 
	[System.Serializable]
	public class BlendShapeFilterGroup
	{
		public string groupName = "Body Part";
		public string[] blendShapeFilter;	
	}
	
	
	public BlendShapeFilterGroup[] blendShapeGroup;

}
