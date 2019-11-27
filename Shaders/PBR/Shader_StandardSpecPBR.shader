Shader "Custom/Shader_StandardSpecPBR"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Metallic", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _EnvTex("WorldMap", CUBE) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        samplerCUBE _EnvTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = _Color.rgb;
            // Metallic and smoothness come from slider variables
            o.Specular = _Metallic;
            o.Smoothness = tex2D (_MainTex, IN.uv_MainTex) * _Color.r*_Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
