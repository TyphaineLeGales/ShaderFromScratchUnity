﻿Shader "Custom/Shader_PackedPractice"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

    }
    SubShader
    {

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo.b = _Color.b;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
