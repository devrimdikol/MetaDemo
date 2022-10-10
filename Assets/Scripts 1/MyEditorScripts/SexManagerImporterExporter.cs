using UnityEditor;
using UnityEngine;
using Assets.MyEditorScripts.ImporterExporter;
using System.IO;
using System.Linq;
using System.Collections.Generic;

#if UNITY_EDITOR
[CustomEditor(typeof(SexManager)), CanEditMultipleObjects]
public class SexManagerImporterExporter : Editor
{
    int SelectedSexPosition = 0;
    string[] SexPositions;
	string JsonFilePath = string.Empty;

    public SexManagerImporterExporter()
    {
        PopulateFiles();
    }

    public void PopulateFiles()
    {
        var sex_position_files = Directory.EnumerateFiles("SexPositions", "*.json").ToList();

        var SexPositionsList = new List<string>();

        SexPositions = new string[sex_position_files.Count];

        for (int i = 0; i < sex_position_files.Count; i++)
        {
            SexPositionsList.Add(sex_position_files[i]);
        }

        SexPositions = SexPositionsList.ToArray();
    }


	public void ShowExplorer(string itemPath)
	{
		itemPath = itemPath.Replace(@"/", @"\");   // explorer doesn't like front slashes
		System.Diagnostics.Process.Start("explorer.exe", "/select,"+itemPath);
	}
	
    public override void OnInspectorGUI()
	{
        SexManager sex_manager = (SexManager)target;

		DrawDefaultInspector();

		GUILayout.Space(50);

		GUI.contentColor = Color.white;
		
        EditorGUI.BeginChangeCheck();
		sex_manager.path = EditorGUILayout.TextField("JSON File", sex_manager.path);

	
        if (EditorGUI.EndChangeCheck())
        {
            JsonFilePath = sex_manager.path;
        }
		JsonFilePath = sex_manager.path;

        GUILayout.Space(10);

		if (GUILayout.Button("SAVE position"))
		{            
            SexManagerExchangeFormat smef = new SexManagerExchangeFormat(sex_manager);

			if (JsonFilePath.Length != 0)
			{
                if (!JsonFilePath.Contains(".json"))
                {
                    JsonFilePath = $"{JsonFilePath}.json";
                }

                if(!JsonFilePath.Contains("SexPositions"))
                {
                    smef.Save($"SexPositions/{JsonFilePath}");
                }
                else
                {
                    smef.Save(JsonFilePath);
                }
                
				PopulateFiles();
				Debug.Log($"{JsonFilePath} exported...");
				//EditorUtility.DisplayDialog("Result", $"{JsonFilePath} exported...", "Yes");
			}
		}

		GUILayout.Space(10);
		if (GUILayout.Button("LOAD  position"))
		{
            Debug.Log(JsonFilePath);

			if (JsonFilePath.Length != 0)
			{
                if(!JsonFilePath.Contains(".json"))
                {
                    JsonFilePath = $"{JsonFilePath}.json";
                }

                var full_path = string.Empty;

                if(!JsonFilePath.Contains("SexPositions"))
                {
                    full_path = $"SexPositions/{JsonFilePath}";
                }
                else
                {
                    full_path = JsonFilePath;
                }

                Debug.Log(full_path);

                if(!File.Exists(full_path))
                {
                    Debug.LogError($"{JsonFilePath} could not be found");
                    return;
                }

				sex_manager.Import(full_path);
			}
		}
	
	
		if (GUILayout.Button("Reset/Relax"))
		{
			for (int j = 0; j < sex_manager.personas.Length; j++)
			{
				sex_manager.personas[j].TPose();
			}
		}
		
		if (GUILayout.Button("Show  Explorer"))
		{
			Debug.Log(JsonFilePath);
			if(!JsonFilePath.Contains("SexPositions"))
			{
				ShowExplorer("SexPositions/" );
			} else
			
			if (JsonFilePath=="" )
				ShowExplorer("SexPositions/" );
			else
				ShowExplorer(JsonFilePath);
		}
		GUILayout.Space(20);
        
		GUI.contentColor = Color.red;
	
		if (GUILayout.Button("Hard Reset position ( Erase all DATA ) "))
		{
			sex_manager.frequencyCurve = new AnimationCurve();
			sex_manager.noiseAmp = 0.0f;
			sex_manager.noiseFreq = 0.0f;
			sex_manager.showGizmos = false;
			sex_manager.gizmoRadius = 0.0f;
			sex_manager.sexDuration = 0;
			sex_manager.ragdollNoParentAtClimax = false;
			sex_manager.climaxDuration = 0.0f;
			sex_manager.climaxForceMinMax = Vector2.zero;
			sex_manager.climaxForce = 0.0f;
			sex_manager.actuators = new SexManager.Actuator[0];

			for (int j = 0; j < sex_manager.personas.Length; j++)
			{
				sex_manager.personas[j].ResetPosition();
				sex_manager.personas[j].TPose();
				sex_manager.personas[j].anchors = new Body.Anchor[0];   
				sex_manager.personas[j].transform.localPosition = Vector3.zero;
				sex_manager.personas[j].transform.localRotation = Quaternion.identity ;
	            
			}
		}
		GUI.contentColor = Color.white;
		GUILayout.Space(20);
        EditorGUI.BeginChangeCheck();

        this.SelectedSexPosition = EditorGUILayout.Popup("Select Position", SelectedSexPosition, SexPositions);

        if (EditorGUI.EndChangeCheck())
        {
            var path2 = SexPositions[SelectedSexPosition];

            if (path2.Length != 0)
            {               
	            sex_manager.Import($"{path2}");
	            sex_manager.path = path2.Replace("SexPositions\\",string.Empty).Replace(".json",string.Empty);
	            JsonFilePath = path2;
            }
        }
    }

    public Transform SearchHierarchyForBone(Transform current, string name)
    {
        if (name == "")
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
}

#endif
