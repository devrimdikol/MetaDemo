// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RRF_HumanShaders/HairShader2/HairShader2_AS_RRF_VRTC_URP"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_Light_Bias("Light_Bias", Range( 0 , 0.1)) = 0
		_Light_Scale("Light_Scale", Range( 0 , 10)) = 0
		_LightScatter("LightScatter", Range( 0 , 1)) = 0
		_BaseIllumination("BaseIllumination", Range( 0 , 1)) = 0.15
		_SSS("SSS", Range( 0 , 1)) = 0
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Alpha_Level("Alpha_Level", Range( 0 , 2)) = 1
		_VRTC("VRTC", 2D) = "white" {}
		[Toggle(_USEVRTC_BIASANDSCALE_ON)] _UseVRTC_BiasAndScale("UseVRTC_BiasAndScale?", Float) = 0
		_VRTC_Bias("VRTC_Bias", Range( 0 , 1)) = 0
		_VRTC_Scale("VRTC_Scale", Range( 0 , 4)) = 1
		_VariantColor1_GlossA("VariantColor1_Gloss(A)", Color) = (0.8897059,0.1308391,0.1308391,0.516)
		_Variant_Color2_GlossA("Variant_Color2_Gloss(A)", Color) = (0,0.1356491,0.7867647,0.516)
		_RootColorPowerA("RootColor-Power(A)", Color) = (0.1102941,0.1005623,0.1005623,0.453)
		_TipColorPowerA("TipColor-Power(A)", Color) = (0.9448277,1,0,0.484)
		_BumpPower("BumpPower", Range( 0 , 5)) = 0.5
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_MainHighlight_Color("MainHighlight_Color", Color) = (0,0,0,0)
		_MainHighlightPosition("Main Highlight Position", Range( -1 , 3)) = 0
		_MainHighlightStrength("Main Highlight Strength", Range( 0 , 2)) = 0.25
		_MainHighlightExponent("Main Highlight Exponent", Range( 0 , 1000)) = 0.2
		_SecondaryHighlightColor("Secondary Highlight Color", Color) = (0.8862069,0.8862069,0.8862069,0)
		_SecondaryHighlightPosition("Secondary Highlight Position", Range( -1 , 3)) = 0
		_SecondaryHighlightStrength("Secondary Highlight Strength", Range( 0 , 2)) = 0.25
		_SecondaryHighlightExponent("Secondary Highlight Exponent", Range( 0 , 1000)) = 0.2
		_Spread("Spread", Range( 0 , 3)) = 0
		_NoisePower("NoisePower", Range( 0 , 2000)) = 0
		_ExtraCuttingR("ExtraCutting(R)", 2D) = "white" {}
		_Stretch("Stretch", Range( 0.01 , 1.01)) = 0.4961396
		_XTiling("XTiling", Range( 1 , 8)) = 0
		_PushHairs("PushHairs", Range( 0 , 1)) = 0
		_PushHairs_Bias("PushHairs_Bias", Range( 0 , 10)) = 0
		_AlphaClipThreshold("AlphaClipThreshold", Range( 0 , 1)) = 0.5
		_UseArbFakeLightDir("UseArbFakeLightDir", Range( 0 , 1)) = 0
		_ArbitraryFakeLightDir("ArbitraryFakeLightDir", Vector) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Off
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70108

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#pragma shader_feature_local _USEVRTC_BIASANDSCALE_ON


			sampler2D _VRTC;
			sampler2D _NormalMap;
			sampler2D _ExtraCuttingR;
			CBUFFER_START( UnityPerMaterial )
			float _PushHairs;
			float _PushHairs_Bias;
			float4 _VariantColor1_GlossA;
			float4 _Variant_Color2_GlossA;
			float4 _VRTC_ST;
			float _VRTC_Bias;
			float _VRTC_Scale;
			float4 _RootColorPowerA;
			float4 _TipColorPowerA;
			float4 _MainHighlight_Color;
			float3 _ArbitraryFakeLightDir;
			float _UseArbFakeLightDir;
			float _MainHighlightPosition;
			float _BumpPower;
			float4 _NormalMap_ST;
			float _Spread;
			float _NoisePower;
			float _MainHighlightExponent;
			float _MainHighlightStrength;
			float _SecondaryHighlightPosition;
			float _SecondaryHighlightExponent;
			float _SecondaryHighlightStrength;
			float4 _SecondaryHighlightColor;
			float _BaseIllumination;
			float _SSS;
			float _Light_Bias;
			float _Light_Scale;
			float _LightScatter;
			float _Metallic;
			float _Alpha_Level;
			float _XTiling;
			float _Stretch;
			float _AlphaClipThreshold;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv0421 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float3 temp_output_420_0 = ( _PushHairs * pow( ( 1.0 - uv0421.y ) , _PushHairs_Bias ) * v.ase_normal );
				float3 OUTPUT_VertexMotion423 = temp_output_420_0;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord8 = screenPos;
				
				o.ase_texcoord6.xy = v.ase_texcoord.xy;
				o.ase_texcoord7 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord6.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = OUTPUT_VertexMotion423;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float3 WorldNormal = normalize( IN.tSpace0.xyz );
				float3 WorldTangent = IN.tSpace1.xyz;
				float3 WorldBiTangent = IN.tSpace2.xyz;
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				#if SHADER_HINT_NICE_QUALITY
					WorldViewDirection = SafeNormalize( WorldViewDirection );
				#endif

				float2 uv_VRTC = IN.ase_texcoord6.xy * _VRTC_ST.xy + _VRTC_ST.zw;
				float4 tex2DNode335 = tex2D( _VRTC, uv_VRTC );
				#ifdef _USEVRTC_BIASANDSCALE_ON
				float4 staticSwitch373 = ( ( tex2DNode335 + _VRTC_Bias ) * _VRTC_Scale );
				#else
				float4 staticSwitch373 = tex2DNode335;
				#endif
				float4 break372 = staticSwitch373;
				float4 lerpResult328 = lerp( _VariantColor1_GlossA , _Variant_Color2_GlossA , break372.r);
				float4 lerpResult330 = lerp( lerpResult328 , _RootColorPowerA , ( _RootColorPowerA.a * break372.g ));
				float4 lerpResult332 = lerp( lerpResult330 , _TipColorPowerA , ( _TipColorPowerA.a * break372.b ));
				float3 T200 = cross( WorldTangent , WorldNormal );
				float3 lerpResult456 = lerp( SafeNormalize(_MainLightPosition.xyz) , _ArbitraryFakeLightDir , _UseArbFakeLightDir);
				float3 DynamicLightDir459 = lerpResult456;
				float3 break461 = DynamicLightDir459;
				float2 uv_NormalMap = IN.ase_texcoord6.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				float3 tex2DNode7 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap ), _BumpPower );
				float originalAlphaCutout403 = tex2DNode335.a;
				float2 appendResult365 = (float2(_NoisePower , 0.1));
				float2 uv0316 = IN.ase_texcoord6.xy * appendResult365 + float2( 0,0 );
				float simplePerlin2D315 = snoise( uv0316 );
				float NoiseFX312 = ( ( tex2DNode7.g + _Spread ) * ( originalAlphaCutout403 * simplePerlin2D315 ) * _Spread );
				float4 appendResult305 = (float4(break461.x , ( ( _MainHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float4 normalizeResult78 = normalize( ( appendResult305 + float4( WorldViewDirection , 0.0 ) ) );
				float4 H93 = normalizeResult78;
				float dotResult95 = dot( float4( T200 , 0.0 ) , H93 );
				float dotTH94 = dotResult95;
				float sinTH97 = sqrt( ( 1.0 - ( dotTH94 * dotTH94 ) ) );
				float smoothstepResult103 = smoothstep( -1.0 , 0.0 , dotTH94);
				float dirAtten102 = smoothstepResult103;
				float dotResult279 = dot( lerpResult456 , WorldNormal );
				float clampResult290 = clamp( ( dotResult279 * dotResult279 * dotResult279 ) , 0.0 , 1.0 );
				float lightZone285 = clampResult290;
				float3 _Vector0 = float3(1,1,1);
				float4 lerpResult467 = lerp( _MainLightColor , float4( _Vector0 , 0.0 ) , _UseArbFakeLightDir);
				float4 DynamicLightColor468 = lerpResult467;
				float lerpResult471 = lerp( _MainLightColor.a , _Vector0.x , _UseArbFakeLightDir);
				float DynamicLightIntensity470 = lerpResult471;
				float4 temp_output_268_0 = ( _MainHighlight_Color * ( pow( sinTH97 , _MainHighlightExponent ) * _MainHighlightStrength * dirAtten102 * lightZone285 ) * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 appendResult241 = (float4(break461.x , ( ( _SecondaryHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float4 normalizeResult246 = normalize( ( appendResult241 + float4( WorldViewDirection , 0.0 ) ) );
				float4 HL2247 = normalizeResult246;
				float dotResult249 = dot( HL2247 , float4( T200 , 0.0 ) );
				float DotTHL2252 = dotResult249;
				float sinTHL2256 = sqrt( ( 1.0 - ( DotTHL2252 * DotTHL2252 ) ) );
				float4 temp_output_265_0 = ( ( pow( sinTHL2256 , _SecondaryHighlightExponent ) * _SecondaryHighlightStrength * dirAtten102 * lightZone285 ) * _SecondaryHighlightColor * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 OUTPUT_Albedo407 = ( lerpResult332 + temp_output_268_0 + temp_output_265_0 );
				
				float3 OUTPUT_NormalMap410 = tex2DNode7;
				
				float3 objToWorldDir343 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord7.xyz, 0 ) ).xyz;
				float3 normalizeResult345 = normalize( objToWorldDir343 );
				float dotResult346 = dot( DynamicLightDir459 , normalizeResult345 );
				float clampResult353 = clamp( ( ( ( dotResult346 + _Light_Bias ) * _Light_Scale ) * _LightScatter ) , 0.0 , 1.0 );
				float SSS_Effect394 = ( _BaseIllumination * _SSS * clampResult353 );
				float4 lerpResult339 = lerp( ( temp_output_268_0 + temp_output_265_0 ) , OUTPUT_Albedo407 , SSS_Effect394);
				float4 OUTPUT_Emissive398 = lerpResult339;
				
				float lerpResult334 = lerp( _VariantColor1_GlossA.a , _Variant_Color2_GlossA.a , tex2DNode335.r);
				float OUTPUT_Smothness412 = lerpResult334;
				
				float4 screenPos = IN.ase_texcoord8;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen454 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither454 = Dither4x4Bayer( fmod(clipScreen454.x, 4), fmod(clipScreen454.y, 4) );
				float Original_HairAlpha392 = ( originalAlphaCutout403 * _Alpha_Level );
				float2 appendResult390 = (float2(_XTiling , 1.0));
				float2 uv0376 = IN.ase_texcoord6.xy * appendResult390 + float2( 0,0 );
				float2 appendResult381 = (float2(uv0376.x , pow( ( uv0376.y * _Stretch ) , 0.5 )));
				float OUTPUT_HairOpacity388 = ( Original_HairAlpha392 * tex2D( _ExtraCuttingR, appendResult381 ).r );
				dither454 = step( dither454, OUTPUT_HairOpacity388 );
				
				float3 Albedo = OUTPUT_Albedo407.rgb;
				float3 Normal = OUTPUT_NormalMap410;
				float3 Emission = OUTPUT_Emissive398.rgb;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = OUTPUT_Smothness412;
				float Occlusion = 1;
				float Alpha = dither454;
				float AlphaClipThreshold = _AlphaClipThreshold;
				float3 BakedGI = 0;

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal )));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldNormal;
					#else
						inputData.normalWS = normalize( WorldNormal );
					#endif
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif
				
				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70108

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#define SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _VRTC;
			sampler2D _ExtraCuttingR;
			CBUFFER_START( UnityPerMaterial )
			float _PushHairs;
			float _PushHairs_Bias;
			float4 _VariantColor1_GlossA;
			float4 _Variant_Color2_GlossA;
			float4 _VRTC_ST;
			float _VRTC_Bias;
			float _VRTC_Scale;
			float4 _RootColorPowerA;
			float4 _TipColorPowerA;
			float4 _MainHighlight_Color;
			float3 _ArbitraryFakeLightDir;
			float _UseArbFakeLightDir;
			float _MainHighlightPosition;
			float _BumpPower;
			float4 _NormalMap_ST;
			float _Spread;
			float _NoisePower;
			float _MainHighlightExponent;
			float _MainHighlightStrength;
			float _SecondaryHighlightPosition;
			float _SecondaryHighlightExponent;
			float _SecondaryHighlightStrength;
			float4 _SecondaryHighlightColor;
			float _BaseIllumination;
			float _SSS;
			float _Light_Bias;
			float _Light_Scale;
			float _LightScatter;
			float _Metallic;
			float _Alpha_Level;
			float _XTiling;
			float _Stretch;
			float _AlphaClipThreshold;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 uv0421 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float3 temp_output_420_0 = ( _PushHairs * pow( ( 1.0 - uv0421.y ) , _PushHairs_Bias ) * v.ase_normal );
				float3 OUTPUT_VertexMotion423 = temp_output_420_0;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = OUTPUT_VertexMotion423;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;
				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
				
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen454 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither454 = Dither4x4Bayer( fmod(clipScreen454.x, 4), fmod(clipScreen454.y, 4) );
				float2 uv_VRTC = IN.ase_texcoord3.xy * _VRTC_ST.xy + _VRTC_ST.zw;
				float4 tex2DNode335 = tex2D( _VRTC, uv_VRTC );
				float originalAlphaCutout403 = tex2DNode335.a;
				float Original_HairAlpha392 = ( originalAlphaCutout403 * _Alpha_Level );
				float2 appendResult390 = (float2(_XTiling , 1.0));
				float2 uv0376 = IN.ase_texcoord3.xy * appendResult390 + float2( 0,0 );
				float2 appendResult381 = (float2(uv0376.x , pow( ( uv0376.y * _Stretch ) , 0.5 )));
				float OUTPUT_HairOpacity388 = ( Original_HairAlpha392 * tex2D( _ExtraCuttingR, appendResult381 ).r );
				dither454 = step( dither454, OUTPUT_HairOpacity388 );
				
				float Alpha = dither454;
				float AlphaClipThreshold = _AlphaClipThreshold;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70108

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL


			sampler2D _VRTC;
			sampler2D _ExtraCuttingR;
			CBUFFER_START( UnityPerMaterial )
			float _PushHairs;
			float _PushHairs_Bias;
			float4 _VariantColor1_GlossA;
			float4 _Variant_Color2_GlossA;
			float4 _VRTC_ST;
			float _VRTC_Bias;
			float _VRTC_Scale;
			float4 _RootColorPowerA;
			float4 _TipColorPowerA;
			float4 _MainHighlight_Color;
			float3 _ArbitraryFakeLightDir;
			float _UseArbFakeLightDir;
			float _MainHighlightPosition;
			float _BumpPower;
			float4 _NormalMap_ST;
			float _Spread;
			float _NoisePower;
			float _MainHighlightExponent;
			float _MainHighlightStrength;
			float _SecondaryHighlightPosition;
			float _SecondaryHighlightExponent;
			float _SecondaryHighlightStrength;
			float4 _SecondaryHighlightColor;
			float _BaseIllumination;
			float _SSS;
			float _Light_Bias;
			float _Light_Scale;
			float _LightScatter;
			float _Metallic;
			float _Alpha_Level;
			float _XTiling;
			float _Stretch;
			float _AlphaClipThreshold;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv0421 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float3 temp_output_420_0 = ( _PushHairs * pow( ( 1.0 - uv0421.y ) , _PushHairs_Bias ) * v.ase_normal );
				float3 OUTPUT_VertexMotion423 = temp_output_420_0;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = OUTPUT_VertexMotion423;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen454 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither454 = Dither4x4Bayer( fmod(clipScreen454.x, 4), fmod(clipScreen454.y, 4) );
				float2 uv_VRTC = IN.ase_texcoord3.xy * _VRTC_ST.xy + _VRTC_ST.zw;
				float4 tex2DNode335 = tex2D( _VRTC, uv_VRTC );
				float originalAlphaCutout403 = tex2DNode335.a;
				float Original_HairAlpha392 = ( originalAlphaCutout403 * _Alpha_Level );
				float2 appendResult390 = (float2(_XTiling , 1.0));
				float2 uv0376 = IN.ase_texcoord3.xy * appendResult390 + float2( 0,0 );
				float2 appendResult381 = (float2(uv0376.x , pow( ( uv0376.y * _Stretch ) , 0.5 )));
				float OUTPUT_HairOpacity388 = ( Original_HairAlpha392 * tex2D( _ExtraCuttingR, appendResult381 ).r );
				dither454 = step( dither454, OUTPUT_HairOpacity388 );
				
				float Alpha = dither454;
				float AlphaClipThreshold = _AlphaClipThreshold;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70108

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _USEVRTC_BIASANDSCALE_ON


			sampler2D _VRTC;
			sampler2D _NormalMap;
			sampler2D _ExtraCuttingR;
			CBUFFER_START( UnityPerMaterial )
			float _PushHairs;
			float _PushHairs_Bias;
			float4 _VariantColor1_GlossA;
			float4 _Variant_Color2_GlossA;
			float4 _VRTC_ST;
			float _VRTC_Bias;
			float _VRTC_Scale;
			float4 _RootColorPowerA;
			float4 _TipColorPowerA;
			float4 _MainHighlight_Color;
			float3 _ArbitraryFakeLightDir;
			float _UseArbFakeLightDir;
			float _MainHighlightPosition;
			float _BumpPower;
			float4 _NormalMap_ST;
			float _Spread;
			float _NoisePower;
			float _MainHighlightExponent;
			float _MainHighlightStrength;
			float _SecondaryHighlightPosition;
			float _SecondaryHighlightExponent;
			float _SecondaryHighlightStrength;
			float4 _SecondaryHighlightColor;
			float _BaseIllumination;
			float _SSS;
			float _Light_Bias;
			float _Light_Scale;
			float _LightScatter;
			float _Metallic;
			float _Alpha_Level;
			float _XTiling;
			float _Stretch;
			float _AlphaClipThreshold;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv0421 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float3 temp_output_420_0 = ( _PushHairs * pow( ( 1.0 - uv0421.y ) , _PushHairs_Bias ) * v.ase_normal );
				float3 OUTPUT_VertexMotion423 = temp_output_420_0;
				
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord6 = screenPos;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_texcoord5 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = OUTPUT_VertexMotion423;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_VRTC = IN.ase_texcoord2.xy * _VRTC_ST.xy + _VRTC_ST.zw;
				float4 tex2DNode335 = tex2D( _VRTC, uv_VRTC );
				#ifdef _USEVRTC_BIASANDSCALE_ON
				float4 staticSwitch373 = ( ( tex2DNode335 + _VRTC_Bias ) * _VRTC_Scale );
				#else
				float4 staticSwitch373 = tex2DNode335;
				#endif
				float4 break372 = staticSwitch373;
				float4 lerpResult328 = lerp( _VariantColor1_GlossA , _Variant_Color2_GlossA , break372.r);
				float4 lerpResult330 = lerp( lerpResult328 , _RootColorPowerA , ( _RootColorPowerA.a * break372.g ));
				float4 lerpResult332 = lerp( lerpResult330 , _TipColorPowerA , ( _TipColorPowerA.a * break372.b ));
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 T200 = cross( ase_worldTangent , ase_worldNormal );
				float3 lerpResult456 = lerp( SafeNormalize(_MainLightPosition.xyz) , _ArbitraryFakeLightDir , _UseArbFakeLightDir);
				float3 DynamicLightDir459 = lerpResult456;
				float3 break461 = DynamicLightDir459;
				float2 uv_NormalMap = IN.ase_texcoord2.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				float3 tex2DNode7 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap ), _BumpPower );
				float originalAlphaCutout403 = tex2DNode335.a;
				float2 appendResult365 = (float2(_NoisePower , 0.1));
				float2 uv0316 = IN.ase_texcoord2.xy * appendResult365 + float2( 0,0 );
				float simplePerlin2D315 = snoise( uv0316 );
				float NoiseFX312 = ( ( tex2DNode7.g + _Spread ) * ( originalAlphaCutout403 * simplePerlin2D315 ) * _Spread );
				float4 appendResult305 = (float4(break461.x , ( ( _MainHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float4 normalizeResult78 = normalize( ( appendResult305 + float4( ase_worldViewDir , 0.0 ) ) );
				float4 H93 = normalizeResult78;
				float dotResult95 = dot( float4( T200 , 0.0 ) , H93 );
				float dotTH94 = dotResult95;
				float sinTH97 = sqrt( ( 1.0 - ( dotTH94 * dotTH94 ) ) );
				float smoothstepResult103 = smoothstep( -1.0 , 0.0 , dotTH94);
				float dirAtten102 = smoothstepResult103;
				float dotResult279 = dot( lerpResult456 , ase_worldNormal );
				float clampResult290 = clamp( ( dotResult279 * dotResult279 * dotResult279 ) , 0.0 , 1.0 );
				float lightZone285 = clampResult290;
				float3 _Vector0 = float3(1,1,1);
				float4 lerpResult467 = lerp( _MainLightColor , float4( _Vector0 , 0.0 ) , _UseArbFakeLightDir);
				float4 DynamicLightColor468 = lerpResult467;
				float lerpResult471 = lerp( _MainLightColor.a , _Vector0.x , _UseArbFakeLightDir);
				float DynamicLightIntensity470 = lerpResult471;
				float4 temp_output_268_0 = ( _MainHighlight_Color * ( pow( sinTH97 , _MainHighlightExponent ) * _MainHighlightStrength * dirAtten102 * lightZone285 ) * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 appendResult241 = (float4(break461.x , ( ( _SecondaryHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float4 normalizeResult246 = normalize( ( appendResult241 + float4( ase_worldViewDir , 0.0 ) ) );
				float4 HL2247 = normalizeResult246;
				float dotResult249 = dot( HL2247 , float4( T200 , 0.0 ) );
				float DotTHL2252 = dotResult249;
				float sinTHL2256 = sqrt( ( 1.0 - ( DotTHL2252 * DotTHL2252 ) ) );
				float4 temp_output_265_0 = ( ( pow( sinTHL2256 , _SecondaryHighlightExponent ) * _SecondaryHighlightStrength * dirAtten102 * lightZone285 ) * _SecondaryHighlightColor * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 OUTPUT_Albedo407 = ( lerpResult332 + temp_output_268_0 + temp_output_265_0 );
				
				float3 objToWorldDir343 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord5.xyz, 0 ) ).xyz;
				float3 normalizeResult345 = normalize( objToWorldDir343 );
				float dotResult346 = dot( DynamicLightDir459 , normalizeResult345 );
				float clampResult353 = clamp( ( ( ( dotResult346 + _Light_Bias ) * _Light_Scale ) * _LightScatter ) , 0.0 , 1.0 );
				float SSS_Effect394 = ( _BaseIllumination * _SSS * clampResult353 );
				float4 lerpResult339 = lerp( ( temp_output_268_0 + temp_output_265_0 ) , OUTPUT_Albedo407 , SSS_Effect394);
				float4 OUTPUT_Emissive398 = lerpResult339;
				
				float4 screenPos = IN.ase_texcoord6;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen454 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither454 = Dither4x4Bayer( fmod(clipScreen454.x, 4), fmod(clipScreen454.y, 4) );
				float Original_HairAlpha392 = ( originalAlphaCutout403 * _Alpha_Level );
				float2 appendResult390 = (float2(_XTiling , 1.0));
				float2 uv0376 = IN.ase_texcoord2.xy * appendResult390 + float2( 0,0 );
				float2 appendResult381 = (float2(uv0376.x , pow( ( uv0376.y * _Stretch ) , 0.5 )));
				float OUTPUT_HairOpacity388 = ( Original_HairAlpha392 * tex2D( _ExtraCuttingR, appendResult381 ).r );
				dither454 = step( dither454, OUTPUT_HairOpacity388 );
				
				
				float3 Albedo = OUTPUT_Albedo407.rgb;
				float3 Emission = OUTPUT_Emissive398.rgb;
				float Alpha = dither454;
				float AlphaClipThreshold = _AlphaClipThreshold;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70108

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _USEVRTC_BIASANDSCALE_ON


			sampler2D _VRTC;
			sampler2D _NormalMap;
			sampler2D _ExtraCuttingR;
			CBUFFER_START( UnityPerMaterial )
			float _PushHairs;
			float _PushHairs_Bias;
			float4 _VariantColor1_GlossA;
			float4 _Variant_Color2_GlossA;
			float4 _VRTC_ST;
			float _VRTC_Bias;
			float _VRTC_Scale;
			float4 _RootColorPowerA;
			float4 _TipColorPowerA;
			float4 _MainHighlight_Color;
			float3 _ArbitraryFakeLightDir;
			float _UseArbFakeLightDir;
			float _MainHighlightPosition;
			float _BumpPower;
			float4 _NormalMap_ST;
			float _Spread;
			float _NoisePower;
			float _MainHighlightExponent;
			float _MainHighlightStrength;
			float _SecondaryHighlightPosition;
			float _SecondaryHighlightExponent;
			float _SecondaryHighlightStrength;
			float4 _SecondaryHighlightColor;
			float _BaseIllumination;
			float _SSS;
			float _Light_Bias;
			float _Light_Scale;
			float _LightScatter;
			float _Metallic;
			float _Alpha_Level;
			float _XTiling;
			float _Stretch;
			float _AlphaClipThreshold;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 uv0421 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float3 temp_output_420_0 = ( _PushHairs * pow( ( 1.0 - uv0421.y ) , _PushHairs_Bias ) * v.ase_normal );
				float3 OUTPUT_VertexMotion423 = temp_output_420_0;
				
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = OUTPUT_VertexMotion423;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_VRTC = IN.ase_texcoord2.xy * _VRTC_ST.xy + _VRTC_ST.zw;
				float4 tex2DNode335 = tex2D( _VRTC, uv_VRTC );
				#ifdef _USEVRTC_BIASANDSCALE_ON
				float4 staticSwitch373 = ( ( tex2DNode335 + _VRTC_Bias ) * _VRTC_Scale );
				#else
				float4 staticSwitch373 = tex2DNode335;
				#endif
				float4 break372 = staticSwitch373;
				float4 lerpResult328 = lerp( _VariantColor1_GlossA , _Variant_Color2_GlossA , break372.r);
				float4 lerpResult330 = lerp( lerpResult328 , _RootColorPowerA , ( _RootColorPowerA.a * break372.g ));
				float4 lerpResult332 = lerp( lerpResult330 , _TipColorPowerA , ( _TipColorPowerA.a * break372.b ));
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 T200 = cross( ase_worldTangent , ase_worldNormal );
				float3 lerpResult456 = lerp( SafeNormalize(_MainLightPosition.xyz) , _ArbitraryFakeLightDir , _UseArbFakeLightDir);
				float3 DynamicLightDir459 = lerpResult456;
				float3 break461 = DynamicLightDir459;
				float2 uv_NormalMap = IN.ase_texcoord2.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				float3 tex2DNode7 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap ), _BumpPower );
				float originalAlphaCutout403 = tex2DNode335.a;
				float2 appendResult365 = (float2(_NoisePower , 0.1));
				float2 uv0316 = IN.ase_texcoord2.xy * appendResult365 + float2( 0,0 );
				float simplePerlin2D315 = snoise( uv0316 );
				float NoiseFX312 = ( ( tex2DNode7.g + _Spread ) * ( originalAlphaCutout403 * simplePerlin2D315 ) * _Spread );
				float4 appendResult305 = (float4(break461.x , ( ( _MainHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float4 normalizeResult78 = normalize( ( appendResult305 + float4( ase_worldViewDir , 0.0 ) ) );
				float4 H93 = normalizeResult78;
				float dotResult95 = dot( float4( T200 , 0.0 ) , H93 );
				float dotTH94 = dotResult95;
				float sinTH97 = sqrt( ( 1.0 - ( dotTH94 * dotTH94 ) ) );
				float smoothstepResult103 = smoothstep( -1.0 , 0.0 , dotTH94);
				float dirAtten102 = smoothstepResult103;
				float dotResult279 = dot( lerpResult456 , ase_worldNormal );
				float clampResult290 = clamp( ( dotResult279 * dotResult279 * dotResult279 ) , 0.0 , 1.0 );
				float lightZone285 = clampResult290;
				float3 _Vector0 = float3(1,1,1);
				float4 lerpResult467 = lerp( _MainLightColor , float4( _Vector0 , 0.0 ) , _UseArbFakeLightDir);
				float4 DynamicLightColor468 = lerpResult467;
				float lerpResult471 = lerp( _MainLightColor.a , _Vector0.x , _UseArbFakeLightDir);
				float DynamicLightIntensity470 = lerpResult471;
				float4 temp_output_268_0 = ( _MainHighlight_Color * ( pow( sinTH97 , _MainHighlightExponent ) * _MainHighlightStrength * dirAtten102 * lightZone285 ) * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 appendResult241 = (float4(break461.x , ( ( _SecondaryHighlightPosition + NoiseFX312 ) + break461.y ) , break461.z , 0.0));
				float4 normalizeResult246 = normalize( ( appendResult241 + float4( ase_worldViewDir , 0.0 ) ) );
				float4 HL2247 = normalizeResult246;
				float dotResult249 = dot( HL2247 , float4( T200 , 0.0 ) );
				float DotTHL2252 = dotResult249;
				float sinTHL2256 = sqrt( ( 1.0 - ( DotTHL2252 * DotTHL2252 ) ) );
				float4 temp_output_265_0 = ( ( pow( sinTHL2256 , _SecondaryHighlightExponent ) * _SecondaryHighlightStrength * dirAtten102 * lightZone285 ) * _SecondaryHighlightColor * DynamicLightColor468 * DynamicLightIntensity470 );
				float4 OUTPUT_Albedo407 = ( lerpResult332 + temp_output_268_0 + temp_output_265_0 );
				
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen454 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither454 = Dither4x4Bayer( fmod(clipScreen454.x, 4), fmod(clipScreen454.y, 4) );
				float Original_HairAlpha392 = ( originalAlphaCutout403 * _Alpha_Level );
				float2 appendResult390 = (float2(_XTiling , 1.0));
				float2 uv0376 = IN.ase_texcoord2.xy * appendResult390 + float2( 0,0 );
				float2 appendResult381 = (float2(uv0376.x , pow( ( uv0376.y * _Stretch ) , 0.5 )));
				float OUTPUT_HairOpacity388 = ( Original_HairAlpha392 * tex2D( _ExtraCuttingR, appendResult381 ).r );
				dither454 = step( dither454, OUTPUT_HairOpacity388 );
				
				
				float3 Albedo = OUTPUT_Albedo407.rgb;
				float Alpha = dither454;
				float AlphaClipThreshold = _AlphaClipThreshold;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=17800
1920;12;1920;1017;3817.625;1520.436;4.020774;True;True
Node;AmplifyShaderEditor.CommentaryNode;402;-632.5151,280.1337;Inherit;False;1958.913;736.6984;Comment;14;311;390;384;364;365;316;315;300;307;299;114;7;404;410;Noise and Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;406;-3766.658,-1337.893;Inherit;False;3050.46;2470.514;Comment;76;392;331;328;372;329;403;335;267;314;109;264;261;108;260;259;106;286;258;104;107;105;262;326;327;102;257;285;290;256;103;97;396;373;370;289;255;132;371;134;368;254;253;99;98;252;249;94;95;251;248;96;247;200;93;246;245;78;241;77;243;17;305;304;306;268;397;265;292;330;466;467;468;471;470;474;475;Color and Highlight Mixing;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-582.5151,885.101;Float;False;Property;_NoisePower;NoisePower;26;0;Create;True;0;0;False;0;0;0;0;2000;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;335;-2762.142,-606.1206;Inherit;True;Property;_VRTC;VRTC;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;365;-226.7994,869.5599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;316;-72.07491,860.832;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;403;-2296.331,-510.8635;Float;False;originalAlphaCutout;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-512.2765,424.4365;Float;False;Property;_BumpPower;BumpPower;15;0;Create;True;0;0;False;0;0.5;1.46;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-73.77025,365.0654;Inherit;True;Property;_NormalMap;NormalMap;5;0;Create;True;0;0;False;0;-1;cf24829a9bef4734582a302bd6f6d130;cf24829a9bef4734582a302bd6f6d130;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;315;236.0447,834.2753;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;405;-4703.304,-412.4611;Inherit;False;687.4736;934.2229;Comment;8;79;198;280;284;279;197;457;458;Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;404;143.3906,629.5546;Inherit;False;403;originalAlphaCutout;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-537.5021,693.4656;Float;False;Property;_Spread;Spread;25;0;Create;True;0;0;False;0;0;0.49;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;311;722.4737,330.1337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;446.4015,661.6004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;458;-4685.002,108.615;Inherit;False;Property;_UseArbFakeLightDir;UseArbFakeLightDir;33;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;280;-4651.655,197.8752;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;457;-4650.923,-31.43463;Inherit;False;Property;_ArbitraryFakeLightDir;ArbitraryFakeLightDir;34;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;401;1329.368,272.7834;Inherit;False;1769.893;663.4403;Comment;11;312;380;376;379;383;391;381;374;393;375;388;Final Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;456;-4349.923,32.56537;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;909.0762,452.3024;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;459;-4180.004,27.68579;Inherit;False;DynamicLightDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;1409.546,485.2986;Float;False;NoiseFX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-4611.419,-1120.539;Inherit;True;312;NoiseFX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-4666.173,-818.6374;Float;False;Property;_MainHighlightPosition;Main Highlight Position;18;0;Create;True;0;0;False;0;0;-0.56;-1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;460;-4371.457,-880.3517;Inherit;False;459;DynamicLightDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;-3851.941,-508.676;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-3992.72,-1179.694;Float;False;Property;_SecondaryHighlightPosition;Secondary Highlight Position;22;0;Create;True;0;0;False;0;0;-0.36;-1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;461;-4165.221,-879.2662;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;306;-3607.776,-1151.192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;304;-3529.548,-530.8989;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;17;-3716.658,-771.6227;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;243;-3437.132,-1116.554;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;305;-3364.19,-581.8586;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-3236.372,-718.7031;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;241;-3187.773,-1096.639;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;198;-4653.304,-180.1292;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;245;-2901.15,-1041.931;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;78;-3038.574,-723.9587;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexTangentNode;79;-4630.145,-362.4611;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CrossProductOpNode;197;-4203.83,-313.4554;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;246;-2708.667,-1048.994;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2836.758,-693.7408;Float;False;H;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;247;-2392.758,-1058.078;Float;False;HL2;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-3489.306,-399.9858;Float;False;T;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3540.833,-259.7031;Inherit;False;93;H;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;-3588.091,551.6077;Inherit;False;200;T;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;248;-3604.341,449.2595;Inherit;False;247;HL2;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;95;-3241.022,-364.4166;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-3064.083,-364.068;Float;False;dotTH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;249;-3268.591,476.1266;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-3555.498,-149.8855;Inherit;False;94;dotTH;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;252;-3023.732,481.425;Float;False;DotTHL2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;284;-4647.628,342.7618;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;384;715.2823,694.3094;Float;False;Property;_XTiling;XTiling;29;0;Create;True;0;0;False;0;0;6.26;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-3264.076,-148.8628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-2734.597,484.8329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;279;-4236.963,244.6978;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;390;1159.397,582.9752;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;254;-2533.547,500.5397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;134;-3060.209,-180.9998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;368;-2729.725,-381.3201;Float;False;Property;_VRTC_Bias;VRTC_Bias;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-2728.873,-294.687;Float;False;Property;_VRTC_Scale;VRTC_Scale;10;0;Create;True;0;0;False;0;1;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;380;1379.835,734.2379;Float;False;Property;_Stretch;Stretch;28;0;Create;True;0;0;False;0;0.4961396;1.01;0.01;1.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;370;-2285.945,-426.237;Inherit;False;ConstantBiasScale;-1;;7;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SqrtOpNode;132;-2858.072,-225.2531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;255;-2330.928,498.9691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;376;1452.762,579.4526;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-3664.241,196.1259;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;314;-2071.932,118.5198;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;466;-2064.816,254.9063;Inherit;False;Constant;_Vector0;Vector 0;35;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;373;-1935.277,-600.7404;Float;False;Property;_UseVRTC_BiasAndScale;UseVRTC_BiasAndScale?;8;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;379;1711.405,649.4501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;103;-3234.803,-1.916496;Inherit;False;3;0;FLOAT;-1;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;-2131.45,498.9688;Float;False;sinTHL2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;396;-2091.989,-289.3039;Float;False;Property;_Alpha_Level;Alpha_Level;6;0;Create;True;0;0;False;0;1;1.44;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;290;-3444.781,238.476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;383;1379.368,821.2239;Float;False;Constant;_Adjust;Adjust;29;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2664.505,-204.7087;Float;False;sinTH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;391;1863.139,734.4855;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;397;-1770.882,-352.9533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-2516.188,51.67668;Inherit;False;97;sinTH;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;-2630.373,908.2946;Inherit;False;256;sinTHL2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;327;-2427.24,-787.0815;Float;False;Property;_Variant_Color2_GlossA;Variant_Color2_Gloss(A);12;0;Create;True;0;0;False;0;0,0.1356491,0.7867647,0.516;0.1764706,0.1256055,0.04930796,0.503;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;372;-1643.475,-762.1263;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;262;-2662.638,673.6901;Float;False;Property;_SecondaryHighlightExponent;Secondary Highlight Exponent;24;0;Create;True;0;0;False;0;0.2;128;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;326;-2428.317,-963.6812;Float;False;Property;_VariantColor1_GlossA;VariantColor1_Gloss(A);11;0;Create;True;0;0;False;0;0.8897059,0.1308391,0.1308391,0.516;0.1470588,0.08713162,0.04108997,0.21;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;467;-1855.161,167.9553;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;329;-2045.256,-1287.893;Float;False;Property;_RootColorPowerA;RootColor-Power(A);13;0;Create;True;0;0;False;0;0.1102941,0.1005623,0.1005623,0.453;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;471;-1835.48,303.5219;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;285;-3266.51,186.3421;Float;False;lightZone;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2597.844,129.8814;Float;False;Property;_MainHighlightExponent;Main Highlight Exponent;20;0;Create;True;0;0;False;0;0.2;33;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-2977.938,-10.84821;Float;False;dirAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;422;314.8744,-2155.113;Inherit;False;1833.611;570.7649;Comment;10;433;423;434;420;429;425;421;445;446;447;Movement;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;292;-1071.695,-941.9322;Float;False;Property;_TipColorPowerA;TipColor-Power(A);14;0;Create;True;0;0;False;0;0.9448277,1,0,0.484;0.1838235,0.120026,0.02432959,0.791;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;106;-2242,-30.08257;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;258;-2281.745,618.481;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;381;1982.499,560.7893;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2592.595,210.4834;Float;False;Property;_MainHighlightStrength;Main Highlight Strength;19;0;Create;True;0;0;False;0;0.25;0.16;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-2557.82,297.1773;Inherit;False;102;dirAtten;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;468;-1654.091,194.5808;Inherit;False;DynamicLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-2644.141,764.4827;Float;False;Property;_SecondaryHighlightStrength;Secondary Highlight Strength;23;0;Create;True;0;0;False;0;0.25;0.24;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;-1407.002,-1128.471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;392;-1346.511,-410.5788;Float;False;Original_HairAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-2622.614,840.986;Inherit;False;102;dirAtten;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;286;-2448.143,371.9342;Inherit;False;285;lightZone;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;328;-1294.275,-976.7998;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;421;373.38,-1997.139;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;470;-1664.805,312.1093;Inherit;False;DynamicLightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2074.68,-48.38425;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;-1842.994,-52.85852;Inherit;False;468;DynamicLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;-598.7312,-830.5269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;446;425.184,-1707.961;Float;False;Property;_PushHairs_Bias;PushHairs_Bias;31;0;Create;True;0;0;False;0;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;267;-2323.583,-261.4672;Float;False;Property;_MainHighlight_Color;MainHighlight_Color;17;0;Create;True;0;0;False;0;0,0,0,0;0.3925173,0.4008352,0.4852941,0.828;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-2022.083,674.0374;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;264;-2017.542,831.6193;Float;False;Property;_SecondaryHighlightColor;Secondary Highlight Color;21;0;Create;True;0;0;False;0;0.8862069,0.8862069,0.8862069,0;1,1,1,0.034;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;374;2182.722,446.7526;Inherit;True;Property;_ExtraCuttingR;ExtraCutting(R);27;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;475;-1858.025,22.28193;Inherit;False;470;DynamicLightIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;2204.727,322.7834;Inherit;False;392;Original_HairAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;330;-907.5844,-1195.583;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;425;622.9376,-1982.877;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;2596.22,391.5271;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;-895.7122,10.42883;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;447;1101.521,-1881.439;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-1474.88,-167.5516;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;429;411.1858,-2084.723;Float;False;Property;_PushHairs;PushHairs;30;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;332;-346.5797,-1040.599;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;445;855.6922,-1930.251;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;35.06141,-940.5189;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;414;2500.923,-1963.795;Inherit;False;1030.613;686.589;Comment;14;452;450;449;448;451;389;408;413;399;411;29;424;453;454;FINAL OUTPUTs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;388;2811.26,394.7545;Float;False;OUTPUT_HairOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;420;1356.595,-1952.198;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;341;-542.1967,1095.895;Inherit;False;2464.81;682.6744;ScatterLight;15;394;363;357;353;340;352;349;351;348;347;346;345;343;342;462;SSS;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;407;303.9502,-965.624;Float;False;OUTPUT_Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;423;1825.246,-1766.413;Float;False;OUTPUT_VertexMotion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;389;2570.967,-1485.191;Inherit;False;388;OUTPUT_HairOpacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;400;951.4557,-139.1102;Inherit;False;860.995;360.5265;Comment;5;291;395;339;398;409;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;2550.923,-1746.575;Inherit;False;398;OUTPUT_Emissive;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;398;1542.451,-89.11021;Float;False;OUTPUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;353;994.4028,1338.479;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;345;49.59906,1414.142;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;782.5613,1351.349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;342;-491.7099,1444.238;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;408;2582.995,-1913.795;Inherit;False;407;OUTPUT_Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;339;1308.01,-85.75253;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;395;1058.093,106.4162;Inherit;False;394;SSS_Effect;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;434;1512.991,-1741.734;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DitheringNode;454;2912.915,-1533.021;Inherit;False;0;True;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;349;487.6428,1298.705;Inherit;False;ConstantBiasScale;-1;;8;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;413;2565.971,-1564.302;Inherit;False;412;OUTPUT_Smothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;343;-225.4491,1401.88;Inherit;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;409;977.3808,11.72447;Inherit;False;407;OUTPUT_Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;1591.598,1161.339;Float;False;SSS_Effect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;334;8.17156,-663.4929;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;924.7745,1137.039;Float;False;Property;_BaseIllumination;BaseIllumination;3;0;Create;True;0;0;False;0;0.15;0.154;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;929.132,1229.432;Float;False;Property;_SSS;SSS;4;0;Create;True;0;0;False;0;0;0.889;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;346;254.6646,1252.074;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;363;1352.02,1172.726;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;291;989.6982,-100.2515;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-247.6851,1548.879;Float;False;Property;_Light_Bias;Light_Bias;0;0;Create;True;0;0;False;0;0;0.0201;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;424;2567.712,-1406.594;Inherit;False;423;OUTPUT_VertexMotion;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;453;2887.446,-1625.141;Inherit;False;Property;_AlphaClipThreshold;AlphaClipThreshold;32;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;2552.708,-1653.873;Float;False;Property;_Metallic;Metallic;16;0;Create;True;0;0;False;0;0;0.453;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;411;2559.048,-1826.162;Inherit;False;410;OUTPUT_NormalMap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;462;-494.8306,1242.294;Inherit;False;459;DynamicLightDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;348;-254.5041,1661.022;Float;False;Property;_Light_Scale;Light_Scale;1;0;Create;True;0;0;False;0;0;2.77;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;433;1109.599,-1708.825;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;266.5262,365.2551;Float;False;OUTPUT_NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;412;341.6769,-669.2474;Float;False;OUTPUT_Smothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;351;118.6937,1671.82;Float;False;Property;_LightScatter;LightScatter;2;0;Create;True;0;0;False;0;0;0.355;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;455;3296.537,-1725.504;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;450;2942.537,-1783.504;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;448;3296.537,-1725.504;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;RRF_HumanShaders/HairShader2/HairShader2_AS_RRF_VRTC_URP;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;12;False;False;False;True;2;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;13;Workflow;1;Surface;0;  Blend;0;Two Sided;0;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Extra Pre Pass;0;Vertex Position,InvertActionOnDeselection;1;0;6;False;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;452;2942.537,-1783.504;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;449;2942.537,-1783.504;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;451;2942.537,-1783.504;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;365;0;364;0
WireConnection;316;0;365;0
WireConnection;403;0;335;4
WireConnection;7;5;114;0
WireConnection;315;0;316;0
WireConnection;311;0;7;2
WireConnection;311;1;300;0
WireConnection;307;0;404;0
WireConnection;307;1;315;0
WireConnection;456;0;280;0
WireConnection;456;1;457;0
WireConnection;456;2;458;0
WireConnection;299;0;311;0
WireConnection;299;1;307;0
WireConnection;299;2;300;0
WireConnection;459;0;456;0
WireConnection;312;0;299;0
WireConnection;298;0;303;0
WireConnection;298;1;313;0
WireConnection;461;0;460;0
WireConnection;306;0;244;0
WireConnection;306;1;313;0
WireConnection;304;0;298;0
WireConnection;304;1;461;1
WireConnection;243;0;306;0
WireConnection;243;1;461;1
WireConnection;305;0;461;0
WireConnection;305;1;304;0
WireConnection;305;2;461;2
WireConnection;77;0;305;0
WireConnection;77;1;17;0
WireConnection;241;0;461;0
WireConnection;241;1;243;0
WireConnection;241;2;461;2
WireConnection;245;0;241;0
WireConnection;245;1;17;0
WireConnection;78;0;77;0
WireConnection;197;0;79;0
WireConnection;197;1;198;0
WireConnection;246;0;245;0
WireConnection;93;0;78;0
WireConnection;247;0;246;0
WireConnection;200;0;197;0
WireConnection;95;0;200;0
WireConnection;95;1;96;0
WireConnection;94;0;95;0
WireConnection;249;0;248;0
WireConnection;249;1;251;0
WireConnection;252;0;249;0
WireConnection;99;0;98;0
WireConnection;99;1;98;0
WireConnection;253;0;252;0
WireConnection;253;1;252;0
WireConnection;279;0;456;0
WireConnection;279;1;284;0
WireConnection;390;0;384;0
WireConnection;254;0;253;0
WireConnection;134;0;99;0
WireConnection;370;3;335;0
WireConnection;370;1;368;0
WireConnection;370;2;371;0
WireConnection;132;0;134;0
WireConnection;255;0;254;0
WireConnection;376;0;390;0
WireConnection;289;0;279;0
WireConnection;289;1;279;0
WireConnection;289;2;279;0
WireConnection;373;1;335;0
WireConnection;373;0;370;0
WireConnection;379;0;376;2
WireConnection;379;1;380;0
WireConnection;103;0;98;0
WireConnection;256;0;255;0
WireConnection;290;0;289;0
WireConnection;97;0;132;0
WireConnection;391;0;379;0
WireConnection;391;1;383;0
WireConnection;397;0;403;0
WireConnection;397;1;396;0
WireConnection;372;0;373;0
WireConnection;467;0;314;0
WireConnection;467;1;466;0
WireConnection;467;2;458;0
WireConnection;471;0;314;2
WireConnection;471;1;466;1
WireConnection;471;2;458;0
WireConnection;285;0;290;0
WireConnection;102;0;103;0
WireConnection;106;0;105;0
WireConnection;106;1;107;0
WireConnection;258;0;257;0
WireConnection;258;1;262;0
WireConnection;381;0;376;1
WireConnection;381;1;391;0
WireConnection;468;0;467;0
WireConnection;331;0;329;4
WireConnection;331;1;372;1
WireConnection;392;0;397;0
WireConnection;328;0;326;0
WireConnection;328;1;327;0
WireConnection;328;2;372;0
WireConnection;470;0;471;0
WireConnection;109;0;106;0
WireConnection;109;1;108;0
WireConnection;109;2;104;0
WireConnection;109;3;286;0
WireConnection;333;0;292;4
WireConnection;333;1;372;2
WireConnection;261;0;258;0
WireConnection;261;1;259;0
WireConnection;261;2;260;0
WireConnection;261;3;286;0
WireConnection;374;1;381;0
WireConnection;330;0;328;0
WireConnection;330;1;329;0
WireConnection;330;2;331;0
WireConnection;425;0;421;2
WireConnection;375;0;393;0
WireConnection;375;1;374;1
WireConnection;265;0;261;0
WireConnection;265;1;264;0
WireConnection;265;2;474;0
WireConnection;265;3;475;0
WireConnection;268;0;267;0
WireConnection;268;1;109;0
WireConnection;268;2;474;0
WireConnection;268;3;475;0
WireConnection;332;0;330;0
WireConnection;332;1;292;0
WireConnection;332;2;333;0
WireConnection;445;0;425;0
WireConnection;445;1;446;0
WireConnection;273;0;332;0
WireConnection;273;1;268;0
WireConnection;273;2;265;0
WireConnection;388;0;375;0
WireConnection;420;0;429;0
WireConnection;420;1;445;0
WireConnection;420;2;447;0
WireConnection;407;0;273;0
WireConnection;423;0;420;0
WireConnection;398;0;339;0
WireConnection;353;0;352;0
WireConnection;345;0;343;0
WireConnection;352;0;349;0
WireConnection;352;1;351;0
WireConnection;339;0;291;0
WireConnection;339;1;409;0
WireConnection;339;2;395;0
WireConnection;434;0;420;0
WireConnection;434;1;433;0
WireConnection;454;0;389;0
WireConnection;349;3;346;0
WireConnection;349;1;347;0
WireConnection;349;2;348;0
WireConnection;343;0;342;0
WireConnection;394;0;363;0
WireConnection;334;0;326;4
WireConnection;334;1;327;4
WireConnection;334;2;335;1
WireConnection;346;0;462;0
WireConnection;346;1;345;0
WireConnection;363;0;340;0
WireConnection;363;1;357;0
WireConnection;363;2;353;0
WireConnection;291;0;268;0
WireConnection;291;1;265;0
WireConnection;410;0;7;0
WireConnection;412;0;334;0
WireConnection;448;0;408;0
WireConnection;448;1;411;0
WireConnection;448;2;399;0
WireConnection;448;3;29;0
WireConnection;448;4;413;0
WireConnection;448;6;454;0
WireConnection;448;7;453;0
WireConnection;448;8;424;0
ASEEND*/
//CHKSM=1C9CA4AB7BB32FB54437DA897E507A28C65A636E