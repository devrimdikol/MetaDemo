using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanBodySimpleMakeup : MonoBehaviour
{
    
	[System.Serializable]
	public class MakeUpPack
	{
		public string name = "MakeupPack";
		
		public Material faceMaterial;
		public Material lipsMaterial;
		public Material earsMaterial;
		public Material eyesocketMaterial;
	}
    
	public SkinnedMeshRenderer bodyRenderer;
	public MakeUpPack[] makeUpList;
	
	
	int activeMakeUpIndex = -1;
	/*
	face MAterial - 1
	Lips - 2
	ears - 5
	Eyesocket - 7
	*/
	
	public void SetLipStickColor(Color c)
	{
		//if(makeUpList[activeMakeUpIndex] != null)
		//{
			bodyRenderer.materials[2].SetColor("_Diffuse", c);
		//}
	}
	
	
	public void ChangeMakeup(int makeupIndex)
	{
		if(makeupIndex <= 0) return;
		
		makeupIndex--;
		activeMakeUpIndex = makeupIndex;
		Material[] mats = bodyRenderer.materials;
		for(int i = 0; i < mats.Length; i++)
		{
			if(i == 1) mats[i] = makeUpList[makeupIndex].faceMaterial;
			if(i == 2) mats[i] = makeUpList[makeupIndex].lipsMaterial;
			if(i == 5) mats[i] = makeUpList[makeupIndex].earsMaterial;
			if(i == 7) mats[i] = makeUpList[makeupIndex].eyesocketMaterial;
			
		}
		
		bodyRenderer.materials = mats;
		/*renderer.material[1] = makeUpList[makeupIndex].faceMaterial;
		renderer.material[2] = makeUpList[makeupIndex].lipsMaterial;
		renderer.material[5] = makeUpList[makeupIndex].earsMaterial;
		renderer.material[7] = makeUpList[makeupIndex].eyesocketMaterial;*/
	}
}
