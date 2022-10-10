using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using Assets.MyEditorScripts.ImporterExporter;
using System.Linq;

public class SexManager : MonoBehaviour
{
	
	[System.Serializable]
	public enum PersonaType { active, passive, third, none }

	[System.Serializable]
	public class Actuator {
		
		public PersonaType personaType = PersonaType.none;
		public Body.ControlType PositionHandletarget= Body.ControlType.pelvis;



		public Transform target;

		public bool active=true;
		[HideInInspector]
		public Vector3 defaultPosition;
		//[HideInInspector]

		[HideInInspector]
		public Quaternion defaultRotation;
		public Vector3 minAngle;
		public Vector3 maxAngle;
		public Vector3 minPosition;
		public Vector3 maxPosition;

		public float freq;
		public float phaseShift;
		public AnimationCurve curve;			
		[HideInInspector]
		public float _forwardmax ;

		[HideInInspector]
		
		public float t;
		
		
		[HideInInspector]
		public Vector3 pos;
		[HideInInspector]
		public Quaternion rot;
		

		
	
	}
	
	[Header("Personas")]
	[Header("- sira onemli, 0: erkek/aktif 1: kadın/pasif 2:yanci")]
	
	[SerializeField]
	public Body[] personas;
	
	[Header("Actuators")]
	
	
	[SerializeField]
	public Actuator[] actuators;

	
	
		

		private float freq=1f;

	[Header("Settings")]
	public AnimationCurve frequencyCurve;
	private int hitCount=0;
	public float noiseAmp = 0f;
	public float noiseFreq = 1f;
	
	public bool showGizmos= false;
	
	public float gizmoRadius = 0.1f;
	//[Range(0,1)]
	//	public float hipWeight = 0f;
	[HideInInspector]
	public int finishState = 0;
	public bool ragdollNoParentAtClimax = true;
	public float sexDuration = 5f;
	public float currentTime;
	public string path;// = string.Empty;
	public void Reset() {
		
		hitCount =0;
		finishState =0;
		freq = 1f;
		foreach (Body persona in personas) {
			persona.ChangeMotionState(Body.MotionType.bipedIK);
			if (persona.ragdollMaster!=null)
				persona.ragdollMaster.GetRagDollTransforms(persona.ragdollMaster.ragdollRootBone);
			persona.TPose();
		}
		
	}
	
	public void Init() {
		
		foreach ( Actuator actuator in actuators)
		{
				
			actuator.t=0;
				
			if ( actuator.personaType==PersonaType.none) {
					
				actuator.defaultPosition=actuator.target.localPosition;
				actuator.defaultRotation=actuator.target.localRotation;
					
			} else {
				int personaID = (int) actuator.personaType; 
	
				actuator.defaultPosition = personas[personaID].GetHandlePosition(actuator.PositionHandletarget);
				actuator.defaultRotation = personas[personaID].GetHandleRotation(actuator.PositionHandletarget);
				
				
					
			}
		}
		Reset();
	}
	
	void Start ()
	{
		
		
		
        
	}

	// Update is called once per frame

	
	void OnDrawGizmosSelected()
	{

		if (!showGizmos)
			return;
		foreach ( Actuator actuator in actuators) if (actuator!=null && actuator.target!=null &&  actuator.active ){
	
			// Draw a yellow sphere at the transform's position
			Gizmos.color = Color.red;
			Gizmos.DrawSphere(actuator.target.position, gizmoRadius);
		
			
			Gizmos.color = Color.white;
			Gizmos.DrawSphere(actuator.target.position, gizmoRadius);
			Gizmos.color = Color.gray;
			Gizmos.DrawLine(actuator.target.position+actuator.target.forward*actuator.minPosition.z, actuator.target.position);
			Gizmos.color = Color.yellow;
			Gizmos.DrawSphere(actuator.target.position+actuator.target.forward*actuator.maxPosition.z, gizmoRadius/2.0f);
			Gizmos.DrawLine(actuator.target.position+actuator.target.forward*actuator.maxPosition.z, actuator.target.position);
			
			Gizmos.DrawSphere(actuator.defaultPosition+actuator.target.forward*actuator.maxPosition.z, gizmoRadius/2.0f);
		}
		
	}
	
	void Finish() {
		
		foreach (Body persona in personas) {
			persona.ChangeMotionState(Body.MotionType.ragdoll);
		}
	}
	
	public float climaxDuration = 1f;
	public Vector2 climaxForceMinMax = new Vector2(-0.15f,0.15f);
	
	public float climaxForce =0.1f;
	

