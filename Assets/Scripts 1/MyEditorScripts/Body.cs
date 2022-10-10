using UnityEngine;
using System.Collections.Generic;
using System.Linq;

using RootMotion.FinalIK;
//using FIMSpace.BonesStimulation;

//using RootMotion.Dynamics;
//[ExecuteInEditMode]

[SelectionBase]
public class Body: MonoBehaviour
{
	

	/*
	public Transform leftFoot;
	public Transform rightFoot;
	public Transform leftFootBend;
	public Transform rightFootBend;
	public Transform pelvis;
	public Transform spine;
	public Transform head;
	public Transform leftHand;
	public Transform rightHand;
	public Transform leftHandBend;
	public Transform rightHandBend; */


	public enum ControlType {head,pelvis,spine,lHand,lHandBend,rHand,rHandBend,lFoot,lFootBend,rFoot,rFootBend}
	public enum MotionType {animation,bipedIK,ragdoll}

	[HideInInspector]
	public int headID=0;
	[HideInInspector]
	public int pelvisID=1;
	[HideInInspector]
	public int spineID=2;
	[HideInInspector]
	public int lHandID=3;
	[HideInInspector]
	public int lHandBendID=4;
	[HideInInspector]
	public int rHandID=5;
	[HideInInspector]
	public int rHandBendID=6;
	[HideInInspector]
	public int lFootID=7;
	[HideInInspector]
	public int lFootBendID=8;
	[HideInInspector]
	public int rFootID=9;
	[HideInInspector]
	public int rFootBendID=10;
	
	public enum AnchorPerson
    {
		Self = 0,
		FirstPartner,
		SecondPartner
    }

	[System.Serializable]
	public class Anchor {
		public ControlType handle;
		
		public Transform anchorTransform;

		public AnchorPerson anchorPerson;
		public string transformName;
		[HideInInspector]
		public Vector3 relativePos;
	}

	[Header("SETUP")]

	
	public Transform characterRootTransform;
	public Animator animator;
	public Color handleColor = Color.white;

	public bool autoinstall_IKComponents_AtStart = true;
	
	public MotionType motionType;
	
	[Header("RAGDOLL")]
	public RagdollMaster ragdollMaster;
	public bool ragdollAnchors=false;
	public float forceWeight=1f;
	public float torqueWeight=1f;

	[Space(10)]

	[Header("ANCHORS")]
	[SerializeField]
	public Anchor[] anchors; 
	
	[HideInInspector]
	public Vector3[] pos = new Vector3[11];
	[HideInInspector]
	public Quaternion[] rot  = new Quaternion[11];

	//public bool fullBodyBipedIK = false;
	
	[Space(10)]
		
[HideInInspector] public Vector3 leftFootPosition;
[HideInInspector] public Quaternion leftFootRotation;
[HideInInspector] public Vector3 rightFootPosition;
[HideInInspector] public Quaternion rightFootRotation;
[HideInInspector] public Vector3 leftFootBendPosition;
[HideInInspector] public Vector3  rightFootBendPosition;
[HideInInspector] public Vector3 pelvisPosition;
[HideInInspector] public Quaternion pelvisRotation;

[HideInInspector] public Vector3 spinePosition;
[HideInInspector] public Quaternion spineRotation;

[HideInInspector] public Vector3 headPosition;
[HideInInspector] public Quaternion headRotation;

[HideInInspector] public Vector3 rightHandPosition;
[HideInInspector]	public Quaternion rightHandRotation;

[HideInInspector]	 public Vector3 leftHandPosition;
[HideInInspector]	public Quaternion  leftHandRotation;

[HideInInspector]	public Vector3 rightHandBendPosition;

[HideInInspector]	public Vector3 leftHandBendPosition;
	


	[Header("AUTOSETUP do not touch")]

	public GameObject ControlGameObject;
	public Transform pelvisControl;
	
	public bool IKSetup = false;
	public bool ragdollSetup = false;
	public LookController lookController;
	
	

	[HideInInspector]
	public  bool active = false;
	public BipedIK bipedIK;// { get; private set; }
	public LookAtIK lookAt;// { get; private set; }
	public ControlType activeControlType;
	
	void OnApplicationQuit()
	{
		TPose();
	}
	
	public Vector3 GetHandlePosition(ControlType handle) {
		
		return pos[(int) handle];
		
	}
	
	public Quaternion GetHandleRotation(ControlType handle) {

		return rot[(int) handle];

	}
	
	public void SetHandlePosition(ControlType handle, Vector3 _pos) {

		pos[(int) handle] = _pos;
		
	}
	
