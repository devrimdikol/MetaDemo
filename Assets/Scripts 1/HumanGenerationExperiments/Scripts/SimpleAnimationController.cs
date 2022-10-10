using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEditor.Animations;


public class SimpleAnimationController : MonoBehaviour
{
	public Animator[] animators;
	//public AnimatorController animationController;
	
	
	public string startingAnimationBoolName = "";
	
	[HideInInspector]
	public AnimatorControllerParameter[] parameters;
	
	
	bool switchingAnimation = false;
	int activeIndex = 0;
	// Start is called before the first frame update
	void Awake()
    {
	    //animator.runtimeAnimatorController = animationController;
	    //parameters = animationController.parameters;
	    
	    if(startingAnimationBoolName != "")
	    {
	    	for(int i = 0; i < parameters.Length; i++)
	    	{
	    		//Debug.Log(parameters[i].name);
	    		if(parameters[i].name == startingAnimationBoolName)
	    		{
	    			SwitchToAnimationBool(i);
	    			break;
	    		}
	    			
	    	}
	    }
	    //SwitchToAnimationBool(-1);
    }

    // Update is called once per frame
	void Update()
    {
	    //if(Input.GetKeyUp("3"))
	    //	SwitchToAnimationBool( ((activeIndex+1) % parameters.Length) - 1);
    }
	
    

	IEnumerator SwitchToAnimationBoolCoroutine(int index)
	{
		if(!switchingAnimation)
		{
			switchingAnimation = true;
			for(int j = 0; j < animators.Length; j++)
			{
				
				if(animators[j] == null) continue;
				
				for(int i = 0; i < parameters.Length; i++)
				{
					animators[j].SetBool(parameters[i].name, false);
				}
			
				yield return new WaitForSeconds(0.3f);
				if(index >= 0)
					animators[j].SetBool(parameters[index].name, true);
			}
			
		
			switchingAnimation = false;
			activeIndex = index+1;
		}
		
		
	}
	public void SwitchToAnimationBool(int index)
	{
		//Debug.Log(index);
		if(!switchingAnimation)
			StartCoroutine(SwitchToAnimationBoolCoroutine(index));
	}
    
	/*void OnGUI()
	{
		for(int i = 0; i < parameters.Length; i++)
		{
			if(GUI.Button(new Rect(20, 50*i, 100,30), parameters[i].name))
			{
				SwitchToAnimationBool(i);
			}
			//GUI.Label(new Rect(20, 50*i + 20, 100,30), parameters[i].type.ToString());
		}
	}*/
}
