using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanBodyBlendShapeGroupManager : MonoBehaviour
{
	public HumanBodyBlendShapeGroup[] blendShapeGroups;
	public HumanBodyGeneratorUIHelper uiHelper;
	public CameraFocusManager cameraFocusManager;
	
	bool firstFrame = true;
	
	int activeGroupIndex = 0;
	// Start is called before the first frame update
    void Start()
    {
	    
    }

    // Update is called once per frame
	void LateUpdate()
    {
	    if(firstFrame)
	    {
	    	firstFrame = false;
	    	SetUIParameterList(0);
	    }
	    
	    if(Input.GetKeyUp("2"))
	    	SetUIParameterList((activeGroupIndex + 1) % blendShapeGroups.Length);
    }
    
    
	public void SetUIParameterList(int index)
	{
		uiHelper.FilterByBlendShapeGroup(blendShapeGroups[index]);
		
		if(cameraFocusManager != null)
			cameraFocusManager.SetTarget(index);
		
		activeGroupIndex = index;
	}
}
