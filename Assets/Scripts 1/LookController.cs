using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RootMotion.FinalIK;

public class LookController : MonoBehaviour
{

	[System.Serializable]
	public class Expresion {
		
		public string name;
		public string idName;
		//	[HideInInspector]
		public int id;
		public bool repeat;
		public Vector2 valueMinMax;
	
		[HideInInspector]
		public float timer;
		public float waitTimer;
		
		[HideInInspector]
		public float duration;
		[HideInInspector]
		public float waitDuration;
		[HideInInspector]
		public bool playing;
		public Vector2 waitMinMax;
		public Vector2 durationMinMax;
		[HideInInspector]
		public float value;
		public AnimationCurve curve;
	
	}
	
	
	
	[Header("Expresions")]
	
	public Expresion[] expresions;
	
	[Header("Main")]
	
	public bool LookInterestingPoints = true;
	public bool autoGetIndexFromBodyGenerator= true;
	//	public BipedIK bipedIK;
	public LookAtIK lookAt;
	public HumanBodyGenerator bodyGenerator;

	
	[Header("Look System")]
	
	
	//	public Transform lookTargetController;
	public Vector3 headControllerPosition; 
	public Vector2 lookBoringDurationMinMax = new Vector2( 2f,4f);
	public Vector3 cameraOffset;
	public float headSmooth=5f;
	public float headWeightSmooth=5f;
	public LayerMask targetLayer;
	public float targetRadius = 2f;
	
	[Header("Head MicroMovement")]
	public float headTimer;
	public Vector2 headTimeMinMax = new Vector2(0,1);
	public float headFreq;
	public float headMovementAmp=1f;
	public float headDuration=0;
	public float headSideLookProbability= 0.5f;

	
	
	[Header("Eye MicroMovement")]
	
	public Transform lEye;
	public Transform rEye;
	
	
	public Vector2 m_eyeTimeMinMax = new Vector2(0,1);
	public 	float eyeRotationRange = 2f;
	
	
	[Header("Blink")]
	
	public Vector2 blinkMinMax = new Vector2(2f,4f);
	public string blinkBlendShapeName = "Blink";
	public int blinkID= -1;
	public float blinkStartValue = 40f;
	public float blinkSpeed=8f;



	

	[Header("Breath")]
	public string breathBlendShapeName = "Breathe";
	public string breathBellyBlendShapeName = "BreatheBelly";
	public int breathBellyID= -1;
	public int breathID = -1;
	public float breathAmp=30f;
	public float breathFreq=0.75f;

	/*[Header("Face Details")]
	public string DetailShapeName = "Flirting";
	public int detailID = -1;
	public float detailAmp=50f;
	public float detailFreq=0.75f;
	public float detailOffset=0f;
	*/
	
	
	
	[Header("Debug")]
	public bool showDebug=false;
	public float targetHeadWeight=1f;
	private float lookTargetWeight = 0f;
	private float _lookTargetWeight = 0f;
	public Vector3 lookPos;

	private  float lookBoringTimer = 0;
	private float lookBoringDuration; 
	//public int millet iste=0;
	

	private Vector3 m_eyeRandomRotation;
	private Quaternion lEyeDefaultRotation;
	private Quaternion rEyeDefaultRotation;
	
	private  float m_eyeTimer;

	private Collider[] targetColliders;
	public int lastTargetCount;
	private int targetIndex;
	private Transform targetTransform;
	private bool blink = false;
	private float blinkTimer = 0;
	private float blinkDuration = 0;
	public float headWeight=0.8f;
	public bool blinking = false;
	private Vector3 smoothVelocity;
	
	public List<Transform> targets;
	public List<Transform> oldTargets;
	
