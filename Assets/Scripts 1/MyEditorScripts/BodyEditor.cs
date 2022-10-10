using UnityEditor;
using UnityEngine;

#if UNITY_EDITOR
[CustomEditor(typeof(Body)), CanEditMultipleObjects]

public class PersonaEditor : Editor
{
	
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
	
	public override void OnInspectorGUI()
	{
	
	
		DrawDefaultInspector ();
		Body example = (Body)target;
		bool noRoot= example.characterRootTransform == null;
		GUI.contentColor = Color.white;
	
		string buttonText="Active Handle Control";
		GUI.contentColor = Color.white;
		        
		if ( example.active ) {
			GUI.contentColor = Color.green;
		        
			buttonText = "Stop Handle Control";
		}
		if (GUILayout.Button(buttonText))
		{ 
			if (example.active) {
				example.active = false;
				if ( example.bipedIK )
					example.bipedIK.enabled = false;
			}
			else {
				example.active = true;
				if ( example.bipedIK )
					example.bipedIK.enabled = true;
			
			}
				
			
		}
		
		

		
		GUI.contentColor = Color.white;
		if (GUILayout.Button("Reset TPose!"))
		{ 
		
			example.TPose();
		}
		GUILayout.Space(20);
		GUI.contentColor = Color.white;
		if ( noRoot)
			GUI.contentColor = Color.gray;
		
		if (GUILayout.Button("Install IK Components"))
		{ 
			if ( !noRoot)
				example.InstallIKComponents();
		}
		if (GUILayout.Button("Remove IK Components"))
		{ 
		
			example.RemoveIKComponents();
		}
		GUILayout.Space(20);
		/*	if (GUILayout.Button("Install FullBodyIK Components"))
		{ 
			if ( !noRoot)
				example.InstallFullIKComponents();
				
			example.fullBodyBipedIK=true;
			
		} */
	

		GUILayout.Space(20);

		if (GUILayout.Button("Add Breast Comps & Physics"))
		{ 
		
			example.AddBreasts();
		}
		
		if (GUILayout.Button("Add Penis"))
		{ 
		
			example.AddPenis();
		}
		if (GUILayout.Button("Add Hands"))
		{ 
		
			example.AddHands();
		}
		
		if (GUILayout.Button("Add Male Interesting Points"))
		{ 
		
			example.AddInterestingPoints(2);
		}
		
		if (GUILayout.Button("Add Female Interesting Points"))
		{ 
		
			example.AddInterestingPoints(3);
		}
		
		if (GUILayout.Button("Add Male Look & Expression System"))
		{ 
		
			example.AddLookSystem(true);
		}
		
		if (GUILayout.Button("Add Female Look & Expression System"))
		{ 
		
			example.AddLookSystem(false);
		}
		
		if (GUILayout.Button("Add Chest&Legs Bone Stimulator"))
		{ 
		
			example.AddJiggleSystem();
		}
		
		GUILayout.Space(20);
		if (GUILayout.Button("Add Ragdoll"))
		{ 
		
			example.AddRagdoll();
		}
		GUILayout.Space(20);

	
		if (GUILayout.Button("Activate Ragdoll"))
		{ 
		
			example.ChangeMotionState(Body.MotionType.ragdoll);
		}
		if (GUILayout.Button("Activate BibedIK"))
		{ 
		
			example.ChangeMotionState(Body.MotionType.bipedIK);
		}
		if (GUILayout.Button("Activate Animation"))
		{ 
		
			example.ChangeMotionState(Body.MotionType.animation);
		}
	
		
		
		GUILayout.Space(20);
		GUI.contentColor = Color.red;
		if (GUILayout.Button("!!!! Reset Handles !!!"))
		{ 
		
			example.ResetPosition();
		}
	
		if (GUILayout.Button("!trans from old system"))
		{ 
			example.pos = new Vector3[11];
			example.rot = new Quaternion[11];
			
			example.pos[headID] = example.headPosition;
			example.pos[pelvisID] = example.pelvisPosition;
			example.pos[spineID] = example.spinePosition;
		
			example.rot[headID] = example.headRotation;
			example.rot[pelvisID] = example.pelvisRotation;
			example.rot[spineID] = example.spineRotation;
		
			
			example.pos[rHandID] = example.rightHandPosition;
			example.rot[rHandID] = example.rightHandRotation;
			
			example.pos[lHandID] = example.leftHandPosition;
			example.rot[lHandID] = example.leftHandRotation;
			
			example.pos[lHandBendID] = example.leftHandBendPosition;
			example.pos[rHandBendID] = example.rightHandBendPosition;
			
			
			example.pos[rFootID] = example.rightFootPosition;
			example.rot[rFootID] = example.rightFootRotation;
			
			example.pos[lFootID] = example.leftFootPosition;
			example.rot[lFootID] = example.leftFootRotation;
			
			example.pos[lFootBendID] = example.leftFootBendPosition;
			example.pos[rFootBendID] = example.rightFootBendPosition;
			/*			
				headPosition = pos[headID];
				pelvisPosition = pos[pelvisID];
				spinePosition = pos[spineID];
				leftHandPosition= pos[lHandID];
				leftHandBendPosition= pos[lHandBendID];
				rightHandPosition= pos[rHandID];
				rightHandBendPosition = pos[rHandBendID];
				leftFootPosition= pos[lFootID];
				leftFootBendPosition = pos[lFootBendID];
				rightFootPosition= pos[rFootID];
				rightFootBendPosition = pos[rFootBendID];
		 		 
				headRotation = rot[headID];
				pelvisRotation = rot[pelvisID];
				spineRotation= rot[spineID];
				leftHandRotation = rot[lHandID];
				rightHandRotation = rot[rHandID];
				leftFootRotation= rot[lFootID];
				rightFootRotation= rot[rFootID]; */
			
		}
		
	}
	
