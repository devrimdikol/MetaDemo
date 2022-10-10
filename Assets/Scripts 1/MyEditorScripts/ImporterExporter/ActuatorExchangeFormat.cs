using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using static SexManager;

namespace Assets.MyEditorScripts.ImporterExporter
{
	[Serializable]
	public class ActuatorExchangeFormat
	{
		public PersonaType PersonaType;
		public Body.ControlType PositionHandleTarget;
		public Transform Target;
		public bool Active;
		public Vector3 DefaultPosition;
		public Quaternion DefaultRotation;		
		public Vector3 MinAngle;
		public Vector3 MaxAngle;
		public Vector3 MinPosition;
		public Vector3 MaxPosition;
		public float Freq;
		public float PhaseShift;
		public AnimationCurve Curve;
		public float ForwardMax;
		public float T;
		public Vector3 Pos;
		public Quaternion Rot;

		public ActuatorExchangeFormat(Actuator actuator)
		{
			PersonaType = actuator.personaType;
			PositionHandleTarget = actuator.PositionHandletarget;
			Target = actuator.target;
			Active = actuator.active;
			DefaultPosition = actuator.defaultPosition;
			DefaultRotation = actuator.defaultRotation;
			MinAngle = actuator.minAngle;
			MaxAngle = actuator.maxAngle;
			MinPosition = actuator.minPosition;
			MaxPosition = actuator.maxPosition;
			Freq = actuator.freq;
			PhaseShift = actuator.phaseShift;
			Curve = actuator.curve;
			ForwardMax = actuator._forwardmax;
			T = actuator.t;
			Pos = actuator.pos;
			Rot = actuator.rot;
		}
	}
}
