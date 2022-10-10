using System;
using UnityEngine;

namespace Assets.MyEditorScripts.ImporterExporter
{
    [Serializable]
	public class AnchorExchangeFormat
	{
		public Body.ControlType Handle;
		public string Anchor;
		public Body.AnchorPerson AnchorPerson;
		public Vector3 RelativePos;

        public AnchorExchangeFormat()
        {

        }
	}
}