	public Vector2 headSmoothInBoring = new Vector2(0.4f,1f);
	public Vector2 headSmoothInNewTarget = new Vector2(0.2f,0.4f);
			
 
	void OnDrawGizmos() {
		
		Gizmos.color = Color.yellow;
		Gizmos.DrawSphere(headControllerPosition, 0.05f);
		if (targets!=null)
			foreach ( Transform _target in targets) 
				if (_target!=null )	
				Gizmos.DrawLine(lookAt.solver.head.transform.position,_target.position);
		
	}
	
	
	public void SenseInterestingPoints()
	{
		 targetColliders = Physics.OverlapSphere( lookAt.solver.head.transform.position, targetRadius, targetLayer);
		 targets.Clear();
		 
			 foreach ( Collider _target in targetColliders) {
			 float angle = Vector3.Angle(transform.forward, _target.transform.position - transform.position);
			 if ( angle<90f)
				 targets.Add(_target.transform);
		 
			 }
		
	
		
		if ( showDebug) {
		
			 foreach ( Transform _target in targets) 
				
				 Debug.DrawLine(lookAt.solver.head.transform.position,_target.position, Color.yellow);
			 // Debug.Log(_target.transform.name+" "+angle);
			
			}
			
		 if ( lookBoringTimer>lookBoringDuration) {
			 //	 Debug.Log("bored");
			  	
			 lookBoringTimer=0;
			 lookBoringDuration = Random.Range(lookBoringDurationMinMax.x,lookBoringDurationMinMax.y);
			 targetIndex= Random.Range(0,targets.Count);
			 if (targetIndex>=targets.Count)
				 targetIndex=0;
			 if ( Random.Range(0f,1f)>headSideLookProbability)
				 targetHeadWeight=headWeight;
			 else 
				 targetHeadWeight=headWeight*0.9f;
			 if (targets.Count>0 && targetIndex<targets.Count )
			 targetTransform = targets[targetIndex].transform;
			 PlayExpression("blink",Random.Range(0.2f,0.4f) );
			 

		 }
	
		 /*	 
		 if (  lastTargetCount < targets.Count) {
			 targetIndex = FindNewComing(targets, targetRadius);
			 lookBoringTimer=0;
			 headSmooth=Random.Range(0.2f,0.3f);
		 } */
		 if (  oldTargets.Count < targets.Count) {
			 targetIndex = FindNewComing(targets, oldTargets);
			 lookBoringTimer=0;
			 headSmooth=Random.Range(headSmoothInNewTarget.x,headSmoothInNewTarget.y);
			 PlayExpression("smile",3f);
			 //	 Debug.Log("newww"+targets[targetIndex].transform.name);
			 if (targets.Count>0 && targetIndex<targets.Count )
			
			 targetTransform = targets[targetIndex].transform;
		 }
		 
	
			 //Transform nearest = GetClosest (targets, targetRadius);
			 //Transform nearest = GetClosest (targets, targetRadius);
		 // Debug.Log(targets.Length);	
		 // Debug.Log(targets.Count+" "+lastTargetCount);
		 lastTargetCount = targets.Count;
		 
		 oldTargets = new List<Transform>(targets);
		 
	 }


	public Transform GetClosest(List<Transform>  enemies, float radius)
	{
		Transform closest = null;
		float minDist = radius;
		Vector3 currentPos = lookAt.solver.head.transform.position;
		foreach (Transform c in enemies)
		{
					Transform t = c;
					float dist = Vector3.Distance(t.position, currentPos);
				if (dist >minDist)
					{
						closest = t;
						minDist = dist;
					}
				}
			
		
		return closest;
	}
	
	
	public int FindNewComing(List<Transform> _listOne, List<Transform> _listTwo)
	{
		int index=0;
		foreach (Transform _GO in _listOne)
		{
			if (!_listTwo.Contains(_GO))
				return index ;
			index++;	
		}
		return -1;
	}
	
