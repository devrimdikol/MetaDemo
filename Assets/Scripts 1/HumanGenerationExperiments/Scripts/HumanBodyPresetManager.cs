using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
public class HumanBodyPresetManager : MonoBehaviour
{
	[System.Serializable]
	public class BodyPresetItem
	{
		public string blendShapeName = "";
		public int blendShapeId = -1;
		public float value = 0;
		public BodyPresetItem(string name)
		{
			blendShapeName = name;
		}
		
		public void SetBlendShapeId(int i)
		{
			blendShapeId = i;
		}
	}
	
	[System.Serializable]
	public class BodyPreset
	{
		public string groupName;
		public BodyPresetItem[] items;
		public List<string> availablePresetNames;
		public BodyPreset(string name, int itemCount)
		{
			groupName = name;
			items = new BodyPresetItem[itemCount];
			for(int i = 0; i < items.Length; i++)
				items[i] = new BodyPresetItem("");
				
			availablePresetNames = new List<string>();
			//Debug.Log("yaratildim su kadar olarak: " +items.Length);
		}
	}
	
	
	public HumanBodyGenerator bodyGenerator;
	
	public List<BodyPreset> presets;
	 List<string> savedPresets;
	public bool randomBodyOnStartup = true;
	// Start is called before the first frame update
    void Start()
    {
	    InitPresetList();  
	    LoadPresetList();
	    
	    if(randomBodyOnStartup)
	    	GenerateRandomBody();
    }
    
	public void GenerateRandomBody()
	{
		
		int index;
		float dice;
		Random.seed = System.DateTime.Now.Millisecond;
		for(int i = 0; i < presets.Count; i++)
		{
			if(presets[i].availablePresetNames.Count == 0) continue;
			
			dice = Random.Range(0,1);
			if(dice > 0.5) continue;
			
			index = Random.Range(0,presets[i].availablePresetNames.Count);
			/*if(index == 0)
			{
				
			}*/
			//Debug.Log("=======" + index);
			ApplyPresetToBody(presets[i].availablePresetNames[index]);
			//for(int j = 0; j < presets[i].availablePresetNames.Count; j++)
			//	Debug.Log("---------->" + presets[i].availablePresetNames[j]);
		}
		
		//bodyGenerator.SetBlendShapeWeight(line[0], float.Parse(line[1]));
	}
    
	public void AssignPresets()
	{
		for(int i = 0; i < presets.Count; i++)
		{
			presets[i].availablePresetNames.Clear();
			for(int j = 0; j < savedPresets.Count; j++)
			{
				if(savedPresets[j].Contains(presets[i].groupName))
					presets[i].availablePresetNames.Add(savedPresets[j]);
			}
		}
	}
    
	public void LoadPresetList()
	{
		if(savedPresets == null)
			savedPresets = new List<string>();
			
		savedPresets.Clear();
		string path = Application.streamingAssetsPath + "\\BodyPresets\\";
		string[] files = System.IO.Directory.GetFiles(path, "*.prs");
	
		string charName = "Eve";
		if(bodyGenerator.gender == HumanBodyGenerator.Gender.Male)
			charName = "Adam";
	
		for(int i = 0; i < files.Length; i++)
		{
			string s = Path.GetFileNameWithoutExtension(files[i]);
			if(s.Contains(charName))
			{
				savedPresets.Add(s);
			}
		}
		
		AssignPresets();
	}
    
	public void InitPresetList()
	{
		HumanBodyBlendShapeGroup[] blendShapeGroups = FindObjectsOfType<HumanBodyBlendShapeGroup>();
		
		presets = new List<BodyPreset>();
		
		for(int i = 0; i < blendShapeGroups.Length; i++)
		{
			if(blendShapeGroups[i].gender != bodyGenerator.gender)
				continue;			
			for(int j = 0; j < blendShapeGroups[i].blendShapeGroup.Length; j++)
			{			
				HumanBodyBlendShapeGroup.BlendShapeFilterGroup b = blendShapeGroups[i].blendShapeGroup[j];
				BodyPreset p = new BodyPreset(b.groupName, b.blendShapeFilter.Length);
				//Debug.Log("!_!_!_!_!_" + b.groupName);
				
				
				for(int k = 0; k < b.blendShapeFilter.Length; k++)
				{
					//Debug.Log("****" + b.blendShapeFilter[k] + "****");
					p.items[k].blendShapeName =  b.blendShapeFilter[k];
					p.items[k].SetBlendShapeId(bodyGenerator.GetBlendShapeIndexByName(p.items[k].blendShapeName));
				}
				
				presets.Add(p);
			}
			//groups.Add( new BodyPresetItem)
		}
	}
	
	public void SavePreset(string name)
	{
		string charName = "Eve";
		if(bodyGenerator.gender == HumanBodyGenerator.Gender.Male)
			charName = "Adam";
			
		string dateTime = System.DateTime.Now.ToString();
		dateTime = dateTime.Replace(":", "");
		dateTime = dateTime.Replace(".", "");
		dateTime = dateTime.Replace(" ", "");
		string fileName = charName + name + "Preset_" + dateTime;
		
		BodyPreset p = null;
		for(int i = 0; i < presets.Count; i++)
		{
			if(presets[i].groupName.Contains(name))
			{
				p = presets[i];
			}
		}
		
		if(p != null)
		{
			for(int i = 0; i < p.items.Length; i++)
			{
				p.items[i].value = bodyGenerator.GetBlendShapeWeight(p.items[i].blendShapeId);
			}
		}
		
		Debug.Log(fileName + " will be written");
		WritePresetToFile(p, fileName);
	}
	
	public void WritePresetToFile(BodyPreset p, string fileName)
	{
		string path = Application.streamingAssetsPath + "\\BodyPresets\\" + fileName + ".prs";
		StreamWriter writer = new StreamWriter(path, false);
		string s;
		for(int i = 0; i < p.items.Length; i++)
		{
			writer.WriteLine(p.items[i].blendShapeName + "=" + Mathf.RoundToInt(p.items[i].value).ToString());
		}
		
		writer.Close();
		
		Debug.Log(path + " written!");
		
		LoadPresetList();
	}
	
	public void ApplyPresetToBody(string presetName)
	{
		string path = Application.streamingAssetsPath + "\\BodyPresets\\" + presetName + ".prs";
		string[] loadData;
		loadData = File.ReadAllText(path).Split('\n');
		
		for(int i = 0; i < loadData.Length; i++)
		{
			if(!loadData[i].Contains('=')) continue;
			
			string[] line = loadData[i].Split('=');
			
			bodyGenerator.SetBlendShapeWeight(line[0], float.Parse(line[1]));
		}
	}
	
	void OnGUI()
	{
		/*for(int i = 0; i < presetNames.Count; i++)
		{
			if(GUI.Button(new Rect(Screen.width - 160, i*35, 150, 30), presetNames[i]))
				ApplyPresetToBody(presetNames[i]);
		}*/
		/*int index = 0;
		for(int i = 0; i < presets.Count; i++)
		{
			for(int j = 0; j < presets[i].availablePresetNames.Count; j++)
			{
				if(GUI.Button(new Rect(Screen.width - 160, index*35, 150, 30), presets[i].availablePresetNames[j]))
					ApplyPresetToBody(presets[i].availablePresetNames[j]);
					
				index++;
			}
		}
		
		if(GUI.Button(new Rect(Screen.width-160, 10, 150,30), "RNDM"))
		GenerateRandomBody();
			
		*/
	}
		
    // Update is called once per frame
    void Update()
    {
        
    }
}
