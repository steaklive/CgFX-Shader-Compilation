// Oren-Nayar shading model
// https://en.wikipedia.org/wiki/Oren%E2%80%93Nayar_reflectance_model
// https://answers.unity.com/questions/565422/need-help-with-oren-nayar-lighting-model.html

Shader "Custom/OrenNayarShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Roughness ("Roughness", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf OrenNayar 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		float _Roughness;
		fixed4 _Color;


		inline float4 LightingOrenNayar(SurfaceOutput s, half3 lightDir, half3 viewDir, half attenuation) {
			
			//A and B
			float roughness = _Roughness;
			float sigma = roughness * roughness;

			float2 OrenNayarCoefficent = sigma / (sigma + float2(0.33, 0.09));
			float2 OrenNayarFactor = float2(1, 0) + float2(-0.5, 0.45) * OrenNayarCoefficent;

			//Angles
			float2 cosTheta = saturate(float2(dot(s.Normal, lightDir), dot(s.Normal, viewDir)));
			float sinTheta = sqrt((1 - cosTheta.x*cosTheta.x)*(1 - cosTheta.y*cosTheta.y));

			float3 lightPlane = normalize(lightDir - cosTheta.x*s.Normal);
			float3 viewPlane = normalize(viewDir - cosTheta.y*s.Normal);

			float cosPhi = saturate(dot(lightPlane, viewPlane));

			float OrenNayarDiffuse = cosPhi * sinTheta / max(cosTheta.x, cosTheta.y);

			float diffuse = cosTheta.x * (OrenNayarCoefficent.x + OrenNayarCoefficent.y * OrenNayarDiffuse);
			
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb*(diffuse*attenuation);
			col.a = s.Alpha;
			
			return col;

		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
