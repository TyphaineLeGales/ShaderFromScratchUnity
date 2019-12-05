Shader "Custom/Shader_SphericalFog"
{
    Properties
    {
       _FogCentre("Fog Centre/Radius", Vector) = (0,0,0.5)
       _FogColor("Fog Color", Color) = (1, 1, 1, 1)
       _InnerRatio("Inner Ratio", Range(0.0, 0.9)) = 0.5
       _Density("Density", Range(0.0, 1.0)) = 0.5
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

            float CalculateFogIntensity(
                float3 sphereCenter,
                float sphereRadius,
                float density,
                float3 cameraPosition,
                float3 viewDirection,
                float maxDistance)
                {
                    // calculate ray-sphere intersection to find collision spots and march from them
                    float3 localCam = cameraPosition - sphereCentre;
                    float a = dot(viewDirection, viewDirection); //dot product of a vector against itself = square of that vector
                    float b = 2* dot(viewDirection, localCam);
                    float c = dot(localCam, localCam) - sphereRadius * sphereRadius;

                    //calculate discriminant to exit if the ray misses the sphere volume => quadratic equation
                    float d = b*b - 4 * a * c;

                    if(d <= 0.0f)
                        return 0;
                    
                    float DSqrt = sqrt(d);
                    float dist = max((-b - DSqrt)/2*a, 0); // make sure distance is positive
                    float dist2 = max((-b + DSqrt)/2*a, 0);

                    float backDepth = min(maxDistance, dist2);
                    float sampl = dist;
                    float step_distance = (backDepth - dist)/10;
                    float step_contribution = density; //how much more fog each step that we take into the depth of the sphere is going to add

                    float centerValue = 1/(1 - innerRatio);

                    float clarity = 1;
                    for (int seg = 0; seg < 10; seg++)
                    {
                        float3 position = localCam + viewDirction * sampl;
                        float val = saturate(centerValue * (1 - length(position)/sphereRadius)); //saturate => clamp value between 0 and 1
                        float fog_amount = saturate(val * step_contribution);
                        clarity *= (1-fog_amount);
                        sampl += step_distance;
                    }

                    return 1 - clarity;

                }
            )


            struct v2f
            {
                float2 view : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD1;
            };

            float4 _FogCentre;
            fixed4 _FogColor;
            float _InnerRatio;
            float _Density;
            sampler2D _CameraDepthTexture;

            v2f vert (appdata_base v) //Unity's inner appdata
            {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = wPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos); //projection of position in clipspace onto screenSpace

                //if camera is inside of object 

                float inFrontOf = (o.pos.z/o.pos.w) > 0;
                o.pos.z *= inFrontOf; // relation w/z works no matter what plateform (differences openGL Metal etc...)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = half4(1, 1, 1, 1);
                return col;
            }
            ENDCG
        }
    }
}
