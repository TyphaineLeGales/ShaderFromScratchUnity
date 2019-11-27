Shader "Custom/Shader_Hologram"
{
    Properties
    {
        _RimColor ("RimColor", Color) = (0,0.5,0.5,0)
        _RimPower("RimPower", Range(0.5, 8)) = 3

    }
    SubShader
    {
        Tags { "Queue" = "Transparent"}
        LOD 200

        // force the write of the depth buffer on first draw call so that you don't see the faces behind in the transparent object
        //ColorMask 0 => doesn't write any color pixel
        Pass {
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;

        };

        fixed4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1- saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            o.Emission = _RimColor.rgb* pow(rim, _RimPower);
            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
