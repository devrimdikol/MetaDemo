using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
/// <summary>
/// human body generator icin UI helper
/// </summary>
public class HumanBodyGeneratorUIHelper : MonoBehaviour
{
    
	public HumanBodyGenerator generator;
	public HumanBodySkinManager skinManager;
	public HumanBodySimpleMakeup makeupManager;
	public HumanBodyHairManager hairManager;
	public HumanBodyPresetManager presetManager;
	public GameObject UIItem;
	public Transform listParent;
	public Slider randomForceSlider;
	public Toggle showFriendlyNamesOnList;
	public Dropdown skinSelectionDropDown;
	public Dropdown makeupSelectionDropDown;
	public Dropdown hairSelectionDropDown;
	public Text randomForceLabel;
	public Text[] blendGroupTitleTexts;
	private List<GameObject> uiItems;
	private Canvas canvas;
	public GameObject debugPanel;
	// Start is called before the first frame update
	
	
	
	int debugPanelCounter = 0;
	
    void Start()
    {
	    canvas = GetComponent<Canvas>();
	    SetupMorphParameterList();
	    SetupSkinListUI();
	    //SetupMakeupListUI();
	    //SetupHairListUI();
	    generator.shapeListUpdatedEvent.AddListener(SetupMorphParameterList);
    }
    
	/// <summary>
	/// filtering UI objects based on body parts
	/// </summary>
	/// <param name="part"></param>
	public void FilterByBlendShapeGroup(HumanBodyBlendShapeGroup part)
	{
		
		FilterMorphParameterList("nowaythereisablendshapenamedlikethisbitch", false);
		
		for(int i = 0; i < blendGroupTitleTexts.Length; i++)
		{
			blendGroupTitleTexts[i].gameObject.SetActive(false);
		}
		
		
		int itemIndex = 0;
		int titleIndex = 0;
		for(int i = 0; i < part.blendShapeGroup.Length; i++)
		{
			//title
			blendGroupTitleTexts[titleIndex].gameObject.SetActive(true);
			blendGroupTitleTexts[titleIndex].text = part.blendShapeGroup[i].groupName;
			
			blendGroupTitleTexts[titleIndex].GetComponent<RectTransform>().SetSiblingIndex(itemIndex);
			
			blendGroupTitleTexts[titleIndex].gameObject.GetComponent<HumanBodyPresetUIControls>().SetupTitle(part.blendShapeGroup[i].groupName,this);
			
			itemIndex++;
			titleIndex++;
			
			//parameters
			for(int j = 0; j < part.blendShapeGroup[i].blendShapeFilter.Length; j++)
			{
				
				for(int k = 0; k < generator.shapeList.Count; k++)
				{
					if(StringOperations.BackwardsStringContains(part.blendShapeGroup[i].blendShapeFilter[j], generator.shapeList[k].parameterName))
					{
						uiItems[k].SetActive(true);
						uiItems[k].GetComponent<RectTransform>().SetSiblingIndex(itemIndex);
						itemIndex++;
					}
				}
			}
		}
	}
	
	
	
	/// <summary>
	/// populate available hair list for characters and put to UI?
	/// </summary>
	void SetupHairListUI()
	{
		hairSelectionDropDown.ClearOptions();
		
		List<string> options = new List<string>();
		
		options.Add("No Hair");
		
		for(int i = 0; i < hairManager.hairObjects.Length; i++)
		{
			if(hairManager.hairObjects[i] != null)
				options.Add(hairManager.hairObjects[i].name);
		}
			
	
		hairSelectionDropDown.AddOptions(options);
		hairSelectionDropDown.value = 0;
	}
	
	/// <summary>
	/// populate available makeup list for characters and put to UI?
	/// </summary>
	void SetupMakeupListUI()
	{
		makeupSelectionDropDown.ClearOptions();
		
		List<string> options = new List<string>();
		
		options.Add("No Makeup");
		
		for(int i = 0; i < makeupManager.makeUpList.Length; i++)
			options.Add(makeupManager.makeUpList[i].name);

		makeupSelectionDropDown.AddOptions(options);
		makeupSelectionDropDown.value = 0;
	}
	
	
    
