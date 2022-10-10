using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class CameraFocusManagerUIHelper : MonoBehaviour
{
	public CameraFocusManager cameraFocusManager;
	public Button[] focusButtons;
	
	int prevTarget;
	
	bool firstFrame = true;
	// Start is called before the first frame update
    void Start()
    {
        
    }


	void SetButtonHighlights()
	{
		int activeIndex = cameraFocusManager.GetTargetIndex();
		for(int i = 0; i < focusButtons.Length; i++)
		{
			if(i == activeIndex)
				focusButtons[i].GetComponent<Image>().color = Color.white;
			else
				focusButtons[i].GetComponent<Image>().color = new Color(1,1,1,0);
		}
	}

    // Update is called once per frame
    void Update()
    {
	    if(firstFrame)
	    {
	    	firstFrame = false;
	    	prevTarget = cameraFocusManager.GetTargetIndex();
	    	SetButtonHighlights();
	    	return;
	    }
	    
	    
	    if(prevTarget != cameraFocusManager.GetTargetIndex())
	    {
	    	SetButtonHighlights();
	    }
	    
	    
    }
    
	void LateUpdate()
	{
		prevTarget = cameraFocusManager.GetTargetIndex();
	}
}
