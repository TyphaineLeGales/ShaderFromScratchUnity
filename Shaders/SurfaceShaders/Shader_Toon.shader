Shader "Custom/Shader_Toon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white"{}
    }
    SubShader
    {

        CGPROGRAM

        #pragma surface surf CustomToon

        float4 _Color;
        sampler2D _RampTex;

        float4 LightingCustomToon (SurfaceOutput s, fixed3 lightDir, fixed atten) {

            float diff = dot(lightDir, s.Normal);
            // h is used as uv value for the ramp tex (sampling will happen following the diagonal)
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }


        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {

            o.Albedo =  _Color.rgb;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
