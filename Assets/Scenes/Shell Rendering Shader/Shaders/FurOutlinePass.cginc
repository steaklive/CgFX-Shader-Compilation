// Rim outline pass - NOT USED

#pragma target 3.0
fixed4 _ColorOutline;
float _Rim;
sampler2D _MainTex;
sampler2D _BumpMap;

#define RIM (1.0 - _Rim)

uniform float _FurLength;
uniform float _Cutoff;
uniform float _CutoffEnd;
uniform float _EdgeFade;
uniform float _DotProduct;

uniform fixed3 _Gravity;
uniform fixed _GravityStrength;

void vert(inout appdata_full v)
{
	fixed3 direction = lerp(v.normal, _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength), 1);
	v.vertex.xyz += direction * _FurLength * 1 * v.color.a;

}

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 viewDir;
	float3 worldNormal;
};

void surf(Input IN, inout SurfaceOutputStandard o) {
	fixed4 c = /*tex2D(_MainTex, IN.uv_MainTex) */ _ColorOutline;

	float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	o.Albedo = c.rgb;


	float diff = 1.0 - dot(IN.worldNormal, IN.viewDir);

	// Cut off the diff to the rim size using the RIM value.
	diff = step(RIM, diff) * diff;

	// Smooth value
	float value = step(RIM, diff) * (diff - RIM) / RIM;

	o.Alpha = value * _ColorOutline.rgb - _EdgeFade;
}