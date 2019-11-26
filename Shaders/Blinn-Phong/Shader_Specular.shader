Shader "Custom/Shader_Specular"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecColor("Spec Color", Color) = (1, 1, 1, 1)
        _Spec("Specular", Range(0, 1)) = 0.5
        _Glossiness ("Glossiness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { 
            "Queue"="Geometry" 
            }

        CGPROGRAM
        
        #pragma surface surf BlinnPhong

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed _Glossiness;
        float4 _Color;
        half _Spec;
        // _SpecColor is defined natively 

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo =  _Color.rgb;
            o.Specular = _Spec;
            o.Gloss = _Glossiness;
            
           // o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
