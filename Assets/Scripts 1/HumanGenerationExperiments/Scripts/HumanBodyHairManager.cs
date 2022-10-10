using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanBodyHairManager : MonoBehaviour
{
    
	public GameObject[] hairObjects;
	public Renderer[] renderers;
	public Material[] materials;
	public bool random = false;
	
	void Start()
	{
		if ( random) {
			int randHairNo = Random.Range(0,hairObjects.Length);
			
			SetHair( randHairNo);
			
			int randID= Random.Range(0,materials.Length);
			var _materials = renderers[randHairNo].materials;
			
			for  ( int i = 0; i < _materials.Length; i++ ) 
			
			{
				//Debug.Log(hairObjects[randHairNo].name + " " + renderers[randHairNo].transform.name + " " + renderers[randHairNo].materials[i].name+  "  " + materials[randID] );
				_materials[i]	=  materials[randID];
			}
			renderers[randHairNo].materials = _materials;
			
		}
			else
		SetHair(0);
	}
	int activeHairIndex = 0;
	public void SetHair(int hairIndex)
	{
		//hairIndex--;
		
		for(int i = 0; i < hairObjects.Length; i++)
		{
			if(i == hairIndex)
			{
				if(hairObjects[i] != null)
				{
					hairObjects[i].SetActive(true);	
				}
				
				activeHairIndex = i;
			}
				
			else
			{
				if(hairObjects[i] != null)
					hairObjects[i].SetActive(false);
			}
				
		}
		
	}
	
	void Update()
	{
		if(Input.GetKeyUp("5"))
		{
			SetHair( (activeHairIndex + 1) % hairObjects.Length);
		}
	}
	
	
	
}