	public Vector3 FreeMove2(int ID, Vector3 pos,Quaternion rot, float size, Vector3 snap, Handles.CapFunction cap ) {
		Body example = (Body)target;
		//	ctrlId = GUIUtility.GetControlID(FocusType.Passive);
		return  example.transform.InverseTransformPoint(Handles.FreeMoveHandle(ID+1,example.transform.TransformPoint(pos),rot,size,snap,cap));
	}
	
	public Vector3 FreeMove(int ID, Vector3 pos,Quaternion rot, float size, Vector3 snap, Handles.CapFunction cap ) {
		Body example = (Body)target;
		//	ctrlId = GUIUtility.GetControlID(FocusType.Passive);
	
		//	return  example.transform.InverseTransformPoint(Handles.FreeMoveHandle(ID+1,example.transform.TransformPoint(pos),rot,size,snap,cap));
		if (hot ==ID+1 || hot == ID+100)
			pos = example.transform.InverseTransformPoint(Handles.PositionHandle(example.transform.TransformPoint(pos),rot));
		return  example.transform.InverseTransformPoint(Handles.FreeMoveHandle(ID+1,example.transform.TransformPoint(pos),rot,size,snap,cap));
		//return  example.transform.InverseTransformPoint(Handles.FreeMoveHandle(example.transform.TransformPoint(pos),rot,size,snap,cap));
	}
	
	public Quaternion FreeRotate(int ID, Quaternion rot,Vector3 pos, float size ) {
		Body example = (Body)target;
		if (hot ==ID+1 || hot == ID+100)
			//	return   Quaternion.Inverse(example.transform.rotation)*(Handles.FreeRotateHandle(ID+100,example.transform.rotation * rot, example.transform.TransformPoint(pos), size));
		return   Quaternion.Inverse(example.transform.rotation)*(Handles.RotationHandle(example.transform.rotation * rot, example.transform.TransformPoint(pos)));
		//return   Quaternion.Inverse(example.transform.rotation)*(Handles.RotationHandle(example.transform.rotation * rot, example.transform.TransformPoint(pos)));
		
		else 
		
			return rot;
	}
	
	public void Label(Vector3 pos, string str){
		Body example = (Body)target;
		GUIStyle style = new GUIStyle();
		style.normal.textColor = example.handleColor; 
	
		Handles.Label(example.transform.TransformPoint(pos), str,style);
	}
	public int ctrlId;
	public int hot ;
	