	/// <summary>
	/// populate available skin list for characters and put to UI?
	/// </summary>
	void SetupSkinListUI()
	{
		skinSelectionDropDown.ClearOptions();
		
		List<string> options = new List<string>();
		
		//options.Add("No Makeup");
		
		for(int i = 0; i < skinManager.skinPacks.Length; i++)
		{
			options.Add(skinManager.skinPacks[i].packName);
		}
		skinSelectionDropDown.AddOptions(options);
		skinSelectionDropDown.value = 0;
	}
    
	/// <summary>
	/// randomize active selected shapes with some force
	/// </summary>
	public void RandomizeAll()
	{
		List<int> randomizerList = new List<int>();
		
		for(int i = 0; i < generator.shapeList.Count; i++)
		{
			if(generator.shapeList[i].inWhiteList && uiItems[i].gameObject.activeSelf)
			{
				randomizerList.Add(i);
			}		
		}
		
		generator.RandomizeAll(randomizerList,randomForceSlider.value);
		UpdateListValues();
		
		randomizerList.Clear();
		randomizerList = null;
	}
	
	/// <summary>
	/// random force slider changed, update text accordingly
	/// </summary>
	public void RandomForceChanged()
	{
		randomForceLabel.text = randomForceSlider.value.ToString("F2");
	}
    
	public void UpdateListValues()
	{
		for(int i = 0; i < generator.shapeList.Count; i++)
		{
			uiItems[i].GetComponent<HumanBodyGeneratorParameterUIItem>().SetupUIItem(i, generator.shapeList[i],showFriendlyNamesOnList.isOn);
		}
	}
    
    
	/// <summary>
	/// populates all parameters list in ui
	/// </summary>
	public void SetupMorphParameterList()
	{
		if(uiItems == null) uiItems = new List<GameObject>();
		
		for(int i = 0; i < uiItems.Count; i++)
			DestroyImmediate(uiItems[i]);
		
		uiItems.Clear();
		
		for(int i = 0; i < generator.shapeList.Count; i++)
		{
			GameObject go = Instantiate(UIItem);
			go.GetComponent<HumanBodyGeneratorParameterUIItem>().SetGenerator(generator);
			go.GetComponent<HumanBodyGeneratorParameterUIItem>().SetupUIItem(i, generator.shapeList[i], true);
			
			go.transform.parent = listParent;
			
			//if(i < 60)
			go.SetActive(true);
			
			if(!generator.shapeList[i].inWhiteList) go.SetActive(false);

			uiItems.Add(go);
		}
	}



	/// <summary>
	/// filtering UI parameter list
	/// </summary>
	/// <param name="filter">filter string</param>
	/// <param name="appendMode">ya bu sikko, gidecek</param>
	public void FilterMorphParameterList(string filter, bool appendMode)
	{
		for(int i = 0; i < generator.shapeList.Count; i++)
		{
			if(filter=="")
			{
				uiItems[i].SetActive(true);
				if(!generator.shapeList[i].inWhiteList)
					uiItems[i].SetActive(false);
				continue;
			}
			
			//if(generator.shapeList[i].parameterName.ToUpper().Contains(filter.ToUpper()))
			if(StringOperations.BackwardsStringContains(filter, generator.shapeList[i].parameterName))
				uiItems[i].SetActive(true);
			else
				uiItems[i].SetActive(false);
				
				
			if(!generator.shapeList[i].inWhiteList)
			{
				//Debug.Log(generator.shapeList[i].parameterName + " not in whitelist");
				uiItems[i].SetActive(false);
			}
				
		}
	}
	
	
	/// <summary>
	/// reset active shapes (visible in UI) 
	/// </summary>
	public void ResetToDefaultValueAllActive()
	{
		for(int i = 0; i < uiItems.Count; i++)
		{
			if(uiItems[i].activeSelf)
			{
				uiItems[i].GetComponent<HumanBodyGeneratorParameterUIItem>().ResetToDefault();
			}
		}
	}
	
	void Update()
	{
		if(Input.GetKeyUp(KeyCode.F2))
			canvas.enabled = !canvas.enabled;
	}
	
	/// <summary>
	/// debug panel isleri
	/// </summary>
	public void DebugPanelOpenStuff()
	{
		debugPanelCounter++;
		if(debugPanelCounter >= 5)
		{
			debugPanelCounter = 0;
			if(debugPanel!= null)
				debugPanel.SetActive(true);
		}
	}
	
	public void SaveBodyPreset(string name)
	{
		if(presetManager != null)
			presetManager.SavePreset(name);
		
	}
}
