Shader "Custom/Shader_RayMarchedClouds"
{
    Properties
    {
        _Scale("Scale", Range(0.1, 10.0)) = 2.0
        _StepScale("Step Scale", Range(0.1, 100.0)) = 1
        _Steps("Steps", Range(1, 200)) = 60
        _MinHeight("Min Height", Range(0.0, 5.0)) = 0
        _MaxHeight("Max Height", Range(6.0, 10.0)) = 10
        _FadeDist("Fade Distance", Range(0.0, 10.0)) = 0.5
        _sunDir("Sun Direction", Vector) = (1, 0, 0, 0)

    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off 
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 view : TEXCOORD0;
                float projPos : TEXCOORD1;
                float3 wpos : TEXCOORD2;
            };

            float _Scale;
            float _StepScale;
            float _Steps;
            float _MinHeight;
            float _MaxHeight;
            float _FadeDist;
            float4 _sunDir;
            sampler2D _CameraDepthTexture;


            v2f vert (appdata v)
            {
                v2f o;
                o.wpos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = o.wpos;
                o.projPos = ComputeScreenPos(o.pos);


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                return fixed4(1, 1, 1, 1);
            }
            ENDCG
        }
    }
}
