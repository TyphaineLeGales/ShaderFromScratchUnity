Shader "Custom/Shader_TextureScrolling"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollX ("ScrollX", Range(-5, 5)) =1
        _ScrollY ("ScrollY", Range(-5, 5)) =1
        _Frequency ("Frequency", Range(0,5)) = 0.4
        _Amplitude ("Amplitude", Range(0,1)) = 0.228
        _Speed ("Speed", Range(0,100)) = 52.5

    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;
        float _ScrollX;
        float _ScrollY;
        float _Frequency;
        float _Speed;
        float _Amplitude;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        struct appdata {
            float4 vertex: POSITION;
            float3 normal : NORMAL;
            float4 texcoord: TEXCOORD0;
            float4 texcoord1: TEXCOORD1;
            float4 texcoord2: TEXCOORD2;
        };

        void vert(inout appdata v, out Input o) {
              UNITY_INITIALIZE_OUTPUT(Input,o);
            float t = _Time * _Speed; 
            float waveHeight = sin(t + v.vertex.z * _Frequency) * _Amplitude +
                        sin(t*2 + v.vertex.z * _Frequency*2) * _Amplitude;
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x , v.normal.y+ waveHeight, v.normal.z));
            o.vertColor = waveHeight + 2;


        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            _ScrollX *= _Time;

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY));
            //float2 uvOffset = 
            o.Albedo = c.rgb*IN.vertColor;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
