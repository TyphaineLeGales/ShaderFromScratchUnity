Shader "Custom/Shader_properties"
{
    Properties
    {
        _Color ("ExampleColor", Color) = (1,1,1,1)
        _Range("ExampleRange", Range(0,5)) = 1
        _Tex("ExampleTexture", 2D) = "White" {}
        _Cube("ExampleCube", CUBE) = "" {}
        _Float("ExampleFloat", Float) = 0.5
        _Vector("ExampleVector", Vector) = (0.5,1,1,1)

    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_Tex;
            float3 worldRefl;
        };

         //  declare variables for each of the properties
        sampler2D _Tex;  
        fixed4 _Color;
        half _Range;
        samplerCUBE _Cube;
        float4 _Vector;
        float _Float;


        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_Tex, IN.uv_Tex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
