Shader "Custom/Shader_01"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Emission("EmissionColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        
        CGPROGRAM
        // Compile a surface shader + name of the shader function + lighting model
        #pragma surface surf Lambert

       
       //Input Data from the model's mesh (vertices, normals, uvs etc...)
        struct Input
        {
            float2 uv_MainTex;
        };

        // properties you want available to your shader function
        fixed4 _Color;
        fixed4 _Emission;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = _Emission.rgb;
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
