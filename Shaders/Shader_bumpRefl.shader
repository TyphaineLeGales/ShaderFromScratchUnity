Shader "Custom/Shader_BumpedRefl"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _EnvTex("EnvironmentMap", CUBE) = "white" {}
        _NormalMap("NormalMap", 2D) = "" {}
        _NormalStrength("NormalStrength", Range(0,5)) = 1

    }
    SubShader
    {

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 worldRefl;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        samplerCUBE _EnvTex;
        fixed4 _Color;
        half _NormalStrength;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex);
            // o.Emission = texCUBE(_EnvTex, IN.worldRefl);
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Normal *= float3(_NormalStrength, _NormalStrength, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
