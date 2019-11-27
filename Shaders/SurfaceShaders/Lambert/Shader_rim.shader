Shader "Custom/Shader_rim"
{
    Properties
    {
        _RimColor ("RimColor", Color) = (0,0.5,0.5,0)
        _RimPower("RimPower", Range(0.5, 8)) = 3

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

        fixed4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1- saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            o.Emission = _RimColor.rgb* pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