	public void SetHandleRotation(ControlType handle, Quaternion _rot ) {
	
		rot[(int) handle] = _rot;
		
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
 
 
 
 
 
	public GameObject fullBodyGameObject;
	public FullBodyBipedIK fullbodyIK;
	

	
	public void  InstallFullIKComponents() {
		
		if (!transform.Find("FullBodyIK") ) {
			
			fullBodyGameObject = new GameObject("FullBodyIK");
			fullBodyGameObject.transform.parent=transform;
			
			
		} else fullBodyGameObject =transform.Find("FullBodyIK").gameObject;
		
	
		fullbodyIK = fullBodyGameObject.GetComponent<FullBodyBipedIK>();
		if ( fullbodyIK==null)
			fullbodyIK = fullBodyGameObject.AddComponent<FullBodyBipedIK>();
			
		fullbodyIK.references.root=characterRootTransform; 
		/*
		fullbodyIK.references.pelvis= SearchHierarchyForBone(transform,"hip");
			
		fullbodyIK.references.leftThigh= SearchHierarchyForBone(transform,"lThighBend");
		fullbodyIK.references.leftCalf= SearchHierarchyForBone(transform,"lShin");
		fullbodyIK.references.leftFoot= SearchHierarchyForBone(transform,"lFoot");
			
		fullbodyIK.references.rightThigh= SearchHierarchyForBone(transform,"rThighBend");
		fullbodyIK.references.rightCalf= SearchHierarchyForBone(transform,"rShin");
		fullbodyIK.references.rightFoot= SearchHierarchyForBone(transform,"rFoot");
	
	
		fullbodyIK.references.leftUpperArm= SearchHierarchyForBone(transform,"lShldrBend");
		fullbodyIK.references.leftForearm= SearchHierarchyForBone(transform,"lForearmBend");
		fullbodyIK.references.leftHand= SearchHierarchyForBone(transform,"lHand");
	
		fullbodyIK.references.rightUpperArm= SearchHierarchyForBone(transform,"rShldrBend");
		fullbodyIK.references.rightForearm= SearchHierarchyForBone(transform,"rForearmBend");
		fullbodyIK.references.rightHand= SearchHierarchyForBone(transform,"rHand");
			
			
		fullbodyIK.references.head= SearchHierarchyForBone(transform,"head");
			
		fullbodyIK.references.spine = new Transform[ 2 ];
		fullbodyIK.references.spine[0] =  SearchHierarchyForBone(transform,"abdomenLower");
		fullbodyIK.references.spine[1] =  SearchHierarchyForBone(transform,"abdomenUpper");
			
		fullbodyIK.references.eyes = new Transform[ 2 ];
		fullbodyIK.references.eyes[0] =  SearchHierarchyForBone(transform,"lEye");
		fullbodyIK.references.eyes[1] =  SearchHierarchyForBone(transform,"rEye");
		fullbodyIK.SetReferences(fullbodyIK.references,SearchHierarchyForBone(transform,"hip"));	
		*/
		

		fullbodyIK.references.rightThigh= SearchHierarchyForBone(transform,"rThighBend");
		fullbodyIK.references.rightCalf= SearchHierarchyForBone(transform,"rShin");
		fullbodyIK.references.rightFoot= SearchHierarchyForBone(transform,"rFoot");
	
	
		fullbodyIK.references.leftUpperArm= SearchHierarchyForBone(transform,"lShldrBend");
		fullbodyIK.references.leftForearm= SearchHierarchyForBone(transform,"lForearmBend");
		fullbodyIK.references.leftHand= SearchHierarchyForBone(transform,"lHand");
	
		fullbodyIK.references.rightUpperArm= SearchHierarchyForBone(transform,"rShldrBend");
		fullbodyIK.references.rightForearm= SearchHierarchyForBone(transform,"rForearmBend");
		fullbodyIK.references.rightHand= SearchHierarchyForBone(transform,"rHand");
			
			
		fullbodyIK.references.head= SearchHierarchyForBone(transform,"head");
			
		fullbodyIK.references.spine = new Transform[ 2 ];
		fullbodyIK.references.spine[0] =  SearchHierarchyForBone(transform,"abdomenLower");
		fullbodyIK.references.spine[1] =  SearchHierarchyForBone(transform,"abdomenUpper");
			
		fullbodyIK.references.eyes = new Transform[ 2 ];
		fullbodyIK.references.eyes[0] =  SearchHierarchyForBone(transform,"lEye");
		fullbodyIK.references.eyes[1] =  SearchHierarchyForBone(transform,"rEye");
		fullbodyIK.SetReferences(fullbodyIK.references,SearchHierarchyForBone(transform,"hip"));	
		
		/*
			
		lookAt = ControlGameObject.GetComponent<LookAtIK>();
		if ( lookAt==null)
			lookAt = ControlGameObject.AddComponent<LookAtIK>();
		lookAt.solver.bodyWeight=0f;
		lookAt.solver.headWeight=0.85f;
		Transform[] eyes= new Transform[ 2 ];
		eyes[0] =  SearchHierarchyForBone(transform,"lEye");
		eyes[1] =  SearchHierarchyForBone(transform,"rEye");
		lookAt.solver.SetChain(null,SearchHierarchyForBone(transform,"head"),eyes,transform);
		
			
		bipedIK.solvers.lookAt.bodyWeight=0f;
		bipedIK.solvers.lookAt.clampWeightHead=0.7f;
		bipedIK.solvers.lookAt.clampWeightHead=0.7f;
		
		bipedIK.solvers.lookAt.IKPositionWeight=0;
		
		ControlGameObject.SetActive(false);
		ControlGameObject.SetActive(true);
		bipedIK.enabled=false;
		bipedIK.enabled=true;
		bipedIK.InitiateBipedIK();
		lookAt.solver.StoreDefaultLocalState();
		lookAt.solver.Initiate(characterRootTransform);
		lookAt.solver.StoreDefaultLocalState();
		lookAt.UpdateSolverExternal();
		lookAt.solver.Update();
		lookAt.solver.FixTransforms();
		lookAt.solver.eyesWeight = 0.3f;
		
		setup = true;
		if (lookController!=null)
		lookController.lookAt = lookAt;
		*/
	}

	public void  InstallIKComponents() {
		
		if (!transform.Find("FullBodyIK") ) {
			
			ControlGameObject = new GameObject("ControlObjects");
			ControlGameObject.transform.parent=transform;
			
			if (!ControlGameObject.transform.Find("PelvisControl") )  {
				GameObject pc = new GameObject("PelvisControl");
				pelvisControl = pc.transform;
				pc.transform.parent=ControlGameObject.transform;
			}
			
			
		} else ControlGameObject =transform.Find("ControlObjects").gameObject;
		
	
		bipedIK = ControlGameObject.GetComponent<BipedIK>();
		if ( bipedIK==null)
			bipedIK = ControlGameObject.AddComponent<BipedIK>();
			
		bipedIK.references.root=characterRootTransform; 
		/*
		bipedIK.references.pelvis= SearchHierarchyForBone(transform,"hip");
			
		bipedIK.references.leftThigh= SearchHierarchyForBone(transform,"lThighBend");
		bipedIK.references.leftCalf= SearchHierarchyForBone(transform,"lShin");
		bipedIK.references.leftFoot= SearchHierarchyForBone(transform,"lFoot");
			
		bipedIK.references.rightThigh= SearchHierarchyForBone(transform,"rThighBend");
		bipedIK.references.rightCalf= SearchHierarchyForBone(transform,"rShin");
		bipedIK.references.rightFoot= SearchHierarchyForBone(transform,"rFoot");
	
	
		bipedIK.references.leftUpperArm= SearchHierarchyForBone(transform,"lShldrBend");
		bipedIK.references.leftForearm= SearchHierarchyForBone(transform,"lForearmBend");
		bipedIK.references.leftHand= SearchHierarchyForBone(transform,"lHand");
	
		bipedIK.references.rightUpperArm= SearchHierarchyForBone(transform,"rShldrBend");
		bipedIK.references.rightForearm= SearchHierarchyForBone(transform,"rForearmBend");
		bipedIK.references.rightHand= SearchHierarchyForBone(transform,"rHand");
			
			
		bipedIK.references.head= SearchHierarchyForBone(transform,"head");
			
		bipedIK.references.spine = new Transform[ 2 ];
		bipedIK.references.spine[0] =  SearchHierarchyForBone(transform,"abdomenLower");
		bipedIK.references.spine[1] =  SearchHierarchyForBone(transform,"abdomenUpper");
			
		bipedIK.references.eyes = new Transform[ 2 ];
		bipedIK.references.eyes[0] =  SearchHierarchyForBone(transform,"lEye");
		bipedIK.references.eyes[1] =  SearchHierarchyForBone(transform,"rEye");
			
		*/	
			
		bipedIK.references.pelvis=animator.GetBoneTransform(HumanBodyBones.Hips );;
			
		bipedIK.references.leftThigh= animator.GetBoneTransform(HumanBodyBones.LeftUpperLeg );
		bipedIK.references.leftCalf= animator.GetBoneTransform(HumanBodyBones.LeftLowerLeg );
		bipedIK.references.leftFoot=  animator.GetBoneTransform(HumanBodyBones.LeftFoot );
			
		bipedIK.references.rightThigh= animator.GetBoneTransform(HumanBodyBones.RightUpperLeg );
		bipedIK.references.rightCalf= animator.GetBoneTransform(HumanBodyBones.RightLowerLeg );
		bipedIK.references.rightFoot= animator.GetBoneTransform(HumanBodyBones.RightFoot );
	
	
		bipedIK.references.leftUpperArm=animator.GetBoneTransform(HumanBodyBones.LeftUpperArm );
		bipedIK.references.leftForearm= animator.GetBoneTransform(HumanBodyBones.LeftLowerArm );
		bipedIK.references.leftHand= animator.GetBoneTransform(HumanBodyBones.LeftHand );
	
		bipedIK.references.rightUpperArm= animator.GetBoneTransform(HumanBodyBones.RightUpperArm );
		bipedIK.references.rightForearm= animator.GetBoneTransform(HumanBodyBones.RightLowerArm );
		bipedIK.references.rightHand= animator.GetBoneTransform(HumanBodyBones.RightHand );
			
			
		bipedIK.references.head= animator.GetBoneTransform(HumanBodyBones.Head );
			
		bipedIK.references.spine = new Transform[ 2 ];
		bipedIK.references.spine[0] = animator.GetBoneTransform(HumanBodyBones.Chest );
		bipedIK.references.spine[1] = animator.GetBoneTransform(HumanBodyBones.UpperChest );
			
		bipedIK.references.eyes = new Transform[ 2 ];
		bipedIK.references.eyes[0] = animator.GetBoneTransform(HumanBodyBones.LeftEye );
		bipedIK.references.eyes[1] =   animator.GetBoneTransform(HumanBodyBones.RightEye );
			

			
			
		lookAt = ControlGameObject.GetComponent<LookAtIK>();
		if ( lookAt==null)
			lookAt = ControlGameObject.AddComponent<LookAtIK>();
		lookAt.solver.bodyWeight=0f;
		lookAt.solver.headWeight=0.85f;
		Transform[] eyes= new Transform[ 2 ];
		eyes[0] = animator.GetBoneTransform(HumanBodyBones.LeftEye );
		eyes[1] =  animator.GetBoneTransform(HumanBodyBones.RightEye );
		lookAt.solver.SetChain(null,animator.GetBoneTransform(HumanBodyBones.Head ),eyes,transform);
		
			
		bipedIK.solvers.lookAt.bodyWeight=0f;
		bipedIK.solvers.lookAt.clampWeightHead=0.7f;
		bipedIK.solvers.lookAt.clampWeightHead=0.7f;
		
		bipedIK.solvers.lookAt.IKPositionWeight=0;
		
		ControlGameObject.SetActive(false);
		ControlGameObject.SetActive(true);
		bipedIK.enabled=false;
		bipedIK.enabled=true;
		bipedIK.InitiateBipedIK();
		lookAt.solver.StoreDefaultLocalState();
		lookAt.solver.Initiate(characterRootTransform);
		lookAt.solver.StoreDefaultLocalState();
		lookAt.UpdateSolverExternal();
		lookAt.solver.Update();
		lookAt.solver.FixTransforms();
		lookAt.solver.eyesWeight = 0.3f;
		
		IKSetup = true;
		if (lookController!=null)
			lookController.lookAt = lookAt;
	}
	
	public void  RemoveIKComponents() {
		
		TPose();
		active =  false;
		if (bipedIK!=null)
			bipedIK.enabled = false;
		if (lookAt!=null)
			lookAt.enabled = false;
		lookAt=null;
		bipedIK=null;
	
		if (ControlGameObject!=null) {
			DestroyImmediate(ControlGameObject.GetComponent<BipedIK>());
			DestroyImmediate(ControlGameObject.GetComponent<LookAtIK>());
			
			DestroyImmediate(ControlGameObject);
		}
		ControlGameObject=null;
		IKSetup = false;
		
	}
	void OnEnable()
	{
		
		//InstallComponents();
		
	}
	public void AddPenis(){
	}
	
	public void AddHands(){
		if ( SearchHierarchyForBone(transform,"HandControllers")!=null) 
			return;
		GameObject handControllers = new GameObject("HandControllers");
		FingerGestures lf = handControllers.AddComponent<FingerGestures>();
		lf.transform.parent = transform;
		lf.fingerTransforms = new Transform[5];
		lf.fingerTransforms[0] = SearchHierarchyForBone(transform,"lThumb1");
		lf.fingerTransforms[1] = SearchHierarchyForBone(transform,"lCarpal1");
		lf.fingerTransforms[2] = SearchHierarchyForBone(transform,"lCarpal2");
		lf.fingerTransforms[3] = SearchHierarchyForBone(transform,"lCarpal3");
		lf.fingerTransforms[4] = SearchHierarchyForBone(transform,"lCarpal4");
		lf.animator = transform.GetComponent<Animator>();
		lf.PoseSelect(0.355f,0.95f,0.9f,0.86f,0.8f,-0.1f);
		lf.speed = 5f;
	
		FingerGestures rf = handControllers.AddComponent<FingerGestures>();
		rf.transform.parent = transform;
		rf.fingerTransforms = new Transform[5];
		rf.fingerTransforms[0] = SearchHierarchyForBone(transform,"rThumb1");
		rf.fingerTransforms[1] = SearchHierarchyForBone(transform,"rCarpal1");
		rf.fingerTransforms[2] = SearchHierarchyForBone(transform,"rCarpal2");
		rf.fingerTransforms[3] = SearchHierarchyForBone(transform,"rCarpal3");
		rf.fingerTransforms[4] = SearchHierarchyForBone(transform,"rCarpal4");
		rf.animator = transform.GetComponent<Animator>();
		rf.PoseSelect(0.355f,0.95f,0.9f,0.86f,0.8f,-0.1f);
		rf.speed = 5f;
	
	}
	
	public GameObject CreateChildGameObject(string transformName, string gameObjectName, Vector3 localPosition, float sphereColliderSize) {
		
		Transform _transform = SearchHierarchyForBone(transform,transformName);
		GameObject go = new GameObject(gameObjectName);
		go.transform.parent=_transform;
		go.transform.localPosition = localPosition;
		go.transform.localScale = Vector3.one;
		go.transform.localRotation = Quaternion.identity;
		if(sphereColliderSize>0f) {
			SphereCollider sc = go.AddComponent<SphereCollider>();
			sc.radius=sphereColliderSize;
			
			sc.isTrigger=true;
		}
		
		return go;
	}
	
	public LookController.Expresion MakeExpression(string name, string idName, bool repeat, Vector2 value, float waitTimer, Vector2 wait, Vector2 duration) {
		
		LookController.Expresion exp= new LookController.Expresion();
		exp.name = name;
		exp.idName = idName;
		exp.repeat = repeat;
		exp.valueMinMax = value;
		exp.waitTimer = waitTimer;
		exp.waitMinMax = wait;
		exp.durationMinMax = duration;
		exp.curve = new AnimationCurve(new Keyframe(0, 0),new Keyframe(0.25f, 1),new Keyframe(0.75f, 1), new Keyframe(1, 0));;
		return  exp;
		
	}
	
	public void AddLookSystem( bool male){
		
		if ( SearchHierarchyForBone(transform,"Look Controller")!=null) {
			Debug.Log("!!! already have Look Controller!!!");
			return;
		}
		GameObject lookControllerGO =  CreateChildGameObject( "",  "Look Controller", Vector3.zero,0f);
		LookController lc = lookControllerGO.AddComponent<LookController>();
		lc.lookAt = lookAt;
		lc.bodyGenerator = gameObject.GetComponent<HumanBodyGenerator>();
		if ( male )
			lc.targetLayer  = LayerMask.GetMask("InterestingPoint 2"); 
		else
			lc.targetLayer  = LayerMask.GetMask("InterestingPoint"); 
		lc.lEye= SearchHierarchyForBone(transform,"lEye");
		lc.rEye= SearchHierarchyForBone(transform,"rEye");
		lookController = lc;
		lc.headControllerPosition =  transform.TransformPoint(pos[headID]);
		lc.expresions = new LookController.Expresion[5];
		lc.expresions[0] = MakeExpression("smile","SmileFullFace",false,new Vector2(0,80),0,new Vector2(0,0),new Vector2(4,4));
		lc.expresions[1] = MakeExpression("brows height","Brows Height",true ,new Vector2(-50,100),0,new Vector2(3,5),new Vector2(2,5));
		lc.expresions[2] = MakeExpression("eyeblink","Blink",true ,new Vector2(20,100),0,new Vector2(3,5),new Vector2(0.1f,0.5f));
		lc.expresions[3] = MakeExpression("eyeblink","Closed",true ,new Vector2(20,100),0,new Vector2(3,5),new Vector2(0.1f,0.5f));
		lc.expresions[4] = MakeExpression("angry","Angry",true ,new Vector2(20,100),0,new Vector2(3,5),new Vector2(3,4));
		/*
		lc.expresions[0].name="smile";
		lc.expresions[0].idName="SmileFullFace";
		lc.expresions[0].repeat=false;
		lc.expresions[0].name="smile";
		lc.expresions[0].name="smile"; */
		
	}

	
	public void AddInterestingPoints(int pointCount){

		if ( SearchHierarchyForBone(transform,"InterestingPoint Head")!=null) {
			Debug.Log("!!! already have Interesting points!!!");
			return;
		}

		GameObject _headGo =  CreateChildGameObject( "head",  "InterestingPoint Head", new Vector3 (0,0.1f,0f),0.1f);
		if (pointCount ==3) 
			_headGo.layer = LayerMask.NameToLayer("InterestingPoint 2");
		else 
			_headGo.layer = LayerMask.NameToLayer("InterestingPoint");
			
	
		GameObject _pelvisGo =  CreateChildGameObject( "pelvis",  "InterestingPoint Pelvis", Vector3.zero,0.1f);
		if (pointCount ==3) 
			_pelvisGo.layer = LayerMask.NameToLayer("InterestingPoint 2");
		else 
			_pelvisGo.layer = LayerMask.NameToLayer("InterestingPoint");
	
		if (pointCount ==3) {
			
			GameObject _breastsGo =  CreateChildGameObject( "chestUpper",  "InterestingPoint Breasts", new Vector3 (0,0,0.2f),0.1f);
			_breastsGo.layer = LayerMask.NameToLayer("InterestingPoint 2");
	
		}
	}
	/*
	public BonesStimulator.Bone AddBone(string s) {
		BonesStimulator.Bone bone=new BonesStimulator.Bone();
		bone.transform= SearchHierarchyForBone(transform,s);
		return bone;
	} */
	public void AddJiggleSystem() {
		/*
		if ( SearchHierarchyForBone(transform,"JiggleSystem")!=null) {
			Debug.Log("!!! already have JiggleSystem!!!");
			return;
		}
		
		GameObject JiggleSystemGo =  CreateChildGameObject( "",  "JiggleSystem", Vector3.zero,0f);
		BonesStimulator bs = JiggleSystemGo.AddComponent<BonesStimulator>();
		bs.Bones = new List<BonesStimulator.Bone>();
		bs.Bones.Add(AddBone("chestLower"));
		bs.Bones.Add(AddBone("chestUpper"));
		bs.Bones.Add(AddBone("neckLower"));
		bs.VibrateAmount= 0.25f;
		bs.VibrateSpeed=3f;
		
		DynamicBone db = JiggleSystemGo.AddComponent<DynamicBone>();

		db.m_Damping=0.45f;
		db.m_Elasticity=0.6f;
		db.m_Stiffness=0.7f;
		db.m_Roots = new List<Transform>();
		db.m_Roots.Clear();
		db.m_Roots.Add(SearchHierarchyForBone(transform,"lThighBend"));
		db.m_Roots.Add(SearchHierarchyForBone(transform,"rThighBend"));
		
		
		*/
	}
	

	
	public void AddBreasts(){
	
		if ( SearchHierarchyForBone(transform,"lBreastPoint")!=null) {
			Debug.Log("!!! already have breasts!!!");
			return;
		}
	
		GameObject lBreastPoint = CreateChildGameObject( "lPectoral", "lBreastPoint", new Vector3 (-0.06f,0.06f,0.2f),0);
		GameObject rBreastPoint = CreateChildGameObject( "rPectoral", "rBreastPoint", new Vector3 (0.06f,0.06f,0.2f),0);
		GameObject breastPhysics = CreateChildGameObject( "", "BreastPhysicsController", Vector3.zero,0);
	

		DynamicBone db = breastPhysics.AddComponent<DynamicBone>();

		db.m_Damping=0.05f;
		db.m_Elasticity=0.06f;
		db.m_Stiffness=0.5f;
		db.m_Roots = new List<Transform>();
		db.m_Roots.Clear();
		db.m_Roots.Add(lBreastPoint.transform.parent);
		db.m_Roots.Add(rBreastPoint.transform.parent);
	
		
	}
	
	void OnDrawGizmos()
	{
		if ( anchors!=null)
		foreach ( Anchor anchor in anchors) {
			
			Gizmos.color =Color.red;
			if ( anchor.anchorTransform!=null)
				Gizmos.DrawLine(anchor.anchorTransform.position, transform.TransformPoint(GetHandlePosition(anchor.handle))  );
			
		}
		// Your gizmo drawing thing goes here if required...
 	//Gizmos.DrawSphere(pos[rHandID],0.05f);
	#if UNITY_EDITOR
		// Ensure continuous Update calls.
		if (!Application.isPlaying)
		{
			UnityEditor.EditorApplication.QueuePlayerLoopUpdate();
			UnityEditor.SceneView.RepaintAll();
		}
	#endif
	}
	
	public void ResetPosition(){
		
		
		pos[lFootID] = new Vector3(-0.1f,0.06f,0f);
		rot[lFootID] = Quaternion.identity;//transform.rotation *Quaternion.identity;
	
		pos[rFootID] = new Vector3(0.1f,0.06f,0f);
		rot[rFootID] = Quaternion.identity;
		
		pos[lFootBendID]= new Vector3(-0.1f,0.5f,0.3f);
		pos[rFootBendID]= new Vector3(0.1f,0.5f,0.3f);
	
	
		pos[pelvisID] = new Vector3(0f,1.03f,0f);
		rot[pelvisID] = Quaternion.identity; 
	
		pos[spineID] = new Vector3(0f,1.5f,0f);
		rot[spineID] = Quaternion.identity;
		
		pos[headID] = new Vector3(0f,1.6f,0.5f);
		
		pos[lHandID] = new Vector3(-0.8f,1.3f,0f);;
		rot[lHandID] = Quaternion.Euler(-30, 00, -30);
		
		pos[rHandID] = new Vector3(0.8f,1.3f,0f);;
		rot[rHandID] = Quaternion.Euler(-30, 00, 30);
		
		pos[lHandBendID] = new Vector3(-0.4f,1.7f,0f);;
		pos[rHandBendID] = new Vector3(0.4f,1.7f,0f);;
		Update();
	}
	
	public void UpdateSolver(IKSolverLimb solver,  Vector3 editorPosition,  Quaternion editorRotation) {


			solver.IKPosition=transform.TransformPoint(editorPosition);
			solver.IKRotation=transform.rotation*(editorRotation);
		
		
		solver.IKPositionWeight = 1f;
		solver.IKRotationWeight = 1f;
	
		


	}
	
	public void UpdateBendSolver(IKSolverLimb solver, Vector3 editorPosition) {

		solver.bendModifier = IKSolverLimb.BendModifier.Goal;


			solver.SetBendGoalPosition( transform.TransformPoint(editorPosition),1f);
			//	solver.executedInEditor=true;
			//solver.MaintainBend()
		
		
		solver.IKPositionWeight = 1f;
		solver.IKPositionWeight = 1f;



	}
	
	public void TPose()
	{
		if (lookAt) {
			lookAt.UpdateSolverExternal();
		
			lookAt.enabled=false;
			lookAt.solver.Update();
		}
		
		if ( bipedIK)
			bipedIK.enabled = false;
		if (animator==null)
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
		
		if ( bipedIK ) 
	
			bipedIK.enabled = true;
	
		if ( bipedIK == true) {
	
			bipedIK.enabled = true;
			bipedIK.UpdateBipedIK();
			bipedIK.UpdateSolverExternal();
		}
		if (lookAt) {
	
			
			lookAt.UpdateSolverExternal();
			lookAt.enabled=true;
		}
		

	}

	public void ResetIK(){
		TPose();
		
		RemoveIKComponents();
		InstallIKComponents();
		if (lookController!=null)
			lookController.lookAt = lookAt;
		TPose(); 
	}
	

	void Start() {
		
		
		if ( autoinstall_IKComponents_AtStart) {
		TPose();
		
			RemoveIKComponents();
			InstallIKComponents();
			if (lookController!=null)
				lookController.lookAt = lookAt;
		TPose(); 
			
		}
		TPose(); 
	
		ChangeMotionState(MotionType.animation);
		
	
	}
	
	public void AddRagdoll(){
		
		
		if (ragdollMaster == null || transform.gameObject.GetComponent<RagdollMaster>()==null)
			ragdollMaster = transform.gameObject.AddComponent<RagdollMaster>();
		ragdollMaster.rootBone = SearchHierarchyForBone(transform,"hip").gameObject;
		Transform ragdollTransform =SearchHierarchyForBone(transform,"Ragdoll");
		if ( SearchHierarchyForBone(transform,"Ragdoll") == null ) {
			ragdollTransform =   (Instantiate (Resources.Load ("Ragdoll")) as GameObject).transform;
			ragdollTransform.name = "Ragdoll";
			ragdollTransform.parent = characterRootTransform; 
			ragdollTransform.localPosition = Vector3.zero;
			ragdollTransform.localRotation = Quaternion.identity;
			ragdollTransform.localScale = new Vector3(1,1,1);
		
		}
		ragdollMaster.ragdollRootBone = SearchHierarchyForBone(ragdollTransform,"hip");
		ragdollMaster.Init();
		
		
	}
	
	public void ChangeMotionState(MotionType _motionType) {
		
		switch(_motionType) {
			
		case MotionType.animation :
		
			motionType = MotionType.animation;
			if (animator!=null)
				animator.enabled = true;

			if (ragdollMaster != null)
				ragdollMaster.DeActivateRagDoll();
			
			active = false;
			if ( bipedIK )
				bipedIK.enabled = false;
				if  (lookAt)
					lookAt.enabled = true;
			
			break;
		
		case MotionType.ragdoll :
			
			motionType = MotionType.ragdoll;

			if (ragdollMaster != null)
				ragdollMaster.ActivateRagDoll();

			if (animator!=null)
				animator.enabled = false;
				
			if  (lookAt)
				lookAt.enabled = false;
	

			TPose(); 

			break;
			
			
		case MotionType.bipedIK :
		
			motionType = MotionType.bipedIK;
			TPose();
			if (ragdollMaster != null)
				ragdollMaster.DeActivateRagDoll();

			active = true;
			if (animator!=null)
				animator.enabled = false;
				
			if ( bipedIK )
				bipedIK.enabled = true;
				
			if  (lookAt)
				lookAt.enabled = true;
	

			break;
		
		default:
			Debug.Log("NOTHING");
			break;
		}
		
	}
	public void UpdateAnchors() {
		
		foreach ( Anchor anchor in anchors) if (anchor.anchorTransform!=null ) {
			Vector3 pos =  anchor.anchorTransform.TransformPoint(anchor.relativePos);
			pos = transform.InverseTransformPoint(pos);
			SetHandlePosition(anchor.handle,pos);
		}
	}
	public  void Update()
	{
	
		

				
		if (lookController!=null) {
	
			lookAt.solver.SetIKPosition( lookController.headControllerPosition);
		} else
			lookAt.solver.SetIKPosition( transform.TransformPoint(pos[headID]));
		
		lookAt.solver.Update();		
		if (Application.isPlaying) {
			
			if ( motionType == MotionType.ragdoll ) 
			if ( ragdollAnchors) { 
			
					UpdateRagdollAnchors();
			}
			
				
			
		} else {
			if ( anchors.Length>0)
				foreach ( Anchor anchor in anchors) {
					
					if (anchor.anchorTransform!=null )
					anchor.relativePos =  anchor.anchorTransform.InverseTransformPoint(transform.TransformPoint( GetHandlePosition(anchor.handle)));
		
				}
		
			}
		
		if ( motionType == MotionType.bipedIK && IKSetup) {
			
			UpdateSolver(bipedIK.solvers.rightHand, pos[rHandID], rot[rHandID]);
			UpdateSolver(bipedIK.solvers.leftHand, pos[lHandID],  rot[lHandID]);
			
			UpdateSolver(bipedIK.solvers.leftFoot, pos[lFootID], rot[lFootID]);
			UpdateSolver(bipedIK.solvers.rightFoot, pos[rFootID], rot[rFootID]);
		
			UpdateBendSolver(bipedIK.solvers.leftHand ,  pos[lHandBendID]);
			UpdateBendSolver(bipedIK.solvers.rightHand ,  pos[rHandBendID]);
			UpdateBendSolver(bipedIK.solvers.leftFoot ,  pos[lFootBendID]);
			UpdateBendSolver(bipedIK.solvers.rightFoot ,   pos[rFootBendID]);
			
			
			pelvisControl.position = transform.TransformPoint(pos[pelvisID]);;
			pelvisControl.rotation = transform.rotation*rot[pelvisID];
			bipedIK.solvers.pelvis.target=pelvisControl;
			
			bipedIK.solvers.pelvis.positionWeight=1f;
			bipedIK.solvers.pelvis.rotationWeight=1f;
			
				
				
			bipedIK.solvers.spine.IKPosition = transform.TransformPoint(pos[spineID]);
			bipedIK.solvers.spine.IKPositionWeight = 1f;
		
			if (!Application.isPlaying) {
			
				lookAt.solver.IKPositionWeight=1f;
		
		
				bipedIK.solvers.leftHand.Update();
				bipedIK.solvers.leftFoot.Update();
				bipedIK.solvers.rightFoot.Update();
				bipedIK.solvers.rightHand.Update();
	        
				bipedIK.solvers.pelvis.Update();
				bipedIK.solvers.spine.Update();
				lookAt.solver.Update();		
			
			}
		
		}		
				
		

		
			
	
		
		
		
		
		
		
		
	}
	
	/*
	public void CalculateForce(int ID, Vector3 offset) {
		
		if ( ragdollMaster.transforms[ID]==null)
			return;
		Rigidbody r = ragdollMaster.transforms[ID].GetComponent<Rigidbody>();
		Vector3 dir = (ragdollMaster.transforms[ID].position-r.position);
		Vector3 force = PhysXTools.GetLinearAcceleration(r.position,transform.TransformPoint( pos[ID] ));
		//	force += targetVelocity;
		force -= r.velocity;
		if (r.useGravity) force -= Physics.gravity * Time.deltaTime;
		force *= forceWeight;
		r.AddForce(force, ForceMode.VelocityChange);

		Vector3 torque = PhysXTools.GetAngularAcceleration(r.rotation, transform.rotation * rot[ID]);
		//	torque += targetAngularVelocity;
		torque -= r.angularVelocity;
		torque *= torqueWeight;
		r.AddTorque(torque, ForceMode.VelocityChange);

	} */
	
	public void CalculateForce(int ID) {
		
		if ( ragdollMaster.transforms[ID]==null)
			return;
		Rigidbody r = ragdollMaster.transforms[ID].GetComponent<Rigidbody>();
		Vector3 dir = (ragdollMaster.transforms[ID].position-r.position);
		Vector3 force = PhysXTools.GetLinearAcceleration(r.position,transform.TransformPoint( pos[ID] ));
		//	force += targetVelocity;
		force -= r.velocity;
		if (r.useGravity) force -= Physics.gravity * Time.deltaTime;
		force *= forceWeight;
		r.AddForce(force, ForceMode.VelocityChange);

		Vector3 torque = PhysXTools.GetAngularAcceleration(r.rotation, transform.rotation * rot[ID]);
		//	torque += targetAngularVelocity;
		torque -= r.angularVelocity;
		torque *= torqueWeight;
		r.AddTorque(torque, ForceMode.VelocityChange);

	}
	
	public void UpdateRagdollAllAnchors() {
		
		CalculateForce(headID);
		CalculateForce(pelvisID);
		CalculateForce(lHandID);
		CalculateForce(rHandID);
		CalculateForce(spineID);		
		CalculateForce(rFootID);
		CalculateForce(lFootID);
		
		 
	}
	
	
	public void UpdateRagdollAnchors() {
		foreach ( Anchor anchor in anchors ) {
			CalculateForce((int) anchor.handle);
		}
		Debug.Log("ff");
		
		 
	}
	
}