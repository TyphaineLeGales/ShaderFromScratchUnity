Shader "Custom/Shader_BumpedRefl"
{
    Properties
    {
        _EnvTex("EnvironmentMap", CUBE) = "white" {}

    }
    SubShader
    {

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_EnvTex;
            float3 worldRefl;
        };


        samplerCUBE _EnvTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = texCUBE(_EnvTex, IN.worldRefl).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
