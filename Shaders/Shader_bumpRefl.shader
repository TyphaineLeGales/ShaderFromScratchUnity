Shader "Custom/Shader_BumpedRefl"
{
    Properties
    {
        _MainTex ("Diffuse Map", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
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
            //INTERNAL_DATA : allows you to modify normals in the surf() while using the world reflection normal by using a different data set by this keyzord
            float3 worldRefl; INTERNAL_DATA
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        samplerCUBE _EnvTex;
        fixed4 _Color;
        half _NormalStrength;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex)*_Color;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Normal *= float3(_NormalStrength, _NormalStrength, 1);
            // WorldReflectionVector = internal function that calculates a vector from the input structure data. Here it's been given the normals
            o.Emission = texCUBE(_EnvTex, WorldReflectionVector(IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
