Shader "Custom/Shader_Waves"
{
    Properties
    {
        _ColorTint ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Frequency ("Frequency", Range(0,5)) = 0.37
        _Amplitude ("Amplitude", Range(0,1)) = 0.5
        _Speed ("Speed", Range(0,100)) = 20

    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        fixed4 _ColorTint;
        float _Frequency;
        float _Speed;
        float _Amplitude;

        struct appdata {
            float4 vertex: POSITION;
            float3 normal : NORMAL;
            float4 texcoord: TEXCOORD0;
            float4 texcoord1: TEXCOORD1;
            float4 texcoord2: TEXCOORD2;
        };

        void vert (inout appdata v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float t = _Time * _Speed;
             float waveHeight = sin(t + v.vertex.x * _Frequency) * _Amplitude +
                        sin(t*2 + v.vertex.x * _Frequency*2) * _Amplitude;
             v.vertex.y = v.vertex.y + waveHeight;
          v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
          o.vertColor = waveHeight + 2;

        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
           float4 c = tex2D(_MainTex, IN.uv_MainTex);
          o.Albedo = c * IN.vertColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
