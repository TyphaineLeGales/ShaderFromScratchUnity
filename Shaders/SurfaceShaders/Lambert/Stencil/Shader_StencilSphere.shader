Shader "Custom/Shader_StencilSphere"
{
    Properties
    {
        _Color ("Color", Color) = (1,0,0,1)

    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        Cull off
        Stencil {
            Ref 1
            Comp notequal
            Pass keep
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
