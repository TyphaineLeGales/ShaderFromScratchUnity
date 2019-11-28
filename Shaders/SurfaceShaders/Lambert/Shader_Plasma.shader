Shader "Custom/Shader_Plasma"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Speed("Speed",Range(0.1, 100)) = 10
        _Scale1("Scale1",Range(0.1, 10)) = 2
        _Scale2("Scale2",Range(0.1, 10)) = 2
        _Scale3("Scale3",Range(0.1, 10)) = 2
        _Scale4("Scale4",Range(0.1, 10)) = 2

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;
        float _Speed;
        float _Scale1;
        float _Scale2;
        float _Scale3;
        float _Scale4;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            const float PI = 3.14159265;
            float t = _Time.x *_Speed;

            //vertical
            fixed4 c = sin(IN.worldPos.x * _Scale1 + t);

             //horizontal
            c += sin(IN.worldPos.z * _Scale2 + t);

            //diagonal 
            c += sin(_Scale3*(IN.worldPos.x*sin(t/2.0)+
            IN.worldPos.z*cos(t/3))+t);

            //circular 
            float c1 = pow(IN.worldPos.x + 0.5 * sin(t/5), 2);
            float c2 = pow(IN.worldPos.z + 0.5 * cos(t/3), 2);
            c += sin(sqrt(_Scale4*(c1+c2)+1+t));

            o.Albedo.r = sin(c/4.0*PI);
            o.Albedo.g = sin(c/4.0*PI + 0.5);
            o.Albedo.b = sin(c/4.0*PI + 1);
            o.Albedo *= _Color;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
