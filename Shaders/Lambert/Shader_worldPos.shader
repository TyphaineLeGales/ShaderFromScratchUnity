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
        };

        fixed4 _Color1;
        fixed4 _Color2;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = float3(0,0,0);
            o.Emission = IN.worldPos.y > -0.5? _Color1 : _Color2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
