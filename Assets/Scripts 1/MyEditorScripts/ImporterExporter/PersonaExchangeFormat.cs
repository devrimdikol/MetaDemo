using System;
using UnityEngine;

namespace Assets.MyEditorScripts.ImporterExporter
{
    [Serializable]
	public class PersonaExchangeFormat
	{
		public string ModelName;
		public Vector3 ModelPosition;
		public Quaternion ModelRotation;

		public Body.ControlType ActiveControlType;
		public Body.MotionType MotionType;

		public AnchorExchangeFormat[] Anchors;

		public Vector3[] Positions = new Vector3[11];
		public Quaternion[] Rotations = new Quaternion[11];

		public PersonaExchangeFormat(Body persona)
		{
			ModelName = persona.gameObject.name;
			ModelPosition = persona.gameObject.transform.localPosition;
			ModelRotation = persona.gameObject.transform.localRotation;

			ActiveControlType = persona.activeControlType;
			MotionType = persona.motionType;

			#region ANCHORS

			Anchors = new AnchorExchangeFormat[persona.anchors.Length];

			for (int i = 0; i < persona.anchors.Length; i++)
            {
				Anchors[i] = new AnchorExchangeFormat();

				Anchors[i].Handle = persona.anchors[i].handle;

                if (persona.anchors[i].anchorTransform != null)
					Anchors[i].Anchor = persona.anchors[i].anchorTransform.name;
				
				Anchors[i].AnchorPerson = persona.anchors[i].anchorPerson;
				Anchors[i].RelativePos = persona.anchors[i].relativePos;
            }

			#endregion

			#region POSITIONS

			Positions = new Vector3[persona.pos.Length];

			for (int i = 0; i < persona.pos.Length; i++)
			{
				Positions[i] = persona.pos[i];
			}

			#endregion

			#region ROTATIONS

			Rotations = new Quaternion[persona.rot.Length];

			for(int i = 0; i < persona.rot.Length; i++)
            {
				Rotations[i] = persona.rot[i];
            }

			#endregion		
		}
    }
}
