// Displacement texture generation shader (brush-like method)

Shader "Unlit/GenerateDispTextureShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Coordinate("Coordinate", Vector) = (0,0,0,0)
		_Color("Color", Color) = (1,0,0,0)
		_Radius("Radius of deformation", Range(0, 300)) = 100
		_DeformationFactor("Deformation depth", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Coordinate;
			fixed4 _Color;

			half _Radius;
			half _DeformationFactor;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				float brushValue = pow(saturate(1-distance(i.uv, _Coordinate.xy)), _Radius);
				fixed4 brushColor = _Color * (brushValue * _DeformationFactor);


				return saturate(col + brushColor);
			}
			ENDCG
		}
	}
}

