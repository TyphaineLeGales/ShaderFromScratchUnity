Shader "Custom/Shader_TextureBlending"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DecalTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _DecalTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
      

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            //fixed4 a = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 b = tex2D (_DecalTex, IN.uv_MainTex) * _Color;
            o.Albedo = _Color.rgb + b.rgb;
            //o.Albedo = b.r > 0.5 ? a.rgb : b.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
