using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Linq;

[ExecuteInEditMode]
public class FingerGestures : MonoBehaviour
{

    public class FingerJoint
    {
        public Transform transform;
        public Quaternion defaultRotation;

    }

    [SerializeField]
    public class Finger
    {
        public List<FingerJoint> joints;

    }
    
	public bool leftHand=true;
	private float leftHandCoeff=1f;
    
    [SerializeField]
    public List<Finger> fingers;
	[Range(0.0f, 1.1f)]
    public float grabThumb = 0.8f;
	[Range(0.0f, 1.1f)]
    public float grab1 = 0.6f;
	[Range(0.0f, 1.1f)]
    public float grab2 = 0.3f;
	[Range(0.0f, 1.1f)]
    public float grab3 = 0.1f;
	[Range(0.0f, 1.1f)]
    public float grab4 = 0.0f;

	[Range(-1f, 1.0f)]
    public float spread = 0.1f;

    public Vector3 targetExtendRotation = new Vector3(0, 0, 0);
	public Vector3 targetBendRotation = new Vector3( 0,0,35 );
	public Vector3 targetSpreadRotation = new Vector3(0, -25, 0);
	public Vector3 targetThumbSpreadRotation = new Vector3(-15, 0, 0);
	public Vector3 targetThumbBend = new Vector3(60, 0, 50);
    

    public Transform[] fingerTransforms;
	public bool active=false;
	public float speed = 1f;
	
	
	public float _grabThumb = 0.8f;
	public float _grab1 = 0.6f;
	public float _grab2 = 0.0f;
	public float _grab3 = 0.0f;
	public float _grab4 = 0.0f;
	public float _spread = 0.1f;
	
	public void PoseSelect(float gt,float g1,float g2,float g3,float g4, float s) {
		
		grabThumb =gt;
		grab1 = g1;
		grab2 = g2;
		grab3 = g3;
		grab4 = g4;
		spread = s;
		
	}

	public Animator animator;
	public float noiseAmp=0.01f;
	public float noiseFreq=0.5f;
	public float noisePhase = 1f;

	public void TPose()
	{

		if (!animator)
			return;
 
		var skeletons=animator.avatar?.humanDescription.skeleton;
     
		var root = animator.transform;
		var tfs = root.GetComponentsInChildren<Transform>();
		var dir = new Dictionary<string, Transform>(tfs.Count());
		foreach (var tf in tfs)
		{
			if (!dir.ContainsKey(tf.name))
				dir.Add(tf.name, tf);
		}
 
		foreach (var skeleton in skeletons)
		{
			if (!dir.TryGetValue(skeleton.name, out var bone))
				continue;
 
			bone.localPosition = skeleton.position;
			bone.localRotation = skeleton.rotation;
			//		bone.localScale = skeleton.scale;
		}
	}

    public FingerJoint AddJoint(Transform _transform)
    {
        FingerJoint jf = new FingerJoint();
        jf.transform = _transform;
        jf.defaultRotation = _transform.localRotation;

        return jf;
    }
	public void GetJoints() {
		
		fingers = new List<Finger>();
		foreach (Transform fingerTransform in fingerTransforms)
		{
			Finger finger = new Finger();
			finger.joints = new List<FingerJoint>();

			Transform[] children = fingerTransform.GetComponentsInChildren<Transform>();
			foreach (Transform child in children)
			{

				finger.joints.Add(AddJoint(child));
			}

			fingers.Add(finger);

		}
		
	}
	void OnEnable() {
	
		TPose();
		GetJoints();
	}

    void Start()
    {

	    TPose();
     GetJoints();

/*
        foreach (Finger finger in fingers)
        {
            foreach (FingerJoint joint in finger.joints)
                Debug.Log(joint.transform.name);
        }
        */
    }
	public float power=3.3f;
	public float jointNumCoeff=0.1f;
	// Update is called once per frame
    void LateUpdate()
    {
	    if  (!active)
	    	return;
	    	
	    	
	    _grab1=Mathf.Lerp(_grab1,grab1,Time.deltaTime*speed);
	    _grab2=Mathf.Lerp(_grab2,grab2,Time.deltaTime*speed);
	    _grab3=Mathf.Lerp(_grab3,grab3,Time.deltaTime*speed);
	    _grab4=Mathf.Lerp(_grab4,grab4,Time.deltaTime*speed);
	    _grabThumb=Mathf.Lerp(_grabThumb,grabThumb,Time.deltaTime*speed);
	    
	    
	    
        int mid = Mathf.CeilToInt(fingers.Count / 2);
  //      Debug.Log(mid);
	    int fingerNo = 0;
	    
	    if ( leftHand)
	    	leftHandCoeff = 1f;
	    else
	    	leftHandCoeff = -1f;
	    
	    
        foreach (Finger finger in fingers)
        {

            int jointNo = 0;
            foreach (FingerJoint joint in finger.joints)
            {
	           
                float grab = 0;
                if (fingerNo == 0)
	                grab = _grabThumb;
                if (fingerNo == 1)
	                grab = _grab1;
                if (fingerNo == 2)
	                grab = _grab2;
                if (fingerNo == 3)
	                grab = _grab3;
                if (fingerNo == 4)
	                grab = _grab4;
	
	            grab += (Mathf.PerlinNoise(0f,Time.time*noiseFreq+fingerNo/5.0f*noisePhase)-0.5f)*2*noiseAmp;
	            Quaternion bendRot =Quaternion.identity;
	            float bend = Mathf.Pow( 1+(jointNo+1)*jointNumCoeff,power)*1f;
	            
	            if (jointNo>0) 
		            bendRot = Quaternion.Euler(leftHandCoeff*targetBendRotation*(1-grab)*bend);               
	            
	            
	            if (fingerNo == 0 && jointNo>0)
			            bendRot = Quaternion.Euler(leftHandCoeff*targetThumbBend*bend*(1-grab));
	        
	            Quaternion spreadRot = Quaternion.identity;
		         
		        if (fingerNo == 0)
	                    spreadRot = Quaternion.Euler(leftHandCoeff*targetThumbSpreadRotation*spread );
			     
	            else 
	            	if (jointNo == 1)
		            {
			            if (fingerNo > mid)
				            spreadRot = Quaternion.Euler(leftHandCoeff*targetSpreadRotation*spread);
			            if (fingerNo == mid)
				            spreadRot =Quaternion.identity;
			            if (fingerNo < mid)
				            spreadRot = Quaternion.Euler(-leftHandCoeff*targetSpreadRotation * spread);
		            }
		      
	                Quaternion target = joint.defaultRotation * bendRot * spreadRot;
		            joint.transform.localRotation = joint.defaultRotation * bendRot * spreadRot;
	            
	            
                jointNo++;
            }


            fingerNo++;


        }

    }
}
