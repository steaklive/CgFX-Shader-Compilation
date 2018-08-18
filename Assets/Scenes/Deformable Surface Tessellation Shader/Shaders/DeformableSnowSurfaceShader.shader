// Surface tessellation shader that uses a Displacement texture for moving vertices

Shader "Custom/DeformableSnowSurfaceShader" {
	Properties {
		_Tess ("Tessellation", Range(1, 32)) = 4

		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_MainNormal("Main Bump Texture", 2D) = "bump" {}
		_SecondColor("Second Color", Color) = (1,1,1,1)
		_SecondTex("Second Texture (RGB)", 2D) = "white" {}

		_DispTex("Displacement Texture", 2D) = "black" {}
		_Displacement("Displacement Factor", Range(0,1)) = 0.3
		
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows vertex:disp tessellate:tessDistance
			
		#pragma target 4.6
		#include "Tessellation.cginc"
		
		struct appdata {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		float _Tess;

		float4 tessDistance(appdata v0, appdata v1, appdata v2) {
			float minDist = 10.0;
			float maxDist = 25.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
		}



		sampler2D _MainTex;
		sampler2D _MainNormal;
		sampler2D _SecondTex;
		sampler2D _DispTex;
		float _Displacement;
		fixed4 _Color;
		fixed4 _SecondColor;



		struct Input {
			float2 uv_MainTex;
			float2 uv_MainNormal;
			float2 uv_SecondTex;
			float2 uv_DispTex;
		};

		half _Glossiness;
		half _Metallic;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void disp(inout appdata v)
		{
			float val = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0, 0)).r;

			float d = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0, 0)).r * _Displacement;

			v.vertex.xyz -= v.normal * d;
			v.vertex.xyz += v.normal*_Displacement;

		}
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			half factor = tex2Dlod(_DispTex, float4(IN.uv_DispTex.xy, 0, 0)).r;
			fixed4 c = lerp(tex2D (_MainTex, IN.uv_MainTex) * _Color, tex2D(_SecondTex, IN.uv_SecondTex) * _SecondColor, factor );
			o.Albedo = c.rgb;

			o.Normal = UnpackNormal(tex2D(_MainNormal, IN.uv_MainNormal));
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}


	FallBack "Diffuse"
}
