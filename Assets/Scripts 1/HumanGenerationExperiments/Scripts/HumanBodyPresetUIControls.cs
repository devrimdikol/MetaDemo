using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanBodyPresetUIControls : MonoBehaviour
{
	[HideInInspector]
	public string groupName;
	HumanBodyGeneratorUIHelper owner;
	// Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
	public void SetupTitle(string name, HumanBodyGeneratorUIHelper _owner)
	{
		groupName = name;
		owner = _owner;
	}
    
	public void SavePreset()
	{
		owner.SaveBodyPreset(groupName);
	}
}