	/*	public int FindNewComing(List<Transform> enemies, float radius)
	{
		int distantIndex = -1;
		float maxDist = 0;
		Vector3 currentPos = transform.position;
		int index=0;
		foreach (Transform t in enemies)
		{
	
			float dist = Vector3.Distance(t.position, currentPos);
			Debug.Log(" "+targets[index].name+  " " + dist);
		
			if (dist > maxDist)
			{
				distantIndex = index;
				maxDist = dist;
			}
			index++;
		}
			
		if ( distantIndex>0)
			Debug.Log("new come:"+targets[distantIndex].transform.name+ " " +distantIndex);
		
		return distantIndex;
	}
	
	*/
	
	void Start()
	{
		if ( lookAt!=null)
		InvokeRepeating("SenseInterestingPoints", 0, 0.1f);

		
		if ( autoGetIndexFromBodyGenerator) {
		blinkID = bodyGenerator.GetBlendShapeIndexByName(blinkBlendShapeName);
		breathID = bodyGenerator.GetBlendShapeIndexByName(breathBlendShapeName);
		breathBellyID= bodyGenerator.GetBlendShapeIndexByName(breathBellyBlendShapeName);
		
		
			foreach ( Expresion e in expresions) {
				e.id = bodyGenerator.GetBlendShapeIndexByName(e.idName);
			
			}
		
		}
		
		
		
		StartCoroutine(Blink());
		
		
		lEyeDefaultRotation = lEye.localRotation;
		rEyeDefaultRotation = rEye.localRotation;
	}



	IEnumerator _PlayExpression (Expresion expression)
	{
		//Debug.Log(expression.name);
	
		if (expression.playing)
			yield break;
		expression.playing=true;
	 	
		expression.timer = 0;
		expression.duration = Random.Range(expression.durationMinMax.x,expression.durationMinMax.y);
		while (expression.timer < expression.duration)
		{
			expression.timer += Time.deltaTime;
			expression.value = expression.valueMinMax.x + expression.curve.Evaluate(expression.timer/expression.duration )*(expression.valueMinMax.y-expression.valueMinMax.x);
			bodyGenerator.SetBlendShapeWeight (expression.id, expression.value);
			yield return null;
		}
		
		bodyGenerator.SetBlendShapeWeight (blinkID, blinkStartValue);
		expression.playing = false;
	}

	IEnumerator Blink ()
	{
		
		if (blinking)
			yield break;
		blinking=true;
	 	
		//old
		//skinnedMeshRenderer.SetBlendShapeWeight (blinkID, 100);
		//new 
		bodyGenerator.SetBlendShapeWeight(blinkID, 100);
		yield return new WaitForSeconds(0.1f);
			
		float t = 0;
 		
		while (t < 1)
		{
			t += Time.deltaTime*blinkSpeed;
			float angle = Mathf.Lerp(100f, blinkStartValue, t );
			//skinnedMeshRenderer.SetBlendShapeWeight (blinkID, angle);

			yield return null;
		}
		
		//skinnedMeshRenderer.SetBlendShapeWeight (blinkID, blinkStartValue);
		bodyGenerator.SetBlendShapeWeight (blinkID, blinkStartValue);
		blinking = false;
	}
	
	public float maxSpeed=10f;
	
	
	public void PlayExpression(string s, float duration) {
		
		foreach ( Expresion e in expresions) {
			if ( e.name== s ) {
				e.duration = duration;
				StartCoroutine(_PlayExpression(e));
			}
		}
		
	}
	
	public void PlayExpression(string s) {
		
		foreach ( Expresion e in expresions) {
			if ( e.name== s ) {

				StartCoroutine(_PlayExpression(e));
			}
		}
		
	}

