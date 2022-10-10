using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
/// <summary>
/// UI element consisting of a name and a slider used to change character shapes
/// </summary>
public class HumanBodyGeneratorParameterUIItem : MonoBehaviour
{
    
	public Text parameterNameLabel;
	public Slider parameterValueSlider;
	public Text parameterValueLabel;
	public string parameterPrefixToOmit = "";
	private int id = 0;

	HumanBodyGenerator generator;
	HumanBodyGenerator.HumanShapeParameterClass obj;

	public void SetGenerator(HumanBodyGenerator gen)
	{
		generator = gen;
		//Debug.Log("my generator ise set");
	}

	public int GetId()
	{
		return id;
	}
	
	/// <summary>
	/// setting up UI item
	/// </summary>
	/// <param name="index">blendshape index</param>
	/// <param name="o">parametenin kendisi (adi, degeri)</param>
	/// <param name="useFriendlyName">show friendly name in UI or not</param>
	public void SetupUIItem(int index, HumanBodyGenerator.HumanShapeParameterClass o, bool useFriendlyName)
	{
		obj = o;
		id = index;
		//parameterNameLabel.text = obj.parameterName.Remove(0,parameterPrefixToOmit.Length);
		if(useFriendlyName)
		{
			parameterNameLabel.resizeTextForBestFit = false;
			parameterNameLabel.text = obj.friendlyName;
		}
			
		else
		{
			parameterNameLabel.resizeTextForBestFit = true;
			parameterNameLabel.text = obj.parameterName;
		}
			
			
			
		parameterValueSlider.value = obj.value;
		parameterValueLabel.text = obj.value.ToString("F2");
	}
	
	
	/// <summary>
	/// blend shape value changed, change texts and inform generator about the change
	/// </summary>
	public void ValueChanged()
	{
		float val = parameterValueSlider.value;
		parameterValueLabel.text = val.ToString("F2");
		generator.SetBlendShapeWeight(id, val);
	}
	
	/// <summary>
	/// reset shape to default
	/// </summary>
	public void ResetToDefault()
	{
		float val = obj.defaultValue;
		generator.SetBlendShapeWeightToDefault(id);
		if(Input.GetKey(KeyCode.LeftControl))
		{
			val = 0;
			generator.SetBlendShapeWeight(id, val);
		}
		
		
		
		parameterValueSlider.value = val;
		parameterValueLabel.text = val.ToString("F2");
	}

}
