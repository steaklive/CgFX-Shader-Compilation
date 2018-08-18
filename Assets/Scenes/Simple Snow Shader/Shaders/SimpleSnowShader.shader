// Simple snow shader

Shader "Custom/CustomSnowShader" {
	Properties {
		_MainColor("Main Color", Color) = (1.0,1.0,1.0,1.0)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Bump("Bump", 2D) = "bump"{}
		_SnowTexture("Snow Texture (RGB)", 2D) = "white"{}
		_SnowBump("Snow Bump", 2D) = "bump"{}
		_Snow("Snow level", Range (1,-1)) = 1
		_SnowColor("Snow color", Color) = (1.0,1.0,1.0,1.0)
		_SnowDirection("Snow direction", Vector) = (0,1,0)
		_SnowDepth("Snow depth", Range(0,1)) = 0
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		sampler2D _SnowTex;
		sampler2D _SnowBump;

		float _Snow;
		float4 _SnowColor;
		float4 _MainColor;
		float4 _SnowDirection;
		float _SnowDepth;
		half _Glossiness;
		half _Metallic;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float2 uv_SnowTex;
			float2 uv_SnowBump;
			float3 worldNormal;
			INTERNAL_DATA
		};


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void vert(inout appdata_full v)
		{
			float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection );
			if (dot(v.normal, sn.xyz) >= _Snow)
			{
				v.vertex.xyz +=(sn.xyz+v.normal)*_SnowDepth*_Snow;
			}
		}
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			half4 mainDiffuse = tex2D (_MainTex, IN.uv_MainTex);
			half4 snowDiffuse = tex2D (_SnowTex, IN.uv_SnowTex);

			half3 snowNormal = half3(0,0,0);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

			if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
			{
				o.Albedo = (snowDiffuse.rgb+0.5*mainDiffuse.rgb)*0.75;
				snowNormal = UnpackNormal(tex2D(_SnowBump, IN.uv_SnowBump));
				o.Normal = normalize(snowNormal + o.Normal);
				//o.Albedo = snowDiffuse.rgb;
			}
			else
			{
				o.Albedo = _MainColor.rgb;
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
			}

			o.Alpha = mainDiffuse.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
