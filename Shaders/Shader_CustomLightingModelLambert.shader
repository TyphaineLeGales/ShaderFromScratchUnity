Shader "Custom/Shader_CustomLightingModel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {


        CGPROGRAM
       
        #pragma surface surf CustomBasic

        //atten = attenuation, for light it corresponds to its intensity or the loss of it there is when travelling through air/water etc ...
        half4 LightingCustomBasic (SurfaceOutput s, half3 lightDir, half atten) {
            half NdotL = dot (s.Normal, lightDir);
            half4 c;
            //the output color c results of the surface albedo * the light color * (the brigthness (dot product) of the light * its attenuation)
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }


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