	private IEnumerator Climax()
	{
		
		Finish();
		float elapsedTime = 0f;
		
		foreach (Body persona in personas) {
			//	if ( ragdollNoParentAtClimax)
				//			persona.ragdollMaster.ragdollRootBone.parent = null;
		 
			Rigidbody[] rigidbodies = persona.ragdollMaster.ragdollRootBone.GetComponentsInChildren<Rigidbody>();
			foreach (Rigidbody child in rigidbodies) 
			{
				child.velocity = Vector3.zero;
				child.angularVelocity =  Vector3.zero;
				//child.rigidbody.AddForce (Vector3.up * 1000);
			}    
		}
		
		
		
		while (elapsedTime < climaxDuration)
		{
			elapsedTime += Time.fixedDeltaTime;
			//spine yukarı
			//kafa havaya baksın
			foreach (Body persona in personas) {
				Rigidbody r = persona.ragdollMaster.transforms[persona.headID].GetComponent<Rigidbody>();
				Vector3 force =  Vector3.up*climaxForce;// persona.ragdollMaster.transforms[persona.headID].up*climaxForce;
						r.AddForce(force, ForceMode.VelocityChange);
				persona.UpdateRagdollAnchors();

			}

			
			yield return null;
		} 
		foreach (Body persona in personas) {
		
			Rigidbody[] rigidbodies = persona.ragdollMaster.ragdollRootBone.GetComponentsInChildren<Rigidbody>();
			foreach (Rigidbody child in rigidbodies) 
			{
				child.velocity = Vector3.zero;
				child.angularVelocity =  Vector3.zero;
				//child.rigidbody.AddForce (Vector3.up * 1000);
			}    
		}
		
	 elapsedTime = 0f;
		
		while (elapsedTime < climaxDuration)
		{
			elapsedTime += Time.fixedDeltaTime;
			//spine yukarı
			//kafa havaya baksın
			foreach (Body persona in personas) {
				Rigidbody r = persona.ragdollMaster.transforms[persona.headID].GetComponent<Rigidbody>();
				Vector3 force =  Vector3.up*climaxForce;// persona.ragdollMaster.transforms[persona.headID].up*climaxForce;
				r.AddForce(force, ForceMode.VelocityChange);
		
				r = persona.ragdollMaster.transforms[persona.pelvisID].GetComponent<Rigidbody>();
				force = - persona.ragdollMaster.transforms[persona.pelvisID].forward*climaxForce;// persona.ragdollMaster.transforms[persona.headID].up*climaxForce;
				r.AddForce(force, ForceMode.VelocityChange);
		

			}
		
			yield return null;
		}				
	}
	
	void LateUpdate()
	{
		if (finishState==2) {
			return;
		}
		foreach ( Body  persona in personas )
		
			persona.UpdateAnchors();
			
			
		foreach ( Actuator actuator in actuators) {
	
			bool anchored = false;
			int personaID = (int) actuator.personaType; 
						
			if ( actuator.personaType != PersonaType.none)
			foreach ( Body.Anchor anc in personas[personaID].anchors )
				if ( anc.handle == actuator.PositionHandletarget) {
					anchored= true;
					Debug.Log( anc.handle.ToString());
				}
			
			if ( !anchored) {
			actuator.pos = actuator.defaultPosition;
			actuator.rot = actuator.defaultRotation;
			} else {
				
				actuator.pos = personas[personaID].pos[(int)actuator.PositionHandletarget];
				actuator.rot = actuator.defaultRotation;
		
			}

			
		}
	
		//	Debug.Log( hitCount);
	
		foreach ( Actuator actuator in actuators) {
	
    	
		
			actuator.t += Time.deltaTime*freq*actuator.freq  ;
			if ( actuator.t>1) {
				actuator.t=0f;
				hitCount++;
				freq = 1+frequencyCurve.Evaluate(currentTime/sexDuration);
				
				if ( finishState==0 )
				if (currentTime>sexDuration) {
					finishState=1;
					
				}
			}

			if ( finishState==1 && actuator.t>0.5f ) {
				finishState=2;
				//StartCoroutine(Climax());
				
			}
			    
			    
			if ( actuator.active) {
				float forceVariation = 1f;
					
		
				actuator.pos +=  actuator.minPosition+ actuator.curve.Evaluate(actuator.t + actuator.phaseShift)*(actuator.maxPosition-actuator.minPosition);
				Quaternion rot=Quaternion.Euler(actuator.minAngle+actuator.curve.Evaluate(actuator.t+actuator.phaseShift)*(actuator.maxAngle-actuator.minAngle));
					
				actuator.rot = rot*actuator.rot;
					
					
				Vector3 noise = new Vector3( noiseAmp*((Mathf.PerlinNoise(Time.time*noiseFreq, 0f)-0.5f) *2f ),
					noiseAmp*((Mathf.PerlinNoise(Time.time*noiseFreq*1.1f, 0.3f)-0.5f) *2f ),
					noiseAmp*((Mathf.PerlinNoise(Time.time*noiseFreq*1.2f, 0.5f)-0.5f) *2f ));
						
					
					
						
						
				if ( actuator.personaType==PersonaType.none) {
					
					actuator.target.localPosition = actuator.pos;
					actuator.target.localRotation = actuator.rot;
					actuator.target.position += noise;
					
				} else {
					int personaID = (int) actuator.personaType; 
						
					personas[personaID].SetHandleRotation(actuator.PositionHandletarget,  actuator.rot );
						
					actuator.pos +=personas[personaID].transform.InverseTransformVector(noise );
					personas[personaID].SetHandlePosition(actuator.PositionHandletarget, actuator.pos );
				
				
				}		
						
					
			}
			    
		}
		
		
		
        
	}

