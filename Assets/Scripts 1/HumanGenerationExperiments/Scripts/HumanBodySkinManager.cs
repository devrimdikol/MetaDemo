using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class HumanBodySkinManager : MonoBehaviour
{
	[System.Serializable]
	public class SkinPack
	{
		public string packName;
		public Material[] materials;
	}
	
	public SkinnedMeshRenderer bodyRenderer;
	//public D
	public bool randomSkinOnStart = false;
	public SkinPack[] skinPacks;
	
	int activeSkinIndex = 0;
	// Start is called before the first frame update
    void Start()
    {
	    int startIndex = 0;
	    if(randomSkinOnStart)
	    {
	    	startIndex = Random.Range(0,skinPacks.Length);
	    }
	    ChangeSkinPack(startIndex);
    }
    
    
	public void ChangeSkinPack(SkinPack s)
	{
		if(bodyRenderer.materials.Length != s.materials.Length)
		{
			Debug.Log("<color=yellow>MAterial lengths must be same</color>");
			return;
		}
		
		Material[] mats = bodyRenderer.materials;
		for(int i = 0; i < s.materials.Length; i++)
		{
			mats[i] = s.materials[i];
		}
		
		bodyRenderer.materials = mats;
	}
	
	public void ChangeSkinPack(int i)
	{
		if(i>=0 && i<skinPacks.Length)
		{
			ChangeSkinPack(skinPacks[i]);
			activeSkinIndex = i;
		}
	}

    // Update is called once per frame
    void Update()
    {
	    //if(Input.GetKeyUp("4"))
	    //	ChangeSkinPack( (activeSkinIndex + 1) % skinPacks.Length);
    }
}
