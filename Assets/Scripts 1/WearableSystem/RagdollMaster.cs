using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RagdollMaster : MonoBehaviour
{
	[System.Serializable]
	public class BoneMappingClass
	{
		public Transform sourceBone;
		public Transform targetBone;
	}
	
	private int headID=0;
	private int pelvisID=1;
	private int spineID=2;
	private int lHandID=3;
	private int lHandBendID=4;
	private int rHandID=5;
	private int rHandBendID=6;
	private int lFootID=7;
	private int lFootBendID=8;
	private int rFootID=9;
	private int rFootBendID=10;
	
	//[HideInInspector]
	public Transform[] transforms = new Transform[11];

	
	[Header("some Required Objects")]
	public GameObject rootBone;
	
	
	Transform[] bodyBones;
	
	
	[Header("DEBUG")]
	public Transform[] wearableBones;
	public BoneMappingClass[] boneMapping;
	public Transform ragdollRootBone;
	
	public bool active= false;
	
	public void Start(){
		
	
	}
	
	
	public void Init() {
		
		wearableBones = rootBone.GetComponentsInChildren<Transform>();
		bodyBones = ragdollRootBone.GetComponentsInChildren<Transform>();

		CreateBoneMapping();
		UpdateBoneTransforms(false);

		Gravity ( true);
		if (!active)
			DeActivateRagDoll();
	}
    
	/// <summary>
	/// MAtches actor bones to cloth bones
	/// </summary>
	public void CreateBoneMapping()
	{
		string boneName = "";
		boneMapping = new BoneMappingClass[wearableBones.Length];
		for(int i = 0; i < wearableBones.Length; i++)
		{
			boneName = wearableBones[i].gameObject.name;
			
			boneMapping[i] = new BoneMappingClass();
			boneMapping[i].targetBone = wearableBones[i];
			for(int j = 0; j < bodyBones.Length; j++)
			{
				if(bodyBones[j].gameObject.name == boneName)
					boneMapping[i].sourceBone = bodyBones[j];
			}

		}
	}
	
    
	public void UpdateBoneTransforms(bool fromSource)
	{
		bool updateScale = true;
		for(int i = 0; i < boneMapping.Length; i++)
		{if (boneMapping[i].sourceBone==null || boneMapping[i].targetBone==null  )
			continue;
	
			if ( fromSource) {
				boneMapping[i].targetBone.localPosition = boneMapping[i].sourceBone.localPosition;
				boneMapping[i].targetBone.localRotation = boneMapping[i].sourceBone.localRotation;
			} else {
				boneMapping[i].sourceBone.localPosition = boneMapping[i].targetBone.localPosition;
				boneMapping[i].sourceBone.localRotation = boneMapping[i].targetBone.localRotation ;
				
			}
			
			
		
				}
	}
	
	public void ActivateRagDoll() {
		active = true;
		UpdateBoneTransforms(false);
		ragdollRootBone.gameObject.SetActive(true);
		
	}
	
	public void DeActivateRagDoll() {
		active = false;

		
		
		ragdollRootBone.gameObject.SetActive(false);
		
	}
	
	public void Gravity(bool activate) {
		
		Component[] rigidbodies;
	
		rigidbodies = ragdollRootBone.GetComponentsInChildren<Rigidbody>();

		foreach (Rigidbody rb in rigidbodies)
			rb.useGravity = activate;
		
	}
    
	void LateUpdate()
	{
		if ( active  )
			UpdateBoneTransforms(true);

	}
	
	
	
	public Transform SearchHierarchyForBone(Transform current, string name)   
 {
 	if (name=="") 
 		return current;
 		
	 if (current.name == name)
		 return current;
	 for (int i = 0; i < current.childCount; ++i)
	 {
		 Transform found = SearchHierarchyForBone(current.GetChild(i), name);
		 if (found != null)
			 return found;
	 }
	 return null;
	 
	 
 }
 
	public void  GetRagDollTransforms(Transform rootTransform) {
		
		
		transforms[pelvisID]= SearchHierarchyForBone(rootTransform,"hip");
		transforms[spineID]= SearchHierarchyForBone(rootTransform,"abdomenUpper");
	
		transforms[lHandID]= SearchHierarchyForBone(rootTransform,"lHand");
		transforms[rHandID]= SearchHierarchyForBone(rootTransform,"rHand");


		transforms[lFootID]= SearchHierarchyForBone(rootTransform,"lFoot");
		transforms[rFootID]= SearchHierarchyForBone(rootTransform,"rFoot");
		
		transforms[headID]= SearchHierarchyForBone(rootTransform,"head");

			

		
	}
 
 
}