	public void Import(string sex_position_name)
    {
		SexManagerExchangeFormat smef = new SexManagerExchangeFormat();
		    //		smef.Load($"SexPositions/{sex_position_name}");
	    smef.Load($"{sex_position_name}");

		#region LOAD GLOBAL VARS

		frequencyCurve = smef.FrequencyCurve;
		noiseAmp = smef.NoiseAmp;
		noiseFreq = smef.NoiseFreq;
		showGizmos = smef.ShowGizmos;
		gizmoRadius = smef.GizmoRadius;
		sexDuration = smef.sexDuration;
		ragdollNoParentAtClimax = smef.RagdollNoParentAtClimax;
		climaxDuration = smef.ClimaxDuration;
		climaxForceMinMax = smef.ClimaxForceMinMax;
		climaxForce = smef.ClimaxForce;

		#endregion

		#region LOAD ACTUATORS

		actuators = new SexManager.Actuator[smef.Actuators.Length];

		for (int i = 0; i < smef.Actuators.Length; i++)
		{
			var actuator = smef.Actuators[i];
			actuators[i] = new SexManager.Actuator();
			actuators[i].personaType = actuator.PersonaType;
			actuators[i].PositionHandletarget = actuator.PositionHandleTarget;
			actuators[i].target = actuator.Target;
			actuators[i].active = true;
			actuators[i].defaultPosition = actuator.DefaultPosition;
			actuators[i].defaultRotation = actuator.DefaultRotation;
			actuators[i].minAngle = actuator.MinAngle;
			actuators[i].maxAngle = actuator.MaxAngle;
			actuators[i].minPosition = actuator.MinPosition;
			actuators[i].maxPosition = actuator.MaxPosition;
			actuators[i].freq = actuator.Freq;
			actuators[i].phaseShift = actuator.PhaseShift;
			actuators[i].curve = actuator.Curve;
			actuators[i]._forwardmax = actuator.ForwardMax;
			actuators[i].t = actuator.T;
			actuators[i].pos = actuator.Pos;
			actuators[i].rot = actuator.Rot;
		}

		#endregion

		#region LOAD PERSONAS

		for (int i = 0; i < personas.Length; i++)
		{
			personas[i].gameObject.transform.position = transform.position + smef.Personas[i].ModelPosition;
			personas[i].gameObject.transform.rotation = smef.Personas[i].ModelRotation;

			personas[i].activeControlType = smef.Personas[i].ActiveControlType;
			personas[i].motionType = smef.Personas[i].MotionType;

			#region LOAD ANCHORS

			personas[i].anchors = new Body.Anchor[smef.Personas[i].Anchors.Length];

			for (int a = 0; a < smef.Personas[i].Anchors.Length; a++)
			{
				personas[i].anchors[a] = new Body.Anchor();
				personas[i].anchors[a].handle = smef.Personas[i].Anchors[a].Handle;
				personas[i].anchors[a].anchorPerson = smef.Personas[i].Anchors[a].AnchorPerson;
				personas[i].anchors[a].relativePos = smef.Personas[i].Anchors[a].RelativePos;

				var anchor_name = smef.Personas[i].Anchors[a].Anchor;
				var anchor_person = personas[i].anchors[a].anchorPerson;

				if (anchor_person == Body.AnchorPerson.Self)
				{
					var bone = personas[i].SearchHierarchyForBone(personas[i].gameObject.transform, anchor_name);
					personas[i].anchors[a].anchorTransform = bone;
					personas[i].anchors[a].transformName = anchor_name;
				}
				else if (anchor_person == Body.AnchorPerson.FirstPartner)
				{
					var other_persona = personas.FirstOrDefault(x => x != personas[i]);

					if (other_persona != null)
					{
						var bone = personas[i].SearchHierarchyForBone(other_persona.gameObject.transform, anchor_name);
						personas[i].anchors[a].anchorTransform = bone;
						personas[i].anchors[a].transformName = anchor_name;

					}
				}
			}

			#endregion

			#region LOAD POSITIONS

			for (int k = 0; k < personas[i].pos.Length; k++)
			{
				personas[i].pos[k] = smef.Personas[i].Positions[k];
			}

			#endregion

			#region LOAD ROTATIONS

			for (int l = 0; l < personas[i].rot.Length; l++)
			{
				personas[i].rot[l] = smef.Personas[i].Rotations[l];
			}

			#endregion
			
			for (int j = 0; j < personas.Length; j++)
			{
				personas[j].ResetIK();
		    
			}
		}
		
	    

		#endregion
	}
}
