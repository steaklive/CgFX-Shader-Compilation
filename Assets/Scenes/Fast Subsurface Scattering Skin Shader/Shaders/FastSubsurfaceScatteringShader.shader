//****************************************************************//

// Fake Subsurface Scattering based on:
// 1) https://colinbarrebrisebois.com/2011/03/07/gdc-2011-approximating-translucency-for-a-fast-cheap-and-convincing-subsurface-scattering-look/
// 2) https://www.alanzucconi.com/2017/08/30/fast-subsurface-scattering-1/

//****************************************************************//

Shader "Custom/FastSubsurfaceScatteringShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ThicknessMap("Thickness Texture", 2D) = "grey" {}

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_DeltaDist ("Subsurface distortion", Range(0,1)) = 0.1
		_Power("Power value for direct translucency", Range(0, 25)) = 0.5
		_Scale("Scale value for direct/back translucency", Range(0, 10)) = 3
		_Attenuation("Attenuation value", Range(0, 5)) = 0.5
		_Ambient("Ambient value", Range(0,1)) = 0.2

	}
	SubShader {

		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardTranslucent fullforwardshadows
		
		#include "UnityPBSLighting.cginc"

		float _Attenuation;
		float _Scale;
		float _Ambient;
		float _Power;
		float _DeltaDist;
		float _Thickness;

		inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			// Original colour
			fixed4 pbr = LightingStandard(s, viewDir, gi);

			// Translucency
			float3 L = gi.light.dir;
			float3 V = viewDir;
			float3 N = s.Normal;
			float3 H = normalize(L + N * _DeltaDist);
			float dotVH = pow(saturate(dot(V, -H)), _Power) * _Scale;
			
			// Back light intensity
			float3 I = _Attenuation * (dotVH + _Ambient) * _Thickness;
			
			pbr.rgb = pbr.rgb + gi.light.color * I;

			return pbr;
		}

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _ThicknessMap;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;

			_Thickness = tex2D(_ThicknessMap, IN.uv_MainTex).r;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
