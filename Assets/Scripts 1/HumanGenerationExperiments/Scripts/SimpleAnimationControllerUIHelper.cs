using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class SimpleAnimationControllerUIHelper : MonoBehaviour
{
	public SimpleAnimationController animationController;
	public Dropdown animationListDropdown;
	
	
	// Start is called before the first frame update
    void Start()
    {
	    SetupAnimationParameterList();
    }
    
	public void SwitchToAnimation(int index)
	{
		animationController.SwitchToAnimationBool(index - 1);
	}

	void SetupAnimationParameterList()
	{
		if(animationController == null) return;
		
		animationListDropdown.ClearOptions();
		
		List<string> options = new List<string>();
		
		options.Add("Idle");
		
		
		for(int i = 0; i < animationController.parameters.Length; i++)
		{
			//OptionDa
			options.Add(animationController.parameters[i].name);
		}
		animationListDropdown.AddOptions(options);
		animationListDropdown.value = 0;
	}
}
