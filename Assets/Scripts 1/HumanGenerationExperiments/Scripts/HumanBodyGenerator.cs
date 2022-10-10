using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.Events;
using SimpleJSON;
/// <summary>
/// class responsible for handling all blendshape operations
/// </summary>
public class HumanBodyGenerator : MonoBehaviour
{
	
	public enum Gender
	{
		Female = 0,
		Male = 1,
	}
	
	
	[System.Serializable]
	public class HumanShapeParameterClass
	{
		public string parameterName;
		public float defaultValue;
		public float value;
		
		public string friendlyName;
		public bool inWhiteList = true;
		
		public HumanShapeParameterClass(string name, float dVal, float cVal)
		{
			parameterName = name;
			defaultValue = dVal;
			value = cVal;
		}
		
		/*public string GetFriendlyName()
		{
			return friendlyName;
		}
		
		/*public bool IsShapeInWhiteList()
		{
			return inWhiteList;
		}*/
	}
	
	
	[System.Serializable]
	public class HumanBodyParts
	{
		public SkinnedMeshRenderer renderer;
		public List<HumanShapeParameterClass> shapeList;
	}
	
	
	/// <summary>
	/// gender of the character
	/// </summary>
	[Tooltip("important, gender of character")]
	public Gender gender = Gender.Female;
	
	/// <summary>
	/// skinned mesh renderer of the body, blend shapes are taken from this renderer
	/// </summary>
	[Tooltip("main renderer, blendshapes are taken from this one")]
	public SkinnedMeshRenderer bodyRenderer;
	
	/// <summary>
	/// skinned mesh renderer of eyelashes
	/// </summary>
	[Tooltip("eyelash renderer")]
	public SkinnedMeshRenderer eyelashRenderer;
	
	/// <summary>
	/// skinned meshrenderer of the hair
	/// </summary>
	[Tooltip("hair renderer")]
	public SkinnedMeshRenderer hairRenderer;
	[HideInInspector]
	public List<HumanShapeParameterClass> shapeList;
	
	
	
	
	/// <summary>
	/// whitelisti degistirdigimiz zaman realtime de isler yurusun diye (calisirken lazim oluyor) haberci event
	/// </summary>
	[HideInInspector]
	public UnityEvent shapeListUpdatedEvent;
	
	//[Tooltip("whitelist refreshed event")]
	
	//public List<string> shapeNameWhiteList;
	
	
	
	/// <summary>
	/// test function to write blendshapes to file
	/// </summary>
	void WriteBlendShapes()
	{
		
		string fileName = "FemaleBlendShapeData.dat";
		if(gender == Gender.Male) fileName = "MaleBlendShapeData.dat";
		
		string path = Application.streamingAssetsPath + "\\" + fileName;
		StreamWriter writer = new StreamWriter(path, false);
		string s;
		for(int i = 0; i < shapeList.Count; i++)
		{
			writer.WriteLine(shapeList[i].parameterName + "=");
		}
		
		writer.Close();
	}
	
	/// <summary>
	/// filter function for UI blendshapelist
	/// </summary>
	void ApplyWhiteListToShapeList()
	{
		string fileName = "FemaleBlendShapeData.dat";
		if(gender == Gender.Male) fileName = "MaleBlendShapeData.dat";
		
		string path = Application.streamingAssetsPath + "\\" + fileName;
		//StreamReader reader = new StreamReader(path, false);
		string[] data = File.ReadAllText(path).Split('\n');
		
		for(int i = 0; i < data.Length; i++)
		{
			if(data[i] != "")
			{
				
				string[] line = data[i].Split('=');
				//Debug.Log(line[1].Length);
				if(line[1].Length > 1)
					shapeList[i].friendlyName = line[1];
				else
					shapeList[i].friendlyName = line[0];
				
				if(data[i][0] == '#')
				{
					shapeList[i].inWhiteList = false;
				}
				
				
			}
		}
	}
	
	
	/*void GetFriendlyShapeNames()
	{
		string fileName = "FemaleBlendShapeData.dat";
		if(gender == Gender.Male) fileName = "MaleBlendShapeData.dat";
		
		string path = Application.streamingAssetsPath + "\\" + fileName;
		//StreamReader reader = new StreamReader(path, false);
		string[] data = File.ReadAllText(path).Split('\n');
		
		for(int i = 0; i < shapeList.Count; i++)
		{
			for(int j = 0; j < data.Length; j++)
			{
				string[] line = data[j].Split('=');
				if(shapeList[i].parameterName == line[0])
				{
					if(line[1].Length > 1)
						shapeList[i].friendlyName = line[1];
					else
					shapeList[i].friendlyName = line[0];
					
				}
					
			}
		}
	}*/
	
