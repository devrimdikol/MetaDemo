using System;
using UnityEngine;

namespace Assets.MyEditorScripts.ImporterExporter
{
    [Serializable]
    public class TransformExchangeFormat
    {
        public Vector3 Position;
        public Quaternion Rotation;
        public Vector3 Scale;

        public TransformExchangeFormat(Vector3 position, Quaternion rotation, Vector3 scale)
        {
            Position = position;
            Rotation = rotation;
            Scale = scale;
        }
    }
}
