using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class MovementDuplicator : MonoBehaviour
{
    [System.Serializable]
    public class CloneLimb
    {
        public Transform source;
        public Transform target;
        public string name;
        public Vector3 prevPos;
        public Vector3 dpos;
    }

    public GameObject source;

    public bool getParts = false;

    public List<CloneLimb> cloneData;

    /*public List<Transform> sourceParts;
    public List<Transform> targetParts;*/
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void CreatePartList()
    {
        Transform[] sources = source.GetComponentsInChildren<Transform>();
        Transform[] targets = GetComponentsInChildren<Transform>();


        if (cloneData == null)
            cloneData = new List<CloneLimb>();
        else
            cloneData.Clear();

        for(int i = 0; i < targets.Length; i++)
        {
	        //if(targets[i].gameObject.name.Contains("mixamorig:"))
	        //{
                CloneLimb c = new CloneLimb();
                c.target = targets[i];
                c.name = c.target.gameObject.name;

                for(int j = 0; j < sources.Length; j++)
                {
                    if (sources[j].gameObject.name == c.name)
                    {
                        c.source = sources[i];
                        c.prevPos = sources[i].position;
                        cloneData.Add(c);
                    }
                }
	        //}
        }
    }

    void UpdateLimbs()
    {
        for(int i = 0; i < cloneData.Count; i++)
        {
            cloneData[i].target.rotation = cloneData[i].source.rotation;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (source == null) return;

        if (cloneData == null)
            CreatePartList();

        if(getParts)
        {
            Debug.Log("getting Parts");
            CreatePartList();
            getParts = false;
        }

        if(cloneData != null)
        {
            if (cloneData.Count > 0)
                UpdateLimbs();

            UpdateTargetPositions();
        }
    }


    void UpdateSourcePositions()
    {
        for(int i = 0; i < cloneData.Count; i++)
        {
            if (cloneData[i].source.gameObject.name.Contains("Hip"))
            {
                cloneData[i].prevPos = cloneData[i].source.parent.transform.position;
            }
        }
    }

    void UpdateTargetPositions()
    {
        for(int i = 0; i < cloneData.Count; i++)
        {
            if(cloneData[i].source.gameObject.name.Contains("Hip"))
            {
                cloneData[i].dpos = cloneData[i].source.parent.transform.position - cloneData[i].prevPos;
                gameObject.transform.Translate(cloneData[i].dpos);
                //if (cloneData[i].dpos.magnitude != 0)
                //    Debug.Log("hareket var");
            }
            
        }
    }

    private void LateUpdate()
    {
        UpdateSourcePositions();
    }
}
