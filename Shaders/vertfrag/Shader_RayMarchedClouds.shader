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

            float random(float3 value, float3 dotDir)
            {
                float3 smallV = sin(value);
                float random = dot(smallV, dotDir);
                random = frac(sin(random)* 123574.43212); 
                return random;
            }

            float3 random3d(float3 value) // run random 3 times 
            {
                return float3 ( random(value, float3(12.898, 68.54, 37.7298)),
                                random(value, float3(39.496, 26.54, 86.7298)),
                                random(value, float3(74.898, 12.54, 8.7298)));
            }

            float noise3d(float3 value)
            {
                value *= _Scale;
                float3 interp = frac(value);
                interp = smoothstep(0.0, 1.0, interp);

                //generate 8 sets of coordinates : 2x interpolate between them same for 2y and 2z
                float3 ZValues[2];
                for(int z = 0; z <= 1; z++)
                {
                    float3 YValues[2];
                    for(int y = 0; y <= 1; y++)
                    {
                        float3 XValues[2];
                        for(int x = 0; x <= 1; x++)
                        {
                            float3 cell = floor(value) + float3(x, y, z);
                            XValues[x] = random3d(cell);
                        }
                        YValues[y] = lerp(XValues[0], XValues[1], interp.x);
                    }
                    ZValues[z] = lerp(YValues[0], YValues[1], interp.y);
                }
                
                //float noise = lerp(ZValues[0], ZValues[1], interp.z);
                //push values appart
                float noise = -1.0 + 2.0 * lerp(ZValues[0], ZValues[1], interp.z);

                return noise;
            }

            fixed4 integrate(fixed4 sum, float diffuse, float density, fixed4 bgcol, float t)
            {
                fixed3 lighting = fixed3(0.75, 0.68, 0.7) * 1.3 + 0.5 * fixed3(0.7, 0.5, 0.3) * diffuse;
                fixed3 colrgb = lerp(fixed3(1.0, 0.95, 0.8), fixed3(0.65, 0.65, 0.65), density);
                fixed4 col = fixed4(colrgb.r, colrgb.g, colrgb.b, density);
                col.rgb *= lighting;
                col.rgb = lerp(col.rgb, bgcol, 1.0 - exp(-0.003*t*t)); //falloff value to mimic natural fog
                col.a *= 0.5;
                col.rgb *= col.a;
                return sum + col*(1.0 - sum.a);
            }

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
                        float diffuse = clamp((density - noiseMap(pos + 0.3 * _sunDir)) / 0.6, 0.0, 1.0);\
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
                //inplement FBM
                f = 0.5 * noise3d(q);
                q = q*2;
                f += 0.25 * noise3d(q);
                q = q*3.5;
                f += 0.15 * noise3d(q);

                //return f if not using NOISERPOC;
                return NOISEPROC(f, p);
            }

            float map2(float3 q) 
            { 
                float3 p = q;
                float f;
                f = 0.8 * noise3d(q);
                q = q*1.5;
                f += 0.4 * noise3d(q);
                q = q*3.5;
                f += 0.2 * noise3d(q);
                return NOISEPROC(f, p);
            }

            fixed4 raymarch(float3 cameraPos, float3 viewDir, fixed4 bgcol, float depth)
            {
               fixed4 col = fixed4(0,0,0,0);
               float  ct = 0; // keep track of number of steps and accumulate 

               MARCH(_Steps, map1, cameraPos, viewDir, bgcol, col, depth, ct); //mapping function to perform noise value calculation
               MARCH(_Steps, map2, cameraPos, viewDir, bgcol, col, depth, ct);
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
