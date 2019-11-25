Shader "Custom/Shader_"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Diffuse Map", 2D) = "white" {}
        _NormalTex ("Normal Map", 2D) = "white" {}
       
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert


        sampler2D _MainTex;
        sampler2D _NormalTex;
        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
