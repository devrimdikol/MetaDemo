// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RRF_HumanShaders/HairShader2/HairShader2_AS_RRF_Mod2"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0.8455882,0.8076825,0.6839316,1)
		_Cutoff( "Mask Clip Value", Float ) = 0.24
		_BaseTone_Alpha("BaseTone_Alpha", 2D) = "white" {}
		_BaseTipColorPower("BaseTipColor-Power", Color) = (1,0,0,0)
		_AlphaLevel("AlphaLevel", Range( 0 , 2)) = 2
		_VariaitonFromBase("VariaitonFromBase", Range( 0 , 1)) = 0.8
		_NormalMap("NormalMap", 2D) = "bump" {}
		_BumpPower("BumpPower", Range( 0 , 3)) = 1
		_MainHighlight_Color("MainHighlight_Color", Color) = (0,0,0,0)
		_MainHighlightPosition("Main Highlight Position", Range( -1 , 3)) = 0
		_MainHighlightStrength("Main Highlight Strength", Range( 0 , 3)) = 0.25
		_MainHighlightExponent("Main Highlight Exponent", Range( 0 , 1000)) = 0.2
		_SecondaryHighlightColor("Secondary Highlight Color", Color) = (0.8862069,0.8862069,0.8862069,0)
		_SecondaryHighlightPosition("Secondary Highlight Position", Range( -1 , 3)) = 0
		_SecondaryHighlightStrength("Secondary Highlight Strength", Range( 0 , 2)) = 0.25
		_SecondaryHighlightExponent("Secondary Highlight Exponent", Range( 0 , 1000)) = 0.2
		_Spread("Spread", Range( -1 , 1)) = 0
		_Noise("Noise", Range( 0 , 1)) = 0
		_CustomShadowPower("CustomShadowPower", Range( 0 , 1)) = 1
		_CustomLightingPower("CustomLightingPower", Range( 0 , 1)) = 0.1
		_Reflectivity("Reflectivity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite On
		ZTest LEqual
		Blend One Zero , SrcAlpha DstColor
		
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _BaseTone_Alpha;
		uniform float4 _BaseTone_Alpha_ST;
		uniform float _AlphaLevel;
		uniform float4 _BaseTipColorPower;
		uniform float4 _BaseColor;
		uniform float4 _MainHighlight_Color;
		uniform float _MainHighlightPosition;
		uniform float _BumpPower;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Spread;
		uniform float _Noise;
		uniform float _MainHighlightExponent;
		uniform float _MainHighlightStrength;
		uniform float _CustomLightingPower;
		uniform float _SecondaryHighlightPosition;
		uniform float _SecondaryHighlightExponent;
		uniform float _SecondaryHighlightStrength;
		uniform float4 _SecondaryHighlightColor;
		uniform float _VariaitonFromBase;
		uniform float _Reflectivity;
		uniform float _CustomShadowPower;
		uniform float _Cutoff = 0.24;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_BaseTone_Alpha = i.uv_texcoord * _BaseTone_Alpha_ST.xy + _BaseTone_Alpha_ST.zw;
			float4 tex2DNode1 = tex2D( _BaseTone_Alpha, uv_BaseTone_Alpha );
			float temp_output_4_0 = pow( ( tex2DNode1.a * tex2DNode1.a ) , _AlphaLevel );
			float4 lerpResult293 = lerp( _BaseTipColorPower , _BaseColor , pow( tex2DNode1.g , ( _BaseTipColorPower.a * 10.0 ) ));
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 T200 = cross( ase_worldTangent , ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode7 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _BumpPower );
			float2 appendResult372 = (float2(1200.0 , ( _Spread * 10.0 )));
			float2 uv_TexCoord360 = i.uv_texcoord * appendResult372;
			float simplePerlin2D359 = snoise( uv_TexCoord360 );
			float lerpResult361 = lerp( tex2DNode7.g , simplePerlin2D359 , _Noise);
			float NoiseFX312 = ( ( tex2DNode7.g + lerpResult361 ) * _Spread );
			float4 appendResult305 = (float4(ase_worldlightDir.x , ( ( _MainHighlightPosition + NoiseFX312 ) + ase_worldlightDir.y ) , ase_worldlightDir.z , 0.0));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float4 normalizeResult78 = normalize( ( appendResult305 + float4( ase_worldViewDir , 0.0 ) ) );
			float4 H93 = normalizeResult78;
			float dotResult95 = dot( float4( T200 , 0.0 ) , H93 );
			float dotTH94 = dotResult95;
			float sinTH97 = sqrt( ( 1.0 - ( dotTH94 * dotTH94 ) ) );
			float smoothstepResult103 = smoothstep( -1.0 , 0.0 , dotTH94);
			float dirAtten102 = smoothstepResult103;
			float dotResult279 = dot( ase_worldlightDir , ase_worldNormal );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_335_0 = ( ase_lightAtten * ase_lightColor.a * ( _CustomLightingPower * 10.0 ) );
			float clampResult290 = clamp( ( dotResult279 * dotResult279 * dotResult279 * temp_output_335_0 ) , 0.0 , 1.0 );
			float lightZone285 = clampResult290;
			float clampResult347 = clamp( temp_output_335_0 , 0.0 , 1.0 );
			float LightAttInt336 = clampResult347;
			float4 temp_output_268_0 = ( _MainHighlight_Color * ( pow( sinTH97 , _MainHighlightExponent ) * _MainHighlightStrength * dirAtten102 * lightZone285 ) * ase_lightColor * ase_lightColor.a * LightAttInt336 );
			float4 appendResult241 = (float4(ase_worldlightDir.x , ( ( _SecondaryHighlightPosition + NoiseFX312 ) + ase_worldlightDir.y ) , ase_worldlightDir.z , 0.0));
			float4 normalizeResult246 = normalize( ( appendResult241 + float4( ase_worldViewDir , 0.0 ) ) );
			float4 HL2247 = normalizeResult246;
			float dotResult249 = dot( HL2247 , float4( T200 , 0.0 ) );
			float DotTHL2252 = dotResult249;
			float sinTHL2256 = sqrt( ( 1.0 - ( DotTHL2252 * DotTHL2252 ) ) );
			float4 temp_output_265_0 = ( ( pow( sinTHL2256 , _SecondaryHighlightExponent ) * _SecondaryHighlightStrength * dirAtten102 * lightZone285 * LightAttInt336 ) * _SecondaryHighlightColor * ase_lightColor * ase_lightColor.a * LightAttInt336 );
			float4 temp_cast_4 = (1.0).xxxx;
			float4 lerpResult144 = lerp( temp_cast_4 , tex2DNode1 , _VariaitonFromBase);
			float4 clampResult275 = clamp( ( ( lerpResult293 + temp_output_268_0 + temp_output_265_0 ) * lerpResult144 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float3 indirectNormal353 = WorldNormalVector( i , tex2DNode7 );
			Unity_GlossyEnvironmentData g353 = UnityGlossyEnvironmentSetup( 0.75, data.worldViewDir, indirectNormal353, float3(0,0,0));
			float3 indirectSpecular353 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal353, g353 );
			float4 lerpResult355 = lerp( ( clampResult275 + ( temp_output_268_0 + temp_output_265_0 ) ) , float4( indirectSpecular353 , 0.0 ) , _Reflectivity);
			float clampResult366 = clamp( LightAttInt336 , 0.0 , 1.0 );
			float3 temp_cast_6 = (clampResult366).xxx;
			float temp_output_2_0_g3 = _CustomShadowPower;
			float temp_output_3_0_g3 = ( 1.0 - temp_output_2_0_g3 );
			float3 appendResult7_g3 = (float3(temp_output_3_0_g3 , temp_output_3_0_g3 , temp_output_3_0_g3));
			float3 clampResult369 = clamp( ( ( temp_cast_6 * temp_output_2_0_g3 ) + appendResult7_g3 ) , float3( 0.1,0.1,0.1 ) , float3( 1,1,1 ) );
			c.rgb = ( lerpResult355 * float4( clampResult369 , 0.0 ) ).rgb;
			c.a = temp_output_4_0;
			clip( temp_output_4_0 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
1920;189;1906;763;-3927.885;-478.6262;1.200451;True;True
Node;AmplifyShaderEditor.RangedFloatNode;300;-796.5721,700.0633;Float;False;Property;_Spread;Spread;16;0;Create;True;0;0;False;0;0;0.298;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-445.0119,787.7539;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;372;-333.6861,860.2456;Inherit;False;FLOAT2;4;0;FLOAT;1200;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;360;-179.2752,862.7714;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1200,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;-206.4711,272.7329;Float;False;Property;_BumpPower;BumpPower;7;0;Create;True;0;0;False;0;1;0.85;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;359;171.9813,862.1579;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-210.9419,1023.513;Float;False;Property;_Noise;Noise;17;0;Create;True;0;0;False;0;0;0.103;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;284.8842,164.9217;Inherit;True;Property;_NormalMap;NormalMap;6;0;Create;True;0;0;False;0;-1;None;8126a85a9900e314395584d32d505790;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;361;618.9824,766.4859;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;311;722.4737,330.1337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;896.8495,466.2956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;1230.974,553.6777;Float;False;NoiseFX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;110;-3870.355,-768.6287;Inherit;False;2882.904;1761.292;BaseSpec;52;314;109;267;261;259;102;106;104;286;108;285;258;260;107;262;105;103;290;256;97;289;132;255;254;134;279;280;284;99;253;252;98;94;95;249;200;96;248;251;93;78;197;198;77;79;17;305;304;298;303;313;340;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-3837.977,-578.5528;Float;False;Property;_MainHighlightPosition;Main Highlight Position;9;0;Create;True;0;0;False;0;0;0.26;-1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-3422.639,-661.655;Inherit;True;312;NoiseFX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;25;-3378.034,-934.0533;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;298;-3054.06,-489.056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-3194.839,-1160.074;Float;False;Property;_SecondaryHighlightPosition;Secondary Highlight Position;13;0;Create;True;0;0;False;0;0;0.21;-1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;304;-2731.667,-511.2789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;-2809.895,-1131.572;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;243;-2639.251,-1096.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;17;-2918.777,-752.0027;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;305;-2566.309,-562.2385;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-2438.491,-699.083;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;241;-2389.892,-1077.019;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;198;-3694.432,119.9227;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexTangentNode;79;-3749.171,-83.18208;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;245;-2103.269,-1022.311;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;78;-2240.693,-704.3386;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;-2980.105,-376.9262;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2038.877,-674.1208;Float;False;H;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;246;-1910.786,-1029.374;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2742.952,-240.0831;Inherit;False;93;H;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;247;-1442.094,-1029.97;Float;False;HL2;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-2691.425,-380.3658;Float;False;T;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;-2790.21,571.2278;Inherit;False;200;T;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;248;-2806.46,468.8795;Inherit;False;247;HL2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;95;-2443.141,-344.7966;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;249;-2470.71,495.7466;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-2266.202,-344.448;Float;False;dotTH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-4179.211,1306.312;Float;False;Property;_CustomLightingPower;CustomLightingPower;19;0;Create;True;0;0;False;0;0.1;0.142;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2757.617,-130.2655;Inherit;False;94;dotTH;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;252;-2225.851,501.045;Float;False;DotTHL2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-2466.195,-129.2428;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;284;-3699.141,715.5179;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;280;-3693.497,528.7839;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;323;-4088.062,1158.374;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-1936.716,504.4529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;322;-4101.374,1052.014;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;-3924.111,1346.061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;-1735.666,520.1598;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-3754.736,1103.952;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;279;-3054.784,196.8065;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;134;-2262.328,-161.3798;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-2866.36,215.7459;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;132;-2060.191,-205.6331;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;255;-1533.047,518.5891;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;-1305.375,558.866;Float;False;sinTHL2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;103;-2436.922,17.70354;Inherit;False;3;0;FLOAT;-1;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;290;-2646.9,258.096;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1856.662,-211.6534;Float;False;sinTH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;347;-3443.339,1135.2;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-2180.057,8.771833;Float;False;dirAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-2094.96,656.8934;Float;False;Property;_SecondaryHighlightExponent;Secondary Highlight Exponent;15;0;Create;True;0;0;False;0;0.2;639;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;292;-759.0253,-823.9559;Float;False;Property;_BaseTipColorPower;BaseTipColor-Power;3;0;Create;True;0;0;False;0;1,0,0,0;1,0.877282,0.1911765,0.203;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;257;-1832.492,927.9147;Inherit;False;256;sinTHL2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1799.963,149.5014;Float;False;Property;_MainHighlightExponent;Main Highlight Exponent;11;0;Create;True;0;0;False;0;0.2;218;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;285;-2468.629,205.9621;Float;False;lightZone;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-682.1694,-646.6733;Float;False;Constant;_Float2;Float 2;19;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1718.307,71.29671;Inherit;False;97;sinTH;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;336;-3150.341,1123.86;Float;False;LightAttInt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-1759.939,316.7973;Inherit;False;102;dirAtten;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-857.8339,12.2865;Inherit;True;Property;_BaseTone_Alpha;BaseTone_Alpha;2;0;Create;True;0;0;False;0;-1;None;d278b4721754dd64ebf3ae49a82076b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;286;-1650.262,391.5542;Inherit;False;285;lightZone;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-489.3649,-648.4099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;-1655.497,459.4134;Inherit;False;336;LightAttInt;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;106;-1444.119,-10.46254;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;258;-1483.864,638.1011;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1794.714,230.1034;Float;False;Property;_MainHighlightStrength;Main Highlight Strength;10;0;Create;True;0;0;False;0;0.25;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-2124.586,771.097;Float;False;Property;_SecondaryHighlightStrength;Secondary Highlight Strength;14;0;Create;True;0;0;False;0;0.25;1.405;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-1824.733,860.6061;Inherit;False;102;dirAtten;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;267;-1502.458,-301.618;Float;False;Property;_MainHighlight_Color;MainHighlight_Color;8;0;Create;True;0;0;False;0;0,0,0,0;1,0.7955375,0.7352941,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;264;-1283.684,886.4523;Float;False;Property;_SecondaryHighlightColor;Secondary Highlight Color;12;0;Create;True;0;0;False;0;0.8862069,0.8862069,0.8862069,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;294;-284.2756,-494.4894;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1276.799,-28.76422;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-872.1382,-576.4238;Float;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;False;0;0.8455882,0.8076825,0.6839316,1;0.5294118,0.3984012,0.05449826,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;314;-1276.534,312.7874;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-1224.201,693.6574;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;-729.1758,429.3002;Inherit;False;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;293;-86.6779,-655.597;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-859.3257,-275.7347;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-647.7953,-153.0608;Float;False;Property;_VariaitonFromBase;VariaitonFromBase;5;0;Create;True;0;0;False;0;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-637.1672,-236.493;Float;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;144;-246.6127,-167.5198;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;179.0984,-470.9795;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;1414.221,-320.6941;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;2838.175,1150.339;Inherit;False;336;LightAttInt;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;366;3389.74,1237.2;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;291;2597.802,338.4355;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;350;3311.503,1451.633;Float;False;Property;_CustomShadowPower;CustomShadowPower;18;0;Create;True;0;0;False;0;1;0.664;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;275;2106.961,-251.2089;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;353;4044.214,817.8863;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.75;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;327;3102.553,95.70804;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;356;4278.867,959.361;Float;False;Property;_Reflectivity;Reflectivity;20;0;Create;True;0;0;False;0;0;0.522;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;365;3883.913,1385.844;Inherit;False;Lerp White To;-1;;3;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;369;4312.649,1384.243;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0.1;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;355;4972.249,614.8429;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-966.4499,247.1846;Float;False;Property;_AlphaLevel;AlphaLevel;4;0;Create;True;0;0;False;0;2;0.45;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-304.6455,93.49822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;4;3944.863,1036.4;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;5224.814,719.6445;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5604.36,653.1859;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;RRF_HumanShaders/HairShader2/HairShader2_AS_RRF_Mod2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.24;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;1;5;False;-1;2;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;371;0;300;0
WireConnection;372;1;371;0
WireConnection;360;0;372;0
WireConnection;359;0;360;0
WireConnection;7;5;114;0
WireConnection;361;0;7;2
WireConnection;361;1;359;0
WireConnection;361;2;308;0
WireConnection;311;0;7;2
WireConnection;311;1;361;0
WireConnection;299;0;311;0
WireConnection;299;1;300;0
WireConnection;312;0;299;0
WireConnection;298;0;303;0
WireConnection;298;1;313;0
WireConnection;304;0;298;0
WireConnection;304;1;25;2
WireConnection;306;0;244;0
WireConnection;306;1;313;0
WireConnection;243;0;306;0
WireConnection;243;1;25;2
WireConnection;305;0;25;1
WireConnection;305;1;304;0
WireConnection;305;2;25;3
WireConnection;77;0;305;0
WireConnection;77;1;17;0
WireConnection;241;0;25;1
WireConnection;241;1;243;0
WireConnection;241;2;25;3
WireConnection;245;0;241;0
WireConnection;245;1;17;0
WireConnection;78;0;77;0
WireConnection;197;0;79;0
WireConnection;197;1;198;0
WireConnection;93;0;78;0
WireConnection;246;0;245;0
WireConnection;247;0;246;0
WireConnection;200;0;197;0
WireConnection;95;0;200;0
WireConnection;95;1;96;0
WireConnection;249;0;248;0
WireConnection;249;1;251;0
WireConnection;94;0;95;0
WireConnection;252;0;249;0
WireConnection;99;0;98;0
WireConnection;99;1;98;0
WireConnection;253;0;252;0
WireConnection;253;1;252;0
WireConnection;370;0;349;0
WireConnection;254;0;253;0
WireConnection;335;0;322;0
WireConnection;335;1;323;2
WireConnection;335;2;370;0
WireConnection;279;0;280;0
WireConnection;279;1;284;0
WireConnection;134;0;99;0
WireConnection;289;0;279;0
WireConnection;289;1;279;0
WireConnection;289;2;279;0
WireConnection;289;3;335;0
WireConnection;132;0;134;0
WireConnection;255;0;254;0
WireConnection;256;0;255;0
WireConnection;103;0;98;0
WireConnection;290;0;289;0
WireConnection;97;0;132;0
WireConnection;347;0;335;0
WireConnection;102;0;103;0
WireConnection;285;0;290;0
WireConnection;336;0;347;0
WireConnection;295;0;292;4
WireConnection;295;1;297;0
WireConnection;106;0;105;0
WireConnection;106;1;107;0
WireConnection;258;0;257;0
WireConnection;258;1;262;0
WireConnection;294;0;1;2
WireConnection;294;1;295;0
WireConnection;109;0;106;0
WireConnection;109;1;108;0
WireConnection;109;2;104;0
WireConnection;109;3;286;0
WireConnection;261;0;258;0
WireConnection;261;1;259;0
WireConnection;261;2;260;0
WireConnection;261;3;286;0
WireConnection;261;4;340;0
WireConnection;265;0;261;0
WireConnection;265;1;264;0
WireConnection;265;2;314;0
WireConnection;265;3;314;2
WireConnection;265;4;340;0
WireConnection;293;0;292;0
WireConnection;293;1;2;0
WireConnection;293;2;294;0
WireConnection;268;0;267;0
WireConnection;268;1;109;0
WireConnection;268;2;314;0
WireConnection;268;3;314;2
WireConnection;268;4;340;0
WireConnection;144;0;143;0
WireConnection;144;1;1;0
WireConnection;144;2;145;0
WireConnection;273;0;293;0
WireConnection;273;1;268;0
WireConnection;273;2;265;0
WireConnection;3;0;273;0
WireConnection;3;1;144;0
WireConnection;366;0;337;0
WireConnection;291;0;268;0
WireConnection;291;1;265;0
WireConnection;275;0;3;0
WireConnection;353;0;7;0
WireConnection;327;0;275;0
WireConnection;327;1;291;0
WireConnection;365;1;366;0
WireConnection;365;2;350;0
WireConnection;369;0;365;0
WireConnection;355;0;327;0
WireConnection;355;1;353;0
WireConnection;355;2;356;0
WireConnection;28;0;1;4
WireConnection;28;1;1;4
WireConnection;4;0;28;0
WireConnection;4;1;5;0
WireConnection;368;0;355;0
WireConnection;368;1;369;0
WireConnection;0;9;4;0
WireConnection;0;10;4;0
WireConnection;0;13;368;0
ASEEND*/
//CHKSM=F237979137F1E57DBA3D25B092AADA0A55FE1E3B