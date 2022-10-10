using UnityEditor;
using UnityEngine;

#if UNITY_EDITOR
[CustomEditor(typeof(FingerGestures)), CanEditMultipleObjects]

public class FingerGesturesEditor : Editor
{
	
	public override void OnInspectorGUI()
	{
	
		GUI.contentColor = Color.white;
	
		DrawDefaultInspector ();
		FingerGestures example = (FingerGestures)target;
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
				example.TPose();
			
			}
			else {
				example.active = true;
				example.TPose();
				example.GetJoints();
			}
			
		}
		GUI.contentColor = Color.white;
		if (GUILayout.Button("Reset TPose!"))
		{ 
		
			example.TPose();
		}
		GUILayout.Space(20);
		GUI.contentColor = Color.yellow;
		if (GUILayout.Button("P all open & spread"))
			example.PoseSelect(1,1,1,1,1,1);
		if (GUILayout.Button("P natural"))
			example.PoseSelect(0.355f,0.95f,0.9f,0.86f,0.8f,-0.1f);
		if (GUILayout.Button("P fist"))
			example.PoseSelect(0.4f,0,0,0,0,-0.1f);
		if (GUILayout.Button("P OK"))
			example.PoseSelect(0.5f, 0.44f, 1.1f, 1.1f, 1.2f,0.43f);
		if (GUILayout.Button("P rock"))
			example.PoseSelect(-0.2f, 1.1f, 0.15f, 0.19f, 1.2f,0.43f);
		if (GUILayout.Button("P bang"))
			example.PoseSelect(1.1f, 1.1f, 1.1f, 0.0f, 0.0f,-0.63f);
		if (GUILayout.Button("P point"))
			example.PoseSelect(0.037f, 1.0f, 0.16f, 0.12f, 0.01f,-0.03f);
		if (GUILayout.Button("P peace"))
			example.PoseSelect(0.0f, 1.1f, 1.1f, 0.0f, 0.0f,1f);
		if (GUILayout.Button("P fuckyou"))
			example.PoseSelect(0.93f, 0.17f, 0.91f, 0.0f, 0.0f,-1f);
	
		if (GUILayout.Button("P grab"))
			example.PoseSelect(0.93f, 0.5f, 0.41f, 0.5f, 0.65f,-0.9f);
	
		
	}
	
	
	public void Label(Vector3 pos, string str){
		FingerGestures example = (FingerGestures)target;
		Handles.Label(example.transform.TransformPoint(pos), str);
	}
	
	protected virtual void OnSceneGUI()
	{
		FingerGestures example = (FingerGestures)target;
		//Debug.Log("osman");
		EditorGUI.BeginChangeCheck();
		///unutmamali
		//Handles.lineThickness = 10;
		//Handles.button XXXX
		Handles.Label(example.transform.position,"finger");

		
		
		//Handles.DrawWireCube(leftFootPosition, Vector3.one);
		//rotation olmayanlarin rotation handleini gosterme (bend, head vs.)

		if (EditorGUI.EndChangeCheck())
		{
			Undo.RecordObject(example, "Change Look At Target Position");
			
		
		
			//example.Update();
			
		}
	}
}
#endif