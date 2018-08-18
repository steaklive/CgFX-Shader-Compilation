// Rim + Depth shader

Shader "Custom/SeeThroughWithRim" {

	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_SpecularMap("Speular Map", 2D) = "black"{}
		_Shininess("Shininess", Range(0.03, 1)) = 0.078125


		_RimCol("Rim Colour" , Color) = (1,0,0,1)
		_RimPow("Rim Power", Float) = 1.0
	
	}
	SubShader{

		Pass{
			Name "Outline Pass"
			Tags{ "RenderType" = "transparent" "Queue" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest Greater               //check  for the pixel being greater or closer to the camera,
			Cull Back
			ZWrite Off
			LOD 200

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _RimCol;
			float _RimPow;

			float4 _MainTex_ST;

			v2f vert(appdata_tan v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = normalize(v.normal);
				o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				//Rim Outline
				half Rim = 1 - saturate(dot(normalize(i.viewDir), i.normal));
				half4 RimOut = _RimCol * pow(Rim, _RimPow);
				return RimOut;
			}
			ENDCG
		}

		CGPROGRAM

		#pragma surface surf StandardSpecular
		#include "UnityCG.cginc"

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float2 uv_SpecularMap;

		};


		sampler2D _MainTex;
		sampler2D _NormalMap;
		sampler2D _SpecularMap;

		half _Shininess;


		void surf(Input IN, inout SurfaceOutputStandardSpecular o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			half4 s = tex2D(_SpecularMap, IN.uv_SpecularMap);

			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));

			o.Specular = s.rgb*_Shininess;

		}

		ENDCG

	}

FallBack "VertexLit"
}