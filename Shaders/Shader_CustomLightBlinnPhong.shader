Shader "Custom/Shader_CustomLightBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {


        CGPROGRAM
       
        #pragma surface surf CustomBasicBlinn

        //atten = attenuation, for light it corresponds to its intensity or the loss of it there is when travelling through air/water etc ...
        half4 LightingCustomBasicBlinn (SurfaceOutput s, half3 lightDir, half viewDir, half atten) {
            //calculate specular
            half3 halfway = normalize(lightDir + viewDir);
            half diff = max(0, dot(s.Normal, lightDir));
            float nh = max(0, dot(s.Normal, halfway));
            //48 is the value Uniy uses
            float spec = pow (nh, 48.0);

            half4 c;
            //the output color c results of the surface albedo * the light color * (the brigthness (dot product) of the light * its attenuation)
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
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
