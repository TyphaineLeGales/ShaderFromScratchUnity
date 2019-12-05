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

             //using a hash define => makes it easy to pass through references of anything because you don't need to declare the type of you argument
            #define MARCH(steps, noiseMap, cameraPos, viewDir, bgcol, sum, depth, t) { \
                for (int i = 0; i < steps  + 1; i++) \
                { \
                    if(t > depth) \
                        break; \
                    float3 pos = cameraPos + t * viewDir; \
                    if (pos.y < _MinHeight || pos.y > _MaxHeight || sum.a > 0.99) \
                    {\
                        t += max(0.1, 0.02*t); \
                        continue; \
                    }\
                    \
                    float density = noiseMap(pos); \
                    if (density > 0.01) \
                    { \
                        float diffuse = clamp((density - noiseMap(pos + 0.3 * _SunDir)) / 0.6, 0.0, 1.0);\
                        sum = integrate(sum, diffuse, density, bgcol, t); \
                    } \
                    t += max(0.1, 0.02 * t); \
                } \
            } 

            #define NOISEPROC(N, P) 1.75 * N * saturate((_MaxHeight - P.y)/_FadeDist) //spread the range of values so that we get quite transparent and quite opaque values

            float map1(float3 q) //q being the position at which we are calculatin the noise
            { 
                float3 p = q;
                float f; //accumulation of different noise values
                f = 0.5 * noise3d(q);
                //return f if not using NOISERPOC;
                return NOISEPROC(f, p);
            }

            fixed4 raymarch(float3 cameraPos, float3 viewDir, fixed4 bgcol, float depth)
            {
               fixed4 col = fixed4(0,0,0,0);
               float  ct = 0; // keep track of number of steps and accumulate 

               MARCH(_Steps, map1, cameraPos, viewDir, bgcol, col, depth, ct); //mapping function to perform noise value calculation
                return clamp(col, 0.0, 1.0);
            
            }

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
                float depth = 1;
                depth *= length(i.view);//get legnth from vector between the camera and pixel location or can use _CameraDepthTexture
                fixed4 col = fixed4(1, 1, 1, 0);
                fixed4 clouds = raymarch(_WorldSpaceCameraPos, normalize(i.view) * _StepScale, col, depth);
                fixed3 mixedCol = col* (1.0 - clouds.a) + clouds.rgb;
                return fixed4(mixedCol, clouds.a);
            }
            ENDCG
        }
    }
}