	public int a=0;
	GUIStyle style ;
	protected virtual void OnSceneGUI()
	{
		Body example = (Body)target;
		//Debug.Log("osman");
		EditorGUI.BeginChangeCheck();
		///unutmamali
		/// 
		if ( EditorGUIUtility.hotControl !=0 &&  EditorGUIUtility.hotControl <11 )
			hot =  EditorGUIUtility.hotControl;
			
		a=0;
		example.activeControlType = (Body.ControlType) hot-1;
	
		Handles.color = example.handleColor;
		//Handles.lineThickness = 10;
		//Handles.button XXXX
		Vector3 snap = Vector3.one * 0.05f;
		Vector3 leftFootPosition =FreeMove( (int) Body.ControlType.lFoot,  example.pos[lFootID], Quaternion.identity, 0.05f, snap, Handles.RectangleHandleCap);
		Quaternion leftFootRotation = FreeRotate((int) Body.ControlType.lFoot, example.rot[lFootID], leftFootPosition, 0.15f);
		Label(leftFootPosition, "leftFoot");

		Vector3 rightFootPosition = FreeMove((int) Body.ControlType.rFoot, example.pos[rFootID], Quaternion.identity, 0.05f, snap, Handles.RectangleHandleCap);
		Quaternion rightFootRotation = FreeRotate((int) Body.ControlType.rFoot,example.rot[rFootID], rightFootPosition, 0.15f);
		Label(rightFootPosition, "rightFoot");
	
		
		Vector3 leftFootBendPosition = FreeMove( (int) Body.ControlType.lFootBend, example.pos[lFootBendID], Quaternion.identity, 0.05f, snap, Handles.CircleHandleCap);
		Label(leftFootBendPosition, "leftFootBend");
		
		
		Vector3 rightFootBendPosition = FreeMove( (int) Body.ControlType.rFootBend, example.pos[rFootBendID], Quaternion.identity, 0.05f, snap, Handles.CircleHandleCap);
		Label(rightFootBendPosition, "rightFootBend");
		

		Vector3  pelvisPosition = FreeMove((int) Body.ControlType.pelvis, example. pos[pelvisID], Quaternion.identity, 0.1f, snap, Handles.RectangleHandleCap);
	Quaternion pelvisRotation = FreeRotate((int) Body.ControlType.pelvis,example.rot[pelvisID],  pelvisPosition, 0.25f);
	Label(pelvisPosition, "Pelvis");
	

	Vector3 spinePosition=example.pos[spineID];
		spinePosition = FreeMove((int) Body.ControlType.spine , example.pos[spineID], example.rot[spineID], 0.1f, snap, Handles.RectangleHandleCap);
	Label(spinePosition, "spine");
		
		
		Vector3  headPosition=example. pos[headID];
		example.rot[headID] =Quaternion.identity;
		headPosition = FreeMove((int) Body.ControlType.head, example. pos[headID], example.rot[headID], 0.1f, snap, Handles.RectangleHandleCap);
		Label(headPosition, "head");
		
		Vector3 leftHandPosition = example.pos[lHandID];
		Quaternion leftHandRotation =  example.rot[lHandID];
		leftHandPosition =FreeMove((int) Body.ControlType.lHand, example.pos[lHandID], Quaternion.identity, 0.05f, snap, Handles.RectangleHandleCap);
		leftHandRotation = FreeRotate((int) Body.ControlType.lHand,example.rot[lHandID], leftHandPosition, 0.15f);
			Label(leftHandPosition, "leftHand");
	
			
		Vector3 rightHandPosition = example.pos[rHandID];
		Quaternion rightHandRotation= example.rot[rHandID];
		rightHandPosition = FreeMove((int) Body.ControlType.rHand,example.pos[rHandID], Quaternion.identity, 0.05f, snap, Handles.RectangleHandleCap);
		rightHandRotation = FreeRotate((int) Body.ControlType.rHand,example.rot[rHandID], rightHandPosition, 0.15f);
			Label(rightHandPosition, "rightHand");
		
		Vector3 leftHandBendPosition = FreeMove((int) Body.ControlType.lHandBend, example.pos[lHandBendID], Quaternion.identity, 0.05f, snap, Handles.CircleHandleCap);
		Label(leftHandBendPosition, "leftHandBend");
		
		Vector3 rightHandBendPosition = FreeMove((int) Body.ControlType.rHandBend, example.pos[rHandBendID], Quaternion.identity, 0.05f, snap, Handles.CircleHandleCap);
		Label(rightHandBendPosition, "rightHandBend");
		
		//Transform leftFootTransforrm = Handles.RotationHandle()
		
		
		//Handles.DrawWireCube(leftFootPosition, Vector3.one);
		//rotation olmayanlarin rotation handleini gosterme (bend, head vs.)
	
		if (EditorGUI.EndChangeCheck())
		{
			Undo.RecordObject(example, "Change Look At Target Position");
			
		example.pos[lFootID] = leftFootPosition;
		example.rot[lFootID] = leftFootRotation;
			
			
		example.pos[rFootID] = rightFootPosition;
		example.rot[rFootID] = rightFootRotation;
			
		example.pos[lFootBendID] = leftFootBendPosition;
		example.pos[rFootBendID] = rightFootBendPosition;
			
			example.pos[pelvisID] = pelvisPosition;
		example.rot[pelvisID] = pelvisRotation;
			
		example.pos[spineID] = spinePosition;
			
			example.pos[headID] =  headPosition;
			example.rot[headID] =  Quaternion.identity;
			
		example.pos[lHandID] = leftHandPosition;
		example.rot[lHandID] = leftHandRotation;
		example.pos[rHandID] = rightHandPosition;
		example.rot[rHandID] = rightHandRotation;
		example.pos[lHandBendID] = leftHandBendPosition;
		example.pos[rHandBendID] = rightHandBendPosition;
			
			
			example.Update();
			
		}
	}
}
#endif