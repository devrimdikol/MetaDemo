using System;
using System.IO;
using UnityEngine;

namespace Assets.MyEditorScripts.ImporterExporter
{
    [Serializable]
	public class SexManagerExchangeFormat
	{
		public AnimationCurve FrequencyCurve;

		public float NoiseAmp;

		public float NoiseFreq;

		public bool ShowGizmos;

		public float GizmoRadius;

		public float sexDuration;

		public bool RagdollNoParentAtClimax;

		public float ClimaxDuration;

		public Vector2 ClimaxForceMinMax;

		public float ClimaxForce;

		public ActuatorExchangeFormat[] Actuators;

		public PersonaExchangeFormat[] Personas;

		public int PersonaCount
        {
            get
            {
				return Personas.Length;
			}			
        }

		public SexManagerExchangeFormat()
		{

		}

		public SexManagerExchangeFormat(SexManager sex_manager)
		{
			FrequencyCurve = sex_manager.frequencyCurve;
			NoiseAmp = sex_manager.noiseAmp;
			NoiseFreq = sex_manager.noiseFreq;	
			ShowGizmos = sex_manager.showGizmos;
			GizmoRadius = sex_manager.gizmoRadius;
			sexDuration = sex_manager.sexDuration;
			RagdollNoParentAtClimax = sex_manager.ragdollNoParentAtClimax;
			ClimaxDuration = sex_manager.climaxDuration;
			ClimaxForceMinMax = sex_manager.climaxForceMinMax;
			ClimaxForce = sex_manager.climaxForce;

			Actuators = new ActuatorExchangeFormat[sex_manager.actuators.Length];

			for(int i = 0; i < sex_manager.actuators.Length; i++)
            {
				var actuator = new ActuatorExchangeFormat(sex_manager.actuators[i]);
				Actuators[i] = actuator;
            }

			Personas = new PersonaExchangeFormat[sex_manager.personas.Length];

			for(int i = 0; i < sex_manager.personas.Length; i++)
            {
				var persona = sex_manager.personas[i];
				Personas[i] = new PersonaExchangeFormat(persona);
            }			
		}

		public void Save(string path)
		{
			string pretty_json = JsonUtility.ToJson(this, true);

			if (File.Exists(path))
			{
				File.Delete(path);
			}

			File.WriteAllText(path, pretty_json);
		}

		public void Load(string path)
        {
			var pretty_json = File.ReadAllText(path);
			var smef = JsonUtility.FromJson<SexManagerExchangeFormat>(pretty_json);

			FrequencyCurve = smef.FrequencyCurve;
			NoiseAmp = smef.NoiseAmp;
			NoiseFreq = smef.NoiseFreq;
			ShowGizmos = smef.ShowGizmos;
			GizmoRadius = smef.GizmoRadius;
			sexDuration = smef.sexDuration;
			RagdollNoParentAtClimax = smef.RagdollNoParentAtClimax;
			ClimaxDuration = smef.ClimaxDuration;
			ClimaxForceMinMax = smef.ClimaxForceMinMax;
			ClimaxForce = smef.ClimaxForce;
			Actuators = smef.Actuators;
			Personas = smef.Personas;			
		}
	}
}