    // Update is called once per frame
	void Update()
	{
		
		if (Input.GetKeyDown("s")) 
			PlayExpression("smile");
		if (Input.GetKeyDown("b")) 
			PlayExpression("brows height");
		if (Input.GetKeyDown("a")) 
			PlayExpression("brows arch");
		
		
		foreach ( Expresion e in expresions) {
			if ( e.repeat) {
				
				if ( e.waitTimer>e.waitDuration ) {
	    	
					 e.waitTimer=0;
					e.waitDuration = Random.Range(e.waitMinMax.x,e.waitMinMax.y);
		
	    			StartCoroutine(_PlayExpression(e));StartCoroutine(Blink());
				}
				e.waitTimer +=Time.deltaTime;
	

				
			}
		}
		
		if (breathID>-1) {
			bodyGenerator.SetBlendShapeWeight (breathID, 50+breathAmp*Mathf.Sin(Time.time*breathFreq*2*Mathf.PI) );
			bodyGenerator.SetBlendShapeWeight (breathBellyID, 50+breathAmp*Mathf.Sin(Time.time*breathFreq*2*Mathf.PI) );
	
		}
		
		if ( lookAt!=null) {
			if ( LookInterestingPoints &&  targets.Count>0 && targetTransform != null)
			{
		
				lookPos = lookAt.solver.head.transform.position+ (  targetTransform.position -lookAt.solver.head.transform.position).normalized*0.5f;
				lookTargetWeight =1f;
				if ( showDebug)
					Debug.DrawLine(lookAt.solver.head.transform.position,targetTransform.position, Color.red);
				headControllerPosition =  Vector3.SmoothDamp(headControllerPosition,lookPos+cameraOffset,ref smoothVelocity,headSmooth);
			    
				//lookAt.solver.target= headController;
			    lookBoringTimer+=Time.deltaTime;
			  
			   
			} else 
				lookTargetWeight =0f;
	
	
			_lookTargetWeight= Mathf.Lerp(_lookTargetWeight, lookTargetWeight,Time.deltaTime*headWeightSmooth);
			lookAt.solver.IKPositionWeight=_lookTargetWeight;
			lookAt.solver.headWeight=Mathf.Lerp(lookAt.solver.headWeight, targetHeadWeight,Time.deltaTime*headWeightSmooth);;
		}
		
	    if ( blinkTimer>blinkDuration ) {
	    	
		    blinkTimer=0;
	    	blinkDuration = Random.Range(blinkMinMax.x,blinkMinMax.y);
		
	    	
	    	StartCoroutine(Blink());
	    }
	    blinkTimer +=Time.deltaTime;
	    

	}
    
	public  float Remap ( float value, float from1, float to1, float from2, float to2) {
		return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
	
	}

	public Vector2 remapMinMaxRotation = new Vector2(-0.1f,0.1f);
	public Vector2 remapMinMaxBlink = new Vector2(0f,100f);
	

	
	void LateUpdate () {
		
		
		
		if ( !blinking) {
			Quaternion r= lEye.localRotation;
			float angle =r.ToEuler().x;
			angle = (angle > 180) ? angle - 360 : angle;
			angle = Remap(angle,remapMinMaxRotation.x,remapMinMaxRotation.y,remapMinMaxBlink.x,remapMinMaxBlink.y);
			angle = Mathf.Clamp(angle,0,100);
			bodyGenerator.SetBlendShapeWeight(blinkID, angle);
			//	Debug.Log(blinkStartValue + " " + angle);
		}
		
		
		if ( lEye!=null)
			lEye.localRotation = Quaternion.Euler(m_eyeRandomRotation)* lEye.localRotation;
		if ( rEye!=null)
			rEye.localRotation = Quaternion.Euler(m_eyeRandomRotation)* rEye.localRotation;
	
	
		if ( m_eyeTimer<0) {
			m_eyeRandomRotation =  new Vector3(Random.Range(-eyeRotationRange,eyeRotationRange),Random.Range(-eyeRotationRange,eyeRotationRange),Random.Range(-eyeRotationRange,eyeRotationRange));
			m_eyeTimer=Random.Range(m_eyeTimeMinMax.x,m_eyeTimeMinMax.y);
			   
		}
		m_eyeTimer-=Time.deltaTime;
	
		
		
	}
}
