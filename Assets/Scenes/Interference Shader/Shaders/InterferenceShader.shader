// Simple interference shader.
// Credits to "Graphics Shaders: Theory and Practice, Second Edition" by Mike Bailey and Steve Cunningham
// Credits to Alan Zucconi: https://www.alanzucconi.com/2017/07/15/the-nature-of-light/
// Play with values and textures in order to get different results:)

Shader "Custom/Interference
Shader" {
    Properties {
        _ColorMult("Luminocity", Range(-1,2)) = 1.1
        _Color ("Color", Color) = (1,1,1,0.37)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 1
        _Metallic ("Metallic", Range(0,1)) = 1
        _Reflection("Reflection Intencity", Range(0.1,10)) = 3
        _Saturation("Reflection Saturation", Range(0.6,2.2)) = 1.79
        _RimEffect("Rim effect", Range(-1,1)) = -0.5
        _Fresnel("Fresnel Coefficient", Range(-1,10)) = 6.2
        _Refraction("Refration Coefficient", float) = 0.31
        _Reflectance("Reflectance", Range(-1,1)) = 1.0

        _Distance("Height-distance", Range(0, 10000)) = 1020
		_Numbers("Number of multipliers", Range(0, 128)) = 8
		_RefractionIndex("Index of refraction", Range (0, 10)) = 1.4
		_ExponentMult("Exponent multiplier", Range (0,10)) = 0.5
		_NoiseMag("Noise Magnifier", Range(2, 16)) = 2
    }
    SubShader {
        Tags {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType"="Transparent"
        }
        LOD 200
 
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        // take out "fullforwardshadows" and add "alpha:fade"
        #pragma surface surf Diffraction fullforwardshadows alpha:fade
 
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
 
		#include "UnityPBSLighting.cginc"


		sampler2D _MainTex;
		sampler2D _NoiseTex;

        float _ColorMult;
        float _Reflection;
        float _RimEffect;
        float _Saturation;
        float _Fresnel;
        float _Refraction;
        float _Reflectance;

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        samplerCUBE _Cube;

        float _Distance;
       	float _RefractionIndex;
		float _ExponentMult;
		float _NoiseMag;
		int _Numbers;
 
        float3 worldTangent;
		float3 noiseVec;
		float noiseRad;

        struct Input {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };
 
 
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_CBUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_CBUFFER_END

        // Wavelength-spectrum approximation to RGB
 		fixed3 bump3y(fixed3 x, fixed3 yoffset)
		{
			float3 y = 1 - x * x;
			y = saturate(y - yoffset);
			return y;
		}
		fixed3 spectral_zucconi6(float w)
		{
			// w: [400, 700]
			// x: [0,   1]
			fixed x = saturate((w - 400.0) / 300.0);

			const float3 c1 = float3(3.54585104, 2.93225262, 2.41593945);
			const float3 x1 = float3(0.69549072, 0.49228336, 0.27699880);
			const float3 y1 = float3(0.02312639, 0.15225084, 0.52607955);

			const float3 c2 = float3(3.90307140, 3.21182957, 3.96587128);
			const float3 x2 = float3(0.11748627, 0.86755042, 0.66077860);
			const float3 y2 = float3(0.84897130, 0.88445281, 0.73949448);

			return	bump3y(c1 * (x - x1), y1) +	bump3y(c2 * (x - x2), y2);
		}


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb * _ColorMult;

            o.Metallic = _Metallic * _Saturation;
            o.Smoothness = _Glossiness;
 
            // Add transparency
            float border = 1 - (abs(dot(IN.viewDir,IN.worldNormal)));
            float alpha = (border * (1 - _RimEffect) + _RimEffect);
            o.Alpha = ((c.a * _Reflection)  * alpha);
            o.Emission = c.a;

            // Getting a tangent vector. Written by Alan Zucconi. Can be used for disk diffraction.
            fixed2 uv = IN.uv_MainTex * 2 - 1;
			fixed2 uv_orthogonal = normalize(uv);
			fixed3 uv_tangent = fixed3(-uv_orthogonal.y, 0, uv_orthogonal.x);
			worldTangent = normalize(mul(unity_ObjectToWorld, float4(uv_tangent, 0)));

			// Noise texture
            noiseVec = tex2D(_NoiseTex, IN.uv_MainTex);
			noiseRad = distance(IN.uv_MainTex.rg, float2(0., 0.)) + _NoiseMag*(noiseVec.r-0.5);
        }

        fixed4 LightingDiffraction(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			fixed4 output = LightingStandard(s, viewDir, gi);

			float3 lightVec = gi.light.dir;
			float3 viewVec = viewDir;
			float3 tanVec = worldTangent;


			float d = _Distance*exp(-_ExponentMult*noiseRad*noiseRad);

			// Diffraction grating
			float cosLightAngle = dot(lightVec, tanVec);
			float cosViewAngle = dot(viewVec, tanVec);
			float u = abs(cosLightAngle - cosViewAngle);
			if (u == 0) return output;

			// Refractive Index
			float eta = _RefractionIndex;

			fixed3 color = 0;

			for (int n = 1; n <= _Numbers; n++)
			{
				float wavelength = 2*u*d*eta/(n+0.5f);
				color += spectral_zucconi6(wavelength);
			}

			color = saturate(color);
			output.rgb += color;
			return output;
		
		}

		void LightingDiffraction_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}
        ENDCG
    }
  FallBack "Diffuse"
}