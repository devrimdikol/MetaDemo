using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WearableManager : MonoBehaviour
{
	[System.Serializable]
	public class WearableBodyPosition
	{
		public bool upperHead = false;
		public bool ear = false;
		public bool eye = false;
		public bool lowerFace = false;
		public bool neck = false;
		public bool shoulder = false;
		public bool arm = false;
		public bool elbow = false;
		public bool foreArm = false;
		public bool wrist = false;
		public bool hand = false;
		public bool fingers = false;
		public bool chest = false;
		public bool back = false;
		public bool waist = false;
		public bool hip = false;
		public bool leg = false;
		public bool knee = false;
		public bool calve = false;
		public bool ankle = false;
		public bool foot = false;
		public bool crotch = false;
		public bool glutes = false;
		public int order = 0;
		
	}
	
	
	public enum WearableBodyPart
	{
		Head = 0,
		UpperBody = 1,
		LowerBody = 2,
		Feet = 3
	}
	
	public enum WearableGender
	{
		Male = 0,
		Female = 1,
	}

	public SkinnedMeshRenderer bodyRenderer;
	public Transform rootBone;
	public WearableGender gender;
	public bool randomClothesOnStart = true;
	private List<Wearable> clothList;
	private Wearable[] wearables;
	[Space(10)]
	[Header("DEBUG")]
	public List<Wearable> finalWearables;
	
	 Vector2 scrollPosition = Vector2.zero;
	// Start is called before the first frame update
    void Start()
    {
	    GetClothes();
	    
	    if(randomClothesOnStart)
	    	AddRandomClothes();
    }
    
	public void AddRandomClothes()
	{
		
		if ( Random.Range(0f,1f)>0.5)
			return;
		if(finalWearables.Count == 0) return;
		
		RemoveAllClothes();
		
		int costumeCount = 2;
		
		List<int> ids = new List<int>();
		
		for(int i = 0; i < costumeCount; i++)
		{
			ids.Add(Random.Range(0,finalWearables.Count));
		}
		
		for(int i = 0; i < costumeCount; i++)
			ApplyWearableToActor(finalWearables[ids[i]]);
	}
    
	public bool WearablesOverlapping(WearableBodyPosition a, WearableBodyPosition b)
	{
		if(a.order != b.order) return false;
		
		if(a.upperHead == true && b.upperHead == true) return true;
		if(a.ear == true && b.ear == true) return true;
		if(a.eye == true && b.eye == true) return true;
		if(a.lowerFace == true && b.lowerFace == true) return true;
		if(a.neck == true && b.neck == true) return true;
		if(a.shoulder == true && b.shoulder == true) return true;
		if(a.arm == true && b.arm == true) return true;
		if(a.elbow == true && b.elbow == true) return true;
		if(a.foreArm == true && b.foreArm == true) return true;
		if(a.wrist == true && b.wrist == true) return true;
		if(a.hand == true && b.hand == true) return true;
		if(a.fingers == true && b.fingers == true) return true;
		if(a.chest == true && b.chest == true) return true;
		if(a.back == true && b.back == true) return true;
		if(a.waist == true && b.waist == true) return true;
		if(a.hip == true && b.hip == true) return true;
		if(a.leg == true && b.leg == true) return true;
		if(a.knee == true && b.knee == true) return true;
		if(a.calve == true && b.calve == true) return true;
		if(a.ankle == true && b.ankle == true) return true;
		if(a.foot == true && b.foot == true) return true;
		if(a.crotch == true && b.crotch == true) return true;
		if(a.glutes == true && b.glutes == true) return true;
		
		return false;
		
	}
    
	public void GetClothes()
	{
		clothList = new List<Wearable>();
		wearables = FindObjectsOfType<Wearable>();
		finalWearables = new List<Wearable>();
		for(int i = 0; i < wearables.Length; i++)
		{
			if(wearables[i].gender == gender)
				finalWearables.Add(wearables[i]);
		}
	}
   
	public void ApplyWearableToActor(Wearable w)
	{

		int objIndexToDelete = -1;
		GameObject go = null;
		for(int i = 0; i < clothList.Count; i++)
		{
			/*if(clothList[i].bodyPart == w.bodyPart)
			{
				if(clothList[i].order == w.order)
				{
					objIndexToDelete = i;
				}
			}*/
			if(WearablesOverlapping(clothList[i].podyPosition, w.podyPosition))
				objIndexToDelete = i;
		}
		
		if(objIndexToDelete >= 0)
		{
			RemoveCloth(objIndexToDelete);
	
		}
	
		go = Instantiate(w.gameObject);
		clothList.Add(go.GetComponent<Wearable>());

		go.GetComponent<Wearable>().FixToCharacter(this);
		
	}
	
	public void RemoveAllClothes()
	{
		for(int i = clothList.Count-1; i >= 0; i--)
			RemoveCloth(i);
	}
	
	public void RemoveCloth(int index)
	{
		clothList[index].RevertChanges();
		GameObject go = clothList[index].gameObject;
		
		clothList.RemoveAt(index);
		DestroyImmediate(go);
	}
    
	/*void OnGUI()
	{
		GUI.color = Color.white;
		
		scrollPosition = GUI.BeginScrollView(new Rect(10, 10, 300, 600), scrollPosition, new Rect(0, 0, 300 , finalWearables.Count*150), false,true);

		// Make four buttons - one in each corner. The coordinate system is defined
		// by the last parameter to BeginScrollView.
		// End the scroll view that we began above.
		
		
		for(int i = 0; i < finalWearables.Count; i++)
		{
			if(GUI.Button(new Rect(10, i*35, 150, 30), finalWearables[i].gameObject.name))
				ApplyWearableToActor(finalWearables[i]);
		}
		GUI.EndScrollView();
		
		GUI.color = Color.red;
		for(int i = 0; i < clothList.Count; i++)
		{
			if(GUI.Button(new Rect(Screen.width - 160, i*35, 150, 30), clothList[i].gameObject.name))
				RemoveCloth(i);
		}
		
		if(GUI.Button(new Rect(Screen.width-100, Screen.height - 50, 90, 30), "rndm"))
			AddRandomClothes();
	}*/
}
