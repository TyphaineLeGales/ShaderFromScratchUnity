 Shader "Custom/Shader_dot2"
{
    Properties
    {
        _bVal("blue channel value", Range(0, 1)) = 1
        // _gVal("green channel value", Range(0, 1)) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert


        struct Input
        {
           float3 viewDir;
        };

        // float _gVal;
        float _bVal;


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
           half dotProduct = 1 - dot(IN.viewDir, o.Normal);
            o.Albedo = float3(smoothstep(0, 0.3, dotProduct), smoothstep(0, 0.6, dotProduct), smoothstep(0, 0.7, dotProduct));

        }
        ENDCG
    }
    FallBack "Diffuse"
}