	void GetFriendlyShapeNames()
	{
		string fileName = "EveInfo";
		string prefix = "Genesis8Female__";
		if(gender == Gender.Male) 
		{
			fileName = "AdamInfo";
			prefix = "Genesis8Male__";
		}
		//string path = Application.streamingAssetsPath + "\\" + fileName;
		//StreamReader reader = new StreamReader(path, false);
		//string[] data = File.ReadAllText(path).Split('\n');
		TextAsset mytxtData=(TextAsset)Resources.Load(fileName);
		string txt=mytxtData.text;
		var N = JSON.Parse(txt);
		for(int i = 0; i < shapeList.Count; i++)
		{

			
			shapeList[i].friendlyName = shapeList[i].parameterName.Replace(prefix,"");
			
			//Debug.Log()
			for(int j = 0; j < N.Count; j++)
			{
				if(N[j]["Name"].Value==shapeList[i].parameterName)
					shapeList[i].friendlyName = N[j]["Label"].Value;
			}
		}
		
		for(int j = 0; j < N.Count; j++)
		{
			//	Debug.Log(N[j]["Name"].Value + "->" + N[j]["Label"].Value);
		}
		
	}
	
	void Awake()
	{
		//Debug.Log("creating shape list");
		CreateBlendshapeList();
		//Debug.Log("creating shape list done");
	}
	
	/// <summary>
	/// initialize characters shapelist
	/// </summary>
	public void CreateBlendshapeList()
	{
		GetShapeList(shapeList, bodyRenderer);	
		
		//debug, sonra kapat
		//WriteBlendShapes();
		
		//ApplyWhiteListToShapeList();
		GetFriendlyShapeNames();
		shapeListUpdatedEvent.Invoke();
	}
	
	
	
	/// <summary>
	/// Gets the list of all blendshapes from a skinned mesh renderer
	/// </summary>
	/// <param name="list">list to fill</param>
	/// <param name="r">renderer</param>
	void GetShapeList(List<HumanShapeParameterClass> list, SkinnedMeshRenderer r)
	{
		if(list == null) list = new List<HumanShapeParameterClass>();
		
		if(list.Count > 0) list.Clear();
		
		Mesh m = r.sharedMesh;
		for (int i= 0; i < m.blendShapeCount; i++)
		{
			string s = m.GetBlendShapeName(i);
			float val = r.GetBlendShapeWeight(i);
			
			list.Add(new HumanShapeParameterClass(s, val, val));
		}
	}
	
	
	/// <summary>
	/// Sets blendshape weight (by index)
	/// </summary>
	/// <param name="index">index of the blend shape</param>
	/// <param name="val">value of the blendshape</param>
	public void SetBlendShapeWeight(int index, float val)
	{
		if(index < 0) return;
		if(index >= shapeList.Count) return;
		
		shapeList[index].value = val;
		if(bodyRenderer != null)
			bodyRenderer.SetBlendShapeWeight(index, shapeList[index].value);
		
		if(eyelashRenderer != null)
		{
			//erkekte nedense blendshapeler kaslara gelmedi??
			if(index < eyelashRenderer.sharedMesh.blendShapeCount)
				eyelashRenderer.SetBlendShapeWeight(index, shapeList[index].value);
		}
			
			
		if(hairRenderer != null)
			hairRenderer.SetBlendShapeWeight(index, shapeList[index].value);
	}
	
	
	/// <summary>
	/// Sets blendshape weight (by name)
	/// </summary>
	/// <param name="shapeName">name of the blendshape</param>
	/// <param name="val"></param>
	public void SetBlendShapeWeight(string shapeName, float val)
	{
		SetBlendShapeWeight(GetBlendShapeIndexByName(shapeName), val);
	}
	
	
	
	/// <summary>
	/// Get blendweight index
	/// </summary>
	/// <param name="shapeName">shape name</param>
	/// <returns>index of the shape in bodyrenderer</returns>
	public int GetBlendShapeIndexByName(string shapeName)
	{
		int result = -1;
		//Debug.Log("looking for " + shapeName + " shapelistCount = " + shapeList.Count);
		for(int i = 0; i < shapeList.Count; i++)
		{
			//if(shapeName.Contains(shapeName))
			//Debug.Log("!!!!!!!!!" + shapeName + " , " + shapeList[i].parameterName);
			if(StringOperations.BackwardsStringContains(shapeName,shapeList[i].parameterName ))
			{
				result = i;
				break;
			}
		}
		
		return result;
	}

	
	/// <summary>
	/// sets morph to original position
	/// </summary>
	/// <param name="index">index of the shape</param>
	public void SetBlendShapeWeightToDefault(int index)
	{
		shapeList[index].value = shapeList[index].defaultValue;
		SetBlendShapeWeight(index, shapeList[index].value);
	}
	
	
	/// <summary>
	/// crazy random function
	/// </summary>
	/// <param name="amount">randomization force</param>
	public void RandomizeAll(List<int> indexList, float amount)
	{
		Random.seed = System.DateTime.Now.Millisecond;
		
		for(int i = 0; i < indexList.Count; i++)
		{
			shapeList[indexList[i]].value = Random.Range(-amount, amount);
			SetBlendShapeWeight(indexList[i], shapeList[indexList[i]].value);
		}
	}
	
	public float GetBlendShapeWeight(int index)
	{
		return bodyRenderer.GetBlendShapeWeight(index);
	}

}
