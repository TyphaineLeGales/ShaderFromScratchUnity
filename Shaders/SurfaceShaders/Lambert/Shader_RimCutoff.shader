Shader "Custom/Shader_rim"
{
    Properties
    {
        _RingColor1 ("RingColor1", Color) = (1,0,0,0)
        _RingColor2 ("RingColor2", Color) = (1,1,0,0)
        _BaseColor ("BaseColor", Color) = (0,0,1,0)

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

        fixed4 _RingColor1;
        fixed4 _RingColor2;
        fixed4 _BaseColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1- saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            o.Emission = rim > 0.5 ?  _RingColor1: rim>0.3 ?  _RingColor2 :  _BaseColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
