using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wearable : MonoBehaviour
{
	[System.Serializable]
	public class BoneMappingClass
	{
		public Transform sourceBone;
		public Transform targetBone;
	}
	
	[System.Serializable]
	public class BlendShapeMappingClass
	{
		public int sourceShapeIndex = -1;
		public int targetShapeIndex = -1;
	}
	
	[System.Serializable]
	public class BoneTransformOverrideClass
	{
		
		public string boneName;
		 Transform boneTransform;
		
		public float scaleOverride = 1;
		Vector3 defaultScale;
		
		public Transform GetBoneTransform(){ return boneTransform; }
		public void SetBoneTransform(Transform t){ boneTransform = t; }
		public void SetDefaultScale(Vector3 s){ defaultScale = s; }
		public Vector3 GetDefaultScale(){ return defaultScale; }
	}
	
    
    
	public WearableManager.WearableGender gender;
    
	//[Header("Body Parts")]
	//public WearableManager.WearableBodyPart bodyPart;
	public WearableManager.WearableBodyPosition podyPosition;
	//public int order = 0;
	
	[Header("some Required Objects")]
	public GameObject wearableRootBone;
	SkinnedMeshRenderer bodyRenderer;
	public SkinnedMeshRenderer wearableRenderer;
	
	[Header("Overrides")]
	public BoneTransformOverrideClass[] boneOverrides;
	// Start is called before the first frame update
	
	Transform[] bodyBones;
	
	
	[Header("DEBUG")]
	public Transform[] wearableBones;
	public BoneMappingClass[] boneMapping;
	public BlendShapeMappingClass[] blendShapeMapping;
	
	//public WearableManager testWM;
	
	WearableManager actorWearableManager;

	public LayerMask myLayerMask;
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
	
	/// <summary>
	/// Matches actor blendshapes to wearable blendshapes
	/// </summary>
	public void CreateBlendShapeMapping()
	{
		Mesh m = wearableRenderer.sharedMesh;
		blendShapeMapping = new BlendShapeMappingClass[m.blendShapeCount];
		string blendShapeName = "";

		for(int i = 0; i < wearableRenderer.sharedMesh.blendShapeCount; i++)
		{
			blendShapeMapping[i] = new BlendShapeMappingClass();
			
			string bs = wearableRenderer.sharedMesh.GetBlendShapeName(i);
			
			blendShapeMapping[i].targetShapeIndex = i;
			
			for(int j = 0; j < actorWearableManager.bodyRenderer.sharedMesh.blendShapeCount; j++)
			{
				string s = actorWearableManager.bodyRenderer.sharedMesh.GetBlendShapeName(j); 
				
				if(StringOperations.BackwardsStringContains( bs.Split("__")[1], s))
					blendShapeMapping[i].sourceShapeIndex = j;
					
			}
		}
	}
	
	/// <summary>
	/// create transform override list
	/// </summary>
	public void CreateTransformOverrides()
	{
		Transform[] actorBones = actorWearableManager.GetComponentsInChildren<Transform>();
		
		for(int i = 0; i < boneOverrides.Length; i++)
		{
			
			for(int j = 0; j < actorBones.Length; j++)
			{
				if(boneOverrides[i].boneName == actorBones[j].gameObject.name)
				{
					boneOverrides[i].SetBoneTransform(actorBones[j]);
					boneOverrides[i].SetDefaultScale(actorBones[j].localScale);
				}
			}
			
		}
	}
    
    
    
	/// <summary>
	/// put wearable onto actor
	/// </summary>
	/// <param name="character">wearable manager of actor</param>
	public void FixToCharacter(WearableManager character)
	{
		
		actorWearableManager = character;
		
		bodyRenderer = actorWearableManager.bodyRenderer;
		bodyBones = actorWearableManager.rootBone.GetComponentsInChildren<Transform>();
		wearableBones = wearableRootBone.GetComponentsInChildren<Transform>();
		
		CreateBoneMapping();
		CreateBlendShapeMapping();
		CreateTransformOverrides();
		
		gameObject.transform.parent = character.gameObject.transform;
		gameObject.transform.localPosition = Vector3.zero;
		gameObject.transform.localRotation = Quaternion.identity;
		
		wearableRenderer.enabled = true;
	}
    
	/// <summary>
	/// revert any changes made to the main character (bone rescaling etc.)
	/// </summary>
	public void RevertChanges()
	{
		////
		for(int i = 0; i < boneOverrides.Length; i++)
		{
			boneOverrides[i].GetBoneTransform().localScale = boneOverrides[i].GetDefaultScale();
		}
	}
    
	/// <summary>
	/// apply actor blendshapes to wearable blendshapes
	/// </summary>
	public void UpdateBlendShapes()
	{
		for(int i = 0; i < blendShapeMapping.Length; i++)
		{
			if(blendShapeMapping[i].sourceShapeIndex == -1) continue;
			float w = actorWearableManager.bodyRenderer.GetBlendShapeWeight(blendShapeMapping[i].sourceShapeIndex);
			wearableRenderer.SetBlendShapeWeight(i, w);
		}
	}
    
	/// <summary>
	/// apply actor bone positions to wearable bone positions
	/// </summary>
	public void UpdateBoneTransforms()
	{
		bool updateScale = true;
		for(int i = 0; i < boneMapping.Length; i++)
		{
			if(boneMapping[i].targetBone == null || boneMapping[i].sourceBone == null)
				continue;
			
			boneMapping[i].targetBone.localPosition = boneMapping[i].sourceBone.localPosition;
			boneMapping[i].targetBone.localRotation = boneMapping[i].sourceBone.localRotation;
			
			for(int j = 0; j < boneOverrides.Length; j++)
				if(boneOverrides[j].GetBoneTransform() == boneMapping[i].sourceBone)
					updateScale = false;
			
			if(updateScale)
				boneMapping[i].targetBone.localScale = boneMapping[i].sourceBone.localScale;
		}
	}
	
	public void OverrideBoneTransforms()
	{
		for(int i = 0; i < boneOverrides.Length; i++)
		{
			if(boneOverrides[i].GetBoneTransform() != null)
				boneOverrides[i].GetBoneTransform().localScale = boneOverrides[i].GetDefaultScale()*boneOverrides[i].scaleOverride;
		}
	}
    
	void LateUpdate()
	{
		UpdateBoneTransforms();
		UpdateBlendShapes();
		OverrideBoneTransforms();
	}
}
