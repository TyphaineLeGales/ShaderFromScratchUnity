Shader "Custom/Shader_Blending"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        // possible blend values : One, Zero, SrcColor, SrcAlpha, DstColor, DstAlpha, OneMinusSrcColor, OneMinusSrcAlpha, OneMinusDstColor, OneMinusDstAlpha
        Blend DstColor One  //with a black and white image => white parts are going to be replace with what's behind making them look transparent
        
        Pass {
            SetTexture [_MainTex] {combine texture}
        }
    }
    FallBack "Diffuse"
}
