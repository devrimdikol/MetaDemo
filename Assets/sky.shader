// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co
 
Shader "Marmoset/Skydome IBL" {
Properties {
    _SkyCubeIBL ("Custom Sky Cube", Cube) = "white" {}
}
 
SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" }
    Cull Off ZWrite Off Fog { Mode Off }
 
    Pass {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma fragmentoption ARB_precision_hint_fastest
        //gamma-correct sampling permutations
        #pragma multi_compile MARMO_LINEAR MARMO_GAMMA
               
        #define MARMO_HQ
       
        #ifndef SHADER_API_GLES
            #define MARMO_SKY_ROTATION
        #endif
       
        #include "UnityCG.cginc"
        #include "../MarmosetCore.cginc"
 
        samplerCUBE _SkyCubeIBL;
        half4       _ExposureIBL;
        float4x4    _SkyMatrix;
       
        struct appdata_t {
            float4 vertex : POSITION;
            float3 texcoord : TEXCOORD0;
        };
 
        struct v2f {
            float4 vertex : POSITION;
            float3 texcoord : TEXCOORD0;
        };
 
        v2f vert (appdata_t v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            #ifdef MARMO_SKY_ROTATION
            o.texcoord = mulVec3(_SkyMatrix, v.vertex.xyz);
            #else
            o.texcoord = v.vertex.xyz;
            #endif
            return o;
        }
 
        half4 frag (v2f i) : COLOR
        {
            half4 col = texCUBE(_SkyCubeIBL, i.texcoord);
            col.rgb = fromRGBM(col)*_ExposureIBL.z;
            col.a = 1.0;
            return col;
        }
        ENDCG
    }
}  
 
 
SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" }
    Cull Off ZWrite Off Fog { Mode Off }
    Color [_Tint]
    Pass {
        SetTexture [_Tex] { combine texture +- primary, texture * primary }
    }
}
 
Fallback Off
 
}