Shader "Custom/Shader_worldPos"
{
    Properties
    {
        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (0,0,0,0)

    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert
        struct Input
        {
            float3 worldPos;
            float3 viewDir;
        };

        fixed4 _Color1;
        fixed4 _Color2;

        void surf (Input IN, inout SurfaceOutput o)
        {
             half rim = 1-saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            o.Emission = IN.worldPos.y > -0.3? _Color1*rim : _Color2*rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
