using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFocusBodyPart : MonoBehaviour
{
    
	[System.Serializable]
	public class BlendShapeFilterGroup
	{
		public string groupName = "Body Part";
		public string[] blendShapeFilter;	
	}
	
	
	public BlendShapeFilterGroup[] blendShapeGroup;
	// Start is called before the first frame update
	/*void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
	}*/
}
