Shader "Unlit/Shader_vertFrag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScaleUVX("Scale uv X", Range(1,10)) = 1
        _ScaleUVY("Scale uv Y", Range(1,10)) = 1
    }
    SubShader
    {   GrabPass {}
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _GrabTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ScaleUVX;
            float _ScaleUVY;

            v2f vert (appdata v)
            {
                v2f o;
                //UnityObjectToClipPos equivqlent to projectionMatrix * modelViewMatrix * vec4(position, 1.0) in glsl;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x = sin(o.uv.x *_ScaleUVX);
                o.uv.y = sin(o.uv.y *_ScaleUVY);
                return o;
            }
            // the o return in the vert is called i when coming into the frag => Unity background Pipeline from output to input
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_GrabTexture, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
