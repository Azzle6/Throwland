// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_UI_Speedlines"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        [Header(Panning Texture)]_PanningTex("PanningTex", 2D) = "white" {}
        [Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
        _PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
        [Header(PolarUV)][Toggle]_Polar_InvertUV("Polar_InvertUV", Float) = 0
        _Polar_Distort_U("Polar_Distort_U", Float) = 0
        _Vector0("Polar_Center", Vector) = (0.5,0.5,0,0)
        [Header(Alpha Sharp)]_AlphaThreshold("AlphaThreshold", Float) = 0
        _AlphaSmoothness("AlphaSmoothness", Float) = 1
        [Toggle]_AlphaSharp_OneMinus("AlphaSharp_OneMinus", Float) = 0
        [Header(AlphaLerp)]_AlphaLerp_TexInfluence("AlphaLerp_TexInfluence", Range( 0 , 1)) = 0.2
        [Header(Circle Mask)]_CircleMask_Radius("CircleMask_Radius", Float) = 0.3
        _CircleMask_Smoothness("CircleMask_Smoothness", Float) = 0.2
        [Toggle]_CircleMask_Invert("CircleMask_Invert", Float) = 0
        _CircleMask_Noise("CircleMask_Noise", Float) = 0.5
        _CircleMask_Center("CircleMask_Center", Vector) = (0.5,0.5,0,0)

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #include "UnityShaderVariables.cginc"
            #define ASE_NEEDS_FRAG_COLOR


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float _AlphaThreshold;
            uniform float _AlphaSmoothness;
            uniform float _CircleMask_Radius;
            uniform float _CircleMask_Smoothness;
            uniform float4 _CircleMask_Center;
            uniform float _CircleMask_Invert;
            uniform float _CircleMask_Noise;
            uniform sampler2D _PanningTex;
            uniform float _PanningTex_ManualOffset;
            uniform float _PanningTex_InvertUV;
            SamplerState sampler_PanningTex;
            uniform float4 _PanningTex_ST;
            uniform float4 _Vector0;
            uniform float _Polar_Distort_U;
            uniform float _Polar_InvertUV;
            uniform float _AlphaLerp_TexInfluence;
            uniform float _AlphaSharp_OneMinus;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float temp_output_7_0_g39 = ( _AlphaThreshold + 0.0 );
                float temp_output_3_0_g41 = _CircleMask_Radius;
                float2 texCoord2_g41 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float smoothstepResult10_g41 = smoothstep( temp_output_3_0_g41 , ( temp_output_3_0_g41 + _CircleMask_Smoothness ) , distance( float4( texCoord2_g41, 0.0 , 0.0 ) , _CircleMask_Center ));
                float lerpResult15_g41 = lerp( ( 1.0 - smoothstepResult10_g41 ) , smoothstepResult10_g41 , _CircleMask_Invert);
                float4 appendResult43_g1 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g1 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g1 = lerp( appendResult43_g1 , appendResult42_g1 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g34 = _PanningTex_ST.zw;
                float2 break3_g34 = temp_output_1_0_g34;
                float4 appendResult5_g34 = (float4(break3_g34.y , break3_g34.x , 0.0 , 0.0));
                float4 lerpResult2_g34 = lerp( float4( temp_output_1_0_g34, 0.0 , 0.0 ) , appendResult5_g34 , _PanningTex_InvertUV);
                float2 texCoord2_g36 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 temp_output_1_0_g36 = float4( texCoord2_g36, 0.0 , 0.0 );
                float4 temp_output_18_0_g36 = _Vector0;
                float temp_output_3_0_g36 = distance( temp_output_1_0_g36 , temp_output_18_0_g36 );
                float4 break6_g36 = ( temp_output_1_0_g36 + ( temp_output_18_0_g36 * float4( -1,-1,0,0 ) ) );
                float temp_output_28_0_g36 = ( ( ( ( atan2( break6_g36.x , break6_g36.y ) / UNITY_PI ) + 1.0 ) / 2.0 ) + ( temp_output_3_0_g36 * _Polar_Distort_U ) );
                float4 appendResult4_g36 = (float4(temp_output_3_0_g36 , temp_output_28_0_g36 , 0.0 , 0.0));
                float4 appendResult24_g36 = (float4(temp_output_28_0_g36 , temp_output_3_0_g36 , 0.0 , 0.0));
                float4 lerpResult25_g36 = lerp( appendResult4_g36 , appendResult24_g36 , _Polar_InvertUV);
                float2 temp_output_1_0_g35 = lerpResult25_g36.xy;
                float2 break3_g35 = temp_output_1_0_g35;
                float4 appendResult5_g35 = (float4(break3_g35.y , break3_g35.x , 0.0 , 0.0));
                float4 lerpResult2_g35 = lerp( float4( temp_output_1_0_g35, 0.0 , 0.0 ) , appendResult5_g35 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g33 = ( _PanningTex_ST.xy * float2( 1,1 ) );
                float2 break3_g33 = temp_output_1_0_g33;
                float4 appendResult5_g33 = (float4(break3_g33.y , break3_g33.x , 0.0 , 0.0));
                float4 lerpResult2_g33 = lerp( float4( temp_output_1_0_g33, 0.0 , 0.0 ) , appendResult5_g33 , _PanningTex_InvertUV);
                float2 panner1_g32 = ( _Time.y * (lerpResult2_g34).xy + ( (lerpResult2_g35).xy * (lerpResult2_g33).xy ));
                float2 texCoord9_g1 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 tex2DNode2_g1 = tex2D( _PanningTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g1 ).xy + panner1_g32 ), ddx( texCoord9_g1 ), ddy( texCoord9_g1 ) );
                float lerpResult1_g40 = lerp( ( lerpResult15_g41 - ( 0.0 * _CircleMask_Noise ) ) , tex2DNode2_g1.r , _AlphaLerp_TexInfluence);
                float temp_output_1_0_g39 = lerpResult1_g40;
                float lerpResult9_g39 = lerp( temp_output_1_0_g39 , ( 1.0 - temp_output_1_0_g39 ) , _AlphaSharp_OneMinus);
                float smoothstepResult2_g39 = smoothstep( temp_output_7_0_g39 , ( temp_output_7_0_g39 + _AlphaSmoothness ) , lerpResult9_g39);
                float4 appendResult9 = (float4(IN.color.r , IN.color.g , IN.color.b , ( IN.color.a * smoothstepResult2_g39 )));
                

                half4 color = appendResult9;

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.FunctionNode;4;-776,7.5;Inherit;False;SF_PolarUV;10;;36;bc5d9a6ecd79c3041a2b8852c4a2b9cf;0;2;1;FLOAT4;0,0,0,0;False;18;FLOAT4;0,0,0,0;False;3;FLOAT4;0;FLOAT4;15;FLOAT4;16
Node;AmplifyShaderEditor.FunctionNode;7;-372,240.5;Inherit;False;SF_CircleMask;20;;41;fe677789fb780d34b8887718ca845428;0;5;17;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;6;FLOAT4;0,0,0,0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;3;-329,-4.5;Inherit;False;SF_PanningTexture;0;;1;b045855c7f4c7344eb8723194efc0969;0;7;46;FLOAT;0;False;3;SAMPLER2D;;False;5;FLOAT2;0,0;False;8;FLOAT2;0,0;False;6;FLOAT2;0,0;False;14;FLOAT2;1,1;False;7;FLOAT2;0,0;False;5;COLOR;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51
Node;AmplifyShaderEditor.FunctionNode;6;36,50.5;Inherit;False;SF_AlphaLerp;18;;40;c2553cd63225274418f59d0e7f8b8bf3;0;2;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;220,-15.5;Inherit;False;SF_AlphaSharp;14;;39;1a46ba76a207bfe4e97ac05d03cb8401;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;297,-233.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;491,-64.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;11;-567.3149,-96.24881;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;9;623,-166.5;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;745,-36;Float;False;True;-1;2;ASEMaterialInspector;0;3;S_UI_Speedlines;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;5;4;0
WireConnection;6;2;7;0
WireConnection;6;3;3;48
WireConnection;5;1;6;0
WireConnection;10;0;8;4
WireConnection;10;1;5;0
WireConnection;9;0;8;1
WireConnection;9;1;8;2
WireConnection;9;2;8;3
WireConnection;9;3;10;0
WireConnection;1;0;9;0
ASEEND*/
//CHKSM=D5375C4B89EF057844E8D8494DD4FB91B5F3C62A