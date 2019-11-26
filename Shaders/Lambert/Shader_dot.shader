Shader "Custom/Shader_dot"
{
    Properties 
    {
        _gVal("Green channel value",Range(0,1)) = 0.545
        _bVal("Blue channel value", Range(0,1)) = 0.505
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert

        half _gVal;
        half _bVal;

        struct Input
        {
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
           half dotP = dot(IN.viewDir, o.Normal);
            o.Albedo = float3(dotP, _gVal, _bVal);

        }
        ENDCG
    }
    FallBack "Diffuse"
}
